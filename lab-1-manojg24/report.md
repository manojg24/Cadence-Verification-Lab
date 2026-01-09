# Bugs report

This file contains the list of all bugs detected in the design.

### Bug 1

#### What is the bug?
When we try to perform a write operation to the cache memory design, if the block or address is already present in the cache then in the faulty design we are rewriting the data onto the address field instead of the data field of the cache i.e. (cache[j].addr <= data_in). The correct method is to perform data operation on the data field i.e. (cache[j].data <= data_in). 

#### Where is it?
Module: work/design/cache_mem.sv

File: cache_mem.sv

Line number(s): 50

#### How to reproduce:
Perform write operation to a particular address, now if we overwrite the data to the same address and read it back then it will show False result.
For Example:

-> After reset

-> Write operation : addr=2 and data_in=0F

-> Write operation : addr=2 and data_in=0A

-> Read operation : addr=2

#### Expected behavior:
-> Read operation at addr = 2 should output data as 0A

#### Actual behavior:
-> Read operation at addr = 2 outputs data as 10 which is wrong

#### Bug fix:
cache[j].data <= data_in;
___

### Bug 2 

#### What is the bug?
When we try to perform a write operation to the cache memory design, and then if we read the same block, the design is trying to load the value from the memory for 1 time unit, which has stale value for that block and then checks for the address in the cache. If it's a Cache hit then it updates the correct data_out. But ideally it should check for cache hit first and then only if its a Cache miss, we should look for data in the memory.

#### Where is it?
Module: work/design/cache_mem.sv

File: cache_mem.sv

Line number(s): 59

#### How to reproduce:
Perform write operation to a particular address, and read it back then it will show False result.
For Example:

-> After reset

-> Write operation : addr=2 and data_in=0F

-> Read operation : addr=2

#### Expected behavior:
-> Read operation at addr = 2 should output data as 0F

#### Actual behavior:
-> Read operation at addr = 2 outputs data as 0 for 1 time unit because of the unnecessary usage of the statement written at line 59 and then fetches the correct value after that.

#### Bug fix:
#1 data_out <= memory[addr]; (Line No 59 - Not required)
