///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : top.sv
// Created by  : Prof. Quinn and Saumil Gogri
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"

	`include "htax_defines.sv"
	`include "htax_packet_c.sv"

	htax_packet_c pkt, fac_pkt; //handle for class objects
	
	bit clk=0;
	
	//Create variables to store port (4-bit) and one data packet (64-bit) 
	logic [3:0] port;
	logic [63:0] data;

//clock definition 
initial forever #5 clk = ~clk;

initial begin
//TO-DO create two instance with above handles with instructions provided below
	//system verilog instance

	$display("--- Creating packet with new() ---");
	pkt = new();
	if (!pkt.randomize()) `uvm_fatal("RND_FAIL", "pkt randomization failed");
	pkt.print();
	drive_packet(pkt);

	// UVM factory instantiation
	$display("\n--- Creating packet with UVM Factory ---");
	fac_pkt = htax_packet_c::type_id::create("fac_pkt");
	if (!fac_pkt.randomize()) `uvm_fatal("RND_FAIL", "fac_pkt randomization failed");
	fac_pkt.print();
	drive_packet(fac_pkt);

	factory.print();
	#10 $finish;
end

//TO DO complete the below task
task drive_packet (htax_packet_c pkt); 
port = 1 << pkt.dest_port;
//At every posedge of clk load each data packet from pkt.data to variable data
foreach (pkt.data[i])
begin
	@(posedge clk);
	data = pkt.data[i];
	$display("@%0t: Driving data[%0d] = %h to port %b", $time, i, data, port);
end
//The whole time the bit of variable port equal to pkt.dest_port is 1 and rest bits are 0
//Assign port = 4'bx and data = 64'bx after the last data packet
@(posedge clk);
	port = 4'bx;
	data = 64'bx;
	$display("@%0t: Drive finished. Assigning port and data to 'x'", $time);
endtask : drive_packet
endmodule
