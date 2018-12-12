
obj/user/spin.debug:     file format elf32-i386


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
  80002c:	e8 84 00 00 00       	call   8000b5 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 10             	sub    $0x10,%esp
	envid_t env;

	cprintf("I am the parent.  Forking the child...\n");
  80003a:	68 60 22 80 00       	push   $0x802260
  80003f:	e8 6b 01 00 00       	call   8001af <cprintf>
	if ((env = fork()) == 0) {
  800044:	e8 9c 0e 00 00       	call   800ee5 <fork>
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	85 c0                	test   %eax,%eax
  80004e:	75 12                	jne    800062 <umain+0x2f>
		cprintf("I am the child.  Spinning...\n");
  800050:	83 ec 0c             	sub    $0xc,%esp
  800053:	68 d8 22 80 00       	push   $0x8022d8
  800058:	e8 52 01 00 00       	call   8001af <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp
  800060:	eb fe                	jmp    800060 <umain+0x2d>
  800062:	89 c3                	mov    %eax,%ebx
		while (1)
			/* do nothing */;
	}

	cprintf("I am the parent.  Running the child...\n");
  800064:	83 ec 0c             	sub    $0xc,%esp
  800067:	68 88 22 80 00       	push   $0x802288
  80006c:	e8 3e 01 00 00       	call   8001af <cprintf>
	sys_yield();
  800071:	e8 bd 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  800076:	e8 b8 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  80007b:	e8 b3 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  800080:	e8 ae 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  800085:	e8 a9 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  80008a:	e8 a4 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  80008f:	e8 9f 0b 00 00       	call   800c33 <sys_yield>
	sys_yield();
  800094:	e8 9a 0b 00 00       	call   800c33 <sys_yield>

	cprintf("I am the parent.  Killing the child...\n");
  800099:	c7 04 24 b0 22 80 00 	movl   $0x8022b0,(%esp)
  8000a0:	e8 0a 01 00 00       	call   8001af <cprintf>
	sys_env_destroy(env);
  8000a5:	89 1c 24             	mov    %ebx,(%esp)
  8000a8:	e8 5f 0a 00 00       	call   800b0c <sys_env_destroy>
}
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000b3:	c9                   	leave  
  8000b4:	c3                   	ret    

008000b5 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000b5:	55                   	push   %ebp
  8000b6:	89 e5                	mov    %esp,%ebp
  8000b8:	56                   	push   %esi
  8000b9:	53                   	push   %ebx
  8000ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000bd:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000c0:	e8 88 0a 00 00       	call   800b4d <sys_getenvid>
  8000c5:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000ca:	89 c2                	mov    %eax,%edx
  8000cc:	c1 e2 05             	shl    $0x5,%edx
  8000cf:	29 c2                	sub    %eax,%edx
  8000d1:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000d8:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000dd:	85 db                	test   %ebx,%ebx
  8000df:	7e 07                	jle    8000e8 <libmain+0x33>
		binaryname = argv[0];
  8000e1:	8b 06                	mov    (%esi),%eax
  8000e3:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000e8:	83 ec 08             	sub    $0x8,%esp
  8000eb:	56                   	push   %esi
  8000ec:	53                   	push   %ebx
  8000ed:	e8 41 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000f2:	e8 0a 00 00 00       	call   800101 <exit>
}
  8000f7:	83 c4 10             	add    $0x10,%esp
  8000fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000fd:	5b                   	pop    %ebx
  8000fe:	5e                   	pop    %esi
  8000ff:	5d                   	pop    %ebp
  800100:	c3                   	ret    

00800101 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800101:	55                   	push   %ebp
  800102:	89 e5                	mov    %esp,%ebp
  800104:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800107:	e8 6e 11 00 00       	call   80127a <close_all>
	sys_env_destroy(0);
  80010c:	83 ec 0c             	sub    $0xc,%esp
  80010f:	6a 00                	push   $0x0
  800111:	e8 f6 09 00 00       	call   800b0c <sys_env_destroy>
}
  800116:	83 c4 10             	add    $0x10,%esp
  800119:	c9                   	leave  
  80011a:	c3                   	ret    

0080011b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	53                   	push   %ebx
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800125:	8b 13                	mov    (%ebx),%edx
  800127:	8d 42 01             	lea    0x1(%edx),%eax
  80012a:	89 03                	mov    %eax,(%ebx)
  80012c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80012f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800133:	3d ff 00 00 00       	cmp    $0xff,%eax
  800138:	74 08                	je     800142 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80013a:	ff 43 04             	incl   0x4(%ebx)
}
  80013d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800140:	c9                   	leave  
  800141:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800142:	83 ec 08             	sub    $0x8,%esp
  800145:	68 ff 00 00 00       	push   $0xff
  80014a:	8d 43 08             	lea    0x8(%ebx),%eax
  80014d:	50                   	push   %eax
  80014e:	e8 7c 09 00 00       	call   800acf <sys_cputs>
		b->idx = 0;
  800153:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	eb dc                	jmp    80013a <putch+0x1f>

0080015e <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80015e:	55                   	push   %ebp
  80015f:	89 e5                	mov    %esp,%ebp
  800161:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800167:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80016e:	00 00 00 
	b.cnt = 0;
  800171:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800178:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80017b:	ff 75 0c             	pushl  0xc(%ebp)
  80017e:	ff 75 08             	pushl  0x8(%ebp)
  800181:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800187:	50                   	push   %eax
  800188:	68 1b 01 80 00       	push   $0x80011b
  80018d:	e8 17 01 00 00       	call   8002a9 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800192:	83 c4 08             	add    $0x8,%esp
  800195:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80019b:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001a1:	50                   	push   %eax
  8001a2:	e8 28 09 00 00       	call   800acf <sys_cputs>

	return b.cnt;
}
  8001a7:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001ad:	c9                   	leave  
  8001ae:	c3                   	ret    

008001af <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001af:	55                   	push   %ebp
  8001b0:	89 e5                	mov    %esp,%ebp
  8001b2:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001b5:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001b8:	50                   	push   %eax
  8001b9:	ff 75 08             	pushl  0x8(%ebp)
  8001bc:	e8 9d ff ff ff       	call   80015e <vcprintf>
	va_end(ap);

	return cnt;
}
  8001c1:	c9                   	leave  
  8001c2:	c3                   	ret    

008001c3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001c3:	55                   	push   %ebp
  8001c4:	89 e5                	mov    %esp,%ebp
  8001c6:	57                   	push   %edi
  8001c7:	56                   	push   %esi
  8001c8:	53                   	push   %ebx
  8001c9:	83 ec 1c             	sub    $0x1c,%esp
  8001cc:	89 c7                	mov    %eax,%edi
  8001ce:	89 d6                	mov    %edx,%esi
  8001d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001d9:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001df:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e4:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001e7:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001ea:	39 d3                	cmp    %edx,%ebx
  8001ec:	72 05                	jb     8001f3 <printnum+0x30>
  8001ee:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001f1:	77 78                	ja     80026b <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 18             	pushl  0x18(%ebp)
  8001f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8001fc:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ff:	53                   	push   %ebx
  800200:	ff 75 10             	pushl  0x10(%ebp)
  800203:	83 ec 08             	sub    $0x8,%esp
  800206:	ff 75 e4             	pushl  -0x1c(%ebp)
  800209:	ff 75 e0             	pushl  -0x20(%ebp)
  80020c:	ff 75 dc             	pushl  -0x24(%ebp)
  80020f:	ff 75 d8             	pushl  -0x28(%ebp)
  800212:	e8 f1 1d 00 00       	call   802008 <__udivdi3>
  800217:	83 c4 18             	add    $0x18,%esp
  80021a:	52                   	push   %edx
  80021b:	50                   	push   %eax
  80021c:	89 f2                	mov    %esi,%edx
  80021e:	89 f8                	mov    %edi,%eax
  800220:	e8 9e ff ff ff       	call   8001c3 <printnum>
  800225:	83 c4 20             	add    $0x20,%esp
  800228:	eb 11                	jmp    80023b <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80022a:	83 ec 08             	sub    $0x8,%esp
  80022d:	56                   	push   %esi
  80022e:	ff 75 18             	pushl  0x18(%ebp)
  800231:	ff d7                	call   *%edi
  800233:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800236:	4b                   	dec    %ebx
  800237:	85 db                	test   %ebx,%ebx
  800239:	7f ef                	jg     80022a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80023b:	83 ec 08             	sub    $0x8,%esp
  80023e:	56                   	push   %esi
  80023f:	83 ec 04             	sub    $0x4,%esp
  800242:	ff 75 e4             	pushl  -0x1c(%ebp)
  800245:	ff 75 e0             	pushl  -0x20(%ebp)
  800248:	ff 75 dc             	pushl  -0x24(%ebp)
  80024b:	ff 75 d8             	pushl  -0x28(%ebp)
  80024e:	e8 c5 1e 00 00       	call   802118 <__umoddi3>
  800253:	83 c4 14             	add    $0x14,%esp
  800256:	0f be 80 00 23 80 00 	movsbl 0x802300(%eax),%eax
  80025d:	50                   	push   %eax
  80025e:	ff d7                	call   *%edi
}
  800260:	83 c4 10             	add    $0x10,%esp
  800263:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800266:	5b                   	pop    %ebx
  800267:	5e                   	pop    %esi
  800268:	5f                   	pop    %edi
  800269:	5d                   	pop    %ebp
  80026a:	c3                   	ret    
  80026b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80026e:	eb c6                	jmp    800236 <printnum+0x73>

00800270 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800270:	55                   	push   %ebp
  800271:	89 e5                	mov    %esp,%ebp
  800273:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800276:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800279:	8b 10                	mov    (%eax),%edx
  80027b:	3b 50 04             	cmp    0x4(%eax),%edx
  80027e:	73 0a                	jae    80028a <sprintputch+0x1a>
		*b->buf++ = ch;
  800280:	8d 4a 01             	lea    0x1(%edx),%ecx
  800283:	89 08                	mov    %ecx,(%eax)
  800285:	8b 45 08             	mov    0x8(%ebp),%eax
  800288:	88 02                	mov    %al,(%edx)
}
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    

0080028c <printfmt>:
{
  80028c:	55                   	push   %ebp
  80028d:	89 e5                	mov    %esp,%ebp
  80028f:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800292:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800295:	50                   	push   %eax
  800296:	ff 75 10             	pushl  0x10(%ebp)
  800299:	ff 75 0c             	pushl  0xc(%ebp)
  80029c:	ff 75 08             	pushl  0x8(%ebp)
  80029f:	e8 05 00 00 00       	call   8002a9 <vprintfmt>
}
  8002a4:	83 c4 10             	add    $0x10,%esp
  8002a7:	c9                   	leave  
  8002a8:	c3                   	ret    

