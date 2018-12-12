
obj/fs/fs:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	cmpl $USTACKTOP, %esp
  800020:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  800026:	75 04                	jne    80002c <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  800028:	6a 00                	push   $0x0
	pushl $0
  80002a:	6a 00                	push   $0x0

0080002c <args_exist>:

args_exist:
	call libmain
  80002c:	e8 99 17 00 00       	call   8017ca <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <diskaddr>:
#include "fs.h"

// Return the virtual address of this disk block.
void*
diskaddr(uint32_t blockno)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
  800039:	8b 45 08             	mov    0x8(%ebp),%eax
	if (blockno == 0 || (super && blockno >= super->s_nblocks))
  80003c:	85 c0                	test   %eax,%eax
  80003e:	74 19                	je     800059 <diskaddr+0x26>
  800040:	8b 15 08 a0 80 00    	mov    0x80a008,%edx
  800046:	85 d2                	test   %edx,%edx
  800048:	74 05                	je     80004f <diskaddr+0x1c>
  80004a:	3b 42 04             	cmp    0x4(%edx),%eax
  80004d:	73 0a                	jae    800059 <diskaddr+0x26>
		panic("bad block number %08x in diskaddr", blockno);
	return (char*) (DISKMAP + blockno * BLKSIZE);
  80004f:	05 00 00 01 00       	add    $0x10000,%eax
  800054:	c1 e0 0c             	shl    $0xc,%eax
}
  800057:	c9                   	leave  
  800058:	c3                   	ret    
		panic("bad block number %08x in diskaddr", blockno);
  800059:	50                   	push   %eax
  80005a:	68 00 37 80 00       	push   $0x803700
  80005f:	6a 09                	push   $0x9
  800061:	68 98 38 80 00       	push   $0x803898
  800066:	e8 c5 17 00 00       	call   801830 <_panic>

0080006b <bc_pgfault>:

// Fault any disk block that is read in to memory by
// loading it from disk.
static void
bc_pgfault(struct UTrapframe *utf)
{
  80006b:	55                   	push   %ebp
  80006c:	89 e5                	mov    %esp,%ebp
  80006e:	56                   	push   %esi
  80006f:	53                   	push   %ebx
  800070:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void *) utf->utf_fault_va;
  800073:	8b 1a                	mov    (%edx),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  800075:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  80007b:	89 c6                	mov    %eax,%esi
  80007d:	c1 ee 0c             	shr    $0xc,%esi
	int r;

	// Check that the fault was within the block cache region
	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  800080:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  800085:	0f 87 a3 00 00 00    	ja     80012e <bc_pgfault+0xc3>
		panic("page fault in FS: eip %08x, va %08x, err %04x",
		      utf->utf_eip, addr, utf->utf_err);

	// Sanity check the block number.
	if (super && blockno >= super->s_nblocks)
  80008b:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800090:	85 c0                	test   %eax,%eax
  800092:	74 09                	je     80009d <bc_pgfault+0x32>
  800094:	3b 70 04             	cmp    0x4(%eax),%esi
  800097:	0f 83 ac 00 00 00    	jae    800149 <bc_pgfault+0xde>
	// of the block from the disk into that page.
	// Hint: first round addr to page boundary.
	// Hint: use sys_blk_read.
	//
	// LAB 5: you code here:
	assert(sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE), PTE_SYSCALL) == 0);
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	68 07 0e 00 00       	push   $0xe07
  8000a5:	89 d8                	mov    %ebx,%eax
  8000a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000ac:	50                   	push   %eax
  8000ad:	6a 00                	push   $0x0
  8000af:	e8 4c 22 00 00       	call   802300 <sys_page_alloc>
  8000b4:	83 c4 10             	add    $0x10,%esp
  8000b7:	85 c0                	test   %eax,%eax
  8000b9:	0f 85 9c 00 00 00    	jne    80015b <bc_pgfault+0xf0>
	assert(sys_blk_read((uint32_t) (diskaddr(blockno) - DISKMAP) / SECTSIZE, diskaddr(blockno), BLKSECTS) >= 0);
  8000bf:	83 ec 0c             	sub    $0xc,%esp
  8000c2:	56                   	push   %esi
  8000c3:	e8 6b ff ff ff       	call   800033 <diskaddr>
  8000c8:	83 c4 0c             	add    $0xc,%esp
  8000cb:	6a 08                	push   $0x8
  8000cd:	50                   	push   %eax
  8000ce:	2d 00 00 00 10       	sub    $0x10000000,%eax
  8000d3:	c1 e8 09             	shr    $0x9,%eax
  8000d6:	50                   	push   %eax
  8000d7:	e8 97 24 00 00       	call   802573 <sys_blk_read>
  8000dc:	83 c4 10             	add    $0x10,%esp
  8000df:	85 c0                	test   %eax,%eax
  8000e1:	0f 88 8a 00 00 00    	js     800171 <bc_pgfault+0x106>
		

	// Clear the dirty bit for the disk block page since we just read the
	// block from disk
	if ((r = sys_page_map(0, addr, 0, addr, uvpt[PGNUM(addr)] & PTE_SYSCALL)) < 0)
  8000e7:	89 d8                	mov    %ebx,%eax
  8000e9:	c1 e8 0c             	shr    $0xc,%eax
  8000ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8000f3:	83 ec 0c             	sub    $0xc,%esp
  8000f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8000fb:	50                   	push   %eax
  8000fc:	53                   	push   %ebx
  8000fd:	6a 00                	push   $0x0
  8000ff:	53                   	push   %ebx
  800100:	6a 00                	push   $0x0
  800102:	e8 3c 22 00 00       	call   802343 <sys_page_map>
  800107:	83 c4 20             	add    $0x20,%esp
  80010a:	85 c0                	test   %eax,%eax
  80010c:	78 79                	js     800187 <bc_pgfault+0x11c>
		panic("in bc_pgfault, sys_page_map: %e", r);

	// Check that the block we read was allocated. (exercise for
	// the reader: why do we do this *after* reading the block
	// in?)
	if (bitmap && block_is_free(blockno))
  80010e:	83 3d 04 a0 80 00 00 	cmpl   $0x0,0x80a004
  800115:	74 10                	je     800127 <bc_pgfault+0xbc>
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	56                   	push   %esi
  80011b:	e8 a6 03 00 00       	call   8004c6 <block_is_free>
  800120:	83 c4 10             	add    $0x10,%esp
  800123:	84 c0                	test   %al,%al
  800125:	75 72                	jne    800199 <bc_pgfault+0x12e>
		panic("reading free block %08x\n", blockno);
}
  800127:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012a:	5b                   	pop    %ebx
  80012b:	5e                   	pop    %esi
  80012c:	5d                   	pop    %ebp
  80012d:	c3                   	ret    
		panic("page fault in FS: eip %08x, va %08x, err %04x",
  80012e:	83 ec 08             	sub    $0x8,%esp
  800131:	ff 72 04             	pushl  0x4(%edx)
  800134:	53                   	push   %ebx
  800135:	ff 72 28             	pushl  0x28(%edx)
  800138:	68 24 37 80 00       	push   $0x803724
  80013d:	6a 27                	push   $0x27
  80013f:	68 98 38 80 00       	push   $0x803898
  800144:	e8 e7 16 00 00       	call   801830 <_panic>
		panic("reading non-existent block %08x\n", blockno);
  800149:	56                   	push   %esi
  80014a:	68 54 37 80 00       	push   $0x803754
  80014f:	6a 2b                	push   $0x2b
  800151:	68 98 38 80 00       	push   $0x803898
  800156:	e8 d5 16 00 00       	call   801830 <_panic>
	assert(sys_page_alloc(0, ROUNDDOWN(addr, PGSIZE), PTE_SYSCALL) == 0);
  80015b:	68 78 37 80 00       	push   $0x803778
  800160:	68 a0 38 80 00       	push   $0x8038a0
  800165:	6a 33                	push   $0x33
  800167:	68 98 38 80 00       	push   $0x803898
  80016c:	e8 bf 16 00 00       	call   801830 <_panic>
	assert(sys_blk_read((uint32_t) (diskaddr(blockno) - DISKMAP) / SECTSIZE, diskaddr(blockno), BLKSECTS) >= 0);
  800171:	68 b8 37 80 00       	push   $0x8037b8
  800176:	68 a0 38 80 00       	push   $0x8038a0
  80017b:	6a 34                	push   $0x34
  80017d:	68 98 38 80 00       	push   $0x803898
  800182:	e8 a9 16 00 00       	call   801830 <_panic>
		panic("in bc_pgfault, sys_page_map: %e", r);
  800187:	50                   	push   %eax
  800188:	68 1c 38 80 00       	push   $0x80381c
  80018d:	6a 3a                	push   $0x3a
  80018f:	68 98 38 80 00       	push   $0x803898
  800194:	e8 97 16 00 00       	call   801830 <_panic>
		panic("reading free block %08x\n", blockno);
  800199:	56                   	push   %esi
  80019a:	68 b5 38 80 00       	push   $0x8038b5
  80019f:	6a 40                	push   $0x40
  8001a1:	68 98 38 80 00       	push   $0x803898
  8001a6:	e8 85 16 00 00       	call   801830 <_panic>

008001ab <va_is_mapped>:
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
	return (uvpd[PDX(va)] & PTE_U) && (uvpt[PGNUM(va)] & PTE_U);
  8001ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b1:	c1 e8 16             	shr    $0x16,%eax
  8001b4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8001bb:	a8 04                	test   $0x4,%al
  8001bd:	74 18                	je     8001d7 <va_is_mapped+0x2c>
  8001bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c2:	c1 e8 0c             	shr    $0xc,%eax
  8001c5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8001cc:	c1 e8 02             	shr    $0x2,%eax
  8001cf:	83 e0 01             	and    $0x1,%eax
  8001d2:	83 e0 01             	and    $0x1,%eax
}
  8001d5:	5d                   	pop    %ebp
  8001d6:	c3                   	ret    
  8001d7:	b0 00                	mov    $0x0,%al
  8001d9:	eb f7                	jmp    8001d2 <va_is_mapped+0x27>

008001db <va_is_dirty>:
{
  8001db:	55                   	push   %ebp
  8001dc:	89 e5                	mov    %esp,%ebp
	return (uvpt[PGNUM(va)] & PTE_D) != 0;
  8001de:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e1:	c1 e8 0c             	shr    $0xc,%eax
  8001e4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8001eb:	c1 e8 06             	shr    $0x6,%eax
  8001ee:	83 e0 01             	and    $0x1,%eax
}
  8001f1:	5d                   	pop    %ebp
  8001f2:	c3                   	ret    

008001f3 <flush_block>:
// Hint: Use va_is_mapped, va_is_dirty, and sys_blk_write.
// Hint: Use the PTE_SYSCALL constant when calling sys_page_map.
// Hint: Don't forget to round addr down.
void
flush_block(void *addr)
{
  8001f3:	55                   	push   %ebp
  8001f4:	89 e5                	mov    %esp,%ebp
  8001f6:	57                   	push   %edi
  8001f7:	56                   	push   %esi
  8001f8:	53                   	push   %ebx
  8001f9:	83 ec 1c             	sub    $0x1c,%esp
  8001fc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	uint32_t blockno = ((uint32_t)addr - DISKMAP) / BLKSIZE;
  8001ff:	8d 83 00 00 00 f0    	lea    -0x10000000(%ebx),%eax
  800205:	89 c7                	mov    %eax,%edi
  800207:	c1 ef 0c             	shr    $0xc,%edi

	if (addr < (void*)DISKMAP || addr >= (void*)(DISKMAP + DISKSIZE))
  80020a:	3d ff ff ff bf       	cmp    $0xbfffffff,%eax
  80020f:	77 2b                	ja     80023c <flush_block+0x49>
		panic("flush_block of bad va %08x", addr);

	// LAB 5: Your code here.
	uint32_t sectno = ((uint32_t)diskaddr(blockno) - DISKMAP) / SECTSIZE;
  800211:	83 ec 0c             	sub    $0xc,%esp
  800214:	57                   	push   %edi
  800215:	e8 19 fe ff ff       	call   800033 <diskaddr>
  80021a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (va_is_mapped(ROUNDDOWN(addr, PGSIZE)) && va_is_dirty(ROUNDDOWN(addr, PGSIZE))) {
  80021d:	89 de                	mov    %ebx,%esi
  80021f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  800225:	89 34 24             	mov    %esi,(%esp)
  800228:	e8 7e ff ff ff       	call   8001ab <va_is_mapped>
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	84 c0                	test   %al,%al
  800232:	75 1a                	jne    80024e <flush_block+0x5b>
		assert(sys_blk_write(sectno, diskaddr(blockno), BLKSECTS) >= 0);
		sys_page_map(0, ROUNDDOWN(addr, PGSIZE), 0, ROUNDDOWN(addr, PGSIZE), uvpt[PGNUM(addr)] & PTE_SYSCALL);
	}
}
  800234:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800237:	5b                   	pop    %ebx
  800238:	5e                   	pop    %esi
  800239:	5f                   	pop    %edi
  80023a:	5d                   	pop    %ebp
  80023b:	c3                   	ret    
		panic("flush_block of bad va %08x", addr);
  80023c:	53                   	push   %ebx
  80023d:	68 ce 38 80 00       	push   $0x8038ce
  800242:	6a 50                	push   $0x50
  800244:	68 98 38 80 00       	push   $0x803898
  800249:	e8 e2 15 00 00       	call   801830 <_panic>
	if (va_is_mapped(ROUNDDOWN(addr, PGSIZE)) && va_is_dirty(ROUNDDOWN(addr, PGSIZE))) {
  80024e:	83 ec 0c             	sub    $0xc,%esp
  800251:	56                   	push   %esi
  800252:	e8 84 ff ff ff       	call   8001db <va_is_dirty>
  800257:	83 c4 10             	add    $0x10,%esp
  80025a:	84 c0                	test   %al,%al
  80025c:	74 d6                	je     800234 <flush_block+0x41>
		assert(sys_blk_write(sectno, diskaddr(blockno), BLKSECTS) >= 0);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	57                   	push   %edi
  800262:	e8 cc fd ff ff       	call   800033 <diskaddr>
  800267:	83 c4 0c             	add    $0xc,%esp
  80026a:	6a 08                	push   $0x8
  80026c:	50                   	push   %eax
	uint32_t sectno = ((uint32_t)diskaddr(blockno) - DISKMAP) / SECTSIZE;
  80026d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800270:	2d 00 00 00 10       	sub    $0x10000000,%eax
  800275:	c1 e8 09             	shr    $0x9,%eax
		assert(sys_blk_write(sectno, diskaddr(blockno), BLKSECTS) >= 0);
  800278:	50                   	push   %eax
  800279:	e8 d3 22 00 00       	call   802551 <sys_blk_write>
  80027e:	83 c4 10             	add    $0x10,%esp
  800281:	85 c0                	test   %eax,%eax
  800283:	78 23                	js     8002a8 <flush_block+0xb5>
		sys_page_map(0, ROUNDDOWN(addr, PGSIZE), 0, ROUNDDOWN(addr, PGSIZE), uvpt[PGNUM(addr)] & PTE_SYSCALL);
  800285:	c1 eb 0c             	shr    $0xc,%ebx
  800288:	8b 04 9d 00 00 40 ef 	mov    -0x10c00000(,%ebx,4),%eax
  80028f:	83 ec 0c             	sub    $0xc,%esp
  800292:	25 07 0e 00 00       	and    $0xe07,%eax
  800297:	50                   	push   %eax
  800298:	56                   	push   %esi
  800299:	6a 00                	push   $0x0
  80029b:	56                   	push   %esi
  80029c:	6a 00                	push   $0x0
  80029e:	e8 a0 20 00 00       	call   802343 <sys_page_map>
  8002a3:	83 c4 20             	add    $0x20,%esp
}
  8002a6:	eb 8c                	jmp    800234 <flush_block+0x41>
		assert(sys_blk_write(sectno, diskaddr(blockno), BLKSECTS) >= 0);
  8002a8:	68 3c 38 80 00       	push   $0x80383c
  8002ad:	68 a0 38 80 00       	push   $0x8038a0
  8002b2:	6a 55                	push   $0x55
  8002b4:	68 98 38 80 00       	push   $0x803898
  8002b9:	e8 72 15 00 00       	call   801830 <_panic>

008002be <bc_init>:
	cprintf("block cache is good\n");
}

void
bc_init(void)
{
  8002be:	55                   	push   %ebp
  8002bf:	89 e5                	mov    %esp,%ebp
  8002c1:	81 ec 24 02 00 00    	sub    $0x224,%esp
	struct Super super;
	set_pgfault_handler(bc_pgfault);
  8002c7:	68 6b 00 80 00       	push   $0x80006b
  8002cc:	e8 e4 22 00 00       	call   8025b5 <set_pgfault_handler>
	memmove(&backup, diskaddr(1), sizeof backup);
  8002d1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8002d8:	e8 56 fd ff ff       	call   800033 <diskaddr>
  8002dd:	83 c4 0c             	add    $0xc,%esp
  8002e0:	68 08 01 00 00       	push   $0x108
  8002e5:	50                   	push   %eax
  8002e6:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  8002ec:	50                   	push   %eax
  8002ed:	e8 cc 1d 00 00       	call   8020be <memmove>
	strcpy(diskaddr(1), "OOPS!\n");
  8002f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8002f9:	e8 35 fd ff ff       	call   800033 <diskaddr>
  8002fe:	83 c4 08             	add    $0x8,%esp
  800301:	68 e9 38 80 00       	push   $0x8038e9
  800306:	50                   	push   %eax
  800307:	e8 3f 1c 00 00       	call   801f4b <strcpy>
	flush_block(diskaddr(1));
  80030c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800313:	e8 1b fd ff ff       	call   800033 <diskaddr>
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	e8 d3 fe ff ff       	call   8001f3 <flush_block>
	assert(va_is_mapped(diskaddr(1)));
  800320:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800327:	e8 07 fd ff ff       	call   800033 <diskaddr>
  80032c:	89 04 24             	mov    %eax,(%esp)
  80032f:	e8 77 fe ff ff       	call   8001ab <va_is_mapped>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	84 c0                	test   %al,%al
  800339:	0f 84 d9 00 00 00    	je     800418 <bc_init+0x15a>
	assert(!va_is_dirty(diskaddr(1)));
  80033f:	83 ec 0c             	sub    $0xc,%esp
  800342:	6a 01                	push   $0x1
  800344:	e8 ea fc ff ff       	call   800033 <diskaddr>
  800349:	89 04 24             	mov    %eax,(%esp)
  80034c:	e8 8a fe ff ff       	call   8001db <va_is_dirty>
  800351:	83 c4 10             	add    $0x10,%esp
  800354:	84 c0                	test   %al,%al
  800356:	0f 85 d2 00 00 00    	jne    80042e <bc_init+0x170>
	sys_page_unmap(0, diskaddr(1));
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	6a 01                	push   $0x1
  800361:	e8 cd fc ff ff       	call   800033 <diskaddr>
  800366:	83 c4 08             	add    $0x8,%esp
  800369:	50                   	push   %eax
  80036a:	6a 00                	push   $0x0
  80036c:	e8 14 20 00 00       	call   802385 <sys_page_unmap>
	assert(!va_is_mapped(diskaddr(1)));
  800371:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800378:	e8 b6 fc ff ff       	call   800033 <diskaddr>
  80037d:	89 04 24             	mov    %eax,(%esp)
  800380:	e8 26 fe ff ff       	call   8001ab <va_is_mapped>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	84 c0                	test   %al,%al
  80038a:	0f 85 b4 00 00 00    	jne    800444 <bc_init+0x186>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  800390:	83 ec 0c             	sub    $0xc,%esp
  800393:	6a 01                	push   $0x1
  800395:	e8 99 fc ff ff       	call   800033 <diskaddr>
  80039a:	83 c4 08             	add    $0x8,%esp
  80039d:	68 e9 38 80 00       	push   $0x8038e9
  8003a2:	50                   	push   %eax
  8003a3:	e8 40 1c 00 00       	call   801fe8 <strcmp>
  8003a8:	83 c4 10             	add    $0x10,%esp
  8003ab:	85 c0                	test   %eax,%eax
  8003ad:	0f 85 a7 00 00 00    	jne    80045a <bc_init+0x19c>
	memmove(diskaddr(1), &backup, sizeof backup);
  8003b3:	83 ec 0c             	sub    $0xc,%esp
  8003b6:	6a 01                	push   $0x1
  8003b8:	e8 76 fc ff ff       	call   800033 <diskaddr>
  8003bd:	83 c4 0c             	add    $0xc,%esp
  8003c0:	68 08 01 00 00       	push   $0x108
  8003c5:	8d 95 e8 fd ff ff    	lea    -0x218(%ebp),%edx
  8003cb:	52                   	push   %edx
  8003cc:	50                   	push   %eax
  8003cd:	e8 ec 1c 00 00       	call   8020be <memmove>
	flush_block(diskaddr(1));
  8003d2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003d9:	e8 55 fc ff ff       	call   800033 <diskaddr>
  8003de:	89 04 24             	mov    %eax,(%esp)
  8003e1:	e8 0d fe ff ff       	call   8001f3 <flush_block>
	cprintf("block cache is good\n");
  8003e6:	c7 04 24 25 39 80 00 	movl   $0x803925,(%esp)
  8003ed:	e8 51 15 00 00       	call   801943 <cprintf>
	check_bc();

	// cache the super block by reading it once
	memmove(&super, diskaddr(1), sizeof super);
  8003f2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8003f9:	e8 35 fc ff ff       	call   800033 <diskaddr>
  8003fe:	83 c4 0c             	add    $0xc,%esp
  800401:	68 08 01 00 00       	push   $0x108
  800406:	50                   	push   %eax
  800407:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80040d:	50                   	push   %eax
  80040e:	e8 ab 1c 00 00       	call   8020be <memmove>
}
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	c9                   	leave  
  800417:	c3                   	ret    
	assert(va_is_mapped(diskaddr(1)));
  800418:	68 0b 39 80 00       	push   $0x80390b
  80041d:	68 a0 38 80 00       	push   $0x8038a0
  800422:	6a 67                	push   $0x67
  800424:	68 98 38 80 00       	push   $0x803898
  800429:	e8 02 14 00 00       	call   801830 <_panic>
	assert(!va_is_dirty(diskaddr(1)));
  80042e:	68 f0 38 80 00       	push   $0x8038f0
  800433:	68 a0 38 80 00       	push   $0x8038a0
  800438:	6a 68                	push   $0x68
  80043a:	68 98 38 80 00       	push   $0x803898
  80043f:	e8 ec 13 00 00       	call   801830 <_panic>
	assert(!va_is_mapped(diskaddr(1)));
  800444:	68 0a 39 80 00       	push   $0x80390a
  800449:	68 a0 38 80 00       	push   $0x8038a0
  80044e:	6a 6c                	push   $0x6c
  800450:	68 98 38 80 00       	push   $0x803898
  800455:	e8 d6 13 00 00       	call   801830 <_panic>
	assert(strcmp(diskaddr(1), "OOPS!\n") == 0);
  80045a:	68 74 38 80 00       	push   $0x803874
  80045f:	68 a0 38 80 00       	push   $0x8038a0
  800464:	6a 6f                	push   $0x6f
  800466:	68 98 38 80 00       	push   $0x803898
  80046b:	e8 c0 13 00 00       	call   801830 <_panic>

00800470 <check_super>:
// --------------------------------------------------------------

// Validate the file system super-block.
void
check_super(void)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	if (super->s_magic != FS_MAGIC)
  800476:	a1 08 a0 80 00       	mov    0x80a008,%eax
  80047b:	81 38 ae 30 05 4a    	cmpl   $0x4a0530ae,(%eax)
  800481:	75 1b                	jne    80049e <check_super+0x2e>
		panic("bad file system magic number");

	if (super->s_nblocks > DISKSIZE/BLKSIZE)
  800483:	81 78 04 00 00 0c 00 	cmpl   $0xc0000,0x4(%eax)
  80048a:	77 26                	ja     8004b2 <check_super+0x42>
		panic("file system is too large");

	cprintf("superblock is good\n");
  80048c:	83 ec 0c             	sub    $0xc,%esp
  80048f:	68 78 39 80 00       	push   $0x803978
  800494:	e8 aa 14 00 00       	call   801943 <cprintf>
}
  800499:	83 c4 10             	add    $0x10,%esp
  80049c:	c9                   	leave  
  80049d:	c3                   	ret    
		panic("bad file system magic number");
  80049e:	83 ec 04             	sub    $0x4,%esp
  8004a1:	68 3a 39 80 00       	push   $0x80393a
  8004a6:	6a 0e                	push   $0xe
  8004a8:	68 57 39 80 00       	push   $0x803957
  8004ad:	e8 7e 13 00 00       	call   801830 <_panic>
		panic("file system is too large");
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 5f 39 80 00       	push   $0x80395f
  8004ba:	6a 11                	push   $0x11
  8004bc:	68 57 39 80 00       	push   $0x803957
  8004c1:	e8 6a 13 00 00       	call   801830 <_panic>

008004c6 <block_is_free>:

// Check to see if the block bitmap indicates that block 'blockno' is free.
// Return 1 if the block is free, 0 if not.
bool
block_is_free(uint32_t blockno)
{
  8004c6:	55                   	push   %ebp
  8004c7:	89 e5                	mov    %esp,%ebp
  8004c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	if (super == 0 || blockno >= super->s_nblocks)
  8004cc:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8004d1:	85 c0                	test   %eax,%eax
  8004d3:	74 19                	je     8004ee <block_is_free+0x28>
  8004d5:	39 48 04             	cmp    %ecx,0x4(%eax)
  8004d8:	76 18                	jbe    8004f2 <block_is_free+0x2c>
		return 0;
	if (bitmap[blockno / 32] & BIT(blockno % 32))
  8004da:	89 ca                	mov    %ecx,%edx
  8004dc:	c1 ea 05             	shr    $0x5,%edx
  8004df:	a1 04 a0 80 00       	mov    0x80a004,%eax
  8004e4:	8b 04 90             	mov    (%eax,%edx,4),%eax
  8004e7:	d3 e8                	shr    %cl,%eax
  8004e9:	83 e0 01             	and    $0x1,%eax
		return 1;
	return 0;
}
  8004ec:	5d                   	pop    %ebp
  8004ed:	c3                   	ret    
		return 0;
  8004ee:	b0 00                	mov    $0x0,%al
  8004f0:	eb fa                	jmp    8004ec <block_is_free+0x26>
  8004f2:	b0 00                	mov    $0x0,%al
  8004f4:	eb f6                	jmp    8004ec <block_is_free+0x26>

008004f6 <free_block>:

// Mark a block free in the bitmap
void
free_block(uint32_t blockno)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
  8004f9:	53                   	push   %ebx
  8004fa:	83 ec 04             	sub    $0x4,%esp
  8004fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	// Blockno zero is the null pointer of block numbers.
	if (blockno == 0)
  800500:	85 c9                	test   %ecx,%ecx
  800502:	74 1a                	je     80051e <free_block+0x28>
		panic("attempt to free zero block");
	bitmap[blockno / 32] |= BIT(blockno % 32);
  800504:	89 cb                	mov    %ecx,%ebx
  800506:	c1 eb 05             	shr    $0x5,%ebx
  800509:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80050f:	b8 01 00 00 00       	mov    $0x1,%eax
  800514:	d3 e0                	shl    %cl,%eax
  800516:	09 04 9a             	or     %eax,(%edx,%ebx,4)
}
  800519:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    
		panic("attempt to free zero block");
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	68 8c 39 80 00       	push   $0x80398c
  800526:	6a 2c                	push   $0x2c
  800528:	68 57 39 80 00       	push   $0x803957
  80052d:	e8 fe 12 00 00       	call   801830 <_panic>

