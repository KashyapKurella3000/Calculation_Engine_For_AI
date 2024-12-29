//
class monw2 extends uvm_monitor;
`uvm_component_utils(monw2)
uvm_analysis_port#(DT176) wd;
virtual proj_intf ii;


function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    wd=new("wd2",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",ii))
        `uvm_fatal("vint","Could not get virtual interface in monw2");
endfunction : connect_phase

task run_phase(uvm_phase phase);
    DT176 dd;
    forever begin
        @(posedge(ii.Sclk));
        if(ii.Swrequest==1 && ii.Swack==1) begin
            dd=new(ii.Swaddr,ii.Swdata);
            wd.write(dd);
        end
    end
endtask : run_phase

endclass : monw2
