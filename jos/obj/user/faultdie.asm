
obj/user/faultdie.debug:     file format elf32-i386


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
  80002c:	e8 4f 00 00 00       	call   800080 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <handler>:

#include <inc/lib.h>

void
handler(struct UTrapframe *utf)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
  800039:	8b 55 08             	mov    0x8(%ebp),%edx
	void *addr = (void*)utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	cprintf("i faulted at va %x, err %x\n", addr, err & 7);
  80003c:	8b 42 04             	mov    0x4(%edx),%eax
  80003f:	83 e0 07             	and    $0x7,%eax
  800042:	50                   	push   %eax
  800043:	ff 32                	pushl  (%edx)
  800045:	68 a0 1f 80 00       	push   $0x801fa0
  80004a:	e8 2b 01 00 00       	call   80017a <cprintf>
	sys_env_destroy(sys_getenvid());
  80004f:	e8 c4 0a 00 00       	call   800b18 <sys_getenvid>
  800054:	89 04 24             	mov    %eax,(%esp)
  800057:	e8 7b 0a 00 00       	call   800ad7 <sys_env_destroy>
}
  80005c:	83 c4 10             	add    $0x10,%esp
  80005f:	c9                   	leave  
  800060:	c3                   	ret    

00800061 <umain>:

void
umain(int argc, char **argv)
{
  800061:	55                   	push   %ebp
  800062:	89 e5                	mov    %esp,%ebp
  800064:	83 ec 14             	sub    $0x14,%esp
	set_pgfault_handler(handler);
  800067:	68 33 00 80 00       	push   $0x800033
  80006c:	e8 7b 0d 00 00       	call   800dec <set_pgfault_handler>
	*(int*)0xDeadBeef = 0;
  800071:	c7 05 ef be ad de 00 	movl   $0x0,0xdeadbeef
  800078:	00 00 00 
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	c9                   	leave  
  80007f:	c3                   	ret    

00800080 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800080:	55                   	push   %ebp
  800081:	89 e5                	mov    %esp,%ebp
  800083:	56                   	push   %esi
  800084:	53                   	push   %ebx
  800085:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800088:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80008b:	e8 88 0a 00 00       	call   800b18 <sys_getenvid>
  800090:	25 ff 03 00 00       	and    $0x3ff,%eax
  800095:	89 c2                	mov    %eax,%edx
  800097:	c1 e2 05             	shl    $0x5,%edx
  80009a:	29 c2                	sub    %eax,%edx
  80009c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8000a3:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a8:	85 db                	test   %ebx,%ebx
  8000aa:	7e 07                	jle    8000b3 <libmain+0x33>
		binaryname = argv[0];
  8000ac:	8b 06                	mov    (%esi),%eax
  8000ae:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	56                   	push   %esi
  8000b7:	53                   	push   %ebx
  8000b8:	e8 a4 ff ff ff       	call   800061 <umain>

	// exit gracefully
	exit();
  8000bd:	e8 0a 00 00 00       	call   8000cc <exit>
}
  8000c2:	83 c4 10             	add    $0x10,%esp
  8000c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c8:	5b                   	pop    %ebx
  8000c9:	5e                   	pop    %esi
  8000ca:	5d                   	pop    %ebp
  8000cb:	c3                   	ret    

008000cc <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000d2:	e8 55 0f 00 00       	call   80102c <close_all>
	sys_env_destroy(0);
  8000d7:	83 ec 0c             	sub    $0xc,%esp
  8000da:	6a 00                	push   $0x0
  8000dc:	e8 f6 09 00 00       	call   800ad7 <sys_env_destroy>
}
  8000e1:	83 c4 10             	add    $0x10,%esp
  8000e4:	c9                   	leave  
  8000e5:	c3                   	ret    

008000e6 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8000e6:	55                   	push   %ebp
  8000e7:	89 e5                	mov    %esp,%ebp
  8000e9:	53                   	push   %ebx
  8000ea:	83 ec 04             	sub    $0x4,%esp
  8000ed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8000f0:	8b 13                	mov    (%ebx),%edx
  8000f2:	8d 42 01             	lea    0x1(%edx),%eax
  8000f5:	89 03                	mov    %eax,(%ebx)
  8000f7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8000fa:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8000fe:	3d ff 00 00 00       	cmp    $0xff,%eax
  800103:	74 08                	je     80010d <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800105:	ff 43 04             	incl   0x4(%ebx)
}
  800108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80010b:	c9                   	leave  
  80010c:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80010d:	83 ec 08             	sub    $0x8,%esp
  800110:	68 ff 00 00 00       	push   $0xff
  800115:	8d 43 08             	lea    0x8(%ebx),%eax
  800118:	50                   	push   %eax
  800119:	e8 7c 09 00 00       	call   800a9a <sys_cputs>
		b->idx = 0;
  80011e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800124:	83 c4 10             	add    $0x10,%esp
  800127:	eb dc                	jmp    800105 <putch+0x1f>

00800129 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800129:	55                   	push   %ebp
  80012a:	89 e5                	mov    %esp,%ebp
  80012c:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800132:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800139:	00 00 00 
	b.cnt = 0;
  80013c:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800143:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800146:	ff 75 0c             	pushl  0xc(%ebp)
  800149:	ff 75 08             	pushl  0x8(%ebp)
  80014c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800152:	50                   	push   %eax
  800153:	68 e6 00 80 00       	push   $0x8000e6
  800158:	e8 17 01 00 00       	call   800274 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80015d:	83 c4 08             	add    $0x8,%esp
  800160:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800166:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80016c:	50                   	push   %eax
  80016d:	e8 28 09 00 00       	call   800a9a <sys_cputs>

	return b.cnt;
}
  800172:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800180:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800183:	50                   	push   %eax
  800184:	ff 75 08             	pushl  0x8(%ebp)
  800187:	e8 9d ff ff ff       	call   800129 <vcprintf>
	va_end(ap);

	return cnt;
}
  80018c:	c9                   	leave  
  80018d:	c3                   	ret    

0080018e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80018e:	55                   	push   %ebp
  80018f:	89 e5                	mov    %esp,%ebp
  800191:	57                   	push   %edi
  800192:	56                   	push   %esi
  800193:	53                   	push   %ebx
  800194:	83 ec 1c             	sub    $0x1c,%esp
  800197:	89 c7                	mov    %eax,%edi
  800199:	89 d6                	mov    %edx,%esi
  80019b:	8b 45 08             	mov    0x8(%ebp),%eax
  80019e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8001a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8001a4:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8001a7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8001aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001af:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8001b2:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8001b5:	39 d3                	cmp    %edx,%ebx
  8001b7:	72 05                	jb     8001be <printnum+0x30>
  8001b9:	39 45 10             	cmp    %eax,0x10(%ebp)
  8001bc:	77 78                	ja     800236 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	ff 75 18             	pushl  0x18(%ebp)
  8001c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8001c7:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8001ca:	53                   	push   %ebx
  8001cb:	ff 75 10             	pushl  0x10(%ebp)
  8001ce:	83 ec 08             	sub    $0x8,%esp
  8001d1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001d4:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d7:	ff 75 dc             	pushl  -0x24(%ebp)
  8001da:	ff 75 d8             	pushl  -0x28(%ebp)
  8001dd:	e8 6a 1b 00 00       	call   801d4c <__udivdi3>
  8001e2:	83 c4 18             	add    $0x18,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	89 f2                	mov    %esi,%edx
  8001e9:	89 f8                	mov    %edi,%eax
  8001eb:	e8 9e ff ff ff       	call   80018e <printnum>
  8001f0:	83 c4 20             	add    $0x20,%esp
  8001f3:	eb 11                	jmp    800206 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	56                   	push   %esi
  8001f9:	ff 75 18             	pushl  0x18(%ebp)
  8001fc:	ff d7                	call   *%edi
  8001fe:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800201:	4b                   	dec    %ebx
  800202:	85 db                	test   %ebx,%ebx
  800204:	7f ef                	jg     8001f5 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800206:	83 ec 08             	sub    $0x8,%esp
  800209:	56                   	push   %esi
  80020a:	83 ec 04             	sub    $0x4,%esp
  80020d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800210:	ff 75 e0             	pushl  -0x20(%ebp)
  800213:	ff 75 dc             	pushl  -0x24(%ebp)
  800216:	ff 75 d8             	pushl  -0x28(%ebp)
  800219:	e8 3e 1c 00 00       	call   801e5c <__umoddi3>
  80021e:	83 c4 14             	add    $0x14,%esp
  800221:	0f be 80 c6 1f 80 00 	movsbl 0x801fc6(%eax),%eax
  800228:	50                   	push   %eax
  800229:	ff d7                	call   *%edi
}
  80022b:	83 c4 10             	add    $0x10,%esp
  80022e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800231:	5b                   	pop    %ebx
  800232:	5e                   	pop    %esi
  800233:	5f                   	pop    %edi
  800234:	5d                   	pop    %ebp
  800235:	c3                   	ret    
  800236:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800239:	eb c6                	jmp    800201 <printnum+0x73>

0080023b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80023b:	55                   	push   %ebp
  80023c:	89 e5                	mov    %esp,%ebp
  80023e:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800241:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800244:	8b 10                	mov    (%eax),%edx
  800246:	3b 50 04             	cmp    0x4(%eax),%edx
  800249:	73 0a                	jae    800255 <sprintputch+0x1a>
		*b->buf++ = ch;
  80024b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80024e:	89 08                	mov    %ecx,(%eax)
  800250:	8b 45 08             	mov    0x8(%ebp),%eax
  800253:	88 02                	mov    %al,(%edx)
}
  800255:	5d                   	pop    %ebp
  800256:	c3                   	ret    

