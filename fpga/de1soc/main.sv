module top (
    input  logic CLOCK_50,
    input  logic [9:0] SW,
    output logic [9:0] LEDR,
    input  logic [3:0] KEY,
    output logic [0:6] HEX0,
    output logic [0:6] HEX1,
    output logic [0:6] HEX2,
    output logic [0:6] HEX3,
    output logic [0:6] HEX4,
    output logic [0:6] HEX5,
    output logic [7:0] VGA_B,
    output logic [7:0] VGA_G,
    output logic [7:0] VGA_R,
    output logic VGA_CLK,
    output logic VGA_SYNC_N,
    output logic VGA_BLANK_N,
    output logic VGA_HS,
    output logic VGA_VS
);

logic reset_bousing;
logic clk;

initial begin
    reset_bousing = 1'b0;
    clk = 0;
end

always @(posedge CLOCK_50) begin
    reset_bousing <= KEY[0];
    clk <= ~clk;
end

logic wr_en;
logic [24:0] wr_data;
logic [18:0] wr_addr;

assign wr_en = 0;

logic r, g, b;

assign VGA_B = {b, 4'h0};
assign VGA_R = {r, 4'h0};
assign VGA_G = {g, 4'h0};

VGA #(
    .VGA_WIDTH            (640),
    .VGA_HEIGHT           (480),
    .VGA_COLOR_DEPTH      (4)
) u_VGA (
    .clk                  (clk),                           // 1 bit
    .rst_n                (reset_bousing),                // 1 bit

    .vga_r                (r),                         // ? bits
    .vga_g                (g),                         // ? bits
    .vga_b                (b),                         // ? bits
    .hsync                (VGA_HS),                        // 1 bit
    .vsync                (VGA_VS),                        // 1 bit
    .vga_visible          (VGA_BLANK_N)
);

assign VGA_SYNC_N = ~(VGA_HS & VGA_VS);
assign VGA_CLK    = clk;

endmodule