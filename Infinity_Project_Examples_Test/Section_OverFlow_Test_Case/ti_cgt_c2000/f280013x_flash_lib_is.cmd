/*
// TI File $Revision: /main/3 $
// Checkin $Date: Agu 1, 2017   13:45:43 $
//
// FILE:    F2800137_FLASH_LIB.cmd
//
// TITLE:   Linker Command File For F2800137 examples that run out of RAM
//
//
//          Keep in mind that LS0, and LS1 are protected by the code
//          security module.
//
//          What this means is in most cases you will want to move to
//          another memory map file which has more memory defined.
//
*/

/*========================================================= */
/* Define the memory block start/length for the F280013x
   PAGE 0 will be used to organize program sections
   PAGE 1 will be used to organize data sections

   Notes:
         Memory blocks on F2800137 are uniform (ie same
         physical memory) in both PAGE 0 and PAGE 1.
         That is the same memory region should not be
         defined for both PAGE 0 and PAGE 1.
         Doing so will result in corruption of program
         and/or data.

         Contiguous SARAM memory blocks can be combined
         if required to create a larger memory block.
*///#############################################################################
// This file belongs to the DCSM testing project for f28002x device.
// It is intended to be a part of the test directory only.
//#############################################################################
//                              DISCLAIMER
//#############################################################################

MEMORY
{
   BEGIN            : origin = 0x00080000, length = 0x00000002
   BOOT_RSVD        : origin = 0x00000002, length = 0x00000126

/* RAMLS1           : origin = 0x0000A000, length = 0x00001FF8 */
   RAMLS1P          : origin = 0x0000A000, length = 0x00001FF8
// RAMLS1_RSVD      : origin = 0x0000BFF8, length = 0x00000008 /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */

   RESET              : origin = 0x003FFFC0, length = 0x00000002

   /* Flash sectors */
/* FLASH_BANK0_SEC_0_7     : origin = 0x080002, length = 0x1FFE */ /* on-chip Flash */
   FLASHBANK0_BOOT	       : origin = 0x080002, length = 0x1FFE	 /* remote update */

/* FLASH_BANK0_SEC_8_15    : origin = 0x082000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_16_23   : origin = 0x084000, length = 0x2000 */ /* on-chip Flash */
   FLASHBANK0_FAST	       : origin = 0x082000, length = 0x04000

/* FLASH_BANK0_SEC_24_31   : origin = 0x086000, length = 0x2000 */ /* on-chip Flash */
   FLASHBANK0_DATA 	       : origin = 0x086000, length = 0x2000	   /* constant data */

/* FLASH_BANK0_SEC_32_29   : origin = 0x088000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_40_47   : origin = 0x08A000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_48_55   : origin = 0x08C000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_56_63   : origin = 0x08E000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_64_71   : origin = 0x090000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_72_79   : origin = 0x092000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_80_87   : origin = 0x094000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_88_95   : origin = 0x096000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_96_103  : origin = 0x098000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_104_111 : origin = 0x09A000, length = 0x2000 */ /* on-chip Flash */
/* FLASH_BANK0_SEC_112_119 : origin = 0x09C000, length = 0x2000  /* on-chip Flash */
/* FLASH_BANK0_SEC_120_127 : origin = 0x09E000, length = 0x1FF0  /* on-chip Flash */
   FLASHBANK0_CODE	  	   : origin = 0x09A000, length = 0x05FF0   /* control code */
/* FLASH_BANK0_SEC_127_RSVD : origin = 0x0A0FF0, length = 0x0010 */  /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */

   RAMM0S          	  : origin = 0x00000128, length = 0x00000158	/* stack */
   RAMM1D         	  : origin = 0x00000280, length = 0x00000578	/* on-chip RAM block M1 */
   RAMM1_RSVD         : origin = 0x000007F8, length = 0x00000008    /* Reserve and do not use for code as per the errata advisory "Memory: Prefetching Beyond Valid Memory" */

   RAMLS0F        	  : origin = 0x00008000, length = 0x00000600	/* Reserve for FAST */
   RAMLS0D        	  : origin = 0x00008600, length = 0x00001A00
}


