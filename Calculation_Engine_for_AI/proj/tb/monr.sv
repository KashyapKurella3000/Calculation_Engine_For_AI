//
class monr extends uvm_monitor;
`uvm_component_utils(monr)
uvm_analysis_port#(SADDR) ra;
uvm_analysis_port#(logic [15:0]) fl;
uvm_analysis_port#(SADDR) wa;

virtual proj_intf ii;


function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
   ra=new("read_addr",this);
   fl=new("length",this);
   wa=new("write_addr",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",ii))
        `uvm_fatal("vint","Could not get virtual interface in monr");
endfunction : connect_phase

task run_phase(uvm_phase phase);
    forever begin
        @(posedge(ii.Rclk));
        if(ii.Rxfr==1 && ii.RdevselX==1 && ii.Rwrite==1) begin
            case (ii.Raddr[11:0])
                64'h8:
                    ra.write(ii.Rwdata);
                64'h10:
                    fl.write(ii.Rwdata);
                64'h18:
                    wa.write(ii.Rwdata);
            endcase
        end
    end
endtask : run_phase

endclass : monr
