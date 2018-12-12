
obj/user/hello.debug:     file format elf32-i386


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
  80002c:	e8 2d 00 00 00       	call   80005e <libmain>
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
  800039:	68 20 1f 80 00       	push   $0x801f20
  80003e:	e8 15 01 00 00       	call   800158 <cprintf>
	cprintf("i am environment %08x\n", thisenv->env_id);
  800043:	a1 04 40 80 00       	mov    0x804004,%eax
  800048:	8b 40 48             	mov    0x48(%eax),%eax
  80004b:	83 c4 08             	add    $0x8,%esp
  80004e:	50                   	push   %eax
  80004f:	68 2e 1f 80 00       	push   $0x801f2e
  800054:	e8 ff 00 00 00       	call   800158 <cprintf>
}
  800059:	83 c4 10             	add    $0x10,%esp
  80005c:	c9                   	leave  
  80005d:	c3                   	ret    

0080005e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80005e:	55                   	push   %ebp
  80005f:	89 e5                	mov    %esp,%ebp
  800061:	56                   	push   %esi
  800062:	53                   	push   %ebx
  800063:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800066:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800069:	e8 88 0a 00 00       	call   800af6 <sys_getenvid>
  80006e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800073:	89 c2                	mov    %eax,%edx
  800075:	c1 e2 05             	shl    $0x5,%edx
  800078:	29 c2                	sub    %eax,%edx
  80007a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800081:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800086:	85 db                	test   %ebx,%ebx
  800088:	7e 07                	jle    800091 <libmain+0x33>
		binaryname = argv[0];
  80008a:	8b 06                	mov    (%esi),%eax
  80008c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800091:	83 ec 08             	sub    $0x8,%esp
  800094:	56                   	push   %esi
  800095:	53                   	push   %ebx
  800096:	e8 98 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009b:	e8 0a 00 00 00       	call   8000aa <exit>
}
  8000a0:	83 c4 10             	add    $0x10,%esp
  8000a3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a6:	5b                   	pop    %ebx
  8000a7:	5e                   	pop    %esi
  8000a8:	5d                   	pop    %ebp
  8000a9:	c3                   	ret    

008000aa <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000aa:	55                   	push   %ebp
  8000ab:	89 e5                	mov    %esp,%ebp
  8000ad:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b0:	e8 e9 0e 00 00       	call   800f9e <close_all>
	sys_env_destroy(0);
  8000b5:	83 ec 0c             	sub    $0xc,%esp
  8000b8:	6a 00                	push   $0x0
  8000ba:	e8 f6 09 00 00       	call   800ab5 <sys_env_destroy>
}
  8000bf:	83 c4 10             	add    $0x10,%esp
  8000c2:	c9                   	leave  
  8000c3:	c3                   	ret    

008000c4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	53                   	push   %ebx
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000ce:	8b 13                	mov    (%ebx),%edx
  8000d0:	8d 42 01             	lea    0x1(%edx),%eax
  8000d3:	89 03                	mov    %eax,(%ebx)
  8000d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000d8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000dc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e1:	74 08                	je     8000eb <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e3:	ff 43 04             	incl   0x4(%ebx)
}
  8000e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000e9:	c9                   	leave  
  8000ea:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000eb:	83 ec 08             	sub    $0x8,%esp
  8000ee:	68 ff 00 00 00       	push   $0xff
  8000f3:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f6:	50                   	push   %eax
  8000f7:	e8 7c 09 00 00       	call   800a78 <sys_cputs>
		b->idx = 0;
  8000fc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	eb dc                	jmp    8000e3 <putch+0x1f>

00800107 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800107:	55                   	push   %ebp
  800108:	89 e5                	mov    %esp,%ebp
  80010a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800110:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800117:	00 00 00 
	b.cnt = 0;
  80011a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800121:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800124:	ff 75 0c             	pushl  0xc(%ebp)
  800127:	ff 75 08             	pushl  0x8(%ebp)
  80012a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800130:	50                   	push   %eax
  800131:	68 c4 00 80 00       	push   $0x8000c4
  800136:	e8 17 01 00 00       	call   800252 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013b:	83 c4 08             	add    $0x8,%esp
  80013e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800144:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014a:	50                   	push   %eax
  80014b:	e8 28 09 00 00       	call   800a78 <sys_cputs>

	return b.cnt;
}
  800150:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800156:	c9                   	leave  
  800157:	c3                   	ret    

00800158 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800158:	55                   	push   %ebp
  800159:	89 e5                	mov    %esp,%ebp
  80015b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80015e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800161:	50                   	push   %eax
  800162:	ff 75 08             	pushl  0x8(%ebp)
  800165:	e8 9d ff ff ff       	call   800107 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	57                   	push   %edi
  800170:	56                   	push   %esi
  800171:	53                   	push   %ebx
  800172:	83 ec 1c             	sub    $0x1c,%esp
  800175:	89 c7                	mov    %eax,%edi
  800177:	89 d6                	mov    %edx,%esi
  800179:	8b 45 08             	mov    0x8(%ebp),%eax
  80017c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80017f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800182:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800185:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800188:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800190:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800193:	39 d3                	cmp    %edx,%ebx
  800195:	72 05                	jb     80019c <printnum+0x30>
  800197:	39 45 10             	cmp    %eax,0x10(%ebp)
  80019a:	77 78                	ja     800214 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80019c:	83 ec 0c             	sub    $0xc,%esp
  80019f:	ff 75 18             	pushl  0x18(%ebp)
  8001a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001a8:	53                   	push   %ebx
  8001a9:	ff 75 10             	pushl  0x10(%ebp)
  8001ac:	83 ec 08             	sub    $0x8,%esp
  8001af:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bb:	e8 00 1b 00 00       	call   801cc0 <__udivdi3>
  8001c0:	83 c4 18             	add    $0x18,%esp
  8001c3:	52                   	push   %edx
  8001c4:	50                   	push   %eax
  8001c5:	89 f2                	mov    %esi,%edx
  8001c7:	89 f8                	mov    %edi,%eax
  8001c9:	e8 9e ff ff ff       	call   80016c <printnum>
  8001ce:	83 c4 20             	add    $0x20,%esp
  8001d1:	eb 11                	jmp    8001e4 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d3:	83 ec 08             	sub    $0x8,%esp
  8001d6:	56                   	push   %esi
  8001d7:	ff 75 18             	pushl  0x18(%ebp)
  8001da:	ff d7                	call   *%edi
  8001dc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001df:	4b                   	dec    %ebx
  8001e0:	85 db                	test   %ebx,%ebx
  8001e2:	7f ef                	jg     8001d3 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e4:	83 ec 08             	sub    $0x8,%esp
  8001e7:	56                   	push   %esi
  8001e8:	83 ec 04             	sub    $0x4,%esp
  8001eb:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001ee:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f7:	e8 d4 1b 00 00       	call   801dd0 <__umoddi3>
  8001fc:	83 c4 14             	add    $0x14,%esp
  8001ff:	0f be 80 4f 1f 80 00 	movsbl 0x801f4f(%eax),%eax
  800206:	50                   	push   %eax
  800207:	ff d7                	call   *%edi
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5f                   	pop    %edi
  800212:	5d                   	pop    %ebp
  800213:	c3                   	ret    
  800214:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800217:	eb c6                	jmp    8001df <printnum+0x73>

00800219 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800219:	55                   	push   %ebp
  80021a:	89 e5                	mov    %esp,%ebp
  80021c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80021f:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800222:	8b 10                	mov    (%eax),%edx
  800224:	3b 50 04             	cmp    0x4(%eax),%edx
  800227:	73 0a                	jae    800233 <sprintputch+0x1a>
		*b->buf++ = ch;
  800229:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022c:	89 08                	mov    %ecx,(%eax)
  80022e:	8b 45 08             	mov    0x8(%ebp),%eax
  800231:	88 02                	mov    %al,(%edx)
}
  800233:	5d                   	pop    %ebp
  800234:	c3                   	ret    

