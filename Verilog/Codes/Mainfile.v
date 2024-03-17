  // 0 0 - ADD
  // 0 1 - SUBTRACT 
  // 1 0 - COMPARE
  // 1 1 - AND

  module full_adder(x,y,z,sum,carry);

  input x,y,z;
  output sum,carry;

  wire w1,w2,w3;

  xor x1(w1,x,y);
  and a1(w2,x,y);
  xor x2(sum,w1,z);  //sum part = x + y + z

  and a2(w3,w1,z);
  or o2(carry,w3,w2);

  endmodule


  module add_sub_4b(a,b,M,S,C);

  //Even the negative numbers are handled using 2s complement 

  input [3:0] a,b;
  input M; // sub if M = 1 and add if M = 0 

  output [3:0]S;
  output C;

  wire c1,c2,c3 ; //carries in subsequent stages
  wire x0,x1,x2,x3;
  // and q1(t1,x3,w3);
  // and q2(t2,x3,w4);

  xor r1(x0,b[0],M);
  xor r2(x1,b[1],M);
  xor r3(x2,b[2],M);
  xor r4(x3,b[3],M);

  full_adder u1(x0,a[0],M,S[0],c1);
  full_adder u2(x1,a[1],c1,S[1],c2);
  full_adder u3(x2,a[2],c2,S[2],c3);
  full_adder u4(x3,a[3],c3,S[3],C);  // Final full adder carry = C;


  // and q1(t1,x3,w3);
  // and q2(t2,x3,w4);
  endmodule

  module comp_4bit(a,b,y,en);

  //a<b = y[0], a>b = y[1] , a=b =y[2] 


  input [3:0] a,b;
  output [2:0] y;
  input en;

  //IMPLEMENTATION 1 : USING DSM 

  // No of gates = 29
  // No of transistors = 158 


  wire na0,na1,na2,na3,nb0,nb1,nb2,nb3;

  not n1(na0,a[0]);
  not n2(na1,a[1]);
  not n3(na2,a[2]);
  not n4(na3,a[3]);

  not n5(nb0,b[0]);
  not n6(nb1,b[1]);
  not n7(nb2,b[2]);
  not n8(nb3,b[3]);


  wire w1,w2,w3,w4,w5,w6,w7,w8;

  and a1(w1,na3,b[3]);  //a3'b3 
  and a2(w2,nb3,a[3]);  //a3b3'

  and a3(w3,na2,b[2]);  //a2'b2
  and a4(w4,a[2],nb2);  //a2b2'

  and a5(w5,na1,b[1]);  //a1'b1
  and a6(w6,nb1,a[1]);  //a1b1'

  and a7(w7,na0,b[0]);  //a0'b0
  and a8(w8,nb0,a[0]);  //a0b0'


  wire x3,x2,x1,x0;


  nor k1(x3,w1,w2);   //x3
  nor k2(x2,w3,w4);   //x2
  nor k3(x1,w5,w6);   //x1
  nor k4(x0,w7,w8);   //x0


  wire t1,t2,t3,t4,t5,t6;

  and q1(t1,x3,w3);
  and q2(t2,x3,w4);
  and q3(t3,x3,x2,w5);
  and q4(t4,x3,x2,w6);
  and q5(t5,x3,x2,x1,w7);
  and q6(t6,x3,x2,x1,w8);

  // // A < B
  or a_less_than(y[0],w1,t1,t3,t5);

  // //A > B
  or a_grt_b(y[1],w2,t2,t4,t6);

  // A = B
  nor ne1(o1,y[1],y[0]);
  and a_equal_b(y[2],o1,en);



  endmodule


  module and_4bit(a,b,y);

  input [3:0] a,b;
  output [3:0] y;


  and a1(y[0],a[0],b[0]);
  and a2(y[1],a[1],b[1]);
  and a3(y[2],a[2],b[2]);
  and a4(y[3],a[3],b[3]);


  endmodule


  module decoder (s0,s1,d);

  input s0,s1;
  output [3:0] d;

  not n1(s0c,s0);
  not n2(s1c,s1);

  and a1(d[0],s0c,s1c); //adder 
  and a2(d[1],s1c,s0);  //subtractor 
  and a3(d[2],s1,s0c);  //compare
  and a4(d[3],s1,s0); // And

  endmodule

  module enable_add (d_eff,a,b,a_f,b_f);

  input [3:0] a,b;
  input d_eff;

  output [3:0] a_f,b_f;

  and a1(a_f[0],d_eff,a[0]);
  and a2(a_f[1],d_eff,a[1]);
  and a3(a_f[2],d_eff,a[2]);
  and a4(a_f[3],d_eff,a[3]);

  and a5(b_f[0],d_eff,b[0]);
  and a6(b_f[1],d_eff,b[1]);
  and a7(b_f[2],d_eff,b[2]);
  and a8(b_f[3],d_eff,b[3]);


  endmodule

  module enable_sub (d,a,b,a1_f,b1_f);

  input [3:0] a,b,d;


  output [3:0] a1_f,b1_f;

  and a1(a1_f[0],d[1],a[0]);
  and a2(a1_f[1],d[1],a[1]);
  and a3(a1_f[2],d[1],a[2]);
  and a4(a1_f[3],d[1],a[3]);

  and a5(b1_f[0],d[1],b[0]);
  and a6(b1_f[1],d[1],b[1]);
  and a7(b1_f[2],d[1],b[2]);
  and a8(b1_f[3],d[1],b[3]);

  endmodule


  module enable_comp (d,a,b,a2_f,b2_f);

  input [3:0] a,b,d;

  output [3:0] a2_f,b2_f;

  and a1(a2_f[0],d[2],a[0]);
  and a2(a2_f[1],d[2],a[1]);
  and a3(a2_f[2],d[2],a[2]);
  and a4(a2_f[3],d[2],a[3]);

  and a5(b2_f[0],d[2],b[0]);
  and a6(b2_f[1],d[2],b[1]);
  and a7(b2_f[2],d[2],b[2]);
  and a8(b2_f[3],d[2],b[3]);

  endmodule

  module enable_and (d,a,b,a3_f,b3_f);

  input [3:0] a,b,d;

  output [3:0] a3_f,b3_f;

  and a1(a3_f[0],d[3],a[0]);
  and a2(a3_f[1],d[3],a[1]);
  and a3(a3_f[2],d[3],a[2]);
  and a4(a3_f[3],d[3],a[3]);

  and a5(b3_f[0],d[3],b[0]);
  and a6(b3_f[1],d[3],b[1]);
  and a7(b3_f[2],d[3],b[2]);
  and a8(b3_f[3],d[3],b[3]);

  endmodule


  module final(s0,s1,a,b,sum,carry,y,y_and);

  input s0,s1;
  input [3:0] a,b;
  output [3:0] sum;
  output [3:0] y_and;
  output carry;
  output [2:0] y;  //comp part 


  output [3:0] a_f,b_f,a1_f,b1_f,a2_f,b2_f,a3_f,b3_f,d;


  decoder select(s0,s1,d);

  or d_eff (d_eff,d[0],d[1]); // pass this into the decoder !

  enable_add add1(d_eff,a,b,a_f,b_f);
  enable_comp comp1(d,a,b,a2_f,b2_f);
  enable_and and1(d,a,b,a3_f,b3_f);


  add_sub_4b add(a_f,b_f,d[1],sum,carry);
  comp_4bit comp(a2_f,b2_f,y,d[2]);
  and_4bit and_cir (a3_f,b3_f,y_and);

  endmodule



