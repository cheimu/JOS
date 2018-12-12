
obj/user/sendpage.debug:     file format elf32-i386


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
  80002c:	e8 6a 01 00 00       	call   80019b <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#define TEMP_ADDR	((char*)0xa00000)
#define TEMP_ADDR_CHILD	((char*)0xb00000)

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 18             	sub    $0x18,%esp
	envid_t who;

	if ((who = fork()) == 0) {
  800039:	e8 8d 0f 00 00       	call   800fcb <fork>
  80003e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800041:	85 c0                	test   %eax,%eax
  800043:	0f 85 9c 00 00 00    	jne    8000e5 <umain+0xb2>
		// Child
		ipc_recv(&who, TEMP_ADDR_CHILD, 0);
  800049:	83 ec 04             	sub    $0x4,%esp
  80004c:	6a 00                	push   $0x0
  80004e:	68 00 00 b0 00       	push   $0xb00000
  800053:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800056:	50                   	push   %eax
  800057:	e8 30 11 00 00       	call   80118c <ipc_recv>
		cprintf("%x got message: %s\n", who, TEMP_ADDR_CHILD);
  80005c:	83 c4 0c             	add    $0xc,%esp
  80005f:	68 00 00 b0 00       	push   $0xb00000
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	68 40 23 80 00       	push   $0x802340
  80006c:	e8 24 02 00 00       	call   800295 <cprintf>
		if (strncmp(TEMP_ADDR_CHILD, str1, strlen(str1)) == 0)
  800071:	83 c4 04             	add    $0x4,%esp
  800074:	ff 35 04 30 80 00    	pushl  0x803004
  80007a:	e8 eb 07 00 00       	call   80086a <strlen>
  80007f:	83 c4 0c             	add    $0xc,%esp
  800082:	50                   	push   %eax
  800083:	ff 35 04 30 80 00    	pushl  0x803004
  800089:	68 00 00 b0 00       	push   $0xb00000
  80008e:	e8 c8 08 00 00       	call   80095b <strncmp>
  800093:	83 c4 10             	add    $0x10,%esp
  800096:	85 c0                	test   %eax,%eax
  800098:	74 39                	je     8000d3 <umain+0xa0>
			cprintf("child received correct message\n");

		memcpy(TEMP_ADDR_CHILD, str2, strlen(str2) + 1);
  80009a:	83 ec 0c             	sub    $0xc,%esp
  80009d:	ff 35 00 30 80 00    	pushl  0x803000
  8000a3:	e8 c2 07 00 00       	call   80086a <strlen>
  8000a8:	83 c4 0c             	add    $0xc,%esp
  8000ab:	40                   	inc    %eax
  8000ac:	50                   	push   %eax
  8000ad:	ff 35 00 30 80 00    	pushl  0x803000
  8000b3:	68 00 00 b0 00       	push   $0xb00000
  8000b8:	e8 b9 09 00 00       	call   800a76 <memcpy>
		ipc_send(who, 0, TEMP_ADDR_CHILD, PTE_P | PTE_W | PTE_U);
  8000bd:	6a 07                	push   $0x7
  8000bf:	68 00 00 b0 00       	push   $0xb00000
  8000c4:	6a 00                	push   $0x0
  8000c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8000c9:	e8 47 11 00 00       	call   801215 <ipc_send>
		return;
  8000ce:	83 c4 20             	add    $0x20,%esp
	ipc_recv(&who, TEMP_ADDR, 0);
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
		cprintf("parent received correct message\n");
	return;
}
  8000d1:	c9                   	leave  
  8000d2:	c3                   	ret    
			cprintf("child received correct message\n");
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	68 54 23 80 00       	push   $0x802354
  8000db:	e8 b5 01 00 00       	call   800295 <cprintf>
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	eb b5                	jmp    80009a <umain+0x67>
	sys_page_alloc(thisenv->env_id, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  8000e5:	a1 04 40 80 00       	mov    0x804004,%eax
  8000ea:	8b 40 48             	mov    0x48(%eax),%eax
  8000ed:	83 ec 04             	sub    $0x4,%esp
  8000f0:	6a 07                	push   $0x7
  8000f2:	68 00 00 a0 00       	push   $0xa00000
  8000f7:	50                   	push   %eax
  8000f8:	e8 55 0b 00 00       	call   800c52 <sys_page_alloc>
	memcpy(TEMP_ADDR, str1, strlen(str1) + 1);
  8000fd:	83 c4 04             	add    $0x4,%esp
  800100:	ff 35 04 30 80 00    	pushl  0x803004
  800106:	e8 5f 07 00 00       	call   80086a <strlen>
  80010b:	83 c4 0c             	add    $0xc,%esp
  80010e:	40                   	inc    %eax
  80010f:	50                   	push   %eax
  800110:	ff 35 04 30 80 00    	pushl  0x803004
  800116:	68 00 00 a0 00       	push   $0xa00000
  80011b:	e8 56 09 00 00       	call   800a76 <memcpy>
	ipc_send(who, 0, TEMP_ADDR, PTE_P | PTE_W | PTE_U);
  800120:	6a 07                	push   $0x7
  800122:	68 00 00 a0 00       	push   $0xa00000
  800127:	6a 00                	push   $0x0
  800129:	ff 75 f4             	pushl  -0xc(%ebp)
  80012c:	e8 e4 10 00 00       	call   801215 <ipc_send>
	ipc_recv(&who, TEMP_ADDR, 0);
  800131:	83 c4 1c             	add    $0x1c,%esp
  800134:	6a 00                	push   $0x0
  800136:	68 00 00 a0 00       	push   $0xa00000
  80013b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80013e:	50                   	push   %eax
  80013f:	e8 48 10 00 00       	call   80118c <ipc_recv>
	cprintf("%x got message: %s\n", who, TEMP_ADDR);
  800144:	83 c4 0c             	add    $0xc,%esp
  800147:	68 00 00 a0 00       	push   $0xa00000
  80014c:	ff 75 f4             	pushl  -0xc(%ebp)
  80014f:	68 40 23 80 00       	push   $0x802340
  800154:	e8 3c 01 00 00       	call   800295 <cprintf>
	if (strncmp(TEMP_ADDR, str2, strlen(str2)) == 0)
  800159:	83 c4 04             	add    $0x4,%esp
  80015c:	ff 35 00 30 80 00    	pushl  0x803000
  800162:	e8 03 07 00 00       	call   80086a <strlen>
  800167:	83 c4 0c             	add    $0xc,%esp
  80016a:	50                   	push   %eax
  80016b:	ff 35 00 30 80 00    	pushl  0x803000
  800171:	68 00 00 a0 00       	push   $0xa00000
  800176:	e8 e0 07 00 00       	call   80095b <strncmp>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	85 c0                	test   %eax,%eax
  800180:	0f 85 4b ff ff ff    	jne    8000d1 <umain+0x9e>
		cprintf("parent received correct message\n");
  800186:	83 ec 0c             	sub    $0xc,%esp
  800189:	68 74 23 80 00       	push   $0x802374
  80018e:	e8 02 01 00 00       	call   800295 <cprintf>
  800193:	83 c4 10             	add    $0x10,%esp
  800196:	e9 36 ff ff ff       	jmp    8000d1 <umain+0x9e>

0080019b <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80019b:	55                   	push   %ebp
  80019c:	89 e5                	mov    %esp,%ebp
  80019e:	56                   	push   %esi
  80019f:	53                   	push   %ebx
  8001a0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001a3:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001a6:	e8 88 0a 00 00       	call   800c33 <sys_getenvid>
  8001ab:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001b0:	89 c2                	mov    %eax,%edx
  8001b2:	c1 e2 05             	shl    $0x5,%edx
  8001b5:	29 c2                	sub    %eax,%edx
  8001b7:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001be:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001c3:	85 db                	test   %ebx,%ebx
  8001c5:	7e 07                	jle    8001ce <libmain+0x33>
		binaryname = argv[0];
  8001c7:	8b 06                	mov    (%esi),%eax
  8001c9:	a3 08 30 80 00       	mov    %eax,0x803008

	// call user main routine
	umain(argc, argv);
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	56                   	push   %esi
  8001d2:	53                   	push   %ebx
  8001d3:	e8 5b fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8001d8:	e8 0a 00 00 00       	call   8001e7 <exit>
}
  8001dd:	83 c4 10             	add    $0x10,%esp
  8001e0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001e3:	5b                   	pop    %ebx
  8001e4:	5e                   	pop    %esi
  8001e5:	5d                   	pop    %ebp
  8001e6:	c3                   	ret    

008001e7 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8001e7:	55                   	push   %ebp
  8001e8:	89 e5                	mov    %esp,%ebp
  8001ea:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8001ed:	e8 95 12 00 00       	call   801487 <close_all>
	sys_env_destroy(0);
  8001f2:	83 ec 0c             	sub    $0xc,%esp
  8001f5:	6a 00                	push   $0x0
  8001f7:	e8 f6 09 00 00       	call   800bf2 <sys_env_destroy>
}
  8001fc:	83 c4 10             	add    $0x10,%esp
  8001ff:	c9                   	leave  
  800200:	c3                   	ret    

00800201 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800201:	55                   	push   %ebp
  800202:	89 e5                	mov    %esp,%ebp
  800204:	53                   	push   %ebx
  800205:	83 ec 04             	sub    $0x4,%esp
  800208:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80020b:	8b 13                	mov    (%ebx),%edx
  80020d:	8d 42 01             	lea    0x1(%edx),%eax
  800210:	89 03                	mov    %eax,(%ebx)
  800212:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800215:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800219:	3d ff 00 00 00       	cmp    $0xff,%eax
  80021e:	74 08                	je     800228 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800220:	ff 43 04             	incl   0x4(%ebx)
}
  800223:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800226:	c9                   	leave  
  800227:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800228:	83 ec 08             	sub    $0x8,%esp
  80022b:	68 ff 00 00 00       	push   $0xff
  800230:	8d 43 08             	lea    0x8(%ebx),%eax
  800233:	50                   	push   %eax
  800234:	e8 7c 09 00 00       	call   800bb5 <sys_cputs>
		b->idx = 0;
  800239:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80023f:	83 c4 10             	add    $0x10,%esp
  800242:	eb dc                	jmp    800220 <putch+0x1f>

00800244 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800244:	55                   	push   %ebp
  800245:	89 e5                	mov    %esp,%ebp
  800247:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80024d:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800254:	00 00 00 
	b.cnt = 0;
  800257:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80025e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800261:	ff 75 0c             	pushl  0xc(%ebp)
  800264:	ff 75 08             	pushl  0x8(%ebp)
  800267:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80026d:	50                   	push   %eax
  80026e:	68 01 02 80 00       	push   $0x800201
  800273:	e8 17 01 00 00       	call   80038f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800278:	83 c4 08             	add    $0x8,%esp
  80027b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800281:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800287:	50                   	push   %eax
  800288:	e8 28 09 00 00       	call   800bb5 <sys_cputs>

	return b.cnt;
}
  80028d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800293:	c9                   	leave  
  800294:	c3                   	ret    

00800295 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800295:	55                   	push   %ebp
  800296:	89 e5                	mov    %esp,%ebp
  800298:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80029b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80029e:	50                   	push   %eax
  80029f:	ff 75 08             	pushl  0x8(%ebp)
  8002a2:	e8 9d ff ff ff       	call   800244 <vcprintf>
	va_end(ap);

	return cnt;
}
  8002a7:	c9                   	leave  
  8002a8:	c3                   	ret    

008002a9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 1c             	sub    $0x1c,%esp
  8002b2:	89 c7                	mov    %eax,%edi
  8002b4:	89 d6                	mov    %edx,%esi
  8002b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8002bf:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8002c2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8002c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ca:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8002cd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8002d0:	39 d3                	cmp    %edx,%ebx
  8002d2:	72 05                	jb     8002d9 <printnum+0x30>
  8002d4:	39 45 10             	cmp    %eax,0x10(%ebp)
  8002d7:	77 78                	ja     800351 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	ff 75 18             	pushl  0x18(%ebp)
  8002df:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e2:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8002e5:	53                   	push   %ebx
  8002e6:	ff 75 10             	pushl  0x10(%ebp)
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8002f2:	ff 75 dc             	pushl  -0x24(%ebp)
  8002f5:	ff 75 d8             	pushl  -0x28(%ebp)
  8002f8:	e8 ef 1d 00 00       	call   8020ec <__udivdi3>
  8002fd:	83 c4 18             	add    $0x18,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	89 f2                	mov    %esi,%edx
  800304:	89 f8                	mov    %edi,%eax
  800306:	e8 9e ff ff ff       	call   8002a9 <printnum>
  80030b:	83 c4 20             	add    $0x20,%esp
  80030e:	eb 11                	jmp    800321 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800310:	83 ec 08             	sub    $0x8,%esp
  800313:	56                   	push   %esi
  800314:	ff 75 18             	pushl  0x18(%ebp)
  800317:	ff d7                	call   *%edi
  800319:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80031c:	4b                   	dec    %ebx
  80031d:	85 db                	test   %ebx,%ebx
  80031f:	7f ef                	jg     800310 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800321:	83 ec 08             	sub    $0x8,%esp
  800324:	56                   	push   %esi
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 e4             	pushl  -0x1c(%ebp)
  80032b:	ff 75 e0             	pushl  -0x20(%ebp)
  80032e:	ff 75 dc             	pushl  -0x24(%ebp)
  800331:	ff 75 d8             	pushl  -0x28(%ebp)
  800334:	e8 c3 1e 00 00       	call   8021fc <__umoddi3>
  800339:	83 c4 14             	add    $0x14,%esp
  80033c:	0f be 80 ec 23 80 00 	movsbl 0x8023ec(%eax),%eax
  800343:	50                   	push   %eax
  800344:	ff d7                	call   *%edi
}
  800346:	83 c4 10             	add    $0x10,%esp
  800349:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034c:	5b                   	pop    %ebx
  80034d:	5e                   	pop    %esi
  80034e:	5f                   	pop    %edi
  80034f:	5d                   	pop    %ebp
  800350:	c3                   	ret    
  800351:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800354:	eb c6                	jmp    80031c <printnum+0x73>

00800356 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800356:	55                   	push   %ebp
  800357:	89 e5                	mov    %esp,%ebp
  800359:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80035c:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80035f:	8b 10                	mov    (%eax),%edx
  800361:	3b 50 04             	cmp    0x4(%eax),%edx
  800364:	73 0a                	jae    800370 <sprintputch+0x1a>
		*b->buf++ = ch;
  800366:	8d 4a 01             	lea    0x1(%edx),%ecx
  800369:	89 08                	mov    %ecx,(%eax)
  80036b:	8b 45 08             	mov    0x8(%ebp),%eax
  80036e:	88 02                	mov    %al,(%edx)
}
  800370:	5d                   	pop    %ebp
  800371:	c3                   	ret    

