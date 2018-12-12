
obj/user/testbss.debug:     file format elf32-i386


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
  80002c:	e8 a5 00 00 00       	call   8000d6 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

uint32_t bigarray[ARRAYSIZE];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	int i;

	cprintf("Making sure bss works right...\n");
  800039:	68 a0 1f 80 00       	push   $0x801fa0
  80003e:	e8 0c 02 00 00       	call   80024f <cprintf>
  800043:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < ARRAYSIZE; i++)
  800046:	b8 00 00 00 00       	mov    $0x0,%eax
		if (bigarray[i] != 0)
  80004b:	83 3c 85 20 40 80 00 	cmpl   $0x0,0x804020(,%eax,4)
  800052:	00 
  800053:	75 5d                	jne    8000b2 <umain+0x7f>
	for (i = 0; i < ARRAYSIZE; i++)
  800055:	40                   	inc    %eax
  800056:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80005b:	75 ee                	jne    80004b <umain+0x18>
  80005d:	b8 00 00 00 00       	mov    $0x0,%eax
			panic("bigarray[%d] isn't cleared!\n", i);
	for (i = 0; i < ARRAYSIZE; i++)
		bigarray[i] = i;
  800062:	89 04 85 20 40 80 00 	mov    %eax,0x804020(,%eax,4)
	for (i = 0; i < ARRAYSIZE; i++)
  800069:	40                   	inc    %eax
  80006a:	3d 00 00 10 00       	cmp    $0x100000,%eax
  80006f:	75 f1                	jne    800062 <umain+0x2f>
  800071:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < ARRAYSIZE; i++)
		if (bigarray[i] != i)
  800076:	3b 04 85 20 40 80 00 	cmp    0x804020(,%eax,4),%eax
  80007d:	75 45                	jne    8000c4 <umain+0x91>
	for (i = 0; i < ARRAYSIZE; i++)
  80007f:	40                   	inc    %eax
  800080:	3d 00 00 10 00       	cmp    $0x100000,%eax
  800085:	75 ef                	jne    800076 <umain+0x43>
			panic("bigarray[%d] didn't hold its value!\n", i);

	cprintf("Yes, good.  Now doing a wild write off the end...\n");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 e8 1f 80 00       	push   $0x801fe8
  80008f:	e8 bb 01 00 00       	call   80024f <cprintf>
	bigarray[ARRAYSIZE+1024] = 0;
  800094:	c7 05 20 50 c0 00 00 	movl   $0x0,0xc05020
  80009b:	00 00 00 
	panic("SHOULD HAVE TRAPPED!!!");
  80009e:	83 c4 0c             	add    $0xc,%esp
  8000a1:	68 47 20 80 00       	push   $0x802047
  8000a6:	6a 1a                	push   $0x1a
  8000a8:	68 38 20 80 00       	push   $0x802038
  8000ad:	e8 8a 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] isn't cleared!\n", i);
  8000b2:	50                   	push   %eax
  8000b3:	68 1b 20 80 00       	push   $0x80201b
  8000b8:	6a 11                	push   $0x11
  8000ba:	68 38 20 80 00       	push   $0x802038
  8000bf:	e8 78 00 00 00       	call   80013c <_panic>
			panic("bigarray[%d] didn't hold its value!\n", i);
  8000c4:	50                   	push   %eax
  8000c5:	68 c0 1f 80 00       	push   $0x801fc0
  8000ca:	6a 16                	push   $0x16
  8000cc:	68 38 20 80 00       	push   $0x802038
  8000d1:	e8 66 00 00 00       	call   80013c <_panic>

008000d6 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000d6:	55                   	push   %ebp
  8000d7:	89 e5                	mov    %esp,%ebp
  8000d9:	56                   	push   %esi
  8000da:	53                   	push   %ebx
  8000db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000de:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000e1:	e8 07 0b 00 00       	call   800bed <sys_getenvid>
  8000e6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000eb:	89 c2                	mov    %eax,%edx
  8000ed:	c1 e2 05             	shl    $0x5,%edx
  8000f0:	29 c2                	sub    %eax,%edx
  8000f2:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000f9:	a3 20 40 c0 00       	mov    %eax,0xc04020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000fe:	85 db                	test   %ebx,%ebx
  800100:	7e 07                	jle    800109 <libmain+0x33>
		binaryname = argv[0];
  800102:	8b 06                	mov    (%esi),%eax
  800104:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800109:	83 ec 08             	sub    $0x8,%esp
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	e8 20 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800113:	e8 0a 00 00 00       	call   800122 <exit>
}
  800118:	83 c4 10             	add    $0x10,%esp
  80011b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80011e:	5b                   	pop    %ebx
  80011f:	5e                   	pop    %esi
  800120:	5d                   	pop    %ebp
  800121:	c3                   	ret    

00800122 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800122:	55                   	push   %ebp
  800123:	89 e5                	mov    %esp,%ebp
  800125:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800128:	e8 68 0f 00 00       	call   801095 <close_all>
	sys_env_destroy(0);
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	6a 00                	push   $0x0
  800132:	e8 75 0a 00 00       	call   800bac <sys_env_destroy>
}
  800137:	83 c4 10             	add    $0x10,%esp
  80013a:	c9                   	leave  
  80013b:	c3                   	ret    

0080013c <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
  800142:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800148:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80014b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800151:	e8 97 0a 00 00       	call   800bed <sys_getenvid>
  800156:	83 ec 04             	sub    $0x4,%esp
  800159:	ff 75 0c             	pushl  0xc(%ebp)
  80015c:	ff 75 08             	pushl  0x8(%ebp)
  80015f:	53                   	push   %ebx
  800160:	50                   	push   %eax
  800161:	68 68 20 80 00       	push   $0x802068
  800166:	68 00 01 00 00       	push   $0x100
  80016b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800171:	56                   	push   %esi
  800172:	e8 93 06 00 00       	call   80080a <snprintf>
  800177:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800179:	83 c4 20             	add    $0x20,%esp
  80017c:	57                   	push   %edi
  80017d:	ff 75 10             	pushl  0x10(%ebp)
  800180:	bf 00 01 00 00       	mov    $0x100,%edi
  800185:	89 f8                	mov    %edi,%eax
  800187:	29 d8                	sub    %ebx,%eax
  800189:	50                   	push   %eax
  80018a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80018d:	50                   	push   %eax
  80018e:	e8 22 06 00 00       	call   8007b5 <vsnprintf>
  800193:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800195:	83 c4 0c             	add    $0xc,%esp
  800198:	68 36 20 80 00       	push   $0x802036
  80019d:	29 df                	sub    %ebx,%edi
  80019f:	57                   	push   %edi
  8001a0:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001a3:	50                   	push   %eax
  8001a4:	e8 61 06 00 00       	call   80080a <snprintf>
	sys_cputs(buf, r);
  8001a9:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001ac:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8001ae:	53                   	push   %ebx
  8001af:	56                   	push   %esi
  8001b0:	e8 ba 09 00 00       	call   800b6f <sys_cputs>
  8001b5:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8001b8:	cc                   	int3   
  8001b9:	eb fd                	jmp    8001b8 <_panic+0x7c>

008001bb <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8001bb:	55                   	push   %ebp
  8001bc:	89 e5                	mov    %esp,%ebp
  8001be:	53                   	push   %ebx
  8001bf:	83 ec 04             	sub    $0x4,%esp
  8001c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001c5:	8b 13                	mov    (%ebx),%edx
  8001c7:	8d 42 01             	lea    0x1(%edx),%eax
  8001ca:	89 03                	mov    %eax,(%ebx)
  8001cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001cf:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001d3:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001d8:	74 08                	je     8001e2 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001da:	ff 43 04             	incl   0x4(%ebx)
}
  8001dd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001e0:	c9                   	leave  
  8001e1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001e2:	83 ec 08             	sub    $0x8,%esp
  8001e5:	68 ff 00 00 00       	push   $0xff
  8001ea:	8d 43 08             	lea    0x8(%ebx),%eax
  8001ed:	50                   	push   %eax
  8001ee:	e8 7c 09 00 00       	call   800b6f <sys_cputs>
		b->idx = 0;
  8001f3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	eb dc                	jmp    8001da <putch+0x1f>

008001fe <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001fe:	55                   	push   %ebp
  8001ff:	89 e5                	mov    %esp,%ebp
  800201:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800207:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80020e:	00 00 00 
	b.cnt = 0;
  800211:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800218:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80021b:	ff 75 0c             	pushl  0xc(%ebp)
  80021e:	ff 75 08             	pushl  0x8(%ebp)
  800221:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800227:	50                   	push   %eax
  800228:	68 bb 01 80 00       	push   $0x8001bb
  80022d:	e8 17 01 00 00       	call   800349 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800232:	83 c4 08             	add    $0x8,%esp
  800235:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80023b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800241:	50                   	push   %eax
  800242:	e8 28 09 00 00       	call   800b6f <sys_cputs>

	return b.cnt;
}
  800247:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80024d:	c9                   	leave  
  80024e:	c3                   	ret    

0080024f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80024f:	55                   	push   %ebp
  800250:	89 e5                	mov    %esp,%ebp
  800252:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800255:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800258:	50                   	push   %eax
  800259:	ff 75 08             	pushl  0x8(%ebp)
  80025c:	e8 9d ff ff ff       	call   8001fe <vcprintf>
	va_end(ap);

	return cnt;
}
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	57                   	push   %edi
  800267:	56                   	push   %esi
  800268:	53                   	push   %ebx
  800269:	83 ec 1c             	sub    $0x1c,%esp
  80026c:	89 c7                	mov    %eax,%edi
  80026e:	89 d6                	mov    %edx,%esi
  800270:	8b 45 08             	mov    0x8(%ebp),%eax
  800273:	8b 55 0c             	mov    0xc(%ebp),%edx
  800276:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800279:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80027c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80027f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800284:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800287:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80028a:	39 d3                	cmp    %edx,%ebx
  80028c:	72 05                	jb     800293 <printnum+0x30>
  80028e:	39 45 10             	cmp    %eax,0x10(%ebp)
  800291:	77 78                	ja     80030b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800293:	83 ec 0c             	sub    $0xc,%esp
  800296:	ff 75 18             	pushl  0x18(%ebp)
  800299:	8b 45 14             	mov    0x14(%ebp),%eax
  80029c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80029f:	53                   	push   %ebx
  8002a0:	ff 75 10             	pushl  0x10(%ebp)
  8002a3:	83 ec 08             	sub    $0x8,%esp
  8002a6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002a9:	ff 75 e0             	pushl  -0x20(%ebp)
  8002ac:	ff 75 dc             	pushl  -0x24(%ebp)
  8002af:	ff 75 d8             	pushl  -0x28(%ebp)
  8002b2:	e8 81 1a 00 00       	call   801d38 <__udivdi3>
  8002b7:	83 c4 18             	add    $0x18,%esp
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	89 f2                	mov    %esi,%edx
  8002be:	89 f8                	mov    %edi,%eax
  8002c0:	e8 9e ff ff ff       	call   800263 <printnum>
  8002c5:	83 c4 20             	add    $0x20,%esp
  8002c8:	eb 11                	jmp    8002db <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	56                   	push   %esi
  8002ce:	ff 75 18             	pushl  0x18(%ebp)
  8002d1:	ff d7                	call   *%edi
  8002d3:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002d6:	4b                   	dec    %ebx
  8002d7:	85 db                	test   %ebx,%ebx
  8002d9:	7f ef                	jg     8002ca <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	56                   	push   %esi
  8002df:	83 ec 04             	sub    $0x4,%esp
  8002e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8002e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8002eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ee:	e8 55 1b 00 00       	call   801e48 <__umoddi3>
  8002f3:	83 c4 14             	add    $0x14,%esp
  8002f6:	0f be 80 8b 20 80 00 	movsbl 0x80208b(%eax),%eax
  8002fd:	50                   	push   %eax
  8002fe:	ff d7                	call   *%edi
}
  800300:	83 c4 10             	add    $0x10,%esp
  800303:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800306:	5b                   	pop    %ebx
  800307:	5e                   	pop    %esi
  800308:	5f                   	pop    %edi
  800309:	5d                   	pop    %ebp
  80030a:	c3                   	ret    
  80030b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80030e:	eb c6                	jmp    8002d6 <printnum+0x73>

00800310 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800316:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800319:	8b 10                	mov    (%eax),%edx
  80031b:	3b 50 04             	cmp    0x4(%eax),%edx
  80031e:	73 0a                	jae    80032a <sprintputch+0x1a>
		*b->buf++ = ch;
  800320:	8d 4a 01             	lea    0x1(%edx),%ecx
  800323:	89 08                	mov    %ecx,(%eax)
  800325:	8b 45 08             	mov    0x8(%ebp),%eax
  800328:	88 02                	mov    %al,(%edx)
}
  80032a:	5d                   	pop    %ebp
  80032b:	c3                   	ret    

0080032c <printfmt>:
{
  80032c:	55                   	push   %ebp
  80032d:	89 e5                	mov    %esp,%ebp
  80032f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800332:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800335:	50                   	push   %eax
  800336:	ff 75 10             	pushl  0x10(%ebp)
  800339:	ff 75 0c             	pushl  0xc(%ebp)
  80033c:	ff 75 08             	pushl  0x8(%ebp)
  80033f:	e8 05 00 00 00       	call   800349 <vprintfmt>
}
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	c9                   	leave  
  800348:	c3                   	ret    