00800235 <printfmt>:
{
  800235:	55                   	push   %ebp
  800236:	89 e5                	mov    %esp,%ebp
  800238:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80023e:	50                   	push   %eax
  80023f:	ff 75 10             	pushl  0x10(%ebp)
  800242:	ff 75 0c             	pushl  0xc(%ebp)
  800245:	ff 75 08             	pushl  0x8(%ebp)
  800248:	e8 05 00 00 00       	call   800252 <vprintfmt>
}
  80024d:	83 c4 10             	add    $0x10,%esp
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <vprintfmt>:
{
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	57                   	push   %edi
  800256:	56                   	push   %esi
  800257:	53                   	push   %ebx
  800258:	83 ec 2c             	sub    $0x2c,%esp
  80025b:	8b 75 08             	mov    0x8(%ebp),%esi
  80025e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800261:	8b 7d 10             	mov    0x10(%ebp),%edi
  800264:	e9 ae 03 00 00       	jmp    800617 <vprintfmt+0x3c5>
  800269:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80026d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800274:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80027b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800282:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800287:	8d 47 01             	lea    0x1(%edi),%eax
  80028a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028d:	8a 17                	mov    (%edi),%dl
  80028f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800292:	3c 55                	cmp    $0x55,%al
  800294:	0f 87 fe 03 00 00    	ja     800698 <vprintfmt+0x446>
  80029a:	0f b6 c0             	movzbl %al,%eax
  80029d:	ff 24 85 a0 20 80 00 	jmp    *0x8020a0(,%eax,4)
  8002a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a7:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ab:	eb da                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b4:	eb d1                	jmp    800287 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b6:	0f b6 d2             	movzbl %dl,%edx
  8002b9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c7:	01 c0                	add    %eax,%eax
  8002c9:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8002cd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d3:	83 f9 09             	cmp    $0x9,%ecx
  8002d6:	77 52                	ja     80032a <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8002d8:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8002d9:	eb e9                	jmp    8002c4 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8002db:	8b 45 14             	mov    0x14(%ebp),%eax
  8002de:	8b 00                	mov    (%eax),%eax
  8002e0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e6:	8d 40 04             	lea    0x4(%eax),%eax
  8002e9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f3:	79 92                	jns    800287 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800302:	eb 83                	jmp    800287 <vprintfmt+0x35>
  800304:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800308:	78 08                	js     800312 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80030a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030d:	e9 75 ff ff ff       	jmp    800287 <vprintfmt+0x35>
  800312:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800319:	eb ef                	jmp    80030a <vprintfmt+0xb8>
  80031b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80031e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800325:	e9 5d ff ff ff       	jmp    800287 <vprintfmt+0x35>
  80032a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800330:	eb bd                	jmp    8002ef <vprintfmt+0x9d>
			lflag++;
  800332:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800333:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800336:	e9 4c ff ff ff       	jmp    800287 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033b:	8b 45 14             	mov    0x14(%ebp),%eax
  80033e:	8d 78 04             	lea    0x4(%eax),%edi
  800341:	83 ec 08             	sub    $0x8,%esp
  800344:	53                   	push   %ebx
  800345:	ff 30                	pushl  (%eax)
  800347:	ff d6                	call   *%esi
			break;
  800349:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80034f:	e9 c0 02 00 00       	jmp    800614 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800354:	8b 45 14             	mov    0x14(%ebp),%eax
  800357:	8d 78 04             	lea    0x4(%eax),%edi
  80035a:	8b 00                	mov    (%eax),%eax
  80035c:	85 c0                	test   %eax,%eax
  80035e:	78 2a                	js     80038a <vprintfmt+0x138>
  800360:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800362:	83 f8 0f             	cmp    $0xf,%eax
  800365:	7f 27                	jg     80038e <vprintfmt+0x13c>
  800367:	8b 04 85 00 22 80 00 	mov    0x802200(,%eax,4),%eax
  80036e:	85 c0                	test   %eax,%eax
  800370:	74 1c                	je     80038e <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800372:	50                   	push   %eax
  800373:	68 31 23 80 00       	push   $0x802331
  800378:	53                   	push   %ebx
  800379:	56                   	push   %esi
  80037a:	e8 b6 fe ff ff       	call   800235 <printfmt>
  80037f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800382:	89 7d 14             	mov    %edi,0x14(%ebp)
  800385:	e9 8a 02 00 00       	jmp    800614 <vprintfmt+0x3c2>
  80038a:	f7 d8                	neg    %eax
  80038c:	eb d2                	jmp    800360 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80038e:	52                   	push   %edx
  80038f:	68 67 1f 80 00       	push   $0x801f67
  800394:	53                   	push   %ebx
  800395:	56                   	push   %esi
  800396:	e8 9a fe ff ff       	call   800235 <printfmt>
  80039b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80039e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a1:	e9 6e 02 00 00       	jmp    800614 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a9:	83 c0 04             	add    $0x4,%eax
  8003ac:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003af:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b2:	8b 38                	mov    (%eax),%edi
  8003b4:	85 ff                	test   %edi,%edi
  8003b6:	74 39                	je     8003f1 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003b8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003bc:	0f 8e a9 00 00 00    	jle    80046b <vprintfmt+0x219>
  8003c2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c6:	0f 84 a7 00 00 00    	je     800473 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d2:	57                   	push   %edi
  8003d3:	e8 6b 03 00 00       	call   800743 <strnlen>
  8003d8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003db:	29 c1                	sub    %eax,%ecx
  8003dd:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003e0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ea:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ed:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ef:	eb 14                	jmp    800405 <vprintfmt+0x1b3>
				p = "(null)";
  8003f1:	bf 60 1f 80 00       	mov    $0x801f60,%edi
  8003f6:	eb c0                	jmp    8003b8 <vprintfmt+0x166>
					putch(padc, putdat);
  8003f8:	83 ec 08             	sub    $0x8,%esp
  8003fb:	53                   	push   %ebx
  8003fc:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ff:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800401:	4f                   	dec    %edi
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	85 ff                	test   %edi,%edi
  800407:	7f ef                	jg     8003f8 <vprintfmt+0x1a6>
  800409:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80040c:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80040f:	89 c8                	mov    %ecx,%eax
  800411:	85 c9                	test   %ecx,%ecx
  800413:	78 10                	js     800425 <vprintfmt+0x1d3>
  800415:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800418:	29 c1                	sub    %eax,%ecx
  80041a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80041d:	89 75 08             	mov    %esi,0x8(%ebp)
  800420:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800423:	eb 15                	jmp    80043a <vprintfmt+0x1e8>
  800425:	b8 00 00 00 00       	mov    $0x0,%eax
  80042a:	eb e9                	jmp    800415 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80042c:	83 ec 08             	sub    $0x8,%esp
  80042f:	53                   	push   %ebx
  800430:	52                   	push   %edx
  800431:	ff 55 08             	call   *0x8(%ebp)
  800434:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800437:	ff 4d e0             	decl   -0x20(%ebp)
  80043a:	47                   	inc    %edi
  80043b:	8a 47 ff             	mov    -0x1(%edi),%al
  80043e:	0f be d0             	movsbl %al,%edx
  800441:	85 d2                	test   %edx,%edx
  800443:	74 59                	je     80049e <vprintfmt+0x24c>
  800445:	85 f6                	test   %esi,%esi
  800447:	78 03                	js     80044c <vprintfmt+0x1fa>
  800449:	4e                   	dec    %esi
  80044a:	78 2f                	js     80047b <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80044c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800450:	74 da                	je     80042c <vprintfmt+0x1da>
  800452:	0f be c0             	movsbl %al,%eax
  800455:	83 e8 20             	sub    $0x20,%eax
  800458:	83 f8 5e             	cmp    $0x5e,%eax
  80045b:	76 cf                	jbe    80042c <vprintfmt+0x1da>
					putch('?', putdat);
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	53                   	push   %ebx
  800461:	6a 3f                	push   $0x3f
  800463:	ff 55 08             	call   *0x8(%ebp)
  800466:	83 c4 10             	add    $0x10,%esp
  800469:	eb cc                	jmp    800437 <vprintfmt+0x1e5>
  80046b:	89 75 08             	mov    %esi,0x8(%ebp)
  80046e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800471:	eb c7                	jmp    80043a <vprintfmt+0x1e8>
  800473:	89 75 08             	mov    %esi,0x8(%ebp)
  800476:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800479:	eb bf                	jmp    80043a <vprintfmt+0x1e8>
  80047b:	8b 75 08             	mov    0x8(%ebp),%esi
  80047e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800481:	eb 0c                	jmp    80048f <vprintfmt+0x23d>
				putch(' ', putdat);
  800483:	83 ec 08             	sub    $0x8,%esp
  800486:	53                   	push   %ebx
  800487:	6a 20                	push   $0x20
  800489:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80048b:	4f                   	dec    %edi
  80048c:	83 c4 10             	add    $0x10,%esp
  80048f:	85 ff                	test   %edi,%edi
  800491:	7f f0                	jg     800483 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800493:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800496:	89 45 14             	mov    %eax,0x14(%ebp)
  800499:	e9 76 01 00 00       	jmp    800614 <vprintfmt+0x3c2>
  80049e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a1:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a4:	eb e9                	jmp    80048f <vprintfmt+0x23d>
	if (lflag >= 2)
  8004a6:	83 f9 01             	cmp    $0x1,%ecx
  8004a9:	7f 1f                	jg     8004ca <vprintfmt+0x278>
	else if (lflag)
  8004ab:	85 c9                	test   %ecx,%ecx
  8004ad:	75 48                	jne    8004f7 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8b 00                	mov    (%eax),%eax
  8004b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	c1 f9 1f             	sar    $0x1f,%ecx
  8004bc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c2:	8d 40 04             	lea    0x4(%eax),%eax
  8004c5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004c8:	eb 17                	jmp    8004e1 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8004ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cd:	8b 50 04             	mov    0x4(%eax),%edx
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004d8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004db:	8d 40 08             	lea    0x8(%eax),%eax
  8004de:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8004e1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8004e7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004eb:	78 25                	js     800512 <vprintfmt+0x2c0>
			base = 10;
  8004ed:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f2:	e9 03 01 00 00       	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8b 00                	mov    (%eax),%eax
  8004fc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ff:	89 c1                	mov    %eax,%ecx
  800501:	c1 f9 1f             	sar    $0x1f,%ecx
  800504:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800507:	8b 45 14             	mov    0x14(%ebp),%eax
  80050a:	8d 40 04             	lea    0x4(%eax),%eax
  80050d:	89 45 14             	mov    %eax,0x14(%ebp)
  800510:	eb cf                	jmp    8004e1 <vprintfmt+0x28f>
				putch('-', putdat);
  800512:	83 ec 08             	sub    $0x8,%esp
  800515:	53                   	push   %ebx
  800516:	6a 2d                	push   $0x2d
  800518:	ff d6                	call   *%esi
				num = -(long long) num;
  80051a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800520:	f7 da                	neg    %edx
  800522:	83 d1 00             	adc    $0x0,%ecx
  800525:	f7 d9                	neg    %ecx
  800527:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80052f:	e9 c6 00 00 00       	jmp    8005fa <vprintfmt+0x3a8>
	if (lflag >= 2)
  800534:	83 f9 01             	cmp    $0x1,%ecx
  800537:	7f 1e                	jg     800557 <vprintfmt+0x305>
	else if (lflag)
  800539:	85 c9                	test   %ecx,%ecx
  80053b:	75 32                	jne    80056f <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80053d:	8b 45 14             	mov    0x14(%ebp),%eax
  800540:	8b 10                	mov    (%eax),%edx
  800542:	b9 00 00 00 00       	mov    $0x0,%ecx
  800547:	8d 40 04             	lea    0x4(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800552:	e9 a3 00 00 00       	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800557:	8b 45 14             	mov    0x14(%ebp),%eax
  80055a:	8b 10                	mov    (%eax),%edx
  80055c:	8b 48 04             	mov    0x4(%eax),%ecx
  80055f:	8d 40 08             	lea    0x8(%eax),%eax
  800562:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800565:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056a:	e9 8b 00 00 00       	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80056f:	8b 45 14             	mov    0x14(%ebp),%eax
  800572:	8b 10                	mov    (%eax),%edx
  800574:	b9 00 00 00 00       	mov    $0x0,%ecx
  800579:	8d 40 04             	lea    0x4(%eax),%eax
  80057c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80057f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800584:	eb 74                	jmp    8005fa <vprintfmt+0x3a8>
	if (lflag >= 2)
  800586:	83 f9 01             	cmp    $0x1,%ecx
  800589:	7f 1b                	jg     8005a6 <vprintfmt+0x354>
	else if (lflag)
  80058b:	85 c9                	test   %ecx,%ecx
  80058d:	75 2c                	jne    8005bb <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	8b 10                	mov    (%eax),%edx
  800594:	b9 00 00 00 00       	mov    $0x0,%ecx
  800599:	8d 40 04             	lea    0x4(%eax),%eax
  80059c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80059f:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a4:	eb 54                	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a9:	8b 10                	mov    (%eax),%edx
  8005ab:	8b 48 04             	mov    0x4(%eax),%ecx
  8005ae:	8d 40 08             	lea    0x8(%eax),%eax
  8005b1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b4:	b8 08 00 00 00       	mov    $0x8,%eax
  8005b9:	eb 3f                	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8005be:	8b 10                	mov    (%eax),%edx
  8005c0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c5:	8d 40 04             	lea    0x4(%eax),%eax
  8005c8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005cb:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d0:	eb 28                	jmp    8005fa <vprintfmt+0x3a8>
			putch('0', putdat);
  8005d2:	83 ec 08             	sub    $0x8,%esp
  8005d5:	53                   	push   %ebx
  8005d6:	6a 30                	push   $0x30
  8005d8:	ff d6                	call   *%esi
			putch('x', putdat);
  8005da:	83 c4 08             	add    $0x8,%esp
  8005dd:	53                   	push   %ebx
  8005de:	6a 78                	push   $0x78
  8005e0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 10                	mov    (%eax),%edx
  8005e7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ec:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005ef:	8d 40 04             	lea    0x4(%eax),%eax
  8005f2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005fa:	83 ec 0c             	sub    $0xc,%esp
  8005fd:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800601:	57                   	push   %edi
  800602:	ff 75 e0             	pushl  -0x20(%ebp)
  800605:	50                   	push   %eax
  800606:	51                   	push   %ecx
  800607:	52                   	push   %edx
  800608:	89 da                	mov    %ebx,%edx
  80060a:	89 f0                	mov    %esi,%eax
  80060c:	e8 5b fb ff ff       	call   80016c <printnum>
			break;
  800611:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800614:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800617:	47                   	inc    %edi
  800618:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061c:	83 f8 25             	cmp    $0x25,%eax
  80061f:	0f 84 44 fc ff ff    	je     800269 <vprintfmt+0x17>
			if (ch == '\0')
  800625:	85 c0                	test   %eax,%eax
  800627:	0f 84 89 00 00 00    	je     8006b6 <vprintfmt+0x464>
			putch(ch, putdat);
  80062d:	83 ec 08             	sub    $0x8,%esp
  800630:	53                   	push   %ebx
  800631:	50                   	push   %eax
  800632:	ff d6                	call   *%esi
  800634:	83 c4 10             	add    $0x10,%esp
  800637:	eb de                	jmp    800617 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800639:	83 f9 01             	cmp    $0x1,%ecx
  80063c:	7f 1b                	jg     800659 <vprintfmt+0x407>
	else if (lflag)
  80063e:	85 c9                	test   %ecx,%ecx
  800640:	75 2c                	jne    80066e <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800652:	b8 10 00 00 00       	mov    $0x10,%eax
  800657:	eb a1                	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800659:	8b 45 14             	mov    0x14(%ebp),%eax
  80065c:	8b 10                	mov    (%eax),%edx
  80065e:	8b 48 04             	mov    0x4(%eax),%ecx
  800661:	8d 40 08             	lea    0x8(%eax),%eax
  800664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800667:	b8 10 00 00 00       	mov    $0x10,%eax
  80066c:	eb 8c                	jmp    8005fa <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80066e:	8b 45 14             	mov    0x14(%ebp),%eax
  800671:	8b 10                	mov    (%eax),%edx
  800673:	b9 00 00 00 00       	mov    $0x0,%ecx
  800678:	8d 40 04             	lea    0x4(%eax),%eax
  80067b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067e:	b8 10 00 00 00       	mov    $0x10,%eax
  800683:	e9 72 ff ff ff       	jmp    8005fa <vprintfmt+0x3a8>
			putch(ch, putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 25                	push   $0x25
  80068e:	ff d6                	call   *%esi
			break;
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	e9 7c ff ff ff       	jmp    800614 <vprintfmt+0x3c2>
			putch('%', putdat);
  800698:	83 ec 08             	sub    $0x8,%esp
  80069b:	53                   	push   %ebx
  80069c:	6a 25                	push   $0x25
  80069e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a0:	83 c4 10             	add    $0x10,%esp
  8006a3:	89 f8                	mov    %edi,%eax
  8006a5:	eb 01                	jmp    8006a8 <vprintfmt+0x456>
  8006a7:	48                   	dec    %eax
  8006a8:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ac:	75 f9                	jne    8006a7 <vprintfmt+0x455>
  8006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b1:	e9 5e ff ff ff       	jmp    800614 <vprintfmt+0x3c2>
}
  8006b6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006b9:	5b                   	pop    %ebx
  8006ba:	5e                   	pop    %esi
  8006bb:	5f                   	pop    %edi
  8006bc:	5d                   	pop    %ebp
  8006bd:	c3                   	ret    

008006be <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006be:	55                   	push   %ebp
  8006bf:	89 e5                	mov    %esp,%ebp
  8006c1:	83 ec 18             	sub    $0x18,%esp
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006cd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006db:	85 c0                	test   %eax,%eax
  8006dd:	74 26                	je     800705 <vsnprintf+0x47>
  8006df:	85 d2                	test   %edx,%edx
  8006e1:	7e 29                	jle    80070c <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e3:	ff 75 14             	pushl  0x14(%ebp)
  8006e6:	ff 75 10             	pushl  0x10(%ebp)
  8006e9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ec:	50                   	push   %eax
  8006ed:	68 19 02 80 00       	push   $0x800219
  8006f2:	e8 5b fb ff ff       	call   800252 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fa:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800700:	83 c4 10             	add    $0x10,%esp
}
  800703:	c9                   	leave  
  800704:	c3                   	ret    
		return -E_INVAL;
  800705:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070a:	eb f7                	jmp    800703 <vsnprintf+0x45>
  80070c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800711:	eb f0                	jmp    800703 <vsnprintf+0x45>

00800713 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800719:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071c:	50                   	push   %eax
  80071d:	ff 75 10             	pushl  0x10(%ebp)
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	ff 75 08             	pushl  0x8(%ebp)
  800726:	e8 93 ff ff ff       	call   8006be <vsnprintf>
	va_end(ap);

	return rc;
}
  80072b:	c9                   	leave  
  80072c:	c3                   	ret    

0080072d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072d:	55                   	push   %ebp
  80072e:	89 e5                	mov    %esp,%ebp
  800730:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800733:	b8 00 00 00 00       	mov    $0x0,%eax
  800738:	eb 01                	jmp    80073b <strlen+0xe>
		n++;
  80073a:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80073b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80073f:	75 f9                	jne    80073a <strlen+0xd>
	return n;
}
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074c:	b8 00 00 00 00       	mov    $0x0,%eax
  800751:	eb 01                	jmp    800754 <strnlen+0x11>
		n++;
  800753:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800754:	39 d0                	cmp    %edx,%eax
  800756:	74 06                	je     80075e <strnlen+0x1b>
  800758:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80075c:	75 f5                	jne    800753 <strnlen+0x10>
	return n;
}
  80075e:	5d                   	pop    %ebp
  80075f:	c3                   	ret    

00800760 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800760:	55                   	push   %ebp
  800761:	89 e5                	mov    %esp,%ebp
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076a:	89 c2                	mov    %eax,%edx
  80076c:	42                   	inc    %edx
  80076d:	41                   	inc    %ecx
  80076e:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800771:	88 5a ff             	mov    %bl,-0x1(%edx)
  800774:	84 db                	test   %bl,%bl
  800776:	75 f4                	jne    80076c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800778:	5b                   	pop    %ebx
  800779:	5d                   	pop    %ebp
  80077a:	c3                   	ret    

0080077b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80077b:	55                   	push   %ebp
  80077c:	89 e5                	mov    %esp,%ebp
  80077e:	53                   	push   %ebx
  80077f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800782:	53                   	push   %ebx
  800783:	e8 a5 ff ff ff       	call   80072d <strlen>
  800788:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80078b:	ff 75 0c             	pushl  0xc(%ebp)
  80078e:	01 d8                	add    %ebx,%eax
  800790:	50                   	push   %eax
  800791:	e8 ca ff ff ff       	call   800760 <strcpy>
	return dst;
}
  800796:	89 d8                	mov    %ebx,%eax
  800798:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079b:	c9                   	leave  
  80079c:	c3                   	ret    

0080079d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	56                   	push   %esi
  8007a1:	53                   	push   %ebx
  8007a2:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007a8:	89 f3                	mov    %esi,%ebx
  8007aa:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007ad:	89 f2                	mov    %esi,%edx
  8007af:	eb 0c                	jmp    8007bd <strncpy+0x20>
		*dst++ = *src;
  8007b1:	42                   	inc    %edx
  8007b2:	8a 01                	mov    (%ecx),%al
  8007b4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007b7:	80 39 01             	cmpb   $0x1,(%ecx)
  8007ba:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007bd:	39 da                	cmp    %ebx,%edx
  8007bf:	75 f0                	jne    8007b1 <strncpy+0x14>
	}
	return ret;
}
  8007c1:	89 f0                	mov    %esi,%eax
  8007c3:	5b                   	pop    %ebx
  8007c4:	5e                   	pop    %esi
  8007c5:	5d                   	pop    %ebp
  8007c6:	c3                   	ret    

008007c7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007c7:	55                   	push   %ebp
  8007c8:	89 e5                	mov    %esp,%ebp
  8007ca:	56                   	push   %esi
  8007cb:	53                   	push   %ebx
  8007cc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d2:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007d5:	85 c0                	test   %eax,%eax
  8007d7:	74 20                	je     8007f9 <strlcpy+0x32>
  8007d9:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8007dd:	89 f0                	mov    %esi,%eax
  8007df:	eb 05                	jmp    8007e6 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007e1:	40                   	inc    %eax
  8007e2:	42                   	inc    %edx
  8007e3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007e6:	39 d8                	cmp    %ebx,%eax
  8007e8:	74 06                	je     8007f0 <strlcpy+0x29>
  8007ea:	8a 0a                	mov    (%edx),%cl
  8007ec:	84 c9                	test   %cl,%cl
  8007ee:	75 f1                	jne    8007e1 <strlcpy+0x1a>
		*dst = '\0';
  8007f0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f3:	29 f0                	sub    %esi,%eax
}
  8007f5:	5b                   	pop    %ebx
  8007f6:	5e                   	pop    %esi
  8007f7:	5d                   	pop    %ebp
  8007f8:	c3                   	ret    
  8007f9:	89 f0                	mov    %esi,%eax
  8007fb:	eb f6                	jmp    8007f3 <strlcpy+0x2c>

008007fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007fd:	55                   	push   %ebp
  8007fe:	89 e5                	mov    %esp,%ebp
  800800:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800803:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800806:	eb 02                	jmp    80080a <strcmp+0xd>
		p++, q++;
  800808:	41                   	inc    %ecx
  800809:	42                   	inc    %edx
	while (*p && *p == *q)
  80080a:	8a 01                	mov    (%ecx),%al
  80080c:	84 c0                	test   %al,%al
  80080e:	74 04                	je     800814 <strcmp+0x17>
  800810:	3a 02                	cmp    (%edx),%al
  800812:	74 f4                	je     800808 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800814:	0f b6 c0             	movzbl %al,%eax
  800817:	0f b6 12             	movzbl (%edx),%edx
  80081a:	29 d0                	sub    %edx,%eax
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	53                   	push   %ebx
  800822:	8b 45 08             	mov    0x8(%ebp),%eax
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
  800828:	89 c3                	mov    %eax,%ebx
  80082a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80082d:	eb 02                	jmp    800831 <strncmp+0x13>
		n--, p++, q++;
  80082f:	40                   	inc    %eax
  800830:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800831:	39 d8                	cmp    %ebx,%eax
  800833:	74 15                	je     80084a <strncmp+0x2c>
  800835:	8a 08                	mov    (%eax),%cl
  800837:	84 c9                	test   %cl,%cl
  800839:	74 04                	je     80083f <strncmp+0x21>
  80083b:	3a 0a                	cmp    (%edx),%cl
  80083d:	74 f0                	je     80082f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80083f:	0f b6 00             	movzbl (%eax),%eax
  800842:	0f b6 12             	movzbl (%edx),%edx
  800845:	29 d0                	sub    %edx,%eax
}
  800847:	5b                   	pop    %ebx
  800848:	5d                   	pop    %ebp
  800849:	c3                   	ret    
		return 0;
  80084a:	b8 00 00 00 00       	mov    $0x0,%eax
  80084f:	eb f6                	jmp    800847 <strncmp+0x29>

