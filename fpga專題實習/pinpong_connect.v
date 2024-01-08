`timescale 1ns / 1ps

module pinpong_connect(clk,reset,led,btn,data);
    input clk,reset,btn;
	output reg [7:0]led;
	inout data;
	wire div_clk;
	reg[1:0] state,last_state; //00:enemy_win 01:wait 10:to _enemy_move 11:to_self_move
	division_clk division_clk1(div_clk,clk,reset);

	always @(posedge clk or	posedge reset) begin //FSM
		if(reset)
			state<=2'b00;
		else begin
			case(state)
				2'b00: begin
				  if (btn && (led == 8'b10000000 || led == 8'b11110000)) begin
					 state <= 2'b10; // STAR self
				  end
				end
				2'b01: begin //wait
				  if (data==1'b1 && led == 8'b00000000) begin
					 state <= 2'b11; // to_self_move
				  end
				end
				2'b10: begin  //to_enemy_move
					if (led == 8'b00000000) begin
						state <= 2'b01; //wait
					end
				end
				2'b11: begin //to_self_move
				  if (led == 8'd0 &&last_state==2'b11) begin
					 state <= 2'b00; // self loss
				  end
				  else if (btn && led != 8'b10000000 ) begin
					 state <= 2'b00; // self early
				  end
				  else if (btn && led == 8'b10000000 ) begin
					 state <= 2'b10; // self hit
				  end
				  else
				    state<=2'b11;
				end
				default: begin
				  state <= state; // Default case
				end
		 endcase
			
		end
	end
	assign data = (state == 2'b00) ? 1'b0 :
                  ((state == 2'b10) && (led == 8'b00000000)) ? 1'bz :
                  ((state == 2'b10) && (led == 8'b00000001)) ? 1'b1 :
                  (state == 2'b11) ? 1'b0 :
                  (state == 2'b01) ? 1'bz :
                  data;
//    assign data =     ((state == 2'b10) && (led == 8'b00000000)) ? 1'bz :
//                      ((state == 2'b10) && (led == 8'b00000001)) ? 1'b1 :
//                      (state == 2'b01) ? 1'bz :
//                      data;
//	always @(posedge div_clk or	posedge reset) begin //date
//	   if(reset)
//			data<=led[0];
//	   else begin
//	       case(state)
//				2'b00: begin
//                    data<=led[0];
//				end
//				2'b01: begin //wait
//				    if (led==8'b00000000)
//				      data<=1'bz;
//				end
//				2'b10: begin  //to_enemy_move
//					data<=led[0];
//				end
//				2'b11: begin //to_self_move
//				    data<=led[0];
//				end
//				default: begin
//				  data <= data; // Default case
//				end
//		 endcase
//	   end
//	 end
	 
	
	always @(posedge div_clk or	posedge reset) begin //LEDMOVE &prestate
		if (reset) begin
			led <= 8'b10000000;// start 8'b10000000
		    last_state<=state;
		end
		else begin
			case(state)
				2'b00: begin //enemy_win
				    if(last_state==2'b11)
				        led<=8'b00000000;
				    else if(led==8'b00000000 && ~btn)
				        led<=8'b11110000;
				end
				2'b01: begin //wait
				     led<=8'd0;
		         end
				2'b10: begin//to_enemy_move
				    if (led==8'b11110000)
				        led<=8'b10000000;
					else if (led == 8'b00000001)
						led <= 8'b00000000;
					else
						led <= {led[0], led[7:1]};
				end
				2'b11: begin//to_self_move
				   if (last_state==2'b01)
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