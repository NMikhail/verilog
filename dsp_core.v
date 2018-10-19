module dsp_core
#(parameter N=7, DW=16, CW=16)
(	  data,
	  filt);
	
parameter OW=$clog2(N)+DW+CW;
parameter size = OW-DW;
input  [(DW-1):0] data;
output  [(OW-1):0] filt;	

genvar d;
wire [OW-DW-1:0] tmp;
generate for (d = 0; d<size;d=d+1) begin :jopa
	assign tmp[d] = data[DW-1];
end
endgenerate

assign filt = {tmp, data};


endmodule