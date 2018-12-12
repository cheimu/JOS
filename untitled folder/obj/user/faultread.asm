
obj/user/faultread.debug:     file format elf32-i386


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
  80002c:	e8 1d 00 00 00       	call   80004e <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	cprintf("I read %08x from location 0!\n", *(unsigned*)0);
  800039:	ff 35 00 00 00 00    	pushl  0x0
  80003f:	68 00 1f 80 00       	push   $0x801f00
  800044:	e8 ff 00 00 00       	call   800148 <cprintf>
}
  800049:	83 c4 10             	add    $0x10,%esp
  80004c:	c9                   	leave  
  80004d:	c3                   	ret    

0080004e <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004e:	55                   	push   %ebp
  80004f:	89 e5                	mov    %esp,%ebp
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800056:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800059:	e8 88 0a 00 00       	call   800ae6 <sys_getenvid>
  80005e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800063:	89 c2                	mov    %eax,%edx
  800065:	c1 e2 05             	shl    $0x5,%edx
  800068:	29 c2                	sub    %eax,%edx
  80006a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800071:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800076:	85 db                	test   %ebx,%ebx
  800078:	7e 07                	jle    800081 <libmain+0x33>
		binaryname = argv[0];
  80007a:	8b 06                	mov    (%esi),%eax
  80007c:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800081:	83 ec 08             	sub    $0x8,%esp
  800084:	56                   	push   %esi
  800085:	53                   	push   %ebx
  800086:	e8 a8 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80008b:	e8 0a 00 00 00       	call   80009a <exit>
}
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800096:	5b                   	pop    %ebx
  800097:	5e                   	pop    %esi
  800098:	5d                   	pop    %ebp
  800099:	c3                   	ret    

0080009a <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80009a:	55                   	push   %ebp
  80009b:	89 e5                	mov    %esp,%ebp
  80009d:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a0:	e8 e9 0e 00 00       	call   800f8e <close_all>
	sys_env_destroy(0);
  8000a5:	83 ec 0c             	sub    $0xc,%esp
  8000a8:	6a 00                	push   $0x0
  8000aa:	e8 f6 09 00 00       	call   800aa5 <sys_env_destroy>
}
  8000af:	83 c4 10             	add    $0x10,%esp
  8000b2:	c9                   	leave  
  8000b3:	c3                   	ret    

008000b4 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000b4:	55                   	push   %ebp
  8000b5:	89 e5                	mov    %esp,%ebp
  8000b7:	53                   	push   %ebx
  8000b8:	83 ec 04             	sub    $0x4,%esp
  8000bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000be:	8b 13                	mov    (%ebx),%edx
  8000c0:	8d 42 01             	lea    0x1(%edx),%eax
  8000c3:	89 03                	mov    %eax,(%ebx)
  8000c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000c8:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000d1:	74 08                	je     8000db <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000d3:	ff 43 04             	incl   0x4(%ebx)
}
  8000d6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000d9:	c9                   	leave  
  8000da:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000db:	83 ec 08             	sub    $0x8,%esp
  8000de:	68 ff 00 00 00       	push   $0xff
  8000e3:	8d 43 08             	lea    0x8(%ebx),%eax
  8000e6:	50                   	push   %eax
  8000e7:	e8 7c 09 00 00       	call   800a68 <sys_cputs>
		b->idx = 0;
  8000ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8000f2:	83 c4 10             	add    $0x10,%esp
  8000f5:	eb dc                	jmp    8000d3 <putch+0x1f>

008000f7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800100:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800107:	00 00 00 
	b.cnt = 0;
  80010a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800111:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800114:	ff 75 0c             	pushl  0xc(%ebp)
  800117:	ff 75 08             	pushl  0x8(%ebp)
  80011a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800120:	50                   	push   %eax
  800121:	68 b4 00 80 00       	push   $0x8000b4
  800126:	e8 17 01 00 00       	call   800242 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80012b:	83 c4 08             	add    $0x8,%esp
  80012e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800134:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80013a:	50                   	push   %eax
  80013b:	e8 28 09 00 00       	call   800a68 <sys_cputs>

	return b.cnt;
}
  800140:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800146:	c9                   	leave  
  800147:	c3                   	ret    

00800148 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800148:	55                   	push   %ebp
  800149:	89 e5                	mov    %esp,%ebp
  80014b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80014e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800151:	50                   	push   %eax
  800152:	ff 75 08             	pushl  0x8(%ebp)
  800155:	e8 9d ff ff ff       	call   8000f7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80015a:	c9                   	leave  
  80015b:	c3                   	ret    

0080015c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
  800162:	83 ec 1c             	sub    $0x1c,%esp
  800165:	89 c7                	mov    %eax,%edi
  800167:	89 d6                	mov    %edx,%esi
  800169:	8b 45 08             	mov    0x8(%ebp),%eax
  80016c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80016f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800172:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800175:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800178:	bb 00 00 00 00       	mov    $0x0,%ebx
  80017d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800180:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800183:	39 d3                	cmp    %edx,%ebx
  800185:	72 05                	jb     80018c <printnum+0x30>
  800187:	39 45 10             	cmp    %eax,0x10(%ebp)
  80018a:	77 78                	ja     800204 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	ff 75 18             	pushl  0x18(%ebp)
  800192:	8b 45 14             	mov    0x14(%ebp),%eax
  800195:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800198:	53                   	push   %ebx
  800199:	ff 75 10             	pushl  0x10(%ebp)
  80019c:	83 ec 08             	sub    $0x8,%esp
  80019f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8001a5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001a8:	ff 75 d8             	pushl  -0x28(%ebp)
  8001ab:	e8 00 1b 00 00       	call   801cb0 <__udivdi3>
  8001b0:	83 c4 18             	add    $0x18,%esp
  8001b3:	52                   	push   %edx
  8001b4:	50                   	push   %eax
  8001b5:	89 f2                	mov    %esi,%edx
  8001b7:	89 f8                	mov    %edi,%eax
  8001b9:	e8 9e ff ff ff       	call   80015c <printnum>
  8001be:	83 c4 20             	add    $0x20,%esp
  8001c1:	eb 11                	jmp    8001d4 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001c3:	83 ec 08             	sub    $0x8,%esp
  8001c6:	56                   	push   %esi
  8001c7:	ff 75 18             	pushl  0x18(%ebp)
  8001ca:	ff d7                	call   *%edi
  8001cc:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001cf:	4b                   	dec    %ebx
  8001d0:	85 db                	test   %ebx,%ebx
  8001d2:	7f ef                	jg     8001c3 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001d4:	83 ec 08             	sub    $0x8,%esp
  8001d7:	56                   	push   %esi
  8001d8:	83 ec 04             	sub    $0x4,%esp
  8001db:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001de:	ff 75 e0             	pushl  -0x20(%ebp)
  8001e1:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e4:	ff 75 d8             	pushl  -0x28(%ebp)
  8001e7:	e8 d4 1b 00 00       	call   801dc0 <__umoddi3>
  8001ec:	83 c4 14             	add    $0x14,%esp
  8001ef:	0f be 80 28 1f 80 00 	movsbl 0x801f28(%eax),%eax
  8001f6:	50                   	push   %eax
  8001f7:	ff d7                	call   *%edi
}
  8001f9:	83 c4 10             	add    $0x10,%esp
  8001fc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ff:	5b                   	pop    %ebx
  800200:	5e                   	pop    %esi
  800201:	5f                   	pop    %edi
  800202:	5d                   	pop    %ebp
  800203:	c3                   	ret    
  800204:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800207:	eb c6                	jmp    8001cf <printnum+0x73>

00800209 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800209:	55                   	push   %ebp
  80020a:	89 e5                	mov    %esp,%ebp
  80020c:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80020f:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800212:	8b 10                	mov    (%eax),%edx
  800214:	3b 50 04             	cmp    0x4(%eax),%edx
  800217:	73 0a                	jae    800223 <sprintputch+0x1a>
		*b->buf++ = ch;
  800219:	8d 4a 01             	lea    0x1(%edx),%ecx
  80021c:	89 08                	mov    %ecx,(%eax)
  80021e:	8b 45 08             	mov    0x8(%ebp),%eax
  800221:	88 02                	mov    %al,(%edx)
}
  800223:	5d                   	pop    %ebp
  800224:	c3                   	ret    

00800225 <printfmt>:
{
  800225:	55                   	push   %ebp
  800226:	89 e5                	mov    %esp,%ebp
  800228:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80022b:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80022e:	50                   	push   %eax
  80022f:	ff 75 10             	pushl  0x10(%ebp)
  800232:	ff 75 0c             	pushl  0xc(%ebp)
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 05 00 00 00       	call   800242 <vprintfmt>
}
  80023d:	83 c4 10             	add    $0x10,%esp
  800240:	c9                   	leave  
  800241:	c3                   	ret    