00800349 <vprintfmt>:
{
  800349:	55                   	push   %ebp
  80034a:	89 e5                	mov    %esp,%ebp
  80034c:	57                   	push   %edi
  80034d:	56                   	push   %esi
  80034e:	53                   	push   %ebx
  80034f:	83 ec 2c             	sub    $0x2c,%esp
  800352:	8b 75 08             	mov    0x8(%ebp),%esi
  800355:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800358:	8b 7d 10             	mov    0x10(%ebp),%edi
  80035b:	e9 ae 03 00 00       	jmp    80070e <vprintfmt+0x3c5>
  800360:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800364:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80036b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800372:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800379:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80037e:	8d 47 01             	lea    0x1(%edi),%eax
  800381:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800384:	8a 17                	mov    (%edi),%dl
  800386:	8d 42 dd             	lea    -0x23(%edx),%eax
  800389:	3c 55                	cmp    $0x55,%al
  80038b:	0f 87 fe 03 00 00    	ja     80078f <vprintfmt+0x446>
  800391:	0f b6 c0             	movzbl %al,%eax
  800394:	ff 24 85 c0 21 80 00 	jmp    *0x8021c0(,%eax,4)
  80039b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80039e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8003a2:	eb da                	jmp    80037e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8003a7:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8003ab:	eb d1                	jmp    80037e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8003ad:	0f b6 d2             	movzbl %dl,%edx
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8003b8:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8003bb:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8003be:	01 c0                	add    %eax,%eax
  8003c0:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003c4:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003c7:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003ca:	83 f9 09             	cmp    $0x9,%ecx
  8003cd:	77 52                	ja     800421 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003cf:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003d0:	eb e9                	jmp    8003bb <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d5:	8b 00                	mov    (%eax),%eax
  8003d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 40 04             	lea    0x4(%eax),%eax
  8003e0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003e6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ea:	79 92                	jns    80037e <vprintfmt+0x35>
				width = precision, precision = -1;
  8003ec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003ef:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003f2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003f9:	eb 83                	jmp    80037e <vprintfmt+0x35>
  8003fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ff:	78 08                	js     800409 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800401:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800404:	e9 75 ff ff ff       	jmp    80037e <vprintfmt+0x35>
  800409:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800410:	eb ef                	jmp    800401 <vprintfmt+0xb8>
  800412:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800415:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80041c:	e9 5d ff ff ff       	jmp    80037e <vprintfmt+0x35>
  800421:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800424:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800427:	eb bd                	jmp    8003e6 <vprintfmt+0x9d>
			lflag++;
  800429:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80042a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80042d:	e9 4c ff ff ff       	jmp    80037e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	8d 78 04             	lea    0x4(%eax),%edi
  800438:	83 ec 08             	sub    $0x8,%esp
  80043b:	53                   	push   %ebx
  80043c:	ff 30                	pushl  (%eax)
  80043e:	ff d6                	call   *%esi
			break;
  800440:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800443:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800446:	e9 c0 02 00 00       	jmp    80070b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80044b:	8b 45 14             	mov    0x14(%ebp),%eax
  80044e:	8d 78 04             	lea    0x4(%eax),%edi
  800451:	8b 00                	mov    (%eax),%eax
  800453:	85 c0                	test   %eax,%eax
  800455:	78 2a                	js     800481 <vprintfmt+0x138>
  800457:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800459:	83 f8 0f             	cmp    $0xf,%eax
  80045c:	7f 27                	jg     800485 <vprintfmt+0x13c>
  80045e:	8b 04 85 20 23 80 00 	mov    0x802320(,%eax,4),%eax
  800465:	85 c0                	test   %eax,%eax
  800467:	74 1c                	je     800485 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800469:	50                   	push   %eax
  80046a:	68 51 24 80 00       	push   $0x802451
  80046f:	53                   	push   %ebx
  800470:	56                   	push   %esi
  800471:	e8 b6 fe ff ff       	call   80032c <printfmt>
  800476:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800479:	89 7d 14             	mov    %edi,0x14(%ebp)
  80047c:	e9 8a 02 00 00       	jmp    80070b <vprintfmt+0x3c2>
  800481:	f7 d8                	neg    %eax
  800483:	eb d2                	jmp    800457 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800485:	52                   	push   %edx
  800486:	68 a3 20 80 00       	push   $0x8020a3
  80048b:	53                   	push   %ebx
  80048c:	56                   	push   %esi
  80048d:	e8 9a fe ff ff       	call   80032c <printfmt>
  800492:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800495:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800498:	e9 6e 02 00 00       	jmp    80070b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80049d:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a0:	83 c0 04             	add    $0x4,%eax
  8004a3:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8004a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a9:	8b 38                	mov    (%eax),%edi
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	74 39                	je     8004e8 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8004af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004b3:	0f 8e a9 00 00 00    	jle    800562 <vprintfmt+0x219>
  8004b9:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8004bd:	0f 84 a7 00 00 00    	je     80056a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c3:	83 ec 08             	sub    $0x8,%esp
  8004c6:	ff 75 d0             	pushl  -0x30(%ebp)
  8004c9:	57                   	push   %edi
  8004ca:	e8 6b 03 00 00       	call   80083a <strnlen>
  8004cf:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004d2:	29 c1                	sub    %eax,%ecx
  8004d4:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004d7:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004da:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004de:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004e4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004e6:	eb 14                	jmp    8004fc <vprintfmt+0x1b3>
				p = "(null)";
  8004e8:	bf 9c 20 80 00       	mov    $0x80209c,%edi
  8004ed:	eb c0                	jmp    8004af <vprintfmt+0x166>
					putch(padc, putdat);
  8004ef:	83 ec 08             	sub    $0x8,%esp
  8004f2:	53                   	push   %ebx
  8004f3:	ff 75 e0             	pushl  -0x20(%ebp)
  8004f6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004f8:	4f                   	dec    %edi
  8004f9:	83 c4 10             	add    $0x10,%esp
  8004fc:	85 ff                	test   %edi,%edi
  8004fe:	7f ef                	jg     8004ef <vprintfmt+0x1a6>
  800500:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800503:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800506:	89 c8                	mov    %ecx,%eax
  800508:	85 c9                	test   %ecx,%ecx
  80050a:	78 10                	js     80051c <vprintfmt+0x1d3>
  80050c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80050f:	29 c1                	sub    %eax,%ecx
  800511:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800514:	89 75 08             	mov    %esi,0x8(%ebp)
  800517:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80051a:	eb 15                	jmp    800531 <vprintfmt+0x1e8>
  80051c:	b8 00 00 00 00       	mov    $0x0,%eax
  800521:	eb e9                	jmp    80050c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800523:	83 ec 08             	sub    $0x8,%esp
  800526:	53                   	push   %ebx
  800527:	52                   	push   %edx
  800528:	ff 55 08             	call   *0x8(%ebp)
  80052b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80052e:	ff 4d e0             	decl   -0x20(%ebp)
  800531:	47                   	inc    %edi
  800532:	8a 47 ff             	mov    -0x1(%edi),%al
  800535:	0f be d0             	movsbl %al,%edx
  800538:	85 d2                	test   %edx,%edx
  80053a:	74 59                	je     800595 <vprintfmt+0x24c>
  80053c:	85 f6                	test   %esi,%esi
  80053e:	78 03                	js     800543 <vprintfmt+0x1fa>
  800540:	4e                   	dec    %esi
  800541:	78 2f                	js     800572 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800543:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800547:	74 da                	je     800523 <vprintfmt+0x1da>
  800549:	0f be c0             	movsbl %al,%eax
  80054c:	83 e8 20             	sub    $0x20,%eax
  80054f:	83 f8 5e             	cmp    $0x5e,%eax
  800552:	76 cf                	jbe    800523 <vprintfmt+0x1da>
					putch('?', putdat);
  800554:	83 ec 08             	sub    $0x8,%esp
  800557:	53                   	push   %ebx
  800558:	6a 3f                	push   $0x3f
  80055a:	ff 55 08             	call   *0x8(%ebp)
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	eb cc                	jmp    80052e <vprintfmt+0x1e5>
  800562:	89 75 08             	mov    %esi,0x8(%ebp)
  800565:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800568:	eb c7                	jmp    800531 <vprintfmt+0x1e8>
  80056a:	89 75 08             	mov    %esi,0x8(%ebp)
  80056d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800570:	eb bf                	jmp    800531 <vprintfmt+0x1e8>
  800572:	8b 75 08             	mov    0x8(%ebp),%esi
  800575:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800578:	eb 0c                	jmp    800586 <vprintfmt+0x23d>
				putch(' ', putdat);
  80057a:	83 ec 08             	sub    $0x8,%esp
  80057d:	53                   	push   %ebx
  80057e:	6a 20                	push   $0x20
  800580:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800582:	4f                   	dec    %edi
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	85 ff                	test   %edi,%edi
  800588:	7f f0                	jg     80057a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80058a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80058d:	89 45 14             	mov    %eax,0x14(%ebp)
  800590:	e9 76 01 00 00       	jmp    80070b <vprintfmt+0x3c2>
  800595:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800598:	8b 75 08             	mov    0x8(%ebp),%esi
  80059b:	eb e9                	jmp    800586 <vprintfmt+0x23d>
	if (lflag >= 2)
  80059d:	83 f9 01             	cmp    $0x1,%ecx
  8005a0:	7f 1f                	jg     8005c1 <vprintfmt+0x278>
	else if (lflag)
  8005a2:	85 c9                	test   %ecx,%ecx
  8005a4:	75 48                	jne    8005ee <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005ae:	89 c1                	mov    %eax,%ecx
  8005b0:	c1 f9 1f             	sar    $0x1f,%ecx
  8005b3:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b9:	8d 40 04             	lea    0x4(%eax),%eax
  8005bc:	89 45 14             	mov    %eax,0x14(%ebp)
  8005bf:	eb 17                	jmp    8005d8 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8005c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c4:	8b 50 04             	mov    0x4(%eax),%edx
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005cc:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d2:	8d 40 08             	lea    0x8(%eax),%eax
  8005d5:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005db:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005de:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005e2:	78 25                	js     800609 <vprintfmt+0x2c0>
			base = 10;
  8005e4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005e9:	e9 03 01 00 00       	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005f6:	89 c1                	mov    %eax,%ecx
  8005f8:	c1 f9 1f             	sar    $0x1f,%ecx
  8005fb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800601:	8d 40 04             	lea    0x4(%eax),%eax
  800604:	89 45 14             	mov    %eax,0x14(%ebp)
  800607:	eb cf                	jmp    8005d8 <vprintfmt+0x28f>
				putch('-', putdat);
  800609:	83 ec 08             	sub    $0x8,%esp
  80060c:	53                   	push   %ebx
  80060d:	6a 2d                	push   $0x2d
  80060f:	ff d6                	call   *%esi
				num = -(long long) num;
  800611:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800614:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800617:	f7 da                	neg    %edx
  800619:	83 d1 00             	adc    $0x0,%ecx
  80061c:	f7 d9                	neg    %ecx
  80061e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800621:	b8 0a 00 00 00       	mov    $0xa,%eax
  800626:	e9 c6 00 00 00       	jmp    8006f1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80062b:	83 f9 01             	cmp    $0x1,%ecx
  80062e:	7f 1e                	jg     80064e <vprintfmt+0x305>
	else if (lflag)
  800630:	85 c9                	test   %ecx,%ecx
  800632:	75 32                	jne    800666 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800634:	8b 45 14             	mov    0x14(%ebp),%eax
  800637:	8b 10                	mov    (%eax),%edx
  800639:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063e:	8d 40 04             	lea    0x4(%eax),%eax
  800641:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800644:	b8 0a 00 00 00       	mov    $0xa,%eax
  800649:	e9 a3 00 00 00       	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80064e:	8b 45 14             	mov    0x14(%ebp),%eax
  800651:	8b 10                	mov    (%eax),%edx
  800653:	8b 48 04             	mov    0x4(%eax),%ecx
  800656:	8d 40 08             	lea    0x8(%eax),%eax
  800659:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80065c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800661:	e9 8b 00 00 00       	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800666:	8b 45 14             	mov    0x14(%ebp),%eax
  800669:	8b 10                	mov    (%eax),%edx
  80066b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800670:	8d 40 04             	lea    0x4(%eax),%eax
  800673:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800676:	b8 0a 00 00 00       	mov    $0xa,%eax
  80067b:	eb 74                	jmp    8006f1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80067d:	83 f9 01             	cmp    $0x1,%ecx
  800680:	7f 1b                	jg     80069d <vprintfmt+0x354>
	else if (lflag)
  800682:	85 c9                	test   %ecx,%ecx
  800684:	75 2c                	jne    8006b2 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800686:	8b 45 14             	mov    0x14(%ebp),%eax
  800689:	8b 10                	mov    (%eax),%edx
  80068b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800690:	8d 40 04             	lea    0x4(%eax),%eax
  800693:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800696:	b8 08 00 00 00       	mov    $0x8,%eax
  80069b:	eb 54                	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 10                	mov    (%eax),%edx
  8006a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8006a5:	8d 40 08             	lea    0x8(%eax),%eax
  8006a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006ab:	b8 08 00 00 00       	mov    $0x8,%eax
  8006b0:	eb 3f                	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 10                	mov    (%eax),%edx
  8006b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006bc:	8d 40 04             	lea    0x4(%eax),%eax
  8006bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8006c2:	b8 08 00 00 00       	mov    $0x8,%eax
  8006c7:	eb 28                	jmp    8006f1 <vprintfmt+0x3a8>
			putch('0', putdat);
  8006c9:	83 ec 08             	sub    $0x8,%esp
  8006cc:	53                   	push   %ebx
  8006cd:	6a 30                	push   $0x30
  8006cf:	ff d6                	call   *%esi
			putch('x', putdat);
  8006d1:	83 c4 08             	add    $0x8,%esp
  8006d4:	53                   	push   %ebx
  8006d5:	6a 78                	push   $0x78
  8006d7:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006dc:	8b 10                	mov    (%eax),%edx
  8006de:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006e3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006e6:	8d 40 04             	lea    0x4(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ec:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006f1:	83 ec 0c             	sub    $0xc,%esp
  8006f4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006f8:	57                   	push   %edi
  8006f9:	ff 75 e0             	pushl  -0x20(%ebp)
  8006fc:	50                   	push   %eax
  8006fd:	51                   	push   %ecx
  8006fe:	52                   	push   %edx
  8006ff:	89 da                	mov    %ebx,%edx
  800701:	89 f0                	mov    %esi,%eax
  800703:	e8 5b fb ff ff       	call   800263 <printnum>
			break;
  800708:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80070b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070e:	47                   	inc    %edi
  80070f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800713:	83 f8 25             	cmp    $0x25,%eax
  800716:	0f 84 44 fc ff ff    	je     800360 <vprintfmt+0x17>
			if (ch == '\0')
  80071c:	85 c0                	test   %eax,%eax
  80071e:	0f 84 89 00 00 00    	je     8007ad <vprintfmt+0x464>
			putch(ch, putdat);
  800724:	83 ec 08             	sub    $0x8,%esp
  800727:	53                   	push   %ebx
  800728:	50                   	push   %eax
  800729:	ff d6                	call   *%esi
  80072b:	83 c4 10             	add    $0x10,%esp
  80072e:	eb de                	jmp    80070e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800730:	83 f9 01             	cmp    $0x1,%ecx
  800733:	7f 1b                	jg     800750 <vprintfmt+0x407>
	else if (lflag)
  800735:	85 c9                	test   %ecx,%ecx
  800737:	75 2c                	jne    800765 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800739:	8b 45 14             	mov    0x14(%ebp),%eax
  80073c:	8b 10                	mov    (%eax),%edx
  80073e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800743:	8d 40 04             	lea    0x4(%eax),%eax
  800746:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800749:	b8 10 00 00 00       	mov    $0x10,%eax
  80074e:	eb a1                	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800750:	8b 45 14             	mov    0x14(%ebp),%eax
  800753:	8b 10                	mov    (%eax),%edx
  800755:	8b 48 04             	mov    0x4(%eax),%ecx
  800758:	8d 40 08             	lea    0x8(%eax),%eax
  80075b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80075e:	b8 10 00 00 00       	mov    $0x10,%eax
  800763:	eb 8c                	jmp    8006f1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800765:	8b 45 14             	mov    0x14(%ebp),%eax
  800768:	8b 10                	mov    (%eax),%edx
  80076a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80076f:	8d 40 04             	lea    0x4(%eax),%eax
  800772:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800775:	b8 10 00 00 00       	mov    $0x10,%eax
  80077a:	e9 72 ff ff ff       	jmp    8006f1 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	53                   	push   %ebx
  800783:	6a 25                	push   $0x25
  800785:	ff d6                	call   *%esi
			break;
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	e9 7c ff ff ff       	jmp    80070b <vprintfmt+0x3c2>
			putch('%', putdat);
  80078f:	83 ec 08             	sub    $0x8,%esp
  800792:	53                   	push   %ebx
  800793:	6a 25                	push   $0x25
  800795:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800797:	83 c4 10             	add    $0x10,%esp
  80079a:	89 f8                	mov    %edi,%eax
  80079c:	eb 01                	jmp    80079f <vprintfmt+0x456>
  80079e:	48                   	dec    %eax
  80079f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8007a3:	75 f9                	jne    80079e <vprintfmt+0x455>
  8007a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007a8:	e9 5e ff ff ff       	jmp    80070b <vprintfmt+0x3c2>
}
  8007ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007b0:	5b                   	pop    %ebx
  8007b1:	5e                   	pop    %esi
  8007b2:	5f                   	pop    %edi
  8007b3:	5d                   	pop    %ebp
  8007b4:	c3                   	ret    

008007b5 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8007b5:	55                   	push   %ebp
  8007b6:	89 e5                	mov    %esp,%ebp
  8007b8:	83 ec 18             	sub    $0x18,%esp
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8007c1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007c4:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007c8:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007cb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007d2:	85 c0                	test   %eax,%eax
  8007d4:	74 26                	je     8007fc <vsnprintf+0x47>
  8007d6:	85 d2                	test   %edx,%edx
  8007d8:	7e 29                	jle    800803 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007da:	ff 75 14             	pushl  0x14(%ebp)
  8007dd:	ff 75 10             	pushl  0x10(%ebp)
  8007e0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007e3:	50                   	push   %eax
  8007e4:	68 10 03 80 00       	push   $0x800310
  8007e9:	e8 5b fb ff ff       	call   800349 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007f1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007f7:	83 c4 10             	add    $0x10,%esp
}
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    
		return -E_INVAL;
  8007fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800801:	eb f7                	jmp    8007fa <vsnprintf+0x45>
  800803:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800808:	eb f0                	jmp    8007fa <vsnprintf+0x45>

0080080a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80080a:	55                   	push   %ebp
  80080b:	89 e5                	mov    %esp,%ebp
  80080d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800810:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800813:	50                   	push   %eax
  800814:	ff 75 10             	pushl  0x10(%ebp)
  800817:	ff 75 0c             	pushl  0xc(%ebp)
  80081a:	ff 75 08             	pushl  0x8(%ebp)
  80081d:	e8 93 ff ff ff       	call   8007b5 <vsnprintf>
	va_end(ap);

	return rc;
}
  800822:	c9                   	leave  
  800823:	c3                   	ret    

00800824 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80082a:	b8 00 00 00 00       	mov    $0x0,%eax
  80082f:	eb 01                	jmp    800832 <strlen+0xe>
		n++;
  800831:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800832:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800836:	75 f9                	jne    800831 <strlen+0xd>
	return n;
}
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    

0080083a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80083a:	55                   	push   %ebp
  80083b:	89 e5                	mov    %esp,%ebp
  80083d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800843:	b8 00 00 00 00       	mov    $0x0,%eax
  800848:	eb 01                	jmp    80084b <strnlen+0x11>
		n++;
  80084a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80084b:	39 d0                	cmp    %edx,%eax
  80084d:	74 06                	je     800855 <strnlen+0x1b>
  80084f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800853:	75 f5                	jne    80084a <strnlen+0x10>
	return n;
}
  800855:	5d                   	pop    %ebp
  800856:	c3                   	ret    

00800857 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800857:	55                   	push   %ebp
  800858:	89 e5                	mov    %esp,%ebp
  80085a:	53                   	push   %ebx
  80085b:	8b 45 08             	mov    0x8(%ebp),%eax
  80085e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800861:	89 c2                	mov    %eax,%edx
  800863:	42                   	inc    %edx
  800864:	41                   	inc    %ecx
  800865:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800868:	88 5a ff             	mov    %bl,-0x1(%edx)
  80086b:	84 db                	test   %bl,%bl
  80086d:	75 f4                	jne    800863 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80086f:	5b                   	pop    %ebx
  800870:	5d                   	pop    %ebp
  800871:	c3                   	ret    

00800872 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800872:	55                   	push   %ebp
  800873:	89 e5                	mov    %esp,%ebp
  800875:	53                   	push   %ebx
  800876:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800879:	53                   	push   %ebx
  80087a:	e8 a5 ff ff ff       	call   800824 <strlen>
  80087f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800882:	ff 75 0c             	pushl  0xc(%ebp)
  800885:	01 d8                	add    %ebx,%eax
  800887:	50                   	push   %eax
  800888:	e8 ca ff ff ff       	call   800857 <strcpy>
	return dst;
}
  80088d:	89 d8                	mov    %ebx,%eax
  80088f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800892:	c9                   	leave  
  800893:	c3                   	ret    

