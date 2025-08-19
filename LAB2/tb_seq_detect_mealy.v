// Testbench for the seq_detect_mealy module
module tb_seq_detect_mealy;

// Signals for the testbench
reg clk, rst, din;
wire y;

// Instantiate the DUT
seq_detect_mealy dut(.clk(clk), .rst(rst), .din(din), .y(y));

// Clock generation
initial begin
    clk = 0;
    forever #5 clk = ~clk;
end

// Stimulus generation
initial begin
    // Synchronous reset
    rst = 1;
    din = 0;
    #10;
    rst = 0;

    // Test sequence: 1101101101
    // Expected pulses: at the end of the 1st, 2nd, and 3rd "1101" patterns.
    // The pulses will appear at simulation times 40, 80, and 100 ns.
    din = 1; #10;
    din = 1; #10;
    din = 0; #10;
    din = 1; #10; // First pattern "1101" is detected.
    din = 1; #10;
    din = 0; #10;
    din = 1; #10;
    din = 1; #10; // Second pattern "1101" is detected.
    din = 0; #10;
    din = 1; #10; // Third pattern "1101" is detected.

    // End simulation
    #50;
    $finish;
end

// Waveform and log file dumping
initial begin
    $dumpfile("dump.vcd");
    $dumpvars(0, tb_seq_detect_mealy);
    $monitor("Time=%0t, rst=%b, din=%b, y=%b", $time, rst, din, y);
end

endmodule