00800851 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800851:	55                   	push   %ebp
  800852:	89 e5                	mov    %esp,%ebp
  800854:	8b 45 08             	mov    0x8(%ebp),%eax
  800857:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80085a:	8a 10                	mov    (%eax),%dl
  80085c:	84 d2                	test   %dl,%dl
  80085e:	74 07                	je     800867 <strchr+0x16>
		if (*s == c)
  800860:	38 ca                	cmp    %cl,%dl
  800862:	74 08                	je     80086c <strchr+0x1b>
	for (; *s; s++)
  800864:	40                   	inc    %eax
  800865:	eb f3                	jmp    80085a <strchr+0x9>
			return (char *) s;
	return 0;
  800867:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80086c:	5d                   	pop    %ebp
  80086d:	c3                   	ret    

0080086e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80086e:	55                   	push   %ebp
  80086f:	89 e5                	mov    %esp,%ebp
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800877:	8a 10                	mov    (%eax),%dl
  800879:	84 d2                	test   %dl,%dl
  80087b:	74 07                	je     800884 <strfind+0x16>
		if (*s == c)
  80087d:	38 ca                	cmp    %cl,%dl
  80087f:	74 03                	je     800884 <strfind+0x16>
	for (; *s; s++)
  800881:	40                   	inc    %eax
  800882:	eb f3                	jmp    800877 <strfind+0x9>
			break;
	return (char *) s;
}
  800884:	5d                   	pop    %ebp
  800885:	c3                   	ret    

00800886 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800886:	55                   	push   %ebp
  800887:	89 e5                	mov    %esp,%ebp
  800889:	57                   	push   %edi
  80088a:	56                   	push   %esi
  80088b:	53                   	push   %ebx
  80088c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80088f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800892:	85 c9                	test   %ecx,%ecx
  800894:	74 13                	je     8008a9 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800896:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80089c:	75 05                	jne    8008a3 <memset+0x1d>
  80089e:	f6 c1 03             	test   $0x3,%cl
  8008a1:	74 0d                	je     8008b0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a6:	fc                   	cld    
  8008a7:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008a9:	89 f8                	mov    %edi,%eax
  8008ab:	5b                   	pop    %ebx
  8008ac:	5e                   	pop    %esi
  8008ad:	5f                   	pop    %edi
  8008ae:	5d                   	pop    %ebp
  8008af:	c3                   	ret    
		c &= 0xFF;
  8008b0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008b4:	89 d3                	mov    %edx,%ebx
  8008b6:	c1 e3 08             	shl    $0x8,%ebx
  8008b9:	89 d0                	mov    %edx,%eax
  8008bb:	c1 e0 18             	shl    $0x18,%eax
  8008be:	89 d6                	mov    %edx,%esi
  8008c0:	c1 e6 10             	shl    $0x10,%esi
  8008c3:	09 f0                	or     %esi,%eax
  8008c5:	09 c2                	or     %eax,%edx
  8008c7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008c9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008cc:	89 d0                	mov    %edx,%eax
  8008ce:	fc                   	cld    
  8008cf:	f3 ab                	rep stos %eax,%es:(%edi)
  8008d1:	eb d6                	jmp    8008a9 <memset+0x23>

008008d3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008d3:	55                   	push   %ebp
  8008d4:	89 e5                	mov    %esp,%ebp
  8008d6:	57                   	push   %edi
  8008d7:	56                   	push   %esi
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008de:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008e1:	39 c6                	cmp    %eax,%esi
  8008e3:	73 33                	jae    800918 <memmove+0x45>
  8008e5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008e8:	39 d0                	cmp    %edx,%eax
  8008ea:	73 2c                	jae    800918 <memmove+0x45>
		s += n;
		d += n;
  8008ec:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008ef:	89 d6                	mov    %edx,%esi
  8008f1:	09 fe                	or     %edi,%esi
  8008f3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008f9:	75 13                	jne    80090e <memmove+0x3b>
  8008fb:	f6 c1 03             	test   $0x3,%cl
  8008fe:	75 0e                	jne    80090e <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800900:	83 ef 04             	sub    $0x4,%edi
  800903:	8d 72 fc             	lea    -0x4(%edx),%esi
  800906:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800909:	fd                   	std    
  80090a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090c:	eb 07                	jmp    800915 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80090e:	4f                   	dec    %edi
  80090f:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800912:	fd                   	std    
  800913:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800915:	fc                   	cld    
  800916:	eb 13                	jmp    80092b <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800918:	89 f2                	mov    %esi,%edx
  80091a:	09 c2                	or     %eax,%edx
  80091c:	f6 c2 03             	test   $0x3,%dl
  80091f:	75 05                	jne    800926 <memmove+0x53>
  800921:	f6 c1 03             	test   $0x3,%cl
  800924:	74 09                	je     80092f <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800926:	89 c7                	mov    %eax,%edi
  800928:	fc                   	cld    
  800929:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80092b:	5e                   	pop    %esi
  80092c:	5f                   	pop    %edi
  80092d:	5d                   	pop    %ebp
  80092e:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80092f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800932:	89 c7                	mov    %eax,%edi
  800934:	fc                   	cld    
  800935:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800937:	eb f2                	jmp    80092b <memmove+0x58>

00800939 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800939:	55                   	push   %ebp
  80093a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80093c:	ff 75 10             	pushl  0x10(%ebp)
  80093f:	ff 75 0c             	pushl  0xc(%ebp)
  800942:	ff 75 08             	pushl  0x8(%ebp)
  800945:	e8 89 ff ff ff       	call   8008d3 <memmove>
}
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	56                   	push   %esi
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	89 c6                	mov    %eax,%esi
  800956:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800959:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80095c:	39 f0                	cmp    %esi,%eax
  80095e:	74 16                	je     800976 <memcmp+0x2a>
		if (*s1 != *s2)
  800960:	8a 08                	mov    (%eax),%cl
  800962:	8a 1a                	mov    (%edx),%bl
  800964:	38 d9                	cmp    %bl,%cl
  800966:	75 04                	jne    80096c <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800968:	40                   	inc    %eax
  800969:	42                   	inc    %edx
  80096a:	eb f0                	jmp    80095c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80096c:	0f b6 c1             	movzbl %cl,%eax
  80096f:	0f b6 db             	movzbl %bl,%ebx
  800972:	29 d8                	sub    %ebx,%eax
  800974:	eb 05                	jmp    80097b <memcmp+0x2f>
	}

	return 0;
  800976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800988:	89 c2                	mov    %eax,%edx
  80098a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80098d:	39 d0                	cmp    %edx,%eax
  80098f:	73 07                	jae    800998 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800991:	38 08                	cmp    %cl,(%eax)
  800993:	74 03                	je     800998 <memfind+0x19>
	for (; s < ends; s++)
  800995:	40                   	inc    %eax
  800996:	eb f5                	jmp    80098d <memfind+0xe>
			break;
	return (void *) s;
}
  800998:	5d                   	pop    %ebp
  800999:	c3                   	ret    

0080099a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	57                   	push   %edi
  80099e:	56                   	push   %esi
  80099f:	53                   	push   %ebx
  8009a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a3:	eb 01                	jmp    8009a6 <strtol+0xc>
		s++;
  8009a5:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009a6:	8a 01                	mov    (%ecx),%al
  8009a8:	3c 20                	cmp    $0x20,%al
  8009aa:	74 f9                	je     8009a5 <strtol+0xb>
  8009ac:	3c 09                	cmp    $0x9,%al
  8009ae:	74 f5                	je     8009a5 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009b0:	3c 2b                	cmp    $0x2b,%al
  8009b2:	74 2b                	je     8009df <strtol+0x45>
		s++;
	else if (*s == '-')
  8009b4:	3c 2d                	cmp    $0x2d,%al
  8009b6:	74 2f                	je     8009e7 <strtol+0x4d>
	int neg = 0;
  8009b8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009bd:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009c4:	75 12                	jne    8009d8 <strtol+0x3e>
  8009c6:	80 39 30             	cmpb   $0x30,(%ecx)
  8009c9:	74 24                	je     8009ef <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009cf:	75 07                	jne    8009d8 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8009d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009dd:	eb 4e                	jmp    800a2d <strtol+0x93>
		s++;
  8009df:	41                   	inc    %ecx
	int neg = 0;
  8009e0:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e5:	eb d6                	jmp    8009bd <strtol+0x23>
		s++, neg = 1;
  8009e7:	41                   	inc    %ecx
  8009e8:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ed:	eb ce                	jmp    8009bd <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ef:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009f3:	74 10                	je     800a05 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  8009f5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f9:	75 dd                	jne    8009d8 <strtol+0x3e>
		s++, base = 8;
  8009fb:	41                   	inc    %ecx
  8009fc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a03:	eb d3                	jmp    8009d8 <strtol+0x3e>
		s += 2, base = 16;
  800a05:	83 c1 02             	add    $0x2,%ecx
  800a08:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a0f:	eb c7                	jmp    8009d8 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a11:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a14:	89 f3                	mov    %esi,%ebx
  800a16:	80 fb 19             	cmp    $0x19,%bl
  800a19:	77 24                	ja     800a3f <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a1b:	0f be d2             	movsbl %dl,%edx
  800a1e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a21:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a24:	7d 2b                	jge    800a51 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a26:	41                   	inc    %ecx
  800a27:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a2b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a2d:	8a 11                	mov    (%ecx),%dl
  800a2f:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a32:	80 fb 09             	cmp    $0x9,%bl
  800a35:	77 da                	ja     800a11 <strtol+0x77>
			dig = *s - '0';
  800a37:	0f be d2             	movsbl %dl,%edx
  800a3a:	83 ea 30             	sub    $0x30,%edx
  800a3d:	eb e2                	jmp    800a21 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a3f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a42:	89 f3                	mov    %esi,%ebx
  800a44:	80 fb 19             	cmp    $0x19,%bl
  800a47:	77 08                	ja     800a51 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a49:	0f be d2             	movsbl %dl,%edx
  800a4c:	83 ea 37             	sub    $0x37,%edx
  800a4f:	eb d0                	jmp    800a21 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a51:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a55:	74 05                	je     800a5c <strtol+0xc2>
		*endptr = (char *) s;
  800a57:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a5c:	85 ff                	test   %edi,%edi
  800a5e:	74 02                	je     800a62 <strtol+0xc8>
  800a60:	f7 d8                	neg    %eax
}
  800a62:	5b                   	pop    %ebx
  800a63:	5e                   	pop    %esi
  800a64:	5f                   	pop    %edi
  800a65:	5d                   	pop    %ebp
  800a66:	c3                   	ret    

00800a67 <atoi>:

int
atoi(const char *s)
{
  800a67:	55                   	push   %ebp
  800a68:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800a6a:	6a 0a                	push   $0xa
  800a6c:	6a 00                	push   $0x0
  800a6e:	ff 75 08             	pushl  0x8(%ebp)
  800a71:	e8 24 ff ff ff       	call   80099a <strtol>
}
  800a76:	c9                   	leave  
  800a77:	c3                   	ret    

00800a78 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a78:	55                   	push   %ebp
  800a79:	89 e5                	mov    %esp,%ebp
  800a7b:	57                   	push   %edi
  800a7c:	56                   	push   %esi
  800a7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a86:	8b 55 08             	mov    0x8(%ebp),%edx
  800a89:	89 c3                	mov    %eax,%ebx
  800a8b:	89 c7                	mov    %eax,%edi
  800a8d:	89 c6                	mov    %eax,%esi
  800a8f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a91:	5b                   	pop    %ebx
  800a92:	5e                   	pop    %esi
  800a93:	5f                   	pop    %edi
  800a94:	5d                   	pop    %ebp
  800a95:	c3                   	ret    

00800a96 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a96:	55                   	push   %ebp
  800a97:	89 e5                	mov    %esp,%ebp
  800a99:	57                   	push   %edi
  800a9a:	56                   	push   %esi
  800a9b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa1:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa6:	89 d1                	mov    %edx,%ecx
  800aa8:	89 d3                	mov    %edx,%ebx
  800aaa:	89 d7                	mov    %edx,%edi
  800aac:	89 d6                	mov    %edx,%esi
  800aae:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ab0:	5b                   	pop    %ebx
  800ab1:	5e                   	pop    %esi
  800ab2:	5f                   	pop    %edi
  800ab3:	5d                   	pop    %ebp
  800ab4:	c3                   	ret    

00800ab5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab5:	55                   	push   %ebp
  800ab6:	89 e5                	mov    %esp,%ebp
  800ab8:	57                   	push   %edi
  800ab9:	56                   	push   %esi
  800aba:	53                   	push   %ebx
  800abb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800abe:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ac8:	8b 55 08             	mov    0x8(%ebp),%edx
  800acb:	89 cb                	mov    %ecx,%ebx
  800acd:	89 cf                	mov    %ecx,%edi
  800acf:	89 ce                	mov    %ecx,%esi
  800ad1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ad3:	85 c0                	test   %eax,%eax
  800ad5:	7f 08                	jg     800adf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ada:	5b                   	pop    %ebx
  800adb:	5e                   	pop    %esi
  800adc:	5f                   	pop    %edi
  800add:	5d                   	pop    %ebp
  800ade:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800adf:	83 ec 0c             	sub    $0xc,%esp
  800ae2:	50                   	push   %eax
  800ae3:	6a 03                	push   $0x3
  800ae5:	68 5f 22 80 00       	push   $0x80225f
  800aea:	6a 23                	push   $0x23
  800aec:	68 7c 22 80 00       	push   $0x80227c
  800af1:	e8 df 0f 00 00       	call   801ad5 <_panic>

00800af6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800af6:	55                   	push   %ebp
  800af7:	89 e5                	mov    %esp,%ebp
  800af9:	57                   	push   %edi
  800afa:	56                   	push   %esi
  800afb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afc:	ba 00 00 00 00       	mov    $0x0,%edx
  800b01:	b8 02 00 00 00       	mov    $0x2,%eax
  800b06:	89 d1                	mov    %edx,%ecx
  800b08:	89 d3                	mov    %edx,%ebx
  800b0a:	89 d7                	mov    %edx,%edi
  800b0c:	89 d6                	mov    %edx,%esi
  800b0e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5f                   	pop    %edi
  800b13:	5d                   	pop    %ebp
  800b14:	c3                   	ret    

00800b15 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	57                   	push   %edi
  800b19:	56                   	push   %esi
  800b1a:	53                   	push   %ebx
  800b1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b1e:	be 00 00 00 00       	mov    $0x0,%esi
  800b23:	b8 04 00 00 00       	mov    $0x4,%eax
  800b28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b31:	89 f7                	mov    %esi,%edi
  800b33:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b35:	85 c0                	test   %eax,%eax
  800b37:	7f 08                	jg     800b41 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b39:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5f                   	pop    %edi
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b41:	83 ec 0c             	sub    $0xc,%esp
  800b44:	50                   	push   %eax
  800b45:	6a 04                	push   $0x4
  800b47:	68 5f 22 80 00       	push   $0x80225f
  800b4c:	6a 23                	push   $0x23
  800b4e:	68 7c 22 80 00       	push   $0x80227c
  800b53:	e8 7d 0f 00 00       	call   801ad5 <_panic>

00800b58 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b58:	55                   	push   %ebp
  800b59:	89 e5                	mov    %esp,%ebp
  800b5b:	57                   	push   %edi
  800b5c:	56                   	push   %esi
  800b5d:	53                   	push   %ebx
  800b5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b61:	b8 05 00 00 00       	mov    $0x5,%eax
  800b66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b6f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b72:	8b 75 18             	mov    0x18(%ebp),%esi
  800b75:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b77:	85 c0                	test   %eax,%eax
  800b79:	7f 08                	jg     800b83 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7e:	5b                   	pop    %ebx
  800b7f:	5e                   	pop    %esi
  800b80:	5f                   	pop    %edi
  800b81:	5d                   	pop    %ebp
  800b82:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b83:	83 ec 0c             	sub    $0xc,%esp
  800b86:	50                   	push   %eax
  800b87:	6a 05                	push   $0x5
  800b89:	68 5f 22 80 00       	push   $0x80225f
  800b8e:	6a 23                	push   $0x23
  800b90:	68 7c 22 80 00       	push   $0x80227c
  800b95:	e8 3b 0f 00 00       	call   801ad5 <_panic>

