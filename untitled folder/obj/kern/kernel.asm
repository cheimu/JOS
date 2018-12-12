
obj/kern/kernel:     file format elf32-i386


Disassembly of section .text:

f0100000 <_start+0xeffffff4>:
.globl _start
_start = RELOC(entry)

.globl entry
entry:
	movw	$0x1234, 0x472			# warm boot
f0100000:	02 b0 ad 1b 02 00    	add    0x21bad(%eax),%dh
f0100006:	00 00                	add    %al,(%eax)
f0100008:	fc                   	cld    
f0100009:	4f                   	dec    %edi
f010000a:	52                   	push   %edx
f010000b:	e4                   	.byte 0xe4

f010000c <entry>:
f010000c:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f0100013:	34 12 
	# sufficient until we set up our real page table in mem_init
	# in lab 2.

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %ecx
f0100015:	b9 00 80 12 00       	mov    $0x128000,%ecx
	movl	%ecx, %cr3
f010001a:	0f 22 d9             	mov    %ecx,%cr3
	# Turn on paging.
	movl	%cr0, %ecx
f010001d:	0f 20 c1             	mov    %cr0,%ecx
	orl	$(CR0_PE|CR0_PG|CR0_WP), %ecx
f0100020:	81 c9 01 00 01 80    	or     $0x80010001,%ecx
	movl	%ecx, %cr0
f0100026:	0f 22 c1             	mov    %ecx,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %ecx
f0100029:	b9 30 00 10 f0       	mov    $0xf0100030,%ecx
	jmp	*%ecx
f010002e:	ff e1                	jmp    *%ecx

f0100030 <relocated>:
relocated:

	# Clear the frame pointer register (EBP)
	# so that once we get into debugging C code,
	# stack backtraces will be terminated properly.
	movl	$0x0, %ebp			# nuke frame pointer
f0100030:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Set the stack pointer
	movl	$(bootstacktop),%esp
f0100035:	bc 00 80 12 f0       	mov    $0xf0128000,%esp

	# pointer to struct multiboot_info
	pushl	%ebx
f010003a:	53                   	push   %ebx
	# saved magic value
	pushl	%eax
f010003b:	50                   	push   %eax

	# now to C code
	call	i386_init
f010003c:	e8 5e 00 00 00       	call   f010009f <i386_init>

f0100041 <spin>:

	# Should never get here, but in case we do, just spin.
spin:	jmp	spin
f0100041:	eb fe                	jmp    f0100041 <spin>

f0100043 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0100043:	55                   	push   %ebp
f0100044:	89 e5                	mov    %esp,%ebp
f0100046:	56                   	push   %esi
f0100047:	53                   	push   %ebx
f0100048:	8b 75 10             	mov    0x10(%ebp),%esi
	va_list ap;

	if (panicstr)
f010004b:	83 3d a4 6f 2c f0 00 	cmpl   $0x0,0xf02c6fa4
f0100052:	74 0f                	je     f0100063 <_panic+0x20>
	va_end(ap);

dead:
	/* break into the kernel monitor */
	while (1)
		monitor(NULL);
f0100054:	83 ec 0c             	sub    $0xc,%esp
f0100057:	6a 00                	push   $0x0
f0100059:	e8 92 09 00 00       	call   f01009f0 <monitor>
f010005e:	83 c4 10             	add    $0x10,%esp
f0100061:	eb f1                	jmp    f0100054 <_panic+0x11>
	panicstr = fmt;
f0100063:	89 35 a4 6f 2c f0    	mov    %esi,0xf02c6fa4
	asm volatile("cli; cld");
f0100069:	fa                   	cli    
f010006a:	fc                   	cld    
	va_start(ap, fmt);
f010006b:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel panic on CPU %d at %s:%d: ", cpunum(), file, line);
f010006e:	e8 b5 63 00 00       	call   f0106428 <cpunum>
f0100073:	ff 75 0c             	pushl  0xc(%ebp)
f0100076:	ff 75 08             	pushl  0x8(%ebp)
f0100079:	50                   	push   %eax
f010007a:	68 80 77 10 f0       	push   $0xf0107780
f010007f:	e8 1f 3c 00 00       	call   f0103ca3 <cprintf>
	vcprintf(fmt, ap);
f0100084:	83 c4 08             	add    $0x8,%esp
f0100087:	53                   	push   %ebx
f0100088:	56                   	push   %esi
f0100089:	e8 ef 3b 00 00       	call   f0103c7d <vcprintf>
	cprintf("\n");
f010008e:	c7 04 24 ec 8a 10 f0 	movl   $0xf0108aec,(%esp)
f0100095:	e8 09 3c 00 00       	call   f0103ca3 <cprintf>
f010009a:	83 c4 10             	add    $0x10,%esp
f010009d:	eb b5                	jmp    f0100054 <_panic+0x11>

f010009f <i386_init>:
{
f010009f:	55                   	push   %ebp
f01000a0:	89 e5                	mov    %esp,%ebp
f01000a2:	56                   	push   %esi
f01000a3:	53                   	push   %ebx
	memset(edata, 0, end - edata);
f01000a4:	83 ec 04             	sub    $0x4,%esp
f01000a7:	b8 28 90 30 f0       	mov    $0xf0309028,%eax
f01000ac:	2d f4 50 2c f0       	sub    $0xf02c50f4,%eax
f01000b1:	50                   	push   %eax
f01000b2:	6a 00                	push   $0x0
f01000b4:	68 f4 50 2c f0       	push   $0xf02c50f4
f01000b9:	e8 5f 5c 00 00       	call   f0105d1d <memset>
	cons_init();
f01000be:	e8 50 06 00 00       	call   f0100713 <cons_init>
	assert(magic == MULTIBOOT_BOOTLOADER_MAGIC);
f01000c3:	83 c4 10             	add    $0x10,%esp
f01000c6:	81 7d 08 02 b0 ad 2b 	cmpl   $0x2badb002,0x8(%ebp)
f01000cd:	74 16                	je     f01000e5 <i386_init+0x46>
f01000cf:	68 a4 77 10 f0       	push   $0xf01077a4
f01000d4:	68 31 78 10 f0       	push   $0xf0107831
f01000d9:	6a 27                	push   $0x27
f01000db:	68 46 78 10 f0       	push   $0xf0107846
f01000e0:	e8 5e ff ff ff       	call   f0100043 <_panic>
	cprintf("451 decimal is %o octal!\n", 451);
f01000e5:	83 ec 08             	sub    $0x8,%esp
f01000e8:	68 c3 01 00 00       	push   $0x1c3
f01000ed:	68 52 78 10 f0       	push   $0xf0107852
f01000f2:	e8 ac 3b 00 00       	call   f0103ca3 <cprintf>
	cpuid_print();
f01000f7:	e8 a3 52 00 00       	call   f010539f <cpuid_print>
	e820_init(addr);
f01000fc:	83 c4 04             	add    $0x4,%esp
f01000ff:	ff 75 0c             	pushl  0xc(%ebp)
f0100102:	e8 2c 0a 00 00       	call   f0100b33 <e820_init>
	mem_init();
f0100107:	e8 66 15 00 00       	call   f0101672 <mem_init>
	env_init();
f010010c:	e8 72 33 00 00       	call   f0103483 <env_init>
	trap_init();
f0100111:	e8 94 3c 00 00       	call   f0103daa <trap_init>
	acpi_init();
f0100116:	e8 99 5f 00 00       	call   f01060b4 <acpi_init>
	mp_init();
f010011b:	e8 3a 62 00 00       	call   f010635a <mp_init>
	lapic_init();
f0100120:	e8 5e 63 00 00       	call   f0106483 <lapic_init>
	pic_init();
f0100125:	e8 db 3a 00 00       	call   f0103c05 <pic_init>
	ioapic_init();
f010012a:	e8 ed 65 00 00       	call   f010671c <ioapic_init>
	ioapic_enable(IRQ_KBD, bootcpu->cpu_apicid);
f010012f:	83 c4 08             	add    $0x8,%esp
f0100132:	0f b6 05 00 80 2c f0 	movzbl 0xf02c8000,%eax
f0100139:	50                   	push   %eax
f010013a:	6a 01                	push   $0x1
f010013c:	e8 84 66 00 00       	call   f01067c5 <ioapic_enable>
	ioapic_enable(IRQ_SERIAL, bootcpu->cpu_apicid);
f0100141:	83 c4 08             	add    $0x8,%esp
f0100144:	0f b6 05 00 80 2c f0 	movzbl 0xf02c8000,%eax
f010014b:	50                   	push   %eax
f010014c:	6a 04                	push   $0x4
f010014e:	e8 72 66 00 00       	call   f01067c5 <ioapic_enable>
	pci_init();
f0100153:	e8 d1 6c 00 00       	call   f0106e29 <pci_init>
extern struct spinlock kernel_lock;

static inline void
lock_kernel(void)
{
	spin_lock(&kernel_lock);
f0100158:	c7 04 24 60 b4 12 f0 	movl   $0xf012b460,(%esp)
f010015f:	e8 a1 66 00 00       	call   f0106805 <spin_lock>
	if (ncpu <= 1)
f0100164:	83 c4 10             	add    $0x10,%esp
f0100167:	83 3d a0 83 2c f0 01 	cmpl   $0x1,0xf02c83a0
f010016e:	0f 8e dd 00 00 00    	jle    f0100251 <i386_init+0x1b2>
	cprintf("SMP: BSP #%d [apicid %02x]\n", cpunum(), thiscpu->cpu_apicid);
f0100174:	e8 af 62 00 00       	call   f0106428 <cpunum>
f0100179:	6b c0 74             	imul   $0x74,%eax,%eax
f010017c:	0f b6 98 00 80 2c f0 	movzbl -0xfd38000(%eax),%ebx
f0100183:	e8 a0 62 00 00       	call   f0106428 <cpunum>
f0100188:	83 ec 04             	sub    $0x4,%esp
f010018b:	53                   	push   %ebx
f010018c:	50                   	push   %eax
f010018d:	68 6c 78 10 f0       	push   $0xf010786c
f0100192:	e8 0c 3b 00 00       	call   f0103ca3 <cprintf>
#define KADDR(pa) _kaddr(__FILE__, __LINE__, pa)

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0100197:	83 c4 10             	add    $0x10,%esp
f010019a:	83 3d c8 74 2c f0 07 	cmpl   $0x7,0xf02c74c8
f01001a1:	76 27                	jbe    f01001ca <i386_init+0x12b>
	memmove(code, mpentry_start, mpentry_end - mpentry_start);
f01001a3:	83 ec 04             	sub    $0x4,%esp
f01001a6:	b8 8a 5f 10 f0       	mov    $0xf0105f8a,%eax
f01001ab:	2d 10 5f 10 f0       	sub    $0xf0105f10,%eax
f01001b0:	50                   	push   %eax
f01001b1:	68 10 5f 10 f0       	push   $0xf0105f10
f01001b6:	68 00 70 00 f0       	push   $0xf0007000
f01001bb:	e8 aa 5b 00 00       	call   f0105d6a <memmove>
f01001c0:	83 c4 10             	add    $0x10,%esp
f01001c3:	be 74 00 00 00       	mov    $0x74,%esi
f01001c8:	eb 64                	jmp    f010022e <i386_init+0x18f>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01001ca:	68 00 70 00 00       	push   $0x7000
f01001cf:	68 c8 77 10 f0       	push   $0xf01077c8
f01001d4:	6a 75                	push   $0x75
f01001d6:	68 46 78 10 f0       	push   $0xf0107846
f01001db:	e8 63 fe ff ff       	call   f0100043 <_panic>
		mpentry_kstack = percpu_kstacks[c - cpus] + KSTKSIZE;
f01001e0:	89 f2                	mov    %esi,%edx
f01001e2:	c1 fa 02             	sar    $0x2,%edx
f01001e5:	89 d0                	mov    %edx,%eax
f01001e7:	c1 e0 07             	shl    $0x7,%eax
f01001ea:	29 d0                	sub    %edx,%eax
f01001ec:	8d 0c c2             	lea    (%edx,%eax,8),%ecx
f01001ef:	89 c8                	mov    %ecx,%eax
f01001f1:	c1 e0 0e             	shl    $0xe,%eax
f01001f4:	29 c8                	sub    %ecx,%eax
f01001f6:	c1 e0 04             	shl    $0x4,%eax
f01001f9:	01 d0                	add    %edx,%eax
f01001fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
f01001fe:	c1 e0 0f             	shl    $0xf,%eax
f0100201:	05 00 10 2d f0       	add    $0xf02d1000,%eax
f0100206:	a3 a8 6f 2c f0       	mov    %eax,0xf02c6fa8
		lapic_startap(c->cpu_apicid, PADDR(code));
f010020b:	83 ec 08             	sub    $0x8,%esp
f010020e:	68 00 70 00 00       	push   $0x7000
f0100213:	0f b6 86 00 80 2c f0 	movzbl -0xfd38000(%esi),%eax
f010021a:	50                   	push   %eax
f010021b:	e8 18 64 00 00       	call   f0106638 <lapic_startap>
f0100220:	83 c4 10             	add    $0x10,%esp
		while(c->cpu_status != CPU_STARTED)
f0100223:	8b 43 04             	mov    0x4(%ebx),%eax
f0100226:	83 f8 01             	cmp    $0x1,%eax
f0100229:	75 f8                	jne    f0100223 <i386_init+0x184>
f010022b:	83 c6 74             	add    $0x74,%esi
f010022e:	8d 9e 00 80 2c f0    	lea    -0xfd38000(%esi),%ebx
	for (c = cpus + 1; c < cpus + ncpu; c++) {
f0100234:	8b 15 a0 83 2c f0    	mov    0xf02c83a0,%edx
f010023a:	8d 04 12             	lea    (%edx,%edx,1),%eax
f010023d:	01 d0                	add    %edx,%eax
f010023f:	01 c0                	add    %eax,%eax
f0100241:	01 d0                	add    %edx,%eax
f0100243:	8d 04 82             	lea    (%edx,%eax,4),%eax
f0100246:	8d 04 85 00 80 2c f0 	lea    -0xfd38000(,%eax,4),%eax
f010024d:	39 c3                	cmp    %eax,%ebx
f010024f:	72 8f                	jb     f01001e0 <i386_init+0x141>
	ENV_CREATE(fs_fs, ENV_TYPE_FS);
f0100251:	83 ec 08             	sub    $0x8,%esp
f0100254:	6a 01                	push   $0x1
f0100256:	68 50 6f 26 f0       	push   $0xf0266f50
f010025b:	e8 d7 33 00 00       	call   f0103637 <env_create>
	ENV_CREATE(user_icode, ENV_TYPE_USER);
f0100260:	83 c4 08             	add    $0x8,%esp
f0100263:	6a 00                	push   $0x0
f0100265:	68 c8 ec 25 f0       	push   $0xf025ecc8
f010026a:	e8 c8 33 00 00       	call   f0103637 <env_create>
	kbd_intr();
f010026f:	e8 43 04 00 00       	call   f01006b7 <kbd_intr>
	sched_yield();
f0100274:	e8 40 45 00 00       	call   f01047b9 <sched_yield>

f0100279 <mp_main>:
{
f0100279:	55                   	push   %ebp
f010027a:	89 e5                	mov    %esp,%ebp
f010027c:	53                   	push   %ebx
f010027d:	83 ec 04             	sub    $0x4,%esp
	lcr3(PADDR(kern_pgdir));
f0100280:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
	if ((uint32_t)kva < KERNBASE)
f0100285:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010028a:	77 15                	ja     f01002a1 <mp_main+0x28>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010028c:	50                   	push   %eax
f010028d:	68 ec 77 10 f0       	push   $0xf01077ec
f0100292:	68 89 00 00 00       	push   $0x89
f0100297:	68 46 78 10 f0       	push   $0xf0107846
f010029c:	e8 a2 fd ff ff       	call   f0100043 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01002a1:	05 00 00 00 10       	add    $0x10000000,%eax
}

static inline void
lcr3(uint32_t val)
{
	asm volatile("movl %0,%%cr3" : : "r" (val));
f01002a6:	0f 22 d8             	mov    %eax,%cr3
	cprintf("  AP #%d [apicid %02x] starting\n", cpunum(), thiscpu->cpu_apicid);
f01002a9:	e8 7a 61 00 00       	call   f0106428 <cpunum>
f01002ae:	6b c0 74             	imul   $0x74,%eax,%eax
f01002b1:	0f b6 98 00 80 2c f0 	movzbl -0xfd38000(%eax),%ebx
f01002b8:	e8 6b 61 00 00       	call   f0106428 <cpunum>
f01002bd:	83 ec 04             	sub    $0x4,%esp
f01002c0:	53                   	push   %ebx
f01002c1:	50                   	push   %eax
f01002c2:	68 10 78 10 f0       	push   $0xf0107810
f01002c7:	e8 d7 39 00 00       	call   f0103ca3 <cprintf>
	lapic_init();
f01002cc:	e8 b2 61 00 00       	call   f0106483 <lapic_init>
	env_init_percpu();
f01002d1:	e8 7d 31 00 00       	call   f0103453 <env_init_percpu>
	trap_init_percpu();
f01002d6:	e8 dc 39 00 00       	call   f0103cb7 <trap_init_percpu>
	xchg(&thiscpu->cpu_status, CPU_STARTED); // tell boot_aps() we're up
f01002db:	e8 48 61 00 00       	call   f0106428 <cpunum>
f01002e0:	6b d0 74             	imul   $0x74,%eax,%edx
f01002e3:	83 c2 04             	add    $0x4,%edx
xchg(volatile uint32_t *addr, uint32_t newval)
{
	uint32_t result;

	// The + in "+m" denotes a read-modify-write operand.
	asm volatile("lock; xchgl %0, %1"
f01002e6:	b8 01 00 00 00       	mov    $0x1,%eax
f01002eb:	f0 87 82 00 80 2c f0 	lock xchg %eax,-0xfd38000(%edx)
f01002f2:	c7 04 24 60 b4 12 f0 	movl   $0xf012b460,(%esp)
f01002f9:	e8 07 65 00 00       	call   f0106805 <spin_lock>
	sched_yield();
f01002fe:	e8 b6 44 00 00       	call   f01047b9 <sched_yield>

f0100303 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0100303:	55                   	push   %ebp
f0100304:	89 e5                	mov    %esp,%ebp
f0100306:	53                   	push   %ebx
f0100307:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f010030a:	8d 5d 14             	lea    0x14(%ebp),%ebx
	cprintf("kernel warning at %s:%d: ", file, line);
f010030d:	ff 75 0c             	pushl  0xc(%ebp)
f0100310:	ff 75 08             	pushl  0x8(%ebp)
f0100313:	68 88 78 10 f0       	push   $0xf0107888
f0100318:	e8 86 39 00 00       	call   f0103ca3 <cprintf>
	vcprintf(fmt, ap);
f010031d:	83 c4 08             	add    $0x8,%esp
f0100320:	53                   	push   %ebx
f0100321:	ff 75 10             	pushl  0x10(%ebp)
f0100324:	e8 54 39 00 00       	call   f0103c7d <vcprintf>
	cprintf("\n");
f0100329:	c7 04 24 ec 8a 10 f0 	movl   $0xf0108aec,(%esp)
f0100330:	e8 6e 39 00 00       	call   f0103ca3 <cprintf>
	va_end(ap);
}
f0100335:	83 c4 10             	add    $0x10,%esp
f0100338:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f010033b:	c9                   	leave  
f010033c:	c3                   	ret    

f010033d <serial_proc_data>:

static bool serial_exists;

static int
serial_proc_data(void)
{
f010033d:	55                   	push   %ebp
f010033e:	89 e5                	mov    %esp,%ebp
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100340:	ba fd 03 00 00       	mov    $0x3fd,%edx
f0100345:	ec                   	in     (%dx),%al
	if (!(inb(COM1+COM_LSR) & COM_LSR_DATA))
f0100346:	a8 01                	test   $0x1,%al
f0100348:	74 0b                	je     f0100355 <serial_proc_data+0x18>
f010034a:	ba f8 03 00 00       	mov    $0x3f8,%edx
f010034f:	ec                   	in     (%dx),%al
		return -1;
	return inb(COM1+COM_RX);
f0100350:	0f b6 c0             	movzbl %al,%eax
}
f0100353:	5d                   	pop    %ebp
f0100354:	c3                   	ret    
		return -1;
f0100355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010035a:	eb f7                	jmp    f0100353 <serial_proc_data+0x16>

f010035c <cons_intr>:

// called by device interrupt routines to feed input characters
// into the circular console input buffer.
static void
cons_intr(int (*proc)(void))
{
f010035c:	55                   	push   %ebp
f010035d:	89 e5                	mov    %esp,%ebp
f010035f:	53                   	push   %ebx
f0100360:	83 ec 04             	sub    $0x4,%esp
f0100363:	89 c3                	mov    %eax,%ebx
	int c;

	while ((c = (*proc)()) != -1) {
f0100365:	ff d3                	call   *%ebx
f0100367:	83 f8 ff             	cmp    $0xffffffff,%eax
f010036a:	74 2d                	je     f0100399 <cons_intr+0x3d>
		if (c == 0)
f010036c:	85 c0                	test   %eax,%eax
f010036e:	74 f5                	je     f0100365 <cons_intr+0x9>
			continue;
		cons.buf[cons.wpos++] = c;
f0100370:	8b 0d 24 62 2c f0    	mov    0xf02c6224,%ecx
f0100376:	8d 51 01             	lea    0x1(%ecx),%edx
f0100379:	89 15 24 62 2c f0    	mov    %edx,0xf02c6224
f010037f:	88 81 20 60 2c f0    	mov    %al,-0xfd39fe0(%ecx)
		if (cons.wpos == CONSBUFSIZE)
f0100385:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f010038b:	75 d8                	jne    f0100365 <cons_intr+0x9>
			cons.wpos = 0;
f010038d:	c7 05 24 62 2c f0 00 	movl   $0x0,0xf02c6224
f0100394:	00 00 00 
f0100397:	eb cc                	jmp    f0100365 <cons_intr+0x9>
	}
}
f0100399:	83 c4 04             	add    $0x4,%esp
f010039c:	5b                   	pop    %ebx
f010039d:	5d                   	pop    %ebp
f010039e:	c3                   	ret    

f010039f <kbd_proc_data>:
{
f010039f:	55                   	push   %ebp
f01003a0:	89 e5                	mov    %esp,%ebp
f01003a2:	53                   	push   %ebx
f01003a3:	83 ec 04             	sub    $0x4,%esp
f01003a6:	ba 64 00 00 00       	mov    $0x64,%edx
f01003ab:	ec                   	in     (%dx),%al
	if ((stat & KBS_DIB) == 0)
f01003ac:	a8 01                	test   $0x1,%al
f01003ae:	0f 84 eb 00 00 00    	je     f010049f <kbd_proc_data+0x100>
	if (stat & KBS_TERR)
f01003b4:	a8 20                	test   $0x20,%al
f01003b6:	0f 85 ea 00 00 00    	jne    f01004a6 <kbd_proc_data+0x107>
f01003bc:	ba 60 00 00 00       	mov    $0x60,%edx
f01003c1:	ec                   	in     (%dx),%al
f01003c2:	88 c2                	mov    %al,%dl
	if (data == 0xE0) {
f01003c4:	3c e0                	cmp    $0xe0,%al
f01003c6:	74 73                	je     f010043b <kbd_proc_data+0x9c>
	} else if (data & 0x80) {
f01003c8:	84 c0                	test   %al,%al
f01003ca:	78 7d                	js     f0100449 <kbd_proc_data+0xaa>
	} else if (shift & E0ESC) {
f01003cc:	8b 0d 00 60 2c f0    	mov    0xf02c6000,%ecx
f01003d2:	f6 c1 40             	test   $0x40,%cl
f01003d5:	74 0e                	je     f01003e5 <kbd_proc_data+0x46>
		data |= 0x80;
f01003d7:	83 c8 80             	or     $0xffffff80,%eax
f01003da:	88 c2                	mov    %al,%dl
		shift &= ~E0ESC;
f01003dc:	83 e1 bf             	and    $0xffffffbf,%ecx
f01003df:	89 0d 00 60 2c f0    	mov    %ecx,0xf02c6000
	shift |= shiftcode[data];
f01003e5:	0f b6 d2             	movzbl %dl,%edx
f01003e8:	0f b6 82 00 7a 10 f0 	movzbl -0xfef8600(%edx),%eax
f01003ef:	0b 05 00 60 2c f0    	or     0xf02c6000,%eax
	shift ^= togglecode[data];
f01003f5:	0f b6 8a 00 79 10 f0 	movzbl -0xfef8700(%edx),%ecx
f01003fc:	31 c8                	xor    %ecx,%eax
f01003fe:	a3 00 60 2c f0       	mov    %eax,0xf02c6000
	c = charcode[shift & (CTL | SHIFT)][data];
f0100403:	89 c1                	mov    %eax,%ecx
f0100405:	83 e1 03             	and    $0x3,%ecx
f0100408:	8b 0c 8d e0 78 10 f0 	mov    -0xfef8720(,%ecx,4),%ecx
f010040f:	8a 14 11             	mov    (%ecx,%edx,1),%dl
f0100412:	0f b6 da             	movzbl %dl,%ebx
	if (shift & CAPSLOCK) {
f0100415:	a8 08                	test   $0x8,%al
f0100417:	74 0d                	je     f0100426 <kbd_proc_data+0x87>
		if ('a' <= c && c <= 'z')
f0100419:	89 da                	mov    %ebx,%edx
f010041b:	8d 4b 9f             	lea    -0x61(%ebx),%ecx
f010041e:	83 f9 19             	cmp    $0x19,%ecx
f0100421:	77 55                	ja     f0100478 <kbd_proc_data+0xd9>
			c += 'A' - 'a';
f0100423:	83 eb 20             	sub    $0x20,%ebx
	if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0100426:	f7 d0                	not    %eax
f0100428:	a8 06                	test   $0x6,%al
f010042a:	75 08                	jne    f0100434 <kbd_proc_data+0x95>
f010042c:	81 fb e9 00 00 00    	cmp    $0xe9,%ebx
f0100432:	74 51                	je     f0100485 <kbd_proc_data+0xe6>
}
f0100434:	89 d8                	mov    %ebx,%eax
f0100436:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0100439:	c9                   	leave  
f010043a:	c3                   	ret    
		shift |= E0ESC;
f010043b:	83 0d 00 60 2c f0 40 	orl    $0x40,0xf02c6000
		return 0;
f0100442:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100447:	eb eb                	jmp    f0100434 <kbd_proc_data+0x95>
		data = (shift & E0ESC ? data : data & 0x7F);
f0100449:	8b 0d 00 60 2c f0    	mov    0xf02c6000,%ecx
f010044f:	f6 c1 40             	test   $0x40,%cl
f0100452:	75 05                	jne    f0100459 <kbd_proc_data+0xba>
f0100454:	83 e0 7f             	and    $0x7f,%eax
f0100457:	88 c2                	mov    %al,%dl
		shift &= ~(shiftcode[data] | E0ESC);
f0100459:	0f b6 d2             	movzbl %dl,%edx
f010045c:	8a 82 00 7a 10 f0    	mov    -0xfef8600(%edx),%al
f0100462:	83 c8 40             	or     $0x40,%eax
f0100465:	0f b6 c0             	movzbl %al,%eax
f0100468:	f7 d0                	not    %eax
f010046a:	21 c8                	and    %ecx,%eax
f010046c:	a3 00 60 2c f0       	mov    %eax,0xf02c6000
		return 0;
f0100471:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100476:	eb bc                	jmp    f0100434 <kbd_proc_data+0x95>
		else if ('A' <= c && c <= 'Z')
f0100478:	83 ea 41             	sub    $0x41,%edx
f010047b:	83 fa 19             	cmp    $0x19,%edx
f010047e:	77 a6                	ja     f0100426 <kbd_proc_data+0x87>
			c += 'a' - 'A';
f0100480:	83 c3 20             	add    $0x20,%ebx
f0100483:	eb a1                	jmp    f0100426 <kbd_proc_data+0x87>
		cprintf("Rebooting!\n");
f0100485:	83 ec 0c             	sub    $0xc,%esp
f0100488:	68 a2 78 10 f0       	push   $0xf01078a2
f010048d:	e8 11 38 00 00       	call   f0103ca3 <cprintf>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100492:	ba 92 00 00 00       	mov    $0x92,%edx
f0100497:	b0 03                	mov    $0x3,%al
f0100499:	ee                   	out    %al,(%dx)
f010049a:	83 c4 10             	add    $0x10,%esp
f010049d:	eb 95                	jmp    f0100434 <kbd_proc_data+0x95>
		return -1;
f010049f:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01004a4:	eb 8e                	jmp    f0100434 <kbd_proc_data+0x95>
		return -1;
f01004a6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
f01004ab:	eb 87                	jmp    f0100434 <kbd_proc_data+0x95>

f01004ad <cons_putc>:
}

// output a character to the console
static void
cons_putc(int c)
{
f01004ad:	55                   	push   %ebp
f01004ae:	89 e5                	mov    %esp,%ebp
f01004b0:	57                   	push   %edi
f01004b1:	56                   	push   %esi
f01004b2:	53                   	push   %ebx
f01004b3:	83 ec 1c             	sub    $0x1c,%esp
f01004b6:	89 c7                	mov    %eax,%edi
f01004b8:	bb 01 32 00 00       	mov    $0x3201,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004bd:	be fd 03 00 00       	mov    $0x3fd,%esi
f01004c2:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004c7:	eb 06                	jmp    f01004cf <cons_putc+0x22>
f01004c9:	89 ca                	mov    %ecx,%edx
f01004cb:	ec                   	in     (%dx),%al
f01004cc:	ec                   	in     (%dx),%al
f01004cd:	ec                   	in     (%dx),%al
f01004ce:	ec                   	in     (%dx),%al
f01004cf:	89 f2                	mov    %esi,%edx
f01004d1:	ec                   	in     (%dx),%al
	for (i = 0;
f01004d2:	a8 20                	test   $0x20,%al
f01004d4:	75 03                	jne    f01004d9 <cons_putc+0x2c>
	     !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800;
f01004d6:	4b                   	dec    %ebx
f01004d7:	75 f0                	jne    f01004c9 <cons_putc+0x1c>
	outb(COM1 + COM_TX, c);
f01004d9:	89 f8                	mov    %edi,%eax
f01004db:	88 45 e7             	mov    %al,-0x19(%ebp)
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f01004de:	ba f8 03 00 00       	mov    $0x3f8,%edx
f01004e3:	ee                   	out    %al,(%dx)
f01004e4:	bb 01 32 00 00       	mov    $0x3201,%ebx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01004e9:	be 79 03 00 00       	mov    $0x379,%esi
f01004ee:	b9 84 00 00 00       	mov    $0x84,%ecx
f01004f3:	eb 06                	jmp    f01004fb <cons_putc+0x4e>
f01004f5:	89 ca                	mov    %ecx,%edx
f01004f7:	ec                   	in     (%dx),%al
f01004f8:	ec                   	in     (%dx),%al
f01004f9:	ec                   	in     (%dx),%al
f01004fa:	ec                   	in     (%dx),%al
f01004fb:	89 f2                	mov    %esi,%edx
f01004fd:	ec                   	in     (%dx),%al
	for (i = 0; !(inb(0x378+1) & 0x80) && i < 12800; i++)
f01004fe:	84 c0                	test   %al,%al
f0100500:	78 03                	js     f0100505 <cons_putc+0x58>
f0100502:	4b                   	dec    %ebx
f0100503:	75 f0                	jne    f01004f5 <cons_putc+0x48>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100505:	ba 78 03 00 00       	mov    $0x378,%edx
f010050a:	8a 45 e7             	mov    -0x19(%ebp),%al
f010050d:	ee                   	out    %al,(%dx)
f010050e:	ba 7a 03 00 00       	mov    $0x37a,%edx
f0100513:	b0 0d                	mov    $0xd,%al
f0100515:	ee                   	out    %al,(%dx)
f0100516:	b0 08                	mov    $0x8,%al
f0100518:	ee                   	out    %al,(%dx)
	if (!console_color) {
f0100519:	83 3d ac 6f 2c f0 00 	cmpl   $0x0,0xf02c6fac
f0100520:	75 0a                	jne    f010052c <cons_putc+0x7f>
		console_color = 0x700;
f0100522:	c7 05 ac 6f 2c f0 00 	movl   $0x700,0xf02c6fac
f0100529:	07 00 00 
	if (!(c & ~0xFF))
f010052c:	f7 c7 00 ff ff ff    	test   $0xffffff00,%edi
f0100532:	75 06                	jne    f010053a <cons_putc+0x8d>
		c |= console_color;
f0100534:	0b 3d ac 6f 2c f0    	or     0xf02c6fac,%edi
	switch (c & 0xff) {
f010053a:	89 f8                	mov    %edi,%eax
f010053c:	0f b6 c0             	movzbl %al,%eax
f010053f:	83 f8 09             	cmp    $0x9,%eax
f0100542:	0f 84 b1 00 00 00    	je     f01005f9 <cons_putc+0x14c>
f0100548:	83 f8 09             	cmp    $0x9,%eax
f010054b:	7e 70                	jle    f01005bd <cons_putc+0x110>
f010054d:	83 f8 0a             	cmp    $0xa,%eax
f0100550:	0f 84 96 00 00 00    	je     f01005ec <cons_putc+0x13f>
f0100556:	83 f8 0d             	cmp    $0xd,%eax
f0100559:	0f 85 d1 00 00 00    	jne    f0100630 <cons_putc+0x183>
		crt_pos -= (crt_pos % CRT_COLS);
f010055f:	66 8b 0d 28 62 2c f0 	mov    0xf02c6228,%cx
f0100566:	bb 50 00 00 00       	mov    $0x50,%ebx
f010056b:	89 c8                	mov    %ecx,%eax
f010056d:	ba 00 00 00 00       	mov    $0x0,%edx
f0100572:	66 f7 f3             	div    %bx
f0100575:	29 d1                	sub    %edx,%ecx
f0100577:	66 89 0d 28 62 2c f0 	mov    %cx,0xf02c6228
	if (crt_pos >= CRT_SIZE) {
f010057e:	66 81 3d 28 62 2c f0 	cmpw   $0x7cf,0xf02c6228
f0100585:	cf 07 
f0100587:	0f 87 c5 00 00 00    	ja     f0100652 <cons_putc+0x1a5>
	outb(addr_6845, 14);
f010058d:	8b 0d 30 62 2c f0    	mov    0xf02c6230,%ecx
f0100593:	b0 0e                	mov    $0xe,%al
f0100595:	89 ca                	mov    %ecx,%edx
f0100597:	ee                   	out    %al,(%dx)
	outb(addr_6845 + 1, crt_pos >> 8);
f0100598:	8d 59 01             	lea    0x1(%ecx),%ebx
f010059b:	66 a1 28 62 2c f0    	mov    0xf02c6228,%ax
f01005a1:	66 c1 e8 08          	shr    $0x8,%ax
f01005a5:	89 da                	mov    %ebx,%edx
f01005a7:	ee                   	out    %al,(%dx)
f01005a8:	b0 0f                	mov    $0xf,%al
f01005aa:	89 ca                	mov    %ecx,%edx
f01005ac:	ee                   	out    %al,(%dx)
f01005ad:	a0 28 62 2c f0       	mov    0xf02c6228,%al
f01005b2:	89 da                	mov    %ebx,%edx
f01005b4:	ee                   	out    %al,(%dx)
	serial_putc(c);
	lpt_putc(c);
	cga_putc(c);
}
f01005b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01005b8:	5b                   	pop    %ebx
f01005b9:	5e                   	pop    %esi
f01005ba:	5f                   	pop    %edi
f01005bb:	5d                   	pop    %ebp
f01005bc:	c3                   	ret    
	switch (c & 0xff) {
f01005bd:	83 f8 08             	cmp    $0x8,%eax
f01005c0:	75 6e                	jne    f0100630 <cons_putc+0x183>
		if (crt_pos > 0) {
f01005c2:	66 a1 28 62 2c f0    	mov    0xf02c6228,%ax
f01005c8:	66 85 c0             	test   %ax,%ax
f01005cb:	74 c0                	je     f010058d <cons_putc+0xe0>
			crt_pos--;
f01005cd:	48                   	dec    %eax
f01005ce:	66 a3 28 62 2c f0    	mov    %ax,0xf02c6228
			crt_buf[crt_pos] = (c & ~0xff) | ' ';
f01005d4:	0f b7 c0             	movzwl %ax,%eax
f01005d7:	81 e7 00 ff ff ff    	and    $0xffffff00,%edi
f01005dd:	83 cf 20             	or     $0x20,%edi
f01005e0:	8b 15 2c 62 2c f0    	mov    0xf02c622c,%edx
f01005e6:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f01005ea:	eb 92                	jmp    f010057e <cons_putc+0xd1>
		crt_pos += CRT_COLS;
f01005ec:	66 83 05 28 62 2c f0 	addw   $0x50,0xf02c6228
f01005f3:	50 
f01005f4:	e9 66 ff ff ff       	jmp    f010055f <cons_putc+0xb2>
		cons_putc(' ');
f01005f9:	b8 20 00 00 00       	mov    $0x20,%eax
f01005fe:	e8 aa fe ff ff       	call   f01004ad <cons_putc>
		cons_putc(' ');
f0100603:	b8 20 00 00 00       	mov    $0x20,%eax
f0100608:	e8 a0 fe ff ff       	call   f01004ad <cons_putc>
		cons_putc(' ');
f010060d:	b8 20 00 00 00       	mov    $0x20,%eax
f0100612:	e8 96 fe ff ff       	call   f01004ad <cons_putc>
		cons_putc(' ');
f0100617:	b8 20 00 00 00       	mov    $0x20,%eax
f010061c:	e8 8c fe ff ff       	call   f01004ad <cons_putc>
		cons_putc(' ');
f0100621:	b8 20 00 00 00       	mov    $0x20,%eax
f0100626:	e8 82 fe ff ff       	call   f01004ad <cons_putc>
f010062b:	e9 4e ff ff ff       	jmp    f010057e <cons_putc+0xd1>
		crt_buf[crt_pos++] = c;		
f0100630:	66 a1 28 62 2c f0    	mov    0xf02c6228,%ax
f0100636:	8d 50 01             	lea    0x1(%eax),%edx
f0100639:	66 89 15 28 62 2c f0 	mov    %dx,0xf02c6228
f0100640:	0f b7 c0             	movzwl %ax,%eax
f0100643:	8b 15 2c 62 2c f0    	mov    0xf02c622c,%edx
f0100649:	66 89 3c 42          	mov    %di,(%edx,%eax,2)
f010064d:	e9 2c ff ff ff       	jmp    f010057e <cons_putc+0xd1>
		memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
f0100652:	a1 2c 62 2c f0       	mov    0xf02c622c,%eax
f0100657:	83 ec 04             	sub    $0x4,%esp
f010065a:	68 00 0f 00 00       	push   $0xf00
f010065f:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
f0100665:	52                   	push   %edx
f0100666:	50                   	push   %eax
f0100667:	e8 fe 56 00 00       	call   f0105d6a <memmove>
			crt_buf[i] = 0x0700 | ' ';
f010066c:	8b 15 2c 62 2c f0    	mov    0xf02c622c,%edx
f0100672:	8d 82 00 0f 00 00    	lea    0xf00(%edx),%eax
f0100678:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f010067e:	83 c4 10             	add    $0x10,%esp
f0100681:	66 c7 00 20 07       	movw   $0x720,(%eax)
f0100686:	83 c0 02             	add    $0x2,%eax
		for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i++)
f0100689:	39 d0                	cmp    %edx,%eax
f010068b:	75 f4                	jne    f0100681 <cons_putc+0x1d4>
		crt_pos -= CRT_COLS;
f010068d:	66 83 2d 28 62 2c f0 	subw   $0x50,0xf02c6228
f0100694:	50 
f0100695:	e9 f3 fe ff ff       	jmp    f010058d <cons_putc+0xe0>

f010069a <serial_intr>:
	if (serial_exists)
f010069a:	80 3d 34 62 2c f0 00 	cmpb   $0x0,0xf02c6234
f01006a1:	75 01                	jne    f01006a4 <serial_intr+0xa>
}
f01006a3:	c3                   	ret    
{
f01006a4:	55                   	push   %ebp
f01006a5:	89 e5                	mov    %esp,%ebp
f01006a7:	83 ec 08             	sub    $0x8,%esp
		cons_intr(serial_proc_data);
f01006aa:	b8 3d 03 10 f0       	mov    $0xf010033d,%eax
f01006af:	e8 a8 fc ff ff       	call   f010035c <cons_intr>
}
f01006b4:	c9                   	leave  
f01006b5:	eb ec                	jmp    f01006a3 <serial_intr+0x9>

f01006b7 <kbd_intr>:
{
f01006b7:	55                   	push   %ebp
f01006b8:	89 e5                	mov    %esp,%ebp
f01006ba:	83 ec 08             	sub    $0x8,%esp
	cons_intr(kbd_proc_data);
f01006bd:	b8 9f 03 10 f0       	mov    $0xf010039f,%eax
f01006c2:	e8 95 fc ff ff       	call   f010035c <cons_intr>
}
f01006c7:	c9                   	leave  
f01006c8:	c3                   	ret    

f01006c9 <cons_getc>:
{
f01006c9:	55                   	push   %ebp
f01006ca:	89 e5                	mov    %esp,%ebp
f01006cc:	83 ec 08             	sub    $0x8,%esp
	serial_intr();
f01006cf:	e8 c6 ff ff ff       	call   f010069a <serial_intr>
	kbd_intr();
f01006d4:	e8 de ff ff ff       	call   f01006b7 <kbd_intr>
	if (cons.rpos != cons.wpos) {
f01006d9:	a1 20 62 2c f0       	mov    0xf02c6220,%eax
f01006de:	3b 05 24 62 2c f0    	cmp    0xf02c6224,%eax
f01006e4:	74 26                	je     f010070c <cons_getc+0x43>
		c = cons.buf[cons.rpos++];
f01006e6:	8d 50 01             	lea    0x1(%eax),%edx
f01006e9:	89 15 20 62 2c f0    	mov    %edx,0xf02c6220
f01006ef:	0f b6 80 20 60 2c f0 	movzbl -0xfd39fe0(%eax),%eax
		if (cons.rpos == CONSBUFSIZE)
f01006f6:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f01006fc:	74 02                	je     f0100700 <cons_getc+0x37>
}
f01006fe:	c9                   	leave  
f01006ff:	c3                   	ret    
			cons.rpos = 0;
f0100700:	c7 05 20 62 2c f0 00 	movl   $0x0,0xf02c6220
f0100707:	00 00 00 
f010070a:	eb f2                	jmp    f01006fe <cons_getc+0x35>
	return 0;
f010070c:	b8 00 00 00 00       	mov    $0x0,%eax
f0100711:	eb eb                	jmp    f01006fe <cons_getc+0x35>

f0100713 <cons_init>:

// initialize the console devices
void
cons_init(void)
{
f0100713:	55                   	push   %ebp
f0100714:	89 e5                	mov    %esp,%ebp
f0100716:	56                   	push   %esi
f0100717:	53                   	push   %ebx
	was = *cp;
f0100718:	66 8b 15 00 80 0b f0 	mov    0xf00b8000,%dx
	*cp = (uint16_t) 0xA55A;
f010071f:	66 c7 05 00 80 0b f0 	movw   $0xa55a,0xf00b8000
f0100726:	5a a5 
	if (*cp != 0xA55A) {
f0100728:	66 a1 00 80 0b f0    	mov    0xf00b8000,%ax
f010072e:	66 3d 5a a5          	cmp    $0xa55a,%ax
f0100732:	0f 84 a7 00 00 00    	je     f01007df <cons_init+0xcc>
		addr_6845 = MONO_BASE;
f0100738:	c7 05 30 62 2c f0 b4 	movl   $0x3b4,0xf02c6230
f010073f:	03 00 00 
		cp = (uint16_t*) (KERNBASE + MONO_BUF);
f0100742:	be 00 00 0b f0       	mov    $0xf00b0000,%esi
f0100747:	b0 0e                	mov    $0xe,%al
f0100749:	8b 15 30 62 2c f0    	mov    0xf02c6230,%edx
f010074f:	ee                   	out    %al,(%dx)
	pos = inb(addr_6845 + 1) << 8;
f0100750:	8d 4a 01             	lea    0x1(%edx),%ecx
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100753:	89 ca                	mov    %ecx,%edx
f0100755:	ec                   	in     (%dx),%al
f0100756:	0f b6 c0             	movzbl %al,%eax
f0100759:	c1 e0 08             	shl    $0x8,%eax
f010075c:	89 c3                	mov    %eax,%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010075e:	b0 0f                	mov    $0xf,%al
f0100760:	8b 15 30 62 2c f0    	mov    0xf02c6230,%edx
f0100766:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0100767:	89 ca                	mov    %ecx,%edx
f0100769:	ec                   	in     (%dx),%al
	crt_buf = (uint16_t*) cp;
f010076a:	89 35 2c 62 2c f0    	mov    %esi,0xf02c622c
	pos |= inb(addr_6845 + 1);
f0100770:	0f b6 c0             	movzbl %al,%eax
f0100773:	09 d8                	or     %ebx,%eax
	crt_pos = pos;
f0100775:	66 a3 28 62 2c f0    	mov    %ax,0xf02c6228
	kbd_intr();
f010077b:	e8 37 ff ff ff       	call   f01006b7 <kbd_intr>
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0100780:	be fa 03 00 00       	mov    $0x3fa,%esi
f0100785:	b0 00                	mov    $0x0,%al
f0100787:	89 f2                	mov    %esi,%edx
f0100789:	ee                   	out    %al,(%dx)
f010078a:	ba fb 03 00 00       	mov    $0x3fb,%edx
f010078f:	b0 80                	mov    $0x80,%al
f0100791:	ee                   	out    %al,(%dx)
f0100792:	bb f8 03 00 00       	mov    $0x3f8,%ebx
f0100797:	b0 0c                	mov    $0xc,%al
f0100799:	89 da                	mov    %ebx,%edx
f010079b:	ee                   	out    %al,(%dx)
f010079c:	ba f9 03 00 00       	mov    $0x3f9,%edx
f01007a1:	b0 00                	mov    $0x0,%al
f01007a3:	ee                   	out    %al,(%dx)
f01007a4:	ba fb 03 00 00       	mov    $0x3fb,%edx
f01007a9:	b0 03                	mov    $0x3,%al
f01007ab:	ee                   	out    %al,(%dx)
f01007ac:	ba fc 03 00 00       	mov    $0x3fc,%edx
f01007b1:	b0 00                	mov    $0x0,%al
f01007b3:	ee                   	out    %al,(%dx)
f01007b4:	ba f9 03 00 00       	mov    $0x3f9,%edx
f01007b9:	b0 01                	mov    $0x1,%al
f01007bb:	ee                   	out    %al,(%dx)
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01007bc:	ba fd 03 00 00       	mov    $0x3fd,%edx
f01007c1:	ec                   	in     (%dx),%al
f01007c2:	88 c1                	mov    %al,%cl
	serial_exists = (inb(COM1+COM_LSR) != 0xFF);
f01007c4:	3c ff                	cmp    $0xff,%al
f01007c6:	0f 95 05 34 62 2c f0 	setne  0xf02c6234
f01007cd:	89 f2                	mov    %esi,%edx
f01007cf:	ec                   	in     (%dx),%al
f01007d0:	89 da                	mov    %ebx,%edx
f01007d2:	ec                   	in     (%dx),%al
	cga_init();
	kbd_init();
	serial_init();

	if (!serial_exists)
f01007d3:	80 f9 ff             	cmp    $0xff,%cl
f01007d6:	74 22                	je     f01007fa <cons_init+0xe7>
		cprintf("Serial port does not exist!\n");
}
f01007d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01007db:	5b                   	pop    %ebx
f01007dc:	5e                   	pop    %esi
f01007dd:	5d                   	pop    %ebp
f01007de:	c3                   	ret    
		*cp = was;
f01007df:	66 89 15 00 80 0b f0 	mov    %dx,0xf00b8000
		addr_6845 = CGA_BASE;
f01007e6:	c7 05 30 62 2c f0 d4 	movl   $0x3d4,0xf02c6230
f01007ed:	03 00 00 
	cp = (uint16_t*) (KERNBASE + CGA_BUF);
f01007f0:	be 00 80 0b f0       	mov    $0xf00b8000,%esi
f01007f5:	e9 4d ff ff ff       	jmp    f0100747 <cons_init+0x34>
		cprintf("Serial port does not exist!\n");
f01007fa:	83 ec 0c             	sub    $0xc,%esp
f01007fd:	68 ae 78 10 f0       	push   $0xf01078ae
f0100802:	e8 9c 34 00 00       	call   f0103ca3 <cprintf>
f0100807:	83 c4 10             	add    $0x10,%esp
}
f010080a:	eb cc                	jmp    f01007d8 <cons_init+0xc5>

f010080c <cputchar>:

// `High'-level console I/O.  Used by readline and cprintf.

void
cputchar(int c)
{
f010080c:	55                   	push   %ebp
f010080d:	89 e5                	mov    %esp,%ebp
f010080f:	83 ec 08             	sub    $0x8,%esp
	cons_putc(c);
f0100812:	8b 45 08             	mov    0x8(%ebp),%eax
f0100815:	e8 93 fc ff ff       	call   f01004ad <cons_putc>
}
f010081a:	c9                   	leave  
f010081b:	c3                   	ret    

f010081c <getchar>:

int
getchar(void)
{
f010081c:	55                   	push   %ebp
f010081d:	89 e5                	mov    %esp,%ebp
f010081f:	83 ec 08             	sub    $0x8,%esp
	int c;

	while ((c = cons_getc()) == 0)
f0100822:	e8 a2 fe ff ff       	call   f01006c9 <cons_getc>
f0100827:	85 c0                	test   %eax,%eax
f0100829:	74 f7                	je     f0100822 <getchar+0x6>
		/* do nothing */;
	return c;
}
f010082b:	c9                   	leave  
f010082c:	c3                   	ret    

f010082d <iscons>:

int
iscons(int fdnum)
{
f010082d:	55                   	push   %ebp
f010082e:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
}
f0100830:	b8 01 00 00 00       	mov    $0x1,%eax
f0100835:	5d                   	pop    %ebp
f0100836:	c3                   	ret    

f0100837 <mon_help>:

/***** Implementations of basic kernel monitor commands *****/

int
mon_help(int argc, char **argv, struct Trapframe *tf)
{
f0100837:	55                   	push   %ebp
f0100838:	89 e5                	mov    %esp,%ebp
f010083a:	83 ec 0c             	sub    $0xc,%esp
	int i;

	for (i = 0; i < ARRAY_SIZE(commands); i++)
		cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f010083d:	68 00 7b 10 f0       	push   $0xf0107b00
f0100842:	68 1e 7b 10 f0       	push   $0xf0107b1e
f0100847:	68 23 7b 10 f0       	push   $0xf0107b23
f010084c:	e8 52 34 00 00       	call   f0103ca3 <cprintf>
f0100851:	83 c4 0c             	add    $0xc,%esp
f0100854:	68 d8 7b 10 f0       	push   $0xf0107bd8
f0100859:	68 2c 7b 10 f0       	push   $0xf0107b2c
f010085e:	68 23 7b 10 f0       	push   $0xf0107b23
f0100863:	e8 3b 34 00 00       	call   f0103ca3 <cprintf>
f0100868:	83 c4 0c             	add    $0xc,%esp
f010086b:	68 00 7c 10 f0       	push   $0xf0107c00
f0100870:	68 35 7b 10 f0       	push   $0xf0107b35
f0100875:	68 23 7b 10 f0       	push   $0xf0107b23
f010087a:	e8 24 34 00 00       	call   f0103ca3 <cprintf>
	return 0;
}
f010087f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100884:	c9                   	leave  
f0100885:	c3                   	ret    

f0100886 <mon_kerninfo>:

int
mon_kerninfo(int argc, char **argv, struct Trapframe *tf)
{
f0100886:	55                   	push   %ebp
f0100887:	89 e5                	mov    %esp,%ebp
f0100889:	83 ec 14             	sub    $0x14,%esp
	extern char _start[], entry[], etext[], edata[], end[];

	cprintf("Special kernel symbols:\n");
f010088c:	68 3f 7b 10 f0       	push   $0xf0107b3f
f0100891:	e8 0d 34 00 00       	call   f0103ca3 <cprintf>
	cprintf("  _start                  %08x (phys)\n", _start);
f0100896:	83 c4 08             	add    $0x8,%esp
f0100899:	68 0c 00 10 00       	push   $0x10000c
f010089e:	68 2c 7c 10 f0       	push   $0xf0107c2c
f01008a3:	e8 fb 33 00 00       	call   f0103ca3 <cprintf>
	cprintf("  entry  %08x (virt)  %08x (phys)\n", entry, entry - KERNBASE);
f01008a8:	83 c4 0c             	add    $0xc,%esp
f01008ab:	68 0c 00 10 00       	push   $0x10000c
f01008b0:	68 0c 00 10 f0       	push   $0xf010000c
f01008b5:	68 54 7c 10 f0       	push   $0xf0107c54
f01008ba:	e8 e4 33 00 00       	call   f0103ca3 <cprintf>
	cprintf("  etext  %08x (virt)  %08x (phys)\n", etext, etext - KERNBASE);
f01008bf:	83 c4 0c             	add    $0xc,%esp
f01008c2:	68 80 77 10 00       	push   $0x107780
f01008c7:	68 80 77 10 f0       	push   $0xf0107780
f01008cc:	68 78 7c 10 f0       	push   $0xf0107c78
f01008d1:	e8 cd 33 00 00       	call   f0103ca3 <cprintf>
	cprintf("  edata  %08x (virt)  %08x (phys)\n", edata, edata - KERNBASE);
f01008d6:	83 c4 0c             	add    $0xc,%esp
f01008d9:	68 f4 50 2c 00       	push   $0x2c50f4
f01008de:	68 f4 50 2c f0       	push   $0xf02c50f4
f01008e3:	68 9c 7c 10 f0       	push   $0xf0107c9c
f01008e8:	e8 b6 33 00 00       	call   f0103ca3 <cprintf>
	cprintf("  end    %08x (virt)  %08x (phys)\n", end, end - KERNBASE);
f01008ed:	83 c4 0c             	add    $0xc,%esp
f01008f0:	68 28 90 30 00       	push   $0x309028
f01008f5:	68 28 90 30 f0       	push   $0xf0309028
f01008fa:	68 c0 7c 10 f0       	push   $0xf0107cc0
f01008ff:	e8 9f 33 00 00       	call   f0103ca3 <cprintf>
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100904:	83 c4 08             	add    $0x8,%esp
		ROUNDUP(end - entry, 1024) / 1024);
f0100907:	b8 27 94 30 f0       	mov    $0xf0309427,%eax
f010090c:	2d 0c 00 10 f0       	sub    $0xf010000c,%eax
	cprintf("Kernel executable memory footprint: %dKB\n",
f0100911:	c1 f8 0a             	sar    $0xa,%eax
f0100914:	50                   	push   %eax
f0100915:	68 e4 7c 10 f0       	push   $0xf0107ce4
f010091a:	e8 84 33 00 00       	call   f0103ca3 <cprintf>
	return 0;
}
f010091f:	b8 00 00 00 00       	mov    $0x0,%eax
f0100924:	c9                   	leave  
f0100925:	c3                   	ret    

f0100926 <mon_backtrace>:

int
mon_backtrace(int argc, char **argv, struct Trapframe *tf)
{
f0100926:	55                   	push   %ebp
f0100927:	89 e5                	mov    %esp,%ebp
f0100929:	57                   	push   %edi
f010092a:	56                   	push   %esi
f010092b:	53                   	push   %ebx
f010092c:	83 ec 48             	sub    $0x48,%esp
	// Your code here.
	cprintf("Stack backtrace:\n");
f010092f:	68 58 7b 10 f0       	push   $0xf0107b58
f0100934:	e8 6a 33 00 00       	call   f0103ca3 <cprintf>
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f0100939:	89 eb                	mov    %ebp,%ebx
	uint32_t* stkptr = (uint32_t*) read_ebp();
	while(stkptr != 0) {
f010093b:	83 c4 10             	add    $0x10,%esp
	//while(stkptr >= (uint32_t*) stackTop) {
		cprintf(" ebp %08x eip %08x args %08x %08x %08x %08x %08x\n"
			,stkptr, stkptr[1], stkptr[2], stkptr[3], stkptr[4], stkptr[5], stkptr[6]);
		struct Eipdebuginfo info;
		int res = debuginfo_eip((uintptr_t)stkptr[1], &info);
f010093e:	8d 7d d0             	lea    -0x30(%ebp),%edi
	while(stkptr != 0) {
f0100941:	85 db                	test   %ebx,%ebx
f0100943:	0f 84 9a 00 00 00    	je     f01009e3 <mon_backtrace+0xbd>
f0100949:	89 65 c4             	mov    %esp,-0x3c(%ebp)
		cprintf(" ebp %08x eip %08x args %08x %08x %08x %08x %08x\n"
f010094c:	ff 73 18             	pushl  0x18(%ebx)
f010094f:	ff 73 14             	pushl  0x14(%ebx)
f0100952:	ff 73 10             	pushl  0x10(%ebx)
f0100955:	ff 73 0c             	pushl  0xc(%ebx)
f0100958:	ff 73 08             	pushl  0x8(%ebx)
f010095b:	ff 73 04             	pushl  0x4(%ebx)
f010095e:	53                   	push   %ebx
f010095f:	68 10 7d 10 f0       	push   $0xf0107d10
f0100964:	e8 3a 33 00 00       	call   f0103ca3 <cprintf>
		int res = debuginfo_eip((uintptr_t)stkptr[1], &info);
f0100969:	83 c4 18             	add    $0x18,%esp
f010096c:	57                   	push   %edi
f010096d:	ff 73 04             	pushl  0x4(%ebx)
f0100970:	e8 e1 46 00 00       	call   f0105056 <debuginfo_eip>
		assert(res == 0);
f0100975:	83 c4 10             	add    $0x10,%esp
f0100978:	85 c0                	test   %eax,%eax
f010097a:	75 51                	jne    f01009cd <mon_backtrace+0xa7>
		char fn_name[info.eip_fn_namelen+1];
f010097c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f010097f:	8d 41 10             	lea    0x10(%ecx),%eax
f0100982:	be 10 00 00 00       	mov    $0x10,%esi
f0100987:	ba 00 00 00 00       	mov    $0x0,%edx
f010098c:	f7 f6                	div    %esi
f010098e:	c1 e0 04             	shl    $0x4,%eax
f0100991:	29 c4                	sub    %eax,%esp
f0100993:	89 e6                	mov    %esp,%esi
		strncpy(fn_name, info.eip_fn_name, info.eip_fn_namelen);
f0100995:	83 ec 04             	sub    $0x4,%esp
f0100998:	51                   	push   %ecx
f0100999:	ff 75 d8             	pushl  -0x28(%ebp)
f010099c:	56                   	push   %esi
f010099d:	e8 92 52 00 00       	call   f0105c34 <strncpy>
		fn_name[info.eip_fn_namelen] = '\0';
f01009a2:	8b 45 dc             	mov    -0x24(%ebp),%eax
f01009a5:	c6 04 06 00          	movb   $0x0,(%esi,%eax,1)
		cprintf("         %s:%d: %s+%d\n", info.eip_file, info.eip_line, fn_name, stkptr[1]-info.eip_fn_addr);
f01009a9:	8b 43 04             	mov    0x4(%ebx),%eax
f01009ac:	2b 45 e0             	sub    -0x20(%ebp),%eax
f01009af:	89 04 24             	mov    %eax,(%esp)
f01009b2:	56                   	push   %esi
f01009b3:	ff 75 d4             	pushl  -0x2c(%ebp)
f01009b6:	ff 75 d0             	pushl  -0x30(%ebp)
f01009b9:	68 82 7b 10 f0       	push   $0xf0107b82
f01009be:	e8 e0 32 00 00       	call   f0103ca3 <cprintf>
		stkptr = (uint32_t*) *stkptr;
f01009c3:	8b 1b                	mov    (%ebx),%ebx
f01009c5:	8b 65 c4             	mov    -0x3c(%ebp),%esp
f01009c8:	e9 74 ff ff ff       	jmp    f0100941 <mon_backtrace+0x1b>
		assert(res == 0);
f01009cd:	68 6a 7b 10 f0       	push   $0xf0107b6a
f01009d2:	68 31 78 10 f0       	push   $0xf0107831
f01009d7:	6a 47                	push   $0x47
f01009d9:	68 73 7b 10 f0       	push   $0xf0107b73
f01009de:	e8 60 f6 ff ff       	call   f0100043 <_panic>

	}
	return 0;
}
f01009e3:	b8 00 00 00 00       	mov    $0x0,%eax
f01009e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01009eb:	5b                   	pop    %ebx
f01009ec:	5e                   	pop    %esi
f01009ed:	5f                   	pop    %edi
f01009ee:	5d                   	pop    %ebp
f01009ef:	c3                   	ret    

f01009f0 <monitor>:
	return 0;
}

void
monitor(struct Trapframe *tf)
{
f01009f0:	55                   	push   %ebp
f01009f1:	89 e5                	mov    %esp,%ebp
f01009f3:	57                   	push   %edi
f01009f4:	56                   	push   %esi
f01009f5:	53                   	push   %ebx
f01009f6:	83 ec 58             	sub    $0x58,%esp
	char *buf;

	cprintf("Welcome to the JOS kernel monitor!\n");
f01009f9:	68 44 7d 10 f0       	push   $0xf0107d44
f01009fe:	e8 a0 32 00 00       	call   f0103ca3 <cprintf>
	cprintf("Type 'help' for a list of commands.\n");
f0100a03:	c7 04 24 68 7d 10 f0 	movl   $0xf0107d68,(%esp)
f0100a0a:	e8 94 32 00 00       	call   f0103ca3 <cprintf>

	if (tf != NULL)
f0100a0f:	83 c4 10             	add    $0x10,%esp
f0100a12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
f0100a16:	74 57                	je     f0100a6f <monitor+0x7f>
		print_trapframe(tf);
f0100a18:	83 ec 0c             	sub    $0xc,%esp
f0100a1b:	ff 75 08             	pushl  0x8(%ebp)
f0100a1e:	e8 b3 35 00 00       	call   f0103fd6 <print_trapframe>
f0100a23:	83 c4 10             	add    $0x10,%esp
f0100a26:	eb 47                	jmp    f0100a6f <monitor+0x7f>
		while (*buf && strchr(WHITESPACE, *buf))
f0100a28:	83 ec 08             	sub    $0x8,%esp
f0100a2b:	0f be c0             	movsbl %al,%eax
f0100a2e:	50                   	push   %eax
f0100a2f:	68 9d 7b 10 f0       	push   $0xf0107b9d
f0100a34:	e8 af 52 00 00       	call   f0105ce8 <strchr>
f0100a39:	83 c4 10             	add    $0x10,%esp
f0100a3c:	85 c0                	test   %eax,%eax
f0100a3e:	74 0a                	je     f0100a4a <monitor+0x5a>
			*buf++ = 0;
f0100a40:	c6 03 00             	movb   $0x0,(%ebx)
f0100a43:	89 f7                	mov    %esi,%edi
f0100a45:	8d 5b 01             	lea    0x1(%ebx),%ebx
f0100a48:	eb 68                	jmp    f0100ab2 <monitor+0xc2>
		if (*buf == 0)
f0100a4a:	80 3b 00             	cmpb   $0x0,(%ebx)
f0100a4d:	74 6f                	je     f0100abe <monitor+0xce>
		if (argc == MAXARGS-1) {
f0100a4f:	83 fe 0f             	cmp    $0xf,%esi
f0100a52:	74 09                	je     f0100a5d <monitor+0x6d>
		argv[argc++] = buf;
f0100a54:	8d 7e 01             	lea    0x1(%esi),%edi
f0100a57:	89 5c b5 a8          	mov    %ebx,-0x58(%ebp,%esi,4)
f0100a5b:	eb 37                	jmp    f0100a94 <monitor+0xa4>
			cprintf("Too many arguments (max %d)\n", MAXARGS);
f0100a5d:	83 ec 08             	sub    $0x8,%esp
f0100a60:	6a 10                	push   $0x10
f0100a62:	68 a2 7b 10 f0       	push   $0xf0107ba2
f0100a67:	e8 37 32 00 00       	call   f0103ca3 <cprintf>
f0100a6c:	83 c4 10             	add    $0x10,%esp

	while (1) {
		buf = readline("K> ");
f0100a6f:	83 ec 0c             	sub    $0xc,%esp
f0100a72:	68 99 7b 10 f0       	push   $0xf0107b99
f0100a77:	e8 51 50 00 00       	call   f0105acd <readline>
f0100a7c:	89 c3                	mov    %eax,%ebx
		if (buf != NULL)
f0100a7e:	83 c4 10             	add    $0x10,%esp
f0100a81:	85 c0                	test   %eax,%eax
f0100a83:	74 ea                	je     f0100a6f <monitor+0x7f>
	argv[argc] = 0;
f0100a85:	c7 45 a8 00 00 00 00 	movl   $0x0,-0x58(%ebp)
	argc = 0;
f0100a8c:	be 00 00 00 00       	mov    $0x0,%esi
f0100a91:	eb 21                	jmp    f0100ab4 <monitor+0xc4>
			buf++;
f0100a93:	43                   	inc    %ebx
		while (*buf && !strchr(WHITESPACE, *buf))
f0100a94:	8a 03                	mov    (%ebx),%al
f0100a96:	84 c0                	test   %al,%al
f0100a98:	74 18                	je     f0100ab2 <monitor+0xc2>
f0100a9a:	83 ec 08             	sub    $0x8,%esp
f0100a9d:	0f be c0             	movsbl %al,%eax
f0100aa0:	50                   	push   %eax
f0100aa1:	68 9d 7b 10 f0       	push   $0xf0107b9d
f0100aa6:	e8 3d 52 00 00       	call   f0105ce8 <strchr>
f0100aab:	83 c4 10             	add    $0x10,%esp
f0100aae:	85 c0                	test   %eax,%eax
f0100ab0:	74 e1                	je     f0100a93 <monitor+0xa3>
			*buf++ = 0;
f0100ab2:	89 fe                	mov    %edi,%esi
		while (*buf && strchr(WHITESPACE, *buf))
f0100ab4:	8a 03                	mov    (%ebx),%al
f0100ab6:	84 c0                	test   %al,%al
f0100ab8:	0f 85 6a ff ff ff    	jne    f0100a28 <monitor+0x38>
	argv[argc] = 0;
f0100abe:	c7 44 b5 a8 00 00 00 	movl   $0x0,-0x58(%ebp,%esi,4)
f0100ac5:	00 
	if (argc == 0)
f0100ac6:	85 f6                	test   %esi,%esi
f0100ac8:	74 a5                	je     f0100a6f <monitor+0x7f>
f0100aca:	bf a0 7d 10 f0       	mov    $0xf0107da0,%edi
f0100acf:	bb 00 00 00 00       	mov    $0x0,%ebx
		if (strcmp(argv[0], commands[i].name) == 0)
f0100ad4:	83 ec 08             	sub    $0x8,%esp
f0100ad7:	ff 37                	pushl  (%edi)
f0100ad9:	ff 75 a8             	pushl  -0x58(%ebp)
f0100adc:	e8 b3 51 00 00       	call   f0105c94 <strcmp>
f0100ae1:	83 c4 10             	add    $0x10,%esp
f0100ae4:	85 c0                	test   %eax,%eax
f0100ae6:	74 21                	je     f0100b09 <monitor+0x119>
	for (i = 0; i < ARRAY_SIZE(commands); i++) {
f0100ae8:	43                   	inc    %ebx
f0100ae9:	83 c7 0c             	add    $0xc,%edi
f0100aec:	83 fb 03             	cmp    $0x3,%ebx
f0100aef:	75 e3                	jne    f0100ad4 <monitor+0xe4>
	cprintf("Unknown command '%s'\n", argv[0]);
f0100af1:	83 ec 08             	sub    $0x8,%esp
f0100af4:	ff 75 a8             	pushl  -0x58(%ebp)
f0100af7:	68 bf 7b 10 f0       	push   $0xf0107bbf
f0100afc:	e8 a2 31 00 00       	call   f0103ca3 <cprintf>
f0100b01:	83 c4 10             	add    $0x10,%esp
f0100b04:	e9 66 ff ff ff       	jmp    f0100a6f <monitor+0x7f>
			return commands[i].func(argc, argv, tf);
f0100b09:	83 ec 04             	sub    $0x4,%esp
f0100b0c:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
f0100b0f:	01 c3                	add    %eax,%ebx
f0100b11:	ff 75 08             	pushl  0x8(%ebp)
f0100b14:	8d 45 a8             	lea    -0x58(%ebp),%eax
f0100b17:	50                   	push   %eax
f0100b18:	56                   	push   %esi
f0100b19:	ff 14 9d a8 7d 10 f0 	call   *-0xfef8258(,%ebx,4)
			if (runcmd(buf, tf) < 0)
f0100b20:	83 c4 10             	add    $0x10,%esp
f0100b23:	85 c0                	test   %eax,%eax
f0100b25:	0f 89 44 ff ff ff    	jns    f0100a6f <monitor+0x7f>
				break;
	}
}
f0100b2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100b2e:	5b                   	pop    %ebx
f0100b2f:	5e                   	pop    %esi
f0100b30:	5f                   	pop    %edi
f0100b31:	5d                   	pop    %ebp
f0100b32:	c3                   	ret    

f0100b33 <e820_init>:

// This function may ONLY be used during initialization,
// before page_init().
void
e820_init(physaddr_t mbi_pa)
{
f0100b33:	55                   	push   %ebp
f0100b34:	89 e5                	mov    %esp,%ebp
f0100b36:	57                   	push   %edi
f0100b37:	56                   	push   %esi
f0100b38:	53                   	push   %ebx
f0100b39:	83 ec 1c             	sub    $0x1c,%esp
f0100b3c:	8b 75 08             	mov    0x8(%ebp),%esi
	struct multiboot_info *mbi;
	uint32_t addr, addr_end, i;

	mbi = (struct multiboot_info *)mbi_pa;
	assert(mbi->flags & MULTIBOOT_INFO_MEM_MAP);
f0100b3f:	f6 06 40             	testb  $0x40,(%esi)
f0100b42:	74 2d                	je     f0100b71 <e820_init+0x3e>
	cprintf("E820: physical memory map [mem 0x%08x-0x%08x]\n",
		mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
f0100b44:	8b 56 30             	mov    0x30(%esi),%edx
	cprintf("E820: physical memory map [mem 0x%08x-0x%08x]\n",
f0100b47:	83 ec 04             	sub    $0x4,%esp
		mbi->mmap_addr, mbi->mmap_addr + mbi->mmap_length - 1);
f0100b4a:	89 d0                	mov    %edx,%eax
f0100b4c:	03 46 2c             	add    0x2c(%esi),%eax
	cprintf("E820: physical memory map [mem 0x%08x-0x%08x]\n",
f0100b4f:	48                   	dec    %eax
f0100b50:	50                   	push   %eax
f0100b51:	52                   	push   %edx
f0100b52:	68 e8 7d 10 f0       	push   $0xf0107de8
f0100b57:	e8 47 31 00 00       	call   f0103ca3 <cprintf>

	addr = mbi->mmap_addr;
f0100b5c:	8b 5e 30             	mov    0x30(%esi),%ebx
	addr_end = mbi->mmap_addr + mbi->mmap_length;
f0100b5f:	89 d8                	mov    %ebx,%eax
f0100b61:	03 46 2c             	add    0x2c(%esi),%eax
f0100b64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	for (i = 0; addr < addr_end; ++i) {
f0100b67:	83 c4 10             	add    $0x10,%esp
f0100b6a:	bf 00 00 00 00       	mov    $0x0,%edi
f0100b6f:	eb 76                	jmp    f0100be7 <e820_init+0xb4>
	assert(mbi->flags & MULTIBOOT_INFO_MEM_MAP);
f0100b71:	68 c4 7d 10 f0       	push   $0xf0107dc4
f0100b76:	68 31 78 10 f0       	push   $0xf0107831
f0100b7b:	6a 26                	push   $0x26
f0100b7d:	68 17 7e 10 f0       	push   $0xf0107e17
f0100b82:	e8 bc f4 ff ff       	call   f0100043 <_panic>
		struct multiboot_mmap_entry *e;

		// Print memory mapping.
		assert(addr_end - addr >= sizeof(*e));
f0100b87:	68 23 7e 10 f0       	push   $0xf0107e23
f0100b8c:	68 31 78 10 f0       	push   $0xf0107831
f0100b91:	6a 30                	push   $0x30
f0100b93:	68 17 7e 10 f0       	push   $0xf0107e17
f0100b98:	e8 a6 f4 ff ff       	call   f0100043 <_panic>
		cprintf(e820_map_types[type - 1]);
f0100b9d:	83 ec 0c             	sub    $0xc,%esp
f0100ba0:	ff 34 85 a0 7e 10 f0 	pushl  -0xfef8160(,%eax,4)
f0100ba7:	e8 f7 30 00 00       	call   f0103ca3 <cprintf>
f0100bac:	83 c4 10             	add    $0x10,%esp
		e = (struct multiboot_mmap_entry *)addr;
		cprintf("  [mem %08p-%08p] ",
			(uintptr_t)e->e820.addr,
			(uintptr_t)(e->e820.addr + e->e820.len - 1));
		print_e820_map_type(e->e820.type);
		cprintf("\n");
f0100baf:	83 ec 0c             	sub    $0xc,%esp
f0100bb2:	68 ec 8a 10 f0       	push   $0xf0108aec
f0100bb7:	e8 e7 30 00 00       	call   f0103ca3 <cprintf>

		// Save a copy.
		assert(i < E820_NR_MAX);
f0100bbc:	83 c4 10             	add    $0x10,%esp
f0100bbf:	83 ff 40             	cmp    $0x40,%edi
f0100bc2:	74 74                	je     f0100c38 <e820_init+0x105>
		e820_map.entries[i] = e->e820;
f0100bc4:	89 fa                	mov    %edi,%edx
f0100bc6:	8d 04 bf             	lea    (%edi,%edi,4),%eax
f0100bc9:	8d 3c 85 c4 6f 2c f0 	lea    -0xfd3903c(,%eax,4),%edi
f0100bd0:	89 f0                	mov    %esi,%eax
f0100bd2:	8d 76 04             	lea    0x4(%esi),%esi
f0100bd5:	b9 05 00 00 00       	mov    $0x5,%ecx
f0100bda:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		addr += (e->size + 4);
f0100bdc:	8b 00                	mov    (%eax),%eax
f0100bde:	8d 5c 03 04          	lea    0x4(%ebx,%eax,1),%ebx
	for (i = 0; addr < addr_end; ++i) {
f0100be2:	89 d0                	mov    %edx,%eax
f0100be4:	40                   	inc    %eax
f0100be5:	89 c7                	mov    %eax,%edi
f0100be7:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0100bea:	73 62                	jae    f0100c4e <e820_init+0x11b>
		assert(addr_end - addr >= sizeof(*e));
f0100bec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100bef:	29 d8                	sub    %ebx,%eax
f0100bf1:	83 f8 17             	cmp    $0x17,%eax
f0100bf4:	76 91                	jbe    f0100b87 <e820_init+0x54>
		e = (struct multiboot_mmap_entry *)addr;
f0100bf6:	89 de                	mov    %ebx,%esi
			(uintptr_t)(e->e820.addr + e->e820.len - 1));
f0100bf8:	8b 53 04             	mov    0x4(%ebx),%edx
		cprintf("  [mem %08p-%08p] ",
f0100bfb:	83 ec 04             	sub    $0x4,%esp
			(uintptr_t)(e->e820.addr + e->e820.len - 1));
f0100bfe:	89 d0                	mov    %edx,%eax
f0100c00:	03 43 0c             	add    0xc(%ebx),%eax
		cprintf("  [mem %08p-%08p] ",
f0100c03:	48                   	dec    %eax
f0100c04:	50                   	push   %eax
f0100c05:	52                   	push   %edx
f0100c06:	68 41 7e 10 f0       	push   $0xf0107e41
f0100c0b:	e8 93 30 00 00       	call   f0103ca3 <cprintf>
		print_e820_map_type(e->e820.type);
f0100c10:	8b 43 14             	mov    0x14(%ebx),%eax
	switch (type) {
f0100c13:	83 c4 10             	add    $0x10,%esp
f0100c16:	8d 50 ff             	lea    -0x1(%eax),%edx
f0100c19:	83 fa 04             	cmp    $0x4,%edx
f0100c1c:	0f 86 7b ff ff ff    	jbe    f0100b9d <e820_init+0x6a>
		cprintf("type %u", type);
f0100c22:	83 ec 08             	sub    $0x8,%esp
f0100c25:	50                   	push   %eax
f0100c26:	68 54 7e 10 f0       	push   $0xf0107e54
f0100c2b:	e8 73 30 00 00       	call   f0103ca3 <cprintf>
f0100c30:	83 c4 10             	add    $0x10,%esp
f0100c33:	e9 77 ff ff ff       	jmp    f0100baf <e820_init+0x7c>
		assert(i < E820_NR_MAX);
f0100c38:	68 5c 7e 10 f0       	push   $0xf0107e5c
f0100c3d:	68 31 78 10 f0       	push   $0xf0107831
f0100c42:	6a 39                	push   $0x39
f0100c44:	68 17 7e 10 f0       	push   $0xf0107e17
f0100c49:	e8 f5 f3 ff ff       	call   f0100043 <_panic>
	}
	e820_map.nr = i;
f0100c4e:	89 3d c0 6f 2c f0    	mov    %edi,0xf02c6fc0
}
f0100c54:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100c57:	5b                   	pop    %ebx
f0100c58:	5e                   	pop    %esi
f0100c59:	5f                   	pop    %edi
f0100c5a:	5d                   	pop    %ebp
f0100c5b:	c3                   	ret    

f0100c5c <boot_alloc>:
// If we're out of memory, boot_alloc should panic.
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
static void *
boot_alloc(uint32_t n)
{
f0100c5c:	55                   	push   %ebp
f0100c5d:	89 e5                	mov    %esp,%ebp
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f0100c5f:	83 3d 38 62 2c f0 00 	cmpl   $0x0,0xf02c6238
f0100c66:	74 25                	je     f0100c8d <boot_alloc+0x31>
	// Allocate a chunk large enough to hold 'n' bytes, then update
	// nextfree.  Make sure nextfree is kept aligned
	// to a multiple of PGSIZE.
	//
	// LAB 2: Your code here.
	if (n == 0) {
f0100c68:	85 c0                	test   %eax,%eax
f0100c6a:	74 40                	je     f0100cac <boot_alloc+0x50>
	}
	if (n > 0) {
		/*result = nextfree;
		nextfree = ROUNDUP((char*) nextfree + n, PGSIZE);
		return result;*/
		size_t num_pages = ((size_t) ROUNDUP((char*)n, PGSIZE)) / PGSIZE;
f0100c6c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
f0100c72:	c1 ea 0c             	shr    $0xc,%edx
		assert((nfreepages - num_pages) >= 0);
		nfreepages -= num_pages;
f0100c75:	29 15 c4 74 2c f0    	sub    %edx,0xf02c74c4
		result = nextfree;
f0100c7b:	a1 38 62 2c f0       	mov    0xf02c6238,%eax
		nextfree += num_pages * PGSIZE;
f0100c80:	c1 e2 0c             	shl    $0xc,%edx
f0100c83:	01 c2                	add    %eax,%edx
f0100c85:	89 15 38 62 2c f0    	mov    %edx,0xf02c6238
		return result;
	}
	return NULL;
}
f0100c8b:	5d                   	pop    %ebp
f0100c8c:	c3                   	ret    
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0100c8d:	ba 27 a0 30 f0       	mov    $0xf030a027,%edx
f0100c92:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0100c98:	89 15 38 62 2c f0    	mov    %edx,0xf02c6238
		nfreepages = npages;
f0100c9e:	8b 15 c8 74 2c f0    	mov    0xf02c74c8,%edx
f0100ca4:	89 15 c4 74 2c f0    	mov    %edx,0xf02c74c4
f0100caa:	eb bc                	jmp    f0100c68 <boot_alloc+0xc>
		return nextfree;
f0100cac:	a1 38 62 2c f0       	mov    0xf02c6238,%eax
f0100cb1:	eb d8                	jmp    f0100c8b <boot_alloc+0x2f>

f0100cb3 <check_va2pa>:
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0100cb3:	89 d1                	mov    %edx,%ecx
f0100cb5:	c1 e9 16             	shr    $0x16,%ecx
	if (!(*pgdir & PTE_P))
f0100cb8:	8b 04 88             	mov    (%eax,%ecx,4),%eax
f0100cbb:	a8 01                	test   $0x1,%al
f0100cbd:	75 06                	jne    f0100cc5 <check_va2pa+0x12>
		return ~0;
f0100cbf:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
	if (!(p[PTX(va)] & PTE_P))
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
}
f0100cc4:	c3                   	ret    
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0100cc5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0100cca:	89 c1                	mov    %eax,%ecx
f0100ccc:	c1 e9 0c             	shr    $0xc,%ecx
f0100ccf:	3b 0d c8 74 2c f0    	cmp    0xf02c74c8,%ecx
f0100cd5:	73 1b                	jae    f0100cf2 <check_va2pa+0x3f>
	if (!(p[PTX(va)] & PTE_P))
f0100cd7:	c1 ea 0c             	shr    $0xc,%edx
f0100cda:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
f0100ce0:	8b 84 90 00 00 00 f0 	mov    -0x10000000(%eax,%edx,4),%eax
f0100ce7:	a8 01                	test   $0x1,%al
f0100ce9:	75 22                	jne    f0100d0d <check_va2pa+0x5a>
		return ~0;
f0100ceb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0100cf0:	eb d2                	jmp    f0100cc4 <check_va2pa+0x11>
{
f0100cf2:	55                   	push   %ebp
f0100cf3:	89 e5                	mov    %esp,%ebp
f0100cf5:	83 ec 08             	sub    $0x8,%esp
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100cf8:	50                   	push   %eax
f0100cf9:	68 c8 77 10 f0       	push   $0xf01077c8
f0100cfe:	68 e1 03 00 00       	push   $0x3e1
f0100d03:	68 05 88 10 f0       	push   $0xf0108805
f0100d08:	e8 36 f3 ff ff       	call   f0100043 <_panic>
	return PTE_ADDR(p[PTX(va)]);
f0100d0d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0100d12:	eb b0                	jmp    f0100cc4 <check_va2pa+0x11>

f0100d14 <check_page_free_list>:
{
f0100d14:	55                   	push   %ebp
f0100d15:	89 e5                	mov    %esp,%ebp
f0100d17:	57                   	push   %edi
f0100d18:	56                   	push   %esi
f0100d19:	53                   	push   %ebx
f0100d1a:	83 ec 2c             	sub    $0x2c,%esp
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100d1d:	84 c0                	test   %al,%al
f0100d1f:	0f 85 79 02 00 00    	jne    f0100f9e <check_page_free_list+0x28a>
	if (!page_free_list)
f0100d25:	83 3d 40 62 2c f0 00 	cmpl   $0x0,0xf02c6240
f0100d2c:	74 0a                	je     f0100d38 <check_page_free_list+0x24>
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100d2e:	be 00 04 00 00       	mov    $0x400,%esi
f0100d33:	e9 c1 02 00 00       	jmp    f0100ff9 <check_page_free_list+0x2e5>
		panic("'page_free_list' is a null pointer!");
f0100d38:	83 ec 04             	sub    $0x4,%esp
f0100d3b:	68 b8 7e 10 f0       	push   $0xf0107eb8
f0100d40:	68 0d 03 00 00       	push   $0x30d
f0100d45:	68 05 88 10 f0       	push   $0xf0108805
f0100d4a:	e8 f4 f2 ff ff       	call   f0100043 <_panic>
f0100d4f:	50                   	push   %eax
f0100d50:	68 c8 77 10 f0       	push   $0xf01077c8
f0100d55:	68 8e 00 00 00       	push   $0x8e
f0100d5a:	68 11 88 10 f0       	push   $0xf0108811
f0100d5f:	e8 df f2 ff ff       	call   f0100043 <_panic>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100d64:	8b 1b                	mov    (%ebx),%ebx
f0100d66:	85 db                	test   %ebx,%ebx
f0100d68:	74 41                	je     f0100dab <check_page_free_list+0x97>
void	user_mem_assert(struct Env *env, const void *va, size_t len, int perm);

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f0100d6a:	89 d8                	mov    %ebx,%eax
f0100d6c:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0100d72:	c1 f8 03             	sar    $0x3,%eax
f0100d75:	c1 e0 0c             	shl    $0xc,%eax
		if (PDX(page2pa(pp)) < pdx_limit)
f0100d78:	89 c2                	mov    %eax,%edx
f0100d7a:	c1 ea 16             	shr    $0x16,%edx
f0100d7d:	39 f2                	cmp    %esi,%edx
f0100d7f:	73 e3                	jae    f0100d64 <check_page_free_list+0x50>
	if (PGNUM(pa) >= npages)
f0100d81:	89 c2                	mov    %eax,%edx
f0100d83:	c1 ea 0c             	shr    $0xc,%edx
f0100d86:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0100d8c:	73 c1                	jae    f0100d4f <check_page_free_list+0x3b>
			memset(page2kva(pp), 0x97, 128);
f0100d8e:	83 ec 04             	sub    $0x4,%esp
f0100d91:	68 80 00 00 00       	push   $0x80
f0100d96:	68 97 00 00 00       	push   $0x97
	return (void *)(pa + KERNBASE);
f0100d9b:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0100da0:	50                   	push   %eax
f0100da1:	e8 77 4f 00 00       	call   f0105d1d <memset>
f0100da6:	83 c4 10             	add    $0x10,%esp
f0100da9:	eb b9                	jmp    f0100d64 <check_page_free_list+0x50>
	first_free_page = (char *) boot_alloc(0);
f0100dab:	b8 00 00 00 00       	mov    $0x0,%eax
f0100db0:	e8 a7 fe ff ff       	call   f0100c5c <boot_alloc>
f0100db5:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100db8:	8b 15 40 62 2c f0    	mov    0xf02c6240,%edx
		assert(pp >= pages);
f0100dbe:	8b 0d d0 74 2c f0    	mov    0xf02c74d0,%ecx
		assert(pp < pages + npages);
f0100dc4:	a1 c8 74 2c f0       	mov    0xf02c74c8,%eax
f0100dc9:	89 45 c8             	mov    %eax,-0x38(%ebp)
f0100dcc:	8d 04 c1             	lea    (%ecx,%eax,8),%eax
f0100dcf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100dd2:	89 4d d0             	mov    %ecx,-0x30(%ebp)
	int nfree_basemem = 0, nfree_extmem = 0;
f0100dd5:	be 00 00 00 00       	mov    $0x0,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100dda:	e9 03 01 00 00       	jmp    f0100ee2 <check_page_free_list+0x1ce>
		assert(pp >= pages);
f0100ddf:	68 1f 88 10 f0       	push   $0xf010881f
f0100de4:	68 31 78 10 f0       	push   $0xf0107831
f0100de9:	68 27 03 00 00       	push   $0x327
f0100dee:	68 05 88 10 f0       	push   $0xf0108805
f0100df3:	e8 4b f2 ff ff       	call   f0100043 <_panic>
		assert(pp < pages + npages);
f0100df8:	68 2b 88 10 f0       	push   $0xf010882b
f0100dfd:	68 31 78 10 f0       	push   $0xf0107831
f0100e02:	68 28 03 00 00       	push   $0x328
f0100e07:	68 05 88 10 f0       	push   $0xf0108805
f0100e0c:	e8 32 f2 ff ff       	call   f0100043 <_panic>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100e11:	68 dc 7e 10 f0       	push   $0xf0107edc
f0100e16:	68 31 78 10 f0       	push   $0xf0107831
f0100e1b:	68 29 03 00 00       	push   $0x329
f0100e20:	68 05 88 10 f0       	push   $0xf0108805
f0100e25:	e8 19 f2 ff ff       	call   f0100043 <_panic>
		assert(page2pa(pp) != 0);
f0100e2a:	68 3f 88 10 f0       	push   $0xf010883f
f0100e2f:	68 31 78 10 f0       	push   $0xf0107831
f0100e34:	68 2c 03 00 00       	push   $0x32c
f0100e39:	68 05 88 10 f0       	push   $0xf0108805
f0100e3e:	e8 00 f2 ff ff       	call   f0100043 <_panic>
		assert(page2pa(pp) != IOPHYSMEM);
f0100e43:	68 50 88 10 f0       	push   $0xf0108850
f0100e48:	68 31 78 10 f0       	push   $0xf0107831
f0100e4d:	68 2d 03 00 00       	push   $0x32d
f0100e52:	68 05 88 10 f0       	push   $0xf0108805
f0100e57:	e8 e7 f1 ff ff       	call   f0100043 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100e5c:	68 10 7f 10 f0       	push   $0xf0107f10
f0100e61:	68 31 78 10 f0       	push   $0xf0107831
f0100e66:	68 2e 03 00 00       	push   $0x32e
f0100e6b:	68 05 88 10 f0       	push   $0xf0108805
f0100e70:	e8 ce f1 ff ff       	call   f0100043 <_panic>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100e75:	68 69 88 10 f0       	push   $0xf0108869
f0100e7a:	68 31 78 10 f0       	push   $0xf0107831
f0100e7f:	68 2f 03 00 00       	push   $0x32f
f0100e84:	68 05 88 10 f0       	push   $0xf0108805
f0100e89:	e8 b5 f1 ff ff       	call   f0100043 <_panic>
	if (PGNUM(pa) >= npages)
f0100e8e:	89 c7                	mov    %eax,%edi
f0100e90:	c1 ef 0c             	shr    $0xc,%edi
f0100e93:	39 7d c8             	cmp    %edi,-0x38(%ebp)
f0100e96:	76 19                	jbe    f0100eb1 <check_page_free_list+0x19d>
	return (void *)(pa + KERNBASE);
f0100e98:	8d b8 00 00 00 f0    	lea    -0x10000000(%eax),%edi
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100e9e:	39 7d cc             	cmp    %edi,-0x34(%ebp)
f0100ea1:	77 23                	ja     f0100ec6 <check_page_free_list+0x1b2>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100ea3:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100ea8:	0f 84 95 00 00 00    	je     f0100f43 <check_page_free_list+0x22f>
			++nfree_extmem;
f0100eae:	43                   	inc    %ebx
f0100eaf:	eb 2f                	jmp    f0100ee0 <check_page_free_list+0x1cc>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0100eb1:	50                   	push   %eax
f0100eb2:	68 c8 77 10 f0       	push   $0xf01077c8
f0100eb7:	68 8e 00 00 00       	push   $0x8e
f0100ebc:	68 11 88 10 f0       	push   $0xf0108811
f0100ec1:	e8 7d f1 ff ff       	call   f0100043 <_panic>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100ec6:	68 34 7f 10 f0       	push   $0xf0107f34
f0100ecb:	68 31 78 10 f0       	push   $0xf0107831
f0100ed0:	68 30 03 00 00       	push   $0x330
f0100ed5:	68 05 88 10 f0       	push   $0xf0108805
f0100eda:	e8 64 f1 ff ff       	call   f0100043 <_panic>
			++nfree_basemem;
f0100edf:	46                   	inc    %esi
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100ee0:	8b 12                	mov    (%edx),%edx
f0100ee2:	85 d2                	test   %edx,%edx
f0100ee4:	74 76                	je     f0100f5c <check_page_free_list+0x248>
		assert(pp >= pages);
f0100ee6:	39 ca                	cmp    %ecx,%edx
f0100ee8:	0f 82 f1 fe ff ff    	jb     f0100ddf <check_page_free_list+0xcb>
		assert(pp < pages + npages);
f0100eee:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
f0100ef1:	0f 83 01 ff ff ff    	jae    f0100df8 <check_page_free_list+0xe4>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f0100ef7:	89 d0                	mov    %edx,%eax
f0100ef9:	2b 45 d0             	sub    -0x30(%ebp),%eax
f0100efc:	a8 07                	test   $0x7,%al
f0100efe:	0f 85 0d ff ff ff    	jne    f0100e11 <check_page_free_list+0xfd>
	return (pp - pages) << PGSHIFT;
f0100f04:	c1 f8 03             	sar    $0x3,%eax
		assert(page2pa(pp) != 0);
f0100f07:	c1 e0 0c             	shl    $0xc,%eax
f0100f0a:	0f 84 1a ff ff ff    	je     f0100e2a <check_page_free_list+0x116>
		assert(page2pa(pp) != IOPHYSMEM);
f0100f10:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0100f15:	0f 84 28 ff ff ff    	je     f0100e43 <check_page_free_list+0x12f>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0100f1b:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0100f20:	0f 84 36 ff ff ff    	je     f0100e5c <check_page_free_list+0x148>
		assert(page2pa(pp) != EXTPHYSMEM);
f0100f26:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0100f2b:	0f 84 44 ff ff ff    	je     f0100e75 <check_page_free_list+0x161>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0100f31:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f0100f36:	0f 87 52 ff ff ff    	ja     f0100e8e <check_page_free_list+0x17a>
		assert(page2pa(pp) != MPENTRY_PADDR);
f0100f3c:	3d 00 70 00 00       	cmp    $0x7000,%eax
f0100f41:	75 9c                	jne    f0100edf <check_page_free_list+0x1cb>
f0100f43:	68 83 88 10 f0       	push   $0xf0108883
f0100f48:	68 31 78 10 f0       	push   $0xf0107831
f0100f4d:	68 33 03 00 00       	push   $0x333
f0100f52:	68 05 88 10 f0       	push   $0xf0108805
f0100f57:	e8 e7 f0 ff ff       	call   f0100043 <_panic>
	assert(nfree_basemem > 0);
f0100f5c:	85 f6                	test   %esi,%esi
f0100f5e:	7e 0c                	jle    f0100f6c <check_page_free_list+0x258>
	assert(nfree_extmem > 0);
f0100f60:	85 db                	test   %ebx,%ebx
f0100f62:	7e 21                	jle    f0100f85 <check_page_free_list+0x271>
}
f0100f64:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0100f67:	5b                   	pop    %ebx
f0100f68:	5e                   	pop    %esi
f0100f69:	5f                   	pop    %edi
f0100f6a:	5d                   	pop    %ebp
f0100f6b:	c3                   	ret    
	assert(nfree_basemem > 0);
f0100f6c:	68 a0 88 10 f0       	push   $0xf01088a0
f0100f71:	68 31 78 10 f0       	push   $0xf0107831
f0100f76:	68 3b 03 00 00       	push   $0x33b
f0100f7b:	68 05 88 10 f0       	push   $0xf0108805
f0100f80:	e8 be f0 ff ff       	call   f0100043 <_panic>
	assert(nfree_extmem > 0);
f0100f85:	68 b2 88 10 f0       	push   $0xf01088b2
f0100f8a:	68 31 78 10 f0       	push   $0xf0107831
f0100f8f:	68 3c 03 00 00       	push   $0x33c
f0100f94:	68 05 88 10 f0       	push   $0xf0108805
f0100f99:	e8 a5 f0 ff ff       	call   f0100043 <_panic>
	if (!page_free_list)
f0100f9e:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f0100fa3:	85 c0                	test   %eax,%eax
f0100fa5:	0f 84 8d fd ff ff    	je     f0100d38 <check_page_free_list+0x24>
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f0100fab:	8d 55 d8             	lea    -0x28(%ebp),%edx
f0100fae:	89 55 e0             	mov    %edx,-0x20(%ebp)
f0100fb1:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0100fb4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0100fb7:	89 c2                	mov    %eax,%edx
f0100fb9:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0100fbf:	f7 c2 00 e0 7f 00    	test   $0x7fe000,%edx
f0100fc5:	0f 95 c2             	setne  %dl
f0100fc8:	0f b6 d2             	movzbl %dl,%edx
			*tp[pagetype] = pp;
f0100fcb:	8b 4c 95 e0          	mov    -0x20(%ebp,%edx,4),%ecx
f0100fcf:	89 01                	mov    %eax,(%ecx)
			tp[pagetype] = &pp->pp_link;
f0100fd1:	89 44 95 e0          	mov    %eax,-0x20(%ebp,%edx,4)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0100fd5:	8b 00                	mov    (%eax),%eax
f0100fd7:	85 c0                	test   %eax,%eax
f0100fd9:	75 dc                	jne    f0100fb7 <check_page_free_list+0x2a3>
		*tp[1] = 0;
f0100fdb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0100fde:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0100fe4:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0100fe7:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0100fea:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f0100fec:	8b 45 d8             	mov    -0x28(%ebp),%eax
f0100fef:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f0100ff4:	be 01 00 00 00       	mov    $0x1,%esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0100ff9:	8b 1d 40 62 2c f0    	mov    0xf02c6240,%ebx
f0100fff:	e9 62 fd ff ff       	jmp    f0100d66 <check_page_free_list+0x52>

f0101004 <page_init>:
{
f0101004:	55                   	push   %ebp
f0101005:	89 e5                	mov    %esp,%ebp
f0101007:	57                   	push   %edi
f0101008:	56                   	push   %esi
f0101009:	53                   	push   %ebx
f010100a:	83 ec 2c             	sub    $0x2c,%esp
	pages[0].pp_ref = 1;
f010100d:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f0101012:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
	pages[0].pp_link = NULL;
f0101018:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f010101e:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f0101023:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101026:	c6 45 cf 00          	movb   $0x0,-0x31(%ebp)
	for (int i = 1; i < PGNUM(IOPHYSMEM); i++) {
f010102a:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
f0101031:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
f0101038:	e9 c3 00 00 00       	jmp    f0101100 <page_init+0xfc>
			pages[i].pp_ref = 1;
f010103d:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			continue;
f0101043:	e9 a0 00 00 00       	jmp    f01010e8 <page_init+0xe4>
				if (PGNUM(addr) == i && ent[j].type == 1) {
f0101048:	89 cb                	mov    %ecx,%ebx
f010104a:	c1 eb 0c             	shr    $0xc,%ebx
f010104d:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0101050:	74 47                	je     f0101099 <page_init+0x95>
			 addr < bound; addr += PGSIZE) {
f0101052:	05 00 10 00 00       	add    $0x1000,%eax
f0101057:	83 d2 00             	adc    $0x0,%edx
f010105a:	81 c1 00 10 00 00    	add    $0x1000,%ecx
			for ( uint64_t addr = ent[j].addr;
f0101060:	39 fa                	cmp    %edi,%edx
f0101062:	72 e4                	jb     f0101048 <page_init+0x44>
f0101064:	77 04                	ja     f010106a <page_init+0x66>
f0101066:	39 f0                	cmp    %esi,%eax
f0101068:	72 de                	jb     f0101048 <page_init+0x44>
f010106a:	83 45 e0 14          	addl   $0x14,-0x20(%ebp)
		for (int j = 0; j < e820_map.nr; j++) {
f010106e:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0101071:	39 55 e0             	cmp    %edx,-0x20(%ebp)
f0101074:	74 38                	je     f01010ae <page_init+0xaa>
			uint64_t bound = ent[j].addr + ent[j].len;
f0101076:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0101079:	8b 91 c8 6f 2c f0    	mov    -0xfd39038(%ecx),%edx
f010107f:	8b 81 c4 6f 2c f0    	mov    -0xfd3903c(%ecx),%eax
f0101085:	89 c6                	mov    %eax,%esi
f0101087:	89 d7                	mov    %edx,%edi
f0101089:	03 b1 cc 6f 2c f0    	add    -0xfd39034(%ecx),%esi
f010108f:	13 b9 d0 6f 2c f0    	adc    -0xfd39030(%ecx),%edi
f0101095:	89 c1                	mov    %eax,%ecx
			for ( uint64_t addr = ent[j].addr;
f0101097:	eb c7                	jmp    f0101060 <page_init+0x5c>
				if (PGNUM(addr) == i && ent[j].type == 1) {
f0101099:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f010109c:	83 bb d4 6f 2c f0 01 	cmpl   $0x1,-0xfd3902c(%ebx)
f01010a3:	75 ad                	jne    f0101052 <page_init+0x4e>
					is_inuse = 0;
f01010a5:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f01010ac:	eb a4                	jmp    f0101052 <page_init+0x4e>
		if (!is_inuse) {
f01010ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01010b2:	75 6d                	jne    f0101121 <page_init+0x11d>
			pages[i].pp_ref = 0;
f01010b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01010b7:	c1 e0 03             	shl    $0x3,%eax
f01010ba:	89 c2                	mov    %eax,%edx
f01010bc:	03 15 d0 74 2c f0    	add    0xf02c74d0,%edx
f01010c2:	66 c7 42 04 00 00    	movw   $0x0,0x4(%edx)
			nfreepages++;
f01010c8:	ff 05 c4 74 2c f0    	incl   0xf02c74c4
			pages[i].pp_link = page_free_list;
f01010ce:	8b 7d d0             	mov    -0x30(%ebp),%edi
f01010d1:	89 3a                	mov    %edi,(%edx)
			page_free_list = &pages[i];
f01010d3:	03 05 d0 74 2c f0    	add    0xf02c74d0,%eax
f01010d9:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01010dc:	c6 45 cf 01          	movb   $0x1,-0x31(%ebp)
			pages[i].pp_ref = 1;
f01010e0:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f01010e5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
	for (int i = 1; i < PGNUM(IOPHYSMEM); i++) {
f01010e8:	42                   	inc    %edx
f01010e9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01010ec:	81 fa 9f 00 00 00    	cmp    $0x9f,%edx
f01010f2:	77 3e                	ja     f0101132 <page_init+0x12e>
		if (i == (int)PGNUM(MPENTRY_PADDR)) {
f01010f4:	83 fa 07             	cmp    $0x7,%edx
f01010f7:	0f 84 40 ff ff ff    	je     f010103d <page_init+0x39>
f01010fd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f0101100:	a1 c0 6f 2c f0       	mov    0xf02c6fc0,%eax
f0101105:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0101108:	c1 e0 02             	shl    $0x2,%eax
f010110b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		for (int j = 0; j < e820_map.nr; j++) {
f010110e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f0101115:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
f010111c:	e9 4d ff ff ff       	jmp    f010106e <page_init+0x6a>
			pages[i].pp_ref = 1;
f0101121:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f0101126:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0101129:	66 c7 44 d0 04 01 00 	movw   $0x1,0x4(%eax,%edx,8)
f0101130:	eb ae                	jmp    f01010e0 <page_init+0xdc>
f0101132:	80 7d cf 00          	cmpb   $0x0,-0x31(%ebp)
f0101136:	75 36                	jne    f010116e <page_init+0x16a>
	char* kernel_bound = boot_alloc(0);
f0101138:	b8 00 00 00 00       	mov    $0x0,%eax
f010113d:	e8 1a fb ff ff       	call   f0100c5c <boot_alloc>
	if ((uint32_t)kva < KERNBASE)
f0101142:	89 c6                	mov    %eax,%esi
	return (physaddr_t)kva - KERNBASE;
f0101144:	8d 88 00 00 00 10    	lea    0x10000000(%eax),%ecx
	for (int i = PGNUM(IOPHYSMEM); i < PGNUM(PADDR(kernel_bound)); i++) {
f010114a:	c1 e9 0c             	shr    $0xc,%ecx
		pages[i].pp_ref = 1;
f010114d:	8b 1d d0 74 2c f0    	mov    0xf02c74d0,%ebx
	for (int i = PGNUM(IOPHYSMEM); i < PGNUM(PADDR(kernel_bound)); i++) {
f0101153:	ba a0 00 00 00       	mov    $0xa0,%edx
	if ((uint32_t)kva < KERNBASE)
f0101158:	81 fe ff ff ff ef    	cmp    $0xefffffff,%esi
f010115e:	76 18                	jbe    f0101178 <page_init+0x174>
f0101160:	39 d1                	cmp    %edx,%ecx
f0101162:	76 29                	jbe    f010118d <page_init+0x189>
		pages[i].pp_ref = 1;
f0101164:	66 c7 44 d3 04 01 00 	movw   $0x1,0x4(%ebx,%edx,8)
	for (int i = PGNUM(IOPHYSMEM); i < PGNUM(PADDR(kernel_bound)); i++) {
f010116b:	42                   	inc    %edx
f010116c:	eb ea                	jmp    f0101158 <page_init+0x154>
f010116e:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0101171:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
f0101176:	eb c0                	jmp    f0101138 <page_init+0x134>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101178:	50                   	push   %eax
f0101179:	68 ec 77 10 f0       	push   $0xf01077ec
f010117e:	68 63 01 00 00       	push   $0x163
f0101183:	68 05 88 10 f0       	push   $0xf0108805
f0101188:	e8 b6 ee ff ff       	call   f0100043 <_panic>
	for (int i = PGNUM(PADDR(kernel_bound)); i < npages; i++) {
f010118d:	89 ce                	mov    %ecx,%esi
f010118f:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f0101194:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101197:	8d 04 cd 00 00 00 00 	lea    0x0(,%ecx,8),%eax
f010119e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f01011a1:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
f01011a5:	eb 78                	jmp    f010121f <page_init+0x21b>
			pages[i].pp_ref = 1;
f01011a7:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f01011ac:	66 c7 40 3c 01 00    	movw   $0x1,0x3c(%eax)
			continue;
f01011b2:	eb 66                	jmp    f010121a <page_init+0x216>
f01011b4:	83 c0 14             	add    $0x14,%eax
		for (int j = 0; j < e820_map.nr; j++) {
f01011b7:	39 d0                	cmp    %edx,%eax
f01011b9:	74 2e                	je     f01011e9 <page_init+0x1e5>
			uint64_t bound = ent[j].addr + ent[j].len;
f01011bb:	8b 88 c4 6f 2c f0    	mov    -0xfd3903c(%eax),%ecx
			int page_upbound = PGNUM(ent[j].addr);
f01011c1:	89 cf                	mov    %ecx,%edi
f01011c3:	c1 ef 0c             	shr    $0xc,%edi
			if (i >= page_upbound && i <= page_lowerbound) {
f01011c6:	39 fe                	cmp    %edi,%esi
f01011c8:	7c ea                	jl     f01011b4 <page_init+0x1b0>
			uint64_t bound = ent[j].addr + ent[j].len;
f01011ca:	03 88 cc 6f 2c f0    	add    -0xfd39034(%eax),%ecx
			int page_lowerbound = PGNUM(bound);
f01011d0:	c1 e9 0c             	shr    $0xc,%ecx
			if (i >= page_upbound && i <= page_lowerbound) {
f01011d3:	39 ce                	cmp    %ecx,%esi
f01011d5:	7f dd                	jg     f01011b4 <page_init+0x1b0>
				if (ent[j].type == 1) {
f01011d7:	83 b8 d4 6f 2c f0 01 	cmpl   $0x1,-0xfd3902c(%eax)
f01011de:	75 d4                	jne    f01011b4 <page_init+0x1b0>
					is_inuse = 0;
f01011e0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
f01011e7:	eb cb                	jmp    f01011b4 <page_init+0x1b0>
		if (!is_inuse) {
f01011e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f01011ed:	75 5d                	jne    f010124c <page_init+0x248>
			pages[i].pp_ref = 0;
f01011ef:	8b 55 e0             	mov    -0x20(%ebp),%edx
f01011f2:	89 d0                	mov    %edx,%eax
f01011f4:	03 05 d0 74 2c f0    	add    0xf02c74d0,%eax
f01011fa:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
			nfreepages++;
f0101200:	ff 05 c4 74 2c f0    	incl   0xf02c74c4
			pages[i].pp_link = page_free_list;
f0101206:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0101209:	89 38                	mov    %edi,(%eax)
			page_free_list = &pages[i];
f010120b:	89 d0                	mov    %edx,%eax
f010120d:	03 05 d0 74 2c f0    	add    0xf02c74d0,%eax
f0101213:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0101216:	c6 45 d8 01          	movb   $0x1,-0x28(%ebp)
	for (int i = PGNUM(PADDR(kernel_bound)); i < npages; i++) {
f010121a:	46                   	inc    %esi
f010121b:	83 45 e0 08          	addl   $0x8,-0x20(%ebp)
f010121f:	3b 35 c8 74 2c f0    	cmp    0xf02c74c8,%esi
f0101225:	73 36                	jae    f010125d <page_init+0x259>
		if (i == PGNUM(MPENTRY_PADDR)) {
f0101227:	83 fe 07             	cmp    $0x7,%esi
f010122a:	0f 84 77 ff ff ff    	je     f01011a7 <page_init+0x1a3>
f0101230:	a1 c0 6f 2c f0       	mov    0xf02c6fc0,%eax
f0101235:	8d 14 80             	lea    (%eax,%eax,4),%edx
f0101238:	c1 e2 02             	shl    $0x2,%edx
		for (int j = 0; j < e820_map.nr; j++) {
f010123b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101240:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
f0101247:	e9 6b ff ff ff       	jmp    f01011b7 <page_init+0x1b3>
			pages[i].pp_ref = 1;
f010124c:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f0101251:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0101254:	66 c7 44 10 04 01 00 	movw   $0x1,0x4(%eax,%edx,1)
f010125b:	eb bd                	jmp    f010121a <page_init+0x216>
f010125d:	80 7d d8 00          	cmpb   $0x0,-0x28(%ebp)
f0101261:	75 08                	jne    f010126b <page_init+0x267>
}
f0101263:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0101266:	5b                   	pop    %ebx
f0101267:	5e                   	pop    %esi
f0101268:	5f                   	pop    %edi
f0101269:	5d                   	pop    %ebp
f010126a:	c3                   	ret    
f010126b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f010126e:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
f0101273:	eb ee                	jmp    f0101263 <page_init+0x25f>

f0101275 <page_alloc>:
{	
f0101275:	55                   	push   %ebp
f0101276:	89 e5                	mov    %esp,%ebp
f0101278:	53                   	push   %ebx
f0101279:	83 ec 04             	sub    $0x4,%esp
	if (page_free_list == NULL) {
f010127c:	8b 1d 40 62 2c f0    	mov    0xf02c6240,%ebx
f0101282:	85 db                	test   %ebx,%ebx
f0101284:	74 22                	je     f01012a8 <page_alloc+0x33>
	if (nfreepages <= 0) {
f0101286:	83 3d c4 74 2c f0 00 	cmpl   $0x0,0xf02c74c4
f010128d:	74 6a                	je     f01012f9 <page_alloc+0x84>
	page_free_list = page_free_list->pp_link;
f010128f:	8b 03                	mov    (%ebx),%eax
f0101291:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
	res->pp_link = NULL;
f0101296:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	nfreepages--;
f010129c:	ff 0d c4 74 2c f0    	decl   0xf02c74c4
	if (alloc_flags & ALLOC_ZERO) {
f01012a2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
f01012a6:	75 07                	jne    f01012af <page_alloc+0x3a>
}
f01012a8:	89 d8                	mov    %ebx,%eax
f01012aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01012ad:	c9                   	leave  
f01012ae:	c3                   	ret    
	return (pp - pages) << PGSHIFT;
f01012af:	89 d8                	mov    %ebx,%eax
f01012b1:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01012b7:	c1 f8 03             	sar    $0x3,%eax
f01012ba:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01012bd:	89 c2                	mov    %eax,%edx
f01012bf:	c1 ea 0c             	shr    $0xc,%edx
f01012c2:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f01012c8:	73 1a                	jae    f01012e4 <page_alloc+0x6f>
		memset(page2kva(res), 0, PGSIZE);
f01012ca:	83 ec 04             	sub    $0x4,%esp
f01012cd:	68 00 10 00 00       	push   $0x1000
f01012d2:	6a 00                	push   $0x0
	return (void *)(pa + KERNBASE);
f01012d4:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01012d9:	50                   	push   %eax
f01012da:	e8 3e 4a 00 00       	call   f0105d1d <memset>
f01012df:	83 c4 10             	add    $0x10,%esp
f01012e2:	eb c4                	jmp    f01012a8 <page_alloc+0x33>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01012e4:	50                   	push   %eax
f01012e5:	68 c8 77 10 f0       	push   $0xf01077c8
f01012ea:	68 8e 00 00 00       	push   $0x8e
f01012ef:	68 11 88 10 f0       	push   $0xf0108811
f01012f4:	e8 4a ed ff ff       	call   f0100043 <_panic>
		return NULL;
f01012f9:	bb 00 00 00 00       	mov    $0x0,%ebx
f01012fe:	eb a8                	jmp    f01012a8 <page_alloc+0x33>

f0101300 <page_free>:
{
f0101300:	55                   	push   %ebp
f0101301:	89 e5                	mov    %esp,%ebp
f0101303:	83 ec 08             	sub    $0x8,%esp
f0101306:	8b 45 08             	mov    0x8(%ebp),%eax
	assert(pp->pp_ref == 0 && pp->pp_link == NULL);
f0101309:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f010130e:	75 1a                	jne    f010132a <page_free+0x2a>
f0101310:	83 38 00             	cmpl   $0x0,(%eax)
f0101313:	75 15                	jne    f010132a <page_free+0x2a>
	pp->pp_link = page_free_list;
f0101315:	8b 15 40 62 2c f0    	mov    0xf02c6240,%edx
f010131b:	89 10                	mov    %edx,(%eax)
	page_free_list = pp;
f010131d:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
	nfreepages++;
f0101322:	ff 05 c4 74 2c f0    	incl   0xf02c74c4
}
f0101328:	c9                   	leave  
f0101329:	c3                   	ret    
	assert(pp->pp_ref == 0 && pp->pp_link == NULL);
f010132a:	68 7c 7f 10 f0       	push   $0xf0107f7c
f010132f:	68 31 78 10 f0       	push   $0xf0107831
f0101334:	68 b7 01 00 00       	push   $0x1b7
f0101339:	68 05 88 10 f0       	push   $0xf0108805
f010133e:	e8 00 ed ff ff       	call   f0100043 <_panic>

f0101343 <page_decref>:
{
f0101343:	55                   	push   %ebp
f0101344:	89 e5                	mov    %esp,%ebp
f0101346:	83 ec 08             	sub    $0x8,%esp
f0101349:	8b 55 08             	mov    0x8(%ebp),%edx
	if (--pp->pp_ref == 0)
f010134c:	8b 42 04             	mov    0x4(%edx),%eax
f010134f:	48                   	dec    %eax
f0101350:	66 89 42 04          	mov    %ax,0x4(%edx)
f0101354:	66 85 c0             	test   %ax,%ax
f0101357:	74 02                	je     f010135b <page_decref+0x18>
}
f0101359:	c9                   	leave  
f010135a:	c3                   	ret    
		page_free(pp);
f010135b:	83 ec 0c             	sub    $0xc,%esp
f010135e:	52                   	push   %edx
f010135f:	e8 9c ff ff ff       	call   f0101300 <page_free>
f0101364:	83 c4 10             	add    $0x10,%esp
}
f0101367:	eb f0                	jmp    f0101359 <page_decref+0x16>

f0101369 <pgdir_walk>:
{
f0101369:	55                   	push   %ebp
f010136a:	89 e5                	mov    %esp,%ebp
f010136c:	53                   	push   %ebx
f010136d:	83 ec 04             	sub    $0x4,%esp
	pde_t* pdeaddr = &pgdir[PDX(va)];
f0101370:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0101373:	c1 eb 16             	shr    $0x16,%ebx
f0101376:	c1 e3 02             	shl    $0x2,%ebx
f0101379:	03 5d 08             	add    0x8(%ebp),%ebx
	if ((*(pdeaddr) & PTE_P) == 0) {
f010137c:	8b 03                	mov    (%ebx),%eax
f010137e:	a8 01                	test   $0x1,%al
f0101380:	75 79                	jne    f01013fb <pgdir_walk+0x92>
		if (create == false) {
f0101382:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0101386:	0f 84 ad 00 00 00    	je     f0101439 <pgdir_walk+0xd0>
			struct PageInfo * newPTP = page_alloc(1);
f010138c:	83 ec 0c             	sub    $0xc,%esp
f010138f:	6a 01                	push   $0x1
f0101391:	e8 df fe ff ff       	call   f0101275 <page_alloc>
			if (newPTP == NULL) {
f0101396:	83 c4 10             	add    $0x10,%esp
f0101399:	85 c0                	test   %eax,%eax
f010139b:	0f 84 9f 00 00 00    	je     f0101440 <pgdir_walk+0xd7>
				newPTP->pp_ref++;
f01013a1:	66 ff 40 04          	incw   0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01013a5:	89 c2                	mov    %eax,%edx
f01013a7:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f01013ad:	c1 fa 03             	sar    $0x3,%edx
f01013b0:	c1 e2 0c             	shl    $0xc,%edx
				*pdeaddr = page2pa(newPTP) | PTE_W | PTE_P | PTE_U;
f01013b3:	83 ca 07             	or     $0x7,%edx
f01013b6:	89 13                	mov    %edx,(%ebx)
f01013b8:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01013be:	c1 f8 03             	sar    $0x3,%eax
f01013c1:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01013c4:	89 c2                	mov    %eax,%edx
f01013c6:	c1 ea 0c             	shr    $0xc,%edx
f01013c9:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f01013cf:	73 15                	jae    f01013e6 <pgdir_walk+0x7d>
				return (pte_t*) (&res_addr[PTX(va)]);
f01013d1:	8b 55 0c             	mov    0xc(%ebp),%edx
f01013d4:	c1 ea 0a             	shr    $0xa,%edx
f01013d7:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
f01013dd:	8d 84 10 00 00 00 f0 	lea    -0x10000000(%eax,%edx,1),%eax
f01013e4:	eb 39                	jmp    f010141f <pgdir_walk+0xb6>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01013e6:	50                   	push   %eax
f01013e7:	68 c8 77 10 f0       	push   $0xf01077c8
f01013ec:	68 8e 00 00 00       	push   $0x8e
f01013f1:	68 11 88 10 f0       	push   $0xf0108811
f01013f6:	e8 48 ec ff ff       	call   f0100043 <_panic>
		pte_t* res_addr = KADDR(PTE_ADDR(*pdeaddr));
f01013fb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0101400:	89 c2                	mov    %eax,%edx
	if (PGNUM(pa) >= npages)
f0101402:	c1 e8 0c             	shr    $0xc,%eax
f0101405:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f010140b:	73 17                	jae    f0101424 <pgdir_walk+0xbb>
		pte_t* pteaddr = &res_addr[PTX(va)];
f010140d:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101410:	c1 e8 0a             	shr    $0xa,%eax
f0101413:	25 fc 0f 00 00       	and    $0xffc,%eax
f0101418:	8d 84 02 00 00 00 f0 	lea    -0x10000000(%edx,%eax,1),%eax
}
f010141f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101422:	c9                   	leave  
f0101423:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101424:	52                   	push   %edx
f0101425:	68 c8 77 10 f0       	push   $0xf01077c8
f010142a:	68 fb 01 00 00       	push   $0x1fb
f010142f:	68 05 88 10 f0       	push   $0xf0108805
f0101434:	e8 0a ec ff ff       	call   f0100043 <_panic>
			return NULL;
f0101439:	b8 00 00 00 00       	mov    $0x0,%eax
f010143e:	eb df                	jmp    f010141f <pgdir_walk+0xb6>
				return NULL;
f0101440:	b8 00 00 00 00       	mov    $0x0,%eax
f0101445:	eb d8                	jmp    f010141f <pgdir_walk+0xb6>

f0101447 <boot_map_region>:
{
f0101447:	55                   	push   %ebp
f0101448:	89 e5                	mov    %esp,%ebp
f010144a:	57                   	push   %edi
f010144b:	56                   	push   %esi
f010144c:	53                   	push   %ebx
f010144d:	83 ec 1c             	sub    $0x1c,%esp
f0101450:	89 45 e0             	mov    %eax,-0x20(%ebp)
	for (int i = 0; i < size / PGSIZE; i++) {
f0101453:	c1 e9 0c             	shr    $0xc,%ecx
f0101456:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0101459:	89 d3                	mov    %edx,%ebx
f010145b:	bf 00 00 00 00       	mov    $0x0,%edi
f0101460:	8b 45 08             	mov    0x8(%ebp),%eax
f0101463:	29 d0                	sub    %edx,%eax
f0101465:	89 45 dc             	mov    %eax,-0x24(%ebp)
		*(pgt_entry) = pa_real | perm | PTE_P;
f0101468:	8b 45 0c             	mov    0xc(%ebp),%eax
f010146b:	83 c8 01             	or     $0x1,%eax
f010146e:	89 45 d8             	mov    %eax,-0x28(%ebp)
	for (int i = 0; i < size / PGSIZE; i++) {
f0101471:	eb 23                	jmp    f0101496 <boot_map_region+0x4f>
f0101473:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0101476:	8d 34 18             	lea    (%eax,%ebx,1),%esi
		pte_t* pgt_entry = pgdir_walk(pgdir, (const void*) va_real, 1);
f0101479:	83 ec 04             	sub    $0x4,%esp
f010147c:	6a 01                	push   $0x1
f010147e:	53                   	push   %ebx
f010147f:	ff 75 e0             	pushl  -0x20(%ebp)
f0101482:	e8 e2 fe ff ff       	call   f0101369 <pgdir_walk>
		*(pgt_entry) = pa_real | perm | PTE_P;
f0101487:	0b 75 d8             	or     -0x28(%ebp),%esi
f010148a:	89 30                	mov    %esi,(%eax)
	for (int i = 0; i < size / PGSIZE; i++) {
f010148c:	47                   	inc    %edi
f010148d:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0101493:	83 c4 10             	add    $0x10,%esp
f0101496:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f0101499:	75 d8                	jne    f0101473 <boot_map_region+0x2c>
}
f010149b:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010149e:	5b                   	pop    %ebx
f010149f:	5e                   	pop    %esi
f01014a0:	5f                   	pop    %edi
f01014a1:	5d                   	pop    %ebp
f01014a2:	c3                   	ret    

f01014a3 <page_lookup>:
{
f01014a3:	55                   	push   %ebp
f01014a4:	89 e5                	mov    %esp,%ebp
f01014a6:	53                   	push   %ebx
f01014a7:	83 ec 08             	sub    $0x8,%esp
f01014aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
	pte_t* pte_entry = pgdir_walk(pgdir, va, 0);
f01014ad:	6a 00                	push   $0x0
f01014af:	ff 75 0c             	pushl  0xc(%ebp)
f01014b2:	ff 75 08             	pushl  0x8(%ebp)
f01014b5:	e8 af fe ff ff       	call   f0101369 <pgdir_walk>
	if (pte_entry == NULL) {
f01014ba:	83 c4 10             	add    $0x10,%esp
f01014bd:	85 c0                	test   %eax,%eax
f01014bf:	74 3c                	je     f01014fd <page_lookup+0x5a>
	if (pte_store != 0) {
f01014c1:	85 db                	test   %ebx,%ebx
f01014c3:	74 02                	je     f01014c7 <page_lookup+0x24>
		*pte_store = pte_entry;
f01014c5:	89 03                	mov    %eax,(%ebx)
	if (!(*pte_entry & PTE_P))
f01014c7:	8b 00                	mov    (%eax),%eax
f01014c9:	a8 01                	test   $0x1,%al
f01014cb:	74 37                	je     f0101504 <page_lookup+0x61>
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f01014cd:	c1 e8 0c             	shr    $0xc,%eax
f01014d0:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f01014d6:	73 0e                	jae    f01014e6 <page_lookup+0x43>
		panic("pa2page called with invalid pa");
	return &pages[PGNUM(pa)];
f01014d8:	8b 15 d0 74 2c f0    	mov    0xf02c74d0,%edx
f01014de:	8d 04 c2             	lea    (%edx,%eax,8),%eax
}
f01014e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01014e4:	c9                   	leave  
f01014e5:	c3                   	ret    
		panic("pa2page called with invalid pa");
f01014e6:	83 ec 04             	sub    $0x4,%esp
f01014e9:	68 a4 7f 10 f0       	push   $0xf0107fa4
f01014ee:	68 87 00 00 00       	push   $0x87
f01014f3:	68 11 88 10 f0       	push   $0xf0108811
f01014f8:	e8 46 eb ff ff       	call   f0100043 <_panic>
		return NULL;
f01014fd:	b8 00 00 00 00       	mov    $0x0,%eax
f0101502:	eb dd                	jmp    f01014e1 <page_lookup+0x3e>
		return NULL;
f0101504:	b8 00 00 00 00       	mov    $0x0,%eax
f0101509:	eb d6                	jmp    f01014e1 <page_lookup+0x3e>

f010150b <tlb_invalidate>:
{
f010150b:	55                   	push   %ebp
f010150c:	89 e5                	mov    %esp,%ebp
f010150e:	83 ec 08             	sub    $0x8,%esp
	if (!curenv || curenv->env_pgdir == pgdir)
f0101511:	e8 12 4f 00 00       	call   f0106428 <cpunum>
f0101516:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0101519:	01 c2                	add    %eax,%edx
f010151b:	01 d2                	add    %edx,%edx
f010151d:	01 c2                	add    %eax,%edx
f010151f:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0101522:	83 3c 85 08 80 2c f0 	cmpl   $0x0,-0xfd37ff8(,%eax,4)
f0101529:	00 
f010152a:	74 22                	je     f010154e <tlb_invalidate+0x43>
f010152c:	e8 f7 4e 00 00       	call   f0106428 <cpunum>
f0101531:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0101534:	01 c2                	add    %eax,%edx
f0101536:	01 d2                	add    %edx,%edx
f0101538:	01 c2                	add    %eax,%edx
f010153a:	8d 04 90             	lea    (%eax,%edx,4),%eax
f010153d:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0101544:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0101547:	39 48 60             	cmp    %ecx,0x60(%eax)
f010154a:	74 02                	je     f010154e <tlb_invalidate+0x43>
}
f010154c:	c9                   	leave  
f010154d:	c3                   	ret    
	asm volatile("invlpg (%0)" : : "r" (addr) : "memory");
f010154e:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101551:	0f 01 38             	invlpg (%eax)
f0101554:	eb f6                	jmp    f010154c <tlb_invalidate+0x41>

f0101556 <page_remove>:
{
f0101556:	55                   	push   %ebp
f0101557:	89 e5                	mov    %esp,%ebp
f0101559:	56                   	push   %esi
f010155a:	53                   	push   %ebx
f010155b:	83 ec 14             	sub    $0x14,%esp
f010155e:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0101561:	8b 75 0c             	mov    0xc(%ebp),%esi
	struct PageInfo* temp = page_lookup(pgdir, va, &store);
f0101564:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0101567:	50                   	push   %eax
f0101568:	56                   	push   %esi
f0101569:	53                   	push   %ebx
f010156a:	e8 34 ff ff ff       	call   f01014a3 <page_lookup>
	if (temp != NULL) {
f010156f:	83 c4 10             	add    $0x10,%esp
f0101572:	85 c0                	test   %eax,%eax
f0101574:	74 1f                	je     f0101595 <page_remove+0x3f>
		page_decref(temp);
f0101576:	83 ec 0c             	sub    $0xc,%esp
f0101579:	50                   	push   %eax
f010157a:	e8 c4 fd ff ff       	call   f0101343 <page_decref>
		*store = 0;
f010157f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101582:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		tlb_invalidate(pgdir, va);
f0101588:	83 c4 08             	add    $0x8,%esp
f010158b:	56                   	push   %esi
f010158c:	53                   	push   %ebx
f010158d:	e8 79 ff ff ff       	call   f010150b <tlb_invalidate>
f0101592:	83 c4 10             	add    $0x10,%esp
}
f0101595:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0101598:	5b                   	pop    %ebx
f0101599:	5e                   	pop    %esi
f010159a:	5d                   	pop    %ebp
f010159b:	c3                   	ret    

f010159c <page_insert>:
{
f010159c:	55                   	push   %ebp
f010159d:	89 e5                	mov    %esp,%ebp
f010159f:	57                   	push   %edi
f01015a0:	56                   	push   %esi
f01015a1:	53                   	push   %ebx
f01015a2:	83 ec 10             	sub    $0x10,%esp
f01015a5:	8b 75 08             	mov    0x8(%ebp),%esi
f01015a8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	pte_t* pte_entry = pgdir_walk(pgdir, va, 1);
f01015ab:	6a 01                	push   $0x1
f01015ad:	ff 75 10             	pushl  0x10(%ebp)
f01015b0:	56                   	push   %esi
f01015b1:	e8 b3 fd ff ff       	call   f0101369 <pgdir_walk>
	if (pte_entry != NULL) {
f01015b6:	83 c4 10             	add    $0x10,%esp
f01015b9:	85 c0                	test   %eax,%eax
f01015bb:	74 4b                	je     f0101608 <page_insert+0x6c>
f01015bd:	89 c7                	mov    %eax,%edi
		pp->pp_ref = pp->pp_ref + 1;  // increment on creation success
f01015bf:	66 ff 43 04          	incw   0x4(%ebx)
		if (*pte_entry & PTE_P)  // present
f01015c3:	f6 00 01             	testb  $0x1,(%eax)
f01015c6:	75 2f                	jne    f01015f7 <page_insert+0x5b>
	return (pp - pages) << PGSHIFT;
f01015c8:	2b 1d d0 74 2c f0    	sub    0xf02c74d0,%ebx
f01015ce:	c1 fb 03             	sar    $0x3,%ebx
f01015d1:	c1 e3 0c             	shl    $0xc,%ebx
		*pte_entry = page2pa(pp) | perm | PTE_P;
f01015d4:	8b 45 14             	mov    0x14(%ebp),%eax
f01015d7:	83 c8 01             	or     $0x1,%eax
f01015da:	09 c3                	or     %eax,%ebx
f01015dc:	89 1f                	mov    %ebx,(%edi)
		pgdir[PDX(va)] = pgdir[PDX(va)] | perm;
f01015de:	8b 45 10             	mov    0x10(%ebp),%eax
f01015e1:	c1 e8 16             	shr    $0x16,%eax
f01015e4:	8b 55 14             	mov    0x14(%ebp),%edx
f01015e7:	09 14 86             	or     %edx,(%esi,%eax,4)
		return 0;
f01015ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01015ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01015f2:	5b                   	pop    %ebx
f01015f3:	5e                   	pop    %esi
f01015f4:	5f                   	pop    %edi
f01015f5:	5d                   	pop    %ebp
f01015f6:	c3                   	ret    
			page_remove(pgdir, va);
f01015f7:	83 ec 08             	sub    $0x8,%esp
f01015fa:	ff 75 10             	pushl  0x10(%ebp)
f01015fd:	56                   	push   %esi
f01015fe:	e8 53 ff ff ff       	call   f0101556 <page_remove>
f0101603:	83 c4 10             	add    $0x10,%esp
f0101606:	eb c0                	jmp    f01015c8 <page_insert+0x2c>
	return -E_NO_MEM;
f0101608:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f010160d:	eb e0                	jmp    f01015ef <page_insert+0x53>

f010160f <mmio_map_region>:
{
f010160f:	55                   	push   %ebp
f0101610:	89 e5                	mov    %esp,%ebp
f0101612:	53                   	push   %ebx
f0101613:	83 ec 04             	sub    $0x4,%esp
	size = ROUNDUP(size, PGSIZE);
f0101616:	8b 45 0c             	mov    0xc(%ebp),%eax
f0101619:	8d 88 ff 0f 00 00    	lea    0xfff(%eax),%ecx
f010161f:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
	assert((base + size) <= MMIOLIM && (base <= (base + size)));
f0101625:	8b 1d 00 b3 12 f0    	mov    0xf012b300,%ebx
f010162b:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f010162e:	3d 00 00 c0 ef       	cmp    $0xefc00000,%eax
f0101633:	77 24                	ja     f0101659 <mmio_map_region+0x4a>
f0101635:	39 c3                	cmp    %eax,%ebx
f0101637:	77 20                	ja     f0101659 <mmio_map_region+0x4a>
	base += size;
f0101639:	a3 00 b3 12 f0       	mov    %eax,0xf012b300
	boot_map_region(kern_pgdir, basePtr, size, pa, PTE_PCD | PTE_PWT | PTE_W);
f010163e:	83 ec 08             	sub    $0x8,%esp
f0101641:	6a 1a                	push   $0x1a
f0101643:	ff 75 08             	pushl  0x8(%ebp)
f0101646:	89 da                	mov    %ebx,%edx
f0101648:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f010164d:	e8 f5 fd ff ff       	call   f0101447 <boot_map_region>
}
f0101652:	89 d8                	mov    %ebx,%eax
f0101654:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0101657:	c9                   	leave  
f0101658:	c3                   	ret    
	assert((base + size) <= MMIOLIM && (base <= (base + size)));
f0101659:	68 c4 7f 10 f0       	push   $0xf0107fc4
f010165e:	68 31 78 10 f0       	push   $0xf0107831
f0101663:	68 b7 02 00 00       	push   $0x2b7
f0101668:	68 05 88 10 f0       	push   $0xf0108805
f010166d:	e8 d1 e9 ff ff       	call   f0100043 <_panic>

f0101672 <mem_init>:
{
f0101672:	55                   	push   %ebp
f0101673:	89 e5                	mov    %esp,%ebp
f0101675:	57                   	push   %edi
f0101676:	56                   	push   %esi
f0101677:	53                   	push   %ebx
f0101678:	83 ec 3c             	sub    $0x3c,%esp
	for (i = 0; i != e820_map.nr; ++i, ++e) {
f010167b:	8b 1d c0 6f 2c f0    	mov    0xf02c6fc0,%ebx
	size_t mem = 0, mem_max = -KERNBASE;
f0101681:	be 00 00 00 00       	mov    $0x0,%esi
	e = e820_map.entries;
f0101686:	b8 c4 6f 2c f0       	mov    $0xf02c6fc4,%eax
	for (i = 0; i != e820_map.nr; ++i, ++e) {
f010168b:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101690:	eb 04                	jmp    f0101696 <mem_init+0x24>
f0101692:	41                   	inc    %ecx
f0101693:	83 c0 14             	add    $0x14,%eax
f0101696:	39 d9                	cmp    %ebx,%ecx
f0101698:	74 1b                	je     f01016b5 <mem_init+0x43>
		if (e->addr >= mem_max)
f010169a:	8b 10                	mov    (%eax),%edx
f010169c:	83 78 04 00          	cmpl   $0x0,0x4(%eax)
f01016a0:	75 f0                	jne    f0101692 <mem_init+0x20>
f01016a2:	81 fa ff ff ff 0f    	cmp    $0xfffffff,%edx
f01016a8:	77 e8                	ja     f0101692 <mem_init+0x20>
		mem = MAX(mem, (size_t)(e->addr + e->len));
f01016aa:	03 50 08             	add    0x8(%eax),%edx
f01016ad:	39 d6                	cmp    %edx,%esi
f01016af:	73 e1                	jae    f0101692 <mem_init+0x20>
f01016b1:	89 d6                	mov    %edx,%esi
f01016b3:	eb dd                	jmp    f0101692 <mem_init+0x20>
	mem = MIN(mem, mem_max);
f01016b5:	89 f0                	mov    %esi,%eax
f01016b7:	81 fe 00 00 00 10    	cmp    $0x10000000,%esi
f01016bd:	76 05                	jbe    f01016c4 <mem_init+0x52>
f01016bf:	b8 00 00 00 10       	mov    $0x10000000,%eax
	npages = mem / PGSIZE;
f01016c4:	89 c2                	mov    %eax,%edx
f01016c6:	c1 ea 0c             	shr    $0xc,%edx
f01016c9:	89 15 c8 74 2c f0    	mov    %edx,0xf02c74c8
	cprintf("E820: physical memory %uMB\n", mem / 1024 / 1024);
f01016cf:	83 ec 08             	sub    $0x8,%esp
f01016d2:	c1 e8 14             	shr    $0x14,%eax
f01016d5:	50                   	push   %eax
f01016d6:	68 c3 88 10 f0       	push   $0xf01088c3
f01016db:	e8 c3 25 00 00       	call   f0103ca3 <cprintf>
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);
f01016e0:	b8 00 10 00 00       	mov    $0x1000,%eax
f01016e5:	e8 72 f5 ff ff       	call   f0100c5c <boot_alloc>
f01016ea:	a3 cc 74 2c f0       	mov    %eax,0xf02c74cc
	memset(kern_pgdir, 0, PGSIZE);
f01016ef:	83 c4 0c             	add    $0xc,%esp
f01016f2:	68 00 10 00 00       	push   $0x1000
f01016f7:	6a 00                	push   $0x0
f01016f9:	50                   	push   %eax
f01016fa:	e8 1e 46 00 00       	call   f0105d1d <memset>
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01016ff:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
	if ((uint32_t)kva < KERNBASE)
f0101704:	83 c4 10             	add    $0x10,%esp
f0101707:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010170c:	0f 86 80 00 00 00    	jbe    f0101792 <mem_init+0x120>
	return (physaddr_t)kva - KERNBASE;
f0101712:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0101718:	83 ca 05             	or     $0x5,%edx
f010171b:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	pages = (struct PageInfo*) boot_alloc(sizeof(struct PageInfo) * npages);
f0101721:	a1 c8 74 2c f0       	mov    0xf02c74c8,%eax
f0101726:	c1 e0 03             	shl    $0x3,%eax
f0101729:	e8 2e f5 ff ff       	call   f0100c5c <boot_alloc>
f010172e:	a3 d0 74 2c f0       	mov    %eax,0xf02c74d0
	memset(pages, 0, sizeof(struct PageInfo) * npages);
f0101733:	83 ec 04             	sub    $0x4,%esp
f0101736:	8b 35 c8 74 2c f0    	mov    0xf02c74c8,%esi
f010173c:	8d 14 f5 00 00 00 00 	lea    0x0(,%esi,8),%edx
f0101743:	52                   	push   %edx
f0101744:	6a 00                	push   $0x0
f0101746:	50                   	push   %eax
f0101747:	e8 d1 45 00 00       	call   f0105d1d <memset>
	envs = (struct Env*) boot_alloc(NENV * sizeof(struct Env));
f010174c:	b8 00 f0 01 00       	mov    $0x1f000,%eax
f0101751:	e8 06 f5 ff ff       	call   f0100c5c <boot_alloc>
f0101756:	a3 44 62 2c f0       	mov    %eax,0xf02c6244
	memset(envs, 0, NENV * sizeof(struct Env));
f010175b:	83 c4 0c             	add    $0xc,%esp
f010175e:	68 00 f0 01 00       	push   $0x1f000
f0101763:	6a 00                	push   $0x0
f0101765:	50                   	push   %eax
f0101766:	e8 b2 45 00 00       	call   f0105d1d <memset>
	page_init();
f010176b:	e8 94 f8 ff ff       	call   f0101004 <page_init>
	check_page_free_list(1);
f0101770:	b8 01 00 00 00       	mov    $0x1,%eax
f0101775:	e8 9a f5 ff ff       	call   f0100d14 <check_page_free_list>
	if (!pages)
f010177a:	83 c4 10             	add    $0x10,%esp
f010177d:	83 3d d0 74 2c f0 00 	cmpl   $0x0,0xf02c74d0
f0101784:	74 21                	je     f01017a7 <mem_init+0x135>
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0101786:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f010178b:	bb 00 00 00 00       	mov    $0x0,%ebx
f0101790:	eb 2f                	jmp    f01017c1 <mem_init+0x14f>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0101792:	50                   	push   %eax
f0101793:	68 ec 77 10 f0       	push   $0xf01077ec
f0101798:	68 93 00 00 00       	push   $0x93
f010179d:	68 05 88 10 f0       	push   $0xf0108805
f01017a2:	e8 9c e8 ff ff       	call   f0100043 <_panic>
		panic("'pages' is a null pointer!");
f01017a7:	83 ec 04             	sub    $0x4,%esp
f01017aa:	68 df 88 10 f0       	push   $0xf01088df
f01017af:	68 4d 03 00 00       	push   $0x34d
f01017b4:	68 05 88 10 f0       	push   $0xf0108805
f01017b9:	e8 85 e8 ff ff       	call   f0100043 <_panic>
		++nfree;
f01017be:	43                   	inc    %ebx
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f01017bf:	8b 00                	mov    (%eax),%eax
f01017c1:	85 c0                	test   %eax,%eax
f01017c3:	75 f9                	jne    f01017be <mem_init+0x14c>
	assert((pp0 = page_alloc(0)));
f01017c5:	83 ec 0c             	sub    $0xc,%esp
f01017c8:	6a 00                	push   $0x0
f01017ca:	e8 a6 fa ff ff       	call   f0101275 <page_alloc>
f01017cf:	89 c7                	mov    %eax,%edi
f01017d1:	83 c4 10             	add    $0x10,%esp
f01017d4:	85 c0                	test   %eax,%eax
f01017d6:	0f 84 10 02 00 00    	je     f01019ec <mem_init+0x37a>
	assert((pp1 = page_alloc(0)));
f01017dc:	83 ec 0c             	sub    $0xc,%esp
f01017df:	6a 00                	push   $0x0
f01017e1:	e8 8f fa ff ff       	call   f0101275 <page_alloc>
f01017e6:	89 c6                	mov    %eax,%esi
f01017e8:	83 c4 10             	add    $0x10,%esp
f01017eb:	85 c0                	test   %eax,%eax
f01017ed:	0f 84 12 02 00 00    	je     f0101a05 <mem_init+0x393>
	assert((pp2 = page_alloc(0)));
f01017f3:	83 ec 0c             	sub    $0xc,%esp
f01017f6:	6a 00                	push   $0x0
f01017f8:	e8 78 fa ff ff       	call   f0101275 <page_alloc>
f01017fd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101800:	83 c4 10             	add    $0x10,%esp
f0101803:	85 c0                	test   %eax,%eax
f0101805:	0f 84 13 02 00 00    	je     f0101a1e <mem_init+0x3ac>
	assert(pp1 && pp1 != pp0);
f010180b:	39 f7                	cmp    %esi,%edi
f010180d:	0f 84 24 02 00 00    	je     f0101a37 <mem_init+0x3c5>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101813:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101816:	39 c6                	cmp    %eax,%esi
f0101818:	0f 84 32 02 00 00    	je     f0101a50 <mem_init+0x3de>
f010181e:	39 c7                	cmp    %eax,%edi
f0101820:	0f 84 2a 02 00 00    	je     f0101a50 <mem_init+0x3de>
	return (pp - pages) << PGSHIFT;
f0101826:	8b 0d d0 74 2c f0    	mov    0xf02c74d0,%ecx
	assert(page2pa(pp0) < npages*PGSIZE);
f010182c:	8b 15 c8 74 2c f0    	mov    0xf02c74c8,%edx
f0101832:	c1 e2 0c             	shl    $0xc,%edx
f0101835:	89 f8                	mov    %edi,%eax
f0101837:	29 c8                	sub    %ecx,%eax
f0101839:	c1 f8 03             	sar    $0x3,%eax
f010183c:	c1 e0 0c             	shl    $0xc,%eax
f010183f:	39 d0                	cmp    %edx,%eax
f0101841:	0f 83 22 02 00 00    	jae    f0101a69 <mem_init+0x3f7>
f0101847:	89 f0                	mov    %esi,%eax
f0101849:	29 c8                	sub    %ecx,%eax
f010184b:	c1 f8 03             	sar    $0x3,%eax
f010184e:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp1) < npages*PGSIZE);
f0101851:	39 c2                	cmp    %eax,%edx
f0101853:	0f 86 29 02 00 00    	jbe    f0101a82 <mem_init+0x410>
f0101859:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f010185c:	29 c8                	sub    %ecx,%eax
f010185e:	c1 f8 03             	sar    $0x3,%eax
f0101861:	c1 e0 0c             	shl    $0xc,%eax
	assert(page2pa(pp2) < npages*PGSIZE);
f0101864:	39 c2                	cmp    %eax,%edx
f0101866:	0f 86 2f 02 00 00    	jbe    f0101a9b <mem_init+0x429>
	fl = page_free_list;
f010186c:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f0101871:	89 45 d0             	mov    %eax,-0x30(%ebp)
	page_free_list = 0;
f0101874:	c7 05 40 62 2c f0 00 	movl   $0x0,0xf02c6240
f010187b:	00 00 00 
	assert(!page_alloc(0));
f010187e:	83 ec 0c             	sub    $0xc,%esp
f0101881:	6a 00                	push   $0x0
f0101883:	e8 ed f9 ff ff       	call   f0101275 <page_alloc>
f0101888:	83 c4 10             	add    $0x10,%esp
f010188b:	85 c0                	test   %eax,%eax
f010188d:	0f 85 21 02 00 00    	jne    f0101ab4 <mem_init+0x442>
	page_free(pp0);
f0101893:	83 ec 0c             	sub    $0xc,%esp
f0101896:	57                   	push   %edi
f0101897:	e8 64 fa ff ff       	call   f0101300 <page_free>
	page_free(pp1);
f010189c:	89 34 24             	mov    %esi,(%esp)
f010189f:	e8 5c fa ff ff       	call   f0101300 <page_free>
	page_free(pp2);
f01018a4:	83 c4 04             	add    $0x4,%esp
f01018a7:	ff 75 d4             	pushl  -0x2c(%ebp)
f01018aa:	e8 51 fa ff ff       	call   f0101300 <page_free>
	assert((pp0 = page_alloc(0)));
f01018af:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f01018b6:	e8 ba f9 ff ff       	call   f0101275 <page_alloc>
f01018bb:	89 c6                	mov    %eax,%esi
f01018bd:	83 c4 10             	add    $0x10,%esp
f01018c0:	85 c0                	test   %eax,%eax
f01018c2:	0f 84 05 02 00 00    	je     f0101acd <mem_init+0x45b>
	assert((pp1 = page_alloc(0)));
f01018c8:	83 ec 0c             	sub    $0xc,%esp
f01018cb:	6a 00                	push   $0x0
f01018cd:	e8 a3 f9 ff ff       	call   f0101275 <page_alloc>
f01018d2:	89 c7                	mov    %eax,%edi
f01018d4:	83 c4 10             	add    $0x10,%esp
f01018d7:	85 c0                	test   %eax,%eax
f01018d9:	0f 84 07 02 00 00    	je     f0101ae6 <mem_init+0x474>
	assert((pp2 = page_alloc(0)));
f01018df:	83 ec 0c             	sub    $0xc,%esp
f01018e2:	6a 00                	push   $0x0
f01018e4:	e8 8c f9 ff ff       	call   f0101275 <page_alloc>
f01018e9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01018ec:	83 c4 10             	add    $0x10,%esp
f01018ef:	85 c0                	test   %eax,%eax
f01018f1:	0f 84 08 02 00 00    	je     f0101aff <mem_init+0x48d>
	assert(pp1 && pp1 != pp0);
f01018f7:	39 fe                	cmp    %edi,%esi
f01018f9:	0f 84 19 02 00 00    	je     f0101b18 <mem_init+0x4a6>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01018ff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101902:	39 c7                	cmp    %eax,%edi
f0101904:	0f 84 27 02 00 00    	je     f0101b31 <mem_init+0x4bf>
f010190a:	39 c6                	cmp    %eax,%esi
f010190c:	0f 84 1f 02 00 00    	je     f0101b31 <mem_init+0x4bf>
	assert(!page_alloc(0));
f0101912:	83 ec 0c             	sub    $0xc,%esp
f0101915:	6a 00                	push   $0x0
f0101917:	e8 59 f9 ff ff       	call   f0101275 <page_alloc>
f010191c:	83 c4 10             	add    $0x10,%esp
f010191f:	85 c0                	test   %eax,%eax
f0101921:	0f 85 23 02 00 00    	jne    f0101b4a <mem_init+0x4d8>
f0101927:	89 f0                	mov    %esi,%eax
f0101929:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f010192f:	c1 f8 03             	sar    $0x3,%eax
f0101932:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101935:	89 c2                	mov    %eax,%edx
f0101937:	c1 ea 0c             	shr    $0xc,%edx
f010193a:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0101940:	0f 83 1d 02 00 00    	jae    f0101b63 <mem_init+0x4f1>
	memset(page2kva(pp0), 1, PGSIZE);
f0101946:	83 ec 04             	sub    $0x4,%esp
f0101949:	68 00 10 00 00       	push   $0x1000
f010194e:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0101950:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101955:	50                   	push   %eax
f0101956:	e8 c2 43 00 00       	call   f0105d1d <memset>
	page_free(pp0);
f010195b:	89 34 24             	mov    %esi,(%esp)
f010195e:	e8 9d f9 ff ff       	call   f0101300 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101963:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010196a:	e8 06 f9 ff ff       	call   f0101275 <page_alloc>
f010196f:	83 c4 10             	add    $0x10,%esp
f0101972:	85 c0                	test   %eax,%eax
f0101974:	0f 84 fe 01 00 00    	je     f0101b78 <mem_init+0x506>
	assert(pp && pp0 == pp);
f010197a:	39 c6                	cmp    %eax,%esi
f010197c:	0f 85 0f 02 00 00    	jne    f0101b91 <mem_init+0x51f>
	return (pp - pages) << PGSHIFT;
f0101982:	89 f0                	mov    %esi,%eax
f0101984:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f010198a:	c1 f8 03             	sar    $0x3,%eax
f010198d:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0101990:	89 c2                	mov    %eax,%edx
f0101992:	c1 ea 0c             	shr    $0xc,%edx
f0101995:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f010199b:	0f 83 09 02 00 00    	jae    f0101baa <mem_init+0x538>
f01019a1:	8d 90 00 10 00 f0    	lea    -0xffff000(%eax),%edx
	return (void *)(pa + KERNBASE);
f01019a7:	8d 80 00 00 00 f0    	lea    -0x10000000(%eax),%eax
		assert(c[i] == 0);
f01019ad:	80 38 00             	cmpb   $0x0,(%eax)
f01019b0:	0f 85 09 02 00 00    	jne    f0101bbf <mem_init+0x54d>
f01019b6:	40                   	inc    %eax
	for (i = 0; i < PGSIZE; i++)
f01019b7:	39 d0                	cmp    %edx,%eax
f01019b9:	75 f2                	jne    f01019ad <mem_init+0x33b>
	page_free_list = fl;
f01019bb:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01019be:	a3 40 62 2c f0       	mov    %eax,0xf02c6240
	page_free(pp0);
f01019c3:	83 ec 0c             	sub    $0xc,%esp
f01019c6:	56                   	push   %esi
f01019c7:	e8 34 f9 ff ff       	call   f0101300 <page_free>
	page_free(pp1);
f01019cc:	89 3c 24             	mov    %edi,(%esp)
f01019cf:	e8 2c f9 ff ff       	call   f0101300 <page_free>
	page_free(pp2);
f01019d4:	83 c4 04             	add    $0x4,%esp
f01019d7:	ff 75 d4             	pushl  -0x2c(%ebp)
f01019da:	e8 21 f9 ff ff       	call   f0101300 <page_free>
	for (pp = page_free_list; pp; pp = pp->pp_link)
f01019df:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f01019e4:	83 c4 10             	add    $0x10,%esp
f01019e7:	e9 ef 01 00 00       	jmp    f0101bdb <mem_init+0x569>
	assert((pp0 = page_alloc(0)));
f01019ec:	68 fa 88 10 f0       	push   $0xf01088fa
f01019f1:	68 31 78 10 f0       	push   $0xf0107831
f01019f6:	68 55 03 00 00       	push   $0x355
f01019fb:	68 05 88 10 f0       	push   $0xf0108805
f0101a00:	e8 3e e6 ff ff       	call   f0100043 <_panic>
	assert((pp1 = page_alloc(0)));
f0101a05:	68 10 89 10 f0       	push   $0xf0108910
f0101a0a:	68 31 78 10 f0       	push   $0xf0107831
f0101a0f:	68 56 03 00 00       	push   $0x356
f0101a14:	68 05 88 10 f0       	push   $0xf0108805
f0101a19:	e8 25 e6 ff ff       	call   f0100043 <_panic>
	assert((pp2 = page_alloc(0)));
f0101a1e:	68 26 89 10 f0       	push   $0xf0108926
f0101a23:	68 31 78 10 f0       	push   $0xf0107831
f0101a28:	68 57 03 00 00       	push   $0x357
f0101a2d:	68 05 88 10 f0       	push   $0xf0108805
f0101a32:	e8 0c e6 ff ff       	call   f0100043 <_panic>
	assert(pp1 && pp1 != pp0);
f0101a37:	68 3c 89 10 f0       	push   $0xf010893c
f0101a3c:	68 31 78 10 f0       	push   $0xf0107831
f0101a41:	68 5a 03 00 00       	push   $0x35a
f0101a46:	68 05 88 10 f0       	push   $0xf0108805
f0101a4b:	e8 f3 e5 ff ff       	call   f0100043 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101a50:	68 f8 7f 10 f0       	push   $0xf0107ff8
f0101a55:	68 31 78 10 f0       	push   $0xf0107831
f0101a5a:	68 5b 03 00 00       	push   $0x35b
f0101a5f:	68 05 88 10 f0       	push   $0xf0108805
f0101a64:	e8 da e5 ff ff       	call   f0100043 <_panic>
	assert(page2pa(pp0) < npages*PGSIZE);
f0101a69:	68 4e 89 10 f0       	push   $0xf010894e
f0101a6e:	68 31 78 10 f0       	push   $0xf0107831
f0101a73:	68 5c 03 00 00       	push   $0x35c
f0101a78:	68 05 88 10 f0       	push   $0xf0108805
f0101a7d:	e8 c1 e5 ff ff       	call   f0100043 <_panic>
	assert(page2pa(pp1) < npages*PGSIZE);
f0101a82:	68 6b 89 10 f0       	push   $0xf010896b
f0101a87:	68 31 78 10 f0       	push   $0xf0107831
f0101a8c:	68 5d 03 00 00       	push   $0x35d
f0101a91:	68 05 88 10 f0       	push   $0xf0108805
f0101a96:	e8 a8 e5 ff ff       	call   f0100043 <_panic>
	assert(page2pa(pp2) < npages*PGSIZE);
f0101a9b:	68 88 89 10 f0       	push   $0xf0108988
f0101aa0:	68 31 78 10 f0       	push   $0xf0107831
f0101aa5:	68 5e 03 00 00       	push   $0x35e
f0101aaa:	68 05 88 10 f0       	push   $0xf0108805
f0101aaf:	e8 8f e5 ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f0101ab4:	68 a5 89 10 f0       	push   $0xf01089a5
f0101ab9:	68 31 78 10 f0       	push   $0xf0107831
f0101abe:	68 65 03 00 00       	push   $0x365
f0101ac3:	68 05 88 10 f0       	push   $0xf0108805
f0101ac8:	e8 76 e5 ff ff       	call   f0100043 <_panic>
	assert((pp0 = page_alloc(0)));
f0101acd:	68 fa 88 10 f0       	push   $0xf01088fa
f0101ad2:	68 31 78 10 f0       	push   $0xf0107831
f0101ad7:	68 6c 03 00 00       	push   $0x36c
f0101adc:	68 05 88 10 f0       	push   $0xf0108805
f0101ae1:	e8 5d e5 ff ff       	call   f0100043 <_panic>
	assert((pp1 = page_alloc(0)));
f0101ae6:	68 10 89 10 f0       	push   $0xf0108910
f0101aeb:	68 31 78 10 f0       	push   $0xf0107831
f0101af0:	68 6d 03 00 00       	push   $0x36d
f0101af5:	68 05 88 10 f0       	push   $0xf0108805
f0101afa:	e8 44 e5 ff ff       	call   f0100043 <_panic>
	assert((pp2 = page_alloc(0)));
f0101aff:	68 26 89 10 f0       	push   $0xf0108926
f0101b04:	68 31 78 10 f0       	push   $0xf0107831
f0101b09:	68 6e 03 00 00       	push   $0x36e
f0101b0e:	68 05 88 10 f0       	push   $0xf0108805
f0101b13:	e8 2b e5 ff ff       	call   f0100043 <_panic>
	assert(pp1 && pp1 != pp0);
f0101b18:	68 3c 89 10 f0       	push   $0xf010893c
f0101b1d:	68 31 78 10 f0       	push   $0xf0107831
f0101b22:	68 70 03 00 00       	push   $0x370
f0101b27:	68 05 88 10 f0       	push   $0xf0108805
f0101b2c:	e8 12 e5 ff ff       	call   f0100043 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101b31:	68 f8 7f 10 f0       	push   $0xf0107ff8
f0101b36:	68 31 78 10 f0       	push   $0xf0107831
f0101b3b:	68 71 03 00 00       	push   $0x371
f0101b40:	68 05 88 10 f0       	push   $0xf0108805
f0101b45:	e8 f9 e4 ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f0101b4a:	68 a5 89 10 f0       	push   $0xf01089a5
f0101b4f:	68 31 78 10 f0       	push   $0xf0107831
f0101b54:	68 72 03 00 00       	push   $0x372
f0101b59:	68 05 88 10 f0       	push   $0xf0108805
f0101b5e:	e8 e0 e4 ff ff       	call   f0100043 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0101b63:	50                   	push   %eax
f0101b64:	68 c8 77 10 f0       	push   $0xf01077c8
f0101b69:	68 8e 00 00 00       	push   $0x8e
f0101b6e:	68 11 88 10 f0       	push   $0xf0108811
f0101b73:	e8 cb e4 ff ff       	call   f0100043 <_panic>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0101b78:	68 b4 89 10 f0       	push   $0xf01089b4
f0101b7d:	68 31 78 10 f0       	push   $0xf0107831
f0101b82:	68 77 03 00 00       	push   $0x377
f0101b87:	68 05 88 10 f0       	push   $0xf0108805
f0101b8c:	e8 b2 e4 ff ff       	call   f0100043 <_panic>
	assert(pp && pp0 == pp);
f0101b91:	68 d2 89 10 f0       	push   $0xf01089d2
f0101b96:	68 31 78 10 f0       	push   $0xf0107831
f0101b9b:	68 78 03 00 00       	push   $0x378
f0101ba0:	68 05 88 10 f0       	push   $0xf0108805
f0101ba5:	e8 99 e4 ff ff       	call   f0100043 <_panic>
f0101baa:	50                   	push   %eax
f0101bab:	68 c8 77 10 f0       	push   $0xf01077c8
f0101bb0:	68 8e 00 00 00       	push   $0x8e
f0101bb5:	68 11 88 10 f0       	push   $0xf0108811
f0101bba:	e8 84 e4 ff ff       	call   f0100043 <_panic>
		assert(c[i] == 0);
f0101bbf:	68 e2 89 10 f0       	push   $0xf01089e2
f0101bc4:	68 31 78 10 f0       	push   $0xf0107831
f0101bc9:	68 7b 03 00 00       	push   $0x37b
f0101bce:	68 05 88 10 f0       	push   $0xf0108805
f0101bd3:	e8 6b e4 ff ff       	call   f0100043 <_panic>
		--nfree;
f0101bd8:	4b                   	dec    %ebx
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0101bd9:	8b 00                	mov    (%eax),%eax
f0101bdb:	85 c0                	test   %eax,%eax
f0101bdd:	75 f9                	jne    f0101bd8 <mem_init+0x566>
	assert(nfree == 0);
f0101bdf:	85 db                	test   %ebx,%ebx
f0101be1:	0f 85 5a 09 00 00    	jne    f0102541 <mem_init+0xecf>
	cprintf("check_page_alloc() succeeded!\n");
f0101be7:	83 ec 0c             	sub    $0xc,%esp
f0101bea:	68 18 80 10 f0       	push   $0xf0108018
f0101bef:	e8 af 20 00 00       	call   f0103ca3 <cprintf>
	int i;
	extern pde_t entry_pgdir[];

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0101bf4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101bfb:	e8 75 f6 ff ff       	call   f0101275 <page_alloc>
f0101c00:	89 c7                	mov    %eax,%edi
f0101c02:	83 c4 10             	add    $0x10,%esp
f0101c05:	85 c0                	test   %eax,%eax
f0101c07:	0f 84 4d 09 00 00    	je     f010255a <mem_init+0xee8>
	assert((pp1 = page_alloc(0)));
f0101c0d:	83 ec 0c             	sub    $0xc,%esp
f0101c10:	6a 00                	push   $0x0
f0101c12:	e8 5e f6 ff ff       	call   f0101275 <page_alloc>
f0101c17:	89 c3                	mov    %eax,%ebx
f0101c19:	83 c4 10             	add    $0x10,%esp
f0101c1c:	85 c0                	test   %eax,%eax
f0101c1e:	0f 84 4f 09 00 00    	je     f0102573 <mem_init+0xf01>
	assert((pp2 = page_alloc(0)));
f0101c24:	83 ec 0c             	sub    $0xc,%esp
f0101c27:	6a 00                	push   $0x0
f0101c29:	e8 47 f6 ff ff       	call   f0101275 <page_alloc>
f0101c2e:	89 c6                	mov    %eax,%esi
f0101c30:	83 c4 10             	add    $0x10,%esp
f0101c33:	85 c0                	test   %eax,%eax
f0101c35:	0f 84 51 09 00 00    	je     f010258c <mem_init+0xf1a>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0101c3b:	39 df                	cmp    %ebx,%edi
f0101c3d:	0f 84 62 09 00 00    	je     f01025a5 <mem_init+0xf33>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0101c43:	39 c3                	cmp    %eax,%ebx
f0101c45:	0f 84 73 09 00 00    	je     f01025be <mem_init+0xf4c>
f0101c4b:	39 c7                	cmp    %eax,%edi
f0101c4d:	0f 84 6b 09 00 00    	je     f01025be <mem_init+0xf4c>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0101c53:	a1 40 62 2c f0       	mov    0xf02c6240,%eax
f0101c58:	89 45 c8             	mov    %eax,-0x38(%ebp)
	page_free_list = 0;
f0101c5b:	c7 05 40 62 2c f0 00 	movl   $0x0,0xf02c6240
f0101c62:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0101c65:	83 ec 0c             	sub    $0xc,%esp
f0101c68:	6a 00                	push   $0x0
f0101c6a:	e8 06 f6 ff ff       	call   f0101275 <page_alloc>
f0101c6f:	83 c4 10             	add    $0x10,%esp
f0101c72:	85 c0                	test   %eax,%eax
f0101c74:	0f 85 5d 09 00 00    	jne    f01025d7 <mem_init+0xf65>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0101c7a:	83 ec 04             	sub    $0x4,%esp
f0101c7d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0101c80:	50                   	push   %eax
f0101c81:	6a 00                	push   $0x0
f0101c83:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101c89:	e8 15 f8 ff ff       	call   f01014a3 <page_lookup>
f0101c8e:	83 c4 10             	add    $0x10,%esp
f0101c91:	85 c0                	test   %eax,%eax
f0101c93:	0f 85 57 09 00 00    	jne    f01025f0 <mem_init+0xf7e>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0101c99:	6a 02                	push   $0x2
f0101c9b:	6a 00                	push   $0x0
f0101c9d:	53                   	push   %ebx
f0101c9e:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101ca4:	e8 f3 f8 ff ff       	call   f010159c <page_insert>
f0101ca9:	83 c4 10             	add    $0x10,%esp
f0101cac:	85 c0                	test   %eax,%eax
f0101cae:	0f 89 55 09 00 00    	jns    f0102609 <mem_init+0xf97>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0101cb4:	83 ec 0c             	sub    $0xc,%esp
f0101cb7:	57                   	push   %edi
f0101cb8:	e8 43 f6 ff ff       	call   f0101300 <page_free>


	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0101cbd:	6a 02                	push   $0x2
f0101cbf:	6a 00                	push   $0x0
f0101cc1:	53                   	push   %ebx
f0101cc2:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101cc8:	e8 cf f8 ff ff       	call   f010159c <page_insert>
f0101ccd:	83 c4 20             	add    $0x20,%esp
f0101cd0:	85 c0                	test   %eax,%eax
f0101cd2:	0f 85 4a 09 00 00    	jne    f0102622 <mem_init+0xfb0>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0101cd8:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101cdd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	return (pp - pages) << PGSHIFT;
f0101ce0:	8b 0d d0 74 2c f0    	mov    0xf02c74d0,%ecx
f0101ce6:	89 4d d0             	mov    %ecx,-0x30(%ebp)
f0101ce9:	8b 00                	mov    (%eax),%eax
f0101ceb:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0101cee:	89 c2                	mov    %eax,%edx
f0101cf0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0101cf6:	89 f8                	mov    %edi,%eax
f0101cf8:	29 c8                	sub    %ecx,%eax
f0101cfa:	c1 f8 03             	sar    $0x3,%eax
f0101cfd:	c1 e0 0c             	shl    $0xc,%eax
f0101d00:	39 c2                	cmp    %eax,%edx
f0101d02:	0f 85 33 09 00 00    	jne    f010263b <mem_init+0xfc9>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0101d08:	ba 00 00 00 00       	mov    $0x0,%edx
f0101d0d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101d10:	e8 9e ef ff ff       	call   f0100cb3 <check_va2pa>
f0101d15:	89 da                	mov    %ebx,%edx
f0101d17:	2b 55 d0             	sub    -0x30(%ebp),%edx
f0101d1a:	c1 fa 03             	sar    $0x3,%edx
f0101d1d:	c1 e2 0c             	shl    $0xc,%edx
f0101d20:	39 d0                	cmp    %edx,%eax
f0101d22:	0f 85 2c 09 00 00    	jne    f0102654 <mem_init+0xfe2>
	assert(pp1->pp_ref == 1);
f0101d28:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0101d2d:	0f 85 3a 09 00 00    	jne    f010266d <mem_init+0xffb>
	assert(pp0->pp_ref == 1);
f0101d33:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0101d38:	0f 85 48 09 00 00    	jne    f0102686 <mem_init+0x1014>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table

	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101d3e:	6a 02                	push   $0x2
f0101d40:	68 00 10 00 00       	push   $0x1000
f0101d45:	56                   	push   %esi
f0101d46:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101d49:	e8 4e f8 ff ff       	call   f010159c <page_insert>
f0101d4e:	83 c4 10             	add    $0x10,%esp
f0101d51:	85 c0                	test   %eax,%eax
f0101d53:	0f 85 46 09 00 00    	jne    f010269f <mem_init+0x102d>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101d59:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101d5e:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101d63:	e8 4b ef ff ff       	call   f0100cb3 <check_va2pa>
f0101d68:	89 f2                	mov    %esi,%edx
f0101d6a:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f0101d70:	c1 fa 03             	sar    $0x3,%edx
f0101d73:	c1 e2 0c             	shl    $0xc,%edx
f0101d76:	39 d0                	cmp    %edx,%eax
f0101d78:	0f 85 3a 09 00 00    	jne    f01026b8 <mem_init+0x1046>
	assert(pp2->pp_ref == 1);
f0101d7e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101d83:	0f 85 48 09 00 00    	jne    f01026d1 <mem_init+0x105f>

	// should be no free memory
	assert(!page_alloc(0));
f0101d89:	83 ec 0c             	sub    $0xc,%esp
f0101d8c:	6a 00                	push   $0x0
f0101d8e:	e8 e2 f4 ff ff       	call   f0101275 <page_alloc>
f0101d93:	83 c4 10             	add    $0x10,%esp
f0101d96:	85 c0                	test   %eax,%eax
f0101d98:	0f 85 4c 09 00 00    	jne    f01026ea <mem_init+0x1078>
	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101d9e:	6a 02                	push   $0x2
f0101da0:	68 00 10 00 00       	push   $0x1000
f0101da5:	56                   	push   %esi
f0101da6:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101dac:	e8 eb f7 ff ff       	call   f010159c <page_insert>
f0101db1:	83 c4 10             	add    $0x10,%esp
f0101db4:	85 c0                	test   %eax,%eax
f0101db6:	0f 85 47 09 00 00    	jne    f0102703 <mem_init+0x1091>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101dbc:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101dc1:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101dc6:	e8 e8 ee ff ff       	call   f0100cb3 <check_va2pa>
f0101dcb:	89 f2                	mov    %esi,%edx
f0101dcd:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f0101dd3:	c1 fa 03             	sar    $0x3,%edx
f0101dd6:	c1 e2 0c             	shl    $0xc,%edx
f0101dd9:	39 d0                	cmp    %edx,%eax
f0101ddb:	0f 85 3b 09 00 00    	jne    f010271c <mem_init+0x10aa>
	assert(pp2->pp_ref == 1);
f0101de1:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101de6:	0f 85 49 09 00 00    	jne    f0102735 <mem_init+0x10c3>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0101dec:	83 ec 0c             	sub    $0xc,%esp
f0101def:	6a 00                	push   $0x0
f0101df1:	e8 7f f4 ff ff       	call   f0101275 <page_alloc>
f0101df6:	83 c4 10             	add    $0x10,%esp
f0101df9:	85 c0                	test   %eax,%eax
f0101dfb:	0f 85 4d 09 00 00    	jne    f010274e <mem_init+0x10dc>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0101e01:	8b 15 cc 74 2c f0    	mov    0xf02c74cc,%edx
f0101e07:	8b 02                	mov    (%edx),%eax
f0101e09:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f0101e0e:	89 c1                	mov    %eax,%ecx
f0101e10:	c1 e9 0c             	shr    $0xc,%ecx
f0101e13:	3b 0d c8 74 2c f0    	cmp    0xf02c74c8,%ecx
f0101e19:	0f 83 48 09 00 00    	jae    f0102767 <mem_init+0x10f5>
	return (void *)(pa + KERNBASE);
f0101e1f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0101e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0101e27:	83 ec 04             	sub    $0x4,%esp
f0101e2a:	6a 00                	push   $0x0
f0101e2c:	68 00 10 00 00       	push   $0x1000
f0101e31:	52                   	push   %edx
f0101e32:	e8 32 f5 ff ff       	call   f0101369 <pgdir_walk>
f0101e37:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f0101e3a:	8d 51 04             	lea    0x4(%ecx),%edx
f0101e3d:	83 c4 10             	add    $0x10,%esp
f0101e40:	39 d0                	cmp    %edx,%eax
f0101e42:	0f 85 34 09 00 00    	jne    f010277c <mem_init+0x110a>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0101e48:	6a 06                	push   $0x6
f0101e4a:	68 00 10 00 00       	push   $0x1000
f0101e4f:	56                   	push   %esi
f0101e50:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101e56:	e8 41 f7 ff ff       	call   f010159c <page_insert>
f0101e5b:	83 c4 10             	add    $0x10,%esp
f0101e5e:	85 c0                	test   %eax,%eax
f0101e60:	0f 85 2f 09 00 00    	jne    f0102795 <mem_init+0x1123>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0101e66:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101e6b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101e6e:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101e73:	e8 3b ee ff ff       	call   f0100cb3 <check_va2pa>
	return (pp - pages) << PGSHIFT;
f0101e78:	89 f2                	mov    %esi,%edx
f0101e7a:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f0101e80:	c1 fa 03             	sar    $0x3,%edx
f0101e83:	c1 e2 0c             	shl    $0xc,%edx
f0101e86:	39 d0                	cmp    %edx,%eax
f0101e88:	0f 85 20 09 00 00    	jne    f01027ae <mem_init+0x113c>
	assert(pp2->pp_ref == 1);
f0101e8e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0101e93:	0f 85 2e 09 00 00    	jne    f01027c7 <mem_init+0x1155>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0101e99:	83 ec 04             	sub    $0x4,%esp
f0101e9c:	6a 00                	push   $0x0
f0101e9e:	68 00 10 00 00       	push   $0x1000
f0101ea3:	ff 75 d4             	pushl  -0x2c(%ebp)
f0101ea6:	e8 be f4 ff ff       	call   f0101369 <pgdir_walk>
f0101eab:	83 c4 10             	add    $0x10,%esp
f0101eae:	f6 00 04             	testb  $0x4,(%eax)
f0101eb1:	0f 84 29 09 00 00    	je     f01027e0 <mem_init+0x116e>
	assert(kern_pgdir[0] & PTE_U);
f0101eb7:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101ebc:	f6 00 04             	testb  $0x4,(%eax)
f0101ebf:	0f 84 34 09 00 00    	je     f01027f9 <mem_init+0x1187>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0101ec5:	6a 02                	push   $0x2
f0101ec7:	68 00 10 00 00       	push   $0x1000
f0101ecc:	56                   	push   %esi
f0101ecd:	50                   	push   %eax
f0101ece:	e8 c9 f6 ff ff       	call   f010159c <page_insert>
f0101ed3:	83 c4 10             	add    $0x10,%esp
f0101ed6:	85 c0                	test   %eax,%eax
f0101ed8:	0f 85 34 09 00 00    	jne    f0102812 <mem_init+0x11a0>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f0101ede:	83 ec 04             	sub    $0x4,%esp
f0101ee1:	6a 00                	push   $0x0
f0101ee3:	68 00 10 00 00       	push   $0x1000
f0101ee8:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101eee:	e8 76 f4 ff ff       	call   f0101369 <pgdir_walk>
f0101ef3:	83 c4 10             	add    $0x10,%esp
f0101ef6:	f6 00 02             	testb  $0x2,(%eax)
f0101ef9:	0f 84 2c 09 00 00    	je     f010282b <mem_init+0x11b9>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101eff:	83 ec 04             	sub    $0x4,%esp
f0101f02:	6a 00                	push   $0x0
f0101f04:	68 00 10 00 00       	push   $0x1000
f0101f09:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101f0f:	e8 55 f4 ff ff       	call   f0101369 <pgdir_walk>
f0101f14:	83 c4 10             	add    $0x10,%esp
f0101f17:	f6 00 04             	testb  $0x4,(%eax)
f0101f1a:	0f 85 24 09 00 00    	jne    f0102844 <mem_init+0x11d2>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f0101f20:	6a 02                	push   $0x2
f0101f22:	68 00 00 40 00       	push   $0x400000
f0101f27:	57                   	push   %edi
f0101f28:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101f2e:	e8 69 f6 ff ff       	call   f010159c <page_insert>
f0101f33:	83 c4 10             	add    $0x10,%esp
f0101f36:	85 c0                	test   %eax,%eax
f0101f38:	0f 89 1f 09 00 00    	jns    f010285d <mem_init+0x11eb>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0101f3e:	6a 02                	push   $0x2
f0101f40:	68 00 10 00 00       	push   $0x1000
f0101f45:	53                   	push   %ebx
f0101f46:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101f4c:	e8 4b f6 ff ff       	call   f010159c <page_insert>
f0101f51:	83 c4 10             	add    $0x10,%esp
f0101f54:	85 c0                	test   %eax,%eax
f0101f56:	0f 85 1a 09 00 00    	jne    f0102876 <mem_init+0x1204>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0101f5c:	83 ec 04             	sub    $0x4,%esp
f0101f5f:	6a 00                	push   $0x0
f0101f61:	68 00 10 00 00       	push   $0x1000
f0101f66:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101f6c:	e8 f8 f3 ff ff       	call   f0101369 <pgdir_walk>
f0101f71:	83 c4 10             	add    $0x10,%esp
f0101f74:	f6 00 04             	testb  $0x4,(%eax)
f0101f77:	0f 85 12 09 00 00    	jne    f010288f <mem_init+0x121d>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f0101f7d:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0101f82:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0101f85:	ba 00 00 00 00       	mov    $0x0,%edx
f0101f8a:	e8 24 ed ff ff       	call   f0100cb3 <check_va2pa>
f0101f8f:	89 c1                	mov    %eax,%ecx
f0101f91:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0101f94:	89 d8                	mov    %ebx,%eax
f0101f96:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0101f9c:	c1 f8 03             	sar    $0x3,%eax
f0101f9f:	c1 e0 0c             	shl    $0xc,%eax
f0101fa2:	39 c1                	cmp    %eax,%ecx
f0101fa4:	0f 85 fe 08 00 00    	jne    f01028a8 <mem_init+0x1236>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0101faa:	ba 00 10 00 00       	mov    $0x1000,%edx
f0101faf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0101fb2:	e8 fc ec ff ff       	call   f0100cb3 <check_va2pa>
f0101fb7:	39 45 d0             	cmp    %eax,-0x30(%ebp)
f0101fba:	0f 85 01 09 00 00    	jne    f01028c1 <mem_init+0x124f>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0101fc0:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0101fc5:	0f 85 0f 09 00 00    	jne    f01028da <mem_init+0x1268>

	assert(pp2->pp_ref == 0);
f0101fcb:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0101fd0:	0f 85 1d 09 00 00    	jne    f01028f3 <mem_init+0x1281>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f0101fd6:	83 ec 0c             	sub    $0xc,%esp
f0101fd9:	6a 00                	push   $0x0
f0101fdb:	e8 95 f2 ff ff       	call   f0101275 <page_alloc>
f0101fe0:	83 c4 10             	add    $0x10,%esp
f0101fe3:	85 c0                	test   %eax,%eax
f0101fe5:	0f 84 21 09 00 00    	je     f010290c <mem_init+0x129a>
f0101feb:	39 c6                	cmp    %eax,%esi
f0101fed:	0f 85 19 09 00 00    	jne    f010290c <mem_init+0x129a>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0101ff3:	83 ec 08             	sub    $0x8,%esp
f0101ff6:	6a 00                	push   $0x0
f0101ff8:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0101ffe:	e8 53 f5 ff ff       	call   f0101556 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102003:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0102008:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f010200b:	ba 00 00 00 00       	mov    $0x0,%edx
f0102010:	e8 9e ec ff ff       	call   f0100cb3 <check_va2pa>
f0102015:	83 c4 10             	add    $0x10,%esp
f0102018:	83 f8 ff             	cmp    $0xffffffff,%eax
f010201b:	0f 85 04 09 00 00    	jne    f0102925 <mem_init+0x12b3>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f0102021:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102026:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102029:	e8 85 ec ff ff       	call   f0100cb3 <check_va2pa>
f010202e:	89 da                	mov    %ebx,%edx
f0102030:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f0102036:	c1 fa 03             	sar    $0x3,%edx
f0102039:	c1 e2 0c             	shl    $0xc,%edx
f010203c:	39 d0                	cmp    %edx,%eax
f010203e:	0f 85 fa 08 00 00    	jne    f010293e <mem_init+0x12cc>
	assert(pp1->pp_ref == 1);
f0102044:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102049:	0f 85 08 09 00 00    	jne    f0102957 <mem_init+0x12e5>
	assert(pp2->pp_ref == 0);
f010204f:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f0102054:	0f 85 16 09 00 00    	jne    f0102970 <mem_init+0x12fe>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f010205a:	6a 00                	push   $0x0
f010205c:	68 00 10 00 00       	push   $0x1000
f0102061:	53                   	push   %ebx
f0102062:	ff 75 d4             	pushl  -0x2c(%ebp)
f0102065:	e8 32 f5 ff ff       	call   f010159c <page_insert>
f010206a:	83 c4 10             	add    $0x10,%esp
f010206d:	85 c0                	test   %eax,%eax
f010206f:	0f 85 14 09 00 00    	jne    f0102989 <mem_init+0x1317>
	assert(pp1->pp_ref);
f0102075:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f010207a:	0f 84 22 09 00 00    	je     f01029a2 <mem_init+0x1330>
	assert(pp1->pp_link == NULL);
f0102080:	83 3b 00             	cmpl   $0x0,(%ebx)
f0102083:	0f 85 32 09 00 00    	jne    f01029bb <mem_init+0x1349>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0102089:	83 ec 08             	sub    $0x8,%esp
f010208c:	68 00 10 00 00       	push   $0x1000
f0102091:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0102097:	e8 ba f4 ff ff       	call   f0101556 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f010209c:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f01020a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01020a4:	ba 00 00 00 00       	mov    $0x0,%edx
f01020a9:	e8 05 ec ff ff       	call   f0100cb3 <check_va2pa>
f01020ae:	83 c4 10             	add    $0x10,%esp
f01020b1:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020b4:	0f 85 1a 09 00 00    	jne    f01029d4 <mem_init+0x1362>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01020ba:	ba 00 10 00 00       	mov    $0x1000,%edx
f01020bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01020c2:	e8 ec eb ff ff       	call   f0100cb3 <check_va2pa>
f01020c7:	83 f8 ff             	cmp    $0xffffffff,%eax
f01020ca:	0f 85 1d 09 00 00    	jne    f01029ed <mem_init+0x137b>
	assert(pp1->pp_ref == 0);
f01020d0:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01020d5:	0f 85 2b 09 00 00    	jne    f0102a06 <mem_init+0x1394>
	assert(pp2->pp_ref == 0);
f01020db:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01020e0:	0f 85 39 09 00 00    	jne    f0102a1f <mem_init+0x13ad>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01020e6:	83 ec 0c             	sub    $0xc,%esp
f01020e9:	6a 00                	push   $0x0
f01020eb:	e8 85 f1 ff ff       	call   f0101275 <page_alloc>
f01020f0:	83 c4 10             	add    $0x10,%esp
f01020f3:	85 c0                	test   %eax,%eax
f01020f5:	0f 84 3d 09 00 00    	je     f0102a38 <mem_init+0x13c6>
f01020fb:	39 c3                	cmp    %eax,%ebx
f01020fd:	0f 85 35 09 00 00    	jne    f0102a38 <mem_init+0x13c6>

	// should be no free memory
	assert(!page_alloc(0));
f0102103:	83 ec 0c             	sub    $0xc,%esp
f0102106:	6a 00                	push   $0x0
f0102108:	e8 68 f1 ff ff       	call   f0101275 <page_alloc>
f010210d:	83 c4 10             	add    $0x10,%esp
f0102110:	85 c0                	test   %eax,%eax
f0102112:	0f 85 39 09 00 00    	jne    f0102a51 <mem_init+0x13df>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102118:	8b 0d cc 74 2c f0    	mov    0xf02c74cc,%ecx
f010211e:	8b 11                	mov    (%ecx),%edx
f0102120:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102126:	89 f8                	mov    %edi,%eax
f0102128:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f010212e:	c1 f8 03             	sar    $0x3,%eax
f0102131:	c1 e0 0c             	shl    $0xc,%eax
f0102134:	39 c2                	cmp    %eax,%edx
f0102136:	0f 85 2e 09 00 00    	jne    f0102a6a <mem_init+0x13f8>
	kern_pgdir[0] = 0;
f010213c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f0102142:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102147:	0f 85 36 09 00 00    	jne    f0102a83 <mem_init+0x1411>
	pp0->pp_ref = 0;
f010214d:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0102153:	83 ec 0c             	sub    $0xc,%esp
f0102156:	57                   	push   %edi
f0102157:	e8 a4 f1 ff ff       	call   f0101300 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f010215c:	83 c4 0c             	add    $0xc,%esp
f010215f:	6a 01                	push   $0x1
f0102161:	68 00 10 40 00       	push   $0x401000
f0102166:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f010216c:	e8 f8 f1 ff ff       	call   f0101369 <pgdir_walk>
f0102171:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102174:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f0102177:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f010217c:	89 45 d0             	mov    %eax,-0x30(%ebp)
f010217f:	8b 50 04             	mov    0x4(%eax),%edx
f0102182:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	if (PGNUM(pa) >= npages)
f0102188:	a1 c8 74 2c f0       	mov    0xf02c74c8,%eax
f010218d:	89 45 cc             	mov    %eax,-0x34(%ebp)
f0102190:	89 d1                	mov    %edx,%ecx
f0102192:	c1 e9 0c             	shr    $0xc,%ecx
f0102195:	83 c4 10             	add    $0x10,%esp
f0102198:	39 c1                	cmp    %eax,%ecx
f010219a:	0f 83 fc 08 00 00    	jae    f0102a9c <mem_init+0x142a>
	assert(ptep == ptep1 + PTX(va));
f01021a0:	81 ea fc ff ff 0f    	sub    $0xffffffc,%edx
f01021a6:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
f01021a9:	0f 85 02 09 00 00    	jne    f0102ab1 <mem_init+0x143f>
	kern_pgdir[PDX(va)] = 0;
f01021af:	8b 45 d0             	mov    -0x30(%ebp),%eax
f01021b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;
f01021b9:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)
	return (pp - pages) << PGSHIFT;
f01021bf:	89 f8                	mov    %edi,%eax
f01021c1:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01021c7:	c1 f8 03             	sar    $0x3,%eax
f01021ca:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01021cd:	89 c2                	mov    %eax,%edx
f01021cf:	c1 ea 0c             	shr    $0xc,%edx
f01021d2:	39 55 cc             	cmp    %edx,-0x34(%ebp)
f01021d5:	0f 86 ef 08 00 00    	jbe    f0102aca <mem_init+0x1458>

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f01021db:	83 ec 04             	sub    $0x4,%esp
f01021de:	68 00 10 00 00       	push   $0x1000
f01021e3:	68 ff 00 00 00       	push   $0xff
	return (void *)(pa + KERNBASE);
f01021e8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01021ed:	50                   	push   %eax
f01021ee:	e8 2a 3b 00 00       	call   f0105d1d <memset>
	page_free(pp0);
f01021f3:	89 3c 24             	mov    %edi,(%esp)
f01021f6:	e8 05 f1 ff ff       	call   f0101300 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f01021fb:	83 c4 0c             	add    $0xc,%esp
f01021fe:	6a 01                	push   $0x1
f0102200:	6a 00                	push   $0x0
f0102202:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0102208:	e8 5c f1 ff ff       	call   f0101369 <pgdir_walk>
	return (pp - pages) << PGSHIFT;
f010220d:	89 fa                	mov    %edi,%edx
f010220f:	2b 15 d0 74 2c f0    	sub    0xf02c74d0,%edx
f0102215:	c1 fa 03             	sar    $0x3,%edx
f0102218:	c1 e2 0c             	shl    $0xc,%edx
	if (PGNUM(pa) >= npages)
f010221b:	89 d0                	mov    %edx,%eax
f010221d:	c1 e8 0c             	shr    $0xc,%eax
f0102220:	83 c4 10             	add    $0x10,%esp
f0102223:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f0102229:	0f 83 b0 08 00 00    	jae    f0102adf <mem_init+0x146d>
	return (void *)(pa + KERNBASE);
f010222f:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
	ptep = (pte_t *) page2kva(pp0);
f0102235:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0102238:	81 ea 00 f0 ff 0f    	sub    $0xffff000,%edx
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f010223e:	f6 00 01             	testb  $0x1,(%eax)
f0102241:	0f 85 ad 08 00 00    	jne    f0102af4 <mem_init+0x1482>
f0102247:	83 c0 04             	add    $0x4,%eax
	for(i=0; i<NPTENTRIES; i++)
f010224a:	39 d0                	cmp    %edx,%eax
f010224c:	75 f0                	jne    f010223e <mem_init+0xbcc>
	kern_pgdir[0] = 0;
f010224e:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0102253:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;
f0102259:	66 c7 47 04 00 00    	movw   $0x0,0x4(%edi)

	// give free list back
	page_free_list = fl;
f010225f:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102262:	a3 40 62 2c f0       	mov    %eax,0xf02c6240

	// free the pages we took
	page_free(pp0);
f0102267:	83 ec 0c             	sub    $0xc,%esp
f010226a:	57                   	push   %edi
f010226b:	e8 90 f0 ff ff       	call   f0101300 <page_free>
	page_free(pp1);
f0102270:	89 1c 24             	mov    %ebx,(%esp)
f0102273:	e8 88 f0 ff ff       	call   f0101300 <page_free>
	page_free(pp2);
f0102278:	89 34 24             	mov    %esi,(%esp)
f010227b:	e8 80 f0 ff ff       	call   f0101300 <page_free>

	// test mmio_map_region
	mm1 = (uintptr_t) mmio_map_region(0, 4097);
f0102280:	83 c4 08             	add    $0x8,%esp
f0102283:	68 01 10 00 00       	push   $0x1001
f0102288:	6a 00                	push   $0x0
f010228a:	e8 80 f3 ff ff       	call   f010160f <mmio_map_region>
f010228f:	89 c3                	mov    %eax,%ebx
	mm2 = (uintptr_t) mmio_map_region(0, 4096);
f0102291:	83 c4 08             	add    $0x8,%esp
f0102294:	68 00 10 00 00       	push   $0x1000
f0102299:	6a 00                	push   $0x0
f010229b:	e8 6f f3 ff ff       	call   f010160f <mmio_map_region>
f01022a0:	89 c6                	mov    %eax,%esi
	// check that they're in the right region
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f01022a2:	83 c4 10             	add    $0x10,%esp
f01022a5:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01022ab:	0f 86 5c 08 00 00    	jbe    f0102b0d <mem_init+0x149b>
f01022b1:	8d 83 a0 1f 00 00    	lea    0x1fa0(%ebx),%eax
f01022b7:	3d ff ff bf ef       	cmp    $0xefbfffff,%eax
f01022bc:	0f 87 4b 08 00 00    	ja     f0102b0d <mem_init+0x149b>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f01022c2:	81 fe ff ff 7f ef    	cmp    $0xef7fffff,%esi
f01022c8:	0f 86 58 08 00 00    	jbe    f0102b26 <mem_init+0x14b4>
f01022ce:	8d 96 a0 1f 00 00    	lea    0x1fa0(%esi),%edx
f01022d4:	81 fa ff ff bf ef    	cmp    $0xefbfffff,%edx
f01022da:	0f 87 46 08 00 00    	ja     f0102b26 <mem_init+0x14b4>
	// check that they're page-aligned
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f01022e0:	89 da                	mov    %ebx,%edx
f01022e2:	09 f2                	or     %esi,%edx
f01022e4:	f7 c2 ff 0f 00 00    	test   $0xfff,%edx
f01022ea:	0f 85 4f 08 00 00    	jne    f0102b3f <mem_init+0x14cd>
	// check that they don't overlap
	assert(mm1 + 8096 <= mm2);
f01022f0:	39 c6                	cmp    %eax,%esi
f01022f2:	0f 82 60 08 00 00    	jb     f0102b58 <mem_init+0x14e6>
	// check page mappings
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f01022f8:	8b 3d cc 74 2c f0    	mov    0xf02c74cc,%edi
f01022fe:	89 da                	mov    %ebx,%edx
f0102300:	89 f8                	mov    %edi,%eax
f0102302:	e8 ac e9 ff ff       	call   f0100cb3 <check_va2pa>
f0102307:	85 c0                	test   %eax,%eax
f0102309:	0f 85 62 08 00 00    	jne    f0102b71 <mem_init+0x14ff>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f010230f:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
f0102315:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0102318:	89 c2                	mov    %eax,%edx
f010231a:	89 f8                	mov    %edi,%eax
f010231c:	e8 92 e9 ff ff       	call   f0100cb3 <check_va2pa>
f0102321:	3d 00 10 00 00       	cmp    $0x1000,%eax
f0102326:	0f 85 5e 08 00 00    	jne    f0102b8a <mem_init+0x1518>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f010232c:	89 f2                	mov    %esi,%edx
f010232e:	89 f8                	mov    %edi,%eax
f0102330:	e8 7e e9 ff ff       	call   f0100cb3 <check_va2pa>
f0102335:	85 c0                	test   %eax,%eax
f0102337:	0f 85 66 08 00 00    	jne    f0102ba3 <mem_init+0x1531>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f010233d:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
f0102343:	89 f8                	mov    %edi,%eax
f0102345:	e8 69 e9 ff ff       	call   f0100cb3 <check_va2pa>
f010234a:	83 f8 ff             	cmp    $0xffffffff,%eax
f010234d:	0f 85 69 08 00 00    	jne    f0102bbc <mem_init+0x154a>
	// check permissions
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102353:	83 ec 04             	sub    $0x4,%esp
f0102356:	6a 00                	push   $0x0
f0102358:	53                   	push   %ebx
f0102359:	57                   	push   %edi
f010235a:	e8 0a f0 ff ff       	call   f0101369 <pgdir_walk>
f010235f:	83 c4 10             	add    $0x10,%esp
f0102362:	f6 00 1a             	testb  $0x1a,(%eax)
f0102365:	0f 84 6a 08 00 00    	je     f0102bd5 <mem_init+0x1563>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f010236b:	83 ec 04             	sub    $0x4,%esp
f010236e:	6a 00                	push   $0x0
f0102370:	53                   	push   %ebx
f0102371:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0102377:	e8 ed ef ff ff       	call   f0101369 <pgdir_walk>
f010237c:	83 c4 10             	add    $0x10,%esp
f010237f:	f6 00 04             	testb  $0x4,(%eax)
f0102382:	0f 85 66 08 00 00    	jne    f0102bee <mem_init+0x157c>
	// clear the mappings
	*pgdir_walk(kern_pgdir, (void*) mm1, 0) = 0;
f0102388:	83 ec 04             	sub    $0x4,%esp
f010238b:	6a 00                	push   $0x0
f010238d:	53                   	push   %ebx
f010238e:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0102394:	e8 d0 ef ff ff       	call   f0101369 <pgdir_walk>
f0102399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm1 + PGSIZE, 0) = 0;
f010239f:	83 c4 0c             	add    $0xc,%esp
f01023a2:	6a 00                	push   $0x0
f01023a4:	ff 75 d4             	pushl  -0x2c(%ebp)
f01023a7:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f01023ad:	e8 b7 ef ff ff       	call   f0101369 <pgdir_walk>
f01023b2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	*pgdir_walk(kern_pgdir, (void*) mm2, 0) = 0;
f01023b8:	83 c4 0c             	add    $0xc,%esp
f01023bb:	6a 00                	push   $0x0
f01023bd:	56                   	push   %esi
f01023be:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f01023c4:	e8 a0 ef ff ff       	call   f0101369 <pgdir_walk>
f01023c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	cprintf("check_page() succeeded!\n");
f01023cf:	c7 04 24 d5 8a 10 f0 	movl   $0xf0108ad5,(%esp)
f01023d6:	e8 c8 18 00 00       	call   f0103ca3 <cprintf>
	boot_map_region(kern_pgdir, UPAGES, PTSIZE, PADDR(pages), PTE_U);
f01023db:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
	if ((uint32_t)kva < KERNBASE)
f01023e0:	83 c4 10             	add    $0x10,%esp
f01023e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01023e8:	0f 86 19 08 00 00    	jbe    f0102c07 <mem_init+0x1595>
f01023ee:	83 ec 08             	sub    $0x8,%esp
f01023f1:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f01023f3:	05 00 00 00 10       	add    $0x10000000,%eax
f01023f8:	50                   	push   %eax
f01023f9:	b9 00 00 40 00       	mov    $0x400000,%ecx
f01023fe:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0102403:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0102408:	e8 3a f0 ff ff       	call   f0101447 <boot_map_region>
	boot_map_region(kern_pgdir, UENVS, NENV * sizeof(struct Env), PADDR(envs), PTE_U);
f010240d:	a1 44 62 2c f0       	mov    0xf02c6244,%eax
	if ((uint32_t)kva < KERNBASE)
f0102412:	83 c4 10             	add    $0x10,%esp
f0102415:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010241a:	0f 86 fc 07 00 00    	jbe    f0102c1c <mem_init+0x15aa>
f0102420:	83 ec 08             	sub    $0x8,%esp
f0102423:	6a 04                	push   $0x4
	return (physaddr_t)kva - KERNBASE;
f0102425:	05 00 00 00 10       	add    $0x10000000,%eax
f010242a:	50                   	push   %eax
f010242b:	b9 00 f0 01 00       	mov    $0x1f000,%ecx
f0102430:	ba 00 00 c0 ee       	mov    $0xeec00000,%edx
f0102435:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f010243a:	e8 08 f0 ff ff       	call   f0101447 <boot_map_region>
	if ((uint32_t)kva < KERNBASE)
f010243f:	83 c4 10             	add    $0x10,%esp
f0102442:	b8 00 00 12 f0       	mov    $0xf0120000,%eax
f0102447:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010244c:	0f 86 df 07 00 00    	jbe    f0102c31 <mem_init+0x15bf>
	boot_map_region(kern_pgdir, KSTACKTOP-KSTKSIZE, ROUNDUP(KSTKSIZE, PGSIZE), PADDR(bootstack), PTE_W);
f0102452:	83 ec 08             	sub    $0x8,%esp
f0102455:	6a 02                	push   $0x2
f0102457:	68 00 00 12 00       	push   $0x120000
f010245c:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0102461:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0102466:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f010246b:	e8 d7 ef ff ff       	call   f0101447 <boot_map_region>
	boot_map_region(kern_pgdir, KERNBASE, 0x100000000 - KERNBASE, PADDR((void*)KERNBASE), PTE_W);
f0102470:	83 c4 08             	add    $0x8,%esp
f0102473:	6a 02                	push   $0x2
f0102475:	6a 00                	push   $0x0
f0102477:	b9 00 00 00 10       	mov    $0x10000000,%ecx
f010247c:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0102481:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f0102486:	e8 bc ef ff ff       	call   f0101447 <boot_map_region>
f010248b:	be 00 90 30 f0       	mov    $0xf0309000,%esi
f0102490:	83 c4 10             	add    $0x10,%esp
f0102493:	bf 00 90 2c f0       	mov    $0xf02c9000,%edi
f0102498:	bb 00 80 ff ef       	mov    $0xefff8000,%ebx
f010249d:	81 ff ff ff ff ef    	cmp    $0xefffffff,%edi
f01024a3:	0f 86 9d 07 00 00    	jbe    f0102c46 <mem_init+0x15d4>
		boot_map_region(kern_pgdir, KSTACKTOP - KSTKSIZE - i * (KSTKGAP + KSTKSIZE),
f01024a9:	83 ec 08             	sub    $0x8,%esp
f01024ac:	6a 02                	push   $0x2
f01024ae:	8d 87 00 00 00 10    	lea    0x10000000(%edi),%eax
f01024b4:	50                   	push   %eax
f01024b5:	b9 00 80 00 00       	mov    $0x8000,%ecx
f01024ba:	89 da                	mov    %ebx,%edx
f01024bc:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
f01024c1:	e8 81 ef ff ff       	call   f0101447 <boot_map_region>
f01024c6:	81 c7 00 80 00 00    	add    $0x8000,%edi
f01024cc:	81 eb 00 00 01 00    	sub    $0x10000,%ebx
	for (int i = 0; i < NCPU; i++) {
f01024d2:	83 c4 10             	add    $0x10,%esp
f01024d5:	39 f7                	cmp    %esi,%edi
f01024d7:	75 c4                	jne    f010249d <mem_init+0xe2b>
f01024d9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
	pgdir = kern_pgdir;
f01024dc:	8b 3d cc 74 2c f0    	mov    0xf02c74cc,%edi
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f01024e2:	a1 c8 74 2c f0       	mov    0xf02c74c8,%eax
f01024e7:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01024ea:	8d 04 c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%eax
f01024f1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01024f6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f01024f9:	8b 35 d0 74 2c f0    	mov    0xf02c74d0,%esi
f01024ff:	89 75 d0             	mov    %esi,-0x30(%ebp)
	for (i = 0; i < n; i += PGSIZE)
f0102502:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102507:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
f010250a:	0f 86 79 07 00 00    	jbe    f0102c89 <mem_init+0x1617>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102510:	8d 93 00 00 00 ef    	lea    -0x11000000(%ebx),%edx
f0102516:	89 f8                	mov    %edi,%eax
f0102518:	e8 96 e7 ff ff       	call   f0100cb3 <check_va2pa>
f010251d:	81 7d d0 ff ff ff ef 	cmpl   $0xefffffff,-0x30(%ebp)
f0102524:	0f 86 31 07 00 00    	jbe    f0102c5b <mem_init+0x15e9>
f010252a:	8d 94 1e 00 00 00 10 	lea    0x10000000(%esi,%ebx,1),%edx
f0102531:	39 d0                	cmp    %edx,%eax
f0102533:	0f 85 37 07 00 00    	jne    f0102c70 <mem_init+0x15fe>
	for (i = 0; i < n; i += PGSIZE)
f0102539:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f010253f:	eb c6                	jmp    f0102507 <mem_init+0xe95>
	assert(nfree == 0);
f0102541:	68 ec 89 10 f0       	push   $0xf01089ec
f0102546:	68 31 78 10 f0       	push   $0xf0107831
f010254b:	68 88 03 00 00       	push   $0x388
f0102550:	68 05 88 10 f0       	push   $0xf0108805
f0102555:	e8 e9 da ff ff       	call   f0100043 <_panic>
	assert((pp0 = page_alloc(0)));
f010255a:	68 fa 88 10 f0       	push   $0xf01088fa
f010255f:	68 31 78 10 f0       	push   $0xf0107831
f0102564:	68 f6 03 00 00       	push   $0x3f6
f0102569:	68 05 88 10 f0       	push   $0xf0108805
f010256e:	e8 d0 da ff ff       	call   f0100043 <_panic>
	assert((pp1 = page_alloc(0)));
f0102573:	68 10 89 10 f0       	push   $0xf0108910
f0102578:	68 31 78 10 f0       	push   $0xf0107831
f010257d:	68 f7 03 00 00       	push   $0x3f7
f0102582:	68 05 88 10 f0       	push   $0xf0108805
f0102587:	e8 b7 da ff ff       	call   f0100043 <_panic>
	assert((pp2 = page_alloc(0)));
f010258c:	68 26 89 10 f0       	push   $0xf0108926
f0102591:	68 31 78 10 f0       	push   $0xf0107831
f0102596:	68 f8 03 00 00       	push   $0x3f8
f010259b:	68 05 88 10 f0       	push   $0xf0108805
f01025a0:	e8 9e da ff ff       	call   f0100043 <_panic>
	assert(pp1 && pp1 != pp0);
f01025a5:	68 3c 89 10 f0       	push   $0xf010893c
f01025aa:	68 31 78 10 f0       	push   $0xf0107831
f01025af:	68 fb 03 00 00       	push   $0x3fb
f01025b4:	68 05 88 10 f0       	push   $0xf0108805
f01025b9:	e8 85 da ff ff       	call   f0100043 <_panic>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01025be:	68 f8 7f 10 f0       	push   $0xf0107ff8
f01025c3:	68 31 78 10 f0       	push   $0xf0107831
f01025c8:	68 fc 03 00 00       	push   $0x3fc
f01025cd:	68 05 88 10 f0       	push   $0xf0108805
f01025d2:	e8 6c da ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f01025d7:	68 a5 89 10 f0       	push   $0xf01089a5
f01025dc:	68 31 78 10 f0       	push   $0xf0107831
f01025e1:	68 03 04 00 00       	push   $0x403
f01025e6:	68 05 88 10 f0       	push   $0xf0108805
f01025eb:	e8 53 da ff ff       	call   f0100043 <_panic>
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f01025f0:	68 38 80 10 f0       	push   $0xf0108038
f01025f5:	68 31 78 10 f0       	push   $0xf0107831
f01025fa:	68 06 04 00 00       	push   $0x406
f01025ff:	68 05 88 10 f0       	push   $0xf0108805
f0102604:	e8 3a da ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102609:	68 70 80 10 f0       	push   $0xf0108070
f010260e:	68 31 78 10 f0       	push   $0xf0107831
f0102613:	68 09 04 00 00       	push   $0x409
f0102618:	68 05 88 10 f0       	push   $0xf0108805
f010261d:	e8 21 da ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102622:	68 a0 80 10 f0       	push   $0xf01080a0
f0102627:	68 31 78 10 f0       	push   $0xf0107831
f010262c:	68 0f 04 00 00       	push   $0x40f
f0102631:	68 05 88 10 f0       	push   $0xf0108805
f0102636:	e8 08 da ff ff       	call   f0100043 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010263b:	68 d0 80 10 f0       	push   $0xf01080d0
f0102640:	68 31 78 10 f0       	push   $0xf0107831
f0102645:	68 10 04 00 00       	push   $0x410
f010264a:	68 05 88 10 f0       	push   $0xf0108805
f010264f:	e8 ef d9 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102654:	68 f8 80 10 f0       	push   $0xf01080f8
f0102659:	68 31 78 10 f0       	push   $0xf0107831
f010265e:	68 11 04 00 00       	push   $0x411
f0102663:	68 05 88 10 f0       	push   $0xf0108805
f0102668:	e8 d6 d9 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 1);
f010266d:	68 f7 89 10 f0       	push   $0xf01089f7
f0102672:	68 31 78 10 f0       	push   $0xf0107831
f0102677:	68 12 04 00 00       	push   $0x412
f010267c:	68 05 88 10 f0       	push   $0xf0108805
f0102681:	e8 bd d9 ff ff       	call   f0100043 <_panic>
	assert(pp0->pp_ref == 1);
f0102686:	68 08 8a 10 f0       	push   $0xf0108a08
f010268b:	68 31 78 10 f0       	push   $0xf0107831
f0102690:	68 13 04 00 00       	push   $0x413
f0102695:	68 05 88 10 f0       	push   $0xf0108805
f010269a:	e8 a4 d9 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f010269f:	68 28 81 10 f0       	push   $0xf0108128
f01026a4:	68 31 78 10 f0       	push   $0xf0107831
f01026a9:	68 17 04 00 00       	push   $0x417
f01026ae:	68 05 88 10 f0       	push   $0xf0108805
f01026b3:	e8 8b d9 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01026b8:	68 64 81 10 f0       	push   $0xf0108164
f01026bd:	68 31 78 10 f0       	push   $0xf0107831
f01026c2:	68 18 04 00 00       	push   $0x418
f01026c7:	68 05 88 10 f0       	push   $0xf0108805
f01026cc:	e8 72 d9 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 1);
f01026d1:	68 19 8a 10 f0       	push   $0xf0108a19
f01026d6:	68 31 78 10 f0       	push   $0xf0107831
f01026db:	68 19 04 00 00       	push   $0x419
f01026e0:	68 05 88 10 f0       	push   $0xf0108805
f01026e5:	e8 59 d9 ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f01026ea:	68 a5 89 10 f0       	push   $0xf01089a5
f01026ef:	68 31 78 10 f0       	push   $0xf0107831
f01026f4:	68 1c 04 00 00       	push   $0x41c
f01026f9:	68 05 88 10 f0       	push   $0xf0108805
f01026fe:	e8 40 d9 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102703:	68 28 81 10 f0       	push   $0xf0108128
f0102708:	68 31 78 10 f0       	push   $0xf0107831
f010270d:	68 1e 04 00 00       	push   $0x41e
f0102712:	68 05 88 10 f0       	push   $0xf0108805
f0102717:	e8 27 d9 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f010271c:	68 64 81 10 f0       	push   $0xf0108164
f0102721:	68 31 78 10 f0       	push   $0xf0107831
f0102726:	68 1f 04 00 00       	push   $0x41f
f010272b:	68 05 88 10 f0       	push   $0xf0108805
f0102730:	e8 0e d9 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 1);
f0102735:	68 19 8a 10 f0       	push   $0xf0108a19
f010273a:	68 31 78 10 f0       	push   $0xf0107831
f010273f:	68 20 04 00 00       	push   $0x420
f0102744:	68 05 88 10 f0       	push   $0xf0108805
f0102749:	e8 f5 d8 ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f010274e:	68 a5 89 10 f0       	push   $0xf01089a5
f0102753:	68 31 78 10 f0       	push   $0xf0107831
f0102758:	68 24 04 00 00       	push   $0x424
f010275d:	68 05 88 10 f0       	push   $0xf0108805
f0102762:	e8 dc d8 ff ff       	call   f0100043 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102767:	50                   	push   %eax
f0102768:	68 c8 77 10 f0       	push   $0xf01077c8
f010276d:	68 27 04 00 00       	push   $0x427
f0102772:	68 05 88 10 f0       	push   $0xf0108805
f0102777:	e8 c7 d8 ff ff       	call   f0100043 <_panic>
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f010277c:	68 94 81 10 f0       	push   $0xf0108194
f0102781:	68 31 78 10 f0       	push   $0xf0107831
f0102786:	68 28 04 00 00       	push   $0x428
f010278b:	68 05 88 10 f0       	push   $0xf0108805
f0102790:	e8 ae d8 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102795:	68 d4 81 10 f0       	push   $0xf01081d4
f010279a:	68 31 78 10 f0       	push   $0xf0107831
f010279f:	68 2b 04 00 00       	push   $0x42b
f01027a4:	68 05 88 10 f0       	push   $0xf0108805
f01027a9:	e8 95 d8 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f01027ae:	68 64 81 10 f0       	push   $0xf0108164
f01027b3:	68 31 78 10 f0       	push   $0xf0107831
f01027b8:	68 2c 04 00 00       	push   $0x42c
f01027bd:	68 05 88 10 f0       	push   $0xf0108805
f01027c2:	e8 7c d8 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 1);
f01027c7:	68 19 8a 10 f0       	push   $0xf0108a19
f01027cc:	68 31 78 10 f0       	push   $0xf0107831
f01027d1:	68 2d 04 00 00       	push   $0x42d
f01027d6:	68 05 88 10 f0       	push   $0xf0108805
f01027db:	e8 63 d8 ff ff       	call   f0100043 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f01027e0:	68 14 82 10 f0       	push   $0xf0108214
f01027e5:	68 31 78 10 f0       	push   $0xf0107831
f01027ea:	68 2e 04 00 00       	push   $0x42e
f01027ef:	68 05 88 10 f0       	push   $0xf0108805
f01027f4:	e8 4a d8 ff ff       	call   f0100043 <_panic>
	assert(kern_pgdir[0] & PTE_U);
f01027f9:	68 2a 8a 10 f0       	push   $0xf0108a2a
f01027fe:	68 31 78 10 f0       	push   $0xf0107831
f0102803:	68 2f 04 00 00       	push   $0x42f
f0102808:	68 05 88 10 f0       	push   $0xf0108805
f010280d:	e8 31 d8 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102812:	68 28 81 10 f0       	push   $0xf0108128
f0102817:	68 31 78 10 f0       	push   $0xf0107831
f010281c:	68 32 04 00 00       	push   $0x432
f0102821:	68 05 88 10 f0       	push   $0xf0108805
f0102826:	e8 18 d8 ff ff       	call   f0100043 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f010282b:	68 48 82 10 f0       	push   $0xf0108248
f0102830:	68 31 78 10 f0       	push   $0xf0107831
f0102835:	68 33 04 00 00       	push   $0x433
f010283a:	68 05 88 10 f0       	push   $0xf0108805
f010283f:	e8 ff d7 ff ff       	call   f0100043 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0102844:	68 7c 82 10 f0       	push   $0xf010827c
f0102849:	68 31 78 10 f0       	push   $0xf0107831
f010284e:	68 34 04 00 00       	push   $0x434
f0102853:	68 05 88 10 f0       	push   $0xf0108805
f0102858:	e8 e6 d7 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010285d:	68 b4 82 10 f0       	push   $0xf01082b4
f0102862:	68 31 78 10 f0       	push   $0xf0107831
f0102867:	68 37 04 00 00       	push   $0x437
f010286c:	68 05 88 10 f0       	push   $0xf0108805
f0102871:	e8 cd d7 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f0102876:	68 ec 82 10 f0       	push   $0xf01082ec
f010287b:	68 31 78 10 f0       	push   $0xf0107831
f0102880:	68 3a 04 00 00       	push   $0x43a
f0102885:	68 05 88 10 f0       	push   $0xf0108805
f010288a:	e8 b4 d7 ff ff       	call   f0100043 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f010288f:	68 7c 82 10 f0       	push   $0xf010827c
f0102894:	68 31 78 10 f0       	push   $0xf0107831
f0102899:	68 3b 04 00 00       	push   $0x43b
f010289e:	68 05 88 10 f0       	push   $0xf0108805
f01028a3:	e8 9b d7 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01028a8:	68 28 83 10 f0       	push   $0xf0108328
f01028ad:	68 31 78 10 f0       	push   $0xf0107831
f01028b2:	68 3e 04 00 00       	push   $0x43e
f01028b7:	68 05 88 10 f0       	push   $0xf0108805
f01028bc:	e8 82 d7 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01028c1:	68 54 83 10 f0       	push   $0xf0108354
f01028c6:	68 31 78 10 f0       	push   $0xf0107831
f01028cb:	68 3f 04 00 00       	push   $0x43f
f01028d0:	68 05 88 10 f0       	push   $0xf0108805
f01028d5:	e8 69 d7 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 2);
f01028da:	68 40 8a 10 f0       	push   $0xf0108a40
f01028df:	68 31 78 10 f0       	push   $0xf0107831
f01028e4:	68 41 04 00 00       	push   $0x441
f01028e9:	68 05 88 10 f0       	push   $0xf0108805
f01028ee:	e8 50 d7 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 0);
f01028f3:	68 51 8a 10 f0       	push   $0xf0108a51
f01028f8:	68 31 78 10 f0       	push   $0xf0107831
f01028fd:	68 43 04 00 00       	push   $0x443
f0102902:	68 05 88 10 f0       	push   $0xf0108805
f0102907:	e8 37 d7 ff ff       	call   f0100043 <_panic>
	assert((pp = page_alloc(0)) && pp == pp2);
f010290c:	68 84 83 10 f0       	push   $0xf0108384
f0102911:	68 31 78 10 f0       	push   $0xf0107831
f0102916:	68 46 04 00 00       	push   $0x446
f010291b:	68 05 88 10 f0       	push   $0xf0108805
f0102920:	e8 1e d7 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0102925:	68 a8 83 10 f0       	push   $0xf01083a8
f010292a:	68 31 78 10 f0       	push   $0xf0107831
f010292f:	68 4a 04 00 00       	push   $0x44a
f0102934:	68 05 88 10 f0       	push   $0xf0108805
f0102939:	e8 05 d7 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010293e:	68 54 83 10 f0       	push   $0xf0108354
f0102943:	68 31 78 10 f0       	push   $0xf0107831
f0102948:	68 4b 04 00 00       	push   $0x44b
f010294d:	68 05 88 10 f0       	push   $0xf0108805
f0102952:	e8 ec d6 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 1);
f0102957:	68 f7 89 10 f0       	push   $0xf01089f7
f010295c:	68 31 78 10 f0       	push   $0xf0107831
f0102961:	68 4c 04 00 00       	push   $0x44c
f0102966:	68 05 88 10 f0       	push   $0xf0108805
f010296b:	e8 d3 d6 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 0);
f0102970:	68 51 8a 10 f0       	push   $0xf0108a51
f0102975:	68 31 78 10 f0       	push   $0xf0107831
f010297a:	68 4d 04 00 00       	push   $0x44d
f010297f:	68 05 88 10 f0       	push   $0xf0108805
f0102984:	e8 ba d6 ff ff       	call   f0100043 <_panic>
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0102989:	68 cc 83 10 f0       	push   $0xf01083cc
f010298e:	68 31 78 10 f0       	push   $0xf0107831
f0102993:	68 50 04 00 00       	push   $0x450
f0102998:	68 05 88 10 f0       	push   $0xf0108805
f010299d:	e8 a1 d6 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref);
f01029a2:	68 62 8a 10 f0       	push   $0xf0108a62
f01029a7:	68 31 78 10 f0       	push   $0xf0107831
f01029ac:	68 51 04 00 00       	push   $0x451
f01029b1:	68 05 88 10 f0       	push   $0xf0108805
f01029b6:	e8 88 d6 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_link == NULL);
f01029bb:	68 6e 8a 10 f0       	push   $0xf0108a6e
f01029c0:	68 31 78 10 f0       	push   $0xf0107831
f01029c5:	68 52 04 00 00       	push   $0x452
f01029ca:	68 05 88 10 f0       	push   $0xf0108805
f01029cf:	e8 6f d6 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f01029d4:	68 a8 83 10 f0       	push   $0xf01083a8
f01029d9:	68 31 78 10 f0       	push   $0xf0107831
f01029de:	68 56 04 00 00       	push   $0x456
f01029e3:	68 05 88 10 f0       	push   $0xf0108805
f01029e8:	e8 56 d6 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f01029ed:	68 04 84 10 f0       	push   $0xf0108404
f01029f2:	68 31 78 10 f0       	push   $0xf0107831
f01029f7:	68 57 04 00 00       	push   $0x457
f01029fc:	68 05 88 10 f0       	push   $0xf0108805
f0102a01:	e8 3d d6 ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 0);
f0102a06:	68 83 8a 10 f0       	push   $0xf0108a83
f0102a0b:	68 31 78 10 f0       	push   $0xf0107831
f0102a10:	68 58 04 00 00       	push   $0x458
f0102a15:	68 05 88 10 f0       	push   $0xf0108805
f0102a1a:	e8 24 d6 ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 0);
f0102a1f:	68 51 8a 10 f0       	push   $0xf0108a51
f0102a24:	68 31 78 10 f0       	push   $0xf0107831
f0102a29:	68 59 04 00 00       	push   $0x459
f0102a2e:	68 05 88 10 f0       	push   $0xf0108805
f0102a33:	e8 0b d6 ff ff       	call   f0100043 <_panic>
	assert((pp = page_alloc(0)) && pp == pp1);
f0102a38:	68 2c 84 10 f0       	push   $0xf010842c
f0102a3d:	68 31 78 10 f0       	push   $0xf0107831
f0102a42:	68 5c 04 00 00       	push   $0x45c
f0102a47:	68 05 88 10 f0       	push   $0xf0108805
f0102a4c:	e8 f2 d5 ff ff       	call   f0100043 <_panic>
	assert(!page_alloc(0));
f0102a51:	68 a5 89 10 f0       	push   $0xf01089a5
f0102a56:	68 31 78 10 f0       	push   $0xf0107831
f0102a5b:	68 5f 04 00 00       	push   $0x45f
f0102a60:	68 05 88 10 f0       	push   $0xf0108805
f0102a65:	e8 d9 d5 ff ff       	call   f0100043 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102a6a:	68 d0 80 10 f0       	push   $0xf01080d0
f0102a6f:	68 31 78 10 f0       	push   $0xf0107831
f0102a74:	68 62 04 00 00       	push   $0x462
f0102a79:	68 05 88 10 f0       	push   $0xf0108805
f0102a7e:	e8 c0 d5 ff ff       	call   f0100043 <_panic>
	assert(pp0->pp_ref == 1);
f0102a83:	68 08 8a 10 f0       	push   $0xf0108a08
f0102a88:	68 31 78 10 f0       	push   $0xf0107831
f0102a8d:	68 64 04 00 00       	push   $0x464
f0102a92:	68 05 88 10 f0       	push   $0xf0108805
f0102a97:	e8 a7 d5 ff ff       	call   f0100043 <_panic>
f0102a9c:	52                   	push   %edx
f0102a9d:	68 c8 77 10 f0       	push   $0xf01077c8
f0102aa2:	68 6b 04 00 00       	push   $0x46b
f0102aa7:	68 05 88 10 f0       	push   $0xf0108805
f0102aac:	e8 92 d5 ff ff       	call   f0100043 <_panic>
	assert(ptep == ptep1 + PTX(va));
f0102ab1:	68 94 8a 10 f0       	push   $0xf0108a94
f0102ab6:	68 31 78 10 f0       	push   $0xf0107831
f0102abb:	68 6c 04 00 00       	push   $0x46c
f0102ac0:	68 05 88 10 f0       	push   $0xf0108805
f0102ac5:	e8 79 d5 ff ff       	call   f0100043 <_panic>
f0102aca:	50                   	push   %eax
f0102acb:	68 c8 77 10 f0       	push   $0xf01077c8
f0102ad0:	68 8e 00 00 00       	push   $0x8e
f0102ad5:	68 11 88 10 f0       	push   $0xf0108811
f0102ada:	e8 64 d5 ff ff       	call   f0100043 <_panic>
f0102adf:	52                   	push   %edx
f0102ae0:	68 c8 77 10 f0       	push   $0xf01077c8
f0102ae5:	68 8e 00 00 00       	push   $0x8e
f0102aea:	68 11 88 10 f0       	push   $0xf0108811
f0102aef:	e8 4f d5 ff ff       	call   f0100043 <_panic>
		assert((ptep[i] & PTE_P) == 0);
f0102af4:	68 ac 8a 10 f0       	push   $0xf0108aac
f0102af9:	68 31 78 10 f0       	push   $0xf0107831
f0102afe:	68 76 04 00 00       	push   $0x476
f0102b03:	68 05 88 10 f0       	push   $0xf0108805
f0102b08:	e8 36 d5 ff ff       	call   f0100043 <_panic>
	assert(mm1 >= MMIOBASE && mm1 + 8096 < MMIOLIM);
f0102b0d:	68 50 84 10 f0       	push   $0xf0108450
f0102b12:	68 31 78 10 f0       	push   $0xf0107831
f0102b17:	68 86 04 00 00       	push   $0x486
f0102b1c:	68 05 88 10 f0       	push   $0xf0108805
f0102b21:	e8 1d d5 ff ff       	call   f0100043 <_panic>
	assert(mm2 >= MMIOBASE && mm2 + 8096 < MMIOLIM);
f0102b26:	68 78 84 10 f0       	push   $0xf0108478
f0102b2b:	68 31 78 10 f0       	push   $0xf0107831
f0102b30:	68 87 04 00 00       	push   $0x487
f0102b35:	68 05 88 10 f0       	push   $0xf0108805
f0102b3a:	e8 04 d5 ff ff       	call   f0100043 <_panic>
	assert(mm1 % PGSIZE == 0 && mm2 % PGSIZE == 0);
f0102b3f:	68 a0 84 10 f0       	push   $0xf01084a0
f0102b44:	68 31 78 10 f0       	push   $0xf0107831
f0102b49:	68 89 04 00 00       	push   $0x489
f0102b4e:	68 05 88 10 f0       	push   $0xf0108805
f0102b53:	e8 eb d4 ff ff       	call   f0100043 <_panic>
	assert(mm1 + 8096 <= mm2);
f0102b58:	68 c3 8a 10 f0       	push   $0xf0108ac3
f0102b5d:	68 31 78 10 f0       	push   $0xf0107831
f0102b62:	68 8b 04 00 00       	push   $0x48b
f0102b67:	68 05 88 10 f0       	push   $0xf0108805
f0102b6c:	e8 d2 d4 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, mm1) == 0);
f0102b71:	68 c8 84 10 f0       	push   $0xf01084c8
f0102b76:	68 31 78 10 f0       	push   $0xf0107831
f0102b7b:	68 8d 04 00 00       	push   $0x48d
f0102b80:	68 05 88 10 f0       	push   $0xf0108805
f0102b85:	e8 b9 d4 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, mm1+PGSIZE) == PGSIZE);
f0102b8a:	68 ec 84 10 f0       	push   $0xf01084ec
f0102b8f:	68 31 78 10 f0       	push   $0xf0107831
f0102b94:	68 8e 04 00 00       	push   $0x48e
f0102b99:	68 05 88 10 f0       	push   $0xf0108805
f0102b9e:	e8 a0 d4 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, mm2) == 0);
f0102ba3:	68 1c 85 10 f0       	push   $0xf010851c
f0102ba8:	68 31 78 10 f0       	push   $0xf0107831
f0102bad:	68 8f 04 00 00       	push   $0x48f
f0102bb2:	68 05 88 10 f0       	push   $0xf0108805
f0102bb7:	e8 87 d4 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(kern_pgdir, mm2+PGSIZE) == ~0);
f0102bbc:	68 40 85 10 f0       	push   $0xf0108540
f0102bc1:	68 31 78 10 f0       	push   $0xf0107831
f0102bc6:	68 90 04 00 00       	push   $0x490
f0102bcb:	68 05 88 10 f0       	push   $0xf0108805
f0102bd0:	e8 6e d4 ff ff       	call   f0100043 <_panic>
	assert(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & (PTE_W|PTE_PWT|PTE_PCD));
f0102bd5:	68 6c 85 10 f0       	push   $0xf010856c
f0102bda:	68 31 78 10 f0       	push   $0xf0107831
f0102bdf:	68 92 04 00 00       	push   $0x492
f0102be4:	68 05 88 10 f0       	push   $0xf0108805
f0102be9:	e8 55 d4 ff ff       	call   f0100043 <_panic>
	assert(!(*pgdir_walk(kern_pgdir, (void*) mm1, 0) & PTE_U));
f0102bee:	68 b0 85 10 f0       	push   $0xf01085b0
f0102bf3:	68 31 78 10 f0       	push   $0xf0107831
f0102bf8:	68 93 04 00 00       	push   $0x493
f0102bfd:	68 05 88 10 f0       	push   $0xf0108805
f0102c02:	e8 3c d4 ff ff       	call   f0100043 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102c07:	50                   	push   %eax
f0102c08:	68 ec 77 10 f0       	push   $0xf01077ec
f0102c0d:	68 bc 00 00 00       	push   $0xbc
f0102c12:	68 05 88 10 f0       	push   $0xf0108805
f0102c17:	e8 27 d4 ff ff       	call   f0100043 <_panic>
f0102c1c:	50                   	push   %eax
f0102c1d:	68 ec 77 10 f0       	push   $0xf01077ec
f0102c22:	68 c4 00 00 00       	push   $0xc4
f0102c27:	68 05 88 10 f0       	push   $0xf0108805
f0102c2c:	e8 12 d4 ff ff       	call   f0100043 <_panic>
f0102c31:	50                   	push   %eax
f0102c32:	68 ec 77 10 f0       	push   $0xf01077ec
f0102c37:	68 d0 00 00 00       	push   $0xd0
f0102c3c:	68 05 88 10 f0       	push   $0xf0108805
f0102c41:	e8 fd d3 ff ff       	call   f0100043 <_panic>
f0102c46:	57                   	push   %edi
f0102c47:	68 ec 77 10 f0       	push   $0xf01077ec
f0102c4c:	68 11 01 00 00       	push   $0x111
f0102c51:	68 05 88 10 f0       	push   $0xf0108805
f0102c56:	e8 e8 d3 ff ff       	call   f0100043 <_panic>
f0102c5b:	56                   	push   %esi
f0102c5c:	68 ec 77 10 f0       	push   $0xf01077ec
f0102c61:	68 a0 03 00 00       	push   $0x3a0
f0102c66:	68 05 88 10 f0       	push   $0xf0108805
f0102c6b:	e8 d3 d3 ff ff       	call   f0100043 <_panic>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f0102c70:	68 e4 85 10 f0       	push   $0xf01085e4
f0102c75:	68 31 78 10 f0       	push   $0xf0107831
f0102c7a:	68 a0 03 00 00       	push   $0x3a0
f0102c7f:	68 05 88 10 f0       	push   $0xf0108805
f0102c84:	e8 ba d3 ff ff       	call   f0100043 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102c89:	8b 35 44 62 2c f0    	mov    0xf02c6244,%esi
	if ((uint32_t)kva < KERNBASE)
f0102c8f:	89 75 d4             	mov    %esi,-0x2c(%ebp)
f0102c92:	bb 00 00 c0 ee       	mov    $0xeec00000,%ebx
f0102c97:	89 da                	mov    %ebx,%edx
f0102c99:	89 f8                	mov    %edi,%eax
f0102c9b:	e8 13 e0 ff ff       	call   f0100cb3 <check_va2pa>
f0102ca0:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102ca7:	76 26                	jbe    f0102ccf <mem_init+0x165d>
f0102ca9:	8d 94 1e 00 00 40 21 	lea    0x21400000(%esi,%ebx,1),%edx
f0102cb0:	39 d0                	cmp    %edx,%eax
f0102cb2:	75 30                	jne    f0102ce4 <mem_init+0x1672>
f0102cb4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
	for (i = 0; i < n; i += PGSIZE)
f0102cba:	81 fb 00 f0 c1 ee    	cmp    $0xeec1f000,%ebx
f0102cc0:	75 d5                	jne    f0102c97 <mem_init+0x1625>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102cc2:	8b 75 cc             	mov    -0x34(%ebp),%esi
f0102cc5:	c1 e6 0c             	shl    $0xc,%esi
f0102cc8:	bb 00 00 00 00       	mov    $0x0,%ebx
f0102ccd:	eb 34                	jmp    f0102d03 <mem_init+0x1691>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102ccf:	56                   	push   %esi
f0102cd0:	68 ec 77 10 f0       	push   $0xf01077ec
f0102cd5:	68 a5 03 00 00       	push   $0x3a5
f0102cda:	68 05 88 10 f0       	push   $0xf0108805
f0102cdf:	e8 5f d3 ff ff       	call   f0100043 <_panic>
		assert(check_va2pa(pgdir, UENVS + i) == PADDR(envs) + i);
f0102ce4:	68 18 86 10 f0       	push   $0xf0108618
f0102ce9:	68 31 78 10 f0       	push   $0xf0107831
f0102cee:	68 a5 03 00 00       	push   $0x3a5
f0102cf3:	68 05 88 10 f0       	push   $0xf0108805
f0102cf8:	e8 46 d3 ff ff       	call   f0100043 <_panic>
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102cfd:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0102d03:	39 f3                	cmp    %esi,%ebx
f0102d05:	73 2a                	jae    f0102d31 <mem_init+0x16bf>
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f0102d07:	8d 93 00 00 00 f0    	lea    -0x10000000(%ebx),%edx
f0102d0d:	89 f8                	mov    %edi,%eax
f0102d0f:	e8 9f df ff ff       	call   f0100cb3 <check_va2pa>
f0102d14:	39 c3                	cmp    %eax,%ebx
f0102d16:	74 e5                	je     f0102cfd <mem_init+0x168b>
f0102d18:	68 4c 86 10 f0       	push   $0xf010864c
f0102d1d:	68 31 78 10 f0       	push   $0xf0107831
f0102d22:	68 a9 03 00 00       	push   $0x3a9
f0102d27:	68 05 88 10 f0       	push   $0xf0108805
f0102d2c:	e8 12 d3 ff ff       	call   f0100043 <_panic>
f0102d31:	b8 00 90 2c f0       	mov    $0xf02c9000,%eax
f0102d36:	f7 d8                	neg    %eax
f0102d38:	89 45 cc             	mov    %eax,-0x34(%ebp)
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0102d3b:	c7 45 d4 00 90 2c f0 	movl   $0xf02c9000,-0x2c(%ebp)
f0102d42:	c7 45 c8 00 80 ff ef 	movl   $0xefff8000,-0x38(%ebp)
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102d49:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102d4c:	89 45 c0             	mov    %eax,-0x40(%ebp)
f0102d4f:	8d 98 00 00 00 10    	lea    0x10000000(%eax),%ebx
f0102d55:	05 00 80 00 10       	add    $0x10008000,%eax
f0102d5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0102d5d:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0102d60:	8d b0 00 80 ff df    	lea    -0x20008000(%eax),%esi
f0102d66:	8d 14 1e             	lea    (%esi,%ebx,1),%edx
f0102d69:	89 f8                	mov    %edi,%eax
f0102d6b:	e8 43 df ff ff       	call   f0100cb3 <check_va2pa>
	if ((uint32_t)kva < KERNBASE)
f0102d70:	81 7d d4 ff ff ff ef 	cmpl   $0xefffffff,-0x2c(%ebp)
f0102d77:	0f 86 c0 00 00 00    	jbe    f0102e3d <mem_init+0x17cb>
f0102d7d:	39 d8                	cmp    %ebx,%eax
f0102d7f:	0f 85 cf 00 00 00    	jne    f0102e54 <mem_init+0x17e2>
f0102d85:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0102d8b:	3b 5d d0             	cmp    -0x30(%ebp),%ebx
f0102d8e:	75 d6                	jne    f0102d66 <mem_init+0x16f4>
f0102d90:	8b 45 c8             	mov    -0x38(%ebp),%eax
f0102d93:	8d 98 00 80 ff ff    	lea    -0x8000(%eax),%ebx
f0102d99:	89 c6                	mov    %eax,%esi
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102d9b:	89 da                	mov    %ebx,%edx
f0102d9d:	89 f8                	mov    %edi,%eax
f0102d9f:	e8 0f df ff ff       	call   f0100cb3 <check_va2pa>
f0102da4:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102da7:	0f 85 c0 00 00 00    	jne    f0102e6d <mem_init+0x17fb>
f0102dad:	81 c3 00 10 00 00    	add    $0x1000,%ebx
		for (i = 0; i < KSTKGAP; i += PGSIZE)
f0102db3:	39 f3                	cmp    %esi,%ebx
f0102db5:	75 e4                	jne    f0102d9b <mem_init+0x1729>
f0102db7:	81 6d c8 00 00 01 00 	subl   $0x10000,-0x38(%ebp)
f0102dbe:	81 45 d4 00 80 00 00 	addl   $0x8000,-0x2c(%ebp)
f0102dc5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0102dc8:	81 6d cc 00 80 01 00 	subl   $0x18000,-0x34(%ebp)
	for (n = 0; n < NCPU; n++) {
f0102dcf:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
f0102dd2:	0f 85 71 ff ff ff    	jne    f0102d49 <mem_init+0x16d7>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102dd8:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0102ddd:	89 f8                	mov    %edi,%eax
f0102ddf:	e8 cf de ff ff       	call   f0100cb3 <check_va2pa>
f0102de4:	83 f8 ff             	cmp    $0xffffffff,%eax
f0102de7:	0f 85 99 00 00 00    	jne    f0102e86 <mem_init+0x1814>
f0102ded:	b8 00 00 00 00       	mov    $0x0,%eax
			if (i >= PDX(KERNBASE)) {
f0102df2:	3d bf 03 00 00       	cmp    $0x3bf,%eax
f0102df7:	0f 87 a2 00 00 00    	ja     f0102e9f <mem_init+0x182d>
				assert(pgdir[i] == 0);
f0102dfd:	83 3c 87 00          	cmpl   $0x0,(%edi,%eax,4)
f0102e01:	0f 85 db 00 00 00    	jne    f0102ee2 <mem_init+0x1870>
	for (i = 0; i < NPDENTRIES; i++) {
f0102e07:	40                   	inc    %eax
f0102e08:	3d ff 03 00 00       	cmp    $0x3ff,%eax
f0102e0d:	0f 87 e8 00 00 00    	ja     f0102efb <mem_init+0x1889>
		switch (i) {
f0102e13:	8d 90 45 fc ff ff    	lea    -0x3bb(%eax),%edx
f0102e19:	83 fa 04             	cmp    $0x4,%edx
f0102e1c:	77 d4                	ja     f0102df2 <mem_init+0x1780>
			assert(pgdir[i] & PTE_P);
f0102e1e:	f6 04 87 01          	testb  $0x1,(%edi,%eax,4)
f0102e22:	75 e3                	jne    f0102e07 <mem_init+0x1795>
f0102e24:	68 ee 8a 10 f0       	push   $0xf0108aee
f0102e29:	68 31 78 10 f0       	push   $0xf0107831
f0102e2e:	68 c6 03 00 00       	push   $0x3c6
f0102e33:	68 05 88 10 f0       	push   $0xf0108805
f0102e38:	e8 06 d2 ff ff       	call   f0100043 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0102e3d:	ff 75 c0             	pushl  -0x40(%ebp)
f0102e40:	68 ec 77 10 f0       	push   $0xf01077ec
f0102e45:	68 b3 03 00 00       	push   $0x3b3
f0102e4a:	68 05 88 10 f0       	push   $0xf0108805
f0102e4f:	e8 ef d1 ff ff       	call   f0100043 <_panic>
			assert(check_va2pa(pgdir, base + KSTKGAP + i)
f0102e54:	68 74 86 10 f0       	push   $0xf0108674
f0102e59:	68 31 78 10 f0       	push   $0xf0107831
f0102e5e:	68 b3 03 00 00       	push   $0x3b3
f0102e63:	68 05 88 10 f0       	push   $0xf0108805
f0102e68:	e8 d6 d1 ff ff       	call   f0100043 <_panic>
			assert(check_va2pa(pgdir, base + i) == ~0);
f0102e6d:	68 bc 86 10 f0       	push   $0xf01086bc
f0102e72:	68 31 78 10 f0       	push   $0xf0107831
f0102e77:	68 b5 03 00 00       	push   $0x3b5
f0102e7c:	68 05 88 10 f0       	push   $0xf0108805
f0102e81:	e8 bd d1 ff ff       	call   f0100043 <_panic>
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0102e86:	68 e0 86 10 f0       	push   $0xf01086e0
f0102e8b:	68 31 78 10 f0       	push   $0xf0107831
f0102e90:	68 bb 03 00 00       	push   $0x3bb
f0102e95:	68 05 88 10 f0       	push   $0xf0108805
f0102e9a:	e8 a4 d1 ff ff       	call   f0100043 <_panic>
				assert(pgdir[i] & PTE_P);
f0102e9f:	8b 14 87             	mov    (%edi,%eax,4),%edx
f0102ea2:	f6 c2 01             	test   $0x1,%dl
f0102ea5:	74 22                	je     f0102ec9 <mem_init+0x1857>
				assert(pgdir[i] & PTE_W);
f0102ea7:	f6 c2 02             	test   $0x2,%dl
f0102eaa:	0f 85 57 ff ff ff    	jne    f0102e07 <mem_init+0x1795>
f0102eb0:	68 ff 8a 10 f0       	push   $0xf0108aff
f0102eb5:	68 31 78 10 f0       	push   $0xf0107831
f0102eba:	68 cb 03 00 00       	push   $0x3cb
f0102ebf:	68 05 88 10 f0       	push   $0xf0108805
f0102ec4:	e8 7a d1 ff ff       	call   f0100043 <_panic>
				assert(pgdir[i] & PTE_P);
f0102ec9:	68 ee 8a 10 f0       	push   $0xf0108aee
f0102ece:	68 31 78 10 f0       	push   $0xf0107831
f0102ed3:	68 ca 03 00 00       	push   $0x3ca
f0102ed8:	68 05 88 10 f0       	push   $0xf0108805
f0102edd:	e8 61 d1 ff ff       	call   f0100043 <_panic>
				assert(pgdir[i] == 0);
f0102ee2:	68 10 8b 10 f0       	push   $0xf0108b10
f0102ee7:	68 31 78 10 f0       	push   $0xf0107831
f0102eec:	68 cd 03 00 00       	push   $0x3cd
f0102ef1:	68 05 88 10 f0       	push   $0xf0108805
f0102ef6:	e8 48 d1 ff ff       	call   f0100043 <_panic>
	cprintf("check_kern_pgdir() succeeded!\n");
f0102efb:	83 ec 0c             	sub    $0xc,%esp
f0102efe:	68 10 87 10 f0       	push   $0xf0108710
f0102f03:	e8 9b 0d 00 00       	call   f0103ca3 <cprintf>
	lcr3(PADDR(kern_pgdir));
f0102f08:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
	if ((uint32_t)kva < KERNBASE)
f0102f0d:	83 c4 10             	add    $0x10,%esp
f0102f10:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0102f15:	0f 86 fe 01 00 00    	jbe    f0103119 <mem_init+0x1aa7>
	return (physaddr_t)kva - KERNBASE;
f0102f1b:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0102f20:	0f 22 d8             	mov    %eax,%cr3
	check_page_free_list(0);
f0102f23:	b8 00 00 00 00       	mov    $0x0,%eax
f0102f28:	e8 e7 dd ff ff       	call   f0100d14 <check_page_free_list>
	asm volatile("movl %%cr0,%0" : "=r" (val));
f0102f2d:	0f 20 c0             	mov    %cr0,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f0102f30:	83 e0 f3             	and    $0xfffffff3,%eax
f0102f33:	0d 23 00 05 80       	or     $0x80050023,%eax
	asm volatile("movl %0,%%cr0" : : "r" (val));
f0102f38:	0f 22 c0             	mov    %eax,%cr0
	uintptr_t va;
	int i;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102f3b:	83 ec 0c             	sub    $0xc,%esp
f0102f3e:	6a 00                	push   $0x0
f0102f40:	e8 30 e3 ff ff       	call   f0101275 <page_alloc>
f0102f45:	89 c3                	mov    %eax,%ebx
f0102f47:	83 c4 10             	add    $0x10,%esp
f0102f4a:	85 c0                	test   %eax,%eax
f0102f4c:	0f 84 dc 01 00 00    	je     f010312e <mem_init+0x1abc>
	assert((pp1 = page_alloc(0)));
f0102f52:	83 ec 0c             	sub    $0xc,%esp
f0102f55:	6a 00                	push   $0x0
f0102f57:	e8 19 e3 ff ff       	call   f0101275 <page_alloc>
f0102f5c:	89 c7                	mov    %eax,%edi
f0102f5e:	83 c4 10             	add    $0x10,%esp
f0102f61:	85 c0                	test   %eax,%eax
f0102f63:	0f 84 de 01 00 00    	je     f0103147 <mem_init+0x1ad5>
	assert((pp2 = page_alloc(0)));
f0102f69:	83 ec 0c             	sub    $0xc,%esp
f0102f6c:	6a 00                	push   $0x0
f0102f6e:	e8 02 e3 ff ff       	call   f0101275 <page_alloc>
f0102f73:	89 c6                	mov    %eax,%esi
f0102f75:	83 c4 10             	add    $0x10,%esp
f0102f78:	85 c0                	test   %eax,%eax
f0102f7a:	0f 84 e0 01 00 00    	je     f0103160 <mem_init+0x1aee>
	page_free(pp0);
f0102f80:	83 ec 0c             	sub    $0xc,%esp
f0102f83:	53                   	push   %ebx
f0102f84:	e8 77 e3 ff ff       	call   f0101300 <page_free>
	return (pp - pages) << PGSHIFT;
f0102f89:	89 f8                	mov    %edi,%eax
f0102f8b:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0102f91:	c1 f8 03             	sar    $0x3,%eax
f0102f94:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102f97:	89 c2                	mov    %eax,%edx
f0102f99:	c1 ea 0c             	shr    $0xc,%edx
f0102f9c:	83 c4 10             	add    $0x10,%esp
f0102f9f:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0102fa5:	0f 83 ce 01 00 00    	jae    f0103179 <mem_init+0x1b07>
	memset(page2kva(pp1), 1, PGSIZE);
f0102fab:	83 ec 04             	sub    $0x4,%esp
f0102fae:	68 00 10 00 00       	push   $0x1000
f0102fb3:	6a 01                	push   $0x1
	return (void *)(pa + KERNBASE);
f0102fb5:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102fba:	50                   	push   %eax
f0102fbb:	e8 5d 2d 00 00       	call   f0105d1d <memset>
	return (pp - pages) << PGSHIFT;
f0102fc0:	89 f0                	mov    %esi,%eax
f0102fc2:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0102fc8:	c1 f8 03             	sar    $0x3,%eax
f0102fcb:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f0102fce:	89 c2                	mov    %eax,%edx
f0102fd0:	c1 ea 0c             	shr    $0xc,%edx
f0102fd3:	83 c4 10             	add    $0x10,%esp
f0102fd6:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0102fdc:	0f 83 ac 01 00 00    	jae    f010318e <mem_init+0x1b1c>
	memset(page2kva(pp2), 2, PGSIZE);
f0102fe2:	83 ec 04             	sub    $0x4,%esp
f0102fe5:	68 00 10 00 00       	push   $0x1000
f0102fea:	6a 02                	push   $0x2
	return (void *)(pa + KERNBASE);
f0102fec:	2d 00 00 00 10       	sub    $0x10000000,%eax
f0102ff1:	50                   	push   %eax
f0102ff2:	e8 26 2d 00 00       	call   f0105d1d <memset>
	page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W);
f0102ff7:	6a 02                	push   $0x2
f0102ff9:	68 00 10 00 00       	push   $0x1000
f0102ffe:	57                   	push   %edi
f0102fff:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0103005:	e8 92 e5 ff ff       	call   f010159c <page_insert>
	assert(pp1->pp_ref == 1);
f010300a:	83 c4 20             	add    $0x20,%esp
f010300d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103012:	0f 85 8b 01 00 00    	jne    f01031a3 <mem_init+0x1b31>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f0103018:	81 3d 00 10 00 00 01 	cmpl   $0x1010101,0x1000
f010301f:	01 01 01 
f0103022:	0f 85 94 01 00 00    	jne    f01031bc <mem_init+0x1b4a>
	page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W);
f0103028:	6a 02                	push   $0x2
f010302a:	68 00 10 00 00       	push   $0x1000
f010302f:	56                   	push   %esi
f0103030:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0103036:	e8 61 e5 ff ff       	call   f010159c <page_insert>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f010303b:	83 c4 10             	add    $0x10,%esp
f010303e:	81 3d 00 10 00 00 02 	cmpl   $0x2020202,0x1000
f0103045:	02 02 02 
f0103048:	0f 85 87 01 00 00    	jne    f01031d5 <mem_init+0x1b63>
	assert(pp2->pp_ref == 1);
f010304e:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0103053:	0f 85 95 01 00 00    	jne    f01031ee <mem_init+0x1b7c>
	assert(pp1->pp_ref == 0);
f0103059:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f010305e:	0f 85 a3 01 00 00    	jne    f0103207 <mem_init+0x1b95>
	*(uint32_t *)PGSIZE = 0x03030303U;
f0103064:	c7 05 00 10 00 00 03 	movl   $0x3030303,0x1000
f010306b:	03 03 03 
	return (pp - pages) << PGSHIFT;
f010306e:	89 f0                	mov    %esi,%eax
f0103070:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0103076:	c1 f8 03             	sar    $0x3,%eax
f0103079:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010307c:	89 c2                	mov    %eax,%edx
f010307e:	c1 ea 0c             	shr    $0xc,%edx
f0103081:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0103087:	0f 83 93 01 00 00    	jae    f0103220 <mem_init+0x1bae>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f010308d:	81 b8 00 00 00 f0 03 	cmpl   $0x3030303,-0x10000000(%eax)
f0103094:	03 03 03 
f0103097:	0f 85 98 01 00 00    	jne    f0103235 <mem_init+0x1bc3>
	page_remove(kern_pgdir, (void*) PGSIZE);
f010309d:	83 ec 08             	sub    $0x8,%esp
f01030a0:	68 00 10 00 00       	push   $0x1000
f01030a5:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f01030ab:	e8 a6 e4 ff ff       	call   f0101556 <page_remove>
	assert(pp2->pp_ref == 0);
f01030b0:	83 c4 10             	add    $0x10,%esp
f01030b3:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01030b8:	0f 85 90 01 00 00    	jne    f010324e <mem_init+0x1bdc>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f01030be:	8b 0d cc 74 2c f0    	mov    0xf02c74cc,%ecx
f01030c4:	8b 11                	mov    (%ecx),%edx
f01030c6:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
	return (pp - pages) << PGSHIFT;
f01030cc:	89 d8                	mov    %ebx,%eax
f01030ce:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01030d4:	c1 f8 03             	sar    $0x3,%eax
f01030d7:	c1 e0 0c             	shl    $0xc,%eax
f01030da:	39 c2                	cmp    %eax,%edx
f01030dc:	0f 85 85 01 00 00    	jne    f0103267 <mem_init+0x1bf5>
	kern_pgdir[0] = 0;
f01030e2:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	assert(pp0->pp_ref == 1);
f01030e8:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01030ed:	0f 85 8d 01 00 00    	jne    f0103280 <mem_init+0x1c0e>
	pp0->pp_ref = 0;
f01030f3:	66 c7 43 04 00 00    	movw   $0x0,0x4(%ebx)

	// free the pages we took
	page_free(pp0);
f01030f9:	83 ec 0c             	sub    $0xc,%esp
f01030fc:	53                   	push   %ebx
f01030fd:	e8 fe e1 ff ff       	call   f0101300 <page_free>

	cprintf("check_page_installed_pgdir() succeeded!\n");
f0103102:	c7 04 24 a4 87 10 f0 	movl   $0xf01087a4,(%esp)
f0103109:	e8 95 0b 00 00       	call   f0103ca3 <cprintf>
}
f010310e:	83 c4 10             	add    $0x10,%esp
f0103111:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103114:	5b                   	pop    %ebx
f0103115:	5e                   	pop    %esi
f0103116:	5f                   	pop    %edi
f0103117:	5d                   	pop    %ebp
f0103118:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103119:	50                   	push   %eax
f010311a:	68 ec 77 10 f0       	push   $0xf01077ec
f010311f:	68 e9 00 00 00       	push   $0xe9
f0103124:	68 05 88 10 f0       	push   $0xf0108805
f0103129:	e8 15 cf ff ff       	call   f0100043 <_panic>
	assert((pp0 = page_alloc(0)));
f010312e:	68 fa 88 10 f0       	push   $0xf01088fa
f0103133:	68 31 78 10 f0       	push   $0xf0107831
f0103138:	68 a8 04 00 00       	push   $0x4a8
f010313d:	68 05 88 10 f0       	push   $0xf0108805
f0103142:	e8 fc ce ff ff       	call   f0100043 <_panic>
	assert((pp1 = page_alloc(0)));
f0103147:	68 10 89 10 f0       	push   $0xf0108910
f010314c:	68 31 78 10 f0       	push   $0xf0107831
f0103151:	68 a9 04 00 00       	push   $0x4a9
f0103156:	68 05 88 10 f0       	push   $0xf0108805
f010315b:	e8 e3 ce ff ff       	call   f0100043 <_panic>
	assert((pp2 = page_alloc(0)));
f0103160:	68 26 89 10 f0       	push   $0xf0108926
f0103165:	68 31 78 10 f0       	push   $0xf0107831
f010316a:	68 aa 04 00 00       	push   $0x4aa
f010316f:	68 05 88 10 f0       	push   $0xf0108805
f0103174:	e8 ca ce ff ff       	call   f0100043 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103179:	50                   	push   %eax
f010317a:	68 c8 77 10 f0       	push   $0xf01077c8
f010317f:	68 8e 00 00 00       	push   $0x8e
f0103184:	68 11 88 10 f0       	push   $0xf0108811
f0103189:	e8 b5 ce ff ff       	call   f0100043 <_panic>
f010318e:	50                   	push   %eax
f010318f:	68 c8 77 10 f0       	push   $0xf01077c8
f0103194:	68 8e 00 00 00       	push   $0x8e
f0103199:	68 11 88 10 f0       	push   $0xf0108811
f010319e:	e8 a0 ce ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 1);
f01031a3:	68 f7 89 10 f0       	push   $0xf01089f7
f01031a8:	68 31 78 10 f0       	push   $0xf0107831
f01031ad:	68 af 04 00 00       	push   $0x4af
f01031b2:	68 05 88 10 f0       	push   $0xf0108805
f01031b7:	e8 87 ce ff ff       	call   f0100043 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x01010101U);
f01031bc:	68 30 87 10 f0       	push   $0xf0108730
f01031c1:	68 31 78 10 f0       	push   $0xf0107831
f01031c6:	68 b0 04 00 00       	push   $0x4b0
f01031cb:	68 05 88 10 f0       	push   $0xf0108805
f01031d0:	e8 6e ce ff ff       	call   f0100043 <_panic>
	assert(*(uint32_t *)PGSIZE == 0x02020202U);
f01031d5:	68 54 87 10 f0       	push   $0xf0108754
f01031da:	68 31 78 10 f0       	push   $0xf0107831
f01031df:	68 b2 04 00 00       	push   $0x4b2
f01031e4:	68 05 88 10 f0       	push   $0xf0108805
f01031e9:	e8 55 ce ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 1);
f01031ee:	68 19 8a 10 f0       	push   $0xf0108a19
f01031f3:	68 31 78 10 f0       	push   $0xf0107831
f01031f8:	68 b3 04 00 00       	push   $0x4b3
f01031fd:	68 05 88 10 f0       	push   $0xf0108805
f0103202:	e8 3c ce ff ff       	call   f0100043 <_panic>
	assert(pp1->pp_ref == 0);
f0103207:	68 83 8a 10 f0       	push   $0xf0108a83
f010320c:	68 31 78 10 f0       	push   $0xf0107831
f0103211:	68 b4 04 00 00       	push   $0x4b4
f0103216:	68 05 88 10 f0       	push   $0xf0108805
f010321b:	e8 23 ce ff ff       	call   f0100043 <_panic>
f0103220:	50                   	push   %eax
f0103221:	68 c8 77 10 f0       	push   $0xf01077c8
f0103226:	68 8e 00 00 00       	push   $0x8e
f010322b:	68 11 88 10 f0       	push   $0xf0108811
f0103230:	e8 0e ce ff ff       	call   f0100043 <_panic>
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f0103235:	68 78 87 10 f0       	push   $0xf0108778
f010323a:	68 31 78 10 f0       	push   $0xf0107831
f010323f:	68 b6 04 00 00       	push   $0x4b6
f0103244:	68 05 88 10 f0       	push   $0xf0108805
f0103249:	e8 f5 cd ff ff       	call   f0100043 <_panic>
	assert(pp2->pp_ref == 0);
f010324e:	68 51 8a 10 f0       	push   $0xf0108a51
f0103253:	68 31 78 10 f0       	push   $0xf0107831
f0103258:	68 b8 04 00 00       	push   $0x4b8
f010325d:	68 05 88 10 f0       	push   $0xf0108805
f0103262:	e8 dc cd ff ff       	call   f0100043 <_panic>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0103267:	68 d0 80 10 f0       	push   $0xf01080d0
f010326c:	68 31 78 10 f0       	push   $0xf0107831
f0103271:	68 bb 04 00 00       	push   $0x4bb
f0103276:	68 05 88 10 f0       	push   $0xf0108805
f010327b:	e8 c3 cd ff ff       	call   f0100043 <_panic>
	assert(pp0->pp_ref == 1);
f0103280:	68 08 8a 10 f0       	push   $0xf0108a08
f0103285:	68 31 78 10 f0       	push   $0xf0107831
f010328a:	68 bd 04 00 00       	push   $0x4bd
f010328f:	68 05 88 10 f0       	push   $0xf0108805
f0103294:	e8 aa cd ff ff       	call   f0100043 <_panic>

f0103299 <user_mem_check>:
{
f0103299:	55                   	push   %ebp
f010329a:	89 e5                	mov    %esp,%ebp
f010329c:	57                   	push   %edi
f010329d:	56                   	push   %esi
f010329e:	53                   	push   %ebx
f010329f:	83 ec 2c             	sub    $0x2c,%esp
f01032a2:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint32_t index = ROUNDDOWN((uint32_t) va, PGSIZE);
f01032a5:	8b 45 0c             	mov    0xc(%ebp),%eax
f01032a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
f01032ab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01032b0:	89 c3                	mov    %eax,%ebx
f01032b2:	89 45 c8             	mov    %eax,-0x38(%ebp)
	uint32_t end = ROUNDUP((uint32_t) va + len, PGSIZE);
f01032b5:	8b 45 10             	mov    0x10(%ebp),%eax
f01032b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01032bb:	8d 84 01 ff 0f 00 00 	lea    0xfff(%ecx,%eax,1),%eax
f01032c2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f01032c7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	perm |= PTE_P;
f01032ca:	8b 45 14             	mov    0x14(%ebp),%eax
f01032cd:	83 c8 01             	or     $0x1,%eax
f01032d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if (!page_lookup(env->env_pgdir, (void*) index,  &store) ||
f01032d3:	8d 75 e4             	lea    -0x1c(%ebp),%esi
	for (; index < end; index+=PGSIZE) {
f01032d6:	3b 5d d4             	cmp    -0x2c(%ebp),%ebx
f01032d9:	73 5e                	jae    f0103339 <user_mem_check+0xa0>
		if (index >= ULIM) {
f01032db:	81 fb ff ff 7f ef    	cmp    $0xef7fffff,%ebx
f01032e1:	77 28                	ja     f010330b <user_mem_check+0x72>
		if (!page_lookup(env->env_pgdir, (void*) index,  &store) ||
f01032e3:	83 ec 04             	sub    $0x4,%esp
f01032e6:	56                   	push   %esi
f01032e7:	53                   	push   %ebx
f01032e8:	ff 77 60             	pushl  0x60(%edi)
f01032eb:	e8 b3 e1 ff ff       	call   f01014a3 <page_lookup>
f01032f0:	83 c4 10             	add    $0x10,%esp
f01032f3:	85 c0                	test   %eax,%eax
f01032f5:	74 26                	je     f010331d <user_mem_check+0x84>
			((*store & (perm)) ^ (perm)) ) {
f01032f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01032fa:	8b 00                	mov    (%eax),%eax
f01032fc:	f7 d0                	not    %eax
		if (!page_lookup(env->env_pgdir, (void*) index,  &store) ||
f01032fe:	85 45 d0             	test   %eax,-0x30(%ebp)
f0103301:	75 1a                	jne    f010331d <user_mem_check+0x84>
	for (; index < end; index+=PGSIZE) {
f0103303:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103309:	eb cb                	jmp    f01032d6 <user_mem_check+0x3d>
			user_mem_check_addr = (index < (uint32_t) ROUNDDOWN((uint32_t) va, PGSIZE)) ? (uint32_t) va : (uint32_t) index;
f010330b:	3b 5d c8             	cmp    -0x38(%ebp),%ebx
f010330e:	72 03                	jb     f0103313 <user_mem_check+0x7a>
f0103310:	89 5d cc             	mov    %ebx,-0x34(%ebp)
f0103313:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0103316:	a3 3c 62 2c f0       	mov    %eax,0xf02c623c
			return -E_FAULT;
f010331b:	eb 0f                	jmp    f010332c <user_mem_check+0x93>
			user_mem_check_addr = (index < (uint32_t) va) ? (uint32_t) va : (uint32_t) index;
f010331d:	89 d8                	mov    %ebx,%eax
f010331f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
f0103322:	73 03                	jae    f0103327 <user_mem_check+0x8e>
f0103324:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103327:	a3 3c 62 2c f0       	mov    %eax,0xf02c623c
			return -E_FAULT;
f010332c:	b8 fa ff ff ff       	mov    $0xfffffffa,%eax
}
f0103331:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103334:	5b                   	pop    %ebx
f0103335:	5e                   	pop    %esi
f0103336:	5f                   	pop    %edi
f0103337:	5d                   	pop    %ebp
f0103338:	c3                   	ret    
	return 0;
f0103339:	b8 00 00 00 00       	mov    $0x0,%eax
f010333e:	eb f1                	jmp    f0103331 <user_mem_check+0x98>

f0103340 <user_mem_assert>:
{
f0103340:	55                   	push   %ebp
f0103341:	89 e5                	mov    %esp,%ebp
f0103343:	53                   	push   %ebx
f0103344:	83 ec 04             	sub    $0x4,%esp
f0103347:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (user_mem_check(env, va, len, perm | PTE_U) < 0) {
f010334a:	8b 45 14             	mov    0x14(%ebp),%eax
f010334d:	83 c8 04             	or     $0x4,%eax
f0103350:	50                   	push   %eax
f0103351:	ff 75 10             	pushl  0x10(%ebp)
f0103354:	ff 75 0c             	pushl  0xc(%ebp)
f0103357:	53                   	push   %ebx
f0103358:	e8 3c ff ff ff       	call   f0103299 <user_mem_check>
f010335d:	83 c4 10             	add    $0x10,%esp
f0103360:	85 c0                	test   %eax,%eax
f0103362:	78 05                	js     f0103369 <user_mem_assert+0x29>
}
f0103364:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103367:	c9                   	leave  
f0103368:	c3                   	ret    
		cprintf("[%08x] user_mem_check assertion failure for "
f0103369:	83 ec 04             	sub    $0x4,%esp
f010336c:	ff 35 3c 62 2c f0    	pushl  0xf02c623c
f0103372:	ff 73 48             	pushl  0x48(%ebx)
f0103375:	68 d0 87 10 f0       	push   $0xf01087d0
f010337a:	e8 24 09 00 00       	call   f0103ca3 <cprintf>
		env_destroy(env);	// may not return
f010337f:	89 1c 24             	mov    %ebx,(%esp)
f0103382:	e8 a8 06 00 00       	call   f0103a2f <env_destroy>
f0103387:	83 c4 10             	add    $0x10,%esp
}
f010338a:	eb d8                	jmp    f0103364 <user_mem_assert+0x24>

f010338c <envid2env>:
//   On success, sets *env_store to the environment.
//   On error, sets *env_store to NULL.
//
int
envid2env(envid_t envid, struct Env **env_store, bool checkperm)
{
f010338c:	55                   	push   %ebp
f010338d:	89 e5                	mov    %esp,%ebp
f010338f:	56                   	push   %esi
f0103390:	53                   	push   %ebx
f0103391:	8b 45 08             	mov    0x8(%ebp),%eax
f0103394:	8b 75 10             	mov    0x10(%ebp),%esi
	struct Env *e;

	// If envid is zero, return the current environment.
	if (envid == 0) {
f0103397:	85 c0                	test   %eax,%eax
f0103399:	74 37                	je     f01033d2 <envid2env+0x46>
	// Look up the Env structure via the index part of the envid,
	// then check the env_id field in that struct Env
	// to ensure that the envid is not stale
	// (i.e., does not refer to a _previous_ environment
	// that used the same slot in the envs[] array).
	e = &envs[ENVX(envid)];
f010339b:	89 c1                	mov    %eax,%ecx
f010339d:	81 e1 ff 03 00 00    	and    $0x3ff,%ecx
f01033a3:	89 ca                	mov    %ecx,%edx
f01033a5:	c1 e2 05             	shl    $0x5,%edx
f01033a8:	29 ca                	sub    %ecx,%edx
f01033aa:	8b 0d 44 62 2c f0    	mov    0xf02c6244,%ecx
f01033b0:	8d 1c 91             	lea    (%ecx,%edx,4),%ebx
	if (e->env_status == ENV_FREE || e->env_id != envid) {
f01033b3:	83 7b 54 00          	cmpl   $0x0,0x54(%ebx)
f01033b7:	74 3d                	je     f01033f6 <envid2env+0x6a>
f01033b9:	3b 43 48             	cmp    0x48(%ebx),%eax
f01033bc:	75 38                	jne    f01033f6 <envid2env+0x6a>
	// Check that the calling environment has legitimate permission
	// to manipulate the specified environment.
	// If checkperm is set, the specified environment
	// must be either the current environment
	// or an immediate child of the current environment.
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f01033be:	89 f0                	mov    %esi,%eax
f01033c0:	84 c0                	test   %al,%al
f01033c2:	75 42                	jne    f0103406 <envid2env+0x7a>
		*env_store = 0;
		return -E_BAD_ENV;
	}

	*env_store = e;
f01033c4:	8b 45 0c             	mov    0xc(%ebp),%eax
f01033c7:	89 18                	mov    %ebx,(%eax)
	return 0;
f01033c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01033ce:	5b                   	pop    %ebx
f01033cf:	5e                   	pop    %esi
f01033d0:	5d                   	pop    %ebp
f01033d1:	c3                   	ret    
		*env_store = curenv;
f01033d2:	e8 51 30 00 00       	call   f0106428 <cpunum>
f01033d7:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01033da:	01 c2                	add    %eax,%edx
f01033dc:	01 d2                	add    %edx,%edx
f01033de:	01 c2                	add    %eax,%edx
f01033e0:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01033e3:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f01033ea:	8b 75 0c             	mov    0xc(%ebp),%esi
f01033ed:	89 06                	mov    %eax,(%esi)
		return 0;
f01033ef:	b8 00 00 00 00       	mov    $0x0,%eax
f01033f4:	eb d8                	jmp    f01033ce <envid2env+0x42>
		*env_store = 0;
f01033f6:	8b 45 0c             	mov    0xc(%ebp),%eax
f01033f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f01033ff:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0103404:	eb c8                	jmp    f01033ce <envid2env+0x42>
	if (checkperm && e != curenv && e->env_parent_id != curenv->env_id) {
f0103406:	e8 1d 30 00 00       	call   f0106428 <cpunum>
f010340b:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010340e:	01 c2                	add    %eax,%edx
f0103410:	01 d2                	add    %edx,%edx
f0103412:	01 c2                	add    %eax,%edx
f0103414:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103417:	3b 1c 85 08 80 2c f0 	cmp    -0xfd37ff8(,%eax,4),%ebx
f010341e:	74 a4                	je     f01033c4 <envid2env+0x38>
f0103420:	8b 73 4c             	mov    0x4c(%ebx),%esi
f0103423:	e8 00 30 00 00       	call   f0106428 <cpunum>
f0103428:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010342b:	01 c2                	add    %eax,%edx
f010342d:	01 d2                	add    %edx,%edx
f010342f:	01 c2                	add    %eax,%edx
f0103431:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103434:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f010343b:	3b 70 48             	cmp    0x48(%eax),%esi
f010343e:	74 84                	je     f01033c4 <envid2env+0x38>
		*env_store = 0;
f0103440:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		return -E_BAD_ENV;
f0103449:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f010344e:	e9 7b ff ff ff       	jmp    f01033ce <envid2env+0x42>

f0103453 <env_init_percpu>:
}

// Load GDT and segment descriptors.
void
env_init_percpu(void)
{
f0103453:	55                   	push   %ebp
f0103454:	89 e5                	mov    %esp,%ebp
	asm volatile("lgdt (%0)" : : "r" (p));
f0103456:	b8 20 b3 12 f0       	mov    $0xf012b320,%eax
f010345b:	0f 01 10             	lgdtl  (%eax)
	lgdt(&gdt_pd);
	// The kernel never uses GS or FS, so we leave those set to
	// the user data segment.
	asm volatile("movw %%ax,%%gs" : : "a" (GD_UD|3));
f010345e:	b8 23 00 00 00       	mov    $0x23,%eax
f0103463:	8e e8                	mov    %eax,%gs
	asm volatile("movw %%ax,%%fs" : : "a" (GD_UD|3));
f0103465:	8e e0                	mov    %eax,%fs
	// The kernel does use ES, DS, and SS.  We'll change between
	// the kernel and user data segments as needed.
	asm volatile("movw %%ax,%%es" : : "a" (GD_KD));
f0103467:	b8 10 00 00 00       	mov    $0x10,%eax
f010346c:	8e c0                	mov    %eax,%es
	asm volatile("movw %%ax,%%ds" : : "a" (GD_KD));
f010346e:	8e d8                	mov    %eax,%ds
	asm volatile("movw %%ax,%%ss" : : "a" (GD_KD));
f0103470:	8e d0                	mov    %eax,%ss
	// Load the kernel text segment into CS.
	asm volatile("ljmp %0,$1f\n 1:\n" : : "i" (GD_KT));
f0103472:	ea 79 34 10 f0 08 00 	ljmp   $0x8,$0xf0103479
	asm volatile("lldt %0" : : "r" (sel));
f0103479:	b8 00 00 00 00       	mov    $0x0,%eax
f010347e:	0f 00 d0             	lldt   %ax
	// For good measure, clear the local descriptor table (LDT),
	// since we don't use it.
	lldt(0);
}
f0103481:	5d                   	pop    %ebp
f0103482:	c3                   	ret    

f0103483 <env_init>:
{
f0103483:	55                   	push   %ebp
f0103484:	89 e5                	mov    %esp,%ebp
f0103486:	56                   	push   %esi
f0103487:	53                   	push   %ebx
		envs[i].env_link = env_free_list;
f0103488:	8b 35 44 62 2c f0    	mov    0xf02c6244,%esi
f010348e:	8b 15 48 62 2c f0    	mov    0xf02c6248,%edx
f0103494:	8d 86 84 ef 01 00    	lea    0x1ef84(%esi),%eax
f010349a:	8d 5e 84             	lea    -0x7c(%esi),%ebx
f010349d:	89 c1                	mov    %eax,%ecx
f010349f:	89 50 44             	mov    %edx,0x44(%eax)
f01034a2:	83 e8 7c             	sub    $0x7c,%eax
		env_free_list = &envs[i];
f01034a5:	89 ca                	mov    %ecx,%edx
	for (int i = NENV - 1; i >= 0; i--) {
f01034a7:	39 d8                	cmp    %ebx,%eax
f01034a9:	75 f2                	jne    f010349d <env_init+0x1a>
f01034ab:	89 35 48 62 2c f0    	mov    %esi,0xf02c6248
	env_init_percpu();
f01034b1:	e8 9d ff ff ff       	call   f0103453 <env_init_percpu>
}
f01034b6:	5b                   	pop    %ebx
f01034b7:	5e                   	pop    %esi
f01034b8:	5d                   	pop    %ebp
f01034b9:	c3                   	ret    

f01034ba <env_alloc>:
//	-E_NO_FREE_ENV if all NENVS environments are allocated
//	-E_NO_MEM on memory exhaustion
//
int
env_alloc(struct Env **newenv_store, envid_t parent_id)
{
f01034ba:	55                   	push   %ebp
f01034bb:	89 e5                	mov    %esp,%ebp
f01034bd:	56                   	push   %esi
f01034be:	53                   	push   %ebx
	int32_t generation;
	int r;
	struct Env *e;

	if (!(e = env_free_list))
f01034bf:	8b 1d 48 62 2c f0    	mov    0xf02c6248,%ebx
f01034c5:	85 db                	test   %ebx,%ebx
f01034c7:	0f 84 5c 01 00 00    	je     f0103629 <env_alloc+0x16f>
	if (!(p = page_alloc(ALLOC_ZERO)))
f01034cd:	83 ec 0c             	sub    $0xc,%esp
f01034d0:	6a 01                	push   $0x1
f01034d2:	e8 9e dd ff ff       	call   f0101275 <page_alloc>
f01034d7:	89 c6                	mov    %eax,%esi
f01034d9:	83 c4 10             	add    $0x10,%esp
f01034dc:	85 c0                	test   %eax,%eax
f01034de:	0f 84 4c 01 00 00    	je     f0103630 <env_alloc+0x176>
	return (pp - pages) << PGSHIFT;
f01034e4:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01034ea:	c1 f8 03             	sar    $0x3,%eax
f01034ed:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01034f0:	89 c2                	mov    %eax,%edx
f01034f2:	c1 ea 0c             	shr    $0xc,%edx
f01034f5:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f01034fb:	0f 83 f4 00 00 00    	jae    f01035f5 <env_alloc+0x13b>
	return (void *)(pa + KERNBASE);
f0103501:	2d 00 00 00 10       	sub    $0x10000000,%eax
	e->env_pgdir = pagedir;
f0103506:	89 43 60             	mov    %eax,0x60(%ebx)
	memcpy(e->env_pgdir, kern_pgdir, PGSIZE);
f0103509:	83 ec 04             	sub    $0x4,%esp
f010350c:	68 00 10 00 00       	push   $0x1000
f0103511:	ff 35 cc 74 2c f0    	pushl  0xf02c74cc
f0103517:	50                   	push   %eax
f0103518:	e8 b3 28 00 00       	call   f0105dd0 <memcpy>
	p->pp_ref++;
f010351d:	66 ff 46 04          	incw   0x4(%esi)
	e->env_pgdir[PDX(UVPT)] = PADDR(e->env_pgdir) | PTE_P | PTE_U;
f0103521:	8b 43 60             	mov    0x60(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f0103524:	83 c4 10             	add    $0x10,%esp
f0103527:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010352c:	0f 86 d8 00 00 00    	jbe    f010360a <env_alloc+0x150>
	return (physaddr_t)kva - KERNBASE;
f0103532:	8d 90 00 00 00 10    	lea    0x10000000(%eax),%edx
f0103538:	83 ca 05             	or     $0x5,%edx
f010353b:	89 90 f4 0e 00 00    	mov    %edx,0xef4(%eax)
	// Allocate and set up the page directory for this environment.
	if ((r = env_setup_vm(e)) < 0)
		return r;

	// Generate an env_id for this environment.
	generation = (e->env_id + (1 << ENVGENSHIFT)) & ~(NENV - 1);
f0103541:	8b 43 48             	mov    0x48(%ebx),%eax
f0103544:	05 00 10 00 00       	add    $0x1000,%eax
	if (generation <= 0)	// Don't create a negative env_id.
f0103549:	25 00 fc ff ff       	and    $0xfffffc00,%eax
f010354e:	89 c2                	mov    %eax,%edx
f0103550:	0f 8e c9 00 00 00    	jle    f010361f <env_alloc+0x165>
		generation = 1 << ENVGENSHIFT;
	e->env_id = generation | (e - envs);
f0103556:	89 d8                	mov    %ebx,%eax
f0103558:	2b 05 44 62 2c f0    	sub    0xf02c6244,%eax
f010355e:	c1 f8 02             	sar    $0x2,%eax
f0103561:	89 c1                	mov    %eax,%ecx
f0103563:	c1 e0 05             	shl    $0x5,%eax
f0103566:	01 c8                	add    %ecx,%eax
f0103568:	c1 e0 05             	shl    $0x5,%eax
f010356b:	01 c8                	add    %ecx,%eax
f010356d:	89 c6                	mov    %eax,%esi
f010356f:	c1 e6 0f             	shl    $0xf,%esi
f0103572:	01 f0                	add    %esi,%eax
f0103574:	c1 e0 05             	shl    $0x5,%eax
f0103577:	01 c8                	add    %ecx,%eax
f0103579:	f7 d8                	neg    %eax
f010357b:	09 d0                	or     %edx,%eax
f010357d:	89 43 48             	mov    %eax,0x48(%ebx)

	// Set the basic status variables.
	e->env_parent_id = parent_id;
f0103580:	8b 45 0c             	mov    0xc(%ebp),%eax
f0103583:	89 43 4c             	mov    %eax,0x4c(%ebx)
	e->env_type = ENV_TYPE_USER;
f0103586:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
	e->env_status = ENV_RUNNABLE;
f010358d:	c7 43 54 02 00 00 00 	movl   $0x2,0x54(%ebx)
	e->env_runs = 0;
f0103594:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)

	// Clear out all the saved register state,
	// to prevent the register values
	// of a prior environment inhabiting this Env structure
	// from "leaking" into our new environment.
	memset(&e->env_tf, 0, sizeof(e->env_tf));
f010359b:	83 ec 04             	sub    $0x4,%esp
f010359e:	6a 44                	push   $0x44
f01035a0:	6a 00                	push   $0x0
f01035a2:	53                   	push   %ebx
f01035a3:	e8 75 27 00 00       	call   f0105d1d <memset>
	// The low 2 bits of each segment register contains the
	// Requestor Privilege Level (RPL); 3 means user mode.  When
	// we switch privilege levels, the hardware does various
	// checks involving the RPL and the Descriptor Privilege Level
	// (DPL) stored in the descriptors themselves.
	e->env_tf.tf_ds = GD_UD | 3;
f01035a8:	66 c7 43 24 23 00    	movw   $0x23,0x24(%ebx)
	e->env_tf.tf_es = GD_UD | 3;
f01035ae:	66 c7 43 20 23 00    	movw   $0x23,0x20(%ebx)
	e->env_tf.tf_ss = GD_UD | 3;
f01035b4:	66 c7 43 40 23 00    	movw   $0x23,0x40(%ebx)
	e->env_tf.tf_esp = USTACKTOP;
f01035ba:	c7 43 3c 00 e0 bf ee 	movl   $0xeebfe000,0x3c(%ebx)
	e->env_tf.tf_cs = GD_UT | 3;
f01035c1:	66 c7 43 34 1b 00    	movw   $0x1b,0x34(%ebx)
	// You will set e->env_tf.tf_eip later.

	// Enable interrupts while in user mode.
	// LAB 4: Your code here.
	e->env_tf.tf_eflags |= FL_IF;
f01035c7:	81 4b 38 00 02 00 00 	orl    $0x200,0x38(%ebx)
	// Clear the page fault handler until user installs one.
	e->env_pgfault_upcall = 0;
f01035ce:	c7 43 64 00 00 00 00 	movl   $0x0,0x64(%ebx)

	// Also clear the IPC receiving flag.
	e->env_ipc_recving = 0;
f01035d5:	c6 43 68 00          	movb   $0x0,0x68(%ebx)

	// commit the allocation
	env_free_list = e->env_link;
f01035d9:	8b 43 44             	mov    0x44(%ebx),%eax
f01035dc:	a3 48 62 2c f0       	mov    %eax,0xf02c6248
	*newenv_store = e;
f01035e1:	8b 45 08             	mov    0x8(%ebp),%eax
f01035e4:	89 18                	mov    %ebx,(%eax)

	// cprintf("[%08x] new env %08x\n", curenv ? curenv->env_id : 0, e->env_id);
	return 0;
f01035e6:	83 c4 10             	add    $0x10,%esp
f01035e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01035ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01035f1:	5b                   	pop    %ebx
f01035f2:	5e                   	pop    %esi
f01035f3:	5d                   	pop    %ebp
f01035f4:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01035f5:	50                   	push   %eax
f01035f6:	68 c8 77 10 f0       	push   $0xf01077c8
f01035fb:	68 8e 00 00 00       	push   $0x8e
f0103600:	68 11 88 10 f0       	push   $0xf0108811
f0103605:	e8 39 ca ff ff       	call   f0100043 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010360a:	50                   	push   %eax
f010360b:	68 ec 77 10 f0       	push   $0xf01077ec
f0103610:	68 c5 00 00 00       	push   $0xc5
f0103615:	68 29 8c 10 f0       	push   $0xf0108c29
f010361a:	e8 24 ca ff ff       	call   f0100043 <_panic>
		generation = 1 << ENVGENSHIFT;
f010361f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103624:	e9 2d ff ff ff       	jmp    f0103556 <env_alloc+0x9c>
		return -E_NO_FREE_ENV;
f0103629:	b8 fb ff ff ff       	mov    $0xfffffffb,%eax
f010362e:	eb be                	jmp    f01035ee <env_alloc+0x134>
		return -E_NO_MEM;
f0103630:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f0103635:	eb b7                	jmp    f01035ee <env_alloc+0x134>

f0103637 <env_create>:
// before running the first user-mode environment.
// The new env's parent ID is set to 0.
//
void
env_create(uint8_t *binary, enum EnvType type)
{
f0103637:	55                   	push   %ebp
f0103638:	89 e5                	mov    %esp,%ebp
f010363a:	57                   	push   %edi
f010363b:	56                   	push   %esi
f010363c:	53                   	push   %ebx
f010363d:	83 ec 34             	sub    $0x34,%esp
	// LAB 3: Your code here.
	struct Env* newenv_store;
	assert(!env_alloc(&newenv_store, 0));
f0103640:	6a 00                	push   $0x0
f0103642:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0103645:	50                   	push   %eax
f0103646:	e8 6f fe ff ff       	call   f01034ba <env_alloc>
f010364b:	83 c4 10             	add    $0x10,%esp
f010364e:	85 c0                	test   %eax,%eax
f0103650:	75 40                	jne    f0103692 <env_create+0x5b>
	load_icode(newenv_store, binary);
f0103652:	8b 7d e4             	mov    -0x1c(%ebp),%edi
	assert(elff->e_magic == ELF_MAGIC);
f0103655:	8b 45 08             	mov    0x8(%ebp),%eax
f0103658:	81 38 7f 45 4c 46    	cmpl   $0x464c457f,(%eax)
f010365e:	75 4b                	jne    f01036ab <env_create+0x74>
	struct Proghdr* header = (struct Proghdr*) (binary + elff->e_phoff);
f0103660:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0103663:	89 c8                	mov    %ecx,%eax
f0103665:	03 41 1c             	add    0x1c(%ecx),%eax
f0103668:	89 c1                	mov    %eax,%ecx
	struct Proghdr* header_end = header +  elff->e_phnum;
f010366a:	8b 45 08             	mov    0x8(%ebp),%eax
f010366d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
f0103671:	c1 e0 05             	shl    $0x5,%eax
f0103674:	01 c8                	add    %ecx,%eax
f0103676:	89 45 d4             	mov    %eax,-0x2c(%ebp)
	lcr3(PADDR(e->env_pgdir));  // question ta??  idk
f0103679:	8b 47 60             	mov    0x60(%edi),%eax
	if ((uint32_t)kva < KERNBASE)
f010367c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103681:	76 41                	jbe    f01036c4 <env_create+0x8d>
	return (physaddr_t)kva - KERNBASE;
f0103683:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0103688:	0f 22 d8             	mov    %eax,%cr3
f010368b:	89 ce                	mov    %ecx,%esi
f010368d:	e9 e0 00 00 00       	jmp    f0103772 <env_create+0x13b>
	assert(!env_alloc(&newenv_store, 0));
f0103692:	68 34 8c 10 f0       	push   $0xf0108c34
f0103697:	68 31 78 10 f0       	push   $0xf0107831
f010369c:	68 8a 01 00 00       	push   $0x18a
f01036a1:	68 29 8c 10 f0       	push   $0xf0108c29
f01036a6:	e8 98 c9 ff ff       	call   f0100043 <_panic>
	assert(elff->e_magic == ELF_MAGIC);
f01036ab:	68 51 8c 10 f0       	push   $0xf0108c51
f01036b0:	68 31 78 10 f0       	push   $0xf0107831
f01036b5:	68 65 01 00 00       	push   $0x165
f01036ba:	68 29 8c 10 f0       	push   $0xf0108c29
f01036bf:	e8 7f c9 ff ff       	call   f0100043 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01036c4:	50                   	push   %eax
f01036c5:	68 ec 77 10 f0       	push   $0xf01077ec
f01036ca:	68 69 01 00 00       	push   $0x169
f01036cf:	68 29 8c 10 f0       	push   $0xf0108c29
f01036d4:	e8 6a c9 ff ff       	call   f0100043 <_panic>
		assert(header->p_filesz <= header->p_memsz);
f01036d9:	68 20 8b 10 f0       	push   $0xf0108b20
f01036de:	68 31 78 10 f0       	push   $0xf0107831
f01036e3:	68 6c 01 00 00       	push   $0x16c
f01036e8:	68 29 8c 10 f0       	push   $0xf0108c29
f01036ed:	e8 51 c9 ff ff       	call   f0100043 <_panic>
	assert(lower < (char*)UTOP && upper <= (char*)UTOP && upper >= lower);
f01036f2:	68 44 8b 10 f0       	push   $0xf0108b44
f01036f7:	68 31 78 10 f0       	push   $0xf0107831
f01036fc:	68 25 01 00 00       	push   $0x125
f0103701:	68 29 8c 10 f0       	push   $0xf0108c29
f0103706:	e8 38 c9 ff ff       	call   f0100043 <_panic>
		assert(pginfo != NULL);
f010370b:	68 6c 8c 10 f0       	push   $0xf0108c6c
f0103710:	68 31 78 10 f0       	push   $0xf0107831
f0103715:	68 28 01 00 00       	push   $0x128
f010371a:	68 29 8c 10 f0       	push   $0xf0108c29
f010371f:	e8 1f c9 ff ff       	call   f0100043 <_panic>
		assert(page_insert(e->env_pgdir, pginfo, lower, PTE_U | PTE_W) == 0);
f0103724:	68 84 8b 10 f0       	push   $0xf0108b84
f0103729:	68 31 78 10 f0       	push   $0xf0107831
f010372e:	68 29 01 00 00       	push   $0x129
f0103733:	68 29 8c 10 f0       	push   $0xf0108c29
f0103738:	e8 06 c9 ff ff       	call   f0100043 <_panic>
f010373d:	8b 75 d0             	mov    -0x30(%ebp),%esi
		memcpy((void*) header->p_va, binary + header->p_offset, header->p_filesz);
f0103740:	83 ec 04             	sub    $0x4,%esp
f0103743:	ff 76 10             	pushl  0x10(%esi)
f0103746:	8b 45 08             	mov    0x8(%ebp),%eax
f0103749:	03 46 04             	add    0x4(%esi),%eax
f010374c:	50                   	push   %eax
f010374d:	ff 76 08             	pushl  0x8(%esi)
f0103750:	e8 7b 26 00 00       	call   f0105dd0 <memcpy>
		       0, header->p_memsz -  header->p_filesz);
f0103755:	8b 46 10             	mov    0x10(%esi),%eax
		memset((void*) header->p_va + header->p_filesz,
f0103758:	83 c4 0c             	add    $0xc,%esp
f010375b:	8b 56 14             	mov    0x14(%esi),%edx
f010375e:	29 c2                	sub    %eax,%edx
f0103760:	52                   	push   %edx
f0103761:	6a 00                	push   $0x0
f0103763:	03 46 08             	add    0x8(%esi),%eax
f0103766:	50                   	push   %eax
f0103767:	e8 b1 25 00 00       	call   f0105d1d <memset>
f010376c:	83 c4 10             	add    $0x10,%esp
	for (; header < header_end; header++) {
f010376f:	83 c6 20             	add    $0x20,%esi
f0103772:	39 75 d4             	cmp    %esi,-0x2c(%ebp)
f0103775:	0f 86 88 00 00 00    	jbe    f0103803 <env_create+0x1cc>
		if (header->p_type != ELF_PROG_LOAD ) continue;
f010377b:	83 3e 01             	cmpl   $0x1,(%esi)
f010377e:	75 ef                	jne    f010376f <env_create+0x138>
		assert(header->p_filesz <= header->p_memsz);
f0103780:	8b 56 14             	mov    0x14(%esi),%edx
f0103783:	39 56 10             	cmp    %edx,0x10(%esi)
f0103786:	0f 87 4d ff ff ff    	ja     f01036d9 <env_create+0xa2>
		region_alloc(e, (void*) header->p_va, header->p_memsz);
f010378c:	8b 46 08             	mov    0x8(%esi),%eax
	char* lower = ROUNDDOWN((char*)va, PGSIZE);
f010378f:	89 c3                	mov    %eax,%ebx
f0103791:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	char* upper = ROUNDUP((char*)(va + len), PGSIZE);
f0103797:	8d 84 02 ff 0f 00 00 	lea    0xfff(%edx,%eax,1),%eax
f010379e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	assert(lower < (char*)UTOP && upper <= (char*)UTOP && upper >= lower);
f01037a3:	81 fb ff ff bf ee    	cmp    $0xeebfffff,%ebx
f01037a9:	0f 87 43 ff ff ff    	ja     f01036f2 <env_create+0xbb>
f01037af:	3d 00 00 c0 ee       	cmp    $0xeec00000,%eax
f01037b4:	0f 87 38 ff ff ff    	ja     f01036f2 <env_create+0xbb>
f01037ba:	39 c3                	cmp    %eax,%ebx
f01037bc:	0f 87 30 ff ff ff    	ja     f01036f2 <env_create+0xbb>
f01037c2:	89 75 d0             	mov    %esi,-0x30(%ebp)
f01037c5:	89 c6                	mov    %eax,%esi
	for (; lower < upper; lower+=PGSIZE) {
f01037c7:	39 de                	cmp    %ebx,%esi
f01037c9:	0f 86 6e ff ff ff    	jbe    f010373d <env_create+0x106>
		struct PageInfo* pginfo = page_alloc(~ALLOC_ZERO);
f01037cf:	83 ec 0c             	sub    $0xc,%esp
f01037d2:	6a fe                	push   $0xfffffffe
f01037d4:	e8 9c da ff ff       	call   f0101275 <page_alloc>
		assert(pginfo != NULL);
f01037d9:	83 c4 10             	add    $0x10,%esp
f01037dc:	85 c0                	test   %eax,%eax
f01037de:	0f 84 27 ff ff ff    	je     f010370b <env_create+0xd4>
		assert(page_insert(e->env_pgdir, pginfo, lower, PTE_U | PTE_W) == 0);
f01037e4:	6a 06                	push   $0x6
f01037e6:	53                   	push   %ebx
f01037e7:	50                   	push   %eax
f01037e8:	ff 77 60             	pushl  0x60(%edi)
f01037eb:	e8 ac dd ff ff       	call   f010159c <page_insert>
f01037f0:	83 c4 10             	add    $0x10,%esp
f01037f3:	85 c0                	test   %eax,%eax
f01037f5:	0f 85 29 ff ff ff    	jne    f0103724 <env_create+0xed>
	for (; lower < upper; lower+=PGSIZE) {
f01037fb:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103801:	eb c4                	jmp    f01037c7 <env_create+0x190>
	e->env_tf.tf_eip = elff->e_entry;
f0103803:	8b 45 08             	mov    0x8(%ebp),%eax
f0103806:	8b 40 18             	mov    0x18(%eax),%eax
f0103809:	89 47 30             	mov    %eax,0x30(%edi)
	struct PageInfo* uistack = page_alloc(~ALLOC_ZERO);
f010380c:	83 ec 0c             	sub    $0xc,%esp
f010380f:	6a fe                	push   $0xfffffffe
f0103811:	e8 5f da ff ff       	call   f0101275 <page_alloc>
	assert(uistack != NULL && 0 == page_insert(e->env_pgdir, uistack, (void*)(USTACKTOP-PGSIZE), PTE_W | PTE_U));
f0103816:	83 c4 10             	add    $0x10,%esp
f0103819:	85 c0                	test   %eax,%eax
f010381b:	74 28                	je     f0103845 <env_create+0x20e>
f010381d:	6a 06                	push   $0x6
f010381f:	68 00 d0 bf ee       	push   $0xeebfd000
f0103824:	50                   	push   %eax
f0103825:	ff 77 60             	pushl  0x60(%edi)
f0103828:	e8 6f dd ff ff       	call   f010159c <page_insert>
f010382d:	83 c4 10             	add    $0x10,%esp
f0103830:	85 c0                	test   %eax,%eax
f0103832:	75 11                	jne    f0103845 <env_create+0x20e>
	newenv_store->env_type = type;
f0103834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103837:	8b 55 0c             	mov    0xc(%ebp),%edx
f010383a:	89 50 50             	mov    %edx,0x50(%eax)


}
f010383d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0103840:	5b                   	pop    %ebx
f0103841:	5e                   	pop    %esi
f0103842:	5f                   	pop    %edi
f0103843:	5d                   	pop    %ebp
f0103844:	c3                   	ret    
	assert(uistack != NULL && 0 == page_insert(e->env_pgdir, uistack, (void*)(USTACKTOP-PGSIZE), PTE_W | PTE_U));
f0103845:	68 c4 8b 10 f0       	push   $0xf0108bc4
f010384a:	68 31 78 10 f0       	push   $0xf0107831
f010384f:	68 7b 01 00 00       	push   $0x17b
f0103854:	68 29 8c 10 f0       	push   $0xf0108c29
f0103859:	e8 e5 c7 ff ff       	call   f0100043 <_panic>

f010385e <env_free>:
//
// Frees env e and all memory it uses.
//
void
env_free(struct Env *e)
{
f010385e:	55                   	push   %ebp
f010385f:	89 e5                	mov    %esp,%ebp
f0103861:	57                   	push   %edi
f0103862:	56                   	push   %esi
f0103863:	53                   	push   %ebx
f0103864:	83 ec 1c             	sub    $0x1c,%esp
	physaddr_t pa;

	// If freeing the current environment, switch to kern_pgdir
	// before freeing the page directory, just in case the page
	// gets reused.
	if (e == curenv)
f0103867:	e8 bc 2b 00 00       	call   f0106428 <cpunum>
f010386c:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010386f:	01 c2                	add    %eax,%edx
f0103871:	01 d2                	add    %edx,%edx
f0103873:	01 c2                	add    %eax,%edx
f0103875:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103878:	8b 4d 08             	mov    0x8(%ebp),%ecx
f010387b:	39 0c 85 08 80 2c f0 	cmp    %ecx,-0xfd37ff8(,%eax,4)
f0103882:	74 0c                	je     f0103890 <env_free+0x32>
f0103884:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f010388b:	e9 b5 00 00 00       	jmp    f0103945 <env_free+0xe7>
		lcr3(PADDR(kern_pgdir));
f0103890:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
	if ((uint32_t)kva < KERNBASE)
f0103895:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010389a:	77 15                	ja     f01038b1 <env_free+0x53>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010389c:	50                   	push   %eax
f010389d:	68 ec 77 10 f0       	push   $0xf01077ec
f01038a2:	68 9f 01 00 00       	push   $0x19f
f01038a7:	68 29 8c 10 f0       	push   $0xf0108c29
f01038ac:	e8 92 c7 ff ff       	call   f0100043 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01038b1:	05 00 00 00 10       	add    $0x10000000,%eax
f01038b6:	0f 22 d8             	mov    %eax,%cr3
f01038b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01038c0:	e9 80 00 00 00       	jmp    f0103945 <env_free+0xe7>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01038c5:	50                   	push   %eax
f01038c6:	68 c8 77 10 f0       	push   $0xf01077c8
f01038cb:	68 ae 01 00 00       	push   $0x1ae
f01038d0:	68 29 8c 10 f0       	push   $0xf0108c29
f01038d5:	e8 69 c7 ff ff       	call   f0100043 <_panic>
f01038da:	83 c3 04             	add    $0x4,%ebx
f01038dd:	81 c6 00 10 00 00    	add    $0x1000,%esi
		// find the pa and va of the page table
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
		pt = (pte_t*) KADDR(pa);

		// unmap all PTEs in this page table
		for (pteno = 0; pteno <= PTX(~0); pteno++) {
f01038e3:	39 fb                	cmp    %edi,%ebx
f01038e5:	74 1e                	je     f0103905 <env_free+0xa7>
			if (pt[pteno] & PTE_P)
f01038e7:	f6 03 01             	testb  $0x1,(%ebx)
f01038ea:	74 ee                	je     f01038da <env_free+0x7c>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f01038ec:	83 ec 08             	sub    $0x8,%esp
f01038ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01038f2:	09 f0                	or     %esi,%eax
f01038f4:	50                   	push   %eax
f01038f5:	8b 45 08             	mov    0x8(%ebp),%eax
f01038f8:	ff 70 60             	pushl  0x60(%eax)
f01038fb:	e8 56 dc ff ff       	call   f0101556 <page_remove>
f0103900:	83 c4 10             	add    $0x10,%esp
f0103903:	eb d5                	jmp    f01038da <env_free+0x7c>
		}

		// free the page table itself
		e->env_pgdir[pdeno] = 0;
f0103905:	8b 45 08             	mov    0x8(%ebp),%eax
f0103908:	8b 40 60             	mov    0x60(%eax),%eax
f010390b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010390e:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	if (PGNUM(pa) >= npages)
f0103915:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0103918:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f010391e:	73 6d                	jae    f010398d <env_free+0x12f>
		page_decref(pa2page(pa));
f0103920:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f0103923:	a1 d0 74 2c f0       	mov    0xf02c74d0,%eax
f0103928:	8b 55 dc             	mov    -0x24(%ebp),%edx
f010392b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
f010392e:	50                   	push   %eax
f010392f:	e8 0f da ff ff       	call   f0101343 <page_decref>
f0103934:	83 c4 10             	add    $0x10,%esp
f0103937:	83 45 e0 04          	addl   $0x4,-0x20(%ebp)
f010393b:	8b 45 e0             	mov    -0x20(%ebp),%eax
	for (pdeno = 0; pdeno < PDX(UTOP); pdeno++) {
f010393e:	3d ec 0e 00 00       	cmp    $0xeec,%eax
f0103943:	74 5f                	je     f01039a4 <env_free+0x146>
		if (!(e->env_pgdir[pdeno] & PTE_P))
f0103945:	8b 45 08             	mov    0x8(%ebp),%eax
f0103948:	8b 40 60             	mov    0x60(%eax),%eax
f010394b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010394e:	8b 04 08             	mov    (%eax,%ecx,1),%eax
f0103951:	a8 01                	test   $0x1,%al
f0103953:	74 e2                	je     f0103937 <env_free+0xd9>
		pa = PTE_ADDR(e->env_pgdir[pdeno]);
f0103955:	25 00 f0 ff ff       	and    $0xfffff000,%eax
	if (PGNUM(pa) >= npages)
f010395a:	89 c2                	mov    %eax,%edx
f010395c:	c1 ea 0c             	shr    $0xc,%edx
f010395f:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0103962:	39 15 c8 74 2c f0    	cmp    %edx,0xf02c74c8
f0103968:	0f 86 57 ff ff ff    	jbe    f01038c5 <env_free+0x67>
				page_remove(e->env_pgdir, PGADDR(pdeno, pteno, 0));
f010396e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0103971:	c1 e1 14             	shl    $0x14,%ecx
f0103974:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
f0103977:	8d b8 00 10 00 f0    	lea    -0xffff000(%eax),%edi
f010397d:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
f0103983:	be 00 00 00 00       	mov    $0x0,%esi
f0103988:	e9 5a ff ff ff       	jmp    f01038e7 <env_free+0x89>
		panic("pa2page called with invalid pa");
f010398d:	83 ec 04             	sub    $0x4,%esp
f0103990:	68 a4 7f 10 f0       	push   $0xf0107fa4
f0103995:	68 87 00 00 00       	push   $0x87
f010399a:	68 11 88 10 f0       	push   $0xf0108811
f010399f:	e8 9f c6 ff ff       	call   f0100043 <_panic>
	}

	// free the page directory
	pa = PADDR(e->env_pgdir);
f01039a4:	8b 45 08             	mov    0x8(%ebp),%eax
f01039a7:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f01039aa:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01039af:	76 52                	jbe    f0103a03 <env_free+0x1a5>
	e->env_pgdir = 0;
f01039b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01039b4:	c7 41 60 00 00 00 00 	movl   $0x0,0x60(%ecx)
	return (physaddr_t)kva - KERNBASE;
f01039bb:	05 00 00 00 10       	add    $0x10000000,%eax
	if (PGNUM(pa) >= npages)
f01039c0:	c1 e8 0c             	shr    $0xc,%eax
f01039c3:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f01039c9:	73 4d                	jae    f0103a18 <env_free+0x1ba>
	page_decref(pa2page(pa));
f01039cb:	83 ec 0c             	sub    $0xc,%esp
	return &pages[PGNUM(pa)];
f01039ce:	8b 15 d0 74 2c f0    	mov    0xf02c74d0,%edx
f01039d4:	8d 04 c2             	lea    (%edx,%eax,8),%eax
f01039d7:	50                   	push   %eax
f01039d8:	e8 66 d9 ff ff       	call   f0101343 <page_decref>

	// return the environment to the free list
	e->env_status = ENV_FREE;
f01039dd:	8b 45 08             	mov    0x8(%ebp),%eax
f01039e0:	c7 40 54 00 00 00 00 	movl   $0x0,0x54(%eax)
	e->env_link = env_free_list;
f01039e7:	a1 48 62 2c f0       	mov    0xf02c6248,%eax
f01039ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
f01039ef:	89 41 44             	mov    %eax,0x44(%ecx)
	env_free_list = e;
f01039f2:	89 0d 48 62 2c f0    	mov    %ecx,0xf02c6248
}
f01039f8:	83 c4 10             	add    $0x10,%esp
f01039fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01039fe:	5b                   	pop    %ebx
f01039ff:	5e                   	pop    %esi
f0103a00:	5f                   	pop    %edi
f0103a01:	5d                   	pop    %ebp
f0103a02:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103a03:	50                   	push   %eax
f0103a04:	68 ec 77 10 f0       	push   $0xf01077ec
f0103a09:	68 bc 01 00 00       	push   $0x1bc
f0103a0e:	68 29 8c 10 f0       	push   $0xf0108c29
f0103a13:	e8 2b c6 ff ff       	call   f0100043 <_panic>
		panic("pa2page called with invalid pa");
f0103a18:	83 ec 04             	sub    $0x4,%esp
f0103a1b:	68 a4 7f 10 f0       	push   $0xf0107fa4
f0103a20:	68 87 00 00 00       	push   $0x87
f0103a25:	68 11 88 10 f0       	push   $0xf0108811
f0103a2a:	e8 14 c6 ff ff       	call   f0100043 <_panic>

f0103a2f <env_destroy>:
// If e was the current env, then runs a new environment (and does not return
// to the caller).
//
void
env_destroy(struct Env *e)
{
f0103a2f:	55                   	push   %ebp
f0103a30:	89 e5                	mov    %esp,%ebp
f0103a32:	53                   	push   %ebx
f0103a33:	83 ec 04             	sub    $0x4,%esp
f0103a36:	8b 5d 08             	mov    0x8(%ebp),%ebx
	// If e is currently running on other CPUs, we change its state to
	// ENV_DYING. A zombie environment will be freed the next time
	// it traps to the kernel.
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103a39:	83 7b 54 03          	cmpl   $0x3,0x54(%ebx)
f0103a3d:	74 2b                	je     f0103a6a <env_destroy+0x3b>
		e->env_status = ENV_DYING;
		return;
	}

	env_free(e);
f0103a3f:	83 ec 0c             	sub    $0xc,%esp
f0103a42:	53                   	push   %ebx
f0103a43:	e8 16 fe ff ff       	call   f010385e <env_free>

	if (curenv == e) {
f0103a48:	e8 db 29 00 00       	call   f0106428 <cpunum>
f0103a4d:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103a50:	01 c2                	add    %eax,%edx
f0103a52:	01 d2                	add    %edx,%edx
f0103a54:	01 c2                	add    %eax,%edx
f0103a56:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103a59:	83 c4 10             	add    $0x10,%esp
f0103a5c:	3b 1c 85 08 80 2c f0 	cmp    -0xfd37ff8(,%eax,4),%ebx
f0103a63:	74 28                	je     f0103a8d <env_destroy+0x5e>
		curenv = NULL;
		sched_yield();
	}
}
f0103a65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103a68:	c9                   	leave  
f0103a69:	c3                   	ret    
	if (e->env_status == ENV_RUNNING && curenv != e) {
f0103a6a:	e8 b9 29 00 00       	call   f0106428 <cpunum>
f0103a6f:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103a72:	01 c2                	add    %eax,%edx
f0103a74:	01 d2                	add    %edx,%edx
f0103a76:	01 c2                	add    %eax,%edx
f0103a78:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103a7b:	3b 1c 85 08 80 2c f0 	cmp    -0xfd37ff8(,%eax,4),%ebx
f0103a82:	74 bb                	je     f0103a3f <env_destroy+0x10>
		e->env_status = ENV_DYING;
f0103a84:	c7 43 54 01 00 00 00 	movl   $0x1,0x54(%ebx)
		return;
f0103a8b:	eb d8                	jmp    f0103a65 <env_destroy+0x36>
		curenv = NULL;
f0103a8d:	e8 96 29 00 00       	call   f0106428 <cpunum>
f0103a92:	6b c0 74             	imul   $0x74,%eax,%eax
f0103a95:	c7 80 08 80 2c f0 00 	movl   $0x0,-0xfd37ff8(%eax)
f0103a9c:	00 00 00 
		sched_yield();
f0103a9f:	e8 15 0d 00 00       	call   f01047b9 <sched_yield>

f0103aa4 <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0103aa4:	55                   	push   %ebp
f0103aa5:	89 e5                	mov    %esp,%ebp
f0103aa7:	53                   	push   %ebx
f0103aa8:	83 ec 04             	sub    $0x4,%esp
	// Record the CPU we are running on for user-space debugging
	curenv->env_cpunum = cpunum();
f0103aab:	e8 78 29 00 00       	call   f0106428 <cpunum>
f0103ab0:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103ab3:	01 c2                	add    %eax,%edx
f0103ab5:	01 d2                	add    %edx,%edx
f0103ab7:	01 c2                	add    %eax,%edx
f0103ab9:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103abc:	8b 1c 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%ebx
f0103ac3:	e8 60 29 00 00       	call   f0106428 <cpunum>
f0103ac8:	89 43 5c             	mov    %eax,0x5c(%ebx)

	asm volatile(
f0103acb:	8b 65 08             	mov    0x8(%ebp),%esp
f0103ace:	61                   	popa   
f0103acf:	07                   	pop    %es
f0103ad0:	1f                   	pop    %ds
f0103ad1:	83 c4 08             	add    $0x8,%esp
f0103ad4:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret\n"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0103ad5:	83 ec 04             	sub    $0x4,%esp
f0103ad8:	68 7b 8c 10 f0       	push   $0xf0108c7b
f0103add:	68 f3 01 00 00       	push   $0x1f3
f0103ae2:	68 29 8c 10 f0       	push   $0xf0108c29
f0103ae7:	e8 57 c5 ff ff       	call   f0100043 <_panic>

f0103aec <env_run>:
//
// This function does not return.
//
void
env_run(struct Env *e)
{
f0103aec:	55                   	push   %ebp
f0103aed:	89 e5                	mov    %esp,%ebp
f0103aef:	83 ec 08             	sub    $0x8,%esp
	//	e->env_tf.  Go back through the code you wrote above
	//	and make sure you have set the relevant parts of
	//	e->env_tf to sensible values.

	// LAB 3: Your code here.
	if (curenv != NULL) {
f0103af2:	e8 31 29 00 00       	call   f0106428 <cpunum>
f0103af7:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103afa:	01 c2                	add    %eax,%edx
f0103afc:	01 d2                	add    %edx,%edx
f0103afe:	01 c2                	add    %eax,%edx
f0103b00:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103b03:	83 3c 85 08 80 2c f0 	cmpl   $0x0,-0xfd37ff8(,%eax,4)
f0103b0a:	00 
f0103b0b:	74 22                	je     f0103b2f <env_run+0x43>
		if (curenv->env_status == ENV_RUNNING) {
f0103b0d:	e8 16 29 00 00       	call   f0106428 <cpunum>
f0103b12:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103b15:	01 c2                	add    %eax,%edx
f0103b17:	01 d2                	add    %edx,%edx
f0103b19:	01 c2                	add    %eax,%edx
f0103b1b:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103b1e:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0103b25:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f0103b29:	0f 84 9e 00 00 00    	je     f0103bcd <env_run+0xe1>
			curenv->env_status = ENV_RUNNABLE;
		}
	}
	curenv = e;
f0103b2f:	e8 f4 28 00 00       	call   f0106428 <cpunum>
f0103b34:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103b37:	01 c2                	add    %eax,%edx
f0103b39:	01 d2                	add    %edx,%edx
f0103b3b:	01 c2                	add    %eax,%edx
f0103b3d:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103b40:	8b 55 08             	mov    0x8(%ebp),%edx
f0103b43:	89 14 85 08 80 2c f0 	mov    %edx,-0xfd37ff8(,%eax,4)
	curenv->env_status = ENV_RUNNING;
f0103b4a:	e8 d9 28 00 00       	call   f0106428 <cpunum>
f0103b4f:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103b52:	01 c2                	add    %eax,%edx
f0103b54:	01 d2                	add    %edx,%edx
f0103b56:	01 c2                	add    %eax,%edx
f0103b58:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103b5b:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0103b62:	c7 40 54 03 00 00 00 	movl   $0x3,0x54(%eax)
	curenv->env_runs++;
f0103b69:	e8 ba 28 00 00       	call   f0106428 <cpunum>
f0103b6e:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103b71:	01 c2                	add    %eax,%edx
f0103b73:	01 d2                	add    %edx,%edx
f0103b75:	01 c2                	add    %eax,%edx
f0103b77:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103b7a:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0103b81:	ff 40 58             	incl   0x58(%eax)
}

static inline void
unlock_kernel(void)
{
	spin_unlock(&kernel_lock);
f0103b84:	83 ec 0c             	sub    $0xc,%esp
f0103b87:	68 60 b4 12 f0       	push   $0xf012b460
f0103b8c:	e8 21 2d 00 00       	call   f01068b2 <spin_unlock>

	// Normally we wouldn't need to do this, but QEMU only runs
	// one CPU at a time and has a long time-slice.  Without the
	// pause, this CPU is likely to reacquire the lock before
	// another CPU has even been given a chance to acquire it.
	asm volatile("pause");
f0103b91:	f3 90                	pause  
	unlock_kernel();
	lcr3(PADDR(curenv->env_pgdir)); 
f0103b93:	e8 90 28 00 00       	call   f0106428 <cpunum>
f0103b98:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103b9b:	01 c2                	add    %eax,%edx
f0103b9d:	01 d2                	add    %edx,%edx
f0103b9f:	01 c2                	add    %eax,%edx
f0103ba1:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103ba4:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0103bab:	8b 40 60             	mov    0x60(%eax),%eax
	if ((uint32_t)kva < KERNBASE)
f0103bae:	83 c4 10             	add    $0x10,%esp
f0103bb1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103bb6:	77 2f                	ja     f0103be7 <env_run+0xfb>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103bb8:	50                   	push   %eax
f0103bb9:	68 ec 77 10 f0       	push   $0xf01077ec
f0103bbe:	68 1a 02 00 00       	push   $0x21a
f0103bc3:	68 29 8c 10 f0       	push   $0xf0108c29
f0103bc8:	e8 76 c4 ff ff       	call   f0100043 <_panic>
			curenv->env_status = ENV_RUNNABLE;
f0103bcd:	e8 56 28 00 00       	call   f0106428 <cpunum>
f0103bd2:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bd5:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f0103bdb:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
f0103be2:	e9 48 ff ff ff       	jmp    f0103b2f <env_run+0x43>
	return (physaddr_t)kva - KERNBASE;
f0103be7:	05 00 00 00 10       	add    $0x10000000,%eax
f0103bec:	0f 22 d8             	mov    %eax,%cr3
	
	env_pop_tf(&(curenv->env_tf));
f0103bef:	e8 34 28 00 00       	call   f0106428 <cpunum>
f0103bf4:	83 ec 0c             	sub    $0xc,%esp
f0103bf7:	6b c0 74             	imul   $0x74,%eax,%eax
f0103bfa:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f0103c00:	e8 9f fe ff ff       	call   f0103aa4 <env_pop_tf>

f0103c05 <pic_init>:
}

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f0103c05:	55                   	push   %ebp
f0103c06:	89 e5                	mov    %esp,%ebp
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103c08:	ba 21 00 00 00       	mov    $0x21,%edx
f0103c0d:	b0 ff                	mov    $0xff,%al
f0103c0f:	ee                   	out    %al,(%dx)
f0103c10:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103c15:	ee                   	out    %al,(%dx)
f0103c16:	ba 20 00 00 00       	mov    $0x20,%edx
f0103c1b:	b0 11                	mov    $0x11,%al
f0103c1d:	ee                   	out    %al,(%dx)
f0103c1e:	ba 21 00 00 00       	mov    $0x21,%edx
f0103c23:	b0 20                	mov    $0x20,%al
f0103c25:	ee                   	out    %al,(%dx)
f0103c26:	b0 04                	mov    $0x4,%al
f0103c28:	ee                   	out    %al,(%dx)
f0103c29:	b0 03                	mov    $0x3,%al
f0103c2b:	ee                   	out    %al,(%dx)
f0103c2c:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103c31:	b0 11                	mov    $0x11,%al
f0103c33:	ee                   	out    %al,(%dx)
f0103c34:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103c39:	b0 28                	mov    $0x28,%al
f0103c3b:	ee                   	out    %al,(%dx)
f0103c3c:	b0 02                	mov    $0x2,%al
f0103c3e:	ee                   	out    %al,(%dx)
f0103c3f:	b0 01                	mov    $0x1,%al
f0103c41:	ee                   	out    %al,(%dx)
f0103c42:	ba 20 00 00 00       	mov    $0x20,%edx
f0103c47:	b0 68                	mov    $0x68,%al
f0103c49:	ee                   	out    %al,(%dx)
f0103c4a:	b0 0a                	mov    $0xa,%al
f0103c4c:	ee                   	out    %al,(%dx)
f0103c4d:	ba a0 00 00 00       	mov    $0xa0,%edx
f0103c52:	b0 68                	mov    $0x68,%al
f0103c54:	ee                   	out    %al,(%dx)
f0103c55:	b0 0a                	mov    $0xa,%al
f0103c57:	ee                   	out    %al,(%dx)
f0103c58:	ba 21 00 00 00       	mov    $0x21,%edx
f0103c5d:	b0 fb                	mov    $0xfb,%al
f0103c5f:	ee                   	out    %al,(%dx)
f0103c60:	ba a1 00 00 00       	mov    $0xa1,%edx
f0103c65:	b0 ff                	mov    $0xff,%al
f0103c67:	ee                   	out    %al,(%dx)
	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
	irq_setmask_8259A(0xffff & ~(BIT(IRQ_SLAVE)));
}
f0103c68:	5d                   	pop    %ebp
f0103c69:	c3                   	ret    

f0103c6a <putch>:
#include <inc/stdarg.h>


static void
putch(int ch, int *cnt)
{
f0103c6a:	55                   	push   %ebp
f0103c6b:	89 e5                	mov    %esp,%ebp
f0103c6d:	83 ec 14             	sub    $0x14,%esp
	cputchar(ch);
f0103c70:	ff 75 08             	pushl  0x8(%ebp)
f0103c73:	e8 94 cb ff ff       	call   f010080c <cputchar>
	*cnt++;
}
f0103c78:	83 c4 10             	add    $0x10,%esp
f0103c7b:	c9                   	leave  
f0103c7c:	c3                   	ret    

f0103c7d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
f0103c7d:	55                   	push   %ebp
f0103c7e:	89 e5                	mov    %esp,%ebp
f0103c80:	83 ec 18             	sub    $0x18,%esp
	int cnt = 0;
f0103c83:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	vprintfmt((void*)putch, &cnt, fmt, ap);
f0103c8a:	ff 75 0c             	pushl  0xc(%ebp)
f0103c8d:	ff 75 08             	pushl  0x8(%ebp)
f0103c90:	8d 45 f4             	lea    -0xc(%ebp),%eax
f0103c93:	50                   	push   %eax
f0103c94:	68 6a 3c 10 f0       	push   $0xf0103c6a
f0103c99:	e8 54 19 00 00       	call   f01055f2 <vprintfmt>
	return cnt;
}
f0103c9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0103ca1:	c9                   	leave  
f0103ca2:	c3                   	ret    

f0103ca3 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f0103ca3:	55                   	push   %ebp
f0103ca4:	89 e5                	mov    %esp,%ebp
f0103ca6:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f0103ca9:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
f0103cac:	50                   	push   %eax
f0103cad:	ff 75 08             	pushl  0x8(%ebp)
f0103cb0:	e8 c8 ff ff ff       	call   f0103c7d <vcprintf>
	va_end(ap);

	return cnt;
}
f0103cb5:	c9                   	leave  
f0103cb6:	c3                   	ret    

f0103cb7 <trap_init_percpu>:
}

// Initialize and load the per-CPU TSS and IDT
void
trap_init_percpu(void)
{
f0103cb7:	55                   	push   %ebp
f0103cb8:	89 e5                	mov    %esp,%ebp
f0103cba:	57                   	push   %edi
f0103cbb:	56                   	push   %esi
f0103cbc:	53                   	push   %ebx
f0103cbd:	83 ec 1c             	sub    $0x1c,%esp
	// get a triple fault.  If you set up an individual CPU's TSS
	// wrong, you may not get a fault until you try to return from
	// user space on that CPU.
	//
	// LAB 4: Your code here:
	int cpuid = cpunum();
f0103cc0:	e8 63 27 00 00       	call   f0106428 <cpunum>
f0103cc5:	89 c6                	mov    %eax,%esi
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	thiscpu->cpu_ts.ts_esp0 = KSTACKTOP - cpuid * (KSTKSIZE + KSTKGAP);
f0103cc7:	e8 5c 27 00 00       	call   f0106428 <cpunum>
f0103ccc:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103ccf:	01 c2                	add    %eax,%edx
f0103cd1:	01 d2                	add    %edx,%edx
f0103cd3:	01 c2                	add    %eax,%edx
f0103cd5:	8d 14 90             	lea    (%eax,%edx,4),%edx
f0103cd8:	89 f1                	mov    %esi,%ecx
f0103cda:	c1 e1 10             	shl    $0x10,%ecx
f0103cdd:	b8 00 00 00 f0       	mov    $0xf0000000,%eax
f0103ce2:	29 c8                	sub    %ecx,%eax
f0103ce4:	89 04 95 10 80 2c f0 	mov    %eax,-0xfd37ff0(,%edx,4)
	thiscpu->cpu_ts.ts_ss0 = GD_KD;
f0103ceb:	e8 38 27 00 00       	call   f0106428 <cpunum>
f0103cf0:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103cf3:	01 c2                	add    %eax,%edx
f0103cf5:	01 d2                	add    %edx,%edx
f0103cf7:	01 c2                	add    %eax,%edx
f0103cf9:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103cfc:	66 c7 04 85 14 80 2c 	movw   $0x10,-0xfd37fec(,%eax,4)
f0103d03:	f0 10 00 

	// Initialize the TSS slot of the gdt.
	gdt[(GD_TSS0 >> 3) + cpuid] = SEG16(STS_T32A, (uint32_t) (&thiscpu->cpu_ts),
f0103d06:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f0103d09:	8d 5e 05             	lea    0x5(%esi),%ebx
f0103d0c:	e8 17 27 00 00       	call   f0106428 <cpunum>
f0103d11:	89 c7                	mov    %eax,%edi
f0103d13:	e8 10 27 00 00       	call   f0106428 <cpunum>
f0103d18:	89 c6                	mov    %eax,%esi
f0103d1a:	e8 09 27 00 00       	call   f0106428 <cpunum>
f0103d1f:	66 c7 04 dd 40 b3 12 	movw   $0x67,-0xfed4cc0(,%ebx,8)
f0103d26:	f0 67 00 
f0103d29:	8d 14 3f             	lea    (%edi,%edi,1),%edx
f0103d2c:	01 fa                	add    %edi,%edx
f0103d2e:	01 d2                	add    %edx,%edx
f0103d30:	01 fa                	add    %edi,%edx
f0103d32:	8d 14 97             	lea    (%edi,%edx,4),%edx
f0103d35:	8d 14 95 0c 80 2c f0 	lea    -0xfd37ff4(,%edx,4),%edx
f0103d3c:	66 89 14 dd 42 b3 12 	mov    %dx,-0xfed4cbe(,%ebx,8)
f0103d43:	f0 
f0103d44:	8d 14 36             	lea    (%esi,%esi,1),%edx
f0103d47:	01 f2                	add    %esi,%edx
f0103d49:	01 d2                	add    %edx,%edx
f0103d4b:	01 f2                	add    %esi,%edx
f0103d4d:	8d 14 96             	lea    (%esi,%edx,4),%edx
f0103d50:	8d 14 95 0c 80 2c f0 	lea    -0xfd37ff4(,%edx,4),%edx
f0103d57:	c1 ea 10             	shr    $0x10,%edx
f0103d5a:	88 14 dd 44 b3 12 f0 	mov    %dl,-0xfed4cbc(,%ebx,8)
f0103d61:	c6 04 dd 46 b3 12 f0 	movb   $0x40,-0xfed4cba(,%ebx,8)
f0103d68:	40 
f0103d69:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0103d6c:	01 c2                	add    %eax,%edx
f0103d6e:	01 d2                	add    %edx,%edx
f0103d70:	01 c2                	add    %eax,%edx
f0103d72:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0103d75:	8d 04 85 0c 80 2c f0 	lea    -0xfd37ff4(,%eax,4),%eax
f0103d7c:	c1 e8 18             	shr    $0x18,%eax
f0103d7f:	88 04 dd 47 b3 12 f0 	mov    %al,-0xfed4cb9(,%ebx,8)
					sizeof(struct Taskstate) - 1, 0);
	gdt[(GD_TSS0 >> 3) + cpuid].sd_s = 0;
f0103d86:	c6 04 dd 45 b3 12 f0 	movb   $0x89,-0xfed4cbb(,%ebx,8)
f0103d8d:	89 

	// Load the TSS selector (like other segment selectors, the
	// bottom three bits are special; we leave them 0)
	ltr(((GD_TSS0 >> 3) + cpuid) << 3);
f0103d8e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0103d91:	83 c0 05             	add    $0x5,%eax
f0103d94:	c1 e0 03             	shl    $0x3,%eax
	asm volatile("ltr %0" : : "r" (sel));
f0103d97:	0f 00 d8             	ltr    %ax
	asm volatile("lidt (%0)" : : "r" (p));
f0103d9a:	b8 a8 b3 12 f0       	mov    $0xf012b3a8,%eax
f0103d9f:	0f 01 18             	lidtl  (%eax)

	// Load the IDT
	lidt(&idt_pd);
}
f0103da2:	83 c4 1c             	add    $0x1c,%esp
f0103da5:	5b                   	pop    %ebx
f0103da6:	5e                   	pop    %esi
f0103da7:	5f                   	pop    %edi
f0103da8:	5d                   	pop    %ebp
f0103da9:	c3                   	ret    

f0103daa <trap_init>:
{
f0103daa:	55                   	push   %ebp
f0103dab:	89 e5                	mov    %esp,%ebp
f0103dad:	83 ec 08             	sub    $0x8,%esp
	for (int i = 0; i < 20; i++) {
f0103db0:	b8 00 00 00 00       	mov    $0x0,%eax
			SETGATE(idt[i], 0, GD_KT, ith[i], i == T_BRKPT ? 3 : 0);
f0103db5:	8b 0c 85 ae b3 12 f0 	mov    -0xfed4c52(,%eax,4),%ecx
f0103dbc:	66 89 0c c5 60 62 2c 	mov    %cx,-0xfd39da0(,%eax,8)
f0103dc3:	f0 
f0103dc4:	66 c7 04 c5 62 62 2c 	movw   $0x8,-0xfd39d9e(,%eax,8)
f0103dcb:	f0 08 00 
f0103dce:	c6 04 c5 64 62 2c f0 	movb   $0x0,-0xfd39d9c(,%eax,8)
f0103dd5:	00 
f0103dd6:	83 f8 03             	cmp    $0x3,%eax
f0103dd9:	0f 94 c2             	sete   %dl
f0103ddc:	f7 da                	neg    %edx
f0103dde:	83 e2 03             	and    $0x3,%edx
f0103de1:	c1 e2 05             	shl    $0x5,%edx
f0103de4:	83 ca 8e             	or     $0xffffff8e,%edx
f0103de7:	88 14 c5 65 62 2c f0 	mov    %dl,-0xfd39d9b(,%eax,8)
f0103dee:	c1 e9 10             	shr    $0x10,%ecx
f0103df1:	66 89 0c c5 66 62 2c 	mov    %cx,-0xfd39d9a(,%eax,8)
f0103df8:	f0 
f0103df9:	89 c1                	mov    %eax,%ecx
		if (i > 9 && i < 15) 
f0103dfb:	8d 50 f6             	lea    -0xa(%eax),%edx
f0103dfe:	83 fa 04             	cmp    $0x4,%edx
f0103e01:	76 12                	jbe    f0103e15 <trap_init+0x6b>
		if (i > 15)
f0103e03:	83 f8 0f             	cmp    $0xf,%eax
f0103e06:	7f 43                	jg     f0103e4b <trap_init+0xa1>
	for (int i = 0; i < 20; i++) {
f0103e08:	40                   	inc    %eax
f0103e09:	83 f8 13             	cmp    $0x13,%eax
f0103e0c:	7f 73                	jg     f0103e81 <trap_init+0xd7>
		if (i < 9) 
f0103e0e:	83 f8 08             	cmp    $0x8,%eax
f0103e11:	7f e6                	jg     f0103df9 <trap_init+0x4f>
f0103e13:	eb a0                	jmp    f0103db5 <trap_init+0xb>
			SETGATE(idt[i], 0, GD_KT, ith[i - 1], 0);
f0103e15:	8b 14 85 aa b3 12 f0 	mov    -0xfed4c56(,%eax,4),%edx
f0103e1c:	66 89 14 c5 60 62 2c 	mov    %dx,-0xfd39da0(,%eax,8)
f0103e23:	f0 
f0103e24:	66 c7 04 c5 62 62 2c 	movw   $0x8,-0xfd39d9e(,%eax,8)
f0103e2b:	f0 08 00 
f0103e2e:	c6 04 c5 64 62 2c f0 	movb   $0x0,-0xfd39d9c(,%eax,8)
f0103e35:	00 
f0103e36:	c6 04 c5 65 62 2c f0 	movb   $0x8e,-0xfd39d9b(,%eax,8)
f0103e3d:	8e 
f0103e3e:	c1 ea 10             	shr    $0x10,%edx
f0103e41:	66 89 14 c5 66 62 2c 	mov    %dx,-0xfd39d9a(,%eax,8)
f0103e48:	f0 
f0103e49:	eb b8                	jmp    f0103e03 <trap_init+0x59>
			SETGATE(idt[i], 0, GD_KT, ith[i - 2], 0);
f0103e4b:	8b 14 8d a6 b3 12 f0 	mov    -0xfed4c5a(,%ecx,4),%edx
f0103e52:	66 89 14 c5 60 62 2c 	mov    %dx,-0xfd39da0(,%eax,8)
f0103e59:	f0 
f0103e5a:	66 c7 04 c5 62 62 2c 	movw   $0x8,-0xfd39d9e(,%eax,8)
f0103e61:	f0 08 00 
f0103e64:	c6 04 c5 64 62 2c f0 	movb   $0x0,-0xfd39d9c(,%eax,8)
f0103e6b:	00 
f0103e6c:	c6 04 c5 65 62 2c f0 	movb   $0x8e,-0xfd39d9b(,%eax,8)
f0103e73:	8e 
f0103e74:	c1 ea 10             	shr    $0x10,%edx
f0103e77:	66 89 14 c5 66 62 2c 	mov    %dx,-0xfd39d9a(,%eax,8)
f0103e7e:	f0 
f0103e7f:	eb 87                	jmp    f0103e08 <trap_init+0x5e>
f0103e81:	b8 20 00 00 00       	mov    $0x20,%eax
      SETGATE(idt[IRQ_OFFSET + i], 0, GD_KT, ith[i + 18], 0);
f0103e86:	8b 14 85 76 b3 12 f0 	mov    -0xfed4c8a(,%eax,4),%edx
f0103e8d:	66 89 14 c5 60 62 2c 	mov    %dx,-0xfd39da0(,%eax,8)
f0103e94:	f0 
f0103e95:	66 c7 04 c5 62 62 2c 	movw   $0x8,-0xfd39d9e(,%eax,8)
f0103e9c:	f0 08 00 
f0103e9f:	c6 04 c5 64 62 2c f0 	movb   $0x0,-0xfd39d9c(,%eax,8)
f0103ea6:	00 
f0103ea7:	c6 04 c5 65 62 2c f0 	movb   $0x8e,-0xfd39d9b(,%eax,8)
f0103eae:	8e 
f0103eaf:	c1 ea 10             	shr    $0x10,%edx
f0103eb2:	66 89 14 c5 66 62 2c 	mov    %dx,-0xfd39d9a(,%eax,8)
f0103eb9:	f0 
f0103eba:	40                   	inc    %eax
    for (int i = 0; i < 16; i++)
f0103ebb:	83 f8 30             	cmp    $0x30,%eax
f0103ebe:	75 c6                	jne    f0103e86 <trap_init+0xdc>
    SETGATE(idt[48], 0, GD_KT, ith[34], 3);
f0103ec0:	a1 36 b4 12 f0       	mov    0xf012b436,%eax
f0103ec5:	66 a3 e0 63 2c f0    	mov    %ax,0xf02c63e0
f0103ecb:	66 c7 05 e2 63 2c f0 	movw   $0x8,0xf02c63e2
f0103ed2:	08 00 
f0103ed4:	c6 05 e4 63 2c f0 00 	movb   $0x0,0xf02c63e4
f0103edb:	c6 05 e5 63 2c f0 ee 	movb   $0xee,0xf02c63e5
f0103ee2:	c1 e8 10             	shr    $0x10,%eax
f0103ee5:	66 a3 e6 63 2c f0    	mov    %ax,0xf02c63e6
    SETGATE(idt[51], 0, GD_KT, ith[35], 0);
f0103eeb:	a1 3a b4 12 f0       	mov    0xf012b43a,%eax
f0103ef0:	66 a3 f8 63 2c f0    	mov    %ax,0xf02c63f8
f0103ef6:	66 c7 05 fa 63 2c f0 	movw   $0x8,0xf02c63fa
f0103efd:	08 00 
f0103eff:	c6 05 fc 63 2c f0 00 	movb   $0x0,0xf02c63fc
f0103f06:	c6 05 fd 63 2c f0 8e 	movb   $0x8e,0xf02c63fd
f0103f0d:	c1 e8 10             	shr    $0x10,%eax
f0103f10:	66 a3 fe 63 2c f0    	mov    %ax,0xf02c63fe
    SETGATE(idt[500], 0, GD_KT, ith[36], 0);
f0103f16:	a1 3e b4 12 f0       	mov    0xf012b43e,%eax
f0103f1b:	66 a3 00 72 2c f0    	mov    %ax,0xf02c7200
f0103f21:	66 c7 05 02 72 2c f0 	movw   $0x8,0xf02c7202
f0103f28:	08 00 
f0103f2a:	c6 05 04 72 2c f0 00 	movb   $0x0,0xf02c7204
f0103f31:	c6 05 05 72 2c f0 8e 	movb   $0x8e,0xf02c7205
f0103f38:	c1 e8 10             	shr    $0x10,%eax
f0103f3b:	66 a3 06 72 2c f0    	mov    %ax,0xf02c7206
	trap_init_percpu();
f0103f41:	e8 71 fd ff ff       	call   f0103cb7 <trap_init_percpu>
}
f0103f46:	c9                   	leave  
f0103f47:	c3                   	ret    

f0103f48 <print_regs>:
	}
}

void
print_regs(struct PushRegs *regs)
{
f0103f48:	55                   	push   %ebp
f0103f49:	89 e5                	mov    %esp,%ebp
f0103f4b:	53                   	push   %ebx
f0103f4c:	83 ec 0c             	sub    $0xc,%esp
f0103f4f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("  edi  0x%08x\n", regs->reg_edi);
f0103f52:	ff 33                	pushl  (%ebx)
f0103f54:	68 87 8c 10 f0       	push   $0xf0108c87
f0103f59:	e8 45 fd ff ff       	call   f0103ca3 <cprintf>
	cprintf("  esi  0x%08x\n", regs->reg_esi);
f0103f5e:	83 c4 08             	add    $0x8,%esp
f0103f61:	ff 73 04             	pushl  0x4(%ebx)
f0103f64:	68 96 8c 10 f0       	push   $0xf0108c96
f0103f69:	e8 35 fd ff ff       	call   f0103ca3 <cprintf>
	cprintf("  ebp  0x%08x\n", regs->reg_ebp);
f0103f6e:	83 c4 08             	add    $0x8,%esp
f0103f71:	ff 73 08             	pushl  0x8(%ebx)
f0103f74:	68 a5 8c 10 f0       	push   $0xf0108ca5
f0103f79:	e8 25 fd ff ff       	call   f0103ca3 <cprintf>
	cprintf("  oesp 0x%08x\n", regs->reg_oesp);
f0103f7e:	83 c4 08             	add    $0x8,%esp
f0103f81:	ff 73 0c             	pushl  0xc(%ebx)
f0103f84:	68 b4 8c 10 f0       	push   $0xf0108cb4
f0103f89:	e8 15 fd ff ff       	call   f0103ca3 <cprintf>
	cprintf("  ebx  0x%08x\n", regs->reg_ebx);
f0103f8e:	83 c4 08             	add    $0x8,%esp
f0103f91:	ff 73 10             	pushl  0x10(%ebx)
f0103f94:	68 c3 8c 10 f0       	push   $0xf0108cc3
f0103f99:	e8 05 fd ff ff       	call   f0103ca3 <cprintf>
	cprintf("  edx  0x%08x\n", regs->reg_edx);
f0103f9e:	83 c4 08             	add    $0x8,%esp
f0103fa1:	ff 73 14             	pushl  0x14(%ebx)
f0103fa4:	68 d2 8c 10 f0       	push   $0xf0108cd2
f0103fa9:	e8 f5 fc ff ff       	call   f0103ca3 <cprintf>
	cprintf("  ecx  0x%08x\n", regs->reg_ecx);
f0103fae:	83 c4 08             	add    $0x8,%esp
f0103fb1:	ff 73 18             	pushl  0x18(%ebx)
f0103fb4:	68 e1 8c 10 f0       	push   $0xf0108ce1
f0103fb9:	e8 e5 fc ff ff       	call   f0103ca3 <cprintf>
	cprintf("  eax  0x%08x\n", regs->reg_eax);
f0103fbe:	83 c4 08             	add    $0x8,%esp
f0103fc1:	ff 73 1c             	pushl  0x1c(%ebx)
f0103fc4:	68 f0 8c 10 f0       	push   $0xf0108cf0
f0103fc9:	e8 d5 fc ff ff       	call   f0103ca3 <cprintf>
}
f0103fce:	83 c4 10             	add    $0x10,%esp
f0103fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0103fd4:	c9                   	leave  
f0103fd5:	c3                   	ret    

f0103fd6 <print_trapframe>:
{
f0103fd6:	55                   	push   %ebp
f0103fd7:	89 e5                	mov    %esp,%ebp
f0103fd9:	53                   	push   %ebx
f0103fda:	83 ec 04             	sub    $0x4,%esp
f0103fdd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("TRAP frame at %p from CPU %d\n", tf, cpunum());
f0103fe0:	e8 43 24 00 00       	call   f0106428 <cpunum>
f0103fe5:	83 ec 04             	sub    $0x4,%esp
f0103fe8:	50                   	push   %eax
f0103fe9:	53                   	push   %ebx
f0103fea:	68 54 8d 10 f0       	push   $0xf0108d54
f0103fef:	e8 af fc ff ff       	call   f0103ca3 <cprintf>
	print_regs(&tf->tf_regs);
f0103ff4:	89 1c 24             	mov    %ebx,(%esp)
f0103ff7:	e8 4c ff ff ff       	call   f0103f48 <print_regs>
	cprintf("  es   0x----%04x\n", tf->tf_es);
f0103ffc:	83 c4 08             	add    $0x8,%esp
f0103fff:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0104003:	50                   	push   %eax
f0104004:	68 72 8d 10 f0       	push   $0xf0108d72
f0104009:	e8 95 fc ff ff       	call   f0103ca3 <cprintf>
	cprintf("  ds   0x----%04x\n", tf->tf_ds);
f010400e:	83 c4 08             	add    $0x8,%esp
f0104011:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0104015:	50                   	push   %eax
f0104016:	68 85 8d 10 f0       	push   $0xf0108d85
f010401b:	e8 83 fc ff ff       	call   f0103ca3 <cprintf>
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0104020:	8b 43 28             	mov    0x28(%ebx),%eax
	if (trapno < ARRAY_SIZE(excnames))
f0104023:	83 c4 10             	add    $0x10,%esp
f0104026:	83 f8 13             	cmp    $0x13,%eax
f0104029:	76 1c                	jbe    f0104047 <print_trapframe+0x71>
	if (trapno == T_SYSCALL)
f010402b:	83 f8 30             	cmp    $0x30,%eax
f010402e:	0f 84 a9 00 00 00    	je     f01040dd <print_trapframe+0x107>
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0104034:	8d 50 e0             	lea    -0x20(%eax),%edx
f0104037:	83 fa 0f             	cmp    $0xf,%edx
f010403a:	0f 86 a7 00 00 00    	jbe    f01040e7 <print_trapframe+0x111>
	return "(unknown trap)";
f0104040:	ba 1e 8d 10 f0       	mov    $0xf0108d1e,%edx
f0104045:	eb 07                	jmp    f010404e <print_trapframe+0x78>
		return excnames[trapno];
f0104047:	8b 14 85 20 90 10 f0 	mov    -0xfef6fe0(,%eax,4),%edx
	cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f010404e:	83 ec 04             	sub    $0x4,%esp
f0104051:	52                   	push   %edx
f0104052:	50                   	push   %eax
f0104053:	68 98 8d 10 f0       	push   $0xf0108d98
f0104058:	e8 46 fc ff ff       	call   f0103ca3 <cprintf>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f010405d:	83 c4 10             	add    $0x10,%esp
f0104060:	3b 1d 60 6a 2c f0    	cmp    0xf02c6a60,%ebx
f0104066:	0f 84 85 00 00 00    	je     f01040f1 <print_trapframe+0x11b>
	cprintf("  err  0x%08x", tf->tf_err);
f010406c:	83 ec 08             	sub    $0x8,%esp
f010406f:	ff 73 2c             	pushl  0x2c(%ebx)
f0104072:	68 b9 8d 10 f0       	push   $0xf0108db9
f0104077:	e8 27 fc ff ff       	call   f0103ca3 <cprintf>
	if (tf->tf_trapno == T_PGFLT)
f010407c:	83 c4 10             	add    $0x10,%esp
f010407f:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0104083:	0f 84 8b 00 00 00    	je     f0104114 <print_trapframe+0x13e>
		cprintf("\n");
f0104089:	83 ec 0c             	sub    $0xc,%esp
f010408c:	68 ec 8a 10 f0       	push   $0xf0108aec
f0104091:	e8 0d fc ff ff       	call   f0103ca3 <cprintf>
f0104096:	83 c4 10             	add    $0x10,%esp
	cprintf("  eip  0x%08x\n", tf->tf_eip);
f0104099:	83 ec 08             	sub    $0x8,%esp
f010409c:	ff 73 30             	pushl  0x30(%ebx)
f010409f:	68 d6 8d 10 f0       	push   $0xf0108dd6
f01040a4:	e8 fa fb ff ff       	call   f0103ca3 <cprintf>
	cprintf("  cs   0x----%04x\n", tf->tf_cs);
f01040a9:	83 c4 08             	add    $0x8,%esp
f01040ac:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f01040b0:	50                   	push   %eax
f01040b1:	68 e5 8d 10 f0       	push   $0xf0108de5
f01040b6:	e8 e8 fb ff ff       	call   f0103ca3 <cprintf>
	cprintf("  flag 0x%08x\n", tf->tf_eflags);
f01040bb:	83 c4 08             	add    $0x8,%esp
f01040be:	ff 73 38             	pushl  0x38(%ebx)
f01040c1:	68 f8 8d 10 f0       	push   $0xf0108df8
f01040c6:	e8 d8 fb ff ff       	call   f0103ca3 <cprintf>
	if ((tf->tf_cs & 3) != 0) {
f01040cb:	83 c4 10             	add    $0x10,%esp
f01040ce:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f01040d2:	0f 85 84 00 00 00    	jne    f010415c <print_trapframe+0x186>
}
f01040d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01040db:	c9                   	leave  
f01040dc:	c3                   	ret    
		return "System call";
f01040dd:	ba ff 8c 10 f0       	mov    $0xf0108cff,%edx
f01040e2:	e9 67 ff ff ff       	jmp    f010404e <print_trapframe+0x78>
		return "Hardware Interrupt";
f01040e7:	ba 0b 8d 10 f0       	mov    $0xf0108d0b,%edx
f01040ec:	e9 5d ff ff ff       	jmp    f010404e <print_trapframe+0x78>
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f01040f1:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f01040f5:	0f 85 71 ff ff ff    	jne    f010406c <print_trapframe+0x96>
	asm volatile("movl %%cr2,%0" : "=r" (val));
f01040fb:	0f 20 d0             	mov    %cr2,%eax
		cprintf("  cr2  0x%08x\n", rcr2());
f01040fe:	83 ec 08             	sub    $0x8,%esp
f0104101:	50                   	push   %eax
f0104102:	68 aa 8d 10 f0       	push   $0xf0108daa
f0104107:	e8 97 fb ff ff       	call   f0103ca3 <cprintf>
f010410c:	83 c4 10             	add    $0x10,%esp
f010410f:	e9 58 ff ff ff       	jmp    f010406c <print_trapframe+0x96>
			tf->tf_err & 1 ? "protection" : "not-present");
f0104114:	8b 43 2c             	mov    0x2c(%ebx),%eax
		cprintf(" [%s, %s, %s]\n",
f0104117:	a8 01                	test   $0x1,%al
f0104119:	75 2c                	jne    f0104147 <print_trapframe+0x171>
f010411b:	b9 38 8d 10 f0       	mov    $0xf0108d38,%ecx
f0104120:	a8 02                	test   $0x2,%al
f0104122:	75 2a                	jne    f010414e <print_trapframe+0x178>
f0104124:	ba 4a 8d 10 f0       	mov    $0xf0108d4a,%edx
f0104129:	a8 04                	test   $0x4,%al
f010412b:	75 28                	jne    f0104155 <print_trapframe+0x17f>
f010412d:	b8 99 8e 10 f0       	mov    $0xf0108e99,%eax
f0104132:	51                   	push   %ecx
f0104133:	52                   	push   %edx
f0104134:	50                   	push   %eax
f0104135:	68 c7 8d 10 f0       	push   $0xf0108dc7
f010413a:	e8 64 fb ff ff       	call   f0103ca3 <cprintf>
f010413f:	83 c4 10             	add    $0x10,%esp
f0104142:	e9 52 ff ff ff       	jmp    f0104099 <print_trapframe+0xc3>
f0104147:	b9 2d 8d 10 f0       	mov    $0xf0108d2d,%ecx
f010414c:	eb d2                	jmp    f0104120 <print_trapframe+0x14a>
f010414e:	ba 44 8d 10 f0       	mov    $0xf0108d44,%edx
f0104153:	eb d4                	jmp    f0104129 <print_trapframe+0x153>
f0104155:	b8 4f 8d 10 f0       	mov    $0xf0108d4f,%eax
f010415a:	eb d6                	jmp    f0104132 <print_trapframe+0x15c>
		cprintf("  esp  0x%08x\n", tf->tf_esp);
f010415c:	83 ec 08             	sub    $0x8,%esp
f010415f:	ff 73 3c             	pushl  0x3c(%ebx)
f0104162:	68 07 8e 10 f0       	push   $0xf0108e07
f0104167:	e8 37 fb ff ff       	call   f0103ca3 <cprintf>
		cprintf("  ss   0x----%04x\n", tf->tf_ss);
f010416c:	83 c4 08             	add    $0x8,%esp
f010416f:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0104173:	50                   	push   %eax
f0104174:	68 16 8e 10 f0       	push   $0xf0108e16
f0104179:	e8 25 fb ff ff       	call   f0103ca3 <cprintf>
f010417e:	83 c4 10             	add    $0x10,%esp
}
f0104181:	e9 52 ff ff ff       	jmp    f01040d8 <print_trapframe+0x102>

f0104186 <page_fault_handler>:
}


void
page_fault_handler(struct Trapframe *tf)
{
f0104186:	55                   	push   %ebp
f0104187:	89 e5                	mov    %esp,%ebp
f0104189:	57                   	push   %edi
f010418a:	56                   	push   %esi
f010418b:	53                   	push   %ebx
f010418c:	83 ec 0c             	sub    $0xc,%esp
f010418f:	8b 5d 08             	mov    0x8(%ebp),%ebx
f0104192:	0f 20 d6             	mov    %cr2,%esi
	fault_va = rcr2();

	// Handle kernel-mode page faults.

	// LAB 3: Your code here.
	assert((tf->tf_cs & 3) == 3);
f0104195:	66 8b 43 34          	mov    0x34(%ebx),%ax
f0104199:	83 e0 03             	and    $0x3,%eax
f010419c:	66 83 f8 03          	cmp    $0x3,%ax
f01041a0:	75 7b                	jne    f010421d <page_fault_handler+0x97>
	//   user_mem_assert() and env_run() are useful here.
	//   To change what the user environment runs, modify 'curenv->env_tf'
	//   (the 'tf' variable points at 'curenv->env_tf').

	// LAB 4: Your code here.
    if (curenv->env_pgfault_upcall) {
f01041a2:	e8 81 22 00 00       	call   f0106428 <cpunum>
f01041a7:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01041aa:	01 c2                	add    %eax,%edx
f01041ac:	01 d2                	add    %edx,%edx
f01041ae:	01 c2                	add    %eax,%edx
f01041b0:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01041b3:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f01041ba:	83 78 64 00          	cmpl   $0x0,0x64(%eax)
f01041be:	75 76                	jne    f0104236 <page_fault_handler+0xb0>
		curenv->env_tf.tf_esp = (uintptr_t) utf;
		env_run(curenv);
    }
	
	// Destroy the environment that caused the fault.
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01041c0:	8b 7b 30             	mov    0x30(%ebx),%edi
		curenv->env_id, fault_va, tf->tf_eip);
f01041c3:	e8 60 22 00 00       	call   f0106428 <cpunum>
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01041c8:	57                   	push   %edi
f01041c9:	56                   	push   %esi
		curenv->env_id, fault_va, tf->tf_eip);
f01041ca:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01041cd:	01 c2                	add    %eax,%edx
f01041cf:	01 d2                	add    %edx,%edx
f01041d1:	01 c2                	add    %eax,%edx
f01041d3:	8d 04 90             	lea    (%eax,%edx,4),%eax
	cprintf("[%08x] user fault va %08x ip %08x\n",
f01041d6:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f01041dd:	ff 70 48             	pushl  0x48(%eax)
f01041e0:	68 e4 8f 10 f0       	push   $0xf0108fe4
f01041e5:	e8 b9 fa ff ff       	call   f0103ca3 <cprintf>
	print_trapframe(tf);
f01041ea:	89 1c 24             	mov    %ebx,(%esp)
f01041ed:	e8 e4 fd ff ff       	call   f0103fd6 <print_trapframe>
	env_destroy(curenv);
f01041f2:	e8 31 22 00 00       	call   f0106428 <cpunum>
f01041f7:	83 c4 04             	add    $0x4,%esp
f01041fa:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01041fd:	01 c2                	add    %eax,%edx
f01041ff:	01 d2                	add    %edx,%edx
f0104201:	01 c2                	add    %eax,%edx
f0104203:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104206:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f010420d:	e8 1d f8 ff ff       	call   f0103a2f <env_destroy>
}
f0104212:	83 c4 10             	add    $0x10,%esp
f0104215:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0104218:	5b                   	pop    %ebx
f0104219:	5e                   	pop    %esi
f010421a:	5f                   	pop    %edi
f010421b:	5d                   	pop    %ebp
f010421c:	c3                   	ret    
	assert((tf->tf_cs & 3) == 3);
f010421d:	68 29 8e 10 f0       	push   $0xf0108e29
f0104222:	68 31 78 10 f0       	push   $0xf0107831
f0104227:	68 b1 01 00 00       	push   $0x1b1
f010422c:	68 3e 8e 10 f0       	push   $0xf0108e3e
f0104231:	e8 0d be ff ff       	call   f0100043 <_panic>
    	if (tf->tf_esp >= UXSTACKTOP-PGSIZE && tf->tf_esp <= UXSTACKTOP - 1) {
f0104236:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104239:	8d 90 00 10 40 11    	lea    0x11401000(%eax),%edx
    		utf = (struct UTrapframe *) (UXSTACKTOP - sizeof(struct UTrapframe));
f010423f:	bf cc ff bf ee       	mov    $0xeebfffcc,%edi
    	if (tf->tf_esp >= UXSTACKTOP-PGSIZE && tf->tf_esp <= UXSTACKTOP - 1) {
f0104244:	81 fa ff 0f 00 00    	cmp    $0xfff,%edx
f010424a:	77 05                	ja     f0104251 <page_fault_handler+0xcb>
    		utf = (struct UTrapframe *) (tf->tf_esp - 4 - sizeof(struct UTrapframe));
f010424c:	83 e8 38             	sub    $0x38,%eax
f010424f:	89 c7                	mov    %eax,%edi
    	user_mem_assert(curenv, (void *) utf, sizeof(struct UTrapframe), PTE_W);
f0104251:	e8 d2 21 00 00       	call   f0106428 <cpunum>
f0104256:	6a 02                	push   $0x2
f0104258:	6a 34                	push   $0x34
f010425a:	57                   	push   %edi
f010425b:	6b c0 74             	imul   $0x74,%eax,%eax
f010425e:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f0104264:	e8 d7 f0 ff ff       	call   f0103340 <user_mem_assert>
		utf->utf_fault_va = fault_va;
f0104269:	89 37                	mov    %esi,(%edi)
		utf->utf_err = tf->tf_err;
f010426b:	8b 43 2c             	mov    0x2c(%ebx),%eax
f010426e:	89 fa                	mov    %edi,%edx
f0104270:	89 47 04             	mov    %eax,0x4(%edi)
		utf->utf_regs = tf->tf_regs;
f0104273:	8d 7f 08             	lea    0x8(%edi),%edi
f0104276:	b9 08 00 00 00       	mov    $0x8,%ecx
f010427b:	89 de                	mov    %ebx,%esi
f010427d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		utf->utf_eip = tf->tf_eip;
f010427f:	8b 43 30             	mov    0x30(%ebx),%eax
f0104282:	89 42 28             	mov    %eax,0x28(%edx)
		utf->utf_eflags = tf->tf_eflags;
f0104285:	8b 43 38             	mov    0x38(%ebx),%eax
f0104288:	89 d7                	mov    %edx,%edi
f010428a:	89 42 2c             	mov    %eax,0x2c(%edx)
		utf->utf_esp = tf->tf_esp;
f010428d:	8b 43 3c             	mov    0x3c(%ebx),%eax
f0104290:	89 42 30             	mov    %eax,0x30(%edx)
		curenv->env_tf.tf_eip = (uintptr_t) curenv->env_pgfault_upcall;
f0104293:	e8 90 21 00 00       	call   f0106428 <cpunum>
f0104298:	6b c0 74             	imul   $0x74,%eax,%eax
f010429b:	8b 98 08 80 2c f0    	mov    -0xfd37ff8(%eax),%ebx
f01042a1:	e8 82 21 00 00       	call   f0106428 <cpunum>
f01042a6:	6b c0 74             	imul   $0x74,%eax,%eax
f01042a9:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f01042af:	8b 40 64             	mov    0x64(%eax),%eax
f01042b2:	89 43 30             	mov    %eax,0x30(%ebx)
		curenv->env_tf.tf_esp = (uintptr_t) utf;
f01042b5:	e8 6e 21 00 00       	call   f0106428 <cpunum>
f01042ba:	6b c0 74             	imul   $0x74,%eax,%eax
f01042bd:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f01042c3:	89 78 3c             	mov    %edi,0x3c(%eax)
		env_run(curenv);
f01042c6:	e8 5d 21 00 00       	call   f0106428 <cpunum>
f01042cb:	83 c4 04             	add    $0x4,%esp
f01042ce:	6b c0 74             	imul   $0x74,%eax,%eax
f01042d1:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f01042d7:	e8 10 f8 ff ff       	call   f0103aec <env_run>

f01042dc <trap>:
{
f01042dc:	55                   	push   %ebp
f01042dd:	89 e5                	mov    %esp,%ebp
f01042df:	57                   	push   %edi
f01042e0:	56                   	push   %esi
f01042e1:	8b 75 08             	mov    0x8(%ebp),%esi
	asm volatile("cld" ::: "cc");
f01042e4:	fc                   	cld    
	if (panicstr)
f01042e5:	83 3d a4 6f 2c f0 00 	cmpl   $0x0,0xf02c6fa4
f01042ec:	74 01                	je     f01042ef <trap+0x13>
		asm volatile("hlt");
f01042ee:	f4                   	hlt    
	if (xchg(&thiscpu->cpu_status, CPU_STARTED) == CPU_HALTED)
f01042ef:	e8 34 21 00 00       	call   f0106428 <cpunum>
f01042f4:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01042f7:	01 c2                	add    %eax,%edx
f01042f9:	01 d2                	add    %edx,%edx
f01042fb:	01 c2                	add    %eax,%edx
f01042fd:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104300:	8d 14 85 04 00 00 00 	lea    0x4(,%eax,4),%edx
	asm volatile("lock; xchgl %0, %1"
f0104307:	b8 01 00 00 00       	mov    $0x1,%eax
f010430c:	f0 87 82 00 80 2c f0 	lock xchg %eax,-0xfd38000(%edx)
f0104313:	83 f8 02             	cmp    $0x2,%eax
f0104316:	0f 84 c2 00 00 00    	je     f01043de <trap+0x102>
	asm volatile("pushfl; popl %0" : "=r" (eflags));
f010431c:	9c                   	pushf  
f010431d:	58                   	pop    %eax
	assert(!(read_eflags() & FL_IF));
f010431e:	f6 c4 02             	test   $0x2,%ah
f0104321:	0f 85 cc 00 00 00    	jne    f01043f3 <trap+0x117>
	if ((tf->tf_cs & 3) == 3) {
f0104327:	66 8b 46 34          	mov    0x34(%esi),%ax
f010432b:	83 e0 03             	and    $0x3,%eax
f010432e:	66 83 f8 03          	cmp    $0x3,%ax
f0104332:	0f 84 d4 00 00 00    	je     f010440c <trap+0x130>
	last_tf = tf;
f0104338:	89 35 60 6a 2c f0    	mov    %esi,0xf02c6a60
	if (tf->tf_trapno == T_PGFLT) {
f010433e:	8b 46 28             	mov    0x28(%esi),%eax
f0104341:	83 f8 0e             	cmp    $0xe,%eax
f0104344:	0f 84 67 01 00 00    	je     f01044b1 <trap+0x1d5>
	if (tf->tf_trapno == T_BRKPT) {
f010434a:	83 f8 03             	cmp    $0x3,%eax
f010434d:	0f 84 6f 01 00 00    	je     f01044c2 <trap+0x1e6>
	if (tf->tf_trapno == T_SYSCALL) {
f0104353:	83 f8 30             	cmp    $0x30,%eax
f0104356:	0f 84 77 01 00 00    	je     f01044d3 <trap+0x1f7>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f010435c:	83 f8 27             	cmp    $0x27,%eax
f010435f:	0f 84 92 01 00 00    	je     f01044f7 <trap+0x21b>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_TIMER) {
f0104365:	83 f8 20             	cmp    $0x20,%eax
f0104368:	0f 84 a6 01 00 00    	je     f0104514 <trap+0x238>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_KBD) {
f010436e:	83 f8 21             	cmp    $0x21,%eax
f0104371:	0f 84 ac 01 00 00    	je     f0104523 <trap+0x247>
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SERIAL) {
f0104377:	83 f8 24             	cmp    $0x24,%eax
f010437a:	0f 84 ad 01 00 00    	je     f010452d <trap+0x251>
	print_trapframe(tf);
f0104380:	83 ec 0c             	sub    $0xc,%esp
f0104383:	56                   	push   %esi
f0104384:	e8 4d fc ff ff       	call   f0103fd6 <print_trapframe>
	if (tf->tf_cs == GD_KT)
f0104389:	83 c4 10             	add    $0x10,%esp
f010438c:	66 83 7e 34 08       	cmpw   $0x8,0x34(%esi)
f0104391:	0f 84 a0 01 00 00    	je     f0104537 <trap+0x25b>
		env_destroy(curenv);
f0104397:	e8 8c 20 00 00       	call   f0106428 <cpunum>
f010439c:	83 ec 0c             	sub    $0xc,%esp
f010439f:	6b c0 74             	imul   $0x74,%eax,%eax
f01043a2:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f01043a8:	e8 82 f6 ff ff       	call   f0103a2f <env_destroy>
f01043ad:	83 c4 10             	add    $0x10,%esp
	if (curenv && curenv->env_status == ENV_RUNNING)
f01043b0:	e8 73 20 00 00       	call   f0106428 <cpunum>
f01043b5:	6b c0 74             	imul   $0x74,%eax,%eax
f01043b8:	83 b8 08 80 2c f0 00 	cmpl   $0x0,-0xfd37ff8(%eax)
f01043bf:	74 18                	je     f01043d9 <trap+0xfd>
f01043c1:	e8 62 20 00 00       	call   f0106428 <cpunum>
f01043c6:	6b c0 74             	imul   $0x74,%eax,%eax
f01043c9:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f01043cf:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f01043d3:	0f 84 75 01 00 00    	je     f010454e <trap+0x272>
		sched_yield();
f01043d9:	e8 db 03 00 00       	call   f01047b9 <sched_yield>
	spin_lock(&kernel_lock);
f01043de:	83 ec 0c             	sub    $0xc,%esp
f01043e1:	68 60 b4 12 f0       	push   $0xf012b460
f01043e6:	e8 1a 24 00 00       	call   f0106805 <spin_lock>
f01043eb:	83 c4 10             	add    $0x10,%esp
f01043ee:	e9 29 ff ff ff       	jmp    f010431c <trap+0x40>
	assert(!(read_eflags() & FL_IF));
f01043f3:	68 4a 8e 10 f0       	push   $0xf0108e4a
f01043f8:	68 31 78 10 f0       	push   $0xf0107831
f01043fd:	68 7e 01 00 00       	push   $0x17e
f0104402:	68 3e 8e 10 f0       	push   $0xf0108e3e
f0104407:	e8 37 bc ff ff       	call   f0100043 <_panic>
		assert(curenv);
f010440c:	e8 17 20 00 00       	call   f0106428 <cpunum>
f0104411:	6b c0 74             	imul   $0x74,%eax,%eax
f0104414:	83 b8 08 80 2c f0 00 	cmpl   $0x0,-0xfd37ff8(%eax)
f010441b:	74 4e                	je     f010446b <trap+0x18f>
f010441d:	83 ec 0c             	sub    $0xc,%esp
f0104420:	68 60 b4 12 f0       	push   $0xf012b460
f0104425:	e8 db 23 00 00       	call   f0106805 <spin_lock>
		if (curenv->env_status == ENV_DYING) {
f010442a:	e8 f9 1f 00 00       	call   f0106428 <cpunum>
f010442f:	6b c0 74             	imul   $0x74,%eax,%eax
f0104432:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f0104438:	83 c4 10             	add    $0x10,%esp
f010443b:	83 78 54 01          	cmpl   $0x1,0x54(%eax)
f010443f:	74 43                	je     f0104484 <trap+0x1a8>
		curenv->env_tf = *tf;
f0104441:	e8 e2 1f 00 00       	call   f0106428 <cpunum>
f0104446:	6b c0 74             	imul   $0x74,%eax,%eax
f0104449:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f010444f:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104454:	89 c7                	mov    %eax,%edi
f0104456:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		tf = &curenv->env_tf;
f0104458:	e8 cb 1f 00 00       	call   f0106428 <cpunum>
f010445d:	6b c0 74             	imul   $0x74,%eax,%eax
f0104460:	8b b0 08 80 2c f0    	mov    -0xfd37ff8(%eax),%esi
f0104466:	e9 cd fe ff ff       	jmp    f0104338 <trap+0x5c>
		assert(curenv);
f010446b:	68 63 8e 10 f0       	push   $0xf0108e63
f0104470:	68 31 78 10 f0       	push   $0xf0107831
f0104475:	68 85 01 00 00       	push   $0x185
f010447a:	68 3e 8e 10 f0       	push   $0xf0108e3e
f010447f:	e8 bf bb ff ff       	call   f0100043 <_panic>
			env_free(curenv);
f0104484:	e8 9f 1f 00 00       	call   f0106428 <cpunum>
f0104489:	83 ec 0c             	sub    $0xc,%esp
f010448c:	6b c0 74             	imul   $0x74,%eax,%eax
f010448f:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f0104495:	e8 c4 f3 ff ff       	call   f010385e <env_free>
			curenv = NULL;
f010449a:	e8 89 1f 00 00       	call   f0106428 <cpunum>
f010449f:	6b c0 74             	imul   $0x74,%eax,%eax
f01044a2:	c7 80 08 80 2c f0 00 	movl   $0x0,-0xfd37ff8(%eax)
f01044a9:	00 00 00 
			sched_yield();
f01044ac:	e8 08 03 00 00       	call   f01047b9 <sched_yield>
		page_fault_handler(tf);
f01044b1:	83 ec 0c             	sub    $0xc,%esp
f01044b4:	56                   	push   %esi
f01044b5:	e8 cc fc ff ff       	call   f0104186 <page_fault_handler>
f01044ba:	83 c4 10             	add    $0x10,%esp
f01044bd:	e9 ee fe ff ff       	jmp    f01043b0 <trap+0xd4>
		monitor(tf);
f01044c2:	83 ec 0c             	sub    $0xc,%esp
f01044c5:	56                   	push   %esi
f01044c6:	e8 25 c5 ff ff       	call   f01009f0 <monitor>
f01044cb:	83 c4 10             	add    $0x10,%esp
f01044ce:	e9 dd fe ff ff       	jmp    f01043b0 <trap+0xd4>
		tf->tf_regs.reg_eax = syscall(tf->tf_regs.reg_eax,
f01044d3:	83 ec 08             	sub    $0x8,%esp
f01044d6:	ff 76 04             	pushl  0x4(%esi)
f01044d9:	ff 36                	pushl  (%esi)
f01044db:	ff 76 10             	pushl  0x10(%esi)
f01044de:	ff 76 18             	pushl  0x18(%esi)
f01044e1:	ff 76 14             	pushl  0x14(%esi)
f01044e4:	ff 76 1c             	pushl  0x1c(%esi)
f01044e7:	e8 77 03 00 00       	call   f0104863 <syscall>
f01044ec:	89 46 1c             	mov    %eax,0x1c(%esi)
f01044ef:	83 c4 20             	add    $0x20,%esp
f01044f2:	e9 b9 fe ff ff       	jmp    f01043b0 <trap+0xd4>
		cprintf("Spurious interrupt on irq 7\n");
f01044f7:	83 ec 0c             	sub    $0xc,%esp
f01044fa:	68 6a 8e 10 f0       	push   $0xf0108e6a
f01044ff:	e8 9f f7 ff ff       	call   f0103ca3 <cprintf>
		print_trapframe(tf);
f0104504:	89 34 24             	mov    %esi,(%esp)
f0104507:	e8 ca fa ff ff       	call   f0103fd6 <print_trapframe>
f010450c:	83 c4 10             	add    $0x10,%esp
f010450f:	e9 9c fe ff ff       	jmp    f01043b0 <trap+0xd4>
		time_tick();
f0104514:	e8 98 24 00 00       	call   f01069b1 <time_tick>
		lapic_eoi();
f0104519:	e8 fd 20 00 00       	call   f010661b <lapic_eoi>
		sched_yield();
f010451e:	e8 96 02 00 00       	call   f01047b9 <sched_yield>
		kbd_intr();
f0104523:	e8 8f c1 ff ff       	call   f01006b7 <kbd_intr>
f0104528:	e9 83 fe ff ff       	jmp    f01043b0 <trap+0xd4>
		serial_intr();
f010452d:	e8 68 c1 ff ff       	call   f010069a <serial_intr>
f0104532:	e9 79 fe ff ff       	jmp    f01043b0 <trap+0xd4>
		panic("unhandled trap in kernel");
f0104537:	83 ec 04             	sub    $0x4,%esp
f010453a:	68 87 8e 10 f0       	push   $0xf0108e87
f010453f:	68 64 01 00 00       	push   $0x164
f0104544:	68 3e 8e 10 f0       	push   $0xf0108e3e
f0104549:	e8 f5 ba ff ff       	call   f0100043 <_panic>
		env_run(curenv);
f010454e:	e8 d5 1e 00 00       	call   f0106428 <cpunum>
f0104553:	83 ec 0c             	sub    $0xc,%esp
f0104556:	6b c0 74             	imul   $0x74,%eax,%eax
f0104559:	ff b0 08 80 2c f0    	pushl  -0xfd37ff8(%eax)
f010455f:	e8 88 f5 ff ff       	call   f0103aec <env_run>

f0104564 <ith_0>:
.text

/*
 * Lab 3: Your code here for generating entry points for the different traps.
 */
TRAPHANDLER_NOEC(ith_0, T_DIVIDE);
f0104564:	6a 00                	push   $0x0
f0104566:	6a 00                	push   $0x0
f0104568:	e9 d5 6e 02 00       	jmp    f012b442 <_alltraps>
f010456d:	90                   	nop

f010456e <ith_1>:
TRAPHANDLER_NOEC(ith_1, T_DEBUG);
f010456e:	6a 00                	push   $0x0
f0104570:	6a 01                	push   $0x1
f0104572:	e9 cb 6e 02 00       	jmp    f012b442 <_alltraps>
f0104577:	90                   	nop

f0104578 <ith_2>:
TRAPHANDLER_NOEC(ith_2, T_NMI);
f0104578:	6a 00                	push   $0x0
f010457a:	6a 02                	push   $0x2
f010457c:	e9 c1 6e 02 00       	jmp    f012b442 <_alltraps>
f0104581:	90                   	nop

f0104582 <ith_3>:
TRAPHANDLER_NOEC(ith_3, T_BRKPT);
f0104582:	6a 00                	push   $0x0
f0104584:	6a 03                	push   $0x3
f0104586:	e9 b7 6e 02 00       	jmp    f012b442 <_alltraps>
f010458b:	90                   	nop

f010458c <ith_4>:
TRAPHANDLER_NOEC(ith_4, T_OFLOW);
f010458c:	6a 00                	push   $0x0
f010458e:	6a 04                	push   $0x4
f0104590:	e9 ad 6e 02 00       	jmp    f012b442 <_alltraps>
f0104595:	90                   	nop

f0104596 <ith_5>:
TRAPHANDLER_NOEC(ith_5, T_BOUND);
f0104596:	6a 00                	push   $0x0
f0104598:	6a 05                	push   $0x5
f010459a:	e9 a3 6e 02 00       	jmp    f012b442 <_alltraps>
f010459f:	90                   	nop

f01045a0 <ith_6>:
TRAPHANDLER_NOEC(ith_6, T_ILLOP);
f01045a0:	6a 00                	push   $0x0
f01045a2:	6a 06                	push   $0x6
f01045a4:	e9 99 6e 02 00       	jmp    f012b442 <_alltraps>
f01045a9:	90                   	nop

f01045aa <ith_7>:
TRAPHANDLER_NOEC(ith_7, T_DEVICE);
f01045aa:	6a 00                	push   $0x0
f01045ac:	6a 07                	push   $0x7
f01045ae:	e9 8f 6e 02 00       	jmp    f012b442 <_alltraps>
f01045b3:	90                   	nop

f01045b4 <ith_8>:
TRAPHANDLER(ith_8, T_DBLFLT);
f01045b4:	6a 08                	push   $0x8
f01045b6:	e9 87 6e 02 00       	jmp    f012b442 <_alltraps>
f01045bb:	90                   	nop

f01045bc <ith_10>:
TRAPHANDLER(ith_10, T_TSS);
f01045bc:	6a 0a                	push   $0xa
f01045be:	e9 7f 6e 02 00       	jmp    f012b442 <_alltraps>
f01045c3:	90                   	nop

f01045c4 <ith_11>:
TRAPHANDLER(ith_11, T_SEGNP);
f01045c4:	6a 0b                	push   $0xb
f01045c6:	e9 77 6e 02 00       	jmp    f012b442 <_alltraps>
f01045cb:	90                   	nop

f01045cc <ith_12>:
TRAPHANDLER(ith_12, T_STACK);
f01045cc:	6a 0c                	push   $0xc
f01045ce:	e9 6f 6e 02 00       	jmp    f012b442 <_alltraps>
f01045d3:	90                   	nop

f01045d4 <ith_13>:
TRAPHANDLER(ith_13, T_GPFLT);
f01045d4:	6a 0d                	push   $0xd
f01045d6:	e9 67 6e 02 00       	jmp    f012b442 <_alltraps>
f01045db:	90                   	nop

f01045dc <ith_14>:
TRAPHANDLER(ith_14, T_PGFLT);
f01045dc:	6a 0e                	push   $0xe
f01045de:	e9 5f 6e 02 00       	jmp    f012b442 <_alltraps>
f01045e3:	90                   	nop

f01045e4 <ith_16>:
TRAPHANDLER_NOEC(ith_16, T_FPERR);
f01045e4:	6a 00                	push   $0x0
f01045e6:	6a 10                	push   $0x10
f01045e8:	e9 55 6e 02 00       	jmp    f012b442 <_alltraps>
f01045ed:	90                   	nop

f01045ee <ith_17>:
TRAPHANDLER(ith_17, T_ALIGN);
f01045ee:	6a 11                	push   $0x11
f01045f0:	e9 4d 6e 02 00       	jmp    f012b442 <_alltraps>
f01045f5:	90                   	nop

f01045f6 <ith_18>:
TRAPHANDLER_NOEC(ith_18, T_MCHK);
f01045f6:	6a 00                	push   $0x0
f01045f8:	6a 12                	push   $0x12
f01045fa:	e9 43 6e 02 00       	jmp    f012b442 <_alltraps>
f01045ff:	90                   	nop

f0104600 <ith_19>:
TRAPHANDLER_NOEC(ith_19, T_SIMDERR);
f0104600:	6a 00                	push   $0x0
f0104602:	6a 13                	push   $0x13
f0104604:	e9 39 6e 02 00       	jmp    f012b442 <_alltraps>
f0104609:	90                   	nop

f010460a <ith_32>:
TRAPHANDLER_NOEC(ith_32, IRQ_OFFSET + IRQ_TIMER);
f010460a:	6a 00                	push   $0x0
f010460c:	6a 20                	push   $0x20
f010460e:	e9 2f 6e 02 00       	jmp    f012b442 <_alltraps>
f0104613:	90                   	nop

f0104614 <ith_33>:
TRAPHANDLER_NOEC(ith_33, IRQ_OFFSET + IRQ_KBD);
f0104614:	6a 00                	push   $0x0
f0104616:	6a 21                	push   $0x21
f0104618:	e9 25 6e 02 00       	jmp    f012b442 <_alltraps>
f010461d:	90                   	nop

f010461e <ith_34>:
TRAPHANDLER_NOEC(ith_34, IRQ_OFFSET + 2);
f010461e:	6a 00                	push   $0x0
f0104620:	6a 22                	push   $0x22
f0104622:	e9 1b 6e 02 00       	jmp    f012b442 <_alltraps>
f0104627:	90                   	nop

f0104628 <ith_35>:
TRAPHANDLER_NOEC(ith_35, IRQ_OFFSET + 3);
f0104628:	6a 00                	push   $0x0
f010462a:	6a 23                	push   $0x23
f010462c:	e9 11 6e 02 00       	jmp    f012b442 <_alltraps>
f0104631:	90                   	nop

f0104632 <ith_36>:
TRAPHANDLER_NOEC(ith_36, IRQ_OFFSET + IRQ_SERIAL);
f0104632:	6a 00                	push   $0x0
f0104634:	6a 24                	push   $0x24
f0104636:	e9 07 6e 02 00       	jmp    f012b442 <_alltraps>
f010463b:	90                   	nop

f010463c <ith_37>:
TRAPHANDLER_NOEC(ith_37, IRQ_OFFSET + 5);
f010463c:	6a 00                	push   $0x0
f010463e:	6a 25                	push   $0x25
f0104640:	e9 fd 6d 02 00       	jmp    f012b442 <_alltraps>
f0104645:	90                   	nop

f0104646 <ith_38>:
TRAPHANDLER_NOEC(ith_38, IRQ_OFFSET + 6);
f0104646:	6a 00                	push   $0x0
f0104648:	6a 26                	push   $0x26
f010464a:	e9 f3 6d 02 00       	jmp    f012b442 <_alltraps>
f010464f:	90                   	nop

f0104650 <ith_39>:
TRAPHANDLER_NOEC(ith_39, IRQ_OFFSET + IRQ_SPURIOUS);
f0104650:	6a 00                	push   $0x0
f0104652:	6a 27                	push   $0x27
f0104654:	e9 e9 6d 02 00       	jmp    f012b442 <_alltraps>
f0104659:	90                   	nop

f010465a <ith_40>:
TRAPHANDLER_NOEC(ith_40, IRQ_OFFSET + 8);
f010465a:	6a 00                	push   $0x0
f010465c:	6a 28                	push   $0x28
f010465e:	e9 df 6d 02 00       	jmp    f012b442 <_alltraps>
f0104663:	90                   	nop

f0104664 <ith_41>:
TRAPHANDLER_NOEC(ith_41, IRQ_OFFSET + 9);
f0104664:	6a 00                	push   $0x0
f0104666:	6a 29                	push   $0x29
f0104668:	e9 d5 6d 02 00       	jmp    f012b442 <_alltraps>
f010466d:	90                   	nop

f010466e <ith_42>:
TRAPHANDLER_NOEC(ith_42, IRQ_OFFSET + 10);
f010466e:	6a 00                	push   $0x0
f0104670:	6a 2a                	push   $0x2a
f0104672:	e9 cb 6d 02 00       	jmp    f012b442 <_alltraps>
f0104677:	90                   	nop

f0104678 <ith_43>:
TRAPHANDLER_NOEC(ith_43, IRQ_OFFSET + 11);
f0104678:	6a 00                	push   $0x0
f010467a:	6a 2b                	push   $0x2b
f010467c:	e9 c1 6d 02 00       	jmp    f012b442 <_alltraps>
f0104681:	90                   	nop

f0104682 <ith_44>:
TRAPHANDLER_NOEC(ith_44, IRQ_OFFSET + 12);
f0104682:	6a 00                	push   $0x0
f0104684:	6a 2c                	push   $0x2c
f0104686:	e9 b7 6d 02 00       	jmp    f012b442 <_alltraps>
f010468b:	90                   	nop

f010468c <ith_45>:
TRAPHANDLER_NOEC(ith_45, IRQ_OFFSET + 13);
f010468c:	6a 00                	push   $0x0
f010468e:	6a 2d                	push   $0x2d
f0104690:	e9 ad 6d 02 00       	jmp    f012b442 <_alltraps>
f0104695:	90                   	nop

f0104696 <ith_46>:
TRAPHANDLER_NOEC(ith_46, IRQ_OFFSET + IRQ_IDE);
f0104696:	6a 00                	push   $0x0
f0104698:	6a 2e                	push   $0x2e
f010469a:	e9 a3 6d 02 00       	jmp    f012b442 <_alltraps>
f010469f:	90                   	nop

f01046a0 <ith_47>:
TRAPHANDLER_NOEC(ith_47, IRQ_OFFSET + 15);
f01046a0:	6a 00                	push   $0x0
f01046a2:	6a 2f                	push   $0x2f
f01046a4:	e9 99 6d 02 00       	jmp    f012b442 <_alltraps>
f01046a9:	90                   	nop

f01046aa <ith_48>:
TRAPHANDLER_NOEC(ith_48, T_SYSCALL);
f01046aa:	6a 00                	push   $0x0
f01046ac:	6a 30                	push   $0x30
f01046ae:	e9 8f 6d 02 00       	jmp    f012b442 <_alltraps>
f01046b3:	90                   	nop

f01046b4 <ith_51>:
TRAPHANDLER_NOEC(ith_51, IRQ_OFFSET + IRQ_ERROR);
f01046b4:	6a 00                	push   $0x0
f01046b6:	6a 33                	push   $0x33
f01046b8:	e9 85 6d 02 00       	jmp    f012b442 <_alltraps>
f01046bd:	90                   	nop

f01046be <ith_500>:
TRAPHANDLER_NOEC(ith_500, T_DEFAULT);
f01046be:	6a 00                	push   $0x0
f01046c0:	68 f4 01 00 00       	push   $0x1f4
f01046c5:	e9 78 6d 02 00       	jmp    f012b442 <_alltraps>

f01046ca <sched_halt>:
// Halt this CPU when there is nothing to do. Wait until the
// timer interrupt wakes it up. This function never returns.
//
void
sched_halt(void)
{
f01046ca:	55                   	push   %ebp
f01046cb:	89 e5                	mov    %esp,%ebp
f01046cd:	83 ec 08             	sub    $0x8,%esp
f01046d0:	a1 44 62 2c f0       	mov    0xf02c6244,%eax
f01046d5:	8d 50 54             	lea    0x54(%eax),%edx
	int i;

	// For debugging and testing purposes, if there are no runnable
	// environments in the system, then drop into the kernel monitor.
	for (i = 0; i < NENV; i++) {
f01046d8:	b9 00 00 00 00       	mov    $0x0,%ecx
		if ((envs[i].env_status == ENV_RUNNABLE ||
		     envs[i].env_status == ENV_RUNNING ||
f01046dd:	8b 02                	mov    (%edx),%eax
f01046df:	48                   	dec    %eax
		if ((envs[i].env_status == ENV_RUNNABLE ||
f01046e0:	83 f8 02             	cmp    $0x2,%eax
f01046e3:	76 2b                	jbe    f0104710 <sched_halt+0x46>
	for (i = 0; i < NENV; i++) {
f01046e5:	41                   	inc    %ecx
f01046e6:	83 c2 7c             	add    $0x7c,%edx
f01046e9:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f01046ef:	75 ec                	jne    f01046dd <sched_halt+0x13>
		     envs[i].env_status == ENV_DYING))
			break;
	}
	if (i == NENV) {
		cprintf("No runnable environments in the system!\n");
f01046f1:	83 ec 0c             	sub    $0xc,%esp
f01046f4:	68 70 90 10 f0       	push   $0xf0109070
f01046f9:	e8 a5 f5 ff ff       	call   f0103ca3 <cprintf>
f01046fe:	83 c4 10             	add    $0x10,%esp
		while (1)
			monitor(NULL);
f0104701:	83 ec 0c             	sub    $0xc,%esp
f0104704:	6a 00                	push   $0x0
f0104706:	e8 e5 c2 ff ff       	call   f01009f0 <monitor>
f010470b:	83 c4 10             	add    $0x10,%esp
f010470e:	eb f1                	jmp    f0104701 <sched_halt+0x37>
	if (i == NENV) {
f0104710:	81 f9 00 04 00 00    	cmp    $0x400,%ecx
f0104716:	74 d9                	je     f01046f1 <sched_halt+0x27>
	}

	// Mark that no environment is running on this CPU
	curenv = NULL;
f0104718:	e8 0b 1d 00 00       	call   f0106428 <cpunum>
f010471d:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104720:	01 c2                	add    %eax,%edx
f0104722:	01 d2                	add    %edx,%edx
f0104724:	01 c2                	add    %eax,%edx
f0104726:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104729:	c7 04 85 08 80 2c f0 	movl   $0x0,-0xfd37ff8(,%eax,4)
f0104730:	00 00 00 00 
	lcr3(PADDR(kern_pgdir));
f0104734:	a1 cc 74 2c f0       	mov    0xf02c74cc,%eax
	if ((uint32_t)kva < KERNBASE)
f0104739:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010473e:	76 67                	jbe    f01047a7 <sched_halt+0xdd>
	return (physaddr_t)kva - KERNBASE;
f0104740:	05 00 00 00 10       	add    $0x10000000,%eax
	asm volatile("movl %0,%%cr3" : : "r" (val));
f0104745:	0f 22 d8             	mov    %eax,%cr3

	// Mark that this CPU is in the HALT state, so that when
	// timer interupts come in, we know we should re-acquire the
	// big kernel lock
	xchg(&thiscpu->cpu_status, CPU_HALTED);
f0104748:	e8 db 1c 00 00       	call   f0106428 <cpunum>
f010474d:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104750:	01 c2                	add    %eax,%edx
f0104752:	01 d2                	add    %edx,%edx
f0104754:	01 c2                	add    %eax,%edx
f0104756:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104759:	8d 14 85 04 00 00 00 	lea    0x4(,%eax,4),%edx
	asm volatile("lock; xchgl %0, %1"
f0104760:	b8 02 00 00 00       	mov    $0x2,%eax
f0104765:	f0 87 82 00 80 2c f0 	lock xchg %eax,-0xfd38000(%edx)
	spin_unlock(&kernel_lock);
f010476c:	83 ec 0c             	sub    $0xc,%esp
f010476f:	68 60 b4 12 f0       	push   $0xf012b460
f0104774:	e8 39 21 00 00       	call   f01068b2 <spin_unlock>
	asm volatile("pause");
f0104779:	f3 90                	pause  
		"pushl $0\n"
		"sti\n"
		"1:\n"
		"hlt\n"
		"jmp 1b\n"
	: : "a" (thiscpu->cpu_ts.ts_esp0));
f010477b:	e8 a8 1c 00 00       	call   f0106428 <cpunum>
f0104780:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104783:	01 c2                	add    %eax,%edx
f0104785:	01 d2                	add    %edx,%edx
f0104787:	01 c2                	add    %eax,%edx
f0104789:	8d 04 90             	lea    (%eax,%edx,4),%eax
	asm volatile (
f010478c:	8b 04 85 10 80 2c f0 	mov    -0xfd37ff0(,%eax,4),%eax
f0104793:	bd 00 00 00 00       	mov    $0x0,%ebp
f0104798:	89 c4                	mov    %eax,%esp
f010479a:	6a 00                	push   $0x0
f010479c:	6a 00                	push   $0x0
f010479e:	fb                   	sti    
f010479f:	f4                   	hlt    
f01047a0:	eb fd                	jmp    f010479f <sched_halt+0xd5>
}
f01047a2:	83 c4 10             	add    $0x10,%esp
f01047a5:	c9                   	leave  
f01047a6:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01047a7:	50                   	push   %eax
f01047a8:	68 ec 77 10 f0       	push   $0xf01077ec
f01047ad:	6a 53                	push   $0x53
f01047af:	68 99 90 10 f0       	push   $0xf0109099
f01047b4:	e8 8a b8 ff ff       	call   f0100043 <_panic>

f01047b9 <sched_yield>:
{
f01047b9:	55                   	push   %ebp
f01047ba:	89 e5                	mov    %esp,%ebp
f01047bc:	53                   	push   %ebx
f01047bd:	83 ec 04             	sub    $0x4,%esp
	struct Env *cur_envir = curenv;
f01047c0:	e8 63 1c 00 00       	call   f0106428 <cpunum>
f01047c5:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01047c8:	01 c2                	add    %eax,%edx
f01047ca:	01 d2                	add    %edx,%edx
f01047cc:	01 c2                	add    %eax,%edx
f01047ce:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01047d1:	8b 0c 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%ecx
	struct Env *end = envs + NENV;
f01047d8:	8b 1d 44 62 2c f0    	mov    0xf02c6244,%ebx
f01047de:	8d 93 00 f0 01 00    	lea    0x1f000(%ebx),%edx
	if (cur_envir == NULL) {
f01047e4:	85 c9                	test   %ecx,%ecx
f01047e6:	74 1a                	je     f0104802 <sched_yield+0x49>
f01047e8:	89 c8                	mov    %ecx,%eax
		for (idle = cur_envir; idle < end; idle++) {
f01047ea:	39 d0                	cmp    %edx,%eax
f01047ec:	73 35                	jae    f0104823 <sched_yield+0x6a>
			if (idle->env_status == ENV_RUNNABLE) {
f01047ee:	83 78 54 02          	cmpl   $0x2,0x54(%eax)
f01047f2:	74 1d                	je     f0104811 <sched_yield+0x58>
		for (idle = cur_envir; idle < end; idle++) {
f01047f4:	83 c0 7c             	add    $0x7c,%eax
f01047f7:	eb f1                	jmp    f01047ea <sched_yield+0x31>
				env_run(idle);
f01047f9:	83 ec 0c             	sub    $0xc,%esp
f01047fc:	53                   	push   %ebx
f01047fd:	e8 ea f2 ff ff       	call   f0103aec <env_run>
		for (idle = envs; idle < end; idle++) {
f0104802:	39 d3                	cmp    %edx,%ebx
f0104804:	74 4a                	je     f0104850 <sched_yield+0x97>
			if (idle->env_status == ENV_RUNNABLE) {
f0104806:	83 7b 54 02          	cmpl   $0x2,0x54(%ebx)
f010480a:	74 ed                	je     f01047f9 <sched_yield+0x40>
		for (idle = envs; idle < end; idle++) {
f010480c:	83 c3 7c             	add    $0x7c,%ebx
f010480f:	eb f1                	jmp    f0104802 <sched_yield+0x49>
				env_run(idle);
f0104811:	83 ec 0c             	sub    $0xc,%esp
f0104814:	50                   	push   %eax
f0104815:	e8 d2 f2 ff ff       	call   f0103aec <env_run>
				env_run(idle);
f010481a:	83 ec 0c             	sub    $0xc,%esp
f010481d:	53                   	push   %ebx
f010481e:	e8 c9 f2 ff ff       	call   f0103aec <env_run>
		for (idle = envs; idle < cur_envir; idle++) {
f0104823:	39 cb                	cmp    %ecx,%ebx
f0104825:	73 0b                	jae    f0104832 <sched_yield+0x79>
			if (idle->env_status == ENV_RUNNABLE) {
f0104827:	83 7b 54 02          	cmpl   $0x2,0x54(%ebx)
f010482b:	74 ed                	je     f010481a <sched_yield+0x61>
		for (idle = envs; idle < cur_envir; idle++) {
f010482d:	83 c3 7c             	add    $0x7c,%ebx
f0104830:	eb f1                	jmp    f0104823 <sched_yield+0x6a>
		if (curenv->env_status == ENV_RUNNING) {
f0104832:	e8 f1 1b 00 00       	call   f0106428 <cpunum>
f0104837:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010483a:	01 c2                	add    %eax,%edx
f010483c:	01 d2                	add    %edx,%edx
f010483e:	01 c2                	add    %eax,%edx
f0104840:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104843:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f010484a:	83 78 54 03          	cmpl   $0x3,0x54(%eax)
f010484e:	74 0a                	je     f010485a <sched_yield+0xa1>
	sched_halt();
f0104850:	e8 75 fe ff ff       	call   f01046ca <sched_halt>
}
f0104855:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0104858:	c9                   	leave  
f0104859:	c3                   	ret    
			env_run(idle);
f010485a:	83 ec 0c             	sub    $0xc,%esp
f010485d:	53                   	push   %ebx
f010485e:	e8 89 f2 ff ff       	call   f0103aec <env_run>

f0104863 <syscall>:
}

// Dispatches to the correct kernel function, passing the arguments.
int32_t
syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f0104863:	55                   	push   %ebp
f0104864:	89 e5                	mov    %esp,%ebp
f0104866:	57                   	push   %edi
f0104867:	56                   	push   %esi
f0104868:	53                   	push   %ebx
f0104869:	83 ec 1c             	sub    $0x1c,%esp
f010486c:	8b 45 08             	mov    0x8(%ebp),%eax
	// Return any appropriate return value.
	// LAB 3: Your code here.

	

	switch (syscallno) {
f010486f:	83 f8 11             	cmp    $0x11,%eax
f0104872:	0f 87 d3 06 00 00    	ja     f0104f4b <syscall+0x6e8>
f0104878:	ff 24 85 ac 90 10 f0 	jmp    *-0xfef6f54(,%eax,4)
	user_mem_assert(curenv, s, len, 0);
f010487f:	e8 a4 1b 00 00       	call   f0106428 <cpunum>
f0104884:	6a 00                	push   $0x0
f0104886:	ff 75 10             	pushl  0x10(%ebp)
f0104889:	ff 75 0c             	pushl  0xc(%ebp)
f010488c:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010488f:	01 c2                	add    %eax,%edx
f0104891:	01 d2                	add    %edx,%edx
f0104893:	01 c2                	add    %eax,%edx
f0104895:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104898:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f010489f:	e8 9c ea ff ff       	call   f0103340 <user_mem_assert>
	cprintf("%.*s", len, s);
f01048a4:	83 c4 0c             	add    $0xc,%esp
f01048a7:	ff 75 0c             	pushl  0xc(%ebp)
f01048aa:	ff 75 10             	pushl  0x10(%ebp)
f01048ad:	68 a6 90 10 f0       	push   $0xf01090a6
f01048b2:	e8 ec f3 ff ff       	call   f0103ca3 <cprintf>
f01048b7:	83 c4 10             	add    $0x10,%esp

	case SYS_cputs : 
		sys_cputs((char*)a1, a2);
		return 0;
f01048ba:	b8 00 00 00 00       	mov    $0x0,%eax
		sys_set_console_color((int)a1);
		return 0;
	default:
		return -E_INVAL;
	}
}
f01048bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01048c2:	5b                   	pop    %ebx
f01048c3:	5e                   	pop    %esi
f01048c4:	5f                   	pop    %edi
f01048c5:	5d                   	pop    %ebp
f01048c6:	c3                   	ret    
	return cons_getc();
f01048c7:	e8 fd bd ff ff       	call   f01006c9 <cons_getc>
		return sys_cgetc();
f01048cc:	eb f1                	jmp    f01048bf <syscall+0x5c>
	return curenv->env_id;
f01048ce:	e8 55 1b 00 00       	call   f0106428 <cpunum>
f01048d3:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01048d6:	01 c2                	add    %eax,%edx
f01048d8:	01 d2                	add    %edx,%edx
f01048da:	01 c2                	add    %eax,%edx
f01048dc:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01048df:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f01048e6:	8b 40 48             	mov    0x48(%eax),%eax
		return sys_getenvid();
f01048e9:	eb d4                	jmp    f01048bf <syscall+0x5c>
	if ((r = envid2env(envid, &e, 1)) < 0)
f01048eb:	83 ec 04             	sub    $0x4,%esp
f01048ee:	6a 01                	push   $0x1
f01048f0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f01048f3:	50                   	push   %eax
f01048f4:	ff 75 0c             	pushl  0xc(%ebp)
f01048f7:	e8 90 ea ff ff       	call   f010338c <envid2env>
f01048fc:	83 c4 10             	add    $0x10,%esp
f01048ff:	85 c0                	test   %eax,%eax
f0104901:	78 bc                	js     f01048bf <syscall+0x5c>
	env_destroy(e);
f0104903:	83 ec 0c             	sub    $0xc,%esp
f0104906:	ff 75 e4             	pushl  -0x1c(%ebp)
f0104909:	e8 21 f1 ff ff       	call   f0103a2f <env_destroy>
f010490e:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104911:	b8 00 00 00 00       	mov    $0x0,%eax
		return sys_env_destroy(a1);
f0104916:	eb a7                	jmp    f01048bf <syscall+0x5c>
	if ((uint32_t) va >= UTOP || (uint32_t) va % PGSIZE != 0) {
f0104918:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f010491f:	0f 87 8e 00 00 00    	ja     f01049b3 <syscall+0x150>
f0104925:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f010492c:	0f 85 8b 00 00 00    	jne    f01049bd <syscall+0x15a>
	if ( !( (perm & (PTE_U | PTE_P)) && ((perm | PTE_SYSCALL) == PTE_SYSCALL))) {
f0104932:	f6 45 14 05          	testb  $0x5,0x14(%ebp)
f0104936:	0f 84 8b 00 00 00    	je     f01049c7 <syscall+0x164>
f010493c:	8b 45 14             	mov    0x14(%ebp),%eax
f010493f:	0d 07 0e 00 00       	or     $0xe07,%eax
f0104944:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0104949:	0f 85 82 00 00 00    	jne    f01049d1 <syscall+0x16e>
  	if (envid2env(envid, &newenv, 1) < 0) {
f010494f:	83 ec 04             	sub    $0x4,%esp
f0104952:	6a 01                	push   $0x1
f0104954:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104957:	50                   	push   %eax
f0104958:	ff 75 0c             	pushl  0xc(%ebp)
f010495b:	e8 2c ea ff ff       	call   f010338c <envid2env>
f0104960:	83 c4 10             	add    $0x10,%esp
f0104963:	85 c0                	test   %eax,%eax
f0104965:	78 74                	js     f01049db <syscall+0x178>
  	struct PageInfo* newPage = page_alloc(ALLOC_ZERO);
f0104967:	83 ec 0c             	sub    $0xc,%esp
f010496a:	6a 01                	push   $0x1
f010496c:	e8 04 c9 ff ff       	call   f0101275 <page_alloc>
f0104971:	89 c3                	mov    %eax,%ebx
  	if (newPage == NULL) {
f0104973:	83 c4 10             	add    $0x10,%esp
f0104976:	85 c0                	test   %eax,%eax
f0104978:	74 6b                	je     f01049e5 <syscall+0x182>
  	if (page_insert(newenv->env_pgdir, newPage, va, perm) < 0) {
f010497a:	ff 75 14             	pushl  0x14(%ebp)
f010497d:	ff 75 10             	pushl  0x10(%ebp)
f0104980:	50                   	push   %eax
f0104981:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104984:	ff 70 60             	pushl  0x60(%eax)
f0104987:	e8 10 cc ff ff       	call   f010159c <page_insert>
f010498c:	83 c4 10             	add    $0x10,%esp
f010498f:	85 c0                	test   %eax,%eax
f0104991:	78 0a                	js     f010499d <syscall+0x13a>
  	return 0;
f0104993:	b8 00 00 00 00       	mov    $0x0,%eax
		return sys_page_alloc(a1, (char*)a2, (int)a3);
f0104998:	e9 22 ff ff ff       	jmp    f01048bf <syscall+0x5c>
  		page_free(newPage);
f010499d:	83 ec 0c             	sub    $0xc,%esp
f01049a0:	53                   	push   %ebx
f01049a1:	e8 5a c9 ff ff       	call   f0101300 <page_free>
f01049a6:	83 c4 10             	add    $0x10,%esp
  		return -E_NO_MEM;
f01049a9:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01049ae:	e9 0c ff ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f01049b3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01049b8:	e9 02 ff ff ff       	jmp    f01048bf <syscall+0x5c>
f01049bd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01049c2:	e9 f8 fe ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f01049c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01049cc:	e9 ee fe ff ff       	jmp    f01048bf <syscall+0x5c>
f01049d1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f01049d6:	e9 e4 fe ff ff       	jmp    f01048bf <syscall+0x5c>
  		return -E_BAD_ENV;
f01049db:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f01049e0:	e9 da fe ff ff       	jmp    f01048bf <syscall+0x5c>
  		return -E_NO_MEM;
f01049e5:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
f01049ea:	e9 d0 fe ff ff       	jmp    f01048bf <syscall+0x5c>
	if (((uint32_t) srcva >= UTOP) || (((uint32_t) srcva % PGSIZE) != 0)) {
f01049ef:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f01049f6:	0f 87 c6 00 00 00    	ja     f0104ac2 <syscall+0x25f>
f01049fc:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104a03:	0f 85 c3 00 00 00    	jne    f0104acc <syscall+0x269>
    if (((uint32_t) dstva >= UTOP) || (((uint32_t) dstva % PGSIZE) != 0)) {
f0104a09:	81 7d 18 ff ff bf ee 	cmpl   $0xeebfffff,0x18(%ebp)
f0104a10:	0f 87 c0 00 00 00    	ja     f0104ad6 <syscall+0x273>
f0104a16:	f7 45 18 ff 0f 00 00 	testl  $0xfff,0x18(%ebp)
f0104a1d:	0f 85 bd 00 00 00    	jne    f0104ae0 <syscall+0x27d>
    if (!(((perm & PTE_U) | (perm & PTE_P)) && ((perm | PTE_SYSCALL) == PTE_SYSCALL))) {
f0104a23:	f6 45 1c 05          	testb  $0x5,0x1c(%ebp)
f0104a27:	0f 84 bd 00 00 00    	je     f0104aea <syscall+0x287>
f0104a2d:	8b 45 1c             	mov    0x1c(%ebp),%eax
f0104a30:	0d 07 0e 00 00       	or     $0xe07,%eax
f0104a35:	3d 07 0e 00 00       	cmp    $0xe07,%eax
f0104a3a:	0f 85 b4 00 00 00    	jne    f0104af4 <syscall+0x291>
	if (envid2env(srcenvid, &esrc, 1) < 0) {
f0104a40:	83 ec 04             	sub    $0x4,%esp
f0104a43:	6a 01                	push   $0x1
f0104a45:	8d 45 dc             	lea    -0x24(%ebp),%eax
f0104a48:	50                   	push   %eax
f0104a49:	ff 75 0c             	pushl  0xc(%ebp)
f0104a4c:	e8 3b e9 ff ff       	call   f010338c <envid2env>
f0104a51:	83 c4 10             	add    $0x10,%esp
f0104a54:	85 c0                	test   %eax,%eax
f0104a56:	0f 88 a2 00 00 00    	js     f0104afe <syscall+0x29b>
	if (envid2env(dstenvid, &edst, 1) < 0) {
f0104a5c:	83 ec 04             	sub    $0x4,%esp
f0104a5f:	6a 01                	push   $0x1
f0104a61:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104a64:	50                   	push   %eax
f0104a65:	ff 75 14             	pushl  0x14(%ebp)
f0104a68:	e8 1f e9 ff ff       	call   f010338c <envid2env>
f0104a6d:	83 c4 10             	add    $0x10,%esp
f0104a70:	85 c0                	test   %eax,%eax
f0104a72:	0f 88 90 00 00 00    	js     f0104b08 <syscall+0x2a5>
	struct PageInfo* srcpp = page_lookup(esrc->env_pgdir, srcva, &src_entry);
f0104a78:	83 ec 04             	sub    $0x4,%esp
f0104a7b:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104a7e:	50                   	push   %eax
f0104a7f:	ff 75 10             	pushl  0x10(%ebp)
f0104a82:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0104a85:	ff 70 60             	pushl  0x60(%eax)
f0104a88:	e8 16 ca ff ff       	call   f01014a3 <page_lookup>
	if (!srcpp) {
f0104a8d:	83 c4 10             	add    $0x10,%esp
f0104a90:	85 c0                	test   %eax,%eax
f0104a92:	74 7e                	je     f0104b12 <syscall+0x2af>
	if ((perm & PTE_W) && !(*src_entry & PTE_W)) {
f0104a94:	f6 45 1c 02          	testb  $0x2,0x1c(%ebp)
f0104a98:	74 08                	je     f0104aa2 <syscall+0x23f>
f0104a9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104a9d:	f6 02 02             	testb  $0x2,(%edx)
f0104aa0:	74 7a                	je     f0104b1c <syscall+0x2b9>
	if (page_insert(edst->env_pgdir, srcpp, dstva, perm) < 0) {
f0104aa2:	ff 75 1c             	pushl  0x1c(%ebp)
f0104aa5:	ff 75 18             	pushl  0x18(%ebp)
f0104aa8:	50                   	push   %eax
f0104aa9:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104aac:	ff 70 60             	pushl  0x60(%eax)
f0104aaf:	e8 e8 ca ff ff       	call   f010159c <page_insert>
f0104ab4:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104ab7:	c1 f8 1f             	sar    $0x1f,%eax
f0104aba:	83 e0 fc             	and    $0xfffffffc,%eax
f0104abd:	e9 fd fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f0104ac2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104ac7:	e9 f3 fd ff ff       	jmp    f01048bf <syscall+0x5c>
f0104acc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104ad1:	e9 e9 fd ff ff       	jmp    f01048bf <syscall+0x5c>
    	return -E_INVAL;
f0104ad6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104adb:	e9 df fd ff ff       	jmp    f01048bf <syscall+0x5c>
f0104ae0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104ae5:	e9 d5 fd ff ff       	jmp    f01048bf <syscall+0x5c>
    	return -E_INVAL;
f0104aea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104aef:	e9 cb fd ff ff       	jmp    f01048bf <syscall+0x5c>
f0104af4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104af9:	e9 c1 fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104afe:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104b03:	e9 b7 fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104b08:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104b0d:	e9 ad fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL; 
f0104b12:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b17:	e9 a3 fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f0104b1c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b21:	e9 99 fd ff ff       	jmp    f01048bf <syscall+0x5c>
	if (((uint32_t) va >= UTOP) || (((uint32_t) va % PGSIZE) != 0)) {
f0104b26:	81 7d 10 ff ff bf ee 	cmpl   $0xeebfffff,0x10(%ebp)
f0104b2d:	77 3f                	ja     f0104b6e <syscall+0x30b>
f0104b2f:	f7 45 10 ff 0f 00 00 	testl  $0xfff,0x10(%ebp)
f0104b36:	75 40                	jne    f0104b78 <syscall+0x315>
	if (envid2env(envid, &env, 1) < 0) {
f0104b38:	83 ec 04             	sub    $0x4,%esp
f0104b3b:	6a 01                	push   $0x1
f0104b3d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104b40:	50                   	push   %eax
f0104b41:	ff 75 0c             	pushl  0xc(%ebp)
f0104b44:	e8 43 e8 ff ff       	call   f010338c <envid2env>
f0104b49:	83 c4 10             	add    $0x10,%esp
f0104b4c:	85 c0                	test   %eax,%eax
f0104b4e:	78 32                	js     f0104b82 <syscall+0x31f>
	page_remove(env->env_pgdir, va);
f0104b50:	83 ec 08             	sub    $0x8,%esp
f0104b53:	ff 75 10             	pushl  0x10(%ebp)
f0104b56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104b59:	ff 70 60             	pushl  0x60(%eax)
f0104b5c:	e8 f5 c9 ff ff       	call   f0101556 <page_remove>
f0104b61:	83 c4 10             	add    $0x10,%esp
	return 0;
f0104b64:	b8 00 00 00 00       	mov    $0x0,%eax
f0104b69:	e9 51 fd ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f0104b6e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b73:	e9 47 fd ff ff       	jmp    f01048bf <syscall+0x5c>
f0104b78:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104b7d:	e9 3d fd ff ff       	jmp    f01048bf <syscall+0x5c>
  		return -E_BAD_ENV;
f0104b82:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return sys_page_unmap(a1, (void*)a2);
f0104b87:	e9 33 fd ff ff       	jmp    f01048bf <syscall+0x5c>
	sched_yield();
f0104b8c:	e8 28 fc ff ff       	call   f01047b9 <sched_yield>
	int newenv = env_alloc(&store, curenv->env_id);
f0104b91:	e8 92 18 00 00       	call   f0106428 <cpunum>
f0104b96:	83 ec 08             	sub    $0x8,%esp
f0104b99:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104b9c:	01 c2                	add    %eax,%edx
f0104b9e:	01 d2                	add    %edx,%edx
f0104ba0:	01 c2                	add    %eax,%edx
f0104ba2:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104ba5:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0104bac:	ff 70 48             	pushl  0x48(%eax)
f0104baf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104bb2:	50                   	push   %eax
f0104bb3:	e8 02 e9 ff ff       	call   f01034ba <env_alloc>
	if (newenv < 0) {
f0104bb8:	83 c4 10             	add    $0x10,%esp
f0104bbb:	85 c0                	test   %eax,%eax
f0104bbd:	78 3d                	js     f0104bfc <syscall+0x399>
		store->env_status = ENV_NOT_RUNNABLE;
f0104bbf:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104bc2:	c7 43 54 04 00 00 00 	movl   $0x4,0x54(%ebx)
		store->env_tf = curenv->env_tf;
f0104bc9:	e8 5a 18 00 00       	call   f0106428 <cpunum>
f0104bce:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104bd1:	01 c2                	add    %eax,%edx
f0104bd3:	01 d2                	add    %edx,%edx
f0104bd5:	01 c2                	add    %eax,%edx
f0104bd7:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104bda:	8b 34 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%esi
f0104be1:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104be6:	89 df                	mov    %ebx,%edi
f0104be8:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		store->env_tf.tf_regs.reg_eax = 0;
f0104bea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104bed:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
		return store->env_id;
f0104bf4:	8b 40 48             	mov    0x48(%eax),%eax
f0104bf7:	e9 c3 fc ff ff       	jmp    f01048bf <syscall+0x5c>
			return -E_NO_MEM;
f0104bfc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
f0104c00:	0f 95 c0             	setne  %al
f0104c03:	0f b6 c0             	movzbl %al,%eax
f0104c06:	83 e8 05             	sub    $0x5,%eax
f0104c09:	e9 b1 fc ff ff       	jmp    f01048bf <syscall+0x5c>
		return sys_env_set_trapframe(a1, (void*)a2);
f0104c0e:	8b 75 10             	mov    0x10(%ebp),%esi
	if (envid2env(envid, &newenv, 1) < 0) {
f0104c11:	83 ec 04             	sub    $0x4,%esp
f0104c14:	6a 01                	push   $0x1
f0104c16:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c19:	50                   	push   %eax
f0104c1a:	ff 75 0c             	pushl  0xc(%ebp)
f0104c1d:	e8 6a e7 ff ff       	call   f010338c <envid2env>
f0104c22:	83 c4 10             	add    $0x10,%esp
f0104c25:	85 c0                	test   %eax,%eax
f0104c27:	78 14                	js     f0104c3d <syscall+0x3da>
	newenv->env_tf = *tf;
f0104c29:	b9 11 00 00 00       	mov    $0x11,%ecx
f0104c2e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f0104c31:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	return 0;
f0104c33:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c38:	e9 82 fc ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104c3d:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return sys_env_set_trapframe(a1, (void*)a2);
f0104c42:	e9 78 fc ff ff       	jmp    f01048bf <syscall+0x5c>
	if (status != ENV_RUNNABLE && status != ENV_NOT_RUNNABLE) {
f0104c47:	83 7d 10 02          	cmpl   $0x2,0x10(%ebp)
f0104c4b:	74 06                	je     f0104c53 <syscall+0x3f0>
f0104c4d:	83 7d 10 04          	cmpl   $0x4,0x10(%ebp)
f0104c51:	75 2b                	jne    f0104c7e <syscall+0x41b>
	int new = envid2env(envid, &store, 1);
f0104c53:	83 ec 04             	sub    $0x4,%esp
f0104c56:	6a 01                	push   $0x1
f0104c58:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c5b:	50                   	push   %eax
f0104c5c:	ff 75 0c             	pushl  0xc(%ebp)
f0104c5f:	e8 28 e7 ff ff       	call   f010338c <envid2env>
	if (new < 0) {
f0104c64:	83 c4 10             	add    $0x10,%esp
f0104c67:	85 c0                	test   %eax,%eax
f0104c69:	78 1d                	js     f0104c88 <syscall+0x425>
		store->env_status = status;
f0104c6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104c6e:	8b 7d 10             	mov    0x10(%ebp),%edi
f0104c71:	89 78 54             	mov    %edi,0x54(%eax)
		return 0;
f0104c74:	b8 00 00 00 00       	mov    $0x0,%eax
f0104c79:	e9 41 fc ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f0104c7e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104c83:	e9 37 fc ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104c88:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return sys_env_set_status(a1, (int) a2);
f0104c8d:	e9 2d fc ff ff       	jmp    f01048bf <syscall+0x5c>
	if (envid2env(envid, &store, 1) < 0) {
f0104c92:	83 ec 04             	sub    $0x4,%esp
f0104c95:	6a 01                	push   $0x1
f0104c97:	8d 45 e4             	lea    -0x1c(%ebp),%eax
f0104c9a:	50                   	push   %eax
f0104c9b:	ff 75 0c             	pushl  0xc(%ebp)
f0104c9e:	e8 e9 e6 ff ff       	call   f010338c <envid2env>
f0104ca3:	83 c4 10             	add    $0x10,%esp
f0104ca6:	85 c0                	test   %eax,%eax
f0104ca8:	78 13                	js     f0104cbd <syscall+0x45a>
	store->env_pgfault_upcall = func;
f0104caa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0104cad:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0104cb0:	89 48 64             	mov    %ecx,0x64(%eax)
	return 0;
f0104cb3:	b8 00 00 00 00       	mov    $0x0,%eax
f0104cb8:	e9 02 fc ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104cbd:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
		return sys_env_set_pgfault_upcall(a1, (void*)a2);
f0104cc2:	e9 f8 fb ff ff       	jmp    f01048bf <syscall+0x5c>
	return sysinfo(info);
f0104cc7:	83 ec 0c             	sub    $0xc,%esp
f0104cca:	ff 75 0c             	pushl  0xc(%ebp)
f0104ccd:	e8 24 1d 00 00       	call   f01069f6 <sysinfo>
		return sys_sysinfo((struct sysinfo*) a1);
f0104cd2:	83 c4 10             	add    $0x10,%esp
f0104cd5:	e9 e5 fb ff ff       	jmp    f01048bf <syscall+0x5c>
	if (envid2env(envid, &dst_env, 0) < 0) {
f0104cda:	83 ec 04             	sub    $0x4,%esp
f0104cdd:	6a 00                	push   $0x0
f0104cdf:	8d 45 e0             	lea    -0x20(%ebp),%eax
f0104ce2:	50                   	push   %eax
f0104ce3:	ff 75 0c             	pushl  0xc(%ebp)
f0104ce6:	e8 a1 e6 ff ff       	call   f010338c <envid2env>
f0104ceb:	83 c4 10             	add    $0x10,%esp
f0104cee:	85 c0                	test   %eax,%eax
f0104cf0:	0f 88 f9 00 00 00    	js     f0104def <syscall+0x58c>
	if (!dst_env->env_ipc_recving) {
f0104cf6:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104cf9:	80 78 68 00          	cmpb   $0x0,0x68(%eax)
f0104cfd:	0f 84 f6 00 00 00    	je     f0104df9 <syscall+0x596>
	if (srcva < (void*) UTOP) {
f0104d03:	81 7d 14 ff ff bf ee 	cmpl   $0xeebfffff,0x14(%ebp)
f0104d0a:	0f 87 99 00 00 00    	ja     f0104da9 <syscall+0x546>
		src_pg = page_lookup(curenv->env_pgdir, srcva, &store);
f0104d10:	e8 13 17 00 00       	call   f0106428 <cpunum>
f0104d15:	83 ec 04             	sub    $0x4,%esp
f0104d18:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0104d1b:	52                   	push   %edx
f0104d1c:	ff 75 14             	pushl  0x14(%ebp)
f0104d1f:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104d22:	01 c2                	add    %eax,%edx
f0104d24:	01 d2                	add    %edx,%edx
f0104d26:	01 c2                	add    %eax,%edx
f0104d28:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104d2b:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0104d32:	ff 70 60             	pushl  0x60(%eax)
f0104d35:	e8 69 c7 ff ff       	call   f01014a3 <page_lookup>
		if ((uint32_t) srcva % PGSIZE != 0 || !(((perm & PTE_U) | (perm & PTE_P)) && ((perm | PTE_SYSCALL) == PTE_SYSCALL)) ||
f0104d3a:	83 c4 10             	add    $0x10,%esp
f0104d3d:	f7 45 14 ff 0f 00 00 	testl  $0xfff,0x14(%ebp)
f0104d44:	0f 85 b9 00 00 00    	jne    f0104e03 <syscall+0x5a0>
f0104d4a:	f6 45 18 05          	testb  $0x5,0x18(%ebp)
f0104d4e:	0f 84 b9 00 00 00    	je     f0104e0d <syscall+0x5aa>
f0104d54:	8b 55 18             	mov    0x18(%ebp),%edx
f0104d57:	81 ca 07 0e 00 00    	or     $0xe07,%edx
f0104d5d:	81 fa 07 0e 00 00    	cmp    $0xe07,%edx
f0104d63:	0f 85 ae 00 00 00    	jne    f0104e17 <syscall+0x5b4>
f0104d69:	85 c0                	test   %eax,%eax
f0104d6b:	0f 84 b0 00 00 00    	je     f0104e21 <syscall+0x5be>
				!src_pg || ((perm & PTE_W) && !(*store & PTE_W))) {
f0104d71:	f6 45 18 02          	testb  $0x2,0x18(%ebp)
f0104d75:	74 0c                	je     f0104d83 <syscall+0x520>
f0104d77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
f0104d7a:	f6 02 02             	testb  $0x2,(%edx)
f0104d7d:	0f 84 a8 00 00 00    	je     f0104e2b <syscall+0x5c8>
		if (page_insert(dst_env->env_pgdir, src_pg, dst_env->env_ipc_dstva, perm) < 0) {
f0104d83:	8b 55 e0             	mov    -0x20(%ebp),%edx
f0104d86:	ff 75 18             	pushl  0x18(%ebp)
f0104d89:	ff 72 6c             	pushl  0x6c(%edx)
f0104d8c:	50                   	push   %eax
f0104d8d:	ff 72 60             	pushl  0x60(%edx)
f0104d90:	e8 07 c8 ff ff       	call   f010159c <page_insert>
f0104d95:	83 c4 10             	add    $0x10,%esp
f0104d98:	85 c0                	test   %eax,%eax
f0104d9a:	0f 88 95 00 00 00    	js     f0104e35 <syscall+0x5d2>
		dst_env->env_ipc_perm = perm;
f0104da0:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104da3:	8b 7d 18             	mov    0x18(%ebp),%edi
f0104da6:	89 78 78             	mov    %edi,0x78(%eax)
	dst_env->env_ipc_recving = false;
f0104da9:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104dac:	c6 46 68 00          	movb   $0x0,0x68(%esi)
	dst_env->env_ipc_from = curenv->env_id;
f0104db0:	e8 73 16 00 00       	call   f0106428 <cpunum>
f0104db5:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104db8:	01 c2                	add    %eax,%edx
f0104dba:	01 d2                	add    %edx,%edx
f0104dbc:	01 c2                	add    %eax,%edx
f0104dbe:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104dc1:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f0104dc8:	8b 40 48             	mov    0x48(%eax),%eax
f0104dcb:	89 46 74             	mov    %eax,0x74(%esi)
	dst_env->env_ipc_value = value;
f0104dce:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0104dd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
f0104dd4:	89 58 70             	mov    %ebx,0x70(%eax)
	dst_env->env_status = ENV_RUNNABLE;
f0104dd7:	c7 40 54 02 00 00 00 	movl   $0x2,0x54(%eax)
	dst_env->env_tf.tf_regs.reg_eax = 0;
f0104dde:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
	return 0;
f0104de5:	b8 00 00 00 00       	mov    $0x0,%eax
f0104dea:	e9 d0 fa ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_BAD_ENV;
f0104def:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
f0104df4:	e9 c6 fa ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_IPC_NOT_RECV;
f0104df9:	b8 f9 ff ff ff       	mov    $0xfffffff9,%eax
f0104dfe:	e9 bc fa ff ff       	jmp    f01048bf <syscall+0x5c>
			return -E_INVAL;
f0104e03:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e08:	e9 b2 fa ff ff       	jmp    f01048bf <syscall+0x5c>
f0104e0d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e12:	e9 a8 fa ff ff       	jmp    f01048bf <syscall+0x5c>
f0104e17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e1c:	e9 9e fa ff ff       	jmp    f01048bf <syscall+0x5c>
f0104e21:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e26:	e9 94 fa ff ff       	jmp    f01048bf <syscall+0x5c>
f0104e2b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e30:	e9 8a fa ff ff       	jmp    f01048bf <syscall+0x5c>
			return -E_NO_MEM;
f0104e35:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
		return sys_ipc_try_send(a1, a2, (void*) a3, (int) a4);
f0104e3a:	e9 80 fa ff ff       	jmp    f01048bf <syscall+0x5c>
	if (dstva < (void*) UTOP && (((uint32_t) dstva % PGSIZE) != 0)) {
f0104e3f:	81 7d 0c ff ff bf ee 	cmpl   $0xeebfffff,0xc(%ebp)
f0104e46:	77 13                	ja     f0104e5b <syscall+0x5f8>
f0104e48:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
f0104e4f:	74 0a                	je     f0104e5b <syscall+0x5f8>
		return sys_ipc_recv((void*) a1);
f0104e51:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104e56:	e9 64 fa ff ff       	jmp    f01048bf <syscall+0x5c>
  	curenv->env_ipc_recving = true;
f0104e5b:	e8 c8 15 00 00       	call   f0106428 <cpunum>
f0104e60:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e63:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f0104e69:	c6 40 68 01          	movb   $0x1,0x68(%eax)
  	curenv->env_ipc_dstva = dstva;
f0104e6d:	e8 b6 15 00 00       	call   f0106428 <cpunum>
f0104e72:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e75:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f0104e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0104e7e:	89 48 6c             	mov    %ecx,0x6c(%eax)
  	curenv->env_status = ENV_NOT_RUNNABLE;
f0104e81:	e8 a2 15 00 00       	call   f0106428 <cpunum>
f0104e86:	6b c0 74             	imul   $0x74,%eax,%eax
f0104e89:	8b 80 08 80 2c f0    	mov    -0xfd37ff8(%eax),%eax
f0104e8f:	c7 40 54 04 00 00 00 	movl   $0x4,0x54(%eax)
  	sched_yield();
f0104e96:	e8 1e f9 ff ff       	call   f01047b9 <sched_yield>
	if (user_mem_check(curenv, buf, BLKSIZE, PTE_U) == 0) {
f0104e9b:	e8 88 15 00 00       	call   f0106428 <cpunum>
f0104ea0:	6a 04                	push   $0x4
f0104ea2:	68 00 10 00 00       	push   $0x1000
f0104ea7:	ff 75 10             	pushl  0x10(%ebp)
f0104eaa:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104ead:	01 c2                	add    %eax,%edx
f0104eaf:	01 d2                	add    %edx,%edx
f0104eb1:	01 c2                	add    %eax,%edx
f0104eb3:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104eb6:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f0104ebd:	e8 d7 e3 ff ff       	call   f0103299 <user_mem_check>
f0104ec2:	83 c4 10             	add    $0x10,%esp
f0104ec5:	85 c0                	test   %eax,%eax
f0104ec7:	0f 85 88 00 00 00    	jne    f0104f55 <syscall+0x6f2>
		return nvme_write(secno, buf, nsecs);
f0104ecd:	0f b7 45 14          	movzwl 0x14(%ebp),%eax
f0104ed1:	50                   	push   %eax
f0104ed2:	ff 75 10             	pushl  0x10(%ebp)
f0104ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104ed8:	ba 00 00 00 00       	mov    $0x0,%edx
f0104edd:	52                   	push   %edx
f0104ede:	50                   	push   %eax
f0104edf:	e8 30 26 00 00       	call   f0107514 <nvme_write>
f0104ee4:	83 c4 10             	add    $0x10,%esp
f0104ee7:	e9 d3 f9 ff ff       	jmp    f01048bf <syscall+0x5c>
	if (user_mem_check(curenv, buf, BLKSIZE, PTE_U) == 0) {
f0104eec:	e8 37 15 00 00       	call   f0106428 <cpunum>
f0104ef1:	6a 04                	push   $0x4
f0104ef3:	68 00 10 00 00       	push   $0x1000
f0104ef8:	ff 75 10             	pushl  0x10(%ebp)
f0104efb:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104efe:	01 c2                	add    %eax,%edx
f0104f00:	01 d2                	add    %edx,%edx
f0104f02:	01 c2                	add    %eax,%edx
f0104f04:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0104f07:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f0104f0e:	e8 86 e3 ff ff       	call   f0103299 <user_mem_check>
f0104f13:	83 c4 10             	add    $0x10,%esp
f0104f16:	85 c0                	test   %eax,%eax
f0104f18:	75 45                	jne    f0104f5f <syscall+0x6fc>
		return nvme_read(secno, buf, nsecs);
f0104f1a:	0f b7 45 14          	movzwl 0x14(%ebp),%eax
f0104f1e:	50                   	push   %eax
f0104f1f:	ff 75 10             	pushl  0x10(%ebp)
f0104f22:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104f25:	ba 00 00 00 00       	mov    $0x0,%edx
f0104f2a:	52                   	push   %edx
f0104f2b:	50                   	push   %eax
f0104f2c:	e8 c3 25 00 00       	call   f01074f4 <nvme_read>
f0104f31:	83 c4 10             	add    $0x10,%esp
f0104f34:	e9 86 f9 ff ff       	jmp    f01048bf <syscall+0x5c>
	console_color = color;
f0104f39:	8b 45 0c             	mov    0xc(%ebp),%eax
f0104f3c:	a3 ac 6f 2c f0       	mov    %eax,0xf02c6fac
		return 0;
f0104f41:	b8 00 00 00 00       	mov    $0x0,%eax
f0104f46:	e9 74 f9 ff ff       	jmp    f01048bf <syscall+0x5c>
		return -E_INVAL;
f0104f4b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0104f50:	e9 6a f9 ff ff       	jmp    f01048bf <syscall+0x5c>
	return -1;
f0104f55:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f5a:	e9 60 f9 ff ff       	jmp    f01048bf <syscall+0x5c>
	return -1;
f0104f5f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0104f64:	e9 56 f9 ff ff       	jmp    f01048bf <syscall+0x5c>

f0104f69 <stab_binsearch>:
//	will exit setting left = 118, right = 554.
//
static void
stab_binsearch(const struct Stab *stabs, int *region_left, int *region_right,
	       int type, uintptr_t addr)
{
f0104f69:	55                   	push   %ebp
f0104f6a:	89 e5                	mov    %esp,%ebp
f0104f6c:	57                   	push   %edi
f0104f6d:	56                   	push   %esi
f0104f6e:	53                   	push   %ebx
f0104f6f:	83 ec 14             	sub    $0x14,%esp
f0104f72:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0104f75:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0104f78:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0104f7b:	8b 7d 08             	mov    0x8(%ebp),%edi
	int l = *region_left, r = *region_right, any_matches = 0;
f0104f7e:	8b 1a                	mov    (%edx),%ebx
f0104f80:	8b 01                	mov    (%ecx),%eax
f0104f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104f85:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)

	while (l <= r) {
f0104f8c:	eb 34                	jmp    f0104fc2 <stab_binsearch+0x59>
		int true_m = (l + r) / 2, m = true_m;

		// search for earliest stab with right type
		while (m >= l && stabs[m].n_type != type)
			m--;
f0104f8e:	48                   	dec    %eax
		while (m >= l && stabs[m].n_type != type)
f0104f8f:	39 c3                	cmp    %eax,%ebx
f0104f91:	7f 2c                	jg     f0104fbf <stab_binsearch+0x56>
f0104f93:	0f b6 0a             	movzbl (%edx),%ecx
f0104f96:	83 ea 0c             	sub    $0xc,%edx
f0104f99:	39 f9                	cmp    %edi,%ecx
f0104f9b:	75 f1                	jne    f0104f8e <stab_binsearch+0x25>
			continue;
		}

		// actual binary search
		any_matches = 1;
		if (stabs[m].n_value < addr) {
f0104f9d:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0104fa0:	01 c2                	add    %eax,%edx
f0104fa2:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104fa5:	8b 54 91 08          	mov    0x8(%ecx,%edx,4),%edx
f0104fa9:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0104fac:	76 37                	jbe    f0104fe5 <stab_binsearch+0x7c>
			*region_left = m;
f0104fae:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
f0104fb1:	89 03                	mov    %eax,(%ebx)
			l = true_m + 1;
f0104fb3:	8d 5e 01             	lea    0x1(%esi),%ebx
		any_matches = 1;
f0104fb6:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104fbd:	eb 03                	jmp    f0104fc2 <stab_binsearch+0x59>
			l = true_m + 1;
f0104fbf:	8d 5e 01             	lea    0x1(%esi),%ebx
	while (l <= r) {
f0104fc2:	3b 5d f0             	cmp    -0x10(%ebp),%ebx
f0104fc5:	7f 48                	jg     f010500f <stab_binsearch+0xa6>
		int true_m = (l + r) / 2, m = true_m;
f0104fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
f0104fca:	01 d8                	add    %ebx,%eax
f0104fcc:	89 c6                	mov    %eax,%esi
f0104fce:	c1 ee 1f             	shr    $0x1f,%esi
f0104fd1:	01 c6                	add    %eax,%esi
f0104fd3:	d1 fe                	sar    %esi
f0104fd5:	8d 04 36             	lea    (%esi,%esi,1),%eax
f0104fd8:	01 f0                	add    %esi,%eax
f0104fda:	8b 4d ec             	mov    -0x14(%ebp),%ecx
f0104fdd:	8d 54 81 04          	lea    0x4(%ecx,%eax,4),%edx
f0104fe1:	89 f0                	mov    %esi,%eax
		while (m >= l && stabs[m].n_type != type)
f0104fe3:	eb aa                	jmp    f0104f8f <stab_binsearch+0x26>
		} else if (stabs[m].n_value > addr) {
f0104fe5:	39 55 0c             	cmp    %edx,0xc(%ebp)
f0104fe8:	73 12                	jae    f0104ffc <stab_binsearch+0x93>
			*region_right = m - 1;
f0104fea:	48                   	dec    %eax
f0104feb:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0104fee:	8b 75 e0             	mov    -0x20(%ebp),%esi
f0104ff1:	89 06                	mov    %eax,(%esi)
		any_matches = 1;
f0104ff3:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f0104ffa:	eb c6                	jmp    f0104fc2 <stab_binsearch+0x59>
			r = m - 1;
		} else {
			// exact match for 'addr', but continue loop to find
			// *region_right
			*region_left = m;
f0104ffc:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f0104fff:	89 06                	mov    %eax,(%esi)
			l = m;
			addr++;
f0105001:	ff 45 0c             	incl   0xc(%ebp)
f0105004:	89 c3                	mov    %eax,%ebx
		any_matches = 1;
f0105006:	c7 45 e8 01 00 00 00 	movl   $0x1,-0x18(%ebp)
f010500d:	eb b3                	jmp    f0104fc2 <stab_binsearch+0x59>
		}
	}

	if (!any_matches)
f010500f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
f0105013:	74 18                	je     f010502d <stab_binsearch+0xc4>
		*region_right = *region_left - 1;
	else {
		// find rightmost region containing 'addr'
		for (l = *region_right;
f0105015:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105018:	8b 00                	mov    (%eax),%eax
		     l > *region_left && stabs[l].n_type != type;
f010501a:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f010501d:	8b 0e                	mov    (%esi),%ecx
f010501f:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0105022:	01 c2                	add    %eax,%edx
f0105024:	8b 75 ec             	mov    -0x14(%ebp),%esi
f0105027:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
		for (l = *region_right;
f010502b:	eb 0e                	jmp    f010503b <stab_binsearch+0xd2>
		*region_right = *region_left - 1;
f010502d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105030:	8b 00                	mov    (%eax),%eax
f0105032:	48                   	dec    %eax
f0105033:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105036:	89 07                	mov    %eax,(%edi)
f0105038:	eb 14                	jmp    f010504e <stab_binsearch+0xe5>
		     l--)
f010503a:	48                   	dec    %eax
		for (l = *region_right;
f010503b:	39 c8                	cmp    %ecx,%eax
f010503d:	7e 0a                	jle    f0105049 <stab_binsearch+0xe0>
		     l > *region_left && stabs[l].n_type != type;
f010503f:	0f b6 1a             	movzbl (%edx),%ebx
f0105042:	83 ea 0c             	sub    $0xc,%edx
f0105045:	39 df                	cmp    %ebx,%edi
f0105047:	75 f1                	jne    f010503a <stab_binsearch+0xd1>
			/* do nothing */;
		*region_left = l;
f0105049:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010504c:	89 07                	mov    %eax,(%edi)
	}
}
f010504e:	83 c4 14             	add    $0x14,%esp
f0105051:	5b                   	pop    %ebx
f0105052:	5e                   	pop    %esi
f0105053:	5f                   	pop    %edi
f0105054:	5d                   	pop    %ebp
f0105055:	c3                   	ret    

f0105056 <debuginfo_eip>:
//	negative if not.  But even if it returns negative it has stored some
//	information into '*info'.
//
int
debuginfo_eip(uintptr_t addr, struct Eipdebuginfo *info)
{
f0105056:	55                   	push   %ebp
f0105057:	89 e5                	mov    %esp,%ebp
f0105059:	57                   	push   %edi
f010505a:	56                   	push   %esi
f010505b:	53                   	push   %ebx
f010505c:	83 ec 3c             	sub    $0x3c,%esp
f010505f:	8b 7d 0c             	mov    0xc(%ebp),%edi
	const struct Stab *stabs, *stab_end;
	const char *stabstr, *stabstr_end;
	int lfile, rfile, lfun, rfun, lline, rline;

	// Initialize *info
	info->eip_file = "<unknown>";
f0105062:	c7 07 f4 90 10 f0    	movl   $0xf01090f4,(%edi)
	info->eip_line = 0;
f0105068:	c7 47 04 00 00 00 00 	movl   $0x0,0x4(%edi)
	info->eip_fn_name = "<unknown>";
f010506f:	c7 47 08 f4 90 10 f0 	movl   $0xf01090f4,0x8(%edi)
	info->eip_fn_namelen = 9;
f0105076:	c7 47 0c 09 00 00 00 	movl   $0x9,0xc(%edi)
	info->eip_fn_addr = addr;
f010507d:	8b 45 08             	mov    0x8(%ebp),%eax
f0105080:	89 47 10             	mov    %eax,0x10(%edi)
	info->eip_fn_narg = 0;
f0105083:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)

	// Find the relevant set of stabs
	if (addr >= ULIM) {
f010508a:	3d ff ff 7f ef       	cmp    $0xef7fffff,%eax
f010508f:	0f 86 3c 01 00 00    	jbe    f01051d1 <debuginfo_eip+0x17b>
		stabs = __STAB_BEGIN__;
		stab_end = __STAB_END__;
		stabstr = __STABSTR_BEGIN__;
		stabstr_end = __STABSTR_END__;
f0105095:	c7 45 b8 e9 f8 11 f0 	movl   $0xf011f8e9,-0x48(%ebp)
		stabstr = __STABSTR_BEGIN__;
f010509c:	c7 45 bc e9 7f 11 f0 	movl   $0xf0117fe9,-0x44(%ebp)
		stab_end = __STAB_END__;
f01050a3:	c7 45 c4 e8 7f 11 f0 	movl   $0xf0117fe8,-0x3c(%ebp)
		stabs = __STAB_BEGIN__;
f01050aa:	c7 45 c0 ac 9e 10 f0 	movl   $0xf0109eac,-0x40(%ebp)
		if (user_mem_check(curenv, stabstr, stabstr_end - stabstr, PTE_P) < 0) 
			return -1;
	}

	// String table validity checks
	if (stabstr_end <= stabstr || stabstr_end[-1] != 0)
f01050b1:	8b 45 b8             	mov    -0x48(%ebp),%eax
f01050b4:	39 45 bc             	cmp    %eax,-0x44(%ebp)
f01050b7:	0f 83 b2 02 00 00    	jae    f010536f <debuginfo_eip+0x319>
f01050bd:	89 c3                	mov    %eax,%ebx
f01050bf:	80 78 ff 00          	cmpb   $0x0,-0x1(%eax)
f01050c3:	0f 85 ad 02 00 00    	jne    f0105376 <debuginfo_eip+0x320>
	// 'eip'.  First, we find the basic source file containing 'eip'.
	// Then, we look in that source file for the function.  Then we look
	// for the line number.

	// Search the entire set of stabs for the source file (type N_SO).
	lfile = 0;
f01050c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	rfile = (stab_end - stabs) - 1;
f01050d0:	8b 75 c4             	mov    -0x3c(%ebp),%esi
f01050d3:	2b 75 c0             	sub    -0x40(%ebp),%esi
f01050d6:	c1 fe 02             	sar    $0x2,%esi
f01050d9:	8d 04 b6             	lea    (%esi,%esi,4),%eax
f01050dc:	8d 04 86             	lea    (%esi,%eax,4),%eax
f01050df:	8d 04 86             	lea    (%esi,%eax,4),%eax
f01050e2:	89 c2                	mov    %eax,%edx
f01050e4:	c1 e2 08             	shl    $0x8,%edx
f01050e7:	01 d0                	add    %edx,%eax
f01050e9:	89 c2                	mov    %eax,%edx
f01050eb:	c1 e2 10             	shl    $0x10,%edx
f01050ee:	01 d0                	add    %edx,%eax
f01050f0:	01 c0                	add    %eax,%eax
f01050f2:	8d 44 06 ff          	lea    -0x1(%esi,%eax,1),%eax
f01050f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
	stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
f01050f9:	83 ec 08             	sub    $0x8,%esp
f01050fc:	ff 75 08             	pushl  0x8(%ebp)
f01050ff:	6a 64                	push   $0x64
f0105101:	8d 4d e0             	lea    -0x20(%ebp),%ecx
f0105104:	8d 55 e4             	lea    -0x1c(%ebp),%edx
f0105107:	8b 75 c0             	mov    -0x40(%ebp),%esi
f010510a:	89 f0                	mov    %esi,%eax
f010510c:	e8 58 fe ff ff       	call   f0104f69 <stab_binsearch>
	if (lfile == 0)
f0105111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f0105114:	83 c4 10             	add    $0x10,%esp
f0105117:	85 c0                	test   %eax,%eax
f0105119:	0f 84 5e 02 00 00    	je     f010537d <debuginfo_eip+0x327>
		return -1;

	// Search within that file's stabs for the function definition
	// (N_FUN).
	lfun = lfile;
f010511f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	rfun = rfile;
f0105122:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0105125:	89 45 d8             	mov    %eax,-0x28(%ebp)
	stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
f0105128:	83 ec 08             	sub    $0x8,%esp
f010512b:	ff 75 08             	pushl  0x8(%ebp)
f010512e:	6a 24                	push   $0x24
f0105130:	8d 4d d8             	lea    -0x28(%ebp),%ecx
f0105133:	8d 55 dc             	lea    -0x24(%ebp),%edx
f0105136:	89 f0                	mov    %esi,%eax
f0105138:	e8 2c fe ff ff       	call   f0104f69 <stab_binsearch>

	if (lfun <= rfun) {
f010513d:	8b 45 dc             	mov    -0x24(%ebp),%eax
f0105140:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105143:	83 c4 10             	add    $0x10,%esp
f0105146:	39 d0                	cmp    %edx,%eax
f0105148:	0f 8f 65 01 00 00    	jg     f01052b3 <debuginfo_eip+0x25d>
		// stabs[lfun] points to the function name
		// in the string table, but check bounds just in case.
		if (stabs[lfun].n_strx < stabstr_end - stabstr)
f010514e:	8d 0c 00             	lea    (%eax,%eax,1),%ecx
f0105151:	01 c1                	add    %eax,%ecx
f0105153:	8d 34 8e             	lea    (%esi,%ecx,4),%esi
f0105156:	8b 0e                	mov    (%esi),%ecx
f0105158:	2b 5d bc             	sub    -0x44(%ebp),%ebx
f010515b:	39 d9                	cmp    %ebx,%ecx
f010515d:	73 06                	jae    f0105165 <debuginfo_eip+0x10f>
			info->eip_fn_name = stabstr + stabs[lfun].n_strx;
f010515f:	03 4d bc             	add    -0x44(%ebp),%ecx
f0105162:	89 4f 08             	mov    %ecx,0x8(%edi)
		info->eip_fn_addr = stabs[lfun].n_value;
f0105165:	8b 4e 08             	mov    0x8(%esi),%ecx
f0105168:	89 4f 10             	mov    %ecx,0x10(%edi)
		addr -= info->eip_fn_addr;
f010516b:	29 4d 08             	sub    %ecx,0x8(%ebp)
		// Search within the function definition for the line number.
		lline = lfun;
f010516e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfun;
f0105171:	89 55 d0             	mov    %edx,-0x30(%ebp)
		info->eip_fn_addr = addr;
		lline = lfile;
		rline = rfile;
	}
	// Ignore stuff after the colon.
	info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
f0105174:	83 ec 08             	sub    $0x8,%esp
f0105177:	6a 3a                	push   $0x3a
f0105179:	ff 77 08             	pushl  0x8(%edi)
f010517c:	e8 84 0b 00 00       	call   f0105d05 <strfind>
f0105181:	2b 47 08             	sub    0x8(%edi),%eax
f0105184:	89 47 0c             	mov    %eax,0xc(%edi)
	// Hint:
	//	There's a particular stabs type used for line numbers.
	//	Look at the STABS documentation and <inc/stab.h> to find
	//	which one.
	// Your code here.
	stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
f0105187:	83 c4 08             	add    $0x8,%esp
f010518a:	ff 75 08             	pushl  0x8(%ebp)
f010518d:	6a 44                	push   $0x44
f010518f:	8d 4d d0             	lea    -0x30(%ebp),%ecx
f0105192:	8d 55 d4             	lea    -0x2c(%ebp),%edx
f0105195:	8b 5d c0             	mov    -0x40(%ebp),%ebx
f0105198:	89 d8                	mov    %ebx,%eax
f010519a:	e8 ca fd ff ff       	call   f0104f69 <stab_binsearch>
    if (lline > rline) return -1;
f010519f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01051a2:	83 c4 10             	add    $0x10,%esp
f01051a5:	3b 45 d0             	cmp    -0x30(%ebp),%eax
f01051a8:	0f 8f d6 01 00 00    	jg     f0105384 <debuginfo_eip+0x32e>
	info->eip_line = stabs[lline].n_desc;
f01051ae:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01051b1:	01 c2                	add    %eax,%edx
f01051b3:	c1 e2 02             	shl    $0x2,%edx
f01051b6:	0f b7 4c 13 06       	movzwl 0x6(%ebx,%edx,1),%ecx
f01051bb:	89 4f 04             	mov    %ecx,0x4(%edi)
	// Search backwards from the line number for the relevant filename
	// stab.
	// We can't just use the "lfile" stab because inlined functions
	// can interpolate code from a different file!
	// Such included source files use the N_SOL stab type.
	while (lline >= lfile
f01051be:	8b 75 e4             	mov    -0x1c(%ebp),%esi
f01051c1:	8d 54 13 04          	lea    0x4(%ebx,%edx,1),%edx
f01051c5:	c6 45 c4 00          	movb   $0x0,-0x3c(%ebp)
f01051c9:	89 7d 0c             	mov    %edi,0xc(%ebp)
f01051cc:	e9 01 01 00 00       	jmp    f01052d2 <debuginfo_eip+0x27c>
		if (user_mem_check(curenv, usd, sizeof(struct UserStabData), PTE_P) < 0) 
f01051d1:	e8 52 12 00 00       	call   f0106428 <cpunum>
f01051d6:	6a 01                	push   $0x1
f01051d8:	6a 10                	push   $0x10
f01051da:	68 00 00 20 00       	push   $0x200000
f01051df:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01051e2:	01 c2                	add    %eax,%edx
f01051e4:	01 d2                	add    %edx,%edx
f01051e6:	01 c2                	add    %eax,%edx
f01051e8:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01051eb:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f01051f2:	e8 a2 e0 ff ff       	call   f0103299 <user_mem_check>
f01051f7:	83 c4 10             	add    $0x10,%esp
f01051fa:	85 c0                	test   %eax,%eax
f01051fc:	0f 88 5f 01 00 00    	js     f0105361 <debuginfo_eip+0x30b>
		stabs = usd->stabs;
f0105202:	a1 00 00 20 00       	mov    0x200000,%eax
f0105207:	89 c3                	mov    %eax,%ebx
f0105209:	89 45 c0             	mov    %eax,-0x40(%ebp)
		stab_end = usd->stab_end;
f010520c:	a1 04 00 20 00       	mov    0x200004,%eax
f0105211:	89 c6                	mov    %eax,%esi
f0105213:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		stabstr = usd->stabstr;
f0105216:	a1 08 00 20 00       	mov    0x200008,%eax
f010521b:	89 45 bc             	mov    %eax,-0x44(%ebp)
		stabstr_end = usd->stabstr_end;
f010521e:	8b 0d 0c 00 20 00    	mov    0x20000c,%ecx
f0105224:	89 4d b8             	mov    %ecx,-0x48(%ebp)
		if (user_mem_check(curenv, stabs, stab_end - stabs, PTE_P) < 0) 
f0105227:	e8 fc 11 00 00       	call   f0106428 <cpunum>
f010522c:	6a 01                	push   $0x1
f010522e:	89 f1                	mov    %esi,%ecx
f0105230:	29 d9                	sub    %ebx,%ecx
f0105232:	c1 f9 02             	sar    $0x2,%ecx
f0105235:	8d 14 89             	lea    (%ecx,%ecx,4),%edx
f0105238:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010523b:	8d 14 91             	lea    (%ecx,%edx,4),%edx
f010523e:	89 d6                	mov    %edx,%esi
f0105240:	c1 e6 08             	shl    $0x8,%esi
f0105243:	01 f2                	add    %esi,%edx
f0105245:	89 d6                	mov    %edx,%esi
f0105247:	c1 e6 10             	shl    $0x10,%esi
f010524a:	01 f2                	add    %esi,%edx
f010524c:	01 d2                	add    %edx,%edx
f010524e:	01 d1                	add    %edx,%ecx
f0105250:	51                   	push   %ecx
f0105251:	53                   	push   %ebx
f0105252:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0105255:	01 c2                	add    %eax,%edx
f0105257:	01 d2                	add    %edx,%edx
f0105259:	01 c2                	add    %eax,%edx
f010525b:	8d 04 90             	lea    (%eax,%edx,4),%eax
f010525e:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f0105265:	e8 2f e0 ff ff       	call   f0103299 <user_mem_check>
f010526a:	83 c4 10             	add    $0x10,%esp
f010526d:	85 c0                	test   %eax,%eax
f010526f:	0f 88 f3 00 00 00    	js     f0105368 <debuginfo_eip+0x312>
		if (user_mem_check(curenv, stabstr, stabstr_end - stabstr, PTE_P) < 0) 
f0105275:	e8 ae 11 00 00       	call   f0106428 <cpunum>
f010527a:	6a 01                	push   $0x1
f010527c:	8b 55 b8             	mov    -0x48(%ebp),%edx
f010527f:	8b 5d bc             	mov    -0x44(%ebp),%ebx
f0105282:	29 da                	sub    %ebx,%edx
f0105284:	52                   	push   %edx
f0105285:	53                   	push   %ebx
f0105286:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0105289:	01 c2                	add    %eax,%edx
f010528b:	01 d2                	add    %edx,%edx
f010528d:	01 c2                	add    %eax,%edx
f010528f:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0105292:	ff 34 85 08 80 2c f0 	pushl  -0xfd37ff8(,%eax,4)
f0105299:	e8 fb df ff ff       	call   f0103299 <user_mem_check>
f010529e:	83 c4 10             	add    $0x10,%esp
f01052a1:	85 c0                	test   %eax,%eax
f01052a3:	0f 89 08 fe ff ff    	jns    f01050b1 <debuginfo_eip+0x5b>
			return -1;
f01052a9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f01052ae:	e9 dd 00 00 00       	jmp    f0105390 <debuginfo_eip+0x33a>
		info->eip_fn_addr = addr;
f01052b3:	8b 45 08             	mov    0x8(%ebp),%eax
f01052b6:	89 47 10             	mov    %eax,0x10(%edi)
		lline = lfile;
f01052b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01052bc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		rline = rfile;
f01052bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01052c2:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01052c5:	e9 aa fe ff ff       	jmp    f0105174 <debuginfo_eip+0x11e>
f01052ca:	48                   	dec    %eax
f01052cb:	83 ea 0c             	sub    $0xc,%edx
f01052ce:	c6 45 c4 01          	movb   $0x1,-0x3c(%ebp)
	while (lline >= lfile
f01052d2:	39 c6                	cmp    %eax,%esi
f01052d4:	7f 20                	jg     f01052f6 <debuginfo_eip+0x2a0>
	       && stabs[lline].n_type != N_SOL
f01052d6:	8a 0a                	mov    (%edx),%cl
f01052d8:	80 f9 84             	cmp    $0x84,%cl
f01052db:	74 3e                	je     f010531b <debuginfo_eip+0x2c5>
	       && (stabs[lline].n_type != N_SO || !stabs[lline].n_value))
f01052dd:	80 f9 64             	cmp    $0x64,%cl
f01052e0:	75 e8                	jne    f01052ca <debuginfo_eip+0x274>
f01052e2:	83 7a 04 00          	cmpl   $0x0,0x4(%edx)
f01052e6:	74 e2                	je     f01052ca <debuginfo_eip+0x274>
f01052e8:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01052eb:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f01052ef:	74 33                	je     f0105324 <debuginfo_eip+0x2ce>
f01052f1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01052f4:	eb 2e                	jmp    f0105324 <debuginfo_eip+0x2ce>
f01052f6:	8b 7d 0c             	mov    0xc(%ebp),%edi
		info->eip_file = stabstr + stabs[lline].n_strx;


	// Set eip_fn_narg to the number of arguments taken by the function,
	// or 0 if there was no containing function.
	if (lfun < rfun)
f01052f9:	8b 55 dc             	mov    -0x24(%ebp),%edx
f01052fc:	8b 5d d8             	mov    -0x28(%ebp),%ebx
f01052ff:	39 da                	cmp    %ebx,%edx
f0105301:	0f 8d 84 00 00 00    	jge    f010538b <debuginfo_eip+0x335>
		for (lline = lfun + 1;
f0105307:	42                   	inc    %edx
f0105308:	89 55 d4             	mov    %edx,-0x2c(%ebp)
f010530b:	89 d0                	mov    %edx,%eax
f010530d:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
f0105310:	01 ca                	add    %ecx,%edx
f0105312:	8b 75 c0             	mov    -0x40(%ebp),%esi
f0105315:	8d 54 96 04          	lea    0x4(%esi,%edx,4),%edx
f0105319:	eb 30                	jmp    f010534b <debuginfo_eip+0x2f5>
f010531b:	8b 7d 0c             	mov    0xc(%ebp),%edi
f010531e:	80 7d c4 00          	cmpb   $0x0,-0x3c(%ebp)
f0105322:	75 1f                	jne    f0105343 <debuginfo_eip+0x2ed>
	if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr)
f0105324:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0105327:	01 d0                	add    %edx,%eax
f0105329:	8b 75 c0             	mov    -0x40(%ebp),%esi
f010532c:	8b 14 86             	mov    (%esi,%eax,4),%edx
f010532f:	8b 45 b8             	mov    -0x48(%ebp),%eax
f0105332:	8b 75 bc             	mov    -0x44(%ebp),%esi
f0105335:	29 f0                	sub    %esi,%eax
f0105337:	39 c2                	cmp    %eax,%edx
f0105339:	73 be                	jae    f01052f9 <debuginfo_eip+0x2a3>
		info->eip_file = stabstr + stabs[lline].n_strx;
f010533b:	89 f0                	mov    %esi,%eax
f010533d:	01 d0                	add    %edx,%eax
f010533f:	89 07                	mov    %eax,(%edi)
f0105341:	eb b6                	jmp    f01052f9 <debuginfo_eip+0x2a3>
f0105343:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f0105346:	eb dc                	jmp    f0105324 <debuginfo_eip+0x2ce>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
		     lline++)
			info->eip_fn_narg++;
f0105348:	ff 47 14             	incl   0x14(%edi)
		for (lline = lfun + 1;
f010534b:	39 c3                	cmp    %eax,%ebx
f010534d:	7e 49                	jle    f0105398 <debuginfo_eip+0x342>
		     lline < rfun && stabs[lline].n_type == N_PSYM;
f010534f:	8a 0a                	mov    (%edx),%cl
f0105351:	40                   	inc    %eax
f0105352:	83 c2 0c             	add    $0xc,%edx
f0105355:	80 f9 a0             	cmp    $0xa0,%cl
f0105358:	74 ee                	je     f0105348 <debuginfo_eip+0x2f2>

	return 0;
f010535a:	b8 00 00 00 00       	mov    $0x0,%eax
f010535f:	eb 2f                	jmp    f0105390 <debuginfo_eip+0x33a>
			return -1;
f0105361:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105366:	eb 28                	jmp    f0105390 <debuginfo_eip+0x33a>
			return -1;
f0105368:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010536d:	eb 21                	jmp    f0105390 <debuginfo_eip+0x33a>
		return -1;
f010536f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105374:	eb 1a                	jmp    f0105390 <debuginfo_eip+0x33a>
f0105376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f010537b:	eb 13                	jmp    f0105390 <debuginfo_eip+0x33a>
		return -1;
f010537d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105382:	eb 0c                	jmp    f0105390 <debuginfo_eip+0x33a>
    if (lline > rline) return -1;
f0105384:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
f0105389:	eb 05                	jmp    f0105390 <debuginfo_eip+0x33a>
	return 0;
f010538b:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105390:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105393:	5b                   	pop    %ebx
f0105394:	5e                   	pop    %esi
f0105395:	5f                   	pop    %edi
f0105396:	5d                   	pop    %ebp
f0105397:	c3                   	ret    
	return 0;
f0105398:	b8 00 00 00 00       	mov    $0x0,%eax
f010539d:	eb f1                	jmp    f0105390 <debuginfo_eip+0x33a>

f010539f <cpuid_print>:
	return feature[bit / 32] & BIT(bit % 32);
}

void
cpuid_print(void)
{
f010539f:	55                   	push   %ebp
f01053a0:	89 e5                	mov    %esp,%ebp
f01053a2:	57                   	push   %edi
f01053a3:	56                   	push   %esi
f01053a4:	53                   	push   %ebx
f01053a5:	83 ec 6c             	sub    $0x6c,%esp
	uint32_t eax, brand[12], feature[CPUID_NR_FLAGS] = {0};
f01053a8:	8d 7d a4             	lea    -0x5c(%ebp),%edi
f01053ab:	b9 05 00 00 00       	mov    $0x5,%ecx
f01053b0:	b8 00 00 00 00       	mov    $0x0,%eax
f01053b5:	f3 ab                	rep stos %eax,%es:(%edi)
	asm volatile("cpuid"
f01053b7:	b8 00 00 00 80       	mov    $0x80000000,%eax
f01053bc:	0f a2                	cpuid  

	cpuid(0x80000000, &eax, NULL, NULL, NULL);
	if (eax < 0x80000004)
f01053be:	3d 03 00 00 80       	cmp    $0x80000003,%eax
f01053c3:	76 73                	jbe    f0105438 <cpuid_print+0x99>
f01053c5:	b8 02 00 00 80       	mov    $0x80000002,%eax
f01053ca:	0f a2                	cpuid  
		*eaxp = eax;
f01053cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
		*ebxp = ebx;
f01053cf:	89 5d bc             	mov    %ebx,-0x44(%ebp)
		*ecxp = ecx;
f01053d2:	89 4d c0             	mov    %ecx,-0x40(%ebp)
		*edxp = edx;
f01053d5:	89 55 c4             	mov    %edx,-0x3c(%ebp)
	asm volatile("cpuid"
f01053d8:	b8 03 00 00 80       	mov    $0x80000003,%eax
f01053dd:	0f a2                	cpuid  
		*eaxp = eax;
f01053df:	89 45 c8             	mov    %eax,-0x38(%ebp)
		*ebxp = ebx;
f01053e2:	89 5d cc             	mov    %ebx,-0x34(%ebp)
		*ecxp = ecx;
f01053e5:	89 4d d0             	mov    %ecx,-0x30(%ebp)
		*edxp = edx;
f01053e8:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	asm volatile("cpuid"
f01053eb:	b8 04 00 00 80       	mov    $0x80000004,%eax
f01053f0:	0f a2                	cpuid  
		*eaxp = eax;
f01053f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		*ebxp = ebx;
f01053f5:	89 5d dc             	mov    %ebx,-0x24(%ebp)
		*ecxp = ecx;
f01053f8:	89 4d e0             	mov    %ecx,-0x20(%ebp)
		*edxp = edx;
f01053fb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
		panic("CPU too old!");

	cpuid(0x80000002, &brand[0], &brand[1], &brand[2], &brand[3]);
	cpuid(0x80000003, &brand[4], &brand[5], &brand[6], &brand[7]);
	cpuid(0x80000004, &brand[8], &brand[9], &brand[10], &brand[11]);
	cprintf("CPU: %.48s\n", brand);
f01053fe:	83 ec 08             	sub    $0x8,%esp
f0105401:	8d 45 b8             	lea    -0x48(%ebp),%eax
f0105404:	50                   	push   %eax
f0105405:	68 17 91 10 f0       	push   $0xf0109117
f010540a:	e8 94 e8 ff ff       	call   f0103ca3 <cprintf>
	asm volatile("cpuid"
f010540f:	b8 01 00 00 00       	mov    $0x1,%eax
f0105414:	0f a2                	cpuid  
f0105416:	89 55 90             	mov    %edx,-0x70(%ebp)
		*ecxp = ecx;
f0105419:	89 4d a8             	mov    %ecx,-0x58(%ebp)
		*edxp = edx;
f010541c:	89 55 a4             	mov    %edx,-0x5c(%ebp)
	asm volatile("cpuid"
f010541f:	b8 01 00 00 80       	mov    $0x80000001,%eax
f0105424:	0f a2                	cpuid  
		*ecxp = ecx;
f0105426:	89 4d b4             	mov    %ecx,-0x4c(%ebp)
		*edxp = edx;
f0105429:	89 55 b0             	mov    %edx,-0x50(%ebp)
f010542c:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < CPUID_NR_FLAGS; ++i) {
f010542f:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
f0105436:	eb 63                	jmp    f010549b <cpuid_print+0xfc>
		panic("CPU too old!");
f0105438:	83 ec 04             	sub    $0x4,%esp
f010543b:	68 fe 90 10 f0       	push   $0xf01090fe
f0105440:	68 8d 00 00 00       	push   $0x8d
f0105445:	68 0b 91 10 f0       	push   $0xf010910b
f010544a:	e8 f4 ab ff ff       	call   f0100043 <_panic>
				cprintf(" %s", name);
f010544f:	83 ec 08             	sub    $0x8,%esp
f0105452:	50                   	push   %eax
f0105453:	68 42 78 10 f0       	push   $0xf0107842
f0105458:	e8 46 e8 ff ff       	call   f0103ca3 <cprintf>
f010545d:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 32; ++j) {
f0105460:	43                   	inc    %ebx
f0105461:	83 fb 20             	cmp    $0x20,%ebx
f0105464:	74 1a                	je     f0105480 <cpuid_print+0xe1>
			if ((feature[i] & BIT(j)) && name)
f0105466:	89 f0                	mov    %esi,%eax
f0105468:	88 d9                	mov    %bl,%cl
f010546a:	d3 e8                	shr    %cl,%eax
f010546c:	a8 01                	test   $0x1,%al
f010546e:	74 f0                	je     f0105460 <cpuid_print+0xc1>
			const char *name = names[CPUID_BIT(i, j)];
f0105470:	8d 04 3b             	lea    (%ebx,%edi,1),%eax
f0105473:	8b 04 85 80 93 10 f0 	mov    -0xfef6c80(,%eax,4),%eax
			if ((feature[i] & BIT(j)) && name)
f010547a:	85 c0                	test   %eax,%eax
f010547c:	75 d1                	jne    f010544f <cpuid_print+0xb0>
f010547e:	eb e0                	jmp    f0105460 <cpuid_print+0xc1>
		cprintf("\n");
f0105480:	83 ec 0c             	sub    $0xc,%esp
f0105483:	68 ec 8a 10 f0       	push   $0xf0108aec
f0105488:	e8 16 e8 ff ff       	call   f0103ca3 <cprintf>
f010548d:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < CPUID_NR_FLAGS; ++i) {
f0105490:	ff 45 94             	incl   -0x6c(%ebp)
f0105493:	8b 45 94             	mov    -0x6c(%ebp),%eax
f0105496:	83 f8 05             	cmp    $0x5,%eax
f0105499:	74 28                	je     f01054c3 <cpuid_print+0x124>
		if (!feature[i])
f010549b:	8b 45 94             	mov    -0x6c(%ebp),%eax
f010549e:	8b 74 85 a4          	mov    -0x5c(%ebp,%eax,4),%esi
f01054a2:	85 f6                	test   %esi,%esi
f01054a4:	74 ea                	je     f0105490 <cpuid_print+0xf1>
		cprintf(" ");
f01054a6:	83 ec 0c             	sub    $0xc,%esp
f01054a9:	68 a0 7b 10 f0       	push   $0xf0107ba0
f01054ae:	e8 f0 e7 ff ff       	call   f0103ca3 <cprintf>
f01054b3:	8b 7d 94             	mov    -0x6c(%ebp),%edi
f01054b6:	c1 e7 05             	shl    $0x5,%edi
f01054b9:	83 c4 10             	add    $0x10,%esp
		for (j = 0; j < 32; ++j) {
f01054bc:	bb 00 00 00 00       	mov    $0x0,%ebx
f01054c1:	eb a3                	jmp    f0105466 <cpuid_print+0xc7>
	      &feature[CPUID_1_ECX], &feature[CPUID_1_EDX]);
	cpuid(0x80000001, NULL, NULL,
	      &feature[CPUID_80000001_ECX], &feature[CPUID_80000001_EDX]);
	print_feature(feature);
	// Check feature bits.
	assert(cpuid_has(feature, CPUID_FEATURE_PSE));
f01054c3:	f6 45 90 08          	testb  $0x8,-0x70(%ebp)
f01054c7:	74 11                	je     f01054da <cpuid_print+0x13b>
	assert(cpuid_has(feature, CPUID_FEATURE_APIC));
f01054c9:	f7 45 90 00 02 00 00 	testl  $0x200,-0x70(%ebp)
f01054d0:	74 21                	je     f01054f3 <cpuid_print+0x154>
}
f01054d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01054d5:	5b                   	pop    %ebx
f01054d6:	5e                   	pop    %esi
f01054d7:	5f                   	pop    %edi
f01054d8:	5d                   	pop    %ebp
f01054d9:	c3                   	ret    
	assert(cpuid_has(feature, CPUID_FEATURE_PSE));
f01054da:	68 1c 93 10 f0       	push   $0xf010931c
f01054df:	68 31 78 10 f0       	push   $0xf0107831
f01054e4:	68 9a 00 00 00       	push   $0x9a
f01054e9:	68 0b 91 10 f0       	push   $0xf010910b
f01054ee:	e8 50 ab ff ff       	call   f0100043 <_panic>
	assert(cpuid_has(feature, CPUID_FEATURE_APIC));
f01054f3:	68 44 93 10 f0       	push   $0xf0109344
f01054f8:	68 31 78 10 f0       	push   $0xf0107831
f01054fd:	68 9b 00 00 00       	push   $0x9b
f0105502:	68 0b 91 10 f0       	push   $0xf010910b
f0105507:	e8 37 ab ff ff       	call   f0100043 <_panic>

f010550c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f010550c:	55                   	push   %ebp
f010550d:	89 e5                	mov    %esp,%ebp
f010550f:	57                   	push   %edi
f0105510:	56                   	push   %esi
f0105511:	53                   	push   %ebx
f0105512:	83 ec 1c             	sub    $0x1c,%esp
f0105515:	89 c7                	mov    %eax,%edi
f0105517:	89 d6                	mov    %edx,%esi
f0105519:	8b 45 08             	mov    0x8(%ebp),%eax
f010551c:	8b 55 0c             	mov    0xc(%ebp),%edx
f010551f:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105522:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0105525:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0105528:	bb 00 00 00 00       	mov    $0x0,%ebx
f010552d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f0105530:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
f0105533:	39 d3                	cmp    %edx,%ebx
f0105535:	72 05                	jb     f010553c <printnum+0x30>
f0105537:	39 45 10             	cmp    %eax,0x10(%ebp)
f010553a:	77 78                	ja     f01055b4 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010553c:	83 ec 0c             	sub    $0xc,%esp
f010553f:	ff 75 18             	pushl  0x18(%ebp)
f0105542:	8b 45 14             	mov    0x14(%ebp),%eax
f0105545:	8d 58 ff             	lea    -0x1(%eax),%ebx
f0105548:	53                   	push   %ebx
f0105549:	ff 75 10             	pushl  0x10(%ebp)
f010554c:	83 ec 08             	sub    $0x8,%esp
f010554f:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105552:	ff 75 e0             	pushl  -0x20(%ebp)
f0105555:	ff 75 dc             	pushl  -0x24(%ebp)
f0105558:	ff 75 d8             	pushl  -0x28(%ebp)
f010555b:	e8 d4 1f 00 00       	call   f0107534 <__udivdi3>
f0105560:	83 c4 18             	add    $0x18,%esp
f0105563:	52                   	push   %edx
f0105564:	50                   	push   %eax
f0105565:	89 f2                	mov    %esi,%edx
f0105567:	89 f8                	mov    %edi,%eax
f0105569:	e8 9e ff ff ff       	call   f010550c <printnum>
f010556e:	83 c4 20             	add    $0x20,%esp
f0105571:	eb 11                	jmp    f0105584 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f0105573:	83 ec 08             	sub    $0x8,%esp
f0105576:	56                   	push   %esi
f0105577:	ff 75 18             	pushl  0x18(%ebp)
f010557a:	ff d7                	call   *%edi
f010557c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
f010557f:	4b                   	dec    %ebx
f0105580:	85 db                	test   %ebx,%ebx
f0105582:	7f ef                	jg     f0105573 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f0105584:	83 ec 08             	sub    $0x8,%esp
f0105587:	56                   	push   %esi
f0105588:	83 ec 04             	sub    $0x4,%esp
f010558b:	ff 75 e4             	pushl  -0x1c(%ebp)
f010558e:	ff 75 e0             	pushl  -0x20(%ebp)
f0105591:	ff 75 dc             	pushl  -0x24(%ebp)
f0105594:	ff 75 d8             	pushl  -0x28(%ebp)
f0105597:	e8 a8 20 00 00       	call   f0107644 <__umoddi3>
f010559c:	83 c4 14             	add    $0x14,%esp
f010559f:	0f be 80 00 96 10 f0 	movsbl -0xfef6a00(%eax),%eax
f01055a6:	50                   	push   %eax
f01055a7:	ff d7                	call   *%edi
}
f01055a9:	83 c4 10             	add    $0x10,%esp
f01055ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01055af:	5b                   	pop    %ebx
f01055b0:	5e                   	pop    %esi
f01055b1:	5f                   	pop    %edi
f01055b2:	5d                   	pop    %ebp
f01055b3:	c3                   	ret    
f01055b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
f01055b7:	eb c6                	jmp    f010557f <printnum+0x73>

f01055b9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f01055b9:	55                   	push   %ebp
f01055ba:	89 e5                	mov    %esp,%ebp
f01055bc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
f01055bf:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
f01055c2:	8b 10                	mov    (%eax),%edx
f01055c4:	3b 50 04             	cmp    0x4(%eax),%edx
f01055c7:	73 0a                	jae    f01055d3 <sprintputch+0x1a>
		*b->buf++ = ch;
f01055c9:	8d 4a 01             	lea    0x1(%edx),%ecx
f01055cc:	89 08                	mov    %ecx,(%eax)
f01055ce:	8b 45 08             	mov    0x8(%ebp),%eax
f01055d1:	88 02                	mov    %al,(%edx)
}
f01055d3:	5d                   	pop    %ebp
f01055d4:	c3                   	ret    

f01055d5 <printfmt>:
{
f01055d5:	55                   	push   %ebp
f01055d6:	89 e5                	mov    %esp,%ebp
f01055d8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
f01055db:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f01055de:	50                   	push   %eax
f01055df:	ff 75 10             	pushl  0x10(%ebp)
f01055e2:	ff 75 0c             	pushl  0xc(%ebp)
f01055e5:	ff 75 08             	pushl  0x8(%ebp)
f01055e8:	e8 05 00 00 00       	call   f01055f2 <vprintfmt>
}
f01055ed:	83 c4 10             	add    $0x10,%esp
f01055f0:	c9                   	leave  
f01055f1:	c3                   	ret    

f01055f2 <vprintfmt>:
{
f01055f2:	55                   	push   %ebp
f01055f3:	89 e5                	mov    %esp,%ebp
f01055f5:	57                   	push   %edi
f01055f6:	56                   	push   %esi
f01055f7:	53                   	push   %ebx
f01055f8:	83 ec 2c             	sub    $0x2c,%esp
f01055fb:	8b 75 08             	mov    0x8(%ebp),%esi
f01055fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
f0105601:	8b 7d 10             	mov    0x10(%ebp),%edi
f0105604:	e9 ae 03 00 00       	jmp    f01059b7 <vprintfmt+0x3c5>
f0105609:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
f010560d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
f0105614:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f010561b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
f0105622:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
f0105627:	8d 47 01             	lea    0x1(%edi),%eax
f010562a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010562d:	8a 17                	mov    (%edi),%dl
f010562f:	8d 42 dd             	lea    -0x23(%edx),%eax
f0105632:	3c 55                	cmp    $0x55,%al
f0105634:	0f 87 fe 03 00 00    	ja     f0105a38 <vprintfmt+0x446>
f010563a:	0f b6 c0             	movzbl %al,%eax
f010563d:	ff 24 85 40 97 10 f0 	jmp    *-0xfef68c0(,%eax,4)
f0105644:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
f0105647:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
f010564b:	eb da                	jmp    f0105627 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f010564d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
f0105650:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
f0105654:	eb d1                	jmp    f0105627 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
f0105656:	0f b6 d2             	movzbl %dl,%edx
f0105659:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f010565c:	b8 00 00 00 00       	mov    $0x0,%eax
f0105661:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
f0105664:	8d 04 80             	lea    (%eax,%eax,4),%eax
f0105667:	01 c0                	add    %eax,%eax
f0105669:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
f010566d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
f0105670:	8d 4a d0             	lea    -0x30(%edx),%ecx
f0105673:	83 f9 09             	cmp    $0x9,%ecx
f0105676:	77 52                	ja     f01056ca <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
f0105678:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
f0105679:	eb e9                	jmp    f0105664 <vprintfmt+0x72>
			precision = va_arg(ap, int);
f010567b:	8b 45 14             	mov    0x14(%ebp),%eax
f010567e:	8b 00                	mov    (%eax),%eax
f0105680:	89 45 d0             	mov    %eax,-0x30(%ebp)
f0105683:	8b 45 14             	mov    0x14(%ebp),%eax
f0105686:	8d 40 04             	lea    0x4(%eax),%eax
f0105689:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
f010568c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
f010568f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f0105693:	79 92                	jns    f0105627 <vprintfmt+0x35>
				width = precision, precision = -1;
f0105695:	8b 45 d0             	mov    -0x30(%ebp),%eax
f0105698:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010569b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
f01056a2:	eb 83                	jmp    f0105627 <vprintfmt+0x35>
f01056a4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f01056a8:	78 08                	js     f01056b2 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
f01056aa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01056ad:	e9 75 ff ff ff       	jmp    f0105627 <vprintfmt+0x35>
f01056b2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
f01056b9:	eb ef                	jmp    f01056aa <vprintfmt+0xb8>
f01056bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
f01056be:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
f01056c5:	e9 5d ff ff ff       	jmp    f0105627 <vprintfmt+0x35>
f01056ca:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
f01056cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
f01056d0:	eb bd                	jmp    f010568f <vprintfmt+0x9d>
			lflag++;
f01056d2:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
f01056d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
f01056d6:	e9 4c ff ff ff       	jmp    f0105627 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
f01056db:	8b 45 14             	mov    0x14(%ebp),%eax
f01056de:	8d 78 04             	lea    0x4(%eax),%edi
f01056e1:	83 ec 08             	sub    $0x8,%esp
f01056e4:	53                   	push   %ebx
f01056e5:	ff 30                	pushl  (%eax)
f01056e7:	ff d6                	call   *%esi
			break;
f01056e9:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
f01056ec:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
f01056ef:	e9 c0 02 00 00       	jmp    f01059b4 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
f01056f4:	8b 45 14             	mov    0x14(%ebp),%eax
f01056f7:	8d 78 04             	lea    0x4(%eax),%edi
f01056fa:	8b 00                	mov    (%eax),%eax
f01056fc:	85 c0                	test   %eax,%eax
f01056fe:	78 2a                	js     f010572a <vprintfmt+0x138>
f0105700:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f0105702:	83 f8 0f             	cmp    $0xf,%eax
f0105705:	7f 27                	jg     f010572e <vprintfmt+0x13c>
f0105707:	8b 04 85 a0 98 10 f0 	mov    -0xfef6760(,%eax,4),%eax
f010570e:	85 c0                	test   %eax,%eax
f0105710:	74 1c                	je     f010572e <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
f0105712:	50                   	push   %eax
f0105713:	68 43 78 10 f0       	push   $0xf0107843
f0105718:	53                   	push   %ebx
f0105719:	56                   	push   %esi
f010571a:	e8 b6 fe ff ff       	call   f01055d5 <printfmt>
f010571f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f0105722:	89 7d 14             	mov    %edi,0x14(%ebp)
f0105725:	e9 8a 02 00 00       	jmp    f01059b4 <vprintfmt+0x3c2>
f010572a:	f7 d8                	neg    %eax
f010572c:	eb d2                	jmp    f0105700 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
f010572e:	52                   	push   %edx
f010572f:	68 18 96 10 f0       	push   $0xf0109618
f0105734:	53                   	push   %ebx
f0105735:	56                   	push   %esi
f0105736:	e8 9a fe ff ff       	call   f01055d5 <printfmt>
f010573b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
f010573e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
f0105741:	e9 6e 02 00 00       	jmp    f01059b4 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
f0105746:	8b 45 14             	mov    0x14(%ebp),%eax
f0105749:	83 c0 04             	add    $0x4,%eax
f010574c:	89 45 cc             	mov    %eax,-0x34(%ebp)
f010574f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105752:	8b 38                	mov    (%eax),%edi
f0105754:	85 ff                	test   %edi,%edi
f0105756:	74 39                	je     f0105791 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
f0105758:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
f010575c:	0f 8e a9 00 00 00    	jle    f010580b <vprintfmt+0x219>
f0105762:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
f0105766:	0f 84 a7 00 00 00    	je     f0105813 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
f010576c:	83 ec 08             	sub    $0x8,%esp
f010576f:	ff 75 d0             	pushl  -0x30(%ebp)
f0105772:	57                   	push   %edi
f0105773:	e8 62 04 00 00       	call   f0105bda <strnlen>
f0105778:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f010577b:	29 c1                	sub    %eax,%ecx
f010577d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
f0105780:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
f0105783:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
f0105787:	89 45 e0             	mov    %eax,-0x20(%ebp)
f010578a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
f010578d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
f010578f:	eb 14                	jmp    f01057a5 <vprintfmt+0x1b3>
				p = "(null)";
f0105791:	bf 11 96 10 f0       	mov    $0xf0109611,%edi
f0105796:	eb c0                	jmp    f0105758 <vprintfmt+0x166>
					putch(padc, putdat);
f0105798:	83 ec 08             	sub    $0x8,%esp
f010579b:	53                   	push   %ebx
f010579c:	ff 75 e0             	pushl  -0x20(%ebp)
f010579f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
f01057a1:	4f                   	dec    %edi
f01057a2:	83 c4 10             	add    $0x10,%esp
f01057a5:	85 ff                	test   %edi,%edi
f01057a7:	7f ef                	jg     f0105798 <vprintfmt+0x1a6>
f01057a9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
f01057ac:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01057af:	89 c8                	mov    %ecx,%eax
f01057b1:	85 c9                	test   %ecx,%ecx
f01057b3:	78 10                	js     f01057c5 <vprintfmt+0x1d3>
f01057b5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
f01057b8:	29 c1                	sub    %eax,%ecx
f01057ba:	89 4d e0             	mov    %ecx,-0x20(%ebp)
f01057bd:	89 75 08             	mov    %esi,0x8(%ebp)
f01057c0:	8b 75 d0             	mov    -0x30(%ebp),%esi
f01057c3:	eb 15                	jmp    f01057da <vprintfmt+0x1e8>
f01057c5:	b8 00 00 00 00       	mov    $0x0,%eax
f01057ca:	eb e9                	jmp    f01057b5 <vprintfmt+0x1c3>
					putch(ch, putdat);
f01057cc:	83 ec 08             	sub    $0x8,%esp
f01057cf:	53                   	push   %ebx
f01057d0:	52                   	push   %edx
f01057d1:	ff 55 08             	call   *0x8(%ebp)
f01057d4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01057d7:	ff 4d e0             	decl   -0x20(%ebp)
f01057da:	47                   	inc    %edi
f01057db:	8a 47 ff             	mov    -0x1(%edi),%al
f01057de:	0f be d0             	movsbl %al,%edx
f01057e1:	85 d2                	test   %edx,%edx
f01057e3:	74 59                	je     f010583e <vprintfmt+0x24c>
f01057e5:	85 f6                	test   %esi,%esi
f01057e7:	78 03                	js     f01057ec <vprintfmt+0x1fa>
f01057e9:	4e                   	dec    %esi
f01057ea:	78 2f                	js     f010581b <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
f01057ec:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
f01057f0:	74 da                	je     f01057cc <vprintfmt+0x1da>
f01057f2:	0f be c0             	movsbl %al,%eax
f01057f5:	83 e8 20             	sub    $0x20,%eax
f01057f8:	83 f8 5e             	cmp    $0x5e,%eax
f01057fb:	76 cf                	jbe    f01057cc <vprintfmt+0x1da>
					putch('?', putdat);
f01057fd:	83 ec 08             	sub    $0x8,%esp
f0105800:	53                   	push   %ebx
f0105801:	6a 3f                	push   $0x3f
f0105803:	ff 55 08             	call   *0x8(%ebp)
f0105806:	83 c4 10             	add    $0x10,%esp
f0105809:	eb cc                	jmp    f01057d7 <vprintfmt+0x1e5>
f010580b:	89 75 08             	mov    %esi,0x8(%ebp)
f010580e:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105811:	eb c7                	jmp    f01057da <vprintfmt+0x1e8>
f0105813:	89 75 08             	mov    %esi,0x8(%ebp)
f0105816:	8b 75 d0             	mov    -0x30(%ebp),%esi
f0105819:	eb bf                	jmp    f01057da <vprintfmt+0x1e8>
f010581b:	8b 75 08             	mov    0x8(%ebp),%esi
f010581e:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105821:	eb 0c                	jmp    f010582f <vprintfmt+0x23d>
				putch(' ', putdat);
f0105823:	83 ec 08             	sub    $0x8,%esp
f0105826:	53                   	push   %ebx
f0105827:	6a 20                	push   $0x20
f0105829:	ff d6                	call   *%esi
			for (; width > 0; width--)
f010582b:	4f                   	dec    %edi
f010582c:	83 c4 10             	add    $0x10,%esp
f010582f:	85 ff                	test   %edi,%edi
f0105831:	7f f0                	jg     f0105823 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
f0105833:	8b 45 cc             	mov    -0x34(%ebp),%eax
f0105836:	89 45 14             	mov    %eax,0x14(%ebp)
f0105839:	e9 76 01 00 00       	jmp    f01059b4 <vprintfmt+0x3c2>
f010583e:	8b 7d e0             	mov    -0x20(%ebp),%edi
f0105841:	8b 75 08             	mov    0x8(%ebp),%esi
f0105844:	eb e9                	jmp    f010582f <vprintfmt+0x23d>
	if (lflag >= 2)
f0105846:	83 f9 01             	cmp    $0x1,%ecx
f0105849:	7f 1f                	jg     f010586a <vprintfmt+0x278>
	else if (lflag)
f010584b:	85 c9                	test   %ecx,%ecx
f010584d:	75 48                	jne    f0105897 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
f010584f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105852:	8b 00                	mov    (%eax),%eax
f0105854:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105857:	89 c1                	mov    %eax,%ecx
f0105859:	c1 f9 1f             	sar    $0x1f,%ecx
f010585c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f010585f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105862:	8d 40 04             	lea    0x4(%eax),%eax
f0105865:	89 45 14             	mov    %eax,0x14(%ebp)
f0105868:	eb 17                	jmp    f0105881 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
f010586a:	8b 45 14             	mov    0x14(%ebp),%eax
f010586d:	8b 50 04             	mov    0x4(%eax),%edx
f0105870:	8b 00                	mov    (%eax),%eax
f0105872:	89 45 d8             	mov    %eax,-0x28(%ebp)
f0105875:	89 55 dc             	mov    %edx,-0x24(%ebp)
f0105878:	8b 45 14             	mov    0x14(%ebp),%eax
f010587b:	8d 40 08             	lea    0x8(%eax),%eax
f010587e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
f0105881:	8b 55 d8             	mov    -0x28(%ebp),%edx
f0105884:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
f0105887:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
f010588b:	78 25                	js     f01058b2 <vprintfmt+0x2c0>
			base = 10;
f010588d:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105892:	e9 03 01 00 00       	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, long);
f0105897:	8b 45 14             	mov    0x14(%ebp),%eax
f010589a:	8b 00                	mov    (%eax),%eax
f010589c:	89 45 d8             	mov    %eax,-0x28(%ebp)
f010589f:	89 c1                	mov    %eax,%ecx
f01058a1:	c1 f9 1f             	sar    $0x1f,%ecx
f01058a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
f01058a7:	8b 45 14             	mov    0x14(%ebp),%eax
f01058aa:	8d 40 04             	lea    0x4(%eax),%eax
f01058ad:	89 45 14             	mov    %eax,0x14(%ebp)
f01058b0:	eb cf                	jmp    f0105881 <vprintfmt+0x28f>
				putch('-', putdat);
f01058b2:	83 ec 08             	sub    $0x8,%esp
f01058b5:	53                   	push   %ebx
f01058b6:	6a 2d                	push   $0x2d
f01058b8:	ff d6                	call   *%esi
				num = -(long long) num;
f01058ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
f01058bd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
f01058c0:	f7 da                	neg    %edx
f01058c2:	83 d1 00             	adc    $0x0,%ecx
f01058c5:	f7 d9                	neg    %ecx
f01058c7:	83 c4 10             	add    $0x10,%esp
			base = 10;
f01058ca:	b8 0a 00 00 00       	mov    $0xa,%eax
f01058cf:	e9 c6 00 00 00       	jmp    f010599a <vprintfmt+0x3a8>
	if (lflag >= 2)
f01058d4:	83 f9 01             	cmp    $0x1,%ecx
f01058d7:	7f 1e                	jg     f01058f7 <vprintfmt+0x305>
	else if (lflag)
f01058d9:	85 c9                	test   %ecx,%ecx
f01058db:	75 32                	jne    f010590f <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
f01058dd:	8b 45 14             	mov    0x14(%ebp),%eax
f01058e0:	8b 10                	mov    (%eax),%edx
f01058e2:	b9 00 00 00 00       	mov    $0x0,%ecx
f01058e7:	8d 40 04             	lea    0x4(%eax),%eax
f01058ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f01058ed:	b8 0a 00 00 00       	mov    $0xa,%eax
f01058f2:	e9 a3 00 00 00       	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
f01058f7:	8b 45 14             	mov    0x14(%ebp),%eax
f01058fa:	8b 10                	mov    (%eax),%edx
f01058fc:	8b 48 04             	mov    0x4(%eax),%ecx
f01058ff:	8d 40 08             	lea    0x8(%eax),%eax
f0105902:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f0105905:	b8 0a 00 00 00       	mov    $0xa,%eax
f010590a:	e9 8b 00 00 00       	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
f010590f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105912:	8b 10                	mov    (%eax),%edx
f0105914:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105919:	8d 40 04             	lea    0x4(%eax),%eax
f010591c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
f010591f:	b8 0a 00 00 00       	mov    $0xa,%eax
f0105924:	eb 74                	jmp    f010599a <vprintfmt+0x3a8>
	if (lflag >= 2)
f0105926:	83 f9 01             	cmp    $0x1,%ecx
f0105929:	7f 1b                	jg     f0105946 <vprintfmt+0x354>
	else if (lflag)
f010592b:	85 c9                	test   %ecx,%ecx
f010592d:	75 2c                	jne    f010595b <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
f010592f:	8b 45 14             	mov    0x14(%ebp),%eax
f0105932:	8b 10                	mov    (%eax),%edx
f0105934:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105939:	8d 40 04             	lea    0x4(%eax),%eax
f010593c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010593f:	b8 08 00 00 00       	mov    $0x8,%eax
f0105944:	eb 54                	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
f0105946:	8b 45 14             	mov    0x14(%ebp),%eax
f0105949:	8b 10                	mov    (%eax),%edx
f010594b:	8b 48 04             	mov    0x4(%eax),%ecx
f010594e:	8d 40 08             	lea    0x8(%eax),%eax
f0105951:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f0105954:	b8 08 00 00 00       	mov    $0x8,%eax
f0105959:	eb 3f                	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
f010595b:	8b 45 14             	mov    0x14(%ebp),%eax
f010595e:	8b 10                	mov    (%eax),%edx
f0105960:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105965:	8d 40 04             	lea    0x4(%eax),%eax
f0105968:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
f010596b:	b8 08 00 00 00       	mov    $0x8,%eax
f0105970:	eb 28                	jmp    f010599a <vprintfmt+0x3a8>
			putch('0', putdat);
f0105972:	83 ec 08             	sub    $0x8,%esp
f0105975:	53                   	push   %ebx
f0105976:	6a 30                	push   $0x30
f0105978:	ff d6                	call   *%esi
			putch('x', putdat);
f010597a:	83 c4 08             	add    $0x8,%esp
f010597d:	53                   	push   %ebx
f010597e:	6a 78                	push   $0x78
f0105980:	ff d6                	call   *%esi
			num = (unsigned long long)
f0105982:	8b 45 14             	mov    0x14(%ebp),%eax
f0105985:	8b 10                	mov    (%eax),%edx
f0105987:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
f010598c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
f010598f:	8d 40 04             	lea    0x4(%eax),%eax
f0105992:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105995:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
f010599a:	83 ec 0c             	sub    $0xc,%esp
f010599d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
f01059a1:	57                   	push   %edi
f01059a2:	ff 75 e0             	pushl  -0x20(%ebp)
f01059a5:	50                   	push   %eax
f01059a6:	51                   	push   %ecx
f01059a7:	52                   	push   %edx
f01059a8:	89 da                	mov    %ebx,%edx
f01059aa:	89 f0                	mov    %esi,%eax
f01059ac:	e8 5b fb ff ff       	call   f010550c <printnum>
			break;
f01059b1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
f01059b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
f01059b7:	47                   	inc    %edi
f01059b8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
f01059bc:	83 f8 25             	cmp    $0x25,%eax
f01059bf:	0f 84 44 fc ff ff    	je     f0105609 <vprintfmt+0x17>
			if (ch == '\0')
f01059c5:	85 c0                	test   %eax,%eax
f01059c7:	0f 84 89 00 00 00    	je     f0105a56 <vprintfmt+0x464>
			putch(ch, putdat);
f01059cd:	83 ec 08             	sub    $0x8,%esp
f01059d0:	53                   	push   %ebx
f01059d1:	50                   	push   %eax
f01059d2:	ff d6                	call   *%esi
f01059d4:	83 c4 10             	add    $0x10,%esp
f01059d7:	eb de                	jmp    f01059b7 <vprintfmt+0x3c5>
	if (lflag >= 2)
f01059d9:	83 f9 01             	cmp    $0x1,%ecx
f01059dc:	7f 1b                	jg     f01059f9 <vprintfmt+0x407>
	else if (lflag)
f01059de:	85 c9                	test   %ecx,%ecx
f01059e0:	75 2c                	jne    f0105a0e <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
f01059e2:	8b 45 14             	mov    0x14(%ebp),%eax
f01059e5:	8b 10                	mov    (%eax),%edx
f01059e7:	b9 00 00 00 00       	mov    $0x0,%ecx
f01059ec:	8d 40 04             	lea    0x4(%eax),%eax
f01059ef:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f01059f2:	b8 10 00 00 00       	mov    $0x10,%eax
f01059f7:	eb a1                	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
f01059f9:	8b 45 14             	mov    0x14(%ebp),%eax
f01059fc:	8b 10                	mov    (%eax),%edx
f01059fe:	8b 48 04             	mov    0x4(%eax),%ecx
f0105a01:	8d 40 08             	lea    0x8(%eax),%eax
f0105a04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105a07:	b8 10 00 00 00       	mov    $0x10,%eax
f0105a0c:	eb 8c                	jmp    f010599a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
f0105a0e:	8b 45 14             	mov    0x14(%ebp),%eax
f0105a11:	8b 10                	mov    (%eax),%edx
f0105a13:	b9 00 00 00 00       	mov    $0x0,%ecx
f0105a18:	8d 40 04             	lea    0x4(%eax),%eax
f0105a1b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
f0105a1e:	b8 10 00 00 00       	mov    $0x10,%eax
f0105a23:	e9 72 ff ff ff       	jmp    f010599a <vprintfmt+0x3a8>
			putch(ch, putdat);
f0105a28:	83 ec 08             	sub    $0x8,%esp
f0105a2b:	53                   	push   %ebx
f0105a2c:	6a 25                	push   $0x25
f0105a2e:	ff d6                	call   *%esi
			break;
f0105a30:	83 c4 10             	add    $0x10,%esp
f0105a33:	e9 7c ff ff ff       	jmp    f01059b4 <vprintfmt+0x3c2>
			putch('%', putdat);
f0105a38:	83 ec 08             	sub    $0x8,%esp
f0105a3b:	53                   	push   %ebx
f0105a3c:	6a 25                	push   $0x25
f0105a3e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
f0105a40:	83 c4 10             	add    $0x10,%esp
f0105a43:	89 f8                	mov    %edi,%eax
f0105a45:	eb 01                	jmp    f0105a48 <vprintfmt+0x456>
f0105a47:	48                   	dec    %eax
f0105a48:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
f0105a4c:	75 f9                	jne    f0105a47 <vprintfmt+0x455>
f0105a4e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f0105a51:	e9 5e ff ff ff       	jmp    f01059b4 <vprintfmt+0x3c2>
}
f0105a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105a59:	5b                   	pop    %ebx
f0105a5a:	5e                   	pop    %esi
f0105a5b:	5f                   	pop    %edi
f0105a5c:	5d                   	pop    %ebp
f0105a5d:	c3                   	ret    

f0105a5e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0105a5e:	55                   	push   %ebp
f0105a5f:	89 e5                	mov    %esp,%ebp
f0105a61:	83 ec 18             	sub    $0x18,%esp
f0105a64:	8b 45 08             	mov    0x8(%ebp),%eax
f0105a67:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0105a6a:	89 45 ec             	mov    %eax,-0x14(%ebp)
f0105a6d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0105a71:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f0105a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
f0105a7b:	85 c0                	test   %eax,%eax
f0105a7d:	74 26                	je     f0105aa5 <vsnprintf+0x47>
f0105a7f:	85 d2                	test   %edx,%edx
f0105a81:	7e 29                	jle    f0105aac <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0105a83:	ff 75 14             	pushl  0x14(%ebp)
f0105a86:	ff 75 10             	pushl  0x10(%ebp)
f0105a89:	8d 45 ec             	lea    -0x14(%ebp),%eax
f0105a8c:	50                   	push   %eax
f0105a8d:	68 b9 55 10 f0       	push   $0xf01055b9
f0105a92:	e8 5b fb ff ff       	call   f01055f2 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0105a97:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0105a9a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0105a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0105aa0:	83 c4 10             	add    $0x10,%esp
}
f0105aa3:	c9                   	leave  
f0105aa4:	c3                   	ret    
		return -E_INVAL;
f0105aa5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105aaa:	eb f7                	jmp    f0105aa3 <vsnprintf+0x45>
f0105aac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0105ab1:	eb f0                	jmp    f0105aa3 <vsnprintf+0x45>

f0105ab3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0105ab3:	55                   	push   %ebp
f0105ab4:	89 e5                	mov    %esp,%ebp
f0105ab6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0105ab9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0105abc:	50                   	push   %eax
f0105abd:	ff 75 10             	pushl  0x10(%ebp)
f0105ac0:	ff 75 0c             	pushl  0xc(%ebp)
f0105ac3:	ff 75 08             	pushl  0x8(%ebp)
f0105ac6:	e8 93 ff ff ff       	call   f0105a5e <vsnprintf>
	va_end(ap);

	return rc;
}
f0105acb:	c9                   	leave  
f0105acc:	c3                   	ret    

f0105acd <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
f0105acd:	55                   	push   %ebp
f0105ace:	89 e5                	mov    %esp,%ebp
f0105ad0:	57                   	push   %edi
f0105ad1:	56                   	push   %esi
f0105ad2:	53                   	push   %ebx
f0105ad3:	83 ec 0c             	sub    $0xc,%esp
f0105ad6:	8b 45 08             	mov    0x8(%ebp),%eax
	int i, c, echoing;

#if JOS_KERNEL
	if (prompt != NULL)
f0105ad9:	85 c0                	test   %eax,%eax
f0105adb:	74 11                	je     f0105aee <readline+0x21>
		cprintf("%s", prompt);
f0105add:	83 ec 08             	sub    $0x8,%esp
f0105ae0:	50                   	push   %eax
f0105ae1:	68 43 78 10 f0       	push   $0xf0107843
f0105ae6:	e8 b8 e1 ff ff       	call   f0103ca3 <cprintf>
f0105aeb:	83 c4 10             	add    $0x10,%esp
	if (prompt != NULL)
		fprintf(1, "%s", prompt);
#endif

	i = 0;
	echoing = iscons(0);
f0105aee:	83 ec 0c             	sub    $0xc,%esp
f0105af1:	6a 00                	push   $0x0
f0105af3:	e8 35 ad ff ff       	call   f010082d <iscons>
f0105af8:	89 c7                	mov    %eax,%edi
f0105afa:	83 c4 10             	add    $0x10,%esp
	i = 0;
f0105afd:	be 00 00 00 00       	mov    $0x0,%esi
f0105b02:	eb 7b                	jmp    f0105b7f <readline+0xb2>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
f0105b04:	83 f8 f8             	cmp    $0xfffffff8,%eax
f0105b07:	74 66                	je     f0105b6f <readline+0xa2>
				cprintf("read error: %e\n", c);
f0105b09:	83 ec 08             	sub    $0x8,%esp
f0105b0c:	50                   	push   %eax
f0105b0d:	68 ff 98 10 f0       	push   $0xf01098ff
f0105b12:	e8 8c e1 ff ff       	call   f0103ca3 <cprintf>
f0105b17:	83 c4 10             	add    $0x10,%esp
			return NULL;
f0105b1a:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b1f:	eb 37                	jmp    f0105b58 <readline+0x8b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
			if (echoing)
				cputchar('\b');
f0105b21:	83 ec 0c             	sub    $0xc,%esp
f0105b24:	6a 08                	push   $0x8
f0105b26:	e8 e1 ac ff ff       	call   f010080c <cputchar>
f0105b2b:	83 c4 10             	add    $0x10,%esp
f0105b2e:	eb 4e                	jmp    f0105b7e <readline+0xb1>
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
f0105b30:	83 ec 0c             	sub    $0xc,%esp
f0105b33:	53                   	push   %ebx
f0105b34:	e8 d3 ac ff ff       	call   f010080c <cputchar>
f0105b39:	83 c4 10             	add    $0x10,%esp
f0105b3c:	eb 6b                	jmp    f0105ba9 <readline+0xdc>
			buf[i++] = c;
		} else if (c == '\n' || c == '\r') {
f0105b3e:	83 fb 0a             	cmp    $0xa,%ebx
f0105b41:	74 05                	je     f0105b48 <readline+0x7b>
f0105b43:	83 fb 0d             	cmp    $0xd,%ebx
f0105b46:	75 37                	jne    f0105b7f <readline+0xb2>
			if (echoing)
f0105b48:	85 ff                	test   %edi,%edi
f0105b4a:	75 14                	jne    f0105b60 <readline+0x93>
				cputchar('\n');
			buf[i] = 0;
f0105b4c:	c6 86 80 6a 2c f0 00 	movb   $0x0,-0xfd39580(%esi)
			return buf;
f0105b53:	b8 80 6a 2c f0       	mov    $0xf02c6a80,%eax
		}
	}
}
f0105b58:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105b5b:	5b                   	pop    %ebx
f0105b5c:	5e                   	pop    %esi
f0105b5d:	5f                   	pop    %edi
f0105b5e:	5d                   	pop    %ebp
f0105b5f:	c3                   	ret    
				cputchar('\n');
f0105b60:	83 ec 0c             	sub    $0xc,%esp
f0105b63:	6a 0a                	push   $0xa
f0105b65:	e8 a2 ac ff ff       	call   f010080c <cputchar>
f0105b6a:	83 c4 10             	add    $0x10,%esp
f0105b6d:	eb dd                	jmp    f0105b4c <readline+0x7f>
			return NULL;
f0105b6f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105b74:	eb e2                	jmp    f0105b58 <readline+0x8b>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105b76:	85 f6                	test   %esi,%esi
f0105b78:	7e 40                	jle    f0105bba <readline+0xed>
			if (echoing)
f0105b7a:	85 ff                	test   %edi,%edi
f0105b7c:	75 a3                	jne    f0105b21 <readline+0x54>
			i--;
f0105b7e:	4e                   	dec    %esi
		c = getchar();
f0105b7f:	e8 98 ac ff ff       	call   f010081c <getchar>
f0105b84:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
f0105b86:	85 c0                	test   %eax,%eax
f0105b88:	0f 88 76 ff ff ff    	js     f0105b04 <readline+0x37>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105b8e:	83 f8 08             	cmp    $0x8,%eax
f0105b91:	74 21                	je     f0105bb4 <readline+0xe7>
f0105b93:	83 f8 7f             	cmp    $0x7f,%eax
f0105b96:	74 de                	je     f0105b76 <readline+0xa9>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105b98:	83 f8 1f             	cmp    $0x1f,%eax
f0105b9b:	7e a1                	jle    f0105b3e <readline+0x71>
f0105b9d:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105ba3:	7f 99                	jg     f0105b3e <readline+0x71>
			if (echoing)
f0105ba5:	85 ff                	test   %edi,%edi
f0105ba7:	75 87                	jne    f0105b30 <readline+0x63>
			buf[i++] = c;
f0105ba9:	88 9e 80 6a 2c f0    	mov    %bl,-0xfd39580(%esi)
f0105baf:	8d 76 01             	lea    0x1(%esi),%esi
f0105bb2:	eb cb                	jmp    f0105b7f <readline+0xb2>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
f0105bb4:	85 f6                	test   %esi,%esi
f0105bb6:	7f c2                	jg     f0105b7a <readline+0xad>
f0105bb8:	eb c5                	jmp    f0105b7f <readline+0xb2>
		} else if (c >= ' ' && i < BUFLEN-1) {
f0105bba:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
f0105bc0:	7e e3                	jle    f0105ba5 <readline+0xd8>
f0105bc2:	eb bb                	jmp    f0105b7f <readline+0xb2>

f0105bc4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0105bc4:	55                   	push   %ebp
f0105bc5:	89 e5                	mov    %esp,%ebp
f0105bc7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0105bca:	b8 00 00 00 00       	mov    $0x0,%eax
f0105bcf:	eb 01                	jmp    f0105bd2 <strlen+0xe>
		n++;
f0105bd1:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
f0105bd2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0105bd6:	75 f9                	jne    f0105bd1 <strlen+0xd>
	return n;
}
f0105bd8:	5d                   	pop    %ebp
f0105bd9:	c3                   	ret    

f0105bda <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0105bda:	55                   	push   %ebp
f0105bdb:	89 e5                	mov    %esp,%ebp
f0105bdd:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105be0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105be3:	b8 00 00 00 00       	mov    $0x0,%eax
f0105be8:	eb 01                	jmp    f0105beb <strnlen+0x11>
		n++;
f0105bea:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0105beb:	39 d0                	cmp    %edx,%eax
f0105bed:	74 06                	je     f0105bf5 <strnlen+0x1b>
f0105bef:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f0105bf3:	75 f5                	jne    f0105bea <strnlen+0x10>
	return n;
}
f0105bf5:	5d                   	pop    %ebp
f0105bf6:	c3                   	ret    

f0105bf7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f0105bf7:	55                   	push   %ebp
f0105bf8:	89 e5                	mov    %esp,%ebp
f0105bfa:	53                   	push   %ebx
f0105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0105c01:	89 c2                	mov    %eax,%edx
f0105c03:	42                   	inc    %edx
f0105c04:	41                   	inc    %ecx
f0105c05:	8a 59 ff             	mov    -0x1(%ecx),%bl
f0105c08:	88 5a ff             	mov    %bl,-0x1(%edx)
f0105c0b:	84 db                	test   %bl,%bl
f0105c0d:	75 f4                	jne    f0105c03 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
f0105c0f:	5b                   	pop    %ebx
f0105c10:	5d                   	pop    %ebp
f0105c11:	c3                   	ret    

f0105c12 <strcat>:

char *
strcat(char *dst, const char *src)
{
f0105c12:	55                   	push   %ebp
f0105c13:	89 e5                	mov    %esp,%ebp
f0105c15:	53                   	push   %ebx
f0105c16:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
f0105c19:	53                   	push   %ebx
f0105c1a:	e8 a5 ff ff ff       	call   f0105bc4 <strlen>
f0105c1f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
f0105c22:	ff 75 0c             	pushl  0xc(%ebp)
f0105c25:	01 d8                	add    %ebx,%eax
f0105c27:	50                   	push   %eax
f0105c28:	e8 ca ff ff ff       	call   f0105bf7 <strcpy>
	return dst;
}
f0105c2d:	89 d8                	mov    %ebx,%eax
f0105c2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0105c32:	c9                   	leave  
f0105c33:	c3                   	ret    

f0105c34 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0105c34:	55                   	push   %ebp
f0105c35:	89 e5                	mov    %esp,%ebp
f0105c37:	56                   	push   %esi
f0105c38:	53                   	push   %ebx
f0105c39:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0105c3f:	89 f3                	mov    %esi,%ebx
f0105c41:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0105c44:	89 f2                	mov    %esi,%edx
f0105c46:	eb 0c                	jmp    f0105c54 <strncpy+0x20>
		*dst++ = *src;
f0105c48:	42                   	inc    %edx
f0105c49:	8a 01                	mov    (%ecx),%al
f0105c4b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f0105c4e:	80 39 01             	cmpb   $0x1,(%ecx)
f0105c51:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
f0105c54:	39 da                	cmp    %ebx,%edx
f0105c56:	75 f0                	jne    f0105c48 <strncpy+0x14>
	}
	return ret;
}
f0105c58:	89 f0                	mov    %esi,%eax
f0105c5a:	5b                   	pop    %ebx
f0105c5b:	5e                   	pop    %esi
f0105c5c:	5d                   	pop    %ebp
f0105c5d:	c3                   	ret    

f0105c5e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f0105c5e:	55                   	push   %ebp
f0105c5f:	89 e5                	mov    %esp,%ebp
f0105c61:	56                   	push   %esi
f0105c62:	53                   	push   %ebx
f0105c63:	8b 75 08             	mov    0x8(%ebp),%esi
f0105c66:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105c69:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f0105c6c:	85 c0                	test   %eax,%eax
f0105c6e:	74 20                	je     f0105c90 <strlcpy+0x32>
f0105c70:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
f0105c74:	89 f0                	mov    %esi,%eax
f0105c76:	eb 05                	jmp    f0105c7d <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f0105c78:	40                   	inc    %eax
f0105c79:	42                   	inc    %edx
f0105c7a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
f0105c7d:	39 d8                	cmp    %ebx,%eax
f0105c7f:	74 06                	je     f0105c87 <strlcpy+0x29>
f0105c81:	8a 0a                	mov    (%edx),%cl
f0105c83:	84 c9                	test   %cl,%cl
f0105c85:	75 f1                	jne    f0105c78 <strlcpy+0x1a>
		*dst = '\0';
f0105c87:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f0105c8a:	29 f0                	sub    %esi,%eax
}
f0105c8c:	5b                   	pop    %ebx
f0105c8d:	5e                   	pop    %esi
f0105c8e:	5d                   	pop    %ebp
f0105c8f:	c3                   	ret    
f0105c90:	89 f0                	mov    %esi,%eax
f0105c92:	eb f6                	jmp    f0105c8a <strlcpy+0x2c>

f0105c94 <strcmp>:

int
strcmp(const char *p, const char *q)
{
f0105c94:	55                   	push   %ebp
f0105c95:	89 e5                	mov    %esp,%ebp
f0105c97:	8b 4d 08             	mov    0x8(%ebp),%ecx
f0105c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
f0105c9d:	eb 02                	jmp    f0105ca1 <strcmp+0xd>
		p++, q++;
f0105c9f:	41                   	inc    %ecx
f0105ca0:	42                   	inc    %edx
	while (*p && *p == *q)
f0105ca1:	8a 01                	mov    (%ecx),%al
f0105ca3:	84 c0                	test   %al,%al
f0105ca5:	74 04                	je     f0105cab <strcmp+0x17>
f0105ca7:	3a 02                	cmp    (%edx),%al
f0105ca9:	74 f4                	je     f0105c9f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
f0105cab:	0f b6 c0             	movzbl %al,%eax
f0105cae:	0f b6 12             	movzbl (%edx),%edx
f0105cb1:	29 d0                	sub    %edx,%eax
}
f0105cb3:	5d                   	pop    %ebp
f0105cb4:	c3                   	ret    

f0105cb5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0105cb5:	55                   	push   %ebp
f0105cb6:	89 e5                	mov    %esp,%ebp
f0105cb8:	53                   	push   %ebx
f0105cb9:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cbc:	8b 55 0c             	mov    0xc(%ebp),%edx
f0105cbf:	89 c3                	mov    %eax,%ebx
f0105cc1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
f0105cc4:	eb 02                	jmp    f0105cc8 <strncmp+0x13>
		n--, p++, q++;
f0105cc6:	40                   	inc    %eax
f0105cc7:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
f0105cc8:	39 d8                	cmp    %ebx,%eax
f0105cca:	74 15                	je     f0105ce1 <strncmp+0x2c>
f0105ccc:	8a 08                	mov    (%eax),%cl
f0105cce:	84 c9                	test   %cl,%cl
f0105cd0:	74 04                	je     f0105cd6 <strncmp+0x21>
f0105cd2:	3a 0a                	cmp    (%edx),%cl
f0105cd4:	74 f0                	je     f0105cc6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0105cd6:	0f b6 00             	movzbl (%eax),%eax
f0105cd9:	0f b6 12             	movzbl (%edx),%edx
f0105cdc:	29 d0                	sub    %edx,%eax
}
f0105cde:	5b                   	pop    %ebx
f0105cdf:	5d                   	pop    %ebp
f0105ce0:	c3                   	ret    
		return 0;
f0105ce1:	b8 00 00 00 00       	mov    $0x0,%eax
f0105ce6:	eb f6                	jmp    f0105cde <strncmp+0x29>

f0105ce8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0105ce8:	55                   	push   %ebp
f0105ce9:	89 e5                	mov    %esp,%ebp
f0105ceb:	8b 45 08             	mov    0x8(%ebp),%eax
f0105cee:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
f0105cf1:	8a 10                	mov    (%eax),%dl
f0105cf3:	84 d2                	test   %dl,%dl
f0105cf5:	74 07                	je     f0105cfe <strchr+0x16>
		if (*s == c)
f0105cf7:	38 ca                	cmp    %cl,%dl
f0105cf9:	74 08                	je     f0105d03 <strchr+0x1b>
	for (; *s; s++)
f0105cfb:	40                   	inc    %eax
f0105cfc:	eb f3                	jmp    f0105cf1 <strchr+0x9>
			return (char *) s;
	return 0;
f0105cfe:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105d03:	5d                   	pop    %ebp
f0105d04:	c3                   	ret    

f0105d05 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f0105d05:	55                   	push   %ebp
f0105d06:	89 e5                	mov    %esp,%ebp
f0105d08:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d0b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
f0105d0e:	8a 10                	mov    (%eax),%dl
f0105d10:	84 d2                	test   %dl,%dl
f0105d12:	74 07                	je     f0105d1b <strfind+0x16>
		if (*s == c)
f0105d14:	38 ca                	cmp    %cl,%dl
f0105d16:	74 03                	je     f0105d1b <strfind+0x16>
	for (; *s; s++)
f0105d18:	40                   	inc    %eax
f0105d19:	eb f3                	jmp    f0105d0e <strfind+0x9>
			break;
	return (char *) s;
}
f0105d1b:	5d                   	pop    %ebp
f0105d1c:	c3                   	ret    

f0105d1d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f0105d1d:	55                   	push   %ebp
f0105d1e:	89 e5                	mov    %esp,%ebp
f0105d20:	57                   	push   %edi
f0105d21:	56                   	push   %esi
f0105d22:	53                   	push   %ebx
f0105d23:	8b 7d 08             	mov    0x8(%ebp),%edi
f0105d26:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
f0105d29:	85 c9                	test   %ecx,%ecx
f0105d2b:	74 13                	je     f0105d40 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f0105d2d:	f7 c7 03 00 00 00    	test   $0x3,%edi
f0105d33:	75 05                	jne    f0105d3a <memset+0x1d>
f0105d35:	f6 c1 03             	test   $0x3,%cl
f0105d38:	74 0d                	je     f0105d47 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f0105d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
f0105d3d:	fc                   	cld    
f0105d3e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f0105d40:	89 f8                	mov    %edi,%eax
f0105d42:	5b                   	pop    %ebx
f0105d43:	5e                   	pop    %esi
f0105d44:	5f                   	pop    %edi
f0105d45:	5d                   	pop    %ebp
f0105d46:	c3                   	ret    
		c &= 0xFF;
f0105d47:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f0105d4b:	89 d3                	mov    %edx,%ebx
f0105d4d:	c1 e3 08             	shl    $0x8,%ebx
f0105d50:	89 d0                	mov    %edx,%eax
f0105d52:	c1 e0 18             	shl    $0x18,%eax
f0105d55:	89 d6                	mov    %edx,%esi
f0105d57:	c1 e6 10             	shl    $0x10,%esi
f0105d5a:	09 f0                	or     %esi,%eax
f0105d5c:	09 c2                	or     %eax,%edx
f0105d5e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
f0105d60:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
f0105d63:	89 d0                	mov    %edx,%eax
f0105d65:	fc                   	cld    
f0105d66:	f3 ab                	rep stos %eax,%es:(%edi)
f0105d68:	eb d6                	jmp    f0105d40 <memset+0x23>

f0105d6a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f0105d6a:	55                   	push   %ebp
f0105d6b:	89 e5                	mov    %esp,%ebp
f0105d6d:	57                   	push   %edi
f0105d6e:	56                   	push   %esi
f0105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
f0105d72:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105d75:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0105d78:	39 c6                	cmp    %eax,%esi
f0105d7a:	73 33                	jae    f0105daf <memmove+0x45>
f0105d7c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f0105d7f:	39 d0                	cmp    %edx,%eax
f0105d81:	73 2c                	jae    f0105daf <memmove+0x45>
		s += n;
		d += n;
f0105d83:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105d86:	89 d6                	mov    %edx,%esi
f0105d88:	09 fe                	or     %edi,%esi
f0105d8a:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0105d90:	75 13                	jne    f0105da5 <memmove+0x3b>
f0105d92:	f6 c1 03             	test   $0x3,%cl
f0105d95:	75 0e                	jne    f0105da5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0105d97:	83 ef 04             	sub    $0x4,%edi
f0105d9a:	8d 72 fc             	lea    -0x4(%edx),%esi
f0105d9d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
f0105da0:	fd                   	std    
f0105da1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105da3:	eb 07                	jmp    f0105dac <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0105da5:	4f                   	dec    %edi
f0105da6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
f0105da9:	fd                   	std    
f0105daa:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f0105dac:	fc                   	cld    
f0105dad:	eb 13                	jmp    f0105dc2 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0105daf:	89 f2                	mov    %esi,%edx
f0105db1:	09 c2                	or     %eax,%edx
f0105db3:	f6 c2 03             	test   $0x3,%dl
f0105db6:	75 05                	jne    f0105dbd <memmove+0x53>
f0105db8:	f6 c1 03             	test   $0x3,%cl
f0105dbb:	74 09                	je     f0105dc6 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0105dbd:	89 c7                	mov    %eax,%edi
f0105dbf:	fc                   	cld    
f0105dc0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f0105dc2:	5e                   	pop    %esi
f0105dc3:	5f                   	pop    %edi
f0105dc4:	5d                   	pop    %ebp
f0105dc5:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f0105dc6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
f0105dc9:	89 c7                	mov    %eax,%edi
f0105dcb:	fc                   	cld    
f0105dcc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0105dce:	eb f2                	jmp    f0105dc2 <memmove+0x58>

f0105dd0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f0105dd0:	55                   	push   %ebp
f0105dd1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
f0105dd3:	ff 75 10             	pushl  0x10(%ebp)
f0105dd6:	ff 75 0c             	pushl  0xc(%ebp)
f0105dd9:	ff 75 08             	pushl  0x8(%ebp)
f0105ddc:	e8 89 ff ff ff       	call   f0105d6a <memmove>
}
f0105de1:	c9                   	leave  
f0105de2:	c3                   	ret    

f0105de3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f0105de3:	55                   	push   %ebp
f0105de4:	89 e5                	mov    %esp,%ebp
f0105de6:	56                   	push   %esi
f0105de7:	53                   	push   %ebx
f0105de8:	8b 45 08             	mov    0x8(%ebp),%eax
f0105deb:	89 c6                	mov    %eax,%esi
f0105ded:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
f0105df0:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
f0105df3:	39 f0                	cmp    %esi,%eax
f0105df5:	74 16                	je     f0105e0d <memcmp+0x2a>
		if (*s1 != *s2)
f0105df7:	8a 08                	mov    (%eax),%cl
f0105df9:	8a 1a                	mov    (%edx),%bl
f0105dfb:	38 d9                	cmp    %bl,%cl
f0105dfd:	75 04                	jne    f0105e03 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
f0105dff:	40                   	inc    %eax
f0105e00:	42                   	inc    %edx
f0105e01:	eb f0                	jmp    f0105df3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
f0105e03:	0f b6 c1             	movzbl %cl,%eax
f0105e06:	0f b6 db             	movzbl %bl,%ebx
f0105e09:	29 d8                	sub    %ebx,%eax
f0105e0b:	eb 05                	jmp    f0105e12 <memcmp+0x2f>
	}

	return 0;
f0105e0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0105e12:	5b                   	pop    %ebx
f0105e13:	5e                   	pop    %esi
f0105e14:	5d                   	pop    %ebp
f0105e15:	c3                   	ret    

f0105e16 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0105e16:	55                   	push   %ebp
f0105e17:	89 e5                	mov    %esp,%ebp
f0105e19:	8b 45 08             	mov    0x8(%ebp),%eax
f0105e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
f0105e1f:	89 c2                	mov    %eax,%edx
f0105e21:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
f0105e24:	39 d0                	cmp    %edx,%eax
f0105e26:	73 07                	jae    f0105e2f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
f0105e28:	38 08                	cmp    %cl,(%eax)
f0105e2a:	74 03                	je     f0105e2f <memfind+0x19>
	for (; s < ends; s++)
f0105e2c:	40                   	inc    %eax
f0105e2d:	eb f5                	jmp    f0105e24 <memfind+0xe>
			break;
	return (void *) s;
}
f0105e2f:	5d                   	pop    %ebp
f0105e30:	c3                   	ret    

f0105e31 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0105e31:	55                   	push   %ebp
f0105e32:	89 e5                	mov    %esp,%ebp
f0105e34:	57                   	push   %edi
f0105e35:	56                   	push   %esi
f0105e36:	53                   	push   %ebx
f0105e37:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0105e3a:	eb 01                	jmp    f0105e3d <strtol+0xc>
		s++;
f0105e3c:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
f0105e3d:	8a 01                	mov    (%ecx),%al
f0105e3f:	3c 20                	cmp    $0x20,%al
f0105e41:	74 f9                	je     f0105e3c <strtol+0xb>
f0105e43:	3c 09                	cmp    $0x9,%al
f0105e45:	74 f5                	je     f0105e3c <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
f0105e47:	3c 2b                	cmp    $0x2b,%al
f0105e49:	74 2b                	je     f0105e76 <strtol+0x45>
		s++;
	else if (*s == '-')
f0105e4b:	3c 2d                	cmp    $0x2d,%al
f0105e4d:	74 2f                	je     f0105e7e <strtol+0x4d>
	int neg = 0;
f0105e4f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105e54:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
f0105e5b:	75 12                	jne    f0105e6f <strtol+0x3e>
f0105e5d:	80 39 30             	cmpb   $0x30,(%ecx)
f0105e60:	74 24                	je     f0105e86 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f0105e62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0105e66:	75 07                	jne    f0105e6f <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f0105e68:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
f0105e6f:	b8 00 00 00 00       	mov    $0x0,%eax
f0105e74:	eb 4e                	jmp    f0105ec4 <strtol+0x93>
		s++;
f0105e76:	41                   	inc    %ecx
	int neg = 0;
f0105e77:	bf 00 00 00 00       	mov    $0x0,%edi
f0105e7c:	eb d6                	jmp    f0105e54 <strtol+0x23>
		s++, neg = 1;
f0105e7e:	41                   	inc    %ecx
f0105e7f:	bf 01 00 00 00       	mov    $0x1,%edi
f0105e84:	eb ce                	jmp    f0105e54 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0105e86:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
f0105e8a:	74 10                	je     f0105e9c <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
f0105e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
f0105e90:	75 dd                	jne    f0105e6f <strtol+0x3e>
		s++, base = 8;
f0105e92:	41                   	inc    %ecx
f0105e93:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
f0105e9a:	eb d3                	jmp    f0105e6f <strtol+0x3e>
		s += 2, base = 16;
f0105e9c:	83 c1 02             	add    $0x2,%ecx
f0105e9f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
f0105ea6:	eb c7                	jmp    f0105e6f <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
f0105ea8:	8d 72 9f             	lea    -0x61(%edx),%esi
f0105eab:	89 f3                	mov    %esi,%ebx
f0105ead:	80 fb 19             	cmp    $0x19,%bl
f0105eb0:	77 24                	ja     f0105ed6 <strtol+0xa5>
			dig = *s - 'a' + 10;
f0105eb2:	0f be d2             	movsbl %dl,%edx
f0105eb5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0105eb8:	3b 55 10             	cmp    0x10(%ebp),%edx
f0105ebb:	7d 2b                	jge    f0105ee8 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
f0105ebd:	41                   	inc    %ecx
f0105ebe:	0f af 45 10          	imul   0x10(%ebp),%eax
f0105ec2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
f0105ec4:	8a 11                	mov    (%ecx),%dl
f0105ec6:	8d 5a d0             	lea    -0x30(%edx),%ebx
f0105ec9:	80 fb 09             	cmp    $0x9,%bl
f0105ecc:	77 da                	ja     f0105ea8 <strtol+0x77>
			dig = *s - '0';
f0105ece:	0f be d2             	movsbl %dl,%edx
f0105ed1:	83 ea 30             	sub    $0x30,%edx
f0105ed4:	eb e2                	jmp    f0105eb8 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
f0105ed6:	8d 72 bf             	lea    -0x41(%edx),%esi
f0105ed9:	89 f3                	mov    %esi,%ebx
f0105edb:	80 fb 19             	cmp    $0x19,%bl
f0105ede:	77 08                	ja     f0105ee8 <strtol+0xb7>
			dig = *s - 'A' + 10;
f0105ee0:	0f be d2             	movsbl %dl,%edx
f0105ee3:	83 ea 37             	sub    $0x37,%edx
f0105ee6:	eb d0                	jmp    f0105eb8 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
f0105ee8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
f0105eec:	74 05                	je     f0105ef3 <strtol+0xc2>
		*endptr = (char *) s;
f0105eee:	8b 75 0c             	mov    0xc(%ebp),%esi
f0105ef1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
f0105ef3:	85 ff                	test   %edi,%edi
f0105ef5:	74 02                	je     f0105ef9 <strtol+0xc8>
f0105ef7:	f7 d8                	neg    %eax
}
f0105ef9:	5b                   	pop    %ebx
f0105efa:	5e                   	pop    %esi
f0105efb:	5f                   	pop    %edi
f0105efc:	5d                   	pop    %ebp
f0105efd:	c3                   	ret    

f0105efe <atoi>:

int
atoi(const char *s)
{
f0105efe:	55                   	push   %ebp
f0105eff:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
f0105f01:	6a 0a                	push   $0xa
f0105f03:	6a 00                	push   $0x0
f0105f05:	ff 75 08             	pushl  0x8(%ebp)
f0105f08:	e8 24 ff ff ff       	call   f0105e31 <strtol>
}
f0105f0d:	c9                   	leave  
f0105f0e:	c3                   	ret    
f0105f0f:	90                   	nop

f0105f10 <mpentry_start>:
.set PROT_MODE_DSEG, 0x10			# kernel data segment selector

.code16
.globl mpentry_start
mpentry_start:
	cli
f0105f10:	fa                   	cli    

	xorw	%ax, %ax
f0105f11:	31 c0                	xor    %eax,%eax
	movw	%ax, %ds
f0105f13:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
f0105f15:	8e c0                	mov    %eax,%es
	movw	%ax, %ss
f0105f17:	8e d0                	mov    %eax,%ss

	lgdt	MPBOOTPHYS(gdtdesc)
f0105f19:	0f 01 16             	lgdtl  (%esi)
f0105f1c:	74 70                	je     f0105f8e <print_table_header+0x3>
	movl	%cr0, %eax
f0105f1e:	0f 20 c0             	mov    %cr0,%eax
	orl	$CR0_PE, %eax
f0105f21:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
f0105f25:	0f 22 c0             	mov    %eax,%cr0

	ljmpl	$(PROT_MODE_CSEG), $(MPBOOTPHYS(start32))
f0105f28:	66 ea 20 70 00 00    	ljmpw  $0x0,$0x7020
f0105f2e:	08 00                	or     %al,(%eax)

f0105f30 <start32>:

.code32
start32:
	movw	$(PROT_MODE_DSEG), %ax
f0105f30:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds
f0105f34:	8e d8                	mov    %eax,%ds
	movw	%ax, %es
f0105f36:	8e c0                	mov    %eax,%es
	movw	%ax, %ss
f0105f38:	8e d0                	mov    %eax,%ss
	movw	$0, %ax
f0105f3a:	66 b8 00 00          	mov    $0x0,%ax
	movw	%ax, %fs
f0105f3e:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs
f0105f40:	8e e8                	mov    %eax,%gs

	# Set up initial page table. We cannot use kern_pgdir yet because
	# we are still running at a low EIP.
	movl	$(RELOC(entry_pgdir)), %eax
f0105f42:	b8 00 80 12 00       	mov    $0x128000,%eax
	movl	%eax, %cr3
f0105f47:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f0105f4a:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0105f4d:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0105f52:	0f 22 c0             	mov    %eax,%cr0

	# Switch to the per-cpu stack allocated in boot_aps()
	movl	mpentry_kstack, %esp
f0105f55:	8b 25 a8 6f 2c f0    	mov    0xf02c6fa8,%esp
	movl	$0x0, %ebp			# nuke frame pointer
f0105f5b:	bd 00 00 00 00       	mov    $0x0,%ebp

	# Call mp_main().  (Exercise for the reader: why the indirect call?)
	movl	$mp_main, %eax
f0105f60:	b8 79 02 10 f0       	mov    $0xf0100279,%eax
	call	*%eax
f0105f65:	ff d0                	call   *%eax

f0105f67 <spin>:

	# If mp_main returns (it shouldn't), loop.
spin:
	jmp	spin
f0105f67:	eb fe                	jmp    f0105f67 <spin>
f0105f69:	8d 76 00             	lea    0x0(%esi),%esi

f0105f6c <gdt>:
	...
f0105f74:	ff                   	(bad)  
f0105f75:	ff 00                	incl   (%eax)
f0105f77:	00 00                	add    %al,(%eax)
f0105f79:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f0105f80:	00                   	.byte 0x0
f0105f81:	92                   	xchg   %eax,%edx
f0105f82:	cf                   	iret   
	...

f0105f84 <gdtdesc>:
f0105f84:	17                   	pop    %ss
f0105f85:	00 5c 70 00          	add    %bl,0x0(%eax,%esi,2)
	...

f0105f8a <mpentry_end>:
	.word	0x17				# sizeof(gdt) - 1
	.long	MPBOOTPHYS(gdt)			# address gdt

.globl mpentry_end
mpentry_end:
	nop
f0105f8a:	90                   	nop

f0105f8b <print_table_header>:
		rsdp->revision, rsdp->oem_id);
}

static void
print_table_header(struct acpi_table_header *hdr)
{
f0105f8b:	55                   	push   %ebp
f0105f8c:	89 e5                	mov    %esp,%ebp
f0105f8e:	57                   	push   %edi
f0105f8f:	56                   	push   %esi
f0105f90:	53                   	push   %ebx
f0105f91:	83 ec 1c             	sub    $0x1c,%esp
f0105f94:	89 c2                	mov    %eax,%edx
	cprintf("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
f0105f96:	8b 78 20             	mov    0x20(%eax),%edi
		hdr->signature, PADDR(hdr), hdr->length, hdr->revision,
		hdr->oem_id, hdr->oem_table_id, hdr->oem_revision,
		hdr->asl_compiler_id, hdr->asl_compiler_revision);
f0105f99:	8d 70 1c             	lea    0x1c(%eax),%esi
	cprintf("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
f0105f9c:	8b 58 18             	mov    0x18(%eax),%ebx
		hdr->oem_id, hdr->oem_table_id, hdr->oem_revision,
f0105f9f:	8d 48 10             	lea    0x10(%eax),%ecx
f0105fa2:	8d 40 0a             	lea    0xa(%eax),%eax
f0105fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	cprintf("ACPI: %.4s %08p %06x v%02d %.6s %.8s %02d %.4s %02d\n",
f0105fa8:	0f b6 42 08          	movzbl 0x8(%edx),%eax
f0105fac:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0105faf:	8b 42 04             	mov    0x4(%edx),%eax
	if ((uint32_t)kva < KERNBASE)
f0105fb2:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f0105fb8:	76 2b                	jbe    f0105fe5 <print_table_header+0x5a>
f0105fba:	83 ec 08             	sub    $0x8,%esp
f0105fbd:	57                   	push   %edi
f0105fbe:	56                   	push   %esi
f0105fbf:	53                   	push   %ebx
f0105fc0:	51                   	push   %ecx
f0105fc1:	ff 75 e4             	pushl  -0x1c(%ebp)
f0105fc4:	ff 75 e0             	pushl  -0x20(%ebp)
f0105fc7:	50                   	push   %eax
	return (physaddr_t)kva - KERNBASE;
f0105fc8:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
f0105fce:	50                   	push   %eax
f0105fcf:	52                   	push   %edx
f0105fd0:	68 10 99 10 f0       	push   $0xf0109910
f0105fd5:	e8 c9 dc ff ff       	call   f0103ca3 <cprintf>
}
f0105fda:	83 c4 30             	add    $0x30,%esp
f0105fdd:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0105fe0:	5b                   	pop    %ebx
f0105fe1:	5e                   	pop    %esi
f0105fe2:	5f                   	pop    %edi
f0105fe3:	5d                   	pop    %ebp
f0105fe4:	c3                   	ret    
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0105fe5:	52                   	push   %edx
f0105fe6:	68 ec 77 10 f0       	push   $0xf01077ec
f0105feb:	6a 1e                	push   $0x1e
f0105fed:	68 69 99 10 f0       	push   $0xf0109969
f0105ff2:	e8 4c a0 ff ff       	call   f0100043 <_panic>

f0105ff7 <rsdp_search1>:
}

// Look for the RSDP in the len bytes at physical address addr.
static struct acpi_table_rsdp *
rsdp_search1(physaddr_t a, int len)
{
f0105ff7:	55                   	push   %ebp
f0105ff8:	89 e5                	mov    %esp,%ebp
f0105ffa:	57                   	push   %edi
f0105ffb:	56                   	push   %esi
f0105ffc:	53                   	push   %ebx
f0105ffd:	83 ec 1c             	sub    $0x1c,%esp
	if (PGNUM(pa) >= npages)
f0106000:	8b 0d c8 74 2c f0    	mov    0xf02c74c8,%ecx
f0106006:	89 c3                	mov    %eax,%ebx
f0106008:	c1 eb 0c             	shr    $0xc,%ebx
f010600b:	39 cb                	cmp    %ecx,%ebx
f010600d:	73 1c                	jae    f010602b <rsdp_search1+0x34>
	return (void *)(pa + KERNBASE);
f010600f:	8d 98 00 00 00 f0    	lea    -0x10000000(%eax),%ebx
	void *p = KADDR(a), *e = KADDR(a + len);
f0106015:	01 c2                	add    %eax,%edx
	if (PGNUM(pa) >= npages)
f0106017:	89 d0                	mov    %edx,%eax
f0106019:	c1 e8 0c             	shr    $0xc,%eax
f010601c:	39 c8                	cmp    %ecx,%eax
f010601e:	73 1d                	jae    f010603d <rsdp_search1+0x46>
	return (void *)(pa + KERNBASE);
f0106020:	8d 82 00 00 00 f0    	lea    -0x10000000(%edx),%eax
f0106026:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	// The signature is on a 16-byte boundary.
	for (; p < e; p += 16) {
f0106029:	eb 36                	jmp    f0106061 <rsdp_search1+0x6a>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010602b:	50                   	push   %eax
f010602c:	68 c8 77 10 f0       	push   $0xf01077c8
f0106031:	6a 32                	push   $0x32
f0106033:	68 69 99 10 f0       	push   $0xf0109969
f0106038:	e8 06 a0 ff ff       	call   f0100043 <_panic>
f010603d:	52                   	push   %edx
f010603e:	68 c8 77 10 f0       	push   $0xf01077c8
f0106043:	6a 32                	push   $0x32
f0106045:	68 69 99 10 f0       	push   $0xf0109969
f010604a:	e8 f4 9f ff ff       	call   f0100043 <_panic>
		sum += ((uint8_t *)addr)[i];
f010604f:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
f0106053:	01 ca                	add    %ecx,%edx
	for (i = 0; i < len; i++)
f0106055:	40                   	inc    %eax
f0106056:	39 c6                	cmp    %eax,%esi
f0106058:	7f f5                	jg     f010604f <rsdp_search1+0x58>

		if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
		    sum(rsdp, 20))
			continue;
		// ACPI 2.0+
		if (rsdp->revision && sum(rsdp, rsdp->length))
f010605a:	84 d2                	test   %dl,%dl
f010605c:	74 4c                	je     f01060aa <rsdp_search1+0xb3>
	for (; p < e; p += 16) {
f010605e:	83 c3 10             	add    $0x10,%ebx
f0106061:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
f0106064:	73 39                	jae    f010609f <rsdp_search1+0xa8>
		if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
f0106066:	83 ec 04             	sub    $0x4,%esp
f0106069:	6a 08                	push   $0x8
f010606b:	68 75 99 10 f0       	push   $0xf0109975
f0106070:	53                   	push   %ebx
f0106071:	e8 6d fd ff ff       	call   f0105de3 <memcmp>
f0106076:	83 c4 10             	add    $0x10,%esp
f0106079:	85 c0                	test   %eax,%eax
f010607b:	75 e1                	jne    f010605e <rsdp_search1+0x67>
f010607d:	89 da                	mov    %ebx,%edx
f010607f:	8d 7b 14             	lea    0x14(%ebx),%edi
f0106082:	89 c1                	mov    %eax,%ecx
		sum += ((uint8_t *)addr)[i];
f0106084:	0f b6 32             	movzbl (%edx),%esi
f0106087:	01 f1                	add    %esi,%ecx
f0106089:	42                   	inc    %edx
	for (i = 0; i < len; i++)
f010608a:	39 fa                	cmp    %edi,%edx
f010608c:	75 f6                	jne    f0106084 <rsdp_search1+0x8d>
		if (memcmp(rsdp->signature, ACPI_SIG_RSDP, 8) ||
f010608e:	84 c9                	test   %cl,%cl
f0106090:	75 cc                	jne    f010605e <rsdp_search1+0x67>
		if (rsdp->revision && sum(rsdp, rsdp->length))
f0106092:	80 7b 0f 00          	cmpb   $0x0,0xf(%ebx)
f0106096:	74 0e                	je     f01060a6 <rsdp_search1+0xaf>
f0106098:	8b 73 14             	mov    0x14(%ebx),%esi
	sum = 0;
f010609b:	89 c2                	mov    %eax,%edx
f010609d:	eb b7                	jmp    f0106056 <rsdp_search1+0x5f>
			continue;
		return rsdp;
	}
	return NULL;
f010609f:	b8 00 00 00 00       	mov    $0x0,%eax
f01060a4:	eb 06                	jmp    f01060ac <rsdp_search1+0xb5>
f01060a6:	89 d8                	mov    %ebx,%eax
f01060a8:	eb 02                	jmp    f01060ac <rsdp_search1+0xb5>
f01060aa:	89 d8                	mov    %ebx,%eax
}
f01060ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
f01060af:	5b                   	pop    %ebx
f01060b0:	5e                   	pop    %esi
f01060b1:	5f                   	pop    %edi
f01060b2:	5d                   	pop    %ebp
f01060b3:	c3                   	ret    

f01060b4 <acpi_init>:
	return rsdp_search1(0xE0000, 0x20000);
}

void
acpi_init(void)
{
f01060b4:	55                   	push   %ebp
f01060b5:	89 e5                	mov    %esp,%ebp
f01060b7:	57                   	push   %edi
f01060b8:	56                   	push   %esi
f01060b9:	53                   	push   %ebx
f01060ba:	83 ec 2c             	sub    $0x2c,%esp
	if (PGNUM(pa) >= npages)
f01060bd:	83 3d c8 74 2c f0 00 	cmpl   $0x0,0xf02c74c8
f01060c4:	0f 84 bb 00 00 00    	je     f0106185 <acpi_init+0xd1>
	ebda = *(uint16_t *) KADDR(0x40E);
f01060ca:	0f b7 05 0e 04 00 f0 	movzwl 0xf000040e,%eax
	ebda <<= 4;
f01060d1:	c1 e0 04             	shl    $0x4,%eax
	if ((rsdp = rsdp_search1(ebda, 1024)))
f01060d4:	ba 00 04 00 00       	mov    $0x400,%edx
f01060d9:	e8 19 ff ff ff       	call   f0105ff7 <rsdp_search1>
f01060de:	89 c3                	mov    %eax,%ebx
f01060e0:	85 c0                	test   %eax,%eax
f01060e2:	0f 84 b3 00 00 00    	je     f010619b <acpi_init+0xe7>
		rsdp->revision, rsdp->oem_id);
f01060e8:	8d 4b 09             	lea    0x9(%ebx),%ecx
	cprintf("ACPI: RSDP %08p %06x v%02d %.6s\n",
f01060eb:	0f b6 53 0f          	movzbl 0xf(%ebx),%edx
f01060ef:	80 7b 0f 00          	cmpb   $0x0,0xf(%ebx)
f01060f3:	0f 84 cf 00 00 00    	je     f01061c8 <acpi_init+0x114>
f01060f9:	8b 43 14             	mov    0x14(%ebx),%eax
	if ((uint32_t)kva < KERNBASE)
f01060fc:	81 fb ff ff ff ef    	cmp    $0xefffffff,%ebx
f0106102:	0f 86 ca 00 00 00    	jbe    f01061d2 <acpi_init+0x11e>
f0106108:	83 ec 0c             	sub    $0xc,%esp
f010610b:	51                   	push   %ecx
f010610c:	52                   	push   %edx
f010610d:	50                   	push   %eax
	return (physaddr_t)kva - KERNBASE;
f010610e:	8d 83 00 00 00 10    	lea    0x10000000(%ebx),%eax
f0106114:	50                   	push   %eax
f0106115:	68 48 99 10 f0       	push   $0xf0109948
f010611a:	e8 84 db ff ff       	call   f0103ca3 <cprintf>
	rsdp = rsdp_search();
	if (!rsdp)
		panic("ACPI: No RSDP found");
	print_table_rsdp(rsdp);

	if (rsdp->revision) {
f010611f:	83 c4 20             	add    $0x20,%esp
f0106122:	80 7b 0f 00          	cmpb   $0x0,0xf(%ebx)
f0106126:	0f 84 ca 00 00 00    	je     f01061f6 <acpi_init+0x142>
		hdr = KADDR(rsdp->xsdt_physical_address);
f010612c:	8b 5b 18             	mov    0x18(%ebx),%ebx
	if (PGNUM(pa) >= npages)
f010612f:	89 d8                	mov    %ebx,%eax
f0106131:	c1 e8 0c             	shr    $0xc,%eax
f0106134:	39 05 c8 74 2c f0    	cmp    %eax,0xf02c74c8
f010613a:	0f 86 a4 00 00 00    	jbe    f01061e4 <acpi_init+0x130>
f0106140:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
		sig = ACPI_SIG_XSDT;
		entry_size = 8;
f0106146:	c7 45 d8 08 00 00 00 	movl   $0x8,-0x28(%ebp)
		sig = ACPI_SIG_XSDT;
f010614d:	bf 7e 99 10 f0       	mov    $0xf010997e,%edi
		hdr = KADDR(rsdp->rsdt_physical_address);
		sig = ACPI_SIG_RSDT;
		entry_size = 4;
	}

	if (memcmp(hdr->signature, sig, 4))
f0106152:	83 ec 04             	sub    $0x4,%esp
f0106155:	6a 04                	push   $0x4
f0106157:	57                   	push   %edi
f0106158:	53                   	push   %ebx
f0106159:	e8 85 fc ff ff       	call   f0105de3 <memcmp>
f010615e:	89 45 e0             	mov    %eax,-0x20(%ebp)
f0106161:	83 c4 10             	add    $0x10,%esp
f0106164:	85 c0                	test   %eax,%eax
f0106166:	0f 85 c3 00 00 00    	jne    f010622f <acpi_init+0x17b>
		panic("ACPI: Incorrect %s signature", sig);
	if (sum(hdr, hdr->length))
f010616c:	8b 73 04             	mov    0x4(%ebx),%esi
	sum = 0;
f010616f:	8b 45 e0             	mov    -0x20(%ebp),%eax
f0106172:	89 c2                	mov    %eax,%edx
	for (i = 0; i < len; i++)
f0106174:	39 c6                	cmp    %eax,%esi
f0106176:	0f 8e c5 00 00 00    	jle    f0106241 <acpi_init+0x18d>
		sum += ((uint8_t *)addr)[i];
f010617c:	0f b6 0c 03          	movzbl (%ebx,%eax,1),%ecx
f0106180:	01 ca                	add    %ecx,%edx
	for (i = 0; i < len; i++)
f0106182:	40                   	inc    %eax
f0106183:	eb ef                	jmp    f0106174 <acpi_init+0xc0>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0106185:	68 0e 04 00 00       	push   $0x40e
f010618a:	68 c8 77 10 f0       	push   $0xf01077c8
f010618f:	6a 4d                	push   $0x4d
f0106191:	68 69 99 10 f0       	push   $0xf0109969
f0106196:	e8 a8 9e ff ff       	call   f0100043 <_panic>
	return rsdp_search1(0xE0000, 0x20000);
f010619b:	ba 00 00 02 00       	mov    $0x20000,%edx
f01061a0:	b8 00 00 0e 00       	mov    $0xe0000,%eax
f01061a5:	e8 4d fe ff ff       	call   f0105ff7 <rsdp_search1>
f01061aa:	89 c3                	mov    %eax,%ebx
	if (!rsdp)
f01061ac:	85 c0                	test   %eax,%eax
f01061ae:	0f 85 34 ff ff ff    	jne    f01060e8 <acpi_init+0x34>
		panic("ACPI: No RSDP found");
f01061b4:	83 ec 04             	sub    $0x4,%esp
f01061b7:	68 88 99 10 f0       	push   $0xf0109988
f01061bc:	6a 60                	push   $0x60
f01061be:	68 69 99 10 f0       	push   $0xf0109969
f01061c3:	e8 7b 9e ff ff       	call   f0100043 <_panic>
	cprintf("ACPI: RSDP %08p %06x v%02d %.6s\n",
f01061c8:	b8 14 00 00 00       	mov    $0x14,%eax
f01061cd:	e9 2a ff ff ff       	jmp    f01060fc <acpi_init+0x48>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01061d2:	53                   	push   %ebx
f01061d3:	68 ec 77 10 f0       	push   $0xf01077ec
f01061d8:	6a 16                	push   $0x16
f01061da:	68 69 99 10 f0       	push   $0xf0109969
f01061df:	e8 5f 9e ff ff       	call   f0100043 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01061e4:	53                   	push   %ebx
f01061e5:	68 c8 77 10 f0       	push   $0xf01077c8
f01061ea:	6a 64                	push   $0x64
f01061ec:	68 69 99 10 f0       	push   $0xf0109969
f01061f1:	e8 4d 9e ff ff       	call   f0100043 <_panic>
		hdr = KADDR(rsdp->rsdt_physical_address);
f01061f6:	8b 5b 10             	mov    0x10(%ebx),%ebx
	if (PGNUM(pa) >= npages)
f01061f9:	89 d8                	mov    %ebx,%eax
f01061fb:	c1 e8 0c             	shr    $0xc,%eax
f01061fe:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f0106204:	73 17                	jae    f010621d <acpi_init+0x169>
f0106206:	81 eb 00 00 00 10    	sub    $0x10000000,%ebx
		entry_size = 4;
f010620c:	c7 45 d8 04 00 00 00 	movl   $0x4,-0x28(%ebp)
		sig = ACPI_SIG_RSDT;
f0106213:	bf 83 99 10 f0       	mov    $0xf0109983,%edi
f0106218:	e9 35 ff ff ff       	jmp    f0106152 <acpi_init+0x9e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f010621d:	53                   	push   %ebx
f010621e:	68 c8 77 10 f0       	push   $0xf01077c8
f0106223:	6a 68                	push   $0x68
f0106225:	68 69 99 10 f0       	push   $0xf0109969
f010622a:	e8 14 9e ff ff       	call   f0100043 <_panic>
		panic("ACPI: Incorrect %s signature", sig);
f010622f:	57                   	push   %edi
f0106230:	68 9c 99 10 f0       	push   $0xf010999c
f0106235:	6a 6e                	push   $0x6e
f0106237:	68 69 99 10 f0       	push   $0xf0109969
f010623c:	e8 02 9e ff ff       	call   f0100043 <_panic>
	if (sum(hdr, hdr->length))
f0106241:	84 d2                	test   %dl,%dl
f0106243:	75 1f                	jne    f0106264 <acpi_init+0x1b0>
		panic("ACPI: Bad %s checksum", sig);
	print_table_header(hdr);
f0106245:	89 d8                	mov    %ebx,%eax
f0106247:	e8 3f fd ff ff       	call   f0105f8b <print_table_header>

	p = hdr + 1;
f010624c:	8d 43 24             	lea    0x24(%ebx),%eax
f010624f:	89 c7                	mov    %eax,%edi
	e = (void *)hdr + hdr->length;
f0106251:	89 d8                	mov    %ebx,%eax
f0106253:	03 43 04             	add    0x4(%ebx),%eax
f0106256:	89 45 dc             	mov    %eax,-0x24(%ebp)
	for (i = 0; p < e; p += entry_size) {
f0106259:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
f0106260:	89 fb                	mov    %edi,%ebx
f0106262:	eb 3a                	jmp    f010629e <acpi_init+0x1ea>
		panic("ACPI: Bad %s checksum", sig);
f0106264:	57                   	push   %edi
f0106265:	68 b9 99 10 f0       	push   $0xf01099b9
f010626a:	6a 70                	push   $0x70
f010626c:	68 69 99 10 f0       	push   $0xf0109969
f0106271:	e8 cd 9d ff ff       	call   f0100043 <_panic>
f0106276:	56                   	push   %esi
f0106277:	68 c8 77 10 f0       	push   $0xf01077c8
f010627c:	6a 76                	push   $0x76
f010627e:	68 69 99 10 f0       	push   $0xf0109969
f0106283:	e8 bb 9d ff ff       	call   f0100043 <_panic>
		sum += ((uint8_t *)addr)[i];
f0106288:	0f b6 8c 30 00 00 00 	movzbl -0x10000000(%eax,%esi,1),%ecx
f010628f:	f0 
f0106290:	01 ca                	add    %ecx,%edx
	for (i = 0; i < len; i++)
f0106292:	40                   	inc    %eax
f0106293:	39 c7                	cmp    %eax,%edi
f0106295:	7f f1                	jg     f0106288 <acpi_init+0x1d4>
		hdr = KADDR(*(uint32_t *)p);
		if (sum(hdr, hdr->length))
f0106297:	84 d2                	test   %dl,%dl
f0106299:	74 2d                	je     f01062c8 <acpi_init+0x214>
	for (i = 0; p < e; p += entry_size) {
f010629b:	03 5d d8             	add    -0x28(%ebp),%ebx
f010629e:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
f01062a1:	73 5e                	jae    f0106301 <acpi_init+0x24d>
		hdr = KADDR(*(uint32_t *)p);
f01062a3:	8b 33                	mov    (%ebx),%esi
	if (PGNUM(pa) >= npages)
f01062a5:	89 f0                	mov    %esi,%eax
f01062a7:	c1 e8 0c             	shr    $0xc,%eax
f01062aa:	3b 05 c8 74 2c f0    	cmp    0xf02c74c8,%eax
f01062b0:	73 c4                	jae    f0106276 <acpi_init+0x1c2>
	return (void *)(pa + KERNBASE);
f01062b2:	8d 86 00 00 00 f0    	lea    -0x10000000(%esi),%eax
f01062b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if (sum(hdr, hdr->length))
f01062bb:	8b be 04 00 00 f0    	mov    -0xffffffc(%esi),%edi
	sum = 0;
f01062c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
f01062c4:	89 c2                	mov    %eax,%edx
f01062c6:	eb cb                	jmp    f0106293 <acpi_init+0x1df>
			continue;
		print_table_header(hdr);
f01062c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
f01062cb:	e8 bb fc ff ff       	call   f0105f8b <print_table_header>
		assert(i < ACPI_NR_MAX);
f01062d0:	83 7d d4 1f          	cmpl   $0x1f,-0x2c(%ebp)
f01062d4:	77 15                	ja     f01062eb <acpi_init+0x237>
		acpi_tables.entries[i++] = hdr;
f01062d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f01062d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
f01062dc:	89 3c 85 84 6e 2c f0 	mov    %edi,-0xfd3917c(,%eax,4)
f01062e3:	8d 40 01             	lea    0x1(%eax),%eax
f01062e6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
f01062e9:	eb b0                	jmp    f010629b <acpi_init+0x1e7>
		assert(i < ACPI_NR_MAX);
f01062eb:	68 cf 99 10 f0       	push   $0xf01099cf
f01062f0:	68 31 78 10 f0       	push   $0xf0107831
f01062f5:	6a 7a                	push   $0x7a
f01062f7:	68 69 99 10 f0       	push   $0xf0109969
f01062fc:	e8 42 9d ff ff       	call   f0100043 <_panic>
	}
	acpi_tables.nr = i;
f0106301:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106304:	a3 80 6e 2c f0       	mov    %eax,0xf02c6e80
}
f0106309:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010630c:	5b                   	pop    %ebx
f010630d:	5e                   	pop    %esi
f010630e:	5f                   	pop    %edi
f010630f:	5d                   	pop    %ebp
f0106310:	c3                   	ret    

f0106311 <acpi_get_table>:

void *
acpi_get_table(const char *signature)
{
f0106311:	55                   	push   %ebp
f0106312:	89 e5                	mov    %esp,%ebp
f0106314:	57                   	push   %edi
f0106315:	56                   	push   %esi
f0106316:	53                   	push   %ebx
f0106317:	83 ec 0c             	sub    $0xc,%esp
f010631a:	8b 7d 08             	mov    0x8(%ebp),%edi
	uint32_t i;
	struct acpi_table_header **phdr = acpi_tables.entries;
f010631d:	be 84 6e 2c f0       	mov    $0xf02c6e84,%esi

	for (i = 0; i < acpi_tables.nr; ++i, ++phdr) {
f0106322:	bb 00 00 00 00       	mov    $0x0,%ebx
f0106327:	3b 1d 80 6e 2c f0    	cmp    0xf02c6e80,%ebx
f010632d:	73 1e                	jae    f010634d <acpi_get_table+0x3c>
		if (!memcmp((*phdr)->signature, signature, 4))
f010632f:	83 ec 04             	sub    $0x4,%esp
f0106332:	6a 04                	push   $0x4
f0106334:	57                   	push   %edi
f0106335:	ff 36                	pushl  (%esi)
f0106337:	e8 a7 fa ff ff       	call   f0105de3 <memcmp>
f010633c:	83 c4 10             	add    $0x10,%esp
f010633f:	85 c0                	test   %eax,%eax
f0106341:	74 06                	je     f0106349 <acpi_get_table+0x38>
	for (i = 0; i < acpi_tables.nr; ++i, ++phdr) {
f0106343:	43                   	inc    %ebx
f0106344:	83 c6 04             	add    $0x4,%esi
f0106347:	eb de                	jmp    f0106327 <acpi_get_table+0x16>
			return *phdr;
f0106349:	8b 06                	mov    (%esi),%eax
f010634b:	eb 05                	jmp    f0106352 <acpi_get_table+0x41>
	}
	return NULL;
f010634d:	b8 00 00 00 00       	mov    $0x0,%eax
}
f0106352:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106355:	5b                   	pop    %ebx
f0106356:	5e                   	pop    %esi
f0106357:	5f                   	pop    %edi
f0106358:	5d                   	pop    %ebp
f0106359:	c3                   	ret    

f010635a <mp_init>:
unsigned char percpu_kstacks[NCPU][KSTKSIZE]
__attribute__ ((aligned(PGSIZE)));

void
mp_init(void)
{
f010635a:	55                   	push   %ebp
f010635b:	89 e5                	mov    %esp,%ebp
f010635d:	56                   	push   %esi
f010635e:	53                   	push   %ebx
	struct acpi_subtable_header *hdr, *end;

	// 5.2.12.1 MADT Processor Local APIC / SAPIC Structure Entry Order
	// * initialize processors in the order that they appear in MADT;
	// * the boot processor is the first processor entry.
	bootcpu->cpu_status = CPU_STARTED;
f010635f:	c7 05 04 80 2c f0 01 	movl   $0x1,0xf02c8004
f0106366:	00 00 00 

	madt = acpi_get_table(ACPI_SIG_MADT);
f0106369:	83 ec 0c             	sub    $0xc,%esp
f010636c:	68 df 99 10 f0       	push   $0xf01099df
f0106371:	e8 9b ff ff ff       	call   f0106311 <acpi_get_table>
	if (!madt)
f0106376:	83 c4 10             	add    $0x10,%esp
f0106379:	85 c0                	test   %eax,%eax
f010637b:	74 11                	je     f010638e <mp_init+0x34>
		panic("ACPI: No MADT found");

	lapic_addr = madt->address;
f010637d:	8b 50 24             	mov    0x24(%eax),%edx
f0106380:	89 15 00 90 30 f0    	mov    %edx,0xf0309000

	hdr = (void *)madt + sizeof(*madt);
f0106386:	8d 50 2c             	lea    0x2c(%eax),%edx
	end = (void *)madt + madt->header.length;
f0106389:	03 40 04             	add    0x4(%eax),%eax
	for (; hdr < end; hdr = (void *)hdr + hdr->length) {
f010638c:	eb 4a                	jmp    f01063d8 <mp_init+0x7e>
		panic("ACPI: No MADT found");
f010638e:	83 ec 04             	sub    $0x4,%esp
f0106391:	68 e4 99 10 f0       	push   $0xf01099e4
f0106396:	6a 1c                	push   $0x1c
f0106398:	68 f8 99 10 f0       	push   $0xf01099f8
f010639d:	e8 a1 9c ff ff       	call   f0100043 <_panic>
		switch (hdr->type) {
		case ACPI_MADT_TYPE_LOCAL_APIC: {
			struct acpi_madt_local_apic *p = (void *)hdr;
			bool enabled = p->lapic_flags & BIT(0);

			if (ncpu < NCPU && enabled) {
f01063a2:	8b 35 a0 83 2c f0    	mov    0xf02c83a0,%esi
f01063a8:	83 fe 07             	cmp    $0x7,%esi
f01063ab:	7f 25                	jg     f01063d2 <mp_init+0x78>
f01063ad:	f6 42 04 01          	testb  $0x1,0x4(%edx)
f01063b1:	74 1f                	je     f01063d2 <mp_init+0x78>
				// Be careful: cpu_apicid may differ from cpus index
				cpus[ncpu].cpu_apicid = p->id;
f01063b3:	8d 1c 36             	lea    (%esi,%esi,1),%ebx
f01063b6:	01 f3                	add    %esi,%ebx
f01063b8:	01 db                	add    %ebx,%ebx
f01063ba:	01 f3                	add    %esi,%ebx
f01063bc:	8d 1c 9e             	lea    (%esi,%ebx,4),%ebx
f01063bf:	8a 4a 03             	mov    0x3(%edx),%cl
f01063c2:	88 0c 9d 00 80 2c f0 	mov    %cl,-0xfd38000(,%ebx,4)
				ncpu++;
f01063c9:	8d 4e 01             	lea    0x1(%esi),%ecx
f01063cc:	89 0d a0 83 2c f0    	mov    %ecx,0xf02c83a0
	for (; hdr < end; hdr = (void *)hdr + hdr->length) {
f01063d2:	0f b6 4a 01          	movzbl 0x1(%edx),%ecx
f01063d6:	01 ca                	add    %ecx,%edx
f01063d8:	39 c2                	cmp    %eax,%edx
f01063da:	73 1c                	jae    f01063f8 <mp_init+0x9e>
		switch (hdr->type) {
f01063dc:	8a 0a                	mov    (%edx),%cl
f01063de:	84 c9                	test   %cl,%cl
f01063e0:	74 c0                	je     f01063a2 <mp_init+0x48>
f01063e2:	80 f9 01             	cmp    $0x1,%cl
f01063e5:	75 eb                	jne    f01063d2 <mp_init+0x78>
		}
		case ACPI_MADT_TYPE_IO_APIC: {
			struct acpi_madt_io_apic *p = (void *)hdr;

			// We use one IOAPIC.
			if (p->global_irq_base == 0)
f01063e7:	83 7a 08 00          	cmpl   $0x0,0x8(%edx)
f01063eb:	75 e5                	jne    f01063d2 <mp_init+0x78>
				ioapic_addr = p->address;
f01063ed:	8b 4a 04             	mov    0x4(%edx),%ecx
f01063f0:	89 0d 04 90 30 f0    	mov    %ecx,0xf0309004
f01063f6:	eb da                	jmp    f01063d2 <mp_init+0x78>
		default:
			break;
		}
	}

	cprintf("SMP: %d CPU(s)\n", ncpu);
f01063f8:	83 ec 08             	sub    $0x8,%esp
f01063fb:	ff 35 a0 83 2c f0    	pushl  0xf02c83a0
f0106401:	68 08 9a 10 f0       	push   $0xf0109a08
f0106406:	e8 98 d8 ff ff       	call   f0103ca3 <cprintf>
}
f010640b:	83 c4 10             	add    $0x10,%esp
f010640e:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106411:	5b                   	pop    %ebx
f0106412:	5e                   	pop    %esi
f0106413:	5d                   	pop    %ebp
f0106414:	c3                   	ret    

f0106415 <lapic_write>:
	return lapic[index];
}

static void
lapic_write(uint32_t index, uint32_t value)
{
f0106415:	55                   	push   %ebp
f0106416:	89 e5                	mov    %esp,%ebp
	lapic[index] = value;
f0106418:	8b 0d 04 6f 2c f0    	mov    0xf02c6f04,%ecx
f010641e:	8d 04 81             	lea    (%ecx,%eax,4),%eax
f0106421:	89 10                	mov    %edx,(%eax)
	lapic[ID];  // wait for write to finish, by reading
f0106423:	8b 41 20             	mov    0x20(%ecx),%eax
}
f0106426:	5d                   	pop    %ebp
f0106427:	c3                   	ret    

f0106428 <cpunum>:
int
cpunum(void)
{
	int apicid, i;

	if (!lapic)
f0106428:	a1 04 6f 2c f0       	mov    0xf02c6f04,%eax
f010642d:	85 c0                	test   %eax,%eax
f010642f:	74 45                	je     f0106476 <cpunum+0x4e>
{
f0106431:	55                   	push   %ebp
f0106432:	89 e5                	mov    %esp,%ebp
f0106434:	56                   	push   %esi
f0106435:	53                   	push   %ebx
	return lapic[index];
f0106436:	8b 58 20             	mov    0x20(%eax),%ebx
		return 0;
	apicid = lapic_read(ID) >> 24;
f0106439:	c1 eb 18             	shr    $0x18,%ebx
	for (i = 0; i < ncpu; ++i) {
f010643c:	8b 35 a0 83 2c f0    	mov    0xf02c83a0,%esi
f0106442:	ba 00 80 2c f0       	mov    $0xf02c8000,%edx
f0106447:	b8 00 00 00 00       	mov    $0x0,%eax
f010644c:	39 f0                	cmp    %esi,%eax
f010644e:	7d 0d                	jge    f010645d <cpunum+0x35>
		if (cpus[i].cpu_apicid == apicid)
f0106450:	0f b6 0a             	movzbl (%edx),%ecx
f0106453:	83 c2 74             	add    $0x74,%edx
f0106456:	39 cb                	cmp    %ecx,%ebx
f0106458:	74 22                	je     f010647c <cpunum+0x54>
	for (i = 0; i < ncpu; ++i) {
f010645a:	40                   	inc    %eax
f010645b:	eb ef                	jmp    f010644c <cpunum+0x24>
			return i;
	}
	assert(0);
f010645d:	68 4e 88 10 f0       	push   $0xf010884e
f0106462:	68 31 78 10 f0       	push   $0xf0107831
f0106467:	68 86 00 00 00       	push   $0x86
f010646c:	68 18 9a 10 f0       	push   $0xf0109a18
f0106471:	e8 cd 9b ff ff       	call   f0100043 <_panic>
		return 0;
f0106476:	b8 00 00 00 00       	mov    $0x0,%eax
f010647b:	c3                   	ret    
}
f010647c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010647f:	5b                   	pop    %ebx
f0106480:	5e                   	pop    %esi
f0106481:	5d                   	pop    %ebp
f0106482:	c3                   	ret    

f0106483 <lapic_init>:
{
f0106483:	55                   	push   %ebp
f0106484:	89 e5                	mov    %esp,%ebp
f0106486:	53                   	push   %ebx
f0106487:	83 ec 04             	sub    $0x4,%esp
	assert(lapic_addr);
f010648a:	a1 00 90 30 f0       	mov    0xf0309000,%eax
f010648f:	85 c0                	test   %eax,%eax
f0106491:	0f 84 24 01 00 00    	je     f01065bb <lapic_init+0x138>
	lapic = mmio_map_region(lapic_addr, 4096);
f0106497:	83 ec 08             	sub    $0x8,%esp
f010649a:	68 00 10 00 00       	push   $0x1000
f010649f:	50                   	push   %eax
f01064a0:	e8 6a b1 ff ff       	call   f010160f <mmio_map_region>
f01064a5:	89 c3                	mov    %eax,%ebx
f01064a7:	a3 04 6f 2c f0       	mov    %eax,0xf02c6f04
	if (thiscpu == bootcpu)
f01064ac:	e8 77 ff ff ff       	call   f0106428 <cpunum>
f01064b1:	8d 14 00             	lea    (%eax,%eax,1),%edx
f01064b4:	01 c2                	add    %eax,%edx
f01064b6:	01 d2                	add    %edx,%edx
f01064b8:	01 c2                	add    %eax,%edx
f01064ba:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01064bd:	83 c4 10             	add    $0x10,%esp
f01064c0:	c1 e0 02             	shl    $0x2,%eax
f01064c3:	0f 84 08 01 00 00    	je     f01065d1 <lapic_init+0x14e>
	lapic_write(SVR, ENABLE | (IRQ_OFFSET + IRQ_SPURIOUS));
f01064c9:	ba 27 01 00 00       	mov    $0x127,%edx
f01064ce:	b8 3c 00 00 00       	mov    $0x3c,%eax
f01064d3:	e8 3d ff ff ff       	call   f0106415 <lapic_write>
	lapic_write(TDCR, X1);
f01064d8:	ba 0b 00 00 00       	mov    $0xb,%edx
f01064dd:	b8 f8 00 00 00       	mov    $0xf8,%eax
f01064e2:	e8 2e ff ff ff       	call   f0106415 <lapic_write>
	lapic_write(TIMER, PERIODIC | (IRQ_OFFSET + IRQ_TIMER));
f01064e7:	ba 20 00 02 00       	mov    $0x20020,%edx
f01064ec:	b8 c8 00 00 00       	mov    $0xc8,%eax
f01064f1:	e8 1f ff ff ff       	call   f0106415 <lapic_write>
	lapic_write(TICR, 10000000);
f01064f6:	ba 80 96 98 00       	mov    $0x989680,%edx
f01064fb:	b8 e0 00 00 00       	mov    $0xe0,%eax
f0106500:	e8 10 ff ff ff       	call   f0106415 <lapic_write>
	if (thiscpu != bootcpu)
f0106505:	e8 1e ff ff ff       	call   f0106428 <cpunum>
f010650a:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010650d:	01 c2                	add    %eax,%edx
f010650f:	01 d2                	add    %edx,%edx
f0106511:	01 c2                	add    %eax,%edx
f0106513:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0106516:	c1 e0 02             	shl    $0x2,%eax
f0106519:	0f 85 d4 00 00 00    	jne    f01065f3 <lapic_init+0x170>
	lapic_write(LINT1, MASKED);
f010651f:	ba 00 00 01 00       	mov    $0x10000,%edx
f0106524:	b8 d8 00 00 00       	mov    $0xd8,%eax
f0106529:	e8 e7 fe ff ff       	call   f0106415 <lapic_write>
	return lapic[index];
f010652e:	8b 1d 04 6f 2c f0    	mov    0xf02c6f04,%ebx
f0106534:	8b 43 30             	mov    0x30(%ebx),%eax
	if (((lapic_read(VER)>>16) & 0xFF) >= 4)
f0106537:	c1 e8 10             	shr    $0x10,%eax
f010653a:	3c 03                	cmp    $0x3,%al
f010653c:	0f 87 c5 00 00 00    	ja     f0106607 <lapic_init+0x184>
	lapic_write(ERROR, IRQ_OFFSET + IRQ_ERROR);
f0106542:	ba 33 00 00 00       	mov    $0x33,%edx
f0106547:	b8 dc 00 00 00       	mov    $0xdc,%eax
f010654c:	e8 c4 fe ff ff       	call   f0106415 <lapic_write>
	lapic_write(ESR, 0);
f0106551:	ba 00 00 00 00       	mov    $0x0,%edx
f0106556:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010655b:	e8 b5 fe ff ff       	call   f0106415 <lapic_write>
	lapic_write(ESR, 0);
f0106560:	ba 00 00 00 00       	mov    $0x0,%edx
f0106565:	b8 a0 00 00 00       	mov    $0xa0,%eax
f010656a:	e8 a6 fe ff ff       	call   f0106415 <lapic_write>
	lapic_write(EOI, 0);
f010656f:	ba 00 00 00 00       	mov    $0x0,%edx
f0106574:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106579:	e8 97 fe ff ff       	call   f0106415 <lapic_write>
	lapic_write(ICRHI, 0);
f010657e:	ba 00 00 00 00       	mov    $0x0,%edx
f0106583:	b8 c4 00 00 00       	mov    $0xc4,%eax
f0106588:	e8 88 fe ff ff       	call   f0106415 <lapic_write>
	lapic_write(ICRLO, BCAST | INIT | LEVEL);
f010658d:	ba 00 85 08 00       	mov    $0x88500,%edx
f0106592:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106597:	e8 79 fe ff ff       	call   f0106415 <lapic_write>
	return lapic[index];
f010659c:	8b 83 00 03 00 00    	mov    0x300(%ebx),%eax
	while(lapic_read(ICRLO) & DELIVS)
f01065a2:	f6 c4 10             	test   $0x10,%ah
f01065a5:	75 f5                	jne    f010659c <lapic_init+0x119>
	lapic_write(TPR, 0);
f01065a7:	ba 00 00 00 00       	mov    $0x0,%edx
f01065ac:	b8 20 00 00 00       	mov    $0x20,%eax
f01065b1:	e8 5f fe ff ff       	call   f0106415 <lapic_write>
}
f01065b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f01065b9:	c9                   	leave  
f01065ba:	c3                   	ret    
	assert(lapic_addr);
f01065bb:	68 25 9a 10 f0       	push   $0xf0109a25
f01065c0:	68 31 78 10 f0       	push   $0xf0107831
f01065c5:	6a 40                	push   $0x40
f01065c7:	68 18 9a 10 f0       	push   $0xf0109a18
f01065cc:	e8 72 9a ff ff       	call   f0100043 <_panic>
	return lapic[index];
f01065d1:	8b 43 30             	mov    0x30(%ebx),%eax
		cprintf("SMP: LAPIC %08p v%02x\n", lapic_addr, lapic_read(VER) & 0xFF);
f01065d4:	83 ec 04             	sub    $0x4,%esp
f01065d7:	0f b6 c0             	movzbl %al,%eax
f01065da:	50                   	push   %eax
f01065db:	ff 35 00 90 30 f0    	pushl  0xf0309000
f01065e1:	68 30 9a 10 f0       	push   $0xf0109a30
f01065e6:	e8 b8 d6 ff ff       	call   f0103ca3 <cprintf>
f01065eb:	83 c4 10             	add    $0x10,%esp
f01065ee:	e9 d6 fe ff ff       	jmp    f01064c9 <lapic_init+0x46>
		lapic_write(LINT0, MASKED);
f01065f3:	ba 00 00 01 00       	mov    $0x10000,%edx
f01065f8:	b8 d4 00 00 00       	mov    $0xd4,%eax
f01065fd:	e8 13 fe ff ff       	call   f0106415 <lapic_write>
f0106602:	e9 18 ff ff ff       	jmp    f010651f <lapic_init+0x9c>
		lapic_write(PCINT, MASKED);
f0106607:	ba 00 00 01 00       	mov    $0x10000,%edx
f010660c:	b8 d0 00 00 00       	mov    $0xd0,%eax
f0106611:	e8 ff fd ff ff       	call   f0106415 <lapic_write>
f0106616:	e9 27 ff ff ff       	jmp    f0106542 <lapic_init+0xbf>

f010661b <lapic_eoi>:

// Acknowledge interrupt.
void
lapic_eoi(void)
{
	if (lapic)
f010661b:	83 3d 04 6f 2c f0 00 	cmpl   $0x0,0xf02c6f04
f0106622:	74 13                	je     f0106637 <lapic_eoi+0x1c>
{
f0106624:	55                   	push   %ebp
f0106625:	89 e5                	mov    %esp,%ebp
		lapic_write(EOI, 0);
f0106627:	ba 00 00 00 00       	mov    $0x0,%edx
f010662c:	b8 2c 00 00 00       	mov    $0x2c,%eax
f0106631:	e8 df fd ff ff       	call   f0106415 <lapic_write>
}
f0106636:	5d                   	pop    %ebp
f0106637:	c3                   	ret    

f0106638 <lapic_startap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapic_startap(uint8_t apicid, uint32_t addr)
{
f0106638:	55                   	push   %ebp
f0106639:	89 e5                	mov    %esp,%ebp
f010663b:	56                   	push   %esi
f010663c:	53                   	push   %ebx
f010663d:	8b 75 08             	mov    0x8(%ebp),%esi
f0106640:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0106643:	ba 70 00 00 00       	mov    $0x70,%edx
f0106648:	b0 0f                	mov    $0xf,%al
f010664a:	ee                   	out    %al,(%dx)
f010664b:	ba 71 00 00 00       	mov    $0x71,%edx
f0106650:	b0 0a                	mov    $0xa,%al
f0106652:	ee                   	out    %al,(%dx)
	if (PGNUM(pa) >= npages)
f0106653:	83 3d c8 74 2c f0 00 	cmpl   $0x0,0xf02c74c8
f010665a:	74 7e                	je     f01066da <lapic_startap+0xa2>
	// and the warm reset vector (DWORD based at 40:67) to point at
	// the AP startup code prior to the [universal startup algorithm]."
	outb(IO_RTC, 0xF);  // offset 0xF is shutdown code
	outb(IO_RTC+1, 0x0A);
	wrv = (uint16_t *)KADDR((0x40 << 4 | 0x67));  // Warm reset vector
	wrv[0] = 0;
f010665c:	66 c7 05 67 04 00 f0 	movw   $0x0,0xf0000467
f0106663:	00 00 
	wrv[1] = addr >> 4;
f0106665:	89 d8                	mov    %ebx,%eax
f0106667:	c1 e8 04             	shr    $0x4,%eax
f010666a:	66 a3 69 04 00 f0    	mov    %ax,0xf0000469

	// "Universal startup algorithm."
	// Send INIT (level-triggered) interrupt to reset other CPU.
	lapic_write(ICRHI, apicid << 24);
f0106670:	c1 e6 18             	shl    $0x18,%esi
f0106673:	89 f2                	mov    %esi,%edx
f0106675:	b8 c4 00 00 00       	mov    $0xc4,%eax
f010667a:	e8 96 fd ff ff       	call   f0106415 <lapic_write>
	lapic_write(ICRLO, INIT | LEVEL | ASSERT);
f010667f:	ba 00 c5 00 00       	mov    $0xc500,%edx
f0106684:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106689:	e8 87 fd ff ff       	call   f0106415 <lapic_write>
	microdelay(200);
	lapic_write(ICRLO, INIT | LEVEL);
f010668e:	ba 00 85 00 00       	mov    $0x8500,%edx
f0106693:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106698:	e8 78 fd ff ff       	call   f0106415 <lapic_write>
	// when it is in the halted state due to an INIT.  So the second
	// should be ignored, but it is part of the official Intel algorithm.
	// Bochs complains about the second one.  Too bad for Bochs.
	for (i = 0; i < 2; i++) {
		lapic_write(ICRHI, apicid << 24);
		lapic_write(ICRLO, STARTUP | (addr >> 12));
f010669d:	c1 eb 0c             	shr    $0xc,%ebx
f01066a0:	80 cf 06             	or     $0x6,%bh
		lapic_write(ICRHI, apicid << 24);
f01066a3:	89 f2                	mov    %esi,%edx
f01066a5:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01066aa:	e8 66 fd ff ff       	call   f0106415 <lapic_write>
		lapic_write(ICRLO, STARTUP | (addr >> 12));
f01066af:	89 da                	mov    %ebx,%edx
f01066b1:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01066b6:	e8 5a fd ff ff       	call   f0106415 <lapic_write>
		lapic_write(ICRHI, apicid << 24);
f01066bb:	89 f2                	mov    %esi,%edx
f01066bd:	b8 c4 00 00 00       	mov    $0xc4,%eax
f01066c2:	e8 4e fd ff ff       	call   f0106415 <lapic_write>
		lapic_write(ICRLO, STARTUP | (addr >> 12));
f01066c7:	89 da                	mov    %ebx,%edx
f01066c9:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01066ce:	e8 42 fd ff ff       	call   f0106415 <lapic_write>
		microdelay(200);
	}
}
f01066d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01066d6:	5b                   	pop    %ebx
f01066d7:	5e                   	pop    %esi
f01066d8:	5d                   	pop    %ebp
f01066d9:	c3                   	ret    
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f01066da:	68 67 04 00 00       	push   $0x467
f01066df:	68 c8 77 10 f0       	push   $0xf01077c8
f01066e4:	68 a7 00 00 00       	push   $0xa7
f01066e9:	68 18 9a 10 f0       	push   $0xf0109a18
f01066ee:	e8 50 99 ff ff       	call   f0100043 <_panic>

f01066f3 <lapic_ipi>:

void
lapic_ipi(int vector)
{
f01066f3:	55                   	push   %ebp
f01066f4:	89 e5                	mov    %esp,%ebp
	lapic_write(ICRLO, OTHERS | FIXED | vector);
f01066f6:	8b 55 08             	mov    0x8(%ebp),%edx
f01066f9:	81 ca 00 00 0c 00    	or     $0xc0000,%edx
f01066ff:	b8 c0 00 00 00       	mov    $0xc0,%eax
f0106704:	e8 0c fd ff ff       	call   f0106415 <lapic_write>
	return lapic[index];
f0106709:	8b 15 04 6f 2c f0    	mov    0xf02c6f04,%edx
f010670f:	8b 82 00 03 00 00    	mov    0x300(%edx),%eax
	while (lapic_read(ICRLO) & DELIVS)
f0106715:	f6 c4 10             	test   $0x10,%ah
f0106718:	75 f5                	jne    f010670f <lapic_ipi+0x1c>
		;
}
f010671a:	5d                   	pop    %ebp
f010671b:	c3                   	ret    

f010671c <ioapic_init>:
	*(ioapic + IOWIN) = data;
}

void
ioapic_init(void)
{
f010671c:	55                   	push   %ebp
f010671d:	89 e5                	mov    %esp,%ebp
f010671f:	56                   	push   %esi
f0106720:	53                   	push   %ebx
	int i, reg_ver, ver, pins;

	// Default physical address.
	assert(ioapic_addr == 0xfec00000);
f0106721:	81 3d 04 90 30 f0 00 	cmpl   $0xfec00000,0xf0309004
f0106728:	00 c0 fe 
f010672b:	75 59                	jne    f0106786 <ioapic_init+0x6a>

	// IOAPIC is the default physical address.  Map it in to
	// virtual memory so we can access it.
	ioapic = mmio_map_region(ioapic_addr, 4096);
f010672d:	83 ec 08             	sub    $0x8,%esp
f0106730:	68 00 10 00 00       	push   $0x1000
f0106735:	68 00 00 c0 fe       	push   $0xfec00000
f010673a:	e8 d0 ae ff ff       	call   f010160f <mmio_map_region>
f010673f:	a3 08 6f 2c f0       	mov    %eax,0xf02c6f08
	*(ioapic + IOREGSEL) = reg;
f0106744:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
	return *(ioapic + IOWIN);
f010674a:	8b 40 10             	mov    0x10(%eax),%eax

	reg_ver = ioapic_read(IOAPICVER);
	ver = reg_ver & 0xff;
	pins = ((reg_ver >> 16) & 0xff) + 1;
f010674d:	89 c2                	mov    %eax,%edx
f010674f:	c1 fa 10             	sar    $0x10,%edx
f0106752:	0f b6 d2             	movzbl %dl,%edx
f0106755:	8d 5a 01             	lea    0x1(%edx),%ebx
	cprintf("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
f0106758:	89 14 24             	mov    %edx,(%esp)
f010675b:	6a 00                	push   $0x0
	ver = reg_ver & 0xff;
f010675d:	0f b6 c0             	movzbl %al,%eax
	cprintf("SMP: IOAPIC %08p v%02x [global_irq %02d-%02d]\n",
f0106760:	50                   	push   %eax
f0106761:	ff 35 04 90 30 f0    	pushl  0xf0309004
f0106767:	68 70 9a 10 f0       	push   $0xf0109a70
f010676c:	e8 32 d5 ff ff       	call   f0103ca3 <cprintf>
	*(ioapic + IOREGSEL) = reg;
f0106771:	8b 0d 08 6f 2c f0    	mov    0xf02c6f08,%ecx
		ioapic_addr, ver, 0, pins - 1);

	// Mark all interrupts edge-triggered, active high, disabled,
	// and not routed to any CPUs.
	for (i = 0; i < pins; ++i) {
f0106777:	83 c4 20             	add    $0x20,%esp
f010677a:	ba 10 00 00 00       	mov    $0x10,%edx
f010677f:	b8 00 00 00 00       	mov    $0x0,%eax
f0106784:	eb 34                	jmp    f01067ba <ioapic_init+0x9e>
	assert(ioapic_addr == 0xfec00000);
f0106786:	68 47 9a 10 f0       	push   $0xf0109a47
f010678b:	68 31 78 10 f0       	push   $0xf0107831
f0106790:	6a 33                	push   $0x33
f0106792:	68 61 9a 10 f0       	push   $0xf0109a61
f0106797:	e8 a7 98 ff ff       	call   f0100043 <_panic>
		ioapic_write(IOREDTBL+2*i, INT_DISABLED | (IRQ_OFFSET + i));
f010679c:	8d 70 20             	lea    0x20(%eax),%esi
f010679f:	81 ce 00 00 01 00    	or     $0x10000,%esi
	*(ioapic + IOREGSEL) = reg;
f01067a5:	89 11                	mov    %edx,(%ecx)
	*(ioapic + IOWIN) = data;
f01067a7:	89 71 10             	mov    %esi,0x10(%ecx)
f01067aa:	8d 72 01             	lea    0x1(%edx),%esi
	*(ioapic + IOREGSEL) = reg;
f01067ad:	89 31                	mov    %esi,(%ecx)
	*(ioapic + IOWIN) = data;
f01067af:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
	for (i = 0; i < pins; ++i) {
f01067b6:	40                   	inc    %eax
f01067b7:	83 c2 02             	add    $0x2,%edx
f01067ba:	39 d8                	cmp    %ebx,%eax
f01067bc:	7c de                	jl     f010679c <ioapic_init+0x80>
		ioapic_write(IOREDTBL+2*i+1, 0);
	}
}
f01067be:	8d 65 f8             	lea    -0x8(%ebp),%esp
f01067c1:	5b                   	pop    %ebx
f01067c2:	5e                   	pop    %esi
f01067c3:	5d                   	pop    %ebp
f01067c4:	c3                   	ret    

f01067c5 <ioapic_enable>:

void
ioapic_enable(int irq, int apicid)
{
f01067c5:	55                   	push   %ebp
f01067c6:	89 e5                	mov    %esp,%ebp
f01067c8:	8b 45 08             	mov    0x8(%ebp),%eax
	// Mark interrupt edge-triggered, active high, enabled,
	// and routed to the given cpu's APIC ID.
	ioapic_write(IOREDTBL+2*irq, IRQ_OFFSET + irq);
f01067cb:	8d 48 20             	lea    0x20(%eax),%ecx
f01067ce:	8d 54 00 10          	lea    0x10(%eax,%eax,1),%edx
	*(ioapic + IOREGSEL) = reg;
f01067d2:	a1 08 6f 2c f0       	mov    0xf02c6f08,%eax
f01067d7:	89 10                	mov    %edx,(%eax)
	*(ioapic + IOWIN) = data;
f01067d9:	89 48 10             	mov    %ecx,0x10(%eax)
	ioapic_write(IOREDTBL+2*irq+1, apicid << 24);
f01067dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f01067df:	c1 e1 18             	shl    $0x18,%ecx
f01067e2:	42                   	inc    %edx
	*(ioapic + IOREGSEL) = reg;
f01067e3:	89 10                	mov    %edx,(%eax)
	*(ioapic + IOWIN) = data;
f01067e5:	89 48 10             	mov    %ecx,0x10(%eax)
}
f01067e8:	5d                   	pop    %ebp
f01067e9:	c3                   	ret    

f01067ea <__spin_initlock>:
}
#endif

void
__spin_initlock(struct spinlock *lk, char *name)
{
f01067ea:	55                   	push   %ebp
f01067eb:	89 e5                	mov    %esp,%ebp
f01067ed:	8b 45 08             	mov    0x8(%ebp),%eax
	lk->locked = 0;
f01067f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#ifdef DEBUG_SPINLOCK
	lk->name = name;
f01067f6:	8b 55 0c             	mov    0xc(%ebp),%edx
f01067f9:	89 50 04             	mov    %edx,0x4(%eax)
	lk->cpu = 0;
f01067fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
#endif
}
f0106803:	5d                   	pop    %ebp
f0106804:	c3                   	ret    

f0106805 <spin_lock>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
spin_lock(struct spinlock *lk)
{
f0106805:	55                   	push   %ebp
f0106806:	89 e5                	mov    %esp,%ebp
f0106808:	56                   	push   %esi
f0106809:	53                   	push   %ebx
f010680a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	return lock->locked && lock->cpu == thiscpu;
f010680d:	83 3b 00             	cmpl   $0x0,(%ebx)
f0106810:	75 07                	jne    f0106819 <spin_lock+0x14>
	asm volatile("lock; xchgl %0, %1"
f0106812:	ba 01 00 00 00       	mov    $0x1,%edx
f0106817:	eb 3f                	jmp    f0106858 <spin_lock+0x53>
f0106819:	8b 73 08             	mov    0x8(%ebx),%esi
f010681c:	e8 07 fc ff ff       	call   f0106428 <cpunum>
f0106821:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0106824:	01 c2                	add    %eax,%edx
f0106826:	01 d2                	add    %edx,%edx
f0106828:	01 c2                	add    %eax,%edx
f010682a:	8d 04 90             	lea    (%eax,%edx,4),%eax
f010682d:	8d 04 85 00 80 2c f0 	lea    -0xfd38000(,%eax,4),%eax
#ifdef DEBUG_SPINLOCK
	if (holding(lk))
f0106834:	39 c6                	cmp    %eax,%esi
f0106836:	75 da                	jne    f0106812 <spin_lock+0xd>
		panic("CPU %d cannot acquire %s: already holding", cpunum(), lk->name);
f0106838:	8b 5b 04             	mov    0x4(%ebx),%ebx
f010683b:	e8 e8 fb ff ff       	call   f0106428 <cpunum>
f0106840:	83 ec 0c             	sub    $0xc,%esp
f0106843:	53                   	push   %ebx
f0106844:	50                   	push   %eax
f0106845:	68 a0 9a 10 f0       	push   $0xf0109aa0
f010684a:	6a 41                	push   $0x41
f010684c:	68 02 9b 10 f0       	push   $0xf0109b02
f0106851:	e8 ed 97 ff ff       	call   f0100043 <_panic>

	// The xchg is atomic.
	// It also serializes, so that reads after acquire are not
	// reordered before it. 
	while (xchg(&lk->locked, 1) != 0)
		asm volatile ("pause");
f0106856:	f3 90                	pause  
f0106858:	89 d0                	mov    %edx,%eax
f010685a:	f0 87 03             	lock xchg %eax,(%ebx)
	while (xchg(&lk->locked, 1) != 0)
f010685d:	85 c0                	test   %eax,%eax
f010685f:	75 f5                	jne    f0106856 <spin_lock+0x51>

	// Record info about lock acquisition for debugging.
#ifdef DEBUG_SPINLOCK
	lk->cpu = thiscpu;
f0106861:	e8 c2 fb ff ff       	call   f0106428 <cpunum>
f0106866:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0106869:	01 c2                	add    %eax,%edx
f010686b:	01 d2                	add    %edx,%edx
f010686d:	01 c2                	add    %eax,%edx
f010686f:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0106872:	8d 04 85 00 80 2c f0 	lea    -0xfd38000(,%eax,4),%eax
f0106879:	89 43 08             	mov    %eax,0x8(%ebx)
	get_caller_pcs(lk->pcs);
f010687c:	83 c3 0c             	add    $0xc,%ebx
	asm volatile("movl %%ebp,%0" : "=r" (ebp));
f010687f:	89 ea                	mov    %ebp,%edx
	for (i = 0; i < 10; i++){
f0106881:	b8 00 00 00 00       	mov    $0x0,%eax
		if (ebp == 0 || ebp < (uint32_t *)ULIM)
f0106886:	81 fa ff ff 7f ef    	cmp    $0xef7fffff,%edx
f010688c:	76 1d                	jbe    f01068ab <spin_lock+0xa6>
		pcs[i] = ebp[1];          // saved %eip
f010688e:	8b 4a 04             	mov    0x4(%edx),%ecx
f0106891:	89 0c 83             	mov    %ecx,(%ebx,%eax,4)
		ebp = (uint32_t *)ebp[0]; // saved %ebp
f0106894:	8b 12                	mov    (%edx),%edx
	for (i = 0; i < 10; i++){
f0106896:	40                   	inc    %eax
f0106897:	83 f8 0a             	cmp    $0xa,%eax
f010689a:	75 ea                	jne    f0106886 <spin_lock+0x81>
#endif
}
f010689c:	8d 65 f8             	lea    -0x8(%ebp),%esp
f010689f:	5b                   	pop    %ebx
f01068a0:	5e                   	pop    %esi
f01068a1:	5d                   	pop    %ebp
f01068a2:	c3                   	ret    
		pcs[i] = 0;
f01068a3:	c7 04 83 00 00 00 00 	movl   $0x0,(%ebx,%eax,4)
	for (; i < 10; i++)
f01068aa:	40                   	inc    %eax
f01068ab:	83 f8 09             	cmp    $0x9,%eax
f01068ae:	7e f3                	jle    f01068a3 <spin_lock+0x9e>
f01068b0:	eb ea                	jmp    f010689c <spin_lock+0x97>

f01068b2 <spin_unlock>:

// Release the lock.
void
spin_unlock(struct spinlock *lk)
{
f01068b2:	55                   	push   %ebp
f01068b3:	89 e5                	mov    %esp,%ebp
f01068b5:	57                   	push   %edi
f01068b6:	56                   	push   %esi
f01068b7:	53                   	push   %ebx
f01068b8:	83 ec 4c             	sub    $0x4c,%esp
f01068bb:	8b 75 08             	mov    0x8(%ebp),%esi
	return lock->locked && lock->cpu == thiscpu;
f01068be:	83 3e 00             	cmpl   $0x0,(%esi)
f01068c1:	75 41                	jne    f0106904 <spin_unlock+0x52>
#ifdef DEBUG_SPINLOCK
	if (!holding(lk)) {
		int i;
		uint32_t pcs[10];
		// Nab the acquiring EIP chain before it gets released
		memmove(pcs, lk->pcs, sizeof pcs);
f01068c3:	83 ec 04             	sub    $0x4,%esp
f01068c6:	6a 28                	push   $0x28
f01068c8:	8d 46 0c             	lea    0xc(%esi),%eax
f01068cb:	50                   	push   %eax
f01068cc:	8d 5d c0             	lea    -0x40(%ebp),%ebx
f01068cf:	53                   	push   %ebx
f01068d0:	e8 95 f4 ff ff       	call   f0105d6a <memmove>
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
			cpunum(), lk->name, lk->cpu - cpus);
f01068d5:	8b 7e 08             	mov    0x8(%esi),%edi
f01068d8:	81 ef 00 80 2c f0    	sub    $0xf02c8000,%edi
		cprintf("CPU %d cannot release %s: held by CPU %d\nAcquired at:", 
f01068de:	c1 ff 02             	sar    $0x2,%edi
f01068e1:	69 ff 35 c2 72 4f    	imul   $0x4f72c235,%edi,%edi
f01068e7:	8b 76 04             	mov    0x4(%esi),%esi
f01068ea:	e8 39 fb ff ff       	call   f0106428 <cpunum>
f01068ef:	57                   	push   %edi
f01068f0:	56                   	push   %esi
f01068f1:	50                   	push   %eax
f01068f2:	68 cc 9a 10 f0       	push   $0xf0109acc
f01068f7:	e8 a7 d3 ff ff       	call   f0103ca3 <cprintf>
f01068fc:	83 c4 20             	add    $0x20,%esp
		for (i = 0; i < 10 && pcs[i]; i++) {
			struct Eipdebuginfo info;
			if (debuginfo_eip(pcs[i], &info) >= 0)
f01068ff:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0106902:	eb 59                	jmp    f010695d <spin_unlock+0xab>
	return lock->locked && lock->cpu == thiscpu;
f0106904:	8b 5e 08             	mov    0x8(%esi),%ebx
f0106907:	e8 1c fb ff ff       	call   f0106428 <cpunum>
f010690c:	8d 14 00             	lea    (%eax,%eax,1),%edx
f010690f:	01 c2                	add    %eax,%edx
f0106911:	01 d2                	add    %edx,%edx
f0106913:	01 c2                	add    %eax,%edx
f0106915:	8d 04 90             	lea    (%eax,%edx,4),%eax
f0106918:	8d 04 85 00 80 2c f0 	lea    -0xfd38000(,%eax,4),%eax
	if (!holding(lk)) {
f010691f:	39 c3                	cmp    %eax,%ebx
f0106921:	75 a0                	jne    f01068c3 <spin_unlock+0x11>
				cprintf("  %08x\n", pcs[i]);
		}
		panic("spin_unlock");
	}

	lk->pcs[0] = 0;
f0106923:	c7 46 0c 00 00 00 00 	movl   $0x0,0xc(%esi)
	lk->cpu = 0;
f010692a:	c7 46 08 00 00 00 00 	movl   $0x0,0x8(%esi)
	asm volatile("lock; xchgl %0, %1"
f0106931:	b8 00 00 00 00       	mov    $0x0,%eax
f0106936:	f0 87 06             	lock xchg %eax,(%esi)
	// Paper says that Intel 64 and IA-32 will not move a load
	// after a store. So lock->locked = 0 would work here.
	// The xchg being asm volatile ensures gcc emits it after
	// the above assignments (and after the critical section).
	xchg(&lk->locked, 0);
}
f0106939:	8d 65 f4             	lea    -0xc(%ebp),%esp
f010693c:	5b                   	pop    %ebx
f010693d:	5e                   	pop    %esi
f010693e:	5f                   	pop    %edi
f010693f:	5d                   	pop    %ebp
f0106940:	c3                   	ret    
				cprintf("  %08x\n", pcs[i]);
f0106941:	83 ec 08             	sub    $0x8,%esp
f0106944:	ff 36                	pushl  (%esi)
f0106946:	68 29 9b 10 f0       	push   $0xf0109b29
f010694b:	e8 53 d3 ff ff       	call   f0103ca3 <cprintf>
f0106950:	83 c4 10             	add    $0x10,%esp
f0106953:	83 c3 04             	add    $0x4,%ebx
		for (i = 0; i < 10 && pcs[i]; i++) {
f0106956:	8d 45 e8             	lea    -0x18(%ebp),%eax
f0106959:	39 c3                	cmp    %eax,%ebx
f010695b:	74 40                	je     f010699d <spin_unlock+0xeb>
f010695d:	89 de                	mov    %ebx,%esi
f010695f:	8b 03                	mov    (%ebx),%eax
f0106961:	85 c0                	test   %eax,%eax
f0106963:	74 38                	je     f010699d <spin_unlock+0xeb>
			if (debuginfo_eip(pcs[i], &info) >= 0)
f0106965:	83 ec 08             	sub    $0x8,%esp
f0106968:	57                   	push   %edi
f0106969:	50                   	push   %eax
f010696a:	e8 e7 e6 ff ff       	call   f0105056 <debuginfo_eip>
f010696f:	83 c4 10             	add    $0x10,%esp
f0106972:	85 c0                	test   %eax,%eax
f0106974:	78 cb                	js     f0106941 <spin_unlock+0x8f>
					pcs[i] - info.eip_fn_addr);
f0106976:	8b 06                	mov    (%esi),%eax
				cprintf("  %08x %s:%d: %.*s+%x\n", pcs[i],
f0106978:	83 ec 04             	sub    $0x4,%esp
f010697b:	89 c2                	mov    %eax,%edx
f010697d:	2b 55 b8             	sub    -0x48(%ebp),%edx
f0106980:	52                   	push   %edx
f0106981:	ff 75 b0             	pushl  -0x50(%ebp)
f0106984:	ff 75 b4             	pushl  -0x4c(%ebp)
f0106987:	ff 75 ac             	pushl  -0x54(%ebp)
f010698a:	ff 75 a8             	pushl  -0x58(%ebp)
f010698d:	50                   	push   %eax
f010698e:	68 12 9b 10 f0       	push   $0xf0109b12
f0106993:	e8 0b d3 ff ff       	call   f0103ca3 <cprintf>
f0106998:	83 c4 20             	add    $0x20,%esp
f010699b:	eb b6                	jmp    f0106953 <spin_unlock+0xa1>
		panic("spin_unlock");
f010699d:	83 ec 04             	sub    $0x4,%esp
f01069a0:	68 31 9b 10 f0       	push   $0xf0109b31
f01069a5:	6a 67                	push   $0x67
f01069a7:	68 02 9b 10 f0       	push   $0xf0109b02
f01069ac:	e8 92 96 ff ff       	call   f0100043 <_panic>

f01069b1 <time_tick>:
// This should be called once per timer interrupt.  A timer interrupt
// fires every 10 ms.
void
time_tick(void)
{
	++ticks;
f01069b1:	a1 10 6f 2c f0       	mov    0xf02c6f10,%eax
f01069b6:	8b 15 14 6f 2c f0    	mov    0xf02c6f14,%edx
f01069bc:	83 c0 01             	add    $0x1,%eax
f01069bf:	83 d2 00             	adc    $0x0,%edx
f01069c2:	a3 10 6f 2c f0       	mov    %eax,0xf02c6f10
f01069c7:	89 15 14 6f 2c f0    	mov    %edx,0xf02c6f14
	if (ticks > UINT64_MAX / NANOSECONDS_PER_TICK)
f01069cd:	81 fa ad 01 00 00    	cmp    $0x1ad,%edx
f01069d3:	72 20                	jb     f01069f5 <time_tick+0x44>
f01069d5:	77 07                	ja     f01069de <time_tick+0x2d>
f01069d7:	3d ca ab 29 7f       	cmp    $0x7f29abca,%eax
f01069dc:	76 17                	jbe    f01069f5 <time_tick+0x44>
{
f01069de:	55                   	push   %ebp
f01069df:	89 e5                	mov    %esp,%ebp
f01069e1:	83 ec 0c             	sub    $0xc,%esp
		panic("time_tick: time overflowed");
f01069e4:	68 49 9b 10 f0       	push   $0xf0109b49
f01069e9:	6a 16                	push   $0x16
f01069eb:	68 64 9b 10 f0       	push   $0xf0109b64
f01069f0:	e8 4e 96 ff ff       	call   f0100043 <_panic>
f01069f5:	c3                   	ret    

f01069f6 <sysinfo>:
}

int
sysinfo(struct sysinfo *info)
{
f01069f6:	55                   	push   %ebp
f01069f7:	89 e5                	mov    %esp,%ebp
f01069f9:	57                   	push   %edi
f01069fa:	56                   	push   %esi
f01069fb:	53                   	push   %ebx
f01069fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
	info->uptime = ticks * NANOSECONDS_PER_TICK;
f01069ff:	69 1d 14 6f 2c f0 80 	imul   $0x989680,0xf02c6f14,%ebx
f0106a06:	96 98 00 
f0106a09:	be 80 96 98 00       	mov    $0x989680,%esi
f0106a0e:	89 f0                	mov    %esi,%eax
f0106a10:	f7 25 10 6f 2c f0    	mull   0xf02c6f10
f0106a16:	89 d7                	mov    %edx,%edi
f0106a18:	01 df                	add    %ebx,%edi
f0106a1a:	89 01                	mov    %eax,(%ecx)
f0106a1c:	89 79 04             	mov    %edi,0x4(%ecx)
	info->totalpages = npages;
f0106a1f:	a1 c8 74 2c f0       	mov    0xf02c74c8,%eax
f0106a24:	89 41 08             	mov    %eax,0x8(%ecx)
	info->freepages = nfreepages;
f0106a27:	a1 c4 74 2c f0       	mov    0xf02c74c4,%eax
f0106a2c:	89 41 0c             	mov    %eax,0xc(%ecx)
	info->inblocks = inblocks;
f0106a2f:	a1 10 90 30 f0       	mov    0xf0309010,%eax
f0106a34:	8b 15 14 90 30 f0    	mov    0xf0309014,%edx
f0106a3a:	89 41 10             	mov    %eax,0x10(%ecx)
f0106a3d:	89 51 14             	mov    %edx,0x14(%ecx)
	info->outblocks = outblocks;
f0106a40:	a1 20 90 30 f0       	mov    0xf0309020,%eax
f0106a45:	8b 15 24 90 30 f0    	mov    0xf0309024,%edx
f0106a4b:	89 41 18             	mov    %eax,0x18(%ecx)
f0106a4e:	89 51 1c             	mov    %edx,0x1c(%ecx)
	info->inpackets = inpackets;
f0106a51:	a1 18 90 30 f0       	mov    0xf0309018,%eax
f0106a56:	8b 15 1c 90 30 f0    	mov    0xf030901c,%edx
f0106a5c:	89 41 20             	mov    %eax,0x20(%ecx)
f0106a5f:	89 51 24             	mov    %edx,0x24(%ecx)
	info->outpackets = outpackets;
f0106a62:	a1 08 90 30 f0       	mov    0xf0309008,%eax
f0106a67:	8b 15 0c 90 30 f0    	mov    0xf030900c,%edx
f0106a6d:	89 41 28             	mov    %eax,0x28(%ecx)
f0106a70:	89 51 2c             	mov    %edx,0x2c(%ecx)
	return 0;
}
f0106a73:	b8 00 00 00 00       	mov    $0x0,%eax
f0106a78:	5b                   	pop    %ebx
f0106a79:	5e                   	pop    %esi
f0106a7a:	5f                   	pop    %edi
f0106a7b:	5d                   	pop    %ebp
f0106a7c:	c3                   	ret    

f0106a7d <pci_conf1_set_addr>:
static void
pci_conf1_set_addr(uint32_t bus,
		   uint32_t dev,
		   uint32_t func,
		   uint32_t offset)
{
f0106a7d:	55                   	push   %ebp
f0106a7e:	89 e5                	mov    %esp,%ebp
f0106a80:	53                   	push   %ebx
f0106a81:	83 ec 04             	sub    $0x4,%esp
f0106a84:	8b 5d 08             	mov    0x8(%ebp),%ebx
	assert(bus < 256);
f0106a87:	3d ff 00 00 00       	cmp    $0xff,%eax
f0106a8c:	77 37                	ja     f0106ac5 <pci_conf1_set_addr+0x48>
	assert(dev < 32);
f0106a8e:	83 fa 1f             	cmp    $0x1f,%edx
f0106a91:	77 48                	ja     f0106adb <pci_conf1_set_addr+0x5e>
	assert(func < 8);
f0106a93:	83 f9 07             	cmp    $0x7,%ecx
f0106a96:	77 59                	ja     f0106af1 <pci_conf1_set_addr+0x74>
	assert(offset < 256);
f0106a98:	81 fb ff 00 00 00    	cmp    $0xff,%ebx
f0106a9e:	77 67                	ja     f0106b07 <pci_conf1_set_addr+0x8a>
	assert((offset & 0x3) == 0);
f0106aa0:	f6 c3 03             	test   $0x3,%bl
f0106aa3:	75 78                	jne    f0106b1d <pci_conf1_set_addr+0xa0>

	uint32_t v = BIT(31) |		// config-space
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106aa5:	c1 e1 08             	shl    $0x8,%ecx
	uint32_t v = BIT(31) |		// config-space
f0106aa8:	81 cb 00 00 00 80    	or     $0x80000000,%ebx
f0106aae:	09 d9                	or     %ebx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106ab0:	c1 e2 0b             	shl    $0xb,%edx
	uint32_t v = BIT(31) |		// config-space
f0106ab3:	09 d1                	or     %edx,%ecx
		(bus << 16) | (dev << 11) | (func << 8) | (offset);
f0106ab5:	c1 e0 10             	shl    $0x10,%eax
	uint32_t v = BIT(31) |		// config-space
f0106ab8:	09 c8                	or     %ecx,%eax
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106aba:	ba f8 0c 00 00       	mov    $0xcf8,%edx
f0106abf:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_addr_ioport, v);
}
f0106ac0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106ac3:	c9                   	leave  
f0106ac4:	c3                   	ret    
	assert(bus < 256);
f0106ac5:	68 73 9b 10 f0       	push   $0xf0109b73
f0106aca:	68 31 78 10 f0       	push   $0xf0107831
f0106acf:	6a 2d                	push   $0x2d
f0106ad1:	68 7d 9b 10 f0       	push   $0xf0109b7d
f0106ad6:	e8 68 95 ff ff       	call   f0100043 <_panic>
	assert(dev < 32);
f0106adb:	68 88 9b 10 f0       	push   $0xf0109b88
f0106ae0:	68 31 78 10 f0       	push   $0xf0107831
f0106ae5:	6a 2e                	push   $0x2e
f0106ae7:	68 7d 9b 10 f0       	push   $0xf0109b7d
f0106aec:	e8 52 95 ff ff       	call   f0100043 <_panic>
	assert(func < 8);
f0106af1:	68 91 9b 10 f0       	push   $0xf0109b91
f0106af6:	68 31 78 10 f0       	push   $0xf0107831
f0106afb:	6a 2f                	push   $0x2f
f0106afd:	68 7d 9b 10 f0       	push   $0xf0109b7d
f0106b02:	e8 3c 95 ff ff       	call   f0100043 <_panic>
	assert(offset < 256);
f0106b07:	68 9a 9b 10 f0       	push   $0xf0109b9a
f0106b0c:	68 31 78 10 f0       	push   $0xf0107831
f0106b11:	6a 30                	push   $0x30
f0106b13:	68 7d 9b 10 f0       	push   $0xf0109b7d
f0106b18:	e8 26 95 ff ff       	call   f0100043 <_panic>
	assert((offset & 0x3) == 0);
f0106b1d:	68 a7 9b 10 f0       	push   $0xf0109ba7
f0106b22:	68 31 78 10 f0       	push   $0xf0107831
f0106b27:	6a 31                	push   $0x31
f0106b29:	68 7d 9b 10 f0       	push   $0xf0109b7d
f0106b2e:	e8 10 95 ff ff       	call   f0100043 <_panic>

f0106b33 <pci_conf_read>:

static uint32_t
pci_conf_read(struct pci_func *f, uint32_t off)
{
f0106b33:	55                   	push   %ebp
f0106b34:	89 e5                	mov    %esp,%ebp
f0106b36:	53                   	push   %ebx
f0106b37:	83 ec 10             	sub    $0x10,%esp
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106b3a:	8b 48 08             	mov    0x8(%eax),%ecx
f0106b3d:	8b 58 04             	mov    0x4(%eax),%ebx
f0106b40:	8b 00                	mov    (%eax),%eax
f0106b42:	8b 40 04             	mov    0x4(%eax),%eax
f0106b45:	52                   	push   %edx
f0106b46:	89 da                	mov    %ebx,%edx
f0106b48:	e8 30 ff ff ff       	call   f0106a7d <pci_conf1_set_addr>
	asm volatile("inl %w1,%0" : "=a" (data) : "d" (port));
f0106b4d:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106b52:	ed                   	in     (%dx),%eax
	return inl(pci_conf1_data_ioport);
}
f0106b53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
f0106b56:	c9                   	leave  
f0106b57:	c3                   	ret    

f0106b58 <pci_conf_write>:

static void
pci_conf_write(struct pci_func *f, uint32_t off, uint32_t v)
{
f0106b58:	55                   	push   %ebp
f0106b59:	89 e5                	mov    %esp,%ebp
f0106b5b:	56                   	push   %esi
f0106b5c:	53                   	push   %ebx
f0106b5d:	89 cb                	mov    %ecx,%ebx
	pci_conf1_set_addr(f->bus->busno, f->dev, f->func, off);
f0106b5f:	8b 48 08             	mov    0x8(%eax),%ecx
f0106b62:	8b 70 04             	mov    0x4(%eax),%esi
f0106b65:	8b 00                	mov    (%eax),%eax
f0106b67:	8b 40 04             	mov    0x4(%eax),%eax
f0106b6a:	83 ec 0c             	sub    $0xc,%esp
f0106b6d:	52                   	push   %edx
f0106b6e:	89 f2                	mov    %esi,%edx
f0106b70:	e8 08 ff ff ff       	call   f0106a7d <pci_conf1_set_addr>
	asm volatile("outl %0,%w1" : : "a" (data), "d" (port));
f0106b75:	ba fc 0c 00 00       	mov    $0xcfc,%edx
f0106b7a:	89 d8                	mov    %ebx,%eax
f0106b7c:	ef                   	out    %eax,(%dx)
	outl(pci_conf1_data_ioport, v);
}
f0106b7d:	83 c4 10             	add    $0x10,%esp
f0106b80:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106b83:	5b                   	pop    %ebx
f0106b84:	5e                   	pop    %esi
f0106b85:	5d                   	pop    %ebp
f0106b86:	c3                   	ret    

f0106b87 <pci_attach_match>:

static int __attribute__((warn_unused_result))
pci_attach_match(uint32_t key1, uint32_t key2,
		 struct pci_driver *list, struct pci_func *pcif)
{
f0106b87:	55                   	push   %ebp
f0106b88:	89 e5                	mov    %esp,%ebp
f0106b8a:	57                   	push   %edi
f0106b8b:	56                   	push   %esi
f0106b8c:	53                   	push   %ebx
f0106b8d:	83 ec 1c             	sub    $0x1c,%esp
f0106b90:	8b 7d 10             	mov    0x10(%ebp),%edi
	uint32_t i;

	for (i = 0; list[i].attachfn; i++) {
f0106b93:	eb 03                	jmp    f0106b98 <pci_attach_match+0x11>
f0106b95:	83 c7 0c             	add    $0xc,%edi
f0106b98:	89 fe                	mov    %edi,%esi
f0106b9a:	8b 47 08             	mov    0x8(%edi),%eax
f0106b9d:	85 c0                	test   %eax,%eax
f0106b9f:	74 3f                	je     f0106be0 <pci_attach_match+0x59>
		if (list[i].key1 == key1 && list[i].key2 == key2) {
f0106ba1:	8b 1f                	mov    (%edi),%ebx
f0106ba3:	3b 5d 08             	cmp    0x8(%ebp),%ebx
f0106ba6:	75 ed                	jne    f0106b95 <pci_attach_match+0xe>
f0106ba8:	8b 56 04             	mov    0x4(%esi),%edx
f0106bab:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f0106bae:	3b 55 0c             	cmp    0xc(%ebp),%edx
f0106bb1:	75 e2                	jne    f0106b95 <pci_attach_match+0xe>
			int r = list[i].attachfn(pcif);
f0106bb3:	83 ec 0c             	sub    $0xc,%esp
f0106bb6:	ff 75 14             	pushl  0x14(%ebp)
f0106bb9:	ff d0                	call   *%eax
			if (r > 0)
f0106bbb:	83 c4 10             	add    $0x10,%esp
f0106bbe:	85 c0                	test   %eax,%eax
f0106bc0:	7f 1e                	jg     f0106be0 <pci_attach_match+0x59>
				return r;
			if (r < 0)
f0106bc2:	85 c0                	test   %eax,%eax
f0106bc4:	79 cf                	jns    f0106b95 <pci_attach_match+0xe>
				cprintf("pci_attach_match: attaching "
f0106bc6:	83 ec 0c             	sub    $0xc,%esp
f0106bc9:	50                   	push   %eax
f0106bca:	ff 76 08             	pushl  0x8(%esi)
f0106bcd:	ff 75 e4             	pushl  -0x1c(%ebp)
f0106bd0:	53                   	push   %ebx
f0106bd1:	68 c0 9c 10 f0       	push   $0xf0109cc0
f0106bd6:	e8 c8 d0 ff ff       	call   f0103ca3 <cprintf>
f0106bdb:	83 c4 20             	add    $0x20,%esp
f0106bde:	eb b5                	jmp    f0106b95 <pci_attach_match+0xe>
					"%x.%x (%p): e\n",
					key1, key2, list[i].attachfn, r);
		}
	}
	return 0;
}
f0106be0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106be3:	5b                   	pop    %ebx
f0106be4:	5e                   	pop    %esi
f0106be5:	5f                   	pop    %edi
f0106be6:	5d                   	pop    %ebp
f0106be7:	c3                   	ret    

f0106be8 <pci_scan_bus>:
		PCI_INTERFACE(f->dev_class), desc);
}

static int
pci_scan_bus(struct pci_bus *bus)
{
f0106be8:	55                   	push   %ebp
f0106be9:	89 e5                	mov    %esp,%ebp
f0106beb:	57                   	push   %edi
f0106bec:	56                   	push   %esi
f0106bed:	53                   	push   %ebx
f0106bee:	81 ec fc 00 00 00    	sub    $0xfc,%esp
f0106bf4:	89 c2                	mov    %eax,%edx
	int totaldev = 0;
	struct pci_func df = { .bus = bus };
f0106bf6:	8d 7d a0             	lea    -0x60(%ebp),%edi
f0106bf9:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106bfe:	b8 00 00 00 00       	mov    $0x0,%eax
f0106c03:	f3 ab                	rep stos %eax,%es:(%edi)
f0106c05:	89 55 a0             	mov    %edx,-0x60(%ebp)
	int totaldev = 0;
f0106c08:	c7 85 00 ff ff ff 00 	movl   $0x0,-0x100(%ebp)
f0106c0f:	00 00 00 

	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106c12:	e9 22 01 00 00       	jmp    f0106d39 <pci_scan_bus+0x151>
		desc = "Unknown";
f0106c17:	be bb 9b 10 f0       	mov    $0xf0109bbb,%esi
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106c1c:	8b 95 64 ff ff ff    	mov    -0x9c(%ebp),%edx
	cprintf("PCI: %02x:%02x.%d %04x:%04x %02x.%02x.%02x %s\n",
f0106c22:	83 ec 08             	sub    $0x8,%esp
f0106c25:	56                   	push   %esi
f0106c26:	0f b6 f4             	movzbl %ah,%esi
f0106c29:	56                   	push   %esi
		PCI_CLASS(f->dev_class), PCI_SUBCLASS(f->dev_class),
f0106c2a:	c1 e8 10             	shr    $0x10,%eax
	cprintf("PCI: %02x:%02x.%d %04x:%04x %02x.%02x.%02x %s\n",
f0106c2d:	0f b6 c0             	movzbl %al,%eax
f0106c30:	50                   	push   %eax
f0106c31:	51                   	push   %ecx
f0106c32:	89 d0                	mov    %edx,%eax
f0106c34:	c1 e8 10             	shr    $0x10,%eax
f0106c37:	50                   	push   %eax
f0106c38:	0f b7 d2             	movzwl %dx,%edx
f0106c3b:	52                   	push   %edx
f0106c3c:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
f0106c42:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
f0106c48:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
f0106c4e:	ff 70 04             	pushl  0x4(%eax)
f0106c51:	68 ec 9c 10 f0       	push   $0xf0109cec
f0106c56:	e8 48 d0 ff ff       	call   f0103ca3 <cprintf>
		pci_attach_match(PCI_CLASS(f->dev_class),
f0106c5b:	83 c4 30             	add    $0x30,%esp
f0106c5e:	53                   	push   %ebx
f0106c5f:	68 a0 b4 12 f0       	push   $0xf012b4a0
f0106c64:	0f b6 85 6a ff ff ff 	movzbl -0x96(%ebp),%eax
f0106c6b:	50                   	push   %eax
f0106c6c:	0f b6 85 6b ff ff ff 	movzbl -0x95(%ebp),%eax
f0106c73:	50                   	push   %eax
f0106c74:	e8 0e ff ff ff       	call   f0106b87 <pci_attach_match>
				 &pci_attach_class[0], f) ||
f0106c79:	83 c4 10             	add    $0x10,%esp
f0106c7c:	85 c0                	test   %eax,%eax
f0106c7e:	0f 84 8f 00 00 00    	je     f0106d13 <pci_scan_bus+0x12b>

		totaldev++;

		struct pci_func f = df;
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
		     f.func++) {
f0106c84:	ff 85 18 ff ff ff    	incl   -0xe8(%ebp)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106c8a:	8b 85 04 ff ff ff    	mov    -0xfc(%ebp),%eax
f0106c90:	3b 85 18 ff ff ff    	cmp    -0xe8(%ebp),%eax
f0106c96:	0f 86 9a 00 00 00    	jbe    f0106d36 <pci_scan_bus+0x14e>
			struct pci_func af = f;
f0106c9c:	8d bd 58 ff ff ff    	lea    -0xa8(%ebp),%edi
f0106ca2:	8d b5 10 ff ff ff    	lea    -0xf0(%ebp),%esi
f0106ca8:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106cad:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

			af.dev_id = pci_conf_read(&f, PCI_ID_REG);
f0106caf:	ba 00 00 00 00       	mov    $0x0,%edx
f0106cb4:	8d 85 10 ff ff ff    	lea    -0xf0(%ebp),%eax
f0106cba:	e8 74 fe ff ff       	call   f0106b33 <pci_conf_read>
f0106cbf:	89 85 64 ff ff ff    	mov    %eax,-0x9c(%ebp)
			if (PCI_VENDOR(af.dev_id) == 0xffff)
f0106cc5:	66 83 f8 ff          	cmp    $0xffff,%ax
f0106cc9:	74 b9                	je     f0106c84 <pci_scan_bus+0x9c>
				continue;

			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106ccb:	ba 3c 00 00 00       	mov    $0x3c,%edx
f0106cd0:	89 d8                	mov    %ebx,%eax
f0106cd2:	e8 5c fe ff ff       	call   f0106b33 <pci_conf_read>
			af.irq_line = PCI_INTERRUPT_LINE(intr);
f0106cd7:	88 45 9c             	mov    %al,-0x64(%ebp)

			af.dev_class = pci_conf_read(&af, PCI_CLASS_REG);
f0106cda:	ba 08 00 00 00       	mov    $0x8,%edx
f0106cdf:	89 d8                	mov    %ebx,%eax
f0106ce1:	e8 4d fe ff ff       	call   f0106b33 <pci_conf_read>
f0106ce6:	89 85 68 ff ff ff    	mov    %eax,-0x98(%ebp)
	if (PCI_CLASS(f->dev_class) < ARRAY_SIZE(pci_class))
f0106cec:	89 c1                	mov    %eax,%ecx
f0106cee:	c1 e9 18             	shr    $0x18,%ecx
f0106cf1:	83 f9 0d             	cmp    $0xd,%ecx
f0106cf4:	0f 87 1d ff ff ff    	ja     f0106c17 <pci_scan_bus+0x2f>
		desc = pci_class[PCI_CLASS(f->dev_class)];
f0106cfa:	8b 34 8d e0 9d 10 f0 	mov    -0xfef6220(,%ecx,4),%esi
	if (!desc)
f0106d01:	85 f6                	test   %esi,%esi
f0106d03:	0f 85 13 ff ff ff    	jne    f0106c1c <pci_scan_bus+0x34>
		desc = "Unknown";
f0106d09:	be bb 9b 10 f0       	mov    $0xf0109bbb,%esi
f0106d0e:	e9 09 ff ff ff       	jmp    f0106c1c <pci_scan_bus+0x34>
				 PCI_PRODUCT(f->dev_id),
f0106d13:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
		pci_attach_match(PCI_VENDOR(f->dev_id),
f0106d19:	53                   	push   %ebx
f0106d1a:	68 18 6f 2c f0       	push   $0xf02c6f18
f0106d1f:	89 c2                	mov    %eax,%edx
f0106d21:	c1 ea 10             	shr    $0x10,%edx
f0106d24:	52                   	push   %edx
f0106d25:	0f b7 c0             	movzwl %ax,%eax
f0106d28:	50                   	push   %eax
f0106d29:	e8 59 fe ff ff       	call   f0106b87 <pci_attach_match>
f0106d2e:	83 c4 10             	add    $0x10,%esp
f0106d31:	e9 4e ff ff ff       	jmp    f0106c84 <pci_scan_bus+0x9c>
	for (df.dev = 0; df.dev < 32; df.dev++) {
f0106d36:	ff 45 a4             	incl   -0x5c(%ebp)
f0106d39:	83 7d a4 1f          	cmpl   $0x1f,-0x5c(%ebp)
f0106d3d:	77 5b                	ja     f0106d9a <pci_scan_bus+0x1b2>
		uint32_t bhlc = pci_conf_read(&df, PCI_BHLC_REG);
f0106d3f:	ba 0c 00 00 00       	mov    $0xc,%edx
f0106d44:	8d 45 a0             	lea    -0x60(%ebp),%eax
f0106d47:	e8 e7 fd ff ff       	call   f0106b33 <pci_conf_read>
		if (PCI_HDRTYPE_TYPE(bhlc) > 1)	    // Unsupported or no device
f0106d4c:	89 c2                	mov    %eax,%edx
f0106d4e:	c1 ea 10             	shr    $0x10,%edx
f0106d51:	83 e2 7f             	and    $0x7f,%edx
f0106d54:	83 fa 01             	cmp    $0x1,%edx
f0106d57:	77 dd                	ja     f0106d36 <pci_scan_bus+0x14e>
		totaldev++;
f0106d59:	ff 85 00 ff ff ff    	incl   -0x100(%ebp)
		struct pci_func f = df;
f0106d5f:	8d bd 10 ff ff ff    	lea    -0xf0(%ebp),%edi
f0106d65:	8d 75 a0             	lea    -0x60(%ebp),%esi
f0106d68:	b9 12 00 00 00       	mov    $0x12,%ecx
f0106d6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106d6f:	c7 85 18 ff ff ff 00 	movl   $0x0,-0xe8(%ebp)
f0106d76:	00 00 00 
f0106d79:	25 00 00 80 00       	and    $0x800000,%eax
f0106d7e:	83 f8 01             	cmp    $0x1,%eax
f0106d81:	19 c0                	sbb    %eax,%eax
f0106d83:	83 e0 f9             	and    $0xfffffff9,%eax
f0106d86:	83 c0 08             	add    $0x8,%eax
f0106d89:	89 85 04 ff ff ff    	mov    %eax,-0xfc(%ebp)
			uint32_t intr = pci_conf_read(&af, PCI_INTERRUPT_REG);
f0106d8f:	8d 9d 58 ff ff ff    	lea    -0xa8(%ebp),%ebx
		for (f.func = 0; f.func < (PCI_HDRTYPE_MULTIFN(bhlc) ? 8 : 1);
f0106d95:	e9 f0 fe ff ff       	jmp    f0106c8a <pci_scan_bus+0xa2>
			pci_attach(&af);
		}
	}

	return totaldev;
}
f0106d9a:	8b 85 00 ff ff ff    	mov    -0x100(%ebp),%eax
f0106da0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106da3:	5b                   	pop    %ebx
f0106da4:	5e                   	pop    %esi
f0106da5:	5f                   	pop    %edi
f0106da6:	5d                   	pop    %ebp
f0106da7:	c3                   	ret    

f0106da8 <pci_bridge_attach>:
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
}

static int
pci_bridge_attach(struct pci_func *pcif)
{
f0106da8:	55                   	push   %ebp
f0106da9:	89 e5                	mov    %esp,%ebp
f0106dab:	56                   	push   %esi
f0106dac:	53                   	push   %ebx
f0106dad:	83 ec 10             	sub    $0x10,%esp
f0106db0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t ioreg  = pci_conf_read(pcif, PCI_BRIDGE_STATIO_REG);
f0106db3:	ba 1c 00 00 00       	mov    $0x1c,%edx
f0106db8:	89 d8                	mov    %ebx,%eax
f0106dba:	e8 74 fd ff ff       	call   f0106b33 <pci_conf_read>
f0106dbf:	89 c6                	mov    %eax,%esi
	uint32_t busreg = pci_conf_read(pcif, PCI_BRIDGE_BUS_REG);
f0106dc1:	ba 18 00 00 00       	mov    $0x18,%edx
f0106dc6:	89 d8                	mov    %ebx,%eax
f0106dc8:	e8 66 fd ff ff       	call   f0106b33 <pci_conf_read>

	if (PCI_BRIDGE_IO_32BITS(ioreg)) {
f0106dcd:	83 e6 0f             	and    $0xf,%esi
f0106dd0:	83 fe 01             	cmp    $0x1,%esi
f0106dd3:	74 35                	je     f0106e0a <pci_bridge_attach+0x62>
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
			pcif->bus->busno, pcif->dev, pcif->func);
		return 0;
	}

	struct pci_bus nbus = {
f0106dd5:	89 5d f0             	mov    %ebx,-0x10(%ebp)
		.parent_bridge = pcif,
		.busno = (busreg >> PCI_BRIDGE_BUS_SECONDARY_SHIFT) & 0xff,
f0106dd8:	0f b6 d4             	movzbl %ah,%edx
	struct pci_bus nbus = {
f0106ddb:	89 55 f4             	mov    %edx,-0xc(%ebp)
	};

	if (pci_show_devs)
		cprintf("  bridge to [bus %02x-%02x]\n",
f0106dde:	83 ec 04             	sub    $0x4,%esp
			nbus.busno, (busreg >> PCI_BRIDGE_BUS_SUBORDINATE_SHIFT) & 0xff);
f0106de1:	c1 e8 10             	shr    $0x10,%eax
		cprintf("  bridge to [bus %02x-%02x]\n",
f0106de4:	0f b6 c0             	movzbl %al,%eax
f0106de7:	50                   	push   %eax
f0106de8:	52                   	push   %edx
f0106de9:	68 c3 9b 10 f0       	push   $0xf0109bc3
f0106dee:	e8 b0 ce ff ff       	call   f0103ca3 <cprintf>

	pci_scan_bus(&nbus);
f0106df3:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0106df6:	e8 ed fd ff ff       	call   f0106be8 <pci_scan_bus>
	return 1;
f0106dfb:	83 c4 10             	add    $0x10,%esp
f0106dfe:	b8 01 00 00 00       	mov    $0x1,%eax
}
f0106e03:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0106e06:	5b                   	pop    %ebx
f0106e07:	5e                   	pop    %esi
f0106e08:	5d                   	pop    %ebp
f0106e09:	c3                   	ret    
		cprintf("PCI: %02x:%02x.%d: 32-bit bridge IO not supported.\n",
f0106e0a:	ff 73 08             	pushl  0x8(%ebx)
f0106e0d:	ff 73 04             	pushl  0x4(%ebx)
f0106e10:	8b 03                	mov    (%ebx),%eax
f0106e12:	ff 70 04             	pushl  0x4(%eax)
f0106e15:	68 1c 9d 10 f0       	push   $0xf0109d1c
f0106e1a:	e8 84 ce ff ff       	call   f0103ca3 <cprintf>
		return 0;
f0106e1f:	83 c4 10             	add    $0x10,%esp
f0106e22:	b8 00 00 00 00       	mov    $0x0,%eax
f0106e27:	eb da                	jmp    f0106e03 <pci_bridge_attach+0x5b>

f0106e29 <pci_init>:
{
f0106e29:	55                   	push   %ebp
f0106e2a:	89 e5                	mov    %esp,%ebp
f0106e2c:	83 ec 18             	sub    $0x18,%esp
	struct pci_bus root_bus = { NULL, 0 };
f0106e2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
f0106e36:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	return pci_scan_bus(&root_bus);
f0106e3d:	8d 45 f0             	lea    -0x10(%ebp),%eax
f0106e40:	e8 a3 fd ff ff       	call   f0106be8 <pci_scan_bus>
}
f0106e45:	c9                   	leave  
f0106e46:	c3                   	ret    

f0106e47 <pci_func_enable>:
{
f0106e47:	55                   	push   %ebp
f0106e48:	89 e5                	mov    %esp,%ebp
f0106e4a:	57                   	push   %edi
f0106e4b:	56                   	push   %esi
f0106e4c:	53                   	push   %ebx
f0106e4d:	83 ec 2c             	sub    $0x2c,%esp
f0106e50:	8b 75 08             	mov    0x8(%ebp),%esi
	pci_conf_write(f, PCI_COMMAND_STATUS_REG,
f0106e53:	b9 07 00 00 00       	mov    $0x7,%ecx
f0106e58:	ba 04 00 00 00       	mov    $0x4,%edx
f0106e5d:	89 f0                	mov    %esi,%eax
f0106e5f:	e8 f4 fc ff ff       	call   f0106b58 <pci_conf_write>
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END; bar += bar_width) {
f0106e64:	bf 10 00 00 00       	mov    $0x10,%edi
f0106e69:	eb 47                	jmp    f0106eb2 <pci_func_enable+0x6b>
			size = PCI_MAPREG_IO_SIZE(rv);
f0106e6b:	83 e0 fc             	and    $0xfffffffc,%eax
f0106e6e:	89 c2                	mov    %eax,%edx
f0106e70:	f7 da                	neg    %edx
f0106e72:	21 c2                	and    %eax,%edx
f0106e74:	89 55 dc             	mov    %edx,-0x24(%ebp)
			base = PCI_MAPREG_IO_ADDR(oldv);
f0106e77:	8b 5d e0             	mov    -0x20(%ebp),%ebx
f0106e7a:	83 e3 fc             	and    $0xfffffffc,%ebx
				cprintf("  BAR %d [port %04p-%04p]\n",
f0106e7d:	8d 44 13 ff          	lea    -0x1(%ebx,%edx,1),%eax
f0106e81:	50                   	push   %eax
f0106e82:	53                   	push   %ebx
f0106e83:	ff 75 d8             	pushl  -0x28(%ebp)
f0106e86:	68 fa 9b 10 f0       	push   $0xf0109bfa
f0106e8b:	e8 13 ce ff ff       	call   f0103ca3 <cprintf>
f0106e90:	83 c4 10             	add    $0x10,%esp
		bar_width = 4;
f0106e93:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
f0106e9a:	e9 89 00 00 00       	jmp    f0106f28 <pci_func_enable+0xe1>
f0106e9f:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	for (bar = PCI_MAPREG_START; bar < PCI_MAPREG_END; bar += bar_width) {
f0106ea6:	03 7d e4             	add    -0x1c(%ebp),%edi
f0106ea9:	83 ff 27             	cmp    $0x27,%edi
f0106eac:	0f 87 d6 00 00 00    	ja     f0106f88 <pci_func_enable+0x141>
		uint32_t oldv = pci_conf_read(f, bar);
f0106eb2:	89 fa                	mov    %edi,%edx
f0106eb4:	89 f0                	mov    %esi,%eax
f0106eb6:	e8 78 fc ff ff       	call   f0106b33 <pci_conf_read>
f0106ebb:	89 c3                	mov    %eax,%ebx
f0106ebd:	89 45 e0             	mov    %eax,-0x20(%ebp)
		pci_conf_write(f, bar, 0xffffffff);
f0106ec0:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
f0106ec5:	89 fa                	mov    %edi,%edx
f0106ec7:	89 f0                	mov    %esi,%eax
f0106ec9:	e8 8a fc ff ff       	call   f0106b58 <pci_conf_write>
		uint32_t rv = pci_conf_read(f, bar);
f0106ece:	89 fa                	mov    %edi,%edx
f0106ed0:	89 f0                	mov    %esi,%eax
f0106ed2:	e8 5c fc ff ff       	call   f0106b33 <pci_conf_read>
		if (rv == 0)
f0106ed7:	85 c0                	test   %eax,%eax
f0106ed9:	74 c4                	je     f0106e9f <pci_func_enable+0x58>
		int regnum = PCI_MAPREG_NUM(bar);
f0106edb:	8d 4f f0             	lea    -0x10(%edi),%ecx
f0106ede:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
f0106ee1:	c1 e9 02             	shr    $0x2,%ecx
f0106ee4:	89 4d d8             	mov    %ecx,-0x28(%ebp)
		if (PCI_MAPREG_TYPE(rv) == PCI_MAPREG_TYPE_MEM) {
f0106ee7:	a8 01                	test   $0x1,%al
f0106ee9:	75 80                	jne    f0106e6b <pci_func_enable+0x24>
			if (PCI_MAPREG_MEM_TYPE(rv) == PCI_MAPREG_MEM_TYPE_64BIT)
f0106eeb:	89 c2                	mov    %eax,%edx
f0106eed:	83 e2 06             	and    $0x6,%edx
				bar_width = 8;
f0106ef0:	83 fa 04             	cmp    $0x4,%edx
f0106ef3:	0f 94 c1             	sete   %cl
f0106ef6:	0f b6 c9             	movzbl %cl,%ecx
f0106ef9:	8d 14 8d 04 00 00 00 	lea    0x4(,%ecx,4),%edx
f0106f00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
			size = PCI_MAPREG_MEM_SIZE(rv);
f0106f03:	83 e0 f0             	and    $0xfffffff0,%eax
f0106f06:	89 c2                	mov    %eax,%edx
f0106f08:	f7 da                	neg    %edx
f0106f0a:	21 c2                	and    %eax,%edx
f0106f0c:	89 55 dc             	mov    %edx,-0x24(%ebp)
			base = PCI_MAPREG_MEM_ADDR(oldv);
f0106f0f:	83 e3 f0             	and    $0xfffffff0,%ebx
				cprintf("  BAR %d [mem %08p-%08p]\n",
f0106f12:	8d 44 13 ff          	lea    -0x1(%ebx,%edx,1),%eax
f0106f16:	50                   	push   %eax
f0106f17:	53                   	push   %ebx
f0106f18:	ff 75 d8             	pushl  -0x28(%ebp)
f0106f1b:	68 e0 9b 10 f0       	push   $0xf0109be0
f0106f20:	e8 7e cd ff ff       	call   f0103ca3 <cprintf>
f0106f25:	83 c4 10             	add    $0x10,%esp
		pci_conf_write(f, bar, oldv);
f0106f28:	8b 4d e0             	mov    -0x20(%ebp),%ecx
f0106f2b:	89 fa                	mov    %edi,%edx
f0106f2d:	89 f0                	mov    %esi,%eax
f0106f2f:	e8 24 fc ff ff       	call   f0106b58 <pci_conf_write>
f0106f34:	8b 45 d4             	mov    -0x2c(%ebp),%eax
f0106f37:	83 e0 fc             	and    $0xfffffffc,%eax
f0106f3a:	01 f0                	add    %esi,%eax
		f->reg_base[regnum] = base;
f0106f3c:	89 58 14             	mov    %ebx,0x14(%eax)
		f->reg_size[regnum] = size;
f0106f3f:	8b 55 dc             	mov    -0x24(%ebp),%edx
f0106f42:	89 50 2c             	mov    %edx,0x2c(%eax)
		if (size && !base)
f0106f45:	85 d2                	test   %edx,%edx
f0106f47:	0f 84 59 ff ff ff    	je     f0106ea6 <pci_func_enable+0x5f>
f0106f4d:	85 db                	test   %ebx,%ebx
f0106f4f:	0f 85 51 ff ff ff    	jne    f0106ea6 <pci_func_enable+0x5f>
				PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id),
f0106f55:	8b 46 0c             	mov    0xc(%esi),%eax
			cprintf("PCI device %02x:%02x.%d (%04x:%04x) "
f0106f58:	83 ec 0c             	sub    $0xc,%esp
f0106f5b:	52                   	push   %edx
f0106f5c:	6a 00                	push   $0x0
f0106f5e:	ff 75 d8             	pushl  -0x28(%ebp)
f0106f61:	89 c2                	mov    %eax,%edx
f0106f63:	c1 ea 10             	shr    $0x10,%edx
f0106f66:	52                   	push   %edx
f0106f67:	0f b7 c0             	movzwl %ax,%eax
f0106f6a:	50                   	push   %eax
f0106f6b:	ff 76 08             	pushl  0x8(%esi)
f0106f6e:	ff 76 04             	pushl  0x4(%esi)
f0106f71:	8b 06                	mov    (%esi),%eax
f0106f73:	ff 70 04             	pushl  0x4(%eax)
f0106f76:	68 50 9d 10 f0       	push   $0xf0109d50
f0106f7b:	e8 23 cd ff ff       	call   f0103ca3 <cprintf>
f0106f80:	83 c4 30             	add    $0x30,%esp
f0106f83:	e9 1e ff ff ff       	jmp    f0106ea6 <pci_func_enable+0x5f>
		PCI_VENDOR(f->dev_id), PCI_PRODUCT(f->dev_id));
f0106f88:	8b 46 0c             	mov    0xc(%esi),%eax
	cprintf("PCI function %02x:%02x.%d (%04x:%04x) enabled\n",
f0106f8b:	83 ec 08             	sub    $0x8,%esp
f0106f8e:	89 c2                	mov    %eax,%edx
f0106f90:	c1 ea 10             	shr    $0x10,%edx
f0106f93:	52                   	push   %edx
f0106f94:	0f b7 c0             	movzwl %ax,%eax
f0106f97:	50                   	push   %eax
f0106f98:	ff 76 08             	pushl  0x8(%esi)
f0106f9b:	ff 76 04             	pushl  0x4(%esi)
f0106f9e:	8b 06                	mov    (%esi),%eax
f0106fa0:	ff 70 04             	pushl  0x4(%eax)
f0106fa3:	68 ac 9d 10 f0       	push   $0xf0109dac
f0106fa8:	e8 f6 cc ff ff       	call   f0103ca3 <cprintf>
}
f0106fad:	83 c4 20             	add    $0x20,%esp
f0106fb0:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0106fb3:	5b                   	pop    %ebx
f0106fb4:	5e                   	pop    %esi
f0106fb5:	5f                   	pop    %edi
f0106fb6:	5d                   	pop    %ebp
f0106fb7:	c3                   	ret    

f0106fb8 <nvme_queue_submit>:
	q->cq_hdbl = base + NVME_CQHDBL(id, dstrd);
}

static int
nvme_queue_submit(struct nvme_queue *q, void *cmd)
{
f0106fb8:	55                   	push   %ebp
f0106fb9:	89 e5                	mov    %esp,%ebp
f0106fbb:	56                   	push   %esi
f0106fbc:	53                   	push   %ebx
f0106fbd:	89 c6                	mov    %eax,%esi
	struct nvme_sqe *sqe = q->sq_va;
	volatile struct nvme_cqe *cqe = q->cq_va;

	sqe += q->sq_tail;
	cqe += q->cq_head;
f0106fbf:	8b 58 1c             	mov    0x1c(%eax),%ebx
f0106fc2:	c1 e3 04             	shl    $0x4,%ebx
f0106fc5:	03 58 14             	add    0x14(%eax),%ebx

	// Copy to SQ
	memcpy(sqe, cmd, sizeof(struct nvme_sqe));
f0106fc8:	83 ec 04             	sub    $0x4,%esp
f0106fcb:	6a 40                	push   $0x40
f0106fcd:	52                   	push   %edx
	sqe += q->sq_tail;
f0106fce:	8b 40 10             	mov    0x10(%eax),%eax
f0106fd1:	c1 e0 06             	shl    $0x6,%eax
f0106fd4:	03 46 08             	add    0x8(%esi),%eax
	memcpy(sqe, cmd, sizeof(struct nvme_sqe));
f0106fd7:	50                   	push   %eax
f0106fd8:	e8 f3 ed ff ff       	call   f0105dd0 <memcpy>

	// Bump the SQ tail pointer
	++q->sq_tail;
f0106fdd:	8b 46 10             	mov    0x10(%esi),%eax
f0106fe0:	40                   	inc    %eax
f0106fe1:	89 46 10             	mov    %eax,0x10(%esi)
	if (q->sq_tail == q->size)
f0106fe4:	83 c4 10             	add    $0x10,%esp
f0106fe7:	3b 46 04             	cmp    0x4(%esi),%eax
f0106fea:	74 3f                	je     f010702b <nvme_queue_submit+0x73>
		q->sq_tail = 0;

	// Ring the SQ doorbell
	mmio_write32(q->sq_tdbl, q->sq_tail);
f0106fec:	8b 56 10             	mov    0x10(%esi),%edx
f0106fef:	8b 46 0c             	mov    0xc(%esi),%eax
	*(volatile uint32_t *)addr = v;
f0106ff2:	89 10                	mov    %edx,(%eax)

	// Wait for CQ
	while ((cqe->flags & NVME_CQE_PHASE) == q->cq_phase)
f0106ff4:	8b 56 20             	mov    0x20(%esi),%edx
f0106ff7:	66 8b 43 0e          	mov    0xe(%ebx),%ax
f0106ffb:	83 e0 01             	and    $0x1,%eax
f0106ffe:	66 39 c2             	cmp    %ax,%dx
f0107001:	74 f4                	je     f0106ff7 <nvme_queue_submit+0x3f>
		;
	assert(NVME_CQE_SC(cqe->flags) == NVME_CQE_SC_SUCCESS);
f0107003:	66 8b 43 0e          	mov    0xe(%ebx),%ax
f0107007:	a8 fe                	test   $0xfe,%al
f0107009:	75 29                	jne    f0107034 <nvme_queue_submit+0x7c>

	// Bump the CQ head pointer
	++q->cq_head;
f010700b:	8b 46 1c             	mov    0x1c(%esi),%eax
f010700e:	40                   	inc    %eax
f010700f:	89 46 1c             	mov    %eax,0x1c(%esi)
	if (q->cq_head == q->size) {
f0107012:	3b 46 04             	cmp    0x4(%esi),%eax
f0107015:	74 33                	je     f010704a <nvme_queue_submit+0x92>
		q->cq_head = 0;
		q->cq_phase ^= NVME_CQE_PHASE;
	}

	// Ring the CQ doorbell
	mmio_write32(q->cq_hdbl, q->cq_head);
f0107017:	8b 56 1c             	mov    0x1c(%esi),%edx
f010701a:	8b 46 18             	mov    0x18(%esi),%eax
f010701d:	89 10                	mov    %edx,(%eax)

	return 0;
}
f010701f:	b8 00 00 00 00       	mov    $0x0,%eax
f0107024:	8d 65 f8             	lea    -0x8(%ebp),%esp
f0107027:	5b                   	pop    %ebx
f0107028:	5e                   	pop    %esi
f0107029:	5d                   	pop    %ebp
f010702a:	c3                   	ret    
		q->sq_tail = 0;
f010702b:	c7 46 10 00 00 00 00 	movl   $0x0,0x10(%esi)
f0107032:	eb b8                	jmp    f0106fec <nvme_queue_submit+0x34>
	assert(NVME_CQE_SC(cqe->flags) == NVME_CQE_SC_SUCCESS);
f0107034:	68 18 9e 10 f0       	push   $0xf0109e18
f0107039:	68 31 78 10 f0       	push   $0xf0107831
f010703e:	6a 50                	push   $0x50
f0107040:	68 88 9e 10 f0       	push   $0xf0109e88
f0107045:	e8 f9 8f ff ff       	call   f0100043 <_panic>
		q->cq_head = 0;
f010704a:	c7 46 1c 00 00 00 00 	movl   $0x0,0x1c(%esi)
		q->cq_phase ^= NVME_CQE_PHASE;
f0107051:	83 f2 01             	xor    $0x1,%edx
f0107054:	66 89 56 20          	mov    %dx,0x20(%esi)
f0107058:	eb bd                	jmp    f0107017 <nvme_queue_submit+0x5f>

f010705a <nvme_rw>:
	return page2pa(pp) + PGOFF(va);
}

static int
nvme_rw(uint8_t opcode, uint64_t secno, void *buf, uint16_t nsecs)
{
f010705a:	55                   	push   %ebp
f010705b:	89 e5                	mov    %esp,%ebp
f010705d:	57                   	push   %edi
f010705e:	56                   	push   %esi
f010705f:	53                   	push   %ebx
f0107060:	83 ec 5c             	sub    $0x5c,%esp
f0107063:	89 c6                	mov    %eax,%esi
f0107065:	89 55 a0             	mov    %edx,-0x60(%ebp)
f0107068:	89 4d a4             	mov    %ecx,-0x5c(%ebp)
f010706b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct PageInfo *pp;
	struct nvme_sqe_io cmd = {
f010706e:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0107071:	b9 10 00 00 00       	mov    $0x10,%ecx
f0107076:	b8 00 00 00 00       	mov    $0x0,%eax
f010707b:	f3 ab                	rep stos %eax,%es:(%edi)
f010707d:	89 f0                	mov    %esi,%eax
f010707f:	88 45 a8             	mov    %al,-0x58(%ebp)
f0107082:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
	pp = page_lookup(curenv->env_pgdir, va, NULL);
f0107089:	e8 9a f3 ff ff       	call   f0106428 <cpunum>
f010708e:	83 ec 04             	sub    $0x4,%esp
f0107091:	6a 00                	push   $0x0
f0107093:	ff 75 08             	pushl  0x8(%ebp)
f0107096:	8d 14 00             	lea    (%eax,%eax,1),%edx
f0107099:	01 c2                	add    %eax,%edx
f010709b:	01 d2                	add    %edx,%edx
f010709d:	01 c2                	add    %eax,%edx
f010709f:	8d 04 90             	lea    (%eax,%edx,4),%eax
f01070a2:	8b 04 85 08 80 2c f0 	mov    -0xfd37ff8(,%eax,4),%eax
f01070a9:	ff 70 60             	pushl  0x60(%eax)
f01070ac:	e8 f2 a3 ff ff       	call   f01014a3 <page_lookup>
	assert(pp);
f01070b1:	83 c4 10             	add    $0x10,%esp
f01070b4:	85 c0                	test   %eax,%eax
f01070b6:	74 5f                	je     f0107117 <nvme_rw+0xbd>
	return page2pa(pp) + PGOFF(va);
f01070b8:	8b 55 08             	mov    0x8(%ebp),%edx
f01070bb:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
	return (pp - pages) << PGSHIFT;
f01070c1:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01070c7:	c1 f8 03             	sar    $0x3,%eax
f01070ca:	c1 e0 0c             	shl    $0xc,%eax
f01070cd:	01 d0                	add    %edx,%eax
		.opcode = opcode,
		.nsid = 1,
		.slba = secno,
		.nlb = nsecs - 1,
		.entry.prp[0] = va2pa(buf),
f01070cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
f01070d2:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	struct nvme_sqe_io cmd = {
f01070d9:	8b 75 a0             	mov    -0x60(%ebp),%esi
f01070dc:	8b 7d a4             	mov    -0x5c(%ebp),%edi
f01070df:	89 75 d0             	mov    %esi,-0x30(%ebp)
f01070e2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
		.nlb = nsecs - 1,
f01070e5:	8d 43 ff             	lea    -0x1(%ebx),%eax
f01070e8:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
	};

	static_assert(sizeof(struct nvme_sqe_io) == sizeof(struct nvme_sqe));
	if (!ioq.sq_va)
f01070ec:	83 3d 48 6f 2c f0 00 	cmpl   $0x0,0xf02c6f48
f01070f3:	74 3b                	je     f0107130 <nvme_rw+0xd6>
		return -E_INVAL;
	// buf must be page aligned
	if (PGOFF(buf))
f01070f5:	85 d2                	test   %edx,%edx
f01070f7:	75 3e                	jne    f0107137 <nvme_rw+0xdd>
		return -E_INVAL;
	// support one page for now
	if (nsecs > BLKSECTS)
f01070f9:	66 83 fb 08          	cmp    $0x8,%bx
f01070fd:	77 3f                	ja     f010713e <nvme_rw+0xe4>
		return -E_INVAL;

	nvme_queue_submit(&ioq, &cmd);
f01070ff:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0107102:	b8 40 6f 2c f0       	mov    $0xf02c6f40,%eax
f0107107:	e8 ac fe ff ff       	call   f0106fb8 <nvme_queue_submit>
	return nsecs;
f010710c:	0f b7 c3             	movzwl %bx,%eax
}
f010710f:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107112:	5b                   	pop    %ebx
f0107113:	5e                   	pop    %esi
f0107114:	5f                   	pop    %edi
f0107115:	5d                   	pop    %ebp
f0107116:	c3                   	ret    
	assert(pp);
f0107117:	68 df 89 10 f0       	push   $0xf01089df
f010711c:	68 31 78 10 f0       	push   $0xf0107831
f0107121:	68 af 00 00 00       	push   $0xaf
f0107126:	68 88 9e 10 f0       	push   $0xf0109e88
f010712b:	e8 13 8f ff ff       	call   f0100043 <_panic>
		return -E_INVAL;
f0107130:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0107135:	eb d8                	jmp    f010710f <nvme_rw+0xb5>
		return -E_INVAL;
f0107137:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f010713c:	eb d1                	jmp    f010710f <nvme_rw+0xb5>
		return -E_INVAL;
f010713e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
f0107143:	eb ca                	jmp    f010710f <nvme_rw+0xb5>

f0107145 <nvme_queue_init>:
{
f0107145:	55                   	push   %ebp
f0107146:	89 e5                	mov    %esp,%ebp
f0107148:	57                   	push   %edi
f0107149:	56                   	push   %esi
f010714a:	53                   	push   %ebx
f010714b:	83 ec 10             	sub    $0x10,%esp
f010714e:	89 c3                	mov    %eax,%ebx
f0107150:	89 d7                	mov    %edx,%edi
f0107152:	89 ce                	mov    %ecx,%esi
	memset(q, 0, sizeof(*q));
f0107154:	6a 24                	push   $0x24
f0107156:	6a 00                	push   $0x0
f0107158:	50                   	push   %eax
f0107159:	e8 bf eb ff ff       	call   f0105d1d <memset>
	q->id = id;
f010715e:	66 89 33             	mov    %si,(%ebx)
	q->size = size;
f0107161:	8b 45 08             	mov    0x8(%ebp),%eax
f0107164:	89 43 04             	mov    %eax,0x4(%ebx)
	p = page_alloc(ALLOC_ZERO);
f0107167:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f010716e:	e8 02 a1 ff ff       	call   f0101275 <page_alloc>
	assert(p);
f0107173:	83 c4 10             	add    $0x10,%esp
f0107176:	85 c0                	test   %eax,%eax
f0107178:	0f 84 8f 00 00 00    	je     f010720d <nvme_queue_init+0xc8>
	p->pp_ref++;
f010717e:	66 ff 40 04          	incw   0x4(%eax)
f0107182:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f0107188:	c1 f8 03             	sar    $0x3,%eax
f010718b:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f010718e:	89 c2                	mov    %eax,%edx
f0107190:	c1 ea 0c             	shr    $0xc,%edx
f0107193:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f0107199:	0f 83 84 00 00 00    	jae    f0107223 <nvme_queue_init+0xde>
	return (void *)(pa + KERNBASE);
f010719f:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01071a4:	89 43 08             	mov    %eax,0x8(%ebx)
	q->sq_tdbl = base + NVME_SQTDBL(id, dstrd);
f01071a7:	0f b7 c6             	movzwl %si,%eax
f01071aa:	0f af 45 0c          	imul   0xc(%ebp),%eax
f01071ae:	8d 84 00 00 10 00 00 	lea    0x1000(%eax,%eax,1),%eax
f01071b5:	01 f8                	add    %edi,%eax
f01071b7:	89 43 0c             	mov    %eax,0xc(%ebx)
	p = page_alloc(ALLOC_ZERO);
f01071ba:	83 ec 0c             	sub    $0xc,%esp
f01071bd:	6a 01                	push   $0x1
f01071bf:	e8 b1 a0 ff ff       	call   f0101275 <page_alloc>
	assert(p);
f01071c4:	83 c4 10             	add    $0x10,%esp
f01071c7:	85 c0                	test   %eax,%eax
f01071c9:	74 6d                	je     f0107238 <nvme_queue_init+0xf3>
	p->pp_ref++;
f01071cb:	66 ff 40 04          	incw   0x4(%eax)
	return (pp - pages) << PGSHIFT;
f01071cf:	2b 05 d0 74 2c f0    	sub    0xf02c74d0,%eax
f01071d5:	c1 f8 03             	sar    $0x3,%eax
f01071d8:	c1 e0 0c             	shl    $0xc,%eax
	if (PGNUM(pa) >= npages)
f01071db:	89 c2                	mov    %eax,%edx
f01071dd:	c1 ea 0c             	shr    $0xc,%edx
f01071e0:	3b 15 c8 74 2c f0    	cmp    0xf02c74c8,%edx
f01071e6:	73 66                	jae    f010724e <nvme_queue_init+0x109>
	return (void *)(pa + KERNBASE);
f01071e8:	2d 00 00 00 10       	sub    $0x10000000,%eax
f01071ed:	89 43 14             	mov    %eax,0x14(%ebx)
	q->cq_hdbl = base + NVME_CQHDBL(id, dstrd);
f01071f0:	0f b7 f6             	movzwl %si,%esi
f01071f3:	8d 44 36 01          	lea    0x1(%esi,%esi,1),%eax
f01071f7:	0f af 45 0c          	imul   0xc(%ebp),%eax
f01071fb:	8d 84 07 00 10 00 00 	lea    0x1000(%edi,%eax,1),%eax
f0107202:	89 43 18             	mov    %eax,0x18(%ebx)
}
f0107205:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107208:	5b                   	pop    %ebx
f0107209:	5e                   	pop    %esi
f010720a:	5f                   	pop    %edi
f010720b:	5d                   	pop    %ebp
f010720c:	c3                   	ret    
	assert(p);
f010720d:	68 67 92 10 f0       	push   $0xf0109267
f0107212:	68 31 78 10 f0       	push   $0xf0107831
f0107217:	6a 2d                	push   $0x2d
f0107219:	68 88 9e 10 f0       	push   $0xf0109e88
f010721e:	e8 20 8e ff ff       	call   f0100043 <_panic>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0107223:	50                   	push   %eax
f0107224:	68 c8 77 10 f0       	push   $0xf01077c8
f0107229:	68 8e 00 00 00       	push   $0x8e
f010722e:	68 11 88 10 f0       	push   $0xf0108811
f0107233:	e8 0b 8e ff ff       	call   f0100043 <_panic>
	assert(p);
f0107238:	68 67 92 10 f0       	push   $0xf0109267
f010723d:	68 31 78 10 f0       	push   $0xf0107831
f0107242:	6a 33                	push   $0x33
f0107244:	68 88 9e 10 f0       	push   $0xf0109e88
f0107249:	e8 f5 8d ff ff       	call   f0100043 <_panic>
f010724e:	50                   	push   %eax
f010724f:	68 c8 77 10 f0       	push   $0xf01077c8
f0107254:	68 8e 00 00 00       	push   $0x8e
f0107259:	68 11 88 10 f0       	push   $0xf0108811
f010725e:	e8 e0 8d ff ff       	call   f0100043 <_panic>

f0107263 <nvme_attach>:
{
f0107263:	55                   	push   %ebp
f0107264:	89 e5                	mov    %esp,%ebp
f0107266:	57                   	push   %edi
f0107267:	56                   	push   %esi
f0107268:	53                   	push   %ebx
f0107269:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
f010726f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (PCI_INTERFACE(pcif->dev_class) != PCI_INTERFACE_NVM_NVME)
f0107272:	80 7b 11 02          	cmpb   $0x2,0x11(%ebx)
f0107276:	74 0d                	je     f0107285 <nvme_attach+0x22>
		return 0;
f0107278:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010727d:	8d 65 f4             	lea    -0xc(%ebp),%esp
f0107280:	5b                   	pop    %ebx
f0107281:	5e                   	pop    %esi
f0107282:	5f                   	pop    %edi
f0107283:	5d                   	pop    %ebp
f0107284:	c3                   	ret    
	pci_func_enable(pcif);
f0107285:	83 ec 0c             	sub    $0xc,%esp
f0107288:	53                   	push   %ebx
f0107289:	e8 b9 fb ff ff       	call   f0106e47 <pci_func_enable>
	base = mmio_map_region(pcif->reg_base[0], pcif->reg_size[0]);
f010728e:	83 c4 08             	add    $0x8,%esp
f0107291:	ff 73 2c             	pushl  0x2c(%ebx)
f0107294:	ff 73 14             	pushl  0x14(%ebx)
f0107297:	e8 73 a3 ff ff       	call   f010160f <mmio_map_region>
f010729c:	89 c3                	mov    %eax,%ebx
	return *(volatile uint32_t *)addr;
f010729e:	8b 00                	mov    (%eax),%eax
f01072a0:	8b 53 04             	mov    0x4(%ebx),%edx
	return lo + (hi << 32);
f01072a3:	be 00 00 00 00       	mov    $0x0,%esi
f01072a8:	89 d7                	mov    %edx,%edi
	lo = mmio_read32(addr);
f01072aa:	ba 00 00 00 00       	mov    $0x0,%edx
	return lo + (hi << 32);
f01072af:	01 c6                	add    %eax,%esi
f01072b1:	11 d7                	adc    %edx,%edi
	assert(NVME_CAP_MPSMIN(cap) <= PGSHIFT);
f01072b3:	89 f9                	mov    %edi,%ecx
f01072b5:	c1 e9 10             	shr    $0x10,%ecx
f01072b8:	83 e1 0f             	and    $0xf,%ecx
f01072bb:	89 c8                	mov    %ecx,%eax
f01072bd:	ba 00 00 00 00       	mov    $0x0,%edx
f01072c2:	83 c0 0c             	add    $0xc,%eax
f01072c5:	83 d2 00             	adc    $0x0,%edx
f01072c8:	83 c4 10             	add    $0x10,%esp
f01072cb:	83 fa 00             	cmp    $0x0,%edx
f01072ce:	77 05                	ja     f01072d5 <nvme_attach+0x72>
f01072d0:	83 f8 0c             	cmp    $0xc,%eax
f01072d3:	76 19                	jbe    f01072ee <nvme_attach+0x8b>
f01072d5:	68 48 9e 10 f0       	push   $0xf0109e48
f01072da:	68 31 78 10 f0       	push   $0xf0107831
f01072df:	68 87 00 00 00       	push   $0x87
f01072e4:	68 88 9e 10 f0       	push   $0xf0109e88
f01072e9:	e8 55 8d ff ff       	call   f0100043 <_panic>
	assert(NVME_CAP_MPSMAX(cap) >= PGSHIFT);
f01072ee:	89 f9                	mov    %edi,%ecx
f01072f0:	c1 e9 14             	shr    $0x14,%ecx
f01072f3:	83 e1 0f             	and    $0xf,%ecx
f01072f6:	89 c8                	mov    %ecx,%eax
f01072f8:	ba 00 00 00 00       	mov    $0x0,%edx
f01072fd:	83 c0 0c             	add    $0xc,%eax
f0107300:	83 d2 00             	adc    $0x0,%edx
f0107303:	83 fa 00             	cmp    $0x0,%edx
f0107306:	77 1e                	ja     f0107326 <nvme_attach+0xc3>
f0107308:	83 f8 0b             	cmp    $0xb,%eax
f010730b:	77 19                	ja     f0107326 <nvme_attach+0xc3>
f010730d:	68 68 9e 10 f0       	push   $0xf0109e68
f0107312:	68 31 78 10 f0       	push   $0xf0107831
f0107317:	68 88 00 00 00       	push   $0x88
f010731c:	68 88 9e 10 f0       	push   $0xf0109e88
f0107321:	e8 1d 8d ff ff       	call   f0100043 <_panic>
	dstrd = NVME_CAP_DSTRD(cap);
f0107326:	89 f9                	mov    %edi,%ecx
f0107328:	83 e1 0f             	and    $0xf,%ecx
f010732b:	83 c1 02             	add    $0x2,%ecx
f010732e:	be 01 00 00 00       	mov    $0x1,%esi
f0107333:	d3 e6                	shl    %cl,%esi
	return *(volatile uint32_t *)addr;
f0107335:	8b 7b 14             	mov    0x14(%ebx),%edi
	assert(!ISSET(cc, NVME_CC_EN));
f0107338:	f7 c7 01 00 00 00    	test   $0x1,%edi
f010733e:	0f 85 49 01 00 00    	jne    f010748d <nvme_attach+0x22a>
	nvme_queue_init(&adminq, base, NVME_ADMIN_Q, ADMINQ_SIZE, dstrd);
f0107344:	83 ec 08             	sub    $0x8,%esp
f0107347:	56                   	push   %esi
f0107348:	6a 08                	push   $0x8
f010734a:	b9 00 00 00 00       	mov    $0x0,%ecx
f010734f:	89 da                	mov    %ebx,%edx
f0107351:	b8 80 6f 2c f0       	mov    $0xf02c6f80,%eax
f0107356:	e8 ea fd ff ff       	call   f0107145 <nvme_queue_init>
	*(volatile uint32_t *)addr = v;
f010735b:	c7 43 24 07 00 07 00 	movl   $0x70007,0x24(%ebx)
	mmio_write64(base + NVME_ACQ, PADDR(adminq.cq_va));
f0107362:	a1 94 6f 2c f0       	mov    0xf02c6f94,%eax
	if ((uint32_t)kva < KERNBASE)
f0107367:	83 c4 10             	add    $0x10,%esp
f010736a:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010736f:	0f 86 31 01 00 00    	jbe    f01074a6 <nvme_attach+0x243>
	return (physaddr_t)kva - KERNBASE;
f0107375:	05 00 00 00 10       	add    $0x10000000,%eax
	*(volatile uint32_t *)addr = v;
f010737a:	89 43 30             	mov    %eax,0x30(%ebx)
f010737d:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
	mmio_write64(base + NVME_ASQ, PADDR(adminq.sq_va));
f0107384:	a1 88 6f 2c f0       	mov    0xf02c6f88,%eax
	if ((uint32_t)kva < KERNBASE)
f0107389:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f010738e:	0f 86 27 01 00 00    	jbe    f01074bb <nvme_attach+0x258>
	return (physaddr_t)kva - KERNBASE;
f0107394:	05 00 00 00 10       	add    $0x10000000,%eax
	*(volatile uint32_t *)addr = v;
f0107399:	89 43 28             	mov    %eax,0x28(%ebx)
f010739c:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
	CLR(cc, NVME_CC_IOCQES_MASK | NVME_CC_IOSQES_MASK |
f01073a3:	81 e7 0f c0 00 ff    	and    $0xff00c00f,%edi
	SET(cc, NVME_CC_EN);
f01073a9:	81 cf 01 00 46 00    	or     $0x460001,%edi
f01073af:	89 7b 14             	mov    %edi,0x14(%ebx)
	return *(volatile uint32_t *)addr;
f01073b2:	8b 43 1c             	mov    0x1c(%ebx),%eax
	while (!ISSET(mmio_read32(base + NVME_CSTS), NVME_CSTS_RDY))
f01073b5:	a8 01                	test   $0x1,%al
f01073b7:	74 f9                	je     f01073b2 <nvme_attach+0x14f>
	nvme_queue_init(&ioq, base, 1, IOQ_SIZE, dstrd);
f01073b9:	83 ec 08             	sub    $0x8,%esp
f01073bc:	56                   	push   %esi
f01073bd:	6a 08                	push   $0x8
f01073bf:	b9 01 00 00 00       	mov    $0x1,%ecx
f01073c4:	89 da                	mov    %ebx,%edx
f01073c6:	b8 40 6f 2c f0       	mov    $0xf02c6f40,%eax
f01073cb:	e8 75 fd ff ff       	call   f0107145 <nvme_queue_init>
	struct nvme_sqe_q cmd_add_iocq = {
f01073d0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
f01073d6:	b9 10 00 00 00       	mov    $0x10,%ecx
f01073db:	b8 00 00 00 00       	mov    $0x0,%eax
f01073e0:	f3 ab                	rep stos %eax,%es:(%edi)
f01073e2:	c6 85 68 ff ff ff 05 	movb   $0x5,-0x98(%ebp)
		.prp1 = PADDR(q->cq_va),
f01073e9:	a1 54 6f 2c f0       	mov    0xf02c6f54,%eax
	if ((uint32_t)kva < KERNBASE)
f01073ee:	83 c4 10             	add    $0x10,%esp
f01073f1:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01073f6:	0f 86 d4 00 00 00    	jbe    f01074d0 <nvme_attach+0x26d>
	return (physaddr_t)kva - KERNBASE;
f01073fc:	05 00 00 00 10       	add    $0x10000000,%eax
f0107401:	89 45 80             	mov    %eax,-0x80(%ebp)
f0107404:	c7 45 84 00 00 00 00 	movl   $0x0,-0x7c(%ebp)
		.qid = q->id,
f010740b:	8b 1d 40 6f 2c f0    	mov    0xf02c6f40,%ebx
	struct nvme_sqe_q cmd_add_iocq = {
f0107411:	66 89 5d 90          	mov    %bx,-0x70(%ebp)
		.qsize = q->size - 1,
f0107415:	8b 15 44 6f 2c f0    	mov    0xf02c6f44,%edx
f010741b:	4a                   	dec    %edx
	struct nvme_sqe_q cmd_add_iocq = {
f010741c:	66 89 55 92          	mov    %dx,-0x6e(%ebp)
f0107420:	c6 45 94 01          	movb   $0x1,-0x6c(%ebp)
	struct nvme_sqe_q cmd_add_iosq = {
f0107424:	8d 7d a8             	lea    -0x58(%ebp),%edi
f0107427:	b9 10 00 00 00       	mov    $0x10,%ecx
f010742c:	b8 00 00 00 00       	mov    $0x0,%eax
f0107431:	f3 ab                	rep stos %eax,%es:(%edi)
f0107433:	c6 45 a8 01          	movb   $0x1,-0x58(%ebp)
		.prp1 = PADDR(q->sq_va),
f0107437:	a1 48 6f 2c f0       	mov    0xf02c6f48,%eax
	if ((uint32_t)kva < KERNBASE)
f010743c:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0107441:	0f 86 9b 00 00 00    	jbe    f01074e2 <nvme_attach+0x27f>
	return (physaddr_t)kva - KERNBASE;
f0107447:	05 00 00 00 10       	add    $0x10000000,%eax
f010744c:	89 45 c0             	mov    %eax,-0x40(%ebp)
f010744f:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	struct nvme_sqe_q cmd_add_iosq = {
f0107456:	66 89 5d d0          	mov    %bx,-0x30(%ebp)
f010745a:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
f010745e:	c6 45 d4 01          	movb   $0x1,-0x2c(%ebp)
f0107462:	66 89 5d d6          	mov    %bx,-0x2a(%ebp)
	nvme_queue_submit(&adminq, &cmd_add_iocq);
f0107466:	8d 95 68 ff ff ff    	lea    -0x98(%ebp),%edx
f010746c:	b8 80 6f 2c f0       	mov    $0xf02c6f80,%eax
f0107471:	e8 42 fb ff ff       	call   f0106fb8 <nvme_queue_submit>
	nvme_queue_submit(&adminq, &cmd_add_iosq);
f0107476:	8d 55 a8             	lea    -0x58(%ebp),%edx
f0107479:	b8 80 6f 2c f0       	mov    $0xf02c6f80,%eax
f010747e:	e8 35 fb ff ff       	call   f0106fb8 <nvme_queue_submit>
	return 1;
f0107483:	b8 01 00 00 00       	mov    $0x1,%eax
f0107488:	e9 f0 fd ff ff       	jmp    f010727d <nvme_attach+0x1a>
	assert(!ISSET(cc, NVME_CC_EN));
f010748d:	68 94 9e 10 f0       	push   $0xf0109e94
f0107492:	68 31 78 10 f0       	push   $0xf0107831
f0107497:	68 8c 00 00 00       	push   $0x8c
f010749c:	68 88 9e 10 f0       	push   $0xf0109e88
f01074a1:	e8 9d 8b ff ff       	call   f0100043 <_panic>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01074a6:	50                   	push   %eax
f01074a7:	68 ec 77 10 f0       	push   $0xf01077ec
f01074ac:	68 92 00 00 00       	push   $0x92
f01074b1:	68 88 9e 10 f0       	push   $0xf0109e88
f01074b6:	e8 88 8b ff ff       	call   f0100043 <_panic>
f01074bb:	50                   	push   %eax
f01074bc:	68 ec 77 10 f0       	push   $0xf01077ec
f01074c1:	68 93 00 00 00       	push   $0x93
f01074c6:	68 88 9e 10 f0       	push   $0xf0109e88
f01074cb:	e8 73 8b ff ff       	call   f0100043 <_panic>
f01074d0:	50                   	push   %eax
f01074d1:	68 ec 77 10 f0       	push   $0xf01077ec
f01074d6:	6a 64                	push   $0x64
f01074d8:	68 88 9e 10 f0       	push   $0xf0109e88
f01074dd:	e8 61 8b ff ff       	call   f0100043 <_panic>
f01074e2:	50                   	push   %eax
f01074e3:	68 ec 77 10 f0       	push   $0xf01077ec
f01074e8:	6a 6b                	push   $0x6b
f01074ea:	68 88 9e 10 f0       	push   $0xf0109e88
f01074ef:	e8 4f 8b ff ff       	call   f0100043 <_panic>

f01074f4 <nvme_read>:

int
nvme_read(uint64_t secno, void *buf, uint16_t nsecs)
{
f01074f4:	55                   	push   %ebp
f01074f5:	89 e5                	mov    %esp,%ebp
f01074f7:	83 ec 10             	sub    $0x10,%esp
	return nvme_rw(NVM_CMD_READ, secno, buf, nsecs);
f01074fa:	0f b7 45 14          	movzwl 0x14(%ebp),%eax
f01074fe:	50                   	push   %eax
f01074ff:	ff 75 10             	pushl  0x10(%ebp)
f0107502:	8b 55 08             	mov    0x8(%ebp),%edx
f0107505:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0107508:	b8 02 00 00 00       	mov    $0x2,%eax
f010750d:	e8 48 fb ff ff       	call   f010705a <nvme_rw>
}
f0107512:	c9                   	leave  
f0107513:	c3                   	ret    

f0107514 <nvme_write>:

int
nvme_write(uint64_t secno, void *buf, uint16_t nsecs)
{
f0107514:	55                   	push   %ebp
f0107515:	89 e5                	mov    %esp,%ebp
f0107517:	83 ec 10             	sub    $0x10,%esp
	return nvme_rw(NVM_CMD_WRITE, secno, buf, nsecs);
f010751a:	0f b7 45 14          	movzwl 0x14(%ebp),%eax
f010751e:	50                   	push   %eax
f010751f:	ff 75 10             	pushl  0x10(%ebp)
f0107522:	8b 55 08             	mov    0x8(%ebp),%edx
f0107525:	8b 4d 0c             	mov    0xc(%ebp),%ecx
f0107528:	b8 01 00 00 00       	mov    $0x1,%eax
f010752d:	e8 28 fb ff ff       	call   f010705a <nvme_rw>
}
f0107532:	c9                   	leave  
f0107533:	c3                   	ret    

f0107534 <__udivdi3>:
f0107534:	55                   	push   %ebp
f0107535:	57                   	push   %edi
f0107536:	56                   	push   %esi
f0107537:	53                   	push   %ebx
f0107538:	83 ec 1c             	sub    $0x1c,%esp
f010753b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
f010753f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
f0107543:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107547:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f010754b:	89 ca                	mov    %ecx,%edx
f010754d:	89 f8                	mov    %edi,%eax
f010754f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
f0107553:	85 f6                	test   %esi,%esi
f0107555:	75 2d                	jne    f0107584 <__udivdi3+0x50>
f0107557:	39 cf                	cmp    %ecx,%edi
f0107559:	77 65                	ja     f01075c0 <__udivdi3+0x8c>
f010755b:	89 fd                	mov    %edi,%ebp
f010755d:	85 ff                	test   %edi,%edi
f010755f:	75 0b                	jne    f010756c <__udivdi3+0x38>
f0107561:	b8 01 00 00 00       	mov    $0x1,%eax
f0107566:	31 d2                	xor    %edx,%edx
f0107568:	f7 f7                	div    %edi
f010756a:	89 c5                	mov    %eax,%ebp
f010756c:	31 d2                	xor    %edx,%edx
f010756e:	89 c8                	mov    %ecx,%eax
f0107570:	f7 f5                	div    %ebp
f0107572:	89 c1                	mov    %eax,%ecx
f0107574:	89 d8                	mov    %ebx,%eax
f0107576:	f7 f5                	div    %ebp
f0107578:	89 cf                	mov    %ecx,%edi
f010757a:	89 fa                	mov    %edi,%edx
f010757c:	83 c4 1c             	add    $0x1c,%esp
f010757f:	5b                   	pop    %ebx
f0107580:	5e                   	pop    %esi
f0107581:	5f                   	pop    %edi
f0107582:	5d                   	pop    %ebp
f0107583:	c3                   	ret    
f0107584:	39 ce                	cmp    %ecx,%esi
f0107586:	77 28                	ja     f01075b0 <__udivdi3+0x7c>
f0107588:	0f bd fe             	bsr    %esi,%edi
f010758b:	83 f7 1f             	xor    $0x1f,%edi
f010758e:	75 40                	jne    f01075d0 <__udivdi3+0x9c>
f0107590:	39 ce                	cmp    %ecx,%esi
f0107592:	72 0a                	jb     f010759e <__udivdi3+0x6a>
f0107594:	3b 44 24 04          	cmp    0x4(%esp),%eax
f0107598:	0f 87 9e 00 00 00    	ja     f010763c <__udivdi3+0x108>
f010759e:	b8 01 00 00 00       	mov    $0x1,%eax
f01075a3:	89 fa                	mov    %edi,%edx
f01075a5:	83 c4 1c             	add    $0x1c,%esp
f01075a8:	5b                   	pop    %ebx
f01075a9:	5e                   	pop    %esi
f01075aa:	5f                   	pop    %edi
f01075ab:	5d                   	pop    %ebp
f01075ac:	c3                   	ret    
f01075ad:	8d 76 00             	lea    0x0(%esi),%esi
f01075b0:	31 ff                	xor    %edi,%edi
f01075b2:	31 c0                	xor    %eax,%eax
f01075b4:	89 fa                	mov    %edi,%edx
f01075b6:	83 c4 1c             	add    $0x1c,%esp
f01075b9:	5b                   	pop    %ebx
f01075ba:	5e                   	pop    %esi
f01075bb:	5f                   	pop    %edi
f01075bc:	5d                   	pop    %ebp
f01075bd:	c3                   	ret    
f01075be:	66 90                	xchg   %ax,%ax
f01075c0:	89 d8                	mov    %ebx,%eax
f01075c2:	f7 f7                	div    %edi
f01075c4:	31 ff                	xor    %edi,%edi
f01075c6:	89 fa                	mov    %edi,%edx
f01075c8:	83 c4 1c             	add    $0x1c,%esp
f01075cb:	5b                   	pop    %ebx
f01075cc:	5e                   	pop    %esi
f01075cd:	5f                   	pop    %edi
f01075ce:	5d                   	pop    %ebp
f01075cf:	c3                   	ret    
f01075d0:	bd 20 00 00 00       	mov    $0x20,%ebp
f01075d5:	29 fd                	sub    %edi,%ebp
f01075d7:	89 f9                	mov    %edi,%ecx
f01075d9:	d3 e6                	shl    %cl,%esi
f01075db:	89 c3                	mov    %eax,%ebx
f01075dd:	89 e9                	mov    %ebp,%ecx
f01075df:	d3 eb                	shr    %cl,%ebx
f01075e1:	89 d9                	mov    %ebx,%ecx
f01075e3:	09 f1                	or     %esi,%ecx
f01075e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f01075e9:	89 f9                	mov    %edi,%ecx
f01075eb:	d3 e0                	shl    %cl,%eax
f01075ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01075f1:	89 d6                	mov    %edx,%esi
f01075f3:	89 e9                	mov    %ebp,%ecx
f01075f5:	d3 ee                	shr    %cl,%esi
f01075f7:	89 f9                	mov    %edi,%ecx
f01075f9:	d3 e2                	shl    %cl,%edx
f01075fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
f01075ff:	89 e9                	mov    %ebp,%ecx
f0107601:	d3 eb                	shr    %cl,%ebx
f0107603:	09 da                	or     %ebx,%edx
f0107605:	89 d0                	mov    %edx,%eax
f0107607:	89 f2                	mov    %esi,%edx
f0107609:	f7 74 24 08          	divl   0x8(%esp)
f010760d:	89 d6                	mov    %edx,%esi
f010760f:	89 c3                	mov    %eax,%ebx
f0107611:	f7 64 24 0c          	mull   0xc(%esp)
f0107615:	39 d6                	cmp    %edx,%esi
f0107617:	72 17                	jb     f0107630 <__udivdi3+0xfc>
f0107619:	74 09                	je     f0107624 <__udivdi3+0xf0>
f010761b:	89 d8                	mov    %ebx,%eax
f010761d:	31 ff                	xor    %edi,%edi
f010761f:	e9 56 ff ff ff       	jmp    f010757a <__udivdi3+0x46>
f0107624:	8b 54 24 04          	mov    0x4(%esp),%edx
f0107628:	89 f9                	mov    %edi,%ecx
f010762a:	d3 e2                	shl    %cl,%edx
f010762c:	39 c2                	cmp    %eax,%edx
f010762e:	73 eb                	jae    f010761b <__udivdi3+0xe7>
f0107630:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0107633:	31 ff                	xor    %edi,%edi
f0107635:	e9 40 ff ff ff       	jmp    f010757a <__udivdi3+0x46>
f010763a:	66 90                	xchg   %ax,%ax
f010763c:	31 c0                	xor    %eax,%eax
f010763e:	e9 37 ff ff ff       	jmp    f010757a <__udivdi3+0x46>
f0107643:	90                   	nop

f0107644 <__umoddi3>:
f0107644:	55                   	push   %ebp
f0107645:	57                   	push   %edi
f0107646:	56                   	push   %esi
f0107647:	53                   	push   %ebx
f0107648:	83 ec 1c             	sub    $0x1c,%esp
f010764b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
f010764f:	8b 74 24 34          	mov    0x34(%esp),%esi
f0107653:	8b 7c 24 38          	mov    0x38(%esp),%edi
f0107657:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f010765b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010765f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f0107663:	89 3c 24             	mov    %edi,(%esp)
f0107666:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f010766a:	89 f2                	mov    %esi,%edx
f010766c:	85 c0                	test   %eax,%eax
f010766e:	75 18                	jne    f0107688 <__umoddi3+0x44>
f0107670:	39 f7                	cmp    %esi,%edi
f0107672:	0f 86 a0 00 00 00    	jbe    f0107718 <__umoddi3+0xd4>
f0107678:	89 c8                	mov    %ecx,%eax
f010767a:	f7 f7                	div    %edi
f010767c:	89 d0                	mov    %edx,%eax
f010767e:	31 d2                	xor    %edx,%edx
f0107680:	83 c4 1c             	add    $0x1c,%esp
f0107683:	5b                   	pop    %ebx
f0107684:	5e                   	pop    %esi
f0107685:	5f                   	pop    %edi
f0107686:	5d                   	pop    %ebp
f0107687:	c3                   	ret    
f0107688:	89 f3                	mov    %esi,%ebx
f010768a:	39 f0                	cmp    %esi,%eax
f010768c:	0f 87 a6 00 00 00    	ja     f0107738 <__umoddi3+0xf4>
f0107692:	0f bd e8             	bsr    %eax,%ebp
f0107695:	83 f5 1f             	xor    $0x1f,%ebp
f0107698:	0f 84 a6 00 00 00    	je     f0107744 <__umoddi3+0x100>
f010769e:	bf 20 00 00 00       	mov    $0x20,%edi
f01076a3:	29 ef                	sub    %ebp,%edi
f01076a5:	89 e9                	mov    %ebp,%ecx
f01076a7:	d3 e0                	shl    %cl,%eax
f01076a9:	8b 34 24             	mov    (%esp),%esi
f01076ac:	89 f2                	mov    %esi,%edx
f01076ae:	89 f9                	mov    %edi,%ecx
f01076b0:	d3 ea                	shr    %cl,%edx
f01076b2:	09 c2                	or     %eax,%edx
f01076b4:	89 14 24             	mov    %edx,(%esp)
f01076b7:	89 f2                	mov    %esi,%edx
f01076b9:	89 e9                	mov    %ebp,%ecx
f01076bb:	d3 e2                	shl    %cl,%edx
f01076bd:	89 54 24 04          	mov    %edx,0x4(%esp)
f01076c1:	89 de                	mov    %ebx,%esi
f01076c3:	89 f9                	mov    %edi,%ecx
f01076c5:	d3 ee                	shr    %cl,%esi
f01076c7:	89 e9                	mov    %ebp,%ecx
f01076c9:	d3 e3                	shl    %cl,%ebx
f01076cb:	8b 54 24 08          	mov    0x8(%esp),%edx
f01076cf:	89 d0                	mov    %edx,%eax
f01076d1:	89 f9                	mov    %edi,%ecx
f01076d3:	d3 e8                	shr    %cl,%eax
f01076d5:	09 d8                	or     %ebx,%eax
f01076d7:	89 d3                	mov    %edx,%ebx
f01076d9:	89 e9                	mov    %ebp,%ecx
f01076db:	d3 e3                	shl    %cl,%ebx
f01076dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f01076e1:	89 f2                	mov    %esi,%edx
f01076e3:	f7 34 24             	divl   (%esp)
f01076e6:	89 d6                	mov    %edx,%esi
f01076e8:	f7 64 24 04          	mull   0x4(%esp)
f01076ec:	89 c3                	mov    %eax,%ebx
f01076ee:	89 d1                	mov    %edx,%ecx
f01076f0:	39 d6                	cmp    %edx,%esi
f01076f2:	72 7c                	jb     f0107770 <__umoddi3+0x12c>
f01076f4:	74 72                	je     f0107768 <__umoddi3+0x124>
f01076f6:	8b 54 24 08          	mov    0x8(%esp),%edx
f01076fa:	29 da                	sub    %ebx,%edx
f01076fc:	19 ce                	sbb    %ecx,%esi
f01076fe:	89 f0                	mov    %esi,%eax
f0107700:	89 f9                	mov    %edi,%ecx
f0107702:	d3 e0                	shl    %cl,%eax
f0107704:	89 e9                	mov    %ebp,%ecx
f0107706:	d3 ea                	shr    %cl,%edx
f0107708:	09 d0                	or     %edx,%eax
f010770a:	89 e9                	mov    %ebp,%ecx
f010770c:	d3 ee                	shr    %cl,%esi
f010770e:	89 f2                	mov    %esi,%edx
f0107710:	83 c4 1c             	add    $0x1c,%esp
f0107713:	5b                   	pop    %ebx
f0107714:	5e                   	pop    %esi
f0107715:	5f                   	pop    %edi
f0107716:	5d                   	pop    %ebp
f0107717:	c3                   	ret    
f0107718:	89 fd                	mov    %edi,%ebp
f010771a:	85 ff                	test   %edi,%edi
f010771c:	75 0b                	jne    f0107729 <__umoddi3+0xe5>
f010771e:	b8 01 00 00 00       	mov    $0x1,%eax
f0107723:	31 d2                	xor    %edx,%edx
f0107725:	f7 f7                	div    %edi
f0107727:	89 c5                	mov    %eax,%ebp
f0107729:	89 f0                	mov    %esi,%eax
f010772b:	31 d2                	xor    %edx,%edx
f010772d:	f7 f5                	div    %ebp
f010772f:	89 c8                	mov    %ecx,%eax
f0107731:	f7 f5                	div    %ebp
f0107733:	e9 44 ff ff ff       	jmp    f010767c <__umoddi3+0x38>
f0107738:	89 c8                	mov    %ecx,%eax
f010773a:	89 f2                	mov    %esi,%edx
f010773c:	83 c4 1c             	add    $0x1c,%esp
f010773f:	5b                   	pop    %ebx
f0107740:	5e                   	pop    %esi
f0107741:	5f                   	pop    %edi
f0107742:	5d                   	pop    %ebp
f0107743:	c3                   	ret    
f0107744:	39 f0                	cmp    %esi,%eax
f0107746:	72 05                	jb     f010774d <__umoddi3+0x109>
f0107748:	39 0c 24             	cmp    %ecx,(%esp)
f010774b:	77 0c                	ja     f0107759 <__umoddi3+0x115>
f010774d:	89 f2                	mov    %esi,%edx
f010774f:	29 f9                	sub    %edi,%ecx
f0107751:	1b 54 24 0c          	sbb    0xc(%esp),%edx
f0107755:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0107759:	8b 44 24 04          	mov    0x4(%esp),%eax
f010775d:	83 c4 1c             	add    $0x1c,%esp
f0107760:	5b                   	pop    %ebx
f0107761:	5e                   	pop    %esi
f0107762:	5f                   	pop    %edi
f0107763:	5d                   	pop    %ebp
f0107764:	c3                   	ret    
f0107765:	8d 76 00             	lea    0x0(%esi),%esi
f0107768:	39 44 24 08          	cmp    %eax,0x8(%esp)
f010776c:	73 88                	jae    f01076f6 <__umoddi3+0xb2>
f010776e:	66 90                	xchg   %ax,%ax
f0107770:	2b 44 24 04          	sub    0x4(%esp),%eax
f0107774:	1b 14 24             	sbb    (%esp),%edx
f0107777:	89 d1                	mov    %edx,%ecx
f0107779:	89 c3                	mov    %eax,%ebx
f010777b:	e9 76 ff ff ff       	jmp    f01076f6 <__umoddi3+0xb2>
