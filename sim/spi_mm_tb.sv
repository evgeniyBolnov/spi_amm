`timescale 10ps/10ps

module spi_mm_tb ();

  logic clk_100m = 0;
  logic reset_n  = 0;
                             //      RW        ADDR     DATA      CRC
  logic [127:0] rx_data[$] = {128'hAAAAAAAA_00000000_DEADBEEF_74071445,
                              128'hAAAAAAAA_00000001_CC00FFEE_00000000,
                              128'hAAAAAAAA_00000001_CC00FFEE_66aa5545,
                              128'hBBBBBBBB_00000001_00000000_00000000,
                              128'hBBBBBBBB_00000001_00000000_00000000,
                              128'hBBBBBBBB_00000000_00000000_00000000};

  logic [63:0] rx_shift_reg;

  integer sended_data[$];
  integer rx_data_pop   ;

  logic MOSI = 1;
  logic MISO    ;
  logic SCLK = 0;
  logic nSS  = 1;

  logic        spi_select    = 0 ;
  logic        write_n       = 1 ;
  logic        read_n        = 1 ;
  logic [ 2:0] mem_addr      = '0;
  logic [31:0] data_from_cpu = '0;
  logic [31:0] data_to_cpu   = '0;

  logic [31:0] spi_read_data;

  logic [15:0] stat;

  logic [127:0] send_spi_word;

  logic eq;

  logic custom_waitrequest;

  initial
    fork
      forever #500 clk_100m = ~clk_100m;
      forever #2000 SCLK = ~SCLK;
    join

  default clocking main @( posedge clk_100m );
  endclocking

  initial 
    begin
      custom_waitrequest <= 0;
      ##1350;
      custom_waitrequest <= 1;
      ##100;
      custom_waitrequest <= 0;
      ##3200;
      custom_waitrequest <= 1;
      ##100;
      custom_waitrequest <= 0;
    end

  initial
    begin
      ##3 reset_n = 1;
      ##100;
      while( rx_data.size() != 0 )
        begin
          @(negedge SCLK);
          nSS <= '0;
          send_spi_word = rx_data.pop_front();
          for (int i = 127; i >= 0; i--)
            begin
              if(send_spi_word[127 -: 32] == 32'hAAAAAAAA)
                MOSI <= send_spi_word[i];
              else
                begin
                  if( i < 64 )
                    begin
                      MOSI <= 0;
                      break;
                    end
                  else
                    MOSI <= send_spi_word[i];
                end
              @(negedge SCLK);
            end
          if(send_spi_word[127 -: 32] == 32'hAAAAAAAA)
            begin
              @(negedge MISO);
              @(negedge SCLK);
              nSS <= 1;
            end
            else
              begin
                @(negedge MISO);
                repeat(2)@(posedge SCLK);
                for (int j = 0; j < 64; j++)
                  begin
                    rx_shift_reg <= {rx_shift_reg[62:0], MISO};
                    @(posedge SCLK);
                  end
                @(negedge SCLK);
                nSS <= 1;
                $display("[TB] RX data:%0x\n[TB] CRC:%0x(%0s)", rx_shift_reg[63:32], rx_shift_reg[31:0], (((send_spi_word[127 : 96] ^ send_spi_word[95 : 64]) ^ rx_shift_reg[63:32]) == rx_shift_reg[31:0]) ? "CORRECT" : "WRONG" );
              end
        end
      ##1000;
      $finish;
    end
    
  wire  [31:0] spi_mm_bridge_0_avalon_master_readdata;           // mm_interconnect_0:spi_mm_bridge_0_avalon_master_readdata -> spi_mm_bridge_0:amm_readdata
  wire         spi_mm_bridge_0_avalon_master_waitrequest;        // mm_interconnect_0:spi_mm_bridge_0_avalon_master_waitrequest -> spi_mm_bridge_0:amm_waitrequest
  wire  [15:0] spi_mm_bridge_0_avalon_master_address;            // spi_mm_bridge_0:amm_address -> mm_interconnect_0:spi_mm_bridge_0_avalon_master_address
  wire         spi_mm_bridge_0_avalon_master_read;               // spi_mm_bridge_0:amm_read -> mm_interconnect_0:spi_mm_bridge_0_avalon_master_read
  wire         spi_mm_bridge_0_avalon_master_readdatavalid;      // mm_interconnect_0:spi_mm_bridge_0_avalon_master_readdatavalid -> spi_mm_bridge_0:amm_readdatavalid
  wire  [31:0] spi_mm_bridge_0_avalon_master_writedata;          // spi_mm_bridge_0:amm_writedata -> mm_interconnect_0:spi_mm_bridge_0_avalon_master_writedata
  wire         spi_mm_bridge_0_avalon_master_write;              // spi_mm_bridge_0:amm_write -> mm_interconnect_0:spi_mm_bridge_0_avalon_master_write
  wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect; // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
  wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;   // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
  wire  [13:0] mm_interconnect_0_onchip_memory2_0_s1_address;    // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
  wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable; // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
  wire         mm_interconnect_0_onchip_memory2_0_s1_write;      // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
  wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;  // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
  wire         mm_interconnect_0_onchip_memory2_0_s1_clken;      // mm_interconnect_0:onchip_memory2_0_s1_clken -> onchip_memory2_0:clken
  wire         rst_controller_reset_out_reset;                   // rst_controller:reset_out -> [mm_interconnect_0:spi_mm_bridge_0_reset_reset_bridge_in_reset_reset, onchip_memory2_0:reset, spi_mm_bridge_0:main_reset]

  i2c_m_onchip_memory2_0 onchip_memory2_0 (
    .clk       (clk_100m                                        ), //   clk1.clk
    .address   (mm_interconnect_0_onchip_memory2_0_s1_address   ), //     s1.address
    .clken     (mm_interconnect_0_onchip_memory2_0_s1_clken     ), //       .clken
    .chipselect(mm_interconnect_0_onchip_memory2_0_s1_chipselect), //       .chipselect
    .write     (mm_interconnect_0_onchip_memory2_0_s1_write     ), //       .write
    .readdata  (mm_interconnect_0_onchip_memory2_0_s1_readdata  ), //       .readdata
    .writedata (mm_interconnect_0_onchip_memory2_0_s1_writedata ), //       .writedata
    .byteenable(mm_interconnect_0_onchip_memory2_0_s1_byteenable), //       .byteenable
    .reset     (~reset_n                                        ), // reset1.reset
    .reset_req (1'b0                                            ), // (terminated)
    .freeze    (1'b0                                            )  // (terminated)
  );

  spi_amm #(
    .AMM_ADDR_WIDTH(16)
  ) spi_amm_inst (
    .main_clk         (clk_100m                                                       ), //         clock.clk
    .main_reset       (~reset_n                                                       ), //         reset.reset
    .amm_address      (spi_mm_bridge_0_avalon_master_address                          ), // avalon_master.address
    .amm_writedata    (spi_mm_bridge_0_avalon_master_writedata                        ), //              .writedata
    .amm_readdata     (spi_mm_bridge_0_avalon_master_readdata                         ), //              .readdata
    .amm_write        (spi_mm_bridge_0_avalon_master_write                            ), //              .write
    .amm_read         (spi_mm_bridge_0_avalon_master_read                             ), //              .read
    .amm_readdatavalid(spi_mm_bridge_0_avalon_master_readdatavalid                    ), //              .readdatavalid
    .amm_waitrequest  (spi_mm_bridge_0_avalon_master_waitrequest || custom_waitrequest), //              .waitrequest
    .MISO             (MISO                                                           ), //           SPI.miso
    .MOSI             (MOSI                                                           ), //              .mosi
    .SCLK             (SCLK                                                           ), //              .sclk
    .nSS              (nSS                                                            )  //              .nss
  );

  i2c_m_mm_interconnect_0 mm_interconnect_0 (
    .clk_0_clk_clk                                    (clk_100m                                        ), //                                   clk_0_clk.clk
    .spi_mm_bridge_0_reset_reset_bridge_in_reset_reset(~reset_n                                        ), // spi_mm_bridge_0_reset_reset_bridge_in_reset.reset
    .spi_mm_bridge_0_avalon_master_address            (spi_mm_bridge_0_avalon_master_address           ), //               spi_mm_bridge_0_avalon_master.address
    .spi_mm_bridge_0_avalon_master_waitrequest        (spi_mm_bridge_0_avalon_master_waitrequest       ), //                                            .waitrequest
    .spi_mm_bridge_0_avalon_master_read               (spi_mm_bridge_0_avalon_master_read              ), //                                            .read
    .spi_mm_bridge_0_avalon_master_readdata           (spi_mm_bridge_0_avalon_master_readdata          ), //                                            .readdata
    .spi_mm_bridge_0_avalon_master_readdatavalid      (spi_mm_bridge_0_avalon_master_readdatavalid     ), //                                            .readdatavalid
    .spi_mm_bridge_0_avalon_master_write              (spi_mm_bridge_0_avalon_master_write             ), //                                            .write
    .spi_mm_bridge_0_avalon_master_writedata          (spi_mm_bridge_0_avalon_master_writedata         ), //                                            .writedata
    .onchip_memory2_0_s1_address                      (mm_interconnect_0_onchip_memory2_0_s1_address   ), //                         onchip_memory2_0_s1.address
    .onchip_memory2_0_s1_write                        (mm_interconnect_0_onchip_memory2_0_s1_write     ), //                                            .write
    .onchip_memory2_0_s1_readdata                     (mm_interconnect_0_onchip_memory2_0_s1_readdata  ), //                                            .readdata
    .onchip_memory2_0_s1_writedata                    (mm_interconnect_0_onchip_memory2_0_s1_writedata ), //                                            .writedata
    .onchip_memory2_0_s1_byteenable                   (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //                                            .byteenable
    .onchip_memory2_0_s1_chipselect                   (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //                                            .chipselect
    .onchip_memory2_0_s1_clken                        (mm_interconnect_0_onchip_memory2_0_s1_clken     )  //                                            .clken
  );
endmodule