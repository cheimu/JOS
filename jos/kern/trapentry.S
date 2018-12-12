/* See COPYRIGHT for copyright information. */

#include <inc/mmu.h>
#include <inc/memlayout.h>
#include <inc/trap.h>

###################################################################
# exceptions/interrupts
###################################################################

/* TRAPHANDLER defines a globally-visible function for handling a trap.
 * It pushes a trap number onto the stack, then jumps to _alltraps.
 * Use TRAPHANDLER for traps where the CPU automatically pushes an error code.
 *
 * You shouldn't call a TRAPHANDLER function from C, but you may
 * need to _declare_ one in C (for instance, to get a function pointer
 * during IDT setup).  You can declare the function with
 *   void NAME();
 * where NAME is the argument passed to TRAPHANDLER.
 */

#define TRAPHANDLER(name, num)						\
	.globl name;		/* define global symbol for 'name' */	\
	.type name, @function;	/* symbol type is function */		\
	.align 2;		/* align function definition */		\
	name:			/* function starts here */		\
	pushl $(num);							\
	jmp _alltraps

/* Use TRAPHANDLER_NOEC for traps where the CPU doesn't push an error code.
 * It pushes a 0 in place of the error code, so the trap frame has the same
 * format in either case.
 */

#define TRAPHANDLER_NOEC(name, num)					\
	.globl name;							\
	.type name, @function;						\
	.align 2;							\
	name:								\
	pushl $0;							\
	pushl $(num);							\
	jmp _alltraps

.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(ith_0, T_DIVIDE);
TRAPHANDLER_NOEC(ith_1, T_DEBUG);
TRAPHANDLER_NOEC(ith_2, T_NMI);
TRAPHANDLER_NOEC(ith_3, T_BRKPT);
TRAPHANDLER_NOEC(ith_4, T_OFLOW);
TRAPHANDLER_NOEC(ith_5, T_BOUND);
TRAPHANDLER_NOEC(ith_6, T_ILLOP);
TRAPHANDLER_NOEC(ith_7, T_DEVICE);
TRAPHANDLER(ith_8, T_DBLFLT);
TRAPHANDLER(ith_10, T_TSS);
TRAPHANDLER(ith_11, T_SEGNP);
TRAPHANDLER(ith_12, T_STACK);
TRAPHANDLER(ith_13, T_GPFLT);
TRAPHANDLER(ith_14, T_PGFLT);
TRAPHANDLER_NOEC(ith_16, T_FPERR);
TRAPHANDLER(ith_17, T_ALIGN);
TRAPHANDLER_NOEC(ith_18, T_MCHK);
TRAPHANDLER_NOEC(ith_19, T_SIMDERR);
TRAPHANDLER_NOEC(ith_32, IRQ_OFFSET + IRQ_TIMER);
TRAPHANDLER_NOEC(ith_33, IRQ_OFFSET + IRQ_KBD);
TRAPHANDLER_NOEC(ith_34, IRQ_OFFSET + 2);
TRAPHANDLER_NOEC(ith_35, IRQ_OFFSET + 3);
TRAPHANDLER_NOEC(ith_36, IRQ_OFFSET + IRQ_SERIAL);
TRAPHANDLER_NOEC(ith_37, IRQ_OFFSET + 5);
TRAPHANDLER_NOEC(ith_38, IRQ_OFFSET + 6);
TRAPHANDLER_NOEC(ith_39, IRQ_OFFSET + IRQ_SPURIOUS);
TRAPHANDLER_NOEC(ith_40, IRQ_OFFSET + 8);
TRAPHANDLER_NOEC(ith_41, IRQ_OFFSET + 9);
TRAPHANDLER_NOEC(ith_42, IRQ_OFFSET + 10);
TRAPHANDLER_NOEC(ith_43, IRQ_OFFSET + 11);
TRAPHANDLER_NOEC(ith_44, IRQ_OFFSET + 12);
TRAPHANDLER_NOEC(ith_45, IRQ_OFFSET + 13);
TRAPHANDLER_NOEC(ith_46, IRQ_OFFSET + IRQ_IDE);
TRAPHANDLER_NOEC(ith_47, IRQ_OFFSET + 15);
TRAPHANDLER_NOEC(ith_48, T_SYSCALL);
TRAPHANDLER_NOEC(ith_51, IRQ_OFFSET + IRQ_ERROR);
TRAPHANDLER_NOEC(ith_500, T_DEFAULT);

/* labx 
   it could be even more concise to use a generator 
*/
.data
.globl ith
ith:
.long ith_0;
.long ith_1;
.long ith_2;
.long ith_3;
.long ith_4;
.long ith_5;
.long ith_6;
.long ith_7;
.long ith_8;
.long ith_10;
.long ith_11;
.long ith_12;
.long ith_13;
.long ith_14;
.long ith_16;
.long ith_17;
.long ith_18;
.long ith_19;
.long ith_32;
.long ith_33;
.long ith_34;
.long ith_35;
.long ith_36;
.long ith_37;
.long ith_38;
.long ith_39;
.long ith_40;
.long ith_41;
.long ith_42;
.long ith_43;
.long ith_44;
.long ith_45;
.long ith_46;
.long ith_47;
.long ith_48;
.long ith_51;
.long ith_500;



/*
 * Lab 3: Your code here for _alltraps
 */
 .globl _alltraps
_alltraps:
	pushl %ds;
	pushl %es;
	pushal;
	movl $GD_KD, %eax;
	movw %ax, %ds;
	movw %ax, %es;
	pushl %esp;
	call trap;
