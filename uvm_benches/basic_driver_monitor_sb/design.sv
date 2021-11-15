// Code your design here
`include "interface.sv"
module simple(clk, reset, in_valid, in_data, in_src, o0_data, o1_data, o2_data, o3_data,
             o0_valid, o1_valid, o2_valid, o3_valid);
  input clk;
  input reset;
  input [7:0] in_data;
  input [1:0] in_src;
  input in_valid;
  
  output [7:0] o0_data;
  output [7:0] o1_data;
  output [7:0] o2_data;
  output [7:0] o3_data;
  
  output o0_valid;
  output o1_valid;
  output o2_valid;
  output o3_valid;
  
  reg[31:0] temp_data;
  reg[3:0]  temp_valid;
  
  always @(posedge clk) begin
    if ( reset) begin
      temp_data <= 32'h0000;
      temp_valid <= 4'b0000;
    end
    else begin
      temp_data[7:0]   <= (in_src == 2'b00) ? in_data : temp_data[7:0];
      temp_data[15:8]  <= (in_src == 2'b01) ? in_data : temp_data[15:8];
      temp_data[23:16] <= (in_src == 2'b10) ? in_data : temp_data[23:16];
      temp_data[31:24] <= (in_src == 2'b11) ? in_data : temp_data[31:24];
      
      temp_valid[0] <= (in_src == 2'b00) ? in_valid:1'b0;
      temp_valid[1] <= (in_src == 2'b01) ? in_valid:1'b0;
      temp_valid[2] <= (in_src == 2'b10) ? in_valid:1'b0;
      temp_valid[3] <= (in_src == 2'b11) ? in_valid:1'b0;
    end  
  end
  
  assign {o3_data, o2_data, o1_data, o0_data}     = temp_data;
  assign {o3_valid, o2_valid, o1_valid, o0_valid} = temp_valid;
  
endmodule
