// Define types for the declarations
typedef logic [47:0] SADDR;
typedef logic [351:0] RDATA;
typedef logic [175:0] WDATA;
typedef logic [63:0] RegADDR;
typedef logic [63:0] RegDATA;

const RegADDR RActl=0;
const RegADDR RAfetchaddr=8;
const RegADDR RAfetchlen=64'h10;
const RegADDR RAstoreaddr=64'h18;

const RegADDR DEV0A=64'h5e00_0000_0000_0000;

typedef struct packed {
    logic sign;
    logic [4:0] exp;
    logic [4:0] mant;
} FP11;