00800257 <printfmt>:
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80025d:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800260:	50                   	push   %eax
  800261:	ff 75 10             	pushl  0x10(%ebp)
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 05 00 00 00       	call   800274 <vprintfmt>
}
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <vprintfmt>:
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	57                   	push   %edi
  800278:	56                   	push   %esi
  800279:	53                   	push   %ebx
  80027a:	83 ec 2c             	sub    $0x2c,%esp
  80027d:	8b 75 08             	mov    0x8(%ebp),%esi
  800280:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800283:	8b 7d 10             	mov    0x10(%ebp),%edi
  800286:	e9 ae 03 00 00       	jmp    800639 <vprintfmt+0x3c5>
  80028b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80028f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800296:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80029d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8002a4:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8002a9:	8d 47 01             	lea    0x1(%edi),%eax
  8002ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8002af:	8a 17                	mov    (%edi),%dl
  8002b1:	8d 42 dd             	lea    -0x23(%edx),%eax
  8002b4:	3c 55                	cmp    $0x55,%al
  8002b6:	0f 87 fe 03 00 00    	ja     8006ba <vprintfmt+0x446>
  8002bc:	0f b6 c0             	movzbl %al,%eax
  8002bf:	ff 24 85 00 21 80 00 	jmp    *0x802100(,%eax,4)
  8002c6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8002c9:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8002cd:	eb da                	jmp    8002a9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8002d2:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8002d6:	eb d1                	jmp    8002a9 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8002d8:	0f b6 d2             	movzbl %dl,%edx
  8002db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8002de:	b8 00 00 00 00       	mov    $0x0,%eax
  8002e3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8002e6:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8002ef:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8002f2:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8002f5:	83 f9 09             	cmp    $0x9,%ecx
  8002f8:	77 52                	ja     80034c <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8002fa:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8002fb:	eb e9                	jmp    8002e6 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8002fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800300:	8b 00                	mov    (%eax),%eax
  800302:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800305:	8b 45 14             	mov    0x14(%ebp),%eax
  800308:	8d 40 04             	lea    0x4(%eax),%eax
  80030b:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80030e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800311:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800315:	79 92                	jns    8002a9 <vprintfmt+0x35>
				width = precision, precision = -1;
  800317:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80031a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80031d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800324:	eb 83                	jmp    8002a9 <vprintfmt+0x35>
  800326:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80032a:	78 08                	js     800334 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80032c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80032f:	e9 75 ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
  800334:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80033b:	eb ef                	jmp    80032c <vprintfmt+0xb8>
  80033d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800340:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800347:	e9 5d ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
  80034c:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80034f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800352:	eb bd                	jmp    800311 <vprintfmt+0x9d>
			lflag++;
  800354:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800355:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800358:	e9 4c ff ff ff       	jmp    8002a9 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80035d:	8b 45 14             	mov    0x14(%ebp),%eax
  800360:	8d 78 04             	lea    0x4(%eax),%edi
  800363:	83 ec 08             	sub    $0x8,%esp
  800366:	53                   	push   %ebx
  800367:	ff 30                	pushl  (%eax)
  800369:	ff d6                	call   *%esi
			break;
  80036b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80036e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800371:	e9 c0 02 00 00       	jmp    800636 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800376:	8b 45 14             	mov    0x14(%ebp),%eax
  800379:	8d 78 04             	lea    0x4(%eax),%edi
  80037c:	8b 00                	mov    (%eax),%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	78 2a                	js     8003ac <vprintfmt+0x138>
  800382:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800384:	83 f8 0f             	cmp    $0xf,%eax
  800387:	7f 27                	jg     8003b0 <vprintfmt+0x13c>
  800389:	8b 04 85 60 22 80 00 	mov    0x802260(,%eax,4),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	74 1c                	je     8003b0 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800394:	50                   	push   %eax
  800395:	68 91 23 80 00       	push   $0x802391
  80039a:	53                   	push   %ebx
  80039b:	56                   	push   %esi
  80039c:	e8 b6 fe ff ff       	call   800257 <printfmt>
  8003a1:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003a4:	89 7d 14             	mov    %edi,0x14(%ebp)
  8003a7:	e9 8a 02 00 00       	jmp    800636 <vprintfmt+0x3c2>
  8003ac:	f7 d8                	neg    %eax
  8003ae:	eb d2                	jmp    800382 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8003b0:	52                   	push   %edx
  8003b1:	68 de 1f 80 00       	push   $0x801fde
  8003b6:	53                   	push   %ebx
  8003b7:	56                   	push   %esi
  8003b8:	e8 9a fe ff ff       	call   800257 <printfmt>
  8003bd:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8003c0:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8003c3:	e9 6e 02 00 00       	jmp    800636 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8003c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8003cb:	83 c0 04             	add    $0x4,%eax
  8003ce:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8003d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d4:	8b 38                	mov    (%eax),%edi
  8003d6:	85 ff                	test   %edi,%edi
  8003d8:	74 39                	je     800413 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8003da:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003de:	0f 8e a9 00 00 00    	jle    80048d <vprintfmt+0x219>
  8003e4:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8003e8:	0f 84 a7 00 00 00    	je     800495 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8003ee:	83 ec 08             	sub    $0x8,%esp
  8003f1:	ff 75 d0             	pushl  -0x30(%ebp)
  8003f4:	57                   	push   %edi
  8003f5:	e8 6b 03 00 00       	call   800765 <strnlen>
  8003fa:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8003fd:	29 c1                	sub    %eax,%ecx
  8003ff:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800402:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800405:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800409:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80040c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  80040f:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800411:	eb 14                	jmp    800427 <vprintfmt+0x1b3>
				p = "(null)";
  800413:	bf d7 1f 80 00       	mov    $0x801fd7,%edi
  800418:	eb c0                	jmp    8003da <vprintfmt+0x166>
					putch(padc, putdat);
  80041a:	83 ec 08             	sub    $0x8,%esp
  80041d:	53                   	push   %ebx
  80041e:	ff 75 e0             	pushl  -0x20(%ebp)
  800421:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800423:	4f                   	dec    %edi
  800424:	83 c4 10             	add    $0x10,%esp
  800427:	85 ff                	test   %edi,%edi
  800429:	7f ef                	jg     80041a <vprintfmt+0x1a6>
  80042b:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80042e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800431:	89 c8                	mov    %ecx,%eax
  800433:	85 c9                	test   %ecx,%ecx
  800435:	78 10                	js     800447 <vprintfmt+0x1d3>
  800437:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80043a:	29 c1                	sub    %eax,%ecx
  80043c:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80043f:	89 75 08             	mov    %esi,0x8(%ebp)
  800442:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800445:	eb 15                	jmp    80045c <vprintfmt+0x1e8>
  800447:	b8 00 00 00 00       	mov    $0x0,%eax
  80044c:	eb e9                	jmp    800437 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80044e:	83 ec 08             	sub    $0x8,%esp
  800451:	53                   	push   %ebx
  800452:	52                   	push   %edx
  800453:	ff 55 08             	call   *0x8(%ebp)
  800456:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800459:	ff 4d e0             	decl   -0x20(%ebp)
  80045c:	47                   	inc    %edi
  80045d:	8a 47 ff             	mov    -0x1(%edi),%al
  800460:	0f be d0             	movsbl %al,%edx
  800463:	85 d2                	test   %edx,%edx
  800465:	74 59                	je     8004c0 <vprintfmt+0x24c>
  800467:	85 f6                	test   %esi,%esi
  800469:	78 03                	js     80046e <vprintfmt+0x1fa>
  80046b:	4e                   	dec    %esi
  80046c:	78 2f                	js     80049d <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80046e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800472:	74 da                	je     80044e <vprintfmt+0x1da>
  800474:	0f be c0             	movsbl %al,%eax
  800477:	83 e8 20             	sub    $0x20,%eax
  80047a:	83 f8 5e             	cmp    $0x5e,%eax
  80047d:	76 cf                	jbe    80044e <vprintfmt+0x1da>
					putch('?', putdat);
  80047f:	83 ec 08             	sub    $0x8,%esp
  800482:	53                   	push   %ebx
  800483:	6a 3f                	push   $0x3f
  800485:	ff 55 08             	call   *0x8(%ebp)
  800488:	83 c4 10             	add    $0x10,%esp
  80048b:	eb cc                	jmp    800459 <vprintfmt+0x1e5>
  80048d:	89 75 08             	mov    %esi,0x8(%ebp)
  800490:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800493:	eb c7                	jmp    80045c <vprintfmt+0x1e8>
  800495:	89 75 08             	mov    %esi,0x8(%ebp)
  800498:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80049b:	eb bf                	jmp    80045c <vprintfmt+0x1e8>
  80049d:	8b 75 08             	mov    0x8(%ebp),%esi
  8004a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004a3:	eb 0c                	jmp    8004b1 <vprintfmt+0x23d>
				putch(' ', putdat);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	53                   	push   %ebx
  8004a9:	6a 20                	push   $0x20
  8004ab:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8004ad:	4f                   	dec    %edi
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	85 ff                	test   %edi,%edi
  8004b3:	7f f0                	jg     8004a5 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8004b5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8004b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8004bb:	e9 76 01 00 00       	jmp    800636 <vprintfmt+0x3c2>
  8004c0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8004c3:	8b 75 08             	mov    0x8(%ebp),%esi
  8004c6:	eb e9                	jmp    8004b1 <vprintfmt+0x23d>
	if (lflag >= 2)
  8004c8:	83 f9 01             	cmp    $0x1,%ecx
  8004cb:	7f 1f                	jg     8004ec <vprintfmt+0x278>
	else if (lflag)
  8004cd:	85 c9                	test   %ecx,%ecx
  8004cf:	75 48                	jne    800519 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8004d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d4:	8b 00                	mov    (%eax),%eax
  8004d6:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004d9:	89 c1                	mov    %eax,%ecx
  8004db:	c1 f9 1f             	sar    $0x1f,%ecx
  8004de:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8004e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8004e4:	8d 40 04             	lea    0x4(%eax),%eax
  8004e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8004ea:	eb 17                	jmp    800503 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8004ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ef:	8b 50 04             	mov    0x4(%eax),%edx
  8004f2:	8b 00                	mov    (%eax),%eax
  8004f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8004f7:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8004fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8004fd:	8d 40 08             	lea    0x8(%eax),%eax
  800500:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800503:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800506:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800509:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80050d:	78 25                	js     800534 <vprintfmt+0x2c0>
			base = 10;
  80050f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800514:	e9 03 01 00 00       	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800519:	8b 45 14             	mov    0x14(%ebp),%eax
  80051c:	8b 00                	mov    (%eax),%eax
  80051e:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800521:	89 c1                	mov    %eax,%ecx
  800523:	c1 f9 1f             	sar    $0x1f,%ecx
  800526:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800529:	8b 45 14             	mov    0x14(%ebp),%eax
  80052c:	8d 40 04             	lea    0x4(%eax),%eax
  80052f:	89 45 14             	mov    %eax,0x14(%ebp)
  800532:	eb cf                	jmp    800503 <vprintfmt+0x28f>
				putch('-', putdat);
  800534:	83 ec 08             	sub    $0x8,%esp
  800537:	53                   	push   %ebx
  800538:	6a 2d                	push   $0x2d
  80053a:	ff d6                	call   *%esi
				num = -(long long) num;
  80053c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80053f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800542:	f7 da                	neg    %edx
  800544:	83 d1 00             	adc    $0x0,%ecx
  800547:	f7 d9                	neg    %ecx
  800549:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80054c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800551:	e9 c6 00 00 00       	jmp    80061c <vprintfmt+0x3a8>
	if (lflag >= 2)
  800556:	83 f9 01             	cmp    $0x1,%ecx
  800559:	7f 1e                	jg     800579 <vprintfmt+0x305>
	else if (lflag)
  80055b:	85 c9                	test   %ecx,%ecx
  80055d:	75 32                	jne    800591 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80055f:	8b 45 14             	mov    0x14(%ebp),%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	b9 00 00 00 00       	mov    $0x0,%ecx
  800569:	8d 40 04             	lea    0x4(%eax),%eax
  80056c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80056f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800574:	e9 a3 00 00 00       	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	8b 10                	mov    (%eax),%edx
  80057e:	8b 48 04             	mov    0x4(%eax),%ecx
  800581:	8d 40 08             	lea    0x8(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800587:	b8 0a 00 00 00       	mov    $0xa,%eax
  80058c:	e9 8b 00 00 00       	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800591:	8b 45 14             	mov    0x14(%ebp),%eax
  800594:	8b 10                	mov    (%eax),%edx
  800596:	b9 00 00 00 00       	mov    $0x0,%ecx
  80059b:	8d 40 04             	lea    0x4(%eax),%eax
  80059e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005a1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005a6:	eb 74                	jmp    80061c <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005a8:	83 f9 01             	cmp    $0x1,%ecx
  8005ab:	7f 1b                	jg     8005c8 <vprintfmt+0x354>
	else if (lflag)
  8005ad:	85 c9                	test   %ecx,%ecx
  8005af:	75 2c                	jne    8005dd <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8005b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b4:	8b 10                	mov    (%eax),%edx
  8005b6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005bb:	8d 40 04             	lea    0x4(%eax),%eax
  8005be:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005c1:	b8 08 00 00 00       	mov    $0x8,%eax
  8005c6:	eb 54                	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cb:	8b 10                	mov    (%eax),%edx
  8005cd:	8b 48 04             	mov    0x4(%eax),%ecx
  8005d0:	8d 40 08             	lea    0x8(%eax),%eax
  8005d3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005d6:	b8 08 00 00 00       	mov    $0x8,%eax
  8005db:	eb 3f                	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e0:	8b 10                	mov    (%eax),%edx
  8005e2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005e7:	8d 40 04             	lea    0x4(%eax),%eax
  8005ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8005ed:	b8 08 00 00 00       	mov    $0x8,%eax
  8005f2:	eb 28                	jmp    80061c <vprintfmt+0x3a8>
			putch('0', putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	53                   	push   %ebx
  8005f8:	6a 30                	push   $0x30
  8005fa:	ff d6                	call   *%esi
			putch('x', putdat);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	53                   	push   %ebx
  800600:	6a 78                	push   $0x78
  800602:	ff d6                	call   *%esi
			num = (unsigned long long)
  800604:	8b 45 14             	mov    0x14(%ebp),%eax
  800607:	8b 10                	mov    (%eax),%edx
  800609:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80060e:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800611:	8d 40 04             	lea    0x4(%eax),%eax
  800614:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800617:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80061c:	83 ec 0c             	sub    $0xc,%esp
  80061f:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800623:	57                   	push   %edi
  800624:	ff 75 e0             	pushl  -0x20(%ebp)
  800627:	50                   	push   %eax
  800628:	51                   	push   %ecx
  800629:	52                   	push   %edx
  80062a:	89 da                	mov    %ebx,%edx
  80062c:	89 f0                	mov    %esi,%eax
  80062e:	e8 5b fb ff ff       	call   80018e <printnum>
			break;
  800633:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800636:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800639:	47                   	inc    %edi
  80063a:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80063e:	83 f8 25             	cmp    $0x25,%eax
  800641:	0f 84 44 fc ff ff    	je     80028b <vprintfmt+0x17>
			if (ch == '\0')
  800647:	85 c0                	test   %eax,%eax
  800649:	0f 84 89 00 00 00    	je     8006d8 <vprintfmt+0x464>
			putch(ch, putdat);
  80064f:	83 ec 08             	sub    $0x8,%esp
  800652:	53                   	push   %ebx
  800653:	50                   	push   %eax
  800654:	ff d6                	call   *%esi
  800656:	83 c4 10             	add    $0x10,%esp
  800659:	eb de                	jmp    800639 <vprintfmt+0x3c5>
	if (lflag >= 2)
  80065b:	83 f9 01             	cmp    $0x1,%ecx
  80065e:	7f 1b                	jg     80067b <vprintfmt+0x407>
	else if (lflag)
  800660:	85 c9                	test   %ecx,%ecx
  800662:	75 2c                	jne    800690 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	8b 10                	mov    (%eax),%edx
  800669:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066e:	8d 40 04             	lea    0x4(%eax),%eax
  800671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800674:	b8 10 00 00 00       	mov    $0x10,%eax
  800679:	eb a1                	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80067b:	8b 45 14             	mov    0x14(%ebp),%eax
  80067e:	8b 10                	mov    (%eax),%edx
  800680:	8b 48 04             	mov    0x4(%eax),%ecx
  800683:	8d 40 08             	lea    0x8(%eax),%eax
  800686:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800689:	b8 10 00 00 00       	mov    $0x10,%eax
  80068e:	eb 8c                	jmp    80061c <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800690:	8b 45 14             	mov    0x14(%ebp),%eax
  800693:	8b 10                	mov    (%eax),%edx
  800695:	b9 00 00 00 00       	mov    $0x0,%ecx
  80069a:	8d 40 04             	lea    0x4(%eax),%eax
  80069d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006a0:	b8 10 00 00 00       	mov    $0x10,%eax
  8006a5:	e9 72 ff ff ff       	jmp    80061c <vprintfmt+0x3a8>
			putch(ch, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	53                   	push   %ebx
  8006ae:	6a 25                	push   $0x25
  8006b0:	ff d6                	call   *%esi
			break;
  8006b2:	83 c4 10             	add    $0x10,%esp
  8006b5:	e9 7c ff ff ff       	jmp    800636 <vprintfmt+0x3c2>
			putch('%', putdat);
  8006ba:	83 ec 08             	sub    $0x8,%esp
  8006bd:	53                   	push   %ebx
  8006be:	6a 25                	push   $0x25
  8006c0:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8006c2:	83 c4 10             	add    $0x10,%esp
  8006c5:	89 f8                	mov    %edi,%eax
  8006c7:	eb 01                	jmp    8006ca <vprintfmt+0x456>
  8006c9:	48                   	dec    %eax
  8006ca:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8006ce:	75 f9                	jne    8006c9 <vprintfmt+0x455>
  8006d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8006d3:	e9 5e ff ff ff       	jmp    800636 <vprintfmt+0x3c2>
}
  8006d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006db:	5b                   	pop    %ebx
  8006dc:	5e                   	pop    %esi
  8006dd:	5f                   	pop    %edi
  8006de:	5d                   	pop    %ebp
  8006df:	c3                   	ret    

008006e0 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8006ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8006ef:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8006f3:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8006f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8006fd:	85 c0                	test   %eax,%eax
  8006ff:	74 26                	je     800727 <vsnprintf+0x47>
  800701:	85 d2                	test   %edx,%edx
  800703:	7e 29                	jle    80072e <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800705:	ff 75 14             	pushl  0x14(%ebp)
  800708:	ff 75 10             	pushl  0x10(%ebp)
  80070b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80070e:	50                   	push   %eax
  80070f:	68 3b 02 80 00       	push   $0x80023b
  800714:	e8 5b fb ff ff       	call   800274 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800719:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80071c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80071f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800722:	83 c4 10             	add    $0x10,%esp
}
  800725:	c9                   	leave  
  800726:	c3                   	ret    
		return -E_INVAL;
  800727:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80072c:	eb f7                	jmp    800725 <vsnprintf+0x45>
  80072e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800733:	eb f0                	jmp    800725 <vsnprintf+0x45>

00800735 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800735:	55                   	push   %ebp
  800736:	89 e5                	mov    %esp,%ebp
  800738:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80073b:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80073e:	50                   	push   %eax
  80073f:	ff 75 10             	pushl  0x10(%ebp)
  800742:	ff 75 0c             	pushl  0xc(%ebp)
  800745:	ff 75 08             	pushl  0x8(%ebp)
  800748:	e8 93 ff ff ff       	call   8006e0 <vsnprintf>
	va_end(ap);

	return rc;
}
  80074d:	c9                   	leave  
  80074e:	c3                   	ret    

0080074f <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80074f:	55                   	push   %ebp
  800750:	89 e5                	mov    %esp,%ebp
  800752:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800755:	b8 00 00 00 00       	mov    $0x0,%eax
  80075a:	eb 01                	jmp    80075d <strlen+0xe>
		n++;
  80075c:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80075d:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800761:	75 f9                	jne    80075c <strlen+0xd>
	return n;
}
  800763:	5d                   	pop    %ebp
  800764:	c3                   	ret    

00800765 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
  800768:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80076b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80076e:	b8 00 00 00 00       	mov    $0x0,%eax
  800773:	eb 01                	jmp    800776 <strnlen+0x11>
		n++;
  800775:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800776:	39 d0                	cmp    %edx,%eax
  800778:	74 06                	je     800780 <strnlen+0x1b>
  80077a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80077e:	75 f5                	jne    800775 <strnlen+0x10>
	return n;
}
  800780:	5d                   	pop    %ebp
  800781:	c3                   	ret    

00800782 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800782:	55                   	push   %ebp
  800783:	89 e5                	mov    %esp,%ebp
  800785:	53                   	push   %ebx
  800786:	8b 45 08             	mov    0x8(%ebp),%eax
  800789:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80078c:	89 c2                	mov    %eax,%edx
  80078e:	42                   	inc    %edx
  80078f:	41                   	inc    %ecx
  800790:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800793:	88 5a ff             	mov    %bl,-0x1(%edx)
  800796:	84 db                	test   %bl,%bl
  800798:	75 f4                	jne    80078e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80079a:	5b                   	pop    %ebx
  80079b:	5d                   	pop    %ebp
  80079c:	c3                   	ret    

0080079d <strcat>:

char *
strcat(char *dst, const char *src)
{
  80079d:	55                   	push   %ebp
  80079e:	89 e5                	mov    %esp,%ebp
  8007a0:	53                   	push   %ebx
  8007a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8007a4:	53                   	push   %ebx
  8007a5:	e8 a5 ff ff ff       	call   80074f <strlen>
  8007aa:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	01 d8                	add    %ebx,%eax
  8007b2:	50                   	push   %eax
  8007b3:	e8 ca ff ff ff       	call   800782 <strcpy>
	return dst;
}
  8007b8:	89 d8                	mov    %ebx,%eax
  8007ba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007bd:	c9                   	leave  
  8007be:	c3                   	ret    

008007bf <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
  8007c2:	56                   	push   %esi
  8007c3:	53                   	push   %ebx
  8007c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8007c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8007ca:	89 f3                	mov    %esi,%ebx
  8007cc:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8007cf:	89 f2                	mov    %esi,%edx
  8007d1:	eb 0c                	jmp    8007df <strncpy+0x20>
		*dst++ = *src;
  8007d3:	42                   	inc    %edx
  8007d4:	8a 01                	mov    (%ecx),%al
  8007d6:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8007d9:	80 39 01             	cmpb   $0x1,(%ecx)
  8007dc:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8007df:	39 da                	cmp    %ebx,%edx
  8007e1:	75 f0                	jne    8007d3 <strncpy+0x14>
	}
	return ret;
}
  8007e3:	89 f0                	mov    %esi,%eax
  8007e5:	5b                   	pop    %ebx
  8007e6:	5e                   	pop    %esi
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	56                   	push   %esi
  8007ed:	53                   	push   %ebx
  8007ee:	8b 75 08             	mov    0x8(%ebp),%esi
  8007f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007f4:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8007f7:	85 c0                	test   %eax,%eax
  8007f9:	74 20                	je     80081b <strlcpy+0x32>
  8007fb:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8007ff:	89 f0                	mov    %esi,%eax
  800801:	eb 05                	jmp    800808 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800803:	40                   	inc    %eax
  800804:	42                   	inc    %edx
  800805:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800808:	39 d8                	cmp    %ebx,%eax
  80080a:	74 06                	je     800812 <strlcpy+0x29>
  80080c:	8a 0a                	mov    (%edx),%cl
  80080e:	84 c9                	test   %cl,%cl
  800810:	75 f1                	jne    800803 <strlcpy+0x1a>
		*dst = '\0';
  800812:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800815:	29 f0                	sub    %esi,%eax
}
  800817:	5b                   	pop    %ebx
  800818:	5e                   	pop    %esi
  800819:	5d                   	pop    %ebp
  80081a:	c3                   	ret    
  80081b:	89 f0                	mov    %esi,%eax
  80081d:	eb f6                	jmp    800815 <strlcpy+0x2c>

0080081f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80081f:	55                   	push   %ebp
  800820:	89 e5                	mov    %esp,%ebp
  800822:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800825:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800828:	eb 02                	jmp    80082c <strcmp+0xd>
		p++, q++;
  80082a:	41                   	inc    %ecx
  80082b:	42                   	inc    %edx
	while (*p && *p == *q)
  80082c:	8a 01                	mov    (%ecx),%al
  80082e:	84 c0                	test   %al,%al
  800830:	74 04                	je     800836 <strcmp+0x17>
  800832:	3a 02                	cmp    (%edx),%al
  800834:	74 f4                	je     80082a <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800836:	0f b6 c0             	movzbl %al,%eax
  800839:	0f b6 12             	movzbl (%edx),%edx
  80083c:	29 d0                	sub    %edx,%eax
}
  80083e:	5d                   	pop    %ebp
  80083f:	c3                   	ret    