00800372 <printfmt>:
{
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800378:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80037b:	50                   	push   %eax
  80037c:	ff 75 10             	pushl  0x10(%ebp)
  80037f:	ff 75 0c             	pushl  0xc(%ebp)
  800382:	ff 75 08             	pushl  0x8(%ebp)
  800385:	e8 05 00 00 00       	call   80038f <vprintfmt>
}
  80038a:	83 c4 10             	add    $0x10,%esp
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <vprintfmt>:
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	57                   	push   %edi
  800393:	56                   	push   %esi
  800394:	53                   	push   %ebx
  800395:	83 ec 2c             	sub    $0x2c,%esp
  800398:	8b 75 08             	mov    0x8(%ebp),%esi
  80039b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80039e:	8b 7d 10             	mov    0x10(%ebp),%edi
  8003a1:	e9 ae 03 00 00       	jmp    800754 <vprintfmt+0x3c5>
  8003a6:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8003aa:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8003b1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003b8:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8003bf:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003c4:	8d 47 01             	lea    0x1(%edi),%eax
  8003c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ca:	8a 17                	mov    (%edi),%dl
  8003cc:	8d 42 dd             	lea    -0x23(%edx),%eax
  8003cf:	3c 55                	cmp    $0x55,%al
  8003d1:	0f 87 fe 03 00 00    	ja     8007d5 <vprintfmt+0x446>
  8003d7:	0f b6 c0             	movzbl %al,%eax
  8003da:	ff 24 85 20 25 80 00 	jmp    *0x802520(,%eax,4)
  8003e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8003e4:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003e8:	eb da                	jmp    8003c4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003ed:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003f1:	eb d1                	jmp    8003c4 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003f3:	0f b6 d2             	movzbl %dl,%edx
  8003f6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8003fe:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800401:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800404:	01 c0                	add    %eax,%eax
  800406:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80040a:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  80040d:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800410:	83 f9 09             	cmp    $0x9,%ecx
  800413:	77 52                	ja     800467 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800415:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800416:	eb e9                	jmp    800401 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800418:	8b 45 14             	mov    0x14(%ebp),%eax
  80041b:	8b 00                	mov    (%eax),%eax
  80041d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800420:	8b 45 14             	mov    0x14(%ebp),%eax
  800423:	8d 40 04             	lea    0x4(%eax),%eax
  800426:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800429:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  80042c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800430:	79 92                	jns    8003c4 <vprintfmt+0x35>
				width = precision, precision = -1;
  800432:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800435:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800438:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80043f:	eb 83                	jmp    8003c4 <vprintfmt+0x35>
  800441:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800445:	78 08                	js     80044f <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800447:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80044a:	e9 75 ff ff ff       	jmp    8003c4 <vprintfmt+0x35>
  80044f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800456:	eb ef                	jmp    800447 <vprintfmt+0xb8>
  800458:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80045b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800462:	e9 5d ff ff ff       	jmp    8003c4 <vprintfmt+0x35>
  800467:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80046a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80046d:	eb bd                	jmp    80042c <vprintfmt+0x9d>
			lflag++;
  80046f:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800470:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800473:	e9 4c ff ff ff       	jmp    8003c4 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800478:	8b 45 14             	mov    0x14(%ebp),%eax
  80047b:	8d 78 04             	lea    0x4(%eax),%edi
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 30                	pushl  (%eax)
  800484:	ff d6                	call   *%esi
			break;
  800486:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800489:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80048c:	e9 c0 02 00 00       	jmp    800751 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800491:	8b 45 14             	mov    0x14(%ebp),%eax
  800494:	8d 78 04             	lea    0x4(%eax),%edi
  800497:	8b 00                	mov    (%eax),%eax
  800499:	85 c0                	test   %eax,%eax
  80049b:	78 2a                	js     8004c7 <vprintfmt+0x138>
  80049d:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80049f:	83 f8 0f             	cmp    $0xf,%eax
  8004a2:	7f 27                	jg     8004cb <vprintfmt+0x13c>
  8004a4:	8b 04 85 80 26 80 00 	mov    0x802680(,%eax,4),%eax
  8004ab:	85 c0                	test   %eax,%eax
  8004ad:	74 1c                	je     8004cb <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8004af:	50                   	push   %eax
  8004b0:	68 a8 27 80 00       	push   $0x8027a8
  8004b5:	53                   	push   %ebx
  8004b6:	56                   	push   %esi
  8004b7:	e8 b6 fe ff ff       	call   800372 <printfmt>
  8004bc:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004bf:	89 7d 14             	mov    %edi,0x14(%ebp)
  8004c2:	e9 8a 02 00 00       	jmp    800751 <vprintfmt+0x3c2>
  8004c7:	f7 d8                	neg    %eax
  8004c9:	eb d2                	jmp    80049d <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8004cb:	52                   	push   %edx
  8004cc:	68 04 24 80 00       	push   $0x802404
  8004d1:	53                   	push   %ebx
  8004d2:	56                   	push   %esi
  8004d3:	e8 9a fe ff ff       	call   800372 <printfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8004db:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8004de:	e9 6e 02 00 00       	jmp    800751 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8004e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e6:	83 c0 04             	add    $0x4,%eax
  8004e9:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8b 38                	mov    (%eax),%edi
  8004f1:	85 ff                	test   %edi,%edi
  8004f3:	74 39                	je     80052e <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004f5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f9:	0f 8e a9 00 00 00    	jle    8005a8 <vprintfmt+0x219>
  8004ff:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800503:	0f 84 a7 00 00 00    	je     8005b0 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	ff 75 d0             	pushl  -0x30(%ebp)
  80050f:	57                   	push   %edi
  800510:	e8 6b 03 00 00       	call   800880 <strnlen>
  800515:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800518:	29 c1                	sub    %eax,%ecx
  80051a:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  80051d:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800520:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800524:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800527:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80052a:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  80052c:	eb 14                	jmp    800542 <vprintfmt+0x1b3>
				p = "(null)";
  80052e:	bf fd 23 80 00       	mov    $0x8023fd,%edi
  800533:	eb c0                	jmp    8004f5 <vprintfmt+0x166>
					putch(padc, putdat);
  800535:	83 ec 08             	sub    $0x8,%esp
  800538:	53                   	push   %ebx
  800539:	ff 75 e0             	pushl  -0x20(%ebp)
  80053c:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80053e:	4f                   	dec    %edi
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	85 ff                	test   %edi,%edi
  800544:	7f ef                	jg     800535 <vprintfmt+0x1a6>
  800546:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800549:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80054c:	89 c8                	mov    %ecx,%eax
  80054e:	85 c9                	test   %ecx,%ecx
  800550:	78 10                	js     800562 <vprintfmt+0x1d3>
  800552:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800555:	29 c1                	sub    %eax,%ecx
  800557:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80055a:	89 75 08             	mov    %esi,0x8(%ebp)
  80055d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800560:	eb 15                	jmp    800577 <vprintfmt+0x1e8>
  800562:	b8 00 00 00 00       	mov    $0x0,%eax
  800567:	eb e9                	jmp    800552 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	52                   	push   %edx
  80056e:	ff 55 08             	call   *0x8(%ebp)
  800571:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800574:	ff 4d e0             	decl   -0x20(%ebp)
  800577:	47                   	inc    %edi
  800578:	8a 47 ff             	mov    -0x1(%edi),%al
  80057b:	0f be d0             	movsbl %al,%edx
  80057e:	85 d2                	test   %edx,%edx
  800580:	74 59                	je     8005db <vprintfmt+0x24c>
  800582:	85 f6                	test   %esi,%esi
  800584:	78 03                	js     800589 <vprintfmt+0x1fa>
  800586:	4e                   	dec    %esi
  800587:	78 2f                	js     8005b8 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800589:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80058d:	74 da                	je     800569 <vprintfmt+0x1da>
  80058f:	0f be c0             	movsbl %al,%eax
  800592:	83 e8 20             	sub    $0x20,%eax
  800595:	83 f8 5e             	cmp    $0x5e,%eax
  800598:	76 cf                	jbe    800569 <vprintfmt+0x1da>
					putch('?', putdat);
  80059a:	83 ec 08             	sub    $0x8,%esp
  80059d:	53                   	push   %ebx
  80059e:	6a 3f                	push   $0x3f
  8005a0:	ff 55 08             	call   *0x8(%ebp)
  8005a3:	83 c4 10             	add    $0x10,%esp
  8005a6:	eb cc                	jmp    800574 <vprintfmt+0x1e5>
  8005a8:	89 75 08             	mov    %esi,0x8(%ebp)
  8005ab:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005ae:	eb c7                	jmp    800577 <vprintfmt+0x1e8>
  8005b0:	89 75 08             	mov    %esi,0x8(%ebp)
  8005b3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8005b6:	eb bf                	jmp    800577 <vprintfmt+0x1e8>
  8005b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8005bb:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005be:	eb 0c                	jmp    8005cc <vprintfmt+0x23d>
				putch(' ', putdat);
  8005c0:	83 ec 08             	sub    $0x8,%esp
  8005c3:	53                   	push   %ebx
  8005c4:	6a 20                	push   $0x20
  8005c6:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8005c8:	4f                   	dec    %edi
  8005c9:	83 c4 10             	add    $0x10,%esp
  8005cc:	85 ff                	test   %edi,%edi
  8005ce:	7f f0                	jg     8005c0 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d0:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005d6:	e9 76 01 00 00       	jmp    800751 <vprintfmt+0x3c2>
  8005db:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8005de:	8b 75 08             	mov    0x8(%ebp),%esi
  8005e1:	eb e9                	jmp    8005cc <vprintfmt+0x23d>
	if (lflag >= 2)
  8005e3:	83 f9 01             	cmp    $0x1,%ecx
  8005e6:	7f 1f                	jg     800607 <vprintfmt+0x278>
	else if (lflag)
  8005e8:	85 c9                	test   %ecx,%ecx
  8005ea:	75 48                	jne    800634 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	8b 00                	mov    (%eax),%eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f4:	89 c1                	mov    %eax,%ecx
  8005f6:	c1 f9 1f             	sar    $0x1f,%ecx
  8005f9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ff:	8d 40 04             	lea    0x4(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
  800605:	eb 17                	jmp    80061e <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	8b 50 04             	mov    0x4(%eax),%edx
  80060d:	8b 00                	mov    (%eax),%eax
  80060f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800612:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8d 40 08             	lea    0x8(%eax),%eax
  80061b:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  80061e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800621:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800624:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800628:	78 25                	js     80064f <vprintfmt+0x2c0>
			base = 10;
  80062a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062f:	e9 03 01 00 00       	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 00                	mov    (%eax),%eax
  800639:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80063c:	89 c1                	mov    %eax,%ecx
  80063e:	c1 f9 1f             	sar    $0x1f,%ecx
  800641:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8d 40 04             	lea    0x4(%eax),%eax
  80064a:	89 45 14             	mov    %eax,0x14(%ebp)
  80064d:	eb cf                	jmp    80061e <vprintfmt+0x28f>
				putch('-', putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	6a 2d                	push   $0x2d
  800655:	ff d6                	call   *%esi
				num = -(long long) num;
  800657:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80065a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80065d:	f7 da                	neg    %edx
  80065f:	83 d1 00             	adc    $0x0,%ecx
  800662:	f7 d9                	neg    %ecx
  800664:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800667:	b8 0a 00 00 00       	mov    $0xa,%eax
  80066c:	e9 c6 00 00 00       	jmp    800737 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800671:	83 f9 01             	cmp    $0x1,%ecx
  800674:	7f 1e                	jg     800694 <vprintfmt+0x305>
	else if (lflag)
  800676:	85 c9                	test   %ecx,%ecx
  800678:	75 32                	jne    8006ac <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80067a:	8b 45 14             	mov    0x14(%ebp),%eax
  80067d:	8b 10                	mov    (%eax),%edx
  80067f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800684:	8d 40 04             	lea    0x4(%eax),%eax
  800687:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80068a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80068f:	e9 a3 00 00 00       	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800694:	8b 45 14             	mov    0x14(%ebp),%eax
  800697:	8b 10                	mov    (%eax),%edx
  800699:	8b 48 04             	mov    0x4(%eax),%ecx
  80069c:	8d 40 08             	lea    0x8(%eax),%eax
  80069f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006a2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006a7:	e9 8b 00 00 00       	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8b 10                	mov    (%eax),%edx
  8006b1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006b6:	8d 40 04             	lea    0x4(%eax),%eax
  8006b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8006bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006c1:	eb 74                	jmp    800737 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8006c3:	83 f9 01             	cmp    $0x1,%ecx
  8006c6:	7f 1b                	jg     8006e3 <vprintfmt+0x354>
	else if (lflag)
  8006c8:	85 c9                	test   %ecx,%ecx
  8006ca:	75 2c                	jne    8006f8 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8006cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cf:	8b 10                	mov    (%eax),%edx
  8006d1:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d6:	8d 40 04             	lea    0x4(%eax),%eax
  8006d9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006dc:	b8 08 00 00 00       	mov    $0x8,%eax
  8006e1:	eb 54                	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e6:	8b 10                	mov    (%eax),%edx
  8006e8:	8b 48 04             	mov    0x4(%eax),%ecx
  8006eb:	8d 40 08             	lea    0x8(%eax),%eax
  8006ee:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006f1:	b8 08 00 00 00       	mov    $0x8,%eax
  8006f6:	eb 3f                	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006fb:	8b 10                	mov    (%eax),%edx
  8006fd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800702:	8d 40 04             	lea    0x4(%eax),%eax
  800705:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800708:	b8 08 00 00 00       	mov    $0x8,%eax
  80070d:	eb 28                	jmp    800737 <vprintfmt+0x3a8>
			putch('0', putdat);
  80070f:	83 ec 08             	sub    $0x8,%esp
  800712:	53                   	push   %ebx
  800713:	6a 30                	push   $0x30
  800715:	ff d6                	call   *%esi
			putch('x', putdat);
  800717:	83 c4 08             	add    $0x8,%esp
  80071a:	53                   	push   %ebx
  80071b:	6a 78                	push   $0x78
  80071d:	ff d6                	call   *%esi
			num = (unsigned long long)
  80071f:	8b 45 14             	mov    0x14(%ebp),%eax
  800722:	8b 10                	mov    (%eax),%edx
  800724:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800729:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  80072c:	8d 40 04             	lea    0x4(%eax),%eax
  80072f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800732:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800737:	83 ec 0c             	sub    $0xc,%esp
  80073a:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80073e:	57                   	push   %edi
  80073f:	ff 75 e0             	pushl  -0x20(%ebp)
  800742:	50                   	push   %eax
  800743:	51                   	push   %ecx
  800744:	52                   	push   %edx
  800745:	89 da                	mov    %ebx,%edx
  800747:	89 f0                	mov    %esi,%eax
  800749:	e8 5b fb ff ff       	call   8002a9 <printnum>
			break;
  80074e:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800751:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800754:	47                   	inc    %edi
  800755:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800759:	83 f8 25             	cmp    $0x25,%eax
  80075c:	0f 84 44 fc ff ff    	je     8003a6 <vprintfmt+0x17>
			if (ch == '\0')
  800762:	85 c0                	test   %eax,%eax
  800764:	0f 84 89 00 00 00    	je     8007f3 <vprintfmt+0x464>
			putch(ch, putdat);
  80076a:	83 ec 08             	sub    $0x8,%esp
  80076d:	53                   	push   %ebx
  80076e:	50                   	push   %eax
  80076f:	ff d6                	call   *%esi
  800771:	83 c4 10             	add    $0x10,%esp
  800774:	eb de                	jmp    800754 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800776:	83 f9 01             	cmp    $0x1,%ecx
  800779:	7f 1b                	jg     800796 <vprintfmt+0x407>
	else if (lflag)
  80077b:	85 c9                	test   %ecx,%ecx
  80077d:	75 2c                	jne    8007ab <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80077f:	8b 45 14             	mov    0x14(%ebp),%eax
  800782:	8b 10                	mov    (%eax),%edx
  800784:	b9 00 00 00 00       	mov    $0x0,%ecx
  800789:	8d 40 04             	lea    0x4(%eax),%eax
  80078c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80078f:	b8 10 00 00 00       	mov    $0x10,%eax
  800794:	eb a1                	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800796:	8b 45 14             	mov    0x14(%ebp),%eax
  800799:	8b 10                	mov    (%eax),%edx
  80079b:	8b 48 04             	mov    0x4(%eax),%ecx
  80079e:	8d 40 08             	lea    0x8(%eax),%eax
  8007a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007a4:	b8 10 00 00 00       	mov    $0x10,%eax
  8007a9:	eb 8c                	jmp    800737 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ae:	8b 10                	mov    (%eax),%edx
  8007b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b5:	8d 40 04             	lea    0x4(%eax),%eax
  8007b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007bb:	b8 10 00 00 00       	mov    $0x10,%eax
  8007c0:	e9 72 ff ff ff       	jmp    800737 <vprintfmt+0x3a8>
			putch(ch, putdat);
  8007c5:	83 ec 08             	sub    $0x8,%esp
  8007c8:	53                   	push   %ebx
  8007c9:	6a 25                	push   $0x25
  8007cb:	ff d6                	call   *%esi
			break;
  8007cd:	83 c4 10             	add    $0x10,%esp
  8007d0:	e9 7c ff ff ff       	jmp    800751 <vprintfmt+0x3c2>
			putch('%', putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	6a 25                	push   $0x25
  8007db:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8007dd:	83 c4 10             	add    $0x10,%esp
  8007e0:	89 f8                	mov    %edi,%eax
  8007e2:	eb 01                	jmp    8007e5 <vprintfmt+0x456>
  8007e4:	48                   	dec    %eax
  8007e5:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007e9:	75 f9                	jne    8007e4 <vprintfmt+0x455>
  8007eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ee:	e9 5e ff ff ff       	jmp    800751 <vprintfmt+0x3c2>
}
  8007f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007f6:	5b                   	pop    %ebx
  8007f7:	5e                   	pop    %esi
  8007f8:	5f                   	pop    %edi
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    

008007fb <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007fb:	55                   	push   %ebp
  8007fc:	89 e5                	mov    %esp,%ebp
  8007fe:	83 ec 18             	sub    $0x18,%esp
  800801:	8b 45 08             	mov    0x8(%ebp),%eax
  800804:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800807:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80080a:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  80080e:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800811:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800818:	85 c0                	test   %eax,%eax
  80081a:	74 26                	je     800842 <vsnprintf+0x47>
  80081c:	85 d2                	test   %edx,%edx
  80081e:	7e 29                	jle    800849 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800820:	ff 75 14             	pushl  0x14(%ebp)
  800823:	ff 75 10             	pushl  0x10(%ebp)
  800826:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800829:	50                   	push   %eax
  80082a:	68 56 03 80 00       	push   $0x800356
  80082f:	e8 5b fb ff ff       	call   80038f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800834:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800837:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80083a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80083d:	83 c4 10             	add    $0x10,%esp
}
  800840:	c9                   	leave  
  800841:	c3                   	ret    
		return -E_INVAL;
  800842:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800847:	eb f7                	jmp    800840 <vsnprintf+0x45>
  800849:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80084e:	eb f0                	jmp    800840 <vsnprintf+0x45>

00800850 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800856:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800859:	50                   	push   %eax
  80085a:	ff 75 10             	pushl  0x10(%ebp)
  80085d:	ff 75 0c             	pushl  0xc(%ebp)
  800860:	ff 75 08             	pushl  0x8(%ebp)
  800863:	e8 93 ff ff ff       	call   8007fb <vsnprintf>
	va_end(ap);

	return rc;
}
  800868:	c9                   	leave  
  800869:	c3                   	ret    

0080086a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80086a:	55                   	push   %ebp
  80086b:	89 e5                	mov    %esp,%ebp
  80086d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800870:	b8 00 00 00 00       	mov    $0x0,%eax
  800875:	eb 01                	jmp    800878 <strlen+0xe>
		n++;
  800877:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800878:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80087c:	75 f9                	jne    800877 <strlen+0xd>
	return n;
}
  80087e:	5d                   	pop    %ebp
  80087f:	c3                   	ret    

00800880 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800880:	55                   	push   %ebp
  800881:	89 e5                	mov    %esp,%ebp
  800883:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800886:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
  80088e:	eb 01                	jmp    800891 <strnlen+0x11>
		n++;
  800890:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800891:	39 d0                	cmp    %edx,%eax
  800893:	74 06                	je     80089b <strnlen+0x1b>
  800895:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800899:	75 f5                	jne    800890 <strnlen+0x10>
	return n;
}
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    

0080089d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	53                   	push   %ebx
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8008a7:	89 c2                	mov    %eax,%edx
  8008a9:	42                   	inc    %edx
  8008aa:	41                   	inc    %ecx
  8008ab:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8008ae:	88 5a ff             	mov    %bl,-0x1(%edx)
  8008b1:	84 db                	test   %bl,%bl
  8008b3:	75 f4                	jne    8008a9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8008b5:	5b                   	pop    %ebx
  8008b6:	5d                   	pop    %ebp
  8008b7:	c3                   	ret    

008008b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8008b8:	55                   	push   %ebp
  8008b9:	89 e5                	mov    %esp,%ebp
  8008bb:	53                   	push   %ebx
  8008bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8008bf:	53                   	push   %ebx
  8008c0:	e8 a5 ff ff ff       	call   80086a <strlen>
  8008c5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8008c8:	ff 75 0c             	pushl  0xc(%ebp)
  8008cb:	01 d8                	add    %ebx,%eax
  8008cd:	50                   	push   %eax
  8008ce:	e8 ca ff ff ff       	call   80089d <strcpy>
	return dst;
}
  8008d3:	89 d8                	mov    %ebx,%eax
  8008d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008d8:	c9                   	leave  
  8008d9:	c3                   	ret    

008008da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8008da:	55                   	push   %ebp
  8008db:	89 e5                	mov    %esp,%ebp
  8008dd:	56                   	push   %esi
  8008de:	53                   	push   %ebx
  8008df:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8008e5:	89 f3                	mov    %esi,%ebx
  8008e7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008ea:	89 f2                	mov    %esi,%edx
  8008ec:	eb 0c                	jmp    8008fa <strncpy+0x20>
		*dst++ = *src;
  8008ee:	42                   	inc    %edx
  8008ef:	8a 01                	mov    (%ecx),%al
  8008f1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008f4:	80 39 01             	cmpb   $0x1,(%ecx)
  8008f7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008fa:	39 da                	cmp    %ebx,%edx
  8008fc:	75 f0                	jne    8008ee <strncpy+0x14>
	}
	return ret;
}
  8008fe:	89 f0                	mov    %esi,%eax
  800900:	5b                   	pop    %ebx
  800901:	5e                   	pop    %esi
  800902:	5d                   	pop    %ebp
  800903:	c3                   	ret    

00800904 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800904:	55                   	push   %ebp
  800905:	89 e5                	mov    %esp,%ebp
  800907:	56                   	push   %esi
  800908:	53                   	push   %ebx
  800909:	8b 75 08             	mov    0x8(%ebp),%esi
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800912:	85 c0                	test   %eax,%eax
  800914:	74 20                	je     800936 <strlcpy+0x32>
  800916:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  80091a:	89 f0                	mov    %esi,%eax
  80091c:	eb 05                	jmp    800923 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80091e:	40                   	inc    %eax
  80091f:	42                   	inc    %edx
  800920:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800923:	39 d8                	cmp    %ebx,%eax
  800925:	74 06                	je     80092d <strlcpy+0x29>
  800927:	8a 0a                	mov    (%edx),%cl
  800929:	84 c9                	test   %cl,%cl
  80092b:	75 f1                	jne    80091e <strlcpy+0x1a>
		*dst = '\0';
  80092d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800930:	29 f0                	sub    %esi,%eax
}
  800932:	5b                   	pop    %ebx
  800933:	5e                   	pop    %esi
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    
  800936:	89 f0                	mov    %esi,%eax
  800938:	eb f6                	jmp    800930 <strlcpy+0x2c>

