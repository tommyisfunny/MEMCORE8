# MEMCORE8 CPU
MEMCORE8 is a 8 bit homebrew CPU.

Its a micro-coded machine which relies heavily on the systems memory (ram) to store internal registers such as the program counter, the stack pointer, general-purpose registers, etc.
This makes it very flexible in terms of the type of architecture it implements using microcode, but comes at the cost of a high number of clock cycles per instruction.

The architecture I implemented is a load-store architecture with 8 bit registers, but has many word wide (16 bit) operations to make handeling pointers easy.

**work in progress**