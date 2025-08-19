module vending_mealy(
    input  wire        clk,
    input  wire        rst,       // sync active-high
    input  wire [1:0]  coin,      // 01=5, 10=10, 00=idle
    output wire        dispense,  // 1-cycle pulse
    output wire        chg5       // 1-cycle pulse when returning 5
);

    // Define states for totals 0, 5, 10, 15
    parameter S_0  = 2'b00;
    parameter S_5  = 2'b01;
    parameter S_10 = 2'b10;
    parameter S_15 = 2'b11;

    // Define coin values for readability
    parameter COIN_IDLE = 2'b00;
    parameter COIN_5    = 2'b01;
    parameter COIN_10   = 2'b10;

    // State registers
    reg [1:0] current_state, next_state;

    // Mealy outputs must be registered to be set in the combinational block
    reg dispense_reg, chg5_reg;
    assign dispense = dispense_reg;
    assign chg5 = chg5_reg;

    // 1. Sequential Logic: State Register
    // This block handles state transitions on the clock edge and synchronous reset.
    always @(posedge clk) begin
        if (rst) begin
            current_state <= S_0;
        end else begin
            current_state <= next_state;
        end
    end

    // 2. Combinational Logic: Next State and Mealy Outputs
    // This block determines the next state and outputs based on the
    // current state AND the current inputs.
    always @(*) begin
        // Default assignments to avoid latches and define default behavior
        next_state = current_state;
        dispense_reg = 1'b0;
        chg5_reg = 1'b0;

        case (current_state)
            S_0: begin
                if (coin == COIN_5)       next_state = S_5;
                else if (coin == COIN_10) next_state = S_10;
            end
            S_5: begin
                if (coin == COIN_5)       next_state = S_10;
                else if (coin == COIN_10) next_state = S_15;
            end
            S_10: begin
                if (coin == COIN_5)       next_state = S_15;
                else if (coin == COIN_10) begin
                    next_state = S_0;
                    dispense_reg = 1'b1; // Output depends on input
                end
            end
            S_15: begin
                if (coin == COIN_5) begin
                    next_state = S_0;
                    dispense_reg = 1'b1; // Output depends on input
                end else if (coin == COIN_10) begin
                    next_state = S_0;
                    dispense_reg = 1'b1; // Output depends on input
                    chg5_reg = 1'b1;     // and this one too
                end
            end
            default: begin
                next_state = S_0;
            end
        endcase
    end

endmodule
