module Mux_Reg(in,clk,out,rst,CE,sel);
parameter input_size=18,RSTTYPE="SYNC";
input [input_size-1:0]in;
input clk,rst,CE,sel;
output [input_size-1:0] out;
reg [input_size-1:0]regs;

assign out= (sel==1)?  regs:in;

generate 
    if(RSTTYPE=="SYNC")begin
always @(posedge clk) begin
      if(rst)
regs<=0;
else begin
    if(CE)
regs<=in;
end
end
    end
else begin
if(RSTTYPE=="ASYNC")begin
always @(posedge clk or posedge rst) begin
    if(rst)
regs<=0;
else begin
    if(CE)
regs<=in;
end
    end
end
end

endgenerate
endmodule


module Muxb(in0,in1,b0);
parameter sel="Direct";
input [17:0]in0;
input [17:0]in1;
output [17:0]b0;                      //Input B
assign b0= (sel=="Direct")?  in0:(sel=="CASCADE")? in1:0;
endmodule


module mux2(sel,in0,in1,out);
input [17:0] in0,in1;  //in0=pre   in1=b0_out
input sel;
output [17:0] out;              //opmode[4]
assign out=(sel==0)? in1:in0;
endmodule

module mux_cin(in0,in1,out);
parameter sel="OPMODE5";
input in0,in1;
output out;              //opmode[5]
assign out=(sel=="OPMODE5")? in0:in1;
endmodule

module mux4(in0,in1,in2,in3,out,sel);  
input [47:0]in0,in1,in2;
input [1:0]sel;      //for Mux Z
output [47:0]out;        
input in3;
assign out=(sel==0)? in3:(sel==1)? in2:(sel==2)? in1:in0; 
endmodule

module mux4_x(in0,in1,in2,in3,out,sel);  
input [47:0]in0,in1;
input [35:0]in2;
input [1:0]sel;               //for Mux X
output [47:0]out;
input in3;
assign out=(sel==0)? in3:(sel==1)? in2:(sel==2)? in1:in0; 
endmodule
