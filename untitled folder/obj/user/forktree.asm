
obj/user/forktree.debug:     file format elf32-i386


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
  80002c:	e8 b2 00 00 00       	call   8000e3 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <forktree>:
	}
}

void
forktree(const char *cur)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 04             	sub    $0x4,%esp
  80003a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	cprintf("%04x: I am '%s'\n", sys_getenvid(), cur);
  80003d:	e8 39 0b 00 00       	call   800b7b <sys_getenvid>
  800042:	83 ec 04             	sub    $0x4,%esp
  800045:	53                   	push   %ebx
  800046:	50                   	push   %eax
  800047:	68 80 22 80 00       	push   $0x802280
  80004c:	e8 8c 01 00 00       	call   8001dd <cprintf>

	forkchild(cur, '0');
  800051:	83 c4 08             	add    $0x8,%esp
  800054:	6a 30                	push   $0x30
  800056:	53                   	push   %ebx
  800057:	e8 13 00 00 00       	call   80006f <forkchild>
	forkchild(cur, '1');
  80005c:	83 c4 08             	add    $0x8,%esp
  80005f:	6a 31                	push   $0x31
  800061:	53                   	push   %ebx
  800062:	e8 08 00 00 00       	call   80006f <forkchild>
}
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80006d:	c9                   	leave  
  80006e:	c3                   	ret    

0080006f <forkchild>:
{
  80006f:	55                   	push   %ebp
  800070:	89 e5                	mov    %esp,%ebp
  800072:	56                   	push   %esi
  800073:	53                   	push   %ebx
  800074:	83 ec 1c             	sub    $0x1c,%esp
  800077:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80007a:	8b 75 0c             	mov    0xc(%ebp),%esi
	if (strlen(cur) >= DEPTH)
  80007d:	53                   	push   %ebx
  80007e:	e8 2f 07 00 00       	call   8007b2 <strlen>
  800083:	83 c4 10             	add    $0x10,%esp
  800086:	83 f8 02             	cmp    $0x2,%eax
  800089:	7e 07                	jle    800092 <forkchild+0x23>
}
  80008b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008e:	5b                   	pop    %ebx
  80008f:	5e                   	pop    %esi
  800090:	5d                   	pop    %ebp
  800091:	c3                   	ret    
	snprintf(nxt, DEPTH+1, "%s%c", cur, branch);
  800092:	83 ec 0c             	sub    $0xc,%esp
  800095:	89 f0                	mov    %esi,%eax
  800097:	0f be f0             	movsbl %al,%esi
  80009a:	56                   	push   %esi
  80009b:	53                   	push   %ebx
  80009c:	68 91 22 80 00       	push   $0x802291
  8000a1:	6a 04                	push   $0x4
  8000a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000a6:	50                   	push   %eax
  8000a7:	e8 ec 06 00 00       	call   800798 <snprintf>
	int id = fork();
  8000ac:	83 c4 20             	add    $0x20,%esp
  8000af:	e8 5f 0e 00 00       	call   800f13 <fork>
	if (id == 0) {
  8000b4:	85 c0                	test   %eax,%eax
  8000b6:	75 d3                	jne    80008b <forkchild+0x1c>
		forktree(nxt);
  8000b8:	83 ec 0c             	sub    $0xc,%esp
  8000bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8000be:	50                   	push   %eax
  8000bf:	e8 6f ff ff ff       	call   800033 <forktree>
		exit();
  8000c4:	e8 66 00 00 00       	call   80012f <exit>
  8000c9:	83 c4 10             	add    $0x10,%esp
  8000cc:	eb bd                	jmp    80008b <forkchild+0x1c>

008000ce <umain>:

void
umain(int argc, char **argv)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	83 ec 14             	sub    $0x14,%esp
	forktree("");
  8000d4:	68 90 22 80 00       	push   $0x802290
  8000d9:	e8 55 ff ff ff       	call   800033 <forktree>
}
  8000de:	83 c4 10             	add    $0x10,%esp
  8000e1:	c9                   	leave  
  8000e2:	c3                   	ret    

008000e3 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8000e3:	55                   	push   %ebp
  8000e4:	89 e5                	mov    %esp,%ebp
  8000e6:	56                   	push   %esi
  8000e7:	53                   	push   %ebx
  8000e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8000eb:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8000ee:	e8 88 0a 00 00       	call   800b7b <sys_getenvid>
  8000f3:	25 ff 03 00 00       	and    $0x3ff,%eax
  8000f8:	89 c2                	mov    %eax,%edx
  8000fa:	c1 e2 05             	shl    $0x5,%edx
  8000fd:	29 c2                	sub    %eax,%edx
  8000ff:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800106:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80010b:	85 db                	test   %ebx,%ebx
  80010d:	7e 07                	jle    800116 <libmain+0x33>
		binaryname = argv[0];
  80010f:	8b 06                	mov    (%esi),%eax
  800111:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800116:	83 ec 08             	sub    $0x8,%esp
  800119:	56                   	push   %esi
  80011a:	53                   	push   %ebx
  80011b:	e8 ae ff ff ff       	call   8000ce <umain>

	// exit gracefully
	exit();
  800120:	e8 0a 00 00 00       	call   80012f <exit>
}
  800125:	83 c4 10             	add    $0x10,%esp
  800128:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80012b:	5b                   	pop    %ebx
  80012c:	5e                   	pop    %esi
  80012d:	5d                   	pop    %ebp
  80012e:	c3                   	ret    

0080012f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80012f:	55                   	push   %ebp
  800130:	89 e5                	mov    %esp,%ebp
  800132:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800135:	e8 6e 11 00 00       	call   8012a8 <close_all>
	sys_env_destroy(0);
  80013a:	83 ec 0c             	sub    $0xc,%esp
  80013d:	6a 00                	push   $0x0
  80013f:	e8 f6 09 00 00       	call   800b3a <sys_env_destroy>
}
  800144:	83 c4 10             	add    $0x10,%esp
  800147:	c9                   	leave  
  800148:	c3                   	ret    

00800149 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	53                   	push   %ebx
  80014d:	83 ec 04             	sub    $0x4,%esp
  800150:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800153:	8b 13                	mov    (%ebx),%edx
  800155:	8d 42 01             	lea    0x1(%edx),%eax
  800158:	89 03                	mov    %eax,(%ebx)
  80015a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80015d:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800161:	3d ff 00 00 00       	cmp    $0xff,%eax
  800166:	74 08                	je     800170 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800168:	ff 43 04             	incl   0x4(%ebx)
}
  80016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80016e:	c9                   	leave  
  80016f:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800170:	83 ec 08             	sub    $0x8,%esp
  800173:	68 ff 00 00 00       	push   $0xff
  800178:	8d 43 08             	lea    0x8(%ebx),%eax
  80017b:	50                   	push   %eax
  80017c:	e8 7c 09 00 00       	call   800afd <sys_cputs>
		b->idx = 0;
  800181:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800187:	83 c4 10             	add    $0x10,%esp
  80018a:	eb dc                	jmp    800168 <putch+0x1f>

0080018c <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80018c:	55                   	push   %ebp
  80018d:	89 e5                	mov    %esp,%ebp
  80018f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800195:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80019c:	00 00 00 
	b.cnt = 0;
  80019f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001a6:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8001b5:	50                   	push   %eax
  8001b6:	68 49 01 80 00       	push   $0x800149
  8001bb:	e8 17 01 00 00       	call   8002d7 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8001c0:	83 c4 08             	add    $0x8,%esp
  8001c3:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8001c9:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8001cf:	50                   	push   %eax
  8001d0:	e8 28 09 00 00       	call   800afd <sys_cputs>

	return b.cnt;
}
  8001d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8001db:	c9                   	leave  
  8001dc:	c3                   	ret    

008001dd <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8001dd:	55                   	push   %ebp
  8001de:	89 e5                	mov    %esp,%ebp
  8001e0:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8001e3:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8001e6:	50                   	push   %eax
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 9d ff ff ff       	call   80018c <vcprintf>
	va_end(ap);

	return cnt;
}
  8001ef:	c9                   	leave  
  8001f0:	c3                   	ret    

008001f1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8001f1:	55                   	push   %ebp
  8001f2:	89 e5                	mov    %esp,%ebp
  8001f4:	57                   	push   %edi
  8001f5:	56                   	push   %esi
  8001f6:	53                   	push   %ebx
  8001f7:	83 ec 1c             	sub    $0x1c,%esp
  8001fa:	89 c7                	mov    %eax,%edi
  8001fc:	89 d6                	mov    %edx,%esi
  8001fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800201:	8b 55 0c             	mov    0xc(%ebp),%edx
  800204:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800207:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80020a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80020d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800212:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800215:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800218:	39 d3                	cmp    %edx,%ebx
  80021a:	72 05                	jb     800221 <printnum+0x30>
  80021c:	39 45 10             	cmp    %eax,0x10(%ebp)
  80021f:	77 78                	ja     800299 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	ff 75 18             	pushl  0x18(%ebp)
  800227:	8b 45 14             	mov    0x14(%ebp),%eax
  80022a:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80022d:	53                   	push   %ebx
  80022e:	ff 75 10             	pushl  0x10(%ebp)
  800231:	83 ec 08             	sub    $0x8,%esp
  800234:	ff 75 e4             	pushl  -0x1c(%ebp)
  800237:	ff 75 e0             	pushl  -0x20(%ebp)
  80023a:	ff 75 dc             	pushl  -0x24(%ebp)
  80023d:	ff 75 d8             	pushl  -0x28(%ebp)
  800240:	e8 ef 1d 00 00       	call   802034 <__udivdi3>
  800245:	83 c4 18             	add    $0x18,%esp
  800248:	52                   	push   %edx
  800249:	50                   	push   %eax
  80024a:	89 f2                	mov    %esi,%edx
  80024c:	89 f8                	mov    %edi,%eax
  80024e:	e8 9e ff ff ff       	call   8001f1 <printnum>
  800253:	83 c4 20             	add    $0x20,%esp
  800256:	eb 11                	jmp    800269 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800258:	83 ec 08             	sub    $0x8,%esp
  80025b:	56                   	push   %esi
  80025c:	ff 75 18             	pushl  0x18(%ebp)
  80025f:	ff d7                	call   *%edi
  800261:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800264:	4b                   	dec    %ebx
  800265:	85 db                	test   %ebx,%ebx
  800267:	7f ef                	jg     800258 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800269:	83 ec 08             	sub    $0x8,%esp
  80026c:	56                   	push   %esi
  80026d:	83 ec 04             	sub    $0x4,%esp
  800270:	ff 75 e4             	pushl  -0x1c(%ebp)
  800273:	ff 75 e0             	pushl  -0x20(%ebp)
  800276:	ff 75 dc             	pushl  -0x24(%ebp)
  800279:	ff 75 d8             	pushl  -0x28(%ebp)
  80027c:	e8 c3 1e 00 00       	call   802144 <__umoddi3>
  800281:	83 c4 14             	add    $0x14,%esp
  800284:	0f be 80 a0 22 80 00 	movsbl 0x8022a0(%eax),%eax
  80028b:	50                   	push   %eax
  80028c:	ff d7                	call   *%edi
}
  80028e:	83 c4 10             	add    $0x10,%esp
  800291:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800294:	5b                   	pop    %ebx
  800295:	5e                   	pop    %esi
  800296:	5f                   	pop    %edi
  800297:	5d                   	pop    %ebp
  800298:	c3                   	ret    
  800299:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80029c:	eb c6                	jmp    800264 <printnum+0x73>

0080029e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80029e:	55                   	push   %ebp
  80029f:	89 e5                	mov    %esp,%ebp
  8002a1:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002a4:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002a7:	8b 10                	mov    (%eax),%edx
  8002a9:	3b 50 04             	cmp    0x4(%eax),%edx
  8002ac:	73 0a                	jae    8002b8 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002ae:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002b1:	89 08                	mov    %ecx,(%eax)
  8002b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b6:	88 02                	mov    %al,(%edx)
}
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    

008002ba <printfmt>:
{
  8002ba:	55                   	push   %ebp
  8002bb:	89 e5                	mov    %esp,%ebp
  8002bd:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002c0:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002c3:	50                   	push   %eax
  8002c4:	ff 75 10             	pushl  0x10(%ebp)
  8002c7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ca:	ff 75 08             	pushl  0x8(%ebp)
  8002cd:	e8 05 00 00 00       	call   8002d7 <vprintfmt>
}
  8002d2:	83 c4 10             	add    $0x10,%esp
  8002d5:	c9                   	leave  
  8002d6:	c3                   	ret    

