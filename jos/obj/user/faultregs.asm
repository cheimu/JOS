
obj/user/faultregs.debug:     file format elf32-i386


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
  80002c:	e8 75 05 00 00       	call   8005a6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <check_regs>:
static struct regs before, during, after;

static void
check_regs(struct regs* a, const char *an, struct regs* b, const char *bn,
	   const char *testname)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	89 c6                	mov    %eax,%esi
  80003e:	89 cb                	mov    %ecx,%ebx
	int mismatch = 0;

	cprintf("%-6s %-8s %-8s\n", "", an, bn);
  800040:	ff 75 08             	pushl  0x8(%ebp)
  800043:	52                   	push   %edx
  800044:	68 f1 24 80 00       	push   $0x8024f1
  800049:	68 c0 24 80 00       	push   $0x8024c0
  80004e:	e8 cc 06 00 00       	call   80071f <cprintf>
			cprintf("MISMATCH\n");				\
			mismatch = 1;					\
		}							\
	} while (0)

	CHECK(edi, regs.reg_edi);
  800053:	ff 33                	pushl  (%ebx)
  800055:	ff 36                	pushl  (%esi)
  800057:	68 d0 24 80 00       	push   $0x8024d0
  80005c:	68 d4 24 80 00       	push   $0x8024d4
  800061:	e8 b9 06 00 00       	call   80071f <cprintf>
  800066:	83 c4 20             	add    $0x20,%esp
  800069:	8b 03                	mov    (%ebx),%eax
  80006b:	39 06                	cmp    %eax,(%esi)
  80006d:	0f 84 31 02 00 00    	je     8002a4 <check_regs+0x271>
  800073:	83 ec 0c             	sub    $0xc,%esp
  800076:	68 e8 24 80 00       	push   $0x8024e8
  80007b:	e8 9f 06 00 00       	call   80071f <cprintf>
  800080:	83 c4 10             	add    $0x10,%esp
  800083:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(esi, regs.reg_esi);
  800088:	ff 73 04             	pushl  0x4(%ebx)
  80008b:	ff 76 04             	pushl  0x4(%esi)
  80008e:	68 f2 24 80 00       	push   $0x8024f2
  800093:	68 d4 24 80 00       	push   $0x8024d4
  800098:	e8 82 06 00 00       	call   80071f <cprintf>
  80009d:	83 c4 10             	add    $0x10,%esp
  8000a0:	8b 43 04             	mov    0x4(%ebx),%eax
  8000a3:	39 46 04             	cmp    %eax,0x4(%esi)
  8000a6:	0f 84 12 02 00 00    	je     8002be <check_regs+0x28b>
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	68 e8 24 80 00       	push   $0x8024e8
  8000b4:	e8 66 06 00 00       	call   80071f <cprintf>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebp, regs.reg_ebp);
  8000c1:	ff 73 08             	pushl  0x8(%ebx)
  8000c4:	ff 76 08             	pushl  0x8(%esi)
  8000c7:	68 f6 24 80 00       	push   $0x8024f6
  8000cc:	68 d4 24 80 00       	push   $0x8024d4
  8000d1:	e8 49 06 00 00       	call   80071f <cprintf>
  8000d6:	83 c4 10             	add    $0x10,%esp
  8000d9:	8b 43 08             	mov    0x8(%ebx),%eax
  8000dc:	39 46 08             	cmp    %eax,0x8(%esi)
  8000df:	0f 84 ee 01 00 00    	je     8002d3 <check_regs+0x2a0>
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	68 e8 24 80 00       	push   $0x8024e8
  8000ed:	e8 2d 06 00 00       	call   80071f <cprintf>
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ebx, regs.reg_ebx);
  8000fa:	ff 73 10             	pushl  0x10(%ebx)
  8000fd:	ff 76 10             	pushl  0x10(%esi)
  800100:	68 fa 24 80 00       	push   $0x8024fa
  800105:	68 d4 24 80 00       	push   $0x8024d4
  80010a:	e8 10 06 00 00       	call   80071f <cprintf>
  80010f:	83 c4 10             	add    $0x10,%esp
  800112:	8b 43 10             	mov    0x10(%ebx),%eax
  800115:	39 46 10             	cmp    %eax,0x10(%esi)
  800118:	0f 84 ca 01 00 00    	je     8002e8 <check_regs+0x2b5>
  80011e:	83 ec 0c             	sub    $0xc,%esp
  800121:	68 e8 24 80 00       	push   $0x8024e8
  800126:	e8 f4 05 00 00       	call   80071f <cprintf>
  80012b:	83 c4 10             	add    $0x10,%esp
  80012e:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(edx, regs.reg_edx);
  800133:	ff 73 14             	pushl  0x14(%ebx)
  800136:	ff 76 14             	pushl  0x14(%esi)
  800139:	68 fe 24 80 00       	push   $0x8024fe
  80013e:	68 d4 24 80 00       	push   $0x8024d4
  800143:	e8 d7 05 00 00       	call   80071f <cprintf>
  800148:	83 c4 10             	add    $0x10,%esp
  80014b:	8b 43 14             	mov    0x14(%ebx),%eax
  80014e:	39 46 14             	cmp    %eax,0x14(%esi)
  800151:	0f 84 a6 01 00 00    	je     8002fd <check_regs+0x2ca>
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 e8 24 80 00       	push   $0x8024e8
  80015f:	e8 bb 05 00 00       	call   80071f <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(ecx, regs.reg_ecx);
  80016c:	ff 73 18             	pushl  0x18(%ebx)
  80016f:	ff 76 18             	pushl  0x18(%esi)
  800172:	68 02 25 80 00       	push   $0x802502
  800177:	68 d4 24 80 00       	push   $0x8024d4
  80017c:	e8 9e 05 00 00       	call   80071f <cprintf>
  800181:	83 c4 10             	add    $0x10,%esp
  800184:	8b 43 18             	mov    0x18(%ebx),%eax
  800187:	39 46 18             	cmp    %eax,0x18(%esi)
  80018a:	0f 84 82 01 00 00    	je     800312 <check_regs+0x2df>
  800190:	83 ec 0c             	sub    $0xc,%esp
  800193:	68 e8 24 80 00       	push   $0x8024e8
  800198:	e8 82 05 00 00       	call   80071f <cprintf>
  80019d:	83 c4 10             	add    $0x10,%esp
  8001a0:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eax, regs.reg_eax);
  8001a5:	ff 73 1c             	pushl  0x1c(%ebx)
  8001a8:	ff 76 1c             	pushl  0x1c(%esi)
  8001ab:	68 06 25 80 00       	push   $0x802506
  8001b0:	68 d4 24 80 00       	push   $0x8024d4
  8001b5:	e8 65 05 00 00       	call   80071f <cprintf>
  8001ba:	83 c4 10             	add    $0x10,%esp
  8001bd:	8b 43 1c             	mov    0x1c(%ebx),%eax
  8001c0:	39 46 1c             	cmp    %eax,0x1c(%esi)
  8001c3:	0f 84 5e 01 00 00    	je     800327 <check_regs+0x2f4>
  8001c9:	83 ec 0c             	sub    $0xc,%esp
  8001cc:	68 e8 24 80 00       	push   $0x8024e8
  8001d1:	e8 49 05 00 00       	call   80071f <cprintf>
  8001d6:	83 c4 10             	add    $0x10,%esp
  8001d9:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eip, eip);
  8001de:	ff 73 20             	pushl  0x20(%ebx)
  8001e1:	ff 76 20             	pushl  0x20(%esi)
  8001e4:	68 0a 25 80 00       	push   $0x80250a
  8001e9:	68 d4 24 80 00       	push   $0x8024d4
  8001ee:	e8 2c 05 00 00       	call   80071f <cprintf>
  8001f3:	83 c4 10             	add    $0x10,%esp
  8001f6:	8b 43 20             	mov    0x20(%ebx),%eax
  8001f9:	39 46 20             	cmp    %eax,0x20(%esi)
  8001fc:	0f 84 3a 01 00 00    	je     80033c <check_regs+0x309>
  800202:	83 ec 0c             	sub    $0xc,%esp
  800205:	68 e8 24 80 00       	push   $0x8024e8
  80020a:	e8 10 05 00 00       	call   80071f <cprintf>
  80020f:	83 c4 10             	add    $0x10,%esp
  800212:	bf 01 00 00 00       	mov    $0x1,%edi
	CHECK(eflags, eflags);
  800217:	ff 73 24             	pushl  0x24(%ebx)
  80021a:	ff 76 24             	pushl  0x24(%esi)
  80021d:	68 0e 25 80 00       	push   $0x80250e
  800222:	68 d4 24 80 00       	push   $0x8024d4
  800227:	e8 f3 04 00 00       	call   80071f <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
  80022f:	8b 43 24             	mov    0x24(%ebx),%eax
  800232:	39 46 24             	cmp    %eax,0x24(%esi)
  800235:	0f 84 16 01 00 00    	je     800351 <check_regs+0x31e>
  80023b:	83 ec 0c             	sub    $0xc,%esp
  80023e:	68 e8 24 80 00       	push   $0x8024e8
  800243:	e8 d7 04 00 00       	call   80071f <cprintf>
	CHECK(esp, esp);
  800248:	ff 73 28             	pushl  0x28(%ebx)
  80024b:	ff 76 28             	pushl  0x28(%esi)
  80024e:	68 15 25 80 00       	push   $0x802515
  800253:	68 d4 24 80 00       	push   $0x8024d4
  800258:	e8 c2 04 00 00       	call   80071f <cprintf>
  80025d:	83 c4 20             	add    $0x20,%esp
  800260:	8b 43 28             	mov    0x28(%ebx),%eax
  800263:	39 46 28             	cmp    %eax,0x28(%esi)
  800266:	0f 84 53 01 00 00    	je     8003bf <check_regs+0x38c>
  80026c:	83 ec 0c             	sub    $0xc,%esp
  80026f:	68 e8 24 80 00       	push   $0x8024e8
  800274:	e8 a6 04 00 00       	call   80071f <cprintf>

#undef CHECK

	cprintf("Registers %s ", testname);
  800279:	83 c4 08             	add    $0x8,%esp
  80027c:	ff 75 0c             	pushl  0xc(%ebp)
  80027f:	68 19 25 80 00       	push   $0x802519
  800284:	e8 96 04 00 00       	call   80071f <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	if (!mismatch)
		cprintf("OK\n");
	else
		cprintf("MISMATCH\n");
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	68 e8 24 80 00       	push   $0x8024e8
  800294:	e8 86 04 00 00       	call   80071f <cprintf>
  800299:	83 c4 10             	add    $0x10,%esp
}
  80029c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029f:	5b                   	pop    %ebx
  8002a0:	5e                   	pop    %esi
  8002a1:	5f                   	pop    %edi
  8002a2:	5d                   	pop    %ebp
  8002a3:	c3                   	ret    
	CHECK(edi, regs.reg_edi);
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 e4 24 80 00       	push   $0x8024e4
  8002ac:	e8 6e 04 00 00       	call   80071f <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	int mismatch = 0;
  8002b4:	bf 00 00 00 00       	mov    $0x0,%edi
  8002b9:	e9 ca fd ff ff       	jmp    800088 <check_regs+0x55>
	CHECK(esi, regs.reg_esi);
  8002be:	83 ec 0c             	sub    $0xc,%esp
  8002c1:	68 e4 24 80 00       	push   $0x8024e4
  8002c6:	e8 54 04 00 00       	call   80071f <cprintf>
  8002cb:	83 c4 10             	add    $0x10,%esp
  8002ce:	e9 ee fd ff ff       	jmp    8000c1 <check_regs+0x8e>
	CHECK(ebp, regs.reg_ebp);
  8002d3:	83 ec 0c             	sub    $0xc,%esp
  8002d6:	68 e4 24 80 00       	push   $0x8024e4
  8002db:	e8 3f 04 00 00       	call   80071f <cprintf>
  8002e0:	83 c4 10             	add    $0x10,%esp
  8002e3:	e9 12 fe ff ff       	jmp    8000fa <check_regs+0xc7>
	CHECK(ebx, regs.reg_ebx);
  8002e8:	83 ec 0c             	sub    $0xc,%esp
  8002eb:	68 e4 24 80 00       	push   $0x8024e4
  8002f0:	e8 2a 04 00 00       	call   80071f <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
  8002f8:	e9 36 fe ff ff       	jmp    800133 <check_regs+0x100>
	CHECK(edx, regs.reg_edx);
  8002fd:	83 ec 0c             	sub    $0xc,%esp
  800300:	68 e4 24 80 00       	push   $0x8024e4
  800305:	e8 15 04 00 00       	call   80071f <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
  80030d:	e9 5a fe ff ff       	jmp    80016c <check_regs+0x139>
	CHECK(ecx, regs.reg_ecx);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	68 e4 24 80 00       	push   $0x8024e4
  80031a:	e8 00 04 00 00       	call   80071f <cprintf>
  80031f:	83 c4 10             	add    $0x10,%esp
  800322:	e9 7e fe ff ff       	jmp    8001a5 <check_regs+0x172>
	CHECK(eax, regs.reg_eax);
  800327:	83 ec 0c             	sub    $0xc,%esp
  80032a:	68 e4 24 80 00       	push   $0x8024e4
  80032f:	e8 eb 03 00 00       	call   80071f <cprintf>
  800334:	83 c4 10             	add    $0x10,%esp
  800337:	e9 a2 fe ff ff       	jmp    8001de <check_regs+0x1ab>
	CHECK(eip, eip);
  80033c:	83 ec 0c             	sub    $0xc,%esp
  80033f:	68 e4 24 80 00       	push   $0x8024e4
  800344:	e8 d6 03 00 00       	call   80071f <cprintf>
  800349:	83 c4 10             	add    $0x10,%esp
  80034c:	e9 c6 fe ff ff       	jmp    800217 <check_regs+0x1e4>
	CHECK(eflags, eflags);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	68 e4 24 80 00       	push   $0x8024e4
  800359:	e8 c1 03 00 00       	call   80071f <cprintf>
	CHECK(esp, esp);
  80035e:	ff 73 28             	pushl  0x28(%ebx)
  800361:	ff 76 28             	pushl  0x28(%esi)
  800364:	68 15 25 80 00       	push   $0x802515
  800369:	68 d4 24 80 00       	push   $0x8024d4
  80036e:	e8 ac 03 00 00       	call   80071f <cprintf>
  800373:	83 c4 20             	add    $0x20,%esp
  800376:	8b 43 28             	mov    0x28(%ebx),%eax
  800379:	39 46 28             	cmp    %eax,0x28(%esi)
  80037c:	0f 85 ea fe ff ff    	jne    80026c <check_regs+0x239>
  800382:	83 ec 0c             	sub    $0xc,%esp
  800385:	68 e4 24 80 00       	push   $0x8024e4
  80038a:	e8 90 03 00 00       	call   80071f <cprintf>
	cprintf("Registers %s ", testname);
  80038f:	83 c4 08             	add    $0x8,%esp
  800392:	ff 75 0c             	pushl  0xc(%ebp)
  800395:	68 19 25 80 00       	push   $0x802519
  80039a:	e8 80 03 00 00       	call   80071f <cprintf>
	if (!mismatch)
  80039f:	83 c4 10             	add    $0x10,%esp
  8003a2:	85 ff                	test   %edi,%edi
  8003a4:	0f 85 e2 fe ff ff    	jne    80028c <check_regs+0x259>
		cprintf("OK\n");
  8003aa:	83 ec 0c             	sub    $0xc,%esp
  8003ad:	68 e4 24 80 00       	push   $0x8024e4
  8003b2:	e8 68 03 00 00       	call   80071f <cprintf>
  8003b7:	83 c4 10             	add    $0x10,%esp
  8003ba:	e9 dd fe ff ff       	jmp    80029c <check_regs+0x269>
	CHECK(esp, esp);
  8003bf:	83 ec 0c             	sub    $0xc,%esp
  8003c2:	68 e4 24 80 00       	push   $0x8024e4
  8003c7:	e8 53 03 00 00       	call   80071f <cprintf>
	cprintf("Registers %s ", testname);
  8003cc:	83 c4 08             	add    $0x8,%esp
  8003cf:	ff 75 0c             	pushl  0xc(%ebp)
  8003d2:	68 19 25 80 00       	push   $0x802519
  8003d7:	e8 43 03 00 00       	call   80071f <cprintf>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	e9 a8 fe ff ff       	jmp    80028c <check_regs+0x259>

008003e4 <pgfault>:

