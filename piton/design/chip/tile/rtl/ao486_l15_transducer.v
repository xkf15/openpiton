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
    input [29:0]                    ao486_transducer_mem_address,
    input [31:0]                    ao486_transducer_mem_writedata,
    input [ 3:0]                    ao486_transducer_mem_byteenable,
    input [ 2:0]                    ao486_transducer_mem_burstcount,
    input                           ao486_transducer_mem_write,
    input                           ao486_transducer_mem_read,

    output                          transducer_ao486_mem_waitrequest,
    output                          transducer_ao486_mem_readdatavalid,
    output [31:0]                   transducer_ao486_mem_readdata,
    
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
   
    output                          transducer_l15_req_ack,
    output                          ao486_int
);

wire [31:0] ao486_mem_wdata_flipped;

assign ao486_mem_wdata_flipped = {  ao486_transducer_mem_writedata[7:0],
                                    ao486_transducer_mem_writedata[15:8],
                                    ao486_transducer_mem_writedata[23:16],
                                    ao486_transducer_mem_writedata[31:24]};

reg [1:0] req_size;
always @* begin
    case (ao486_transducer_mem_byteenable)
    4'b0001, 4'b0010, 4'b0100, 4'b1000: begin
        req_size = `PCX_SZ_1B;
    end
    4'b0011, 4'b0110, 4'b1100: begin
        req_size = `PCX_SZ_1B;
    end
    4'b0111, 4'b1110: begin
        req_size = `PCX_SZ_4B;
    end
    4'b1111: begin
        req_size = `PCX_SZ_4B;
    end
    endcase
