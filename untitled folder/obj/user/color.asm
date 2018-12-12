
obj/user/color.debug:     file format elf32-i386


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
  80002c:	e8 b3 00 00 00       	call   8000e4 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
// hello, world
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("hello, world\n");
  800039:	68 a0 1f 80 00       	push   $0x801fa0
  80003e:	e8 9b 01 00 00       	call   8001de <cprintf>
	sys_set_console_color(0x400);
  800043:	c7 04 24 00 04 00 00 	movl   $0x400,(%esp)
  80004a:	e8 e1 0d 00 00       	call   800e30 <sys_set_console_color>
	cprintf("hello, world\n");
  80004f:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  800056:	e8 83 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x300);
  80005b:	c7 04 24 00 03 00 00 	movl   $0x300,(%esp)
  800062:	e8 c9 0d 00 00       	call   800e30 <sys_set_console_color>
    cprintf("hello, world\n");
  800067:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  80006e:	e8 6b 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x100);
  800073:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  80007a:	e8 b1 0d 00 00       	call   800e30 <sys_set_console_color>
    cprintf("hello, world\n");
  80007f:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  800086:	e8 53 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x200);
  80008b:	c7 04 24 00 02 00 00 	movl   $0x200,(%esp)
  800092:	e8 99 0d 00 00       	call   800e30 <sys_set_console_color>
    cprintf("hello, world\n");
  800097:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  80009e:	e8 3b 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x800);
  8000a3:	c7 04 24 00 08 00 00 	movl   $0x800,(%esp)
  8000aa:	e8 81 0d 00 00       	call   800e30 <sys_set_console_color>
    cprintf("hello, world\n");
  8000af:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  8000b6:	e8 23 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x600);
  8000bb:	c7 04 24 00 06 00 00 	movl   $0x600,(%esp)
  8000c2:	e8 69 0d 00 00       	call   800e30 <sys_set_console_color>
    cprintf("hello, world\n");
  8000c7:	c7 04 24 a0 1f 80 00 	movl   $0x801fa0,(%esp)
  8000ce:	e8 0b 01 00 00       	call   8001de <cprintf>
    sys_set_console_color(0x700);
  8000d3:	c7 04 24 00 07 00 00 	movl   $0x700,(%esp)
  8000da:	e8 51 0d 00 00       	call   800e30 <sys_set_console_color>
}
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	c9                   	leave  
  8000e3:	c3                   	ret    

008000e4 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e4:	55                   	push   %ebp
  8000e5:	89 e5                	mov    %esp,%ebp
  8000e7:	56                   	push   %esi
  8000e8:	53                   	push   %ebx
  8000e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000ec:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ef:	e8 88 0a 00 00       	call   800b7c <sys_getenvid>
  8000f4:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f9:	89 c2                	mov    %eax,%edx
  8000fb:	c1 e2 05             	shl    $0x5,%edx
  8000fe:	29 c2                	sub    %eax,%edx
  800100:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800107:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010c:	85 db                	test   %ebx,%ebx
  80010e:	7e 07                	jle    800117 <libmain+0x33>
		binaryname = argv[0];
  800110:	8b 06                	mov    (%esi),%eax
  800112:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800117:	83 ec 08             	sub    $0x8,%esp
  80011a:	56                   	push   %esi
  80011b:	53                   	push   %ebx
  80011c:	e8 12 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800121:	e8 0a 00 00 00       	call   800130 <exit>
}
  800126:	83 c4 10             	add    $0x10,%esp
  800129:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012c:	5b                   	pop    %ebx
  80012d:	5e                   	pop    %esi
  80012e:	5d                   	pop    %ebp
  80012f:	c3                   	ret    

00800130 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800130:	55                   	push   %ebp
  800131:	89 e5                	mov    %esp,%ebp
  800133:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800136:	e8 e9 0e 00 00       	call   801024 <close_all>
	sys_env_destroy(0);
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	6a 00                	push   $0x0
  800140:	e8 f6 09 00 00       	call   800b3b <sys_env_destroy>
}
  800145:	83 c4 10             	add    $0x10,%esp
  800148:	c9                   	leave  
  800149:	c3                   	ret    

0080014a <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80014a:	55                   	push   %ebp
  80014b:	89 e5                	mov    %esp,%ebp
  80014d:	53                   	push   %ebx
  80014e:	83 ec 04             	sub    $0x4,%esp
  800151:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800154:	8b 13                	mov    (%ebx),%edx
  800156:	8d 42 01             	lea    0x1(%edx),%eax
  800159:	89 03                	mov    %eax,(%ebx)
  80015b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015e:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800162:	3d ff 00 00 00       	cmp    $0xff,%eax
  800167:	74 08                	je     800171 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800169:	ff 43 04             	incl   0x4(%ebx)
}
  80016c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016f:	c9                   	leave  
  800170:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800171:	83 ec 08             	sub    $0x8,%esp
  800174:	68 ff 00 00 00       	push   $0xff
  800179:	8d 43 08             	lea    0x8(%ebx),%eax
  80017c:	50                   	push   %eax
  80017d:	e8 7c 09 00 00       	call   800afe <sys_cputs>
		b->idx = 0;
  800182:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800188:	83 c4 10             	add    $0x10,%esp
  80018b:	eb dc                	jmp    800169 <putch+0x1f>

0080018d <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018d:	55                   	push   %ebp
  80018e:	89 e5                	mov    %esp,%ebp
  800190:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800196:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019d:	00 00 00 
	b.cnt = 0;
  8001a0:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a7:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001aa:	ff 75 0c             	pushl  0xc(%ebp)
  8001ad:	ff 75 08             	pushl  0x8(%ebp)
  8001b0:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b6:	50                   	push   %eax
  8001b7:	68 4a 01 80 00       	push   $0x80014a
  8001bc:	e8 17 01 00 00       	call   8002d8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c1:	83 c4 08             	add    $0x8,%esp
  8001c4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001ca:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001d0:	50                   	push   %eax
  8001d1:	e8 28 09 00 00       	call   800afe <sys_cputs>

	return b.cnt;
}
  8001d6:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001dc:	c9                   	leave  
  8001dd:	c3                   	ret    

008001de <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001de:	55                   	push   %ebp
  8001df:	89 e5                	mov    %esp,%ebp
  8001e1:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e4:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e7:	50                   	push   %eax
  8001e8:	ff 75 08             	pushl  0x8(%ebp)
  8001eb:	e8 9d ff ff ff       	call   80018d <vcprintf>
	va_end(ap);

	return cnt;
}
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	57                   	push   %edi
  8001f6:	56                   	push   %esi
  8001f7:	53                   	push   %ebx
  8001f8:	83 ec 1c             	sub    $0x1c,%esp
  8001fb:	89 c7                	mov    %eax,%edi
  8001fd:	89 d6                	mov    %edx,%esi
  8001ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800202:	8b 55 0c             	mov    0xc(%ebp),%edx
  800205:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800208:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80020e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800213:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800216:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800219:	39 d3                	cmp    %edx,%ebx
  80021b:	72 05                	jb     800222 <printnum+0x30>
  80021d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800220:	77 78                	ja     80029a <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800222:	83 ec 0c             	sub    $0xc,%esp
  800225:	ff 75 18             	pushl  0x18(%ebp)
  800228:	8b 45 14             	mov    0x14(%ebp),%eax
  80022b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80022e:	53                   	push   %ebx
  80022f:	ff 75 10             	pushl  0x10(%ebp)
  800232:	83 ec 08             	sub    $0x8,%esp
  800235:	ff 75 e4             	pushl  -0x1c(%ebp)
  800238:	ff 75 e0             	pushl  -0x20(%ebp)
  80023b:	ff 75 dc             	pushl  -0x24(%ebp)
  80023e:	ff 75 d8             	pushl  -0x28(%ebp)
  800241:	e8 fe 1a 00 00       	call   801d44 <__udivdi3>
  800246:	83 c4 18             	add    $0x18,%esp
  800249:	52                   	push   %edx
  80024a:	50                   	push   %eax
  80024b:	89 f2                	mov    %esi,%edx
  80024d:	89 f8                	mov    %edi,%eax
  80024f:	e8 9e ff ff ff       	call   8001f2 <printnum>
  800254:	83 c4 20             	add    $0x20,%esp
  800257:	eb 11                	jmp    80026a <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	56                   	push   %esi
  80025d:	ff 75 18             	pushl  0x18(%ebp)
  800260:	ff d7                	call   *%edi
  800262:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800265:	4b                   	dec    %ebx
  800266:	85 db                	test   %ebx,%ebx
  800268:	7f ef                	jg     800259 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80026a:	83 ec 08             	sub    $0x8,%esp
  80026d:	56                   	push   %esi
  80026e:	83 ec 04             	sub    $0x4,%esp
  800271:	ff 75 e4             	pushl  -0x1c(%ebp)
  800274:	ff 75 e0             	pushl  -0x20(%ebp)
  800277:	ff 75 dc             	pushl  -0x24(%ebp)
  80027a:	ff 75 d8             	pushl  -0x28(%ebp)
  80027d:	e8 d2 1b 00 00       	call   801e54 <__umoddi3>
  800282:	83 c4 14             	add    $0x14,%esp
  800285:	0f be 80 b8 1f 80 00 	movsbl 0x801fb8(%eax),%eax
  80028c:	50                   	push   %eax
  80028d:	ff d7                	call   *%edi
}
  80028f:	83 c4 10             	add    $0x10,%esp
  800292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800295:	5b                   	pop    %ebx
  800296:	5e                   	pop    %esi
  800297:	5f                   	pop    %edi
  800298:	5d                   	pop    %ebp
  800299:	c3                   	ret    
  80029a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80029d:	eb c6                	jmp    800265 <printnum+0x73>

0080029f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a5:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002a8:	8b 10                	mov    (%eax),%edx
  8002aa:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ad:	73 0a                	jae    8002b9 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b2:	89 08                	mov    %ecx,(%eax)
  8002b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b7:	88 02                	mov    %al,(%edx)
}
  8002b9:	5d                   	pop    %ebp
  8002ba:	c3                   	ret    

008002bb <printfmt>:
{
  8002bb:	55                   	push   %ebp
  8002bc:	89 e5                	mov    %esp,%ebp
  8002be:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c4:	50                   	push   %eax
  8002c5:	ff 75 10             	pushl  0x10(%ebp)
  8002c8:	ff 75 0c             	pushl  0xc(%ebp)
  8002cb:	ff 75 08             	pushl  0x8(%ebp)
  8002ce:	e8 05 00 00 00       	call   8002d8 <vprintfmt>
}
  8002d3:	83 c4 10             	add    $0x10,%esp
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    