0080093a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80093a:	55                   	push   %ebp
  80093b:	89 e5                	mov    %esp,%ebp
  80093d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800943:	eb 02                	jmp    800947 <strcmp+0xd>
		p++, q++;
  800945:	41                   	inc    %ecx
  800946:	42                   	inc    %edx
	while (*p && *p == *q)
  800947:	8a 01                	mov    (%ecx),%al
  800949:	84 c0                	test   %al,%al
  80094b:	74 04                	je     800951 <strcmp+0x17>
  80094d:	3a 02                	cmp    (%edx),%al
  80094f:	74 f4                	je     800945 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800951:	0f b6 c0             	movzbl %al,%eax
  800954:	0f b6 12             	movzbl (%edx),%edx
  800957:	29 d0                	sub    %edx,%eax
}
  800959:	5d                   	pop    %ebp
  80095a:	c3                   	ret    

0080095b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
  80095e:	53                   	push   %ebx
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	8b 55 0c             	mov    0xc(%ebp),%edx
  800965:	89 c3                	mov    %eax,%ebx
  800967:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80096a:	eb 02                	jmp    80096e <strncmp+0x13>
		n--, p++, q++;
  80096c:	40                   	inc    %eax
  80096d:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80096e:	39 d8                	cmp    %ebx,%eax
  800970:	74 15                	je     800987 <strncmp+0x2c>
  800972:	8a 08                	mov    (%eax),%cl
  800974:	84 c9                	test   %cl,%cl
  800976:	74 04                	je     80097c <strncmp+0x21>
  800978:	3a 0a                	cmp    (%edx),%cl
  80097a:	74 f0                	je     80096c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80097c:	0f b6 00             	movzbl (%eax),%eax
  80097f:	0f b6 12             	movzbl (%edx),%edx
  800982:	29 d0                	sub    %edx,%eax
}
  800984:	5b                   	pop    %ebx
  800985:	5d                   	pop    %ebp
  800986:	c3                   	ret    
		return 0;
  800987:	b8 00 00 00 00       	mov    $0x0,%eax
  80098c:	eb f6                	jmp    800984 <strncmp+0x29>

0080098e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80098e:	55                   	push   %ebp
  80098f:	89 e5                	mov    %esp,%ebp
  800991:	8b 45 08             	mov    0x8(%ebp),%eax
  800994:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800997:	8a 10                	mov    (%eax),%dl
  800999:	84 d2                	test   %dl,%dl
  80099b:	74 07                	je     8009a4 <strchr+0x16>
		if (*s == c)
  80099d:	38 ca                	cmp    %cl,%dl
  80099f:	74 08                	je     8009a9 <strchr+0x1b>
	for (; *s; s++)
  8009a1:	40                   	inc    %eax
  8009a2:	eb f3                	jmp    800997 <strchr+0x9>
			return (char *) s;
	return 0;
  8009a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b1:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8009b4:	8a 10                	mov    (%eax),%dl
  8009b6:	84 d2                	test   %dl,%dl
  8009b8:	74 07                	je     8009c1 <strfind+0x16>
		if (*s == c)
  8009ba:	38 ca                	cmp    %cl,%dl
  8009bc:	74 03                	je     8009c1 <strfind+0x16>
	for (; *s; s++)
  8009be:	40                   	inc    %eax
  8009bf:	eb f3                	jmp    8009b4 <strfind+0x9>
			break;
	return (char *) s;
}
  8009c1:	5d                   	pop    %ebp
  8009c2:	c3                   	ret    

008009c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8009c3:	55                   	push   %ebp
  8009c4:	89 e5                	mov    %esp,%ebp
  8009c6:	57                   	push   %edi
  8009c7:	56                   	push   %esi
  8009c8:	53                   	push   %ebx
  8009c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8009cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8009cf:	85 c9                	test   %ecx,%ecx
  8009d1:	74 13                	je     8009e6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8009d3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8009d9:	75 05                	jne    8009e0 <memset+0x1d>
  8009db:	f6 c1 03             	test   $0x3,%cl
  8009de:	74 0d                	je     8009ed <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8009e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e3:	fc                   	cld    
  8009e4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009e6:	89 f8                	mov    %edi,%eax
  8009e8:	5b                   	pop    %ebx
  8009e9:	5e                   	pop    %esi
  8009ea:	5f                   	pop    %edi
  8009eb:	5d                   	pop    %ebp
  8009ec:	c3                   	ret    
		c &= 0xFF;
  8009ed:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009f1:	89 d3                	mov    %edx,%ebx
  8009f3:	c1 e3 08             	shl    $0x8,%ebx
  8009f6:	89 d0                	mov    %edx,%eax
  8009f8:	c1 e0 18             	shl    $0x18,%eax
  8009fb:	89 d6                	mov    %edx,%esi
  8009fd:	c1 e6 10             	shl    $0x10,%esi
  800a00:	09 f0                	or     %esi,%eax
  800a02:	09 c2                	or     %eax,%edx
  800a04:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800a06:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800a09:	89 d0                	mov    %edx,%eax
  800a0b:	fc                   	cld    
  800a0c:	f3 ab                	rep stos %eax,%es:(%edi)
  800a0e:	eb d6                	jmp    8009e6 <memset+0x23>

00800a10 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800a10:	55                   	push   %ebp
  800a11:	89 e5                	mov    %esp,%ebp
  800a13:	57                   	push   %edi
  800a14:	56                   	push   %esi
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a1b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800a1e:	39 c6                	cmp    %eax,%esi
  800a20:	73 33                	jae    800a55 <memmove+0x45>
  800a22:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800a25:	39 d0                	cmp    %edx,%eax
  800a27:	73 2c                	jae    800a55 <memmove+0x45>
		s += n;
		d += n;
  800a29:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a2c:	89 d6                	mov    %edx,%esi
  800a2e:	09 fe                	or     %edi,%esi
  800a30:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800a36:	75 13                	jne    800a4b <memmove+0x3b>
  800a38:	f6 c1 03             	test   $0x3,%cl
  800a3b:	75 0e                	jne    800a4b <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800a3d:	83 ef 04             	sub    $0x4,%edi
  800a40:	8d 72 fc             	lea    -0x4(%edx),%esi
  800a43:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a46:	fd                   	std    
  800a47:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a49:	eb 07                	jmp    800a52 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a4b:	4f                   	dec    %edi
  800a4c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a4f:	fd                   	std    
  800a50:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a52:	fc                   	cld    
  800a53:	eb 13                	jmp    800a68 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a55:	89 f2                	mov    %esi,%edx
  800a57:	09 c2                	or     %eax,%edx
  800a59:	f6 c2 03             	test   $0x3,%dl
  800a5c:	75 05                	jne    800a63 <memmove+0x53>
  800a5e:	f6 c1 03             	test   $0x3,%cl
  800a61:	74 09                	je     800a6c <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a63:	89 c7                	mov    %eax,%edi
  800a65:	fc                   	cld    
  800a66:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a68:	5e                   	pop    %esi
  800a69:	5f                   	pop    %edi
  800a6a:	5d                   	pop    %ebp
  800a6b:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a6c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a6f:	89 c7                	mov    %eax,%edi
  800a71:	fc                   	cld    
  800a72:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a74:	eb f2                	jmp    800a68 <memmove+0x58>

00800a76 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a79:	ff 75 10             	pushl  0x10(%ebp)
  800a7c:	ff 75 0c             	pushl  0xc(%ebp)
  800a7f:	ff 75 08             	pushl  0x8(%ebp)
  800a82:	e8 89 ff ff ff       	call   800a10 <memmove>
}
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	56                   	push   %esi
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	89 c6                	mov    %eax,%esi
  800a93:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a96:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a99:	39 f0                	cmp    %esi,%eax
  800a9b:	74 16                	je     800ab3 <memcmp+0x2a>
		if (*s1 != *s2)
  800a9d:	8a 08                	mov    (%eax),%cl
  800a9f:	8a 1a                	mov    (%edx),%bl
  800aa1:	38 d9                	cmp    %bl,%cl
  800aa3:	75 04                	jne    800aa9 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800aa5:	40                   	inc    %eax
  800aa6:	42                   	inc    %edx
  800aa7:	eb f0                	jmp    800a99 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800aa9:	0f b6 c1             	movzbl %cl,%eax
  800aac:	0f b6 db             	movzbl %bl,%ebx
  800aaf:	29 d8                	sub    %ebx,%eax
  800ab1:	eb 05                	jmp    800ab8 <memcmp+0x2f>
	}

	return 0;
  800ab3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ab8:	5b                   	pop    %ebx
  800ab9:	5e                   	pop    %esi
  800aba:	5d                   	pop    %ebp
  800abb:	c3                   	ret    

00800abc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800ac5:	89 c2                	mov    %eax,%edx
  800ac7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800aca:	39 d0                	cmp    %edx,%eax
  800acc:	73 07                	jae    800ad5 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ace:	38 08                	cmp    %cl,(%eax)
  800ad0:	74 03                	je     800ad5 <memfind+0x19>
	for (; s < ends; s++)
  800ad2:	40                   	inc    %eax
  800ad3:	eb f5                	jmp    800aca <memfind+0xe>
			break;
	return (void *) s;
}
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
  800add:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800ae0:	eb 01                	jmp    800ae3 <strtol+0xc>
		s++;
  800ae2:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800ae3:	8a 01                	mov    (%ecx),%al
  800ae5:	3c 20                	cmp    $0x20,%al
  800ae7:	74 f9                	je     800ae2 <strtol+0xb>
  800ae9:	3c 09                	cmp    $0x9,%al
  800aeb:	74 f5                	je     800ae2 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800aed:	3c 2b                	cmp    $0x2b,%al
  800aef:	74 2b                	je     800b1c <strtol+0x45>
		s++;
	else if (*s == '-')
  800af1:	3c 2d                	cmp    $0x2d,%al
  800af3:	74 2f                	je     800b24 <strtol+0x4d>
	int neg = 0;
  800af5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800afa:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800b01:	75 12                	jne    800b15 <strtol+0x3e>
  800b03:	80 39 30             	cmpb   $0x30,(%ecx)
  800b06:	74 24                	je     800b2c <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800b08:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b0c:	75 07                	jne    800b15 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800b0e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800b15:	b8 00 00 00 00       	mov    $0x0,%eax
  800b1a:	eb 4e                	jmp    800b6a <strtol+0x93>
		s++;
  800b1c:	41                   	inc    %ecx
	int neg = 0;
  800b1d:	bf 00 00 00 00       	mov    $0x0,%edi
  800b22:	eb d6                	jmp    800afa <strtol+0x23>
		s++, neg = 1;
  800b24:	41                   	inc    %ecx
  800b25:	bf 01 00 00 00       	mov    $0x1,%edi
  800b2a:	eb ce                	jmp    800afa <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800b2c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800b30:	74 10                	je     800b42 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800b32:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b36:	75 dd                	jne    800b15 <strtol+0x3e>
		s++, base = 8;
  800b38:	41                   	inc    %ecx
  800b39:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800b40:	eb d3                	jmp    800b15 <strtol+0x3e>
		s += 2, base = 16;
  800b42:	83 c1 02             	add    $0x2,%ecx
  800b45:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b4c:	eb c7                	jmp    800b15 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b4e:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b51:	89 f3                	mov    %esi,%ebx
  800b53:	80 fb 19             	cmp    $0x19,%bl
  800b56:	77 24                	ja     800b7c <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b58:	0f be d2             	movsbl %dl,%edx
  800b5b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b5e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b61:	7d 2b                	jge    800b8e <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b63:	41                   	inc    %ecx
  800b64:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b68:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b6a:	8a 11                	mov    (%ecx),%dl
  800b6c:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b6f:	80 fb 09             	cmp    $0x9,%bl
  800b72:	77 da                	ja     800b4e <strtol+0x77>
			dig = *s - '0';
  800b74:	0f be d2             	movsbl %dl,%edx
  800b77:	83 ea 30             	sub    $0x30,%edx
  800b7a:	eb e2                	jmp    800b5e <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b7c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b7f:	89 f3                	mov    %esi,%ebx
  800b81:	80 fb 19             	cmp    $0x19,%bl
  800b84:	77 08                	ja     800b8e <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b86:	0f be d2             	movsbl %dl,%edx
  800b89:	83 ea 37             	sub    $0x37,%edx
  800b8c:	eb d0                	jmp    800b5e <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b92:	74 05                	je     800b99 <strtol+0xc2>
		*endptr = (char *) s;
  800b94:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b97:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b99:	85 ff                	test   %edi,%edi
  800b9b:	74 02                	je     800b9f <strtol+0xc8>
  800b9d:	f7 d8                	neg    %eax
}
  800b9f:	5b                   	pop    %ebx
  800ba0:	5e                   	pop    %esi
  800ba1:	5f                   	pop    %edi
  800ba2:	5d                   	pop    %ebp
  800ba3:	c3                   	ret    

00800ba4 <atoi>:

int
atoi(const char *s)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800ba7:	6a 0a                	push   $0xa
  800ba9:	6a 00                	push   $0x0
  800bab:	ff 75 08             	pushl  0x8(%ebp)
  800bae:	e8 24 ff ff ff       	call   800ad7 <strtol>
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	57                   	push   %edi
  800bb9:	56                   	push   %esi
  800bba:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bbb:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc3:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc6:	89 c3                	mov    %eax,%ebx
  800bc8:	89 c7                	mov    %eax,%edi
  800bca:	89 c6                	mov    %eax,%esi
  800bcc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800bce:	5b                   	pop    %ebx
  800bcf:	5e                   	pop    %esi
  800bd0:	5f                   	pop    %edi
  800bd1:	5d                   	pop    %ebp
  800bd2:	c3                   	ret    

00800bd3 <sys_cgetc>:

int
sys_cgetc(void)
{
  800bd3:	55                   	push   %ebp
  800bd4:	89 e5                	mov    %esp,%ebp
  800bd6:	57                   	push   %edi
  800bd7:	56                   	push   %esi
  800bd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800bde:	b8 01 00 00 00       	mov    $0x1,%eax
  800be3:	89 d1                	mov    %edx,%ecx
  800be5:	89 d3                	mov    %edx,%ebx
  800be7:	89 d7                	mov    %edx,%edi
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800bed:	5b                   	pop    %ebx
  800bee:	5e                   	pop    %esi
  800bef:	5f                   	pop    %edi
  800bf0:	5d                   	pop    %ebp
  800bf1:	c3                   	ret    

00800bf2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bf2:	55                   	push   %ebp
  800bf3:	89 e5                	mov    %esp,%ebp
  800bf5:	57                   	push   %edi
  800bf6:	56                   	push   %esi
  800bf7:	53                   	push   %ebx
  800bf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c00:	b8 03 00 00 00       	mov    $0x3,%eax
  800c05:	8b 55 08             	mov    0x8(%ebp),%edx
  800c08:	89 cb                	mov    %ecx,%ebx
  800c0a:	89 cf                	mov    %ecx,%edi
  800c0c:	89 ce                	mov    %ecx,%esi
  800c0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c10:	85 c0                	test   %eax,%eax
  800c12:	7f 08                	jg     800c1c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800c14:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c17:	5b                   	pop    %ebx
  800c18:	5e                   	pop    %esi
  800c19:	5f                   	pop    %edi
  800c1a:	5d                   	pop    %ebp
  800c1b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c1c:	83 ec 0c             	sub    $0xc,%esp
  800c1f:	50                   	push   %eax
  800c20:	6a 03                	push   $0x3
  800c22:	68 df 26 80 00       	push   $0x8026df
  800c27:	6a 23                	push   $0x23
  800c29:	68 fc 26 80 00       	push   $0x8026fc
  800c2e:	e8 8b 13 00 00       	call   801fbe <_panic>

00800c33 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c39:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3e:	b8 02 00 00 00       	mov    $0x2,%eax
  800c43:	89 d1                	mov    %edx,%ecx
  800c45:	89 d3                	mov    %edx,%ebx
  800c47:	89 d7                	mov    %edx,%edi
  800c49:	89 d6                	mov    %edx,%esi
  800c4b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5b:	be 00 00 00 00       	mov    $0x0,%esi
  800c60:	b8 04 00 00 00       	mov    $0x4,%eax
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c6e:	89 f7                	mov    %esi,%edi
  800c70:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c72:	85 c0                	test   %eax,%eax
  800c74:	7f 08                	jg     800c7e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c76:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7e:	83 ec 0c             	sub    $0xc,%esp
  800c81:	50                   	push   %eax
  800c82:	6a 04                	push   $0x4
  800c84:	68 df 26 80 00       	push   $0x8026df
  800c89:	6a 23                	push   $0x23
  800c8b:	68 fc 26 80 00       	push   $0x8026fc
  800c90:	e8 29 13 00 00       	call   801fbe <_panic>

00800c95 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	53                   	push   %ebx
  800c9b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9e:	b8 05 00 00 00       	mov    $0x5,%eax
  800ca3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ca9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800cac:	8b 7d 14             	mov    0x14(%ebp),%edi
  800caf:	8b 75 18             	mov    0x18(%ebp),%esi
  800cb2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb4:	85 c0                	test   %eax,%eax
  800cb6:	7f 08                	jg     800cc0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800cb8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cbb:	5b                   	pop    %ebx
  800cbc:	5e                   	pop    %esi
  800cbd:	5f                   	pop    %edi
  800cbe:	5d                   	pop    %ebp
  800cbf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc0:	83 ec 0c             	sub    $0xc,%esp
  800cc3:	50                   	push   %eax
  800cc4:	6a 05                	push   $0x5
  800cc6:	68 df 26 80 00       	push   $0x8026df
  800ccb:	6a 23                	push   $0x23
  800ccd:	68 fc 26 80 00       	push   $0x8026fc
  800cd2:	e8 e7 12 00 00       	call   801fbe <_panic>

00800cd7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800cd7:	55                   	push   %ebp
  800cd8:	89 e5                	mov    %esp,%ebp
  800cda:	57                   	push   %edi
  800cdb:	56                   	push   %esi
  800cdc:	53                   	push   %ebx
  800cdd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ce0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce5:	b8 06 00 00 00       	mov    $0x6,%eax
  800cea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ced:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf0:	89 df                	mov    %ebx,%edi
  800cf2:	89 de                	mov    %ebx,%esi
  800cf4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf6:	85 c0                	test   %eax,%eax
  800cf8:	7f 08                	jg     800d02 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cfa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d02:	83 ec 0c             	sub    $0xc,%esp
  800d05:	50                   	push   %eax
  800d06:	6a 06                	push   $0x6
  800d08:	68 df 26 80 00       	push   $0x8026df
  800d0d:	6a 23                	push   $0x23
  800d0f:	68 fc 26 80 00       	push   $0x8026fc
  800d14:	e8 a5 12 00 00       	call   801fbe <_panic>

00800d19 <sys_yield>:

void
sys_yield(void)
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d1f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d24:	b8 0b 00 00 00       	mov    $0xb,%eax
  800d29:	89 d1                	mov    %edx,%ecx
  800d2b:	89 d3                	mov    %edx,%ebx
  800d2d:	89 d7                	mov    %edx,%edi
  800d2f:	89 d6                	mov    %edx,%esi
  800d31:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800d33:	5b                   	pop    %ebx
  800d34:	5e                   	pop    %esi
  800d35:	5f                   	pop    %edi
  800d36:	5d                   	pop    %ebp
  800d37:	c3                   	ret    

00800d38 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800d38:	55                   	push   %ebp
  800d39:	89 e5                	mov    %esp,%ebp
  800d3b:	57                   	push   %edi
  800d3c:	56                   	push   %esi
  800d3d:	53                   	push   %ebx
  800d3e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d46:	b8 08 00 00 00       	mov    $0x8,%eax
  800d4b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d51:	89 df                	mov    %ebx,%edi
  800d53:	89 de                	mov    %ebx,%esi
  800d55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d57:	85 c0                	test   %eax,%eax
  800d59:	7f 08                	jg     800d63 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d5e:	5b                   	pop    %ebx
  800d5f:	5e                   	pop    %esi
  800d60:	5f                   	pop    %edi
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d63:	83 ec 0c             	sub    $0xc,%esp
  800d66:	50                   	push   %eax
  800d67:	6a 08                	push   $0x8
  800d69:	68 df 26 80 00       	push   $0x8026df
  800d6e:	6a 23                	push   $0x23
  800d70:	68 fc 26 80 00       	push   $0x8026fc
  800d75:	e8 44 12 00 00       	call   801fbe <_panic>

00800d7a <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	57                   	push   %edi
  800d7e:	56                   	push   %esi
  800d7f:	53                   	push   %ebx
  800d80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d88:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d90:	89 cb                	mov    %ecx,%ebx
  800d92:	89 cf                	mov    %ecx,%edi
  800d94:	89 ce                	mov    %ecx,%esi
  800d96:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d98:	85 c0                	test   %eax,%eax
  800d9a:	7f 08                	jg     800da4 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d9c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9f:	5b                   	pop    %ebx
  800da0:	5e                   	pop    %esi
  800da1:	5f                   	pop    %edi
  800da2:	5d                   	pop    %ebp
  800da3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da4:	83 ec 0c             	sub    $0xc,%esp
  800da7:	50                   	push   %eax
  800da8:	6a 0c                	push   $0xc
  800daa:	68 df 26 80 00       	push   $0x8026df
  800daf:	6a 23                	push   $0x23
  800db1:	68 fc 26 80 00       	push   $0x8026fc
  800db6:	e8 03 12 00 00       	call   801fbe <_panic>

00800dbb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800dbb:	55                   	push   %ebp
  800dbc:	89 e5                	mov    %esp,%ebp
  800dbe:	57                   	push   %edi
  800dbf:	56                   	push   %esi
  800dc0:	53                   	push   %ebx
  800dc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc9:	b8 09 00 00 00       	mov    $0x9,%eax
  800dce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd4:	89 df                	mov    %ebx,%edi
  800dd6:	89 de                	mov    %ebx,%esi
  800dd8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dda:	85 c0                	test   %eax,%eax
  800ddc:	7f 08                	jg     800de6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800de1:	5b                   	pop    %ebx
  800de2:	5e                   	pop    %esi
  800de3:	5f                   	pop    %edi
  800de4:	5d                   	pop    %ebp
  800de5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de6:	83 ec 0c             	sub    $0xc,%esp
  800de9:	50                   	push   %eax
  800dea:	6a 09                	push   $0x9
  800dec:	68 df 26 80 00       	push   $0x8026df
  800df1:	6a 23                	push   $0x23
  800df3:	68 fc 26 80 00       	push   $0x8026fc
  800df8:	e8 c1 11 00 00       	call   801fbe <_panic>

00800dfd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	57                   	push   %edi
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e0b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800e10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e13:	8b 55 08             	mov    0x8(%ebp),%edx
  800e16:	89 df                	mov    %ebx,%edi
  800e18:	89 de                	mov    %ebx,%esi
  800e1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e1c:	85 c0                	test   %eax,%eax
  800e1e:	7f 08                	jg     800e28 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800e20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e23:	5b                   	pop    %ebx
  800e24:	5e                   	pop    %esi
  800e25:	5f                   	pop    %edi
  800e26:	5d                   	pop    %ebp
  800e27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e28:	83 ec 0c             	sub    $0xc,%esp
  800e2b:	50                   	push   %eax
  800e2c:	6a 0a                	push   $0xa
  800e2e:	68 df 26 80 00       	push   $0x8026df
  800e33:	6a 23                	push   $0x23
  800e35:	68 fc 26 80 00       	push   $0x8026fc
  800e3a:	e8 7f 11 00 00       	call   801fbe <_panic>

00800e3f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800e3f:	55                   	push   %ebp
  800e40:	89 e5                	mov    %esp,%ebp
  800e42:	57                   	push   %edi
  800e43:	56                   	push   %esi
  800e44:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e45:	be 00 00 00 00       	mov    $0x0,%esi
  800e4a:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e4f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e52:	8b 55 08             	mov    0x8(%ebp),%edx
  800e55:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e58:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e5b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e5d:	5b                   	pop    %ebx
  800e5e:	5e                   	pop    %esi
  800e5f:	5f                   	pop    %edi
  800e60:	5d                   	pop    %ebp
  800e61:	c3                   	ret    

00800e62 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	57                   	push   %edi
  800e66:	56                   	push   %esi
  800e67:	53                   	push   %ebx
  800e68:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e70:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e75:	8b 55 08             	mov    0x8(%ebp),%edx
  800e78:	89 cb                	mov    %ecx,%ebx
  800e7a:	89 cf                	mov    %ecx,%edi
  800e7c:	89 ce                	mov    %ecx,%esi
  800e7e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e80:	85 c0                	test   %eax,%eax
  800e82:	7f 08                	jg     800e8c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e87:	5b                   	pop    %ebx
  800e88:	5e                   	pop    %esi
  800e89:	5f                   	pop    %edi
  800e8a:	5d                   	pop    %ebp
  800e8b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	50                   	push   %eax
  800e90:	6a 0e                	push   $0xe
  800e92:	68 df 26 80 00       	push   $0x8026df
  800e97:	6a 23                	push   $0x23
  800e99:	68 fc 26 80 00       	push   $0x8026fc
  800e9e:	e8 1b 11 00 00       	call   801fbe <_panic>

00800ea3 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	57                   	push   %edi
  800ea7:	56                   	push   %esi
  800ea8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea9:	be 00 00 00 00       	mov    $0x0,%esi
  800eae:	b8 0f 00 00 00       	mov    $0xf,%eax
  800eb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ebc:	89 f7                	mov    %esi,%edi
  800ebe:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ec0:	5b                   	pop    %ebx
  800ec1:	5e                   	pop    %esi
  800ec2:	5f                   	pop    %edi
  800ec3:	5d                   	pop    %ebp
  800ec4:	c3                   	ret    

00800ec5 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	57                   	push   %edi
  800ec9:	56                   	push   %esi
  800eca:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ecb:	be 00 00 00 00       	mov    $0x0,%esi
  800ed0:	b8 10 00 00 00       	mov    $0x10,%eax
  800ed5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed8:	8b 55 08             	mov    0x8(%ebp),%edx
  800edb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ede:	89 f7                	mov    %esi,%edi
  800ee0:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800ee2:	5b                   	pop    %ebx
  800ee3:	5e                   	pop    %esi
  800ee4:	5f                   	pop    %edi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    

00800ee7 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800ee7:	55                   	push   %ebp
  800ee8:	89 e5                	mov    %esp,%ebp
  800eea:	57                   	push   %edi
  800eeb:	56                   	push   %esi
  800eec:	53                   	push   %ebx
	asm volatile("int %1\n"
  800eed:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ef2:	b8 11 00 00 00       	mov    $0x11,%eax
  800ef7:	8b 55 08             	mov    0x8(%ebp),%edx
  800efa:	89 cb                	mov    %ecx,%ebx
  800efc:	89 cf                	mov    %ecx,%edi
  800efe:	89 ce                	mov    %ecx,%esi
  800f00:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800f02:	5b                   	pop    %ebx
  800f03:	5e                   	pop    %esi
  800f04:	5f                   	pop    %edi
  800f05:	5d                   	pop    %ebp
  800f06:	c3                   	ret    

00800f07 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	56                   	push   %esi
  800f0b:	53                   	push   %ebx
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800f0f:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800f11:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800f15:	0f 84 84 00 00 00    	je     800f9f <pgfault+0x98>
  800f1b:	89 d8                	mov    %ebx,%eax
  800f1d:	c1 e8 16             	shr    $0x16,%eax
  800f20:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f27:	a8 01                	test   $0x1,%al
  800f29:	74 74                	je     800f9f <pgfault+0x98>
  800f2b:	89 d8                	mov    %ebx,%eax
  800f2d:	c1 e8 0c             	shr    $0xc,%eax
  800f30:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800f37:	f6 c4 08             	test   $0x8,%ah
  800f3a:	74 63                	je     800f9f <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800f3c:	e8 f2 fc ff ff       	call   800c33 <sys_getenvid>
  800f41:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800f43:	83 ec 04             	sub    $0x4,%esp
  800f46:	6a 07                	push   $0x7
  800f48:	68 00 f0 7f 00       	push   $0x7ff000
  800f4d:	50                   	push   %eax
  800f4e:	e8 ff fc ff ff       	call   800c52 <sys_page_alloc>
  800f53:	83 c4 10             	add    $0x10,%esp
  800f56:	85 c0                	test   %eax,%eax
  800f58:	78 5b                	js     800fb5 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800f5a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800f60:	83 ec 04             	sub    $0x4,%esp
  800f63:	68 00 10 00 00       	push   $0x1000
  800f68:	53                   	push   %ebx
  800f69:	68 00 f0 7f 00       	push   $0x7ff000
  800f6e:	e8 03 fb ff ff       	call   800a76 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800f73:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800f7a:	53                   	push   %ebx
  800f7b:	56                   	push   %esi
  800f7c:	68 00 f0 7f 00       	push   $0x7ff000
  800f81:	56                   	push   %esi
  800f82:	e8 0e fd ff ff       	call   800c95 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800f87:	83 c4 18             	add    $0x18,%esp
  800f8a:	68 00 f0 7f 00       	push   $0x7ff000
  800f8f:	56                   	push   %esi
  800f90:	e8 42 fd ff ff       	call   800cd7 <sys_page_unmap>

}
  800f95:	83 c4 10             	add    $0x10,%esp
  800f98:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5d                   	pop    %ebp
  800f9e:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800f9f:	68 0c 27 80 00       	push   $0x80270c
  800fa4:	68 96 27 80 00       	push   $0x802796
  800fa9:	6a 1c                	push   $0x1c
  800fab:	68 ab 27 80 00       	push   $0x8027ab
  800fb0:	e8 09 10 00 00       	call   801fbe <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800fb5:	68 5c 27 80 00       	push   $0x80275c
  800fba:	68 96 27 80 00       	push   $0x802796
  800fbf:	6a 26                	push   $0x26
  800fc1:	68 ab 27 80 00       	push   $0x8027ab
  800fc6:	e8 f3 0f 00 00       	call   801fbe <_panic>

00800fcb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	57                   	push   %edi
  800fcf:	56                   	push   %esi
  800fd0:	53                   	push   %ebx
  800fd1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800fd4:	68 07 0f 80 00       	push   $0x800f07
  800fd9:	e8 5f 10 00 00       	call   80203d <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800fde:	b8 07 00 00 00       	mov    $0x7,%eax
  800fe3:	cd 30                	int    $0x30
  800fe5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fe8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800feb:	83 c4 10             	add    $0x10,%esp
  800fee:	85 c0                	test   %eax,%eax
  800ff0:	0f 88 58 01 00 00    	js     80114e <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	74 07                	je     801001 <fork+0x36>
  800ffa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fff:	eb 72                	jmp    801073 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  801001:	e8 2d fc ff ff       	call   800c33 <sys_getenvid>
  801006:	25 ff 03 00 00       	and    $0x3ff,%eax
  80100b:	89 c2                	mov    %eax,%edx
  80100d:	c1 e2 05             	shl    $0x5,%edx
  801010:	29 c2                	sub    %eax,%edx
  801012:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801019:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  80101e:	e9 20 01 00 00       	jmp    801143 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  801023:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  80102a:	e8 04 fc ff ff       	call   800c33 <sys_getenvid>
  80102f:	83 ec 0c             	sub    $0xc,%esp
  801032:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801038:	57                   	push   %edi
  801039:	56                   	push   %esi
  80103a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80103d:	56                   	push   %esi
  80103e:	50                   	push   %eax
  80103f:	e8 51 fc ff ff       	call   800c95 <sys_page_map>
  801044:	83 c4 20             	add    $0x20,%esp
  801047:	eb 18                	jmp    801061 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801049:	e8 e5 fb ff ff       	call   800c33 <sys_getenvid>
  80104e:	83 ec 0c             	sub    $0xc,%esp
  801051:	6a 05                	push   $0x5
  801053:	56                   	push   %esi
  801054:	ff 75 e4             	pushl  -0x1c(%ebp)
  801057:	56                   	push   %esi
  801058:	50                   	push   %eax
  801059:	e8 37 fc ff ff       	call   800c95 <sys_page_map>
  80105e:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801061:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801067:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80106d:	0f 84 8f 00 00 00    	je     801102 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  801073:	89 d8                	mov    %ebx,%eax
  801075:	c1 e8 16             	shr    $0x16,%eax
  801078:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80107f:	a8 01                	test   $0x1,%al
  801081:	74 de                	je     801061 <fork+0x96>
  801083:	89 d8                	mov    %ebx,%eax
  801085:	c1 e8 0c             	shr    $0xc,%eax
  801088:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80108f:	a8 04                	test   $0x4,%al
  801091:	74 ce                	je     801061 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801093:	89 de                	mov    %ebx,%esi
  801095:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80109b:	89 f0                	mov    %esi,%eax
  80109d:	c1 e8 0c             	shr    $0xc,%eax
  8010a0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010a7:	f6 c6 04             	test   $0x4,%dh
  8010aa:	0f 85 73 ff ff ff    	jne    801023 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  8010b0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010b7:	a9 02 08 00 00       	test   $0x802,%eax
  8010bc:	74 8b                	je     801049 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8010be:	e8 70 fb ff ff       	call   800c33 <sys_getenvid>
  8010c3:	83 ec 0c             	sub    $0xc,%esp
  8010c6:	68 05 08 00 00       	push   $0x805
  8010cb:	56                   	push   %esi
  8010cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010cf:	56                   	push   %esi
  8010d0:	50                   	push   %eax
  8010d1:	e8 bf fb ff ff       	call   800c95 <sys_page_map>
  8010d6:	83 c4 20             	add    $0x20,%esp
  8010d9:	85 c0                	test   %eax,%eax
  8010db:	78 84                	js     801061 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8010dd:	e8 51 fb ff ff       	call   800c33 <sys_getenvid>
  8010e2:	89 c7                	mov    %eax,%edi
  8010e4:	e8 4a fb ff ff       	call   800c33 <sys_getenvid>
  8010e9:	83 ec 0c             	sub    $0xc,%esp
  8010ec:	68 05 08 00 00       	push   $0x805
  8010f1:	56                   	push   %esi
  8010f2:	57                   	push   %edi
  8010f3:	56                   	push   %esi
  8010f4:	50                   	push   %eax
  8010f5:	e8 9b fb ff ff       	call   800c95 <sys_page_map>
  8010fa:	83 c4 20             	add    $0x20,%esp
  8010fd:	e9 5f ff ff ff       	jmp    801061 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801102:	83 ec 04             	sub    $0x4,%esp
  801105:	6a 07                	push   $0x7
  801107:	68 00 f0 bf ee       	push   $0xeebff000
  80110c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80110f:	57                   	push   %edi
  801110:	e8 3d fb ff ff       	call   800c52 <sys_page_alloc>
  801115:	83 c4 10             	add    $0x10,%esp
  801118:	85 c0                	test   %eax,%eax
  80111a:	78 3b                	js     801157 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  80111c:	83 ec 08             	sub    $0x8,%esp
  80111f:	68 83 20 80 00       	push   $0x802083
  801124:	57                   	push   %edi
  801125:	e8 d3 fc ff ff       	call   800dfd <sys_env_set_pgfault_upcall>
  80112a:	83 c4 10             	add    $0x10,%esp
  80112d:	85 c0                	test   %eax,%eax
  80112f:	78 2f                	js     801160 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801131:	83 ec 08             	sub    $0x8,%esp
  801134:	6a 02                	push   $0x2
  801136:	57                   	push   %edi
  801137:	e8 fc fb ff ff       	call   800d38 <sys_env_set_status>
	if (temp < 0) {
  80113c:	83 c4 10             	add    $0x10,%esp
  80113f:	85 c0                	test   %eax,%eax
  801141:	78 26                	js     801169 <fork+0x19e>
		return -1;
	}

	return childid;
}
  801143:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801146:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801149:	5b                   	pop    %ebx
  80114a:	5e                   	pop    %esi
  80114b:	5f                   	pop    %edi
  80114c:	5d                   	pop    %ebp
  80114d:	c3                   	ret    
		return -1;
  80114e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801155:	eb ec                	jmp    801143 <fork+0x178>
		return -1;
  801157:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80115e:	eb e3                	jmp    801143 <fork+0x178>
		return -1;
  801160:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801167:	eb da                	jmp    801143 <fork+0x178>
		return -1;
  801169:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801170:	eb d1                	jmp    801143 <fork+0x178>

00801172 <sfork>:

