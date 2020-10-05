module ams_spi #(
  parameter ADDR_WIDTH   = 32         ,
  parameter SS_COUNT     = 2          ,
  parameter CLOCK_FREQ   = 150_000_000,
  parameter SPI_CLOCK    = 50_000_000 ,
  parameter READ_TIMEOUT = 60
) (
  input                         main_reset       ,
  input                         main_clk         ,
  // Avalon-MM Slave
  input        [ADDR_WIDTH-1:0] ams_address      ,
  input        [          31:0] ams_writedata    ,
  output logic [          31:0] ams_readdata     ,
  input                         ams_write        ,
  input                         ams_read         ,
  output logic                  ams_readdatavalid,
  output logic                  ams_waitrequest  ,
  output logic [           1:0] ams_response     ,
  //SPI
  output logic                  MOSI             ,
  input                         MISO             ,
  output                        SCLK             ,
  output logic [  SS_COUNT-1:0] nSS
);

  initial
    begin
      $warning("Clock divider: %f", CLOCK_DIV );
      $warning("Result clock: %f", CLOCK_FREQ / ( 2000000.0 * CLOCK_DIV ) );
      if ( ADDR_WIDTH - ((SS_COUNT > 1) ? $clog2(SS_COUNT) : 1) < 2)
        $error("No Address space");
      else
        $warning("SS width: %d", (SS_COUNT > 1) ? $clog2(SS_COUNT) : 1);
    end

  localparam integer CLOCK_DIV = CLOCK_FREQ / ( 2 * SPI_CLOCK );

  localparam WRITE_WORD = 32'hAAAAAAAA;
  localparam READ_WORD  = 32'hBBBBBBBB;

  enum logic[5:0] {
    IDLE_ST,
    READ_STATE_ST,
    WRITE_ST,
    READ_ST,
    FINISH_ST,
    RESET_ST
  } ams_state;

  enum logic[9:0] {
    IDLE_SST,
    PREAMBULE_SST,
    ADDRESS_SST,
    WDATA_SST,
    CRC_SST,
    WAIT_ACK_SST,
    RDATA_SST,
    RCRC_SST,
    FINISH_SST,
    RESET_SST
  } spi_state;

  logic [31:0] writedata;
  logic [31:0] address  ;

  logic [ 5:0] spi_cnt          ;
  logic [31:0] spi_shiftreg     ;
  logic [31:0] spi_read_shiftreg;
  logic [31:0] readdata         ;
  logic [31:0] crc              ;

  logic [$clog2(SS_COUNT):0] ss_select;

  integer timeout;

  generate
    logic SCLK_reg;

    assign SCLK     = ~SCLK_reg;

    if ( CLOCK_DIV < 1 )
      begin
        assign SCLK_reg = main_clk;
      end
    else
      begin
        logic [$clog2(CLOCK_DIV):0] clock_div_cnt;

        always_ff @(posedge main_clk or posedge main_reset)
          begin
            if (main_reset)
              begin
                clock_div_cnt <= '0;
                SCLK_reg      <= 1'b1;
              end
            else
              begin
                clock_div_cnt <= ( clock_div_cnt == CLOCK_DIV - 1 ) ? '0 : clock_div_cnt + 1'b1;
                if ( clock_div_cnt == CLOCK_DIV - 1 )
                  SCLK_reg <= ~SCLK_reg;
              end
          end
        end

  endgenerate

  always_ff @(posedge SCLK_reg or posedge main_reset)
    begin
      if ( main_reset )
        begin
          spi_state         <= RESET_SST;
          spi_shiftreg      <= '0;
          MOSI              <= 1'b1;
          timeout           <= '0;
          spi_cnt           <= '0;
          nSS               <= '1;
          readdata          <= '0;
          spi_read_shiftreg <= '0;
        end
      else
        begin
          case (spi_state)
            IDLE_SST :
              begin
                if ( ams_state == WRITE_ST || ams_state == READ_ST )
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] ========START=========");
                    `endif
                    spi_state    <= PREAMBULE_SST;
                    spi_shiftreg <= ( ams_state == WRITE_ST ) ? WRITE_WORD : READ_WORD;
                  end
                else
                  begin
                    spi_cnt <= '0;
                    nSS     <= '1;
                  end
                timeout <= '0;
                MOSI    <= 1'b1;
              end
            PREAMBULE_SST :
              begin
                if ( spi_cnt < 31 )
                  begin
                    spi_cnt      <= spi_cnt + 1'b1;
                    spi_shiftreg <= {spi_shiftreg[30:0], 1'b0};
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Send %s preambule", ( ams_state == WRITE_ST ) ? "WRITE" : "READ" );
                    `endif
                    spi_state    <= ADDRESS_SST;
                    spi_shiftreg <= address;
                    spi_cnt      <= '0;
                  end
                MOSI           <= spi_shiftreg[31];
                nSS[ss_select] <= 0;
              end
            ADDRESS_SST :
              begin
                if ( spi_cnt < 31 )
                  begin
                    spi_cnt      <= spi_cnt + 1'b1;
                    spi_shiftreg <= {spi_shiftreg[30:0], 1'b0};
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Send 0x%x address", address );
                    `endif
                    spi_state    <= ( ams_state == WRITE_ST ) ? WDATA_SST : WAIT_ACK_SST;
                    spi_shiftreg <= writedata;
                    spi_cnt      <= '0;
                  end
                MOSI           <= spi_shiftreg[31];
                nSS[ss_select] <= 0;
              end
            WDATA_SST :
              begin
                if ( spi_cnt < 31 )
                  begin
                    spi_cnt      <= spi_cnt + 1'b1;
                    spi_shiftreg <= {spi_shiftreg[30:0], 1'b0};
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Send 0x%x data", writedata );
                    `endif
                    spi_state    <= CRC_SST;
                    spi_shiftreg <= ( writedata ^ address ) ^ WRITE_WORD;
                    spi_cnt      <= '0;
                  end
                MOSI           <= spi_shiftreg[31];
                nSS[ss_select] <= 0;
              end
            CRC_SST :
              begin
                if ( spi_cnt < 31 )
                  begin
                    spi_cnt      <= spi_cnt + 1'b1;
                    spi_shiftreg <= {spi_shiftreg[30:0], 1'b0};
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Send 0x%x CRC", ( writedata ^ address ) ^ WRITE_WORD );
                    `endif
                    spi_state <= WAIT_ACK_SST;
                    spi_cnt   <= '0;
                  end
                MOSI           <= spi_shiftreg[31];
                nSS[ss_select] <= 0;
              end
            WAIT_ACK_SST :
              begin
                if ( timeout < READ_TIMEOUT )
                  begin
                    if ( ~MISO )
                      begin
                        if ( ams_state == WRITE_ST )
                          begin
                            spi_state <= FINISH_SST;
                            nSS       <= '1;
                          end
                        else
                          spi_state <= RDATA_SST;
                      end
                    else
                      timeout <= timeout + 1'b1;
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Time is over!!!!" );
                    `endif
                    spi_state <= FINISH_SST;
                  end
                spi_cnt <= '0;
                MOSI    <= 1'b1;
              end
            RDATA_SST :
              begin
                if (spi_cnt < 32)
                  spi_cnt <= spi_cnt + 1'b1;
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Received 0x%x data", spi_read_shiftreg );
                    `endif
                    readdata  <= spi_read_shiftreg;
                    spi_state <= RCRC_SST;
                    spi_cnt   <= '0;
                  end
                spi_read_shiftreg <= {spi_read_shiftreg[30:0], MISO};
                MOSI              <= 1'b1;
              end
            RCRC_SST :
              begin
                if (spi_cnt < 30)
                  begin
                    spi_read_shiftreg <= {spi_read_shiftreg[30:0], MISO};
                    spi_cnt           <= spi_cnt + 1'b1;
                  end
                else
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] Received 0x%x CRC", {spi_read_shiftreg[30:0], MISO} );
                    `endif
                    nSS       <= '1;
                    spi_state <= FINISH_SST;
                    spi_cnt   <= '0;
                    crc       <= {spi_read_shiftreg[30:0], MISO};
                  end
                MOSI <= 1'b1;
              end
            FINISH_SST :
              begin
                if ( ams_state == FINISH_ST )
                  begin
                    `ifdef MODELSIM
                      $display("[AMS-SPI] ========FINISH=========");
                    `endif
                    spi_state <= IDLE_SST;
                  end
                MOSI <= 1'b1;
              end
            default :
              begin
                spi_state <= IDLE_SST;
              end
          endcase
        end
    end

  always_ff @(posedge main_clk or posedge main_reset)
    begin
      if ( main_reset )
        begin
          ams_readdata      <= '0;
          ams_readdatavalid <= '0;
          ams_waitrequest   <= '1;
          ams_response      <= '0;
          writedata         <= '0;
          ams_state         <= RESET_ST;
          address           <= '0;
        end
      else
        begin
          case (ams_state)
            IDLE_ST :
              begin
                if ( ( ams_write || ams_read ) )
                  begin
                    ams_state       <= READ_STATE_ST;
                    ams_waitrequest <= 1'b0;
                  end
                ams_response <= 2'b00;
              end
            READ_STATE_ST :
              begin
                if ( ams_write )
                  begin
                    writedata <= ams_writedata;
                    ams_state <= WRITE_ST;
                  end
                else if ( ams_read )
                  ams_state <= READ_ST;
                ams_waitrequest <= 1'b1;
                address         <= ams_address[ ADDR_WIDTH - ( (SS_COUNT > 1) ? $clog2(SS_COUNT) : 1 ) - 1 : 0 ];
                ss_select       <= ams_address[ ADDR_WIDTH - 1 -: ( (SS_COUNT > 1) ? $clog2(SS_COUNT) : 1 ) ];
              end
            WRITE_ST :
              begin
                if ( spi_state == FINISH_SST)
                  ams_state <= FINISH_ST;
              end
            READ_ST :
              begin
                if ( spi_state == RCRC_SST )
                  ams_readdata <= readdata;
                if ( spi_state == FINISH_SST)
                  begin
                    if ( ( ( ( READ_WORD ^ address ) ^ readdata ) ^ crc ) == 0 )
                      begin
                        if ( timeout < READ_TIMEOUT )
                          begin
                            ams_readdatavalid <= 1'b1;
                            `ifdef MODELSIM
                              $display("[AMS-SPI] Data correct!!!!");
                            `endif
                          end
                        else
                          begin
                            `ifdef MODELSIM
                              $display("[AMS-SPI] Timeout reset!!!!");
                            `endif
                            ams_readdatavalid <= 1'b0;
                            ams_response      <= 2'b10;
                          end
                      end
                    else
                      begin
                        `ifdef MODELSIM
                          $display("[AMS-SPI] CRC error!!!!");
                        `endif
                        ams_readdatavalid <= 1'b0;
                      end
                    ams_state <= FINISH_ST;
                  end
              end
            FINISH_ST :
              begin
                if ( spi_state == IDLE_SST )
                  ams_state <= IDLE_ST;
                ams_readdatavalid <= 1'b0;
                ams_response      <= 2'b00;
              end
            default :
              ams_state <= IDLE_ST;
          endcase
        end
    end

endmodule