008002a9 <vprintfmt>:
{
  8002a9:	55                   	push   %ebp
  8002aa:	89 e5                	mov    %esp,%ebp
  8002ac:	57                   	push   %edi
  8002ad:	56                   	push   %esi
  8002ae:	53                   	push   %ebx
  8002af:	83 ec 2c             	sub    $0x2c,%esp
  8002b2:	8b 75 08             	mov    0x8(%ebp),%esi
  8002b5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002b8:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002bb:	e9 ae 03 00 00       	jmp    80066e <vprintfmt+0x3c5>
  8002c0:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002c4:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002cb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002d2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002d9:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002de:	8d 47 01             	lea    0x1(%edi),%eax
  8002e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002e4:	8a 17                	mov    (%edi),%dl
  8002e6:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002e9:	3c 55                	cmp    $0x55,%al
  8002eb:	0f 87 fe 03 00 00    	ja     8006ef <vprintfmt+0x446>
  8002f1:	0f b6 c0             	movzbl %al,%eax
  8002f4:	ff 24 85 40 24 80 00 	jmp    *0x802440(,%eax,4)
  8002fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002fe:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800302:	eb da                	jmp    8002de <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800304:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800307:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80030b:	eb d1                	jmp    8002de <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	0f b6 d2             	movzbl %dl,%edx
  800310:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800313:	b8 00 00 00 00       	mov    $0x0,%eax
  800318:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80031b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80031e:	01 c0                	add    %eax,%eax
  800320:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800324:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800327:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80032a:	83 f9 09             	cmp    $0x9,%ecx
  80032d:	77 52                	ja     800381 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80032f:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800330:	eb e9                	jmp    80031b <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800332:	8b 45 14             	mov    0x14(%ebp),%eax
  800335:	8b 00                	mov    (%eax),%eax
  800337:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80033a:	8b 45 14             	mov    0x14(%ebp),%eax
  80033d:	8d 40 04             	lea    0x4(%eax),%eax
  800340:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800343:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800346:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80034a:	79 92                	jns    8002de <vprintfmt+0x35>
				width = precision, precision = -1;
  80034c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80034f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800352:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800359:	eb 83                	jmp    8002de <vprintfmt+0x35>
  80035b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80035f:	78 08                	js     800369 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800361:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800364:	e9 75 ff ff ff       	jmp    8002de <vprintfmt+0x35>
  800369:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800370:	eb ef                	jmp    800361 <vprintfmt+0xb8>
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800375:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80037c:	e9 5d ff ff ff       	jmp    8002de <vprintfmt+0x35>
  800381:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800384:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800387:	eb bd                	jmp    800346 <vprintfmt+0x9d>
			lflag++;
  800389:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80038a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80038d:	e9 4c ff ff ff       	jmp    8002de <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800392:	8b 45 14             	mov    0x14(%ebp),%eax
  800395:	8d 78 04             	lea    0x4(%eax),%edi
  800398:	83 ec 08             	sub    $0x8,%esp
  80039b:	53                   	push   %ebx
  80039c:	ff 30                	pushl  (%eax)
  80039e:	ff d6                	call   *%esi
			break;
  8003a0:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003a3:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003a6:	e9 c0 02 00 00       	jmp    80066b <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ae:	8d 78 04             	lea    0x4(%eax),%edi
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	85 c0                	test   %eax,%eax
  8003b5:	78 2a                	js     8003e1 <vprintfmt+0x138>
  8003b7:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003b9:	83 f8 0f             	cmp    $0xf,%eax
  8003bc:	7f 27                	jg     8003e5 <vprintfmt+0x13c>
  8003be:	8b 04 85 a0 25 80 00 	mov    0x8025a0(,%eax,4),%eax
  8003c5:	85 c0                	test   %eax,%eax
  8003c7:	74 1c                	je     8003e5 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003c9:	50                   	push   %eax
  8003ca:	68 c8 26 80 00       	push   $0x8026c8
  8003cf:	53                   	push   %ebx
  8003d0:	56                   	push   %esi
  8003d1:	e8 b6 fe ff ff       	call   80028c <printfmt>
  8003d6:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003d9:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003dc:	e9 8a 02 00 00       	jmp    80066b <vprintfmt+0x3c2>
  8003e1:	f7 d8                	neg    %eax
  8003e3:	eb d2                	jmp    8003b7 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003e5:	52                   	push   %edx
  8003e6:	68 18 23 80 00       	push   $0x802318
  8003eb:	53                   	push   %ebx
  8003ec:	56                   	push   %esi
  8003ed:	e8 9a fe ff ff       	call   80028c <printfmt>
  8003f2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003f5:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003f8:	e9 6e 02 00 00       	jmp    80066b <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800400:	83 c0 04             	add    $0x4,%eax
  800403:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800406:	8b 45 14             	mov    0x14(%ebp),%eax
  800409:	8b 38                	mov    (%eax),%edi
  80040b:	85 ff                	test   %edi,%edi
  80040d:	74 39                	je     800448 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80040f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800413:	0f 8e a9 00 00 00    	jle    8004c2 <vprintfmt+0x219>
  800419:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80041d:	0f 84 a7 00 00 00    	je     8004ca <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800423:	83 ec 08             	sub    $0x8,%esp
  800426:	ff 75 d0             	pushl  -0x30(%ebp)
  800429:	57                   	push   %edi
  80042a:	e8 6b 03 00 00       	call   80079a <strnlen>
  80042f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800432:	29 c1                	sub    %eax,%ecx
  800434:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800437:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80043a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80043e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800441:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800444:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800446:	eb 14                	jmp    80045c <vprintfmt+0x1b3>
				p = "(null)";
  800448:	bf 11 23 80 00       	mov    $0x802311,%edi
  80044d:	eb c0                	jmp    80040f <vprintfmt+0x166>
					putch(padc, putdat);
  80044f:	83 ec 08             	sub    $0x8,%esp
  800452:	53                   	push   %ebx
  800453:	ff 75 e0             	pushl  -0x20(%ebp)
  800456:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800458:	4f                   	dec    %edi
  800459:	83 c4 10             	add    $0x10,%esp
  80045c:	85 ff                	test   %edi,%edi
  80045e:	7f ef                	jg     80044f <vprintfmt+0x1a6>
  800460:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800463:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800466:	89 c8                	mov    %ecx,%eax
  800468:	85 c9                	test   %ecx,%ecx
  80046a:	78 10                	js     80047c <vprintfmt+0x1d3>
  80046c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80046f:	29 c1                	sub    %eax,%ecx
  800471:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800474:	89 75 08             	mov    %esi,0x8(%ebp)
  800477:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047a:	eb 15                	jmp    800491 <vprintfmt+0x1e8>
  80047c:	b8 00 00 00 00       	mov    $0x0,%eax
  800481:	eb e9                	jmp    80046c <vprintfmt+0x1c3>
					putch(ch, putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	52                   	push   %edx
  800488:	ff 55 08             	call   *0x8(%ebp)
  80048b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80048e:	ff 4d e0             	decl   -0x20(%ebp)
  800491:	47                   	inc    %edi
  800492:	8a 47 ff             	mov    -0x1(%edi),%al
  800495:	0f be d0             	movsbl %al,%edx
  800498:	85 d2                	test   %edx,%edx
  80049a:	74 59                	je     8004f5 <vprintfmt+0x24c>
  80049c:	85 f6                	test   %esi,%esi
  80049e:	78 03                	js     8004a3 <vprintfmt+0x1fa>
  8004a0:	4e                   	dec    %esi
  8004a1:	78 2f                	js     8004d2 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004a3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004a7:	74 da                	je     800483 <vprintfmt+0x1da>
  8004a9:	0f be c0             	movsbl %al,%eax
  8004ac:	83 e8 20             	sub    $0x20,%eax
  8004af:	83 f8 5e             	cmp    $0x5e,%eax
  8004b2:	76 cf                	jbe    800483 <vprintfmt+0x1da>
					putch('?', putdat);
  8004b4:	83 ec 08             	sub    $0x8,%esp
  8004b7:	53                   	push   %ebx
  8004b8:	6a 3f                	push   $0x3f
  8004ba:	ff 55 08             	call   *0x8(%ebp)
  8004bd:	83 c4 10             	add    $0x10,%esp
  8004c0:	eb cc                	jmp    80048e <vprintfmt+0x1e5>
  8004c2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c8:	eb c7                	jmp    800491 <vprintfmt+0x1e8>
  8004ca:	89 75 08             	mov    %esi,0x8(%ebp)
  8004cd:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004d0:	eb bf                	jmp    800491 <vprintfmt+0x1e8>
  8004d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8004d5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004d8:	eb 0c                	jmp    8004e6 <vprintfmt+0x23d>
				putch(' ', putdat);
  8004da:	83 ec 08             	sub    $0x8,%esp
  8004dd:	53                   	push   %ebx
  8004de:	6a 20                	push   $0x20
  8004e0:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004e2:	4f                   	dec    %edi
  8004e3:	83 c4 10             	add    $0x10,%esp
  8004e6:	85 ff                	test   %edi,%edi
  8004e8:	7f f0                	jg     8004da <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8004f0:	e9 76 01 00 00       	jmp    80066b <vprintfmt+0x3c2>
  8004f5:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004f8:	8b 75 08             	mov    0x8(%ebp),%esi
  8004fb:	eb e9                	jmp    8004e6 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004fd:	83 f9 01             	cmp    $0x1,%ecx
  800500:	7f 1f                	jg     800521 <vprintfmt+0x278>
	else if (lflag)
  800502:	85 c9                	test   %ecx,%ecx
  800504:	75 48                	jne    80054e <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800506:	8b 45 14             	mov    0x14(%ebp),%eax
  800509:	8b 00                	mov    (%eax),%eax
  80050b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80050e:	89 c1                	mov    %eax,%ecx
  800510:	c1 f9 1f             	sar    $0x1f,%ecx
  800513:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8d 40 04             	lea    0x4(%eax),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
  80051f:	eb 17                	jmp    800538 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800521:	8b 45 14             	mov    0x14(%ebp),%eax
  800524:	8b 50 04             	mov    0x4(%eax),%edx
  800527:	8b 00                	mov    (%eax),%eax
  800529:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80052c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80052f:	8b 45 14             	mov    0x14(%ebp),%eax
  800532:	8d 40 08             	lea    0x8(%eax),%eax
  800535:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800538:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80053e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800542:	78 25                	js     800569 <vprintfmt+0x2c0>
			base = 10;
  800544:	b8 0a 00 00 00       	mov    $0xa,%eax
  800549:	e9 03 01 00 00       	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80054e:	8b 45 14             	mov    0x14(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800556:	89 c1                	mov    %eax,%ecx
  800558:	c1 f9 1f             	sar    $0x1f,%ecx
  80055b:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 40 04             	lea    0x4(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
  800567:	eb cf                	jmp    800538 <vprintfmt+0x28f>
				putch('-', putdat);
  800569:	83 ec 08             	sub    $0x8,%esp
  80056c:	53                   	push   %ebx
  80056d:	6a 2d                	push   $0x2d
  80056f:	ff d6                	call   *%esi
				num = -(long long) num;
  800571:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800574:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800577:	f7 da                	neg    %edx
  800579:	83 d1 00             	adc    $0x0,%ecx
  80057c:	f7 d9                	neg    %ecx
  80057e:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800581:	b8 0a 00 00 00       	mov    $0xa,%eax
  800586:	e9 c6 00 00 00       	jmp    800651 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80058b:	83 f9 01             	cmp    $0x1,%ecx
  80058e:	7f 1e                	jg     8005ae <vprintfmt+0x305>
	else if (lflag)
  800590:	85 c9                	test   %ecx,%ecx
  800592:	75 32                	jne    8005c6 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800594:	8b 45 14             	mov    0x14(%ebp),%eax
  800597:	8b 10                	mov    (%eax),%edx
  800599:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059e:	8d 40 04             	lea    0x4(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a9:	e9 a3 00 00 00       	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	8b 10                	mov    (%eax),%edx
  8005b3:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b6:	8d 40 08             	lea    0x8(%eax),%eax
  8005b9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005bc:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c1:	e9 8b 00 00 00       	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c9:	8b 10                	mov    (%eax),%edx
  8005cb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005d0:	8d 40 04             	lea    0x4(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005db:	eb 74                	jmp    800651 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005dd:	83 f9 01             	cmp    $0x1,%ecx
  8005e0:	7f 1b                	jg     8005fd <vprintfmt+0x354>
	else if (lflag)
  8005e2:	85 c9                	test   %ecx,%ecx
  8005e4:	75 2c                	jne    800612 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e9:	8b 10                	mov    (%eax),%edx
  8005eb:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005f0:	8d 40 04             	lea    0x4(%eax),%eax
  8005f3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005f6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005fb:	eb 54                	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8b 48 04             	mov    0x4(%eax),%ecx
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80060b:	b8 08 00 00 00       	mov    $0x8,%eax
  800610:	eb 3f                	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800612:	8b 45 14             	mov    0x14(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061c:	8d 40 04             	lea    0x4(%eax),%eax
  80061f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800622:	b8 08 00 00 00       	mov    $0x8,%eax
  800627:	eb 28                	jmp    800651 <vprintfmt+0x3a8>
			putch('0', putdat);
  800629:	83 ec 08             	sub    $0x8,%esp
  80062c:	53                   	push   %ebx
  80062d:	6a 30                	push   $0x30
  80062f:	ff d6                	call   *%esi
			putch('x', putdat);
  800631:	83 c4 08             	add    $0x8,%esp
  800634:	53                   	push   %ebx
  800635:	6a 78                	push   $0x78
  800637:	ff d6                	call   *%esi
			num = (unsigned long long)
  800639:	8b 45 14             	mov    0x14(%ebp),%eax
  80063c:	8b 10                	mov    (%eax),%edx
  80063e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800643:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800646:	8d 40 04             	lea    0x4(%eax),%eax
  800649:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80064c:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800651:	83 ec 0c             	sub    $0xc,%esp
  800654:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800658:	57                   	push   %edi
  800659:	ff 75 e0             	pushl  -0x20(%ebp)
  80065c:	50                   	push   %eax
  80065d:	51                   	push   %ecx
  80065e:	52                   	push   %edx
  80065f:	89 da                	mov    %ebx,%edx
  800661:	89 f0                	mov    %esi,%eax
  800663:	e8 5b fb ff ff       	call   8001c3 <printnum>
			break;
  800668:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80066b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80066e:	47                   	inc    %edi
  80066f:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800673:	83 f8 25             	cmp    $0x25,%eax
  800676:	0f 84 44 fc ff ff    	je     8002c0 <vprintfmt+0x17>
			if (ch == '\0')
  80067c:	85 c0                	test   %eax,%eax
  80067e:	0f 84 89 00 00 00    	je     80070d <vprintfmt+0x464>
			putch(ch, putdat);
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	53                   	push   %ebx
  800688:	50                   	push   %eax
  800689:	ff d6                	call   *%esi
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	eb de                	jmp    80066e <vprintfmt+0x3c5>
	if (lflag >= 2)
  800690:	83 f9 01             	cmp    $0x1,%ecx
  800693:	7f 1b                	jg     8006b0 <vprintfmt+0x407>
	else if (lflag)
  800695:	85 c9                	test   %ecx,%ecx
  800697:	75 2c                	jne    8006c5 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800699:	8b 45 14             	mov    0x14(%ebp),%eax
  80069c:	8b 10                	mov    (%eax),%edx
  80069e:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006a3:	8d 40 04             	lea    0x4(%eax),%eax
  8006a6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a9:	b8 10 00 00 00       	mov    $0x10,%eax
  8006ae:	eb a1                	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b3:	8b 10                	mov    (%eax),%edx
  8006b5:	8b 48 04             	mov    0x4(%eax),%ecx
  8006b8:	8d 40 08             	lea    0x8(%eax),%eax
  8006bb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006be:	b8 10 00 00 00       	mov    $0x10,%eax
  8006c3:	eb 8c                	jmp    800651 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8b 10                	mov    (%eax),%edx
  8006ca:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006cf:	8d 40 04             	lea    0x4(%eax),%eax
  8006d2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8006da:	e9 72 ff ff ff       	jmp    800651 <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	53                   	push   %ebx
  8006e3:	6a 25                	push   $0x25
  8006e5:	ff d6                	call   *%esi
			break;
  8006e7:	83 c4 10             	add    $0x10,%esp
  8006ea:	e9 7c ff ff ff       	jmp    80066b <vprintfmt+0x3c2>
			putch('%', putdat);
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	53                   	push   %ebx
  8006f3:	6a 25                	push   $0x25
  8006f5:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006f7:	83 c4 10             	add    $0x10,%esp
  8006fa:	89 f8                	mov    %edi,%eax
  8006fc:	eb 01                	jmp    8006ff <vprintfmt+0x456>
  8006fe:	48                   	dec    %eax
  8006ff:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800703:	75 f9                	jne    8006fe <vprintfmt+0x455>
  800705:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800708:	e9 5e ff ff ff       	jmp    80066b <vprintfmt+0x3c2>
}
  80070d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800710:	5b                   	pop    %ebx
  800711:	5e                   	pop    %esi
  800712:	5f                   	pop    %edi
  800713:	5d                   	pop    %ebp
  800714:	c3                   	ret    

00800715 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800715:	55                   	push   %ebp
  800716:	89 e5                	mov    %esp,%ebp
  800718:	83 ec 18             	sub    $0x18,%esp
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800721:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800724:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800728:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80072b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800732:	85 c0                	test   %eax,%eax
  800734:	74 26                	je     80075c <vsnprintf+0x47>
  800736:	85 d2                	test   %edx,%edx
  800738:	7e 29                	jle    800763 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80073a:	ff 75 14             	pushl  0x14(%ebp)
  80073d:	ff 75 10             	pushl  0x10(%ebp)
  800740:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800743:	50                   	push   %eax
  800744:	68 70 02 80 00       	push   $0x800270
  800749:	e8 5b fb ff ff       	call   8002a9 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80074e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800751:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800757:	83 c4 10             	add    $0x10,%esp
}
  80075a:	c9                   	leave  
  80075b:	c3                   	ret    
		return -E_INVAL;
  80075c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800761:	eb f7                	jmp    80075a <vsnprintf+0x45>
  800763:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800768:	eb f0                	jmp    80075a <vsnprintf+0x45>

0080076a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80076a:	55                   	push   %ebp
  80076b:	89 e5                	mov    %esp,%ebp
  80076d:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800770:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800773:	50                   	push   %eax
  800774:	ff 75 10             	pushl  0x10(%ebp)
  800777:	ff 75 0c             	pushl  0xc(%ebp)
  80077a:	ff 75 08             	pushl  0x8(%ebp)
  80077d:	e8 93 ff ff ff       	call   800715 <vsnprintf>
	va_end(ap);

	return rc;
}
  800782:	c9                   	leave  
  800783:	c3                   	ret    

00800784 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800784:	55                   	push   %ebp
  800785:	89 e5                	mov    %esp,%ebp
  800787:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80078a:	b8 00 00 00 00       	mov    $0x0,%eax
  80078f:	eb 01                	jmp    800792 <strlen+0xe>
		n++;
  800791:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800792:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800796:	75 f9                	jne    800791 <strlen+0xd>
	return n;
}
  800798:	5d                   	pop    %ebp
  800799:	c3                   	ret    

0080079a <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007a0:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8007a8:	eb 01                	jmp    8007ab <strnlen+0x11>
		n++;
  8007aa:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007ab:	39 d0                	cmp    %edx,%eax
  8007ad:	74 06                	je     8007b5 <strnlen+0x1b>
  8007af:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007b3:	75 f5                	jne    8007aa <strnlen+0x10>
	return n;
}
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	53                   	push   %ebx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007c1:	89 c2                	mov    %eax,%edx
  8007c3:	42                   	inc    %edx
  8007c4:	41                   	inc    %ecx
  8007c5:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007c8:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007cb:	84 db                	test   %bl,%bl
  8007cd:	75 f4                	jne    8007c3 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007cf:	5b                   	pop    %ebx
  8007d0:	5d                   	pop    %ebp
  8007d1:	c3                   	ret    

008007d2 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	53                   	push   %ebx
  8007d6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007d9:	53                   	push   %ebx
  8007da:	e8 a5 ff ff ff       	call   800784 <strlen>
  8007df:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007e2:	ff 75 0c             	pushl  0xc(%ebp)
  8007e5:	01 d8                	add    %ebx,%eax
  8007e7:	50                   	push   %eax
  8007e8:	e8 ca ff ff ff       	call   8007b7 <strcpy>
	return dst;
}
  8007ed:	89 d8                	mov    %ebx,%eax
  8007ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007f2:	c9                   	leave  
  8007f3:	c3                   	ret    

008007f4 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	56                   	push   %esi
  8007f8:	53                   	push   %ebx
  8007f9:	8b 75 08             	mov    0x8(%ebp),%esi
  8007fc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ff:	89 f3                	mov    %esi,%ebx
  800801:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800804:	89 f2                	mov    %esi,%edx
  800806:	eb 0c                	jmp    800814 <strncpy+0x20>
		*dst++ = *src;
  800808:	42                   	inc    %edx
  800809:	8a 01                	mov    (%ecx),%al
  80080b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80080e:	80 39 01             	cmpb   $0x1,(%ecx)
  800811:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800814:	39 da                	cmp    %ebx,%edx
  800816:	75 f0                	jne    800808 <strncpy+0x14>
	}
	return ret;
}
  800818:	89 f0                	mov    %esi,%eax
  80081a:	5b                   	pop    %ebx
  80081b:	5e                   	pop    %esi
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	8b 75 08             	mov    0x8(%ebp),%esi
  800826:	8b 55 0c             	mov    0xc(%ebp),%edx
  800829:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80082c:	85 c0                	test   %eax,%eax
  80082e:	74 20                	je     800850 <strlcpy+0x32>
  800830:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800834:	89 f0                	mov    %esi,%eax
  800836:	eb 05                	jmp    80083d <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800838:	40                   	inc    %eax
  800839:	42                   	inc    %edx
  80083a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80083d:	39 d8                	cmp    %ebx,%eax
  80083f:	74 06                	je     800847 <strlcpy+0x29>
  800841:	8a 0a                	mov    (%edx),%cl
  800843:	84 c9                	test   %cl,%cl
  800845:	75 f1                	jne    800838 <strlcpy+0x1a>
		*dst = '\0';
  800847:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  80084a:	29 f0                	sub    %esi,%eax
}
  80084c:	5b                   	pop    %ebx
  80084d:	5e                   	pop    %esi
  80084e:	5d                   	pop    %ebp
  80084f:	c3                   	ret    
  800850:	89 f0                	mov    %esi,%eax
  800852:	eb f6                	jmp    80084a <strlcpy+0x2c>

00800854 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800854:	55                   	push   %ebp
  800855:	89 e5                	mov    %esp,%ebp
  800857:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80085a:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80085d:	eb 02                	jmp    800861 <strcmp+0xd>
		p++, q++;
  80085f:	41                   	inc    %ecx
  800860:	42                   	inc    %edx
	while (*p && *p == *q)
  800861:	8a 01                	mov    (%ecx),%al
  800863:	84 c0                	test   %al,%al
  800865:	74 04                	je     80086b <strcmp+0x17>
  800867:	3a 02                	cmp    (%edx),%al
  800869:	74 f4                	je     80085f <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80086b:	0f b6 c0             	movzbl %al,%eax
  80086e:	0f b6 12             	movzbl (%edx),%edx
  800871:	29 d0                	sub    %edx,%eax
}
  800873:	5d                   	pop    %ebp
  800874:	c3                   	ret    

00800875 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800875:	55                   	push   %ebp
  800876:	89 e5                	mov    %esp,%ebp
  800878:	53                   	push   %ebx
  800879:	8b 45 08             	mov    0x8(%ebp),%eax
  80087c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80087f:	89 c3                	mov    %eax,%ebx
  800881:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800884:	eb 02                	jmp    800888 <strncmp+0x13>
		n--, p++, q++;
  800886:	40                   	inc    %eax
  800887:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800888:	39 d8                	cmp    %ebx,%eax
  80088a:	74 15                	je     8008a1 <strncmp+0x2c>
  80088c:	8a 08                	mov    (%eax),%cl
  80088e:	84 c9                	test   %cl,%cl
  800890:	74 04                	je     800896 <strncmp+0x21>
  800892:	3a 0a                	cmp    (%edx),%cl
  800894:	74 f0                	je     800886 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800896:	0f b6 00             	movzbl (%eax),%eax
  800899:	0f b6 12             	movzbl (%edx),%edx
  80089c:	29 d0                	sub    %edx,%eax
}
  80089e:	5b                   	pop    %ebx
  80089f:	5d                   	pop    %ebp
  8008a0:	c3                   	ret    
		return 0;
  8008a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a6:	eb f6                	jmp    80089e <strncmp+0x29>

008008a8 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ae:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008b1:	8a 10                	mov    (%eax),%dl
  8008b3:	84 d2                	test   %dl,%dl
  8008b5:	74 07                	je     8008be <strchr+0x16>
		if (*s == c)
  8008b7:	38 ca                	cmp    %cl,%dl
  8008b9:	74 08                	je     8008c3 <strchr+0x1b>
	for (; *s; s++)
  8008bb:	40                   	inc    %eax
  8008bc:	eb f3                	jmp    8008b1 <strchr+0x9>
			return (char *) s;
	return 0;
  8008be:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008c3:	5d                   	pop    %ebp
  8008c4:	c3                   	ret    

008008c5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008c5:	55                   	push   %ebp
  8008c6:	89 e5                	mov    %esp,%ebp
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008ce:	8a 10                	mov    (%eax),%dl
  8008d0:	84 d2                	test   %dl,%dl
  8008d2:	74 07                	je     8008db <strfind+0x16>
		if (*s == c)
  8008d4:	38 ca                	cmp    %cl,%dl
  8008d6:	74 03                	je     8008db <strfind+0x16>
	for (; *s; s++)
  8008d8:	40                   	inc    %eax
  8008d9:	eb f3                	jmp    8008ce <strfind+0x9>
			break;
	return (char *) s;
}
  8008db:	5d                   	pop    %ebp
  8008dc:	c3                   	ret    

