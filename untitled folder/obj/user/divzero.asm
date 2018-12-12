
obj/user/divzero.debug:     file format elf32-i386


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
  80002c:	e8 2f 00 00 00       	call   800060 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

int zero;

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	zero = 0;
  800039:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  800040:	00 00 00 
	cprintf("1/0 is %08x!\n", 1/zero);
  800043:	b8 01 00 00 00       	mov    $0x1,%eax
  800048:	b9 00 00 00 00       	mov    $0x0,%ecx
  80004d:	99                   	cltd   
  80004e:	f7 f9                	idiv   %ecx
  800050:	50                   	push   %eax
  800051:	68 20 1f 80 00       	push   $0x801f20
  800056:	e8 ff 00 00 00       	call   80015a <cprintf>
}
  80005b:	83 c4 10             	add    $0x10,%esp
  80005e:	c9                   	leave  
  80005f:	c3                   	ret    

00800060 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800060:	55                   	push   %ebp
  800061:	89 e5                	mov    %esp,%ebp
  800063:	56                   	push   %esi
  800064:	53                   	push   %ebx
  800065:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800068:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80006b:	e8 88 0a 00 00       	call   800af8 <sys_getenvid>
  800070:	25 ff 03 00 00       	and    $0x3ff,%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	c1 e2 05             	shl    $0x5,%edx
  80007a:	29 c2                	sub    %eax,%edx
  80007c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800083:	a3 08 40 80 00       	mov    %eax,0x804008

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800088:	85 db                	test   %ebx,%ebx
  80008a:	7e 07                	jle    800093 <libmain+0x33>
		binaryname = argv[0];
  80008c:	8b 06                	mov    (%esi),%eax
  80008e:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	56                   	push   %esi
  800097:	53                   	push   %ebx
  800098:	e8 96 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80009d:	e8 0a 00 00 00       	call   8000ac <exit>
}
  8000a2:	83 c4 10             	add    $0x10,%esp
  8000a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000a8:	5b                   	pop    %ebx
  8000a9:	5e                   	pop    %esi
  8000aa:	5d                   	pop    %ebp
  8000ab:	c3                   	ret    

008000ac <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000ac:	55                   	push   %ebp
  8000ad:	89 e5                	mov    %esp,%ebp
  8000af:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b2:	e8 e9 0e 00 00       	call   800fa0 <close_all>
	sys_env_destroy(0);
  8000b7:	83 ec 0c             	sub    $0xc,%esp
  8000ba:	6a 00                	push   $0x0
  8000bc:	e8 f6 09 00 00       	call   800ab7 <sys_env_destroy>
}
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	c9                   	leave  
  8000c5:	c3                   	ret    

008000c6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	53                   	push   %ebx
  8000ca:	83 ec 04             	sub    $0x4,%esp
  8000cd:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000d0:	8b 13                	mov    (%ebx),%edx
  8000d2:	8d 42 01             	lea    0x1(%edx),%eax
  8000d5:	89 03                	mov    %eax,(%ebx)
  8000d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000da:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000de:	3d ff 00 00 00       	cmp    $0xff,%eax
  8000e3:	74 08                	je     8000ed <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8000e5:	ff 43 04             	incl   0x4(%ebx)
}
  8000e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8000eb:	c9                   	leave  
  8000ec:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8000ed:	83 ec 08             	sub    $0x8,%esp
  8000f0:	68 ff 00 00 00       	push   $0xff
  8000f5:	8d 43 08             	lea    0x8(%ebx),%eax
  8000f8:	50                   	push   %eax
  8000f9:	e8 7c 09 00 00       	call   800a7a <sys_cputs>
		b->idx = 0;
  8000fe:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800104:	83 c4 10             	add    $0x10,%esp
  800107:	eb dc                	jmp    8000e5 <putch+0x1f>

00800109 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800109:	55                   	push   %ebp
  80010a:	89 e5                	mov    %esp,%ebp
  80010c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800112:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800119:	00 00 00 
	b.cnt = 0;
  80011c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800123:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800126:	ff 75 0c             	pushl  0xc(%ebp)
  800129:	ff 75 08             	pushl  0x8(%ebp)
  80012c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800132:	50                   	push   %eax
  800133:	68 c6 00 80 00       	push   $0x8000c6
  800138:	e8 17 01 00 00       	call   800254 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80013d:	83 c4 08             	add    $0x8,%esp
  800140:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800146:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80014c:	50                   	push   %eax
  80014d:	e8 28 09 00 00       	call   800a7a <sys_cputs>

	return b.cnt;
}
  800152:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800158:	c9                   	leave  
  800159:	c3                   	ret    

0080015a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80015a:	55                   	push   %ebp
  80015b:	89 e5                	mov    %esp,%ebp
  80015d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800160:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800163:	50                   	push   %eax
  800164:	ff 75 08             	pushl  0x8(%ebp)
  800167:	e8 9d ff ff ff       	call   800109 <vcprintf>
	va_end(ap);

	return cnt;
}
  80016c:	c9                   	leave  
  80016d:	c3                   	ret    

0080016e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80016e:	55                   	push   %ebp
  80016f:	89 e5                	mov    %esp,%ebp
  800171:	57                   	push   %edi
  800172:	56                   	push   %esi
  800173:	53                   	push   %ebx
  800174:	83 ec 1c             	sub    $0x1c,%esp
  800177:	89 c7                	mov    %eax,%edi
  800179:	89 d6                	mov    %edx,%esi
  80017b:	8b 45 08             	mov    0x8(%ebp),%eax
  80017e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800181:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800184:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800187:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80018a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80018f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800192:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800195:	39 d3                	cmp    %edx,%ebx
  800197:	72 05                	jb     80019e <printnum+0x30>
  800199:	39 45 10             	cmp    %eax,0x10(%ebp)
  80019c:	77 78                	ja     800216 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80019e:	83 ec 0c             	sub    $0xc,%esp
  8001a1:	ff 75 18             	pushl  0x18(%ebp)
  8001a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8001a7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001aa:	53                   	push   %ebx
  8001ab:	ff 75 10             	pushl  0x10(%ebp)
  8001ae:	83 ec 08             	sub    $0x8,%esp
  8001b1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001b4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001b7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001ba:	ff 75 d8             	pushl  -0x28(%ebp)
  8001bd:	e8 fe 1a 00 00       	call   801cc0 <__udivdi3>
  8001c2:	83 c4 18             	add    $0x18,%esp
  8001c5:	52                   	push   %edx
  8001c6:	50                   	push   %eax
  8001c7:	89 f2                	mov    %esi,%edx
  8001c9:	89 f8                	mov    %edi,%eax
  8001cb:	e8 9e ff ff ff       	call   80016e <printnum>
  8001d0:	83 c4 20             	add    $0x20,%esp
  8001d3:	eb 11                	jmp    8001e6 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001d5:	83 ec 08             	sub    $0x8,%esp
  8001d8:	56                   	push   %esi
  8001d9:	ff 75 18             	pushl  0x18(%ebp)
  8001dc:	ff d7                	call   *%edi
  8001de:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8001e1:	4b                   	dec    %ebx
  8001e2:	85 db                	test   %ebx,%ebx
  8001e4:	7f ef                	jg     8001d5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8001e6:	83 ec 08             	sub    $0x8,%esp
  8001e9:	56                   	push   %esi
  8001ea:	83 ec 04             	sub    $0x4,%esp
  8001ed:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001f0:	ff 75 e0             	pushl  -0x20(%ebp)
  8001f3:	ff 75 dc             	pushl  -0x24(%ebp)
  8001f6:	ff 75 d8             	pushl  -0x28(%ebp)
  8001f9:	e8 d2 1b 00 00       	call   801dd0 <__umoddi3>
  8001fe:	83 c4 14             	add    $0x14,%esp
  800201:	0f be 80 38 1f 80 00 	movsbl 0x801f38(%eax),%eax
  800208:	50                   	push   %eax
  800209:	ff d7                	call   *%edi
}
  80020b:	83 c4 10             	add    $0x10,%esp
  80020e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800211:	5b                   	pop    %ebx
  800212:	5e                   	pop    %esi
  800213:	5f                   	pop    %edi
  800214:	5d                   	pop    %ebp
  800215:	c3                   	ret    
  800216:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800219:	eb c6                	jmp    8001e1 <printnum+0x73>

0080021b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80021b:	55                   	push   %ebp
  80021c:	89 e5                	mov    %esp,%ebp
  80021e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800221:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800224:	8b 10                	mov    (%eax),%edx
  800226:	3b 50 04             	cmp    0x4(%eax),%edx
  800229:	73 0a                	jae    800235 <sprintputch+0x1a>
		*b->buf++ = ch;
  80022b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80022e:	89 08                	mov    %ecx,(%eax)
  800230:	8b 45 08             	mov    0x8(%ebp),%eax
  800233:	88 02                	mov    %al,(%edx)
}
  800235:	5d                   	pop    %ebp
  800236:	c3                   	ret    

