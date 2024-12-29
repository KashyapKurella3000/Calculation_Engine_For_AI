// A simple watch dog timer
`define wdt_start(who,cnt,msg) begin WDTREQ m_z=new(cnt,msg); \
    who.write(m_z); end
`define wdt_stop(who) begin WDTREQ m_z=new(0,""); who.write(m_z); end


class wdt extends uvm_scoreboard;
`uvm_component_utils(wdt)
uvm_tlm_analysis_fifo#(WDTREQ) reqin;
uvm_tlm_analysis_fifo#(reg) clk;

int remaining;
string msg;

function new(string name, uvm_component par=null);
    super.new(name,par);
endfunction : new

function void build_phase(uvm_phase phase);
    reqin=new("wdtreq",this);
    clk=new("clk",this);
endfunction : build_phase

task do_clks();
    reg rv;
    forever begin
        clk.get(rv);
        if( remaining>0 ) begin
            remaining-=1;
            if ( remaining<=0 ) begin
                `uvm_error("wdt",msg)
                `uvm_fatal("wdt","Simulation ended, error location unknown")
            end
        end
    end
endtask : do_clks

task do_msgs();
    WDTREQ rq;
    forever begin
        reqin.get(rq);
        remaining=rq.cycnt;
        msg=rq.msg;
    end
endtask : do_msgs

task run_phase(uvm_phase phase);
    fork
        do_clks();
        do_msgs();
    join_none
endtask : run_phase


endclass : wdt