008008dd <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	57                   	push   %edi
  8008e1:	56                   	push   %esi
  8008e2:	53                   	push   %ebx
  8008e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008e6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008e9:	85 c9                	test   %ecx,%ecx
  8008eb:	74 13                	je     800900 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008f3:	75 05                	jne    8008fa <memset+0x1d>
  8008f5:	f6 c1 03             	test   $0x3,%cl
  8008f8:	74 0d                	je     800907 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008fd:	fc                   	cld    
  8008fe:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800900:	89 f8                	mov    %edi,%eax
  800902:	5b                   	pop    %ebx
  800903:	5e                   	pop    %esi
  800904:	5f                   	pop    %edi
  800905:	5d                   	pop    %ebp
  800906:	c3                   	ret    
		c &= 0xFF;
  800907:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80090b:	89 d3                	mov    %edx,%ebx
  80090d:	c1 e3 08             	shl    $0x8,%ebx
  800910:	89 d0                	mov    %edx,%eax
  800912:	c1 e0 18             	shl    $0x18,%eax
  800915:	89 d6                	mov    %edx,%esi
  800917:	c1 e6 10             	shl    $0x10,%esi
  80091a:	09 f0                	or     %esi,%eax
  80091c:	09 c2                	or     %eax,%edx
  80091e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800920:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800923:	89 d0                	mov    %edx,%eax
  800925:	fc                   	cld    
  800926:	f3 ab                	rep stos %eax,%es:(%edi)
  800928:	eb d6                	jmp    800900 <memset+0x23>

0080092a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	57                   	push   %edi
  80092e:	56                   	push   %esi
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 75 0c             	mov    0xc(%ebp),%esi
  800935:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800938:	39 c6                	cmp    %eax,%esi
  80093a:	73 33                	jae    80096f <memmove+0x45>
  80093c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80093f:	39 d0                	cmp    %edx,%eax
  800941:	73 2c                	jae    80096f <memmove+0x45>
		s += n;
		d += n;
  800943:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800946:	89 d6                	mov    %edx,%esi
  800948:	09 fe                	or     %edi,%esi
  80094a:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800950:	75 13                	jne    800965 <memmove+0x3b>
  800952:	f6 c1 03             	test   $0x3,%cl
  800955:	75 0e                	jne    800965 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800957:	83 ef 04             	sub    $0x4,%edi
  80095a:	8d 72 fc             	lea    -0x4(%edx),%esi
  80095d:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800960:	fd                   	std    
  800961:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800963:	eb 07                	jmp    80096c <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800965:	4f                   	dec    %edi
  800966:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800969:	fd                   	std    
  80096a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80096c:	fc                   	cld    
  80096d:	eb 13                	jmp    800982 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80096f:	89 f2                	mov    %esi,%edx
  800971:	09 c2                	or     %eax,%edx
  800973:	f6 c2 03             	test   $0x3,%dl
  800976:	75 05                	jne    80097d <memmove+0x53>
  800978:	f6 c1 03             	test   $0x3,%cl
  80097b:	74 09                	je     800986 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  80097d:	89 c7                	mov    %eax,%edi
  80097f:	fc                   	cld    
  800980:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800982:	5e                   	pop    %esi
  800983:	5f                   	pop    %edi
  800984:	5d                   	pop    %ebp
  800985:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800986:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800989:	89 c7                	mov    %eax,%edi
  80098b:	fc                   	cld    
  80098c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80098e:	eb f2                	jmp    800982 <memmove+0x58>

00800990 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800993:	ff 75 10             	pushl  0x10(%ebp)
  800996:	ff 75 0c             	pushl  0xc(%ebp)
  800999:	ff 75 08             	pushl  0x8(%ebp)
  80099c:	e8 89 ff ff ff       	call   80092a <memmove>
}
  8009a1:	c9                   	leave  
  8009a2:	c3                   	ret    

008009a3 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009a3:	55                   	push   %ebp
  8009a4:	89 e5                	mov    %esp,%ebp
  8009a6:	56                   	push   %esi
  8009a7:	53                   	push   %ebx
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	89 c6                	mov    %eax,%esi
  8009ad:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009b0:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009b3:	39 f0                	cmp    %esi,%eax
  8009b5:	74 16                	je     8009cd <memcmp+0x2a>
		if (*s1 != *s2)
  8009b7:	8a 08                	mov    (%eax),%cl
  8009b9:	8a 1a                	mov    (%edx),%bl
  8009bb:	38 d9                	cmp    %bl,%cl
  8009bd:	75 04                	jne    8009c3 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009bf:	40                   	inc    %eax
  8009c0:	42                   	inc    %edx
  8009c1:	eb f0                	jmp    8009b3 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009c3:	0f b6 c1             	movzbl %cl,%eax
  8009c6:	0f b6 db             	movzbl %bl,%ebx
  8009c9:	29 d8                	sub    %ebx,%eax
  8009cb:	eb 05                	jmp    8009d2 <memcmp+0x2f>
	}

	return 0;
  8009cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8009d2:	5b                   	pop    %ebx
  8009d3:	5e                   	pop    %esi
  8009d4:	5d                   	pop    %ebp
  8009d5:	c3                   	ret    

008009d6 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009d6:	55                   	push   %ebp
  8009d7:	89 e5                	mov    %esp,%ebp
  8009d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8009dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009df:	89 c2                	mov    %eax,%edx
  8009e1:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009e4:	39 d0                	cmp    %edx,%eax
  8009e6:	73 07                	jae    8009ef <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009e8:	38 08                	cmp    %cl,(%eax)
  8009ea:	74 03                	je     8009ef <memfind+0x19>
	for (; s < ends; s++)
  8009ec:	40                   	inc    %eax
  8009ed:	eb f5                	jmp    8009e4 <memfind+0xe>
			break;
	return (void *) s;
}
  8009ef:	5d                   	pop    %ebp
  8009f0:	c3                   	ret    

008009f1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009f1:	55                   	push   %ebp
  8009f2:	89 e5                	mov    %esp,%ebp
  8009f4:	57                   	push   %edi
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009fa:	eb 01                	jmp    8009fd <strtol+0xc>
		s++;
  8009fc:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009fd:	8a 01                	mov    (%ecx),%al
  8009ff:	3c 20                	cmp    $0x20,%al
  800a01:	74 f9                	je     8009fc <strtol+0xb>
  800a03:	3c 09                	cmp    $0x9,%al
  800a05:	74 f5                	je     8009fc <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a07:	3c 2b                	cmp    $0x2b,%al
  800a09:	74 2b                	je     800a36 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a0b:	3c 2d                	cmp    $0x2d,%al
  800a0d:	74 2f                	je     800a3e <strtol+0x4d>
	int neg = 0;
  800a0f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a14:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a1b:	75 12                	jne    800a2f <strtol+0x3e>
  800a1d:	80 39 30             	cmpb   $0x30,(%ecx)
  800a20:	74 24                	je     800a46 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a22:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a26:	75 07                	jne    800a2f <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a28:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a2f:	b8 00 00 00 00       	mov    $0x0,%eax
  800a34:	eb 4e                	jmp    800a84 <strtol+0x93>
		s++;
  800a36:	41                   	inc    %ecx
	int neg = 0;
  800a37:	bf 00 00 00 00       	mov    $0x0,%edi
  800a3c:	eb d6                	jmp    800a14 <strtol+0x23>
		s++, neg = 1;
  800a3e:	41                   	inc    %ecx
  800a3f:	bf 01 00 00 00       	mov    $0x1,%edi
  800a44:	eb ce                	jmp    800a14 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a46:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a4a:	74 10                	je     800a5c <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a4c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a50:	75 dd                	jne    800a2f <strtol+0x3e>
		s++, base = 8;
  800a52:	41                   	inc    %ecx
  800a53:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a5a:	eb d3                	jmp    800a2f <strtol+0x3e>
		s += 2, base = 16;
  800a5c:	83 c1 02             	add    $0x2,%ecx
  800a5f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a66:	eb c7                	jmp    800a2f <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a68:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a6b:	89 f3                	mov    %esi,%ebx
  800a6d:	80 fb 19             	cmp    $0x19,%bl
  800a70:	77 24                	ja     800a96 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a72:	0f be d2             	movsbl %dl,%edx
  800a75:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a78:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a7b:	7d 2b                	jge    800aa8 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a7d:	41                   	inc    %ecx
  800a7e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a82:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a84:	8a 11                	mov    (%ecx),%dl
  800a86:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a89:	80 fb 09             	cmp    $0x9,%bl
  800a8c:	77 da                	ja     800a68 <strtol+0x77>
			dig = *s - '0';
  800a8e:	0f be d2             	movsbl %dl,%edx
  800a91:	83 ea 30             	sub    $0x30,%edx
  800a94:	eb e2                	jmp    800a78 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a96:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a99:	89 f3                	mov    %esi,%ebx
  800a9b:	80 fb 19             	cmp    $0x19,%bl
  800a9e:	77 08                	ja     800aa8 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800aa0:	0f be d2             	movsbl %dl,%edx
  800aa3:	83 ea 37             	sub    $0x37,%edx
  800aa6:	eb d0                	jmp    800a78 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800aa8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800aac:	74 05                	je     800ab3 <strtol+0xc2>
		*endptr = (char *) s;
  800aae:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ab1:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ab3:	85 ff                	test   %edi,%edi
  800ab5:	74 02                	je     800ab9 <strtol+0xc8>
  800ab7:	f7 d8                	neg    %eax
}
  800ab9:	5b                   	pop    %ebx
  800aba:	5e                   	pop    %esi
  800abb:	5f                   	pop    %edi
  800abc:	5d                   	pop    %ebp
  800abd:	c3                   	ret    

00800abe <atoi>:

int
atoi(const char *s)
{
  800abe:	55                   	push   %ebp
  800abf:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800ac1:	6a 0a                	push   $0xa
  800ac3:	6a 00                	push   $0x0
  800ac5:	ff 75 08             	pushl  0x8(%ebp)
  800ac8:	e8 24 ff ff ff       	call   8009f1 <strtol>
}
  800acd:	c9                   	leave  
  800ace:	c3                   	ret    

00800acf <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800acf:	55                   	push   %ebp
  800ad0:	89 e5                	mov    %esp,%ebp
  800ad2:	57                   	push   %edi
  800ad3:	56                   	push   %esi
  800ad4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ad5:	b8 00 00 00 00       	mov    $0x0,%eax
  800ada:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800add:	8b 55 08             	mov    0x8(%ebp),%edx
  800ae0:	89 c3                	mov    %eax,%ebx
  800ae2:	89 c7                	mov    %eax,%edi
  800ae4:	89 c6                	mov    %eax,%esi
  800ae6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <sys_cgetc>:

int
sys_cgetc(void)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
  800af0:	57                   	push   %edi
  800af1:	56                   	push   %esi
  800af2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800af3:	ba 00 00 00 00       	mov    $0x0,%edx
  800af8:	b8 01 00 00 00       	mov    $0x1,%eax
  800afd:	89 d1                	mov    %edx,%ecx
  800aff:	89 d3                	mov    %edx,%ebx
  800b01:	89 d7                	mov    %edx,%edi
  800b03:	89 d6                	mov    %edx,%esi
  800b05:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b07:	5b                   	pop    %ebx
  800b08:	5e                   	pop    %esi
  800b09:	5f                   	pop    %edi
  800b0a:	5d                   	pop    %ebp
  800b0b:	c3                   	ret    

00800b0c <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	57                   	push   %edi
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b15:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b1a:	b8 03 00 00 00       	mov    $0x3,%eax
  800b1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800b22:	89 cb                	mov    %ecx,%ebx
  800b24:	89 cf                	mov    %ecx,%edi
  800b26:	89 ce                	mov    %ecx,%esi
  800b28:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b2a:	85 c0                	test   %eax,%eax
  800b2c:	7f 08                	jg     800b36 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b31:	5b                   	pop    %ebx
  800b32:	5e                   	pop    %esi
  800b33:	5f                   	pop    %edi
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b36:	83 ec 0c             	sub    $0xc,%esp
  800b39:	50                   	push   %eax
  800b3a:	6a 03                	push   $0x3
  800b3c:	68 ff 25 80 00       	push   $0x8025ff
  800b41:	6a 23                	push   $0x23
  800b43:	68 1c 26 80 00       	push   $0x80261c
  800b48:	e8 64 12 00 00       	call   801db1 <_panic>

00800b4d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
  800b50:	57                   	push   %edi
  800b51:	56                   	push   %esi
  800b52:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b53:	ba 00 00 00 00       	mov    $0x0,%edx
  800b58:	b8 02 00 00 00       	mov    $0x2,%eax
  800b5d:	89 d1                	mov    %edx,%ecx
  800b5f:	89 d3                	mov    %edx,%ebx
  800b61:	89 d7                	mov    %edx,%edi
  800b63:	89 d6                	mov    %edx,%esi
  800b65:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5f                   	pop    %edi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	57                   	push   %edi
  800b70:	56                   	push   %esi
  800b71:	53                   	push   %ebx
  800b72:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b75:	be 00 00 00 00       	mov    $0x0,%esi
  800b7a:	b8 04 00 00 00       	mov    $0x4,%eax
  800b7f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b82:	8b 55 08             	mov    0x8(%ebp),%edx
  800b85:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b88:	89 f7                	mov    %esi,%edi
  800b8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b8c:	85 c0                	test   %eax,%eax
  800b8e:	7f 08                	jg     800b98 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b93:	5b                   	pop    %ebx
  800b94:	5e                   	pop    %esi
  800b95:	5f                   	pop    %edi
  800b96:	5d                   	pop    %ebp
  800b97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b98:	83 ec 0c             	sub    $0xc,%esp
  800b9b:	50                   	push   %eax
  800b9c:	6a 04                	push   $0x4
  800b9e:	68 ff 25 80 00       	push   $0x8025ff
  800ba3:	6a 23                	push   $0x23
  800ba5:	68 1c 26 80 00       	push   $0x80261c
  800baa:	e8 02 12 00 00       	call   801db1 <_panic>

00800baf <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800baf:	55                   	push   %ebp
  800bb0:	89 e5                	mov    %esp,%ebp
  800bb2:	57                   	push   %edi
  800bb3:	56                   	push   %esi
  800bb4:	53                   	push   %ebx
  800bb5:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bb8:	b8 05 00 00 00       	mov    $0x5,%eax
  800bbd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bc0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bc6:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bc9:	8b 75 18             	mov    0x18(%ebp),%esi
  800bcc:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bce:	85 c0                	test   %eax,%eax
  800bd0:	7f 08                	jg     800bda <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800bd2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bd5:	5b                   	pop    %ebx
  800bd6:	5e                   	pop    %esi
  800bd7:	5f                   	pop    %edi
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bda:	83 ec 0c             	sub    $0xc,%esp
  800bdd:	50                   	push   %eax
  800bde:	6a 05                	push   $0x5
  800be0:	68 ff 25 80 00       	push   $0x8025ff
  800be5:	6a 23                	push   $0x23
  800be7:	68 1c 26 80 00       	push   $0x80261c
  800bec:	e8 c0 11 00 00       	call   801db1 <_panic>

00800bf1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bf1:	55                   	push   %ebp
  800bf2:	89 e5                	mov    %esp,%ebp
  800bf4:	57                   	push   %edi
  800bf5:	56                   	push   %esi
  800bf6:	53                   	push   %ebx
  800bf7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bff:	b8 06 00 00 00       	mov    $0x6,%eax
  800c04:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c07:	8b 55 08             	mov    0x8(%ebp),%edx
  800c0a:	89 df                	mov    %ebx,%edi
  800c0c:	89 de                	mov    %ebx,%esi
  800c0e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c10:	85 c0                	test   %eax,%eax
  800c12:	7f 08                	jg     800c1c <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800c20:	6a 06                	push   $0x6
  800c22:	68 ff 25 80 00       	push   $0x8025ff
  800c27:	6a 23                	push   $0x23
  800c29:	68 1c 26 80 00       	push   $0x80261c
  800c2e:	e8 7e 11 00 00       	call   801db1 <_panic>

00800c33 <sys_yield>:

