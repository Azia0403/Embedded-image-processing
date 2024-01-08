`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    05:54:36 09/27/2023 
// Design Name: 
// Module Name:    hw1 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module hw1(reset,clk,cnt1,cnt2);
	input clk,reset;
	output reg [7:0]cnt1,cnt2;
	reg state;
	always @(posedge clk or negedge reset) begin //FSM
		if(~reset)
			state<=1'd0;
		else begin
		if(cnt1>=8'd30)
			state<=1'd1;
		if(cnt2<=8'd130)
			state<=1'd0;
		end
	end
		always @(posedge clk or negedge reset or state) begin//cnt1
		if(~reset)
			cnt1<=8'd13;
		else begin
		if (~state)begin
			if (cnt2==8'd161);
				cnt1<=cnt1+8'd1;
		end
		else 
			cnt1<=8'd13;
		end
	end
		always @(posedge clk or negedge reset or state) begin//cnt2
		if(~reset)
			cnt2<=8'd161;
		else begin
		if (state)begin
			if (cnt1==8'd13)
				cnt2<=cnt2-8'd1;
		end
		else 
			cnt2<=8'd161;
		end
	end


endmodule
