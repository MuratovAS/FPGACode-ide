module pwm8b
       (
           input clk,
           input en,
           input [7:0] value_in,
           output out
       );

reg [7:0] counter;
reg [7:0] value; //max 255

assign out = (counter < value);

initial
begin
	counter = 0;
	value = 255;
end

always @(posedge clk)
begin
	counter <= counter + 1;

	if(en == 1'b1)
	begin
		value <= value_in;
	end;
end
endmodule