// Challenge!
int
sfork(void)
{
  801172:	55                   	push   %ebp
  801173:	89 e5                	mov    %esp,%ebp
  801175:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801178:	68 b6 27 80 00       	push   $0x8027b6
  80117d:	68 85 00 00 00       	push   $0x85
  801182:	68 ab 27 80 00       	push   $0x8027ab
  801187:	e8 32 0e 00 00       	call   801fbe <_panic>

0080118c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	57                   	push   %edi
  801190:	56                   	push   %esi
  801191:	53                   	push   %ebx
  801192:	83 ec 0c             	sub    $0xc,%esp
  801195:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801198:	8b 7d 0c             	mov    0xc(%ebp),%edi
  80119b:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80119e:	85 ff                	test   %edi,%edi
  8011a0:	74 53                	je     8011f5 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  8011a2:	83 ec 0c             	sub    $0xc,%esp
  8011a5:	57                   	push   %edi
  8011a6:	e8 b7 fc ff ff       	call   800e62 <sys_ipc_recv>
  8011ab:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  8011ae:	85 db                	test   %ebx,%ebx
  8011b0:	74 0b                	je     8011bd <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8011b2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011b8:	8b 52 74             	mov    0x74(%edx),%edx
  8011bb:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  8011bd:	85 f6                	test   %esi,%esi
  8011bf:	74 0f                	je     8011d0 <ipc_recv+0x44>
  8011c1:	85 ff                	test   %edi,%edi
  8011c3:	74 0b                	je     8011d0 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8011c5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8011cb:	8b 52 78             	mov    0x78(%edx),%edx
  8011ce:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  8011d0:	85 c0                	test   %eax,%eax
  8011d2:	74 30                	je     801204 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8011d4:	85 db                	test   %ebx,%ebx
  8011d6:	74 06                	je     8011de <ipc_recv+0x52>
      		*from_env_store = 0;
  8011d8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8011de:	85 f6                	test   %esi,%esi
  8011e0:	74 2c                	je     80120e <ipc_recv+0x82>
      		*perm_store = 0;
  8011e2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8011e8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8011ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f0:	5b                   	pop    %ebx
  8011f1:	5e                   	pop    %esi
  8011f2:	5f                   	pop    %edi
  8011f3:	5d                   	pop    %ebp
  8011f4:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8011f5:	83 ec 0c             	sub    $0xc,%esp
  8011f8:	6a ff                	push   $0xffffffff
  8011fa:	e8 63 fc ff ff       	call   800e62 <sys_ipc_recv>
  8011ff:	83 c4 10             	add    $0x10,%esp
  801202:	eb aa                	jmp    8011ae <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801204:	a1 04 40 80 00       	mov    0x804004,%eax
  801209:	8b 40 70             	mov    0x70(%eax),%eax
  80120c:	eb df                	jmp    8011ed <ipc_recv+0x61>
		return -1;
  80120e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801213:	eb d8                	jmp    8011ed <ipc_recv+0x61>

00801215 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	57                   	push   %edi
  801219:	56                   	push   %esi
  80121a:	53                   	push   %ebx
  80121b:	83 ec 0c             	sub    $0xc,%esp
  80121e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801221:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801224:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801227:	85 db                	test   %ebx,%ebx
  801229:	75 22                	jne    80124d <ipc_send+0x38>
		pg = (void *) UTOP+1;
  80122b:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801230:	eb 1b                	jmp    80124d <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801232:	68 cc 27 80 00       	push   $0x8027cc
  801237:	68 96 27 80 00       	push   $0x802796
  80123c:	6a 48                	push   $0x48
  80123e:	68 ef 27 80 00       	push   $0x8027ef
  801243:	e8 76 0d 00 00       	call   801fbe <_panic>
		sys_yield();
  801248:	e8 cc fa ff ff       	call   800d19 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80124d:	57                   	push   %edi
  80124e:	53                   	push   %ebx
  80124f:	56                   	push   %esi
  801250:	ff 75 08             	pushl  0x8(%ebp)
  801253:	e8 e7 fb ff ff       	call   800e3f <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801258:	83 c4 10             	add    $0x10,%esp
  80125b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80125e:	74 e8                	je     801248 <ipc_send+0x33>
  801260:	85 c0                	test   %eax,%eax
  801262:	75 ce                	jne    801232 <ipc_send+0x1d>
		sys_yield();
  801264:	e8 b0 fa ff ff       	call   800d19 <sys_yield>
		
	}
	
}
  801269:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126c:	5b                   	pop    %ebx
  80126d:	5e                   	pop    %esi
  80126e:	5f                   	pop    %edi
  80126f:	5d                   	pop    %ebp
  801270:	c3                   	ret    

00801271 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801277:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80127c:	89 c2                	mov    %eax,%edx
  80127e:	c1 e2 05             	shl    $0x5,%edx
  801281:	29 c2                	sub    %eax,%edx
  801283:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80128a:	8b 52 50             	mov    0x50(%edx),%edx
  80128d:	39 ca                	cmp    %ecx,%edx
  80128f:	74 0f                	je     8012a0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801291:	40                   	inc    %eax
  801292:	3d 00 04 00 00       	cmp    $0x400,%eax
  801297:	75 e3                	jne    80127c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801299:	b8 00 00 00 00       	mov    $0x0,%eax
  80129e:	eb 11                	jmp    8012b1 <ipc_find_env+0x40>
			return envs[i].env_id;
  8012a0:	89 c2                	mov    %eax,%edx
  8012a2:	c1 e2 05             	shl    $0x5,%edx
  8012a5:	29 c2                	sub    %eax,%edx
  8012a7:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8012ae:	8b 40 48             	mov    0x48(%eax),%eax
}
  8012b1:	5d                   	pop    %ebp
  8012b2:	c3                   	ret    

008012b3 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8012b3:	55                   	push   %ebp
  8012b4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	05 00 00 00 30       	add    $0x30000000,%eax
  8012be:	c1 e8 0c             	shr    $0xc,%eax
}
  8012c1:	5d                   	pop    %ebp
  8012c2:	c3                   	ret    

008012c3 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8012c3:	55                   	push   %ebp
  8012c4:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c9:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8012ce:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012d3:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8012d8:	5d                   	pop    %ebp
  8012d9:	c3                   	ret    

008012da <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e0:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8012e5:	89 c2                	mov    %eax,%edx
  8012e7:	c1 ea 16             	shr    $0x16,%edx
  8012ea:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012f1:	f6 c2 01             	test   $0x1,%dl
  8012f4:	74 2a                	je     801320 <fd_alloc+0x46>
  8012f6:	89 c2                	mov    %eax,%edx
  8012f8:	c1 ea 0c             	shr    $0xc,%edx
  8012fb:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801302:	f6 c2 01             	test   $0x1,%dl
  801305:	74 19                	je     801320 <fd_alloc+0x46>
  801307:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80130c:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801311:	75 d2                	jne    8012e5 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801313:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801319:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80131e:	eb 07                	jmp    801327 <fd_alloc+0x4d>
			*fd_store = fd;
  801320:	89 01                	mov    %eax,(%ecx)
			return 0;
  801322:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801327:	5d                   	pop    %ebp
  801328:	c3                   	ret    

00801329 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801329:	55                   	push   %ebp
  80132a:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80132c:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801330:	77 39                	ja     80136b <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801332:	8b 45 08             	mov    0x8(%ebp),%eax
  801335:	c1 e0 0c             	shl    $0xc,%eax
  801338:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80133d:	89 c2                	mov    %eax,%edx
  80133f:	c1 ea 16             	shr    $0x16,%edx
  801342:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801349:	f6 c2 01             	test   $0x1,%dl
  80134c:	74 24                	je     801372 <fd_lookup+0x49>
  80134e:	89 c2                	mov    %eax,%edx
  801350:	c1 ea 0c             	shr    $0xc,%edx
  801353:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80135a:	f6 c2 01             	test   $0x1,%dl
  80135d:	74 1a                	je     801379 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80135f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801362:	89 02                	mov    %eax,(%edx)
	return 0;
  801364:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801369:	5d                   	pop    %ebp
  80136a:	c3                   	ret    
		return -E_INVAL;
  80136b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801370:	eb f7                	jmp    801369 <fd_lookup+0x40>
		return -E_INVAL;
  801372:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801377:	eb f0                	jmp    801369 <fd_lookup+0x40>
  801379:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80137e:	eb e9                	jmp    801369 <fd_lookup+0x40>

00801380 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801380:	55                   	push   %ebp
  801381:	89 e5                	mov    %esp,%ebp
  801383:	83 ec 08             	sub    $0x8,%esp
  801386:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801389:	ba 78 28 80 00       	mov    $0x802878,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80138e:	b8 0c 30 80 00       	mov    $0x80300c,%eax
		if (devtab[i]->dev_id == dev_id) {
  801393:	39 08                	cmp    %ecx,(%eax)
  801395:	74 33                	je     8013ca <dev_lookup+0x4a>
  801397:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80139a:	8b 02                	mov    (%edx),%eax
  80139c:	85 c0                	test   %eax,%eax
  80139e:	75 f3                	jne    801393 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8013a0:	a1 04 40 80 00       	mov    0x804004,%eax
  8013a5:	8b 40 48             	mov    0x48(%eax),%eax
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	51                   	push   %ecx
  8013ac:	50                   	push   %eax
  8013ad:	68 fc 27 80 00       	push   $0x8027fc
  8013b2:	e8 de ee ff ff       	call   800295 <cprintf>
	*dev = 0;
  8013b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8013c0:	83 c4 10             	add    $0x10,%esp
  8013c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8013c8:	c9                   	leave  
  8013c9:	c3                   	ret    
			*dev = devtab[i];
  8013ca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8013cd:	89 01                	mov    %eax,(%ecx)
			return 0;
  8013cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8013d4:	eb f2                	jmp    8013c8 <dev_lookup+0x48>

008013d6 <fd_close>:
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	57                   	push   %edi
  8013da:	56                   	push   %esi
  8013db:	53                   	push   %ebx
  8013dc:	83 ec 1c             	sub    $0x1c,%esp
  8013df:	8b 75 08             	mov    0x8(%ebp),%esi
  8013e2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013e5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8013e8:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013e9:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8013ef:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8013f2:	50                   	push   %eax
  8013f3:	e8 31 ff ff ff       	call   801329 <fd_lookup>
  8013f8:	89 c7                	mov    %eax,%edi
  8013fa:	83 c4 08             	add    $0x8,%esp
  8013fd:	85 c0                	test   %eax,%eax
  8013ff:	78 05                	js     801406 <fd_close+0x30>
	    || fd != fd2)
  801401:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801404:	74 13                	je     801419 <fd_close+0x43>
		return (must_exist ? r : 0);
  801406:	84 db                	test   %bl,%bl
  801408:	75 05                	jne    80140f <fd_close+0x39>
  80140a:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80140f:	89 f8                	mov    %edi,%eax
  801411:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801414:	5b                   	pop    %ebx
  801415:	5e                   	pop    %esi
  801416:	5f                   	pop    %edi
  801417:	5d                   	pop    %ebp
  801418:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80141f:	50                   	push   %eax
  801420:	ff 36                	pushl  (%esi)
  801422:	e8 59 ff ff ff       	call   801380 <dev_lookup>
  801427:	89 c7                	mov    %eax,%edi
  801429:	83 c4 10             	add    $0x10,%esp
  80142c:	85 c0                	test   %eax,%eax
  80142e:	78 15                	js     801445 <fd_close+0x6f>
		if (dev->dev_close)
  801430:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801433:	8b 40 10             	mov    0x10(%eax),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 1b                	je     801455 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80143a:	83 ec 0c             	sub    $0xc,%esp
  80143d:	56                   	push   %esi
  80143e:	ff d0                	call   *%eax
  801440:	89 c7                	mov    %eax,%edi
  801442:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801445:	83 ec 08             	sub    $0x8,%esp
  801448:	56                   	push   %esi
  801449:	6a 00                	push   $0x0
  80144b:	e8 87 f8 ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  801450:	83 c4 10             	add    $0x10,%esp
  801453:	eb ba                	jmp    80140f <fd_close+0x39>
			r = 0;
  801455:	bf 00 00 00 00       	mov    $0x0,%edi
  80145a:	eb e9                	jmp    801445 <fd_close+0x6f>

0080145c <close>:

int
close(int fdnum)
{
  80145c:	55                   	push   %ebp
  80145d:	89 e5                	mov    %esp,%ebp
  80145f:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801462:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801465:	50                   	push   %eax
  801466:	ff 75 08             	pushl  0x8(%ebp)
  801469:	e8 bb fe ff ff       	call   801329 <fd_lookup>
  80146e:	83 c4 08             	add    $0x8,%esp
  801471:	85 c0                	test   %eax,%eax
  801473:	78 10                	js     801485 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801475:	83 ec 08             	sub    $0x8,%esp
  801478:	6a 01                	push   $0x1
  80147a:	ff 75 f4             	pushl  -0xc(%ebp)
  80147d:	e8 54 ff ff ff       	call   8013d6 <fd_close>
  801482:	83 c4 10             	add    $0x10,%esp
}
  801485:	c9                   	leave  
  801486:	c3                   	ret    

00801487 <close_all>:

void
close_all(void)
{
  801487:	55                   	push   %ebp
  801488:	89 e5                	mov    %esp,%ebp
  80148a:	53                   	push   %ebx
  80148b:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80148e:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801493:	83 ec 0c             	sub    $0xc,%esp
  801496:	53                   	push   %ebx
  801497:	e8 c0 ff ff ff       	call   80145c <close>
	for (i = 0; i < MAXFD; i++)
  80149c:	43                   	inc    %ebx
  80149d:	83 c4 10             	add    $0x10,%esp
  8014a0:	83 fb 20             	cmp    $0x20,%ebx
  8014a3:	75 ee                	jne    801493 <close_all+0xc>
}
  8014a5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a8:	c9                   	leave  
  8014a9:	c3                   	ret    

008014aa <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8014aa:	55                   	push   %ebp
  8014ab:	89 e5                	mov    %esp,%ebp
  8014ad:	57                   	push   %edi
  8014ae:	56                   	push   %esi
  8014af:	53                   	push   %ebx
  8014b0:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8014b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014b6:	50                   	push   %eax
  8014b7:	ff 75 08             	pushl  0x8(%ebp)
  8014ba:	e8 6a fe ff ff       	call   801329 <fd_lookup>
  8014bf:	89 c3                	mov    %eax,%ebx
  8014c1:	83 c4 08             	add    $0x8,%esp
  8014c4:	85 c0                	test   %eax,%eax
  8014c6:	0f 88 81 00 00 00    	js     80154d <dup+0xa3>
		return r;
	close(newfdnum);
  8014cc:	83 ec 0c             	sub    $0xc,%esp
  8014cf:	ff 75 0c             	pushl  0xc(%ebp)
  8014d2:	e8 85 ff ff ff       	call   80145c <close>

	newfd = INDEX2FD(newfdnum);
  8014d7:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014da:	c1 e6 0c             	shl    $0xc,%esi
  8014dd:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8014e3:	83 c4 04             	add    $0x4,%esp
  8014e6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8014e9:	e8 d5 fd ff ff       	call   8012c3 <fd2data>
  8014ee:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8014f0:	89 34 24             	mov    %esi,(%esp)
  8014f3:	e8 cb fd ff ff       	call   8012c3 <fd2data>
  8014f8:	83 c4 10             	add    $0x10,%esp
  8014fb:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8014fd:	89 d8                	mov    %ebx,%eax
  8014ff:	c1 e8 16             	shr    $0x16,%eax
  801502:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801509:	a8 01                	test   $0x1,%al
  80150b:	74 11                	je     80151e <dup+0x74>
  80150d:	89 d8                	mov    %ebx,%eax
  80150f:	c1 e8 0c             	shr    $0xc,%eax
  801512:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801519:	f6 c2 01             	test   $0x1,%dl
  80151c:	75 39                	jne    801557 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80151e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801521:	89 d0                	mov    %edx,%eax
  801523:	c1 e8 0c             	shr    $0xc,%eax
  801526:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80152d:	83 ec 0c             	sub    $0xc,%esp
  801530:	25 07 0e 00 00       	and    $0xe07,%eax
  801535:	50                   	push   %eax
  801536:	56                   	push   %esi
  801537:	6a 00                	push   $0x0
  801539:	52                   	push   %edx
  80153a:	6a 00                	push   $0x0
  80153c:	e8 54 f7 ff ff       	call   800c95 <sys_page_map>
  801541:	89 c3                	mov    %eax,%ebx
  801543:	83 c4 20             	add    $0x20,%esp
  801546:	85 c0                	test   %eax,%eax
  801548:	78 31                	js     80157b <dup+0xd1>
		goto err;

	return newfdnum;
  80154a:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80154d:	89 d8                	mov    %ebx,%eax
  80154f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801552:	5b                   	pop    %ebx
  801553:	5e                   	pop    %esi
  801554:	5f                   	pop    %edi
  801555:	5d                   	pop    %ebp
  801556:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801557:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80155e:	83 ec 0c             	sub    $0xc,%esp
  801561:	25 07 0e 00 00       	and    $0xe07,%eax
  801566:	50                   	push   %eax
  801567:	57                   	push   %edi
  801568:	6a 00                	push   $0x0
  80156a:	53                   	push   %ebx
  80156b:	6a 00                	push   $0x0
  80156d:	e8 23 f7 ff ff       	call   800c95 <sys_page_map>
  801572:	89 c3                	mov    %eax,%ebx
  801574:	83 c4 20             	add    $0x20,%esp
  801577:	85 c0                	test   %eax,%eax
  801579:	79 a3                	jns    80151e <dup+0x74>
	sys_page_unmap(0, newfd);
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	56                   	push   %esi
  80157f:	6a 00                	push   $0x0
  801581:	e8 51 f7 ff ff       	call   800cd7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801586:	83 c4 08             	add    $0x8,%esp
  801589:	57                   	push   %edi
  80158a:	6a 00                	push   $0x0
  80158c:	e8 46 f7 ff ff       	call   800cd7 <sys_page_unmap>
	return r;
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	eb b7                	jmp    80154d <dup+0xa3>

00801596 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
  801599:	53                   	push   %ebx
  80159a:	83 ec 14             	sub    $0x14,%esp
  80159d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015a3:	50                   	push   %eax
  8015a4:	53                   	push   %ebx
  8015a5:	e8 7f fd ff ff       	call   801329 <fd_lookup>
  8015aa:	83 c4 08             	add    $0x8,%esp
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 3f                	js     8015f0 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015b1:	83 ec 08             	sub    $0x8,%esp
  8015b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015b7:	50                   	push   %eax
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	ff 30                	pushl  (%eax)
  8015bd:	e8 be fd ff ff       	call   801380 <dev_lookup>
  8015c2:	83 c4 10             	add    $0x10,%esp
  8015c5:	85 c0                	test   %eax,%eax
  8015c7:	78 27                	js     8015f0 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 42 08             	mov    0x8(%edx),%eax
  8015cf:	83 e0 03             	and    $0x3,%eax
  8015d2:	83 f8 01             	cmp    $0x1,%eax
  8015d5:	74 1e                	je     8015f5 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8015d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015da:	8b 40 08             	mov    0x8(%eax),%eax
  8015dd:	85 c0                	test   %eax,%eax
  8015df:	74 35                	je     801616 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8015e1:	83 ec 04             	sub    $0x4,%esp
  8015e4:	ff 75 10             	pushl  0x10(%ebp)
  8015e7:	ff 75 0c             	pushl  0xc(%ebp)
  8015ea:	52                   	push   %edx
  8015eb:	ff d0                	call   *%eax
  8015ed:	83 c4 10             	add    $0x10,%esp
}
  8015f0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015f3:	c9                   	leave  
  8015f4:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8015f5:	a1 04 40 80 00       	mov    0x804004,%eax
  8015fa:	8b 40 48             	mov    0x48(%eax),%eax
  8015fd:	83 ec 04             	sub    $0x4,%esp
  801600:	53                   	push   %ebx
  801601:	50                   	push   %eax
  801602:	68 3d 28 80 00       	push   $0x80283d
  801607:	e8 89 ec ff ff       	call   800295 <cprintf>
		return -E_INVAL;
  80160c:	83 c4 10             	add    $0x10,%esp
  80160f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801614:	eb da                	jmp    8015f0 <read+0x5a>
		return -E_NOT_SUPP;
  801616:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80161b:	eb d3                	jmp    8015f0 <read+0x5a>