008002d8 <vprintfmt>:
{
  8002d8:	55                   	push   %ebp
  8002d9:	89 e5                	mov    %esp,%ebp
  8002db:	57                   	push   %edi
  8002dc:	56                   	push   %esi
  8002dd:	53                   	push   %ebx
  8002de:	83 ec 2c             	sub    $0x2c,%esp
  8002e1:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e7:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002ea:	e9 ae 03 00 00       	jmp    80069d <vprintfmt+0x3c5>
  8002ef:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002f3:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002fa:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800301:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800308:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030d:	8d 47 01             	lea    0x1(%edi),%eax
  800310:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800313:	8a 17                	mov    (%edi),%dl
  800315:	8d 42 dd             	lea    -0x23(%edx),%eax
  800318:	3c 55                	cmp    $0x55,%al
  80031a:	0f 87 fe 03 00 00    	ja     80071e <vprintfmt+0x446>
  800320:	0f b6 c0             	movzbl %al,%eax
  800323:	ff 24 85 00 21 80 00 	jmp    *0x802100(,%eax,4)
  80032a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800331:	eb da                	jmp    80030d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800336:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80033a:	eb d1                	jmp    80030d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80033c:	0f b6 d2             	movzbl %dl,%edx
  80033f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800342:	b8 00 00 00 00       	mov    $0x0,%eax
  800347:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80034a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034d:	01 c0                	add    %eax,%eax
  80034f:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800353:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800356:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800359:	83 f9 09             	cmp    $0x9,%ecx
  80035c:	77 52                	ja     8003b0 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80035e:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80035f:	eb e9                	jmp    80034a <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800361:	8b 45 14             	mov    0x14(%ebp),%eax
  800364:	8b 00                	mov    (%eax),%eax
  800366:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800369:	8b 45 14             	mov    0x14(%ebp),%eax
  80036c:	8d 40 04             	lea    0x4(%eax),%eax
  80036f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800372:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800375:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800379:	79 92                	jns    80030d <vprintfmt+0x35>
				width = precision, precision = -1;
  80037b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800381:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800388:	eb 83                	jmp    80030d <vprintfmt+0x35>
  80038a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038e:	78 08                	js     800398 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800393:	e9 75 ff ff ff       	jmp    80030d <vprintfmt+0x35>
  800398:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039f:	eb ef                	jmp    800390 <vprintfmt+0xb8>
  8003a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003ab:	e9 5d ff ff ff       	jmp    80030d <vprintfmt+0x35>
  8003b0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b6:	eb bd                	jmp    800375 <vprintfmt+0x9d>
			lflag++;
  8003b8:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bc:	e9 4c ff ff ff       	jmp    80030d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c4:	8d 78 04             	lea    0x4(%eax),%edi
  8003c7:	83 ec 08             	sub    $0x8,%esp
  8003ca:	53                   	push   %ebx
  8003cb:	ff 30                	pushl  (%eax)
  8003cd:	ff d6                	call   *%esi
			break;
  8003cf:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d5:	e9 c0 02 00 00       	jmp    80069a <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003da:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dd:	8d 78 04             	lea    0x4(%eax),%edi
  8003e0:	8b 00                	mov    (%eax),%eax
  8003e2:	85 c0                	test   %eax,%eax
  8003e4:	78 2a                	js     800410 <vprintfmt+0x138>
  8003e6:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e8:	83 f8 0f             	cmp    $0xf,%eax
  8003eb:	7f 27                	jg     800414 <vprintfmt+0x13c>
  8003ed:	8b 04 85 60 22 80 00 	mov    0x802260(,%eax,4),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	74 1c                	je     800414 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003f8:	50                   	push   %eax
  8003f9:	68 91 23 80 00       	push   $0x802391
  8003fe:	53                   	push   %ebx
  8003ff:	56                   	push   %esi
  800400:	e8 b6 fe ff ff       	call   8002bb <printfmt>
  800405:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800408:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040b:	e9 8a 02 00 00       	jmp    80069a <vprintfmt+0x3c2>
  800410:	f7 d8                	neg    %eax
  800412:	eb d2                	jmp    8003e6 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800414:	52                   	push   %edx
  800415:	68 d0 1f 80 00       	push   $0x801fd0
  80041a:	53                   	push   %ebx
  80041b:	56                   	push   %esi
  80041c:	e8 9a fe ff ff       	call   8002bb <printfmt>
  800421:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800424:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800427:	e9 6e 02 00 00       	jmp    80069a <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80042c:	8b 45 14             	mov    0x14(%ebp),%eax
  80042f:	83 c0 04             	add    $0x4,%eax
  800432:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800435:	8b 45 14             	mov    0x14(%ebp),%eax
  800438:	8b 38                	mov    (%eax),%edi
  80043a:	85 ff                	test   %edi,%edi
  80043c:	74 39                	je     800477 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80043e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800442:	0f 8e a9 00 00 00    	jle    8004f1 <vprintfmt+0x219>
  800448:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80044c:	0f 84 a7 00 00 00    	je     8004f9 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	ff 75 d0             	pushl  -0x30(%ebp)
  800458:	57                   	push   %edi
  800459:	e8 6b 03 00 00       	call   8007c9 <strnlen>
  80045e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800461:	29 c1                	sub    %eax,%ecx
  800463:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800466:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800469:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80046d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800470:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800473:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800475:	eb 14                	jmp    80048b <vprintfmt+0x1b3>
				p = "(null)";
  800477:	bf c9 1f 80 00       	mov    $0x801fc9,%edi
  80047c:	eb c0                	jmp    80043e <vprintfmt+0x166>
					putch(padc, putdat);
  80047e:	83 ec 08             	sub    $0x8,%esp
  800481:	53                   	push   %ebx
  800482:	ff 75 e0             	pushl  -0x20(%ebp)
  800485:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800487:	4f                   	dec    %edi
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	85 ff                	test   %edi,%edi
  80048d:	7f ef                	jg     80047e <vprintfmt+0x1a6>
  80048f:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800492:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800495:	89 c8                	mov    %ecx,%eax
  800497:	85 c9                	test   %ecx,%ecx
  800499:	78 10                	js     8004ab <vprintfmt+0x1d3>
  80049b:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049e:	29 c1                	sub    %eax,%ecx
  8004a0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a9:	eb 15                	jmp    8004c0 <vprintfmt+0x1e8>
  8004ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8004b0:	eb e9                	jmp    80049b <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004b2:	83 ec 08             	sub    $0x8,%esp
  8004b5:	53                   	push   %ebx
  8004b6:	52                   	push   %edx
  8004b7:	ff 55 08             	call   *0x8(%ebp)
  8004ba:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004bd:	ff 4d e0             	decl   -0x20(%ebp)
  8004c0:	47                   	inc    %edi
  8004c1:	8a 47 ff             	mov    -0x1(%edi),%al
  8004c4:	0f be d0             	movsbl %al,%edx
  8004c7:	85 d2                	test   %edx,%edx
  8004c9:	74 59                	je     800524 <vprintfmt+0x24c>
  8004cb:	85 f6                	test   %esi,%esi
  8004cd:	78 03                	js     8004d2 <vprintfmt+0x1fa>
  8004cf:	4e                   	dec    %esi
  8004d0:	78 2f                	js     800501 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d6:	74 da                	je     8004b2 <vprintfmt+0x1da>
  8004d8:	0f be c0             	movsbl %al,%eax
  8004db:	83 e8 20             	sub    $0x20,%eax
  8004de:	83 f8 5e             	cmp    $0x5e,%eax
  8004e1:	76 cf                	jbe    8004b2 <vprintfmt+0x1da>
					putch('?', putdat);
  8004e3:	83 ec 08             	sub    $0x8,%esp
  8004e6:	53                   	push   %ebx
  8004e7:	6a 3f                	push   $0x3f
  8004e9:	ff 55 08             	call   *0x8(%ebp)
  8004ec:	83 c4 10             	add    $0x10,%esp
  8004ef:	eb cc                	jmp    8004bd <vprintfmt+0x1e5>
  8004f1:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f4:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f7:	eb c7                	jmp    8004c0 <vprintfmt+0x1e8>
  8004f9:	89 75 08             	mov    %esi,0x8(%ebp)
  8004fc:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004ff:	eb bf                	jmp    8004c0 <vprintfmt+0x1e8>
  800501:	8b 75 08             	mov    0x8(%ebp),%esi
  800504:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800507:	eb 0c                	jmp    800515 <vprintfmt+0x23d>
				putch(' ', putdat);
  800509:	83 ec 08             	sub    $0x8,%esp
  80050c:	53                   	push   %ebx
  80050d:	6a 20                	push   $0x20
  80050f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800511:	4f                   	dec    %edi
  800512:	83 c4 10             	add    $0x10,%esp
  800515:	85 ff                	test   %edi,%edi
  800517:	7f f0                	jg     800509 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800519:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
  80051f:	e9 76 01 00 00       	jmp    80069a <vprintfmt+0x3c2>
  800524:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800527:	8b 75 08             	mov    0x8(%ebp),%esi
  80052a:	eb e9                	jmp    800515 <vprintfmt+0x23d>
	if (lflag >= 2)
  80052c:	83 f9 01             	cmp    $0x1,%ecx
  80052f:	7f 1f                	jg     800550 <vprintfmt+0x278>
	else if (lflag)
  800531:	85 c9                	test   %ecx,%ecx
  800533:	75 48                	jne    80057d <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800535:	8b 45 14             	mov    0x14(%ebp),%eax
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053d:	89 c1                	mov    %eax,%ecx
  80053f:	c1 f9 1f             	sar    $0x1f,%ecx
  800542:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800545:	8b 45 14             	mov    0x14(%ebp),%eax
  800548:	8d 40 04             	lea    0x4(%eax),%eax
  80054b:	89 45 14             	mov    %eax,0x14(%ebp)
  80054e:	eb 17                	jmp    800567 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800550:	8b 45 14             	mov    0x14(%ebp),%eax
  800553:	8b 50 04             	mov    0x4(%eax),%edx
  800556:	8b 00                	mov    (%eax),%eax
  800558:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055e:	8b 45 14             	mov    0x14(%ebp),%eax
  800561:	8d 40 08             	lea    0x8(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800567:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80056a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80056d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800571:	78 25                	js     800598 <vprintfmt+0x2c0>
			base = 10;
  800573:	b8 0a 00 00 00       	mov    $0xa,%eax
  800578:	e9 03 01 00 00       	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80057d:	8b 45 14             	mov    0x14(%ebp),%eax
  800580:	8b 00                	mov    (%eax),%eax
  800582:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800585:	89 c1                	mov    %eax,%ecx
  800587:	c1 f9 1f             	sar    $0x1f,%ecx
  80058a:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058d:	8b 45 14             	mov    0x14(%ebp),%eax
  800590:	8d 40 04             	lea    0x4(%eax),%eax
  800593:	89 45 14             	mov    %eax,0x14(%ebp)
  800596:	eb cf                	jmp    800567 <vprintfmt+0x28f>
				putch('-', putdat);
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	53                   	push   %ebx
  80059c:	6a 2d                	push   $0x2d
  80059e:	ff d6                	call   *%esi
				num = -(long long) num;
  8005a0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a6:	f7 da                	neg    %edx
  8005a8:	83 d1 00             	adc    $0x0,%ecx
  8005ab:	f7 d9                	neg    %ecx
  8005ad:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005b0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b5:	e9 c6 00 00 00       	jmp    800680 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005ba:	83 f9 01             	cmp    $0x1,%ecx
  8005bd:	7f 1e                	jg     8005dd <vprintfmt+0x305>
	else if (lflag)
  8005bf:	85 c9                	test   %ecx,%ecx
  8005c1:	75 32                	jne    8005f5 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8005c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c6:	8b 10                	mov    (%eax),%edx
  8005c8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cd:	8d 40 04             	lea    0x4(%eax),%eax
  8005d0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d8:	e9 a3 00 00 00       	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e5:	8d 40 08             	lea    0x8(%eax),%eax
  8005e8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f0:	e9 8b 00 00 00       	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f8:	8b 10                	mov    (%eax),%edx
  8005fa:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ff:	8d 40 04             	lea    0x4(%eax),%eax
  800602:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800605:	b8 0a 00 00 00       	mov    $0xa,%eax
  80060a:	eb 74                	jmp    800680 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80060c:	83 f9 01             	cmp    $0x1,%ecx
  80060f:	7f 1b                	jg     80062c <vprintfmt+0x354>
	else if (lflag)
  800611:	85 c9                	test   %ecx,%ecx
  800613:	75 2c                	jne    800641 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800625:	b8 08 00 00 00       	mov    $0x8,%eax
  80062a:	eb 54                	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 14             	mov    0x14(%ebp),%eax
  80062f:	8b 10                	mov    (%eax),%edx
  800631:	8b 48 04             	mov    0x4(%eax),%ecx
  800634:	8d 40 08             	lea    0x8(%eax),%eax
  800637:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80063a:	b8 08 00 00 00       	mov    $0x8,%eax
  80063f:	eb 3f                	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800641:	8b 45 14             	mov    0x14(%ebp),%eax
  800644:	8b 10                	mov    (%eax),%edx
  800646:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064b:	8d 40 04             	lea    0x4(%eax),%eax
  80064e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800651:	b8 08 00 00 00       	mov    $0x8,%eax
  800656:	eb 28                	jmp    800680 <vprintfmt+0x3a8>
			putch('0', putdat);
  800658:	83 ec 08             	sub    $0x8,%esp
  80065b:	53                   	push   %ebx
  80065c:	6a 30                	push   $0x30
  80065e:	ff d6                	call   *%esi
			putch('x', putdat);
  800660:	83 c4 08             	add    $0x8,%esp
  800663:	53                   	push   %ebx
  800664:	6a 78                	push   $0x78
  800666:	ff d6                	call   *%esi
			num = (unsigned long long)
  800668:	8b 45 14             	mov    0x14(%ebp),%eax
  80066b:	8b 10                	mov    (%eax),%edx
  80066d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800672:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800675:	8d 40 04             	lea    0x4(%eax),%eax
  800678:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800680:	83 ec 0c             	sub    $0xc,%esp
  800683:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800687:	57                   	push   %edi
  800688:	ff 75 e0             	pushl  -0x20(%ebp)
  80068b:	50                   	push   %eax
  80068c:	51                   	push   %ecx
  80068d:	52                   	push   %edx
  80068e:	89 da                	mov    %ebx,%edx
  800690:	89 f0                	mov    %esi,%eax
  800692:	e8 5b fb ff ff       	call   8001f2 <printnum>
			break;
  800697:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80069a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069d:	47                   	inc    %edi
  80069e:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a2:	83 f8 25             	cmp    $0x25,%eax
  8006a5:	0f 84 44 fc ff ff    	je     8002ef <vprintfmt+0x17>
			if (ch == '\0')
  8006ab:	85 c0                	test   %eax,%eax
  8006ad:	0f 84 89 00 00 00    	je     80073c <vprintfmt+0x464>
			putch(ch, putdat);
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	53                   	push   %ebx
  8006b7:	50                   	push   %eax
  8006b8:	ff d6                	call   *%esi
  8006ba:	83 c4 10             	add    $0x10,%esp
  8006bd:	eb de                	jmp    80069d <vprintfmt+0x3c5>
	if (lflag >= 2)
  8006bf:	83 f9 01             	cmp    $0x1,%ecx
  8006c2:	7f 1b                	jg     8006df <vprintfmt+0x407>
	else if (lflag)
  8006c4:	85 c9                	test   %ecx,%ecx
  8006c6:	75 2c                	jne    8006f4 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006cb:	8b 10                	mov    (%eax),%edx
  8006cd:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d2:	8d 40 04             	lea    0x4(%eax),%eax
  8006d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006dd:	eb a1                	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 10                	mov    (%eax),%edx
  8006e4:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e7:	8d 40 08             	lea    0x8(%eax),%eax
  8006ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ed:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f2:	eb 8c                	jmp    800680 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8b 10                	mov    (%eax),%edx
  8006f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fe:	8d 40 04             	lea    0x4(%eax),%eax
  800701:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800704:	b8 10 00 00 00       	mov    $0x10,%eax
  800709:	e9 72 ff ff ff       	jmp    800680 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80070e:	83 ec 08             	sub    $0x8,%esp
  800711:	53                   	push   %ebx
  800712:	6a 25                	push   $0x25
  800714:	ff d6                	call   *%esi
			break;
  800716:	83 c4 10             	add    $0x10,%esp
  800719:	e9 7c ff ff ff       	jmp    80069a <vprintfmt+0x3c2>
			putch('%', putdat);
  80071e:	83 ec 08             	sub    $0x8,%esp
  800721:	53                   	push   %ebx
  800722:	6a 25                	push   $0x25
  800724:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800726:	83 c4 10             	add    $0x10,%esp
  800729:	89 f8                	mov    %edi,%eax
  80072b:	eb 01                	jmp    80072e <vprintfmt+0x456>
  80072d:	48                   	dec    %eax
  80072e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800732:	75 f9                	jne    80072d <vprintfmt+0x455>
  800734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800737:	e9 5e ff ff ff       	jmp    80069a <vprintfmt+0x3c2>
}
  80073c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073f:	5b                   	pop    %ebx
  800740:	5e                   	pop    %esi
  800741:	5f                   	pop    %edi
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	83 ec 18             	sub    $0x18,%esp
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800750:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800753:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800757:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80075a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800761:	85 c0                	test   %eax,%eax
  800763:	74 26                	je     80078b <vsnprintf+0x47>
  800765:	85 d2                	test   %edx,%edx
  800767:	7e 29                	jle    800792 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800769:	ff 75 14             	pushl  0x14(%ebp)
  80076c:	ff 75 10             	pushl  0x10(%ebp)
  80076f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800772:	50                   	push   %eax
  800773:	68 9f 02 80 00       	push   $0x80029f
  800778:	e8 5b fb ff ff       	call   8002d8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800780:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800783:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800786:	83 c4 10             	add    $0x10,%esp
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    
		return -E_INVAL;
  80078b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800790:	eb f7                	jmp    800789 <vsnprintf+0x45>
  800792:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800797:	eb f0                	jmp    800789 <vsnprintf+0x45>

00800799 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
  80079c:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80079f:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a2:	50                   	push   %eax
  8007a3:	ff 75 10             	pushl  0x10(%ebp)
  8007a6:	ff 75 0c             	pushl  0xc(%ebp)
  8007a9:	ff 75 08             	pushl  0x8(%ebp)
  8007ac:	e8 93 ff ff ff       	call   800744 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b1:	c9                   	leave  
  8007b2:	c3                   	ret    

008007b3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007be:	eb 01                	jmp    8007c1 <strlen+0xe>
		n++;
  8007c0:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8007c1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c5:	75 f9                	jne    8007c0 <strlen+0xd>
	return n;
}
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007cf:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d7:	eb 01                	jmp    8007da <strnlen+0x11>
		n++;
  8007d9:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007da:	39 d0                	cmp    %edx,%eax
  8007dc:	74 06                	je     8007e4 <strnlen+0x1b>
  8007de:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e2:	75 f5                	jne    8007d9 <strnlen+0x10>
	return n;
}
  8007e4:	5d                   	pop    %ebp
  8007e5:	c3                   	ret    

008007e6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	53                   	push   %ebx
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007f0:	89 c2                	mov    %eax,%edx
  8007f2:	42                   	inc    %edx
  8007f3:	41                   	inc    %ecx
  8007f4:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007f7:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007fa:	84 db                	test   %bl,%bl
  8007fc:	75 f4                	jne    8007f2 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007fe:	5b                   	pop    %ebx
  8007ff:	5d                   	pop    %ebp
  800800:	c3                   	ret    

00800801 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800801:	55                   	push   %ebp
  800802:	89 e5                	mov    %esp,%ebp
  800804:	53                   	push   %ebx
  800805:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800808:	53                   	push   %ebx
  800809:	e8 a5 ff ff ff       	call   8007b3 <strlen>
  80080e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800811:	ff 75 0c             	pushl  0xc(%ebp)
  800814:	01 d8                	add    %ebx,%eax
  800816:	50                   	push   %eax
  800817:	e8 ca ff ff ff       	call   8007e6 <strcpy>
	return dst;
}
  80081c:	89 d8                	mov    %ebx,%eax
  80081e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800821:	c9                   	leave  
  800822:	c3                   	ret    

00800823 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800823:	55                   	push   %ebp
  800824:	89 e5                	mov    %esp,%ebp
  800826:	56                   	push   %esi
  800827:	53                   	push   %ebx
  800828:	8b 75 08             	mov    0x8(%ebp),%esi
  80082b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082e:	89 f3                	mov    %esi,%ebx
  800830:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800833:	89 f2                	mov    %esi,%edx
  800835:	eb 0c                	jmp    800843 <strncpy+0x20>
		*dst++ = *src;
  800837:	42                   	inc    %edx
  800838:	8a 01                	mov    (%ecx),%al
  80083a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083d:	80 39 01             	cmpb   $0x1,(%ecx)
  800840:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800843:	39 da                	cmp    %ebx,%edx
  800845:	75 f0                	jne    800837 <strncpy+0x14>
	}
	return ret;
}
  800847:	89 f0                	mov    %esi,%eax
  800849:	5b                   	pop    %ebx
  80084a:	5e                   	pop    %esi
  80084b:	5d                   	pop    %ebp
  80084c:	c3                   	ret    

0080084d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	56                   	push   %esi
  800851:	53                   	push   %ebx
  800852:	8b 75 08             	mov    0x8(%ebp),%esi
  800855:	8b 55 0c             	mov    0xc(%ebp),%edx
  800858:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085b:	85 c0                	test   %eax,%eax
  80085d:	74 20                	je     80087f <strlcpy+0x32>
  80085f:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800863:	89 f0                	mov    %esi,%eax
  800865:	eb 05                	jmp    80086c <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800867:	40                   	inc    %eax
  800868:	42                   	inc    %edx
  800869:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80086c:	39 d8                	cmp    %ebx,%eax
  80086e:	74 06                	je     800876 <strlcpy+0x29>
  800870:	8a 0a                	mov    (%edx),%cl
  800872:	84 c9                	test   %cl,%cl
  800874:	75 f1                	jne    800867 <strlcpy+0x1a>
		*dst = '\0';
  800876:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800879:	29 f0                	sub    %esi,%eax
}
  80087b:	5b                   	pop    %ebx
  80087c:	5e                   	pop    %esi
  80087d:	5d                   	pop    %ebp
  80087e:	c3                   	ret    
  80087f:	89 f0                	mov    %esi,%eax
  800881:	eb f6                	jmp    800879 <strlcpy+0x2c>

00800883 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800883:	55                   	push   %ebp
  800884:	89 e5                	mov    %esp,%ebp
  800886:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800889:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80088c:	eb 02                	jmp    800890 <strcmp+0xd>
		p++, q++;
  80088e:	41                   	inc    %ecx
  80088f:	42                   	inc    %edx
	while (*p && *p == *q)
  800890:	8a 01                	mov    (%ecx),%al
  800892:	84 c0                	test   %al,%al
  800894:	74 04                	je     80089a <strcmp+0x17>
  800896:	3a 02                	cmp    (%edx),%al
  800898:	74 f4                	je     80088e <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80089a:	0f b6 c0             	movzbl %al,%eax
  80089d:	0f b6 12             	movzbl (%edx),%edx
  8008a0:	29 d0                	sub    %edx,%eax
}
  8008a2:	5d                   	pop    %ebp
  8008a3:	c3                   	ret    