00800242 <vprintfmt>:
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	57                   	push   %edi
  800246:	56                   	push   %esi
  800247:	53                   	push   %ebx
  800248:	83 ec 2c             	sub    $0x2c,%esp
  80024b:	8b 75 08             	mov    0x8(%ebp),%esi
  80024e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800251:	8b 7d 10             	mov    0x10(%ebp),%edi
  800254:	e9 ae 03 00 00       	jmp    800607 <vprintfmt+0x3c5>
  800259:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80025d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800264:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80026b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800272:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800277:	8d 47 01             	lea    0x1(%edi),%eax
  80027a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80027d:	8a 17                	mov    (%edi),%dl
  80027f:	8d 42 dd             	lea    -0x23(%edx),%eax
  800282:	3c 55                	cmp    $0x55,%al
  800284:	0f 87 fe 03 00 00    	ja     800688 <vprintfmt+0x446>
  80028a:	0f b6 c0             	movzbl %al,%eax
  80028d:	ff 24 85 60 20 80 00 	jmp    *0x802060(,%eax,4)
  800294:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800297:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80029b:	eb da                	jmp    800277 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80029d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002a0:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002a4:	eb d1                	jmp    800277 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002a6:	0f b6 d2             	movzbl %dl,%edx
  8002a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002b4:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002b7:	01 c0                	add    %eax,%eax
  8002b9:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8002bd:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002c0:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002c3:	83 f9 09             	cmp    $0x9,%ecx
  8002c6:	77 52                	ja     80031a <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8002c8:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8002c9:	eb e9                	jmp    8002b4 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8002cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8002ce:	8b 00                	mov    (%eax),%eax
  8002d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8002d6:	8d 40 04             	lea    0x4(%eax),%eax
  8002d9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002df:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002e3:	79 92                	jns    800277 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002e5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002eb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8002f2:	eb 83                	jmp    800277 <vprintfmt+0x35>
  8002f4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f8:	78 08                	js     800302 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8002fa:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002fd:	e9 75 ff ff ff       	jmp    800277 <vprintfmt+0x35>
  800302:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800309:	eb ef                	jmp    8002fa <vprintfmt+0xb8>
  80030b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80030e:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800315:	e9 5d ff ff ff       	jmp    800277 <vprintfmt+0x35>
  80031a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80031d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800320:	eb bd                	jmp    8002df <vprintfmt+0x9d>
			lflag++;
  800322:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800323:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800326:	e9 4c ff ff ff       	jmp    800277 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80032b:	8b 45 14             	mov    0x14(%ebp),%eax
  80032e:	8d 78 04             	lea    0x4(%eax),%edi
  800331:	83 ec 08             	sub    $0x8,%esp
  800334:	53                   	push   %ebx
  800335:	ff 30                	pushl  (%eax)
  800337:	ff d6                	call   *%esi
			break;
  800339:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80033c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80033f:	e9 c0 02 00 00       	jmp    800604 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800344:	8b 45 14             	mov    0x14(%ebp),%eax
  800347:	8d 78 04             	lea    0x4(%eax),%edi
  80034a:	8b 00                	mov    (%eax),%eax
  80034c:	85 c0                	test   %eax,%eax
  80034e:	78 2a                	js     80037a <vprintfmt+0x138>
  800350:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800352:	83 f8 0f             	cmp    $0xf,%eax
  800355:	7f 27                	jg     80037e <vprintfmt+0x13c>
  800357:	8b 04 85 c0 21 80 00 	mov    0x8021c0(,%eax,4),%eax
  80035e:	85 c0                	test   %eax,%eax
  800360:	74 1c                	je     80037e <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800362:	50                   	push   %eax
  800363:	68 f1 22 80 00       	push   $0x8022f1
  800368:	53                   	push   %ebx
  800369:	56                   	push   %esi
  80036a:	e8 b6 fe ff ff       	call   800225 <printfmt>
  80036f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800372:	89 7d 14             	mov    %edi,0x14(%ebp)
  800375:	e9 8a 02 00 00       	jmp    800604 <vprintfmt+0x3c2>
  80037a:	f7 d8                	neg    %eax
  80037c:	eb d2                	jmp    800350 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80037e:	52                   	push   %edx
  80037f:	68 40 1f 80 00       	push   $0x801f40
  800384:	53                   	push   %ebx
  800385:	56                   	push   %esi
  800386:	e8 9a fe ff ff       	call   800225 <printfmt>
  80038b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80038e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800391:	e9 6e 02 00 00       	jmp    800604 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800396:	8b 45 14             	mov    0x14(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80039f:	8b 45 14             	mov    0x14(%ebp),%eax
  8003a2:	8b 38                	mov    (%eax),%edi
  8003a4:	85 ff                	test   %edi,%edi
  8003a6:	74 39                	je     8003e1 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ac:	0f 8e a9 00 00 00    	jle    80045b <vprintfmt+0x219>
  8003b2:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003b6:	0f 84 a7 00 00 00    	je     800463 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 d0             	pushl  -0x30(%ebp)
  8003c2:	57                   	push   %edi
  8003c3:	e8 6b 03 00 00       	call   800733 <strnlen>
  8003c8:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003cb:	29 c1                	sub    %eax,%ecx
  8003cd:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003d0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003d3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003da:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003dd:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003df:	eb 14                	jmp    8003f5 <vprintfmt+0x1b3>
				p = "(null)";
  8003e1:	bf 39 1f 80 00       	mov    $0x801f39,%edi
  8003e6:	eb c0                	jmp    8003a8 <vprintfmt+0x166>
					putch(padc, putdat);
  8003e8:	83 ec 08             	sub    $0x8,%esp
  8003eb:	53                   	push   %ebx
  8003ec:	ff 75 e0             	pushl  -0x20(%ebp)
  8003ef:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f1:	4f                   	dec    %edi
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	85 ff                	test   %edi,%edi
  8003f7:	7f ef                	jg     8003e8 <vprintfmt+0x1a6>
  8003f9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8003fc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8003ff:	89 c8                	mov    %ecx,%eax
  800401:	85 c9                	test   %ecx,%ecx
  800403:	78 10                	js     800415 <vprintfmt+0x1d3>
  800405:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800408:	29 c1                	sub    %eax,%ecx
  80040a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80040d:	89 75 08             	mov    %esi,0x8(%ebp)
  800410:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800413:	eb 15                	jmp    80042a <vprintfmt+0x1e8>
  800415:	b8 00 00 00 00       	mov    $0x0,%eax
  80041a:	eb e9                	jmp    800405 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80041c:	83 ec 08             	sub    $0x8,%esp
  80041f:	53                   	push   %ebx
  800420:	52                   	push   %edx
  800421:	ff 55 08             	call   *0x8(%ebp)
  800424:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800427:	ff 4d e0             	decl   -0x20(%ebp)
  80042a:	47                   	inc    %edi
  80042b:	8a 47 ff             	mov    -0x1(%edi),%al
  80042e:	0f be d0             	movsbl %al,%edx
  800431:	85 d2                	test   %edx,%edx
  800433:	74 59                	je     80048e <vprintfmt+0x24c>
  800435:	85 f6                	test   %esi,%esi
  800437:	78 03                	js     80043c <vprintfmt+0x1fa>
  800439:	4e                   	dec    %esi
  80043a:	78 2f                	js     80046b <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80043c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800440:	74 da                	je     80041c <vprintfmt+0x1da>
  800442:	0f be c0             	movsbl %al,%eax
  800445:	83 e8 20             	sub    $0x20,%eax
  800448:	83 f8 5e             	cmp    $0x5e,%eax
  80044b:	76 cf                	jbe    80041c <vprintfmt+0x1da>
					putch('?', putdat);
  80044d:	83 ec 08             	sub    $0x8,%esp
  800450:	53                   	push   %ebx
  800451:	6a 3f                	push   $0x3f
  800453:	ff 55 08             	call   *0x8(%ebp)
  800456:	83 c4 10             	add    $0x10,%esp
  800459:	eb cc                	jmp    800427 <vprintfmt+0x1e5>
  80045b:	89 75 08             	mov    %esi,0x8(%ebp)
  80045e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800461:	eb c7                	jmp    80042a <vprintfmt+0x1e8>
  800463:	89 75 08             	mov    %esi,0x8(%ebp)
  800466:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800469:	eb bf                	jmp    80042a <vprintfmt+0x1e8>
  80046b:	8b 75 08             	mov    0x8(%ebp),%esi
  80046e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800471:	eb 0c                	jmp    80047f <vprintfmt+0x23d>
				putch(' ', putdat);
  800473:	83 ec 08             	sub    $0x8,%esp
  800476:	53                   	push   %ebx
  800477:	6a 20                	push   $0x20
  800479:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80047b:	4f                   	dec    %edi
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	85 ff                	test   %edi,%edi
  800481:	7f f0                	jg     800473 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800483:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800486:	89 45 14             	mov    %eax,0x14(%ebp)
  800489:	e9 76 01 00 00       	jmp    800604 <vprintfmt+0x3c2>
  80048e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800491:	8b 75 08             	mov    0x8(%ebp),%esi
  800494:	eb e9                	jmp    80047f <vprintfmt+0x23d>
	if (lflag >= 2)
  800496:	83 f9 01             	cmp    $0x1,%ecx
  800499:	7f 1f                	jg     8004ba <vprintfmt+0x278>
	else if (lflag)
  80049b:	85 c9                	test   %ecx,%ecx
  80049d:	75 48                	jne    8004e7 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80049f:	8b 45 14             	mov    0x14(%ebp),%eax
  8004a2:	8b 00                	mov    (%eax),%eax
  8004a4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004a7:	89 c1                	mov    %eax,%ecx
  8004a9:	c1 f9 1f             	sar    $0x1f,%ecx
  8004ac:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004af:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b2:	8d 40 04             	lea    0x4(%eax),%eax
  8004b5:	89 45 14             	mov    %eax,0x14(%ebp)
  8004b8:	eb 17                	jmp    8004d1 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8004ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8004bd:	8b 50 04             	mov    0x4(%eax),%edx
  8004c0:	8b 00                	mov    (%eax),%eax
  8004c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004c5:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8d 40 08             	lea    0x8(%eax),%eax
  8004ce:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8004d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8004d7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004db:	78 25                	js     800502 <vprintfmt+0x2c0>
			base = 10;
  8004dd:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004e2:	e9 03 01 00 00       	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8004e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ea:	8b 00                	mov    (%eax),%eax
  8004ec:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004ef:	89 c1                	mov    %eax,%ecx
  8004f1:	c1 f9 1f             	sar    $0x1f,%ecx
  8004f4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fa:	8d 40 04             	lea    0x4(%eax),%eax
  8004fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800500:	eb cf                	jmp    8004d1 <vprintfmt+0x28f>
				putch('-', putdat);
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	53                   	push   %ebx
  800506:	6a 2d                	push   $0x2d
  800508:	ff d6                	call   *%esi
				num = -(long long) num;
  80050a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80050d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800510:	f7 da                	neg    %edx
  800512:	83 d1 00             	adc    $0x0,%ecx
  800515:	f7 d9                	neg    %ecx
  800517:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80051a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80051f:	e9 c6 00 00 00       	jmp    8005ea <vprintfmt+0x3a8>
	if (lflag >= 2)
  800524:	83 f9 01             	cmp    $0x1,%ecx
  800527:	7f 1e                	jg     800547 <vprintfmt+0x305>
	else if (lflag)
  800529:	85 c9                	test   %ecx,%ecx
  80052b:	75 32                	jne    80055f <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80052d:	8b 45 14             	mov    0x14(%ebp),%eax
  800530:	8b 10                	mov    (%eax),%edx
  800532:	b9 00 00 00 00       	mov    $0x0,%ecx
  800537:	8d 40 04             	lea    0x4(%eax),%eax
  80053a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80053d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800542:	e9 a3 00 00 00       	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800547:	8b 45 14             	mov    0x14(%ebp),%eax
  80054a:	8b 10                	mov    (%eax),%edx
  80054c:	8b 48 04             	mov    0x4(%eax),%ecx
  80054f:	8d 40 08             	lea    0x8(%eax),%eax
  800552:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800555:	b8 0a 00 00 00       	mov    $0xa,%eax
  80055a:	e9 8b 00 00 00       	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800574:	eb 74                	jmp    8005ea <vprintfmt+0x3a8>
	if (lflag >= 2)
  800576:	83 f9 01             	cmp    $0x1,%ecx
  800579:	7f 1b                	jg     800596 <vprintfmt+0x354>
	else if (lflag)
  80057b:	85 c9                	test   %ecx,%ecx
  80057d:	75 2c                	jne    8005ab <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80057f:	8b 45 14             	mov    0x14(%ebp),%eax
  800582:	8b 10                	mov    (%eax),%edx
  800584:	b9 00 00 00 00       	mov    $0x0,%ecx
  800589:	8d 40 04             	lea    0x4(%eax),%eax
  80058c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80058f:	b8 08 00 00 00       	mov    $0x8,%eax
  800594:	eb 54                	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800596:	8b 45 14             	mov    0x14(%ebp),%eax
  800599:	8b 10                	mov    (%eax),%edx
  80059b:	8b 48 04             	mov    0x4(%eax),%ecx
  80059e:	8d 40 08             	lea    0x8(%eax),%eax
  8005a1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a4:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a9:	eb 3f                	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8b 10                	mov    (%eax),%edx
  8005b0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005b5:	8d 40 04             	lea    0x4(%eax),%eax
  8005b8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005bb:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c0:	eb 28                	jmp    8005ea <vprintfmt+0x3a8>
			putch('0', putdat);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	53                   	push   %ebx
  8005c6:	6a 30                	push   $0x30
  8005c8:	ff d6                	call   *%esi
			putch('x', putdat);
  8005ca:	83 c4 08             	add    $0x8,%esp
  8005cd:	53                   	push   %ebx
  8005ce:	6a 78                	push   $0x78
  8005d0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005d2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d5:	8b 10                	mov    (%eax),%edx
  8005d7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005dc:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005df:	8d 40 04             	lea    0x4(%eax),%eax
  8005e2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005e5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005ea:	83 ec 0c             	sub    $0xc,%esp
  8005ed:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8005f1:	57                   	push   %edi
  8005f2:	ff 75 e0             	pushl  -0x20(%ebp)
  8005f5:	50                   	push   %eax
  8005f6:	51                   	push   %ecx
  8005f7:	52                   	push   %edx
  8005f8:	89 da                	mov    %ebx,%edx
  8005fa:	89 f0                	mov    %esi,%eax
  8005fc:	e8 5b fb ff ff       	call   80015c <printnum>
			break;
  800601:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800604:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800607:	47                   	inc    %edi
  800608:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80060c:	83 f8 25             	cmp    $0x25,%eax
  80060f:	0f 84 44 fc ff ff    	je     800259 <vprintfmt+0x17>
			if (ch == '\0')
  800615:	85 c0                	test   %eax,%eax
  800617:	0f 84 89 00 00 00    	je     8006a6 <vprintfmt+0x464>
			putch(ch, putdat);
  80061d:	83 ec 08             	sub    $0x8,%esp
  800620:	53                   	push   %ebx
  800621:	50                   	push   %eax
  800622:	ff d6                	call   *%esi
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	eb de                	jmp    800607 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800629:	83 f9 01             	cmp    $0x1,%ecx
  80062c:	7f 1b                	jg     800649 <vprintfmt+0x407>
	else if (lflag)
  80062e:	85 c9                	test   %ecx,%ecx
  800630:	75 2c                	jne    80065e <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800632:	8b 45 14             	mov    0x14(%ebp),%eax
  800635:	8b 10                	mov    (%eax),%edx
  800637:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063c:	8d 40 04             	lea    0x4(%eax),%eax
  80063f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800642:	b8 10 00 00 00       	mov    $0x10,%eax
  800647:	eb a1                	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800649:	8b 45 14             	mov    0x14(%ebp),%eax
  80064c:	8b 10                	mov    (%eax),%edx
  80064e:	8b 48 04             	mov    0x4(%eax),%ecx
  800651:	8d 40 08             	lea    0x8(%eax),%eax
  800654:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800657:	b8 10 00 00 00       	mov    $0x10,%eax
  80065c:	eb 8c                	jmp    8005ea <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80065e:	8b 45 14             	mov    0x14(%ebp),%eax
  800661:	8b 10                	mov    (%eax),%edx
  800663:	b9 00 00 00 00       	mov    $0x0,%ecx
  800668:	8d 40 04             	lea    0x4(%eax),%eax
  80066b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80066e:	b8 10 00 00 00       	mov    $0x10,%eax
  800673:	e9 72 ff ff ff       	jmp    8005ea <vprintfmt+0x3a8>
			putch(ch, putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 25                	push   $0x25
  80067e:	ff d6                	call   *%esi
			break;
  800680:	83 c4 10             	add    $0x10,%esp
  800683:	e9 7c ff ff ff       	jmp    800604 <vprintfmt+0x3c2>
			putch('%', putdat);
  800688:	83 ec 08             	sub    $0x8,%esp
  80068b:	53                   	push   %ebx
  80068c:	6a 25                	push   $0x25
  80068e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800690:	83 c4 10             	add    $0x10,%esp
  800693:	89 f8                	mov    %edi,%eax
  800695:	eb 01                	jmp    800698 <vprintfmt+0x456>
  800697:	48                   	dec    %eax
  800698:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80069c:	75 f9                	jne    800697 <vprintfmt+0x455>
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006a1:	e9 5e ff ff ff       	jmp    800604 <vprintfmt+0x3c2>
}
  8006a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a9:	5b                   	pop    %ebx
  8006aa:	5e                   	pop    %esi
  8006ab:	5f                   	pop    %edi
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	83 ec 18             	sub    $0x18,%esp
  8006b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b7:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006bd:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006c1:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	74 26                	je     8006f5 <vsnprintf+0x47>
  8006cf:	85 d2                	test   %edx,%edx
  8006d1:	7e 29                	jle    8006fc <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006d3:	ff 75 14             	pushl  0x14(%ebp)
  8006d6:	ff 75 10             	pushl  0x10(%ebp)
  8006d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006dc:	50                   	push   %eax
  8006dd:	68 09 02 80 00       	push   $0x800209
  8006e2:	e8 5b fb ff ff       	call   800242 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006ea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006f0:	83 c4 10             	add    $0x10,%esp
}
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    
		return -E_INVAL;
  8006f5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8006fa:	eb f7                	jmp    8006f3 <vsnprintf+0x45>
  8006fc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800701:	eb f0                	jmp    8006f3 <vsnprintf+0x45>

00800703 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800709:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80070c:	50                   	push   %eax
  80070d:	ff 75 10             	pushl  0x10(%ebp)
  800710:	ff 75 0c             	pushl  0xc(%ebp)
  800713:	ff 75 08             	pushl  0x8(%ebp)
  800716:	e8 93 ff ff ff       	call   8006ae <vsnprintf>
	va_end(ap);

	return rc;
}
  80071b:	c9                   	leave  
  80071c:	c3                   	ret    

0080071d <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80071d:	55                   	push   %ebp
  80071e:	89 e5                	mov    %esp,%ebp
  800720:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800723:	b8 00 00 00 00       	mov    $0x0,%eax
  800728:	eb 01                	jmp    80072b <strlen+0xe>
		n++;
  80072a:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80072b:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80072f:	75 f9                	jne    80072a <strlen+0xd>
	return n;
}
  800731:	5d                   	pop    %ebp
  800732:	c3                   	ret    

00800733 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800733:	55                   	push   %ebp
  800734:	89 e5                	mov    %esp,%ebp
  800736:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800739:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80073c:	b8 00 00 00 00       	mov    $0x0,%eax
  800741:	eb 01                	jmp    800744 <strnlen+0x11>
		n++;
  800743:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800744:	39 d0                	cmp    %edx,%eax
  800746:	74 06                	je     80074e <strnlen+0x1b>
  800748:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80074c:	75 f5                	jne    800743 <strnlen+0x10>
	return n;
}
  80074e:	5d                   	pop    %ebp
  80074f:	c3                   	ret    

00800750 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800750:	55                   	push   %ebp
  800751:	89 e5                	mov    %esp,%ebp
  800753:	53                   	push   %ebx
  800754:	8b 45 08             	mov    0x8(%ebp),%eax
  800757:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80075a:	89 c2                	mov    %eax,%edx
  80075c:	42                   	inc    %edx
  80075d:	41                   	inc    %ecx
  80075e:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800761:	88 5a ff             	mov    %bl,-0x1(%edx)
  800764:	84 db                	test   %bl,%bl
  800766:	75 f4                	jne    80075c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800768:	5b                   	pop    %ebx
  800769:	5d                   	pop    %ebp
  80076a:	c3                   	ret    

0080076b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80076b:	55                   	push   %ebp
  80076c:	89 e5                	mov    %esp,%ebp
  80076e:	53                   	push   %ebx
  80076f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800772:	53                   	push   %ebx
  800773:	e8 a5 ff ff ff       	call   80071d <strlen>
  800778:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80077b:	ff 75 0c             	pushl  0xc(%ebp)
  80077e:	01 d8                	add    %ebx,%eax
  800780:	50                   	push   %eax
  800781:	e8 ca ff ff ff       	call   800750 <strcpy>
	return dst;
}
  800786:	89 d8                	mov    %ebx,%eax
  800788:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	56                   	push   %esi
  800791:	53                   	push   %ebx
  800792:	8b 75 08             	mov    0x8(%ebp),%esi
  800795:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800798:	89 f3                	mov    %esi,%ebx
  80079a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80079d:	89 f2                	mov    %esi,%edx
  80079f:	eb 0c                	jmp    8007ad <strncpy+0x20>
		*dst++ = *src;
  8007a1:	42                   	inc    %edx
  8007a2:	8a 01                	mov    (%ecx),%al
  8007a4:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007a7:	80 39 01             	cmpb   $0x1,(%ecx)
  8007aa:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007ad:	39 da                	cmp    %ebx,%edx
  8007af:	75 f0                	jne    8007a1 <strncpy+0x14>
	}
	return ret;
}
  8007b1:	89 f0                	mov    %esi,%eax
  8007b3:	5b                   	pop    %ebx
  8007b4:	5e                   	pop    %esi
  8007b5:	5d                   	pop    %ebp
  8007b6:	c3                   	ret    

008007b7 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007b7:	55                   	push   %ebp
  8007b8:	89 e5                	mov    %esp,%ebp
  8007ba:	56                   	push   %esi
  8007bb:	53                   	push   %ebx
  8007bc:	8b 75 08             	mov    0x8(%ebp),%esi
  8007bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007c2:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007c5:	85 c0                	test   %eax,%eax
  8007c7:	74 20                	je     8007e9 <strlcpy+0x32>
  8007c9:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8007cd:	89 f0                	mov    %esi,%eax
  8007cf:	eb 05                	jmp    8007d6 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007d1:	40                   	inc    %eax
  8007d2:	42                   	inc    %edx
  8007d3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007d6:	39 d8                	cmp    %ebx,%eax
  8007d8:	74 06                	je     8007e0 <strlcpy+0x29>
  8007da:	8a 0a                	mov    (%edx),%cl
  8007dc:	84 c9                	test   %cl,%cl
  8007de:	75 f1                	jne    8007d1 <strlcpy+0x1a>
		*dst = '\0';
  8007e0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007e3:	29 f0                	sub    %esi,%eax
}
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    
  8007e9:	89 f0                	mov    %esi,%eax
  8007eb:	eb f6                	jmp    8007e3 <strlcpy+0x2c>

008007ed <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007ed:	55                   	push   %ebp
  8007ee:	89 e5                	mov    %esp,%ebp
  8007f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007f3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8007f6:	eb 02                	jmp    8007fa <strcmp+0xd>
		p++, q++;
  8007f8:	41                   	inc    %ecx
  8007f9:	42                   	inc    %edx
	while (*p && *p == *q)
  8007fa:	8a 01                	mov    (%ecx),%al
  8007fc:	84 c0                	test   %al,%al
  8007fe:	74 04                	je     800804 <strcmp+0x17>
  800800:	3a 02                	cmp    (%edx),%al
  800802:	74 f4                	je     8007f8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800804:	0f b6 c0             	movzbl %al,%eax
  800807:	0f b6 12             	movzbl (%edx),%edx
  80080a:	29 d0                	sub    %edx,%eax
}
  80080c:	5d                   	pop    %ebp
  80080d:	c3                   	ret    

0080080e <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	53                   	push   %ebx
  800812:	8b 45 08             	mov    0x8(%ebp),%eax
  800815:	8b 55 0c             	mov    0xc(%ebp),%edx
  800818:	89 c3                	mov    %eax,%ebx
  80081a:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80081d:	eb 02                	jmp    800821 <strncmp+0x13>
		n--, p++, q++;
  80081f:	40                   	inc    %eax
  800820:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800821:	39 d8                	cmp    %ebx,%eax
  800823:	74 15                	je     80083a <strncmp+0x2c>
  800825:	8a 08                	mov    (%eax),%cl
  800827:	84 c9                	test   %cl,%cl
  800829:	74 04                	je     80082f <strncmp+0x21>
  80082b:	3a 0a                	cmp    (%edx),%cl
  80082d:	74 f0                	je     80081f <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80082f:	0f b6 00             	movzbl (%eax),%eax
  800832:	0f b6 12             	movzbl (%edx),%edx
  800835:	29 d0                	sub    %edx,%eax
}
  800837:	5b                   	pop    %ebx
  800838:	5d                   	pop    %ebp
  800839:	c3                   	ret    
		return 0;
  80083a:	b8 00 00 00 00       	mov    $0x0,%eax
  80083f:	eb f6                	jmp    800837 <strncmp+0x29>

