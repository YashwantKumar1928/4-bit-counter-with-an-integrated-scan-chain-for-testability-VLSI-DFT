// four_bit_counter_scan.v
module four_bit_counter_scan (
    input  wire clk,
    input  wire rst,
    input  wire scan_en,
    input  wire scan_in,   // External scan input (to the first flip-flop)
    output [3:0] count,    // Current counter value from the flip-flops
    output scan_out        // Final chain output from the last flip-flop
);
    // Internal wires to connect scan outputs from one FF to the next.
    wire chain0, chain1, chain2;
    reg [3:0] next_val;

    // Compute the next count value (normal mode: counter increments by 1)
    // Note: This is a purely combinational block that uses the current state.
    always @(*) begin
        next_val = count + 4'b0001;
    end

    // Instantiate four scan-enabled flip-flops
    // The chain is built so that the external scan signal enters the first FF
    // and each scan_out connects to the next FF's scan_in.
    scan_dff ff0 (
        .clk(clk),
        .rst(rst),
        .d(next_val[0]),
        .scan_in(scan_in),
        .scan_en(scan_en),
        .q(count[0]),
        .scan_out(chain0)
    );

    scan_dff ff1 (
        .clk(clk),
        .rst(rst),
        .d(next_val[1]),
        .scan_in(chain0),
        .scan_en(scan_en),
        .q(count[1]),
        .scan_out(chain1)
    );

    scan_dff ff2 (
        .clk(clk),
        .rst(rst),
        .d(next_val[2]),
        .scan_in(chain1),
        .scan_en(scan_en),
        .q(count[2]),
        .scan_out(chain2)
    );

    scan_dff ff3 (
        .clk(clk),
        .rst(rst),
        .d(next_val[3]),
        .scan_in(chain2),
        .scan_en(scan_en),
        .q(count[3]),
        .scan_out(scan_out)
    );
endmodule
