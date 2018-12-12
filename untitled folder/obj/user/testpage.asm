
obj/user/testpage.debug:     file format elf32-i386


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
  80002c:	e8 de 06 00 00       	call   80070f <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

static char buf[PGSIZE] __attribute__((aligned(PGSIZE)));

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	binaryname = "testpage";
  800039:	c7 05 00 40 80 00 c0 	movl   $0x8025c0,0x804000
  800040:	25 80 00 

	// sys_page_alloc error cases
	assert(sys_page_alloc(-1, VA, PTE_U|PTE_P) == -E_BAD_ENV);
  800043:	6a 05                	push   $0x5
  800045:	68 00 00 00 a0       	push   $0xa0000000
  80004a:	6a ff                	push   $0xffffffff
  80004c:	e8 f4 11 00 00       	call   801245 <sys_page_alloc>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800057:	0f 85 f2 03 00 00    	jne    80044f <umain+0x41c>
	assert(sys_page_alloc(0, (void *)UTOP + PGSIZE, PTE_U|PTE_P) == -E_INVAL);
  80005d:	83 ec 04             	sub    $0x4,%esp
  800060:	6a 05                	push   $0x5
  800062:	68 00 10 c0 ee       	push   $0xeec01000
  800067:	6a 00                	push   $0x0
  800069:	e8 d7 11 00 00       	call   801245 <sys_page_alloc>
  80006e:	83 c4 10             	add    $0x10,%esp
  800071:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800074:	0f 85 eb 03 00 00    	jne    800465 <umain+0x432>
	assert(sys_page_alloc(0, VA + 1, PTE_U|PTE_P) == -E_INVAL);
  80007a:	83 ec 04             	sub    $0x4,%esp
  80007d:	6a 05                	push   $0x5
  80007f:	68 01 00 00 a0       	push   $0xa0000001
  800084:	6a 00                	push   $0x0
  800086:	e8 ba 11 00 00       	call   801245 <sys_page_alloc>
  80008b:	83 c4 10             	add    $0x10,%esp
  80008e:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800091:	0f 85 e4 03 00 00    	jne    80047b <umain+0x448>
	assert(sys_page_alloc(0, VA, PTE_U|PTE_P|PTE_G) == -E_INVAL);
  800097:	83 ec 04             	sub    $0x4,%esp
  80009a:	68 05 01 00 00       	push   $0x105
  80009f:	68 00 00 00 a0       	push   $0xa0000000
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 9a 11 00 00       	call   801245 <sys_page_alloc>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8000b1:	0f 85 da 03 00 00    	jne    800491 <umain+0x45e>
	assert(sys_page_alloc(0, VA, 0) == -E_INVAL);
  8000b7:	83 ec 04             	sub    $0x4,%esp
  8000ba:	6a 00                	push   $0x0
  8000bc:	68 00 00 00 a0       	push   $0xa0000000
  8000c1:	6a 00                	push   $0x0
  8000c3:	e8 7d 11 00 00       	call   801245 <sys_page_alloc>
  8000c8:	83 c4 10             	add    $0x10,%esp
  8000cb:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8000ce:	0f 85 d3 03 00 00    	jne    8004a7 <umain+0x474>

	// sys_page_map error cases
	assert(sys_page_map(-1, buf, 0, buf, PTE_U|PTE_P) == -E_BAD_ENV);
  8000d4:	83 ec 0c             	sub    $0xc,%esp
  8000d7:	6a 05                	push   $0x5
  8000d9:	68 00 50 80 00       	push   $0x805000
  8000de:	6a 00                	push   $0x0
  8000e0:	68 00 50 80 00       	push   $0x805000
  8000e5:	6a ff                	push   $0xffffffff
  8000e7:	e8 9c 11 00 00       	call   801288 <sys_page_map>
  8000ec:	83 c4 20             	add    $0x20,%esp
  8000ef:	83 f8 fe             	cmp    $0xfffffffe,%eax
  8000f2:	0f 85 c5 03 00 00    	jne    8004bd <umain+0x48a>
	assert(sys_page_map(0, buf, -1, buf, PTE_U|PTE_P) == -E_BAD_ENV);
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	6a 05                	push   $0x5
  8000fd:	68 00 50 80 00       	push   $0x805000
  800102:	6a ff                	push   $0xffffffff
  800104:	68 00 50 80 00       	push   $0x805000
  800109:	6a 00                	push   $0x0
  80010b:	e8 78 11 00 00       	call   801288 <sys_page_map>
  800110:	83 c4 20             	add    $0x20,%esp
  800113:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800116:	0f 85 b7 03 00 00    	jne    8004d3 <umain+0x4a0>
	assert(sys_page_map(0, buf + 1, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  80011c:	83 ec 0c             	sub    $0xc,%esp
  80011f:	6a 05                	push   $0x5
  800121:	68 00 00 00 a0       	push   $0xa0000000
  800126:	6a 00                	push   $0x0
  800128:	68 01 50 80 00       	push   $0x805001
  80012d:	6a 00                	push   $0x0
  80012f:	e8 54 11 00 00       	call   801288 <sys_page_map>
  800134:	83 c4 20             	add    $0x20,%esp
  800137:	83 f8 fd             	cmp    $0xfffffffd,%eax
  80013a:	0f 85 a9 03 00 00    	jne    8004e9 <umain+0x4b6>
	assert(sys_page_map(0, (void *)UTOP + PGSIZE, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  800140:	83 ec 0c             	sub    $0xc,%esp
  800143:	6a 05                	push   $0x5
  800145:	68 00 00 00 a0       	push   $0xa0000000
  80014a:	6a 00                	push   $0x0
  80014c:	68 00 10 c0 ee       	push   $0xeec01000
  800151:	6a 00                	push   $0x0
  800153:	e8 30 11 00 00       	call   801288 <sys_page_map>
  800158:	83 c4 20             	add    $0x20,%esp
  80015b:	83 f8 fd             	cmp    $0xfffffffd,%eax
  80015e:	0f 85 9b 03 00 00    	jne    8004ff <umain+0x4cc>
	assert(sys_page_map(0, buf, 0, (void *)UTOP + PGSIZE, PTE_U|PTE_P) == -E_INVAL);
  800164:	83 ec 0c             	sub    $0xc,%esp
  800167:	6a 05                	push   $0x5
  800169:	68 00 10 c0 ee       	push   $0xeec01000
  80016e:	6a 00                	push   $0x0
  800170:	68 00 50 80 00       	push   $0x805000
  800175:	6a 00                	push   $0x0
  800177:	e8 0c 11 00 00       	call   801288 <sys_page_map>
  80017c:	83 c4 20             	add    $0x20,%esp
  80017f:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800182:	0f 85 8d 03 00 00    	jne    800515 <umain+0x4e2>
	assert(sys_page_map(0, buf, 0, buf - 1, PTE_U|PTE_P) == -E_INVAL);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 05                	push   $0x5
  80018d:	68 ff 4f 80 00       	push   $0x804fff
  800192:	6a 00                	push   $0x0
  800194:	68 00 50 80 00       	push   $0x805000
  800199:	6a 00                	push   $0x0
  80019b:	e8 e8 10 00 00       	call   801288 <sys_page_map>
  8001a0:	83 c4 20             	add    $0x20,%esp
  8001a3:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8001a6:	0f 85 7f 03 00 00    	jne    80052b <umain+0x4f8>
	assert(sys_page_map(0, VA, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  8001ac:	83 ec 0c             	sub    $0xc,%esp
  8001af:	6a 05                	push   $0x5
  8001b1:	68 00 00 00 a0       	push   $0xa0000000
  8001b6:	6a 00                	push   $0x0
  8001b8:	68 00 00 00 a0       	push   $0xa0000000
  8001bd:	6a 00                	push   $0x0
  8001bf:	e8 c4 10 00 00       	call   801288 <sys_page_map>
  8001c4:	83 c4 20             	add    $0x20,%esp
  8001c7:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8001ca:	0f 85 71 03 00 00    	jne    800541 <umain+0x50e>
	assert(sys_page_map(0, buf, 0, buf, PTE_U|PTE_P|PTE_G) == -E_INVAL);
  8001d0:	83 ec 0c             	sub    $0xc,%esp
  8001d3:	68 05 01 00 00       	push   $0x105
  8001d8:	68 00 50 80 00       	push   $0x805000
  8001dd:	6a 00                	push   $0x0
  8001df:	68 00 50 80 00       	push   $0x805000
  8001e4:	6a 00                	push   $0x0
  8001e6:	e8 9d 10 00 00       	call   801288 <sys_page_map>
  8001eb:	83 c4 20             	add    $0x20,%esp
  8001ee:	83 f8 fd             	cmp    $0xfffffffd,%eax
  8001f1:	0f 85 60 03 00 00    	jne    800557 <umain+0x524>
	assert(sys_page_map(0, buf, 0, buf, 0) == -E_INVAL);
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	6a 00                	push   $0x0
  8001fc:	68 00 50 80 00       	push   $0x805000
  800201:	6a 00                	push   $0x0
  800203:	68 00 50 80 00       	push   $0x805000
  800208:	6a 00                	push   $0x0
  80020a:	e8 79 10 00 00       	call   801288 <sys_page_map>
  80020f:	83 c4 20             	add    $0x20,%esp
  800212:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800215:	0f 85 52 03 00 00    	jne    80056d <umain+0x53a>

	// sys_page_unmap error cases
	assert(sys_page_unmap(-1, VA) == -E_BAD_ENV);
  80021b:	83 ec 08             	sub    $0x8,%esp
  80021e:	68 00 00 00 a0       	push   $0xa0000000
  800223:	6a ff                	push   $0xffffffff
  800225:	e8 a0 10 00 00       	call   8012ca <sys_page_unmap>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	83 f8 fe             	cmp    $0xfffffffe,%eax
  800230:	0f 85 4d 03 00 00    	jne    800583 <umain+0x550>
	assert(sys_page_unmap(0, (void *)UTOP + PGSIZE) == -E_INVAL);
  800236:	83 ec 08             	sub    $0x8,%esp
  800239:	68 00 10 c0 ee       	push   $0xeec01000
  80023e:	6a 00                	push   $0x0
  800240:	e8 85 10 00 00       	call   8012ca <sys_page_unmap>
  800245:	83 c4 10             	add    $0x10,%esp
  800248:	83 f8 fd             	cmp    $0xfffffffd,%eax
  80024b:	0f 85 48 03 00 00    	jne    800599 <umain+0x566>
	assert(sys_page_unmap(0, VA + 1) == -E_INVAL);
  800251:	83 ec 08             	sub    $0x8,%esp
  800254:	68 01 00 00 a0       	push   $0xa0000001
  800259:	6a 00                	push   $0x0
  80025b:	e8 6a 10 00 00       	call   8012ca <sys_page_unmap>
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800266:	0f 85 43 03 00 00    	jne    8005af <umain+0x57c>
	assert(sys_page_unmap(0, VA) == 0);
  80026c:	83 ec 08             	sub    $0x8,%esp
  80026f:	68 00 00 00 a0       	push   $0xa0000000
  800274:	6a 00                	push   $0x0
  800276:	e8 4f 10 00 00       	call   8012ca <sys_page_unmap>
  80027b:	83 c4 10             	add    $0x10,%esp
  80027e:	85 c0                	test   %eax,%eax
  800280:	0f 85 3f 03 00 00    	jne    8005c5 <umain+0x592>

	// map buf at VA & write to VA
	assert(!(uvpd[PDX(VA)] & PTE_P) || !(uvpt[PGNUM(VA)] & PTE_P));
  800286:	a1 00 da 7b ef       	mov    0xef7bda00,%eax
  80028b:	a8 01                	test   $0x1,%al
  80028d:	74 0d                	je     80029c <umain+0x269>
  80028f:	a1 00 00 68 ef       	mov    0xef680000,%eax
  800294:	a8 01                	test   $0x1,%al
  800296:	0f 85 3f 03 00 00    	jne    8005db <umain+0x5a8>
	assert(sys_page_map(0, buf, 0, VA, PTE_U|PTE_P|PTE_W) == 0);
  80029c:	83 ec 0c             	sub    $0xc,%esp
  80029f:	6a 07                	push   $0x7
  8002a1:	68 00 00 00 a0       	push   $0xa0000000
  8002a6:	6a 00                	push   $0x0
  8002a8:	68 00 50 80 00       	push   $0x805000
  8002ad:	6a 00                	push   $0x0
  8002af:	e8 d4 0f 00 00       	call   801288 <sys_page_map>
  8002b4:	83 c4 20             	add    $0x20,%esp
  8002b7:	85 c0                	test   %eax,%eax
  8002b9:	0f 85 32 03 00 00    	jne    8005f1 <umain+0x5be>
	assert((uvpd[PDX(VA)] & PTE_P) && (uvpt[PGNUM(VA)] & PTE_P));
  8002bf:	a1 00 da 7b ef       	mov    0xef7bda00,%eax
  8002c4:	a8 01                	test   $0x1,%al
  8002c6:	0f 84 3b 03 00 00    	je     800607 <umain+0x5d4>
  8002cc:	a1 00 00 68 ef       	mov    0xef680000,%eax
  8002d1:	a8 01                	test   $0x1,%al
  8002d3:	0f 84 2e 03 00 00    	je     800607 <umain+0x5d4>
	strcpy(VA, "hello");
  8002d9:	83 ec 08             	sub    $0x8,%esp
  8002dc:	68 09 26 80 00       	push   $0x802609
  8002e1:	68 00 00 00 a0       	push   $0xa0000000
  8002e6:	e8 a5 0b 00 00       	call   800e90 <strcpy>
	assert(strcmp(VA, "hello") == 0);
  8002eb:	83 c4 08             	add    $0x8,%esp
  8002ee:	68 09 26 80 00       	push   $0x802609
  8002f3:	68 00 00 00 a0       	push   $0xa0000000
  8002f8:	e8 30 0c 00 00       	call   800f2d <strcmp>
  8002fd:	83 c4 10             	add    $0x10,%esp
  800300:	85 c0                	test   %eax,%eax
  800302:	0f 85 15 03 00 00    	jne    80061d <umain+0x5ea>
	assert(strcmp(buf, "hello") == 0);
  800308:	83 ec 08             	sub    $0x8,%esp
  80030b:	68 09 26 80 00       	push   $0x802609
  800310:	68 00 50 80 00       	push   $0x805000
  800315:	e8 13 0c 00 00       	call   800f2d <strcmp>
  80031a:	83 c4 10             	add    $0x10,%esp
  80031d:	85 c0                	test   %eax,%eax
  80031f:	0f 85 0e 03 00 00    	jne    800633 <umain+0x600>

	// swap the pages at buf & VA
	assert(sys_page_alloc(0, VA, PTE_U|PTE_P|PTE_W) == 0);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	6a 07                	push   $0x7
  80032a:	68 00 00 00 a0       	push   $0xa0000000
  80032f:	6a 00                	push   $0x0
  800331:	e8 0f 0f 00 00       	call   801245 <sys_page_alloc>
  800336:	83 c4 10             	add    $0x10,%esp
  800339:	85 c0                	test   %eax,%eax
  80033b:	0f 85 08 03 00 00    	jne    800649 <umain+0x616>
	assert(*(char *)VA == 0); // new page mapped
  800341:	80 3d 00 00 00 a0 00 	cmpb   $0x0,0xa0000000
  800348:	0f 85 11 03 00 00    	jne    80065f <umain+0x62c>
	strcpy(VA, "world");
  80034e:	83 ec 08             	sub    $0x8,%esp
  800351:	68 53 26 80 00       	push   $0x802653
  800356:	68 00 00 00 a0       	push   $0xa0000000
  80035b:	e8 30 0b 00 00       	call   800e90 <strcpy>
	assert(strcmp(buf, "hello") == 0);
  800360:	83 c4 08             	add    $0x8,%esp
  800363:	68 09 26 80 00       	push   $0x802609
  800368:	68 00 50 80 00       	push   $0x805000
  80036d:	e8 bb 0b 00 00       	call   800f2d <strcmp>
  800372:	83 c4 10             	add    $0x10,%esp
  800375:	85 c0                	test   %eax,%eax
  800377:	0f 85 f8 02 00 00    	jne    800675 <umain+0x642>
	assert(strcmp(VA, "world") == 0);
  80037d:	83 ec 08             	sub    $0x8,%esp
  800380:	68 53 26 80 00       	push   $0x802653
  800385:	68 00 00 00 a0       	push   $0xa0000000
  80038a:	e8 9e 0b 00 00       	call   800f2d <strcmp>
  80038f:	83 c4 10             	add    $0x10,%esp
  800392:	85 c0                	test   %eax,%eax
  800394:	0f 85 f1 02 00 00    	jne    80068b <umain+0x658>
	assert(sys_page_map(0, buf, 0, UTEMP, PTE_U|PTE_P|PTE_W) == 0);
  80039a:	83 ec 0c             	sub    $0xc,%esp
  80039d:	6a 07                	push   $0x7
  80039f:	68 00 00 40 00       	push   $0x400000
  8003a4:	6a 00                	push   $0x0
  8003a6:	68 00 50 80 00       	push   $0x805000
  8003ab:	6a 00                	push   $0x0
  8003ad:	e8 d6 0e 00 00       	call   801288 <sys_page_map>
  8003b2:	83 c4 20             	add    $0x20,%esp
  8003b5:	85 c0                	test   %eax,%eax
  8003b7:	0f 85 e4 02 00 00    	jne    8006a1 <umain+0x66e>
	assert(sys_page_map(0, VA, 0, buf, PTE_U|PTE_P|PTE_W) == 0);
  8003bd:	83 ec 0c             	sub    $0xc,%esp
  8003c0:	6a 07                	push   $0x7
  8003c2:	68 00 50 80 00       	push   $0x805000
  8003c7:	6a 00                	push   $0x0
  8003c9:	68 00 00 00 a0       	push   $0xa0000000
  8003ce:	6a 00                	push   $0x0
  8003d0:	e8 b3 0e 00 00       	call   801288 <sys_page_map>
  8003d5:	83 c4 20             	add    $0x20,%esp
  8003d8:	85 c0                	test   %eax,%eax
  8003da:	0f 85 d7 02 00 00    	jne    8006b7 <umain+0x684>
	assert(sys_page_map(0, UTEMP, 0, VA, PTE_U|PTE_P|PTE_W) == 0);
  8003e0:	83 ec 0c             	sub    $0xc,%esp
  8003e3:	6a 07                	push   $0x7
  8003e5:	68 00 00 00 a0       	push   $0xa0000000
  8003ea:	6a 00                	push   $0x0
  8003ec:	68 00 00 40 00       	push   $0x400000
  8003f1:	6a 00                	push   $0x0
  8003f3:	e8 90 0e 00 00       	call   801288 <sys_page_map>
  8003f8:	83 c4 20             	add    $0x20,%esp
  8003fb:	85 c0                	test   %eax,%eax
  8003fd:	0f 85 ca 02 00 00    	jne    8006cd <umain+0x69a>
	assert(strcmp(buf, "world") == 0);
  800403:	83 ec 08             	sub    $0x8,%esp
  800406:	68 53 26 80 00       	push   $0x802653
  80040b:	68 00 50 80 00       	push   $0x805000
  800410:	e8 18 0b 00 00       	call   800f2d <strcmp>
  800415:	83 c4 10             	add    $0x10,%esp
  800418:	85 c0                	test   %eax,%eax
  80041a:	0f 85 c3 02 00 00    	jne    8006e3 <umain+0x6b0>
	assert(strcmp(VA, "hello") == 0);
  800420:	83 ec 08             	sub    $0x8,%esp
  800423:	68 09 26 80 00       	push   $0x802609
  800428:	68 00 00 00 a0       	push   $0xa0000000
  80042d:	e8 fb 0a 00 00       	call   800f2d <strcmp>
  800432:	83 c4 10             	add    $0x10,%esp
  800435:	85 c0                	test   %eax,%eax
  800437:	0f 85 bc 02 00 00    	jne    8006f9 <umain+0x6c6>

	cprintf("page tests passed\n");
  80043d:	83 ec 0c             	sub    $0xc,%esp
  800440:	68 8c 26 80 00       	push   $0x80268c
  800445:	e8 3e 04 00 00       	call   800888 <cprintf>
}
  80044a:	83 c4 10             	add    $0x10,%esp
  80044d:	c9                   	leave  
  80044e:	c3                   	ret    
	assert(sys_page_alloc(-1, VA, PTE_U|PTE_P) == -E_BAD_ENV);
  80044f:	68 a0 26 80 00       	push   $0x8026a0
  800454:	68 c9 25 80 00       	push   $0x8025c9
  800459:	6a 0d                	push   $0xd
  80045b:	68 de 25 80 00       	push   $0x8025de
  800460:	e8 10 03 00 00       	call   800775 <_panic>
	assert(sys_page_alloc(0, (void *)UTOP + PGSIZE, PTE_U|PTE_P) == -E_INVAL);
  800465:	68 d4 26 80 00       	push   $0x8026d4
  80046a:	68 c9 25 80 00       	push   $0x8025c9
  80046f:	6a 0e                	push   $0xe
  800471:	68 de 25 80 00       	push   $0x8025de
  800476:	e8 fa 02 00 00       	call   800775 <_panic>
	assert(sys_page_alloc(0, VA + 1, PTE_U|PTE_P) == -E_INVAL);
  80047b:	68 18 27 80 00       	push   $0x802718
  800480:	68 c9 25 80 00       	push   $0x8025c9
  800485:	6a 0f                	push   $0xf
  800487:	68 de 25 80 00       	push   $0x8025de
  80048c:	e8 e4 02 00 00       	call   800775 <_panic>
	assert(sys_page_alloc(0, VA, PTE_U|PTE_P|PTE_G) == -E_INVAL);
  800491:	68 4c 27 80 00       	push   $0x80274c
  800496:	68 c9 25 80 00       	push   $0x8025c9
  80049b:	6a 10                	push   $0x10
  80049d:	68 de 25 80 00       	push   $0x8025de
  8004a2:	e8 ce 02 00 00       	call   800775 <_panic>
	assert(sys_page_alloc(0, VA, 0) == -E_INVAL);
  8004a7:	68 84 27 80 00       	push   $0x802784
  8004ac:	68 c9 25 80 00       	push   $0x8025c9
  8004b1:	6a 11                	push   $0x11
  8004b3:	68 de 25 80 00       	push   $0x8025de
  8004b8:	e8 b8 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(-1, buf, 0, buf, PTE_U|PTE_P) == -E_BAD_ENV);
  8004bd:	68 ac 27 80 00       	push   $0x8027ac
  8004c2:	68 c9 25 80 00       	push   $0x8025c9
  8004c7:	6a 14                	push   $0x14
  8004c9:	68 de 25 80 00       	push   $0x8025de
  8004ce:	e8 a2 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, -1, buf, PTE_U|PTE_P) == -E_BAD_ENV);
  8004d3:	68 e8 27 80 00       	push   $0x8027e8
  8004d8:	68 c9 25 80 00       	push   $0x8025c9
  8004dd:	6a 15                	push   $0x15
  8004df:	68 de 25 80 00       	push   $0x8025de
  8004e4:	e8 8c 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf + 1, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  8004e9:	68 24 28 80 00       	push   $0x802824
  8004ee:	68 c9 25 80 00       	push   $0x8025c9
  8004f3:	6a 16                	push   $0x16
  8004f5:	68 de 25 80 00       	push   $0x8025de
  8004fa:	e8 76 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, (void *)UTOP + PGSIZE, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  8004ff:	68 60 28 80 00       	push   $0x802860
  800504:	68 c9 25 80 00       	push   $0x8025c9
  800509:	6a 17                	push   $0x17
  80050b:	68 de 25 80 00       	push   $0x8025de
  800510:	e8 60 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, (void *)UTOP + PGSIZE, PTE_U|PTE_P) == -E_INVAL);
  800515:	68 a8 28 80 00       	push   $0x8028a8
  80051a:	68 c9 25 80 00       	push   $0x8025c9
  80051f:	6a 18                	push   $0x18
  800521:	68 de 25 80 00       	push   $0x8025de
  800526:	e8 4a 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, buf - 1, PTE_U|PTE_P) == -E_INVAL);
  80052b:	68 f0 28 80 00       	push   $0x8028f0
  800530:	68 c9 25 80 00       	push   $0x8025c9
  800535:	6a 19                	push   $0x19
  800537:	68 de 25 80 00       	push   $0x8025de
  80053c:	e8 34 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, VA, 0, VA, PTE_U|PTE_P) == -E_INVAL);
  800541:	68 2c 29 80 00       	push   $0x80292c
  800546:	68 c9 25 80 00       	push   $0x8025c9
  80054b:	6a 1a                	push   $0x1a
  80054d:	68 de 25 80 00       	push   $0x8025de
  800552:	e8 1e 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, buf, PTE_U|PTE_P|PTE_G) == -E_INVAL);
  800557:	68 60 29 80 00       	push   $0x802960
  80055c:	68 c9 25 80 00       	push   $0x8025c9
  800561:	6a 1b                	push   $0x1b
  800563:	68 de 25 80 00       	push   $0x8025de
  800568:	e8 08 02 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, buf, 0) == -E_INVAL);
  80056d:	68 9c 29 80 00       	push   $0x80299c
  800572:	68 c9 25 80 00       	push   $0x8025c9
  800577:	6a 1c                	push   $0x1c
  800579:	68 de 25 80 00       	push   $0x8025de
  80057e:	e8 f2 01 00 00       	call   800775 <_panic>
	assert(sys_page_unmap(-1, VA) == -E_BAD_ENV);
  800583:	68 c8 29 80 00       	push   $0x8029c8
  800588:	68 c9 25 80 00       	push   $0x8025c9
  80058d:	6a 1f                	push   $0x1f
  80058f:	68 de 25 80 00       	push   $0x8025de
  800594:	e8 dc 01 00 00       	call   800775 <_panic>
	assert(sys_page_unmap(0, (void *)UTOP + PGSIZE) == -E_INVAL);
  800599:	68 f0 29 80 00       	push   $0x8029f0
  80059e:	68 c9 25 80 00       	push   $0x8025c9
  8005a3:	6a 20                	push   $0x20
  8005a5:	68 de 25 80 00       	push   $0x8025de
  8005aa:	e8 c6 01 00 00       	call   800775 <_panic>
	assert(sys_page_unmap(0, VA + 1) == -E_INVAL);
  8005af:	68 28 2a 80 00       	push   $0x802a28
  8005b4:	68 c9 25 80 00       	push   $0x8025c9
  8005b9:	6a 21                	push   $0x21
  8005bb:	68 de 25 80 00       	push   $0x8025de
  8005c0:	e8 b0 01 00 00       	call   800775 <_panic>
	assert(sys_page_unmap(0, VA) == 0);
  8005c5:	68 ee 25 80 00       	push   $0x8025ee
  8005ca:	68 c9 25 80 00       	push   $0x8025c9
  8005cf:	6a 22                	push   $0x22
  8005d1:	68 de 25 80 00       	push   $0x8025de
  8005d6:	e8 9a 01 00 00       	call   800775 <_panic>
	assert(!(uvpd[PDX(VA)] & PTE_P) || !(uvpt[PGNUM(VA)] & PTE_P));
  8005db:	68 50 2a 80 00       	push   $0x802a50
  8005e0:	68 c9 25 80 00       	push   $0x8025c9
  8005e5:	6a 25                	push   $0x25
  8005e7:	68 de 25 80 00       	push   $0x8025de
  8005ec:	e8 84 01 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, VA, PTE_U|PTE_P|PTE_W) == 0);
  8005f1:	68 88 2a 80 00       	push   $0x802a88
  8005f6:	68 c9 25 80 00       	push   $0x8025c9
  8005fb:	6a 26                	push   $0x26
  8005fd:	68 de 25 80 00       	push   $0x8025de
  800602:	e8 6e 01 00 00       	call   800775 <_panic>
	assert((uvpd[PDX(VA)] & PTE_P) && (uvpt[PGNUM(VA)] & PTE_P));
  800607:	68 bc 2a 80 00       	push   $0x802abc
  80060c:	68 c9 25 80 00       	push   $0x8025c9
  800611:	6a 27                	push   $0x27
  800613:	68 de 25 80 00       	push   $0x8025de
  800618:	e8 58 01 00 00       	call   800775 <_panic>
	assert(strcmp(VA, "hello") == 0);
  80061d:	68 0f 26 80 00       	push   $0x80260f
  800622:	68 c9 25 80 00       	push   $0x8025c9
  800627:	6a 29                	push   $0x29
  800629:	68 de 25 80 00       	push   $0x8025de
  80062e:	e8 42 01 00 00       	call   800775 <_panic>
	assert(strcmp(buf, "hello") == 0);
  800633:	68 28 26 80 00       	push   $0x802628
  800638:	68 c9 25 80 00       	push   $0x8025c9
  80063d:	6a 2a                	push   $0x2a
  80063f:	68 de 25 80 00       	push   $0x8025de
  800644:	e8 2c 01 00 00       	call   800775 <_panic>
	assert(sys_page_alloc(0, VA, PTE_U|PTE_P|PTE_W) == 0);
  800649:	68 f4 2a 80 00       	push   $0x802af4
  80064e:	68 c9 25 80 00       	push   $0x8025c9
  800653:	6a 2d                	push   $0x2d
  800655:	68 de 25 80 00       	push   $0x8025de
  80065a:	e8 16 01 00 00       	call   800775 <_panic>
	assert(*(char *)VA == 0); // new page mapped
  80065f:	68 42 26 80 00       	push   $0x802642
  800664:	68 c9 25 80 00       	push   $0x8025c9
  800669:	6a 2e                	push   $0x2e
  80066b:	68 de 25 80 00       	push   $0x8025de
  800670:	e8 00 01 00 00       	call   800775 <_panic>
	assert(strcmp(buf, "hello") == 0);
  800675:	68 28 26 80 00       	push   $0x802628
  80067a:	68 c9 25 80 00       	push   $0x8025c9
  80067f:	6a 30                	push   $0x30
  800681:	68 de 25 80 00       	push   $0x8025de
  800686:	e8 ea 00 00 00       	call   800775 <_panic>
	assert(strcmp(VA, "world") == 0);
  80068b:	68 59 26 80 00       	push   $0x802659
  800690:	68 c9 25 80 00       	push   $0x8025c9
  800695:	6a 31                	push   $0x31
  800697:	68 de 25 80 00       	push   $0x8025de
  80069c:	e8 d4 00 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, buf, 0, UTEMP, PTE_U|PTE_P|PTE_W) == 0);
  8006a1:	68 24 2b 80 00       	push   $0x802b24
  8006a6:	68 c9 25 80 00       	push   $0x8025c9
  8006ab:	6a 32                	push   $0x32
  8006ad:	68 de 25 80 00       	push   $0x8025de
  8006b2:	e8 be 00 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, VA, 0, buf, PTE_U|PTE_P|PTE_W) == 0);
  8006b7:	68 5c 2b 80 00       	push   $0x802b5c
  8006bc:	68 c9 25 80 00       	push   $0x8025c9
  8006c1:	6a 33                	push   $0x33
  8006c3:	68 de 25 80 00       	push   $0x8025de
  8006c8:	e8 a8 00 00 00       	call   800775 <_panic>
	assert(sys_page_map(0, UTEMP, 0, VA, PTE_U|PTE_P|PTE_W) == 0);
  8006cd:	68 90 2b 80 00       	push   $0x802b90
  8006d2:	68 c9 25 80 00       	push   $0x8025c9
  8006d7:	6a 34                	push   $0x34
  8006d9:	68 de 25 80 00       	push   $0x8025de
  8006de:	e8 92 00 00 00       	call   800775 <_panic>
	assert(strcmp(buf, "world") == 0);
  8006e3:	68 72 26 80 00       	push   $0x802672
  8006e8:	68 c9 25 80 00       	push   $0x8025c9
  8006ed:	6a 35                	push   $0x35
  8006ef:	68 de 25 80 00       	push   $0x8025de
  8006f4:	e8 7c 00 00 00       	call   800775 <_panic>
	assert(strcmp(VA, "hello") == 0);
  8006f9:	68 0f 26 80 00       	push   $0x80260f
  8006fe:	68 c9 25 80 00       	push   $0x8025c9
  800703:	6a 36                	push   $0x36
  800705:	68 de 25 80 00       	push   $0x8025de
  80070a:	e8 66 00 00 00       	call   800775 <_panic>

