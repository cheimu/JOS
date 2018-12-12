
obj/boot/boot.out:     file format elf32-i386


Disassembly of section .text:

00007c00 <start>:
.set CR0_PE_ON,      0x1			# protected mode enable flag

.code16						# Assemble for 16-bit mode
.globl start
start:
	cli					# Disable interrupts
    7c00:	fa                   	cli    
	cld					# String operations increment
    7c01:	fc                   	cld    

	# Set up the important data segment registers (DS, ES, SS).
	xorw	%ax, %ax			# Segment number zero
    7c02:	31 c0                	xor    %eax,%eax
	movw	%ax, %ds			# -> Data Segment
    7c04:	8e d8                	mov    %eax,%ds
	movw	%ax, %es			# -> Extra Segment
    7c06:	8e c0                	mov    %eax,%es
	movw	%ax, %ss			# -> Stack Segment
    7c08:	8e d0                	mov    %eax,%ss

00007c0a <seta20.1>:
	# Enable A20:
	#   For backwards compatibility with the earliest PCs, physical
	#   address line 20 is tied low, so that addresses higher than
	#   1MB wrap around to zero by default.  This code undoes this.
seta20.1:
	inb	$0x64, %al			# Wait for not busy
    7c0a:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7c0c:	a8 02                	test   $0x2,%al
	jnz	seta20.1
    7c0e:	75 fa                	jne    7c0a <seta20.1>

	movb	$0xd1, %al			# 0xd1 -> port 0x64
    7c10:	b0 d1                	mov    $0xd1,%al
	outb	%al, $0x64
    7c12:	e6 64                	out    %al,$0x64

00007c14 <seta20.2>:

seta20.2:
	inb	$0x64, %al			# Wait for not busy
    7c14:	e4 64                	in     $0x64,%al
	testb	$0x2, %al
    7c16:	a8 02                	test   $0x2,%al
	jnz	seta20.2
    7c18:	75 fa                	jne    7c14 <seta20.2>

	movb	$0xdf, %al			# 0xdf -> port 0x60
    7c1a:	b0 df                	mov    $0xdf,%al
	outb	%al, $0x60
    7c1c:	e6 60                	out    %al,$0x60

00007c1e <e820_start>:

	# Copy the E820 memory map to MULTIBOOT_PADDR.
e820_start:
	xorl	%ebx, %ebx			# clear ebx
    7c1e:	66 31 db             	xor    %bx,%bx
	movw	$MULTIBOOT_PADDR, %di
    7c21:	bf                   	.byte 0xbf
    7c22:	00                   	.byte 0x0
    7c23:	90                   	nop

00007c24 <e820_loop>:
e820_loop:
	movl	$20, (%di)			# fill 20 into size
    7c24:	66 c7 05 14 00 00 00 	movw   $0xc783,0x14
    7c2b:	83 c7 
	addw	$4, %di				# bump to payload
    7c2d:	04 66                	add    $0x66,%al
	movl	$0x534d4150, %edx		# "SMAP"
    7c2f:	ba 50 41 4d 53       	mov    $0x534d4150,%edx
	movl	$0xe820, %eax
    7c34:	66 b8 20 e8          	mov    $0xe820,%ax
    7c38:	00 00                	add    %al,(%eax)
	movw	$20, %cx			# ignore ACPI 3.0 extended attributes
    7c3a:	b9 14 00 cd 15       	mov    $0x15cd0014,%ecx
	int	$0x15
	jc	e820_end			# none?
    7c3f:	72 0d                	jb     7c4e <e820_end>
	cmpw	$20, %cx
    7c41:	83 f9 14             	cmp    $0x14,%ecx
	jg	e820_skip			# entry should have at least 20 byte
    7c44:	7f 03                	jg     7c49 <e820_skip>

00007c46 <e820_next>:
e820_next:
	addw	$20, %di			# continue to next entry
    7c46:	83 c7 14             	add    $0x14,%edi

00007c49 <e820_skip>:
e820_skip:
	test	%ebx, %ebx
    7c49:	66 85 db             	test   %bx,%bx
	jne	e820_loop			# done if ebx = 0
    7c4c:	75 d6                	jne    7c24 <e820_loop>