00800237 <printfmt>:
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80023d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800240:	50                   	push   %eax
  800241:	ff 75 10             	pushl  0x10(%ebp)
  800244:	ff 75 0c             	pushl  0xc(%ebp)
  800247:	ff 75 08             	pushl  0x8(%ebp)
  80024a:	e8 05 00 00 00       	call   800254 <vprintfmt>
}
  80024f:	83 c4 10             	add    $0x10,%esp
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <vprintfmt>:
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	57                   	push   %edi
  800258:	56                   	push   %esi
  800259:	53                   	push   %ebx
  80025a:	83 ec 2c             	sub    $0x2c,%esp
  80025d:	8b 75 08             	mov    0x8(%ebp),%esi
  800260:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800263:	8b 7d 10             	mov    0x10(%ebp),%edi
  800266:	e9 ae 03 00 00       	jmp    800619 <vprintfmt+0x3c5>
  80026b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80026f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800276:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80027d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800284:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800289:	8d 47 01             	lea    0x1(%edi),%eax
  80028c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80028f:	8a 17                	mov    (%edi),%dl
  800291:	8d 42 dd             	lea    -0x23(%edx),%eax
  800294:	3c 55                	cmp    $0x55,%al
  800296:	0f 87 fe 03 00 00    	ja     80069a <vprintfmt+0x446>
  80029c:	0f b6 c0             	movzbl %al,%eax
  80029f:	ff 24 85 80 20 80 00 	jmp    *0x802080(,%eax,4)
  8002a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002a9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002ad:	eb da                	jmp    800289 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002b2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002b6:	eb d1                	jmp    800289 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002b8:	0f b6 d2             	movzbl %dl,%edx
  8002bb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002be:	b8 00 00 00 00       	mov    $0x0,%eax
  8002c3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002c6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002c9:	01 c0                	add    %eax,%eax
  8002cb:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8002cf:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002d2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002d5:	83 f9 09             	cmp    $0x9,%ecx
  8002d8:	77 52                	ja     80032c <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8002da:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8002db:	eb e9                	jmp    8002c6 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8002dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e0:	8b 00                	mov    (%eax),%eax
  8002e2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8002e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8002e8:	8d 40 04             	lea    0x4(%eax),%eax
  8002eb:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8002ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8002f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8002f5:	79 92                	jns    800289 <vprintfmt+0x35>
				width = precision, precision = -1;
  8002f7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8002fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8002fd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800304:	eb 83                	jmp    800289 <vprintfmt+0x35>
  800306:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80030a:	78 08                	js     800314 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80030f:	e9 75 ff ff ff       	jmp    800289 <vprintfmt+0x35>
  800314:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80031b:	eb ef                	jmp    80030c <vprintfmt+0xb8>
  80031d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800320:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800327:	e9 5d ff ff ff       	jmp    800289 <vprintfmt+0x35>
  80032c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80032f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800332:	eb bd                	jmp    8002f1 <vprintfmt+0x9d>
			lflag++;
  800334:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800335:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800338:	e9 4c ff ff ff       	jmp    800289 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80033d:	8b 45 14             	mov    0x14(%ebp),%eax
  800340:	8d 78 04             	lea    0x4(%eax),%edi
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	53                   	push   %ebx
  800347:	ff 30                	pushl  (%eax)
  800349:	ff d6                	call   *%esi
			break;
  80034b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80034e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800351:	e9 c0 02 00 00       	jmp    800616 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800356:	8b 45 14             	mov    0x14(%ebp),%eax
  800359:	8d 78 04             	lea    0x4(%eax),%edi
  80035c:	8b 00                	mov    (%eax),%eax
  80035e:	85 c0                	test   %eax,%eax
  800360:	78 2a                	js     80038c <vprintfmt+0x138>
  800362:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800364:	83 f8 0f             	cmp    $0xf,%eax
  800367:	7f 27                	jg     800390 <vprintfmt+0x13c>
  800369:	8b 04 85 e0 21 80 00 	mov    0x8021e0(,%eax,4),%eax
  800370:	85 c0                	test   %eax,%eax
  800372:	74 1c                	je     800390 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800374:	50                   	push   %eax
  800375:	68 11 23 80 00       	push   $0x802311
  80037a:	53                   	push   %ebx
  80037b:	56                   	push   %esi
  80037c:	e8 b6 fe ff ff       	call   800237 <printfmt>
  800381:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800384:	89 7d 14             	mov    %edi,0x14(%ebp)
  800387:	e9 8a 02 00 00       	jmp    800616 <vprintfmt+0x3c2>
  80038c:	f7 d8                	neg    %eax
  80038e:	eb d2                	jmp    800362 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800390:	52                   	push   %edx
  800391:	68 50 1f 80 00       	push   $0x801f50
  800396:	53                   	push   %ebx
  800397:	56                   	push   %esi
  800398:	e8 9a fe ff ff       	call   800237 <printfmt>
  80039d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003a3:	e9 6e 02 00 00       	jmp    800616 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003ab:	83 c0 04             	add    $0x4,%eax
  8003ae:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b4:	8b 38                	mov    (%eax),%edi
  8003b6:	85 ff                	test   %edi,%edi
  8003b8:	74 39                	je     8003f3 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003ba:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003be:	0f 8e a9 00 00 00    	jle    80046d <vprintfmt+0x219>
  8003c4:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003c8:	0f 84 a7 00 00 00    	je     800475 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d4:	57                   	push   %edi
  8003d5:	e8 6b 03 00 00       	call   800745 <strnlen>
  8003da:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003dd:	29 c1                	sub    %eax,%ecx
  8003df:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8003e2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8003e5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8003e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ec:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8003ef:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8003f1:	eb 14                	jmp    800407 <vprintfmt+0x1b3>
				p = "(null)";
  8003f3:	bf 49 1f 80 00       	mov    $0x801f49,%edi
  8003f8:	eb c0                	jmp    8003ba <vprintfmt+0x166>
					putch(padc, putdat);
  8003fa:	83 ec 08             	sub    $0x8,%esp
  8003fd:	53                   	push   %ebx
  8003fe:	ff 75 e0             	pushl  -0x20(%ebp)
  800401:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800403:	4f                   	dec    %edi
  800404:	83 c4 10             	add    $0x10,%esp
  800407:	85 ff                	test   %edi,%edi
  800409:	7f ef                	jg     8003fa <vprintfmt+0x1a6>
  80040b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80040e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800411:	89 c8                	mov    %ecx,%eax
  800413:	85 c9                	test   %ecx,%ecx
  800415:	78 10                	js     800427 <vprintfmt+0x1d3>
  800417:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80041a:	29 c1                	sub    %eax,%ecx
  80041c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80041f:	89 75 08             	mov    %esi,0x8(%ebp)
  800422:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800425:	eb 15                	jmp    80043c <vprintfmt+0x1e8>
  800427:	b8 00 00 00 00       	mov    $0x0,%eax
  80042c:	eb e9                	jmp    800417 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80042e:	83 ec 08             	sub    $0x8,%esp
  800431:	53                   	push   %ebx
  800432:	52                   	push   %edx
  800433:	ff 55 08             	call   *0x8(%ebp)
  800436:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800439:	ff 4d e0             	decl   -0x20(%ebp)
  80043c:	47                   	inc    %edi
  80043d:	8a 47 ff             	mov    -0x1(%edi),%al
  800440:	0f be d0             	movsbl %al,%edx
  800443:	85 d2                	test   %edx,%edx
  800445:	74 59                	je     8004a0 <vprintfmt+0x24c>
  800447:	85 f6                	test   %esi,%esi
  800449:	78 03                	js     80044e <vprintfmt+0x1fa>
  80044b:	4e                   	dec    %esi
  80044c:	78 2f                	js     80047d <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80044e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800452:	74 da                	je     80042e <vprintfmt+0x1da>
  800454:	0f be c0             	movsbl %al,%eax
  800457:	83 e8 20             	sub    $0x20,%eax
  80045a:	83 f8 5e             	cmp    $0x5e,%eax
  80045d:	76 cf                	jbe    80042e <vprintfmt+0x1da>
					putch('?', putdat);
  80045f:	83 ec 08             	sub    $0x8,%esp
  800462:	53                   	push   %ebx
  800463:	6a 3f                	push   $0x3f
  800465:	ff 55 08             	call   *0x8(%ebp)
  800468:	83 c4 10             	add    $0x10,%esp
  80046b:	eb cc                	jmp    800439 <vprintfmt+0x1e5>
  80046d:	89 75 08             	mov    %esi,0x8(%ebp)
  800470:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800473:	eb c7                	jmp    80043c <vprintfmt+0x1e8>
  800475:	89 75 08             	mov    %esi,0x8(%ebp)
  800478:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80047b:	eb bf                	jmp    80043c <vprintfmt+0x1e8>
  80047d:	8b 75 08             	mov    0x8(%ebp),%esi
  800480:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800483:	eb 0c                	jmp    800491 <vprintfmt+0x23d>
				putch(' ', putdat);
  800485:	83 ec 08             	sub    $0x8,%esp
  800488:	53                   	push   %ebx
  800489:	6a 20                	push   $0x20
  80048b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80048d:	4f                   	dec    %edi
  80048e:	83 c4 10             	add    $0x10,%esp
  800491:	85 ff                	test   %edi,%edi
  800493:	7f f0                	jg     800485 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800495:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800498:	89 45 14             	mov    %eax,0x14(%ebp)
  80049b:	e9 76 01 00 00       	jmp    800616 <vprintfmt+0x3c2>
  8004a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a6:	eb e9                	jmp    800491 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004a8:	83 f9 01             	cmp    $0x1,%ecx
  8004ab:	7f 1f                	jg     8004cc <vprintfmt+0x278>
	else if (lflag)
  8004ad:	85 c9                	test   %ecx,%ecx
  8004af:	75 48                	jne    8004f9 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004b4:	8b 00                	mov    (%eax),%eax
  8004b6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004b9:	89 c1                	mov    %eax,%ecx
  8004bb:	c1 f9 1f             	sar    $0x1f,%ecx
  8004be:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004c1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c4:	8d 40 04             	lea    0x4(%eax),%eax
  8004c7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ca:	eb 17                	jmp    8004e3 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8004cc:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cf:	8b 50 04             	mov    0x4(%eax),%edx
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004da:	8b 45 14             	mov    0x14(%ebp),%eax
  8004dd:	8d 40 08             	lea    0x8(%eax),%eax
  8004e0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8004e3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8004e6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8004e9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8004ed:	78 25                	js     800514 <vprintfmt+0x2c0>
			base = 10;
  8004ef:	b8 0a 00 00 00       	mov    $0xa,%eax
  8004f4:	e9 03 01 00 00       	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8004f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fc:	8b 00                	mov    (%eax),%eax
  8004fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800501:	89 c1                	mov    %eax,%ecx
  800503:	c1 f9 1f             	sar    $0x1f,%ecx
  800506:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800509:	8b 45 14             	mov    0x14(%ebp),%eax
  80050c:	8d 40 04             	lea    0x4(%eax),%eax
  80050f:	89 45 14             	mov    %eax,0x14(%ebp)
  800512:	eb cf                	jmp    8004e3 <vprintfmt+0x28f>
				putch('-', putdat);
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	53                   	push   %ebx
  800518:	6a 2d                	push   $0x2d
  80051a:	ff d6                	call   *%esi
				num = -(long long) num;
  80051c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80051f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800522:	f7 da                	neg    %edx
  800524:	83 d1 00             	adc    $0x0,%ecx
  800527:	f7 d9                	neg    %ecx
  800529:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80052c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800531:	e9 c6 00 00 00       	jmp    8005fc <vprintfmt+0x3a8>
	if (lflag >= 2)
  800536:	83 f9 01             	cmp    $0x1,%ecx
  800539:	7f 1e                	jg     800559 <vprintfmt+0x305>
	else if (lflag)
  80053b:	85 c9                	test   %ecx,%ecx
  80053d:	75 32                	jne    800571 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80053f:	8b 45 14             	mov    0x14(%ebp),%eax
  800542:	8b 10                	mov    (%eax),%edx
  800544:	b9 00 00 00 00       	mov    $0x0,%ecx
  800549:	8d 40 04             	lea    0x4(%eax),%eax
  80054c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80054f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800554:	e9 a3 00 00 00       	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800559:	8b 45 14             	mov    0x14(%ebp),%eax
  80055c:	8b 10                	mov    (%eax),%edx
  80055e:	8b 48 04             	mov    0x4(%eax),%ecx
  800561:	8d 40 08             	lea    0x8(%eax),%eax
  800564:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800567:	b8 0a 00 00 00       	mov    $0xa,%eax
  80056c:	e9 8b 00 00 00       	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800571:	8b 45 14             	mov    0x14(%ebp),%eax
  800574:	8b 10                	mov    (%eax),%edx
  800576:	b9 00 00 00 00       	mov    $0x0,%ecx
  80057b:	8d 40 04             	lea    0x4(%eax),%eax
  80057e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800581:	b8 0a 00 00 00       	mov    $0xa,%eax
  800586:	eb 74                	jmp    8005fc <vprintfmt+0x3a8>
	if (lflag >= 2)
  800588:	83 f9 01             	cmp    $0x1,%ecx
  80058b:	7f 1b                	jg     8005a8 <vprintfmt+0x354>
	else if (lflag)
  80058d:	85 c9                	test   %ecx,%ecx
  80058f:	75 2c                	jne    8005bd <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8005a6:	eb 54                	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ab:	8b 10                	mov    (%eax),%edx
  8005ad:	8b 48 04             	mov    0x4(%eax),%ecx
  8005b0:	8d 40 08             	lea    0x8(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005b6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005bb:	eb 3f                	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c0:	8b 10                	mov    (%eax),%edx
  8005c2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005c7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ca:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005cd:	b8 08 00 00 00       	mov    $0x8,%eax
  8005d2:	eb 28                	jmp    8005fc <vprintfmt+0x3a8>
			putch('0', putdat);
  8005d4:	83 ec 08             	sub    $0x8,%esp
  8005d7:	53                   	push   %ebx
  8005d8:	6a 30                	push   $0x30
  8005da:	ff d6                	call   *%esi
			putch('x', putdat);
  8005dc:	83 c4 08             	add    $0x8,%esp
  8005df:	53                   	push   %ebx
  8005e0:	6a 78                	push   $0x78
  8005e2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8005e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e7:	8b 10                	mov    (%eax),%edx
  8005e9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8005ee:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8005f1:	8d 40 04             	lea    0x4(%eax),%eax
  8005f4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8005f7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8005fc:	83 ec 0c             	sub    $0xc,%esp
  8005ff:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800603:	57                   	push   %edi
  800604:	ff 75 e0             	pushl  -0x20(%ebp)
  800607:	50                   	push   %eax
  800608:	51                   	push   %ecx
  800609:	52                   	push   %edx
  80060a:	89 da                	mov    %ebx,%edx
  80060c:	89 f0                	mov    %esi,%eax
  80060e:	e8 5b fb ff ff       	call   80016e <printnum>
			break;
  800613:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800616:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800619:	47                   	inc    %edi
  80061a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80061e:	83 f8 25             	cmp    $0x25,%eax
  800621:	0f 84 44 fc ff ff    	je     80026b <vprintfmt+0x17>
			if (ch == '\0')
  800627:	85 c0                	test   %eax,%eax
  800629:	0f 84 89 00 00 00    	je     8006b8 <vprintfmt+0x464>
			putch(ch, putdat);
  80062f:	83 ec 08             	sub    $0x8,%esp
  800632:	53                   	push   %ebx
  800633:	50                   	push   %eax
  800634:	ff d6                	call   *%esi
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	eb de                	jmp    800619 <vprintfmt+0x3c5>
	if (lflag >= 2)
  80063b:	83 f9 01             	cmp    $0x1,%ecx
  80063e:	7f 1b                	jg     80065b <vprintfmt+0x407>
	else if (lflag)
  800640:	85 c9                	test   %ecx,%ecx
  800642:	75 2c                	jne    800670 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	8b 10                	mov    (%eax),%edx
  800649:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064e:	8d 40 04             	lea    0x4(%eax),%eax
  800651:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800654:	b8 10 00 00 00       	mov    $0x10,%eax
  800659:	eb a1                	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80065b:	8b 45 14             	mov    0x14(%ebp),%eax
  80065e:	8b 10                	mov    (%eax),%edx
  800660:	8b 48 04             	mov    0x4(%eax),%ecx
  800663:	8d 40 08             	lea    0x8(%eax),%eax
  800666:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800669:	b8 10 00 00 00       	mov    $0x10,%eax
  80066e:	eb 8c                	jmp    8005fc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800670:	8b 45 14             	mov    0x14(%ebp),%eax
  800673:	8b 10                	mov    (%eax),%edx
  800675:	b9 00 00 00 00       	mov    $0x0,%ecx
  80067a:	8d 40 04             	lea    0x4(%eax),%eax
  80067d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800680:	b8 10 00 00 00       	mov    $0x10,%eax
  800685:	e9 72 ff ff ff       	jmp    8005fc <vprintfmt+0x3a8>
			putch(ch, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	53                   	push   %ebx
  80068e:	6a 25                	push   $0x25
  800690:	ff d6                	call   *%esi
			break;
  800692:	83 c4 10             	add    $0x10,%esp
  800695:	e9 7c ff ff ff       	jmp    800616 <vprintfmt+0x3c2>
			putch('%', putdat);
  80069a:	83 ec 08             	sub    $0x8,%esp
  80069d:	53                   	push   %ebx
  80069e:	6a 25                	push   $0x25
  8006a0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006a2:	83 c4 10             	add    $0x10,%esp
  8006a5:	89 f8                	mov    %edi,%eax
  8006a7:	eb 01                	jmp    8006aa <vprintfmt+0x456>
  8006a9:	48                   	dec    %eax
  8006aa:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ae:	75 f9                	jne    8006a9 <vprintfmt+0x455>
  8006b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006b3:	e9 5e ff ff ff       	jmp    800616 <vprintfmt+0x3c2>
}
  8006b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bb:	5b                   	pop    %ebx
  8006bc:	5e                   	pop    %esi
  8006bd:	5f                   	pop    %edi
  8006be:	5d                   	pop    %ebp
  8006bf:	c3                   	ret    

008006c0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006c0:	55                   	push   %ebp
  8006c1:	89 e5                	mov    %esp,%ebp
  8006c3:	83 ec 18             	sub    $0x18,%esp
  8006c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006cf:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006d3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006dd:	85 c0                	test   %eax,%eax
  8006df:	74 26                	je     800707 <vsnprintf+0x47>
  8006e1:	85 d2                	test   %edx,%edx
  8006e3:	7e 29                	jle    80070e <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8006e5:	ff 75 14             	pushl  0x14(%ebp)
  8006e8:	ff 75 10             	pushl  0x10(%ebp)
  8006eb:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8006ee:	50                   	push   %eax
  8006ef:	68 1b 02 80 00       	push   $0x80021b
  8006f4:	e8 5b fb ff ff       	call   800254 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8006f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8006fc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800702:	83 c4 10             	add    $0x10,%esp
}
  800705:	c9                   	leave  
  800706:	c3                   	ret    
		return -E_INVAL;
  800707:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80070c:	eb f7                	jmp    800705 <vsnprintf+0x45>
  80070e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800713:	eb f0                	jmp    800705 <vsnprintf+0x45>

00800715 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800715:	55                   	push   %ebp
  800716:	89 e5                	mov    %esp,%ebp
  800718:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80071b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80071e:	50                   	push   %eax
  80071f:	ff 75 10             	pushl  0x10(%ebp)
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	ff 75 08             	pushl  0x8(%ebp)
  800728:	e8 93 ff ff ff       	call   8006c0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80072d:	c9                   	leave  
  80072e:	c3                   	ret    

0080072f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80072f:	55                   	push   %ebp
  800730:	89 e5                	mov    %esp,%ebp
  800732:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800735:	b8 00 00 00 00       	mov    $0x0,%eax
  80073a:	eb 01                	jmp    80073d <strlen+0xe>
		n++;
  80073c:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80073d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800741:	75 f9                	jne    80073c <strlen+0xd>
	return n;
}
  800743:	5d                   	pop    %ebp
  800744:	c3                   	ret    

00800745 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800745:	55                   	push   %ebp
  800746:	89 e5                	mov    %esp,%ebp
  800748:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80074b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80074e:	b8 00 00 00 00       	mov    $0x0,%eax
  800753:	eb 01                	jmp    800756 <strnlen+0x11>
		n++;
  800755:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800756:	39 d0                	cmp    %edx,%eax
  800758:	74 06                	je     800760 <strnlen+0x1b>
  80075a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80075e:	75 f5                	jne    800755 <strnlen+0x10>
	return n;
}
  800760:	5d                   	pop    %ebp
  800761:	c3                   	ret    

00800762 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800762:	55                   	push   %ebp
  800763:	89 e5                	mov    %esp,%ebp
  800765:	53                   	push   %ebx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80076c:	89 c2                	mov    %eax,%edx
  80076e:	42                   	inc    %edx
  80076f:	41                   	inc    %ecx
  800770:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800773:	88 5a ff             	mov    %bl,-0x1(%edx)
  800776:	84 db                	test   %bl,%bl
  800778:	75 f4                	jne    80076e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80077a:	5b                   	pop    %ebx
  80077b:	5d                   	pop    %ebp
  80077c:	c3                   	ret    

0080077d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80077d:	55                   	push   %ebp
  80077e:	89 e5                	mov    %esp,%ebp
  800780:	53                   	push   %ebx
  800781:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800784:	53                   	push   %ebx
  800785:	e8 a5 ff ff ff       	call   80072f <strlen>
  80078a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80078d:	ff 75 0c             	pushl  0xc(%ebp)
  800790:	01 d8                	add    %ebx,%eax
  800792:	50                   	push   %eax
  800793:	e8 ca ff ff ff       	call   800762 <strcpy>
	return dst;
}
  800798:	89 d8                	mov    %ebx,%eax
  80079a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80079d:	c9                   	leave  
  80079e:	c3                   	ret    

