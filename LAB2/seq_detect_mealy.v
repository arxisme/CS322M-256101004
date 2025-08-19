module seq_detect_mealy(
    input  wire clk,
    input  wire rst,
    input  wire din,
    output wire y    // The output wire
);

// State encoding
localparam S0 = 2'b00, S1 = 2'b01, S2 = 2'b10, S3 = 2'b11;

// Internal state register
reg [1:0] current_state, next_state;

// Internal register for the combinational output
reg y_reg;

// Continuous assignment to drive the output wire from the internal register
assign y = y_reg;

// Sequential logic for state transitions
always @(posedge clk) begin
    if (rst) begin
        current_state <= S0;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic for next state and Mealy output
always @(*) begin
    next_state = current_state; // Default to stay in the same state
    y_reg = 1'b0; // Default output is 0

    case(current_state)
        S0: begin
            if (din) begin
                next_state = S1;
            end
        end
        S1: begin
            if (din) begin
                next_state = S2;
            end else begin
                next_state = S0;
            end
        end
        S2: begin
            if (din) begin
                next_state = S2;
            end else begin
                next_state = S3;
            end
        end
        S3: begin
            if (din) begin
                next_state = S2;
                y_reg = 1'b1; // Assign to the internal register
            end else begin
                next_state = S0;
            end
        end
        default: begin
            next_state = S0;
        end
    endcase
end

endmodule
