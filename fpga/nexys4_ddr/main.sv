//`define COMPRESS_OUT 1
//`define SPI_RST_EN 1

module top (
    input logic clk,  // 100MHz

    output logic [15:0] LED,

    input logic [15:0] SW,

    input logic CPU_RESETN,

    // VGA
    output logic VGA_HS,
    output logic VGA_VS,
    output logic [3:0] VGA_R,
    output logic [3:0] VGA_G,
    output logic [3:0] VGA_B
);



endmodule