00800841 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800841:	55                   	push   %ebp
  800842:	89 e5                	mov    %esp,%ebp
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80084a:	8a 10                	mov    (%eax),%dl
  80084c:	84 d2                	test   %dl,%dl
  80084e:	74 07                	je     800857 <strchr+0x16>
		if (*s == c)
  800850:	38 ca                	cmp    %cl,%dl
  800852:	74 08                	je     80085c <strchr+0x1b>
	for (; *s; s++)
  800854:	40                   	inc    %eax
  800855:	eb f3                	jmp    80084a <strchr+0x9>
			return (char *) s;
	return 0;
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80085c:	5d                   	pop    %ebp
  80085d:	c3                   	ret    

0080085e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	8b 45 08             	mov    0x8(%ebp),%eax
  800864:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800867:	8a 10                	mov    (%eax),%dl
  800869:	84 d2                	test   %dl,%dl
  80086b:	74 07                	je     800874 <strfind+0x16>
		if (*s == c)
  80086d:	38 ca                	cmp    %cl,%dl
  80086f:	74 03                	je     800874 <strfind+0x16>
	for (; *s; s++)
  800871:	40                   	inc    %eax
  800872:	eb f3                	jmp    800867 <strfind+0x9>
			break;
	return (char *) s;
}
  800874:	5d                   	pop    %ebp
  800875:	c3                   	ret    

00800876 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800876:	55                   	push   %ebp
  800877:	89 e5                	mov    %esp,%ebp
  800879:	57                   	push   %edi
  80087a:	56                   	push   %esi
  80087b:	53                   	push   %ebx
  80087c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80087f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800882:	85 c9                	test   %ecx,%ecx
  800884:	74 13                	je     800899 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800886:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80088c:	75 05                	jne    800893 <memset+0x1d>
  80088e:	f6 c1 03             	test   $0x3,%cl
  800891:	74 0d                	je     8008a0 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800893:	8b 45 0c             	mov    0xc(%ebp),%eax
  800896:	fc                   	cld    
  800897:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800899:	89 f8                	mov    %edi,%eax
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5f                   	pop    %edi
  80089e:	5d                   	pop    %ebp
  80089f:	c3                   	ret    
		c &= 0xFF;
  8008a0:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008a4:	89 d3                	mov    %edx,%ebx
  8008a6:	c1 e3 08             	shl    $0x8,%ebx
  8008a9:	89 d0                	mov    %edx,%eax
  8008ab:	c1 e0 18             	shl    $0x18,%eax
  8008ae:	89 d6                	mov    %edx,%esi
  8008b0:	c1 e6 10             	shl    $0x10,%esi
  8008b3:	09 f0                	or     %esi,%eax
  8008b5:	09 c2                	or     %eax,%edx
  8008b7:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008b9:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008bc:	89 d0                	mov    %edx,%eax
  8008be:	fc                   	cld    
  8008bf:	f3 ab                	rep stos %eax,%es:(%edi)
  8008c1:	eb d6                	jmp    800899 <memset+0x23>

008008c3 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	57                   	push   %edi
  8008c7:	56                   	push   %esi
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008d1:	39 c6                	cmp    %eax,%esi
  8008d3:	73 33                	jae    800908 <memmove+0x45>
  8008d5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008d8:	39 d0                	cmp    %edx,%eax
  8008da:	73 2c                	jae    800908 <memmove+0x45>
		s += n;
		d += n;
  8008dc:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008df:	89 d6                	mov    %edx,%esi
  8008e1:	09 fe                	or     %edi,%esi
  8008e3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008e9:	75 13                	jne    8008fe <memmove+0x3b>
  8008eb:	f6 c1 03             	test   $0x3,%cl
  8008ee:	75 0e                	jne    8008fe <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8008f0:	83 ef 04             	sub    $0x4,%edi
  8008f3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8008f6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8008f9:	fd                   	std    
  8008fa:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8008fc:	eb 07                	jmp    800905 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8008fe:	4f                   	dec    %edi
  8008ff:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800902:	fd                   	std    
  800903:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800905:	fc                   	cld    
  800906:	eb 13                	jmp    80091b <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800908:	89 f2                	mov    %esi,%edx
  80090a:	09 c2                	or     %eax,%edx
  80090c:	f6 c2 03             	test   $0x3,%dl
  80090f:	75 05                	jne    800916 <memmove+0x53>
  800911:	f6 c1 03             	test   $0x3,%cl
  800914:	74 09                	je     80091f <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800916:	89 c7                	mov    %eax,%edi
  800918:	fc                   	cld    
  800919:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80091b:	5e                   	pop    %esi
  80091c:	5f                   	pop    %edi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80091f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800922:	89 c7                	mov    %eax,%edi
  800924:	fc                   	cld    
  800925:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800927:	eb f2                	jmp    80091b <memmove+0x58>

00800929 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800929:	55                   	push   %ebp
  80092a:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80092c:	ff 75 10             	pushl  0x10(%ebp)
  80092f:	ff 75 0c             	pushl  0xc(%ebp)
  800932:	ff 75 08             	pushl  0x8(%ebp)
  800935:	e8 89 ff ff ff       	call   8008c3 <memmove>
}
  80093a:	c9                   	leave  
  80093b:	c3                   	ret    

0080093c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80093c:	55                   	push   %ebp
  80093d:	89 e5                	mov    %esp,%ebp
  80093f:	56                   	push   %esi
  800940:	53                   	push   %ebx
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	89 c6                	mov    %eax,%esi
  800946:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800949:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80094c:	39 f0                	cmp    %esi,%eax
  80094e:	74 16                	je     800966 <memcmp+0x2a>
		if (*s1 != *s2)
  800950:	8a 08                	mov    (%eax),%cl
  800952:	8a 1a                	mov    (%edx),%bl
  800954:	38 d9                	cmp    %bl,%cl
  800956:	75 04                	jne    80095c <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800958:	40                   	inc    %eax
  800959:	42                   	inc    %edx
  80095a:	eb f0                	jmp    80094c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80095c:	0f b6 c1             	movzbl %cl,%eax
  80095f:	0f b6 db             	movzbl %bl,%ebx
  800962:	29 d8                	sub    %ebx,%eax
  800964:	eb 05                	jmp    80096b <memcmp+0x2f>
	}

	return 0;
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80096b:	5b                   	pop    %ebx
  80096c:	5e                   	pop    %esi
  80096d:	5d                   	pop    %ebp
  80096e:	c3                   	ret    

0080096f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	8b 45 08             	mov    0x8(%ebp),%eax
  800975:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800978:	89 c2                	mov    %eax,%edx
  80097a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80097d:	39 d0                	cmp    %edx,%eax
  80097f:	73 07                	jae    800988 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800981:	38 08                	cmp    %cl,(%eax)
  800983:	74 03                	je     800988 <memfind+0x19>
	for (; s < ends; s++)
  800985:	40                   	inc    %eax
  800986:	eb f5                	jmp    80097d <memfind+0xe>
			break;
	return (void *) s;
}
  800988:	5d                   	pop    %ebp
  800989:	c3                   	ret    

0080098a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	57                   	push   %edi
  80098e:	56                   	push   %esi
  80098f:	53                   	push   %ebx
  800990:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800993:	eb 01                	jmp    800996 <strtol+0xc>
		s++;
  800995:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800996:	8a 01                	mov    (%ecx),%al
  800998:	3c 20                	cmp    $0x20,%al
  80099a:	74 f9                	je     800995 <strtol+0xb>
  80099c:	3c 09                	cmp    $0x9,%al
  80099e:	74 f5                	je     800995 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009a0:	3c 2b                	cmp    $0x2b,%al
  8009a2:	74 2b                	je     8009cf <strtol+0x45>
		s++;
	else if (*s == '-')
  8009a4:	3c 2d                	cmp    $0x2d,%al
  8009a6:	74 2f                	je     8009d7 <strtol+0x4d>
	int neg = 0;
  8009a8:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009ad:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009b4:	75 12                	jne    8009c8 <strtol+0x3e>
  8009b6:	80 39 30             	cmpb   $0x30,(%ecx)
  8009b9:	74 24                	je     8009df <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009bb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009bf:	75 07                	jne    8009c8 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009c1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8009c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8009cd:	eb 4e                	jmp    800a1d <strtol+0x93>
		s++;
  8009cf:	41                   	inc    %ecx
	int neg = 0;
  8009d0:	bf 00 00 00 00       	mov    $0x0,%edi
  8009d5:	eb d6                	jmp    8009ad <strtol+0x23>
		s++, neg = 1;
  8009d7:	41                   	inc    %ecx
  8009d8:	bf 01 00 00 00       	mov    $0x1,%edi
  8009dd:	eb ce                	jmp    8009ad <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009df:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009e3:	74 10                	je     8009f5 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  8009e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009e9:	75 dd                	jne    8009c8 <strtol+0x3e>
		s++, base = 8;
  8009eb:	41                   	inc    %ecx
  8009ec:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8009f3:	eb d3                	jmp    8009c8 <strtol+0x3e>
		s += 2, base = 16;
  8009f5:	83 c1 02             	add    $0x2,%ecx
  8009f8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8009ff:	eb c7                	jmp    8009c8 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a01:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a04:	89 f3                	mov    %esi,%ebx
  800a06:	80 fb 19             	cmp    $0x19,%bl
  800a09:	77 24                	ja     800a2f <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a0b:	0f be d2             	movsbl %dl,%edx
  800a0e:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a11:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a14:	7d 2b                	jge    800a41 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a16:	41                   	inc    %ecx
  800a17:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a1b:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a1d:	8a 11                	mov    (%ecx),%dl
  800a1f:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a22:	80 fb 09             	cmp    $0x9,%bl
  800a25:	77 da                	ja     800a01 <strtol+0x77>
			dig = *s - '0';
  800a27:	0f be d2             	movsbl %dl,%edx
  800a2a:	83 ea 30             	sub    $0x30,%edx
  800a2d:	eb e2                	jmp    800a11 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a2f:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a32:	89 f3                	mov    %esi,%ebx
  800a34:	80 fb 19             	cmp    $0x19,%bl
  800a37:	77 08                	ja     800a41 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a39:	0f be d2             	movsbl %dl,%edx
  800a3c:	83 ea 37             	sub    $0x37,%edx
  800a3f:	eb d0                	jmp    800a11 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a41:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a45:	74 05                	je     800a4c <strtol+0xc2>
		*endptr = (char *) s;
  800a47:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a4a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a4c:	85 ff                	test   %edi,%edi
  800a4e:	74 02                	je     800a52 <strtol+0xc8>
  800a50:	f7 d8                	neg    %eax
}
  800a52:	5b                   	pop    %ebx
  800a53:	5e                   	pop    %esi
  800a54:	5f                   	pop    %edi
  800a55:	5d                   	pop    %ebp
  800a56:	c3                   	ret    

00800a57 <atoi>:

int
atoi(const char *s)
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800a5a:	6a 0a                	push   $0xa
  800a5c:	6a 00                	push   $0x0
  800a5e:	ff 75 08             	pushl  0x8(%ebp)
  800a61:	e8 24 ff ff ff       	call   80098a <strtol>
}
  800a66:	c9                   	leave  
  800a67:	c3                   	ret    

00800a68 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a68:	55                   	push   %ebp
  800a69:	89 e5                	mov    %esp,%ebp
  800a6b:	57                   	push   %edi
  800a6c:	56                   	push   %esi
  800a6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a6e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a73:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a76:	8b 55 08             	mov    0x8(%ebp),%edx
  800a79:	89 c3                	mov    %eax,%ebx
  800a7b:	89 c7                	mov    %eax,%edi
  800a7d:	89 c6                	mov    %eax,%esi
  800a7f:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a81:	5b                   	pop    %ebx
  800a82:	5e                   	pop    %esi
  800a83:	5f                   	pop    %edi
  800a84:	5d                   	pop    %ebp
  800a85:	c3                   	ret    

00800a86 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a86:	55                   	push   %ebp
  800a87:	89 e5                	mov    %esp,%ebp
  800a89:	57                   	push   %edi
  800a8a:	56                   	push   %esi
  800a8b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a8c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a91:	b8 01 00 00 00       	mov    $0x1,%eax
  800a96:	89 d1                	mov    %edx,%ecx
  800a98:	89 d3                	mov    %edx,%ebx
  800a9a:	89 d7                	mov    %edx,%edi
  800a9c:	89 d6                	mov    %edx,%esi
  800a9e:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800aa0:	5b                   	pop    %ebx
  800aa1:	5e                   	pop    %esi
  800aa2:	5f                   	pop    %edi
  800aa3:	5d                   	pop    %ebp
  800aa4:	c3                   	ret    

00800aa5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800aa5:	55                   	push   %ebp
  800aa6:	89 e5                	mov    %esp,%ebp
  800aa8:	57                   	push   %edi
  800aa9:	56                   	push   %esi
  800aaa:	53                   	push   %ebx
  800aab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800aae:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ab3:	b8 03 00 00 00       	mov    $0x3,%eax
  800ab8:	8b 55 08             	mov    0x8(%ebp),%edx
  800abb:	89 cb                	mov    %ecx,%ebx
  800abd:	89 cf                	mov    %ecx,%edi
  800abf:	89 ce                	mov    %ecx,%esi
  800ac1:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ac3:	85 c0                	test   %eax,%eax
  800ac5:	7f 08                	jg     800acf <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ac7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5f                   	pop    %edi
  800acd:	5d                   	pop    %ebp
  800ace:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800acf:	83 ec 0c             	sub    $0xc,%esp
  800ad2:	50                   	push   %eax
  800ad3:	6a 03                	push   $0x3
  800ad5:	68 1f 22 80 00       	push   $0x80221f
  800ada:	6a 23                	push   $0x23
  800adc:	68 3c 22 80 00       	push   $0x80223c
  800ae1:	e8 df 0f 00 00       	call   801ac5 <_panic>

00800ae6 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	57                   	push   %edi
  800aea:	56                   	push   %esi
  800aeb:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aec:	ba 00 00 00 00       	mov    $0x0,%edx
  800af1:	b8 02 00 00 00       	mov    $0x2,%eax
  800af6:	89 d1                	mov    %edx,%ecx
  800af8:	89 d3                	mov    %edx,%ebx
  800afa:	89 d7                	mov    %edx,%edi
  800afc:	89 d6                	mov    %edx,%esi
  800afe:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b00:	5b                   	pop    %ebx
  800b01:	5e                   	pop    %esi
  800b02:	5f                   	pop    %edi
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	57                   	push   %edi
  800b09:	56                   	push   %esi
  800b0a:	53                   	push   %ebx
  800b0b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b0e:	be 00 00 00 00       	mov    $0x0,%esi
  800b13:	b8 04 00 00 00       	mov    $0x4,%eax
  800b18:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b1b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b1e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b21:	89 f7                	mov    %esi,%edi
  800b23:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b25:	85 c0                	test   %eax,%eax
  800b27:	7f 08                	jg     800b31 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b29:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b2c:	5b                   	pop    %ebx
  800b2d:	5e                   	pop    %esi
  800b2e:	5f                   	pop    %edi
  800b2f:	5d                   	pop    %ebp
  800b30:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b31:	83 ec 0c             	sub    $0xc,%esp
  800b34:	50                   	push   %eax
  800b35:	6a 04                	push   $0x4
  800b37:	68 1f 22 80 00       	push   $0x80221f
  800b3c:	6a 23                	push   $0x23
  800b3e:	68 3c 22 80 00       	push   $0x80223c
  800b43:	e8 7d 0f 00 00       	call   801ac5 <_panic>

00800b48 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b48:	55                   	push   %ebp
  800b49:	89 e5                	mov    %esp,%ebp
  800b4b:	57                   	push   %edi
  800b4c:	56                   	push   %esi
  800b4d:	53                   	push   %ebx
  800b4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b51:	b8 05 00 00 00       	mov    $0x5,%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b62:	8b 75 18             	mov    0x18(%ebp),%esi
  800b65:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b67:	85 c0                	test   %eax,%eax
  800b69:	7f 08                	jg     800b73 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b6e:	5b                   	pop    %ebx
  800b6f:	5e                   	pop    %esi
  800b70:	5f                   	pop    %edi
  800b71:	5d                   	pop    %ebp
  800b72:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b73:	83 ec 0c             	sub    $0xc,%esp
  800b76:	50                   	push   %eax
  800b77:	6a 05                	push   $0x5
  800b79:	68 1f 22 80 00       	push   $0x80221f
  800b7e:	6a 23                	push   $0x23
  800b80:	68 3c 22 80 00       	push   $0x80223c
  800b85:	e8 3b 0f 00 00       	call   801ac5 <_panic>

