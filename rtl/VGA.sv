module VGA #(
    parameter VGA_WIDTH       = 640,
    parameter VGA_HEIGHT      = 480,
    parameter VGA_COLOR_DEPTH = 4,
    parameter BUFFER_WIDTH    = VGA_COLOR_DEPTH * 3 // RGB888
) (
    input  logic clk,
    input  logic rst_n,

    output logic [VGA_COLOR_DEPTH - 1:0] vga_r,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_g,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_b,
    output logic hsync,
    output logic vsync,
    output logic vga_visible
);
    // VGA Timing Parameters for 640x480 @ 60Hz
    localparam H_VISIBLE     = 640;
    localparam H_FRONT_PORCH = 16;
    localparam H_SYNC_PULSE  = 96;
    localparam H_BACK_PORCH  = 48;
    localparam H_TOTAL       = H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE + H_BACK_PORCH;

    localparam V_VISIBLE     = 480;
    localparam V_FRONT_PORCH = 10;
    localparam V_SYNC_PULSE  = 2;
    localparam V_BACK_PORCH  = 33;
    localparam V_TOTAL       = V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE + V_BACK_PORCH;

    logic [9:0] h_count;
    logic [9:0] v_count;
    logic visible_area;

    logic [18:0] pixel_index;
    always_ff @(posedge clk or negedge rst_n) begin : PIXEL_ADDR_LOGIC
        if (!rst_n) begin
            pixel_index <= 0;
        end else begin
            if (v_count == 0 && h_count == 0) begin
                pixel_index <= 0;
            end else if (visible_area) begin
                pixel_index <= pixel_index + 1;
            end
        end
    end

    // Contadores de varredura
    always_ff @(posedge clk or negedge rst_n) begin : VGA_SYNC_LOGIC
        if (!rst_n) begin
            h_count <= 0;
            v_count <= 0;
        end else begin
            if (h_count == H_TOTAL - 1) begin
                h_count <= 0;
                if (v_count == V_TOTAL - 1)
                    v_count <= 0;
                else
                    v_count <= v_count + 1;
            end else begin
                h_count <= h_count + 1;
            end
        end
    end

    assign hsync = ~(h_count >= (H_VISIBLE + H_FRONT_PORCH) &&
                     h_count < (H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE));
    assign vsync = ~(v_count >= (V_VISIBLE + V_FRONT_PORCH) &&
                     v_count < (V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE));

    assign visible_area = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);
    assign vga_visible  = visible_area;

    pixel_gen #(
        .VGA_WIDTH       (VGA_WIDTH),
        .VGA_HEIGHT      (VGA_HEIGHT),
        .VGA_COLOR_DEPTH (VGA_COLOR_DEPTH)
    ) u1 (
        .visible_area (visible_area),
        .id           (pixel_index),
        .r            (vga_r),
        .g            (vga_g),
        .b            (vga_b)
    );

endmodule
