//
class base_test extends uvm_test;
  `uvm_component_utils(base_test)

  
  packet_env      pkt_env;
  packet_sequence pkt_seq;
  
  virtual driver_interface.mp     drvr_intf;
  virtual driver_interface.mon_mp drvr_mon_intf;
  
  virtual monitor_interface.mp mon_intf[4];
  
  
  function new(string name="base_test",uvm_component parent = this);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_seq = packet_sequence::type_id::create("pkt_seq");
    pkt_env = packet_env::type_id::create("pkt_env", this);
    
    void'(uvm_config_db#(virtual driver_interface.mp)::get(this, "", "drvr_intf", drvr_intf));
    void'(uvm_config_db#(virtual driver_interface.mon_mp)::get(this, "", "drvr_mon_intf", drvr_mon_intf));
        
    void'(uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[0]", mon_intf[0]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[1]", mon_intf[1]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[2]", mon_intf[2]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[3]", mon_intf[3]));
    
    void'(uvm_config_db#(virtual driver_interface.mp)::set(this, "pkt_env", "drvr_intf", drvr_intf));
    void'(uvm_config_db#(virtual driver_interface.mon_mp)::set(this, "pkt_env", "drvr_mon_intf", drvr_mon_intf));
    
    void'(uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_env", "mon_intf[0]", mon_intf[0]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_env", "mon_intf[1]", mon_intf[1]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_env", "mon_intf[2]", mon_intf[2]));
    void'(uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_env", "mon_intf[3]", mon_intf[3]));

    
    `uvm_info(get_type_name(), "SHRI:::from build_phase", UVM_HIGH)
  endfunction
  
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    phase.raise_objection(this);
    repeat (2) @ (drvr_intf.cb);
    //uvm_config_db#(uvm_object_wrapper)::set(this,"pkt_env.pkt_agent.pkt_seqr.main_phase", "default_sequence", packet_sequence::type_id::get()); 
    void'(pkt_seq.randomize() with {pkt_seq.num_of_pkts == 9;});
    pkt_seq.start(pkt_env.pkt_agent.pkt_seqr);
    repeat (10) @ (drvr_intf.cb);
    phase.drop_objection(this);
    `uvm_info(get_type_name(), "SHRI::from run_phase", UVM_HIGH)
  endtask
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_type_name(), "SHRI::report_phase", UVM_HIGH)
  endfunction
  
endclass
