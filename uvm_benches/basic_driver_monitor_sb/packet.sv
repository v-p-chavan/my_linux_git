class packet extends uvm_sequence_item;
  rand logic[1:0] dst;
  rand logic[7:0] data;
  
  function new(string name="packet");
    super.new(name);
  endfunction
  

  virtual function string convert2string;
    string s;
    $sformat(s, "%s", super.convert2string());
    $sformat(s, " dst=%0h data=%0h \n", dst, data);
    return s;
  endfunction
  
  function void do_print(uvm_printer printer);
    if (printer.knobs.sprint == 0)
      `uvm_info(get_type_name(), convert2string(), UVM_MEDIUM)
    else
      printer.m_string = convert2string();
  endfunction
  
  function void do_copy(uvm_object rhs);
    packet pkt;
    super.do_copy(rhs);
    $cast(pkt, rhs);
  
    dst  = pkt.dst;
    data = pkt.data;  
  endfunction
  
  virtual function bit do_compare(uvm_object rhs, uvm_comparer comparer);
    packet pkt;
    bit equal;
    equal = super.do_compare(rhs, comparer);
    
    $cast(pkt, rhs);
    equal &= comparer.compare_field_int("dst", dst,  pkt.dst,  $bits(dst));
    equal &= comparer.compare_field_int("data",data, pkt.data, $bits(data));
    
    return equal;
  endfunction
  
  `uvm_object_utils_begin(packet)
    //`uvm_field_int(dst, UVM_DEFAULT)
    //`uvm_field_int(data, UVM_DEFAULT)
  `uvm_object_utils_end
endclass
    