00800894 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800894:	55                   	push   %ebp
  800895:	89 e5                	mov    %esp,%ebp
  800897:	56                   	push   %esi
  800898:	53                   	push   %ebx
  800899:	8b 75 08             	mov    0x8(%ebp),%esi
  80089c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80089f:	89 f3                	mov    %esi,%ebx
  8008a1:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8008a4:	89 f2                	mov    %esi,%edx
  8008a6:	eb 0c                	jmp    8008b4 <strncpy+0x20>
		*dst++ = *src;
  8008a8:	42                   	inc    %edx
  8008a9:	8a 01                	mov    (%ecx),%al
  8008ab:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8008ae:	80 39 01             	cmpb   $0x1,(%ecx)
  8008b1:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8008b4:	39 da                	cmp    %ebx,%edx
  8008b6:	75 f0                	jne    8008a8 <strncpy+0x14>
	}
	return ret;
}
  8008b8:	89 f0                	mov    %esi,%eax
  8008ba:	5b                   	pop    %ebx
  8008bb:	5e                   	pop    %esi
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	56                   	push   %esi
  8008c2:	53                   	push   %ebx
  8008c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8008c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008cc:	85 c0                	test   %eax,%eax
  8008ce:	74 20                	je     8008f0 <strlcpy+0x32>
  8008d0:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008d4:	89 f0                	mov    %esi,%eax
  8008d6:	eb 05                	jmp    8008dd <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008d8:	40                   	inc    %eax
  8008d9:	42                   	inc    %edx
  8008da:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008dd:	39 d8                	cmp    %ebx,%eax
  8008df:	74 06                	je     8008e7 <strlcpy+0x29>
  8008e1:	8a 0a                	mov    (%edx),%cl
  8008e3:	84 c9                	test   %cl,%cl
  8008e5:	75 f1                	jne    8008d8 <strlcpy+0x1a>
		*dst = '\0';
  8008e7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008ea:	29 f0                	sub    %esi,%eax
}
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    
  8008f0:	89 f0                	mov    %esi,%eax
  8008f2:	eb f6                	jmp    8008ea <strlcpy+0x2c>

008008f4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008fd:	eb 02                	jmp    800901 <strcmp+0xd>
		p++, q++;
  8008ff:	41                   	inc    %ecx
  800900:	42                   	inc    %edx
	while (*p && *p == *q)
  800901:	8a 01                	mov    (%ecx),%al
  800903:	84 c0                	test   %al,%al
  800905:	74 04                	je     80090b <strcmp+0x17>
  800907:	3a 02                	cmp    (%edx),%al
  800909:	74 f4                	je     8008ff <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80090b:	0f b6 c0             	movzbl %al,%eax
  80090e:	0f b6 12             	movzbl (%edx),%edx
  800911:	29 d0                	sub    %edx,%eax
}
  800913:	5d                   	pop    %ebp
  800914:	c3                   	ret    

00800915 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	53                   	push   %ebx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80091f:	89 c3                	mov    %eax,%ebx
  800921:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800924:	eb 02                	jmp    800928 <strncmp+0x13>
		n--, p++, q++;
  800926:	40                   	inc    %eax
  800927:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800928:	39 d8                	cmp    %ebx,%eax
  80092a:	74 15                	je     800941 <strncmp+0x2c>
  80092c:	8a 08                	mov    (%eax),%cl
  80092e:	84 c9                	test   %cl,%cl
  800930:	74 04                	je     800936 <strncmp+0x21>
  800932:	3a 0a                	cmp    (%edx),%cl
  800934:	74 f0                	je     800926 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800936:	0f b6 00             	movzbl (%eax),%eax
  800939:	0f b6 12             	movzbl (%edx),%edx
  80093c:	29 d0                	sub    %edx,%eax
}
  80093e:	5b                   	pop    %ebx
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    
		return 0;
  800941:	b8 00 00 00 00       	mov    $0x0,%eax
  800946:	eb f6                	jmp    80093e <strncmp+0x29>

00800948 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	8b 45 08             	mov    0x8(%ebp),%eax
  80094e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800951:	8a 10                	mov    (%eax),%dl
  800953:	84 d2                	test   %dl,%dl
  800955:	74 07                	je     80095e <strchr+0x16>
		if (*s == c)
  800957:	38 ca                	cmp    %cl,%dl
  800959:	74 08                	je     800963 <strchr+0x1b>
	for (; *s; s++)
  80095b:	40                   	inc    %eax
  80095c:	eb f3                	jmp    800951 <strchr+0x9>
			return (char *) s;
	return 0;
  80095e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800963:	5d                   	pop    %ebp
  800964:	c3                   	ret    

00800965 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800965:	55                   	push   %ebp
  800966:	89 e5                	mov    %esp,%ebp
  800968:	8b 45 08             	mov    0x8(%ebp),%eax
  80096b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80096e:	8a 10                	mov    (%eax),%dl
  800970:	84 d2                	test   %dl,%dl
  800972:	74 07                	je     80097b <strfind+0x16>
		if (*s == c)
  800974:	38 ca                	cmp    %cl,%dl
  800976:	74 03                	je     80097b <strfind+0x16>
	for (; *s; s++)
  800978:	40                   	inc    %eax
  800979:	eb f3                	jmp    80096e <strfind+0x9>
			break;
	return (char *) s;
}
  80097b:	5d                   	pop    %ebp
  80097c:	c3                   	ret    

0080097d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80097d:	55                   	push   %ebp
  80097e:	89 e5                	mov    %esp,%ebp
  800980:	57                   	push   %edi
  800981:	56                   	push   %esi
  800982:	53                   	push   %ebx
  800983:	8b 7d 08             	mov    0x8(%ebp),%edi
  800986:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800989:	85 c9                	test   %ecx,%ecx
  80098b:	74 13                	je     8009a0 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80098d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800993:	75 05                	jne    80099a <memset+0x1d>
  800995:	f6 c1 03             	test   $0x3,%cl
  800998:	74 0d                	je     8009a7 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	fc                   	cld    
  80099e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8009a0:	89 f8                	mov    %edi,%eax
  8009a2:	5b                   	pop    %ebx
  8009a3:	5e                   	pop    %esi
  8009a4:	5f                   	pop    %edi
  8009a5:	5d                   	pop    %ebp
  8009a6:	c3                   	ret    
		c &= 0xFF;
  8009a7:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8009ab:	89 d3                	mov    %edx,%ebx
  8009ad:	c1 e3 08             	shl    $0x8,%ebx
  8009b0:	89 d0                	mov    %edx,%eax
  8009b2:	c1 e0 18             	shl    $0x18,%eax
  8009b5:	89 d6                	mov    %edx,%esi
  8009b7:	c1 e6 10             	shl    $0x10,%esi
  8009ba:	09 f0                	or     %esi,%eax
  8009bc:	09 c2                	or     %eax,%edx
  8009be:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8009c0:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8009c3:	89 d0                	mov    %edx,%eax
  8009c5:	fc                   	cld    
  8009c6:	f3 ab                	rep stos %eax,%es:(%edi)
  8009c8:	eb d6                	jmp    8009a0 <memset+0x23>

008009ca <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009ca:	55                   	push   %ebp
  8009cb:	89 e5                	mov    %esp,%ebp
  8009cd:	57                   	push   %edi
  8009ce:	56                   	push   %esi
  8009cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d2:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009d5:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009d8:	39 c6                	cmp    %eax,%esi
  8009da:	73 33                	jae    800a0f <memmove+0x45>
  8009dc:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009df:	39 d0                	cmp    %edx,%eax
  8009e1:	73 2c                	jae    800a0f <memmove+0x45>
		s += n;
		d += n;
  8009e3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009e6:	89 d6                	mov    %edx,%esi
  8009e8:	09 fe                	or     %edi,%esi
  8009ea:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009f0:	75 13                	jne    800a05 <memmove+0x3b>
  8009f2:	f6 c1 03             	test   $0x3,%cl
  8009f5:	75 0e                	jne    800a05 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009f7:	83 ef 04             	sub    $0x4,%edi
  8009fa:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009fd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800a00:	fd                   	std    
  800a01:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a03:	eb 07                	jmp    800a0c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800a05:	4f                   	dec    %edi
  800a06:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800a09:	fd                   	std    
  800a0a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800a0c:	fc                   	cld    
  800a0d:	eb 13                	jmp    800a22 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800a0f:	89 f2                	mov    %esi,%edx
  800a11:	09 c2                	or     %eax,%edx
  800a13:	f6 c2 03             	test   $0x3,%dl
  800a16:	75 05                	jne    800a1d <memmove+0x53>
  800a18:	f6 c1 03             	test   $0x3,%cl
  800a1b:	74 09                	je     800a26 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800a1d:	89 c7                	mov    %eax,%edi
  800a1f:	fc                   	cld    
  800a20:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800a22:	5e                   	pop    %esi
  800a23:	5f                   	pop    %edi
  800a24:	5d                   	pop    %ebp
  800a25:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a26:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a29:	89 c7                	mov    %eax,%edi
  800a2b:	fc                   	cld    
  800a2c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a2e:	eb f2                	jmp    800a22 <memmove+0x58>

00800a30 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a33:	ff 75 10             	pushl  0x10(%ebp)
  800a36:	ff 75 0c             	pushl  0xc(%ebp)
  800a39:	ff 75 08             	pushl  0x8(%ebp)
  800a3c:	e8 89 ff ff ff       	call   8009ca <memmove>
}
  800a41:	c9                   	leave  
  800a42:	c3                   	ret    

00800a43 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a43:	55                   	push   %ebp
  800a44:	89 e5                	mov    %esp,%ebp
  800a46:	56                   	push   %esi
  800a47:	53                   	push   %ebx
  800a48:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4b:	89 c6                	mov    %eax,%esi
  800a4d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a50:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a53:	39 f0                	cmp    %esi,%eax
  800a55:	74 16                	je     800a6d <memcmp+0x2a>
		if (*s1 != *s2)
  800a57:	8a 08                	mov    (%eax),%cl
  800a59:	8a 1a                	mov    (%edx),%bl
  800a5b:	38 d9                	cmp    %bl,%cl
  800a5d:	75 04                	jne    800a63 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a5f:	40                   	inc    %eax
  800a60:	42                   	inc    %edx
  800a61:	eb f0                	jmp    800a53 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a63:	0f b6 c1             	movzbl %cl,%eax
  800a66:	0f b6 db             	movzbl %bl,%ebx
  800a69:	29 d8                	sub    %ebx,%eax
  800a6b:	eb 05                	jmp    800a72 <memcmp+0x2f>
	}

	return 0;
  800a6d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a72:	5b                   	pop    %ebx
  800a73:	5e                   	pop    %esi
  800a74:	5d                   	pop    %ebp
  800a75:	c3                   	ret    

00800a76 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a76:	55                   	push   %ebp
  800a77:	89 e5                	mov    %esp,%ebp
  800a79:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a7f:	89 c2                	mov    %eax,%edx
  800a81:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a84:	39 d0                	cmp    %edx,%eax
  800a86:	73 07                	jae    800a8f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a88:	38 08                	cmp    %cl,(%eax)
  800a8a:	74 03                	je     800a8f <memfind+0x19>
	for (; s < ends; s++)
  800a8c:	40                   	inc    %eax
  800a8d:	eb f5                	jmp    800a84 <memfind+0xe>
			break;
	return (void *) s;
}
  800a8f:	5d                   	pop    %ebp
  800a90:	c3                   	ret    

00800a91 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a91:	55                   	push   %ebp
  800a92:	89 e5                	mov    %esp,%ebp
  800a94:	57                   	push   %edi
  800a95:	56                   	push   %esi
  800a96:	53                   	push   %ebx
  800a97:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a9a:	eb 01                	jmp    800a9d <strtol+0xc>
		s++;
  800a9c:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a9d:	8a 01                	mov    (%ecx),%al
  800a9f:	3c 20                	cmp    $0x20,%al
  800aa1:	74 f9                	je     800a9c <strtol+0xb>
  800aa3:	3c 09                	cmp    $0x9,%al
  800aa5:	74 f5                	je     800a9c <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800aa7:	3c 2b                	cmp    $0x2b,%al
  800aa9:	74 2b                	je     800ad6 <strtol+0x45>
		s++;
	else if (*s == '-')
  800aab:	3c 2d                	cmp    $0x2d,%al
  800aad:	74 2f                	je     800ade <strtol+0x4d>
	int neg = 0;
  800aaf:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ab4:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800abb:	75 12                	jne    800acf <strtol+0x3e>
  800abd:	80 39 30             	cmpb   $0x30,(%ecx)
  800ac0:	74 24                	je     800ae6 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800ac2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ac6:	75 07                	jne    800acf <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800ac8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800acf:	b8 00 00 00 00       	mov    $0x0,%eax
  800ad4:	eb 4e                	jmp    800b24 <strtol+0x93>
		s++;
  800ad6:	41                   	inc    %ecx
	int neg = 0;
  800ad7:	bf 00 00 00 00       	mov    $0x0,%edi
  800adc:	eb d6                	jmp    800ab4 <strtol+0x23>
		s++, neg = 1;
  800ade:	41                   	inc    %ecx
  800adf:	bf 01 00 00 00       	mov    $0x1,%edi
  800ae4:	eb ce                	jmp    800ab4 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ae6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800aea:	74 10                	je     800afc <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800aec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800af0:	75 dd                	jne    800acf <strtol+0x3e>
		s++, base = 8;
  800af2:	41                   	inc    %ecx
  800af3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800afa:	eb d3                	jmp    800acf <strtol+0x3e>
		s += 2, base = 16;
  800afc:	83 c1 02             	add    $0x2,%ecx
  800aff:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800b06:	eb c7                	jmp    800acf <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800b08:	8d 72 9f             	lea    -0x61(%edx),%esi
  800b0b:	89 f3                	mov    %esi,%ebx
  800b0d:	80 fb 19             	cmp    $0x19,%bl
  800b10:	77 24                	ja     800b36 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800b12:	0f be d2             	movsbl %dl,%edx
  800b15:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800b18:	3b 55 10             	cmp    0x10(%ebp),%edx
  800b1b:	7d 2b                	jge    800b48 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800b1d:	41                   	inc    %ecx
  800b1e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800b22:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b24:	8a 11                	mov    (%ecx),%dl
  800b26:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b29:	80 fb 09             	cmp    $0x9,%bl
  800b2c:	77 da                	ja     800b08 <strtol+0x77>
			dig = *s - '0';
  800b2e:	0f be d2             	movsbl %dl,%edx
  800b31:	83 ea 30             	sub    $0x30,%edx
  800b34:	eb e2                	jmp    800b18 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b36:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b39:	89 f3                	mov    %esi,%ebx
  800b3b:	80 fb 19             	cmp    $0x19,%bl
  800b3e:	77 08                	ja     800b48 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b40:	0f be d2             	movsbl %dl,%edx
  800b43:	83 ea 37             	sub    $0x37,%edx
  800b46:	eb d0                	jmp    800b18 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b48:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b4c:	74 05                	je     800b53 <strtol+0xc2>
		*endptr = (char *) s;
  800b4e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b51:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b53:	85 ff                	test   %edi,%edi
  800b55:	74 02                	je     800b59 <strtol+0xc8>
  800b57:	f7 d8                	neg    %eax
}
  800b59:	5b                   	pop    %ebx
  800b5a:	5e                   	pop    %esi
  800b5b:	5f                   	pop    %edi
  800b5c:	5d                   	pop    %ebp
  800b5d:	c3                   	ret    

00800b5e <atoi>:

int
atoi(const char *s)
{
  800b5e:	55                   	push   %ebp
  800b5f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b61:	6a 0a                	push   $0xa
  800b63:	6a 00                	push   $0x0
  800b65:	ff 75 08             	pushl  0x8(%ebp)
  800b68:	e8 24 ff ff ff       	call   800a91 <strtol>
}
  800b6d:	c9                   	leave  
  800b6e:	c3                   	ret    

00800b6f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	57                   	push   %edi
  800b73:	56                   	push   %esi
  800b74:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b75:	b8 00 00 00 00       	mov    $0x0,%eax
  800b7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	89 c3                	mov    %eax,%ebx
  800b82:	89 c7                	mov    %eax,%edi
  800b84:	89 c6                	mov    %eax,%esi
  800b86:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5f                   	pop    %edi
  800b8b:	5d                   	pop    %ebp
  800b8c:	c3                   	ret    

00800b8d <sys_cgetc>:

int
sys_cgetc(void)
{
  800b8d:	55                   	push   %ebp
  800b8e:	89 e5                	mov    %esp,%ebp
  800b90:	57                   	push   %edi
  800b91:	56                   	push   %esi
  800b92:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b93:	ba 00 00 00 00       	mov    $0x0,%edx
  800b98:	b8 01 00 00 00       	mov    $0x1,%eax
  800b9d:	89 d1                	mov    %edx,%ecx
  800b9f:	89 d3                	mov    %edx,%ebx
  800ba1:	89 d7                	mov    %edx,%edi
  800ba3:	89 d6                	mov    %edx,%esi
  800ba5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ba7:	5b                   	pop    %ebx
  800ba8:	5e                   	pop    %esi
  800ba9:	5f                   	pop    %edi
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	57                   	push   %edi
  800bb0:	56                   	push   %esi
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb5:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bba:	b8 03 00 00 00       	mov    $0x3,%eax
  800bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc2:	89 cb                	mov    %ecx,%ebx
  800bc4:	89 cf                	mov    %ecx,%edi
  800bc6:	89 ce                	mov    %ecx,%esi
  800bc8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bca:	85 c0                	test   %eax,%eax
  800bcc:	7f 08                	jg     800bd6 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800bce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bd6:	83 ec 0c             	sub    $0xc,%esp
  800bd9:	50                   	push   %eax
  800bda:	6a 03                	push   $0x3
  800bdc:	68 7f 23 80 00       	push   $0x80237f
  800be1:	6a 23                	push   $0x23
  800be3:	68 9c 23 80 00       	push   $0x80239c
  800be8:	e8 4f f5 ff ff       	call   80013c <_panic>

00800bed <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bed:	55                   	push   %ebp
  800bee:	89 e5                	mov    %esp,%ebp
  800bf0:	57                   	push   %edi
  800bf1:	56                   	push   %esi
  800bf2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bf3:	ba 00 00 00 00       	mov    $0x0,%edx
  800bf8:	b8 02 00 00 00       	mov    $0x2,%eax
  800bfd:	89 d1                	mov    %edx,%ecx
  800bff:	89 d3                	mov    %edx,%ebx
  800c01:	89 d7                	mov    %edx,%edi
  800c03:	89 d6                	mov    %edx,%esi
  800c05:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800c07:	5b                   	pop    %ebx
  800c08:	5e                   	pop    %esi
  800c09:	5f                   	pop    %edi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    

00800c0c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800c0c:	55                   	push   %ebp
  800c0d:	89 e5                	mov    %esp,%ebp
  800c0f:	57                   	push   %edi
  800c10:	56                   	push   %esi
  800c11:	53                   	push   %ebx
  800c12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c15:	be 00 00 00 00       	mov    $0x0,%esi
  800c1a:	b8 04 00 00 00       	mov    $0x4,%eax
  800c1f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c22:	8b 55 08             	mov    0x8(%ebp),%edx
  800c25:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c28:	89 f7                	mov    %esi,%edi
  800c2a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c2c:	85 c0                	test   %eax,%eax
  800c2e:	7f 08                	jg     800c38 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c30:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c33:	5b                   	pop    %ebx
  800c34:	5e                   	pop    %esi
  800c35:	5f                   	pop    %edi
  800c36:	5d                   	pop    %ebp
  800c37:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c38:	83 ec 0c             	sub    $0xc,%esp
  800c3b:	50                   	push   %eax
  800c3c:	6a 04                	push   $0x4
  800c3e:	68 7f 23 80 00       	push   $0x80237f
  800c43:	6a 23                	push   $0x23
  800c45:	68 9c 23 80 00       	push   $0x80239c
  800c4a:	e8 ed f4 ff ff       	call   80013c <_panic>

00800c4f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	57                   	push   %edi
  800c53:	56                   	push   %esi
  800c54:	53                   	push   %ebx
  800c55:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c58:	b8 05 00 00 00       	mov    $0x5,%eax
  800c5d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c60:	8b 55 08             	mov    0x8(%ebp),%edx
  800c63:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c66:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c69:	8b 75 18             	mov    0x18(%ebp),%esi
  800c6c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c6e:	85 c0                	test   %eax,%eax
  800c70:	7f 08                	jg     800c7a <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5f                   	pop    %edi
  800c78:	5d                   	pop    %ebp
  800c79:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7a:	83 ec 0c             	sub    $0xc,%esp
  800c7d:	50                   	push   %eax
  800c7e:	6a 05                	push   $0x5
  800c80:	68 7f 23 80 00       	push   $0x80237f
  800c85:	6a 23                	push   $0x23
  800c87:	68 9c 23 80 00       	push   $0x80239c
  800c8c:	e8 ab f4 ff ff       	call   80013c <_panic>

00800c91 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	57                   	push   %edi
  800c95:	56                   	push   %esi
  800c96:	53                   	push   %ebx
  800c97:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c9f:	b8 06 00 00 00       	mov    $0x6,%eax
  800ca4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	89 df                	mov    %ebx,%edi
  800cac:	89 de                	mov    %ebx,%esi
  800cae:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb0:	85 c0                	test   %eax,%eax
  800cb2:	7f 08                	jg     800cbc <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800cb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb7:	5b                   	pop    %ebx
  800cb8:	5e                   	pop    %esi
  800cb9:	5f                   	pop    %edi
  800cba:	5d                   	pop    %ebp
  800cbb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbc:	83 ec 0c             	sub    $0xc,%esp
  800cbf:	50                   	push   %eax
  800cc0:	6a 06                	push   $0x6
  800cc2:	68 7f 23 80 00       	push   $0x80237f
  800cc7:	6a 23                	push   $0x23
  800cc9:	68 9c 23 80 00       	push   $0x80239c
  800cce:	e8 69 f4 ff ff       	call   80013c <_panic>

00800cd3 <sys_yield>:

void
sys_yield(void)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	57                   	push   %edi
  800cd7:	56                   	push   %esi
  800cd8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cd9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cde:	b8 0b 00 00 00       	mov    $0xb,%eax
  800ce3:	89 d1                	mov    %edx,%ecx
  800ce5:	89 d3                	mov    %edx,%ebx
  800ce7:	89 d7                	mov    %edx,%edi
  800ce9:	89 d6                	mov    %edx,%esi
  800ceb:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800ced:	5b                   	pop    %ebx
  800cee:	5e                   	pop    %esi
  800cef:	5f                   	pop    %edi
  800cf0:	5d                   	pop    %ebp
  800cf1:	c3                   	ret    

00800cf2 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
  800cf8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cfb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d00:	b8 08 00 00 00       	mov    $0x8,%eax
  800d05:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d08:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0b:	89 df                	mov    %ebx,%edi
  800d0d:	89 de                	mov    %ebx,%esi
  800d0f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d11:	85 c0                	test   %eax,%eax
  800d13:	7f 08                	jg     800d1d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800d15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d18:	5b                   	pop    %ebx
  800d19:	5e                   	pop    %esi
  800d1a:	5f                   	pop    %edi
  800d1b:	5d                   	pop    %ebp
  800d1c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d1d:	83 ec 0c             	sub    $0xc,%esp
  800d20:	50                   	push   %eax
  800d21:	6a 08                	push   $0x8
  800d23:	68 7f 23 80 00       	push   $0x80237f
  800d28:	6a 23                	push   $0x23
  800d2a:	68 9c 23 80 00       	push   $0x80239c
  800d2f:	e8 08 f4 ff ff       	call   80013c <_panic>

00800d34 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d3d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d42:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d47:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4a:	89 cb                	mov    %ecx,%ebx
  800d4c:	89 cf                	mov    %ecx,%edi
  800d4e:	89 ce                	mov    %ecx,%esi
  800d50:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d52:	85 c0                	test   %eax,%eax
  800d54:	7f 08                	jg     800d5e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d59:	5b                   	pop    %ebx
  800d5a:	5e                   	pop    %esi
  800d5b:	5f                   	pop    %edi
  800d5c:	5d                   	pop    %ebp
  800d5d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d5e:	83 ec 0c             	sub    $0xc,%esp
  800d61:	50                   	push   %eax
  800d62:	6a 0c                	push   $0xc
  800d64:	68 7f 23 80 00       	push   $0x80237f
  800d69:	6a 23                	push   $0x23
  800d6b:	68 9c 23 80 00       	push   $0x80239c
  800d70:	e8 c7 f3 ff ff       	call   80013c <_panic>

00800d75 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	57                   	push   %edi
  800d79:	56                   	push   %esi
  800d7a:	53                   	push   %ebx
  800d7b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d83:	b8 09 00 00 00       	mov    $0x9,%eax
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	89 df                	mov    %ebx,%edi
  800d90:	89 de                	mov    %ebx,%esi
  800d92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d94:	85 c0                	test   %eax,%eax
  800d96:	7f 08                	jg     800da0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d9b:	5b                   	pop    %ebx
  800d9c:	5e                   	pop    %esi
  800d9d:	5f                   	pop    %edi
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da0:	83 ec 0c             	sub    $0xc,%esp
  800da3:	50                   	push   %eax
  800da4:	6a 09                	push   $0x9
  800da6:	68 7f 23 80 00       	push   $0x80237f
  800dab:	6a 23                	push   $0x23
  800dad:	68 9c 23 80 00       	push   $0x80239c
  800db2:	e8 85 f3 ff ff       	call   80013c <_panic>

00800db7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800db7:	55                   	push   %ebp
  800db8:	89 e5                	mov    %esp,%ebp
  800dba:	57                   	push   %edi
  800dbb:	56                   	push   %esi
  800dbc:	53                   	push   %ebx
  800dbd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dc0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc5:	b8 0a 00 00 00       	mov    $0xa,%eax
  800dca:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dcd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd0:	89 df                	mov    %ebx,%edi
  800dd2:	89 de                	mov    %ebx,%esi
  800dd4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dd6:	85 c0                	test   %eax,%eax
  800dd8:	7f 08                	jg     800de2 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800dda:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ddd:	5b                   	pop    %ebx
  800dde:	5e                   	pop    %esi
  800ddf:	5f                   	pop    %edi
  800de0:	5d                   	pop    %ebp
  800de1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800de2:	83 ec 0c             	sub    $0xc,%esp
  800de5:	50                   	push   %eax
  800de6:	6a 0a                	push   $0xa
  800de8:	68 7f 23 80 00       	push   $0x80237f
  800ded:	6a 23                	push   $0x23
  800def:	68 9c 23 80 00       	push   $0x80239c
  800df4:	e8 43 f3 ff ff       	call   80013c <_panic>

00800df9 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800df9:	55                   	push   %ebp
  800dfa:	89 e5                	mov    %esp,%ebp
  800dfc:	57                   	push   %edi
  800dfd:	56                   	push   %esi
  800dfe:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dff:	be 00 00 00 00       	mov    $0x0,%esi
  800e04:	b8 0d 00 00 00       	mov    $0xd,%eax
  800e09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e12:	8b 7d 14             	mov    0x14(%ebp),%edi
  800e15:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800e17:	5b                   	pop    %ebx
  800e18:	5e                   	pop    %esi
  800e19:	5f                   	pop    %edi
  800e1a:	5d                   	pop    %ebp
  800e1b:	c3                   	ret    

00800e1c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800e1c:	55                   	push   %ebp
  800e1d:	89 e5                	mov    %esp,%ebp
  800e1f:	57                   	push   %edi
  800e20:	56                   	push   %esi
  800e21:	53                   	push   %ebx
  800e22:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e25:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e2a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e2f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e32:	89 cb                	mov    %ecx,%ebx
  800e34:	89 cf                	mov    %ecx,%edi
  800e36:	89 ce                	mov    %ecx,%esi
  800e38:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e3a:	85 c0                	test   %eax,%eax
  800e3c:	7f 08                	jg     800e46 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e3e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e41:	5b                   	pop    %ebx
  800e42:	5e                   	pop    %esi
  800e43:	5f                   	pop    %edi
  800e44:	5d                   	pop    %ebp
  800e45:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e46:	83 ec 0c             	sub    $0xc,%esp
  800e49:	50                   	push   %eax
  800e4a:	6a 0e                	push   $0xe
  800e4c:	68 7f 23 80 00       	push   $0x80237f
  800e51:	6a 23                	push   $0x23
  800e53:	68 9c 23 80 00       	push   $0x80239c
  800e58:	e8 df f2 ff ff       	call   80013c <_panic>

00800e5d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e5d:	55                   	push   %ebp
  800e5e:	89 e5                	mov    %esp,%ebp
  800e60:	57                   	push   %edi
  800e61:	56                   	push   %esi
  800e62:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e63:	be 00 00 00 00       	mov    $0x0,%esi
  800e68:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e70:	8b 55 08             	mov    0x8(%ebp),%edx
  800e73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e76:	89 f7                	mov    %esi,%edi
  800e78:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e7a:	5b                   	pop    %ebx
  800e7b:	5e                   	pop    %esi
  800e7c:	5f                   	pop    %edi
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	57                   	push   %edi
  800e83:	56                   	push   %esi
  800e84:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e85:	be 00 00 00 00       	mov    $0x0,%esi
  800e8a:	b8 10 00 00 00       	mov    $0x10,%eax
  800e8f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e92:	8b 55 08             	mov    0x8(%ebp),%edx
  800e95:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e98:	89 f7                	mov    %esi,%edi
  800e9a:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    

00800ea1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800ea1:	55                   	push   %ebp
  800ea2:	89 e5                	mov    %esp,%ebp
  800ea4:	57                   	push   %edi
  800ea5:	56                   	push   %esi
  800ea6:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ea7:	b9 00 00 00 00       	mov    $0x0,%ecx
  800eac:	b8 11 00 00 00       	mov    $0x11,%eax
  800eb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800eb4:	89 cb                	mov    %ecx,%ebx
  800eb6:	89 cf                	mov    %ecx,%edi
  800eb8:	89 ce                	mov    %ecx,%esi
  800eba:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800ebc:	5b                   	pop    %ebx
  800ebd:	5e                   	pop    %esi
  800ebe:	5f                   	pop    %edi
  800ebf:	5d                   	pop    %ebp
  800ec0:	c3                   	ret    

00800ec1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	05 00 00 00 30       	add    $0x30000000,%eax
  800ecc:	c1 e8 0c             	shr    $0xc,%eax
}
  800ecf:	5d                   	pop    %ebp
  800ed0:	c3                   	ret    

00800ed1 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed7:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800edc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ee1:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ee6:	5d                   	pop    %ebp
  800ee7:	c3                   	ret    

00800ee8 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800ee8:	55                   	push   %ebp
  800ee9:	89 e5                	mov    %esp,%ebp
  800eeb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eee:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ef3:	89 c2                	mov    %eax,%edx
  800ef5:	c1 ea 16             	shr    $0x16,%edx
  800ef8:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eff:	f6 c2 01             	test   $0x1,%dl
  800f02:	74 2a                	je     800f2e <fd_alloc+0x46>
  800f04:	89 c2                	mov    %eax,%edx
  800f06:	c1 ea 0c             	shr    $0xc,%edx
  800f09:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f10:	f6 c2 01             	test   $0x1,%dl
  800f13:	74 19                	je     800f2e <fd_alloc+0x46>
  800f15:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800f1a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800f1f:	75 d2                	jne    800ef3 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800f21:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800f27:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800f2c:	eb 07                	jmp    800f35 <fd_alloc+0x4d>
			*fd_store = fd;
  800f2e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f30:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    

00800f37 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800f37:	55                   	push   %ebp
  800f38:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800f3a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800f3e:	77 39                	ja     800f79 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	c1 e0 0c             	shl    $0xc,%eax
  800f46:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800f4b:	89 c2                	mov    %eax,%edx
  800f4d:	c1 ea 16             	shr    $0x16,%edx
  800f50:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f57:	f6 c2 01             	test   $0x1,%dl
  800f5a:	74 24                	je     800f80 <fd_lookup+0x49>
  800f5c:	89 c2                	mov    %eax,%edx
  800f5e:	c1 ea 0c             	shr    $0xc,%edx
  800f61:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f68:	f6 c2 01             	test   $0x1,%dl
  800f6b:	74 1a                	je     800f87 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f6d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f70:	89 02                	mov    %eax,(%edx)
	return 0;
  800f72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f77:	5d                   	pop    %ebp
  800f78:	c3                   	ret    
		return -E_INVAL;
  800f79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f7e:	eb f7                	jmp    800f77 <fd_lookup+0x40>
		return -E_INVAL;
  800f80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f85:	eb f0                	jmp    800f77 <fd_lookup+0x40>
  800f87:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f8c:	eb e9                	jmp    800f77 <fd_lookup+0x40>

00800f8e <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	83 ec 08             	sub    $0x8,%esp
  800f94:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f97:	ba 28 24 80 00       	mov    $0x802428,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f9c:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800fa1:	39 08                	cmp    %ecx,(%eax)
  800fa3:	74 33                	je     800fd8 <dev_lookup+0x4a>
  800fa5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800fa8:	8b 02                	mov    (%edx),%eax
  800faa:	85 c0                	test   %eax,%eax
  800fac:	75 f3                	jne    800fa1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800fae:	a1 20 40 c0 00       	mov    0xc04020,%eax
  800fb3:	8b 40 48             	mov    0x48(%eax),%eax
  800fb6:	83 ec 04             	sub    $0x4,%esp
  800fb9:	51                   	push   %ecx
  800fba:	50                   	push   %eax
  800fbb:	68 ac 23 80 00       	push   $0x8023ac
  800fc0:	e8 8a f2 ff ff       	call   80024f <cprintf>
	*dev = 0;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800fd6:	c9                   	leave  
  800fd7:	c3                   	ret    
			*dev = devtab[i];
  800fd8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fdb:	89 01                	mov    %eax,(%ecx)
			return 0;
  800fdd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe2:	eb f2                	jmp    800fd6 <dev_lookup+0x48>

