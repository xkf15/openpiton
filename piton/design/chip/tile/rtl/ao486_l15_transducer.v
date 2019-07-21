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
    input [3:0]                     ao486_transducer_mem_byteenable,
    input [2:0]                     ao486_transducer_mem_burstcount,
    input                           ao486_transducer_mem_write,
    input                           ao486_transducer_mem_read,
    input [1:0]                     state_transducer,
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
    input [63:0]                    l15_transducer_data_2,
    input [63:0]                    l15_transducer_data_3,
   
    output                          transducer_l15_req_ack,
    output                          ao486_int
);

localparam IDLE = 2'b00;
localparam NEW = 2'b01;
localparam BUSY = 2'b10;
localparam WRITE = 2'b11;
localparam READ = 2'b10;
reg [1:0] state_reg;
reg [1:0] state_next;
reg flop_bus;
reg [1:0] req_type_reg;
reg [1:0] req_type_next;
reg readcode_do_buf;


always @(*) begin
  flop_bus = 1'b0;
  case (state_reg)
    IDLE: begin
      if (ao486_transducer_mem_read | ao486_transducer_mem_write) begin
        state_next = NEW;
        req_type_next = ao486_transducer_mem_write ? WRITE : ao486_transducer_mem_read ? READ : IDLE;
      end
      else begin
        state_next = IDLE;
        req_type_next = IDLE;
      end
    end
    NEW: begin
      flop_bus = 1'b1;
      state_next = BUSY;
    end
    BUSY: begin
      
      if (((req_type_reg == READ) & (double_access_counter == 2'b10) & l15_transducer_val & (double_access | double_access_ifill)) | ((req_type_reg == READ) & l15_transducer_val & ~(double_access | double_access_ifill)) | (l15_transducer_val & (req_type_reg == WRITE) & ~double_transfer_reg & (write_buf_count_arbit == (write_submit_count_arbit + 1'b1)))) begin
        if (ao486_transducer_mem_read | ao486_transducer_mem_write) begin
          state_next = NEW;
          req_type_next = ao486_transducer_mem_write ? WRITE : ao486_transducer_mem_read ? READ : IDLE;
        end else begin
          state_next = IDLE;
          req_type_next = IDLE;
        end
      end else begin
        state_next = BUSY;
      end
    end
  endcase
end

always @(posedge clk) begin
  if (~rst_n) begin
    state_reg <= IDLE;
  end else begin
    state_reg <= state_next;
    req_type_reg <= req_type_next;
  end
end

reg [29:0] addr_reg;
reg [3:0] byteenable_reg;

always @(posedge clk) begin
  if (~rst_n) begin
    addr_reg <= 40'b0;
    byteenable_reg <= 4'b0;
  end else if (flop_bus) begin
    addr_reg <= ao486_transducer_mem_address;
    byteenable_reg <= ao486_transducer_mem_byteenable;
  end
end

wire [31:0] ao486_mem_wdata_flipped;
reg [31:0] ao486_transducer_mem_writedata_buffer_0, ao486_transducer_mem_writedata_buffer_1, ao486_transducer_mem_writedata_buffer_2, ao486_transducer_mem_writedata_buffer_3;
reg [3:0] ao486_transducer_mem_byteenable_buffer_0, ao486_transducer_mem_byteenable_buffer_1, ao486_transducer_mem_byteenable_buffer_2, ao486_transducer_mem_byteenable_buffer_3;
reg [2:0] write_buf_count_arbit;
reg write_buf_complete_waitrequest;

