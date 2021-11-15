interface driver_interface(input bit clk, input bit reset);
  logic [1:0] in_src;
  logic [7:0] in_data;
  logic       in_valid;  
  
  clocking cb @(posedge clk);
    default input #1ns output #1ns;
    output in_valid;
    output in_data;
    output in_src;
  endclocking
  
  modport mp (clocking cb, input reset);    
    
  clocking mon_cb @(posedge clk);
    default input #1ns output #1ns;
    input in_valid;
    input in_data;
    input in_src;
  endclocking
  
    modport mon_mp (clocking mon_cb, input reset);  
endinterface
    

    
interface monitor_interface(input bit clk, input bit reset);
  logic       o_valid;
  logic [7:0] o_data;
  
  clocking cb @(posedge clk);
    default input #1ns output #1ns;
    input o_valid;
    input o_data;
  endclocking
  
  modport mp(clocking cb, input reset);
   
endinterface


    
    
    
    
    
    
    
