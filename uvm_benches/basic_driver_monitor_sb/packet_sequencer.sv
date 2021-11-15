class packet_sequencer extends uvm_sequencer#(packet);
  
  // has a imp declared, no need to re-declare. 
  function new(string name="packet_sequencer", uvm_component parent=this);
    super.new(name, parent);
  endfunction
  
  `uvm_component_utils_begin(packet_sequencer)
  `uvm_component_utils_end
  
endclass
