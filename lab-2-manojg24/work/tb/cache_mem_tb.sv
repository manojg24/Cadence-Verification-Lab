module cache_mem_test(cache_mem_intf.tb cmbus);

  initial
  begin : mem_t

//TO DO : Create your own stimulus (Hint call mem_write and mem_read task of cmbus instance)

  cmbus.mem_write(5, 8'h07);

  cmbus.mem_write(5, 8'h05);
  
  cmbus.mem_read(5); // cache hit

  cmbus.mem_write(3, 8'h01);
  
  cmbus.mem_read(3); //cache hit

  cmbus.mem_read(5); // Reading again from 5 to check cache miss, getting from main memory

	$finish;
  end

endmodule
