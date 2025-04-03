// scan_dff.v
module scan_dff (
    input  wire clk,
    input  wire rst,
    input  wire d,        // Normal data input
    input  wire scan_in,  // Scan (serial) data input
    input  wire scan_en,  // Scan enable signal: when high, shift in scan_in
    output reg  q,       // Flip-flop output (normal and scan)
    output reg  scan_out // Output for chaining to the next flip-flop
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            q <= 1'b0;
        else if (scan_en)
            q <= scan_in; // In scan mode, capture serial data
        else
            q <= d;       // In functional mode, capture normal data
    end

    // Continuously assign the current output to the scan chain output.
    always @(posedge clk) begin
        scan_out <= q;
    end
endmodule
