class packet_agent extends uvm_agent;
  packet_driver           pkt_drvr;
  packet_sequencer        pkt_seqr;
  packet_driver_monitor   pkt_drvr_mon;
  
  uvm_analysis_export#(packet) mon_agent_exp;
  
  function new(string name="packet_agent", uvm_component parent=this);
    super.new(name, parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_drvr = packet_driver::type_id::create("pkt_drvr", this);
    pkt_seqr = packet_sequencer::type_id::create("pkt_seqr", this);
    pkt_drvr_mon = packet_driver_monitor::type_id::create("pkt_drvr_mon", this);
    mon_agent_exp = new("mon_agent_exp");
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    pkt_drvr.seq_item_port.connect(pkt_seqr.seq_item_export);
    pkt_drvr_mon.drvr_mon_analysis_port.connect(mon_agent_exp);
  endfunction
  
  `uvm_component_utils_begin(packet_agent)
  `uvm_component_utils_end
endclass


class packet_agent_op extends uvm_agent;
  packet_monitor_op            pkt_mon[4];
  uvm_analysis_export#(packet) mon_agent_op_exp[4];
  function new(string name="packet_agent_op", uvm_component parent=this);
    super.new(name, parent);
  endfunction 
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    pkt_mon[0]  = packet_monitor_op::type_id::create("pkt_mon[0]", this);
    pkt_mon[1]  = packet_monitor_op::type_id::create("pkt_mon[1]", this);
    pkt_mon[2]  = packet_monitor_op::type_id::create("pkt_mon[2]", this);
    pkt_mon[3]  = packet_monitor_op::type_id::create("pkt_mon[3]", this);
    
    mon_agent_op_exp[0] = new("mon_agent_op_exp[0]");
    mon_agent_op_exp[1] = new("mon_agent_op_exp[1]");
    mon_agent_op_exp[2] = new("mon_agent_op_exp[2]");
    mon_agent_op_exp[3] = new("mon_agent_op_exp[3]");
  endfunction
  
  virtual function void connect_phase(uvm_phase phase);
    super.connect_phase(phase);
    pkt_mon[0].mon_analysis_port.connect(mon_agent_op_exp[0]);
    pkt_mon[1].mon_analysis_port.connect(mon_agent_op_exp[1]);
    pkt_mon[2].mon_analysis_port.connect(mon_agent_op_exp[2]);
    pkt_mon[3].mon_analysis_port.connect(mon_agent_op_exp[3]);
  endfunction
    
  `uvm_component_utils_begin(packet_agent_op)
  `uvm_component_utils_end
  
endclass