module link_top(
    input  wire clk,
    input  wire rst,
    output wire done
);

    // Internal wires for handshake and data
    wire        req;
    wire        ack;
    wire [7:0]  data;
    wire [7:0]  last_byte_received; // For observation/debug if needed

    // Instantiate Master FSM
    master_fsm master_inst (
        .clk(clk),
        .rst(rst),
        .ack(ack),
        .req(req),
        .data(data),
        .done(done)
    );

    // Instantiate Slave FSM
    slave_fsm slave_inst (
        .clk(clk),
        .rst(rst),
        .req(req),
        .data_in(data),
        .ack(ack),
        .last_byte(last_byte_received)
    );

endmodule