00007c4e <e820_end>:
e820_end:
	mov	%edi, (mbi)			# store end pointer to mbi
    7c4e:	66 89 3e             	mov    %di,(%esi)
    7c51:	8c 7e 0f             	mov    %?,0xf(%esi)

	# Switch from real to protected mode, using a bootstrap GDT
	# and segment translation that makes virtual addresses
	# identical to their physical addresses, so that the
	# effective memory map does not change during the switch.
	lgdt	gdtdesc
    7c54:	01 16                	add    %edx,(%esi)
    7c56:	9c                   	pushf  
    7c57:	7c 0f                	jl     7c68 <protcseg+0x1>
	movl	%cr0, %eax
    7c59:	20 c0                	and    %al,%al
	orl	$CR0_PE_ON, %eax
    7c5b:	66 83 c8 01          	or     $0x1,%ax
	movl	%eax, %cr0
    7c5f:	0f 22 c0             	mov    %eax,%cr0

	# Jump to next instruction, but in 32-bit code segment.
	# Switches processor into 32-bit mode.
	ljmp	$PROT_MODE_CSEG, $protcseg
    7c62:	ea                   	.byte 0xea
    7c63:	67 7c 08             	addr16 jl 7c6e <protcseg+0x7>
	...

00007c67 <protcseg>:

.code32						# Assemble for 32-bit mode
protcseg:
	# Set up the protected-mode data segment registers
	movw	$PROT_MODE_DSEG, %ax		# Our data segment selector
    7c67:	66 b8 10 00          	mov    $0x10,%ax
	movw	%ax, %ds			# -> DS: Data Segment
    7c6b:	8e d8                	mov    %eax,%ds
	movw	%ax, %es			# -> ES: Extra Segment
    7c6d:	8e c0                	mov    %eax,%es
	movw	%ax, %fs			# -> FS
    7c6f:	8e e0                	mov    %eax,%fs
	movw	%ax, %gs			# -> GS
    7c71:	8e e8                	mov    %eax,%gs
	movw	%ax, %ss			# -> SS: Stack Segment
    7c73:	8e d0                	mov    %eax,%ss

	# Set up the stack pointer and call into C.
	movl	$start, %esp
    7c75:	bc 00 7c 00 00       	mov    $0x7c00,%esp
	call	bootmain
    7c7a:	e8 ce 00 00 00       	call   7d4d <bootmain>

00007c7f <spin>:

	# If bootmain returns (it shouldn't), loop.
spin:
	jmp	spin
    7c7f:	eb fe                	jmp    7c7f <spin>
    7c81:	8d 76 00             	lea    0x0(%esi),%esi

00007c84 <gdt>:
	...
    7c8c:	ff                   	(bad)  
    7c8d:	ff 00                	incl   (%eax)
    7c8f:	00 00                	add    %al,(%eax)
    7c91:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
    7c98:	00                   	.byte 0x0
    7c99:	92                   	xchg   %eax,%edx
    7c9a:	cf                   	iret   
	...

00007c9c <gdtdesc>:
    7c9c:	17                   	pop    %ss
    7c9d:	00                   	.byte 0x0
    7c9e:	84 7c 00 00          	test   %bh,0x0(%eax,%eax,1)

00007ca2 <waitdisk>:
	}
}

