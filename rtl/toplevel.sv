module toplevel (
    input        clk        ,
    input        master_miso,
    output       master_mosi,
    output       master_sclk,
    output       master_nss ,
    output       slave_miso ,
    input        slave_mosi ,
    input        slave_sclk ,
    input        slave_nss  ,
    output [7:0] led
);

  spi_amm_qsys u0 (
    .clk_clk        (clk        ), //        clk.clk
    .reset_reset_n  (1'b1       ), //      reset.reset_n
    .spi_master_miso(master_miso), // spi_master.miso
    .spi_master_mosi(master_mosi), //           .mosi
    .spi_master_sclk(master_sclk), //           .sclk
    .spi_master_nss (master_nss ), //           .nss
    .spi_slave_miso (slave_miso ), //  spi_slave.miso
    .spi_slave_mosi (slave_mosi ), //           .mosi
    .spi_slave_sclk (slave_sclk ), //           .sclk
    .spi_slave_nss  (slave_nss  ), //           .nss
    .pio_export     (led        )
  );

endmodule 