void
sys_yield(void)
{
  800c33:	55                   	push   %ebp
  800c34:	89 e5                	mov    %esp,%ebp
  800c36:	57                   	push   %edi
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c39:	ba 00 00 00 00       	mov    $0x0,%edx
  800c3e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c43:	89 d1                	mov    %edx,%ecx
  800c45:	89 d3                	mov    %edx,%ebx
  800c47:	89 d7                	mov    %edx,%edi
  800c49:	89 d6                	mov    %edx,%esi
  800c4b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c4d:	5b                   	pop    %ebx
  800c4e:	5e                   	pop    %esi
  800c4f:	5f                   	pop    %edi
  800c50:	5d                   	pop    %ebp
  800c51:	c3                   	ret    

00800c52 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c52:	55                   	push   %ebp
  800c53:	89 e5                	mov    %esp,%ebp
  800c55:	57                   	push   %edi
  800c56:	56                   	push   %esi
  800c57:	53                   	push   %ebx
  800c58:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c5b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c60:	b8 08 00 00 00       	mov    $0x8,%eax
  800c65:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c68:	8b 55 08             	mov    0x8(%ebp),%edx
  800c6b:	89 df                	mov    %ebx,%edi
  800c6d:	89 de                	mov    %ebx,%esi
  800c6f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c71:	85 c0                	test   %eax,%eax
  800c73:	7f 08                	jg     800c7d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c75:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c78:	5b                   	pop    %ebx
  800c79:	5e                   	pop    %esi
  800c7a:	5f                   	pop    %edi
  800c7b:	5d                   	pop    %ebp
  800c7c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c7d:	83 ec 0c             	sub    $0xc,%esp
  800c80:	50                   	push   %eax
  800c81:	6a 08                	push   $0x8
  800c83:	68 ff 25 80 00       	push   $0x8025ff
  800c88:	6a 23                	push   $0x23
  800c8a:	68 1c 26 80 00       	push   $0x80261c
  800c8f:	e8 1d 11 00 00       	call   801db1 <_panic>

00800c94 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c94:	55                   	push   %ebp
  800c95:	89 e5                	mov    %esp,%ebp
  800c97:	57                   	push   %edi
  800c98:	56                   	push   %esi
  800c99:	53                   	push   %ebx
  800c9a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ca2:	b8 0c 00 00 00       	mov    $0xc,%eax
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	89 cb                	mov    %ecx,%ebx
  800cac:	89 cf                	mov    %ecx,%edi
  800cae:	89 ce                	mov    %ecx,%esi
  800cb0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cb2:	85 c0                	test   %eax,%eax
  800cb4:	7f 08                	jg     800cbe <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800cb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cb9:	5b                   	pop    %ebx
  800cba:	5e                   	pop    %esi
  800cbb:	5f                   	pop    %edi
  800cbc:	5d                   	pop    %ebp
  800cbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	50                   	push   %eax
  800cc2:	6a 0c                	push   $0xc
  800cc4:	68 ff 25 80 00       	push   $0x8025ff
  800cc9:	6a 23                	push   $0x23
  800ccb:	68 1c 26 80 00       	push   $0x80261c
  800cd0:	e8 dc 10 00 00       	call   801db1 <_panic>

00800cd5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
  800cd8:	57                   	push   %edi
  800cd9:	56                   	push   %esi
  800cda:	53                   	push   %ebx
  800cdb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cde:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ce3:	b8 09 00 00 00       	mov    $0x9,%eax
  800ce8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ceb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cee:	89 df                	mov    %ebx,%edi
  800cf0:	89 de                	mov    %ebx,%esi
  800cf2:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cf4:	85 c0                	test   %eax,%eax
  800cf6:	7f 08                	jg     800d00 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cfb:	5b                   	pop    %ebx
  800cfc:	5e                   	pop    %esi
  800cfd:	5f                   	pop    %edi
  800cfe:	5d                   	pop    %ebp
  800cff:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d00:	83 ec 0c             	sub    $0xc,%esp
  800d03:	50                   	push   %eax
  800d04:	6a 09                	push   $0x9
  800d06:	68 ff 25 80 00       	push   $0x8025ff
  800d0b:	6a 23                	push   $0x23
  800d0d:	68 1c 26 80 00       	push   $0x80261c
  800d12:	e8 9a 10 00 00       	call   801db1 <_panic>

00800d17 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d17:	55                   	push   %ebp
  800d18:	89 e5                	mov    %esp,%ebp
  800d1a:	57                   	push   %edi
  800d1b:	56                   	push   %esi
  800d1c:	53                   	push   %ebx
  800d1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d20:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d25:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800d30:	89 df                	mov    %ebx,%edi
  800d32:	89 de                	mov    %ebx,%esi
  800d34:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d36:	85 c0                	test   %eax,%eax
  800d38:	7f 08                	jg     800d42 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5f                   	pop    %edi
  800d40:	5d                   	pop    %ebp
  800d41:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d42:	83 ec 0c             	sub    $0xc,%esp
  800d45:	50                   	push   %eax
  800d46:	6a 0a                	push   $0xa
  800d48:	68 ff 25 80 00       	push   $0x8025ff
  800d4d:	6a 23                	push   $0x23
  800d4f:	68 1c 26 80 00       	push   $0x80261c
  800d54:	e8 58 10 00 00       	call   801db1 <_panic>

00800d59 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d59:	55                   	push   %ebp
  800d5a:	89 e5                	mov    %esp,%ebp
  800d5c:	57                   	push   %edi
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5f:	be 00 00 00 00       	mov    $0x0,%esi
  800d64:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d69:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d6c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d72:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d75:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    

00800d7c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d7c:	55                   	push   %ebp
  800d7d:	89 e5                	mov    %esp,%ebp
  800d7f:	57                   	push   %edi
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d85:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d8a:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d92:	89 cb                	mov    %ecx,%ebx
  800d94:	89 cf                	mov    %ecx,%edi
  800d96:	89 ce                	mov    %ecx,%esi
  800d98:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d9a:	85 c0                	test   %eax,%eax
  800d9c:	7f 08                	jg     800da6 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da1:	5b                   	pop    %ebx
  800da2:	5e                   	pop    %esi
  800da3:	5f                   	pop    %edi
  800da4:	5d                   	pop    %ebp
  800da5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800da6:	83 ec 0c             	sub    $0xc,%esp
  800da9:	50                   	push   %eax
  800daa:	6a 0e                	push   $0xe
  800dac:	68 ff 25 80 00       	push   $0x8025ff
  800db1:	6a 23                	push   $0x23
  800db3:	68 1c 26 80 00       	push   $0x80261c
  800db8:	e8 f4 0f 00 00       	call   801db1 <_panic>

00800dbd <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	57                   	push   %edi
  800dc1:	56                   	push   %esi
  800dc2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dc3:	be 00 00 00 00       	mov    $0x0,%esi
  800dc8:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dcd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd0:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dd6:	89 f7                	mov    %esi,%edi
  800dd8:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dda:	5b                   	pop    %ebx
  800ddb:	5e                   	pop    %esi
  800ddc:	5f                   	pop    %edi
  800ddd:	5d                   	pop    %ebp
  800dde:	c3                   	ret    

00800ddf <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
  800de2:	57                   	push   %edi
  800de3:	56                   	push   %esi
  800de4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800de5:	be 00 00 00 00       	mov    $0x0,%esi
  800dea:	b8 10 00 00 00       	mov    $0x10,%eax
  800def:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df2:	8b 55 08             	mov    0x8(%ebp),%edx
  800df5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800df8:	89 f7                	mov    %esi,%edi
  800dfa:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dfc:	5b                   	pop    %ebx
  800dfd:	5e                   	pop    %esi
  800dfe:	5f                   	pop    %edi
  800dff:	5d                   	pop    %ebp
  800e00:	c3                   	ret    

00800e01 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	57                   	push   %edi
  800e05:	56                   	push   %esi
  800e06:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e07:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e0c:	b8 11 00 00 00       	mov    $0x11,%eax
  800e11:	8b 55 08             	mov    0x8(%ebp),%edx
  800e14:	89 cb                	mov    %ecx,%ebx
  800e16:	89 cf                	mov    %ecx,%edi
  800e18:	89 ce                	mov    %ecx,%esi
  800e1a:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e1c:	5b                   	pop    %ebx
  800e1d:	5e                   	pop    %esi
  800e1e:	5f                   	pop    %edi
  800e1f:	5d                   	pop    %ebp
  800e20:	c3                   	ret    

00800e21 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e21:	55                   	push   %ebp
  800e22:	89 e5                	mov    %esp,%ebp
  800e24:	56                   	push   %esi
  800e25:	53                   	push   %ebx
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e29:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800e2b:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e2f:	0f 84 84 00 00 00    	je     800eb9 <pgfault+0x98>
  800e35:	89 d8                	mov    %ebx,%eax
  800e37:	c1 e8 16             	shr    $0x16,%eax
  800e3a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e41:	a8 01                	test   $0x1,%al
  800e43:	74 74                	je     800eb9 <pgfault+0x98>
  800e45:	89 d8                	mov    %ebx,%eax
  800e47:	c1 e8 0c             	shr    $0xc,%eax
  800e4a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e51:	f6 c4 08             	test   $0x8,%ah
  800e54:	74 63                	je     800eb9 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800e56:	e8 f2 fc ff ff       	call   800b4d <sys_getenvid>
  800e5b:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800e5d:	83 ec 04             	sub    $0x4,%esp
  800e60:	6a 07                	push   $0x7
  800e62:	68 00 f0 7f 00       	push   $0x7ff000
  800e67:	50                   	push   %eax
  800e68:	e8 ff fc ff ff       	call   800b6c <sys_page_alloc>
  800e6d:	83 c4 10             	add    $0x10,%esp
  800e70:	85 c0                	test   %eax,%eax
  800e72:	78 5b                	js     800ecf <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800e74:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800e7a:	83 ec 04             	sub    $0x4,%esp
  800e7d:	68 00 10 00 00       	push   $0x1000
  800e82:	53                   	push   %ebx
  800e83:	68 00 f0 7f 00       	push   $0x7ff000
  800e88:	e8 03 fb ff ff       	call   800990 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800e8d:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800e94:	53                   	push   %ebx
  800e95:	56                   	push   %esi
  800e96:	68 00 f0 7f 00       	push   $0x7ff000
  800e9b:	56                   	push   %esi
  800e9c:	e8 0e fd ff ff       	call   800baf <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800ea1:	83 c4 18             	add    $0x18,%esp
  800ea4:	68 00 f0 7f 00       	push   $0x7ff000
  800ea9:	56                   	push   %esi
  800eaa:	e8 42 fd ff ff       	call   800bf1 <sys_page_unmap>

}
  800eaf:	83 c4 10             	add    $0x10,%esp
  800eb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800eb5:	5b                   	pop    %ebx
  800eb6:	5e                   	pop    %esi
  800eb7:	5d                   	pop    %ebp
  800eb8:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800eb9:	68 2c 26 80 00       	push   $0x80262c
  800ebe:	68 b6 26 80 00       	push   $0x8026b6
  800ec3:	6a 1c                	push   $0x1c
  800ec5:	68 cb 26 80 00       	push   $0x8026cb
  800eca:	e8 e2 0e 00 00       	call   801db1 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800ecf:	68 7c 26 80 00       	push   $0x80267c
  800ed4:	68 b6 26 80 00       	push   $0x8026b6
  800ed9:	6a 26                	push   $0x26
  800edb:	68 cb 26 80 00       	push   $0x8026cb
  800ee0:	e8 cc 0e 00 00       	call   801db1 <_panic>

00800ee5 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800ee5:	55                   	push   %ebp
  800ee6:	89 e5                	mov    %esp,%ebp
  800ee8:	57                   	push   %edi
  800ee9:	56                   	push   %esi
  800eea:	53                   	push   %ebx
  800eeb:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800eee:	68 21 0e 80 00       	push   $0x800e21
  800ef3:	e8 38 0f 00 00       	call   801e30 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800ef8:	b8 07 00 00 00       	mov    $0x7,%eax
  800efd:	cd 30                	int    $0x30
  800eff:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800f05:	83 c4 10             	add    $0x10,%esp
  800f08:	85 c0                	test   %eax,%eax
  800f0a:	0f 88 58 01 00 00    	js     801068 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800f10:	85 c0                	test   %eax,%eax
  800f12:	74 07                	je     800f1b <fork+0x36>
  800f14:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f19:	eb 72                	jmp    800f8d <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f1b:	e8 2d fc ff ff       	call   800b4d <sys_getenvid>
  800f20:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f25:	89 c2                	mov    %eax,%edx
  800f27:	c1 e2 05             	shl    $0x5,%edx
  800f2a:	29 c2                	sub    %eax,%edx
  800f2c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800f33:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f38:	e9 20 01 00 00       	jmp    80105d <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800f3d:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  800f44:	e8 04 fc ff ff       	call   800b4d <sys_getenvid>
  800f49:	83 ec 0c             	sub    $0xc,%esp
  800f4c:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  800f52:	57                   	push   %edi
  800f53:	56                   	push   %esi
  800f54:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f57:	56                   	push   %esi
  800f58:	50                   	push   %eax
  800f59:	e8 51 fc ff ff       	call   800baf <sys_page_map>
  800f5e:	83 c4 20             	add    $0x20,%esp
  800f61:	eb 18                	jmp    800f7b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  800f63:	e8 e5 fb ff ff       	call   800b4d <sys_getenvid>
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	6a 05                	push   $0x5
  800f6d:	56                   	push   %esi
  800f6e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f71:	56                   	push   %esi
  800f72:	50                   	push   %eax
  800f73:	e8 37 fc ff ff       	call   800baf <sys_page_map>
  800f78:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  800f7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800f81:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800f87:	0f 84 8f 00 00 00    	je     80101c <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  800f8d:	89 d8                	mov    %ebx,%eax
  800f8f:	c1 e8 16             	shr    $0x16,%eax
  800f92:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800f99:	a8 01                	test   $0x1,%al
  800f9b:	74 de                	je     800f7b <fork+0x96>
  800f9d:	89 d8                	mov    %ebx,%eax
  800f9f:	c1 e8 0c             	shr    $0xc,%eax
  800fa2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fa9:	a8 04                	test   $0x4,%al
  800fab:	74 ce                	je     800f7b <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  800fad:	89 de                	mov    %ebx,%esi
  800faf:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  800fb5:	89 f0                	mov    %esi,%eax
  800fb7:	c1 e8 0c             	shr    $0xc,%eax
  800fba:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fc1:	f6 c6 04             	test   $0x4,%dh
  800fc4:	0f 85 73 ff ff ff    	jne    800f3d <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  800fca:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd1:	a9 02 08 00 00       	test   $0x802,%eax
  800fd6:	74 8b                	je     800f63 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  800fd8:	e8 70 fb ff ff       	call   800b4d <sys_getenvid>
  800fdd:	83 ec 0c             	sub    $0xc,%esp
  800fe0:	68 05 08 00 00       	push   $0x805
  800fe5:	56                   	push   %esi
  800fe6:	ff 75 e4             	pushl  -0x1c(%ebp)
  800fe9:	56                   	push   %esi
  800fea:	50                   	push   %eax
  800feb:	e8 bf fb ff ff       	call   800baf <sys_page_map>
  800ff0:	83 c4 20             	add    $0x20,%esp
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	78 84                	js     800f7b <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  800ff7:	e8 51 fb ff ff       	call   800b4d <sys_getenvid>
  800ffc:	89 c7                	mov    %eax,%edi
  800ffe:	e8 4a fb ff ff       	call   800b4d <sys_getenvid>
  801003:	83 ec 0c             	sub    $0xc,%esp
  801006:	68 05 08 00 00       	push   $0x805
  80100b:	56                   	push   %esi
  80100c:	57                   	push   %edi
  80100d:	56                   	push   %esi
  80100e:	50                   	push   %eax
  80100f:	e8 9b fb ff ff       	call   800baf <sys_page_map>
  801014:	83 c4 20             	add    $0x20,%esp
  801017:	e9 5f ff ff ff       	jmp    800f7b <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  80101c:	83 ec 04             	sub    $0x4,%esp
  80101f:	6a 07                	push   $0x7
  801021:	68 00 f0 bf ee       	push   $0xeebff000
  801026:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801029:	57                   	push   %edi
  80102a:	e8 3d fb ff ff       	call   800b6c <sys_page_alloc>
  80102f:	83 c4 10             	add    $0x10,%esp
  801032:	85 c0                	test   %eax,%eax
  801034:	78 3b                	js     801071 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801036:	83 ec 08             	sub    $0x8,%esp
  801039:	68 76 1e 80 00       	push   $0x801e76
  80103e:	57                   	push   %edi
  80103f:	e8 d3 fc ff ff       	call   800d17 <sys_env_set_pgfault_upcall>
  801044:	83 c4 10             	add    $0x10,%esp
  801047:	85 c0                	test   %eax,%eax
  801049:	78 2f                	js     80107a <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  80104b:	83 ec 08             	sub    $0x8,%esp
  80104e:	6a 02                	push   $0x2
  801050:	57                   	push   %edi
  801051:	e8 fc fb ff ff       	call   800c52 <sys_env_set_status>
	if (temp < 0) {
  801056:	83 c4 10             	add    $0x10,%esp
  801059:	85 c0                	test   %eax,%eax
  80105b:	78 26                	js     801083 <fork+0x19e>
		return -1;
	}

	return childid;
}
  80105d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801060:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801063:	5b                   	pop    %ebx
  801064:	5e                   	pop    %esi
  801065:	5f                   	pop    %edi
  801066:	5d                   	pop    %ebp
  801067:	c3                   	ret    
		return -1;
  801068:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80106f:	eb ec                	jmp    80105d <fork+0x178>
		return -1;
  801071:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801078:	eb e3                	jmp    80105d <fork+0x178>
		return -1;
  80107a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801081:	eb da                	jmp    80105d <fork+0x178>
		return -1;
  801083:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80108a:	eb d1                	jmp    80105d <fork+0x178>

0080108c <sfork>:

// Challenge!
int
sfork(void)
{
  80108c:	55                   	push   %ebp
  80108d:	89 e5                	mov    %esp,%ebp
  80108f:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801092:	68 d6 26 80 00       	push   $0x8026d6
  801097:	68 85 00 00 00       	push   $0x85
  80109c:	68 cb 26 80 00       	push   $0x8026cb
  8010a1:	e8 0b 0d 00 00       	call   801db1 <_panic>

008010a6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010a6:	55                   	push   %ebp
  8010a7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	05 00 00 00 30       	add    $0x30000000,%eax
  8010b1:	c1 e8 0c             	shr    $0xc,%eax
}
  8010b4:	5d                   	pop    %ebp
  8010b5:	c3                   	ret    

008010b6 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bc:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010c1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010c6:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010d3:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8010d8:	89 c2                	mov    %eax,%edx
  8010da:	c1 ea 16             	shr    $0x16,%edx
  8010dd:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8010e4:	f6 c2 01             	test   $0x1,%dl
  8010e7:	74 2a                	je     801113 <fd_alloc+0x46>
  8010e9:	89 c2                	mov    %eax,%edx
  8010eb:	c1 ea 0c             	shr    $0xc,%edx
  8010ee:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8010f5:	f6 c2 01             	test   $0x1,%dl
  8010f8:	74 19                	je     801113 <fd_alloc+0x46>
  8010fa:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8010ff:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801104:	75 d2                	jne    8010d8 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801106:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80110c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801111:	eb 07                	jmp    80111a <fd_alloc+0x4d>
			*fd_store = fd;
  801113:	89 01                	mov    %eax,(%ecx)
			return 0;
  801115:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80111a:	5d                   	pop    %ebp
  80111b:	c3                   	ret    

0080111c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80111c:	55                   	push   %ebp
  80111d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80111f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801123:	77 39                	ja     80115e <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
  801128:	c1 e0 0c             	shl    $0xc,%eax
  80112b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801130:	89 c2                	mov    %eax,%edx
  801132:	c1 ea 16             	shr    $0x16,%edx
  801135:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80113c:	f6 c2 01             	test   $0x1,%dl
  80113f:	74 24                	je     801165 <fd_lookup+0x49>
  801141:	89 c2                	mov    %eax,%edx
  801143:	c1 ea 0c             	shr    $0xc,%edx
  801146:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80114d:	f6 c2 01             	test   $0x1,%dl
  801150:	74 1a                	je     80116c <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801152:	8b 55 0c             	mov    0xc(%ebp),%edx
  801155:	89 02                	mov    %eax,(%edx)
	return 0;
  801157:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80115c:	5d                   	pop    %ebp
  80115d:	c3                   	ret    
		return -E_INVAL;
  80115e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801163:	eb f7                	jmp    80115c <fd_lookup+0x40>
		return -E_INVAL;
  801165:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80116a:	eb f0                	jmp    80115c <fd_lookup+0x40>
  80116c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801171:	eb e9                	jmp    80115c <fd_lookup+0x40>

