///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : top.sv (Activity 1 - Starter)
// Purpose     : Test basic SystemVerilog constraints (preparation for Lab 3)
///////////////////////////////////////////////////////////////////////////

`timescale 1ns/1ps
module top;

	import uvm_pkg::*;
	`include "uvm_macros.svh"
	`include "htax_packet_c.sv"

	htax_packet_c pkt;

	initial begin
		$display("=== Activity 1: Learning SystemVerilog Constraints ===");

		// Basic test: Create and randomize a few packets
		$display("\n--- Basic Test: Generate 5 Random Packets ---");
		for(int i = 0; i < 5; i++) begin
			pkt = new();
			if(pkt.randomize()) begin
				$display("Packet %0d:", i);
				pkt.print_packet();
			end else begin
				$error("Randomization failed for packet %0d", i);
			end
		end

		// TODO 5: Call distribution testing task
		// Call the test_distribution() task you will implement below
		// YOUR CODE HERE:
		test_distributon();


		// TODO 6: Call relationship testing task  
		// Call the test_relationships() task you will implement below
		// YOUR CODE HERE:
		test_relationships();


		$display("\n=== Activity 1 Complete! You're ready for Lab 3! ===");
		$finish;
	end

	// TODO 5: Implement distribution testing task
	// Create a task called test_distribution() that:
	// 1. Declares an array to count each priority level: int priority_count[4];
	// 2. Initializes the counters to 0
	// 3. Generates 100 packets in a loop
	// 4. For each packet, increments the counter for its pkt_priority
	// 5. Displays the final counts and percentages
	//
	// Task structure:
	// task test_distribution();
	//     // Your implementation here
	// endtask
	//
	// YOUR CODE HERE:

	task test_distributon();
	int priority_count[4];
	foreach(priority_count[i])
	begin
		priority_count[i] = 0;
	end
	for(int i=0; i<100; i++)
	begin
		pkt = new();
		if(pkt.randomize())
		begin
			priority_count[pkt.pkt_priority]++;
		end
	end
	$display("priority distribution results");
	for(int i =0; i<4; i++)
	begin
		$display("priority %0d: %0d packets(%0d%%)", i ,priority_count[i], priority_count[i]);
	end
	endtask		


	// TODO 6: Implement relationship testing task
	// Create a task called test_relationships() that:
	// 1. Declares a violations counter: int violations;
	// 2. Initializes violations to 0
	// 3. Generates 20 packets in a loop
	// 4. For each packet, checks if pkt_priority >= 2 and packet_size > 512
	// 5. If found, this is a constraint violation - increment violations and display error
	// 6. Reports the total number of violations (should be 0!)
	//
	// Task structure:
	// task test_relationships();
	//     // Your implementation here
	// endtask
	//
	// YOUR CODE HERE:

	task test_relationships();
	int violations = 0;
	for(int i=0; i<20; i++) 
	begin
		pkt =new();
		if(pkt.randomize())
		begin
			if(pkt.pkt_priority >= 2 && pkt.packet_size >512)
			begin
				violations ++;
				$display("Found Violation");
			end
		end
	end
	$display("Toatal violations: %0d", violations);
	if(violations == 0)
	begin
		$display("SUCCESS: Constraint relationship working correctly!");
	end
	endtask

endmodule