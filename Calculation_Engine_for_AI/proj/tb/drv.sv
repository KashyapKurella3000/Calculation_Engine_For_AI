// The basic driver. Has a lot to do.
//
class drv extends uvm_driver#(DrvMsg);
`uvm_component_utils(drv)

DrvMsg dm;
virtual proj_intf vi;

typedef struct packed {
    logic [175:0] coef;
    logic [175:0] op2;
} memloc;

memloc mem[reg[47:0]];

function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void connect_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual proj_intf)::get(null,"top","intf0",vi))
        `uvm_fatal("vint","Could not get virtual interface in drv1");
endfunction : connect_phase

task memreader();
    logic [47:0] waddr;
    vi.Srack=0;
    vi.Srstrobe=0;
    forever begin
        @(posedge(vi.Sclk));
        if (vi.Sreset) continue;
        if (!vi.Srrequest) continue;
        waddr=vi.Sraddr;
        #1;
        vi.Srack=1;
        vi.Srdata=mem[waddr];
        vi.Srstrobe=1;
        waddr+=1;
        @(posedge(vi.Sclk)) #1;
        vi.Srack=0;
        repeat(15) begin
           vi.Srdata=mem[waddr];
           waddr+=1;
           @(posedge(vi.Sclk)) #1;
        end
        vi.Srstrobe=0;
        vi.Sraddr=$urandom_range(1234567);
    end
endtask : memreader

task memwriter();
    vi.Swack=0;
    forever begin
        @(posedge(vi.Sclk)) begin
            if(vi.Swrequest) begin
                repeat($urandom_range(0,2)) @(posedge(vi.Sclk));
                #1;
                vi.Swack=1;
            end else begin
                #1;
                vi.Swack=0;
            end
        end
    end

endtask : memwriter

task sendReset();
    vi.reset=0;
    #1;
    vi.reset=1;
    repeat(3) @(posedge(vi.clk)) #1;
    vi.reset=0;
endtask : sendReset

task writeReg(DrvMsg dm);
    vi.Rxfr=0;
    vi.Rwrite=1;
    vi.RdevselX=1;
    vi.Raddr=dm.reg_addr;
    vi.Rwdata=dm.reg_data;
    @(posedge(vi.clk)) #1;
    vi.Rxfr=1;
    @(posedge(vi.clk)) #1;
    vi.Rxfr=0;
    vi.RdevselX=0;
    vi.Raddr=$urandom_range(1,10000);
    vi.Rwdata=$urandom_range(0,70000);
endtask : writeReg

task inits();
    vi.reset=0;
    vi.RdevselX=0;
    vi.Rwrite=0;
    vi.Rxfr=0;
    vi.Raddr=0;
    vi.Rwdata=0;
    vi.BAD=0;
endtask : inits

task setmem(DrvMsg dm);
    mem[dm.wm.addr]=dm.wm.rdata;
endtask : setmem

task read_reg(input logic [11:0] addr, output logic [63:0] rdata);
    vi.Rxfr=0;
    vi.Rwrite=0;
    vi.RdevselX=1;
    vi.Raddr=addr;
    vi.Rwdata=dm.reg_data;
    @(posedge(vi.clk)) #1;
    vi.Rxfr=1;
    @(posedge(vi.clk)) ;
    rdata=vi.Rrdata;
    if(^rdata===1'bx) begin
        `uvm_error("X","Rrdata contains an X")
        vi.BAD=1;
    end
    #1
    vi.Rxfr=0;
    vi.RdevselX=0;
    vi.Raddr=$urandom_range(1,10000);
endtask : read_reg

task wait_busy(int maxcnt);
    logic [63:0] rval;
    int wcnt=maxcnt/2;
    read_reg(0,rval);
    while(rval[0] && wcnt>0) begin
        read_reg(0,rval);
        wcnt-=1;
    end
    if(wcnt<=0) begin
        `uvm_fatal("busy",$sformatf("Still busy after %d cycles from start of calculation",maxcnt))
    end
endtask : wait_busy

task run_phase(uvm_phase phase);
    inits();
    fork
        memreader();
        memwriter();
    join_none
    forever begin
        seq_item_port.get_next_item(dm);
        case(dm.cmd)
            DCreset:
                sendReset();
            DCwreg:
                writeReg(dm);
            DCstall:
                repeat(dm.cycles) @(posedge(vi.clk)) #1;
            DCsetmem:
                setmem(dm);
            DCwaitbusy:
                wait_busy(dm.cycles);
            default:
                `uvm_fatal("death","unknown driver command code")
        endcase

        seq_item_port.item_done();

    end
endtask : run_phase

endclass : drv