00800b9a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	57                   	push   %edi
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ba8:	b8 06 00 00 00       	mov    $0x6,%eax
  800bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	89 df                	mov    %ebx,%edi
  800bb5:	89 de                	mov    %ebx,%esi
  800bb7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bb9:	85 c0                	test   %eax,%eax
  800bbb:	7f 08                	jg     800bc5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc0:	5b                   	pop    %ebx
  800bc1:	5e                   	pop    %esi
  800bc2:	5f                   	pop    %edi
  800bc3:	5d                   	pop    %ebp
  800bc4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc5:	83 ec 0c             	sub    $0xc,%esp
  800bc8:	50                   	push   %eax
  800bc9:	6a 06                	push   $0x6
  800bcb:	68 5f 22 80 00       	push   $0x80225f
  800bd0:	6a 23                	push   $0x23
  800bd2:	68 7c 22 80 00       	push   $0x80227c
  800bd7:	e8 f9 0e 00 00       	call   801ad5 <_panic>

00800bdc <sys_yield>:

void
sys_yield(void)
{
  800bdc:	55                   	push   %ebp
  800bdd:	89 e5                	mov    %esp,%ebp
  800bdf:	57                   	push   %edi
  800be0:	56                   	push   %esi
  800be1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bec:	89 d1                	mov    %edx,%ecx
  800bee:	89 d3                	mov    %edx,%ebx
  800bf0:	89 d7                	mov    %edx,%edi
  800bf2:	89 d6                	mov    %edx,%esi
  800bf4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf6:	5b                   	pop    %ebx
  800bf7:	5e                   	pop    %esi
  800bf8:	5f                   	pop    %edi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    

00800bfb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bfb:	55                   	push   %ebp
  800bfc:	89 e5                	mov    %esp,%ebp
  800bfe:	57                   	push   %edi
  800bff:	56                   	push   %esi
  800c00:	53                   	push   %ebx
  800c01:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c04:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c09:	b8 08 00 00 00       	mov    $0x8,%eax
  800c0e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c11:	8b 55 08             	mov    0x8(%ebp),%edx
  800c14:	89 df                	mov    %ebx,%edi
  800c16:	89 de                	mov    %ebx,%esi
  800c18:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1a:	85 c0                	test   %eax,%eax
  800c1c:	7f 08                	jg     800c26 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c1e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c21:	5b                   	pop    %ebx
  800c22:	5e                   	pop    %esi
  800c23:	5f                   	pop    %edi
  800c24:	5d                   	pop    %ebp
  800c25:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c26:	83 ec 0c             	sub    $0xc,%esp
  800c29:	50                   	push   %eax
  800c2a:	6a 08                	push   $0x8
  800c2c:	68 5f 22 80 00       	push   $0x80225f
  800c31:	6a 23                	push   $0x23
  800c33:	68 7c 22 80 00       	push   $0x80227c
  800c38:	e8 98 0e 00 00       	call   801ad5 <_panic>

00800c3d <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c3d:	55                   	push   %ebp
  800c3e:	89 e5                	mov    %esp,%ebp
  800c40:	57                   	push   %edi
  800c41:	56                   	push   %esi
  800c42:	53                   	push   %ebx
  800c43:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c46:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c50:	8b 55 08             	mov    0x8(%ebp),%edx
  800c53:	89 cb                	mov    %ecx,%ebx
  800c55:	89 cf                	mov    %ecx,%edi
  800c57:	89 ce                	mov    %ecx,%esi
  800c59:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5b:	85 c0                	test   %eax,%eax
  800c5d:	7f 08                	jg     800c67 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c62:	5b                   	pop    %ebx
  800c63:	5e                   	pop    %esi
  800c64:	5f                   	pop    %edi
  800c65:	5d                   	pop    %ebp
  800c66:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c67:	83 ec 0c             	sub    $0xc,%esp
  800c6a:	50                   	push   %eax
  800c6b:	6a 0c                	push   $0xc
  800c6d:	68 5f 22 80 00       	push   $0x80225f
  800c72:	6a 23                	push   $0x23
  800c74:	68 7c 22 80 00       	push   $0x80227c
  800c79:	e8 57 0e 00 00       	call   801ad5 <_panic>

00800c7e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
  800c84:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c87:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8c:	b8 09 00 00 00       	mov    $0x9,%eax
  800c91:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c94:	8b 55 08             	mov    0x8(%ebp),%edx
  800c97:	89 df                	mov    %ebx,%edi
  800c99:	89 de                	mov    %ebx,%esi
  800c9b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9d:	85 c0                	test   %eax,%eax
  800c9f:	7f 08                	jg     800ca9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca4:	5b                   	pop    %ebx
  800ca5:	5e                   	pop    %esi
  800ca6:	5f                   	pop    %edi
  800ca7:	5d                   	pop    %ebp
  800ca8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	50                   	push   %eax
  800cad:	6a 09                	push   $0x9
  800caf:	68 5f 22 80 00       	push   $0x80225f
  800cb4:	6a 23                	push   $0x23
  800cb6:	68 7c 22 80 00       	push   $0x80227c
  800cbb:	e8 15 0e 00 00       	call   801ad5 <_panic>

00800cc0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc0:	55                   	push   %ebp
  800cc1:	89 e5                	mov    %esp,%ebp
  800cc3:	57                   	push   %edi
  800cc4:	56                   	push   %esi
  800cc5:	53                   	push   %ebx
  800cc6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cc9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cce:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd9:	89 df                	mov    %ebx,%edi
  800cdb:	89 de                	mov    %ebx,%esi
  800cdd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cdf:	85 c0                	test   %eax,%eax
  800ce1:	7f 08                	jg     800ceb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ce3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce6:	5b                   	pop    %ebx
  800ce7:	5e                   	pop    %esi
  800ce8:	5f                   	pop    %edi
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ceb:	83 ec 0c             	sub    $0xc,%esp
  800cee:	50                   	push   %eax
  800cef:	6a 0a                	push   $0xa
  800cf1:	68 5f 22 80 00       	push   $0x80225f
  800cf6:	6a 23                	push   $0x23
  800cf8:	68 7c 22 80 00       	push   $0x80227c
  800cfd:	e8 d3 0d 00 00       	call   801ad5 <_panic>

00800d02 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d08:	be 00 00 00 00       	mov    $0x0,%esi
  800d0d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d12:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d1e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d20:	5b                   	pop    %ebx
  800d21:	5e                   	pop    %esi
  800d22:	5f                   	pop    %edi
  800d23:	5d                   	pop    %ebp
  800d24:	c3                   	ret    

00800d25 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	57                   	push   %edi
  800d29:	56                   	push   %esi
  800d2a:	53                   	push   %ebx
  800d2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d33:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d38:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3b:	89 cb                	mov    %ecx,%ebx
  800d3d:	89 cf                	mov    %ecx,%edi
  800d3f:	89 ce                	mov    %ecx,%esi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4a:	5b                   	pop    %ebx
  800d4b:	5e                   	pop    %esi
  800d4c:	5f                   	pop    %edi
  800d4d:	5d                   	pop    %ebp
  800d4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d4f:	83 ec 0c             	sub    $0xc,%esp
  800d52:	50                   	push   %eax
  800d53:	6a 0e                	push   $0xe
  800d55:	68 5f 22 80 00       	push   $0x80225f
  800d5a:	6a 23                	push   $0x23
  800d5c:	68 7c 22 80 00       	push   $0x80227c
  800d61:	e8 6f 0d 00 00       	call   801ad5 <_panic>

00800d66 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6c:	be 00 00 00 00       	mov    $0x0,%esi
  800d71:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d76:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d79:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d7f:	89 f7                	mov    %esi,%edi
  800d81:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800d83:	5b                   	pop    %ebx
  800d84:	5e                   	pop    %esi
  800d85:	5f                   	pop    %edi
  800d86:	5d                   	pop    %ebp
  800d87:	c3                   	ret    

00800d88 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	b8 10 00 00 00       	mov    $0x10,%eax
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	89 f7                	mov    %esi,%edi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_set_console_color>:

void sys_set_console_color(int color) {
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db5:	b8 11 00 00 00       	mov    $0x11,%eax
  800dba:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbd:	89 cb                	mov    %ecx,%ebx
  800dbf:	89 cf                	mov    %ecx,%edi
  800dc1:	89 ce                	mov    %ecx,%esi
  800dc3:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800dc5:	5b                   	pop    %ebx
  800dc6:	5e                   	pop    %esi
  800dc7:	5f                   	pop    %edi
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	05 00 00 00 30       	add    $0x30000000,%eax
  800dd5:	c1 e8 0c             	shr    $0xc,%eax
}
  800dd8:	5d                   	pop    %ebp
  800dd9:	c3                   	ret    

00800dda <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800de5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dea:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800def:	5d                   	pop    %ebp
  800df0:	c3                   	ret    

00800df1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df1:	55                   	push   %ebp
  800df2:	89 e5                	mov    %esp,%ebp
  800df4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dfc:	89 c2                	mov    %eax,%edx
  800dfe:	c1 ea 16             	shr    $0x16,%edx
  800e01:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e08:	f6 c2 01             	test   $0x1,%dl
  800e0b:	74 2a                	je     800e37 <fd_alloc+0x46>
  800e0d:	89 c2                	mov    %eax,%edx
  800e0f:	c1 ea 0c             	shr    $0xc,%edx
  800e12:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e19:	f6 c2 01             	test   $0x1,%dl
  800e1c:	74 19                	je     800e37 <fd_alloc+0x46>
  800e1e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e23:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e28:	75 d2                	jne    800dfc <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e2a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e30:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e35:	eb 07                	jmp    800e3e <fd_alloc+0x4d>
			*fd_store = fd;
  800e37:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e43:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800e47:	77 39                	ja     800e82 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	c1 e0 0c             	shl    $0xc,%eax
  800e4f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e54:	89 c2                	mov    %eax,%edx
  800e56:	c1 ea 16             	shr    $0x16,%edx
  800e59:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e60:	f6 c2 01             	test   $0x1,%dl
  800e63:	74 24                	je     800e89 <fd_lookup+0x49>
  800e65:	89 c2                	mov    %eax,%edx
  800e67:	c1 ea 0c             	shr    $0xc,%edx
  800e6a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e71:	f6 c2 01             	test   $0x1,%dl
  800e74:	74 1a                	je     800e90 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	89 02                	mov    %eax,(%edx)
	return 0;
  800e7b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
		return -E_INVAL;
  800e82:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e87:	eb f7                	jmp    800e80 <fd_lookup+0x40>
		return -E_INVAL;
  800e89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e8e:	eb f0                	jmp    800e80 <fd_lookup+0x40>
  800e90:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e95:	eb e9                	jmp    800e80 <fd_lookup+0x40>

00800e97 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	83 ec 08             	sub    $0x8,%esp
  800e9d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea0:	ba 08 23 80 00       	mov    $0x802308,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ea5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eaa:	39 08                	cmp    %ecx,(%eax)
  800eac:	74 33                	je     800ee1 <dev_lookup+0x4a>
  800eae:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eb1:	8b 02                	mov    (%edx),%eax
  800eb3:	85 c0                	test   %eax,%eax
  800eb5:	75 f3                	jne    800eaa <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800eb7:	a1 04 40 80 00       	mov    0x804004,%eax
  800ebc:	8b 40 48             	mov    0x48(%eax),%eax
  800ebf:	83 ec 04             	sub    $0x4,%esp
  800ec2:	51                   	push   %ecx
  800ec3:	50                   	push   %eax
  800ec4:	68 8c 22 80 00       	push   $0x80228c
  800ec9:	e8 8a f2 ff ff       	call   800158 <cprintf>
	*dev = 0;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ed7:	83 c4 10             	add    $0x10,%esp
  800eda:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    
			*dev = devtab[i];
  800ee1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ee6:	b8 00 00 00 00       	mov    $0x0,%eax
  800eeb:	eb f2                	jmp    800edf <dev_lookup+0x48>

00800eed <fd_close>:
{
  800eed:	55                   	push   %ebp
  800eee:	89 e5                	mov    %esp,%ebp
  800ef0:	57                   	push   %edi
  800ef1:	56                   	push   %esi
  800ef2:	53                   	push   %ebx
  800ef3:	83 ec 1c             	sub    $0x1c,%esp
  800ef6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ef9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800efc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eff:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f00:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f06:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f09:	50                   	push   %eax
  800f0a:	e8 31 ff ff ff       	call   800e40 <fd_lookup>
  800f0f:	89 c7                	mov    %eax,%edi
  800f11:	83 c4 08             	add    $0x8,%esp
  800f14:	85 c0                	test   %eax,%eax
  800f16:	78 05                	js     800f1d <fd_close+0x30>
	    || fd != fd2)
  800f18:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800f1b:	74 13                	je     800f30 <fd_close+0x43>
		return (must_exist ? r : 0);
  800f1d:	84 db                	test   %bl,%bl
  800f1f:	75 05                	jne    800f26 <fd_close+0x39>
  800f21:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800f26:	89 f8                	mov    %edi,%eax
  800f28:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2b:	5b                   	pop    %ebx
  800f2c:	5e                   	pop    %esi
  800f2d:	5f                   	pop    %edi
  800f2e:	5d                   	pop    %ebp
  800f2f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f30:	83 ec 08             	sub    $0x8,%esp
  800f33:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f36:	50                   	push   %eax
  800f37:	ff 36                	pushl  (%esi)
  800f39:	e8 59 ff ff ff       	call   800e97 <dev_lookup>
  800f3e:	89 c7                	mov    %eax,%edi
  800f40:	83 c4 10             	add    $0x10,%esp
  800f43:	85 c0                	test   %eax,%eax
  800f45:	78 15                	js     800f5c <fd_close+0x6f>
		if (dev->dev_close)
  800f47:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4a:	8b 40 10             	mov    0x10(%eax),%eax
  800f4d:	85 c0                	test   %eax,%eax
  800f4f:	74 1b                	je     800f6c <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800f51:	83 ec 0c             	sub    $0xc,%esp
  800f54:	56                   	push   %esi
  800f55:	ff d0                	call   *%eax
  800f57:	89 c7                	mov    %eax,%edi
  800f59:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f5c:	83 ec 08             	sub    $0x8,%esp
  800f5f:	56                   	push   %esi
  800f60:	6a 00                	push   $0x0
  800f62:	e8 33 fc ff ff       	call   800b9a <sys_page_unmap>
	return r;
  800f67:	83 c4 10             	add    $0x10,%esp
  800f6a:	eb ba                	jmp    800f26 <fd_close+0x39>
			r = 0;
  800f6c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f71:	eb e9                	jmp    800f5c <fd_close+0x6f>

00800f73 <close>:

int
close(int fdnum)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f7c:	50                   	push   %eax
  800f7d:	ff 75 08             	pushl  0x8(%ebp)
  800f80:	e8 bb fe ff ff       	call   800e40 <fd_lookup>
  800f85:	83 c4 08             	add    $0x8,%esp
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	78 10                	js     800f9c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f8c:	83 ec 08             	sub    $0x8,%esp
  800f8f:	6a 01                	push   $0x1
  800f91:	ff 75 f4             	pushl  -0xc(%ebp)
  800f94:	e8 54 ff ff ff       	call   800eed <fd_close>
  800f99:	83 c4 10             	add    $0x10,%esp
}
  800f9c:	c9                   	leave  
  800f9d:	c3                   	ret    

00800f9e <close_all>:

void
close_all(void)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	53                   	push   %ebx
  800fa2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fa5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800faa:	83 ec 0c             	sub    $0xc,%esp
  800fad:	53                   	push   %ebx
  800fae:	e8 c0 ff ff ff       	call   800f73 <close>
	for (i = 0; i < MAXFD; i++)
  800fb3:	43                   	inc    %ebx
  800fb4:	83 c4 10             	add    $0x10,%esp
  800fb7:	83 fb 20             	cmp    $0x20,%ebx
  800fba:	75 ee                	jne    800faa <close_all+0xc>
}
  800fbc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fbf:	c9                   	leave  
  800fc0:	c3                   	ret    