0080070f <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80070f:	55                   	push   %ebp
  800710:	89 e5                	mov    %esp,%ebp
  800712:	56                   	push   %esi
  800713:	53                   	push   %ebx
  800714:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800717:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80071a:	e8 07 0b 00 00       	call   801226 <sys_getenvid>
  80071f:	25 ff 03 00 00       	and    $0x3ff,%eax
  800724:	89 c2                	mov    %eax,%edx
  800726:	c1 e2 05             	shl    $0x5,%edx
  800729:	29 c2                	sub    %eax,%edx
  80072b:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800732:	a3 04 60 80 00       	mov    %eax,0x806004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800737:	85 db                	test   %ebx,%ebx
  800739:	7e 07                	jle    800742 <libmain+0x33>
		binaryname = argv[0];
  80073b:	8b 06                	mov    (%esi),%eax
  80073d:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	umain(argc, argv);
  800742:	83 ec 08             	sub    $0x8,%esp
  800745:	56                   	push   %esi
  800746:	53                   	push   %ebx
  800747:	e8 e7 f8 ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80074c:	e8 0a 00 00 00       	call   80075b <exit>
}
  800751:	83 c4 10             	add    $0x10,%esp
  800754:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800757:	5b                   	pop    %ebx
  800758:	5e                   	pop    %esi
  800759:	5d                   	pop    %ebp
  80075a:	c3                   	ret    

0080075b <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800761:	e8 68 0f 00 00       	call   8016ce <close_all>
	sys_env_destroy(0);
  800766:	83 ec 0c             	sub    $0xc,%esp
  800769:	6a 00                	push   $0x0
  80076b:	e8 75 0a 00 00       	call   8011e5 <sys_env_destroy>
}
  800770:	83 c4 10             	add    $0x10,%esp
  800773:	c9                   	leave  
  800774:	c3                   	ret    

00800775 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	57                   	push   %edi
  800779:	56                   	push   %esi
  80077a:	53                   	push   %ebx
  80077b:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800781:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800784:	8b 1d 00 40 80 00    	mov    0x804000,%ebx
  80078a:	e8 97 0a 00 00       	call   801226 <sys_getenvid>
  80078f:	83 ec 04             	sub    $0x4,%esp
  800792:	ff 75 0c             	pushl  0xc(%ebp)
  800795:	ff 75 08             	pushl  0x8(%ebp)
  800798:	53                   	push   %ebx
  800799:	50                   	push   %eax
  80079a:	68 d0 2b 80 00       	push   $0x802bd0
  80079f:	68 00 01 00 00       	push   $0x100
  8007a4:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  8007aa:	56                   	push   %esi
  8007ab:	e8 93 06 00 00       	call   800e43 <snprintf>
  8007b0:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  8007b2:	83 c4 20             	add    $0x20,%esp
  8007b5:	57                   	push   %edi
  8007b6:	ff 75 10             	pushl  0x10(%ebp)
  8007b9:	bf 00 01 00 00       	mov    $0x100,%edi
  8007be:	89 f8                	mov    %edi,%eax
  8007c0:	29 d8                	sub    %ebx,%eax
  8007c2:	50                   	push   %eax
  8007c3:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8007c6:	50                   	push   %eax
  8007c7:	e8 22 06 00 00       	call   800dee <vsnprintf>
  8007cc:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8007ce:	83 c4 0c             	add    $0xc,%esp
  8007d1:	68 ee 2f 80 00       	push   $0x802fee
  8007d6:	29 df                	sub    %ebx,%edi
  8007d8:	57                   	push   %edi
  8007d9:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8007dc:	50                   	push   %eax
  8007dd:	e8 61 06 00 00       	call   800e43 <snprintf>
	sys_cputs(buf, r);
  8007e2:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8007e5:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8007e7:	53                   	push   %ebx
  8007e8:	56                   	push   %esi
  8007e9:	e8 ba 09 00 00       	call   8011a8 <sys_cputs>
  8007ee:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8007f1:	cc                   	int3   
  8007f2:	eb fd                	jmp    8007f1 <_panic+0x7c>

008007f4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 04             	sub    $0x4,%esp
  8007fb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8007fe:	8b 13                	mov    (%ebx),%edx
  800800:	8d 42 01             	lea    0x1(%edx),%eax
  800803:	89 03                	mov    %eax,(%ebx)
  800805:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800808:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80080c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800811:	74 08                	je     80081b <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800813:	ff 43 04             	incl   0x4(%ebx)
}
  800816:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800819:	c9                   	leave  
  80081a:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80081b:	83 ec 08             	sub    $0x8,%esp
  80081e:	68 ff 00 00 00       	push   $0xff
  800823:	8d 43 08             	lea    0x8(%ebx),%eax
  800826:	50                   	push   %eax
  800827:	e8 7c 09 00 00       	call   8011a8 <sys_cputs>
		b->idx = 0;
  80082c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800832:	83 c4 10             	add    $0x10,%esp
  800835:	eb dc                	jmp    800813 <putch+0x1f>

00800837 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800837:	55                   	push   %ebp
  800838:	89 e5                	mov    %esp,%ebp
  80083a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800840:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800847:	00 00 00 
	b.cnt = 0;
  80084a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800851:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800854:	ff 75 0c             	pushl  0xc(%ebp)
  800857:	ff 75 08             	pushl  0x8(%ebp)
  80085a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800860:	50                   	push   %eax
  800861:	68 f4 07 80 00       	push   $0x8007f4
  800866:	e8 17 01 00 00       	call   800982 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80086b:	83 c4 08             	add    $0x8,%esp
  80086e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800874:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80087a:	50                   	push   %eax
  80087b:	e8 28 09 00 00       	call   8011a8 <sys_cputs>

	return b.cnt;
}
  800880:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800886:	c9                   	leave  
  800887:	c3                   	ret    

00800888 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80088e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800891:	50                   	push   %eax
  800892:	ff 75 08             	pushl  0x8(%ebp)
  800895:	e8 9d ff ff ff       	call   800837 <vcprintf>
	va_end(ap);

	return cnt;
}
  80089a:	c9                   	leave  
  80089b:	c3                   	ret    

0080089c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80089c:	55                   	push   %ebp
  80089d:	89 e5                	mov    %esp,%ebp
  80089f:	57                   	push   %edi
  8008a0:	56                   	push   %esi
  8008a1:	53                   	push   %ebx
  8008a2:	83 ec 1c             	sub    $0x1c,%esp
  8008a5:	89 c7                	mov    %eax,%edi
  8008a7:	89 d6                	mov    %edx,%esi
  8008a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008af:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008b2:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8008b5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8008b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008bd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008c0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8008c3:	39 d3                	cmp    %edx,%ebx
  8008c5:	72 05                	jb     8008cc <printnum+0x30>
  8008c7:	39 45 10             	cmp    %eax,0x10(%ebp)
  8008ca:	77 78                	ja     800944 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8008cc:	83 ec 0c             	sub    $0xc,%esp
  8008cf:	ff 75 18             	pushl  0x18(%ebp)
  8008d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8008d8:	53                   	push   %ebx
  8008d9:	ff 75 10             	pushl  0x10(%ebp)
  8008dc:	83 ec 08             	sub    $0x8,%esp
  8008df:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008e2:	ff 75 e0             	pushl  -0x20(%ebp)
  8008e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8008e8:	ff 75 d8             	pushl  -0x28(%ebp)
  8008eb:	e8 80 1a 00 00       	call   802370 <__udivdi3>
  8008f0:	83 c4 18             	add    $0x18,%esp
  8008f3:	52                   	push   %edx
  8008f4:	50                   	push   %eax
  8008f5:	89 f2                	mov    %esi,%edx
  8008f7:	89 f8                	mov    %edi,%eax
  8008f9:	e8 9e ff ff ff       	call   80089c <printnum>
  8008fe:	83 c4 20             	add    $0x20,%esp
  800901:	eb 11                	jmp    800914 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800903:	83 ec 08             	sub    $0x8,%esp
  800906:	56                   	push   %esi
  800907:	ff 75 18             	pushl  0x18(%ebp)
  80090a:	ff d7                	call   *%edi
  80090c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80090f:	4b                   	dec    %ebx
  800910:	85 db                	test   %ebx,%ebx
  800912:	7f ef                	jg     800903 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	56                   	push   %esi
  800918:	83 ec 04             	sub    $0x4,%esp
  80091b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80091e:	ff 75 e0             	pushl  -0x20(%ebp)
  800921:	ff 75 dc             	pushl  -0x24(%ebp)
  800924:	ff 75 d8             	pushl  -0x28(%ebp)
  800927:	e8 54 1b 00 00       	call   802480 <__umoddi3>
  80092c:	83 c4 14             	add    $0x14,%esp
  80092f:	0f be 80 f3 2b 80 00 	movsbl 0x802bf3(%eax),%eax
  800936:	50                   	push   %eax
  800937:	ff d7                	call   *%edi
}
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80093f:	5b                   	pop    %ebx
  800940:	5e                   	pop    %esi
  800941:	5f                   	pop    %edi
  800942:	5d                   	pop    %ebp
  800943:	c3                   	ret    
  800944:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800947:	eb c6                	jmp    80090f <printnum+0x73>

00800949 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80094f:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800952:	8b 10                	mov    (%eax),%edx
  800954:	3b 50 04             	cmp    0x4(%eax),%edx
  800957:	73 0a                	jae    800963 <sprintputch+0x1a>
		*b->buf++ = ch;
  800959:	8d 4a 01             	lea    0x1(%edx),%ecx
  80095c:	89 08                	mov    %ecx,(%eax)
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	88 02                	mov    %al,(%edx)
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <printfmt>:
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80096b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80096e:	50                   	push   %eax
  80096f:	ff 75 10             	pushl  0x10(%ebp)
  800972:	ff 75 0c             	pushl  0xc(%ebp)
  800975:	ff 75 08             	pushl  0x8(%ebp)
  800978:	e8 05 00 00 00       	call   800982 <vprintfmt>
}
  80097d:	83 c4 10             	add    $0x10,%esp
  800980:	c9                   	leave  
  800981:	c3                   	ret    

