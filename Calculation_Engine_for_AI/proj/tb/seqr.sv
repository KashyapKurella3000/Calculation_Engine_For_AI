// A dumb sequencer
class seqr extends uvm_sequencer#(DrvMsg);
`uvm_component_utils(seqr)

function new(string name="seqr",uvm_component par=null);
    super.new(name,par);
endfunction : new


endclass : seqr