00801173 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801173:	55                   	push   %ebp
  801174:	89 e5                	mov    %esp,%ebp
  801176:	83 ec 08             	sub    $0x8,%esp
  801179:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80117c:	ba 68 27 80 00       	mov    $0x802768,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801181:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801186:	39 08                	cmp    %ecx,(%eax)
  801188:	74 33                	je     8011bd <dev_lookup+0x4a>
  80118a:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80118d:	8b 02                	mov    (%edx),%eax
  80118f:	85 c0                	test   %eax,%eax
  801191:	75 f3                	jne    801186 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801193:	a1 04 40 80 00       	mov    0x804004,%eax
  801198:	8b 40 48             	mov    0x48(%eax),%eax
  80119b:	83 ec 04             	sub    $0x4,%esp
  80119e:	51                   	push   %ecx
  80119f:	50                   	push   %eax
  8011a0:	68 ec 26 80 00       	push   $0x8026ec
  8011a5:	e8 05 f0 ff ff       	call   8001af <cprintf>
	*dev = 0;
  8011aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011b3:	83 c4 10             	add    $0x10,%esp
  8011b6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    
			*dev = devtab[i];
  8011bd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011c0:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011c2:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c7:	eb f2                	jmp    8011bb <dev_lookup+0x48>

008011c9 <fd_close>:
{
  8011c9:	55                   	push   %ebp
  8011ca:	89 e5                	mov    %esp,%ebp
  8011cc:	57                   	push   %edi
  8011cd:	56                   	push   %esi
  8011ce:	53                   	push   %ebx
  8011cf:	83 ec 1c             	sub    $0x1c,%esp
  8011d2:	8b 75 08             	mov    0x8(%ebp),%esi
  8011d5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011d8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011db:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8011dc:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8011e2:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8011e5:	50                   	push   %eax
  8011e6:	e8 31 ff ff ff       	call   80111c <fd_lookup>
  8011eb:	89 c7                	mov    %eax,%edi
  8011ed:	83 c4 08             	add    $0x8,%esp
  8011f0:	85 c0                	test   %eax,%eax
  8011f2:	78 05                	js     8011f9 <fd_close+0x30>
	    || fd != fd2)
  8011f4:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8011f7:	74 13                	je     80120c <fd_close+0x43>
		return (must_exist ? r : 0);
  8011f9:	84 db                	test   %bl,%bl
  8011fb:	75 05                	jne    801202 <fd_close+0x39>
  8011fd:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801202:	89 f8                	mov    %edi,%eax
  801204:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80120c:	83 ec 08             	sub    $0x8,%esp
  80120f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	ff 36                	pushl  (%esi)
  801215:	e8 59 ff ff ff       	call   801173 <dev_lookup>
  80121a:	89 c7                	mov    %eax,%edi
  80121c:	83 c4 10             	add    $0x10,%esp
  80121f:	85 c0                	test   %eax,%eax
  801221:	78 15                	js     801238 <fd_close+0x6f>
		if (dev->dev_close)
  801223:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801226:	8b 40 10             	mov    0x10(%eax),%eax
  801229:	85 c0                	test   %eax,%eax
  80122b:	74 1b                	je     801248 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80122d:	83 ec 0c             	sub    $0xc,%esp
  801230:	56                   	push   %esi
  801231:	ff d0                	call   *%eax
  801233:	89 c7                	mov    %eax,%edi
  801235:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801238:	83 ec 08             	sub    $0x8,%esp
  80123b:	56                   	push   %esi
  80123c:	6a 00                	push   $0x0
  80123e:	e8 ae f9 ff ff       	call   800bf1 <sys_page_unmap>
	return r;
  801243:	83 c4 10             	add    $0x10,%esp
  801246:	eb ba                	jmp    801202 <fd_close+0x39>
			r = 0;
  801248:	bf 00 00 00 00       	mov    $0x0,%edi
  80124d:	eb e9                	jmp    801238 <fd_close+0x6f>

0080124f <close>:

int
close(int fdnum)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801255:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801258:	50                   	push   %eax
  801259:	ff 75 08             	pushl  0x8(%ebp)
  80125c:	e8 bb fe ff ff       	call   80111c <fd_lookup>
  801261:	83 c4 08             	add    $0x8,%esp
  801264:	85 c0                	test   %eax,%eax
  801266:	78 10                	js     801278 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801268:	83 ec 08             	sub    $0x8,%esp
  80126b:	6a 01                	push   $0x1
  80126d:	ff 75 f4             	pushl  -0xc(%ebp)
  801270:	e8 54 ff ff ff       	call   8011c9 <fd_close>
  801275:	83 c4 10             	add    $0x10,%esp
}
  801278:	c9                   	leave  
  801279:	c3                   	ret    

0080127a <close_all>:

void
close_all(void)
{
  80127a:	55                   	push   %ebp
  80127b:	89 e5                	mov    %esp,%ebp
  80127d:	53                   	push   %ebx
  80127e:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801281:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801286:	83 ec 0c             	sub    $0xc,%esp
  801289:	53                   	push   %ebx
  80128a:	e8 c0 ff ff ff       	call   80124f <close>
	for (i = 0; i < MAXFD; i++)
  80128f:	43                   	inc    %ebx
  801290:	83 c4 10             	add    $0x10,%esp
  801293:	83 fb 20             	cmp    $0x20,%ebx
  801296:	75 ee                	jne    801286 <close_all+0xc>
}
  801298:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80129b:	c9                   	leave  
  80129c:	c3                   	ret    

0080129d <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	57                   	push   %edi
  8012a1:	56                   	push   %esi
  8012a2:	53                   	push   %ebx
  8012a3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012a6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012a9:	50                   	push   %eax
  8012aa:	ff 75 08             	pushl  0x8(%ebp)
  8012ad:	e8 6a fe ff ff       	call   80111c <fd_lookup>
  8012b2:	89 c3                	mov    %eax,%ebx
  8012b4:	83 c4 08             	add    $0x8,%esp
  8012b7:	85 c0                	test   %eax,%eax
  8012b9:	0f 88 81 00 00 00    	js     801340 <dup+0xa3>
		return r;
	close(newfdnum);
  8012bf:	83 ec 0c             	sub    $0xc,%esp
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 85 ff ff ff       	call   80124f <close>

	newfd = INDEX2FD(newfdnum);
  8012ca:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012cd:	c1 e6 0c             	shl    $0xc,%esi
  8012d0:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8012d6:	83 c4 04             	add    $0x4,%esp
  8012d9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012dc:	e8 d5 fd ff ff       	call   8010b6 <fd2data>
  8012e1:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8012e3:	89 34 24             	mov    %esi,(%esp)
  8012e6:	e8 cb fd ff ff       	call   8010b6 <fd2data>
  8012eb:	83 c4 10             	add    $0x10,%esp
  8012ee:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8012f0:	89 d8                	mov    %ebx,%eax
  8012f2:	c1 e8 16             	shr    $0x16,%eax
  8012f5:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012fc:	a8 01                	test   $0x1,%al
  8012fe:	74 11                	je     801311 <dup+0x74>
  801300:	89 d8                	mov    %ebx,%eax
  801302:	c1 e8 0c             	shr    $0xc,%eax
  801305:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80130c:	f6 c2 01             	test   $0x1,%dl
  80130f:	75 39                	jne    80134a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801311:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801314:	89 d0                	mov    %edx,%eax
  801316:	c1 e8 0c             	shr    $0xc,%eax
  801319:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	25 07 0e 00 00       	and    $0xe07,%eax
  801328:	50                   	push   %eax
  801329:	56                   	push   %esi
  80132a:	6a 00                	push   $0x0
  80132c:	52                   	push   %edx
  80132d:	6a 00                	push   $0x0
  80132f:	e8 7b f8 ff ff       	call   800baf <sys_page_map>
  801334:	89 c3                	mov    %eax,%ebx
  801336:	83 c4 20             	add    $0x20,%esp
  801339:	85 c0                	test   %eax,%eax
  80133b:	78 31                	js     80136e <dup+0xd1>
		goto err;

	return newfdnum;
  80133d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801340:	89 d8                	mov    %ebx,%eax
  801342:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801345:	5b                   	pop    %ebx
  801346:	5e                   	pop    %esi
  801347:	5f                   	pop    %edi
  801348:	5d                   	pop    %ebp
  801349:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80134a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801351:	83 ec 0c             	sub    $0xc,%esp
  801354:	25 07 0e 00 00       	and    $0xe07,%eax
  801359:	50                   	push   %eax
  80135a:	57                   	push   %edi
  80135b:	6a 00                	push   $0x0
  80135d:	53                   	push   %ebx
  80135e:	6a 00                	push   $0x0
  801360:	e8 4a f8 ff ff       	call   800baf <sys_page_map>
  801365:	89 c3                	mov    %eax,%ebx
  801367:	83 c4 20             	add    $0x20,%esp
  80136a:	85 c0                	test   %eax,%eax
  80136c:	79 a3                	jns    801311 <dup+0x74>
	sys_page_unmap(0, newfd);
  80136e:	83 ec 08             	sub    $0x8,%esp
  801371:	56                   	push   %esi
  801372:	6a 00                	push   $0x0
  801374:	e8 78 f8 ff ff       	call   800bf1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801379:	83 c4 08             	add    $0x8,%esp
  80137c:	57                   	push   %edi
  80137d:	6a 00                	push   $0x0
  80137f:	e8 6d f8 ff ff       	call   800bf1 <sys_page_unmap>
	return r;
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	eb b7                	jmp    801340 <dup+0xa3>

00801389 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801389:	55                   	push   %ebp
  80138a:	89 e5                	mov    %esp,%ebp
  80138c:	53                   	push   %ebx
  80138d:	83 ec 14             	sub    $0x14,%esp
  801390:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801393:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801396:	50                   	push   %eax
  801397:	53                   	push   %ebx
  801398:	e8 7f fd ff ff       	call   80111c <fd_lookup>
  80139d:	83 c4 08             	add    $0x8,%esp
  8013a0:	85 c0                	test   %eax,%eax
  8013a2:	78 3f                	js     8013e3 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013aa:	50                   	push   %eax
  8013ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013ae:	ff 30                	pushl  (%eax)
  8013b0:	e8 be fd ff ff       	call   801173 <dev_lookup>
  8013b5:	83 c4 10             	add    $0x10,%esp
  8013b8:	85 c0                	test   %eax,%eax
  8013ba:	78 27                	js     8013e3 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013bc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013bf:	8b 42 08             	mov    0x8(%edx),%eax
  8013c2:	83 e0 03             	and    $0x3,%eax
  8013c5:	83 f8 01             	cmp    $0x1,%eax
  8013c8:	74 1e                	je     8013e8 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013cd:	8b 40 08             	mov    0x8(%eax),%eax
  8013d0:	85 c0                	test   %eax,%eax
  8013d2:	74 35                	je     801409 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	ff 75 10             	pushl  0x10(%ebp)
  8013da:	ff 75 0c             	pushl  0xc(%ebp)
  8013dd:	52                   	push   %edx
  8013de:	ff d0                	call   *%eax
  8013e0:	83 c4 10             	add    $0x10,%esp
}
  8013e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013e6:	c9                   	leave  
  8013e7:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8013e8:	a1 04 40 80 00       	mov    0x804004,%eax
  8013ed:	8b 40 48             	mov    0x48(%eax),%eax
  8013f0:	83 ec 04             	sub    $0x4,%esp
  8013f3:	53                   	push   %ebx
  8013f4:	50                   	push   %eax
  8013f5:	68 2d 27 80 00       	push   $0x80272d
  8013fa:	e8 b0 ed ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  8013ff:	83 c4 10             	add    $0x10,%esp
  801402:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801407:	eb da                	jmp    8013e3 <read+0x5a>
		return -E_NOT_SUPP;
  801409:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80140e:	eb d3                	jmp    8013e3 <read+0x5a>

00801410 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	53                   	push   %ebx
  801416:	83 ec 0c             	sub    $0xc,%esp
  801419:	8b 7d 08             	mov    0x8(%ebp),%edi
  80141c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80141f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801424:	39 f3                	cmp    %esi,%ebx
  801426:	73 25                	jae    80144d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801428:	83 ec 04             	sub    $0x4,%esp
  80142b:	89 f0                	mov    %esi,%eax
  80142d:	29 d8                	sub    %ebx,%eax
  80142f:	50                   	push   %eax
  801430:	89 d8                	mov    %ebx,%eax
  801432:	03 45 0c             	add    0xc(%ebp),%eax
  801435:	50                   	push   %eax
  801436:	57                   	push   %edi
  801437:	e8 4d ff ff ff       	call   801389 <read>
		if (m < 0)
  80143c:	83 c4 10             	add    $0x10,%esp
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 08                	js     80144b <readn+0x3b>
			return m;
		if (m == 0)
  801443:	85 c0                	test   %eax,%eax
  801445:	74 06                	je     80144d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801447:	01 c3                	add    %eax,%ebx
  801449:	eb d9                	jmp    801424 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80144b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80144d:	89 d8                	mov    %ebx,%eax
  80144f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801452:	5b                   	pop    %ebx
  801453:	5e                   	pop    %esi
  801454:	5f                   	pop    %edi
  801455:	5d                   	pop    %ebp
  801456:	c3                   	ret    

00801457 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801457:	55                   	push   %ebp
  801458:	89 e5                	mov    %esp,%ebp
  80145a:	53                   	push   %ebx
  80145b:	83 ec 14             	sub    $0x14,%esp
  80145e:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801461:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801464:	50                   	push   %eax
  801465:	53                   	push   %ebx
  801466:	e8 b1 fc ff ff       	call   80111c <fd_lookup>
  80146b:	83 c4 08             	add    $0x8,%esp
  80146e:	85 c0                	test   %eax,%eax
  801470:	78 3a                	js     8014ac <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801472:	83 ec 08             	sub    $0x8,%esp
  801475:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801478:	50                   	push   %eax
  801479:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80147c:	ff 30                	pushl  (%eax)
  80147e:	e8 f0 fc ff ff       	call   801173 <dev_lookup>
  801483:	83 c4 10             	add    $0x10,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 22                	js     8014ac <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80148a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80148d:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801491:	74 1e                	je     8014b1 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801493:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801496:	8b 52 0c             	mov    0xc(%edx),%edx
  801499:	85 d2                	test   %edx,%edx
  80149b:	74 35                	je     8014d2 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80149d:	83 ec 04             	sub    $0x4,%esp
  8014a0:	ff 75 10             	pushl  0x10(%ebp)
  8014a3:	ff 75 0c             	pushl  0xc(%ebp)
  8014a6:	50                   	push   %eax
  8014a7:	ff d2                	call   *%edx
  8014a9:	83 c4 10             	add    $0x10,%esp
}
  8014ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014b1:	a1 04 40 80 00       	mov    0x804004,%eax
  8014b6:	8b 40 48             	mov    0x48(%eax),%eax
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	53                   	push   %ebx
  8014bd:	50                   	push   %eax
  8014be:	68 49 27 80 00       	push   $0x802749
  8014c3:	e8 e7 ec ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  8014c8:	83 c4 10             	add    $0x10,%esp
  8014cb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014d0:	eb da                	jmp    8014ac <write+0x55>
		return -E_NOT_SUPP;
  8014d2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014d7:	eb d3                	jmp    8014ac <write+0x55>

008014d9 <seek>:

int
seek(int fdnum, off_t offset)
{
  8014d9:	55                   	push   %ebp
  8014da:	89 e5                	mov    %esp,%ebp
  8014dc:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8014df:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8014e2:	50                   	push   %eax
  8014e3:	ff 75 08             	pushl  0x8(%ebp)
  8014e6:	e8 31 fc ff ff       	call   80111c <fd_lookup>
  8014eb:	83 c4 08             	add    $0x8,%esp
  8014ee:	85 c0                	test   %eax,%eax
  8014f0:	78 0e                	js     801500 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8014f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014f5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014f8:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8014fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801500:	c9                   	leave  
  801501:	c3                   	ret    

00801502 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801502:	55                   	push   %ebp
  801503:	89 e5                	mov    %esp,%ebp
  801505:	53                   	push   %ebx
  801506:	83 ec 14             	sub    $0x14,%esp
  801509:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80150c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80150f:	50                   	push   %eax
  801510:	53                   	push   %ebx
  801511:	e8 06 fc ff ff       	call   80111c <fd_lookup>
  801516:	83 c4 08             	add    $0x8,%esp
  801519:	85 c0                	test   %eax,%eax
  80151b:	78 37                	js     801554 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801523:	50                   	push   %eax
  801524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801527:	ff 30                	pushl  (%eax)
  801529:	e8 45 fc ff ff       	call   801173 <dev_lookup>
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 1f                	js     801554 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801535:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801538:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80153c:	74 1b                	je     801559 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80153e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801541:	8b 52 18             	mov    0x18(%edx),%edx
  801544:	85 d2                	test   %edx,%edx
  801546:	74 32                	je     80157a <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801548:	83 ec 08             	sub    $0x8,%esp
  80154b:	ff 75 0c             	pushl  0xc(%ebp)
  80154e:	50                   	push   %eax
  80154f:	ff d2                	call   *%edx
  801551:	83 c4 10             	add    $0x10,%esp
}
  801554:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801557:	c9                   	leave  
  801558:	c3                   	ret    
			thisenv->env_id, fdnum);
  801559:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80155e:	8b 40 48             	mov    0x48(%eax),%eax
  801561:	83 ec 04             	sub    $0x4,%esp
  801564:	53                   	push   %ebx
  801565:	50                   	push   %eax
  801566:	68 0c 27 80 00       	push   $0x80270c
  80156b:	e8 3f ec ff ff       	call   8001af <cprintf>
		return -E_INVAL;
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801578:	eb da                	jmp    801554 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80157a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80157f:	eb d3                	jmp    801554 <ftruncate+0x52>

00801581 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801581:	55                   	push   %ebp
  801582:	89 e5                	mov    %esp,%ebp
  801584:	53                   	push   %ebx
  801585:	83 ec 14             	sub    $0x14,%esp
  801588:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80158b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80158e:	50                   	push   %eax
  80158f:	ff 75 08             	pushl  0x8(%ebp)
  801592:	e8 85 fb ff ff       	call   80111c <fd_lookup>
  801597:	83 c4 08             	add    $0x8,%esp
  80159a:	85 c0                	test   %eax,%eax
  80159c:	78 4b                	js     8015e9 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80159e:	83 ec 08             	sub    $0x8,%esp
  8015a1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015a4:	50                   	push   %eax
  8015a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a8:	ff 30                	pushl  (%eax)
  8015aa:	e8 c4 fb ff ff       	call   801173 <dev_lookup>
  8015af:	83 c4 10             	add    $0x10,%esp
  8015b2:	85 c0                	test   %eax,%eax
  8015b4:	78 33                	js     8015e9 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b9:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015bd:	74 2f                	je     8015ee <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015bf:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015c2:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015c9:	00 00 00 
	stat->st_type = 0;
  8015cc:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8015d3:	00 00 00 
	stat->st_dev = dev;
  8015d6:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8015dc:	83 ec 08             	sub    $0x8,%esp
  8015df:	53                   	push   %ebx
  8015e0:	ff 75 f0             	pushl  -0x10(%ebp)
  8015e3:	ff 50 14             	call   *0x14(%eax)
  8015e6:	83 c4 10             	add    $0x10,%esp
}
  8015e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8015ec:	c9                   	leave  
  8015ed:	c3                   	ret    
		return -E_NOT_SUPP;
  8015ee:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015f3:	eb f4                	jmp    8015e9 <fstat+0x68>