008002d7 <vprintfmt>:
{
  8002d7:	55                   	push   %ebp
  8002d8:	89 e5                	mov    %esp,%ebp
  8002da:	57                   	push   %edi
  8002db:	56                   	push   %esi
  8002dc:	53                   	push   %ebx
  8002dd:	83 ec 2c             	sub    $0x2c,%esp
  8002e0:	8b 75 08             	mov    0x8(%ebp),%esi
  8002e3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8002e6:	8b 7d 10             	mov    0x10(%ebp),%edi
  8002e9:	e9 ae 03 00 00       	jmp    80069c <vprintfmt+0x3c5>
  8002ee:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8002f2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8002f9:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800300:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800307:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80030c:	8d 47 01             	lea    0x1(%edi),%eax
  80030f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800312:	8a 17                	mov    (%edi),%dl
  800314:	8d 42 dd             	lea    -0x23(%edx),%eax
  800317:	3c 55                	cmp    $0x55,%al
  800319:	0f 87 fe 03 00 00    	ja     80071d <vprintfmt+0x446>
  80031f:	0f b6 c0             	movzbl %al,%eax
  800322:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  800329:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80032c:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800330:	eb da                	jmp    80030c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800332:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800335:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800339:	eb d1                	jmp    80030c <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80033b:	0f b6 d2             	movzbl %dl,%edx
  80033e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800341:	b8 00 00 00 00       	mov    $0x0,%eax
  800346:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800349:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80034c:	01 c0                	add    %eax,%eax
  80034e:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800352:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800355:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800358:	83 f9 09             	cmp    $0x9,%ecx
  80035b:	77 52                	ja     8003af <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80035d:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80035e:	eb e9                	jmp    800349 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800360:	8b 45 14             	mov    0x14(%ebp),%eax
  800363:	8b 00                	mov    (%eax),%eax
  800365:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800368:	8b 45 14             	mov    0x14(%ebp),%eax
  80036b:	8d 40 04             	lea    0x4(%eax),%eax
  80036e:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800371:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800374:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800378:	79 92                	jns    80030c <vprintfmt+0x35>
				width = precision, precision = -1;
  80037a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80037d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800380:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800387:	eb 83                	jmp    80030c <vprintfmt+0x35>
  800389:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80038d:	78 08                	js     800397 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80038f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800392:	e9 75 ff ff ff       	jmp    80030c <vprintfmt+0x35>
  800397:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80039e:	eb ef                	jmp    80038f <vprintfmt+0xb8>
  8003a0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003a3:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003aa:	e9 5d ff ff ff       	jmp    80030c <vprintfmt+0x35>
  8003af:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b5:	eb bd                	jmp    800374 <vprintfmt+0x9d>
			lflag++;
  8003b7:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003b8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003bb:	e9 4c ff ff ff       	jmp    80030c <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8003c3:	8d 78 04             	lea    0x4(%eax),%edi
  8003c6:	83 ec 08             	sub    $0x8,%esp
  8003c9:	53                   	push   %ebx
  8003ca:	ff 30                	pushl  (%eax)
  8003cc:	ff d6                	call   *%esi
			break;
  8003ce:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003d1:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003d4:	e9 c0 02 00 00       	jmp    800699 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8003dc:	8d 78 04             	lea    0x4(%eax),%edi
  8003df:	8b 00                	mov    (%eax),%eax
  8003e1:	85 c0                	test   %eax,%eax
  8003e3:	78 2a                	js     80040f <vprintfmt+0x138>
  8003e5:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8003e7:	83 f8 0f             	cmp    $0xf,%eax
  8003ea:	7f 27                	jg     800413 <vprintfmt+0x13c>
  8003ec:	8b 04 85 40 25 80 00 	mov    0x802540(,%eax,4),%eax
  8003f3:	85 c0                	test   %eax,%eax
  8003f5:	74 1c                	je     800413 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8003f7:	50                   	push   %eax
  8003f8:	68 68 26 80 00       	push   $0x802668
  8003fd:	53                   	push   %ebx
  8003fe:	56                   	push   %esi
  8003ff:	e8 b6 fe ff ff       	call   8002ba <printfmt>
  800404:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800407:	89 7d 14             	mov    %edi,0x14(%ebp)
  80040a:	e9 8a 02 00 00       	jmp    800699 <vprintfmt+0x3c2>
  80040f:	f7 d8                	neg    %eax
  800411:	eb d2                	jmp    8003e5 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800413:	52                   	push   %edx
  800414:	68 b8 22 80 00       	push   $0x8022b8
  800419:	53                   	push   %ebx
  80041a:	56                   	push   %esi
  80041b:	e8 9a fe ff ff       	call   8002ba <printfmt>
  800420:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800423:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800426:	e9 6e 02 00 00       	jmp    800699 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80042b:	8b 45 14             	mov    0x14(%ebp),%eax
  80042e:	83 c0 04             	add    $0x4,%eax
  800431:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800434:	8b 45 14             	mov    0x14(%ebp),%eax
  800437:	8b 38                	mov    (%eax),%edi
  800439:	85 ff                	test   %edi,%edi
  80043b:	74 39                	je     800476 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80043d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800441:	0f 8e a9 00 00 00    	jle    8004f0 <vprintfmt+0x219>
  800447:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80044b:	0f 84 a7 00 00 00    	je     8004f8 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800451:	83 ec 08             	sub    $0x8,%esp
  800454:	ff 75 d0             	pushl  -0x30(%ebp)
  800457:	57                   	push   %edi
  800458:	e8 6b 03 00 00       	call   8007c8 <strnlen>
  80045d:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800460:	29 c1                	sub    %eax,%ecx
  800462:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800465:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800468:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80046c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80046f:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800472:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800474:	eb 14                	jmp    80048a <vprintfmt+0x1b3>
				p = "(null)";
  800476:	bf b1 22 80 00       	mov    $0x8022b1,%edi
  80047b:	eb c0                	jmp    80043d <vprintfmt+0x166>
					putch(padc, putdat);
  80047d:	83 ec 08             	sub    $0x8,%esp
  800480:	53                   	push   %ebx
  800481:	ff 75 e0             	pushl  -0x20(%ebp)
  800484:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800486:	4f                   	dec    %edi
  800487:	83 c4 10             	add    $0x10,%esp
  80048a:	85 ff                	test   %edi,%edi
  80048c:	7f ef                	jg     80047d <vprintfmt+0x1a6>
  80048e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800491:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800494:	89 c8                	mov    %ecx,%eax
  800496:	85 c9                	test   %ecx,%ecx
  800498:	78 10                	js     8004aa <vprintfmt+0x1d3>
  80049a:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80049d:	29 c1                	sub    %eax,%ecx
  80049f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004a2:	89 75 08             	mov    %esi,0x8(%ebp)
  8004a5:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004a8:	eb 15                	jmp    8004bf <vprintfmt+0x1e8>
  8004aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8004af:	eb e9                	jmp    80049a <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004b1:	83 ec 08             	sub    $0x8,%esp
  8004b4:	53                   	push   %ebx
  8004b5:	52                   	push   %edx
  8004b6:	ff 55 08             	call   *0x8(%ebp)
  8004b9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004bc:	ff 4d e0             	decl   -0x20(%ebp)
  8004bf:	47                   	inc    %edi
  8004c0:	8a 47 ff             	mov    -0x1(%edi),%al
  8004c3:	0f be d0             	movsbl %al,%edx
  8004c6:	85 d2                	test   %edx,%edx
  8004c8:	74 59                	je     800523 <vprintfmt+0x24c>
  8004ca:	85 f6                	test   %esi,%esi
  8004cc:	78 03                	js     8004d1 <vprintfmt+0x1fa>
  8004ce:	4e                   	dec    %esi
  8004cf:	78 2f                	js     800500 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004d5:	74 da                	je     8004b1 <vprintfmt+0x1da>
  8004d7:	0f be c0             	movsbl %al,%eax
  8004da:	83 e8 20             	sub    $0x20,%eax
  8004dd:	83 f8 5e             	cmp    $0x5e,%eax
  8004e0:	76 cf                	jbe    8004b1 <vprintfmt+0x1da>
					putch('?', putdat);
  8004e2:	83 ec 08             	sub    $0x8,%esp
  8004e5:	53                   	push   %ebx
  8004e6:	6a 3f                	push   $0x3f
  8004e8:	ff 55 08             	call   *0x8(%ebp)
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	eb cc                	jmp    8004bc <vprintfmt+0x1e5>
  8004f0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f6:	eb c7                	jmp    8004bf <vprintfmt+0x1e8>
  8004f8:	89 75 08             	mov    %esi,0x8(%ebp)
  8004fb:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004fe:	eb bf                	jmp    8004bf <vprintfmt+0x1e8>
  800500:	8b 75 08             	mov    0x8(%ebp),%esi
  800503:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800506:	eb 0c                	jmp    800514 <vprintfmt+0x23d>
				putch(' ', putdat);
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	53                   	push   %ebx
  80050c:	6a 20                	push   $0x20
  80050e:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800510:	4f                   	dec    %edi
  800511:	83 c4 10             	add    $0x10,%esp
  800514:	85 ff                	test   %edi,%edi
  800516:	7f f0                	jg     800508 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800518:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80051b:	89 45 14             	mov    %eax,0x14(%ebp)
  80051e:	e9 76 01 00 00       	jmp    800699 <vprintfmt+0x3c2>
  800523:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800526:	8b 75 08             	mov    0x8(%ebp),%esi
  800529:	eb e9                	jmp    800514 <vprintfmt+0x23d>
	if (lflag >= 2)
  80052b:	83 f9 01             	cmp    $0x1,%ecx
  80052e:	7f 1f                	jg     80054f <vprintfmt+0x278>
	else if (lflag)
  800530:	85 c9                	test   %ecx,%ecx
  800532:	75 48                	jne    80057c <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800534:	8b 45 14             	mov    0x14(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80053c:	89 c1                	mov    %eax,%ecx
  80053e:	c1 f9 1f             	sar    $0x1f,%ecx
  800541:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800544:	8b 45 14             	mov    0x14(%ebp),%eax
  800547:	8d 40 04             	lea    0x4(%eax),%eax
  80054a:	89 45 14             	mov    %eax,0x14(%ebp)
  80054d:	eb 17                	jmp    800566 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80054f:	8b 45 14             	mov    0x14(%ebp),%eax
  800552:	8b 50 04             	mov    0x4(%eax),%edx
  800555:	8b 00                	mov    (%eax),%eax
  800557:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80055d:	8b 45 14             	mov    0x14(%ebp),%eax
  800560:	8d 40 08             	lea    0x8(%eax),%eax
  800563:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800566:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800569:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80056c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800570:	78 25                	js     800597 <vprintfmt+0x2c0>
			base = 10;
  800572:	b8 0a 00 00 00       	mov    $0xa,%eax
  800577:	e9 03 01 00 00       	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80057c:	8b 45 14             	mov    0x14(%ebp),%eax
  80057f:	8b 00                	mov    (%eax),%eax
  800581:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800584:	89 c1                	mov    %eax,%ecx
  800586:	c1 f9 1f             	sar    $0x1f,%ecx
  800589:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80058c:	8b 45 14             	mov    0x14(%ebp),%eax
  80058f:	8d 40 04             	lea    0x4(%eax),%eax
  800592:	89 45 14             	mov    %eax,0x14(%ebp)
  800595:	eb cf                	jmp    800566 <vprintfmt+0x28f>
				putch('-', putdat);
  800597:	83 ec 08             	sub    $0x8,%esp
  80059a:	53                   	push   %ebx
  80059b:	6a 2d                	push   $0x2d
  80059d:	ff d6                	call   *%esi
				num = -(long long) num;
  80059f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005a2:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005a5:	f7 da                	neg    %edx
  8005a7:	83 d1 00             	adc    $0x0,%ecx
  8005aa:	f7 d9                	neg    %ecx
  8005ac:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005b4:	e9 c6 00 00 00       	jmp    80067f <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005b9:	83 f9 01             	cmp    $0x1,%ecx
  8005bc:	7f 1e                	jg     8005dc <vprintfmt+0x305>
	else if (lflag)
  8005be:	85 c9                	test   %ecx,%ecx
  8005c0:	75 32                	jne    8005f4 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8005c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005c5:	8b 10                	mov    (%eax),%edx
  8005c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005cc:	8d 40 04             	lea    0x4(%eax),%eax
  8005cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005d2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d7:	e9 a3 00 00 00       	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8005df:	8b 10                	mov    (%eax),%edx
  8005e1:	8b 48 04             	mov    0x4(%eax),%ecx
  8005e4:	8d 40 08             	lea    0x8(%eax),%eax
  8005e7:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005ef:	e9 8b 00 00 00       	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8005f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f7:	8b 10                	mov    (%eax),%edx
  8005f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005fe:	8d 40 04             	lea    0x4(%eax),%eax
  800601:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800604:	b8 0a 00 00 00       	mov    $0xa,%eax
  800609:	eb 74                	jmp    80067f <vprintfmt+0x3a8>
	if (lflag >= 2)
  80060b:	83 f9 01             	cmp    $0x1,%ecx
  80060e:	7f 1b                	jg     80062b <vprintfmt+0x354>
	else if (lflag)
  800610:	85 c9                	test   %ecx,%ecx
  800612:	75 2c                	jne    800640 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	8b 10                	mov    (%eax),%edx
  800619:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061e:	8d 40 04             	lea    0x4(%eax),%eax
  800621:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800624:	b8 08 00 00 00       	mov    $0x8,%eax
  800629:	eb 54                	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80062b:	8b 45 14             	mov    0x14(%ebp),%eax
  80062e:	8b 10                	mov    (%eax),%edx
  800630:	8b 48 04             	mov    0x4(%eax),%ecx
  800633:	8d 40 08             	lea    0x8(%eax),%eax
  800636:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800639:	b8 08 00 00 00       	mov    $0x8,%eax
  80063e:	eb 3f                	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800640:	8b 45 14             	mov    0x14(%ebp),%eax
  800643:	8b 10                	mov    (%eax),%edx
  800645:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064a:	8d 40 04             	lea    0x4(%eax),%eax
  80064d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800650:	b8 08 00 00 00       	mov    $0x8,%eax
  800655:	eb 28                	jmp    80067f <vprintfmt+0x3a8>
			putch('0', putdat);
  800657:	83 ec 08             	sub    $0x8,%esp
  80065a:	53                   	push   %ebx
  80065b:	6a 30                	push   $0x30
  80065d:	ff d6                	call   *%esi
			putch('x', putdat);
  80065f:	83 c4 08             	add    $0x8,%esp
  800662:	53                   	push   %ebx
  800663:	6a 78                	push   $0x78
  800665:	ff d6                	call   *%esi
			num = (unsigned long long)
  800667:	8b 45 14             	mov    0x14(%ebp),%eax
  80066a:	8b 10                	mov    (%eax),%edx
  80066c:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800671:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800674:	8d 40 04             	lea    0x4(%eax),%eax
  800677:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80067a:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80067f:	83 ec 0c             	sub    $0xc,%esp
  800682:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800686:	57                   	push   %edi
  800687:	ff 75 e0             	pushl  -0x20(%ebp)
  80068a:	50                   	push   %eax
  80068b:	51                   	push   %ecx
  80068c:	52                   	push   %edx
  80068d:	89 da                	mov    %ebx,%edx
  80068f:	89 f0                	mov    %esi,%eax
  800691:	e8 5b fb ff ff       	call   8001f1 <printnum>
			break;
  800696:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800699:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80069c:	47                   	inc    %edi
  80069d:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006a1:	83 f8 25             	cmp    $0x25,%eax
  8006a4:	0f 84 44 fc ff ff    	je     8002ee <vprintfmt+0x17>
			if (ch == '\0')
  8006aa:	85 c0                	test   %eax,%eax
  8006ac:	0f 84 89 00 00 00    	je     80073b <vprintfmt+0x464>
			putch(ch, putdat);
  8006b2:	83 ec 08             	sub    $0x8,%esp
  8006b5:	53                   	push   %ebx
  8006b6:	50                   	push   %eax
  8006b7:	ff d6                	call   *%esi
  8006b9:	83 c4 10             	add    $0x10,%esp
  8006bc:	eb de                	jmp    80069c <vprintfmt+0x3c5>
	if (lflag >= 2)
  8006be:	83 f9 01             	cmp    $0x1,%ecx
  8006c1:	7f 1b                	jg     8006de <vprintfmt+0x407>
	else if (lflag)
  8006c3:	85 c9                	test   %ecx,%ecx
  8006c5:	75 2c                	jne    8006f3 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ca:	8b 10                	mov    (%eax),%edx
  8006cc:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006d1:	8d 40 04             	lea    0x4(%eax),%eax
  8006d4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006d7:	b8 10 00 00 00       	mov    $0x10,%eax
  8006dc:	eb a1                	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006de:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e1:	8b 10                	mov    (%eax),%edx
  8006e3:	8b 48 04             	mov    0x4(%eax),%ecx
  8006e6:	8d 40 08             	lea    0x8(%eax),%eax
  8006e9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006ec:	b8 10 00 00 00       	mov    $0x10,%eax
  8006f1:	eb 8c                	jmp    80067f <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8006f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f6:	8b 10                	mov    (%eax),%edx
  8006f8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006fd:	8d 40 04             	lea    0x4(%eax),%eax
  800700:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800703:	b8 10 00 00 00       	mov    $0x10,%eax
  800708:	e9 72 ff ff ff       	jmp    80067f <vprintfmt+0x3a8>
			putch(ch, putdat);
  80070d:	83 ec 08             	sub    $0x8,%esp
  800710:	53                   	push   %ebx
  800711:	6a 25                	push   $0x25
  800713:	ff d6                	call   *%esi
			break;
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	e9 7c ff ff ff       	jmp    800699 <vprintfmt+0x3c2>
			putch('%', putdat);
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	53                   	push   %ebx
  800721:	6a 25                	push   $0x25
  800723:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800725:	83 c4 10             	add    $0x10,%esp
  800728:	89 f8                	mov    %edi,%eax
  80072a:	eb 01                	jmp    80072d <vprintfmt+0x456>
  80072c:	48                   	dec    %eax
  80072d:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800731:	75 f9                	jne    80072c <vprintfmt+0x455>
  800733:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800736:	e9 5e ff ff ff       	jmp    800699 <vprintfmt+0x3c2>
}
  80073b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80073e:	5b                   	pop    %ebx
  80073f:	5e                   	pop    %esi
  800740:	5f                   	pop    %edi
  800741:	5d                   	pop    %ebp
  800742:	c3                   	ret    

00800743 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800743:	55                   	push   %ebp
  800744:	89 e5                	mov    %esp,%ebp
  800746:	83 ec 18             	sub    $0x18,%esp
  800749:	8b 45 08             	mov    0x8(%ebp),%eax
  80074c:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80074f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800752:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800756:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800759:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800760:	85 c0                	test   %eax,%eax
  800762:	74 26                	je     80078a <vsnprintf+0x47>
  800764:	85 d2                	test   %edx,%edx
  800766:	7e 29                	jle    800791 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800768:	ff 75 14             	pushl  0x14(%ebp)
  80076b:	ff 75 10             	pushl  0x10(%ebp)
  80076e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800771:	50                   	push   %eax
  800772:	68 9e 02 80 00       	push   $0x80029e
  800777:	e8 5b fb ff ff       	call   8002d7 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80077c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80077f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800785:	83 c4 10             	add    $0x10,%esp
}
  800788:	c9                   	leave  
  800789:	c3                   	ret    
		return -E_INVAL;
  80078a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80078f:	eb f7                	jmp    800788 <vsnprintf+0x45>
  800791:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800796:	eb f0                	jmp    800788 <vsnprintf+0x45>

00800798 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80079e:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007a1:	50                   	push   %eax
  8007a2:	ff 75 10             	pushl  0x10(%ebp)
  8007a5:	ff 75 0c             	pushl  0xc(%ebp)
  8007a8:	ff 75 08             	pushl  0x8(%ebp)
  8007ab:	e8 93 ff ff ff       	call   800743 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007b0:	c9                   	leave  
  8007b1:	c3                   	ret    

008007b2 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007b2:	55                   	push   %ebp
  8007b3:	89 e5                	mov    %esp,%ebp
  8007b5:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8007bd:	eb 01                	jmp    8007c0 <strlen+0xe>
		n++;
  8007bf:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8007c0:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007c4:	75 f9                	jne    8007bf <strlen+0xd>
	return n;
}
  8007c6:	5d                   	pop    %ebp
  8007c7:	c3                   	ret    

008007c8 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007c8:	55                   	push   %ebp
  8007c9:	89 e5                	mov    %esp,%ebp
  8007cb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ce:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8007d6:	eb 01                	jmp    8007d9 <strnlen+0x11>
		n++;
  8007d8:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007d9:	39 d0                	cmp    %edx,%eax
  8007db:	74 06                	je     8007e3 <strnlen+0x1b>
  8007dd:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  8007e1:	75 f5                	jne    8007d8 <strnlen+0x10>
	return n;
}
  8007e3:	5d                   	pop    %ebp
  8007e4:	c3                   	ret    

008007e5 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	53                   	push   %ebx
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8007ef:	89 c2                	mov    %eax,%edx
  8007f1:	42                   	inc    %edx
  8007f2:	41                   	inc    %ecx
  8007f3:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8007f6:	88 5a ff             	mov    %bl,-0x1(%edx)
  8007f9:	84 db                	test   %bl,%bl
  8007fb:	75 f4                	jne    8007f1 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8007fd:	5b                   	pop    %ebx
  8007fe:	5d                   	pop    %ebp
  8007ff:	c3                   	ret    

00800800 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	53                   	push   %ebx
  800804:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800807:	53                   	push   %ebx
  800808:	e8 a5 ff ff ff       	call   8007b2 <strlen>
  80080d:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800810:	ff 75 0c             	pushl  0xc(%ebp)
  800813:	01 d8                	add    %ebx,%eax
  800815:	50                   	push   %eax
  800816:	e8 ca ff ff ff       	call   8007e5 <strcpy>
	return dst;
}
  80081b:	89 d8                	mov    %ebx,%eax
  80081d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800820:	c9                   	leave  
  800821:	c3                   	ret    

00800822 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800822:	55                   	push   %ebp
  800823:	89 e5                	mov    %esp,%ebp
  800825:	56                   	push   %esi
  800826:	53                   	push   %ebx
  800827:	8b 75 08             	mov    0x8(%ebp),%esi
  80082a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80082d:	89 f3                	mov    %esi,%ebx
  80082f:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800832:	89 f2                	mov    %esi,%edx
  800834:	eb 0c                	jmp    800842 <strncpy+0x20>
		*dst++ = *src;
  800836:	42                   	inc    %edx
  800837:	8a 01                	mov    (%ecx),%al
  800839:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80083c:	80 39 01             	cmpb   $0x1,(%ecx)
  80083f:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800842:	39 da                	cmp    %ebx,%edx
  800844:	75 f0                	jne    800836 <strncpy+0x14>
	}
	return ret;
}
  800846:	89 f0                	mov    %esi,%eax
  800848:	5b                   	pop    %ebx
  800849:	5e                   	pop    %esi
  80084a:	5d                   	pop    %ebp
  80084b:	c3                   	ret    

0080084c <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80084c:	55                   	push   %ebp
  80084d:	89 e5                	mov    %esp,%ebp
  80084f:	56                   	push   %esi
  800850:	53                   	push   %ebx
  800851:	8b 75 08             	mov    0x8(%ebp),%esi
  800854:	8b 55 0c             	mov    0xc(%ebp),%edx
  800857:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80085a:	85 c0                	test   %eax,%eax
  80085c:	74 20                	je     80087e <strlcpy+0x32>
  80085e:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800862:	89 f0                	mov    %esi,%eax
  800864:	eb 05                	jmp    80086b <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800866:	40                   	inc    %eax
  800867:	42                   	inc    %edx
  800868:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80086b:	39 d8                	cmp    %ebx,%eax
  80086d:	74 06                	je     800875 <strlcpy+0x29>
  80086f:	8a 0a                	mov    (%edx),%cl
  800871:	84 c9                	test   %cl,%cl
  800873:	75 f1                	jne    800866 <strlcpy+0x1a>
		*dst = '\0';
  800875:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800878:	29 f0                	sub    %esi,%eax
}
  80087a:	5b                   	pop    %ebx
  80087b:	5e                   	pop    %esi
  80087c:	5d                   	pop    %ebp
  80087d:	c3                   	ret    
  80087e:	89 f0                	mov    %esi,%eax
  800880:	eb f6                	jmp    800878 <strlcpy+0x2c>

00800882 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800882:	55                   	push   %ebp
  800883:	89 e5                	mov    %esp,%ebp
  800885:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800888:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  80088b:	eb 02                	jmp    80088f <strcmp+0xd>
		p++, q++;
  80088d:	41                   	inc    %ecx
  80088e:	42                   	inc    %edx
	while (*p && *p == *q)
  80088f:	8a 01                	mov    (%ecx),%al
  800891:	84 c0                	test   %al,%al
  800893:	74 04                	je     800899 <strcmp+0x17>
  800895:	3a 02                	cmp    (%edx),%al
  800897:	74 f4                	je     80088d <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800899:	0f b6 c0             	movzbl %al,%eax
  80089c:	0f b6 12             	movzbl (%edx),%edx
  80089f:	29 d0                	sub    %edx,%eax
}
  8008a1:	5d                   	pop    %ebp
  8008a2:	c3                   	ret    