0080079f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80079f:	55                   	push   %ebp
  8007a0:	89 e5                	mov    %esp,%ebp
  8007a2:	56                   	push   %esi
  8007a3:	53                   	push   %ebx
  8007a4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007aa:	89 f3                	mov    %esi,%ebx
  8007ac:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007af:	89 f2                	mov    %esi,%edx
  8007b1:	eb 0c                	jmp    8007bf <strncpy+0x20>
		*dst++ = *src;
  8007b3:	42                   	inc    %edx
  8007b4:	8a 01                	mov    (%ecx),%al
  8007b6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007b9:	80 39 01             	cmpb   $0x1,(%ecx)
  8007bc:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007bf:	39 da                	cmp    %ebx,%edx
  8007c1:	75 f0                	jne    8007b3 <strncpy+0x14>
	}
	return ret;
}
  8007c3:	89 f0                	mov    %esi,%eax
  8007c5:	5b                   	pop    %ebx
  8007c6:	5e                   	pop    %esi
  8007c7:	5d                   	pop    %ebp
  8007c8:	c3                   	ret    

008007c9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	56                   	push   %esi
  8007cd:	53                   	push   %ebx
  8007ce:	8b 75 08             	mov    0x8(%ebp),%esi
  8007d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d4:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007d7:	85 c0                	test   %eax,%eax
  8007d9:	74 20                	je     8007fb <strlcpy+0x32>
  8007db:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8007df:	89 f0                	mov    %esi,%eax
  8007e1:	eb 05                	jmp    8007e8 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8007e3:	40                   	inc    %eax
  8007e4:	42                   	inc    %edx
  8007e5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8007e8:	39 d8                	cmp    %ebx,%eax
  8007ea:	74 06                	je     8007f2 <strlcpy+0x29>
  8007ec:	8a 0a                	mov    (%edx),%cl
  8007ee:	84 c9                	test   %cl,%cl
  8007f0:	75 f1                	jne    8007e3 <strlcpy+0x1a>
		*dst = '\0';
  8007f2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8007f5:	29 f0                	sub    %esi,%eax
}
  8007f7:	5b                   	pop    %ebx
  8007f8:	5e                   	pop    %esi
  8007f9:	5d                   	pop    %ebp
  8007fa:	c3                   	ret    
  8007fb:	89 f0                	mov    %esi,%eax
  8007fd:	eb f6                	jmp    8007f5 <strlcpy+0x2c>

008007ff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800805:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800808:	eb 02                	jmp    80080c <strcmp+0xd>
		p++, q++;
  80080a:	41                   	inc    %ecx
  80080b:	42                   	inc    %edx
	while (*p && *p == *q)
  80080c:	8a 01                	mov    (%ecx),%al
  80080e:	84 c0                	test   %al,%al
  800810:	74 04                	je     800816 <strcmp+0x17>
  800812:	3a 02                	cmp    (%edx),%al
  800814:	74 f4                	je     80080a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800816:	0f b6 c0             	movzbl %al,%eax
  800819:	0f b6 12             	movzbl (%edx),%edx
  80081c:	29 d0                	sub    %edx,%eax
}
  80081e:	5d                   	pop    %ebp
  80081f:	c3                   	ret    

00800820 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800820:	55                   	push   %ebp
  800821:	89 e5                	mov    %esp,%ebp
  800823:	53                   	push   %ebx
  800824:	8b 45 08             	mov    0x8(%ebp),%eax
  800827:	8b 55 0c             	mov    0xc(%ebp),%edx
  80082a:	89 c3                	mov    %eax,%ebx
  80082c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80082f:	eb 02                	jmp    800833 <strncmp+0x13>
		n--, p++, q++;
  800831:	40                   	inc    %eax
  800832:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800833:	39 d8                	cmp    %ebx,%eax
  800835:	74 15                	je     80084c <strncmp+0x2c>
  800837:	8a 08                	mov    (%eax),%cl
  800839:	84 c9                	test   %cl,%cl
  80083b:	74 04                	je     800841 <strncmp+0x21>
  80083d:	3a 0a                	cmp    (%edx),%cl
  80083f:	74 f0                	je     800831 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800841:	0f b6 00             	movzbl (%eax),%eax
  800844:	0f b6 12             	movzbl (%edx),%edx
  800847:	29 d0                	sub    %edx,%eax
}
  800849:	5b                   	pop    %ebx
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    
		return 0;
  80084c:	b8 00 00 00 00       	mov    $0x0,%eax
  800851:	eb f6                	jmp    800849 <strncmp+0x29>

00800853 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800853:	55                   	push   %ebp
  800854:	89 e5                	mov    %esp,%ebp
  800856:	8b 45 08             	mov    0x8(%ebp),%eax
  800859:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80085c:	8a 10                	mov    (%eax),%dl
  80085e:	84 d2                	test   %dl,%dl
  800860:	74 07                	je     800869 <strchr+0x16>
		if (*s == c)
  800862:	38 ca                	cmp    %cl,%dl
  800864:	74 08                	je     80086e <strchr+0x1b>
	for (; *s; s++)
  800866:	40                   	inc    %eax
  800867:	eb f3                	jmp    80085c <strchr+0x9>
			return (char *) s;
	return 0;
  800869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80086e:	5d                   	pop    %ebp
  80086f:	c3                   	ret    

00800870 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	8b 45 08             	mov    0x8(%ebp),%eax
  800876:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800879:	8a 10                	mov    (%eax),%dl
  80087b:	84 d2                	test   %dl,%dl
  80087d:	74 07                	je     800886 <strfind+0x16>
		if (*s == c)
  80087f:	38 ca                	cmp    %cl,%dl
  800881:	74 03                	je     800886 <strfind+0x16>
	for (; *s; s++)
  800883:	40                   	inc    %eax
  800884:	eb f3                	jmp    800879 <strfind+0x9>
			break;
	return (char *) s;
}
  800886:	5d                   	pop    %ebp
  800887:	c3                   	ret    

00800888 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800888:	55                   	push   %ebp
  800889:	89 e5                	mov    %esp,%ebp
  80088b:	57                   	push   %edi
  80088c:	56                   	push   %esi
  80088d:	53                   	push   %ebx
  80088e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800891:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800894:	85 c9                	test   %ecx,%ecx
  800896:	74 13                	je     8008ab <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800898:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80089e:	75 05                	jne    8008a5 <memset+0x1d>
  8008a0:	f6 c1 03             	test   $0x3,%cl
  8008a3:	74 0d                	je     8008b2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008a8:	fc                   	cld    
  8008a9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008ab:	89 f8                	mov    %edi,%eax
  8008ad:	5b                   	pop    %ebx
  8008ae:	5e                   	pop    %esi
  8008af:	5f                   	pop    %edi
  8008b0:	5d                   	pop    %ebp
  8008b1:	c3                   	ret    
		c &= 0xFF;
  8008b2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008b6:	89 d3                	mov    %edx,%ebx
  8008b8:	c1 e3 08             	shl    $0x8,%ebx
  8008bb:	89 d0                	mov    %edx,%eax
  8008bd:	c1 e0 18             	shl    $0x18,%eax
  8008c0:	89 d6                	mov    %edx,%esi
  8008c2:	c1 e6 10             	shl    $0x10,%esi
  8008c5:	09 f0                	or     %esi,%eax
  8008c7:	09 c2                	or     %eax,%edx
  8008c9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008cb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008ce:	89 d0                	mov    %edx,%eax
  8008d0:	fc                   	cld    
  8008d1:	f3 ab                	rep stos %eax,%es:(%edi)
  8008d3:	eb d6                	jmp    8008ab <memset+0x23>

008008d5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	57                   	push   %edi
  8008d9:	56                   	push   %esi
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8008e0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8008e3:	39 c6                	cmp    %eax,%esi
  8008e5:	73 33                	jae    80091a <memmove+0x45>
  8008e7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8008ea:	39 d0                	cmp    %edx,%eax
  8008ec:	73 2c                	jae    80091a <memmove+0x45>
		s += n;
		d += n;
  8008ee:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8008f1:	89 d6                	mov    %edx,%esi
  8008f3:	09 fe                	or     %edi,%esi
  8008f5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8008fb:	75 13                	jne    800910 <memmove+0x3b>
  8008fd:	f6 c1 03             	test   $0x3,%cl
  800900:	75 0e                	jne    800910 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800902:	83 ef 04             	sub    $0x4,%edi
  800905:	8d 72 fc             	lea    -0x4(%edx),%esi
  800908:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80090b:	fd                   	std    
  80090c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80090e:	eb 07                	jmp    800917 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800910:	4f                   	dec    %edi
  800911:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800914:	fd                   	std    
  800915:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800917:	fc                   	cld    
  800918:	eb 13                	jmp    80092d <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80091a:	89 f2                	mov    %esi,%edx
  80091c:	09 c2                	or     %eax,%edx
  80091e:	f6 c2 03             	test   $0x3,%dl
  800921:	75 05                	jne    800928 <memmove+0x53>
  800923:	f6 c1 03             	test   $0x3,%cl
  800926:	74 09                	je     800931 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800928:	89 c7                	mov    %eax,%edi
  80092a:	fc                   	cld    
  80092b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80092d:	5e                   	pop    %esi
  80092e:	5f                   	pop    %edi
  80092f:	5d                   	pop    %ebp
  800930:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800931:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800934:	89 c7                	mov    %eax,%edi
  800936:	fc                   	cld    
  800937:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800939:	eb f2                	jmp    80092d <memmove+0x58>

0080093b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80093b:	55                   	push   %ebp
  80093c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80093e:	ff 75 10             	pushl  0x10(%ebp)
  800941:	ff 75 0c             	pushl  0xc(%ebp)
  800944:	ff 75 08             	pushl  0x8(%ebp)
  800947:	e8 89 ff ff ff       	call   8008d5 <memmove>
}
  80094c:	c9                   	leave  
  80094d:	c3                   	ret    

0080094e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80094e:	55                   	push   %ebp
  80094f:	89 e5                	mov    %esp,%ebp
  800951:	56                   	push   %esi
  800952:	53                   	push   %ebx
  800953:	8b 45 08             	mov    0x8(%ebp),%eax
  800956:	89 c6                	mov    %eax,%esi
  800958:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  80095b:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80095e:	39 f0                	cmp    %esi,%eax
  800960:	74 16                	je     800978 <memcmp+0x2a>
		if (*s1 != *s2)
  800962:	8a 08                	mov    (%eax),%cl
  800964:	8a 1a                	mov    (%edx),%bl
  800966:	38 d9                	cmp    %bl,%cl
  800968:	75 04                	jne    80096e <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80096a:	40                   	inc    %eax
  80096b:	42                   	inc    %edx
  80096c:	eb f0                	jmp    80095e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80096e:	0f b6 c1             	movzbl %cl,%eax
  800971:	0f b6 db             	movzbl %bl,%ebx
  800974:	29 d8                	sub    %ebx,%eax
  800976:	eb 05                	jmp    80097d <memcmp+0x2f>
	}

	return 0;
  800978:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80097d:	5b                   	pop    %ebx
  80097e:	5e                   	pop    %esi
  80097f:	5d                   	pop    %ebp
  800980:	c3                   	ret    

00800981 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  80098a:	89 c2                	mov    %eax,%edx
  80098c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  80098f:	39 d0                	cmp    %edx,%eax
  800991:	73 07                	jae    80099a <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800993:	38 08                	cmp    %cl,(%eax)
  800995:	74 03                	je     80099a <memfind+0x19>
	for (; s < ends; s++)
  800997:	40                   	inc    %eax
  800998:	eb f5                	jmp    80098f <memfind+0xe>
			break;
	return (void *) s;
}
  80099a:	5d                   	pop    %ebp
  80099b:	c3                   	ret    

0080099c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80099c:	55                   	push   %ebp
  80099d:	89 e5                	mov    %esp,%ebp
  80099f:	57                   	push   %edi
  8009a0:	56                   	push   %esi
  8009a1:	53                   	push   %ebx
  8009a2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009a5:	eb 01                	jmp    8009a8 <strtol+0xc>
		s++;
  8009a7:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009a8:	8a 01                	mov    (%ecx),%al
  8009aa:	3c 20                	cmp    $0x20,%al
  8009ac:	74 f9                	je     8009a7 <strtol+0xb>
  8009ae:	3c 09                	cmp    $0x9,%al
  8009b0:	74 f5                	je     8009a7 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009b2:	3c 2b                	cmp    $0x2b,%al
  8009b4:	74 2b                	je     8009e1 <strtol+0x45>
		s++;
	else if (*s == '-')
  8009b6:	3c 2d                	cmp    $0x2d,%al
  8009b8:	74 2f                	je     8009e9 <strtol+0x4d>
	int neg = 0;
  8009ba:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009bf:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009c6:	75 12                	jne    8009da <strtol+0x3e>
  8009c8:	80 39 30             	cmpb   $0x30,(%ecx)
  8009cb:	74 24                	je     8009f1 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009d1:	75 07                	jne    8009da <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009d3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8009da:	b8 00 00 00 00       	mov    $0x0,%eax
  8009df:	eb 4e                	jmp    800a2f <strtol+0x93>
		s++;
  8009e1:	41                   	inc    %ecx
	int neg = 0;
  8009e2:	bf 00 00 00 00       	mov    $0x0,%edi
  8009e7:	eb d6                	jmp    8009bf <strtol+0x23>
		s++, neg = 1;
  8009e9:	41                   	inc    %ecx
  8009ea:	bf 01 00 00 00       	mov    $0x1,%edi
  8009ef:	eb ce                	jmp    8009bf <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009f1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  8009f5:	74 10                	je     800a07 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  8009f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009fb:	75 dd                	jne    8009da <strtol+0x3e>
		s++, base = 8;
  8009fd:	41                   	inc    %ecx
  8009fe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a05:	eb d3                	jmp    8009da <strtol+0x3e>
		s += 2, base = 16;
  800a07:	83 c1 02             	add    $0x2,%ecx
  800a0a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a11:	eb c7                	jmp    8009da <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a13:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a16:	89 f3                	mov    %esi,%ebx
  800a18:	80 fb 19             	cmp    $0x19,%bl
  800a1b:	77 24                	ja     800a41 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a1d:	0f be d2             	movsbl %dl,%edx
  800a20:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a23:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a26:	7d 2b                	jge    800a53 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a28:	41                   	inc    %ecx
  800a29:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a2d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a2f:	8a 11                	mov    (%ecx),%dl
  800a31:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a34:	80 fb 09             	cmp    $0x9,%bl
  800a37:	77 da                	ja     800a13 <strtol+0x77>
			dig = *s - '0';
  800a39:	0f be d2             	movsbl %dl,%edx
  800a3c:	83 ea 30             	sub    $0x30,%edx
  800a3f:	eb e2                	jmp    800a23 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a41:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a44:	89 f3                	mov    %esi,%ebx
  800a46:	80 fb 19             	cmp    $0x19,%bl
  800a49:	77 08                	ja     800a53 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a4b:	0f be d2             	movsbl %dl,%edx
  800a4e:	83 ea 37             	sub    $0x37,%edx
  800a51:	eb d0                	jmp    800a23 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a53:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a57:	74 05                	je     800a5e <strtol+0xc2>
		*endptr = (char *) s;
  800a59:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a5c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a5e:	85 ff                	test   %edi,%edi
  800a60:	74 02                	je     800a64 <strtol+0xc8>
  800a62:	f7 d8                	neg    %eax
}
  800a64:	5b                   	pop    %ebx
  800a65:	5e                   	pop    %esi
  800a66:	5f                   	pop    %edi
  800a67:	5d                   	pop    %ebp
  800a68:	c3                   	ret    