0080161d <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	57                   	push   %edi
  801621:	56                   	push   %esi
  801622:	53                   	push   %ebx
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	8b 7d 08             	mov    0x8(%ebp),%edi
  801629:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80162c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801631:	39 f3                	cmp    %esi,%ebx
  801633:	73 25                	jae    80165a <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801635:	83 ec 04             	sub    $0x4,%esp
  801638:	89 f0                	mov    %esi,%eax
  80163a:	29 d8                	sub    %ebx,%eax
  80163c:	50                   	push   %eax
  80163d:	89 d8                	mov    %ebx,%eax
  80163f:	03 45 0c             	add    0xc(%ebp),%eax
  801642:	50                   	push   %eax
  801643:	57                   	push   %edi
  801644:	e8 4d ff ff ff       	call   801596 <read>
		if (m < 0)
  801649:	83 c4 10             	add    $0x10,%esp
  80164c:	85 c0                	test   %eax,%eax
  80164e:	78 08                	js     801658 <readn+0x3b>
			return m;
		if (m == 0)
  801650:	85 c0                	test   %eax,%eax
  801652:	74 06                	je     80165a <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801654:	01 c3                	add    %eax,%ebx
  801656:	eb d9                	jmp    801631 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801658:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80165a:	89 d8                	mov    %ebx,%eax
  80165c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80165f:	5b                   	pop    %ebx
  801660:	5e                   	pop    %esi
  801661:	5f                   	pop    %edi
  801662:	5d                   	pop    %ebp
  801663:	c3                   	ret    

00801664 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801664:	55                   	push   %ebp
  801665:	89 e5                	mov    %esp,%ebp
  801667:	53                   	push   %ebx
  801668:	83 ec 14             	sub    $0x14,%esp
  80166b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80166e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801671:	50                   	push   %eax
  801672:	53                   	push   %ebx
  801673:	e8 b1 fc ff ff       	call   801329 <fd_lookup>
  801678:	83 c4 08             	add    $0x8,%esp
  80167b:	85 c0                	test   %eax,%eax
  80167d:	78 3a                	js     8016b9 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80167f:	83 ec 08             	sub    $0x8,%esp
  801682:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801685:	50                   	push   %eax
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	ff 30                	pushl  (%eax)
  80168b:	e8 f0 fc ff ff       	call   801380 <dev_lookup>
  801690:	83 c4 10             	add    $0x10,%esp
  801693:	85 c0                	test   %eax,%eax
  801695:	78 22                	js     8016b9 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169a:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80169e:	74 1e                	je     8016be <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8016a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016a3:	8b 52 0c             	mov    0xc(%edx),%edx
  8016a6:	85 d2                	test   %edx,%edx
  8016a8:	74 35                	je     8016df <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8016aa:	83 ec 04             	sub    $0x4,%esp
  8016ad:	ff 75 10             	pushl  0x10(%ebp)
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	50                   	push   %eax
  8016b4:	ff d2                	call   *%edx
  8016b6:	83 c4 10             	add    $0x10,%esp
}
  8016b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016bc:	c9                   	leave  
  8016bd:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8016be:	a1 04 40 80 00       	mov    0x804004,%eax
  8016c3:	8b 40 48             	mov    0x48(%eax),%eax
  8016c6:	83 ec 04             	sub    $0x4,%esp
  8016c9:	53                   	push   %ebx
  8016ca:	50                   	push   %eax
  8016cb:	68 59 28 80 00       	push   $0x802859
  8016d0:	e8 c0 eb ff ff       	call   800295 <cprintf>
		return -E_INVAL;
  8016d5:	83 c4 10             	add    $0x10,%esp
  8016d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8016dd:	eb da                	jmp    8016b9 <write+0x55>
		return -E_NOT_SUPP;
  8016df:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016e4:	eb d3                	jmp    8016b9 <write+0x55>

008016e6 <seek>:

int
seek(int fdnum, off_t offset)
{
  8016e6:	55                   	push   %ebp
  8016e7:	89 e5                	mov    %esp,%ebp
  8016e9:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016ec:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8016ef:	50                   	push   %eax
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	e8 31 fc ff ff       	call   801329 <fd_lookup>
  8016f8:	83 c4 08             	add    $0x8,%esp
  8016fb:	85 c0                	test   %eax,%eax
  8016fd:	78 0e                	js     80170d <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8016ff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801702:	8b 55 0c             	mov    0xc(%ebp),%edx
  801705:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801708:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80170d:	c9                   	leave  
  80170e:	c3                   	ret    

0080170f <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80170f:	55                   	push   %ebp
  801710:	89 e5                	mov    %esp,%ebp
  801712:	53                   	push   %ebx
  801713:	83 ec 14             	sub    $0x14,%esp
  801716:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801719:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171c:	50                   	push   %eax
  80171d:	53                   	push   %ebx
  80171e:	e8 06 fc ff ff       	call   801329 <fd_lookup>
  801723:	83 c4 08             	add    $0x8,%esp
  801726:	85 c0                	test   %eax,%eax
  801728:	78 37                	js     801761 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172a:	83 ec 08             	sub    $0x8,%esp
  80172d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801730:	50                   	push   %eax
  801731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801734:	ff 30                	pushl  (%eax)
  801736:	e8 45 fc ff ff       	call   801380 <dev_lookup>
  80173b:	83 c4 10             	add    $0x10,%esp
  80173e:	85 c0                	test   %eax,%eax
  801740:	78 1f                	js     801761 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801742:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801745:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801749:	74 1b                	je     801766 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80174b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174e:	8b 52 18             	mov    0x18(%edx),%edx
  801751:	85 d2                	test   %edx,%edx
  801753:	74 32                	je     801787 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801755:	83 ec 08             	sub    $0x8,%esp
  801758:	ff 75 0c             	pushl  0xc(%ebp)
  80175b:	50                   	push   %eax
  80175c:	ff d2                	call   *%edx
  80175e:	83 c4 10             	add    $0x10,%esp
}
  801761:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801764:	c9                   	leave  
  801765:	c3                   	ret    
			thisenv->env_id, fdnum);
  801766:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80176b:	8b 40 48             	mov    0x48(%eax),%eax
  80176e:	83 ec 04             	sub    $0x4,%esp
  801771:	53                   	push   %ebx
  801772:	50                   	push   %eax
  801773:	68 1c 28 80 00       	push   $0x80281c
  801778:	e8 18 eb ff ff       	call   800295 <cprintf>
		return -E_INVAL;
  80177d:	83 c4 10             	add    $0x10,%esp
  801780:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801785:	eb da                	jmp    801761 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801787:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80178c:	eb d3                	jmp    801761 <ftruncate+0x52>

0080178e <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	53                   	push   %ebx
  801792:	83 ec 14             	sub    $0x14,%esp
  801795:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801798:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80179b:	50                   	push   %eax
  80179c:	ff 75 08             	pushl  0x8(%ebp)
  80179f:	e8 85 fb ff ff       	call   801329 <fd_lookup>
  8017a4:	83 c4 08             	add    $0x8,%esp
  8017a7:	85 c0                	test   %eax,%eax
  8017a9:	78 4b                	js     8017f6 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8017ab:	83 ec 08             	sub    $0x8,%esp
  8017ae:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017b1:	50                   	push   %eax
  8017b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b5:	ff 30                	pushl  (%eax)
  8017b7:	e8 c4 fb ff ff       	call   801380 <dev_lookup>
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	85 c0                	test   %eax,%eax
  8017c1:	78 33                	js     8017f6 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8017c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c6:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8017ca:	74 2f                	je     8017fb <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8017cc:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8017cf:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8017d6:	00 00 00 
	stat->st_type = 0;
  8017d9:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8017e0:	00 00 00 
	stat->st_dev = dev;
  8017e3:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8017e9:	83 ec 08             	sub    $0x8,%esp
  8017ec:	53                   	push   %ebx
  8017ed:	ff 75 f0             	pushl  -0x10(%ebp)
  8017f0:	ff 50 14             	call   *0x14(%eax)
  8017f3:	83 c4 10             	add    $0x10,%esp
}
  8017f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017f9:	c9                   	leave  
  8017fa:	c3                   	ret    
		return -E_NOT_SUPP;
  8017fb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801800:	eb f4                	jmp    8017f6 <fstat+0x68>

00801802 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	56                   	push   %esi
  801806:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801807:	83 ec 08             	sub    $0x8,%esp
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 08             	pushl  0x8(%ebp)
  80180f:	e8 34 02 00 00       	call   801a48 <open>
  801814:	89 c3                	mov    %eax,%ebx
  801816:	83 c4 10             	add    $0x10,%esp
  801819:	85 c0                	test   %eax,%eax
  80181b:	78 1b                	js     801838 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80181d:	83 ec 08             	sub    $0x8,%esp
  801820:	ff 75 0c             	pushl  0xc(%ebp)
  801823:	50                   	push   %eax
  801824:	e8 65 ff ff ff       	call   80178e <fstat>
  801829:	89 c6                	mov    %eax,%esi
	close(fd);
  80182b:	89 1c 24             	mov    %ebx,(%esp)
  80182e:	e8 29 fc ff ff       	call   80145c <close>
	return r;
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	89 f3                	mov    %esi,%ebx
}
  801838:	89 d8                	mov    %ebx,%eax
  80183a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80183d:	5b                   	pop    %ebx
  80183e:	5e                   	pop    %esi
  80183f:	5d                   	pop    %ebp
  801840:	c3                   	ret    

00801841 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	56                   	push   %esi
  801845:	53                   	push   %ebx
  801846:	89 c6                	mov    %eax,%esi
  801848:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80184a:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801851:	74 27                	je     80187a <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801853:	6a 07                	push   $0x7
  801855:	68 00 50 80 00       	push   $0x805000
  80185a:	56                   	push   %esi
  80185b:	ff 35 00 40 80 00    	pushl  0x804000
  801861:	e8 af f9 ff ff       	call   801215 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801866:	83 c4 0c             	add    $0xc,%esp
  801869:	6a 00                	push   $0x0
  80186b:	53                   	push   %ebx
  80186c:	6a 00                	push   $0x0
  80186e:	e8 19 f9 ff ff       	call   80118c <ipc_recv>
}
  801873:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801876:	5b                   	pop    %ebx
  801877:	5e                   	pop    %esi
  801878:	5d                   	pop    %ebp
  801879:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80187a:	83 ec 0c             	sub    $0xc,%esp
  80187d:	6a 01                	push   $0x1
  80187f:	e8 ed f9 ff ff       	call   801271 <ipc_find_env>
  801884:	a3 00 40 80 00       	mov    %eax,0x804000
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	eb c5                	jmp    801853 <fsipc+0x12>

0080188e <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80188e:	55                   	push   %ebp
  80188f:	89 e5                	mov    %esp,%ebp
  801891:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801894:	8b 45 08             	mov    0x8(%ebp),%eax
  801897:	8b 40 0c             	mov    0xc(%eax),%eax
  80189a:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80189f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a2:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8018a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ac:	b8 02 00 00 00       	mov    $0x2,%eax
  8018b1:	e8 8b ff ff ff       	call   801841 <fsipc>
}
  8018b6:	c9                   	leave  
  8018b7:	c3                   	ret    

008018b8 <devfile_flush>:
{
  8018b8:	55                   	push   %ebp
  8018b9:	89 e5                	mov    %esp,%ebp
  8018bb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8018be:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c1:	8b 40 0c             	mov    0xc(%eax),%eax
  8018c4:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8018c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8018ce:	b8 06 00 00 00       	mov    $0x6,%eax
  8018d3:	e8 69 ff ff ff       	call   801841 <fsipc>
}
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <devfile_stat>:
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	53                   	push   %ebx
  8018de:	83 ec 04             	sub    $0x4,%esp
  8018e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8018e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ea:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8018ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f4:	b8 05 00 00 00       	mov    $0x5,%eax
  8018f9:	e8 43 ff ff ff       	call   801841 <fsipc>
  8018fe:	85 c0                	test   %eax,%eax
  801900:	78 2c                	js     80192e <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801902:	83 ec 08             	sub    $0x8,%esp
  801905:	68 00 50 80 00       	push   $0x805000
  80190a:	53                   	push   %ebx
  80190b:	e8 8d ef ff ff       	call   80089d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801910:	a1 80 50 80 00       	mov    0x805080,%eax
  801915:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80191b:	a1 84 50 80 00       	mov    0x805084,%eax
  801920:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801926:	83 c4 10             	add    $0x10,%esp
  801929:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801931:	c9                   	leave  
  801932:	c3                   	ret    

00801933 <devfile_write>:
{
  801933:	55                   	push   %ebp
  801934:	89 e5                	mov    %esp,%ebp
  801936:	53                   	push   %ebx
  801937:	83 ec 04             	sub    $0x4,%esp
  80193a:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80193d:	89 d8                	mov    %ebx,%eax
  80193f:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801945:	76 05                	jbe    80194c <devfile_write+0x19>
  801947:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80194c:	8b 55 08             	mov    0x8(%ebp),%edx
  80194f:	8b 52 0c             	mov    0xc(%edx),%edx
  801952:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801958:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80195d:	83 ec 04             	sub    $0x4,%esp
  801960:	50                   	push   %eax
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	68 08 50 80 00       	push   $0x805008
  801969:	e8 a2 f0 ff ff       	call   800a10 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80196e:	ba 00 00 00 00       	mov    $0x0,%edx
  801973:	b8 04 00 00 00       	mov    $0x4,%eax
  801978:	e8 c4 fe ff ff       	call   801841 <fsipc>
  80197d:	83 c4 10             	add    $0x10,%esp
  801980:	85 c0                	test   %eax,%eax
  801982:	78 0b                	js     80198f <devfile_write+0x5c>
	assert(r <= n);
  801984:	39 c3                	cmp    %eax,%ebx
  801986:	72 0c                	jb     801994 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801988:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80198d:	7f 1e                	jg     8019ad <devfile_write+0x7a>
}
  80198f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801992:	c9                   	leave  
  801993:	c3                   	ret    
	assert(r <= n);
  801994:	68 88 28 80 00       	push   $0x802888
  801999:	68 96 27 80 00       	push   $0x802796
  80199e:	68 98 00 00 00       	push   $0x98
  8019a3:	68 8f 28 80 00       	push   $0x80288f
  8019a8:	e8 11 06 00 00       	call   801fbe <_panic>
	assert(r <= PGSIZE);
  8019ad:	68 9a 28 80 00       	push   $0x80289a
  8019b2:	68 96 27 80 00       	push   $0x802796
  8019b7:	68 99 00 00 00       	push   $0x99
  8019bc:	68 8f 28 80 00       	push   $0x80288f
  8019c1:	e8 f8 05 00 00       	call   801fbe <_panic>

008019c6 <devfile_read>:
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
  8019cb:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8019ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8019d4:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8019d9:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8019df:	ba 00 00 00 00       	mov    $0x0,%edx
  8019e4:	b8 03 00 00 00       	mov    $0x3,%eax
  8019e9:	e8 53 fe ff ff       	call   801841 <fsipc>
  8019ee:	89 c3                	mov    %eax,%ebx
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	78 1f                	js     801a13 <devfile_read+0x4d>
	assert(r <= n);
  8019f4:	39 c6                	cmp    %eax,%esi
  8019f6:	72 24                	jb     801a1c <devfile_read+0x56>
	assert(r <= PGSIZE);
  8019f8:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8019fd:	7f 33                	jg     801a32 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8019ff:	83 ec 04             	sub    $0x4,%esp
  801a02:	50                   	push   %eax
  801a03:	68 00 50 80 00       	push   $0x805000
  801a08:	ff 75 0c             	pushl  0xc(%ebp)
  801a0b:	e8 00 f0 ff ff       	call   800a10 <memmove>
	return r;
  801a10:	83 c4 10             	add    $0x10,%esp
}
  801a13:	89 d8                	mov    %ebx,%eax
  801a15:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a18:	5b                   	pop    %ebx
  801a19:	5e                   	pop    %esi
  801a1a:	5d                   	pop    %ebp
  801a1b:	c3                   	ret    
	assert(r <= n);
  801a1c:	68 88 28 80 00       	push   $0x802888
  801a21:	68 96 27 80 00       	push   $0x802796
  801a26:	6a 7c                	push   $0x7c
  801a28:	68 8f 28 80 00       	push   $0x80288f
  801a2d:	e8 8c 05 00 00       	call   801fbe <_panic>
	assert(r <= PGSIZE);
  801a32:	68 9a 28 80 00       	push   $0x80289a
  801a37:	68 96 27 80 00       	push   $0x802796
  801a3c:	6a 7d                	push   $0x7d
  801a3e:	68 8f 28 80 00       	push   $0x80288f
  801a43:	e8 76 05 00 00       	call   801fbe <_panic>

00801a48 <open>:
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
  801a4b:	56                   	push   %esi
  801a4c:	53                   	push   %ebx
  801a4d:	83 ec 1c             	sub    $0x1c,%esp
  801a50:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801a53:	56                   	push   %esi
  801a54:	e8 11 ee ff ff       	call   80086a <strlen>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801a61:	7f 6c                	jg     801acf <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a69:	50                   	push   %eax
  801a6a:	e8 6b f8 ff ff       	call   8012da <fd_alloc>
  801a6f:	89 c3                	mov    %eax,%ebx
  801a71:	83 c4 10             	add    $0x10,%esp
  801a74:	85 c0                	test   %eax,%eax
  801a76:	78 3c                	js     801ab4 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a78:	83 ec 08             	sub    $0x8,%esp
  801a7b:	56                   	push   %esi
  801a7c:	68 00 50 80 00       	push   $0x805000
  801a81:	e8 17 ee ff ff       	call   80089d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a86:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a89:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a8e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a91:	b8 01 00 00 00       	mov    $0x1,%eax
  801a96:	e8 a6 fd ff ff       	call   801841 <fsipc>
  801a9b:	89 c3                	mov    %eax,%ebx
  801a9d:	83 c4 10             	add    $0x10,%esp
  801aa0:	85 c0                	test   %eax,%eax
  801aa2:	78 19                	js     801abd <open+0x75>
	return fd2num(fd);
  801aa4:	83 ec 0c             	sub    $0xc,%esp
  801aa7:	ff 75 f4             	pushl  -0xc(%ebp)
  801aaa:	e8 04 f8 ff ff       	call   8012b3 <fd2num>
  801aaf:	89 c3                	mov    %eax,%ebx
  801ab1:	83 c4 10             	add    $0x10,%esp
}
  801ab4:	89 d8                	mov    %ebx,%eax
  801ab6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ab9:	5b                   	pop    %ebx
  801aba:	5e                   	pop    %esi
  801abb:	5d                   	pop    %ebp
  801abc:	c3                   	ret    
		fd_close(fd, 0);
  801abd:	83 ec 08             	sub    $0x8,%esp
  801ac0:	6a 00                	push   $0x0
  801ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  801ac5:	e8 0c f9 ff ff       	call   8013d6 <fd_close>
		return r;
  801aca:	83 c4 10             	add    $0x10,%esp
  801acd:	eb e5                	jmp    801ab4 <open+0x6c>
		return -E_BAD_PATH;
  801acf:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801ad4:	eb de                	jmp    801ab4 <open+0x6c>

