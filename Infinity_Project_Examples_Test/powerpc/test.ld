ENTRY(_Reset)

MEMORY
{
  /* Flash memory for the code and read-only data */
  FLASH (rx) : ORIGIN = 0x00f00000, LENGTH = 128K

  /* SRAM for writable data, stack, and heap */
  SRAM (rwx) : ORIGIN = 0x20000000, LENGTH = 64K
}

SECTIONS
{
/* . = 0x10000; */
  . = 0xf00000; 

 .startup . : { startup.o(.text) }
 .text : { *(.text) }
 .data : { *(.data) }
 .bss : { *(.bss COMMON) }
 . = ALIGN(8);
 . = . + 0x1000; /* 4kB of stack memory */
 stack_top = .;
}