00800532 <alloc_block>:
// -E_NO_DISK if we are out of blocks.
//
// Hint: use free_block as an example for manipulating the bitmap.
int
alloc_block(void)
{
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	57                   	push   %edi
  800536:	56                   	push   %esi
  800537:	53                   	push   %ebx
  800538:	83 ec 0c             	sub    $0xc,%esp
	// The bitmap consists of one or more blocks.  A single bitmap block
	// contains the in-use bits for BLKBITSIZE blocks.  There are
	// super->s_nblocks blocks in the disk altogether.

	// LAB 5: Your code here.
	for (int i = 3; i < super->s_nblocks; i++) {
  80053b:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800540:	8b 70 04             	mov    0x4(%eax),%esi
  800543:	bb 03 00 00 00       	mov    $0x3,%ebx
  800548:	89 df                	mov    %ebx,%edi
  80054a:	39 de                	cmp    %ebx,%esi
  80054c:	76 57                	jbe    8005a5 <alloc_block+0x73>
		if (block_is_free(i)) {
  80054e:	53                   	push   %ebx
  80054f:	e8 72 ff ff ff       	call   8004c6 <block_is_free>
  800554:	83 c4 04             	add    $0x4,%esp
  800557:	84 c0                	test   %al,%al
  800559:	75 03                	jne    80055e <alloc_block+0x2c>
	for (int i = 3; i < super->s_nblocks; i++) {
  80055b:	43                   	inc    %ebx
  80055c:	eb ea                	jmp    800548 <alloc_block+0x16>
			bitmap[i / 32] &= ~(BIT(i % 32));
  80055e:	89 d8                	mov    %ebx,%eax
  800560:	85 db                	test   %ebx,%ebx
  800562:	78 35                	js     800599 <alloc_block+0x67>
  800564:	c1 f8 05             	sar    $0x5,%eax
  800567:	8b 15 04 a0 80 00    	mov    0x80a004,%edx
  80056d:	8d 14 82             	lea    (%edx,%eax,4),%edx
  800570:	89 d9                	mov    %ebx,%ecx
  800572:	81 e1 1f 00 00 80    	and    $0x8000001f,%ecx
  800578:	78 24                	js     80059e <alloc_block+0x6c>
  80057a:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
  80057f:	d3 c0                	rol    %cl,%eax
  800581:	21 02                	and    %eax,(%edx)
			flush_block(diskaddr(i));
  800583:	83 ec 0c             	sub    $0xc,%esp
  800586:	57                   	push   %edi
  800587:	e8 a7 fa ff ff       	call   800033 <diskaddr>
  80058c:	89 04 24             	mov    %eax,(%esp)
  80058f:	e8 5f fc ff ff       	call   8001f3 <flush_block>
			return i;
  800594:	83 c4 10             	add    $0x10,%esp
  800597:	eb 11                	jmp    8005aa <alloc_block+0x78>
			bitmap[i / 32] &= ~(BIT(i % 32));
  800599:	8d 43 1f             	lea    0x1f(%ebx),%eax
  80059c:	eb c6                	jmp    800564 <alloc_block+0x32>
  80059e:	49                   	dec    %ecx
  80059f:	83 c9 e0             	or     $0xffffffe0,%ecx
  8005a2:	41                   	inc    %ecx
  8005a3:	eb d5                	jmp    80057a <alloc_block+0x48>
		}
	}
	return -E_NO_DISK;
  8005a5:	bb f7 ff ff ff       	mov    $0xfffffff7,%ebx
}
  8005aa:	89 d8                	mov    %ebx,%eax
  8005ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005af:	5b                   	pop    %ebx
  8005b0:	5e                   	pop    %esi
  8005b1:	5f                   	pop    %edi
  8005b2:	5d                   	pop    %ebp
  8005b3:	c3                   	ret    

008005b4 <file_block_walk>:
//
// Analogy: This is like pgdir_walk for files.
// Hint: Don't forget to clear any block you allocate.
static int
file_block_walk(struct File *f, uint32_t filebno, uint32_t **ppdiskbno, bool alloc)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	57                   	push   %edi
  8005b8:	56                   	push   %esi
  8005b9:	53                   	push   %ebx
  8005ba:	83 ec 1c             	sub    $0x1c,%esp
  8005bd:	8b 5d 08             	mov    0x8(%ebp),%ebx
    // LAB 5: Your code here.
	if (filebno >= NDIRECT + NINDIRECT)
  8005c0:	81 fa 09 04 00 00    	cmp    $0x409,%edx
  8005c6:	0f 87 a3 00 00 00    	ja     80066f <file_block_walk+0xbb>
		return -E_INVAL;
	if (filebno < NINDIRECT) {
  8005cc:	81 fa ff 03 00 00    	cmp    $0x3ff,%edx
  8005d2:	77 1e                	ja     8005f2 <file_block_walk+0x3e>
		if (ppdiskbno)
  8005d4:	85 c9                	test   %ecx,%ecx
  8005d6:	0f 84 9d 00 00 00    	je     800679 <file_block_walk+0xc5>
			*ppdiskbno = &f->f_direct[filebno];
  8005dc:	8d 84 90 88 00 00 00 	lea    0x88(%eax,%edx,4),%eax
  8005e3:	89 01                	mov    %eax,(%ecx)
		return 0;
  8005e5:	b8 00 00 00 00       	mov    $0x0,%eax
		*ppdiskbno =  tmp[filebno];
	}
	return 0;
	
    
}
  8005ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005ed:	5b                   	pop    %ebx
  8005ee:	5e                   	pop    %esi
  8005ef:	5f                   	pop    %edi
  8005f0:	5d                   	pop    %ebp
  8005f1:	c3                   	ret    
  8005f2:	89 ce                	mov    %ecx,%esi
  8005f4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  8005f7:	89 c7                	mov    %eax,%edi
	if (!new_dir) {
  8005f9:	83 b8 b0 00 00 00 00 	cmpl   $0x0,0xb0(%eax)
  800600:	75 45                	jne    800647 <file_block_walk+0x93>
		if (!alloc) {
  800602:	84 db                	test   %bl,%bl
  800604:	74 7d                	je     800683 <file_block_walk+0xcf>
		int blk_num = alloc_block();
  800606:	e8 27 ff ff ff       	call   800532 <alloc_block>
		if (blk_num < 0) {
  80060b:	85 c0                	test   %eax,%eax
  80060d:	78 7e                	js     80068d <file_block_walk+0xd9>
		f->f_indirect = blk_num;
  80060f:	89 87 b0 00 00 00    	mov    %eax,0xb0(%edi)
		memset(diskaddr(f->f_indirect), 0, BLKSIZE);
  800615:	83 ec 0c             	sub    $0xc,%esp
  800618:	50                   	push   %eax
  800619:	e8 15 fa ff ff       	call   800033 <diskaddr>
  80061e:	83 c4 0c             	add    $0xc,%esp
  800621:	68 00 10 00 00       	push   $0x1000
  800626:	6a 00                	push   $0x0
  800628:	50                   	push   %eax
  800629:	e8 43 1a 00 00       	call   802071 <memset>
		flush_block(diskaddr(f->f_indirect));
  80062e:	83 c4 04             	add    $0x4,%esp
  800631:	ff b7 b0 00 00 00    	pushl  0xb0(%edi)
  800637:	e8 f7 f9 ff ff       	call   800033 <diskaddr>
  80063c:	89 04 24             	mov    %eax,(%esp)
  80063f:	e8 af fb ff ff       	call   8001f3 <flush_block>
  800644:	83 c4 10             	add    $0x10,%esp
	if (ppdiskbno) {
  800647:	85 f6                	test   %esi,%esi
  800649:	74 4c                	je     800697 <file_block_walk+0xe3>
		uint32_t** tmp = (uint32_t**) diskaddr(f->f_indirect);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	ff b7 b0 00 00 00    	pushl  0xb0(%edi)
  800654:	e8 da f9 ff ff       	call   800033 <diskaddr>
		*ppdiskbno =  tmp[filebno];
  800659:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80065c:	8b 44 98 d8          	mov    -0x28(%eax,%ebx,4),%eax
  800660:	89 06                	mov    %eax,(%esi)
  800662:	83 c4 10             	add    $0x10,%esp
	return 0;
  800665:	b8 00 00 00 00       	mov    $0x0,%eax
  80066a:	e9 7b ff ff ff       	jmp    8005ea <file_block_walk+0x36>
		return -E_INVAL;
  80066f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800674:	e9 71 ff ff ff       	jmp    8005ea <file_block_walk+0x36>
		return 0;
  800679:	b8 00 00 00 00       	mov    $0x0,%eax
  80067e:	e9 67 ff ff ff       	jmp    8005ea <file_block_walk+0x36>
			return -E_NOT_FOUND;
  800683:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800688:	e9 5d ff ff ff       	jmp    8005ea <file_block_walk+0x36>
			return -E_NO_DISK;
  80068d:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  800692:	e9 53 ff ff ff       	jmp    8005ea <file_block_walk+0x36>
	return 0;
  800697:	b8 00 00 00 00       	mov    $0x0,%eax
  80069c:	e9 49 ff ff ff       	jmp    8005ea <file_block_walk+0x36>

008006a1 <check_bitmap>:
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	57                   	push   %edi
  8006a5:	56                   	push   %esi
  8006a6:	53                   	push   %ebx
  8006a7:	83 ec 0c             	sub    $0xc,%esp
	for (i = 0; i * BLKBITSIZE < super->s_nblocks; i++)
  8006aa:	a1 08 a0 80 00       	mov    0x80a008,%eax
  8006af:	8b 78 04             	mov    0x4(%eax),%edi
  8006b2:	be 02 00 00 00       	mov    $0x2,%esi
  8006b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bc:	39 fb                	cmp    %edi,%ebx
  8006be:	73 2a                	jae    8006ea <check_bitmap+0x49>
		assert(!block_is_free(2+i));
  8006c0:	56                   	push   %esi
  8006c1:	e8 00 fe ff ff       	call   8004c6 <block_is_free>
  8006c6:	83 c4 04             	add    $0x4,%esp
  8006c9:	81 c3 00 80 00 00    	add    $0x8000,%ebx
  8006cf:	46                   	inc    %esi
  8006d0:	84 c0                	test   %al,%al
  8006d2:	74 e8                	je     8006bc <check_bitmap+0x1b>
  8006d4:	68 a7 39 80 00       	push   $0x8039a7
  8006d9:	68 a0 38 80 00       	push   $0x8038a0
  8006de:	6a 55                	push   $0x55
  8006e0:	68 57 39 80 00       	push   $0x803957
  8006e5:	e8 46 11 00 00       	call   801830 <_panic>
	assert(!block_is_free(0));
  8006ea:	83 ec 0c             	sub    $0xc,%esp
  8006ed:	6a 00                	push   $0x0
  8006ef:	e8 d2 fd ff ff       	call   8004c6 <block_is_free>
  8006f4:	83 c4 10             	add    $0x10,%esp
  8006f7:	84 c0                	test   %al,%al
  8006f9:	75 29                	jne    800724 <check_bitmap+0x83>
	assert(!block_is_free(1));
  8006fb:	83 ec 0c             	sub    $0xc,%esp
  8006fe:	6a 01                	push   $0x1
  800700:	e8 c1 fd ff ff       	call   8004c6 <block_is_free>
  800705:	83 c4 10             	add    $0x10,%esp
  800708:	84 c0                	test   %al,%al
  80070a:	75 2e                	jne    80073a <check_bitmap+0x99>
	cprintf("bitmap is good\n");
  80070c:	83 ec 0c             	sub    $0xc,%esp
  80070f:	68 df 39 80 00       	push   $0x8039df
  800714:	e8 2a 12 00 00       	call   801943 <cprintf>
}
  800719:	83 c4 10             	add    $0x10,%esp
  80071c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80071f:	5b                   	pop    %ebx
  800720:	5e                   	pop    %esi
  800721:	5f                   	pop    %edi
  800722:	5d                   	pop    %ebp
  800723:	c3                   	ret    
	assert(!block_is_free(0));
  800724:	68 bb 39 80 00       	push   $0x8039bb
  800729:	68 a0 38 80 00       	push   $0x8038a0
  80072e:	6a 58                	push   $0x58
  800730:	68 57 39 80 00       	push   $0x803957
  800735:	e8 f6 10 00 00       	call   801830 <_panic>
	assert(!block_is_free(1));
  80073a:	68 cd 39 80 00       	push   $0x8039cd
  80073f:	68 a0 38 80 00       	push   $0x8038a0
  800744:	6a 59                	push   $0x59
  800746:	68 57 39 80 00       	push   $0x803957
  80074b:	e8 e0 10 00 00       	call   801830 <_panic>

00800750 <fs_init>:
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	83 ec 08             	sub    $0x8,%esp
	bc_init();
  800756:	e8 63 fb ff ff       	call   8002be <bc_init>
	super = diskaddr(1);
  80075b:	83 ec 0c             	sub    $0xc,%esp
  80075e:	6a 01                	push   $0x1
  800760:	e8 ce f8 ff ff       	call   800033 <diskaddr>
  800765:	a3 08 a0 80 00       	mov    %eax,0x80a008
	check_super();
  80076a:	e8 01 fd ff ff       	call   800470 <check_super>
	bitmap = diskaddr(2);
  80076f:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800776:	e8 b8 f8 ff ff       	call   800033 <diskaddr>
  80077b:	a3 04 a0 80 00       	mov    %eax,0x80a004
	check_bitmap();
  800780:	e8 1c ff ff ff       	call   8006a1 <check_bitmap>
}
  800785:	83 c4 10             	add    $0x10,%esp
  800788:	c9                   	leave  
  800789:	c3                   	ret    

0080078a <file_get_block>:
//	-E_INVAL if filebno is out of range.
//
// Hint: Use file_block_walk and alloc_block.
int
file_get_block(struct File *f, uint32_t filebno, char **blk)
{
  80078a:	55                   	push   %ebp
  80078b:	89 e5                	mov    %esp,%ebp
  80078d:	83 ec 18             	sub    $0x18,%esp
  800790:	8b 55 0c             	mov    0xc(%ebp),%edx
    // LAB 5: Your code here.
	uint32_t* ppdiskbno;
	if (filebno > NDIRECT + NINDIRECT)
  800793:	81 fa 0a 04 00 00    	cmp    $0x40a,%edx
  800799:	77 49                	ja     8007e4 <file_get_block+0x5a>
		return -E_INVAL;

    if (file_block_walk(f, filebno, &ppdiskbno, true) < 0)
  80079b:	83 ec 0c             	sub    $0xc,%esp
  80079e:	6a 01                	push   $0x1
  8007a0:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	e8 09 fe ff ff       	call   8005b4 <file_block_walk>
  8007ab:	83 c4 10             	add    $0x10,%esp
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	78 39                	js     8007eb <file_get_block+0x61>
    	return -E_NO_DISK;

    if (!*ppdiskbno) {
  8007b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007b5:	83 38 00             	cmpl   $0x0,(%eax)
  8007b8:	75 0e                	jne    8007c8 <file_get_block+0x3e>
    	int res = alloc_block();
  8007ba:	e8 73 fd ff ff       	call   800532 <alloc_block>
    	if (res < 0) {
  8007bf:	85 c0                	test   %eax,%eax
  8007c1:	78 2f                	js     8007f2 <file_get_block+0x68>
    		return -E_NO_DISK;
    	}
    	*ppdiskbno = res;
  8007c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c6:	89 02                	mov    %eax,(%edx)
    }
    *blk = (char*) diskaddr(*ppdiskbno);
  8007c8:	83 ec 0c             	sub    $0xc,%esp
  8007cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007ce:	ff 30                	pushl  (%eax)
  8007d0:	e8 5e f8 ff ff       	call   800033 <diskaddr>
  8007d5:	8b 55 10             	mov    0x10(%ebp),%edx
  8007d8:	89 02                	mov    %eax,(%edx)
    return 0;
  8007da:	83 c4 10             	add    $0x10,%esp
  8007dd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8007e2:	c9                   	leave  
  8007e3:	c3                   	ret    
		return -E_INVAL;
  8007e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e9:	eb f7                	jmp    8007e2 <file_get_block+0x58>
    	return -E_NO_DISK;
  8007eb:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8007f0:	eb f0                	jmp    8007e2 <file_get_block+0x58>
    		return -E_NO_DISK;
  8007f2:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
  8007f7:	eb e9                	jmp    8007e2 <file_get_block+0x58>

008007f9 <walk_path>:
// If we cannot find the file but find the directory
// it should be in, set *pdir and copy the final path
// element into lastelem.
static int
walk_path(const char *path, struct File **pdir, struct File **pf, char *lastelem)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	57                   	push   %edi
  8007fd:	56                   	push   %esi
  8007fe:	53                   	push   %ebx
  8007ff:	81 ec bc 00 00 00    	sub    $0xbc,%esp
  800805:	89 95 40 ff ff ff    	mov    %edx,-0xc0(%ebp)
  80080b:	89 8d 3c ff ff ff    	mov    %ecx,-0xc4(%ebp)
  800811:	eb 01                	jmp    800814 <walk_path+0x1b>
		p++;
  800813:	40                   	inc    %eax
	while (*p == '/')
  800814:	80 38 2f             	cmpb   $0x2f,(%eax)
  800817:	74 fa                	je     800813 <walk_path+0x1a>
	int r;

	// if (*path != '/')
	//	return -E_BAD_PATH;
	path = skip_slash(path);
	f = &super->s_root;
  800819:	8b 0d 08 a0 80 00    	mov    0x80a008,%ecx
  80081f:	83 c1 08             	add    $0x8,%ecx
  800822:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	dir = 0;
	name[0] = 0;
  800828:	c6 85 68 ff ff ff 00 	movb   $0x0,-0x98(%ebp)

	if (pdir)
  80082f:	8b 8d 40 ff ff ff    	mov    -0xc0(%ebp),%ecx
  800835:	85 c9                	test   %ecx,%ecx
  800837:	74 06                	je     80083f <walk_path+0x46>
		*pdir = 0;
  800839:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	*pf = 0;
  80083f:	8b 8d 3c ff ff ff    	mov    -0xc4(%ebp),%ecx
  800845:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	dir = 0;
  80084b:	ba 00 00 00 00       	mov    $0x0,%edx
	while (*path != '\0') {
  800850:	e9 c9 01 00 00       	jmp    800a1e <walk_path+0x225>
		dir = f;
		p = path;
		while (*path != '/' && *path != '\0')
			path++;
  800855:	47                   	inc    %edi
		while (*path != '/' && *path != '\0')
  800856:	8a 17                	mov    (%edi),%dl
  800858:	80 fa 2f             	cmp    $0x2f,%dl
  80085b:	74 04                	je     800861 <walk_path+0x68>
  80085d:	84 d2                	test   %dl,%dl
  80085f:	75 f4                	jne    800855 <walk_path+0x5c>
		if (path - p >= MAXNAMELEN)
  800861:	89 fb                	mov    %edi,%ebx
  800863:	29 c3                	sub    %eax,%ebx
  800865:	83 fb 7f             	cmp    $0x7f,%ebx
  800868:	0f 8f 81 01 00 00    	jg     8009ef <walk_path+0x1f6>
			return -E_BAD_PATH;
		memmove(name, p, path - p);
  80086e:	83 ec 04             	sub    $0x4,%esp
  800871:	53                   	push   %ebx
  800872:	50                   	push   %eax
  800873:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800879:	50                   	push   %eax
  80087a:	e8 3f 18 00 00       	call   8020be <memmove>
		name[path - p] = '\0';
  80087f:	c6 84 1d 68 ff ff ff 	movb   $0x0,-0x98(%ebp,%ebx,1)
  800886:	00 
  800887:	83 c4 10             	add    $0x10,%esp
  80088a:	eb 01                	jmp    80088d <walk_path+0x94>
		p++;
  80088c:	47                   	inc    %edi
	while (*p == '/')
  80088d:	80 3f 2f             	cmpb   $0x2f,(%edi)
  800890:	74 fa                	je     80088c <walk_path+0x93>
		path = skip_slash(path);

		if (!FTYPE_ISDIR(dir->f_type))
  800892:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  800898:	8b 81 84 00 00 00    	mov    0x84(%ecx),%eax
  80089e:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
  8008a4:	25 00 f0 00 00       	and    $0xf000,%eax
  8008a9:	3d 00 40 00 00       	cmp    $0x4000,%eax
  8008ae:	0f 85 42 01 00 00    	jne    8009f6 <walk_path+0x1fd>
	assert((dir->f_size % BLKSIZE) == 0);
  8008b4:	8b 81 80 00 00 00    	mov    0x80(%ecx),%eax
  8008ba:	a9 ff 0f 00 00       	test   $0xfff,%eax
  8008bf:	0f 85 9a 00 00 00    	jne    80095f <walk_path+0x166>
	nblock = dir->f_size / BLKSIZE;
  8008c5:	89 c2                	mov    %eax,%edx
  8008c7:	85 c0                	test   %eax,%eax
  8008c9:	0f 88 a9 00 00 00    	js     800978 <walk_path+0x17f>
  8008cf:	c1 fa 0c             	sar    $0xc,%edx
  8008d2:	89 95 48 ff ff ff    	mov    %edx,-0xb8(%ebp)
	for (i = 0; i < nblock; i++) {
  8008d8:	c7 85 50 ff ff ff 00 	movl   $0x0,-0xb0(%ebp)
  8008df:	00 00 00 
			if (strcmp(f[j].f_name, name) == 0) {
  8008e2:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  8008e8:	89 bd 44 ff ff ff    	mov    %edi,-0xbc(%ebp)
	for (i = 0; i < nblock; i++) {
  8008ee:	8b 8d 50 ff ff ff    	mov    -0xb0(%ebp),%ecx
  8008f4:	39 8d 48 ff ff ff    	cmp    %ecx,-0xb8(%ebp)
  8008fa:	0f 84 83 00 00 00    	je     800983 <walk_path+0x18a>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800900:	83 ec 04             	sub    $0x4,%esp
  800903:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
  800909:	50                   	push   %eax
  80090a:	ff b5 50 ff ff ff    	pushl  -0xb0(%ebp)
  800910:	ff b5 4c ff ff ff    	pushl  -0xb4(%ebp)
  800916:	e8 6f fe ff ff       	call   80078a <file_get_block>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	85 c0                	test   %eax,%eax
  800920:	0f 88 04 01 00 00    	js     800a2a <walk_path+0x231>
		f = (struct File*) blk;
  800926:	8b 9d 64 ff ff ff    	mov    -0x9c(%ebp),%ebx
  80092c:	8d bb 00 10 00 00    	lea    0x1000(%ebx),%edi
			if (strcmp(f[j].f_name, name) == 0) {
  800932:	89 9d 54 ff ff ff    	mov    %ebx,-0xac(%ebp)
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	56                   	push   %esi
  80093c:	53                   	push   %ebx
  80093d:	e8 a6 16 00 00       	call   801fe8 <strcmp>
  800942:	83 c4 10             	add    $0x10,%esp
  800945:	85 c0                	test   %eax,%eax
  800947:	0f 84 b7 00 00 00    	je     800a04 <walk_path+0x20b>
  80094d:	81 c3 00 01 00 00    	add    $0x100,%ebx
		for (j = 0; j < BLKFILES; j++)
  800953:	39 fb                	cmp    %edi,%ebx
  800955:	75 db                	jne    800932 <walk_path+0x139>
	for (i = 0; i < nblock; i++) {
  800957:	ff 85 50 ff ff ff    	incl   -0xb0(%ebp)
  80095d:	eb 8f                	jmp    8008ee <walk_path+0xf5>
	assert((dir->f_size % BLKSIZE) == 0);
  80095f:	68 ef 39 80 00       	push   $0x8039ef
  800964:	68 a0 38 80 00       	push   $0x8038a0
  800969:	68 d8 00 00 00       	push   $0xd8
  80096e:	68 57 39 80 00       	push   $0x803957
  800973:	e8 b8 0e 00 00       	call   801830 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800978:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  80097e:	e9 4c ff ff ff       	jmp    8008cf <walk_path+0xd6>
  800983:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			return -E_NOT_FOUND;

		if ((r = dir_lookup(dir, name, &f)) < 0) {
			if (r == -E_NOT_FOUND && *path == '\0') {
  800989:	80 3e 00             	cmpb   $0x0,(%esi)
  80098c:	75 6f                	jne    8009fd <walk_path+0x204>
				if (pdir)
  80098e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  800994:	85 c0                	test   %eax,%eax
  800996:	74 08                	je     8009a0 <walk_path+0x1a7>
					*pdir = dir;
  800998:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  80099e:	89 08                	mov    %ecx,(%eax)
				if (lastelem)
  8009a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a4:	74 15                	je     8009bb <walk_path+0x1c2>
					strcpy(lastelem, name);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	ff 75 08             	pushl  0x8(%ebp)
  8009b3:	e8 93 15 00 00       	call   801f4b <strcpy>
  8009b8:	83 c4 10             	add    $0x10,%esp
				*pf = 0;
  8009bb:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8009c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
			}
			return r;
  8009c7:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009cc:	eb 6b                	jmp    800a39 <walk_path+0x240>
		}
	}

	if (pdir)
  8009ce:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  8009d4:	85 c0                	test   %eax,%eax
  8009d6:	74 02                	je     8009da <walk_path+0x1e1>
		*pdir = dir;
  8009d8:	89 10                	mov    %edx,(%eax)
	*pf = f;
  8009da:	8b 85 3c ff ff ff    	mov    -0xc4(%ebp),%eax
  8009e0:	8b 8d 4c ff ff ff    	mov    -0xb4(%ebp),%ecx
  8009e6:	89 08                	mov    %ecx,(%eax)
	return 0;
  8009e8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ed:	eb 4a                	jmp    800a39 <walk_path+0x240>
			return -E_BAD_PATH;
  8009ef:	b8 f4 ff ff ff       	mov    $0xfffffff4,%eax
  8009f4:	eb 43                	jmp    800a39 <walk_path+0x240>
			return -E_NOT_FOUND;
  8009f6:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  8009fb:	eb 3c                	jmp    800a39 <walk_path+0x240>
			return r;
  8009fd:	b8 f5 ff ff ff       	mov    $0xfffffff5,%eax
  800a02:	eb 35                	jmp    800a39 <walk_path+0x240>
  800a04:	8b bd 44 ff ff ff    	mov    -0xbc(%ebp),%edi
  800a0a:	89 f8                	mov    %edi,%eax
  800a0c:	8b 95 4c ff ff ff    	mov    -0xb4(%ebp),%edx
			if (strcmp(f[j].f_name, name) == 0) {
  800a12:	8b 8d 54 ff ff ff    	mov    -0xac(%ebp),%ecx
  800a18:	89 8d 4c ff ff ff    	mov    %ecx,-0xb4(%ebp)
	while (*path != '\0') {
  800a1e:	80 38 00             	cmpb   $0x0,(%eax)
  800a21:	74 ab                	je     8009ce <walk_path+0x1d5>
  800a23:	89 c7                	mov    %eax,%edi
  800a25:	e9 2c fe ff ff       	jmp    800856 <walk_path+0x5d>
  800a2a:	8b b5 44 ff ff ff    	mov    -0xbc(%ebp),%esi
			if (r == -E_NOT_FOUND && *path == '\0') {
  800a30:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800a33:	0f 84 50 ff ff ff    	je     800989 <walk_path+0x190>
}
  800a39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a3c:	5b                   	pop    %ebx
  800a3d:	5e                   	pop    %esi
  800a3e:	5f                   	pop    %edi
  800a3f:	5d                   	pop    %ebp
  800a40:	c3                   	ret    

00800a41 <file_open>:

// Open "path".  On success set *pf to point at the file and return 0.
// On error return < 0.
int
file_open(const char *path, struct File **pf)
{
  800a41:	55                   	push   %ebp
  800a42:	89 e5                	mov    %esp,%ebp
  800a44:	83 ec 14             	sub    $0x14,%esp
	return walk_path(path, 0, pf, 0);
  800a47:	6a 00                	push   $0x0
  800a49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a4c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a51:	8b 45 08             	mov    0x8(%ebp),%eax
  800a54:	e8 a0 fd ff ff       	call   8007f9 <walk_path>
}
  800a59:	c9                   	leave  
  800a5a:	c3                   	ret    

00800a5b <file_read>:
// Read count bytes from f into buf, starting from seek position
// offset.  This meant to mimic the standard pread function.
// Returns the number of bytes read, < 0 on error.
ssize_t
file_read(struct File *f, void *buf, size_t count, off_t offset)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	57                   	push   %edi
  800a5f:	56                   	push   %esi
  800a60:	53                   	push   %ebx
  800a61:	83 ec 2c             	sub    $0x2c,%esp
  800a64:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800a67:	8b 55 14             	mov    0x14(%ebp),%edx
	int r, bn;
	off_t pos;
	char *blk;

	if (offset >= f->f_size)
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
  800a73:	39 d0                	cmp    %edx,%eax
  800a75:	0f 8e 8f 00 00 00    	jle    800b0a <file_read+0xaf>
		return 0;

	count = MIN(count, f->f_size - offset);
  800a7b:	29 d0                	sub    %edx,%eax
  800a7d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a80:	3b 45 10             	cmp    0x10(%ebp),%eax
  800a83:	76 06                	jbe    800a8b <file_read+0x30>
  800a85:	8b 45 10             	mov    0x10(%ebp),%eax
  800a88:	89 45 d0             	mov    %eax,-0x30(%ebp)

	for (pos = offset; pos < offset + count; ) {
  800a8b:	89 d3                	mov    %edx,%ebx
  800a8d:	03 55 d0             	add    -0x30(%ebp),%edx
  800a90:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  800a93:	eb 26                	jmp    800abb <file_read+0x60>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800a95:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800a9b:	eb 32                	jmp    800acf <file_read+0x74>
			return r;
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800a9d:	48                   	dec    %eax
  800a9e:	0d 00 f0 ff ff       	or     $0xfffff000,%eax
  800aa3:	40                   	inc    %eax
  800aa4:	eb 45                	jmp    800aeb <file_read+0x90>
		memmove(buf, blk + pos % BLKSIZE, bn);
  800aa6:	83 ec 04             	sub    $0x4,%esp
  800aa9:	56                   	push   %esi
  800aaa:	03 55 e4             	add    -0x1c(%ebp),%edx
  800aad:	52                   	push   %edx
  800aae:	57                   	push   %edi
  800aaf:	e8 0a 16 00 00       	call   8020be <memmove>
		pos += bn;
  800ab4:	01 f3                	add    %esi,%ebx
		buf += bn;
  800ab6:	01 f7                	add    %esi,%edi
  800ab8:	83 c4 10             	add    $0x10,%esp
	for (pos = offset; pos < offset + count; ) {
  800abb:	89 de                	mov    %ebx,%esi
  800abd:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800ac0:	76 43                	jbe    800b05 <file_read+0xaa>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800ac2:	83 ec 04             	sub    $0x4,%esp
  800ac5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ac8:	50                   	push   %eax
  800ac9:	89 d8                	mov    %ebx,%eax
  800acb:	85 db                	test   %ebx,%ebx
  800acd:	78 c6                	js     800a95 <file_read+0x3a>
  800acf:	c1 f8 0c             	sar    $0xc,%eax
  800ad2:	50                   	push   %eax
  800ad3:	ff 75 08             	pushl  0x8(%ebp)
  800ad6:	e8 af fc ff ff       	call   80078a <file_get_block>
  800adb:	83 c4 10             	add    $0x10,%esp
  800ade:	85 c0                	test   %eax,%eax
  800ae0:	78 2d                	js     800b0f <file_read+0xb4>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800ae2:	89 d8                	mov    %ebx,%eax
  800ae4:	25 ff 0f 00 80       	and    $0x80000fff,%eax
  800ae9:	78 b2                	js     800a9d <file_read+0x42>
  800aeb:	89 c2                	mov    %eax,%edx
  800aed:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800af0:	29 f1                	sub    %esi,%ecx
  800af2:	be 00 10 00 00       	mov    $0x1000,%esi
  800af7:	29 c6                	sub    %eax,%esi
  800af9:	89 f0                	mov    %esi,%eax
  800afb:	89 ce                	mov    %ecx,%esi
  800afd:	39 c1                	cmp    %eax,%ecx
  800aff:	76 a5                	jbe    800aa6 <file_read+0x4b>
  800b01:	89 c6                	mov    %eax,%esi
  800b03:	eb a1                	jmp    800aa6 <file_read+0x4b>
	}

	return count;
  800b05:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b08:	eb 05                	jmp    800b0f <file_read+0xb4>
		return 0;
  800b0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <file_set_size>:
}

// Set the size of file f, truncating or extending as necessary.
int
file_set_size(struct File *f, off_t newsize)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	83 ec 2c             	sub    $0x2c,%esp
  800b20:	8b 75 08             	mov    0x8(%ebp),%esi
	if (f->f_size > newsize)
  800b23:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800b29:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b2c:	7f 1f                	jg     800b4d <file_set_size+0x36>
		file_truncate_blocks(f, newsize);
	f->f_size = newsize;
  800b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b31:	89 86 80 00 00 00    	mov    %eax,0x80(%esi)
	flush_block(f);
  800b37:	83 ec 0c             	sub    $0xc,%esp
  800b3a:	56                   	push   %esi
  800b3b:	e8 b3 f6 ff ff       	call   8001f3 <flush_block>
	return 0;
}
  800b40:	b8 00 00 00 00       	mov    $0x0,%eax
  800b45:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b48:	5b                   	pop    %ebx
  800b49:	5e                   	pop    %esi
  800b4a:	5f                   	pop    %edi
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800b4d:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b52:	89 c7                	mov    %eax,%edi
  800b54:	85 c0                	test   %eax,%eax
  800b56:	78 1b                	js     800b73 <file_set_size+0x5c>
  800b58:	c1 ff 0c             	sar    $0xc,%edi
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	05 ff 0f 00 00       	add    $0xfff,%eax
  800b63:	89 c2                	mov    %eax,%edx
  800b65:	85 c0                	test   %eax,%eax
  800b67:	78 12                	js     800b7b <file_set_size+0x64>
  800b69:	c1 fa 0c             	sar    $0xc,%edx
  800b6c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800b6f:	89 d3                	mov    %edx,%ebx
  800b71:	eb 4a                	jmp    800bbd <file_set_size+0xa6>
	old_nblocks = (f->f_size + BLKSIZE - 1) / BLKSIZE;
  800b73:	8d b8 ff 0f 00 00    	lea    0xfff(%eax),%edi
  800b79:	eb dd                	jmp    800b58 <file_set_size+0x41>
	new_nblocks = (newsize + BLKSIZE - 1) / BLKSIZE;
  800b7b:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800b81:	eb e6                	jmp    800b69 <file_set_size+0x52>
	if (new_nblocks <= NDIRECT && f->f_indirect) {
  800b83:	83 7d d4 0a          	cmpl   $0xa,-0x2c(%ebp)
  800b87:	77 a5                	ja     800b2e <file_set_size+0x17>
  800b89:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800b8f:	85 c0                	test   %eax,%eax
  800b91:	74 9b                	je     800b2e <file_set_size+0x17>
		free_block(f->f_indirect);
  800b93:	83 ec 0c             	sub    $0xc,%esp
  800b96:	50                   	push   %eax
  800b97:	e8 5a f9 ff ff       	call   8004f6 <free_block>
		f->f_indirect = 0;
  800b9c:	c7 86 b0 00 00 00 00 	movl   $0x0,0xb0(%esi)
  800ba3:	00 00 00 
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	eb 83                	jmp    800b2e <file_set_size+0x17>
			cprintf("warning: file_free_block: %e", r);
  800bab:	83 ec 08             	sub    $0x8,%esp
  800bae:	50                   	push   %eax
  800baf:	68 0c 3a 80 00       	push   $0x803a0c
  800bb4:	e8 8a 0d 00 00       	call   801943 <cprintf>
  800bb9:	83 c4 10             	add    $0x10,%esp
	for (bno = new_nblocks; bno < old_nblocks; bno++)
  800bbc:	43                   	inc    %ebx
  800bbd:	39 df                	cmp    %ebx,%edi
  800bbf:	76 c2                	jbe    800b83 <file_set_size+0x6c>
	if ((r = file_block_walk(f, filebno, &ptr, 0)) < 0)
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	6a 00                	push   $0x0
  800bc6:	8d 4d e4             	lea    -0x1c(%ebp),%ecx
  800bc9:	89 da                	mov    %ebx,%edx
  800bcb:	89 f0                	mov    %esi,%eax
  800bcd:	e8 e2 f9 ff ff       	call   8005b4 <file_block_walk>
  800bd2:	83 c4 10             	add    $0x10,%esp
  800bd5:	85 c0                	test   %eax,%eax
  800bd7:	78 d2                	js     800bab <file_set_size+0x94>
	if (*ptr) {
  800bd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bdc:	8b 00                	mov    (%eax),%eax
  800bde:	85 c0                	test   %eax,%eax
  800be0:	74 da                	je     800bbc <file_set_size+0xa5>
		free_block(*ptr);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	50                   	push   %eax
  800be6:	e8 0b f9 ff ff       	call   8004f6 <free_block>
		*ptr = 0;
  800beb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800bee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  800bf4:	83 c4 10             	add    $0x10,%esp
  800bf7:	eb c3                	jmp    800bbc <file_set_size+0xa5>

00800bf9 <file_write>:
{
  800bf9:	55                   	push   %ebp
  800bfa:	89 e5                	mov    %esp,%ebp
  800bfc:	57                   	push   %edi
  800bfd:	56                   	push   %esi
  800bfe:	53                   	push   %ebx
  800bff:	83 ec 2c             	sub    $0x2c,%esp
  800c02:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800c05:	8b 5d 14             	mov    0x14(%ebp),%ebx
	if (offset + count > f->f_size)
  800c08:	89 d8                	mov    %ebx,%eax
  800c0a:	03 45 10             	add    0x10(%ebp),%eax
  800c0d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  800c10:	8b 55 08             	mov    0x8(%ebp),%edx
  800c13:	3b 82 80 00 00 00    	cmp    0x80(%edx),%eax
  800c19:	76 3b                	jbe    800c56 <file_write+0x5d>
		if ((r = file_set_size(f, offset + count)) < 0)
  800c1b:	83 ec 08             	sub    $0x8,%esp
  800c1e:	50                   	push   %eax
  800c1f:	52                   	push   %edx
  800c20:	e8 f2 fe ff ff       	call   800b17 <file_set_size>
  800c25:	83 c4 10             	add    $0x10,%esp
  800c28:	85 c0                	test   %eax,%eax
  800c2a:	79 2a                	jns    800c56 <file_write+0x5d>
  800c2c:	eb 75                	jmp    800ca3 <file_write+0xaa>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800c2e:	8d 83 ff 0f 00 00    	lea    0xfff(%ebx),%eax
  800c34:	eb 34                	jmp    800c6a <file_write+0x71>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800c36:	48                   	dec    %eax
  800c37:	0d 00 f0 ff ff       	or     $0xfffff000,%eax
  800c3c:	40                   	inc    %eax
  800c3d:	eb 47                	jmp    800c86 <file_write+0x8d>
		memmove(blk + pos % BLKSIZE, buf, bn);
  800c3f:	83 ec 04             	sub    $0x4,%esp
  800c42:	56                   	push   %esi
  800c43:	57                   	push   %edi
  800c44:	89 d0                	mov    %edx,%eax
  800c46:	03 45 e4             	add    -0x1c(%ebp),%eax
  800c49:	50                   	push   %eax
  800c4a:	e8 6f 14 00 00       	call   8020be <memmove>
		pos += bn;
  800c4f:	01 f3                	add    %esi,%ebx
		buf += bn;
  800c51:	01 f7                	add    %esi,%edi
  800c53:	83 c4 10             	add    $0x10,%esp
	for (pos = offset; pos < offset + count; ) {
  800c56:	89 de                	mov    %ebx,%esi
  800c58:	39 5d d4             	cmp    %ebx,-0x2c(%ebp)
  800c5b:	76 43                	jbe    800ca0 <file_write+0xa7>
		if ((r = file_get_block(f, pos / BLKSIZE, &blk)) < 0)
  800c5d:	83 ec 04             	sub    $0x4,%esp
  800c60:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800c63:	50                   	push   %eax
  800c64:	89 d8                	mov    %ebx,%eax
  800c66:	85 db                	test   %ebx,%ebx
  800c68:	78 c4                	js     800c2e <file_write+0x35>
  800c6a:	c1 f8 0c             	sar    $0xc,%eax
  800c6d:	50                   	push   %eax
  800c6e:	ff 75 08             	pushl  0x8(%ebp)
  800c71:	e8 14 fb ff ff       	call   80078a <file_get_block>
  800c76:	83 c4 10             	add    $0x10,%esp
  800c79:	85 c0                	test   %eax,%eax
  800c7b:	78 26                	js     800ca3 <file_write+0xaa>
		bn = MIN(BLKSIZE - pos % BLKSIZE, offset + count - pos);
  800c7d:	89 d8                	mov    %ebx,%eax
  800c7f:	25 ff 0f 00 80       	and    $0x80000fff,%eax
  800c84:	78 b0                	js     800c36 <file_write+0x3d>
  800c86:	89 c2                	mov    %eax,%edx
  800c88:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  800c8b:	29 f1                	sub    %esi,%ecx
  800c8d:	be 00 10 00 00       	mov    $0x1000,%esi
  800c92:	29 c6                	sub    %eax,%esi
  800c94:	89 f0                	mov    %esi,%eax
  800c96:	89 ce                	mov    %ecx,%esi
  800c98:	39 c1                	cmp    %eax,%ecx
  800c9a:	76 a3                	jbe    800c3f <file_write+0x46>
  800c9c:	89 c6                	mov    %eax,%esi
  800c9e:	eb 9f                	jmp    800c3f <file_write+0x46>
	return count;
  800ca0:	8b 45 10             	mov    0x10(%ebp),%eax
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    

00800cab <file_flush>:
// Loop over all the blocks in file.
// Translate the file block number into a disk block number
// and then check whether that disk block is dirty.  If so, write it out.
void
file_flush(struct File *f)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	56                   	push   %esi
  800caf:	53                   	push   %ebx
  800cb0:	83 ec 10             	sub    $0x10,%esp
  800cb3:	8b 75 08             	mov    0x8(%ebp),%esi
	int i;
	uint32_t *pdiskbno;

	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800cb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbb:	eb 01                	jmp    800cbe <file_flush+0x13>
  800cbd:	43                   	inc    %ebx
  800cbe:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800cc4:	05 ff 0f 00 00       	add    $0xfff,%eax
  800cc9:	89 c2                	mov    %eax,%edx
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	78 42                	js     800d11 <file_flush+0x66>
  800ccf:	c1 fa 0c             	sar    $0xc,%edx
  800cd2:	39 d3                	cmp    %edx,%ebx
  800cd4:	7d 43                	jge    800d19 <file_flush+0x6e>
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800cd6:	83 ec 0c             	sub    $0xc,%esp
  800cd9:	6a 00                	push   $0x0
  800cdb:	8d 4d f4             	lea    -0xc(%ebp),%ecx
  800cde:	89 da                	mov    %ebx,%edx
  800ce0:	89 f0                	mov    %esi,%eax
  800ce2:	e8 cd f8 ff ff       	call   8005b4 <file_block_walk>
  800ce7:	83 c4 10             	add    $0x10,%esp
  800cea:	85 c0                	test   %eax,%eax
  800cec:	78 cf                	js     800cbd <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  800cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
		if (file_block_walk(f, i, &pdiskbno, 0) < 0 ||
  800cf1:	85 c0                	test   %eax,%eax
  800cf3:	74 c8                	je     800cbd <file_flush+0x12>
		    pdiskbno == NULL || *pdiskbno == 0)
  800cf5:	8b 00                	mov    (%eax),%eax
  800cf7:	85 c0                	test   %eax,%eax
  800cf9:	74 c2                	je     800cbd <file_flush+0x12>
			continue;
		flush_block(diskaddr(*pdiskbno));
  800cfb:	83 ec 0c             	sub    $0xc,%esp
  800cfe:	50                   	push   %eax
  800cff:	e8 2f f3 ff ff       	call   800033 <diskaddr>
  800d04:	89 04 24             	mov    %eax,(%esp)
  800d07:	e8 e7 f4 ff ff       	call   8001f3 <flush_block>
  800d0c:	83 c4 10             	add    $0x10,%esp
  800d0f:	eb ac                	jmp    800cbd <file_flush+0x12>
	for (i = 0; i < (f->f_size + BLKSIZE - 1) / BLKSIZE; i++) {
  800d11:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800d17:	eb b6                	jmp    800ccf <file_flush+0x24>
	}
	flush_block(f);
  800d19:	83 ec 0c             	sub    $0xc,%esp
  800d1c:	56                   	push   %esi
  800d1d:	e8 d1 f4 ff ff       	call   8001f3 <flush_block>
	if (f->f_indirect)
  800d22:	8b 86 b0 00 00 00    	mov    0xb0(%esi),%eax
  800d28:	83 c4 10             	add    $0x10,%esp
  800d2b:	85 c0                	test   %eax,%eax
  800d2d:	75 07                	jne    800d36 <file_flush+0x8b>
		flush_block(diskaddr(f->f_indirect));
}
  800d2f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d32:	5b                   	pop    %ebx
  800d33:	5e                   	pop    %esi
  800d34:	5d                   	pop    %ebp
  800d35:	c3                   	ret    
		flush_block(diskaddr(f->f_indirect));
  800d36:	83 ec 0c             	sub    $0xc,%esp
  800d39:	50                   	push   %eax
  800d3a:	e8 f4 f2 ff ff       	call   800033 <diskaddr>
  800d3f:	89 04 24             	mov    %eax,(%esp)
  800d42:	e8 ac f4 ff ff       	call   8001f3 <flush_block>
  800d47:	83 c4 10             	add    $0x10,%esp
}
  800d4a:	eb e3                	jmp    800d2f <file_flush+0x84>

00800d4c <file_create>:
{
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	57                   	push   %edi
  800d50:	56                   	push   %esi
  800d51:	53                   	push   %ebx
  800d52:	81 ec b8 00 00 00    	sub    $0xb8,%esp
	if ((r = walk_path(path, &dir, &f, name)) == 0)
  800d58:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800d5e:	50                   	push   %eax
  800d5f:	8d 8d 60 ff ff ff    	lea    -0xa0(%ebp),%ecx
  800d65:	8d 95 64 ff ff ff    	lea    -0x9c(%ebp),%edx
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	e8 86 fa ff ff       	call   8007f9 <walk_path>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	85 c0                	test   %eax,%eax
  800d78:	0f 84 0f 01 00 00    	je     800e8d <file_create+0x141>
	if (r != -E_NOT_FOUND || dir == 0)
  800d7e:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800d81:	74 08                	je     800d8b <file_create+0x3f>
}
  800d83:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d86:	5b                   	pop    %ebx
  800d87:	5e                   	pop    %esi
  800d88:	5f                   	pop    %edi
  800d89:	5d                   	pop    %ebp
  800d8a:	c3                   	ret    
	if (r != -E_NOT_FOUND || dir == 0)
  800d8b:	8b b5 64 ff ff ff    	mov    -0x9c(%ebp),%esi
  800d91:	85 f6                	test   %esi,%esi
  800d93:	74 ee                	je     800d83 <file_create+0x37>
	assert((dir->f_size % BLKSIZE) == 0);
  800d95:	8b 86 80 00 00 00    	mov    0x80(%esi),%eax
  800d9b:	a9 ff 0f 00 00       	test   $0xfff,%eax
  800da0:	75 55                	jne    800df7 <file_create+0xab>
	nblock = dir->f_size / BLKSIZE;
  800da2:	89 c2                	mov    %eax,%edx
  800da4:	85 c0                	test   %eax,%eax
  800da6:	78 68                	js     800e10 <file_create+0xc4>
  800da8:	c1 fa 0c             	sar    $0xc,%edx
  800dab:	89 95 54 ff ff ff    	mov    %edx,-0xac(%ebp)
	for (i = 0; i < nblock; i++) {
  800db1:	bb 00 00 00 00       	mov    $0x0,%ebx
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800db6:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
	for (i = 0; i < nblock; i++) {
  800dbc:	39 9d 54 ff ff ff    	cmp    %ebx,-0xac(%ebp)
  800dc2:	0f 84 91 00 00 00    	je     800e59 <file_create+0x10d>
		if ((r = file_get_block(dir, i, &blk)) < 0)
  800dc8:	83 ec 04             	sub    $0x4,%esp
  800dcb:	57                   	push   %edi
  800dcc:	53                   	push   %ebx
  800dcd:	56                   	push   %esi
  800dce:	e8 b7 f9 ff ff       	call   80078a <file_get_block>
  800dd3:	83 c4 10             	add    $0x10,%esp
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	78 a9                	js     800d83 <file_create+0x37>
		f = (struct File*) blk;
  800dda:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800de0:	8d 90 00 10 00 00    	lea    0x1000(%eax),%edx
			if (f[j].f_name[0] == '\0') {
  800de6:	80 38 00             	cmpb   $0x0,(%eax)
  800de9:	74 2d                	je     800e18 <file_create+0xcc>
  800deb:	05 00 01 00 00       	add    $0x100,%eax
		for (j = 0; j < BLKFILES; j++)
  800df0:	39 d0                	cmp    %edx,%eax
  800df2:	75 f2                	jne    800de6 <file_create+0x9a>
	for (i = 0; i < nblock; i++) {
  800df4:	43                   	inc    %ebx
  800df5:	eb c5                	jmp    800dbc <file_create+0x70>
	assert((dir->f_size % BLKSIZE) == 0);
  800df7:	68 ef 39 80 00       	push   $0x8039ef
  800dfc:	68 a0 38 80 00       	push   $0x8038a0
  800e01:	68 f1 00 00 00       	push   $0xf1
  800e06:	68 57 39 80 00       	push   $0x803957
  800e0b:	e8 20 0a 00 00       	call   801830 <_panic>
	nblock = dir->f_size / BLKSIZE;
  800e10:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
  800e16:	eb 90                	jmp    800da8 <file_create+0x5c>
				*file = &f[j];
  800e18:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
	strcpy(f->f_name, name);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  800e27:	50                   	push   %eax
  800e28:	ff b5 60 ff ff ff    	pushl  -0xa0(%ebp)
  800e2e:	e8 18 11 00 00       	call   801f4b <strcpy>
	*pf = f;
  800e33:	8b 95 60 ff ff ff    	mov    -0xa0(%ebp),%edx
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	89 10                	mov    %edx,(%eax)
	file_flush(dir);
  800e3e:	83 c4 04             	add    $0x4,%esp
  800e41:	ff b5 64 ff ff ff    	pushl  -0x9c(%ebp)
  800e47:	e8 5f fe ff ff       	call   800cab <file_flush>
	return 0;
  800e4c:	83 c4 10             	add    $0x10,%esp
  800e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  800e54:	e9 2a ff ff ff       	jmp    800d83 <file_create+0x37>
	dir->f_size += BLKSIZE;
  800e59:	81 86 80 00 00 00 00 	addl   $0x1000,0x80(%esi)
  800e60:	10 00 00 
	if ((r = file_get_block(dir, i, &blk)) < 0)
  800e63:	83 ec 04             	sub    $0x4,%esp
  800e66:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  800e6c:	50                   	push   %eax
  800e6d:	53                   	push   %ebx
  800e6e:	56                   	push   %esi
  800e6f:	e8 16 f9 ff ff       	call   80078a <file_get_block>
  800e74:	83 c4 10             	add    $0x10,%esp
  800e77:	85 c0                	test   %eax,%eax
  800e79:	0f 88 04 ff ff ff    	js     800d83 <file_create+0x37>
	*file = &f[0];
  800e7f:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  800e85:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
  800e8b:	eb 91                	jmp    800e1e <file_create+0xd2>
		return -E_FILE_EXISTS;
  800e8d:	b8 f3 ff ff ff       	mov    $0xfffffff3,%eax
  800e92:	e9 ec fe ff ff       	jmp    800d83 <file_create+0x37>

00800e97 <fs_sync>:


// Sync the entire file system.  A big hammer.
void
fs_sync(void)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	53                   	push   %ebx
  800e9b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 1; i < super->s_nblocks; i++)
  800e9e:	bb 01 00 00 00       	mov    $0x1,%ebx
  800ea3:	eb 15                	jmp    800eba <fs_sync+0x23>
		flush_block(diskaddr(i));
  800ea5:	83 ec 0c             	sub    $0xc,%esp
  800ea8:	53                   	push   %ebx
  800ea9:	e8 85 f1 ff ff       	call   800033 <diskaddr>
  800eae:	89 04 24             	mov    %eax,(%esp)
  800eb1:	e8 3d f3 ff ff       	call   8001f3 <flush_block>
	for (i = 1; i < super->s_nblocks; i++)
  800eb6:	43                   	inc    %ebx
  800eb7:	83 c4 10             	add    $0x10,%esp
  800eba:	a1 08 a0 80 00       	mov    0x80a008,%eax
  800ebf:	39 58 04             	cmp    %ebx,0x4(%eax)
  800ec2:	77 e1                	ja     800ea5 <fs_sync+0xe>
}
  800ec4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <serve_sync>:
}


int
serve_sync(envid_t envid, union Fsipc *req)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 08             	sub    $0x8,%esp
	fs_sync();
  800ecf:	e8 c3 ff ff ff       	call   800e97 <fs_sync>
	return 0;
}
  800ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed9:	c9                   	leave  
  800eda:	c3                   	ret    

00800edb <serve_init>:
{
  800edb:	55                   	push   %ebp
  800edc:	89 e5                	mov    %esp,%ebp
  800ede:	ba 40 50 80 00       	mov    $0x805040,%edx
	uintptr_t va = FILEVA;
  800ee3:	b9 00 00 00 d0       	mov    $0xd0000000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
		opentab[i].o_fileid = i;
  800eed:	89 02                	mov    %eax,(%edx)
		opentab[i].o_fd = (struct Fd*) va;
  800eef:	89 4a 0c             	mov    %ecx,0xc(%edx)
		va += PGSIZE;
  800ef2:	81 c1 00 10 00 00    	add    $0x1000,%ecx
	for (i = 0; i < MAXOPEN; i++) {
  800ef8:	40                   	inc    %eax
  800ef9:	83 c2 10             	add    $0x10,%edx
  800efc:	3d 00 04 00 00       	cmp    $0x400,%eax
  800f01:	75 ea                	jne    800eed <serve_init+0x12>
}
  800f03:	5d                   	pop    %ebp
  800f04:	c3                   	ret    

00800f05 <openfile_alloc>:
{
  800f05:	55                   	push   %ebp
  800f06:	89 e5                	mov    %esp,%ebp
  800f08:	57                   	push   %edi
  800f09:	56                   	push   %esi
  800f0a:	53                   	push   %ebx
  800f0b:	83 ec 0c             	sub    $0xc,%esp
  800f0e:	8b 7d 08             	mov    0x8(%ebp),%edi
	for (i = 0; i < MAXOPEN; i++) {
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	89 de                	mov    %ebx,%esi
  800f18:	c1 e6 04             	shl    $0x4,%esi
		switch (pageref(opentab[i].o_fd)) {
  800f1b:	83 ec 0c             	sub    $0xc,%esp
  800f1e:	ff b6 4c 50 80 00    	pushl  0x80504c(%esi)
  800f24:	e8 59 20 00 00       	call   802f82 <pageref>
  800f29:	83 c4 10             	add    $0x10,%esp
  800f2c:	85 c0                	test   %eax,%eax
  800f2e:	74 15                	je     800f45 <openfile_alloc+0x40>
  800f30:	83 f8 01             	cmp    $0x1,%eax
  800f33:	74 2e                	je     800f63 <openfile_alloc+0x5e>
	for (i = 0; i < MAXOPEN; i++) {
  800f35:	43                   	inc    %ebx
  800f36:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
  800f3c:	75 d8                	jne    800f16 <openfile_alloc+0x11>
	return -E_MAX_OPEN;
  800f3e:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f43:	eb 4f                	jmp    800f94 <openfile_alloc+0x8f>
			if ((r = sys_page_alloc(0, opentab[i].o_fd, PTE_P|PTE_U|PTE_W)) < 0)
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	6a 07                	push   $0x7
  800f4a:	89 d8                	mov    %ebx,%eax
  800f4c:	c1 e0 04             	shl    $0x4,%eax
  800f4f:	ff b0 4c 50 80 00    	pushl  0x80504c(%eax)
  800f55:	6a 00                	push   $0x0
  800f57:	e8 a4 13 00 00       	call   802300 <sys_page_alloc>
  800f5c:	83 c4 10             	add    $0x10,%esp
  800f5f:	85 c0                	test   %eax,%eax
  800f61:	78 31                	js     800f94 <openfile_alloc+0x8f>
			opentab[i].o_fileid += MAXOPEN;
  800f63:	c1 e3 04             	shl    $0x4,%ebx
  800f66:	81 83 40 50 80 00 00 	addl   $0x400,0x805040(%ebx)
  800f6d:	04 00 00 
			*o = &opentab[i];
  800f70:	81 c6 40 50 80 00    	add    $0x805040,%esi
  800f76:	89 37                	mov    %esi,(%edi)
			memset(opentab[i].o_fd, 0, PGSIZE);
  800f78:	83 ec 04             	sub    $0x4,%esp
  800f7b:	68 00 10 00 00       	push   $0x1000
  800f80:	6a 00                	push   $0x0
  800f82:	ff b3 4c 50 80 00    	pushl  0x80504c(%ebx)
  800f88:	e8 e4 10 00 00       	call   802071 <memset>
			return (*o)->o_fileid;
  800f8d:	8b 07                	mov    (%edi),%eax
  800f8f:	8b 00                	mov    (%eax),%eax
  800f91:	83 c4 10             	add    $0x10,%esp
}
  800f94:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f97:	5b                   	pop    %ebx
  800f98:	5e                   	pop    %esi
  800f99:	5f                   	pop    %edi
  800f9a:	5d                   	pop    %ebp
  800f9b:	c3                   	ret    

00800f9c <openfile_lookup>:
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	57                   	push   %edi
  800fa0:	56                   	push   %esi
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 18             	sub    $0x18,%esp
  800fa5:	8b 7d 0c             	mov    0xc(%ebp),%edi
	o = &opentab[fileid % MAXOPEN];
  800fa8:	89 fb                	mov    %edi,%ebx
  800faa:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  800fb0:	89 de                	mov    %ebx,%esi
  800fb2:	c1 e6 04             	shl    $0x4,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800fb5:	ff b6 4c 50 80 00    	pushl  0x80504c(%esi)
	o = &opentab[fileid % MAXOPEN];
  800fbb:	81 c6 40 50 80 00    	add    $0x805040,%esi
	if (pageref(o->o_fd) <= 1 || o->o_fileid != fileid)
  800fc1:	e8 bc 1f 00 00       	call   802f82 <pageref>
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	83 f8 01             	cmp    $0x1,%eax
  800fcc:	7e 1d                	jle    800feb <openfile_lookup+0x4f>
  800fce:	c1 e3 04             	shl    $0x4,%ebx
  800fd1:	3b bb 40 50 80 00    	cmp    0x805040(%ebx),%edi
  800fd7:	75 19                	jne    800ff2 <openfile_lookup+0x56>
	*po = o;
  800fd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdc:	89 30                	mov    %esi,(%eax)
	return 0;
  800fde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fe3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe6:	5b                   	pop    %ebx
  800fe7:	5e                   	pop    %esi
  800fe8:	5f                   	pop    %edi
  800fe9:	5d                   	pop    %ebp
  800fea:	c3                   	ret    
		return -E_INVAL;
  800feb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff0:	eb f1                	jmp    800fe3 <openfile_lookup+0x47>
  800ff2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ff7:	eb ea                	jmp    800fe3 <openfile_lookup+0x47>

00800ff9 <serve_set_size>:
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	53                   	push   %ebx
  800ffd:	83 ec 18             	sub    $0x18,%esp
  801000:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801003:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801006:	50                   	push   %eax
  801007:	ff 33                	pushl  (%ebx)
  801009:	ff 75 08             	pushl  0x8(%ebp)
  80100c:	e8 8b ff ff ff       	call   800f9c <openfile_lookup>
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	85 c0                	test   %eax,%eax
  801016:	78 14                	js     80102c <serve_set_size+0x33>
	return file_set_size(o->o_file, req->req_size);
  801018:	83 ec 08             	sub    $0x8,%esp
  80101b:	ff 73 04             	pushl  0x4(%ebx)
  80101e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801021:	ff 70 04             	pushl  0x4(%eax)
  801024:	e8 ee fa ff ff       	call   800b17 <file_set_size>
  801029:	83 c4 10             	add    $0x10,%esp
}
  80102c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <serve_read>:
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
  801034:	53                   	push   %ebx
  801035:	83 ec 18             	sub    $0x18,%esp
  801038:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  80103b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80103e:	50                   	push   %eax
  80103f:	ff 33                	pushl  (%ebx)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 53 ff ff ff       	call   800f9c <openfile_lookup>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 25                	js     801075 <serve_read+0x44>
	if ((r= file_read(o->o_file, ret->ret_buf, ipc->read.req_n, o->o_fd->fd_offset)) < 0) {
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	8b 50 0c             	mov    0xc(%eax),%edx
  801056:	ff 72 04             	pushl  0x4(%edx)
  801059:	ff 73 04             	pushl  0x4(%ebx)
  80105c:	53                   	push   %ebx
  80105d:	ff 70 04             	pushl  0x4(%eax)
  801060:	e8 f6 f9 ff ff       	call   800a5b <file_read>
  801065:	83 c4 10             	add    $0x10,%esp
  801068:	85 c0                	test   %eax,%eax
  80106a:	78 09                	js     801075 <serve_read+0x44>
	o->o_fd->fd_offset += r;
  80106c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80106f:	8b 52 0c             	mov    0xc(%edx),%edx
  801072:	01 42 04             	add    %eax,0x4(%edx)
}
  801075:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <serve_write>:
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	53                   	push   %ebx
  80107e:	83 ec 18             	sub    $0x18,%esp
  801081:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801087:	50                   	push   %eax
  801088:	ff 33                	pushl  (%ebx)
  80108a:	ff 75 08             	pushl  0x8(%ebp)
  80108d:	e8 0a ff ff ff       	call   800f9c <openfile_lookup>
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	78 28                	js     8010c1 <serve_write+0x47>
	if ((r= file_write(o->o_file, req->req_buf, req->req_n, o->o_fd->fd_offset)) < 0) {
  801099:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109c:	8b 50 0c             	mov    0xc(%eax),%edx
  80109f:	ff 72 04             	pushl  0x4(%edx)
  8010a2:	ff 73 04             	pushl  0x4(%ebx)
  8010a5:	83 c3 08             	add    $0x8,%ebx
  8010a8:	53                   	push   %ebx
  8010a9:	ff 70 04             	pushl  0x4(%eax)
  8010ac:	e8 48 fb ff ff       	call   800bf9 <file_write>
  8010b1:	83 c4 10             	add    $0x10,%esp
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	78 09                	js     8010c1 <serve_write+0x47>
	o->o_fd->fd_offset += r;
  8010b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010bb:	8b 52 0c             	mov    0xc(%edx),%edx
  8010be:	01 42 04             	add    %eax,0x4(%edx)
}
  8010c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010c4:	c9                   	leave  
  8010c5:	c3                   	ret    

008010c6 <serve_stat>:
{
  8010c6:	55                   	push   %ebp
  8010c7:	89 e5                	mov    %esp,%ebp
  8010c9:	53                   	push   %ebx
  8010ca:	83 ec 18             	sub    $0x18,%esp
  8010cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  8010d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d3:	50                   	push   %eax
  8010d4:	ff 33                	pushl  (%ebx)
  8010d6:	ff 75 08             	pushl  0x8(%ebp)
  8010d9:	e8 be fe ff ff       	call   800f9c <openfile_lookup>
  8010de:	83 c4 10             	add    $0x10,%esp
  8010e1:	85 c0                	test   %eax,%eax
  8010e3:	78 38                	js     80111d <serve_stat+0x57>
	strcpy(ret->ret_name, o->o_file->f_name);
  8010e5:	83 ec 08             	sub    $0x8,%esp
  8010e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010eb:	ff 70 04             	pushl  0x4(%eax)
  8010ee:	53                   	push   %ebx
  8010ef:	e8 57 0e 00 00       	call   801f4b <strcpy>
	ret->ret_size = o->o_file->f_size;
  8010f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f7:	8b 50 04             	mov    0x4(%eax),%edx
  8010fa:	8b 92 80 00 00 00    	mov    0x80(%edx),%edx
  801100:	89 93 80 00 00 00    	mov    %edx,0x80(%ebx)
	ret->ret_type = o->o_file->f_type;
  801106:	8b 40 04             	mov    0x4(%eax),%eax
  801109:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
  80110f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801120:	c9                   	leave  
  801121:	c3                   	ret    

00801122 <serve_flush>:
{
  801122:	55                   	push   %ebp
  801123:	89 e5                	mov    %esp,%ebp
  801125:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = openfile_lookup(envid, req->req_fileid, &o)) < 0)
  801128:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80112b:	50                   	push   %eax
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	ff 30                	pushl  (%eax)
  801131:	ff 75 08             	pushl  0x8(%ebp)
  801134:	e8 63 fe ff ff       	call   800f9c <openfile_lookup>
  801139:	83 c4 10             	add    $0x10,%esp
  80113c:	85 c0                	test   %eax,%eax
  80113e:	78 16                	js     801156 <serve_flush+0x34>
	file_flush(o->o_file);
  801140:	83 ec 0c             	sub    $0xc,%esp
  801143:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801146:	ff 70 04             	pushl  0x4(%eax)
  801149:	e8 5d fb ff ff       	call   800cab <file_flush>
	return 0;
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801156:	c9                   	leave  
  801157:	c3                   	ret    

00801158 <serve_open>:
{
  801158:	55                   	push   %ebp
  801159:	89 e5                	mov    %esp,%ebp
  80115b:	53                   	push   %ebx
  80115c:	81 ec 18 04 00 00    	sub    $0x418,%esp
  801162:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	memmove(path, req->req_path, MAXPATHLEN);
  801165:	68 00 04 00 00       	push   $0x400
  80116a:	53                   	push   %ebx
  80116b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801171:	50                   	push   %eax
  801172:	e8 47 0f 00 00       	call   8020be <memmove>
	path[MAXPATHLEN-1] = 0;
  801177:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
	if ((r = openfile_alloc(&o)) < 0) {
  80117b:	8d 85 f0 fb ff ff    	lea    -0x410(%ebp),%eax
  801181:	89 04 24             	mov    %eax,(%esp)
  801184:	e8 7c fd ff ff       	call   800f05 <openfile_alloc>
  801189:	83 c4 10             	add    $0x10,%esp
  80118c:	85 c0                	test   %eax,%eax
  80118e:	0f 88 f0 00 00 00    	js     801284 <serve_open+0x12c>
	if (req->req_omode & O_CREAT) {
  801194:	f6 83 01 04 00 00 01 	testb  $0x1,0x401(%ebx)
  80119b:	74 33                	je     8011d0 <serve_open+0x78>
		if ((r = file_create(path, &f)) < 0) {
  80119d:	83 ec 08             	sub    $0x8,%esp
  8011a0:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8011a6:	50                   	push   %eax
  8011a7:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8011ad:	50                   	push   %eax
  8011ae:	e8 99 fb ff ff       	call   800d4c <file_create>
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	85 c0                	test   %eax,%eax
  8011b8:	79 37                	jns    8011f1 <serve_open+0x99>
			if (!(req->req_omode & O_EXCL) && r == -E_FILE_EXISTS)
  8011ba:	f6 83 01 04 00 00 04 	testb  $0x4,0x401(%ebx)
  8011c1:	0f 85 bd 00 00 00    	jne    801284 <serve_open+0x12c>
  8011c7:	83 f8 f3             	cmp    $0xfffffff3,%eax
  8011ca:	0f 85 b4 00 00 00    	jne    801284 <serve_open+0x12c>
		if ((r = file_open(path, &f)) < 0) {
  8011d0:	83 ec 08             	sub    $0x8,%esp
  8011d3:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  8011d9:	50                   	push   %eax
  8011da:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  8011e0:	50                   	push   %eax
  8011e1:	e8 5b f8 ff ff       	call   800a41 <file_open>
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	0f 88 93 00 00 00    	js     801284 <serve_open+0x12c>
	if (req->req_omode & O_TRUNC) {
  8011f1:	f6 83 01 04 00 00 02 	testb  $0x2,0x401(%ebx)
  8011f8:	74 17                	je     801211 <serve_open+0xb9>
		if ((r = file_set_size(f, 0)) < 0) {
  8011fa:	83 ec 08             	sub    $0x8,%esp
  8011fd:	6a 00                	push   $0x0
  8011ff:	ff b5 f4 fb ff ff    	pushl  -0x40c(%ebp)
  801205:	e8 0d f9 ff ff       	call   800b17 <file_set_size>
  80120a:	83 c4 10             	add    $0x10,%esp
  80120d:	85 c0                	test   %eax,%eax
  80120f:	78 73                	js     801284 <serve_open+0x12c>
	if ((r = file_open(path, &f)) < 0) {
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	8d 85 f4 fb ff ff    	lea    -0x40c(%ebp),%eax
  80121a:	50                   	push   %eax
  80121b:	8d 85 f8 fb ff ff    	lea    -0x408(%ebp),%eax
  801221:	50                   	push   %eax
  801222:	e8 1a f8 ff ff       	call   800a41 <file_open>
  801227:	83 c4 10             	add    $0x10,%esp
  80122a:	85 c0                	test   %eax,%eax
  80122c:	78 56                	js     801284 <serve_open+0x12c>
	o->o_file = f;
  80122e:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801234:	8b 95 f4 fb ff ff    	mov    -0x40c(%ebp),%edx
  80123a:	89 50 04             	mov    %edx,0x4(%eax)
	o->o_fd->fd_file.id = o->o_fileid;
  80123d:	8b 50 0c             	mov    0xc(%eax),%edx
  801240:	8b 08                	mov    (%eax),%ecx
  801242:	89 4a 0c             	mov    %ecx,0xc(%edx)
	o->o_fd->fd_omode = req->req_omode & O_ACCMODE;
  801245:	8b 48 0c             	mov    0xc(%eax),%ecx
  801248:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80124e:	83 e2 03             	and    $0x3,%edx
  801251:	89 51 08             	mov    %edx,0x8(%ecx)
	o->o_fd->fd_dev_id = devfile.dev_id;
  801254:	8b 40 0c             	mov    0xc(%eax),%eax
  801257:	8b 15 44 90 80 00    	mov    0x809044,%edx
  80125d:	89 10                	mov    %edx,(%eax)
	o->o_mode = req->req_omode;
  80125f:	8b 85 f0 fb ff ff    	mov    -0x410(%ebp),%eax
  801265:	8b 93 00 04 00 00    	mov    0x400(%ebx),%edx
  80126b:	89 50 08             	mov    %edx,0x8(%eax)
	*pg_store = o->o_fd;
  80126e:	8b 50 0c             	mov    0xc(%eax),%edx
  801271:	8b 45 10             	mov    0x10(%ebp),%eax
  801274:	89 10                	mov    %edx,(%eax)
	*perm_store = PTE_P|PTE_U|PTE_W|PTE_SHARE;
  801276:	8b 45 14             	mov    0x14(%ebp),%eax
  801279:	c7 00 07 04 00 00    	movl   $0x407,(%eax)
	return 0;
  80127f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801284:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801287:	c9                   	leave  
  801288:	c3                   	ret    

00801289 <serve>:
	[FSREQ_SYNC] =		serve_sync,
};

void
serve(void)
{
  801289:	55                   	push   %ebp
  80128a:	89 e5                	mov    %esp,%ebp
  80128c:	56                   	push   %esi
  80128d:	53                   	push   %ebx
  80128e:	83 ec 10             	sub    $0x10,%esp
	int perm, r;
	void *pg;

	while (1) {
		perm = 0;
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801291:	8d 5d f0             	lea    -0x10(%ebp),%ebx
  801294:	8d 75 f4             	lea    -0xc(%ebp),%esi
  801297:	eb 68                	jmp    801301 <serve+0x78>
			cprintf("fs req %d from %08x [page %08x: %s]\n",
				req, whom, uvpt[PGNUM(fsreq)], fsreq);

		// All requests must contain an argument page
		if (!(perm & PTE_P)) {
			cprintf("Invalid request from %08x: no argument page\n",
  801299:	83 ec 08             	sub    $0x8,%esp
  80129c:	ff 75 f4             	pushl  -0xc(%ebp)
  80129f:	68 2c 3a 80 00       	push   $0x803a2c
  8012a4:	e8 9a 06 00 00       	call   801943 <cprintf>
				whom);
			continue; // just leave it hanging...
  8012a9:	83 c4 10             	add    $0x10,%esp
  8012ac:	eb 53                	jmp    801301 <serve+0x78>
		}

		pg = NULL;
		if (req == FSREQ_OPEN) {
			r = serve_open(whom, (struct Fsreq_open*)fsreq, &pg, &perm);
  8012ae:	53                   	push   %ebx
  8012af:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8012b2:	50                   	push   %eax
  8012b3:	ff 35 24 50 80 00    	pushl  0x805024
  8012b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012bc:	e8 97 fe ff ff       	call   801158 <serve_open>
  8012c1:	83 c4 10             	add    $0x10,%esp
  8012c4:	eb 19                	jmp    8012df <serve+0x56>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
			r = handlers[req](whom, fsreq);
		} else {
			cprintf("Invalid request code %d from %08x\n", req, whom);
  8012c6:	83 ec 04             	sub    $0x4,%esp
  8012c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8012cc:	50                   	push   %eax
  8012cd:	68 5c 3a 80 00       	push   $0x803a5c
  8012d2:	e8 6c 06 00 00       	call   801943 <cprintf>
  8012d7:	83 c4 10             	add    $0x10,%esp
			r = -E_INVAL;
  8012da:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
		}
		ipc_send(whom, r, pg, perm);
  8012df:	ff 75 f0             	pushl  -0x10(%ebp)
  8012e2:	ff 75 ec             	pushl  -0x14(%ebp)
  8012e5:	50                   	push   %eax
  8012e6:	ff 75 f4             	pushl  -0xc(%ebp)
  8012e9:	e8 bc 13 00 00       	call   8026aa <ipc_send>
		sys_page_unmap(0, fsreq);
  8012ee:	83 c4 08             	add    $0x8,%esp
  8012f1:	ff 35 24 50 80 00    	pushl  0x805024
  8012f7:	6a 00                	push   $0x0
  8012f9:	e8 87 10 00 00       	call   802385 <sys_page_unmap>
  8012fe:	83 c4 10             	add    $0x10,%esp
		perm = 0;
  801301:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		req = ipc_recv((int32_t *) &whom, fsreq, &perm);
  801308:	83 ec 04             	sub    $0x4,%esp
  80130b:	53                   	push   %ebx
  80130c:	ff 35 24 50 80 00    	pushl  0x805024
  801312:	56                   	push   %esi
  801313:	e8 09 13 00 00       	call   802621 <ipc_recv>
		if (!(perm & PTE_P)) {
  801318:	83 c4 10             	add    $0x10,%esp
  80131b:	f6 45 f0 01          	testb  $0x1,-0x10(%ebp)
  80131f:	0f 84 74 ff ff ff    	je     801299 <serve+0x10>
		pg = NULL;
  801325:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		if (req == FSREQ_OPEN) {
  80132c:	83 f8 01             	cmp    $0x1,%eax
  80132f:	0f 84 79 ff ff ff    	je     8012ae <serve+0x25>
		} else if (req < ARRAY_SIZE(handlers) && handlers[req]) {
  801335:	83 f8 08             	cmp    $0x8,%eax
  801338:	77 8c                	ja     8012c6 <serve+0x3d>
  80133a:	8b 14 85 00 50 80 00 	mov    0x805000(,%eax,4),%edx
  801341:	85 d2                	test   %edx,%edx
  801343:	74 81                	je     8012c6 <serve+0x3d>
			r = handlers[req](whom, fsreq);
  801345:	83 ec 08             	sub    $0x8,%esp
  801348:	ff 35 24 50 80 00    	pushl  0x805024
  80134e:	ff 75 f4             	pushl  -0xc(%ebp)
  801351:	ff d2                	call   *%edx
  801353:	83 c4 10             	add    $0x10,%esp
  801356:	eb 87                	jmp    8012df <serve+0x56>

00801358 <umain>:
	}
}

void
umain(int argc, char **argv)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 14             	sub    $0x14,%esp
	static_assert(sizeof(struct File) == 256);
	binaryname = "fs";
  80135e:	c7 05 40 90 80 00 7f 	movl   $0x803a7f,0x809040
  801365:	3a 80 00 
	cprintf("FS is running\n");
  801368:	68 82 3a 80 00       	push   $0x803a82
  80136d:	e8 d1 05 00 00       	call   801943 <cprintf>

	serve_init();
  801372:	e8 64 fb ff ff       	call   800edb <serve_init>
	fs_init();
  801377:	e8 d4 f3 ff ff       	call   800750 <fs_init>
        fs_test();
  80137c:	e8 05 00 00 00       	call   801386 <fs_test>
	serve();
  801381:	e8 03 ff ff ff       	call   801289 <serve>

00801386 <fs_test>:

static char *msg = "This is the NEW message of the day!\n\n";

void
fs_test(void)
{
  801386:	55                   	push   %ebp
  801387:	89 e5                	mov    %esp,%ebp
  801389:	53                   	push   %ebx
  80138a:	83 ec 18             	sub    $0x18,%esp
	int r;
	char *blk;
	uint32_t *bits;

	// back up bitmap
	if ((r = sys_page_alloc(0, (void*) PGSIZE, PTE_P|PTE_U|PTE_W)) < 0)
  80138d:	6a 07                	push   $0x7
  80138f:	68 00 10 00 00       	push   $0x1000
  801394:	6a 00                	push   $0x0
  801396:	e8 65 0f 00 00       	call   802300 <sys_page_alloc>
  80139b:	83 c4 10             	add    $0x10,%esp
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	0f 88 67 02 00 00    	js     80160d <fs_test+0x287>
		panic("sys_page_alloc: %e", r);
	bits = (uint32_t*) PGSIZE;
	memmove(bits, bitmap, PGSIZE);
  8013a6:	83 ec 04             	sub    $0x4,%esp
  8013a9:	68 00 10 00 00       	push   $0x1000
  8013ae:	ff 35 04 a0 80 00    	pushl  0x80a004
  8013b4:	68 00 10 00 00       	push   $0x1000
  8013b9:	e8 00 0d 00 00       	call   8020be <memmove>
	// allocate block
	if ((r = alloc_block()) < 0)
  8013be:	e8 6f f1 ff ff       	call   800532 <alloc_block>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	85 c0                	test   %eax,%eax
  8013c8:	0f 88 51 02 00 00    	js     80161f <fs_test+0x299>
		panic("alloc_block: %e", r);
	// check that block was free
	assert(bits[r/32] & (1 << (r%32)));
  8013ce:	89 c2                	mov    %eax,%edx
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	0f 88 59 02 00 00    	js     801631 <fs_test+0x2ab>
  8013d8:	c1 fa 05             	sar    $0x5,%edx
  8013db:	c1 e2 02             	shl    $0x2,%edx
  8013de:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8013e3:	0f 88 50 02 00 00    	js     801639 <fs_test+0x2b3>
  8013e9:	bb 01 00 00 00       	mov    $0x1,%ebx
  8013ee:	88 c1                	mov    %al,%cl
  8013f0:	d3 e3                	shl    %cl,%ebx
  8013f2:	85 9a 00 10 00 00    	test   %ebx,0x1000(%edx)
  8013f8:	0f 84 45 02 00 00    	je     801643 <fs_test+0x2bd>
	// and is not free any more
	assert(!(bitmap[r/32] & (1 << (r%32))));
  8013fe:	8b 0d 04 a0 80 00    	mov    0x80a004,%ecx
  801404:	85 1c 11             	test   %ebx,(%ecx,%edx,1)
  801407:	0f 85 4c 02 00 00    	jne    801659 <fs_test+0x2d3>
	cprintf("alloc_block is good\n");
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	68 d9 3a 80 00       	push   $0x803ad9
  801415:	e8 29 05 00 00       	call   801943 <cprintf>

	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND) {
  80141a:	83 c4 08             	add    $0x8,%esp
  80141d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801420:	50                   	push   %eax
  801421:	68 ee 3a 80 00       	push   $0x803aee
  801426:	e8 16 f6 ff ff       	call   800a41 <file_open>
  80142b:	89 c3                	mov    %eax,%ebx
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	85 c0                	test   %eax,%eax
  801432:	0f 88 37 02 00 00    	js     80166f <fs_test+0x2e9>
		cprintf("error number %d\n", r);
		panic("file_open /not-found: %e", r);
	}
	else if (r == 0)
  801438:	85 c0                	test   %eax,%eax
  80143a:	0f 84 58 02 00 00    	je     801698 <fs_test+0x312>
		panic("file_open /not-found succeeded!");
	if ((r = file_open("/newmotd", &f)) < 0)
  801440:	83 ec 08             	sub    $0x8,%esp
  801443:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801446:	50                   	push   %eax
  801447:	68 23 3b 80 00       	push   $0x803b23
  80144c:	e8 f0 f5 ff ff       	call   800a41 <file_open>
  801451:	83 c4 10             	add    $0x10,%esp
  801454:	85 c0                	test   %eax,%eax
  801456:	0f 88 50 02 00 00    	js     8016ac <fs_test+0x326>
		panic("file_open /newmotd: %e", r);
	cprintf("file_open is good\n");
  80145c:	83 ec 0c             	sub    $0xc,%esp
  80145f:	68 43 3b 80 00       	push   $0x803b43
  801464:	e8 da 04 00 00       	call   801943 <cprintf>

	if ((r = file_get_block(f, 0, &blk)) < 0)
  801469:	83 c4 0c             	add    $0xc,%esp
  80146c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80146f:	50                   	push   %eax
  801470:	6a 00                	push   $0x0
  801472:	ff 75 f4             	pushl  -0xc(%ebp)
  801475:	e8 10 f3 ff ff       	call   80078a <file_get_block>
  80147a:	83 c4 10             	add    $0x10,%esp
  80147d:	85 c0                	test   %eax,%eax
  80147f:	0f 88 39 02 00 00    	js     8016be <fs_test+0x338>
		panic("file_get_block: %e", r);
	if (strcmp(blk, msg) != 0)
  801485:	83 ec 08             	sub    $0x8,%esp
  801488:	68 88 3c 80 00       	push   $0x803c88
  80148d:	ff 75 f0             	pushl  -0x10(%ebp)
  801490:	e8 53 0b 00 00       	call   801fe8 <strcmp>
  801495:	83 c4 10             	add    $0x10,%esp
  801498:	85 c0                	test   %eax,%eax
  80149a:	0f 85 30 02 00 00    	jne    8016d0 <fs_test+0x34a>
		panic("file_get_block returned wrong data");
	cprintf("file_get_block is good\n");
  8014a0:	83 ec 0c             	sub    $0xc,%esp
  8014a3:	68 69 3b 80 00       	push   $0x803b69
  8014a8:	e8 96 04 00 00       	call   801943 <cprintf>

	*(volatile char*)blk = *(volatile char*)blk;
  8014ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b0:	8a 10                	mov    (%eax),%dl
  8014b2:	88 10                	mov    %dl,(%eax)
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	c1 e8 0c             	shr    $0xc,%eax
  8014ba:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014c1:	83 c4 10             	add    $0x10,%esp
  8014c4:	a8 40                	test   $0x40,%al
  8014c6:	0f 84 18 02 00 00    	je     8016e4 <fs_test+0x35e>
	file_flush(f);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8014d2:	e8 d4 f7 ff ff       	call   800cab <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	c1 e8 0c             	shr    $0xc,%eax
  8014dd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e4:	83 c4 10             	add    $0x10,%esp
  8014e7:	a8 40                	test   $0x40,%al
  8014e9:	0f 85 0b 02 00 00    	jne    8016fa <fs_test+0x374>
	cprintf("file_flush is good\n");
  8014ef:	83 ec 0c             	sub    $0xc,%esp
  8014f2:	68 9d 3b 80 00       	push   $0x803b9d
  8014f7:	e8 47 04 00 00       	call   801943 <cprintf>

	if ((r = file_set_size(f, 0)) < 0)
  8014fc:	83 c4 08             	add    $0x8,%esp
  8014ff:	6a 00                	push   $0x0
  801501:	ff 75 f4             	pushl  -0xc(%ebp)
  801504:	e8 0e f6 ff ff       	call   800b17 <file_set_size>
  801509:	83 c4 10             	add    $0x10,%esp
  80150c:	85 c0                	test   %eax,%eax
  80150e:	0f 88 fc 01 00 00    	js     801710 <fs_test+0x38a>
		panic("file_set_size: %e", r);
	assert(f->f_direct[0] == 0);
  801514:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801517:	83 b8 88 00 00 00 00 	cmpl   $0x0,0x88(%eax)
  80151e:	0f 85 fe 01 00 00    	jne    801722 <fs_test+0x39c>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801524:	c1 e8 0c             	shr    $0xc,%eax
  801527:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80152e:	a8 40                	test   $0x40,%al
  801530:	0f 85 02 02 00 00    	jne    801738 <fs_test+0x3b2>
	cprintf("file_truncate is good\n");
  801536:	83 ec 0c             	sub    $0xc,%esp
  801539:	68 f1 3b 80 00       	push   $0x803bf1
  80153e:	e8 00 04 00 00       	call   801943 <cprintf>

	if ((r = file_set_size(f, strlen(msg))) < 0)
  801543:	c7 04 24 88 3c 80 00 	movl   $0x803c88,(%esp)
  80154a:	e8 c9 09 00 00       	call   801f18 <strlen>
  80154f:	83 c4 08             	add    $0x8,%esp
  801552:	50                   	push   %eax
  801553:	ff 75 f4             	pushl  -0xc(%ebp)
  801556:	e8 bc f5 ff ff       	call   800b17 <file_set_size>
  80155b:	83 c4 10             	add    $0x10,%esp
  80155e:	85 c0                	test   %eax,%eax
  801560:	0f 88 e8 01 00 00    	js     80174e <fs_test+0x3c8>
		panic("file_set_size 2: %e", r);
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801569:	89 c2                	mov    %eax,%edx
  80156b:	c1 ea 0c             	shr    $0xc,%edx
  80156e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801575:	f6 c2 40             	test   $0x40,%dl
  801578:	0f 85 e2 01 00 00    	jne    801760 <fs_test+0x3da>
	if ((r = file_get_block(f, 0, &blk)) < 0)
  80157e:	83 ec 04             	sub    $0x4,%esp
  801581:	8d 55 f0             	lea    -0x10(%ebp),%edx
  801584:	52                   	push   %edx
  801585:	6a 00                	push   $0x0
  801587:	50                   	push   %eax
  801588:	e8 fd f1 ff ff       	call   80078a <file_get_block>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	85 c0                	test   %eax,%eax
  801592:	0f 88 de 01 00 00    	js     801776 <fs_test+0x3f0>
		panic("file_get_block 2: %e", r);
	strcpy(blk, msg);
  801598:	83 ec 08             	sub    $0x8,%esp
  80159b:	68 88 3c 80 00       	push   $0x803c88
  8015a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015a3:	e8 a3 09 00 00       	call   801f4b <strcpy>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8015a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ab:	c1 e8 0c             	shr    $0xc,%eax
  8015ae:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015b5:	83 c4 10             	add    $0x10,%esp
  8015b8:	a8 40                	test   $0x40,%al
  8015ba:	0f 84 c8 01 00 00    	je     801788 <fs_test+0x402>
	file_flush(f);
  8015c0:	83 ec 0c             	sub    $0xc,%esp
  8015c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c6:	e8 e0 f6 ff ff       	call   800cab <file_flush>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	c1 e8 0c             	shr    $0xc,%eax
  8015d1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015d8:	83 c4 10             	add    $0x10,%esp
  8015db:	a8 40                	test   $0x40,%al
  8015dd:	0f 85 bb 01 00 00    	jne    80179e <fs_test+0x418>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8015e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e6:	c1 e8 0c             	shr    $0xc,%eax
  8015e9:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8015f0:	a8 40                	test   $0x40,%al
  8015f2:	0f 85 bc 01 00 00    	jne    8017b4 <fs_test+0x42e>
	cprintf("file rewrite is good\n");
  8015f8:	83 ec 0c             	sub    $0xc,%esp
  8015fb:	68 31 3c 80 00       	push   $0x803c31
  801600:	e8 3e 03 00 00       	call   801943 <cprintf>
}
  801605:	83 c4 10             	add    $0x10,%esp
  801608:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80160b:	c9                   	leave  
  80160c:	c3                   	ret    
		panic("sys_page_alloc: %e", r);
  80160d:	50                   	push   %eax
  80160e:	68 91 3a 80 00       	push   $0x803a91
  801613:	6a 12                	push   $0x12
  801615:	68 a4 3a 80 00       	push   $0x803aa4
  80161a:	e8 11 02 00 00       	call   801830 <_panic>
		panic("alloc_block: %e", r);
  80161f:	50                   	push   %eax
  801620:	68 ae 3a 80 00       	push   $0x803aae
  801625:	6a 17                	push   $0x17
  801627:	68 a4 3a 80 00       	push   $0x803aa4
  80162c:	e8 ff 01 00 00       	call   801830 <_panic>
	assert(bits[r/32] & (1 << (r%32)));
  801631:	8d 50 1f             	lea    0x1f(%eax),%edx
  801634:	e9 9f fd ff ff       	jmp    8013d8 <fs_test+0x52>
  801639:	48                   	dec    %eax
  80163a:	83 c8 e0             	or     $0xffffffe0,%eax
  80163d:	40                   	inc    %eax
  80163e:	e9 a6 fd ff ff       	jmp    8013e9 <fs_test+0x63>
  801643:	68 be 3a 80 00       	push   $0x803abe
  801648:	68 a0 38 80 00       	push   $0x8038a0
  80164d:	6a 19                	push   $0x19
  80164f:	68 a4 3a 80 00       	push   $0x803aa4
  801654:	e8 d7 01 00 00       	call   801830 <_panic>
	assert(!(bitmap[r/32] & (1 << (r%32))));
  801659:	68 48 3c 80 00       	push   $0x803c48
  80165e:	68 a0 38 80 00       	push   $0x8038a0
  801663:	6a 1b                	push   $0x1b
  801665:	68 a4 3a 80 00       	push   $0x803aa4
  80166a:	e8 c1 01 00 00       	call   801830 <_panic>
	if ((r = file_open("/not-found", &f)) < 0 && r != -E_NOT_FOUND) {
  80166f:	83 f8 f5             	cmp    $0xfffffff5,%eax
  801672:	0f 84 c8 fd ff ff    	je     801440 <fs_test+0xba>
		cprintf("error number %d\n", r);
  801678:	83 ec 08             	sub    $0x8,%esp
  80167b:	50                   	push   %eax
  80167c:	68 f9 3a 80 00       	push   $0x803af9
  801681:	e8 bd 02 00 00       	call   801943 <cprintf>
		panic("file_open /not-found: %e", r);
  801686:	53                   	push   %ebx
  801687:	68 0a 3b 80 00       	push   $0x803b0a
  80168c:	6a 20                	push   $0x20
  80168e:	68 a4 3a 80 00       	push   $0x803aa4
  801693:	e8 98 01 00 00       	call   801830 <_panic>
		panic("file_open /not-found succeeded!");
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	68 68 3c 80 00       	push   $0x803c68
  8016a0:	6a 23                	push   $0x23
  8016a2:	68 a4 3a 80 00       	push   $0x803aa4
  8016a7:	e8 84 01 00 00       	call   801830 <_panic>
		panic("file_open /newmotd: %e", r);
  8016ac:	50                   	push   %eax
  8016ad:	68 2c 3b 80 00       	push   $0x803b2c
  8016b2:	6a 25                	push   $0x25
  8016b4:	68 a4 3a 80 00       	push   $0x803aa4
  8016b9:	e8 72 01 00 00       	call   801830 <_panic>
		panic("file_get_block: %e", r);
  8016be:	50                   	push   %eax
  8016bf:	68 56 3b 80 00       	push   $0x803b56
  8016c4:	6a 29                	push   $0x29
  8016c6:	68 a4 3a 80 00       	push   $0x803aa4
  8016cb:	e8 60 01 00 00       	call   801830 <_panic>
		panic("file_get_block returned wrong data");
  8016d0:	83 ec 04             	sub    $0x4,%esp
  8016d3:	68 b0 3c 80 00       	push   $0x803cb0
  8016d8:	6a 2b                	push   $0x2b
  8016da:	68 a4 3a 80 00       	push   $0x803aa4
  8016df:	e8 4c 01 00 00       	call   801830 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  8016e4:	68 82 3b 80 00       	push   $0x803b82
  8016e9:	68 a0 38 80 00       	push   $0x8038a0
  8016ee:	6a 2f                	push   $0x2f
  8016f0:	68 a4 3a 80 00       	push   $0x803aa4
  8016f5:	e8 36 01 00 00       	call   801830 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  8016fa:	68 81 3b 80 00       	push   $0x803b81
  8016ff:	68 a0 38 80 00       	push   $0x8038a0
  801704:	6a 31                	push   $0x31
  801706:	68 a4 3a 80 00       	push   $0x803aa4
  80170b:	e8 20 01 00 00       	call   801830 <_panic>
		panic("file_set_size: %e", r);
  801710:	50                   	push   %eax
  801711:	68 b1 3b 80 00       	push   $0x803bb1
  801716:	6a 35                	push   $0x35
  801718:	68 a4 3a 80 00       	push   $0x803aa4
  80171d:	e8 0e 01 00 00       	call   801830 <_panic>
	assert(f->f_direct[0] == 0);
  801722:	68 c3 3b 80 00       	push   $0x803bc3
  801727:	68 a0 38 80 00       	push   $0x8038a0
  80172c:	6a 36                	push   $0x36
  80172e:	68 a4 3a 80 00       	push   $0x803aa4
  801733:	e8 f8 00 00 00       	call   801830 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801738:	68 d7 3b 80 00       	push   $0x803bd7
  80173d:	68 a0 38 80 00       	push   $0x8038a0
  801742:	6a 37                	push   $0x37
  801744:	68 a4 3a 80 00       	push   $0x803aa4
  801749:	e8 e2 00 00 00       	call   801830 <_panic>
		panic("file_set_size 2: %e", r);
  80174e:	50                   	push   %eax
  80174f:	68 08 3c 80 00       	push   $0x803c08
  801754:	6a 3b                	push   $0x3b
  801756:	68 a4 3a 80 00       	push   $0x803aa4
  80175b:	e8 d0 00 00 00       	call   801830 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  801760:	68 d7 3b 80 00       	push   $0x803bd7
  801765:	68 a0 38 80 00       	push   $0x8038a0
  80176a:	6a 3c                	push   $0x3c
  80176c:	68 a4 3a 80 00       	push   $0x803aa4
  801771:	e8 ba 00 00 00       	call   801830 <_panic>
		panic("file_get_block 2: %e", r);
  801776:	50                   	push   %eax
  801777:	68 1c 3c 80 00       	push   $0x803c1c
  80177c:	6a 3e                	push   $0x3e
  80177e:	68 a4 3a 80 00       	push   $0x803aa4
  801783:	e8 a8 00 00 00       	call   801830 <_panic>
	assert((uvpt[PGNUM(blk)] & PTE_D));
  801788:	68 82 3b 80 00       	push   $0x803b82
  80178d:	68 a0 38 80 00       	push   $0x8038a0
  801792:	6a 40                	push   $0x40
  801794:	68 a4 3a 80 00       	push   $0x803aa4
  801799:	e8 92 00 00 00       	call   801830 <_panic>
	assert(!(uvpt[PGNUM(blk)] & PTE_D));
  80179e:	68 81 3b 80 00       	push   $0x803b81
  8017a3:	68 a0 38 80 00       	push   $0x8038a0
  8017a8:	6a 42                	push   $0x42
  8017aa:	68 a4 3a 80 00       	push   $0x803aa4
  8017af:	e8 7c 00 00 00       	call   801830 <_panic>
	assert(!(uvpt[PGNUM(f)] & PTE_D));
  8017b4:	68 d7 3b 80 00       	push   $0x803bd7
  8017b9:	68 a0 38 80 00       	push   $0x8038a0
  8017be:	6a 43                	push   $0x43
  8017c0:	68 a4 3a 80 00       	push   $0x803aa4
  8017c5:	e8 66 00 00 00       	call   801830 <_panic>

008017ca <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	56                   	push   %esi
  8017ce:	53                   	push   %ebx
  8017cf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8017d2:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8017d5:	e8 07 0b 00 00       	call   8022e1 <sys_getenvid>
  8017da:	25 ff 03 00 00       	and    $0x3ff,%eax
  8017df:	89 c2                	mov    %eax,%edx
  8017e1:	c1 e2 05             	shl    $0x5,%edx
  8017e4:	29 c2                	sub    %eax,%edx
  8017e6:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8017ed:	a3 0c a0 80 00       	mov    %eax,0x80a00c

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8017f2:	85 db                	test   %ebx,%ebx
  8017f4:	7e 07                	jle    8017fd <libmain+0x33>
		binaryname = argv[0];
  8017f6:	8b 06                	mov    (%esi),%eax
  8017f8:	a3 40 90 80 00       	mov    %eax,0x809040

	// call user main routine
	umain(argc, argv);
  8017fd:	83 ec 08             	sub    $0x8,%esp
  801800:	56                   	push   %esi
  801801:	53                   	push   %ebx
  801802:	e8 51 fb ff ff       	call   801358 <umain>

	// exit gracefully
	exit();
  801807:	e8 0a 00 00 00       	call   801816 <exit>
}
  80180c:	83 c4 10             	add    $0x10,%esp
  80180f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801812:	5b                   	pop    %ebx
  801813:	5e                   	pop    %esi
  801814:	5d                   	pop    %ebp
  801815:	c3                   	ret    

00801816 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  801816:	55                   	push   %ebp
  801817:	89 e5                	mov    %esp,%ebp
  801819:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80181c:	e8 fb 10 00 00       	call   80291c <close_all>
	sys_env_destroy(0);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	6a 00                	push   $0x0
  801826:	e8 75 0a 00 00       	call   8022a0 <sys_env_destroy>
}
  80182b:	83 c4 10             	add    $0x10,%esp
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	57                   	push   %edi
  801834:	56                   	push   %esi
  801835:	53                   	push   %ebx
  801836:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80183c:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80183f:	8b 1d 40 90 80 00    	mov    0x809040,%ebx
  801845:	e8 97 0a 00 00       	call   8022e1 <sys_getenvid>
  80184a:	83 ec 04             	sub    $0x4,%esp
  80184d:	ff 75 0c             	pushl  0xc(%ebp)
  801850:	ff 75 08             	pushl  0x8(%ebp)
  801853:	53                   	push   %ebx
  801854:	50                   	push   %eax
  801855:	68 e0 3c 80 00       	push   $0x803ce0
  80185a:	68 00 01 00 00       	push   $0x100
  80185f:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801865:	56                   	push   %esi
  801866:	e8 93 06 00 00       	call   801efe <snprintf>
  80186b:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80186d:	83 c4 20             	add    $0x20,%esp
  801870:	57                   	push   %edi
  801871:	ff 75 10             	pushl  0x10(%ebp)
  801874:	bf 00 01 00 00       	mov    $0x100,%edi
  801879:	89 f8                	mov    %edi,%eax
  80187b:	29 d8                	sub    %ebx,%eax
  80187d:	50                   	push   %eax
  80187e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801881:	50                   	push   %eax
  801882:	e8 22 06 00 00       	call   801ea9 <vsnprintf>
  801887:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801889:	83 c4 0c             	add    $0xc,%esp
  80188c:	68 ee 38 80 00       	push   $0x8038ee
  801891:	29 df                	sub    %ebx,%edi
  801893:	57                   	push   %edi
  801894:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801897:	50                   	push   %eax
  801898:	e8 61 06 00 00       	call   801efe <snprintf>
	sys_cputs(buf, r);
  80189d:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8018a0:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8018a2:	53                   	push   %ebx
  8018a3:	56                   	push   %esi
  8018a4:	e8 ba 09 00 00       	call   802263 <sys_cputs>
  8018a9:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8018ac:	cc                   	int3   
  8018ad:	eb fd                	jmp    8018ac <_panic+0x7c>

008018af <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	53                   	push   %ebx
  8018b3:	83 ec 04             	sub    $0x4,%esp
  8018b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8018b9:	8b 13                	mov    (%ebx),%edx
  8018bb:	8d 42 01             	lea    0x1(%edx),%eax
  8018be:	89 03                	mov    %eax,(%ebx)
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8018c7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8018cc:	74 08                	je     8018d6 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8018ce:	ff 43 04             	incl   0x4(%ebx)
}
  8018d1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8018d6:	83 ec 08             	sub    $0x8,%esp
  8018d9:	68 ff 00 00 00       	push   $0xff
  8018de:	8d 43 08             	lea    0x8(%ebx),%eax
  8018e1:	50                   	push   %eax
  8018e2:	e8 7c 09 00 00       	call   802263 <sys_cputs>
		b->idx = 0;
  8018e7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	eb dc                	jmp    8018ce <putch+0x1f>

008018f2 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
  8018f5:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8018fb:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801902:	00 00 00 
	b.cnt = 0;
  801905:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80190c:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80190f:	ff 75 0c             	pushl  0xc(%ebp)
  801912:	ff 75 08             	pushl  0x8(%ebp)
  801915:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80191b:	50                   	push   %eax
  80191c:	68 af 18 80 00       	push   $0x8018af
  801921:	e8 17 01 00 00       	call   801a3d <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801926:	83 c4 08             	add    $0x8,%esp
  801929:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80192f:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801935:	50                   	push   %eax
  801936:	e8 28 09 00 00       	call   802263 <sys_cputs>

	return b.cnt;
}
  80193b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801949:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80194c:	50                   	push   %eax
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 9d ff ff ff       	call   8018f2 <vcprintf>
	va_end(ap);

	return cnt;
}
  801955:	c9                   	leave  
  801956:	c3                   	ret    

00801957 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801957:	55                   	push   %ebp
  801958:	89 e5                	mov    %esp,%ebp
  80195a:	57                   	push   %edi
  80195b:	56                   	push   %esi
  80195c:	53                   	push   %ebx
  80195d:	83 ec 1c             	sub    $0x1c,%esp
  801960:	89 c7                	mov    %eax,%edi
  801962:	89 d6                	mov    %edx,%esi
  801964:	8b 45 08             	mov    0x8(%ebp),%eax
  801967:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80196d:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801970:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801973:	bb 00 00 00 00       	mov    $0x0,%ebx
  801978:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80197b:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80197e:	39 d3                	cmp    %edx,%ebx
  801980:	72 05                	jb     801987 <printnum+0x30>
  801982:	39 45 10             	cmp    %eax,0x10(%ebp)
  801985:	77 78                	ja     8019ff <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801987:	83 ec 0c             	sub    $0xc,%esp
  80198a:	ff 75 18             	pushl  0x18(%ebp)
  80198d:	8b 45 14             	mov    0x14(%ebp),%eax
  801990:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801993:	53                   	push   %ebx
  801994:	ff 75 10             	pushl  0x10(%ebp)
  801997:	83 ec 08             	sub    $0x8,%esp
  80199a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80199d:	ff 75 e0             	pushl  -0x20(%ebp)
  8019a0:	ff 75 dc             	pushl  -0x24(%ebp)
  8019a3:	ff 75 d8             	pushl  -0x28(%ebp)
  8019a6:	e8 ed 1a 00 00       	call   803498 <__udivdi3>
  8019ab:	83 c4 18             	add    $0x18,%esp
  8019ae:	52                   	push   %edx
  8019af:	50                   	push   %eax
  8019b0:	89 f2                	mov    %esi,%edx
  8019b2:	89 f8                	mov    %edi,%eax
  8019b4:	e8 9e ff ff ff       	call   801957 <printnum>
  8019b9:	83 c4 20             	add    $0x20,%esp
  8019bc:	eb 11                	jmp    8019cf <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8019be:	83 ec 08             	sub    $0x8,%esp
  8019c1:	56                   	push   %esi
  8019c2:	ff 75 18             	pushl  0x18(%ebp)
  8019c5:	ff d7                	call   *%edi
  8019c7:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8019ca:	4b                   	dec    %ebx
  8019cb:	85 db                	test   %ebx,%ebx
  8019cd:	7f ef                	jg     8019be <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8019cf:	83 ec 08             	sub    $0x8,%esp
  8019d2:	56                   	push   %esi
  8019d3:	83 ec 04             	sub    $0x4,%esp
  8019d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8019d9:	ff 75 e0             	pushl  -0x20(%ebp)
  8019dc:	ff 75 dc             	pushl  -0x24(%ebp)
  8019df:	ff 75 d8             	pushl  -0x28(%ebp)
  8019e2:	e8 c1 1b 00 00       	call   8035a8 <__umoddi3>
  8019e7:	83 c4 14             	add    $0x14,%esp
  8019ea:	0f be 80 03 3d 80 00 	movsbl 0x803d03(%eax),%eax
  8019f1:	50                   	push   %eax
  8019f2:	ff d7                	call   *%edi
}
  8019f4:	83 c4 10             	add    $0x10,%esp
  8019f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019fa:	5b                   	pop    %ebx
  8019fb:	5e                   	pop    %esi
  8019fc:	5f                   	pop    %edi
  8019fd:	5d                   	pop    %ebp
  8019fe:	c3                   	ret    
  8019ff:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a02:	eb c6                	jmp    8019ca <printnum+0x73>

00801a04 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
  801a07:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801a0a:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  801a0d:	8b 10                	mov    (%eax),%edx
  801a0f:	3b 50 04             	cmp    0x4(%eax),%edx
  801a12:	73 0a                	jae    801a1e <sprintputch+0x1a>
		*b->buf++ = ch;
  801a14:	8d 4a 01             	lea    0x1(%edx),%ecx
  801a17:	89 08                	mov    %ecx,(%eax)
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	88 02                	mov    %al,(%edx)
}
  801a1e:	5d                   	pop    %ebp
  801a1f:	c3                   	ret    

00801a20 <printfmt>:
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801a26:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801a29:	50                   	push   %eax
  801a2a:	ff 75 10             	pushl  0x10(%ebp)
  801a2d:	ff 75 0c             	pushl  0xc(%ebp)
  801a30:	ff 75 08             	pushl  0x8(%ebp)
  801a33:	e8 05 00 00 00       	call   801a3d <vprintfmt>
}
  801a38:	83 c4 10             	add    $0x10,%esp
  801a3b:	c9                   	leave  
  801a3c:	c3                   	ret    

00801a3d <vprintfmt>:
{
  801a3d:	55                   	push   %ebp
  801a3e:	89 e5                	mov    %esp,%ebp
  801a40:	57                   	push   %edi
  801a41:	56                   	push   %esi
  801a42:	53                   	push   %ebx
  801a43:	83 ec 2c             	sub    $0x2c,%esp
  801a46:	8b 75 08             	mov    0x8(%ebp),%esi
  801a49:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801a4c:	8b 7d 10             	mov    0x10(%ebp),%edi
  801a4f:	e9 ae 03 00 00       	jmp    801e02 <vprintfmt+0x3c5>
  801a54:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801a58:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801a5f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801a66:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801a6d:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801a72:	8d 47 01             	lea    0x1(%edi),%eax
  801a75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801a78:	8a 17                	mov    (%edi),%dl
  801a7a:	8d 42 dd             	lea    -0x23(%edx),%eax
  801a7d:	3c 55                	cmp    $0x55,%al
  801a7f:	0f 87 fe 03 00 00    	ja     801e83 <vprintfmt+0x446>
  801a85:	0f b6 c0             	movzbl %al,%eax
  801a88:	ff 24 85 40 3e 80 00 	jmp    *0x803e40(,%eax,4)
  801a8f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801a92:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801a96:	eb da                	jmp    801a72 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801a98:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801a9b:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801a9f:	eb d1                	jmp    801a72 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801aa1:	0f b6 d2             	movzbl %dl,%edx
  801aa4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801aa7:	b8 00 00 00 00       	mov    $0x0,%eax
  801aac:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801aaf:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801ab2:	01 c0                	add    %eax,%eax
  801ab4:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801ab8:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801abb:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801abe:	83 f9 09             	cmp    $0x9,%ecx
  801ac1:	77 52                	ja     801b15 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  801ac3:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801ac4:	eb e9                	jmp    801aaf <vprintfmt+0x72>
			precision = va_arg(ap, int);
  801ac6:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac9:	8b 00                	mov    (%eax),%eax
  801acb:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801ace:	8b 45 14             	mov    0x14(%ebp),%eax
  801ad1:	8d 40 04             	lea    0x4(%eax),%eax
  801ad4:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  801ad7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  801ada:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ade:	79 92                	jns    801a72 <vprintfmt+0x35>
				width = precision, precision = -1;
  801ae0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801ae3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ae6:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801aed:	eb 83                	jmp    801a72 <vprintfmt+0x35>
  801aef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801af3:	78 08                	js     801afd <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  801af5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801af8:	e9 75 ff ff ff       	jmp    801a72 <vprintfmt+0x35>
  801afd:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801b04:	eb ef                	jmp    801af5 <vprintfmt+0xb8>
  801b06:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801b09:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801b10:	e9 5d ff ff ff       	jmp    801a72 <vprintfmt+0x35>
  801b15:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801b18:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801b1b:	eb bd                	jmp    801ada <vprintfmt+0x9d>
			lflag++;
  801b1d:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  801b1e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801b21:	e9 4c ff ff ff       	jmp    801a72 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801b26:	8b 45 14             	mov    0x14(%ebp),%eax
  801b29:	8d 78 04             	lea    0x4(%eax),%edi
  801b2c:	83 ec 08             	sub    $0x8,%esp
  801b2f:	53                   	push   %ebx
  801b30:	ff 30                	pushl  (%eax)
  801b32:	ff d6                	call   *%esi
			break;
  801b34:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801b37:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801b3a:	e9 c0 02 00 00       	jmp    801dff <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801b3f:	8b 45 14             	mov    0x14(%ebp),%eax
  801b42:	8d 78 04             	lea    0x4(%eax),%edi
  801b45:	8b 00                	mov    (%eax),%eax
  801b47:	85 c0                	test   %eax,%eax
  801b49:	78 2a                	js     801b75 <vprintfmt+0x138>
  801b4b:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801b4d:	83 f8 0f             	cmp    $0xf,%eax
  801b50:	7f 27                	jg     801b79 <vprintfmt+0x13c>
  801b52:	8b 04 85 a0 3f 80 00 	mov    0x803fa0(,%eax,4),%eax
  801b59:	85 c0                	test   %eax,%eax
  801b5b:	74 1c                	je     801b79 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  801b5d:	50                   	push   %eax
  801b5e:	68 b2 38 80 00       	push   $0x8038b2
  801b63:	53                   	push   %ebx
  801b64:	56                   	push   %esi
  801b65:	e8 b6 fe ff ff       	call   801a20 <printfmt>
  801b6a:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801b6d:	89 7d 14             	mov    %edi,0x14(%ebp)
  801b70:	e9 8a 02 00 00       	jmp    801dff <vprintfmt+0x3c2>
  801b75:	f7 d8                	neg    %eax
  801b77:	eb d2                	jmp    801b4b <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801b79:	52                   	push   %edx
  801b7a:	68 1b 3d 80 00       	push   $0x803d1b
  801b7f:	53                   	push   %ebx
  801b80:	56                   	push   %esi
  801b81:	e8 9a fe ff ff       	call   801a20 <printfmt>
  801b86:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801b89:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801b8c:	e9 6e 02 00 00       	jmp    801dff <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801b91:	8b 45 14             	mov    0x14(%ebp),%eax
  801b94:	83 c0 04             	add    $0x4,%eax
  801b97:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801b9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9d:	8b 38                	mov    (%eax),%edi
  801b9f:	85 ff                	test   %edi,%edi
  801ba1:	74 39                	je     801bdc <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801ba3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ba7:	0f 8e a9 00 00 00    	jle    801c56 <vprintfmt+0x219>
  801bad:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801bb1:	0f 84 a7 00 00 00    	je     801c5e <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 d0             	pushl  -0x30(%ebp)
  801bbd:	57                   	push   %edi
  801bbe:	e8 6b 03 00 00       	call   801f2e <strnlen>
  801bc3:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801bc6:	29 c1                	sub    %eax,%ecx
  801bc8:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801bcb:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  801bce:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  801bd2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801bd5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  801bd8:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  801bda:	eb 14                	jmp    801bf0 <vprintfmt+0x1b3>
				p = "(null)";
  801bdc:	bf 14 3d 80 00       	mov    $0x803d14,%edi
  801be1:	eb c0                	jmp    801ba3 <vprintfmt+0x166>
					putch(padc, putdat);
  801be3:	83 ec 08             	sub    $0x8,%esp
  801be6:	53                   	push   %ebx
  801be7:	ff 75 e0             	pushl  -0x20(%ebp)
  801bea:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  801bec:	4f                   	dec    %edi
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	85 ff                	test   %edi,%edi
  801bf2:	7f ef                	jg     801be3 <vprintfmt+0x1a6>
  801bf4:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801bf7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801bfa:	89 c8                	mov    %ecx,%eax
  801bfc:	85 c9                	test   %ecx,%ecx
  801bfe:	78 10                	js     801c10 <vprintfmt+0x1d3>
  801c00:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801c03:	29 c1                	sub    %eax,%ecx
  801c05:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801c08:	89 75 08             	mov    %esi,0x8(%ebp)
  801c0b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c0e:	eb 15                	jmp    801c25 <vprintfmt+0x1e8>
  801c10:	b8 00 00 00 00       	mov    $0x0,%eax
  801c15:	eb e9                	jmp    801c00 <vprintfmt+0x1c3>
					putch(ch, putdat);
  801c17:	83 ec 08             	sub    $0x8,%esp
  801c1a:	53                   	push   %ebx
  801c1b:	52                   	push   %edx
  801c1c:	ff 55 08             	call   *0x8(%ebp)
  801c1f:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801c22:	ff 4d e0             	decl   -0x20(%ebp)
  801c25:	47                   	inc    %edi
  801c26:	8a 47 ff             	mov    -0x1(%edi),%al
  801c29:	0f be d0             	movsbl %al,%edx
  801c2c:	85 d2                	test   %edx,%edx
  801c2e:	74 59                	je     801c89 <vprintfmt+0x24c>
  801c30:	85 f6                	test   %esi,%esi
  801c32:	78 03                	js     801c37 <vprintfmt+0x1fa>
  801c34:	4e                   	dec    %esi
  801c35:	78 2f                	js     801c66 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801c37:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c3b:	74 da                	je     801c17 <vprintfmt+0x1da>
  801c3d:	0f be c0             	movsbl %al,%eax
  801c40:	83 e8 20             	sub    $0x20,%eax
  801c43:	83 f8 5e             	cmp    $0x5e,%eax
  801c46:	76 cf                	jbe    801c17 <vprintfmt+0x1da>
					putch('?', putdat);
  801c48:	83 ec 08             	sub    $0x8,%esp
  801c4b:	53                   	push   %ebx
  801c4c:	6a 3f                	push   $0x3f
  801c4e:	ff 55 08             	call   *0x8(%ebp)
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	eb cc                	jmp    801c22 <vprintfmt+0x1e5>
  801c56:	89 75 08             	mov    %esi,0x8(%ebp)
  801c59:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c5c:	eb c7                	jmp    801c25 <vprintfmt+0x1e8>
  801c5e:	89 75 08             	mov    %esi,0x8(%ebp)
  801c61:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801c64:	eb bf                	jmp    801c25 <vprintfmt+0x1e8>
  801c66:	8b 75 08             	mov    0x8(%ebp),%esi
  801c69:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801c6c:	eb 0c                	jmp    801c7a <vprintfmt+0x23d>
				putch(' ', putdat);
  801c6e:	83 ec 08             	sub    $0x8,%esp
  801c71:	53                   	push   %ebx
  801c72:	6a 20                	push   $0x20
  801c74:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801c76:	4f                   	dec    %edi
  801c77:	83 c4 10             	add    $0x10,%esp
  801c7a:	85 ff                	test   %edi,%edi
  801c7c:	7f f0                	jg     801c6e <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  801c7e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801c81:	89 45 14             	mov    %eax,0x14(%ebp)
  801c84:	e9 76 01 00 00       	jmp    801dff <vprintfmt+0x3c2>
  801c89:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801c8c:	8b 75 08             	mov    0x8(%ebp),%esi
  801c8f:	eb e9                	jmp    801c7a <vprintfmt+0x23d>
	if (lflag >= 2)
  801c91:	83 f9 01             	cmp    $0x1,%ecx
  801c94:	7f 1f                	jg     801cb5 <vprintfmt+0x278>
	else if (lflag)
  801c96:	85 c9                	test   %ecx,%ecx
  801c98:	75 48                	jne    801ce2 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801c9a:	8b 45 14             	mov    0x14(%ebp),%eax
  801c9d:	8b 00                	mov    (%eax),%eax
  801c9f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801ca2:	89 c1                	mov    %eax,%ecx
  801ca4:	c1 f9 1f             	sar    $0x1f,%ecx
  801ca7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801caa:	8b 45 14             	mov    0x14(%ebp),%eax
  801cad:	8d 40 04             	lea    0x4(%eax),%eax
  801cb0:	89 45 14             	mov    %eax,0x14(%ebp)
  801cb3:	eb 17                	jmp    801ccc <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801cb5:	8b 45 14             	mov    0x14(%ebp),%eax
  801cb8:	8b 50 04             	mov    0x4(%eax),%edx
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cc0:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  801cc6:	8d 40 08             	lea    0x8(%eax),%eax
  801cc9:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801ccc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ccf:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  801cd2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801cd6:	78 25                	js     801cfd <vprintfmt+0x2c0>
			base = 10;
  801cd8:	b8 0a 00 00 00       	mov    $0xa,%eax
  801cdd:	e9 03 01 00 00       	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  801ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  801ce5:	8b 00                	mov    (%eax),%eax
  801ce7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801cea:	89 c1                	mov    %eax,%ecx
  801cec:	c1 f9 1f             	sar    $0x1f,%ecx
  801cef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801cf2:	8b 45 14             	mov    0x14(%ebp),%eax
  801cf5:	8d 40 04             	lea    0x4(%eax),%eax
  801cf8:	89 45 14             	mov    %eax,0x14(%ebp)
  801cfb:	eb cf                	jmp    801ccc <vprintfmt+0x28f>
				putch('-', putdat);
  801cfd:	83 ec 08             	sub    $0x8,%esp
  801d00:	53                   	push   %ebx
  801d01:	6a 2d                	push   $0x2d
  801d03:	ff d6                	call   *%esi
				num = -(long long) num;
  801d05:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d08:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801d0b:	f7 da                	neg    %edx
  801d0d:	83 d1 00             	adc    $0x0,%ecx
  801d10:	f7 d9                	neg    %ecx
  801d12:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801d15:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d1a:	e9 c6 00 00 00       	jmp    801de5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801d1f:	83 f9 01             	cmp    $0x1,%ecx
  801d22:	7f 1e                	jg     801d42 <vprintfmt+0x305>
	else if (lflag)
  801d24:	85 c9                	test   %ecx,%ecx
  801d26:	75 32                	jne    801d5a <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801d28:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2b:	8b 10                	mov    (%eax),%edx
  801d2d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d32:	8d 40 04             	lea    0x4(%eax),%eax
  801d35:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801d38:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d3d:	e9 a3 00 00 00       	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801d42:	8b 45 14             	mov    0x14(%ebp),%eax
  801d45:	8b 10                	mov    (%eax),%edx
  801d47:	8b 48 04             	mov    0x4(%eax),%ecx
  801d4a:	8d 40 08             	lea    0x8(%eax),%eax
  801d4d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801d50:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d55:	e9 8b 00 00 00       	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801d5a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d5d:	8b 10                	mov    (%eax),%edx
  801d5f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d64:	8d 40 04             	lea    0x4(%eax),%eax
  801d67:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801d6a:	b8 0a 00 00 00       	mov    $0xa,%eax
  801d6f:	eb 74                	jmp    801de5 <vprintfmt+0x3a8>
	if (lflag >= 2)
  801d71:	83 f9 01             	cmp    $0x1,%ecx
  801d74:	7f 1b                	jg     801d91 <vprintfmt+0x354>
	else if (lflag)
  801d76:	85 c9                	test   %ecx,%ecx
  801d78:	75 2c                	jne    801da6 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801d7a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d7d:	8b 10                	mov    (%eax),%edx
  801d7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801d84:	8d 40 04             	lea    0x4(%eax),%eax
  801d87:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801d8a:	b8 08 00 00 00       	mov    $0x8,%eax
  801d8f:	eb 54                	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801d91:	8b 45 14             	mov    0x14(%ebp),%eax
  801d94:	8b 10                	mov    (%eax),%edx
  801d96:	8b 48 04             	mov    0x4(%eax),%ecx
  801d99:	8d 40 08             	lea    0x8(%eax),%eax
  801d9c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801d9f:	b8 08 00 00 00       	mov    $0x8,%eax
  801da4:	eb 3f                	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801da6:	8b 45 14             	mov    0x14(%ebp),%eax
  801da9:	8b 10                	mov    (%eax),%edx
  801dab:	b9 00 00 00 00       	mov    $0x0,%ecx
  801db0:	8d 40 04             	lea    0x4(%eax),%eax
  801db3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801db6:	b8 08 00 00 00       	mov    $0x8,%eax
  801dbb:	eb 28                	jmp    801de5 <vprintfmt+0x3a8>
			putch('0', putdat);
  801dbd:	83 ec 08             	sub    $0x8,%esp
  801dc0:	53                   	push   %ebx
  801dc1:	6a 30                	push   $0x30
  801dc3:	ff d6                	call   *%esi
			putch('x', putdat);
  801dc5:	83 c4 08             	add    $0x8,%esp
  801dc8:	53                   	push   %ebx
  801dc9:	6a 78                	push   $0x78
  801dcb:	ff d6                	call   *%esi
			num = (unsigned long long)
  801dcd:	8b 45 14             	mov    0x14(%ebp),%eax
  801dd0:	8b 10                	mov    (%eax),%edx
  801dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801dd7:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801dda:	8d 40 04             	lea    0x4(%eax),%eax
  801ddd:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801de0:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801de5:	83 ec 0c             	sub    $0xc,%esp
  801de8:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801dec:	57                   	push   %edi
  801ded:	ff 75 e0             	pushl  -0x20(%ebp)
  801df0:	50                   	push   %eax
  801df1:	51                   	push   %ecx
  801df2:	52                   	push   %edx
  801df3:	89 da                	mov    %ebx,%edx
  801df5:	89 f0                	mov    %esi,%eax
  801df7:	e8 5b fb ff ff       	call   801957 <printnum>
			break;
  801dfc:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801dff:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801e02:	47                   	inc    %edi
  801e03:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801e07:	83 f8 25             	cmp    $0x25,%eax
  801e0a:	0f 84 44 fc ff ff    	je     801a54 <vprintfmt+0x17>
			if (ch == '\0')
  801e10:	85 c0                	test   %eax,%eax
  801e12:	0f 84 89 00 00 00    	je     801ea1 <vprintfmt+0x464>
			putch(ch, putdat);
  801e18:	83 ec 08             	sub    $0x8,%esp
  801e1b:	53                   	push   %ebx
  801e1c:	50                   	push   %eax
  801e1d:	ff d6                	call   *%esi
  801e1f:	83 c4 10             	add    $0x10,%esp
  801e22:	eb de                	jmp    801e02 <vprintfmt+0x3c5>
	if (lflag >= 2)
  801e24:	83 f9 01             	cmp    $0x1,%ecx
  801e27:	7f 1b                	jg     801e44 <vprintfmt+0x407>
	else if (lflag)
  801e29:	85 c9                	test   %ecx,%ecx
  801e2b:	75 2c                	jne    801e59 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801e2d:	8b 45 14             	mov    0x14(%ebp),%eax
  801e30:	8b 10                	mov    (%eax),%edx
  801e32:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e37:	8d 40 04             	lea    0x4(%eax),%eax
  801e3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e3d:	b8 10 00 00 00       	mov    $0x10,%eax
  801e42:	eb a1                	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801e44:	8b 45 14             	mov    0x14(%ebp),%eax
  801e47:	8b 10                	mov    (%eax),%edx
  801e49:	8b 48 04             	mov    0x4(%eax),%ecx
  801e4c:	8d 40 08             	lea    0x8(%eax),%eax
  801e4f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e52:	b8 10 00 00 00       	mov    $0x10,%eax
  801e57:	eb 8c                	jmp    801de5 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801e59:	8b 45 14             	mov    0x14(%ebp),%eax
  801e5c:	8b 10                	mov    (%eax),%edx
  801e5e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801e63:	8d 40 04             	lea    0x4(%eax),%eax
  801e66:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801e69:	b8 10 00 00 00       	mov    $0x10,%eax
  801e6e:	e9 72 ff ff ff       	jmp    801de5 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801e73:	83 ec 08             	sub    $0x8,%esp
  801e76:	53                   	push   %ebx
  801e77:	6a 25                	push   $0x25
  801e79:	ff d6                	call   *%esi
			break;
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	e9 7c ff ff ff       	jmp    801dff <vprintfmt+0x3c2>
			putch('%', putdat);
  801e83:	83 ec 08             	sub    $0x8,%esp
  801e86:	53                   	push   %ebx
  801e87:	6a 25                	push   $0x25
  801e89:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801e8b:	83 c4 10             	add    $0x10,%esp
  801e8e:	89 f8                	mov    %edi,%eax
  801e90:	eb 01                	jmp    801e93 <vprintfmt+0x456>
  801e92:	48                   	dec    %eax
  801e93:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801e97:	75 f9                	jne    801e92 <vprintfmt+0x455>
  801e99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e9c:	e9 5e ff ff ff       	jmp    801dff <vprintfmt+0x3c2>
}
  801ea1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ea4:	5b                   	pop    %ebx
  801ea5:	5e                   	pop    %esi
  801ea6:	5f                   	pop    %edi
  801ea7:	5d                   	pop    %ebp
  801ea8:	c3                   	ret    

00801ea9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801ea9:	55                   	push   %ebp
  801eaa:	89 e5                	mov    %esp,%ebp
  801eac:	83 ec 18             	sub    $0x18,%esp
  801eaf:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb2:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801eb8:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801ebc:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801ebf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801ec6:	85 c0                	test   %eax,%eax
  801ec8:	74 26                	je     801ef0 <vsnprintf+0x47>
  801eca:	85 d2                	test   %edx,%edx
  801ecc:	7e 29                	jle    801ef7 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801ece:	ff 75 14             	pushl  0x14(%ebp)
  801ed1:	ff 75 10             	pushl  0x10(%ebp)
  801ed4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801ed7:	50                   	push   %eax
  801ed8:	68 04 1a 80 00       	push   $0x801a04
  801edd:	e8 5b fb ff ff       	call   801a3d <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801ee2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ee5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801ee8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eeb:	83 c4 10             	add    $0x10,%esp
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    
		return -E_INVAL;
  801ef0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801ef5:	eb f7                	jmp    801eee <vsnprintf+0x45>
  801ef7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801efc:	eb f0                	jmp    801eee <vsnprintf+0x45>

00801efe <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801efe:	55                   	push   %ebp
  801eff:	89 e5                	mov    %esp,%ebp
  801f01:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801f04:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801f07:	50                   	push   %eax
  801f08:	ff 75 10             	pushl  0x10(%ebp)
  801f0b:	ff 75 0c             	pushl  0xc(%ebp)
  801f0e:	ff 75 08             	pushl  0x8(%ebp)
  801f11:	e8 93 ff ff ff       	call   801ea9 <vsnprintf>
	va_end(ap);

	return rc;
}
  801f16:	c9                   	leave  
  801f17:	c3                   	ret    

00801f18 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801f18:	55                   	push   %ebp
  801f19:	89 e5                	mov    %esp,%ebp
  801f1b:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801f1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f23:	eb 01                	jmp    801f26 <strlen+0xe>
		n++;
  801f25:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801f26:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801f2a:	75 f9                	jne    801f25 <strlen+0xd>
	return n;
}
  801f2c:	5d                   	pop    %ebp
  801f2d:	c3                   	ret    

00801f2e <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801f2e:	55                   	push   %ebp
  801f2f:	89 e5                	mov    %esp,%ebp
  801f31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f34:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f37:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3c:	eb 01                	jmp    801f3f <strnlen+0x11>
		n++;
  801f3e:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801f3f:	39 d0                	cmp    %edx,%eax
  801f41:	74 06                	je     801f49 <strnlen+0x1b>
  801f43:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801f47:	75 f5                	jne    801f3e <strnlen+0x10>
	return n;
}
  801f49:	5d                   	pop    %ebp
  801f4a:	c3                   	ret    

00801f4b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801f4b:	55                   	push   %ebp
  801f4c:	89 e5                	mov    %esp,%ebp
  801f4e:	53                   	push   %ebx
  801f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f52:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801f55:	89 c2                	mov    %eax,%edx
  801f57:	42                   	inc    %edx
  801f58:	41                   	inc    %ecx
  801f59:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801f5c:	88 5a ff             	mov    %bl,-0x1(%edx)
  801f5f:	84 db                	test   %bl,%bl
  801f61:	75 f4                	jne    801f57 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801f63:	5b                   	pop    %ebx
  801f64:	5d                   	pop    %ebp
  801f65:	c3                   	ret    

00801f66 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801f66:	55                   	push   %ebp
  801f67:	89 e5                	mov    %esp,%ebp
  801f69:	53                   	push   %ebx
  801f6a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801f6d:	53                   	push   %ebx
  801f6e:	e8 a5 ff ff ff       	call   801f18 <strlen>
  801f73:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801f76:	ff 75 0c             	pushl  0xc(%ebp)
  801f79:	01 d8                	add    %ebx,%eax
  801f7b:	50                   	push   %eax
  801f7c:	e8 ca ff ff ff       	call   801f4b <strcpy>
	return dst;
}
  801f81:	89 d8                	mov    %ebx,%eax
  801f83:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f86:	c9                   	leave  
  801f87:	c3                   	ret    

00801f88 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801f88:	55                   	push   %ebp
  801f89:	89 e5                	mov    %esp,%ebp
  801f8b:	56                   	push   %esi
  801f8c:	53                   	push   %ebx
  801f8d:	8b 75 08             	mov    0x8(%ebp),%esi
  801f90:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f93:	89 f3                	mov    %esi,%ebx
  801f95:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801f98:	89 f2                	mov    %esi,%edx
  801f9a:	eb 0c                	jmp    801fa8 <strncpy+0x20>
		*dst++ = *src;
  801f9c:	42                   	inc    %edx
  801f9d:	8a 01                	mov    (%ecx),%al
  801f9f:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801fa2:	80 39 01             	cmpb   $0x1,(%ecx)
  801fa5:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801fa8:	39 da                	cmp    %ebx,%edx
  801faa:	75 f0                	jne    801f9c <strncpy+0x14>
	}
	return ret;
}
  801fac:	89 f0                	mov    %esi,%eax
  801fae:	5b                   	pop    %ebx
  801faf:	5e                   	pop    %esi
  801fb0:	5d                   	pop    %ebp
  801fb1:	c3                   	ret    

00801fb2 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801fb2:	55                   	push   %ebp
  801fb3:	89 e5                	mov    %esp,%ebp
  801fb5:	56                   	push   %esi
  801fb6:	53                   	push   %ebx
  801fb7:	8b 75 08             	mov    0x8(%ebp),%esi
  801fba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbd:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801fc0:	85 c0                	test   %eax,%eax
  801fc2:	74 20                	je     801fe4 <strlcpy+0x32>
  801fc4:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  801fc8:	89 f0                	mov    %esi,%eax
  801fca:	eb 05                	jmp    801fd1 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801fcc:	40                   	inc    %eax
  801fcd:	42                   	inc    %edx
  801fce:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801fd1:	39 d8                	cmp    %ebx,%eax
  801fd3:	74 06                	je     801fdb <strlcpy+0x29>
  801fd5:	8a 0a                	mov    (%edx),%cl
  801fd7:	84 c9                	test   %cl,%cl
  801fd9:	75 f1                	jne    801fcc <strlcpy+0x1a>
		*dst = '\0';
  801fdb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801fde:	29 f0                	sub    %esi,%eax
}
  801fe0:	5b                   	pop    %ebx
  801fe1:	5e                   	pop    %esi
  801fe2:	5d                   	pop    %ebp
  801fe3:	c3                   	ret    
  801fe4:	89 f0                	mov    %esi,%eax
  801fe6:	eb f6                	jmp    801fde <strlcpy+0x2c>

00801fe8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801fe8:	55                   	push   %ebp
  801fe9:	89 e5                	mov    %esp,%ebp
  801feb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801fee:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801ff1:	eb 02                	jmp    801ff5 <strcmp+0xd>
		p++, q++;
  801ff3:	41                   	inc    %ecx
  801ff4:	42                   	inc    %edx
	while (*p && *p == *q)
  801ff5:	8a 01                	mov    (%ecx),%al
  801ff7:	84 c0                	test   %al,%al
  801ff9:	74 04                	je     801fff <strcmp+0x17>
  801ffb:	3a 02                	cmp    (%edx),%al
  801ffd:	74 f4                	je     801ff3 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801fff:	0f b6 c0             	movzbl %al,%eax
  802002:	0f b6 12             	movzbl (%edx),%edx
  802005:	29 d0                	sub    %edx,%eax
}
  802007:	5d                   	pop    %ebp
  802008:	c3                   	ret    

00802009 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
  80200c:	53                   	push   %ebx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	8b 55 0c             	mov    0xc(%ebp),%edx
  802013:	89 c3                	mov    %eax,%ebx
  802015:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  802018:	eb 02                	jmp    80201c <strncmp+0x13>
		n--, p++, q++;
  80201a:	40                   	inc    %eax
  80201b:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80201c:	39 d8                	cmp    %ebx,%eax
  80201e:	74 15                	je     802035 <strncmp+0x2c>
  802020:	8a 08                	mov    (%eax),%cl
  802022:	84 c9                	test   %cl,%cl
  802024:	74 04                	je     80202a <strncmp+0x21>
  802026:	3a 0a                	cmp    (%edx),%cl
  802028:	74 f0                	je     80201a <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80202a:	0f b6 00             	movzbl (%eax),%eax
  80202d:	0f b6 12             	movzbl (%edx),%edx
  802030:	29 d0                	sub    %edx,%eax
}
  802032:	5b                   	pop    %ebx
  802033:	5d                   	pop    %ebp
  802034:	c3                   	ret    
		return 0;
  802035:	b8 00 00 00 00       	mov    $0x0,%eax
  80203a:	eb f6                	jmp    802032 <strncmp+0x29>

0080203c <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80203c:	55                   	push   %ebp
  80203d:	89 e5                	mov    %esp,%ebp
  80203f:	8b 45 08             	mov    0x8(%ebp),%eax
  802042:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  802045:	8a 10                	mov    (%eax),%dl
  802047:	84 d2                	test   %dl,%dl
  802049:	74 07                	je     802052 <strchr+0x16>
		if (*s == c)
  80204b:	38 ca                	cmp    %cl,%dl
  80204d:	74 08                	je     802057 <strchr+0x1b>
	for (; *s; s++)
  80204f:	40                   	inc    %eax
  802050:	eb f3                	jmp    802045 <strchr+0x9>
			return (char *) s;
	return 0;
  802052:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802057:	5d                   	pop    %ebp
  802058:	c3                   	ret    

00802059 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  802059:	55                   	push   %ebp
  80205a:	89 e5                	mov    %esp,%ebp
  80205c:	8b 45 08             	mov    0x8(%ebp),%eax
  80205f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  802062:	8a 10                	mov    (%eax),%dl
  802064:	84 d2                	test   %dl,%dl
  802066:	74 07                	je     80206f <strfind+0x16>
		if (*s == c)
  802068:	38 ca                	cmp    %cl,%dl
  80206a:	74 03                	je     80206f <strfind+0x16>
	for (; *s; s++)
  80206c:	40                   	inc    %eax
  80206d:	eb f3                	jmp    802062 <strfind+0x9>
			break;
	return (char *) s;
}
  80206f:	5d                   	pop    %ebp
  802070:	c3                   	ret    

00802071 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	57                   	push   %edi
  802075:	56                   	push   %esi
  802076:	53                   	push   %ebx
  802077:	8b 7d 08             	mov    0x8(%ebp),%edi
  80207a:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80207d:	85 c9                	test   %ecx,%ecx
  80207f:	74 13                	je     802094 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  802081:	f7 c7 03 00 00 00    	test   $0x3,%edi
  802087:	75 05                	jne    80208e <memset+0x1d>
  802089:	f6 c1 03             	test   $0x3,%cl
  80208c:	74 0d                	je     80209b <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80208e:	8b 45 0c             	mov    0xc(%ebp),%eax
  802091:	fc                   	cld    
  802092:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  802094:	89 f8                	mov    %edi,%eax
  802096:	5b                   	pop    %ebx
  802097:	5e                   	pop    %esi
  802098:	5f                   	pop    %edi
  802099:	5d                   	pop    %ebp
  80209a:	c3                   	ret    
		c &= 0xFF;
  80209b:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80209f:	89 d3                	mov    %edx,%ebx
  8020a1:	c1 e3 08             	shl    $0x8,%ebx
  8020a4:	89 d0                	mov    %edx,%eax
  8020a6:	c1 e0 18             	shl    $0x18,%eax
  8020a9:	89 d6                	mov    %edx,%esi
  8020ab:	c1 e6 10             	shl    $0x10,%esi
  8020ae:	09 f0                	or     %esi,%eax
  8020b0:	09 c2                	or     %eax,%edx
  8020b2:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8020b4:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8020b7:	89 d0                	mov    %edx,%eax
  8020b9:	fc                   	cld    
  8020ba:	f3 ab                	rep stos %eax,%es:(%edi)
  8020bc:	eb d6                	jmp    802094 <memset+0x23>

008020be <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8020be:	55                   	push   %ebp
  8020bf:	89 e5                	mov    %esp,%ebp
  8020c1:	57                   	push   %edi
  8020c2:	56                   	push   %esi
  8020c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c6:	8b 75 0c             	mov    0xc(%ebp),%esi
  8020c9:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8020cc:	39 c6                	cmp    %eax,%esi
  8020ce:	73 33                	jae    802103 <memmove+0x45>
  8020d0:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8020d3:	39 d0                	cmp    %edx,%eax
  8020d5:	73 2c                	jae    802103 <memmove+0x45>
		s += n;
		d += n;
  8020d7:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8020da:	89 d6                	mov    %edx,%esi
  8020dc:	09 fe                	or     %edi,%esi
  8020de:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8020e4:	75 13                	jne    8020f9 <memmove+0x3b>
  8020e6:	f6 c1 03             	test   $0x3,%cl
  8020e9:	75 0e                	jne    8020f9 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8020eb:	83 ef 04             	sub    $0x4,%edi
  8020ee:	8d 72 fc             	lea    -0x4(%edx),%esi
  8020f1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8020f4:	fd                   	std    
  8020f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8020f7:	eb 07                	jmp    802100 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8020f9:	4f                   	dec    %edi
  8020fa:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8020fd:	fd                   	std    
  8020fe:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  802100:	fc                   	cld    
  802101:	eb 13                	jmp    802116 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  802103:	89 f2                	mov    %esi,%edx
  802105:	09 c2                	or     %eax,%edx
  802107:	f6 c2 03             	test   $0x3,%dl
  80210a:	75 05                	jne    802111 <memmove+0x53>
  80210c:	f6 c1 03             	test   $0x3,%cl
  80210f:	74 09                	je     80211a <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  802111:	89 c7                	mov    %eax,%edi
  802113:	fc                   	cld    
  802114:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  802116:	5e                   	pop    %esi
  802117:	5f                   	pop    %edi
  802118:	5d                   	pop    %ebp
  802119:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80211a:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80211d:	89 c7                	mov    %eax,%edi
  80211f:	fc                   	cld    
  802120:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  802122:	eb f2                	jmp    802116 <memmove+0x58>

00802124 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  802127:	ff 75 10             	pushl  0x10(%ebp)
  80212a:	ff 75 0c             	pushl  0xc(%ebp)
  80212d:	ff 75 08             	pushl  0x8(%ebp)
  802130:	e8 89 ff ff ff       	call   8020be <memmove>
}
  802135:	c9                   	leave  
  802136:	c3                   	ret    

00802137 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  802137:	55                   	push   %ebp
  802138:	89 e5                	mov    %esp,%ebp
  80213a:	56                   	push   %esi
  80213b:	53                   	push   %ebx
  80213c:	8b 45 08             	mov    0x8(%ebp),%eax
  80213f:	89 c6                	mov    %eax,%esi
  802141:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  802144:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  802147:	39 f0                	cmp    %esi,%eax
  802149:	74 16                	je     802161 <memcmp+0x2a>
		if (*s1 != *s2)
  80214b:	8a 08                	mov    (%eax),%cl
  80214d:	8a 1a                	mov    (%edx),%bl
  80214f:	38 d9                	cmp    %bl,%cl
  802151:	75 04                	jne    802157 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  802153:	40                   	inc    %eax
  802154:	42                   	inc    %edx
  802155:	eb f0                	jmp    802147 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  802157:	0f b6 c1             	movzbl %cl,%eax
  80215a:	0f b6 db             	movzbl %bl,%ebx
  80215d:	29 d8                	sub    %ebx,%eax
  80215f:	eb 05                	jmp    802166 <memcmp+0x2f>
	}

	return 0;
  802161:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802166:	5b                   	pop    %ebx
  802167:	5e                   	pop    %esi
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    

0080216a <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  802173:	89 c2                	mov    %eax,%edx
  802175:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  802178:	39 d0                	cmp    %edx,%eax
  80217a:	73 07                	jae    802183 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  80217c:	38 08                	cmp    %cl,(%eax)
  80217e:	74 03                	je     802183 <memfind+0x19>
	for (; s < ends; s++)
  802180:	40                   	inc    %eax
  802181:	eb f5                	jmp    802178 <memfind+0xe>
			break;
	return (void *) s;
}
  802183:	5d                   	pop    %ebp
  802184:	c3                   	ret    

00802185 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
  802188:	57                   	push   %edi
  802189:	56                   	push   %esi
  80218a:	53                   	push   %ebx
  80218b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80218e:	eb 01                	jmp    802191 <strtol+0xc>
		s++;
  802190:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  802191:	8a 01                	mov    (%ecx),%al
  802193:	3c 20                	cmp    $0x20,%al
  802195:	74 f9                	je     802190 <strtol+0xb>
  802197:	3c 09                	cmp    $0x9,%al
  802199:	74 f5                	je     802190 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  80219b:	3c 2b                	cmp    $0x2b,%al
  80219d:	74 2b                	je     8021ca <strtol+0x45>
		s++;
	else if (*s == '-')
  80219f:	3c 2d                	cmp    $0x2d,%al
  8021a1:	74 2f                	je     8021d2 <strtol+0x4d>
	int neg = 0;
  8021a3:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021a8:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8021af:	75 12                	jne    8021c3 <strtol+0x3e>
  8021b1:	80 39 30             	cmpb   $0x30,(%ecx)
  8021b4:	74 24                	je     8021da <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8021b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021ba:	75 07                	jne    8021c3 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8021bc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8021c3:	b8 00 00 00 00       	mov    $0x0,%eax
  8021c8:	eb 4e                	jmp    802218 <strtol+0x93>
		s++;
  8021ca:	41                   	inc    %ecx
	int neg = 0;
  8021cb:	bf 00 00 00 00       	mov    $0x0,%edi
  8021d0:	eb d6                	jmp    8021a8 <strtol+0x23>
		s++, neg = 1;
  8021d2:	41                   	inc    %ecx
  8021d3:	bf 01 00 00 00       	mov    $0x1,%edi
  8021d8:	eb ce                	jmp    8021a8 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8021da:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8021de:	74 10                	je     8021f0 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  8021e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8021e4:	75 dd                	jne    8021c3 <strtol+0x3e>
		s++, base = 8;
  8021e6:	41                   	inc    %ecx
  8021e7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8021ee:	eb d3                	jmp    8021c3 <strtol+0x3e>
		s += 2, base = 16;
  8021f0:	83 c1 02             	add    $0x2,%ecx
  8021f3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8021fa:	eb c7                	jmp    8021c3 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  8021fc:	8d 72 9f             	lea    -0x61(%edx),%esi
  8021ff:	89 f3                	mov    %esi,%ebx
  802201:	80 fb 19             	cmp    $0x19,%bl
  802204:	77 24                	ja     80222a <strtol+0xa5>
			dig = *s - 'a' + 10;
  802206:	0f be d2             	movsbl %dl,%edx
  802209:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80220c:	3b 55 10             	cmp    0x10(%ebp),%edx
  80220f:	7d 2b                	jge    80223c <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  802211:	41                   	inc    %ecx
  802212:	0f af 45 10          	imul   0x10(%ebp),%eax
  802216:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  802218:	8a 11                	mov    (%ecx),%dl
  80221a:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80221d:	80 fb 09             	cmp    $0x9,%bl
  802220:	77 da                	ja     8021fc <strtol+0x77>
			dig = *s - '0';
  802222:	0f be d2             	movsbl %dl,%edx
  802225:	83 ea 30             	sub    $0x30,%edx
  802228:	eb e2                	jmp    80220c <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  80222a:	8d 72 bf             	lea    -0x41(%edx),%esi
  80222d:	89 f3                	mov    %esi,%ebx
  80222f:	80 fb 19             	cmp    $0x19,%bl
  802232:	77 08                	ja     80223c <strtol+0xb7>
			dig = *s - 'A' + 10;
  802234:	0f be d2             	movsbl %dl,%edx
  802237:	83 ea 37             	sub    $0x37,%edx
  80223a:	eb d0                	jmp    80220c <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  80223c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  802240:	74 05                	je     802247 <strtol+0xc2>
		*endptr = (char *) s;
  802242:	8b 75 0c             	mov    0xc(%ebp),%esi
  802245:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  802247:	85 ff                	test   %edi,%edi
  802249:	74 02                	je     80224d <strtol+0xc8>
  80224b:	f7 d8                	neg    %eax
}
  80224d:	5b                   	pop    %ebx
  80224e:	5e                   	pop    %esi
  80224f:	5f                   	pop    %edi
  802250:	5d                   	pop    %ebp
  802251:	c3                   	ret    

00802252 <atoi>:

int
atoi(const char *s)
{
  802252:	55                   	push   %ebp
  802253:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  802255:	6a 0a                	push   $0xa
  802257:	6a 00                	push   $0x0
  802259:	ff 75 08             	pushl  0x8(%ebp)
  80225c:	e8 24 ff ff ff       	call   802185 <strtol>
}
  802261:	c9                   	leave  
  802262:	c3                   	ret    

00802263 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  802263:	55                   	push   %ebp
  802264:	89 e5                	mov    %esp,%ebp
  802266:	57                   	push   %edi
  802267:	56                   	push   %esi
  802268:	53                   	push   %ebx
	asm volatile("int %1\n"
  802269:	b8 00 00 00 00       	mov    $0x0,%eax
  80226e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802271:	8b 55 08             	mov    0x8(%ebp),%edx
  802274:	89 c3                	mov    %eax,%ebx
  802276:	89 c7                	mov    %eax,%edi
  802278:	89 c6                	mov    %eax,%esi
  80227a:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80227c:	5b                   	pop    %ebx
  80227d:	5e                   	pop    %esi
  80227e:	5f                   	pop    %edi
  80227f:	5d                   	pop    %ebp
  802280:	c3                   	ret    

00802281 <sys_cgetc>:

int
sys_cgetc(void)
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
  802284:	57                   	push   %edi
  802285:	56                   	push   %esi
  802286:	53                   	push   %ebx
	asm volatile("int %1\n"
  802287:	ba 00 00 00 00       	mov    $0x0,%edx
  80228c:	b8 01 00 00 00       	mov    $0x1,%eax
  802291:	89 d1                	mov    %edx,%ecx
  802293:	89 d3                	mov    %edx,%ebx
  802295:	89 d7                	mov    %edx,%edi
  802297:	89 d6                	mov    %edx,%esi
  802299:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  80229b:	5b                   	pop    %ebx
  80229c:	5e                   	pop    %esi
  80229d:	5f                   	pop    %edi
  80229e:	5d                   	pop    %ebp
  80229f:	c3                   	ret    

008022a0 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8022a0:	55                   	push   %ebp
  8022a1:	89 e5                	mov    %esp,%ebp
  8022a3:	57                   	push   %edi
  8022a4:	56                   	push   %esi
  8022a5:	53                   	push   %ebx
  8022a6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8022a9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8022ae:	b8 03 00 00 00       	mov    $0x3,%eax
  8022b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022b6:	89 cb                	mov    %ecx,%ebx
  8022b8:	89 cf                	mov    %ecx,%edi
  8022ba:	89 ce                	mov    %ecx,%esi
  8022bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8022be:	85 c0                	test   %eax,%eax
  8022c0:	7f 08                	jg     8022ca <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8022c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022c5:	5b                   	pop    %ebx
  8022c6:	5e                   	pop    %esi
  8022c7:	5f                   	pop    %edi
  8022c8:	5d                   	pop    %ebp
  8022c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8022ca:	83 ec 0c             	sub    $0xc,%esp
  8022cd:	50                   	push   %eax
  8022ce:	6a 03                	push   $0x3
  8022d0:	68 ff 3f 80 00       	push   $0x803fff
  8022d5:	6a 23                	push   $0x23
  8022d7:	68 1c 40 80 00       	push   $0x80401c
  8022dc:	e8 4f f5 ff ff       	call   801830 <_panic>

008022e1 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8022e1:	55                   	push   %ebp
  8022e2:	89 e5                	mov    %esp,%ebp
  8022e4:	57                   	push   %edi
  8022e5:	56                   	push   %esi
  8022e6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8022e7:	ba 00 00 00 00       	mov    $0x0,%edx
  8022ec:	b8 02 00 00 00       	mov    $0x2,%eax
  8022f1:	89 d1                	mov    %edx,%ecx
  8022f3:	89 d3                	mov    %edx,%ebx
  8022f5:	89 d7                	mov    %edx,%edi
  8022f7:	89 d6                	mov    %edx,%esi
  8022f9:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8022fb:	5b                   	pop    %ebx
  8022fc:	5e                   	pop    %esi
  8022fd:	5f                   	pop    %edi
  8022fe:	5d                   	pop    %ebp
  8022ff:	c3                   	ret    

00802300 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
  802303:	57                   	push   %edi
  802304:	56                   	push   %esi
  802305:	53                   	push   %ebx
  802306:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802309:	be 00 00 00 00       	mov    $0x0,%esi
  80230e:	b8 04 00 00 00       	mov    $0x4,%eax
  802313:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802316:	8b 55 08             	mov    0x8(%ebp),%edx
  802319:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80231c:	89 f7                	mov    %esi,%edi
  80231e:	cd 30                	int    $0x30
	if(check && ret > 0)
  802320:	85 c0                	test   %eax,%eax
  802322:	7f 08                	jg     80232c <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  802324:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802327:	5b                   	pop    %ebx
  802328:	5e                   	pop    %esi
  802329:	5f                   	pop    %edi
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80232c:	83 ec 0c             	sub    $0xc,%esp
  80232f:	50                   	push   %eax
  802330:	6a 04                	push   $0x4
  802332:	68 ff 3f 80 00       	push   $0x803fff
  802337:	6a 23                	push   $0x23
  802339:	68 1c 40 80 00       	push   $0x80401c
  80233e:	e8 ed f4 ff ff       	call   801830 <_panic>

00802343 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  802343:	55                   	push   %ebp
  802344:	89 e5                	mov    %esp,%ebp
  802346:	57                   	push   %edi
  802347:	56                   	push   %esi
  802348:	53                   	push   %ebx
  802349:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80234c:	b8 05 00 00 00       	mov    $0x5,%eax
  802351:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80235a:	8b 7d 14             	mov    0x14(%ebp),%edi
  80235d:	8b 75 18             	mov    0x18(%ebp),%esi
  802360:	cd 30                	int    $0x30
	if(check && ret > 0)
  802362:	85 c0                	test   %eax,%eax
  802364:	7f 08                	jg     80236e <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  802366:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802369:	5b                   	pop    %ebx
  80236a:	5e                   	pop    %esi
  80236b:	5f                   	pop    %edi
  80236c:	5d                   	pop    %ebp
  80236d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80236e:	83 ec 0c             	sub    $0xc,%esp
  802371:	50                   	push   %eax
  802372:	6a 05                	push   $0x5
  802374:	68 ff 3f 80 00       	push   $0x803fff
  802379:	6a 23                	push   $0x23
  80237b:	68 1c 40 80 00       	push   $0x80401c
  802380:	e8 ab f4 ff ff       	call   801830 <_panic>

00802385 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  802385:	55                   	push   %ebp
  802386:	89 e5                	mov    %esp,%ebp
  802388:	57                   	push   %edi
  802389:	56                   	push   %esi
  80238a:	53                   	push   %ebx
  80238b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80238e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802393:	b8 06 00 00 00       	mov    $0x6,%eax
  802398:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80239b:	8b 55 08             	mov    0x8(%ebp),%edx
  80239e:	89 df                	mov    %ebx,%edi
  8023a0:	89 de                	mov    %ebx,%esi
  8023a2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8023a4:	85 c0                	test   %eax,%eax
  8023a6:	7f 08                	jg     8023b0 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8023a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ab:	5b                   	pop    %ebx
  8023ac:	5e                   	pop    %esi
  8023ad:	5f                   	pop    %edi
  8023ae:	5d                   	pop    %ebp
  8023af:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8023b0:	83 ec 0c             	sub    $0xc,%esp
  8023b3:	50                   	push   %eax
  8023b4:	6a 06                	push   $0x6
  8023b6:	68 ff 3f 80 00       	push   $0x803fff
  8023bb:	6a 23                	push   $0x23
  8023bd:	68 1c 40 80 00       	push   $0x80401c
  8023c2:	e8 69 f4 ff ff       	call   801830 <_panic>

008023c7 <sys_yield>:

void
sys_yield(void)
{
  8023c7:	55                   	push   %ebp
  8023c8:	89 e5                	mov    %esp,%ebp
  8023ca:	57                   	push   %edi
  8023cb:	56                   	push   %esi
  8023cc:	53                   	push   %ebx
	asm volatile("int %1\n"
  8023cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8023d2:	b8 0b 00 00 00       	mov    $0xb,%eax
  8023d7:	89 d1                	mov    %edx,%ecx
  8023d9:	89 d3                	mov    %edx,%ebx
  8023db:	89 d7                	mov    %edx,%edi
  8023dd:	89 d6                	mov    %edx,%esi
  8023df:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8023e1:	5b                   	pop    %ebx
  8023e2:	5e                   	pop    %esi
  8023e3:	5f                   	pop    %edi
  8023e4:	5d                   	pop    %ebp
  8023e5:	c3                   	ret    

008023e6 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8023e6:	55                   	push   %ebp
  8023e7:	89 e5                	mov    %esp,%ebp
  8023e9:	57                   	push   %edi
  8023ea:	56                   	push   %esi
  8023eb:	53                   	push   %ebx
  8023ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8023ef:	bb 00 00 00 00       	mov    $0x0,%ebx
  8023f4:	b8 08 00 00 00       	mov    $0x8,%eax
  8023f9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8023fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ff:	89 df                	mov    %ebx,%edi
  802401:	89 de                	mov    %ebx,%esi
  802403:	cd 30                	int    $0x30
	if(check && ret > 0)
  802405:	85 c0                	test   %eax,%eax
  802407:	7f 08                	jg     802411 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  802409:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240c:	5b                   	pop    %ebx
  80240d:	5e                   	pop    %esi
  80240e:	5f                   	pop    %edi
  80240f:	5d                   	pop    %ebp
  802410:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802411:	83 ec 0c             	sub    $0xc,%esp
  802414:	50                   	push   %eax
  802415:	6a 08                	push   $0x8
  802417:	68 ff 3f 80 00       	push   $0x803fff
  80241c:	6a 23                	push   $0x23
  80241e:	68 1c 40 80 00       	push   $0x80401c
  802423:	e8 08 f4 ff ff       	call   801830 <_panic>

00802428 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  802428:	55                   	push   %ebp
  802429:	89 e5                	mov    %esp,%ebp
  80242b:	57                   	push   %edi
  80242c:	56                   	push   %esi
  80242d:	53                   	push   %ebx
  80242e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802431:	b9 00 00 00 00       	mov    $0x0,%ecx
  802436:	b8 0c 00 00 00       	mov    $0xc,%eax
  80243b:	8b 55 08             	mov    0x8(%ebp),%edx
  80243e:	89 cb                	mov    %ecx,%ebx
  802440:	89 cf                	mov    %ecx,%edi
  802442:	89 ce                	mov    %ecx,%esi
  802444:	cd 30                	int    $0x30
	if(check && ret > 0)
  802446:	85 c0                	test   %eax,%eax
  802448:	7f 08                	jg     802452 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80244a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80244d:	5b                   	pop    %ebx
  80244e:	5e                   	pop    %esi
  80244f:	5f                   	pop    %edi
  802450:	5d                   	pop    %ebp
  802451:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802452:	83 ec 0c             	sub    $0xc,%esp
  802455:	50                   	push   %eax
  802456:	6a 0c                	push   $0xc
  802458:	68 ff 3f 80 00       	push   $0x803fff
  80245d:	6a 23                	push   $0x23
  80245f:	68 1c 40 80 00       	push   $0x80401c
  802464:	e8 c7 f3 ff ff       	call   801830 <_panic>

00802469 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  802469:	55                   	push   %ebp
  80246a:	89 e5                	mov    %esp,%ebp
  80246c:	57                   	push   %edi
  80246d:	56                   	push   %esi
  80246e:	53                   	push   %ebx
  80246f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802472:	bb 00 00 00 00       	mov    $0x0,%ebx
  802477:	b8 09 00 00 00       	mov    $0x9,%eax
  80247c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80247f:	8b 55 08             	mov    0x8(%ebp),%edx
  802482:	89 df                	mov    %ebx,%edi
  802484:	89 de                	mov    %ebx,%esi
  802486:	cd 30                	int    $0x30
	if(check && ret > 0)
  802488:	85 c0                	test   %eax,%eax
  80248a:	7f 08                	jg     802494 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80248c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80248f:	5b                   	pop    %ebx
  802490:	5e                   	pop    %esi
  802491:	5f                   	pop    %edi
  802492:	5d                   	pop    %ebp
  802493:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  802494:	83 ec 0c             	sub    $0xc,%esp
  802497:	50                   	push   %eax
  802498:	6a 09                	push   $0x9
  80249a:	68 ff 3f 80 00       	push   $0x803fff
  80249f:	6a 23                	push   $0x23
  8024a1:	68 1c 40 80 00       	push   $0x80401c
  8024a6:	e8 85 f3 ff ff       	call   801830 <_panic>

008024ab <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8024ab:	55                   	push   %ebp
  8024ac:	89 e5                	mov    %esp,%ebp
  8024ae:	57                   	push   %edi
  8024af:	56                   	push   %esi
  8024b0:	53                   	push   %ebx
  8024b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8024b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8024b9:	b8 0a 00 00 00       	mov    $0xa,%eax
  8024be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8024c4:	89 df                	mov    %ebx,%edi
  8024c6:	89 de                	mov    %ebx,%esi
  8024c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8024ca:	85 c0                	test   %eax,%eax
  8024cc:	7f 08                	jg     8024d6 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8024ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024d1:	5b                   	pop    %ebx
  8024d2:	5e                   	pop    %esi
  8024d3:	5f                   	pop    %edi
  8024d4:	5d                   	pop    %ebp
  8024d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	50                   	push   %eax
  8024da:	6a 0a                	push   $0xa
  8024dc:	68 ff 3f 80 00       	push   $0x803fff
  8024e1:	6a 23                	push   $0x23
  8024e3:	68 1c 40 80 00       	push   $0x80401c
  8024e8:	e8 43 f3 ff ff       	call   801830 <_panic>

008024ed <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8024ed:	55                   	push   %ebp
  8024ee:	89 e5                	mov    %esp,%ebp
  8024f0:	57                   	push   %edi
  8024f1:	56                   	push   %esi
  8024f2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8024f3:	be 00 00 00 00       	mov    $0x0,%esi
  8024f8:	b8 0d 00 00 00       	mov    $0xd,%eax
  8024fd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802500:	8b 55 08             	mov    0x8(%ebp),%edx
  802503:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802506:	8b 7d 14             	mov    0x14(%ebp),%edi
  802509:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80250b:	5b                   	pop    %ebx
  80250c:	5e                   	pop    %esi
  80250d:	5f                   	pop    %edi
  80250e:	5d                   	pop    %ebp
  80250f:	c3                   	ret    

00802510 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	57                   	push   %edi
  802514:	56                   	push   %esi
  802515:	53                   	push   %ebx
  802516:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  802519:	b9 00 00 00 00       	mov    $0x0,%ecx
  80251e:	b8 0e 00 00 00       	mov    $0xe,%eax
  802523:	8b 55 08             	mov    0x8(%ebp),%edx
  802526:	89 cb                	mov    %ecx,%ebx
  802528:	89 cf                	mov    %ecx,%edi
  80252a:	89 ce                	mov    %ecx,%esi
  80252c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80252e:	85 c0                	test   %eax,%eax
  802530:	7f 08                	jg     80253a <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  802532:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802535:	5b                   	pop    %ebx
  802536:	5e                   	pop    %esi
  802537:	5f                   	pop    %edi
  802538:	5d                   	pop    %ebp
  802539:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80253a:	83 ec 0c             	sub    $0xc,%esp
  80253d:	50                   	push   %eax
  80253e:	6a 0e                	push   $0xe
  802540:	68 ff 3f 80 00       	push   $0x803fff
  802545:	6a 23                	push   $0x23
  802547:	68 1c 40 80 00       	push   $0x80401c
  80254c:	e8 df f2 ff ff       	call   801830 <_panic>

00802551 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  802551:	55                   	push   %ebp
  802552:	89 e5                	mov    %esp,%ebp
  802554:	57                   	push   %edi
  802555:	56                   	push   %esi
  802556:	53                   	push   %ebx
	asm volatile("int %1\n"
  802557:	be 00 00 00 00       	mov    $0x0,%esi
  80255c:	b8 0f 00 00 00       	mov    $0xf,%eax
  802561:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802564:	8b 55 08             	mov    0x8(%ebp),%edx
  802567:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80256a:	89 f7                	mov    %esi,%edi
  80256c:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80256e:	5b                   	pop    %ebx
  80256f:	5e                   	pop    %esi
  802570:	5f                   	pop    %edi
  802571:	5d                   	pop    %ebp
  802572:	c3                   	ret    

00802573 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  802573:	55                   	push   %ebp
  802574:	89 e5                	mov    %esp,%ebp
  802576:	57                   	push   %edi
  802577:	56                   	push   %esi
  802578:	53                   	push   %ebx
	asm volatile("int %1\n"
  802579:	be 00 00 00 00       	mov    $0x0,%esi
  80257e:	b8 10 00 00 00       	mov    $0x10,%eax
  802583:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802586:	8b 55 08             	mov    0x8(%ebp),%edx
  802589:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80258c:	89 f7                	mov    %esi,%edi
  80258e:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  802590:	5b                   	pop    %ebx
  802591:	5e                   	pop    %esi
  802592:	5f                   	pop    %edi
  802593:	5d                   	pop    %ebp
  802594:	c3                   	ret    

00802595 <sys_set_console_color>:

void sys_set_console_color(int color) {
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	57                   	push   %edi
  802599:	56                   	push   %esi
  80259a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80259b:	b9 00 00 00 00       	mov    $0x0,%ecx
  8025a0:	b8 11 00 00 00       	mov    $0x11,%eax
  8025a5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025a8:	89 cb                	mov    %ecx,%ebx
  8025aa:	89 cf                	mov    %ecx,%edi
  8025ac:	89 ce                	mov    %ecx,%esi
  8025ae:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8025b0:	5b                   	pop    %ebx
  8025b1:	5e                   	pop    %esi
  8025b2:	5f                   	pop    %edi
  8025b3:	5d                   	pop    %ebp
  8025b4:	c3                   	ret    

008025b5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8025b5:	55                   	push   %ebp
  8025b6:	89 e5                	mov    %esp,%ebp
  8025b8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8025bb:	83 3d 10 a0 80 00 00 	cmpl   $0x0,0x80a010
  8025c2:	74 0a                	je     8025ce <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8025c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c7:	a3 10 a0 80 00       	mov    %eax,0x80a010
}
  8025cc:	c9                   	leave  
  8025cd:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  8025ce:	e8 0e fd ff ff       	call   8022e1 <sys_getenvid>
  8025d3:	83 ec 04             	sub    $0x4,%esp
  8025d6:	6a 07                	push   $0x7
  8025d8:	68 00 f0 bf ee       	push   $0xeebff000
  8025dd:	50                   	push   %eax
  8025de:	e8 1d fd ff ff       	call   802300 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8025e3:	e8 f9 fc ff ff       	call   8022e1 <sys_getenvid>
  8025e8:	83 c4 08             	add    $0x8,%esp
  8025eb:	68 fb 25 80 00       	push   $0x8025fb
  8025f0:	50                   	push   %eax
  8025f1:	e8 b5 fe ff ff       	call   8024ab <sys_env_set_pgfault_upcall>
  8025f6:	83 c4 10             	add    $0x10,%esp
  8025f9:	eb c9                	jmp    8025c4 <set_pgfault_handler+0xf>

008025fb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8025fb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8025fc:	a1 10 a0 80 00       	mov    0x80a010,%eax
	call *%eax
  802601:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802603:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  802606:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80260a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80260e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802611:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802613:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  802617:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80261a:	61                   	popa   
	addl $4, %esp
  80261b:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80261e:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80261f:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802620:	c3                   	ret    

00802621 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802621:	55                   	push   %ebp
  802622:	89 e5                	mov    %esp,%ebp
  802624:	57                   	push   %edi
  802625:	56                   	push   %esi
  802626:	53                   	push   %ebx
  802627:	83 ec 0c             	sub    $0xc,%esp
  80262a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80262d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802630:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802633:	85 ff                	test   %edi,%edi
  802635:	74 53                	je     80268a <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  802637:	83 ec 0c             	sub    $0xc,%esp
  80263a:	57                   	push   %edi
  80263b:	e8 d0 fe ff ff       	call   802510 <sys_ipc_recv>
  802640:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802643:	85 db                	test   %ebx,%ebx
  802645:	74 0b                	je     802652 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  802647:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80264d:	8b 52 74             	mov    0x74(%edx),%edx
  802650:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802652:	85 f6                	test   %esi,%esi
  802654:	74 0f                	je     802665 <ipc_recv+0x44>
  802656:	85 ff                	test   %edi,%edi
  802658:	74 0b                	je     802665 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80265a:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  802660:	8b 52 78             	mov    0x78(%edx),%edx
  802663:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802665:	85 c0                	test   %eax,%eax
  802667:	74 30                	je     802699 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802669:	85 db                	test   %ebx,%ebx
  80266b:	74 06                	je     802673 <ipc_recv+0x52>
      		*from_env_store = 0;
  80266d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802673:	85 f6                	test   %esi,%esi
  802675:	74 2c                	je     8026a3 <ipc_recv+0x82>
      		*perm_store = 0;
  802677:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80267d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802682:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802685:	5b                   	pop    %ebx
  802686:	5e                   	pop    %esi
  802687:	5f                   	pop    %edi
  802688:	5d                   	pop    %ebp
  802689:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80268a:	83 ec 0c             	sub    $0xc,%esp
  80268d:	6a ff                	push   $0xffffffff
  80268f:	e8 7c fe ff ff       	call   802510 <sys_ipc_recv>
  802694:	83 c4 10             	add    $0x10,%esp
  802697:	eb aa                	jmp    802643 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802699:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80269e:	8b 40 70             	mov    0x70(%eax),%eax
  8026a1:	eb df                	jmp    802682 <ipc_recv+0x61>
		return -1;
  8026a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8026a8:	eb d8                	jmp    802682 <ipc_recv+0x61>

008026aa <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8026aa:	55                   	push   %ebp
  8026ab:	89 e5                	mov    %esp,%ebp
  8026ad:	57                   	push   %edi
  8026ae:	56                   	push   %esi
  8026af:	53                   	push   %ebx
  8026b0:	83 ec 0c             	sub    $0xc,%esp
  8026b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8026b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8026b9:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8026bc:	85 db                	test   %ebx,%ebx
  8026be:	75 22                	jne    8026e2 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8026c0:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8026c5:	eb 1b                	jmp    8026e2 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8026c7:	68 2c 40 80 00       	push   $0x80402c
  8026cc:	68 a0 38 80 00       	push   $0x8038a0
  8026d1:	6a 48                	push   $0x48
  8026d3:	68 4f 40 80 00       	push   $0x80404f
  8026d8:	e8 53 f1 ff ff       	call   801830 <_panic>
		sys_yield();
  8026dd:	e8 e5 fc ff ff       	call   8023c7 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8026e2:	57                   	push   %edi
  8026e3:	53                   	push   %ebx
  8026e4:	56                   	push   %esi
  8026e5:	ff 75 08             	pushl  0x8(%ebp)
  8026e8:	e8 00 fe ff ff       	call   8024ed <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8026ed:	83 c4 10             	add    $0x10,%esp
  8026f0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8026f3:	74 e8                	je     8026dd <ipc_send+0x33>
  8026f5:	85 c0                	test   %eax,%eax
  8026f7:	75 ce                	jne    8026c7 <ipc_send+0x1d>
		sys_yield();
  8026f9:	e8 c9 fc ff ff       	call   8023c7 <sys_yield>
		
	}
	
}
  8026fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802701:	5b                   	pop    %ebx
  802702:	5e                   	pop    %esi
  802703:	5f                   	pop    %edi
  802704:	5d                   	pop    %ebp
  802705:	c3                   	ret    

00802706 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80270c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802711:	89 c2                	mov    %eax,%edx
  802713:	c1 e2 05             	shl    $0x5,%edx
  802716:	29 c2                	sub    %eax,%edx
  802718:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80271f:	8b 52 50             	mov    0x50(%edx),%edx
  802722:	39 ca                	cmp    %ecx,%edx
  802724:	74 0f                	je     802735 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  802726:	40                   	inc    %eax
  802727:	3d 00 04 00 00       	cmp    $0x400,%eax
  80272c:	75 e3                	jne    802711 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80272e:	b8 00 00 00 00       	mov    $0x0,%eax
  802733:	eb 11                	jmp    802746 <ipc_find_env+0x40>
			return envs[i].env_id;
  802735:	89 c2                	mov    %eax,%edx
  802737:	c1 e2 05             	shl    $0x5,%edx
  80273a:	29 c2                	sub    %eax,%edx
  80273c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802743:	8b 40 48             	mov    0x48(%eax),%eax
}
  802746:	5d                   	pop    %ebp
  802747:	c3                   	ret    

00802748 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  802748:	55                   	push   %ebp
  802749:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80274b:	8b 45 08             	mov    0x8(%ebp),%eax
  80274e:	05 00 00 00 30       	add    $0x30000000,%eax
  802753:	c1 e8 0c             	shr    $0xc,%eax
}
  802756:	5d                   	pop    %ebp
  802757:	c3                   	ret    

00802758 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  802758:	55                   	push   %ebp
  802759:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80275b:	8b 45 08             	mov    0x8(%ebp),%eax
  80275e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  802763:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  802768:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80276d:	5d                   	pop    %ebp
  80276e:	c3                   	ret    

0080276f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80276f:	55                   	push   %ebp
  802770:	89 e5                	mov    %esp,%ebp
  802772:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802775:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80277a:	89 c2                	mov    %eax,%edx
  80277c:	c1 ea 16             	shr    $0x16,%edx
  80277f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  802786:	f6 c2 01             	test   $0x1,%dl
  802789:	74 2a                	je     8027b5 <fd_alloc+0x46>
  80278b:	89 c2                	mov    %eax,%edx
  80278d:	c1 ea 0c             	shr    $0xc,%edx
  802790:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  802797:	f6 c2 01             	test   $0x1,%dl
  80279a:	74 19                	je     8027b5 <fd_alloc+0x46>
  80279c:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8027a1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8027a6:	75 d2                	jne    80277a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8027a8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8027ae:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8027b3:	eb 07                	jmp    8027bc <fd_alloc+0x4d>
			*fd_store = fd;
  8027b5:	89 01                	mov    %eax,(%ecx)
			return 0;
  8027b7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027bc:	5d                   	pop    %ebp
  8027bd:	c3                   	ret    

008027be <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8027be:	55                   	push   %ebp
  8027bf:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8027c1:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8027c5:	77 39                	ja     802800 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8027c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ca:	c1 e0 0c             	shl    $0xc,%eax
  8027cd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8027d2:	89 c2                	mov    %eax,%edx
  8027d4:	c1 ea 16             	shr    $0x16,%edx
  8027d7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8027de:	f6 c2 01             	test   $0x1,%dl
  8027e1:	74 24                	je     802807 <fd_lookup+0x49>
  8027e3:	89 c2                	mov    %eax,%edx
  8027e5:	c1 ea 0c             	shr    $0xc,%edx
  8027e8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8027ef:	f6 c2 01             	test   $0x1,%dl
  8027f2:	74 1a                	je     80280e <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8027f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f7:	89 02                	mov    %eax,(%edx)
	return 0;
  8027f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027fe:	5d                   	pop    %ebp
  8027ff:	c3                   	ret    
		return -E_INVAL;
  802800:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802805:	eb f7                	jmp    8027fe <fd_lookup+0x40>
		return -E_INVAL;
  802807:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80280c:	eb f0                	jmp    8027fe <fd_lookup+0x40>
  80280e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802813:	eb e9                	jmp    8027fe <fd_lookup+0x40>

00802815 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  802815:	55                   	push   %ebp
  802816:	89 e5                	mov    %esp,%ebp
  802818:	83 ec 08             	sub    $0x8,%esp
  80281b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80281e:	ba dc 40 80 00       	mov    $0x8040dc,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  802823:	b8 44 90 80 00       	mov    $0x809044,%eax
		if (devtab[i]->dev_id == dev_id) {
  802828:	39 08                	cmp    %ecx,(%eax)
  80282a:	74 33                	je     80285f <dev_lookup+0x4a>
  80282c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80282f:	8b 02                	mov    (%edx),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	75 f3                	jne    802828 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  802835:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80283a:	8b 40 48             	mov    0x48(%eax),%eax
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	51                   	push   %ecx
  802841:	50                   	push   %eax
  802842:	68 5c 40 80 00       	push   $0x80405c
  802847:	e8 f7 f0 ff ff       	call   801943 <cprintf>
	*dev = 0;
  80284c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80284f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  802855:	83 c4 10             	add    $0x10,%esp
  802858:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    
			*dev = devtab[i];
  80285f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802862:	89 01                	mov    %eax,(%ecx)
			return 0;
  802864:	b8 00 00 00 00       	mov    $0x0,%eax
  802869:	eb f2                	jmp    80285d <dev_lookup+0x48>

0080286b <fd_close>:
{
  80286b:	55                   	push   %ebp
  80286c:	89 e5                	mov    %esp,%ebp
  80286e:	57                   	push   %edi
  80286f:	56                   	push   %esi
  802870:	53                   	push   %ebx
  802871:	83 ec 1c             	sub    $0x1c,%esp
  802874:	8b 75 08             	mov    0x8(%ebp),%esi
  802877:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80287a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80287d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80287e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  802884:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  802887:	50                   	push   %eax
  802888:	e8 31 ff ff ff       	call   8027be <fd_lookup>
  80288d:	89 c7                	mov    %eax,%edi
  80288f:	83 c4 08             	add    $0x8,%esp
  802892:	85 c0                	test   %eax,%eax
  802894:	78 05                	js     80289b <fd_close+0x30>
	    || fd != fd2)
  802896:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  802899:	74 13                	je     8028ae <fd_close+0x43>
		return (must_exist ? r : 0);
  80289b:	84 db                	test   %bl,%bl
  80289d:	75 05                	jne    8028a4 <fd_close+0x39>
  80289f:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8028a4:	89 f8                	mov    %edi,%eax
  8028a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8028a9:	5b                   	pop    %ebx
  8028aa:	5e                   	pop    %esi
  8028ab:	5f                   	pop    %edi
  8028ac:	5d                   	pop    %ebp
  8028ad:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8028ae:	83 ec 08             	sub    $0x8,%esp
  8028b1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8028b4:	50                   	push   %eax
  8028b5:	ff 36                	pushl  (%esi)
  8028b7:	e8 59 ff ff ff       	call   802815 <dev_lookup>
  8028bc:	89 c7                	mov    %eax,%edi
  8028be:	83 c4 10             	add    $0x10,%esp
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	78 15                	js     8028da <fd_close+0x6f>
		if (dev->dev_close)
  8028c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8028c8:	8b 40 10             	mov    0x10(%eax),%eax
  8028cb:	85 c0                	test   %eax,%eax
  8028cd:	74 1b                	je     8028ea <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8028cf:	83 ec 0c             	sub    $0xc,%esp
  8028d2:	56                   	push   %esi
  8028d3:	ff d0                	call   *%eax
  8028d5:	89 c7                	mov    %eax,%edi
  8028d7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8028da:	83 ec 08             	sub    $0x8,%esp
  8028dd:	56                   	push   %esi
  8028de:	6a 00                	push   $0x0
  8028e0:	e8 a0 fa ff ff       	call   802385 <sys_page_unmap>
	return r;
  8028e5:	83 c4 10             	add    $0x10,%esp
  8028e8:	eb ba                	jmp    8028a4 <fd_close+0x39>
			r = 0;
  8028ea:	bf 00 00 00 00       	mov    $0x0,%edi
  8028ef:	eb e9                	jmp    8028da <fd_close+0x6f>

008028f1 <close>:

int
close(int fdnum)
{
  8028f1:	55                   	push   %ebp
  8028f2:	89 e5                	mov    %esp,%ebp
  8028f4:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8028f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8028fa:	50                   	push   %eax
  8028fb:	ff 75 08             	pushl  0x8(%ebp)
  8028fe:	e8 bb fe ff ff       	call   8027be <fd_lookup>
  802903:	83 c4 08             	add    $0x8,%esp
  802906:	85 c0                	test   %eax,%eax
  802908:	78 10                	js     80291a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80290a:	83 ec 08             	sub    $0x8,%esp
  80290d:	6a 01                	push   $0x1
  80290f:	ff 75 f4             	pushl  -0xc(%ebp)
  802912:	e8 54 ff ff ff       	call   80286b <fd_close>
  802917:	83 c4 10             	add    $0x10,%esp
}
  80291a:	c9                   	leave  
  80291b:	c3                   	ret    

0080291c <close_all>:

void
close_all(void)
{
  80291c:	55                   	push   %ebp
  80291d:	89 e5                	mov    %esp,%ebp
  80291f:	53                   	push   %ebx
  802920:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  802923:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  802928:	83 ec 0c             	sub    $0xc,%esp
  80292b:	53                   	push   %ebx
  80292c:	e8 c0 ff ff ff       	call   8028f1 <close>
	for (i = 0; i < MAXFD; i++)
  802931:	43                   	inc    %ebx
  802932:	83 c4 10             	add    $0x10,%esp
  802935:	83 fb 20             	cmp    $0x20,%ebx
  802938:	75 ee                	jne    802928 <close_all+0xc>
}
  80293a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80293d:	c9                   	leave  
  80293e:	c3                   	ret    

0080293f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80293f:	55                   	push   %ebp
  802940:	89 e5                	mov    %esp,%ebp
  802942:	57                   	push   %edi
  802943:	56                   	push   %esi
  802944:	53                   	push   %ebx
  802945:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  802948:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80294b:	50                   	push   %eax
  80294c:	ff 75 08             	pushl  0x8(%ebp)
  80294f:	e8 6a fe ff ff       	call   8027be <fd_lookup>
  802954:	89 c3                	mov    %eax,%ebx
  802956:	83 c4 08             	add    $0x8,%esp
  802959:	85 c0                	test   %eax,%eax
  80295b:	0f 88 81 00 00 00    	js     8029e2 <dup+0xa3>
		return r;
	close(newfdnum);
  802961:	83 ec 0c             	sub    $0xc,%esp
  802964:	ff 75 0c             	pushl  0xc(%ebp)
  802967:	e8 85 ff ff ff       	call   8028f1 <close>

	newfd = INDEX2FD(newfdnum);
  80296c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80296f:	c1 e6 0c             	shl    $0xc,%esi
  802972:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  802978:	83 c4 04             	add    $0x4,%esp
  80297b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80297e:	e8 d5 fd ff ff       	call   802758 <fd2data>
  802983:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  802985:	89 34 24             	mov    %esi,(%esp)
  802988:	e8 cb fd ff ff       	call   802758 <fd2data>
  80298d:	83 c4 10             	add    $0x10,%esp
  802990:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  802992:	89 d8                	mov    %ebx,%eax
  802994:	c1 e8 16             	shr    $0x16,%eax
  802997:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80299e:	a8 01                	test   $0x1,%al
  8029a0:	74 11                	je     8029b3 <dup+0x74>
  8029a2:	89 d8                	mov    %ebx,%eax
  8029a4:	c1 e8 0c             	shr    $0xc,%eax
  8029a7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8029ae:	f6 c2 01             	test   $0x1,%dl
  8029b1:	75 39                	jne    8029ec <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8029b3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8029b6:	89 d0                	mov    %edx,%eax
  8029b8:	c1 e8 0c             	shr    $0xc,%eax
  8029bb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8029c2:	83 ec 0c             	sub    $0xc,%esp
  8029c5:	25 07 0e 00 00       	and    $0xe07,%eax
  8029ca:	50                   	push   %eax
  8029cb:	56                   	push   %esi
  8029cc:	6a 00                	push   $0x0
  8029ce:	52                   	push   %edx
  8029cf:	6a 00                	push   $0x0
  8029d1:	e8 6d f9 ff ff       	call   802343 <sys_page_map>
  8029d6:	89 c3                	mov    %eax,%ebx
  8029d8:	83 c4 20             	add    $0x20,%esp
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	78 31                	js     802a10 <dup+0xd1>
		goto err;

	return newfdnum;
  8029df:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8029e2:	89 d8                	mov    %ebx,%eax
  8029e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029e7:	5b                   	pop    %ebx
  8029e8:	5e                   	pop    %esi
  8029e9:	5f                   	pop    %edi
  8029ea:	5d                   	pop    %ebp
  8029eb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8029ec:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8029f3:	83 ec 0c             	sub    $0xc,%esp
  8029f6:	25 07 0e 00 00       	and    $0xe07,%eax
  8029fb:	50                   	push   %eax
  8029fc:	57                   	push   %edi
  8029fd:	6a 00                	push   $0x0
  8029ff:	53                   	push   %ebx
  802a00:	6a 00                	push   $0x0
  802a02:	e8 3c f9 ff ff       	call   802343 <sys_page_map>
  802a07:	89 c3                	mov    %eax,%ebx
  802a09:	83 c4 20             	add    $0x20,%esp
  802a0c:	85 c0                	test   %eax,%eax
  802a0e:	79 a3                	jns    8029b3 <dup+0x74>
	sys_page_unmap(0, newfd);
  802a10:	83 ec 08             	sub    $0x8,%esp
  802a13:	56                   	push   %esi
  802a14:	6a 00                	push   $0x0
  802a16:	e8 6a f9 ff ff       	call   802385 <sys_page_unmap>
	sys_page_unmap(0, nva);
  802a1b:	83 c4 08             	add    $0x8,%esp
  802a1e:	57                   	push   %edi
  802a1f:	6a 00                	push   $0x0
  802a21:	e8 5f f9 ff ff       	call   802385 <sys_page_unmap>
	return r;
  802a26:	83 c4 10             	add    $0x10,%esp
  802a29:	eb b7                	jmp    8029e2 <dup+0xa3>

00802a2b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  802a2b:	55                   	push   %ebp
  802a2c:	89 e5                	mov    %esp,%ebp
  802a2e:	53                   	push   %ebx
  802a2f:	83 ec 14             	sub    $0x14,%esp
  802a32:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802a35:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802a38:	50                   	push   %eax
  802a39:	53                   	push   %ebx
  802a3a:	e8 7f fd ff ff       	call   8027be <fd_lookup>
  802a3f:	83 c4 08             	add    $0x8,%esp
  802a42:	85 c0                	test   %eax,%eax
  802a44:	78 3f                	js     802a85 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802a46:	83 ec 08             	sub    $0x8,%esp
  802a49:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802a4c:	50                   	push   %eax
  802a4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a50:	ff 30                	pushl  (%eax)
  802a52:	e8 be fd ff ff       	call   802815 <dev_lookup>
  802a57:	83 c4 10             	add    $0x10,%esp
  802a5a:	85 c0                	test   %eax,%eax
  802a5c:	78 27                	js     802a85 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  802a5e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802a61:	8b 42 08             	mov    0x8(%edx),%eax
  802a64:	83 e0 03             	and    $0x3,%eax
  802a67:	83 f8 01             	cmp    $0x1,%eax
  802a6a:	74 1e                	je     802a8a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802a6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6f:	8b 40 08             	mov    0x8(%eax),%eax
  802a72:	85 c0                	test   %eax,%eax
  802a74:	74 35                	je     802aab <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802a76:	83 ec 04             	sub    $0x4,%esp
  802a79:	ff 75 10             	pushl  0x10(%ebp)
  802a7c:	ff 75 0c             	pushl  0xc(%ebp)
  802a7f:	52                   	push   %edx
  802a80:	ff d0                	call   *%eax
  802a82:	83 c4 10             	add    $0x10,%esp
}
  802a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802a88:	c9                   	leave  
  802a89:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802a8a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802a8f:	8b 40 48             	mov    0x48(%eax),%eax
  802a92:	83 ec 04             	sub    $0x4,%esp
  802a95:	53                   	push   %ebx
  802a96:	50                   	push   %eax
  802a97:	68 a0 40 80 00       	push   $0x8040a0
  802a9c:	e8 a2 ee ff ff       	call   801943 <cprintf>
		return -E_INVAL;
  802aa1:	83 c4 10             	add    $0x10,%esp
  802aa4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802aa9:	eb da                	jmp    802a85 <read+0x5a>
		return -E_NOT_SUPP;
  802aab:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802ab0:	eb d3                	jmp    802a85 <read+0x5a>

00802ab2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
  802ab5:	57                   	push   %edi
  802ab6:	56                   	push   %esi
  802ab7:	53                   	push   %ebx
  802ab8:	83 ec 0c             	sub    $0xc,%esp
  802abb:	8b 7d 08             	mov    0x8(%ebp),%edi
  802abe:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  802ac1:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ac6:	39 f3                	cmp    %esi,%ebx
  802ac8:	73 25                	jae    802aef <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aca:	83 ec 04             	sub    $0x4,%esp
  802acd:	89 f0                	mov    %esi,%eax
  802acf:	29 d8                	sub    %ebx,%eax
  802ad1:	50                   	push   %eax
  802ad2:	89 d8                	mov    %ebx,%eax
  802ad4:	03 45 0c             	add    0xc(%ebp),%eax
  802ad7:	50                   	push   %eax
  802ad8:	57                   	push   %edi
  802ad9:	e8 4d ff ff ff       	call   802a2b <read>
		if (m < 0)
  802ade:	83 c4 10             	add    $0x10,%esp
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	78 08                	js     802aed <readn+0x3b>
			return m;
		if (m == 0)
  802ae5:	85 c0                	test   %eax,%eax
  802ae7:	74 06                	je     802aef <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802ae9:	01 c3                	add    %eax,%ebx
  802aeb:	eb d9                	jmp    802ac6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802aed:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  802aef:	89 d8                	mov    %ebx,%eax
  802af1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802af4:	5b                   	pop    %ebx
  802af5:	5e                   	pop    %esi
  802af6:	5f                   	pop    %edi
  802af7:	5d                   	pop    %ebp
  802af8:	c3                   	ret    

00802af9 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802af9:	55                   	push   %ebp
  802afa:	89 e5                	mov    %esp,%ebp
  802afc:	53                   	push   %ebx
  802afd:	83 ec 14             	sub    $0x14,%esp
  802b00:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802b03:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802b06:	50                   	push   %eax
  802b07:	53                   	push   %ebx
  802b08:	e8 b1 fc ff ff       	call   8027be <fd_lookup>
  802b0d:	83 c4 08             	add    $0x8,%esp
  802b10:	85 c0                	test   %eax,%eax
  802b12:	78 3a                	js     802b4e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802b14:	83 ec 08             	sub    $0x8,%esp
  802b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802b1a:	50                   	push   %eax
  802b1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b1e:	ff 30                	pushl  (%eax)
  802b20:	e8 f0 fc ff ff       	call   802815 <dev_lookup>
  802b25:	83 c4 10             	add    $0x10,%esp
  802b28:	85 c0                	test   %eax,%eax
  802b2a:	78 22                	js     802b4e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802b2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802b33:	74 1e                	je     802b53 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  802b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b38:	8b 52 0c             	mov    0xc(%edx),%edx
  802b3b:	85 d2                	test   %edx,%edx
  802b3d:	74 35                	je     802b74 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	ff 75 10             	pushl  0x10(%ebp)
  802b45:	ff 75 0c             	pushl  0xc(%ebp)
  802b48:	50                   	push   %eax
  802b49:	ff d2                	call   *%edx
  802b4b:	83 c4 10             	add    $0x10,%esp
}
  802b4e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802b51:	c9                   	leave  
  802b52:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  802b53:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  802b58:	8b 40 48             	mov    0x48(%eax),%eax
  802b5b:	83 ec 04             	sub    $0x4,%esp
  802b5e:	53                   	push   %ebx
  802b5f:	50                   	push   %eax
  802b60:	68 bc 40 80 00       	push   $0x8040bc
  802b65:	e8 d9 ed ff ff       	call   801943 <cprintf>
		return -E_INVAL;
  802b6a:	83 c4 10             	add    $0x10,%esp
  802b6d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802b72:	eb da                	jmp    802b4e <write+0x55>
		return -E_NOT_SUPP;
  802b74:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802b79:	eb d3                	jmp    802b4e <write+0x55>

00802b7b <seek>:

int
seek(int fdnum, off_t offset)
{
  802b7b:	55                   	push   %ebp
  802b7c:	89 e5                	mov    %esp,%ebp
  802b7e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802b81:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802b84:	50                   	push   %eax
  802b85:	ff 75 08             	pushl  0x8(%ebp)
  802b88:	e8 31 fc ff ff       	call   8027be <fd_lookup>
  802b8d:	83 c4 08             	add    $0x8,%esp
  802b90:	85 c0                	test   %eax,%eax
  802b92:	78 0e                	js     802ba2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802b94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  802b9a:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  802b9d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ba2:	c9                   	leave  
  802ba3:	c3                   	ret    

00802ba4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802ba4:	55                   	push   %ebp
  802ba5:	89 e5                	mov    %esp,%ebp
  802ba7:	53                   	push   %ebx
  802ba8:	83 ec 14             	sub    $0x14,%esp
  802bab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  802bae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802bb1:	50                   	push   %eax
  802bb2:	53                   	push   %ebx
  802bb3:	e8 06 fc ff ff       	call   8027be <fd_lookup>
  802bb8:	83 c4 08             	add    $0x8,%esp
  802bbb:	85 c0                	test   %eax,%eax
  802bbd:	78 37                	js     802bf6 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802bbf:	83 ec 08             	sub    $0x8,%esp
  802bc2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802bc5:	50                   	push   %eax
  802bc6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bc9:	ff 30                	pushl  (%eax)
  802bcb:	e8 45 fc ff ff       	call   802815 <dev_lookup>
  802bd0:	83 c4 10             	add    $0x10,%esp
  802bd3:	85 c0                	test   %eax,%eax
  802bd5:	78 1f                	js     802bf6 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802bd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802bda:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  802bde:	74 1b                	je     802bfb <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  802be0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802be3:	8b 52 18             	mov    0x18(%edx),%edx
  802be6:	85 d2                	test   %edx,%edx
  802be8:	74 32                	je     802c1c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802bea:	83 ec 08             	sub    $0x8,%esp
  802bed:	ff 75 0c             	pushl  0xc(%ebp)
  802bf0:	50                   	push   %eax
  802bf1:	ff d2                	call   *%edx
  802bf3:	83 c4 10             	add    $0x10,%esp
}
  802bf6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802bf9:	c9                   	leave  
  802bfa:	c3                   	ret    
			thisenv->env_id, fdnum);
  802bfb:	a1 0c a0 80 00       	mov    0x80a00c,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  802c00:	8b 40 48             	mov    0x48(%eax),%eax
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	53                   	push   %ebx
  802c07:	50                   	push   %eax
  802c08:	68 7c 40 80 00       	push   $0x80407c
  802c0d:	e8 31 ed ff ff       	call   801943 <cprintf>
		return -E_INVAL;
  802c12:	83 c4 10             	add    $0x10,%esp
  802c15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802c1a:	eb da                	jmp    802bf6 <ftruncate+0x52>
		return -E_NOT_SUPP;
  802c1c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c21:	eb d3                	jmp    802bf6 <ftruncate+0x52>

00802c23 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  802c23:	55                   	push   %ebp
  802c24:	89 e5                	mov    %esp,%ebp
  802c26:	53                   	push   %ebx
  802c27:	83 ec 14             	sub    $0x14,%esp
  802c2a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  802c2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802c30:	50                   	push   %eax
  802c31:	ff 75 08             	pushl  0x8(%ebp)
  802c34:	e8 85 fb ff ff       	call   8027be <fd_lookup>
  802c39:	83 c4 08             	add    $0x8,%esp
  802c3c:	85 c0                	test   %eax,%eax
  802c3e:	78 4b                	js     802c8b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  802c40:	83 ec 08             	sub    $0x8,%esp
  802c43:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802c46:	50                   	push   %eax
  802c47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c4a:	ff 30                	pushl  (%eax)
  802c4c:	e8 c4 fb ff ff       	call   802815 <dev_lookup>
  802c51:	83 c4 10             	add    $0x10,%esp
  802c54:	85 c0                	test   %eax,%eax
  802c56:	78 33                	js     802c8b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  802c58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  802c5f:	74 2f                	je     802c90 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  802c61:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802c64:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802c6b:	00 00 00 
	stat->st_type = 0;
  802c6e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802c75:	00 00 00 
	stat->st_dev = dev;
  802c78:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  802c7e:	83 ec 08             	sub    $0x8,%esp
  802c81:	53                   	push   %ebx
  802c82:	ff 75 f0             	pushl  -0x10(%ebp)
  802c85:	ff 50 14             	call   *0x14(%eax)
  802c88:	83 c4 10             	add    $0x10,%esp
}
  802c8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c8e:	c9                   	leave  
  802c8f:	c3                   	ret    
		return -E_NOT_SUPP;
  802c90:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802c95:	eb f4                	jmp    802c8b <fstat+0x68>