008008a4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a4:	55                   	push   %ebp
  8008a5:	89 e5                	mov    %esp,%ebp
  8008a7:	53                   	push   %ebx
  8008a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ae:	89 c3                	mov    %eax,%ebx
  8008b0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b3:	eb 02                	jmp    8008b7 <strncmp+0x13>
		n--, p++, q++;
  8008b5:	40                   	inc    %eax
  8008b6:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8008b7:	39 d8                	cmp    %ebx,%eax
  8008b9:	74 15                	je     8008d0 <strncmp+0x2c>
  8008bb:	8a 08                	mov    (%eax),%cl
  8008bd:	84 c9                	test   %cl,%cl
  8008bf:	74 04                	je     8008c5 <strncmp+0x21>
  8008c1:	3a 0a                	cmp    (%edx),%cl
  8008c3:	74 f0                	je     8008b5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c5:	0f b6 00             	movzbl (%eax),%eax
  8008c8:	0f b6 12             	movzbl (%edx),%edx
  8008cb:	29 d0                	sub    %edx,%eax
}
  8008cd:	5b                   	pop    %ebx
  8008ce:	5d                   	pop    %ebp
  8008cf:	c3                   	ret    
		return 0;
  8008d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d5:	eb f6                	jmp    8008cd <strncmp+0x29>

008008d7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008e0:	8a 10                	mov    (%eax),%dl
  8008e2:	84 d2                	test   %dl,%dl
  8008e4:	74 07                	je     8008ed <strchr+0x16>
		if (*s == c)
  8008e6:	38 ca                	cmp    %cl,%dl
  8008e8:	74 08                	je     8008f2 <strchr+0x1b>
	for (; *s; s++)
  8008ea:	40                   	inc    %eax
  8008eb:	eb f3                	jmp    8008e0 <strchr+0x9>
			return (char *) s;
	return 0;
  8008ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f2:	5d                   	pop    %ebp
  8008f3:	c3                   	ret    

008008f4 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f4:	55                   	push   %ebp
  8008f5:	89 e5                	mov    %esp,%ebp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008fd:	8a 10                	mov    (%eax),%dl
  8008ff:	84 d2                	test   %dl,%dl
  800901:	74 07                	je     80090a <strfind+0x16>
		if (*s == c)
  800903:	38 ca                	cmp    %cl,%dl
  800905:	74 03                	je     80090a <strfind+0x16>
	for (; *s; s++)
  800907:	40                   	inc    %eax
  800908:	eb f3                	jmp    8008fd <strfind+0x9>
			break;
	return (char *) s;
}
  80090a:	5d                   	pop    %ebp
  80090b:	c3                   	ret    

0080090c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090c:	55                   	push   %ebp
  80090d:	89 e5                	mov    %esp,%ebp
  80090f:	57                   	push   %edi
  800910:	56                   	push   %esi
  800911:	53                   	push   %ebx
  800912:	8b 7d 08             	mov    0x8(%ebp),%edi
  800915:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800918:	85 c9                	test   %ecx,%ecx
  80091a:	74 13                	je     80092f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800922:	75 05                	jne    800929 <memset+0x1d>
  800924:	f6 c1 03             	test   $0x3,%cl
  800927:	74 0d                	je     800936 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800929:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092c:	fc                   	cld    
  80092d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092f:	89 f8                	mov    %edi,%eax
  800931:	5b                   	pop    %ebx
  800932:	5e                   	pop    %esi
  800933:	5f                   	pop    %edi
  800934:	5d                   	pop    %ebp
  800935:	c3                   	ret    
		c &= 0xFF;
  800936:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80093a:	89 d3                	mov    %edx,%ebx
  80093c:	c1 e3 08             	shl    $0x8,%ebx
  80093f:	89 d0                	mov    %edx,%eax
  800941:	c1 e0 18             	shl    $0x18,%eax
  800944:	89 d6                	mov    %edx,%esi
  800946:	c1 e6 10             	shl    $0x10,%esi
  800949:	09 f0                	or     %esi,%eax
  80094b:	09 c2                	or     %eax,%edx
  80094d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80094f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800952:	89 d0                	mov    %edx,%eax
  800954:	fc                   	cld    
  800955:	f3 ab                	rep stos %eax,%es:(%edi)
  800957:	eb d6                	jmp    80092f <memset+0x23>

00800959 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	57                   	push   %edi
  80095d:	56                   	push   %esi
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	8b 75 0c             	mov    0xc(%ebp),%esi
  800964:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800967:	39 c6                	cmp    %eax,%esi
  800969:	73 33                	jae    80099e <memmove+0x45>
  80096b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096e:	39 d0                	cmp    %edx,%eax
  800970:	73 2c                	jae    80099e <memmove+0x45>
		s += n;
		d += n;
  800972:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800975:	89 d6                	mov    %edx,%esi
  800977:	09 fe                	or     %edi,%esi
  800979:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097f:	75 13                	jne    800994 <memmove+0x3b>
  800981:	f6 c1 03             	test   $0x3,%cl
  800984:	75 0e                	jne    800994 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800986:	83 ef 04             	sub    $0x4,%edi
  800989:	8d 72 fc             	lea    -0x4(%edx),%esi
  80098c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80098f:	fd                   	std    
  800990:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800992:	eb 07                	jmp    80099b <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800994:	4f                   	dec    %edi
  800995:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800998:	fd                   	std    
  800999:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099b:	fc                   	cld    
  80099c:	eb 13                	jmp    8009b1 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099e:	89 f2                	mov    %esi,%edx
  8009a0:	09 c2                	or     %eax,%edx
  8009a2:	f6 c2 03             	test   $0x3,%dl
  8009a5:	75 05                	jne    8009ac <memmove+0x53>
  8009a7:	f6 c1 03             	test   $0x3,%cl
  8009aa:	74 09                	je     8009b5 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ac:	89 c7                	mov    %eax,%edi
  8009ae:	fc                   	cld    
  8009af:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b1:	5e                   	pop    %esi
  8009b2:	5f                   	pop    %edi
  8009b3:	5d                   	pop    %ebp
  8009b4:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b8:	89 c7                	mov    %eax,%edi
  8009ba:	fc                   	cld    
  8009bb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bd:	eb f2                	jmp    8009b1 <memmove+0x58>

008009bf <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009bf:	55                   	push   %ebp
  8009c0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c2:	ff 75 10             	pushl  0x10(%ebp)
  8009c5:	ff 75 0c             	pushl  0xc(%ebp)
  8009c8:	ff 75 08             	pushl  0x8(%ebp)
  8009cb:	e8 89 ff ff ff       	call   800959 <memmove>
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	56                   	push   %esi
  8009d6:	53                   	push   %ebx
  8009d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009da:	89 c6                	mov    %eax,%esi
  8009dc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009df:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009e2:	39 f0                	cmp    %esi,%eax
  8009e4:	74 16                	je     8009fc <memcmp+0x2a>
		if (*s1 != *s2)
  8009e6:	8a 08                	mov    (%eax),%cl
  8009e8:	8a 1a                	mov    (%edx),%bl
  8009ea:	38 d9                	cmp    %bl,%cl
  8009ec:	75 04                	jne    8009f2 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ee:	40                   	inc    %eax
  8009ef:	42                   	inc    %edx
  8009f0:	eb f0                	jmp    8009e2 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009f2:	0f b6 c1             	movzbl %cl,%eax
  8009f5:	0f b6 db             	movzbl %bl,%ebx
  8009f8:	29 d8                	sub    %ebx,%eax
  8009fa:	eb 05                	jmp    800a01 <memcmp+0x2f>
	}

	return 0;
  8009fc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a01:	5b                   	pop    %ebx
  800a02:	5e                   	pop    %esi
  800a03:	5d                   	pop    %ebp
  800a04:	c3                   	ret    

00800a05 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a05:	55                   	push   %ebp
  800a06:	89 e5                	mov    %esp,%ebp
  800a08:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a0e:	89 c2                	mov    %eax,%edx
  800a10:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a13:	39 d0                	cmp    %edx,%eax
  800a15:	73 07                	jae    800a1e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a17:	38 08                	cmp    %cl,(%eax)
  800a19:	74 03                	je     800a1e <memfind+0x19>
	for (; s < ends; s++)
  800a1b:	40                   	inc    %eax
  800a1c:	eb f5                	jmp    800a13 <memfind+0xe>
			break;
	return (void *) s;
}
  800a1e:	5d                   	pop    %ebp
  800a1f:	c3                   	ret    

00800a20 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	57                   	push   %edi
  800a24:	56                   	push   %esi
  800a25:	53                   	push   %ebx
  800a26:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a29:	eb 01                	jmp    800a2c <strtol+0xc>
		s++;
  800a2b:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a2c:	8a 01                	mov    (%ecx),%al
  800a2e:	3c 20                	cmp    $0x20,%al
  800a30:	74 f9                	je     800a2b <strtol+0xb>
  800a32:	3c 09                	cmp    $0x9,%al
  800a34:	74 f5                	je     800a2b <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a36:	3c 2b                	cmp    $0x2b,%al
  800a38:	74 2b                	je     800a65 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a3a:	3c 2d                	cmp    $0x2d,%al
  800a3c:	74 2f                	je     800a6d <strtol+0x4d>
	int neg = 0;
  800a3e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a43:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a4a:	75 12                	jne    800a5e <strtol+0x3e>
  800a4c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4f:	74 24                	je     800a75 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a55:	75 07                	jne    800a5e <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a57:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a63:	eb 4e                	jmp    800ab3 <strtol+0x93>
		s++;
  800a65:	41                   	inc    %ecx
	int neg = 0;
  800a66:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6b:	eb d6                	jmp    800a43 <strtol+0x23>
		s++, neg = 1;
  800a6d:	41                   	inc    %ecx
  800a6e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a73:	eb ce                	jmp    800a43 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a75:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a79:	74 10                	je     800a8b <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a7b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a7f:	75 dd                	jne    800a5e <strtol+0x3e>
		s++, base = 8;
  800a81:	41                   	inc    %ecx
  800a82:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a89:	eb d3                	jmp    800a5e <strtol+0x3e>
		s += 2, base = 16;
  800a8b:	83 c1 02             	add    $0x2,%ecx
  800a8e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a95:	eb c7                	jmp    800a5e <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a97:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a9a:	89 f3                	mov    %esi,%ebx
  800a9c:	80 fb 19             	cmp    $0x19,%bl
  800a9f:	77 24                	ja     800ac5 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800aa1:	0f be d2             	movsbl %dl,%edx
  800aa4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aa7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aaa:	7d 2b                	jge    800ad7 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800aac:	41                   	inc    %ecx
  800aad:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab3:	8a 11                	mov    (%ecx),%dl
  800ab5:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ab8:	80 fb 09             	cmp    $0x9,%bl
  800abb:	77 da                	ja     800a97 <strtol+0x77>
			dig = *s - '0';
  800abd:	0f be d2             	movsbl %dl,%edx
  800ac0:	83 ea 30             	sub    $0x30,%edx
  800ac3:	eb e2                	jmp    800aa7 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800ac5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac8:	89 f3                	mov    %esi,%ebx
  800aca:	80 fb 19             	cmp    $0x19,%bl
  800acd:	77 08                	ja     800ad7 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800acf:	0f be d2             	movsbl %dl,%edx
  800ad2:	83 ea 37             	sub    $0x37,%edx
  800ad5:	eb d0                	jmp    800aa7 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800adb:	74 05                	je     800ae2 <strtol+0xc2>
		*endptr = (char *) s;
  800add:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ae0:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae2:	85 ff                	test   %edi,%edi
  800ae4:	74 02                	je     800ae8 <strtol+0xc8>
  800ae6:	f7 d8                	neg    %eax
}
  800ae8:	5b                   	pop    %ebx
  800ae9:	5e                   	pop    %esi
  800aea:	5f                   	pop    %edi
  800aeb:	5d                   	pop    %ebp
  800aec:	c3                   	ret    

00800aed <atoi>:

int
atoi(const char *s)
{
  800aed:	55                   	push   %ebp
  800aee:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800af0:	6a 0a                	push   $0xa
  800af2:	6a 00                	push   $0x0
  800af4:	ff 75 08             	pushl  0x8(%ebp)
  800af7:	e8 24 ff ff ff       	call   800a20 <strtol>
}
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    

00800afe <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800afe:	55                   	push   %ebp
  800aff:	89 e5                	mov    %esp,%ebp
  800b01:	57                   	push   %edi
  800b02:	56                   	push   %esi
  800b03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b04:	b8 00 00 00 00       	mov    $0x0,%eax
  800b09:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0f:	89 c3                	mov    %eax,%ebx
  800b11:	89 c7                	mov    %eax,%edi
  800b13:	89 c6                	mov    %eax,%esi
  800b15:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b17:	5b                   	pop    %ebx
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    

00800b1c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1c:	55                   	push   %ebp
  800b1d:	89 e5                	mov    %esp,%ebp
  800b1f:	57                   	push   %edi
  800b20:	56                   	push   %esi
  800b21:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b22:	ba 00 00 00 00       	mov    $0x0,%edx
  800b27:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2c:	89 d1                	mov    %edx,%ecx
  800b2e:	89 d3                	mov    %edx,%ebx
  800b30:	89 d7                	mov    %edx,%edi
  800b32:	89 d6                	mov    %edx,%esi
  800b34:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b36:	5b                   	pop    %ebx
  800b37:	5e                   	pop    %esi
  800b38:	5f                   	pop    %edi
  800b39:	5d                   	pop    %ebp
  800b3a:	c3                   	ret    

00800b3b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
  800b3e:	57                   	push   %edi
  800b3f:	56                   	push   %esi
  800b40:	53                   	push   %ebx
  800b41:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b44:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b49:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b51:	89 cb                	mov    %ecx,%ebx
  800b53:	89 cf                	mov    %ecx,%edi
  800b55:	89 ce                	mov    %ecx,%esi
  800b57:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b59:	85 c0                	test   %eax,%eax
  800b5b:	7f 08                	jg     800b65 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b60:	5b                   	pop    %ebx
  800b61:	5e                   	pop    %esi
  800b62:	5f                   	pop    %edi
  800b63:	5d                   	pop    %ebp
  800b64:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b65:	83 ec 0c             	sub    $0xc,%esp
  800b68:	50                   	push   %eax
  800b69:	6a 03                	push   $0x3
  800b6b:	68 bf 22 80 00       	push   $0x8022bf
  800b70:	6a 23                	push   $0x23
  800b72:	68 dc 22 80 00       	push   $0x8022dc
  800b77:	e8 df 0f 00 00       	call   801b5b <_panic>

00800b7c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b7c:	55                   	push   %ebp
  800b7d:	89 e5                	mov    %esp,%ebp
  800b7f:	57                   	push   %edi
  800b80:	56                   	push   %esi
  800b81:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b82:	ba 00 00 00 00       	mov    $0x0,%edx
  800b87:	b8 02 00 00 00       	mov    $0x2,%eax
  800b8c:	89 d1                	mov    %edx,%ecx
  800b8e:	89 d3                	mov    %edx,%ebx
  800b90:	89 d7                	mov    %edx,%edi
  800b92:	89 d6                	mov    %edx,%esi
  800b94:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b96:	5b                   	pop    %ebx
  800b97:	5e                   	pop    %esi
  800b98:	5f                   	pop    %edi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    

00800b9b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	57                   	push   %edi
  800b9f:	56                   	push   %esi
  800ba0:	53                   	push   %ebx
  800ba1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba4:	be 00 00 00 00       	mov    $0x0,%esi
  800ba9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb7:	89 f7                	mov    %esi,%edi
  800bb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbb:	85 c0                	test   %eax,%eax
  800bbd:	7f 08                	jg     800bc7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc2:	5b                   	pop    %ebx
  800bc3:	5e                   	pop    %esi
  800bc4:	5f                   	pop    %edi
  800bc5:	5d                   	pop    %ebp
  800bc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc7:	83 ec 0c             	sub    $0xc,%esp
  800bca:	50                   	push   %eax
  800bcb:	6a 04                	push   $0x4
  800bcd:	68 bf 22 80 00       	push   $0x8022bf
  800bd2:	6a 23                	push   $0x23
  800bd4:	68 dc 22 80 00       	push   $0x8022dc
  800bd9:	e8 7d 0f 00 00       	call   801b5b <_panic>

00800bde <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
  800be4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be7:	b8 05 00 00 00       	mov    $0x5,%eax
  800bec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bef:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf5:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bf8:	8b 75 18             	mov    0x18(%ebp),%esi
  800bfb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfd:	85 c0                	test   %eax,%eax
  800bff:	7f 08                	jg     800c09 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c01:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c04:	5b                   	pop    %ebx
  800c05:	5e                   	pop    %esi
  800c06:	5f                   	pop    %edi
  800c07:	5d                   	pop    %ebp
  800c08:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c09:	83 ec 0c             	sub    $0xc,%esp
  800c0c:	50                   	push   %eax
  800c0d:	6a 05                	push   $0x5
  800c0f:	68 bf 22 80 00       	push   $0x8022bf
  800c14:	6a 23                	push   $0x23
  800c16:	68 dc 22 80 00       	push   $0x8022dc
  800c1b:	e8 3b 0f 00 00       	call   801b5b <_panic>