static void
pgfault(struct UTrapframe *utf)
{
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	57                   	push   %edi
  8003e8:	56                   	push   %esi
  8003e9:	8b 45 08             	mov    0x8(%ebp),%eax
	int r;

	if (utf->utf_fault_va != (uint32_t)UTEMP)
  8003ec:	8b 10                	mov    (%eax),%edx
  8003ee:	81 fa 00 00 40 00    	cmp    $0x400000,%edx
  8003f4:	75 6f                	jne    800465 <pgfault+0x81>
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
		      utf->utf_fault_va, utf->utf_eip);

	// Check registers in UTrapframe
	during.regs = utf->utf_regs;
  8003f6:	bf 40 40 80 00       	mov    $0x804040,%edi
  8003fb:	8d 70 08             	lea    0x8(%eax),%esi
  8003fe:	b9 08 00 00 00       	mov    $0x8,%ecx
  800403:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	during.eip = utf->utf_eip;
  800405:	8b 50 28             	mov    0x28(%eax),%edx
  800408:	89 15 60 40 80 00    	mov    %edx,0x804060
	during.eflags = utf->utf_eflags & ~FL_RF;
  80040e:	8b 50 2c             	mov    0x2c(%eax),%edx
  800411:	81 e2 ff ff fe ff    	and    $0xfffeffff,%edx
  800417:	89 15 64 40 80 00    	mov    %edx,0x804064
	during.esp = utf->utf_esp;
  80041d:	8b 40 30             	mov    0x30(%eax),%eax
  800420:	a3 68 40 80 00       	mov    %eax,0x804068
	check_regs(&before, "before", &during, "during", "in UTrapframe");
  800425:	83 ec 08             	sub    $0x8,%esp
  800428:	68 3f 25 80 00       	push   $0x80253f
  80042d:	68 4d 25 80 00       	push   $0x80254d
  800432:	b9 40 40 80 00       	mov    $0x804040,%ecx
  800437:	ba 38 25 80 00       	mov    $0x802538,%edx
  80043c:	b8 80 40 80 00       	mov    $0x804080,%eax
  800441:	e8 ed fb ff ff       	call   800033 <check_regs>

	// Map UTEMP so the write succeeds
	if ((r = sys_page_alloc(0, UTEMP, PTE_U|PTE_P|PTE_W)) < 0)
  800446:	83 c4 0c             	add    $0xc,%esp
  800449:	6a 07                	push   $0x7
  80044b:	68 00 00 40 00       	push   $0x400000
  800450:	6a 00                	push   $0x0
  800452:	e8 85 0c 00 00       	call   8010dc <sys_page_alloc>
  800457:	83 c4 10             	add    $0x10,%esp
  80045a:	85 c0                	test   %eax,%eax
  80045c:	78 1f                	js     80047d <pgfault+0x99>
		panic("sys_page_alloc: %e", r);
}
  80045e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800461:	5e                   	pop    %esi
  800462:	5f                   	pop    %edi
  800463:	5d                   	pop    %ebp
  800464:	c3                   	ret    
		panic("pgfault expected at UTEMP, got 0x%08x (eip %08x)",
  800465:	83 ec 0c             	sub    $0xc,%esp
  800468:	ff 70 28             	pushl  0x28(%eax)
  80046b:	52                   	push   %edx
  80046c:	68 80 25 80 00       	push   $0x802580
  800471:	6a 51                	push   $0x51
  800473:	68 27 25 80 00       	push   $0x802527
  800478:	e8 8f 01 00 00       	call   80060c <_panic>
		panic("sys_page_alloc: %e", r);
  80047d:	50                   	push   %eax
  80047e:	68 54 25 80 00       	push   $0x802554
  800483:	6a 5c                	push   $0x5c
  800485:	68 27 25 80 00       	push   $0x802527
  80048a:	e8 7d 01 00 00       	call   80060c <_panic>

0080048f <umain>:

void
umain(int argc, char **argv)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(pgfault);
  800495:	68 e4 03 80 00       	push   $0x8003e4
  80049a:	e8 f2 0e 00 00       	call   801391 <set_pgfault_handler>

	asm volatile(
  80049f:	50                   	push   %eax
  8004a0:	9c                   	pushf  
  8004a1:	58                   	pop    %eax
  8004a2:	0d d5 08 00 00       	or     $0x8d5,%eax
  8004a7:	50                   	push   %eax
  8004a8:	9d                   	popf   
  8004a9:	a3 a4 40 80 00       	mov    %eax,0x8040a4
  8004ae:	8d 05 e9 04 80 00    	lea    0x8004e9,%eax
  8004b4:	a3 a0 40 80 00       	mov    %eax,0x8040a0
  8004b9:	58                   	pop    %eax
  8004ba:	89 3d 80 40 80 00    	mov    %edi,0x804080
  8004c0:	89 35 84 40 80 00    	mov    %esi,0x804084
  8004c6:	89 2d 88 40 80 00    	mov    %ebp,0x804088
  8004cc:	89 1d 90 40 80 00    	mov    %ebx,0x804090
  8004d2:	89 15 94 40 80 00    	mov    %edx,0x804094
  8004d8:	89 0d 98 40 80 00    	mov    %ecx,0x804098
  8004de:	a3 9c 40 80 00       	mov    %eax,0x80409c
  8004e3:	89 25 a8 40 80 00    	mov    %esp,0x8040a8
  8004e9:	c7 05 00 00 40 00 2a 	movl   $0x2a,0x400000
  8004f0:	00 00 00 
  8004f3:	89 3d 00 40 80 00    	mov    %edi,0x804000
  8004f9:	89 35 04 40 80 00    	mov    %esi,0x804004
  8004ff:	89 2d 08 40 80 00    	mov    %ebp,0x804008
  800505:	89 1d 10 40 80 00    	mov    %ebx,0x804010
  80050b:	89 15 14 40 80 00    	mov    %edx,0x804014
  800511:	89 0d 18 40 80 00    	mov    %ecx,0x804018
  800517:	a3 1c 40 80 00       	mov    %eax,0x80401c
  80051c:	89 25 28 40 80 00    	mov    %esp,0x804028
  800522:	8b 3d 80 40 80 00    	mov    0x804080,%edi
  800528:	8b 35 84 40 80 00    	mov    0x804084,%esi
  80052e:	8b 2d 88 40 80 00    	mov    0x804088,%ebp
  800534:	8b 1d 90 40 80 00    	mov    0x804090,%ebx
  80053a:	8b 15 94 40 80 00    	mov    0x804094,%edx
  800540:	8b 0d 98 40 80 00    	mov    0x804098,%ecx
  800546:	a1 9c 40 80 00       	mov    0x80409c,%eax
  80054b:	8b 25 a8 40 80 00    	mov    0x8040a8,%esp
  800551:	50                   	push   %eax
  800552:	9c                   	pushf  
  800553:	58                   	pop    %eax
  800554:	a3 24 40 80 00       	mov    %eax,0x804024
  800559:	58                   	pop    %eax
		: : "m" (before), "m" (after) : "memory", "cc");

	// Check UTEMP to roughly determine that EIP was restored
	// correctly (of course, we probably wouldn't get this far if
	// it weren't)
	if (*(int*)UTEMP != 42)
  80055a:	83 c4 10             	add    $0x10,%esp
  80055d:	83 3d 00 00 40 00 2a 	cmpl   $0x2a,0x400000
  800564:	74 10                	je     800576 <umain+0xe7>
		cprintf("EIP after page-fault MISMATCH\n");
  800566:	83 ec 0c             	sub    $0xc,%esp
  800569:	68 b4 25 80 00       	push   $0x8025b4
  80056e:	e8 ac 01 00 00       	call   80071f <cprintf>
  800573:	83 c4 10             	add    $0x10,%esp
	after.eip = before.eip;
  800576:	a1 a0 40 80 00       	mov    0x8040a0,%eax
  80057b:	a3 20 40 80 00       	mov    %eax,0x804020

	check_regs(&before, "before", &after, "after", "after page-fault");
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	68 67 25 80 00       	push   $0x802567
  800588:	68 78 25 80 00       	push   $0x802578
  80058d:	b9 00 40 80 00       	mov    $0x804000,%ecx
  800592:	ba 38 25 80 00       	mov    $0x802538,%edx
  800597:	b8 80 40 80 00       	mov    $0x804080,%eax
  80059c:	e8 92 fa ff ff       	call   800033 <check_regs>
}
  8005a1:	83 c4 10             	add    $0x10,%esp
  8005a4:	c9                   	leave  
  8005a5:	c3                   	ret    

008005a6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8005a6:	55                   	push   %ebp
  8005a7:	89 e5                	mov    %esp,%ebp
  8005a9:	56                   	push   %esi
  8005aa:	53                   	push   %ebx
  8005ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8005ae:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8005b1:	e8 07 0b 00 00       	call   8010bd <sys_getenvid>
  8005b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8005bb:	89 c2                	mov    %eax,%edx
  8005bd:	c1 e2 05             	shl    $0x5,%edx
  8005c0:	29 c2                	sub    %eax,%edx
  8005c2:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8005c9:	a3 b0 40 80 00       	mov    %eax,0x8040b0

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005ce:	85 db                	test   %ebx,%ebx
  8005d0:	7e 07                	jle    8005d9 <libmain+0x33>
		binaryname = argv[0];
  8005d2:	8b 06                	mov    (%esi),%eax
  8005d4:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8005d9:	83 ec 08             	sub    $0x8,%esp
  8005dc:	56                   	push   %esi
  8005dd:	53                   	push   %ebx
  8005de:	e8 ac fe ff ff       	call   80048f <umain>

	// exit gracefully
	exit();
  8005e3:	e8 0a 00 00 00       	call   8005f2 <exit>
}
  8005e8:	83 c4 10             	add    $0x10,%esp
  8005eb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005ee:	5b                   	pop    %ebx
  8005ef:	5e                   	pop    %esi
  8005f0:	5d                   	pop    %ebp
  8005f1:	c3                   	ret    

008005f2 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8005f2:	55                   	push   %ebp
  8005f3:	89 e5                	mov    %esp,%ebp
  8005f5:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8005f8:	e8 d4 0f 00 00       	call   8015d1 <close_all>
	sys_env_destroy(0);
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	6a 00                	push   $0x0
  800602:	e8 75 0a 00 00       	call   80107c <sys_env_destroy>
}
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	c9                   	leave  
  80060b:	c3                   	ret    

0080060c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80060c:	55                   	push   %ebp
  80060d:	89 e5                	mov    %esp,%ebp
  80060f:	57                   	push   %edi
  800610:	56                   	push   %esi
  800611:	53                   	push   %ebx
  800612:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800618:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80061b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800621:	e8 97 0a 00 00       	call   8010bd <sys_getenvid>
  800626:	83 ec 04             	sub    $0x4,%esp
  800629:	ff 75 0c             	pushl  0xc(%ebp)
  80062c:	ff 75 08             	pushl  0x8(%ebp)
  80062f:	53                   	push   %ebx
  800630:	50                   	push   %eax
  800631:	68 e0 25 80 00       	push   $0x8025e0
  800636:	68 00 01 00 00       	push   $0x100
  80063b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800641:	56                   	push   %esi
  800642:	e8 93 06 00 00       	call   800cda <snprintf>
  800647:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800649:	83 c4 20             	add    $0x20,%esp
  80064c:	57                   	push   %edi
  80064d:	ff 75 10             	pushl  0x10(%ebp)
  800650:	bf 00 01 00 00       	mov    $0x100,%edi
  800655:	89 f8                	mov    %edi,%eax
  800657:	29 d8                	sub    %ebx,%eax
  800659:	50                   	push   %eax
  80065a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80065d:	50                   	push   %eax
  80065e:	e8 22 06 00 00       	call   800c85 <vsnprintf>
  800663:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800665:	83 c4 0c             	add    $0xc,%esp
  800668:	68 f0 24 80 00       	push   $0x8024f0
  80066d:	29 df                	sub    %ebx,%edi
  80066f:	57                   	push   %edi
  800670:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800673:	50                   	push   %eax
  800674:	e8 61 06 00 00       	call   800cda <snprintf>
	sys_cputs(buf, r);
  800679:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80067c:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80067e:	53                   	push   %ebx
  80067f:	56                   	push   %esi
  800680:	e8 ba 09 00 00       	call   80103f <sys_cputs>
  800685:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800688:	cc                   	int3   
  800689:	eb fd                	jmp    800688 <_panic+0x7c>

0080068b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80068b:	55                   	push   %ebp
  80068c:	89 e5                	mov    %esp,%ebp
  80068e:	53                   	push   %ebx
  80068f:	83 ec 04             	sub    $0x4,%esp
  800692:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800695:	8b 13                	mov    (%ebx),%edx
  800697:	8d 42 01             	lea    0x1(%edx),%eax
  80069a:	89 03                	mov    %eax,(%ebx)
  80069c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80069f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8006a3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006a8:	74 08                	je     8006b2 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8006aa:	ff 43 04             	incl   0x4(%ebx)
}
  8006ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006b0:	c9                   	leave  
  8006b1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	68 ff 00 00 00       	push   $0xff
  8006ba:	8d 43 08             	lea    0x8(%ebx),%eax
  8006bd:	50                   	push   %eax
  8006be:	e8 7c 09 00 00       	call   80103f <sys_cputs>
		b->idx = 0;
  8006c3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	eb dc                	jmp    8006aa <putch+0x1f>

008006ce <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8006d7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8006de:	00 00 00 
	b.cnt = 0;
  8006e1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8006e8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8006f7:	50                   	push   %eax
  8006f8:	68 8b 06 80 00       	push   $0x80068b
  8006fd:	e8 17 01 00 00       	call   800819 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800702:	83 c4 08             	add    $0x8,%esp
  800705:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80070b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800711:	50                   	push   %eax
  800712:	e8 28 09 00 00       	call   80103f <sys_cputs>

	return b.cnt;
}
  800717:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80071d:	c9                   	leave  
  80071e:	c3                   	ret    

0080071f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80071f:	55                   	push   %ebp
  800720:	89 e5                	mov    %esp,%ebp
  800722:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800725:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800728:	50                   	push   %eax
  800729:	ff 75 08             	pushl  0x8(%ebp)
  80072c:	e8 9d ff ff ff       	call   8006ce <vcprintf>
	va_end(ap);

	return cnt;
}
  800731:	c9                   	leave  
  800732:	c3                   	ret    

00800733 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	57                   	push   %edi
  800737:	56                   	push   %esi
  800738:	53                   	push   %ebx
  800739:	83 ec 1c             	sub    $0x1c,%esp
  80073c:	89 c7                	mov    %eax,%edi
  80073e:	89 d6                	mov    %edx,%esi
  800740:	8b 45 08             	mov    0x8(%ebp),%eax
  800743:	8b 55 0c             	mov    0xc(%ebp),%edx
  800746:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800749:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80074c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80074f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800754:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800757:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80075a:	39 d3                	cmp    %edx,%ebx
  80075c:	72 05                	jb     800763 <printnum+0x30>
  80075e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800761:	77 78                	ja     8007db <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	ff 75 18             	pushl  0x18(%ebp)
  800769:	8b 45 14             	mov    0x14(%ebp),%eax
  80076c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80076f:	53                   	push   %ebx
  800770:	ff 75 10             	pushl  0x10(%ebp)
  800773:	83 ec 08             	sub    $0x8,%esp
  800776:	ff 75 e4             	pushl  -0x1c(%ebp)
  800779:	ff 75 e0             	pushl  -0x20(%ebp)
  80077c:	ff 75 dc             	pushl  -0x24(%ebp)
  80077f:	ff 75 d8             	pushl  -0x28(%ebp)
  800782:	e8 ed 1a 00 00       	call   802274 <__udivdi3>
  800787:	83 c4 18             	add    $0x18,%esp
  80078a:	52                   	push   %edx
  80078b:	50                   	push   %eax
  80078c:	89 f2                	mov    %esi,%edx
  80078e:	89 f8                	mov    %edi,%eax
  800790:	e8 9e ff ff ff       	call   800733 <printnum>
  800795:	83 c4 20             	add    $0x20,%esp
  800798:	eb 11                	jmp    8007ab <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80079a:	83 ec 08             	sub    $0x8,%esp
  80079d:	56                   	push   %esi
  80079e:	ff 75 18             	pushl  0x18(%ebp)
  8007a1:	ff d7                	call   *%edi
  8007a3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8007a6:	4b                   	dec    %ebx
  8007a7:	85 db                	test   %ebx,%ebx
  8007a9:	7f ef                	jg     80079a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	56                   	push   %esi
  8007af:	83 ec 04             	sub    $0x4,%esp
  8007b2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8007b5:	ff 75 e0             	pushl  -0x20(%ebp)
  8007b8:	ff 75 dc             	pushl  -0x24(%ebp)
  8007bb:	ff 75 d8             	pushl  -0x28(%ebp)
  8007be:	e8 c1 1b 00 00       	call   802384 <__umoddi3>
  8007c3:	83 c4 14             	add    $0x14,%esp
  8007c6:	0f be 80 03 26 80 00 	movsbl 0x802603(%eax),%eax
  8007cd:	50                   	push   %eax
  8007ce:	ff d7                	call   *%edi
}
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007d6:	5b                   	pop    %ebx
  8007d7:	5e                   	pop    %esi
  8007d8:	5f                   	pop    %edi
  8007d9:	5d                   	pop    %ebp
  8007da:	c3                   	ret    
  8007db:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8007de:	eb c6                	jmp    8007a6 <printnum+0x73>

008007e0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8007e0:	55                   	push   %ebp
  8007e1:	89 e5                	mov    %esp,%ebp
  8007e3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8007e6:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8007e9:	8b 10                	mov    (%eax),%edx
  8007eb:	3b 50 04             	cmp    0x4(%eax),%edx
  8007ee:	73 0a                	jae    8007fa <sprintputch+0x1a>
		*b->buf++ = ch;
  8007f0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8007f3:	89 08                	mov    %ecx,(%eax)
  8007f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f8:	88 02                	mov    %al,(%edx)
}
  8007fa:	5d                   	pop    %ebp
  8007fb:	c3                   	ret    

008007fc <printfmt>:
{
  8007fc:	55                   	push   %ebp
  8007fd:	89 e5                	mov    %esp,%ebp
  8007ff:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800805:	50                   	push   %eax
  800806:	ff 75 10             	pushl  0x10(%ebp)
  800809:	ff 75 0c             	pushl  0xc(%ebp)
  80080c:	ff 75 08             	pushl  0x8(%ebp)
  80080f:	e8 05 00 00 00       	call   800819 <vprintfmt>
}
  800814:	83 c4 10             	add    $0x10,%esp
  800817:	c9                   	leave  
  800818:	c3                   	ret    