00802c97 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
  802c9a:	56                   	push   %esi
  802c9b:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802c9c:	83 ec 08             	sub    $0x8,%esp
  802c9f:	6a 00                	push   $0x0
  802ca1:	ff 75 08             	pushl  0x8(%ebp)
  802ca4:	e8 34 02 00 00       	call   802edd <open>
  802ca9:	89 c3                	mov    %eax,%ebx
  802cab:	83 c4 10             	add    $0x10,%esp
  802cae:	85 c0                	test   %eax,%eax
  802cb0:	78 1b                	js     802ccd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  802cb2:	83 ec 08             	sub    $0x8,%esp
  802cb5:	ff 75 0c             	pushl  0xc(%ebp)
  802cb8:	50                   	push   %eax
  802cb9:	e8 65 ff ff ff       	call   802c23 <fstat>
  802cbe:	89 c6                	mov    %eax,%esi
	close(fd);
  802cc0:	89 1c 24             	mov    %ebx,(%esp)
  802cc3:	e8 29 fc ff ff       	call   8028f1 <close>
	return r;
  802cc8:	83 c4 10             	add    $0x10,%esp
  802ccb:	89 f3                	mov    %esi,%ebx
}
  802ccd:	89 d8                	mov    %ebx,%eax
  802ccf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802cd2:	5b                   	pop    %ebx
  802cd3:	5e                   	pop    %esi
  802cd4:	5d                   	pop    %ebp
  802cd5:	c3                   	ret    

