module VGA #(
    parameter CLK_FREQ        = 100_000_000,
    parameter VGA_CLK_FREQ    = 25_000_000,
    parameter VGA_WIDTH       = 640,
    parameter VGA_HEIGHT      = 480,
    parameter VGA_COLOR_DEPTH = 4,
    parameter BUFFER_WIDTH    = VGA_COLOR_DEPTH * 3 // RGB888
) (
    input  logic clk,
    input  logic rst_n,
    
    input  logic wr_en_i,
    input  logic [BUFFER_WIDTH - 1:0] wr_data_i,
    input  logic [18:0] wr_addr_i,

    output logic [VGA_COLOR_DEPTH - 1:0] vga_r,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_g,
    output logic [VGA_COLOR_DEPTH - 1:0] vga_b,
    output logic hsync,
    output logic vsync,
    output logic vga_visible
);

    localparam BUFFER_SIZE = VGA_WIDTH * VGA_HEIGHT;

    logic [VGA_COLOR_DEPTH - 1: 0] video_buffer [0: BUFFER_SIZE - 1];

    initial begin
        $readmemh("initial_video.hex", video_buffer);
    end

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

    always_ff @( posedge clk ) begin : BUFFER_INPUT_LOGIC
        if(wr_en_i) begin
            video_buffer[wr_addr_i] <= wr_data_i;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin : PIXEL_ADDR_LOGIC
        if (!rst_n) begin
            pixel_index <= 0;
        end else begin
            if (visible_area) begin
                pixel_index <= pixel_index + 1;
            end else if (h_count == 0 && v_count == 0) begin
                pixel_index <= 0;  // Reinicia no topo da tela
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

    assign vga_r = visible_area ? video_buffer[pixel_index] : 0;
    assign vga_g = visible_area ? video_buffer[pixel_index] : 0;
    assign vga_b = visible_area ? video_buffer[pixel_index] : 0;
    assign hsync = ~(h_count >= (H_VISIBLE + H_FRONT_PORCH) &&
                     h_count < (H_VISIBLE + H_FRONT_PORCH + H_SYNC_PULSE));
    assign vsync = ~(v_count >= (V_VISIBLE + V_FRONT_PORCH) &&
                     v_count < (V_VISIBLE + V_FRONT_PORCH + V_SYNC_PULSE));

    assign visible_area = (h_count < H_VISIBLE) && (v_count < V_VISIBLE);
    assign vga_visible  = visible_area;

endmodule