00800819 <vprintfmt>:
{
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	57                   	push   %edi
  80081d:	56                   	push   %esi
  80081e:	53                   	push   %ebx
  80081f:	83 ec 2c             	sub    $0x2c,%esp
  800822:	8b 75 08             	mov    0x8(%ebp),%esi
  800825:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800828:	8b 7d 10             	mov    0x10(%ebp),%edi
  80082b:	e9 ae 03 00 00       	jmp    800bde <vprintfmt+0x3c5>
  800830:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800834:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80083b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800842:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800849:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80084e:	8d 47 01             	lea    0x1(%edi),%eax
  800851:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800854:	8a 17                	mov    (%edi),%dl
  800856:	8d 42 dd             	lea    -0x23(%edx),%eax
  800859:	3c 55                	cmp    $0x55,%al
  80085b:	0f 87 fe 03 00 00    	ja     800c5f <vprintfmt+0x446>
  800861:	0f b6 c0             	movzbl %al,%eax
  800864:	ff 24 85 40 27 80 00 	jmp    *0x802740(,%eax,4)
  80086b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80086e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800872:	eb da                	jmp    80084e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800874:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800877:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80087b:	eb d1                	jmp    80084e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80087d:	0f b6 d2             	movzbl %dl,%edx
  800880:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800883:	b8 00 00 00 00       	mov    $0x0,%eax
  800888:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80088b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80088e:	01 c0                	add    %eax,%eax
  800890:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800894:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800897:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80089a:	83 f9 09             	cmp    $0x9,%ecx
  80089d:	77 52                	ja     8008f1 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80089f:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8008a0:	eb e9                	jmp    80088b <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	8b 00                	mov    (%eax),%eax
  8008a7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	8d 40 04             	lea    0x4(%eax),%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8008b3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8008b6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008ba:	79 92                	jns    80084e <vprintfmt+0x35>
				width = precision, precision = -1;
  8008bc:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8008bf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008c2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8008c9:	eb 83                	jmp    80084e <vprintfmt+0x35>
  8008cb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8008cf:	78 08                	js     8008d9 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8008d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8008d4:	e9 75 ff ff ff       	jmp    80084e <vprintfmt+0x35>
  8008d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008e0:	eb ef                	jmp    8008d1 <vprintfmt+0xb8>
  8008e2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8008e5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8008ec:	e9 5d ff ff ff       	jmp    80084e <vprintfmt+0x35>
  8008f1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8008f4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8008f7:	eb bd                	jmp    8008b6 <vprintfmt+0x9d>
			lflag++;
  8008f9:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8008fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8008fd:	e9 4c ff ff ff       	jmp    80084e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800902:	8b 45 14             	mov    0x14(%ebp),%eax
  800905:	8d 78 04             	lea    0x4(%eax),%edi
  800908:	83 ec 08             	sub    $0x8,%esp
  80090b:	53                   	push   %ebx
  80090c:	ff 30                	pushl  (%eax)
  80090e:	ff d6                	call   *%esi
			break;
  800910:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800913:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800916:	e9 c0 02 00 00       	jmp    800bdb <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80091b:	8b 45 14             	mov    0x14(%ebp),%eax
  80091e:	8d 78 04             	lea    0x4(%eax),%edi
  800921:	8b 00                	mov    (%eax),%eax
  800923:	85 c0                	test   %eax,%eax
  800925:	78 2a                	js     800951 <vprintfmt+0x138>
  800927:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800929:	83 f8 0f             	cmp    $0xf,%eax
  80092c:	7f 27                	jg     800955 <vprintfmt+0x13c>
  80092e:	8b 04 85 a0 28 80 00 	mov    0x8028a0(,%eax,4),%eax
  800935:	85 c0                	test   %eax,%eax
  800937:	74 1c                	je     800955 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800939:	50                   	push   %eax
  80093a:	68 d1 29 80 00       	push   $0x8029d1
  80093f:	53                   	push   %ebx
  800940:	56                   	push   %esi
  800941:	e8 b6 fe ff ff       	call   8007fc <printfmt>
  800946:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800949:	89 7d 14             	mov    %edi,0x14(%ebp)
  80094c:	e9 8a 02 00 00       	jmp    800bdb <vprintfmt+0x3c2>
  800951:	f7 d8                	neg    %eax
  800953:	eb d2                	jmp    800927 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800955:	52                   	push   %edx
  800956:	68 1b 26 80 00       	push   $0x80261b
  80095b:	53                   	push   %ebx
  80095c:	56                   	push   %esi
  80095d:	e8 9a fe ff ff       	call   8007fc <printfmt>
  800962:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800965:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800968:	e9 6e 02 00 00       	jmp    800bdb <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80096d:	8b 45 14             	mov    0x14(%ebp),%eax
  800970:	83 c0 04             	add    $0x4,%eax
  800973:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800976:	8b 45 14             	mov    0x14(%ebp),%eax
  800979:	8b 38                	mov    (%eax),%edi
  80097b:	85 ff                	test   %edi,%edi
  80097d:	74 39                	je     8009b8 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80097f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800983:	0f 8e a9 00 00 00    	jle    800a32 <vprintfmt+0x219>
  800989:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80098d:	0f 84 a7 00 00 00    	je     800a3a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800993:	83 ec 08             	sub    $0x8,%esp
  800996:	ff 75 d0             	pushl  -0x30(%ebp)
  800999:	57                   	push   %edi
  80099a:	e8 6b 03 00 00       	call   800d0a <strnlen>
  80099f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8009a2:	29 c1                	sub    %eax,%ecx
  8009a4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8009a7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8009aa:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8009ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8009b1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8009b4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009b6:	eb 14                	jmp    8009cc <vprintfmt+0x1b3>
				p = "(null)";
  8009b8:	bf 14 26 80 00       	mov    $0x802614,%edi
  8009bd:	eb c0                	jmp    80097f <vprintfmt+0x166>
					putch(padc, putdat);
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	53                   	push   %ebx
  8009c3:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8009c8:	4f                   	dec    %edi
  8009c9:	83 c4 10             	add    $0x10,%esp
  8009cc:	85 ff                	test   %edi,%edi
  8009ce:	7f ef                	jg     8009bf <vprintfmt+0x1a6>
  8009d0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8009d3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009d6:	89 c8                	mov    %ecx,%eax
  8009d8:	85 c9                	test   %ecx,%ecx
  8009da:	78 10                	js     8009ec <vprintfmt+0x1d3>
  8009dc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8009df:	29 c1                	sub    %eax,%ecx
  8009e1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8009e4:	89 75 08             	mov    %esi,0x8(%ebp)
  8009e7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8009ea:	eb 15                	jmp    800a01 <vprintfmt+0x1e8>
  8009ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8009f1:	eb e9                	jmp    8009dc <vprintfmt+0x1c3>
					putch(ch, putdat);
  8009f3:	83 ec 08             	sub    $0x8,%esp
  8009f6:	53                   	push   %ebx
  8009f7:	52                   	push   %edx
  8009f8:	ff 55 08             	call   *0x8(%ebp)
  8009fb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009fe:	ff 4d e0             	decl   -0x20(%ebp)
  800a01:	47                   	inc    %edi
  800a02:	8a 47 ff             	mov    -0x1(%edi),%al
  800a05:	0f be d0             	movsbl %al,%edx
  800a08:	85 d2                	test   %edx,%edx
  800a0a:	74 59                	je     800a65 <vprintfmt+0x24c>
  800a0c:	85 f6                	test   %esi,%esi
  800a0e:	78 03                	js     800a13 <vprintfmt+0x1fa>
  800a10:	4e                   	dec    %esi
  800a11:	78 2f                	js     800a42 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800a13:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800a17:	74 da                	je     8009f3 <vprintfmt+0x1da>
  800a19:	0f be c0             	movsbl %al,%eax
  800a1c:	83 e8 20             	sub    $0x20,%eax
  800a1f:	83 f8 5e             	cmp    $0x5e,%eax
  800a22:	76 cf                	jbe    8009f3 <vprintfmt+0x1da>
					putch('?', putdat);
  800a24:	83 ec 08             	sub    $0x8,%esp
  800a27:	53                   	push   %ebx
  800a28:	6a 3f                	push   $0x3f
  800a2a:	ff 55 08             	call   *0x8(%ebp)
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb cc                	jmp    8009fe <vprintfmt+0x1e5>
  800a32:	89 75 08             	mov    %esi,0x8(%ebp)
  800a35:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a38:	eb c7                	jmp    800a01 <vprintfmt+0x1e8>
  800a3a:	89 75 08             	mov    %esi,0x8(%ebp)
  800a3d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800a40:	eb bf                	jmp    800a01 <vprintfmt+0x1e8>
  800a42:	8b 75 08             	mov    0x8(%ebp),%esi
  800a45:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a48:	eb 0c                	jmp    800a56 <vprintfmt+0x23d>
				putch(' ', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	53                   	push   %ebx
  800a4e:	6a 20                	push   $0x20
  800a50:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800a52:	4f                   	dec    %edi
  800a53:	83 c4 10             	add    $0x10,%esp
  800a56:	85 ff                	test   %edi,%edi
  800a58:	7f f0                	jg     800a4a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800a5a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
  800a60:	e9 76 01 00 00       	jmp    800bdb <vprintfmt+0x3c2>
  800a65:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800a68:	8b 75 08             	mov    0x8(%ebp),%esi
  800a6b:	eb e9                	jmp    800a56 <vprintfmt+0x23d>
	if (lflag >= 2)
  800a6d:	83 f9 01             	cmp    $0x1,%ecx
  800a70:	7f 1f                	jg     800a91 <vprintfmt+0x278>
	else if (lflag)
  800a72:	85 c9                	test   %ecx,%ecx
  800a74:	75 48                	jne    800abe <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800a76:	8b 45 14             	mov    0x14(%ebp),%eax
  800a79:	8b 00                	mov    (%eax),%eax
  800a7b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a7e:	89 c1                	mov    %eax,%ecx
  800a80:	c1 f9 1f             	sar    $0x1f,%ecx
  800a83:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800a86:	8b 45 14             	mov    0x14(%ebp),%eax
  800a89:	8d 40 04             	lea    0x4(%eax),%eax
  800a8c:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8f:	eb 17                	jmp    800aa8 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800a91:	8b 45 14             	mov    0x14(%ebp),%eax
  800a94:	8b 50 04             	mov    0x4(%eax),%edx
  800a97:	8b 00                	mov    (%eax),%eax
  800a99:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800a9c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800a9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa2:	8d 40 08             	lea    0x8(%eax),%eax
  800aa5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800aa8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800aab:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800aae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800ab2:	78 25                	js     800ad9 <vprintfmt+0x2c0>
			base = 10;
  800ab4:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ab9:	e9 03 01 00 00       	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800abe:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac1:	8b 00                	mov    (%eax),%eax
  800ac3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800ac6:	89 c1                	mov    %eax,%ecx
  800ac8:	c1 f9 1f             	sar    $0x1f,%ecx
  800acb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800ace:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad1:	8d 40 04             	lea    0x4(%eax),%eax
  800ad4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad7:	eb cf                	jmp    800aa8 <vprintfmt+0x28f>
				putch('-', putdat);
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	53                   	push   %ebx
  800add:	6a 2d                	push   $0x2d
  800adf:	ff d6                	call   *%esi
				num = -(long long) num;
  800ae1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ae4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ae7:	f7 da                	neg    %edx
  800ae9:	83 d1 00             	adc    $0x0,%ecx
  800aec:	f7 d9                	neg    %ecx
  800aee:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800af1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800af6:	e9 c6 00 00 00       	jmp    800bc1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800afb:	83 f9 01             	cmp    $0x1,%ecx
  800afe:	7f 1e                	jg     800b1e <vprintfmt+0x305>
	else if (lflag)
  800b00:	85 c9                	test   %ecx,%ecx
  800b02:	75 32                	jne    800b36 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800b04:	8b 45 14             	mov    0x14(%ebp),%eax
  800b07:	8b 10                	mov    (%eax),%edx
  800b09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0e:	8d 40 04             	lea    0x4(%eax),%eax
  800b11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b14:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b19:	e9 a3 00 00 00       	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b21:	8b 10                	mov    (%eax),%edx
  800b23:	8b 48 04             	mov    0x4(%eax),%ecx
  800b26:	8d 40 08             	lea    0x8(%eax),%eax
  800b29:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b2c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b31:	e9 8b 00 00 00       	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800b36:	8b 45 14             	mov    0x14(%ebp),%eax
  800b39:	8b 10                	mov    (%eax),%edx
  800b3b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b40:	8d 40 04             	lea    0x4(%eax),%eax
  800b43:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800b46:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b4b:	eb 74                	jmp    800bc1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800b4d:	83 f9 01             	cmp    $0x1,%ecx
  800b50:	7f 1b                	jg     800b6d <vprintfmt+0x354>
	else if (lflag)
  800b52:	85 c9                	test   %ecx,%ecx
  800b54:	75 2c                	jne    800b82 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800b56:	8b 45 14             	mov    0x14(%ebp),%eax
  800b59:	8b 10                	mov    (%eax),%edx
  800b5b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b60:	8d 40 04             	lea    0x4(%eax),%eax
  800b63:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b66:	b8 08 00 00 00       	mov    $0x8,%eax
  800b6b:	eb 54                	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800b70:	8b 10                	mov    (%eax),%edx
  800b72:	8b 48 04             	mov    0x4(%eax),%ecx
  800b75:	8d 40 08             	lea    0x8(%eax),%eax
  800b78:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b7b:	b8 08 00 00 00       	mov    $0x8,%eax
  800b80:	eb 3f                	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800b82:	8b 45 14             	mov    0x14(%ebp),%eax
  800b85:	8b 10                	mov    (%eax),%edx
  800b87:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b8c:	8d 40 04             	lea    0x4(%eax),%eax
  800b8f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800b92:	b8 08 00 00 00       	mov    $0x8,%eax
  800b97:	eb 28                	jmp    800bc1 <vprintfmt+0x3a8>
			putch('0', putdat);
  800b99:	83 ec 08             	sub    $0x8,%esp
  800b9c:	53                   	push   %ebx
  800b9d:	6a 30                	push   $0x30
  800b9f:	ff d6                	call   *%esi
			putch('x', putdat);
  800ba1:	83 c4 08             	add    $0x8,%esp
  800ba4:	53                   	push   %ebx
  800ba5:	6a 78                	push   $0x78
  800ba7:	ff d6                	call   *%esi
			num = (unsigned long long)
  800ba9:	8b 45 14             	mov    0x14(%ebp),%eax
  800bac:	8b 10                	mov    (%eax),%edx
  800bae:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800bb3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800bb6:	8d 40 04             	lea    0x4(%eax),%eax
  800bb9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800bbc:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800bc1:	83 ec 0c             	sub    $0xc,%esp
  800bc4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800bc8:	57                   	push   %edi
  800bc9:	ff 75 e0             	pushl  -0x20(%ebp)
  800bcc:	50                   	push   %eax
  800bcd:	51                   	push   %ecx
  800bce:	52                   	push   %edx
  800bcf:	89 da                	mov    %ebx,%edx
  800bd1:	89 f0                	mov    %esi,%eax
  800bd3:	e8 5b fb ff ff       	call   800733 <printnum>
			break;
  800bd8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800bdb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bde:	47                   	inc    %edi
  800bdf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800be3:	83 f8 25             	cmp    $0x25,%eax
  800be6:	0f 84 44 fc ff ff    	je     800830 <vprintfmt+0x17>
			if (ch == '\0')
  800bec:	85 c0                	test   %eax,%eax
  800bee:	0f 84 89 00 00 00    	je     800c7d <vprintfmt+0x464>
			putch(ch, putdat);
  800bf4:	83 ec 08             	sub    $0x8,%esp
  800bf7:	53                   	push   %ebx
  800bf8:	50                   	push   %eax
  800bf9:	ff d6                	call   *%esi
  800bfb:	83 c4 10             	add    $0x10,%esp
  800bfe:	eb de                	jmp    800bde <vprintfmt+0x3c5>
	if (lflag >= 2)
  800c00:	83 f9 01             	cmp    $0x1,%ecx
  800c03:	7f 1b                	jg     800c20 <vprintfmt+0x407>
	else if (lflag)
  800c05:	85 c9                	test   %ecx,%ecx
  800c07:	75 2c                	jne    800c35 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800c09:	8b 45 14             	mov    0x14(%ebp),%eax
  800c0c:	8b 10                	mov    (%eax),%edx
  800c0e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c13:	8d 40 04             	lea    0x4(%eax),%eax
  800c16:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c19:	b8 10 00 00 00       	mov    $0x10,%eax
  800c1e:	eb a1                	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800c20:	8b 45 14             	mov    0x14(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 48 04             	mov    0x4(%eax),%ecx
  800c28:	8d 40 08             	lea    0x8(%eax),%eax
  800c2b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c2e:	b8 10 00 00 00       	mov    $0x10,%eax
  800c33:	eb 8c                	jmp    800bc1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800c35:	8b 45 14             	mov    0x14(%ebp),%eax
  800c38:	8b 10                	mov    (%eax),%edx
  800c3a:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3f:	8d 40 04             	lea    0x4(%eax),%eax
  800c42:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c45:	b8 10 00 00 00       	mov    $0x10,%eax
  800c4a:	e9 72 ff ff ff       	jmp    800bc1 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800c4f:	83 ec 08             	sub    $0x8,%esp
  800c52:	53                   	push   %ebx
  800c53:	6a 25                	push   $0x25
  800c55:	ff d6                	call   *%esi
			break;
  800c57:	83 c4 10             	add    $0x10,%esp
  800c5a:	e9 7c ff ff ff       	jmp    800bdb <vprintfmt+0x3c2>
			putch('%', putdat);
  800c5f:	83 ec 08             	sub    $0x8,%esp
  800c62:	53                   	push   %ebx
  800c63:	6a 25                	push   $0x25
  800c65:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c67:	83 c4 10             	add    $0x10,%esp
  800c6a:	89 f8                	mov    %edi,%eax
  800c6c:	eb 01                	jmp    800c6f <vprintfmt+0x456>
  800c6e:	48                   	dec    %eax
  800c6f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800c73:	75 f9                	jne    800c6e <vprintfmt+0x455>
  800c75:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c78:	e9 5e ff ff ff       	jmp    800bdb <vprintfmt+0x3c2>
}
  800c7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c80:	5b                   	pop    %ebx
  800c81:	5e                   	pop    %esi
  800c82:	5f                   	pop    %edi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
  800c88:	83 ec 18             	sub    $0x18,%esp
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c91:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c94:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800c98:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800c9b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ca2:	85 c0                	test   %eax,%eax
  800ca4:	74 26                	je     800ccc <vsnprintf+0x47>
  800ca6:	85 d2                	test   %edx,%edx
  800ca8:	7e 29                	jle    800cd3 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800caa:	ff 75 14             	pushl  0x14(%ebp)
  800cad:	ff 75 10             	pushl  0x10(%ebp)
  800cb0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cb3:	50                   	push   %eax
  800cb4:	68 e0 07 80 00       	push   $0x8007e0
  800cb9:	e8 5b fb ff ff       	call   800819 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800cbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cc1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800cc7:	83 c4 10             	add    $0x10,%esp
}
  800cca:	c9                   	leave  
  800ccb:	c3                   	ret    
		return -E_INVAL;
  800ccc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd1:	eb f7                	jmp    800cca <vsnprintf+0x45>
  800cd3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800cd8:	eb f0                	jmp    800cca <vsnprintf+0x45>

00800cda <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cda:	55                   	push   %ebp
  800cdb:	89 e5                	mov    %esp,%ebp
  800cdd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ce0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ce3:	50                   	push   %eax
  800ce4:	ff 75 10             	pushl  0x10(%ebp)
  800ce7:	ff 75 0c             	pushl  0xc(%ebp)
  800cea:	ff 75 08             	pushl  0x8(%ebp)
  800ced:	e8 93 ff ff ff       	call   800c85 <vsnprintf>
	va_end(ap);

	return rc;
}
  800cf2:	c9                   	leave  
  800cf3:	c3                   	ret    

00800cf4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800cf4:	55                   	push   %ebp
  800cf5:	89 e5                	mov    %esp,%ebp
  800cf7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800cfa:	b8 00 00 00 00       	mov    $0x0,%eax
  800cff:	eb 01                	jmp    800d02 <strlen+0xe>
		n++;
  800d01:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800d02:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800d06:	75 f9                	jne    800d01 <strlen+0xd>
	return n;
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800d10:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d13:	b8 00 00 00 00       	mov    $0x0,%eax
  800d18:	eb 01                	jmp    800d1b <strnlen+0x11>
		n++;
  800d1a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d1b:	39 d0                	cmp    %edx,%eax
  800d1d:	74 06                	je     800d25 <strnlen+0x1b>
  800d1f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800d23:	75 f5                	jne    800d1a <strnlen+0x10>
	return n;
}
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	53                   	push   %ebx
  800d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800d31:	89 c2                	mov    %eax,%edx
  800d33:	42                   	inc    %edx
  800d34:	41                   	inc    %ecx
  800d35:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800d38:	88 5a ff             	mov    %bl,-0x1(%edx)
  800d3b:	84 db                	test   %bl,%bl
  800d3d:	75 f4                	jne    800d33 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800d3f:	5b                   	pop    %ebx
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    

00800d42 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	53                   	push   %ebx
  800d46:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800d49:	53                   	push   %ebx
  800d4a:	e8 a5 ff ff ff       	call   800cf4 <strlen>
  800d4f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800d52:	ff 75 0c             	pushl  0xc(%ebp)
  800d55:	01 d8                	add    %ebx,%eax
  800d57:	50                   	push   %eax
  800d58:	e8 ca ff ff ff       	call   800d27 <strcpy>
	return dst;
}
  800d5d:	89 d8                	mov    %ebx,%eax
  800d5f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d62:	c9                   	leave  
  800d63:	c3                   	ret    

00800d64 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800d64:	55                   	push   %ebp
  800d65:	89 e5                	mov    %esp,%ebp
  800d67:	56                   	push   %esi
  800d68:	53                   	push   %ebx
  800d69:	8b 75 08             	mov    0x8(%ebp),%esi
  800d6c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6f:	89 f3                	mov    %esi,%ebx
  800d71:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	89 f2                	mov    %esi,%edx
  800d76:	eb 0c                	jmp    800d84 <strncpy+0x20>
		*dst++ = *src;
  800d78:	42                   	inc    %edx
  800d79:	8a 01                	mov    (%ecx),%al
  800d7b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800d7e:	80 39 01             	cmpb   $0x1,(%ecx)
  800d81:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800d84:	39 da                	cmp    %ebx,%edx
  800d86:	75 f0                	jne    800d78 <strncpy+0x14>
	}
	return ret;
}
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	5b                   	pop    %ebx
  800d8b:	5e                   	pop    %esi
  800d8c:	5d                   	pop    %ebp
  800d8d:	c3                   	ret    

00800d8e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800d8e:	55                   	push   %ebp
  800d8f:	89 e5                	mov    %esp,%ebp
  800d91:	56                   	push   %esi
  800d92:	53                   	push   %ebx
  800d93:	8b 75 08             	mov    0x8(%ebp),%esi
  800d96:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d99:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800d9c:	85 c0                	test   %eax,%eax
  800d9e:	74 20                	je     800dc0 <strlcpy+0x32>
  800da0:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800da4:	89 f0                	mov    %esi,%eax
  800da6:	eb 05                	jmp    800dad <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800da8:	40                   	inc    %eax
  800da9:	42                   	inc    %edx
  800daa:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800dad:	39 d8                	cmp    %ebx,%eax
  800daf:	74 06                	je     800db7 <strlcpy+0x29>
  800db1:	8a 0a                	mov    (%edx),%cl
  800db3:	84 c9                	test   %cl,%cl
  800db5:	75 f1                	jne    800da8 <strlcpy+0x1a>
		*dst = '\0';
  800db7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dba:	29 f0                	sub    %esi,%eax
}
  800dbc:	5b                   	pop    %ebx
  800dbd:	5e                   	pop    %esi
  800dbe:	5d                   	pop    %ebp
  800dbf:	c3                   	ret    
  800dc0:	89 f0                	mov    %esi,%eax
  800dc2:	eb f6                	jmp    800dba <strlcpy+0x2c>

00800dc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dca:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800dcd:	eb 02                	jmp    800dd1 <strcmp+0xd>
		p++, q++;
  800dcf:	41                   	inc    %ecx
  800dd0:	42                   	inc    %edx
	while (*p && *p == *q)
  800dd1:	8a 01                	mov    (%ecx),%al
  800dd3:	84 c0                	test   %al,%al
  800dd5:	74 04                	je     800ddb <strcmp+0x17>
  800dd7:	3a 02                	cmp    (%edx),%al
  800dd9:	74 f4                	je     800dcf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	0f b6 12             	movzbl (%edx),%edx
  800de1:	29 d0                	sub    %edx,%eax
}
  800de3:	5d                   	pop    %ebp
  800de4:	c3                   	ret    

00800de5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800de5:	55                   	push   %ebp
  800de6:	89 e5                	mov    %esp,%ebp
  800de8:	53                   	push   %ebx
  800de9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dec:	8b 55 0c             	mov    0xc(%ebp),%edx
  800def:	89 c3                	mov    %eax,%ebx
  800df1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800df4:	eb 02                	jmp    800df8 <strncmp+0x13>
		n--, p++, q++;
  800df6:	40                   	inc    %eax
  800df7:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800df8:	39 d8                	cmp    %ebx,%eax
  800dfa:	74 15                	je     800e11 <strncmp+0x2c>
  800dfc:	8a 08                	mov    (%eax),%cl
  800dfe:	84 c9                	test   %cl,%cl
  800e00:	74 04                	je     800e06 <strncmp+0x21>
  800e02:	3a 0a                	cmp    (%edx),%cl
  800e04:	74 f0                	je     800df6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e06:	0f b6 00             	movzbl (%eax),%eax
  800e09:	0f b6 12             	movzbl (%edx),%edx
  800e0c:	29 d0                	sub    %edx,%eax
}
  800e0e:	5b                   	pop    %ebx
  800e0f:	5d                   	pop    %ebp
  800e10:	c3                   	ret    
		return 0;
  800e11:	b8 00 00 00 00       	mov    $0x0,%eax
  800e16:	eb f6                	jmp    800e0e <strncmp+0x29>