00800982 <vprintfmt>:
{
  800982:	55                   	push   %ebp
  800983:	89 e5                	mov    %esp,%ebp
  800985:	57                   	push   %edi
  800986:	56                   	push   %esi
  800987:	53                   	push   %ebx
  800988:	83 ec 2c             	sub    $0x2c,%esp
  80098b:	8b 75 08             	mov    0x8(%ebp),%esi
  80098e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800991:	8b 7d 10             	mov    0x10(%ebp),%edi
  800994:	e9 ae 03 00 00       	jmp    800d47 <vprintfmt+0x3c5>
  800999:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80099d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8009a4:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8009ab:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8009b2:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009b7:	8d 47 01             	lea    0x1(%edi),%eax
  8009ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8009bd:	8a 17                	mov    (%edi),%dl
  8009bf:	8d 42 dd             	lea    -0x23(%edx),%eax
  8009c2:	3c 55                	cmp    $0x55,%al
  8009c4:	0f 87 fe 03 00 00    	ja     800dc8 <vprintfmt+0x446>
  8009ca:	0f b6 c0             	movzbl %al,%eax
  8009cd:	ff 24 85 40 2d 80 00 	jmp    *0x802d40(,%eax,4)
  8009d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8009d7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8009db:	eb da                	jmp    8009b7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8009e0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8009e4:	eb d1                	jmp    8009b7 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8009e6:	0f b6 d2             	movzbl %dl,%edx
  8009e9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8009f4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8009f7:	01 c0                	add    %eax,%eax
  8009f9:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8009fd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800a00:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800a03:	83 f9 09             	cmp    $0x9,%ecx
  800a06:	77 52                	ja     800a5a <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800a08:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800a09:	eb e9                	jmp    8009f4 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800a0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0e:	8b 00                	mov    (%eax),%eax
  800a10:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a13:	8b 45 14             	mov    0x14(%ebp),%eax
  800a16:	8d 40 04             	lea    0x4(%eax),%eax
  800a19:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800a1c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	79 92                	jns    8009b7 <vprintfmt+0x35>
				width = precision, precision = -1;
  800a25:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a28:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a2b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800a32:	eb 83                	jmp    8009b7 <vprintfmt+0x35>
  800a34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a38:	78 08                	js     800a42 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800a3a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800a3d:	e9 75 ff ff ff       	jmp    8009b7 <vprintfmt+0x35>
  800a42:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a49:	eb ef                	jmp    800a3a <vprintfmt+0xb8>
  800a4b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800a4e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800a55:	e9 5d ff ff ff       	jmp    8009b7 <vprintfmt+0x35>
  800a5a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800a5d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800a60:	eb bd                	jmp    800a1f <vprintfmt+0x9d>
			lflag++;
  800a62:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800a63:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800a66:	e9 4c ff ff ff       	jmp    8009b7 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	8d 78 04             	lea    0x4(%eax),%edi
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	53                   	push   %ebx
  800a75:	ff 30                	pushl  (%eax)
  800a77:	ff d6                	call   *%esi
			break;
  800a79:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800a7c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800a7f:	e9 c0 02 00 00       	jmp    800d44 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	8d 78 04             	lea    0x4(%eax),%edi
  800a8a:	8b 00                	mov    (%eax),%eax
  800a8c:	85 c0                	test   %eax,%eax
  800a8e:	78 2a                	js     800aba <vprintfmt+0x138>
  800a90:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800a92:	83 f8 0f             	cmp    $0xf,%eax
  800a95:	7f 27                	jg     800abe <vprintfmt+0x13c>
  800a97:	8b 04 85 a0 2e 80 00 	mov    0x802ea0(,%eax,4),%eax
  800a9e:	85 c0                	test   %eax,%eax
  800aa0:	74 1c                	je     800abe <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800aa2:	50                   	push   %eax
  800aa3:	68 db 25 80 00       	push   $0x8025db
  800aa8:	53                   	push   %ebx
  800aa9:	56                   	push   %esi
  800aaa:	e8 b6 fe ff ff       	call   800965 <printfmt>
  800aaf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ab2:	89 7d 14             	mov    %edi,0x14(%ebp)
  800ab5:	e9 8a 02 00 00       	jmp    800d44 <vprintfmt+0x3c2>
  800aba:	f7 d8                	neg    %eax
  800abc:	eb d2                	jmp    800a90 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800abe:	52                   	push   %edx
  800abf:	68 0b 2c 80 00       	push   $0x802c0b
  800ac4:	53                   	push   %ebx
  800ac5:	56                   	push   %esi
  800ac6:	e8 9a fe ff ff       	call   800965 <printfmt>
  800acb:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800ace:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800ad1:	e9 6e 02 00 00       	jmp    800d44 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 c0 04             	add    $0x4,%eax
  800adc:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	8b 38                	mov    (%eax),%edi
  800ae4:	85 ff                	test   %edi,%edi
  800ae6:	74 39                	je     800b21 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800ae8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aec:	0f 8e a9 00 00 00    	jle    800b9b <vprintfmt+0x219>
  800af2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800af6:	0f 84 a7 00 00 00    	je     800ba3 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800afc:	83 ec 08             	sub    $0x8,%esp
  800aff:	ff 75 d0             	pushl  -0x30(%ebp)
  800b02:	57                   	push   %edi
  800b03:	e8 6b 03 00 00       	call   800e73 <strnlen>
  800b08:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800b0b:	29 c1                	sub    %eax,%ecx
  800b0d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800b10:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800b13:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800b17:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b1a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800b1d:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1f:	eb 14                	jmp    800b35 <vprintfmt+0x1b3>
				p = "(null)";
  800b21:	bf 04 2c 80 00       	mov    $0x802c04,%edi
  800b26:	eb c0                	jmp    800ae8 <vprintfmt+0x166>
					putch(padc, putdat);
  800b28:	83 ec 08             	sub    $0x8,%esp
  800b2b:	53                   	push   %ebx
  800b2c:	ff 75 e0             	pushl  -0x20(%ebp)
  800b2f:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800b31:	4f                   	dec    %edi
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	85 ff                	test   %edi,%edi
  800b37:	7f ef                	jg     800b28 <vprintfmt+0x1a6>
  800b39:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800b3c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800b3f:	89 c8                	mov    %ecx,%eax
  800b41:	85 c9                	test   %ecx,%ecx
  800b43:	78 10                	js     800b55 <vprintfmt+0x1d3>
  800b45:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800b48:	29 c1                	sub    %eax,%ecx
  800b4a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800b4d:	89 75 08             	mov    %esi,0x8(%ebp)
  800b50:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b53:	eb 15                	jmp    800b6a <vprintfmt+0x1e8>
  800b55:	b8 00 00 00 00       	mov    $0x0,%eax
  800b5a:	eb e9                	jmp    800b45 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	53                   	push   %ebx
  800b60:	52                   	push   %edx
  800b61:	ff 55 08             	call   *0x8(%ebp)
  800b64:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b67:	ff 4d e0             	decl   -0x20(%ebp)
  800b6a:	47                   	inc    %edi
  800b6b:	8a 47 ff             	mov    -0x1(%edi),%al
  800b6e:	0f be d0             	movsbl %al,%edx
  800b71:	85 d2                	test   %edx,%edx
  800b73:	74 59                	je     800bce <vprintfmt+0x24c>
  800b75:	85 f6                	test   %esi,%esi
  800b77:	78 03                	js     800b7c <vprintfmt+0x1fa>
  800b79:	4e                   	dec    %esi
  800b7a:	78 2f                	js     800bab <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800b7c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800b80:	74 da                	je     800b5c <vprintfmt+0x1da>
  800b82:	0f be c0             	movsbl %al,%eax
  800b85:	83 e8 20             	sub    $0x20,%eax
  800b88:	83 f8 5e             	cmp    $0x5e,%eax
  800b8b:	76 cf                	jbe    800b5c <vprintfmt+0x1da>
					putch('?', putdat);
  800b8d:	83 ec 08             	sub    $0x8,%esp
  800b90:	53                   	push   %ebx
  800b91:	6a 3f                	push   $0x3f
  800b93:	ff 55 08             	call   *0x8(%ebp)
  800b96:	83 c4 10             	add    $0x10,%esp
  800b99:	eb cc                	jmp    800b67 <vprintfmt+0x1e5>
  800b9b:	89 75 08             	mov    %esi,0x8(%ebp)
  800b9e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ba1:	eb c7                	jmp    800b6a <vprintfmt+0x1e8>
  800ba3:	89 75 08             	mov    %esi,0x8(%ebp)
  800ba6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ba9:	eb bf                	jmp    800b6a <vprintfmt+0x1e8>
  800bab:	8b 75 08             	mov    0x8(%ebp),%esi
  800bae:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800bb1:	eb 0c                	jmp    800bbf <vprintfmt+0x23d>
				putch(' ', putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	53                   	push   %ebx
  800bb7:	6a 20                	push   $0x20
  800bb9:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800bbb:	4f                   	dec    %edi
  800bbc:	83 c4 10             	add    $0x10,%esp
  800bbf:	85 ff                	test   %edi,%edi
  800bc1:	7f f0                	jg     800bb3 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800bc3:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800bc6:	89 45 14             	mov    %eax,0x14(%ebp)
  800bc9:	e9 76 01 00 00       	jmp    800d44 <vprintfmt+0x3c2>
  800bce:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800bd1:	8b 75 08             	mov    0x8(%ebp),%esi
  800bd4:	eb e9                	jmp    800bbf <vprintfmt+0x23d>
	if (lflag >= 2)
  800bd6:	83 f9 01             	cmp    $0x1,%ecx
  800bd9:	7f 1f                	jg     800bfa <vprintfmt+0x278>
	else if (lflag)
  800bdb:	85 c9                	test   %ecx,%ecx
  800bdd:	75 48                	jne    800c27 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800bdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800be2:	8b 00                	mov    (%eax),%eax
  800be4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800be7:	89 c1                	mov    %eax,%ecx
  800be9:	c1 f9 1f             	sar    $0x1f,%ecx
  800bec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800bef:	8b 45 14             	mov    0x14(%ebp),%eax
  800bf2:	8d 40 04             	lea    0x4(%eax),%eax
  800bf5:	89 45 14             	mov    %eax,0x14(%ebp)
  800bf8:	eb 17                	jmp    800c11 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800bfa:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfd:	8b 50 04             	mov    0x4(%eax),%edx
  800c00:	8b 00                	mov    (%eax),%eax
  800c02:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c05:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800c08:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0b:	8d 40 08             	lea    0x8(%eax),%eax
  800c0e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800c11:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c14:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800c17:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800c1b:	78 25                	js     800c42 <vprintfmt+0x2c0>
			base = 10;
  800c1d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c22:	e9 03 01 00 00       	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800c27:	8b 45 14             	mov    0x14(%ebp),%eax
  800c2a:	8b 00                	mov    (%eax),%eax
  800c2c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800c2f:	89 c1                	mov    %eax,%ecx
  800c31:	c1 f9 1f             	sar    $0x1f,%ecx
  800c34:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800c37:	8b 45 14             	mov    0x14(%ebp),%eax
  800c3a:	8d 40 04             	lea    0x4(%eax),%eax
  800c3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800c40:	eb cf                	jmp    800c11 <vprintfmt+0x28f>
				putch('-', putdat);
  800c42:	83 ec 08             	sub    $0x8,%esp
  800c45:	53                   	push   %ebx
  800c46:	6a 2d                	push   $0x2d
  800c48:	ff d6                	call   *%esi
				num = -(long long) num;
  800c4a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800c4d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800c50:	f7 da                	neg    %edx
  800c52:	83 d1 00             	adc    $0x0,%ecx
  800c55:	f7 d9                	neg    %ecx
  800c57:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800c5a:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c5f:	e9 c6 00 00 00       	jmp    800d2a <vprintfmt+0x3a8>
	if (lflag >= 2)
  800c64:	83 f9 01             	cmp    $0x1,%ecx
  800c67:	7f 1e                	jg     800c87 <vprintfmt+0x305>
	else if (lflag)
  800c69:	85 c9                	test   %ecx,%ecx
  800c6b:	75 32                	jne    800c9f <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800c6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c70:	8b 10                	mov    (%eax),%edx
  800c72:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c77:	8d 40 04             	lea    0x4(%eax),%eax
  800c7a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c7d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c82:	e9 a3 00 00 00       	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800c87:	8b 45 14             	mov    0x14(%ebp),%eax
  800c8a:	8b 10                	mov    (%eax),%edx
  800c8c:	8b 48 04             	mov    0x4(%eax),%ecx
  800c8f:	8d 40 08             	lea    0x8(%eax),%eax
  800c92:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c95:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c9a:	e9 8b 00 00 00       	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	8b 10                	mov    (%eax),%edx
  800ca4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca9:	8d 40 04             	lea    0x4(%eax),%eax
  800cac:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800caf:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cb4:	eb 74                	jmp    800d2a <vprintfmt+0x3a8>
	if (lflag >= 2)
  800cb6:	83 f9 01             	cmp    $0x1,%ecx
  800cb9:	7f 1b                	jg     800cd6 <vprintfmt+0x354>
	else if (lflag)
  800cbb:	85 c9                	test   %ecx,%ecx
  800cbd:	75 2c                	jne    800ceb <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800cbf:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc2:	8b 10                	mov    (%eax),%edx
  800cc4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cc9:	8d 40 04             	lea    0x4(%eax),%eax
  800ccc:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ccf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cd4:	eb 54                	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800cd6:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd9:	8b 10                	mov    (%eax),%edx
  800cdb:	8b 48 04             	mov    0x4(%eax),%ecx
  800cde:	8d 40 08             	lea    0x8(%eax),%eax
  800ce1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ce4:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce9:	eb 3f                	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800ceb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cee:	8b 10                	mov    (%eax),%edx
  800cf0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf5:	8d 40 04             	lea    0x4(%eax),%eax
  800cf8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800cfb:	b8 08 00 00 00       	mov    $0x8,%eax
  800d00:	eb 28                	jmp    800d2a <vprintfmt+0x3a8>
			putch('0', putdat);
  800d02:	83 ec 08             	sub    $0x8,%esp
  800d05:	53                   	push   %ebx
  800d06:	6a 30                	push   $0x30
  800d08:	ff d6                	call   *%esi
			putch('x', putdat);
  800d0a:	83 c4 08             	add    $0x8,%esp
  800d0d:	53                   	push   %ebx
  800d0e:	6a 78                	push   $0x78
  800d10:	ff d6                	call   *%esi
			num = (unsigned long long)
  800d12:	8b 45 14             	mov    0x14(%ebp),%eax
  800d15:	8b 10                	mov    (%eax),%edx
  800d17:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800d1c:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800d1f:	8d 40 04             	lea    0x4(%eax),%eax
  800d22:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d25:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800d2a:	83 ec 0c             	sub    $0xc,%esp
  800d2d:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800d31:	57                   	push   %edi
  800d32:	ff 75 e0             	pushl  -0x20(%ebp)
  800d35:	50                   	push   %eax
  800d36:	51                   	push   %ecx
  800d37:	52                   	push   %edx
  800d38:	89 da                	mov    %ebx,%edx
  800d3a:	89 f0                	mov    %esi,%eax
  800d3c:	e8 5b fb ff ff       	call   80089c <printnum>
			break;
  800d41:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800d44:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d47:	47                   	inc    %edi
  800d48:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800d4c:	83 f8 25             	cmp    $0x25,%eax
  800d4f:	0f 84 44 fc ff ff    	je     800999 <vprintfmt+0x17>
			if (ch == '\0')
  800d55:	85 c0                	test   %eax,%eax
  800d57:	0f 84 89 00 00 00    	je     800de6 <vprintfmt+0x464>
			putch(ch, putdat);
  800d5d:	83 ec 08             	sub    $0x8,%esp
  800d60:	53                   	push   %ebx
  800d61:	50                   	push   %eax
  800d62:	ff d6                	call   *%esi
  800d64:	83 c4 10             	add    $0x10,%esp
  800d67:	eb de                	jmp    800d47 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800d69:	83 f9 01             	cmp    $0x1,%ecx
  800d6c:	7f 1b                	jg     800d89 <vprintfmt+0x407>
	else if (lflag)
  800d6e:	85 c9                	test   %ecx,%ecx
  800d70:	75 2c                	jne    800d9e <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800d72:	8b 45 14             	mov    0x14(%ebp),%eax
  800d75:	8b 10                	mov    (%eax),%edx
  800d77:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d7c:	8d 40 04             	lea    0x4(%eax),%eax
  800d7f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d82:	b8 10 00 00 00       	mov    $0x10,%eax
  800d87:	eb a1                	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800d89:	8b 45 14             	mov    0x14(%ebp),%eax
  800d8c:	8b 10                	mov    (%eax),%edx
  800d8e:	8b 48 04             	mov    0x4(%eax),%ecx
  800d91:	8d 40 08             	lea    0x8(%eax),%eax
  800d94:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d97:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9c:	eb 8c                	jmp    800d2a <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800d9e:	8b 45 14             	mov    0x14(%ebp),%eax
  800da1:	8b 10                	mov    (%eax),%edx
  800da3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da8:	8d 40 04             	lea    0x4(%eax),%eax
  800dab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800dae:	b8 10 00 00 00       	mov    $0x10,%eax
  800db3:	e9 72 ff ff ff       	jmp    800d2a <vprintfmt+0x3a8>
			putch(ch, putdat);
  800db8:	83 ec 08             	sub    $0x8,%esp
  800dbb:	53                   	push   %ebx
  800dbc:	6a 25                	push   $0x25
  800dbe:	ff d6                	call   *%esi
			break;
  800dc0:	83 c4 10             	add    $0x10,%esp
  800dc3:	e9 7c ff ff ff       	jmp    800d44 <vprintfmt+0x3c2>
			putch('%', putdat);
  800dc8:	83 ec 08             	sub    $0x8,%esp
  800dcb:	53                   	push   %ebx
  800dcc:	6a 25                	push   $0x25
  800dce:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800dd0:	83 c4 10             	add    $0x10,%esp
  800dd3:	89 f8                	mov    %edi,%eax
  800dd5:	eb 01                	jmp    800dd8 <vprintfmt+0x456>
  800dd7:	48                   	dec    %eax
  800dd8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800ddc:	75 f9                	jne    800dd7 <vprintfmt+0x455>
  800dde:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800de1:	e9 5e ff ff ff       	jmp    800d44 <vprintfmt+0x3c2>
}
  800de6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de9:	5b                   	pop    %ebx
  800dea:	5e                   	pop    %esi
  800deb:	5f                   	pop    %edi
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 18             	sub    $0x18,%esp
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dfa:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dfd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800e01:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800e04:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800e0b:	85 c0                	test   %eax,%eax
  800e0d:	74 26                	je     800e35 <vsnprintf+0x47>
  800e0f:	85 d2                	test   %edx,%edx
  800e11:	7e 29                	jle    800e3c <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e13:	ff 75 14             	pushl  0x14(%ebp)
  800e16:	ff 75 10             	pushl  0x10(%ebp)
  800e19:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e1c:	50                   	push   %eax
  800e1d:	68 49 09 80 00       	push   $0x800949
  800e22:	e8 5b fb ff ff       	call   800982 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800e27:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e2a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e30:	83 c4 10             	add    $0x10,%esp
}
  800e33:	c9                   	leave  
  800e34:	c3                   	ret    
		return -E_INVAL;
  800e35:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e3a:	eb f7                	jmp    800e33 <vsnprintf+0x45>
  800e3c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e41:	eb f0                	jmp    800e33 <vsnprintf+0x45>

00800e43 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e43:	55                   	push   %ebp
  800e44:	89 e5                	mov    %esp,%ebp
  800e46:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e49:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800e4c:	50                   	push   %eax
  800e4d:	ff 75 10             	pushl  0x10(%ebp)
  800e50:	ff 75 0c             	pushl  0xc(%ebp)
  800e53:	ff 75 08             	pushl  0x8(%ebp)
  800e56:	e8 93 ff ff ff       	call   800dee <vsnprintf>
	va_end(ap);

	return rc;
}
  800e5b:	c9                   	leave  
  800e5c:	c3                   	ret    

00800e5d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800e63:	b8 00 00 00 00       	mov    $0x0,%eax
  800e68:	eb 01                	jmp    800e6b <strlen+0xe>
		n++;
  800e6a:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800e6b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800e6f:	75 f9                	jne    800e6a <strlen+0xd>
	return n;
}
  800e71:	5d                   	pop    %ebp
  800e72:	c3                   	ret    

00800e73 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800e73:	55                   	push   %ebp
  800e74:	89 e5                	mov    %esp,%ebp
  800e76:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e79:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800e81:	eb 01                	jmp    800e84 <strnlen+0x11>
		n++;
  800e83:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e84:	39 d0                	cmp    %edx,%eax
  800e86:	74 06                	je     800e8e <strnlen+0x1b>
  800e88:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800e8c:	75 f5                	jne    800e83 <strnlen+0x10>
	return n;
}
  800e8e:	5d                   	pop    %ebp
  800e8f:	c3                   	ret    