008015f5 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8015f5:	55                   	push   %ebp
  8015f6:	89 e5                	mov    %esp,%ebp
  8015f8:	56                   	push   %esi
  8015f9:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8015fa:	83 ec 08             	sub    $0x8,%esp
  8015fd:	6a 00                	push   $0x0
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	e8 34 02 00 00       	call   80183b <open>
  801607:	89 c3                	mov    %eax,%ebx
  801609:	83 c4 10             	add    $0x10,%esp
  80160c:	85 c0                	test   %eax,%eax
  80160e:	78 1b                	js     80162b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801610:	83 ec 08             	sub    $0x8,%esp
  801613:	ff 75 0c             	pushl  0xc(%ebp)
  801616:	50                   	push   %eax
  801617:	e8 65 ff ff ff       	call   801581 <fstat>
  80161c:	89 c6                	mov    %eax,%esi
	close(fd);
  80161e:	89 1c 24             	mov    %ebx,(%esp)
  801621:	e8 29 fc ff ff       	call   80124f <close>
	return r;
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 f3                	mov    %esi,%ebx
}
  80162b:	89 d8                	mov    %ebx,%eax
  80162d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801630:	5b                   	pop    %ebx
  801631:	5e                   	pop    %esi
  801632:	5d                   	pop    %ebp
  801633:	c3                   	ret    

00801634 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	89 c6                	mov    %eax,%esi
  80163b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80163d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801644:	74 27                	je     80166d <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801646:	6a 07                	push   $0x7
  801648:	68 00 50 80 00       	push   $0x805000
  80164d:	56                   	push   %esi
  80164e:	ff 35 00 40 80 00    	pushl  0x804000
  801654:	e8 cc 08 00 00       	call   801f25 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801659:	83 c4 0c             	add    $0xc,%esp
  80165c:	6a 00                	push   $0x0
  80165e:	53                   	push   %ebx
  80165f:	6a 00                	push   $0x0
  801661:	e8 36 08 00 00       	call   801e9c <ipc_recv>
}
  801666:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801669:	5b                   	pop    %ebx
  80166a:	5e                   	pop    %esi
  80166b:	5d                   	pop    %ebp
  80166c:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80166d:	83 ec 0c             	sub    $0xc,%esp
  801670:	6a 01                	push   $0x1
  801672:	e8 0a 09 00 00       	call   801f81 <ipc_find_env>
  801677:	a3 00 40 80 00       	mov    %eax,0x804000
  80167c:	83 c4 10             	add    $0x10,%esp
  80167f:	eb c5                	jmp    801646 <fsipc+0x12>

00801681 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801681:	55                   	push   %ebp
  801682:	89 e5                	mov    %esp,%ebp
  801684:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801687:	8b 45 08             	mov    0x8(%ebp),%eax
  80168a:	8b 40 0c             	mov    0xc(%eax),%eax
  80168d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801692:	8b 45 0c             	mov    0xc(%ebp),%eax
  801695:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80169a:	ba 00 00 00 00       	mov    $0x0,%edx
  80169f:	b8 02 00 00 00       	mov    $0x2,%eax
  8016a4:	e8 8b ff ff ff       	call   801634 <fsipc>
}
  8016a9:	c9                   	leave  
  8016aa:	c3                   	ret    

008016ab <devfile_flush>:
{
  8016ab:	55                   	push   %ebp
  8016ac:	89 e5                	mov    %esp,%ebp
  8016ae:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b7:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	b8 06 00 00 00       	mov    $0x6,%eax
  8016c6:	e8 69 ff ff ff       	call   801634 <fsipc>
}
  8016cb:	c9                   	leave  
  8016cc:	c3                   	ret    

008016cd <devfile_stat>:
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	53                   	push   %ebx
  8016d1:	83 ec 04             	sub    $0x4,%esp
  8016d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8016d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016da:	8b 40 0c             	mov    0xc(%eax),%eax
  8016dd:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	b8 05 00 00 00       	mov    $0x5,%eax
  8016ec:	e8 43 ff ff ff       	call   801634 <fsipc>
  8016f1:	85 c0                	test   %eax,%eax
  8016f3:	78 2c                	js     801721 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	68 00 50 80 00       	push   $0x805000
  8016fd:	53                   	push   %ebx
  8016fe:	e8 b4 f0 ff ff       	call   8007b7 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801703:	a1 80 50 80 00       	mov    0x805080,%eax
  801708:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80170e:	a1 84 50 80 00       	mov    0x805084,%eax
  801713:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801719:	83 c4 10             	add    $0x10,%esp
  80171c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801721:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801724:	c9                   	leave  
  801725:	c3                   	ret    

00801726 <devfile_write>:
{
  801726:	55                   	push   %ebp
  801727:	89 e5                	mov    %esp,%ebp
  801729:	53                   	push   %ebx
  80172a:	83 ec 04             	sub    $0x4,%esp
  80172d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801730:	89 d8                	mov    %ebx,%eax
  801732:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801738:	76 05                	jbe    80173f <devfile_write+0x19>
  80173a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80173f:	8b 55 08             	mov    0x8(%ebp),%edx
  801742:	8b 52 0c             	mov    0xc(%edx),%edx
  801745:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80174b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801750:	83 ec 04             	sub    $0x4,%esp
  801753:	50                   	push   %eax
  801754:	ff 75 0c             	pushl  0xc(%ebp)
  801757:	68 08 50 80 00       	push   $0x805008
  80175c:	e8 c9 f1 ff ff       	call   80092a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	b8 04 00 00 00       	mov    $0x4,%eax
  80176b:	e8 c4 fe ff ff       	call   801634 <fsipc>
  801770:	83 c4 10             	add    $0x10,%esp
  801773:	85 c0                	test   %eax,%eax
  801775:	78 0b                	js     801782 <devfile_write+0x5c>
	assert(r <= n);
  801777:	39 c3                	cmp    %eax,%ebx
  801779:	72 0c                	jb     801787 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80177b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801780:	7f 1e                	jg     8017a0 <devfile_write+0x7a>
}
  801782:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801785:	c9                   	leave  
  801786:	c3                   	ret    
	assert(r <= n);
  801787:	68 78 27 80 00       	push   $0x802778
  80178c:	68 b6 26 80 00       	push   $0x8026b6
  801791:	68 98 00 00 00       	push   $0x98
  801796:	68 7f 27 80 00       	push   $0x80277f
  80179b:	e8 11 06 00 00       	call   801db1 <_panic>
	assert(r <= PGSIZE);
  8017a0:	68 8a 27 80 00       	push   $0x80278a
  8017a5:	68 b6 26 80 00       	push   $0x8026b6
  8017aa:	68 99 00 00 00       	push   $0x99
  8017af:	68 7f 27 80 00       	push   $0x80277f
  8017b4:	e8 f8 05 00 00       	call   801db1 <_panic>

008017b9 <devfile_read>:
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
  8017bc:	56                   	push   %esi
  8017bd:	53                   	push   %ebx
  8017be:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c7:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017cc:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8017d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d7:	b8 03 00 00 00       	mov    $0x3,%eax
  8017dc:	e8 53 fe ff ff       	call   801634 <fsipc>
  8017e1:	89 c3                	mov    %eax,%ebx
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 1f                	js     801806 <devfile_read+0x4d>
	assert(r <= n);
  8017e7:	39 c6                	cmp    %eax,%esi
  8017e9:	72 24                	jb     80180f <devfile_read+0x56>
	assert(r <= PGSIZE);
  8017eb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017f0:	7f 33                	jg     801825 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	50                   	push   %eax
  8017f6:	68 00 50 80 00       	push   $0x805000
  8017fb:	ff 75 0c             	pushl  0xc(%ebp)
  8017fe:	e8 27 f1 ff ff       	call   80092a <memmove>
	return r;
  801803:	83 c4 10             	add    $0x10,%esp
}
  801806:	89 d8                	mov    %ebx,%eax
  801808:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5d                   	pop    %ebp
  80180e:	c3                   	ret    
	assert(r <= n);
  80180f:	68 78 27 80 00       	push   $0x802778
  801814:	68 b6 26 80 00       	push   $0x8026b6
  801819:	6a 7c                	push   $0x7c
  80181b:	68 7f 27 80 00       	push   $0x80277f
  801820:	e8 8c 05 00 00       	call   801db1 <_panic>
	assert(r <= PGSIZE);
  801825:	68 8a 27 80 00       	push   $0x80278a
  80182a:	68 b6 26 80 00       	push   $0x8026b6
  80182f:	6a 7d                	push   $0x7d
  801831:	68 7f 27 80 00       	push   $0x80277f
  801836:	e8 76 05 00 00       	call   801db1 <_panic>

0080183b <open>:
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	56                   	push   %esi
  80183f:	53                   	push   %ebx
  801840:	83 ec 1c             	sub    $0x1c,%esp
  801843:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801846:	56                   	push   %esi
  801847:	e8 38 ef ff ff       	call   800784 <strlen>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801854:	7f 6c                	jg     8018c2 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801856:	83 ec 0c             	sub    $0xc,%esp
  801859:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185c:	50                   	push   %eax
  80185d:	e8 6b f8 ff ff       	call   8010cd <fd_alloc>
  801862:	89 c3                	mov    %eax,%ebx
  801864:	83 c4 10             	add    $0x10,%esp
  801867:	85 c0                	test   %eax,%eax
  801869:	78 3c                	js     8018a7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80186b:	83 ec 08             	sub    $0x8,%esp
  80186e:	56                   	push   %esi
  80186f:	68 00 50 80 00       	push   $0x805000
  801874:	e8 3e ef ff ff       	call   8007b7 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801879:	8b 45 0c             	mov    0xc(%ebp),%eax
  80187c:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801881:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801884:	b8 01 00 00 00       	mov    $0x1,%eax
  801889:	e8 a6 fd ff ff       	call   801634 <fsipc>
  80188e:	89 c3                	mov    %eax,%ebx
  801890:	83 c4 10             	add    $0x10,%esp
  801893:	85 c0                	test   %eax,%eax
  801895:	78 19                	js     8018b0 <open+0x75>
	return fd2num(fd);
  801897:	83 ec 0c             	sub    $0xc,%esp
  80189a:	ff 75 f4             	pushl  -0xc(%ebp)
  80189d:	e8 04 f8 ff ff       	call   8010a6 <fd2num>
  8018a2:	89 c3                	mov    %eax,%ebx
  8018a4:	83 c4 10             	add    $0x10,%esp
}
  8018a7:	89 d8                	mov    %ebx,%eax
  8018a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
		fd_close(fd, 0);
  8018b0:	83 ec 08             	sub    $0x8,%esp
  8018b3:	6a 00                	push   $0x0
  8018b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8018b8:	e8 0c f9 ff ff       	call   8011c9 <fd_close>
		return r;
  8018bd:	83 c4 10             	add    $0x10,%esp
  8018c0:	eb e5                	jmp    8018a7 <open+0x6c>
		return -E_BAD_PATH;
  8018c2:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018c7:	eb de                	jmp    8018a7 <open+0x6c>

008018c9 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
  8018cc:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018cf:	ba 00 00 00 00       	mov    $0x0,%edx
  8018d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8018d9:	e8 56 fd ff ff       	call   801634 <fsipc>
}
  8018de:	c9                   	leave  
  8018df:	c3                   	ret    

008018e0 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	56                   	push   %esi
  8018e4:	53                   	push   %ebx
  8018e5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8018e8:	83 ec 0c             	sub    $0xc,%esp
  8018eb:	ff 75 08             	pushl  0x8(%ebp)
  8018ee:	e8 c3 f7 ff ff       	call   8010b6 <fd2data>
  8018f3:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8018f5:	83 c4 08             	add    $0x8,%esp
  8018f8:	68 96 27 80 00       	push   $0x802796
  8018fd:	53                   	push   %ebx
  8018fe:	e8 b4 ee ff ff       	call   8007b7 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801903:	8b 46 04             	mov    0x4(%esi),%eax
  801906:	2b 06                	sub    (%esi),%eax
  801908:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80190e:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801915:	10 00 00 
	stat->st_dev = &devpipe;
  801918:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80191f:	30 80 00 
	return 0;
}
  801922:	b8 00 00 00 00       	mov    $0x0,%eax
  801927:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192a:	5b                   	pop    %ebx
  80192b:	5e                   	pop    %esi
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	53                   	push   %ebx
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801938:	53                   	push   %ebx
  801939:	6a 00                	push   $0x0
  80193b:	e8 b1 f2 ff ff       	call   800bf1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801940:	89 1c 24             	mov    %ebx,(%esp)
  801943:	e8 6e f7 ff ff       	call   8010b6 <fd2data>
  801948:	83 c4 08             	add    $0x8,%esp
  80194b:	50                   	push   %eax
  80194c:	6a 00                	push   $0x0
  80194e:	e8 9e f2 ff ff       	call   800bf1 <sys_page_unmap>
}
  801953:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <_pipeisclosed>:
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
  80195b:	57                   	push   %edi
  80195c:	56                   	push   %esi
  80195d:	53                   	push   %ebx
  80195e:	83 ec 1c             	sub    $0x1c,%esp
  801961:	89 c7                	mov    %eax,%edi
  801963:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801965:	a1 04 40 80 00       	mov    0x804004,%eax
  80196a:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80196d:	83 ec 0c             	sub    $0xc,%esp
  801970:	57                   	push   %edi
  801971:	e8 4d 06 00 00       	call   801fc3 <pageref>
  801976:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801979:	89 34 24             	mov    %esi,(%esp)
  80197c:	e8 42 06 00 00       	call   801fc3 <pageref>
		nn = thisenv->env_runs;
  801981:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801987:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80198a:	83 c4 10             	add    $0x10,%esp
  80198d:	39 cb                	cmp    %ecx,%ebx
  80198f:	74 1b                	je     8019ac <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801991:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801994:	75 cf                	jne    801965 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801996:	8b 42 58             	mov    0x58(%edx),%eax
  801999:	6a 01                	push   $0x1
  80199b:	50                   	push   %eax
  80199c:	53                   	push   %ebx
  80199d:	68 9d 27 80 00       	push   $0x80279d
  8019a2:	e8 08 e8 ff ff       	call   8001af <cprintf>
  8019a7:	83 c4 10             	add    $0x10,%esp
  8019aa:	eb b9                	jmp    801965 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019ac:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019af:	0f 94 c0             	sete   %al
  8019b2:	0f b6 c0             	movzbl %al,%eax
}
  8019b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019b8:	5b                   	pop    %ebx
  8019b9:	5e                   	pop    %esi
  8019ba:	5f                   	pop    %edi
  8019bb:	5d                   	pop    %ebp
  8019bc:	c3                   	ret    

008019bd <devpipe_write>:
{
  8019bd:	55                   	push   %ebp
  8019be:	89 e5                	mov    %esp,%ebp
  8019c0:	57                   	push   %edi
  8019c1:	56                   	push   %esi
  8019c2:	53                   	push   %ebx
  8019c3:	83 ec 18             	sub    $0x18,%esp
  8019c6:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019c9:	56                   	push   %esi
  8019ca:	e8 e7 f6 ff ff       	call   8010b6 <fd2data>
  8019cf:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019d1:	83 c4 10             	add    $0x10,%esp
  8019d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8019d9:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8019dc:	74 41                	je     801a1f <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8019de:	8b 53 04             	mov    0x4(%ebx),%edx
  8019e1:	8b 03                	mov    (%ebx),%eax
  8019e3:	83 c0 20             	add    $0x20,%eax
  8019e6:	39 c2                	cmp    %eax,%edx
  8019e8:	72 14                	jb     8019fe <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8019ea:	89 da                	mov    %ebx,%edx
  8019ec:	89 f0                	mov    %esi,%eax
  8019ee:	e8 65 ff ff ff       	call   801958 <_pipeisclosed>
  8019f3:	85 c0                	test   %eax,%eax
  8019f5:	75 2c                	jne    801a23 <devpipe_write+0x66>
			sys_yield();
  8019f7:	e8 37 f2 ff ff       	call   800c33 <sys_yield>
  8019fc:	eb e0                	jmp    8019de <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8019fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a01:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801a0b:	78 0b                	js     801a18 <devpipe_write+0x5b>
  801a0d:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801a11:	42                   	inc    %edx
  801a12:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a15:	47                   	inc    %edi
  801a16:	eb c1                	jmp    8019d9 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a18:	48                   	dec    %eax
  801a19:	83 c8 e0             	or     $0xffffffe0,%eax
  801a1c:	40                   	inc    %eax
  801a1d:	eb ee                	jmp    801a0d <devpipe_write+0x50>
	return i;
  801a1f:	89 f8                	mov    %edi,%eax
  801a21:	eb 05                	jmp    801a28 <devpipe_write+0x6b>
				return 0;
  801a23:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a2b:	5b                   	pop    %ebx
  801a2c:	5e                   	pop    %esi
  801a2d:	5f                   	pop    %edi
  801a2e:	5d                   	pop    %ebp
  801a2f:	c3                   	ret    

00801a30 <devpipe_read>:
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
  801a33:	57                   	push   %edi
  801a34:	56                   	push   %esi
  801a35:	53                   	push   %ebx
  801a36:	83 ec 18             	sub    $0x18,%esp
  801a39:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a3c:	57                   	push   %edi
  801a3d:	e8 74 f6 ff ff       	call   8010b6 <fd2data>
  801a42:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a4c:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801a4f:	74 46                	je     801a97 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801a51:	8b 06                	mov    (%esi),%eax
  801a53:	3b 46 04             	cmp    0x4(%esi),%eax
  801a56:	75 22                	jne    801a7a <devpipe_read+0x4a>
			if (i > 0)
  801a58:	85 db                	test   %ebx,%ebx
  801a5a:	74 0a                	je     801a66 <devpipe_read+0x36>
				return i;
  801a5c:	89 d8                	mov    %ebx,%eax
}
  801a5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a61:	5b                   	pop    %ebx
  801a62:	5e                   	pop    %esi
  801a63:	5f                   	pop    %edi
  801a64:	5d                   	pop    %ebp
  801a65:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801a66:	89 f2                	mov    %esi,%edx
  801a68:	89 f8                	mov    %edi,%eax
  801a6a:	e8 e9 fe ff ff       	call   801958 <_pipeisclosed>
  801a6f:	85 c0                	test   %eax,%eax
  801a71:	75 28                	jne    801a9b <devpipe_read+0x6b>
			sys_yield();
  801a73:	e8 bb f1 ff ff       	call   800c33 <sys_yield>
  801a78:	eb d7                	jmp    801a51 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a7a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801a7f:	78 0f                	js     801a90 <devpipe_read+0x60>
  801a81:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801a85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801a88:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801a8b:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801a8d:	43                   	inc    %ebx
  801a8e:	eb bc                	jmp    801a4c <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801a90:	48                   	dec    %eax
  801a91:	83 c8 e0             	or     $0xffffffe0,%eax
  801a94:	40                   	inc    %eax
  801a95:	eb ea                	jmp    801a81 <devpipe_read+0x51>
	return i;
  801a97:	89 d8                	mov    %ebx,%eax
  801a99:	eb c3                	jmp    801a5e <devpipe_read+0x2e>
				return 0;
  801a9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa0:	eb bc                	jmp    801a5e <devpipe_read+0x2e>