00800fc1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fc1:	55                   	push   %ebp
  800fc2:	89 e5                	mov    %esp,%ebp
  800fc4:	57                   	push   %edi
  800fc5:	56                   	push   %esi
  800fc6:	53                   	push   %ebx
  800fc7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fcd:	50                   	push   %eax
  800fce:	ff 75 08             	pushl  0x8(%ebp)
  800fd1:	e8 6a fe ff ff       	call   800e40 <fd_lookup>
  800fd6:	89 c3                	mov    %eax,%ebx
  800fd8:	83 c4 08             	add    $0x8,%esp
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	0f 88 81 00 00 00    	js     801064 <dup+0xa3>
		return r;
	close(newfdnum);
  800fe3:	83 ec 0c             	sub    $0xc,%esp
  800fe6:	ff 75 0c             	pushl  0xc(%ebp)
  800fe9:	e8 85 ff ff ff       	call   800f73 <close>

	newfd = INDEX2FD(newfdnum);
  800fee:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ff1:	c1 e6 0c             	shl    $0xc,%esi
  800ff4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800ffa:	83 c4 04             	add    $0x4,%esp
  800ffd:	ff 75 e4             	pushl  -0x1c(%ebp)
  801000:	e8 d5 fd ff ff       	call   800dda <fd2data>
  801005:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801007:	89 34 24             	mov    %esi,(%esp)
  80100a:	e8 cb fd ff ff       	call   800dda <fd2data>
  80100f:	83 c4 10             	add    $0x10,%esp
  801012:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801014:	89 d8                	mov    %ebx,%eax
  801016:	c1 e8 16             	shr    $0x16,%eax
  801019:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801020:	a8 01                	test   $0x1,%al
  801022:	74 11                	je     801035 <dup+0x74>
  801024:	89 d8                	mov    %ebx,%eax
  801026:	c1 e8 0c             	shr    $0xc,%eax
  801029:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801030:	f6 c2 01             	test   $0x1,%dl
  801033:	75 39                	jne    80106e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801035:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801038:	89 d0                	mov    %edx,%eax
  80103a:	c1 e8 0c             	shr    $0xc,%eax
  80103d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	25 07 0e 00 00       	and    $0xe07,%eax
  80104c:	50                   	push   %eax
  80104d:	56                   	push   %esi
  80104e:	6a 00                	push   $0x0
  801050:	52                   	push   %edx
  801051:	6a 00                	push   $0x0
  801053:	e8 00 fb ff ff       	call   800b58 <sys_page_map>
  801058:	89 c3                	mov    %eax,%ebx
  80105a:	83 c4 20             	add    $0x20,%esp
  80105d:	85 c0                	test   %eax,%eax
  80105f:	78 31                	js     801092 <dup+0xd1>
		goto err;

	return newfdnum;
  801061:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801064:	89 d8                	mov    %ebx,%eax
  801066:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801069:	5b                   	pop    %ebx
  80106a:	5e                   	pop    %esi
  80106b:	5f                   	pop    %edi
  80106c:	5d                   	pop    %ebp
  80106d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80106e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801075:	83 ec 0c             	sub    $0xc,%esp
  801078:	25 07 0e 00 00       	and    $0xe07,%eax
  80107d:	50                   	push   %eax
  80107e:	57                   	push   %edi
  80107f:	6a 00                	push   $0x0
  801081:	53                   	push   %ebx
  801082:	6a 00                	push   $0x0
  801084:	e8 cf fa ff ff       	call   800b58 <sys_page_map>
  801089:	89 c3                	mov    %eax,%ebx
  80108b:	83 c4 20             	add    $0x20,%esp
  80108e:	85 c0                	test   %eax,%eax
  801090:	79 a3                	jns    801035 <dup+0x74>
	sys_page_unmap(0, newfd);
  801092:	83 ec 08             	sub    $0x8,%esp
  801095:	56                   	push   %esi
  801096:	6a 00                	push   $0x0
  801098:	e8 fd fa ff ff       	call   800b9a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80109d:	83 c4 08             	add    $0x8,%esp
  8010a0:	57                   	push   %edi
  8010a1:	6a 00                	push   $0x0
  8010a3:	e8 f2 fa ff ff       	call   800b9a <sys_page_unmap>
	return r;
  8010a8:	83 c4 10             	add    $0x10,%esp
  8010ab:	eb b7                	jmp    801064 <dup+0xa3>

008010ad <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	53                   	push   %ebx
  8010b1:	83 ec 14             	sub    $0x14,%esp
  8010b4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010b7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010ba:	50                   	push   %eax
  8010bb:	53                   	push   %ebx
  8010bc:	e8 7f fd ff ff       	call   800e40 <fd_lookup>
  8010c1:	83 c4 08             	add    $0x8,%esp
  8010c4:	85 c0                	test   %eax,%eax
  8010c6:	78 3f                	js     801107 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010c8:	83 ec 08             	sub    $0x8,%esp
  8010cb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010ce:	50                   	push   %eax
  8010cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d2:	ff 30                	pushl  (%eax)
  8010d4:	e8 be fd ff ff       	call   800e97 <dev_lookup>
  8010d9:	83 c4 10             	add    $0x10,%esp
  8010dc:	85 c0                	test   %eax,%eax
  8010de:	78 27                	js     801107 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e3:	8b 42 08             	mov    0x8(%edx),%eax
  8010e6:	83 e0 03             	and    $0x3,%eax
  8010e9:	83 f8 01             	cmp    $0x1,%eax
  8010ec:	74 1e                	je     80110c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f1:	8b 40 08             	mov    0x8(%eax),%eax
  8010f4:	85 c0                	test   %eax,%eax
  8010f6:	74 35                	je     80112d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010f8:	83 ec 04             	sub    $0x4,%esp
  8010fb:	ff 75 10             	pushl  0x10(%ebp)
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	52                   	push   %edx
  801102:	ff d0                	call   *%eax
  801104:	83 c4 10             	add    $0x10,%esp
}
  801107:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110a:	c9                   	leave  
  80110b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	8b 40 48             	mov    0x48(%eax),%eax
  801114:	83 ec 04             	sub    $0x4,%esp
  801117:	53                   	push   %ebx
  801118:	50                   	push   %eax
  801119:	68 cd 22 80 00       	push   $0x8022cd
  80111e:	e8 35 f0 ff ff       	call   800158 <cprintf>
		return -E_INVAL;
  801123:	83 c4 10             	add    $0x10,%esp
  801126:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112b:	eb da                	jmp    801107 <read+0x5a>
		return -E_NOT_SUPP;
  80112d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801132:	eb d3                	jmp    801107 <read+0x5a>

00801134 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801134:	55                   	push   %ebp
  801135:	89 e5                	mov    %esp,%ebp
  801137:	57                   	push   %edi
  801138:	56                   	push   %esi
  801139:	53                   	push   %ebx
  80113a:	83 ec 0c             	sub    $0xc,%esp
  80113d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801140:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801143:	bb 00 00 00 00       	mov    $0x0,%ebx
  801148:	39 f3                	cmp    %esi,%ebx
  80114a:	73 25                	jae    801171 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80114c:	83 ec 04             	sub    $0x4,%esp
  80114f:	89 f0                	mov    %esi,%eax
  801151:	29 d8                	sub    %ebx,%eax
  801153:	50                   	push   %eax
  801154:	89 d8                	mov    %ebx,%eax
  801156:	03 45 0c             	add    0xc(%ebp),%eax
  801159:	50                   	push   %eax
  80115a:	57                   	push   %edi
  80115b:	e8 4d ff ff ff       	call   8010ad <read>
		if (m < 0)
  801160:	83 c4 10             	add    $0x10,%esp
  801163:	85 c0                	test   %eax,%eax
  801165:	78 08                	js     80116f <readn+0x3b>
			return m;
		if (m == 0)
  801167:	85 c0                	test   %eax,%eax
  801169:	74 06                	je     801171 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80116b:	01 c3                	add    %eax,%ebx
  80116d:	eb d9                	jmp    801148 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80116f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801171:	89 d8                	mov    %ebx,%eax
  801173:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801176:	5b                   	pop    %ebx
  801177:	5e                   	pop    %esi
  801178:	5f                   	pop    %edi
  801179:	5d                   	pop    %ebp
  80117a:	c3                   	ret    

0080117b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	53                   	push   %ebx
  80117f:	83 ec 14             	sub    $0x14,%esp
  801182:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801185:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801188:	50                   	push   %eax
  801189:	53                   	push   %ebx
  80118a:	e8 b1 fc ff ff       	call   800e40 <fd_lookup>
  80118f:	83 c4 08             	add    $0x8,%esp
  801192:	85 c0                	test   %eax,%eax
  801194:	78 3a                	js     8011d0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801196:	83 ec 08             	sub    $0x8,%esp
  801199:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119c:	50                   	push   %eax
  80119d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a0:	ff 30                	pushl  (%eax)
  8011a2:	e8 f0 fc ff ff       	call   800e97 <dev_lookup>
  8011a7:	83 c4 10             	add    $0x10,%esp
  8011aa:	85 c0                	test   %eax,%eax
  8011ac:	78 22                	js     8011d0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011b5:	74 1e                	je     8011d5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011ba:	8b 52 0c             	mov    0xc(%edx),%edx
  8011bd:	85 d2                	test   %edx,%edx
  8011bf:	74 35                	je     8011f6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011c1:	83 ec 04             	sub    $0x4,%esp
  8011c4:	ff 75 10             	pushl  0x10(%ebp)
  8011c7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ca:	50                   	push   %eax
  8011cb:	ff d2                	call   *%edx
  8011cd:	83 c4 10             	add    $0x10,%esp
}
  8011d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d3:	c9                   	leave  
  8011d4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011da:	8b 40 48             	mov    0x48(%eax),%eax
  8011dd:	83 ec 04             	sub    $0x4,%esp
  8011e0:	53                   	push   %ebx
  8011e1:	50                   	push   %eax
  8011e2:	68 e9 22 80 00       	push   $0x8022e9
  8011e7:	e8 6c ef ff ff       	call   800158 <cprintf>
		return -E_INVAL;
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f4:	eb da                	jmp    8011d0 <write+0x55>
		return -E_NOT_SUPP;
  8011f6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fb:	eb d3                	jmp    8011d0 <write+0x55>

008011fd <seek>:

int
seek(int fdnum, off_t offset)
{
  8011fd:	55                   	push   %ebp
  8011fe:	89 e5                	mov    %esp,%ebp
  801200:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801203:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801206:	50                   	push   %eax
  801207:	ff 75 08             	pushl  0x8(%ebp)
  80120a:	e8 31 fc ff ff       	call   800e40 <fd_lookup>
  80120f:	83 c4 08             	add    $0x8,%esp
  801212:	85 c0                	test   %eax,%eax
  801214:	78 0e                	js     801224 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801216:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801219:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80121f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801224:	c9                   	leave  
  801225:	c3                   	ret    

00801226 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801226:	55                   	push   %ebp
  801227:	89 e5                	mov    %esp,%ebp
  801229:	53                   	push   %ebx
  80122a:	83 ec 14             	sub    $0x14,%esp
  80122d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801230:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801233:	50                   	push   %eax
  801234:	53                   	push   %ebx
  801235:	e8 06 fc ff ff       	call   800e40 <fd_lookup>
  80123a:	83 c4 08             	add    $0x8,%esp
  80123d:	85 c0                	test   %eax,%eax
  80123f:	78 37                	js     801278 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801241:	83 ec 08             	sub    $0x8,%esp
  801244:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801247:	50                   	push   %eax
  801248:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124b:	ff 30                	pushl  (%eax)
  80124d:	e8 45 fc ff ff       	call   800e97 <dev_lookup>
  801252:	83 c4 10             	add    $0x10,%esp
  801255:	85 c0                	test   %eax,%eax
  801257:	78 1f                	js     801278 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801259:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801260:	74 1b                	je     80127d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801265:	8b 52 18             	mov    0x18(%edx),%edx
  801268:	85 d2                	test   %edx,%edx
  80126a:	74 32                	je     80129e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	ff 75 0c             	pushl  0xc(%ebp)
  801272:	50                   	push   %eax
  801273:	ff d2                	call   *%edx
  801275:	83 c4 10             	add    $0x10,%esp
}
  801278:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127b:	c9                   	leave  
  80127c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80127d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801282:	8b 40 48             	mov    0x48(%eax),%eax
  801285:	83 ec 04             	sub    $0x4,%esp
  801288:	53                   	push   %ebx
  801289:	50                   	push   %eax
  80128a:	68 ac 22 80 00       	push   $0x8022ac
  80128f:	e8 c4 ee ff ff       	call   800158 <cprintf>
		return -E_INVAL;
  801294:	83 c4 10             	add    $0x10,%esp
  801297:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129c:	eb da                	jmp    801278 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80129e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a3:	eb d3                	jmp    801278 <ftruncate+0x52>

008012a5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012a5:	55                   	push   %ebp
  8012a6:	89 e5                	mov    %esp,%ebp
  8012a8:	53                   	push   %ebx
  8012a9:	83 ec 14             	sub    $0x14,%esp
  8012ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012af:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b2:	50                   	push   %eax
  8012b3:	ff 75 08             	pushl  0x8(%ebp)
  8012b6:	e8 85 fb ff ff       	call   800e40 <fd_lookup>
  8012bb:	83 c4 08             	add    $0x8,%esp
  8012be:	85 c0                	test   %eax,%eax
  8012c0:	78 4b                	js     80130d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c2:	83 ec 08             	sub    $0x8,%esp
  8012c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012c8:	50                   	push   %eax
  8012c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012cc:	ff 30                	pushl  (%eax)
  8012ce:	e8 c4 fb ff ff       	call   800e97 <dev_lookup>
  8012d3:	83 c4 10             	add    $0x10,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 33                	js     80130d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012dd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012e1:	74 2f                	je     801312 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012e3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012e6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012ed:	00 00 00 
	stat->st_type = 0;
  8012f0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012f7:	00 00 00 
	stat->st_dev = dev;
  8012fa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801300:	83 ec 08             	sub    $0x8,%esp
  801303:	53                   	push   %ebx
  801304:	ff 75 f0             	pushl  -0x10(%ebp)
  801307:	ff 50 14             	call   *0x14(%eax)
  80130a:	83 c4 10             	add    $0x10,%esp
}
  80130d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801310:	c9                   	leave  
  801311:	c3                   	ret    
		return -E_NOT_SUPP;
  801312:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801317:	eb f4                	jmp    80130d <fstat+0x68>

00801319 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801319:	55                   	push   %ebp
  80131a:	89 e5                	mov    %esp,%ebp
  80131c:	56                   	push   %esi
  80131d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	6a 00                	push   $0x0
  801323:	ff 75 08             	pushl  0x8(%ebp)
  801326:	e8 34 02 00 00       	call   80155f <open>
  80132b:	89 c3                	mov    %eax,%ebx
  80132d:	83 c4 10             	add    $0x10,%esp
  801330:	85 c0                	test   %eax,%eax
  801332:	78 1b                	js     80134f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801334:	83 ec 08             	sub    $0x8,%esp
  801337:	ff 75 0c             	pushl  0xc(%ebp)
  80133a:	50                   	push   %eax
  80133b:	e8 65 ff ff ff       	call   8012a5 <fstat>
  801340:	89 c6                	mov    %eax,%esi
	close(fd);
  801342:	89 1c 24             	mov    %ebx,(%esp)
  801345:	e8 29 fc ff ff       	call   800f73 <close>
	return r;
  80134a:	83 c4 10             	add    $0x10,%esp
  80134d:	89 f3                	mov    %esi,%ebx
}
  80134f:	89 d8                	mov    %ebx,%eax
  801351:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801354:	5b                   	pop    %ebx
  801355:	5e                   	pop    %esi
  801356:	5d                   	pop    %ebp
  801357:	c3                   	ret    

00801358 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	56                   	push   %esi
  80135c:	53                   	push   %ebx
  80135d:	89 c6                	mov    %eax,%esi
  80135f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801361:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801368:	74 27                	je     801391 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80136a:	6a 07                	push   $0x7
  80136c:	68 00 50 80 00       	push   $0x805000
  801371:	56                   	push   %esi
  801372:	ff 35 00 40 80 00    	pushl  0x804000
  801378:	e8 60 08 00 00       	call   801bdd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80137d:	83 c4 0c             	add    $0xc,%esp
  801380:	6a 00                	push   $0x0
  801382:	53                   	push   %ebx
  801383:	6a 00                	push   $0x0
  801385:	e8 ca 07 00 00       	call   801b54 <ipc_recv>
}
  80138a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138d:	5b                   	pop    %ebx
  80138e:	5e                   	pop    %esi
  80138f:	5d                   	pop    %ebp
  801390:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801391:	83 ec 0c             	sub    $0xc,%esp
  801394:	6a 01                	push   $0x1
  801396:	e8 9e 08 00 00       	call   801c39 <ipc_find_env>
  80139b:	a3 00 40 80 00       	mov    %eax,0x804000
  8013a0:	83 c4 10             	add    $0x10,%esp
  8013a3:	eb c5                	jmp    80136a <fsipc+0x12>

008013a5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013a5:	55                   	push   %ebp
  8013a6:	89 e5                	mov    %esp,%ebp
  8013a8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013be:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c3:	b8 02 00 00 00       	mov    $0x2,%eax
  8013c8:	e8 8b ff ff ff       	call   801358 <fsipc>
}
  8013cd:	c9                   	leave  
  8013ce:	c3                   	ret    