00800e90 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e90:	55                   	push   %ebp
  800e91:	89 e5                	mov    %esp,%ebp
  800e93:	53                   	push   %ebx
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800e9a:	89 c2                	mov    %eax,%edx
  800e9c:	42                   	inc    %edx
  800e9d:	41                   	inc    %ecx
  800e9e:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800ea1:	88 5a ff             	mov    %bl,-0x1(%edx)
  800ea4:	84 db                	test   %bl,%bl
  800ea6:	75 f4                	jne    800e9c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800ea8:	5b                   	pop    %ebx
  800ea9:	5d                   	pop    %ebp
  800eaa:	c3                   	ret    

00800eab <strcat>:

char *
strcat(char *dst, const char *src)
{
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	53                   	push   %ebx
  800eaf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800eb2:	53                   	push   %ebx
  800eb3:	e8 a5 ff ff ff       	call   800e5d <strlen>
  800eb8:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800ebb:	ff 75 0c             	pushl  0xc(%ebp)
  800ebe:	01 d8                	add    %ebx,%eax
  800ec0:	50                   	push   %eax
  800ec1:	e8 ca ff ff ff       	call   800e90 <strcpy>
	return dst;
}
  800ec6:	89 d8                	mov    %ebx,%eax
  800ec8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ecb:	c9                   	leave  
  800ecc:	c3                   	ret    

00800ecd <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	56                   	push   %esi
  800ed1:	53                   	push   %ebx
  800ed2:	8b 75 08             	mov    0x8(%ebp),%esi
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	89 f3                	mov    %esi,%ebx
  800eda:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800edd:	89 f2                	mov    %esi,%edx
  800edf:	eb 0c                	jmp    800eed <strncpy+0x20>
		*dst++ = *src;
  800ee1:	42                   	inc    %edx
  800ee2:	8a 01                	mov    (%ecx),%al
  800ee4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800ee7:	80 39 01             	cmpb   $0x1,(%ecx)
  800eea:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800eed:	39 da                	cmp    %ebx,%edx
  800eef:	75 f0                	jne    800ee1 <strncpy+0x14>
	}
	return ret;
}
  800ef1:	89 f0                	mov    %esi,%eax
  800ef3:	5b                   	pop    %ebx
  800ef4:	5e                   	pop    %esi
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
  800efc:	8b 75 08             	mov    0x8(%ebp),%esi
  800eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f02:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800f05:	85 c0                	test   %eax,%eax
  800f07:	74 20                	je     800f29 <strlcpy+0x32>
  800f09:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800f0d:	89 f0                	mov    %esi,%eax
  800f0f:	eb 05                	jmp    800f16 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800f11:	40                   	inc    %eax
  800f12:	42                   	inc    %edx
  800f13:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800f16:	39 d8                	cmp    %ebx,%eax
  800f18:	74 06                	je     800f20 <strlcpy+0x29>
  800f1a:	8a 0a                	mov    (%edx),%cl
  800f1c:	84 c9                	test   %cl,%cl
  800f1e:	75 f1                	jne    800f11 <strlcpy+0x1a>
		*dst = '\0';
  800f20:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f23:	29 f0                	sub    %esi,%eax
}
  800f25:	5b                   	pop    %ebx
  800f26:	5e                   	pop    %esi
  800f27:	5d                   	pop    %ebp
  800f28:	c3                   	ret    
  800f29:	89 f0                	mov    %esi,%eax
  800f2b:	eb f6                	jmp    800f23 <strlcpy+0x2c>

00800f2d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f33:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800f36:	eb 02                	jmp    800f3a <strcmp+0xd>
		p++, q++;
  800f38:	41                   	inc    %ecx
  800f39:	42                   	inc    %edx
	while (*p && *p == *q)
  800f3a:	8a 01                	mov    (%ecx),%al
  800f3c:	84 c0                	test   %al,%al
  800f3e:	74 04                	je     800f44 <strcmp+0x17>
  800f40:	3a 02                	cmp    (%edx),%al
  800f42:	74 f4                	je     800f38 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f44:	0f b6 c0             	movzbl %al,%eax
  800f47:	0f b6 12             	movzbl (%edx),%edx
  800f4a:	29 d0                	sub    %edx,%eax
}
  800f4c:	5d                   	pop    %ebp
  800f4d:	c3                   	ret    

00800f4e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	53                   	push   %ebx
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f58:	89 c3                	mov    %eax,%ebx
  800f5a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800f5d:	eb 02                	jmp    800f61 <strncmp+0x13>
		n--, p++, q++;
  800f5f:	40                   	inc    %eax
  800f60:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800f61:	39 d8                	cmp    %ebx,%eax
  800f63:	74 15                	je     800f7a <strncmp+0x2c>
  800f65:	8a 08                	mov    (%eax),%cl
  800f67:	84 c9                	test   %cl,%cl
  800f69:	74 04                	je     800f6f <strncmp+0x21>
  800f6b:	3a 0a                	cmp    (%edx),%cl
  800f6d:	74 f0                	je     800f5f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f6f:	0f b6 00             	movzbl (%eax),%eax
  800f72:	0f b6 12             	movzbl (%edx),%edx
  800f75:	29 d0                	sub    %edx,%eax
}
  800f77:	5b                   	pop    %ebx
  800f78:	5d                   	pop    %ebp
  800f79:	c3                   	ret    
		return 0;
  800f7a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f7f:	eb f6                	jmp    800f77 <strncmp+0x29>

00800f81 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
  800f84:	8b 45 08             	mov    0x8(%ebp),%eax
  800f87:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800f8a:	8a 10                	mov    (%eax),%dl
  800f8c:	84 d2                	test   %dl,%dl
  800f8e:	74 07                	je     800f97 <strchr+0x16>
		if (*s == c)
  800f90:	38 ca                	cmp    %cl,%dl
  800f92:	74 08                	je     800f9c <strchr+0x1b>
	for (; *s; s++)
  800f94:	40                   	inc    %eax
  800f95:	eb f3                	jmp    800f8a <strchr+0x9>
			return (char *) s;
	return 0;
  800f97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f9c:	5d                   	pop    %ebp
  800f9d:	c3                   	ret    

00800f9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800fa7:	8a 10                	mov    (%eax),%dl
  800fa9:	84 d2                	test   %dl,%dl
  800fab:	74 07                	je     800fb4 <strfind+0x16>
		if (*s == c)
  800fad:	38 ca                	cmp    %cl,%dl
  800faf:	74 03                	je     800fb4 <strfind+0x16>
	for (; *s; s++)
  800fb1:	40                   	inc    %eax
  800fb2:	eb f3                	jmp    800fa7 <strfind+0x9>
			break;
	return (char *) s;
}
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    

00800fb6 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800fb6:	55                   	push   %ebp
  800fb7:	89 e5                	mov    %esp,%ebp
  800fb9:	57                   	push   %edi
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	8b 7d 08             	mov    0x8(%ebp),%edi
  800fbf:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800fc2:	85 c9                	test   %ecx,%ecx
  800fc4:	74 13                	je     800fd9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800fc6:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800fcc:	75 05                	jne    800fd3 <memset+0x1d>
  800fce:	f6 c1 03             	test   $0x3,%cl
  800fd1:	74 0d                	je     800fe0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800fd3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fd6:	fc                   	cld    
  800fd7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800fd9:	89 f8                	mov    %edi,%eax
  800fdb:	5b                   	pop    %ebx
  800fdc:	5e                   	pop    %esi
  800fdd:	5f                   	pop    %edi
  800fde:	5d                   	pop    %ebp
  800fdf:	c3                   	ret    
		c &= 0xFF;
  800fe0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800fe4:	89 d3                	mov    %edx,%ebx
  800fe6:	c1 e3 08             	shl    $0x8,%ebx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	c1 e0 18             	shl    $0x18,%eax
  800fee:	89 d6                	mov    %edx,%esi
  800ff0:	c1 e6 10             	shl    $0x10,%esi
  800ff3:	09 f0                	or     %esi,%eax
  800ff5:	09 c2                	or     %eax,%edx
  800ff7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ff9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ffc:	89 d0                	mov    %edx,%eax
  800ffe:	fc                   	cld    
  800fff:	f3 ab                	rep stos %eax,%es:(%edi)
  801001:	eb d6                	jmp    800fd9 <memset+0x23>

00801003 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	57                   	push   %edi
  801007:	56                   	push   %esi
  801008:	8b 45 08             	mov    0x8(%ebp),%eax
  80100b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80100e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801011:	39 c6                	cmp    %eax,%esi
  801013:	73 33                	jae    801048 <memmove+0x45>
  801015:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801018:	39 d0                	cmp    %edx,%eax
  80101a:	73 2c                	jae    801048 <memmove+0x45>
		s += n;
		d += n;
  80101c:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80101f:	89 d6                	mov    %edx,%esi
  801021:	09 fe                	or     %edi,%esi
  801023:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801029:	75 13                	jne    80103e <memmove+0x3b>
  80102b:	f6 c1 03             	test   $0x3,%cl
  80102e:	75 0e                	jne    80103e <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801030:	83 ef 04             	sub    $0x4,%edi
  801033:	8d 72 fc             	lea    -0x4(%edx),%esi
  801036:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801039:	fd                   	std    
  80103a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80103c:	eb 07                	jmp    801045 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80103e:	4f                   	dec    %edi
  80103f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801042:	fd                   	std    
  801043:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801045:	fc                   	cld    
  801046:	eb 13                	jmp    80105b <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801048:	89 f2                	mov    %esi,%edx
  80104a:	09 c2                	or     %eax,%edx
  80104c:	f6 c2 03             	test   $0x3,%dl
  80104f:	75 05                	jne    801056 <memmove+0x53>
  801051:	f6 c1 03             	test   $0x3,%cl
  801054:	74 09                	je     80105f <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801056:	89 c7                	mov    %eax,%edi
  801058:	fc                   	cld    
  801059:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80105b:	5e                   	pop    %esi
  80105c:	5f                   	pop    %edi
  80105d:	5d                   	pop    %ebp
  80105e:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80105f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801062:	89 c7                	mov    %eax,%edi
  801064:	fc                   	cld    
  801065:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801067:	eb f2                	jmp    80105b <memmove+0x58>

00801069 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801069:	55                   	push   %ebp
  80106a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80106c:	ff 75 10             	pushl  0x10(%ebp)
  80106f:	ff 75 0c             	pushl  0xc(%ebp)
  801072:	ff 75 08             	pushl  0x8(%ebp)
  801075:	e8 89 ff ff ff       	call   801003 <memmove>
}
  80107a:	c9                   	leave  
  80107b:	c3                   	ret    

0080107c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	8b 45 08             	mov    0x8(%ebp),%eax
  801084:	89 c6                	mov    %eax,%esi
  801086:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801089:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80108c:	39 f0                	cmp    %esi,%eax
  80108e:	74 16                	je     8010a6 <memcmp+0x2a>
		if (*s1 != *s2)
  801090:	8a 08                	mov    (%eax),%cl
  801092:	8a 1a                	mov    (%edx),%bl
  801094:	38 d9                	cmp    %bl,%cl
  801096:	75 04                	jne    80109c <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801098:	40                   	inc    %eax
  801099:	42                   	inc    %edx
  80109a:	eb f0                	jmp    80108c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80109c:	0f b6 c1             	movzbl %cl,%eax
  80109f:	0f b6 db             	movzbl %bl,%ebx
  8010a2:	29 d8                	sub    %ebx,%eax
  8010a4:	eb 05                	jmp    8010ab <memcmp+0x2f>
	}

	return 0;
  8010a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ab:	5b                   	pop    %ebx
  8010ac:	5e                   	pop    %esi
  8010ad:	5d                   	pop    %ebp
  8010ae:	c3                   	ret    

008010af <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8010b8:	89 c2                	mov    %eax,%edx
  8010ba:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8010bd:	39 d0                	cmp    %edx,%eax
  8010bf:	73 07                	jae    8010c8 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8010c1:	38 08                	cmp    %cl,(%eax)
  8010c3:	74 03                	je     8010c8 <memfind+0x19>
	for (; s < ends; s++)
  8010c5:	40                   	inc    %eax
  8010c6:	eb f5                	jmp    8010bd <memfind+0xe>
			break;
	return (void *) s;
}
  8010c8:	5d                   	pop    %ebp
  8010c9:	c3                   	ret    

008010ca <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8010ca:	55                   	push   %ebp
  8010cb:	89 e5                	mov    %esp,%ebp
  8010cd:	57                   	push   %edi
  8010ce:	56                   	push   %esi
  8010cf:	53                   	push   %ebx
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8010d3:	eb 01                	jmp    8010d6 <strtol+0xc>
		s++;
  8010d5:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8010d6:	8a 01                	mov    (%ecx),%al
  8010d8:	3c 20                	cmp    $0x20,%al
  8010da:	74 f9                	je     8010d5 <strtol+0xb>
  8010dc:	3c 09                	cmp    $0x9,%al
  8010de:	74 f5                	je     8010d5 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8010e0:	3c 2b                	cmp    $0x2b,%al
  8010e2:	74 2b                	je     80110f <strtol+0x45>
		s++;
	else if (*s == '-')
  8010e4:	3c 2d                	cmp    $0x2d,%al
  8010e6:	74 2f                	je     801117 <strtol+0x4d>
	int neg = 0;
  8010e8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010ed:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8010f4:	75 12                	jne    801108 <strtol+0x3e>
  8010f6:	80 39 30             	cmpb   $0x30,(%ecx)
  8010f9:	74 24                	je     80111f <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8010fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ff:	75 07                	jne    801108 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801101:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801108:	b8 00 00 00 00       	mov    $0x0,%eax
  80110d:	eb 4e                	jmp    80115d <strtol+0x93>
		s++;
  80110f:	41                   	inc    %ecx
	int neg = 0;
  801110:	bf 00 00 00 00       	mov    $0x0,%edi
  801115:	eb d6                	jmp    8010ed <strtol+0x23>
		s++, neg = 1;
  801117:	41                   	inc    %ecx
  801118:	bf 01 00 00 00       	mov    $0x1,%edi
  80111d:	eb ce                	jmp    8010ed <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80111f:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801123:	74 10                	je     801135 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801125:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801129:	75 dd                	jne    801108 <strtol+0x3e>
		s++, base = 8;
  80112b:	41                   	inc    %ecx
  80112c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801133:	eb d3                	jmp    801108 <strtol+0x3e>
		s += 2, base = 16;
  801135:	83 c1 02             	add    $0x2,%ecx
  801138:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80113f:	eb c7                	jmp    801108 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801141:	8d 72 9f             	lea    -0x61(%edx),%esi
  801144:	89 f3                	mov    %esi,%ebx
  801146:	80 fb 19             	cmp    $0x19,%bl
  801149:	77 24                	ja     80116f <strtol+0xa5>
			dig = *s - 'a' + 10;
  80114b:	0f be d2             	movsbl %dl,%edx
  80114e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801151:	3b 55 10             	cmp    0x10(%ebp),%edx
  801154:	7d 2b                	jge    801181 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801156:	41                   	inc    %ecx
  801157:	0f af 45 10          	imul   0x10(%ebp),%eax
  80115b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80115d:	8a 11                	mov    (%ecx),%dl
  80115f:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801162:	80 fb 09             	cmp    $0x9,%bl
  801165:	77 da                	ja     801141 <strtol+0x77>
			dig = *s - '0';
  801167:	0f be d2             	movsbl %dl,%edx
  80116a:	83 ea 30             	sub    $0x30,%edx
  80116d:	eb e2                	jmp    801151 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  80116f:	8d 72 bf             	lea    -0x41(%edx),%esi
  801172:	89 f3                	mov    %esi,%ebx
  801174:	80 fb 19             	cmp    $0x19,%bl
  801177:	77 08                	ja     801181 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801179:	0f be d2             	movsbl %dl,%edx
  80117c:	83 ea 37             	sub    $0x37,%edx
  80117f:	eb d0                	jmp    801151 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801181:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801185:	74 05                	je     80118c <strtol+0xc2>
		*endptr = (char *) s;
  801187:	8b 75 0c             	mov    0xc(%ebp),%esi
  80118a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  80118c:	85 ff                	test   %edi,%edi
  80118e:	74 02                	je     801192 <strtol+0xc8>
  801190:	f7 d8                	neg    %eax
}
  801192:	5b                   	pop    %ebx
  801193:	5e                   	pop    %esi
  801194:	5f                   	pop    %edi
  801195:	5d                   	pop    %ebp
  801196:	c3                   	ret    

00801197 <atoi>:

int
atoi(const char *s)
{
  801197:	55                   	push   %ebp
  801198:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  80119a:	6a 0a                	push   $0xa
  80119c:	6a 00                	push   $0x0
  80119e:	ff 75 08             	pushl  0x8(%ebp)
  8011a1:	e8 24 ff ff ff       	call   8010ca <strtol>
}
  8011a6:	c9                   	leave  
  8011a7:	c3                   	ret    

008011a8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8011a8:	55                   	push   %ebp
  8011a9:	89 e5                	mov    %esp,%ebp
  8011ab:	57                   	push   %edi
  8011ac:	56                   	push   %esi
  8011ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b9:	89 c3                	mov    %eax,%ebx
  8011bb:	89 c7                	mov    %eax,%edi
  8011bd:	89 c6                	mov    %eax,%esi
  8011bf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8011c1:	5b                   	pop    %ebx
  8011c2:	5e                   	pop    %esi
  8011c3:	5f                   	pop    %edi
  8011c4:	5d                   	pop    %ebp
  8011c5:	c3                   	ret    

008011c6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8011c6:	55                   	push   %ebp
  8011c7:	89 e5                	mov    %esp,%ebp
  8011c9:	57                   	push   %edi
  8011ca:	56                   	push   %esi
  8011cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8011d6:	89 d1                	mov    %edx,%ecx
  8011d8:	89 d3                	mov    %edx,%ebx
  8011da:	89 d7                	mov    %edx,%edi
  8011dc:	89 d6                	mov    %edx,%esi
  8011de:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8011e0:	5b                   	pop    %ebx
  8011e1:	5e                   	pop    %esi
  8011e2:	5f                   	pop    %edi
  8011e3:	5d                   	pop    %ebp
  8011e4:	c3                   	ret    

008011e5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8011e5:	55                   	push   %ebp
  8011e6:	89 e5                	mov    %esp,%ebp
  8011e8:	57                   	push   %edi
  8011e9:	56                   	push   %esi
  8011ea:	53                   	push   %ebx
  8011eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8011f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fb:	89 cb                	mov    %ecx,%ebx
  8011fd:	89 cf                	mov    %ecx,%edi
  8011ff:	89 ce                	mov    %ecx,%esi
  801201:	cd 30                	int    $0x30
	if(check && ret > 0)
  801203:	85 c0                	test   %eax,%eax
  801205:	7f 08                	jg     80120f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801207:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120a:	5b                   	pop    %ebx
  80120b:	5e                   	pop    %esi
  80120c:	5f                   	pop    %edi
  80120d:	5d                   	pop    %ebp
  80120e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	50                   	push   %eax
  801213:	6a 03                	push   $0x3
  801215:	68 ff 2e 80 00       	push   $0x802eff
  80121a:	6a 23                	push   $0x23
  80121c:	68 1c 2f 80 00       	push   $0x802f1c
  801221:	e8 4f f5 ff ff       	call   800775 <_panic>

00801226 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	57                   	push   %edi
  80122a:	56                   	push   %esi
  80122b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122c:	ba 00 00 00 00       	mov    $0x0,%edx
  801231:	b8 02 00 00 00       	mov    $0x2,%eax
  801236:	89 d1                	mov    %edx,%ecx
  801238:	89 d3                	mov    %edx,%ebx
  80123a:	89 d7                	mov    %edx,%edi
  80123c:	89 d6                	mov    %edx,%esi
  80123e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801240:	5b                   	pop    %ebx
  801241:	5e                   	pop    %esi
  801242:	5f                   	pop    %edi
  801243:	5d                   	pop    %ebp
  801244:	c3                   	ret    

00801245 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	57                   	push   %edi
  801249:	56                   	push   %esi
  80124a:	53                   	push   %ebx
  80124b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80124e:	be 00 00 00 00       	mov    $0x0,%esi
  801253:	b8 04 00 00 00       	mov    $0x4,%eax
  801258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801261:	89 f7                	mov    %esi,%edi
  801263:	cd 30                	int    $0x30
	if(check && ret > 0)
  801265:	85 c0                	test   %eax,%eax
  801267:	7f 08                	jg     801271 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126c:	5b                   	pop    %ebx
  80126d:	5e                   	pop    %esi
  80126e:	5f                   	pop    %edi
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801271:	83 ec 0c             	sub    $0xc,%esp
  801274:	50                   	push   %eax
  801275:	6a 04                	push   $0x4
  801277:	68 ff 2e 80 00       	push   $0x802eff
  80127c:	6a 23                	push   $0x23
  80127e:	68 1c 2f 80 00       	push   $0x802f1c
  801283:	e8 ed f4 ff ff       	call   800775 <_panic>