00802cd6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802cd6:	55                   	push   %ebp
  802cd7:	89 e5                	mov    %esp,%ebp
  802cd9:	56                   	push   %esi
  802cda:	53                   	push   %ebx
  802cdb:	89 c6                	mov    %eax,%esi
  802cdd:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  802cdf:	83 3d 00 a0 80 00 00 	cmpl   $0x0,0x80a000
  802ce6:	74 27                	je     802d0f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802ce8:	6a 07                	push   $0x7
  802cea:	68 00 b0 80 00       	push   $0x80b000
  802cef:	56                   	push   %esi
  802cf0:	ff 35 00 a0 80 00    	pushl  0x80a000
  802cf6:	e8 af f9 ff ff       	call   8026aa <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802cfb:	83 c4 0c             	add    $0xc,%esp
  802cfe:	6a 00                	push   $0x0
  802d00:	53                   	push   %ebx
  802d01:	6a 00                	push   $0x0
  802d03:	e8 19 f9 ff ff       	call   802621 <ipc_recv>
}
  802d08:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802d0b:	5b                   	pop    %ebx
  802d0c:	5e                   	pop    %esi
  802d0d:	5d                   	pop    %ebp
  802d0e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  802d0f:	83 ec 0c             	sub    $0xc,%esp
  802d12:	6a 01                	push   $0x1
  802d14:	e8 ed f9 ff ff       	call   802706 <ipc_find_env>
  802d19:	a3 00 a0 80 00       	mov    %eax,0x80a000
  802d1e:	83 c4 10             	add    $0x10,%esp
  802d21:	eb c5                	jmp    802ce8 <fsipc+0x12>