008013cf <devfile_flush>:
{
  8013cf:	55                   	push   %ebp
  8013d0:	89 e5                	mov    %esp,%ebp
  8013d2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013db:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8013ea:	e8 69 ff ff ff       	call   801358 <fsipc>
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <devfile_stat>:
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	53                   	push   %ebx
  8013f5:	83 ec 04             	sub    $0x4,%esp
  8013f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fe:	8b 40 0c             	mov    0xc(%eax),%eax
  801401:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801406:	ba 00 00 00 00       	mov    $0x0,%edx
  80140b:	b8 05 00 00 00       	mov    $0x5,%eax
  801410:	e8 43 ff ff ff       	call   801358 <fsipc>
  801415:	85 c0                	test   %eax,%eax
  801417:	78 2c                	js     801445 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801419:	83 ec 08             	sub    $0x8,%esp
  80141c:	68 00 50 80 00       	push   $0x805000
  801421:	53                   	push   %ebx
  801422:	e8 39 f3 ff ff       	call   800760 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801427:	a1 80 50 80 00       	mov    0x805080,%eax
  80142c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801432:	a1 84 50 80 00       	mov    0x805084,%eax
  801437:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80143d:	83 c4 10             	add    $0x10,%esp
  801440:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801445:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801448:	c9                   	leave  
  801449:	c3                   	ret    

0080144a <devfile_write>:
{
  80144a:	55                   	push   %ebp
  80144b:	89 e5                	mov    %esp,%ebp
  80144d:	53                   	push   %ebx
  80144e:	83 ec 04             	sub    $0x4,%esp
  801451:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801454:	89 d8                	mov    %ebx,%eax
  801456:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80145c:	76 05                	jbe    801463 <devfile_write+0x19>
  80145e:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801463:	8b 55 08             	mov    0x8(%ebp),%edx
  801466:	8b 52 0c             	mov    0xc(%edx),%edx
  801469:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80146f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801474:	83 ec 04             	sub    $0x4,%esp
  801477:	50                   	push   %eax
  801478:	ff 75 0c             	pushl  0xc(%ebp)
  80147b:	68 08 50 80 00       	push   $0x805008
  801480:	e8 4e f4 ff ff       	call   8008d3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801485:	ba 00 00 00 00       	mov    $0x0,%edx
  80148a:	b8 04 00 00 00       	mov    $0x4,%eax
  80148f:	e8 c4 fe ff ff       	call   801358 <fsipc>
  801494:	83 c4 10             	add    $0x10,%esp
  801497:	85 c0                	test   %eax,%eax
  801499:	78 0b                	js     8014a6 <devfile_write+0x5c>
	assert(r <= n);
  80149b:	39 c3                	cmp    %eax,%ebx
  80149d:	72 0c                	jb     8014ab <devfile_write+0x61>
	assert(r <= PGSIZE);
  80149f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014a4:	7f 1e                	jg     8014c4 <devfile_write+0x7a>
}
  8014a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a9:	c9                   	leave  
  8014aa:	c3                   	ret    
	assert(r <= n);
  8014ab:	68 18 23 80 00       	push   $0x802318
  8014b0:	68 1f 23 80 00       	push   $0x80231f
  8014b5:	68 98 00 00 00       	push   $0x98
  8014ba:	68 34 23 80 00       	push   $0x802334
  8014bf:	e8 11 06 00 00       	call   801ad5 <_panic>
	assert(r <= PGSIZE);
  8014c4:	68 3f 23 80 00       	push   $0x80233f
  8014c9:	68 1f 23 80 00       	push   $0x80231f
  8014ce:	68 99 00 00 00       	push   $0x99
  8014d3:	68 34 23 80 00       	push   $0x802334
  8014d8:	e8 f8 05 00 00       	call   801ad5 <_panic>

008014dd <devfile_read>:
{
  8014dd:	55                   	push   %ebp
  8014de:	89 e5                	mov    %esp,%ebp
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014eb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014f0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fb:	b8 03 00 00 00       	mov    $0x3,%eax
  801500:	e8 53 fe ff ff       	call   801358 <fsipc>
  801505:	89 c3                	mov    %eax,%ebx
  801507:	85 c0                	test   %eax,%eax
  801509:	78 1f                	js     80152a <devfile_read+0x4d>
	assert(r <= n);
  80150b:	39 c6                	cmp    %eax,%esi
  80150d:	72 24                	jb     801533 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80150f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801514:	7f 33                	jg     801549 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801516:	83 ec 04             	sub    $0x4,%esp
  801519:	50                   	push   %eax
  80151a:	68 00 50 80 00       	push   $0x805000
  80151f:	ff 75 0c             	pushl  0xc(%ebp)
  801522:	e8 ac f3 ff ff       	call   8008d3 <memmove>
	return r;
  801527:	83 c4 10             	add    $0x10,%esp
}
  80152a:	89 d8                	mov    %ebx,%eax
  80152c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80152f:	5b                   	pop    %ebx
  801530:	5e                   	pop    %esi
  801531:	5d                   	pop    %ebp
  801532:	c3                   	ret    
	assert(r <= n);
  801533:	68 18 23 80 00       	push   $0x802318
  801538:	68 1f 23 80 00       	push   $0x80231f
  80153d:	6a 7c                	push   $0x7c
  80153f:	68 34 23 80 00       	push   $0x802334
  801544:	e8 8c 05 00 00       	call   801ad5 <_panic>
	assert(r <= PGSIZE);
  801549:	68 3f 23 80 00       	push   $0x80233f
  80154e:	68 1f 23 80 00       	push   $0x80231f
  801553:	6a 7d                	push   $0x7d
  801555:	68 34 23 80 00       	push   $0x802334
  80155a:	e8 76 05 00 00       	call   801ad5 <_panic>

0080155f <open>:
{
  80155f:	55                   	push   %ebp
  801560:	89 e5                	mov    %esp,%ebp
  801562:	56                   	push   %esi
  801563:	53                   	push   %ebx
  801564:	83 ec 1c             	sub    $0x1c,%esp
  801567:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80156a:	56                   	push   %esi
  80156b:	e8 bd f1 ff ff       	call   80072d <strlen>
  801570:	83 c4 10             	add    $0x10,%esp
  801573:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801578:	7f 6c                	jg     8015e6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80157a:	83 ec 0c             	sub    $0xc,%esp
  80157d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801580:	50                   	push   %eax
  801581:	e8 6b f8 ff ff       	call   800df1 <fd_alloc>
  801586:	89 c3                	mov    %eax,%ebx
  801588:	83 c4 10             	add    $0x10,%esp
  80158b:	85 c0                	test   %eax,%eax
  80158d:	78 3c                	js     8015cb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80158f:	83 ec 08             	sub    $0x8,%esp
  801592:	56                   	push   %esi
  801593:	68 00 50 80 00       	push   $0x805000
  801598:	e8 c3 f1 ff ff       	call   800760 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8015ad:	e8 a6 fd ff ff       	call   801358 <fsipc>
  8015b2:	89 c3                	mov    %eax,%ebx
  8015b4:	83 c4 10             	add    $0x10,%esp
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	78 19                	js     8015d4 <open+0x75>
	return fd2num(fd);
  8015bb:	83 ec 0c             	sub    $0xc,%esp
  8015be:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c1:	e8 04 f8 ff ff       	call   800dca <fd2num>
  8015c6:	89 c3                	mov    %eax,%ebx
  8015c8:	83 c4 10             	add    $0x10,%esp
}
  8015cb:	89 d8                	mov    %ebx,%eax
  8015cd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d0:	5b                   	pop    %ebx
  8015d1:	5e                   	pop    %esi
  8015d2:	5d                   	pop    %ebp
  8015d3:	c3                   	ret    
		fd_close(fd, 0);
  8015d4:	83 ec 08             	sub    $0x8,%esp
  8015d7:	6a 00                	push   $0x0
  8015d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015dc:	e8 0c f9 ff ff       	call   800eed <fd_close>
		return r;
  8015e1:	83 c4 10             	add    $0x10,%esp
  8015e4:	eb e5                	jmp    8015cb <open+0x6c>
		return -E_BAD_PATH;
  8015e6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015eb:	eb de                	jmp    8015cb <open+0x6c>

008015ed <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f8:	b8 08 00 00 00       	mov    $0x8,%eax
  8015fd:	e8 56 fd ff ff       	call   801358 <fsipc>
}
  801602:	c9                   	leave  
  801603:	c3                   	ret    

00801604 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801604:	55                   	push   %ebp
  801605:	89 e5                	mov    %esp,%ebp
  801607:	56                   	push   %esi
  801608:	53                   	push   %ebx
  801609:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80160c:	83 ec 0c             	sub    $0xc,%esp
  80160f:	ff 75 08             	pushl  0x8(%ebp)
  801612:	e8 c3 f7 ff ff       	call   800dda <fd2data>
  801617:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801619:	83 c4 08             	add    $0x8,%esp
  80161c:	68 4b 23 80 00       	push   $0x80234b
  801621:	53                   	push   %ebx
  801622:	e8 39 f1 ff ff       	call   800760 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801627:	8b 46 04             	mov    0x4(%esi),%eax
  80162a:	2b 06                	sub    (%esi),%eax
  80162c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801632:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801639:	10 00 00 
	stat->st_dev = &devpipe;
  80163c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801643:	30 80 00 
	return 0;
}
  801646:	b8 00 00 00 00       	mov    $0x0,%eax
  80164b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80164e:	5b                   	pop    %ebx
  80164f:	5e                   	pop    %esi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	53                   	push   %ebx
  801656:	83 ec 0c             	sub    $0xc,%esp
  801659:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80165c:	53                   	push   %ebx
  80165d:	6a 00                	push   $0x0
  80165f:	e8 36 f5 ff ff       	call   800b9a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801664:	89 1c 24             	mov    %ebx,(%esp)
  801667:	e8 6e f7 ff ff       	call   800dda <fd2data>
  80166c:	83 c4 08             	add    $0x8,%esp
  80166f:	50                   	push   %eax
  801670:	6a 00                	push   $0x0
  801672:	e8 23 f5 ff ff       	call   800b9a <sys_page_unmap>
}
  801677:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <_pipeisclosed>:
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	57                   	push   %edi
  801680:	56                   	push   %esi
  801681:	53                   	push   %ebx
  801682:	83 ec 1c             	sub    $0x1c,%esp
  801685:	89 c7                	mov    %eax,%edi
  801687:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801689:	a1 04 40 80 00       	mov    0x804004,%eax
  80168e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801691:	83 ec 0c             	sub    $0xc,%esp
  801694:	57                   	push   %edi
  801695:	e8 e1 05 00 00       	call   801c7b <pageref>
  80169a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80169d:	89 34 24             	mov    %esi,(%esp)
  8016a0:	e8 d6 05 00 00       	call   801c7b <pageref>
		nn = thisenv->env_runs;
  8016a5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8016ab:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016ae:	83 c4 10             	add    $0x10,%esp
  8016b1:	39 cb                	cmp    %ecx,%ebx
  8016b3:	74 1b                	je     8016d0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016b5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016b8:	75 cf                	jne    801689 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016ba:	8b 42 58             	mov    0x58(%edx),%eax
  8016bd:	6a 01                	push   $0x1
  8016bf:	50                   	push   %eax
  8016c0:	53                   	push   %ebx
  8016c1:	68 52 23 80 00       	push   $0x802352
  8016c6:	e8 8d ea ff ff       	call   800158 <cprintf>
  8016cb:	83 c4 10             	add    $0x10,%esp
  8016ce:	eb b9                	jmp    801689 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016d0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016d3:	0f 94 c0             	sete   %al
  8016d6:	0f b6 c0             	movzbl %al,%eax
}
  8016d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016dc:	5b                   	pop    %ebx
  8016dd:	5e                   	pop    %esi
  8016de:	5f                   	pop    %edi
  8016df:	5d                   	pop    %ebp
  8016e0:	c3                   	ret    

008016e1 <devpipe_write>:
{
  8016e1:	55                   	push   %ebp
  8016e2:	89 e5                	mov    %esp,%ebp
  8016e4:	57                   	push   %edi
  8016e5:	56                   	push   %esi
  8016e6:	53                   	push   %ebx
  8016e7:	83 ec 18             	sub    $0x18,%esp
  8016ea:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016ed:	56                   	push   %esi
  8016ee:	e8 e7 f6 ff ff       	call   800dda <fd2data>
  8016f3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016f5:	83 c4 10             	add    $0x10,%esp
  8016f8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016fd:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801700:	74 41                	je     801743 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801702:	8b 53 04             	mov    0x4(%ebx),%edx
  801705:	8b 03                	mov    (%ebx),%eax
  801707:	83 c0 20             	add    $0x20,%eax
  80170a:	39 c2                	cmp    %eax,%edx
  80170c:	72 14                	jb     801722 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80170e:	89 da                	mov    %ebx,%edx
  801710:	89 f0                	mov    %esi,%eax
  801712:	e8 65 ff ff ff       	call   80167c <_pipeisclosed>
  801717:	85 c0                	test   %eax,%eax
  801719:	75 2c                	jne    801747 <devpipe_write+0x66>
			sys_yield();
  80171b:	e8 bc f4 ff ff       	call   800bdc <sys_yield>
  801720:	eb e0                	jmp    801702 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801722:	8b 45 0c             	mov    0xc(%ebp),%eax
  801725:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801728:	89 d0                	mov    %edx,%eax
  80172a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80172f:	78 0b                	js     80173c <devpipe_write+0x5b>
  801731:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801735:	42                   	inc    %edx
  801736:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801739:	47                   	inc    %edi
  80173a:	eb c1                	jmp    8016fd <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80173c:	48                   	dec    %eax
  80173d:	83 c8 e0             	or     $0xffffffe0,%eax
  801740:	40                   	inc    %eax
  801741:	eb ee                	jmp    801731 <devpipe_write+0x50>
	return i;
  801743:	89 f8                	mov    %edi,%eax
  801745:	eb 05                	jmp    80174c <devpipe_write+0x6b>
				return 0;
  801747:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5f                   	pop    %edi
  801752:	5d                   	pop    %ebp
  801753:	c3                   	ret    

00801754 <devpipe_read>:
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	57                   	push   %edi
  801758:	56                   	push   %esi
  801759:	53                   	push   %ebx
  80175a:	83 ec 18             	sub    $0x18,%esp
  80175d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801760:	57                   	push   %edi
  801761:	e8 74 f6 ff ff       	call   800dda <fd2data>
  801766:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801770:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801773:	74 46                	je     8017bb <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801775:	8b 06                	mov    (%esi),%eax
  801777:	3b 46 04             	cmp    0x4(%esi),%eax
  80177a:	75 22                	jne    80179e <devpipe_read+0x4a>
			if (i > 0)
  80177c:	85 db                	test   %ebx,%ebx
  80177e:	74 0a                	je     80178a <devpipe_read+0x36>
				return i;
  801780:	89 d8                	mov    %ebx,%eax
}
  801782:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801785:	5b                   	pop    %ebx
  801786:	5e                   	pop    %esi
  801787:	5f                   	pop    %edi
  801788:	5d                   	pop    %ebp
  801789:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  80178a:	89 f2                	mov    %esi,%edx
  80178c:	89 f8                	mov    %edi,%eax
  80178e:	e8 e9 fe ff ff       	call   80167c <_pipeisclosed>
  801793:	85 c0                	test   %eax,%eax
  801795:	75 28                	jne    8017bf <devpipe_read+0x6b>
			sys_yield();
  801797:	e8 40 f4 ff ff       	call   800bdc <sys_yield>
  80179c:	eb d7                	jmp    801775 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80179e:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8017a3:	78 0f                	js     8017b4 <devpipe_read+0x60>
  8017a5:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8017a9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ac:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8017af:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8017b1:	43                   	inc    %ebx
  8017b2:	eb bc                	jmp    801770 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017b4:	48                   	dec    %eax
  8017b5:	83 c8 e0             	or     $0xffffffe0,%eax
  8017b8:	40                   	inc    %eax
  8017b9:	eb ea                	jmp    8017a5 <devpipe_read+0x51>
	return i;
  8017bb:	89 d8                	mov    %ebx,%eax
  8017bd:	eb c3                	jmp    801782 <devpipe_read+0x2e>
				return 0;
  8017bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c4:	eb bc                	jmp    801782 <devpipe_read+0x2e>