00801288 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801288:	55                   	push   %ebp
  801289:	89 e5                	mov    %esp,%ebp
  80128b:	57                   	push   %edi
  80128c:	56                   	push   %esi
  80128d:	53                   	push   %ebx
  80128e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801291:	b8 05 00 00 00       	mov    $0x5,%eax
  801296:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801299:	8b 55 08             	mov    0x8(%ebp),%edx
  80129c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80129f:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012a2:	8b 75 18             	mov    0x18(%ebp),%esi
  8012a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a7:	85 c0                	test   %eax,%eax
  8012a9:	7f 08                	jg     8012b3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8012ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ae:	5b                   	pop    %ebx
  8012af:	5e                   	pop    %esi
  8012b0:	5f                   	pop    %edi
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b3:	83 ec 0c             	sub    $0xc,%esp
  8012b6:	50                   	push   %eax
  8012b7:	6a 05                	push   $0x5
  8012b9:	68 ff 2e 80 00       	push   $0x802eff
  8012be:	6a 23                	push   $0x23
  8012c0:	68 1c 2f 80 00       	push   $0x802f1c
  8012c5:	e8 ab f4 ff ff       	call   800775 <_panic>

008012ca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	57                   	push   %edi
  8012ce:	56                   	push   %esi
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8012d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8012dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e3:	89 df                	mov    %ebx,%edi
  8012e5:	89 de                	mov    %ebx,%esi
  8012e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012e9:	85 c0                	test   %eax,%eax
  8012eb:	7f 08                	jg     8012f5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8012ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f0:	5b                   	pop    %ebx
  8012f1:	5e                   	pop    %esi
  8012f2:	5f                   	pop    %edi
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f5:	83 ec 0c             	sub    $0xc,%esp
  8012f8:	50                   	push   %eax
  8012f9:	6a 06                	push   $0x6
  8012fb:	68 ff 2e 80 00       	push   $0x802eff
  801300:	6a 23                	push   $0x23
  801302:	68 1c 2f 80 00       	push   $0x802f1c
  801307:	e8 69 f4 ff ff       	call   800775 <_panic>

0080130c <sys_yield>:

void
sys_yield(void)
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	57                   	push   %edi
  801310:	56                   	push   %esi
  801311:	53                   	push   %ebx
	asm volatile("int %1\n"
  801312:	ba 00 00 00 00       	mov    $0x0,%edx
  801317:	b8 0b 00 00 00       	mov    $0xb,%eax
  80131c:	89 d1                	mov    %edx,%ecx
  80131e:	89 d3                	mov    %edx,%ebx
  801320:	89 d7                	mov    %edx,%edi
  801322:	89 d6                	mov    %edx,%esi
  801324:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801326:	5b                   	pop    %ebx
  801327:	5e                   	pop    %esi
  801328:	5f                   	pop    %edi
  801329:	5d                   	pop    %ebp
  80132a:	c3                   	ret    

0080132b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	57                   	push   %edi
  80132f:	56                   	push   %esi
  801330:	53                   	push   %ebx
  801331:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801334:	bb 00 00 00 00       	mov    $0x0,%ebx
  801339:	b8 08 00 00 00       	mov    $0x8,%eax
  80133e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801341:	8b 55 08             	mov    0x8(%ebp),%edx
  801344:	89 df                	mov    %ebx,%edi
  801346:	89 de                	mov    %ebx,%esi
  801348:	cd 30                	int    $0x30
	if(check && ret > 0)
  80134a:	85 c0                	test   %eax,%eax
  80134c:	7f 08                	jg     801356 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80134e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801351:	5b                   	pop    %ebx
  801352:	5e                   	pop    %esi
  801353:	5f                   	pop    %edi
  801354:	5d                   	pop    %ebp
  801355:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801356:	83 ec 0c             	sub    $0xc,%esp
  801359:	50                   	push   %eax
  80135a:	6a 08                	push   $0x8
  80135c:	68 ff 2e 80 00       	push   $0x802eff
  801361:	6a 23                	push   $0x23
  801363:	68 1c 2f 80 00       	push   $0x802f1c
  801368:	e8 08 f4 ff ff       	call   800775 <_panic>

0080136d <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  80136d:	55                   	push   %ebp
  80136e:	89 e5                	mov    %esp,%ebp
  801370:	57                   	push   %edi
  801371:	56                   	push   %esi
  801372:	53                   	push   %ebx
  801373:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801376:	b9 00 00 00 00       	mov    $0x0,%ecx
  80137b:	b8 0c 00 00 00       	mov    $0xc,%eax
  801380:	8b 55 08             	mov    0x8(%ebp),%edx
  801383:	89 cb                	mov    %ecx,%ebx
  801385:	89 cf                	mov    %ecx,%edi
  801387:	89 ce                	mov    %ecx,%esi
  801389:	cd 30                	int    $0x30
	if(check && ret > 0)
  80138b:	85 c0                	test   %eax,%eax
  80138d:	7f 08                	jg     801397 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80138f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801392:	5b                   	pop    %ebx
  801393:	5e                   	pop    %esi
  801394:	5f                   	pop    %edi
  801395:	5d                   	pop    %ebp
  801396:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801397:	83 ec 0c             	sub    $0xc,%esp
  80139a:	50                   	push   %eax
  80139b:	6a 0c                	push   $0xc
  80139d:	68 ff 2e 80 00       	push   $0x802eff
  8013a2:	6a 23                	push   $0x23
  8013a4:	68 1c 2f 80 00       	push   $0x802f1c
  8013a9:	e8 c7 f3 ff ff       	call   800775 <_panic>

008013ae <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	57                   	push   %edi
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8013c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c7:	89 df                	mov    %ebx,%edi
  8013c9:	89 de                	mov    %ebx,%esi
  8013cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	7f 08                	jg     8013d9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8013d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d4:	5b                   	pop    %ebx
  8013d5:	5e                   	pop    %esi
  8013d6:	5f                   	pop    %edi
  8013d7:	5d                   	pop    %ebp
  8013d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d9:	83 ec 0c             	sub    $0xc,%esp
  8013dc:	50                   	push   %eax
  8013dd:	6a 09                	push   $0x9
  8013df:	68 ff 2e 80 00       	push   $0x802eff
  8013e4:	6a 23                	push   $0x23
  8013e6:	68 1c 2f 80 00       	push   $0x802f1c
  8013eb:	e8 85 f3 ff ff       	call   800775 <_panic>

008013f0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8013f0:	55                   	push   %ebp
  8013f1:	89 e5                	mov    %esp,%ebp
  8013f3:	57                   	push   %edi
  8013f4:	56                   	push   %esi
  8013f5:	53                   	push   %ebx
  8013f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8013fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  801403:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801406:	8b 55 08             	mov    0x8(%ebp),%edx
  801409:	89 df                	mov    %ebx,%edi
  80140b:	89 de                	mov    %ebx,%esi
  80140d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80140f:	85 c0                	test   %eax,%eax
  801411:	7f 08                	jg     80141b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801413:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801416:	5b                   	pop    %ebx
  801417:	5e                   	pop    %esi
  801418:	5f                   	pop    %edi
  801419:	5d                   	pop    %ebp
  80141a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80141b:	83 ec 0c             	sub    $0xc,%esp
  80141e:	50                   	push   %eax
  80141f:	6a 0a                	push   $0xa
  801421:	68 ff 2e 80 00       	push   $0x802eff
  801426:	6a 23                	push   $0x23
  801428:	68 1c 2f 80 00       	push   $0x802f1c
  80142d:	e8 43 f3 ff ff       	call   800775 <_panic>

00801432 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  801432:	55                   	push   %ebp
  801433:	89 e5                	mov    %esp,%ebp
  801435:	57                   	push   %edi
  801436:	56                   	push   %esi
  801437:	53                   	push   %ebx
	asm volatile("int %1\n"
  801438:	be 00 00 00 00       	mov    $0x0,%esi
  80143d:	b8 0d 00 00 00       	mov    $0xd,%eax
  801442:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801445:	8b 55 08             	mov    0x8(%ebp),%edx
  801448:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80144b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80144e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  801450:	5b                   	pop    %ebx
  801451:	5e                   	pop    %esi
  801452:	5f                   	pop    %edi
  801453:	5d                   	pop    %ebp
  801454:	c3                   	ret    

00801455 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	57                   	push   %edi
  801459:	56                   	push   %esi
  80145a:	53                   	push   %ebx
  80145b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80145e:	b9 00 00 00 00       	mov    $0x0,%ecx
  801463:	b8 0e 00 00 00       	mov    $0xe,%eax
  801468:	8b 55 08             	mov    0x8(%ebp),%edx
  80146b:	89 cb                	mov    %ecx,%ebx
  80146d:	89 cf                	mov    %ecx,%edi
  80146f:	89 ce                	mov    %ecx,%esi
  801471:	cd 30                	int    $0x30
	if(check && ret > 0)
  801473:	85 c0                	test   %eax,%eax
  801475:	7f 08                	jg     80147f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801477:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80147a:	5b                   	pop    %ebx
  80147b:	5e                   	pop    %esi
  80147c:	5f                   	pop    %edi
  80147d:	5d                   	pop    %ebp
  80147e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80147f:	83 ec 0c             	sub    $0xc,%esp
  801482:	50                   	push   %eax
  801483:	6a 0e                	push   $0xe
  801485:	68 ff 2e 80 00       	push   $0x802eff
  80148a:	6a 23                	push   $0x23
  80148c:	68 1c 2f 80 00       	push   $0x802f1c
  801491:	e8 df f2 ff ff       	call   800775 <_panic>

00801496 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	57                   	push   %edi
  80149a:	56                   	push   %esi
  80149b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80149c:	be 00 00 00 00       	mov    $0x0,%esi
  8014a1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8014a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014af:	89 f7                	mov    %esi,%edi
  8014b1:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8014b3:	5b                   	pop    %ebx
  8014b4:	5e                   	pop    %esi
  8014b5:	5f                   	pop    %edi
  8014b6:	5d                   	pop    %ebp
  8014b7:	c3                   	ret    

008014b8 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8014b8:	55                   	push   %ebp
  8014b9:	89 e5                	mov    %esp,%ebp
  8014bb:	57                   	push   %edi
  8014bc:	56                   	push   %esi
  8014bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014be:	be 00 00 00 00       	mov    $0x0,%esi
  8014c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8014c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014d1:	89 f7                	mov    %esi,%edi
  8014d3:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8014d5:	5b                   	pop    %ebx
  8014d6:	5e                   	pop    %esi
  8014d7:	5f                   	pop    %edi
  8014d8:	5d                   	pop    %ebp
  8014d9:	c3                   	ret    

008014da <sys_set_console_color>:

void sys_set_console_color(int color) {
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
  8014dd:	57                   	push   %edi
  8014de:	56                   	push   %esi
  8014df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8014e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8014e5:	b8 11 00 00 00       	mov    $0x11,%eax
  8014ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ed:	89 cb                	mov    %ecx,%ebx
  8014ef:	89 cf                	mov    %ecx,%edi
  8014f1:	89 ce                	mov    %ecx,%esi
  8014f3:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8014f5:	5b                   	pop    %ebx
  8014f6:	5e                   	pop    %esi
  8014f7:	5f                   	pop    %edi
  8014f8:	5d                   	pop    %ebp
  8014f9:	c3                   	ret    

008014fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801500:	05 00 00 00 30       	add    $0x30000000,%eax
  801505:	c1 e8 0c             	shr    $0xc,%eax
}
  801508:	5d                   	pop    %ebp
  801509:	c3                   	ret    

0080150a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80150a:	55                   	push   %ebp
  80150b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801515:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80151a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80151f:	5d                   	pop    %ebp
  801520:	c3                   	ret    

00801521 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801527:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80152c:	89 c2                	mov    %eax,%edx
  80152e:	c1 ea 16             	shr    $0x16,%edx
  801531:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801538:	f6 c2 01             	test   $0x1,%dl
  80153b:	74 2a                	je     801567 <fd_alloc+0x46>
  80153d:	89 c2                	mov    %eax,%edx
  80153f:	c1 ea 0c             	shr    $0xc,%edx
  801542:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801549:	f6 c2 01             	test   $0x1,%dl
  80154c:	74 19                	je     801567 <fd_alloc+0x46>
  80154e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801553:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801558:	75 d2                	jne    80152c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80155a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801560:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801565:	eb 07                	jmp    80156e <fd_alloc+0x4d>
			*fd_store = fd;
  801567:	89 01                	mov    %eax,(%ecx)
			return 0;
  801569:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156e:	5d                   	pop    %ebp
  80156f:	c3                   	ret    

00801570 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801570:	55                   	push   %ebp
  801571:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801573:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801577:	77 39                	ja     8015b2 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	c1 e0 0c             	shl    $0xc,%eax
  80157f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801584:	89 c2                	mov    %eax,%edx
  801586:	c1 ea 16             	shr    $0x16,%edx
  801589:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801590:	f6 c2 01             	test   $0x1,%dl
  801593:	74 24                	je     8015b9 <fd_lookup+0x49>
  801595:	89 c2                	mov    %eax,%edx
  801597:	c1 ea 0c             	shr    $0xc,%edx
  80159a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015a1:	f6 c2 01             	test   $0x1,%dl
  8015a4:	74 1a                	je     8015c0 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8015ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b0:	5d                   	pop    %ebp
  8015b1:	c3                   	ret    
		return -E_INVAL;
  8015b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b7:	eb f7                	jmp    8015b0 <fd_lookup+0x40>
		return -E_INVAL;
  8015b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015be:	eb f0                	jmp    8015b0 <fd_lookup+0x40>
  8015c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015c5:	eb e9                	jmp    8015b0 <fd_lookup+0x40>

008015c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 08             	sub    $0x8,%esp
  8015cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015d0:	ba a8 2f 80 00       	mov    $0x802fa8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015d5:	b8 04 40 80 00       	mov    $0x804004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015da:	39 08                	cmp    %ecx,(%eax)
  8015dc:	74 33                	je     801611 <dev_lookup+0x4a>
  8015de:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8015e1:	8b 02                	mov    (%edx),%eax
  8015e3:	85 c0                	test   %eax,%eax
  8015e5:	75 f3                	jne    8015da <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015e7:	a1 04 60 80 00       	mov    0x806004,%eax
  8015ec:	8b 40 48             	mov    0x48(%eax),%eax
  8015ef:	83 ec 04             	sub    $0x4,%esp
  8015f2:	51                   	push   %ecx
  8015f3:	50                   	push   %eax
  8015f4:	68 2c 2f 80 00       	push   $0x802f2c
  8015f9:	e8 8a f2 ff ff       	call   800888 <cprintf>
	*dev = 0;
  8015fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801601:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801607:	83 c4 10             	add    $0x10,%esp
  80160a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80160f:	c9                   	leave  
  801610:	c3                   	ret    
			*dev = devtab[i];
  801611:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801614:	89 01                	mov    %eax,(%ecx)
			return 0;
  801616:	b8 00 00 00 00       	mov    $0x0,%eax
  80161b:	eb f2                	jmp    80160f <dev_lookup+0x48>

0080161d <fd_close>:
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	57                   	push   %edi
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	83 ec 1c             	sub    $0x1c,%esp
  801626:	8b 75 08             	mov    0x8(%ebp),%esi
  801629:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80162c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80162f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801630:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801636:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801639:	50                   	push   %eax
  80163a:	e8 31 ff ff ff       	call   801570 <fd_lookup>
  80163f:	89 c7                	mov    %eax,%edi
  801641:	83 c4 08             	add    $0x8,%esp
  801644:	85 c0                	test   %eax,%eax
  801646:	78 05                	js     80164d <fd_close+0x30>
	    || fd != fd2)
  801648:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80164b:	74 13                	je     801660 <fd_close+0x43>
		return (must_exist ? r : 0);
  80164d:	84 db                	test   %bl,%bl
  80164f:	75 05                	jne    801656 <fd_close+0x39>
  801651:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801656:	89 f8                	mov    %edi,%eax
  801658:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165b:	5b                   	pop    %ebx
  80165c:	5e                   	pop    %esi
  80165d:	5f                   	pop    %edi
  80165e:	5d                   	pop    %ebp
  80165f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801660:	83 ec 08             	sub    $0x8,%esp
  801663:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801666:	50                   	push   %eax
  801667:	ff 36                	pushl  (%esi)
  801669:	e8 59 ff ff ff       	call   8015c7 <dev_lookup>
  80166e:	89 c7                	mov    %eax,%edi
  801670:	83 c4 10             	add    $0x10,%esp
  801673:	85 c0                	test   %eax,%eax
  801675:	78 15                	js     80168c <fd_close+0x6f>
		if (dev->dev_close)
  801677:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80167a:	8b 40 10             	mov    0x10(%eax),%eax
  80167d:	85 c0                	test   %eax,%eax
  80167f:	74 1b                	je     80169c <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	56                   	push   %esi
  801685:	ff d0                	call   *%eax
  801687:	89 c7                	mov    %eax,%edi
  801689:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	56                   	push   %esi
  801690:	6a 00                	push   $0x0
  801692:	e8 33 fc ff ff       	call   8012ca <sys_page_unmap>
	return r;
  801697:	83 c4 10             	add    $0x10,%esp
  80169a:	eb ba                	jmp    801656 <fd_close+0x39>
			r = 0;
  80169c:	bf 00 00 00 00       	mov    $0x0,%edi
  8016a1:	eb e9                	jmp    80168c <fd_close+0x6f>

008016a3 <close>:

int
close(int fdnum)
{
  8016a3:	55                   	push   %ebp
  8016a4:	89 e5                	mov    %esp,%ebp
  8016a6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ac:	50                   	push   %eax
  8016ad:	ff 75 08             	pushl  0x8(%ebp)
  8016b0:	e8 bb fe ff ff       	call   801570 <fd_lookup>
  8016b5:	83 c4 08             	add    $0x8,%esp
  8016b8:	85 c0                	test   %eax,%eax
  8016ba:	78 10                	js     8016cc <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8016bc:	83 ec 08             	sub    $0x8,%esp
  8016bf:	6a 01                	push   $0x1
  8016c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8016c4:	e8 54 ff ff ff       	call   80161d <fd_close>
  8016c9:	83 c4 10             	add    $0x10,%esp
}
  8016cc:	c9                   	leave  
  8016cd:	c3                   	ret    

008016ce <close_all>:

void
close_all(void)
{
  8016ce:	55                   	push   %ebp
  8016cf:	89 e5                	mov    %esp,%ebp
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016da:	83 ec 0c             	sub    $0xc,%esp
  8016dd:	53                   	push   %ebx
  8016de:	e8 c0 ff ff ff       	call   8016a3 <close>
	for (i = 0; i < MAXFD; i++)
  8016e3:	43                   	inc    %ebx
  8016e4:	83 c4 10             	add    $0x10,%esp
  8016e7:	83 fb 20             	cmp    $0x20,%ebx
  8016ea:	75 ee                	jne    8016da <close_all+0xc>
}
  8016ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ef:	c9                   	leave  
  8016f0:	c3                   	ret    

008016f1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8016f1:	55                   	push   %ebp
  8016f2:	89 e5                	mov    %esp,%ebp
  8016f4:	57                   	push   %edi
  8016f5:	56                   	push   %esi
  8016f6:	53                   	push   %ebx
  8016f7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8016fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016fd:	50                   	push   %eax
  8016fe:	ff 75 08             	pushl  0x8(%ebp)
  801701:	e8 6a fe ff ff       	call   801570 <fd_lookup>
  801706:	89 c3                	mov    %eax,%ebx
  801708:	83 c4 08             	add    $0x8,%esp
  80170b:	85 c0                	test   %eax,%eax
  80170d:	0f 88 81 00 00 00    	js     801794 <dup+0xa3>
		return r;
	close(newfdnum);
  801713:	83 ec 0c             	sub    $0xc,%esp
  801716:	ff 75 0c             	pushl  0xc(%ebp)
  801719:	e8 85 ff ff ff       	call   8016a3 <close>

	newfd = INDEX2FD(newfdnum);
  80171e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801721:	c1 e6 0c             	shl    $0xc,%esi
  801724:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80172a:	83 c4 04             	add    $0x4,%esp
  80172d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801730:	e8 d5 fd ff ff       	call   80150a <fd2data>
  801735:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801737:	89 34 24             	mov    %esi,(%esp)
  80173a:	e8 cb fd ff ff       	call   80150a <fd2data>
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801744:	89 d8                	mov    %ebx,%eax
  801746:	c1 e8 16             	shr    $0x16,%eax
  801749:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801750:	a8 01                	test   $0x1,%al
  801752:	74 11                	je     801765 <dup+0x74>
  801754:	89 d8                	mov    %ebx,%eax
  801756:	c1 e8 0c             	shr    $0xc,%eax
  801759:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801760:	f6 c2 01             	test   $0x1,%dl
  801763:	75 39                	jne    80179e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801765:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801768:	89 d0                	mov    %edx,%eax
  80176a:	c1 e8 0c             	shr    $0xc,%eax
  80176d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801774:	83 ec 0c             	sub    $0xc,%esp
  801777:	25 07 0e 00 00       	and    $0xe07,%eax
  80177c:	50                   	push   %eax
  80177d:	56                   	push   %esi
  80177e:	6a 00                	push   $0x0
  801780:	52                   	push   %edx
  801781:	6a 00                	push   $0x0
  801783:	e8 00 fb ff ff       	call   801288 <sys_page_map>
  801788:	89 c3                	mov    %eax,%ebx
  80178a:	83 c4 20             	add    $0x20,%esp
  80178d:	85 c0                	test   %eax,%eax
  80178f:	78 31                	js     8017c2 <dup+0xd1>
		goto err;

	return newfdnum;
  801791:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801794:	89 d8                	mov    %ebx,%eax
  801796:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801799:	5b                   	pop    %ebx
  80179a:	5e                   	pop    %esi
  80179b:	5f                   	pop    %edi
  80179c:	5d                   	pop    %ebp
  80179d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80179e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017a5:	83 ec 0c             	sub    $0xc,%esp
  8017a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8017ad:	50                   	push   %eax
  8017ae:	57                   	push   %edi
  8017af:	6a 00                	push   $0x0
  8017b1:	53                   	push   %ebx
  8017b2:	6a 00                	push   $0x0
  8017b4:	e8 cf fa ff ff       	call   801288 <sys_page_map>
  8017b9:	89 c3                	mov    %eax,%ebx
  8017bb:	83 c4 20             	add    $0x20,%esp
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	79 a3                	jns    801765 <dup+0x74>
	sys_page_unmap(0, newfd);
  8017c2:	83 ec 08             	sub    $0x8,%esp
  8017c5:	56                   	push   %esi
  8017c6:	6a 00                	push   $0x0
  8017c8:	e8 fd fa ff ff       	call   8012ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017cd:	83 c4 08             	add    $0x8,%esp
  8017d0:	57                   	push   %edi
  8017d1:	6a 00                	push   $0x0
  8017d3:	e8 f2 fa ff ff       	call   8012ca <sys_page_unmap>
	return r;
  8017d8:	83 c4 10             	add    $0x10,%esp
  8017db:	eb b7                	jmp    801794 <dup+0xa3>

008017dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
  8017e0:	53                   	push   %ebx
  8017e1:	83 ec 14             	sub    $0x14,%esp
  8017e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017ea:	50                   	push   %eax
  8017eb:	53                   	push   %ebx
  8017ec:	e8 7f fd ff ff       	call   801570 <fd_lookup>
  8017f1:	83 c4 08             	add    $0x8,%esp
  8017f4:	85 c0                	test   %eax,%eax
  8017f6:	78 3f                	js     801837 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017f8:	83 ec 08             	sub    $0x8,%esp
  8017fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017fe:	50                   	push   %eax
  8017ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801802:	ff 30                	pushl  (%eax)
  801804:	e8 be fd ff ff       	call   8015c7 <dev_lookup>
  801809:	83 c4 10             	add    $0x10,%esp
  80180c:	85 c0                	test   %eax,%eax
  80180e:	78 27                	js     801837 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801810:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801813:	8b 42 08             	mov    0x8(%edx),%eax
  801816:	83 e0 03             	and    $0x3,%eax
  801819:	83 f8 01             	cmp    $0x1,%eax
  80181c:	74 1e                	je     80183c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80181e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801821:	8b 40 08             	mov    0x8(%eax),%eax
  801824:	85 c0                	test   %eax,%eax
  801826:	74 35                	je     80185d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801828:	83 ec 04             	sub    $0x4,%esp
  80182b:	ff 75 10             	pushl  0x10(%ebp)
  80182e:	ff 75 0c             	pushl  0xc(%ebp)
  801831:	52                   	push   %edx
  801832:	ff d0                	call   *%eax
  801834:	83 c4 10             	add    $0x10,%esp
}
  801837:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80183c:	a1 04 60 80 00       	mov    0x806004,%eax
  801841:	8b 40 48             	mov    0x48(%eax),%eax
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	53                   	push   %ebx
  801848:	50                   	push   %eax
  801849:	68 6d 2f 80 00       	push   $0x802f6d
  80184e:	e8 35 f0 ff ff       	call   800888 <cprintf>
		return -E_INVAL;
  801853:	83 c4 10             	add    $0x10,%esp
  801856:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80185b:	eb da                	jmp    801837 <read+0x5a>
		return -E_NOT_SUPP;
  80185d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801862:	eb d3                	jmp    801837 <read+0x5a>