00802d23 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  802d23:	55                   	push   %ebp
  802d24:	89 e5                	mov    %esp,%ebp
  802d26:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2f:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.set_size.req_size = newsize;
  802d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d37:	a3 04 b0 80 00       	mov    %eax,0x80b004
	return fsipc(FSREQ_SET_SIZE, NULL);
  802d3c:	ba 00 00 00 00       	mov    $0x0,%edx
  802d41:	b8 02 00 00 00       	mov    $0x2,%eax
  802d46:	e8 8b ff ff ff       	call   802cd6 <fsipc>
}
  802d4b:	c9                   	leave  
  802d4c:	c3                   	ret    

00802d4d <devfile_flush>:
{
  802d4d:	55                   	push   %ebp
  802d4e:	89 e5                	mov    %esp,%ebp
  802d50:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	a3 00 b0 80 00       	mov    %eax,0x80b000
	return fsipc(FSREQ_FLUSH, NULL);
  802d5e:	ba 00 00 00 00       	mov    $0x0,%edx
  802d63:	b8 06 00 00 00       	mov    $0x6,%eax
  802d68:	e8 69 ff ff ff       	call   802cd6 <fsipc>
}
  802d6d:	c9                   	leave  
  802d6e:	c3                   	ret    

00802d6f <devfile_stat>:
{
  802d6f:	55                   	push   %ebp
  802d70:	89 e5                	mov    %esp,%ebp
  802d72:	53                   	push   %ebx
  802d73:	83 ec 04             	sub    $0x4,%esp
  802d76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d7f:	a3 00 b0 80 00       	mov    %eax,0x80b000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802d84:	ba 00 00 00 00       	mov    $0x0,%edx
  802d89:	b8 05 00 00 00       	mov    $0x5,%eax
  802d8e:	e8 43 ff ff ff       	call   802cd6 <fsipc>
  802d93:	85 c0                	test   %eax,%eax
  802d95:	78 2c                	js     802dc3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802d97:	83 ec 08             	sub    $0x8,%esp
  802d9a:	68 00 b0 80 00       	push   $0x80b000
  802d9f:	53                   	push   %ebx
  802da0:	e8 a6 f1 ff ff       	call   801f4b <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802da5:	a1 80 b0 80 00       	mov    0x80b080,%eax
  802daa:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  802db0:	a1 84 b0 80 00       	mov    0x80b084,%eax
  802db5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802dbb:	83 c4 10             	add    $0x10,%esp
  802dbe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802dc3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802dc6:	c9                   	leave  
  802dc7:	c3                   	ret    

00802dc8 <devfile_write>:
{
  802dc8:	55                   	push   %ebp
  802dc9:	89 e5                	mov    %esp,%ebp
  802dcb:	53                   	push   %ebx
  802dcc:	83 ec 04             	sub    $0x4,%esp
  802dcf:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  802dd2:	89 d8                	mov    %ebx,%eax
  802dd4:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802dda:	76 05                	jbe    802de1 <devfile_write+0x19>
  802ddc:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  802de1:	8b 55 08             	mov    0x8(%ebp),%edx
  802de4:	8b 52 0c             	mov    0xc(%edx),%edx
  802de7:	89 15 00 b0 80 00    	mov    %edx,0x80b000
	fsipcbuf.write.req_n = size;
  802ded:	a3 04 b0 80 00       	mov    %eax,0x80b004
	memmove(fsipcbuf.write.req_buf, buf, size);
  802df2:	83 ec 04             	sub    $0x4,%esp
  802df5:	50                   	push   %eax
  802df6:	ff 75 0c             	pushl  0xc(%ebp)
  802df9:	68 08 b0 80 00       	push   $0x80b008
  802dfe:	e8 bb f2 ff ff       	call   8020be <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  802e03:	ba 00 00 00 00       	mov    $0x0,%edx
  802e08:	b8 04 00 00 00       	mov    $0x4,%eax
  802e0d:	e8 c4 fe ff ff       	call   802cd6 <fsipc>
  802e12:	83 c4 10             	add    $0x10,%esp
  802e15:	85 c0                	test   %eax,%eax
  802e17:	78 0b                	js     802e24 <devfile_write+0x5c>
	assert(r <= n);
  802e19:	39 c3                	cmp    %eax,%ebx
  802e1b:	72 0c                	jb     802e29 <devfile_write+0x61>
	assert(r <= PGSIZE);
  802e1d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802e22:	7f 1e                	jg     802e42 <devfile_write+0x7a>
}
  802e24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802e27:	c9                   	leave  
  802e28:	c3                   	ret    
	assert(r <= n);
  802e29:	68 ec 40 80 00       	push   $0x8040ec
  802e2e:	68 a0 38 80 00       	push   $0x8038a0
  802e33:	68 98 00 00 00       	push   $0x98
  802e38:	68 f3 40 80 00       	push   $0x8040f3
  802e3d:	e8 ee e9 ff ff       	call   801830 <_panic>
	assert(r <= PGSIZE);
  802e42:	68 fe 40 80 00       	push   $0x8040fe
  802e47:	68 a0 38 80 00       	push   $0x8038a0
  802e4c:	68 99 00 00 00       	push   $0x99
  802e51:	68 f3 40 80 00       	push   $0x8040f3
  802e56:	e8 d5 e9 ff ff       	call   801830 <_panic>

00802e5b <devfile_read>:
{
  802e5b:	55                   	push   %ebp
  802e5c:	89 e5                	mov    %esp,%ebp
  802e5e:	56                   	push   %esi
  802e5f:	53                   	push   %ebx
  802e60:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802e63:	8b 45 08             	mov    0x8(%ebp),%eax
  802e66:	8b 40 0c             	mov    0xc(%eax),%eax
  802e69:	a3 00 b0 80 00       	mov    %eax,0x80b000
	fsipcbuf.read.req_n = n;
  802e6e:	89 35 04 b0 80 00    	mov    %esi,0x80b004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802e74:	ba 00 00 00 00       	mov    $0x0,%edx
  802e79:	b8 03 00 00 00       	mov    $0x3,%eax
  802e7e:	e8 53 fe ff ff       	call   802cd6 <fsipc>
  802e83:	89 c3                	mov    %eax,%ebx
  802e85:	85 c0                	test   %eax,%eax
  802e87:	78 1f                	js     802ea8 <devfile_read+0x4d>
	assert(r <= n);
  802e89:	39 c6                	cmp    %eax,%esi
  802e8b:	72 24                	jb     802eb1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  802e8d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  802e92:	7f 33                	jg     802ec7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802e94:	83 ec 04             	sub    $0x4,%esp
  802e97:	50                   	push   %eax
  802e98:	68 00 b0 80 00       	push   $0x80b000
  802e9d:	ff 75 0c             	pushl  0xc(%ebp)
  802ea0:	e8 19 f2 ff ff       	call   8020be <memmove>
	return r;
  802ea5:	83 c4 10             	add    $0x10,%esp
}
  802ea8:	89 d8                	mov    %ebx,%eax
  802eaa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ead:	5b                   	pop    %ebx
  802eae:	5e                   	pop    %esi
  802eaf:	5d                   	pop    %ebp
  802eb0:	c3                   	ret    
	assert(r <= n);
  802eb1:	68 ec 40 80 00       	push   $0x8040ec
  802eb6:	68 a0 38 80 00       	push   $0x8038a0
  802ebb:	6a 7c                	push   $0x7c
  802ebd:	68 f3 40 80 00       	push   $0x8040f3
  802ec2:	e8 69 e9 ff ff       	call   801830 <_panic>
	assert(r <= PGSIZE);
  802ec7:	68 fe 40 80 00       	push   $0x8040fe
  802ecc:	68 a0 38 80 00       	push   $0x8038a0
  802ed1:	6a 7d                	push   $0x7d
  802ed3:	68 f3 40 80 00       	push   $0x8040f3
  802ed8:	e8 53 e9 ff ff       	call   801830 <_panic>

00802edd <open>:
{
  802edd:	55                   	push   %ebp
  802ede:	89 e5                	mov    %esp,%ebp
  802ee0:	56                   	push   %esi
  802ee1:	53                   	push   %ebx
  802ee2:	83 ec 1c             	sub    $0x1c,%esp
  802ee5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802ee8:	56                   	push   %esi
  802ee9:	e8 2a f0 ff ff       	call   801f18 <strlen>
  802eee:	83 c4 10             	add    $0x10,%esp
  802ef1:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802ef6:	7f 6c                	jg     802f64 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802ef8:	83 ec 0c             	sub    $0xc,%esp
  802efb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802efe:	50                   	push   %eax
  802eff:	e8 6b f8 ff ff       	call   80276f <fd_alloc>
  802f04:	89 c3                	mov    %eax,%ebx
  802f06:	83 c4 10             	add    $0x10,%esp
  802f09:	85 c0                	test   %eax,%eax
  802f0b:	78 3c                	js     802f49 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  802f0d:	83 ec 08             	sub    $0x8,%esp
  802f10:	56                   	push   %esi
  802f11:	68 00 b0 80 00       	push   $0x80b000
  802f16:	e8 30 f0 ff ff       	call   801f4b <strcpy>
	fsipcbuf.open.req_omode = mode;
  802f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  802f1e:	a3 00 b4 80 00       	mov    %eax,0x80b400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  802f23:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f26:	b8 01 00 00 00       	mov    $0x1,%eax
  802f2b:	e8 a6 fd ff ff       	call   802cd6 <fsipc>
  802f30:	89 c3                	mov    %eax,%ebx
  802f32:	83 c4 10             	add    $0x10,%esp
  802f35:	85 c0                	test   %eax,%eax
  802f37:	78 19                	js     802f52 <open+0x75>
	return fd2num(fd);
  802f39:	83 ec 0c             	sub    $0xc,%esp
  802f3c:	ff 75 f4             	pushl  -0xc(%ebp)
  802f3f:	e8 04 f8 ff ff       	call   802748 <fd2num>
  802f44:	89 c3                	mov    %eax,%ebx
  802f46:	83 c4 10             	add    $0x10,%esp
}
  802f49:	89 d8                	mov    %ebx,%eax
  802f4b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f4e:	5b                   	pop    %ebx
  802f4f:	5e                   	pop    %esi
  802f50:	5d                   	pop    %ebp
  802f51:	c3                   	ret    
		fd_close(fd, 0);
  802f52:	83 ec 08             	sub    $0x8,%esp
  802f55:	6a 00                	push   $0x0
  802f57:	ff 75 f4             	pushl  -0xc(%ebp)
  802f5a:	e8 0c f9 ff ff       	call   80286b <fd_close>
		return r;
  802f5f:	83 c4 10             	add    $0x10,%esp
  802f62:	eb e5                	jmp    802f49 <open+0x6c>
		return -E_BAD_PATH;
  802f64:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802f69:	eb de                	jmp    802f49 <open+0x6c>

00802f6b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802f6b:	55                   	push   %ebp
  802f6c:	89 e5                	mov    %esp,%ebp
  802f6e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  802f71:	ba 00 00 00 00       	mov    $0x0,%edx
  802f76:	b8 08 00 00 00       	mov    $0x8,%eax
  802f7b:	e8 56 fd ff ff       	call   802cd6 <fsipc>
}
  802f80:	c9                   	leave  
  802f81:	c3                   	ret    