end
reg transducer_l15_val_reg;
reg new_request_reg;
wire new_request; 
reg l15_transducer_ack_reg;
assign new_request = ao486_transducer_mem_write | ao486_transducer_mem_read | (double_access & (double_access_counter == 2'b10));
always @(posedge clk) begin
    new_request_reg <= new_request;
    l15_transducer_ack_reg <= l15_transducer_ack;
    if(~new_request_reg & new_request)
        transducer_l15_val_reg <= 1'b1;
    else if(l15_transducer_ack_reg & ~l15_transducer_ack)
        transducer_l15_val_reg <= 1'b0;
end

assign transducer_l15_val = transducer_l15_val_reg;
//--- ao486 -> L1.5
assign transducer_l15_rqtype =  ao486_transducer_mem_write ? `STORE_RQ :
                                ao486_transducer_mem_read  ? `LOAD_RQ : 
                                5'b0;
assign transducer_l15_amo_op = `L15_AMO_OP_NONE;
assign transducer_l15_size = req_size;
wire [31:0] transducer_l15_address_unshifted;
assign transducer_l15_address_unshifted = {{8{1'b0}}, ao486_transducer_mem_address, 2'b0};
wire [1:0] address_offset_byteenable;
assign address_offset_byteenable = ao486_transducer_mem_byteenable[0] ? 2'b00 : ao486_transducer_mem_byteenable[1] ? 2'b01 : ao486_transducer_mem_byteenable[2] ? 2'b10 : ao486_transducer_mem_byteenable[3] ? 2'b11 : 2'b00;
// assign transducer_l15_address = {{8{1'b0}}, ao486_transducer_mem_address, 2'b0} + address_offset_byteenable;
assign transducer_l15_data = {ao486_mem_wdata_flipped, ao486_mem_wdata_flipped};
assign transducer_l15_nc = ao486_transducer_mem_address[29];

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
reg transducer_ao486_mem_readdatavalid_reg;
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
reg double_access_reg;
reg transducer_ao486_mem_waitrequest_reg;
always @(posedge clk) begin
    double_access_reg <= double_access;
    if(new_request)
        transducer_ao486_mem_waitrequest_reg <= 1'b1;
    else if(l15_transducer_val & (read_count_reg == 2'b00))
        transducer_ao486_mem_waitrequest_reg <= 1'b0;
    else if(double_access_reg & ~ double_access)
        transducer_ao486_mem_waitrequest_reg <= 1'b0;
end

assign transducer_ao486_mem_waitrequest = transducer_ao486_mem_waitrequest_reg;// & ~l15_transducer_ack;


// assign transducer_ao486_mem_waitrequest = (ao486_transducer_mem_read | ao486_transducer_mem_write) & ~l15_transducer_ack;

assign transducer_ao486_mem_readdatavalid = transducer_ao486_mem_readdatavalid_reg;
assign transducer_ao486_mem_readdata = {rdata_part[7:0],
                                        rdata_part[15:8],
                                        rdata_part[23:16],
                                        rdata_part[31:24]};
assign transducer_l15_req_ack = l15_transducer_val & (((l15_transducer_returntype == `LOAD_RET) & (read_count_reg == 2'b00)) | (l15_transducer_returntype != `LOAD_RET));
reg double_access;
reg [1:0] double_access_counter;
wire [1:0] ao486_burstcount;
assign ao486_burstcount = (ao486_transducer_mem_burstcount - 1'b1);
always @(posedge clk) begin
    if (~rst_n) begin
        read_count_reg <= 2'b00;
    end
    else if (~new_request_reg & new_request) begin
        read_count_reg <= (ao486_transducer_mem_burstcount - 1'b1);
    end
    else if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & ~transducer_l15_req_ack) begin
        read_count_reg <= read_count_reg - 1'b1;
    end
end


always @(*) begin
    if (~rst_n) begin
        double_access <= 1'b0;
    end
    else if (ao486_transducer_mem_read) begin
        double_access <= ((ao486_burstcount == 2'b11) & ao486_transducer_mem_address[0]) | ((ao486_burstcount == 2'b11) & ao486_transducer_mem_address[1]) | ((ao486_burstcount == 2'b01) & ao486_transducer_mem_address[1] & ao486_transducer_mem_address[0]);
    end
    else if(double_access_counter == 2'b01) begin
        double_access <= 1'b0;
    end
end

reg ao486_transducer_mem_read_reg;
reg transducer_l15_req_ack_reg;
always@(posedge clk) begin
    transducer_l15_req_ack_reg <= transducer_l15_req_ack;
    ao486_transducer_mem_read_reg <= ao486_transducer_mem_read;
    if(~transducer_l15_req_ack_reg & transducer_l15_req_ack) 
        double_access_counter <= double_access_counter - 1'b1;
    else if(~ao486_transducer_mem_read_reg & ao486_transducer_mem_read)
        double_access_counter <= 2'b11;
end

wire [31:0] transducer_l15_address_first_access;
wire [31:0] transducer_l15_address_second_access;
reg [31:0] transducer_l15_address_reg;
assign transducer_l15_address_second_access = {{8{1'b0}}, ao486_transducer_mem_address [29:2] + 4'h1, 4'h0};
assign transducer_l15_address_first_access = {{8{1'b0}}, ao486_transducer_mem_address, 2'b0};

always@(*) begin
    if(ao486_transducer_mem_read)
        transducer_l15_address_reg <= transducer_l15_address_first_access;
    else if(double_access_counter == 2'b10)
        transducer_l15_address_reg <= transducer_l15_address_second_access;
end

assign transducer_l15_address = transducer_l15_address_reg;
wire [2:0] word_select;
assign word_select = {1'b0, (~read_count_reg)} + {1'b0, transducer_l15_address_first_access[3:2]};
always @(*) begin
    if(double_access & l15_transducer_val) begin
        case(word_select)
            3'b000: begin
                rdata_part <= l15_transducer_data_0_buffer_double_access[63:32];
            end
            3'b001: begin
                rdata_part <= l15_transducer_data_0_buffer_double_access[31:0];
            end
            3'b010: begin
                rdata_part <= l15_transducer_data_1_buffer_double_access[63:32];
            end
            3'b011: begin
                rdata_part <= l15_transducer_data_1_buffer_double_access[31:0];
            end
             3'b100: begin
                rdata_part <= l15_transducer_data_2_buffer_double_access[63:32];
            end
            3'b101: begin
                rdata_part <= l15_transducer_data_2_buffer_double_access[31:0];
            end
            3'b110: begin
                rdata_part <= l15_transducer_data_3_buffer_double_access[63:32];
            end
        endcase 
    end
    else if(~double_access & l15_transducer_val) begin
        case((~read_count_reg) + transducer_l15_address[3:2])
            2'b00: begin
                rdata_part <= l15_transducer_data_0_buffer_double_access[63:32];
            end
            2'b01: begin
                rdata_part <= l15_transducer_data_0_buffer_double_access[31:0];
            end
            2'b10: begin
                rdata_part <= l15_transducer_data_1_buffer_double_access[63:32];
            end
            2'b11: begin
                rdata_part <= l15_transducer_data_1_buffer_double_access[31:0];
            end
        endcase 
    end
end

reg [63:0] l15_transducer_data_0_buffer_double_access, l15_transducer_data_1_buffer_double_access;
reg [63:0] l15_transducer_data_2_buffer_double_access, l15_transducer_data_3_buffer_double_access;
always @(*) begin
    if(l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & (double_access_counter == 2'b11))begin
        l15_transducer_data_0_buffer_double_access <= l15_transducer_data_0;
        l15_transducer_data_1_buffer_double_access <= l15_transducer_data_1;
    end
    else if(l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & (double_access_counter == 2'b10))begin
        l15_transducer_data_2_buffer_double_access <= l15_transducer_data_0;
        l15_transducer_data_3_buffer_double_access <= l15_transducer_data_1;
    end
end


always @* begin
    if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & ~double_access) begin
        transducer_ao486_mem_readdatavalid_reg <= 1'b1;
    end
    else if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & double_access & (double_access_counter == 2'b10)) begin
        transducer_ao486_mem_readdatavalid_reg <= 1'b1;
    end
    else begin
        transducer_ao486_mem_readdatavalid_reg <= 1'b0;
    end
end

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