00800c20 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
  800c23:	57                   	push   %edi
  800c24:	56                   	push   %esi
  800c25:	53                   	push   %ebx
  800c26:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c29:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c33:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c36:	8b 55 08             	mov    0x8(%ebp),%edx
  800c39:	89 df                	mov    %ebx,%edi
  800c3b:	89 de                	mov    %ebx,%esi
  800c3d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3f:	85 c0                	test   %eax,%eax
  800c41:	7f 08                	jg     800c4b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c46:	5b                   	pop    %ebx
  800c47:	5e                   	pop    %esi
  800c48:	5f                   	pop    %edi
  800c49:	5d                   	pop    %ebp
  800c4a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4b:	83 ec 0c             	sub    $0xc,%esp
  800c4e:	50                   	push   %eax
  800c4f:	6a 06                	push   $0x6
  800c51:	68 bf 22 80 00       	push   $0x8022bf
  800c56:	6a 23                	push   $0x23
  800c58:	68 dc 22 80 00       	push   $0x8022dc
  800c5d:	e8 f9 0e 00 00       	call   801b5b <_panic>

00800c62 <sys_yield>:

void
sys_yield(void)
{
  800c62:	55                   	push   %ebp
  800c63:	89 e5                	mov    %esp,%ebp
  800c65:	57                   	push   %edi
  800c66:	56                   	push   %esi
  800c67:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c68:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c72:	89 d1                	mov    %edx,%ecx
  800c74:	89 d3                	mov    %edx,%ebx
  800c76:	89 d7                	mov    %edx,%edi
  800c78:	89 d6                	mov    %edx,%esi
  800c7a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7c:	5b                   	pop    %ebx
  800c7d:	5e                   	pop    %esi
  800c7e:	5f                   	pop    %edi
  800c7f:	5d                   	pop    %ebp
  800c80:	c3                   	ret    

00800c81 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	57                   	push   %edi
  800c85:	56                   	push   %esi
  800c86:	53                   	push   %ebx
  800c87:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c94:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c97:	8b 55 08             	mov    0x8(%ebp),%edx
  800c9a:	89 df                	mov    %ebx,%edi
  800c9c:	89 de                	mov    %ebx,%esi
  800c9e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ca0:	85 c0                	test   %eax,%eax
  800ca2:	7f 08                	jg     800cac <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800ca4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca7:	5b                   	pop    %ebx
  800ca8:	5e                   	pop    %esi
  800ca9:	5f                   	pop    %edi
  800caa:	5d                   	pop    %ebp
  800cab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cac:	83 ec 0c             	sub    $0xc,%esp
  800caf:	50                   	push   %eax
  800cb0:	6a 08                	push   $0x8
  800cb2:	68 bf 22 80 00       	push   $0x8022bf
  800cb7:	6a 23                	push   $0x23
  800cb9:	68 dc 22 80 00       	push   $0x8022dc
  800cbe:	e8 98 0e 00 00       	call   801b5b <_panic>

00800cc3 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	57                   	push   %edi
  800cc7:	56                   	push   %esi
  800cc8:	53                   	push   %ebx
  800cc9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	89 cb                	mov    %ecx,%ebx
  800cdb:	89 cf                	mov    %ecx,%edi
  800cdd:	89 ce                	mov    %ecx,%esi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800ce5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce8:	5b                   	pop    %ebx
  800ce9:	5e                   	pop    %esi
  800cea:	5f                   	pop    %edi
  800ceb:	5d                   	pop    %ebp
  800cec:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ced:	83 ec 0c             	sub    $0xc,%esp
  800cf0:	50                   	push   %eax
  800cf1:	6a 0c                	push   $0xc
  800cf3:	68 bf 22 80 00       	push   $0x8022bf
  800cf8:	6a 23                	push   $0x23
  800cfa:	68 dc 22 80 00       	push   $0x8022dc
  800cff:	e8 57 0e 00 00       	call   801b5b <_panic>

00800d04 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
  800d0a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d12:	b8 09 00 00 00       	mov    $0x9,%eax
  800d17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1d:	89 df                	mov    %ebx,%edi
  800d1f:	89 de                	mov    %ebx,%esi
  800d21:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d23:	85 c0                	test   %eax,%eax
  800d25:	7f 08                	jg     800d2f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d27:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2a:	5b                   	pop    %ebx
  800d2b:	5e                   	pop    %esi
  800d2c:	5f                   	pop    %edi
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2f:	83 ec 0c             	sub    $0xc,%esp
  800d32:	50                   	push   %eax
  800d33:	6a 09                	push   $0x9
  800d35:	68 bf 22 80 00       	push   $0x8022bf
  800d3a:	6a 23                	push   $0x23
  800d3c:	68 dc 22 80 00       	push   $0x8022dc
  800d41:	e8 15 0e 00 00       	call   801b5b <_panic>

00800d46 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d46:	55                   	push   %ebp
  800d47:	89 e5                	mov    %esp,%ebp
  800d49:	57                   	push   %edi
  800d4a:	56                   	push   %esi
  800d4b:	53                   	push   %ebx
  800d4c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d54:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	89 df                	mov    %ebx,%edi
  800d61:	89 de                	mov    %ebx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d69:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d71:	83 ec 0c             	sub    $0xc,%esp
  800d74:	50                   	push   %eax
  800d75:	6a 0a                	push   $0xa
  800d77:	68 bf 22 80 00       	push   $0x8022bf
  800d7c:	6a 23                	push   $0x23
  800d7e:	68 dc 22 80 00       	push   $0x8022dc
  800d83:	e8 d3 0d 00 00       	call   801b5b <_panic>

00800d88 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da6:	5b                   	pop    %ebx
  800da7:	5e                   	pop    %esi
  800da8:	5f                   	pop    %edi
  800da9:	5d                   	pop    %ebp
  800daa:	c3                   	ret    

00800dab <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dab:	55                   	push   %ebp
  800dac:	89 e5                	mov    %esp,%ebp
  800dae:	57                   	push   %edi
  800daf:	56                   	push   %esi
  800db0:	53                   	push   %ebx
  800db1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dbe:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc1:	89 cb                	mov    %ecx,%ebx
  800dc3:	89 cf                	mov    %ecx,%edi
  800dc5:	89 ce                	mov    %ecx,%esi
  800dc7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc9:	85 c0                	test   %eax,%eax
  800dcb:	7f 08                	jg     800dd5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd0:	5b                   	pop    %ebx
  800dd1:	5e                   	pop    %esi
  800dd2:	5f                   	pop    %edi
  800dd3:	5d                   	pop    %ebp
  800dd4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd5:	83 ec 0c             	sub    $0xc,%esp
  800dd8:	50                   	push   %eax
  800dd9:	6a 0e                	push   $0xe
  800ddb:	68 bf 22 80 00       	push   $0x8022bf
  800de0:	6a 23                	push   $0x23
  800de2:	68 dc 22 80 00       	push   $0x8022dc
  800de7:	e8 6f 0d 00 00       	call   801b5b <_panic>

00800dec <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	57                   	push   %edi
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df2:	be 00 00 00 00       	mov    $0x0,%esi
  800df7:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	8b 55 08             	mov    0x8(%ebp),%edx
  800e02:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e05:	89 f7                	mov    %esi,%edi
  800e07:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    

00800e0e <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e0e:	55                   	push   %ebp
  800e0f:	89 e5                	mov    %esp,%ebp
  800e11:	57                   	push   %edi
  800e12:	56                   	push   %esi
  800e13:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e14:	be 00 00 00 00       	mov    $0x0,%esi
  800e19:	b8 10 00 00 00       	mov    $0x10,%eax
  800e1e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e21:	8b 55 08             	mov    0x8(%ebp),%edx
  800e24:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e27:	89 f7                	mov    %esi,%edi
  800e29:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e2b:	5b                   	pop    %ebx
  800e2c:	5e                   	pop    %esi
  800e2d:	5f                   	pop    %edi
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	57                   	push   %edi
  800e34:	56                   	push   %esi
  800e35:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3b:	b8 11 00 00 00       	mov    $0x11,%eax
  800e40:	8b 55 08             	mov    0x8(%ebp),%edx
  800e43:	89 cb                	mov    %ecx,%ebx
  800e45:	89 cf                	mov    %ecx,%edi
  800e47:	89 ce                	mov    %ecx,%esi
  800e49:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	05 00 00 00 30       	add    $0x30000000,%eax
  800e5b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e5e:	5d                   	pop    %ebp
  800e5f:	c3                   	ret    

00800e60 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e6b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e70:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e7d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e82:	89 c2                	mov    %eax,%edx
  800e84:	c1 ea 16             	shr    $0x16,%edx
  800e87:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e8e:	f6 c2 01             	test   $0x1,%dl
  800e91:	74 2a                	je     800ebd <fd_alloc+0x46>
  800e93:	89 c2                	mov    %eax,%edx
  800e95:	c1 ea 0c             	shr    $0xc,%edx
  800e98:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e9f:	f6 c2 01             	test   $0x1,%dl
  800ea2:	74 19                	je     800ebd <fd_alloc+0x46>
  800ea4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ea9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eae:	75 d2                	jne    800e82 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eb0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800eb6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ebb:	eb 07                	jmp    800ec4 <fd_alloc+0x4d>
			*fd_store = fd;
  800ebd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ebf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec4:	5d                   	pop    %ebp
  800ec5:	c3                   	ret    

00800ec6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ec6:	55                   	push   %ebp
  800ec7:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ec9:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800ecd:	77 39                	ja     800f08 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	c1 e0 0c             	shl    $0xc,%eax
  800ed5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800eda:	89 c2                	mov    %eax,%edx
  800edc:	c1 ea 16             	shr    $0x16,%edx
  800edf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800ee6:	f6 c2 01             	test   $0x1,%dl
  800ee9:	74 24                	je     800f0f <fd_lookup+0x49>
  800eeb:	89 c2                	mov    %eax,%edx
  800eed:	c1 ea 0c             	shr    $0xc,%edx
  800ef0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ef7:	f6 c2 01             	test   $0x1,%dl
  800efa:	74 1a                	je     800f16 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eff:	89 02                	mov    %eax,(%edx)
	return 0;
  800f01:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f06:	5d                   	pop    %ebp
  800f07:	c3                   	ret    
		return -E_INVAL;
  800f08:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f0d:	eb f7                	jmp    800f06 <fd_lookup+0x40>
		return -E_INVAL;
  800f0f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f14:	eb f0                	jmp    800f06 <fd_lookup+0x40>
  800f16:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1b:	eb e9                	jmp    800f06 <fd_lookup+0x40>

00800f1d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f1d:	55                   	push   %ebp
  800f1e:	89 e5                	mov    %esp,%ebp
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f26:	ba 68 23 80 00       	mov    $0x802368,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f2b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f30:	39 08                	cmp    %ecx,(%eax)
  800f32:	74 33                	je     800f67 <dev_lookup+0x4a>
  800f34:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f37:	8b 02                	mov    (%edx),%eax
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	75 f3                	jne    800f30 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f3d:	a1 04 40 80 00       	mov    0x804004,%eax
  800f42:	8b 40 48             	mov    0x48(%eax),%eax
  800f45:	83 ec 04             	sub    $0x4,%esp
  800f48:	51                   	push   %ecx
  800f49:	50                   	push   %eax
  800f4a:	68 ec 22 80 00       	push   $0x8022ec
  800f4f:	e8 8a f2 ff ff       	call   8001de <cprintf>
	*dev = 0;
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f5d:	83 c4 10             	add    $0x10,%esp
  800f60:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    
			*dev = devtab[i];
  800f67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f6a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f71:	eb f2                	jmp    800f65 <dev_lookup+0x48>

00800f73 <fd_close>:
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	57                   	push   %edi
  800f77:	56                   	push   %esi
  800f78:	53                   	push   %ebx
  800f79:	83 ec 1c             	sub    $0x1c,%esp
  800f7c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f7f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f82:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f85:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f86:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f8c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f8f:	50                   	push   %eax
  800f90:	e8 31 ff ff ff       	call   800ec6 <fd_lookup>
  800f95:	89 c7                	mov    %eax,%edi
  800f97:	83 c4 08             	add    $0x8,%esp
  800f9a:	85 c0                	test   %eax,%eax
  800f9c:	78 05                	js     800fa3 <fd_close+0x30>
	    || fd != fd2)
  800f9e:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800fa1:	74 13                	je     800fb6 <fd_close+0x43>
		return (must_exist ? r : 0);
  800fa3:	84 db                	test   %bl,%bl
  800fa5:	75 05                	jne    800fac <fd_close+0x39>
  800fa7:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800fac:	89 f8                	mov    %edi,%eax
  800fae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb1:	5b                   	pop    %ebx
  800fb2:	5e                   	pop    %esi
  800fb3:	5f                   	pop    %edi
  800fb4:	5d                   	pop    %ebp
  800fb5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fb6:	83 ec 08             	sub    $0x8,%esp
  800fb9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fbc:	50                   	push   %eax
  800fbd:	ff 36                	pushl  (%esi)
  800fbf:	e8 59 ff ff ff       	call   800f1d <dev_lookup>
  800fc4:	89 c7                	mov    %eax,%edi
  800fc6:	83 c4 10             	add    $0x10,%esp
  800fc9:	85 c0                	test   %eax,%eax
  800fcb:	78 15                	js     800fe2 <fd_close+0x6f>
		if (dev->dev_close)
  800fcd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd0:	8b 40 10             	mov    0x10(%eax),%eax
  800fd3:	85 c0                	test   %eax,%eax
  800fd5:	74 1b                	je     800ff2 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800fd7:	83 ec 0c             	sub    $0xc,%esp
  800fda:	56                   	push   %esi
  800fdb:	ff d0                	call   *%eax
  800fdd:	89 c7                	mov    %eax,%edi
  800fdf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fe2:	83 ec 08             	sub    $0x8,%esp
  800fe5:	56                   	push   %esi
  800fe6:	6a 00                	push   $0x0
  800fe8:	e8 33 fc ff ff       	call   800c20 <sys_page_unmap>
	return r;
  800fed:	83 c4 10             	add    $0x10,%esp
  800ff0:	eb ba                	jmp    800fac <fd_close+0x39>
			r = 0;
  800ff2:	bf 00 00 00 00       	mov    $0x0,%edi
  800ff7:	eb e9                	jmp    800fe2 <fd_close+0x6f>

00800ff9 <close>:

int
close(int fdnum)
{
  800ff9:	55                   	push   %ebp
  800ffa:	89 e5                	mov    %esp,%ebp
  800ffc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800fff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801002:	50                   	push   %eax
  801003:	ff 75 08             	pushl  0x8(%ebp)
  801006:	e8 bb fe ff ff       	call   800ec6 <fd_lookup>
  80100b:	83 c4 08             	add    $0x8,%esp
  80100e:	85 c0                	test   %eax,%eax
  801010:	78 10                	js     801022 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801012:	83 ec 08             	sub    $0x8,%esp
  801015:	6a 01                	push   $0x1
  801017:	ff 75 f4             	pushl  -0xc(%ebp)
  80101a:	e8 54 ff ff ff       	call   800f73 <fd_close>
  80101f:	83 c4 10             	add    $0x10,%esp
}
  801022:	c9                   	leave  
  801023:	c3                   	ret    

00801024 <close_all>:

void
close_all(void)
{
  801024:	55                   	push   %ebp
  801025:	89 e5                	mov    %esp,%ebp
  801027:	53                   	push   %ebx
  801028:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80102b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801030:	83 ec 0c             	sub    $0xc,%esp
  801033:	53                   	push   %ebx
  801034:	e8 c0 ff ff ff       	call   800ff9 <close>
	for (i = 0; i < MAXFD; i++)
  801039:	43                   	inc    %ebx
  80103a:	83 c4 10             	add    $0x10,%esp
  80103d:	83 fb 20             	cmp    $0x20,%ebx
  801040:	75 ee                	jne    801030 <close_all+0xc>
}
  801042:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	57                   	push   %edi
  80104b:	56                   	push   %esi
  80104c:	53                   	push   %ebx
  80104d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801050:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801053:	50                   	push   %eax
  801054:	ff 75 08             	pushl  0x8(%ebp)
  801057:	e8 6a fe ff ff       	call   800ec6 <fd_lookup>
  80105c:	89 c3                	mov    %eax,%ebx
  80105e:	83 c4 08             	add    $0x8,%esp
  801061:	85 c0                	test   %eax,%eax
  801063:	0f 88 81 00 00 00    	js     8010ea <dup+0xa3>
		return r;
	close(newfdnum);
  801069:	83 ec 0c             	sub    $0xc,%esp
  80106c:	ff 75 0c             	pushl  0xc(%ebp)
  80106f:	e8 85 ff ff ff       	call   800ff9 <close>

	newfd = INDEX2FD(newfdnum);
  801074:	8b 75 0c             	mov    0xc(%ebp),%esi
  801077:	c1 e6 0c             	shl    $0xc,%esi
  80107a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801080:	83 c4 04             	add    $0x4,%esp
  801083:	ff 75 e4             	pushl  -0x1c(%ebp)
  801086:	e8 d5 fd ff ff       	call   800e60 <fd2data>
  80108b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80108d:	89 34 24             	mov    %esi,(%esp)
  801090:	e8 cb fd ff ff       	call   800e60 <fd2data>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80109a:	89 d8                	mov    %ebx,%eax
  80109c:	c1 e8 16             	shr    $0x16,%eax
  80109f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010a6:	a8 01                	test   $0x1,%al
  8010a8:	74 11                	je     8010bb <dup+0x74>
  8010aa:	89 d8                	mov    %ebx,%eax
  8010ac:	c1 e8 0c             	shr    $0xc,%eax
  8010af:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010b6:	f6 c2 01             	test   $0x1,%dl
  8010b9:	75 39                	jne    8010f4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010bb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010be:	89 d0                	mov    %edx,%eax
  8010c0:	c1 e8 0c             	shr    $0xc,%eax
  8010c3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ca:	83 ec 0c             	sub    $0xc,%esp
  8010cd:	25 07 0e 00 00       	and    $0xe07,%eax
  8010d2:	50                   	push   %eax
  8010d3:	56                   	push   %esi
  8010d4:	6a 00                	push   $0x0
  8010d6:	52                   	push   %edx
  8010d7:	6a 00                	push   $0x0
  8010d9:	e8 00 fb ff ff       	call   800bde <sys_page_map>
  8010de:	89 c3                	mov    %eax,%ebx
  8010e0:	83 c4 20             	add    $0x20,%esp
  8010e3:	85 c0                	test   %eax,%eax
  8010e5:	78 31                	js     801118 <dup+0xd1>
		goto err;

	return newfdnum;
  8010e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010ea:	89 d8                	mov    %ebx,%eax
  8010ec:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010ef:	5b                   	pop    %ebx
  8010f0:	5e                   	pop    %esi
  8010f1:	5f                   	pop    %edi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010f4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010fb:	83 ec 0c             	sub    $0xc,%esp
  8010fe:	25 07 0e 00 00       	and    $0xe07,%eax
  801103:	50                   	push   %eax
  801104:	57                   	push   %edi
  801105:	6a 00                	push   $0x0
  801107:	53                   	push   %ebx
  801108:	6a 00                	push   $0x0
  80110a:	e8 cf fa ff ff       	call   800bde <sys_page_map>
  80110f:	89 c3                	mov    %eax,%ebx
  801111:	83 c4 20             	add    $0x20,%esp
  801114:	85 c0                	test   %eax,%eax
  801116:	79 a3                	jns    8010bb <dup+0x74>
	sys_page_unmap(0, newfd);
  801118:	83 ec 08             	sub    $0x8,%esp
  80111b:	56                   	push   %esi
  80111c:	6a 00                	push   $0x0
  80111e:	e8 fd fa ff ff       	call   800c20 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801123:	83 c4 08             	add    $0x8,%esp
  801126:	57                   	push   %edi
  801127:	6a 00                	push   $0x0
  801129:	e8 f2 fa ff ff       	call   800c20 <sys_page_unmap>
	return r;
  80112e:	83 c4 10             	add    $0x10,%esp
  801131:	eb b7                	jmp    8010ea <dup+0xa3>

00801133 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801133:	55                   	push   %ebp
  801134:	89 e5                	mov    %esp,%ebp
  801136:	53                   	push   %ebx
  801137:	83 ec 14             	sub    $0x14,%esp
  80113a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80113d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801140:	50                   	push   %eax
  801141:	53                   	push   %ebx
  801142:	e8 7f fd ff ff       	call   800ec6 <fd_lookup>
  801147:	83 c4 08             	add    $0x8,%esp
  80114a:	85 c0                	test   %eax,%eax
  80114c:	78 3f                	js     80118d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80114e:	83 ec 08             	sub    $0x8,%esp
  801151:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801154:	50                   	push   %eax
  801155:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801158:	ff 30                	pushl  (%eax)
  80115a:	e8 be fd ff ff       	call   800f1d <dev_lookup>
  80115f:	83 c4 10             	add    $0x10,%esp
  801162:	85 c0                	test   %eax,%eax
  801164:	78 27                	js     80118d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801166:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801169:	8b 42 08             	mov    0x8(%edx),%eax
  80116c:	83 e0 03             	and    $0x3,%eax
  80116f:	83 f8 01             	cmp    $0x1,%eax
  801172:	74 1e                	je     801192 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	8b 40 08             	mov    0x8(%eax),%eax
  80117a:	85 c0                	test   %eax,%eax
  80117c:	74 35                	je     8011b3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80117e:	83 ec 04             	sub    $0x4,%esp
  801181:	ff 75 10             	pushl  0x10(%ebp)
  801184:	ff 75 0c             	pushl  0xc(%ebp)
  801187:	52                   	push   %edx
  801188:	ff d0                	call   *%eax
  80118a:	83 c4 10             	add    $0x10,%esp
}
  80118d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801190:	c9                   	leave  
  801191:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801192:	a1 04 40 80 00       	mov    0x804004,%eax
  801197:	8b 40 48             	mov    0x48(%eax),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	53                   	push   %ebx
  80119e:	50                   	push   %eax
  80119f:	68 2d 23 80 00       	push   $0x80232d
  8011a4:	e8 35 f0 ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b1:	eb da                	jmp    80118d <read+0x5a>
		return -E_NOT_SUPP;
  8011b3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011b8:	eb d3                	jmp    80118d <read+0x5a>

008011ba <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011ba:	55                   	push   %ebp
  8011bb:	89 e5                	mov    %esp,%ebp
  8011bd:	57                   	push   %edi
  8011be:	56                   	push   %esi
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 0c             	sub    $0xc,%esp
  8011c3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011c6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ce:	39 f3                	cmp    %esi,%ebx
  8011d0:	73 25                	jae    8011f7 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011d2:	83 ec 04             	sub    $0x4,%esp
  8011d5:	89 f0                	mov    %esi,%eax
  8011d7:	29 d8                	sub    %ebx,%eax
  8011d9:	50                   	push   %eax
  8011da:	89 d8                	mov    %ebx,%eax
  8011dc:	03 45 0c             	add    0xc(%ebp),%eax
  8011df:	50                   	push   %eax
  8011e0:	57                   	push   %edi
  8011e1:	e8 4d ff ff ff       	call   801133 <read>
		if (m < 0)
  8011e6:	83 c4 10             	add    $0x10,%esp
  8011e9:	85 c0                	test   %eax,%eax
  8011eb:	78 08                	js     8011f5 <readn+0x3b>
			return m;
		if (m == 0)
  8011ed:	85 c0                	test   %eax,%eax
  8011ef:	74 06                	je     8011f7 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011f1:	01 c3                	add    %eax,%ebx
  8011f3:	eb d9                	jmp    8011ce <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011f7:	89 d8                	mov    %ebx,%eax
  8011f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011fc:	5b                   	pop    %ebx
  8011fd:	5e                   	pop    %esi
  8011fe:	5f                   	pop    %edi
  8011ff:	5d                   	pop    %ebp
  801200:	c3                   	ret    

00801201 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801201:	55                   	push   %ebp
  801202:	89 e5                	mov    %esp,%ebp
  801204:	53                   	push   %ebx
  801205:	83 ec 14             	sub    $0x14,%esp
  801208:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80120b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80120e:	50                   	push   %eax
  80120f:	53                   	push   %ebx
  801210:	e8 b1 fc ff ff       	call   800ec6 <fd_lookup>
  801215:	83 c4 08             	add    $0x8,%esp
  801218:	85 c0                	test   %eax,%eax
  80121a:	78 3a                	js     801256 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80121c:	83 ec 08             	sub    $0x8,%esp
  80121f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801222:	50                   	push   %eax
  801223:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801226:	ff 30                	pushl  (%eax)
  801228:	e8 f0 fc ff ff       	call   800f1d <dev_lookup>
  80122d:	83 c4 10             	add    $0x10,%esp
  801230:	85 c0                	test   %eax,%eax
  801232:	78 22                	js     801256 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801234:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801237:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80123b:	74 1e                	je     80125b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80123d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801240:	8b 52 0c             	mov    0xc(%edx),%edx
  801243:	85 d2                	test   %edx,%edx
  801245:	74 35                	je     80127c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801247:	83 ec 04             	sub    $0x4,%esp
  80124a:	ff 75 10             	pushl  0x10(%ebp)
  80124d:	ff 75 0c             	pushl  0xc(%ebp)
  801250:	50                   	push   %eax
  801251:	ff d2                	call   *%edx
  801253:	83 c4 10             	add    $0x10,%esp
}
  801256:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801259:	c9                   	leave  
  80125a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80125b:	a1 04 40 80 00       	mov    0x804004,%eax
  801260:	8b 40 48             	mov    0x48(%eax),%eax
  801263:	83 ec 04             	sub    $0x4,%esp
  801266:	53                   	push   %ebx
  801267:	50                   	push   %eax
  801268:	68 49 23 80 00       	push   $0x802349
  80126d:	e8 6c ef ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  801272:	83 c4 10             	add    $0x10,%esp
  801275:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80127a:	eb da                	jmp    801256 <write+0x55>
		return -E_NOT_SUPP;
  80127c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801281:	eb d3                	jmp    801256 <write+0x55>

00801283 <seek>:

int
seek(int fdnum, off_t offset)
{
  801283:	55                   	push   %ebp
  801284:	89 e5                	mov    %esp,%ebp
  801286:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801289:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 08             	pushl  0x8(%ebp)
  801290:	e8 31 fc ff ff       	call   800ec6 <fd_lookup>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	78 0e                	js     8012aa <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80129c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80129f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012a2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	53                   	push   %ebx
  8012b0:	83 ec 14             	sub    $0x14,%esp
  8012b3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b9:	50                   	push   %eax
  8012ba:	53                   	push   %ebx
  8012bb:	e8 06 fc ff ff       	call   800ec6 <fd_lookup>
  8012c0:	83 c4 08             	add    $0x8,%esp
  8012c3:	85 c0                	test   %eax,%eax
  8012c5:	78 37                	js     8012fe <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012cd:	50                   	push   %eax
  8012ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d1:	ff 30                	pushl  (%eax)
  8012d3:	e8 45 fc ff ff       	call   800f1d <dev_lookup>
  8012d8:	83 c4 10             	add    $0x10,%esp
  8012db:	85 c0                	test   %eax,%eax
  8012dd:	78 1f                	js     8012fe <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012e2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012e6:	74 1b                	je     801303 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012eb:	8b 52 18             	mov    0x18(%edx),%edx
  8012ee:	85 d2                	test   %edx,%edx
  8012f0:	74 32                	je     801324 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	ff 75 0c             	pushl  0xc(%ebp)
  8012f8:	50                   	push   %eax
  8012f9:	ff d2                	call   *%edx
  8012fb:	83 c4 10             	add    $0x10,%esp
}
  8012fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801301:	c9                   	leave  
  801302:	c3                   	ret    
			thisenv->env_id, fdnum);
  801303:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801308:	8b 40 48             	mov    0x48(%eax),%eax
  80130b:	83 ec 04             	sub    $0x4,%esp
  80130e:	53                   	push   %ebx
  80130f:	50                   	push   %eax
  801310:	68 0c 23 80 00       	push   $0x80230c
  801315:	e8 c4 ee ff ff       	call   8001de <cprintf>
		return -E_INVAL;
  80131a:	83 c4 10             	add    $0x10,%esp
  80131d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801322:	eb da                	jmp    8012fe <ftruncate+0x52>
		return -E_NOT_SUPP;
  801324:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801329:	eb d3                	jmp    8012fe <ftruncate+0x52>

0080132b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	53                   	push   %ebx
  80132f:	83 ec 14             	sub    $0x14,%esp
  801332:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801335:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801338:	50                   	push   %eax
  801339:	ff 75 08             	pushl  0x8(%ebp)
  80133c:	e8 85 fb ff ff       	call   800ec6 <fd_lookup>
  801341:	83 c4 08             	add    $0x8,%esp
  801344:	85 c0                	test   %eax,%eax
  801346:	78 4b                	js     801393 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801348:	83 ec 08             	sub    $0x8,%esp
  80134b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80134e:	50                   	push   %eax
  80134f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801352:	ff 30                	pushl  (%eax)
  801354:	e8 c4 fb ff ff       	call   800f1d <dev_lookup>
  801359:	83 c4 10             	add    $0x10,%esp
  80135c:	85 c0                	test   %eax,%eax
  80135e:	78 33                	js     801393 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801367:	74 2f                	je     801398 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801369:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80136c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801373:	00 00 00 
	stat->st_type = 0;
  801376:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80137d:	00 00 00 
	stat->st_dev = dev;
  801380:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801386:	83 ec 08             	sub    $0x8,%esp
  801389:	53                   	push   %ebx
  80138a:	ff 75 f0             	pushl  -0x10(%ebp)
  80138d:	ff 50 14             	call   *0x14(%eax)
  801390:	83 c4 10             	add    $0x10,%esp
}
  801393:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801396:	c9                   	leave  
  801397:	c3                   	ret    
		return -E_NOT_SUPP;
  801398:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80139d:	eb f4                	jmp    801393 <fstat+0x68>

0080139f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80139f:	55                   	push   %ebp
  8013a0:	89 e5                	mov    %esp,%ebp
  8013a2:	56                   	push   %esi
  8013a3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013a4:	83 ec 08             	sub    $0x8,%esp
  8013a7:	6a 00                	push   $0x0
  8013a9:	ff 75 08             	pushl  0x8(%ebp)
  8013ac:	e8 34 02 00 00       	call   8015e5 <open>
  8013b1:	89 c3                	mov    %eax,%ebx
  8013b3:	83 c4 10             	add    $0x10,%esp
  8013b6:	85 c0                	test   %eax,%eax
  8013b8:	78 1b                	js     8013d5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013ba:	83 ec 08             	sub    $0x8,%esp
  8013bd:	ff 75 0c             	pushl  0xc(%ebp)
  8013c0:	50                   	push   %eax
  8013c1:	e8 65 ff ff ff       	call   80132b <fstat>
  8013c6:	89 c6                	mov    %eax,%esi
	close(fd);
  8013c8:	89 1c 24             	mov    %ebx,(%esp)
  8013cb:	e8 29 fc ff ff       	call   800ff9 <close>
	return r;
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 f3                	mov    %esi,%ebx
}
  8013d5:	89 d8                	mov    %ebx,%eax
  8013d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013da:	5b                   	pop    %ebx
  8013db:	5e                   	pop    %esi
  8013dc:	5d                   	pop    %ebp
  8013dd:	c3                   	ret    

008013de <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013de:	55                   	push   %ebp
  8013df:	89 e5                	mov    %esp,%ebp
  8013e1:	56                   	push   %esi
  8013e2:	53                   	push   %ebx
  8013e3:	89 c6                	mov    %eax,%esi
  8013e5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013e7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013ee:	74 27                	je     801417 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013f0:	6a 07                	push   $0x7
  8013f2:	68 00 50 80 00       	push   $0x805000
  8013f7:	56                   	push   %esi
  8013f8:	ff 35 00 40 80 00    	pushl  0x804000
  8013fe:	e8 60 08 00 00       	call   801c63 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801403:	83 c4 0c             	add    $0xc,%esp
  801406:	6a 00                	push   $0x0
  801408:	53                   	push   %ebx
  801409:	6a 00                	push   $0x0
  80140b:	e8 ca 07 00 00       	call   801bda <ipc_recv>
}
  801410:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801413:	5b                   	pop    %ebx
  801414:	5e                   	pop    %esi
  801415:	5d                   	pop    %ebp
  801416:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	6a 01                	push   $0x1
  80141c:	e8 9e 08 00 00       	call   801cbf <ipc_find_env>
  801421:	a3 00 40 80 00       	mov    %eax,0x804000
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	eb c5                	jmp    8013f0 <fsipc+0x12>

0080142b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80142b:	55                   	push   %ebp
  80142c:	89 e5                	mov    %esp,%ebp
  80142e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801431:	8b 45 08             	mov    0x8(%ebp),%eax
  801434:	8b 40 0c             	mov    0xc(%eax),%eax
  801437:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  80143c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80143f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801444:	ba 00 00 00 00       	mov    $0x0,%edx
  801449:	b8 02 00 00 00       	mov    $0x2,%eax
  80144e:	e8 8b ff ff ff       	call   8013de <fsipc>
}
  801453:	c9                   	leave  
  801454:	c3                   	ret    