00800b8a <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b8a:	55                   	push   %ebp
  800b8b:	89 e5                	mov    %esp,%ebp
  800b8d:	57                   	push   %edi
  800b8e:	56                   	push   %esi
  800b8f:	53                   	push   %ebx
  800b90:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b93:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b98:	b8 06 00 00 00       	mov    $0x6,%eax
  800b9d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ba0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ba3:	89 df                	mov    %ebx,%edi
  800ba5:	89 de                	mov    %ebx,%esi
  800ba7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba9:	85 c0                	test   %eax,%eax
  800bab:	7f 08                	jg     800bb5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bb0:	5b                   	pop    %ebx
  800bb1:	5e                   	pop    %esi
  800bb2:	5f                   	pop    %edi
  800bb3:	5d                   	pop    %ebp
  800bb4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb5:	83 ec 0c             	sub    $0xc,%esp
  800bb8:	50                   	push   %eax
  800bb9:	6a 06                	push   $0x6
  800bbb:	68 1f 22 80 00       	push   $0x80221f
  800bc0:	6a 23                	push   $0x23
  800bc2:	68 3c 22 80 00       	push   $0x80223c
  800bc7:	e8 f9 0e 00 00       	call   801ac5 <_panic>

00800bcc <sys_yield>:

void
sys_yield(void)
{
  800bcc:	55                   	push   %ebp
  800bcd:	89 e5                	mov    %esp,%ebp
  800bcf:	57                   	push   %edi
  800bd0:	56                   	push   %esi
  800bd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd7:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bdc:	89 d1                	mov    %edx,%ecx
  800bde:	89 d3                	mov    %edx,%ebx
  800be0:	89 d7                	mov    %edx,%edi
  800be2:	89 d6                	mov    %edx,%esi
  800be4:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800be6:	5b                   	pop    %ebx
  800be7:	5e                   	pop    %esi
  800be8:	5f                   	pop    %edi
  800be9:	5d                   	pop    %ebp
  800bea:	c3                   	ret    

00800beb <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	57                   	push   %edi
  800bef:	56                   	push   %esi
  800bf0:	53                   	push   %ebx
  800bf1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bf9:	b8 08 00 00 00       	mov    $0x8,%eax
  800bfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c01:	8b 55 08             	mov    0x8(%ebp),%edx
  800c04:	89 df                	mov    %ebx,%edi
  800c06:	89 de                	mov    %ebx,%esi
  800c08:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	7f 08                	jg     800c16 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c0e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c11:	5b                   	pop    %ebx
  800c12:	5e                   	pop    %esi
  800c13:	5f                   	pop    %edi
  800c14:	5d                   	pop    %ebp
  800c15:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c16:	83 ec 0c             	sub    $0xc,%esp
  800c19:	50                   	push   %eax
  800c1a:	6a 08                	push   $0x8
  800c1c:	68 1f 22 80 00       	push   $0x80221f
  800c21:	6a 23                	push   $0x23
  800c23:	68 3c 22 80 00       	push   $0x80223c
  800c28:	e8 98 0e 00 00       	call   801ac5 <_panic>

00800c2d <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c2d:	55                   	push   %ebp
  800c2e:	89 e5                	mov    %esp,%ebp
  800c30:	57                   	push   %edi
  800c31:	56                   	push   %esi
  800c32:	53                   	push   %ebx
  800c33:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c36:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c3b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c40:	8b 55 08             	mov    0x8(%ebp),%edx
  800c43:	89 cb                	mov    %ecx,%ebx
  800c45:	89 cf                	mov    %ecx,%edi
  800c47:	89 ce                	mov    %ecx,%esi
  800c49:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4b:	85 c0                	test   %eax,%eax
  800c4d:	7f 08                	jg     800c57 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c4f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c52:	5b                   	pop    %ebx
  800c53:	5e                   	pop    %esi
  800c54:	5f                   	pop    %edi
  800c55:	5d                   	pop    %ebp
  800c56:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c57:	83 ec 0c             	sub    $0xc,%esp
  800c5a:	50                   	push   %eax
  800c5b:	6a 0c                	push   $0xc
  800c5d:	68 1f 22 80 00       	push   $0x80221f
  800c62:	6a 23                	push   $0x23
  800c64:	68 3c 22 80 00       	push   $0x80223c
  800c69:	e8 57 0e 00 00       	call   801ac5 <_panic>

00800c6e <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	57                   	push   %edi
  800c72:	56                   	push   %esi
  800c73:	53                   	push   %ebx
  800c74:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c77:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7c:	b8 09 00 00 00       	mov    $0x9,%eax
  800c81:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c84:	8b 55 08             	mov    0x8(%ebp),%edx
  800c87:	89 df                	mov    %ebx,%edi
  800c89:	89 de                	mov    %ebx,%esi
  800c8b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8d:	85 c0                	test   %eax,%eax
  800c8f:	7f 08                	jg     800c99 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800c91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c94:	5b                   	pop    %ebx
  800c95:	5e                   	pop    %esi
  800c96:	5f                   	pop    %edi
  800c97:	5d                   	pop    %ebp
  800c98:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c99:	83 ec 0c             	sub    $0xc,%esp
  800c9c:	50                   	push   %eax
  800c9d:	6a 09                	push   $0x9
  800c9f:	68 1f 22 80 00       	push   $0x80221f
  800ca4:	6a 23                	push   $0x23
  800ca6:	68 3c 22 80 00       	push   $0x80223c
  800cab:	e8 15 0e 00 00       	call   801ac5 <_panic>

00800cb0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cb0:	55                   	push   %ebp
  800cb1:	89 e5                	mov    %esp,%ebp
  800cb3:	57                   	push   %edi
  800cb4:	56                   	push   %esi
  800cb5:	53                   	push   %ebx
  800cb6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cb9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cbe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cc3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	89 df                	mov    %ebx,%edi
  800ccb:	89 de                	mov    %ebx,%esi
  800ccd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ccf:	85 c0                	test   %eax,%eax
  800cd1:	7f 08                	jg     800cdb <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800cd3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cd6:	5b                   	pop    %ebx
  800cd7:	5e                   	pop    %esi
  800cd8:	5f                   	pop    %edi
  800cd9:	5d                   	pop    %ebp
  800cda:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cdb:	83 ec 0c             	sub    $0xc,%esp
  800cde:	50                   	push   %eax
  800cdf:	6a 0a                	push   $0xa
  800ce1:	68 1f 22 80 00       	push   $0x80221f
  800ce6:	6a 23                	push   $0x23
  800ce8:	68 3c 22 80 00       	push   $0x80223c
  800ced:	e8 d3 0d 00 00       	call   801ac5 <_panic>

00800cf2 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800cf2:	55                   	push   %ebp
  800cf3:	89 e5                	mov    %esp,%ebp
  800cf5:	57                   	push   %edi
  800cf6:	56                   	push   %esi
  800cf7:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cf8:	be 00 00 00 00       	mov    $0x0,%esi
  800cfd:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d02:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d05:	8b 55 08             	mov    0x8(%ebp),%edx
  800d08:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d0b:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d0e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d10:	5b                   	pop    %ebx
  800d11:	5e                   	pop    %esi
  800d12:	5f                   	pop    %edi
  800d13:	5d                   	pop    %ebp
  800d14:	c3                   	ret    

00800d15 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	57                   	push   %edi
  800d19:	56                   	push   %esi
  800d1a:	53                   	push   %ebx
  800d1b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d1e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d23:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d28:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2b:	89 cb                	mov    %ecx,%ebx
  800d2d:	89 cf                	mov    %ecx,%edi
  800d2f:	89 ce                	mov    %ecx,%esi
  800d31:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d33:	85 c0                	test   %eax,%eax
  800d35:	7f 08                	jg     800d3f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d37:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d3a:	5b                   	pop    %ebx
  800d3b:	5e                   	pop    %esi
  800d3c:	5f                   	pop    %edi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3f:	83 ec 0c             	sub    $0xc,%esp
  800d42:	50                   	push   %eax
  800d43:	6a 0e                	push   $0xe
  800d45:	68 1f 22 80 00       	push   $0x80221f
  800d4a:	6a 23                	push   $0x23
  800d4c:	68 3c 22 80 00       	push   $0x80223c
  800d51:	e8 6f 0d 00 00       	call   801ac5 <_panic>

00800d56 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800d56:	55                   	push   %ebp
  800d57:	89 e5                	mov    %esp,%ebp
  800d59:	57                   	push   %edi
  800d5a:	56                   	push   %esi
  800d5b:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d5c:	be 00 00 00 00       	mov    $0x0,%esi
  800d61:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d69:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d6f:	89 f7                	mov    %esi,%edi
  800d71:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800d73:	5b                   	pop    %ebx
  800d74:	5e                   	pop    %esi
  800d75:	5f                   	pop    %edi
  800d76:	5d                   	pop    %ebp
  800d77:	c3                   	ret    

00800d78 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800d78:	55                   	push   %ebp
  800d79:	89 e5                	mov    %esp,%ebp
  800d7b:	57                   	push   %edi
  800d7c:	56                   	push   %esi
  800d7d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d7e:	be 00 00 00 00       	mov    $0x0,%esi
  800d83:	b8 10 00 00 00       	mov    $0x10,%eax
  800d88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d91:	89 f7                	mov    %esi,%edi
  800d93:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800d95:	5b                   	pop    %ebx
  800d96:	5e                   	pop    %esi
  800d97:	5f                   	pop    %edi
  800d98:	5d                   	pop    %ebp
  800d99:	c3                   	ret    

00800d9a <sys_set_console_color>:

void sys_set_console_color(int color) {
  800d9a:	55                   	push   %ebp
  800d9b:	89 e5                	mov    %esp,%ebp
  800d9d:	57                   	push   %edi
  800d9e:	56                   	push   %esi
  800d9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800da0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800da5:	b8 11 00 00 00       	mov    $0x11,%eax
  800daa:	8b 55 08             	mov    0x8(%ebp),%edx
  800dad:	89 cb                	mov    %ecx,%ebx
  800daf:	89 cf                	mov    %ecx,%edi
  800db1:	89 ce                	mov    %ecx,%esi
  800db3:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    

00800dba <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dba:	55                   	push   %ebp
  800dbb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	05 00 00 00 30       	add    $0x30000000,%eax
  800dc5:	c1 e8 0c             	shr    $0xc,%eax
}
  800dc8:	5d                   	pop    %ebp
  800dc9:	c3                   	ret    

00800dca <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800dca:	55                   	push   %ebp
  800dcb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800dd5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dda:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800ddf:	5d                   	pop    %ebp
  800de0:	c3                   	ret    

00800de1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800de7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dec:	89 c2                	mov    %eax,%edx
  800dee:	c1 ea 16             	shr    $0x16,%edx
  800df1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800df8:	f6 c2 01             	test   $0x1,%dl
  800dfb:	74 2a                	je     800e27 <fd_alloc+0x46>
  800dfd:	89 c2                	mov    %eax,%edx
  800dff:	c1 ea 0c             	shr    $0xc,%edx
  800e02:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e09:	f6 c2 01             	test   $0x1,%dl
  800e0c:	74 19                	je     800e27 <fd_alloc+0x46>
  800e0e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e13:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e18:	75 d2                	jne    800dec <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e1a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e20:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e25:	eb 07                	jmp    800e2e <fd_alloc+0x4d>
			*fd_store = fd;
  800e27:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e33:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800e37:	77 39                	ja     800e72 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	c1 e0 0c             	shl    $0xc,%eax
  800e3f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e44:	89 c2                	mov    %eax,%edx
  800e46:	c1 ea 16             	shr    $0x16,%edx
  800e49:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e50:	f6 c2 01             	test   $0x1,%dl
  800e53:	74 24                	je     800e79 <fd_lookup+0x49>
  800e55:	89 c2                	mov    %eax,%edx
  800e57:	c1 ea 0c             	shr    $0xc,%edx
  800e5a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e61:	f6 c2 01             	test   $0x1,%dl
  800e64:	74 1a                	je     800e80 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e66:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e69:	89 02                	mov    %eax,(%edx)
	return 0;
  800e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e70:	5d                   	pop    %ebp
  800e71:	c3                   	ret    
		return -E_INVAL;
  800e72:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e77:	eb f7                	jmp    800e70 <fd_lookup+0x40>
		return -E_INVAL;
  800e79:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e7e:	eb f0                	jmp    800e70 <fd_lookup+0x40>
  800e80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e85:	eb e9                	jmp    800e70 <fd_lookup+0x40>

00800e87 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e87:	55                   	push   %ebp
  800e88:	89 e5                	mov    %esp,%ebp
  800e8a:	83 ec 08             	sub    $0x8,%esp
  800e8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e90:	ba c8 22 80 00       	mov    $0x8022c8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800e95:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800e9a:	39 08                	cmp    %ecx,(%eax)
  800e9c:	74 33                	je     800ed1 <dev_lookup+0x4a>
  800e9e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800ea1:	8b 02                	mov    (%edx),%eax
  800ea3:	85 c0                	test   %eax,%eax
  800ea5:	75 f3                	jne    800e9a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800ea7:	a1 04 40 80 00       	mov    0x804004,%eax
  800eac:	8b 40 48             	mov    0x48(%eax),%eax
  800eaf:	83 ec 04             	sub    $0x4,%esp
  800eb2:	51                   	push   %ecx
  800eb3:	50                   	push   %eax
  800eb4:	68 4c 22 80 00       	push   $0x80224c
  800eb9:	e8 8a f2 ff ff       	call   800148 <cprintf>
	*dev = 0;
  800ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ec7:	83 c4 10             	add    $0x10,%esp
  800eca:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    
			*dev = devtab[i];
  800ed1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ed4:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
  800edb:	eb f2                	jmp    800ecf <dev_lookup+0x48>

00800edd <fd_close>:
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	57                   	push   %edi
  800ee1:	56                   	push   %esi
  800ee2:	53                   	push   %ebx
  800ee3:	83 ec 1c             	sub    $0x1c,%esp
  800ee6:	8b 75 08             	mov    0x8(%ebp),%esi
  800ee9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800eec:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800eef:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ef0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800ef6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800ef9:	50                   	push   %eax
  800efa:	e8 31 ff ff ff       	call   800e30 <fd_lookup>
  800eff:	89 c7                	mov    %eax,%edi
  800f01:	83 c4 08             	add    $0x8,%esp
  800f04:	85 c0                	test   %eax,%eax
  800f06:	78 05                	js     800f0d <fd_close+0x30>
	    || fd != fd2)
  800f08:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800f0b:	74 13                	je     800f20 <fd_close+0x43>
		return (must_exist ? r : 0);
  800f0d:	84 db                	test   %bl,%bl
  800f0f:	75 05                	jne    800f16 <fd_close+0x39>
  800f11:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800f16:	89 f8                	mov    %edi,%eax
  800f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f1b:	5b                   	pop    %ebx
  800f1c:	5e                   	pop    %esi
  800f1d:	5f                   	pop    %edi
  800f1e:	5d                   	pop    %ebp
  800f1f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f26:	50                   	push   %eax
  800f27:	ff 36                	pushl  (%esi)
  800f29:	e8 59 ff ff ff       	call   800e87 <dev_lookup>
  800f2e:	89 c7                	mov    %eax,%edi
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	85 c0                	test   %eax,%eax
  800f35:	78 15                	js     800f4c <fd_close+0x6f>
		if (dev->dev_close)
  800f37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f3a:	8b 40 10             	mov    0x10(%eax),%eax
  800f3d:	85 c0                	test   %eax,%eax
  800f3f:	74 1b                	je     800f5c <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800f41:	83 ec 0c             	sub    $0xc,%esp
  800f44:	56                   	push   %esi
  800f45:	ff d0                	call   *%eax
  800f47:	89 c7                	mov    %eax,%edi
  800f49:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f4c:	83 ec 08             	sub    $0x8,%esp
  800f4f:	56                   	push   %esi
  800f50:	6a 00                	push   $0x0
  800f52:	e8 33 fc ff ff       	call   800b8a <sys_page_unmap>
	return r;
  800f57:	83 c4 10             	add    $0x10,%esp
  800f5a:	eb ba                	jmp    800f16 <fd_close+0x39>
			r = 0;
  800f5c:	bf 00 00 00 00       	mov    $0x0,%edi
  800f61:	eb e9                	jmp    800f4c <fd_close+0x6f>

00800f63 <close>:

int
close(int fdnum)
{
  800f63:	55                   	push   %ebp
  800f64:	89 e5                	mov    %esp,%ebp
  800f66:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f69:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f6c:	50                   	push   %eax
  800f6d:	ff 75 08             	pushl  0x8(%ebp)
  800f70:	e8 bb fe ff ff       	call   800e30 <fd_lookup>
  800f75:	83 c4 08             	add    $0x8,%esp
  800f78:	85 c0                	test   %eax,%eax
  800f7a:	78 10                	js     800f8c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f7c:	83 ec 08             	sub    $0x8,%esp
  800f7f:	6a 01                	push   $0x1
  800f81:	ff 75 f4             	pushl  -0xc(%ebp)
  800f84:	e8 54 ff ff ff       	call   800edd <fd_close>
  800f89:	83 c4 10             	add    $0x10,%esp
}
  800f8c:	c9                   	leave  
  800f8d:	c3                   	ret    

00800f8e <close_all>:

void
close_all(void)
{
  800f8e:	55                   	push   %ebp
  800f8f:	89 e5                	mov    %esp,%ebp
  800f91:	53                   	push   %ebx
  800f92:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800f95:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800f9a:	83 ec 0c             	sub    $0xc,%esp
  800f9d:	53                   	push   %ebx
  800f9e:	e8 c0 ff ff ff       	call   800f63 <close>
	for (i = 0; i < MAXFD; i++)
  800fa3:	43                   	inc    %ebx
  800fa4:	83 c4 10             	add    $0x10,%esp
  800fa7:	83 fb 20             	cmp    $0x20,%ebx
  800faa:	75 ee                	jne    800f9a <close_all+0xc>
}
  800fac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800faf:	c9                   	leave  
  800fb0:	c3                   	ret    

00800fb1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fb1:	55                   	push   %ebp
  800fb2:	89 e5                	mov    %esp,%ebp
  800fb4:	57                   	push   %edi
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fbd:	50                   	push   %eax
  800fbe:	ff 75 08             	pushl  0x8(%ebp)
  800fc1:	e8 6a fe ff ff       	call   800e30 <fd_lookup>
  800fc6:	89 c3                	mov    %eax,%ebx
  800fc8:	83 c4 08             	add    $0x8,%esp
  800fcb:	85 c0                	test   %eax,%eax
  800fcd:	0f 88 81 00 00 00    	js     801054 <dup+0xa3>
		return r;
	close(newfdnum);
  800fd3:	83 ec 0c             	sub    $0xc,%esp
  800fd6:	ff 75 0c             	pushl  0xc(%ebp)
  800fd9:	e8 85 ff ff ff       	call   800f63 <close>

	newfd = INDEX2FD(newfdnum);
  800fde:	8b 75 0c             	mov    0xc(%ebp),%esi
  800fe1:	c1 e6 0c             	shl    $0xc,%esi
  800fe4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800fea:	83 c4 04             	add    $0x4,%esp
  800fed:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ff0:	e8 d5 fd ff ff       	call   800dca <fd2data>
  800ff5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800ff7:	89 34 24             	mov    %esi,(%esp)
  800ffa:	e8 cb fd ff ff       	call   800dca <fd2data>
  800fff:	83 c4 10             	add    $0x10,%esp
  801002:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801004:	89 d8                	mov    %ebx,%eax
  801006:	c1 e8 16             	shr    $0x16,%eax
  801009:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801010:	a8 01                	test   $0x1,%al
  801012:	74 11                	je     801025 <dup+0x74>
  801014:	89 d8                	mov    %ebx,%eax
  801016:	c1 e8 0c             	shr    $0xc,%eax
  801019:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801020:	f6 c2 01             	test   $0x1,%dl
  801023:	75 39                	jne    80105e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801025:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801028:	89 d0                	mov    %edx,%eax
  80102a:	c1 e8 0c             	shr    $0xc,%eax
  80102d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801034:	83 ec 0c             	sub    $0xc,%esp
  801037:	25 07 0e 00 00       	and    $0xe07,%eax
  80103c:	50                   	push   %eax
  80103d:	56                   	push   %esi
  80103e:	6a 00                	push   $0x0
  801040:	52                   	push   %edx
  801041:	6a 00                	push   $0x0
  801043:	e8 00 fb ff ff       	call   800b48 <sys_page_map>
  801048:	89 c3                	mov    %eax,%ebx
  80104a:	83 c4 20             	add    $0x20,%esp
  80104d:	85 c0                	test   %eax,%eax
  80104f:	78 31                	js     801082 <dup+0xd1>
		goto err;

	return newfdnum;
  801051:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801054:	89 d8                	mov    %ebx,%eax
  801056:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801059:	5b                   	pop    %ebx
  80105a:	5e                   	pop    %esi
  80105b:	5f                   	pop    %edi
  80105c:	5d                   	pop    %ebp
  80105d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80105e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801065:	83 ec 0c             	sub    $0xc,%esp
  801068:	25 07 0e 00 00       	and    $0xe07,%eax
  80106d:	50                   	push   %eax
  80106e:	57                   	push   %edi
  80106f:	6a 00                	push   $0x0
  801071:	53                   	push   %ebx
  801072:	6a 00                	push   $0x0
  801074:	e8 cf fa ff ff       	call   800b48 <sys_page_map>
  801079:	89 c3                	mov    %eax,%ebx
  80107b:	83 c4 20             	add    $0x20,%esp
  80107e:	85 c0                	test   %eax,%eax
  801080:	79 a3                	jns    801025 <dup+0x74>
	sys_page_unmap(0, newfd);
  801082:	83 ec 08             	sub    $0x8,%esp
  801085:	56                   	push   %esi
  801086:	6a 00                	push   $0x0
  801088:	e8 fd fa ff ff       	call   800b8a <sys_page_unmap>
	sys_page_unmap(0, nva);
  80108d:	83 c4 08             	add    $0x8,%esp
  801090:	57                   	push   %edi
  801091:	6a 00                	push   $0x0
  801093:	e8 f2 fa ff ff       	call   800b8a <sys_page_unmap>
	return r;
  801098:	83 c4 10             	add    $0x10,%esp
  80109b:	eb b7                	jmp    801054 <dup+0xa3>

0080109d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	53                   	push   %ebx
  8010a1:	83 ec 14             	sub    $0x14,%esp
  8010a4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010a7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010aa:	50                   	push   %eax
  8010ab:	53                   	push   %ebx
  8010ac:	e8 7f fd ff ff       	call   800e30 <fd_lookup>
  8010b1:	83 c4 08             	add    $0x8,%esp
  8010b4:	85 c0                	test   %eax,%eax
  8010b6:	78 3f                	js     8010f7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010b8:	83 ec 08             	sub    $0x8,%esp
  8010bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010be:	50                   	push   %eax
  8010bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010c2:	ff 30                	pushl  (%eax)
  8010c4:	e8 be fd ff ff       	call   800e87 <dev_lookup>
  8010c9:	83 c4 10             	add    $0x10,%esp
  8010cc:	85 c0                	test   %eax,%eax
  8010ce:	78 27                	js     8010f7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010d0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010d3:	8b 42 08             	mov    0x8(%edx),%eax
  8010d6:	83 e0 03             	and    $0x3,%eax
  8010d9:	83 f8 01             	cmp    $0x1,%eax
  8010dc:	74 1e                	je     8010fc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e1:	8b 40 08             	mov    0x8(%eax),%eax
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	74 35                	je     80111d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010e8:	83 ec 04             	sub    $0x4,%esp
  8010eb:	ff 75 10             	pushl  0x10(%ebp)
  8010ee:	ff 75 0c             	pushl  0xc(%ebp)
  8010f1:	52                   	push   %edx
  8010f2:	ff d0                	call   *%eax
  8010f4:	83 c4 10             	add    $0x10,%esp
}
  8010f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8010fc:	a1 04 40 80 00       	mov    0x804004,%eax
  801101:	8b 40 48             	mov    0x48(%eax),%eax
  801104:	83 ec 04             	sub    $0x4,%esp
  801107:	53                   	push   %ebx
  801108:	50                   	push   %eax
  801109:	68 8d 22 80 00       	push   $0x80228d
  80110e:	e8 35 f0 ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80111b:	eb da                	jmp    8010f7 <read+0x5a>
		return -E_NOT_SUPP;
  80111d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801122:	eb d3                	jmp    8010f7 <read+0x5a>

00801124 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801124:	55                   	push   %ebp
  801125:	89 e5                	mov    %esp,%ebp
  801127:	57                   	push   %edi
  801128:	56                   	push   %esi
  801129:	53                   	push   %ebx
  80112a:	83 ec 0c             	sub    $0xc,%esp
  80112d:	8b 7d 08             	mov    0x8(%ebp),%edi
  801130:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801133:	bb 00 00 00 00       	mov    $0x0,%ebx
  801138:	39 f3                	cmp    %esi,%ebx
  80113a:	73 25                	jae    801161 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80113c:	83 ec 04             	sub    $0x4,%esp
  80113f:	89 f0                	mov    %esi,%eax
  801141:	29 d8                	sub    %ebx,%eax
  801143:	50                   	push   %eax
  801144:	89 d8                	mov    %ebx,%eax
  801146:	03 45 0c             	add    0xc(%ebp),%eax
  801149:	50                   	push   %eax
  80114a:	57                   	push   %edi
  80114b:	e8 4d ff ff ff       	call   80109d <read>
		if (m < 0)
  801150:	83 c4 10             	add    $0x10,%esp
  801153:	85 c0                	test   %eax,%eax
  801155:	78 08                	js     80115f <readn+0x3b>
			return m;
		if (m == 0)
  801157:	85 c0                	test   %eax,%eax
  801159:	74 06                	je     801161 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80115b:	01 c3                	add    %eax,%ebx
  80115d:	eb d9                	jmp    801138 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80115f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801161:	89 d8                	mov    %ebx,%eax
  801163:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801166:	5b                   	pop    %ebx
  801167:	5e                   	pop    %esi
  801168:	5f                   	pop    %edi
  801169:	5d                   	pop    %ebp
  80116a:	c3                   	ret    

0080116b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80116b:	55                   	push   %ebp
  80116c:	89 e5                	mov    %esp,%ebp
  80116e:	53                   	push   %ebx
  80116f:	83 ec 14             	sub    $0x14,%esp
  801172:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801175:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801178:	50                   	push   %eax
  801179:	53                   	push   %ebx
  80117a:	e8 b1 fc ff ff       	call   800e30 <fd_lookup>
  80117f:	83 c4 08             	add    $0x8,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	78 3a                	js     8011c0 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801186:	83 ec 08             	sub    $0x8,%esp
  801189:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80118c:	50                   	push   %eax
  80118d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801190:	ff 30                	pushl  (%eax)
  801192:	e8 f0 fc ff ff       	call   800e87 <dev_lookup>
  801197:	83 c4 10             	add    $0x10,%esp
  80119a:	85 c0                	test   %eax,%eax
  80119c:	78 22                	js     8011c0 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80119e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011a5:	74 1e                	je     8011c5 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011aa:	8b 52 0c             	mov    0xc(%edx),%edx
  8011ad:	85 d2                	test   %edx,%edx
  8011af:	74 35                	je     8011e6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011b1:	83 ec 04             	sub    $0x4,%esp
  8011b4:	ff 75 10             	pushl  0x10(%ebp)
  8011b7:	ff 75 0c             	pushl  0xc(%ebp)
  8011ba:	50                   	push   %eax
  8011bb:	ff d2                	call   *%edx
  8011bd:	83 c4 10             	add    $0x10,%esp
}
  8011c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011c5:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ca:	8b 40 48             	mov    0x48(%eax),%eax
  8011cd:	83 ec 04             	sub    $0x4,%esp
  8011d0:	53                   	push   %ebx
  8011d1:	50                   	push   %eax
  8011d2:	68 a9 22 80 00       	push   $0x8022a9
  8011d7:	e8 6c ef ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011e4:	eb da                	jmp    8011c0 <write+0x55>
		return -E_NOT_SUPP;
  8011e6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011eb:	eb d3                	jmp    8011c0 <write+0x55>

008011ed <seek>:

int
seek(int fdnum, off_t offset)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011f3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8011f6:	50                   	push   %eax
  8011f7:	ff 75 08             	pushl  0x8(%ebp)
  8011fa:	e8 31 fc ff ff       	call   800e30 <fd_lookup>
  8011ff:	83 c4 08             	add    $0x8,%esp
  801202:	85 c0                	test   %eax,%eax
  801204:	78 0e                	js     801214 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8b 55 0c             	mov    0xc(%ebp),%edx
  80120c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	53                   	push   %ebx
  80121a:	83 ec 14             	sub    $0x14,%esp
  80121d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801220:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801223:	50                   	push   %eax
  801224:	53                   	push   %ebx
  801225:	e8 06 fc ff ff       	call   800e30 <fd_lookup>
  80122a:	83 c4 08             	add    $0x8,%esp
  80122d:	85 c0                	test   %eax,%eax
  80122f:	78 37                	js     801268 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801231:	83 ec 08             	sub    $0x8,%esp
  801234:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801237:	50                   	push   %eax
  801238:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123b:	ff 30                	pushl  (%eax)
  80123d:	e8 45 fc ff ff       	call   800e87 <dev_lookup>
  801242:	83 c4 10             	add    $0x10,%esp
  801245:	85 c0                	test   %eax,%eax
  801247:	78 1f                	js     801268 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801249:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801250:	74 1b                	je     80126d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801252:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801255:	8b 52 18             	mov    0x18(%edx),%edx
  801258:	85 d2                	test   %edx,%edx
  80125a:	74 32                	je     80128e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	ff 75 0c             	pushl  0xc(%ebp)
  801262:	50                   	push   %eax
  801263:	ff d2                	call   *%edx
  801265:	83 c4 10             	add    $0x10,%esp
}
  801268:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80126b:	c9                   	leave  
  80126c:	c3                   	ret    
			thisenv->env_id, fdnum);
  80126d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801272:	8b 40 48             	mov    0x48(%eax),%eax
  801275:	83 ec 04             	sub    $0x4,%esp
  801278:	53                   	push   %ebx
  801279:	50                   	push   %eax
  80127a:	68 6c 22 80 00       	push   $0x80226c
  80127f:	e8 c4 ee ff ff       	call   800148 <cprintf>
		return -E_INVAL;
  801284:	83 c4 10             	add    $0x10,%esp
  801287:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80128c:	eb da                	jmp    801268 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80128e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801293:	eb d3                	jmp    801268 <ftruncate+0x52>

00801295 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801295:	55                   	push   %ebp
  801296:	89 e5                	mov    %esp,%ebp
  801298:	53                   	push   %ebx
  801299:	83 ec 14             	sub    $0x14,%esp
  80129c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80129f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012a2:	50                   	push   %eax
  8012a3:	ff 75 08             	pushl  0x8(%ebp)
  8012a6:	e8 85 fb ff ff       	call   800e30 <fd_lookup>
  8012ab:	83 c4 08             	add    $0x8,%esp
  8012ae:	85 c0                	test   %eax,%eax
  8012b0:	78 4b                	js     8012fd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012b2:	83 ec 08             	sub    $0x8,%esp
  8012b5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012b8:	50                   	push   %eax
  8012b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012bc:	ff 30                	pushl  (%eax)
  8012be:	e8 c4 fb ff ff       	call   800e87 <dev_lookup>
  8012c3:	83 c4 10             	add    $0x10,%esp
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	78 33                	js     8012fd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cd:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012d1:	74 2f                	je     801302 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012d3:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012d6:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012dd:	00 00 00 
	stat->st_type = 0;
  8012e0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012e7:	00 00 00 
	stat->st_dev = dev;
  8012ea:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8012f0:	83 ec 08             	sub    $0x8,%esp
  8012f3:	53                   	push   %ebx
  8012f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8012f7:	ff 50 14             	call   *0x14(%eax)
  8012fa:	83 c4 10             	add    $0x10,%esp
}
  8012fd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801300:	c9                   	leave  
  801301:	c3                   	ret    
		return -E_NOT_SUPP;
  801302:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801307:	eb f4                	jmp    8012fd <fstat+0x68>

00801309 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	56                   	push   %esi
  80130d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80130e:	83 ec 08             	sub    $0x8,%esp
  801311:	6a 00                	push   $0x0
  801313:	ff 75 08             	pushl  0x8(%ebp)
  801316:	e8 34 02 00 00       	call   80154f <open>
  80131b:	89 c3                	mov    %eax,%ebx
  80131d:	83 c4 10             	add    $0x10,%esp
  801320:	85 c0                	test   %eax,%eax
  801322:	78 1b                	js     80133f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801324:	83 ec 08             	sub    $0x8,%esp
  801327:	ff 75 0c             	pushl  0xc(%ebp)
  80132a:	50                   	push   %eax
  80132b:	e8 65 ff ff ff       	call   801295 <fstat>
  801330:	89 c6                	mov    %eax,%esi
	close(fd);
  801332:	89 1c 24             	mov    %ebx,(%esp)
  801335:	e8 29 fc ff ff       	call   800f63 <close>
	return r;
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	89 f3                	mov    %esi,%ebx
}
  80133f:	89 d8                	mov    %ebx,%eax
  801341:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801344:	5b                   	pop    %ebx
  801345:	5e                   	pop    %esi
  801346:	5d                   	pop    %ebp
  801347:	c3                   	ret    

00801348 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801348:	55                   	push   %ebp
  801349:	89 e5                	mov    %esp,%ebp
  80134b:	56                   	push   %esi
  80134c:	53                   	push   %ebx
  80134d:	89 c6                	mov    %eax,%esi
  80134f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801351:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801358:	74 27                	je     801381 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80135a:	6a 07                	push   $0x7
  80135c:	68 00 50 80 00       	push   $0x805000
  801361:	56                   	push   %esi
  801362:	ff 35 00 40 80 00    	pushl  0x804000
  801368:	e8 60 08 00 00       	call   801bcd <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80136d:	83 c4 0c             	add    $0xc,%esp
  801370:	6a 00                	push   $0x0
  801372:	53                   	push   %ebx
  801373:	6a 00                	push   $0x0
  801375:	e8 ca 07 00 00       	call   801b44 <ipc_recv>
}
  80137a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80137d:	5b                   	pop    %ebx
  80137e:	5e                   	pop    %esi
  80137f:	5d                   	pop    %ebp
  801380:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801381:	83 ec 0c             	sub    $0xc,%esp
  801384:	6a 01                	push   $0x1
  801386:	e8 9e 08 00 00       	call   801c29 <ipc_find_env>
  80138b:	a3 00 40 80 00       	mov    %eax,0x804000
  801390:	83 c4 10             	add    $0x10,%esp
  801393:	eb c5                	jmp    80135a <fsipc+0x12>