008008a3 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	53                   	push   %ebx
  8008a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ad:	89 c3                	mov    %eax,%ebx
  8008af:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008b2:	eb 02                	jmp    8008b6 <strncmp+0x13>
		n--, p++, q++;
  8008b4:	40                   	inc    %eax
  8008b5:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8008b6:	39 d8                	cmp    %ebx,%eax
  8008b8:	74 15                	je     8008cf <strncmp+0x2c>
  8008ba:	8a 08                	mov    (%eax),%cl
  8008bc:	84 c9                	test   %cl,%cl
  8008be:	74 04                	je     8008c4 <strncmp+0x21>
  8008c0:	3a 0a                	cmp    (%edx),%cl
  8008c2:	74 f0                	je     8008b4 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008c4:	0f b6 00             	movzbl (%eax),%eax
  8008c7:	0f b6 12             	movzbl (%edx),%edx
  8008ca:	29 d0                	sub    %edx,%eax
}
  8008cc:	5b                   	pop    %ebx
  8008cd:	5d                   	pop    %ebp
  8008ce:	c3                   	ret    
		return 0;
  8008cf:	b8 00 00 00 00       	mov    $0x0,%eax
  8008d4:	eb f6                	jmp    8008cc <strncmp+0x29>

008008d6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008d6:	55                   	push   %ebp
  8008d7:	89 e5                	mov    %esp,%ebp
  8008d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dc:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008df:	8a 10                	mov    (%eax),%dl
  8008e1:	84 d2                	test   %dl,%dl
  8008e3:	74 07                	je     8008ec <strchr+0x16>
		if (*s == c)
  8008e5:	38 ca                	cmp    %cl,%dl
  8008e7:	74 08                	je     8008f1 <strchr+0x1b>
	for (; *s; s++)
  8008e9:	40                   	inc    %eax
  8008ea:	eb f3                	jmp    8008df <strchr+0x9>
			return (char *) s;
	return 0;
  8008ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8008f1:	5d                   	pop    %ebp
  8008f2:	c3                   	ret    

008008f3 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8008f3:	55                   	push   %ebp
  8008f4:	89 e5                	mov    %esp,%ebp
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8008fc:	8a 10                	mov    (%eax),%dl
  8008fe:	84 d2                	test   %dl,%dl
  800900:	74 07                	je     800909 <strfind+0x16>
		if (*s == c)
  800902:	38 ca                	cmp    %cl,%dl
  800904:	74 03                	je     800909 <strfind+0x16>
	for (; *s; s++)
  800906:	40                   	inc    %eax
  800907:	eb f3                	jmp    8008fc <strfind+0x9>
			break;
	return (char *) s;
}
  800909:	5d                   	pop    %ebp
  80090a:	c3                   	ret    

0080090b <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	57                   	push   %edi
  80090f:	56                   	push   %esi
  800910:	53                   	push   %ebx
  800911:	8b 7d 08             	mov    0x8(%ebp),%edi
  800914:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800917:	85 c9                	test   %ecx,%ecx
  800919:	74 13                	je     80092e <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80091b:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800921:	75 05                	jne    800928 <memset+0x1d>
  800923:	f6 c1 03             	test   $0x3,%cl
  800926:	74 0d                	je     800935 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800928:	8b 45 0c             	mov    0xc(%ebp),%eax
  80092b:	fc                   	cld    
  80092c:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80092e:	89 f8                	mov    %edi,%eax
  800930:	5b                   	pop    %ebx
  800931:	5e                   	pop    %esi
  800932:	5f                   	pop    %edi
  800933:	5d                   	pop    %ebp
  800934:	c3                   	ret    
		c &= 0xFF;
  800935:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800939:	89 d3                	mov    %edx,%ebx
  80093b:	c1 e3 08             	shl    $0x8,%ebx
  80093e:	89 d0                	mov    %edx,%eax
  800940:	c1 e0 18             	shl    $0x18,%eax
  800943:	89 d6                	mov    %edx,%esi
  800945:	c1 e6 10             	shl    $0x10,%esi
  800948:	09 f0                	or     %esi,%eax
  80094a:	09 c2                	or     %eax,%edx
  80094c:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80094e:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800951:	89 d0                	mov    %edx,%eax
  800953:	fc                   	cld    
  800954:	f3 ab                	rep stos %eax,%es:(%edi)
  800956:	eb d6                	jmp    80092e <memset+0x23>

00800958 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800958:	55                   	push   %ebp
  800959:	89 e5                	mov    %esp,%ebp
  80095b:	57                   	push   %edi
  80095c:	56                   	push   %esi
  80095d:	8b 45 08             	mov    0x8(%ebp),%eax
  800960:	8b 75 0c             	mov    0xc(%ebp),%esi
  800963:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800966:	39 c6                	cmp    %eax,%esi
  800968:	73 33                	jae    80099d <memmove+0x45>
  80096a:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80096d:	39 d0                	cmp    %edx,%eax
  80096f:	73 2c                	jae    80099d <memmove+0x45>
		s += n;
		d += n;
  800971:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800974:	89 d6                	mov    %edx,%esi
  800976:	09 fe                	or     %edi,%esi
  800978:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80097e:	75 13                	jne    800993 <memmove+0x3b>
  800980:	f6 c1 03             	test   $0x3,%cl
  800983:	75 0e                	jne    800993 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800985:	83 ef 04             	sub    $0x4,%edi
  800988:	8d 72 fc             	lea    -0x4(%edx),%esi
  80098b:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  80098e:	fd                   	std    
  80098f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800991:	eb 07                	jmp    80099a <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800993:	4f                   	dec    %edi
  800994:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800997:	fd                   	std    
  800998:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  80099a:	fc                   	cld    
  80099b:	eb 13                	jmp    8009b0 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80099d:	89 f2                	mov    %esi,%edx
  80099f:	09 c2                	or     %eax,%edx
  8009a1:	f6 c2 03             	test   $0x3,%dl
  8009a4:	75 05                	jne    8009ab <memmove+0x53>
  8009a6:	f6 c1 03             	test   $0x3,%cl
  8009a9:	74 09                	je     8009b4 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009ab:	89 c7                	mov    %eax,%edi
  8009ad:	fc                   	cld    
  8009ae:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009b0:	5e                   	pop    %esi
  8009b1:	5f                   	pop    %edi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009b4:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009b7:	89 c7                	mov    %eax,%edi
  8009b9:	fc                   	cld    
  8009ba:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009bc:	eb f2                	jmp    8009b0 <memmove+0x58>

008009be <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009c1:	ff 75 10             	pushl  0x10(%ebp)
  8009c4:	ff 75 0c             	pushl  0xc(%ebp)
  8009c7:	ff 75 08             	pushl  0x8(%ebp)
  8009ca:	e8 89 ff ff ff       	call   800958 <memmove>
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	56                   	push   %esi
  8009d5:	53                   	push   %ebx
  8009d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d9:	89 c6                	mov    %eax,%esi
  8009db:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009de:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  8009e1:	39 f0                	cmp    %esi,%eax
  8009e3:	74 16                	je     8009fb <memcmp+0x2a>
		if (*s1 != *s2)
  8009e5:	8a 08                	mov    (%eax),%cl
  8009e7:	8a 1a                	mov    (%edx),%bl
  8009e9:	38 d9                	cmp    %bl,%cl
  8009eb:	75 04                	jne    8009f1 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8009ed:	40                   	inc    %eax
  8009ee:	42                   	inc    %edx
  8009ef:	eb f0                	jmp    8009e1 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8009f1:	0f b6 c1             	movzbl %cl,%eax
  8009f4:	0f b6 db             	movzbl %bl,%ebx
  8009f7:	29 d8                	sub    %ebx,%eax
  8009f9:	eb 05                	jmp    800a00 <memcmp+0x2f>
	}

	return 0;
  8009fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a00:	5b                   	pop    %ebx
  800a01:	5e                   	pop    %esi
  800a02:	5d                   	pop    %ebp
  800a03:	c3                   	ret    

00800a04 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a04:	55                   	push   %ebp
  800a05:	89 e5                	mov    %esp,%ebp
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a0d:	89 c2                	mov    %eax,%edx
  800a0f:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a12:	39 d0                	cmp    %edx,%eax
  800a14:	73 07                	jae    800a1d <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a16:	38 08                	cmp    %cl,(%eax)
  800a18:	74 03                	je     800a1d <memfind+0x19>
	for (; s < ends; s++)
  800a1a:	40                   	inc    %eax
  800a1b:	eb f5                	jmp    800a12 <memfind+0xe>
			break;
	return (void *) s;
}
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	57                   	push   %edi
  800a23:	56                   	push   %esi
  800a24:	53                   	push   %ebx
  800a25:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a28:	eb 01                	jmp    800a2b <strtol+0xc>
		s++;
  800a2a:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a2b:	8a 01                	mov    (%ecx),%al
  800a2d:	3c 20                	cmp    $0x20,%al
  800a2f:	74 f9                	je     800a2a <strtol+0xb>
  800a31:	3c 09                	cmp    $0x9,%al
  800a33:	74 f5                	je     800a2a <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a35:	3c 2b                	cmp    $0x2b,%al
  800a37:	74 2b                	je     800a64 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a39:	3c 2d                	cmp    $0x2d,%al
  800a3b:	74 2f                	je     800a6c <strtol+0x4d>
	int neg = 0;
  800a3d:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a42:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a49:	75 12                	jne    800a5d <strtol+0x3e>
  800a4b:	80 39 30             	cmpb   $0x30,(%ecx)
  800a4e:	74 24                	je     800a74 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a54:	75 07                	jne    800a5d <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a56:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a5d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a62:	eb 4e                	jmp    800ab2 <strtol+0x93>
		s++;
  800a64:	41                   	inc    %ecx
	int neg = 0;
  800a65:	bf 00 00 00 00       	mov    $0x0,%edi
  800a6a:	eb d6                	jmp    800a42 <strtol+0x23>
		s++, neg = 1;
  800a6c:	41                   	inc    %ecx
  800a6d:	bf 01 00 00 00       	mov    $0x1,%edi
  800a72:	eb ce                	jmp    800a42 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a74:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a78:	74 10                	je     800a8a <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a7a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a7e:	75 dd                	jne    800a5d <strtol+0x3e>
		s++, base = 8;
  800a80:	41                   	inc    %ecx
  800a81:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800a88:	eb d3                	jmp    800a5d <strtol+0x3e>
		s += 2, base = 16;
  800a8a:	83 c1 02             	add    $0x2,%ecx
  800a8d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800a94:	eb c7                	jmp    800a5d <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800a96:	8d 72 9f             	lea    -0x61(%edx),%esi
  800a99:	89 f3                	mov    %esi,%ebx
  800a9b:	80 fb 19             	cmp    $0x19,%bl
  800a9e:	77 24                	ja     800ac4 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800aa0:	0f be d2             	movsbl %dl,%edx
  800aa3:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800aa6:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aa9:	7d 2b                	jge    800ad6 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800aab:	41                   	inc    %ecx
  800aac:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ab0:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ab2:	8a 11                	mov    (%ecx),%dl
  800ab4:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ab7:	80 fb 09             	cmp    $0x9,%bl
  800aba:	77 da                	ja     800a96 <strtol+0x77>
			dig = *s - '0';
  800abc:	0f be d2             	movsbl %dl,%edx
  800abf:	83 ea 30             	sub    $0x30,%edx
  800ac2:	eb e2                	jmp    800aa6 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800ac4:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ac7:	89 f3                	mov    %esi,%ebx
  800ac9:	80 fb 19             	cmp    $0x19,%bl
  800acc:	77 08                	ja     800ad6 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800ace:	0f be d2             	movsbl %dl,%edx
  800ad1:	83 ea 37             	sub    $0x37,%edx
  800ad4:	eb d0                	jmp    800aa6 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800ad6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ada:	74 05                	je     800ae1 <strtol+0xc2>
		*endptr = (char *) s;
  800adc:	8b 75 0c             	mov    0xc(%ebp),%esi
  800adf:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800ae1:	85 ff                	test   %edi,%edi
  800ae3:	74 02                	je     800ae7 <strtol+0xc8>
  800ae5:	f7 d8                	neg    %eax
}
  800ae7:	5b                   	pop    %ebx
  800ae8:	5e                   	pop    %esi
  800ae9:	5f                   	pop    %edi
  800aea:	5d                   	pop    %ebp
  800aeb:	c3                   	ret    

00800aec <atoi>:

int
atoi(const char *s)
{
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800aef:	6a 0a                	push   $0xa
  800af1:	6a 00                	push   $0x0
  800af3:	ff 75 08             	pushl  0x8(%ebp)
  800af6:	e8 24 ff ff ff       	call   800a1f <strtol>
}
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
  800b00:	57                   	push   %edi
  800b01:	56                   	push   %esi
  800b02:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b03:	b8 00 00 00 00       	mov    $0x0,%eax
  800b08:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0e:	89 c3                	mov    %eax,%ebx
  800b10:	89 c7                	mov    %eax,%edi
  800b12:	89 c6                	mov    %eax,%esi
  800b14:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b16:	5b                   	pop    %ebx
  800b17:	5e                   	pop    %esi
  800b18:	5f                   	pop    %edi
  800b19:	5d                   	pop    %ebp
  800b1a:	c3                   	ret    

00800b1b <sys_cgetc>:

int
sys_cgetc(void)
{
  800b1b:	55                   	push   %ebp
  800b1c:	89 e5                	mov    %esp,%ebp
  800b1e:	57                   	push   %edi
  800b1f:	56                   	push   %esi
  800b20:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b21:	ba 00 00 00 00       	mov    $0x0,%edx
  800b26:	b8 01 00 00 00       	mov    $0x1,%eax
  800b2b:	89 d1                	mov    %edx,%ecx
  800b2d:	89 d3                	mov    %edx,%ebx
  800b2f:	89 d7                	mov    %edx,%edi
  800b31:	89 d6                	mov    %edx,%esi
  800b33:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
  800b3d:	57                   	push   %edi
  800b3e:	56                   	push   %esi
  800b3f:	53                   	push   %ebx
  800b40:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b43:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b48:	b8 03 00 00 00       	mov    $0x3,%eax
  800b4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b50:	89 cb                	mov    %ecx,%ebx
  800b52:	89 cf                	mov    %ecx,%edi
  800b54:	89 ce                	mov    %ecx,%esi
  800b56:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b58:	85 c0                	test   %eax,%eax
  800b5a:	7f 08                	jg     800b64 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800b5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5f                   	pop    %edi
  800b62:	5d                   	pop    %ebp
  800b63:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800b64:	83 ec 0c             	sub    $0xc,%esp
  800b67:	50                   	push   %eax
  800b68:	6a 03                	push   $0x3
  800b6a:	68 9f 25 80 00       	push   $0x80259f
  800b6f:	6a 23                	push   $0x23
  800b71:	68 bc 25 80 00       	push   $0x8025bc
  800b76:	e8 64 12 00 00       	call   801ddf <_panic>

00800b7b <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	57                   	push   %edi
  800b7f:	56                   	push   %esi
  800b80:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b81:	ba 00 00 00 00       	mov    $0x0,%edx
  800b86:	b8 02 00 00 00       	mov    $0x2,%eax
  800b8b:	89 d1                	mov    %edx,%ecx
  800b8d:	89 d3                	mov    %edx,%ebx
  800b8f:	89 d7                	mov    %edx,%edi
  800b91:	89 d6                	mov    %edx,%esi
  800b93:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5f                   	pop    %edi
  800b98:	5d                   	pop    %ebp
  800b99:	c3                   	ret    

00800b9a <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	57                   	push   %edi
  800b9e:	56                   	push   %esi
  800b9f:	53                   	push   %ebx
  800ba0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ba3:	be 00 00 00 00       	mov    $0x0,%esi
  800ba8:	b8 04 00 00 00       	mov    $0x4,%eax
  800bad:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800bb3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bb6:	89 f7                	mov    %esi,%edi
  800bb8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bba:	85 c0                	test   %eax,%eax
  800bbc:	7f 08                	jg     800bc6 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bc1:	5b                   	pop    %ebx
  800bc2:	5e                   	pop    %esi
  800bc3:	5f                   	pop    %edi
  800bc4:	5d                   	pop    %ebp
  800bc5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bc6:	83 ec 0c             	sub    $0xc,%esp
  800bc9:	50                   	push   %eax
  800bca:	6a 04                	push   $0x4
  800bcc:	68 9f 25 80 00       	push   $0x80259f
  800bd1:	6a 23                	push   $0x23
  800bd3:	68 bc 25 80 00       	push   $0x8025bc
  800bd8:	e8 02 12 00 00       	call   801ddf <_panic>

00800bdd <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bdd:	55                   	push   %ebp
  800bde:	89 e5                	mov    %esp,%ebp
  800be0:	57                   	push   %edi
  800be1:	56                   	push   %esi
  800be2:	53                   	push   %ebx
  800be3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800be6:	b8 05 00 00 00       	mov    $0x5,%eax
  800beb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bee:	8b 55 08             	mov    0x8(%ebp),%edx
  800bf1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bf4:	8b 7d 14             	mov    0x14(%ebp),%edi
  800bf7:	8b 75 18             	mov    0x18(%ebp),%esi
  800bfa:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bfc:	85 c0                	test   %eax,%eax
  800bfe:	7f 08                	jg     800c08 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c03:	5b                   	pop    %ebx
  800c04:	5e                   	pop    %esi
  800c05:	5f                   	pop    %edi
  800c06:	5d                   	pop    %ebp
  800c07:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c08:	83 ec 0c             	sub    $0xc,%esp
  800c0b:	50                   	push   %eax
  800c0c:	6a 05                	push   $0x5
  800c0e:	68 9f 25 80 00       	push   $0x80259f
  800c13:	6a 23                	push   $0x23
  800c15:	68 bc 25 80 00       	push   $0x8025bc
  800c1a:	e8 c0 11 00 00       	call   801ddf <_panic>

00800c1f <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	57                   	push   %edi
  800c23:	56                   	push   %esi
  800c24:	53                   	push   %ebx
  800c25:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c28:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c2d:	b8 06 00 00 00       	mov    $0x6,%eax
  800c32:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c35:	8b 55 08             	mov    0x8(%ebp),%edx
  800c38:	89 df                	mov    %ebx,%edi
  800c3a:	89 de                	mov    %ebx,%esi
  800c3c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c3e:	85 c0                	test   %eax,%eax
  800c40:	7f 08                	jg     800c4a <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c42:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c45:	5b                   	pop    %ebx
  800c46:	5e                   	pop    %esi
  800c47:	5f                   	pop    %edi
  800c48:	5d                   	pop    %ebp
  800c49:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c4a:	83 ec 0c             	sub    $0xc,%esp
  800c4d:	50                   	push   %eax
  800c4e:	6a 06                	push   $0x6
  800c50:	68 9f 25 80 00       	push   $0x80259f
  800c55:	6a 23                	push   $0x23
  800c57:	68 bc 25 80 00       	push   $0x8025bc
  800c5c:	e8 7e 11 00 00       	call   801ddf <_panic>

00800c61 <sys_yield>:

void
sys_yield(void)
{
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	57                   	push   %edi
  800c65:	56                   	push   %esi
  800c66:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c67:	ba 00 00 00 00       	mov    $0x0,%edx
  800c6c:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c71:	89 d1                	mov    %edx,%ecx
  800c73:	89 d3                	mov    %edx,%ebx
  800c75:	89 d7                	mov    %edx,%edi
  800c77:	89 d6                	mov    %edx,%esi
  800c79:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c7b:	5b                   	pop    %ebx
  800c7c:	5e                   	pop    %esi
  800c7d:	5f                   	pop    %edi
  800c7e:	5d                   	pop    %ebp
  800c7f:	c3                   	ret    

00800c80 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800c80:	55                   	push   %ebp
  800c81:	89 e5                	mov    %esp,%ebp
  800c83:	57                   	push   %edi
  800c84:	56                   	push   %esi
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c89:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c8e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	89 df                	mov    %ebx,%edi
  800c9b:	89 de                	mov    %ebx,%esi
  800c9d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c9f:	85 c0                	test   %eax,%eax
  800ca1:	7f 08                	jg     800cab <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
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
  800caf:	6a 08                	push   $0x8
  800cb1:	68 9f 25 80 00       	push   $0x80259f
  800cb6:	6a 23                	push   $0x23
  800cb8:	68 bc 25 80 00       	push   $0x8025bc
  800cbd:	e8 1d 11 00 00       	call   801ddf <_panic>

00800cc2 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	57                   	push   %edi
  800cc6:	56                   	push   %esi
  800cc7:	53                   	push   %ebx
  800cc8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ccb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd0:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cd8:	89 cb                	mov    %ecx,%ebx
  800cda:	89 cf                	mov    %ecx,%edi
  800cdc:	89 ce                	mov    %ecx,%esi
  800cde:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ce0:	85 c0                	test   %eax,%eax
  800ce2:	7f 08                	jg     800cec <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ce7:	5b                   	pop    %ebx
  800ce8:	5e                   	pop    %esi
  800ce9:	5f                   	pop    %edi
  800cea:	5d                   	pop    %ebp
  800ceb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cec:	83 ec 0c             	sub    $0xc,%esp
  800cef:	50                   	push   %eax
  800cf0:	6a 0c                	push   $0xc
  800cf2:	68 9f 25 80 00       	push   $0x80259f
  800cf7:	6a 23                	push   $0x23
  800cf9:	68 bc 25 80 00       	push   $0x8025bc
  800cfe:	e8 dc 10 00 00       	call   801ddf <_panic>

00800d03 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d03:	55                   	push   %ebp
  800d04:	89 e5                	mov    %esp,%ebp
  800d06:	57                   	push   %edi
  800d07:	56                   	push   %esi
  800d08:	53                   	push   %ebx
  800d09:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d11:	b8 09 00 00 00       	mov    $0x9,%eax
  800d16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d19:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1c:	89 df                	mov    %ebx,%edi
  800d1e:	89 de                	mov    %ebx,%esi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d26:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d29:	5b                   	pop    %ebx
  800d2a:	5e                   	pop    %esi
  800d2b:	5f                   	pop    %edi
  800d2c:	5d                   	pop    %ebp
  800d2d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d2e:	83 ec 0c             	sub    $0xc,%esp
  800d31:	50                   	push   %eax
  800d32:	6a 09                	push   $0x9
  800d34:	68 9f 25 80 00       	push   $0x80259f
  800d39:	6a 23                	push   $0x23
  800d3b:	68 bc 25 80 00       	push   $0x8025bc
  800d40:	e8 9a 10 00 00       	call   801ddf <_panic>

00800d45 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d53:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5e:	89 df                	mov    %ebx,%edi
  800d60:	89 de                	mov    %ebx,%esi
  800d62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d68:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6b:	5b                   	pop    %ebx
  800d6c:	5e                   	pop    %esi
  800d6d:	5f                   	pop    %edi
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d70:	83 ec 0c             	sub    $0xc,%esp
  800d73:	50                   	push   %eax
  800d74:	6a 0a                	push   $0xa
  800d76:	68 9f 25 80 00       	push   $0x80259f
  800d7b:	6a 23                	push   $0x23
  800d7d:	68 bc 25 80 00       	push   $0x8025bc
  800d82:	e8 58 10 00 00       	call   801ddf <_panic>

00800d87 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d8d:	be 00 00 00 00       	mov    $0x0,%esi
  800d92:	b8 0d 00 00 00       	mov    $0xd,%eax
  800d97:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da0:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da3:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800da5:	5b                   	pop    %ebx
  800da6:	5e                   	pop    %esi
  800da7:	5f                   	pop    %edi
  800da8:	5d                   	pop    %ebp
  800da9:	c3                   	ret    

00800daa <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800daa:	55                   	push   %ebp
  800dab:	89 e5                	mov    %esp,%ebp
  800dad:	57                   	push   %edi
  800dae:	56                   	push   %esi
  800daf:	53                   	push   %ebx
  800db0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800db3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800db8:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dbd:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc0:	89 cb                	mov    %ecx,%ebx
  800dc2:	89 cf                	mov    %ecx,%edi
  800dc4:	89 ce                	mov    %ecx,%esi
  800dc6:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dc8:	85 c0                	test   %eax,%eax
  800dca:	7f 08                	jg     800dd4 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800dcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dcf:	5b                   	pop    %ebx
  800dd0:	5e                   	pop    %esi
  800dd1:	5f                   	pop    %edi
  800dd2:	5d                   	pop    %ebp
  800dd3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dd4:	83 ec 0c             	sub    $0xc,%esp
  800dd7:	50                   	push   %eax
  800dd8:	6a 0e                	push   $0xe
  800dda:	68 9f 25 80 00       	push   $0x80259f
  800ddf:	6a 23                	push   $0x23
  800de1:	68 bc 25 80 00       	push   $0x8025bc
  800de6:	e8 f4 0f 00 00       	call   801ddf <_panic>

00800deb <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	57                   	push   %edi
  800def:	56                   	push   %esi
  800df0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800df1:	be 00 00 00 00       	mov    $0x0,%esi
  800df6:	b8 0f 00 00 00       	mov    $0xf,%eax
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e04:	89 f7                	mov    %esi,%edi
  800e06:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e08:	5b                   	pop    %ebx
  800e09:	5e                   	pop    %esi
  800e0a:	5f                   	pop    %edi
  800e0b:	5d                   	pop    %ebp
  800e0c:	c3                   	ret    

00800e0d <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	57                   	push   %edi
  800e11:	56                   	push   %esi
  800e12:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e13:	be 00 00 00 00       	mov    $0x0,%esi
  800e18:	b8 10 00 00 00       	mov    $0x10,%eax
  800e1d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e20:	8b 55 08             	mov    0x8(%ebp),%edx
  800e23:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e26:	89 f7                	mov    %esi,%edi
  800e28:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e2a:	5b                   	pop    %ebx
  800e2b:	5e                   	pop    %esi
  800e2c:	5f                   	pop    %edi
  800e2d:	5d                   	pop    %ebp
  800e2e:	c3                   	ret    

00800e2f <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e2f:	55                   	push   %ebp
  800e30:	89 e5                	mov    %esp,%ebp
  800e32:	57                   	push   %edi
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e3a:	b8 11 00 00 00       	mov    $0x11,%eax
  800e3f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e42:	89 cb                	mov    %ecx,%ebx
  800e44:	89 cf                	mov    %ecx,%edi
  800e46:	89 ce                	mov    %ecx,%esi
  800e48:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    

00800e4f <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800e4f:	55                   	push   %ebp
  800e50:	89 e5                	mov    %esp,%ebp
  800e52:	56                   	push   %esi
  800e53:	53                   	push   %ebx
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800e57:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800e59:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800e5d:	0f 84 84 00 00 00    	je     800ee7 <pgfault+0x98>
  800e63:	89 d8                	mov    %ebx,%eax
  800e65:	c1 e8 16             	shr    $0x16,%eax
  800e68:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800e6f:	a8 01                	test   $0x1,%al
  800e71:	74 74                	je     800ee7 <pgfault+0x98>
  800e73:	89 d8                	mov    %ebx,%eax
  800e75:	c1 e8 0c             	shr    $0xc,%eax
  800e78:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800e7f:	f6 c4 08             	test   $0x8,%ah
  800e82:	74 63                	je     800ee7 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800e84:	e8 f2 fc ff ff       	call   800b7b <sys_getenvid>
  800e89:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	6a 07                	push   $0x7
  800e90:	68 00 f0 7f 00       	push   $0x7ff000
  800e95:	50                   	push   %eax
  800e96:	e8 ff fc ff ff       	call   800b9a <sys_page_alloc>
  800e9b:	83 c4 10             	add    $0x10,%esp
  800e9e:	85 c0                	test   %eax,%eax
  800ea0:	78 5b                	js     800efd <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  800ea2:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  800ea8:	83 ec 04             	sub    $0x4,%esp
  800eab:	68 00 10 00 00       	push   $0x1000
  800eb0:	53                   	push   %ebx
  800eb1:	68 00 f0 7f 00       	push   $0x7ff000
  800eb6:	e8 03 fb ff ff       	call   8009be <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  800ebb:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  800ec2:	53                   	push   %ebx
  800ec3:	56                   	push   %esi
  800ec4:	68 00 f0 7f 00       	push   $0x7ff000
  800ec9:	56                   	push   %esi
  800eca:	e8 0e fd ff ff       	call   800bdd <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  800ecf:	83 c4 18             	add    $0x18,%esp
  800ed2:	68 00 f0 7f 00       	push   $0x7ff000
  800ed7:	56                   	push   %esi
  800ed8:	e8 42 fd ff ff       	call   800c1f <sys_page_unmap>

}
  800edd:	83 c4 10             	add    $0x10,%esp
  800ee0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ee3:	5b                   	pop    %ebx
  800ee4:	5e                   	pop    %esi
  800ee5:	5d                   	pop    %ebp
  800ee6:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800ee7:	68 cc 25 80 00       	push   $0x8025cc
  800eec:	68 56 26 80 00       	push   $0x802656
  800ef1:	6a 1c                	push   $0x1c
  800ef3:	68 6b 26 80 00       	push   $0x80266b
  800ef8:	e8 e2 0e 00 00       	call   801ddf <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800efd:	68 1c 26 80 00       	push   $0x80261c
  800f02:	68 56 26 80 00       	push   $0x802656
  800f07:	6a 26                	push   $0x26
  800f09:	68 6b 26 80 00       	push   $0x80266b
  800f0e:	e8 cc 0e 00 00       	call   801ddf <_panic>

00800f13 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  800f13:	55                   	push   %ebp
  800f14:	89 e5                	mov    %esp,%ebp
  800f16:	57                   	push   %edi
  800f17:	56                   	push   %esi
  800f18:	53                   	push   %ebx
  800f19:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  800f1c:	68 4f 0e 80 00       	push   $0x800e4f
  800f21:	e8 38 0f 00 00       	call   801e5e <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  800f26:	b8 07 00 00 00       	mov    $0x7,%eax
  800f2b:	cd 30                	int    $0x30
  800f2d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f30:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  800f33:	83 c4 10             	add    $0x10,%esp
  800f36:	85 c0                	test   %eax,%eax
  800f38:	0f 88 58 01 00 00    	js     801096 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  800f3e:	85 c0                	test   %eax,%eax
  800f40:	74 07                	je     800f49 <fork+0x36>
  800f42:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f47:	eb 72                	jmp    800fbb <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  800f49:	e8 2d fc ff ff       	call   800b7b <sys_getenvid>
  800f4e:	25 ff 03 00 00       	and    $0x3ff,%eax
  800f53:	89 c2                	mov    %eax,%edx
  800f55:	c1 e2 05             	shl    $0x5,%edx
  800f58:	29 c2                	sub    %eax,%edx
  800f5a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800f61:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  800f66:	e9 20 01 00 00       	jmp    80108b <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  800f6b:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  800f72:	e8 04 fc ff ff       	call   800b7b <sys_getenvid>
  800f77:	83 ec 0c             	sub    $0xc,%esp
  800f7a:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  800f80:	57                   	push   %edi
  800f81:	56                   	push   %esi
  800f82:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f85:	56                   	push   %esi
  800f86:	50                   	push   %eax
  800f87:	e8 51 fc ff ff       	call   800bdd <sys_page_map>
  800f8c:	83 c4 20             	add    $0x20,%esp
  800f8f:	eb 18                	jmp    800fa9 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  800f91:	e8 e5 fb ff ff       	call   800b7b <sys_getenvid>
  800f96:	83 ec 0c             	sub    $0xc,%esp
  800f99:	6a 05                	push   $0x5
  800f9b:	56                   	push   %esi
  800f9c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9f:	56                   	push   %esi
  800fa0:	50                   	push   %eax
  800fa1:	e8 37 fc ff ff       	call   800bdd <sys_page_map>
  800fa6:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  800fa9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  800faf:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  800fb5:	0f 84 8f 00 00 00    	je     80104a <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  800fbb:	89 d8                	mov    %ebx,%eax
  800fbd:	c1 e8 16             	shr    $0x16,%eax
  800fc0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fc7:	a8 01                	test   $0x1,%al
  800fc9:	74 de                	je     800fa9 <fork+0x96>
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	c1 e8 0c             	shr    $0xc,%eax
  800fd0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fd7:	a8 04                	test   $0x4,%al
  800fd9:	74 ce                	je     800fa9 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  800fdb:	89 de                	mov    %ebx,%esi
  800fdd:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  800fe3:	89 f0                	mov    %esi,%eax
  800fe5:	c1 e8 0c             	shr    $0xc,%eax
  800fe8:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800fef:	f6 c6 04             	test   $0x4,%dh
  800ff2:	0f 85 73 ff ff ff    	jne    800f6b <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  800ff8:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fff:	a9 02 08 00 00       	test   $0x802,%eax
  801004:	74 8b                	je     800f91 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801006:	e8 70 fb ff ff       	call   800b7b <sys_getenvid>
  80100b:	83 ec 0c             	sub    $0xc,%esp
  80100e:	68 05 08 00 00       	push   $0x805
  801013:	56                   	push   %esi
  801014:	ff 75 e4             	pushl  -0x1c(%ebp)
  801017:	56                   	push   %esi
  801018:	50                   	push   %eax
  801019:	e8 bf fb ff ff       	call   800bdd <sys_page_map>
  80101e:	83 c4 20             	add    $0x20,%esp
  801021:	85 c0                	test   %eax,%eax
  801023:	78 84                	js     800fa9 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801025:	e8 51 fb ff ff       	call   800b7b <sys_getenvid>
  80102a:	89 c7                	mov    %eax,%edi
  80102c:	e8 4a fb ff ff       	call   800b7b <sys_getenvid>
  801031:	83 ec 0c             	sub    $0xc,%esp
  801034:	68 05 08 00 00       	push   $0x805
  801039:	56                   	push   %esi
  80103a:	57                   	push   %edi
  80103b:	56                   	push   %esi
  80103c:	50                   	push   %eax
  80103d:	e8 9b fb ff ff       	call   800bdd <sys_page_map>
  801042:	83 c4 20             	add    $0x20,%esp
  801045:	e9 5f ff ff ff       	jmp    800fa9 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  80104a:	83 ec 04             	sub    $0x4,%esp
  80104d:	6a 07                	push   $0x7
  80104f:	68 00 f0 bf ee       	push   $0xeebff000
  801054:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801057:	57                   	push   %edi
  801058:	e8 3d fb ff ff       	call   800b9a <sys_page_alloc>
  80105d:	83 c4 10             	add    $0x10,%esp
  801060:	85 c0                	test   %eax,%eax
  801062:	78 3b                	js     80109f <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801064:	83 ec 08             	sub    $0x8,%esp
  801067:	68 a4 1e 80 00       	push   $0x801ea4
  80106c:	57                   	push   %edi
  80106d:	e8 d3 fc ff ff       	call   800d45 <sys_env_set_pgfault_upcall>
  801072:	83 c4 10             	add    $0x10,%esp
  801075:	85 c0                	test   %eax,%eax
  801077:	78 2f                	js     8010a8 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801079:	83 ec 08             	sub    $0x8,%esp
  80107c:	6a 02                	push   $0x2
  80107e:	57                   	push   %edi
  80107f:	e8 fc fb ff ff       	call   800c80 <sys_env_set_status>
	if (temp < 0) {
  801084:	83 c4 10             	add    $0x10,%esp
  801087:	85 c0                	test   %eax,%eax
  801089:	78 26                	js     8010b1 <fork+0x19e>
		return -1;
	}

	return childid;
}
  80108b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80108e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5f                   	pop    %edi
  801094:	5d                   	pop    %ebp
  801095:	c3                   	ret    
		return -1;
  801096:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80109d:	eb ec                	jmp    80108b <fork+0x178>
		return -1;
  80109f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010a6:	eb e3                	jmp    80108b <fork+0x178>
		return -1;
  8010a8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010af:	eb da                	jmp    80108b <fork+0x178>
		return -1;
  8010b1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8010b8:	eb d1                	jmp    80108b <fork+0x178>

008010ba <sfork>:

// Challenge!
int
sfork(void)
{
  8010ba:	55                   	push   %ebp
  8010bb:	89 e5                	mov    %esp,%ebp
  8010bd:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8010c0:	68 76 26 80 00       	push   $0x802676
  8010c5:	68 85 00 00 00       	push   $0x85
  8010ca:	68 6b 26 80 00       	push   $0x80266b
  8010cf:	e8 0b 0d 00 00       	call   801ddf <_panic>

008010d4 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8010d4:	55                   	push   %ebp
  8010d5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	05 00 00 00 30       	add    $0x30000000,%eax
  8010df:	c1 e8 0c             	shr    $0xc,%eax
}
  8010e2:	5d                   	pop    %ebp
  8010e3:	c3                   	ret    

008010e4 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8010e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ea:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8010ef:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8010f4:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8010f9:	5d                   	pop    %ebp
  8010fa:	c3                   	ret    

008010fb <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8010fb:	55                   	push   %ebp
  8010fc:	89 e5                	mov    %esp,%ebp
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801106:	89 c2                	mov    %eax,%edx
  801108:	c1 ea 16             	shr    $0x16,%edx
  80110b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801112:	f6 c2 01             	test   $0x1,%dl
  801115:	74 2a                	je     801141 <fd_alloc+0x46>
  801117:	89 c2                	mov    %eax,%edx
  801119:	c1 ea 0c             	shr    $0xc,%edx
  80111c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801123:	f6 c2 01             	test   $0x1,%dl
  801126:	74 19                	je     801141 <fd_alloc+0x46>
  801128:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80112d:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801132:	75 d2                	jne    801106 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801134:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80113a:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80113f:	eb 07                	jmp    801148 <fd_alloc+0x4d>
			*fd_store = fd;
  801141:	89 01                	mov    %eax,(%ecx)
			return 0;
  801143:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80114d:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801151:	77 39                	ja     80118c <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	c1 e0 0c             	shl    $0xc,%eax
  801159:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80115e:	89 c2                	mov    %eax,%edx
  801160:	c1 ea 16             	shr    $0x16,%edx
  801163:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80116a:	f6 c2 01             	test   $0x1,%dl
  80116d:	74 24                	je     801193 <fd_lookup+0x49>
  80116f:	89 c2                	mov    %eax,%edx
  801171:	c1 ea 0c             	shr    $0xc,%edx
  801174:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80117b:	f6 c2 01             	test   $0x1,%dl
  80117e:	74 1a                	je     80119a <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801180:	8b 55 0c             	mov    0xc(%ebp),%edx
  801183:	89 02                	mov    %eax,(%edx)
	return 0;
  801185:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    
		return -E_INVAL;
  80118c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801191:	eb f7                	jmp    80118a <fd_lookup+0x40>
		return -E_INVAL;
  801193:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801198:	eb f0                	jmp    80118a <fd_lookup+0x40>
  80119a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80119f:	eb e9                	jmp    80118a <fd_lookup+0x40>