00800a69 <atoi>:

int
atoi(const char *s)
{
  800a69:	55                   	push   %ebp
  800a6a:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800a6c:	6a 0a                	push   $0xa
  800a6e:	6a 00                	push   $0x0
  800a70:	ff 75 08             	pushl  0x8(%ebp)
  800a73:	e8 24 ff ff ff       	call   80099c <strtol>
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	57                   	push   %edi
  800a7e:	56                   	push   %esi
  800a7f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a80:	b8 00 00 00 00       	mov    $0x0,%eax
  800a85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800a88:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8b:	89 c3                	mov    %eax,%ebx
  800a8d:	89 c7                	mov    %eax,%edi
  800a8f:	89 c6                	mov    %eax,%esi
  800a91:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    

00800a98 <sys_cgetc>:

int
sys_cgetc(void)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	57                   	push   %edi
  800a9c:	56                   	push   %esi
  800a9d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800a9e:	ba 00 00 00 00       	mov    $0x0,%edx
  800aa3:	b8 01 00 00 00       	mov    $0x1,%eax
  800aa8:	89 d1                	mov    %edx,%ecx
  800aaa:	89 d3                	mov    %edx,%ebx
  800aac:	89 d7                	mov    %edx,%edi
  800aae:	89 d6                	mov    %edx,%esi
  800ab0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ab2:	5b                   	pop    %ebx
  800ab3:	5e                   	pop    %esi
  800ab4:	5f                   	pop    %edi
  800ab5:	5d                   	pop    %ebp
  800ab6:	c3                   	ret    

00800ab7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ab7:	55                   	push   %ebp
  800ab8:	89 e5                	mov    %esp,%ebp
  800aba:	57                   	push   %edi
  800abb:	56                   	push   %esi
  800abc:	53                   	push   %ebx
  800abd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ac0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ac5:	b8 03 00 00 00       	mov    $0x3,%eax
  800aca:	8b 55 08             	mov    0x8(%ebp),%edx
  800acd:	89 cb                	mov    %ecx,%ebx
  800acf:	89 cf                	mov    %ecx,%edi
  800ad1:	89 ce                	mov    %ecx,%esi
  800ad3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ad5:	85 c0                	test   %eax,%eax
  800ad7:	7f 08                	jg     800ae1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800ad9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800adc:	5b                   	pop    %ebx
  800add:	5e                   	pop    %esi
  800ade:	5f                   	pop    %edi
  800adf:	5d                   	pop    %ebp
  800ae0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ae1:	83 ec 0c             	sub    $0xc,%esp
  800ae4:	50                   	push   %eax
  800ae5:	6a 03                	push   $0x3
  800ae7:	68 3f 22 80 00       	push   $0x80223f
  800aec:	6a 23                	push   $0x23
  800aee:	68 5c 22 80 00       	push   $0x80225c
  800af3:	e8 df 0f 00 00       	call   801ad7 <_panic>

00800af8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800af8:	55                   	push   %ebp
  800af9:	89 e5                	mov    %esp,%ebp
  800afb:	57                   	push   %edi
  800afc:	56                   	push   %esi
  800afd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800afe:	ba 00 00 00 00       	mov    $0x0,%edx
  800b03:	b8 02 00 00 00       	mov    $0x2,%eax
  800b08:	89 d1                	mov    %edx,%ecx
  800b0a:	89 d3                	mov    %edx,%ebx
  800b0c:	89 d7                	mov    %edx,%edi
  800b0e:	89 d6                	mov    %edx,%esi
  800b10:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b12:	5b                   	pop    %ebx
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    

00800b17 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b17:	55                   	push   %ebp
  800b18:	89 e5                	mov    %esp,%ebp
  800b1a:	57                   	push   %edi
  800b1b:	56                   	push   %esi
  800b1c:	53                   	push   %ebx
  800b1d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b20:	be 00 00 00 00       	mov    $0x0,%esi
  800b25:	b8 04 00 00 00       	mov    $0x4,%eax
  800b2a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b30:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b33:	89 f7                	mov    %esi,%edi
  800b35:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b37:	85 c0                	test   %eax,%eax
  800b39:	7f 08                	jg     800b43 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b3b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b3e:	5b                   	pop    %ebx
  800b3f:	5e                   	pop    %esi
  800b40:	5f                   	pop    %edi
  800b41:	5d                   	pop    %ebp
  800b42:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b43:	83 ec 0c             	sub    $0xc,%esp
  800b46:	50                   	push   %eax
  800b47:	6a 04                	push   $0x4
  800b49:	68 3f 22 80 00       	push   $0x80223f
  800b4e:	6a 23                	push   $0x23
  800b50:	68 5c 22 80 00       	push   $0x80225c
  800b55:	e8 7d 0f 00 00       	call   801ad7 <_panic>

00800b5a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b5a:	55                   	push   %ebp
  800b5b:	89 e5                	mov    %esp,%ebp
  800b5d:	57                   	push   %edi
  800b5e:	56                   	push   %esi
  800b5f:	53                   	push   %ebx
  800b60:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b63:	b8 05 00 00 00       	mov    $0x5,%eax
  800b68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b71:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b74:	8b 75 18             	mov    0x18(%ebp),%esi
  800b77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b79:	85 c0                	test   %eax,%eax
  800b7b:	7f 08                	jg     800b85 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b80:	5b                   	pop    %ebx
  800b81:	5e                   	pop    %esi
  800b82:	5f                   	pop    %edi
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b85:	83 ec 0c             	sub    $0xc,%esp
  800b88:	50                   	push   %eax
  800b89:	6a 05                	push   $0x5
  800b8b:	68 3f 22 80 00       	push   $0x80223f
  800b90:	6a 23                	push   $0x23
  800b92:	68 5c 22 80 00       	push   $0x80225c
  800b97:	e8 3b 0f 00 00       	call   801ad7 <_panic>

00800b9c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
  800ba2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800baa:	b8 06 00 00 00       	mov    $0x6,%eax
  800baf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb5:	89 df                	mov    %ebx,%edi
  800bb7:	89 de                	mov    %ebx,%esi
  800bb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bbb:	85 c0                	test   %eax,%eax
  800bbd:	7f 08                	jg     800bc7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
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
  800bcb:	6a 06                	push   $0x6
  800bcd:	68 3f 22 80 00       	push   $0x80223f
  800bd2:	6a 23                	push   $0x23
  800bd4:	68 5c 22 80 00       	push   $0x80225c
  800bd9:	e8 f9 0e 00 00       	call   801ad7 <_panic>

00800bde <sys_yield>:

void
sys_yield(void)
{
  800bde:	55                   	push   %ebp
  800bdf:	89 e5                	mov    %esp,%ebp
  800be1:	57                   	push   %edi
  800be2:	56                   	push   %esi
  800be3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800be4:	ba 00 00 00 00       	mov    $0x0,%edx
  800be9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800bee:	89 d1                	mov    %edx,%ecx
  800bf0:	89 d3                	mov    %edx,%ebx
  800bf2:	89 d7                	mov    %edx,%edi
  800bf4:	89 d6                	mov    %edx,%esi
  800bf6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800bf8:	5b                   	pop    %ebx
  800bf9:	5e                   	pop    %esi
  800bfa:	5f                   	pop    %edi
  800bfb:	5d                   	pop    %ebp
  800bfc:	c3                   	ret    

00800bfd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800bfd:	55                   	push   %ebp
  800bfe:	89 e5                	mov    %esp,%ebp
  800c00:	57                   	push   %edi
  800c01:	56                   	push   %esi
  800c02:	53                   	push   %ebx
  800c03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c06:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c0b:	b8 08 00 00 00       	mov    $0x8,%eax
  800c10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c13:	8b 55 08             	mov    0x8(%ebp),%edx
  800c16:	89 df                	mov    %ebx,%edi
  800c18:	89 de                	mov    %ebx,%esi
  800c1a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1c:	85 c0                	test   %eax,%eax
  800c1e:	7f 08                	jg     800c28 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5f                   	pop    %edi
  800c26:	5d                   	pop    %ebp
  800c27:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c28:	83 ec 0c             	sub    $0xc,%esp
  800c2b:	50                   	push   %eax
  800c2c:	6a 08                	push   $0x8
  800c2e:	68 3f 22 80 00       	push   $0x80223f
  800c33:	6a 23                	push   $0x23
  800c35:	68 5c 22 80 00       	push   $0x80225c
  800c3a:	e8 98 0e 00 00       	call   801ad7 <_panic>

00800c3f <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	57                   	push   %edi
  800c43:	56                   	push   %esi
  800c44:	53                   	push   %ebx
  800c45:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c48:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c52:	8b 55 08             	mov    0x8(%ebp),%edx
  800c55:	89 cb                	mov    %ecx,%ebx
  800c57:	89 cf                	mov    %ecx,%edi
  800c59:	89 ce                	mov    %ecx,%esi
  800c5b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5d:	85 c0                	test   %eax,%eax
  800c5f:	7f 08                	jg     800c69 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c61:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c64:	5b                   	pop    %ebx
  800c65:	5e                   	pop    %esi
  800c66:	5f                   	pop    %edi
  800c67:	5d                   	pop    %ebp
  800c68:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c69:	83 ec 0c             	sub    $0xc,%esp
  800c6c:	50                   	push   %eax
  800c6d:	6a 0c                	push   $0xc
  800c6f:	68 3f 22 80 00       	push   $0x80223f
  800c74:	6a 23                	push   $0x23
  800c76:	68 5c 22 80 00       	push   $0x80225c
  800c7b:	e8 57 0e 00 00       	call   801ad7 <_panic>

00800c80 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8e:	b8 09 00 00 00       	mov    $0x9,%eax
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	89 df                	mov    %ebx,%edi
  800c9b:	89 de                	mov    %ebx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ca3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ca6:	5b                   	pop    %ebx
  800ca7:	5e                   	pop    %esi
  800ca8:	5f                   	pop    %edi
  800ca9:	5d                   	pop    %ebp
  800caa:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cab:	83 ec 0c             	sub    $0xc,%esp
  800cae:	50                   	push   %eax
  800caf:	6a 09                	push   $0x9
  800cb1:	68 3f 22 80 00       	push   $0x80223f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 5c 22 80 00       	push   $0x80225c
  800cbd:	e8 15 0e 00 00       	call   801ad7 <_panic>

00800cc2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cd0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cd5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cd8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cdb:	89 df                	mov    %ebx,%edi
  800cdd:	89 de                	mov    %ebx,%esi
  800cdf:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce1:	85 c0                	test   %eax,%eax
  800ce3:	7f 08                	jg     800ced <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
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
  800cf1:	6a 0a                	push   $0xa
  800cf3:	68 3f 22 80 00       	push   $0x80223f
  800cf8:	6a 23                	push   $0x23
  800cfa:	68 5c 22 80 00       	push   $0x80225c
  800cff:	e8 d3 0d 00 00       	call   801ad7 <_panic>

00800d04 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d04:	55                   	push   %ebp
  800d05:	89 e5                	mov    %esp,%ebp
  800d07:	57                   	push   %edi
  800d08:	56                   	push   %esi
  800d09:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d0a:	be 00 00 00 00       	mov    $0x0,%esi
  800d0f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d14:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d17:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d20:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d22:	5b                   	pop    %ebx
  800d23:	5e                   	pop    %esi
  800d24:	5f                   	pop    %edi
  800d25:	5d                   	pop    %ebp
  800d26:	c3                   	ret    

00800d27 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d27:	55                   	push   %ebp
  800d28:	89 e5                	mov    %esp,%ebp
  800d2a:	57                   	push   %edi
  800d2b:	56                   	push   %esi
  800d2c:	53                   	push   %ebx
  800d2d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d30:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d35:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	89 cb                	mov    %ecx,%ebx
  800d3f:	89 cf                	mov    %ecx,%edi
  800d41:	89 ce                	mov    %ecx,%esi
  800d43:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d45:	85 c0                	test   %eax,%eax
  800d47:	7f 08                	jg     800d51 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800d49:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d4c:	5b                   	pop    %ebx
  800d4d:	5e                   	pop    %esi
  800d4e:	5f                   	pop    %edi
  800d4f:	5d                   	pop    %ebp
  800d50:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d51:	83 ec 0c             	sub    $0xc,%esp
  800d54:	50                   	push   %eax
  800d55:	6a 0e                	push   $0xe
  800d57:	68 3f 22 80 00       	push   $0x80223f
  800d5c:	6a 23                	push   $0x23
  800d5e:	68 5c 22 80 00       	push   $0x80225c
  800d63:	e8 6f 0d 00 00       	call   801ad7 <_panic>

00800d68 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
  800d6b:	57                   	push   %edi
  800d6c:	56                   	push   %esi
  800d6d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d6e:	be 00 00 00 00       	mov    $0x0,%esi
  800d73:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d78:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d81:	89 f7                	mov    %esi,%edi
  800d83:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800d85:	5b                   	pop    %ebx
  800d86:	5e                   	pop    %esi
  800d87:	5f                   	pop    %edi
  800d88:	5d                   	pop    %ebp
  800d89:	c3                   	ret    

00800d8a <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800d8a:	55                   	push   %ebp
  800d8b:	89 e5                	mov    %esp,%ebp
  800d8d:	57                   	push   %edi
  800d8e:	56                   	push   %esi
  800d8f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d90:	be 00 00 00 00       	mov    $0x0,%esi
  800d95:	b8 10 00 00 00       	mov    $0x10,%eax
  800d9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da3:	89 f7                	mov    %esi,%edi
  800da5:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800da7:	5b                   	pop    %ebx
  800da8:	5e                   	pop    %esi
  800da9:	5f                   	pop    %edi
  800daa:	5d                   	pop    %ebp
  800dab:	c3                   	ret    

00800dac <sys_set_console_color>:

void sys_set_console_color(int color) {
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
  800daf:	57                   	push   %edi
  800db0:	56                   	push   %esi
  800db1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db7:	b8 11 00 00 00       	mov    $0x11,%eax
  800dbc:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbf:	89 cb                	mov    %ecx,%ebx
  800dc1:	89 cf                	mov    %ecx,%edi
  800dc3:	89 ce                	mov    %ecx,%esi
  800dc5:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd2:	05 00 00 00 30       	add    $0x30000000,%eax
  800dd7:	c1 e8 0c             	shr    $0xc,%eax
}
  800dda:	5d                   	pop    %ebp
  800ddb:	c3                   	ret    

00800ddc <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800ddc:	55                   	push   %ebp
  800ddd:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800de7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800dec:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800df1:	5d                   	pop    %ebp
  800df2:	c3                   	ret    

00800df3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800df3:	55                   	push   %ebp
  800df4:	89 e5                	mov    %esp,%ebp
  800df6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800df9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800dfe:	89 c2                	mov    %eax,%edx
  800e00:	c1 ea 16             	shr    $0x16,%edx
  800e03:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e0a:	f6 c2 01             	test   $0x1,%dl
  800e0d:	74 2a                	je     800e39 <fd_alloc+0x46>
  800e0f:	89 c2                	mov    %eax,%edx
  800e11:	c1 ea 0c             	shr    $0xc,%edx
  800e14:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e1b:	f6 c2 01             	test   $0x1,%dl
  800e1e:	74 19                	je     800e39 <fd_alloc+0x46>
  800e20:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800e25:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800e2a:	75 d2                	jne    800dfe <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800e2c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800e32:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800e37:	eb 07                	jmp    800e40 <fd_alloc+0x4d>
			*fd_store = fd;
  800e39:	89 01                	mov    %eax,(%ecx)
			return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e40:	5d                   	pop    %ebp
  800e41:	c3                   	ret    

00800e42 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800e42:	55                   	push   %ebp
  800e43:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800e45:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800e49:	77 39                	ja     800e84 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	c1 e0 0c             	shl    $0xc,%eax
  800e51:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800e56:	89 c2                	mov    %eax,%edx
  800e58:	c1 ea 16             	shr    $0x16,%edx
  800e5b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e62:	f6 c2 01             	test   $0x1,%dl
  800e65:	74 24                	je     800e8b <fd_lookup+0x49>
  800e67:	89 c2                	mov    %eax,%edx
  800e69:	c1 ea 0c             	shr    $0xc,%edx
  800e6c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800e73:	f6 c2 01             	test   $0x1,%dl
  800e76:	74 1a                	je     800e92 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800e78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e7b:	89 02                	mov    %eax,(%edx)
	return 0;
  800e7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e82:	5d                   	pop    %ebp
  800e83:	c3                   	ret    
		return -E_INVAL;
  800e84:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e89:	eb f7                	jmp    800e82 <fd_lookup+0x40>
		return -E_INVAL;
  800e8b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e90:	eb f0                	jmp    800e82 <fd_lookup+0x40>
  800e92:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800e97:	eb e9                	jmp    800e82 <fd_lookup+0x40>

00800e99 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800e99:	55                   	push   %ebp
  800e9a:	89 e5                	mov    %esp,%ebp
  800e9c:	83 ec 08             	sub    $0x8,%esp
  800e9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ea2:	ba e8 22 80 00       	mov    $0x8022e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800ea7:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800eac:	39 08                	cmp    %ecx,(%eax)
  800eae:	74 33                	je     800ee3 <dev_lookup+0x4a>
  800eb0:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800eb3:	8b 02                	mov    (%edx),%eax
  800eb5:	85 c0                	test   %eax,%eax
  800eb7:	75 f3                	jne    800eac <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800eb9:	a1 08 40 80 00       	mov    0x804008,%eax
  800ebe:	8b 40 48             	mov    0x48(%eax),%eax
  800ec1:	83 ec 04             	sub    $0x4,%esp
  800ec4:	51                   	push   %ecx
  800ec5:	50                   	push   %eax
  800ec6:	68 6c 22 80 00       	push   $0x80226c
  800ecb:	e8 8a f2 ff ff       	call   80015a <cprintf>
	*dev = 0;
  800ed0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800ed9:	83 c4 10             	add    $0x10,%esp
  800edc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800ee1:	c9                   	leave  
  800ee2:	c3                   	ret    
			*dev = devtab[i];
  800ee3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ee6:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ee8:	b8 00 00 00 00       	mov    $0x0,%eax
  800eed:	eb f2                	jmp    800ee1 <dev_lookup+0x48>

00800eef <fd_close>:
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
  800ef5:	83 ec 1c             	sub    $0x1c,%esp
  800ef8:	8b 75 08             	mov    0x8(%ebp),%esi
  800efb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800efe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f01:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f02:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f08:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f0b:	50                   	push   %eax
  800f0c:	e8 31 ff ff ff       	call   800e42 <fd_lookup>
  800f11:	89 c7                	mov    %eax,%edi
  800f13:	83 c4 08             	add    $0x8,%esp
  800f16:	85 c0                	test   %eax,%eax
  800f18:	78 05                	js     800f1f <fd_close+0x30>
	    || fd != fd2)
  800f1a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800f1d:	74 13                	je     800f32 <fd_close+0x43>
		return (must_exist ? r : 0);
  800f1f:	84 db                	test   %bl,%bl
  800f21:	75 05                	jne    800f28 <fd_close+0x39>
  800f23:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800f28:	89 f8                	mov    %edi,%eax
  800f2a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f2d:	5b                   	pop    %ebx
  800f2e:	5e                   	pop    %esi
  800f2f:	5f                   	pop    %edi
  800f30:	5d                   	pop    %ebp
  800f31:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800f38:	50                   	push   %eax
  800f39:	ff 36                	pushl  (%esi)
  800f3b:	e8 59 ff ff ff       	call   800e99 <dev_lookup>
  800f40:	89 c7                	mov    %eax,%edi
  800f42:	83 c4 10             	add    $0x10,%esp
  800f45:	85 c0                	test   %eax,%eax
  800f47:	78 15                	js     800f5e <fd_close+0x6f>
		if (dev->dev_close)
  800f49:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f4c:	8b 40 10             	mov    0x10(%eax),%eax
  800f4f:	85 c0                	test   %eax,%eax
  800f51:	74 1b                	je     800f6e <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800f53:	83 ec 0c             	sub    $0xc,%esp
  800f56:	56                   	push   %esi
  800f57:	ff d0                	call   *%eax
  800f59:	89 c7                	mov    %eax,%edi
  800f5b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800f5e:	83 ec 08             	sub    $0x8,%esp
  800f61:	56                   	push   %esi
  800f62:	6a 00                	push   $0x0
  800f64:	e8 33 fc ff ff       	call   800b9c <sys_page_unmap>
	return r;
  800f69:	83 c4 10             	add    $0x10,%esp
  800f6c:	eb ba                	jmp    800f28 <fd_close+0x39>
			r = 0;
  800f6e:	bf 00 00 00 00       	mov    $0x0,%edi
  800f73:	eb e9                	jmp    800f5e <fd_close+0x6f>

00800f75 <close>:

int
close(int fdnum)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f7b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f7e:	50                   	push   %eax
  800f7f:	ff 75 08             	pushl  0x8(%ebp)
  800f82:	e8 bb fe ff ff       	call   800e42 <fd_lookup>
  800f87:	83 c4 08             	add    $0x8,%esp
  800f8a:	85 c0                	test   %eax,%eax
  800f8c:	78 10                	js     800f9e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  800f8e:	83 ec 08             	sub    $0x8,%esp
  800f91:	6a 01                	push   $0x1
  800f93:	ff 75 f4             	pushl  -0xc(%ebp)
  800f96:	e8 54 ff ff ff       	call   800eef <fd_close>
  800f9b:	83 c4 10             	add    $0x10,%esp
}
  800f9e:	c9                   	leave  
  800f9f:	c3                   	ret    