00801395 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80139b:	8b 45 08             	mov    0x8(%ebp),%eax
  80139e:	8b 40 0c             	mov    0xc(%eax),%eax
  8013a1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013a9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8013b3:	b8 02 00 00 00       	mov    $0x2,%eax
  8013b8:	e8 8b ff ff ff       	call   801348 <fsipc>
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <devfile_flush>:
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013cb:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013d0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d5:	b8 06 00 00 00       	mov    $0x6,%eax
  8013da:	e8 69 ff ff ff       	call   801348 <fsipc>
}
  8013df:	c9                   	leave  
  8013e0:	c3                   	ret    

008013e1 <devfile_stat>:
{
  8013e1:	55                   	push   %ebp
  8013e2:	89 e5                	mov    %esp,%ebp
  8013e4:	53                   	push   %ebx
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8013f1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8013f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013fb:	b8 05 00 00 00       	mov    $0x5,%eax
  801400:	e8 43 ff ff ff       	call   801348 <fsipc>
  801405:	85 c0                	test   %eax,%eax
  801407:	78 2c                	js     801435 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	68 00 50 80 00       	push   $0x805000
  801411:	53                   	push   %ebx
  801412:	e8 39 f3 ff ff       	call   800750 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801417:	a1 80 50 80 00       	mov    0x805080,%eax
  80141c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801422:	a1 84 50 80 00       	mov    0x805084,%eax
  801427:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801435:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801438:	c9                   	leave  
  801439:	c3                   	ret    

0080143a <devfile_write>:
{
  80143a:	55                   	push   %ebp
  80143b:	89 e5                	mov    %esp,%ebp
  80143d:	53                   	push   %ebx
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801444:	89 d8                	mov    %ebx,%eax
  801446:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80144c:	76 05                	jbe    801453 <devfile_write+0x19>
  80144e:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801453:	8b 55 08             	mov    0x8(%ebp),%edx
  801456:	8b 52 0c             	mov    0xc(%edx),%edx
  801459:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80145f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801464:	83 ec 04             	sub    $0x4,%esp
  801467:	50                   	push   %eax
  801468:	ff 75 0c             	pushl  0xc(%ebp)
  80146b:	68 08 50 80 00       	push   $0x805008
  801470:	e8 4e f4 ff ff       	call   8008c3 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801475:	ba 00 00 00 00       	mov    $0x0,%edx
  80147a:	b8 04 00 00 00       	mov    $0x4,%eax
  80147f:	e8 c4 fe ff ff       	call   801348 <fsipc>
  801484:	83 c4 10             	add    $0x10,%esp
  801487:	85 c0                	test   %eax,%eax
  801489:	78 0b                	js     801496 <devfile_write+0x5c>
	assert(r <= n);
  80148b:	39 c3                	cmp    %eax,%ebx
  80148d:	72 0c                	jb     80149b <devfile_write+0x61>
	assert(r <= PGSIZE);
  80148f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801494:	7f 1e                	jg     8014b4 <devfile_write+0x7a>
}
  801496:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801499:	c9                   	leave  
  80149a:	c3                   	ret    
	assert(r <= n);
  80149b:	68 d8 22 80 00       	push   $0x8022d8
  8014a0:	68 df 22 80 00       	push   $0x8022df
  8014a5:	68 98 00 00 00       	push   $0x98
  8014aa:	68 f4 22 80 00       	push   $0x8022f4
  8014af:	e8 11 06 00 00       	call   801ac5 <_panic>
	assert(r <= PGSIZE);
  8014b4:	68 ff 22 80 00       	push   $0x8022ff
  8014b9:	68 df 22 80 00       	push   $0x8022df
  8014be:	68 99 00 00 00       	push   $0x99
  8014c3:	68 f4 22 80 00       	push   $0x8022f4
  8014c8:	e8 f8 05 00 00       	call   801ac5 <_panic>

008014cd <devfile_read>:
{
  8014cd:	55                   	push   %ebp
  8014ce:	89 e5                	mov    %esp,%ebp
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8014db:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014e0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8014eb:	b8 03 00 00 00       	mov    $0x3,%eax
  8014f0:	e8 53 fe ff ff       	call   801348 <fsipc>
  8014f5:	89 c3                	mov    %eax,%ebx
  8014f7:	85 c0                	test   %eax,%eax
  8014f9:	78 1f                	js     80151a <devfile_read+0x4d>
	assert(r <= n);
  8014fb:	39 c6                	cmp    %eax,%esi
  8014fd:	72 24                	jb     801523 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8014ff:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801504:	7f 33                	jg     801539 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801506:	83 ec 04             	sub    $0x4,%esp
  801509:	50                   	push   %eax
  80150a:	68 00 50 80 00       	push   $0x805000
  80150f:	ff 75 0c             	pushl  0xc(%ebp)
  801512:	e8 ac f3 ff ff       	call   8008c3 <memmove>
	return r;
  801517:	83 c4 10             	add    $0x10,%esp
}
  80151a:	89 d8                	mov    %ebx,%eax
  80151c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80151f:	5b                   	pop    %ebx
  801520:	5e                   	pop    %esi
  801521:	5d                   	pop    %ebp
  801522:	c3                   	ret    
	assert(r <= n);
  801523:	68 d8 22 80 00       	push   $0x8022d8
  801528:	68 df 22 80 00       	push   $0x8022df
  80152d:	6a 7c                	push   $0x7c
  80152f:	68 f4 22 80 00       	push   $0x8022f4
  801534:	e8 8c 05 00 00       	call   801ac5 <_panic>
	assert(r <= PGSIZE);
  801539:	68 ff 22 80 00       	push   $0x8022ff
  80153e:	68 df 22 80 00       	push   $0x8022df
  801543:	6a 7d                	push   $0x7d
  801545:	68 f4 22 80 00       	push   $0x8022f4
  80154a:	e8 76 05 00 00       	call   801ac5 <_panic>

0080154f <open>:
{
  80154f:	55                   	push   %ebp
  801550:	89 e5                	mov    %esp,%ebp
  801552:	56                   	push   %esi
  801553:	53                   	push   %ebx
  801554:	83 ec 1c             	sub    $0x1c,%esp
  801557:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80155a:	56                   	push   %esi
  80155b:	e8 bd f1 ff ff       	call   80071d <strlen>
  801560:	83 c4 10             	add    $0x10,%esp
  801563:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801568:	7f 6c                	jg     8015d6 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80156a:	83 ec 0c             	sub    $0xc,%esp
  80156d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801570:	50                   	push   %eax
  801571:	e8 6b f8 ff ff       	call   800de1 <fd_alloc>
  801576:	89 c3                	mov    %eax,%ebx
  801578:	83 c4 10             	add    $0x10,%esp
  80157b:	85 c0                	test   %eax,%eax
  80157d:	78 3c                	js     8015bb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80157f:	83 ec 08             	sub    $0x8,%esp
  801582:	56                   	push   %esi
  801583:	68 00 50 80 00       	push   $0x805000
  801588:	e8 c3 f1 ff ff       	call   800750 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80158d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801590:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801595:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801598:	b8 01 00 00 00       	mov    $0x1,%eax
  80159d:	e8 a6 fd ff ff       	call   801348 <fsipc>
  8015a2:	89 c3                	mov    %eax,%ebx
  8015a4:	83 c4 10             	add    $0x10,%esp
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	78 19                	js     8015c4 <open+0x75>
	return fd2num(fd);
  8015ab:	83 ec 0c             	sub    $0xc,%esp
  8015ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b1:	e8 04 f8 ff ff       	call   800dba <fd2num>
  8015b6:	89 c3                	mov    %eax,%ebx
  8015b8:	83 c4 10             	add    $0x10,%esp
}
  8015bb:	89 d8                	mov    %ebx,%eax
  8015bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015c0:	5b                   	pop    %ebx
  8015c1:	5e                   	pop    %esi
  8015c2:	5d                   	pop    %ebp
  8015c3:	c3                   	ret    
		fd_close(fd, 0);
  8015c4:	83 ec 08             	sub    $0x8,%esp
  8015c7:	6a 00                	push   $0x0
  8015c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cc:	e8 0c f9 ff ff       	call   800edd <fd_close>
		return r;
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	eb e5                	jmp    8015bb <open+0x6c>
		return -E_BAD_PATH;
  8015d6:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015db:	eb de                	jmp    8015bb <open+0x6c>

008015dd <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015e3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015e8:	b8 08 00 00 00       	mov    $0x8,%eax
  8015ed:	e8 56 fd ff ff       	call   801348 <fsipc>
}
  8015f2:	c9                   	leave  
  8015f3:	c3                   	ret    

008015f4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8015f4:	55                   	push   %ebp
  8015f5:	89 e5                	mov    %esp,%ebp
  8015f7:	56                   	push   %esi
  8015f8:	53                   	push   %ebx
  8015f9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8015fc:	83 ec 0c             	sub    $0xc,%esp
  8015ff:	ff 75 08             	pushl  0x8(%ebp)
  801602:	e8 c3 f7 ff ff       	call   800dca <fd2data>
  801607:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801609:	83 c4 08             	add    $0x8,%esp
  80160c:	68 0b 23 80 00       	push   $0x80230b
  801611:	53                   	push   %ebx
  801612:	e8 39 f1 ff ff       	call   800750 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801617:	8b 46 04             	mov    0x4(%esi),%eax
  80161a:	2b 06                	sub    (%esi),%eax
  80161c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801622:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801629:	10 00 00 
	stat->st_dev = &devpipe;
  80162c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801633:	30 80 00 
	return 0;
}
  801636:	b8 00 00 00 00       	mov    $0x0,%eax
  80163b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80163e:	5b                   	pop    %ebx
  80163f:	5e                   	pop    %esi
  801640:	5d                   	pop    %ebp
  801641:	c3                   	ret    

00801642 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801642:	55                   	push   %ebp
  801643:	89 e5                	mov    %esp,%ebp
  801645:	53                   	push   %ebx
  801646:	83 ec 0c             	sub    $0xc,%esp
  801649:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80164c:	53                   	push   %ebx
  80164d:	6a 00                	push   $0x0
  80164f:	e8 36 f5 ff ff       	call   800b8a <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801654:	89 1c 24             	mov    %ebx,(%esp)
  801657:	e8 6e f7 ff ff       	call   800dca <fd2data>
  80165c:	83 c4 08             	add    $0x8,%esp
  80165f:	50                   	push   %eax
  801660:	6a 00                	push   $0x0
  801662:	e8 23 f5 ff ff       	call   800b8a <sys_page_unmap>
}
  801667:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80166a:	c9                   	leave  
  80166b:	c3                   	ret    

0080166c <_pipeisclosed>:
{
  80166c:	55                   	push   %ebp
  80166d:	89 e5                	mov    %esp,%ebp
  80166f:	57                   	push   %edi
  801670:	56                   	push   %esi
  801671:	53                   	push   %ebx
  801672:	83 ec 1c             	sub    $0x1c,%esp
  801675:	89 c7                	mov    %eax,%edi
  801677:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801679:	a1 04 40 80 00       	mov    0x804004,%eax
  80167e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801681:	83 ec 0c             	sub    $0xc,%esp
  801684:	57                   	push   %edi
  801685:	e8 e1 05 00 00       	call   801c6b <pageref>
  80168a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80168d:	89 34 24             	mov    %esi,(%esp)
  801690:	e8 d6 05 00 00       	call   801c6b <pageref>
		nn = thisenv->env_runs;
  801695:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80169b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80169e:	83 c4 10             	add    $0x10,%esp
  8016a1:	39 cb                	cmp    %ecx,%ebx
  8016a3:	74 1b                	je     8016c0 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016a5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016a8:	75 cf                	jne    801679 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016aa:	8b 42 58             	mov    0x58(%edx),%eax
  8016ad:	6a 01                	push   $0x1
  8016af:	50                   	push   %eax
  8016b0:	53                   	push   %ebx
  8016b1:	68 12 23 80 00       	push   $0x802312
  8016b6:	e8 8d ea ff ff       	call   800148 <cprintf>
  8016bb:	83 c4 10             	add    $0x10,%esp
  8016be:	eb b9                	jmp    801679 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016c0:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016c3:	0f 94 c0             	sete   %al
  8016c6:	0f b6 c0             	movzbl %al,%eax
}
  8016c9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016cc:	5b                   	pop    %ebx
  8016cd:	5e                   	pop    %esi
  8016ce:	5f                   	pop    %edi
  8016cf:	5d                   	pop    %ebp
  8016d0:	c3                   	ret    