008011a1 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8011a1:	55                   	push   %ebp
  8011a2:	89 e5                	mov    %esp,%ebp
  8011a4:	83 ec 08             	sub    $0x8,%esp
  8011a7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011aa:	ba 08 27 80 00       	mov    $0x802708,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8011af:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8011b4:	39 08                	cmp    %ecx,(%eax)
  8011b6:	74 33                	je     8011eb <dev_lookup+0x4a>
  8011b8:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8011bb:	8b 02                	mov    (%edx),%eax
  8011bd:	85 c0                	test   %eax,%eax
  8011bf:	75 f3                	jne    8011b4 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8011c1:	a1 04 40 80 00       	mov    0x804004,%eax
  8011c6:	8b 40 48             	mov    0x48(%eax),%eax
  8011c9:	83 ec 04             	sub    $0x4,%esp
  8011cc:	51                   	push   %ecx
  8011cd:	50                   	push   %eax
  8011ce:	68 8c 26 80 00       	push   $0x80268c
  8011d3:	e8 05 f0 ff ff       	call   8001dd <cprintf>
	*dev = 0;
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8011e1:	83 c4 10             	add    $0x10,%esp
  8011e4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8011e9:	c9                   	leave  
  8011ea:	c3                   	ret    
			*dev = devtab[i];
  8011eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011ee:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011f5:	eb f2                	jmp    8011e9 <dev_lookup+0x48>

008011f7 <fd_close>:
{
  8011f7:	55                   	push   %ebp
  8011f8:	89 e5                	mov    %esp,%ebp
  8011fa:	57                   	push   %edi
  8011fb:	56                   	push   %esi
  8011fc:	53                   	push   %ebx
  8011fd:	83 ec 1c             	sub    $0x1c,%esp
  801200:	8b 75 08             	mov    0x8(%ebp),%esi
  801203:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801206:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801209:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80120a:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801210:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801213:	50                   	push   %eax
  801214:	e8 31 ff ff ff       	call   80114a <fd_lookup>
  801219:	89 c7                	mov    %eax,%edi
  80121b:	83 c4 08             	add    $0x8,%esp
  80121e:	85 c0                	test   %eax,%eax
  801220:	78 05                	js     801227 <fd_close+0x30>
	    || fd != fd2)
  801222:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801225:	74 13                	je     80123a <fd_close+0x43>
		return (must_exist ? r : 0);
  801227:	84 db                	test   %bl,%bl
  801229:	75 05                	jne    801230 <fd_close+0x39>
  80122b:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801230:	89 f8                	mov    %edi,%eax
  801232:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801235:	5b                   	pop    %ebx
  801236:	5e                   	pop    %esi
  801237:	5f                   	pop    %edi
  801238:	5d                   	pop    %ebp
  801239:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80123a:	83 ec 08             	sub    $0x8,%esp
  80123d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801240:	50                   	push   %eax
  801241:	ff 36                	pushl  (%esi)
  801243:	e8 59 ff ff ff       	call   8011a1 <dev_lookup>
  801248:	89 c7                	mov    %eax,%edi
  80124a:	83 c4 10             	add    $0x10,%esp
  80124d:	85 c0                	test   %eax,%eax
  80124f:	78 15                	js     801266 <fd_close+0x6f>
		if (dev->dev_close)
  801251:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801254:	8b 40 10             	mov    0x10(%eax),%eax
  801257:	85 c0                	test   %eax,%eax
  801259:	74 1b                	je     801276 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80125b:	83 ec 0c             	sub    $0xc,%esp
  80125e:	56                   	push   %esi
  80125f:	ff d0                	call   *%eax
  801261:	89 c7                	mov    %eax,%edi
  801263:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801266:	83 ec 08             	sub    $0x8,%esp
  801269:	56                   	push   %esi
  80126a:	6a 00                	push   $0x0
  80126c:	e8 ae f9 ff ff       	call   800c1f <sys_page_unmap>
	return r;
  801271:	83 c4 10             	add    $0x10,%esp
  801274:	eb ba                	jmp    801230 <fd_close+0x39>
			r = 0;
  801276:	bf 00 00 00 00       	mov    $0x0,%edi
  80127b:	eb e9                	jmp    801266 <fd_close+0x6f>

0080127d <close>:

int
close(int fdnum)
{
  80127d:	55                   	push   %ebp
  80127e:	89 e5                	mov    %esp,%ebp
  801280:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801283:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801286:	50                   	push   %eax
  801287:	ff 75 08             	pushl  0x8(%ebp)
  80128a:	e8 bb fe ff ff       	call   80114a <fd_lookup>
  80128f:	83 c4 08             	add    $0x8,%esp
  801292:	85 c0                	test   %eax,%eax
  801294:	78 10                	js     8012a6 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801296:	83 ec 08             	sub    $0x8,%esp
  801299:	6a 01                	push   $0x1
  80129b:	ff 75 f4             	pushl  -0xc(%ebp)
  80129e:	e8 54 ff ff ff       	call   8011f7 <fd_close>
  8012a3:	83 c4 10             	add    $0x10,%esp
}
  8012a6:	c9                   	leave  
  8012a7:	c3                   	ret    

008012a8 <close_all>:

void
close_all(void)
{
  8012a8:	55                   	push   %ebp
  8012a9:	89 e5                	mov    %esp,%ebp
  8012ab:	53                   	push   %ebx
  8012ac:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8012af:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8012b4:	83 ec 0c             	sub    $0xc,%esp
  8012b7:	53                   	push   %ebx
  8012b8:	e8 c0 ff ff ff       	call   80127d <close>
	for (i = 0; i < MAXFD; i++)
  8012bd:	43                   	inc    %ebx
  8012be:	83 c4 10             	add    $0x10,%esp
  8012c1:	83 fb 20             	cmp    $0x20,%ebx
  8012c4:	75 ee                	jne    8012b4 <close_all+0xc>
}
  8012c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012c9:	c9                   	leave  
  8012ca:	c3                   	ret    

008012cb <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8012cb:	55                   	push   %ebp
  8012cc:	89 e5                	mov    %esp,%ebp
  8012ce:	57                   	push   %edi
  8012cf:	56                   	push   %esi
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8012d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012d7:	50                   	push   %eax
  8012d8:	ff 75 08             	pushl  0x8(%ebp)
  8012db:	e8 6a fe ff ff       	call   80114a <fd_lookup>
  8012e0:	89 c3                	mov    %eax,%ebx
  8012e2:	83 c4 08             	add    $0x8,%esp
  8012e5:	85 c0                	test   %eax,%eax
  8012e7:	0f 88 81 00 00 00    	js     80136e <dup+0xa3>
		return r;
	close(newfdnum);
  8012ed:	83 ec 0c             	sub    $0xc,%esp
  8012f0:	ff 75 0c             	pushl  0xc(%ebp)
  8012f3:	e8 85 ff ff ff       	call   80127d <close>

	newfd = INDEX2FD(newfdnum);
  8012f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  8012fb:	c1 e6 0c             	shl    $0xc,%esi
  8012fe:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801304:	83 c4 04             	add    $0x4,%esp
  801307:	ff 75 e4             	pushl  -0x1c(%ebp)
  80130a:	e8 d5 fd ff ff       	call   8010e4 <fd2data>
  80130f:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801311:	89 34 24             	mov    %esi,(%esp)
  801314:	e8 cb fd ff ff       	call   8010e4 <fd2data>
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80131e:	89 d8                	mov    %ebx,%eax
  801320:	c1 e8 16             	shr    $0x16,%eax
  801323:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80132a:	a8 01                	test   $0x1,%al
  80132c:	74 11                	je     80133f <dup+0x74>
  80132e:	89 d8                	mov    %ebx,%eax
  801330:	c1 e8 0c             	shr    $0xc,%eax
  801333:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80133a:	f6 c2 01             	test   $0x1,%dl
  80133d:	75 39                	jne    801378 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80133f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801342:	89 d0                	mov    %edx,%eax
  801344:	c1 e8 0c             	shr    $0xc,%eax
  801347:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80134e:	83 ec 0c             	sub    $0xc,%esp
  801351:	25 07 0e 00 00       	and    $0xe07,%eax
  801356:	50                   	push   %eax
  801357:	56                   	push   %esi
  801358:	6a 00                	push   $0x0
  80135a:	52                   	push   %edx
  80135b:	6a 00                	push   $0x0
  80135d:	e8 7b f8 ff ff       	call   800bdd <sys_page_map>
  801362:	89 c3                	mov    %eax,%ebx
  801364:	83 c4 20             	add    $0x20,%esp
  801367:	85 c0                	test   %eax,%eax
  801369:	78 31                	js     80139c <dup+0xd1>
		goto err;

	return newfdnum;
  80136b:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80136e:	89 d8                	mov    %ebx,%eax
  801370:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801373:	5b                   	pop    %ebx
  801374:	5e                   	pop    %esi
  801375:	5f                   	pop    %edi
  801376:	5d                   	pop    %ebp
  801377:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801378:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80137f:	83 ec 0c             	sub    $0xc,%esp
  801382:	25 07 0e 00 00       	and    $0xe07,%eax
  801387:	50                   	push   %eax
  801388:	57                   	push   %edi
  801389:	6a 00                	push   $0x0
  80138b:	53                   	push   %ebx
  80138c:	6a 00                	push   $0x0
  80138e:	e8 4a f8 ff ff       	call   800bdd <sys_page_map>
  801393:	89 c3                	mov    %eax,%ebx
  801395:	83 c4 20             	add    $0x20,%esp
  801398:	85 c0                	test   %eax,%eax
  80139a:	79 a3                	jns    80133f <dup+0x74>
	sys_page_unmap(0, newfd);
  80139c:	83 ec 08             	sub    $0x8,%esp
  80139f:	56                   	push   %esi
  8013a0:	6a 00                	push   $0x0
  8013a2:	e8 78 f8 ff ff       	call   800c1f <sys_page_unmap>
	sys_page_unmap(0, nva);
  8013a7:	83 c4 08             	add    $0x8,%esp
  8013aa:	57                   	push   %edi
  8013ab:	6a 00                	push   $0x0
  8013ad:	e8 6d f8 ff ff       	call   800c1f <sys_page_unmap>
	return r;
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	eb b7                	jmp    80136e <dup+0xa3>

008013b7 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8013b7:	55                   	push   %ebp
  8013b8:	89 e5                	mov    %esp,%ebp
  8013ba:	53                   	push   %ebx
  8013bb:	83 ec 14             	sub    $0x14,%esp
  8013be:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013c1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013c4:	50                   	push   %eax
  8013c5:	53                   	push   %ebx
  8013c6:	e8 7f fd ff ff       	call   80114a <fd_lookup>
  8013cb:	83 c4 08             	add    $0x8,%esp
  8013ce:	85 c0                	test   %eax,%eax
  8013d0:	78 3f                	js     801411 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013d2:	83 ec 08             	sub    $0x8,%esp
  8013d5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013d8:	50                   	push   %eax
  8013d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dc:	ff 30                	pushl  (%eax)
  8013de:	e8 be fd ff ff       	call   8011a1 <dev_lookup>
  8013e3:	83 c4 10             	add    $0x10,%esp
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	78 27                	js     801411 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8013ea:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013ed:	8b 42 08             	mov    0x8(%edx),%eax
  8013f0:	83 e0 03             	and    $0x3,%eax
  8013f3:	83 f8 01             	cmp    $0x1,%eax
  8013f6:	74 1e                	je     801416 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8013f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013fb:	8b 40 08             	mov    0x8(%eax),%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	74 35                	je     801437 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801402:	83 ec 04             	sub    $0x4,%esp
  801405:	ff 75 10             	pushl  0x10(%ebp)
  801408:	ff 75 0c             	pushl  0xc(%ebp)
  80140b:	52                   	push   %edx
  80140c:	ff d0                	call   *%eax
  80140e:	83 c4 10             	add    $0x10,%esp
}
  801411:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801414:	c9                   	leave  
  801415:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801416:	a1 04 40 80 00       	mov    0x804004,%eax
  80141b:	8b 40 48             	mov    0x48(%eax),%eax
  80141e:	83 ec 04             	sub    $0x4,%esp
  801421:	53                   	push   %ebx
  801422:	50                   	push   %eax
  801423:	68 cd 26 80 00       	push   $0x8026cd
  801428:	e8 b0 ed ff ff       	call   8001dd <cprintf>
		return -E_INVAL;
  80142d:	83 c4 10             	add    $0x10,%esp
  801430:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801435:	eb da                	jmp    801411 <read+0x5a>
		return -E_NOT_SUPP;
  801437:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80143c:	eb d3                	jmp    801411 <read+0x5a>

0080143e <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	57                   	push   %edi
  801442:	56                   	push   %esi
  801443:	53                   	push   %ebx
  801444:	83 ec 0c             	sub    $0xc,%esp
  801447:	8b 7d 08             	mov    0x8(%ebp),%edi
  80144a:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80144d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801452:	39 f3                	cmp    %esi,%ebx
  801454:	73 25                	jae    80147b <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801456:	83 ec 04             	sub    $0x4,%esp
  801459:	89 f0                	mov    %esi,%eax
  80145b:	29 d8                	sub    %ebx,%eax
  80145d:	50                   	push   %eax
  80145e:	89 d8                	mov    %ebx,%eax
  801460:	03 45 0c             	add    0xc(%ebp),%eax
  801463:	50                   	push   %eax
  801464:	57                   	push   %edi
  801465:	e8 4d ff ff ff       	call   8013b7 <read>
		if (m < 0)
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	85 c0                	test   %eax,%eax
  80146f:	78 08                	js     801479 <readn+0x3b>
			return m;
		if (m == 0)
  801471:	85 c0                	test   %eax,%eax
  801473:	74 06                	je     80147b <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801475:	01 c3                	add    %eax,%ebx
  801477:	eb d9                	jmp    801452 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801479:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80147b:	89 d8                	mov    %ebx,%eax
  80147d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801480:	5b                   	pop    %ebx
  801481:	5e                   	pop    %esi
  801482:	5f                   	pop    %edi
  801483:	5d                   	pop    %ebp
  801484:	c3                   	ret    

00801485 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801485:	55                   	push   %ebp
  801486:	89 e5                	mov    %esp,%ebp
  801488:	53                   	push   %ebx
  801489:	83 ec 14             	sub    $0x14,%esp
  80148c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80148f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801492:	50                   	push   %eax
  801493:	53                   	push   %ebx
  801494:	e8 b1 fc ff ff       	call   80114a <fd_lookup>
  801499:	83 c4 08             	add    $0x8,%esp
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 3a                	js     8014da <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014a6:	50                   	push   %eax
  8014a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014aa:	ff 30                	pushl  (%eax)
  8014ac:	e8 f0 fc ff ff       	call   8011a1 <dev_lookup>
  8014b1:	83 c4 10             	add    $0x10,%esp
  8014b4:	85 c0                	test   %eax,%eax
  8014b6:	78 22                	js     8014da <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8014b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014bb:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8014bf:	74 1e                	je     8014df <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8014c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c4:	8b 52 0c             	mov    0xc(%edx),%edx
  8014c7:	85 d2                	test   %edx,%edx
  8014c9:	74 35                	je     801500 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8014cb:	83 ec 04             	sub    $0x4,%esp
  8014ce:	ff 75 10             	pushl  0x10(%ebp)
  8014d1:	ff 75 0c             	pushl  0xc(%ebp)
  8014d4:	50                   	push   %eax
  8014d5:	ff d2                	call   *%edx
  8014d7:	83 c4 10             	add    $0x10,%esp
}
  8014da:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8014df:	a1 04 40 80 00       	mov    0x804004,%eax
  8014e4:	8b 40 48             	mov    0x48(%eax),%eax
  8014e7:	83 ec 04             	sub    $0x4,%esp
  8014ea:	53                   	push   %ebx
  8014eb:	50                   	push   %eax
  8014ec:	68 e9 26 80 00       	push   $0x8026e9
  8014f1:	e8 e7 ec ff ff       	call   8001dd <cprintf>
		return -E_INVAL;
  8014f6:	83 c4 10             	add    $0x10,%esp
  8014f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014fe:	eb da                	jmp    8014da <write+0x55>
		return -E_NOT_SUPP;
  801500:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801505:	eb d3                	jmp    8014da <write+0x55>

00801507 <seek>:

int
seek(int fdnum, off_t offset)
{
  801507:	55                   	push   %ebp
  801508:	89 e5                	mov    %esp,%ebp
  80150a:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80150d:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801510:	50                   	push   %eax
  801511:	ff 75 08             	pushl  0x8(%ebp)
  801514:	e8 31 fc ff ff       	call   80114a <fd_lookup>
  801519:	83 c4 08             	add    $0x8,%esp
  80151c:	85 c0                	test   %eax,%eax
  80151e:	78 0e                	js     80152e <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801520:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801523:	8b 55 0c             	mov    0xc(%ebp),%edx
  801526:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80152e:	c9                   	leave  
  80152f:	c3                   	ret    

00801530 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801530:	55                   	push   %ebp
  801531:	89 e5                	mov    %esp,%ebp
  801533:	53                   	push   %ebx
  801534:	83 ec 14             	sub    $0x14,%esp
  801537:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80153a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80153d:	50                   	push   %eax
  80153e:	53                   	push   %ebx
  80153f:	e8 06 fc ff ff       	call   80114a <fd_lookup>
  801544:	83 c4 08             	add    $0x8,%esp
  801547:	85 c0                	test   %eax,%eax
  801549:	78 37                	js     801582 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801551:	50                   	push   %eax
  801552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801555:	ff 30                	pushl  (%eax)
  801557:	e8 45 fc ff ff       	call   8011a1 <dev_lookup>
  80155c:	83 c4 10             	add    $0x10,%esp
  80155f:	85 c0                	test   %eax,%eax
  801561:	78 1f                	js     801582 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80156a:	74 1b                	je     801587 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80156c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156f:	8b 52 18             	mov    0x18(%edx),%edx
  801572:	85 d2                	test   %edx,%edx
  801574:	74 32                	je     8015a8 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801576:	83 ec 08             	sub    $0x8,%esp
  801579:	ff 75 0c             	pushl  0xc(%ebp)
  80157c:	50                   	push   %eax
  80157d:	ff d2                	call   *%edx
  80157f:	83 c4 10             	add    $0x10,%esp
}
  801582:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801585:	c9                   	leave  
  801586:	c3                   	ret    
			thisenv->env_id, fdnum);
  801587:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80158c:	8b 40 48             	mov    0x48(%eax),%eax
  80158f:	83 ec 04             	sub    $0x4,%esp
  801592:	53                   	push   %ebx
  801593:	50                   	push   %eax
  801594:	68 ac 26 80 00       	push   $0x8026ac
  801599:	e8 3f ec ff ff       	call   8001dd <cprintf>
		return -E_INVAL;
  80159e:	83 c4 10             	add    $0x10,%esp
  8015a1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015a6:	eb da                	jmp    801582 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8015a8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015ad:	eb d3                	jmp    801582 <ftruncate+0x52>

