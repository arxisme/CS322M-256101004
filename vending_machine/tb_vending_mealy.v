module tb_vending_mealy;

    // Testbench signals
    reg clk;
    reg rst;
    reg [1:0] coin;
    wire dispense;
    wire chg5;

    // Constants for testability
    parameter COIN_IDLE = 2'b00;
    parameter COIN_5    = 2'b01;
    parameter COIN_10   = 2'b10;

    // Instantiate the Device Under Test (DUT)
    vending_mealy dut (
        .clk(clk),
        .rst(rst),
        .coin(coin),
        .dispense(dispense),
        .chg5(chg5)
    );

    // Clock Generator
    parameter CLK_PERIOD = 10;
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Simulation Stimulus
    initial begin
        // For waveform viewing
        $dumpfile("waveform.vcd");
        $dumpvars(0, tb_vending_mealy);

        // 1. Apply Reset
        rst = 1;
        coin = COIN_IDLE;
        @(posedge clk);
        @(posedge clk);
        rst = 0;
        @(posedge clk);

        // 2. Scenario 1: Simple Vend (10 + 10 = 20)
        $display("Test 1: Inserting 10 + 10");
        coin <= COIN_10; @(posedge clk); // Total = 10
        coin <= COIN_10; @(posedge clk); // Total = 20. dispense should pulse now
        coin <= COIN_IDLE; @(posedge clk); // Back to idle.

        #20;

        // 3. Scenario 2: Vend with Change (5 + 10 + 10 = 25)
        $display("Test 2: Inserting 5 + 10 + 10");
        coin <= COIN_5; @(posedge clk);  // Total = 5
        coin <= COIN_10; @(posedge clk); // Total = 15
        coin <= COIN_10; @(posedge clk); // Total = 25. dispense and chg5 should pulse now
        coin <= COIN_IDLE; @(posedge clk);

        #20;

        // 4. Scenario 3: Another simple vend (5+5+5+5)
        $display("Test 3: Inserting 5 + 5 + 5 + 5");
        coin <= COIN_5; @(posedge clk); // Total = 5
        coin <= COIN_5; @(posedge clk); // Total = 10
        coin <= COIN_5; @(posedge clk); // Total = 15
        coin <= COIN_5; @(posedge clk); // Total = 20. dispense should pulse now
        coin <= COIN_IDLE; @(posedge clk);

        // End simulation
        #50;
        $display("Testbench finished.");
        $finish;
    end

endmodule