00801ad6 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801adc:	ba 00 00 00 00       	mov    $0x0,%edx
  801ae1:	b8 08 00 00 00       	mov    $0x8,%eax
  801ae6:	e8 56 fd ff ff       	call   801841 <fsipc>
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
  801af0:	56                   	push   %esi
  801af1:	53                   	push   %ebx
  801af2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	ff 75 08             	pushl  0x8(%ebp)
  801afb:	e8 c3 f7 ff ff       	call   8012c3 <fd2data>
  801b00:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801b02:	83 c4 08             	add    $0x8,%esp
  801b05:	68 a6 28 80 00       	push   $0x8028a6
  801b0a:	53                   	push   %ebx
  801b0b:	e8 8d ed ff ff       	call   80089d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801b10:	8b 46 04             	mov    0x4(%esi),%eax
  801b13:	2b 06                	sub    (%esi),%eax
  801b15:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801b1b:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801b22:	10 00 00 
	stat->st_dev = &devpipe;
  801b25:	c7 83 88 00 00 00 28 	movl   $0x803028,0x88(%ebx)
  801b2c:	30 80 00 
	return 0;
}
  801b2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801b34:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b37:	5b                   	pop    %ebx
  801b38:	5e                   	pop    %esi
  801b39:	5d                   	pop    %ebp
  801b3a:	c3                   	ret    

00801b3b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
  801b3e:	53                   	push   %ebx
  801b3f:	83 ec 0c             	sub    $0xc,%esp
  801b42:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801b45:	53                   	push   %ebx
  801b46:	6a 00                	push   $0x0
  801b48:	e8 8a f1 ff ff       	call   800cd7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801b4d:	89 1c 24             	mov    %ebx,(%esp)
  801b50:	e8 6e f7 ff ff       	call   8012c3 <fd2data>
  801b55:	83 c4 08             	add    $0x8,%esp
  801b58:	50                   	push   %eax
  801b59:	6a 00                	push   $0x0
  801b5b:	e8 77 f1 ff ff       	call   800cd7 <sys_page_unmap>
}
  801b60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b63:	c9                   	leave  
  801b64:	c3                   	ret    

00801b65 <_pipeisclosed>:
{
  801b65:	55                   	push   %ebp
  801b66:	89 e5                	mov    %esp,%ebp
  801b68:	57                   	push   %edi
  801b69:	56                   	push   %esi
  801b6a:	53                   	push   %ebx
  801b6b:	83 ec 1c             	sub    $0x1c,%esp
  801b6e:	89 c7                	mov    %eax,%edi
  801b70:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801b72:	a1 04 40 80 00       	mov    0x804004,%eax
  801b77:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	57                   	push   %edi
  801b7e:	e8 26 05 00 00       	call   8020a9 <pageref>
  801b83:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b86:	89 34 24             	mov    %esi,(%esp)
  801b89:	e8 1b 05 00 00       	call   8020a9 <pageref>
		nn = thisenv->env_runs;
  801b8e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b94:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b97:	83 c4 10             	add    $0x10,%esp
  801b9a:	39 cb                	cmp    %ecx,%ebx
  801b9c:	74 1b                	je     801bb9 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b9e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801ba1:	75 cf                	jne    801b72 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801ba3:	8b 42 58             	mov    0x58(%edx),%eax
  801ba6:	6a 01                	push   $0x1
  801ba8:	50                   	push   %eax
  801ba9:	53                   	push   %ebx
  801baa:	68 ad 28 80 00       	push   $0x8028ad
  801baf:	e8 e1 e6 ff ff       	call   800295 <cprintf>
  801bb4:	83 c4 10             	add    $0x10,%esp
  801bb7:	eb b9                	jmp    801b72 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801bb9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801bbc:	0f 94 c0             	sete   %al
  801bbf:	0f b6 c0             	movzbl %al,%eax
}
  801bc2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc5:	5b                   	pop    %ebx
  801bc6:	5e                   	pop    %esi
  801bc7:	5f                   	pop    %edi
  801bc8:	5d                   	pop    %ebp
  801bc9:	c3                   	ret    

00801bca <devpipe_write>:
{
  801bca:	55                   	push   %ebp
  801bcb:	89 e5                	mov    %esp,%ebp
  801bcd:	57                   	push   %edi
  801bce:	56                   	push   %esi
  801bcf:	53                   	push   %ebx
  801bd0:	83 ec 18             	sub    $0x18,%esp
  801bd3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801bd6:	56                   	push   %esi
  801bd7:	e8 e7 f6 ff ff       	call   8012c3 <fd2data>
  801bdc:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801bde:	83 c4 10             	add    $0x10,%esp
  801be1:	bf 00 00 00 00       	mov    $0x0,%edi
  801be6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801be9:	74 41                	je     801c2c <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801beb:	8b 53 04             	mov    0x4(%ebx),%edx
  801bee:	8b 03                	mov    (%ebx),%eax
  801bf0:	83 c0 20             	add    $0x20,%eax
  801bf3:	39 c2                	cmp    %eax,%edx
  801bf5:	72 14                	jb     801c0b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801bf7:	89 da                	mov    %ebx,%edx
  801bf9:	89 f0                	mov    %esi,%eax
  801bfb:	e8 65 ff ff ff       	call   801b65 <_pipeisclosed>
  801c00:	85 c0                	test   %eax,%eax
  801c02:	75 2c                	jne    801c30 <devpipe_write+0x66>
			sys_yield();
  801c04:	e8 10 f1 ff ff       	call   800d19 <sys_yield>
  801c09:	eb e0                	jmp    801beb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
  801c0e:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801c11:	89 d0                	mov    %edx,%eax
  801c13:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c18:	78 0b                	js     801c25 <devpipe_write+0x5b>
  801c1a:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801c1e:	42                   	inc    %edx
  801c1f:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801c22:	47                   	inc    %edi
  801c23:	eb c1                	jmp    801be6 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801c25:	48                   	dec    %eax
  801c26:	83 c8 e0             	or     $0xffffffe0,%eax
  801c29:	40                   	inc    %eax
  801c2a:	eb ee                	jmp    801c1a <devpipe_write+0x50>
	return i;
  801c2c:	89 f8                	mov    %edi,%eax
  801c2e:	eb 05                	jmp    801c35 <devpipe_write+0x6b>
				return 0;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c35:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c38:	5b                   	pop    %ebx
  801c39:	5e                   	pop    %esi
  801c3a:	5f                   	pop    %edi
  801c3b:	5d                   	pop    %ebp
  801c3c:	c3                   	ret    

00801c3d <devpipe_read>:
{
  801c3d:	55                   	push   %ebp
  801c3e:	89 e5                	mov    %esp,%ebp
  801c40:	57                   	push   %edi
  801c41:	56                   	push   %esi
  801c42:	53                   	push   %ebx
  801c43:	83 ec 18             	sub    $0x18,%esp
  801c46:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801c49:	57                   	push   %edi
  801c4a:	e8 74 f6 ff ff       	call   8012c3 <fd2data>
  801c4f:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801c51:	83 c4 10             	add    $0x10,%esp
  801c54:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c59:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801c5c:	74 46                	je     801ca4 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801c5e:	8b 06                	mov    (%esi),%eax
  801c60:	3b 46 04             	cmp    0x4(%esi),%eax
  801c63:	75 22                	jne    801c87 <devpipe_read+0x4a>
			if (i > 0)
  801c65:	85 db                	test   %ebx,%ebx
  801c67:	74 0a                	je     801c73 <devpipe_read+0x36>
				return i;
  801c69:	89 d8                	mov    %ebx,%eax
}
  801c6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c6e:	5b                   	pop    %ebx
  801c6f:	5e                   	pop    %esi
  801c70:	5f                   	pop    %edi
  801c71:	5d                   	pop    %ebp
  801c72:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801c73:	89 f2                	mov    %esi,%edx
  801c75:	89 f8                	mov    %edi,%eax
  801c77:	e8 e9 fe ff ff       	call   801b65 <_pipeisclosed>
  801c7c:	85 c0                	test   %eax,%eax
  801c7e:	75 28                	jne    801ca8 <devpipe_read+0x6b>
			sys_yield();
  801c80:	e8 94 f0 ff ff       	call   800d19 <sys_yield>
  801c85:	eb d7                	jmp    801c5e <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c87:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c8c:	78 0f                	js     801c9d <devpipe_read+0x60>
  801c8e:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c95:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c98:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c9a:	43                   	inc    %ebx
  801c9b:	eb bc                	jmp    801c59 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c9d:	48                   	dec    %eax
  801c9e:	83 c8 e0             	or     $0xffffffe0,%eax
  801ca1:	40                   	inc    %eax
  801ca2:	eb ea                	jmp    801c8e <devpipe_read+0x51>
	return i;
  801ca4:	89 d8                	mov    %ebx,%eax
  801ca6:	eb c3                	jmp    801c6b <devpipe_read+0x2e>
				return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
  801cad:	eb bc                	jmp    801c6b <devpipe_read+0x2e>

00801caf <pipe>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801cb7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cba:	50                   	push   %eax
  801cbb:	e8 1a f6 ff ff       	call   8012da <fd_alloc>
  801cc0:	89 c3                	mov    %eax,%ebx
  801cc2:	83 c4 10             	add    $0x10,%esp
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	0f 88 2a 01 00 00    	js     801df7 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ccd:	83 ec 04             	sub    $0x4,%esp
  801cd0:	68 07 04 00 00       	push   $0x407
  801cd5:	ff 75 f4             	pushl  -0xc(%ebp)
  801cd8:	6a 00                	push   $0x0
  801cda:	e8 73 ef ff ff       	call   800c52 <sys_page_alloc>
  801cdf:	89 c3                	mov    %eax,%ebx
  801ce1:	83 c4 10             	add    $0x10,%esp
  801ce4:	85 c0                	test   %eax,%eax
  801ce6:	0f 88 0b 01 00 00    	js     801df7 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801cec:	83 ec 0c             	sub    $0xc,%esp
  801cef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801cf2:	50                   	push   %eax
  801cf3:	e8 e2 f5 ff ff       	call   8012da <fd_alloc>
  801cf8:	89 c3                	mov    %eax,%ebx
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	0f 88 e2 00 00 00    	js     801de7 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d05:	83 ec 04             	sub    $0x4,%esp
  801d08:	68 07 04 00 00       	push   $0x407
  801d0d:	ff 75 f0             	pushl  -0x10(%ebp)
  801d10:	6a 00                	push   $0x0
  801d12:	e8 3b ef ff ff       	call   800c52 <sys_page_alloc>
  801d17:	89 c3                	mov    %eax,%ebx
  801d19:	83 c4 10             	add    $0x10,%esp
  801d1c:	85 c0                	test   %eax,%eax
  801d1e:	0f 88 c3 00 00 00    	js     801de7 <pipe+0x138>
	va = fd2data(fd0);
  801d24:	83 ec 0c             	sub    $0xc,%esp
  801d27:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2a:	e8 94 f5 ff ff       	call   8012c3 <fd2data>
  801d2f:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d31:	83 c4 0c             	add    $0xc,%esp
  801d34:	68 07 04 00 00       	push   $0x407
  801d39:	50                   	push   %eax
  801d3a:	6a 00                	push   $0x0
  801d3c:	e8 11 ef ff ff       	call   800c52 <sys_page_alloc>
  801d41:	89 c3                	mov    %eax,%ebx
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	85 c0                	test   %eax,%eax
  801d48:	0f 88 89 00 00 00    	js     801dd7 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801d4e:	83 ec 0c             	sub    $0xc,%esp
  801d51:	ff 75 f0             	pushl  -0x10(%ebp)
  801d54:	e8 6a f5 ff ff       	call   8012c3 <fd2data>
  801d59:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801d60:	50                   	push   %eax
  801d61:	6a 00                	push   $0x0
  801d63:	56                   	push   %esi
  801d64:	6a 00                	push   $0x0
  801d66:	e8 2a ef ff ff       	call   800c95 <sys_page_map>
  801d6b:	89 c3                	mov    %eax,%ebx
  801d6d:	83 c4 20             	add    $0x20,%esp
  801d70:	85 c0                	test   %eax,%eax
  801d72:	78 55                	js     801dc9 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801d74:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d82:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d89:	8b 15 28 30 80 00    	mov    0x803028,%edx
  801d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d92:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d97:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d9e:	83 ec 0c             	sub    $0xc,%esp
  801da1:	ff 75 f4             	pushl  -0xc(%ebp)
  801da4:	e8 0a f5 ff ff       	call   8012b3 <fd2num>
  801da9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dac:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801dae:	83 c4 04             	add    $0x4,%esp
  801db1:	ff 75 f0             	pushl  -0x10(%ebp)
  801db4:	e8 fa f4 ff ff       	call   8012b3 <fd2num>
  801db9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbc:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801dbf:	83 c4 10             	add    $0x10,%esp
  801dc2:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dc7:	eb 2e                	jmp    801df7 <pipe+0x148>
	sys_page_unmap(0, va);
  801dc9:	83 ec 08             	sub    $0x8,%esp
  801dcc:	56                   	push   %esi
  801dcd:	6a 00                	push   $0x0
  801dcf:	e8 03 ef ff ff       	call   800cd7 <sys_page_unmap>
  801dd4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801dd7:	83 ec 08             	sub    $0x8,%esp
  801dda:	ff 75 f0             	pushl  -0x10(%ebp)
  801ddd:	6a 00                	push   $0x0
  801ddf:	e8 f3 ee ff ff       	call   800cd7 <sys_page_unmap>
  801de4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801de7:	83 ec 08             	sub    $0x8,%esp
  801dea:	ff 75 f4             	pushl  -0xc(%ebp)
  801ded:	6a 00                	push   $0x0
  801def:	e8 e3 ee ff ff       	call   800cd7 <sys_page_unmap>
  801df4:	83 c4 10             	add    $0x10,%esp
}
  801df7:	89 d8                	mov    %ebx,%eax
  801df9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfc:	5b                   	pop    %ebx
  801dfd:	5e                   	pop    %esi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    

00801e00 <pipeisclosed>:
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
  801e03:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e09:	50                   	push   %eax
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	e8 17 f5 ff ff       	call   801329 <fd_lookup>
  801e12:	83 c4 10             	add    $0x10,%esp
  801e15:	85 c0                	test   %eax,%eax
  801e17:	78 18                	js     801e31 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801e19:	83 ec 0c             	sub    $0xc,%esp
  801e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  801e1f:	e8 9f f4 ff ff       	call   8012c3 <fd2data>
	return _pipeisclosed(fd, p);
  801e24:	89 c2                	mov    %eax,%edx
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	e8 37 fd ff ff       	call   801b65 <_pipeisclosed>
  801e2e:	83 c4 10             	add    $0x10,%esp
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e36:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3b:	5d                   	pop    %ebp
  801e3c:	c3                   	ret    

00801e3d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e3d:	55                   	push   %ebp
  801e3e:	89 e5                	mov    %esp,%ebp
  801e40:	53                   	push   %ebx
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801e47:	68 c5 28 80 00       	push   $0x8028c5
  801e4c:	53                   	push   %ebx
  801e4d:	e8 4b ea ff ff       	call   80089d <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801e52:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801e59:	20 00 00 
	return 0;
}
  801e5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <devcons_write>:
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	57                   	push   %edi
  801e6a:	56                   	push   %esi
  801e6b:	53                   	push   %ebx
  801e6c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e72:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e77:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e7d:	eb 1d                	jmp    801e9c <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e7f:	83 ec 04             	sub    $0x4,%esp
  801e82:	53                   	push   %ebx
  801e83:	03 45 0c             	add    0xc(%ebp),%eax
  801e86:	50                   	push   %eax
  801e87:	57                   	push   %edi
  801e88:	e8 83 eb ff ff       	call   800a10 <memmove>
		sys_cputs(buf, m);
  801e8d:	83 c4 08             	add    $0x8,%esp
  801e90:	53                   	push   %ebx
  801e91:	57                   	push   %edi
  801e92:	e8 1e ed ff ff       	call   800bb5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e97:	01 de                	add    %ebx,%esi
  801e99:	83 c4 10             	add    $0x10,%esp
  801e9c:	89 f0                	mov    %esi,%eax
  801e9e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801ea1:	73 11                	jae    801eb4 <devcons_write+0x4e>
		m = n - tot;
  801ea3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ea6:	29 f3                	sub    %esi,%ebx
  801ea8:	83 fb 7f             	cmp    $0x7f,%ebx
  801eab:	76 d2                	jbe    801e7f <devcons_write+0x19>
  801ead:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801eb2:	eb cb                	jmp    801e7f <devcons_write+0x19>
}
  801eb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5f                   	pop    %edi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    

00801ebc <devcons_read>:
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
  801ebf:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801ec2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ec6:	75 0c                	jne    801ed4 <devcons_read+0x18>
		return 0;
  801ec8:	b8 00 00 00 00       	mov    $0x0,%eax
  801ecd:	eb 21                	jmp    801ef0 <devcons_read+0x34>
		sys_yield();
  801ecf:	e8 45 ee ff ff       	call   800d19 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ed4:	e8 fa ec ff ff       	call   800bd3 <sys_cgetc>
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	74 f2                	je     801ecf <devcons_read+0x13>
	if (c < 0)
  801edd:	85 c0                	test   %eax,%eax
  801edf:	78 0f                	js     801ef0 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801ee1:	83 f8 04             	cmp    $0x4,%eax
  801ee4:	74 0c                	je     801ef2 <devcons_read+0x36>
	*(char*)vbuf = c;
  801ee6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee9:	88 02                	mov    %al,(%edx)
	return 1;
  801eeb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    
		return 0;
  801ef2:	b8 00 00 00 00       	mov    $0x0,%eax
  801ef7:	eb f7                	jmp    801ef0 <devcons_read+0x34>

00801ef9 <cputchar>:
{
  801ef9:	55                   	push   %ebp
  801efa:	89 e5                	mov    %esp,%ebp
  801efc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801f05:	6a 01                	push   $0x1
  801f07:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f0a:	50                   	push   %eax
  801f0b:	e8 a5 ec ff ff       	call   800bb5 <sys_cputs>
}
  801f10:	83 c4 10             	add    $0x10,%esp
  801f13:	c9                   	leave  
  801f14:	c3                   	ret    

