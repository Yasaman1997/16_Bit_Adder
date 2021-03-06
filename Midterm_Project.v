`timescale 1ns/1ns

module FA(S,CO,A,B,Cin);
  input A,B,Cin;
  output S,CO;
  wire [2:0]l;
  
  xor #2 u1(S,A,B,Cin);
  xor #2 u2(l[0],A,B);
  and #2 u3(l[1],Cin,l[0]);
  and #2 u4(l[2],A,B);
  or  #2 u5(CO,l[1],l[2]);
  
endmodule



`timescale 1ns/1ns
module CLA(S[3:0],Cout,A[3:0],B[3:0],Cin);
input [3:0]A,B;
input Cin;
wire [3:0]P,G;
wire [9:0]M;
wire [3:1]C;
output [3:0]S;
output Cout;

  xor #2 (P[0],A[0],B[0]);
 xor #2(P[1],A[1],B[1]);
 xor #2(P[2],A[2],B[2]);
 xor #2(P[3],A[3],B[3]);    
 and #2(G[0],A[0],B[0]);
 and #2(G[1],A[1],B[1]);
 and #2(G[2],A[2],B[2]);
 and #2(G[3],A[3],B[3]);
 

 and #2 (M[0],P[0],Cin);
 or #2 (C[1],G[0],M[0]);  
 
 and #3 (M[1],P[1],P[0],Cin);
 and #2 (M[2],P[1],G[0]);
 or #3(C[2],G[1],M[1],M[2]);

 and #2(M[3],G[1],P[2]);
 and #3(M[4],P[2],P[1],G[0]);
 and #4(M[5],P[2],P[1],P[0],Cin);
 or #4 (C[3],G[2],M[3],M[4],M[5]);
 
 and #2 (M[6],P[3],G[2]);
 and #3 (M[7],P[3],P[2],G[1]);
 and #4 (M[8],P[3],P[2],P[1],G[0]);
 and #5 (M[9],P[3],P[2],P[1],P[0],Cin);
 or #5 (Cout,G[3],M[6],M[7],M[8],M[9]);

   
 xor #2 (S[0],P[0],Cin);
 xor #2 (S[1],P[1],C[1]);   
 xor #2(S[2],P[2],C[2]); 
 xor #2 (S[3],P[3],C[3]);   
 
    endmodule


`timescale 1ns/1ns

module Adder1(Cout,S,A,B,Cin);
 
 
  input [15:0]A;
  input [15:0]B;
  input Cin;
  wire [14:0]C;
  output Cout;
  output[15:0]S;
  
  
FA f1(S[0],C[0],A[0],B[0],Cin);

FA f2(S[1],C[1],A[1],B[1],C[0]);

FA f3(S[2],C[2],A[2],B[2],C[1]);

FA f4(S[3],C[3],A[3],B[3],C[2]);
  
FA f5(S[4],C[4],A[4],B[4],C[3]);
FA f6(S[5],C[5],A[5],B[5],C[4]);
FA f7(S[6],C[6],A[6],B[6],C[5]);
  
FA f8(S[7],C[7],A[7],B[7],C[6]);
  
FA f9(S[8],C[8],A[8],B[8],C[7]);
  
FA f10(S[9],C[9],A[9],B[9],C[8]);
  
FA f11(S[10],C[10],A[10],B[10],C[9]);
  
FA f12(S[11],C[11],A[11],B[11],C[10]);
  
FA f13(S[12],C[12],A[12],B[12],C[11]);
  
FA f14(S[13],C[13],A[13],B[13],C[12]);

FA f15(S[14],C[14],A[14],B[14],C[13]);
  
FA f16(S[15],Cout,A[15],B[15],C[14]);

endmodule





`timescale 1ns/1ns

module Adder2(Cout,S[15:0],A[15:0],B[15:0],Cin);
  
  input [15:0]A;
  input [15:0]B;
  input Cin;
  
  wire [2:0]C;
  
  output Cout;
  output[15:0]S;
  
CLA CLA1 (S [3:0],C[0],A[3:0],B[3:0],Cin);
CLA CLA2 (S[7:4],C[1],A[7:4],B[7:4],C[0]);
CLA CLA3 (S[11:8],C[2],A[11:8],B[11:8],C[1]);
CLA CLA4 (S[15:12],Cout,A[15:12],B[15:12],C[2]);

endmodule










//test bench
`timescale 1ns/1ns
module Adder16_TB();
  reg [15:0]A;
  reg [15:0]B;
  reg Cin=0;
  wire Cout1,Cout2;
  wire [15:0]S;
  wire [15:0]p;
  
Adder1 g1(Cout1,S,A,B,Cin);
Adder2 g2(Cout2,p,A,B,Cin);

initial 
begin
  
  #1
   A=0;
   B=0;
   
  #199

  A=16'b10010011010111;//9431
  B=16'b00001111111110;//1022
  //A=16'd9431;
 // B=16'd1022;


  #200
  A=16'b0000001111111110;
  B=16'b1111110111101000;  //65000
   //B=16'd1022;
  // A=16'd65000;


  #200 $finish;    
  end
  initial 
  $monitor("A=%b B=%b p=%b S=%b Cout1=%b Cout2=%b",A,B,Cin,S,p,Cout1,Cout2);
  
endmodule




