module tb_link_top;

    // Testbench signals
    reg clk;
    reg rst;
    wire done;

    // Instantiate the Device Under Test (DUT)
    link_top dut (
        .clk(clk),
        .rst(rst),
        .done(done)
    );

    // Clock Generator
    parameter CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Simulation Stimulus and Control
    initial begin
        // For waveform viewing
        $dumpfile("waveform.vcd");
        // Dump signals in top and one level down
        $dumpvars(1, tb_link_top);

        // 1) Apply Reset
        rst = 1;
        #20;
        rst = 0;
        $display("Reset released. Starting transfer...");

        // 2) Run until 'done' is high, then stop
        wait (dut.done == 1'b1);
        $display("Transfer complete! 'done' signal received at time %0t.", $time);

        // Wait a few more cycles to see the 'done' pulse clearly
        #50;

        // 3) Stop simulation
        $finish;
    end

endmodule