00801455 <devfile_flush>:
{
  801455:	55                   	push   %ebp
  801456:	89 e5                	mov    %esp,%ebp
  801458:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8b 40 0c             	mov    0xc(%eax),%eax
  801461:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801466:	ba 00 00 00 00       	mov    $0x0,%edx
  80146b:	b8 06 00 00 00       	mov    $0x6,%eax
  801470:	e8 69 ff ff ff       	call   8013de <fsipc>
}
  801475:	c9                   	leave  
  801476:	c3                   	ret    

00801477 <devfile_stat>:
{
  801477:	55                   	push   %ebp
  801478:	89 e5                	mov    %esp,%ebp
  80147a:	53                   	push   %ebx
  80147b:	83 ec 04             	sub    $0x4,%esp
  80147e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801481:	8b 45 08             	mov    0x8(%ebp),%eax
  801484:	8b 40 0c             	mov    0xc(%eax),%eax
  801487:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  80148c:	ba 00 00 00 00       	mov    $0x0,%edx
  801491:	b8 05 00 00 00       	mov    $0x5,%eax
  801496:	e8 43 ff ff ff       	call   8013de <fsipc>
  80149b:	85 c0                	test   %eax,%eax
  80149d:	78 2c                	js     8014cb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80149f:	83 ec 08             	sub    $0x8,%esp
  8014a2:	68 00 50 80 00       	push   $0x805000
  8014a7:	53                   	push   %ebx
  8014a8:	e8 39 f3 ff ff       	call   8007e6 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014ad:	a1 80 50 80 00       	mov    0x805080,%eax
  8014b2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8014b8:	a1 84 50 80 00       	mov    0x805084,%eax
  8014bd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014c3:	83 c4 10             	add    $0x10,%esp
  8014c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ce:	c9                   	leave  
  8014cf:	c3                   	ret    

008014d0 <devfile_write>:
{
  8014d0:	55                   	push   %ebp
  8014d1:	89 e5                	mov    %esp,%ebp
  8014d3:	53                   	push   %ebx
  8014d4:	83 ec 04             	sub    $0x4,%esp
  8014d7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8014da:	89 d8                	mov    %ebx,%eax
  8014dc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8014e2:	76 05                	jbe    8014e9 <devfile_write+0x19>
  8014e4:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ec:	8b 52 0c             	mov    0xc(%edx),%edx
  8014ef:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8014f5:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8014fa:	83 ec 04             	sub    $0x4,%esp
  8014fd:	50                   	push   %eax
  8014fe:	ff 75 0c             	pushl  0xc(%ebp)
  801501:	68 08 50 80 00       	push   $0x805008
  801506:	e8 4e f4 ff ff       	call   800959 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80150b:	ba 00 00 00 00       	mov    $0x0,%edx
  801510:	b8 04 00 00 00       	mov    $0x4,%eax
  801515:	e8 c4 fe ff ff       	call   8013de <fsipc>
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	85 c0                	test   %eax,%eax
  80151f:	78 0b                	js     80152c <devfile_write+0x5c>
	assert(r <= n);
  801521:	39 c3                	cmp    %eax,%ebx
  801523:	72 0c                	jb     801531 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801525:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80152a:	7f 1e                	jg     80154a <devfile_write+0x7a>
}
  80152c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80152f:	c9                   	leave  
  801530:	c3                   	ret    
	assert(r <= n);
  801531:	68 78 23 80 00       	push   $0x802378
  801536:	68 7f 23 80 00       	push   $0x80237f
  80153b:	68 98 00 00 00       	push   $0x98
  801540:	68 94 23 80 00       	push   $0x802394
  801545:	e8 11 06 00 00       	call   801b5b <_panic>
	assert(r <= PGSIZE);
  80154a:	68 9f 23 80 00       	push   $0x80239f
  80154f:	68 7f 23 80 00       	push   $0x80237f
  801554:	68 99 00 00 00       	push   $0x99
  801559:	68 94 23 80 00       	push   $0x802394
  80155e:	e8 f8 05 00 00       	call   801b5b <_panic>

00801563 <devfile_read>:
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	56                   	push   %esi
  801567:	53                   	push   %ebx
  801568:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80156b:	8b 45 08             	mov    0x8(%ebp),%eax
  80156e:	8b 40 0c             	mov    0xc(%eax),%eax
  801571:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801576:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80157c:	ba 00 00 00 00       	mov    $0x0,%edx
  801581:	b8 03 00 00 00       	mov    $0x3,%eax
  801586:	e8 53 fe ff ff       	call   8013de <fsipc>
  80158b:	89 c3                	mov    %eax,%ebx
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 1f                	js     8015b0 <devfile_read+0x4d>
	assert(r <= n);
  801591:	39 c6                	cmp    %eax,%esi
  801593:	72 24                	jb     8015b9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801595:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80159a:	7f 33                	jg     8015cf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  80159c:	83 ec 04             	sub    $0x4,%esp
  80159f:	50                   	push   %eax
  8015a0:	68 00 50 80 00       	push   $0x805000
  8015a5:	ff 75 0c             	pushl  0xc(%ebp)
  8015a8:	e8 ac f3 ff ff       	call   800959 <memmove>
	return r;
  8015ad:	83 c4 10             	add    $0x10,%esp
}
  8015b0:	89 d8                	mov    %ebx,%eax
  8015b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b5:	5b                   	pop    %ebx
  8015b6:	5e                   	pop    %esi
  8015b7:	5d                   	pop    %ebp
  8015b8:	c3                   	ret    
	assert(r <= n);
  8015b9:	68 78 23 80 00       	push   $0x802378
  8015be:	68 7f 23 80 00       	push   $0x80237f
  8015c3:	6a 7c                	push   $0x7c
  8015c5:	68 94 23 80 00       	push   $0x802394
  8015ca:	e8 8c 05 00 00       	call   801b5b <_panic>
	assert(r <= PGSIZE);
  8015cf:	68 9f 23 80 00       	push   $0x80239f
  8015d4:	68 7f 23 80 00       	push   $0x80237f
  8015d9:	6a 7d                	push   $0x7d
  8015db:	68 94 23 80 00       	push   $0x802394
  8015e0:	e8 76 05 00 00       	call   801b5b <_panic>

008015e5 <open>:
{
  8015e5:	55                   	push   %ebp
  8015e6:	89 e5                	mov    %esp,%ebp
  8015e8:	56                   	push   %esi
  8015e9:	53                   	push   %ebx
  8015ea:	83 ec 1c             	sub    $0x1c,%esp
  8015ed:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015f0:	56                   	push   %esi
  8015f1:	e8 bd f1 ff ff       	call   8007b3 <strlen>
  8015f6:	83 c4 10             	add    $0x10,%esp
  8015f9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8015fe:	7f 6c                	jg     80166c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801606:	50                   	push   %eax
  801607:	e8 6b f8 ff ff       	call   800e77 <fd_alloc>
  80160c:	89 c3                	mov    %eax,%ebx
  80160e:	83 c4 10             	add    $0x10,%esp
  801611:	85 c0                	test   %eax,%eax
  801613:	78 3c                	js     801651 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	56                   	push   %esi
  801619:	68 00 50 80 00       	push   $0x805000
  80161e:	e8 c3 f1 ff ff       	call   8007e6 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801623:	8b 45 0c             	mov    0xc(%ebp),%eax
  801626:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80162b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162e:	b8 01 00 00 00       	mov    $0x1,%eax
  801633:	e8 a6 fd ff ff       	call   8013de <fsipc>
  801638:	89 c3                	mov    %eax,%ebx
  80163a:	83 c4 10             	add    $0x10,%esp
  80163d:	85 c0                	test   %eax,%eax
  80163f:	78 19                	js     80165a <open+0x75>
	return fd2num(fd);
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	ff 75 f4             	pushl  -0xc(%ebp)
  801647:	e8 04 f8 ff ff       	call   800e50 <fd2num>
  80164c:	89 c3                	mov    %eax,%ebx
  80164e:	83 c4 10             	add    $0x10,%esp
}
  801651:	89 d8                	mov    %ebx,%eax
  801653:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801656:	5b                   	pop    %ebx
  801657:	5e                   	pop    %esi
  801658:	5d                   	pop    %ebp
  801659:	c3                   	ret    
		fd_close(fd, 0);
  80165a:	83 ec 08             	sub    $0x8,%esp
  80165d:	6a 00                	push   $0x0
  80165f:	ff 75 f4             	pushl  -0xc(%ebp)
  801662:	e8 0c f9 ff ff       	call   800f73 <fd_close>
		return r;
  801667:	83 c4 10             	add    $0x10,%esp
  80166a:	eb e5                	jmp    801651 <open+0x6c>
		return -E_BAD_PATH;
  80166c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801671:	eb de                	jmp    801651 <open+0x6c>

00801673 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801673:	55                   	push   %ebp
  801674:	89 e5                	mov    %esp,%ebp
  801676:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801679:	ba 00 00 00 00       	mov    $0x0,%edx
  80167e:	b8 08 00 00 00       	mov    $0x8,%eax
  801683:	e8 56 fd ff ff       	call   8013de <fsipc>
}
  801688:	c9                   	leave  
  801689:	c3                   	ret    

0080168a <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80168a:	55                   	push   %ebp
  80168b:	89 e5                	mov    %esp,%ebp
  80168d:	56                   	push   %esi
  80168e:	53                   	push   %ebx
  80168f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801692:	83 ec 0c             	sub    $0xc,%esp
  801695:	ff 75 08             	pushl  0x8(%ebp)
  801698:	e8 c3 f7 ff ff       	call   800e60 <fd2data>
  80169d:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80169f:	83 c4 08             	add    $0x8,%esp
  8016a2:	68 ab 23 80 00       	push   $0x8023ab
  8016a7:	53                   	push   %ebx
  8016a8:	e8 39 f1 ff ff       	call   8007e6 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016ad:	8b 46 04             	mov    0x4(%esi),%eax
  8016b0:	2b 06                	sub    (%esi),%eax
  8016b2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  8016b8:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8016bf:	10 00 00 
	stat->st_dev = &devpipe;
  8016c2:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016c9:	30 80 00 
	return 0;
}
  8016cc:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016d4:	5b                   	pop    %ebx
  8016d5:	5e                   	pop    %esi
  8016d6:	5d                   	pop    %ebp
  8016d7:	c3                   	ret    

008016d8 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016d8:	55                   	push   %ebp
  8016d9:	89 e5                	mov    %esp,%ebp
  8016db:	53                   	push   %ebx
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016e2:	53                   	push   %ebx
  8016e3:	6a 00                	push   $0x0
  8016e5:	e8 36 f5 ff ff       	call   800c20 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016ea:	89 1c 24             	mov    %ebx,(%esp)
  8016ed:	e8 6e f7 ff ff       	call   800e60 <fd2data>
  8016f2:	83 c4 08             	add    $0x8,%esp
  8016f5:	50                   	push   %eax
  8016f6:	6a 00                	push   $0x0
  8016f8:	e8 23 f5 ff ff       	call   800c20 <sys_page_unmap>
}
  8016fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801700:	c9                   	leave  
  801701:	c3                   	ret    

00801702 <_pipeisclosed>:
{
  801702:	55                   	push   %ebp
  801703:	89 e5                	mov    %esp,%ebp
  801705:	57                   	push   %edi
  801706:	56                   	push   %esi
  801707:	53                   	push   %ebx
  801708:	83 ec 1c             	sub    $0x1c,%esp
  80170b:	89 c7                	mov    %eax,%edi
  80170d:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80170f:	a1 04 40 80 00       	mov    0x804004,%eax
  801714:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	57                   	push   %edi
  80171b:	e8 e1 05 00 00       	call   801d01 <pageref>
  801720:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801723:	89 34 24             	mov    %esi,(%esp)
  801726:	e8 d6 05 00 00       	call   801d01 <pageref>
		nn = thisenv->env_runs;
  80172b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801731:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801734:	83 c4 10             	add    $0x10,%esp
  801737:	39 cb                	cmp    %ecx,%ebx
  801739:	74 1b                	je     801756 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80173b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80173e:	75 cf                	jne    80170f <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801740:	8b 42 58             	mov    0x58(%edx),%eax
  801743:	6a 01                	push   $0x1
  801745:	50                   	push   %eax
  801746:	53                   	push   %ebx
  801747:	68 b2 23 80 00       	push   $0x8023b2
  80174c:	e8 8d ea ff ff       	call   8001de <cprintf>
  801751:	83 c4 10             	add    $0x10,%esp
  801754:	eb b9                	jmp    80170f <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801756:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801759:	0f 94 c0             	sete   %al
  80175c:	0f b6 c0             	movzbl %al,%eax
}
  80175f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801762:	5b                   	pop    %ebx
  801763:	5e                   	pop    %esi
  801764:	5f                   	pop    %edi
  801765:	5d                   	pop    %ebp
  801766:	c3                   	ret    

00801767 <devpipe_write>:
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	57                   	push   %edi
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	83 ec 18             	sub    $0x18,%esp
  801770:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801773:	56                   	push   %esi
  801774:	e8 e7 f6 ff ff       	call   800e60 <fd2data>
  801779:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  80177b:	83 c4 10             	add    $0x10,%esp
  80177e:	bf 00 00 00 00       	mov    $0x0,%edi
  801783:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801786:	74 41                	je     8017c9 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801788:	8b 53 04             	mov    0x4(%ebx),%edx
  80178b:	8b 03                	mov    (%ebx),%eax
  80178d:	83 c0 20             	add    $0x20,%eax
  801790:	39 c2                	cmp    %eax,%edx
  801792:	72 14                	jb     8017a8 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801794:	89 da                	mov    %ebx,%edx
  801796:	89 f0                	mov    %esi,%eax
  801798:	e8 65 ff ff ff       	call   801702 <_pipeisclosed>
  80179d:	85 c0                	test   %eax,%eax
  80179f:	75 2c                	jne    8017cd <devpipe_write+0x66>
			sys_yield();
  8017a1:	e8 bc f4 ff ff       	call   800c62 <sys_yield>
  8017a6:	eb e0                	jmp    801788 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017ab:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8017ae:	89 d0                	mov    %edx,%eax
  8017b0:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8017b5:	78 0b                	js     8017c2 <devpipe_write+0x5b>
  8017b7:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8017bb:	42                   	inc    %edx
  8017bc:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017bf:	47                   	inc    %edi
  8017c0:	eb c1                	jmp    801783 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017c2:	48                   	dec    %eax
  8017c3:	83 c8 e0             	or     $0xffffffe0,%eax
  8017c6:	40                   	inc    %eax
  8017c7:	eb ee                	jmp    8017b7 <devpipe_write+0x50>
	return i;
  8017c9:	89 f8                	mov    %edi,%eax
  8017cb:	eb 05                	jmp    8017d2 <devpipe_write+0x6b>
				return 0;
  8017cd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017d5:	5b                   	pop    %ebx
  8017d6:	5e                   	pop    %esi
  8017d7:	5f                   	pop    %edi
  8017d8:	5d                   	pop    %ebp
  8017d9:	c3                   	ret    

008017da <devpipe_read>:
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
  8017dd:	57                   	push   %edi
  8017de:	56                   	push   %esi
  8017df:	53                   	push   %ebx
  8017e0:	83 ec 18             	sub    $0x18,%esp
  8017e3:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017e6:	57                   	push   %edi
  8017e7:	e8 74 f6 ff ff       	call   800e60 <fd2data>
  8017ec:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017f6:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8017f9:	74 46                	je     801841 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8017fb:	8b 06                	mov    (%esi),%eax
  8017fd:	3b 46 04             	cmp    0x4(%esi),%eax
  801800:	75 22                	jne    801824 <devpipe_read+0x4a>
			if (i > 0)
  801802:	85 db                	test   %ebx,%ebx
  801804:	74 0a                	je     801810 <devpipe_read+0x36>
				return i;
  801806:	89 d8                	mov    %ebx,%eax
}
  801808:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80180b:	5b                   	pop    %ebx
  80180c:	5e                   	pop    %esi
  80180d:	5f                   	pop    %edi
  80180e:	5d                   	pop    %ebp
  80180f:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801810:	89 f2                	mov    %esi,%edx
  801812:	89 f8                	mov    %edi,%eax
  801814:	e8 e9 fe ff ff       	call   801702 <_pipeisclosed>
  801819:	85 c0                	test   %eax,%eax
  80181b:	75 28                	jne    801845 <devpipe_read+0x6b>
			sys_yield();
  80181d:	e8 40 f4 ff ff       	call   800c62 <sys_yield>
  801822:	eb d7                	jmp    8017fb <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801824:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801829:	78 0f                	js     80183a <devpipe_read+0x60>
  80182b:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  80182f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801832:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801835:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801837:	43                   	inc    %ebx
  801838:	eb bc                	jmp    8017f6 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80183a:	48                   	dec    %eax
  80183b:	83 c8 e0             	or     $0xffffffe0,%eax
  80183e:	40                   	inc    %eax
  80183f:	eb ea                	jmp    80182b <devpipe_read+0x51>
	return i;
  801841:	89 d8                	mov    %ebx,%eax
  801843:	eb c3                	jmp    801808 <devpipe_read+0x2e>
				return 0;
  801845:	b8 00 00 00 00       	mov    $0x0,%eax
  80184a:	eb bc                	jmp    801808 <devpipe_read+0x2e>