008016d1 <devpipe_write>:
{
  8016d1:	55                   	push   %ebp
  8016d2:	89 e5                	mov    %esp,%ebp
  8016d4:	57                   	push   %edi
  8016d5:	56                   	push   %esi
  8016d6:	53                   	push   %ebx
  8016d7:	83 ec 18             	sub    $0x18,%esp
  8016da:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016dd:	56                   	push   %esi
  8016de:	e8 e7 f6 ff ff       	call   800dca <fd2data>
  8016e3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016e5:	83 c4 10             	add    $0x10,%esp
  8016e8:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ed:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8016f0:	74 41                	je     801733 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8016f2:	8b 53 04             	mov    0x4(%ebx),%edx
  8016f5:	8b 03                	mov    (%ebx),%eax
  8016f7:	83 c0 20             	add    $0x20,%eax
  8016fa:	39 c2                	cmp    %eax,%edx
  8016fc:	72 14                	jb     801712 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8016fe:	89 da                	mov    %ebx,%edx
  801700:	89 f0                	mov    %esi,%eax
  801702:	e8 65 ff ff ff       	call   80166c <_pipeisclosed>
  801707:	85 c0                	test   %eax,%eax
  801709:	75 2c                	jne    801737 <devpipe_write+0x66>
			sys_yield();
  80170b:	e8 bc f4 ff ff       	call   800bcc <sys_yield>
  801710:	eb e0                	jmp    8016f2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801712:	8b 45 0c             	mov    0xc(%ebp),%eax
  801715:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801718:	89 d0                	mov    %edx,%eax
  80171a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80171f:	78 0b                	js     80172c <devpipe_write+0x5b>
  801721:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801725:	42                   	inc    %edx
  801726:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801729:	47                   	inc    %edi
  80172a:	eb c1                	jmp    8016ed <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80172c:	48                   	dec    %eax
  80172d:	83 c8 e0             	or     $0xffffffe0,%eax
  801730:	40                   	inc    %eax
  801731:	eb ee                	jmp    801721 <devpipe_write+0x50>
	return i;
  801733:	89 f8                	mov    %edi,%eax
  801735:	eb 05                	jmp    80173c <devpipe_write+0x6b>
				return 0;
  801737:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80173c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80173f:	5b                   	pop    %ebx
  801740:	5e                   	pop    %esi
  801741:	5f                   	pop    %edi
  801742:	5d                   	pop    %ebp
  801743:	c3                   	ret    

00801744 <devpipe_read>:
{
  801744:	55                   	push   %ebp
  801745:	89 e5                	mov    %esp,%ebp
  801747:	57                   	push   %edi
  801748:	56                   	push   %esi
  801749:	53                   	push   %ebx
  80174a:	83 ec 18             	sub    $0x18,%esp
  80174d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801750:	57                   	push   %edi
  801751:	e8 74 f6 ff ff       	call   800dca <fd2data>
  801756:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801760:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801763:	74 46                	je     8017ab <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801765:	8b 06                	mov    (%esi),%eax
  801767:	3b 46 04             	cmp    0x4(%esi),%eax
  80176a:	75 22                	jne    80178e <devpipe_read+0x4a>
			if (i > 0)
  80176c:	85 db                	test   %ebx,%ebx
  80176e:	74 0a                	je     80177a <devpipe_read+0x36>
				return i;
  801770:	89 d8                	mov    %ebx,%eax
}
  801772:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801775:	5b                   	pop    %ebx
  801776:	5e                   	pop    %esi
  801777:	5f                   	pop    %edi
  801778:	5d                   	pop    %ebp
  801779:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  80177a:	89 f2                	mov    %esi,%edx
  80177c:	89 f8                	mov    %edi,%eax
  80177e:	e8 e9 fe ff ff       	call   80166c <_pipeisclosed>
  801783:	85 c0                	test   %eax,%eax
  801785:	75 28                	jne    8017af <devpipe_read+0x6b>
			sys_yield();
  801787:	e8 40 f4 ff ff       	call   800bcc <sys_yield>
  80178c:	eb d7                	jmp    801765 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80178e:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801793:	78 0f                	js     8017a4 <devpipe_read+0x60>
  801795:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801799:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80179c:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80179f:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8017a1:	43                   	inc    %ebx
  8017a2:	eb bc                	jmp    801760 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017a4:	48                   	dec    %eax
  8017a5:	83 c8 e0             	or     $0xffffffe0,%eax
  8017a8:	40                   	inc    %eax
  8017a9:	eb ea                	jmp    801795 <devpipe_read+0x51>
	return i;
  8017ab:	89 d8                	mov    %ebx,%eax
  8017ad:	eb c3                	jmp    801772 <devpipe_read+0x2e>
				return 0;
  8017af:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b4:	eb bc                	jmp    801772 <devpipe_read+0x2e>

008017b6 <pipe>:
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	56                   	push   %esi
  8017ba:	53                   	push   %ebx
  8017bb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017be:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017c1:	50                   	push   %eax
  8017c2:	e8 1a f6 ff ff       	call   800de1 <fd_alloc>
  8017c7:	89 c3                	mov    %eax,%ebx
  8017c9:	83 c4 10             	add    $0x10,%esp
  8017cc:	85 c0                	test   %eax,%eax
  8017ce:	0f 88 2a 01 00 00    	js     8018fe <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017d4:	83 ec 04             	sub    $0x4,%esp
  8017d7:	68 07 04 00 00       	push   $0x407
  8017dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8017df:	6a 00                	push   $0x0
  8017e1:	e8 1f f3 ff ff       	call   800b05 <sys_page_alloc>
  8017e6:	89 c3                	mov    %eax,%ebx
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	85 c0                	test   %eax,%eax
  8017ed:	0f 88 0b 01 00 00    	js     8018fe <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8017f3:	83 ec 0c             	sub    $0xc,%esp
  8017f6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8017f9:	50                   	push   %eax
  8017fa:	e8 e2 f5 ff ff       	call   800de1 <fd_alloc>
  8017ff:	89 c3                	mov    %eax,%ebx
  801801:	83 c4 10             	add    $0x10,%esp
  801804:	85 c0                	test   %eax,%eax
  801806:	0f 88 e2 00 00 00    	js     8018ee <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	68 07 04 00 00       	push   $0x407
  801814:	ff 75 f0             	pushl  -0x10(%ebp)
  801817:	6a 00                	push   $0x0
  801819:	e8 e7 f2 ff ff       	call   800b05 <sys_page_alloc>
  80181e:	89 c3                	mov    %eax,%ebx
  801820:	83 c4 10             	add    $0x10,%esp
  801823:	85 c0                	test   %eax,%eax
  801825:	0f 88 c3 00 00 00    	js     8018ee <pipe+0x138>
	va = fd2data(fd0);
  80182b:	83 ec 0c             	sub    $0xc,%esp
  80182e:	ff 75 f4             	pushl  -0xc(%ebp)
  801831:	e8 94 f5 ff ff       	call   800dca <fd2data>
  801836:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801838:	83 c4 0c             	add    $0xc,%esp
  80183b:	68 07 04 00 00       	push   $0x407
  801840:	50                   	push   %eax
  801841:	6a 00                	push   $0x0
  801843:	e8 bd f2 ff ff       	call   800b05 <sys_page_alloc>
  801848:	89 c3                	mov    %eax,%ebx
  80184a:	83 c4 10             	add    $0x10,%esp
  80184d:	85 c0                	test   %eax,%eax
  80184f:	0f 88 89 00 00 00    	js     8018de <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801855:	83 ec 0c             	sub    $0xc,%esp
  801858:	ff 75 f0             	pushl  -0x10(%ebp)
  80185b:	e8 6a f5 ff ff       	call   800dca <fd2data>
  801860:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801867:	50                   	push   %eax
  801868:	6a 00                	push   $0x0
  80186a:	56                   	push   %esi
  80186b:	6a 00                	push   $0x0
  80186d:	e8 d6 f2 ff ff       	call   800b48 <sys_page_map>
  801872:	89 c3                	mov    %eax,%ebx
  801874:	83 c4 20             	add    $0x20,%esp
  801877:	85 c0                	test   %eax,%eax
  801879:	78 55                	js     8018d0 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80187b:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801881:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801884:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801886:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801889:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801890:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801899:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80189b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80189e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018a5:	83 ec 0c             	sub    $0xc,%esp
  8018a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018ab:	e8 0a f5 ff ff       	call   800dba <fd2num>
  8018b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018b3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018b5:	83 c4 04             	add    $0x4,%esp
  8018b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8018bb:	e8 fa f4 ff ff       	call   800dba <fd2num>
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018c6:	83 c4 10             	add    $0x10,%esp
  8018c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018ce:	eb 2e                	jmp    8018fe <pipe+0x148>
	sys_page_unmap(0, va);
  8018d0:	83 ec 08             	sub    $0x8,%esp
  8018d3:	56                   	push   %esi
  8018d4:	6a 00                	push   $0x0
  8018d6:	e8 af f2 ff ff       	call   800b8a <sys_page_unmap>
  8018db:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e4:	6a 00                	push   $0x0
  8018e6:	e8 9f f2 ff ff       	call   800b8a <sys_page_unmap>
  8018eb:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8018ee:	83 ec 08             	sub    $0x8,%esp
  8018f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8018f4:	6a 00                	push   $0x0
  8018f6:	e8 8f f2 ff ff       	call   800b8a <sys_page_unmap>
  8018fb:	83 c4 10             	add    $0x10,%esp
}
  8018fe:	89 d8                	mov    %ebx,%eax
  801900:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801903:	5b                   	pop    %ebx
  801904:	5e                   	pop    %esi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <pipeisclosed>:
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80190d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801910:	50                   	push   %eax
  801911:	ff 75 08             	pushl  0x8(%ebp)
  801914:	e8 17 f5 ff ff       	call   800e30 <fd_lookup>
  801919:	83 c4 10             	add    $0x10,%esp
  80191c:	85 c0                	test   %eax,%eax
  80191e:	78 18                	js     801938 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801920:	83 ec 0c             	sub    $0xc,%esp
  801923:	ff 75 f4             	pushl  -0xc(%ebp)
  801926:	e8 9f f4 ff ff       	call   800dca <fd2data>
	return _pipeisclosed(fd, p);
  80192b:	89 c2                	mov    %eax,%edx
  80192d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801930:	e8 37 fd ff ff       	call   80166c <_pipeisclosed>
  801935:	83 c4 10             	add    $0x10,%esp
}
  801938:	c9                   	leave  
  801939:	c3                   	ret    

0080193a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80193d:	b8 00 00 00 00       	mov    $0x0,%eax
  801942:	5d                   	pop    %ebp
  801943:	c3                   	ret    

00801944 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801944:	55                   	push   %ebp
  801945:	89 e5                	mov    %esp,%ebp
  801947:	53                   	push   %ebx
  801948:	83 ec 0c             	sub    $0xc,%esp
  80194b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80194e:	68 2a 23 80 00       	push   $0x80232a
  801953:	53                   	push   %ebx
  801954:	e8 f7 ed ff ff       	call   800750 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801959:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801960:	20 00 00 
	return 0;
}
  801963:	b8 00 00 00 00       	mov    $0x0,%eax
  801968:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80196b:	c9                   	leave  
  80196c:	c3                   	ret    

0080196d <devcons_write>:
{
  80196d:	55                   	push   %ebp
  80196e:	89 e5                	mov    %esp,%ebp
  801970:	57                   	push   %edi
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801979:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80197e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801984:	eb 1d                	jmp    8019a3 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801986:	83 ec 04             	sub    $0x4,%esp
  801989:	53                   	push   %ebx
  80198a:	03 45 0c             	add    0xc(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	57                   	push   %edi
  80198f:	e8 2f ef ff ff       	call   8008c3 <memmove>
		sys_cputs(buf, m);
  801994:	83 c4 08             	add    $0x8,%esp
  801997:	53                   	push   %ebx
  801998:	57                   	push   %edi
  801999:	e8 ca f0 ff ff       	call   800a68 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80199e:	01 de                	add    %ebx,%esi
  8019a0:	83 c4 10             	add    $0x10,%esp
  8019a3:	89 f0                	mov    %esi,%eax
  8019a5:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019a8:	73 11                	jae    8019bb <devcons_write+0x4e>
		m = n - tot;
  8019aa:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019ad:	29 f3                	sub    %esi,%ebx
  8019af:	83 fb 7f             	cmp    $0x7f,%ebx
  8019b2:	76 d2                	jbe    801986 <devcons_write+0x19>
  8019b4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8019b9:	eb cb                	jmp    801986 <devcons_write+0x19>
}
  8019bb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019be:	5b                   	pop    %ebx
  8019bf:	5e                   	pop    %esi
  8019c0:	5f                   	pop    %edi
  8019c1:	5d                   	pop    %ebp
  8019c2:	c3                   	ret    

008019c3 <devcons_read>:
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
  8019c6:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8019c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019cd:	75 0c                	jne    8019db <devcons_read+0x18>
		return 0;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019d4:	eb 21                	jmp    8019f7 <devcons_read+0x34>
		sys_yield();
  8019d6:	e8 f1 f1 ff ff       	call   800bcc <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019db:	e8 a6 f0 ff ff       	call   800a86 <sys_cgetc>
  8019e0:	85 c0                	test   %eax,%eax
  8019e2:	74 f2                	je     8019d6 <devcons_read+0x13>
	if (c < 0)
  8019e4:	85 c0                	test   %eax,%eax
  8019e6:	78 0f                	js     8019f7 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8019e8:	83 f8 04             	cmp    $0x4,%eax
  8019eb:	74 0c                	je     8019f9 <devcons_read+0x36>
	*(char*)vbuf = c;
  8019ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f0:	88 02                	mov    %al,(%edx)
	return 1;
  8019f2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    
		return 0;
  8019f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8019fe:	eb f7                	jmp    8019f7 <devcons_read+0x34>

00801a00 <cputchar>:
{
  801a00:	55                   	push   %ebp
  801a01:	89 e5                	mov    %esp,%ebp
  801a03:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a06:	8b 45 08             	mov    0x8(%ebp),%eax
  801a09:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a0c:	6a 01                	push   $0x1
  801a0e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a11:	50                   	push   %eax
  801a12:	e8 51 f0 ff ff       	call   800a68 <sys_cputs>
}
  801a17:	83 c4 10             	add    $0x10,%esp
  801a1a:	c9                   	leave  
  801a1b:	c3                   	ret    

00801a1c <getchar>:
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
  801a1f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a22:	6a 01                	push   $0x1
  801a24:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a27:	50                   	push   %eax
  801a28:	6a 00                	push   $0x0
  801a2a:	e8 6e f6 ff ff       	call   80109d <read>
	if (r < 0)
  801a2f:	83 c4 10             	add    $0x10,%esp
  801a32:	85 c0                	test   %eax,%eax
  801a34:	78 08                	js     801a3e <getchar+0x22>
	if (r < 1)
  801a36:	85 c0                	test   %eax,%eax
  801a38:	7e 06                	jle    801a40 <getchar+0x24>
	return c;
  801a3a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    
		return -E_EOF;
  801a40:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a45:	eb f7                	jmp    801a3e <getchar+0x22>

00801a47 <iscons>:
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a50:	50                   	push   %eax
  801a51:	ff 75 08             	pushl  0x8(%ebp)
  801a54:	e8 d7 f3 ff ff       	call   800e30 <fd_lookup>
  801a59:	83 c4 10             	add    $0x10,%esp
  801a5c:	85 c0                	test   %eax,%eax
  801a5e:	78 11                	js     801a71 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a63:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a69:	39 10                	cmp    %edx,(%eax)
  801a6b:	0f 94 c0             	sete   %al
  801a6e:	0f b6 c0             	movzbl %al,%eax
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <opencons>:
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
  801a76:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a79:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a7c:	50                   	push   %eax
  801a7d:	e8 5f f3 ff ff       	call   800de1 <fd_alloc>
  801a82:	83 c4 10             	add    $0x10,%esp
  801a85:	85 c0                	test   %eax,%eax
  801a87:	78 3a                	js     801ac3 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a89:	83 ec 04             	sub    $0x4,%esp
  801a8c:	68 07 04 00 00       	push   $0x407
  801a91:	ff 75 f4             	pushl  -0xc(%ebp)
  801a94:	6a 00                	push   $0x0
  801a96:	e8 6a f0 ff ff       	call   800b05 <sys_page_alloc>
  801a9b:	83 c4 10             	add    $0x10,%esp
  801a9e:	85 c0                	test   %eax,%eax
  801aa0:	78 21                	js     801ac3 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801aa2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801aab:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ab0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ab7:	83 ec 0c             	sub    $0xc,%esp
  801aba:	50                   	push   %eax
  801abb:	e8 fa f2 ff ff       	call   800dba <fd2num>
  801ac0:	83 c4 10             	add    $0x10,%esp
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	57                   	push   %edi
  801ac9:	56                   	push   %esi
  801aca:	53                   	push   %ebx
  801acb:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801ad1:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801ad4:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801ada:	e8 07 f0 ff ff       	call   800ae6 <sys_getenvid>
  801adf:	83 ec 04             	sub    $0x4,%esp
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	53                   	push   %ebx
  801ae9:	50                   	push   %eax
  801aea:	68 38 23 80 00       	push   $0x802338
  801aef:	68 00 01 00 00       	push   $0x100
  801af4:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801afa:	56                   	push   %esi
  801afb:	e8 03 ec ff ff       	call   800703 <snprintf>
  801b00:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801b02:	83 c4 20             	add    $0x20,%esp
  801b05:	57                   	push   %edi
  801b06:	ff 75 10             	pushl  0x10(%ebp)
  801b09:	bf 00 01 00 00       	mov    $0x100,%edi
  801b0e:	89 f8                	mov    %edi,%eax
  801b10:	29 d8                	sub    %ebx,%eax
  801b12:	50                   	push   %eax
  801b13:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 92 eb ff ff       	call   8006ae <vsnprintf>
  801b1c:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b1e:	83 c4 0c             	add    $0xc,%esp
  801b21:	68 1c 1f 80 00       	push   $0x801f1c
  801b26:	29 df                	sub    %ebx,%edi
  801b28:	57                   	push   %edi
  801b29:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b2c:	50                   	push   %eax
  801b2d:	e8 d1 eb ff ff       	call   800703 <snprintf>
	sys_cputs(buf, r);
  801b32:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b35:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801b37:	53                   	push   %ebx
  801b38:	56                   	push   %esi
  801b39:	e8 2a ef ff ff       	call   800a68 <sys_cputs>
  801b3e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b41:	cc                   	int3   
  801b42:	eb fd                	jmp    801b41 <_panic+0x7c>

00801b44 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b44:	55                   	push   %ebp
  801b45:	89 e5                	mov    %esp,%ebp
  801b47:	57                   	push   %edi
  801b48:	56                   	push   %esi
  801b49:	53                   	push   %ebx
  801b4a:	83 ec 0c             	sub    $0xc,%esp
  801b4d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b50:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b53:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b56:	85 ff                	test   %edi,%edi
  801b58:	74 53                	je     801bad <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	57                   	push   %edi
  801b5e:	e8 b2 f1 ff ff       	call   800d15 <sys_ipc_recv>
  801b63:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b66:	85 db                	test   %ebx,%ebx
  801b68:	74 0b                	je     801b75 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b6a:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b70:	8b 52 74             	mov    0x74(%edx),%edx
  801b73:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b75:	85 f6                	test   %esi,%esi
  801b77:	74 0f                	je     801b88 <ipc_recv+0x44>
  801b79:	85 ff                	test   %edi,%edi
  801b7b:	74 0b                	je     801b88 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b7d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b83:	8b 52 78             	mov    0x78(%edx),%edx
  801b86:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b88:	85 c0                	test   %eax,%eax
  801b8a:	74 30                	je     801bbc <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b8c:	85 db                	test   %ebx,%ebx
  801b8e:	74 06                	je     801b96 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b90:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b96:	85 f6                	test   %esi,%esi
  801b98:	74 2c                	je     801bc6 <ipc_recv+0x82>
      		*perm_store = 0;
  801b9a:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801ba0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801ba5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba8:	5b                   	pop    %ebx
  801ba9:	5e                   	pop    %esi
  801baa:	5f                   	pop    %edi
  801bab:	5d                   	pop    %ebp
  801bac:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bad:	83 ec 0c             	sub    $0xc,%esp
  801bb0:	6a ff                	push   $0xffffffff
  801bb2:	e8 5e f1 ff ff       	call   800d15 <sys_ipc_recv>
  801bb7:	83 c4 10             	add    $0x10,%esp
  801bba:	eb aa                	jmp    801b66 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bbc:	a1 04 40 80 00       	mov    0x804004,%eax
  801bc1:	8b 40 70             	mov    0x70(%eax),%eax
  801bc4:	eb df                	jmp    801ba5 <ipc_recv+0x61>
		return -1;
  801bc6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bcb:	eb d8                	jmp    801ba5 <ipc_recv+0x61>

00801bcd <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bcd:	55                   	push   %ebp
  801bce:	89 e5                	mov    %esp,%ebp
  801bd0:	57                   	push   %edi
  801bd1:	56                   	push   %esi
  801bd2:	53                   	push   %ebx
  801bd3:	83 ec 0c             	sub    $0xc,%esp
  801bd6:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bdc:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bdf:	85 db                	test   %ebx,%ebx
  801be1:	75 22                	jne    801c05 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801be3:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801be8:	eb 1b                	jmp    801c05 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bea:	68 5c 23 80 00       	push   $0x80235c
  801bef:	68 df 22 80 00       	push   $0x8022df
  801bf4:	6a 48                	push   $0x48
  801bf6:	68 80 23 80 00       	push   $0x802380
  801bfb:	e8 c5 fe ff ff       	call   801ac5 <_panic>
		sys_yield();
  801c00:	e8 c7 ef ff ff       	call   800bcc <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c05:	57                   	push   %edi
  801c06:	53                   	push   %ebx
  801c07:	56                   	push   %esi
  801c08:	ff 75 08             	pushl  0x8(%ebp)
  801c0b:	e8 e2 f0 ff ff       	call   800cf2 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c10:	83 c4 10             	add    $0x10,%esp
  801c13:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c16:	74 e8                	je     801c00 <ipc_send+0x33>
  801c18:	85 c0                	test   %eax,%eax
  801c1a:	75 ce                	jne    801bea <ipc_send+0x1d>
		sys_yield();
  801c1c:	e8 ab ef ff ff       	call   800bcc <sys_yield>
		
	}
	
}
  801c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c24:	5b                   	pop    %ebx
  801c25:	5e                   	pop    %esi
  801c26:	5f                   	pop    %edi
  801c27:	5d                   	pop    %ebp
  801c28:	c3                   	ret    

