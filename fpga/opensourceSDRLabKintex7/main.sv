module top (
    input  logic clk, // 50MHz
    input  logic rst_n,

    output logic [7:0] led,
    output logic [2:0] TMDS_DATA_P1,
    output logic [2:0] TMDS_DATA_N1,
    output logic       TMDS_CLK_P1,
    output logic       TMDS_CLK_N1,
    output logic       HDMI_OUT_EN1
);

logic visible_area, hsync, vsync;
logic [7:0] red, blue, green;

logic locked, pixel_clk, serial_clk;

clk_wiz_0 clk_wiz_0_inst (
    .clk_out1 (pixel_clk),  // Pixel clock - 25 MHz
    .clk_out2 (serial_clk), // Serial clock - 125 MHz

    .resetn   (rst_n),      // Active low reset
    .locked   (locked),     // Locked signal
    .clk_in1  (clk)         // System clock - 50 MHz
);


rgb2dvi rgb2dvi_0_inst1(
    .TMDS_Clk_p  (TMDS_CLK_P1),
    .TMDS_Clk_n  (TMDS_CLK_N1),
    .TMDS_Data_p (TMDS_DATA_P1),
    .TMDS_Data_n (TMDS_DATA_N1),
    .aRst        (1'b0), 
    .vid_pData   ({red, blue, green}),
    .vid_pVDE    (visible_area),
    .vid_pHSync  (hsync),
    .vid_pVSync  (vsync),
    .PixelClk    (pixel_clk),
    .SerialClk   (serial_clk)
);

logic wr_en;
logic [24:0] wr_data;
logic [18:0] wr_addr;

assign wr_en = 0;

VGA #(
    .VGA_WIDTH            (640),
    .VGA_HEIGHT           (480),
    .VGA_COLOR_DEPTH      (4)
) u_VGA (
    .clk                  (pixel_clk),                     // 1 bit
    .rst_n                (rst_n),                         // 1 bit

    .vga_r                (red),                           // ? bits
    .vga_g                (green),                         // ? bits
    .vga_b                (blue),                          // ? bits
    .hsync                (hsync),                         // 1 bit
    .vsync                (vsync),                         // 1 bit
    .vga_visible          (visible_area)
);

assign HDMI_OUT_EN1 = 1'b1; 

endmodule