0080184c <pipe>:
{
  80184c:	55                   	push   %ebp
  80184d:	89 e5                	mov    %esp,%ebp
  80184f:	56                   	push   %esi
  801850:	53                   	push   %ebx
  801851:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801854:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801857:	50                   	push   %eax
  801858:	e8 1a f6 ff ff       	call   800e77 <fd_alloc>
  80185d:	89 c3                	mov    %eax,%ebx
  80185f:	83 c4 10             	add    $0x10,%esp
  801862:	85 c0                	test   %eax,%eax
  801864:	0f 88 2a 01 00 00    	js     801994 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 07 04 00 00       	push   $0x407
  801872:	ff 75 f4             	pushl  -0xc(%ebp)
  801875:	6a 00                	push   $0x0
  801877:	e8 1f f3 ff ff       	call   800b9b <sys_page_alloc>
  80187c:	89 c3                	mov    %eax,%ebx
  80187e:	83 c4 10             	add    $0x10,%esp
  801881:	85 c0                	test   %eax,%eax
  801883:	0f 88 0b 01 00 00    	js     801994 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801889:	83 ec 0c             	sub    $0xc,%esp
  80188c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80188f:	50                   	push   %eax
  801890:	e8 e2 f5 ff ff       	call   800e77 <fd_alloc>
  801895:	89 c3                	mov    %eax,%ebx
  801897:	83 c4 10             	add    $0x10,%esp
  80189a:	85 c0                	test   %eax,%eax
  80189c:	0f 88 e2 00 00 00    	js     801984 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 07 04 00 00       	push   $0x407
  8018aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8018ad:	6a 00                	push   $0x0
  8018af:	e8 e7 f2 ff ff       	call   800b9b <sys_page_alloc>
  8018b4:	89 c3                	mov    %eax,%ebx
  8018b6:	83 c4 10             	add    $0x10,%esp
  8018b9:	85 c0                	test   %eax,%eax
  8018bb:	0f 88 c3 00 00 00    	js     801984 <pipe+0x138>
	va = fd2data(fd0);
  8018c1:	83 ec 0c             	sub    $0xc,%esp
  8018c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8018c7:	e8 94 f5 ff ff       	call   800e60 <fd2data>
  8018cc:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018ce:	83 c4 0c             	add    $0xc,%esp
  8018d1:	68 07 04 00 00       	push   $0x407
  8018d6:	50                   	push   %eax
  8018d7:	6a 00                	push   $0x0
  8018d9:	e8 bd f2 ff ff       	call   800b9b <sys_page_alloc>
  8018de:	89 c3                	mov    %eax,%ebx
  8018e0:	83 c4 10             	add    $0x10,%esp
  8018e3:	85 c0                	test   %eax,%eax
  8018e5:	0f 88 89 00 00 00    	js     801974 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018eb:	83 ec 0c             	sub    $0xc,%esp
  8018ee:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f1:	e8 6a f5 ff ff       	call   800e60 <fd2data>
  8018f6:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8018fd:	50                   	push   %eax
  8018fe:	6a 00                	push   $0x0
  801900:	56                   	push   %esi
  801901:	6a 00                	push   $0x0
  801903:	e8 d6 f2 ff ff       	call   800bde <sys_page_map>
  801908:	89 c3                	mov    %eax,%ebx
  80190a:	83 c4 20             	add    $0x20,%esp
  80190d:	85 c0                	test   %eax,%eax
  80190f:	78 55                	js     801966 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801911:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191a:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80191c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80191f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801926:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80192c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80192f:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801934:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80193b:	83 ec 0c             	sub    $0xc,%esp
  80193e:	ff 75 f4             	pushl  -0xc(%ebp)
  801941:	e8 0a f5 ff ff       	call   800e50 <fd2num>
  801946:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801949:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80194b:	83 c4 04             	add    $0x4,%esp
  80194e:	ff 75 f0             	pushl  -0x10(%ebp)
  801951:	e8 fa f4 ff ff       	call   800e50 <fd2num>
  801956:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801959:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80195c:	83 c4 10             	add    $0x10,%esp
  80195f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801964:	eb 2e                	jmp    801994 <pipe+0x148>
	sys_page_unmap(0, va);
  801966:	83 ec 08             	sub    $0x8,%esp
  801969:	56                   	push   %esi
  80196a:	6a 00                	push   $0x0
  80196c:	e8 af f2 ff ff       	call   800c20 <sys_page_unmap>
  801971:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801974:	83 ec 08             	sub    $0x8,%esp
  801977:	ff 75 f0             	pushl  -0x10(%ebp)
  80197a:	6a 00                	push   $0x0
  80197c:	e8 9f f2 ff ff       	call   800c20 <sys_page_unmap>
  801981:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801984:	83 ec 08             	sub    $0x8,%esp
  801987:	ff 75 f4             	pushl  -0xc(%ebp)
  80198a:	6a 00                	push   $0x0
  80198c:	e8 8f f2 ff ff       	call   800c20 <sys_page_unmap>
  801991:	83 c4 10             	add    $0x10,%esp
}
  801994:	89 d8                	mov    %ebx,%eax
  801996:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801999:	5b                   	pop    %ebx
  80199a:	5e                   	pop    %esi
  80199b:	5d                   	pop    %ebp
  80199c:	c3                   	ret    

0080199d <pipeisclosed>:
{
  80199d:	55                   	push   %ebp
  80199e:	89 e5                	mov    %esp,%ebp
  8019a0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019a6:	50                   	push   %eax
  8019a7:	ff 75 08             	pushl  0x8(%ebp)
  8019aa:	e8 17 f5 ff ff       	call   800ec6 <fd_lookup>
  8019af:	83 c4 10             	add    $0x10,%esp
  8019b2:	85 c0                	test   %eax,%eax
  8019b4:	78 18                	js     8019ce <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8019b6:	83 ec 0c             	sub    $0xc,%esp
  8019b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8019bc:	e8 9f f4 ff ff       	call   800e60 <fd2data>
	return _pipeisclosed(fd, p);
  8019c1:	89 c2                	mov    %eax,%edx
  8019c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019c6:	e8 37 fd ff ff       	call   801702 <_pipeisclosed>
  8019cb:	83 c4 10             	add    $0x10,%esp
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8019d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d8:	5d                   	pop    %ebp
  8019d9:	c3                   	ret    

008019da <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
  8019dd:	53                   	push   %ebx
  8019de:	83 ec 0c             	sub    $0xc,%esp
  8019e1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8019e4:	68 ca 23 80 00       	push   $0x8023ca
  8019e9:	53                   	push   %ebx
  8019ea:	e8 f7 ed ff ff       	call   8007e6 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8019ef:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8019f6:	20 00 00 
	return 0;
}
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <devcons_write>:
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	57                   	push   %edi
  801a07:	56                   	push   %esi
  801a08:	53                   	push   %ebx
  801a09:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a0f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a14:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a1a:	eb 1d                	jmp    801a39 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801a1c:	83 ec 04             	sub    $0x4,%esp
  801a1f:	53                   	push   %ebx
  801a20:	03 45 0c             	add    0xc(%ebp),%eax
  801a23:	50                   	push   %eax
  801a24:	57                   	push   %edi
  801a25:	e8 2f ef ff ff       	call   800959 <memmove>
		sys_cputs(buf, m);
  801a2a:	83 c4 08             	add    $0x8,%esp
  801a2d:	53                   	push   %ebx
  801a2e:	57                   	push   %edi
  801a2f:	e8 ca f0 ff ff       	call   800afe <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a34:	01 de                	add    %ebx,%esi
  801a36:	83 c4 10             	add    $0x10,%esp
  801a39:	89 f0                	mov    %esi,%eax
  801a3b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a3e:	73 11                	jae    801a51 <devcons_write+0x4e>
		m = n - tot;
  801a40:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a43:	29 f3                	sub    %esi,%ebx
  801a45:	83 fb 7f             	cmp    $0x7f,%ebx
  801a48:	76 d2                	jbe    801a1c <devcons_write+0x19>
  801a4a:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801a4f:	eb cb                	jmp    801a1c <devcons_write+0x19>
}
  801a51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a54:	5b                   	pop    %ebx
  801a55:	5e                   	pop    %esi
  801a56:	5f                   	pop    %edi
  801a57:	5d                   	pop    %ebp
  801a58:	c3                   	ret    

00801a59 <devcons_read>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801a5f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a63:	75 0c                	jne    801a71 <devcons_read+0x18>
		return 0;
  801a65:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6a:	eb 21                	jmp    801a8d <devcons_read+0x34>
		sys_yield();
  801a6c:	e8 f1 f1 ff ff       	call   800c62 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801a71:	e8 a6 f0 ff ff       	call   800b1c <sys_cgetc>
  801a76:	85 c0                	test   %eax,%eax
  801a78:	74 f2                	je     801a6c <devcons_read+0x13>
	if (c < 0)
  801a7a:	85 c0                	test   %eax,%eax
  801a7c:	78 0f                	js     801a8d <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801a7e:	83 f8 04             	cmp    $0x4,%eax
  801a81:	74 0c                	je     801a8f <devcons_read+0x36>
	*(char*)vbuf = c;
  801a83:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a86:	88 02                	mov    %al,(%edx)
	return 1;
  801a88:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a8d:	c9                   	leave  
  801a8e:	c3                   	ret    
		return 0;
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	eb f7                	jmp    801a8d <devcons_read+0x34>

00801a96 <cputchar>:
{
  801a96:	55                   	push   %ebp
  801a97:	89 e5                	mov    %esp,%ebp
  801a99:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801aa2:	6a 01                	push   $0x1
  801aa4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aa7:	50                   	push   %eax
  801aa8:	e8 51 f0 ff ff       	call   800afe <sys_cputs>
}
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <getchar>:
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
  801ab5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ab8:	6a 01                	push   $0x1
  801aba:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801abd:	50                   	push   %eax
  801abe:	6a 00                	push   $0x0
  801ac0:	e8 6e f6 ff ff       	call   801133 <read>
	if (r < 0)
  801ac5:	83 c4 10             	add    $0x10,%esp
  801ac8:	85 c0                	test   %eax,%eax
  801aca:	78 08                	js     801ad4 <getchar+0x22>
	if (r < 1)
  801acc:	85 c0                	test   %eax,%eax
  801ace:	7e 06                	jle    801ad6 <getchar+0x24>
	return c;
  801ad0:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    
		return -E_EOF;
  801ad6:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801adb:	eb f7                	jmp    801ad4 <getchar+0x22>

00801add <iscons>:
{
  801add:	55                   	push   %ebp
  801ade:	89 e5                	mov    %esp,%ebp
  801ae0:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ae3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ae6:	50                   	push   %eax
  801ae7:	ff 75 08             	pushl  0x8(%ebp)
  801aea:	e8 d7 f3 ff ff       	call   800ec6 <fd_lookup>
  801aef:	83 c4 10             	add    $0x10,%esp
  801af2:	85 c0                	test   %eax,%eax
  801af4:	78 11                	js     801b07 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aff:	39 10                	cmp    %edx,(%eax)
  801b01:	0f 94 c0             	sete   %al
  801b04:	0f b6 c0             	movzbl %al,%eax
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <opencons>:
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
  801b0c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b0f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b12:	50                   	push   %eax
  801b13:	e8 5f f3 ff ff       	call   800e77 <fd_alloc>
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	78 3a                	js     801b59 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b1f:	83 ec 04             	sub    $0x4,%esp
  801b22:	68 07 04 00 00       	push   $0x407
  801b27:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2a:	6a 00                	push   $0x0
  801b2c:	e8 6a f0 ff ff       	call   800b9b <sys_page_alloc>
  801b31:	83 c4 10             	add    $0x10,%esp
  801b34:	85 c0                	test   %eax,%eax
  801b36:	78 21                	js     801b59 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801b38:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b41:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b46:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b4d:	83 ec 0c             	sub    $0xc,%esp
  801b50:	50                   	push   %eax
  801b51:	e8 fa f2 ff ff       	call   800e50 <fd2num>
  801b56:	83 c4 10             	add    $0x10,%esp
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801b67:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801b6a:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801b70:	e8 07 f0 ff ff       	call   800b7c <sys_getenvid>
  801b75:	83 ec 04             	sub    $0x4,%esp
  801b78:	ff 75 0c             	pushl  0xc(%ebp)
  801b7b:	ff 75 08             	pushl  0x8(%ebp)
  801b7e:	53                   	push   %ebx
  801b7f:	50                   	push   %eax
  801b80:	68 d8 23 80 00       	push   $0x8023d8
  801b85:	68 00 01 00 00       	push   $0x100
  801b8a:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801b90:	56                   	push   %esi
  801b91:	e8 03 ec ff ff       	call   800799 <snprintf>
  801b96:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801b98:	83 c4 20             	add    $0x20,%esp
  801b9b:	57                   	push   %edi
  801b9c:	ff 75 10             	pushl  0x10(%ebp)
  801b9f:	bf 00 01 00 00       	mov    $0x100,%edi
  801ba4:	89 f8                	mov    %edi,%eax
  801ba6:	29 d8                	sub    %ebx,%eax
  801ba8:	50                   	push   %eax
  801ba9:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801bac:	50                   	push   %eax
  801bad:	e8 92 eb ff ff       	call   800744 <vsnprintf>
  801bb2:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801bb4:	83 c4 0c             	add    $0xc,%esp
  801bb7:	68 c3 23 80 00       	push   $0x8023c3
  801bbc:	29 df                	sub    %ebx,%edi
  801bbe:	57                   	push   %edi
  801bbf:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801bc2:	50                   	push   %eax
  801bc3:	e8 d1 eb ff ff       	call   800799 <snprintf>
	sys_cputs(buf, r);
  801bc8:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801bcb:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801bcd:	53                   	push   %ebx
  801bce:	56                   	push   %esi
  801bcf:	e8 2a ef ff ff       	call   800afe <sys_cputs>
  801bd4:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801bd7:	cc                   	int3   
  801bd8:	eb fd                	jmp    801bd7 <_panic+0x7c>

00801bda <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
  801bdd:	57                   	push   %edi
  801bde:	56                   	push   %esi
  801bdf:	53                   	push   %ebx
  801be0:	83 ec 0c             	sub    $0xc,%esp
  801be3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801be6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801be9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801bec:	85 ff                	test   %edi,%edi
  801bee:	74 53                	je     801c43 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801bf0:	83 ec 0c             	sub    $0xc,%esp
  801bf3:	57                   	push   %edi
  801bf4:	e8 b2 f1 ff ff       	call   800dab <sys_ipc_recv>
  801bf9:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801bfc:	85 db                	test   %ebx,%ebx
  801bfe:	74 0b                	je     801c0b <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c00:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c06:	8b 52 74             	mov    0x74(%edx),%edx
  801c09:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801c0b:	85 f6                	test   %esi,%esi
  801c0d:	74 0f                	je     801c1e <ipc_recv+0x44>
  801c0f:	85 ff                	test   %edi,%edi
  801c11:	74 0b                	je     801c1e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c13:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c19:	8b 52 78             	mov    0x78(%edx),%edx
  801c1c:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c1e:	85 c0                	test   %eax,%eax
  801c20:	74 30                	je     801c52 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c22:	85 db                	test   %ebx,%ebx
  801c24:	74 06                	je     801c2c <ipc_recv+0x52>
      		*from_env_store = 0;
  801c26:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c2c:	85 f6                	test   %esi,%esi
  801c2e:	74 2c                	je     801c5c <ipc_recv+0x82>
      		*perm_store = 0;
  801c30:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c36:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3e:	5b                   	pop    %ebx
  801c3f:	5e                   	pop    %esi
  801c40:	5f                   	pop    %edi
  801c41:	5d                   	pop    %ebp
  801c42:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c43:	83 ec 0c             	sub    $0xc,%esp
  801c46:	6a ff                	push   $0xffffffff
  801c48:	e8 5e f1 ff ff       	call   800dab <sys_ipc_recv>
  801c4d:	83 c4 10             	add    $0x10,%esp
  801c50:	eb aa                	jmp    801bfc <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c52:	a1 04 40 80 00       	mov    0x804004,%eax
  801c57:	8b 40 70             	mov    0x70(%eax),%eax
  801c5a:	eb df                	jmp    801c3b <ipc_recv+0x61>
		return -1;
  801c5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c61:	eb d8                	jmp    801c3b <ipc_recv+0x61>

00801c63 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c63:	55                   	push   %ebp
  801c64:	89 e5                	mov    %esp,%ebp
  801c66:	57                   	push   %edi
  801c67:	56                   	push   %esi
  801c68:	53                   	push   %ebx
  801c69:	83 ec 0c             	sub    $0xc,%esp
  801c6c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c6f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c72:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c75:	85 db                	test   %ebx,%ebx
  801c77:	75 22                	jne    801c9b <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c79:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c7e:	eb 1b                	jmp    801c9b <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c80:	68 fc 23 80 00       	push   $0x8023fc
  801c85:	68 7f 23 80 00       	push   $0x80237f
  801c8a:	6a 48                	push   $0x48
  801c8c:	68 20 24 80 00       	push   $0x802420
  801c91:	e8 c5 fe ff ff       	call   801b5b <_panic>
		sys_yield();
  801c96:	e8 c7 ef ff ff       	call   800c62 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c9b:	57                   	push   %edi
  801c9c:	53                   	push   %ebx
  801c9d:	56                   	push   %esi
  801c9e:	ff 75 08             	pushl  0x8(%ebp)
  801ca1:	e8 e2 f0 ff ff       	call   800d88 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801ca6:	83 c4 10             	add    $0x10,%esp
  801ca9:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cac:	74 e8                	je     801c96 <ipc_send+0x33>
  801cae:	85 c0                	test   %eax,%eax
  801cb0:	75 ce                	jne    801c80 <ipc_send+0x1d>
		sys_yield();
  801cb2:	e8 ab ef ff ff       	call   800c62 <sys_yield>
		
	}
	
}
  801cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cba:	5b                   	pop    %ebx
  801cbb:	5e                   	pop    %esi
  801cbc:	5f                   	pop    %edi
  801cbd:	5d                   	pop    %ebp
  801cbe:	c3                   	ret    

