module testbench;
    reg  [3:0] A, B;
    wire       equal;

    four_bit_comparator uut (
        .A(A),
        .B(B),
        .equal(equal)
    );

    initial begin
        $display("A    B    | Equal");
        $monitor("%b %b |   %b", A, B, equal);

        A = 4'b0001; B = 4'b0000; #10;


        $finish;
    end
endmodule