always @(posedge clk) begin
    if(~rst_n)
        write_buf_count_arbit <= 3'b000;
    else if(ao486_transducer_mem_write & ((write_buf_count_arbit == 2'b00) | (write_buf_count_arbit == 3'b100)) & ~write_buf_complete_waitrequest) begin
        ao486_transducer_mem_writedata_buffer_0 <= ao486_transducer_mem_writedata;
        ao486_transducer_mem_byteenable_buffer_0 <= ao486_transducer_mem_byteenable;
        write_buf_count_arbit <= write_buf_count_arbit + 1'b1;
        write_buf_complete_waitrequest <= (ao486_transducer_mem_burstcount == (write_buf_count_arbit + 1'b1)) ? 1'b1 : 1'b0;
    end
    else if(ao486_transducer_mem_write & (write_buf_count_arbit == 2'b01) & ~write_buf_complete_waitrequest) begin
        ao486_transducer_mem_writedata_buffer_1 <= ao486_transducer_mem_writedata;
        ao486_transducer_mem_byteenable_buffer_1 <= ao486_transducer_mem_byteenable;
        write_buf_count_arbit <= (write_buf_complete_waitrequest) ? write_buf_count_arbit : write_buf_count_arbit + 1'b1;
        write_buf_complete_waitrequest <= (ao486_transducer_mem_burstcount == (write_buf_count_arbit + 1'b1)) ? 1'b1 : 1'b0;
    end
    else if(ao486_transducer_mem_write & (write_buf_count_arbit == 2'b10) & ~write_buf_complete_waitrequest) begin
        ao486_transducer_mem_writedata_buffer_2 <= ao486_transducer_mem_writedata;
        ao486_transducer_mem_byteenable_buffer_2 <= ao486_transducer_mem_byteenable;
        write_buf_count_arbit <= (write_buf_complete_waitrequest) ? write_buf_count_arbit : write_buf_count_arbit + 1'b1;
        write_buf_complete_waitrequest <= (ao486_transducer_mem_burstcount == (write_buf_count_arbit + 1'b1)) ? 1'b1 : 1'b0;
    end
    else if(ao486_transducer_mem_write & (write_buf_count_arbit == 2'b11) & ~write_buf_complete_waitrequest) begin
        ao486_transducer_mem_writedata_buffer_3 <= ao486_transducer_mem_writedata;
        ao486_transducer_mem_byteenable_buffer_3 <= ao486_transducer_mem_byteenable;
        write_buf_count_arbit <= (write_buf_complete_waitrequest) ? write_buf_count_arbit : write_buf_count_arbit + 1'b1;
        write_buf_complete_waitrequest <= (ao486_transducer_mem_burstcount == (write_buf_count_arbit + 1'b1)) ? 1'b1 : 1'b0;
    end
end

wire [31:0] ao486_transducer_mem_writedata_buffer_0_flipped, ao486_transducer_mem_writedata_buffer_1_flipped, ao486_transducer_mem_writedata_buffer_2_flipped, ao486_transducer_mem_writedata_buffer_3_flipped;
wire [3:0] ao486_transducer_mem_byteenable_buffer_0_flipped, ao486_transducer_mem_byteenable_buffer_1_flipped, ao486_transducer_mem_byteenable_buffer_2_flipped, ao486_transducer_mem_byteenable_buffer_3_flipped;

assign ao486_transducer_mem_writedata_buffer_0_flipped = {  ao486_transducer_mem_writedata_buffer_0[7:0],
                                                            ao486_transducer_mem_writedata_buffer_0[15:8],
                                                            ao486_transducer_mem_writedata_buffer_0[23:16],
                                                            ao486_transducer_mem_writedata_buffer_0[31:24]};

assign ao486_transducer_mem_writedata_buffer_1_flipped = {  ao486_transducer_mem_writedata_buffer_1[7:0],
                                                            ao486_transducer_mem_writedata_buffer_1[15:8],
                                                            ao486_transducer_mem_writedata_buffer_1[23:16],
                                                            ao486_transducer_mem_writedata_buffer_1[31:24]};

assign ao486_transducer_mem_writedata_buffer_2_flipped = {  ao486_transducer_mem_writedata_buffer_2[7:0],
                                                            ao486_transducer_mem_writedata_buffer_2[15:8],
                                                            ao486_transducer_mem_writedata_buffer_2[23:16],
                                                            ao486_transducer_mem_writedata_buffer_2[31:24]};

assign ao486_transducer_mem_writedata_buffer_3_flipped = {  ao486_transducer_mem_writedata_buffer_3[7:0],
                                                            ao486_transducer_mem_writedata_buffer_3[15:8],
                                                            ao486_transducer_mem_writedata_buffer_3[23:16],
                                                            ao486_transducer_mem_writedata_buffer_3[31:24]};

assign ao486_transducer_mem_byteenable_buffer_0_flipped = { ao486_transducer_mem_byteenable_buffer_0[0],
                                                            ao486_transducer_mem_byteenable_buffer_0[1],
                                                            ao486_transducer_mem_byteenable_buffer_0[2],
                                                            ao486_transducer_mem_byteenable_buffer_0[3]};

assign ao486_transducer_mem_byteenable_buffer_1_flipped = { ao486_transducer_mem_byteenable_buffer_1[0],
                                                            ao486_transducer_mem_byteenable_buffer_1[1],
                                                            ao486_transducer_mem_byteenable_buffer_1[2],
                                                            ao486_transducer_mem_byteenable_buffer_1[3]};

assign ao486_transducer_mem_byteenable_buffer_2_flipped = { ao486_transducer_mem_byteenable_buffer_2[0],
                                                            ao486_transducer_mem_byteenable_buffer_2[1],
                                                            ao486_transducer_mem_byteenable_buffer_2[2],
                                                            ao486_transducer_mem_byteenable_buffer_2[3]};

assign ao486_transducer_mem_byteenable_buffer_3_flipped = { ao486_transducer_mem_byteenable_buffer_3[0],
                                                            ao486_transducer_mem_byteenable_buffer_3[1],
                                                            ao486_transducer_mem_byteenable_buffer_3[2],
                                                            ao486_transducer_mem_byteenable_buffer_3[3]};

reg [31:0] ao486_transducer_mem_writedata_buffer_arbit;
reg [3:0] ao486_transducer_mem_byteenable_buffer_arbit;
always @(*) begin
    case(write_submit_count_arbit) 
        3'b000: ao486_transducer_mem_writedata_buffer_arbit = ao486_transducer_mem_writedata_buffer_0_flipped;
        3'b001: ao486_transducer_mem_writedata_buffer_arbit = ao486_transducer_mem_writedata_buffer_1_flipped;
        3'b010: ao486_transducer_mem_writedata_buffer_arbit = ao486_transducer_mem_writedata_buffer_2_flipped;
        3'b011: ao486_transducer_mem_writedata_buffer_arbit = ao486_transducer_mem_writedata_buffer_3_flipped;
    endcase
end

always @(*) begin
    case(write_submit_count_arbit) 
        3'b000: ao486_transducer_mem_byteenable_buffer_arbit = ao486_transducer_mem_byteenable_buffer_0_flipped;
        3'b001: ao486_transducer_mem_byteenable_buffer_arbit = ao486_transducer_mem_byteenable_buffer_1_flipped;
        3'b010: ao486_transducer_mem_byteenable_buffer_arbit = ao486_transducer_mem_byteenable_buffer_2_flipped;
        3'b011: ao486_transducer_mem_byteenable_buffer_arbit = ao486_transducer_mem_byteenable_buffer_3_flipped;
    endcase
end
reg [2:0] req_size_write;
reg [31:0] transducer_l15_address_reg_write;
reg [31:0] transducer_l15_data_reg_write;
reg [2:0] transducer_l15_req_size_reg_write;
reg [1:0] write_reg_count;
reg double_transfer_reg;
reg [2:0] req_size_double_transfer;
reg [31:0] ao486_transducer_mem_address_write_reg;
reg [31:0] ao486_transducer_mem_address_write_reg_double_transfer;
reg [31:0] ao486_transducer_mem_write_data_reg;
reg [31:0] ao486_transducer_mem_write_data_reg_double_transfer;

always @(*) begin
    if(req_type_reg == WRITE) begin
    case (ao486_transducer_mem_byteenable_buffer_arbit) 
        4'b0001, 4'b0010, 4'b0100, 4'b1000: begin
            req_size_write <= `PCX_SZ_1B;
                case(ao486_transducer_mem_byteenable_buffer_arbit) 
                    4'b0001: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd3);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[7:0], ao486_transducer_mem_writedata_buffer_arbit[7:0], ao486_transducer_mem_writedata_buffer_arbit[7:0], ao486_transducer_mem_writedata_buffer_arbit[7:0]};
                    end
                    4'b0010: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd2);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8]};
                    end
                    4'b0100: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd1);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16]};
                    end
                    4'b1000: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[31:24], ao486_transducer_mem_writedata_buffer_arbit[31:24], ao486_transducer_mem_writedata_buffer_arbit[31:24], ao486_transducer_mem_writedata_buffer_arbit[31:24]};
                    end
                endcase
        end

        4'b0011, 4'b1100: begin
            req_size_write <= `PCX_SZ_2B;
                case(ao486_transducer_mem_byteenable_buffer_arbit) 
                    4'b0011: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd2);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[15:0], ao486_transducer_mem_writedata_buffer_arbit[15:0]};
                    end
                    4'b1100: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[31:16], ao486_transducer_mem_writedata_buffer_arbit[31:16]};
                    end
                endcase
        end

        4'b1111: begin
            req_size_write <= `PCX_SZ_4B;
            ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf);
            ao486_transducer_mem_write_data_reg <= ao486_transducer_mem_writedata_buffer_arbit;
        end

        4'b0111, 4'b1110: begin
            req_size_write <= `PCX_SZ_1B;
            req_size_double_transfer <= `PCX_SZ_2B;
            double_transfer_reg = 1'b1;
                case(ao486_transducer_mem_byteenable_buffer_arbit) 
                    4'b0111: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd1);
                        ao486_transducer_mem_address_write_reg_double_transfer <= (transducer_l15_address_reg_write_buf + 2'd2);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16]};
                        ao486_transducer_mem_write_data_reg_double_transfer <= {ao486_transducer_mem_writedata_buffer_arbit[15:0], ao486_transducer_mem_writedata_buffer_arbit[15:0]};
                    end
                    4'b1110: begin
                        ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd2);
                        ao486_transducer_mem_address_write_reg_double_transfer <= (transducer_l15_address_reg_write_buf);
                        ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8]};
                        ao486_transducer_mem_write_data_reg_double_transfer <= {ao486_transducer_mem_writedata_buffer_arbit[31:16], ao486_transducer_mem_writedata_buffer_arbit[31:16]};
                    end
                endcase
        end
        
        4'b0110: begin
            req_size_write <= `PCX_SZ_1B;
            req_size_double_transfer <= `PCX_SZ_1B;
            double_transfer_reg = 1'b1;
            ao486_transducer_mem_address_write_reg <= (transducer_l15_address_reg_write_buf + 2'd1);
            ao486_transducer_mem_address_write_reg_double_transfer <= (transducer_l15_address_reg_write_buf + 2'd2);
            ao486_transducer_mem_write_data_reg <= {ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16], ao486_transducer_mem_writedata_buffer_arbit[23:16]};
            ao486_transducer_mem_write_data_reg_double_transfer <= {ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8], ao486_transducer_mem_writedata_buffer_arbit[15:8]};
        end
    endcase
    end
end


reg ao486_transducer_mem_write_reg;
reg ao486_l15_write;
reg [2:0] write_submit_count_arbit;
always @(posedge clk) begin
if(ao486_l15_write) begin
    if(~ao486_transducer_mem_write_reg & ao486_transducer_mem_write & ~write_buf_complete_waitrequest) begin
        write_submit_count_arbit <= 3'b000;
        write_reg_count <= 2'b00;
    end
    else if(l15_transducer_val & ~double_transfer_reg) begin
        write_submit_count_arbit <= write_submit_count_arbit + 1'b1;
        write_reg_count <= 2'b00;
    end
    else if(l15_transducer_val & double_transfer_reg) begin
        write_reg_count <= write_reg_count + 1'b1;
    end
    else if(l15_transducer_val & double_transfer_reg & (write_reg_count == 2'b10)) begin
        write_reg_count <= 2'b00;
        write_submit_count_arbit <= write_submit_count_arbit + 1'b1;
    end
    end
end

always @(*) begin
    if(request_new & (req_type_reg == WRITE)) begin
        ao486_l15_write = 1'b1;
    end
    else if(write_submit_count_arbit == write_buf_count_arbit) begin
        ao486_l15_write = 1'b0;
    end
end

always @(*) begin
    if(ao486_l15_write & ~double_transfer_reg & write_buf_complete_waitrequest) begin
        transducer_l15_address_reg_write <= ao486_transducer_mem_address_write_reg;
        transducer_l15_data_reg_write <= ao486_transducer_mem_write_data_reg;
        transducer_l15_req_size_reg_write <= req_size_write;
    end
    else if(ao486_l15_write & double_transfer_reg & (write_reg_count == 2'b00) & write_buf_complete_waitrequest) begin
        transducer_l15_address_reg_write <= ao486_transducer_mem_address_write_reg;
        transducer_l15_data_reg_write <= ao486_transducer_mem_write_data_reg;
        transducer_l15_req_size_reg_write <= req_size_write;
            end
    else if(ao486_l15_write & double_transfer_reg & (write_reg_count == 2'b01) & write_buf_complete_waitrequest) begin
        transducer_l15_address_reg_write <= ao486_transducer_mem_address_write_reg_double_transfer;
        transducer_l15_data_reg_write <= ao486_transducer_mem_write_data_reg_double_transfer;
        transducer_l15_req_size_reg_write <= req_size_double_transfer;
    end
end
always @(posedge clk) begin
    if(l15_transducer_val & (write_buf_count_arbit == (write_submit_count_arbit + 1'b1)) & ~double_transfer_reg) begin
        transducer_l15_val_reg_write <= 1'b0;
        write_buf_count_arbit <= 3'b000;
        write_buf_complete_waitrequest <= 1'b0;
    end
end

always @(*) begin
    if(l15_transducer_val & (write_reg_count == 2'b01))
        double_transfer_reg = 1'b0;
end

always @(posedge clk) begin
    if(request_new & (req_type_reg == WRITE)) begin
        transducer_l15_address_reg_write_buf <= transducer_l15_address_first_access;
        transducer_l15_val_reg_write <= 1'b1;
    end
    else if(l15_transducer_val & ao486_l15_write & ~double_transfer_reg)
        transducer_l15_address_reg_write_buf <= transducer_l15_address_reg_write_buf + 3'd4;
end

// assign ao486_mem_wdata_flipped = {  ao486_transducer_mem_writedata[7:0],
//                                     ao486_transducer_mem_writedata[15:8],
//                                     ao486_transducer_mem_writedata[23:16],
//                                     ao486_transducer_mem_writedata[31:24]};
reg [2:0] req_size_read;
always @* begin
    case (byteenable_reg)
    4'b0001, 4'b0010, 4'b0100, 4'b1000: begin
        req_size_read = `PCX_SZ_1B;
    end
    4'b0011, 4'b0110, 4'b1100: begin
        req_size_read = `PCX_SZ_2B;
    end
    4'b0111, 4'b1110: begin
        req_size_read = `PCX_SZ_4B;
    end
    4'b1111: begin
        req_size_read = `PCX_SZ_4B;
    end
    endcase
end

reg current_val;
reg prev_val;
// is this a new request from the core?
wire request_new;
assign request_new = ~current_val & prev_val;

always @ (posedge clk)
begin
    if (!rst_n) begin
       current_val <= 1'b0;
       prev_val <= 1'b0;
    end
    else begin
       current_val <= ao486_transducer_mem_read | ao486_transducer_mem_write;
       prev_val <= current_val;
    end
end 

reg transducer_l15_val_reg;
reg transducer_l15_val_reg_write;

reg new_request_reg;
reg new_request; 
assign new_request = current_val_trans & ~prev_val_trans;

reg current_val_trans;
reg prev_val_trans;

always @ (posedge clk)
begin
    if (!rst_n) begin
       current_val_trans <= 1'b0;
       prev_val_trans <= 1'b0;
    end
    else begin
       current_val_trans <= (state_reg == BUSY) & (((double_access | double_access_ifill) & (double_access_counter == 2'b10)) | (double_transfer_reg & (write_reg_count == 2'b01)));
       prev_val_trans <= current_val_trans;
    end
end 

always @(*) begin
    if((state_reg == BUSY) & (req_type_reg == READ)) begin
        if(request_new | new_request)
            transducer_l15_val_reg = 1'b1;
        else if(l15_transducer_ack)
            transducer_l15_val_reg = 1'b0;
    end
end

assign transducer_l15_val = (req_type_reg == 2'b10) ? transducer_l15_val_reg : (req_type_reg == 2'b11) ? transducer_l15_val_reg_write : transducer_l15_val_reg;

assign transducer_l15_address = (req_type_reg == 2'b10) ? transducer_l15_address_reg : (req_type_reg == 2'b11) ? transducer_l15_address_reg_write : transducer_l15_address_reg;

reg readcode_do_ifill_reg;

always @(*) begin
    if(state_transducer == 2'd3)
        readcode_do_ifill_reg = 1'b1;
    else 
        readcode_do_ifill_reg = 1'b0;

end

//--- ao486 -> L1.5
assign transducer_l15_rqtype =  (req_type_reg == WRITE) ? `STORE_RQ :
                                (req_type_reg == READ) & readcode_do_ifill_reg ? `IMISS_RQ :
                                (req_type_reg == READ) ? `LOAD_RQ : 
                                5'b0;
assign transducer_l15_amo_op = `L15_AMO_OP_NONE;
assign transducer_l15_size = (req_type_reg == 2'b10) ? req_size_read : (req_type_reg == 2'b11) ? transducer_l15_req_size_reg_write : req_size_read;
wire [31:0] transducer_l15_address_unshifted;
assign transducer_l15_address_unshifted = {{8{1'b0}}, addr_reg, 2'b0};
wire [1:0] address_offset_byteenable;
assign address_offset_byteenable = ao486_transducer_mem_byteenable[0] ? 2'b00 : ao486_transducer_mem_byteenable[1] ? 2'b01 : ao486_transducer_mem_byteenable[2] ? 2'b10 : ao486_transducer_mem_byteenable[3] ? 2'b11 : 2'b00;

assign transducer_l15_data = {transducer_l15_data_reg_write, transducer_l15_data_reg_write};
assign transducer_l15_nc = addr_reg[29];

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
    double_access_reg <= double_access;
    double_access_ifill_reg <= double_access_ifill;
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
reg double_access_ifill_reg;
reg transducer_ao486_mem_waitrequest_reg;
always @(*) begin
    if(request_new & (req_type_reg == READ))
        transducer_ao486_mem_waitrequest_reg = 1'b1;
    else if(l15_transducer_val & (read_count_reg == 2'b00) & ~double_access & ~double_access_ifill)
        transducer_ao486_mem_waitrequest_reg = 1'b0;
    else if(double_access_reg & ~double_access)
        transducer_ao486_mem_waitrequest_reg = 1'b0;
    else if(double_access_ifill_reg & ~double_access_ifill)
        transducer_ao486_mem_waitrequest_reg = 1'b0;
end

assign transducer_ao486_mem_waitrequest = (req_type_reg == 2'b10) ? transducer_ao486_mem_waitrequest_reg : (req_type_reg == 2'b11) ? write_buf_complete_waitrequest : transducer_ao486_mem_waitrequest_reg ;// & ~l15_transducer_ack;


// assign transducer_ao486_mem_waitrequest = (ao486_transducer_mem_read | ao486_transducer_mem_write) & ~l15_transducer_ack;

assign transducer_ao486_mem_readdatavalid = transducer_ao486_mem_readdatavalid_reg;
assign transducer_ao486_mem_readdata = {rdata_part[7:0],
                                        rdata_part[15:8],
                                        rdata_part[23:16],
                                        rdata_part[31:24]};
assign transducer_l15_req_ack = l15_transducer_val & ((((l15_transducer_returntype == `LOAD_RET) | (l15_transducer_returntype == `IFILL_RET)) & (read_count_reg == 2'b00)) | ((l15_transducer_returntype != `LOAD_RET) & (l15_transducer_returntype != `IFILL_RET)));
reg double_access;
reg [1:0] double_access_counter;
reg double_access_ifill;
wire [1:0] ao486_burstcount;
assign ao486_burstcount = (ao486_transducer_mem_burstcount - 1'b1);
always @(posedge clk) begin
    if (~rst_n) begin
        read_count_reg <= 2'b00;
    end
    else if (request_new | new_request) begin
        read_count_reg <= (ao486_transducer_mem_burstcount - 1'b1);
    end
    else if (l15_transducer_val & ((l15_transducer_returntype == `LOAD_RET) | (l15_transducer_returntype == `IFILL_RET)) & ~transducer_l15_req_ack) begin
        read_count_reg <= read_count_reg - 1'b1;
    end
end

wire check_double_access, check_double_access_ifill;
assign check_double_access_ifill = check_double_access & addr_reg[2];
assign check_double_access = ((ao486_burstcount == 2'b11) & addr_reg[0]) | ((ao486_burstcount == 2'b11) & addr_reg[1]) | ((ao486_burstcount == 2'b01) & addr_reg[1] & addr_reg[0]);
always @(*) begin
    if (~rst_n) begin
        double_access = 1'b0;
        double_access_ifill = 1'b0;
    end
    else if (request_new & ~readcode_do_ifill_reg & (req_type_reg == READ)) begin
        double_access = (state_reg == BUSY) & check_double_access;
    end
    else if (request_new & readcode_do_ifill_reg & (req_type_reg == READ)) begin
        double_access_ifill = (state_reg == BUSY) & check_double_access_ifill;
    end
    else if(double_access_counter == 2'b01) begin
        double_access = 1'b0;
        double_access_ifill = 1'b0;

    end
end

reg ao486_transducer_mem_read_reg;
reg transducer_l15_req_ack_reg;

always@(posedge clk) begin
    ao486_transducer_mem_read_reg <= ao486_transducer_mem_read;
    if(transducer_l15_req_ack) 
        double_access_counter <= double_access_counter - 1'b1;
    else if(request_new & (req_type_reg == READ)) begin
        double_access_counter <= 2'b11;
    end
end
reg [31:0] transducer_l15_address_reg_write_buf;
wire [31:0] transducer_l15_address_first_access;
wire [31:0] transducer_l15_address_second_access;
wire [31:0] transducer_l15_address_ifill;
wire [31:0] transducer_l15_address_ifill_second_access;
reg [31:0] transducer_l15_address_reg;

assign transducer_l15_address_second_access = {{8{1'b0}}, addr_reg [29:2] + 4'h1, 4'h0};
assign transducer_l15_address_first_access = {{8{1'b0}}, addr_reg, 2'b0};
assign transducer_l15_address_ifill = {{8{1'b0}}, addr_reg[29:3], 5'b0};
assign transducer_l15_address_ifill_second_access = transducer_l15_address_second_access;

always@(*) begin
    if((state_reg == BUSY) & (req_type_reg == READ)) begin
        if(request_new & readcode_do_ifill_reg)
            transducer_l15_address_reg = transducer_l15_address_ifill;
        else if(request_new & ~readcode_do_ifill_reg)
            transducer_l15_address_reg = transducer_l15_address_first_access;
        else if(double_access_counter == 2'b10)
            transducer_l15_address_reg = transducer_l15_address_second_access;
    end
end

// assign transducer_l15_address = (req_type_reg == 2'b10) ? transducer_l15_address_reg : (req_type_reg == 2'b11) ? transducer_l15_address_reg_write : transducer_l15_address_reg;
wire [2:0] word_select;
// wire [3:0] word_select_ifill;
assign word_select = {1'b0, (~read_count_reg)} + {1'b0, transducer_l15_address_first_access[3:2]};
// assign word_select_ifill = {1'b0, (~read_count_reg)} + {1'b0, transducer_l15_address_first_access[4:2]};
always @(*) begin
    if(double_access & l15_transducer_val & ~readcode_do_ifill_reg) begin
        case(word_select)
            3'b000: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[63:32];
            end
            3'b001: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[31:0];
            end
            3'b010: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[63:32];
            end
            3'b011: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[31:0];
            end
            3'b100: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[63:32];
            end
            3'b101: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[31:0];
            end
            3'b110: begin
                rdata_part = l15_transducer_data_3_buffer_double_access[63:32];
            end
        endcase 
    end
    else if(~double_access & l15_transducer_val & ~readcode_do_ifill_reg) begin
        case(word_select)
            3'b000: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[63:32];
            end
            3'b001: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[31:0];
            end
            3'b010: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[63:32];
            end
            3'b011: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[31:0];
            end
            3'b100: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[31:0];
            end
            3'b101: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[63:32];
            end
            3'b110: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[31:0];
            end
        endcase 
    end
    else if(~double_access & l15_transducer_val & readcode_do_ifill_reg) begin
    case(transducer_l15_address_first_access[4])
        1'b0: begin
            case(word_select)
            3'b000: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[63:32];
            end
            3'b001: begin
                rdata_part = l15_transducer_data_0_buffer_double_access[31:0];
            end
            3'b010: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[63:32];
            end
            3'b011: begin
                rdata_part = l15_transducer_data_1_buffer_double_access[31:0];
            end
            3'b100: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[63:32];
            end
            3'b101: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[31:0];
            end
            3'b110: begin
                rdata_part = l15_transducer_data_3_buffer_double_access[63:32];
            end
        endcase
        end
        1'b1: begin
            case(word_select)
            3'b000: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[63:32];
            end
            3'b001: begin
                rdata_part = l15_transducer_data_2_buffer_double_access[31:0];
            end
            3'b010: begin
                rdata_part = l15_transducer_data_3_buffer_double_access[63:32];
            end
            3'b011: begin
                rdata_part = l15_transducer_data_3_buffer_double_access[31:0];
            end
            3'b100: begin
                rdata_part = l15_transducer_data_4_buffer_double_access[63:32];
            end
            3'b101: begin
                rdata_part = l15_transducer_data_4_buffer_double_access[31:0];
            end
            3'b110: begin
                rdata_part = l15_transducer_data_5_buffer_double_access[63:32];
            end
        endcase
        end
    endcase 
    end
end

reg [63:0] l15_transducer_data_0_buffer_double_access, l15_transducer_data_1_buffer_double_access;
reg [63:0] l15_transducer_data_2_buffer_double_access, l15_transducer_data_3_buffer_double_access;
reg [63:0] l15_transducer_data_4_buffer_double_access, l15_transducer_data_5_buffer_double_access;
always @(*) begin
    if(l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & (double_access_counter == 2'b11))begin
        l15_transducer_data_0_buffer_double_access = l15_transducer_data_0;
        l15_transducer_data_1_buffer_double_access = l15_transducer_data_1;
    end
    else if(l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & (double_access_counter == 2'b10))begin
        l15_transducer_data_2_buffer_double_access = l15_transducer_data_0;
        l15_transducer_data_3_buffer_double_access = l15_transducer_data_1;
    end
    else if(l15_transducer_val & (l15_transducer_returntype == `IFILL_RET) & (~double_access_ifill | (double_access_counter == 2'b11)))begin
        l15_transducer_data_0_buffer_double_access = l15_transducer_data_0;
        l15_transducer_data_1_buffer_double_access = l15_transducer_data_1;
        l15_transducer_data_2_buffer_double_access = l15_transducer_data_2;
        l15_transducer_data_3_buffer_double_access = l15_transducer_data_3;
    end
    else if(l15_transducer_val & (l15_transducer_returntype == `IFILL_RET) & (double_access_counter == 2'b10) & double_access_ifill)begin
        l15_transducer_data_4_buffer_double_access = l15_transducer_data_0;
        l15_transducer_data_5_buffer_double_access = l15_transducer_data_1;
    end
end


always @* begin
    if (l15_transducer_val & ((l15_transducer_returntype == `LOAD_RET) | (l15_transducer_returntype == `IFILL_RET)) & ~double_access & ~double_access_ifill) begin
        transducer_ao486_mem_readdatavalid_reg = 1'b1;
    end
    else if (l15_transducer_val & (l15_transducer_returntype == `LOAD_RET) & double_access & (double_access_counter == 2'b10)) begin
        transducer_ao486_mem_readdatavalid_reg = 1'b1;
    end
    else if (l15_transducer_val & (l15_transducer_returntype == `IFILL_RET) & double_access_ifill & (double_access_counter == 2'b10)) begin
        transducer_ao486_mem_readdatavalid_reg = 1'b1;
    end
    else begin
        transducer_ao486_mem_readdatavalid_reg = 1'b0;
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