00801864 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	57                   	push   %edi
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	83 ec 0c             	sub    $0xc,%esp
  80186d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801870:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801873:	bb 00 00 00 00       	mov    $0x0,%ebx
  801878:	39 f3                	cmp    %esi,%ebx
  80187a:	73 25                	jae    8018a1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80187c:	83 ec 04             	sub    $0x4,%esp
  80187f:	89 f0                	mov    %esi,%eax
  801881:	29 d8                	sub    %ebx,%eax
  801883:	50                   	push   %eax
  801884:	89 d8                	mov    %ebx,%eax
  801886:	03 45 0c             	add    0xc(%ebp),%eax
  801889:	50                   	push   %eax
  80188a:	57                   	push   %edi
  80188b:	e8 4d ff ff ff       	call   8017dd <read>
		if (m < 0)
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	85 c0                	test   %eax,%eax
  801895:	78 08                	js     80189f <readn+0x3b>
			return m;
		if (m == 0)
  801897:	85 c0                	test   %eax,%eax
  801899:	74 06                	je     8018a1 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80189b:	01 c3                	add    %eax,%ebx
  80189d:	eb d9                	jmp    801878 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80189f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018a1:	89 d8                	mov    %ebx,%eax
  8018a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5f                   	pop    %edi
  8018a9:	5d                   	pop    %ebp
  8018aa:	c3                   	ret    

008018ab <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	53                   	push   %ebx
  8018af:	83 ec 14             	sub    $0x14,%esp
  8018b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018b8:	50                   	push   %eax
  8018b9:	53                   	push   %ebx
  8018ba:	e8 b1 fc ff ff       	call   801570 <fd_lookup>
  8018bf:	83 c4 08             	add    $0x8,%esp
  8018c2:	85 c0                	test   %eax,%eax
  8018c4:	78 3a                	js     801900 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018c6:	83 ec 08             	sub    $0x8,%esp
  8018c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018cc:	50                   	push   %eax
  8018cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d0:	ff 30                	pushl  (%eax)
  8018d2:	e8 f0 fc ff ff       	call   8015c7 <dev_lookup>
  8018d7:	83 c4 10             	add    $0x10,%esp
  8018da:	85 c0                	test   %eax,%eax
  8018dc:	78 22                	js     801900 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018e5:	74 1e                	je     801905 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8018ed:	85 d2                	test   %edx,%edx
  8018ef:	74 35                	je     801926 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8018f1:	83 ec 04             	sub    $0x4,%esp
  8018f4:	ff 75 10             	pushl  0x10(%ebp)
  8018f7:	ff 75 0c             	pushl  0xc(%ebp)
  8018fa:	50                   	push   %eax
  8018fb:	ff d2                	call   *%edx
  8018fd:	83 c4 10             	add    $0x10,%esp
}
  801900:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801903:	c9                   	leave  
  801904:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801905:	a1 04 60 80 00       	mov    0x806004,%eax
  80190a:	8b 40 48             	mov    0x48(%eax),%eax
  80190d:	83 ec 04             	sub    $0x4,%esp
  801910:	53                   	push   %ebx
  801911:	50                   	push   %eax
  801912:	68 89 2f 80 00       	push   $0x802f89
  801917:	e8 6c ef ff ff       	call   800888 <cprintf>
		return -E_INVAL;
  80191c:	83 c4 10             	add    $0x10,%esp
  80191f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801924:	eb da                	jmp    801900 <write+0x55>
		return -E_NOT_SUPP;
  801926:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80192b:	eb d3                	jmp    801900 <write+0x55>

0080192d <seek>:

int
seek(int fdnum, off_t offset)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801933:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801936:	50                   	push   %eax
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	e8 31 fc ff ff       	call   801570 <fd_lookup>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 0e                	js     801954 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801946:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801949:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80194f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801954:	c9                   	leave  
  801955:	c3                   	ret    

00801956 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	53                   	push   %ebx
  80195a:	83 ec 14             	sub    $0x14,%esp
  80195d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801960:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801963:	50                   	push   %eax
  801964:	53                   	push   %ebx
  801965:	e8 06 fc ff ff       	call   801570 <fd_lookup>
  80196a:	83 c4 08             	add    $0x8,%esp
  80196d:	85 c0                	test   %eax,%eax
  80196f:	78 37                	js     8019a8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801971:	83 ec 08             	sub    $0x8,%esp
  801974:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801977:	50                   	push   %eax
  801978:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80197b:	ff 30                	pushl  (%eax)
  80197d:	e8 45 fc ff ff       	call   8015c7 <dev_lookup>
  801982:	83 c4 10             	add    $0x10,%esp
  801985:	85 c0                	test   %eax,%eax
  801987:	78 1f                	js     8019a8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801989:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80198c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801990:	74 1b                	je     8019ad <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801992:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801995:	8b 52 18             	mov    0x18(%edx),%edx
  801998:	85 d2                	test   %edx,%edx
  80199a:	74 32                	je     8019ce <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80199c:	83 ec 08             	sub    $0x8,%esp
  80199f:	ff 75 0c             	pushl  0xc(%ebp)
  8019a2:	50                   	push   %eax
  8019a3:	ff d2                	call   *%edx
  8019a5:	83 c4 10             	add    $0x10,%esp
}
  8019a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019ad:	a1 04 60 80 00       	mov    0x806004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019b2:	8b 40 48             	mov    0x48(%eax),%eax
  8019b5:	83 ec 04             	sub    $0x4,%esp
  8019b8:	53                   	push   %ebx
  8019b9:	50                   	push   %eax
  8019ba:	68 4c 2f 80 00       	push   $0x802f4c
  8019bf:	e8 c4 ee ff ff       	call   800888 <cprintf>
		return -E_INVAL;
  8019c4:	83 c4 10             	add    $0x10,%esp
  8019c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019cc:	eb da                	jmp    8019a8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019d3:	eb d3                	jmp    8019a8 <ftruncate+0x52>

008019d5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	53                   	push   %ebx
  8019d9:	83 ec 14             	sub    $0x14,%esp
  8019dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e2:	50                   	push   %eax
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	e8 85 fb ff ff       	call   801570 <fd_lookup>
  8019eb:	83 c4 08             	add    $0x8,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	78 4b                	js     801a3d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f2:	83 ec 08             	sub    $0x8,%esp
  8019f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fc:	ff 30                	pushl  (%eax)
  8019fe:	e8 c4 fb ff ff       	call   8015c7 <dev_lookup>
  801a03:	83 c4 10             	add    $0x10,%esp
  801a06:	85 c0                	test   %eax,%eax
  801a08:	78 33                	js     801a3d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a0d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a11:	74 2f                	je     801a42 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a13:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a16:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a1d:	00 00 00 
	stat->st_type = 0;
  801a20:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a27:	00 00 00 
	stat->st_dev = dev;
  801a2a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a30:	83 ec 08             	sub    $0x8,%esp
  801a33:	53                   	push   %ebx
  801a34:	ff 75 f0             	pushl  -0x10(%ebp)
  801a37:	ff 50 14             	call   *0x14(%eax)
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    
		return -E_NOT_SUPP;
  801a42:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a47:	eb f4                	jmp    801a3d <fstat+0x68>

00801a49 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
  801a4c:	56                   	push   %esi
  801a4d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a4e:	83 ec 08             	sub    $0x8,%esp
  801a51:	6a 00                	push   $0x0
  801a53:	ff 75 08             	pushl  0x8(%ebp)
  801a56:	e8 34 02 00 00       	call   801c8f <open>
  801a5b:	89 c3                	mov    %eax,%ebx
  801a5d:	83 c4 10             	add    $0x10,%esp
  801a60:	85 c0                	test   %eax,%eax
  801a62:	78 1b                	js     801a7f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a64:	83 ec 08             	sub    $0x8,%esp
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	50                   	push   %eax
  801a6b:	e8 65 ff ff ff       	call   8019d5 <fstat>
  801a70:	89 c6                	mov    %eax,%esi
	close(fd);
  801a72:	89 1c 24             	mov    %ebx,(%esp)
  801a75:	e8 29 fc ff ff       	call   8016a3 <close>
	return r;
  801a7a:	83 c4 10             	add    $0x10,%esp
  801a7d:	89 f3                	mov    %esi,%ebx
}
  801a7f:	89 d8                	mov    %ebx,%eax
  801a81:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a84:	5b                   	pop    %ebx
  801a85:	5e                   	pop    %esi
  801a86:	5d                   	pop    %ebp
  801a87:	c3                   	ret    

00801a88 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
  801a8b:	56                   	push   %esi
  801a8c:	53                   	push   %ebx
  801a8d:	89 c6                	mov    %eax,%esi
  801a8f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801a91:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801a98:	74 27                	je     801ac1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801a9a:	6a 07                	push   $0x7
  801a9c:	68 00 70 80 00       	push   $0x807000
  801aa1:	56                   	push   %esi
  801aa2:	ff 35 00 60 80 00    	pushl  0x806000
  801aa8:	e8 e1 07 00 00       	call   80228e <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801aad:	83 c4 0c             	add    $0xc,%esp
  801ab0:	6a 00                	push   $0x0
  801ab2:	53                   	push   %ebx
  801ab3:	6a 00                	push   $0x0
  801ab5:	e8 4b 07 00 00       	call   802205 <ipc_recv>
}
  801aba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abd:	5b                   	pop    %ebx
  801abe:	5e                   	pop    %esi
  801abf:	5d                   	pop    %ebp
  801ac0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ac1:	83 ec 0c             	sub    $0xc,%esp
  801ac4:	6a 01                	push   $0x1
  801ac6:	e8 1f 08 00 00       	call   8022ea <ipc_find_env>
  801acb:	a3 00 60 80 00       	mov    %eax,0x806000
  801ad0:	83 c4 10             	add    $0x10,%esp
  801ad3:	eb c5                	jmp    801a9a <fsipc+0x12>

00801ad5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801adb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ade:	8b 40 0c             	mov    0xc(%eax),%eax
  801ae1:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ae9:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801aee:	ba 00 00 00 00       	mov    $0x0,%edx
  801af3:	b8 02 00 00 00       	mov    $0x2,%eax
  801af8:	e8 8b ff ff ff       	call   801a88 <fsipc>
}
  801afd:	c9                   	leave  
  801afe:	c3                   	ret    

00801aff <devfile_flush>:
{
  801aff:	55                   	push   %ebp
  801b00:	89 e5                	mov    %esp,%ebp
  801b02:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b05:	8b 45 08             	mov    0x8(%ebp),%eax
  801b08:	8b 40 0c             	mov    0xc(%eax),%eax
  801b0b:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801b10:	ba 00 00 00 00       	mov    $0x0,%edx
  801b15:	b8 06 00 00 00       	mov    $0x6,%eax
  801b1a:	e8 69 ff ff ff       	call   801a88 <fsipc>
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <devfile_stat>:
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
  801b24:	53                   	push   %ebx
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b31:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b36:	ba 00 00 00 00       	mov    $0x0,%edx
  801b3b:	b8 05 00 00 00       	mov    $0x5,%eax
  801b40:	e8 43 ff ff ff       	call   801a88 <fsipc>
  801b45:	85 c0                	test   %eax,%eax
  801b47:	78 2c                	js     801b75 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b49:	83 ec 08             	sub    $0x8,%esp
  801b4c:	68 00 70 80 00       	push   $0x807000
  801b51:	53                   	push   %ebx
  801b52:	e8 39 f3 ff ff       	call   800e90 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b57:	a1 80 70 80 00       	mov    0x807080,%eax
  801b5c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801b62:	a1 84 70 80 00       	mov    0x807084,%eax
  801b67:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <devfile_write>:
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	53                   	push   %ebx
  801b7e:	83 ec 04             	sub    $0x4,%esp
  801b81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801b84:	89 d8                	mov    %ebx,%eax
  801b86:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801b8c:	76 05                	jbe    801b93 <devfile_write+0x19>
  801b8e:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801b93:	8b 55 08             	mov    0x8(%ebp),%edx
  801b96:	8b 52 0c             	mov    0xc(%edx),%edx
  801b99:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = size;
  801b9f:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801ba4:	83 ec 04             	sub    $0x4,%esp
  801ba7:	50                   	push   %eax
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	68 08 70 80 00       	push   $0x807008
  801bb0:	e8 4e f4 ff ff       	call   801003 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801bb5:	ba 00 00 00 00       	mov    $0x0,%edx
  801bba:	b8 04 00 00 00       	mov    $0x4,%eax
  801bbf:	e8 c4 fe ff ff       	call   801a88 <fsipc>
  801bc4:	83 c4 10             	add    $0x10,%esp
  801bc7:	85 c0                	test   %eax,%eax
  801bc9:	78 0b                	js     801bd6 <devfile_write+0x5c>
	assert(r <= n);
  801bcb:	39 c3                	cmp    %eax,%ebx
  801bcd:	72 0c                	jb     801bdb <devfile_write+0x61>
	assert(r <= PGSIZE);
  801bcf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bd4:	7f 1e                	jg     801bf4 <devfile_write+0x7a>
}
  801bd6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    
	assert(r <= n);
  801bdb:	68 b8 2f 80 00       	push   $0x802fb8
  801be0:	68 c9 25 80 00       	push   $0x8025c9
  801be5:	68 98 00 00 00       	push   $0x98
  801bea:	68 bf 2f 80 00       	push   $0x802fbf
  801bef:	e8 81 eb ff ff       	call   800775 <_panic>
	assert(r <= PGSIZE);
  801bf4:	68 ca 2f 80 00       	push   $0x802fca
  801bf9:	68 c9 25 80 00       	push   $0x8025c9
  801bfe:	68 99 00 00 00       	push   $0x99
  801c03:	68 bf 2f 80 00       	push   $0x802fbf
  801c08:	e8 68 eb ff ff       	call   800775 <_panic>

00801c0d <devfile_read>:
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
  801c10:	56                   	push   %esi
  801c11:	53                   	push   %ebx
  801c12:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c15:	8b 45 08             	mov    0x8(%ebp),%eax
  801c18:	8b 40 0c             	mov    0xc(%eax),%eax
  801c1b:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801c20:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c26:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2b:	b8 03 00 00 00       	mov    $0x3,%eax
  801c30:	e8 53 fe ff ff       	call   801a88 <fsipc>
  801c35:	89 c3                	mov    %eax,%ebx
  801c37:	85 c0                	test   %eax,%eax
  801c39:	78 1f                	js     801c5a <devfile_read+0x4d>
	assert(r <= n);
  801c3b:	39 c6                	cmp    %eax,%esi
  801c3d:	72 24                	jb     801c63 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c3f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c44:	7f 33                	jg     801c79 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c46:	83 ec 04             	sub    $0x4,%esp
  801c49:	50                   	push   %eax
  801c4a:	68 00 70 80 00       	push   $0x807000
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	e8 ac f3 ff ff       	call   801003 <memmove>
	return r;
  801c57:	83 c4 10             	add    $0x10,%esp
}
  801c5a:	89 d8                	mov    %ebx,%eax
  801c5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c5f:	5b                   	pop    %ebx
  801c60:	5e                   	pop    %esi
  801c61:	5d                   	pop    %ebp
  801c62:	c3                   	ret    
	assert(r <= n);
  801c63:	68 b8 2f 80 00       	push   $0x802fb8
  801c68:	68 c9 25 80 00       	push   $0x8025c9
  801c6d:	6a 7c                	push   $0x7c
  801c6f:	68 bf 2f 80 00       	push   $0x802fbf
  801c74:	e8 fc ea ff ff       	call   800775 <_panic>
	assert(r <= PGSIZE);
  801c79:	68 ca 2f 80 00       	push   $0x802fca
  801c7e:	68 c9 25 80 00       	push   $0x8025c9
  801c83:	6a 7d                	push   $0x7d
  801c85:	68 bf 2f 80 00       	push   $0x802fbf
  801c8a:	e8 e6 ea ff ff       	call   800775 <_panic>

00801c8f <open>:
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	56                   	push   %esi
  801c93:	53                   	push   %ebx
  801c94:	83 ec 1c             	sub    $0x1c,%esp
  801c97:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801c9a:	56                   	push   %esi
  801c9b:	e8 bd f1 ff ff       	call   800e5d <strlen>
  801ca0:	83 c4 10             	add    $0x10,%esp
  801ca3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801ca8:	7f 6c                	jg     801d16 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801caa:	83 ec 0c             	sub    $0xc,%esp
  801cad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cb0:	50                   	push   %eax
  801cb1:	e8 6b f8 ff ff       	call   801521 <fd_alloc>
  801cb6:	89 c3                	mov    %eax,%ebx
  801cb8:	83 c4 10             	add    $0x10,%esp
  801cbb:	85 c0                	test   %eax,%eax
  801cbd:	78 3c                	js     801cfb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cbf:	83 ec 08             	sub    $0x8,%esp
  801cc2:	56                   	push   %esi
  801cc3:	68 00 70 80 00       	push   $0x807000
  801cc8:	e8 c3 f1 ff ff       	call   800e90 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ccd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cd0:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801cd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cd8:	b8 01 00 00 00       	mov    $0x1,%eax
  801cdd:	e8 a6 fd ff ff       	call   801a88 <fsipc>
  801ce2:	89 c3                	mov    %eax,%ebx
  801ce4:	83 c4 10             	add    $0x10,%esp
  801ce7:	85 c0                	test   %eax,%eax
  801ce9:	78 19                	js     801d04 <open+0x75>
	return fd2num(fd);
  801ceb:	83 ec 0c             	sub    $0xc,%esp
  801cee:	ff 75 f4             	pushl  -0xc(%ebp)
  801cf1:	e8 04 f8 ff ff       	call   8014fa <fd2num>
  801cf6:	89 c3                	mov    %eax,%ebx
  801cf8:	83 c4 10             	add    $0x10,%esp
}
  801cfb:	89 d8                	mov    %ebx,%eax
  801cfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d00:	5b                   	pop    %ebx
  801d01:	5e                   	pop    %esi
  801d02:	5d                   	pop    %ebp
  801d03:	c3                   	ret    
		fd_close(fd, 0);
  801d04:	83 ec 08             	sub    $0x8,%esp
  801d07:	6a 00                	push   $0x0
  801d09:	ff 75 f4             	pushl  -0xc(%ebp)
  801d0c:	e8 0c f9 ff ff       	call   80161d <fd_close>
		return r;
  801d11:	83 c4 10             	add    $0x10,%esp
  801d14:	eb e5                	jmp    801cfb <open+0x6c>
		return -E_BAD_PATH;
  801d16:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d1b:	eb de                	jmp    801cfb <open+0x6c>

