/* Memory Map:
Master PIC - Command	0x0020
Master PIC - Data	0x0021
Slave PIC - Command	0x00A0
Slave PIC - Data	0x00A1

PIT:
0x40         Channel 0 data port (read/write)
0x41         Channel 1 data port (read/write)
0x42         Channel 2 data port (read/write)
0x43         Mode/Command register (write only, a read is ignored)
*/




module ao486_io_transducer (
    input                           clk,
    input                           rst_n,
    input [15:0]                    ao486_transducer_io_address,
    input [3:0]                     ao486_transducer_io_byteenable,

    input                           ao486_transducer_io_read,
    output                          transducer_ao486_io_readdatavalid,
    output reg [31:0]                   transducer_ao486_io_readdata,

    input                           ao486_transducer_io_write,
    input [31:0]                    ao486_transducer_io_writedata,
    output                          transducer_ao486_io_waitrequest,
    output                          interrupt_do,
    output [7:0]                    interrupt_vector, 
    input                           interrupt_done
);

wire irq_pit, irq_rtc;
wire [7:0] speaker_61h_readdata;
wire speaker_enable;
wire speaker_out;
wire [15:0] interrupt_input_pic;
reg [15:0] ao486_peripheral_address;
reg [7:0] ao486_peripheral_data;

reg [1:0] io_address_pit;
reg io_read_pit, io_write_pit;
reg [7:0] io_writedata_pit;
wire [7:0] io_readdata_pit;
pit pit(
        .clk                                (clk),
        .rst_n                              (rst_n),
        .irq                                (irq_pit),
        .io_address                         (io_address_pit),
        .io_read                            (io_read_pit),
        .io_readdata                        (io_readdata_pit),
        .io_write                           (io_write_pit),
        .io_writedata                       (io_writedata_pit),
        .speaker_61h_read                   (1'b0),
        .speaker_61h_readdata               (speaker_61h_readdata),
        .speaker_61h_write                  (1'b0),
        .speaker_61h_writedata              (8'b0),
        .speaker_enable                     (speaker_enable),
        .speaker_out                        (speaker_out),
        .mgmt_address                       (1'b0),
        .mgmt_write                         (1'b0),
        .mgmt_writedata                     (32'b0)
    );

reg master_address_pic, master_read_pic, master_write_pic;
reg [7:0] master_writedata_pic;
wire [7:0] master_readdata_pic;

reg slave_address_pic, slave_read_pic, slave_write_pic;
reg [7:0] slave_writedata_pic;
wire [7:0] slave_readdata_pic;

pic pic(
        .clk                (clk),
        .rst_n              (rst_n),
        
        //master pic
        .master_address     (master_address_pic),
        .master_read        (master_read_pic),
        .master_readdata    (master_readdata_pic),
        .master_write       (master_write_pic),
        .master_writedata   (master_writedata_pic),
        //slave pic
        .slave_address      (slave_address_pic),
        .slave_read         (slave_read_pic),
        .slave_readdata     (slave_readdata_pic),
        .slave_write        (slave_write_pic),
        .slave_writedata    (slave_writedata_pic),
        
        //interrupt input
        .interrupt_input    (interrupt_input_pic),
        
        //interrupt output
        .interrupt_do       (interrupt_do),
        .interrupt_vector   (interrupt_vector),
        .interrupt_done     (interrupt_done)
    );

reg io_address_rtc, io_read_rtc, io_write_rtc;
reg [7:0] io_writedata_rtc;
wire [7:0] io_readdata_rtc;

rtc rtc(
        .clk               (clk),
        .rst_n             (rst_n),
        
        .irq               (irq_rtc),
        
        //io slave
        .io_address        (io_address_rtc),
        .io_read           (io_read_rtc),
        .io_readdata       (io_readdata_rtc),
        .io_write          (io_write_rtc),
        .io_writedata      (io_writedata_rtc),

        .mgmt_address      (8'b0),
        .mgmt_write        (1'b0),
        .mgmt_writedata    (32'b0)
);

always @(*) begin
    case(ao486_transducer_io_byteenable)
        4'b0001: begin
            ao486_peripheral_address = ao486_transducer_io_address;
            ao486_peripheral_data = ao486_transducer_io_writedata [7:0];
        end
        4'b0010: begin
            ao486_peripheral_address = ao486_transducer_io_address + 1'd1;
            ao486_peripheral_data = ao486_transducer_io_writedata [15:8];
        end
        4'b0100: begin
            ao486_peripheral_address = ao486_transducer_io_address + 2'd2;
            ao486_peripheral_data = ao486_transducer_io_writedata [23:16];
        end
        4'b1000: begin
            ao486_peripheral_address = ao486_transducer_io_address + 2'd3;
            ao486_peripheral_data = ao486_transducer_io_writedata [31:24];
        end
    endcase
end

always @(*) begin
    if((ao486_transducer_io_read | ao486_transducer_io_write) & ((ao486_peripheral_address == 16'h0020) | (ao486_peripheral_address == 16'h0021))) begin
        master_address_pic = ao486_peripheral_address;
        master_read_pic = ao486_transducer_io_read;
        master_write_pic = ao486_transducer_io_write;
        master_writedata_pic = ao486_peripheral_data;
        transducer_ao486_io_readdata = master_readdata_pic;
    end
    else if((ao486_transducer_io_read | ao486_transducer_io_write) & ((ao486_peripheral_address == 16'h00A0) | (ao486_peripheral_address == 16'h00A1))) begin
        slave_address_pic = ao486_peripheral_address;
        slave_read_pic = ao486_transducer_io_read;
        slave_write_pic = ao486_transducer_io_write;
        slave_writedata_pic = ao486_peripheral_data;
        transducer_ao486_io_readdata = slave_readdata_pic;
    end
    else begin
        master_address_pic = 1'b0;
        master_read_pic = 1'b0;
        master_write_pic = 1'b0;
        master_writedata_pic = 8'b0;
        slave_address_pic = 1'b0;
        slave_read_pic = 1'b0;
        slave_write_pic = 1'b0;
        slave_writedata_pic = 8'b0;
    end
end

always @(*) begin
    if((ao486_transducer_io_read | ao486_transducer_io_write) & ((ao486_peripheral_address == 16'h0040) | (ao486_peripheral_address == 16'h0041) | (ao486_peripheral_address == 16'h0042) | (ao486_peripheral_address == 16'h0043))) begin
        io_address_pit = ao486_peripheral_address[1:0];
        io_read_pit = ao486_transducer_io_read;
        io_write_pit = ao486_transducer_io_write;
        io_writedata_pit = ao486_peripheral_data;
        transducer_ao486_io_readdata = io_readdata_pit;
    end
    else begin
        io_address_pit = 2'b0;
        io_read_pit = 1'b0;
        io_write_pit = 1'b0;
        io_writedata_pit = 8'b0;
    end
end

always @(*) begin
    if((ao486_transducer_io_read | ao486_transducer_io_write) & ((ao486_peripheral_address == 16'h0070) | (ao486_peripheral_address == 16'h0071))) begin
        io_address_rtc = ao486_peripheral_address[0];
        io_read_rtc = ao486_transducer_io_read;
        io_write_rtc = ao486_transducer_io_write;
        io_writedata_rtc = ao486_peripheral_data;
        transducer_ao486_io_readdata = io_readdata_rtc;
    end
end

assign transducer_ao486_io_readdatavalid = ao486_transducer_io_read;

assign interrupt_input_pic = {7'b0, irq_rtc, 7'b0, irq_pit};

assign transducer_ao486_io_waitrequest = 1'b0;

endmodule