00800840 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800840:	55                   	push   %ebp
  800841:	89 e5                	mov    %esp,%ebp
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084a:	89 c3                	mov    %eax,%ebx
  80084c:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80084f:	eb 02                	jmp    800853 <strncmp+0x13>
		n--, p++, q++;
  800851:	40                   	inc    %eax
  800852:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800853:	39 d8                	cmp    %ebx,%eax
  800855:	74 15                	je     80086c <strncmp+0x2c>
  800857:	8a 08                	mov    (%eax),%cl
  800859:	84 c9                	test   %cl,%cl
  80085b:	74 04                	je     800861 <strncmp+0x21>
  80085d:	3a 0a                	cmp    (%edx),%cl
  80085f:	74 f0                	je     800851 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800861:	0f b6 00             	movzbl (%eax),%eax
  800864:	0f b6 12             	movzbl (%edx),%edx
  800867:	29 d0                	sub    %edx,%eax
}
  800869:	5b                   	pop    %ebx
  80086a:	5d                   	pop    %ebp
  80086b:	c3                   	ret    
		return 0;
  80086c:	b8 00 00 00 00       	mov    $0x0,%eax
  800871:	eb f6                	jmp    800869 <strncmp+0x29>

00800873 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800873:	55                   	push   %ebp
  800874:	89 e5                	mov    %esp,%ebp
  800876:	8b 45 08             	mov    0x8(%ebp),%eax
  800879:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80087c:	8a 10                	mov    (%eax),%dl
  80087e:	84 d2                	test   %dl,%dl
  800880:	74 07                	je     800889 <strchr+0x16>
		if (*s == c)
  800882:	38 ca                	cmp    %cl,%dl
  800884:	74 08                	je     80088e <strchr+0x1b>
	for (; *s; s++)
  800886:	40                   	inc    %eax
  800887:	eb f3                	jmp    80087c <strchr+0x9>
			return (char *) s;
	return 0;
  800889:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088e:	5d                   	pop    %ebp
  80088f:	c3                   	ret    

00800890 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800890:	55                   	push   %ebp
  800891:	89 e5                	mov    %esp,%ebp
  800893:	8b 45 08             	mov    0x8(%ebp),%eax
  800896:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800899:	8a 10                	mov    (%eax),%dl
  80089b:	84 d2                	test   %dl,%dl
  80089d:	74 07                	je     8008a6 <strfind+0x16>
		if (*s == c)
  80089f:	38 ca                	cmp    %cl,%dl
  8008a1:	74 03                	je     8008a6 <strfind+0x16>
	for (; *s; s++)
  8008a3:	40                   	inc    %eax
  8008a4:	eb f3                	jmp    800899 <strfind+0x9>
			break;
	return (char *) s;
}
  8008a6:	5d                   	pop    %ebp
  8008a7:	c3                   	ret    

008008a8 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	57                   	push   %edi
  8008ac:	56                   	push   %esi
  8008ad:	53                   	push   %ebx
  8008ae:	8b 7d 08             	mov    0x8(%ebp),%edi
  8008b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8008b4:	85 c9                	test   %ecx,%ecx
  8008b6:	74 13                	je     8008cb <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8008b8:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8008be:	75 05                	jne    8008c5 <memset+0x1d>
  8008c0:	f6 c1 03             	test   $0x3,%cl
  8008c3:	74 0d                	je     8008d2 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8008c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c8:	fc                   	cld    
  8008c9:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8008cb:	89 f8                	mov    %edi,%eax
  8008cd:	5b                   	pop    %ebx
  8008ce:	5e                   	pop    %esi
  8008cf:	5f                   	pop    %edi
  8008d0:	5d                   	pop    %ebp
  8008d1:	c3                   	ret    
		c &= 0xFF;
  8008d2:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8008d6:	89 d3                	mov    %edx,%ebx
  8008d8:	c1 e3 08             	shl    $0x8,%ebx
  8008db:	89 d0                	mov    %edx,%eax
  8008dd:	c1 e0 18             	shl    $0x18,%eax
  8008e0:	89 d6                	mov    %edx,%esi
  8008e2:	c1 e6 10             	shl    $0x10,%esi
  8008e5:	09 f0                	or     %esi,%eax
  8008e7:	09 c2                	or     %eax,%edx
  8008e9:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8008eb:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8008ee:	89 d0                	mov    %edx,%eax
  8008f0:	fc                   	cld    
  8008f1:	f3 ab                	rep stos %eax,%es:(%edi)
  8008f3:	eb d6                	jmp    8008cb <memset+0x23>

008008f5 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8008f5:	55                   	push   %ebp
  8008f6:	89 e5                	mov    %esp,%ebp
  8008f8:	57                   	push   %edi
  8008f9:	56                   	push   %esi
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800900:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800903:	39 c6                	cmp    %eax,%esi
  800905:	73 33                	jae    80093a <memmove+0x45>
  800907:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80090a:	39 d0                	cmp    %edx,%eax
  80090c:	73 2c                	jae    80093a <memmove+0x45>
		s += n;
		d += n;
  80090e:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800911:	89 d6                	mov    %edx,%esi
  800913:	09 fe                	or     %edi,%esi
  800915:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80091b:	75 13                	jne    800930 <memmove+0x3b>
  80091d:	f6 c1 03             	test   $0x3,%cl
  800920:	75 0e                	jne    800930 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800922:	83 ef 04             	sub    $0x4,%edi
  800925:	8d 72 fc             	lea    -0x4(%edx),%esi
  800928:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80092b:	fd                   	std    
  80092c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80092e:	eb 07                	jmp    800937 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800930:	4f                   	dec    %edi
  800931:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800934:	fd                   	std    
  800935:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800937:	fc                   	cld    
  800938:	eb 13                	jmp    80094d <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80093a:	89 f2                	mov    %esi,%edx
  80093c:	09 c2                	or     %eax,%edx
  80093e:	f6 c2 03             	test   $0x3,%dl
  800941:	75 05                	jne    800948 <memmove+0x53>
  800943:	f6 c1 03             	test   $0x3,%cl
  800946:	74 09                	je     800951 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800948:	89 c7                	mov    %eax,%edi
  80094a:	fc                   	cld    
  80094b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  80094d:	5e                   	pop    %esi
  80094e:	5f                   	pop    %edi
  80094f:	5d                   	pop    %ebp
  800950:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800951:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800954:	89 c7                	mov    %eax,%edi
  800956:	fc                   	cld    
  800957:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800959:	eb f2                	jmp    80094d <memmove+0x58>

0080095b <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  80095b:	55                   	push   %ebp
  80095c:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  80095e:	ff 75 10             	pushl  0x10(%ebp)
  800961:	ff 75 0c             	pushl  0xc(%ebp)
  800964:	ff 75 08             	pushl  0x8(%ebp)
  800967:	e8 89 ff ff ff       	call   8008f5 <memmove>
}
  80096c:	c9                   	leave  
  80096d:	c3                   	ret    

0080096e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  80096e:	55                   	push   %ebp
  80096f:	89 e5                	mov    %esp,%ebp
  800971:	56                   	push   %esi
  800972:	53                   	push   %ebx
  800973:	8b 45 08             	mov    0x8(%ebp),%eax
  800976:	89 c6                	mov    %eax,%esi
  800978:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  80097b:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  80097e:	39 f0                	cmp    %esi,%eax
  800980:	74 16                	je     800998 <memcmp+0x2a>
		if (*s1 != *s2)
  800982:	8a 08                	mov    (%eax),%cl
  800984:	8a 1a                	mov    (%edx),%bl
  800986:	38 d9                	cmp    %bl,%cl
  800988:	75 04                	jne    80098e <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  80098a:	40                   	inc    %eax
  80098b:	42                   	inc    %edx
  80098c:	eb f0                	jmp    80097e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  80098e:	0f b6 c1             	movzbl %cl,%eax
  800991:	0f b6 db             	movzbl %bl,%ebx
  800994:	29 d8                	sub    %ebx,%eax
  800996:	eb 05                	jmp    80099d <memcmp+0x2f>
	}

	return 0;
  800998:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80099d:	5b                   	pop    %ebx
  80099e:	5e                   	pop    %esi
  80099f:	5d                   	pop    %ebp
  8009a0:	c3                   	ret    

008009a1 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8009a1:	55                   	push   %ebp
  8009a2:	89 e5                	mov    %esp,%ebp
  8009a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8009aa:	89 c2                	mov    %eax,%edx
  8009ac:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8009af:	39 d0                	cmp    %edx,%eax
  8009b1:	73 07                	jae    8009ba <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8009b3:	38 08                	cmp    %cl,(%eax)
  8009b5:	74 03                	je     8009ba <memfind+0x19>
	for (; s < ends; s++)
  8009b7:	40                   	inc    %eax
  8009b8:	eb f5                	jmp    8009af <memfind+0xe>
			break;
	return (void *) s;
}
  8009ba:	5d                   	pop    %ebp
  8009bb:	c3                   	ret    

008009bc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8009bc:	55                   	push   %ebp
  8009bd:	89 e5                	mov    %esp,%ebp
  8009bf:	57                   	push   %edi
  8009c0:	56                   	push   %esi
  8009c1:	53                   	push   %ebx
  8009c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8009c5:	eb 01                	jmp    8009c8 <strtol+0xc>
		s++;
  8009c7:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8009c8:	8a 01                	mov    (%ecx),%al
  8009ca:	3c 20                	cmp    $0x20,%al
  8009cc:	74 f9                	je     8009c7 <strtol+0xb>
  8009ce:	3c 09                	cmp    $0x9,%al
  8009d0:	74 f5                	je     8009c7 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8009d2:	3c 2b                	cmp    $0x2b,%al
  8009d4:	74 2b                	je     800a01 <strtol+0x45>
		s++;
	else if (*s == '-')
  8009d6:	3c 2d                	cmp    $0x2d,%al
  8009d8:	74 2f                	je     800a09 <strtol+0x4d>
	int neg = 0;
  8009da:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8009df:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  8009e6:	75 12                	jne    8009fa <strtol+0x3e>
  8009e8:	80 39 30             	cmpb   $0x30,(%ecx)
  8009eb:	74 24                	je     800a11 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  8009ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8009f1:	75 07                	jne    8009fa <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  8009f3:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  8009fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8009ff:	eb 4e                	jmp    800a4f <strtol+0x93>
		s++;
  800a01:	41                   	inc    %ecx
	int neg = 0;
  800a02:	bf 00 00 00 00       	mov    $0x0,%edi
  800a07:	eb d6                	jmp    8009df <strtol+0x23>
		s++, neg = 1;
  800a09:	41                   	inc    %ecx
  800a0a:	bf 01 00 00 00       	mov    $0x1,%edi
  800a0f:	eb ce                	jmp    8009df <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a11:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a15:	74 10                	je     800a27 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a17:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a1b:	75 dd                	jne    8009fa <strtol+0x3e>
		s++, base = 8;
  800a1d:	41                   	inc    %ecx
  800a1e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a25:	eb d3                	jmp    8009fa <strtol+0x3e>
		s += 2, base = 16;
  800a27:	83 c1 02             	add    $0x2,%ecx
  800a2a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a31:	eb c7                	jmp    8009fa <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a33:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a36:	89 f3                	mov    %esi,%ebx
  800a38:	80 fb 19             	cmp    $0x19,%bl
  800a3b:	77 24                	ja     800a61 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800a3d:	0f be d2             	movsbl %dl,%edx
  800a40:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800a43:	3b 55 10             	cmp    0x10(%ebp),%edx
  800a46:	7d 2b                	jge    800a73 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800a48:	41                   	inc    %ecx
  800a49:	0f af 45 10          	imul   0x10(%ebp),%eax
  800a4d:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800a4f:	8a 11                	mov    (%ecx),%dl
  800a51:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800a54:	80 fb 09             	cmp    $0x9,%bl
  800a57:	77 da                	ja     800a33 <strtol+0x77>
			dig = *s - '0';
  800a59:	0f be d2             	movsbl %dl,%edx
  800a5c:	83 ea 30             	sub    $0x30,%edx
  800a5f:	eb e2                	jmp    800a43 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800a61:	8d 72 bf             	lea    -0x41(%edx),%esi
  800a64:	89 f3                	mov    %esi,%ebx
  800a66:	80 fb 19             	cmp    $0x19,%bl
  800a69:	77 08                	ja     800a73 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800a6b:	0f be d2             	movsbl %dl,%edx
  800a6e:	83 ea 37             	sub    $0x37,%edx
  800a71:	eb d0                	jmp    800a43 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800a73:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a77:	74 05                	je     800a7e <strtol+0xc2>
		*endptr = (char *) s;
  800a79:	8b 75 0c             	mov    0xc(%ebp),%esi
  800a7c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800a7e:	85 ff                	test   %edi,%edi
  800a80:	74 02                	je     800a84 <strtol+0xc8>
  800a82:	f7 d8                	neg    %eax
}
  800a84:	5b                   	pop    %ebx
  800a85:	5e                   	pop    %esi
  800a86:	5f                   	pop    %edi
  800a87:	5d                   	pop    %ebp
  800a88:	c3                   	ret    

00800a89 <atoi>:

int
atoi(const char *s)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800a8c:	6a 0a                	push   $0xa
  800a8e:	6a 00                	push   $0x0
  800a90:	ff 75 08             	pushl  0x8(%ebp)
  800a93:	e8 24 ff ff ff       	call   8009bc <strtol>
}
  800a98:	c9                   	leave  
  800a99:	c3                   	ret    

00800a9a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800a9a:	55                   	push   %ebp
  800a9b:	89 e5                	mov    %esp,%ebp
  800a9d:	57                   	push   %edi
  800a9e:	56                   	push   %esi
  800a9f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800aa5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800aa8:	8b 55 08             	mov    0x8(%ebp),%edx
  800aab:	89 c3                	mov    %eax,%ebx
  800aad:	89 c7                	mov    %eax,%edi
  800aaf:	89 c6                	mov    %eax,%esi
  800ab1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800ab3:	5b                   	pop    %ebx
  800ab4:	5e                   	pop    %esi
  800ab5:	5f                   	pop    %edi
  800ab6:	5d                   	pop    %ebp
  800ab7:	c3                   	ret    

00800ab8 <sys_cgetc>:

int
sys_cgetc(void)
{
  800ab8:	55                   	push   %ebp
  800ab9:	89 e5                	mov    %esp,%ebp
  800abb:	57                   	push   %edi
  800abc:	56                   	push   %esi
  800abd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800abe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac3:	b8 01 00 00 00       	mov    $0x1,%eax
  800ac8:	89 d1                	mov    %edx,%ecx
  800aca:	89 d3                	mov    %edx,%ebx
  800acc:	89 d7                	mov    %edx,%edi
  800ace:	89 d6                	mov    %edx,%esi
  800ad0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5f                   	pop    %edi
  800ad5:	5d                   	pop    %ebp
  800ad6:	c3                   	ret    

00800ad7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ad7:	55                   	push   %ebp
  800ad8:	89 e5                	mov    %esp,%ebp
  800ada:	57                   	push   %edi
  800adb:	56                   	push   %esi
  800adc:	53                   	push   %ebx
  800add:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ae0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800ae5:	b8 03 00 00 00       	mov    $0x3,%eax
  800aea:	8b 55 08             	mov    0x8(%ebp),%edx
  800aed:	89 cb                	mov    %ecx,%ebx
  800aef:	89 cf                	mov    %ecx,%edi
  800af1:	89 ce                	mov    %ecx,%esi
  800af3:	cd 30                	int    $0x30
	if(check && ret > 0)
  800af5:	85 c0                	test   %eax,%eax
  800af7:	7f 08                	jg     800b01 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800af9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800afc:	5b                   	pop    %ebx
  800afd:	5e                   	pop    %esi
  800afe:	5f                   	pop    %edi
  800aff:	5d                   	pop    %ebp
  800b00:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b01:	83 ec 0c             	sub    $0xc,%esp
  800b04:	50                   	push   %eax
  800b05:	6a 03                	push   $0x3
  800b07:	68 bf 22 80 00       	push   $0x8022bf
  800b0c:	6a 23                	push   $0x23
  800b0e:	68 dc 22 80 00       	push   $0x8022dc
  800b13:	e8 4b 10 00 00       	call   801b63 <_panic>

00800b18 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b18:	55                   	push   %ebp
  800b19:	89 e5                	mov    %esp,%ebp
  800b1b:	57                   	push   %edi
  800b1c:	56                   	push   %esi
  800b1d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b1e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b23:	b8 02 00 00 00       	mov    $0x2,%eax
  800b28:	89 d1                	mov    %edx,%ecx
  800b2a:	89 d3                	mov    %edx,%ebx
  800b2c:	89 d7                	mov    %edx,%edi
  800b2e:	89 d6                	mov    %edx,%esi
  800b30:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b32:	5b                   	pop    %ebx
  800b33:	5e                   	pop    %esi
  800b34:	5f                   	pop    %edi
  800b35:	5d                   	pop    %ebp
  800b36:	c3                   	ret    

00800b37 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b37:	55                   	push   %ebp
  800b38:	89 e5                	mov    %esp,%ebp
  800b3a:	57                   	push   %edi
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b40:	be 00 00 00 00       	mov    $0x0,%esi
  800b45:	b8 04 00 00 00       	mov    $0x4,%eax
  800b4a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b53:	89 f7                	mov    %esi,%edi
  800b55:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b57:	85 c0                	test   %eax,%eax
  800b59:	7f 08                	jg     800b63 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800b5b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5e:	5b                   	pop    %ebx
  800b5f:	5e                   	pop    %esi
  800b60:	5f                   	pop    %edi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b63:	83 ec 0c             	sub    $0xc,%esp
  800b66:	50                   	push   %eax
  800b67:	6a 04                	push   $0x4
  800b69:	68 bf 22 80 00       	push   $0x8022bf
  800b6e:	6a 23                	push   $0x23
  800b70:	68 dc 22 80 00       	push   $0x8022dc
  800b75:	e8 e9 0f 00 00       	call   801b63 <_panic>

00800b7a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800b7a:	55                   	push   %ebp
  800b7b:	89 e5                	mov    %esp,%ebp
  800b7d:	57                   	push   %edi
  800b7e:	56                   	push   %esi
  800b7f:	53                   	push   %ebx
  800b80:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b83:	b8 05 00 00 00       	mov    $0x5,%eax
  800b88:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b8e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800b91:	8b 7d 14             	mov    0x14(%ebp),%edi
  800b94:	8b 75 18             	mov    0x18(%ebp),%esi
  800b97:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b99:	85 c0                	test   %eax,%eax
  800b9b:	7f 08                	jg     800ba5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800b9d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ba0:	5b                   	pop    %ebx
  800ba1:	5e                   	pop    %esi
  800ba2:	5f                   	pop    %edi
  800ba3:	5d                   	pop    %ebp
  800ba4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ba5:	83 ec 0c             	sub    $0xc,%esp
  800ba8:	50                   	push   %eax
  800ba9:	6a 05                	push   $0x5
  800bab:	68 bf 22 80 00       	push   $0x8022bf
  800bb0:	6a 23                	push   $0x23
  800bb2:	68 dc 22 80 00       	push   $0x8022dc
  800bb7:	e8 a7 0f 00 00       	call   801b63 <_panic>

00800bbc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800bbc:	55                   	push   %ebp
  800bbd:	89 e5                	mov    %esp,%ebp
  800bbf:	57                   	push   %edi
  800bc0:	56                   	push   %esi
  800bc1:	53                   	push   %ebx
  800bc2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc5:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bca:	b8 06 00 00 00       	mov    $0x6,%eax
  800bcf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	89 df                	mov    %ebx,%edi
  800bd7:	89 de                	mov    %ebx,%esi
  800bd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	7f 08                	jg     800be7 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800bdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800be2:	5b                   	pop    %ebx
  800be3:	5e                   	pop    %esi
  800be4:	5f                   	pop    %edi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800be7:	83 ec 0c             	sub    $0xc,%esp
  800bea:	50                   	push   %eax
  800beb:	6a 06                	push   $0x6
  800bed:	68 bf 22 80 00       	push   $0x8022bf
  800bf2:	6a 23                	push   $0x23
  800bf4:	68 dc 22 80 00       	push   $0x8022dc
  800bf9:	e8 65 0f 00 00       	call   801b63 <_panic>

00800bfe <sys_yield>:

void
sys_yield(void)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c04:	ba 00 00 00 00       	mov    $0x0,%edx
  800c09:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c0e:	89 d1                	mov    %edx,%ecx
  800c10:	89 d3                	mov    %edx,%ebx
  800c12:	89 d7                	mov    %edx,%edi
  800c14:	89 d6                	mov    %edx,%esi
  800c16:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c18:	5b                   	pop    %ebx
  800c19:	5e                   	pop    %esi
  800c1a:	5f                   	pop    %edi
  800c1b:	5d                   	pop    %ebp
  800c1c:	c3                   	ret    

00800c1d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	57                   	push   %edi
  800c21:	56                   	push   %esi
  800c22:	53                   	push   %ebx
  800c23:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c26:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2b:	b8 08 00 00 00       	mov    $0x8,%eax
  800c30:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c33:	8b 55 08             	mov    0x8(%ebp),%edx
  800c36:	89 df                	mov    %ebx,%edi
  800c38:	89 de                	mov    %ebx,%esi
  800c3a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3c:	85 c0                	test   %eax,%eax
  800c3e:	7f 08                	jg     800c48 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800c40:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c43:	5b                   	pop    %ebx
  800c44:	5e                   	pop    %esi
  800c45:	5f                   	pop    %edi
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c48:	83 ec 0c             	sub    $0xc,%esp
  800c4b:	50                   	push   %eax
  800c4c:	6a 08                	push   $0x8
  800c4e:	68 bf 22 80 00       	push   $0x8022bf
  800c53:	6a 23                	push   $0x23
  800c55:	68 dc 22 80 00       	push   $0x8022dc
  800c5a:	e8 04 0f 00 00       	call   801b63 <_panic>

00800c5f <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800c5f:	55                   	push   %ebp
  800c60:	89 e5                	mov    %esp,%ebp
  800c62:	57                   	push   %edi
  800c63:	56                   	push   %esi
  800c64:	53                   	push   %ebx
  800c65:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c68:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c6d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800c72:	8b 55 08             	mov    0x8(%ebp),%edx
  800c75:	89 cb                	mov    %ecx,%ebx
  800c77:	89 cf                	mov    %ecx,%edi
  800c79:	89 ce                	mov    %ecx,%esi
  800c7b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c7d:	85 c0                	test   %eax,%eax
  800c7f:	7f 08                	jg     800c89 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800c81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5f                   	pop    %edi
  800c87:	5d                   	pop    %ebp
  800c88:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c89:	83 ec 0c             	sub    $0xc,%esp
  800c8c:	50                   	push   %eax
  800c8d:	6a 0c                	push   $0xc
  800c8f:	68 bf 22 80 00       	push   $0x8022bf
  800c94:	6a 23                	push   $0x23
  800c96:	68 dc 22 80 00       	push   $0x8022dc
  800c9b:	e8 c3 0e 00 00       	call   801b63 <_panic>

00800ca0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	57                   	push   %edi
  800ca4:	56                   	push   %esi
  800ca5:	53                   	push   %ebx
  800ca6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca9:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cae:	b8 09 00 00 00       	mov    $0x9,%eax
  800cb3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb9:	89 df                	mov    %ebx,%edi
  800cbb:	89 de                	mov    %ebx,%esi
  800cbd:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbf:	85 c0                	test   %eax,%eax
  800cc1:	7f 08                	jg     800ccb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800cc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc6:	5b                   	pop    %ebx
  800cc7:	5e                   	pop    %esi
  800cc8:	5f                   	pop    %edi
  800cc9:	5d                   	pop    %ebp
  800cca:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccb:	83 ec 0c             	sub    $0xc,%esp
  800cce:	50                   	push   %eax
  800ccf:	6a 09                	push   $0x9
  800cd1:	68 bf 22 80 00       	push   $0x8022bf
  800cd6:	6a 23                	push   $0x23
  800cd8:	68 dc 22 80 00       	push   $0x8022dc
  800cdd:	e8 81 0e 00 00       	call   801b63 <_panic>

00800ce2 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ce2:	55                   	push   %ebp
  800ce3:	89 e5                	mov    %esp,%ebp
  800ce5:	57                   	push   %edi
  800ce6:	56                   	push   %esi
  800ce7:	53                   	push   %ebx
  800ce8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ceb:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cf0:	b8 0a 00 00 00       	mov    $0xa,%eax
  800cf5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cf8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfb:	89 df                	mov    %ebx,%edi
  800cfd:	89 de                	mov    %ebx,%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d05:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d08:	5b                   	pop    %ebx
  800d09:	5e                   	pop    %esi
  800d0a:	5f                   	pop    %edi
  800d0b:	5d                   	pop    %ebp
  800d0c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d0d:	83 ec 0c             	sub    $0xc,%esp
  800d10:	50                   	push   %eax
  800d11:	6a 0a                	push   $0xa
  800d13:	68 bf 22 80 00       	push   $0x8022bf
  800d18:	6a 23                	push   $0x23
  800d1a:	68 dc 22 80 00       	push   $0x8022dc
  800d1f:	e8 3f 0e 00 00       	call   801b63 <_panic>

00800d24 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2a:	be 00 00 00 00       	mov    $0x0,%esi
  800d2f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d34:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d37:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d3d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d40:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d50:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d55:	b8 0e 00 00 00       	mov    $0xe,%eax
  800d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5d:	89 cb                	mov    %ecx,%ebx
  800d5f:	89 cf                	mov    %ecx,%edi
  800d61:	89 ce                	mov    %ecx,%esi
  800d63:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d65:	85 c0                	test   %eax,%eax
  800d67:	7f 08                	jg     800d71 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
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
  800d75:	6a 0e                	push   $0xe
  800d77:	68 bf 22 80 00       	push   $0x8022bf
  800d7c:	6a 23                	push   $0x23
  800d7e:	68 dc 22 80 00       	push   $0x8022dc
  800d83:	e8 db 0d 00 00       	call   801b63 <_panic>

00800d88 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	57                   	push   %edi
  800d8c:	56                   	push   %esi
  800d8d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8e:	be 00 00 00 00       	mov    $0x0,%esi
  800d93:	b8 0f 00 00 00       	mov    $0xf,%eax
  800d98:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da1:	89 f7                	mov    %esi,%edi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
	asm volatile("int %1\n"
  800db0:	be 00 00 00 00       	mov    $0x0,%esi
  800db5:	b8 10 00 00 00       	mov    $0x10,%eax
  800dba:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc3:	89 f7                	mov    %esi,%edi
  800dc5:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5f                   	pop    %edi
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <sys_set_console_color>:

void sys_set_console_color(int color) {
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	57                   	push   %edi
  800dd0:	56                   	push   %esi
  800dd1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dd2:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd7:	b8 11 00 00 00       	mov    $0x11,%eax
  800ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  800ddf:	89 cb                	mov    %ecx,%ebx
  800de1:	89 cf                	mov    %ecx,%edi
  800de3:	89 ce                	mov    %ecx,%esi
  800de5:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800de7:	5b                   	pop    %ebx
  800de8:	5e                   	pop    %esi
  800de9:	5f                   	pop    %edi
  800dea:	5d                   	pop    %ebp
  800deb:	c3                   	ret    

00800dec <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  800dec:	55                   	push   %ebp
  800ded:	89 e5                	mov    %esp,%ebp
  800def:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  800df2:	83 3d 08 40 80 00 00 	cmpl   $0x0,0x804008
  800df9:	74 0a                	je     800e05 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	a3 08 40 80 00       	mov    %eax,0x804008
}
  800e03:	c9                   	leave  
  800e04:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  800e05:	e8 0e fd ff ff       	call   800b18 <sys_getenvid>
  800e0a:	83 ec 04             	sub    $0x4,%esp
  800e0d:	6a 07                	push   $0x7
  800e0f:	68 00 f0 bf ee       	push   $0xeebff000
  800e14:	50                   	push   %eax
  800e15:	e8 1d fd ff ff       	call   800b37 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  800e1a:	e8 f9 fc ff ff       	call   800b18 <sys_getenvid>
  800e1f:	83 c4 08             	add    $0x8,%esp
  800e22:	68 32 0e 80 00       	push   $0x800e32
  800e27:	50                   	push   %eax
  800e28:	e8 b5 fe ff ff       	call   800ce2 <sys_env_set_pgfault_upcall>
  800e2d:	83 c4 10             	add    $0x10,%esp
  800e30:	eb c9                	jmp    800dfb <set_pgfault_handler+0xf>

00800e32 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  800e32:	54                   	push   %esp
	movl _pgfault_handler, %eax
  800e33:	a1 08 40 80 00       	mov    0x804008,%eax
	call *%eax
  800e38:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800e3a:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  800e3d:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  800e41:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  800e45:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800e48:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800e4a:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  800e4e:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  800e51:	61                   	popa   
	addl $4, %esp
  800e52:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  800e55:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800e56:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800e57:	c3                   	ret    

00800e58 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	05 00 00 00 30       	add    $0x30000000,%eax
  800e63:	c1 e8 0c             	shr    $0xc,%eax
}
  800e66:	5d                   	pop    %ebp
  800e67:	c3                   	ret    

00800e68 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e68:	55                   	push   %ebp
  800e69:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6e:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e73:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e78:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e7d:	5d                   	pop    %ebp
  800e7e:	c3                   	ret    

00800e7f <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e7f:	55                   	push   %ebp
  800e80:	89 e5                	mov    %esp,%ebp
  800e82:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e85:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800e8a:	89 c2                	mov    %eax,%edx
  800e8c:	c1 ea 16             	shr    $0x16,%edx
  800e8f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800e96:	f6 c2 01             	test   $0x1,%dl
  800e99:	74 2a                	je     800ec5 <fd_alloc+0x46>
  800e9b:	89 c2                	mov    %eax,%edx
  800e9d:	c1 ea 0c             	shr    $0xc,%edx
  800ea0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ea7:	f6 c2 01             	test   $0x1,%dl
  800eaa:	74 19                	je     800ec5 <fd_alloc+0x46>
  800eac:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800eb1:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800eb6:	75 d2                	jne    800e8a <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800eb8:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ebe:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800ec3:	eb 07                	jmp    800ecc <fd_alloc+0x4d>
			*fd_store = fd;
  800ec5:	89 01                	mov    %eax,(%ecx)
			return 0;
  800ec7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecc:	5d                   	pop    %ebp
  800ecd:	c3                   	ret    

00800ece <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ece:	55                   	push   %ebp
  800ecf:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ed1:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800ed5:	77 39                	ja     800f10 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	c1 e0 0c             	shl    $0xc,%eax
  800edd:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800ee2:	89 c2                	mov    %eax,%edx
  800ee4:	c1 ea 16             	shr    $0x16,%edx
  800ee7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eee:	f6 c2 01             	test   $0x1,%dl
  800ef1:	74 24                	je     800f17 <fd_lookup+0x49>
  800ef3:	89 c2                	mov    %eax,%edx
  800ef5:	c1 ea 0c             	shr    $0xc,%edx
  800ef8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800eff:	f6 c2 01             	test   $0x1,%dl
  800f02:	74 1a                	je     800f1e <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f04:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f07:	89 02                	mov    %eax,(%edx)
	return 0;
  800f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f0e:	5d                   	pop    %ebp
  800f0f:	c3                   	ret    
		return -E_INVAL;
  800f10:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f15:	eb f7                	jmp    800f0e <fd_lookup+0x40>
		return -E_INVAL;
  800f17:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f1c:	eb f0                	jmp    800f0e <fd_lookup+0x40>
  800f1e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f23:	eb e9                	jmp    800f0e <fd_lookup+0x40>

00800f25 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f25:	55                   	push   %ebp
  800f26:	89 e5                	mov    %esp,%ebp
  800f28:	83 ec 08             	sub    $0x8,%esp
  800f2b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2e:	ba 68 23 80 00       	mov    $0x802368,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f33:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f38:	39 08                	cmp    %ecx,(%eax)
  800f3a:	74 33                	je     800f6f <dev_lookup+0x4a>
  800f3c:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f3f:	8b 02                	mov    (%edx),%eax
  800f41:	85 c0                	test   %eax,%eax
  800f43:	75 f3                	jne    800f38 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f45:	a1 04 40 80 00       	mov    0x804004,%eax
  800f4a:	8b 40 48             	mov    0x48(%eax),%eax
  800f4d:	83 ec 04             	sub    $0x4,%esp
  800f50:	51                   	push   %ecx
  800f51:	50                   	push   %eax
  800f52:	68 ec 22 80 00       	push   $0x8022ec
  800f57:	e8 1e f2 ff ff       	call   80017a <cprintf>
	*dev = 0;
  800f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f5f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f65:	83 c4 10             	add    $0x10,%esp
  800f68:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f6d:	c9                   	leave  
  800f6e:	c3                   	ret    
			*dev = devtab[i];
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
  800f79:	eb f2                	jmp    800f6d <dev_lookup+0x48>

00800f7b <fd_close>:
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	57                   	push   %edi
  800f7f:	56                   	push   %esi
  800f80:	53                   	push   %ebx
  800f81:	83 ec 1c             	sub    $0x1c,%esp
  800f84:	8b 75 08             	mov    0x8(%ebp),%esi
  800f87:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f8a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800f8d:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800f8e:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800f94:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800f97:	50                   	push   %eax
  800f98:	e8 31 ff ff ff       	call   800ece <fd_lookup>
  800f9d:	89 c7                	mov    %eax,%edi
  800f9f:	83 c4 08             	add    $0x8,%esp
  800fa2:	85 c0                	test   %eax,%eax
  800fa4:	78 05                	js     800fab <fd_close+0x30>
	    || fd != fd2)
  800fa6:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800fa9:	74 13                	je     800fbe <fd_close+0x43>
		return (must_exist ? r : 0);
  800fab:	84 db                	test   %bl,%bl
  800fad:	75 05                	jne    800fb4 <fd_close+0x39>
  800faf:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800fb4:	89 f8                	mov    %edi,%eax
  800fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fb9:	5b                   	pop    %ebx
  800fba:	5e                   	pop    %esi
  800fbb:	5f                   	pop    %edi
  800fbc:	5d                   	pop    %ebp
  800fbd:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fbe:	83 ec 08             	sub    $0x8,%esp
  800fc1:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	ff 36                	pushl  (%esi)
  800fc7:	e8 59 ff ff ff       	call   800f25 <dev_lookup>
  800fcc:	89 c7                	mov    %eax,%edi
  800fce:	83 c4 10             	add    $0x10,%esp
  800fd1:	85 c0                	test   %eax,%eax
  800fd3:	78 15                	js     800fea <fd_close+0x6f>
		if (dev->dev_close)
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	8b 40 10             	mov    0x10(%eax),%eax
  800fdb:	85 c0                	test   %eax,%eax
  800fdd:	74 1b                	je     800ffa <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800fdf:	83 ec 0c             	sub    $0xc,%esp
  800fe2:	56                   	push   %esi
  800fe3:	ff d0                	call   *%eax
  800fe5:	89 c7                	mov    %eax,%edi
  800fe7:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800fea:	83 ec 08             	sub    $0x8,%esp
  800fed:	56                   	push   %esi
  800fee:	6a 00                	push   $0x0
  800ff0:	e8 c7 fb ff ff       	call   800bbc <sys_page_unmap>
	return r;
  800ff5:	83 c4 10             	add    $0x10,%esp
  800ff8:	eb ba                	jmp    800fb4 <fd_close+0x39>
			r = 0;
  800ffa:	bf 00 00 00 00       	mov    $0x0,%edi
  800fff:	eb e9                	jmp    800fea <fd_close+0x6f>

