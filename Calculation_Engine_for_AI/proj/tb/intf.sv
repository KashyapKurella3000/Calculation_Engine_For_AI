// Contains the interface definitions for the project
//


interface proj_intf (input logic clk,Sclk,Rclk,
    output logic reset,input logic Sreset,Rreset);
// The S bus (SJSU bus to the accelerator(s) )
//    logic Sclock;
//    logic Sreset;
    logic Srrequest;
    logic Srack;
    SADDR Sraddr;
    logic Srstrobe;
    RDATA Srdata;
    logic Swrequest;
    logic Swack;
    SADDR Swaddr;
    WDATA Swdata;
// The R bus (register transfers)
//    logic Rclk;
//    logic Rreset;
    logic Rwrite;
    logic Rxfr;
    RegADDR Raddr;
    RegDATA Rwdata;
    RegDATA Rrdata;
    logic RdevselX;

    logic BAD; // indicates when an error occurs...



endinterface : proj_intf
