// Code your testbench here
// or browse Examples
`include "my_uvm_pkg.svh"

module tb_top();
  import uvm_pkg::*;
  import my_uvm_pkg::*;
  
  bit clk;
  bit reset;
  
  initial begin
    clk = 1'b0;
    forever begin
      clk = #10ns ~clk;
    end
  end
  
  initial begin
    reset = 1'b0;
    repeat (2) @ (posedge clk);
    reset = 1'b0;
  end
  
  //initial begin
  //  $dumpfile("dump.vcd");
  //  $dumpvars;
  //end
  
  driver_interface drvr_intf   (.clk(clk), .reset(reset));
  monitor_interface mon_intf[4](.clk(clk), .reset(reset));
  
  simple simple_dut(
    .clk(clk), 
    .reset(reset),       
    .in_src(drvr_intf.in_src),
    .in_data(drvr_intf.in_data),
    .in_valid(drvr_intf.in_valid),
    .o0_valid(mon_intf[0].o_valid),
    .o0_data(mon_intf[0].o_data),
    .o1_valid(mon_intf[1].o_valid),
    .o1_data(mon_intf[1].o_data),
    .o2_valid(mon_intf[2].o_valid),
    .o2_data(mon_intf[2].o_data),
    .o3_valid(mon_intf[3].o_valid),
    .o3_data(mon_intf[3].o_data));
    
  
  initial begin
    
    uvm_config_db#(virtual driver_interface.mp)::set(null, "uvm_test_top", "drvr_intf", drvr_intf.mp);
    uvm_config_db#(virtual driver_interface.mon_mp)::set(null, "uvm_test_top", "drvr_mon_intf", drvr_intf.mon_mp);
    
    uvm_config_db#(virtual monitor_interface.mp)::set(null, "uvm_test_top", "mon_intf[0]", mon_intf[0].mp);
    uvm_config_db#(virtual monitor_interface.mp)::set(null, "uvm_test_top", "mon_intf[1]", mon_intf[1].mp);
    uvm_config_db#(virtual monitor_interface.mp)::set(null, "uvm_test_top", "mon_intf[2]", mon_intf[2].mp);
    uvm_config_db#(virtual monitor_interface.mp)::set(null, "uvm_test_top", "mon_intf[3]", mon_intf[3].mp);
    
    run_test("base_test");
  end
endmodule
