
module tb_final();

  // Inputs
  reg s0, s1;
  reg [3:0] a, b;

  // Outputs
  wire [3:0] sum;  //full adder sum 
  wire carry;  // full adder carry 
  wire [3:0] y_and;   //and part 
  wire [2:0] y;  //comp -part 
  wire [3:0] d;   //decoder 
  wire [3:0] a_f,b_f,a1_f,b1_f,a2_f,b2_f,a3_f,b3_f;   //new - fed inputs 


  // Instantiate the final module
  final uut (
    .s0(s0),.s1(s1),.a(a),.b(b),.sum(sum),.carry(carry),.y(y),.y_and(y_and)
  )
  ; 

    initial begin

    $dumpfile("dump.vcd"); /* to dump the change the in the values of a register and wires */
    $dumpvars(0,tb_final) ; /* (level , module name) */
    
end




  // Clock generation
  reg clk = 0;
  always #5 clk = ~clk;

  // Test vectors
  initial begin

  // Test case 1: Addition (1 + 2)
    s0 = 1'b0;
    s1 = 1'b0;
    a = 4'b0001;
    b = 4'b0001;
    #10;
    $display("ADD block is on ");
    $display("Test case 1: %b + %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 1: a = %b, b = %b, a<b =%b ,a>b = %b , a=b = %b", a, b, y[0],y[1],y[2]);
    $display("Test case 1: a = %b, b = %b, y_and = %b\n\n", a, b, y_and);



  // $display("Test case 3: a = %b, b = %b, a<b =%b ,a>b = %b , a=b = %b ", a, b, y[0],y[1],y[2]);
    
 // Test case 2: Subtraction (3 - 2)
    s0 = 1'b1;
    s1 = 1'b0;
    a = 4'b1111;
    b = 4'b1101;
    #10;

    $display("SUB block is on ");
    $display("Test case 2: %b - %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 2: a = %b, b = %b, a<b =%b ,a>b = %b , a=b = %b", a, b, y[0],y[1],y[2]);
    $display("Test case 2: a = %b, b = %b, y_and = %b\n\n", a, b, y_and);


  // Test case 3: Comparison (4 == 4)
    s0 = 1'b0;
    s1 = 1'b1;
    a = 4'b0110;
    b = 4'b0111;
    #10;

    $display("COMP block is on ");
    $display("Test case 3: %b + %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 3: %b - %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 3: a = %b, b = %b, a<b =%b ,a>b = %b , a=b = %b", a, b, y[0],y[1],y[2]);
    $display("Test case 3: a = %b, b = %b, y_and = %b\n\n", a, b, y_and);

    // Test case 4 : Anding 
    s0 = 1'b1;
    s1 = 1'b1;
    a = 4'b0111;
    b = 4'b0110;
    #10;

 
    $display("AND block is on ");
    $display("Test case 4: %b + %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 4: %b - %b = %b (Carry: %b)", a, b, sum, carry);
    $display("Test case 4: a = %b, b = %b, a<b =%b ,a>b = %b , a=b = %b", a, b, y[0],y[1],y[2]);
    $display("Test case 4: a = %b, b = %b, y_and = %b\n\n", a, b, y_and);

    $finish;
  end

endmodule
