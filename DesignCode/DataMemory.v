`timescale 1ns / 10ps

module DataMemory(
	input clk, memRead, memWrite,
	input [1:0] mem_mode,
	input [31:0] addr,
	input [31:0] wdata,
	output reg [31:0] rdata,
	output reg [31:0] tag
);

parameter Byte = 2'b00;
parameter HalfWord = 2'b01;
parameter Word = 2'b10;

reg [7:0] data_mem [40:0];

initial
begin
	//Initializing Data Memory
	$readmemh("DataMem.mem", data_mem); 
end
//Synchronous Write
always@(posedge clk)
begin  
	if(memWrite)
	begin
	   case(mem_mode)
	       Byte: 
	       begin
	           data_mem[addr] <= wdata[7:0];
	       end
	       HalfWord: 
	       begin
	           data_mem[addr] <= wdata[7:0];
	           data_mem[addr+1] <= wdata[15:8];
	       end
	       Word: 
	       begin
	           data_mem[addr] <= wdata[7:0];
               data_mem[addr+1] <= wdata[15:8];
               data_mem[addr+2] <= wdata[23:16];
               data_mem[addr+3] <= wdata[31:24];
	       end
	   endcase
	end
end

//Asynchronuous Read
always@(*)
begin
    if(memRead)
	begin
	   case(mem_mode)
	       Byte: 
	       begin
	            rdata <= $signed(data_mem[addr]);
	       end
	       HalfWord: 
	       begin
	            rdata <= $signed({data_mem[addr+1], data_mem[addr]});
	       end
	       Word: 
	       begin
	            rdata <= $signed({data_mem[addr+3], data_mem[addr+2], data_mem[addr+1], data_mem[addr]});
	       end
	   endcase
	end
end  

always@(*)
begin
    tag <= {data_mem[3], data_mem[2], data_mem[1], data_mem[0]};
end

endmodule