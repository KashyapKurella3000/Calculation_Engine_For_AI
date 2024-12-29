// a basic uvm test for fun and pleasure

class test1 extends uvm_test;
`uvm_component_utils(test1)


seq1 s1;
seqr sqr;
drv dr;
monw1 m1;
ma16 m16;
bld176 b176;
chkwr ckw;
monw2 m2;
monr mr;

function new(string name="test1",uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    sqr=seqr::type_id::create("seqr",this);
    dr=drv::type_id::create("drv",this);
    m1=monw1::type_id::create("mon1",this);
    m16=ma16::type_id::create("m16",this);
    b176=bld176::type_id::create("b176",this);
    ckw=chkwr::type_id::create("ckw",this);
    m2=monw2::type_id::create("monw2",this);
    mr=monr::type_id::create("monr",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    dr.seq_item_port.connect(sqr.seq_item_export);
    m1.wd.connect(m16.bigdatain.analysis_export);
    m16.fres.connect(b176.din.analysis_export);
    b176.dout.connect(ckw.expected.analysis_export);
    m2.wd.connect(ckw.actual.analysis_export);
    m1.clk.connect(ckw.wdt_t1.clk.analysis_export);
    mr.wa.connect(b176.adrw);
    mr.ra.connect(m16.rd1.analysis_export);
    mr.fl.connect(m16.rln1.analysis_export);
endfunction : connect_phase

task run_phase(uvm_phase phase);
//    `uvm_info("debug","Safe in the test run_phase",UVM_MEDIUM)
    set_report_max_quit_count(3);
    s1=new();
    phase.raise_objection(this);
    s1.start(sqr);
    #185;
    phase.drop_objection(this);

endtask : run_phase



endclass : test1
