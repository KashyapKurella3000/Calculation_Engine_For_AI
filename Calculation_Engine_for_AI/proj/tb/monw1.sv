//
class monw1 extends uvm_monitor;
`uvm_component_utils(monw1)
uvm_analysis_port#(DT352) wd;
uvm_analysis_port#(reg) clk;

virtual proj_intf ii;



function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    wd=new("wd",this);
    clk=new("clk",this);

endfunction : build_phase

function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",ii))
        `uvm_fatal("vint","Could not get virtual interface in monw1");
endfunction : connect_phase

task run_phase(uvm_phase phase);
    DT352 dd;
    forever begin
        @(posedge(ii.Sclk));
        if(ii.Srstrobe==1) begin
            dd=new();
            dd.A=ii.Srdata[351:176];
            dd.B=ii.Srdata[175:0];
            dd.addr=ii.Sraddr;
            dd.ack=ii.Srack;
            wd.write(dd);
        end
        if ( !ii.Sreset ) begin
            clk.write(1'b1);
            if(ii.Srrequest===1'bX) begin
                `uvm_error("X","Srrequest contains X")
                ii.BAD=1;
            end
            if(ii.Swrequest===1'bX) begin
                `uvm_error("X","Swrequest contains X")
                ii.BAD=1;
            end
            if(^ii.Sraddr===1'bX) begin
                `uvm_error("X",$sformatf("Sraddr contains an X 'h%h",ii.Sraddr))
                ii.BAD=1;
            end
            if(^ii.Swaddr===1'bX) begin
                `uvm_error("X",$sformatf("Swaddr contains an X 'h%h",ii.Swaddr))
                ii.BAD=1;
            end
            if(^ii.Swdata===1'bX) begin
                `uvm_error("X",$sformatf("Swdata contains an X 'h%h",ii.Swdata))
                ii.BAD=1;
            end
            if(^ii.Rrdata===1'bX) begin
                `uvm_error("X",$sformatf("Rrdata contains an X 'h%h",ii.Rrdata))
                ii.BAD=1;
            end
        end
    end
endtask : run_phase

endclass : monw1
