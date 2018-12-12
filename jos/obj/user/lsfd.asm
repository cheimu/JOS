
obj/user/lsfd.debug:     file format elf32-i386


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
  80002c:	e8 00 01 00 00       	call   800131 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <usage>:
#include <inc/lib.h>

void
usage(void)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: lsfd [-1]\n");
  800039:	68 60 22 80 00       	push   $0x802260
  80003e:	e8 e8 01 00 00       	call   80022b <cprintf>
	exit();
  800043:	e8 35 01 00 00       	call   80017d <exit>
}
  800048:	83 c4 10             	add    $0x10,%esp
  80004b:	c9                   	leave  
  80004c:	c3                   	ret    

0080004d <umain>:

void
umain(int argc, char **argv)
{
  80004d:	55                   	push   %ebp
  80004e:	89 e5                	mov    %esp,%ebp
  800050:	57                   	push   %edi
  800051:	56                   	push   %esi
  800052:	53                   	push   %ebx
  800053:	81 ec b0 00 00 00    	sub    $0xb0,%esp
	int i, usefprint = 0;
	struct Stat st;
	struct Argstate args;

	argstart(&argc, argv, &args);
  800059:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80005f:	50                   	push   %eax
  800060:	ff 75 0c             	pushl  0xc(%ebp)
  800063:	8d 45 08             	lea    0x8(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	e8 31 0e 00 00       	call   800e9d <argstart>
	while ((i = argnext(&args)) >= 0)
  80006c:	83 c4 10             	add    $0x10,%esp
	int i, usefprint = 0;
  80006f:	be 00 00 00 00       	mov    $0x0,%esi
	while ((i = argnext(&args)) >= 0)
  800074:	8d 9d 4c ff ff ff    	lea    -0xb4(%ebp),%ebx
		if (i == '1')
			usefprint = 1;
  80007a:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((i = argnext(&args)) >= 0)
  80007f:	83 ec 0c             	sub    $0xc,%esp
  800082:	53                   	push   %ebx
  800083:	e8 4e 0e 00 00       	call   800ed6 <argnext>
  800088:	83 c4 10             	add    $0x10,%esp
  80008b:	85 c0                	test   %eax,%eax
  80008d:	78 10                	js     80009f <umain+0x52>
		if (i == '1')
  80008f:	83 f8 31             	cmp    $0x31,%eax
  800092:	75 04                	jne    800098 <umain+0x4b>
			usefprint = 1;
  800094:	89 fe                	mov    %edi,%esi
  800096:	eb e7                	jmp    80007f <umain+0x32>
		else
			usage();
  800098:	e8 96 ff ff ff       	call   800033 <usage>
  80009d:	eb e0                	jmp    80007f <umain+0x32>
  80009f:	bb 00 00 00 00       	mov    $0x0,%ebx

	for (i = 0; i < 32; i++)
		if (fstat(i, &st) >= 0) {
  8000a4:	8d bd 5c ff ff ff    	lea    -0xa4(%ebp),%edi
  8000aa:	eb 35                	jmp    8000e1 <umain+0x94>
			if (usefprint)
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
					i, st.st_name, FTYPE_ISDIR(st.st_type),
					st.st_size, st.st_dev->dev_name);
			else
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000ac:	83 ec 08             	sub    $0x8,%esp
  8000af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b2:	ff 70 04             	pushl  0x4(%eax)
  8000b5:	ff 75 dc             	pushl  -0x24(%ebp)
					i, st.st_name, FTYPE_ISDIR(st.st_type),
  8000b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000bb:	25 00 f0 00 00       	and    $0xf000,%eax
				cprintf("fd %d: name %s isdir %d size %d dev %s\n",
  8000c0:	3d 00 40 00 00       	cmp    $0x4000,%eax
  8000c5:	0f 94 c0             	sete   %al
  8000c8:	0f b6 c0             	movzbl %al,%eax
  8000cb:	50                   	push   %eax
  8000cc:	57                   	push   %edi
  8000cd:	53                   	push   %ebx
  8000ce:	68 74 22 80 00       	push   $0x802274
  8000d3:	e8 53 01 00 00       	call   80022b <cprintf>
  8000d8:	83 c4 20             	add    $0x20,%esp
	for (i = 0; i < 32; i++)
  8000db:	43                   	inc    %ebx
  8000dc:	83 fb 20             	cmp    $0x20,%ebx
  8000df:	74 48                	je     800129 <umain+0xdc>
		if (fstat(i, &st) >= 0) {
  8000e1:	83 ec 08             	sub    $0x8,%esp
  8000e4:	57                   	push   %edi
  8000e5:	53                   	push   %ebx
  8000e6:	e8 e6 13 00 00       	call   8014d1 <fstat>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	85 c0                	test   %eax,%eax
  8000f0:	78 e9                	js     8000db <umain+0x8e>
			if (usefprint)
  8000f2:	85 f6                	test   %esi,%esi
  8000f4:	74 b6                	je     8000ac <umain+0x5f>
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000fc:	ff 70 04             	pushl  0x4(%eax)
  8000ff:	ff 75 dc             	pushl  -0x24(%ebp)
					i, st.st_name, FTYPE_ISDIR(st.st_type),
  800102:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800105:	25 00 f0 00 00       	and    $0xf000,%eax
				fprintf(1, "fd %d: name %s isdir %d size %d dev %s\n",
  80010a:	3d 00 40 00 00       	cmp    $0x4000,%eax
  80010f:	0f 94 c0             	sete   %al
  800112:	0f b6 c0             	movzbl %al,%eax
  800115:	50                   	push   %eax
  800116:	57                   	push   %edi
  800117:	53                   	push   %ebx
  800118:	68 74 22 80 00       	push   $0x802274
  80011d:	6a 01                	push   $0x1
  80011f:	e8 f2 17 00 00       	call   801916 <fprintf>
  800124:	83 c4 20             	add    $0x20,%esp
  800127:	eb b2                	jmp    8000db <umain+0x8e>
					st.st_size, st.st_dev->dev_name);
		}
}
  800129:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012c:	5b                   	pop    %ebx
  80012d:	5e                   	pop    %esi
  80012e:	5f                   	pop    %edi
  80012f:	5d                   	pop    %ebp
  800130:	c3                   	ret    

00800131 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800131:	55                   	push   %ebp
  800132:	89 e5                	mov    %esp,%ebp
  800134:	56                   	push   %esi
  800135:	53                   	push   %ebx
  800136:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800139:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80013c:	e8 88 0a 00 00       	call   800bc9 <sys_getenvid>
  800141:	25 ff 03 00 00       	and    $0x3ff,%eax
  800146:	89 c2                	mov    %eax,%edx
  800148:	c1 e2 05             	shl    $0x5,%edx
  80014b:	29 c2                	sub    %eax,%edx
  80014d:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800154:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800159:	85 db                	test   %ebx,%ebx
  80015b:	7e 07                	jle    800164 <libmain+0x33>
		binaryname = argv[0];
  80015d:	8b 06                	mov    (%esi),%eax
  80015f:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800164:	83 ec 08             	sub    $0x8,%esp
  800167:	56                   	push   %esi
  800168:	53                   	push   %ebx
  800169:	e8 df fe ff ff       	call   80004d <umain>

	// exit gracefully
	exit();
  80016e:	e8 0a 00 00 00       	call   80017d <exit>
}
  800173:	83 c4 10             	add    $0x10,%esp
  800176:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800179:	5b                   	pop    %ebx
  80017a:	5e                   	pop    %esi
  80017b:	5d                   	pop    %ebp
  80017c:	c3                   	ret    

0080017d <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80017d:	55                   	push   %ebp
  80017e:	89 e5                	mov    %esp,%ebp
  800180:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800183:	e8 42 10 00 00       	call   8011ca <close_all>
	sys_env_destroy(0);
  800188:	83 ec 0c             	sub    $0xc,%esp
  80018b:	6a 00                	push   $0x0
  80018d:	e8 f6 09 00 00       	call   800b88 <sys_env_destroy>
}
  800192:	83 c4 10             	add    $0x10,%esp
  800195:	c9                   	leave  
  800196:	c3                   	ret    

00800197 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800197:	55                   	push   %ebp
  800198:	89 e5                	mov    %esp,%ebp
  80019a:	53                   	push   %ebx
  80019b:	83 ec 04             	sub    $0x4,%esp
  80019e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8001a1:	8b 13                	mov    (%ebx),%edx
  8001a3:	8d 42 01             	lea    0x1(%edx),%eax
  8001a6:	89 03                	mov    %eax,(%ebx)
  8001a8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8001ab:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8001af:	3d ff 00 00 00       	cmp    $0xff,%eax
  8001b4:	74 08                	je     8001be <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8001b6:	ff 43 04             	incl   0x4(%ebx)
}
  8001b9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8001bc:	c9                   	leave  
  8001bd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8001be:	83 ec 08             	sub    $0x8,%esp
  8001c1:	68 ff 00 00 00       	push   $0xff
  8001c6:	8d 43 08             	lea    0x8(%ebx),%eax
  8001c9:	50                   	push   %eax
  8001ca:	e8 7c 09 00 00       	call   800b4b <sys_cputs>
		b->idx = 0;
  8001cf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	eb dc                	jmp    8001b6 <putch+0x1f>

008001da <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8001da:	55                   	push   %ebp
  8001db:	89 e5                	mov    %esp,%ebp
  8001dd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8001e3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8001ea:	00 00 00 
	b.cnt = 0;
  8001ed:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8001f4:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8001f7:	ff 75 0c             	pushl  0xc(%ebp)
  8001fa:	ff 75 08             	pushl  0x8(%ebp)
  8001fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	68 97 01 80 00       	push   $0x800197
  800209:	e8 17 01 00 00       	call   800325 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80020e:	83 c4 08             	add    $0x8,%esp
  800211:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800217:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80021d:	50                   	push   %eax
  80021e:	e8 28 09 00 00       	call   800b4b <sys_cputs>

	return b.cnt;
}
  800223:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800231:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800234:	50                   	push   %eax
  800235:	ff 75 08             	pushl  0x8(%ebp)
  800238:	e8 9d ff ff ff       	call   8001da <vcprintf>
	va_end(ap);

	return cnt;
}
  80023d:	c9                   	leave  
  80023e:	c3                   	ret    

0080023f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80023f:	55                   	push   %ebp
  800240:	89 e5                	mov    %esp,%ebp
  800242:	57                   	push   %edi
  800243:	56                   	push   %esi
  800244:	53                   	push   %ebx
  800245:	83 ec 1c             	sub    $0x1c,%esp
  800248:	89 c7                	mov    %eax,%edi
  80024a:	89 d6                	mov    %edx,%esi
  80024c:	8b 45 08             	mov    0x8(%ebp),%eax
  80024f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800252:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800255:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800258:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80025b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800260:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800263:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800266:	39 d3                	cmp    %edx,%ebx
  800268:	72 05                	jb     80026f <printnum+0x30>
  80026a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80026d:	77 78                	ja     8002e7 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	ff 75 18             	pushl  0x18(%ebp)
  800275:	8b 45 14             	mov    0x14(%ebp),%eax
  800278:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80027b:	53                   	push   %ebx
  80027c:	ff 75 10             	pushl  0x10(%ebp)
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	ff 75 e4             	pushl  -0x1c(%ebp)
  800285:	ff 75 e0             	pushl  -0x20(%ebp)
  800288:	ff 75 dc             	pushl  -0x24(%ebp)
  80028b:	ff 75 d8             	pushl  -0x28(%ebp)
  80028e:	e8 6d 1d 00 00       	call   802000 <__udivdi3>
  800293:	83 c4 18             	add    $0x18,%esp
  800296:	52                   	push   %edx
  800297:	50                   	push   %eax
  800298:	89 f2                	mov    %esi,%edx
  80029a:	89 f8                	mov    %edi,%eax
  80029c:	e8 9e ff ff ff       	call   80023f <printnum>
  8002a1:	83 c4 20             	add    $0x20,%esp
  8002a4:	eb 11                	jmp    8002b7 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8002a6:	83 ec 08             	sub    $0x8,%esp
  8002a9:	56                   	push   %esi
  8002aa:	ff 75 18             	pushl  0x18(%ebp)
  8002ad:	ff d7                	call   *%edi
  8002af:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8002b2:	4b                   	dec    %ebx
  8002b3:	85 db                	test   %ebx,%ebx
  8002b5:	7f ef                	jg     8002a6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8002b7:	83 ec 08             	sub    $0x8,%esp
  8002ba:	56                   	push   %esi
  8002bb:	83 ec 04             	sub    $0x4,%esp
  8002be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8002c1:	ff 75 e0             	pushl  -0x20(%ebp)
  8002c4:	ff 75 dc             	pushl  -0x24(%ebp)
  8002c7:	ff 75 d8             	pushl  -0x28(%ebp)
  8002ca:	e8 41 1e 00 00       	call   802110 <__umoddi3>
  8002cf:	83 c4 14             	add    $0x14,%esp
  8002d2:	0f be 80 a6 22 80 00 	movsbl 0x8022a6(%eax),%eax
  8002d9:	50                   	push   %eax
  8002da:	ff d7                	call   *%edi
}
  8002dc:	83 c4 10             	add    $0x10,%esp
  8002df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e2:	5b                   	pop    %ebx
  8002e3:	5e                   	pop    %esi
  8002e4:	5f                   	pop    %edi
  8002e5:	5d                   	pop    %ebp
  8002e6:	c3                   	ret    
  8002e7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002ea:	eb c6                	jmp    8002b2 <printnum+0x73>

008002ec <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002f2:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002f5:	8b 10                	mov    (%eax),%edx
  8002f7:	3b 50 04             	cmp    0x4(%eax),%edx
  8002fa:	73 0a                	jae    800306 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002fc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002ff:	89 08                	mov    %ecx,(%eax)
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	88 02                	mov    %al,(%edx)
}
  800306:	5d                   	pop    %ebp
  800307:	c3                   	ret    

00800308 <printfmt>:
{
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80030e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800311:	50                   	push   %eax
  800312:	ff 75 10             	pushl  0x10(%ebp)
  800315:	ff 75 0c             	pushl  0xc(%ebp)
  800318:	ff 75 08             	pushl  0x8(%ebp)
  80031b:	e8 05 00 00 00       	call   800325 <vprintfmt>
}
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	c9                   	leave  
  800324:	c3                   	ret    

