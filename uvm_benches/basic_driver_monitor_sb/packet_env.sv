class packet_env extends uvm_env;
  packet_agent    pkt_agent;
  packet_agent_op pkt_agent_op;
  packet_scoreboard pkt_sb;
  
  virtual driver_interface.mp   drvr_intf;
  virtual driver_interface.mon_mp drvr_mon_intf;
  virtual monitor_interface.mp  mon_intf[4];
  
  
  function new(string name="pkt_agent", uvm_component parent=this);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    //logic [1:0] l_dst;
    pkt_agent    = packet_agent::type_id::create("pkt_agent", this);
    pkt_agent_op = packet_agent_op::type_id::create("pkt_agent_op", this);
    pkt_sb       = packet_scoreboard::type_id::create("pkt_sb", this);
    
    void'(uvm_config_db#(virtual driver_interface.mp)::get(this, "", "drvr_intf", drvr_intf));
    void'(uvm_config_db#(virtual driver_interface.mon_mp)::get(this, "", "drvr_mon_intf", drvr_mon_intf));
    
    uvm_config_db#(virtual driver_interface.mp)::set(this,"pkt_agent.pkt_drvr", "drvr_intf", drvr_intf);
    uvm_config_db#(virtual driver_interface.mon_mp)::set(this,"pkt_agent.pkt_drvr_mon", "drvr_mon_intf", drvr_mon_intf);
    
    
    if(!uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[0]", mon_intf[0])) begin
      `uvm_fatal(get_full_name(), $sformatf("MON intf not found for mon no=%0d", 0))
    end
    if(!uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[1]", mon_intf[1])) begin
      `uvm_fatal(get_full_name(), $sformatf("MON intf not found for mon no=%0d", 0))
    end
    if(!uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[2]", mon_intf[2])) begin
      `uvm_fatal(get_full_name(), $sformatf("MON intf not found for mon no=%0d", 0))
    end
    if(!uvm_config_db#(virtual monitor_interface.mp)::get(this, "", "mon_intf[3]", mon_intf[3])) begin
      `uvm_fatal(get_full_name(), $sformatf("MON intf not found for mon no=%0d", 0))
    end
    
    
   
    uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_agent_op.pkt_mon[0]", "mon_intf", mon_intf[0]);
    uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_agent_op.pkt_mon[1]", "mon_intf", mon_intf[1]);
    uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_agent_op.pkt_mon[2]", "mon_intf", mon_intf[2]);
    uvm_config_db#(virtual monitor_interface.mp)::set(this, "pkt_agent_op.pkt_mon[3]", "mon_intf", mon_intf[3]);
    
    uvm_config_db#(int)::set(this, "pkt_agent_op.pkt_mon[0]", "dst", 0);      
    uvm_config_db#(int)::set(this, "pkt_agent_op.pkt_mon[1]", "dst", 1);      
    uvm_config_db#(int)::set(this, "pkt_agent_op.pkt_mon[2]", "dst", 2);      
    uvm_config_db#(int)::set(this, "pkt_agent_op.pkt_mon[3]", "dst", 3);      
   
  endfunction

  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    pkt_agent.mon_agent_exp.connect(pkt_sb.drvr_mon_imp);
    
    pkt_agent_op.mon_agent_op_exp[0].connect(pkt_sb.mon0_pkt_imp);
    pkt_agent_op.mon_agent_op_exp[1].connect(pkt_sb.mon1_pkt_imp);
    pkt_agent_op.mon_agent_op_exp[2].connect(pkt_sb.mon2_pkt_imp);
    pkt_agent_op.mon_agent_op_exp[3].connect(pkt_sb.mon3_pkt_imp);
  endfunction
  
  `uvm_component_utils_begin(packet_env)
  `uvm_component_utils_end
  
endclass
