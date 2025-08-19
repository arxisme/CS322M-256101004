module slave_fsm(
    input  wire        clk,
    input  wire        rst,
    input  wire        req,
    input  wire [7:0]  data_in,
    output wire        ack,
    output wire [7:0]  last_byte // observable for TB
);
    // FSM State Definitions
    parameter S_IDLE  = 2'b00;
    parameter S_ACK_1 = 2'b01; // First cycle of ACK hold
    parameter S_ACK_2 = 2'b10; // Second cycle of ACK hold

    // Internal Registers
    reg [1:0] current_state, next_state;
    reg [7:0] latched_data;
    reg ack_reg;

    assign ack = ack_reg;
    assign last_byte = latched_data;

    // Sequential Block: State Register
    always @(posedge clk) begin
        if (rst) begin
            current_state <= S_IDLE;
            latched_data  <= 8'h00;
        end else begin
            current_state <= next_state;
            // Latch data on the rising edge of req
            if (current_state == S_IDLE && req) begin
                latched_data <= data_in;
            end
        end
    end

    // Combinational Block: Next State and Output Logic
    always @(*) begin
        next_state = current_state;
        ack_reg = 1'b0;

        case (current_state)
            S_IDLE: begin
                if (req) begin
                    ack_reg = 1'b1;
                    next_state = S_ACK_1;
                end
            end
            S_ACK_1: begin // 1st cycle holding ACK
                ack_reg = 1'b1;
                next_state = S_ACK_2;
            end
            S_ACK_2: begin // 2nd cycle holding ACK
                ack_reg = 1'b1;
                if (!req) begin // Master has seen ACK and dropped REQ
                    next_state = S_IDLE;
                end
            end
            default: next_state = S_IDLE;
        endcase
    end
endmodule
