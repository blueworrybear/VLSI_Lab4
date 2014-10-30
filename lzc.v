module LZC(
    input wire CLK,
    input wire RST_N,
    input wire MODE,
    input wire [7:0] DATA,
    input wire IVALID,
    output reg [5:0] ZEROS,
    output reg OVALID
);
    
parameter [1:0] IDLE = 2'b00;
parameter [1:0] CALC = 2'b01;
parameter [1:0] FINISH = 2'b10;

reg [2:0] time_cnt;
reg [1:0] state;
reg found;

function [5:0] zeros_cnt;
input[7:0] data;
begin
	if (data[7:0] == 0) begin
     	zeros_cnt = 6'd8;
    end else if (data[7:1] == 0) begin
     	zeros_cnt = 6'd7;
	end else if (data[7:2] == 0) begin
	    zeros_cnt = 6'd6;
    end else if (data[7:3] == 0) begin
        zeros_cnt = 6'd5;
    end else if (data[7:4] == 0) begin
        zeros_cnt = 6'd4;
    end else if (data[7:5] == 0) begin
        zeros_cnt = 6'd3;
    end else if (data[7:6] == 0) begin
        zeros_cnt = 6'd2;
    end else if (data[7] == 0) begin
        zeros_cnt = 6'd1;
    end else begin
        zeros_cnt = 6'd0;
    end
end
endfunction

always @(posedge CLK or negedge RST_N) begin
    if(RST_N == 1'b0) begin
		state = IDLE;
        ZEROS = 6'd0;
        time_cnt = 3'd0;
        OVALID = 1'b0;
        found = 1'b0;
	end else begin
		case (state)
        	IDLE : begin
            	OVALID = 1'b0;
            	if (IVALID) begin
                    ZEROS = zeros_cnt(DATA);
                    time_cnt = 3'd0;
                	state = CALC;
                    if (DATA != 8'd0) begin
                        found = 1'b1;
                    end else begin
                        found = 1'b0;    
                    end
            	end else begin
					state = IDLE;
				end
        	end
            CALC : begin
                if (IVALID == 1'b1) begin
                    time_cnt = time_cnt + 1;

                    if (found == 1'b0)begin
                       ZEROS = ZEROS + zeros_cnt(DATA); 
                    end

                    if (DATA != 8'd0) begin
                        found = 1'b1;
                    end

                    if (MODE == 1'b0) begin
                        if (time_cnt == 3'd3) begin
                            state = FINISH;
                        end else begin
                            state = CALC;
                        end
                    end else begin
                        if (time_cnt == 3'd3 | DATA != 8'd0) begin
                            state = FINISH;
                        end else begin
                            state = CALC;
                        end
                    end
                end else begin
                    state <= CALC;
                end
            end
            FINISH: begin
    			OVALID = 1'b1;
    			state = IDLE;
    		end
    		default: begin
    			OVALID = 1'b0;
    			state = IDLE;
            end
        endcase
    end
end
endmodule
