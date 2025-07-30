module testbench;
    reg A, B;
    wire o1, o2, o3;

    one_bit_comparator uut (
        .A(A),
        .B(B),
        .o1(o1),
        .o2(o2),
        .o3(o3)
    );

    initial begin
        $display("A B | o1 o2 o3");
        $monitor("%b %b |  %b  %b  %b", A, B, o1, o2, o3);

        A = 0; B = 0; #10;
        A = 0; B = 1; #10;
        A = 1; B = 0; #10;
        A = 1; B = 1; #10;

        $finish;
    end
endmodule
