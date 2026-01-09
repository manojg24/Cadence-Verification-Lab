///////////////////////////////////////////////////////////////////////////
// Texas A&M University
// CSCE 616 Hardware Design Verification
// File name   : htax_packet_c.sv (Activity 1 - Starter)
// Purpose     : Learn basic SystemVerilog constraints (preparation for Lab 3)
///////////////////////////////////////////////////////////////////////////
`include "uvm_macros.svh"
import uvm_pkg::*;

class htax_packet_c extends uvm_sequence_item;
	
	// TODO 1: Add basic random fields
	// Create the following random fields for a simple network packet:
	// packet_size (will represent packet length in bytes)
	// destination (will represent destination address)  
	// pkt_priority (will represent packet priority level)
	// Note: Use 'pkt_priority' NOT 'priority' (reserved keyword)
	//
	// YOUR CODE HERE:
	rand int packet_size;
	rand int destination;
       	rand int pkt_priority;	

	// UVM macros for built-in automation
	`uvm_object_utils_begin(htax_packet_c)
		// TODO 2: Add UVM field macros
		// Add uvm_field_int macros for each field you created above
		// This allows UVM to automatically handle printing and copying
		//
		// YOUR CODE HERE:
       `uvm_field_int(packet_size, UVM_ALL_ON);
       `uvm_field_int(destination, UVM_ALL_ON);
       `uvm_field_int(pkt_priority, UVM_ALL_ON);
	
	`uvm_object_utils_end

	//constructor
	function new (string name="htax_packet_c");
		super.new(name);
	endfunction

	// TODO 3: Write basic constraints
	// Write constraints for your fields:
	//
	// 1. packet_size should be between 64 and 1500 bytes (typical network packet sizes)
	// 2. destination should be between 1 and 10 (representing 10 possible destinations)
	// 3. pkt_priority should be 0, 1, 2, or 3, with this distribution:
	//    - pkt_priority 0 (low): 60% 
	//    - pkt_priority 1 (normal): 30%
	//    - pkt_priority 2 (high): 8%
	//    - pkt_priority 3 (critical): 2%
	//
	// YOUR CODE HERE:
	constraint packet_size_cons {
		packet_size >= 64;
		packet_size <= 1500;
	}	

	constraint destination_cons {
		destination >= 1;
		destination <= 10;
	}

	constraint pkt_priority_cons {
		pkt_priority dist {0:=60,1:=30,2:=8,3:=2};
	}

	// TODO 4: Add a constraint relationship
	// Write a constraint that creates a relationship between fields:
	// "High priority packets (pkt_priority >= 2) should be smaller (packet_size <= 512)"
	//
	// Use the implication operator (->):
	// This means: "IF pkt_priority is 2 or 3, THEN packet_size must be 512 or less"
	//
	// YOUR CODE HERE:
	constraint high_priority_cons {
		(pkt_priority >= 2 && pkt_priority <= 3) -> (packet_size <= 512);
	}

	// Helper function to display packet information  
	function void print_packet();
		$display("Packet: size=%0d bytes, dest=%0d, priority=%0d", 
		         packet_size, destination, pkt_priority);
	endfunction

endclass : htax_packet_c