00800e18 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e18:	55                   	push   %ebp
  800e19:	89 e5                	mov    %esp,%ebp
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800e21:	8a 10                	mov    (%eax),%dl
  800e23:	84 d2                	test   %dl,%dl
  800e25:	74 07                	je     800e2e <strchr+0x16>
		if (*s == c)
  800e27:	38 ca                	cmp    %cl,%dl
  800e29:	74 08                	je     800e33 <strchr+0x1b>
	for (; *s; s++)
  800e2b:	40                   	inc    %eax
  800e2c:	eb f3                	jmp    800e21 <strchr+0x9>
			return (char *) s;
	return 0;
  800e2e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e33:	5d                   	pop    %ebp
  800e34:	c3                   	ret    

00800e35 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e35:	55                   	push   %ebp
  800e36:	89 e5                	mov    %esp,%ebp
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800e3e:	8a 10                	mov    (%eax),%dl
  800e40:	84 d2                	test   %dl,%dl
  800e42:	74 07                	je     800e4b <strfind+0x16>
		if (*s == c)
  800e44:	38 ca                	cmp    %cl,%dl
  800e46:	74 03                	je     800e4b <strfind+0x16>
	for (; *s; s++)
  800e48:	40                   	inc    %eax
  800e49:	eb f3                	jmp    800e3e <strfind+0x9>
			break;
	return (char *) s;
}
  800e4b:	5d                   	pop    %ebp
  800e4c:	c3                   	ret    

00800e4d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	57                   	push   %edi
  800e51:	56                   	push   %esi
  800e52:	53                   	push   %ebx
  800e53:	8b 7d 08             	mov    0x8(%ebp),%edi
  800e56:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800e59:	85 c9                	test   %ecx,%ecx
  800e5b:	74 13                	je     800e70 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800e5d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800e63:	75 05                	jne    800e6a <memset+0x1d>
  800e65:	f6 c1 03             	test   $0x3,%cl
  800e68:	74 0d                	je     800e77 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800e6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6d:	fc                   	cld    
  800e6e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800e70:	89 f8                	mov    %edi,%eax
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    
		c &= 0xFF;
  800e77:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800e7b:	89 d3                	mov    %edx,%ebx
  800e7d:	c1 e3 08             	shl    $0x8,%ebx
  800e80:	89 d0                	mov    %edx,%eax
  800e82:	c1 e0 18             	shl    $0x18,%eax
  800e85:	89 d6                	mov    %edx,%esi
  800e87:	c1 e6 10             	shl    $0x10,%esi
  800e8a:	09 f0                	or     %esi,%eax
  800e8c:	09 c2                	or     %eax,%edx
  800e8e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800e90:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800e93:	89 d0                	mov    %edx,%eax
  800e95:	fc                   	cld    
  800e96:	f3 ab                	rep stos %eax,%es:(%edi)
  800e98:	eb d6                	jmp    800e70 <memset+0x23>

00800e9a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800e9a:	55                   	push   %ebp
  800e9b:	89 e5                	mov    %esp,%ebp
  800e9d:	57                   	push   %edi
  800e9e:	56                   	push   %esi
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ea5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ea8:	39 c6                	cmp    %eax,%esi
  800eaa:	73 33                	jae    800edf <memmove+0x45>
  800eac:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800eaf:	39 d0                	cmp    %edx,%eax
  800eb1:	73 2c                	jae    800edf <memmove+0x45>
		s += n;
		d += n;
  800eb3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800eb6:	89 d6                	mov    %edx,%esi
  800eb8:	09 fe                	or     %edi,%esi
  800eba:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ec0:	75 13                	jne    800ed5 <memmove+0x3b>
  800ec2:	f6 c1 03             	test   $0x3,%cl
  800ec5:	75 0e                	jne    800ed5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ec7:	83 ef 04             	sub    $0x4,%edi
  800eca:	8d 72 fc             	lea    -0x4(%edx),%esi
  800ecd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ed0:	fd                   	std    
  800ed1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800ed3:	eb 07                	jmp    800edc <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800ed5:	4f                   	dec    %edi
  800ed6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800ed9:	fd                   	std    
  800eda:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800edc:	fc                   	cld    
  800edd:	eb 13                	jmp    800ef2 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800edf:	89 f2                	mov    %esi,%edx
  800ee1:	09 c2                	or     %eax,%edx
  800ee3:	f6 c2 03             	test   $0x3,%dl
  800ee6:	75 05                	jne    800eed <memmove+0x53>
  800ee8:	f6 c1 03             	test   $0x3,%cl
  800eeb:	74 09                	je     800ef6 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800eed:	89 c7                	mov    %eax,%edi
  800eef:	fc                   	cld    
  800ef0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800ef6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800ef9:	89 c7                	mov    %eax,%edi
  800efb:	fc                   	cld    
  800efc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800efe:	eb f2                	jmp    800ef2 <memmove+0x58>

00800f00 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800f00:	55                   	push   %ebp
  800f01:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800f03:	ff 75 10             	pushl  0x10(%ebp)
  800f06:	ff 75 0c             	pushl  0xc(%ebp)
  800f09:	ff 75 08             	pushl  0x8(%ebp)
  800f0c:	e8 89 ff ff ff       	call   800e9a <memmove>
}
  800f11:	c9                   	leave  
  800f12:	c3                   	ret    

00800f13 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 c6                	mov    %eax,%esi
  800f1d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800f20:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800f23:	39 f0                	cmp    %esi,%eax
  800f25:	74 16                	je     800f3d <memcmp+0x2a>
		if (*s1 != *s2)
  800f27:	8a 08                	mov    (%eax),%cl
  800f29:	8a 1a                	mov    (%edx),%bl
  800f2b:	38 d9                	cmp    %bl,%cl
  800f2d:	75 04                	jne    800f33 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800f2f:	40                   	inc    %eax
  800f30:	42                   	inc    %edx
  800f31:	eb f0                	jmp    800f23 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800f33:	0f b6 c1             	movzbl %cl,%eax
  800f36:	0f b6 db             	movzbl %bl,%ebx
  800f39:	29 d8                	sub    %ebx,%eax
  800f3b:	eb 05                	jmp    800f42 <memcmp+0x2f>
	}

	return 0;
  800f3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f42:	5b                   	pop    %ebx
  800f43:	5e                   	pop    %esi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800f4f:	89 c2                	mov    %eax,%edx
  800f51:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800f54:	39 d0                	cmp    %edx,%eax
  800f56:	73 07                	jae    800f5f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f58:	38 08                	cmp    %cl,(%eax)
  800f5a:	74 03                	je     800f5f <memfind+0x19>
	for (; s < ends; s++)
  800f5c:	40                   	inc    %eax
  800f5d:	eb f5                	jmp    800f54 <memfind+0xe>
			break;
	return (void *) s;
}
  800f5f:	5d                   	pop    %ebp
  800f60:	c3                   	ret    

00800f61 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f61:	55                   	push   %ebp
  800f62:	89 e5                	mov    %esp,%ebp
  800f64:	57                   	push   %edi
  800f65:	56                   	push   %esi
  800f66:	53                   	push   %ebx
  800f67:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6a:	eb 01                	jmp    800f6d <strtol+0xc>
		s++;
  800f6c:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800f6d:	8a 01                	mov    (%ecx),%al
  800f6f:	3c 20                	cmp    $0x20,%al
  800f71:	74 f9                	je     800f6c <strtol+0xb>
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 f5                	je     800f6c <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800f77:	3c 2b                	cmp    $0x2b,%al
  800f79:	74 2b                	je     800fa6 <strtol+0x45>
		s++;
	else if (*s == '-')
  800f7b:	3c 2d                	cmp    $0x2d,%al
  800f7d:	74 2f                	je     800fae <strtol+0x4d>
	int neg = 0;
  800f7f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f84:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800f8b:	75 12                	jne    800f9f <strtol+0x3e>
  800f8d:	80 39 30             	cmpb   $0x30,(%ecx)
  800f90:	74 24                	je     800fb6 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800f92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f96:	75 07                	jne    800f9f <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800f98:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800f9f:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa4:	eb 4e                	jmp    800ff4 <strtol+0x93>
		s++;
  800fa6:	41                   	inc    %ecx
	int neg = 0;
  800fa7:	bf 00 00 00 00       	mov    $0x0,%edi
  800fac:	eb d6                	jmp    800f84 <strtol+0x23>
		s++, neg = 1;
  800fae:	41                   	inc    %ecx
  800faf:	bf 01 00 00 00       	mov    $0x1,%edi
  800fb4:	eb ce                	jmp    800f84 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800fba:	74 10                	je     800fcc <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800fbc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc0:	75 dd                	jne    800f9f <strtol+0x3e>
		s++, base = 8;
  800fc2:	41                   	inc    %ecx
  800fc3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fca:	eb d3                	jmp    800f9f <strtol+0x3e>
		s += 2, base = 16;
  800fcc:	83 c1 02             	add    $0x2,%ecx
  800fcf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fd6:	eb c7                	jmp    800f9f <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800fd8:	8d 72 9f             	lea    -0x61(%edx),%esi
  800fdb:	89 f3                	mov    %esi,%ebx
  800fdd:	80 fb 19             	cmp    $0x19,%bl
  800fe0:	77 24                	ja     801006 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800fe2:	0f be d2             	movsbl %dl,%edx
  800fe5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800fe8:	3b 55 10             	cmp    0x10(%ebp),%edx
  800feb:	7d 2b                	jge    801018 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800fed:	41                   	inc    %ecx
  800fee:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ff2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ff4:	8a 11                	mov    (%ecx),%dl
  800ff6:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ff9:	80 fb 09             	cmp    $0x9,%bl
  800ffc:	77 da                	ja     800fd8 <strtol+0x77>
			dig = *s - '0';
  800ffe:	0f be d2             	movsbl %dl,%edx
  801001:	83 ea 30             	sub    $0x30,%edx
  801004:	eb e2                	jmp    800fe8 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801006:	8d 72 bf             	lea    -0x41(%edx),%esi
  801009:	89 f3                	mov    %esi,%ebx
  80100b:	80 fb 19             	cmp    $0x19,%bl
  80100e:	77 08                	ja     801018 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801010:	0f be d2             	movsbl %dl,%edx
  801013:	83 ea 37             	sub    $0x37,%edx
  801016:	eb d0                	jmp    800fe8 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801018:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101c:	74 05                	je     801023 <strtol+0xc2>
		*endptr = (char *) s;
  80101e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801021:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801023:	85 ff                	test   %edi,%edi
  801025:	74 02                	je     801029 <strtol+0xc8>
  801027:	f7 d8                	neg    %eax
}
  801029:	5b                   	pop    %ebx
  80102a:	5e                   	pop    %esi
  80102b:	5f                   	pop    %edi
  80102c:	5d                   	pop    %ebp
  80102d:	c3                   	ret    

0080102e <atoi>:

int
atoi(const char *s)
{
  80102e:	55                   	push   %ebp
  80102f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801031:	6a 0a                	push   $0xa
  801033:	6a 00                	push   $0x0
  801035:	ff 75 08             	pushl  0x8(%ebp)
  801038:	e8 24 ff ff ff       	call   800f61 <strtol>
}
  80103d:	c9                   	leave  
  80103e:	c3                   	ret    