00800325 <vprintfmt>:
{
  800325:	55                   	push   %ebp
  800326:	89 e5                	mov    %esp,%ebp
  800328:	57                   	push   %edi
  800329:	56                   	push   %esi
  80032a:	53                   	push   %ebx
  80032b:	83 ec 2c             	sub    $0x2c,%esp
  80032e:	8b 75 08             	mov    0x8(%ebp),%esi
  800331:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800334:	8b 7d 10             	mov    0x10(%ebp),%edi
  800337:	e9 ae 03 00 00       	jmp    8006ea <vprintfmt+0x3c5>
  80033c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800340:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800347:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80034e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800355:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80035a:	8d 47 01             	lea    0x1(%edi),%eax
  80035d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800360:	8a 17                	mov    (%edi),%dl
  800362:	8d 42 dd             	lea    -0x23(%edx),%eax
  800365:	3c 55                	cmp    $0x55,%al
  800367:	0f 87 fe 03 00 00    	ja     80076b <vprintfmt+0x446>
  80036d:	0f b6 c0             	movzbl %al,%eax
  800370:	ff 24 85 e0 23 80 00 	jmp    *0x8023e0(,%eax,4)
  800377:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80037a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80037e:	eb da                	jmp    80035a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800383:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800387:	eb d1                	jmp    80035a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800389:	0f b6 d2             	movzbl %dl,%edx
  80038c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80038f:	b8 00 00 00 00       	mov    $0x0,%eax
  800394:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800397:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80039a:	01 c0                	add    %eax,%eax
  80039c:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8003a0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8003a3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8003a6:	83 f9 09             	cmp    $0x9,%ecx
  8003a9:	77 52                	ja     8003fd <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8003ab:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8003ac:	eb e9                	jmp    800397 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8003ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b1:	8b 00                	mov    (%eax),%eax
  8003b3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b9:	8d 40 04             	lea    0x4(%eax),%eax
  8003bc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8003bf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8003c2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003c6:	79 92                	jns    80035a <vprintfmt+0x35>
				width = precision, precision = -1;
  8003c8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003ce:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003d5:	eb 83                	jmp    80035a <vprintfmt+0x35>
  8003d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003db:	78 08                	js     8003e5 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003e0:	e9 75 ff ff ff       	jmp    80035a <vprintfmt+0x35>
  8003e5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003ec:	eb ef                	jmp    8003dd <vprintfmt+0xb8>
  8003ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003f1:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003f8:	e9 5d ff ff ff       	jmp    80035a <vprintfmt+0x35>
  8003fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800400:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800403:	eb bd                	jmp    8003c2 <vprintfmt+0x9d>
			lflag++;
  800405:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800406:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800409:	e9 4c ff ff ff       	jmp    80035a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80040e:	8b 45 14             	mov    0x14(%ebp),%eax
  800411:	8d 78 04             	lea    0x4(%eax),%edi
  800414:	83 ec 08             	sub    $0x8,%esp
  800417:	53                   	push   %ebx
  800418:	ff 30                	pushl  (%eax)
  80041a:	ff d6                	call   *%esi
			break;
  80041c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80041f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800422:	e9 c0 02 00 00       	jmp    8006e7 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800427:	8b 45 14             	mov    0x14(%ebp),%eax
  80042a:	8d 78 04             	lea    0x4(%eax),%edi
  80042d:	8b 00                	mov    (%eax),%eax
  80042f:	85 c0                	test   %eax,%eax
  800431:	78 2a                	js     80045d <vprintfmt+0x138>
  800433:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800435:	83 f8 0f             	cmp    $0xf,%eax
  800438:	7f 27                	jg     800461 <vprintfmt+0x13c>
  80043a:	8b 04 85 40 25 80 00 	mov    0x802540(,%eax,4),%eax
  800441:	85 c0                	test   %eax,%eax
  800443:	74 1c                	je     800461 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800445:	50                   	push   %eax
  800446:	68 71 26 80 00       	push   $0x802671
  80044b:	53                   	push   %ebx
  80044c:	56                   	push   %esi
  80044d:	e8 b6 fe ff ff       	call   800308 <printfmt>
  800452:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800455:	89 7d 14             	mov    %edi,0x14(%ebp)
  800458:	e9 8a 02 00 00       	jmp    8006e7 <vprintfmt+0x3c2>
  80045d:	f7 d8                	neg    %eax
  80045f:	eb d2                	jmp    800433 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800461:	52                   	push   %edx
  800462:	68 be 22 80 00       	push   $0x8022be
  800467:	53                   	push   %ebx
  800468:	56                   	push   %esi
  800469:	e8 9a fe ff ff       	call   800308 <printfmt>
  80046e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800471:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800474:	e9 6e 02 00 00       	jmp    8006e7 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800479:	8b 45 14             	mov    0x14(%ebp),%eax
  80047c:	83 c0 04             	add    $0x4,%eax
  80047f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800482:	8b 45 14             	mov    0x14(%ebp),%eax
  800485:	8b 38                	mov    (%eax),%edi
  800487:	85 ff                	test   %edi,%edi
  800489:	74 39                	je     8004c4 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80048b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80048f:	0f 8e a9 00 00 00    	jle    80053e <vprintfmt+0x219>
  800495:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800499:	0f 84 a7 00 00 00    	je     800546 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80049f:	83 ec 08             	sub    $0x8,%esp
  8004a2:	ff 75 d0             	pushl  -0x30(%ebp)
  8004a5:	57                   	push   %edi
  8004a6:	e8 6b 03 00 00       	call   800816 <strnlen>
  8004ab:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8004ae:	29 c1                	sub    %eax,%ecx
  8004b0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8004b3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8004b6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8004ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004bd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8004c0:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004c2:	eb 14                	jmp    8004d8 <vprintfmt+0x1b3>
				p = "(null)";
  8004c4:	bf b7 22 80 00       	mov    $0x8022b7,%edi
  8004c9:	eb c0                	jmp    80048b <vprintfmt+0x166>
					putch(padc, putdat);
  8004cb:	83 ec 08             	sub    $0x8,%esp
  8004ce:	53                   	push   %ebx
  8004cf:	ff 75 e0             	pushl  -0x20(%ebp)
  8004d2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004d4:	4f                   	dec    %edi
  8004d5:	83 c4 10             	add    $0x10,%esp
  8004d8:	85 ff                	test   %edi,%edi
  8004da:	7f ef                	jg     8004cb <vprintfmt+0x1a6>
  8004dc:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004df:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004e2:	89 c8                	mov    %ecx,%eax
  8004e4:	85 c9                	test   %ecx,%ecx
  8004e6:	78 10                	js     8004f8 <vprintfmt+0x1d3>
  8004e8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004eb:	29 c1                	sub    %eax,%ecx
  8004ed:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004f0:	89 75 08             	mov    %esi,0x8(%ebp)
  8004f3:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004f6:	eb 15                	jmp    80050d <vprintfmt+0x1e8>
  8004f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8004fd:	eb e9                	jmp    8004e8 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004ff:	83 ec 08             	sub    $0x8,%esp
  800502:	53                   	push   %ebx
  800503:	52                   	push   %edx
  800504:	ff 55 08             	call   *0x8(%ebp)
  800507:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80050a:	ff 4d e0             	decl   -0x20(%ebp)
  80050d:	47                   	inc    %edi
  80050e:	8a 47 ff             	mov    -0x1(%edi),%al
  800511:	0f be d0             	movsbl %al,%edx
  800514:	85 d2                	test   %edx,%edx
  800516:	74 59                	je     800571 <vprintfmt+0x24c>
  800518:	85 f6                	test   %esi,%esi
  80051a:	78 03                	js     80051f <vprintfmt+0x1fa>
  80051c:	4e                   	dec    %esi
  80051d:	78 2f                	js     80054e <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80051f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800523:	74 da                	je     8004ff <vprintfmt+0x1da>
  800525:	0f be c0             	movsbl %al,%eax
  800528:	83 e8 20             	sub    $0x20,%eax
  80052b:	83 f8 5e             	cmp    $0x5e,%eax
  80052e:	76 cf                	jbe    8004ff <vprintfmt+0x1da>
					putch('?', putdat);
  800530:	83 ec 08             	sub    $0x8,%esp
  800533:	53                   	push   %ebx
  800534:	6a 3f                	push   $0x3f
  800536:	ff 55 08             	call   *0x8(%ebp)
  800539:	83 c4 10             	add    $0x10,%esp
  80053c:	eb cc                	jmp    80050a <vprintfmt+0x1e5>
  80053e:	89 75 08             	mov    %esi,0x8(%ebp)
  800541:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800544:	eb c7                	jmp    80050d <vprintfmt+0x1e8>
  800546:	89 75 08             	mov    %esi,0x8(%ebp)
  800549:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80054c:	eb bf                	jmp    80050d <vprintfmt+0x1e8>
  80054e:	8b 75 08             	mov    0x8(%ebp),%esi
  800551:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800554:	eb 0c                	jmp    800562 <vprintfmt+0x23d>
				putch(' ', putdat);
  800556:	83 ec 08             	sub    $0x8,%esp
  800559:	53                   	push   %ebx
  80055a:	6a 20                	push   $0x20
  80055c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80055e:	4f                   	dec    %edi
  80055f:	83 c4 10             	add    $0x10,%esp
  800562:	85 ff                	test   %edi,%edi
  800564:	7f f0                	jg     800556 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800566:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800569:	89 45 14             	mov    %eax,0x14(%ebp)
  80056c:	e9 76 01 00 00       	jmp    8006e7 <vprintfmt+0x3c2>
  800571:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800574:	8b 75 08             	mov    0x8(%ebp),%esi
  800577:	eb e9                	jmp    800562 <vprintfmt+0x23d>
	if (lflag >= 2)
  800579:	83 f9 01             	cmp    $0x1,%ecx
  80057c:	7f 1f                	jg     80059d <vprintfmt+0x278>
	else if (lflag)
  80057e:	85 c9                	test   %ecx,%ecx
  800580:	75 48                	jne    8005ca <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800582:	8b 45 14             	mov    0x14(%ebp),%eax
  800585:	8b 00                	mov    (%eax),%eax
  800587:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80058a:	89 c1                	mov    %eax,%ecx
  80058c:	c1 f9 1f             	sar    $0x1f,%ecx
  80058f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800592:	8b 45 14             	mov    0x14(%ebp),%eax
  800595:	8d 40 04             	lea    0x4(%eax),%eax
  800598:	89 45 14             	mov    %eax,0x14(%ebp)
  80059b:	eb 17                	jmp    8005b4 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 50 04             	mov    0x4(%eax),%edx
  8005a3:	8b 00                	mov    (%eax),%eax
  8005a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8005ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ae:	8d 40 08             	lea    0x8(%eax),%eax
  8005b1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8005b4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005b7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8005ba:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8005be:	78 25                	js     8005e5 <vprintfmt+0x2c0>
			base = 10;
  8005c0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005c5:	e9 03 01 00 00       	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8005ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8005cd:	8b 00                	mov    (%eax),%eax
  8005cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005d2:	89 c1                	mov    %eax,%ecx
  8005d4:	c1 f9 1f             	sar    $0x1f,%ecx
  8005d7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005da:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dd:	8d 40 04             	lea    0x4(%eax),%eax
  8005e0:	89 45 14             	mov    %eax,0x14(%ebp)
  8005e3:	eb cf                	jmp    8005b4 <vprintfmt+0x28f>
				putch('-', putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	53                   	push   %ebx
  8005e9:	6a 2d                	push   $0x2d
  8005eb:	ff d6                	call   *%esi
				num = -(long long) num;
  8005ed:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005f0:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005f3:	f7 da                	neg    %edx
  8005f5:	83 d1 00             	adc    $0x0,%ecx
  8005f8:	f7 d9                	neg    %ecx
  8005fa:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005fd:	b8 0a 00 00 00       	mov    $0xa,%eax
  800602:	e9 c6 00 00 00       	jmp    8006cd <vprintfmt+0x3a8>
	if (lflag >= 2)
  800607:	83 f9 01             	cmp    $0x1,%ecx
  80060a:	7f 1e                	jg     80062a <vprintfmt+0x305>
	else if (lflag)
  80060c:	85 c9                	test   %ecx,%ecx
  80060e:	75 32                	jne    800642 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800610:	8b 45 14             	mov    0x14(%ebp),%eax
  800613:	8b 10                	mov    (%eax),%edx
  800615:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061a:	8d 40 04             	lea    0x4(%eax),%eax
  80061d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800620:	b8 0a 00 00 00       	mov    $0xa,%eax
  800625:	e9 a3 00 00 00       	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80062a:	8b 45 14             	mov    0x14(%ebp),%eax
  80062d:	8b 10                	mov    (%eax),%edx
  80062f:	8b 48 04             	mov    0x4(%eax),%ecx
  800632:	8d 40 08             	lea    0x8(%eax),%eax
  800635:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800638:	b8 0a 00 00 00       	mov    $0xa,%eax
  80063d:	e9 8b 00 00 00       	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800642:	8b 45 14             	mov    0x14(%ebp),%eax
  800645:	8b 10                	mov    (%eax),%edx
  800647:	b9 00 00 00 00       	mov    $0x0,%ecx
  80064c:	8d 40 04             	lea    0x4(%eax),%eax
  80064f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800652:	b8 0a 00 00 00       	mov    $0xa,%eax
  800657:	eb 74                	jmp    8006cd <vprintfmt+0x3a8>
	if (lflag >= 2)
  800659:	83 f9 01             	cmp    $0x1,%ecx
  80065c:	7f 1b                	jg     800679 <vprintfmt+0x354>
	else if (lflag)
  80065e:	85 c9                	test   %ecx,%ecx
  800660:	75 2c                	jne    80068e <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800662:	8b 45 14             	mov    0x14(%ebp),%eax
  800665:	8b 10                	mov    (%eax),%edx
  800667:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066c:	8d 40 04             	lea    0x4(%eax),%eax
  80066f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800672:	b8 08 00 00 00       	mov    $0x8,%eax
  800677:	eb 54                	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800679:	8b 45 14             	mov    0x14(%ebp),%eax
  80067c:	8b 10                	mov    (%eax),%edx
  80067e:	8b 48 04             	mov    0x4(%eax),%ecx
  800681:	8d 40 08             	lea    0x8(%eax),%eax
  800684:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800687:	b8 08 00 00 00       	mov    $0x8,%eax
  80068c:	eb 3f                	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80068e:	8b 45 14             	mov    0x14(%ebp),%eax
  800691:	8b 10                	mov    (%eax),%edx
  800693:	b9 00 00 00 00       	mov    $0x0,%ecx
  800698:	8d 40 04             	lea    0x4(%eax),%eax
  80069b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80069e:	b8 08 00 00 00       	mov    $0x8,%eax
  8006a3:	eb 28                	jmp    8006cd <vprintfmt+0x3a8>
			putch('0', putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	53                   	push   %ebx
  8006a9:	6a 30                	push   $0x30
  8006ab:	ff d6                	call   *%esi
			putch('x', putdat);
  8006ad:	83 c4 08             	add    $0x8,%esp
  8006b0:	53                   	push   %ebx
  8006b1:	6a 78                	push   $0x78
  8006b3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	8b 10                	mov    (%eax),%edx
  8006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8006bf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8006c2:	8d 40 04             	lea    0x4(%eax),%eax
  8006c5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006c8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006cd:	83 ec 0c             	sub    $0xc,%esp
  8006d0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006d4:	57                   	push   %edi
  8006d5:	ff 75 e0             	pushl  -0x20(%ebp)
  8006d8:	50                   	push   %eax
  8006d9:	51                   	push   %ecx
  8006da:	52                   	push   %edx
  8006db:	89 da                	mov    %ebx,%edx
  8006dd:	89 f0                	mov    %esi,%eax
  8006df:	e8 5b fb ff ff       	call   80023f <printnum>
			break;
  8006e4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006e7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006ea:	47                   	inc    %edi
  8006eb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006ef:	83 f8 25             	cmp    $0x25,%eax
  8006f2:	0f 84 44 fc ff ff    	je     80033c <vprintfmt+0x17>
			if (ch == '\0')
  8006f8:	85 c0                	test   %eax,%eax
  8006fa:	0f 84 89 00 00 00    	je     800789 <vprintfmt+0x464>
			putch(ch, putdat);
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	53                   	push   %ebx
  800704:	50                   	push   %eax
  800705:	ff d6                	call   *%esi
  800707:	83 c4 10             	add    $0x10,%esp
  80070a:	eb de                	jmp    8006ea <vprintfmt+0x3c5>
	if (lflag >= 2)
  80070c:	83 f9 01             	cmp    $0x1,%ecx
  80070f:	7f 1b                	jg     80072c <vprintfmt+0x407>
	else if (lflag)
  800711:	85 c9                	test   %ecx,%ecx
  800713:	75 2c                	jne    800741 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800715:	8b 45 14             	mov    0x14(%ebp),%eax
  800718:	8b 10                	mov    (%eax),%edx
  80071a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071f:	8d 40 04             	lea    0x4(%eax),%eax
  800722:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800725:	b8 10 00 00 00       	mov    $0x10,%eax
  80072a:	eb a1                	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80072c:	8b 45 14             	mov    0x14(%ebp),%eax
  80072f:	8b 10                	mov    (%eax),%edx
  800731:	8b 48 04             	mov    0x4(%eax),%ecx
  800734:	8d 40 08             	lea    0x8(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80073a:	b8 10 00 00 00       	mov    $0x10,%eax
  80073f:	eb 8c                	jmp    8006cd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800741:	8b 45 14             	mov    0x14(%ebp),%eax
  800744:	8b 10                	mov    (%eax),%edx
  800746:	b9 00 00 00 00       	mov    $0x0,%ecx
  80074b:	8d 40 04             	lea    0x4(%eax),%eax
  80074e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800751:	b8 10 00 00 00       	mov    $0x10,%eax
  800756:	e9 72 ff ff ff       	jmp    8006cd <vprintfmt+0x3a8>
			putch(ch, putdat);
  80075b:	83 ec 08             	sub    $0x8,%esp
  80075e:	53                   	push   %ebx
  80075f:	6a 25                	push   $0x25
  800761:	ff d6                	call   *%esi
			break;
  800763:	83 c4 10             	add    $0x10,%esp
  800766:	e9 7c ff ff ff       	jmp    8006e7 <vprintfmt+0x3c2>
			putch('%', putdat);
  80076b:	83 ec 08             	sub    $0x8,%esp
  80076e:	53                   	push   %ebx
  80076f:	6a 25                	push   $0x25
  800771:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800773:	83 c4 10             	add    $0x10,%esp
  800776:	89 f8                	mov    %edi,%eax
  800778:	eb 01                	jmp    80077b <vprintfmt+0x456>
  80077a:	48                   	dec    %eax
  80077b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80077f:	75 f9                	jne    80077a <vprintfmt+0x455>
  800781:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800784:	e9 5e ff ff ff       	jmp    8006e7 <vprintfmt+0x3c2>
}
  800789:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80078c:	5b                   	pop    %ebx
  80078d:	5e                   	pop    %esi
  80078e:	5f                   	pop    %edi
  80078f:	5d                   	pop    %ebp
  800790:	c3                   	ret    

00800791 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800791:	55                   	push   %ebp
  800792:	89 e5                	mov    %esp,%ebp
  800794:	83 ec 18             	sub    $0x18,%esp
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80079d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8007a0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8007a4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8007a7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8007ae:	85 c0                	test   %eax,%eax
  8007b0:	74 26                	je     8007d8 <vsnprintf+0x47>
  8007b2:	85 d2                	test   %edx,%edx
  8007b4:	7e 29                	jle    8007df <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8007b6:	ff 75 14             	pushl  0x14(%ebp)
  8007b9:	ff 75 10             	pushl  0x10(%ebp)
  8007bc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	68 ec 02 80 00       	push   $0x8002ec
  8007c5:	e8 5b fb ff ff       	call   800325 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8007ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007cd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007d3:	83 c4 10             	add    $0x10,%esp
}
  8007d6:	c9                   	leave  
  8007d7:	c3                   	ret    
		return -E_INVAL;
  8007d8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007dd:	eb f7                	jmp    8007d6 <vsnprintf+0x45>
  8007df:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007e4:	eb f0                	jmp    8007d6 <vsnprintf+0x45>

008007e6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007e6:	55                   	push   %ebp
  8007e7:	89 e5                	mov    %esp,%ebp
  8007e9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007ec:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007ef:	50                   	push   %eax
  8007f0:	ff 75 10             	pushl  0x10(%ebp)
  8007f3:	ff 75 0c             	pushl  0xc(%ebp)
  8007f6:	ff 75 08             	pushl  0x8(%ebp)
  8007f9:	e8 93 ff ff ff       	call   800791 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007fe:	c9                   	leave  
  8007ff:	c3                   	ret    

00800800 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800800:	55                   	push   %ebp
  800801:	89 e5                	mov    %esp,%ebp
  800803:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800806:	b8 00 00 00 00       	mov    $0x0,%eax
  80080b:	eb 01                	jmp    80080e <strlen+0xe>
		n++;
  80080d:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80080e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800812:	75 f9                	jne    80080d <strlen+0xd>
	return n;
}
  800814:	5d                   	pop    %ebp
  800815:	c3                   	ret    

00800816 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800816:	55                   	push   %ebp
  800817:	89 e5                	mov    %esp,%ebp
  800819:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80081c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80081f:	b8 00 00 00 00       	mov    $0x0,%eax
  800824:	eb 01                	jmp    800827 <strnlen+0x11>
		n++;
  800826:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800827:	39 d0                	cmp    %edx,%eax
  800829:	74 06                	je     800831 <strnlen+0x1b>
  80082b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80082f:	75 f5                	jne    800826 <strnlen+0x10>
	return n;
}
  800831:	5d                   	pop    %ebp
  800832:	c3                   	ret    

00800833 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800833:	55                   	push   %ebp
  800834:	89 e5                	mov    %esp,%ebp
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80083d:	89 c2                	mov    %eax,%edx
  80083f:	42                   	inc    %edx
  800840:	41                   	inc    %ecx
  800841:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800844:	88 5a ff             	mov    %bl,-0x1(%edx)
  800847:	84 db                	test   %bl,%bl
  800849:	75 f4                	jne    80083f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80084b:	5b                   	pop    %ebx
  80084c:	5d                   	pop    %ebp
  80084d:	c3                   	ret    

0080084e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80084e:	55                   	push   %ebp
  80084f:	89 e5                	mov    %esp,%ebp
  800851:	53                   	push   %ebx
  800852:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800855:	53                   	push   %ebx
  800856:	e8 a5 ff ff ff       	call   800800 <strlen>
  80085b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80085e:	ff 75 0c             	pushl  0xc(%ebp)
  800861:	01 d8                	add    %ebx,%eax
  800863:	50                   	push   %eax
  800864:	e8 ca ff ff ff       	call   800833 <strcpy>
	return dst;
}
  800869:	89 d8                	mov    %ebx,%eax
  80086b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80086e:	c9                   	leave  
  80086f:	c3                   	ret    

00800870 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800870:	55                   	push   %ebp
  800871:	89 e5                	mov    %esp,%ebp
  800873:	56                   	push   %esi
  800874:	53                   	push   %ebx
  800875:	8b 75 08             	mov    0x8(%ebp),%esi
  800878:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80087b:	89 f3                	mov    %esi,%ebx
  80087d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800880:	89 f2                	mov    %esi,%edx
  800882:	eb 0c                	jmp    800890 <strncpy+0x20>
		*dst++ = *src;
  800884:	42                   	inc    %edx
  800885:	8a 01                	mov    (%ecx),%al
  800887:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80088a:	80 39 01             	cmpb   $0x1,(%ecx)
  80088d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800890:	39 da                	cmp    %ebx,%edx
  800892:	75 f0                	jne    800884 <strncpy+0x14>
	}
	return ret;
}
  800894:	89 f0                	mov    %esi,%eax
  800896:	5b                   	pop    %ebx
  800897:	5e                   	pop    %esi
  800898:	5d                   	pop    %ebp
  800899:	c3                   	ret    

0080089a <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80089a:	55                   	push   %ebp
  80089b:	89 e5                	mov    %esp,%ebp
  80089d:	56                   	push   %esi
  80089e:	53                   	push   %ebx
  80089f:	8b 75 08             	mov    0x8(%ebp),%esi
  8008a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008a5:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8008a8:	85 c0                	test   %eax,%eax
  8008aa:	74 20                	je     8008cc <strlcpy+0x32>
  8008ac:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8008b0:	89 f0                	mov    %esi,%eax
  8008b2:	eb 05                	jmp    8008b9 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8008b4:	40                   	inc    %eax
  8008b5:	42                   	inc    %edx
  8008b6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8008b9:	39 d8                	cmp    %ebx,%eax
  8008bb:	74 06                	je     8008c3 <strlcpy+0x29>
  8008bd:	8a 0a                	mov    (%edx),%cl
  8008bf:	84 c9                	test   %cl,%cl
  8008c1:	75 f1                	jne    8008b4 <strlcpy+0x1a>
		*dst = '\0';
  8008c3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8008c6:	29 f0                	sub    %esi,%eax
}
  8008c8:	5b                   	pop    %ebx
  8008c9:	5e                   	pop    %esi
  8008ca:	5d                   	pop    %ebp
  8008cb:	c3                   	ret    
  8008cc:	89 f0                	mov    %esi,%eax
  8008ce:	eb f6                	jmp    8008c6 <strlcpy+0x2c>

