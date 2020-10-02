module spi_amm #(
  parameter AMM_ADDR_WIDTH = 32
) (
  input                             main_reset       ,
  // Avalon-MM Master
  input                             main_clk         ,
  output logic [AMM_ADDR_WIDTH-1:0] amm_address      ,
  output logic [              31:0] amm_writedata    ,
  input        [              31:0] amm_readdata     ,
  output logic                      amm_write        ,
  output logic                      amm_read         ,
  input                             amm_readdatavalid,
  input                             amm_waitrequest  ,
  //SPI
  input                             MOSI             ,
  output                            MISO             ,
  input                             SCLK             ,
  input                             nSS
);

  localparam WRITE_OPERATION = 32'hAAAAAAAA;
  localparam READ_OPERATION  = 32'hBBBBBBBB;

  enum logic[7:0] {
    IDLE_ST,
    OP_ST,
    ADDR_ST,
    DATA_ST,
    WORK_ST,
    CRC_ST,
    RESPONSE_ST,
    RESPONSE_CRC_ST,
    RESET_ST
  } state;

  enum logic[5:0] {
    SUB_IDLE,
    SUB_WRITE,
    SUB_READ,
    SUB_WAIT,
    SUB_FINISH,
    SUB_RESET
  } sub_state;

  logic [31:0] shift_reg;
  logic [31:0] send_reg ;
  logic [ 5:0] rx_cnt   ;
  logic [ 5:0] tx_cnt   ;

  logic [31:0] word_send;
  logic        bit_send ;

  logic spi_bit_send  ;
  logic spi_word_ready;

  logic data_valid   ;
  logic data_valid_dl;
  logic rx_we        ;

  logic word_ready;

  logic        write_op;
  logic [31:0] addr_op ;
  logic [31:0] data_op ;
  logic [31:0] crc_op  ;

  logic MOSI_reg;
  logic SCLK_reg;
  logic nSS_reg ;

  always_ff @(posedge main_clk)
    begin
      MOSI_reg <= MOSI;
      SCLK_reg <= SCLK;
      nSS_reg <= nSS;
    end

  always_ff @(posedge SCLK_reg or posedge main_reset)
    begin
      if (main_reset)
        begin
          rx_cnt     <= '0;
          shift_reg  <= '0;
          data_valid <= '0;
        end
      else
        begin
          if(~nSS_reg)
            begin
              shift_reg <= {shift_reg[30:0], MOSI_reg};
              if (rx_cnt < 31)
                begin
                  rx_cnt     <= rx_cnt + 1'b1;
                  data_valid <= 1'b0;
                end
              else
                begin
                  rx_cnt     <= '0;
                  data_valid <= 1'b1;
                end
            end
          else
            begin
              shift_reg <= '0;
              rx_cnt    <= '0;
            end
        end
    end

    assign MISO = ( ~nSS_reg) ? ( spi_word_ready ) ? send_reg[31] : spi_bit_send : 1'b1;

    always_ff @(posedge SCLK_reg or posedge main_reset)
      begin
        if (main_reset)
          begin
            tx_cnt         <= 31;
            send_reg       <= '1;
            spi_bit_send   <= 1'b1;
            spi_word_ready <= 1'b0;
          end
        else
          begin
            if(~nSS_reg)
              begin
                if ( tx_cnt > 0 && spi_word_ready )
                  begin
                    send_reg <= {send_reg[30:0], 1'b1};
                    tx_cnt   <= tx_cnt - 1'b1;
                  end
                else
                  begin
                    tx_cnt   <= 31;
                    send_reg <= word_send;
                  end
              end
            else
              send_reg <= '1;
            spi_bit_send   <= bit_send;
            spi_word_ready <= word_ready;
          end
      end

    always_ff @(posedge main_clk or posedge main_reset)
      begin
        if(main_reset)
          begin
            data_valid_dl <= '0;
            rx_we         <= '0;
          end
        else
          begin
            data_valid_dl <= ~data_valid;
            rx_we         <= data_valid & data_valid_dl;
          end
      end

      always_ff @(posedge main_clk or posedge main_reset)
        begin
          if (main_reset)
            begin
              state         <= RESET_ST;
              write_op      <= 1'b0;
              addr_op       <= '0;
              data_op       <= '0;
              crc_op        <= '0;
              word_ready    <= '0;
              bit_send      <= 1'b1;
              sub_state     <= SUB_RESET;
              amm_address   <= '0;
              amm_writedata <= '0;
              amm_write     <= '0;
              amm_read      <= '0;
              word_send     <= '1;
            end
          else
            begin
              case( state )
                IDLE_ST :
                  begin
                    if( ~nSS_reg )
                      begin
                        state    <= OP_ST;
                        bit_send <= 1'b1;
                      end
                    write_op   <= 1'b0;
                    addr_op    <= '0;
                    data_op    <= '0;
                    crc_op     <= '0;
                    word_ready <= '0;
                  end
                OP_ST :
                  begin
                    if( rx_we )
                      begin
                        state    <= ADDR_ST;
                        write_op <= ( shift_reg == WRITE_OPERATION) ? 1'b1 : 1'b0 ;
                        `ifdef MODELSIM
                          $display("[SPI-AMM] Received operation:\t 0x%x(%0s)", shift_reg, (shift_reg == READ_OPERATION) ? "READ" : (shift_reg == WRITE_OPERATION) ? "WRITE" : "UNKNOWN");
                        `endif
                      end
                    bit_send <= 1'b1;
                  end
                ADDR_ST :
                  begin
                    if( rx_we )
                      begin
                        state   <= ( write_op ) ? DATA_ST : WORK_ST;
                        addr_op <= shift_reg;
                        `ifdef MODELSIM
                          $display("[SPI-AMM] Received address:\t 0x%x", shift_reg);
                        `endif
                      end
                    bit_send <= 1'b1;
                  end
                DATA_ST :
                  begin
                    if( rx_we )
                      begin
                        state   <= CRC_ST;
                        data_op <= shift_reg;
                        `ifdef MODELSIM
                          $display("[SPI-AMM] Received data:\t 0x%x", shift_reg);
                        `endif
                      end
                    bit_send <= 1'b1;
                  end
                CRC_ST :
                  begin
                    if( rx_we )
                      begin
                        state  <= WORK_ST;
                        crc_op <= shift_reg;
                        `ifdef MODELSIM
                          $display("[SPI-AMM] Received CRC:\t 0x%x", shift_reg);
                        `endif
                      end
                  end
                WORK_ST :
                  begin
                    bit_send <= 1'b1;
                    case (sub_state)
                      SUB_IDLE :
                        begin
                          amm_address <= addr_op[AMM_ADDR_WIDTH-1:0];
                          if (write_op)
                            begin
                              if( ( ( ( write_op ) ? WRITE_OPERATION : READ_OPERATION ) ^ data_op  ^ addr_op ) == crc_op )
                                begin
                                  amm_writedata <= data_op;
                                  amm_write     <= 1'b1;
                                  if (!amm_waitrequest)
                                    sub_state <= SUB_WRITE;
                                end
                                else
                                  begin
                                    sub_state <= SUB_FINISH;
                                    `ifdef MODELSIM
                                      $display("[SPI-AMM] BAD data!!!\nCalculated CRC: %0x", ( ( write_op ) ? WRITE_OPERATION : READ_OPERATION ) ^ data_op ^ addr_op );
                                    `endif
                                  end
                            end
                          else
                            begin
                              amm_read <= 1'b1;
                              if (!amm_waitrequest)
                                sub_state <= SUB_READ;
                            end
                        end
                      SUB_WRITE :
                        begin
                          `ifdef MODELSIM
                            $display("[SPI-AMM] Data OK!(WR)");
                          `endif
                          sub_state <= SUB_FINISH;
                          amm_write <= 1'b0;
                        end
                      SUB_READ :
                        begin
                          amm_read <= 1'b0;
                          if (amm_readdatavalid)
                            begin
                              word_send <= amm_readdata;
                              sub_state <= SUB_FINISH;
                              `ifdef MODELSIM
                                $display("[SPI-AMM] Data OK!(RD)");
                                $display("[SPI-AMM] Transmitted 0x%x data", amm_readdata);
                              `endif
                            end
                        end
                      SUB_FINISH :
                        begin
                          sub_state     <= SUB_IDLE;
                          state         <= RESPONSE_ST;
                          bit_send      <= 1'b0;
                          amm_read      <= '0;
                          amm_write     <= '0;
                          amm_address   <= '0;
                          amm_writedata <= '0;
                        end
                      default :
                        begin
                          sub_state <= SUB_IDLE;
                        end
                    endcase
                  end
                RESPONSE_ST :
                  begin
                    if(nSS_reg)
                      begin
                        state <= IDLE_ST;
                      end
                    else
                      begin
                        if (!write_op && !spi_bit_send)
                          begin
                            word_ready <= 1'b1;
                            if (tx_cnt == 1)
                              begin
                                word_send <= READ_OPERATION ^ addr_op ^ word_send;
                                `ifdef MODELSIM
                                  $display("[SPI-AMM] Transmitted 0x%x CRC", READ_OPERATION ^ addr_op ^ word_send);
                                `endif
                                state <= RESPONSE_CRC_ST;
                              end
                          end
                      end
                  end
                RESPONSE_CRC_ST :
                  begin
                    if(nSS_reg)
                      state <= IDLE_ST;
                  end
                default : state <= IDLE_ST;
              endcase
            end
        end

endmodule