SECTIONS
{
   .reset           : > RESET,  		    TYPE = DSECT /* not used, */
   codestart		: > BEGIN,     			ALIGN(4)

   GROUP
   {
   	.TI.ramfunc {
#if defined(MOTOR1_FAST) || defined(MOTOR2_FAST)
       -l est_trajState_coff.lib<est_setupTrajState.obj> (.text)
#endif

#if defined(SFRA_ENABLE)
       -l sfra_f32_tmu_coff.lib<sfra_f32_tmu_collect.obj> (.text)
       -l sfra_f32_tmu_coff.lib<sfra_f32_tmu_inject.obj> (.text)
#endif
   			   }
   	dclfuncs
    dcl32funcs
   }                          LOAD >  FLASHBANK0_CODE,
                              RUN  >  RAMLS1P,
				              LOAD_START(RamfuncsLoadStart),
				              LOAD_SIZE(RamfuncsLoadSize),
				              LOAD_END(RamfuncsLoadEnd),
				              RUN_START(RamfuncsRunStart),
				              RUN_SIZE(RamfuncsRunSize),
				              RUN_END(RamfuncsRunEnd),
                              ALIGN(8)

    ctrlfuncs            :    LOAD >  FLASHBANK0_CODE,
                              RUN  >  RAMLS1P,
                              LOAD_START(loadStart_ctrlfuncs),
                              LOAD_END(loadEnd_ctrlfuncs),
                              LOAD_SIZE(loadSize_ctrlfuncs),
                              RUN_START(runStart_ctrlfuncs),
                              RUN_END(runEnd_ctrlfuncs),
                              RUN_SIZE(runSize_ctrlfuncs),
                              ALIGN(8)

   .text            : > FLASHBANK0_CODE,	ALIGN(4)
   .cinit           : > FLASHBANK0_CODE,	ALIGN(4)
   .switch          : > FLASHBANK0_CODE,	ALIGN(4)
   .cio				: > FLASHBANK0_CODE
   .pinit           : > FLASHBANK0_CODE,	ALIGN(4)
   .const           : > FLASHBANK0_CODE,  	ALIGN(4)
   .init_array      : > FLASHBANK0_CODE,	ALIGN(4)

   .stack           : > RAMM0S
   .bss             : > RAMM1D
   .bss:output      : > RAMM1D
   .bss:cio         : > RAMM1D
   .data            : > RAMM1D
   .sysmem          : > RAMM1D



    fastCode 		: > FLASHBANK0_FAST
    {
         --library=fast_full_lib.lib (.text)
    }

          /*  Allocate IQ math areas: */
   IQmath           : > FLASHBANK0_CODE, 	ALIGN(8)
   IQmathTables     : > FLASHBANK0_CODE,	ALIGN(8)

   	prms_data 		     : > FLASHBANK0_DATA

    est_data             : >  RAMLS0F,
                              LOAD_START(loadStart_est_data),
                              LOAD_END(loadEnd_est_data),
                              LOAD_SIZE(loadSize_est_data)
    hal_data             : >  RAMM1D,
                              LOAD_START(loadStart_hal_data),
                              LOAD_END(loadEnd_hal_data),
                              LOAD_SIZE(loadSize_hal_data)
    user_data            : >  RAMM1D,
                              LOAD_START(loadStart_user_data),
                              LOAD_END(loadEnd_user_data),
                              LOAD_SIZE(loadSize_user_data)
    foc_data             : >  RAMM1D,
                              LOAD_START(loadStart_foc_data),
                              LOAD_END(loadEnd_foc_data),
                              LOAD_SIZE(loadSize_foc_data)
    sys_data             : >  RAMLS0D,
                              LOAD_START(loadStart_sys_data),
                              LOAD_END(loadEnd_sys_data),
                              LOAD_SIZE(loadSize_sys_data)
    vibc_data            : >  RAMLS0D,
                              LOAD_START(loadStart_vibc_data),
                              LOAD_END(loadEnd_vibc_data),
                              LOAD_SIZE(loadSize_vibc_data)
    dmaBuf_data          : >  RAMLS0D,
                              LOAD_START(loadStart_dmaBuf_data),
                              LOAD_END(loadEnd_dmaBuf_data),
                              LOAD_SIZE(loadSize_dmaBuf_data)
    SFRA_F32_Data        : >  RAMLS0D,
                              LOAD_START(loadStart_SFRA_F32_Data),
                              LOAD_END(loadEnd_SFRA_F32_Data),
                              LOAD_SIZE(loadSize_SFRA_F32_Data)
    datalog_data         : >  RAMLS0D,
                              LOAD_START(loadStart_datalog_data),
                              LOAD_END(loadEnd_datalog_data),
                              LOAD_SIZE(loadSize_datalog_data)
    dbgc_data            : >  RAMLS0D,
                              LOAD_START(loadStart_dbgc_data),
                              LOAD_END(loadEnd_dbgc_data),
                              LOAD_SIZE(loadSize_dbgc_data)
}

/*
//===========================================================================
// End of file.
//===========================================================================
*/
