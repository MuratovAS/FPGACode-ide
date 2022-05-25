`include "src/pwm8b.v"

module top (input CLK,
            output LED1,
            output LED2,
            output LED3,
            output LED4,
            output LED5);
	
	reg en             = 1;
	reg [7:0] value_in = 8'd10;
	wire out;
	
	pwm8b pwm_1(
	.clk(CLK),
	.en(en),
	.value_in(value_in),
	.out(out)
	);
	
	assign LED1 = out;
	assign LED2 = 0;
	assign LED3 = 0;
	assign LED4 = 0;
	assign LED5 = 0;
endmodule
