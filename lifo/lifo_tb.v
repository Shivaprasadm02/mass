`include "lifo.v"
module lifo_tb;
reg clk,rstn,we,re;
wire empty,full;
reg [7:0]data_in;
wire[7:0] data_out;

lifo DUT(clk,rstn,we,re,data_in,empty,full,data_out);

always #5 clk = ~(clk);

task initialize();
begin 
clk = 1'b0;
rstn = 1'b0;
//we = 1'b0;
//re = 1'b0;
end
endtask

task rstn_dut;
begin
@(negedge clk);
rstn = 1'b0;
@(negedge clk);
rstn=1'b1;
end
endtask

task write_lifo(input [7:0]din);
begin
@(negedge clk)
we = 1'b1;
re = 1'b0;
data_in = din;
$display($time, " data_in=%d  , we=%d, re=%d , full=%d, empty=%d",data_in, we , re, full,empty);
end
endtask

task read_lifo;
begin
@(negedge clk)
we = 1'b0;
re = 1'b1;
$display($time,"data_out=%d , we=%d, re=%d, full=%d,empty=%d",data_out, we , re,full,empty);
end
endtask

initial
begin
initialize;
#5;
rstn_dut;
repeat(10)
write_lifo({$random}%8);
we = 1'b0;
#50;
repeat(10)
read_lifo;
re = 1'b0;
end

initial
	#1000 $finish;
endmodule
