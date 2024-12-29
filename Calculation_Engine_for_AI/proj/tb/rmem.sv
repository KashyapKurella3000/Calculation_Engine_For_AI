// A simple read memory model

class rmem extends uvm_scoreboard;
`uvm_component_utils(rmem)
uvm_tlm_analysis_fifo #(WMEM) wreq;

virtual proj_intf vi;

RDATA wrmem[SADDR];

function new(string name="rmem",uvm_component par=null);
    super.new(name,par);

endfunction : new

function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",vi))
        `uvm_fatal("vint","Could not get virtual interface in rmem");
endfunction : connect_phase

function void build_phase(uvm_phase phase);
    wreq= new("wreq",this);

endfunction : build_phase

endclass : rmem
