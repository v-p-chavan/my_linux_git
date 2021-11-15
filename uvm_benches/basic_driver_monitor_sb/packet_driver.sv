class packet_driver extends uvm_driver #(packet);
  packet pkt;
  virtual driver_interface.mp drvr_intf;
  
  
  function new(string name="packet_driver", uvm_component parent=this);
    super.new(name, parent);
  endfunction
  
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
    assert(uvm_config_db#(virtual driver_interface.mp)::get(this, "", "drvr_intf", drvr_intf));
  endfunction
  
    
  virtual task run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    forever begin
      seq_item_port.get_next_item(pkt);
      drive_packet(pkt);
      seq_item_port.item_done();
    end
    
  endtask
  
   virtual task drive_packet(packet pkt);
      drvr_intf.cb.in_valid <= 1'b1;
      drvr_intf.cb.in_data  <= pkt.data;
      drvr_intf.cb.in_src   <= pkt.dst;
     repeat(1) @(drvr_intf.cb);
      drvr_intf.cb.in_valid <= 1'b0;
     `uvm_info(get_full_name(), $sformatf("%s", pkt.convert2string()), UVM_HIGH)
     
  endtask
 
  
  `uvm_component_utils_begin(packet_driver)
  `uvm_component_utils_end
  
endclass
