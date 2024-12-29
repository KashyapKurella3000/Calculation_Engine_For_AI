// Messages passed around the test bench

typedef struct packed {
    SADDR addr;
    RDATA rdata;
} WMEM;

typedef enum {
    DCreset,
    DCwreg,
    DCstall,
    DCsetmem,
    DCwaitbusy
} DrvCMD;

class DrvMsg extends uvm_sequence_item;
    DrvCMD cmd;
    RegADDR reg_addr;
    RegDATA reg_data;
    WMEM wm;
    int cycles;
endclass : DrvMsg

class OPS ;
    FP11 A;
    FP11 B;
endclass : OPS

class G4A ;
    FP11 [3:0] A;
    FP11 [3:0] B;
endclass : G4A

class DT352;
    FP11 [15:0] A;
    FP11 [15:0] B;
    SADDR addr;
    logic ack;
endclass : DT352

class DT176;
    FP11 [15:0] A;
    SADDR addr;
    function new(SADDR adr,FP11 [15:0] wdata);
        A=wdata;
        addr=adr;
    endfunction : new
endclass : DT176

class CK1;
    logic A;
    string msg;
    function new(logic a,string m);
        this.A=a;
        this.msg=m;
    endfunction : new
endclass : CK1

class CKSADDR;
    SADDR A;
    string msg;
    function new(SADDR a,string m);
        this.A=a;
        this.msg=m;
    endfunction : new
endclass : CKSADDR

class WDTREQ;
    int cycnt;
    string msg;
    function new(int cnt, string m);
        this.cycnt=cnt;
        this.msg=m;
    endfunction : new
endclass : WDTREQ