008008d0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008d0:	55                   	push   %ebp
  8008d1:	89 e5                	mov    %esp,%ebp
  8008d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008d6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008d9:	eb 02                	jmp    8008dd <strcmp+0xd>
		p++, q++;
  8008db:	41                   	inc    %ecx
  8008dc:	42                   	inc    %edx
	while (*p && *p == *q)
  8008dd:	8a 01                	mov    (%ecx),%al
  8008df:	84 c0                	test   %al,%al
  8008e1:	74 04                	je     8008e7 <strcmp+0x17>
  8008e3:	3a 02                	cmp    (%edx),%al
  8008e5:	74 f4                	je     8008db <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e7:	0f b6 c0             	movzbl %al,%eax
  8008ea:	0f b6 12             	movzbl (%edx),%edx
  8008ed:	29 d0                	sub    %edx,%eax
}
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	53                   	push   %ebx
  8008f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fb:	89 c3                	mov    %eax,%ebx
  8008fd:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800900:	eb 02                	jmp    800904 <strncmp+0x13>
		n--, p++, q++;
  800902:	40                   	inc    %eax
  800903:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800904:	39 d8                	cmp    %ebx,%eax
  800906:	74 15                	je     80091d <strncmp+0x2c>
  800908:	8a 08                	mov    (%eax),%cl
  80090a:	84 c9                	test   %cl,%cl
  80090c:	74 04                	je     800912 <strncmp+0x21>
  80090e:	3a 0a                	cmp    (%edx),%cl
  800910:	74 f0                	je     800902 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800912:	0f b6 00             	movzbl (%eax),%eax
  800915:	0f b6 12             	movzbl (%edx),%edx
  800918:	29 d0                	sub    %edx,%eax
}
  80091a:	5b                   	pop    %ebx
  80091b:	5d                   	pop    %ebp
  80091c:	c3                   	ret    
		return 0;
  80091d:	b8 00 00 00 00       	mov    $0x0,%eax
  800922:	eb f6                	jmp    80091a <strncmp+0x29>

00800924 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800924:	55                   	push   %ebp
  800925:	89 e5                	mov    %esp,%ebp
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80092d:	8a 10                	mov    (%eax),%dl
  80092f:	84 d2                	test   %dl,%dl
  800931:	74 07                	je     80093a <strchr+0x16>
		if (*s == c)
  800933:	38 ca                	cmp    %cl,%dl
  800935:	74 08                	je     80093f <strchr+0x1b>
	for (; *s; s++)
  800937:	40                   	inc    %eax
  800938:	eb f3                	jmp    80092d <strchr+0x9>
			return (char *) s;
	return 0;
  80093a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80094a:	8a 10                	mov    (%eax),%dl
  80094c:	84 d2                	test   %dl,%dl
  80094e:	74 07                	je     800957 <strfind+0x16>
		if (*s == c)
  800950:	38 ca                	cmp    %cl,%dl
  800952:	74 03                	je     800957 <strfind+0x16>
	for (; *s; s++)
  800954:	40                   	inc    %eax
  800955:	eb f3                	jmp    80094a <strfind+0x9>
			break;
	return (char *) s;
}
  800957:	5d                   	pop    %ebp
  800958:	c3                   	ret    

00800959 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800959:	55                   	push   %ebp
  80095a:	89 e5                	mov    %esp,%ebp
  80095c:	57                   	push   %edi
  80095d:	56                   	push   %esi
  80095e:	53                   	push   %ebx
  80095f:	8b 7d 08             	mov    0x8(%ebp),%edi
  800962:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800965:	85 c9                	test   %ecx,%ecx
  800967:	74 13                	je     80097c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800969:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80096f:	75 05                	jne    800976 <memset+0x1d>
  800971:	f6 c1 03             	test   $0x3,%cl
  800974:	74 0d                	je     800983 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800976:	8b 45 0c             	mov    0xc(%ebp),%eax
  800979:	fc                   	cld    
  80097a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80097c:	89 f8                	mov    %edi,%eax
  80097e:	5b                   	pop    %ebx
  80097f:	5e                   	pop    %esi
  800980:	5f                   	pop    %edi
  800981:	5d                   	pop    %ebp
  800982:	c3                   	ret    
		c &= 0xFF;
  800983:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800987:	89 d3                	mov    %edx,%ebx
  800989:	c1 e3 08             	shl    $0x8,%ebx
  80098c:	89 d0                	mov    %edx,%eax
  80098e:	c1 e0 18             	shl    $0x18,%eax
  800991:	89 d6                	mov    %edx,%esi
  800993:	c1 e6 10             	shl    $0x10,%esi
  800996:	09 f0                	or     %esi,%eax
  800998:	09 c2                	or     %eax,%edx
  80099a:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80099c:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80099f:	89 d0                	mov    %edx,%eax
  8009a1:	fc                   	cld    
  8009a2:	f3 ab                	rep stos %eax,%es:(%edi)
  8009a4:	eb d6                	jmp    80097c <memset+0x23>

008009a6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8009a6:	55                   	push   %ebp
  8009a7:	89 e5                	mov    %esp,%ebp
  8009a9:	57                   	push   %edi
  8009aa:	56                   	push   %esi
  8009ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ae:	8b 75 0c             	mov    0xc(%ebp),%esi
  8009b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8009b4:	39 c6                	cmp    %eax,%esi
  8009b6:	73 33                	jae    8009eb <memmove+0x45>
  8009b8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8009bb:	39 d0                	cmp    %edx,%eax
  8009bd:	73 2c                	jae    8009eb <memmove+0x45>
		s += n;
		d += n;
  8009bf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009c2:	89 d6                	mov    %edx,%esi
  8009c4:	09 fe                	or     %edi,%esi
  8009c6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8009cc:	75 13                	jne    8009e1 <memmove+0x3b>
  8009ce:	f6 c1 03             	test   $0x3,%cl
  8009d1:	75 0e                	jne    8009e1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009d3:	83 ef 04             	sub    $0x4,%edi
  8009d6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009d9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009dc:	fd                   	std    
  8009dd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009df:	eb 07                	jmp    8009e8 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009e1:	4f                   	dec    %edi
  8009e2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009e5:	fd                   	std    
  8009e6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009e8:	fc                   	cld    
  8009e9:	eb 13                	jmp    8009fe <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009eb:	89 f2                	mov    %esi,%edx
  8009ed:	09 c2                	or     %eax,%edx
  8009ef:	f6 c2 03             	test   $0x3,%dl
  8009f2:	75 05                	jne    8009f9 <memmove+0x53>
  8009f4:	f6 c1 03             	test   $0x3,%cl
  8009f7:	74 09                	je     800a02 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009f9:	89 c7                	mov    %eax,%edi
  8009fb:	fc                   	cld    
  8009fc:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009fe:	5e                   	pop    %esi
  8009ff:	5f                   	pop    %edi
  800a00:	5d                   	pop    %ebp
  800a01:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800a02:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800a05:	89 c7                	mov    %eax,%edi
  800a07:	fc                   	cld    
  800a08:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800a0a:	eb f2                	jmp    8009fe <memmove+0x58>

00800a0c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800a0c:	55                   	push   %ebp
  800a0d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800a0f:	ff 75 10             	pushl  0x10(%ebp)
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	ff 75 08             	pushl  0x8(%ebp)
  800a18:	e8 89 ff ff ff       	call   8009a6 <memmove>
}
  800a1d:	c9                   	leave  
  800a1e:	c3                   	ret    

00800a1f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
  800a22:	56                   	push   %esi
  800a23:	53                   	push   %ebx
  800a24:	8b 45 08             	mov    0x8(%ebp),%eax
  800a27:	89 c6                	mov    %eax,%esi
  800a29:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800a2c:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a2f:	39 f0                	cmp    %esi,%eax
  800a31:	74 16                	je     800a49 <memcmp+0x2a>
		if (*s1 != *s2)
  800a33:	8a 08                	mov    (%eax),%cl
  800a35:	8a 1a                	mov    (%edx),%bl
  800a37:	38 d9                	cmp    %bl,%cl
  800a39:	75 04                	jne    800a3f <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a3b:	40                   	inc    %eax
  800a3c:	42                   	inc    %edx
  800a3d:	eb f0                	jmp    800a2f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a3f:	0f b6 c1             	movzbl %cl,%eax
  800a42:	0f b6 db             	movzbl %bl,%ebx
  800a45:	29 d8                	sub    %ebx,%eax
  800a47:	eb 05                	jmp    800a4e <memcmp+0x2f>
	}

	return 0;
  800a49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a4e:	5b                   	pop    %ebx
  800a4f:	5e                   	pop    %esi
  800a50:	5d                   	pop    %ebp
  800a51:	c3                   	ret    

00800a52 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a52:	55                   	push   %ebp
  800a53:	89 e5                	mov    %esp,%ebp
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a5b:	89 c2                	mov    %eax,%edx
  800a5d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a60:	39 d0                	cmp    %edx,%eax
  800a62:	73 07                	jae    800a6b <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a64:	38 08                	cmp    %cl,(%eax)
  800a66:	74 03                	je     800a6b <memfind+0x19>
	for (; s < ends; s++)
  800a68:	40                   	inc    %eax
  800a69:	eb f5                	jmp    800a60 <memfind+0xe>
			break;
	return (void *) s;
}
  800a6b:	5d                   	pop    %ebp
  800a6c:	c3                   	ret    

00800a6d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a6d:	55                   	push   %ebp
  800a6e:	89 e5                	mov    %esp,%ebp
  800a70:	57                   	push   %edi
  800a71:	56                   	push   %esi
  800a72:	53                   	push   %ebx
  800a73:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a76:	eb 01                	jmp    800a79 <strtol+0xc>
		s++;
  800a78:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a79:	8a 01                	mov    (%ecx),%al
  800a7b:	3c 20                	cmp    $0x20,%al
  800a7d:	74 f9                	je     800a78 <strtol+0xb>
  800a7f:	3c 09                	cmp    $0x9,%al
  800a81:	74 f5                	je     800a78 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a83:	3c 2b                	cmp    $0x2b,%al
  800a85:	74 2b                	je     800ab2 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a87:	3c 2d                	cmp    $0x2d,%al
  800a89:	74 2f                	je     800aba <strtol+0x4d>
	int neg = 0;
  800a8b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a90:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a97:	75 12                	jne    800aab <strtol+0x3e>
  800a99:	80 39 30             	cmpb   $0x30,(%ecx)
  800a9c:	74 24                	je     800ac2 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aa2:	75 07                	jne    800aab <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800aa4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800aab:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab0:	eb 4e                	jmp    800b00 <strtol+0x93>
		s++;
  800ab2:	41                   	inc    %ecx
	int neg = 0;
  800ab3:	bf 00 00 00 00       	mov    $0x0,%edi
  800ab8:	eb d6                	jmp    800a90 <strtol+0x23>
		s++, neg = 1;
  800aba:	41                   	inc    %ecx
  800abb:	bf 01 00 00 00       	mov    $0x1,%edi
  800ac0:	eb ce                	jmp    800a90 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ac2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800ac6:	74 10                	je     800ad8 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	75 dd                	jne    800aab <strtol+0x3e>
		s++, base = 8;
  800ace:	41                   	inc    %ecx
  800acf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ad6:	eb d3                	jmp    800aab <strtol+0x3e>
		s += 2, base = 16;
  800ad8:	83 c1 02             	add    $0x2,%ecx
  800adb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ae2:	eb c7                	jmp    800aab <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ae4:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ae7:	89 f3                	mov    %esi,%ebx
  800ae9:	80 fb 19             	cmp    $0x19,%bl
  800aec:	77 24                	ja     800b12 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800aee:	0f be d2             	movsbl %dl,%edx
  800af1:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800af4:	3b 55 10             	cmp    0x10(%ebp),%edx
  800af7:	7d 2b                	jge    800b24 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800af9:	41                   	inc    %ecx
  800afa:	0f af 45 10          	imul   0x10(%ebp),%eax
  800afe:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800b00:	8a 11                	mov    (%ecx),%dl
  800b02:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800b05:	80 fb 09             	cmp    $0x9,%bl
  800b08:	77 da                	ja     800ae4 <strtol+0x77>
			dig = *s - '0';
  800b0a:	0f be d2             	movsbl %dl,%edx
  800b0d:	83 ea 30             	sub    $0x30,%edx
  800b10:	eb e2                	jmp    800af4 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800b12:	8d 72 bf             	lea    -0x41(%edx),%esi
  800b15:	89 f3                	mov    %esi,%ebx
  800b17:	80 fb 19             	cmp    $0x19,%bl
  800b1a:	77 08                	ja     800b24 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800b1c:	0f be d2             	movsbl %dl,%edx
  800b1f:	83 ea 37             	sub    $0x37,%edx
  800b22:	eb d0                	jmp    800af4 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800b24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b28:	74 05                	je     800b2f <strtol+0xc2>
		*endptr = (char *) s;
  800b2a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b2d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b2f:	85 ff                	test   %edi,%edi
  800b31:	74 02                	je     800b35 <strtol+0xc8>
  800b33:	f7 d8                	neg    %eax
}
  800b35:	5b                   	pop    %ebx
  800b36:	5e                   	pop    %esi
  800b37:	5f                   	pop    %edi
  800b38:	5d                   	pop    %ebp
  800b39:	c3                   	ret    

00800b3a <atoi>:

int
atoi(const char *s)
{
  800b3a:	55                   	push   %ebp
  800b3b:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b3d:	6a 0a                	push   $0xa
  800b3f:	6a 00                	push   $0x0
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 24 ff ff ff       	call   800a6d <strtol>
}
  800b49:	c9                   	leave  
  800b4a:	c3                   	ret    

00800b4b <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	57                   	push   %edi
  800b4f:	56                   	push   %esi
  800b50:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b51:	b8 00 00 00 00       	mov    $0x0,%eax
  800b56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b59:	8b 55 08             	mov    0x8(%ebp),%edx
  800b5c:	89 c3                	mov    %eax,%ebx
  800b5e:	89 c7                	mov    %eax,%edi
  800b60:	89 c6                	mov    %eax,%esi
  800b62:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b64:	5b                   	pop    %ebx
  800b65:	5e                   	pop    %esi
  800b66:	5f                   	pop    %edi
  800b67:	5d                   	pop    %ebp
  800b68:	c3                   	ret    

00800b69 <sys_cgetc>:

int
sys_cgetc(void)
{
  800b69:	55                   	push   %ebp
  800b6a:	89 e5                	mov    %esp,%ebp
  800b6c:	57                   	push   %edi
  800b6d:	56                   	push   %esi
  800b6e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b6f:	ba 00 00 00 00       	mov    $0x0,%edx
  800b74:	b8 01 00 00 00       	mov    $0x1,%eax
  800b79:	89 d1                	mov    %edx,%ecx
  800b7b:	89 d3                	mov    %edx,%ebx
  800b7d:	89 d7                	mov    %edx,%edi
  800b7f:	89 d6                	mov    %edx,%esi
  800b81:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b83:	5b                   	pop    %ebx
  800b84:	5e                   	pop    %esi
  800b85:	5f                   	pop    %edi
  800b86:	5d                   	pop    %ebp
  800b87:	c3                   	ret    

00800b88 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b88:	55                   	push   %ebp
  800b89:	89 e5                	mov    %esp,%ebp
  800b8b:	57                   	push   %edi
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
  800b8e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b91:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b96:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b9e:	89 cb                	mov    %ecx,%ebx
  800ba0:	89 cf                	mov    %ecx,%edi
  800ba2:	89 ce                	mov    %ecx,%esi
  800ba4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ba6:	85 c0                	test   %eax,%eax
  800ba8:	7f 08                	jg     800bb2 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800baa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800bad:	5b                   	pop    %ebx
  800bae:	5e                   	pop    %esi
  800baf:	5f                   	pop    %edi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800bb2:	83 ec 0c             	sub    $0xc,%esp
  800bb5:	50                   	push   %eax
  800bb6:	6a 03                	push   $0x3
  800bb8:	68 9f 25 80 00       	push   $0x80259f
  800bbd:	6a 23                	push   $0x23
  800bbf:	68 bc 25 80 00       	push   $0x8025bc
  800bc4:	e8 4b 12 00 00       	call   801e14 <_panic>

00800bc9 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	57                   	push   %edi
  800bcd:	56                   	push   %esi
  800bce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800bcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800bd4:	b8 02 00 00 00       	mov    $0x2,%eax
  800bd9:	89 d1                	mov    %edx,%ecx
  800bdb:	89 d3                	mov    %edx,%ebx
  800bdd:	89 d7                	mov    %edx,%edi
  800bdf:	89 d6                	mov    %edx,%esi
  800be1:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5f                   	pop    %edi
  800be6:	5d                   	pop    %ebp
  800be7:	c3                   	ret    

00800be8 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
  800beb:	57                   	push   %edi
  800bec:	56                   	push   %esi
  800bed:	53                   	push   %ebx
  800bee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bf1:	be 00 00 00 00       	mov    $0x0,%esi
  800bf6:	b8 04 00 00 00       	mov    $0x4,%eax
  800bfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c04:	89 f7                	mov    %esi,%edi
  800c06:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c08:	85 c0                	test   %eax,%eax
  800c0a:	7f 08                	jg     800c14 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c0f:	5b                   	pop    %ebx
  800c10:	5e                   	pop    %esi
  800c11:	5f                   	pop    %edi
  800c12:	5d                   	pop    %ebp
  800c13:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c14:	83 ec 0c             	sub    $0xc,%esp
  800c17:	50                   	push   %eax
  800c18:	6a 04                	push   $0x4
  800c1a:	68 9f 25 80 00       	push   $0x80259f
  800c1f:	6a 23                	push   $0x23
  800c21:	68 bc 25 80 00       	push   $0x8025bc
  800c26:	e8 e9 11 00 00       	call   801e14 <_panic>

00800c2b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	57                   	push   %edi
  800c2f:	56                   	push   %esi
  800c30:	53                   	push   %ebx
  800c31:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c34:	b8 05 00 00 00       	mov    $0x5,%eax
  800c39:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c42:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c45:	8b 75 18             	mov    0x18(%ebp),%esi
  800c48:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c4a:	85 c0                	test   %eax,%eax
  800c4c:	7f 08                	jg     800c56 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c4e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c51:	5b                   	pop    %ebx
  800c52:	5e                   	pop    %esi
  800c53:	5f                   	pop    %edi
  800c54:	5d                   	pop    %ebp
  800c55:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c56:	83 ec 0c             	sub    $0xc,%esp
  800c59:	50                   	push   %eax
  800c5a:	6a 05                	push   $0x5
  800c5c:	68 9f 25 80 00       	push   $0x80259f
  800c61:	6a 23                	push   $0x23
  800c63:	68 bc 25 80 00       	push   $0x8025bc
  800c68:	e8 a7 11 00 00       	call   801e14 <_panic>

00800c6d <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c6d:	55                   	push   %ebp
  800c6e:	89 e5                	mov    %esp,%ebp
  800c70:	57                   	push   %edi
  800c71:	56                   	push   %esi
  800c72:	53                   	push   %ebx
  800c73:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c76:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c7b:	b8 06 00 00 00       	mov    $0x6,%eax
  800c80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c83:	8b 55 08             	mov    0x8(%ebp),%edx
  800c86:	89 df                	mov    %ebx,%edi
  800c88:	89 de                	mov    %ebx,%esi
  800c8a:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c8c:	85 c0                	test   %eax,%eax
  800c8e:	7f 08                	jg     800c98 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c98:	83 ec 0c             	sub    $0xc,%esp
  800c9b:	50                   	push   %eax
  800c9c:	6a 06                	push   $0x6
  800c9e:	68 9f 25 80 00       	push   $0x80259f
  800ca3:	6a 23                	push   $0x23
  800ca5:	68 bc 25 80 00       	push   $0x8025bc
  800caa:	e8 65 11 00 00       	call   801e14 <_panic>

00800caf <sys_yield>:

void
sys_yield(void)
{
  800caf:	55                   	push   %ebp
  800cb0:	89 e5                	mov    %esp,%ebp
  800cb2:	57                   	push   %edi
  800cb3:	56                   	push   %esi
  800cb4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb5:	ba 00 00 00 00       	mov    $0x0,%edx
  800cba:	b8 0b 00 00 00       	mov    $0xb,%eax
  800cbf:	89 d1                	mov    %edx,%ecx
  800cc1:	89 d3                	mov    %edx,%ebx
  800cc3:	89 d7                	mov    %edx,%edi
  800cc5:	89 d6                	mov    %edx,%esi
  800cc7:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800cc9:	5b                   	pop    %ebx
  800cca:	5e                   	pop    %esi
  800ccb:	5f                   	pop    %edi
  800ccc:	5d                   	pop    %ebp
  800ccd:	c3                   	ret    

00800cce <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800cce:	55                   	push   %ebp
  800ccf:	89 e5                	mov    %esp,%ebp
  800cd1:	57                   	push   %edi
  800cd2:	56                   	push   %esi
  800cd3:	53                   	push   %ebx
  800cd4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cd7:	bb 00 00 00 00       	mov    $0x0,%ebx
  800cdc:	b8 08 00 00 00       	mov    $0x8,%eax
  800ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce7:	89 df                	mov    %ebx,%edi
  800ce9:	89 de                	mov    %ebx,%esi
  800ceb:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ced:	85 c0                	test   %eax,%eax
  800cef:	7f 08                	jg     800cf9 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cf1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cf4:	5b                   	pop    %ebx
  800cf5:	5e                   	pop    %esi
  800cf6:	5f                   	pop    %edi
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cf9:	83 ec 0c             	sub    $0xc,%esp
  800cfc:	50                   	push   %eax
  800cfd:	6a 08                	push   $0x8
  800cff:	68 9f 25 80 00       	push   $0x80259f
  800d04:	6a 23                	push   $0x23
  800d06:	68 bc 25 80 00       	push   $0x8025bc
  800d0b:	e8 04 11 00 00       	call   801e14 <_panic>

00800d10 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
  800d13:	57                   	push   %edi
  800d14:	56                   	push   %esi
  800d15:	53                   	push   %ebx
  800d16:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d19:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d1e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800d23:	8b 55 08             	mov    0x8(%ebp),%edx
  800d26:	89 cb                	mov    %ecx,%ebx
  800d28:	89 cf                	mov    %ecx,%edi
  800d2a:	89 ce                	mov    %ecx,%esi
  800d2c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d2e:	85 c0                	test   %eax,%eax
  800d30:	7f 08                	jg     800d3a <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800d32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d35:	5b                   	pop    %ebx
  800d36:	5e                   	pop    %esi
  800d37:	5f                   	pop    %edi
  800d38:	5d                   	pop    %ebp
  800d39:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d3a:	83 ec 0c             	sub    $0xc,%esp
  800d3d:	50                   	push   %eax
  800d3e:	6a 0c                	push   $0xc
  800d40:	68 9f 25 80 00       	push   $0x80259f
  800d45:	6a 23                	push   $0x23
  800d47:	68 bc 25 80 00       	push   $0x8025bc
  800d4c:	e8 c3 10 00 00       	call   801e14 <_panic>

00800d51 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d51:	55                   	push   %ebp
  800d52:	89 e5                	mov    %esp,%ebp
  800d54:	57                   	push   %edi
  800d55:	56                   	push   %esi
  800d56:	53                   	push   %ebx
  800d57:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d5a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d5f:	b8 09 00 00 00       	mov    $0x9,%eax
  800d64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d67:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6a:	89 df                	mov    %ebx,%edi
  800d6c:	89 de                	mov    %ebx,%esi
  800d6e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d70:	85 c0                	test   %eax,%eax
  800d72:	7f 08                	jg     800d7c <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800d74:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d77:	5b                   	pop    %ebx
  800d78:	5e                   	pop    %esi
  800d79:	5f                   	pop    %edi
  800d7a:	5d                   	pop    %ebp
  800d7b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d7c:	83 ec 0c             	sub    $0xc,%esp
  800d7f:	50                   	push   %eax
  800d80:	6a 09                	push   $0x9
  800d82:	68 9f 25 80 00       	push   $0x80259f
  800d87:	6a 23                	push   $0x23
  800d89:	68 bc 25 80 00       	push   $0x8025bc
  800d8e:	e8 81 10 00 00       	call   801e14 <_panic>

00800d93 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d93:	55                   	push   %ebp
  800d94:	89 e5                	mov    %esp,%ebp
  800d96:	57                   	push   %edi
  800d97:	56                   	push   %esi
  800d98:	53                   	push   %ebx
  800d99:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d9c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da1:	b8 0a 00 00 00       	mov    $0xa,%eax
  800da6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800da9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dac:	89 df                	mov    %ebx,%edi
  800dae:	89 de                	mov    %ebx,%esi
  800db0:	cd 30                	int    $0x30
	if(check && ret > 0)
  800db2:	85 c0                	test   %eax,%eax
  800db4:	7f 08                	jg     800dbe <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800db6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db9:	5b                   	pop    %ebx
  800dba:	5e                   	pop    %esi
  800dbb:	5f                   	pop    %edi
  800dbc:	5d                   	pop    %ebp
  800dbd:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dbe:	83 ec 0c             	sub    $0xc,%esp
  800dc1:	50                   	push   %eax
  800dc2:	6a 0a                	push   $0xa
  800dc4:	68 9f 25 80 00       	push   $0x80259f
  800dc9:	6a 23                	push   $0x23
  800dcb:	68 bc 25 80 00       	push   $0x8025bc
  800dd0:	e8 3f 10 00 00       	call   801e14 <_panic>

00800dd5 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800dd5:	55                   	push   %ebp
  800dd6:	89 e5                	mov    %esp,%ebp
  800dd8:	57                   	push   %edi
  800dd9:	56                   	push   %esi
  800dda:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ddb:	be 00 00 00 00       	mov    $0x0,%esi
  800de0:	b8 0d 00 00 00       	mov    $0xd,%eax
  800de5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de8:	8b 55 08             	mov    0x8(%ebp),%edx
  800deb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dee:	8b 7d 14             	mov    0x14(%ebp),%edi
  800df1:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    

00800df8 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800df8:	55                   	push   %ebp
  800df9:	89 e5                	mov    %esp,%ebp
  800dfb:	57                   	push   %edi
  800dfc:	56                   	push   %esi
  800dfd:	53                   	push   %ebx
  800dfe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e01:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e06:	b8 0e 00 00 00       	mov    $0xe,%eax
  800e0b:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0e:	89 cb                	mov    %ecx,%ebx
  800e10:	89 cf                	mov    %ecx,%edi
  800e12:	89 ce                	mov    %ecx,%esi
  800e14:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e16:	85 c0                	test   %eax,%eax
  800e18:	7f 08                	jg     800e22 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800e1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e1d:	5b                   	pop    %ebx
  800e1e:	5e                   	pop    %esi
  800e1f:	5f                   	pop    %edi
  800e20:	5d                   	pop    %ebp
  800e21:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e22:	83 ec 0c             	sub    $0xc,%esp
  800e25:	50                   	push   %eax
  800e26:	6a 0e                	push   $0xe
  800e28:	68 9f 25 80 00       	push   $0x80259f
  800e2d:	6a 23                	push   $0x23
  800e2f:	68 bc 25 80 00       	push   $0x8025bc
  800e34:	e8 db 0f 00 00       	call   801e14 <_panic>

00800e39 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	57                   	push   %edi
  800e3d:	56                   	push   %esi
  800e3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e3f:	be 00 00 00 00       	mov    $0x0,%esi
  800e44:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e49:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e4c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e52:	89 f7                	mov    %esi,%edi
  800e54:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e56:	5b                   	pop    %ebx
  800e57:	5e                   	pop    %esi
  800e58:	5f                   	pop    %edi
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e61:	be 00 00 00 00       	mov    $0x0,%esi
  800e66:	b8 10 00 00 00       	mov    $0x10,%eax
  800e6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800e71:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e74:	89 f7                	mov    %esi,%edi
  800e76:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e78:	5b                   	pop    %ebx
  800e79:	5e                   	pop    %esi
  800e7a:	5f                   	pop    %edi
  800e7b:	5d                   	pop    %ebp
  800e7c:	c3                   	ret    

00800e7d <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	57                   	push   %edi
  800e81:	56                   	push   %esi
  800e82:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e83:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e88:	b8 11 00 00 00       	mov    $0x11,%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 cb                	mov    %ecx,%ebx
  800e92:	89 cf                	mov    %ecx,%edi
  800e94:	89 ce                	mov    %ecx,%esi
  800e96:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e98:	5b                   	pop    %ebx
  800e99:	5e                   	pop    %esi
  800e9a:	5f                   	pop    %edi
  800e9b:	5d                   	pop    %ebp
  800e9c:	c3                   	ret    

00800e9d <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  800e9d:	55                   	push   %ebp
  800e9e:	89 e5                	mov    %esp,%ebp
  800ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  800ea3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  800ea9:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  800eab:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800eae:	83 3a 01             	cmpl   $0x1,(%edx)
  800eb1:	7e 15                	jle    800ec8 <argstart+0x2b>
  800eb3:	85 c9                	test   %ecx,%ecx
  800eb5:	74 18                	je     800ecf <argstart+0x32>
  800eb7:	ba 71 22 80 00       	mov    $0x802271,%edx
  800ebc:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  800ebf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  800ec6:	5d                   	pop    %ebp
  800ec7:	c3                   	ret    
	args->curarg = (*argc > 1 && argv ? "" : 0);
  800ec8:	ba 00 00 00 00       	mov    $0x0,%edx
  800ecd:	eb ed                	jmp    800ebc <argstart+0x1f>
  800ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ed4:	eb e6                	jmp    800ebc <argstart+0x1f>

00800ed6 <argnext>:

int
argnext(struct Argstate *args)
{
  800ed6:	55                   	push   %ebp
  800ed7:	89 e5                	mov    %esp,%ebp
  800ed9:	53                   	push   %ebx
  800eda:	83 ec 04             	sub    $0x4,%esp
  800edd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  800ee0:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  800ee7:	8b 43 08             	mov    0x8(%ebx),%eax
  800eea:	85 c0                	test   %eax,%eax
  800eec:	74 6d                	je     800f5b <argnext+0x85>
		return -1;

	if (!*args->curarg) {
  800eee:	80 38 00             	cmpb   $0x0,(%eax)
  800ef1:	75 45                	jne    800f38 <argnext+0x62>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  800ef3:	8b 0b                	mov    (%ebx),%ecx
  800ef5:	83 39 01             	cmpl   $0x1,(%ecx)
  800ef8:	74 53                	je     800f4d <argnext+0x77>
		    || args->argv[1][0] != '-'
  800efa:	8b 53 04             	mov    0x4(%ebx),%edx
  800efd:	8b 42 04             	mov    0x4(%edx),%eax
  800f00:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f03:	75 48                	jne    800f4d <argnext+0x77>
		    || args->argv[1][1] == '\0')
  800f05:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f09:	74 42                	je     800f4d <argnext+0x77>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  800f0b:	40                   	inc    %eax
  800f0c:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f0f:	83 ec 04             	sub    $0x4,%esp
  800f12:	8b 01                	mov    (%ecx),%eax
  800f14:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  800f1b:	50                   	push   %eax
  800f1c:	8d 42 08             	lea    0x8(%edx),%eax
  800f1f:	50                   	push   %eax
  800f20:	83 c2 04             	add    $0x4,%edx
  800f23:	52                   	push   %edx
  800f24:	e8 7d fa ff ff       	call   8009a6 <memmove>
		(*args->argc)--;
  800f29:	8b 03                	mov    (%ebx),%eax
  800f2b:	ff 08                	decl   (%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f2d:	8b 43 08             	mov    0x8(%ebx),%eax
  800f30:	83 c4 10             	add    $0x10,%esp
  800f33:	80 38 2d             	cmpb   $0x2d,(%eax)
  800f36:	74 0f                	je     800f47 <argnext+0x71>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  800f38:	8b 53 08             	mov    0x8(%ebx),%edx
  800f3b:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  800f3e:	42                   	inc    %edx
  800f3f:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  800f42:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  800f47:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  800f4b:	75 eb                	jne    800f38 <argnext+0x62>
	args->curarg = 0;
  800f4d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  800f54:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800f59:	eb e7                	jmp    800f42 <argnext+0x6c>
		return -1;
  800f5b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  800f60:	eb e0                	jmp    800f42 <argnext+0x6c>

00800f62 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
  800f65:	53                   	push   %ebx
  800f66:	83 ec 04             	sub    $0x4,%esp
  800f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  800f6c:	8b 43 08             	mov    0x8(%ebx),%eax
  800f6f:	85 c0                	test   %eax,%eax
  800f71:	74 5a                	je     800fcd <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  800f73:	80 38 00             	cmpb   $0x0,(%eax)
  800f76:	74 12                	je     800f8a <argnextvalue+0x28>
		args->argvalue = args->curarg;
  800f78:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  800f7b:	c7 43 08 71 22 80 00 	movl   $0x802271,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  800f82:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  800f85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800f88:	c9                   	leave  
  800f89:	c3                   	ret    
	} else if (*args->argc > 1) {
  800f8a:	8b 13                	mov    (%ebx),%edx
  800f8c:	83 3a 01             	cmpl   $0x1,(%edx)
  800f8f:	7e 2c                	jle    800fbd <argnextvalue+0x5b>
		args->argvalue = args->argv[1];
  800f91:	8b 43 04             	mov    0x4(%ebx),%eax
  800f94:	8b 48 04             	mov    0x4(%eax),%ecx
  800f97:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  800f9a:	83 ec 04             	sub    $0x4,%esp
  800f9d:	8b 12                	mov    (%edx),%edx
  800f9f:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  800fa6:	52                   	push   %edx
  800fa7:	8d 50 08             	lea    0x8(%eax),%edx
  800faa:	52                   	push   %edx
  800fab:	83 c0 04             	add    $0x4,%eax
  800fae:	50                   	push   %eax
  800faf:	e8 f2 f9 ff ff       	call   8009a6 <memmove>
		(*args->argc)--;
  800fb4:	8b 03                	mov    (%ebx),%eax
  800fb6:	ff 08                	decl   (%eax)
  800fb8:	83 c4 10             	add    $0x10,%esp
  800fbb:	eb c5                	jmp    800f82 <argnextvalue+0x20>
		args->argvalue = 0;
  800fbd:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  800fc4:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  800fcb:	eb b5                	jmp    800f82 <argnextvalue+0x20>
		return 0;
  800fcd:	b8 00 00 00 00       	mov    $0x0,%eax
  800fd2:	eb b1                	jmp    800f85 <argnextvalue+0x23>

00800fd4 <argvalue>:
{
  800fd4:	55                   	push   %ebp
  800fd5:	89 e5                	mov    %esp,%ebp
  800fd7:	83 ec 08             	sub    $0x8,%esp
  800fda:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fdd:	8b 51 0c             	mov    0xc(%ecx),%edx
  800fe0:	89 d0                	mov    %edx,%eax
  800fe2:	85 d2                	test   %edx,%edx
  800fe4:	74 02                	je     800fe8 <argvalue+0x14>
}
  800fe6:	c9                   	leave  
  800fe7:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	51                   	push   %ecx
  800fec:	e8 71 ff ff ff       	call   800f62 <argnextvalue>
  800ff1:	83 c4 10             	add    $0x10,%esp
  800ff4:	eb f0                	jmp    800fe6 <argvalue+0x12>

00800ff6 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800ff6:	55                   	push   %ebp
  800ff7:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	05 00 00 00 30       	add    $0x30000000,%eax
  801001:	c1 e8 0c             	shr    $0xc,%eax
}
  801004:	5d                   	pop    %ebp
  801005:	c3                   	ret    

00801006 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801006:	55                   	push   %ebp
  801007:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801009:	8b 45 08             	mov    0x8(%ebp),%eax
  80100c:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801011:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801016:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80101b:	5d                   	pop    %ebp
  80101c:	c3                   	ret    

0080101d <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80101d:	55                   	push   %ebp
  80101e:	89 e5                	mov    %esp,%ebp
  801020:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801023:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801028:	89 c2                	mov    %eax,%edx
  80102a:	c1 ea 16             	shr    $0x16,%edx
  80102d:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801034:	f6 c2 01             	test   $0x1,%dl
  801037:	74 2a                	je     801063 <fd_alloc+0x46>
  801039:	89 c2                	mov    %eax,%edx
  80103b:	c1 ea 0c             	shr    $0xc,%edx
  80103e:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801045:	f6 c2 01             	test   $0x1,%dl
  801048:	74 19                	je     801063 <fd_alloc+0x46>
  80104a:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80104f:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801054:	75 d2                	jne    801028 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801056:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80105c:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801061:	eb 07                	jmp    80106a <fd_alloc+0x4d>
			*fd_store = fd;
  801063:	89 01                	mov    %eax,(%ecx)
			return 0;
  801065:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80106a:	5d                   	pop    %ebp
  80106b:	c3                   	ret    

0080106c <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80106f:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801073:	77 39                	ja     8010ae <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	c1 e0 0c             	shl    $0xc,%eax
  80107b:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801080:	89 c2                	mov    %eax,%edx
  801082:	c1 ea 16             	shr    $0x16,%edx
  801085:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80108c:	f6 c2 01             	test   $0x1,%dl
  80108f:	74 24                	je     8010b5 <fd_lookup+0x49>
  801091:	89 c2                	mov    %eax,%edx
  801093:	c1 ea 0c             	shr    $0xc,%edx
  801096:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80109d:	f6 c2 01             	test   $0x1,%dl
  8010a0:	74 1a                	je     8010bc <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8010a2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a5:	89 02                	mov    %eax,(%edx)
	return 0;
  8010a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010ac:	5d                   	pop    %ebp
  8010ad:	c3                   	ret    
		return -E_INVAL;
  8010ae:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010b3:	eb f7                	jmp    8010ac <fd_lookup+0x40>
		return -E_INVAL;
  8010b5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010ba:	eb f0                	jmp    8010ac <fd_lookup+0x40>
  8010bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8010c1:	eb e9                	jmp    8010ac <fd_lookup+0x40>

008010c3 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
  8010c6:	83 ec 08             	sub    $0x8,%esp
  8010c9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cc:	ba 48 26 80 00       	mov    $0x802648,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8010d1:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8010d6:	39 08                	cmp    %ecx,(%eax)
  8010d8:	74 33                	je     80110d <dev_lookup+0x4a>
  8010da:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8010dd:	8b 02                	mov    (%edx),%eax
  8010df:	85 c0                	test   %eax,%eax
  8010e1:	75 f3                	jne    8010d6 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8010e3:	a1 04 40 80 00       	mov    0x804004,%eax
  8010e8:	8b 40 48             	mov    0x48(%eax),%eax
  8010eb:	83 ec 04             	sub    $0x4,%esp
  8010ee:	51                   	push   %ecx
  8010ef:	50                   	push   %eax
  8010f0:	68 cc 25 80 00       	push   $0x8025cc
  8010f5:	e8 31 f1 ff ff       	call   80022b <cprintf>
	*dev = 0;
  8010fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801103:	83 c4 10             	add    $0x10,%esp
  801106:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    
			*dev = devtab[i];
  80110d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801110:	89 01                	mov    %eax,(%ecx)
			return 0;
  801112:	b8 00 00 00 00       	mov    $0x0,%eax
  801117:	eb f2                	jmp    80110b <dev_lookup+0x48>

00801119 <fd_close>:
{
  801119:	55                   	push   %ebp
  80111a:	89 e5                	mov    %esp,%ebp
  80111c:	57                   	push   %edi
  80111d:	56                   	push   %esi
  80111e:	53                   	push   %ebx
  80111f:	83 ec 1c             	sub    $0x1c,%esp
  801122:	8b 75 08             	mov    0x8(%ebp),%esi
  801125:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801128:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80112b:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80112c:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801132:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801135:	50                   	push   %eax
  801136:	e8 31 ff ff ff       	call   80106c <fd_lookup>
  80113b:	89 c7                	mov    %eax,%edi
  80113d:	83 c4 08             	add    $0x8,%esp
  801140:	85 c0                	test   %eax,%eax
  801142:	78 05                	js     801149 <fd_close+0x30>
	    || fd != fd2)
  801144:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801147:	74 13                	je     80115c <fd_close+0x43>
		return (must_exist ? r : 0);
  801149:	84 db                	test   %bl,%bl
  80114b:	75 05                	jne    801152 <fd_close+0x39>
  80114d:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801152:	89 f8                	mov    %edi,%eax
  801154:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801157:	5b                   	pop    %ebx
  801158:	5e                   	pop    %esi
  801159:	5f                   	pop    %edi
  80115a:	5d                   	pop    %ebp
  80115b:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80115c:	83 ec 08             	sub    $0x8,%esp
  80115f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801162:	50                   	push   %eax
  801163:	ff 36                	pushl  (%esi)
  801165:	e8 59 ff ff ff       	call   8010c3 <dev_lookup>
  80116a:	89 c7                	mov    %eax,%edi
  80116c:	83 c4 10             	add    $0x10,%esp
  80116f:	85 c0                	test   %eax,%eax
  801171:	78 15                	js     801188 <fd_close+0x6f>
		if (dev->dev_close)
  801173:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801176:	8b 40 10             	mov    0x10(%eax),%eax
  801179:	85 c0                	test   %eax,%eax
  80117b:	74 1b                	je     801198 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  80117d:	83 ec 0c             	sub    $0xc,%esp
  801180:	56                   	push   %esi
  801181:	ff d0                	call   *%eax
  801183:	89 c7                	mov    %eax,%edi
  801185:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801188:	83 ec 08             	sub    $0x8,%esp
  80118b:	56                   	push   %esi
  80118c:	6a 00                	push   $0x0
  80118e:	e8 da fa ff ff       	call   800c6d <sys_page_unmap>
	return r;
  801193:	83 c4 10             	add    $0x10,%esp
  801196:	eb ba                	jmp    801152 <fd_close+0x39>
			r = 0;
  801198:	bf 00 00 00 00       	mov    $0x0,%edi
  80119d:	eb e9                	jmp    801188 <fd_close+0x6f>

0080119f <close>:

int
close(int fdnum)
{
  80119f:	55                   	push   %ebp
  8011a0:	89 e5                	mov    %esp,%ebp
  8011a2:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011a5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011a8:	50                   	push   %eax
  8011a9:	ff 75 08             	pushl  0x8(%ebp)
  8011ac:	e8 bb fe ff ff       	call   80106c <fd_lookup>
  8011b1:	83 c4 08             	add    $0x8,%esp
  8011b4:	85 c0                	test   %eax,%eax
  8011b6:	78 10                	js     8011c8 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	6a 01                	push   $0x1
  8011bd:	ff 75 f4             	pushl  -0xc(%ebp)
  8011c0:	e8 54 ff ff ff       	call   801119 <fd_close>
  8011c5:	83 c4 10             	add    $0x10,%esp
}
  8011c8:	c9                   	leave  
  8011c9:	c3                   	ret    

008011ca <close_all>:

void
close_all(void)
{
  8011ca:	55                   	push   %ebp
  8011cb:	89 e5                	mov    %esp,%ebp
  8011cd:	53                   	push   %ebx
  8011ce:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8011d1:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	53                   	push   %ebx
  8011da:	e8 c0 ff ff ff       	call   80119f <close>
	for (i = 0; i < MAXFD; i++)
  8011df:	43                   	inc    %ebx
  8011e0:	83 c4 10             	add    $0x10,%esp
  8011e3:	83 fb 20             	cmp    $0x20,%ebx
  8011e6:	75 ee                	jne    8011d6 <close_all+0xc>
}
  8011e8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011eb:	c9                   	leave  
  8011ec:	c3                   	ret    

008011ed <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8011ed:	55                   	push   %ebp
  8011ee:	89 e5                	mov    %esp,%ebp
  8011f0:	57                   	push   %edi
  8011f1:	56                   	push   %esi
  8011f2:	53                   	push   %ebx
  8011f3:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8011f6:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8011f9:	50                   	push   %eax
  8011fa:	ff 75 08             	pushl  0x8(%ebp)
  8011fd:	e8 6a fe ff ff       	call   80106c <fd_lookup>
  801202:	89 c3                	mov    %eax,%ebx
  801204:	83 c4 08             	add    $0x8,%esp
  801207:	85 c0                	test   %eax,%eax
  801209:	0f 88 81 00 00 00    	js     801290 <dup+0xa3>
		return r;
	close(newfdnum);
  80120f:	83 ec 0c             	sub    $0xc,%esp
  801212:	ff 75 0c             	pushl  0xc(%ebp)
  801215:	e8 85 ff ff ff       	call   80119f <close>

	newfd = INDEX2FD(newfdnum);
  80121a:	8b 75 0c             	mov    0xc(%ebp),%esi
  80121d:	c1 e6 0c             	shl    $0xc,%esi
  801220:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801226:	83 c4 04             	add    $0x4,%esp
  801229:	ff 75 e4             	pushl  -0x1c(%ebp)
  80122c:	e8 d5 fd ff ff       	call   801006 <fd2data>
  801231:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801233:	89 34 24             	mov    %esi,(%esp)
  801236:	e8 cb fd ff ff       	call   801006 <fd2data>
  80123b:	83 c4 10             	add    $0x10,%esp
  80123e:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801240:	89 d8                	mov    %ebx,%eax
  801242:	c1 e8 16             	shr    $0x16,%eax
  801245:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80124c:	a8 01                	test   $0x1,%al
  80124e:	74 11                	je     801261 <dup+0x74>
  801250:	89 d8                	mov    %ebx,%eax
  801252:	c1 e8 0c             	shr    $0xc,%eax
  801255:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80125c:	f6 c2 01             	test   $0x1,%dl
  80125f:	75 39                	jne    80129a <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801261:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801264:	89 d0                	mov    %edx,%eax
  801266:	c1 e8 0c             	shr    $0xc,%eax
  801269:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801270:	83 ec 0c             	sub    $0xc,%esp
  801273:	25 07 0e 00 00       	and    $0xe07,%eax
  801278:	50                   	push   %eax
  801279:	56                   	push   %esi
  80127a:	6a 00                	push   $0x0
  80127c:	52                   	push   %edx
  80127d:	6a 00                	push   $0x0
  80127f:	e8 a7 f9 ff ff       	call   800c2b <sys_page_map>
  801284:	89 c3                	mov    %eax,%ebx
  801286:	83 c4 20             	add    $0x20,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	78 31                	js     8012be <dup+0xd1>
		goto err;

	return newfdnum;
  80128d:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801290:	89 d8                	mov    %ebx,%eax
  801292:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801295:	5b                   	pop    %ebx
  801296:	5e                   	pop    %esi
  801297:	5f                   	pop    %edi
  801298:	5d                   	pop    %ebp
  801299:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80129a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012a1:	83 ec 0c             	sub    $0xc,%esp
  8012a4:	25 07 0e 00 00       	and    $0xe07,%eax
  8012a9:	50                   	push   %eax
  8012aa:	57                   	push   %edi
  8012ab:	6a 00                	push   $0x0
  8012ad:	53                   	push   %ebx
  8012ae:	6a 00                	push   $0x0
  8012b0:	e8 76 f9 ff ff       	call   800c2b <sys_page_map>
  8012b5:	89 c3                	mov    %eax,%ebx
  8012b7:	83 c4 20             	add    $0x20,%esp
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	79 a3                	jns    801261 <dup+0x74>
	sys_page_unmap(0, newfd);
  8012be:	83 ec 08             	sub    $0x8,%esp
  8012c1:	56                   	push   %esi
  8012c2:	6a 00                	push   $0x0
  8012c4:	e8 a4 f9 ff ff       	call   800c6d <sys_page_unmap>
	sys_page_unmap(0, nva);
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	57                   	push   %edi
  8012cd:	6a 00                	push   $0x0
  8012cf:	e8 99 f9 ff ff       	call   800c6d <sys_page_unmap>
	return r;
  8012d4:	83 c4 10             	add    $0x10,%esp
  8012d7:	eb b7                	jmp    801290 <dup+0xa3>

008012d9 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	53                   	push   %ebx
  8012dd:	83 ec 14             	sub    $0x14,%esp
  8012e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012e3:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012e6:	50                   	push   %eax
  8012e7:	53                   	push   %ebx
  8012e8:	e8 7f fd ff ff       	call   80106c <fd_lookup>
  8012ed:	83 c4 08             	add    $0x8,%esp
  8012f0:	85 c0                	test   %eax,%eax
  8012f2:	78 3f                	js     801333 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012fa:	50                   	push   %eax
  8012fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012fe:	ff 30                	pushl  (%eax)
  801300:	e8 be fd ff ff       	call   8010c3 <dev_lookup>
  801305:	83 c4 10             	add    $0x10,%esp
  801308:	85 c0                	test   %eax,%eax
  80130a:	78 27                	js     801333 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80130c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80130f:	8b 42 08             	mov    0x8(%edx),%eax
  801312:	83 e0 03             	and    $0x3,%eax
  801315:	83 f8 01             	cmp    $0x1,%eax
  801318:	74 1e                	je     801338 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80131a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80131d:	8b 40 08             	mov    0x8(%eax),%eax
  801320:	85 c0                	test   %eax,%eax
  801322:	74 35                	je     801359 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801324:	83 ec 04             	sub    $0x4,%esp
  801327:	ff 75 10             	pushl  0x10(%ebp)
  80132a:	ff 75 0c             	pushl  0xc(%ebp)
  80132d:	52                   	push   %edx
  80132e:	ff d0                	call   *%eax
  801330:	83 c4 10             	add    $0x10,%esp
}
  801333:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801336:	c9                   	leave  
  801337:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801338:	a1 04 40 80 00       	mov    0x804004,%eax
  80133d:	8b 40 48             	mov    0x48(%eax),%eax
  801340:	83 ec 04             	sub    $0x4,%esp
  801343:	53                   	push   %ebx
  801344:	50                   	push   %eax
  801345:	68 0d 26 80 00       	push   $0x80260d
  80134a:	e8 dc ee ff ff       	call   80022b <cprintf>
		return -E_INVAL;
  80134f:	83 c4 10             	add    $0x10,%esp
  801352:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801357:	eb da                	jmp    801333 <read+0x5a>
		return -E_NOT_SUPP;
  801359:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80135e:	eb d3                	jmp    801333 <read+0x5a>

00801360 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	57                   	push   %edi
  801364:	56                   	push   %esi
  801365:	53                   	push   %ebx
  801366:	83 ec 0c             	sub    $0xc,%esp
  801369:	8b 7d 08             	mov    0x8(%ebp),%edi
  80136c:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80136f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801374:	39 f3                	cmp    %esi,%ebx
  801376:	73 25                	jae    80139d <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801378:	83 ec 04             	sub    $0x4,%esp
  80137b:	89 f0                	mov    %esi,%eax
  80137d:	29 d8                	sub    %ebx,%eax
  80137f:	50                   	push   %eax
  801380:	89 d8                	mov    %ebx,%eax
  801382:	03 45 0c             	add    0xc(%ebp),%eax
  801385:	50                   	push   %eax
  801386:	57                   	push   %edi
  801387:	e8 4d ff ff ff       	call   8012d9 <read>
		if (m < 0)
  80138c:	83 c4 10             	add    $0x10,%esp
  80138f:	85 c0                	test   %eax,%eax
  801391:	78 08                	js     80139b <readn+0x3b>
			return m;
		if (m == 0)
  801393:	85 c0                	test   %eax,%eax
  801395:	74 06                	je     80139d <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801397:	01 c3                	add    %eax,%ebx
  801399:	eb d9                	jmp    801374 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80139b:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80139d:	89 d8                	mov    %ebx,%eax
  80139f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013a2:	5b                   	pop    %ebx
  8013a3:	5e                   	pop    %esi
  8013a4:	5f                   	pop    %edi
  8013a5:	5d                   	pop    %ebp
  8013a6:	c3                   	ret    

008013a7 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	53                   	push   %ebx
  8013ab:	83 ec 14             	sub    $0x14,%esp
  8013ae:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8013b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8013b4:	50                   	push   %eax
  8013b5:	53                   	push   %ebx
  8013b6:	e8 b1 fc ff ff       	call   80106c <fd_lookup>
  8013bb:	83 c4 08             	add    $0x8,%esp
  8013be:	85 c0                	test   %eax,%eax
  8013c0:	78 3a                	js     8013fc <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8013c2:	83 ec 08             	sub    $0x8,%esp
  8013c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013c8:	50                   	push   %eax
  8013c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013cc:	ff 30                	pushl  (%eax)
  8013ce:	e8 f0 fc ff ff       	call   8010c3 <dev_lookup>
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 22                	js     8013fc <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8013da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013dd:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8013e1:	74 1e                	je     801401 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8013e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013e6:	8b 52 0c             	mov    0xc(%edx),%edx
  8013e9:	85 d2                	test   %edx,%edx
  8013eb:	74 35                	je     801422 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8013ed:	83 ec 04             	sub    $0x4,%esp
  8013f0:	ff 75 10             	pushl  0x10(%ebp)
  8013f3:	ff 75 0c             	pushl  0xc(%ebp)
  8013f6:	50                   	push   %eax
  8013f7:	ff d2                	call   *%edx
  8013f9:	83 c4 10             	add    $0x10,%esp
}
  8013fc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013ff:	c9                   	leave  
  801400:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801401:	a1 04 40 80 00       	mov    0x804004,%eax
  801406:	8b 40 48             	mov    0x48(%eax),%eax
  801409:	83 ec 04             	sub    $0x4,%esp
  80140c:	53                   	push   %ebx
  80140d:	50                   	push   %eax
  80140e:	68 29 26 80 00       	push   $0x802629
  801413:	e8 13 ee ff ff       	call   80022b <cprintf>
		return -E_INVAL;
  801418:	83 c4 10             	add    $0x10,%esp
  80141b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801420:	eb da                	jmp    8013fc <write+0x55>
		return -E_NOT_SUPP;
  801422:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801427:	eb d3                	jmp    8013fc <write+0x55>

00801429 <seek>:

int
seek(int fdnum, off_t offset)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80142f:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801432:	50                   	push   %eax
  801433:	ff 75 08             	pushl  0x8(%ebp)
  801436:	e8 31 fc ff ff       	call   80106c <fd_lookup>
  80143b:	83 c4 08             	add    $0x8,%esp
  80143e:	85 c0                	test   %eax,%eax
  801440:	78 0e                	js     801450 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801442:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801445:	8b 55 0c             	mov    0xc(%ebp),%edx
  801448:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80144b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	53                   	push   %ebx
  801456:	83 ec 14             	sub    $0x14,%esp
  801459:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80145c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80145f:	50                   	push   %eax
  801460:	53                   	push   %ebx
  801461:	e8 06 fc ff ff       	call   80106c <fd_lookup>
  801466:	83 c4 08             	add    $0x8,%esp
  801469:	85 c0                	test   %eax,%eax
  80146b:	78 37                	js     8014a4 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80146d:	83 ec 08             	sub    $0x8,%esp
  801470:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801473:	50                   	push   %eax
  801474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801477:	ff 30                	pushl  (%eax)
  801479:	e8 45 fc ff ff       	call   8010c3 <dev_lookup>
  80147e:	83 c4 10             	add    $0x10,%esp
  801481:	85 c0                	test   %eax,%eax
  801483:	78 1f                	js     8014a4 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801488:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80148c:	74 1b                	je     8014a9 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80148e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801491:	8b 52 18             	mov    0x18(%edx),%edx
  801494:	85 d2                	test   %edx,%edx
  801496:	74 32                	je     8014ca <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801498:	83 ec 08             	sub    $0x8,%esp
  80149b:	ff 75 0c             	pushl  0xc(%ebp)
  80149e:	50                   	push   %eax
  80149f:	ff d2                	call   *%edx
  8014a1:	83 c4 10             	add    $0x10,%esp
}
  8014a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014a7:	c9                   	leave  
  8014a8:	c3                   	ret    
			thisenv->env_id, fdnum);
  8014a9:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8014ae:	8b 40 48             	mov    0x48(%eax),%eax
  8014b1:	83 ec 04             	sub    $0x4,%esp
  8014b4:	53                   	push   %ebx
  8014b5:	50                   	push   %eax
  8014b6:	68 ec 25 80 00       	push   $0x8025ec
  8014bb:	e8 6b ed ff ff       	call   80022b <cprintf>
		return -E_INVAL;
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014c8:	eb da                	jmp    8014a4 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8014ca:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014cf:	eb d3                	jmp    8014a4 <ftruncate+0x52>