00801f15 <getchar>:
{
  801f15:	55                   	push   %ebp
  801f16:	89 e5                	mov    %esp,%ebp
  801f18:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801f1b:	6a 01                	push   $0x1
  801f1d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801f20:	50                   	push   %eax
  801f21:	6a 00                	push   $0x0
  801f23:	e8 6e f6 ff ff       	call   801596 <read>
	if (r < 0)
  801f28:	83 c4 10             	add    $0x10,%esp
  801f2b:	85 c0                	test   %eax,%eax
  801f2d:	78 08                	js     801f37 <getchar+0x22>
	if (r < 1)
  801f2f:	85 c0                	test   %eax,%eax
  801f31:	7e 06                	jle    801f39 <getchar+0x24>
	return c;
  801f33:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f37:	c9                   	leave  
  801f38:	c3                   	ret    
		return -E_EOF;
  801f39:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f3e:	eb f7                	jmp    801f37 <getchar+0x22>

00801f40 <iscons>:
{
  801f40:	55                   	push   %ebp
  801f41:	89 e5                	mov    %esp,%ebp
  801f43:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f46:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f49:	50                   	push   %eax
  801f4a:	ff 75 08             	pushl  0x8(%ebp)
  801f4d:	e8 d7 f3 ff ff       	call   801329 <fd_lookup>
  801f52:	83 c4 10             	add    $0x10,%esp
  801f55:	85 c0                	test   %eax,%eax
  801f57:	78 11                	js     801f6a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5c:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801f62:	39 10                	cmp    %edx,(%eax)
  801f64:	0f 94 c0             	sete   %al
  801f67:	0f b6 c0             	movzbl %al,%eax
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <opencons>:
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
  801f6f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f72:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f75:	50                   	push   %eax
  801f76:	e8 5f f3 ff ff       	call   8012da <fd_alloc>
  801f7b:	83 c4 10             	add    $0x10,%esp
  801f7e:	85 c0                	test   %eax,%eax
  801f80:	78 3a                	js     801fbc <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f82:	83 ec 04             	sub    $0x4,%esp
  801f85:	68 07 04 00 00       	push   $0x407
  801f8a:	ff 75 f4             	pushl  -0xc(%ebp)
  801f8d:	6a 00                	push   $0x0
  801f8f:	e8 be ec ff ff       	call   800c52 <sys_page_alloc>
  801f94:	83 c4 10             	add    $0x10,%esp
  801f97:	85 c0                	test   %eax,%eax
  801f99:	78 21                	js     801fbc <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f9b:	8b 15 44 30 80 00    	mov    0x803044,%edx
  801fa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa4:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801fa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa9:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	50                   	push   %eax
  801fb4:	e8 fa f2 ff ff       	call   8012b3 <fd2num>
  801fb9:	83 c4 10             	add    $0x10,%esp
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	57                   	push   %edi
  801fc2:	56                   	push   %esi
  801fc3:	53                   	push   %ebx
  801fc4:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801fca:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801fcd:	8b 1d 08 30 80 00    	mov    0x803008,%ebx
  801fd3:	e8 5b ec ff ff       	call   800c33 <sys_getenvid>
  801fd8:	83 ec 04             	sub    $0x4,%esp
  801fdb:	ff 75 0c             	pushl  0xc(%ebp)
  801fde:	ff 75 08             	pushl  0x8(%ebp)
  801fe1:	53                   	push   %ebx
  801fe2:	50                   	push   %eax
  801fe3:	68 d4 28 80 00       	push   $0x8028d4
  801fe8:	68 00 01 00 00       	push   $0x100
  801fed:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801ff3:	56                   	push   %esi
  801ff4:	e8 57 e8 ff ff       	call   800850 <snprintf>
  801ff9:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801ffb:	83 c4 20             	add    $0x20,%esp
  801ffe:	57                   	push   %edi
  801fff:	ff 75 10             	pushl  0x10(%ebp)
  802002:	bf 00 01 00 00       	mov    $0x100,%edi
  802007:	89 f8                	mov    %edi,%eax
  802009:	29 d8                	sub    %ebx,%eax
  80200b:	50                   	push   %eax
  80200c:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80200f:	50                   	push   %eax
  802010:	e8 e6 e7 ff ff       	call   8007fb <vsnprintf>
  802015:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  802017:	83 c4 0c             	add    $0xc,%esp
  80201a:	68 be 28 80 00       	push   $0x8028be
  80201f:	29 df                	sub    %ebx,%edi
  802021:	57                   	push   %edi
  802022:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  802025:	50                   	push   %eax
  802026:	e8 25 e8 ff ff       	call   800850 <snprintf>
	sys_cputs(buf, r);
  80202b:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80202e:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  802030:	53                   	push   %ebx
  802031:	56                   	push   %esi
  802032:	e8 7e eb ff ff       	call   800bb5 <sys_cputs>
  802037:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80203a:	cc                   	int3   
  80203b:	eb fd                	jmp    80203a <_panic+0x7c>

0080203d <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  80203d:	55                   	push   %ebp
  80203e:	89 e5                	mov    %esp,%ebp
  802040:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802043:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  80204a:	74 0a                	je     802056 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  80204c:	8b 45 08             	mov    0x8(%ebp),%eax
  80204f:	a3 00 60 80 00       	mov    %eax,0x806000
}
  802054:	c9                   	leave  
  802055:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  802056:	e8 d8 eb ff ff       	call   800c33 <sys_getenvid>
  80205b:	83 ec 04             	sub    $0x4,%esp
  80205e:	6a 07                	push   $0x7
  802060:	68 00 f0 bf ee       	push   $0xeebff000
  802065:	50                   	push   %eax
  802066:	e8 e7 eb ff ff       	call   800c52 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  80206b:	e8 c3 eb ff ff       	call   800c33 <sys_getenvid>
  802070:	83 c4 08             	add    $0x8,%esp
  802073:	68 83 20 80 00       	push   $0x802083
  802078:	50                   	push   %eax
  802079:	e8 7f ed ff ff       	call   800dfd <sys_env_set_pgfault_upcall>
  80207e:	83 c4 10             	add    $0x10,%esp
  802081:	eb c9                	jmp    80204c <set_pgfault_handler+0xf>

00802083 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802083:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802084:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802089:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80208b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  80208e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802092:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802096:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802099:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80209b:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  80209f:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  8020a2:	61                   	popa   
	addl $4, %esp
  8020a3:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  8020a6:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  8020a7:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  8020a8:	c3                   	ret    

008020a9 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8020af:	c1 e8 16             	shr    $0x16,%eax
  8020b2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020b9:	a8 01                	test   $0x1,%al
  8020bb:	74 21                	je     8020de <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  8020bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c0:	c1 e8 0c             	shr    $0xc,%eax
  8020c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020ca:	a8 01                	test   $0x1,%al
  8020cc:	74 17                	je     8020e5 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020ce:	c1 e8 0c             	shr    $0xc,%eax
  8020d1:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  8020d8:	ef 
  8020d9:	0f b7 c0             	movzwl %ax,%eax
  8020dc:	eb 05                	jmp    8020e3 <pageref+0x3a>
		return 0;
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020e3:	5d                   	pop    %ebp
  8020e4:	c3                   	ret    
		return 0;
  8020e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8020ea:	eb f7                	jmp    8020e3 <pageref+0x3a>

008020ec <__udivdi3>:
  8020ec:	55                   	push   %ebp
  8020ed:	57                   	push   %edi
  8020ee:	56                   	push   %esi
  8020ef:	53                   	push   %ebx
  8020f0:	83 ec 1c             	sub    $0x1c,%esp
  8020f3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8020f7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8020fb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8020ff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802103:	89 ca                	mov    %ecx,%edx
  802105:	89 f8                	mov    %edi,%eax
  802107:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80210b:	85 f6                	test   %esi,%esi
  80210d:	75 2d                	jne    80213c <__udivdi3+0x50>
  80210f:	39 cf                	cmp    %ecx,%edi
  802111:	77 65                	ja     802178 <__udivdi3+0x8c>
  802113:	89 fd                	mov    %edi,%ebp
  802115:	85 ff                	test   %edi,%edi
  802117:	75 0b                	jne    802124 <__udivdi3+0x38>
  802119:	b8 01 00 00 00       	mov    $0x1,%eax
  80211e:	31 d2                	xor    %edx,%edx
  802120:	f7 f7                	div    %edi
  802122:	89 c5                	mov    %eax,%ebp
  802124:	31 d2                	xor    %edx,%edx
  802126:	89 c8                	mov    %ecx,%eax
  802128:	f7 f5                	div    %ebp
  80212a:	89 c1                	mov    %eax,%ecx
  80212c:	89 d8                	mov    %ebx,%eax
  80212e:	f7 f5                	div    %ebp
  802130:	89 cf                	mov    %ecx,%edi
  802132:	89 fa                	mov    %edi,%edx
  802134:	83 c4 1c             	add    $0x1c,%esp
  802137:	5b                   	pop    %ebx
  802138:	5e                   	pop    %esi
  802139:	5f                   	pop    %edi
  80213a:	5d                   	pop    %ebp
  80213b:	c3                   	ret    
  80213c:	39 ce                	cmp    %ecx,%esi
  80213e:	77 28                	ja     802168 <__udivdi3+0x7c>
  802140:	0f bd fe             	bsr    %esi,%edi
  802143:	83 f7 1f             	xor    $0x1f,%edi
  802146:	75 40                	jne    802188 <__udivdi3+0x9c>
  802148:	39 ce                	cmp    %ecx,%esi
  80214a:	72 0a                	jb     802156 <__udivdi3+0x6a>
  80214c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802150:	0f 87 9e 00 00 00    	ja     8021f4 <__udivdi3+0x108>
  802156:	b8 01 00 00 00       	mov    $0x1,%eax
  80215b:	89 fa                	mov    %edi,%edx
  80215d:	83 c4 1c             	add    $0x1c,%esp
  802160:	5b                   	pop    %ebx
  802161:	5e                   	pop    %esi
  802162:	5f                   	pop    %edi
  802163:	5d                   	pop    %ebp
  802164:	c3                   	ret    
  802165:	8d 76 00             	lea    0x0(%esi),%esi
  802168:	31 ff                	xor    %edi,%edi
  80216a:	31 c0                	xor    %eax,%eax
  80216c:	89 fa                	mov    %edi,%edx
  80216e:	83 c4 1c             	add    $0x1c,%esp
  802171:	5b                   	pop    %ebx
  802172:	5e                   	pop    %esi
  802173:	5f                   	pop    %edi
  802174:	5d                   	pop    %ebp
  802175:	c3                   	ret    
  802176:	66 90                	xchg   %ax,%ax
  802178:	89 d8                	mov    %ebx,%eax
  80217a:	f7 f7                	div    %edi
  80217c:	31 ff                	xor    %edi,%edi
  80217e:	89 fa                	mov    %edi,%edx
  802180:	83 c4 1c             	add    $0x1c,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
  802188:	bd 20 00 00 00       	mov    $0x20,%ebp
  80218d:	29 fd                	sub    %edi,%ebp
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 e6                	shl    %cl,%esi
  802193:	89 c3                	mov    %eax,%ebx
  802195:	89 e9                	mov    %ebp,%ecx
  802197:	d3 eb                	shr    %cl,%ebx
  802199:	89 d9                	mov    %ebx,%ecx
  80219b:	09 f1                	or     %esi,%ecx
  80219d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021a1:	89 f9                	mov    %edi,%ecx
  8021a3:	d3 e0                	shl    %cl,%eax
  8021a5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021a9:	89 d6                	mov    %edx,%esi
  8021ab:	89 e9                	mov    %ebp,%ecx
  8021ad:	d3 ee                	shr    %cl,%esi
  8021af:	89 f9                	mov    %edi,%ecx
  8021b1:	d3 e2                	shl    %cl,%edx
  8021b3:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021b7:	89 e9                	mov    %ebp,%ecx
  8021b9:	d3 eb                	shr    %cl,%ebx
  8021bb:	09 da                	or     %ebx,%edx
  8021bd:	89 d0                	mov    %edx,%eax
  8021bf:	89 f2                	mov    %esi,%edx
  8021c1:	f7 74 24 08          	divl   0x8(%esp)
  8021c5:	89 d6                	mov    %edx,%esi
  8021c7:	89 c3                	mov    %eax,%ebx
  8021c9:	f7 64 24 0c          	mull   0xc(%esp)
  8021cd:	39 d6                	cmp    %edx,%esi
  8021cf:	72 17                	jb     8021e8 <__udivdi3+0xfc>
  8021d1:	74 09                	je     8021dc <__udivdi3+0xf0>
  8021d3:	89 d8                	mov    %ebx,%eax
  8021d5:	31 ff                	xor    %edi,%edi
  8021d7:	e9 56 ff ff ff       	jmp    802132 <__udivdi3+0x46>
  8021dc:	8b 54 24 04          	mov    0x4(%esp),%edx
  8021e0:	89 f9                	mov    %edi,%ecx
  8021e2:	d3 e2                	shl    %cl,%edx
  8021e4:	39 c2                	cmp    %eax,%edx
  8021e6:	73 eb                	jae    8021d3 <__udivdi3+0xe7>
  8021e8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8021eb:	31 ff                	xor    %edi,%edi
  8021ed:	e9 40 ff ff ff       	jmp    802132 <__udivdi3+0x46>
  8021f2:	66 90                	xchg   %ax,%ax
  8021f4:	31 c0                	xor    %eax,%eax
  8021f6:	e9 37 ff ff ff       	jmp    802132 <__udivdi3+0x46>
  8021fb:	90                   	nop

008021fc <__umoddi3>:
  8021fc:	55                   	push   %ebp
  8021fd:	57                   	push   %edi
  8021fe:	56                   	push   %esi
  8021ff:	53                   	push   %ebx
  802200:	83 ec 1c             	sub    $0x1c,%esp
  802203:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802207:	8b 74 24 34          	mov    0x34(%esp),%esi
  80220b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80220f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802213:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802217:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80221b:	89 3c 24             	mov    %edi,(%esp)
  80221e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802222:	89 f2                	mov    %esi,%edx
  802224:	85 c0                	test   %eax,%eax
  802226:	75 18                	jne    802240 <__umoddi3+0x44>
  802228:	39 f7                	cmp    %esi,%edi
  80222a:	0f 86 a0 00 00 00    	jbe    8022d0 <__umoddi3+0xd4>
  802230:	89 c8                	mov    %ecx,%eax
  802232:	f7 f7                	div    %edi
  802234:	89 d0                	mov    %edx,%eax
  802236:	31 d2                	xor    %edx,%edx
  802238:	83 c4 1c             	add    $0x1c,%esp
  80223b:	5b                   	pop    %ebx
  80223c:	5e                   	pop    %esi
  80223d:	5f                   	pop    %edi
  80223e:	5d                   	pop    %ebp
  80223f:	c3                   	ret    
  802240:	89 f3                	mov    %esi,%ebx
  802242:	39 f0                	cmp    %esi,%eax
  802244:	0f 87 a6 00 00 00    	ja     8022f0 <__umoddi3+0xf4>
  80224a:	0f bd e8             	bsr    %eax,%ebp
  80224d:	83 f5 1f             	xor    $0x1f,%ebp
  802250:	0f 84 a6 00 00 00    	je     8022fc <__umoddi3+0x100>
  802256:	bf 20 00 00 00       	mov    $0x20,%edi
  80225b:	29 ef                	sub    %ebp,%edi
  80225d:	89 e9                	mov    %ebp,%ecx
  80225f:	d3 e0                	shl    %cl,%eax
  802261:	8b 34 24             	mov    (%esp),%esi
  802264:	89 f2                	mov    %esi,%edx
  802266:	89 f9                	mov    %edi,%ecx
  802268:	d3 ea                	shr    %cl,%edx
  80226a:	09 c2                	or     %eax,%edx
  80226c:	89 14 24             	mov    %edx,(%esp)
  80226f:	89 f2                	mov    %esi,%edx
  802271:	89 e9                	mov    %ebp,%ecx
  802273:	d3 e2                	shl    %cl,%edx
  802275:	89 54 24 04          	mov    %edx,0x4(%esp)
  802279:	89 de                	mov    %ebx,%esi
  80227b:	89 f9                	mov    %edi,%ecx
  80227d:	d3 ee                	shr    %cl,%esi
  80227f:	89 e9                	mov    %ebp,%ecx
  802281:	d3 e3                	shl    %cl,%ebx
  802283:	8b 54 24 08          	mov    0x8(%esp),%edx
  802287:	89 d0                	mov    %edx,%eax
  802289:	89 f9                	mov    %edi,%ecx
  80228b:	d3 e8                	shr    %cl,%eax
  80228d:	09 d8                	or     %ebx,%eax
  80228f:	89 d3                	mov    %edx,%ebx
  802291:	89 e9                	mov    %ebp,%ecx
  802293:	d3 e3                	shl    %cl,%ebx
  802295:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802299:	89 f2                	mov    %esi,%edx
  80229b:	f7 34 24             	divl   (%esp)
  80229e:	89 d6                	mov    %edx,%esi
  8022a0:	f7 64 24 04          	mull   0x4(%esp)
  8022a4:	89 c3                	mov    %eax,%ebx
  8022a6:	89 d1                	mov    %edx,%ecx
  8022a8:	39 d6                	cmp    %edx,%esi
  8022aa:	72 7c                	jb     802328 <__umoddi3+0x12c>
  8022ac:	74 72                	je     802320 <__umoddi3+0x124>
  8022ae:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022b2:	29 da                	sub    %ebx,%edx
  8022b4:	19 ce                	sbb    %ecx,%esi
  8022b6:	89 f0                	mov    %esi,%eax
  8022b8:	89 f9                	mov    %edi,%ecx
  8022ba:	d3 e0                	shl    %cl,%eax
  8022bc:	89 e9                	mov    %ebp,%ecx
  8022be:	d3 ea                	shr    %cl,%edx
  8022c0:	09 d0                	or     %edx,%eax
  8022c2:	89 e9                	mov    %ebp,%ecx
  8022c4:	d3 ee                	shr    %cl,%esi
  8022c6:	89 f2                	mov    %esi,%edx
  8022c8:	83 c4 1c             	add    $0x1c,%esp
  8022cb:	5b                   	pop    %ebx
  8022cc:	5e                   	pop    %esi
  8022cd:	5f                   	pop    %edi
  8022ce:	5d                   	pop    %ebp
  8022cf:	c3                   	ret    
  8022d0:	89 fd                	mov    %edi,%ebp
  8022d2:	85 ff                	test   %edi,%edi
  8022d4:	75 0b                	jne    8022e1 <__umoddi3+0xe5>
  8022d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8022db:	31 d2                	xor    %edx,%edx
  8022dd:	f7 f7                	div    %edi
  8022df:	89 c5                	mov    %eax,%ebp
  8022e1:	89 f0                	mov    %esi,%eax
  8022e3:	31 d2                	xor    %edx,%edx
  8022e5:	f7 f5                	div    %ebp
  8022e7:	89 c8                	mov    %ecx,%eax
  8022e9:	f7 f5                	div    %ebp
  8022eb:	e9 44 ff ff ff       	jmp    802234 <__umoddi3+0x38>
  8022f0:	89 c8                	mov    %ecx,%eax
  8022f2:	89 f2                	mov    %esi,%edx
  8022f4:	83 c4 1c             	add    $0x1c,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    
  8022fc:	39 f0                	cmp    %esi,%eax
  8022fe:	72 05                	jb     802305 <__umoddi3+0x109>
  802300:	39 0c 24             	cmp    %ecx,(%esp)
  802303:	77 0c                	ja     802311 <__umoddi3+0x115>
  802305:	89 f2                	mov    %esi,%edx
  802307:	29 f9                	sub    %edi,%ecx
  802309:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80230d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802311:	8b 44 24 04          	mov    0x4(%esp),%eax
  802315:	83 c4 1c             	add    $0x1c,%esp
  802318:	5b                   	pop    %ebx
  802319:	5e                   	pop    %esi
  80231a:	5f                   	pop    %edi
  80231b:	5d                   	pop    %ebp
  80231c:	c3                   	ret    
  80231d:	8d 76 00             	lea    0x0(%esi),%esi
  802320:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802324:	73 88                	jae    8022ae <__umoddi3+0xb2>
  802326:	66 90                	xchg   %ax,%ax
  802328:	2b 44 24 04          	sub    0x4(%esp),%eax
  80232c:	1b 14 24             	sbb    (%esp),%edx
  80232f:	89 d1                	mov    %edx,%ecx
  802331:	89 c3                	mov    %eax,%ebx
  802333:	e9 76 ff ff ff       	jmp    8022ae <__umoddi3+0xb2>
