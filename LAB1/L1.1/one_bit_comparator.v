module one_bit_comparator (
    input wire A,
    input wire B,
    output wire o1,
    output wire o2,
    output wire o3  
);

assign o1 = A & ~B;
assign o2 = ~(A ^ B);  // A == B
assign o3 = ~A & B;

endmodule
