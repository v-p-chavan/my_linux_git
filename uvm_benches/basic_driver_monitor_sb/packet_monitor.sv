class packet_driver_monitor extends uvm_monitor;
  virtual driver_interface.mon_mp drvr_mon_intf;
  packet pkt;
  uvm_analysis_port#(packet) drvr_mon_analysis_port;
  
  function new(string name="packet_driver_monitor", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    drvr_mon_analysis_port = new("drvr_mon_analysis_port", this);
    pkt = packet::type_id::create("pkt");
    if(!uvm_config_db#(virtual driver_interface.mon_mp)::get(this, "", "drvr_mon_intf", drvr_mon_intf)) begin
      `uvm_fatal(get_type_name(), "MON interface not found")
    end
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      if (drvr_mon_intf.mon_cb.in_valid) begin
        pkt.data = drvr_mon_intf.mon_cb.in_data;
        pkt.dst  = drvr_mon_intf.mon_cb.in_src;
        `uvm_info(get_full_name(),$sformatf("pkt:%0s", pkt.convert2string()), UVM_HIGH)
        drvr_mon_analysis_port.write(pkt);
        //pkt.print();
      end
      repeat (1) @ (drvr_mon_intf.mon_cb);
    end      
  endtask
  
  `uvm_component_utils_begin(packet_driver_monitor)
  `uvm_component_utils_end
    
endclass

class packet_monitor_op extends uvm_monitor;
  virtual monitor_interface.mp mon_intf;
  packet pkt;
  uvm_analysis_port#(packet) mon_analysis_port;
  
  logic [1:0] dst;
  
  
  function new(string name="packet_monitor_op", uvm_component parent=null);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon_analysis_port = new("mon_analysis_port", this);
    if(!uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf", mon_intf)) begin
      `uvm_fatal(get_type_name(), "MON interface not found")
    end
    if(!uvm_config_db#(int)::get(this, "", "dst", dst)) begin
      `uvm_fatal(get_type_name(), $sformatf("MON dst set to = %0h", dst))
    end
    
    pkt = packet::type_id::create("pkt");
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    forever begin
      if (mon_intf.cb.o_valid) begin
        pkt.data = mon_intf.cb.o_data;
        pkt.dst  = dst;
        `uvm_info(get_full_name(),$sformatf("MON:%0d pkt:%0s", dst, pkt.convert2string()), UVM_HIGH)
        mon_analysis_port.write(pkt);
        //pkt.print();
      end
      repeat (1) @ (mon_intf.cb);
    end      
  endtask
  
  `uvm_component_utils_begin(packet_monitor_op)
  `uvm_component_utils_end
    
endclass