0080103f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80103f:	55                   	push   %ebp
  801040:	89 e5                	mov    %esp,%ebp
  801042:	57                   	push   %edi
  801043:	56                   	push   %esi
  801044:	53                   	push   %ebx
	asm volatile("int %1\n"
  801045:	b8 00 00 00 00       	mov    $0x0,%eax
  80104a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	89 c3                	mov    %eax,%ebx
  801052:	89 c7                	mov    %eax,%edi
  801054:	89 c6                	mov    %eax,%esi
  801056:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  801058:	5b                   	pop    %ebx
  801059:	5e                   	pop    %esi
  80105a:	5f                   	pop    %edi
  80105b:	5d                   	pop    %ebp
  80105c:	c3                   	ret    

0080105d <sys_cgetc>:

int
sys_cgetc(void)
{
  80105d:	55                   	push   %ebp
  80105e:	89 e5                	mov    %esp,%ebp
  801060:	57                   	push   %edi
  801061:	56                   	push   %esi
  801062:	53                   	push   %ebx
	asm volatile("int %1\n"
  801063:	ba 00 00 00 00       	mov    $0x0,%edx
  801068:	b8 01 00 00 00       	mov    $0x1,%eax
  80106d:	89 d1                	mov    %edx,%ecx
  80106f:	89 d3                	mov    %edx,%ebx
  801071:	89 d7                	mov    %edx,%edi
  801073:	89 d6                	mov    %edx,%esi
  801075:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801077:	5b                   	pop    %ebx
  801078:	5e                   	pop    %esi
  801079:	5f                   	pop    %edi
  80107a:	5d                   	pop    %ebp
  80107b:	c3                   	ret    

0080107c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80107c:	55                   	push   %ebp
  80107d:	89 e5                	mov    %esp,%ebp
  80107f:	57                   	push   %edi
  801080:	56                   	push   %esi
  801081:	53                   	push   %ebx
  801082:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801085:	b9 00 00 00 00       	mov    $0x0,%ecx
  80108a:	b8 03 00 00 00       	mov    $0x3,%eax
  80108f:	8b 55 08             	mov    0x8(%ebp),%edx
  801092:	89 cb                	mov    %ecx,%ebx
  801094:	89 cf                	mov    %ecx,%edi
  801096:	89 ce                	mov    %ecx,%esi
  801098:	cd 30                	int    $0x30
	if(check && ret > 0)
  80109a:	85 c0                	test   %eax,%eax
  80109c:	7f 08                	jg     8010a6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a1:	5b                   	pop    %ebx
  8010a2:	5e                   	pop    %esi
  8010a3:	5f                   	pop    %edi
  8010a4:	5d                   	pop    %ebp
  8010a5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010a6:	83 ec 0c             	sub    $0xc,%esp
  8010a9:	50                   	push   %eax
  8010aa:	6a 03                	push   $0x3
  8010ac:	68 ff 28 80 00       	push   $0x8028ff
  8010b1:	6a 23                	push   $0x23
  8010b3:	68 1c 29 80 00       	push   $0x80291c
  8010b8:	e8 4f f5 ff ff       	call   80060c <_panic>

008010bd <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  8010bd:	55                   	push   %ebp
  8010be:	89 e5                	mov    %esp,%ebp
  8010c0:	57                   	push   %edi
  8010c1:	56                   	push   %esi
  8010c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010c8:	b8 02 00 00 00       	mov    $0x2,%eax
  8010cd:	89 d1                	mov    %edx,%ecx
  8010cf:	89 d3                	mov    %edx,%ebx
  8010d1:	89 d7                	mov    %edx,%edi
  8010d3:	89 d6                	mov    %edx,%esi
  8010d5:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  8010d7:	5b                   	pop    %ebx
  8010d8:	5e                   	pop    %esi
  8010d9:	5f                   	pop    %edi
  8010da:	5d                   	pop    %ebp
  8010db:	c3                   	ret    

008010dc <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  8010dc:	55                   	push   %ebp
  8010dd:	89 e5                	mov    %esp,%ebp
  8010df:	57                   	push   %edi
  8010e0:	56                   	push   %esi
  8010e1:	53                   	push   %ebx
  8010e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010e5:	be 00 00 00 00       	mov    $0x0,%esi
  8010ea:	b8 04 00 00 00       	mov    $0x4,%eax
  8010ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010f8:	89 f7                	mov    %esi,%edi
  8010fa:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	7f 08                	jg     801108 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801100:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801103:	5b                   	pop    %ebx
  801104:	5e                   	pop    %esi
  801105:	5f                   	pop    %edi
  801106:	5d                   	pop    %ebp
  801107:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801108:	83 ec 0c             	sub    $0xc,%esp
  80110b:	50                   	push   %eax
  80110c:	6a 04                	push   $0x4
  80110e:	68 ff 28 80 00       	push   $0x8028ff
  801113:	6a 23                	push   $0x23
  801115:	68 1c 29 80 00       	push   $0x80291c
  80111a:	e8 ed f4 ff ff       	call   80060c <_panic>

0080111f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
  801125:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801128:	b8 05 00 00 00       	mov    $0x5,%eax
  80112d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801130:	8b 55 08             	mov    0x8(%ebp),%edx
  801133:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801136:	8b 7d 14             	mov    0x14(%ebp),%edi
  801139:	8b 75 18             	mov    0x18(%ebp),%esi
  80113c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80113e:	85 c0                	test   %eax,%eax
  801140:	7f 08                	jg     80114a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801142:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80114a:	83 ec 0c             	sub    $0xc,%esp
  80114d:	50                   	push   %eax
  80114e:	6a 05                	push   $0x5
  801150:	68 ff 28 80 00       	push   $0x8028ff
  801155:	6a 23                	push   $0x23
  801157:	68 1c 29 80 00       	push   $0x80291c
  80115c:	e8 ab f4 ff ff       	call   80060c <_panic>

00801161 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801161:	55                   	push   %ebp
  801162:	89 e5                	mov    %esp,%ebp
  801164:	57                   	push   %edi
  801165:	56                   	push   %esi
  801166:	53                   	push   %ebx
  801167:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80116a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80116f:	b8 06 00 00 00       	mov    $0x6,%eax
  801174:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801177:	8b 55 08             	mov    0x8(%ebp),%edx
  80117a:	89 df                	mov    %ebx,%edi
  80117c:	89 de                	mov    %ebx,%esi
  80117e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801180:	85 c0                	test   %eax,%eax
  801182:	7f 08                	jg     80118c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801184:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80118c:	83 ec 0c             	sub    $0xc,%esp
  80118f:	50                   	push   %eax
  801190:	6a 06                	push   $0x6
  801192:	68 ff 28 80 00       	push   $0x8028ff
  801197:	6a 23                	push   $0x23
  801199:	68 1c 29 80 00       	push   $0x80291c
  80119e:	e8 69 f4 ff ff       	call   80060c <_panic>

008011a3 <sys_yield>:

void
sys_yield(void)
{
  8011a3:	55                   	push   %ebp
  8011a4:	89 e5                	mov    %esp,%ebp
  8011a6:	57                   	push   %edi
  8011a7:	56                   	push   %esi
  8011a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8011ae:	b8 0b 00 00 00       	mov    $0xb,%eax
  8011b3:	89 d1                	mov    %edx,%ecx
  8011b5:	89 d3                	mov    %edx,%ebx
  8011b7:	89 d7                	mov    %edx,%edi
  8011b9:	89 d6                	mov    %edx,%esi
  8011bb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8011bd:	5b                   	pop    %ebx
  8011be:	5e                   	pop    %esi
  8011bf:	5f                   	pop    %edi
  8011c0:	5d                   	pop    %ebp
  8011c1:	c3                   	ret    

008011c2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011cb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d0:	b8 08 00 00 00       	mov    $0x8,%eax
  8011d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8011db:	89 df                	mov    %ebx,%edi
  8011dd:	89 de                	mov    %ebx,%esi
  8011df:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011e1:	85 c0                	test   %eax,%eax
  8011e3:	7f 08                	jg     8011ed <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8011e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011e8:	5b                   	pop    %ebx
  8011e9:	5e                   	pop    %esi
  8011ea:	5f                   	pop    %edi
  8011eb:	5d                   	pop    %ebp
  8011ec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ed:	83 ec 0c             	sub    $0xc,%esp
  8011f0:	50                   	push   %eax
  8011f1:	6a 08                	push   $0x8
  8011f3:	68 ff 28 80 00       	push   $0x8028ff
  8011f8:	6a 23                	push   $0x23
  8011fa:	68 1c 29 80 00       	push   $0x80291c
  8011ff:	e8 08 f4 ff ff       	call   80060c <_panic>

00801204 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  801204:	55                   	push   %ebp
  801205:	89 e5                	mov    %esp,%ebp
  801207:	57                   	push   %edi
  801208:	56                   	push   %esi
  801209:	53                   	push   %ebx
  80120a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80120d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801212:	b8 0c 00 00 00       	mov    $0xc,%eax
  801217:	8b 55 08             	mov    0x8(%ebp),%edx
  80121a:	89 cb                	mov    %ecx,%ebx
  80121c:	89 cf                	mov    %ecx,%edi
  80121e:	89 ce                	mov    %ecx,%esi
  801220:	cd 30                	int    $0x30
	if(check && ret > 0)
  801222:	85 c0                	test   %eax,%eax
  801224:	7f 08                	jg     80122e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  801226:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801229:	5b                   	pop    %ebx
  80122a:	5e                   	pop    %esi
  80122b:	5f                   	pop    %edi
  80122c:	5d                   	pop    %ebp
  80122d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80122e:	83 ec 0c             	sub    $0xc,%esp
  801231:	50                   	push   %eax
  801232:	6a 0c                	push   $0xc
  801234:	68 ff 28 80 00       	push   $0x8028ff
  801239:	6a 23                	push   $0x23
  80123b:	68 1c 29 80 00       	push   $0x80291c
  801240:	e8 c7 f3 ff ff       	call   80060c <_panic>

00801245 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801245:	55                   	push   %ebp
  801246:	89 e5                	mov    %esp,%ebp
  801248:	57                   	push   %edi
  801249:	56                   	push   %esi
  80124a:	53                   	push   %ebx
  80124b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80124e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801253:	b8 09 00 00 00       	mov    $0x9,%eax
  801258:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125b:	8b 55 08             	mov    0x8(%ebp),%edx
  80125e:	89 df                	mov    %ebx,%edi
  801260:	89 de                	mov    %ebx,%esi
  801262:	cd 30                	int    $0x30
	if(check && ret > 0)
  801264:	85 c0                	test   %eax,%eax
  801266:	7f 08                	jg     801270 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801268:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126b:	5b                   	pop    %ebx
  80126c:	5e                   	pop    %esi
  80126d:	5f                   	pop    %edi
  80126e:	5d                   	pop    %ebp
  80126f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	50                   	push   %eax
  801274:	6a 09                	push   $0x9
  801276:	68 ff 28 80 00       	push   $0x8028ff
  80127b:	6a 23                	push   $0x23
  80127d:	68 1c 29 80 00       	push   $0x80291c
  801282:	e8 85 f3 ff ff       	call   80060c <_panic>

00801287 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801287:	55                   	push   %ebp
  801288:	89 e5                	mov    %esp,%ebp
  80128a:	57                   	push   %edi
  80128b:	56                   	push   %esi
  80128c:	53                   	push   %ebx
  80128d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801290:	bb 00 00 00 00       	mov    $0x0,%ebx
  801295:	b8 0a 00 00 00       	mov    $0xa,%eax
  80129a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129d:	8b 55 08             	mov    0x8(%ebp),%edx
  8012a0:	89 df                	mov    %ebx,%edi
  8012a2:	89 de                	mov    %ebx,%esi
  8012a4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	7f 08                	jg     8012b2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8012aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ad:	5b                   	pop    %ebx
  8012ae:	5e                   	pop    %esi
  8012af:	5f                   	pop    %edi
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012b2:	83 ec 0c             	sub    $0xc,%esp
  8012b5:	50                   	push   %eax
  8012b6:	6a 0a                	push   $0xa
  8012b8:	68 ff 28 80 00       	push   $0x8028ff
  8012bd:	6a 23                	push   $0x23
  8012bf:	68 1c 29 80 00       	push   $0x80291c
  8012c4:	e8 43 f3 ff ff       	call   80060c <_panic>

008012c9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8012c9:	55                   	push   %ebp
  8012ca:	89 e5                	mov    %esp,%ebp
  8012cc:	57                   	push   %edi
  8012cd:	56                   	push   %esi
  8012ce:	53                   	push   %ebx
	asm volatile("int %1\n"
  8012cf:	be 00 00 00 00       	mov    $0x0,%esi
  8012d4:	b8 0d 00 00 00       	mov    $0xd,%eax
  8012d9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8012df:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8012e2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8012e5:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8012e7:	5b                   	pop    %ebx
  8012e8:	5e                   	pop    %esi
  8012e9:	5f                   	pop    %edi
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	57                   	push   %edi
  8012f0:	56                   	push   %esi
  8012f1:	53                   	push   %ebx
  8012f2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012f5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012fa:	b8 0e 00 00 00       	mov    $0xe,%eax
  8012ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801302:	89 cb                	mov    %ecx,%ebx
  801304:	89 cf                	mov    %ecx,%edi
  801306:	89 ce                	mov    %ecx,%esi
  801308:	cd 30                	int    $0x30
	if(check && ret > 0)
  80130a:	85 c0                	test   %eax,%eax
  80130c:	7f 08                	jg     801316 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80130e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801311:	5b                   	pop    %ebx
  801312:	5e                   	pop    %esi
  801313:	5f                   	pop    %edi
  801314:	5d                   	pop    %ebp
  801315:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801316:	83 ec 0c             	sub    $0xc,%esp
  801319:	50                   	push   %eax
  80131a:	6a 0e                	push   $0xe
  80131c:	68 ff 28 80 00       	push   $0x8028ff
  801321:	6a 23                	push   $0x23
  801323:	68 1c 29 80 00       	push   $0x80291c
  801328:	e8 df f2 ff ff       	call   80060c <_panic>

0080132d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	57                   	push   %edi
  801331:	56                   	push   %esi
  801332:	53                   	push   %ebx
	asm volatile("int %1\n"
  801333:	be 00 00 00 00       	mov    $0x0,%esi
  801338:	b8 0f 00 00 00       	mov    $0xf,%eax
  80133d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801340:	8b 55 08             	mov    0x8(%ebp),%edx
  801343:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801346:	89 f7                	mov    %esi,%edi
  801348:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80134a:	5b                   	pop    %ebx
  80134b:	5e                   	pop    %esi
  80134c:	5f                   	pop    %edi
  80134d:	5d                   	pop    %ebp
  80134e:	c3                   	ret    

0080134f <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	57                   	push   %edi
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
	asm volatile("int %1\n"
  801355:	be 00 00 00 00       	mov    $0x0,%esi
  80135a:	b8 10 00 00 00       	mov    $0x10,%eax
  80135f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801368:	89 f7                	mov    %esi,%edi
  80136a:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80136c:	5b                   	pop    %ebx
  80136d:	5e                   	pop    %esi
  80136e:	5f                   	pop    %edi
  80136f:	5d                   	pop    %ebp
  801370:	c3                   	ret    

00801371 <sys_set_console_color>:

void sys_set_console_color(int color) {
  801371:	55                   	push   %ebp
  801372:	89 e5                	mov    %esp,%ebp
  801374:	57                   	push   %edi
  801375:	56                   	push   %esi
  801376:	53                   	push   %ebx
	asm volatile("int %1\n"
  801377:	b9 00 00 00 00       	mov    $0x0,%ecx
  80137c:	b8 11 00 00 00       	mov    $0x11,%eax
  801381:	8b 55 08             	mov    0x8(%ebp),%edx
  801384:	89 cb                	mov    %ecx,%ebx
  801386:	89 cf                	mov    %ecx,%edi
  801388:	89 ce                	mov    %ecx,%esi
  80138a:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  80138c:	5b                   	pop    %ebx
  80138d:	5e                   	pop    %esi
  80138e:	5f                   	pop    %edi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    

00801391 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801391:	55                   	push   %ebp
  801392:	89 e5                	mov    %esp,%ebp
  801394:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801397:	83 3d b4 40 80 00 00 	cmpl   $0x0,0x8040b4
  80139e:	74 0a                	je     8013aa <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8013a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a3:	a3 b4 40 80 00       	mov    %eax,0x8040b4
}
  8013a8:	c9                   	leave  
  8013a9:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  8013aa:	e8 0e fd ff ff       	call   8010bd <sys_getenvid>
  8013af:	83 ec 04             	sub    $0x4,%esp
  8013b2:	6a 07                	push   $0x7
  8013b4:	68 00 f0 bf ee       	push   $0xeebff000
  8013b9:	50                   	push   %eax
  8013ba:	e8 1d fd ff ff       	call   8010dc <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8013bf:	e8 f9 fc ff ff       	call   8010bd <sys_getenvid>
  8013c4:	83 c4 08             	add    $0x8,%esp
  8013c7:	68 d7 13 80 00       	push   $0x8013d7
  8013cc:	50                   	push   %eax
  8013cd:	e8 b5 fe ff ff       	call   801287 <sys_env_set_pgfault_upcall>
  8013d2:	83 c4 10             	add    $0x10,%esp
  8013d5:	eb c9                	jmp    8013a0 <set_pgfault_handler+0xf>

008013d7 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  8013d7:	54                   	push   %esp
	movl _pgfault_handler, %eax
  8013d8:	a1 b4 40 80 00       	mov    0x8040b4,%eax
	call *%eax
  8013dd:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  8013df:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  8013e2:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  8013e6:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  8013ea:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  8013ed:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  8013ef:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  8013f3:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8013f6:	61                   	popa   
	addl $4, %esp
  8013f7:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8013fa:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8013fb:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8013fc:	c3                   	ret    

008013fd <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013fd:	55                   	push   %ebp
  8013fe:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801400:	8b 45 08             	mov    0x8(%ebp),%eax
  801403:	05 00 00 00 30       	add    $0x30000000,%eax
  801408:	c1 e8 0c             	shr    $0xc,%eax
}
  80140b:	5d                   	pop    %ebp
  80140c:	c3                   	ret    

0080140d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80140d:	55                   	push   %ebp
  80140e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801410:	8b 45 08             	mov    0x8(%ebp),%eax
  801413:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801418:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80141d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801422:	5d                   	pop    %ebp
  801423:	c3                   	ret    

00801424 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80142a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80142f:	89 c2                	mov    %eax,%edx
  801431:	c1 ea 16             	shr    $0x16,%edx
  801434:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143b:	f6 c2 01             	test   $0x1,%dl
  80143e:	74 2a                	je     80146a <fd_alloc+0x46>
  801440:	89 c2                	mov    %eax,%edx
  801442:	c1 ea 0c             	shr    $0xc,%edx
  801445:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80144c:	f6 c2 01             	test   $0x1,%dl
  80144f:	74 19                	je     80146a <fd_alloc+0x46>
  801451:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801456:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80145b:	75 d2                	jne    80142f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80145d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801463:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801468:	eb 07                	jmp    801471 <fd_alloc+0x4d>
			*fd_store = fd;
  80146a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80146c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801471:	5d                   	pop    %ebp
  801472:	c3                   	ret    

00801473 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801473:	55                   	push   %ebp
  801474:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801476:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80147a:	77 39                	ja     8014b5 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80147c:	8b 45 08             	mov    0x8(%ebp),%eax
  80147f:	c1 e0 0c             	shl    $0xc,%eax
  801482:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801487:	89 c2                	mov    %eax,%edx
  801489:	c1 ea 16             	shr    $0x16,%edx
  80148c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801493:	f6 c2 01             	test   $0x1,%dl
  801496:	74 24                	je     8014bc <fd_lookup+0x49>
  801498:	89 c2                	mov    %eax,%edx
  80149a:	c1 ea 0c             	shr    $0xc,%edx
  80149d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8014a4:	f6 c2 01             	test   $0x1,%dl
  8014a7:	74 1a                	je     8014c3 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8014a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ac:	89 02                	mov    %eax,(%edx)
	return 0;
  8014ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b3:	5d                   	pop    %ebp
  8014b4:	c3                   	ret    
		return -E_INVAL;
  8014b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ba:	eb f7                	jmp    8014b3 <fd_lookup+0x40>
		return -E_INVAL;
  8014bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c1:	eb f0                	jmp    8014b3 <fd_lookup+0x40>
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb e9                	jmp    8014b3 <fd_lookup+0x40>

008014ca <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 08             	sub    $0x8,%esp
  8014d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8014d3:	ba a8 29 80 00       	mov    $0x8029a8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8014d8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8014dd:	39 08                	cmp    %ecx,(%eax)
  8014df:	74 33                	je     801514 <dev_lookup+0x4a>
  8014e1:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8014e4:	8b 02                	mov    (%edx),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	75 f3                	jne    8014dd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8014ea:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  8014ef:	8b 40 48             	mov    0x48(%eax),%eax
  8014f2:	83 ec 04             	sub    $0x4,%esp
  8014f5:	51                   	push   %ecx
  8014f6:	50                   	push   %eax
  8014f7:	68 2c 29 80 00       	push   $0x80292c
  8014fc:	e8 1e f2 ff ff       	call   80071f <cprintf>
	*dev = 0;
  801501:	8b 45 0c             	mov    0xc(%ebp),%eax
  801504:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80150a:	83 c4 10             	add    $0x10,%esp
  80150d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801512:	c9                   	leave  
  801513:	c3                   	ret    
			*dev = devtab[i];
  801514:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801517:	89 01                	mov    %eax,(%ecx)
			return 0;
  801519:	b8 00 00 00 00       	mov    $0x0,%eax
  80151e:	eb f2                	jmp    801512 <dev_lookup+0x48>

00801520 <fd_close>:
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
  801523:	57                   	push   %edi
  801524:	56                   	push   %esi
  801525:	53                   	push   %ebx
  801526:	83 ec 1c             	sub    $0x1c,%esp
  801529:	8b 75 08             	mov    0x8(%ebp),%esi
  80152c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80152f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801532:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801533:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801539:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80153c:	50                   	push   %eax
  80153d:	e8 31 ff ff ff       	call   801473 <fd_lookup>
  801542:	89 c7                	mov    %eax,%edi
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 05                	js     801550 <fd_close+0x30>
	    || fd != fd2)
  80154b:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80154e:	74 13                	je     801563 <fd_close+0x43>
		return (must_exist ? r : 0);
  801550:	84 db                	test   %bl,%bl
  801552:	75 05                	jne    801559 <fd_close+0x39>
  801554:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801559:	89 f8                	mov    %edi,%eax
  80155b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80155e:	5b                   	pop    %ebx
  80155f:	5e                   	pop    %esi
  801560:	5f                   	pop    %edi
  801561:	5d                   	pop    %ebp
  801562:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801563:	83 ec 08             	sub    $0x8,%esp
  801566:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801569:	50                   	push   %eax
  80156a:	ff 36                	pushl  (%esi)
  80156c:	e8 59 ff ff ff       	call   8014ca <dev_lookup>
  801571:	89 c7                	mov    %eax,%edi
  801573:	83 c4 10             	add    $0x10,%esp
  801576:	85 c0                	test   %eax,%eax
  801578:	78 15                	js     80158f <fd_close+0x6f>
		if (dev->dev_close)
  80157a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80157d:	8b 40 10             	mov    0x10(%eax),%eax
  801580:	85 c0                	test   %eax,%eax
  801582:	74 1b                	je     80159f <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801584:	83 ec 0c             	sub    $0xc,%esp
  801587:	56                   	push   %esi
  801588:	ff d0                	call   *%eax
  80158a:	89 c7                	mov    %eax,%edi
  80158c:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	56                   	push   %esi
  801593:	6a 00                	push   $0x0
  801595:	e8 c7 fb ff ff       	call   801161 <sys_page_unmap>
	return r;
  80159a:	83 c4 10             	add    $0x10,%esp
  80159d:	eb ba                	jmp    801559 <fd_close+0x39>
			r = 0;
  80159f:	bf 00 00 00 00       	mov    $0x0,%edi
  8015a4:	eb e9                	jmp    80158f <fd_close+0x6f>

008015a6 <close>:

int
close(int fdnum)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015af:	50                   	push   %eax
  8015b0:	ff 75 08             	pushl  0x8(%ebp)
  8015b3:	e8 bb fe ff ff       	call   801473 <fd_lookup>
  8015b8:	83 c4 08             	add    $0x8,%esp
  8015bb:	85 c0                	test   %eax,%eax
  8015bd:	78 10                	js     8015cf <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8015bf:	83 ec 08             	sub    $0x8,%esp
  8015c2:	6a 01                	push   $0x1
  8015c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c7:	e8 54 ff ff ff       	call   801520 <fd_close>
  8015cc:	83 c4 10             	add    $0x10,%esp
}
  8015cf:	c9                   	leave  
  8015d0:	c3                   	ret    

008015d1 <close_all>:

void
close_all(void)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	53                   	push   %ebx
  8015d5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8015d8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	53                   	push   %ebx
  8015e1:	e8 c0 ff ff ff       	call   8015a6 <close>
	for (i = 0; i < MAXFD; i++)
  8015e6:	43                   	inc    %ebx
  8015e7:	83 c4 10             	add    $0x10,%esp
  8015ea:	83 fb 20             	cmp    $0x20,%ebx
  8015ed:	75 ee                	jne    8015dd <close_all+0xc>
}
  8015ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	57                   	push   %edi
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
  8015fa:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801600:	50                   	push   %eax
  801601:	ff 75 08             	pushl  0x8(%ebp)
  801604:	e8 6a fe ff ff       	call   801473 <fd_lookup>
  801609:	89 c3                	mov    %eax,%ebx
  80160b:	83 c4 08             	add    $0x8,%esp
  80160e:	85 c0                	test   %eax,%eax
  801610:	0f 88 81 00 00 00    	js     801697 <dup+0xa3>
		return r;
	close(newfdnum);
  801616:	83 ec 0c             	sub    $0xc,%esp
  801619:	ff 75 0c             	pushl  0xc(%ebp)
  80161c:	e8 85 ff ff ff       	call   8015a6 <close>

	newfd = INDEX2FD(newfdnum);
  801621:	8b 75 0c             	mov    0xc(%ebp),%esi
  801624:	c1 e6 0c             	shl    $0xc,%esi
  801627:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80162d:	83 c4 04             	add    $0x4,%esp
  801630:	ff 75 e4             	pushl  -0x1c(%ebp)
  801633:	e8 d5 fd ff ff       	call   80140d <fd2data>
  801638:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80163a:	89 34 24             	mov    %esi,(%esp)
  80163d:	e8 cb fd ff ff       	call   80140d <fd2data>
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801647:	89 d8                	mov    %ebx,%eax
  801649:	c1 e8 16             	shr    $0x16,%eax
  80164c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801653:	a8 01                	test   $0x1,%al
  801655:	74 11                	je     801668 <dup+0x74>
  801657:	89 d8                	mov    %ebx,%eax
  801659:	c1 e8 0c             	shr    $0xc,%eax
  80165c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801663:	f6 c2 01             	test   $0x1,%dl
  801666:	75 39                	jne    8016a1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801668:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80166b:	89 d0                	mov    %edx,%eax
  80166d:	c1 e8 0c             	shr    $0xc,%eax
  801670:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801677:	83 ec 0c             	sub    $0xc,%esp
  80167a:	25 07 0e 00 00       	and    $0xe07,%eax
  80167f:	50                   	push   %eax
  801680:	56                   	push   %esi
  801681:	6a 00                	push   $0x0
  801683:	52                   	push   %edx
  801684:	6a 00                	push   $0x0
  801686:	e8 94 fa ff ff       	call   80111f <sys_page_map>
  80168b:	89 c3                	mov    %eax,%ebx
  80168d:	83 c4 20             	add    $0x20,%esp
  801690:	85 c0                	test   %eax,%eax
  801692:	78 31                	js     8016c5 <dup+0xd1>
		goto err;

	return newfdnum;
  801694:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801697:	89 d8                	mov    %ebx,%eax
  801699:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80169c:	5b                   	pop    %ebx
  80169d:	5e                   	pop    %esi
  80169e:	5f                   	pop    %edi
  80169f:	5d                   	pop    %ebp
  8016a0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8016a1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8016a8:	83 ec 0c             	sub    $0xc,%esp
  8016ab:	25 07 0e 00 00       	and    $0xe07,%eax
  8016b0:	50                   	push   %eax
  8016b1:	57                   	push   %edi
  8016b2:	6a 00                	push   $0x0
  8016b4:	53                   	push   %ebx
  8016b5:	6a 00                	push   $0x0
  8016b7:	e8 63 fa ff ff       	call   80111f <sys_page_map>
  8016bc:	89 c3                	mov    %eax,%ebx
  8016be:	83 c4 20             	add    $0x20,%esp
  8016c1:	85 c0                	test   %eax,%eax
  8016c3:	79 a3                	jns    801668 <dup+0x74>
	sys_page_unmap(0, newfd);
  8016c5:	83 ec 08             	sub    $0x8,%esp
  8016c8:	56                   	push   %esi
  8016c9:	6a 00                	push   $0x0
  8016cb:	e8 91 fa ff ff       	call   801161 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8016d0:	83 c4 08             	add    $0x8,%esp
  8016d3:	57                   	push   %edi
  8016d4:	6a 00                	push   $0x0
  8016d6:	e8 86 fa ff ff       	call   801161 <sys_page_unmap>
	return r;
  8016db:	83 c4 10             	add    $0x10,%esp
  8016de:	eb b7                	jmp    801697 <dup+0xa3>

008016e0 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 14             	sub    $0x14,%esp
  8016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016ea:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016ed:	50                   	push   %eax
  8016ee:	53                   	push   %ebx
  8016ef:	e8 7f fd ff ff       	call   801473 <fd_lookup>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	78 3f                	js     80173a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016fb:	83 ec 08             	sub    $0x8,%esp
  8016fe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801701:	50                   	push   %eax
  801702:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801705:	ff 30                	pushl  (%eax)
  801707:	e8 be fd ff ff       	call   8014ca <dev_lookup>
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	85 c0                	test   %eax,%eax
  801711:	78 27                	js     80173a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801713:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801716:	8b 42 08             	mov    0x8(%edx),%eax
  801719:	83 e0 03             	and    $0x3,%eax
  80171c:	83 f8 01             	cmp    $0x1,%eax
  80171f:	74 1e                	je     80173f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801724:	8b 40 08             	mov    0x8(%eax),%eax
  801727:	85 c0                	test   %eax,%eax
  801729:	74 35                	je     801760 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	ff 75 10             	pushl  0x10(%ebp)
  801731:	ff 75 0c             	pushl  0xc(%ebp)
  801734:	52                   	push   %edx
  801735:	ff d0                	call   *%eax
  801737:	83 c4 10             	add    $0x10,%esp
}
  80173a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80173d:	c9                   	leave  
  80173e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80173f:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801744:	8b 40 48             	mov    0x48(%eax),%eax
  801747:	83 ec 04             	sub    $0x4,%esp
  80174a:	53                   	push   %ebx
  80174b:	50                   	push   %eax
  80174c:	68 6d 29 80 00       	push   $0x80296d
  801751:	e8 c9 ef ff ff       	call   80071f <cprintf>
		return -E_INVAL;
  801756:	83 c4 10             	add    $0x10,%esp
  801759:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80175e:	eb da                	jmp    80173a <read+0x5a>
		return -E_NOT_SUPP;
  801760:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801765:	eb d3                	jmp    80173a <read+0x5a>

00801767 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	57                   	push   %edi
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	83 ec 0c             	sub    $0xc,%esp
  801770:	8b 7d 08             	mov    0x8(%ebp),%edi
  801773:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801776:	bb 00 00 00 00       	mov    $0x0,%ebx
  80177b:	39 f3                	cmp    %esi,%ebx
  80177d:	73 25                	jae    8017a4 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80177f:	83 ec 04             	sub    $0x4,%esp
  801782:	89 f0                	mov    %esi,%eax
  801784:	29 d8                	sub    %ebx,%eax
  801786:	50                   	push   %eax
  801787:	89 d8                	mov    %ebx,%eax
  801789:	03 45 0c             	add    0xc(%ebp),%eax
  80178c:	50                   	push   %eax
  80178d:	57                   	push   %edi
  80178e:	e8 4d ff ff ff       	call   8016e0 <read>
		if (m < 0)
  801793:	83 c4 10             	add    $0x10,%esp
  801796:	85 c0                	test   %eax,%eax
  801798:	78 08                	js     8017a2 <readn+0x3b>
			return m;
		if (m == 0)
  80179a:	85 c0                	test   %eax,%eax
  80179c:	74 06                	je     8017a4 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80179e:	01 c3                	add    %eax,%ebx
  8017a0:	eb d9                	jmp    80177b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8017a2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8017a4:	89 d8                	mov    %ebx,%eax
  8017a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017a9:	5b                   	pop    %ebx
  8017aa:	5e                   	pop    %esi
  8017ab:	5f                   	pop    %edi
  8017ac:	5d                   	pop    %ebp
  8017ad:	c3                   	ret    

008017ae <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
  8017b1:	53                   	push   %ebx
  8017b2:	83 ec 14             	sub    $0x14,%esp
  8017b5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017b8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017bb:	50                   	push   %eax
  8017bc:	53                   	push   %ebx
  8017bd:	e8 b1 fc ff ff       	call   801473 <fd_lookup>
  8017c2:	83 c4 08             	add    $0x8,%esp
  8017c5:	85 c0                	test   %eax,%eax
  8017c7:	78 3a                	js     801803 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017c9:	83 ec 08             	sub    $0x8,%esp
  8017cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	ff 30                	pushl  (%eax)
  8017d5:	e8 f0 fc ff ff       	call   8014ca <dev_lookup>
  8017da:	83 c4 10             	add    $0x10,%esp
  8017dd:	85 c0                	test   %eax,%eax
  8017df:	78 22                	js     801803 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8017e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017e4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8017e8:	74 1e                	je     801808 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8017ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ed:	8b 52 0c             	mov    0xc(%edx),%edx
  8017f0:	85 d2                	test   %edx,%edx
  8017f2:	74 35                	je     801829 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	ff 75 10             	pushl  0x10(%ebp)
  8017fa:	ff 75 0c             	pushl  0xc(%ebp)
  8017fd:	50                   	push   %eax
  8017fe:	ff d2                	call   *%edx
  801800:	83 c4 10             	add    $0x10,%esp
}
  801803:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801806:	c9                   	leave  
  801807:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801808:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  80180d:	8b 40 48             	mov    0x48(%eax),%eax
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	53                   	push   %ebx
  801814:	50                   	push   %eax
  801815:	68 89 29 80 00       	push   $0x802989
  80181a:	e8 00 ef ff ff       	call   80071f <cprintf>
		return -E_INVAL;
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801827:	eb da                	jmp    801803 <write+0x55>
		return -E_NOT_SUPP;
  801829:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80182e:	eb d3                	jmp    801803 <write+0x55>

00801830 <seek>:

int
seek(int fdnum, off_t offset)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801836:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801839:	50                   	push   %eax
  80183a:	ff 75 08             	pushl  0x8(%ebp)
  80183d:	e8 31 fc ff ff       	call   801473 <fd_lookup>
  801842:	83 c4 08             	add    $0x8,%esp
  801845:	85 c0                	test   %eax,%eax
  801847:	78 0e                	js     801857 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801852:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	53                   	push   %ebx
  80185d:	83 ec 14             	sub    $0x14,%esp
  801860:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801863:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801866:	50                   	push   %eax
  801867:	53                   	push   %ebx
  801868:	e8 06 fc ff ff       	call   801473 <fd_lookup>
  80186d:	83 c4 08             	add    $0x8,%esp
  801870:	85 c0                	test   %eax,%eax
  801872:	78 37                	js     8018ab <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801874:	83 ec 08             	sub    $0x8,%esp
  801877:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187a:	50                   	push   %eax
  80187b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80187e:	ff 30                	pushl  (%eax)
  801880:	e8 45 fc ff ff       	call   8014ca <dev_lookup>
  801885:	83 c4 10             	add    $0x10,%esp
  801888:	85 c0                	test   %eax,%eax
  80188a:	78 1f                	js     8018ab <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80188c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80188f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801893:	74 1b                	je     8018b0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801895:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801898:	8b 52 18             	mov    0x18(%edx),%edx
  80189b:	85 d2                	test   %edx,%edx
  80189d:	74 32                	je     8018d1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80189f:	83 ec 08             	sub    $0x8,%esp
  8018a2:	ff 75 0c             	pushl  0xc(%ebp)
  8018a5:	50                   	push   %eax
  8018a6:	ff d2                	call   *%edx
  8018a8:	83 c4 10             	add    $0x10,%esp
}
  8018ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    
			thisenv->env_id, fdnum);
  8018b0:	a1 b0 40 80 00       	mov    0x8040b0,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8018b5:	8b 40 48             	mov    0x48(%eax),%eax
  8018b8:	83 ec 04             	sub    $0x4,%esp
  8018bb:	53                   	push   %ebx
  8018bc:	50                   	push   %eax
  8018bd:	68 4c 29 80 00       	push   $0x80294c
  8018c2:	e8 58 ee ff ff       	call   80071f <cprintf>
		return -E_INVAL;
  8018c7:	83 c4 10             	add    $0x10,%esp
  8018ca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018cf:	eb da                	jmp    8018ab <ftruncate+0x52>
		return -E_NOT_SUPP;
  8018d1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018d6:	eb d3                	jmp    8018ab <ftruncate+0x52>