00801001 <close>:

int
close(int fdnum)
{
  801001:	55                   	push   %ebp
  801002:	89 e5                	mov    %esp,%ebp
  801004:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801007:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80100a:	50                   	push   %eax
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 bb fe ff ff       	call   800ece <fd_lookup>
  801013:	83 c4 08             	add    $0x8,%esp
  801016:	85 c0                	test   %eax,%eax
  801018:	78 10                	js     80102a <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80101a:	83 ec 08             	sub    $0x8,%esp
  80101d:	6a 01                	push   $0x1
  80101f:	ff 75 f4             	pushl  -0xc(%ebp)
  801022:	e8 54 ff ff ff       	call   800f7b <fd_close>
  801027:	83 c4 10             	add    $0x10,%esp
}
  80102a:	c9                   	leave  
  80102b:	c3                   	ret    

0080102c <close_all>:

void
close_all(void)
{
  80102c:	55                   	push   %ebp
  80102d:	89 e5                	mov    %esp,%ebp
  80102f:	53                   	push   %ebx
  801030:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801033:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801038:	83 ec 0c             	sub    $0xc,%esp
  80103b:	53                   	push   %ebx
  80103c:	e8 c0 ff ff ff       	call   801001 <close>
	for (i = 0; i < MAXFD; i++)
  801041:	43                   	inc    %ebx
  801042:	83 c4 10             	add    $0x10,%esp
  801045:	83 fb 20             	cmp    $0x20,%ebx
  801048:	75 ee                	jne    801038 <close_all+0xc>
}
  80104a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80104d:	c9                   	leave  
  80104e:	c3                   	ret    

0080104f <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	57                   	push   %edi
  801053:	56                   	push   %esi
  801054:	53                   	push   %ebx
  801055:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801058:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80105b:	50                   	push   %eax
  80105c:	ff 75 08             	pushl  0x8(%ebp)
  80105f:	e8 6a fe ff ff       	call   800ece <fd_lookup>
  801064:	89 c3                	mov    %eax,%ebx
  801066:	83 c4 08             	add    $0x8,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	0f 88 81 00 00 00    	js     8010f2 <dup+0xa3>
		return r;
	close(newfdnum);
  801071:	83 ec 0c             	sub    $0xc,%esp
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 85 ff ff ff       	call   801001 <close>

	newfd = INDEX2FD(newfdnum);
  80107c:	8b 75 0c             	mov    0xc(%ebp),%esi
  80107f:	c1 e6 0c             	shl    $0xc,%esi
  801082:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	ff 75 e4             	pushl  -0x1c(%ebp)
  80108e:	e8 d5 fd ff ff       	call   800e68 <fd2data>
  801093:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801095:	89 34 24             	mov    %esi,(%esp)
  801098:	e8 cb fd ff ff       	call   800e68 <fd2data>
  80109d:	83 c4 10             	add    $0x10,%esp
  8010a0:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010a2:	89 d8                	mov    %ebx,%eax
  8010a4:	c1 e8 16             	shr    $0x16,%eax
  8010a7:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010ae:	a8 01                	test   $0x1,%al
  8010b0:	74 11                	je     8010c3 <dup+0x74>
  8010b2:	89 d8                	mov    %ebx,%eax
  8010b4:	c1 e8 0c             	shr    $0xc,%eax
  8010b7:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010be:	f6 c2 01             	test   $0x1,%dl
  8010c1:	75 39                	jne    8010fc <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010c3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010c6:	89 d0                	mov    %edx,%eax
  8010c8:	c1 e8 0c             	shr    $0xc,%eax
  8010cb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010d2:	83 ec 0c             	sub    $0xc,%esp
  8010d5:	25 07 0e 00 00       	and    $0xe07,%eax
  8010da:	50                   	push   %eax
  8010db:	56                   	push   %esi
  8010dc:	6a 00                	push   $0x0
  8010de:	52                   	push   %edx
  8010df:	6a 00                	push   $0x0
  8010e1:	e8 94 fa ff ff       	call   800b7a <sys_page_map>
  8010e6:	89 c3                	mov    %eax,%ebx
  8010e8:	83 c4 20             	add    $0x20,%esp
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	78 31                	js     801120 <dup+0xd1>
		goto err;

	return newfdnum;
  8010ef:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8010f2:	89 d8                	mov    %ebx,%eax
  8010f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010f7:	5b                   	pop    %ebx
  8010f8:	5e                   	pop    %esi
  8010f9:	5f                   	pop    %edi
  8010fa:	5d                   	pop    %ebp
  8010fb:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8010fc:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801103:	83 ec 0c             	sub    $0xc,%esp
  801106:	25 07 0e 00 00       	and    $0xe07,%eax
  80110b:	50                   	push   %eax
  80110c:	57                   	push   %edi
  80110d:	6a 00                	push   $0x0
  80110f:	53                   	push   %ebx
  801110:	6a 00                	push   $0x0
  801112:	e8 63 fa ff ff       	call   800b7a <sys_page_map>
  801117:	89 c3                	mov    %eax,%ebx
  801119:	83 c4 20             	add    $0x20,%esp
  80111c:	85 c0                	test   %eax,%eax
  80111e:	79 a3                	jns    8010c3 <dup+0x74>
	sys_page_unmap(0, newfd);
  801120:	83 ec 08             	sub    $0x8,%esp
  801123:	56                   	push   %esi
  801124:	6a 00                	push   $0x0
  801126:	e8 91 fa ff ff       	call   800bbc <sys_page_unmap>
	sys_page_unmap(0, nva);
  80112b:	83 c4 08             	add    $0x8,%esp
  80112e:	57                   	push   %edi
  80112f:	6a 00                	push   $0x0
  801131:	e8 86 fa ff ff       	call   800bbc <sys_page_unmap>
	return r;
  801136:	83 c4 10             	add    $0x10,%esp
  801139:	eb b7                	jmp    8010f2 <dup+0xa3>

0080113b <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80113b:	55                   	push   %ebp
  80113c:	89 e5                	mov    %esp,%ebp
  80113e:	53                   	push   %ebx
  80113f:	83 ec 14             	sub    $0x14,%esp
  801142:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801145:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801148:	50                   	push   %eax
  801149:	53                   	push   %ebx
  80114a:	e8 7f fd ff ff       	call   800ece <fd_lookup>
  80114f:	83 c4 08             	add    $0x8,%esp
  801152:	85 c0                	test   %eax,%eax
  801154:	78 3f                	js     801195 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801156:	83 ec 08             	sub    $0x8,%esp
  801159:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80115c:	50                   	push   %eax
  80115d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801160:	ff 30                	pushl  (%eax)
  801162:	e8 be fd ff ff       	call   800f25 <dev_lookup>
  801167:	83 c4 10             	add    $0x10,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 27                	js     801195 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80116e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801171:	8b 42 08             	mov    0x8(%edx),%eax
  801174:	83 e0 03             	and    $0x3,%eax
  801177:	83 f8 01             	cmp    $0x1,%eax
  80117a:	74 1e                	je     80119a <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80117c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117f:	8b 40 08             	mov    0x8(%eax),%eax
  801182:	85 c0                	test   %eax,%eax
  801184:	74 35                	je     8011bb <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801186:	83 ec 04             	sub    $0x4,%esp
  801189:	ff 75 10             	pushl  0x10(%ebp)
  80118c:	ff 75 0c             	pushl  0xc(%ebp)
  80118f:	52                   	push   %edx
  801190:	ff d0                	call   *%eax
  801192:	83 c4 10             	add    $0x10,%esp
}
  801195:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801198:	c9                   	leave  
  801199:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80119a:	a1 04 40 80 00       	mov    0x804004,%eax
  80119f:	8b 40 48             	mov    0x48(%eax),%eax
  8011a2:	83 ec 04             	sub    $0x4,%esp
  8011a5:	53                   	push   %ebx
  8011a6:	50                   	push   %eax
  8011a7:	68 2d 23 80 00       	push   $0x80232d
  8011ac:	e8 c9 ef ff ff       	call   80017a <cprintf>
		return -E_INVAL;
  8011b1:	83 c4 10             	add    $0x10,%esp
  8011b4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011b9:	eb da                	jmp    801195 <read+0x5a>
		return -E_NOT_SUPP;
  8011bb:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011c0:	eb d3                	jmp    801195 <read+0x5a>

008011c2 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011c2:	55                   	push   %ebp
  8011c3:	89 e5                	mov    %esp,%ebp
  8011c5:	57                   	push   %edi
  8011c6:	56                   	push   %esi
  8011c7:	53                   	push   %ebx
  8011c8:	83 ec 0c             	sub    $0xc,%esp
  8011cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011ce:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011d6:	39 f3                	cmp    %esi,%ebx
  8011d8:	73 25                	jae    8011ff <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011da:	83 ec 04             	sub    $0x4,%esp
  8011dd:	89 f0                	mov    %esi,%eax
  8011df:	29 d8                	sub    %ebx,%eax
  8011e1:	50                   	push   %eax
  8011e2:	89 d8                	mov    %ebx,%eax
  8011e4:	03 45 0c             	add    0xc(%ebp),%eax
  8011e7:	50                   	push   %eax
  8011e8:	57                   	push   %edi
  8011e9:	e8 4d ff ff ff       	call   80113b <read>
		if (m < 0)
  8011ee:	83 c4 10             	add    $0x10,%esp
  8011f1:	85 c0                	test   %eax,%eax
  8011f3:	78 08                	js     8011fd <readn+0x3b>
			return m;
		if (m == 0)
  8011f5:	85 c0                	test   %eax,%eax
  8011f7:	74 06                	je     8011ff <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8011f9:	01 c3                	add    %eax,%ebx
  8011fb:	eb d9                	jmp    8011d6 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011fd:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8011ff:	89 d8                	mov    %ebx,%eax
  801201:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801204:	5b                   	pop    %ebx
  801205:	5e                   	pop    %esi
  801206:	5f                   	pop    %edi
  801207:	5d                   	pop    %ebp
  801208:	c3                   	ret    

00801209 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	53                   	push   %ebx
  80120d:	83 ec 14             	sub    $0x14,%esp
  801210:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801213:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801216:	50                   	push   %eax
  801217:	53                   	push   %ebx
  801218:	e8 b1 fc ff ff       	call   800ece <fd_lookup>
  80121d:	83 c4 08             	add    $0x8,%esp
  801220:	85 c0                	test   %eax,%eax
  801222:	78 3a                	js     80125e <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801224:	83 ec 08             	sub    $0x8,%esp
  801227:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80122a:	50                   	push   %eax
  80122b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80122e:	ff 30                	pushl  (%eax)
  801230:	e8 f0 fc ff ff       	call   800f25 <dev_lookup>
  801235:	83 c4 10             	add    $0x10,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 22                	js     80125e <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80123c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80123f:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801243:	74 1e                	je     801263 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801245:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801248:	8b 52 0c             	mov    0xc(%edx),%edx
  80124b:	85 d2                	test   %edx,%edx
  80124d:	74 35                	je     801284 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80124f:	83 ec 04             	sub    $0x4,%esp
  801252:	ff 75 10             	pushl  0x10(%ebp)
  801255:	ff 75 0c             	pushl  0xc(%ebp)
  801258:	50                   	push   %eax
  801259:	ff d2                	call   *%edx
  80125b:	83 c4 10             	add    $0x10,%esp
}
  80125e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801261:	c9                   	leave  
  801262:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801263:	a1 04 40 80 00       	mov    0x804004,%eax
  801268:	8b 40 48             	mov    0x48(%eax),%eax
  80126b:	83 ec 04             	sub    $0x4,%esp
  80126e:	53                   	push   %ebx
  80126f:	50                   	push   %eax
  801270:	68 49 23 80 00       	push   $0x802349
  801275:	e8 00 ef ff ff       	call   80017a <cprintf>
		return -E_INVAL;
  80127a:	83 c4 10             	add    $0x10,%esp
  80127d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801282:	eb da                	jmp    80125e <write+0x55>
		return -E_NOT_SUPP;
  801284:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801289:	eb d3                	jmp    80125e <write+0x55>

0080128b <seek>:

int
seek(int fdnum, off_t offset)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801291:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801294:	50                   	push   %eax
  801295:	ff 75 08             	pushl  0x8(%ebp)
  801298:	e8 31 fc ff ff       	call   800ece <fd_lookup>
  80129d:	83 c4 08             	add    $0x8,%esp
  8012a0:	85 c0                	test   %eax,%eax
  8012a2:	78 0e                	js     8012b2 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012aa:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b2:	c9                   	leave  
  8012b3:	c3                   	ret    

008012b4 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012b4:	55                   	push   %ebp
  8012b5:	89 e5                	mov    %esp,%ebp
  8012b7:	53                   	push   %ebx
  8012b8:	83 ec 14             	sub    $0x14,%esp
  8012bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012be:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012c1:	50                   	push   %eax
  8012c2:	53                   	push   %ebx
  8012c3:	e8 06 fc ff ff       	call   800ece <fd_lookup>
  8012c8:	83 c4 08             	add    $0x8,%esp
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	78 37                	js     801306 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012cf:	83 ec 08             	sub    $0x8,%esp
  8012d2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012d5:	50                   	push   %eax
  8012d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012d9:	ff 30                	pushl  (%eax)
  8012db:	e8 45 fc ff ff       	call   800f25 <dev_lookup>
  8012e0:	83 c4 10             	add    $0x10,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 1f                	js     801306 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012ea:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8012ee:	74 1b                	je     80130b <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8012f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012f3:	8b 52 18             	mov    0x18(%edx),%edx
  8012f6:	85 d2                	test   %edx,%edx
  8012f8:	74 32                	je     80132c <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8012fa:	83 ec 08             	sub    $0x8,%esp
  8012fd:	ff 75 0c             	pushl  0xc(%ebp)
  801300:	50                   	push   %eax
  801301:	ff d2                	call   *%edx
  801303:	83 c4 10             	add    $0x10,%esp
}
  801306:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801309:	c9                   	leave  
  80130a:	c3                   	ret    
			thisenv->env_id, fdnum);
  80130b:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801310:	8b 40 48             	mov    0x48(%eax),%eax
  801313:	83 ec 04             	sub    $0x4,%esp
  801316:	53                   	push   %ebx
  801317:	50                   	push   %eax
  801318:	68 0c 23 80 00       	push   $0x80230c
  80131d:	e8 58 ee ff ff       	call   80017a <cprintf>
		return -E_INVAL;
  801322:	83 c4 10             	add    $0x10,%esp
  801325:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80132a:	eb da                	jmp    801306 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80132c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801331:	eb d3                	jmp    801306 <ftruncate+0x52>

00801333 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801333:	55                   	push   %ebp
  801334:	89 e5                	mov    %esp,%ebp
  801336:	53                   	push   %ebx
  801337:	83 ec 14             	sub    $0x14,%esp
  80133a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80133d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801340:	50                   	push   %eax
  801341:	ff 75 08             	pushl  0x8(%ebp)
  801344:	e8 85 fb ff ff       	call   800ece <fd_lookup>
  801349:	83 c4 08             	add    $0x8,%esp
  80134c:	85 c0                	test   %eax,%eax
  80134e:	78 4b                	js     80139b <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801350:	83 ec 08             	sub    $0x8,%esp
  801353:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801356:	50                   	push   %eax
  801357:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135a:	ff 30                	pushl  (%eax)
  80135c:	e8 c4 fb ff ff       	call   800f25 <dev_lookup>
  801361:	83 c4 10             	add    $0x10,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 33                	js     80139b <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801368:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80136b:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80136f:	74 2f                	je     8013a0 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801371:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801374:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80137b:	00 00 00 
	stat->st_type = 0;
  80137e:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801385:	00 00 00 
	stat->st_dev = dev;
  801388:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80138e:	83 ec 08             	sub    $0x8,%esp
  801391:	53                   	push   %ebx
  801392:	ff 75 f0             	pushl  -0x10(%ebp)
  801395:	ff 50 14             	call   *0x14(%eax)
  801398:	83 c4 10             	add    $0x10,%esp
}
  80139b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80139e:	c9                   	leave  
  80139f:	c3                   	ret    
		return -E_NOT_SUPP;
  8013a0:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013a5:	eb f4                	jmp    80139b <fstat+0x68>