00800fe4 <fd_close>:
{
  800fe4:	55                   	push   %ebp
  800fe5:	89 e5                	mov    %esp,%ebp
  800fe7:	57                   	push   %edi
  800fe8:	56                   	push   %esi
  800fe9:	53                   	push   %ebx
  800fea:	83 ec 1c             	sub    $0x1c,%esp
  800fed:	8b 75 08             	mov    0x8(%ebp),%esi
  800ff0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ff3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800ff6:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff7:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ffd:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801000:	50                   	push   %eax
  801001:	e8 31 ff ff ff       	call   800f37 <fd_lookup>
  801006:	89 c7                	mov    %eax,%edi
  801008:	83 c4 08             	add    $0x8,%esp
  80100b:	85 c0                	test   %eax,%eax
  80100d:	78 05                	js     801014 <fd_close+0x30>
	    || fd != fd2)
  80100f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801012:	74 13                	je     801027 <fd_close+0x43>
		return (must_exist ? r : 0);
  801014:	84 db                	test   %bl,%bl
  801016:	75 05                	jne    80101d <fd_close+0x39>
  801018:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80101d:	89 f8                	mov    %edi,%eax
  80101f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801022:	5b                   	pop    %ebx
  801023:	5e                   	pop    %esi
  801024:	5f                   	pop    %edi
  801025:	5d                   	pop    %ebp
  801026:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801027:	83 ec 08             	sub    $0x8,%esp
  80102a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80102d:	50                   	push   %eax
  80102e:	ff 36                	pushl  (%esi)
  801030:	e8 59 ff ff ff       	call   800f8e <dev_lookup>
  801035:	89 c7                	mov    %eax,%edi
  801037:	83 c4 10             	add    $0x10,%esp
  80103a:	85 c0                	test   %eax,%eax
  80103c:	78 15                	js     801053 <fd_close+0x6f>
		if (dev->dev_close)
  80103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801041:	8b 40 10             	mov    0x10(%eax),%eax
  801044:	85 c0                	test   %eax,%eax
  801046:	74 1b                	je     801063 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801048:	83 ec 0c             	sub    $0xc,%esp
  80104b:	56                   	push   %esi
  80104c:	ff d0                	call   *%eax
  80104e:	89 c7                	mov    %eax,%edi
  801050:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801053:	83 ec 08             	sub    $0x8,%esp
  801056:	56                   	push   %esi
  801057:	6a 00                	push   $0x0
  801059:	e8 33 fc ff ff       	call   800c91 <sys_page_unmap>
	return r;
  80105e:	83 c4 10             	add    $0x10,%esp
  801061:	eb ba                	jmp    80101d <fd_close+0x39>
			r = 0;
  801063:	bf 00 00 00 00       	mov    $0x0,%edi
  801068:	eb e9                	jmp    801053 <fd_close+0x6f>

0080106a <close>:

int
close(int fdnum)
{
  80106a:	55                   	push   %ebp
  80106b:	89 e5                	mov    %esp,%ebp
  80106d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801070:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 bb fe ff ff       	call   800f37 <fd_lookup>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	78 10                	js     801093 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801083:	83 ec 08             	sub    $0x8,%esp
  801086:	6a 01                	push   $0x1
  801088:	ff 75 f4             	pushl  -0xc(%ebp)
  80108b:	e8 54 ff ff ff       	call   800fe4 <fd_close>
  801090:	83 c4 10             	add    $0x10,%esp
}
  801093:	c9                   	leave  
  801094:	c3                   	ret    

00801095 <close_all>:

void
close_all(void)
{
  801095:	55                   	push   %ebp
  801096:	89 e5                	mov    %esp,%ebp
  801098:	53                   	push   %ebx
  801099:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80109c:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8010a1:	83 ec 0c             	sub    $0xc,%esp
  8010a4:	53                   	push   %ebx
  8010a5:	e8 c0 ff ff ff       	call   80106a <close>
	for (i = 0; i < MAXFD; i++)
  8010aa:	43                   	inc    %ebx
  8010ab:	83 c4 10             	add    $0x10,%esp
  8010ae:	83 fb 20             	cmp    $0x20,%ebx
  8010b1:	75 ee                	jne    8010a1 <close_all+0xc>
}
  8010b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    

008010b8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8010b8:	55                   	push   %ebp
  8010b9:	89 e5                	mov    %esp,%ebp
  8010bb:	57                   	push   %edi
  8010bc:	56                   	push   %esi
  8010bd:	53                   	push   %ebx
  8010be:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8010c1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	ff 75 08             	pushl  0x8(%ebp)
  8010c8:	e8 6a fe ff ff       	call   800f37 <fd_lookup>
  8010cd:	89 c3                	mov    %eax,%ebx
  8010cf:	83 c4 08             	add    $0x8,%esp
  8010d2:	85 c0                	test   %eax,%eax
  8010d4:	0f 88 81 00 00 00    	js     80115b <dup+0xa3>
		return r;
	close(newfdnum);
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	ff 75 0c             	pushl  0xc(%ebp)
  8010e0:	e8 85 ff ff ff       	call   80106a <close>

	newfd = INDEX2FD(newfdnum);
  8010e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e8:	c1 e6 0c             	shl    $0xc,%esi
  8010eb:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010f1:	83 c4 04             	add    $0x4,%esp
  8010f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010f7:	e8 d5 fd ff ff       	call   800ed1 <fd2data>
  8010fc:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010fe:	89 34 24             	mov    %esi,(%esp)
  801101:	e8 cb fd ff ff       	call   800ed1 <fd2data>
  801106:	83 c4 10             	add    $0x10,%esp
  801109:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80110b:	89 d8                	mov    %ebx,%eax
  80110d:	c1 e8 16             	shr    $0x16,%eax
  801110:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801117:	a8 01                	test   $0x1,%al
  801119:	74 11                	je     80112c <dup+0x74>
  80111b:	89 d8                	mov    %ebx,%eax
  80111d:	c1 e8 0c             	shr    $0xc,%eax
  801120:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801127:	f6 c2 01             	test   $0x1,%dl
  80112a:	75 39                	jne    801165 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80112c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80112f:	89 d0                	mov    %edx,%eax
  801131:	c1 e8 0c             	shr    $0xc,%eax
  801134:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113b:	83 ec 0c             	sub    $0xc,%esp
  80113e:	25 07 0e 00 00       	and    $0xe07,%eax
  801143:	50                   	push   %eax
  801144:	56                   	push   %esi
  801145:	6a 00                	push   $0x0
  801147:	52                   	push   %edx
  801148:	6a 00                	push   $0x0
  80114a:	e8 00 fb ff ff       	call   800c4f <sys_page_map>
  80114f:	89 c3                	mov    %eax,%ebx
  801151:	83 c4 20             	add    $0x20,%esp
  801154:	85 c0                	test   %eax,%eax
  801156:	78 31                	js     801189 <dup+0xd1>
		goto err;

	return newfdnum;
  801158:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80115b:	89 d8                	mov    %ebx,%eax
  80115d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801160:	5b                   	pop    %ebx
  801161:	5e                   	pop    %esi
  801162:	5f                   	pop    %edi
  801163:	5d                   	pop    %ebp
  801164:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801165:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80116c:	83 ec 0c             	sub    $0xc,%esp
  80116f:	25 07 0e 00 00       	and    $0xe07,%eax
  801174:	50                   	push   %eax
  801175:	57                   	push   %edi
  801176:	6a 00                	push   $0x0
  801178:	53                   	push   %ebx
  801179:	6a 00                	push   $0x0
  80117b:	e8 cf fa ff ff       	call   800c4f <sys_page_map>
  801180:	89 c3                	mov    %eax,%ebx
  801182:	83 c4 20             	add    $0x20,%esp
  801185:	85 c0                	test   %eax,%eax
  801187:	79 a3                	jns    80112c <dup+0x74>
	sys_page_unmap(0, newfd);
  801189:	83 ec 08             	sub    $0x8,%esp
  80118c:	56                   	push   %esi
  80118d:	6a 00                	push   $0x0
  80118f:	e8 fd fa ff ff       	call   800c91 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801194:	83 c4 08             	add    $0x8,%esp
  801197:	57                   	push   %edi
  801198:	6a 00                	push   $0x0
  80119a:	e8 f2 fa ff ff       	call   800c91 <sys_page_unmap>
	return r;
  80119f:	83 c4 10             	add    $0x10,%esp
  8011a2:	eb b7                	jmp    80115b <dup+0xa3>

008011a4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8011a4:	55                   	push   %ebp
  8011a5:	89 e5                	mov    %esp,%ebp
  8011a7:	53                   	push   %ebx
  8011a8:	83 ec 14             	sub    $0x14,%esp
  8011ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8011ae:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011b1:	50                   	push   %eax
  8011b2:	53                   	push   %ebx
  8011b3:	e8 7f fd ff ff       	call   800f37 <fd_lookup>
  8011b8:	83 c4 08             	add    $0x8,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	78 3f                	js     8011fe <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8011bf:	83 ec 08             	sub    $0x8,%esp
  8011c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011c5:	50                   	push   %eax
  8011c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011c9:	ff 30                	pushl  (%eax)
  8011cb:	e8 be fd ff ff       	call   800f8e <dev_lookup>
  8011d0:	83 c4 10             	add    $0x10,%esp
  8011d3:	85 c0                	test   %eax,%eax
  8011d5:	78 27                	js     8011fe <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8011d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011da:	8b 42 08             	mov    0x8(%edx),%eax
  8011dd:	83 e0 03             	and    $0x3,%eax
  8011e0:	83 f8 01             	cmp    $0x1,%eax
  8011e3:	74 1e                	je     801203 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8011e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e8:	8b 40 08             	mov    0x8(%eax),%eax
  8011eb:	85 c0                	test   %eax,%eax
  8011ed:	74 35                	je     801224 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8011ef:	83 ec 04             	sub    $0x4,%esp
  8011f2:	ff 75 10             	pushl  0x10(%ebp)
  8011f5:	ff 75 0c             	pushl  0xc(%ebp)
  8011f8:	52                   	push   %edx
  8011f9:	ff d0                	call   *%eax
  8011fb:	83 c4 10             	add    $0x10,%esp
}
  8011fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801201:	c9                   	leave  
  801202:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801203:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801208:	8b 40 48             	mov    0x48(%eax),%eax
  80120b:	83 ec 04             	sub    $0x4,%esp
  80120e:	53                   	push   %ebx
  80120f:	50                   	push   %eax
  801210:	68 ed 23 80 00       	push   $0x8023ed
  801215:	e8 35 f0 ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  80121a:	83 c4 10             	add    $0x10,%esp
  80121d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801222:	eb da                	jmp    8011fe <read+0x5a>
		return -E_NOT_SUPP;
  801224:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801229:	eb d3                	jmp    8011fe <read+0x5a>

0080122b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80122b:	55                   	push   %ebp
  80122c:	89 e5                	mov    %esp,%ebp
  80122e:	57                   	push   %edi
  80122f:	56                   	push   %esi
  801230:	53                   	push   %ebx
  801231:	83 ec 0c             	sub    $0xc,%esp
  801234:	8b 7d 08             	mov    0x8(%ebp),%edi
  801237:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80123a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80123f:	39 f3                	cmp    %esi,%ebx
  801241:	73 25                	jae    801268 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801243:	83 ec 04             	sub    $0x4,%esp
  801246:	89 f0                	mov    %esi,%eax
  801248:	29 d8                	sub    %ebx,%eax
  80124a:	50                   	push   %eax
  80124b:	89 d8                	mov    %ebx,%eax
  80124d:	03 45 0c             	add    0xc(%ebp),%eax
  801250:	50                   	push   %eax
  801251:	57                   	push   %edi
  801252:	e8 4d ff ff ff       	call   8011a4 <read>
		if (m < 0)
  801257:	83 c4 10             	add    $0x10,%esp
  80125a:	85 c0                	test   %eax,%eax
  80125c:	78 08                	js     801266 <readn+0x3b>
			return m;
		if (m == 0)
  80125e:	85 c0                	test   %eax,%eax
  801260:	74 06                	je     801268 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801262:	01 c3                	add    %eax,%ebx
  801264:	eb d9                	jmp    80123f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801266:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801268:	89 d8                	mov    %ebx,%eax
  80126a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80126d:	5b                   	pop    %ebx
  80126e:	5e                   	pop    %esi
  80126f:	5f                   	pop    %edi
  801270:	5d                   	pop    %ebp
  801271:	c3                   	ret    

00801272 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	53                   	push   %ebx
  801276:	83 ec 14             	sub    $0x14,%esp
  801279:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80127c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80127f:	50                   	push   %eax
  801280:	53                   	push   %ebx
  801281:	e8 b1 fc ff ff       	call   800f37 <fd_lookup>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 3a                	js     8012c7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80128d:	83 ec 08             	sub    $0x8,%esp
  801290:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801297:	ff 30                	pushl  (%eax)
  801299:	e8 f0 fc ff ff       	call   800f8e <dev_lookup>
  80129e:	83 c4 10             	add    $0x10,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	78 22                	js     8012c7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012a8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ac:	74 1e                	je     8012cc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8012ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012b1:	8b 52 0c             	mov    0xc(%edx),%edx
  8012b4:	85 d2                	test   %edx,%edx
  8012b6:	74 35                	je     8012ed <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8012b8:	83 ec 04             	sub    $0x4,%esp
  8012bb:	ff 75 10             	pushl  0x10(%ebp)
  8012be:	ff 75 0c             	pushl  0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff d2                	call   *%edx
  8012c4:	83 c4 10             	add    $0x10,%esp
}
  8012c7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8012cc:	a1 20 40 c0 00       	mov    0xc04020,%eax
  8012d1:	8b 40 48             	mov    0x48(%eax),%eax
  8012d4:	83 ec 04             	sub    $0x4,%esp
  8012d7:	53                   	push   %ebx
  8012d8:	50                   	push   %eax
  8012d9:	68 09 24 80 00       	push   $0x802409
  8012de:	e8 6c ef ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  8012e3:	83 c4 10             	add    $0x10,%esp
  8012e6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012eb:	eb da                	jmp    8012c7 <write+0x55>
		return -E_NOT_SUPP;
  8012ed:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012f2:	eb d3                	jmp    8012c7 <write+0x55>

008012f4 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012fa:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012fd:	50                   	push   %eax
  8012fe:	ff 75 08             	pushl  0x8(%ebp)
  801301:	e8 31 fc ff ff       	call   800f37 <fd_lookup>
  801306:	83 c4 08             	add    $0x8,%esp
  801309:	85 c0                	test   %eax,%eax
  80130b:	78 0e                	js     80131b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80130d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801310:	8b 55 0c             	mov    0xc(%ebp),%edx
  801313:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801316:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80131b:	c9                   	leave  
  80131c:	c3                   	ret    

0080131d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80131d:	55                   	push   %ebp
  80131e:	89 e5                	mov    %esp,%ebp
  801320:	53                   	push   %ebx
  801321:	83 ec 14             	sub    $0x14,%esp
  801324:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801327:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80132a:	50                   	push   %eax
  80132b:	53                   	push   %ebx
  80132c:	e8 06 fc ff ff       	call   800f37 <fd_lookup>
  801331:	83 c4 08             	add    $0x8,%esp
  801334:	85 c0                	test   %eax,%eax
  801336:	78 37                	js     80136f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801338:	83 ec 08             	sub    $0x8,%esp
  80133b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801342:	ff 30                	pushl  (%eax)
  801344:	e8 45 fc ff ff       	call   800f8e <dev_lookup>
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 1f                	js     80136f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801353:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801357:	74 1b                	je     801374 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801359:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80135c:	8b 52 18             	mov    0x18(%edx),%edx
  80135f:	85 d2                	test   %edx,%edx
  801361:	74 32                	je     801395 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801363:	83 ec 08             	sub    $0x8,%esp
  801366:	ff 75 0c             	pushl  0xc(%ebp)
  801369:	50                   	push   %eax
  80136a:	ff d2                	call   *%edx
  80136c:	83 c4 10             	add    $0x10,%esp
}
  80136f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801372:	c9                   	leave  
  801373:	c3                   	ret    
			thisenv->env_id, fdnum);
  801374:	a1 20 40 c0 00       	mov    0xc04020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801379:	8b 40 48             	mov    0x48(%eax),%eax
  80137c:	83 ec 04             	sub    $0x4,%esp
  80137f:	53                   	push   %ebx
  801380:	50                   	push   %eax
  801381:	68 cc 23 80 00       	push   $0x8023cc
  801386:	e8 c4 ee ff ff       	call   80024f <cprintf>
		return -E_INVAL;
  80138b:	83 c4 10             	add    $0x10,%esp
  80138e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801393:	eb da                	jmp    80136f <ftruncate+0x52>
		return -E_NOT_SUPP;
  801395:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139a:	eb d3                	jmp    80136f <ftruncate+0x52>

0080139c <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80139c:	55                   	push   %ebp
  80139d:	89 e5                	mov    %esp,%ebp
  80139f:	53                   	push   %ebx
  8013a0:	83 ec 14             	sub    $0x14,%esp
  8013a3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013a6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013a9:	50                   	push   %eax
  8013aa:	ff 75 08             	pushl  0x8(%ebp)
  8013ad:	e8 85 fb ff ff       	call   800f37 <fd_lookup>
  8013b2:	83 c4 08             	add    $0x8,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 4b                	js     801404 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013b9:	83 ec 08             	sub    $0x8,%esp
  8013bc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013bf:	50                   	push   %eax
  8013c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013c3:	ff 30                	pushl  (%eax)
  8013c5:	e8 c4 fb ff ff       	call   800f8e <dev_lookup>
  8013ca:	83 c4 10             	add    $0x10,%esp
  8013cd:	85 c0                	test   %eax,%eax
  8013cf:	78 33                	js     801404 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8013d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d4:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8013d8:	74 2f                	je     801409 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8013da:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8013dd:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8013e4:	00 00 00 
	stat->st_type = 0;
  8013e7:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8013ee:	00 00 00 
	stat->st_dev = dev;
  8013f1:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013f7:	83 ec 08             	sub    $0x8,%esp
  8013fa:	53                   	push   %ebx
  8013fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8013fe:	ff 50 14             	call   *0x14(%eax)
  801401:	83 c4 10             	add    $0x10,%esp
}
  801404:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801407:	c9                   	leave  
  801408:	c3                   	ret    
		return -E_NOT_SUPP;
  801409:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140e:	eb f4                	jmp    801404 <fstat+0x68>

