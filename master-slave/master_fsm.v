module master_fsm(
    input  wire        clk,
    input  wire        rst,
    input  wire        ack,
    output wire        req,
    output wire [7:0]  data,
    output wire        done
);

    // FSM State Definitions
    parameter M_IDLE          = 3'b000;
    parameter M_DRIVE_DATA    = 3'b001;
    parameter M_WAIT_ACK      = 3'b010;
    parameter M_DROP_REQ      = 3'b011;
    parameter M_WAIT_ACK_LOW  = 3'b100;
    parameter M_DONE          = 3'b101;
    parameter M_FINISHED      = 3'b110; // New state to halt the FSM

    // Internal Registers
    reg [2:0] current_state, next_state;
    reg [1:0] byte_index; // Counts from 0 to 3 for 4 bytes

    // Outputs must be registered to be controlled by the FSM
    reg req_reg;
    reg [7:0] data_reg;
    reg done_reg;

    assign req = req_reg;
    assign data = data_reg;
    assign done = done_reg;

    // Sequential Block: State and Counter Register
    always @(posedge clk) begin
        if (rst) begin
            current_state <= M_IDLE;
            byte_index    <= 2'b00;
        end else begin
            current_state <= next_state;
            // Increment byte counter only when a handshake completes
            if (current_state == M_WAIT_ACK_LOW && !ack) begin
                byte_index <= byte_index + 1;
            end
        end
    end

    // Combinational Block: Next State and Output Logic
    always @(*) begin
        // Default assignments
        next_state = current_state;
        req_reg    = 1'b0;
        data_reg   = 8'hA0 + byte_index; // Example data: A0, A1, A2, A3
        done_reg   = 1'b0;

        case (current_state)
            M_IDLE: begin
                // Automatically start the transfer after reset
                next_state = M_DRIVE_DATA;
            end
            M_DRIVE_DATA: begin
                req_reg = 1'b1;
                next_state = M_WAIT_ACK;
            end
            M_WAIT_ACK: begin
                req_reg = 1'b1;
                if (ack) begin
                    next_state = M_DROP_REQ;
                end
            end
            M_DROP_REQ: begin
                req_reg = 1'b0; // Drop req
                next_state = M_WAIT_ACK_LOW;
            end
            M_WAIT_ACK_LOW: begin
                req_reg = 1'b0;
                if (!ack) begin // Handshake complete
                    if (byte_index == 3) begin
                        next_state = M_DONE;
                    end else begin
                        next_state = M_DRIVE_DATA;
                    end
                end
            end
            M_DONE: begin
                done_reg = 1'b1;
                next_state = M_FINISHED; // Go to the finished state
            end
            M_FINISHED: begin
                // Stay here after the transfer is complete
                next_state = M_FINISHED;
            end
            default: next_state = M_IDLE;
        endcase
    end
endmodule