008018d8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 14             	sub    $0x14,%esp
  8018df:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018e2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018e5:	50                   	push   %eax
  8018e6:	ff 75 08             	pushl  0x8(%ebp)
  8018e9:	e8 85 fb ff ff       	call   801473 <fd_lookup>
  8018ee:	83 c4 08             	add    $0x8,%esp
  8018f1:	85 c0                	test   %eax,%eax
  8018f3:	78 4b                	js     801940 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018f5:	83 ec 08             	sub    $0x8,%esp
  8018f8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018fb:	50                   	push   %eax
  8018fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ff:	ff 30                	pushl  (%eax)
  801901:	e8 c4 fb ff ff       	call   8014ca <dev_lookup>
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 33                	js     801940 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80190d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801910:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801914:	74 2f                	je     801945 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801916:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801919:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801920:	00 00 00 
	stat->st_type = 0;
  801923:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80192a:	00 00 00 
	stat->st_dev = dev;
  80192d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801933:	83 ec 08             	sub    $0x8,%esp
  801936:	53                   	push   %ebx
  801937:	ff 75 f0             	pushl  -0x10(%ebp)
  80193a:	ff 50 14             	call   *0x14(%eax)
  80193d:	83 c4 10             	add    $0x10,%esp
}
  801940:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801943:	c9                   	leave  
  801944:	c3                   	ret    
		return -E_NOT_SUPP;
  801945:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80194a:	eb f4                	jmp    801940 <fstat+0x68>

0080194c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	6a 00                	push   $0x0
  801956:	ff 75 08             	pushl  0x8(%ebp)
  801959:	e8 34 02 00 00       	call   801b92 <open>
  80195e:	89 c3                	mov    %eax,%ebx
  801960:	83 c4 10             	add    $0x10,%esp
  801963:	85 c0                	test   %eax,%eax
  801965:	78 1b                	js     801982 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801967:	83 ec 08             	sub    $0x8,%esp
  80196a:	ff 75 0c             	pushl  0xc(%ebp)
  80196d:	50                   	push   %eax
  80196e:	e8 65 ff ff ff       	call   8018d8 <fstat>
  801973:	89 c6                	mov    %eax,%esi
	close(fd);
  801975:	89 1c 24             	mov    %ebx,(%esp)
  801978:	e8 29 fc ff ff       	call   8015a6 <close>
	return r;
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	89 f3                	mov    %esi,%ebx
}
  801982:	89 d8                	mov    %ebx,%eax
  801984:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801987:	5b                   	pop    %ebx
  801988:	5e                   	pop    %esi
  801989:	5d                   	pop    %ebp
  80198a:	c3                   	ret    

0080198b <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80198b:	55                   	push   %ebp
  80198c:	89 e5                	mov    %esp,%ebp
  80198e:	56                   	push   %esi
  80198f:	53                   	push   %ebx
  801990:	89 c6                	mov    %eax,%esi
  801992:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801994:	83 3d ac 40 80 00 00 	cmpl   $0x0,0x8040ac
  80199b:	74 27                	je     8019c4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80199d:	6a 07                	push   $0x7
  80199f:	68 00 50 80 00       	push   $0x805000
  8019a4:	56                   	push   %esi
  8019a5:	ff 35 ac 40 80 00    	pushl  0x8040ac
  8019ab:	e8 e1 07 00 00       	call   802191 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8019b0:	83 c4 0c             	add    $0xc,%esp
  8019b3:	6a 00                	push   $0x0
  8019b5:	53                   	push   %ebx
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 4b 07 00 00       	call   802108 <ipc_recv>
}
  8019bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019c0:	5b                   	pop    %ebx
  8019c1:	5e                   	pop    %esi
  8019c2:	5d                   	pop    %ebp
  8019c3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8019c4:	83 ec 0c             	sub    $0xc,%esp
  8019c7:	6a 01                	push   $0x1
  8019c9:	e8 1f 08 00 00       	call   8021ed <ipc_find_env>
  8019ce:	a3 ac 40 80 00       	mov    %eax,0x8040ac
  8019d3:	83 c4 10             	add    $0x10,%esp
  8019d6:	eb c5                	jmp    80199d <fsipc+0x12>

008019d8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
  8019db:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8019e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ec:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8019f1:	ba 00 00 00 00       	mov    $0x0,%edx
  8019f6:	b8 02 00 00 00       	mov    $0x2,%eax
  8019fb:	e8 8b ff ff ff       	call   80198b <fsipc>
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <devfile_flush>:
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
  801a05:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	8b 40 0c             	mov    0xc(%eax),%eax
  801a0e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801a13:	ba 00 00 00 00       	mov    $0x0,%edx
  801a18:	b8 06 00 00 00       	mov    $0x6,%eax
  801a1d:	e8 69 ff ff ff       	call   80198b <fsipc>
}
  801a22:	c9                   	leave  
  801a23:	c3                   	ret    

00801a24 <devfile_stat>:
{
  801a24:	55                   	push   %ebp
  801a25:	89 e5                	mov    %esp,%ebp
  801a27:	53                   	push   %ebx
  801a28:	83 ec 04             	sub    $0x4,%esp
  801a2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	8b 40 0c             	mov    0xc(%eax),%eax
  801a34:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801a39:	ba 00 00 00 00       	mov    $0x0,%edx
  801a3e:	b8 05 00 00 00       	mov    $0x5,%eax
  801a43:	e8 43 ff ff ff       	call   80198b <fsipc>
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	78 2c                	js     801a78 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801a4c:	83 ec 08             	sub    $0x8,%esp
  801a4f:	68 00 50 80 00       	push   $0x805000
  801a54:	53                   	push   %ebx
  801a55:	e8 cd f2 ff ff       	call   800d27 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a5a:	a1 80 50 80 00       	mov    0x805080,%eax
  801a5f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801a65:	a1 84 50 80 00       	mov    0x805084,%eax
  801a6a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a70:	83 c4 10             	add    $0x10,%esp
  801a73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a78:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a7b:	c9                   	leave  
  801a7c:	c3                   	ret    

00801a7d <devfile_write>:
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	53                   	push   %ebx
  801a81:	83 ec 04             	sub    $0x4,%esp
  801a84:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801a87:	89 d8                	mov    %ebx,%eax
  801a89:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801a8f:	76 05                	jbe    801a96 <devfile_write+0x19>
  801a91:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a96:	8b 55 08             	mov    0x8(%ebp),%edx
  801a99:	8b 52 0c             	mov    0xc(%edx),%edx
  801a9c:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801aa2:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801aa7:	83 ec 04             	sub    $0x4,%esp
  801aaa:	50                   	push   %eax
  801aab:	ff 75 0c             	pushl  0xc(%ebp)
  801aae:	68 08 50 80 00       	push   $0x805008
  801ab3:	e8 e2 f3 ff ff       	call   800e9a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801ab8:	ba 00 00 00 00       	mov    $0x0,%edx
  801abd:	b8 04 00 00 00       	mov    $0x4,%eax
  801ac2:	e8 c4 fe ff ff       	call   80198b <fsipc>
  801ac7:	83 c4 10             	add    $0x10,%esp
  801aca:	85 c0                	test   %eax,%eax
  801acc:	78 0b                	js     801ad9 <devfile_write+0x5c>
	assert(r <= n);
  801ace:	39 c3                	cmp    %eax,%ebx
  801ad0:	72 0c                	jb     801ade <devfile_write+0x61>
	assert(r <= PGSIZE);
  801ad2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801ad7:	7f 1e                	jg     801af7 <devfile_write+0x7a>
}
  801ad9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801adc:	c9                   	leave  
  801add:	c3                   	ret    
	assert(r <= n);
  801ade:	68 b8 29 80 00       	push   $0x8029b8
  801ae3:	68 bf 29 80 00       	push   $0x8029bf
  801ae8:	68 98 00 00 00       	push   $0x98
  801aed:	68 d4 29 80 00       	push   $0x8029d4
  801af2:	e8 15 eb ff ff       	call   80060c <_panic>
	assert(r <= PGSIZE);
  801af7:	68 df 29 80 00       	push   $0x8029df
  801afc:	68 bf 29 80 00       	push   $0x8029bf
  801b01:	68 99 00 00 00       	push   $0x99
  801b06:	68 d4 29 80 00       	push   $0x8029d4
  801b0b:	e8 fc ea ff ff       	call   80060c <_panic>

00801b10 <devfile_read>:
{
  801b10:	55                   	push   %ebp
  801b11:	89 e5                	mov    %esp,%ebp
  801b13:	56                   	push   %esi
  801b14:	53                   	push   %ebx
  801b15:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801b18:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1b:	8b 40 0c             	mov    0xc(%eax),%eax
  801b1e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801b23:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801b29:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2e:	b8 03 00 00 00       	mov    $0x3,%eax
  801b33:	e8 53 fe ff ff       	call   80198b <fsipc>
  801b38:	89 c3                	mov    %eax,%ebx
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	78 1f                	js     801b5d <devfile_read+0x4d>
	assert(r <= n);
  801b3e:	39 c6                	cmp    %eax,%esi
  801b40:	72 24                	jb     801b66 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801b42:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801b47:	7f 33                	jg     801b7c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	50                   	push   %eax
  801b4d:	68 00 50 80 00       	push   $0x805000
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	e8 40 f3 ff ff       	call   800e9a <memmove>
	return r;
  801b5a:	83 c4 10             	add    $0x10,%esp
}
  801b5d:	89 d8                	mov    %ebx,%eax
  801b5f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b62:	5b                   	pop    %ebx
  801b63:	5e                   	pop    %esi
  801b64:	5d                   	pop    %ebp
  801b65:	c3                   	ret    
	assert(r <= n);
  801b66:	68 b8 29 80 00       	push   $0x8029b8
  801b6b:	68 bf 29 80 00       	push   $0x8029bf
  801b70:	6a 7c                	push   $0x7c
  801b72:	68 d4 29 80 00       	push   $0x8029d4
  801b77:	e8 90 ea ff ff       	call   80060c <_panic>
	assert(r <= PGSIZE);
  801b7c:	68 df 29 80 00       	push   $0x8029df
  801b81:	68 bf 29 80 00       	push   $0x8029bf
  801b86:	6a 7d                	push   $0x7d
  801b88:	68 d4 29 80 00       	push   $0x8029d4
  801b8d:	e8 7a ea ff ff       	call   80060c <_panic>

00801b92 <open>:
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
  801b95:	56                   	push   %esi
  801b96:	53                   	push   %ebx
  801b97:	83 ec 1c             	sub    $0x1c,%esp
  801b9a:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b9d:	56                   	push   %esi
  801b9e:	e8 51 f1 ff ff       	call   800cf4 <strlen>
  801ba3:	83 c4 10             	add    $0x10,%esp
  801ba6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801bab:	7f 6c                	jg     801c19 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bb3:	50                   	push   %eax
  801bb4:	e8 6b f8 ff ff       	call   801424 <fd_alloc>
  801bb9:	89 c3                	mov    %eax,%ebx
  801bbb:	83 c4 10             	add    $0x10,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	78 3c                	js     801bfe <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801bc2:	83 ec 08             	sub    $0x8,%esp
  801bc5:	56                   	push   %esi
  801bc6:	68 00 50 80 00       	push   $0x805000
  801bcb:	e8 57 f1 ff ff       	call   800d27 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801bd3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801bd8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bdb:	b8 01 00 00 00       	mov    $0x1,%eax
  801be0:	e8 a6 fd ff ff       	call   80198b <fsipc>
  801be5:	89 c3                	mov    %eax,%ebx
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	85 c0                	test   %eax,%eax
  801bec:	78 19                	js     801c07 <open+0x75>
	return fd2num(fd);
  801bee:	83 ec 0c             	sub    $0xc,%esp
  801bf1:	ff 75 f4             	pushl  -0xc(%ebp)
  801bf4:	e8 04 f8 ff ff       	call   8013fd <fd2num>
  801bf9:	89 c3                	mov    %eax,%ebx
  801bfb:	83 c4 10             	add    $0x10,%esp
}
  801bfe:	89 d8                	mov    %ebx,%eax
  801c00:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c03:	5b                   	pop    %ebx
  801c04:	5e                   	pop    %esi
  801c05:	5d                   	pop    %ebp
  801c06:	c3                   	ret    
		fd_close(fd, 0);
  801c07:	83 ec 08             	sub    $0x8,%esp
  801c0a:	6a 00                	push   $0x0
  801c0c:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0f:	e8 0c f9 ff ff       	call   801520 <fd_close>
		return r;
  801c14:	83 c4 10             	add    $0x10,%esp
  801c17:	eb e5                	jmp    801bfe <open+0x6c>
		return -E_BAD_PATH;
  801c19:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801c1e:	eb de                	jmp    801bfe <open+0x6c>