00800fa0 <close_all>:

void
close_all(void)
{
  800fa0:	55                   	push   %ebp
  800fa1:	89 e5                	mov    %esp,%ebp
  800fa3:	53                   	push   %ebx
  800fa4:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  800fa7:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800fac:	83 ec 0c             	sub    $0xc,%esp
  800faf:	53                   	push   %ebx
  800fb0:	e8 c0 ff ff ff       	call   800f75 <close>
	for (i = 0; i < MAXFD; i++)
  800fb5:	43                   	inc    %ebx
  800fb6:	83 c4 10             	add    $0x10,%esp
  800fb9:	83 fb 20             	cmp    $0x20,%ebx
  800fbc:	75 ee                	jne    800fac <close_all+0xc>
}
  800fbe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fc1:	c9                   	leave  
  800fc2:	c3                   	ret    

00800fc3 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800fc3:	55                   	push   %ebp
  800fc4:	89 e5                	mov    %esp,%ebp
  800fc6:	57                   	push   %edi
  800fc7:	56                   	push   %esi
  800fc8:	53                   	push   %ebx
  800fc9:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800fcc:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fcf:	50                   	push   %eax
  800fd0:	ff 75 08             	pushl  0x8(%ebp)
  800fd3:	e8 6a fe ff ff       	call   800e42 <fd_lookup>
  800fd8:	89 c3                	mov    %eax,%ebx
  800fda:	83 c4 08             	add    $0x8,%esp
  800fdd:	85 c0                	test   %eax,%eax
  800fdf:	0f 88 81 00 00 00    	js     801066 <dup+0xa3>
		return r;
	close(newfdnum);
  800fe5:	83 ec 0c             	sub    $0xc,%esp
  800fe8:	ff 75 0c             	pushl  0xc(%ebp)
  800feb:	e8 85 ff ff ff       	call   800f75 <close>

	newfd = INDEX2FD(newfdnum);
  800ff0:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ff3:	c1 e6 0c             	shl    $0xc,%esi
  800ff6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800ffc:	83 c4 04             	add    $0x4,%esp
  800fff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801002:	e8 d5 fd ff ff       	call   800ddc <fd2data>
  801007:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801009:	89 34 24             	mov    %esi,(%esp)
  80100c:	e8 cb fd ff ff       	call   800ddc <fd2data>
  801011:	83 c4 10             	add    $0x10,%esp
  801014:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801016:	89 d8                	mov    %ebx,%eax
  801018:	c1 e8 16             	shr    $0x16,%eax
  80101b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801022:	a8 01                	test   $0x1,%al
  801024:	74 11                	je     801037 <dup+0x74>
  801026:	89 d8                	mov    %ebx,%eax
  801028:	c1 e8 0c             	shr    $0xc,%eax
  80102b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801032:	f6 c2 01             	test   $0x1,%dl
  801035:	75 39                	jne    801070 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801037:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80103a:	89 d0                	mov    %edx,%eax
  80103c:	c1 e8 0c             	shr    $0xc,%eax
  80103f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801046:	83 ec 0c             	sub    $0xc,%esp
  801049:	25 07 0e 00 00       	and    $0xe07,%eax
  80104e:	50                   	push   %eax
  80104f:	56                   	push   %esi
  801050:	6a 00                	push   $0x0
  801052:	52                   	push   %edx
  801053:	6a 00                	push   $0x0
  801055:	e8 00 fb ff ff       	call   800b5a <sys_page_map>
  80105a:	89 c3                	mov    %eax,%ebx
  80105c:	83 c4 20             	add    $0x20,%esp
  80105f:	85 c0                	test   %eax,%eax
  801061:	78 31                	js     801094 <dup+0xd1>
		goto err;

	return newfdnum;
  801063:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801066:	89 d8                	mov    %ebx,%eax
  801068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80106b:	5b                   	pop    %ebx
  80106c:	5e                   	pop    %esi
  80106d:	5f                   	pop    %edi
  80106e:	5d                   	pop    %ebp
  80106f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801070:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801077:	83 ec 0c             	sub    $0xc,%esp
  80107a:	25 07 0e 00 00       	and    $0xe07,%eax
  80107f:	50                   	push   %eax
  801080:	57                   	push   %edi
  801081:	6a 00                	push   $0x0
  801083:	53                   	push   %ebx
  801084:	6a 00                	push   $0x0
  801086:	e8 cf fa ff ff       	call   800b5a <sys_page_map>
  80108b:	89 c3                	mov    %eax,%ebx
  80108d:	83 c4 20             	add    $0x20,%esp
  801090:	85 c0                	test   %eax,%eax
  801092:	79 a3                	jns    801037 <dup+0x74>
	sys_page_unmap(0, newfd);
  801094:	83 ec 08             	sub    $0x8,%esp
  801097:	56                   	push   %esi
  801098:	6a 00                	push   $0x0
  80109a:	e8 fd fa ff ff       	call   800b9c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80109f:	83 c4 08             	add    $0x8,%esp
  8010a2:	57                   	push   %edi
  8010a3:	6a 00                	push   $0x0
  8010a5:	e8 f2 fa ff ff       	call   800b9c <sys_page_unmap>
	return r;
  8010aa:	83 c4 10             	add    $0x10,%esp
  8010ad:	eb b7                	jmp    801066 <dup+0xa3>

008010af <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8010af:	55                   	push   %ebp
  8010b0:	89 e5                	mov    %esp,%ebp
  8010b2:	53                   	push   %ebx
  8010b3:	83 ec 14             	sub    $0x14,%esp
  8010b6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8010b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8010bc:	50                   	push   %eax
  8010bd:	53                   	push   %ebx
  8010be:	e8 7f fd ff ff       	call   800e42 <fd_lookup>
  8010c3:	83 c4 08             	add    $0x8,%esp
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	78 3f                	js     801109 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8010ca:	83 ec 08             	sub    $0x8,%esp
  8010cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010d0:	50                   	push   %eax
  8010d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010d4:	ff 30                	pushl  (%eax)
  8010d6:	e8 be fd ff ff       	call   800e99 <dev_lookup>
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	78 27                	js     801109 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8010e2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8010e5:	8b 42 08             	mov    0x8(%edx),%eax
  8010e8:	83 e0 03             	and    $0x3,%eax
  8010eb:	83 f8 01             	cmp    $0x1,%eax
  8010ee:	74 1e                	je     80110e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f3:	8b 40 08             	mov    0x8(%eax),%eax
  8010f6:	85 c0                	test   %eax,%eax
  8010f8:	74 35                	je     80112f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8010fa:	83 ec 04             	sub    $0x4,%esp
  8010fd:	ff 75 10             	pushl  0x10(%ebp)
  801100:	ff 75 0c             	pushl  0xc(%ebp)
  801103:	52                   	push   %edx
  801104:	ff d0                	call   *%eax
  801106:	83 c4 10             	add    $0x10,%esp
}
  801109:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80110c:	c9                   	leave  
  80110d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80110e:	a1 08 40 80 00       	mov    0x804008,%eax
  801113:	8b 40 48             	mov    0x48(%eax),%eax
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	53                   	push   %ebx
  80111a:	50                   	push   %eax
  80111b:	68 ad 22 80 00       	push   $0x8022ad
  801120:	e8 35 f0 ff ff       	call   80015a <cprintf>
		return -E_INVAL;
  801125:	83 c4 10             	add    $0x10,%esp
  801128:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80112d:	eb da                	jmp    801109 <read+0x5a>
		return -E_NOT_SUPP;
  80112f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801134:	eb d3                	jmp    801109 <read+0x5a>

