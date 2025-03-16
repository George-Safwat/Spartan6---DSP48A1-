module  DSP(A,B,C,D,CARRYIN,M,P,CARRYOUT,
CARRYOUTF,clk,opmode,cea,ceb,cec,cecarryin,
ced,cem,ceopmode,cep,rsta,rstb,rstc,rstcarryin,
rstd,rstm,rstopmode,rstp,BCOUT,PCIN,PCOUT,BCIN);
parameter A0REG=0,B0REG=0,A1REG=1,B1REG=1,CREG=1, DREG=1, MREG=1, 
PREG=1, CARRYINREG=1,CARRYOUTREG=1,OPMODEREG=1,
CARRYINSEL="OPMODE5",B_INPUT="DIRECT",RSTTYPE="SYNC";


input CARRYIN,clk,cea,ceb,cec,cecarryin,
ced,cem,ceopmode,cep,rsta,rstb,rstc,rstcarryin,
rstd,rstm,rstopmode,rstp;
input [7:0]opmode;
input [17:0]A,B,D,BCIN;
input [47:0]C,PCIN;
output [47:0]P,PCOUT;
output [35:0]M;
output reg CARRYOUT;
output CARRYOUTF;
output [17:0]BCOUT;

wire [17:0]a,a1_out,d,b0,b0_out,b1,b1_out;
reg [17:0]pre_add_sub;
reg [48:0]post_add_sub;
wire [35:0]M_out;
reg [35:0]M_in;
wire [47:0]c,z,x;
wire [7:0]opmode_out;
wire cyi,cyi_out,cyo_out;
//Input A
Mux_Reg a0(.in(A),.clk(clk),.out(a),.rst(rsta),.CE(cea),.sel(A0REG));
Mux_Reg a1(.in(a),.clk(clk),.out(a1_out),.rst(rsta),.CE(cea),.sel(A1REG));
//Input B
Muxb B_in(.in0(B),.b0(b0),.in1(BCIN));
Mux_Reg B0(.in(b0),.clk(clk),.out(b0_out),.rst(rstb),.CE(ceb),.sel(B0REG));
mux2 b_in(.sel(opmode_out[4]),.in0(pre_add_sub),.in1(b0_out),.out(b1));
Mux_Reg B1(.in(b1),.clk(clk),.out(b1_out),.rst(rstb),.CE(ceb),.sel(B1REG));
//Input C
Mux_Reg #(.input_size(48))c_in(.in(C),.clk(clk),.out(c),.rst(rstc),.CE(cec),.sel(CREG));
//Input D
Mux_Reg d_in(.in(D),.clk(clk),.out(d),.rst(rstd),.CE(ced),.sel(DREG));
//Output P
Mux_Reg #(.input_size(48))p(.in(post_add_sub),.clk(clk),.out(P),.rst(rstp),.CE(cep),.sel(PREG));
//M
Mux_Reg #(.input_size(36))m(.in(M_in),.clk(clk),.out(M_out),.rst(rstm),.CE(cem),.sel(MREG));
//Opmodes
Mux_Reg #(.input_size(2)) op1(.in(opmode[1:0]),.clk(clk),.out(opmode_out[1:0]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
Mux_Reg #(.input_size(2)) op2(.in(opmode[3:2]),.clk(clk),.out(opmode_out[3:2]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
Mux_Reg #(.input_size(1)) op4(.in(opmode[4]),.clk(clk),.out(opmode_out[4]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
Mux_Reg #(.input_size(1)) op5(.in(opmode[5]),.clk(clk),.out(opmode_out[5]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
Mux_Reg #(.input_size(1)) op6(.in(opmode[6]),.clk(clk),.out(opmode_out[6]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
Mux_Reg #(.input_size(1)) op7(.in(opmode[7]),.clk(clk),.out(opmode_out[7]),.rst(rstopmode),.CE(ceopmode),.sel(OPMODEREG));
//CARRYIN
mux_cin cin(.in0(opmode[5]),.in1(CARRYIN),.out(cyi));
Mux_Reg #(.input_size(1)) CYI(.in(cyi),.clk(clk),.out(cyi_out),.rst(rstcarryin),.CE(ceopmode),.sel(CARRYINREG));
//CARRYOUT
Mux_Reg #(.input_size(1)) CYO(.in(post_add_sub[48]),.clk(clk),.out(cyo_out),.rst(rstcarryin),.CE(ceopmode),.sel(CARRYOUTREG));
//MUX_z
mux4 MUXz(.in0(c),.in1(PCIN),.in2(P),.in3(0),.out(z),.sel(opmode[3:2]));
//MUX_x
mux4_x MUXx(.in0({d[11:0],a1_out,b1_out}),.in1(P),.in2(M_out),.in3(0),.out(x),.sel(opmode[1:0]));

always @(posedge clk) begin  
case({opmode[7],opmode[6]})
2'b00:begin
pre_add_sub= d + b0_out;
M_in= b1_out*a1_out ;
post_add_sub=x+z;
CARRYOUT=cyo_out;
end

2'b01:begin
pre_add_sub=d-b0_out;
M_in=b1_out*a1_out;
post_add_sub=z+x;
CARRYOUT=cyo_out;
end

2'b10:begin
pre_add_sub=d+b0_out;
M_in=b1_out*a1_out;
post_add_sub=z-(x+cyi_out);
CARRYOUT=cyo_out;
end

2'b11:begin
pre_add_sub=d-b0_out;
M_in=b1_out*a1_out;
post_add_sub=z-(x+cyi_out);
CARRYOUT=cyo_out;
end
endcase
    
end
assign BCOUT=b1_out;
assign M=~(~M_out);
assign CARRYOUTF=CARRYOUT;
assign PCOUT=P;

endmodule