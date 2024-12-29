//
class chkwr extends uvm_scoreboard;
`uvm_component_utils(chkwr)
uvm_tlm_analysis_fifo#(DT176) expected;
uvm_tlm_analysis_fifo#(DT176) actual;
uvm_analysis_port#(WDTREQ) t1;
DT176 exp,act;
wdt wdt_t1;
virtual proj_intf ii;

function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    expected=new("expected",this);
    actual=new("actual",this);
    t1=new("wdtt1",this);
    wdt_t1=wdt::type_id::create("wdt1",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    t1.connect(wdt_t1.reqin.analysis_export);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",ii))
        `uvm_fatal("vint","Could not get virtual interface in chkwr");

endfunction : connect_phase

task run_phase(uvm_phase phase);
    forever begin
        expected.get(exp);
        `wdt_start(t1,32,"Expected a write within 32 clocks of first input")
        actual.get(act);
        `wdt_stop(t1)
        if(exp.addr!==act.addr) begin
            `uvm_error("addr",$sformatf("write address exp %h got %h",
                exp.addr,act.addr))
        end
        if(exp.A !== act.A) begin
            `uvm_error("error",$sformatf("Data write error Exp %h Got %h",exp.A,act.A))
            ii.BAD=1;
        end else begin
//            `uvm_info("debug","got one right",UVM_MEDIUM)
        end
    end
endtask : run_phase

endclass : chkwr