00802f82 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802f82:	55                   	push   %ebp
  802f83:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802f85:	8b 45 08             	mov    0x8(%ebp),%eax
  802f88:	c1 e8 16             	shr    $0x16,%eax
  802f8b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802f92:	a8 01                	test   $0x1,%al
  802f94:	74 21                	je     802fb7 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	c1 e8 0c             	shr    $0xc,%eax
  802f9c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802fa3:	a8 01                	test   $0x1,%al
  802fa5:	74 17                	je     802fbe <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802fa7:	c1 e8 0c             	shr    $0xc,%eax
  802faa:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802fb1:	ef 
  802fb2:	0f b7 c0             	movzwl %ax,%eax
  802fb5:	eb 05                	jmp    802fbc <pageref+0x3a>
		return 0;
  802fb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fbc:	5d                   	pop    %ebp
  802fbd:	c3                   	ret    
		return 0;
  802fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  802fc3:	eb f7                	jmp    802fbc <pageref+0x3a>

00802fc5 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802fc5:	55                   	push   %ebp
  802fc6:	89 e5                	mov    %esp,%ebp
  802fc8:	56                   	push   %esi
  802fc9:	53                   	push   %ebx
  802fca:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802fcd:	83 ec 0c             	sub    $0xc,%esp
  802fd0:	ff 75 08             	pushl  0x8(%ebp)
  802fd3:	e8 80 f7 ff ff       	call   802758 <fd2data>
  802fd8:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802fda:	83 c4 08             	add    $0x8,%esp
  802fdd:	68 0a 41 80 00       	push   $0x80410a
  802fe2:	53                   	push   %ebx
  802fe3:	e8 63 ef ff ff       	call   801f4b <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802fe8:	8b 46 04             	mov    0x4(%esi),%eax
  802feb:	2b 06                	sub    (%esi),%eax
  802fed:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  802ff3:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  802ffa:	10 00 00 
	stat->st_dev = &devpipe;
  802ffd:	c7 83 88 00 00 00 60 	movl   $0x809060,0x88(%ebx)
  803004:	90 80 00 
	return 0;
}
  803007:	b8 00 00 00 00       	mov    $0x0,%eax
  80300c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80300f:	5b                   	pop    %ebx
  803010:	5e                   	pop    %esi
  803011:	5d                   	pop    %ebp
  803012:	c3                   	ret    