008014d1 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8014d1:	55                   	push   %ebp
  8014d2:	89 e5                	mov    %esp,%ebp
  8014d4:	53                   	push   %ebx
  8014d5:	83 ec 14             	sub    $0x14,%esp
  8014d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8014db:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8014de:	50                   	push   %eax
  8014df:	ff 75 08             	pushl  0x8(%ebp)
  8014e2:	e8 85 fb ff ff       	call   80106c <fd_lookup>
  8014e7:	83 c4 08             	add    $0x8,%esp
  8014ea:	85 c0                	test   %eax,%eax
  8014ec:	78 4b                	js     801539 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8014ee:	83 ec 08             	sub    $0x8,%esp
  8014f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8014f4:	50                   	push   %eax
  8014f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f8:	ff 30                	pushl  (%eax)
  8014fa:	e8 c4 fb ff ff       	call   8010c3 <dev_lookup>
  8014ff:	83 c4 10             	add    $0x10,%esp
  801502:	85 c0                	test   %eax,%eax
  801504:	78 33                	js     801539 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801506:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801509:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80150d:	74 2f                	je     80153e <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80150f:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801512:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801519:	00 00 00 
	stat->st_type = 0;
  80151c:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801523:	00 00 00 
	stat->st_dev = dev;
  801526:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80152c:	83 ec 08             	sub    $0x8,%esp
  80152f:	53                   	push   %ebx
  801530:	ff 75 f0             	pushl  -0x10(%ebp)
  801533:	ff 50 14             	call   *0x14(%eax)
  801536:	83 c4 10             	add    $0x10,%esp
}
  801539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80153c:	c9                   	leave  
  80153d:	c3                   	ret    
		return -E_NOT_SUPP;
  80153e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801543:	eb f4                	jmp    801539 <fstat+0x68>

