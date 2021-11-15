`uvm_analysis_imp_decl(_mon0)
`uvm_analysis_imp_decl(_mon1)
`uvm_analysis_imp_decl(_mon2)
`uvm_analysis_imp_decl(_mon3)

`uvm_analysis_imp_decl(_drvr_mon)

class packet_scoreboard extends uvm_scoreboard;
  
  uvm_analysis_imp_mon0#(packet, packet_scoreboard) mon0_pkt_imp;
  uvm_analysis_imp_mon1#(packet, packet_scoreboard) mon1_pkt_imp;
  uvm_analysis_imp_mon2#(packet, packet_scoreboard) mon2_pkt_imp;
  uvm_analysis_imp_mon3#(packet, packet_scoreboard) mon3_pkt_imp;
  
  uvm_analysis_imp_drvr_mon#(packet, packet_scoreboard) drvr_mon_imp;
  
  packet mon_q[4][$];
  packet drvr_mon_q[$];
  
  
  function new(string name="pkt_scoreboard", uvm_component parent=this);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    mon0_pkt_imp = new("mon0_pkt_imp", this);
    mon1_pkt_imp = new("mon1_pkt_imp", this);
    mon2_pkt_imp = new("mon2_pkt_imp", this);
    mon3_pkt_imp = new("mon3_pkt_imp", this);
    
    drvr_mon_imp = new("drvr_mon_imp", this);
  endfunction
  
  
  function void write_drvr_mon(packet pkt);
    packet drvr_mon_pkt = packet::type_id::create("drvr_mon_pkt");
    drvr_mon_pkt.copy(pkt);
    drvr_mon_q.push_back(drvr_mon_pkt);
  endfunction
  
  function void write_mon0(packet pkt);
    packet mon0_pkt = packet::type_id::create("mon0_pkt");
    mon0_pkt.copy(pkt);
    mon_q[0].push_back(mon0_pkt); 
  endfunction
  
  function void write_mon1(packet pkt);
    packet mon1_pkt = packet::type_id::create("mon1_pkt");
    mon1_pkt.copy(pkt);
    mon_q[1].push_back(mon1_pkt); 
  endfunction
  
  function void write_mon2(packet pkt);
    packet mon2_pkt = packet::type_id::create("mon2_pkt");
    mon2_pkt.copy(pkt);
    mon_q[2].push_back(mon2_pkt); 
  endfunction
  
  function void write_mon3(packet pkt);
    packet mon3_pkt = packet::type_id::create("mon3_pkt");
    mon3_pkt.copy(pkt);
    mon_q[3].push_back(mon3_pkt); 
  endfunction
  
  
  virtual task run_phase(uvm_phase phase);
    packet drvr_mon_pkt;
    packet op_pkt;
    
    super.run_phase(phase);
   
    forever begin
        wait (drvr_mon_q.size() > 0);        
        drvr_mon_pkt = drvr_mon_q.pop_front();
      
        wait (mon_q[drvr_mon_pkt.dst].size());
        op_pkt = mon_q[drvr_mon_pkt.dst].pop_front();
      
        if (!drvr_mon_pkt.compare(op_pkt)) begin
          `uvm_info(get_full_name(), $sformatf("packet did not match"), UVM_HIGH)
        end
        else begin
          `uvm_info(get_full_name(), $sformatf("packet matched"), UVM_HIGH)
        end
      
    end    
  
  endtask
  
  virtual function void report_phase(uvm_phase phase);
    super.report_phase(phase);
    `uvm_info(get_full_name(), $sformatf("Printing mon0, size=%0d", mon_q[0].size() ), UVM_HIGH)
    print_q(mon_q[0]);
    `uvm_info(get_full_name(), $sformatf("Printing mon1, size=%0d", mon_q[1].size() ), UVM_HIGH)
    print_q(mon_q[1]);
    `uvm_info(get_full_name(), $sformatf("Printing mon2, size=%0d", mon_q[2].size() ), UVM_HIGH)
    print_q(mon_q[2]);
    `uvm_info(get_full_name(), $sformatf("Printing mon3, size=%0d", mon_q[3].size() ), UVM_HIGH)
    print_q(mon_q[3]);
    `uvm_info(get_full_name(), $sformatf("Printing drvr_mon_q, size=%0d", drvr_mon_q.size() ), UVM_HIGH)
    print_q(drvr_mon_q);
  endfunction
  
  function void print_q(packet q[$]);
    packet p;
    while(q.size()) begin
      p=q.pop_front();
      p.print(); 
    end
  endfunction
  
  `uvm_component_utils_begin(packet_scoreboard)
  `uvm_component_utils_end
endclass