00801136 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	57                   	push   %edi
  80113a:	56                   	push   %esi
  80113b:	53                   	push   %ebx
  80113c:	83 ec 0c             	sub    $0xc,%esp
  80113f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801142:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801145:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114a:	39 f3                	cmp    %esi,%ebx
  80114c:	73 25                	jae    801173 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80114e:	83 ec 04             	sub    $0x4,%esp
  801151:	89 f0                	mov    %esi,%eax
  801153:	29 d8                	sub    %ebx,%eax
  801155:	50                   	push   %eax
  801156:	89 d8                	mov    %ebx,%eax
  801158:	03 45 0c             	add    0xc(%ebp),%eax
  80115b:	50                   	push   %eax
  80115c:	57                   	push   %edi
  80115d:	e8 4d ff ff ff       	call   8010af <read>
		if (m < 0)
  801162:	83 c4 10             	add    $0x10,%esp
  801165:	85 c0                	test   %eax,%eax
  801167:	78 08                	js     801171 <readn+0x3b>
			return m;
		if (m == 0)
  801169:	85 c0                	test   %eax,%eax
  80116b:	74 06                	je     801173 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80116d:	01 c3                	add    %eax,%ebx
  80116f:	eb d9                	jmp    80114a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801171:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801173:	89 d8                	mov    %ebx,%eax
  801175:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801178:	5b                   	pop    %ebx
  801179:	5e                   	pop    %esi
  80117a:	5f                   	pop    %edi
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
  801180:	53                   	push   %ebx
  801181:	83 ec 14             	sub    $0x14,%esp
  801184:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801187:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80118a:	50                   	push   %eax
  80118b:	53                   	push   %ebx
  80118c:	e8 b1 fc ff ff       	call   800e42 <fd_lookup>
  801191:	83 c4 08             	add    $0x8,%esp
  801194:	85 c0                	test   %eax,%eax
  801196:	78 3a                	js     8011d2 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801198:	83 ec 08             	sub    $0x8,%esp
  80119b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80119e:	50                   	push   %eax
  80119f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011a2:	ff 30                	pushl  (%eax)
  8011a4:	e8 f0 fc ff ff       	call   800e99 <dev_lookup>
  8011a9:	83 c4 10             	add    $0x10,%esp
  8011ac:	85 c0                	test   %eax,%eax
  8011ae:	78 22                	js     8011d2 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8011b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b3:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8011b7:	74 1e                	je     8011d7 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8011b9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011bc:	8b 52 0c             	mov    0xc(%edx),%edx
  8011bf:	85 d2                	test   %edx,%edx
  8011c1:	74 35                	je     8011f8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8011c3:	83 ec 04             	sub    $0x4,%esp
  8011c6:	ff 75 10             	pushl  0x10(%ebp)
  8011c9:	ff 75 0c             	pushl  0xc(%ebp)
  8011cc:	50                   	push   %eax
  8011cd:	ff d2                	call   *%edx
  8011cf:	83 c4 10             	add    $0x10,%esp
}
  8011d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011d5:	c9                   	leave  
  8011d6:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8011d7:	a1 08 40 80 00       	mov    0x804008,%eax
  8011dc:	8b 40 48             	mov    0x48(%eax),%eax
  8011df:	83 ec 04             	sub    $0x4,%esp
  8011e2:	53                   	push   %ebx
  8011e3:	50                   	push   %eax
  8011e4:	68 c9 22 80 00       	push   $0x8022c9
  8011e9:	e8 6c ef ff ff       	call   80015a <cprintf>
		return -E_INVAL;
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011f6:	eb da                	jmp    8011d2 <write+0x55>
		return -E_NOT_SUPP;
  8011f8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011fd:	eb d3                	jmp    8011d2 <write+0x55>

008011ff <seek>:

int
seek(int fdnum, off_t offset)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801205:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801208:	50                   	push   %eax
  801209:	ff 75 08             	pushl  0x8(%ebp)
  80120c:	e8 31 fc ff ff       	call   800e42 <fd_lookup>
  801211:	83 c4 08             	add    $0x8,%esp
  801214:	85 c0                	test   %eax,%eax
  801216:	78 0e                	js     801226 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80121e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801221:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801226:	c9                   	leave  
  801227:	c3                   	ret    

00801228 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801228:	55                   	push   %ebp
  801229:	89 e5                	mov    %esp,%ebp
  80122b:	53                   	push   %ebx
  80122c:	83 ec 14             	sub    $0x14,%esp
  80122f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801232:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801235:	50                   	push   %eax
  801236:	53                   	push   %ebx
  801237:	e8 06 fc ff ff       	call   800e42 <fd_lookup>
  80123c:	83 c4 08             	add    $0x8,%esp
  80123f:	85 c0                	test   %eax,%eax
  801241:	78 37                	js     80127a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801243:	83 ec 08             	sub    $0x8,%esp
  801246:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801249:	50                   	push   %eax
  80124a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124d:	ff 30                	pushl  (%eax)
  80124f:	e8 45 fc ff ff       	call   800e99 <dev_lookup>
  801254:	83 c4 10             	add    $0x10,%esp
  801257:	85 c0                	test   %eax,%eax
  801259:	78 1f                	js     80127a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80125b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80125e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801262:	74 1b                	je     80127f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801264:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801267:	8b 52 18             	mov    0x18(%edx),%edx
  80126a:	85 d2                	test   %edx,%edx
  80126c:	74 32                	je     8012a0 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80126e:	83 ec 08             	sub    $0x8,%esp
  801271:	ff 75 0c             	pushl  0xc(%ebp)
  801274:	50                   	push   %eax
  801275:	ff d2                	call   *%edx
  801277:	83 c4 10             	add    $0x10,%esp
}
  80127a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80127f:	a1 08 40 80 00       	mov    0x804008,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801284:	8b 40 48             	mov    0x48(%eax),%eax
  801287:	83 ec 04             	sub    $0x4,%esp
  80128a:	53                   	push   %ebx
  80128b:	50                   	push   %eax
  80128c:	68 8c 22 80 00       	push   $0x80228c
  801291:	e8 c4 ee ff ff       	call   80015a <cprintf>
		return -E_INVAL;
  801296:	83 c4 10             	add    $0x10,%esp
  801299:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129e:	eb da                	jmp    80127a <ftruncate+0x52>
		return -E_NOT_SUPP;
  8012a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a5:	eb d3                	jmp    80127a <ftruncate+0x52>

008012a7 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8012a7:	55                   	push   %ebp
  8012a8:	89 e5                	mov    %esp,%ebp
  8012aa:	53                   	push   %ebx
  8012ab:	83 ec 14             	sub    $0x14,%esp
  8012ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012b4:	50                   	push   %eax
  8012b5:	ff 75 08             	pushl  0x8(%ebp)
  8012b8:	e8 85 fb ff ff       	call   800e42 <fd_lookup>
  8012bd:	83 c4 08             	add    $0x8,%esp
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	78 4b                	js     80130f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012c4:	83 ec 08             	sub    $0x8,%esp
  8012c7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ca:	50                   	push   %eax
  8012cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ce:	ff 30                	pushl  (%eax)
  8012d0:	e8 c4 fb ff ff       	call   800e99 <dev_lookup>
  8012d5:	83 c4 10             	add    $0x10,%esp
  8012d8:	85 c0                	test   %eax,%eax
  8012da:	78 33                	js     80130f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8012dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012df:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8012e3:	74 2f                	je     801314 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8012e5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8012e8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8012ef:	00 00 00 
	stat->st_type = 0;
  8012f2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8012f9:	00 00 00 
	stat->st_dev = dev;
  8012fc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801302:	83 ec 08             	sub    $0x8,%esp
  801305:	53                   	push   %ebx
  801306:	ff 75 f0             	pushl  -0x10(%ebp)
  801309:	ff 50 14             	call   *0x14(%eax)
  80130c:	83 c4 10             	add    $0x10,%esp
}
  80130f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801312:	c9                   	leave  
  801313:	c3                   	ret    
		return -E_NOT_SUPP;
  801314:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801319:	eb f4                	jmp    80130f <fstat+0x68>

0080131b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	6a 00                	push   $0x0
  801325:	ff 75 08             	pushl  0x8(%ebp)
  801328:	e8 34 02 00 00       	call   801561 <open>
  80132d:	89 c3                	mov    %eax,%ebx
  80132f:	83 c4 10             	add    $0x10,%esp
  801332:	85 c0                	test   %eax,%eax
  801334:	78 1b                	js     801351 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801336:	83 ec 08             	sub    $0x8,%esp
  801339:	ff 75 0c             	pushl  0xc(%ebp)
  80133c:	50                   	push   %eax
  80133d:	e8 65 ff ff ff       	call   8012a7 <fstat>
  801342:	89 c6                	mov    %eax,%esi
	close(fd);
  801344:	89 1c 24             	mov    %ebx,(%esp)
  801347:	e8 29 fc ff ff       	call   800f75 <close>
	return r;
  80134c:	83 c4 10             	add    $0x10,%esp
  80134f:	89 f3                	mov    %esi,%ebx
}
  801351:	89 d8                	mov    %ebx,%eax
  801353:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801356:	5b                   	pop    %ebx
  801357:	5e                   	pop    %esi
  801358:	5d                   	pop    %ebp
  801359:	c3                   	ret    

0080135a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	56                   	push   %esi
  80135e:	53                   	push   %ebx
  80135f:	89 c6                	mov    %eax,%esi
  801361:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801363:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80136a:	74 27                	je     801393 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80136c:	6a 07                	push   $0x7
  80136e:	68 00 50 80 00       	push   $0x805000
  801373:	56                   	push   %esi
  801374:	ff 35 00 40 80 00    	pushl  0x804000
  80137a:	e8 60 08 00 00       	call   801bdf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80137f:	83 c4 0c             	add    $0xc,%esp
  801382:	6a 00                	push   $0x0
  801384:	53                   	push   %ebx
  801385:	6a 00                	push   $0x0
  801387:	e8 ca 07 00 00       	call   801b56 <ipc_recv>
}
  80138c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80138f:	5b                   	pop    %ebx
  801390:	5e                   	pop    %esi
  801391:	5d                   	pop    %ebp
  801392:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801393:	83 ec 0c             	sub    $0xc,%esp
  801396:	6a 01                	push   $0x1
  801398:	e8 9e 08 00 00       	call   801c3b <ipc_find_env>
  80139d:	a3 00 40 80 00       	mov    %eax,0x804000
  8013a2:	83 c4 10             	add    $0x10,%esp
  8013a5:	eb c5                	jmp    80136c <fsipc+0x12>

008013a7 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	8b 40 0c             	mov    0xc(%eax),%eax
  8013b3:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8013c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c5:	b8 02 00 00 00       	mov    $0x2,%eax
  8013ca:	e8 8b ff ff ff       	call   80135a <fsipc>
}
  8013cf:	c9                   	leave  
  8013d0:	c3                   	ret    

008013d1 <devfile_flush>:
{
  8013d1:	55                   	push   %ebp
  8013d2:	89 e5                	mov    %esp,%ebp
  8013d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8013d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013da:	8b 40 0c             	mov    0xc(%eax),%eax
  8013dd:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8013e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013e7:	b8 06 00 00 00       	mov    $0x6,%eax
  8013ec:	e8 69 ff ff ff       	call   80135a <fsipc>
}
  8013f1:	c9                   	leave  
  8013f2:	c3                   	ret    

008013f3 <devfile_stat>:
{
  8013f3:	55                   	push   %ebp
  8013f4:	89 e5                	mov    %esp,%ebp
  8013f6:	53                   	push   %ebx
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8013fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801400:	8b 40 0c             	mov    0xc(%eax),%eax
  801403:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801408:	ba 00 00 00 00       	mov    $0x0,%edx
  80140d:	b8 05 00 00 00       	mov    $0x5,%eax
  801412:	e8 43 ff ff ff       	call   80135a <fsipc>
  801417:	85 c0                	test   %eax,%eax
  801419:	78 2c                	js     801447 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80141b:	83 ec 08             	sub    $0x8,%esp
  80141e:	68 00 50 80 00       	push   $0x805000
  801423:	53                   	push   %ebx
  801424:	e8 39 f3 ff ff       	call   800762 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801429:	a1 80 50 80 00       	mov    0x805080,%eax
  80142e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801434:	a1 84 50 80 00       	mov    0x805084,%eax
  801439:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  80143f:	83 c4 10             	add    $0x10,%esp
  801442:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801447:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80144a:	c9                   	leave  
  80144b:	c3                   	ret    

0080144c <devfile_write>:
{
  80144c:	55                   	push   %ebp
  80144d:	89 e5                	mov    %esp,%ebp
  80144f:	53                   	push   %ebx
  801450:	83 ec 04             	sub    $0x4,%esp
  801453:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801456:	89 d8                	mov    %ebx,%eax
  801458:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80145e:	76 05                	jbe    801465 <devfile_write+0x19>
  801460:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801465:	8b 55 08             	mov    0x8(%ebp),%edx
  801468:	8b 52 0c             	mov    0xc(%edx),%edx
  80146b:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801471:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801476:	83 ec 04             	sub    $0x4,%esp
  801479:	50                   	push   %eax
  80147a:	ff 75 0c             	pushl  0xc(%ebp)
  80147d:	68 08 50 80 00       	push   $0x805008
  801482:	e8 4e f4 ff ff       	call   8008d5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801487:	ba 00 00 00 00       	mov    $0x0,%edx
  80148c:	b8 04 00 00 00       	mov    $0x4,%eax
  801491:	e8 c4 fe ff ff       	call   80135a <fsipc>
  801496:	83 c4 10             	add    $0x10,%esp
  801499:	85 c0                	test   %eax,%eax
  80149b:	78 0b                	js     8014a8 <devfile_write+0x5c>
	assert(r <= n);
  80149d:	39 c3                	cmp    %eax,%ebx
  80149f:	72 0c                	jb     8014ad <devfile_write+0x61>
	assert(r <= PGSIZE);
  8014a1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8014a6:	7f 1e                	jg     8014c6 <devfile_write+0x7a>
}
  8014a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ab:	c9                   	leave  
  8014ac:	c3                   	ret    
	assert(r <= n);
  8014ad:	68 f8 22 80 00       	push   $0x8022f8
  8014b2:	68 ff 22 80 00       	push   $0x8022ff
  8014b7:	68 98 00 00 00       	push   $0x98
  8014bc:	68 14 23 80 00       	push   $0x802314
  8014c1:	e8 11 06 00 00       	call   801ad7 <_panic>
	assert(r <= PGSIZE);
  8014c6:	68 1f 23 80 00       	push   $0x80231f
  8014cb:	68 ff 22 80 00       	push   $0x8022ff
  8014d0:	68 99 00 00 00       	push   $0x99
  8014d5:	68 14 23 80 00       	push   $0x802314
  8014da:	e8 f8 05 00 00       	call   801ad7 <_panic>

008014df <devfile_read>:
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	56                   	push   %esi
  8014e3:	53                   	push   %ebx
  8014e4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8014e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ed:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8014f2:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8014f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8014fd:	b8 03 00 00 00       	mov    $0x3,%eax
  801502:	e8 53 fe ff ff       	call   80135a <fsipc>
  801507:	89 c3                	mov    %eax,%ebx
  801509:	85 c0                	test   %eax,%eax
  80150b:	78 1f                	js     80152c <devfile_read+0x4d>
	assert(r <= n);
  80150d:	39 c6                	cmp    %eax,%esi
  80150f:	72 24                	jb     801535 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801511:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801516:	7f 33                	jg     80154b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801518:	83 ec 04             	sub    $0x4,%esp
  80151b:	50                   	push   %eax
  80151c:	68 00 50 80 00       	push   $0x805000
  801521:	ff 75 0c             	pushl  0xc(%ebp)
  801524:	e8 ac f3 ff ff       	call   8008d5 <memmove>
	return r;
  801529:	83 c4 10             	add    $0x10,%esp
}
  80152c:	89 d8                	mov    %ebx,%eax
  80152e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801531:	5b                   	pop    %ebx
  801532:	5e                   	pop    %esi
  801533:	5d                   	pop    %ebp
  801534:	c3                   	ret    
	assert(r <= n);
  801535:	68 f8 22 80 00       	push   $0x8022f8
  80153a:	68 ff 22 80 00       	push   $0x8022ff
  80153f:	6a 7c                	push   $0x7c
  801541:	68 14 23 80 00       	push   $0x802314
  801546:	e8 8c 05 00 00       	call   801ad7 <_panic>
	assert(r <= PGSIZE);
  80154b:	68 1f 23 80 00       	push   $0x80231f
  801550:	68 ff 22 80 00       	push   $0x8022ff
  801555:	6a 7d                	push   $0x7d
  801557:	68 14 23 80 00       	push   $0x802314
  80155c:	e8 76 05 00 00       	call   801ad7 <_panic>