00801aa2 <pipe>:
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	56                   	push   %esi
  801aa6:	53                   	push   %ebx
  801aa7:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801aaa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aad:	50                   	push   %eax
  801aae:	e8 1a f6 ff ff       	call   8010cd <fd_alloc>
  801ab3:	89 c3                	mov    %eax,%ebx
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	85 c0                	test   %eax,%eax
  801aba:	0f 88 2a 01 00 00    	js     801bea <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ac0:	83 ec 04             	sub    $0x4,%esp
  801ac3:	68 07 04 00 00       	push   $0x407
  801ac8:	ff 75 f4             	pushl  -0xc(%ebp)
  801acb:	6a 00                	push   $0x0
  801acd:	e8 9a f0 ff ff       	call   800b6c <sys_page_alloc>
  801ad2:	89 c3                	mov    %eax,%ebx
  801ad4:	83 c4 10             	add    $0x10,%esp
  801ad7:	85 c0                	test   %eax,%eax
  801ad9:	0f 88 0b 01 00 00    	js     801bea <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801adf:	83 ec 0c             	sub    $0xc,%esp
  801ae2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801ae5:	50                   	push   %eax
  801ae6:	e8 e2 f5 ff ff       	call   8010cd <fd_alloc>
  801aeb:	89 c3                	mov    %eax,%ebx
  801aed:	83 c4 10             	add    $0x10,%esp
  801af0:	85 c0                	test   %eax,%eax
  801af2:	0f 88 e2 00 00 00    	js     801bda <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801af8:	83 ec 04             	sub    $0x4,%esp
  801afb:	68 07 04 00 00       	push   $0x407
  801b00:	ff 75 f0             	pushl  -0x10(%ebp)
  801b03:	6a 00                	push   $0x0
  801b05:	e8 62 f0 ff ff       	call   800b6c <sys_page_alloc>
  801b0a:	89 c3                	mov    %eax,%ebx
  801b0c:	83 c4 10             	add    $0x10,%esp
  801b0f:	85 c0                	test   %eax,%eax
  801b11:	0f 88 c3 00 00 00    	js     801bda <pipe+0x138>
	va = fd2data(fd0);
  801b17:	83 ec 0c             	sub    $0xc,%esp
  801b1a:	ff 75 f4             	pushl  -0xc(%ebp)
  801b1d:	e8 94 f5 ff ff       	call   8010b6 <fd2data>
  801b22:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b24:	83 c4 0c             	add    $0xc,%esp
  801b27:	68 07 04 00 00       	push   $0x407
  801b2c:	50                   	push   %eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	e8 38 f0 ff ff       	call   800b6c <sys_page_alloc>
  801b34:	89 c3                	mov    %eax,%ebx
  801b36:	83 c4 10             	add    $0x10,%esp
  801b39:	85 c0                	test   %eax,%eax
  801b3b:	0f 88 89 00 00 00    	js     801bca <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b41:	83 ec 0c             	sub    $0xc,%esp
  801b44:	ff 75 f0             	pushl  -0x10(%ebp)
  801b47:	e8 6a f5 ff ff       	call   8010b6 <fd2data>
  801b4c:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b53:	50                   	push   %eax
  801b54:	6a 00                	push   $0x0
  801b56:	56                   	push   %esi
  801b57:	6a 00                	push   $0x0
  801b59:	e8 51 f0 ff ff       	call   800baf <sys_page_map>
  801b5e:	89 c3                	mov    %eax,%ebx
  801b60:	83 c4 20             	add    $0x20,%esp
  801b63:	85 c0                	test   %eax,%eax
  801b65:	78 55                	js     801bbc <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801b67:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b70:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801b72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b75:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801b7c:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b85:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801b87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b8a:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801b91:	83 ec 0c             	sub    $0xc,%esp
  801b94:	ff 75 f4             	pushl  -0xc(%ebp)
  801b97:	e8 0a f5 ff ff       	call   8010a6 <fd2num>
  801b9c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b9f:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ba1:	83 c4 04             	add    $0x4,%esp
  801ba4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ba7:	e8 fa f4 ff ff       	call   8010a6 <fd2num>
  801bac:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801baf:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801bb2:	83 c4 10             	add    $0x10,%esp
  801bb5:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bba:	eb 2e                	jmp    801bea <pipe+0x148>
	sys_page_unmap(0, va);
  801bbc:	83 ec 08             	sub    $0x8,%esp
  801bbf:	56                   	push   %esi
  801bc0:	6a 00                	push   $0x0
  801bc2:	e8 2a f0 ff ff       	call   800bf1 <sys_page_unmap>
  801bc7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bca:	83 ec 08             	sub    $0x8,%esp
  801bcd:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd0:	6a 00                	push   $0x0
  801bd2:	e8 1a f0 ff ff       	call   800bf1 <sys_page_unmap>
  801bd7:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801bda:	83 ec 08             	sub    $0x8,%esp
  801bdd:	ff 75 f4             	pushl  -0xc(%ebp)
  801be0:	6a 00                	push   $0x0
  801be2:	e8 0a f0 ff ff       	call   800bf1 <sys_page_unmap>
  801be7:	83 c4 10             	add    $0x10,%esp
}
  801bea:	89 d8                	mov    %ebx,%eax
  801bec:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801bef:	5b                   	pop    %ebx
  801bf0:	5e                   	pop    %esi
  801bf1:	5d                   	pop    %ebp
  801bf2:	c3                   	ret    

00801bf3 <pipeisclosed>:
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
  801bf6:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801bf9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801bfc:	50                   	push   %eax
  801bfd:	ff 75 08             	pushl  0x8(%ebp)
  801c00:	e8 17 f5 ff ff       	call   80111c <fd_lookup>
  801c05:	83 c4 10             	add    $0x10,%esp
  801c08:	85 c0                	test   %eax,%eax
  801c0a:	78 18                	js     801c24 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c0c:	83 ec 0c             	sub    $0xc,%esp
  801c0f:	ff 75 f4             	pushl  -0xc(%ebp)
  801c12:	e8 9f f4 ff ff       	call   8010b6 <fd2data>
	return _pipeisclosed(fd, p);
  801c17:	89 c2                	mov    %eax,%edx
  801c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c1c:	e8 37 fd ff ff       	call   801958 <_pipeisclosed>
  801c21:	83 c4 10             	add    $0x10,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c29:	b8 00 00 00 00       	mov    $0x0,%eax
  801c2e:	5d                   	pop    %ebp
  801c2f:	c3                   	ret    

00801c30 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
  801c33:	53                   	push   %ebx
  801c34:	83 ec 0c             	sub    $0xc,%esp
  801c37:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801c3a:	68 b5 27 80 00       	push   $0x8027b5
  801c3f:	53                   	push   %ebx
  801c40:	e8 72 eb ff ff       	call   8007b7 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801c45:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801c4c:	20 00 00 
	return 0;
}
  801c4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c54:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c57:	c9                   	leave  
  801c58:	c3                   	ret    

00801c59 <devcons_write>:
{
  801c59:	55                   	push   %ebp
  801c5a:	89 e5                	mov    %esp,%ebp
  801c5c:	57                   	push   %edi
  801c5d:	56                   	push   %esi
  801c5e:	53                   	push   %ebx
  801c5f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c65:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c6a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c70:	eb 1d                	jmp    801c8f <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	53                   	push   %ebx
  801c76:	03 45 0c             	add    0xc(%ebp),%eax
  801c79:	50                   	push   %eax
  801c7a:	57                   	push   %edi
  801c7b:	e8 aa ec ff ff       	call   80092a <memmove>
		sys_cputs(buf, m);
  801c80:	83 c4 08             	add    $0x8,%esp
  801c83:	53                   	push   %ebx
  801c84:	57                   	push   %edi
  801c85:	e8 45 ee ff ff       	call   800acf <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801c8a:	01 de                	add    %ebx,%esi
  801c8c:	83 c4 10             	add    $0x10,%esp
  801c8f:	89 f0                	mov    %esi,%eax
  801c91:	3b 75 10             	cmp    0x10(%ebp),%esi
  801c94:	73 11                	jae    801ca7 <devcons_write+0x4e>
		m = n - tot;
  801c96:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c99:	29 f3                	sub    %esi,%ebx
  801c9b:	83 fb 7f             	cmp    $0x7f,%ebx
  801c9e:	76 d2                	jbe    801c72 <devcons_write+0x19>
  801ca0:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801ca5:	eb cb                	jmp    801c72 <devcons_write+0x19>
}
  801ca7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801caa:	5b                   	pop    %ebx
  801cab:	5e                   	pop    %esi
  801cac:	5f                   	pop    %edi
  801cad:	5d                   	pop    %ebp
  801cae:	c3                   	ret    

00801caf <devcons_read>:
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801cb5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801cb9:	75 0c                	jne    801cc7 <devcons_read+0x18>
		return 0;
  801cbb:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc0:	eb 21                	jmp    801ce3 <devcons_read+0x34>
		sys_yield();
  801cc2:	e8 6c ef ff ff       	call   800c33 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801cc7:	e8 21 ee ff ff       	call   800aed <sys_cgetc>
  801ccc:	85 c0                	test   %eax,%eax
  801cce:	74 f2                	je     801cc2 <devcons_read+0x13>
	if (c < 0)
  801cd0:	85 c0                	test   %eax,%eax
  801cd2:	78 0f                	js     801ce3 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801cd4:	83 f8 04             	cmp    $0x4,%eax
  801cd7:	74 0c                	je     801ce5 <devcons_read+0x36>
	*(char*)vbuf = c;
  801cd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cdc:	88 02                	mov    %al,(%edx)
	return 1;
  801cde:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ce3:	c9                   	leave  
  801ce4:	c3                   	ret    
		return 0;
  801ce5:	b8 00 00 00 00       	mov    $0x0,%eax
  801cea:	eb f7                	jmp    801ce3 <devcons_read+0x34>

00801cec <cputchar>:
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
  801cef:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801cf8:	6a 01                	push   $0x1
  801cfa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801cfd:	50                   	push   %eax
  801cfe:	e8 cc ed ff ff       	call   800acf <sys_cputs>
}
  801d03:	83 c4 10             	add    $0x10,%esp
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <getchar>:
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d0e:	6a 01                	push   $0x1
  801d10:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d13:	50                   	push   %eax
  801d14:	6a 00                	push   $0x0
  801d16:	e8 6e f6 ff ff       	call   801389 <read>
	if (r < 0)
  801d1b:	83 c4 10             	add    $0x10,%esp
  801d1e:	85 c0                	test   %eax,%eax
  801d20:	78 08                	js     801d2a <getchar+0x22>
	if (r < 1)
  801d22:	85 c0                	test   %eax,%eax
  801d24:	7e 06                	jle    801d2c <getchar+0x24>
	return c;
  801d26:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d2a:	c9                   	leave  
  801d2b:	c3                   	ret    
		return -E_EOF;
  801d2c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d31:	eb f7                	jmp    801d2a <getchar+0x22>

00801d33 <iscons>:
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d39:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d3c:	50                   	push   %eax
  801d3d:	ff 75 08             	pushl  0x8(%ebp)
  801d40:	e8 d7 f3 ff ff       	call   80111c <fd_lookup>
  801d45:	83 c4 10             	add    $0x10,%esp
  801d48:	85 c0                	test   %eax,%eax
  801d4a:	78 11                	js     801d5d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d4f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d55:	39 10                	cmp    %edx,(%eax)
  801d57:	0f 94 c0             	sete   %al
  801d5a:	0f b6 c0             	movzbl %al,%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <opencons>:
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d65:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d68:	50                   	push   %eax
  801d69:	e8 5f f3 ff ff       	call   8010cd <fd_alloc>
  801d6e:	83 c4 10             	add    $0x10,%esp
  801d71:	85 c0                	test   %eax,%eax
  801d73:	78 3a                	js     801daf <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	68 07 04 00 00       	push   $0x407
  801d7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801d80:	6a 00                	push   $0x0
  801d82:	e8 e5 ed ff ff       	call   800b6c <sys_page_alloc>
  801d87:	83 c4 10             	add    $0x10,%esp
  801d8a:	85 c0                	test   %eax,%eax
  801d8c:	78 21                	js     801daf <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801d8e:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801d99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d9c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801da3:	83 ec 0c             	sub    $0xc,%esp
  801da6:	50                   	push   %eax
  801da7:	e8 fa f2 ff ff       	call   8010a6 <fd2num>
  801dac:	83 c4 10             	add    $0x10,%esp
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
  801db4:	57                   	push   %edi
  801db5:	56                   	push   %esi
  801db6:	53                   	push   %ebx
  801db7:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801dbd:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801dc0:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801dc6:	e8 82 ed ff ff       	call   800b4d <sys_getenvid>
  801dcb:	83 ec 04             	sub    $0x4,%esp
  801dce:	ff 75 0c             	pushl  0xc(%ebp)
  801dd1:	ff 75 08             	pushl  0x8(%ebp)
  801dd4:	53                   	push   %ebx
  801dd5:	50                   	push   %eax
  801dd6:	68 c4 27 80 00       	push   $0x8027c4
  801ddb:	68 00 01 00 00       	push   $0x100
  801de0:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801de6:	56                   	push   %esi
  801de7:	e8 7e e9 ff ff       	call   80076a <snprintf>
  801dec:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801dee:	83 c4 20             	add    $0x20,%esp
  801df1:	57                   	push   %edi
  801df2:	ff 75 10             	pushl  0x10(%ebp)
  801df5:	bf 00 01 00 00       	mov    $0x100,%edi
  801dfa:	89 f8                	mov    %edi,%eax
  801dfc:	29 d8                	sub    %ebx,%eax
  801dfe:	50                   	push   %eax
  801dff:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e02:	50                   	push   %eax
  801e03:	e8 0d e9 ff ff       	call   800715 <vsnprintf>
  801e08:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e0a:	83 c4 0c             	add    $0xc,%esp
  801e0d:	68 f4 22 80 00       	push   $0x8022f4
  801e12:	29 df                	sub    %ebx,%edi
  801e14:	57                   	push   %edi
  801e15:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e18:	50                   	push   %eax
  801e19:	e8 4c e9 ff ff       	call   80076a <snprintf>
	sys_cputs(buf, r);
  801e1e:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e21:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801e23:	53                   	push   %ebx
  801e24:	56                   	push   %esi
  801e25:	e8 a5 ec ff ff       	call   800acf <sys_cputs>
  801e2a:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e2d:	cc                   	int3   
  801e2e:	eb fd                	jmp    801e2d <_panic+0x7c>

00801e30 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e36:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e3d:	74 0a                	je     801e49 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e42:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e47:	c9                   	leave  
  801e48:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801e49:	e8 ff ec ff ff       	call   800b4d <sys_getenvid>
  801e4e:	83 ec 04             	sub    $0x4,%esp
  801e51:	6a 07                	push   $0x7
  801e53:	68 00 f0 bf ee       	push   $0xeebff000
  801e58:	50                   	push   %eax
  801e59:	e8 0e ed ff ff       	call   800b6c <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801e5e:	e8 ea ec ff ff       	call   800b4d <sys_getenvid>
  801e63:	83 c4 08             	add    $0x8,%esp
  801e66:	68 76 1e 80 00       	push   $0x801e76
  801e6b:	50                   	push   %eax
  801e6c:	e8 a6 ee ff ff       	call   800d17 <sys_env_set_pgfault_upcall>
  801e71:	83 c4 10             	add    $0x10,%esp
  801e74:	eb c9                	jmp    801e3f <set_pgfault_handler+0xf>

00801e76 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801e76:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801e77:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801e7c:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801e7e:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801e81:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801e85:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801e89:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801e8c:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801e8e:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801e92:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801e95:	61                   	popa   
	addl $4, %esp
  801e96:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801e99:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801e9a:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801e9b:	c3                   	ret    

00801e9c <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e9c:	55                   	push   %ebp
  801e9d:	89 e5                	mov    %esp,%ebp
  801e9f:	57                   	push   %edi
  801ea0:	56                   	push   %esi
  801ea1:	53                   	push   %ebx
  801ea2:	83 ec 0c             	sub    $0xc,%esp
  801ea5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ea8:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801eab:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801eae:	85 ff                	test   %edi,%edi
  801eb0:	74 53                	je     801f05 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801eb2:	83 ec 0c             	sub    $0xc,%esp
  801eb5:	57                   	push   %edi
  801eb6:	e8 c1 ee ff ff       	call   800d7c <sys_ipc_recv>
  801ebb:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801ebe:	85 db                	test   %ebx,%ebx
  801ec0:	74 0b                	je     801ecd <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801ec2:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ec8:	8b 52 74             	mov    0x74(%edx),%edx
  801ecb:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801ecd:	85 f6                	test   %esi,%esi
  801ecf:	74 0f                	je     801ee0 <ipc_recv+0x44>
  801ed1:	85 ff                	test   %edi,%edi
  801ed3:	74 0b                	je     801ee0 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801ed5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801edb:	8b 52 78             	mov    0x78(%edx),%edx
  801ede:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801ee0:	85 c0                	test   %eax,%eax
  801ee2:	74 30                	je     801f14 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801ee4:	85 db                	test   %ebx,%ebx
  801ee6:	74 06                	je     801eee <ipc_recv+0x52>
      		*from_env_store = 0;
  801ee8:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801eee:	85 f6                	test   %esi,%esi
  801ef0:	74 2c                	je     801f1e <ipc_recv+0x82>
      		*perm_store = 0;
  801ef2:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801ef8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801efd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f00:	5b                   	pop    %ebx
  801f01:	5e                   	pop    %esi
  801f02:	5f                   	pop    %edi
  801f03:	5d                   	pop    %ebp
  801f04:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801f05:	83 ec 0c             	sub    $0xc,%esp
  801f08:	6a ff                	push   $0xffffffff
  801f0a:	e8 6d ee ff ff       	call   800d7c <sys_ipc_recv>
  801f0f:	83 c4 10             	add    $0x10,%esp
  801f12:	eb aa                	jmp    801ebe <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801f14:	a1 04 40 80 00       	mov    0x804004,%eax
  801f19:	8b 40 70             	mov    0x70(%eax),%eax
  801f1c:	eb df                	jmp    801efd <ipc_recv+0x61>
		return -1;
  801f1e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f23:	eb d8                	jmp    801efd <ipc_recv+0x61>

