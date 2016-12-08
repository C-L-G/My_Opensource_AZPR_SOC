`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:42:46 09/09/2015 
// Design Name: 
// Module Name:    buffer_hdl_core 
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
module buffer_hdl_core #(
	parameter WIDTHA      = 8,
	parameter SIZEA       = 512,
	parameter ADDRWIDTHA  = 9,
	parameter WIDTHB      = 16,
	parameter SIZEB       = 256,
	parameter ADDRWIDTHB  = 8

)(
	input	wire						buffer_clk_a,
	input	wire						buffer_clk_b,
	input	wire						buffer_we_a,
	input	wire						buffer_we_b,
	input	wire	[ADDRWIDTHA-1:0]	buffer_addr_a,
	input	wire	[ADDRWIDTHB-1:0]	buffer_addr_b,	
	input	wire	[WIDTHA-1:0]		buffer_din_a,
	input	wire	[WIDTHB-1:0]		buffer_din_b,
	output	reg		[WIDTHA-1:0]		buffer_dout_a = 0,
	output	reg		[WIDTHB-1:0]		buffer_dout_b = 0
);
  
	`define max(a,b) {(a) > (b) ? (a) : (b)}
	`define min(a,b) {(a) < (b) ? (a) : (b)}
	wire enA;
	wire enB;
	assign 	enA = 1;
	assign 	enB = 1;	
	function integer log2;
		input integer value;
		reg [31:0] shifted;
		integer res;
		begin
			if (value < 2)
			  log2 = value;
			else
				begin
				  shifted = value-1;
				  for (res=0; shifted>0; res=res+1)
					shifted = shifted>>1;
				  log2 = res;
				end
		end
	endfunction

	localparam maxSIZE   = `max(SIZEA, SIZEB);
	localparam maxWIDTH  = `max(WIDTHA, WIDTHB);
	localparam minWIDTH  = `min(WIDTHA, WIDTHB);
	localparam RATIO     = maxWIDTH / minWIDTH;
	localparam log2RATIO = log2(RATIO);

  // An asymmetric RAM is modeled in a similar way as a symmetric RAM, with an
  // array of array reg. Its aspect ratio corresponds to the port with the
  // lower data width (larger depth)
  reg     [minWIDTH-1:0]  buffer_core [0:maxSIZE-1];
  
  genvar i;

  // Describe the port with the smaller data width exactly as you are used to
  // for symmetric block RAMs
  always @(posedge buffer_clk_b)
  begin  : portB
    if (enB)
      if (buffer_we_b) begin
        buffer_core[buffer_addr_b] <= buffer_din_b;
        buffer_dout_b <= buffer_din_b;
      end else
        buffer_dout_b <= buffer_core[buffer_addr_b];
    end

  // A generate-for is used to describe the port with the larger data width in a
  // generic and compact way
  
	`define BIGEND 1
	`ifndef  BIGEND
		`define LITTLEEND 1
	`endif
	generate for (i = 0; i < RATIO; i = i+1)
	begin: portA
		`ifdef LITTLEEND
		localparam [log2RATIO-1:0] lsbaddr = i;
		`elsif BIGEND
		localparam [log2RATIO-1:0] lsbaddr = RATIO-i-1;
		`endif
		always @(posedge buffer_clk_a)
			if (enA) begin
				if (buffer_we_a) begin	
					buffer_core[{buffer_addr_a,lsbaddr}] <= buffer_din_a[(i+1)*minWIDTH-1:i*minWIDTH];
					buffer_dout_a[(i+1)*minWIDTH-1:i*minWIDTH] <= buffer_din_a[(i+1)*minWIDTH-1:i*minWIDTH];
				end else
					buffer_dout_a[(i+1)*minWIDTH-1:i*minWIDTH] <= buffer_core[{buffer_addr_a, lsbaddr}];
			end
	end
	endgenerate
	  
endmodule