void
waitdisk(void)
{
    7ca2:	55                   	push   %ebp
    7ca3:	89 e5                	mov    %esp,%ebp

static inline uint8_t
inb(int port)
{
	uint8_t data;
	asm volatile("inb %w1,%0" : "=a" (data) : "d" (port));
    7ca5:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7caa:	ec                   	in     (%dx),%al
	// wait for disk reaady
	while ((inb(0x1F7) & 0xC0) != 0x40)
    7cab:	83 e0 c0             	and    $0xffffffc0,%eax
    7cae:	3c 40                	cmp    $0x40,%al
    7cb0:	75 f8                	jne    7caa <waitdisk+0x8>
		/* do nothing */;
}
    7cb2:	5d                   	pop    %ebp
    7cb3:	c3                   	ret    

00007cb4 <readsect>:

void
readsect(void *dst, uint32_t offset)
{
    7cb4:	55                   	push   %ebp
    7cb5:	89 e5                	mov    %esp,%ebp
    7cb7:	57                   	push   %edi
    7cb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	// wait for disk to be ready
	waitdisk();
    7cbb:	e8 e2 ff ff ff       	call   7ca2 <waitdisk>
}

static inline void
outb(int port, uint8_t data)
{
	asm volatile("outb %0,%w1" : : "a" (data), "d" (port));
    7cc0:	ba f2 01 00 00       	mov    $0x1f2,%edx
    7cc5:	b0 01                	mov    $0x1,%al
    7cc7:	ee                   	out    %al,(%dx)
    7cc8:	ba f3 01 00 00       	mov    $0x1f3,%edx
    7ccd:	88 c8                	mov    %cl,%al
    7ccf:	ee                   	out    %al,(%dx)

	outb(0x1F2, 1);		// count = 1
	outb(0x1F3, offset);
	outb(0x1F4, offset >> 8);
    7cd0:	89 c8                	mov    %ecx,%eax
    7cd2:	c1 e8 08             	shr    $0x8,%eax
    7cd5:	ba f4 01 00 00       	mov    $0x1f4,%edx
    7cda:	ee                   	out    %al,(%dx)
	outb(0x1F5, offset >> 16);
    7cdb:	89 c8                	mov    %ecx,%eax
    7cdd:	c1 e8 10             	shr    $0x10,%eax
    7ce0:	ba f5 01 00 00       	mov    $0x1f5,%edx
    7ce5:	ee                   	out    %al,(%dx)
	outb(0x1F6, (offset >> 24) | 0xE0);
    7ce6:	89 c8                	mov    %ecx,%eax
    7ce8:	c1 e8 18             	shr    $0x18,%eax
    7ceb:	83 c8 e0             	or     $0xffffffe0,%eax
    7cee:	ba f6 01 00 00       	mov    $0x1f6,%edx
    7cf3:	ee                   	out    %al,(%dx)
    7cf4:	ba f7 01 00 00       	mov    $0x1f7,%edx
    7cf9:	b0 20                	mov    $0x20,%al
    7cfb:	ee                   	out    %al,(%dx)
	outb(0x1F7, 0x20);	// cmd 0x20 - read sectors

	// wait for disk to be ready
	waitdisk();
    7cfc:	e8 a1 ff ff ff       	call   7ca2 <waitdisk>
	asm volatile("cld\n\trepne\n\tinsl"
    7d01:	8b 7d 08             	mov    0x8(%ebp),%edi
    7d04:	b9 80 00 00 00       	mov    $0x80,%ecx
    7d09:	ba f0 01 00 00       	mov    $0x1f0,%edx
    7d0e:	fc                   	cld    
    7d0f:	f2 6d                	repnz insl (%dx),%es:(%edi)

	// read a sector
	insl(0x1F0, dst, SECTSIZE/4);
}
    7d11:	5f                   	pop    %edi
    7d12:	5d                   	pop    %ebp
    7d13:	c3                   	ret    

00007d14 <readseg>:
{
    7d14:	55                   	push   %ebp
    7d15:	89 e5                	mov    %esp,%ebp
    7d17:	57                   	push   %edi
    7d18:	56                   	push   %esi
    7d19:	53                   	push   %ebx
    7d1a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	end_pa = pa + count;
    7d1d:	8b 75 0c             	mov    0xc(%ebp),%esi
    7d20:	01 de                	add    %ebx,%esi
	pa &= ~(SECTSIZE - 1);
    7d22:	81 e3 00 fe ff ff    	and    $0xfffffe00,%ebx
	offset = (offset / SECTSIZE) + 1;
    7d28:	8b 7d 10             	mov    0x10(%ebp),%edi
    7d2b:	c1 ef 09             	shr    $0x9,%edi
    7d2e:	47                   	inc    %edi
	while (pa < end_pa) {
    7d2f:	39 f3                	cmp    %esi,%ebx
    7d31:	73 12                	jae    7d45 <readseg+0x31>
		readsect((uint8_t*) pa, offset);
    7d33:	57                   	push   %edi
    7d34:	53                   	push   %ebx
    7d35:	e8 7a ff ff ff       	call   7cb4 <readsect>
		pa += SECTSIZE;
    7d3a:	81 c3 00 02 00 00    	add    $0x200,%ebx
		offset++;
    7d40:	47                   	inc    %edi
    7d41:	58                   	pop    %eax
    7d42:	5a                   	pop    %edx
    7d43:	eb ea                	jmp    7d2f <readseg+0x1b>
}
    7d45:	8d 65 f4             	lea    -0xc(%ebp),%esp
    7d48:	5b                   	pop    %ebx
    7d49:	5e                   	pop    %esi
    7d4a:	5f                   	pop    %edi
    7d4b:	5d                   	pop    %ebp
    7d4c:	c3                   	ret    

00007d4d <bootmain>:
{
    7d4d:	55                   	push   %ebp
    7d4e:	89 e5                	mov    %esp,%ebp
    7d50:	56                   	push   %esi
    7d51:	53                   	push   %ebx
	readseg((uint32_t) ELFHDR, SECTSIZE*8, 0);
    7d52:	6a 00                	push   $0x0
    7d54:	68 00 10 00 00       	push   $0x1000
    7d59:	68 00 00 01 00       	push   $0x10000
    7d5e:	e8 b1 ff ff ff       	call   7d14 <readseg>
	if (ELFHDR->e_magic != ELF_MAGIC)
    7d63:	83 c4 0c             	add    $0xc,%esp
    7d66:	81 3d 00 00 01 00 7f 	cmpl   $0x464c457f,0x10000
    7d6d:	45 4c 46 
    7d70:	75 5d                	jne    7dcf <bootmain+0x82>
	ph = (struct Proghdr *) ((uint8_t *) ELFHDR + ELFHDR->e_phoff);
    7d72:	a1 1c 00 01 00       	mov    0x1001c,%eax
    7d77:	8d 98 00 00 01 00    	lea    0x10000(%eax),%ebx
	eph = ph + ELFHDR->e_phnum;
    7d7d:	0f b7 35 2c 00 01 00 	movzwl 0x1002c,%esi
    7d84:	c1 e6 05             	shl    $0x5,%esi
    7d87:	01 de                	add    %ebx,%esi
	for (; ph < eph; ph++)
    7d89:	39 f3                	cmp    %esi,%ebx
    7d8b:	73 16                	jae    7da3 <bootmain+0x56>
		readseg(ph->p_pa, ph->p_memsz, ph->p_offset);
    7d8d:	ff 73 04             	pushl  0x4(%ebx)
    7d90:	ff 73 14             	pushl  0x14(%ebx)
    7d93:	ff 73 0c             	pushl  0xc(%ebx)
    7d96:	e8 79 ff ff ff       	call   7d14 <readseg>
	for (; ph < eph; ph++)
    7d9b:	83 c3 20             	add    $0x20,%ebx
    7d9e:	83 c4 0c             	add    $0xc,%esp
    7da1:	eb e6                	jmp    7d89 <bootmain+0x3c>
	mbi->flags = MULTIBOOT_INFO_MEM_MAP;
    7da3:	8b 15 8c 7e 00 00    	mov    0x7e8c,%edx
    7da9:	c7 02 40 00 00 00    	movl   $0x40,(%edx)
	mbi->mmap_length = (uint32_t)mbi & (4096 - 1); // 4K aligned
    7daf:	89 d0                	mov    %edx,%eax
    7db1:	25 ff 0f 00 00       	and    $0xfff,%eax
    7db6:	89 42 2c             	mov    %eax,0x2c(%edx)
	mbi->mmap_addr = (uint32_t)mbi - mbi->mmap_length;
    7db9:	89 d1                	mov    %edx,%ecx
    7dbb:	29 c1                	sub    %eax,%ecx
    7dbd:	89 4a 30             	mov    %ecx,0x30(%edx)
	asm volatile("movl %0, %%eax\n\tmovl %1, %%ebx"
    7dc0:	b9 02 b0 ad 2b       	mov    $0x2badb002,%ecx
    7dc5:	89 c8                	mov    %ecx,%eax
    7dc7:	89 d3                	mov    %edx,%ebx
	((void (*)(void)) (ELFHDR->e_entry))();
    7dc9:	ff 15 18 00 01 00    	call   *0x10018
}

static inline void
outw(int port, uint16_t data)
{
	asm volatile("outw %0,%w1" : : "a" (data), "d" (port));
    7dcf:	ba 00 8a 00 00       	mov    $0x8a00,%edx
    7dd4:	b8 00 8a ff ff       	mov    $0xffff8a00,%eax
    7dd9:	66 ef                	out    %ax,(%dx)
    7ddb:	b8 00 8e ff ff       	mov    $0xffff8e00,%eax
    7de0:	66 ef                	out    %ax,(%dx)
    7de2:	eb fe                	jmp    7de2 <bootmain+0x95>