00801f25 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f25:	55                   	push   %ebp
  801f26:	89 e5                	mov    %esp,%ebp
  801f28:	57                   	push   %edi
  801f29:	56                   	push   %esi
  801f2a:	53                   	push   %ebx
  801f2b:	83 ec 0c             	sub    $0xc,%esp
  801f2e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f31:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f34:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f37:	85 db                	test   %ebx,%ebx
  801f39:	75 22                	jne    801f5d <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801f3b:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801f40:	eb 1b                	jmp    801f5d <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f42:	68 e8 27 80 00       	push   $0x8027e8
  801f47:	68 b6 26 80 00       	push   $0x8026b6
  801f4c:	6a 48                	push   $0x48
  801f4e:	68 0c 28 80 00       	push   $0x80280c
  801f53:	e8 59 fe ff ff       	call   801db1 <_panic>
		sys_yield();
  801f58:	e8 d6 ec ff ff       	call   800c33 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801f5d:	57                   	push   %edi
  801f5e:	53                   	push   %ebx
  801f5f:	56                   	push   %esi
  801f60:	ff 75 08             	pushl  0x8(%ebp)
  801f63:	e8 f1 ed ff ff       	call   800d59 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f68:	83 c4 10             	add    $0x10,%esp
  801f6b:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f6e:	74 e8                	je     801f58 <ipc_send+0x33>
  801f70:	85 c0                	test   %eax,%eax
  801f72:	75 ce                	jne    801f42 <ipc_send+0x1d>
		sys_yield();
  801f74:	e8 ba ec ff ff       	call   800c33 <sys_yield>
		
	}
	
}
  801f79:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f7c:	5b                   	pop    %ebx
  801f7d:	5e                   	pop    %esi
  801f7e:	5f                   	pop    %edi
  801f7f:	5d                   	pop    %ebp
  801f80:	c3                   	ret    

00801f81 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f81:	55                   	push   %ebp
  801f82:	89 e5                	mov    %esp,%ebp
  801f84:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f8c:	89 c2                	mov    %eax,%edx
  801f8e:	c1 e2 05             	shl    $0x5,%edx
  801f91:	29 c2                	sub    %eax,%edx
  801f93:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801f9a:	8b 52 50             	mov    0x50(%edx),%edx
  801f9d:	39 ca                	cmp    %ecx,%edx
  801f9f:	74 0f                	je     801fb0 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801fa1:	40                   	inc    %eax
  801fa2:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fa7:	75 e3                	jne    801f8c <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fa9:	b8 00 00 00 00       	mov    $0x0,%eax
  801fae:	eb 11                	jmp    801fc1 <ipc_find_env+0x40>
			return envs[i].env_id;
  801fb0:	89 c2                	mov    %eax,%edx
  801fb2:	c1 e2 05             	shl    $0x5,%edx
  801fb5:	29 c2                	sub    %eax,%edx
  801fb7:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801fbe:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fc1:	5d                   	pop    %ebp
  801fc2:	c3                   	ret    

00801fc3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fc3:	55                   	push   %ebp
  801fc4:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc9:	c1 e8 16             	shr    $0x16,%eax
  801fcc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fd3:	a8 01                	test   $0x1,%al
  801fd5:	74 21                	je     801ff8 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801fda:	c1 e8 0c             	shr    $0xc,%eax
  801fdd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801fe4:	a8 01                	test   $0x1,%al
  801fe6:	74 17                	je     801fff <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fe8:	c1 e8 0c             	shr    $0xc,%eax
  801feb:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801ff2:	ef 
  801ff3:	0f b7 c0             	movzwl %ax,%eax
  801ff6:	eb 05                	jmp    801ffd <pageref+0x3a>
		return 0;
  801ff8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ffd:	5d                   	pop    %ebp
  801ffe:	c3                   	ret    
		return 0;
  801fff:	b8 00 00 00 00       	mov    $0x0,%eax
  802004:	eb f7                	jmp    801ffd <pageref+0x3a>
  802006:	66 90                	xchg   %ax,%ax

00802008 <__udivdi3>:
  802008:	55                   	push   %ebp
  802009:	57                   	push   %edi
  80200a:	56                   	push   %esi
  80200b:	53                   	push   %ebx
  80200c:	83 ec 1c             	sub    $0x1c,%esp
  80200f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802013:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802017:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80201b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80201f:	89 ca                	mov    %ecx,%edx
  802021:	89 f8                	mov    %edi,%eax
  802023:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802027:	85 f6                	test   %esi,%esi
  802029:	75 2d                	jne    802058 <__udivdi3+0x50>
  80202b:	39 cf                	cmp    %ecx,%edi
  80202d:	77 65                	ja     802094 <__udivdi3+0x8c>
  80202f:	89 fd                	mov    %edi,%ebp
  802031:	85 ff                	test   %edi,%edi
  802033:	75 0b                	jne    802040 <__udivdi3+0x38>
  802035:	b8 01 00 00 00       	mov    $0x1,%eax
  80203a:	31 d2                	xor    %edx,%edx
  80203c:	f7 f7                	div    %edi
  80203e:	89 c5                	mov    %eax,%ebp
  802040:	31 d2                	xor    %edx,%edx
  802042:	89 c8                	mov    %ecx,%eax
  802044:	f7 f5                	div    %ebp
  802046:	89 c1                	mov    %eax,%ecx
  802048:	89 d8                	mov    %ebx,%eax
  80204a:	f7 f5                	div    %ebp
  80204c:	89 cf                	mov    %ecx,%edi
  80204e:	89 fa                	mov    %edi,%edx
  802050:	83 c4 1c             	add    $0x1c,%esp
  802053:	5b                   	pop    %ebx
  802054:	5e                   	pop    %esi
  802055:	5f                   	pop    %edi
  802056:	5d                   	pop    %ebp
  802057:	c3                   	ret    
  802058:	39 ce                	cmp    %ecx,%esi
  80205a:	77 28                	ja     802084 <__udivdi3+0x7c>
  80205c:	0f bd fe             	bsr    %esi,%edi
  80205f:	83 f7 1f             	xor    $0x1f,%edi
  802062:	75 40                	jne    8020a4 <__udivdi3+0x9c>
  802064:	39 ce                	cmp    %ecx,%esi
  802066:	72 0a                	jb     802072 <__udivdi3+0x6a>
  802068:	3b 44 24 04          	cmp    0x4(%esp),%eax
  80206c:	0f 87 9e 00 00 00    	ja     802110 <__udivdi3+0x108>
  802072:	b8 01 00 00 00       	mov    $0x1,%eax
  802077:	89 fa                	mov    %edi,%edx
  802079:	83 c4 1c             	add    $0x1c,%esp
  80207c:	5b                   	pop    %ebx
  80207d:	5e                   	pop    %esi
  80207e:	5f                   	pop    %edi
  80207f:	5d                   	pop    %ebp
  802080:	c3                   	ret    
  802081:	8d 76 00             	lea    0x0(%esi),%esi
  802084:	31 ff                	xor    %edi,%edi
  802086:	31 c0                	xor    %eax,%eax
  802088:	89 fa                	mov    %edi,%edx
  80208a:	83 c4 1c             	add    $0x1c,%esp
  80208d:	5b                   	pop    %ebx
  80208e:	5e                   	pop    %esi
  80208f:	5f                   	pop    %edi
  802090:	5d                   	pop    %ebp
  802091:	c3                   	ret    
  802092:	66 90                	xchg   %ax,%ax
  802094:	89 d8                	mov    %ebx,%eax
  802096:	f7 f7                	div    %edi
  802098:	31 ff                	xor    %edi,%edi
  80209a:	89 fa                	mov    %edi,%edx
  80209c:	83 c4 1c             	add    $0x1c,%esp
  80209f:	5b                   	pop    %ebx
  8020a0:	5e                   	pop    %esi
  8020a1:	5f                   	pop    %edi
  8020a2:	5d                   	pop    %ebp
  8020a3:	c3                   	ret    
  8020a4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020a9:	29 fd                	sub    %edi,%ebp
  8020ab:	89 f9                	mov    %edi,%ecx
  8020ad:	d3 e6                	shl    %cl,%esi
  8020af:	89 c3                	mov    %eax,%ebx
  8020b1:	89 e9                	mov    %ebp,%ecx
  8020b3:	d3 eb                	shr    %cl,%ebx
  8020b5:	89 d9                	mov    %ebx,%ecx
  8020b7:	09 f1                	or     %esi,%ecx
  8020b9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020bd:	89 f9                	mov    %edi,%ecx
  8020bf:	d3 e0                	shl    %cl,%eax
  8020c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020c5:	89 d6                	mov    %edx,%esi
  8020c7:	89 e9                	mov    %ebp,%ecx
  8020c9:	d3 ee                	shr    %cl,%esi
  8020cb:	89 f9                	mov    %edi,%ecx
  8020cd:	d3 e2                	shl    %cl,%edx
  8020cf:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020d3:	89 e9                	mov    %ebp,%ecx
  8020d5:	d3 eb                	shr    %cl,%ebx
  8020d7:	09 da                	or     %ebx,%edx
  8020d9:	89 d0                	mov    %edx,%eax
  8020db:	89 f2                	mov    %esi,%edx
  8020dd:	f7 74 24 08          	divl   0x8(%esp)
  8020e1:	89 d6                	mov    %edx,%esi
  8020e3:	89 c3                	mov    %eax,%ebx
  8020e5:	f7 64 24 0c          	mull   0xc(%esp)
  8020e9:	39 d6                	cmp    %edx,%esi
  8020eb:	72 17                	jb     802104 <__udivdi3+0xfc>
  8020ed:	74 09                	je     8020f8 <__udivdi3+0xf0>
  8020ef:	89 d8                	mov    %ebx,%eax
  8020f1:	31 ff                	xor    %edi,%edi
  8020f3:	e9 56 ff ff ff       	jmp    80204e <__udivdi3+0x46>
  8020f8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020fc:	89 f9                	mov    %edi,%ecx
  8020fe:	d3 e2                	shl    %cl,%edx
  802100:	39 c2                	cmp    %eax,%edx
  802102:	73 eb                	jae    8020ef <__udivdi3+0xe7>
  802104:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802107:	31 ff                	xor    %edi,%edi
  802109:	e9 40 ff ff ff       	jmp    80204e <__udivdi3+0x46>
  80210e:	66 90                	xchg   %ax,%ax
  802110:	31 c0                	xor    %eax,%eax
  802112:	e9 37 ff ff ff       	jmp    80204e <__udivdi3+0x46>
  802117:	90                   	nop

00802118 <__umoddi3>:
  802118:	55                   	push   %ebp
  802119:	57                   	push   %edi
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	83 ec 1c             	sub    $0x1c,%esp
  80211f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802123:	8b 74 24 34          	mov    0x34(%esp),%esi
  802127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80212b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80212f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802133:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802137:	89 3c 24             	mov    %edi,(%esp)
  80213a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80213e:	89 f2                	mov    %esi,%edx
  802140:	85 c0                	test   %eax,%eax
  802142:	75 18                	jne    80215c <__umoddi3+0x44>
  802144:	39 f7                	cmp    %esi,%edi
  802146:	0f 86 a0 00 00 00    	jbe    8021ec <__umoddi3+0xd4>
  80214c:	89 c8                	mov    %ecx,%eax
  80214e:	f7 f7                	div    %edi
  802150:	89 d0                	mov    %edx,%eax
  802152:	31 d2                	xor    %edx,%edx
  802154:	83 c4 1c             	add    $0x1c,%esp
  802157:	5b                   	pop    %ebx
  802158:	5e                   	pop    %esi
  802159:	5f                   	pop    %edi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    
  80215c:	89 f3                	mov    %esi,%ebx
  80215e:	39 f0                	cmp    %esi,%eax
  802160:	0f 87 a6 00 00 00    	ja     80220c <__umoddi3+0xf4>
  802166:	0f bd e8             	bsr    %eax,%ebp
  802169:	83 f5 1f             	xor    $0x1f,%ebp
  80216c:	0f 84 a6 00 00 00    	je     802218 <__umoddi3+0x100>
  802172:	bf 20 00 00 00       	mov    $0x20,%edi
  802177:	29 ef                	sub    %ebp,%edi
  802179:	89 e9                	mov    %ebp,%ecx
  80217b:	d3 e0                	shl    %cl,%eax
  80217d:	8b 34 24             	mov    (%esp),%esi
  802180:	89 f2                	mov    %esi,%edx
  802182:	89 f9                	mov    %edi,%ecx
  802184:	d3 ea                	shr    %cl,%edx
  802186:	09 c2                	or     %eax,%edx
  802188:	89 14 24             	mov    %edx,(%esp)
  80218b:	89 f2                	mov    %esi,%edx
  80218d:	89 e9                	mov    %ebp,%ecx
  80218f:	d3 e2                	shl    %cl,%edx
  802191:	89 54 24 04          	mov    %edx,0x4(%esp)
  802195:	89 de                	mov    %ebx,%esi
  802197:	89 f9                	mov    %edi,%ecx
  802199:	d3 ee                	shr    %cl,%esi
  80219b:	89 e9                	mov    %ebp,%ecx
  80219d:	d3 e3                	shl    %cl,%ebx
  80219f:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021a3:	89 d0                	mov    %edx,%eax
  8021a5:	89 f9                	mov    %edi,%ecx
  8021a7:	d3 e8                	shr    %cl,%eax
  8021a9:	09 d8                	or     %ebx,%eax
  8021ab:	89 d3                	mov    %edx,%ebx
  8021ad:	89 e9                	mov    %ebp,%ecx
  8021af:	d3 e3                	shl    %cl,%ebx
  8021b1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021b5:	89 f2                	mov    %esi,%edx
  8021b7:	f7 34 24             	divl   (%esp)
  8021ba:	89 d6                	mov    %edx,%esi
  8021bc:	f7 64 24 04          	mull   0x4(%esp)
  8021c0:	89 c3                	mov    %eax,%ebx
  8021c2:	89 d1                	mov    %edx,%ecx
  8021c4:	39 d6                	cmp    %edx,%esi
  8021c6:	72 7c                	jb     802244 <__umoddi3+0x12c>
  8021c8:	74 72                	je     80223c <__umoddi3+0x124>
  8021ca:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021ce:	29 da                	sub    %ebx,%edx
  8021d0:	19 ce                	sbb    %ecx,%esi
  8021d2:	89 f0                	mov    %esi,%eax
  8021d4:	89 f9                	mov    %edi,%ecx
  8021d6:	d3 e0                	shl    %cl,%eax
  8021d8:	89 e9                	mov    %ebp,%ecx
  8021da:	d3 ea                	shr    %cl,%edx
  8021dc:	09 d0                	or     %edx,%eax
  8021de:	89 e9                	mov    %ebp,%ecx
  8021e0:	d3 ee                	shr    %cl,%esi
  8021e2:	89 f2                	mov    %esi,%edx
  8021e4:	83 c4 1c             	add    $0x1c,%esp
  8021e7:	5b                   	pop    %ebx
  8021e8:	5e                   	pop    %esi
  8021e9:	5f                   	pop    %edi
  8021ea:	5d                   	pop    %ebp
  8021eb:	c3                   	ret    
  8021ec:	89 fd                	mov    %edi,%ebp
  8021ee:	85 ff                	test   %edi,%edi
  8021f0:	75 0b                	jne    8021fd <__umoddi3+0xe5>
  8021f2:	b8 01 00 00 00       	mov    $0x1,%eax
  8021f7:	31 d2                	xor    %edx,%edx
  8021f9:	f7 f7                	div    %edi
  8021fb:	89 c5                	mov    %eax,%ebp
  8021fd:	89 f0                	mov    %esi,%eax
  8021ff:	31 d2                	xor    %edx,%edx
  802201:	f7 f5                	div    %ebp
  802203:	89 c8                	mov    %ecx,%eax
  802205:	f7 f5                	div    %ebp
  802207:	e9 44 ff ff ff       	jmp    802150 <__umoddi3+0x38>
  80220c:	89 c8                	mov    %ecx,%eax
  80220e:	89 f2                	mov    %esi,%edx
  802210:	83 c4 1c             	add    $0x1c,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    
  802218:	39 f0                	cmp    %esi,%eax
  80221a:	72 05                	jb     802221 <__umoddi3+0x109>
  80221c:	39 0c 24             	cmp    %ecx,(%esp)
  80221f:	77 0c                	ja     80222d <__umoddi3+0x115>
  802221:	89 f2                	mov    %esi,%edx
  802223:	29 f9                	sub    %edi,%ecx
  802225:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802229:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80222d:	8b 44 24 04          	mov    0x4(%esp),%eax
  802231:	83 c4 1c             	add    $0x1c,%esp
  802234:	5b                   	pop    %ebx
  802235:	5e                   	pop    %esi
  802236:	5f                   	pop    %edi
  802237:	5d                   	pop    %ebp
  802238:	c3                   	ret    
  802239:	8d 76 00             	lea    0x0(%esi),%esi
  80223c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802240:	73 88                	jae    8021ca <__umoddi3+0xb2>
  802242:	66 90                	xchg   %ax,%ax
  802244:	2b 44 24 04          	sub    0x4(%esp),%eax
  802248:	1b 14 24             	sbb    (%esp),%edx
  80224b:	89 d1                	mov    %edx,%ecx
  80224d:	89 c3                	mov    %eax,%ebx
  80224f:	e9 76 ff ff ff       	jmp    8021ca <__umoddi3+0xb2>
