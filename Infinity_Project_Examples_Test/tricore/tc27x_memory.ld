/**************************************************************************************************
 * FILE: tc27x_memory.ld
 *
 * UC ARCHITECTURE:
 *
 *    TC2xx
 *
 * UC FAMILY:
 *
 *    TC27x
 *
 * DESCRIPTION:
 *
 *    uC family memory region definition file.
 *    Not all available memory regions are defined, only those used in BSP example.
 *    It includes the application linker files locating sections to memory regions at the end.
 *
 * FILE HISTORY:
 *    V1.0    Initial version
 *
 *
 **************************************************************************************************
 * Copyright (C) 2015-2021 HighTec EDV-Systeme GmbH.  All rights reserved.
 * This is proprietary software. Any use of the software requires a written
 * license agreement with HighTec EDV-Systeme GmbH. Please contact for
 * detailed license information: info@hightec-rt.com.
 *************************************************************************************************/
 
 
 
 
OUTPUT_FORMAT("elf32-tricore")
OUTPUT_ARCH(tricore)
ENTRY(_crt0_reset)

/* ================================================================================================
 * TC27X MEMORY REGIONS
 * ==============================================================================================*/

MEMORY
{
  /* Program Flash memory - cached region */
  int_flash0 (rx):      org = 0x80000000, len = 2M
  int_flash1 (rx):      org = 0x80200000, len = 2M

  /* Program scratchpad memories */
  pspr_cpu0 (rx):       org = 0x70100000, len = 24K
  pspr_cpu1 (rx):       org = 0x60100000, len = 32K
  pspr_cpu2 (rx):       org = 0x50100000, len = 32K
  
  /* Data scratchpad memories */
  dspr_cpu0 (w!x):      org = 0x70000000, len = 112K
  dspr_cpu1 (w!x):      org = 0x60000000, len = 120K
  dspr_cpu2 (w!x):      org = 0x50000000, len = 120K
  
  /* Periphery memory space region */
  periphery_base :      org = 0xF0000000, len = 0
  periphery_end  :      org = 0xFFFF0000, len = 0
  
  /* Global LMU RAM */
  lmu (wx):             org = 0xB0000000, len = 32K
  lmu_cached (wx):      org = 0x90000000, len = 32K
  
  /* BMHDs (Boot Mode Headers) located in PFLASH */
  bmhd_0 (rx) : 		org = 0xa0000000, len = 32
  bmhd_1 (rx) : 		org = 0xa0020000, len = 32
  bmhd_2 (rx) : 		org = 0xa000ffe0, len = 32
  bmhd_3 (rx) : 		org = 0xa001ffe0, len = 32
}


/* ================================================================================================
 * MEMORY REGION SYMBOLS
 * ==============================================================================================*/

/* Internal Flash memory */
INT_FLASH_MEMORY_BASE = ORIGIN(int_flash0);
INT_FLASH_MEMORY_SIZE = 4M;

/* ================================================================================================
 * INCLUDE OF APPLICATION LINKER FILE
 * ==============================================================================================*/
 
INCLUDE tc27x_bsp_example.ld
