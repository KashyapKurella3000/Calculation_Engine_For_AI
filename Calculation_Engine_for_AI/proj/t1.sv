// A test driver
`timescale 1ns/10ps

`define LC(x) `"/home/morris/272/f24/proj/tb/x`"

`define simulation bob


`include `LC(defs.sv)
`include `LC(intf.sv)

package proj224;
    import uvm_pkg::*;
    `include `LC(defs.sv)
    `include `LC(msgs.sv)
    `include `LC(seq1.svp)
    `include `LC(seqr.sv)
    `include `LC(fpm.svp)
    `include `LC(fpa.svp)
    `include `LC(wdt.sv)

    `include `LC(monr.sv)
    `include `LC(rmem.sv)
    `include `LC(chkwr.sv)
    `include `LC(bld176.sv)
    `include `LC(monw1.sv)
    `include `LC(monw2.sv)
    `include `LC(ma4.sv)
    `include `LC(ma16.sv)
    `include `LC(drv.sv)
    `include `LC(uvmt1.sv)


endpackage : proj224

`include "fpeng.sv"

module top();
    import uvm_pkg::*;


    logic clk;
    logic reset;

    proj_intf ii(clk,clk,clk,reset,reset,reset);

    initial begin
        clk=0;
        repeat(200000) begin
            clk=1;
            #5;
            clk=0;
            #5;
        end
        $display("Ran out of clocks");
        $finish();

    end

    initial begin
        uvm_config_db #(virtual proj_intf)::set(null, "top", "intf0" , ii);
        run_test("test1");
    end

    initial begin
        $dumpfile("proj.vcd");
        repeat(0) @(posedge(clk));
        $dumpvars(9,top);
        repeat(20000) @(posedge(clk));
        #1 $dumpoff();
    end

fpeng fpe(.Rclk(clk),.Rreset(reset),
    .Rwrite(ii.Rwrite),
    .Rxfr(ii.Rxfr),
    .Raddr(ii.Raddr[11:0]),
    .Rwdata(ii.Rwdata),
    .Rrdata(ii.Rrdata),
    .RdevselX(ii.RdevselX),
    .Sclk(clk),.Sreset(reset),
    .Srrequest(ii.Srrequest),
    .Srack(ii.Srack),
    .Sraddr(ii.Sraddr),
    .Srstrobe(ii.Srstrobe),
    .Srdata(ii.Srdata),
    .Swrequest(ii.Swrequest),
    .Swack(ii.Swack),
    .Swaddr(ii.Swaddr),
    .Swdata(ii.Swdata)
);

endmodule : top