00801545 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
  801548:	56                   	push   %esi
  801549:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	6a 00                	push   $0x0
  80154f:	ff 75 08             	pushl  0x8(%ebp)
  801552:	e8 34 02 00 00       	call   80178b <open>
  801557:	89 c3                	mov    %eax,%ebx
  801559:	83 c4 10             	add    $0x10,%esp
  80155c:	85 c0                	test   %eax,%eax
  80155e:	78 1b                	js     80157b <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	ff 75 0c             	pushl  0xc(%ebp)
  801566:	50                   	push   %eax
  801567:	e8 65 ff ff ff       	call   8014d1 <fstat>
  80156c:	89 c6                	mov    %eax,%esi
	close(fd);
  80156e:	89 1c 24             	mov    %ebx,(%esp)
  801571:	e8 29 fc ff ff       	call   80119f <close>
	return r;
  801576:	83 c4 10             	add    $0x10,%esp
  801579:	89 f3                	mov    %esi,%ebx
}
  80157b:	89 d8                	mov    %ebx,%eax
  80157d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801580:	5b                   	pop    %ebx
  801581:	5e                   	pop    %esi
  801582:	5d                   	pop    %ebp
  801583:	c3                   	ret    

00801584 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801584:	55                   	push   %ebp
  801585:	89 e5                	mov    %esp,%ebp
  801587:	56                   	push   %esi
  801588:	53                   	push   %ebx
  801589:	89 c6                	mov    %eax,%esi
  80158b:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80158d:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801594:	74 27                	je     8015bd <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801596:	6a 07                	push   $0x7
  801598:	68 00 50 80 00       	push   $0x805000
  80159d:	56                   	push   %esi
  80159e:	ff 35 00 40 80 00    	pushl  0x804000
  8015a4:	e8 73 09 00 00       	call   801f1c <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8015a9:	83 c4 0c             	add    $0xc,%esp
  8015ac:	6a 00                	push   $0x0
  8015ae:	53                   	push   %ebx
  8015af:	6a 00                	push   $0x0
  8015b1:	e8 dd 08 00 00       	call   801e93 <ipc_recv>
}
  8015b6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015b9:	5b                   	pop    %ebx
  8015ba:	5e                   	pop    %esi
  8015bb:	5d                   	pop    %ebp
  8015bc:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8015bd:	83 ec 0c             	sub    $0xc,%esp
  8015c0:	6a 01                	push   $0x1
  8015c2:	e8 b1 09 00 00       	call   801f78 <ipc_find_env>
  8015c7:	a3 00 40 80 00       	mov    %eax,0x804000
  8015cc:	83 c4 10             	add    $0x10,%esp
  8015cf:	eb c5                	jmp    801596 <fsipc+0x12>

008015d1 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8015d1:	55                   	push   %ebp
  8015d2:	89 e5                	mov    %esp,%ebp
  8015d4:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8015d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015da:	8b 40 0c             	mov    0xc(%eax),%eax
  8015dd:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8015e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015e5:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8015ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8015ef:	b8 02 00 00 00       	mov    $0x2,%eax
  8015f4:	e8 8b ff ff ff       	call   801584 <fsipc>
}
  8015f9:	c9                   	leave  
  8015fa:	c3                   	ret    

008015fb <devfile_flush>:
{
  8015fb:	55                   	push   %ebp
  8015fc:	89 e5                	mov    %esp,%ebp
  8015fe:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801601:	8b 45 08             	mov    0x8(%ebp),%eax
  801604:	8b 40 0c             	mov    0xc(%eax),%eax
  801607:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80160c:	ba 00 00 00 00       	mov    $0x0,%edx
  801611:	b8 06 00 00 00       	mov    $0x6,%eax
  801616:	e8 69 ff ff ff       	call   801584 <fsipc>
}
  80161b:	c9                   	leave  
  80161c:	c3                   	ret    

0080161d <devfile_stat>:
{
  80161d:	55                   	push   %ebp
  80161e:	89 e5                	mov    %esp,%ebp
  801620:	53                   	push   %ebx
  801621:	83 ec 04             	sub    $0x4,%esp
  801624:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	8b 40 0c             	mov    0xc(%eax),%eax
  80162d:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801632:	ba 00 00 00 00       	mov    $0x0,%edx
  801637:	b8 05 00 00 00       	mov    $0x5,%eax
  80163c:	e8 43 ff ff ff       	call   801584 <fsipc>
  801641:	85 c0                	test   %eax,%eax
  801643:	78 2c                	js     801671 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801645:	83 ec 08             	sub    $0x8,%esp
  801648:	68 00 50 80 00       	push   $0x805000
  80164d:	53                   	push   %ebx
  80164e:	e8 e0 f1 ff ff       	call   800833 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801653:	a1 80 50 80 00       	mov    0x805080,%eax
  801658:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80165e:	a1 84 50 80 00       	mov    0x805084,%eax
  801663:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801669:	83 c4 10             	add    $0x10,%esp
  80166c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801671:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801674:	c9                   	leave  
  801675:	c3                   	ret    

00801676 <devfile_write>:
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	53                   	push   %ebx
  80167a:	83 ec 04             	sub    $0x4,%esp
  80167d:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801680:	89 d8                	mov    %ebx,%eax
  801682:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801688:	76 05                	jbe    80168f <devfile_write+0x19>
  80168a:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80168f:	8b 55 08             	mov    0x8(%ebp),%edx
  801692:	8b 52 0c             	mov    0xc(%edx),%edx
  801695:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  80169b:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8016a0:	83 ec 04             	sub    $0x4,%esp
  8016a3:	50                   	push   %eax
  8016a4:	ff 75 0c             	pushl  0xc(%ebp)
  8016a7:	68 08 50 80 00       	push   $0x805008
  8016ac:	e8 f5 f2 ff ff       	call   8009a6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8016b1:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b6:	b8 04 00 00 00       	mov    $0x4,%eax
  8016bb:	e8 c4 fe ff ff       	call   801584 <fsipc>
  8016c0:	83 c4 10             	add    $0x10,%esp
  8016c3:	85 c0                	test   %eax,%eax
  8016c5:	78 0b                	js     8016d2 <devfile_write+0x5c>
	assert(r <= n);
  8016c7:	39 c3                	cmp    %eax,%ebx
  8016c9:	72 0c                	jb     8016d7 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8016cb:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8016d0:	7f 1e                	jg     8016f0 <devfile_write+0x7a>
}
  8016d2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d5:	c9                   	leave  
  8016d6:	c3                   	ret    
	assert(r <= n);
  8016d7:	68 58 26 80 00       	push   $0x802658
  8016dc:	68 5f 26 80 00       	push   $0x80265f
  8016e1:	68 98 00 00 00       	push   $0x98
  8016e6:	68 74 26 80 00       	push   $0x802674
  8016eb:	e8 24 07 00 00       	call   801e14 <_panic>
	assert(r <= PGSIZE);
  8016f0:	68 7f 26 80 00       	push   $0x80267f
  8016f5:	68 5f 26 80 00       	push   $0x80265f
  8016fa:	68 99 00 00 00       	push   $0x99
  8016ff:	68 74 26 80 00       	push   $0x802674
  801704:	e8 0b 07 00 00       	call   801e14 <_panic>

00801709 <devfile_read>:
{
  801709:	55                   	push   %ebp
  80170a:	89 e5                	mov    %esp,%ebp
  80170c:	56                   	push   %esi
  80170d:	53                   	push   %ebx
  80170e:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801711:	8b 45 08             	mov    0x8(%ebp),%eax
  801714:	8b 40 0c             	mov    0xc(%eax),%eax
  801717:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80171c:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801722:	ba 00 00 00 00       	mov    $0x0,%edx
  801727:	b8 03 00 00 00       	mov    $0x3,%eax
  80172c:	e8 53 fe ff ff       	call   801584 <fsipc>
  801731:	89 c3                	mov    %eax,%ebx
  801733:	85 c0                	test   %eax,%eax
  801735:	78 1f                	js     801756 <devfile_read+0x4d>
	assert(r <= n);
  801737:	39 c6                	cmp    %eax,%esi
  801739:	72 24                	jb     80175f <devfile_read+0x56>
	assert(r <= PGSIZE);
  80173b:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801740:	7f 33                	jg     801775 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801742:	83 ec 04             	sub    $0x4,%esp
  801745:	50                   	push   %eax
  801746:	68 00 50 80 00       	push   $0x805000
  80174b:	ff 75 0c             	pushl  0xc(%ebp)
  80174e:	e8 53 f2 ff ff       	call   8009a6 <memmove>
	return r;
  801753:	83 c4 10             	add    $0x10,%esp
}
  801756:	89 d8                	mov    %ebx,%eax
  801758:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80175b:	5b                   	pop    %ebx
  80175c:	5e                   	pop    %esi
  80175d:	5d                   	pop    %ebp
  80175e:	c3                   	ret    
	assert(r <= n);
  80175f:	68 58 26 80 00       	push   $0x802658
  801764:	68 5f 26 80 00       	push   $0x80265f
  801769:	6a 7c                	push   $0x7c
  80176b:	68 74 26 80 00       	push   $0x802674
  801770:	e8 9f 06 00 00       	call   801e14 <_panic>
	assert(r <= PGSIZE);
  801775:	68 7f 26 80 00       	push   $0x80267f
  80177a:	68 5f 26 80 00       	push   $0x80265f
  80177f:	6a 7d                	push   $0x7d
  801781:	68 74 26 80 00       	push   $0x802674
  801786:	e8 89 06 00 00       	call   801e14 <_panic>

0080178b <open>:
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
  801790:	83 ec 1c             	sub    $0x1c,%esp
  801793:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801796:	56                   	push   %esi
  801797:	e8 64 f0 ff ff       	call   800800 <strlen>
  80179c:	83 c4 10             	add    $0x10,%esp
  80179f:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8017a4:	7f 6c                	jg     801812 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	e8 6b f8 ff ff       	call   80101d <fd_alloc>
  8017b2:	89 c3                	mov    %eax,%ebx
  8017b4:	83 c4 10             	add    $0x10,%esp
  8017b7:	85 c0                	test   %eax,%eax
  8017b9:	78 3c                	js     8017f7 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8017bb:	83 ec 08             	sub    $0x8,%esp
  8017be:	56                   	push   %esi
  8017bf:	68 00 50 80 00       	push   $0x805000
  8017c4:	e8 6a f0 ff ff       	call   800833 <strcpy>
	fsipcbuf.open.req_omode = mode;
  8017c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017cc:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8017d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d4:	b8 01 00 00 00       	mov    $0x1,%eax
  8017d9:	e8 a6 fd ff ff       	call   801584 <fsipc>
  8017de:	89 c3                	mov    %eax,%ebx
  8017e0:	83 c4 10             	add    $0x10,%esp
  8017e3:	85 c0                	test   %eax,%eax
  8017e5:	78 19                	js     801800 <open+0x75>
	return fd2num(fd);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ed:	e8 04 f8 ff ff       	call   800ff6 <fd2num>
  8017f2:	89 c3                	mov    %eax,%ebx
  8017f4:	83 c4 10             	add    $0x10,%esp
}
  8017f7:	89 d8                	mov    %ebx,%eax
  8017f9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fc:	5b                   	pop    %ebx
  8017fd:	5e                   	pop    %esi
  8017fe:	5d                   	pop    %ebp
  8017ff:	c3                   	ret    
		fd_close(fd, 0);
  801800:	83 ec 08             	sub    $0x8,%esp
  801803:	6a 00                	push   $0x0
  801805:	ff 75 f4             	pushl  -0xc(%ebp)
  801808:	e8 0c f9 ff ff       	call   801119 <fd_close>
		return r;
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb e5                	jmp    8017f7 <open+0x6c>
		return -E_BAD_PATH;
  801812:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801817:	eb de                	jmp    8017f7 <open+0x6c>

00801819 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
  80181c:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80181f:	ba 00 00 00 00       	mov    $0x0,%edx
  801824:	b8 08 00 00 00       	mov    $0x8,%eax
  801829:	e8 56 fd ff ff       	call   801584 <fsipc>
}
  80182e:	c9                   	leave  
  80182f:	c3                   	ret    

00801830 <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  801830:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  801834:	7e 38                	jle    80186e <writebuf+0x3e>
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
  801839:	53                   	push   %ebx
  80183a:	83 ec 08             	sub    $0x8,%esp
  80183d:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80183f:	ff 70 04             	pushl  0x4(%eax)
  801842:	8d 40 10             	lea    0x10(%eax),%eax
  801845:	50                   	push   %eax
  801846:	ff 33                	pushl  (%ebx)
  801848:	e8 5a fb ff ff       	call   8013a7 <write>
		if (result > 0)
  80184d:	83 c4 10             	add    $0x10,%esp
  801850:	85 c0                	test   %eax,%eax
  801852:	7e 03                	jle    801857 <writebuf+0x27>
			b->result += result;
  801854:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  801857:	3b 43 04             	cmp    0x4(%ebx),%eax
  80185a:	74 0e                	je     80186a <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80185c:	89 c2                	mov    %eax,%edx
  80185e:	85 c0                	test   %eax,%eax
  801860:	7e 05                	jle    801867 <writebuf+0x37>
  801862:	ba 00 00 00 00       	mov    $0x0,%edx
  801867:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  80186a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186d:	c9                   	leave  
  80186e:	c3                   	ret    

0080186f <putch>:

static void
putch(int ch, void *thunk)
{
  80186f:	55                   	push   %ebp
  801870:	89 e5                	mov    %esp,%ebp
  801872:	53                   	push   %ebx
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  801879:	8b 53 04             	mov    0x4(%ebx),%edx
  80187c:	8d 42 01             	lea    0x1(%edx),%eax
  80187f:	89 43 04             	mov    %eax,0x4(%ebx)
  801882:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801885:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801889:	3d 00 01 00 00       	cmp    $0x100,%eax
  80188e:	74 06                	je     801896 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  801890:	83 c4 04             	add    $0x4,%esp
  801893:	5b                   	pop    %ebx
  801894:	5d                   	pop    %ebp
  801895:	c3                   	ret    
		writebuf(b);
  801896:	89 d8                	mov    %ebx,%eax
  801898:	e8 93 ff ff ff       	call   801830 <writebuf>
		b->idx = 0;
  80189d:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  8018a4:	eb ea                	jmp    801890 <putch+0x21>

008018a6 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  8018af:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b2:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8018b8:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8018bf:	00 00 00 
	b.result = 0;
  8018c2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8018c9:	00 00 00 
	b.error = 1;
  8018cc:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8018d3:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8018d6:	ff 75 10             	pushl  0x10(%ebp)
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	68 6f 18 80 00       	push   $0x80186f
  8018e8:	e8 38 ea ff ff       	call   800325 <vprintfmt>
	if (b.idx > 0)
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8018f7:	7e 0b                	jle    801904 <vfprintf+0x5e>
		writebuf(&b);
  8018f9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8018ff:	e8 2c ff ff ff       	call   801830 <writebuf>

	return (b.result ? b.result : b.error);
  801904:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  80190a:	85 c0                	test   %eax,%eax
  80190c:	75 06                	jne    801914 <vfprintf+0x6e>
  80190e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80191c:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80191f:	50                   	push   %eax
  801920:	ff 75 0c             	pushl  0xc(%ebp)
  801923:	ff 75 08             	pushl  0x8(%ebp)
  801926:	e8 7b ff ff ff       	call   8018a6 <vfprintf>
	va_end(ap);

	return cnt;
}
  80192b:	c9                   	leave  
  80192c:	c3                   	ret    

0080192d <printf>:

int
printf(const char *fmt, ...)
{
  80192d:	55                   	push   %ebp
  80192e:	89 e5                	mov    %esp,%ebp
  801930:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801933:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  801936:	50                   	push   %eax
  801937:	ff 75 08             	pushl  0x8(%ebp)
  80193a:	6a 01                	push   $0x1
  80193c:	e8 65 ff ff ff       	call   8018a6 <vfprintf>
	va_end(ap);

	return cnt;
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	56                   	push   %esi
  801947:	53                   	push   %ebx
  801948:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80194b:	83 ec 0c             	sub    $0xc,%esp
  80194e:	ff 75 08             	pushl  0x8(%ebp)
  801951:	e8 b0 f6 ff ff       	call   801006 <fd2data>
  801956:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801958:	83 c4 08             	add    $0x8,%esp
  80195b:	68 8b 26 80 00       	push   $0x80268b
  801960:	53                   	push   %ebx
  801961:	e8 cd ee ff ff       	call   800833 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801966:	8b 46 04             	mov    0x4(%esi),%eax
  801969:	2b 06                	sub    (%esi),%eax
  80196b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801971:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801978:	10 00 00 
	stat->st_dev = &devpipe;
  80197b:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801982:	30 80 00 
	return 0;
}
  801985:	b8 00 00 00 00       	mov    $0x0,%eax
  80198a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80198d:	5b                   	pop    %ebx
  80198e:	5e                   	pop    %esi
  80198f:	5d                   	pop    %ebp
  801990:	c3                   	ret    

00801991 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
  801994:	53                   	push   %ebx
  801995:	83 ec 0c             	sub    $0xc,%esp
  801998:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80199b:	53                   	push   %ebx
  80199c:	6a 00                	push   $0x0
  80199e:	e8 ca f2 ff ff       	call   800c6d <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  8019a3:	89 1c 24             	mov    %ebx,(%esp)
  8019a6:	e8 5b f6 ff ff       	call   801006 <fd2data>
  8019ab:	83 c4 08             	add    $0x8,%esp
  8019ae:	50                   	push   %eax
  8019af:	6a 00                	push   $0x0
  8019b1:	e8 b7 f2 ff ff       	call   800c6d <sys_page_unmap>
}
  8019b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <_pipeisclosed>:
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
  8019be:	57                   	push   %edi
  8019bf:	56                   	push   %esi
  8019c0:	53                   	push   %ebx
  8019c1:	83 ec 1c             	sub    $0x1c,%esp
  8019c4:	89 c7                	mov    %eax,%edi
  8019c6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8019c8:	a1 04 40 80 00       	mov    0x804004,%eax
  8019cd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8019d0:	83 ec 0c             	sub    $0xc,%esp
  8019d3:	57                   	push   %edi
  8019d4:	e8 e1 05 00 00       	call   801fba <pageref>
  8019d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019dc:	89 34 24             	mov    %esi,(%esp)
  8019df:	e8 d6 05 00 00       	call   801fba <pageref>
		nn = thisenv->env_runs;
  8019e4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8019ea:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8019ed:	83 c4 10             	add    $0x10,%esp
  8019f0:	39 cb                	cmp    %ecx,%ebx
  8019f2:	74 1b                	je     801a0f <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8019f4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8019f7:	75 cf                	jne    8019c8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8019f9:	8b 42 58             	mov    0x58(%edx),%eax
  8019fc:	6a 01                	push   $0x1
  8019fe:	50                   	push   %eax
  8019ff:	53                   	push   %ebx
  801a00:	68 92 26 80 00       	push   $0x802692
  801a05:	e8 21 e8 ff ff       	call   80022b <cprintf>
  801a0a:	83 c4 10             	add    $0x10,%esp
  801a0d:	eb b9                	jmp    8019c8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801a0f:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801a12:	0f 94 c0             	sete   %al
  801a15:	0f b6 c0             	movzbl %al,%eax
}
  801a18:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a1b:	5b                   	pop    %ebx
  801a1c:	5e                   	pop    %esi
  801a1d:	5f                   	pop    %edi
  801a1e:	5d                   	pop    %ebp
  801a1f:	c3                   	ret    