00801c20 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
  801c23:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801c26:	ba 00 00 00 00       	mov    $0x0,%edx
  801c2b:	b8 08 00 00 00       	mov    $0x8,%eax
  801c30:	e8 56 fd ff ff       	call   80198b <fsipc>
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
  801c3a:	56                   	push   %esi
  801c3b:	53                   	push   %ebx
  801c3c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c3f:	83 ec 0c             	sub    $0xc,%esp
  801c42:	ff 75 08             	pushl  0x8(%ebp)
  801c45:	e8 c3 f7 ff ff       	call   80140d <fd2data>
  801c4a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c4c:	83 c4 08             	add    $0x8,%esp
  801c4f:	68 eb 29 80 00       	push   $0x8029eb
  801c54:	53                   	push   %ebx
  801c55:	e8 cd f0 ff ff       	call   800d27 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c5a:	8b 46 04             	mov    0x4(%esi),%eax
  801c5d:	2b 06                	sub    (%esi),%eax
  801c5f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801c65:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801c6c:	10 00 00 
	stat->st_dev = &devpipe;
  801c6f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c76:	30 80 00 
	return 0;
}
  801c79:	b8 00 00 00 00       	mov    $0x0,%eax
  801c7e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c81:	5b                   	pop    %ebx
  801c82:	5e                   	pop    %esi
  801c83:	5d                   	pop    %ebp
  801c84:	c3                   	ret    

00801c85 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
  801c88:	53                   	push   %ebx
  801c89:	83 ec 0c             	sub    $0xc,%esp
  801c8c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c8f:	53                   	push   %ebx
  801c90:	6a 00                	push   $0x0
  801c92:	e8 ca f4 ff ff       	call   801161 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c97:	89 1c 24             	mov    %ebx,(%esp)
  801c9a:	e8 6e f7 ff ff       	call   80140d <fd2data>
  801c9f:	83 c4 08             	add    $0x8,%esp
  801ca2:	50                   	push   %eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	e8 b7 f4 ff ff       	call   801161 <sys_page_unmap>
}
  801caa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <_pipeisclosed>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	57                   	push   %edi
  801cb3:	56                   	push   %esi
  801cb4:	53                   	push   %ebx
  801cb5:	83 ec 1c             	sub    $0x1c,%esp
  801cb8:	89 c7                	mov    %eax,%edi
  801cba:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cbc:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  801cc1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cc4:	83 ec 0c             	sub    $0xc,%esp
  801cc7:	57                   	push   %edi
  801cc8:	e8 62 05 00 00       	call   80222f <pageref>
  801ccd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cd0:	89 34 24             	mov    %esi,(%esp)
  801cd3:	e8 57 05 00 00       	call   80222f <pageref>
		nn = thisenv->env_runs;
  801cd8:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  801cde:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	39 cb                	cmp    %ecx,%ebx
  801ce6:	74 1b                	je     801d03 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801ce8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ceb:	75 cf                	jne    801cbc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ced:	8b 42 58             	mov    0x58(%edx),%eax
  801cf0:	6a 01                	push   $0x1
  801cf2:	50                   	push   %eax
  801cf3:	53                   	push   %ebx
  801cf4:	68 f2 29 80 00       	push   $0x8029f2
  801cf9:	e8 21 ea ff ff       	call   80071f <cprintf>
  801cfe:	83 c4 10             	add    $0x10,%esp
  801d01:	eb b9                	jmp    801cbc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801d03:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801d06:	0f 94 c0             	sete   %al
  801d09:	0f b6 c0             	movzbl %al,%eax
}
  801d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    

00801d14 <devpipe_write>:
{
  801d14:	55                   	push   %ebp
  801d15:	89 e5                	mov    %esp,%ebp
  801d17:	57                   	push   %edi
  801d18:	56                   	push   %esi
  801d19:	53                   	push   %ebx
  801d1a:	83 ec 18             	sub    $0x18,%esp
  801d1d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d20:	56                   	push   %esi
  801d21:	e8 e7 f6 ff ff       	call   80140d <fd2data>
  801d26:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d28:	83 c4 10             	add    $0x10,%esp
  801d2b:	bf 00 00 00 00       	mov    $0x0,%edi
  801d30:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d33:	74 41                	je     801d76 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d35:	8b 53 04             	mov    0x4(%ebx),%edx
  801d38:	8b 03                	mov    (%ebx),%eax
  801d3a:	83 c0 20             	add    $0x20,%eax
  801d3d:	39 c2                	cmp    %eax,%edx
  801d3f:	72 14                	jb     801d55 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d41:	89 da                	mov    %ebx,%edx
  801d43:	89 f0                	mov    %esi,%eax
  801d45:	e8 65 ff ff ff       	call   801caf <_pipeisclosed>
  801d4a:	85 c0                	test   %eax,%eax
  801d4c:	75 2c                	jne    801d7a <devpipe_write+0x66>
			sys_yield();
  801d4e:	e8 50 f4 ff ff       	call   8011a3 <sys_yield>
  801d53:	eb e0                	jmp    801d35 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d58:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801d5b:	89 d0                	mov    %edx,%eax
  801d5d:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801d62:	78 0b                	js     801d6f <devpipe_write+0x5b>
  801d64:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801d68:	42                   	inc    %edx
  801d69:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d6c:	47                   	inc    %edi
  801d6d:	eb c1                	jmp    801d30 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d6f:	48                   	dec    %eax
  801d70:	83 c8 e0             	or     $0xffffffe0,%eax
  801d73:	40                   	inc    %eax
  801d74:	eb ee                	jmp    801d64 <devpipe_write+0x50>
	return i;
  801d76:	89 f8                	mov    %edi,%eax
  801d78:	eb 05                	jmp    801d7f <devpipe_write+0x6b>
				return 0;
  801d7a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d82:	5b                   	pop    %ebx
  801d83:	5e                   	pop    %esi
  801d84:	5f                   	pop    %edi
  801d85:	5d                   	pop    %ebp
  801d86:	c3                   	ret    

00801d87 <devpipe_read>:
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	57                   	push   %edi
  801d8b:	56                   	push   %esi
  801d8c:	53                   	push   %ebx
  801d8d:	83 ec 18             	sub    $0x18,%esp
  801d90:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d93:	57                   	push   %edi
  801d94:	e8 74 f6 ff ff       	call   80140d <fd2data>
  801d99:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801da3:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801da6:	74 46                	je     801dee <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801da8:	8b 06                	mov    (%esi),%eax
  801daa:	3b 46 04             	cmp    0x4(%esi),%eax
  801dad:	75 22                	jne    801dd1 <devpipe_read+0x4a>
			if (i > 0)
  801daf:	85 db                	test   %ebx,%ebx
  801db1:	74 0a                	je     801dbd <devpipe_read+0x36>
				return i;
  801db3:	89 d8                	mov    %ebx,%eax
}
  801db5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801dbd:	89 f2                	mov    %esi,%edx
  801dbf:	89 f8                	mov    %edi,%eax
  801dc1:	e8 e9 fe ff ff       	call   801caf <_pipeisclosed>
  801dc6:	85 c0                	test   %eax,%eax
  801dc8:	75 28                	jne    801df2 <devpipe_read+0x6b>
			sys_yield();
  801dca:	e8 d4 f3 ff ff       	call   8011a3 <sys_yield>
  801dcf:	eb d7                	jmp    801da8 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd1:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801dd6:	78 0f                	js     801de7 <devpipe_read+0x60>
  801dd8:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801ddc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ddf:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801de2:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801de4:	43                   	inc    %ebx
  801de5:	eb bc                	jmp    801da3 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801de7:	48                   	dec    %eax
  801de8:	83 c8 e0             	or     $0xffffffe0,%eax
  801deb:	40                   	inc    %eax
  801dec:	eb ea                	jmp    801dd8 <devpipe_read+0x51>
	return i;
  801dee:	89 d8                	mov    %ebx,%eax
  801df0:	eb c3                	jmp    801db5 <devpipe_read+0x2e>
				return 0;
  801df2:	b8 00 00 00 00       	mov    $0x0,%eax
  801df7:	eb bc                	jmp    801db5 <devpipe_read+0x2e>

00801df9 <pipe>:
{
  801df9:	55                   	push   %ebp
  801dfa:	89 e5                	mov    %esp,%ebp
  801dfc:	56                   	push   %esi
  801dfd:	53                   	push   %ebx
  801dfe:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801e01:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e04:	50                   	push   %eax
  801e05:	e8 1a f6 ff ff       	call   801424 <fd_alloc>
  801e0a:	89 c3                	mov    %eax,%ebx
  801e0c:	83 c4 10             	add    $0x10,%esp
  801e0f:	85 c0                	test   %eax,%eax
  801e11:	0f 88 2a 01 00 00    	js     801f41 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e17:	83 ec 04             	sub    $0x4,%esp
  801e1a:	68 07 04 00 00       	push   $0x407
  801e1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801e22:	6a 00                	push   $0x0
  801e24:	e8 b3 f2 ff ff       	call   8010dc <sys_page_alloc>
  801e29:	89 c3                	mov    %eax,%ebx
  801e2b:	83 c4 10             	add    $0x10,%esp
  801e2e:	85 c0                	test   %eax,%eax
  801e30:	0f 88 0b 01 00 00    	js     801f41 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801e36:	83 ec 0c             	sub    $0xc,%esp
  801e39:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e3c:	50                   	push   %eax
  801e3d:	e8 e2 f5 ff ff       	call   801424 <fd_alloc>
  801e42:	89 c3                	mov    %eax,%ebx
  801e44:	83 c4 10             	add    $0x10,%esp
  801e47:	85 c0                	test   %eax,%eax
  801e49:	0f 88 e2 00 00 00    	js     801f31 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e4f:	83 ec 04             	sub    $0x4,%esp
  801e52:	68 07 04 00 00       	push   $0x407
  801e57:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5a:	6a 00                	push   $0x0
  801e5c:	e8 7b f2 ff ff       	call   8010dc <sys_page_alloc>
  801e61:	89 c3                	mov    %eax,%ebx
  801e63:	83 c4 10             	add    $0x10,%esp
  801e66:	85 c0                	test   %eax,%eax
  801e68:	0f 88 c3 00 00 00    	js     801f31 <pipe+0x138>
	va = fd2data(fd0);
  801e6e:	83 ec 0c             	sub    $0xc,%esp
  801e71:	ff 75 f4             	pushl  -0xc(%ebp)
  801e74:	e8 94 f5 ff ff       	call   80140d <fd2data>
  801e79:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e7b:	83 c4 0c             	add    $0xc,%esp
  801e7e:	68 07 04 00 00       	push   $0x407
  801e83:	50                   	push   %eax
  801e84:	6a 00                	push   $0x0
  801e86:	e8 51 f2 ff ff       	call   8010dc <sys_page_alloc>
  801e8b:	89 c3                	mov    %eax,%ebx
  801e8d:	83 c4 10             	add    $0x10,%esp
  801e90:	85 c0                	test   %eax,%eax
  801e92:	0f 88 89 00 00 00    	js     801f21 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e98:	83 ec 0c             	sub    $0xc,%esp
  801e9b:	ff 75 f0             	pushl  -0x10(%ebp)
  801e9e:	e8 6a f5 ff ff       	call   80140d <fd2data>
  801ea3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801eaa:	50                   	push   %eax
  801eab:	6a 00                	push   $0x0
  801ead:	56                   	push   %esi
  801eae:	6a 00                	push   $0x0
  801eb0:	e8 6a f2 ff ff       	call   80111f <sys_page_map>
  801eb5:	89 c3                	mov    %eax,%ebx
  801eb7:	83 c4 20             	add    $0x20,%esp
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 55                	js     801f13 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801ebe:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ec4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ec7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ecc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ed3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801edc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ee1:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	ff 75 f4             	pushl  -0xc(%ebp)
  801eee:	e8 0a f5 ff ff       	call   8013fd <fd2num>
  801ef3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef6:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ef8:	83 c4 04             	add    $0x4,%esp
  801efb:	ff 75 f0             	pushl  -0x10(%ebp)
  801efe:	e8 fa f4 ff ff       	call   8013fd <fd2num>
  801f03:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f06:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801f09:	83 c4 10             	add    $0x10,%esp
  801f0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f11:	eb 2e                	jmp    801f41 <pipe+0x148>
	sys_page_unmap(0, va);
  801f13:	83 ec 08             	sub    $0x8,%esp
  801f16:	56                   	push   %esi
  801f17:	6a 00                	push   $0x0
  801f19:	e8 43 f2 ff ff       	call   801161 <sys_page_unmap>
  801f1e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f21:	83 ec 08             	sub    $0x8,%esp
  801f24:	ff 75 f0             	pushl  -0x10(%ebp)
  801f27:	6a 00                	push   $0x0
  801f29:	e8 33 f2 ff ff       	call   801161 <sys_page_unmap>
  801f2e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f31:	83 ec 08             	sub    $0x8,%esp
  801f34:	ff 75 f4             	pushl  -0xc(%ebp)
  801f37:	6a 00                	push   $0x0
  801f39:	e8 23 f2 ff ff       	call   801161 <sys_page_unmap>
  801f3e:	83 c4 10             	add    $0x10,%esp
}
  801f41:	89 d8                	mov    %ebx,%eax
  801f43:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f46:	5b                   	pop    %ebx
  801f47:	5e                   	pop    %esi
  801f48:	5d                   	pop    %ebp
  801f49:	c3                   	ret    

00801f4a <pipeisclosed>:
{
  801f4a:	55                   	push   %ebp
  801f4b:	89 e5                	mov    %esp,%ebp
  801f4d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f50:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f53:	50                   	push   %eax
  801f54:	ff 75 08             	pushl  0x8(%ebp)
  801f57:	e8 17 f5 ff ff       	call   801473 <fd_lookup>
  801f5c:	83 c4 10             	add    $0x10,%esp
  801f5f:	85 c0                	test   %eax,%eax
  801f61:	78 18                	js     801f7b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f63:	83 ec 0c             	sub    $0xc,%esp
  801f66:	ff 75 f4             	pushl  -0xc(%ebp)
  801f69:	e8 9f f4 ff ff       	call   80140d <fd2data>
	return _pipeisclosed(fd, p);
  801f6e:	89 c2                	mov    %eax,%edx
  801f70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f73:	e8 37 fd ff ff       	call   801caf <_pipeisclosed>
  801f78:	83 c4 10             	add    $0x10,%esp
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    

00801f87 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f87:	55                   	push   %ebp
  801f88:	89 e5                	mov    %esp,%ebp
  801f8a:	53                   	push   %ebx
  801f8b:	83 ec 0c             	sub    $0xc,%esp
  801f8e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801f91:	68 0a 2a 80 00       	push   $0x802a0a
  801f96:	53                   	push   %ebx
  801f97:	e8 8b ed ff ff       	call   800d27 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801f9c:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801fa3:	20 00 00 
	return 0;
}
  801fa6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <devcons_write>:
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
  801fb3:	57                   	push   %edi
  801fb4:	56                   	push   %esi
  801fb5:	53                   	push   %ebx
  801fb6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fbc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fc1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fc7:	eb 1d                	jmp    801fe6 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801fc9:	83 ec 04             	sub    $0x4,%esp
  801fcc:	53                   	push   %ebx
  801fcd:	03 45 0c             	add    0xc(%ebp),%eax
  801fd0:	50                   	push   %eax
  801fd1:	57                   	push   %edi
  801fd2:	e8 c3 ee ff ff       	call   800e9a <memmove>
		sys_cputs(buf, m);
  801fd7:	83 c4 08             	add    $0x8,%esp
  801fda:	53                   	push   %ebx
  801fdb:	57                   	push   %edi
  801fdc:	e8 5e f0 ff ff       	call   80103f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fe1:	01 de                	add    %ebx,%esi
  801fe3:	83 c4 10             	add    $0x10,%esp
  801fe6:	89 f0                	mov    %esi,%eax
  801fe8:	3b 75 10             	cmp    0x10(%ebp),%esi
  801feb:	73 11                	jae    801ffe <devcons_write+0x4e>
		m = n - tot;
  801fed:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ff0:	29 f3                	sub    %esi,%ebx
  801ff2:	83 fb 7f             	cmp    $0x7f,%ebx
  801ff5:	76 d2                	jbe    801fc9 <devcons_write+0x19>
  801ff7:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801ffc:	eb cb                	jmp    801fc9 <devcons_write+0x19>
}
  801ffe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802001:	5b                   	pop    %ebx
  802002:	5e                   	pop    %esi
  802003:	5f                   	pop    %edi
  802004:	5d                   	pop    %ebp
  802005:	c3                   	ret    

