module top1920x1080(
	input pixel_clock, //148.25 МГц
	input rst,
	output vsync,
	output hsync,
	output de);
	
parameter H_FRONT_PORCH = 88, H_PULSE = 44, H_BACK_PORCH = 148, H_VISIBLE = 1920;
parameter V_FRONT_PORCH = 4,  V_PULSE = 5,  V_BACK_PORCH = 36,  V_VISIBLE = 1080;
parameter H_TOTAL_PIX = H_FRONT_PORCH + H_PULSE + H_BACK_PORCH + H_VISIBLE;
parameter V_TOTAL_PIX = V_FRONT_PORCH + V_PULSE + V_BACK_PORCH + V_VISIBLE;

reg [11:0] hcnt;
reg [10:0] vcnt;
wire v_en;

//horizontal sync
always @(posedge pixel_clock or posedge rst) begin
	if (rst)
		hcnt <= 11'b0;
	else if (hcnt < H_TOTAL_PIX-1)
		hcnt <= hcnt + 11'b01;
	else
		hcnt <= 11'b0;
end
assign hsync = (hcnt < H_PULSE) ? 1'b0 : 1'b1;


//vertical sync
assign v_en = (hcnt == (H_TOTAL_PIX - 1)) ? 1'b1 : 1'b0;
always @(posedge pixel_clock or posedge rst) begin
	if (rst)
		vcnt <= 10'b0;
	else	
		if (v_en)
			if (vcnt < V_TOTAL_PIX)
				vcnt <= vcnt + 10'b01;
			else
				vcnt <= 10'b0;
end
assign vsync = (vcnt < V_PULSE) ? 1'b0 : 1'b1;

//display area
assign de = ((hcnt>(H_PULSE + H_BACK_PORCH - 1))&&(hcnt<(H_PULSE + H_BACK_PORCH + H_VISIBLE))&&(vcnt>(V_PULSE + V_BACK_PORCH - 1))&&(vcnt<(V_PULSE + V_BACK_PORCH + V_VISIBLE)));
endmodule