00801561 <open>:
{
  801561:	55                   	push   %ebp
  801562:	89 e5                	mov    %esp,%ebp
  801564:	56                   	push   %esi
  801565:	53                   	push   %ebx
  801566:	83 ec 1c             	sub    $0x1c,%esp
  801569:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80156c:	56                   	push   %esi
  80156d:	e8 bd f1 ff ff       	call   80072f <strlen>
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80157a:	7f 6c                	jg     8015e8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80157c:	83 ec 0c             	sub    $0xc,%esp
  80157f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801582:	50                   	push   %eax
  801583:	e8 6b f8 ff ff       	call   800df3 <fd_alloc>
  801588:	89 c3                	mov    %eax,%ebx
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	85 c0                	test   %eax,%eax
  80158f:	78 3c                	js     8015cd <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801591:	83 ec 08             	sub    $0x8,%esp
  801594:	56                   	push   %esi
  801595:	68 00 50 80 00       	push   $0x805000
  80159a:	e8 c3 f1 ff ff       	call   800762 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80159f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a2:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8015a7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8015af:	e8 a6 fd ff ff       	call   80135a <fsipc>
  8015b4:	89 c3                	mov    %eax,%ebx
  8015b6:	83 c4 10             	add    $0x10,%esp
  8015b9:	85 c0                	test   %eax,%eax
  8015bb:	78 19                	js     8015d6 <open+0x75>
	return fd2num(fd);
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8015c3:	e8 04 f8 ff ff       	call   800dcc <fd2num>
  8015c8:	89 c3                	mov    %eax,%ebx
  8015ca:	83 c4 10             	add    $0x10,%esp
}
  8015cd:	89 d8                	mov    %ebx,%eax
  8015cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d2:	5b                   	pop    %ebx
  8015d3:	5e                   	pop    %esi
  8015d4:	5d                   	pop    %ebp
  8015d5:	c3                   	ret    
		fd_close(fd, 0);
  8015d6:	83 ec 08             	sub    $0x8,%esp
  8015d9:	6a 00                	push   $0x0
  8015db:	ff 75 f4             	pushl  -0xc(%ebp)
  8015de:	e8 0c f9 ff ff       	call   800eef <fd_close>
		return r;
  8015e3:	83 c4 10             	add    $0x10,%esp
  8015e6:	eb e5                	jmp    8015cd <open+0x6c>
		return -E_BAD_PATH;
  8015e8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8015ed:	eb de                	jmp    8015cd <open+0x6c>

008015ef <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8015ef:	55                   	push   %ebp
  8015f0:	89 e5                	mov    %esp,%ebp
  8015f2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8015f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8015fa:	b8 08 00 00 00       	mov    $0x8,%eax
  8015ff:	e8 56 fd ff ff       	call   80135a <fsipc>
}
  801604:	c9                   	leave  
  801605:	c3                   	ret    

00801606 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801606:	55                   	push   %ebp
  801607:	89 e5                	mov    %esp,%ebp
  801609:	56                   	push   %esi
  80160a:	53                   	push   %ebx
  80160b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80160e:	83 ec 0c             	sub    $0xc,%esp
  801611:	ff 75 08             	pushl  0x8(%ebp)
  801614:	e8 c3 f7 ff ff       	call   800ddc <fd2data>
  801619:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  80161b:	83 c4 08             	add    $0x8,%esp
  80161e:	68 2b 23 80 00       	push   $0x80232b
  801623:	53                   	push   %ebx
  801624:	e8 39 f1 ff ff       	call   800762 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801629:	8b 46 04             	mov    0x4(%esi),%eax
  80162c:	2b 06                	sub    (%esi),%eax
  80162e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801634:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  80163b:	10 00 00 
	stat->st_dev = &devpipe;
  80163e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801645:	30 80 00 
	return 0;
}
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801650:	5b                   	pop    %ebx
  801651:	5e                   	pop    %esi
  801652:	5d                   	pop    %ebp
  801653:	c3                   	ret    

00801654 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801654:	55                   	push   %ebp
  801655:	89 e5                	mov    %esp,%ebp
  801657:	53                   	push   %ebx
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80165e:	53                   	push   %ebx
  80165f:	6a 00                	push   $0x0
  801661:	e8 36 f5 ff ff       	call   800b9c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801666:	89 1c 24             	mov    %ebx,(%esp)
  801669:	e8 6e f7 ff ff       	call   800ddc <fd2data>
  80166e:	83 c4 08             	add    $0x8,%esp
  801671:	50                   	push   %eax
  801672:	6a 00                	push   $0x0
  801674:	e8 23 f5 ff ff       	call   800b9c <sys_page_unmap>
}
  801679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80167c:	c9                   	leave  
  80167d:	c3                   	ret    

0080167e <_pipeisclosed>:
{
  80167e:	55                   	push   %ebp
  80167f:	89 e5                	mov    %esp,%ebp
  801681:	57                   	push   %edi
  801682:	56                   	push   %esi
  801683:	53                   	push   %ebx
  801684:	83 ec 1c             	sub    $0x1c,%esp
  801687:	89 c7                	mov    %eax,%edi
  801689:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  80168b:	a1 08 40 80 00       	mov    0x804008,%eax
  801690:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801693:	83 ec 0c             	sub    $0xc,%esp
  801696:	57                   	push   %edi
  801697:	e8 e1 05 00 00       	call   801c7d <pageref>
  80169c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80169f:	89 34 24             	mov    %esi,(%esp)
  8016a2:	e8 d6 05 00 00       	call   801c7d <pageref>
		nn = thisenv->env_runs;
  8016a7:	8b 15 08 40 80 00    	mov    0x804008,%edx
  8016ad:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8016b0:	83 c4 10             	add    $0x10,%esp
  8016b3:	39 cb                	cmp    %ecx,%ebx
  8016b5:	74 1b                	je     8016d2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8016b7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016ba:	75 cf                	jne    80168b <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8016bc:	8b 42 58             	mov    0x58(%edx),%eax
  8016bf:	6a 01                	push   $0x1
  8016c1:	50                   	push   %eax
  8016c2:	53                   	push   %ebx
  8016c3:	68 32 23 80 00       	push   $0x802332
  8016c8:	e8 8d ea ff ff       	call   80015a <cprintf>
  8016cd:	83 c4 10             	add    $0x10,%esp
  8016d0:	eb b9                	jmp    80168b <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8016d2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8016d5:	0f 94 c0             	sete   %al
  8016d8:	0f b6 c0             	movzbl %al,%eax
}
  8016db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016de:	5b                   	pop    %ebx
  8016df:	5e                   	pop    %esi
  8016e0:	5f                   	pop    %edi
  8016e1:	5d                   	pop    %ebp
  8016e2:	c3                   	ret    

008016e3 <devpipe_write>:
{
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	57                   	push   %edi
  8016e7:	56                   	push   %esi
  8016e8:	53                   	push   %ebx
  8016e9:	83 ec 18             	sub    $0x18,%esp
  8016ec:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8016ef:	56                   	push   %esi
  8016f0:	e8 e7 f6 ff ff       	call   800ddc <fd2data>
  8016f5:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8016f7:	83 c4 10             	add    $0x10,%esp
  8016fa:	bf 00 00 00 00       	mov    $0x0,%edi
  8016ff:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801702:	74 41                	je     801745 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801704:	8b 53 04             	mov    0x4(%ebx),%edx
  801707:	8b 03                	mov    (%ebx),%eax
  801709:	83 c0 20             	add    $0x20,%eax
  80170c:	39 c2                	cmp    %eax,%edx
  80170e:	72 14                	jb     801724 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801710:	89 da                	mov    %ebx,%edx
  801712:	89 f0                	mov    %esi,%eax
  801714:	e8 65 ff ff ff       	call   80167e <_pipeisclosed>
  801719:	85 c0                	test   %eax,%eax
  80171b:	75 2c                	jne    801749 <devpipe_write+0x66>
			sys_yield();
  80171d:	e8 bc f4 ff ff       	call   800bde <sys_yield>
  801722:	eb e0                	jmp    801704 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801724:	8b 45 0c             	mov    0xc(%ebp),%eax
  801727:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  80172a:	89 d0                	mov    %edx,%eax
  80172c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801731:	78 0b                	js     80173e <devpipe_write+0x5b>
  801733:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801737:	42                   	inc    %edx
  801738:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  80173b:	47                   	inc    %edi
  80173c:	eb c1                	jmp    8016ff <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80173e:	48                   	dec    %eax
  80173f:	83 c8 e0             	or     $0xffffffe0,%eax
  801742:	40                   	inc    %eax
  801743:	eb ee                	jmp    801733 <devpipe_write+0x50>
	return i;
  801745:	89 f8                	mov    %edi,%eax
  801747:	eb 05                	jmp    80174e <devpipe_write+0x6b>
				return 0;
  801749:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801751:	5b                   	pop    %ebx
  801752:	5e                   	pop    %esi
  801753:	5f                   	pop    %edi
  801754:	5d                   	pop    %ebp
  801755:	c3                   	ret    

00801756 <devpipe_read>:
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	57                   	push   %edi
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
  80175c:	83 ec 18             	sub    $0x18,%esp
  80175f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801762:	57                   	push   %edi
  801763:	e8 74 f6 ff ff       	call   800ddc <fd2data>
  801768:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801772:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801775:	74 46                	je     8017bd <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801777:	8b 06                	mov    (%esi),%eax
  801779:	3b 46 04             	cmp    0x4(%esi),%eax
  80177c:	75 22                	jne    8017a0 <devpipe_read+0x4a>
			if (i > 0)
  80177e:	85 db                	test   %ebx,%ebx
  801780:	74 0a                	je     80178c <devpipe_read+0x36>
				return i;
  801782:	89 d8                	mov    %ebx,%eax
}
  801784:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801787:	5b                   	pop    %ebx
  801788:	5e                   	pop    %esi
  801789:	5f                   	pop    %edi
  80178a:	5d                   	pop    %ebp
  80178b:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  80178c:	89 f2                	mov    %esi,%edx
  80178e:	89 f8                	mov    %edi,%eax
  801790:	e8 e9 fe ff ff       	call   80167e <_pipeisclosed>
  801795:	85 c0                	test   %eax,%eax
  801797:	75 28                	jne    8017c1 <devpipe_read+0x6b>
			sys_yield();
  801799:	e8 40 f4 ff ff       	call   800bde <sys_yield>
  80179e:	eb d7                	jmp    801777 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017a0:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8017a5:	78 0f                	js     8017b6 <devpipe_read+0x60>
  8017a7:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8017ab:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017ae:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8017b1:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8017b3:	43                   	inc    %ebx
  8017b4:	eb bc                	jmp    801772 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8017b6:	48                   	dec    %eax
  8017b7:	83 c8 e0             	or     $0xffffffe0,%eax
  8017ba:	40                   	inc    %eax
  8017bb:	eb ea                	jmp    8017a7 <devpipe_read+0x51>
	return i;
  8017bd:	89 d8                	mov    %ebx,%eax
  8017bf:	eb c3                	jmp    801784 <devpipe_read+0x2e>
				return 0;
  8017c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c6:	eb bc                	jmp    801784 <devpipe_read+0x2e>

008017c8 <pipe>:
{
  8017c8:	55                   	push   %ebp
  8017c9:	89 e5                	mov    %esp,%ebp
  8017cb:	56                   	push   %esi
  8017cc:	53                   	push   %ebx
  8017cd:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8017d0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017d3:	50                   	push   %eax
  8017d4:	e8 1a f6 ff ff       	call   800df3 <fd_alloc>
  8017d9:	89 c3                	mov    %eax,%ebx
  8017db:	83 c4 10             	add    $0x10,%esp
  8017de:	85 c0                	test   %eax,%eax
  8017e0:	0f 88 2a 01 00 00    	js     801910 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8017e6:	83 ec 04             	sub    $0x4,%esp
  8017e9:	68 07 04 00 00       	push   $0x407
  8017ee:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f1:	6a 00                	push   $0x0
  8017f3:	e8 1f f3 ff ff       	call   800b17 <sys_page_alloc>
  8017f8:	89 c3                	mov    %eax,%ebx
  8017fa:	83 c4 10             	add    $0x10,%esp
  8017fd:	85 c0                	test   %eax,%eax
  8017ff:	0f 88 0b 01 00 00    	js     801910 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801805:	83 ec 0c             	sub    $0xc,%esp
  801808:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80180b:	50                   	push   %eax
  80180c:	e8 e2 f5 ff ff       	call   800df3 <fd_alloc>
  801811:	89 c3                	mov    %eax,%ebx
  801813:	83 c4 10             	add    $0x10,%esp
  801816:	85 c0                	test   %eax,%eax
  801818:	0f 88 e2 00 00 00    	js     801900 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80181e:	83 ec 04             	sub    $0x4,%esp
  801821:	68 07 04 00 00       	push   $0x407
  801826:	ff 75 f0             	pushl  -0x10(%ebp)
  801829:	6a 00                	push   $0x0
  80182b:	e8 e7 f2 ff ff       	call   800b17 <sys_page_alloc>
  801830:	89 c3                	mov    %eax,%ebx
  801832:	83 c4 10             	add    $0x10,%esp
  801835:	85 c0                	test   %eax,%eax
  801837:	0f 88 c3 00 00 00    	js     801900 <pipe+0x138>
	va = fd2data(fd0);
  80183d:	83 ec 0c             	sub    $0xc,%esp
  801840:	ff 75 f4             	pushl  -0xc(%ebp)
  801843:	e8 94 f5 ff ff       	call   800ddc <fd2data>
  801848:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80184a:	83 c4 0c             	add    $0xc,%esp
  80184d:	68 07 04 00 00       	push   $0x407
  801852:	50                   	push   %eax
  801853:	6a 00                	push   $0x0
  801855:	e8 bd f2 ff ff       	call   800b17 <sys_page_alloc>
  80185a:	89 c3                	mov    %eax,%ebx
  80185c:	83 c4 10             	add    $0x10,%esp
  80185f:	85 c0                	test   %eax,%eax
  801861:	0f 88 89 00 00 00    	js     8018f0 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801867:	83 ec 0c             	sub    $0xc,%esp
  80186a:	ff 75 f0             	pushl  -0x10(%ebp)
  80186d:	e8 6a f5 ff ff       	call   800ddc <fd2data>
  801872:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801879:	50                   	push   %eax
  80187a:	6a 00                	push   $0x0
  80187c:	56                   	push   %esi
  80187d:	6a 00                	push   $0x0
  80187f:	e8 d6 f2 ff ff       	call   800b5a <sys_page_map>
  801884:	89 c3                	mov    %eax,%ebx
  801886:	83 c4 20             	add    $0x20,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	78 55                	js     8018e2 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80188d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801896:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80189b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8018a2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  8018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ab:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8018ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018b0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8018b7:	83 ec 0c             	sub    $0xc,%esp
  8018ba:	ff 75 f4             	pushl  -0xc(%ebp)
  8018bd:	e8 0a f5 ff ff       	call   800dcc <fd2num>
  8018c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8018c7:	83 c4 04             	add    $0x4,%esp
  8018ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cd:	e8 fa f4 ff ff       	call   800dcc <fd2num>
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  8018d8:	83 c4 10             	add    $0x10,%esp
  8018db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018e0:	eb 2e                	jmp    801910 <pipe+0x148>
	sys_page_unmap(0, va);
  8018e2:	83 ec 08             	sub    $0x8,%esp
  8018e5:	56                   	push   %esi
  8018e6:	6a 00                	push   $0x0
  8018e8:	e8 af f2 ff ff       	call   800b9c <sys_page_unmap>
  8018ed:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  8018f0:	83 ec 08             	sub    $0x8,%esp
  8018f3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f6:	6a 00                	push   $0x0
  8018f8:	e8 9f f2 ff ff       	call   800b9c <sys_page_unmap>
  8018fd:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801900:	83 ec 08             	sub    $0x8,%esp
  801903:	ff 75 f4             	pushl  -0xc(%ebp)
  801906:	6a 00                	push   $0x0
  801908:	e8 8f f2 ff ff       	call   800b9c <sys_page_unmap>
  80190d:	83 c4 10             	add    $0x10,%esp
}
  801910:	89 d8                	mov    %ebx,%eax
  801912:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801915:	5b                   	pop    %ebx
  801916:	5e                   	pop    %esi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <pipeisclosed>:
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80191f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801922:	50                   	push   %eax
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	e8 17 f5 ff ff       	call   800e42 <fd_lookup>
  80192b:	83 c4 10             	add    $0x10,%esp
  80192e:	85 c0                	test   %eax,%eax
  801930:	78 18                	js     80194a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801932:	83 ec 0c             	sub    $0xc,%esp
  801935:	ff 75 f4             	pushl  -0xc(%ebp)
  801938:	e8 9f f4 ff ff       	call   800ddc <fd2data>
	return _pipeisclosed(fd, p);
  80193d:	89 c2                	mov    %eax,%edx
  80193f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801942:	e8 37 fd ff ff       	call   80167e <_pipeisclosed>
  801947:	83 c4 10             	add    $0x10,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80194f:	b8 00 00 00 00       	mov    $0x0,%eax
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	53                   	push   %ebx
  80195a:	83 ec 0c             	sub    $0xc,%esp
  80195d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801960:	68 4a 23 80 00       	push   $0x80234a
  801965:	53                   	push   %ebx
  801966:	e8 f7 ed ff ff       	call   800762 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  80196b:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801972:	20 00 00 
	return 0;
}
  801975:	b8 00 00 00 00       	mov    $0x0,%eax
  80197a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <devcons_write>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	57                   	push   %edi
  801983:	56                   	push   %esi
  801984:	53                   	push   %ebx
  801985:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  80198b:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801990:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801996:	eb 1d                	jmp    8019b5 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801998:	83 ec 04             	sub    $0x4,%esp
  80199b:	53                   	push   %ebx
  80199c:	03 45 0c             	add    0xc(%ebp),%eax
  80199f:	50                   	push   %eax
  8019a0:	57                   	push   %edi
  8019a1:	e8 2f ef ff ff       	call   8008d5 <memmove>
		sys_cputs(buf, m);
  8019a6:	83 c4 08             	add    $0x8,%esp
  8019a9:	53                   	push   %ebx
  8019aa:	57                   	push   %edi
  8019ab:	e8 ca f0 ff ff       	call   800a7a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8019b0:	01 de                	add    %ebx,%esi
  8019b2:	83 c4 10             	add    $0x10,%esp
  8019b5:	89 f0                	mov    %esi,%eax
  8019b7:	3b 75 10             	cmp    0x10(%ebp),%esi
  8019ba:	73 11                	jae    8019cd <devcons_write+0x4e>
		m = n - tot;
  8019bc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8019bf:	29 f3                	sub    %esi,%ebx
  8019c1:	83 fb 7f             	cmp    $0x7f,%ebx
  8019c4:	76 d2                	jbe    801998 <devcons_write+0x19>
  8019c6:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  8019cb:	eb cb                	jmp    801998 <devcons_write+0x19>
}
  8019cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019d0:	5b                   	pop    %ebx
  8019d1:	5e                   	pop    %esi
  8019d2:	5f                   	pop    %edi
  8019d3:	5d                   	pop    %ebp
  8019d4:	c3                   	ret    