00801d1d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d1d:	55                   	push   %ebp
  801d1e:	89 e5                	mov    %esp,%ebp
  801d20:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d23:	ba 00 00 00 00       	mov    $0x0,%edx
  801d28:	b8 08 00 00 00       	mov    $0x8,%eax
  801d2d:	e8 56 fd ff ff       	call   801a88 <fsipc>
}
  801d32:	c9                   	leave  
  801d33:	c3                   	ret    

00801d34 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801d34:	55                   	push   %ebp
  801d35:	89 e5                	mov    %esp,%ebp
  801d37:	56                   	push   %esi
  801d38:	53                   	push   %ebx
  801d39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	ff 75 08             	pushl  0x8(%ebp)
  801d42:	e8 c3 f7 ff ff       	call   80150a <fd2data>
  801d47:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801d49:	83 c4 08             	add    $0x8,%esp
  801d4c:	68 d6 2f 80 00       	push   $0x802fd6
  801d51:	53                   	push   %ebx
  801d52:	e8 39 f1 ff ff       	call   800e90 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801d57:	8b 46 04             	mov    0x4(%esi),%eax
  801d5a:	2b 06                	sub    (%esi),%eax
  801d5c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801d62:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801d69:	10 00 00 
	stat->st_dev = &devpipe;
  801d6c:	c7 83 88 00 00 00 20 	movl   $0x804020,0x88(%ebx)
  801d73:	40 80 00 
	return 0;
}
  801d76:	b8 00 00 00 00       	mov    $0x0,%eax
  801d7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d7e:	5b                   	pop    %ebx
  801d7f:	5e                   	pop    %esi
  801d80:	5d                   	pop    %ebp
  801d81:	c3                   	ret    

00801d82 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	53                   	push   %ebx
  801d86:	83 ec 0c             	sub    $0xc,%esp
  801d89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801d8c:	53                   	push   %ebx
  801d8d:	6a 00                	push   $0x0
  801d8f:	e8 36 f5 ff ff       	call   8012ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801d94:	89 1c 24             	mov    %ebx,(%esp)
  801d97:	e8 6e f7 ff ff       	call   80150a <fd2data>
  801d9c:	83 c4 08             	add    $0x8,%esp
  801d9f:	50                   	push   %eax
  801da0:	6a 00                	push   $0x0
  801da2:	e8 23 f5 ff ff       	call   8012ca <sys_page_unmap>
}
  801da7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <_pipeisclosed>:
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
  801daf:	57                   	push   %edi
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
  801db2:	83 ec 1c             	sub    $0x1c,%esp
  801db5:	89 c7                	mov    %eax,%edi
  801db7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801db9:	a1 04 60 80 00       	mov    0x806004,%eax
  801dbe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801dc1:	83 ec 0c             	sub    $0xc,%esp
  801dc4:	57                   	push   %edi
  801dc5:	e8 62 05 00 00       	call   80232c <pageref>
  801dca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801dcd:	89 34 24             	mov    %esi,(%esp)
  801dd0:	e8 57 05 00 00       	call   80232c <pageref>
		nn = thisenv->env_runs;
  801dd5:	8b 15 04 60 80 00    	mov    0x806004,%edx
  801ddb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801dde:	83 c4 10             	add    $0x10,%esp
  801de1:	39 cb                	cmp    %ecx,%ebx
  801de3:	74 1b                	je     801e00 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801de5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801de8:	75 cf                	jne    801db9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801dea:	8b 42 58             	mov    0x58(%edx),%eax
  801ded:	6a 01                	push   $0x1
  801def:	50                   	push   %eax
  801df0:	53                   	push   %ebx
  801df1:	68 dd 2f 80 00       	push   $0x802fdd
  801df6:	e8 8d ea ff ff       	call   800888 <cprintf>
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	eb b9                	jmp    801db9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e00:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e03:	0f 94 c0             	sete   %al
  801e06:	0f b6 c0             	movzbl %al,%eax
}
  801e09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5f                   	pop    %edi
  801e0f:	5d                   	pop    %ebp
  801e10:	c3                   	ret    

00801e11 <devpipe_write>:
{
  801e11:	55                   	push   %ebp
  801e12:	89 e5                	mov    %esp,%ebp
  801e14:	57                   	push   %edi
  801e15:	56                   	push   %esi
  801e16:	53                   	push   %ebx
  801e17:	83 ec 18             	sub    $0x18,%esp
  801e1a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e1d:	56                   	push   %esi
  801e1e:	e8 e7 f6 ff ff       	call   80150a <fd2data>
  801e23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	bf 00 00 00 00       	mov    $0x0,%edi
  801e2d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801e30:	74 41                	je     801e73 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801e32:	8b 53 04             	mov    0x4(%ebx),%edx
  801e35:	8b 03                	mov    (%ebx),%eax
  801e37:	83 c0 20             	add    $0x20,%eax
  801e3a:	39 c2                	cmp    %eax,%edx
  801e3c:	72 14                	jb     801e52 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801e3e:	89 da                	mov    %ebx,%edx
  801e40:	89 f0                	mov    %esi,%eax
  801e42:	e8 65 ff ff ff       	call   801dac <_pipeisclosed>
  801e47:	85 c0                	test   %eax,%eax
  801e49:	75 2c                	jne    801e77 <devpipe_write+0x66>
			sys_yield();
  801e4b:	e8 bc f4 ff ff       	call   80130c <sys_yield>
  801e50:	eb e0                	jmp    801e32 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e52:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e55:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801e58:	89 d0                	mov    %edx,%eax
  801e5a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801e5f:	78 0b                	js     801e6c <devpipe_write+0x5b>
  801e61:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801e65:	42                   	inc    %edx
  801e66:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801e69:	47                   	inc    %edi
  801e6a:	eb c1                	jmp    801e2d <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801e6c:	48                   	dec    %eax
  801e6d:	83 c8 e0             	or     $0xffffffe0,%eax
  801e70:	40                   	inc    %eax
  801e71:	eb ee                	jmp    801e61 <devpipe_write+0x50>
	return i;
  801e73:	89 f8                	mov    %edi,%eax
  801e75:	eb 05                	jmp    801e7c <devpipe_write+0x6b>
				return 0;
  801e77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e7f:	5b                   	pop    %ebx
  801e80:	5e                   	pop    %esi
  801e81:	5f                   	pop    %edi
  801e82:	5d                   	pop    %ebp
  801e83:	c3                   	ret    

00801e84 <devpipe_read>:
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
  801e87:	57                   	push   %edi
  801e88:	56                   	push   %esi
  801e89:	53                   	push   %ebx
  801e8a:	83 ec 18             	sub    $0x18,%esp
  801e8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801e90:	57                   	push   %edi
  801e91:	e8 74 f6 ff ff       	call   80150a <fd2data>
  801e96:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801e98:	83 c4 10             	add    $0x10,%esp
  801e9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801ea0:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ea3:	74 46                	je     801eeb <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801ea5:	8b 06                	mov    (%esi),%eax
  801ea7:	3b 46 04             	cmp    0x4(%esi),%eax
  801eaa:	75 22                	jne    801ece <devpipe_read+0x4a>
			if (i > 0)
  801eac:	85 db                	test   %ebx,%ebx
  801eae:	74 0a                	je     801eba <devpipe_read+0x36>
				return i;
  801eb0:	89 d8                	mov    %ebx,%eax
}
  801eb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb5:	5b                   	pop    %ebx
  801eb6:	5e                   	pop    %esi
  801eb7:	5f                   	pop    %edi
  801eb8:	5d                   	pop    %ebp
  801eb9:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801eba:	89 f2                	mov    %esi,%edx
  801ebc:	89 f8                	mov    %edi,%eax
  801ebe:	e8 e9 fe ff ff       	call   801dac <_pipeisclosed>
  801ec3:	85 c0                	test   %eax,%eax
  801ec5:	75 28                	jne    801eef <devpipe_read+0x6b>
			sys_yield();
  801ec7:	e8 40 f4 ff ff       	call   80130c <sys_yield>
  801ecc:	eb d7                	jmp    801ea5 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ece:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801ed3:	78 0f                	js     801ee4 <devpipe_read+0x60>
  801ed5:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801ed9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801edc:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801edf:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801ee1:	43                   	inc    %ebx
  801ee2:	eb bc                	jmp    801ea0 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801ee4:	48                   	dec    %eax
  801ee5:	83 c8 e0             	or     $0xffffffe0,%eax
  801ee8:	40                   	inc    %eax
  801ee9:	eb ea                	jmp    801ed5 <devpipe_read+0x51>
	return i;
  801eeb:	89 d8                	mov    %ebx,%eax
  801eed:	eb c3                	jmp    801eb2 <devpipe_read+0x2e>
				return 0;
  801eef:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef4:	eb bc                	jmp    801eb2 <devpipe_read+0x2e>

00801ef6 <pipe>:
{
  801ef6:	55                   	push   %ebp
  801ef7:	89 e5                	mov    %esp,%ebp
  801ef9:	56                   	push   %esi
  801efa:	53                   	push   %ebx
  801efb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801efe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f01:	50                   	push   %eax
  801f02:	e8 1a f6 ff ff       	call   801521 <fd_alloc>
  801f07:	89 c3                	mov    %eax,%ebx
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	0f 88 2a 01 00 00    	js     80203e <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f14:	83 ec 04             	sub    $0x4,%esp
  801f17:	68 07 04 00 00       	push   $0x407
  801f1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f1f:	6a 00                	push   $0x0
  801f21:	e8 1f f3 ff ff       	call   801245 <sys_page_alloc>
  801f26:	89 c3                	mov    %eax,%ebx
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	0f 88 0b 01 00 00    	js     80203e <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801f39:	50                   	push   %eax
  801f3a:	e8 e2 f5 ff ff       	call   801521 <fd_alloc>
  801f3f:	89 c3                	mov    %eax,%ebx
  801f41:	83 c4 10             	add    $0x10,%esp
  801f44:	85 c0                	test   %eax,%eax
  801f46:	0f 88 e2 00 00 00    	js     80202e <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f4c:	83 ec 04             	sub    $0x4,%esp
  801f4f:	68 07 04 00 00       	push   $0x407
  801f54:	ff 75 f0             	pushl  -0x10(%ebp)
  801f57:	6a 00                	push   $0x0
  801f59:	e8 e7 f2 ff ff       	call   801245 <sys_page_alloc>
  801f5e:	89 c3                	mov    %eax,%ebx
  801f60:	83 c4 10             	add    $0x10,%esp
  801f63:	85 c0                	test   %eax,%eax
  801f65:	0f 88 c3 00 00 00    	js     80202e <pipe+0x138>
	va = fd2data(fd0);
  801f6b:	83 ec 0c             	sub    $0xc,%esp
  801f6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f71:	e8 94 f5 ff ff       	call   80150a <fd2data>
  801f76:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f78:	83 c4 0c             	add    $0xc,%esp
  801f7b:	68 07 04 00 00       	push   $0x407
  801f80:	50                   	push   %eax
  801f81:	6a 00                	push   $0x0
  801f83:	e8 bd f2 ff ff       	call   801245 <sys_page_alloc>
  801f88:	89 c3                	mov    %eax,%ebx
  801f8a:	83 c4 10             	add    $0x10,%esp
  801f8d:	85 c0                	test   %eax,%eax
  801f8f:	0f 88 89 00 00 00    	js     80201e <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	ff 75 f0             	pushl  -0x10(%ebp)
  801f9b:	e8 6a f5 ff ff       	call   80150a <fd2data>
  801fa0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801fa7:	50                   	push   %eax
  801fa8:	6a 00                	push   $0x0
  801faa:	56                   	push   %esi
  801fab:	6a 00                	push   $0x0
  801fad:	e8 d6 f2 ff ff       	call   801288 <sys_page_map>
  801fb2:	89 c3                	mov    %eax,%ebx
  801fb4:	83 c4 20             	add    $0x20,%esp
  801fb7:	85 c0                	test   %eax,%eax
  801fb9:	78 55                	js     802010 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801fbb:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fc9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801fd0:	8b 15 20 40 80 00    	mov    0x804020,%edx
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801fe5:	83 ec 0c             	sub    $0xc,%esp
  801fe8:	ff 75 f4             	pushl  -0xc(%ebp)
  801feb:	e8 0a f5 ff ff       	call   8014fa <fd2num>
  801ff0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ff3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ff5:	83 c4 04             	add    $0x4,%esp
  801ff8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ffb:	e8 fa f4 ff ff       	call   8014fa <fd2num>
  802000:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802003:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802006:	83 c4 10             	add    $0x10,%esp
  802009:	bb 00 00 00 00       	mov    $0x0,%ebx
  80200e:	eb 2e                	jmp    80203e <pipe+0x148>
	sys_page_unmap(0, va);
  802010:	83 ec 08             	sub    $0x8,%esp
  802013:	56                   	push   %esi
  802014:	6a 00                	push   $0x0
  802016:	e8 af f2 ff ff       	call   8012ca <sys_page_unmap>
  80201b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80201e:	83 ec 08             	sub    $0x8,%esp
  802021:	ff 75 f0             	pushl  -0x10(%ebp)
  802024:	6a 00                	push   $0x0
  802026:	e8 9f f2 ff ff       	call   8012ca <sys_page_unmap>
  80202b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80202e:	83 ec 08             	sub    $0x8,%esp
  802031:	ff 75 f4             	pushl  -0xc(%ebp)
  802034:	6a 00                	push   $0x0
  802036:	e8 8f f2 ff ff       	call   8012ca <sys_page_unmap>
  80203b:	83 c4 10             	add    $0x10,%esp
}
  80203e:	89 d8                	mov    %ebx,%eax
  802040:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802043:	5b                   	pop    %ebx
  802044:	5e                   	pop    %esi
  802045:	5d                   	pop    %ebp
  802046:	c3                   	ret    

00802047 <pipeisclosed>:
{
  802047:	55                   	push   %ebp
  802048:	89 e5                	mov    %esp,%ebp
  80204a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80204d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802050:	50                   	push   %eax
  802051:	ff 75 08             	pushl  0x8(%ebp)
  802054:	e8 17 f5 ff ff       	call   801570 <fd_lookup>
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	85 c0                	test   %eax,%eax
  80205e:	78 18                	js     802078 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802060:	83 ec 0c             	sub    $0xc,%esp
  802063:	ff 75 f4             	pushl  -0xc(%ebp)
  802066:	e8 9f f4 ff ff       	call   80150a <fd2data>
	return _pipeisclosed(fd, p);
  80206b:	89 c2                	mov    %eax,%edx
  80206d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802070:	e8 37 fd ff ff       	call   801dac <_pipeisclosed>
  802075:	83 c4 10             	add    $0x10,%esp
}
  802078:	c9                   	leave  
  802079:	c3                   	ret    

0080207a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80207a:	55                   	push   %ebp
  80207b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    

00802084 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
  802087:	53                   	push   %ebx
  802088:	83 ec 0c             	sub    $0xc,%esp
  80208b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80208e:	68 f5 2f 80 00       	push   $0x802ff5
  802093:	53                   	push   %ebx
  802094:	e8 f7 ed ff ff       	call   800e90 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  802099:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8020a0:	20 00 00 
	return 0;
}
  8020a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ab:	c9                   	leave  
  8020ac:	c3                   	ret    

008020ad <devcons_write>:
{
  8020ad:	55                   	push   %ebp
  8020ae:	89 e5                	mov    %esp,%ebp
  8020b0:	57                   	push   %edi
  8020b1:	56                   	push   %esi
  8020b2:	53                   	push   %ebx
  8020b3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8020b9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8020be:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8020c4:	eb 1d                	jmp    8020e3 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8020c6:	83 ec 04             	sub    $0x4,%esp
  8020c9:	53                   	push   %ebx
  8020ca:	03 45 0c             	add    0xc(%ebp),%eax
  8020cd:	50                   	push   %eax
  8020ce:	57                   	push   %edi
  8020cf:	e8 2f ef ff ff       	call   801003 <memmove>
		sys_cputs(buf, m);
  8020d4:	83 c4 08             	add    $0x8,%esp
  8020d7:	53                   	push   %ebx
  8020d8:	57                   	push   %edi
  8020d9:	e8 ca f0 ff ff       	call   8011a8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8020de:	01 de                	add    %ebx,%esi
  8020e0:	83 c4 10             	add    $0x10,%esp
  8020e3:	89 f0                	mov    %esi,%eax
  8020e5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8020e8:	73 11                	jae    8020fb <devcons_write+0x4e>
		m = n - tot;
  8020ea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8020ed:	29 f3                	sub    %esi,%ebx
  8020ef:	83 fb 7f             	cmp    $0x7f,%ebx
  8020f2:	76 d2                	jbe    8020c6 <devcons_write+0x19>
  8020f4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8020f9:	eb cb                	jmp    8020c6 <devcons_write+0x19>
}
  8020fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fe:	5b                   	pop    %ebx
  8020ff:	5e                   	pop    %esi
  802100:	5f                   	pop    %edi
  802101:	5d                   	pop    %ebp
  802102:	c3                   	ret    