00802006 <devcons_read>:
{
  802006:	55                   	push   %ebp
  802007:	89 e5                	mov    %esp,%ebp
  802009:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  80200c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802010:	75 0c                	jne    80201e <devcons_read+0x18>
		return 0;
  802012:	b8 00 00 00 00       	mov    $0x0,%eax
  802017:	eb 21                	jmp    80203a <devcons_read+0x34>
		sys_yield();
  802019:	e8 85 f1 ff ff       	call   8011a3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80201e:	e8 3a f0 ff ff       	call   80105d <sys_cgetc>
  802023:	85 c0                	test   %eax,%eax
  802025:	74 f2                	je     802019 <devcons_read+0x13>
	if (c < 0)
  802027:	85 c0                	test   %eax,%eax
  802029:	78 0f                	js     80203a <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80202b:	83 f8 04             	cmp    $0x4,%eax
  80202e:	74 0c                	je     80203c <devcons_read+0x36>
	*(char*)vbuf = c;
  802030:	8b 55 0c             	mov    0xc(%ebp),%edx
  802033:	88 02                	mov    %al,(%edx)
	return 1;
  802035:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80203a:	c9                   	leave  
  80203b:	c3                   	ret    
		return 0;
  80203c:	b8 00 00 00 00       	mov    $0x0,%eax
  802041:	eb f7                	jmp    80203a <devcons_read+0x34>

00802043 <cputchar>:
{
  802043:	55                   	push   %ebp
  802044:	89 e5                	mov    %esp,%ebp
  802046:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802049:	8b 45 08             	mov    0x8(%ebp),%eax
  80204c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80204f:	6a 01                	push   $0x1
  802051:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802054:	50                   	push   %eax
  802055:	e8 e5 ef ff ff       	call   80103f <sys_cputs>
}
  80205a:	83 c4 10             	add    $0x10,%esp
  80205d:	c9                   	leave  
  80205e:	c3                   	ret    

0080205f <getchar>:
{
  80205f:	55                   	push   %ebp
  802060:	89 e5                	mov    %esp,%ebp
  802062:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802065:	6a 01                	push   $0x1
  802067:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80206a:	50                   	push   %eax
  80206b:	6a 00                	push   $0x0
  80206d:	e8 6e f6 ff ff       	call   8016e0 <read>
	if (r < 0)
  802072:	83 c4 10             	add    $0x10,%esp
  802075:	85 c0                	test   %eax,%eax
  802077:	78 08                	js     802081 <getchar+0x22>
	if (r < 1)
  802079:	85 c0                	test   %eax,%eax
  80207b:	7e 06                	jle    802083 <getchar+0x24>
	return c;
  80207d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802081:	c9                   	leave  
  802082:	c3                   	ret    
		return -E_EOF;
  802083:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802088:	eb f7                	jmp    802081 <getchar+0x22>

0080208a <iscons>:
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802090:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802093:	50                   	push   %eax
  802094:	ff 75 08             	pushl  0x8(%ebp)
  802097:	e8 d7 f3 ff ff       	call   801473 <fd_lookup>
  80209c:	83 c4 10             	add    $0x10,%esp
  80209f:	85 c0                	test   %eax,%eax
  8020a1:	78 11                	js     8020b4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020ac:	39 10                	cmp    %edx,(%eax)
  8020ae:	0f 94 c0             	sete   %al
  8020b1:	0f b6 c0             	movzbl %al,%eax
}
  8020b4:	c9                   	leave  
  8020b5:	c3                   	ret    

008020b6 <opencons>:
{
  8020b6:	55                   	push   %ebp
  8020b7:	89 e5                	mov    %esp,%ebp
  8020b9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020bf:	50                   	push   %eax
  8020c0:	e8 5f f3 ff ff       	call   801424 <fd_alloc>
  8020c5:	83 c4 10             	add    $0x10,%esp
  8020c8:	85 c0                	test   %eax,%eax
  8020ca:	78 3a                	js     802106 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020cc:	83 ec 04             	sub    $0x4,%esp
  8020cf:	68 07 04 00 00       	push   $0x407
  8020d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8020d7:	6a 00                	push   $0x0
  8020d9:	e8 fe ef ff ff       	call   8010dc <sys_page_alloc>
  8020de:	83 c4 10             	add    $0x10,%esp
  8020e1:	85 c0                	test   %eax,%eax
  8020e3:	78 21                	js     802106 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020e5:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f3:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020fa:	83 ec 0c             	sub    $0xc,%esp
  8020fd:	50                   	push   %eax
  8020fe:	e8 fa f2 ff ff       	call   8013fd <fd2num>
  802103:	83 c4 10             	add    $0x10,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
  80210b:	57                   	push   %edi
  80210c:	56                   	push   %esi
  80210d:	53                   	push   %ebx
  80210e:	83 ec 0c             	sub    $0xc,%esp
  802111:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802114:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802117:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80211a:	85 ff                	test   %edi,%edi
  80211c:	74 53                	je     802171 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80211e:	83 ec 0c             	sub    $0xc,%esp
  802121:	57                   	push   %edi
  802122:	e8 c5 f1 ff ff       	call   8012ec <sys_ipc_recv>
  802127:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80212a:	85 db                	test   %ebx,%ebx
  80212c:	74 0b                	je     802139 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80212e:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  802134:	8b 52 74             	mov    0x74(%edx),%edx
  802137:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802139:	85 f6                	test   %esi,%esi
  80213b:	74 0f                	je     80214c <ipc_recv+0x44>
  80213d:	85 ff                	test   %edi,%edi
  80213f:	74 0b                	je     80214c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802141:	8b 15 b0 40 80 00    	mov    0x8040b0,%edx
  802147:	8b 52 78             	mov    0x78(%edx),%edx
  80214a:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  80214c:	85 c0                	test   %eax,%eax
  80214e:	74 30                	je     802180 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802150:	85 db                	test   %ebx,%ebx
  802152:	74 06                	je     80215a <ipc_recv+0x52>
      		*from_env_store = 0;
  802154:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  80215a:	85 f6                	test   %esi,%esi
  80215c:	74 2c                	je     80218a <ipc_recv+0x82>
      		*perm_store = 0;
  80215e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  802164:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80216c:	5b                   	pop    %ebx
  80216d:	5e                   	pop    %esi
  80216e:	5f                   	pop    %edi
  80216f:	5d                   	pop    %ebp
  802170:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802171:	83 ec 0c             	sub    $0xc,%esp
  802174:	6a ff                	push   $0xffffffff
  802176:	e8 71 f1 ff ff       	call   8012ec <sys_ipc_recv>
  80217b:	83 c4 10             	add    $0x10,%esp
  80217e:	eb aa                	jmp    80212a <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802180:	a1 b0 40 80 00       	mov    0x8040b0,%eax
  802185:	8b 40 70             	mov    0x70(%eax),%eax
  802188:	eb df                	jmp    802169 <ipc_recv+0x61>
		return -1;
  80218a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80218f:	eb d8                	jmp    802169 <ipc_recv+0x61>

00802191 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802191:	55                   	push   %ebp
  802192:	89 e5                	mov    %esp,%ebp
  802194:	57                   	push   %edi
  802195:	56                   	push   %esi
  802196:	53                   	push   %ebx
  802197:	83 ec 0c             	sub    $0xc,%esp
  80219a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80219d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8021a0:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8021a3:	85 db                	test   %ebx,%ebx
  8021a5:	75 22                	jne    8021c9 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8021a7:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8021ac:	eb 1b                	jmp    8021c9 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8021ae:	68 18 2a 80 00       	push   $0x802a18
  8021b3:	68 bf 29 80 00       	push   $0x8029bf
  8021b8:	6a 48                	push   $0x48
  8021ba:	68 3c 2a 80 00       	push   $0x802a3c
  8021bf:	e8 48 e4 ff ff       	call   80060c <_panic>
		sys_yield();
  8021c4:	e8 da ef ff ff       	call   8011a3 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8021c9:	57                   	push   %edi
  8021ca:	53                   	push   %ebx
  8021cb:	56                   	push   %esi
  8021cc:	ff 75 08             	pushl  0x8(%ebp)
  8021cf:	e8 f5 f0 ff ff       	call   8012c9 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8021d4:	83 c4 10             	add    $0x10,%esp
  8021d7:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8021da:	74 e8                	je     8021c4 <ipc_send+0x33>
  8021dc:	85 c0                	test   %eax,%eax
  8021de:	75 ce                	jne    8021ae <ipc_send+0x1d>
		sys_yield();
  8021e0:	e8 be ef ff ff       	call   8011a3 <sys_yield>
		
	}
	
}
  8021e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    

008021ed <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8021ed:	55                   	push   %ebp
  8021ee:	89 e5                	mov    %esp,%ebp
  8021f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8021f3:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8021f8:	89 c2                	mov    %eax,%edx
  8021fa:	c1 e2 05             	shl    $0x5,%edx
  8021fd:	29 c2                	sub    %eax,%edx
  8021ff:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802206:	8b 52 50             	mov    0x50(%edx),%edx
  802209:	39 ca                	cmp    %ecx,%edx
  80220b:	74 0f                	je     80221c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80220d:	40                   	inc    %eax
  80220e:	3d 00 04 00 00       	cmp    $0x400,%eax
  802213:	75 e3                	jne    8021f8 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802215:	b8 00 00 00 00       	mov    $0x0,%eax
  80221a:	eb 11                	jmp    80222d <ipc_find_env+0x40>
			return envs[i].env_id;
  80221c:	89 c2                	mov    %eax,%edx
  80221e:	c1 e2 05             	shl    $0x5,%edx
  802221:	29 c2                	sub    %eax,%edx
  802223:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80222a:	8b 40 48             	mov    0x48(%eax),%eax
}
  80222d:	5d                   	pop    %ebp
  80222e:	c3                   	ret    

0080222f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80222f:	55                   	push   %ebp
  802230:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	c1 e8 16             	shr    $0x16,%eax
  802238:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80223f:	a8 01                	test   $0x1,%al
  802241:	74 21                	je     802264 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	c1 e8 0c             	shr    $0xc,%eax
  802249:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802250:	a8 01                	test   $0x1,%al
  802252:	74 17                	je     80226b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802254:	c1 e8 0c             	shr    $0xc,%eax
  802257:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80225e:	ef 
  80225f:	0f b7 c0             	movzwl %ax,%eax
  802262:	eb 05                	jmp    802269 <pageref+0x3a>
		return 0;
  802264:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802269:	5d                   	pop    %ebp
  80226a:	c3                   	ret    
		return 0;
  80226b:	b8 00 00 00 00       	mov    $0x0,%eax
  802270:	eb f7                	jmp    802269 <pageref+0x3a>
  802272:	66 90                	xchg   %ax,%ax

00802274 <__udivdi3>:
  802274:	55                   	push   %ebp
  802275:	57                   	push   %edi
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	83 ec 1c             	sub    $0x1c,%esp
  80227b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80227f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802287:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80228b:	89 ca                	mov    %ecx,%edx
  80228d:	89 f8                	mov    %edi,%eax
  80228f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802293:	85 f6                	test   %esi,%esi
  802295:	75 2d                	jne    8022c4 <__udivdi3+0x50>
  802297:	39 cf                	cmp    %ecx,%edi
  802299:	77 65                	ja     802300 <__udivdi3+0x8c>
  80229b:	89 fd                	mov    %edi,%ebp
  80229d:	85 ff                	test   %edi,%edi
  80229f:	75 0b                	jne    8022ac <__udivdi3+0x38>
  8022a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8022a6:	31 d2                	xor    %edx,%edx
  8022a8:	f7 f7                	div    %edi
  8022aa:	89 c5                	mov    %eax,%ebp
  8022ac:	31 d2                	xor    %edx,%edx
  8022ae:	89 c8                	mov    %ecx,%eax
  8022b0:	f7 f5                	div    %ebp
  8022b2:	89 c1                	mov    %eax,%ecx
  8022b4:	89 d8                	mov    %ebx,%eax
  8022b6:	f7 f5                	div    %ebp
  8022b8:	89 cf                	mov    %ecx,%edi
  8022ba:	89 fa                	mov    %edi,%edx
  8022bc:	83 c4 1c             	add    $0x1c,%esp
  8022bf:	5b                   	pop    %ebx
  8022c0:	5e                   	pop    %esi
  8022c1:	5f                   	pop    %edi
  8022c2:	5d                   	pop    %ebp
  8022c3:	c3                   	ret    
  8022c4:	39 ce                	cmp    %ecx,%esi
  8022c6:	77 28                	ja     8022f0 <__udivdi3+0x7c>
  8022c8:	0f bd fe             	bsr    %esi,%edi
  8022cb:	83 f7 1f             	xor    $0x1f,%edi
  8022ce:	75 40                	jne    802310 <__udivdi3+0x9c>
  8022d0:	39 ce                	cmp    %ecx,%esi
  8022d2:	72 0a                	jb     8022de <__udivdi3+0x6a>
  8022d4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8022d8:	0f 87 9e 00 00 00    	ja     80237c <__udivdi3+0x108>
  8022de:	b8 01 00 00 00       	mov    $0x1,%eax
  8022e3:	89 fa                	mov    %edi,%edx
  8022e5:	83 c4 1c             	add    $0x1c,%esp
  8022e8:	5b                   	pop    %ebx
  8022e9:	5e                   	pop    %esi
  8022ea:	5f                   	pop    %edi
  8022eb:	5d                   	pop    %ebp
  8022ec:	c3                   	ret    
  8022ed:	8d 76 00             	lea    0x0(%esi),%esi
  8022f0:	31 ff                	xor    %edi,%edi
  8022f2:	31 c0                	xor    %eax,%eax
  8022f4:	89 fa                	mov    %edi,%edx
  8022f6:	83 c4 1c             	add    $0x1c,%esp
  8022f9:	5b                   	pop    %ebx
  8022fa:	5e                   	pop    %esi
  8022fb:	5f                   	pop    %edi
  8022fc:	5d                   	pop    %ebp
  8022fd:	c3                   	ret    
  8022fe:	66 90                	xchg   %ax,%ax
  802300:	89 d8                	mov    %ebx,%eax
  802302:	f7 f7                	div    %edi
  802304:	31 ff                	xor    %edi,%edi
  802306:	89 fa                	mov    %edi,%edx
  802308:	83 c4 1c             	add    $0x1c,%esp
  80230b:	5b                   	pop    %ebx
  80230c:	5e                   	pop    %esi
  80230d:	5f                   	pop    %edi
  80230e:	5d                   	pop    %ebp
  80230f:	c3                   	ret    
  802310:	bd 20 00 00 00       	mov    $0x20,%ebp
  802315:	29 fd                	sub    %edi,%ebp
  802317:	89 f9                	mov    %edi,%ecx
  802319:	d3 e6                	shl    %cl,%esi
  80231b:	89 c3                	mov    %eax,%ebx
  80231d:	89 e9                	mov    %ebp,%ecx
  80231f:	d3 eb                	shr    %cl,%ebx
  802321:	89 d9                	mov    %ebx,%ecx
  802323:	09 f1                	or     %esi,%ecx
  802325:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802329:	89 f9                	mov    %edi,%ecx
  80232b:	d3 e0                	shl    %cl,%eax
  80232d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802331:	89 d6                	mov    %edx,%esi
  802333:	89 e9                	mov    %ebp,%ecx
  802335:	d3 ee                	shr    %cl,%esi
  802337:	89 f9                	mov    %edi,%ecx
  802339:	d3 e2                	shl    %cl,%edx
  80233b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80233f:	89 e9                	mov    %ebp,%ecx
  802341:	d3 eb                	shr    %cl,%ebx
  802343:	09 da                	or     %ebx,%edx
  802345:	89 d0                	mov    %edx,%eax
  802347:	89 f2                	mov    %esi,%edx
  802349:	f7 74 24 08          	divl   0x8(%esp)
  80234d:	89 d6                	mov    %edx,%esi
  80234f:	89 c3                	mov    %eax,%ebx
  802351:	f7 64 24 0c          	mull   0xc(%esp)
  802355:	39 d6                	cmp    %edx,%esi
  802357:	72 17                	jb     802370 <__udivdi3+0xfc>
  802359:	74 09                	je     802364 <__udivdi3+0xf0>
  80235b:	89 d8                	mov    %ebx,%eax
  80235d:	31 ff                	xor    %edi,%edi
  80235f:	e9 56 ff ff ff       	jmp    8022ba <__udivdi3+0x46>
  802364:	8b 54 24 04          	mov    0x4(%esp),%edx
  802368:	89 f9                	mov    %edi,%ecx
  80236a:	d3 e2                	shl    %cl,%edx
  80236c:	39 c2                	cmp    %eax,%edx
  80236e:	73 eb                	jae    80235b <__udivdi3+0xe7>
  802370:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802373:	31 ff                	xor    %edi,%edi
  802375:	e9 40 ff ff ff       	jmp    8022ba <__udivdi3+0x46>
  80237a:	66 90                	xchg   %ax,%ax
  80237c:	31 c0                	xor    %eax,%eax
  80237e:	e9 37 ff ff ff       	jmp    8022ba <__udivdi3+0x46>
  802383:	90                   	nop

00802384 <__umoddi3>:
  802384:	55                   	push   %ebp
  802385:	57                   	push   %edi
  802386:	56                   	push   %esi
  802387:	53                   	push   %ebx
  802388:	83 ec 1c             	sub    $0x1c,%esp
  80238b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80238f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802393:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802397:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80239b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80239f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023a3:	89 3c 24             	mov    %edi,(%esp)
  8023a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023aa:	89 f2                	mov    %esi,%edx
  8023ac:	85 c0                	test   %eax,%eax
  8023ae:	75 18                	jne    8023c8 <__umoddi3+0x44>
  8023b0:	39 f7                	cmp    %esi,%edi
  8023b2:	0f 86 a0 00 00 00    	jbe    802458 <__umoddi3+0xd4>
  8023b8:	89 c8                	mov    %ecx,%eax
  8023ba:	f7 f7                	div    %edi
  8023bc:	89 d0                	mov    %edx,%eax
  8023be:	31 d2                	xor    %edx,%edx
  8023c0:	83 c4 1c             	add    $0x1c,%esp
  8023c3:	5b                   	pop    %ebx
  8023c4:	5e                   	pop    %esi
  8023c5:	5f                   	pop    %edi
  8023c6:	5d                   	pop    %ebp
  8023c7:	c3                   	ret    
  8023c8:	89 f3                	mov    %esi,%ebx
  8023ca:	39 f0                	cmp    %esi,%eax
  8023cc:	0f 87 a6 00 00 00    	ja     802478 <__umoddi3+0xf4>
  8023d2:	0f bd e8             	bsr    %eax,%ebp
  8023d5:	83 f5 1f             	xor    $0x1f,%ebp
  8023d8:	0f 84 a6 00 00 00    	je     802484 <__umoddi3+0x100>
  8023de:	bf 20 00 00 00       	mov    $0x20,%edi
  8023e3:	29 ef                	sub    %ebp,%edi
  8023e5:	89 e9                	mov    %ebp,%ecx
  8023e7:	d3 e0                	shl    %cl,%eax
  8023e9:	8b 34 24             	mov    (%esp),%esi
  8023ec:	89 f2                	mov    %esi,%edx
  8023ee:	89 f9                	mov    %edi,%ecx
  8023f0:	d3 ea                	shr    %cl,%edx
  8023f2:	09 c2                	or     %eax,%edx
  8023f4:	89 14 24             	mov    %edx,(%esp)
  8023f7:	89 f2                	mov    %esi,%edx
  8023f9:	89 e9                	mov    %ebp,%ecx
  8023fb:	d3 e2                	shl    %cl,%edx
  8023fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802401:	89 de                	mov    %ebx,%esi
  802403:	89 f9                	mov    %edi,%ecx
  802405:	d3 ee                	shr    %cl,%esi
  802407:	89 e9                	mov    %ebp,%ecx
  802409:	d3 e3                	shl    %cl,%ebx
  80240b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80240f:	89 d0                	mov    %edx,%eax
  802411:	89 f9                	mov    %edi,%ecx
  802413:	d3 e8                	shr    %cl,%eax
  802415:	09 d8                	or     %ebx,%eax
  802417:	89 d3                	mov    %edx,%ebx
  802419:	89 e9                	mov    %ebp,%ecx
  80241b:	d3 e3                	shl    %cl,%ebx
  80241d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802421:	89 f2                	mov    %esi,%edx
  802423:	f7 34 24             	divl   (%esp)
  802426:	89 d6                	mov    %edx,%esi
  802428:	f7 64 24 04          	mull   0x4(%esp)
  80242c:	89 c3                	mov    %eax,%ebx
  80242e:	89 d1                	mov    %edx,%ecx
  802430:	39 d6                	cmp    %edx,%esi
  802432:	72 7c                	jb     8024b0 <__umoddi3+0x12c>
  802434:	74 72                	je     8024a8 <__umoddi3+0x124>
  802436:	8b 54 24 08          	mov    0x8(%esp),%edx
  80243a:	29 da                	sub    %ebx,%edx
  80243c:	19 ce                	sbb    %ecx,%esi
  80243e:	89 f0                	mov    %esi,%eax
  802440:	89 f9                	mov    %edi,%ecx
  802442:	d3 e0                	shl    %cl,%eax
  802444:	89 e9                	mov    %ebp,%ecx
  802446:	d3 ea                	shr    %cl,%edx
  802448:	09 d0                	or     %edx,%eax
  80244a:	89 e9                	mov    %ebp,%ecx
  80244c:	d3 ee                	shr    %cl,%esi
  80244e:	89 f2                	mov    %esi,%edx
  802450:	83 c4 1c             	add    $0x1c,%esp
  802453:	5b                   	pop    %ebx
  802454:	5e                   	pop    %esi
  802455:	5f                   	pop    %edi
  802456:	5d                   	pop    %ebp
  802457:	c3                   	ret    
  802458:	89 fd                	mov    %edi,%ebp
  80245a:	85 ff                	test   %edi,%edi
  80245c:	75 0b                	jne    802469 <__umoddi3+0xe5>
  80245e:	b8 01 00 00 00       	mov    $0x1,%eax
  802463:	31 d2                	xor    %edx,%edx
  802465:	f7 f7                	div    %edi
  802467:	89 c5                	mov    %eax,%ebp
  802469:	89 f0                	mov    %esi,%eax
  80246b:	31 d2                	xor    %edx,%edx
  80246d:	f7 f5                	div    %ebp
  80246f:	89 c8                	mov    %ecx,%eax
  802471:	f7 f5                	div    %ebp
  802473:	e9 44 ff ff ff       	jmp    8023bc <__umoddi3+0x38>
  802478:	89 c8                	mov    %ecx,%eax
  80247a:	89 f2                	mov    %esi,%edx
  80247c:	83 c4 1c             	add    $0x1c,%esp
  80247f:	5b                   	pop    %ebx
  802480:	5e                   	pop    %esi
  802481:	5f                   	pop    %edi
  802482:	5d                   	pop    %ebp
  802483:	c3                   	ret    
  802484:	39 f0                	cmp    %esi,%eax
  802486:	72 05                	jb     80248d <__umoddi3+0x109>
  802488:	39 0c 24             	cmp    %ecx,(%esp)
  80248b:	77 0c                	ja     802499 <__umoddi3+0x115>
  80248d:	89 f2                	mov    %esi,%edx
  80248f:	29 f9                	sub    %edi,%ecx
  802491:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802495:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802499:	8b 44 24 04          	mov    0x4(%esp),%eax
  80249d:	83 c4 1c             	add    $0x1c,%esp
  8024a0:	5b                   	pop    %ebx
  8024a1:	5e                   	pop    %esi
  8024a2:	5f                   	pop    %edi
  8024a3:	5d                   	pop    %ebp
  8024a4:	c3                   	ret    
  8024a5:	8d 76 00             	lea    0x0(%esi),%esi
  8024a8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8024ac:	73 88                	jae    802436 <__umoddi3+0xb2>
  8024ae:	66 90                	xchg   %ax,%ax
  8024b0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8024b4:	1b 14 24             	sbb    (%esp),%edx
  8024b7:	89 d1                	mov    %edx,%ecx
  8024b9:	89 c3                	mov    %eax,%ebx
  8024bb:	e9 76 ff ff ff       	jmp    802436 <__umoddi3+0xb2>
