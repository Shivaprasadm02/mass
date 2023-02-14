module lifo(clock,resetn,write_en,read_en,data_in,empty,full,data_out);

input clock,resetn,write_en,read_en;
input [7:0]data_in;
output empty,full;
output reg [7:0]data_out;

reg[4:0] pt=4'b0;
reg[4:0] fifo_counter;
reg[7:0]memory[15:0];
integer i;

assign empty = (fifo_counter == 5'b00000) ? 1'b1:1'b0;
assign full = (fifo_counter == 5'b10000) ? 1'b1:1'b0;

//write logic
always @(posedge clock)
begin
if(!resetn)
begin
for(i=0;i<16;i=i+1)
begin
	memory[i] = 0;
	pt =4'b0;
end
end
else if ((write_en == 1'b1) &&(full == 1'b0))
begin
$display("wr_pt=%d", pt);
memory[pt]<=data_in;
pt <= pt +1'b1;
$monitor("inc_pt=%d", pt);
end
else
pt = pt;
end

//read logic
always@(posedge clock)
begin
if(!resetn)
begin
pt =4'b0;
data_out =8'b0;
end
else if((read_en == 1'b1) && (empty == 1'b0))
//else if(read_en == 1'b1) 
begin
$display("rd_pt=%d", pt);
data_out <= memory[pt];
pt <= pt - 1'b1;
$monitor("dec_pt=%d", pt);
end
else
pt = pt;
end

//counter logic
always@(posedge clock)
begin
if(!resetn)
fifo_counter <=0;
else if((!(full)) && (write_en))
fifo_counter <= fifo_counter + 1;
else if((!(empty)) && read_en)
fifo_counter <= fifo_counter -1;
else
fifo_counter <=fifo_counter;
end
endmodule


/*
assign empty = (pt == 5'b00001) ? 1'b1:1'b0;
assign full = (pt > 5'b01111) ? 1'b1:1'b0;
*/
/*
always @(posedge clock)
begin
if(!resetn)
begin
data_out <=8'b0;
pt <=1;
for(i=0;i<16;i=i+1)
begin
	memory[i] <= 0;
end
end
else if ((write_en == 1'b1) &&(full == 1'b0))
begin
$monitor("pt=%d",pt);
memory[pt]<=data_in;
$monitor("mem=%d",memory[pt]);
pt <=pt +1;
end
else if((read_en == 1'b1) && (empty == 1'b0))
begin
pt <= pt - 1;
$monitor("pt=%d",pt);
data_out <= memory[pt];
end
end
endmodule 
*/