00803013 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  803013:	55                   	push   %ebp
  803014:	89 e5                	mov    %esp,%ebp
  803016:	53                   	push   %ebx
  803017:	83 ec 0c             	sub    $0xc,%esp
  80301a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80301d:	53                   	push   %ebx
  80301e:	6a 00                	push   $0x0
  803020:	e8 60 f3 ff ff       	call   802385 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  803025:	89 1c 24             	mov    %ebx,(%esp)
  803028:	e8 2b f7 ff ff       	call   802758 <fd2data>
  80302d:	83 c4 08             	add    $0x8,%esp
  803030:	50                   	push   %eax
  803031:	6a 00                	push   $0x0
  803033:	e8 4d f3 ff ff       	call   802385 <sys_page_unmap>
}
  803038:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80303b:	c9                   	leave  
  80303c:	c3                   	ret    

0080303d <_pipeisclosed>:
{
  80303d:	55                   	push   %ebp
  80303e:	89 e5                	mov    %esp,%ebp
  803040:	57                   	push   %edi
  803041:	56                   	push   %esi
  803042:	53                   	push   %ebx
  803043:	83 ec 1c             	sub    $0x1c,%esp
  803046:	89 c7                	mov    %eax,%edi
  803048:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80304a:	a1 0c a0 80 00       	mov    0x80a00c,%eax
  80304f:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  803052:	83 ec 0c             	sub    $0xc,%esp
  803055:	57                   	push   %edi
  803056:	e8 27 ff ff ff       	call   802f82 <pageref>
  80305b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80305e:	89 34 24             	mov    %esi,(%esp)
  803061:	e8 1c ff ff ff       	call   802f82 <pageref>
		nn = thisenv->env_runs;
  803066:	8b 15 0c a0 80 00    	mov    0x80a00c,%edx
  80306c:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80306f:	83 c4 10             	add    $0x10,%esp
  803072:	39 cb                	cmp    %ecx,%ebx
  803074:	74 1b                	je     803091 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  803076:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803079:	75 cf                	jne    80304a <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  80307b:	8b 42 58             	mov    0x58(%edx),%eax
  80307e:	6a 01                	push   $0x1
  803080:	50                   	push   %eax
  803081:	53                   	push   %ebx
  803082:	68 11 41 80 00       	push   $0x804111
  803087:	e8 b7 e8 ff ff       	call   801943 <cprintf>
  80308c:	83 c4 10             	add    $0x10,%esp
  80308f:	eb b9                	jmp    80304a <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  803091:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  803094:	0f 94 c0             	sete   %al
  803097:	0f b6 c0             	movzbl %al,%eax
}
  80309a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80309d:	5b                   	pop    %ebx
  80309e:	5e                   	pop    %esi
  80309f:	5f                   	pop    %edi
  8030a0:	5d                   	pop    %ebp
  8030a1:	c3                   	ret    

