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
    output logic [0:6] HEX5
);

logic reset_bousing;

initial begin
    reset_bousing = 1'b0;
end



always @(posedge CLOCK_50) begin
    reset_bousing <= ~KEY[0];
end

    
endmodule