008015af <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8015af:	55                   	push   %ebp
  8015b0:	89 e5                	mov    %esp,%ebp
  8015b2:	53                   	push   %ebx
  8015b3:	83 ec 14             	sub    $0x14,%esp
  8015b6:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015bc:	50                   	push   %eax
  8015bd:	ff 75 08             	pushl  0x8(%ebp)
  8015c0:	e8 85 fb ff ff       	call   80114a <fd_lookup>
  8015c5:	83 c4 08             	add    $0x8,%esp
  8015c8:	85 c0                	test   %eax,%eax
  8015ca:	78 4b                	js     801617 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8015cc:	83 ec 08             	sub    $0x8,%esp
  8015cf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8015d2:	50                   	push   %eax
  8015d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d6:	ff 30                	pushl  (%eax)
  8015d8:	e8 c4 fb ff ff       	call   8011a1 <dev_lookup>
  8015dd:	83 c4 10             	add    $0x10,%esp
  8015e0:	85 c0                	test   %eax,%eax
  8015e2:	78 33                	js     801617 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8015e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015e7:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8015eb:	74 2f                	je     80161c <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8015ed:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8015f0:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8015f7:	00 00 00 
	stat->st_type = 0;
  8015fa:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801601:	00 00 00 
	stat->st_dev = dev;
  801604:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	53                   	push   %ebx
  80160e:	ff 75 f0             	pushl  -0x10(%ebp)
  801611:	ff 50 14             	call   *0x14(%eax)
  801614:	83 c4 10             	add    $0x10,%esp
}
  801617:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80161a:	c9                   	leave  
  80161b:	c3                   	ret    
		return -E_NOT_SUPP;
  80161c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801621:	eb f4                	jmp    801617 <fstat+0x68>

00801623 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801623:	55                   	push   %ebp
  801624:	89 e5                	mov    %esp,%ebp
  801626:	56                   	push   %esi
  801627:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801628:	83 ec 08             	sub    $0x8,%esp
  80162b:	6a 00                	push   $0x0
  80162d:	ff 75 08             	pushl  0x8(%ebp)
  801630:	e8 34 02 00 00       	call   801869 <open>
  801635:	89 c3                	mov    %eax,%ebx
  801637:	83 c4 10             	add    $0x10,%esp
  80163a:	85 c0                	test   %eax,%eax
  80163c:	78 1b                	js     801659 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80163e:	83 ec 08             	sub    $0x8,%esp
  801641:	ff 75 0c             	pushl  0xc(%ebp)
  801644:	50                   	push   %eax
  801645:	e8 65 ff ff ff       	call   8015af <fstat>
  80164a:	89 c6                	mov    %eax,%esi
	close(fd);
  80164c:	89 1c 24             	mov    %ebx,(%esp)
  80164f:	e8 29 fc ff ff       	call   80127d <close>
	return r;
  801654:	83 c4 10             	add    $0x10,%esp
  801657:	89 f3                	mov    %esi,%ebx
}
  801659:	89 d8                	mov    %ebx,%eax
  80165b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80165e:	5b                   	pop    %ebx
  80165f:	5e                   	pop    %esi
  801660:	5d                   	pop    %ebp
  801661:	c3                   	ret    

00801662 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801662:	55                   	push   %ebp
  801663:	89 e5                	mov    %esp,%ebp
  801665:	56                   	push   %esi
  801666:	53                   	push   %ebx
  801667:	89 c6                	mov    %eax,%esi
  801669:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80166b:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801672:	74 27                	je     80169b <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801674:	6a 07                	push   $0x7
  801676:	68 00 50 80 00       	push   $0x805000
  80167b:	56                   	push   %esi
  80167c:	ff 35 00 40 80 00    	pushl  0x804000
  801682:	e8 cc 08 00 00       	call   801f53 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801687:	83 c4 0c             	add    $0xc,%esp
  80168a:	6a 00                	push   $0x0
  80168c:	53                   	push   %ebx
  80168d:	6a 00                	push   $0x0
  80168f:	e8 36 08 00 00       	call   801eca <ipc_recv>
}
  801694:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801697:	5b                   	pop    %ebx
  801698:	5e                   	pop    %esi
  801699:	5d                   	pop    %ebp
  80169a:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  80169b:	83 ec 0c             	sub    $0xc,%esp
  80169e:	6a 01                	push   $0x1
  8016a0:	e8 0a 09 00 00       	call   801faf <ipc_find_env>
  8016a5:	a3 00 40 80 00       	mov    %eax,0x804000
  8016aa:	83 c4 10             	add    $0x10,%esp
  8016ad:	eb c5                	jmp    801674 <fsipc+0x12>

008016af <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8016bb:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8016c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016c3:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8016c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8016cd:	b8 02 00 00 00       	mov    $0x2,%eax
  8016d2:	e8 8b ff ff ff       	call   801662 <fsipc>
}
  8016d7:	c9                   	leave  
  8016d8:	c3                   	ret    

008016d9 <devfile_flush>:
{
  8016d9:	55                   	push   %ebp
  8016da:	89 e5                	mov    %esp,%ebp
  8016dc:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8016df:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8016e5:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8016ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ef:	b8 06 00 00 00       	mov    $0x6,%eax
  8016f4:	e8 69 ff ff ff       	call   801662 <fsipc>
}
  8016f9:	c9                   	leave  
  8016fa:	c3                   	ret    

008016fb <devfile_stat>:
{
  8016fb:	55                   	push   %ebp
  8016fc:	89 e5                	mov    %esp,%ebp
  8016fe:	53                   	push   %ebx
  8016ff:	83 ec 04             	sub    $0x4,%esp
  801702:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	8b 40 0c             	mov    0xc(%eax),%eax
  80170b:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801710:	ba 00 00 00 00       	mov    $0x0,%edx
  801715:	b8 05 00 00 00       	mov    $0x5,%eax
  80171a:	e8 43 ff ff ff       	call   801662 <fsipc>
  80171f:	85 c0                	test   %eax,%eax
  801721:	78 2c                	js     80174f <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801723:	83 ec 08             	sub    $0x8,%esp
  801726:	68 00 50 80 00       	push   $0x805000
  80172b:	53                   	push   %ebx
  80172c:	e8 b4 f0 ff ff       	call   8007e5 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801731:	a1 80 50 80 00       	mov    0x805080,%eax
  801736:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80173c:	a1 84 50 80 00       	mov    0x805084,%eax
  801741:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80174f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801752:	c9                   	leave  
  801753:	c3                   	ret    

00801754 <devfile_write>:
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	53                   	push   %ebx
  801758:	83 ec 04             	sub    $0x4,%esp
  80175b:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80175e:	89 d8                	mov    %ebx,%eax
  801760:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801766:	76 05                	jbe    80176d <devfile_write+0x19>
  801768:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80176d:	8b 55 08             	mov    0x8(%ebp),%edx
  801770:	8b 52 0c             	mov    0xc(%edx),%edx
  801773:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801779:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80177e:	83 ec 04             	sub    $0x4,%esp
  801781:	50                   	push   %eax
  801782:	ff 75 0c             	pushl  0xc(%ebp)
  801785:	68 08 50 80 00       	push   $0x805008
  80178a:	e8 c9 f1 ff ff       	call   800958 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80178f:	ba 00 00 00 00       	mov    $0x0,%edx
  801794:	b8 04 00 00 00       	mov    $0x4,%eax
  801799:	e8 c4 fe ff ff       	call   801662 <fsipc>
  80179e:	83 c4 10             	add    $0x10,%esp
  8017a1:	85 c0                	test   %eax,%eax
  8017a3:	78 0b                	js     8017b0 <devfile_write+0x5c>
	assert(r <= n);
  8017a5:	39 c3                	cmp    %eax,%ebx
  8017a7:	72 0c                	jb     8017b5 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8017a9:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8017ae:	7f 1e                	jg     8017ce <devfile_write+0x7a>
}
  8017b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b3:	c9                   	leave  
  8017b4:	c3                   	ret    
	assert(r <= n);
  8017b5:	68 18 27 80 00       	push   $0x802718
  8017ba:	68 56 26 80 00       	push   $0x802656
  8017bf:	68 98 00 00 00       	push   $0x98
  8017c4:	68 1f 27 80 00       	push   $0x80271f
  8017c9:	e8 11 06 00 00       	call   801ddf <_panic>
	assert(r <= PGSIZE);
  8017ce:	68 2a 27 80 00       	push   $0x80272a
  8017d3:	68 56 26 80 00       	push   $0x802656
  8017d8:	68 99 00 00 00       	push   $0x99
  8017dd:	68 1f 27 80 00       	push   $0x80271f
  8017e2:	e8 f8 05 00 00       	call   801ddf <_panic>

008017e7 <devfile_read>:
{
  8017e7:	55                   	push   %ebp
  8017e8:	89 e5                	mov    %esp,%ebp
  8017ea:	56                   	push   %esi
  8017eb:	53                   	push   %ebx
  8017ec:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8017ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8017f5:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  8017fa:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801800:	ba 00 00 00 00       	mov    $0x0,%edx
  801805:	b8 03 00 00 00       	mov    $0x3,%eax
  80180a:	e8 53 fe ff ff       	call   801662 <fsipc>
  80180f:	89 c3                	mov    %eax,%ebx
  801811:	85 c0                	test   %eax,%eax
  801813:	78 1f                	js     801834 <devfile_read+0x4d>
	assert(r <= n);
  801815:	39 c6                	cmp    %eax,%esi
  801817:	72 24                	jb     80183d <devfile_read+0x56>
	assert(r <= PGSIZE);
  801819:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80181e:	7f 33                	jg     801853 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801820:	83 ec 04             	sub    $0x4,%esp
  801823:	50                   	push   %eax
  801824:	68 00 50 80 00       	push   $0x805000
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	e8 27 f1 ff ff       	call   800958 <memmove>
	return r;
  801831:	83 c4 10             	add    $0x10,%esp
}
  801834:	89 d8                	mov    %ebx,%eax
  801836:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801839:	5b                   	pop    %ebx
  80183a:	5e                   	pop    %esi
  80183b:	5d                   	pop    %ebp
  80183c:	c3                   	ret    
	assert(r <= n);
  80183d:	68 18 27 80 00       	push   $0x802718
  801842:	68 56 26 80 00       	push   $0x802656
  801847:	6a 7c                	push   $0x7c
  801849:	68 1f 27 80 00       	push   $0x80271f
  80184e:	e8 8c 05 00 00       	call   801ddf <_panic>
	assert(r <= PGSIZE);
  801853:	68 2a 27 80 00       	push   $0x80272a
  801858:	68 56 26 80 00       	push   $0x802656
  80185d:	6a 7d                	push   $0x7d
  80185f:	68 1f 27 80 00       	push   $0x80271f
  801864:	e8 76 05 00 00       	call   801ddf <_panic>

00801869 <open>:
{
  801869:	55                   	push   %ebp
  80186a:	89 e5                	mov    %esp,%ebp
  80186c:	56                   	push   %esi
  80186d:	53                   	push   %ebx
  80186e:	83 ec 1c             	sub    $0x1c,%esp
  801871:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801874:	56                   	push   %esi
  801875:	e8 38 ef ff ff       	call   8007b2 <strlen>
  80187a:	83 c4 10             	add    $0x10,%esp
  80187d:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801882:	7f 6c                	jg     8018f0 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801884:	83 ec 0c             	sub    $0xc,%esp
  801887:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80188a:	50                   	push   %eax
  80188b:	e8 6b f8 ff ff       	call   8010fb <fd_alloc>
  801890:	89 c3                	mov    %eax,%ebx
  801892:	83 c4 10             	add    $0x10,%esp
  801895:	85 c0                	test   %eax,%eax
  801897:	78 3c                	js     8018d5 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801899:	83 ec 08             	sub    $0x8,%esp
  80189c:	56                   	push   %esi
  80189d:	68 00 50 80 00       	push   $0x805000
  8018a2:	e8 3e ef ff ff       	call   8007e5 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8018a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018aa:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8018af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8018b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8018b7:	e8 a6 fd ff ff       	call   801662 <fsipc>
  8018bc:	89 c3                	mov    %eax,%ebx
  8018be:	83 c4 10             	add    $0x10,%esp
  8018c1:	85 c0                	test   %eax,%eax
  8018c3:	78 19                	js     8018de <open+0x75>
	return fd2num(fd);
  8018c5:	83 ec 0c             	sub    $0xc,%esp
  8018c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8018cb:	e8 04 f8 ff ff       	call   8010d4 <fd2num>
  8018d0:	89 c3                	mov    %eax,%ebx
  8018d2:	83 c4 10             	add    $0x10,%esp
}
  8018d5:	89 d8                	mov    %ebx,%eax
  8018d7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018da:	5b                   	pop    %ebx
  8018db:	5e                   	pop    %esi
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    
		fd_close(fd, 0);
  8018de:	83 ec 08             	sub    $0x8,%esp
  8018e1:	6a 00                	push   $0x0
  8018e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8018e6:	e8 0c f9 ff ff       	call   8011f7 <fd_close>
		return r;
  8018eb:	83 c4 10             	add    $0x10,%esp
  8018ee:	eb e5                	jmp    8018d5 <open+0x6c>
		return -E_BAD_PATH;
  8018f0:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8018f5:	eb de                	jmp    8018d5 <open+0x6c>

008018f7 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8018f7:	55                   	push   %ebp
  8018f8:	89 e5                	mov    %esp,%ebp
  8018fa:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8018fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801902:	b8 08 00 00 00       	mov    $0x8,%eax
  801907:	e8 56 fd ff ff       	call   801662 <fsipc>
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	56                   	push   %esi
  801912:	53                   	push   %ebx
  801913:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801916:	83 ec 0c             	sub    $0xc,%esp
  801919:	ff 75 08             	pushl  0x8(%ebp)
  80191c:	e8 c3 f7 ff ff       	call   8010e4 <fd2data>
  801921:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801923:	83 c4 08             	add    $0x8,%esp
  801926:	68 36 27 80 00       	push   $0x802736
  80192b:	53                   	push   %ebx
  80192c:	e8 b4 ee ff ff       	call   8007e5 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801931:	8b 46 04             	mov    0x4(%esi),%eax
  801934:	2b 06                	sub    (%esi),%eax
  801936:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  80193c:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801943:	10 00 00 
	stat->st_dev = &devpipe;
  801946:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  80194d:	30 80 00 
	return 0;
}
  801950:	b8 00 00 00 00       	mov    $0x0,%eax
  801955:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801958:	5b                   	pop    %ebx
  801959:	5e                   	pop    %esi
  80195a:	5d                   	pop    %ebp
  80195b:	c3                   	ret    

0080195c <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
  80195f:	53                   	push   %ebx
  801960:	83 ec 0c             	sub    $0xc,%esp
  801963:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801966:	53                   	push   %ebx
  801967:	6a 00                	push   $0x0
  801969:	e8 b1 f2 ff ff       	call   800c1f <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80196e:	89 1c 24             	mov    %ebx,(%esp)
  801971:	e8 6e f7 ff ff       	call   8010e4 <fd2data>
  801976:	83 c4 08             	add    $0x8,%esp
  801979:	50                   	push   %eax
  80197a:	6a 00                	push   $0x0
  80197c:	e8 9e f2 ff ff       	call   800c1f <sys_page_unmap>
}
  801981:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801984:	c9                   	leave  
  801985:	c3                   	ret    

00801986 <_pipeisclosed>:
{
  801986:	55                   	push   %ebp
  801987:	89 e5                	mov    %esp,%ebp
  801989:	57                   	push   %edi
  80198a:	56                   	push   %esi
  80198b:	53                   	push   %ebx
  80198c:	83 ec 1c             	sub    $0x1c,%esp
  80198f:	89 c7                	mov    %eax,%edi
  801991:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801993:	a1 04 40 80 00       	mov    0x804004,%eax
  801998:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80199b:	83 ec 0c             	sub    $0xc,%esp
  80199e:	57                   	push   %edi
  80199f:	e8 4d 06 00 00       	call   801ff1 <pageref>
  8019a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019a7:	89 34 24             	mov    %esi,(%esp)
  8019aa:	e8 42 06 00 00       	call   801ff1 <pageref>
		nn = thisenv->env_runs;
  8019af:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019b5:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	39 cb                	cmp    %ecx,%ebx
  8019bd:	74 1b                	je     8019da <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019bf:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019c2:	75 cf                	jne    801993 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019c4:	8b 42 58             	mov    0x58(%edx),%eax
  8019c7:	6a 01                	push   $0x1
  8019c9:	50                   	push   %eax
  8019ca:	53                   	push   %ebx
  8019cb:	68 3d 27 80 00       	push   $0x80273d
  8019d0:	e8 08 e8 ff ff       	call   8001dd <cprintf>
  8019d5:	83 c4 10             	add    $0x10,%esp
  8019d8:	eb b9                	jmp    801993 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8019da:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019dd:	0f 94 c0             	sete   %al
  8019e0:	0f b6 c0             	movzbl %al,%eax
}
  8019e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8019e6:	5b                   	pop    %ebx
  8019e7:	5e                   	pop    %esi
  8019e8:	5f                   	pop    %edi
  8019e9:	5d                   	pop    %ebp
  8019ea:	c3                   	ret    

008019eb <devpipe_write>:
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	57                   	push   %edi
  8019ef:	56                   	push   %esi
  8019f0:	53                   	push   %ebx
  8019f1:	83 ec 18             	sub    $0x18,%esp
  8019f4:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8019f7:	56                   	push   %esi
  8019f8:	e8 e7 f6 ff ff       	call   8010e4 <fd2data>
  8019fd:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8019ff:	83 c4 10             	add    $0x10,%esp
  801a02:	bf 00 00 00 00       	mov    $0x0,%edi
  801a07:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a0a:	74 41                	je     801a4d <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a0c:	8b 53 04             	mov    0x4(%ebx),%edx
  801a0f:	8b 03                	mov    (%ebx),%eax
  801a11:	83 c0 20             	add    $0x20,%eax
  801a14:	39 c2                	cmp    %eax,%edx
  801a16:	72 14                	jb     801a2c <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a18:	89 da                	mov    %ebx,%edx
  801a1a:	89 f0                	mov    %esi,%eax
  801a1c:	e8 65 ff ff ff       	call   801986 <_pipeisclosed>
  801a21:	85 c0                	test   %eax,%eax
  801a23:	75 2c                	jne    801a51 <devpipe_write+0x66>
			sys_yield();
  801a25:	e8 37 f2 ff ff       	call   800c61 <sys_yield>
  801a2a:	eb e0                	jmp    801a0c <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a2f:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801a32:	89 d0                	mov    %edx,%eax
  801a34:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801a39:	78 0b                	js     801a46 <devpipe_write+0x5b>
  801a3b:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801a3f:	42                   	inc    %edx
  801a40:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a43:	47                   	inc    %edi
  801a44:	eb c1                	jmp    801a07 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a46:	48                   	dec    %eax
  801a47:	83 c8 e0             	or     $0xffffffe0,%eax
  801a4a:	40                   	inc    %eax
  801a4b:	eb ee                	jmp    801a3b <devpipe_write+0x50>
	return i;
  801a4d:	89 f8                	mov    %edi,%eax
  801a4f:	eb 05                	jmp    801a56 <devpipe_write+0x6b>
				return 0;
  801a51:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a56:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a59:	5b                   	pop    %ebx
  801a5a:	5e                   	pop    %esi
  801a5b:	5f                   	pop    %edi
  801a5c:	5d                   	pop    %ebp
  801a5d:	c3                   	ret    

