`timescale 1ns / 1ps
`define MAX_VALUE 8'd255 //overflow
`define N_MAX 20'd14000  //1/30 s  n*256/100M>1=/30

module breathled(reset,clk,led);
	input clk,reset;
	output reg led;
	reg [1:0]state; //0:cnt_High  1: cnt_Low 2:max change
	reg max_CountUp, change; 
	reg [7:0]cnt_High,cnt_Low,max;
    reg [19:0]n;
	always @(posedge clk or posedge reset) begin //LED
		if(reset)
			led<=1'd0;
		else begin
			if(state==2'd0)
				led<=1'b1;
			else if(state==2'd1)
				led<=1'b0;
			else
				led<=led;
		end
	end
	
	
	always @(posedge clk or posedge reset) begin //FSM
		if(reset)
			state<=2'd0;
		else begin
			if((cnt_High>=max)&&(state==2'd0))
				state<=2'd1;
			else if((cnt_Low>=`MAX_VALUE - max)&&(state==2'd1))
				state<=2'd2;
			else if((change)&&(state==2'd2))
				state<=2'd0;
			else
				state<=state;
				
		end
	end
	always @(posedge clk or posedge reset ) begin//cnt_High
		if(reset)
			cnt_High<=8'd0;
		else begin
			if (state==2'd0)
				cnt_High<=cnt_High+8'd1;
			else 
				cnt_High<=8'd0;
		end
	end
	always @(posedge clk or posedge reset ) begin//cnt_Low
		if(reset)
			cnt_Low<=8'd0;
		else begin
			if (state==2'd1)
				cnt_Low<=cnt_Low+8'd1;
			else 
				cnt_Low<=8'd0;
		end
		
	end
	
	always @(posedge clk or posedge reset ) begin //max  
		if(reset)begin
			max<=8'd0;
		end
		else begin
			if ((state==2'd2)&&(n==`N_MAX))begin
				if((~max_CountUp)&&(max>8'd0))
					max<=max-8'd1;
				else if((max_CountUp)&&(max<`MAX_VALUE))
					max<=max+8'd1;
			end
			else
				max<=max;
		end
	end
	
	always @(posedge clk or posedge reset ) begin // n
		if(reset)begin
			n<=20'd0;
		end
		else begin
		    if ((state==2'd2)&&(change==1'b0))
                if(n>= `N_MAX)
                    n<=20'd0;
                else
		            n<=n+20'd1;  
		    else
                n<=n;
        end
	end
    
    always @(posedge clk or posedge reset ) begin // change
		if(reset)begin
			change<=1'd0;
		end
		else begin
			if (state==2'd2)
				change<=1'd1;
			else
				change<=1'd0;
		end
	end	
	
	always @(posedge clk or posedge reset) begin//max_CountUp :1:count up  0:count down
		if(reset)
			max_CountUp<=0; //count down
		else begin
			if (state==2'd2)begin
				if (max==`MAX_VALUE)
					max_CountUp<=1'b0;
				else if (max==8'b0)
					max_CountUp<=1'b1; //count up
				else 
					max_CountUp<=max_CountUp;
			end
			else
				max_CountUp<=max_CountUp;

		end
	end
	

endmodule