00801410 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	56                   	push   %esi
  801414:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801415:	83 ec 08             	sub    $0x8,%esp
  801418:	6a 00                	push   $0x0
  80141a:	ff 75 08             	pushl  0x8(%ebp)
  80141d:	e8 34 02 00 00       	call   801656 <open>
  801422:	89 c3                	mov    %eax,%ebx
  801424:	83 c4 10             	add    $0x10,%esp
  801427:	85 c0                	test   %eax,%eax
  801429:	78 1b                	js     801446 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80142b:	83 ec 08             	sub    $0x8,%esp
  80142e:	ff 75 0c             	pushl  0xc(%ebp)
  801431:	50                   	push   %eax
  801432:	e8 65 ff ff ff       	call   80139c <fstat>
  801437:	89 c6                	mov    %eax,%esi
	close(fd);
  801439:	89 1c 24             	mov    %ebx,(%esp)
  80143c:	e8 29 fc ff ff       	call   80106a <close>
	return r;
  801441:	83 c4 10             	add    $0x10,%esp
  801444:	89 f3                	mov    %esi,%ebx
}
  801446:	89 d8                	mov    %ebx,%eax
  801448:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80144b:	5b                   	pop    %ebx
  80144c:	5e                   	pop    %esi
  80144d:	5d                   	pop    %ebp
  80144e:	c3                   	ret    

0080144f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80144f:	55                   	push   %ebp
  801450:	89 e5                	mov    %esp,%ebp
  801452:	56                   	push   %esi
  801453:	53                   	push   %ebx
  801454:	89 c6                	mov    %eax,%esi
  801456:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801458:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80145f:	74 27                	je     801488 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801461:	6a 07                	push   $0x7
  801463:	68 00 50 c0 00       	push   $0xc05000
  801468:	56                   	push   %esi
  801469:	ff 35 00 40 80 00    	pushl  0x804000
  80146f:	e8 e1 07 00 00       	call   801c55 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801474:	83 c4 0c             	add    $0xc,%esp
  801477:	6a 00                	push   $0x0
  801479:	53                   	push   %ebx
  80147a:	6a 00                	push   $0x0
  80147c:	e8 4b 07 00 00       	call   801bcc <ipc_recv>
}
  801481:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801484:	5b                   	pop    %ebx
  801485:	5e                   	pop    %esi
  801486:	5d                   	pop    %ebp
  801487:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801488:	83 ec 0c             	sub    $0xc,%esp
  80148b:	6a 01                	push   $0x1
  80148d:	e8 1f 08 00 00       	call   801cb1 <ipc_find_env>
  801492:	a3 00 40 80 00       	mov    %eax,0x804000
  801497:	83 c4 10             	add    $0x10,%esp
  80149a:	eb c5                	jmp    801461 <fsipc+0x12>

0080149c <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80149c:	55                   	push   %ebp
  80149d:	89 e5                	mov    %esp,%ebp
  80149f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.set_size.req_size = newsize;
  8014ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b0:	a3 04 50 c0 00       	mov    %eax,0xc05004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8014b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ba:	b8 02 00 00 00       	mov    $0x2,%eax
  8014bf:	e8 8b ff ff ff       	call   80144f <fsipc>
}
  8014c4:	c9                   	leave  
  8014c5:	c3                   	ret    

008014c6 <devfile_flush>:
{
  8014c6:	55                   	push   %ebp
  8014c7:	89 e5                	mov    %esp,%ebp
  8014c9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8014cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8014d2:	a3 00 50 c0 00       	mov    %eax,0xc05000
	return fsipc(FSREQ_FLUSH, NULL);
  8014d7:	ba 00 00 00 00       	mov    $0x0,%edx
  8014dc:	b8 06 00 00 00       	mov    $0x6,%eax
  8014e1:	e8 69 ff ff ff       	call   80144f <fsipc>
}
  8014e6:	c9                   	leave  
  8014e7:	c3                   	ret    

008014e8 <devfile_stat>:
{
  8014e8:	55                   	push   %ebp
  8014e9:	89 e5                	mov    %esp,%ebp
  8014eb:	53                   	push   %ebx
  8014ec:	83 ec 04             	sub    $0x4,%esp
  8014ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8014f8:	a3 00 50 c0 00       	mov    %eax,0xc05000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801502:	b8 05 00 00 00       	mov    $0x5,%eax
  801507:	e8 43 ff ff ff       	call   80144f <fsipc>
  80150c:	85 c0                	test   %eax,%eax
  80150e:	78 2c                	js     80153c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801510:	83 ec 08             	sub    $0x8,%esp
  801513:	68 00 50 c0 00       	push   $0xc05000
  801518:	53                   	push   %ebx
  801519:	e8 39 f3 ff ff       	call   800857 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  80151e:	a1 80 50 c0 00       	mov    0xc05080,%eax
  801523:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801529:	a1 84 50 c0 00       	mov    0xc05084,%eax
  80152e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801534:	83 c4 10             	add    $0x10,%esp
  801537:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80153c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153f:	c9                   	leave  
  801540:	c3                   	ret    

00801541 <devfile_write>:
{
  801541:	55                   	push   %ebp
  801542:	89 e5                	mov    %esp,%ebp
  801544:	53                   	push   %ebx
  801545:	83 ec 04             	sub    $0x4,%esp
  801548:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80154b:	89 d8                	mov    %ebx,%eax
  80154d:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801553:	76 05                	jbe    80155a <devfile_write+0x19>
  801555:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80155a:	8b 55 08             	mov    0x8(%ebp),%edx
  80155d:	8b 52 0c             	mov    0xc(%edx),%edx
  801560:	89 15 00 50 c0 00    	mov    %edx,0xc05000
	fsipcbuf.write.req_n = size;
  801566:	a3 04 50 c0 00       	mov    %eax,0xc05004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80156b:	83 ec 04             	sub    $0x4,%esp
  80156e:	50                   	push   %eax
  80156f:	ff 75 0c             	pushl  0xc(%ebp)
  801572:	68 08 50 c0 00       	push   $0xc05008
  801577:	e8 4e f4 ff ff       	call   8009ca <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	b8 04 00 00 00       	mov    $0x4,%eax
  801586:	e8 c4 fe ff ff       	call   80144f <fsipc>
  80158b:	83 c4 10             	add    $0x10,%esp
  80158e:	85 c0                	test   %eax,%eax
  801590:	78 0b                	js     80159d <devfile_write+0x5c>
	assert(r <= n);
  801592:	39 c3                	cmp    %eax,%ebx
  801594:	72 0c                	jb     8015a2 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801596:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80159b:	7f 1e                	jg     8015bb <devfile_write+0x7a>
}
  80159d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    
	assert(r <= n);
  8015a2:	68 38 24 80 00       	push   $0x802438
  8015a7:	68 3f 24 80 00       	push   $0x80243f
  8015ac:	68 98 00 00 00       	push   $0x98
  8015b1:	68 54 24 80 00       	push   $0x802454
  8015b6:	e8 81 eb ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  8015bb:	68 5f 24 80 00       	push   $0x80245f
  8015c0:	68 3f 24 80 00       	push   $0x80243f
  8015c5:	68 99 00 00 00       	push   $0x99
  8015ca:	68 54 24 80 00       	push   $0x802454
  8015cf:	e8 68 eb ff ff       	call   80013c <_panic>

008015d4 <devfile_read>:
{
  8015d4:	55                   	push   %ebp
  8015d5:	89 e5                	mov    %esp,%ebp
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
  8015d9:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8015dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8015df:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e2:	a3 00 50 c0 00       	mov    %eax,0xc05000
	fsipcbuf.read.req_n = n;
  8015e7:	89 35 04 50 c0 00    	mov    %esi,0xc05004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8015ed:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f2:	b8 03 00 00 00       	mov    $0x3,%eax
  8015f7:	e8 53 fe ff ff       	call   80144f <fsipc>
  8015fc:	89 c3                	mov    %eax,%ebx
  8015fe:	85 c0                	test   %eax,%eax
  801600:	78 1f                	js     801621 <devfile_read+0x4d>
	assert(r <= n);
  801602:	39 c6                	cmp    %eax,%esi
  801604:	72 24                	jb     80162a <devfile_read+0x56>
	assert(r <= PGSIZE);
  801606:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80160b:	7f 33                	jg     801640 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80160d:	83 ec 04             	sub    $0x4,%esp
  801610:	50                   	push   %eax
  801611:	68 00 50 c0 00       	push   $0xc05000
  801616:	ff 75 0c             	pushl  0xc(%ebp)
  801619:	e8 ac f3 ff ff       	call   8009ca <memmove>
	return r;
  80161e:	83 c4 10             	add    $0x10,%esp
}
  801621:	89 d8                	mov    %ebx,%eax
  801623:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801626:	5b                   	pop    %ebx
  801627:	5e                   	pop    %esi
  801628:	5d                   	pop    %ebp
  801629:	c3                   	ret    
	assert(r <= n);
  80162a:	68 38 24 80 00       	push   $0x802438
  80162f:	68 3f 24 80 00       	push   $0x80243f
  801634:	6a 7c                	push   $0x7c
  801636:	68 54 24 80 00       	push   $0x802454
  80163b:	e8 fc ea ff ff       	call   80013c <_panic>
	assert(r <= PGSIZE);
  801640:	68 5f 24 80 00       	push   $0x80245f
  801645:	68 3f 24 80 00       	push   $0x80243f
  80164a:	6a 7d                	push   $0x7d
  80164c:	68 54 24 80 00       	push   $0x802454
  801651:	e8 e6 ea ff ff       	call   80013c <_panic>

00801656 <open>:
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	56                   	push   %esi
  80165a:	53                   	push   %ebx
  80165b:	83 ec 1c             	sub    $0x1c,%esp
  80165e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801661:	56                   	push   %esi
  801662:	e8 bd f1 ff ff       	call   800824 <strlen>
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80166f:	7f 6c                	jg     8016dd <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801671:	83 ec 0c             	sub    $0xc,%esp
  801674:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801677:	50                   	push   %eax
  801678:	e8 6b f8 ff ff       	call   800ee8 <fd_alloc>
  80167d:	89 c3                	mov    %eax,%ebx
  80167f:	83 c4 10             	add    $0x10,%esp
  801682:	85 c0                	test   %eax,%eax
  801684:	78 3c                	js     8016c2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801686:	83 ec 08             	sub    $0x8,%esp
  801689:	56                   	push   %esi
  80168a:	68 00 50 c0 00       	push   $0xc05000
  80168f:	e8 c3 f1 ff ff       	call   800857 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801694:	8b 45 0c             	mov    0xc(%ebp),%eax
  801697:	a3 00 54 c0 00       	mov    %eax,0xc05400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80169c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80169f:	b8 01 00 00 00       	mov    $0x1,%eax
  8016a4:	e8 a6 fd ff ff       	call   80144f <fsipc>
  8016a9:	89 c3                	mov    %eax,%ebx
  8016ab:	83 c4 10             	add    $0x10,%esp
  8016ae:	85 c0                	test   %eax,%eax
  8016b0:	78 19                	js     8016cb <open+0x75>
	return fd2num(fd);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8016b8:	e8 04 f8 ff ff       	call   800ec1 <fd2num>
  8016bd:	89 c3                	mov    %eax,%ebx
  8016bf:	83 c4 10             	add    $0x10,%esp
}
  8016c2:	89 d8                	mov    %ebx,%eax
  8016c4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016c7:	5b                   	pop    %ebx
  8016c8:	5e                   	pop    %esi
  8016c9:	5d                   	pop    %ebp
  8016ca:	c3                   	ret    
		fd_close(fd, 0);
  8016cb:	83 ec 08             	sub    $0x8,%esp
  8016ce:	6a 00                	push   $0x0
  8016d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d3:	e8 0c f9 ff ff       	call   800fe4 <fd_close>
		return r;
  8016d8:	83 c4 10             	add    $0x10,%esp
  8016db:	eb e5                	jmp    8016c2 <open+0x6c>
		return -E_BAD_PATH;
  8016dd:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8016e2:	eb de                	jmp    8016c2 <open+0x6c>

008016e4 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 08 00 00 00       	mov    $0x8,%eax
  8016f4:	e8 56 fd ff ff       	call   80144f <fsipc>
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	56                   	push   %esi
  8016ff:	53                   	push   %ebx
  801700:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801703:	83 ec 0c             	sub    $0xc,%esp
  801706:	ff 75 08             	pushl  0x8(%ebp)
  801709:	e8 c3 f7 ff ff       	call   800ed1 <fd2data>
  80170e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801710:	83 c4 08             	add    $0x8,%esp
  801713:	68 6b 24 80 00       	push   $0x80246b
  801718:	53                   	push   %ebx
  801719:	e8 39 f1 ff ff       	call   800857 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  80171e:	8b 46 04             	mov    0x4(%esi),%eax
  801721:	2b 06                	sub    (%esi),%eax
  801723:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801729:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801730:	10 00 00 
	stat->st_dev = &devpipe;
  801733:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80173a:	30 80 00 
	return 0;
}
  80173d:	b8 00 00 00 00       	mov    $0x0,%eax
  801742:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801745:	5b                   	pop    %ebx
  801746:	5e                   	pop    %esi
  801747:	5d                   	pop    %ebp
  801748:	c3                   	ret    

00801749 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801749:	55                   	push   %ebp
  80174a:	89 e5                	mov    %esp,%ebp
  80174c:	53                   	push   %ebx
  80174d:	83 ec 0c             	sub    $0xc,%esp
  801750:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801753:	53                   	push   %ebx
  801754:	6a 00                	push   $0x0
  801756:	e8 36 f5 ff ff       	call   800c91 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80175b:	89 1c 24             	mov    %ebx,(%esp)
  80175e:	e8 6e f7 ff ff       	call   800ed1 <fd2data>
  801763:	83 c4 08             	add    $0x8,%esp
  801766:	50                   	push   %eax
  801767:	6a 00                	push   $0x0
  801769:	e8 23 f5 ff ff       	call   800c91 <sys_page_unmap>
}
  80176e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <_pipeisclosed>:
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
  801776:	57                   	push   %edi
  801777:	56                   	push   %esi
  801778:	53                   	push   %ebx
  801779:	83 ec 1c             	sub    $0x1c,%esp
  80177c:	89 c7                	mov    %eax,%edi
  80177e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801780:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801785:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801788:	83 ec 0c             	sub    $0xc,%esp
  80178b:	57                   	push   %edi
  80178c:	e8 62 05 00 00       	call   801cf3 <pageref>
  801791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801794:	89 34 24             	mov    %esi,(%esp)
  801797:	e8 57 05 00 00       	call   801cf3 <pageref>
		nn = thisenv->env_runs;
  80179c:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  8017a2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8017a5:	83 c4 10             	add    $0x10,%esp
  8017a8:	39 cb                	cmp    %ecx,%ebx
  8017aa:	74 1b                	je     8017c7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8017ac:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017af:	75 cf                	jne    801780 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8017b1:	8b 42 58             	mov    0x58(%edx),%eax
  8017b4:	6a 01                	push   $0x1
  8017b6:	50                   	push   %eax
  8017b7:	53                   	push   %ebx
  8017b8:	68 72 24 80 00       	push   $0x802472
  8017bd:	e8 8d ea ff ff       	call   80024f <cprintf>
  8017c2:	83 c4 10             	add    $0x10,%esp
  8017c5:	eb b9                	jmp    801780 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8017c7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8017ca:	0f 94 c0             	sete   %al
  8017cd:	0f b6 c0             	movzbl %al,%eax
}
  8017d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d3:	5b                   	pop    %ebx
  8017d4:	5e                   	pop    %esi
  8017d5:	5f                   	pop    %edi
  8017d6:	5d                   	pop    %ebp
  8017d7:	c3                   	ret    

