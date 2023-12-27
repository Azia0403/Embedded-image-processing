`timescale 1ns / 1ps

module pinpong(clk,reset,led,btn_left,btn_right);
	input clk,reset,btn_right,btn_left;
	output reg [7:0]led;
	wire div_clk;
	reg[1:0] state,last_state; //00:L_win 01:R_win 10:R_move 11:L_move
	division_clk division_clk1(div_clk,clk,reset);

	always @(posedge clk or	posedge reset) begin //FSM
		if(reset)
			state<=2'b00;
		else begin
			case(state)
				2'b00: begin
				  if (btn_left) begin
					 state <= 2'b10; // STAR L
				  end
				end
				2'b01: begin
				  if (btn_right) begin
					 state <= 2'b11; // STAR R
				  end
				end
				2'b10: begin
					if (~btn_right && led == 8'd0) begin
						state <= 2'b00; // R loss
					end
					else if (btn_right && led != 8'd00000001) begin
						state <= 2'b00; // R early
					end
					else if (btn_right && led == 8'd00000001)
						state <= 2'b11; // R hit
					end
				2'b11: begin
				  if (~btn_left && led == 8'd0) begin
					 state <= 2'b01; // L loss
				  end
				  else if (btn_left && led != 8'b10000000) begin
					 state <= 2'b01; // L early
				  end
				  else if (btn_left && led == 8'b10000000) begin
					 state <= 2'b10; // L hit
				  end
				end
				default: begin
				  state <= state; // Default case
				end
		 endcase
			
		end
	end
	
	always @(posedge div_clk or	posedge reset) begin //LEDMOVE &prestate
		if (reset) begin
			led <= 8'b10000000;// start 8'b10000000
		    last_state<=state;
		end
		else begin
			case(state)
				2'b00: begin
				    if(last_state==2'b10)
				        led<=8'b11110000;
				end
				2'b01: begin
					if(last_state==2'b11)
				        led<=8'b00001111;
				end
				2'b10: begin
				    if (led==8'b11110000)
				        led<=8'b10000000;
					else if (led == 8'b00000001)
						led <= 8'b00000000;
					else
						led <= {led[0], led[7:1]};
				end
				2'b11: begin
				   if (led==8'b00001111)
				        led<=8'b00000001;
				   else if (led == 8'b10000000)
						led <= 8'b00000000;
					else
						led <= {led[6:0], led[7]};
				end
				default: begin
				  led <=led; // Default case
				end
			endcase
			last_state<=state;
		end
	end

		

endmodule


module division_clk(out_clk,in_clk,reset);
	output reg out_clk;
	input in_clk,reset;
	reg[23:0]max,cnt;
	reg [4:0]random;
	//assign out_clk=tmp[0];
	
	always@(posedge in_clk or posedge reset)begin
		if(reset)begin
			max<=24'b011111111111111111111111;
			random<=5'd17;
			cnt<=24'd1;
			out_clk<=1'b0;
		end
		else begin
		    if (cnt==24'd0)begin
		      random[4]<=random[3]^random[0];
		      random[3]<=random[2];
		      random[2]<=random[1]^random[0];
		      random[1]<=random[0];
		      random[0]<=random[4]; 
		    end
            if(cnt<max)begin
		        cnt<=cnt+24'd1;
		    end
		    else begin
		        cnt<=24'd0;
		        max<={random,19'b1111111111111111111};
		        out_clk<=~out_clk;
		    end    
		end
	end
endmodule

