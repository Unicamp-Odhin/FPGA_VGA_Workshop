module pixel_gen #(
    parameter VGA_WIDTH       = 640,
    parameter VGA_HEIGHT      = 480,
    parameter VGA_COLOR_DEPTH = 4,
    parameter BUFFER_WIDTH    = VGA_COLOR_DEPTH * 3 // RGB888
) (
    input  logic visible_area,
    input  logic [18:0] id,
    output logic [VGA_COLOR_DEPTH - 1:0] r,
    output logic [VGA_COLOR_DEPTH - 1:0] g,
    output logic [VGA_COLOR_DEPTH - 1:0] b
);

    localparam BUFFER_SIZE = VGA_WIDTH * VGA_HEIGHT;

    logic [VGA_COLOR_DEPTH - 1: 0] video_buffer [0: BUFFER_SIZE - 1];

    initial begin
        $readmemh("initial_video.hex", video_buffer);
    end

    // WIDTH = 64
    logic [5:0] x;
    logic [9:0] y;

    assign x = id[5:0];
    assign y = id[15:6];

    // Padrão escolhido
    logic [7:0] val;
    assign val = x ^ y;

    //assign r = visible_area ? val      : 0;
    //assign g = visible_area ? ~val     : 0;
    //assign b = visible_area ? val >> 1 : 0;

    assign r = video_buffer[id];
    assign g = video_buffer[id];
    assign b = video_buffer[id];

    //assign r = visible_area ? 0       : 0;
    //assign g = visible_area ? 0       : 0;
    //assign b = visible_area ? 8'hFFFF : 0;

endmodule
