OUTPUT_ARCH( "riscv" )
OUTPUT_FORMAT("elf32-littleriscv")
ENTRY( _start )

MEMORY
{
  /* Program Flash (ROM) for storing code and constants */
  FLASH (rx) : ORIGIN = 0x20400000, LENGTH = 128K

  /* Data RAM for runtime data, stack, and heap */
  RAM (rwx) : ORIGIN = 0x80000000, LENGTH = 64K
}

SECTIONS
{
  /* text: test code section */
  . = 0x20400000;
  .text : { *(.text) }
  /* gnu_build_id: readonly build identifier */
  .gnu_build_id : { *(.note.gnu.build-id) }
  /* rodata: readonly data segment */
  .rodata : { *(.rodata) }

  /* data: Initialized data segment */
  . = 0x80000000;
  .data : { *(.data) }
  .sdata : { *(.sdata) }
  .debug : { *(.debug) }
  . += 0x1000;
  stack_top = .;

  /* End of uninitalized data segement */
  _end = .;
}