008017d8 <devpipe_write>:
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	57                   	push   %edi
  8017dc:	56                   	push   %esi
  8017dd:	53                   	push   %ebx
  8017de:	83 ec 18             	sub    $0x18,%esp
  8017e1:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8017e4:	56                   	push   %esi
  8017e5:	e8 e7 f6 ff ff       	call   800ed1 <fd2data>
  8017ea:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8017ec:	83 c4 10             	add    $0x10,%esp
  8017ef:	bf 00 00 00 00       	mov    $0x0,%edi
  8017f4:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8017f7:	74 41                	je     80183a <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8017f9:	8b 53 04             	mov    0x4(%ebx),%edx
  8017fc:	8b 03                	mov    (%ebx),%eax
  8017fe:	83 c0 20             	add    $0x20,%eax
  801801:	39 c2                	cmp    %eax,%edx
  801803:	72 14                	jb     801819 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801805:	89 da                	mov    %ebx,%edx
  801807:	89 f0                	mov    %esi,%eax
  801809:	e8 65 ff ff ff       	call   801773 <_pipeisclosed>
  80180e:	85 c0                	test   %eax,%eax
  801810:	75 2c                	jne    80183e <devpipe_write+0x66>
			sys_yield();
  801812:	e8 bc f4 ff ff       	call   800cd3 <sys_yield>
  801817:	eb e0                	jmp    8017f9 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801819:	8b 45 0c             	mov    0xc(%ebp),%eax
  80181c:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  80181f:	89 d0                	mov    %edx,%eax
  801821:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801826:	78 0b                	js     801833 <devpipe_write+0x5b>
  801828:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  80182c:	42                   	inc    %edx
  80182d:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801830:	47                   	inc    %edi
  801831:	eb c1                	jmp    8017f4 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801833:	48                   	dec    %eax
  801834:	83 c8 e0             	or     $0xffffffe0,%eax
  801837:	40                   	inc    %eax
  801838:	eb ee                	jmp    801828 <devpipe_write+0x50>
	return i;
  80183a:	89 f8                	mov    %edi,%eax
  80183c:	eb 05                	jmp    801843 <devpipe_write+0x6b>
				return 0;
  80183e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801843:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801846:	5b                   	pop    %ebx
  801847:	5e                   	pop    %esi
  801848:	5f                   	pop    %edi
  801849:	5d                   	pop    %ebp
  80184a:	c3                   	ret    

0080184b <devpipe_read>:
{
  80184b:	55                   	push   %ebp
  80184c:	89 e5                	mov    %esp,%ebp
  80184e:	57                   	push   %edi
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 18             	sub    $0x18,%esp
  801854:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801857:	57                   	push   %edi
  801858:	e8 74 f6 ff ff       	call   800ed1 <fd2data>
  80185d:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	bb 00 00 00 00       	mov    $0x0,%ebx
  801867:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80186a:	74 46                	je     8018b2 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  80186c:	8b 06                	mov    (%esi),%eax
  80186e:	3b 46 04             	cmp    0x4(%esi),%eax
  801871:	75 22                	jne    801895 <devpipe_read+0x4a>
			if (i > 0)
  801873:	85 db                	test   %ebx,%ebx
  801875:	74 0a                	je     801881 <devpipe_read+0x36>
				return i;
  801877:	89 d8                	mov    %ebx,%eax
}
  801879:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80187c:	5b                   	pop    %ebx
  80187d:	5e                   	pop    %esi
  80187e:	5f                   	pop    %edi
  80187f:	5d                   	pop    %ebp
  801880:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801881:	89 f2                	mov    %esi,%edx
  801883:	89 f8                	mov    %edi,%eax
  801885:	e8 e9 fe ff ff       	call   801773 <_pipeisclosed>
  80188a:	85 c0                	test   %eax,%eax
  80188c:	75 28                	jne    8018b6 <devpipe_read+0x6b>
			sys_yield();
  80188e:	e8 40 f4 ff ff       	call   800cd3 <sys_yield>
  801893:	eb d7                	jmp    80186c <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801895:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80189a:	78 0f                	js     8018ab <devpipe_read+0x60>
  80189c:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8018a0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a3:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8018a6:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8018a8:	43                   	inc    %ebx
  8018a9:	eb bc                	jmp    801867 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8018ab:	48                   	dec    %eax
  8018ac:	83 c8 e0             	or     $0xffffffe0,%eax
  8018af:	40                   	inc    %eax
  8018b0:	eb ea                	jmp    80189c <devpipe_read+0x51>
	return i;
  8018b2:	89 d8                	mov    %ebx,%eax
  8018b4:	eb c3                	jmp    801879 <devpipe_read+0x2e>
				return 0;
  8018b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8018bb:	eb bc                	jmp    801879 <devpipe_read+0x2e>

008018bd <pipe>:
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	56                   	push   %esi
  8018c1:	53                   	push   %ebx
  8018c2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8018c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018c8:	50                   	push   %eax
  8018c9:	e8 1a f6 ff ff       	call   800ee8 <fd_alloc>
  8018ce:	89 c3                	mov    %eax,%ebx
  8018d0:	83 c4 10             	add    $0x10,%esp
  8018d3:	85 c0                	test   %eax,%eax
  8018d5:	0f 88 2a 01 00 00    	js     801a05 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	68 07 04 00 00       	push   $0x407
  8018e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e6:	6a 00                	push   $0x0
  8018e8:	e8 1f f3 ff ff       	call   800c0c <sys_page_alloc>
  8018ed:	89 c3                	mov    %eax,%ebx
  8018ef:	83 c4 10             	add    $0x10,%esp
  8018f2:	85 c0                	test   %eax,%eax
  8018f4:	0f 88 0b 01 00 00    	js     801a05 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8018fa:	83 ec 0c             	sub    $0xc,%esp
  8018fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801900:	50                   	push   %eax
  801901:	e8 e2 f5 ff ff       	call   800ee8 <fd_alloc>
  801906:	89 c3                	mov    %eax,%ebx
  801908:	83 c4 10             	add    $0x10,%esp
  80190b:	85 c0                	test   %eax,%eax
  80190d:	0f 88 e2 00 00 00    	js     8019f5 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801913:	83 ec 04             	sub    $0x4,%esp
  801916:	68 07 04 00 00       	push   $0x407
  80191b:	ff 75 f0             	pushl  -0x10(%ebp)
  80191e:	6a 00                	push   $0x0
  801920:	e8 e7 f2 ff ff       	call   800c0c <sys_page_alloc>
  801925:	89 c3                	mov    %eax,%ebx
  801927:	83 c4 10             	add    $0x10,%esp
  80192a:	85 c0                	test   %eax,%eax
  80192c:	0f 88 c3 00 00 00    	js     8019f5 <pipe+0x138>
	va = fd2data(fd0);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	ff 75 f4             	pushl  -0xc(%ebp)
  801938:	e8 94 f5 ff ff       	call   800ed1 <fd2data>
  80193d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80193f:	83 c4 0c             	add    $0xc,%esp
  801942:	68 07 04 00 00       	push   $0x407
  801947:	50                   	push   %eax
  801948:	6a 00                	push   $0x0
  80194a:	e8 bd f2 ff ff       	call   800c0c <sys_page_alloc>
  80194f:	89 c3                	mov    %eax,%ebx
  801951:	83 c4 10             	add    $0x10,%esp
  801954:	85 c0                	test   %eax,%eax
  801956:	0f 88 89 00 00 00    	js     8019e5 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80195c:	83 ec 0c             	sub    $0xc,%esp
  80195f:	ff 75 f0             	pushl  -0x10(%ebp)
  801962:	e8 6a f5 ff ff       	call   800ed1 <fd2data>
  801967:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  80196e:	50                   	push   %eax
  80196f:	6a 00                	push   $0x0
  801971:	56                   	push   %esi
  801972:	6a 00                	push   $0x0
  801974:	e8 d6 f2 ff ff       	call   800c4f <sys_page_map>
  801979:	89 c3                	mov    %eax,%ebx
  80197b:	83 c4 20             	add    $0x20,%esp
  80197e:	85 c0                	test   %eax,%eax
  801980:	78 55                	js     8019d7 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801982:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80198b:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80198d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801990:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801997:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80199d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8019a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8019ac:	83 ec 0c             	sub    $0xc,%esp
  8019af:	ff 75 f4             	pushl  -0xc(%ebp)
  8019b2:	e8 0a f5 ff ff       	call   800ec1 <fd2num>
  8019b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ba:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8019bc:	83 c4 04             	add    $0x4,%esp
  8019bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8019c2:	e8 fa f4 ff ff       	call   800ec1 <fd2num>
  8019c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019ca:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8019cd:	83 c4 10             	add    $0x10,%esp
  8019d0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019d5:	eb 2e                	jmp    801a05 <pipe+0x148>
	sys_page_unmap(0, va);
  8019d7:	83 ec 08             	sub    $0x8,%esp
  8019da:	56                   	push   %esi
  8019db:	6a 00                	push   $0x0
  8019dd:	e8 af f2 ff ff       	call   800c91 <sys_page_unmap>
  8019e2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8019e5:	83 ec 08             	sub    $0x8,%esp
  8019e8:	ff 75 f0             	pushl  -0x10(%ebp)
  8019eb:	6a 00                	push   $0x0
  8019ed:	e8 9f f2 ff ff       	call   800c91 <sys_page_unmap>
  8019f2:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8019f5:	83 ec 08             	sub    $0x8,%esp
  8019f8:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fb:	6a 00                	push   $0x0
  8019fd:	e8 8f f2 ff ff       	call   800c91 <sys_page_unmap>
  801a02:	83 c4 10             	add    $0x10,%esp
}
  801a05:	89 d8                	mov    %ebx,%eax
  801a07:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a0a:	5b                   	pop    %ebx
  801a0b:	5e                   	pop    %esi
  801a0c:	5d                   	pop    %ebp
  801a0d:	c3                   	ret    

00801a0e <pipeisclosed>:
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
  801a11:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a14:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a17:	50                   	push   %eax
  801a18:	ff 75 08             	pushl  0x8(%ebp)
  801a1b:	e8 17 f5 ff ff       	call   800f37 <fd_lookup>
  801a20:	83 c4 10             	add    $0x10,%esp
  801a23:	85 c0                	test   %eax,%eax
  801a25:	78 18                	js     801a3f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801a27:	83 ec 0c             	sub    $0xc,%esp
  801a2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2d:	e8 9f f4 ff ff       	call   800ed1 <fd2data>
	return _pipeisclosed(fd, p);
  801a32:	89 c2                	mov    %eax,%edx
  801a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a37:	e8 37 fd ff ff       	call   801773 <_pipeisclosed>
  801a3c:	83 c4 10             	add    $0x10,%esp
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801a44:	b8 00 00 00 00       	mov    $0x0,%eax
  801a49:	5d                   	pop    %ebp
  801a4a:	c3                   	ret    

00801a4b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
  801a4e:	53                   	push   %ebx
  801a4f:	83 ec 0c             	sub    $0xc,%esp
  801a52:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801a55:	68 8a 24 80 00       	push   $0x80248a
  801a5a:	53                   	push   %ebx
  801a5b:	e8 f7 ed ff ff       	call   800857 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801a60:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801a67:	20 00 00 
	return 0;
}
  801a6a:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <devcons_write>:
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
  801a77:	57                   	push   %edi
  801a78:	56                   	push   %esi
  801a79:	53                   	push   %ebx
  801a7a:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a80:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a85:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a8b:	eb 1d                	jmp    801aaa <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801a8d:	83 ec 04             	sub    $0x4,%esp
  801a90:	53                   	push   %ebx
  801a91:	03 45 0c             	add    0xc(%ebp),%eax
  801a94:	50                   	push   %eax
  801a95:	57                   	push   %edi
  801a96:	e8 2f ef ff ff       	call   8009ca <memmove>
		sys_cputs(buf, m);
  801a9b:	83 c4 08             	add    $0x8,%esp
  801a9e:	53                   	push   %ebx
  801a9f:	57                   	push   %edi
  801aa0:	e8 ca f0 ff ff       	call   800b6f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801aa5:	01 de                	add    %ebx,%esi
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	89 f0                	mov    %esi,%eax
  801aac:	3b 75 10             	cmp    0x10(%ebp),%esi
  801aaf:	73 11                	jae    801ac2 <devcons_write+0x4e>
		m = n - tot;
  801ab1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801ab4:	29 f3                	sub    %esi,%ebx
  801ab6:	83 fb 7f             	cmp    $0x7f,%ebx
  801ab9:	76 d2                	jbe    801a8d <devcons_write+0x19>
  801abb:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801ac0:	eb cb                	jmp    801a8d <devcons_write+0x19>
}
  801ac2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac5:	5b                   	pop    %ebx
  801ac6:	5e                   	pop    %esi
  801ac7:	5f                   	pop    %edi
  801ac8:	5d                   	pop    %ebp
  801ac9:	c3                   	ret    

00801aca <devcons_read>:
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801ad0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ad4:	75 0c                	jne    801ae2 <devcons_read+0x18>
		return 0;
  801ad6:	b8 00 00 00 00       	mov    $0x0,%eax
  801adb:	eb 21                	jmp    801afe <devcons_read+0x34>
		sys_yield();
  801add:	e8 f1 f1 ff ff       	call   800cd3 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ae2:	e8 a6 f0 ff ff       	call   800b8d <sys_cgetc>
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	74 f2                	je     801add <devcons_read+0x13>
	if (c < 0)
  801aeb:	85 c0                	test   %eax,%eax
  801aed:	78 0f                	js     801afe <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801aef:	83 f8 04             	cmp    $0x4,%eax
  801af2:	74 0c                	je     801b00 <devcons_read+0x36>
	*(char*)vbuf = c;
  801af4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af7:	88 02                	mov    %al,(%edx)
	return 1;
  801af9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801afe:	c9                   	leave  
  801aff:	c3                   	ret    
		return 0;
  801b00:	b8 00 00 00 00       	mov    $0x0,%eax
  801b05:	eb f7                	jmp    801afe <devcons_read+0x34>

00801b07 <cputchar>:
{
  801b07:	55                   	push   %ebp
  801b08:	89 e5                	mov    %esp,%ebp
  801b0a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801b0d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b10:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801b13:	6a 01                	push   $0x1
  801b15:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b18:	50                   	push   %eax
  801b19:	e8 51 f0 ff ff       	call   800b6f <sys_cputs>
}
  801b1e:	83 c4 10             	add    $0x10,%esp
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <getchar>:
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
  801b26:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801b29:	6a 01                	push   $0x1
  801b2b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801b2e:	50                   	push   %eax
  801b2f:	6a 00                	push   $0x0
  801b31:	e8 6e f6 ff ff       	call   8011a4 <read>
	if (r < 0)
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	78 08                	js     801b45 <getchar+0x22>
	if (r < 1)
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	7e 06                	jle    801b47 <getchar+0x24>
	return c;
  801b41:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    
		return -E_EOF;
  801b47:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801b4c:	eb f7                	jmp    801b45 <getchar+0x22>

00801b4e <iscons>:
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801b54:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b57:	50                   	push   %eax
  801b58:	ff 75 08             	pushl  0x8(%ebp)
  801b5b:	e8 d7 f3 ff ff       	call   800f37 <fd_lookup>
  801b60:	83 c4 10             	add    $0x10,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 11                	js     801b78 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b6a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b70:	39 10                	cmp    %edx,(%eax)
  801b72:	0f 94 c0             	sete   %al
  801b75:	0f b6 c0             	movzbl %al,%eax
}
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <opencons>:
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
  801b7d:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b80:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b83:	50                   	push   %eax
  801b84:	e8 5f f3 ff ff       	call   800ee8 <fd_alloc>
  801b89:	83 c4 10             	add    $0x10,%esp
  801b8c:	85 c0                	test   %eax,%eax
  801b8e:	78 3a                	js     801bca <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b90:	83 ec 04             	sub    $0x4,%esp
  801b93:	68 07 04 00 00       	push   $0x407
  801b98:	ff 75 f4             	pushl  -0xc(%ebp)
  801b9b:	6a 00                	push   $0x0
  801b9d:	e8 6a f0 ff ff       	call   800c0c <sys_page_alloc>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	85 c0                	test   %eax,%eax
  801ba7:	78 21                	js     801bca <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ba9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bb7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	50                   	push   %eax
  801bc2:	e8 fa f2 ff ff       	call   800ec1 <fd2num>
  801bc7:	83 c4 10             	add    $0x10,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	57                   	push   %edi
  801bd0:	56                   	push   %esi
  801bd1:	53                   	push   %ebx
  801bd2:	83 ec 0c             	sub    $0xc,%esp
  801bd5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bd8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801bdb:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801bde:	85 ff                	test   %edi,%edi
  801be0:	74 53                	je     801c35 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	57                   	push   %edi
  801be6:	e8 31 f2 ff ff       	call   800e1c <sys_ipc_recv>
  801beb:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801bee:	85 db                	test   %ebx,%ebx
  801bf0:	74 0b                	je     801bfd <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bf2:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801bf8:	8b 52 74             	mov    0x74(%edx),%edx
  801bfb:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801bfd:	85 f6                	test   %esi,%esi
  801bff:	74 0f                	je     801c10 <ipc_recv+0x44>
  801c01:	85 ff                	test   %edi,%edi
  801c03:	74 0b                	je     801c10 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c05:	8b 15 20 40 c0 00    	mov    0xc04020,%edx
  801c0b:	8b 52 78             	mov    0x78(%edx),%edx
  801c0e:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c10:	85 c0                	test   %eax,%eax
  801c12:	74 30                	je     801c44 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c14:	85 db                	test   %ebx,%ebx
  801c16:	74 06                	je     801c1e <ipc_recv+0x52>
      		*from_env_store = 0;
  801c18:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c1e:	85 f6                	test   %esi,%esi
  801c20:	74 2c                	je     801c4e <ipc_recv+0x82>
      		*perm_store = 0;
  801c22:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c28:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c2d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c35:	83 ec 0c             	sub    $0xc,%esp
  801c38:	6a ff                	push   $0xffffffff
  801c3a:	e8 dd f1 ff ff       	call   800e1c <sys_ipc_recv>
  801c3f:	83 c4 10             	add    $0x10,%esp
  801c42:	eb aa                	jmp    801bee <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c44:	a1 20 40 c0 00       	mov    0xc04020,%eax
  801c49:	8b 40 70             	mov    0x70(%eax),%eax
  801c4c:	eb df                	jmp    801c2d <ipc_recv+0x61>
		return -1;
  801c4e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c53:	eb d8                	jmp    801c2d <ipc_recv+0x61>

