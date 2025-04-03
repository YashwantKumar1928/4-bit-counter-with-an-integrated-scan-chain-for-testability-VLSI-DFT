// tb_four_bit_counter_scan.v
`timescale 1ns/1ps
module tb_four_bit_counter_scan;
    reg clk;
    reg rst;
    reg scan_en;
    reg scan_in;
    wire [3:0] count;
    wire scan_out;

    // Instantiate the four-bit counter with scan chain functionality.
    four_bit_counter_scan uut (
        .clk(clk),
        .rst(rst),
        .scan_en(scan_en),
        .scan_in(scan_in),
        .count(count),
        .scan_out(scan_out)
    );

    // Clock generation: a 10 ns period.
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    // Stimulus sequence.
    initial begin
        // Step 1: Initialize and reset the system.
        rst = 1;
        scan_en = 0;
        scan_in = 0;
        #12;
        rst = 0;
        
        // Step 2: Run in normal mode to observe counting.
        $display("---- Normal Mode: Counter Running ----");
        repeat (5) begin
            #10; // wait one clock cycle
            $display("Time=%0t, count=%b", $time, count);
        end
        
        // Step 3: Enable scan mode and shift in a known pattern.
        $display("\n---- Scan Mode: Shifting in Pattern 1,0,1,0 ----");
        scan_en = 1;
        // The following sequence shifts in 4 bits, one per clock cycle:
        scan_in = 1; #10;  // Shift in '1'
        scan_in = 0; #10;  // Shift in '0'
        scan_in = 1; #10;  // Shift in '1'
        scan_in = 0; #10;  // Shift in '0'

        // Step 4: Disable scan mode and observe the new counter state.
        scan_en = 0;
        #10;
        $display("After Scan Shift, count=%b (Expected pattern: 1010)", count);
        
        // Step 5: Resume normal operation.
        $display("\n---- Resuming Normal Mode ----");
        repeat (3) begin
            #10;
            $display("Time=%0t, count=%b", $time, count);
        end

        $finish;
    end
endmodule
