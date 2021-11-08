`default_nettype none
`define VCD_OUTPUT pwm8b
`define DUMPSTR(x) `"x.vcd`"
`timescale 100 ns / 10 ns

module pwm8b_tb();
//-- Simulation time: 20us (20 * 100ns)
parameter DURATION = 200;

//-- i/o port
reg clk;
reg en;
reg [7:0] value_in;
wire out;

//-- Clock signal. It is not used in this simulation
initial
begin
	clk = 0;
	forever #0.1 clk = ~clk;
end

//-- Instantiate the unit to test
pwm8b pwm_u
      (
          .clk(clk),
          .en(en),
          .value_in(value_in),
          .out(out)
      );

//-- Test script
initial
begin
	#1;
	en = 1;
	value_in = 8'd0;
	#50;
	value_in = 8'd100;
	#50;
	value_in = 8'd200;
	#50;
	value_in = 8'd255;
	#50;
end

//-- File were to store the simulation results
initial
begin
	$display("End of simulation");
	$dumpfile(`DUMPSTR(`VCD_OUTPUT));
	$dumpvars(0, pwm_u);
	#(DURATION) $display("End of simulation");
	$finish;
end

endmodule
