///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : simple_mem_tb.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

module mem_test;
	reg  clk;
	reg  rst_n;
	reg  rd_en;
	reg  wr_en;
	reg [4:0]  addr;
	reg [7:0]  data_in;
	wire [7:0]  data_out;
	

  //simple mem instantiation
  simple_mem mem_inst (
	.clk(clk),
	.rst_n(rst_n),
	.rd_en(rd_en),
	.wr_en(wr_en),
	.addr(addr),
	.data_in(data_in),
	.data_out(data_out)
	);

  initial clk = 0;
  always #10 clk = ~clk;

  initial
  begin : mem_t

    rst_n = 0;       
    rd_en = 0;
    wr_en = 0;
    addr  = 0;
    data_in = 0;
    #20 rst_n = 1;
    $display ("Asynch Memory Reset"); 
    @(posedge clk);

  // After reset read from all addresses and confirm reset state
  for (int i = 0; i < 32; i++) begin
    addr <= i;
    rd_en <= 1;
    @(posedge clk);
        $display("Addr %0d after reset: data_out=%0h (expected 00)", i, data_out);
    rd_en <= 0;
    @(posedge clk);
  end

  // Run a loop to write iter value on the address -- write 5 on memory[5]
  for (int i = 0; i < 8; i++) begin
    addr    <= i;
    data_in <= i;      
    wr_en   <= 1;
    @(posedge clk);
    wr_en   <= 0;

    rd_en   <= 1;
    @(posedge clk);
    rd_en   <= 1;
    @(posedge clk);
    if (data_out !== 8'h05)
        $display("ERROR: memory[5] expected=05, got=%0h", data_out);
    else
        $display("OK: memory[5] correctly holds 05");
    rd_en   <= 0;
  end
  

  // Add your own stimulus to catch the bug in the design. Also display the current vs expected value

  addr    <= 5;
  data_in <= 8'h05;
  wr_en   <= 1;
  @(posedge clk);
  wr_en   <= 0;

  rd_en   <= 1;
  @(posedge clk);
      $display("DEBUG: Wrote 0x05 to addr 5, read back %0h", data_out);
  rd_en   <= 0;
  @(posedge clk);

  addr    <= 5;
  data_in <= 8'h55;
  wr_en   <= 1;
  @(posedge clk);
  wr_en   <= 0;

  rd_en   <= 1;
  @(posedge clk);
      $display("DEBUG: Wrote 0x55 to addr 5, read back %0h (expected 0x55)", data_out);
  if (data_out !== 8'h55)
      $display("BUG DETECTED: Memory is XORing instead of overwriting!");
  rd_en   <= 0;
  @(posedge clk);
    
  $finish; 
  end

  task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
  //complete the task <insert display statement for debug>
  begin
    @(negedge clk);
    wr_en <= 1;
    rd_en <= 0;
    addr <= addr_in;
    data_in <= data_wr;

    @(negedge clk);
    wr_en <= 0;
  	$display ("Write Address : %0d with data : %0h", addr, data_wr);
  end
  endtask

  task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
  //complete the task <insert display statement for debug>
  begin
    @(negedge clk);
    wr_en <= 0;
    rd_en <= 1;
    addr <= addr_in;

    @(negedge clk);
    data_rd = data_out;
    rd_en <= 0;
  	$display ("Read Address : %0d with data : %0h", addr, data_rd);
  end
  endtask

endmodule