00801cbf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cbf:	55                   	push   %ebp
  801cc0:	89 e5                	mov    %esp,%ebp
  801cc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801cc5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cca:	89 c2                	mov    %eax,%edx
  801ccc:	c1 e2 05             	shl    $0x5,%edx
  801ccf:	29 c2                	sub    %eax,%edx
  801cd1:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801cd8:	8b 52 50             	mov    0x50(%edx),%edx
  801cdb:	39 ca                	cmp    %ecx,%edx
  801cdd:	74 0f                	je     801cee <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801cdf:	40                   	inc    %eax
  801ce0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ce5:	75 e3                	jne    801cca <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801ce7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cec:	eb 11                	jmp    801cff <ipc_find_env+0x40>
			return envs[i].env_id;
  801cee:	89 c2                	mov    %eax,%edx
  801cf0:	c1 e2 05             	shl    $0x5,%edx
  801cf3:	29 c2                	sub    %eax,%edx
  801cf5:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801cfc:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cff:	5d                   	pop    %ebp
  801d00:	c3                   	ret    

00801d01 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d01:	55                   	push   %ebp
  801d02:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d04:	8b 45 08             	mov    0x8(%ebp),%eax
  801d07:	c1 e8 16             	shr    $0x16,%eax
  801d0a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d11:	a8 01                	test   $0x1,%al
  801d13:	74 21                	je     801d36 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d15:	8b 45 08             	mov    0x8(%ebp),%eax
  801d18:	c1 e8 0c             	shr    $0xc,%eax
  801d1b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d22:	a8 01                	test   $0x1,%al
  801d24:	74 17                	je     801d3d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d26:	c1 e8 0c             	shr    $0xc,%eax
  801d29:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d30:	ef 
  801d31:	0f b7 c0             	movzwl %ax,%eax
  801d34:	eb 05                	jmp    801d3b <pageref+0x3a>
		return 0;
  801d36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d3b:	5d                   	pop    %ebp
  801d3c:	c3                   	ret    
		return 0;
  801d3d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d42:	eb f7                	jmp    801d3b <pageref+0x3a>

00801d44 <__udivdi3>:
  801d44:	55                   	push   %ebp
  801d45:	57                   	push   %edi
  801d46:	56                   	push   %esi
  801d47:	53                   	push   %ebx
  801d48:	83 ec 1c             	sub    $0x1c,%esp
  801d4b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d4f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d53:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d57:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d5b:	89 ca                	mov    %ecx,%edx
  801d5d:	89 f8                	mov    %edi,%eax
  801d5f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d63:	85 f6                	test   %esi,%esi
  801d65:	75 2d                	jne    801d94 <__udivdi3+0x50>
  801d67:	39 cf                	cmp    %ecx,%edi
  801d69:	77 65                	ja     801dd0 <__udivdi3+0x8c>
  801d6b:	89 fd                	mov    %edi,%ebp
  801d6d:	85 ff                	test   %edi,%edi
  801d6f:	75 0b                	jne    801d7c <__udivdi3+0x38>
  801d71:	b8 01 00 00 00       	mov    $0x1,%eax
  801d76:	31 d2                	xor    %edx,%edx
  801d78:	f7 f7                	div    %edi
  801d7a:	89 c5                	mov    %eax,%ebp
  801d7c:	31 d2                	xor    %edx,%edx
  801d7e:	89 c8                	mov    %ecx,%eax
  801d80:	f7 f5                	div    %ebp
  801d82:	89 c1                	mov    %eax,%ecx
  801d84:	89 d8                	mov    %ebx,%eax
  801d86:	f7 f5                	div    %ebp
  801d88:	89 cf                	mov    %ecx,%edi
  801d8a:	89 fa                	mov    %edi,%edx
  801d8c:	83 c4 1c             	add    $0x1c,%esp
  801d8f:	5b                   	pop    %ebx
  801d90:	5e                   	pop    %esi
  801d91:	5f                   	pop    %edi
  801d92:	5d                   	pop    %ebp
  801d93:	c3                   	ret    
  801d94:	39 ce                	cmp    %ecx,%esi
  801d96:	77 28                	ja     801dc0 <__udivdi3+0x7c>
  801d98:	0f bd fe             	bsr    %esi,%edi
  801d9b:	83 f7 1f             	xor    $0x1f,%edi
  801d9e:	75 40                	jne    801de0 <__udivdi3+0x9c>
  801da0:	39 ce                	cmp    %ecx,%esi
  801da2:	72 0a                	jb     801dae <__udivdi3+0x6a>
  801da4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801da8:	0f 87 9e 00 00 00    	ja     801e4c <__udivdi3+0x108>
  801dae:	b8 01 00 00 00       	mov    $0x1,%eax
  801db3:	89 fa                	mov    %edi,%edx
  801db5:	83 c4 1c             	add    $0x1c,%esp
  801db8:	5b                   	pop    %ebx
  801db9:	5e                   	pop    %esi
  801dba:	5f                   	pop    %edi
  801dbb:	5d                   	pop    %ebp
  801dbc:	c3                   	ret    
  801dbd:	8d 76 00             	lea    0x0(%esi),%esi
  801dc0:	31 ff                	xor    %edi,%edi
  801dc2:	31 c0                	xor    %eax,%eax
  801dc4:	89 fa                	mov    %edi,%edx
  801dc6:	83 c4 1c             	add    $0x1c,%esp
  801dc9:	5b                   	pop    %ebx
  801dca:	5e                   	pop    %esi
  801dcb:	5f                   	pop    %edi
  801dcc:	5d                   	pop    %ebp
  801dcd:	c3                   	ret    
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	89 d8                	mov    %ebx,%eax
  801dd2:	f7 f7                	div    %edi
  801dd4:	31 ff                	xor    %edi,%edi
  801dd6:	89 fa                	mov    %edi,%edx
  801dd8:	83 c4 1c             	add    $0x1c,%esp
  801ddb:	5b                   	pop    %ebx
  801ddc:	5e                   	pop    %esi
  801ddd:	5f                   	pop    %edi
  801dde:	5d                   	pop    %ebp
  801ddf:	c3                   	ret    
  801de0:	bd 20 00 00 00       	mov    $0x20,%ebp
  801de5:	29 fd                	sub    %edi,%ebp
  801de7:	89 f9                	mov    %edi,%ecx
  801de9:	d3 e6                	shl    %cl,%esi
  801deb:	89 c3                	mov    %eax,%ebx
  801ded:	89 e9                	mov    %ebp,%ecx
  801def:	d3 eb                	shr    %cl,%ebx
  801df1:	89 d9                	mov    %ebx,%ecx
  801df3:	09 f1                	or     %esi,%ecx
  801df5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df9:	89 f9                	mov    %edi,%ecx
  801dfb:	d3 e0                	shl    %cl,%eax
  801dfd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e01:	89 d6                	mov    %edx,%esi
  801e03:	89 e9                	mov    %ebp,%ecx
  801e05:	d3 ee                	shr    %cl,%esi
  801e07:	89 f9                	mov    %edi,%ecx
  801e09:	d3 e2                	shl    %cl,%edx
  801e0b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e0f:	89 e9                	mov    %ebp,%ecx
  801e11:	d3 eb                	shr    %cl,%ebx
  801e13:	09 da                	or     %ebx,%edx
  801e15:	89 d0                	mov    %edx,%eax
  801e17:	89 f2                	mov    %esi,%edx
  801e19:	f7 74 24 08          	divl   0x8(%esp)
  801e1d:	89 d6                	mov    %edx,%esi
  801e1f:	89 c3                	mov    %eax,%ebx
  801e21:	f7 64 24 0c          	mull   0xc(%esp)
  801e25:	39 d6                	cmp    %edx,%esi
  801e27:	72 17                	jb     801e40 <__udivdi3+0xfc>
  801e29:	74 09                	je     801e34 <__udivdi3+0xf0>
  801e2b:	89 d8                	mov    %ebx,%eax
  801e2d:	31 ff                	xor    %edi,%edi
  801e2f:	e9 56 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e34:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e38:	89 f9                	mov    %edi,%ecx
  801e3a:	d3 e2                	shl    %cl,%edx
  801e3c:	39 c2                	cmp    %eax,%edx
  801e3e:	73 eb                	jae    801e2b <__udivdi3+0xe7>
  801e40:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e43:	31 ff                	xor    %edi,%edi
  801e45:	e9 40 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e4a:	66 90                	xchg   %ax,%ax
  801e4c:	31 c0                	xor    %eax,%eax
  801e4e:	e9 37 ff ff ff       	jmp    801d8a <__udivdi3+0x46>
  801e53:	90                   	nop

00801e54 <__umoddi3>:
  801e54:	55                   	push   %ebp
  801e55:	57                   	push   %edi
  801e56:	56                   	push   %esi
  801e57:	53                   	push   %ebx
  801e58:	83 ec 1c             	sub    $0x1c,%esp
  801e5b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e5f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e63:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e67:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e6f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e73:	89 3c 24             	mov    %edi,(%esp)
  801e76:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e7a:	89 f2                	mov    %esi,%edx
  801e7c:	85 c0                	test   %eax,%eax
  801e7e:	75 18                	jne    801e98 <__umoddi3+0x44>
  801e80:	39 f7                	cmp    %esi,%edi
  801e82:	0f 86 a0 00 00 00    	jbe    801f28 <__umoddi3+0xd4>
  801e88:	89 c8                	mov    %ecx,%eax
  801e8a:	f7 f7                	div    %edi
  801e8c:	89 d0                	mov    %edx,%eax
  801e8e:	31 d2                	xor    %edx,%edx
  801e90:	83 c4 1c             	add    $0x1c,%esp
  801e93:	5b                   	pop    %ebx
  801e94:	5e                   	pop    %esi
  801e95:	5f                   	pop    %edi
  801e96:	5d                   	pop    %ebp
  801e97:	c3                   	ret    
  801e98:	89 f3                	mov    %esi,%ebx
  801e9a:	39 f0                	cmp    %esi,%eax
  801e9c:	0f 87 a6 00 00 00    	ja     801f48 <__umoddi3+0xf4>
  801ea2:	0f bd e8             	bsr    %eax,%ebp
  801ea5:	83 f5 1f             	xor    $0x1f,%ebp
  801ea8:	0f 84 a6 00 00 00    	je     801f54 <__umoddi3+0x100>
  801eae:	bf 20 00 00 00       	mov    $0x20,%edi
  801eb3:	29 ef                	sub    %ebp,%edi
  801eb5:	89 e9                	mov    %ebp,%ecx
  801eb7:	d3 e0                	shl    %cl,%eax
  801eb9:	8b 34 24             	mov    (%esp),%esi
  801ebc:	89 f2                	mov    %esi,%edx
  801ebe:	89 f9                	mov    %edi,%ecx
  801ec0:	d3 ea                	shr    %cl,%edx
  801ec2:	09 c2                	or     %eax,%edx
  801ec4:	89 14 24             	mov    %edx,(%esp)
  801ec7:	89 f2                	mov    %esi,%edx
  801ec9:	89 e9                	mov    %ebp,%ecx
  801ecb:	d3 e2                	shl    %cl,%edx
  801ecd:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed1:	89 de                	mov    %ebx,%esi
  801ed3:	89 f9                	mov    %edi,%ecx
  801ed5:	d3 ee                	shr    %cl,%esi
  801ed7:	89 e9                	mov    %ebp,%ecx
  801ed9:	d3 e3                	shl    %cl,%ebx
  801edb:	8b 54 24 08          	mov    0x8(%esp),%edx
  801edf:	89 d0                	mov    %edx,%eax
  801ee1:	89 f9                	mov    %edi,%ecx
  801ee3:	d3 e8                	shr    %cl,%eax
  801ee5:	09 d8                	or     %ebx,%eax
  801ee7:	89 d3                	mov    %edx,%ebx
  801ee9:	89 e9                	mov    %ebp,%ecx
  801eeb:	d3 e3                	shl    %cl,%ebx
  801eed:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef1:	89 f2                	mov    %esi,%edx
  801ef3:	f7 34 24             	divl   (%esp)
  801ef6:	89 d6                	mov    %edx,%esi
  801ef8:	f7 64 24 04          	mull   0x4(%esp)
  801efc:	89 c3                	mov    %eax,%ebx
  801efe:	89 d1                	mov    %edx,%ecx
  801f00:	39 d6                	cmp    %edx,%esi
  801f02:	72 7c                	jb     801f80 <__umoddi3+0x12c>
  801f04:	74 72                	je     801f78 <__umoddi3+0x124>
  801f06:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f0a:	29 da                	sub    %ebx,%edx
  801f0c:	19 ce                	sbb    %ecx,%esi
  801f0e:	89 f0                	mov    %esi,%eax
  801f10:	89 f9                	mov    %edi,%ecx
  801f12:	d3 e0                	shl    %cl,%eax
  801f14:	89 e9                	mov    %ebp,%ecx
  801f16:	d3 ea                	shr    %cl,%edx
  801f18:	09 d0                	or     %edx,%eax
  801f1a:	89 e9                	mov    %ebp,%ecx
  801f1c:	d3 ee                	shr    %cl,%esi
  801f1e:	89 f2                	mov    %esi,%edx
  801f20:	83 c4 1c             	add    $0x1c,%esp
  801f23:	5b                   	pop    %ebx
  801f24:	5e                   	pop    %esi
  801f25:	5f                   	pop    %edi
  801f26:	5d                   	pop    %ebp
  801f27:	c3                   	ret    
  801f28:	89 fd                	mov    %edi,%ebp
  801f2a:	85 ff                	test   %edi,%edi
  801f2c:	75 0b                	jne    801f39 <__umoddi3+0xe5>
  801f2e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f33:	31 d2                	xor    %edx,%edx
  801f35:	f7 f7                	div    %edi
  801f37:	89 c5                	mov    %eax,%ebp
  801f39:	89 f0                	mov    %esi,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	f7 f5                	div    %ebp
  801f3f:	89 c8                	mov    %ecx,%eax
  801f41:	f7 f5                	div    %ebp
  801f43:	e9 44 ff ff ff       	jmp    801e8c <__umoddi3+0x38>
  801f48:	89 c8                	mov    %ecx,%eax
  801f4a:	89 f2                	mov    %esi,%edx
  801f4c:	83 c4 1c             	add    $0x1c,%esp
  801f4f:	5b                   	pop    %ebx
  801f50:	5e                   	pop    %esi
  801f51:	5f                   	pop    %edi
  801f52:	5d                   	pop    %ebp
  801f53:	c3                   	ret    
  801f54:	39 f0                	cmp    %esi,%eax
  801f56:	72 05                	jb     801f5d <__umoddi3+0x109>
  801f58:	39 0c 24             	cmp    %ecx,(%esp)
  801f5b:	77 0c                	ja     801f69 <__umoddi3+0x115>
  801f5d:	89 f2                	mov    %esi,%edx
  801f5f:	29 f9                	sub    %edi,%ecx
  801f61:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f65:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f69:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f6d:	83 c4 1c             	add    $0x1c,%esp
  801f70:	5b                   	pop    %ebx
  801f71:	5e                   	pop    %esi
  801f72:	5f                   	pop    %edi
  801f73:	5d                   	pop    %ebp
  801f74:	c3                   	ret    
  801f75:	8d 76 00             	lea    0x0(%esi),%esi
  801f78:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f7c:	73 88                	jae    801f06 <__umoddi3+0xb2>
  801f7e:	66 90                	xchg   %ax,%ax
  801f80:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f84:	1b 14 24             	sbb    (%esp),%edx
  801f87:	89 d1                	mov    %edx,%ecx
  801f89:	89 c3                	mov    %eax,%ebx
  801f8b:	e9 76 ff ff ff       	jmp    801f06 <__umoddi3+0xb2>
