class packet_sequence extends uvm_sequence#(packet);
  rand int num_of_pkts;
  packet pkt;
  constraint c {num_of_pkts > 0; num_of_pkts < 10;}
  `uvm_declare_p_sequencer(uvm_sequencer#(packet))
  //need to define sequencer
  
  function new(string name="packet_sequence");
    super.new(name);
  endfunction
  
  task body();
    `uvm_info(get_type_name(), $sformatf("num of pkts=%0d", num_of_pkts), UVM_HIGH)
    repeat (num_of_pkts) begin
      pkt=packet::type_id::create("pkt");
      start_item(pkt);  // what does this exactly do ? 
      void'(pkt.randomize());
      finish_item(pkt); // what does this exactly do ?
    end
  endtask
  
  `uvm_object_utils_begin(packet_sequence)
    `uvm_field_int(num_of_pkts, UVM_DEFAULT)
  `uvm_object_utils_end
  
endclass
