/*
Copyright (c) 2018 Princeton University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of Princeton University nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY PRINCETON UNIVERSITY "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL PRINCETON UNIVERSITY BE LIABLE FOR ANY
DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
(INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
(INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
module ao486_l15_transducer (
    input                           clk,
    input                           rst_n,

    // Avalon memory bus
    //input [29:0]                    ao486_transducer_mem_address,
    //input [31:0]                    ao486_transducer_mem_writedata,
    //input [ 3:0]                    ao486_transducer_mem_byteenable,
    //input [ 2:0]                    ao486_transducer_mem_burstcount,
    //input                           ao486_transducer_mem_write,
    //input                           ao486_transducer_mem_read,

    //output                          transducer_ao486_mem_waitrequest,
    //output                          transducer_ao486_mem_readdatavalid,
    //output [31:0]                   transducer_ao486_mem_readdata,
    //RESP:
    input               writeburst_do,
    output              writeburst_done,
    
    input       [31:0]  writeburst_address,
    input       [1:0]   writeburst_dword_length,
    input       [3:0]   writeburst_byteenable_0,
    input       [3:0]   writeburst_byteenable_1,
    input       [55:0]  writeburst_data,
    //END
    
    //RESP:
    input               writeline_do,
    output              writeline_done,
    
    input       [31:0]  writeline_address,
    input       [127:0] writeline_line,
    //END
    
    //RESP:
    input               readburst_do,
    output              readburst_done,
    
    input       [31:0]  readburst_address,
    input       [1:0]   readburst_dword_length,
    input       [3:0]   readburst_byte_length,
    output      [95:0]  readburst_data,
    //END
    
    //RESP:
    input               readline_do,
    output              readline_done,
    
    input       [31:0]  readline_address,
    output      [127:0] readline_line,
    //END
    
    //RESP:
    input               readcode_do,
    output              readcode_done,
    
    input       [31:0]  readcode_address,
    output      [127:0] readcode_line,
    output      [31:0]  readcode_partial,
    output              readcode_partial_done,
    //END
    
    // Avalon io bus
    input [15:0]                    ao486_transducer_io_address,
    input [ 3:0]                    ao486_transducer_io_byteenable,

    input                           ao486_transducer_io_read,
    output                          transducer_ao486_io_readdatavalid,
    output [31:0]                   transducer_ao486_io_readdata,

    input                           ao486_transducer_io_write,
    input [31:0]                    ao486_transducer_io_writedata,

    output                          transducer_ao486_io_waitrequest,
    
    input                           l15_transducer_ack,
    input                           l15_transducer_header_ack,

    // outputs ao486 uses                    
    output [4:0]                    transducer_l15_rqtype,
    output [`L15_AMO_OP_WIDTH-1:0]  transducer_l15_amo_op,
    output [2:0]                    transducer_l15_size,
    output                          transducer_l15_val,
    output [`PHY_ADDR_WIDTH-1:0]    transducer_l15_address,
    output [63:0]                   transducer_l15_data,
    output                          transducer_l15_nc,


    // outputs ao486 doesn't use                    
    output [0:0]                    transducer_l15_threadid,
    output                          transducer_l15_prefetch,
    output                          transducer_l15_invalidate_cacheline,
    output                          transducer_l15_blockstore,
    output                          transducer_l15_blockinitstore,
    output [1:0]                    transducer_l15_l1rplway,
    output [63:0]                   transducer_l15_data_next_entry,
    output [32:0]                   transducer_l15_csm_data,

    //--- L1.5 -> ao486
    input                           l15_transducer_val,
    input [3:0]                     l15_transducer_returntype,
    
    input [63:0]                    l15_transducer_data_0,
    input [63:0]                    l15_transducer_data_1,
    input [63:0]                    l15_transducer_data_2,
    input [63:0]                    l15_transducer_data_3,
   
    output                          transducer_l15_req_ack,
    output                          ao486_int
);

wire any_req;

assign any_req = writeburst_do | writeline_do | readburst_do | readline_do | readcode_do;

wire [64:0] ao486_mem_wdata_0_flipped;
wire [64:0] ao486_mem_wdata_1_flipped;

assign ao486_mem_wdata_0_flipped = {  writeline_line[7:0],
                                      writeline_line[15:8],
                                      writeline_line[23:16],
                                      writeline_line[31:24],
                                      writeline_line[39:32],
                                      writeline_line[47:40],
                                      writeline_line[55:48],
                                      writeline_line[63:56]};

assign ao486_mem_wdata_1_flipped = {  writeline_line[71:64],
                                      writeline_line[79:72],
                                      writeline_line[87:80],
                                      writeline_line[95:88],
                                      writeline_line[103:96],
                                      writeline_line[111:104],
                                      writeline_line[119:112],
                                      writeline_line[127:120]};

localparam ACK_IDLE = 1'b0;
localparam ACK_WAIT = 1'b1;

reg current_val;
reg prev_val;
// is this a new request from the core?
wire new_request = current_val & ~prev_val;
always @ (posedge clk)
begin
    if (!rst_n) begin
       current_val <= 1'b0;
       prev_val <= 1'b0;
    end
    else begin
       current_val <= any_req;
       prev_val <= current_val;
    end
end 

// are we waiting for an ack
reg ack_reg;
reg ack_next;
always @ (posedge clk) begin
    if (!rst_n) begin
        ack_reg <= 1'b0;
    end
    else begin
        ack_reg <= ack_next;
    end
end

always @ (*) begin
    // be careful with these conditionals.
    if (l15_transducer_ack) begin
        ack_next = ACK_IDLE;
    end
    else if (new_request) begin
        ack_next = ACK_WAIT;
    end
    else begin
        ack_next = ack_reg;
    end
end

reg [1:0] req_size;
reg [31:0] req_addr;
always @* begin
    req_size = `PCX_SZ_1B;
    req_addr = 32'b0;
    if (writeline_do) begin
        req_size = `PCX_SZ_16B;
        req_addr = writeline_address;
    end
    else if (readline_do) begin
        req_size = `PCX_SZ_16B;
        req_addr = readline_address;
    end
    else if (readcode_do) begin
        req_size = `PCX_SZ_16B;
        req_addr = readcode_address;
    end
end

assign transducer_l15_val = (ack_reg == ACK_WAIT) ? any_req
                         : (ack_reg == ACK_IDLE) ? new_request
                         : any_req;
//--- ao486 -> L1.5
assign transducer_l15_rqtype =  writeburst_do | writeline_do ? `STORE_RQ :
                                readburst_do | readline_do   ? `LOAD_RQ : 
                                readcode_do ? `IMISS_RQ :
                                5'b0;
assign transducer_l15_amo_op = `L15_AMO_OP_NONE;
assign transducer_l15_size = req_size;
//assign transducer_l15_address = {{8{ao486_transducer_mem_address[29]}}, ao486_transducer_mem_address, 2'b0};
assign transducer_l15_address = {{8{req_addr[31]}}, req_addr[31:4], 4'b0};
assign transducer_l15_data = ao486_mem_wdata_0_flipped;
assign transducer_l15_nc = req_addr[31];

// unused wires tie to zero
assign transducer_l15_threadid = 1'b0;
assign transducer_l15_prefetch = 1'b0;
assign transducer_l15_invalidate_cacheline = 1'b0;
assign transducer_l15_blockstore = 1'b0;
assign transducer_l15_blockinitstore = 1'b0;
assign transducer_l15_l1rplway = 2'b0;
assign transducer_l15_data_next_entry = 64'b0;
assign transducer_l15_csm_data = 33'b0;

//--- L1.5 -> ao486
//reg transducer_ao486_mem_readdatavalid_reg;
reg [31:0] rdata_part;
reg [1:0] read_count_reg;

// keep track of whether we have received the wakeup interrupt
reg ao486_int_reg;
reg int_recv;
assign ao486_int = ao486_int_reg;
always @ (posedge clk) begin
    if (~rst_n) begin
        ao486_int_reg <= 1'b0;
    end
    else if (int_recv) begin
        ao486_int_reg <= 1'b1;
    end
    else if (ao486_int_reg) begin
        ao486_int_reg <= 1'b0;
    end
end
       
//assign transducer_ao486_mem_waitrequest = (ao486_transducer_mem_read | ao486_transducer_mem_write) & ~l15_transducer_ack;

//assign transducer_ao486_mem_readdatavalid = transducer_ao486_mem_readdatavalid_reg;
//assign transducer_ao486_mem_readdata = {rdata_part[7:0],
//                                        rdata_part[15:8],
//                                        rdata_part[23:16],
//                                        rdata_part[31:24]};
assign transducer_l15_req_ack = l15_transducer_val;

//always @(posedge clk) begin
//    if (~rst_n) begin
//        read_count_reg <= 2'b00;
//    end
//    else if (ao486_transducer_mem_read) begin
//        read_count_reg <= (ao486_transducer_mem_burstcount - 1'b1);
//    end
//    else if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & ~transducer_l15_req_ack) begin
//        read_count_reg <= read_count_reg - 1'b1;
//    end
//end

assign writeburst_done = 1'b0;

assign writeline_done = l15_transducer_val & (l15_transducer_returntype == `ST_ACK);

assign readburst_done = 1'b0;

assign readline_line = {l15_transducer_data_1, l15_transducer_data_0};
assign readline_done = l15_transducer_val & (l15_transducer_returntype == `LOAD_RET);

assign readcode_line = req_addr[4] ? {l15_transducer_data_3, l15_transducer_data_2} : {l15_transducer_data_1, l15_transducer_data_0};
assign readcode_done = l15_transducer_val & (l15_transducer_returntype == `IFILL_RET);

//always @* begin
//    case((~read_count_reg) + transducer_l15_address[3:2])
//    2'b00: begin
//       rdata_part = l15_transducer_data_0[63:32];
//    end
//    2'b01: begin
//       rdata_part = l15_transducer_data_0[31:0];
//    end
//    2'b10: begin
//       rdata_part = l15_transducer_data_1[63:32];
//    end
//    2'b11: begin
//       rdata_part = l15_transducer_data_1[31:0];
//    end
//    endcase 
//end

//always @* begin
//    if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET)) begin
//        transducer_ao486_mem_readdatavalid_reg = 1'b1;
//    end
//    else begin
//        transducer_ao486_mem_readdatavalid_reg = 1'b0;
//    end
//end

always @ * begin
   if (l15_transducer_val) begin
      case(l15_transducer_returntype)
        `LOAD_RET:
          begin
             // load
             int_recv = 1'b0;
          end
        `ST_ACK:
          begin
             int_recv = 1'b0;
          end
        `INT_RET:
          begin
             if (l15_transducer_data_0[17:16] == 2'b01) begin
                int_recv = 1'b1;
             end
             else begin
                int_recv = 1'b0;
             end
          end
        default: begin
           int_recv = 1'b0;
        end
      endcase 
   end
   else begin
       int_recv = 1'b0;
   end
end

endmodule
