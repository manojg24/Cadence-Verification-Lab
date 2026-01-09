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
Perform write operation to a particular address, now if we overwrite the data to the same address and read it back then it will show False result. For Example:

-> After reset

-> Write operation : addr=5 and data_in=07

-> Write operation : addr=5 and data_in=05

-> Read operation : addr=5

#### Expected behavior:
 Read operation at addr = 5 should output data as 05

#### Actual behavior:
 Read operation at addr = 5 should output data as 07

#### Bug fix:
cache[j].data <= data_in;

___

### Bug 2 ...