008013a7 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	56                   	push   %esi
  8013ab:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013ac:	83 ec 08             	sub    $0x8,%esp
  8013af:	6a 00                	push   $0x0
  8013b1:	ff 75 08             	pushl  0x8(%ebp)
  8013b4:	e8 34 02 00 00       	call   8015ed <open>
  8013b9:	89 c3                	mov    %eax,%ebx
  8013bb:	83 c4 10             	add    $0x10,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 1b                	js     8013dd <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	ff 75 0c             	pushl  0xc(%ebp)
  8013c8:	50                   	push   %eax
  8013c9:	e8 65 ff ff ff       	call   801333 <fstat>
  8013ce:	89 c6                	mov    %eax,%esi
	close(fd);
  8013d0:	89 1c 24             	mov    %ebx,(%esp)
  8013d3:	e8 29 fc ff ff       	call   801001 <close>
	return r;
  8013d8:	83 c4 10             	add    $0x10,%esp
  8013db:	89 f3                	mov    %esi,%ebx
}
  8013dd:	89 d8                	mov    %ebx,%eax
  8013df:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013e2:	5b                   	pop    %ebx
  8013e3:	5e                   	pop    %esi
  8013e4:	5d                   	pop    %ebp
  8013e5:	c3                   	ret    

008013e6 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013e6:	55                   	push   %ebp
  8013e7:	89 e5                	mov    %esp,%ebp
  8013e9:	56                   	push   %esi
  8013ea:	53                   	push   %ebx
  8013eb:	89 c6                	mov    %eax,%esi
  8013ed:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8013ef:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8013f6:	74 27                	je     80141f <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8013f8:	6a 07                	push   $0x7
  8013fa:	68 00 50 80 00       	push   $0x805000
  8013ff:	56                   	push   %esi
  801400:	ff 35 00 40 80 00    	pushl  0x804000
  801406:	e8 60 08 00 00       	call   801c6b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80140b:	83 c4 0c             	add    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	53                   	push   %ebx
  801411:	6a 00                	push   $0x0
  801413:	e8 ca 07 00 00       	call   801be2 <ipc_recv>
}
  801418:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80141b:	5b                   	pop    %ebx
  80141c:	5e                   	pop    %esi
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80141f:	83 ec 0c             	sub    $0xc,%esp
  801422:	6a 01                	push   $0x1
  801424:	e8 9e 08 00 00       	call   801cc7 <ipc_find_env>
  801429:	a3 00 40 80 00       	mov    %eax,0x804000
  80142e:	83 c4 10             	add    $0x10,%esp
  801431:	eb c5                	jmp    8013f8 <fsipc+0x12>

00801433 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8b 40 0c             	mov    0xc(%eax),%eax
  80143f:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801444:	8b 45 0c             	mov    0xc(%ebp),%eax
  801447:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80144c:	ba 00 00 00 00       	mov    $0x0,%edx
  801451:	b8 02 00 00 00       	mov    $0x2,%eax
  801456:	e8 8b ff ff ff       	call   8013e6 <fsipc>
}
  80145b:	c9                   	leave  
  80145c:	c3                   	ret    

0080145d <devfile_flush>:
{
  80145d:	55                   	push   %ebp
  80145e:	89 e5                	mov    %esp,%ebp
  801460:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801463:	8b 45 08             	mov    0x8(%ebp),%eax
  801466:	8b 40 0c             	mov    0xc(%eax),%eax
  801469:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80146e:	ba 00 00 00 00       	mov    $0x0,%edx
  801473:	b8 06 00 00 00       	mov    $0x6,%eax
  801478:	e8 69 ff ff ff       	call   8013e6 <fsipc>
}
  80147d:	c9                   	leave  
  80147e:	c3                   	ret    

0080147f <devfile_stat>:
{
  80147f:	55                   	push   %ebp
  801480:	89 e5                	mov    %esp,%ebp
  801482:	53                   	push   %ebx
  801483:	83 ec 04             	sub    $0x4,%esp
  801486:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8b 40 0c             	mov    0xc(%eax),%eax
  80148f:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801494:	ba 00 00 00 00       	mov    $0x0,%edx
  801499:	b8 05 00 00 00       	mov    $0x5,%eax
  80149e:	e8 43 ff ff ff       	call   8013e6 <fsipc>
  8014a3:	85 c0                	test   %eax,%eax
  8014a5:	78 2c                	js     8014d3 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014a7:	83 ec 08             	sub    $0x8,%esp
  8014aa:	68 00 50 80 00       	push   $0x805000
  8014af:	53                   	push   %ebx
  8014b0:	e8 cd f2 ff ff       	call   800782 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014b5:	a1 80 50 80 00       	mov    0x805080,%eax
  8014ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8014c0:	a1 84 50 80 00       	mov    0x805084,%eax
  8014c5:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014cb:	83 c4 10             	add    $0x10,%esp
  8014ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014d6:	c9                   	leave  
  8014d7:	c3                   	ret    

008014d8 <devfile_write>:
{
  8014d8:	55                   	push   %ebp
  8014d9:	89 e5                	mov    %esp,%ebp
  8014db:	53                   	push   %ebx
  8014dc:	83 ec 04             	sub    $0x4,%esp
  8014df:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8014e2:	89 d8                	mov    %ebx,%eax
  8014e4:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8014ea:	76 05                	jbe    8014f1 <devfile_write+0x19>
  8014ec:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8014f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f4:	8b 52 0c             	mov    0xc(%edx),%edx
  8014f7:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8014fd:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801502:	83 ec 04             	sub    $0x4,%esp
  801505:	50                   	push   %eax
  801506:	ff 75 0c             	pushl  0xc(%ebp)
  801509:	68 08 50 80 00       	push   $0x805008
  80150e:	e8 e2 f3 ff ff       	call   8008f5 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801513:	ba 00 00 00 00       	mov    $0x0,%edx
  801518:	b8 04 00 00 00       	mov    $0x4,%eax
  80151d:	e8 c4 fe ff ff       	call   8013e6 <fsipc>
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 0b                	js     801534 <devfile_write+0x5c>
	assert(r <= n);
  801529:	39 c3                	cmp    %eax,%ebx
  80152b:	72 0c                	jb     801539 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80152d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801532:	7f 1e                	jg     801552 <devfile_write+0x7a>
}
  801534:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801537:	c9                   	leave  
  801538:	c3                   	ret    
	assert(r <= n);
  801539:	68 78 23 80 00       	push   $0x802378
  80153e:	68 7f 23 80 00       	push   $0x80237f
  801543:	68 98 00 00 00       	push   $0x98
  801548:	68 94 23 80 00       	push   $0x802394
  80154d:	e8 11 06 00 00       	call   801b63 <_panic>
	assert(r <= PGSIZE);
  801552:	68 9f 23 80 00       	push   $0x80239f
  801557:	68 7f 23 80 00       	push   $0x80237f
  80155c:	68 99 00 00 00       	push   $0x99
  801561:	68 94 23 80 00       	push   $0x802394
  801566:	e8 f8 05 00 00       	call   801b63 <_panic>

0080156b <devfile_read>:
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	56                   	push   %esi
  80156f:	53                   	push   %ebx
  801570:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801573:	8b 45 08             	mov    0x8(%ebp),%eax
  801576:	8b 40 0c             	mov    0xc(%eax),%eax
  801579:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80157e:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801584:	ba 00 00 00 00       	mov    $0x0,%edx
  801589:	b8 03 00 00 00       	mov    $0x3,%eax
  80158e:	e8 53 fe ff ff       	call   8013e6 <fsipc>
  801593:	89 c3                	mov    %eax,%ebx
  801595:	85 c0                	test   %eax,%eax
  801597:	78 1f                	js     8015b8 <devfile_read+0x4d>
	assert(r <= n);
  801599:	39 c6                	cmp    %eax,%esi
  80159b:	72 24                	jb     8015c1 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80159d:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015a2:	7f 33                	jg     8015d7 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015a4:	83 ec 04             	sub    $0x4,%esp
  8015a7:	50                   	push   %eax
  8015a8:	68 00 50 80 00       	push   $0x805000
  8015ad:	ff 75 0c             	pushl  0xc(%ebp)
  8015b0:	e8 40 f3 ff ff       	call   8008f5 <memmove>
	return r;
  8015b5:	83 c4 10             	add    $0x10,%esp
}
  8015b8:	89 d8                	mov    %ebx,%eax
  8015ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015bd:	5b                   	pop    %ebx
  8015be:	5e                   	pop    %esi
  8015bf:	5d                   	pop    %ebp
  8015c0:	c3                   	ret    
	assert(r <= n);
  8015c1:	68 78 23 80 00       	push   $0x802378
  8015c6:	68 7f 23 80 00       	push   $0x80237f
  8015cb:	6a 7c                	push   $0x7c
  8015cd:	68 94 23 80 00       	push   $0x802394
  8015d2:	e8 8c 05 00 00       	call   801b63 <_panic>
	assert(r <= PGSIZE);
  8015d7:	68 9f 23 80 00       	push   $0x80239f
  8015dc:	68 7f 23 80 00       	push   $0x80237f
  8015e1:	6a 7d                	push   $0x7d
  8015e3:	68 94 23 80 00       	push   $0x802394
  8015e8:	e8 76 05 00 00       	call   801b63 <_panic>

008015ed <open>:
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	56                   	push   %esi
  8015f1:	53                   	push   %ebx
  8015f2:	83 ec 1c             	sub    $0x1c,%esp
  8015f5:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8015f8:	56                   	push   %esi
  8015f9:	e8 51 f1 ff ff       	call   80074f <strlen>
  8015fe:	83 c4 10             	add    $0x10,%esp
  801601:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801606:	7f 6c                	jg     801674 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801608:	83 ec 0c             	sub    $0xc,%esp
  80160b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	e8 6b f8 ff ff       	call   800e7f <fd_alloc>
  801614:	89 c3                	mov    %eax,%ebx
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	85 c0                	test   %eax,%eax
  80161b:	78 3c                	js     801659 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  80161d:	83 ec 08             	sub    $0x8,%esp
  801620:	56                   	push   %esi
  801621:	68 00 50 80 00       	push   $0x805000
  801626:	e8 57 f1 ff ff       	call   800782 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80162b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162e:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801636:	b8 01 00 00 00       	mov    $0x1,%eax
  80163b:	e8 a6 fd ff ff       	call   8013e6 <fsipc>
  801640:	89 c3                	mov    %eax,%ebx
  801642:	83 c4 10             	add    $0x10,%esp
  801645:	85 c0                	test   %eax,%eax
  801647:	78 19                	js     801662 <open+0x75>
	return fd2num(fd);
  801649:	83 ec 0c             	sub    $0xc,%esp
  80164c:	ff 75 f4             	pushl  -0xc(%ebp)
  80164f:	e8 04 f8 ff ff       	call   800e58 <fd2num>
  801654:	89 c3                	mov    %eax,%ebx
  801656:	83 c4 10             	add    $0x10,%esp
}
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165e:	5b                   	pop    %ebx
  80165f:	5e                   	pop    %esi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    
		fd_close(fd, 0);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	6a 00                	push   $0x0
  801667:	ff 75 f4             	pushl  -0xc(%ebp)
  80166a:	e8 0c f9 ff ff       	call   800f7b <fd_close>
		return r;
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	eb e5                	jmp    801659 <open+0x6c>
		return -E_BAD_PATH;
  801674:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801679:	eb de                	jmp    801659 <open+0x6c>

0080167b <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  80167b:	55                   	push   %ebp
  80167c:	89 e5                	mov    %esp,%ebp
  80167e:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801681:	ba 00 00 00 00       	mov    $0x0,%edx
  801686:	b8 08 00 00 00       	mov    $0x8,%eax
  80168b:	e8 56 fd ff ff       	call   8013e6 <fsipc>
}
  801690:	c9                   	leave  
  801691:	c3                   	ret    

00801692 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	56                   	push   %esi
  801696:	53                   	push   %ebx
  801697:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80169a:	83 ec 0c             	sub    $0xc,%esp
  80169d:	ff 75 08             	pushl  0x8(%ebp)
  8016a0:	e8 c3 f7 ff ff       	call   800e68 <fd2data>
  8016a5:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	68 ab 23 80 00       	push   $0x8023ab
  8016af:	53                   	push   %ebx
  8016b0:	e8 cd f0 ff ff       	call   800782 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8016b5:	8b 46 04             	mov    0x4(%esi),%eax
  8016b8:	2b 06                	sub    (%esi),%eax
  8016ba:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  8016c0:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8016c7:	10 00 00 
	stat->st_dev = &devpipe;
  8016ca:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8016d1:	30 80 00 
	return 0;
}
  8016d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8016dc:	5b                   	pop    %ebx
  8016dd:	5e                   	pop    %esi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    

008016e0 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  8016e0:	55                   	push   %ebp
  8016e1:	89 e5                	mov    %esp,%ebp
  8016e3:	53                   	push   %ebx
  8016e4:	83 ec 0c             	sub    $0xc,%esp
  8016e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  8016ea:	53                   	push   %ebx
  8016eb:	6a 00                	push   $0x0
  8016ed:	e8 ca f4 ff ff       	call   800bbc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8016f2:	89 1c 24             	mov    %ebx,(%esp)
  8016f5:	e8 6e f7 ff ff       	call   800e68 <fd2data>
  8016fa:	83 c4 08             	add    $0x8,%esp
  8016fd:	50                   	push   %eax
  8016fe:	6a 00                	push   $0x0
  801700:	e8 b7 f4 ff ff       	call   800bbc <sys_page_unmap>
}
  801705:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <_pipeisclosed>:
{
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	57                   	push   %edi
  80170e:	56                   	push   %esi
  80170f:	53                   	push   %ebx
  801710:	83 ec 1c             	sub    $0x1c,%esp
  801713:	89 c7                	mov    %eax,%edi
  801715:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801717:	a1 04 40 80 00       	mov    0x804004,%eax
  80171c:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80171f:	83 ec 0c             	sub    $0xc,%esp
  801722:	57                   	push   %edi
  801723:	e8 e1 05 00 00       	call   801d09 <pageref>
  801728:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80172b:	89 34 24             	mov    %esi,(%esp)
  80172e:	e8 d6 05 00 00       	call   801d09 <pageref>
		nn = thisenv->env_runs;
  801733:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801739:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  80173c:	83 c4 10             	add    $0x10,%esp
  80173f:	39 cb                	cmp    %ecx,%ebx
  801741:	74 1b                	je     80175e <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801743:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801746:	75 cf                	jne    801717 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801748:	8b 42 58             	mov    0x58(%edx),%eax
  80174b:	6a 01                	push   $0x1
  80174d:	50                   	push   %eax
  80174e:	53                   	push   %ebx
  80174f:	68 b2 23 80 00       	push   $0x8023b2
  801754:	e8 21 ea ff ff       	call   80017a <cprintf>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	eb b9                	jmp    801717 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80175e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801761:	0f 94 c0             	sete   %al
  801764:	0f b6 c0             	movzbl %al,%eax
}
  801767:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80176a:	5b                   	pop    %ebx
  80176b:	5e                   	pop    %esi
  80176c:	5f                   	pop    %edi
  80176d:	5d                   	pop    %ebp
  80176e:	c3                   	ret    

0080176f <devpipe_write>:
{
  80176f:	55                   	push   %ebp
  801770:	89 e5                	mov    %esp,%ebp
  801772:	57                   	push   %edi
  801773:	56                   	push   %esi
  801774:	53                   	push   %ebx
  801775:	83 ec 18             	sub    $0x18,%esp
  801778:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80177b:	56                   	push   %esi
  80177c:	e8 e7 f6 ff ff       	call   800e68 <fd2data>
  801781:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	bf 00 00 00 00       	mov    $0x0,%edi
  80178b:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80178e:	74 41                	je     8017d1 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801790:	8b 53 04             	mov    0x4(%ebx),%edx
  801793:	8b 03                	mov    (%ebx),%eax
  801795:	83 c0 20             	add    $0x20,%eax
  801798:	39 c2                	cmp    %eax,%edx
  80179a:	72 14                	jb     8017b0 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80179c:	89 da                	mov    %ebx,%edx
  80179e:	89 f0                	mov    %esi,%eax
  8017a0:	e8 65 ff ff ff       	call   80170a <_pipeisclosed>
  8017a5:	85 c0                	test   %eax,%eax
  8017a7:	75 2c                	jne    8017d5 <devpipe_write+0x66>
			sys_yield();
  8017a9:	e8 50 f4 ff ff       	call   800bfe <sys_yield>
  8017ae:	eb e0                	jmp    801790 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017b3:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8017b6:	89 d0                	mov    %edx,%eax
  8017b8:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8017bd:	78 0b                	js     8017ca <devpipe_write+0x5b>
  8017bf:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8017c3:	42                   	inc    %edx
  8017c4:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8017c7:	47                   	inc    %edi
  8017c8:	eb c1                	jmp    80178b <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8017ca:	48                   	dec    %eax
  8017cb:	83 c8 e0             	or     $0xffffffe0,%eax
  8017ce:	40                   	inc    %eax
  8017cf:	eb ee                	jmp    8017bf <devpipe_write+0x50>
	return i;
  8017d1:	89 f8                	mov    %edi,%eax
  8017d3:	eb 05                	jmp    8017da <devpipe_write+0x6b>
				return 0;
  8017d5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017da:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017dd:	5b                   	pop    %ebx
  8017de:	5e                   	pop    %esi
  8017df:	5f                   	pop    %edi
  8017e0:	5d                   	pop    %ebp
  8017e1:	c3                   	ret    

008017e2 <devpipe_read>:
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
  8017e5:	57                   	push   %edi
  8017e6:	56                   	push   %esi
  8017e7:	53                   	push   %ebx
  8017e8:	83 ec 18             	sub    $0x18,%esp
  8017eb:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  8017ee:	57                   	push   %edi
  8017ef:	e8 74 f6 ff ff       	call   800e68 <fd2data>
  8017f4:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  8017f6:	83 c4 10             	add    $0x10,%esp
  8017f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017fe:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801801:	74 46                	je     801849 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801803:	8b 06                	mov    (%esi),%eax
  801805:	3b 46 04             	cmp    0x4(%esi),%eax
  801808:	75 22                	jne    80182c <devpipe_read+0x4a>
			if (i > 0)
  80180a:	85 db                	test   %ebx,%ebx
  80180c:	74 0a                	je     801818 <devpipe_read+0x36>
				return i;
  80180e:	89 d8                	mov    %ebx,%eax
}
  801810:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801813:	5b                   	pop    %ebx
  801814:	5e                   	pop    %esi
  801815:	5f                   	pop    %edi
  801816:	5d                   	pop    %ebp
  801817:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801818:	89 f2                	mov    %esi,%edx
  80181a:	89 f8                	mov    %edi,%eax
  80181c:	e8 e9 fe ff ff       	call   80170a <_pipeisclosed>
  801821:	85 c0                	test   %eax,%eax
  801823:	75 28                	jne    80184d <devpipe_read+0x6b>
			sys_yield();
  801825:	e8 d4 f3 ff ff       	call   800bfe <sys_yield>
  80182a:	eb d7                	jmp    801803 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80182c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801831:	78 0f                	js     801842 <devpipe_read+0x60>
  801833:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801837:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80183a:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80183d:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  80183f:	43                   	inc    %ebx
  801840:	eb bc                	jmp    8017fe <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801842:	48                   	dec    %eax
  801843:	83 c8 e0             	or     $0xffffffe0,%eax
  801846:	40                   	inc    %eax
  801847:	eb ea                	jmp    801833 <devpipe_read+0x51>
	return i;
  801849:	89 d8                	mov    %ebx,%eax
  80184b:	eb c3                	jmp    801810 <devpipe_read+0x2e>
				return 0;
  80184d:	b8 00 00 00 00       	mov    $0x0,%eax
  801852:	eb bc                	jmp    801810 <devpipe_read+0x2e>

