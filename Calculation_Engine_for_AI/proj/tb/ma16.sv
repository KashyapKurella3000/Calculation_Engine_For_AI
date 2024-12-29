//
class ma16 extends uvm_agent;
`uvm_component_utils(ma16)
uvm_analysis_port#(G4A) dt4[3:0];
uvm_tlm_analysis_fifo#(DT352) bigdatain;
uvm_analysis_port#(FP11) fres;
uvm_tlm_analysis_fifo#(SADDR) rd1;
uvm_tlm_analysis_fifo#(logic [15:0]) rln1;


ma4 mm[3:0];
fpamodel add4;

SADDR initial_ra;
logic [15:0] initial_len;

function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

task dora();
    forever begin
        rd1.get(initial_ra);
    end
endtask : dora

task doil();
    forever begin
        rln1.get(initial_len);
    end
endtask : doil

task run_phase(uvm_phase phase);
    DT352 big;
    G4A mdat;
    fork
        dora();
        doil();
    join_none
    forever begin
        bigdatain.get(big);
        if( big.ack )begin
            if (big.addr != initial_ra) begin
                `uvm_error("read_addr",$sformatf("Read address error exp %h got %h",initial_ra,big.addr))
            end
            initial_ra+=16;
            if(initial_len<=0) begin
                `uvm_error("read_len",$sformatf("Read of too many locations"))
            end
            initial_len-=1;
        end
        for(int ix=0; ix<4; ix+=1) begin
           mdat=new();
           for(int iy=0; iy<4; iy+=1) begin
            mdat.A[iy]=big.A[ix*4+iy];
            mdat.B[iy]=big.B[ix*4+iy];
           end
           dt4[ix].write(mdat);
        end
    end
endtask : run_phase

function void build_phase(uvm_phase phase);
    for(int ix=0; ix<4; ix+=1) mm[ix]=ma4::type_id::create($sformatf("mm%d",ix),this);
    add4=fpamodel::type_id::create("fpa",this);
    fres=new("fres",this);
    for(int ix=0; ix<4; ix+=1) dt4[ix]=new($sformatf("dt4_%d",ix),this);
    bigdatain=new("bigin",this);
    rd1=new("rd_init_addr",this);
    rln1=new("rd_init_len",this);
endfunction : build_phase

function void connect_phase(uvm_phase phase);
    for(int ix=0; ix<4; ix+=1) dt4[ix].connect(mm[ix].dtin.analysis_export);
    mm[0].ares.connect(add4.pa.analysis_export);
    mm[1].ares.connect(add4.pb.analysis_export);
    mm[2].ares.connect(add4.pc.analysis_export);
    mm[3].ares.connect(add4.pd.analysis_export);
    add4.pz.connect(fres);
endfunction : connect_phase


endclass : ma16
