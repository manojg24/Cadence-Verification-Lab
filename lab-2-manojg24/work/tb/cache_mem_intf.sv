interface cache_mem_intf (input clk, input rst_n);
  logic [4:0] addr;
  logic [7:0] data_in;
  logic [7:0] data_out;
  logic rd_en;
  logic wr_en;

//TO DO : Define modport for tb
modport tb(
  input data_out,
  output addr, data_in, rd_en, wr_en,
  import mem_write, mem_read
);
     

//TO DO : Define modport for mem
modport mem(
  input addr, data_in, rd_en, wr_en,
  output data_out
);  
              
task mem_write (input logic [4:0] addr_in, input logic [7:0] data_wr);
  @(negedge clk);
  wr_en <= 1;
  rd_en <= 0;
  addr <= addr_in;
  data_in <= data_wr;

  @(negedge clk);
  wr_en <= 0;
  $display ("Write Address : %0d with data : %0h", addr, data_wr);
endtask


task mem_read (input logic [4:0] addr_in, output logic [7:0] data_rd);
  @(negedge clk);
  wr_en <= 0;
  rd_en <= 1;
  addr <= addr_in;

  @(negedge clk);
  data_rd = data_out;
  rd_en <= 0;
    $display ("Read Address : %0d with data : %0h", addr, data_rd);
endtask
              
endinterface