00801a20 <devpipe_write>:
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	57                   	push   %edi
  801a24:	56                   	push   %esi
  801a25:	53                   	push   %ebx
  801a26:	83 ec 18             	sub    $0x18,%esp
  801a29:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801a2c:	56                   	push   %esi
  801a2d:	e8 d4 f5 ff ff       	call   801006 <fd2data>
  801a32:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801a34:	83 c4 10             	add    $0x10,%esp
  801a37:	bf 00 00 00 00       	mov    $0x0,%edi
  801a3c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801a3f:	74 41                	je     801a82 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801a41:	8b 53 04             	mov    0x4(%ebx),%edx
  801a44:	8b 03                	mov    (%ebx),%eax
  801a46:	83 c0 20             	add    $0x20,%eax
  801a49:	39 c2                	cmp    %eax,%edx
  801a4b:	72 14                	jb     801a61 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801a4d:	89 da                	mov    %ebx,%edx
  801a4f:	89 f0                	mov    %esi,%eax
  801a51:	e8 65 ff ff ff       	call   8019bb <_pipeisclosed>
  801a56:	85 c0                	test   %eax,%eax
  801a58:	75 2c                	jne    801a86 <devpipe_write+0x66>
			sys_yield();
  801a5a:	e8 50 f2 ff ff       	call   800caf <sys_yield>
  801a5f:	eb e0                	jmp    801a41 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a61:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a64:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801a67:	89 d0                	mov    %edx,%eax
  801a69:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801a6e:	78 0b                	js     801a7b <devpipe_write+0x5b>
  801a70:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801a74:	42                   	inc    %edx
  801a75:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801a78:	47                   	inc    %edi
  801a79:	eb c1                	jmp    801a3c <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801a7b:	48                   	dec    %eax
  801a7c:	83 c8 e0             	or     $0xffffffe0,%eax
  801a7f:	40                   	inc    %eax
  801a80:	eb ee                	jmp    801a70 <devpipe_write+0x50>
	return i;
  801a82:	89 f8                	mov    %edi,%eax
  801a84:	eb 05                	jmp    801a8b <devpipe_write+0x6b>
				return 0;
  801a86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801a8e:	5b                   	pop    %ebx
  801a8f:	5e                   	pop    %esi
  801a90:	5f                   	pop    %edi
  801a91:	5d                   	pop    %ebp
  801a92:	c3                   	ret    

00801a93 <devpipe_read>:
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
  801a96:	57                   	push   %edi
  801a97:	56                   	push   %esi
  801a98:	53                   	push   %ebx
  801a99:	83 ec 18             	sub    $0x18,%esp
  801a9c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801a9f:	57                   	push   %edi
  801aa0:	e8 61 f5 ff ff       	call   801006 <fd2data>
  801aa5:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801aa7:	83 c4 10             	add    $0x10,%esp
  801aaa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801aaf:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801ab2:	74 46                	je     801afa <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801ab4:	8b 06                	mov    (%esi),%eax
  801ab6:	3b 46 04             	cmp    0x4(%esi),%eax
  801ab9:	75 22                	jne    801add <devpipe_read+0x4a>
			if (i > 0)
  801abb:	85 db                	test   %ebx,%ebx
  801abd:	74 0a                	je     801ac9 <devpipe_read+0x36>
				return i;
  801abf:	89 d8                	mov    %ebx,%eax
}
  801ac1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ac4:	5b                   	pop    %ebx
  801ac5:	5e                   	pop    %esi
  801ac6:	5f                   	pop    %edi
  801ac7:	5d                   	pop    %ebp
  801ac8:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801ac9:	89 f2                	mov    %esi,%edx
  801acb:	89 f8                	mov    %edi,%eax
  801acd:	e8 e9 fe ff ff       	call   8019bb <_pipeisclosed>
  801ad2:	85 c0                	test   %eax,%eax
  801ad4:	75 28                	jne    801afe <devpipe_read+0x6b>
			sys_yield();
  801ad6:	e8 d4 f1 ff ff       	call   800caf <sys_yield>
  801adb:	eb d7                	jmp    801ab4 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801add:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801ae2:	78 0f                	js     801af3 <devpipe_read+0x60>
  801ae4:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801ae8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801aeb:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801aee:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801af0:	43                   	inc    %ebx
  801af1:	eb bc                	jmp    801aaf <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801af3:	48                   	dec    %eax
  801af4:	83 c8 e0             	or     $0xffffffe0,%eax
  801af7:	40                   	inc    %eax
  801af8:	eb ea                	jmp    801ae4 <devpipe_read+0x51>
	return i;
  801afa:	89 d8                	mov    %ebx,%eax
  801afc:	eb c3                	jmp    801ac1 <devpipe_read+0x2e>
				return 0;
  801afe:	b8 00 00 00 00       	mov    $0x0,%eax
  801b03:	eb bc                	jmp    801ac1 <devpipe_read+0x2e>

00801b05 <pipe>:
{
  801b05:	55                   	push   %ebp
  801b06:	89 e5                	mov    %esp,%ebp
  801b08:	56                   	push   %esi
  801b09:	53                   	push   %ebx
  801b0a:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801b0d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b10:	50                   	push   %eax
  801b11:	e8 07 f5 ff ff       	call   80101d <fd_alloc>
  801b16:	89 c3                	mov    %eax,%ebx
  801b18:	83 c4 10             	add    $0x10,%esp
  801b1b:	85 c0                	test   %eax,%eax
  801b1d:	0f 88 2a 01 00 00    	js     801c4d <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b23:	83 ec 04             	sub    $0x4,%esp
  801b26:	68 07 04 00 00       	push   $0x407
  801b2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b2e:	6a 00                	push   $0x0
  801b30:	e8 b3 f0 ff ff       	call   800be8 <sys_page_alloc>
  801b35:	89 c3                	mov    %eax,%ebx
  801b37:	83 c4 10             	add    $0x10,%esp
  801b3a:	85 c0                	test   %eax,%eax
  801b3c:	0f 88 0b 01 00 00    	js     801c4d <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801b42:	83 ec 0c             	sub    $0xc,%esp
  801b45:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801b48:	50                   	push   %eax
  801b49:	e8 cf f4 ff ff       	call   80101d <fd_alloc>
  801b4e:	89 c3                	mov    %eax,%ebx
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	85 c0                	test   %eax,%eax
  801b55:	0f 88 e2 00 00 00    	js     801c3d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b5b:	83 ec 04             	sub    $0x4,%esp
  801b5e:	68 07 04 00 00       	push   $0x407
  801b63:	ff 75 f0             	pushl  -0x10(%ebp)
  801b66:	6a 00                	push   $0x0
  801b68:	e8 7b f0 ff ff       	call   800be8 <sys_page_alloc>
  801b6d:	89 c3                	mov    %eax,%ebx
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	85 c0                	test   %eax,%eax
  801b74:	0f 88 c3 00 00 00    	js     801c3d <pipe+0x138>
	va = fd2data(fd0);
  801b7a:	83 ec 0c             	sub    $0xc,%esp
  801b7d:	ff 75 f4             	pushl  -0xc(%ebp)
  801b80:	e8 81 f4 ff ff       	call   801006 <fd2data>
  801b85:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801b87:	83 c4 0c             	add    $0xc,%esp
  801b8a:	68 07 04 00 00       	push   $0x407
  801b8f:	50                   	push   %eax
  801b90:	6a 00                	push   $0x0
  801b92:	e8 51 f0 ff ff       	call   800be8 <sys_page_alloc>
  801b97:	89 c3                	mov    %eax,%ebx
  801b99:	83 c4 10             	add    $0x10,%esp
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	0f 88 89 00 00 00    	js     801c2d <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ba4:	83 ec 0c             	sub    $0xc,%esp
  801ba7:	ff 75 f0             	pushl  -0x10(%ebp)
  801baa:	e8 57 f4 ff ff       	call   801006 <fd2data>
  801baf:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801bb6:	50                   	push   %eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	56                   	push   %esi
  801bba:	6a 00                	push   $0x0
  801bbc:	e8 6a f0 ff ff       	call   800c2b <sys_page_map>
  801bc1:	89 c3                	mov    %eax,%ebx
  801bc3:	83 c4 20             	add    $0x20,%esp
  801bc6:	85 c0                	test   %eax,%eax
  801bc8:	78 55                	js     801c1f <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801bca:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801bd0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801bdf:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801be5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801be8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801bea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bed:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfa:	e8 f7 f3 ff ff       	call   800ff6 <fd2num>
  801bff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c02:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801c04:	83 c4 04             	add    $0x4,%esp
  801c07:	ff 75 f0             	pushl  -0x10(%ebp)
  801c0a:	e8 e7 f3 ff ff       	call   800ff6 <fd2num>
  801c0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c12:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801c15:	83 c4 10             	add    $0x10,%esp
  801c18:	bb 00 00 00 00       	mov    $0x0,%ebx
  801c1d:	eb 2e                	jmp    801c4d <pipe+0x148>
	sys_page_unmap(0, va);
  801c1f:	83 ec 08             	sub    $0x8,%esp
  801c22:	56                   	push   %esi
  801c23:	6a 00                	push   $0x0
  801c25:	e8 43 f0 ff ff       	call   800c6d <sys_page_unmap>
  801c2a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801c2d:	83 ec 08             	sub    $0x8,%esp
  801c30:	ff 75 f0             	pushl  -0x10(%ebp)
  801c33:	6a 00                	push   $0x0
  801c35:	e8 33 f0 ff ff       	call   800c6d <sys_page_unmap>
  801c3a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801c3d:	83 ec 08             	sub    $0x8,%esp
  801c40:	ff 75 f4             	pushl  -0xc(%ebp)
  801c43:	6a 00                	push   $0x0
  801c45:	e8 23 f0 ff ff       	call   800c6d <sys_page_unmap>
  801c4a:	83 c4 10             	add    $0x10,%esp
}
  801c4d:	89 d8                	mov    %ebx,%eax
  801c4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c52:	5b                   	pop    %ebx
  801c53:	5e                   	pop    %esi
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <pipeisclosed>:
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
  801c59:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c5f:	50                   	push   %eax
  801c60:	ff 75 08             	pushl  0x8(%ebp)
  801c63:	e8 04 f4 ff ff       	call   80106c <fd_lookup>
  801c68:	83 c4 10             	add    $0x10,%esp
  801c6b:	85 c0                	test   %eax,%eax
  801c6d:	78 18                	js     801c87 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801c6f:	83 ec 0c             	sub    $0xc,%esp
  801c72:	ff 75 f4             	pushl  -0xc(%ebp)
  801c75:	e8 8c f3 ff ff       	call   801006 <fd2data>
	return _pipeisclosed(fd, p);
  801c7a:	89 c2                	mov    %eax,%edx
  801c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c7f:	e8 37 fd ff ff       	call   8019bb <_pipeisclosed>
  801c84:	83 c4 10             	add    $0x10,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801c8c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c91:	5d                   	pop    %ebp
  801c92:	c3                   	ret    

00801c93 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
  801c96:	53                   	push   %ebx
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801c9d:	68 aa 26 80 00       	push   $0x8026aa
  801ca2:	53                   	push   %ebx
  801ca3:	e8 8b eb ff ff       	call   800833 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801ca8:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801caf:	20 00 00 
	return 0;
}
  801cb2:	b8 00 00 00 00       	mov    $0x0,%eax
  801cb7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cba:	c9                   	leave  
  801cbb:	c3                   	ret    

00801cbc <devcons_write>:
{
  801cbc:	55                   	push   %ebp
  801cbd:	89 e5                	mov    %esp,%ebp
  801cbf:	57                   	push   %edi
  801cc0:	56                   	push   %esi
  801cc1:	53                   	push   %ebx
  801cc2:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801cc8:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801ccd:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801cd3:	eb 1d                	jmp    801cf2 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801cd5:	83 ec 04             	sub    $0x4,%esp
  801cd8:	53                   	push   %ebx
  801cd9:	03 45 0c             	add    0xc(%ebp),%eax
  801cdc:	50                   	push   %eax
  801cdd:	57                   	push   %edi
  801cde:	e8 c3 ec ff ff       	call   8009a6 <memmove>
		sys_cputs(buf, m);
  801ce3:	83 c4 08             	add    $0x8,%esp
  801ce6:	53                   	push   %ebx
  801ce7:	57                   	push   %edi
  801ce8:	e8 5e ee ff ff       	call   800b4b <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801ced:	01 de                	add    %ebx,%esi
  801cef:	83 c4 10             	add    $0x10,%esp
  801cf2:	89 f0                	mov    %esi,%eax
  801cf4:	3b 75 10             	cmp    0x10(%ebp),%esi
  801cf7:	73 11                	jae    801d0a <devcons_write+0x4e>
		m = n - tot;
  801cf9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801cfc:	29 f3                	sub    %esi,%ebx
  801cfe:	83 fb 7f             	cmp    $0x7f,%ebx
  801d01:	76 d2                	jbe    801cd5 <devcons_write+0x19>
  801d03:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801d08:	eb cb                	jmp    801cd5 <devcons_write+0x19>
}
  801d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d0d:	5b                   	pop    %ebx
  801d0e:	5e                   	pop    %esi
  801d0f:	5f                   	pop    %edi
  801d10:	5d                   	pop    %ebp
  801d11:	c3                   	ret    

00801d12 <devcons_read>:
{
  801d12:	55                   	push   %ebp
  801d13:	89 e5                	mov    %esp,%ebp
  801d15:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801d1c:	75 0c                	jne    801d2a <devcons_read+0x18>
		return 0;
  801d1e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d23:	eb 21                	jmp    801d46 <devcons_read+0x34>
		sys_yield();
  801d25:	e8 85 ef ff ff       	call   800caf <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801d2a:	e8 3a ee ff ff       	call   800b69 <sys_cgetc>
  801d2f:	85 c0                	test   %eax,%eax
  801d31:	74 f2                	je     801d25 <devcons_read+0x13>
	if (c < 0)
  801d33:	85 c0                	test   %eax,%eax
  801d35:	78 0f                	js     801d46 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801d37:	83 f8 04             	cmp    $0x4,%eax
  801d3a:	74 0c                	je     801d48 <devcons_read+0x36>
	*(char*)vbuf = c;
  801d3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d3f:	88 02                	mov    %al,(%edx)
	return 1;
  801d41:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    
		return 0;
  801d48:	b8 00 00 00 00       	mov    $0x0,%eax
  801d4d:	eb f7                	jmp    801d46 <devcons_read+0x34>

00801d4f <cputchar>:
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
  801d52:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801d55:	8b 45 08             	mov    0x8(%ebp),%eax
  801d58:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801d5b:	6a 01                	push   $0x1
  801d5d:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d60:	50                   	push   %eax
  801d61:	e8 e5 ed ff ff       	call   800b4b <sys_cputs>
}
  801d66:	83 c4 10             	add    $0x10,%esp
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <getchar>:
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
  801d6e:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801d71:	6a 01                	push   $0x1
  801d73:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801d76:	50                   	push   %eax
  801d77:	6a 00                	push   $0x0
  801d79:	e8 5b f5 ff ff       	call   8012d9 <read>
	if (r < 0)
  801d7e:	83 c4 10             	add    $0x10,%esp
  801d81:	85 c0                	test   %eax,%eax
  801d83:	78 08                	js     801d8d <getchar+0x22>
	if (r < 1)
  801d85:	85 c0                	test   %eax,%eax
  801d87:	7e 06                	jle    801d8f <getchar+0x24>
	return c;
  801d89:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    
		return -E_EOF;
  801d8f:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801d94:	eb f7                	jmp    801d8d <getchar+0x22>

00801d96 <iscons>:
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
  801d99:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d9c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d9f:	50                   	push   %eax
  801da0:	ff 75 08             	pushl  0x8(%ebp)
  801da3:	e8 c4 f2 ff ff       	call   80106c <fd_lookup>
  801da8:	83 c4 10             	add    $0x10,%esp
  801dab:	85 c0                	test   %eax,%eax
  801dad:	78 11                	js     801dc0 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801db8:	39 10                	cmp    %edx,(%eax)
  801dba:	0f 94 c0             	sete   %al
  801dbd:	0f b6 c0             	movzbl %al,%eax
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <opencons>:
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
  801dc5:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801dc8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801dcb:	50                   	push   %eax
  801dcc:	e8 4c f2 ff ff       	call   80101d <fd_alloc>
  801dd1:	83 c4 10             	add    $0x10,%esp
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	78 3a                	js     801e12 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801dd8:	83 ec 04             	sub    $0x4,%esp
  801ddb:	68 07 04 00 00       	push   $0x407
  801de0:	ff 75 f4             	pushl  -0xc(%ebp)
  801de3:	6a 00                	push   $0x0
  801de5:	e8 fe ed ff ff       	call   800be8 <sys_page_alloc>
  801dea:	83 c4 10             	add    $0x10,%esp
  801ded:	85 c0                	test   %eax,%eax
  801def:	78 21                	js     801e12 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801df1:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dfa:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801dfc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dff:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	50                   	push   %eax
  801e0a:	e8 e7 f1 ff ff       	call   800ff6 <fd2num>
  801e0f:	83 c4 10             	add    $0x10,%esp
}
  801e12:	c9                   	leave  
  801e13:	c3                   	ret    

00801e14 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801e14:	55                   	push   %ebp
  801e15:	89 e5                	mov    %esp,%ebp
  801e17:	57                   	push   %edi
  801e18:	56                   	push   %esi
  801e19:	53                   	push   %ebx
  801e1a:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801e20:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801e23:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801e29:	e8 9b ed ff ff       	call   800bc9 <sys_getenvid>
  801e2e:	83 ec 04             	sub    $0x4,%esp
  801e31:	ff 75 0c             	pushl  0xc(%ebp)
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	53                   	push   %ebx
  801e38:	50                   	push   %eax
  801e39:	68 b8 26 80 00       	push   $0x8026b8
  801e3e:	68 00 01 00 00       	push   $0x100
  801e43:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801e49:	56                   	push   %esi
  801e4a:	e8 97 e9 ff ff       	call   8007e6 <snprintf>
  801e4f:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801e51:	83 c4 20             	add    $0x20,%esp
  801e54:	57                   	push   %edi
  801e55:	ff 75 10             	pushl  0x10(%ebp)
  801e58:	bf 00 01 00 00       	mov    $0x100,%edi
  801e5d:	89 f8                	mov    %edi,%eax
  801e5f:	29 d8                	sub    %ebx,%eax
  801e61:	50                   	push   %eax
  801e62:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e65:	50                   	push   %eax
  801e66:	e8 26 e9 ff ff       	call   800791 <vsnprintf>
  801e6b:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e6d:	83 c4 0c             	add    $0xc,%esp
  801e70:	68 70 22 80 00       	push   $0x802270
  801e75:	29 df                	sub    %ebx,%edi
  801e77:	57                   	push   %edi
  801e78:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801e7b:	50                   	push   %eax
  801e7c:	e8 65 e9 ff ff       	call   8007e6 <snprintf>
	sys_cputs(buf, r);
  801e81:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801e84:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801e86:	53                   	push   %ebx
  801e87:	56                   	push   %esi
  801e88:	e8 be ec ff ff       	call   800b4b <sys_cputs>
  801e8d:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801e90:	cc                   	int3   
  801e91:	eb fd                	jmp    801e90 <_panic+0x7c>

