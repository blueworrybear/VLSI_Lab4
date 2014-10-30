module stimulus;
	parameter cyc = 10;
    parameter delay = 1;
    
    //declare module
    reg clk, rst_n, ivalid,mode;
	reg [7:0] data;
	wire ovalid;
	wire [5:0] zeros;
    
    LZC lzc01(
        .CLK(clk),
        .RST_N(rst_n),
        .MODE(mode),
        .DATA(data),
        .IVALID(ivalid),
        .ZEROS(zeros),
        .OVALID(ovalid));
    
    //end declare module
    always #(cyc/2) clk = ~clk;
    
    initial begin
		$fsdbDumpfile("lzc.fsdb");
		$fsdbDumpvars;

		$monitor($time, " CLK=%b RST_N=%b IVALID=%b DATA=%h MODE=%b | OVALID=%b ZEROS=%d", clk, rst_n, ivalid, data, mode, ovalid, zeros);
	end
    
    initial begin
        clk = 1;
		rst_n = 1;
		#(cyc);
		#(cyc) rst_n = 0;
		#(cyc*4) rst_n = 1;
		#(cyc*2);

		#(cyc) nop;
        
        //case 1
        //input: 0000,0000 mode: normal
        #(cyc) load; mode_select(1); data_in(8'hF0);
		#(cyc) data_in(8'h00);
        #(cyc) data_in(8'h00);
        #(cyc) data_in(8'h00);
		#(cyc) nop;
		#(cyc*2);
        
        //case 2
        //input: 0800,0FFF mode: normal
        #(cyc) load; mode_select(0); data_in(8'h08);
		#(cyc) data_in(8'h00);
        #(cyc) data_in(8'h0F);
        #(cyc) data_in(8'hFF);
		#(cyc) nop;
        #(cyc*2)
        
		//case 3
        //input: 0800,0FFF mode: normal
		//interrupt
        #(cyc) load; mode_select(0); data_in(8'h08);
		#(cyc) nop;
		#(cyc) load; data_in(8'h00);
        #(cyc) data_in(8'h0F);
        #(cyc) data_in(8'hFF);
		#(cyc) nop;
        #(cyc*2)

        
        #(cyc) nop;
		#(cyc*8);
		$finish;
    end
    
    task nop;
		begin
			ivalid = 0;
		end
	endtask
	task load;
		begin
			ivalid = 1;
		end
	endtask
	task data_in;
		input [7:0] data1;
		begin
			data = data1;
		end
	endtask
    task mode_select;
		input [0:0] m;
		begin
			mode = m;
		end
	endtask
endmodule