008017c6 <pipe>:
{
  8017c6:	55                   	push   %ebp
  8017c7:	89 e5                	mov    %esp,%ebp
  8017c9:	56                   	push   %esi
  8017ca:	53                   	push   %ebx
  8017cb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017ce:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d1:	50                   	push   %eax
  8017d2:	e8 1a f6 ff ff       	call   800df1 <fd_alloc>
  8017d7:	89 c3                	mov    %eax,%ebx
  8017d9:	83 c4 10             	add    $0x10,%esp
  8017dc:	85 c0                	test   %eax,%eax
  8017de:	0f 88 2a 01 00 00    	js     80190e <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017e4:	83 ec 04             	sub    $0x4,%esp
  8017e7:	68 07 04 00 00       	push   $0x407
  8017ec:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ef:	6a 00                	push   $0x0
  8017f1:	e8 1f f3 ff ff       	call   800b15 <sys_page_alloc>
  8017f6:	89 c3                	mov    %eax,%ebx
  8017f8:	83 c4 10             	add    $0x10,%esp
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	0f 88 0b 01 00 00    	js     80190e <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801809:	50                   	push   %eax
  80180a:	e8 e2 f5 ff ff       	call   800df1 <fd_alloc>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	85 c0                	test   %eax,%eax
  801816:	0f 88 e2 00 00 00    	js     8018fe <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80181c:	83 ec 04             	sub    $0x4,%esp
  80181f:	68 07 04 00 00       	push   $0x407
  801824:	ff 75 f0             	pushl  -0x10(%ebp)
  801827:	6a 00                	push   $0x0
  801829:	e8 e7 f2 ff ff       	call   800b15 <sys_page_alloc>
  80182e:	89 c3                	mov    %eax,%ebx
  801830:	83 c4 10             	add    $0x10,%esp
  801833:	85 c0                	test   %eax,%eax
  801835:	0f 88 c3 00 00 00    	js     8018fe <pipe+0x138>
	va = fd2data(fd0);
  80183b:	83 ec 0c             	sub    $0xc,%esp
  80183e:	ff 75 f4             	pushl  -0xc(%ebp)
  801841:	e8 94 f5 ff ff       	call   800dda <fd2data>
  801846:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801848:	83 c4 0c             	add    $0xc,%esp
  80184b:	68 07 04 00 00       	push   $0x407
  801850:	50                   	push   %eax
  801851:	6a 00                	push   $0x0
  801853:	e8 bd f2 ff ff       	call   800b15 <sys_page_alloc>
  801858:	89 c3                	mov    %eax,%ebx
  80185a:	83 c4 10             	add    $0x10,%esp
  80185d:	85 c0                	test   %eax,%eax
  80185f:	0f 88 89 00 00 00    	js     8018ee <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801865:	83 ec 0c             	sub    $0xc,%esp
  801868:	ff 75 f0             	pushl  -0x10(%ebp)
  80186b:	e8 6a f5 ff ff       	call   800dda <fd2data>
  801870:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801877:	50                   	push   %eax
  801878:	6a 00                	push   $0x0
  80187a:	56                   	push   %esi
  80187b:	6a 00                	push   $0x0
  80187d:	e8 d6 f2 ff ff       	call   800b58 <sys_page_map>
  801882:	89 c3                	mov    %eax,%ebx
  801884:	83 c4 20             	add    $0x20,%esp
  801887:	85 c0                	test   %eax,%eax
  801889:	78 55                	js     8018e0 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80188b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801894:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801899:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018a0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ae:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018b5:	83 ec 0c             	sub    $0xc,%esp
  8018b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bb:	e8 0a f5 ff ff       	call   800dca <fd2num>
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018c5:	83 c4 04             	add    $0x4,%esp
  8018c8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cb:	e8 fa f4 ff ff       	call   800dca <fd2num>
  8018d0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018d6:	83 c4 10             	add    $0x10,%esp
  8018d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018de:	eb 2e                	jmp    80190e <pipe+0x148>
	sys_page_unmap(0, va);
  8018e0:	83 ec 08             	sub    $0x8,%esp
  8018e3:	56                   	push   %esi
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 af f2 ff ff       	call   800b9a <sys_page_unmap>
  8018eb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018ee:	83 ec 08             	sub    $0x8,%esp
  8018f1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 9f f2 ff ff       	call   800b9a <sys_page_unmap>
  8018fb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8018fe:	83 ec 08             	sub    $0x8,%esp
  801901:	ff 75 f4             	pushl  -0xc(%ebp)
  801904:	6a 00                	push   $0x0
  801906:	e8 8f f2 ff ff       	call   800b9a <sys_page_unmap>
  80190b:	83 c4 10             	add    $0x10,%esp
}
  80190e:	89 d8                	mov    %ebx,%eax
  801910:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801913:	5b                   	pop    %ebx
  801914:	5e                   	pop    %esi
  801915:	5d                   	pop    %ebp
  801916:	c3                   	ret    

00801917 <pipeisclosed>:
{
  801917:	55                   	push   %ebp
  801918:	89 e5                	mov    %esp,%ebp
  80191a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801920:	50                   	push   %eax
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	e8 17 f5 ff ff       	call   800e40 <fd_lookup>
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	85 c0                	test   %eax,%eax
  80192e:	78 18                	js     801948 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801930:	83 ec 0c             	sub    $0xc,%esp
  801933:	ff 75 f4             	pushl  -0xc(%ebp)
  801936:	e8 9f f4 ff ff       	call   800dda <fd2data>
	return _pipeisclosed(fd, p);
  80193b:	89 c2                	mov    %eax,%edx
  80193d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801940:	e8 37 fd ff ff       	call   80167c <_pipeisclosed>
  801945:	83 c4 10             	add    $0x10,%esp
}
  801948:	c9                   	leave  
  801949:	c3                   	ret    

0080194a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80194d:	b8 00 00 00 00       	mov    $0x0,%eax
  801952:	5d                   	pop    %ebp
  801953:	c3                   	ret    

00801954 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801954:	55                   	push   %ebp
  801955:	89 e5                	mov    %esp,%ebp
  801957:	53                   	push   %ebx
  801958:	83 ec 0c             	sub    $0xc,%esp
  80195b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80195e:	68 6a 23 80 00       	push   $0x80236a
  801963:	53                   	push   %ebx
  801964:	e8 f7 ed ff ff       	call   800760 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801969:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801970:	20 00 00 
	return 0;
}
  801973:	b8 00 00 00 00       	mov    $0x0,%eax
  801978:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197b:	c9                   	leave  
  80197c:	c3                   	ret    

0080197d <devcons_write>:
{
  80197d:	55                   	push   %ebp
  80197e:	89 e5                	mov    %esp,%ebp
  801980:	57                   	push   %edi
  801981:	56                   	push   %esi
  801982:	53                   	push   %ebx
  801983:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801989:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80198e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801994:	eb 1d                	jmp    8019b3 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801996:	83 ec 04             	sub    $0x4,%esp
  801999:	53                   	push   %ebx
  80199a:	03 45 0c             	add    0xc(%ebp),%eax
  80199d:	50                   	push   %eax
  80199e:	57                   	push   %edi
  80199f:	e8 2f ef ff ff       	call   8008d3 <memmove>
		sys_cputs(buf, m);
  8019a4:	83 c4 08             	add    $0x8,%esp
  8019a7:	53                   	push   %ebx
  8019a8:	57                   	push   %edi
  8019a9:	e8 ca f0 ff ff       	call   800a78 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019ae:	01 de                	add    %ebx,%esi
  8019b0:	83 c4 10             	add    $0x10,%esp
  8019b3:	89 f0                	mov    %esi,%eax
  8019b5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019b8:	73 11                	jae    8019cb <devcons_write+0x4e>
		m = n - tot;
  8019ba:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019bd:	29 f3                	sub    %esi,%ebx
  8019bf:	83 fb 7f             	cmp    $0x7f,%ebx
  8019c2:	76 d2                	jbe    801996 <devcons_write+0x19>
  8019c4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8019c9:	eb cb                	jmp    801996 <devcons_write+0x19>
}
  8019cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019ce:	5b                   	pop    %ebx
  8019cf:	5e                   	pop    %esi
  8019d0:	5f                   	pop    %edi
  8019d1:	5d                   	pop    %ebp
  8019d2:	c3                   	ret    

008019d3 <devcons_read>:
{
  8019d3:	55                   	push   %ebp
  8019d4:	89 e5                	mov    %esp,%ebp
  8019d6:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8019d9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019dd:	75 0c                	jne    8019eb <devcons_read+0x18>
		return 0;
  8019df:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e4:	eb 21                	jmp    801a07 <devcons_read+0x34>
		sys_yield();
  8019e6:	e8 f1 f1 ff ff       	call   800bdc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019eb:	e8 a6 f0 ff ff       	call   800a96 <sys_cgetc>
  8019f0:	85 c0                	test   %eax,%eax
  8019f2:	74 f2                	je     8019e6 <devcons_read+0x13>
	if (c < 0)
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 0f                	js     801a07 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8019f8:	83 f8 04             	cmp    $0x4,%eax
  8019fb:	74 0c                	je     801a09 <devcons_read+0x36>
	*(char*)vbuf = c;
  8019fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a00:	88 02                	mov    %al,(%edx)
	return 1;
  801a02:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a07:	c9                   	leave  
  801a08:	c3                   	ret    
		return 0;
  801a09:	b8 00 00 00 00       	mov    $0x0,%eax
  801a0e:	eb f7                	jmp    801a07 <devcons_read+0x34>

00801a10 <cputchar>:
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
  801a13:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a1c:	6a 01                	push   $0x1
  801a1e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a21:	50                   	push   %eax
  801a22:	e8 51 f0 ff ff       	call   800a78 <sys_cputs>
}
  801a27:	83 c4 10             	add    $0x10,%esp
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <getchar>:
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a32:	6a 01                	push   $0x1
  801a34:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a37:	50                   	push   %eax
  801a38:	6a 00                	push   $0x0
  801a3a:	e8 6e f6 ff ff       	call   8010ad <read>
	if (r < 0)
  801a3f:	83 c4 10             	add    $0x10,%esp
  801a42:	85 c0                	test   %eax,%eax
  801a44:	78 08                	js     801a4e <getchar+0x22>
	if (r < 1)
  801a46:	85 c0                	test   %eax,%eax
  801a48:	7e 06                	jle    801a50 <getchar+0x24>
	return c;
  801a4a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a4e:	c9                   	leave  
  801a4f:	c3                   	ret    
		return -E_EOF;
  801a50:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a55:	eb f7                	jmp    801a4e <getchar+0x22>

00801a57 <iscons>:
{
  801a57:	55                   	push   %ebp
  801a58:	89 e5                	mov    %esp,%ebp
  801a5a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a5d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a60:	50                   	push   %eax
  801a61:	ff 75 08             	pushl  0x8(%ebp)
  801a64:	e8 d7 f3 ff ff       	call   800e40 <fd_lookup>
  801a69:	83 c4 10             	add    $0x10,%esp
  801a6c:	85 c0                	test   %eax,%eax
  801a6e:	78 11                	js     801a81 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a73:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a79:	39 10                	cmp    %edx,(%eax)
  801a7b:	0f 94 c0             	sete   %al
  801a7e:	0f b6 c0             	movzbl %al,%eax
}
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <opencons>:
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a89:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8c:	50                   	push   %eax
  801a8d:	e8 5f f3 ff ff       	call   800df1 <fd_alloc>
  801a92:	83 c4 10             	add    $0x10,%esp
  801a95:	85 c0                	test   %eax,%eax
  801a97:	78 3a                	js     801ad3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a99:	83 ec 04             	sub    $0x4,%esp
  801a9c:	68 07 04 00 00       	push   $0x407
  801aa1:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa4:	6a 00                	push   $0x0
  801aa6:	e8 6a f0 ff ff       	call   800b15 <sys_page_alloc>
  801aab:	83 c4 10             	add    $0x10,%esp
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	78 21                	js     801ad3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ab2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801abd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ac7:	83 ec 0c             	sub    $0xc,%esp
  801aca:	50                   	push   %eax
  801acb:	e8 fa f2 ff ff       	call   800dca <fd2num>
  801ad0:	83 c4 10             	add    $0x10,%esp
}
  801ad3:	c9                   	leave  
  801ad4:	c3                   	ret    

00801ad5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ad5:	55                   	push   %ebp
  801ad6:	89 e5                	mov    %esp,%ebp
  801ad8:	57                   	push   %edi
  801ad9:	56                   	push   %esi
  801ada:	53                   	push   %ebx
  801adb:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801ae1:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801ae4:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801aea:	e8 07 f0 ff ff       	call   800af6 <sys_getenvid>
  801aef:	83 ec 04             	sub    $0x4,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	ff 75 08             	pushl  0x8(%ebp)
  801af8:	53                   	push   %ebx
  801af9:	50                   	push   %eax
  801afa:	68 78 23 80 00       	push   $0x802378
  801aff:	68 00 01 00 00       	push   $0x100
  801b04:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801b0a:	56                   	push   %esi
  801b0b:	e8 03 ec ff ff       	call   800713 <snprintf>
  801b10:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801b12:	83 c4 20             	add    $0x20,%esp
  801b15:	57                   	push   %edi
  801b16:	ff 75 10             	pushl  0x10(%ebp)
  801b19:	bf 00 01 00 00       	mov    $0x100,%edi
  801b1e:	89 f8                	mov    %edi,%eax
  801b20:	29 d8                	sub    %ebx,%eax
  801b22:	50                   	push   %eax
  801b23:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b26:	50                   	push   %eax
  801b27:	e8 92 eb ff ff       	call   8006be <vsnprintf>
  801b2c:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b2e:	83 c4 0c             	add    $0xc,%esp
  801b31:	68 63 23 80 00       	push   $0x802363
  801b36:	29 df                	sub    %ebx,%edi
  801b38:	57                   	push   %edi
  801b39:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b3c:	50                   	push   %eax
  801b3d:	e8 d1 eb ff ff       	call   800713 <snprintf>
	sys_cputs(buf, r);
  801b42:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b45:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801b47:	53                   	push   %ebx
  801b48:	56                   	push   %esi
  801b49:	e8 2a ef ff ff       	call   800a78 <sys_cputs>
  801b4e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b51:	cc                   	int3   
  801b52:	eb fd                	jmp    801b51 <_panic+0x7c>

00801b54 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
  801b57:	57                   	push   %edi
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b60:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b63:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b66:	85 ff                	test   %edi,%edi
  801b68:	74 53                	je     801bbd <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b6a:	83 ec 0c             	sub    $0xc,%esp
  801b6d:	57                   	push   %edi
  801b6e:	e8 b2 f1 ff ff       	call   800d25 <sys_ipc_recv>
  801b73:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b76:	85 db                	test   %ebx,%ebx
  801b78:	74 0b                	je     801b85 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b7a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b80:	8b 52 74             	mov    0x74(%edx),%edx
  801b83:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b85:	85 f6                	test   %esi,%esi
  801b87:	74 0f                	je     801b98 <ipc_recv+0x44>
  801b89:	85 ff                	test   %edi,%edi
  801b8b:	74 0b                	je     801b98 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b8d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b93:	8b 52 78             	mov    0x78(%edx),%edx
  801b96:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b98:	85 c0                	test   %eax,%eax
  801b9a:	74 30                	je     801bcc <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b9c:	85 db                	test   %ebx,%ebx
  801b9e:	74 06                	je     801ba6 <ipc_recv+0x52>
      		*from_env_store = 0;
  801ba0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801ba6:	85 f6                	test   %esi,%esi
  801ba8:	74 2c                	je     801bd6 <ipc_recv+0x82>
      		*perm_store = 0;
  801baa:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801bb5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bb8:	5b                   	pop    %ebx
  801bb9:	5e                   	pop    %esi
  801bba:	5f                   	pop    %edi
  801bbb:	5d                   	pop    %ebp
  801bbc:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bbd:	83 ec 0c             	sub    $0xc,%esp
  801bc0:	6a ff                	push   $0xffffffff
  801bc2:	e8 5e f1 ff ff       	call   800d25 <sys_ipc_recv>
  801bc7:	83 c4 10             	add    $0x10,%esp
  801bca:	eb aa                	jmp    801b76 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bcc:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd1:	8b 40 70             	mov    0x70(%eax),%eax
  801bd4:	eb df                	jmp    801bb5 <ipc_recv+0x61>
		return -1;
  801bd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bdb:	eb d8                	jmp    801bb5 <ipc_recv+0x61>

