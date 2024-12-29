//
class bld176 extends uvm_scoreboard;
`uvm_component_utils(bld176)
uvm_tlm_analysis_fifo#(FP11) din;
uvm_analysis_port#(DT176) dout;
uvm_analysis_imp#(SADDR,bld176) adrw;

SADDR waddr;

function new(string name,uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    din=new("din",this);
    dout=new("dout",this);
    adrw=new("adrw",this);
endfunction : build_phase

function void write(SADDR wa);
    waddr=wa;
endfunction : write

task run_phase(uvm_phase phase);
    int cnt16;
    DT176 acd;
    FP11 dd;
    cnt16=0;
    forever begin
        din.get(dd);
        if(cnt16==0) begin
            acd=new(waddr,0);
            waddr+=1;
        end
        acd.A[cnt16]=dd;
        cnt16+=1;
        if(cnt16>=16) begin
            dout.write(acd);
            cnt16=0;
        end
    end
endtask : run_phase

endclass : bld176