00801a5e <devpipe_read>:
{
  801a5e:	55                   	push   %ebp
  801a5f:	89 e5                	mov    %esp,%ebp
  801a61:	57                   	push   %edi
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
  801a64:	83 ec 18             	sub    $0x18,%esp
  801a67:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a6a:	57                   	push   %edi
  801a6b:	e8 74 f6 ff ff       	call   8010e4 <fd2data>
  801a70:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801a72:	83 c4 10             	add    $0x10,%esp
  801a75:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a7a:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801a7d:	74 46                	je     801ac5 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801a7f:	8b 06                	mov    (%esi),%eax
  801a81:	3b 46 04             	cmp    0x4(%esi),%eax
  801a84:	75 22                	jne    801aa8 <devpipe_read+0x4a>
			if (i > 0)
  801a86:	85 db                	test   %ebx,%ebx
  801a88:	74 0a                	je     801a94 <devpipe_read+0x36>
				return i;
  801a8a:	89 d8                	mov    %ebx,%eax
}
  801a8c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a8f:	5b                   	pop    %ebx
  801a90:	5e                   	pop    %esi
  801a91:	5f                   	pop    %edi
  801a92:	5d                   	pop    %ebp
  801a93:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801a94:	89 f2                	mov    %esi,%edx
  801a96:	89 f8                	mov    %edi,%eax
  801a98:	e8 e9 fe ff ff       	call   801986 <_pipeisclosed>
  801a9d:	85 c0                	test   %eax,%eax
  801a9f:	75 28                	jne    801ac9 <devpipe_read+0x6b>
			sys_yield();
  801aa1:	e8 bb f1 ff ff       	call   800c61 <sys_yield>
  801aa6:	eb d7                	jmp    801a7f <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801aa8:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801aad:	78 0f                	js     801abe <devpipe_read+0x60>
  801aaf:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801ab3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801ab6:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801ab9:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801abb:	43                   	inc    %ebx
  801abc:	eb bc                	jmp    801a7a <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801abe:	48                   	dec    %eax
  801abf:	83 c8 e0             	or     $0xffffffe0,%eax
  801ac2:	40                   	inc    %eax
  801ac3:	eb ea                	jmp    801aaf <devpipe_read+0x51>
	return i;
  801ac5:	89 d8                	mov    %ebx,%eax
  801ac7:	eb c3                	jmp    801a8c <devpipe_read+0x2e>
				return 0;
  801ac9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ace:	eb bc                	jmp    801a8c <devpipe_read+0x2e>

00801ad0 <pipe>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	56                   	push   %esi
  801ad4:	53                   	push   %ebx
  801ad5:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801ad8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801adb:	50                   	push   %eax
  801adc:	e8 1a f6 ff ff       	call   8010fb <fd_alloc>
  801ae1:	89 c3                	mov    %eax,%ebx
  801ae3:	83 c4 10             	add    $0x10,%esp
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	0f 88 2a 01 00 00    	js     801c18 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801aee:	83 ec 04             	sub    $0x4,%esp
  801af1:	68 07 04 00 00       	push   $0x407
  801af6:	ff 75 f4             	pushl  -0xc(%ebp)
  801af9:	6a 00                	push   $0x0
  801afb:	e8 9a f0 ff ff       	call   800b9a <sys_page_alloc>
  801b00:	89 c3                	mov    %eax,%ebx
  801b02:	83 c4 10             	add    $0x10,%esp
  801b05:	85 c0                	test   %eax,%eax
  801b07:	0f 88 0b 01 00 00    	js     801c18 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801b0d:	83 ec 0c             	sub    $0xc,%esp
  801b10:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b13:	50                   	push   %eax
  801b14:	e8 e2 f5 ff ff       	call   8010fb <fd_alloc>
  801b19:	89 c3                	mov    %eax,%ebx
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	85 c0                	test   %eax,%eax
  801b20:	0f 88 e2 00 00 00    	js     801c08 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b26:	83 ec 04             	sub    $0x4,%esp
  801b29:	68 07 04 00 00       	push   $0x407
  801b2e:	ff 75 f0             	pushl  -0x10(%ebp)
  801b31:	6a 00                	push   $0x0
  801b33:	e8 62 f0 ff ff       	call   800b9a <sys_page_alloc>
  801b38:	89 c3                	mov    %eax,%ebx
  801b3a:	83 c4 10             	add    $0x10,%esp
  801b3d:	85 c0                	test   %eax,%eax
  801b3f:	0f 88 c3 00 00 00    	js     801c08 <pipe+0x138>
	va = fd2data(fd0);
  801b45:	83 ec 0c             	sub    $0xc,%esp
  801b48:	ff 75 f4             	pushl  -0xc(%ebp)
  801b4b:	e8 94 f5 ff ff       	call   8010e4 <fd2data>
  801b50:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b52:	83 c4 0c             	add    $0xc,%esp
  801b55:	68 07 04 00 00       	push   $0x407
  801b5a:	50                   	push   %eax
  801b5b:	6a 00                	push   $0x0
  801b5d:	e8 38 f0 ff ff       	call   800b9a <sys_page_alloc>
  801b62:	89 c3                	mov    %eax,%ebx
  801b64:	83 c4 10             	add    $0x10,%esp
  801b67:	85 c0                	test   %eax,%eax
  801b69:	0f 88 89 00 00 00    	js     801bf8 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b6f:	83 ec 0c             	sub    $0xc,%esp
  801b72:	ff 75 f0             	pushl  -0x10(%ebp)
  801b75:	e8 6a f5 ff ff       	call   8010e4 <fd2data>
  801b7a:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801b81:	50                   	push   %eax
  801b82:	6a 00                	push   $0x0
  801b84:	56                   	push   %esi
  801b85:	6a 00                	push   $0x0
  801b87:	e8 51 f0 ff ff       	call   800bdd <sys_page_map>
  801b8c:	89 c3                	mov    %eax,%ebx
  801b8e:	83 c4 20             	add    $0x20,%esp
  801b91:	85 c0                	test   %eax,%eax
  801b93:	78 55                	js     801bea <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801b95:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b9e:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ba3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801baa:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb3:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb8:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bbf:	83 ec 0c             	sub    $0xc,%esp
  801bc2:	ff 75 f4             	pushl  -0xc(%ebp)
  801bc5:	e8 0a f5 ff ff       	call   8010d4 <fd2num>
  801bca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bcd:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801bcf:	83 c4 04             	add    $0x4,%esp
  801bd2:	ff 75 f0             	pushl  -0x10(%ebp)
  801bd5:	e8 fa f4 ff ff       	call   8010d4 <fd2num>
  801bda:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801bdd:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be8:	eb 2e                	jmp    801c18 <pipe+0x148>
	sys_page_unmap(0, va);
  801bea:	83 ec 08             	sub    $0x8,%esp
  801bed:	56                   	push   %esi
  801bee:	6a 00                	push   $0x0
  801bf0:	e8 2a f0 ff ff       	call   800c1f <sys_page_unmap>
  801bf5:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801bf8:	83 ec 08             	sub    $0x8,%esp
  801bfb:	ff 75 f0             	pushl  -0x10(%ebp)
  801bfe:	6a 00                	push   $0x0
  801c00:	e8 1a f0 ff ff       	call   800c1f <sys_page_unmap>
  801c05:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c08:	83 ec 08             	sub    $0x8,%esp
  801c0b:	ff 75 f4             	pushl  -0xc(%ebp)
  801c0e:	6a 00                	push   $0x0
  801c10:	e8 0a f0 ff ff       	call   800c1f <sys_page_unmap>
  801c15:	83 c4 10             	add    $0x10,%esp
}
  801c18:	89 d8                	mov    %ebx,%eax
  801c1a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c1d:	5b                   	pop    %ebx
  801c1e:	5e                   	pop    %esi
  801c1f:	5d                   	pop    %ebp
  801c20:	c3                   	ret    

00801c21 <pipeisclosed>:
{
  801c21:	55                   	push   %ebp
  801c22:	89 e5                	mov    %esp,%ebp
  801c24:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c27:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c2a:	50                   	push   %eax
  801c2b:	ff 75 08             	pushl  0x8(%ebp)
  801c2e:	e8 17 f5 ff ff       	call   80114a <fd_lookup>
  801c33:	83 c4 10             	add    $0x10,%esp
  801c36:	85 c0                	test   %eax,%eax
  801c38:	78 18                	js     801c52 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c3a:	83 ec 0c             	sub    $0xc,%esp
  801c3d:	ff 75 f4             	pushl  -0xc(%ebp)
  801c40:	e8 9f f4 ff ff       	call   8010e4 <fd2data>
	return _pipeisclosed(fd, p);
  801c45:	89 c2                	mov    %eax,%edx
  801c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c4a:	e8 37 fd ff ff       	call   801986 <_pipeisclosed>
  801c4f:	83 c4 10             	add    $0x10,%esp
}
  801c52:	c9                   	leave  
  801c53:	c3                   	ret    

00801c54 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c54:	55                   	push   %ebp
  801c55:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c57:	b8 00 00 00 00       	mov    $0x0,%eax
  801c5c:	5d                   	pop    %ebp
  801c5d:	c3                   	ret    

00801c5e <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
  801c61:	53                   	push   %ebx
  801c62:	83 ec 0c             	sub    $0xc,%esp
  801c65:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801c68:	68 55 27 80 00       	push   $0x802755
  801c6d:	53                   	push   %ebx
  801c6e:	e8 72 eb ff ff       	call   8007e5 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801c73:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801c7a:	20 00 00 
	return 0;
}
  801c7d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c82:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <devcons_write>:
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
  801c8a:	57                   	push   %edi
  801c8b:	56                   	push   %esi
  801c8c:	53                   	push   %ebx
  801c8d:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801c93:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801c98:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801c9e:	eb 1d                	jmp    801cbd <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801ca0:	83 ec 04             	sub    $0x4,%esp
  801ca3:	53                   	push   %ebx
  801ca4:	03 45 0c             	add    0xc(%ebp),%eax
  801ca7:	50                   	push   %eax
  801ca8:	57                   	push   %edi
  801ca9:	e8 aa ec ff ff       	call   800958 <memmove>
		sys_cputs(buf, m);
  801cae:	83 c4 08             	add    $0x8,%esp
  801cb1:	53                   	push   %ebx
  801cb2:	57                   	push   %edi
  801cb3:	e8 45 ee ff ff       	call   800afd <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801cb8:	01 de                	add    %ebx,%esi
  801cba:	83 c4 10             	add    $0x10,%esp
  801cbd:	89 f0                	mov    %esi,%eax
  801cbf:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cc2:	73 11                	jae    801cd5 <devcons_write+0x4e>
		m = n - tot;
  801cc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cc7:	29 f3                	sub    %esi,%ebx
  801cc9:	83 fb 7f             	cmp    $0x7f,%ebx
  801ccc:	76 d2                	jbe    801ca0 <devcons_write+0x19>
  801cce:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801cd3:	eb cb                	jmp    801ca0 <devcons_write+0x19>
}
  801cd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cd8:	5b                   	pop    %ebx
  801cd9:	5e                   	pop    %esi
  801cda:	5f                   	pop    %edi
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <devcons_read>:
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ce7:	75 0c                	jne    801cf5 <devcons_read+0x18>
		return 0;
  801ce9:	b8 00 00 00 00       	mov    $0x0,%eax
  801cee:	eb 21                	jmp    801d11 <devcons_read+0x34>
		sys_yield();
  801cf0:	e8 6c ef ff ff       	call   800c61 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801cf5:	e8 21 ee ff ff       	call   800b1b <sys_cgetc>
  801cfa:	85 c0                	test   %eax,%eax
  801cfc:	74 f2                	je     801cf0 <devcons_read+0x13>
	if (c < 0)
  801cfe:	85 c0                	test   %eax,%eax
  801d00:	78 0f                	js     801d11 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801d02:	83 f8 04             	cmp    $0x4,%eax
  801d05:	74 0c                	je     801d13 <devcons_read+0x36>
	*(char*)vbuf = c;
  801d07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d0a:	88 02                	mov    %al,(%edx)
	return 1;
  801d0c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d11:	c9                   	leave  
  801d12:	c3                   	ret    
		return 0;
  801d13:	b8 00 00 00 00       	mov    $0x0,%eax
  801d18:	eb f7                	jmp    801d11 <devcons_read+0x34>

00801d1a <cputchar>:
{
  801d1a:	55                   	push   %ebp
  801d1b:	89 e5                	mov    %esp,%ebp
  801d1d:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d20:	8b 45 08             	mov    0x8(%ebp),%eax
  801d23:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d26:	6a 01                	push   $0x1
  801d28:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d2b:	50                   	push   %eax
  801d2c:	e8 cc ed ff ff       	call   800afd <sys_cputs>
}
  801d31:	83 c4 10             	add    $0x10,%esp
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <getchar>:
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d3c:	6a 01                	push   $0x1
  801d3e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d41:	50                   	push   %eax
  801d42:	6a 00                	push   $0x0
  801d44:	e8 6e f6 ff ff       	call   8013b7 <read>
	if (r < 0)
  801d49:	83 c4 10             	add    $0x10,%esp
  801d4c:	85 c0                	test   %eax,%eax
  801d4e:	78 08                	js     801d58 <getchar+0x22>
	if (r < 1)
  801d50:	85 c0                	test   %eax,%eax
  801d52:	7e 06                	jle    801d5a <getchar+0x24>
	return c;
  801d54:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    
		return -E_EOF;
  801d5a:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d5f:	eb f7                	jmp    801d58 <getchar+0x22>

00801d61 <iscons>:
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
  801d64:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d67:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d6a:	50                   	push   %eax
  801d6b:	ff 75 08             	pushl  0x8(%ebp)
  801d6e:	e8 d7 f3 ff ff       	call   80114a <fd_lookup>
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	85 c0                	test   %eax,%eax
  801d78:	78 11                	js     801d8b <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801d7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d7d:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801d83:	39 10                	cmp    %edx,(%eax)
  801d85:	0f 94 c0             	sete   %al
  801d88:	0f b6 c0             	movzbl %al,%eax
}
  801d8b:	c9                   	leave  
  801d8c:	c3                   	ret    