00802103 <devcons_read>:
{
  802103:	55                   	push   %ebp
  802104:	89 e5                	mov    %esp,%ebp
  802106:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  802109:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210d:	75 0c                	jne    80211b <devcons_read+0x18>
		return 0;
  80210f:	b8 00 00 00 00       	mov    $0x0,%eax
  802114:	eb 21                	jmp    802137 <devcons_read+0x34>
		sys_yield();
  802116:	e8 f1 f1 ff ff       	call   80130c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80211b:	e8 a6 f0 ff ff       	call   8011c6 <sys_cgetc>
  802120:	85 c0                	test   %eax,%eax
  802122:	74 f2                	je     802116 <devcons_read+0x13>
	if (c < 0)
  802124:	85 c0                	test   %eax,%eax
  802126:	78 0f                	js     802137 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  802128:	83 f8 04             	cmp    $0x4,%eax
  80212b:	74 0c                	je     802139 <devcons_read+0x36>
	*(char*)vbuf = c;
  80212d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802130:	88 02                	mov    %al,(%edx)
	return 1;
  802132:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802137:	c9                   	leave  
  802138:	c3                   	ret    
		return 0;
  802139:	b8 00 00 00 00       	mov    $0x0,%eax
  80213e:	eb f7                	jmp    802137 <devcons_read+0x34>

00802140 <cputchar>:
{
  802140:	55                   	push   %ebp
  802141:	89 e5                	mov    %esp,%ebp
  802143:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802146:	8b 45 08             	mov    0x8(%ebp),%eax
  802149:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80214c:	6a 01                	push   $0x1
  80214e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802151:	50                   	push   %eax
  802152:	e8 51 f0 ff ff       	call   8011a8 <sys_cputs>
}
  802157:	83 c4 10             	add    $0x10,%esp
  80215a:	c9                   	leave  
  80215b:	c3                   	ret    

0080215c <getchar>:
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
  80215f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802162:	6a 01                	push   $0x1
  802164:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802167:	50                   	push   %eax
  802168:	6a 00                	push   $0x0
  80216a:	e8 6e f6 ff ff       	call   8017dd <read>
	if (r < 0)
  80216f:	83 c4 10             	add    $0x10,%esp
  802172:	85 c0                	test   %eax,%eax
  802174:	78 08                	js     80217e <getchar+0x22>
	if (r < 1)
  802176:	85 c0                	test   %eax,%eax
  802178:	7e 06                	jle    802180 <getchar+0x24>
	return c;
  80217a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80217e:	c9                   	leave  
  80217f:	c3                   	ret    
		return -E_EOF;
  802180:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802185:	eb f7                	jmp    80217e <getchar+0x22>

00802187 <iscons>:
{
  802187:	55                   	push   %ebp
  802188:	89 e5                	mov    %esp,%ebp
  80218a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80218d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802190:	50                   	push   %eax
  802191:	ff 75 08             	pushl  0x8(%ebp)
  802194:	e8 d7 f3 ff ff       	call   801570 <fd_lookup>
  802199:	83 c4 10             	add    $0x10,%esp
  80219c:	85 c0                	test   %eax,%eax
  80219e:	78 11                	js     8021b1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8021a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a3:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8021a9:	39 10                	cmp    %edx,(%eax)
  8021ab:	0f 94 c0             	sete   %al
  8021ae:	0f b6 c0             	movzbl %al,%eax
}
  8021b1:	c9                   	leave  
  8021b2:	c3                   	ret    

008021b3 <opencons>:
{
  8021b3:	55                   	push   %ebp
  8021b4:	89 e5                	mov    %esp,%ebp
  8021b6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8021b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021bc:	50                   	push   %eax
  8021bd:	e8 5f f3 ff ff       	call   801521 <fd_alloc>
  8021c2:	83 c4 10             	add    $0x10,%esp
  8021c5:	85 c0                	test   %eax,%eax
  8021c7:	78 3a                	js     802203 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8021c9:	83 ec 04             	sub    $0x4,%esp
  8021cc:	68 07 04 00 00       	push   $0x407
  8021d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8021d4:	6a 00                	push   $0x0
  8021d6:	e8 6a f0 ff ff       	call   801245 <sys_page_alloc>
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	78 21                	js     802203 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8021e2:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8021e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021eb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8021ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8021f7:	83 ec 0c             	sub    $0xc,%esp
  8021fa:	50                   	push   %eax
  8021fb:	e8 fa f2 ff ff       	call   8014fa <fd2num>
  802200:	83 c4 10             	add    $0x10,%esp
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	57                   	push   %edi
  802209:	56                   	push   %esi
  80220a:	53                   	push   %ebx
  80220b:	83 ec 0c             	sub    $0xc,%esp
  80220e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802211:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802214:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802217:	85 ff                	test   %edi,%edi
  802219:	74 53                	je     80226e <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80221b:	83 ec 0c             	sub    $0xc,%esp
  80221e:	57                   	push   %edi
  80221f:	e8 31 f2 ff ff       	call   801455 <sys_ipc_recv>
  802224:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802227:	85 db                	test   %ebx,%ebx
  802229:	74 0b                	je     802236 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80222b:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802231:	8b 52 74             	mov    0x74(%edx),%edx
  802234:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802236:	85 f6                	test   %esi,%esi
  802238:	74 0f                	je     802249 <ipc_recv+0x44>
  80223a:	85 ff                	test   %edi,%edi
  80223c:	74 0b                	je     802249 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80223e:	8b 15 04 60 80 00    	mov    0x806004,%edx
  802244:	8b 52 78             	mov    0x78(%edx),%edx
  802247:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  802249:	85 c0                	test   %eax,%eax
  80224b:	74 30                	je     80227d <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  80224d:	85 db                	test   %ebx,%ebx
  80224f:	74 06                	je     802257 <ipc_recv+0x52>
      		*from_env_store = 0;
  802251:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802257:	85 f6                	test   %esi,%esi
  802259:	74 2c                	je     802287 <ipc_recv+0x82>
      		*perm_store = 0;
  80225b:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  802261:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802266:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802269:	5b                   	pop    %ebx
  80226a:	5e                   	pop    %esi
  80226b:	5f                   	pop    %edi
  80226c:	5d                   	pop    %ebp
  80226d:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80226e:	83 ec 0c             	sub    $0xc,%esp
  802271:	6a ff                	push   $0xffffffff
  802273:	e8 dd f1 ff ff       	call   801455 <sys_ipc_recv>
  802278:	83 c4 10             	add    $0x10,%esp
  80227b:	eb aa                	jmp    802227 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  80227d:	a1 04 60 80 00       	mov    0x806004,%eax
  802282:	8b 40 70             	mov    0x70(%eax),%eax
  802285:	eb df                	jmp    802266 <ipc_recv+0x61>
		return -1;
  802287:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80228c:	eb d8                	jmp    802266 <ipc_recv+0x61>

0080228e <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80228e:	55                   	push   %ebp
  80228f:	89 e5                	mov    %esp,%ebp
  802291:	57                   	push   %edi
  802292:	56                   	push   %esi
  802293:	53                   	push   %ebx
  802294:	83 ec 0c             	sub    $0xc,%esp
  802297:	8b 75 0c             	mov    0xc(%ebp),%esi
  80229a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80229d:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8022a0:	85 db                	test   %ebx,%ebx
  8022a2:	75 22                	jne    8022c6 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8022a4:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8022a9:	eb 1b                	jmp    8022c6 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8022ab:	68 04 30 80 00       	push   $0x803004
  8022b0:	68 c9 25 80 00       	push   $0x8025c9
  8022b5:	6a 48                	push   $0x48
  8022b7:	68 28 30 80 00       	push   $0x803028
  8022bc:	e8 b4 e4 ff ff       	call   800775 <_panic>
		sys_yield();
  8022c1:	e8 46 f0 ff ff       	call   80130c <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8022c6:	57                   	push   %edi
  8022c7:	53                   	push   %ebx
  8022c8:	56                   	push   %esi
  8022c9:	ff 75 08             	pushl  0x8(%ebp)
  8022cc:	e8 61 f1 ff ff       	call   801432 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8022d1:	83 c4 10             	add    $0x10,%esp
  8022d4:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8022d7:	74 e8                	je     8022c1 <ipc_send+0x33>
  8022d9:	85 c0                	test   %eax,%eax
  8022db:	75 ce                	jne    8022ab <ipc_send+0x1d>
		sys_yield();
  8022dd:	e8 2a f0 ff ff       	call   80130c <sys_yield>
		
	}
	
}
  8022e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8022e5:	5b                   	pop    %ebx
  8022e6:	5e                   	pop    %esi
  8022e7:	5f                   	pop    %edi
  8022e8:	5d                   	pop    %ebp
  8022e9:	c3                   	ret    

008022ea <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8022f0:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8022f5:	89 c2                	mov    %eax,%edx
  8022f7:	c1 e2 05             	shl    $0x5,%edx
  8022fa:	29 c2                	sub    %eax,%edx
  8022fc:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802303:	8b 52 50             	mov    0x50(%edx),%edx
  802306:	39 ca                	cmp    %ecx,%edx
  802308:	74 0f                	je     802319 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80230a:	40                   	inc    %eax
  80230b:	3d 00 04 00 00       	cmp    $0x400,%eax
  802310:	75 e3                	jne    8022f5 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802312:	b8 00 00 00 00       	mov    $0x0,%eax
  802317:	eb 11                	jmp    80232a <ipc_find_env+0x40>
			return envs[i].env_id;
  802319:	89 c2                	mov    %eax,%edx
  80231b:	c1 e2 05             	shl    $0x5,%edx
  80231e:	29 c2                	sub    %eax,%edx
  802320:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802327:	8b 40 48             	mov    0x48(%eax),%eax
}
  80232a:	5d                   	pop    %ebp
  80232b:	c3                   	ret    

0080232c <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80232c:	55                   	push   %ebp
  80232d:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80232f:	8b 45 08             	mov    0x8(%ebp),%eax
  802332:	c1 e8 16             	shr    $0x16,%eax
  802335:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80233c:	a8 01                	test   $0x1,%al
  80233e:	74 21                	je     802361 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802340:	8b 45 08             	mov    0x8(%ebp),%eax
  802343:	c1 e8 0c             	shr    $0xc,%eax
  802346:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80234d:	a8 01                	test   $0x1,%al
  80234f:	74 17                	je     802368 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802351:	c1 e8 0c             	shr    $0xc,%eax
  802354:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80235b:	ef 
  80235c:	0f b7 c0             	movzwl %ax,%eax
  80235f:	eb 05                	jmp    802366 <pageref+0x3a>
		return 0;
  802361:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802366:	5d                   	pop    %ebp
  802367:	c3                   	ret    
		return 0;
  802368:	b8 00 00 00 00       	mov    $0x0,%eax
  80236d:	eb f7                	jmp    802366 <pageref+0x3a>
  80236f:	90                   	nop

00802370 <__udivdi3>:
  802370:	55                   	push   %ebp
  802371:	57                   	push   %edi
  802372:	56                   	push   %esi
  802373:	53                   	push   %ebx
  802374:	83 ec 1c             	sub    $0x1c,%esp
  802377:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80237b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80237f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802383:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802387:	89 ca                	mov    %ecx,%edx
  802389:	89 f8                	mov    %edi,%eax
  80238b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80238f:	85 f6                	test   %esi,%esi
  802391:	75 2d                	jne    8023c0 <__udivdi3+0x50>
  802393:	39 cf                	cmp    %ecx,%edi
  802395:	77 65                	ja     8023fc <__udivdi3+0x8c>
  802397:	89 fd                	mov    %edi,%ebp
  802399:	85 ff                	test   %edi,%edi
  80239b:	75 0b                	jne    8023a8 <__udivdi3+0x38>
  80239d:	b8 01 00 00 00       	mov    $0x1,%eax
  8023a2:	31 d2                	xor    %edx,%edx
  8023a4:	f7 f7                	div    %edi
  8023a6:	89 c5                	mov    %eax,%ebp
  8023a8:	31 d2                	xor    %edx,%edx
  8023aa:	89 c8                	mov    %ecx,%eax
  8023ac:	f7 f5                	div    %ebp
  8023ae:	89 c1                	mov    %eax,%ecx
  8023b0:	89 d8                	mov    %ebx,%eax
  8023b2:	f7 f5                	div    %ebp
  8023b4:	89 cf                	mov    %ecx,%edi
  8023b6:	89 fa                	mov    %edi,%edx
  8023b8:	83 c4 1c             	add    $0x1c,%esp
  8023bb:	5b                   	pop    %ebx
  8023bc:	5e                   	pop    %esi
  8023bd:	5f                   	pop    %edi
  8023be:	5d                   	pop    %ebp
  8023bf:	c3                   	ret    
  8023c0:	39 ce                	cmp    %ecx,%esi
  8023c2:	77 28                	ja     8023ec <__udivdi3+0x7c>
  8023c4:	0f bd fe             	bsr    %esi,%edi
  8023c7:	83 f7 1f             	xor    $0x1f,%edi
  8023ca:	75 40                	jne    80240c <__udivdi3+0x9c>
  8023cc:	39 ce                	cmp    %ecx,%esi
  8023ce:	72 0a                	jb     8023da <__udivdi3+0x6a>
  8023d0:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8023d4:	0f 87 9e 00 00 00    	ja     802478 <__udivdi3+0x108>
  8023da:	b8 01 00 00 00       	mov    $0x1,%eax
  8023df:	89 fa                	mov    %edi,%edx
  8023e1:	83 c4 1c             	add    $0x1c,%esp
  8023e4:	5b                   	pop    %ebx
  8023e5:	5e                   	pop    %esi
  8023e6:	5f                   	pop    %edi
  8023e7:	5d                   	pop    %ebp
  8023e8:	c3                   	ret    
  8023e9:	8d 76 00             	lea    0x0(%esi),%esi
  8023ec:	31 ff                	xor    %edi,%edi
  8023ee:	31 c0                	xor    %eax,%eax
  8023f0:	89 fa                	mov    %edi,%edx
  8023f2:	83 c4 1c             	add    $0x1c,%esp
  8023f5:	5b                   	pop    %ebx
  8023f6:	5e                   	pop    %esi
  8023f7:	5f                   	pop    %edi
  8023f8:	5d                   	pop    %ebp
  8023f9:	c3                   	ret    
  8023fa:	66 90                	xchg   %ax,%ax
  8023fc:	89 d8                	mov    %ebx,%eax
  8023fe:	f7 f7                	div    %edi
  802400:	31 ff                	xor    %edi,%edi
  802402:	89 fa                	mov    %edi,%edx
  802404:	83 c4 1c             	add    $0x1c,%esp
  802407:	5b                   	pop    %ebx
  802408:	5e                   	pop    %esi
  802409:	5f                   	pop    %edi
  80240a:	5d                   	pop    %ebp
  80240b:	c3                   	ret    
  80240c:	bd 20 00 00 00       	mov    $0x20,%ebp
  802411:	29 fd                	sub    %edi,%ebp
  802413:	89 f9                	mov    %edi,%ecx
  802415:	d3 e6                	shl    %cl,%esi
  802417:	89 c3                	mov    %eax,%ebx
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	d3 eb                	shr    %cl,%ebx
  80241d:	89 d9                	mov    %ebx,%ecx
  80241f:	09 f1                	or     %esi,%ecx
  802421:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802425:	89 f9                	mov    %edi,%ecx
  802427:	d3 e0                	shl    %cl,%eax
  802429:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80242d:	89 d6                	mov    %edx,%esi
  80242f:	89 e9                	mov    %ebp,%ecx
  802431:	d3 ee                	shr    %cl,%esi
  802433:	89 f9                	mov    %edi,%ecx
  802435:	d3 e2                	shl    %cl,%edx
  802437:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80243b:	89 e9                	mov    %ebp,%ecx
  80243d:	d3 eb                	shr    %cl,%ebx
  80243f:	09 da                	or     %ebx,%edx
  802441:	89 d0                	mov    %edx,%eax
  802443:	89 f2                	mov    %esi,%edx
  802445:	f7 74 24 08          	divl   0x8(%esp)
  802449:	89 d6                	mov    %edx,%esi
  80244b:	89 c3                	mov    %eax,%ebx
  80244d:	f7 64 24 0c          	mull   0xc(%esp)
  802451:	39 d6                	cmp    %edx,%esi
  802453:	72 17                	jb     80246c <__udivdi3+0xfc>
  802455:	74 09                	je     802460 <__udivdi3+0xf0>
  802457:	89 d8                	mov    %ebx,%eax
  802459:	31 ff                	xor    %edi,%edi
  80245b:	e9 56 ff ff ff       	jmp    8023b6 <__udivdi3+0x46>
  802460:	8b 54 24 04          	mov    0x4(%esp),%edx
  802464:	89 f9                	mov    %edi,%ecx
  802466:	d3 e2                	shl    %cl,%edx
  802468:	39 c2                	cmp    %eax,%edx
  80246a:	73 eb                	jae    802457 <__udivdi3+0xe7>
  80246c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80246f:	31 ff                	xor    %edi,%edi
  802471:	e9 40 ff ff ff       	jmp    8023b6 <__udivdi3+0x46>
  802476:	66 90                	xchg   %ax,%ax
  802478:	31 c0                	xor    %eax,%eax
  80247a:	e9 37 ff ff ff       	jmp    8023b6 <__udivdi3+0x46>
  80247f:	90                   	nop

00802480 <__umoddi3>:
  802480:	55                   	push   %ebp
  802481:	57                   	push   %edi
  802482:	56                   	push   %esi
  802483:	53                   	push   %ebx
  802484:	83 ec 1c             	sub    $0x1c,%esp
  802487:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80248b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80248f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802493:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802497:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80249b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80249f:	89 3c 24             	mov    %edi,(%esp)
  8024a2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024a6:	89 f2                	mov    %esi,%edx
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	75 18                	jne    8024c4 <__umoddi3+0x44>
  8024ac:	39 f7                	cmp    %esi,%edi
  8024ae:	0f 86 a0 00 00 00    	jbe    802554 <__umoddi3+0xd4>
  8024b4:	89 c8                	mov    %ecx,%eax
  8024b6:	f7 f7                	div    %edi
  8024b8:	89 d0                	mov    %edx,%eax
  8024ba:	31 d2                	xor    %edx,%edx
  8024bc:	83 c4 1c             	add    $0x1c,%esp
  8024bf:	5b                   	pop    %ebx
  8024c0:	5e                   	pop    %esi
  8024c1:	5f                   	pop    %edi
  8024c2:	5d                   	pop    %ebp
  8024c3:	c3                   	ret    
  8024c4:	89 f3                	mov    %esi,%ebx
  8024c6:	39 f0                	cmp    %esi,%eax
  8024c8:	0f 87 a6 00 00 00    	ja     802574 <__umoddi3+0xf4>
  8024ce:	0f bd e8             	bsr    %eax,%ebp
  8024d1:	83 f5 1f             	xor    $0x1f,%ebp
  8024d4:	0f 84 a6 00 00 00    	je     802580 <__umoddi3+0x100>
  8024da:	bf 20 00 00 00       	mov    $0x20,%edi
  8024df:	29 ef                	sub    %ebp,%edi
  8024e1:	89 e9                	mov    %ebp,%ecx
  8024e3:	d3 e0                	shl    %cl,%eax
  8024e5:	8b 34 24             	mov    (%esp),%esi
  8024e8:	89 f2                	mov    %esi,%edx
  8024ea:	89 f9                	mov    %edi,%ecx
  8024ec:	d3 ea                	shr    %cl,%edx
  8024ee:	09 c2                	or     %eax,%edx
  8024f0:	89 14 24             	mov    %edx,(%esp)
  8024f3:	89 f2                	mov    %esi,%edx
  8024f5:	89 e9                	mov    %ebp,%ecx
  8024f7:	d3 e2                	shl    %cl,%edx
  8024f9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8024fd:	89 de                	mov    %ebx,%esi
  8024ff:	89 f9                	mov    %edi,%ecx
  802501:	d3 ee                	shr    %cl,%esi
  802503:	89 e9                	mov    %ebp,%ecx
  802505:	d3 e3                	shl    %cl,%ebx
  802507:	8b 54 24 08          	mov    0x8(%esp),%edx
  80250b:	89 d0                	mov    %edx,%eax
  80250d:	89 f9                	mov    %edi,%ecx
  80250f:	d3 e8                	shr    %cl,%eax
  802511:	09 d8                	or     %ebx,%eax
  802513:	89 d3                	mov    %edx,%ebx
  802515:	89 e9                	mov    %ebp,%ecx
  802517:	d3 e3                	shl    %cl,%ebx
  802519:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80251d:	89 f2                	mov    %esi,%edx
  80251f:	f7 34 24             	divl   (%esp)
  802522:	89 d6                	mov    %edx,%esi
  802524:	f7 64 24 04          	mull   0x4(%esp)
  802528:	89 c3                	mov    %eax,%ebx
  80252a:	89 d1                	mov    %edx,%ecx
  80252c:	39 d6                	cmp    %edx,%esi
  80252e:	72 7c                	jb     8025ac <__umoddi3+0x12c>
  802530:	74 72                	je     8025a4 <__umoddi3+0x124>
  802532:	8b 54 24 08          	mov    0x8(%esp),%edx
  802536:	29 da                	sub    %ebx,%edx
  802538:	19 ce                	sbb    %ecx,%esi
  80253a:	89 f0                	mov    %esi,%eax
  80253c:	89 f9                	mov    %edi,%ecx
  80253e:	d3 e0                	shl    %cl,%eax
  802540:	89 e9                	mov    %ebp,%ecx
  802542:	d3 ea                	shr    %cl,%edx
  802544:	09 d0                	or     %edx,%eax
  802546:	89 e9                	mov    %ebp,%ecx
  802548:	d3 ee                	shr    %cl,%esi
  80254a:	89 f2                	mov    %esi,%edx
  80254c:	83 c4 1c             	add    $0x1c,%esp
  80254f:	5b                   	pop    %ebx
  802550:	5e                   	pop    %esi
  802551:	5f                   	pop    %edi
  802552:	5d                   	pop    %ebp
  802553:	c3                   	ret    
  802554:	89 fd                	mov    %edi,%ebp
  802556:	85 ff                	test   %edi,%edi
  802558:	75 0b                	jne    802565 <__umoddi3+0xe5>
  80255a:	b8 01 00 00 00       	mov    $0x1,%eax
  80255f:	31 d2                	xor    %edx,%edx
  802561:	f7 f7                	div    %edi
  802563:	89 c5                	mov    %eax,%ebp
  802565:	89 f0                	mov    %esi,%eax
  802567:	31 d2                	xor    %edx,%edx
  802569:	f7 f5                	div    %ebp
  80256b:	89 c8                	mov    %ecx,%eax
  80256d:	f7 f5                	div    %ebp
  80256f:	e9 44 ff ff ff       	jmp    8024b8 <__umoddi3+0x38>
  802574:	89 c8                	mov    %ecx,%eax
  802576:	89 f2                	mov    %esi,%edx
  802578:	83 c4 1c             	add    $0x1c,%esp
  80257b:	5b                   	pop    %ebx
  80257c:	5e                   	pop    %esi
  80257d:	5f                   	pop    %edi
  80257e:	5d                   	pop    %ebp
  80257f:	c3                   	ret    
  802580:	39 f0                	cmp    %esi,%eax
  802582:	72 05                	jb     802589 <__umoddi3+0x109>
  802584:	39 0c 24             	cmp    %ecx,(%esp)
  802587:	77 0c                	ja     802595 <__umoddi3+0x115>
  802589:	89 f2                	mov    %esi,%edx
  80258b:	29 f9                	sub    %edi,%ecx
  80258d:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802591:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802595:	8b 44 24 04          	mov    0x4(%esp),%eax
  802599:	83 c4 1c             	add    $0x1c,%esp
  80259c:	5b                   	pop    %ebx
  80259d:	5e                   	pop    %esi
  80259e:	5f                   	pop    %edi
  80259f:	5d                   	pop    %ebp
  8025a0:	c3                   	ret    
  8025a1:	8d 76 00             	lea    0x0(%esi),%esi
  8025a4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8025a8:	73 88                	jae    802532 <__umoddi3+0xb2>
  8025aa:	66 90                	xchg   %ax,%ax
  8025ac:	2b 44 24 04          	sub    0x4(%esp),%eax
  8025b0:	1b 14 24             	sbb    (%esp),%edx
  8025b3:	89 d1                	mov    %edx,%ecx
  8025b5:	89 c3                	mov    %eax,%ebx
  8025b7:	e9 76 ff ff ff       	jmp    802532 <__umoddi3+0xb2>
