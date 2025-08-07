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

logic wr_en;
logic [24:0] wr_data;
logic [18:0] wr_addr;

assign wr_en = 0;

logic clk_vga;

logic locked;

clk_wiz_0 clk_wiz_0_inst (
    .clk_out1 (clk_vga),  // VGA clock - 25.175 MHz

    .resetn   (CPU_RESETN),      // Active low reset
    .locked   (locked),     // Locked signal
    .clk_in1  (clk)         // System clock - 50 MHz
);


VGA #(
    .VGA_WIDTH            (640),
    .VGA_HEIGHT           (480),
    .VGA_COLOR_DEPTH      (4)
) u_VGA (
    .clk                  (clk_vga),                    // 1 bit
    .rst_n                (CPU_RESETN),                    // 1 bit

    .vga_r                (VGA_R),                         // ? bits
    .vga_g                (VGA_G),                         // ? bits
    .vga_b                (VGA_B),                         // ? bits
    .hsync                (VGA_HS),                        // 1 bit
    .vsync                (VGA_VS),                        // 1 bit
    .vga_visible          ()
);

endmodule

