`timescale 10ps/10ps

module ams_spi_tb ();

  logic clk_100m = 0;
  logic reset_n  = 0;

  logic [31:0] ams_address       = '0;
  logic [31:0] ams_writedata     = '0;
  logic [31:0] ams_readdata          ;
  logic        ams_write         = '0;
  logic        ams_read          = '0;
  logic        ams_readdatavalid     ;
  logic        ams_waitrequest       ;

  logic custom_MISO = 0;

  initial
    fork
      forever #333 clk_100m = ~clk_100m;
    join

  default clocking main @( posedge clk_100m );
  endclocking

  initial
    begin
      ##3 reset_n = 1;
      ##10;
      write(32'h00000001, 32'hDEADBEEF);
      ##10;
      read(32'h00000001);
      ##10;
      read(32'h00000001);
      ##10;
      read(32'h00000001);
      for (int i = 0; i < 10; i++) begin
        if ( $random() & 32'h1 )
          write($random(), $random());
        else
          read($random());
      end
      ##500;
      $finish;
    end

  initial begin
    ##675 custom_MISO = 1;
    @(ams_spi_inst.spi_state == ams_spi_inst.FINISH_SST) custom_MISO = 0;
  end

  ams_spi #(
    .ADDR_WIDTH  (32         ),
    .CLOCK_FREQ  (150_000_000),
    .SPI_CLOCK   (50_000_000 ),
    .READ_TIMEOUT(128        )
  ) ams_spi_inst (
    .main_reset       (~reset_n              ),
    .main_clk         (clk_100m              ),
    .ams_address      (ams_address           ),
    .ams_writedata    (ams_writedata         ),
    .ams_readdata     (ams_readdata          ),
    .ams_write        (ams_write             ),
    .ams_read         (ams_read              ),
    .ams_readdatavalid(ams_readdatavalid     ),
    .ams_waitrequest  (ams_waitrequest       ),
    .MOSI             (MOSI                  ),
    .MISO             (MISO    || custom_MISO),
    .SCLK             (SCLK                  ),
    .nSS              (nSS                   )
  );

  wire  [31:0] spi_amm_bridge_0_avalon_master_readdata;                     // mm_interconnect_0:spi_amm_bridge_0_avalon_master_readdata -> spi_amm_bridge_0:amm_readdata
  wire         spi_amm_bridge_0_avalon_master_waitrequest;                  // mm_interconnect_0:spi_amm_bridge_0_avalon_master_waitrequest -> spi_amm_bridge_0:amm_waitrequest
  wire  [16:0] spi_amm_bridge_0_avalon_master_address;                      // spi_amm_bridge_0:amm_address -> mm_interconnect_0:spi_amm_bridge_0_avalon_master_address
  wire         spi_amm_bridge_0_avalon_master_read;                         // spi_amm_bridge_0:amm_read -> mm_interconnect_0:spi_amm_bridge_0_avalon_master_read
  wire         spi_amm_bridge_0_avalon_master_readdatavalid;                // mm_interconnect_0:spi_amm_bridge_0_avalon_master_readdatavalid -> spi_amm_bridge_0:amm_readdatavalid
  wire  [31:0] spi_amm_bridge_0_avalon_master_writedata;                    // spi_amm_bridge_0:amm_writedata -> mm_interconnect_0:spi_amm_bridge_0_avalon_master_writedata
  wire         spi_amm_bridge_0_avalon_master_write;  
  wire         mm_interconnect_0_onchip_memory2_0_s1_chipselect;            // mm_interconnect_0:onchip_memory2_0_s1_chipselect -> onchip_memory2_0:chipselect
  wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_readdata;              // onchip_memory2_0:readdata -> mm_interconnect_0:onchip_memory2_0_s1_readdata
  wire  [14:0] mm_interconnect_0_onchip_memory2_0_s1_address;               // mm_interconnect_0:onchip_memory2_0_s1_address -> onchip_memory2_0:address
  wire   [3:0] mm_interconnect_0_onchip_memory2_0_s1_byteenable;            // mm_interconnect_0:onchip_memory2_0_s1_byteenable -> onchip_memory2_0:byteenable
  wire         mm_interconnect_0_onchip_memory2_0_s1_write;                 // mm_interconnect_0:onchip_memory2_0_s1_write -> onchip_memory2_0:write
  wire  [31:0] mm_interconnect_0_onchip_memory2_0_s1_writedata;             // mm_interconnect_0:onchip_memory2_0_s1_writedata -> onchip_memory2_0:writedata
  wire         mm_interconnect_0_onchip_memory2_0_s1_clken;
  
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
    .main_clk         (clk_100m                                    ), //         clock.clk
    .main_reset       (~reset_n                                    ), //         reset.reset
    .amm_address      (spi_amm_bridge_0_avalon_master_address      ), // avalon_master.address
    .amm_writedata    (spi_amm_bridge_0_avalon_master_writedata    ), //              .writedata
    .amm_readdata     (spi_amm_bridge_0_avalon_master_readdata     ), //              .readdata
    .amm_write        (spi_amm_bridge_0_avalon_master_write        ), //              .write
    .amm_read         (spi_amm_bridge_0_avalon_master_read         ), //              .read
    .amm_readdatavalid(spi_amm_bridge_0_avalon_master_readdatavalid), //              .readdatavalid
    .amm_waitrequest  (spi_amm_bridge_0_avalon_master_waitrequest  ), //              .waitrequest
    .MISO             (MISO                                        ), //           SPI.miso
    .MOSI             (MOSI                                        ), //              .mosi
    .SCLK             (SCLK                                        ), //              .sclk
    .nSS              (nSS                                         )  //              .nss
  );

  i2c_m_mm_interconnect_0 mm_interconnect_0 (
    .pll_0_outclk1_clk                                 (clk_100m                                        ), //                                pll_0_outclk1.clk
    .spi_amm_bridge_0_reset_reset_bridge_in_reset_reset(~reset_n                                        ), // spi_amm_bridge_0_reset_reset_bridge_in_reset.reset
    .spi_amm_bridge_0_avalon_master_address            (spi_amm_bridge_0_avalon_master_address          ), //               spi_amm_bridge_0_avalon_master.address
    .spi_amm_bridge_0_avalon_master_waitrequest        (spi_amm_bridge_0_avalon_master_waitrequest      ), //                                             .waitrequest
    .spi_amm_bridge_0_avalon_master_read               (spi_amm_bridge_0_avalon_master_read             ), //                                             .read
    .spi_amm_bridge_0_avalon_master_readdata           (spi_amm_bridge_0_avalon_master_readdata         ), //                                             .readdata
    .spi_amm_bridge_0_avalon_master_readdatavalid      (spi_amm_bridge_0_avalon_master_readdatavalid    ), //                                             .readdatavalid
    .spi_amm_bridge_0_avalon_master_write              (spi_amm_bridge_0_avalon_master_write            ), //                                             .write
    .spi_amm_bridge_0_avalon_master_writedata          (spi_amm_bridge_0_avalon_master_writedata        ), //                                             .writedata
    .onchip_memory2_0_s1_address                       (mm_interconnect_0_onchip_memory2_0_s1_address   ), //                          onchip_memory2_0_s1.address
    .onchip_memory2_0_s1_write                         (mm_interconnect_0_onchip_memory2_0_s1_write     ), //                                             .write
    .onchip_memory2_0_s1_readdata                      (mm_interconnect_0_onchip_memory2_0_s1_readdata  ), //                                             .readdata
    .onchip_memory2_0_s1_writedata                     (mm_interconnect_0_onchip_memory2_0_s1_writedata ), //                                             .writedata
    .onchip_memory2_0_s1_byteenable                    (mm_interconnect_0_onchip_memory2_0_s1_byteenable), //                                             .byteenable
    .onchip_memory2_0_s1_chipselect                    (mm_interconnect_0_onchip_memory2_0_s1_chipselect), //                                             .chipselect
    .onchip_memory2_0_s1_clken                         (mm_interconnect_0_onchip_memory2_0_s1_clken     )  //                                             .clken
  );


  task write(integer addr, integer data);
    begin
      $display("[TB] Send: 0x%x Ad: 0x%x", data, addr);
      ams_address   <= addr;
      ams_write     <= 1'b1;
      ams_writedata <= data;
      @(negedge ams_waitrequest);
      @(posedge clk_100m);
      ams_write <= 1'b0;
    end
  endtask : write

  task read(integer addr);
    begin
      $display("[TB] Read from: 0x%x", addr);
      ams_address   <= addr;
      ams_read      <= 1'b1;
      @(negedge ams_waitrequest);
      @(posedge clk_100m);
      ams_read <= 1'b0;
    end
  endtask : read

endmodule