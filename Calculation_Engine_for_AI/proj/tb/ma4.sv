// An agent to contain a multiply and add of 4 items
class ma4 extends uvm_agent;
`uvm_component_utils(ma4)
uvm_tlm_analysis_fifo#(G4A) dtin;
uvm_analysis_port#(OPS) m[3:0];
uvm_analysis_port#(FP11) ares;

modFP11m Mul0;
modFP11m Mul1;
modFP11m Mul2;
modFP11m Mul3;
fpamodel add4;

task do_in();
    forever begin
        OPS op;
        G4A opi;
        dtin.get(opi);
        for (int ix=0; ix<4; ix+=1) begin
            op=new();
            op.A=opi.A[ix];
            op.B=opi.B[ix];
            m[ix].write(op);
        end
    end
endtask : do_in

task do_out();
endtask : do_out

task run_phase(uvm_phase phase);
    fork
        do_in();
        do_out();
    join_none
endtask : run_phase

function new(string name="ma4",uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    dtin=new("dtin",this);
    m[0]=new("m0",this);
    m[1]=new("m1",this);
    m[2]=new("m2",this);
    m[3]=new("m3",this);
    Mul0=modFP11m::type_id::create("Mul0",this);
    Mul1=modFP11m::type_id::create("Mul1",this);
    Mul2=modFP11m::type_id::create("Mul2",this);
    Mul3=modFP11m::type_id::create("Mul3",this);
    add4=fpamodel::type_id::create("FPA",this);
    ares=new("ares",this);

endfunction : build_phase

function void connect_phase(uvm_phase phase);
    m[0].connect(Mul0.omsg.analysis_export);
    m[1].connect(Mul1.omsg.analysis_export);
    m[2].connect(Mul2.omsg.analysis_export);
    m[3].connect(Mul3.omsg.analysis_export);
    Mul0.rmsg.connect(add4.pa.analysis_export);
    Mul1.rmsg.connect(add4.pb.analysis_export);
    Mul2.rmsg.connect(add4.pc.analysis_export);
    Mul3.rmsg.connect(add4.pd.analysis_export);
    add4.pz.connect(ares);

endfunction : connect_phase

endclass : ma4