00801bdd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bdd:	55                   	push   %ebp
  801bde:	89 e5                	mov    %esp,%ebp
  801be0:	57                   	push   %edi
  801be1:	56                   	push   %esi
  801be2:	53                   	push   %ebx
  801be3:	83 ec 0c             	sub    $0xc,%esp
  801be6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801be9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bec:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bef:	85 db                	test   %ebx,%ebx
  801bf1:	75 22                	jne    801c15 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bf3:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bf8:	eb 1b                	jmp    801c15 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bfa:	68 9c 23 80 00       	push   $0x80239c
  801bff:	68 1f 23 80 00       	push   $0x80231f
  801c04:	6a 48                	push   $0x48
  801c06:	68 c0 23 80 00       	push   $0x8023c0
  801c0b:	e8 c5 fe ff ff       	call   801ad5 <_panic>
		sys_yield();
  801c10:	e8 c7 ef ff ff       	call   800bdc <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c15:	57                   	push   %edi
  801c16:	53                   	push   %ebx
  801c17:	56                   	push   %esi
  801c18:	ff 75 08             	pushl  0x8(%ebp)
  801c1b:	e8 e2 f0 ff ff       	call   800d02 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c20:	83 c4 10             	add    $0x10,%esp
  801c23:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c26:	74 e8                	je     801c10 <ipc_send+0x33>
  801c28:	85 c0                	test   %eax,%eax
  801c2a:	75 ce                	jne    801bfa <ipc_send+0x1d>
		sys_yield();
  801c2c:	e8 ab ef ff ff       	call   800bdc <sys_yield>
		
	}
	
}
  801c31:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c34:	5b                   	pop    %ebx
  801c35:	5e                   	pop    %esi
  801c36:	5f                   	pop    %edi
  801c37:	5d                   	pop    %ebp
  801c38:	c3                   	ret    

00801c39 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
  801c3c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c3f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c44:	89 c2                	mov    %eax,%edx
  801c46:	c1 e2 05             	shl    $0x5,%edx
  801c49:	29 c2                	sub    %eax,%edx
  801c4b:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c52:	8b 52 50             	mov    0x50(%edx),%edx
  801c55:	39 ca                	cmp    %ecx,%edx
  801c57:	74 0f                	je     801c68 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c59:	40                   	inc    %eax
  801c5a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c5f:	75 e3                	jne    801c44 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c61:	b8 00 00 00 00       	mov    $0x0,%eax
  801c66:	eb 11                	jmp    801c79 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c68:	89 c2                	mov    %eax,%edx
  801c6a:	c1 e2 05             	shl    $0x5,%edx
  801c6d:	29 c2                	sub    %eax,%edx
  801c6f:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c76:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c79:	5d                   	pop    %ebp
  801c7a:	c3                   	ret    

00801c7b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c81:	c1 e8 16             	shr    $0x16,%eax
  801c84:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c8b:	a8 01                	test   $0x1,%al
  801c8d:	74 21                	je     801cb0 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c92:	c1 e8 0c             	shr    $0xc,%eax
  801c95:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c9c:	a8 01                	test   $0x1,%al
  801c9e:	74 17                	je     801cb7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca0:	c1 e8 0c             	shr    $0xc,%eax
  801ca3:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801caa:	ef 
  801cab:	0f b7 c0             	movzwl %ax,%eax
  801cae:	eb 05                	jmp    801cb5 <pageref+0x3a>
		return 0;
  801cb0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb5:	5d                   	pop    %ebp
  801cb6:	c3                   	ret    
		return 0;
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbc:	eb f7                	jmp    801cb5 <pageref+0x3a>
  801cbe:	66 90                	xchg   %ax,%ax

00801cc0 <__udivdi3>:
  801cc0:	55                   	push   %ebp
  801cc1:	57                   	push   %edi
  801cc2:	56                   	push   %esi
  801cc3:	53                   	push   %ebx
  801cc4:	83 ec 1c             	sub    $0x1c,%esp
  801cc7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ccb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801ccf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cd3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cd7:	89 ca                	mov    %ecx,%edx
  801cd9:	89 f8                	mov    %edi,%eax
  801cdb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cdf:	85 f6                	test   %esi,%esi
  801ce1:	75 2d                	jne    801d10 <__udivdi3+0x50>
  801ce3:	39 cf                	cmp    %ecx,%edi
  801ce5:	77 65                	ja     801d4c <__udivdi3+0x8c>
  801ce7:	89 fd                	mov    %edi,%ebp
  801ce9:	85 ff                	test   %edi,%edi
  801ceb:	75 0b                	jne    801cf8 <__udivdi3+0x38>
  801ced:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf2:	31 d2                	xor    %edx,%edx
  801cf4:	f7 f7                	div    %edi
  801cf6:	89 c5                	mov    %eax,%ebp
  801cf8:	31 d2                	xor    %edx,%edx
  801cfa:	89 c8                	mov    %ecx,%eax
  801cfc:	f7 f5                	div    %ebp
  801cfe:	89 c1                	mov    %eax,%ecx
  801d00:	89 d8                	mov    %ebx,%eax
  801d02:	f7 f5                	div    %ebp
  801d04:	89 cf                	mov    %ecx,%edi
  801d06:	89 fa                	mov    %edi,%edx
  801d08:	83 c4 1c             	add    $0x1c,%esp
  801d0b:	5b                   	pop    %ebx
  801d0c:	5e                   	pop    %esi
  801d0d:	5f                   	pop    %edi
  801d0e:	5d                   	pop    %ebp
  801d0f:	c3                   	ret    
  801d10:	39 ce                	cmp    %ecx,%esi
  801d12:	77 28                	ja     801d3c <__udivdi3+0x7c>
  801d14:	0f bd fe             	bsr    %esi,%edi
  801d17:	83 f7 1f             	xor    $0x1f,%edi
  801d1a:	75 40                	jne    801d5c <__udivdi3+0x9c>
  801d1c:	39 ce                	cmp    %ecx,%esi
  801d1e:	72 0a                	jb     801d2a <__udivdi3+0x6a>
  801d20:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d24:	0f 87 9e 00 00 00    	ja     801dc8 <__udivdi3+0x108>
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	89 fa                	mov    %edi,%edx
  801d31:	83 c4 1c             	add    $0x1c,%esp
  801d34:	5b                   	pop    %ebx
  801d35:	5e                   	pop    %esi
  801d36:	5f                   	pop    %edi
  801d37:	5d                   	pop    %ebp
  801d38:	c3                   	ret    
  801d39:	8d 76 00             	lea    0x0(%esi),%esi
  801d3c:	31 ff                	xor    %edi,%edi
  801d3e:	31 c0                	xor    %eax,%eax
  801d40:	89 fa                	mov    %edi,%edx
  801d42:	83 c4 1c             	add    $0x1c,%esp
  801d45:	5b                   	pop    %ebx
  801d46:	5e                   	pop    %esi
  801d47:	5f                   	pop    %edi
  801d48:	5d                   	pop    %ebp
  801d49:	c3                   	ret    
  801d4a:	66 90                	xchg   %ax,%ax
  801d4c:	89 d8                	mov    %ebx,%eax
  801d4e:	f7 f7                	div    %edi
  801d50:	31 ff                	xor    %edi,%edi
  801d52:	89 fa                	mov    %edi,%edx
  801d54:	83 c4 1c             	add    $0x1c,%esp
  801d57:	5b                   	pop    %ebx
  801d58:	5e                   	pop    %esi
  801d59:	5f                   	pop    %edi
  801d5a:	5d                   	pop    %ebp
  801d5b:	c3                   	ret    
  801d5c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d61:	29 fd                	sub    %edi,%ebp
  801d63:	89 f9                	mov    %edi,%ecx
  801d65:	d3 e6                	shl    %cl,%esi
  801d67:	89 c3                	mov    %eax,%ebx
  801d69:	89 e9                	mov    %ebp,%ecx
  801d6b:	d3 eb                	shr    %cl,%ebx
  801d6d:	89 d9                	mov    %ebx,%ecx
  801d6f:	09 f1                	or     %esi,%ecx
  801d71:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d75:	89 f9                	mov    %edi,%ecx
  801d77:	d3 e0                	shl    %cl,%eax
  801d79:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d7d:	89 d6                	mov    %edx,%esi
  801d7f:	89 e9                	mov    %ebp,%ecx
  801d81:	d3 ee                	shr    %cl,%esi
  801d83:	89 f9                	mov    %edi,%ecx
  801d85:	d3 e2                	shl    %cl,%edx
  801d87:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d8b:	89 e9                	mov    %ebp,%ecx
  801d8d:	d3 eb                	shr    %cl,%ebx
  801d8f:	09 da                	or     %ebx,%edx
  801d91:	89 d0                	mov    %edx,%eax
  801d93:	89 f2                	mov    %esi,%edx
  801d95:	f7 74 24 08          	divl   0x8(%esp)
  801d99:	89 d6                	mov    %edx,%esi
  801d9b:	89 c3                	mov    %eax,%ebx
  801d9d:	f7 64 24 0c          	mull   0xc(%esp)
  801da1:	39 d6                	cmp    %edx,%esi
  801da3:	72 17                	jb     801dbc <__udivdi3+0xfc>
  801da5:	74 09                	je     801db0 <__udivdi3+0xf0>
  801da7:	89 d8                	mov    %ebx,%eax
  801da9:	31 ff                	xor    %edi,%edi
  801dab:	e9 56 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801db0:	8b 54 24 04          	mov    0x4(%esp),%edx
  801db4:	89 f9                	mov    %edi,%ecx
  801db6:	d3 e2                	shl    %cl,%edx
  801db8:	39 c2                	cmp    %eax,%edx
  801dba:	73 eb                	jae    801da7 <__udivdi3+0xe7>
  801dbc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dbf:	31 ff                	xor    %edi,%edi
  801dc1:	e9 40 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	31 c0                	xor    %eax,%eax
  801dca:	e9 37 ff ff ff       	jmp    801d06 <__udivdi3+0x46>
  801dcf:	90                   	nop

00801dd0 <__umoddi3>:
  801dd0:	55                   	push   %ebp
  801dd1:	57                   	push   %edi
  801dd2:	56                   	push   %esi
  801dd3:	53                   	push   %ebx
  801dd4:	83 ec 1c             	sub    $0x1c,%esp
  801dd7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ddb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ddf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801de3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801de7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801deb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801def:	89 3c 24             	mov    %edi,(%esp)
  801df2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801df6:	89 f2                	mov    %esi,%edx
  801df8:	85 c0                	test   %eax,%eax
  801dfa:	75 18                	jne    801e14 <__umoddi3+0x44>
  801dfc:	39 f7                	cmp    %esi,%edi
  801dfe:	0f 86 a0 00 00 00    	jbe    801ea4 <__umoddi3+0xd4>
  801e04:	89 c8                	mov    %ecx,%eax
  801e06:	f7 f7                	div    %edi
  801e08:	89 d0                	mov    %edx,%eax
  801e0a:	31 d2                	xor    %edx,%edx
  801e0c:	83 c4 1c             	add    $0x1c,%esp
  801e0f:	5b                   	pop    %ebx
  801e10:	5e                   	pop    %esi
  801e11:	5f                   	pop    %edi
  801e12:	5d                   	pop    %ebp
  801e13:	c3                   	ret    
  801e14:	89 f3                	mov    %esi,%ebx
  801e16:	39 f0                	cmp    %esi,%eax
  801e18:	0f 87 a6 00 00 00    	ja     801ec4 <__umoddi3+0xf4>
  801e1e:	0f bd e8             	bsr    %eax,%ebp
  801e21:	83 f5 1f             	xor    $0x1f,%ebp
  801e24:	0f 84 a6 00 00 00    	je     801ed0 <__umoddi3+0x100>
  801e2a:	bf 20 00 00 00       	mov    $0x20,%edi
  801e2f:	29 ef                	sub    %ebp,%edi
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 e0                	shl    %cl,%eax
  801e35:	8b 34 24             	mov    (%esp),%esi
  801e38:	89 f2                	mov    %esi,%edx
  801e3a:	89 f9                	mov    %edi,%ecx
  801e3c:	d3 ea                	shr    %cl,%edx
  801e3e:	09 c2                	or     %eax,%edx
  801e40:	89 14 24             	mov    %edx,(%esp)
  801e43:	89 f2                	mov    %esi,%edx
  801e45:	89 e9                	mov    %ebp,%ecx
  801e47:	d3 e2                	shl    %cl,%edx
  801e49:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e4d:	89 de                	mov    %ebx,%esi
  801e4f:	89 f9                	mov    %edi,%ecx
  801e51:	d3 ee                	shr    %cl,%esi
  801e53:	89 e9                	mov    %ebp,%ecx
  801e55:	d3 e3                	shl    %cl,%ebx
  801e57:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e5b:	89 d0                	mov    %edx,%eax
  801e5d:	89 f9                	mov    %edi,%ecx
  801e5f:	d3 e8                	shr    %cl,%eax
  801e61:	09 d8                	or     %ebx,%eax
  801e63:	89 d3                	mov    %edx,%ebx
  801e65:	89 e9                	mov    %ebp,%ecx
  801e67:	d3 e3                	shl    %cl,%ebx
  801e69:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e6d:	89 f2                	mov    %esi,%edx
  801e6f:	f7 34 24             	divl   (%esp)
  801e72:	89 d6                	mov    %edx,%esi
  801e74:	f7 64 24 04          	mull   0x4(%esp)
  801e78:	89 c3                	mov    %eax,%ebx
  801e7a:	89 d1                	mov    %edx,%ecx
  801e7c:	39 d6                	cmp    %edx,%esi
  801e7e:	72 7c                	jb     801efc <__umoddi3+0x12c>
  801e80:	74 72                	je     801ef4 <__umoddi3+0x124>
  801e82:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e86:	29 da                	sub    %ebx,%edx
  801e88:	19 ce                	sbb    %ecx,%esi
  801e8a:	89 f0                	mov    %esi,%eax
  801e8c:	89 f9                	mov    %edi,%ecx
  801e8e:	d3 e0                	shl    %cl,%eax
  801e90:	89 e9                	mov    %ebp,%ecx
  801e92:	d3 ea                	shr    %cl,%edx
  801e94:	09 d0                	or     %edx,%eax
  801e96:	89 e9                	mov    %ebp,%ecx
  801e98:	d3 ee                	shr    %cl,%esi
  801e9a:	89 f2                	mov    %esi,%edx
  801e9c:	83 c4 1c             	add    $0x1c,%esp
  801e9f:	5b                   	pop    %ebx
  801ea0:	5e                   	pop    %esi
  801ea1:	5f                   	pop    %edi
  801ea2:	5d                   	pop    %ebp
  801ea3:	c3                   	ret    
  801ea4:	89 fd                	mov    %edi,%ebp
  801ea6:	85 ff                	test   %edi,%edi
  801ea8:	75 0b                	jne    801eb5 <__umoddi3+0xe5>
  801eaa:	b8 01 00 00 00       	mov    $0x1,%eax
  801eaf:	31 d2                	xor    %edx,%edx
  801eb1:	f7 f7                	div    %edi
  801eb3:	89 c5                	mov    %eax,%ebp
  801eb5:	89 f0                	mov    %esi,%eax
  801eb7:	31 d2                	xor    %edx,%edx
  801eb9:	f7 f5                	div    %ebp
  801ebb:	89 c8                	mov    %ecx,%eax
  801ebd:	f7 f5                	div    %ebp
  801ebf:	e9 44 ff ff ff       	jmp    801e08 <__umoddi3+0x38>
  801ec4:	89 c8                	mov    %ecx,%eax
  801ec6:	89 f2                	mov    %esi,%edx
  801ec8:	83 c4 1c             	add    $0x1c,%esp
  801ecb:	5b                   	pop    %ebx
  801ecc:	5e                   	pop    %esi
  801ecd:	5f                   	pop    %edi
  801ece:	5d                   	pop    %ebp
  801ecf:	c3                   	ret    
  801ed0:	39 f0                	cmp    %esi,%eax
  801ed2:	72 05                	jb     801ed9 <__umoddi3+0x109>
  801ed4:	39 0c 24             	cmp    %ecx,(%esp)
  801ed7:	77 0c                	ja     801ee5 <__umoddi3+0x115>
  801ed9:	89 f2                	mov    %esi,%edx
  801edb:	29 f9                	sub    %edi,%ecx
  801edd:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ee1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ee5:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ee9:	83 c4 1c             	add    $0x1c,%esp
  801eec:	5b                   	pop    %ebx
  801eed:	5e                   	pop    %esi
  801eee:	5f                   	pop    %edi
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    
  801ef1:	8d 76 00             	lea    0x0(%esi),%esi
  801ef4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ef8:	73 88                	jae    801e82 <__umoddi3+0xb2>
  801efa:	66 90                	xchg   %ax,%ax
  801efc:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f00:	1b 14 24             	sbb    (%esp),%edx
  801f03:	89 d1                	mov    %edx,%ecx
  801f05:	89 c3                	mov    %eax,%ebx
  801f07:	e9 76 ff ff ff       	jmp    801e82 <__umoddi3+0xb2>