00801854 <pipe>:
{
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
  801859:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  80185c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80185f:	50                   	push   %eax
  801860:	e8 1a f6 ff ff       	call   800e7f <fd_alloc>
  801865:	89 c3                	mov    %eax,%ebx
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	85 c0                	test   %eax,%eax
  80186c:	0f 88 2a 01 00 00    	js     80199c <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801872:	83 ec 04             	sub    $0x4,%esp
  801875:	68 07 04 00 00       	push   $0x407
  80187a:	ff 75 f4             	pushl  -0xc(%ebp)
  80187d:	6a 00                	push   $0x0
  80187f:	e8 b3 f2 ff ff       	call   800b37 <sys_page_alloc>
  801884:	89 c3                	mov    %eax,%ebx
  801886:	83 c4 10             	add    $0x10,%esp
  801889:	85 c0                	test   %eax,%eax
  80188b:	0f 88 0b 01 00 00    	js     80199c <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801891:	83 ec 0c             	sub    $0xc,%esp
  801894:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801897:	50                   	push   %eax
  801898:	e8 e2 f5 ff ff       	call   800e7f <fd_alloc>
  80189d:	89 c3                	mov    %eax,%ebx
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	85 c0                	test   %eax,%eax
  8018a4:	0f 88 e2 00 00 00    	js     80198c <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	68 07 04 00 00       	push   $0x407
  8018b2:	ff 75 f0             	pushl  -0x10(%ebp)
  8018b5:	6a 00                	push   $0x0
  8018b7:	e8 7b f2 ff ff       	call   800b37 <sys_page_alloc>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	0f 88 c3 00 00 00    	js     80198c <pipe+0x138>
	va = fd2data(fd0);
  8018c9:	83 ec 0c             	sub    $0xc,%esp
  8018cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cf:	e8 94 f5 ff ff       	call   800e68 <fd2data>
  8018d4:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018d6:	83 c4 0c             	add    $0xc,%esp
  8018d9:	68 07 04 00 00       	push   $0x407
  8018de:	50                   	push   %eax
  8018df:	6a 00                	push   $0x0
  8018e1:	e8 51 f2 ff ff       	call   800b37 <sys_page_alloc>
  8018e6:	89 c3                	mov    %eax,%ebx
  8018e8:	83 c4 10             	add    $0x10,%esp
  8018eb:	85 c0                	test   %eax,%eax
  8018ed:	0f 88 89 00 00 00    	js     80197c <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8018f3:	83 ec 0c             	sub    $0xc,%esp
  8018f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8018f9:	e8 6a f5 ff ff       	call   800e68 <fd2data>
  8018fe:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801905:	50                   	push   %eax
  801906:	6a 00                	push   $0x0
  801908:	56                   	push   %esi
  801909:	6a 00                	push   $0x0
  80190b:	e8 6a f2 ff ff       	call   800b7a <sys_page_map>
  801910:	89 c3                	mov    %eax,%ebx
  801912:	83 c4 20             	add    $0x20,%esp
  801915:	85 c0                	test   %eax,%eax
  801917:	78 55                	js     80196e <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801919:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80191f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801922:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801927:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80192e:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801934:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801937:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801939:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80193c:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801943:	83 ec 0c             	sub    $0xc,%esp
  801946:	ff 75 f4             	pushl  -0xc(%ebp)
  801949:	e8 0a f5 ff ff       	call   800e58 <fd2num>
  80194e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801951:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801953:	83 c4 04             	add    $0x4,%esp
  801956:	ff 75 f0             	pushl  -0x10(%ebp)
  801959:	e8 fa f4 ff ff       	call   800e58 <fd2num>
  80195e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801961:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801964:	83 c4 10             	add    $0x10,%esp
  801967:	bb 00 00 00 00       	mov    $0x0,%ebx
  80196c:	eb 2e                	jmp    80199c <pipe+0x148>
	sys_page_unmap(0, va);
  80196e:	83 ec 08             	sub    $0x8,%esp
  801971:	56                   	push   %esi
  801972:	6a 00                	push   $0x0
  801974:	e8 43 f2 ff ff       	call   800bbc <sys_page_unmap>
  801979:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80197c:	83 ec 08             	sub    $0x8,%esp
  80197f:	ff 75 f0             	pushl  -0x10(%ebp)
  801982:	6a 00                	push   $0x0
  801984:	e8 33 f2 ff ff       	call   800bbc <sys_page_unmap>
  801989:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80198c:	83 ec 08             	sub    $0x8,%esp
  80198f:	ff 75 f4             	pushl  -0xc(%ebp)
  801992:	6a 00                	push   $0x0
  801994:	e8 23 f2 ff ff       	call   800bbc <sys_page_unmap>
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    

008019a5 <pipeisclosed>:
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
  8019a8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ae:	50                   	push   %eax
  8019af:	ff 75 08             	pushl  0x8(%ebp)
  8019b2:	e8 17 f5 ff ff       	call   800ece <fd_lookup>
  8019b7:	83 c4 10             	add    $0x10,%esp
  8019ba:	85 c0                	test   %eax,%eax
  8019bc:	78 18                	js     8019d6 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8019be:	83 ec 0c             	sub    $0xc,%esp
  8019c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8019c4:	e8 9f f4 ff ff       	call   800e68 <fd2data>
	return _pipeisclosed(fd, p);
  8019c9:	89 c2                	mov    %eax,%edx
  8019cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019ce:	e8 37 fd ff ff       	call   80170a <_pipeisclosed>
  8019d3:	83 c4 10             	add    $0x10,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8019db:	b8 00 00 00 00       	mov    $0x0,%eax
  8019e0:	5d                   	pop    %ebp
  8019e1:	c3                   	ret    

008019e2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8019e2:	55                   	push   %ebp
  8019e3:	89 e5                	mov    %esp,%ebp
  8019e5:	53                   	push   %ebx
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8019ec:	68 ca 23 80 00       	push   $0x8023ca
  8019f1:	53                   	push   %ebx
  8019f2:	e8 8b ed ff ff       	call   800782 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8019f7:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8019fe:	20 00 00 
	return 0;
}
  801a01:	b8 00 00 00 00       	mov    $0x0,%eax
  801a06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <devcons_write>:
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
  801a0e:	57                   	push   %edi
  801a0f:	56                   	push   %esi
  801a10:	53                   	push   %ebx
  801a11:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801a17:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801a1c:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801a22:	eb 1d                	jmp    801a41 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801a24:	83 ec 04             	sub    $0x4,%esp
  801a27:	53                   	push   %ebx
  801a28:	03 45 0c             	add    0xc(%ebp),%eax
  801a2b:	50                   	push   %eax
  801a2c:	57                   	push   %edi
  801a2d:	e8 c3 ee ff ff       	call   8008f5 <memmove>
		sys_cputs(buf, m);
  801a32:	83 c4 08             	add    $0x8,%esp
  801a35:	53                   	push   %ebx
  801a36:	57                   	push   %edi
  801a37:	e8 5e f0 ff ff       	call   800a9a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801a3c:	01 de                	add    %ebx,%esi
  801a3e:	83 c4 10             	add    $0x10,%esp
  801a41:	89 f0                	mov    %esi,%eax
  801a43:	3b 75 10             	cmp    0x10(%ebp),%esi
  801a46:	73 11                	jae    801a59 <devcons_write+0x4e>
		m = n - tot;
  801a48:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801a4b:	29 f3                	sub    %esi,%ebx
  801a4d:	83 fb 7f             	cmp    $0x7f,%ebx
  801a50:	76 d2                	jbe    801a24 <devcons_write+0x19>
  801a52:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801a57:	eb cb                	jmp    801a24 <devcons_write+0x19>
}
  801a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a5c:	5b                   	pop    %ebx
  801a5d:	5e                   	pop    %esi
  801a5e:	5f                   	pop    %edi
  801a5f:	5d                   	pop    %ebp
  801a60:	c3                   	ret    

00801a61 <devcons_read>:
{
  801a61:	55                   	push   %ebp
  801a62:	89 e5                	mov    %esp,%ebp
  801a64:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801a67:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a6b:	75 0c                	jne    801a79 <devcons_read+0x18>
		return 0;
  801a6d:	b8 00 00 00 00       	mov    $0x0,%eax
  801a72:	eb 21                	jmp    801a95 <devcons_read+0x34>
		sys_yield();
  801a74:	e8 85 f1 ff ff       	call   800bfe <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801a79:	e8 3a f0 ff ff       	call   800ab8 <sys_cgetc>
  801a7e:	85 c0                	test   %eax,%eax
  801a80:	74 f2                	je     801a74 <devcons_read+0x13>
	if (c < 0)
  801a82:	85 c0                	test   %eax,%eax
  801a84:	78 0f                	js     801a95 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801a86:	83 f8 04             	cmp    $0x4,%eax
  801a89:	74 0c                	je     801a97 <devcons_read+0x36>
	*(char*)vbuf = c;
  801a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a8e:	88 02                	mov    %al,(%edx)
	return 1;
  801a90:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    
		return 0;
  801a97:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9c:	eb f7                	jmp    801a95 <devcons_read+0x34>

00801a9e <cputchar>:
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa7:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801aaa:	6a 01                	push   $0x1
  801aac:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801aaf:	50                   	push   %eax
  801ab0:	e8 e5 ef ff ff       	call   800a9a <sys_cputs>
}
  801ab5:	83 c4 10             	add    $0x10,%esp
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <getchar>:
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
  801abd:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ac0:	6a 01                	push   $0x1
  801ac2:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ac5:	50                   	push   %eax
  801ac6:	6a 00                	push   $0x0
  801ac8:	e8 6e f6 ff ff       	call   80113b <read>
	if (r < 0)
  801acd:	83 c4 10             	add    $0x10,%esp
  801ad0:	85 c0                	test   %eax,%eax
  801ad2:	78 08                	js     801adc <getchar+0x22>
	if (r < 1)
  801ad4:	85 c0                	test   %eax,%eax
  801ad6:	7e 06                	jle    801ade <getchar+0x24>
	return c;
  801ad8:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    
		return -E_EOF;
  801ade:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ae3:	eb f7                	jmp    801adc <getchar+0x22>

00801ae5 <iscons>:
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801aeb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801aee:	50                   	push   %eax
  801aef:	ff 75 08             	pushl  0x8(%ebp)
  801af2:	e8 d7 f3 ff ff       	call   800ece <fd_lookup>
  801af7:	83 c4 10             	add    $0x10,%esp
  801afa:	85 c0                	test   %eax,%eax
  801afc:	78 11                	js     801b0f <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801afe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b01:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b07:	39 10                	cmp    %edx,(%eax)
  801b09:	0f 94 c0             	sete   %al
  801b0c:	0f b6 c0             	movzbl %al,%eax
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <opencons>:
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
  801b14:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801b17:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b1a:	50                   	push   %eax
  801b1b:	e8 5f f3 ff ff       	call   800e7f <fd_alloc>
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	85 c0                	test   %eax,%eax
  801b25:	78 3a                	js     801b61 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801b27:	83 ec 04             	sub    $0x4,%esp
  801b2a:	68 07 04 00 00       	push   $0x407
  801b2f:	ff 75 f4             	pushl  -0xc(%ebp)
  801b32:	6a 00                	push   $0x0
  801b34:	e8 fe ef ff ff       	call   800b37 <sys_page_alloc>
  801b39:	83 c4 10             	add    $0x10,%esp
  801b3c:	85 c0                	test   %eax,%eax
  801b3e:	78 21                	js     801b61 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801b40:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b49:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801b55:	83 ec 0c             	sub    $0xc,%esp
  801b58:	50                   	push   %eax
  801b59:	e8 fa f2 ff ff       	call   800e58 <fd2num>
  801b5e:	83 c4 10             	add    $0x10,%esp
}
  801b61:	c9                   	leave  
  801b62:	c3                   	ret    

00801b63 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801b63:	55                   	push   %ebp
  801b64:	89 e5                	mov    %esp,%ebp
  801b66:	57                   	push   %edi
  801b67:	56                   	push   %esi
  801b68:	53                   	push   %ebx
  801b69:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801b6f:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801b72:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801b78:	e8 9b ef ff ff       	call   800b18 <sys_getenvid>
  801b7d:	83 ec 04             	sub    $0x4,%esp
  801b80:	ff 75 0c             	pushl  0xc(%ebp)
  801b83:	ff 75 08             	pushl  0x8(%ebp)
  801b86:	53                   	push   %ebx
  801b87:	50                   	push   %eax
  801b88:	68 d8 23 80 00       	push   $0x8023d8
  801b8d:	68 00 01 00 00       	push   $0x100
  801b92:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801b98:	56                   	push   %esi
  801b99:	e8 97 eb ff ff       	call   800735 <snprintf>
  801b9e:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801ba0:	83 c4 20             	add    $0x20,%esp
  801ba3:	57                   	push   %edi
  801ba4:	ff 75 10             	pushl  0x10(%ebp)
  801ba7:	bf 00 01 00 00       	mov    $0x100,%edi
  801bac:	89 f8                	mov    %edi,%eax
  801bae:	29 d8                	sub    %ebx,%eax
  801bb0:	50                   	push   %eax
  801bb1:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801bb4:	50                   	push   %eax
  801bb5:	e8 26 eb ff ff       	call   8006e0 <vsnprintf>
  801bba:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801bbc:	83 c4 0c             	add    $0xc,%esp
  801bbf:	68 c3 23 80 00       	push   $0x8023c3
  801bc4:	29 df                	sub    %ebx,%edi
  801bc6:	57                   	push   %edi
  801bc7:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801bca:	50                   	push   %eax
  801bcb:	e8 65 eb ff ff       	call   800735 <snprintf>
	sys_cputs(buf, r);
  801bd0:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801bd3:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801bd5:	53                   	push   %ebx
  801bd6:	56                   	push   %esi
  801bd7:	e8 be ee ff ff       	call   800a9a <sys_cputs>
  801bdc:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801bdf:	cc                   	int3   
  801be0:	eb fd                	jmp    801bdf <_panic+0x7c>

00801be2 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
  801be5:	57                   	push   %edi
  801be6:	56                   	push   %esi
  801be7:	53                   	push   %ebx
  801be8:	83 ec 0c             	sub    $0xc,%esp
  801beb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bee:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801bf1:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801bf4:	85 ff                	test   %edi,%edi
  801bf6:	74 53                	je     801c4b <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801bf8:	83 ec 0c             	sub    $0xc,%esp
  801bfb:	57                   	push   %edi
  801bfc:	e8 46 f1 ff ff       	call   800d47 <sys_ipc_recv>
  801c01:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801c04:	85 db                	test   %ebx,%ebx
  801c06:	74 0b                	je     801c13 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801c08:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c0e:	8b 52 74             	mov    0x74(%edx),%edx
  801c11:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801c13:	85 f6                	test   %esi,%esi
  801c15:	74 0f                	je     801c26 <ipc_recv+0x44>
  801c17:	85 ff                	test   %edi,%edi
  801c19:	74 0b                	je     801c26 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801c1b:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801c21:	8b 52 78             	mov    0x78(%edx),%edx
  801c24:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801c26:	85 c0                	test   %eax,%eax
  801c28:	74 30                	je     801c5a <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801c2a:	85 db                	test   %ebx,%ebx
  801c2c:	74 06                	je     801c34 <ipc_recv+0x52>
      		*from_env_store = 0;
  801c2e:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c34:	85 f6                	test   %esi,%esi
  801c36:	74 2c                	je     801c64 <ipc_recv+0x82>
      		*perm_store = 0;
  801c38:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c3e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c46:	5b                   	pop    %ebx
  801c47:	5e                   	pop    %esi
  801c48:	5f                   	pop    %edi
  801c49:	5d                   	pop    %ebp
  801c4a:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c4b:	83 ec 0c             	sub    $0xc,%esp
  801c4e:	6a ff                	push   $0xffffffff
  801c50:	e8 f2 f0 ff ff       	call   800d47 <sys_ipc_recv>
  801c55:	83 c4 10             	add    $0x10,%esp
  801c58:	eb aa                	jmp    801c04 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c5a:	a1 04 40 80 00       	mov    0x804004,%eax
  801c5f:	8b 40 70             	mov    0x70(%eax),%eax
  801c62:	eb df                	jmp    801c43 <ipc_recv+0x61>
		return -1;
  801c64:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c69:	eb d8                	jmp    801c43 <ipc_recv+0x61>