008019d5 <devcons_read>:
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
  8019d8:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8019db:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8019df:	75 0c                	jne    8019ed <devcons_read+0x18>
		return 0;
  8019e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e6:	eb 21                	jmp    801a09 <devcons_read+0x34>
		sys_yield();
  8019e8:	e8 f1 f1 ff ff       	call   800bde <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8019ed:	e8 a6 f0 ff ff       	call   800a98 <sys_cgetc>
  8019f2:	85 c0                	test   %eax,%eax
  8019f4:	74 f2                	je     8019e8 <devcons_read+0x13>
	if (c < 0)
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	78 0f                	js     801a09 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8019fa:	83 f8 04             	cmp    $0x4,%eax
  8019fd:	74 0c                	je     801a0b <devcons_read+0x36>
	*(char*)vbuf = c;
  8019ff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a02:	88 02                	mov    %al,(%edx)
	return 1;
  801a04:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    
		return 0;
  801a0b:	b8 00 00 00 00       	mov    $0x0,%eax
  801a10:	eb f7                	jmp    801a09 <devcons_read+0x34>

00801a12 <cputchar>:
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
  801a15:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801a18:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801a1e:	6a 01                	push   $0x1
  801a20:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a23:	50                   	push   %eax
  801a24:	e8 51 f0 ff ff       	call   800a7a <sys_cputs>
}
  801a29:	83 c4 10             	add    $0x10,%esp
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <getchar>:
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801a34:	6a 01                	push   $0x1
  801a36:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801a39:	50                   	push   %eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	e8 6e f6 ff ff       	call   8010af <read>
	if (r < 0)
  801a41:	83 c4 10             	add    $0x10,%esp
  801a44:	85 c0                	test   %eax,%eax
  801a46:	78 08                	js     801a50 <getchar+0x22>
	if (r < 1)
  801a48:	85 c0                	test   %eax,%eax
  801a4a:	7e 06                	jle    801a52 <getchar+0x24>
	return c;
  801a4c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801a50:	c9                   	leave  
  801a51:	c3                   	ret    
		return -E_EOF;
  801a52:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801a57:	eb f7                	jmp    801a50 <getchar+0x22>

00801a59 <iscons>:
{
  801a59:	55                   	push   %ebp
  801a5a:	89 e5                	mov    %esp,%ebp
  801a5c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 d7 f3 ff ff       	call   800e42 <fd_lookup>
  801a6b:	83 c4 10             	add    $0x10,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 11                	js     801a83 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a75:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801a7b:	39 10                	cmp    %edx,(%eax)
  801a7d:	0f 94 c0             	sete   %al
  801a80:	0f b6 c0             	movzbl %al,%eax
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <opencons>:
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801a8b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a8e:	50                   	push   %eax
  801a8f:	e8 5f f3 ff ff       	call   800df3 <fd_alloc>
  801a94:	83 c4 10             	add    $0x10,%esp
  801a97:	85 c0                	test   %eax,%eax
  801a99:	78 3a                	js     801ad5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801a9b:	83 ec 04             	sub    $0x4,%esp
  801a9e:	68 07 04 00 00       	push   $0x407
  801aa3:	ff 75 f4             	pushl  -0xc(%ebp)
  801aa6:	6a 00                	push   $0x0
  801aa8:	e8 6a f0 ff ff       	call   800b17 <sys_page_alloc>
  801aad:	83 c4 10             	add    $0x10,%esp
  801ab0:	85 c0                	test   %eax,%eax
  801ab2:	78 21                	js     801ad5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801ab4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801aba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801abd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ac2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801ac9:	83 ec 0c             	sub    $0xc,%esp
  801acc:	50                   	push   %eax
  801acd:	e8 fa f2 ff ff       	call   800dcc <fd2num>
  801ad2:	83 c4 10             	add    $0x10,%esp
}
  801ad5:	c9                   	leave  
  801ad6:	c3                   	ret    

00801ad7 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ad7:	55                   	push   %ebp
  801ad8:	89 e5                	mov    %esp,%ebp
  801ada:	57                   	push   %edi
  801adb:	56                   	push   %esi
  801adc:	53                   	push   %ebx
  801add:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801ae3:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801ae6:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801aec:	e8 07 f0 ff ff       	call   800af8 <sys_getenvid>
  801af1:	83 ec 04             	sub    $0x4,%esp
  801af4:	ff 75 0c             	pushl  0xc(%ebp)
  801af7:	ff 75 08             	pushl  0x8(%ebp)
  801afa:	53                   	push   %ebx
  801afb:	50                   	push   %eax
  801afc:	68 58 23 80 00       	push   $0x802358
  801b01:	68 00 01 00 00       	push   $0x100
  801b06:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801b0c:	56                   	push   %esi
  801b0d:	e8 03 ec ff ff       	call   800715 <snprintf>
  801b12:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801b14:	83 c4 20             	add    $0x20,%esp
  801b17:	57                   	push   %edi
  801b18:	ff 75 10             	pushl  0x10(%ebp)
  801b1b:	bf 00 01 00 00       	mov    $0x100,%edi
  801b20:	89 f8                	mov    %edi,%eax
  801b22:	29 d8                	sub    %ebx,%eax
  801b24:	50                   	push   %eax
  801b25:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b28:	50                   	push   %eax
  801b29:	e8 92 eb ff ff       	call   8006c0 <vsnprintf>
  801b2e:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b30:	83 c4 0c             	add    $0xc,%esp
  801b33:	68 2c 1f 80 00       	push   $0x801f2c
  801b38:	29 df                	sub    %ebx,%edi
  801b3a:	57                   	push   %edi
  801b3b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801b3e:	50                   	push   %eax
  801b3f:	e8 d1 eb ff ff       	call   800715 <snprintf>
	sys_cputs(buf, r);
  801b44:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801b47:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801b49:	53                   	push   %ebx
  801b4a:	56                   	push   %esi
  801b4b:	e8 2a ef ff ff       	call   800a7a <sys_cputs>
  801b50:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801b53:	cc                   	int3   
  801b54:	eb fd                	jmp    801b53 <_panic+0x7c>

00801b56 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b56:	55                   	push   %ebp
  801b57:	89 e5                	mov    %esp,%ebp
  801b59:	57                   	push   %edi
  801b5a:	56                   	push   %esi
  801b5b:	53                   	push   %ebx
  801b5c:	83 ec 0c             	sub    $0xc,%esp
  801b5f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b62:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b65:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b68:	85 ff                	test   %edi,%edi
  801b6a:	74 53                	je     801bbf <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b6c:	83 ec 0c             	sub    $0xc,%esp
  801b6f:	57                   	push   %edi
  801b70:	e8 b2 f1 ff ff       	call   800d27 <sys_ipc_recv>
  801b75:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b78:	85 db                	test   %ebx,%ebx
  801b7a:	74 0b                	je     801b87 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b7c:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b82:	8b 52 74             	mov    0x74(%edx),%edx
  801b85:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b87:	85 f6                	test   %esi,%esi
  801b89:	74 0f                	je     801b9a <ipc_recv+0x44>
  801b8b:	85 ff                	test   %edi,%edi
  801b8d:	74 0b                	je     801b9a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b8f:	8b 15 08 40 80 00    	mov    0x804008,%edx
  801b95:	8b 52 78             	mov    0x78(%edx),%edx
  801b98:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b9a:	85 c0                	test   %eax,%eax
  801b9c:	74 30                	je     801bce <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b9e:	85 db                	test   %ebx,%ebx
  801ba0:	74 06                	je     801ba8 <ipc_recv+0x52>
      		*from_env_store = 0;
  801ba2:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801ba8:	85 f6                	test   %esi,%esi
  801baa:	74 2c                	je     801bd8 <ipc_recv+0x82>
      		*perm_store = 0;
  801bac:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801bb2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801bb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bba:	5b                   	pop    %ebx
  801bbb:	5e                   	pop    %esi
  801bbc:	5f                   	pop    %edi
  801bbd:	5d                   	pop    %ebp
  801bbe:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	6a ff                	push   $0xffffffff
  801bc4:	e8 5e f1 ff ff       	call   800d27 <sys_ipc_recv>
  801bc9:	83 c4 10             	add    $0x10,%esp
  801bcc:	eb aa                	jmp    801b78 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bce:	a1 08 40 80 00       	mov    0x804008,%eax
  801bd3:	8b 40 70             	mov    0x70(%eax),%eax
  801bd6:	eb df                	jmp    801bb7 <ipc_recv+0x61>
		return -1;
  801bd8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bdd:	eb d8                	jmp    801bb7 <ipc_recv+0x61>

00801bdf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
  801be2:	57                   	push   %edi
  801be3:	56                   	push   %esi
  801be4:	53                   	push   %ebx
  801be5:	83 ec 0c             	sub    $0xc,%esp
  801be8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801beb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bee:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bf1:	85 db                	test   %ebx,%ebx
  801bf3:	75 22                	jne    801c17 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bf5:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bfa:	eb 1b                	jmp    801c17 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bfc:	68 7c 23 80 00       	push   $0x80237c
  801c01:	68 ff 22 80 00       	push   $0x8022ff
  801c06:	6a 48                	push   $0x48
  801c08:	68 a0 23 80 00       	push   $0x8023a0
  801c0d:	e8 c5 fe ff ff       	call   801ad7 <_panic>
		sys_yield();
  801c12:	e8 c7 ef ff ff       	call   800bde <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c17:	57                   	push   %edi
  801c18:	53                   	push   %ebx
  801c19:	56                   	push   %esi
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 e2 f0 ff ff       	call   800d04 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c28:	74 e8                	je     801c12 <ipc_send+0x33>
  801c2a:	85 c0                	test   %eax,%eax
  801c2c:	75 ce                	jne    801bfc <ipc_send+0x1d>
		sys_yield();
  801c2e:	e8 ab ef ff ff       	call   800bde <sys_yield>
		
	}
	
}
  801c33:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c36:	5b                   	pop    %ebx
  801c37:	5e                   	pop    %esi
  801c38:	5f                   	pop    %edi
  801c39:	5d                   	pop    %ebp
  801c3a:	c3                   	ret    

00801c3b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c46:	89 c2                	mov    %eax,%edx
  801c48:	c1 e2 05             	shl    $0x5,%edx
  801c4b:	29 c2                	sub    %eax,%edx
  801c4d:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c54:	8b 52 50             	mov    0x50(%edx),%edx
  801c57:	39 ca                	cmp    %ecx,%edx
  801c59:	74 0f                	je     801c6a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c5b:	40                   	inc    %eax
  801c5c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c61:	75 e3                	jne    801c46 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c63:	b8 00 00 00 00       	mov    $0x0,%eax
  801c68:	eb 11                	jmp    801c7b <ipc_find_env+0x40>
			return envs[i].env_id;
  801c6a:	89 c2                	mov    %eax,%edx
  801c6c:	c1 e2 05             	shl    $0x5,%edx
  801c6f:	29 c2                	sub    %eax,%edx
  801c71:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c78:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c7b:	5d                   	pop    %ebp
  801c7c:	c3                   	ret    

00801c7d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c7d:	55                   	push   %ebp
  801c7e:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c80:	8b 45 08             	mov    0x8(%ebp),%eax
  801c83:	c1 e8 16             	shr    $0x16,%eax
  801c86:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c8d:	a8 01                	test   $0x1,%al
  801c8f:	74 21                	je     801cb2 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c91:	8b 45 08             	mov    0x8(%ebp),%eax
  801c94:	c1 e8 0c             	shr    $0xc,%eax
  801c97:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c9e:	a8 01                	test   $0x1,%al
  801ca0:	74 17                	je     801cb9 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca2:	c1 e8 0c             	shr    $0xc,%eax
  801ca5:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801cac:	ef 
  801cad:	0f b7 c0             	movzwl %ax,%eax
  801cb0:	eb 05                	jmp    801cb7 <pageref+0x3a>
		return 0;
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cb7:	5d                   	pop    %ebp
  801cb8:	c3                   	ret    
		return 0;
  801cb9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cbe:	eb f7                	jmp    801cb7 <pageref+0x3a>

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