00801d8d <opencons>:
{
  801d8d:	55                   	push   %ebp
  801d8e:	89 e5                	mov    %esp,%ebp
  801d90:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801d93:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d96:	50                   	push   %eax
  801d97:	e8 5f f3 ff ff       	call   8010fb <fd_alloc>
  801d9c:	83 c4 10             	add    $0x10,%esp
  801d9f:	85 c0                	test   %eax,%eax
  801da1:	78 3a                	js     801ddd <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801da3:	83 ec 04             	sub    $0x4,%esp
  801da6:	68 07 04 00 00       	push   $0x407
  801dab:	ff 75 f4             	pushl  -0xc(%ebp)
  801dae:	6a 00                	push   $0x0
  801db0:	e8 e5 ed ff ff       	call   800b9a <sys_page_alloc>
  801db5:	83 c4 10             	add    $0x10,%esp
  801db8:	85 c0                	test   %eax,%eax
  801dba:	78 21                	js     801ddd <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801dbc:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dca:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801dd1:	83 ec 0c             	sub    $0xc,%esp
  801dd4:	50                   	push   %eax
  801dd5:	e8 fa f2 ff ff       	call   8010d4 <fd2num>
  801dda:	83 c4 10             	add    $0x10,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
  801de2:	57                   	push   %edi
  801de3:	56                   	push   %esi
  801de4:	53                   	push   %ebx
  801de5:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801deb:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801dee:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801df4:	e8 82 ed ff ff       	call   800b7b <sys_getenvid>
  801df9:	83 ec 04             	sub    $0x4,%esp
  801dfc:	ff 75 0c             	pushl  0xc(%ebp)
  801dff:	ff 75 08             	pushl  0x8(%ebp)
  801e02:	53                   	push   %ebx
  801e03:	50                   	push   %eax
  801e04:	68 64 27 80 00       	push   $0x802764
  801e09:	68 00 01 00 00       	push   $0x100
  801e0e:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801e14:	56                   	push   %esi
  801e15:	e8 7e e9 ff ff       	call   800798 <snprintf>
  801e1a:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801e1c:	83 c4 20             	add    $0x20,%esp
  801e1f:	57                   	push   %edi
  801e20:	ff 75 10             	pushl  0x10(%ebp)
  801e23:	bf 00 01 00 00       	mov    $0x100,%edi
  801e28:	89 f8                	mov    %edi,%eax
  801e2a:	29 d8                	sub    %ebx,%eax
  801e2c:	50                   	push   %eax
  801e2d:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e30:	50                   	push   %eax
  801e31:	e8 0d e9 ff ff       	call   800743 <vsnprintf>
  801e36:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e38:	83 c4 0c             	add    $0xc,%esp
  801e3b:	68 8f 22 80 00       	push   $0x80228f
  801e40:	29 df                	sub    %ebx,%edi
  801e42:	57                   	push   %edi
  801e43:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e46:	50                   	push   %eax
  801e47:	e8 4c e9 ff ff       	call   800798 <snprintf>
	sys_cputs(buf, r);
  801e4c:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e4f:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801e51:	53                   	push   %ebx
  801e52:	56                   	push   %esi
  801e53:	e8 a5 ec ff ff       	call   800afd <sys_cputs>
  801e58:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e5b:	cc                   	int3   
  801e5c:	eb fd                	jmp    801e5b <_panic+0x7c>

00801e5e <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
  801e61:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801e64:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801e6b:	74 0a                	je     801e77 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e70:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801e77:	e8 ff ec ff ff       	call   800b7b <sys_getenvid>
  801e7c:	83 ec 04             	sub    $0x4,%esp
  801e7f:	6a 07                	push   $0x7
  801e81:	68 00 f0 bf ee       	push   $0xeebff000
  801e86:	50                   	push   %eax
  801e87:	e8 0e ed ff ff       	call   800b9a <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801e8c:	e8 ea ec ff ff       	call   800b7b <sys_getenvid>
  801e91:	83 c4 08             	add    $0x8,%esp
  801e94:	68 a4 1e 80 00       	push   $0x801ea4
  801e99:	50                   	push   %eax
  801e9a:	e8 a6 ee ff ff       	call   800d45 <sys_env_set_pgfault_upcall>
  801e9f:	83 c4 10             	add    $0x10,%esp
  801ea2:	eb c9                	jmp    801e6d <set_pgfault_handler+0xf>

00801ea4 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801ea4:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801ea5:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801eaa:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801eac:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801eaf:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801eb3:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801eb7:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801eba:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801ebc:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801ec0:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801ec3:	61                   	popa   
	addl $4, %esp
  801ec4:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801ec7:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801ec8:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801ec9:	c3                   	ret    

00801eca <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	57                   	push   %edi
  801ece:	56                   	push   %esi
  801ecf:	53                   	push   %ebx
  801ed0:	83 ec 0c             	sub    $0xc,%esp
  801ed3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801ed6:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ed9:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801edc:	85 ff                	test   %edi,%edi
  801ede:	74 53                	je     801f33 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	57                   	push   %edi
  801ee4:	e8 c1 ee ff ff       	call   800daa <sys_ipc_recv>
  801ee9:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801eec:	85 db                	test   %ebx,%ebx
  801eee:	74 0b                	je     801efb <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801ef0:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ef6:	8b 52 74             	mov    0x74(%edx),%edx
  801ef9:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801efb:	85 f6                	test   %esi,%esi
  801efd:	74 0f                	je     801f0e <ipc_recv+0x44>
  801eff:	85 ff                	test   %edi,%edi
  801f01:	74 0b                	je     801f0e <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801f03:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801f09:	8b 52 78             	mov    0x78(%edx),%edx
  801f0c:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801f0e:	85 c0                	test   %eax,%eax
  801f10:	74 30                	je     801f42 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801f12:	85 db                	test   %ebx,%ebx
  801f14:	74 06                	je     801f1c <ipc_recv+0x52>
      		*from_env_store = 0;
  801f16:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801f1c:	85 f6                	test   %esi,%esi
  801f1e:	74 2c                	je     801f4c <ipc_recv+0x82>
      		*perm_store = 0;
  801f20:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801f26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801f2b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f2e:	5b                   	pop    %ebx
  801f2f:	5e                   	pop    %esi
  801f30:	5f                   	pop    %edi
  801f31:	5d                   	pop    %ebp
  801f32:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801f33:	83 ec 0c             	sub    $0xc,%esp
  801f36:	6a ff                	push   $0xffffffff
  801f38:	e8 6d ee ff ff       	call   800daa <sys_ipc_recv>
  801f3d:	83 c4 10             	add    $0x10,%esp
  801f40:	eb aa                	jmp    801eec <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801f42:	a1 04 40 80 00       	mov    0x804004,%eax
  801f47:	8b 40 70             	mov    0x70(%eax),%eax
  801f4a:	eb df                	jmp    801f2b <ipc_recv+0x61>
		return -1;
  801f4c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f51:	eb d8                	jmp    801f2b <ipc_recv+0x61>

00801f53 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f53:	55                   	push   %ebp
  801f54:	89 e5                	mov    %esp,%ebp
  801f56:	57                   	push   %edi
  801f57:	56                   	push   %esi
  801f58:	53                   	push   %ebx
  801f59:	83 ec 0c             	sub    $0xc,%esp
  801f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f5f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f62:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f65:	85 db                	test   %ebx,%ebx
  801f67:	75 22                	jne    801f8b <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801f69:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801f6e:	eb 1b                	jmp    801f8b <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f70:	68 88 27 80 00       	push   $0x802788
  801f75:	68 56 26 80 00       	push   $0x802656
  801f7a:	6a 48                	push   $0x48
  801f7c:	68 ac 27 80 00       	push   $0x8027ac
  801f81:	e8 59 fe ff ff       	call   801ddf <_panic>
		sys_yield();
  801f86:	e8 d6 ec ff ff       	call   800c61 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801f8b:	57                   	push   %edi
  801f8c:	53                   	push   %ebx
  801f8d:	56                   	push   %esi
  801f8e:	ff 75 08             	pushl  0x8(%ebp)
  801f91:	e8 f1 ed ff ff       	call   800d87 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f96:	83 c4 10             	add    $0x10,%esp
  801f99:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f9c:	74 e8                	je     801f86 <ipc_send+0x33>
  801f9e:	85 c0                	test   %eax,%eax
  801fa0:	75 ce                	jne    801f70 <ipc_send+0x1d>
		sys_yield();
  801fa2:	e8 ba ec ff ff       	call   800c61 <sys_yield>
		
	}
	
}
  801fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801fb5:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801fba:	89 c2                	mov    %eax,%edx
  801fbc:	c1 e2 05             	shl    $0x5,%edx
  801fbf:	29 c2                	sub    %eax,%edx
  801fc1:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801fc8:	8b 52 50             	mov    0x50(%edx),%edx
  801fcb:	39 ca                	cmp    %ecx,%edx
  801fcd:	74 0f                	je     801fde <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801fcf:	40                   	inc    %eax
  801fd0:	3d 00 04 00 00       	cmp    $0x400,%eax
  801fd5:	75 e3                	jne    801fba <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fd7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fdc:	eb 11                	jmp    801fef <ipc_find_env+0x40>
			return envs[i].env_id;
  801fde:	89 c2                	mov    %eax,%edx
  801fe0:	c1 e2 05             	shl    $0x5,%edx
  801fe3:	29 c2                	sub    %eax,%edx
  801fe5:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801fec:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fef:	5d                   	pop    %ebp
  801ff0:	c3                   	ret    

00801ff1 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801ff1:	55                   	push   %ebp
  801ff2:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff7:	c1 e8 16             	shr    $0x16,%eax
  801ffa:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802001:	a8 01                	test   $0x1,%al
  802003:	74 21                	je     802026 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802005:	8b 45 08             	mov    0x8(%ebp),%eax
  802008:	c1 e8 0c             	shr    $0xc,%eax
  80200b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802012:	a8 01                	test   $0x1,%al
  802014:	74 17                	je     80202d <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802016:	c1 e8 0c             	shr    $0xc,%eax
  802019:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802020:	ef 
  802021:	0f b7 c0             	movzwl %ax,%eax
  802024:	eb 05                	jmp    80202b <pageref+0x3a>
		return 0;
  802026:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80202b:	5d                   	pop    %ebp
  80202c:	c3                   	ret    
		return 0;
  80202d:	b8 00 00 00 00       	mov    $0x0,%eax
  802032:	eb f7                	jmp    80202b <pageref+0x3a>

00802034 <__udivdi3>:
  802034:	55                   	push   %ebp
  802035:	57                   	push   %edi
  802036:	56                   	push   %esi
  802037:	53                   	push   %ebx
  802038:	83 ec 1c             	sub    $0x1c,%esp
  80203b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80203f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802043:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802047:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80204b:	89 ca                	mov    %ecx,%edx
  80204d:	89 f8                	mov    %edi,%eax
  80204f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802053:	85 f6                	test   %esi,%esi
  802055:	75 2d                	jne    802084 <__udivdi3+0x50>
  802057:	39 cf                	cmp    %ecx,%edi
  802059:	77 65                	ja     8020c0 <__udivdi3+0x8c>
  80205b:	89 fd                	mov    %edi,%ebp
  80205d:	85 ff                	test   %edi,%edi
  80205f:	75 0b                	jne    80206c <__udivdi3+0x38>
  802061:	b8 01 00 00 00       	mov    $0x1,%eax
  802066:	31 d2                	xor    %edx,%edx
  802068:	f7 f7                	div    %edi
  80206a:	89 c5                	mov    %eax,%ebp
  80206c:	31 d2                	xor    %edx,%edx
  80206e:	89 c8                	mov    %ecx,%eax
  802070:	f7 f5                	div    %ebp
  802072:	89 c1                	mov    %eax,%ecx
  802074:	89 d8                	mov    %ebx,%eax
  802076:	f7 f5                	div    %ebp
  802078:	89 cf                	mov    %ecx,%edi
  80207a:	89 fa                	mov    %edi,%edx
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
  802084:	39 ce                	cmp    %ecx,%esi
  802086:	77 28                	ja     8020b0 <__udivdi3+0x7c>
  802088:	0f bd fe             	bsr    %esi,%edi
  80208b:	83 f7 1f             	xor    $0x1f,%edi
  80208e:	75 40                	jne    8020d0 <__udivdi3+0x9c>
  802090:	39 ce                	cmp    %ecx,%esi
  802092:	72 0a                	jb     80209e <__udivdi3+0x6a>
  802094:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802098:	0f 87 9e 00 00 00    	ja     80213c <__udivdi3+0x108>
  80209e:	b8 01 00 00 00       	mov    $0x1,%eax
  8020a3:	89 fa                	mov    %edi,%edx
  8020a5:	83 c4 1c             	add    $0x1c,%esp
  8020a8:	5b                   	pop    %ebx
  8020a9:	5e                   	pop    %esi
  8020aa:	5f                   	pop    %edi
  8020ab:	5d                   	pop    %ebp
  8020ac:	c3                   	ret    
  8020ad:	8d 76 00             	lea    0x0(%esi),%esi
  8020b0:	31 ff                	xor    %edi,%edi
  8020b2:	31 c0                	xor    %eax,%eax
  8020b4:	89 fa                	mov    %edi,%edx
  8020b6:	83 c4 1c             	add    $0x1c,%esp
  8020b9:	5b                   	pop    %ebx
  8020ba:	5e                   	pop    %esi
  8020bb:	5f                   	pop    %edi
  8020bc:	5d                   	pop    %ebp
  8020bd:	c3                   	ret    
  8020be:	66 90                	xchg   %ax,%ax
  8020c0:	89 d8                	mov    %ebx,%eax
  8020c2:	f7 f7                	div    %edi
  8020c4:	31 ff                	xor    %edi,%edi
  8020c6:	89 fa                	mov    %edi,%edx
  8020c8:	83 c4 1c             	add    $0x1c,%esp
  8020cb:	5b                   	pop    %ebx
  8020cc:	5e                   	pop    %esi
  8020cd:	5f                   	pop    %edi
  8020ce:	5d                   	pop    %ebp
  8020cf:	c3                   	ret    
  8020d0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020d5:	29 fd                	sub    %edi,%ebp
  8020d7:	89 f9                	mov    %edi,%ecx
  8020d9:	d3 e6                	shl    %cl,%esi
  8020db:	89 c3                	mov    %eax,%ebx
  8020dd:	89 e9                	mov    %ebp,%ecx
  8020df:	d3 eb                	shr    %cl,%ebx
  8020e1:	89 d9                	mov    %ebx,%ecx
  8020e3:	09 f1                	or     %esi,%ecx
  8020e5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020e9:	89 f9                	mov    %edi,%ecx
  8020eb:	d3 e0                	shl    %cl,%eax
  8020ed:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020f1:	89 d6                	mov    %edx,%esi
  8020f3:	89 e9                	mov    %ebp,%ecx
  8020f5:	d3 ee                	shr    %cl,%esi
  8020f7:	89 f9                	mov    %edi,%ecx
  8020f9:	d3 e2                	shl    %cl,%edx
  8020fb:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020ff:	89 e9                	mov    %ebp,%ecx
  802101:	d3 eb                	shr    %cl,%ebx
  802103:	09 da                	or     %ebx,%edx
  802105:	89 d0                	mov    %edx,%eax
  802107:	89 f2                	mov    %esi,%edx
  802109:	f7 74 24 08          	divl   0x8(%esp)
  80210d:	89 d6                	mov    %edx,%esi
  80210f:	89 c3                	mov    %eax,%ebx
  802111:	f7 64 24 0c          	mull   0xc(%esp)
  802115:	39 d6                	cmp    %edx,%esi
  802117:	72 17                	jb     802130 <__udivdi3+0xfc>
  802119:	74 09                	je     802124 <__udivdi3+0xf0>
  80211b:	89 d8                	mov    %ebx,%eax
  80211d:	31 ff                	xor    %edi,%edi
  80211f:	e9 56 ff ff ff       	jmp    80207a <__udivdi3+0x46>
  802124:	8b 54 24 04          	mov    0x4(%esp),%edx
  802128:	89 f9                	mov    %edi,%ecx
  80212a:	d3 e2                	shl    %cl,%edx
  80212c:	39 c2                	cmp    %eax,%edx
  80212e:	73 eb                	jae    80211b <__udivdi3+0xe7>
  802130:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802133:	31 ff                	xor    %edi,%edi
  802135:	e9 40 ff ff ff       	jmp    80207a <__udivdi3+0x46>
  80213a:	66 90                	xchg   %ax,%ax
  80213c:	31 c0                	xor    %eax,%eax
  80213e:	e9 37 ff ff ff       	jmp    80207a <__udivdi3+0x46>
  802143:	90                   	nop

00802144 <__umoddi3>:
  802144:	55                   	push   %ebp
  802145:	57                   	push   %edi
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	83 ec 1c             	sub    $0x1c,%esp
  80214b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80214f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802153:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802157:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80215b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80215f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802163:	89 3c 24             	mov    %edi,(%esp)
  802166:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80216a:	89 f2                	mov    %esi,%edx
  80216c:	85 c0                	test   %eax,%eax
  80216e:	75 18                	jne    802188 <__umoddi3+0x44>
  802170:	39 f7                	cmp    %esi,%edi
  802172:	0f 86 a0 00 00 00    	jbe    802218 <__umoddi3+0xd4>
  802178:	89 c8                	mov    %ecx,%eax
  80217a:	f7 f7                	div    %edi
  80217c:	89 d0                	mov    %edx,%eax
  80217e:	31 d2                	xor    %edx,%edx
  802180:	83 c4 1c             	add    $0x1c,%esp
  802183:	5b                   	pop    %ebx
  802184:	5e                   	pop    %esi
  802185:	5f                   	pop    %edi
  802186:	5d                   	pop    %ebp
  802187:	c3                   	ret    
  802188:	89 f3                	mov    %esi,%ebx
  80218a:	39 f0                	cmp    %esi,%eax
  80218c:	0f 87 a6 00 00 00    	ja     802238 <__umoddi3+0xf4>
  802192:	0f bd e8             	bsr    %eax,%ebp
  802195:	83 f5 1f             	xor    $0x1f,%ebp
  802198:	0f 84 a6 00 00 00    	je     802244 <__umoddi3+0x100>
  80219e:	bf 20 00 00 00       	mov    $0x20,%edi
  8021a3:	29 ef                	sub    %ebp,%edi
  8021a5:	89 e9                	mov    %ebp,%ecx
  8021a7:	d3 e0                	shl    %cl,%eax
  8021a9:	8b 34 24             	mov    (%esp),%esi
  8021ac:	89 f2                	mov    %esi,%edx
  8021ae:	89 f9                	mov    %edi,%ecx
  8021b0:	d3 ea                	shr    %cl,%edx
  8021b2:	09 c2                	or     %eax,%edx
  8021b4:	89 14 24             	mov    %edx,(%esp)
  8021b7:	89 f2                	mov    %esi,%edx
  8021b9:	89 e9                	mov    %ebp,%ecx
  8021bb:	d3 e2                	shl    %cl,%edx
  8021bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8021c1:	89 de                	mov    %ebx,%esi
  8021c3:	89 f9                	mov    %edi,%ecx
  8021c5:	d3 ee                	shr    %cl,%esi
  8021c7:	89 e9                	mov    %ebp,%ecx
  8021c9:	d3 e3                	shl    %cl,%ebx
  8021cb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021cf:	89 d0                	mov    %edx,%eax
  8021d1:	89 f9                	mov    %edi,%ecx
  8021d3:	d3 e8                	shr    %cl,%eax
  8021d5:	09 d8                	or     %ebx,%eax
  8021d7:	89 d3                	mov    %edx,%ebx
  8021d9:	89 e9                	mov    %ebp,%ecx
  8021db:	d3 e3                	shl    %cl,%ebx
  8021dd:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021e1:	89 f2                	mov    %esi,%edx
  8021e3:	f7 34 24             	divl   (%esp)
  8021e6:	89 d6                	mov    %edx,%esi
  8021e8:	f7 64 24 04          	mull   0x4(%esp)
  8021ec:	89 c3                	mov    %eax,%ebx
  8021ee:	89 d1                	mov    %edx,%ecx
  8021f0:	39 d6                	cmp    %edx,%esi
  8021f2:	72 7c                	jb     802270 <__umoddi3+0x12c>
  8021f4:	74 72                	je     802268 <__umoddi3+0x124>
  8021f6:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021fa:	29 da                	sub    %ebx,%edx
  8021fc:	19 ce                	sbb    %ecx,%esi
  8021fe:	89 f0                	mov    %esi,%eax
  802200:	89 f9                	mov    %edi,%ecx
  802202:	d3 e0                	shl    %cl,%eax
  802204:	89 e9                	mov    %ebp,%ecx
  802206:	d3 ea                	shr    %cl,%edx
  802208:	09 d0                	or     %edx,%eax
  80220a:	89 e9                	mov    %ebp,%ecx
  80220c:	d3 ee                	shr    %cl,%esi
  80220e:	89 f2                	mov    %esi,%edx
  802210:	83 c4 1c             	add    $0x1c,%esp
  802213:	5b                   	pop    %ebx
  802214:	5e                   	pop    %esi
  802215:	5f                   	pop    %edi
  802216:	5d                   	pop    %ebp
  802217:	c3                   	ret    
  802218:	89 fd                	mov    %edi,%ebp
  80221a:	85 ff                	test   %edi,%edi
  80221c:	75 0b                	jne    802229 <__umoddi3+0xe5>
  80221e:	b8 01 00 00 00       	mov    $0x1,%eax
  802223:	31 d2                	xor    %edx,%edx
  802225:	f7 f7                	div    %edi
  802227:	89 c5                	mov    %eax,%ebp
  802229:	89 f0                	mov    %esi,%eax
  80222b:	31 d2                	xor    %edx,%edx
  80222d:	f7 f5                	div    %ebp
  80222f:	89 c8                	mov    %ecx,%eax
  802231:	f7 f5                	div    %ebp
  802233:	e9 44 ff ff ff       	jmp    80217c <__umoddi3+0x38>
  802238:	89 c8                	mov    %ecx,%eax
  80223a:	89 f2                	mov    %esi,%edx
  80223c:	83 c4 1c             	add    $0x1c,%esp
  80223f:	5b                   	pop    %ebx
  802240:	5e                   	pop    %esi
  802241:	5f                   	pop    %edi
  802242:	5d                   	pop    %ebp
  802243:	c3                   	ret    
  802244:	39 f0                	cmp    %esi,%eax
  802246:	72 05                	jb     80224d <__umoddi3+0x109>
  802248:	39 0c 24             	cmp    %ecx,(%esp)
  80224b:	77 0c                	ja     802259 <__umoddi3+0x115>
  80224d:	89 f2                	mov    %esi,%edx
  80224f:	29 f9                	sub    %edi,%ecx
  802251:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802255:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802259:	8b 44 24 04          	mov    0x4(%esp),%eax
  80225d:	83 c4 1c             	add    $0x1c,%esp
  802260:	5b                   	pop    %ebx
  802261:	5e                   	pop    %esi
  802262:	5f                   	pop    %edi
  802263:	5d                   	pop    %ebp
  802264:	c3                   	ret    
  802265:	8d 76 00             	lea    0x0(%esi),%esi
  802268:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80226c:	73 88                	jae    8021f6 <__umoddi3+0xb2>
  80226e:	66 90                	xchg   %ax,%ax
  802270:	2b 44 24 04          	sub    0x4(%esp),%eax
  802274:	1b 14 24             	sbb    (%esp),%edx
  802277:	89 d1                	mov    %edx,%ecx
  802279:	89 c3                	mov    %eax,%ebx
  80227b:	e9 76 ff ff ff       	jmp    8021f6 <__umoddi3+0xb2>