00801e93 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
  801e96:	57                   	push   %edi
  801e97:	56                   	push   %esi
  801e98:	53                   	push   %ebx
  801e99:	83 ec 0c             	sub    $0xc,%esp
  801e9c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801e9f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801ea2:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801ea5:	85 ff                	test   %edi,%edi
  801ea7:	74 53                	je     801efc <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801ea9:	83 ec 0c             	sub    $0xc,%esp
  801eac:	57                   	push   %edi
  801ead:	e8 46 ef ff ff       	call   800df8 <sys_ipc_recv>
  801eb2:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801eb5:	85 db                	test   %ebx,%ebx
  801eb7:	74 0b                	je     801ec4 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801eb9:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ebf:	8b 52 74             	mov    0x74(%edx),%edx
  801ec2:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801ec4:	85 f6                	test   %esi,%esi
  801ec6:	74 0f                	je     801ed7 <ipc_recv+0x44>
  801ec8:	85 ff                	test   %edi,%edi
  801eca:	74 0b                	je     801ed7 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801ecc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ed2:	8b 52 78             	mov    0x78(%edx),%edx
  801ed5:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801ed7:	85 c0                	test   %eax,%eax
  801ed9:	74 30                	je     801f0b <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801edb:	85 db                	test   %ebx,%ebx
  801edd:	74 06                	je     801ee5 <ipc_recv+0x52>
      		*from_env_store = 0;
  801edf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801ee5:	85 f6                	test   %esi,%esi
  801ee7:	74 2c                	je     801f15 <ipc_recv+0x82>
      		*perm_store = 0;
  801ee9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801eef:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801ef4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ef7:	5b                   	pop    %ebx
  801ef8:	5e                   	pop    %esi
  801ef9:	5f                   	pop    %edi
  801efa:	5d                   	pop    %ebp
  801efb:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801efc:	83 ec 0c             	sub    $0xc,%esp
  801eff:	6a ff                	push   $0xffffffff
  801f01:	e8 f2 ee ff ff       	call   800df8 <sys_ipc_recv>
  801f06:	83 c4 10             	add    $0x10,%esp
  801f09:	eb aa                	jmp    801eb5 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801f0b:	a1 04 40 80 00       	mov    0x804004,%eax
  801f10:	8b 40 70             	mov    0x70(%eax),%eax
  801f13:	eb df                	jmp    801ef4 <ipc_recv+0x61>
		return -1;
  801f15:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801f1a:	eb d8                	jmp    801ef4 <ipc_recv+0x61>

00801f1c <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801f1c:	55                   	push   %ebp
  801f1d:	89 e5                	mov    %esp,%ebp
  801f1f:	57                   	push   %edi
  801f20:	56                   	push   %esi
  801f21:	53                   	push   %ebx
  801f22:	83 ec 0c             	sub    $0xc,%esp
  801f25:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f28:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801f2b:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801f2e:	85 db                	test   %ebx,%ebx
  801f30:	75 22                	jne    801f54 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801f32:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801f37:	eb 1b                	jmp    801f54 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f39:	68 dc 26 80 00       	push   $0x8026dc
  801f3e:	68 5f 26 80 00       	push   $0x80265f
  801f43:	6a 48                	push   $0x48
  801f45:	68 00 27 80 00       	push   $0x802700
  801f4a:	e8 c5 fe ff ff       	call   801e14 <_panic>
		sys_yield();
  801f4f:	e8 5b ed ff ff       	call   800caf <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801f54:	57                   	push   %edi
  801f55:	53                   	push   %ebx
  801f56:	56                   	push   %esi
  801f57:	ff 75 08             	pushl  0x8(%ebp)
  801f5a:	e8 76 ee ff ff       	call   800dd5 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801f5f:	83 c4 10             	add    $0x10,%esp
  801f62:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801f65:	74 e8                	je     801f4f <ipc_send+0x33>
  801f67:	85 c0                	test   %eax,%eax
  801f69:	75 ce                	jne    801f39 <ipc_send+0x1d>
		sys_yield();
  801f6b:	e8 3f ed ff ff       	call   800caf <sys_yield>
		
	}
	
}
  801f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f73:	5b                   	pop    %ebx
  801f74:	5e                   	pop    %esi
  801f75:	5f                   	pop    %edi
  801f76:	5d                   	pop    %ebp
  801f77:	c3                   	ret    

00801f78 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801f7e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801f83:	89 c2                	mov    %eax,%edx
  801f85:	c1 e2 05             	shl    $0x5,%edx
  801f88:	29 c2                	sub    %eax,%edx
  801f8a:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801f91:	8b 52 50             	mov    0x50(%edx),%edx
  801f94:	39 ca                	cmp    %ecx,%edx
  801f96:	74 0f                	je     801fa7 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801f98:	40                   	inc    %eax
  801f99:	3d 00 04 00 00       	cmp    $0x400,%eax
  801f9e:	75 e3                	jne    801f83 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	eb 11                	jmp    801fb8 <ipc_find_env+0x40>
			return envs[i].env_id;
  801fa7:	89 c2                	mov    %eax,%edx
  801fa9:	c1 e2 05             	shl    $0x5,%edx
  801fac:	29 c2                	sub    %eax,%edx
  801fae:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801fb5:	8b 40 48             	mov    0x48(%eax),%eax
}
  801fb8:	5d                   	pop    %ebp
  801fb9:	c3                   	ret    

00801fba <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801fba:	55                   	push   %ebp
  801fbb:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc0:	c1 e8 16             	shr    $0x16,%eax
  801fc3:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801fca:	a8 01                	test   $0x1,%al
  801fcc:	74 21                	je     801fef <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801fce:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd1:	c1 e8 0c             	shr    $0xc,%eax
  801fd4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801fdb:	a8 01                	test   $0x1,%al
  801fdd:	74 17                	je     801ff6 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801fdf:	c1 e8 0c             	shr    $0xc,%eax
  801fe2:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801fe9:	ef 
  801fea:	0f b7 c0             	movzwl %ax,%eax
  801fed:	eb 05                	jmp    801ff4 <pageref+0x3a>
		return 0;
  801fef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ff4:	5d                   	pop    %ebp
  801ff5:	c3                   	ret    
		return 0;
  801ff6:	b8 00 00 00 00       	mov    $0x0,%eax
  801ffb:	eb f7                	jmp    801ff4 <pageref+0x3a>
  801ffd:	66 90                	xchg   %ax,%ax
  801fff:	90                   	nop

00802000 <__udivdi3>:
  802000:	55                   	push   %ebp
  802001:	57                   	push   %edi
  802002:	56                   	push   %esi
  802003:	53                   	push   %ebx
  802004:	83 ec 1c             	sub    $0x1c,%esp
  802007:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80200b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80200f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802013:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  802017:	89 ca                	mov    %ecx,%edx
  802019:	89 f8                	mov    %edi,%eax
  80201b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80201f:	85 f6                	test   %esi,%esi
  802021:	75 2d                	jne    802050 <__udivdi3+0x50>
  802023:	39 cf                	cmp    %ecx,%edi
  802025:	77 65                	ja     80208c <__udivdi3+0x8c>
  802027:	89 fd                	mov    %edi,%ebp
  802029:	85 ff                	test   %edi,%edi
  80202b:	75 0b                	jne    802038 <__udivdi3+0x38>
  80202d:	b8 01 00 00 00       	mov    $0x1,%eax
  802032:	31 d2                	xor    %edx,%edx
  802034:	f7 f7                	div    %edi
  802036:	89 c5                	mov    %eax,%ebp
  802038:	31 d2                	xor    %edx,%edx
  80203a:	89 c8                	mov    %ecx,%eax
  80203c:	f7 f5                	div    %ebp
  80203e:	89 c1                	mov    %eax,%ecx
  802040:	89 d8                	mov    %ebx,%eax
  802042:	f7 f5                	div    %ebp
  802044:	89 cf                	mov    %ecx,%edi
  802046:	89 fa                	mov    %edi,%edx
  802048:	83 c4 1c             	add    $0x1c,%esp
  80204b:	5b                   	pop    %ebx
  80204c:	5e                   	pop    %esi
  80204d:	5f                   	pop    %edi
  80204e:	5d                   	pop    %ebp
  80204f:	c3                   	ret    
  802050:	39 ce                	cmp    %ecx,%esi
  802052:	77 28                	ja     80207c <__udivdi3+0x7c>
  802054:	0f bd fe             	bsr    %esi,%edi
  802057:	83 f7 1f             	xor    $0x1f,%edi
  80205a:	75 40                	jne    80209c <__udivdi3+0x9c>
  80205c:	39 ce                	cmp    %ecx,%esi
  80205e:	72 0a                	jb     80206a <__udivdi3+0x6a>
  802060:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802064:	0f 87 9e 00 00 00    	ja     802108 <__udivdi3+0x108>
  80206a:	b8 01 00 00 00       	mov    $0x1,%eax
  80206f:	89 fa                	mov    %edi,%edx
  802071:	83 c4 1c             	add    $0x1c,%esp
  802074:	5b                   	pop    %ebx
  802075:	5e                   	pop    %esi
  802076:	5f                   	pop    %edi
  802077:	5d                   	pop    %ebp
  802078:	c3                   	ret    
  802079:	8d 76 00             	lea    0x0(%esi),%esi
  80207c:	31 ff                	xor    %edi,%edi
  80207e:	31 c0                	xor    %eax,%eax
  802080:	89 fa                	mov    %edi,%edx
  802082:	83 c4 1c             	add    $0x1c,%esp
  802085:	5b                   	pop    %ebx
  802086:	5e                   	pop    %esi
  802087:	5f                   	pop    %edi
  802088:	5d                   	pop    %ebp
  802089:	c3                   	ret    
  80208a:	66 90                	xchg   %ax,%ax
  80208c:	89 d8                	mov    %ebx,%eax
  80208e:	f7 f7                	div    %edi
  802090:	31 ff                	xor    %edi,%edi
  802092:	89 fa                	mov    %edi,%edx
  802094:	83 c4 1c             	add    $0x1c,%esp
  802097:	5b                   	pop    %ebx
  802098:	5e                   	pop    %esi
  802099:	5f                   	pop    %edi
  80209a:	5d                   	pop    %ebp
  80209b:	c3                   	ret    
  80209c:	bd 20 00 00 00       	mov    $0x20,%ebp
  8020a1:	29 fd                	sub    %edi,%ebp
  8020a3:	89 f9                	mov    %edi,%ecx
  8020a5:	d3 e6                	shl    %cl,%esi
  8020a7:	89 c3                	mov    %eax,%ebx
  8020a9:	89 e9                	mov    %ebp,%ecx
  8020ab:	d3 eb                	shr    %cl,%ebx
  8020ad:	89 d9                	mov    %ebx,%ecx
  8020af:	09 f1                	or     %esi,%ecx
  8020b1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8020b5:	89 f9                	mov    %edi,%ecx
  8020b7:	d3 e0                	shl    %cl,%eax
  8020b9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8020bd:	89 d6                	mov    %edx,%esi
  8020bf:	89 e9                	mov    %ebp,%ecx
  8020c1:	d3 ee                	shr    %cl,%esi
  8020c3:	89 f9                	mov    %edi,%ecx
  8020c5:	d3 e2                	shl    %cl,%edx
  8020c7:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8020cb:	89 e9                	mov    %ebp,%ecx
  8020cd:	d3 eb                	shr    %cl,%ebx
  8020cf:	09 da                	or     %ebx,%edx
  8020d1:	89 d0                	mov    %edx,%eax
  8020d3:	89 f2                	mov    %esi,%edx
  8020d5:	f7 74 24 08          	divl   0x8(%esp)
  8020d9:	89 d6                	mov    %edx,%esi
  8020db:	89 c3                	mov    %eax,%ebx
  8020dd:	f7 64 24 0c          	mull   0xc(%esp)
  8020e1:	39 d6                	cmp    %edx,%esi
  8020e3:	72 17                	jb     8020fc <__udivdi3+0xfc>
  8020e5:	74 09                	je     8020f0 <__udivdi3+0xf0>
  8020e7:	89 d8                	mov    %ebx,%eax
  8020e9:	31 ff                	xor    %edi,%edi
  8020eb:	e9 56 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  8020f0:	8b 54 24 04          	mov    0x4(%esp),%edx
  8020f4:	89 f9                	mov    %edi,%ecx
  8020f6:	d3 e2                	shl    %cl,%edx
  8020f8:	39 c2                	cmp    %eax,%edx
  8020fa:	73 eb                	jae    8020e7 <__udivdi3+0xe7>
  8020fc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8020ff:	31 ff                	xor    %edi,%edi
  802101:	e9 40 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  802106:	66 90                	xchg   %ax,%ax
  802108:	31 c0                	xor    %eax,%eax
  80210a:	e9 37 ff ff ff       	jmp    802046 <__udivdi3+0x46>
  80210f:	90                   	nop

00802110 <__umoddi3>:
  802110:	55                   	push   %ebp
  802111:	57                   	push   %edi
  802112:	56                   	push   %esi
  802113:	53                   	push   %ebx
  802114:	83 ec 1c             	sub    $0x1c,%esp
  802117:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80211b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80211f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802123:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  802127:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80212b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80212f:	89 3c 24             	mov    %edi,(%esp)
  802132:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802136:	89 f2                	mov    %esi,%edx
  802138:	85 c0                	test   %eax,%eax
  80213a:	75 18                	jne    802154 <__umoddi3+0x44>
  80213c:	39 f7                	cmp    %esi,%edi
  80213e:	0f 86 a0 00 00 00    	jbe    8021e4 <__umoddi3+0xd4>
  802144:	89 c8                	mov    %ecx,%eax
  802146:	f7 f7                	div    %edi
  802148:	89 d0                	mov    %edx,%eax
  80214a:	31 d2                	xor    %edx,%edx
  80214c:	83 c4 1c             	add    $0x1c,%esp
  80214f:	5b                   	pop    %ebx
  802150:	5e                   	pop    %esi
  802151:	5f                   	pop    %edi
  802152:	5d                   	pop    %ebp
  802153:	c3                   	ret    
  802154:	89 f3                	mov    %esi,%ebx
  802156:	39 f0                	cmp    %esi,%eax
  802158:	0f 87 a6 00 00 00    	ja     802204 <__umoddi3+0xf4>
  80215e:	0f bd e8             	bsr    %eax,%ebp
  802161:	83 f5 1f             	xor    $0x1f,%ebp
  802164:	0f 84 a6 00 00 00    	je     802210 <__umoddi3+0x100>
  80216a:	bf 20 00 00 00       	mov    $0x20,%edi
  80216f:	29 ef                	sub    %ebp,%edi
  802171:	89 e9                	mov    %ebp,%ecx
  802173:	d3 e0                	shl    %cl,%eax
  802175:	8b 34 24             	mov    (%esp),%esi
  802178:	89 f2                	mov    %esi,%edx
  80217a:	89 f9                	mov    %edi,%ecx
  80217c:	d3 ea                	shr    %cl,%edx
  80217e:	09 c2                	or     %eax,%edx
  802180:	89 14 24             	mov    %edx,(%esp)
  802183:	89 f2                	mov    %esi,%edx
  802185:	89 e9                	mov    %ebp,%ecx
  802187:	d3 e2                	shl    %cl,%edx
  802189:	89 54 24 04          	mov    %edx,0x4(%esp)
  80218d:	89 de                	mov    %ebx,%esi
  80218f:	89 f9                	mov    %edi,%ecx
  802191:	d3 ee                	shr    %cl,%esi
  802193:	89 e9                	mov    %ebp,%ecx
  802195:	d3 e3                	shl    %cl,%ebx
  802197:	8b 54 24 08          	mov    0x8(%esp),%edx
  80219b:	89 d0                	mov    %edx,%eax
  80219d:	89 f9                	mov    %edi,%ecx
  80219f:	d3 e8                	shr    %cl,%eax
  8021a1:	09 d8                	or     %ebx,%eax
  8021a3:	89 d3                	mov    %edx,%ebx
  8021a5:	89 e9                	mov    %ebp,%ecx
  8021a7:	d3 e3                	shl    %cl,%ebx
  8021a9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ad:	89 f2                	mov    %esi,%edx
  8021af:	f7 34 24             	divl   (%esp)
  8021b2:	89 d6                	mov    %edx,%esi
  8021b4:	f7 64 24 04          	mull   0x4(%esp)
  8021b8:	89 c3                	mov    %eax,%ebx
  8021ba:	89 d1                	mov    %edx,%ecx
  8021bc:	39 d6                	cmp    %edx,%esi
  8021be:	72 7c                	jb     80223c <__umoddi3+0x12c>
  8021c0:	74 72                	je     802234 <__umoddi3+0x124>
  8021c2:	8b 54 24 08          	mov    0x8(%esp),%edx
  8021c6:	29 da                	sub    %ebx,%edx
  8021c8:	19 ce                	sbb    %ecx,%esi
  8021ca:	89 f0                	mov    %esi,%eax
  8021cc:	89 f9                	mov    %edi,%ecx
  8021ce:	d3 e0                	shl    %cl,%eax
  8021d0:	89 e9                	mov    %ebp,%ecx
  8021d2:	d3 ea                	shr    %cl,%edx
  8021d4:	09 d0                	or     %edx,%eax
  8021d6:	89 e9                	mov    %ebp,%ecx
  8021d8:	d3 ee                	shr    %cl,%esi
  8021da:	89 f2                	mov    %esi,%edx
  8021dc:	83 c4 1c             	add    $0x1c,%esp
  8021df:	5b                   	pop    %ebx
  8021e0:	5e                   	pop    %esi
  8021e1:	5f                   	pop    %edi
  8021e2:	5d                   	pop    %ebp
  8021e3:	c3                   	ret    
  8021e4:	89 fd                	mov    %edi,%ebp
  8021e6:	85 ff                	test   %edi,%edi
  8021e8:	75 0b                	jne    8021f5 <__umoddi3+0xe5>
  8021ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8021ef:	31 d2                	xor    %edx,%edx
  8021f1:	f7 f7                	div    %edi
  8021f3:	89 c5                	mov    %eax,%ebp
  8021f5:	89 f0                	mov    %esi,%eax
  8021f7:	31 d2                	xor    %edx,%edx
  8021f9:	f7 f5                	div    %ebp
  8021fb:	89 c8                	mov    %ecx,%eax
  8021fd:	f7 f5                	div    %ebp
  8021ff:	e9 44 ff ff ff       	jmp    802148 <__umoddi3+0x38>
  802204:	89 c8                	mov    %ecx,%eax
  802206:	89 f2                	mov    %esi,%edx
  802208:	83 c4 1c             	add    $0x1c,%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5e                   	pop    %esi
  80220d:	5f                   	pop    %edi
  80220e:	5d                   	pop    %ebp
  80220f:	c3                   	ret    
  802210:	39 f0                	cmp    %esi,%eax
  802212:	72 05                	jb     802219 <__umoddi3+0x109>
  802214:	39 0c 24             	cmp    %ecx,(%esp)
  802217:	77 0c                	ja     802225 <__umoddi3+0x115>
  802219:	89 f2                	mov    %esi,%edx
  80221b:	29 f9                	sub    %edi,%ecx
  80221d:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802221:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802225:	8b 44 24 04          	mov    0x4(%esp),%eax
  802229:	83 c4 1c             	add    $0x1c,%esp
  80222c:	5b                   	pop    %ebx
  80222d:	5e                   	pop    %esi
  80222e:	5f                   	pop    %edi
  80222f:	5d                   	pop    %ebp
  802230:	c3                   	ret    
  802231:	8d 76 00             	lea    0x0(%esi),%esi
  802234:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802238:	73 88                	jae    8021c2 <__umoddi3+0xb2>
  80223a:	66 90                	xchg   %ax,%ax
  80223c:	2b 44 24 04          	sub    0x4(%esp),%eax
  802240:	1b 14 24             	sbb    (%esp),%edx
  802243:	89 d1                	mov    %edx,%ecx
  802245:	89 c3                	mov    %eax,%ebx
  802247:	e9 76 ff ff ff       	jmp    8021c2 <__umoddi3+0xb2>