00801c55 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
  801c58:	57                   	push   %edi
  801c59:	56                   	push   %esi
  801c5a:	53                   	push   %ebx
  801c5b:	83 ec 0c             	sub    $0xc,%esp
  801c5e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c64:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c67:	85 db                	test   %ebx,%ebx
  801c69:	75 22                	jne    801c8d <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c6b:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c70:	eb 1b                	jmp    801c8d <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c72:	68 98 24 80 00       	push   $0x802498
  801c77:	68 3f 24 80 00       	push   $0x80243f
  801c7c:	6a 48                	push   $0x48
  801c7e:	68 bc 24 80 00       	push   $0x8024bc
  801c83:	e8 b4 e4 ff ff       	call   80013c <_panic>
		sys_yield();
  801c88:	e8 46 f0 ff ff       	call   800cd3 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c8d:	57                   	push   %edi
  801c8e:	53                   	push   %ebx
  801c8f:	56                   	push   %esi
  801c90:	ff 75 08             	pushl  0x8(%ebp)
  801c93:	e8 61 f1 ff ff       	call   800df9 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c98:	83 c4 10             	add    $0x10,%esp
  801c9b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c9e:	74 e8                	je     801c88 <ipc_send+0x33>
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	75 ce                	jne    801c72 <ipc_send+0x1d>
		sys_yield();
  801ca4:	e8 2a f0 ff ff       	call   800cd3 <sys_yield>
		
	}
	
}
  801ca9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cac:	5b                   	pop    %ebx
  801cad:	5e                   	pop    %esi
  801cae:	5f                   	pop    %edi
  801caf:	5d                   	pop    %ebp
  801cb0:	c3                   	ret    

00801cb1 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cb1:	55                   	push   %ebp
  801cb2:	89 e5                	mov    %esp,%ebp
  801cb4:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cbc:	89 c2                	mov    %eax,%edx
  801cbe:	c1 e2 05             	shl    $0x5,%edx
  801cc1:	29 c2                	sub    %eax,%edx
  801cc3:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801cca:	8b 52 50             	mov    0x50(%edx),%edx
  801ccd:	39 ca                	cmp    %ecx,%edx
  801ccf:	74 0f                	je     801ce0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801cd1:	40                   	inc    %eax
  801cd2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cd7:	75 e3                	jne    801cbc <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cde:	eb 11                	jmp    801cf1 <ipc_find_env+0x40>
			return envs[i].env_id;
  801ce0:	89 c2                	mov    %eax,%edx
  801ce2:	c1 e2 05             	shl    $0x5,%edx
  801ce5:	29 c2                	sub    %eax,%edx
  801ce7:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801cee:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cf1:	5d                   	pop    %ebp
  801cf2:	c3                   	ret    

00801cf3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	c1 e8 16             	shr    $0x16,%eax
  801cfc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d03:	a8 01                	test   $0x1,%al
  801d05:	74 21                	je     801d28 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d07:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0a:	c1 e8 0c             	shr    $0xc,%eax
  801d0d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d14:	a8 01                	test   $0x1,%al
  801d16:	74 17                	je     801d2f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d18:	c1 e8 0c             	shr    $0xc,%eax
  801d1b:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d22:	ef 
  801d23:	0f b7 c0             	movzwl %ax,%eax
  801d26:	eb 05                	jmp    801d2d <pageref+0x3a>
		return 0;
  801d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d2d:	5d                   	pop    %ebp
  801d2e:	c3                   	ret    
		return 0;
  801d2f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d34:	eb f7                	jmp    801d2d <pageref+0x3a>
  801d36:	66 90                	xchg   %ax,%ax

00801d38 <__udivdi3>:
  801d38:	55                   	push   %ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 1c             	sub    $0x1c,%esp
  801d3f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d43:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d47:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d4b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d4f:	89 ca                	mov    %ecx,%edx
  801d51:	89 f8                	mov    %edi,%eax
  801d53:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d57:	85 f6                	test   %esi,%esi
  801d59:	75 2d                	jne    801d88 <__udivdi3+0x50>
  801d5b:	39 cf                	cmp    %ecx,%edi
  801d5d:	77 65                	ja     801dc4 <__udivdi3+0x8c>
  801d5f:	89 fd                	mov    %edi,%ebp
  801d61:	85 ff                	test   %edi,%edi
  801d63:	75 0b                	jne    801d70 <__udivdi3+0x38>
  801d65:	b8 01 00 00 00       	mov    $0x1,%eax
  801d6a:	31 d2                	xor    %edx,%edx
  801d6c:	f7 f7                	div    %edi
  801d6e:	89 c5                	mov    %eax,%ebp
  801d70:	31 d2                	xor    %edx,%edx
  801d72:	89 c8                	mov    %ecx,%eax
  801d74:	f7 f5                	div    %ebp
  801d76:	89 c1                	mov    %eax,%ecx
  801d78:	89 d8                	mov    %ebx,%eax
  801d7a:	f7 f5                	div    %ebp
  801d7c:	89 cf                	mov    %ecx,%edi
  801d7e:	89 fa                	mov    %edi,%edx
  801d80:	83 c4 1c             	add    $0x1c,%esp
  801d83:	5b                   	pop    %ebx
  801d84:	5e                   	pop    %esi
  801d85:	5f                   	pop    %edi
  801d86:	5d                   	pop    %ebp
  801d87:	c3                   	ret    
  801d88:	39 ce                	cmp    %ecx,%esi
  801d8a:	77 28                	ja     801db4 <__udivdi3+0x7c>
  801d8c:	0f bd fe             	bsr    %esi,%edi
  801d8f:	83 f7 1f             	xor    $0x1f,%edi
  801d92:	75 40                	jne    801dd4 <__udivdi3+0x9c>
  801d94:	39 ce                	cmp    %ecx,%esi
  801d96:	72 0a                	jb     801da2 <__udivdi3+0x6a>
  801d98:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d9c:	0f 87 9e 00 00 00    	ja     801e40 <__udivdi3+0x108>
  801da2:	b8 01 00 00 00       	mov    $0x1,%eax
  801da7:	89 fa                	mov    %edi,%edx
  801da9:	83 c4 1c             	add    $0x1c,%esp
  801dac:	5b                   	pop    %ebx
  801dad:	5e                   	pop    %esi
  801dae:	5f                   	pop    %edi
  801daf:	5d                   	pop    %ebp
  801db0:	c3                   	ret    
  801db1:	8d 76 00             	lea    0x0(%esi),%esi
  801db4:	31 ff                	xor    %edi,%edi
  801db6:	31 c0                	xor    %eax,%eax
  801db8:	89 fa                	mov    %edi,%edx
  801dba:	83 c4 1c             	add    $0x1c,%esp
  801dbd:	5b                   	pop    %ebx
  801dbe:	5e                   	pop    %esi
  801dbf:	5f                   	pop    %edi
  801dc0:	5d                   	pop    %ebp
  801dc1:	c3                   	ret    
  801dc2:	66 90                	xchg   %ax,%ax
  801dc4:	89 d8                	mov    %ebx,%eax
  801dc6:	f7 f7                	div    %edi
  801dc8:	31 ff                	xor    %edi,%edi
  801dca:	89 fa                	mov    %edi,%edx
  801dcc:	83 c4 1c             	add    $0x1c,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5f                   	pop    %edi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    
  801dd4:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dd9:	29 fd                	sub    %edi,%ebp
  801ddb:	89 f9                	mov    %edi,%ecx
  801ddd:	d3 e6                	shl    %cl,%esi
  801ddf:	89 c3                	mov    %eax,%ebx
  801de1:	89 e9                	mov    %ebp,%ecx
  801de3:	d3 eb                	shr    %cl,%ebx
  801de5:	89 d9                	mov    %ebx,%ecx
  801de7:	09 f1                	or     %esi,%ecx
  801de9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ded:	89 f9                	mov    %edi,%ecx
  801def:	d3 e0                	shl    %cl,%eax
  801df1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df5:	89 d6                	mov    %edx,%esi
  801df7:	89 e9                	mov    %ebp,%ecx
  801df9:	d3 ee                	shr    %cl,%esi
  801dfb:	89 f9                	mov    %edi,%ecx
  801dfd:	d3 e2                	shl    %cl,%edx
  801dff:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 eb                	shr    %cl,%ebx
  801e07:	09 da                	or     %ebx,%edx
  801e09:	89 d0                	mov    %edx,%eax
  801e0b:	89 f2                	mov    %esi,%edx
  801e0d:	f7 74 24 08          	divl   0x8(%esp)
  801e11:	89 d6                	mov    %edx,%esi
  801e13:	89 c3                	mov    %eax,%ebx
  801e15:	f7 64 24 0c          	mull   0xc(%esp)
  801e19:	39 d6                	cmp    %edx,%esi
  801e1b:	72 17                	jb     801e34 <__udivdi3+0xfc>
  801e1d:	74 09                	je     801e28 <__udivdi3+0xf0>
  801e1f:	89 d8                	mov    %ebx,%eax
  801e21:	31 ff                	xor    %edi,%edi
  801e23:	e9 56 ff ff ff       	jmp    801d7e <__udivdi3+0x46>
  801e28:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e2c:	89 f9                	mov    %edi,%ecx
  801e2e:	d3 e2                	shl    %cl,%edx
  801e30:	39 c2                	cmp    %eax,%edx
  801e32:	73 eb                	jae    801e1f <__udivdi3+0xe7>
  801e34:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e37:	31 ff                	xor    %edi,%edi
  801e39:	e9 40 ff ff ff       	jmp    801d7e <__udivdi3+0x46>
  801e3e:	66 90                	xchg   %ax,%ax
  801e40:	31 c0                	xor    %eax,%eax
  801e42:	e9 37 ff ff ff       	jmp    801d7e <__udivdi3+0x46>
  801e47:	90                   	nop

00801e48 <__umoddi3>:
  801e48:	55                   	push   %ebp
  801e49:	57                   	push   %edi
  801e4a:	56                   	push   %esi
  801e4b:	53                   	push   %ebx
  801e4c:	83 ec 1c             	sub    $0x1c,%esp
  801e4f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e53:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e57:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e5b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e5f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e63:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e67:	89 3c 24             	mov    %edi,(%esp)
  801e6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e6e:	89 f2                	mov    %esi,%edx
  801e70:	85 c0                	test   %eax,%eax
  801e72:	75 18                	jne    801e8c <__umoddi3+0x44>
  801e74:	39 f7                	cmp    %esi,%edi
  801e76:	0f 86 a0 00 00 00    	jbe    801f1c <__umoddi3+0xd4>
  801e7c:	89 c8                	mov    %ecx,%eax
  801e7e:	f7 f7                	div    %edi
  801e80:	89 d0                	mov    %edx,%eax
  801e82:	31 d2                	xor    %edx,%edx
  801e84:	83 c4 1c             	add    $0x1c,%esp
  801e87:	5b                   	pop    %ebx
  801e88:	5e                   	pop    %esi
  801e89:	5f                   	pop    %edi
  801e8a:	5d                   	pop    %ebp
  801e8b:	c3                   	ret    
  801e8c:	89 f3                	mov    %esi,%ebx
  801e8e:	39 f0                	cmp    %esi,%eax
  801e90:	0f 87 a6 00 00 00    	ja     801f3c <__umoddi3+0xf4>
  801e96:	0f bd e8             	bsr    %eax,%ebp
  801e99:	83 f5 1f             	xor    $0x1f,%ebp
  801e9c:	0f 84 a6 00 00 00    	je     801f48 <__umoddi3+0x100>
  801ea2:	bf 20 00 00 00       	mov    $0x20,%edi
  801ea7:	29 ef                	sub    %ebp,%edi
  801ea9:	89 e9                	mov    %ebp,%ecx
  801eab:	d3 e0                	shl    %cl,%eax
  801ead:	8b 34 24             	mov    (%esp),%esi
  801eb0:	89 f2                	mov    %esi,%edx
  801eb2:	89 f9                	mov    %edi,%ecx
  801eb4:	d3 ea                	shr    %cl,%edx
  801eb6:	09 c2                	or     %eax,%edx
  801eb8:	89 14 24             	mov    %edx,(%esp)
  801ebb:	89 f2                	mov    %esi,%edx
  801ebd:	89 e9                	mov    %ebp,%ecx
  801ebf:	d3 e2                	shl    %cl,%edx
  801ec1:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ec5:	89 de                	mov    %ebx,%esi
  801ec7:	89 f9                	mov    %edi,%ecx
  801ec9:	d3 ee                	shr    %cl,%esi
  801ecb:	89 e9                	mov    %ebp,%ecx
  801ecd:	d3 e3                	shl    %cl,%ebx
  801ecf:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ed3:	89 d0                	mov    %edx,%eax
  801ed5:	89 f9                	mov    %edi,%ecx
  801ed7:	d3 e8                	shr    %cl,%eax
  801ed9:	09 d8                	or     %ebx,%eax
  801edb:	89 d3                	mov    %edx,%ebx
  801edd:	89 e9                	mov    %ebp,%ecx
  801edf:	d3 e3                	shl    %cl,%ebx
  801ee1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ee5:	89 f2                	mov    %esi,%edx
  801ee7:	f7 34 24             	divl   (%esp)
  801eea:	89 d6                	mov    %edx,%esi
  801eec:	f7 64 24 04          	mull   0x4(%esp)
  801ef0:	89 c3                	mov    %eax,%ebx
  801ef2:	89 d1                	mov    %edx,%ecx
  801ef4:	39 d6                	cmp    %edx,%esi
  801ef6:	72 7c                	jb     801f74 <__umoddi3+0x12c>
  801ef8:	74 72                	je     801f6c <__umoddi3+0x124>
  801efa:	8b 54 24 08          	mov    0x8(%esp),%edx
  801efe:	29 da                	sub    %ebx,%edx
  801f00:	19 ce                	sbb    %ecx,%esi
  801f02:	89 f0                	mov    %esi,%eax
  801f04:	89 f9                	mov    %edi,%ecx
  801f06:	d3 e0                	shl    %cl,%eax
  801f08:	89 e9                	mov    %ebp,%ecx
  801f0a:	d3 ea                	shr    %cl,%edx
  801f0c:	09 d0                	or     %edx,%eax
  801f0e:	89 e9                	mov    %ebp,%ecx
  801f10:	d3 ee                	shr    %cl,%esi
  801f12:	89 f2                	mov    %esi,%edx
  801f14:	83 c4 1c             	add    $0x1c,%esp
  801f17:	5b                   	pop    %ebx
  801f18:	5e                   	pop    %esi
  801f19:	5f                   	pop    %edi
  801f1a:	5d                   	pop    %ebp
  801f1b:	c3                   	ret    
  801f1c:	89 fd                	mov    %edi,%ebp
  801f1e:	85 ff                	test   %edi,%edi
  801f20:	75 0b                	jne    801f2d <__umoddi3+0xe5>
  801f22:	b8 01 00 00 00       	mov    $0x1,%eax
  801f27:	31 d2                	xor    %edx,%edx
  801f29:	f7 f7                	div    %edi
  801f2b:	89 c5                	mov    %eax,%ebp
  801f2d:	89 f0                	mov    %esi,%eax
  801f2f:	31 d2                	xor    %edx,%edx
  801f31:	f7 f5                	div    %ebp
  801f33:	89 c8                	mov    %ecx,%eax
  801f35:	f7 f5                	div    %ebp
  801f37:	e9 44 ff ff ff       	jmp    801e80 <__umoddi3+0x38>
  801f3c:	89 c8                	mov    %ecx,%eax
  801f3e:	89 f2                	mov    %esi,%edx
  801f40:	83 c4 1c             	add    $0x1c,%esp
  801f43:	5b                   	pop    %ebx
  801f44:	5e                   	pop    %esi
  801f45:	5f                   	pop    %edi
  801f46:	5d                   	pop    %ebp
  801f47:	c3                   	ret    
  801f48:	39 f0                	cmp    %esi,%eax
  801f4a:	72 05                	jb     801f51 <__umoddi3+0x109>
  801f4c:	39 0c 24             	cmp    %ecx,(%esp)
  801f4f:	77 0c                	ja     801f5d <__umoddi3+0x115>
  801f51:	89 f2                	mov    %esi,%edx
  801f53:	29 f9                	sub    %edi,%ecx
  801f55:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f59:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f5d:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f61:	83 c4 1c             	add    $0x1c,%esp
  801f64:	5b                   	pop    %ebx
  801f65:	5e                   	pop    %esi
  801f66:	5f                   	pop    %edi
  801f67:	5d                   	pop    %ebp
  801f68:	c3                   	ret    
  801f69:	8d 76 00             	lea    0x0(%esi),%esi
  801f6c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f70:	73 88                	jae    801efa <__umoddi3+0xb2>
  801f72:	66 90                	xchg   %ax,%ax
  801f74:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f78:	1b 14 24             	sbb    (%esp),%edx
  801f7b:	89 d1                	mov    %edx,%ecx
  801f7d:	89 c3                	mov    %eax,%ebx
  801f7f:	e9 76 ff ff ff       	jmp    801efa <__umoddi3+0xb2>