008030a2 <devpipe_write>:
{
  8030a2:	55                   	push   %ebp
  8030a3:	89 e5                	mov    %esp,%ebp
  8030a5:	57                   	push   %edi
  8030a6:	56                   	push   %esi
  8030a7:	53                   	push   %ebx
  8030a8:	83 ec 18             	sub    $0x18,%esp
  8030ab:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8030ae:	56                   	push   %esi
  8030af:	e8 a4 f6 ff ff       	call   802758 <fd2data>
  8030b4:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8030b6:	83 c4 10             	add    $0x10,%esp
  8030b9:	bf 00 00 00 00       	mov    $0x0,%edi
  8030be:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8030c1:	74 41                	je     803104 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8030c3:	8b 53 04             	mov    0x4(%ebx),%edx
  8030c6:	8b 03                	mov    (%ebx),%eax
  8030c8:	83 c0 20             	add    $0x20,%eax
  8030cb:	39 c2                	cmp    %eax,%edx
  8030cd:	72 14                	jb     8030e3 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8030cf:	89 da                	mov    %ebx,%edx
  8030d1:	89 f0                	mov    %esi,%eax
  8030d3:	e8 65 ff ff ff       	call   80303d <_pipeisclosed>
  8030d8:	85 c0                	test   %eax,%eax
  8030da:	75 2c                	jne    803108 <devpipe_write+0x66>
			sys_yield();
  8030dc:	e8 e6 f2 ff ff       	call   8023c7 <sys_yield>
  8030e1:	eb e0                	jmp    8030c3 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8030e6:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8030e9:	89 d0                	mov    %edx,%eax
  8030eb:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8030f0:	78 0b                	js     8030fd <devpipe_write+0x5b>
  8030f2:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8030f6:	42                   	inc    %edx
  8030f7:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8030fa:	47                   	inc    %edi
  8030fb:	eb c1                	jmp    8030be <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8030fd:	48                   	dec    %eax
  8030fe:	83 c8 e0             	or     $0xffffffe0,%eax
  803101:	40                   	inc    %eax
  803102:	eb ee                	jmp    8030f2 <devpipe_write+0x50>
	return i;
  803104:	89 f8                	mov    %edi,%eax
  803106:	eb 05                	jmp    80310d <devpipe_write+0x6b>
				return 0;
  803108:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80310d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803110:	5b                   	pop    %ebx
  803111:	5e                   	pop    %esi
  803112:	5f                   	pop    %edi
  803113:	5d                   	pop    %ebp
  803114:	c3                   	ret    

00803115 <devpipe_read>:
{
  803115:	55                   	push   %ebp
  803116:	89 e5                	mov    %esp,%ebp
  803118:	57                   	push   %edi
  803119:	56                   	push   %esi
  80311a:	53                   	push   %ebx
  80311b:	83 ec 18             	sub    $0x18,%esp
  80311e:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  803121:	57                   	push   %edi
  803122:	e8 31 f6 ff ff       	call   802758 <fd2data>
  803127:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  803129:	83 c4 10             	add    $0x10,%esp
  80312c:	bb 00 00 00 00       	mov    $0x0,%ebx
  803131:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  803134:	74 46                	je     80317c <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  803136:	8b 06                	mov    (%esi),%eax
  803138:	3b 46 04             	cmp    0x4(%esi),%eax
  80313b:	75 22                	jne    80315f <devpipe_read+0x4a>
			if (i > 0)
  80313d:	85 db                	test   %ebx,%ebx
  80313f:	74 0a                	je     80314b <devpipe_read+0x36>
				return i;
  803141:	89 d8                	mov    %ebx,%eax
}
  803143:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803146:	5b                   	pop    %ebx
  803147:	5e                   	pop    %esi
  803148:	5f                   	pop    %edi
  803149:	5d                   	pop    %ebp
  80314a:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  80314b:	89 f2                	mov    %esi,%edx
  80314d:	89 f8                	mov    %edi,%eax
  80314f:	e8 e9 fe ff ff       	call   80303d <_pipeisclosed>
  803154:	85 c0                	test   %eax,%eax
  803156:	75 28                	jne    803180 <devpipe_read+0x6b>
			sys_yield();
  803158:	e8 6a f2 ff ff       	call   8023c7 <sys_yield>
  80315d:	eb d7                	jmp    803136 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80315f:	25 1f 00 00 80       	and    $0x8000001f,%eax
  803164:	78 0f                	js     803175 <devpipe_read+0x60>
  803166:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  80316a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80316d:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  803170:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  803172:	43                   	inc    %ebx
  803173:	eb bc                	jmp    803131 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  803175:	48                   	dec    %eax
  803176:	83 c8 e0             	or     $0xffffffe0,%eax
  803179:	40                   	inc    %eax
  80317a:	eb ea                	jmp    803166 <devpipe_read+0x51>
	return i;
  80317c:	89 d8                	mov    %ebx,%eax
  80317e:	eb c3                	jmp    803143 <devpipe_read+0x2e>
				return 0;
  803180:	b8 00 00 00 00       	mov    $0x0,%eax
  803185:	eb bc                	jmp    803143 <devpipe_read+0x2e>

00803187 <pipe>:
{
  803187:	55                   	push   %ebp
  803188:	89 e5                	mov    %esp,%ebp
  80318a:	56                   	push   %esi
  80318b:	53                   	push   %ebx
  80318c:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80318f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803192:	50                   	push   %eax
  803193:	e8 d7 f5 ff ff       	call   80276f <fd_alloc>
  803198:	89 c3                	mov    %eax,%ebx
  80319a:	83 c4 10             	add    $0x10,%esp
  80319d:	85 c0                	test   %eax,%eax
  80319f:	0f 88 2a 01 00 00    	js     8032cf <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031a5:	83 ec 04             	sub    $0x4,%esp
  8031a8:	68 07 04 00 00       	push   $0x407
  8031ad:	ff 75 f4             	pushl  -0xc(%ebp)
  8031b0:	6a 00                	push   $0x0
  8031b2:	e8 49 f1 ff ff       	call   802300 <sys_page_alloc>
  8031b7:	89 c3                	mov    %eax,%ebx
  8031b9:	83 c4 10             	add    $0x10,%esp
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	0f 88 0b 01 00 00    	js     8032cf <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8031c4:	83 ec 0c             	sub    $0xc,%esp
  8031c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8031ca:	50                   	push   %eax
  8031cb:	e8 9f f5 ff ff       	call   80276f <fd_alloc>
  8031d0:	89 c3                	mov    %eax,%ebx
  8031d2:	83 c4 10             	add    $0x10,%esp
  8031d5:	85 c0                	test   %eax,%eax
  8031d7:	0f 88 e2 00 00 00    	js     8032bf <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8031dd:	83 ec 04             	sub    $0x4,%esp
  8031e0:	68 07 04 00 00       	push   $0x407
  8031e5:	ff 75 f0             	pushl  -0x10(%ebp)
  8031e8:	6a 00                	push   $0x0
  8031ea:	e8 11 f1 ff ff       	call   802300 <sys_page_alloc>
  8031ef:	89 c3                	mov    %eax,%ebx
  8031f1:	83 c4 10             	add    $0x10,%esp
  8031f4:	85 c0                	test   %eax,%eax
  8031f6:	0f 88 c3 00 00 00    	js     8032bf <pipe+0x138>
	va = fd2data(fd0);
  8031fc:	83 ec 0c             	sub    $0xc,%esp
  8031ff:	ff 75 f4             	pushl  -0xc(%ebp)
  803202:	e8 51 f5 ff ff       	call   802758 <fd2data>
  803207:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803209:	83 c4 0c             	add    $0xc,%esp
  80320c:	68 07 04 00 00       	push   $0x407
  803211:	50                   	push   %eax
  803212:	6a 00                	push   $0x0
  803214:	e8 e7 f0 ff ff       	call   802300 <sys_page_alloc>
  803219:	89 c3                	mov    %eax,%ebx
  80321b:	83 c4 10             	add    $0x10,%esp
  80321e:	85 c0                	test   %eax,%eax
  803220:	0f 88 89 00 00 00    	js     8032af <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  803226:	83 ec 0c             	sub    $0xc,%esp
  803229:	ff 75 f0             	pushl  -0x10(%ebp)
  80322c:	e8 27 f5 ff ff       	call   802758 <fd2data>
  803231:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  803238:	50                   	push   %eax
  803239:	6a 00                	push   $0x0
  80323b:	56                   	push   %esi
  80323c:	6a 00                	push   $0x0
  80323e:	e8 00 f1 ff ff       	call   802343 <sys_page_map>
  803243:	89 c3                	mov    %eax,%ebx
  803245:	83 c4 20             	add    $0x20,%esp
  803248:	85 c0                	test   %eax,%eax
  80324a:	78 55                	js     8032a1 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80324c:	8b 15 60 90 80 00    	mov    0x809060,%edx
  803252:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803255:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  803257:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80325a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  803261:	8b 15 60 90 80 00    	mov    0x809060,%edx
  803267:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326a:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80326c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80326f:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  803276:	83 ec 0c             	sub    $0xc,%esp
  803279:	ff 75 f4             	pushl  -0xc(%ebp)
  80327c:	e8 c7 f4 ff ff       	call   802748 <fd2num>
  803281:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803284:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  803286:	83 c4 04             	add    $0x4,%esp
  803289:	ff 75 f0             	pushl  -0x10(%ebp)
  80328c:	e8 b7 f4 ff ff       	call   802748 <fd2num>
  803291:	8b 4d 08             	mov    0x8(%ebp),%ecx
  803294:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  803297:	83 c4 10             	add    $0x10,%esp
  80329a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80329f:	eb 2e                	jmp    8032cf <pipe+0x148>
	sys_page_unmap(0, va);
  8032a1:	83 ec 08             	sub    $0x8,%esp
  8032a4:	56                   	push   %esi
  8032a5:	6a 00                	push   $0x0
  8032a7:	e8 d9 f0 ff ff       	call   802385 <sys_page_unmap>
  8032ac:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8032af:	83 ec 08             	sub    $0x8,%esp
  8032b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8032b5:	6a 00                	push   $0x0
  8032b7:	e8 c9 f0 ff ff       	call   802385 <sys_page_unmap>
  8032bc:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8032bf:	83 ec 08             	sub    $0x8,%esp
  8032c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8032c5:	6a 00                	push   $0x0
  8032c7:	e8 b9 f0 ff ff       	call   802385 <sys_page_unmap>
  8032cc:	83 c4 10             	add    $0x10,%esp
}
  8032cf:	89 d8                	mov    %ebx,%eax
  8032d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8032d4:	5b                   	pop    %ebx
  8032d5:	5e                   	pop    %esi
  8032d6:	5d                   	pop    %ebp
  8032d7:	c3                   	ret    

008032d8 <pipeisclosed>:
{
  8032d8:	55                   	push   %ebp
  8032d9:	89 e5                	mov    %esp,%ebp
  8032db:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8032de:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8032e1:	50                   	push   %eax
  8032e2:	ff 75 08             	pushl  0x8(%ebp)
  8032e5:	e8 d4 f4 ff ff       	call   8027be <fd_lookup>
  8032ea:	83 c4 10             	add    $0x10,%esp
  8032ed:	85 c0                	test   %eax,%eax
  8032ef:	78 18                	js     803309 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8032f1:	83 ec 0c             	sub    $0xc,%esp
  8032f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8032f7:	e8 5c f4 ff ff       	call   802758 <fd2data>
	return _pipeisclosed(fd, p);
  8032fc:	89 c2                	mov    %eax,%edx
  8032fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803301:	e8 37 fd ff ff       	call   80303d <_pipeisclosed>
  803306:	83 c4 10             	add    $0x10,%esp
}
  803309:	c9                   	leave  
  80330a:	c3                   	ret    

0080330b <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80330b:	55                   	push   %ebp
  80330c:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80330e:	b8 00 00 00 00       	mov    $0x0,%eax
  803313:	5d                   	pop    %ebp
  803314:	c3                   	ret    

00803315 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  803315:	55                   	push   %ebp
  803316:	89 e5                	mov    %esp,%ebp
  803318:	53                   	push   %ebx
  803319:	83 ec 0c             	sub    $0xc,%esp
  80331c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80331f:	68 29 41 80 00       	push   $0x804129
  803324:	53                   	push   %ebx
  803325:	e8 21 ec ff ff       	call   801f4b <strcpy>
	stat->st_type = FTYPE_IFCHR;
  80332a:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  803331:	20 00 00 
	return 0;
}
  803334:	b8 00 00 00 00       	mov    $0x0,%eax
  803339:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80333c:	c9                   	leave  
  80333d:	c3                   	ret    

0080333e <devcons_write>:
{
  80333e:	55                   	push   %ebp
  80333f:	89 e5                	mov    %esp,%ebp
  803341:	57                   	push   %edi
  803342:	56                   	push   %esi
  803343:	53                   	push   %ebx
  803344:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80334a:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80334f:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  803355:	eb 1d                	jmp    803374 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  803357:	83 ec 04             	sub    $0x4,%esp
  80335a:	53                   	push   %ebx
  80335b:	03 45 0c             	add    0xc(%ebp),%eax
  80335e:	50                   	push   %eax
  80335f:	57                   	push   %edi
  803360:	e8 59 ed ff ff       	call   8020be <memmove>
		sys_cputs(buf, m);
  803365:	83 c4 08             	add    $0x8,%esp
  803368:	53                   	push   %ebx
  803369:	57                   	push   %edi
  80336a:	e8 f4 ee ff ff       	call   802263 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80336f:	01 de                	add    %ebx,%esi
  803371:	83 c4 10             	add    $0x10,%esp
  803374:	89 f0                	mov    %esi,%eax
  803376:	3b 75 10             	cmp    0x10(%ebp),%esi
  803379:	73 11                	jae    80338c <devcons_write+0x4e>
		m = n - tot;
  80337b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80337e:	29 f3                	sub    %esi,%ebx
  803380:	83 fb 7f             	cmp    $0x7f,%ebx
  803383:	76 d2                	jbe    803357 <devcons_write+0x19>
  803385:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  80338a:	eb cb                	jmp    803357 <devcons_write+0x19>
}
  80338c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80338f:	5b                   	pop    %ebx
  803390:	5e                   	pop    %esi
  803391:	5f                   	pop    %edi
  803392:	5d                   	pop    %ebp
  803393:	c3                   	ret    

00803394 <devcons_read>:
{
  803394:	55                   	push   %ebp
  803395:	89 e5                	mov    %esp,%ebp
  803397:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  80339a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80339e:	75 0c                	jne    8033ac <devcons_read+0x18>
		return 0;
  8033a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8033a5:	eb 21                	jmp    8033c8 <devcons_read+0x34>
		sys_yield();
  8033a7:	e8 1b f0 ff ff       	call   8023c7 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8033ac:	e8 d0 ee ff ff       	call   802281 <sys_cgetc>
  8033b1:	85 c0                	test   %eax,%eax
  8033b3:	74 f2                	je     8033a7 <devcons_read+0x13>
	if (c < 0)
  8033b5:	85 c0                	test   %eax,%eax
  8033b7:	78 0f                	js     8033c8 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8033b9:	83 f8 04             	cmp    $0x4,%eax
  8033bc:	74 0c                	je     8033ca <devcons_read+0x36>
	*(char*)vbuf = c;
  8033be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8033c1:	88 02                	mov    %al,(%edx)
	return 1;
  8033c3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8033c8:	c9                   	leave  
  8033c9:	c3                   	ret    
		return 0;
  8033ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8033cf:	eb f7                	jmp    8033c8 <devcons_read+0x34>

008033d1 <cputchar>:
{
  8033d1:	55                   	push   %ebp
  8033d2:	89 e5                	mov    %esp,%ebp
  8033d4:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8033d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033da:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8033dd:	6a 01                	push   $0x1
  8033df:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8033e2:	50                   	push   %eax
  8033e3:	e8 7b ee ff ff       	call   802263 <sys_cputs>
}
  8033e8:	83 c4 10             	add    $0x10,%esp
  8033eb:	c9                   	leave  
  8033ec:	c3                   	ret    

008033ed <getchar>:
{
  8033ed:	55                   	push   %ebp
  8033ee:	89 e5                	mov    %esp,%ebp
  8033f0:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8033f3:	6a 01                	push   $0x1
  8033f5:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8033f8:	50                   	push   %eax
  8033f9:	6a 00                	push   $0x0
  8033fb:	e8 2b f6 ff ff       	call   802a2b <read>
	if (r < 0)
  803400:	83 c4 10             	add    $0x10,%esp
  803403:	85 c0                	test   %eax,%eax
  803405:	78 08                	js     80340f <getchar+0x22>
	if (r < 1)
  803407:	85 c0                	test   %eax,%eax
  803409:	7e 06                	jle    803411 <getchar+0x24>
	return c;
  80340b:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80340f:	c9                   	leave  
  803410:	c3                   	ret    
		return -E_EOF;
  803411:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  803416:	eb f7                	jmp    80340f <getchar+0x22>

00803418 <iscons>:
{
  803418:	55                   	push   %ebp
  803419:	89 e5                	mov    %esp,%ebp
  80341b:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80341e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  803421:	50                   	push   %eax
  803422:	ff 75 08             	pushl  0x8(%ebp)
  803425:	e8 94 f3 ff ff       	call   8027be <fd_lookup>
  80342a:	83 c4 10             	add    $0x10,%esp
  80342d:	85 c0                	test   %eax,%eax
  80342f:	78 11                	js     803442 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  803431:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803434:	8b 15 7c 90 80 00    	mov    0x80907c,%edx
  80343a:	39 10                	cmp    %edx,(%eax)
  80343c:	0f 94 c0             	sete   %al
  80343f:	0f b6 c0             	movzbl %al,%eax
}
  803442:	c9                   	leave  
  803443:	c3                   	ret    

00803444 <opencons>:
{
  803444:	55                   	push   %ebp
  803445:	89 e5                	mov    %esp,%ebp
  803447:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  80344a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80344d:	50                   	push   %eax
  80344e:	e8 1c f3 ff ff       	call   80276f <fd_alloc>
  803453:	83 c4 10             	add    $0x10,%esp
  803456:	85 c0                	test   %eax,%eax
  803458:	78 3a                	js     803494 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  80345a:	83 ec 04             	sub    $0x4,%esp
  80345d:	68 07 04 00 00       	push   $0x407
  803462:	ff 75 f4             	pushl  -0xc(%ebp)
  803465:	6a 00                	push   $0x0
  803467:	e8 94 ee ff ff       	call   802300 <sys_page_alloc>
  80346c:	83 c4 10             	add    $0x10,%esp
  80346f:	85 c0                	test   %eax,%eax
  803471:	78 21                	js     803494 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  803473:	8b 15 7c 90 80 00    	mov    0x80907c,%edx
  803479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347c:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80347e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803481:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  803488:	83 ec 0c             	sub    $0xc,%esp
  80348b:	50                   	push   %eax
  80348c:	e8 b7 f2 ff ff       	call   802748 <fd2num>
  803491:	83 c4 10             	add    $0x10,%esp
}
  803494:	c9                   	leave  
  803495:	c3                   	ret    
  803496:	66 90                	xchg   %ax,%ax

00803498 <__udivdi3>:
  803498:	55                   	push   %ebp
  803499:	57                   	push   %edi
  80349a:	56                   	push   %esi
  80349b:	53                   	push   %ebx
  80349c:	83 ec 1c             	sub    $0x1c,%esp
  80349f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034a3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034a7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034ab:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8034af:	89 ca                	mov    %ecx,%edx
  8034b1:	89 f8                	mov    %edi,%eax
  8034b3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034b7:	85 f6                	test   %esi,%esi
  8034b9:	75 2d                	jne    8034e8 <__udivdi3+0x50>
  8034bb:	39 cf                	cmp    %ecx,%edi
  8034bd:	77 65                	ja     803524 <__udivdi3+0x8c>
  8034bf:	89 fd                	mov    %edi,%ebp
  8034c1:	85 ff                	test   %edi,%edi
  8034c3:	75 0b                	jne    8034d0 <__udivdi3+0x38>
  8034c5:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ca:	31 d2                	xor    %edx,%edx
  8034cc:	f7 f7                	div    %edi
  8034ce:	89 c5                	mov    %eax,%ebp
  8034d0:	31 d2                	xor    %edx,%edx
  8034d2:	89 c8                	mov    %ecx,%eax
  8034d4:	f7 f5                	div    %ebp
  8034d6:	89 c1                	mov    %eax,%ecx
  8034d8:	89 d8                	mov    %ebx,%eax
  8034da:	f7 f5                	div    %ebp
  8034dc:	89 cf                	mov    %ecx,%edi
  8034de:	89 fa                	mov    %edi,%edx
  8034e0:	83 c4 1c             	add    $0x1c,%esp
  8034e3:	5b                   	pop    %ebx
  8034e4:	5e                   	pop    %esi
  8034e5:	5f                   	pop    %edi
  8034e6:	5d                   	pop    %ebp
  8034e7:	c3                   	ret    
  8034e8:	39 ce                	cmp    %ecx,%esi
  8034ea:	77 28                	ja     803514 <__udivdi3+0x7c>
  8034ec:	0f bd fe             	bsr    %esi,%edi
  8034ef:	83 f7 1f             	xor    $0x1f,%edi
  8034f2:	75 40                	jne    803534 <__udivdi3+0x9c>
  8034f4:	39 ce                	cmp    %ecx,%esi
  8034f6:	72 0a                	jb     803502 <__udivdi3+0x6a>
  8034f8:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8034fc:	0f 87 9e 00 00 00    	ja     8035a0 <__udivdi3+0x108>
  803502:	b8 01 00 00 00       	mov    $0x1,%eax
  803507:	89 fa                	mov    %edi,%edx
  803509:	83 c4 1c             	add    $0x1c,%esp
  80350c:	5b                   	pop    %ebx
  80350d:	5e                   	pop    %esi
  80350e:	5f                   	pop    %edi
  80350f:	5d                   	pop    %ebp
  803510:	c3                   	ret    
  803511:	8d 76 00             	lea    0x0(%esi),%esi
  803514:	31 ff                	xor    %edi,%edi
  803516:	31 c0                	xor    %eax,%eax
  803518:	89 fa                	mov    %edi,%edx
  80351a:	83 c4 1c             	add    $0x1c,%esp
  80351d:	5b                   	pop    %ebx
  80351e:	5e                   	pop    %esi
  80351f:	5f                   	pop    %edi
  803520:	5d                   	pop    %ebp
  803521:	c3                   	ret    
  803522:	66 90                	xchg   %ax,%ax
  803524:	89 d8                	mov    %ebx,%eax
  803526:	f7 f7                	div    %edi
  803528:	31 ff                	xor    %edi,%edi
  80352a:	89 fa                	mov    %edi,%edx
  80352c:	83 c4 1c             	add    $0x1c,%esp
  80352f:	5b                   	pop    %ebx
  803530:	5e                   	pop    %esi
  803531:	5f                   	pop    %edi
  803532:	5d                   	pop    %ebp
  803533:	c3                   	ret    
  803534:	bd 20 00 00 00       	mov    $0x20,%ebp
  803539:	29 fd                	sub    %edi,%ebp
  80353b:	89 f9                	mov    %edi,%ecx
  80353d:	d3 e6                	shl    %cl,%esi
  80353f:	89 c3                	mov    %eax,%ebx
  803541:	89 e9                	mov    %ebp,%ecx
  803543:	d3 eb                	shr    %cl,%ebx
  803545:	89 d9                	mov    %ebx,%ecx
  803547:	09 f1                	or     %esi,%ecx
  803549:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80354d:	89 f9                	mov    %edi,%ecx
  80354f:	d3 e0                	shl    %cl,%eax
  803551:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803555:	89 d6                	mov    %edx,%esi
  803557:	89 e9                	mov    %ebp,%ecx
  803559:	d3 ee                	shr    %cl,%esi
  80355b:	89 f9                	mov    %edi,%ecx
  80355d:	d3 e2                	shl    %cl,%edx
  80355f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  803563:	89 e9                	mov    %ebp,%ecx
  803565:	d3 eb                	shr    %cl,%ebx
  803567:	09 da                	or     %ebx,%edx
  803569:	89 d0                	mov    %edx,%eax
  80356b:	89 f2                	mov    %esi,%edx
  80356d:	f7 74 24 08          	divl   0x8(%esp)
  803571:	89 d6                	mov    %edx,%esi
  803573:	89 c3                	mov    %eax,%ebx
  803575:	f7 64 24 0c          	mull   0xc(%esp)
  803579:	39 d6                	cmp    %edx,%esi
  80357b:	72 17                	jb     803594 <__udivdi3+0xfc>
  80357d:	74 09                	je     803588 <__udivdi3+0xf0>
  80357f:	89 d8                	mov    %ebx,%eax
  803581:	31 ff                	xor    %edi,%edi
  803583:	e9 56 ff ff ff       	jmp    8034de <__udivdi3+0x46>
  803588:	8b 54 24 04          	mov    0x4(%esp),%edx
  80358c:	89 f9                	mov    %edi,%ecx
  80358e:	d3 e2                	shl    %cl,%edx
  803590:	39 c2                	cmp    %eax,%edx
  803592:	73 eb                	jae    80357f <__udivdi3+0xe7>
  803594:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803597:	31 ff                	xor    %edi,%edi
  803599:	e9 40 ff ff ff       	jmp    8034de <__udivdi3+0x46>
  80359e:	66 90                	xchg   %ax,%ax
  8035a0:	31 c0                	xor    %eax,%eax
  8035a2:	e9 37 ff ff ff       	jmp    8034de <__udivdi3+0x46>
  8035a7:	90                   	nop

008035a8 <__umoddi3>:
  8035a8:	55                   	push   %ebp
  8035a9:	57                   	push   %edi
  8035aa:	56                   	push   %esi
  8035ab:	53                   	push   %ebx
  8035ac:	83 ec 1c             	sub    $0x1c,%esp
  8035af:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035b3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035b7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035c3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035c7:	89 3c 24             	mov    %edi,(%esp)
  8035ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035ce:	89 f2                	mov    %esi,%edx
  8035d0:	85 c0                	test   %eax,%eax
  8035d2:	75 18                	jne    8035ec <__umoddi3+0x44>
  8035d4:	39 f7                	cmp    %esi,%edi
  8035d6:	0f 86 a0 00 00 00    	jbe    80367c <__umoddi3+0xd4>
  8035dc:	89 c8                	mov    %ecx,%eax
  8035de:	f7 f7                	div    %edi
  8035e0:	89 d0                	mov    %edx,%eax
  8035e2:	31 d2                	xor    %edx,%edx
  8035e4:	83 c4 1c             	add    $0x1c,%esp
  8035e7:	5b                   	pop    %ebx
  8035e8:	5e                   	pop    %esi
  8035e9:	5f                   	pop    %edi
  8035ea:	5d                   	pop    %ebp
  8035eb:	c3                   	ret    
  8035ec:	89 f3                	mov    %esi,%ebx
  8035ee:	39 f0                	cmp    %esi,%eax
  8035f0:	0f 87 a6 00 00 00    	ja     80369c <__umoddi3+0xf4>
  8035f6:	0f bd e8             	bsr    %eax,%ebp
  8035f9:	83 f5 1f             	xor    $0x1f,%ebp
  8035fc:	0f 84 a6 00 00 00    	je     8036a8 <__umoddi3+0x100>
  803602:	bf 20 00 00 00       	mov    $0x20,%edi
  803607:	29 ef                	sub    %ebp,%edi
  803609:	89 e9                	mov    %ebp,%ecx
  80360b:	d3 e0                	shl    %cl,%eax
  80360d:	8b 34 24             	mov    (%esp),%esi
  803610:	89 f2                	mov    %esi,%edx
  803612:	89 f9                	mov    %edi,%ecx
  803614:	d3 ea                	shr    %cl,%edx
  803616:	09 c2                	or     %eax,%edx
  803618:	89 14 24             	mov    %edx,(%esp)
  80361b:	89 f2                	mov    %esi,%edx
  80361d:	89 e9                	mov    %ebp,%ecx
  80361f:	d3 e2                	shl    %cl,%edx
  803621:	89 54 24 04          	mov    %edx,0x4(%esp)
  803625:	89 de                	mov    %ebx,%esi
  803627:	89 f9                	mov    %edi,%ecx
  803629:	d3 ee                	shr    %cl,%esi
  80362b:	89 e9                	mov    %ebp,%ecx
  80362d:	d3 e3                	shl    %cl,%ebx
  80362f:	8b 54 24 08          	mov    0x8(%esp),%edx
  803633:	89 d0                	mov    %edx,%eax
  803635:	89 f9                	mov    %edi,%ecx
  803637:	d3 e8                	shr    %cl,%eax
  803639:	09 d8                	or     %ebx,%eax
  80363b:	89 d3                	mov    %edx,%ebx
  80363d:	89 e9                	mov    %ebp,%ecx
  80363f:	d3 e3                	shl    %cl,%ebx
  803641:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803645:	89 f2                	mov    %esi,%edx
  803647:	f7 34 24             	divl   (%esp)
  80364a:	89 d6                	mov    %edx,%esi
  80364c:	f7 64 24 04          	mull   0x4(%esp)
  803650:	89 c3                	mov    %eax,%ebx
  803652:	89 d1                	mov    %edx,%ecx
  803654:	39 d6                	cmp    %edx,%esi
  803656:	72 7c                	jb     8036d4 <__umoddi3+0x12c>
  803658:	74 72                	je     8036cc <__umoddi3+0x124>
  80365a:	8b 54 24 08          	mov    0x8(%esp),%edx
  80365e:	29 da                	sub    %ebx,%edx
  803660:	19 ce                	sbb    %ecx,%esi
  803662:	89 f0                	mov    %esi,%eax
  803664:	89 f9                	mov    %edi,%ecx
  803666:	d3 e0                	shl    %cl,%eax
  803668:	89 e9                	mov    %ebp,%ecx
  80366a:	d3 ea                	shr    %cl,%edx
  80366c:	09 d0                	or     %edx,%eax
  80366e:	89 e9                	mov    %ebp,%ecx
  803670:	d3 ee                	shr    %cl,%esi
  803672:	89 f2                	mov    %esi,%edx
  803674:	83 c4 1c             	add    $0x1c,%esp
  803677:	5b                   	pop    %ebx
  803678:	5e                   	pop    %esi
  803679:	5f                   	pop    %edi
  80367a:	5d                   	pop    %ebp
  80367b:	c3                   	ret    
  80367c:	89 fd                	mov    %edi,%ebp
  80367e:	85 ff                	test   %edi,%edi
  803680:	75 0b                	jne    80368d <__umoddi3+0xe5>
  803682:	b8 01 00 00 00       	mov    $0x1,%eax
  803687:	31 d2                	xor    %edx,%edx
  803689:	f7 f7                	div    %edi
  80368b:	89 c5                	mov    %eax,%ebp
  80368d:	89 f0                	mov    %esi,%eax
  80368f:	31 d2                	xor    %edx,%edx
  803691:	f7 f5                	div    %ebp
  803693:	89 c8                	mov    %ecx,%eax
  803695:	f7 f5                	div    %ebp
  803697:	e9 44 ff ff ff       	jmp    8035e0 <__umoddi3+0x38>
  80369c:	89 c8                	mov    %ecx,%eax
  80369e:	89 f2                	mov    %esi,%edx
  8036a0:	83 c4 1c             	add    $0x1c,%esp
  8036a3:	5b                   	pop    %ebx
  8036a4:	5e                   	pop    %esi
  8036a5:	5f                   	pop    %edi
  8036a6:	5d                   	pop    %ebp
  8036a7:	c3                   	ret    
  8036a8:	39 f0                	cmp    %esi,%eax
  8036aa:	72 05                	jb     8036b1 <__umoddi3+0x109>
  8036ac:	39 0c 24             	cmp    %ecx,(%esp)
  8036af:	77 0c                	ja     8036bd <__umoddi3+0x115>
  8036b1:	89 f2                	mov    %esi,%edx
  8036b3:	29 f9                	sub    %edi,%ecx
  8036b5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036b9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036bd:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036c1:	83 c4 1c             	add    $0x1c,%esp
  8036c4:	5b                   	pop    %ebx
  8036c5:	5e                   	pop    %esi
  8036c6:	5f                   	pop    %edi
  8036c7:	5d                   	pop    %ebp
  8036c8:	c3                   	ret    
  8036c9:	8d 76 00             	lea    0x0(%esi),%esi
  8036cc:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8036d0:	73 88                	jae    80365a <__umoddi3+0xb2>
  8036d2:	66 90                	xchg   %ax,%ax
  8036d4:	2b 44 24 04          	sub    0x4(%esp),%eax
  8036d8:	1b 14 24             	sbb    (%esp),%edx
  8036db:	89 d1                	mov    %edx,%ecx
  8036dd:	89 c3                	mov    %eax,%ebx
  8036df:	e9 76 ff ff ff       	jmp    80365a <__umoddi3+0xb2>