00801c29 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
  801c2c:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2f:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c34:	89 c2                	mov    %eax,%edx
  801c36:	c1 e2 05             	shl    $0x5,%edx
  801c39:	29 c2                	sub    %eax,%edx
  801c3b:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c42:	8b 52 50             	mov    0x50(%edx),%edx
  801c45:	39 ca                	cmp    %ecx,%edx
  801c47:	74 0f                	je     801c58 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c49:	40                   	inc    %eax
  801c4a:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c4f:	75 e3                	jne    801c34 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c51:	b8 00 00 00 00       	mov    $0x0,%eax
  801c56:	eb 11                	jmp    801c69 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c58:	89 c2                	mov    %eax,%edx
  801c5a:	c1 e2 05             	shl    $0x5,%edx
  801c5d:	29 c2                	sub    %eax,%edx
  801c5f:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c66:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c69:	5d                   	pop    %ebp
  801c6a:	c3                   	ret    

00801c6b <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	c1 e8 16             	shr    $0x16,%eax
  801c74:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c7b:	a8 01                	test   $0x1,%al
  801c7d:	74 21                	je     801ca0 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c82:	c1 e8 0c             	shr    $0xc,%eax
  801c85:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c8c:	a8 01                	test   $0x1,%al
  801c8e:	74 17                	je     801ca7 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c90:	c1 e8 0c             	shr    $0xc,%eax
  801c93:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c9a:	ef 
  801c9b:	0f b7 c0             	movzwl %ax,%eax
  801c9e:	eb 05                	jmp    801ca5 <pageref+0x3a>
		return 0;
  801ca0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca5:	5d                   	pop    %ebp
  801ca6:	c3                   	ret    
		return 0;
  801ca7:	b8 00 00 00 00       	mov    $0x0,%eax
  801cac:	eb f7                	jmp    801ca5 <pageref+0x3a>
  801cae:	66 90                	xchg   %ax,%ax

00801cb0 <__udivdi3>:
  801cb0:	55                   	push   %ebp
  801cb1:	57                   	push   %edi
  801cb2:	56                   	push   %esi
  801cb3:	53                   	push   %ebx
  801cb4:	83 ec 1c             	sub    $0x1c,%esp
  801cb7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cbb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cc3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc7:	89 ca                	mov    %ecx,%edx
  801cc9:	89 f8                	mov    %edi,%eax
  801ccb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ccf:	85 f6                	test   %esi,%esi
  801cd1:	75 2d                	jne    801d00 <__udivdi3+0x50>
  801cd3:	39 cf                	cmp    %ecx,%edi
  801cd5:	77 65                	ja     801d3c <__udivdi3+0x8c>
  801cd7:	89 fd                	mov    %edi,%ebp
  801cd9:	85 ff                	test   %edi,%edi
  801cdb:	75 0b                	jne    801ce8 <__udivdi3+0x38>
  801cdd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ce2:	31 d2                	xor    %edx,%edx
  801ce4:	f7 f7                	div    %edi
  801ce6:	89 c5                	mov    %eax,%ebp
  801ce8:	31 d2                	xor    %edx,%edx
  801cea:	89 c8                	mov    %ecx,%eax
  801cec:	f7 f5                	div    %ebp
  801cee:	89 c1                	mov    %eax,%ecx
  801cf0:	89 d8                	mov    %ebx,%eax
  801cf2:	f7 f5                	div    %ebp
  801cf4:	89 cf                	mov    %ecx,%edi
  801cf6:	89 fa                	mov    %edi,%edx
  801cf8:	83 c4 1c             	add    $0x1c,%esp
  801cfb:	5b                   	pop    %ebx
  801cfc:	5e                   	pop    %esi
  801cfd:	5f                   	pop    %edi
  801cfe:	5d                   	pop    %ebp
  801cff:	c3                   	ret    
  801d00:	39 ce                	cmp    %ecx,%esi
  801d02:	77 28                	ja     801d2c <__udivdi3+0x7c>
  801d04:	0f bd fe             	bsr    %esi,%edi
  801d07:	83 f7 1f             	xor    $0x1f,%edi
  801d0a:	75 40                	jne    801d4c <__udivdi3+0x9c>
  801d0c:	39 ce                	cmp    %ecx,%esi
  801d0e:	72 0a                	jb     801d1a <__udivdi3+0x6a>
  801d10:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d14:	0f 87 9e 00 00 00    	ja     801db8 <__udivdi3+0x108>
  801d1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1f:	89 fa                	mov    %edi,%edx
  801d21:	83 c4 1c             	add    $0x1c,%esp
  801d24:	5b                   	pop    %ebx
  801d25:	5e                   	pop    %esi
  801d26:	5f                   	pop    %edi
  801d27:	5d                   	pop    %ebp
  801d28:	c3                   	ret    
  801d29:	8d 76 00             	lea    0x0(%esi),%esi
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	31 c0                	xor    %eax,%eax
  801d30:	89 fa                	mov    %edi,%edx
  801d32:	83 c4 1c             	add    $0x1c,%esp
  801d35:	5b                   	pop    %ebx
  801d36:	5e                   	pop    %esi
  801d37:	5f                   	pop    %edi
  801d38:	5d                   	pop    %ebp
  801d39:	c3                   	ret    
  801d3a:	66 90                	xchg   %ax,%ax
  801d3c:	89 d8                	mov    %ebx,%eax
  801d3e:	f7 f7                	div    %edi
  801d40:	31 ff                	xor    %edi,%edi
  801d42:	89 fa                	mov    %edi,%edx
  801d44:	83 c4 1c             	add    $0x1c,%esp
  801d47:	5b                   	pop    %ebx
  801d48:	5e                   	pop    %esi
  801d49:	5f                   	pop    %edi
  801d4a:	5d                   	pop    %ebp
  801d4b:	c3                   	ret    
  801d4c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d51:	29 fd                	sub    %edi,%ebp
  801d53:	89 f9                	mov    %edi,%ecx
  801d55:	d3 e6                	shl    %cl,%esi
  801d57:	89 c3                	mov    %eax,%ebx
  801d59:	89 e9                	mov    %ebp,%ecx
  801d5b:	d3 eb                	shr    %cl,%ebx
  801d5d:	89 d9                	mov    %ebx,%ecx
  801d5f:	09 f1                	or     %esi,%ecx
  801d61:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d65:	89 f9                	mov    %edi,%ecx
  801d67:	d3 e0                	shl    %cl,%eax
  801d69:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d6d:	89 d6                	mov    %edx,%esi
  801d6f:	89 e9                	mov    %ebp,%ecx
  801d71:	d3 ee                	shr    %cl,%esi
  801d73:	89 f9                	mov    %edi,%ecx
  801d75:	d3 e2                	shl    %cl,%edx
  801d77:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d7b:	89 e9                	mov    %ebp,%ecx
  801d7d:	d3 eb                	shr    %cl,%ebx
  801d7f:	09 da                	or     %ebx,%edx
  801d81:	89 d0                	mov    %edx,%eax
  801d83:	89 f2                	mov    %esi,%edx
  801d85:	f7 74 24 08          	divl   0x8(%esp)
  801d89:	89 d6                	mov    %edx,%esi
  801d8b:	89 c3                	mov    %eax,%ebx
  801d8d:	f7 64 24 0c          	mull   0xc(%esp)
  801d91:	39 d6                	cmp    %edx,%esi
  801d93:	72 17                	jb     801dac <__udivdi3+0xfc>
  801d95:	74 09                	je     801da0 <__udivdi3+0xf0>
  801d97:	89 d8                	mov    %ebx,%eax
  801d99:	31 ff                	xor    %edi,%edi
  801d9b:	e9 56 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801da0:	8b 54 24 04          	mov    0x4(%esp),%edx
  801da4:	89 f9                	mov    %edi,%ecx
  801da6:	d3 e2                	shl    %cl,%edx
  801da8:	39 c2                	cmp    %eax,%edx
  801daa:	73 eb                	jae    801d97 <__udivdi3+0xe7>
  801dac:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801daf:	31 ff                	xor    %edi,%edi
  801db1:	e9 40 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801db6:	66 90                	xchg   %ax,%ax
  801db8:	31 c0                	xor    %eax,%eax
  801dba:	e9 37 ff ff ff       	jmp    801cf6 <__udivdi3+0x46>
  801dbf:	90                   	nop

00801dc0 <__umoddi3>:
  801dc0:	55                   	push   %ebp
  801dc1:	57                   	push   %edi
  801dc2:	56                   	push   %esi
  801dc3:	53                   	push   %ebx
  801dc4:	83 ec 1c             	sub    $0x1c,%esp
  801dc7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dcb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dcf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dd3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dd7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ddb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ddf:	89 3c 24             	mov    %edi,(%esp)
  801de2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de6:	89 f2                	mov    %esi,%edx
  801de8:	85 c0                	test   %eax,%eax
  801dea:	75 18                	jne    801e04 <__umoddi3+0x44>
  801dec:	39 f7                	cmp    %esi,%edi
  801dee:	0f 86 a0 00 00 00    	jbe    801e94 <__umoddi3+0xd4>
  801df4:	89 c8                	mov    %ecx,%eax
  801df6:	f7 f7                	div    %edi
  801df8:	89 d0                	mov    %edx,%eax
  801dfa:	31 d2                	xor    %edx,%edx
  801dfc:	83 c4 1c             	add    $0x1c,%esp
  801dff:	5b                   	pop    %ebx
  801e00:	5e                   	pop    %esi
  801e01:	5f                   	pop    %edi
  801e02:	5d                   	pop    %ebp
  801e03:	c3                   	ret    
  801e04:	89 f3                	mov    %esi,%ebx
  801e06:	39 f0                	cmp    %esi,%eax
  801e08:	0f 87 a6 00 00 00    	ja     801eb4 <__umoddi3+0xf4>
  801e0e:	0f bd e8             	bsr    %eax,%ebp
  801e11:	83 f5 1f             	xor    $0x1f,%ebp
  801e14:	0f 84 a6 00 00 00    	je     801ec0 <__umoddi3+0x100>
  801e1a:	bf 20 00 00 00       	mov    $0x20,%edi
  801e1f:	29 ef                	sub    %ebp,%edi
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e0                	shl    %cl,%eax
  801e25:	8b 34 24             	mov    (%esp),%esi
  801e28:	89 f2                	mov    %esi,%edx
  801e2a:	89 f9                	mov    %edi,%ecx
  801e2c:	d3 ea                	shr    %cl,%edx
  801e2e:	09 c2                	or     %eax,%edx
  801e30:	89 14 24             	mov    %edx,(%esp)
  801e33:	89 f2                	mov    %esi,%edx
  801e35:	89 e9                	mov    %ebp,%ecx
  801e37:	d3 e2                	shl    %cl,%edx
  801e39:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e3d:	89 de                	mov    %ebx,%esi
  801e3f:	89 f9                	mov    %edi,%ecx
  801e41:	d3 ee                	shr    %cl,%esi
  801e43:	89 e9                	mov    %ebp,%ecx
  801e45:	d3 e3                	shl    %cl,%ebx
  801e47:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e4b:	89 d0                	mov    %edx,%eax
  801e4d:	89 f9                	mov    %edi,%ecx
  801e4f:	d3 e8                	shr    %cl,%eax
  801e51:	09 d8                	or     %ebx,%eax
  801e53:	89 d3                	mov    %edx,%ebx
  801e55:	89 e9                	mov    %ebp,%ecx
  801e57:	d3 e3                	shl    %cl,%ebx
  801e59:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e5d:	89 f2                	mov    %esi,%edx
  801e5f:	f7 34 24             	divl   (%esp)
  801e62:	89 d6                	mov    %edx,%esi
  801e64:	f7 64 24 04          	mull   0x4(%esp)
  801e68:	89 c3                	mov    %eax,%ebx
  801e6a:	89 d1                	mov    %edx,%ecx
  801e6c:	39 d6                	cmp    %edx,%esi
  801e6e:	72 7c                	jb     801eec <__umoddi3+0x12c>
  801e70:	74 72                	je     801ee4 <__umoddi3+0x124>
  801e72:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e76:	29 da                	sub    %ebx,%edx
  801e78:	19 ce                	sbb    %ecx,%esi
  801e7a:	89 f0                	mov    %esi,%eax
  801e7c:	89 f9                	mov    %edi,%ecx
  801e7e:	d3 e0                	shl    %cl,%eax
  801e80:	89 e9                	mov    %ebp,%ecx
  801e82:	d3 ea                	shr    %cl,%edx
  801e84:	09 d0                	or     %edx,%eax
  801e86:	89 e9                	mov    %ebp,%ecx
  801e88:	d3 ee                	shr    %cl,%esi
  801e8a:	89 f2                	mov    %esi,%edx
  801e8c:	83 c4 1c             	add    $0x1c,%esp
  801e8f:	5b                   	pop    %ebx
  801e90:	5e                   	pop    %esi
  801e91:	5f                   	pop    %edi
  801e92:	5d                   	pop    %ebp
  801e93:	c3                   	ret    
  801e94:	89 fd                	mov    %edi,%ebp
  801e96:	85 ff                	test   %edi,%edi
  801e98:	75 0b                	jne    801ea5 <__umoddi3+0xe5>
  801e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9f:	31 d2                	xor    %edx,%edx
  801ea1:	f7 f7                	div    %edi
  801ea3:	89 c5                	mov    %eax,%ebp
  801ea5:	89 f0                	mov    %esi,%eax
  801ea7:	31 d2                	xor    %edx,%edx
  801ea9:	f7 f5                	div    %ebp
  801eab:	89 c8                	mov    %ecx,%eax
  801ead:	f7 f5                	div    %ebp
  801eaf:	e9 44 ff ff ff       	jmp    801df8 <__umoddi3+0x38>
  801eb4:	89 c8                	mov    %ecx,%eax
  801eb6:	89 f2                	mov    %esi,%edx
  801eb8:	83 c4 1c             	add    $0x1c,%esp
  801ebb:	5b                   	pop    %ebx
  801ebc:	5e                   	pop    %esi
  801ebd:	5f                   	pop    %edi
  801ebe:	5d                   	pop    %ebp
  801ebf:	c3                   	ret    
  801ec0:	39 f0                	cmp    %esi,%eax
  801ec2:	72 05                	jb     801ec9 <__umoddi3+0x109>
  801ec4:	39 0c 24             	cmp    %ecx,(%esp)
  801ec7:	77 0c                	ja     801ed5 <__umoddi3+0x115>
  801ec9:	89 f2                	mov    %esi,%edx
  801ecb:	29 f9                	sub    %edi,%ecx
  801ecd:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ed1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed5:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed9:	83 c4 1c             	add    $0x1c,%esp
  801edc:	5b                   	pop    %ebx
  801edd:	5e                   	pop    %esi
  801ede:	5f                   	pop    %edi
  801edf:	5d                   	pop    %ebp
  801ee0:	c3                   	ret    
  801ee1:	8d 76 00             	lea    0x0(%esi),%esi
  801ee4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ee8:	73 88                	jae    801e72 <__umoddi3+0xb2>
  801eea:	66 90                	xchg   %ax,%ax
  801eec:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ef0:	1b 14 24             	sbb    (%esp),%edx
  801ef3:	89 d1                	mov    %edx,%ecx
  801ef5:	89 c3                	mov    %eax,%ebx
  801ef7:	e9 76 ff ff ff       	jmp    801e72 <__umoddi3+0xb2>
