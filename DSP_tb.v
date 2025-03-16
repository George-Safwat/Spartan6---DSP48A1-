module DSP_tb();
parameter A0REG=0,B0REG=0,A1REG=1,B1REG=1,CREG=1, DREG=1, MREG=1, 
PREG=1, CARRYINREG=1,CARRYOUTREG=1,OPMODEREG=1,
CARRYINSEL="OPMODE5",B_INPUT="DIRECT",RSTTYPE="SYNC";

reg CARRYIN,clk,cea,ceb,cec,cecarryin,
ced,cem,ceopmode,cep,rsta,rstb,rstc,rstcarryin,
rstd,rstm,rstopmode,rstp;

reg [7:0]opmode;
reg [17:0]A,B,D;
reg [47:0]C,PCIN;
reg [17:0]BCIN;

wire [47:0]P,PCOUT;
wire [35:0]M;
wire CARRYOUT;
wire CARRYOUTF;
wire [17:0]BCOUT;


DSP DSP_test(.A(A),.B(B),.C(C),.D(D),.CARRYIN(CARRYIN),.M(M),.P(P),.CARRYOUT(CARRYOUT),
.CARRYOUTF(CARRYOUTF),.clk(clk),.opmode(opmode),.cea(cea),.ceb(ceb),.cec(cec),.cecarryin(cecarryin),
.ced(ced),.cem(cem),.ceopmode(ceopmode),.cep(cep),.rsta(rsta),.rstb(rstb),.rstc(rstc),.rstcarryin(rstcarryin),
.rstd(rstd),.rstm(rstm),.rstopmode(rstopmode),.rstp(rstp),.BCOUT(BCOUT),.PCIN(PCIN),.PCOUT(PCOUT));

initial begin
clk=1;
forever #1 clk=~clk;
end

integer i;
initial begin
//Test reset
rsta=1;
rstb=1;
rstc=1;
rstcarryin=1;
rstd=1;
rstm=1;
rstopmode=1;
rstp=1;

cea=0;
ceb=0;
cec=0;
cecarryin=0;
ced=0;
cem=0;
ceopmode=0;
cep=0;


A=$random;
B=$random;
C=$random;
D=$random;
opmode=$random;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);

if(P!=0)begin
$display("Error in Design");
$stop;
end

rsta=0;
rstb=0;
rstc=0;
rstcarryin=0;
rstd=0;
rstm=0;
rstopmode=0;
rstp=0;

cea=1;
ceb=1;
cec=1;
cecarryin=1;
ced=1;
cem=1;
ceopmode=1;
cep=1;

for(i=0;i<10;i=i+1)begin
//test addition
A=$urandom_range(0,1000);
B=$urandom_range(0,1000);
C=$urandom_range(0,1000);
D=$urandom_range(0,1000);
opmode=8'b00111101;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);



//test subtraction
A=$urandom_range(0,1000);
B=$urandom_range(0,1000);
C=$urandom_range(0,1000);
D=$urandom_range(0,1000);
opmode=8'b11111101;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);

//test subtraction then addition

A=$urandom_range(0,1000);
B=$urandom_range(0,1000);
C=$urandom_range(0,1000);
D=$urandom_range(0,1000);
opmode=8'b01111101;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);

//test addition then subtraction 
A=$urandom_range(0,1000);
B=$urandom_range(0,1000);
C=$urandom_range(0,1000);
D=$urandom_range(0,1000);
opmode=8'b10111101;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);

//Test all cases
A=$random;
B=$random;
C=$random;
D=$random;
opmode=$random;
CARRYIN=$random;
BCIN=$random;
PCIN=$random; 
repeat (7) @(negedge clk);


end
$stop;

end
initial begin 
    $monitor("A=%d,B=%d,BCOUT=%d,C=%d,D=%d,opmode=%b,P=%d,PCOUT=%d,CARRYOUT=%d,CARRYOUTF=%d",A,B,C,D,BCOUT,opmode,P,PCOUT,CARRYOUT,CARRYOUTF,);
end
endmodule