00801c6b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	57                   	push   %edi
  801c6f:	56                   	push   %esi
  801c70:	53                   	push   %ebx
  801c71:	83 ec 0c             	sub    $0xc,%esp
  801c74:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c77:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c7a:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c7d:	85 db                	test   %ebx,%ebx
  801c7f:	75 22                	jne    801ca3 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c81:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c86:	eb 1b                	jmp    801ca3 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c88:	68 fc 23 80 00       	push   $0x8023fc
  801c8d:	68 7f 23 80 00       	push   $0x80237f
  801c92:	6a 48                	push   $0x48
  801c94:	68 20 24 80 00       	push   $0x802420
  801c99:	e8 c5 fe ff ff       	call   801b63 <_panic>
		sys_yield();
  801c9e:	e8 5b ef ff ff       	call   800bfe <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801ca3:	57                   	push   %edi
  801ca4:	53                   	push   %ebx
  801ca5:	56                   	push   %esi
  801ca6:	ff 75 08             	pushl  0x8(%ebp)
  801ca9:	e8 76 f0 ff ff       	call   800d24 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801cae:	83 c4 10             	add    $0x10,%esp
  801cb1:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801cb4:	74 e8                	je     801c9e <ipc_send+0x33>
  801cb6:	85 c0                	test   %eax,%eax
  801cb8:	75 ce                	jne    801c88 <ipc_send+0x1d>
		sys_yield();
  801cba:	e8 3f ef ff ff       	call   800bfe <sys_yield>
		
	}
	
}
  801cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cc2:	5b                   	pop    %ebx
  801cc3:	5e                   	pop    %esi
  801cc4:	5f                   	pop    %edi
  801cc5:	5d                   	pop    %ebp
  801cc6:	c3                   	ret    

00801cc7 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801cc7:	55                   	push   %ebp
  801cc8:	89 e5                	mov    %esp,%ebp
  801cca:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ccd:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801cd2:	89 c2                	mov    %eax,%edx
  801cd4:	c1 e2 05             	shl    $0x5,%edx
  801cd7:	29 c2                	sub    %eax,%edx
  801cd9:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801ce0:	8b 52 50             	mov    0x50(%edx),%edx
  801ce3:	39 ca                	cmp    %ecx,%edx
  801ce5:	74 0f                	je     801cf6 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801ce7:	40                   	inc    %eax
  801ce8:	3d 00 04 00 00       	cmp    $0x400,%eax
  801ced:	75 e3                	jne    801cd2 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801cef:	b8 00 00 00 00       	mov    $0x0,%eax
  801cf4:	eb 11                	jmp    801d07 <ipc_find_env+0x40>
			return envs[i].env_id;
  801cf6:	89 c2                	mov    %eax,%edx
  801cf8:	c1 e2 05             	shl    $0x5,%edx
  801cfb:	29 c2                	sub    %eax,%edx
  801cfd:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801d04:	8b 40 48             	mov    0x48(%eax),%eax
}
  801d07:	5d                   	pop    %ebp
  801d08:	c3                   	ret    

00801d09 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0f:	c1 e8 16             	shr    $0x16,%eax
  801d12:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801d19:	a8 01                	test   $0x1,%al
  801d1b:	74 21                	je     801d3e <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	c1 e8 0c             	shr    $0xc,%eax
  801d23:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801d2a:	a8 01                	test   $0x1,%al
  801d2c:	74 17                	je     801d45 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d2e:	c1 e8 0c             	shr    $0xc,%eax
  801d31:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d38:	ef 
  801d39:	0f b7 c0             	movzwl %ax,%eax
  801d3c:	eb 05                	jmp    801d43 <pageref+0x3a>
		return 0;
  801d3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d43:	5d                   	pop    %ebp
  801d44:	c3                   	ret    
		return 0;
  801d45:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4a:	eb f7                	jmp    801d43 <pageref+0x3a>

00801d4c <__udivdi3>:
  801d4c:	55                   	push   %ebp
  801d4d:	57                   	push   %edi
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	83 ec 1c             	sub    $0x1c,%esp
  801d53:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d57:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d5f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d63:	89 ca                	mov    %ecx,%edx
  801d65:	89 f8                	mov    %edi,%eax
  801d67:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d6b:	85 f6                	test   %esi,%esi
  801d6d:	75 2d                	jne    801d9c <__udivdi3+0x50>
  801d6f:	39 cf                	cmp    %ecx,%edi
  801d71:	77 65                	ja     801dd8 <__udivdi3+0x8c>
  801d73:	89 fd                	mov    %edi,%ebp
  801d75:	85 ff                	test   %edi,%edi
  801d77:	75 0b                	jne    801d84 <__udivdi3+0x38>
  801d79:	b8 01 00 00 00       	mov    $0x1,%eax
  801d7e:	31 d2                	xor    %edx,%edx
  801d80:	f7 f7                	div    %edi
  801d82:	89 c5                	mov    %eax,%ebp
  801d84:	31 d2                	xor    %edx,%edx
  801d86:	89 c8                	mov    %ecx,%eax
  801d88:	f7 f5                	div    %ebp
  801d8a:	89 c1                	mov    %eax,%ecx
  801d8c:	89 d8                	mov    %ebx,%eax
  801d8e:	f7 f5                	div    %ebp
  801d90:	89 cf                	mov    %ecx,%edi
  801d92:	89 fa                	mov    %edi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	39 ce                	cmp    %ecx,%esi
  801d9e:	77 28                	ja     801dc8 <__udivdi3+0x7c>
  801da0:	0f bd fe             	bsr    %esi,%edi
  801da3:	83 f7 1f             	xor    $0x1f,%edi
  801da6:	75 40                	jne    801de8 <__udivdi3+0x9c>
  801da8:	39 ce                	cmp    %ecx,%esi
  801daa:	72 0a                	jb     801db6 <__udivdi3+0x6a>
  801dac:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801db0:	0f 87 9e 00 00 00    	ja     801e54 <__udivdi3+0x108>
  801db6:	b8 01 00 00 00       	mov    $0x1,%eax
  801dbb:	89 fa                	mov    %edi,%edx
  801dbd:	83 c4 1c             	add    $0x1c,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5f                   	pop    %edi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    
  801dc5:	8d 76 00             	lea    0x0(%esi),%esi
  801dc8:	31 ff                	xor    %edi,%edi
  801dca:	31 c0                	xor    %eax,%eax
  801dcc:	89 fa                	mov    %edi,%edx
  801dce:	83 c4 1c             	add    $0x1c,%esp
  801dd1:	5b                   	pop    %ebx
  801dd2:	5e                   	pop    %esi
  801dd3:	5f                   	pop    %edi
  801dd4:	5d                   	pop    %ebp
  801dd5:	c3                   	ret    
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	89 d8                	mov    %ebx,%eax
  801dda:	f7 f7                	div    %edi
  801ddc:	31 ff                	xor    %edi,%edi
  801dde:	89 fa                	mov    %edi,%edx
  801de0:	83 c4 1c             	add    $0x1c,%esp
  801de3:	5b                   	pop    %ebx
  801de4:	5e                   	pop    %esi
  801de5:	5f                   	pop    %edi
  801de6:	5d                   	pop    %ebp
  801de7:	c3                   	ret    
  801de8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801ded:	29 fd                	sub    %edi,%ebp
  801def:	89 f9                	mov    %edi,%ecx
  801df1:	d3 e6                	shl    %cl,%esi
  801df3:	89 c3                	mov    %eax,%ebx
  801df5:	89 e9                	mov    %ebp,%ecx
  801df7:	d3 eb                	shr    %cl,%ebx
  801df9:	89 d9                	mov    %ebx,%ecx
  801dfb:	09 f1                	or     %esi,%ecx
  801dfd:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e01:	89 f9                	mov    %edi,%ecx
  801e03:	d3 e0                	shl    %cl,%eax
  801e05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e09:	89 d6                	mov    %edx,%esi
  801e0b:	89 e9                	mov    %ebp,%ecx
  801e0d:	d3 ee                	shr    %cl,%esi
  801e0f:	89 f9                	mov    %edi,%ecx
  801e11:	d3 e2                	shl    %cl,%edx
  801e13:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801e17:	89 e9                	mov    %ebp,%ecx
  801e19:	d3 eb                	shr    %cl,%ebx
  801e1b:	09 da                	or     %ebx,%edx
  801e1d:	89 d0                	mov    %edx,%eax
  801e1f:	89 f2                	mov    %esi,%edx
  801e21:	f7 74 24 08          	divl   0x8(%esp)
  801e25:	89 d6                	mov    %edx,%esi
  801e27:	89 c3                	mov    %eax,%ebx
  801e29:	f7 64 24 0c          	mull   0xc(%esp)
  801e2d:	39 d6                	cmp    %edx,%esi
  801e2f:	72 17                	jb     801e48 <__udivdi3+0xfc>
  801e31:	74 09                	je     801e3c <__udivdi3+0xf0>
  801e33:	89 d8                	mov    %ebx,%eax
  801e35:	31 ff                	xor    %edi,%edi
  801e37:	e9 56 ff ff ff       	jmp    801d92 <__udivdi3+0x46>
  801e3c:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e40:	89 f9                	mov    %edi,%ecx
  801e42:	d3 e2                	shl    %cl,%edx
  801e44:	39 c2                	cmp    %eax,%edx
  801e46:	73 eb                	jae    801e33 <__udivdi3+0xe7>
  801e48:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e4b:	31 ff                	xor    %edi,%edi
  801e4d:	e9 40 ff ff ff       	jmp    801d92 <__udivdi3+0x46>
  801e52:	66 90                	xchg   %ax,%ax
  801e54:	31 c0                	xor    %eax,%eax
  801e56:	e9 37 ff ff ff       	jmp    801d92 <__udivdi3+0x46>
  801e5b:	90                   	nop

00801e5c <__umoddi3>:
  801e5c:	55                   	push   %ebp
  801e5d:	57                   	push   %edi
  801e5e:	56                   	push   %esi
  801e5f:	53                   	push   %ebx
  801e60:	83 ec 1c             	sub    $0x1c,%esp
  801e63:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e67:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e6b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e6f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e77:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e7b:	89 3c 24             	mov    %edi,(%esp)
  801e7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e82:	89 f2                	mov    %esi,%edx
  801e84:	85 c0                	test   %eax,%eax
  801e86:	75 18                	jne    801ea0 <__umoddi3+0x44>
  801e88:	39 f7                	cmp    %esi,%edi
  801e8a:	0f 86 a0 00 00 00    	jbe    801f30 <__umoddi3+0xd4>
  801e90:	89 c8                	mov    %ecx,%eax
  801e92:	f7 f7                	div    %edi
  801e94:	89 d0                	mov    %edx,%eax
  801e96:	31 d2                	xor    %edx,%edx
  801e98:	83 c4 1c             	add    $0x1c,%esp
  801e9b:	5b                   	pop    %ebx
  801e9c:	5e                   	pop    %esi
  801e9d:	5f                   	pop    %edi
  801e9e:	5d                   	pop    %ebp
  801e9f:	c3                   	ret    
  801ea0:	89 f3                	mov    %esi,%ebx
  801ea2:	39 f0                	cmp    %esi,%eax
  801ea4:	0f 87 a6 00 00 00    	ja     801f50 <__umoddi3+0xf4>
  801eaa:	0f bd e8             	bsr    %eax,%ebp
  801ead:	83 f5 1f             	xor    $0x1f,%ebp
  801eb0:	0f 84 a6 00 00 00    	je     801f5c <__umoddi3+0x100>
  801eb6:	bf 20 00 00 00       	mov    $0x20,%edi
  801ebb:	29 ef                	sub    %ebp,%edi
  801ebd:	89 e9                	mov    %ebp,%ecx
  801ebf:	d3 e0                	shl    %cl,%eax
  801ec1:	8b 34 24             	mov    (%esp),%esi
  801ec4:	89 f2                	mov    %esi,%edx
  801ec6:	89 f9                	mov    %edi,%ecx
  801ec8:	d3 ea                	shr    %cl,%edx
  801eca:	09 c2                	or     %eax,%edx
  801ecc:	89 14 24             	mov    %edx,(%esp)
  801ecf:	89 f2                	mov    %esi,%edx
  801ed1:	89 e9                	mov    %ebp,%ecx
  801ed3:	d3 e2                	shl    %cl,%edx
  801ed5:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ed9:	89 de                	mov    %ebx,%esi
  801edb:	89 f9                	mov    %edi,%ecx
  801edd:	d3 ee                	shr    %cl,%esi
  801edf:	89 e9                	mov    %ebp,%ecx
  801ee1:	d3 e3                	shl    %cl,%ebx
  801ee3:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ee7:	89 d0                	mov    %edx,%eax
  801ee9:	89 f9                	mov    %edi,%ecx
  801eeb:	d3 e8                	shr    %cl,%eax
  801eed:	09 d8                	or     %ebx,%eax
  801eef:	89 d3                	mov    %edx,%ebx
  801ef1:	89 e9                	mov    %ebp,%ecx
  801ef3:	d3 e3                	shl    %cl,%ebx
  801ef5:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ef9:	89 f2                	mov    %esi,%edx
  801efb:	f7 34 24             	divl   (%esp)
  801efe:	89 d6                	mov    %edx,%esi
  801f00:	f7 64 24 04          	mull   0x4(%esp)
  801f04:	89 c3                	mov    %eax,%ebx
  801f06:	89 d1                	mov    %edx,%ecx
  801f08:	39 d6                	cmp    %edx,%esi
  801f0a:	72 7c                	jb     801f88 <__umoddi3+0x12c>
  801f0c:	74 72                	je     801f80 <__umoddi3+0x124>
  801f0e:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f12:	29 da                	sub    %ebx,%edx
  801f14:	19 ce                	sbb    %ecx,%esi
  801f16:	89 f0                	mov    %esi,%eax
  801f18:	89 f9                	mov    %edi,%ecx
  801f1a:	d3 e0                	shl    %cl,%eax
  801f1c:	89 e9                	mov    %ebp,%ecx
  801f1e:	d3 ea                	shr    %cl,%edx
  801f20:	09 d0                	or     %edx,%eax
  801f22:	89 e9                	mov    %ebp,%ecx
  801f24:	d3 ee                	shr    %cl,%esi
  801f26:	89 f2                	mov    %esi,%edx
  801f28:	83 c4 1c             	add    $0x1c,%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5f                   	pop    %edi
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    
  801f30:	89 fd                	mov    %edi,%ebp
  801f32:	85 ff                	test   %edi,%edi
  801f34:	75 0b                	jne    801f41 <__umoddi3+0xe5>
  801f36:	b8 01 00 00 00       	mov    $0x1,%eax
  801f3b:	31 d2                	xor    %edx,%edx
  801f3d:	f7 f7                	div    %edi
  801f3f:	89 c5                	mov    %eax,%ebp
  801f41:	89 f0                	mov    %esi,%eax
  801f43:	31 d2                	xor    %edx,%edx
  801f45:	f7 f5                	div    %ebp
  801f47:	89 c8                	mov    %ecx,%eax
  801f49:	f7 f5                	div    %ebp
  801f4b:	e9 44 ff ff ff       	jmp    801e94 <__umoddi3+0x38>
  801f50:	89 c8                	mov    %ecx,%eax
  801f52:	89 f2                	mov    %esi,%edx
  801f54:	83 c4 1c             	add    $0x1c,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    
  801f5c:	39 f0                	cmp    %esi,%eax
  801f5e:	72 05                	jb     801f65 <__umoddi3+0x109>
  801f60:	39 0c 24             	cmp    %ecx,(%esp)
  801f63:	77 0c                	ja     801f71 <__umoddi3+0x115>
  801f65:	89 f2                	mov    %esi,%edx
  801f67:	29 f9                	sub    %edi,%ecx
  801f69:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f6d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f71:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f75:	83 c4 1c             	add    $0x1c,%esp
  801f78:	5b                   	pop    %ebx
  801f79:	5e                   	pop    %esi
  801f7a:	5f                   	pop    %edi
  801f7b:	5d                   	pop    %ebp
  801f7c:	c3                   	ret    
  801f7d:	8d 76 00             	lea    0x0(%esi),%esi
  801f80:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f84:	73 88                	jae    801f0e <__umoddi3+0xb2>
  801f86:	66 90                	xchg   %ax,%ax
  801f88:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f8c:	1b 14 24             	sbb    (%esp),%edx
  801f8f:	89 d1                	mov    %edx,%ecx
  801f91:	89 c3                	mov    %eax,%ebx
  801f93:	e9 76 ff ff ff       	jmp    801f0e <__umoddi3+0xb2>
