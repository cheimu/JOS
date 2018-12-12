
obj/user/cat.debug:     file format elf32-i386


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
  80002c:	e8 fc 00 00 00       	call   80012d <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <cat>:

char buf[8192];

void
cat(int f, char *s)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
	long n;
	int r;

	while ((n = read(f, buf, (long)sizeof(buf))) > 0)
  80003b:	83 ec 04             	sub    $0x4,%esp
  80003e:	68 00 20 00 00       	push   $0x2000
  800043:	68 20 40 80 00       	push   $0x804020
  800048:	56                   	push   %esi
  800049:	e8 05 11 00 00       	call   801153 <read>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	7e 2f                	jle    800086 <cat+0x53>
		if ((r = write(1, buf, n)) != n)
  800057:	83 ec 04             	sub    $0x4,%esp
  80005a:	53                   	push   %ebx
  80005b:	68 20 40 80 00       	push   $0x804020
  800060:	6a 01                	push   $0x1
  800062:	e8 ba 11 00 00       	call   801221 <write>
  800067:	83 c4 10             	add    $0x10,%esp
  80006a:	39 c3                	cmp    %eax,%ebx
  80006c:	74 cd                	je     80003b <cat+0x8>
			panic("write error copying %s: %e", s, r);
  80006e:	83 ec 0c             	sub    $0xc,%esp
  800071:	50                   	push   %eax
  800072:	ff 75 0c             	pushl  0xc(%ebp)
  800075:	68 00 21 80 00       	push   $0x802100
  80007a:	6a 0d                	push   $0xd
  80007c:	68 1b 21 80 00       	push   $0x80211b
  800081:	e8 0d 01 00 00       	call   800193 <_panic>
	if (n < 0)
  800086:	85 c0                	test   %eax,%eax
  800088:	78 07                	js     800091 <cat+0x5e>
		panic("error reading %s: %e", s, n);
}
  80008a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008d:	5b                   	pop    %ebx
  80008e:	5e                   	pop    %esi
  80008f:	5d                   	pop    %ebp
  800090:	c3                   	ret    
		panic("error reading %s: %e", s, n);
  800091:	83 ec 0c             	sub    $0xc,%esp
  800094:	50                   	push   %eax
  800095:	ff 75 0c             	pushl  0xc(%ebp)
  800098:	68 26 21 80 00       	push   $0x802126
  80009d:	6a 0f                	push   $0xf
  80009f:	68 1b 21 80 00       	push   $0x80211b
  8000a4:	e8 ea 00 00 00       	call   800193 <_panic>

008000a9 <umain>:

void
umain(int argc, char **argv)
{
  8000a9:	55                   	push   %ebp
  8000aa:	89 e5                	mov    %esp,%ebp
  8000ac:	57                   	push   %edi
  8000ad:	56                   	push   %esi
  8000ae:	53                   	push   %ebx
  8000af:	83 ec 0c             	sub    $0xc,%esp
  8000b2:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int f, i;

	binaryname = "cat";
  8000b5:	c7 05 00 30 80 00 3b 	movl   $0x80213b,0x803000
  8000bc:	21 80 00 
  8000bf:	bb 01 00 00 00       	mov    $0x1,%ebx
	if (argc == 1)
  8000c4:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
  8000c8:	75 2f                	jne    8000f9 <umain+0x50>
		cat(0, "<stdin>");
  8000ca:	83 ec 08             	sub    $0x8,%esp
  8000cd:	68 3f 21 80 00       	push   $0x80213f
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 5a ff ff ff       	call   800033 <cat>
  8000d9:	83 c4 10             	add    $0x10,%esp
			else {
				cat(f, argv[i]);
				close(f);
			}
		}
}
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
				printf("can't open %s: %e\n", argv[i], f);
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	50                   	push   %eax
  8000e8:	ff 34 9f             	pushl  (%edi,%ebx,4)
  8000eb:	68 47 21 80 00       	push   $0x802147
  8000f0:	e8 b2 16 00 00       	call   8017a7 <printf>
  8000f5:	83 c4 10             	add    $0x10,%esp
		for (i = 1; i < argc; i++) {
  8000f8:	43                   	inc    %ebx
  8000f9:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  8000fc:	7d de                	jge    8000dc <umain+0x33>
			f = open(argv[i], O_RDONLY);
  8000fe:	83 ec 08             	sub    $0x8,%esp
  800101:	6a 00                	push   $0x0
  800103:	ff 34 9f             	pushl  (%edi,%ebx,4)
  800106:	e8 fa 14 00 00       	call   801605 <open>
  80010b:	89 c6                	mov    %eax,%esi
			if (f < 0)
  80010d:	83 c4 10             	add    $0x10,%esp
  800110:	85 c0                	test   %eax,%eax
  800112:	78 d0                	js     8000e4 <umain+0x3b>
				cat(f, argv[i]);
  800114:	83 ec 08             	sub    $0x8,%esp
  800117:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80011a:	50                   	push   %eax
  80011b:	e8 13 ff ff ff       	call   800033 <cat>
				close(f);
  800120:	89 34 24             	mov    %esi,(%esp)
  800123:	e8 f1 0e 00 00       	call   801019 <close>
  800128:	83 c4 10             	add    $0x10,%esp
  80012b:	eb cb                	jmp    8000f8 <umain+0x4f>

0080012d <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80012d:	55                   	push   %ebp
  80012e:	89 e5                	mov    %esp,%ebp
  800130:	56                   	push   %esi
  800131:	53                   	push   %ebx
  800132:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800135:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800138:	e8 5f 0a 00 00       	call   800b9c <sys_getenvid>
  80013d:	25 ff 03 00 00       	and    $0x3ff,%eax
  800142:	89 c2                	mov    %eax,%edx
  800144:	c1 e2 05             	shl    $0x5,%edx
  800147:	29 c2                	sub    %eax,%edx
  800149:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800150:	a3 20 60 80 00       	mov    %eax,0x806020

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800155:	85 db                	test   %ebx,%ebx
  800157:	7e 07                	jle    800160 <libmain+0x33>
		binaryname = argv[0];
  800159:	8b 06                	mov    (%esi),%eax
  80015b:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800160:	83 ec 08             	sub    $0x8,%esp
  800163:	56                   	push   %esi
  800164:	53                   	push   %ebx
  800165:	e8 3f ff ff ff       	call   8000a9 <umain>

	// exit gracefully
	exit();
  80016a:	e8 0a 00 00 00       	call   800179 <exit>
}
  80016f:	83 c4 10             	add    $0x10,%esp
  800172:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800175:	5b                   	pop    %ebx
  800176:	5e                   	pop    %esi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    

00800179 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800179:	55                   	push   %ebp
  80017a:	89 e5                	mov    %esp,%ebp
  80017c:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80017f:	e8 c0 0e 00 00       	call   801044 <close_all>
	sys_env_destroy(0);
  800184:	83 ec 0c             	sub    $0xc,%esp
  800187:	6a 00                	push   $0x0
  800189:	e8 cd 09 00 00       	call   800b5b <sys_env_destroy>
}
  80018e:	83 c4 10             	add    $0x10,%esp
  800191:	c9                   	leave  
  800192:	c3                   	ret    

00800193 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800193:	55                   	push   %ebp
  800194:	89 e5                	mov    %esp,%ebp
  800196:	57                   	push   %edi
  800197:	56                   	push   %esi
  800198:	53                   	push   %ebx
  800199:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80019f:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8001a2:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  8001a8:	e8 ef 09 00 00       	call   800b9c <sys_getenvid>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	ff 75 0c             	pushl  0xc(%ebp)
  8001b3:	ff 75 08             	pushl  0x8(%ebp)
  8001b6:	53                   	push   %ebx
  8001b7:	50                   	push   %eax
  8001b8:	68 64 21 80 00       	push   $0x802164
  8001bd:	68 00 01 00 00       	push   $0x100
  8001c2:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  8001c8:	56                   	push   %esi
  8001c9:	e8 eb 05 00 00       	call   8007b9 <snprintf>
  8001ce:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  8001d0:	83 c4 20             	add    $0x20,%esp
  8001d3:	57                   	push   %edi
  8001d4:	ff 75 10             	pushl  0x10(%ebp)
  8001d7:	bf 00 01 00 00       	mov    $0x100,%edi
  8001dc:	89 f8                	mov    %edi,%eax
  8001de:	29 d8                	sub    %ebx,%eax
  8001e0:	50                   	push   %eax
  8001e1:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001e4:	50                   	push   %eax
  8001e5:	e8 7a 05 00 00       	call   800764 <vsnprintf>
  8001ea:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8001ec:	83 c4 0c             	add    $0xc,%esp
  8001ef:	68 83 25 80 00       	push   $0x802583
  8001f4:	29 df                	sub    %ebx,%edi
  8001f6:	57                   	push   %edi
  8001f7:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8001fa:	50                   	push   %eax
  8001fb:	e8 b9 05 00 00       	call   8007b9 <snprintf>
	sys_cputs(buf, r);
  800200:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800203:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800205:	53                   	push   %ebx
  800206:	56                   	push   %esi
  800207:	e8 12 09 00 00       	call   800b1e <sys_cputs>
  80020c:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80020f:	cc                   	int3   
  800210:	eb fd                	jmp    80020f <_panic+0x7c>

00800212 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	57                   	push   %edi
  800216:	56                   	push   %esi
  800217:	53                   	push   %ebx
  800218:	83 ec 1c             	sub    $0x1c,%esp
  80021b:	89 c7                	mov    %eax,%edi
  80021d:	89 d6                	mov    %edx,%esi
  80021f:	8b 45 08             	mov    0x8(%ebp),%eax
  800222:	8b 55 0c             	mov    0xc(%ebp),%edx
  800225:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800228:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80022b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80022e:	bb 00 00 00 00       	mov    $0x0,%ebx
  800233:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800236:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800239:	39 d3                	cmp    %edx,%ebx
  80023b:	72 05                	jb     800242 <printnum+0x30>
  80023d:	39 45 10             	cmp    %eax,0x10(%ebp)
  800240:	77 78                	ja     8002ba <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800242:	83 ec 0c             	sub    $0xc,%esp
  800245:	ff 75 18             	pushl  0x18(%ebp)
  800248:	8b 45 14             	mov    0x14(%ebp),%eax
  80024b:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80024e:	53                   	push   %ebx
  80024f:	ff 75 10             	pushl  0x10(%ebp)
  800252:	83 ec 08             	sub    $0x8,%esp
  800255:	ff 75 e4             	pushl  -0x1c(%ebp)
  800258:	ff 75 e0             	pushl  -0x20(%ebp)
  80025b:	ff 75 dc             	pushl  -0x24(%ebp)
  80025e:	ff 75 d8             	pushl  -0x28(%ebp)
  800261:	e8 3a 1c 00 00       	call   801ea0 <__udivdi3>
  800266:	83 c4 18             	add    $0x18,%esp
  800269:	52                   	push   %edx
  80026a:	50                   	push   %eax
  80026b:	89 f2                	mov    %esi,%edx
  80026d:	89 f8                	mov    %edi,%eax
  80026f:	e8 9e ff ff ff       	call   800212 <printnum>
  800274:	83 c4 20             	add    $0x20,%esp
  800277:	eb 11                	jmp    80028a <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800279:	83 ec 08             	sub    $0x8,%esp
  80027c:	56                   	push   %esi
  80027d:	ff 75 18             	pushl  0x18(%ebp)
  800280:	ff d7                	call   *%edi
  800282:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800285:	4b                   	dec    %ebx
  800286:	85 db                	test   %ebx,%ebx
  800288:	7f ef                	jg     800279 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80028a:	83 ec 08             	sub    $0x8,%esp
  80028d:	56                   	push   %esi
  80028e:	83 ec 04             	sub    $0x4,%esp
  800291:	ff 75 e4             	pushl  -0x1c(%ebp)
  800294:	ff 75 e0             	pushl  -0x20(%ebp)
  800297:	ff 75 dc             	pushl  -0x24(%ebp)
  80029a:	ff 75 d8             	pushl  -0x28(%ebp)
  80029d:	e8 0e 1d 00 00       	call   801fb0 <__umoddi3>
  8002a2:	83 c4 14             	add    $0x14,%esp
  8002a5:	0f be 80 87 21 80 00 	movsbl 0x802187(%eax),%eax
  8002ac:	50                   	push   %eax
  8002ad:	ff d7                	call   *%edi
}
  8002af:	83 c4 10             	add    $0x10,%esp
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    
  8002ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8002bd:	eb c6                	jmp    800285 <printnum+0x73>

008002bf <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8002c5:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8002c8:	8b 10                	mov    (%eax),%edx
  8002ca:	3b 50 04             	cmp    0x4(%eax),%edx
  8002cd:	73 0a                	jae    8002d9 <sprintputch+0x1a>
		*b->buf++ = ch;
  8002cf:	8d 4a 01             	lea    0x1(%edx),%ecx
  8002d2:	89 08                	mov    %ecx,(%eax)
  8002d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002d7:	88 02                	mov    %al,(%edx)
}
  8002d9:	5d                   	pop    %ebp
  8002da:	c3                   	ret    

008002db <printfmt>:
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8002e1:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8002e4:	50                   	push   %eax
  8002e5:	ff 75 10             	pushl  0x10(%ebp)
  8002e8:	ff 75 0c             	pushl  0xc(%ebp)
  8002eb:	ff 75 08             	pushl  0x8(%ebp)
  8002ee:	e8 05 00 00 00       	call   8002f8 <vprintfmt>
}
  8002f3:	83 c4 10             	add    $0x10,%esp
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <vprintfmt>:
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
  8002fe:	83 ec 2c             	sub    $0x2c,%esp
  800301:	8b 75 08             	mov    0x8(%ebp),%esi
  800304:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800307:	8b 7d 10             	mov    0x10(%ebp),%edi
  80030a:	e9 ae 03 00 00       	jmp    8006bd <vprintfmt+0x3c5>
  80030f:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800313:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80031a:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800321:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800328:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80032d:	8d 47 01             	lea    0x1(%edi),%eax
  800330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800333:	8a 17                	mov    (%edi),%dl
  800335:	8d 42 dd             	lea    -0x23(%edx),%eax
  800338:	3c 55                	cmp    $0x55,%al
  80033a:	0f 87 fe 03 00 00    	ja     80073e <vprintfmt+0x446>
  800340:	0f b6 c0             	movzbl %al,%eax
  800343:	ff 24 85 c0 22 80 00 	jmp    *0x8022c0(,%eax,4)
  80034a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80034d:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800351:	eb da                	jmp    80032d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800353:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800356:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80035a:	eb d1                	jmp    80032d <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80035c:	0f b6 d2             	movzbl %dl,%edx
  80035f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800362:	b8 00 00 00 00       	mov    $0x0,%eax
  800367:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80036a:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800373:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800376:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800379:	83 f9 09             	cmp    $0x9,%ecx
  80037c:	77 52                	ja     8003d0 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80037e:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80037f:	eb e9                	jmp    80036a <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800381:	8b 45 14             	mov    0x14(%ebp),%eax
  800384:	8b 00                	mov    (%eax),%eax
  800386:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800389:	8b 45 14             	mov    0x14(%ebp),%eax
  80038c:	8d 40 04             	lea    0x4(%eax),%eax
  80038f:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800395:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800399:	79 92                	jns    80032d <vprintfmt+0x35>
				width = precision, precision = -1;
  80039b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8003a1:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8003a8:	eb 83                	jmp    80032d <vprintfmt+0x35>
  8003aa:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8003ae:	78 08                	js     8003b8 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8003b0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8003b3:	e9 75 ff ff ff       	jmp    80032d <vprintfmt+0x35>
  8003b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003bf:	eb ef                	jmp    8003b0 <vprintfmt+0xb8>
  8003c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8003c4:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8003cb:	e9 5d ff ff ff       	jmp    80032d <vprintfmt+0x35>
  8003d0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8003d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003d6:	eb bd                	jmp    800395 <vprintfmt+0x9d>
			lflag++;
  8003d8:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8003d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8003dc:	e9 4c ff ff ff       	jmp    80032d <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8003e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e4:	8d 78 04             	lea    0x4(%eax),%edi
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	53                   	push   %ebx
  8003eb:	ff 30                	pushl  (%eax)
  8003ed:	ff d6                	call   *%esi
			break;
  8003ef:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8003f2:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8003f5:	e9 c0 02 00 00       	jmp    8006ba <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8003fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8003fd:	8d 78 04             	lea    0x4(%eax),%edi
  800400:	8b 00                	mov    (%eax),%eax
  800402:	85 c0                	test   %eax,%eax
  800404:	78 2a                	js     800430 <vprintfmt+0x138>
  800406:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800408:	83 f8 0f             	cmp    $0xf,%eax
  80040b:	7f 27                	jg     800434 <vprintfmt+0x13c>
  80040d:	8b 04 85 20 24 80 00 	mov    0x802420(,%eax,4),%eax
  800414:	85 c0                	test   %eax,%eax
  800416:	74 1c                	je     800434 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800418:	50                   	push   %eax
  800419:	68 51 25 80 00       	push   $0x802551
  80041e:	53                   	push   %ebx
  80041f:	56                   	push   %esi
  800420:	e8 b6 fe ff ff       	call   8002db <printfmt>
  800425:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800428:	89 7d 14             	mov    %edi,0x14(%ebp)
  80042b:	e9 8a 02 00 00       	jmp    8006ba <vprintfmt+0x3c2>
  800430:	f7 d8                	neg    %eax
  800432:	eb d2                	jmp    800406 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800434:	52                   	push   %edx
  800435:	68 9f 21 80 00       	push   $0x80219f
  80043a:	53                   	push   %ebx
  80043b:	56                   	push   %esi
  80043c:	e8 9a fe ff ff       	call   8002db <printfmt>
  800441:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800444:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800447:	e9 6e 02 00 00       	jmp    8006ba <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80044c:	8b 45 14             	mov    0x14(%ebp),%eax
  80044f:	83 c0 04             	add    $0x4,%eax
  800452:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800455:	8b 45 14             	mov    0x14(%ebp),%eax
  800458:	8b 38                	mov    (%eax),%edi
  80045a:	85 ff                	test   %edi,%edi
  80045c:	74 39                	je     800497 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80045e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800462:	0f 8e a9 00 00 00    	jle    800511 <vprintfmt+0x219>
  800468:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80046c:	0f 84 a7 00 00 00    	je     800519 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800472:	83 ec 08             	sub    $0x8,%esp
  800475:	ff 75 d0             	pushl  -0x30(%ebp)
  800478:	57                   	push   %edi
  800479:	e8 6b 03 00 00       	call   8007e9 <strnlen>
  80047e:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800481:	29 c1                	sub    %eax,%ecx
  800483:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800486:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800489:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80048d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800490:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800493:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800495:	eb 14                	jmp    8004ab <vprintfmt+0x1b3>
				p = "(null)";
  800497:	bf 98 21 80 00       	mov    $0x802198,%edi
  80049c:	eb c0                	jmp    80045e <vprintfmt+0x166>
					putch(padc, putdat);
  80049e:	83 ec 08             	sub    $0x8,%esp
  8004a1:	53                   	push   %ebx
  8004a2:	ff 75 e0             	pushl  -0x20(%ebp)
  8004a5:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8004a7:	4f                   	dec    %edi
  8004a8:	83 c4 10             	add    $0x10,%esp
  8004ab:	85 ff                	test   %edi,%edi
  8004ad:	7f ef                	jg     80049e <vprintfmt+0x1a6>
  8004af:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8004b2:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004b5:	89 c8                	mov    %ecx,%eax
  8004b7:	85 c9                	test   %ecx,%ecx
  8004b9:	78 10                	js     8004cb <vprintfmt+0x1d3>
  8004bb:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8004be:	29 c1                	sub    %eax,%ecx
  8004c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8004c3:	89 75 08             	mov    %esi,0x8(%ebp)
  8004c6:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8004c9:	eb 15                	jmp    8004e0 <vprintfmt+0x1e8>
  8004cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8004d0:	eb e9                	jmp    8004bb <vprintfmt+0x1c3>
					putch(ch, putdat);
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	53                   	push   %ebx
  8004d6:	52                   	push   %edx
  8004d7:	ff 55 08             	call   *0x8(%ebp)
  8004da:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8004dd:	ff 4d e0             	decl   -0x20(%ebp)
  8004e0:	47                   	inc    %edi
  8004e1:	8a 47 ff             	mov    -0x1(%edi),%al
  8004e4:	0f be d0             	movsbl %al,%edx
  8004e7:	85 d2                	test   %edx,%edx
  8004e9:	74 59                	je     800544 <vprintfmt+0x24c>
  8004eb:	85 f6                	test   %esi,%esi
  8004ed:	78 03                	js     8004f2 <vprintfmt+0x1fa>
  8004ef:	4e                   	dec    %esi
  8004f0:	78 2f                	js     800521 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  8004f2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8004f6:	74 da                	je     8004d2 <vprintfmt+0x1da>
  8004f8:	0f be c0             	movsbl %al,%eax
  8004fb:	83 e8 20             	sub    $0x20,%eax
  8004fe:	83 f8 5e             	cmp    $0x5e,%eax
  800501:	76 cf                	jbe    8004d2 <vprintfmt+0x1da>
					putch('?', putdat);
  800503:	83 ec 08             	sub    $0x8,%esp
  800506:	53                   	push   %ebx
  800507:	6a 3f                	push   $0x3f
  800509:	ff 55 08             	call   *0x8(%ebp)
  80050c:	83 c4 10             	add    $0x10,%esp
  80050f:	eb cc                	jmp    8004dd <vprintfmt+0x1e5>
  800511:	89 75 08             	mov    %esi,0x8(%ebp)
  800514:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800517:	eb c7                	jmp    8004e0 <vprintfmt+0x1e8>
  800519:	89 75 08             	mov    %esi,0x8(%ebp)
  80051c:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80051f:	eb bf                	jmp    8004e0 <vprintfmt+0x1e8>
  800521:	8b 75 08             	mov    0x8(%ebp),%esi
  800524:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800527:	eb 0c                	jmp    800535 <vprintfmt+0x23d>
				putch(' ', putdat);
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	6a 20                	push   $0x20
  80052f:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800531:	4f                   	dec    %edi
  800532:	83 c4 10             	add    $0x10,%esp
  800535:	85 ff                	test   %edi,%edi
  800537:	7f f0                	jg     800529 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800539:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80053c:	89 45 14             	mov    %eax,0x14(%ebp)
  80053f:	e9 76 01 00 00       	jmp    8006ba <vprintfmt+0x3c2>
  800544:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800547:	8b 75 08             	mov    0x8(%ebp),%esi
  80054a:	eb e9                	jmp    800535 <vprintfmt+0x23d>
	if (lflag >= 2)
  80054c:	83 f9 01             	cmp    $0x1,%ecx
  80054f:	7f 1f                	jg     800570 <vprintfmt+0x278>
	else if (lflag)
  800551:	85 c9                	test   %ecx,%ecx
  800553:	75 48                	jne    80059d <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800555:	8b 45 14             	mov    0x14(%ebp),%eax
  800558:	8b 00                	mov    (%eax),%eax
  80055a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80055d:	89 c1                	mov    %eax,%ecx
  80055f:	c1 f9 1f             	sar    $0x1f,%ecx
  800562:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800565:	8b 45 14             	mov    0x14(%ebp),%eax
  800568:	8d 40 04             	lea    0x4(%eax),%eax
  80056b:	89 45 14             	mov    %eax,0x14(%ebp)
  80056e:	eb 17                	jmp    800587 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800570:	8b 45 14             	mov    0x14(%ebp),%eax
  800573:	8b 50 04             	mov    0x4(%eax),%edx
  800576:	8b 00                	mov    (%eax),%eax
  800578:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80057b:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80057e:	8b 45 14             	mov    0x14(%ebp),%eax
  800581:	8d 40 08             	lea    0x8(%eax),%eax
  800584:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800587:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80058a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80058d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800591:	78 25                	js     8005b8 <vprintfmt+0x2c0>
			base = 10;
  800593:	b8 0a 00 00 00       	mov    $0xa,%eax
  800598:	e9 03 01 00 00       	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	8b 00                	mov    (%eax),%eax
  8005a2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8005a5:	89 c1                	mov    %eax,%ecx
  8005a7:	c1 f9 1f             	sar    $0x1f,%ecx
  8005aa:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8005ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b0:	8d 40 04             	lea    0x4(%eax),%eax
  8005b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8005b6:	eb cf                	jmp    800587 <vprintfmt+0x28f>
				putch('-', putdat);
  8005b8:	83 ec 08             	sub    $0x8,%esp
  8005bb:	53                   	push   %ebx
  8005bc:	6a 2d                	push   $0x2d
  8005be:	ff d6                	call   *%esi
				num = -(long long) num;
  8005c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8005c3:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8005c6:	f7 da                	neg    %edx
  8005c8:	83 d1 00             	adc    $0x0,%ecx
  8005cb:	f7 d9                	neg    %ecx
  8005cd:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8005d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005d5:	e9 c6 00 00 00       	jmp    8006a0 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8005da:	83 f9 01             	cmp    $0x1,%ecx
  8005dd:	7f 1e                	jg     8005fd <vprintfmt+0x305>
	else if (lflag)
  8005df:	85 c9                	test   %ecx,%ecx
  8005e1:	75 32                	jne    800615 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8005e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e6:	8b 10                	mov    (%eax),%edx
  8005e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8005ed:	8d 40 04             	lea    0x4(%eax),%eax
  8005f0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8005f3:	b8 0a 00 00 00       	mov    $0xa,%eax
  8005f8:	e9 a3 00 00 00       	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8005fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800600:	8b 10                	mov    (%eax),%edx
  800602:	8b 48 04             	mov    0x4(%eax),%ecx
  800605:	8d 40 08             	lea    0x8(%eax),%eax
  800608:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80060b:	b8 0a 00 00 00       	mov    $0xa,%eax
  800610:	e9 8b 00 00 00       	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800615:	8b 45 14             	mov    0x14(%ebp),%eax
  800618:	8b 10                	mov    (%eax),%edx
  80061a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80061f:	8d 40 04             	lea    0x4(%eax),%eax
  800622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800625:	b8 0a 00 00 00       	mov    $0xa,%eax
  80062a:	eb 74                	jmp    8006a0 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80062c:	83 f9 01             	cmp    $0x1,%ecx
  80062f:	7f 1b                	jg     80064c <vprintfmt+0x354>
	else if (lflag)
  800631:	85 c9                	test   %ecx,%ecx
  800633:	75 2c                	jne    800661 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800635:	8b 45 14             	mov    0x14(%ebp),%eax
  800638:	8b 10                	mov    (%eax),%edx
  80063a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80063f:	8d 40 04             	lea    0x4(%eax),%eax
  800642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800645:	b8 08 00 00 00       	mov    $0x8,%eax
  80064a:	eb 54                	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80064c:	8b 45 14             	mov    0x14(%ebp),%eax
  80064f:	8b 10                	mov    (%eax),%edx
  800651:	8b 48 04             	mov    0x4(%eax),%ecx
  800654:	8d 40 08             	lea    0x8(%eax),%eax
  800657:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80065a:	b8 08 00 00 00       	mov    $0x8,%eax
  80065f:	eb 3f                	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800661:	8b 45 14             	mov    0x14(%ebp),%eax
  800664:	8b 10                	mov    (%eax),%edx
  800666:	b9 00 00 00 00       	mov    $0x0,%ecx
  80066b:	8d 40 04             	lea    0x4(%eax),%eax
  80066e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800671:	b8 08 00 00 00       	mov    $0x8,%eax
  800676:	eb 28                	jmp    8006a0 <vprintfmt+0x3a8>
			putch('0', putdat);
  800678:	83 ec 08             	sub    $0x8,%esp
  80067b:	53                   	push   %ebx
  80067c:	6a 30                	push   $0x30
  80067e:	ff d6                	call   *%esi
			putch('x', putdat);
  800680:	83 c4 08             	add    $0x8,%esp
  800683:	53                   	push   %ebx
  800684:	6a 78                	push   $0x78
  800686:	ff d6                	call   *%esi
			num = (unsigned long long)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	8b 10                	mov    (%eax),%edx
  80068d:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800692:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800695:	8d 40 04             	lea    0x4(%eax),%eax
  800698:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80069b:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8006a7:	57                   	push   %edi
  8006a8:	ff 75 e0             	pushl  -0x20(%ebp)
  8006ab:	50                   	push   %eax
  8006ac:	51                   	push   %ecx
  8006ad:	52                   	push   %edx
  8006ae:	89 da                	mov    %ebx,%edx
  8006b0:	89 f0                	mov    %esi,%eax
  8006b2:	e8 5b fb ff ff       	call   800212 <printnum>
			break;
  8006b7:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8006ba:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006bd:	47                   	inc    %edi
  8006be:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8006c2:	83 f8 25             	cmp    $0x25,%eax
  8006c5:	0f 84 44 fc ff ff    	je     80030f <vprintfmt+0x17>
			if (ch == '\0')
  8006cb:	85 c0                	test   %eax,%eax
  8006cd:	0f 84 89 00 00 00    	je     80075c <vprintfmt+0x464>
			putch(ch, putdat);
  8006d3:	83 ec 08             	sub    $0x8,%esp
  8006d6:	53                   	push   %ebx
  8006d7:	50                   	push   %eax
  8006d8:	ff d6                	call   *%esi
  8006da:	83 c4 10             	add    $0x10,%esp
  8006dd:	eb de                	jmp    8006bd <vprintfmt+0x3c5>
	if (lflag >= 2)
  8006df:	83 f9 01             	cmp    $0x1,%ecx
  8006e2:	7f 1b                	jg     8006ff <vprintfmt+0x407>
	else if (lflag)
  8006e4:	85 c9                	test   %ecx,%ecx
  8006e6:	75 2c                	jne    800714 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8006e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8006eb:	8b 10                	mov    (%eax),%edx
  8006ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8006f8:	b8 10 00 00 00       	mov    $0x10,%eax
  8006fd:	eb a1                	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8006ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800702:	8b 10                	mov    (%eax),%edx
  800704:	8b 48 04             	mov    0x4(%eax),%ecx
  800707:	8d 40 08             	lea    0x8(%eax),%eax
  80070a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80070d:	b8 10 00 00 00       	mov    $0x10,%eax
  800712:	eb 8c                	jmp    8006a0 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800714:	8b 45 14             	mov    0x14(%ebp),%eax
  800717:	8b 10                	mov    (%eax),%edx
  800719:	b9 00 00 00 00       	mov    $0x0,%ecx
  80071e:	8d 40 04             	lea    0x4(%eax),%eax
  800721:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800724:	b8 10 00 00 00       	mov    $0x10,%eax
  800729:	e9 72 ff ff ff       	jmp    8006a0 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	53                   	push   %ebx
  800732:	6a 25                	push   $0x25
  800734:	ff d6                	call   *%esi
			break;
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	e9 7c ff ff ff       	jmp    8006ba <vprintfmt+0x3c2>
			putch('%', putdat);
  80073e:	83 ec 08             	sub    $0x8,%esp
  800741:	53                   	push   %ebx
  800742:	6a 25                	push   $0x25
  800744:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800746:	83 c4 10             	add    $0x10,%esp
  800749:	89 f8                	mov    %edi,%eax
  80074b:	eb 01                	jmp    80074e <vprintfmt+0x456>
  80074d:	48                   	dec    %eax
  80074e:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800752:	75 f9                	jne    80074d <vprintfmt+0x455>
  800754:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800757:	e9 5e ff ff ff       	jmp    8006ba <vprintfmt+0x3c2>
}
  80075c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80075f:	5b                   	pop    %ebx
  800760:	5e                   	pop    %esi
  800761:	5f                   	pop    %edi
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	83 ec 18             	sub    $0x18,%esp
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800770:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800773:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800777:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80077a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800781:	85 c0                	test   %eax,%eax
  800783:	74 26                	je     8007ab <vsnprintf+0x47>
  800785:	85 d2                	test   %edx,%edx
  800787:	7e 29                	jle    8007b2 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800789:	ff 75 14             	pushl  0x14(%ebp)
  80078c:	ff 75 10             	pushl  0x10(%ebp)
  80078f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800792:	50                   	push   %eax
  800793:	68 bf 02 80 00       	push   $0x8002bf
  800798:	e8 5b fb ff ff       	call   8002f8 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80079d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8007a0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8007a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a6:	83 c4 10             	add    $0x10,%esp
}
  8007a9:	c9                   	leave  
  8007aa:	c3                   	ret    
		return -E_INVAL;
  8007ab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b0:	eb f7                	jmp    8007a9 <vsnprintf+0x45>
  8007b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8007b7:	eb f0                	jmp    8007a9 <vsnprintf+0x45>

008007b9 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8007b9:	55                   	push   %ebp
  8007ba:	89 e5                	mov    %esp,%ebp
  8007bc:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8007bf:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8007c2:	50                   	push   %eax
  8007c3:	ff 75 10             	pushl  0x10(%ebp)
  8007c6:	ff 75 0c             	pushl  0xc(%ebp)
  8007c9:	ff 75 08             	pushl  0x8(%ebp)
  8007cc:	e8 93 ff ff ff       	call   800764 <vsnprintf>
	va_end(ap);

	return rc;
}
  8007d1:	c9                   	leave  
  8007d2:	c3                   	ret    

008007d3 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8007d3:	55                   	push   %ebp
  8007d4:	89 e5                	mov    %esp,%ebp
  8007d6:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8007d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8007de:	eb 01                	jmp    8007e1 <strlen+0xe>
		n++;
  8007e0:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8007e1:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8007e5:	75 f9                	jne    8007e0 <strlen+0xd>
	return n;
}
  8007e7:	5d                   	pop    %ebp
  8007e8:	c3                   	ret    

008007e9 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8007e9:	55                   	push   %ebp
  8007ea:	89 e5                	mov    %esp,%ebp
  8007ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8007ef:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007f2:	b8 00 00 00 00       	mov    $0x0,%eax
  8007f7:	eb 01                	jmp    8007fa <strnlen+0x11>
		n++;
  8007f9:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8007fa:	39 d0                	cmp    %edx,%eax
  8007fc:	74 06                	je     800804 <strnlen+0x1b>
  8007fe:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800802:	75 f5                	jne    8007f9 <strnlen+0x10>
	return n;
}
  800804:	5d                   	pop    %ebp
  800805:	c3                   	ret    

00800806 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800806:	55                   	push   %ebp
  800807:	89 e5                	mov    %esp,%ebp
  800809:	53                   	push   %ebx
  80080a:	8b 45 08             	mov    0x8(%ebp),%eax
  80080d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800810:	89 c2                	mov    %eax,%edx
  800812:	42                   	inc    %edx
  800813:	41                   	inc    %ecx
  800814:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800817:	88 5a ff             	mov    %bl,-0x1(%edx)
  80081a:	84 db                	test   %bl,%bl
  80081c:	75 f4                	jne    800812 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80081e:	5b                   	pop    %ebx
  80081f:	5d                   	pop    %ebp
  800820:	c3                   	ret    

00800821 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800821:	55                   	push   %ebp
  800822:	89 e5                	mov    %esp,%ebp
  800824:	53                   	push   %ebx
  800825:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800828:	53                   	push   %ebx
  800829:	e8 a5 ff ff ff       	call   8007d3 <strlen>
  80082e:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800831:	ff 75 0c             	pushl  0xc(%ebp)
  800834:	01 d8                	add    %ebx,%eax
  800836:	50                   	push   %eax
  800837:	e8 ca ff ff ff       	call   800806 <strcpy>
	return dst;
}
  80083c:	89 d8                	mov    %ebx,%eax
  80083e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800841:	c9                   	leave  
  800842:	c3                   	ret    

00800843 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800843:	55                   	push   %ebp
  800844:	89 e5                	mov    %esp,%ebp
  800846:	56                   	push   %esi
  800847:	53                   	push   %ebx
  800848:	8b 75 08             	mov    0x8(%ebp),%esi
  80084b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80084e:	89 f3                	mov    %esi,%ebx
  800850:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800853:	89 f2                	mov    %esi,%edx
  800855:	eb 0c                	jmp    800863 <strncpy+0x20>
		*dst++ = *src;
  800857:	42                   	inc    %edx
  800858:	8a 01                	mov    (%ecx),%al
  80085a:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80085d:	80 39 01             	cmpb   $0x1,(%ecx)
  800860:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800863:	39 da                	cmp    %ebx,%edx
  800865:	75 f0                	jne    800857 <strncpy+0x14>
	}
	return ret;
}
  800867:	89 f0                	mov    %esi,%eax
  800869:	5b                   	pop    %ebx
  80086a:	5e                   	pop    %esi
  80086b:	5d                   	pop    %ebp
  80086c:	c3                   	ret    

0080086d <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80086d:	55                   	push   %ebp
  80086e:	89 e5                	mov    %esp,%ebp
  800870:	56                   	push   %esi
  800871:	53                   	push   %ebx
  800872:	8b 75 08             	mov    0x8(%ebp),%esi
  800875:	8b 55 0c             	mov    0xc(%ebp),%edx
  800878:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80087b:	85 c0                	test   %eax,%eax
  80087d:	74 20                	je     80089f <strlcpy+0x32>
  80087f:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800883:	89 f0                	mov    %esi,%eax
  800885:	eb 05                	jmp    80088c <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800887:	40                   	inc    %eax
  800888:	42                   	inc    %edx
  800889:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80088c:	39 d8                	cmp    %ebx,%eax
  80088e:	74 06                	je     800896 <strlcpy+0x29>
  800890:	8a 0a                	mov    (%edx),%cl
  800892:	84 c9                	test   %cl,%cl
  800894:	75 f1                	jne    800887 <strlcpy+0x1a>
		*dst = '\0';
  800896:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800899:	29 f0                	sub    %esi,%eax
}
  80089b:	5b                   	pop    %ebx
  80089c:	5e                   	pop    %esi
  80089d:	5d                   	pop    %ebp
  80089e:	c3                   	ret    
  80089f:	89 f0                	mov    %esi,%eax
  8008a1:	eb f6                	jmp    800899 <strlcpy+0x2c>

008008a3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8008a3:	55                   	push   %ebp
  8008a4:	89 e5                	mov    %esp,%ebp
  8008a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8008a9:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8008ac:	eb 02                	jmp    8008b0 <strcmp+0xd>
		p++, q++;
  8008ae:	41                   	inc    %ecx
  8008af:	42                   	inc    %edx
	while (*p && *p == *q)
  8008b0:	8a 01                	mov    (%ecx),%al
  8008b2:	84 c0                	test   %al,%al
  8008b4:	74 04                	je     8008ba <strcmp+0x17>
  8008b6:	3a 02                	cmp    (%edx),%al
  8008b8:	74 f4                	je     8008ae <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8008ba:	0f b6 c0             	movzbl %al,%eax
  8008bd:	0f b6 12             	movzbl (%edx),%edx
  8008c0:	29 d0                	sub    %edx,%eax
}
  8008c2:	5d                   	pop    %ebp
  8008c3:	c3                   	ret    

008008c4 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8008c4:	55                   	push   %ebp
  8008c5:	89 e5                	mov    %esp,%ebp
  8008c7:	53                   	push   %ebx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008ce:	89 c3                	mov    %eax,%ebx
  8008d0:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8008d3:	eb 02                	jmp    8008d7 <strncmp+0x13>
		n--, p++, q++;
  8008d5:	40                   	inc    %eax
  8008d6:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8008d7:	39 d8                	cmp    %ebx,%eax
  8008d9:	74 15                	je     8008f0 <strncmp+0x2c>
  8008db:	8a 08                	mov    (%eax),%cl
  8008dd:	84 c9                	test   %cl,%cl
  8008df:	74 04                	je     8008e5 <strncmp+0x21>
  8008e1:	3a 0a                	cmp    (%edx),%cl
  8008e3:	74 f0                	je     8008d5 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8008e5:	0f b6 00             	movzbl (%eax),%eax
  8008e8:	0f b6 12             	movzbl (%edx),%edx
  8008eb:	29 d0                	sub    %edx,%eax
}
  8008ed:	5b                   	pop    %ebx
  8008ee:	5d                   	pop    %ebp
  8008ef:	c3                   	ret    
		return 0;
  8008f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8008f5:	eb f6                	jmp    8008ed <strncmp+0x29>

008008f7 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8008f7:	55                   	push   %ebp
  8008f8:	89 e5                	mov    %esp,%ebp
  8008fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fd:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800900:	8a 10                	mov    (%eax),%dl
  800902:	84 d2                	test   %dl,%dl
  800904:	74 07                	je     80090d <strchr+0x16>
		if (*s == c)
  800906:	38 ca                	cmp    %cl,%dl
  800908:	74 08                	je     800912 <strchr+0x1b>
	for (; *s; s++)
  80090a:	40                   	inc    %eax
  80090b:	eb f3                	jmp    800900 <strchr+0x9>
			return (char *) s;
	return 0;
  80090d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800912:	5d                   	pop    %ebp
  800913:	c3                   	ret    

00800914 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800914:	55                   	push   %ebp
  800915:	89 e5                	mov    %esp,%ebp
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80091d:	8a 10                	mov    (%eax),%dl
  80091f:	84 d2                	test   %dl,%dl
  800921:	74 07                	je     80092a <strfind+0x16>
		if (*s == c)
  800923:	38 ca                	cmp    %cl,%dl
  800925:	74 03                	je     80092a <strfind+0x16>
	for (; *s; s++)
  800927:	40                   	inc    %eax
  800928:	eb f3                	jmp    80091d <strfind+0x9>
			break;
	return (char *) s;
}
  80092a:	5d                   	pop    %ebp
  80092b:	c3                   	ret    

0080092c <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80092c:	55                   	push   %ebp
  80092d:	89 e5                	mov    %esp,%ebp
  80092f:	57                   	push   %edi
  800930:	56                   	push   %esi
  800931:	53                   	push   %ebx
  800932:	8b 7d 08             	mov    0x8(%ebp),%edi
  800935:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800938:	85 c9                	test   %ecx,%ecx
  80093a:	74 13                	je     80094f <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80093c:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800942:	75 05                	jne    800949 <memset+0x1d>
  800944:	f6 c1 03             	test   $0x3,%cl
  800947:	74 0d                	je     800956 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	fc                   	cld    
  80094d:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80094f:	89 f8                	mov    %edi,%eax
  800951:	5b                   	pop    %ebx
  800952:	5e                   	pop    %esi
  800953:	5f                   	pop    %edi
  800954:	5d                   	pop    %ebp
  800955:	c3                   	ret    
		c &= 0xFF;
  800956:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80095a:	89 d3                	mov    %edx,%ebx
  80095c:	c1 e3 08             	shl    $0x8,%ebx
  80095f:	89 d0                	mov    %edx,%eax
  800961:	c1 e0 18             	shl    $0x18,%eax
  800964:	89 d6                	mov    %edx,%esi
  800966:	c1 e6 10             	shl    $0x10,%esi
  800969:	09 f0                	or     %esi,%eax
  80096b:	09 c2                	or     %eax,%edx
  80096d:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  80096f:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800972:	89 d0                	mov    %edx,%eax
  800974:	fc                   	cld    
  800975:	f3 ab                	rep stos %eax,%es:(%edi)
  800977:	eb d6                	jmp    80094f <memset+0x23>

00800979 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800979:	55                   	push   %ebp
  80097a:	89 e5                	mov    %esp,%ebp
  80097c:	57                   	push   %edi
  80097d:	56                   	push   %esi
  80097e:	8b 45 08             	mov    0x8(%ebp),%eax
  800981:	8b 75 0c             	mov    0xc(%ebp),%esi
  800984:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800987:	39 c6                	cmp    %eax,%esi
  800989:	73 33                	jae    8009be <memmove+0x45>
  80098b:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80098e:	39 d0                	cmp    %edx,%eax
  800990:	73 2c                	jae    8009be <memmove+0x45>
		s += n;
		d += n;
  800992:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800995:	89 d6                	mov    %edx,%esi
  800997:	09 fe                	or     %edi,%esi
  800999:	f7 c6 03 00 00 00    	test   $0x3,%esi
  80099f:	75 13                	jne    8009b4 <memmove+0x3b>
  8009a1:	f6 c1 03             	test   $0x3,%cl
  8009a4:	75 0e                	jne    8009b4 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8009a6:	83 ef 04             	sub    $0x4,%edi
  8009a9:	8d 72 fc             	lea    -0x4(%edx),%esi
  8009ac:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8009af:	fd                   	std    
  8009b0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009b2:	eb 07                	jmp    8009bb <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8009b4:	4f                   	dec    %edi
  8009b5:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8009b8:	fd                   	std    
  8009b9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8009bb:	fc                   	cld    
  8009bc:	eb 13                	jmp    8009d1 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8009be:	89 f2                	mov    %esi,%edx
  8009c0:	09 c2                	or     %eax,%edx
  8009c2:	f6 c2 03             	test   $0x3,%dl
  8009c5:	75 05                	jne    8009cc <memmove+0x53>
  8009c7:	f6 c1 03             	test   $0x3,%cl
  8009ca:	74 09                	je     8009d5 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8009cc:	89 c7                	mov    %eax,%edi
  8009ce:	fc                   	cld    
  8009cf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8009d1:	5e                   	pop    %esi
  8009d2:	5f                   	pop    %edi
  8009d3:	5d                   	pop    %ebp
  8009d4:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8009d5:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8009d8:	89 c7                	mov    %eax,%edi
  8009da:	fc                   	cld    
  8009db:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8009dd:	eb f2                	jmp    8009d1 <memmove+0x58>

008009df <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8009df:	55                   	push   %ebp
  8009e0:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8009e2:	ff 75 10             	pushl  0x10(%ebp)
  8009e5:	ff 75 0c             	pushl  0xc(%ebp)
  8009e8:	ff 75 08             	pushl  0x8(%ebp)
  8009eb:	e8 89 ff ff ff       	call   800979 <memmove>
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	56                   	push   %esi
  8009f6:	53                   	push   %ebx
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 c6                	mov    %eax,%esi
  8009fc:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  8009ff:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800a02:	39 f0                	cmp    %esi,%eax
  800a04:	74 16                	je     800a1c <memcmp+0x2a>
		if (*s1 != *s2)
  800a06:	8a 08                	mov    (%eax),%cl
  800a08:	8a 1a                	mov    (%edx),%bl
  800a0a:	38 d9                	cmp    %bl,%cl
  800a0c:	75 04                	jne    800a12 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800a0e:	40                   	inc    %eax
  800a0f:	42                   	inc    %edx
  800a10:	eb f0                	jmp    800a02 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800a12:	0f b6 c1             	movzbl %cl,%eax
  800a15:	0f b6 db             	movzbl %bl,%ebx
  800a18:	29 d8                	sub    %ebx,%eax
  800a1a:	eb 05                	jmp    800a21 <memcmp+0x2f>
	}

	return 0;
  800a1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a21:	5b                   	pop    %ebx
  800a22:	5e                   	pop    %esi
  800a23:	5d                   	pop    %ebp
  800a24:	c3                   	ret    

00800a25 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800a25:	55                   	push   %ebp
  800a26:	89 e5                	mov    %esp,%ebp
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800a2e:	89 c2                	mov    %eax,%edx
  800a30:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800a33:	39 d0                	cmp    %edx,%eax
  800a35:	73 07                	jae    800a3e <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800a37:	38 08                	cmp    %cl,(%eax)
  800a39:	74 03                	je     800a3e <memfind+0x19>
	for (; s < ends; s++)
  800a3b:	40                   	inc    %eax
  800a3c:	eb f5                	jmp    800a33 <memfind+0xe>
			break;
	return (void *) s;
}
  800a3e:	5d                   	pop    %ebp
  800a3f:	c3                   	ret    

00800a40 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800a40:	55                   	push   %ebp
  800a41:	89 e5                	mov    %esp,%ebp
  800a43:	57                   	push   %edi
  800a44:	56                   	push   %esi
  800a45:	53                   	push   %ebx
  800a46:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800a49:	eb 01                	jmp    800a4c <strtol+0xc>
		s++;
  800a4b:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800a4c:	8a 01                	mov    (%ecx),%al
  800a4e:	3c 20                	cmp    $0x20,%al
  800a50:	74 f9                	je     800a4b <strtol+0xb>
  800a52:	3c 09                	cmp    $0x9,%al
  800a54:	74 f5                	je     800a4b <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800a56:	3c 2b                	cmp    $0x2b,%al
  800a58:	74 2b                	je     800a85 <strtol+0x45>
		s++;
	else if (*s == '-')
  800a5a:	3c 2d                	cmp    $0x2d,%al
  800a5c:	74 2f                	je     800a8d <strtol+0x4d>
	int neg = 0;
  800a5e:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a63:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800a6a:	75 12                	jne    800a7e <strtol+0x3e>
  800a6c:	80 39 30             	cmpb   $0x30,(%ecx)
  800a6f:	74 24                	je     800a95 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800a71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a75:	75 07                	jne    800a7e <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800a77:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800a7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800a83:	eb 4e                	jmp    800ad3 <strtol+0x93>
		s++;
  800a85:	41                   	inc    %ecx
	int neg = 0;
  800a86:	bf 00 00 00 00       	mov    $0x0,%edi
  800a8b:	eb d6                	jmp    800a63 <strtol+0x23>
		s++, neg = 1;
  800a8d:	41                   	inc    %ecx
  800a8e:	bf 01 00 00 00       	mov    $0x1,%edi
  800a93:	eb ce                	jmp    800a63 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800a95:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800a99:	74 10                	je     800aab <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800a9b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800a9f:	75 dd                	jne    800a7e <strtol+0x3e>
		s++, base = 8;
  800aa1:	41                   	inc    %ecx
  800aa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800aa9:	eb d3                	jmp    800a7e <strtol+0x3e>
		s += 2, base = 16;
  800aab:	83 c1 02             	add    $0x2,%ecx
  800aae:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ab5:	eb c7                	jmp    800a7e <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ab7:	8d 72 9f             	lea    -0x61(%edx),%esi
  800aba:	89 f3                	mov    %esi,%ebx
  800abc:	80 fb 19             	cmp    $0x19,%bl
  800abf:	77 24                	ja     800ae5 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800ac1:	0f be d2             	movsbl %dl,%edx
  800ac4:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ac7:	3b 55 10             	cmp    0x10(%ebp),%edx
  800aca:	7d 2b                	jge    800af7 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800acc:	41                   	inc    %ecx
  800acd:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ad1:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800ad3:	8a 11                	mov    (%ecx),%dl
  800ad5:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ad8:	80 fb 09             	cmp    $0x9,%bl
  800adb:	77 da                	ja     800ab7 <strtol+0x77>
			dig = *s - '0';
  800add:	0f be d2             	movsbl %dl,%edx
  800ae0:	83 ea 30             	sub    $0x30,%edx
  800ae3:	eb e2                	jmp    800ac7 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800ae5:	8d 72 bf             	lea    -0x41(%edx),%esi
  800ae8:	89 f3                	mov    %esi,%ebx
  800aea:	80 fb 19             	cmp    $0x19,%bl
  800aed:	77 08                	ja     800af7 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800aef:	0f be d2             	movsbl %dl,%edx
  800af2:	83 ea 37             	sub    $0x37,%edx
  800af5:	eb d0                	jmp    800ac7 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800af7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800afb:	74 05                	je     800b02 <strtol+0xc2>
		*endptr = (char *) s;
  800afd:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b00:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800b02:	85 ff                	test   %edi,%edi
  800b04:	74 02                	je     800b08 <strtol+0xc8>
  800b06:	f7 d8                	neg    %eax
}
  800b08:	5b                   	pop    %ebx
  800b09:	5e                   	pop    %esi
  800b0a:	5f                   	pop    %edi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <atoi>:

int
atoi(const char *s)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800b10:	6a 0a                	push   $0xa
  800b12:	6a 00                	push   $0x0
  800b14:	ff 75 08             	pushl  0x8(%ebp)
  800b17:	e8 24 ff ff ff       	call   800a40 <strtol>
}
  800b1c:	c9                   	leave  
  800b1d:	c3                   	ret    

00800b1e <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800b1e:	55                   	push   %ebp
  800b1f:	89 e5                	mov    %esp,%ebp
  800b21:	57                   	push   %edi
  800b22:	56                   	push   %esi
  800b23:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b24:	b8 00 00 00 00       	mov    $0x0,%eax
  800b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2f:	89 c3                	mov    %eax,%ebx
  800b31:	89 c7                	mov    %eax,%edi
  800b33:	89 c6                	mov    %eax,%esi
  800b35:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800b37:	5b                   	pop    %ebx
  800b38:	5e                   	pop    %esi
  800b39:	5f                   	pop    %edi
  800b3a:	5d                   	pop    %ebp
  800b3b:	c3                   	ret    

00800b3c <sys_cgetc>:

int
sys_cgetc(void)
{
  800b3c:	55                   	push   %ebp
  800b3d:	89 e5                	mov    %esp,%ebp
  800b3f:	57                   	push   %edi
  800b40:	56                   	push   %esi
  800b41:	53                   	push   %ebx
	asm volatile("int %1\n"
  800b42:	ba 00 00 00 00       	mov    $0x0,%edx
  800b47:	b8 01 00 00 00       	mov    $0x1,%eax
  800b4c:	89 d1                	mov    %edx,%ecx
  800b4e:	89 d3                	mov    %edx,%ebx
  800b50:	89 d7                	mov    %edx,%edi
  800b52:	89 d6                	mov    %edx,%esi
  800b54:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5f                   	pop    %edi
  800b59:	5d                   	pop    %ebp
  800b5a:	c3                   	ret    

00800b5b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800b5b:	55                   	push   %ebp
  800b5c:	89 e5                	mov    %esp,%ebp
  800b5e:	57                   	push   %edi
  800b5f:	56                   	push   %esi
  800b60:	53                   	push   %ebx
  800b61:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800b64:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b69:	b8 03 00 00 00       	mov    $0x3,%eax
  800b6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b71:	89 cb                	mov    %ecx,%ebx
  800b73:	89 cf                	mov    %ecx,%edi
  800b75:	89 ce                	mov    %ecx,%esi
  800b77:	cd 30                	int    $0x30
	if(check && ret > 0)
  800b79:	85 c0                	test   %eax,%eax
  800b7b:	7f 08                	jg     800b85 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800b89:	6a 03                	push   $0x3
  800b8b:	68 7f 24 80 00       	push   $0x80247f
  800b90:	6a 23                	push   $0x23
  800b92:	68 9c 24 80 00       	push   $0x80249c
  800b97:	e8 f7 f5 ff ff       	call   800193 <_panic>

00800b9c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	57                   	push   %edi
  800ba0:	56                   	push   %esi
  800ba1:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ba2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ba7:	b8 02 00 00 00       	mov    $0x2,%eax
  800bac:	89 d1                	mov    %edx,%ecx
  800bae:	89 d3                	mov    %edx,%ebx
  800bb0:	89 d7                	mov    %edx,%edi
  800bb2:	89 d6                	mov    %edx,%esi
  800bb4:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800bb6:	5b                   	pop    %ebx
  800bb7:	5e                   	pop    %esi
  800bb8:	5f                   	pop    %edi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    

00800bbb <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800bbb:	55                   	push   %ebp
  800bbc:	89 e5                	mov    %esp,%ebp
  800bbe:	57                   	push   %edi
  800bbf:	56                   	push   %esi
  800bc0:	53                   	push   %ebx
  800bc1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800bc4:	be 00 00 00 00       	mov    $0x0,%esi
  800bc9:	b8 04 00 00 00       	mov    $0x4,%eax
  800bce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800bd1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800bd7:	89 f7                	mov    %esi,%edi
  800bd9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800bdb:	85 c0                	test   %eax,%eax
  800bdd:	7f 08                	jg     800be7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800beb:	6a 04                	push   $0x4
  800bed:	68 7f 24 80 00       	push   $0x80247f
  800bf2:	6a 23                	push   $0x23
  800bf4:	68 9c 24 80 00       	push   $0x80249c
  800bf9:	e8 95 f5 ff ff       	call   800193 <_panic>

00800bfe <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800bfe:	55                   	push   %ebp
  800bff:	89 e5                	mov    %esp,%ebp
  800c01:	57                   	push   %edi
  800c02:	56                   	push   %esi
  800c03:	53                   	push   %ebx
  800c04:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c07:	b8 05 00 00 00       	mov    $0x5,%eax
  800c0c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c0f:	8b 55 08             	mov    0x8(%ebp),%edx
  800c12:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800c15:	8b 7d 14             	mov    0x14(%ebp),%edi
  800c18:	8b 75 18             	mov    0x18(%ebp),%esi
  800c1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	7f 08                	jg     800c29 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800c21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c24:	5b                   	pop    %ebx
  800c25:	5e                   	pop    %esi
  800c26:	5f                   	pop    %edi
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c29:	83 ec 0c             	sub    $0xc,%esp
  800c2c:	50                   	push   %eax
  800c2d:	6a 05                	push   $0x5
  800c2f:	68 7f 24 80 00       	push   $0x80247f
  800c34:	6a 23                	push   $0x23
  800c36:	68 9c 24 80 00       	push   $0x80249c
  800c3b:	e8 53 f5 ff ff       	call   800193 <_panic>

00800c40 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	57                   	push   %edi
  800c44:	56                   	push   %esi
  800c45:	53                   	push   %ebx
  800c46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800c49:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c4e:	b8 06 00 00 00       	mov    $0x6,%eax
  800c53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c56:	8b 55 08             	mov    0x8(%ebp),%edx
  800c59:	89 df                	mov    %ebx,%edi
  800c5b:	89 de                	mov    %ebx,%esi
  800c5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800c5f:	85 c0                	test   %eax,%eax
  800c61:	7f 08                	jg     800c6b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800c63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c66:	5b                   	pop    %ebx
  800c67:	5e                   	pop    %esi
  800c68:	5f                   	pop    %edi
  800c69:	5d                   	pop    %ebp
  800c6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800c6b:	83 ec 0c             	sub    $0xc,%esp
  800c6e:	50                   	push   %eax
  800c6f:	6a 06                	push   $0x6
  800c71:	68 7f 24 80 00       	push   $0x80247f
  800c76:	6a 23                	push   $0x23
  800c78:	68 9c 24 80 00       	push   $0x80249c
  800c7d:	e8 11 f5 ff ff       	call   800193 <_panic>

00800c82 <sys_yield>:

void
sys_yield(void)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	57                   	push   %edi
  800c86:	56                   	push   %esi
  800c87:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c88:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800c92:	89 d1                	mov    %edx,%ecx
  800c94:	89 d3                	mov    %edx,%ebx
  800c96:	89 d7                	mov    %edx,%edi
  800c98:	89 d6                	mov    %edx,%esi
  800c9a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800c9c:	5b                   	pop    %ebx
  800c9d:	5e                   	pop    %esi
  800c9e:	5f                   	pop    %edi
  800c9f:	5d                   	pop    %ebp
  800ca0:	c3                   	ret    

00800ca1 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800ca1:	55                   	push   %ebp
  800ca2:	89 e5                	mov    %esp,%ebp
  800ca4:	57                   	push   %edi
  800ca5:	56                   	push   %esi
  800ca6:	53                   	push   %ebx
  800ca7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800caa:	bb 00 00 00 00       	mov    $0x0,%ebx
  800caf:	b8 08 00 00 00       	mov    $0x8,%eax
  800cb4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb7:	8b 55 08             	mov    0x8(%ebp),%edx
  800cba:	89 df                	mov    %ebx,%edi
  800cbc:	89 de                	mov    %ebx,%esi
  800cbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	7f 08                	jg     800ccc <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800cc4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc7:	5b                   	pop    %ebx
  800cc8:	5e                   	pop    %esi
  800cc9:	5f                   	pop    %edi
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ccc:	83 ec 0c             	sub    $0xc,%esp
  800ccf:	50                   	push   %eax
  800cd0:	6a 08                	push   $0x8
  800cd2:	68 7f 24 80 00       	push   $0x80247f
  800cd7:	6a 23                	push   $0x23
  800cd9:	68 9c 24 80 00       	push   $0x80249c
  800cde:	e8 b0 f4 ff ff       	call   800193 <_panic>

00800ce3 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
  800ce9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cec:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf1:	b8 0c 00 00 00       	mov    $0xc,%eax
  800cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf9:	89 cb                	mov    %ecx,%ebx
  800cfb:	89 cf                	mov    %ecx,%edi
  800cfd:	89 ce                	mov    %ecx,%esi
  800cff:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d01:	85 c0                	test   %eax,%eax
  800d03:	7f 08                	jg     800d0d <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
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
  800d11:	6a 0c                	push   $0xc
  800d13:	68 7f 24 80 00       	push   $0x80247f
  800d18:	6a 23                	push   $0x23
  800d1a:	68 9c 24 80 00       	push   $0x80249c
  800d1f:	e8 6f f4 ff ff       	call   800193 <_panic>

00800d24 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800d24:	55                   	push   %ebp
  800d25:	89 e5                	mov    %esp,%ebp
  800d27:	57                   	push   %edi
  800d28:	56                   	push   %esi
  800d29:	53                   	push   %ebx
  800d2a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d32:	b8 09 00 00 00       	mov    $0x9,%eax
  800d37:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  800d3d:	89 df                	mov    %ebx,%edi
  800d3f:	89 de                	mov    %ebx,%esi
  800d41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d43:	85 c0                	test   %eax,%eax
  800d45:	7f 08                	jg     800d4f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
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
  800d53:	6a 09                	push   $0x9
  800d55:	68 7f 24 80 00       	push   $0x80247f
  800d5a:	6a 23                	push   $0x23
  800d5c:	68 9c 24 80 00       	push   $0x80249c
  800d61:	e8 2d f4 ff ff       	call   800193 <_panic>

00800d66 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
  800d69:	57                   	push   %edi
  800d6a:	56                   	push   %esi
  800d6b:	53                   	push   %ebx
  800d6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d74:	b8 0a 00 00 00       	mov    $0xa,%eax
  800d79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d7f:	89 df                	mov    %ebx,%edi
  800d81:	89 de                	mov    %ebx,%esi
  800d83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d85:	85 c0                	test   %eax,%eax
  800d87:	7f 08                	jg     800d91 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800d89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d8c:	5b                   	pop    %ebx
  800d8d:	5e                   	pop    %esi
  800d8e:	5f                   	pop    %edi
  800d8f:	5d                   	pop    %ebp
  800d90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d91:	83 ec 0c             	sub    $0xc,%esp
  800d94:	50                   	push   %eax
  800d95:	6a 0a                	push   $0xa
  800d97:	68 7f 24 80 00       	push   $0x80247f
  800d9c:	6a 23                	push   $0x23
  800d9e:	68 9c 24 80 00       	push   $0x80249c
  800da3:	e8 eb f3 ff ff       	call   800193 <_panic>

00800da8 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800da8:	55                   	push   %ebp
  800da9:	89 e5                	mov    %esp,%ebp
  800dab:	57                   	push   %edi
  800dac:	56                   	push   %esi
  800dad:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dae:	be 00 00 00 00       	mov    $0x0,%esi
  800db3:	b8 0d 00 00 00       	mov    $0xd,%eax
  800db8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dbb:	8b 55 08             	mov    0x8(%ebp),%edx
  800dbe:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800dc1:	8b 7d 14             	mov    0x14(%ebp),%edi
  800dc4:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800dc6:	5b                   	pop    %ebx
  800dc7:	5e                   	pop    %esi
  800dc8:	5f                   	pop    %edi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	57                   	push   %edi
  800dcf:	56                   	push   %esi
  800dd0:	53                   	push   %ebx
  800dd1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  800dd9:	b8 0e 00 00 00       	mov    $0xe,%eax
  800dde:	8b 55 08             	mov    0x8(%ebp),%edx
  800de1:	89 cb                	mov    %ecx,%ebx
  800de3:	89 cf                	mov    %ecx,%edi
  800de5:	89 ce                	mov    %ecx,%esi
  800de7:	cd 30                	int    $0x30
	if(check && ret > 0)
  800de9:	85 c0                	test   %eax,%eax
  800deb:	7f 08                	jg     800df5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800ded:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df0:	5b                   	pop    %ebx
  800df1:	5e                   	pop    %esi
  800df2:	5f                   	pop    %edi
  800df3:	5d                   	pop    %ebp
  800df4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df5:	83 ec 0c             	sub    $0xc,%esp
  800df8:	50                   	push   %eax
  800df9:	6a 0e                	push   $0xe
  800dfb:	68 7f 24 80 00       	push   $0x80247f
  800e00:	6a 23                	push   $0x23
  800e02:	68 9c 24 80 00       	push   $0x80249c
  800e07:	e8 87 f3 ff ff       	call   800193 <_panic>

00800e0c <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	57                   	push   %edi
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e12:	be 00 00 00 00       	mov    $0x0,%esi
  800e17:	b8 0f 00 00 00       	mov    $0xf,%eax
  800e1c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e25:	89 f7                	mov    %esi,%edi
  800e27:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e34:	be 00 00 00 00       	mov    $0x0,%esi
  800e39:	b8 10 00 00 00       	mov    $0x10,%eax
  800e3e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e41:	8b 55 08             	mov    0x8(%ebp),%edx
  800e44:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800e47:	89 f7                	mov    %esi,%edi
  800e49:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800e4b:	5b                   	pop    %ebx
  800e4c:	5e                   	pop    %esi
  800e4d:	5f                   	pop    %edi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	57                   	push   %edi
  800e54:	56                   	push   %esi
  800e55:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e56:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e5b:	b8 11 00 00 00       	mov    $0x11,%eax
  800e60:	8b 55 08             	mov    0x8(%ebp),%edx
  800e63:	89 cb                	mov    %ecx,%ebx
  800e65:	89 cf                	mov    %ecx,%edi
  800e67:	89 ce                	mov    %ecx,%esi
  800e69:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800e6b:	5b                   	pop    %ebx
  800e6c:	5e                   	pop    %esi
  800e6d:	5f                   	pop    %edi
  800e6e:	5d                   	pop    %ebp
  800e6f:	c3                   	ret    

00800e70 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	05 00 00 00 30       	add    $0x30000000,%eax
  800e7b:	c1 e8 0c             	shr    $0xc,%eax
}
  800e7e:	5d                   	pop    %ebp
  800e7f:	c3                   	ret    

00800e80 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800e80:	55                   	push   %ebp
  800e81:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800e8b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800e90:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800e95:	5d                   	pop    %ebp
  800e96:	c3                   	ret    

00800e97 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800e97:	55                   	push   %ebp
  800e98:	89 e5                	mov    %esp,%ebp
  800e9a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e9d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800ea2:	89 c2                	mov    %eax,%edx
  800ea4:	c1 ea 16             	shr    $0x16,%edx
  800ea7:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800eae:	f6 c2 01             	test   $0x1,%dl
  800eb1:	74 2a                	je     800edd <fd_alloc+0x46>
  800eb3:	89 c2                	mov    %eax,%edx
  800eb5:	c1 ea 0c             	shr    $0xc,%edx
  800eb8:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800ebf:	f6 c2 01             	test   $0x1,%dl
  800ec2:	74 19                	je     800edd <fd_alloc+0x46>
  800ec4:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800ec9:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800ece:	75 d2                	jne    800ea2 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800ed0:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800ed6:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800edb:	eb 07                	jmp    800ee4 <fd_alloc+0x4d>
			*fd_store = fd;
  800edd:	89 01                	mov    %eax,(%ecx)
			return 0;
  800edf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ee4:	5d                   	pop    %ebp
  800ee5:	c3                   	ret    

00800ee6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800ee6:	55                   	push   %ebp
  800ee7:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800ee9:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800eed:	77 39                	ja     800f28 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	c1 e0 0c             	shl    $0xc,%eax
  800ef5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800efa:	89 c2                	mov    %eax,%edx
  800efc:	c1 ea 16             	shr    $0x16,%edx
  800eff:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800f06:	f6 c2 01             	test   $0x1,%dl
  800f09:	74 24                	je     800f2f <fd_lookup+0x49>
  800f0b:	89 c2                	mov    %eax,%edx
  800f0d:	c1 ea 0c             	shr    $0xc,%edx
  800f10:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800f17:	f6 c2 01             	test   $0x1,%dl
  800f1a:	74 1a                	je     800f36 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  800f1c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f1f:	89 02                	mov    %eax,(%edx)
	return 0;
  800f21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    
		return -E_INVAL;
  800f28:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f2d:	eb f7                	jmp    800f26 <fd_lookup+0x40>
		return -E_INVAL;
  800f2f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f34:	eb f0                	jmp    800f26 <fd_lookup+0x40>
  800f36:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800f3b:	eb e9                	jmp    800f26 <fd_lookup+0x40>

00800f3d <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 08             	sub    $0x8,%esp
  800f43:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f46:	ba 28 25 80 00       	mov    $0x802528,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  800f4b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800f50:	39 08                	cmp    %ecx,(%eax)
  800f52:	74 33                	je     800f87 <dev_lookup+0x4a>
  800f54:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800f57:	8b 02                	mov    (%edx),%eax
  800f59:	85 c0                	test   %eax,%eax
  800f5b:	75 f3                	jne    800f50 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  800f5d:	a1 20 60 80 00       	mov    0x806020,%eax
  800f62:	8b 40 48             	mov    0x48(%eax),%eax
  800f65:	83 ec 04             	sub    $0x4,%esp
  800f68:	51                   	push   %ecx
  800f69:	50                   	push   %eax
  800f6a:	68 ac 24 80 00       	push   $0x8024ac
  800f6f:	e8 ae 0d 00 00       	call   801d22 <cprintf>
	*dev = 0;
  800f74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f77:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800f7d:	83 c4 10             	add    $0x10,%esp
  800f80:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800f85:	c9                   	leave  
  800f86:	c3                   	ret    
			*dev = devtab[i];
  800f87:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f8a:	89 01                	mov    %eax,(%ecx)
			return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
  800f91:	eb f2                	jmp    800f85 <dev_lookup+0x48>

00800f93 <fd_close>:
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	57                   	push   %edi
  800f97:	56                   	push   %esi
  800f98:	53                   	push   %ebx
  800f99:	83 ec 1c             	sub    $0x1c,%esp
  800f9c:	8b 75 08             	mov    0x8(%ebp),%esi
  800f9f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800fa2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800fa5:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800fa6:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800fac:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800faf:	50                   	push   %eax
  800fb0:	e8 31 ff ff ff       	call   800ee6 <fd_lookup>
  800fb5:	89 c7                	mov    %eax,%edi
  800fb7:	83 c4 08             	add    $0x8,%esp
  800fba:	85 c0                	test   %eax,%eax
  800fbc:	78 05                	js     800fc3 <fd_close+0x30>
	    || fd != fd2)
  800fbe:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800fc1:	74 13                	je     800fd6 <fd_close+0x43>
		return (must_exist ? r : 0);
  800fc3:	84 db                	test   %bl,%bl
  800fc5:	75 05                	jne    800fcc <fd_close+0x39>
  800fc7:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800fcc:	89 f8                	mov    %edi,%eax
  800fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800fd6:	83 ec 08             	sub    $0x8,%esp
  800fd9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800fdc:	50                   	push   %eax
  800fdd:	ff 36                	pushl  (%esi)
  800fdf:	e8 59 ff ff ff       	call   800f3d <dev_lookup>
  800fe4:	89 c7                	mov    %eax,%edi
  800fe6:	83 c4 10             	add    $0x10,%esp
  800fe9:	85 c0                	test   %eax,%eax
  800feb:	78 15                	js     801002 <fd_close+0x6f>
		if (dev->dev_close)
  800fed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ff0:	8b 40 10             	mov    0x10(%eax),%eax
  800ff3:	85 c0                	test   %eax,%eax
  800ff5:	74 1b                	je     801012 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800ff7:	83 ec 0c             	sub    $0xc,%esp
  800ffa:	56                   	push   %esi
  800ffb:	ff d0                	call   *%eax
  800ffd:	89 c7                	mov    %eax,%edi
  800fff:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801002:	83 ec 08             	sub    $0x8,%esp
  801005:	56                   	push   %esi
  801006:	6a 00                	push   $0x0
  801008:	e8 33 fc ff ff       	call   800c40 <sys_page_unmap>
	return r;
  80100d:	83 c4 10             	add    $0x10,%esp
  801010:	eb ba                	jmp    800fcc <fd_close+0x39>
			r = 0;
  801012:	bf 00 00 00 00       	mov    $0x0,%edi
  801017:	eb e9                	jmp    801002 <fd_close+0x6f>

00801019 <close>:

int
close(int fdnum)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80101f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801022:	50                   	push   %eax
  801023:	ff 75 08             	pushl  0x8(%ebp)
  801026:	e8 bb fe ff ff       	call   800ee6 <fd_lookup>
  80102b:	83 c4 08             	add    $0x8,%esp
  80102e:	85 c0                	test   %eax,%eax
  801030:	78 10                	js     801042 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801032:	83 ec 08             	sub    $0x8,%esp
  801035:	6a 01                	push   $0x1
  801037:	ff 75 f4             	pushl  -0xc(%ebp)
  80103a:	e8 54 ff ff ff       	call   800f93 <fd_close>
  80103f:	83 c4 10             	add    $0x10,%esp
}
  801042:	c9                   	leave  
  801043:	c3                   	ret    

00801044 <close_all>:

void
close_all(void)
{
  801044:	55                   	push   %ebp
  801045:	89 e5                	mov    %esp,%ebp
  801047:	53                   	push   %ebx
  801048:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80104b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801050:	83 ec 0c             	sub    $0xc,%esp
  801053:	53                   	push   %ebx
  801054:	e8 c0 ff ff ff       	call   801019 <close>
	for (i = 0; i < MAXFD; i++)
  801059:	43                   	inc    %ebx
  80105a:	83 c4 10             	add    $0x10,%esp
  80105d:	83 fb 20             	cmp    $0x20,%ebx
  801060:	75 ee                	jne    801050 <close_all+0xc>
}
  801062:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801065:	c9                   	leave  
  801066:	c3                   	ret    

00801067 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801067:	55                   	push   %ebp
  801068:	89 e5                	mov    %esp,%ebp
  80106a:	57                   	push   %edi
  80106b:	56                   	push   %esi
  80106c:	53                   	push   %ebx
  80106d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801070:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801073:	50                   	push   %eax
  801074:	ff 75 08             	pushl  0x8(%ebp)
  801077:	e8 6a fe ff ff       	call   800ee6 <fd_lookup>
  80107c:	89 c3                	mov    %eax,%ebx
  80107e:	83 c4 08             	add    $0x8,%esp
  801081:	85 c0                	test   %eax,%eax
  801083:	0f 88 81 00 00 00    	js     80110a <dup+0xa3>
		return r;
	close(newfdnum);
  801089:	83 ec 0c             	sub    $0xc,%esp
  80108c:	ff 75 0c             	pushl  0xc(%ebp)
  80108f:	e8 85 ff ff ff       	call   801019 <close>

	newfd = INDEX2FD(newfdnum);
  801094:	8b 75 0c             	mov    0xc(%ebp),%esi
  801097:	c1 e6 0c             	shl    $0xc,%esi
  80109a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8010a0:	83 c4 04             	add    $0x4,%esp
  8010a3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010a6:	e8 d5 fd ff ff       	call   800e80 <fd2data>
  8010ab:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8010ad:	89 34 24             	mov    %esi,(%esp)
  8010b0:	e8 cb fd ff ff       	call   800e80 <fd2data>
  8010b5:	83 c4 10             	add    $0x10,%esp
  8010b8:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8010ba:	89 d8                	mov    %ebx,%eax
  8010bc:	c1 e8 16             	shr    $0x16,%eax
  8010bf:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8010c6:	a8 01                	test   $0x1,%al
  8010c8:	74 11                	je     8010db <dup+0x74>
  8010ca:	89 d8                	mov    %ebx,%eax
  8010cc:	c1 e8 0c             	shr    $0xc,%eax
  8010cf:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8010d6:	f6 c2 01             	test   $0x1,%dl
  8010d9:	75 39                	jne    801114 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8010db:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e8 0c             	shr    $0xc,%eax
  8010e3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8010ea:	83 ec 0c             	sub    $0xc,%esp
  8010ed:	25 07 0e 00 00       	and    $0xe07,%eax
  8010f2:	50                   	push   %eax
  8010f3:	56                   	push   %esi
  8010f4:	6a 00                	push   $0x0
  8010f6:	52                   	push   %edx
  8010f7:	6a 00                	push   $0x0
  8010f9:	e8 00 fb ff ff       	call   800bfe <sys_page_map>
  8010fe:	89 c3                	mov    %eax,%ebx
  801100:	83 c4 20             	add    $0x20,%esp
  801103:	85 c0                	test   %eax,%eax
  801105:	78 31                	js     801138 <dup+0xd1>
		goto err;

	return newfdnum;
  801107:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80110a:	89 d8                	mov    %ebx,%eax
  80110c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110f:	5b                   	pop    %ebx
  801110:	5e                   	pop    %esi
  801111:	5f                   	pop    %edi
  801112:	5d                   	pop    %ebp
  801113:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801114:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80111b:	83 ec 0c             	sub    $0xc,%esp
  80111e:	25 07 0e 00 00       	and    $0xe07,%eax
  801123:	50                   	push   %eax
  801124:	57                   	push   %edi
  801125:	6a 00                	push   $0x0
  801127:	53                   	push   %ebx
  801128:	6a 00                	push   $0x0
  80112a:	e8 cf fa ff ff       	call   800bfe <sys_page_map>
  80112f:	89 c3                	mov    %eax,%ebx
  801131:	83 c4 20             	add    $0x20,%esp
  801134:	85 c0                	test   %eax,%eax
  801136:	79 a3                	jns    8010db <dup+0x74>
	sys_page_unmap(0, newfd);
  801138:	83 ec 08             	sub    $0x8,%esp
  80113b:	56                   	push   %esi
  80113c:	6a 00                	push   $0x0
  80113e:	e8 fd fa ff ff       	call   800c40 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801143:	83 c4 08             	add    $0x8,%esp
  801146:	57                   	push   %edi
  801147:	6a 00                	push   $0x0
  801149:	e8 f2 fa ff ff       	call   800c40 <sys_page_unmap>
	return r;
  80114e:	83 c4 10             	add    $0x10,%esp
  801151:	eb b7                	jmp    80110a <dup+0xa3>

00801153 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	53                   	push   %ebx
  801157:	83 ec 14             	sub    $0x14,%esp
  80115a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80115d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801160:	50                   	push   %eax
  801161:	53                   	push   %ebx
  801162:	e8 7f fd ff ff       	call   800ee6 <fd_lookup>
  801167:	83 c4 08             	add    $0x8,%esp
  80116a:	85 c0                	test   %eax,%eax
  80116c:	78 3f                	js     8011ad <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80116e:	83 ec 08             	sub    $0x8,%esp
  801171:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801174:	50                   	push   %eax
  801175:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801178:	ff 30                	pushl  (%eax)
  80117a:	e8 be fd ff ff       	call   800f3d <dev_lookup>
  80117f:	83 c4 10             	add    $0x10,%esp
  801182:	85 c0                	test   %eax,%eax
  801184:	78 27                	js     8011ad <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801186:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801189:	8b 42 08             	mov    0x8(%edx),%eax
  80118c:	83 e0 03             	and    $0x3,%eax
  80118f:	83 f8 01             	cmp    $0x1,%eax
  801192:	74 1e                	je     8011b2 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801194:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801197:	8b 40 08             	mov    0x8(%eax),%eax
  80119a:	85 c0                	test   %eax,%eax
  80119c:	74 35                	je     8011d3 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80119e:	83 ec 04             	sub    $0x4,%esp
  8011a1:	ff 75 10             	pushl  0x10(%ebp)
  8011a4:	ff 75 0c             	pushl  0xc(%ebp)
  8011a7:	52                   	push   %edx
  8011a8:	ff d0                	call   *%eax
  8011aa:	83 c4 10             	add    $0x10,%esp
}
  8011ad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b0:	c9                   	leave  
  8011b1:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8011b2:	a1 20 60 80 00       	mov    0x806020,%eax
  8011b7:	8b 40 48             	mov    0x48(%eax),%eax
  8011ba:	83 ec 04             	sub    $0x4,%esp
  8011bd:	53                   	push   %ebx
  8011be:	50                   	push   %eax
  8011bf:	68 ed 24 80 00       	push   $0x8024ed
  8011c4:	e8 59 0b 00 00       	call   801d22 <cprintf>
		return -E_INVAL;
  8011c9:	83 c4 10             	add    $0x10,%esp
  8011cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8011d1:	eb da                	jmp    8011ad <read+0x5a>
		return -E_NOT_SUPP;
  8011d3:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8011d8:	eb d3                	jmp    8011ad <read+0x5a>

008011da <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8011da:	55                   	push   %ebp
  8011db:	89 e5                	mov    %esp,%ebp
  8011dd:	57                   	push   %edi
  8011de:	56                   	push   %esi
  8011df:	53                   	push   %ebx
  8011e0:	83 ec 0c             	sub    $0xc,%esp
  8011e3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8011e6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8011e9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8011ee:	39 f3                	cmp    %esi,%ebx
  8011f0:	73 25                	jae    801217 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8011f2:	83 ec 04             	sub    $0x4,%esp
  8011f5:	89 f0                	mov    %esi,%eax
  8011f7:	29 d8                	sub    %ebx,%eax
  8011f9:	50                   	push   %eax
  8011fa:	89 d8                	mov    %ebx,%eax
  8011fc:	03 45 0c             	add    0xc(%ebp),%eax
  8011ff:	50                   	push   %eax
  801200:	57                   	push   %edi
  801201:	e8 4d ff ff ff       	call   801153 <read>
		if (m < 0)
  801206:	83 c4 10             	add    $0x10,%esp
  801209:	85 c0                	test   %eax,%eax
  80120b:	78 08                	js     801215 <readn+0x3b>
			return m;
		if (m == 0)
  80120d:	85 c0                	test   %eax,%eax
  80120f:	74 06                	je     801217 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  801211:	01 c3                	add    %eax,%ebx
  801213:	eb d9                	jmp    8011ee <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801215:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801217:	89 d8                	mov    %ebx,%eax
  801219:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80121c:	5b                   	pop    %ebx
  80121d:	5e                   	pop    %esi
  80121e:	5f                   	pop    %edi
  80121f:	5d                   	pop    %ebp
  801220:	c3                   	ret    

00801221 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  801221:	55                   	push   %ebp
  801222:	89 e5                	mov    %esp,%ebp
  801224:	53                   	push   %ebx
  801225:	83 ec 14             	sub    $0x14,%esp
  801228:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80122b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80122e:	50                   	push   %eax
  80122f:	53                   	push   %ebx
  801230:	e8 b1 fc ff ff       	call   800ee6 <fd_lookup>
  801235:	83 c4 08             	add    $0x8,%esp
  801238:	85 c0                	test   %eax,%eax
  80123a:	78 3a                	js     801276 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80123c:	83 ec 08             	sub    $0x8,%esp
  80123f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801246:	ff 30                	pushl  (%eax)
  801248:	e8 f0 fc ff ff       	call   800f3d <dev_lookup>
  80124d:	83 c4 10             	add    $0x10,%esp
  801250:	85 c0                	test   %eax,%eax
  801252:	78 22                	js     801276 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801254:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801257:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80125b:	74 1e                	je     80127b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80125d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801260:	8b 52 0c             	mov    0xc(%edx),%edx
  801263:	85 d2                	test   %edx,%edx
  801265:	74 35                	je     80129c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801267:	83 ec 04             	sub    $0x4,%esp
  80126a:	ff 75 10             	pushl  0x10(%ebp)
  80126d:	ff 75 0c             	pushl  0xc(%ebp)
  801270:	50                   	push   %eax
  801271:	ff d2                	call   *%edx
  801273:	83 c4 10             	add    $0x10,%esp
}
  801276:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801279:	c9                   	leave  
  80127a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80127b:	a1 20 60 80 00       	mov    0x806020,%eax
  801280:	8b 40 48             	mov    0x48(%eax),%eax
  801283:	83 ec 04             	sub    $0x4,%esp
  801286:	53                   	push   %ebx
  801287:	50                   	push   %eax
  801288:	68 09 25 80 00       	push   $0x802509
  80128d:	e8 90 0a 00 00       	call   801d22 <cprintf>
		return -E_INVAL;
  801292:	83 c4 10             	add    $0x10,%esp
  801295:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80129a:	eb da                	jmp    801276 <write+0x55>
		return -E_NOT_SUPP;
  80129c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8012a1:	eb d3                	jmp    801276 <write+0x55>

008012a3 <seek>:

int
seek(int fdnum, off_t offset)
{
  8012a3:	55                   	push   %ebp
  8012a4:	89 e5                	mov    %esp,%ebp
  8012a6:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8012a9:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8012ac:	50                   	push   %eax
  8012ad:	ff 75 08             	pushl  0x8(%ebp)
  8012b0:	e8 31 fc ff ff       	call   800ee6 <fd_lookup>
  8012b5:	83 c4 08             	add    $0x8,%esp
  8012b8:	85 c0                	test   %eax,%eax
  8012ba:	78 0e                	js     8012ca <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8012bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012c2:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8012c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ca:	c9                   	leave  
  8012cb:	c3                   	ret    

008012cc <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8012cc:	55                   	push   %ebp
  8012cd:	89 e5                	mov    %esp,%ebp
  8012cf:	53                   	push   %ebx
  8012d0:	83 ec 14             	sub    $0x14,%esp
  8012d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8012d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8012d9:	50                   	push   %eax
  8012da:	53                   	push   %ebx
  8012db:	e8 06 fc ff ff       	call   800ee6 <fd_lookup>
  8012e0:	83 c4 08             	add    $0x8,%esp
  8012e3:	85 c0                	test   %eax,%eax
  8012e5:	78 37                	js     80131e <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8012e7:	83 ec 08             	sub    $0x8,%esp
  8012ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8012ed:	50                   	push   %eax
  8012ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8012f1:	ff 30                	pushl  (%eax)
  8012f3:	e8 45 fc ff ff       	call   800f3d <dev_lookup>
  8012f8:	83 c4 10             	add    $0x10,%esp
  8012fb:	85 c0                	test   %eax,%eax
  8012fd:	78 1f                	js     80131e <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8012ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801302:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801306:	74 1b                	je     801323 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801308:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80130b:	8b 52 18             	mov    0x18(%edx),%edx
  80130e:	85 d2                	test   %edx,%edx
  801310:	74 32                	je     801344 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801312:	83 ec 08             	sub    $0x8,%esp
  801315:	ff 75 0c             	pushl  0xc(%ebp)
  801318:	50                   	push   %eax
  801319:	ff d2                	call   *%edx
  80131b:	83 c4 10             	add    $0x10,%esp
}
  80131e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801321:	c9                   	leave  
  801322:	c3                   	ret    
			thisenv->env_id, fdnum);
  801323:	a1 20 60 80 00       	mov    0x806020,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801328:	8b 40 48             	mov    0x48(%eax),%eax
  80132b:	83 ec 04             	sub    $0x4,%esp
  80132e:	53                   	push   %ebx
  80132f:	50                   	push   %eax
  801330:	68 cc 24 80 00       	push   $0x8024cc
  801335:	e8 e8 09 00 00       	call   801d22 <cprintf>
		return -E_INVAL;
  80133a:	83 c4 10             	add    $0x10,%esp
  80133d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801342:	eb da                	jmp    80131e <ftruncate+0x52>
		return -E_NOT_SUPP;
  801344:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801349:	eb d3                	jmp    80131e <ftruncate+0x52>

0080134b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80134b:	55                   	push   %ebp
  80134c:	89 e5                	mov    %esp,%ebp
  80134e:	53                   	push   %ebx
  80134f:	83 ec 14             	sub    $0x14,%esp
  801352:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801355:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801358:	50                   	push   %eax
  801359:	ff 75 08             	pushl  0x8(%ebp)
  80135c:	e8 85 fb ff ff       	call   800ee6 <fd_lookup>
  801361:	83 c4 08             	add    $0x8,%esp
  801364:	85 c0                	test   %eax,%eax
  801366:	78 4b                	js     8013b3 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801368:	83 ec 08             	sub    $0x8,%esp
  80136b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80136e:	50                   	push   %eax
  80136f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801372:	ff 30                	pushl  (%eax)
  801374:	e8 c4 fb ff ff       	call   800f3d <dev_lookup>
  801379:	83 c4 10             	add    $0x10,%esp
  80137c:	85 c0                	test   %eax,%eax
  80137e:	78 33                	js     8013b3 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801380:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801383:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801387:	74 2f                	je     8013b8 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801389:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80138c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801393:	00 00 00 
	stat->st_type = 0;
  801396:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80139d:	00 00 00 
	stat->st_dev = dev;
  8013a0:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8013a6:	83 ec 08             	sub    $0x8,%esp
  8013a9:	53                   	push   %ebx
  8013aa:	ff 75 f0             	pushl  -0x10(%ebp)
  8013ad:	ff 50 14             	call   *0x14(%eax)
  8013b0:	83 c4 10             	add    $0x10,%esp
}
  8013b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8013b6:	c9                   	leave  
  8013b7:	c3                   	ret    
		return -E_NOT_SUPP;
  8013b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8013bd:	eb f4                	jmp    8013b3 <fstat+0x68>

008013bf <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	56                   	push   %esi
  8013c3:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8013c4:	83 ec 08             	sub    $0x8,%esp
  8013c7:	6a 00                	push   $0x0
  8013c9:	ff 75 08             	pushl  0x8(%ebp)
  8013cc:	e8 34 02 00 00       	call   801605 <open>
  8013d1:	89 c3                	mov    %eax,%ebx
  8013d3:	83 c4 10             	add    $0x10,%esp
  8013d6:	85 c0                	test   %eax,%eax
  8013d8:	78 1b                	js     8013f5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8013da:	83 ec 08             	sub    $0x8,%esp
  8013dd:	ff 75 0c             	pushl  0xc(%ebp)
  8013e0:	50                   	push   %eax
  8013e1:	e8 65 ff ff ff       	call   80134b <fstat>
  8013e6:	89 c6                	mov    %eax,%esi
	close(fd);
  8013e8:	89 1c 24             	mov    %ebx,(%esp)
  8013eb:	e8 29 fc ff ff       	call   801019 <close>
	return r;
  8013f0:	83 c4 10             	add    $0x10,%esp
  8013f3:	89 f3                	mov    %esi,%ebx
}
  8013f5:	89 d8                	mov    %ebx,%eax
  8013f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8013fa:	5b                   	pop    %ebx
  8013fb:	5e                   	pop    %esi
  8013fc:	5d                   	pop    %ebp
  8013fd:	c3                   	ret    

008013fe <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8013fe:	55                   	push   %ebp
  8013ff:	89 e5                	mov    %esp,%ebp
  801401:	56                   	push   %esi
  801402:	53                   	push   %ebx
  801403:	89 c6                	mov    %eax,%esi
  801405:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801407:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80140e:	74 27                	je     801437 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801410:	6a 07                	push   $0x7
  801412:	68 00 70 80 00       	push   $0x807000
  801417:	56                   	push   %esi
  801418:	ff 35 00 40 80 00    	pushl  0x804000
  80141e:	e8 9c 09 00 00       	call   801dbf <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801423:	83 c4 0c             	add    $0xc,%esp
  801426:	6a 00                	push   $0x0
  801428:	53                   	push   %ebx
  801429:	6a 00                	push   $0x0
  80142b:	e8 06 09 00 00       	call   801d36 <ipc_recv>
}
  801430:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801433:	5b                   	pop    %ebx
  801434:	5e                   	pop    %esi
  801435:	5d                   	pop    %ebp
  801436:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801437:	83 ec 0c             	sub    $0xc,%esp
  80143a:	6a 01                	push   $0x1
  80143c:	e8 da 09 00 00       	call   801e1b <ipc_find_env>
  801441:	a3 00 40 80 00       	mov    %eax,0x804000
  801446:	83 c4 10             	add    $0x10,%esp
  801449:	eb c5                	jmp    801410 <fsipc+0x12>

0080144b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	8b 40 0c             	mov    0xc(%eax),%eax
  801457:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  80145c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80145f:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801464:	ba 00 00 00 00       	mov    $0x0,%edx
  801469:	b8 02 00 00 00       	mov    $0x2,%eax
  80146e:	e8 8b ff ff ff       	call   8013fe <fsipc>
}
  801473:	c9                   	leave  
  801474:	c3                   	ret    

00801475 <devfile_flush>:
{
  801475:	55                   	push   %ebp
  801476:	89 e5                	mov    %esp,%ebp
  801478:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
  80147e:	8b 40 0c             	mov    0xc(%eax),%eax
  801481:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  801486:	ba 00 00 00 00       	mov    $0x0,%edx
  80148b:	b8 06 00 00 00       	mov    $0x6,%eax
  801490:	e8 69 ff ff ff       	call   8013fe <fsipc>
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <devfile_stat>:
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	53                   	push   %ebx
  80149b:	83 ec 04             	sub    $0x4,%esp
  80149e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8b 40 0c             	mov    0xc(%eax),%eax
  8014a7:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8014ac:	ba 00 00 00 00       	mov    $0x0,%edx
  8014b1:	b8 05 00 00 00       	mov    $0x5,%eax
  8014b6:	e8 43 ff ff ff       	call   8013fe <fsipc>
  8014bb:	85 c0                	test   %eax,%eax
  8014bd:	78 2c                	js     8014eb <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8014bf:	83 ec 08             	sub    $0x8,%esp
  8014c2:	68 00 70 80 00       	push   $0x807000
  8014c7:	53                   	push   %ebx
  8014c8:	e8 39 f3 ff ff       	call   800806 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8014cd:	a1 80 70 80 00       	mov    0x807080,%eax
  8014d2:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8014d8:	a1 84 70 80 00       	mov    0x807084,%eax
  8014dd:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8014e3:	83 c4 10             	add    $0x10,%esp
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014ee:	c9                   	leave  
  8014ef:	c3                   	ret    

008014f0 <devfile_write>:
{
  8014f0:	55                   	push   %ebp
  8014f1:	89 e5                	mov    %esp,%ebp
  8014f3:	53                   	push   %ebx
  8014f4:	83 ec 04             	sub    $0x4,%esp
  8014f7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8014fa:	89 d8                	mov    %ebx,%eax
  8014fc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801502:	76 05                	jbe    801509 <devfile_write+0x19>
  801504:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801509:	8b 55 08             	mov    0x8(%ebp),%edx
  80150c:	8b 52 0c             	mov    0xc(%edx),%edx
  80150f:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = size;
  801515:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80151a:	83 ec 04             	sub    $0x4,%esp
  80151d:	50                   	push   %eax
  80151e:	ff 75 0c             	pushl  0xc(%ebp)
  801521:	68 08 70 80 00       	push   $0x807008
  801526:	e8 4e f4 ff ff       	call   800979 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  80152b:	ba 00 00 00 00       	mov    $0x0,%edx
  801530:	b8 04 00 00 00       	mov    $0x4,%eax
  801535:	e8 c4 fe ff ff       	call   8013fe <fsipc>
  80153a:	83 c4 10             	add    $0x10,%esp
  80153d:	85 c0                	test   %eax,%eax
  80153f:	78 0b                	js     80154c <devfile_write+0x5c>
	assert(r <= n);
  801541:	39 c3                	cmp    %eax,%ebx
  801543:	72 0c                	jb     801551 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801545:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80154a:	7f 1e                	jg     80156a <devfile_write+0x7a>
}
  80154c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80154f:	c9                   	leave  
  801550:	c3                   	ret    
	assert(r <= n);
  801551:	68 38 25 80 00       	push   $0x802538
  801556:	68 3f 25 80 00       	push   $0x80253f
  80155b:	68 98 00 00 00       	push   $0x98
  801560:	68 54 25 80 00       	push   $0x802554
  801565:	e8 29 ec ff ff       	call   800193 <_panic>
	assert(r <= PGSIZE);
  80156a:	68 5f 25 80 00       	push   $0x80255f
  80156f:	68 3f 25 80 00       	push   $0x80253f
  801574:	68 99 00 00 00       	push   $0x99
  801579:	68 54 25 80 00       	push   $0x802554
  80157e:	e8 10 ec ff ff       	call   800193 <_panic>

00801583 <devfile_read>:
{
  801583:	55                   	push   %ebp
  801584:	89 e5                	mov    %esp,%ebp
  801586:	56                   	push   %esi
  801587:	53                   	push   %ebx
  801588:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8b 40 0c             	mov    0xc(%eax),%eax
  801591:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  801596:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  80159c:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a1:	b8 03 00 00 00       	mov    $0x3,%eax
  8015a6:	e8 53 fe ff ff       	call   8013fe <fsipc>
  8015ab:	89 c3                	mov    %eax,%ebx
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	78 1f                	js     8015d0 <devfile_read+0x4d>
	assert(r <= n);
  8015b1:	39 c6                	cmp    %eax,%esi
  8015b3:	72 24                	jb     8015d9 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8015b5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8015ba:	7f 33                	jg     8015ef <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8015bc:	83 ec 04             	sub    $0x4,%esp
  8015bf:	50                   	push   %eax
  8015c0:	68 00 70 80 00       	push   $0x807000
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	e8 ac f3 ff ff       	call   800979 <memmove>
	return r;
  8015cd:	83 c4 10             	add    $0x10,%esp
}
  8015d0:	89 d8                	mov    %ebx,%eax
  8015d2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d5:	5b                   	pop    %ebx
  8015d6:	5e                   	pop    %esi
  8015d7:	5d                   	pop    %ebp
  8015d8:	c3                   	ret    
	assert(r <= n);
  8015d9:	68 38 25 80 00       	push   $0x802538
  8015de:	68 3f 25 80 00       	push   $0x80253f
  8015e3:	6a 7c                	push   $0x7c
  8015e5:	68 54 25 80 00       	push   $0x802554
  8015ea:	e8 a4 eb ff ff       	call   800193 <_panic>
	assert(r <= PGSIZE);
  8015ef:	68 5f 25 80 00       	push   $0x80255f
  8015f4:	68 3f 25 80 00       	push   $0x80253f
  8015f9:	6a 7d                	push   $0x7d
  8015fb:	68 54 25 80 00       	push   $0x802554
  801600:	e8 8e eb ff ff       	call   800193 <_panic>

00801605 <open>:
{
  801605:	55                   	push   %ebp
  801606:	89 e5                	mov    %esp,%ebp
  801608:	56                   	push   %esi
  801609:	53                   	push   %ebx
  80160a:	83 ec 1c             	sub    $0x1c,%esp
  80160d:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801610:	56                   	push   %esi
  801611:	e8 bd f1 ff ff       	call   8007d3 <strlen>
  801616:	83 c4 10             	add    $0x10,%esp
  801619:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80161e:	7f 6c                	jg     80168c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801620:	83 ec 0c             	sub    $0xc,%esp
  801623:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801626:	50                   	push   %eax
  801627:	e8 6b f8 ff ff       	call   800e97 <fd_alloc>
  80162c:	89 c3                	mov    %eax,%ebx
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	85 c0                	test   %eax,%eax
  801633:	78 3c                	js     801671 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	56                   	push   %esi
  801639:	68 00 70 80 00       	push   $0x807000
  80163e:	e8 c3 f1 ff ff       	call   800806 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801643:	8b 45 0c             	mov    0xc(%ebp),%eax
  801646:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  80164b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80164e:	b8 01 00 00 00       	mov    $0x1,%eax
  801653:	e8 a6 fd ff ff       	call   8013fe <fsipc>
  801658:	89 c3                	mov    %eax,%ebx
  80165a:	83 c4 10             	add    $0x10,%esp
  80165d:	85 c0                	test   %eax,%eax
  80165f:	78 19                	js     80167a <open+0x75>
	return fd2num(fd);
  801661:	83 ec 0c             	sub    $0xc,%esp
  801664:	ff 75 f4             	pushl  -0xc(%ebp)
  801667:	e8 04 f8 ff ff       	call   800e70 <fd2num>
  80166c:	89 c3                	mov    %eax,%ebx
  80166e:	83 c4 10             	add    $0x10,%esp
}
  801671:	89 d8                	mov    %ebx,%eax
  801673:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801676:	5b                   	pop    %ebx
  801677:	5e                   	pop    %esi
  801678:	5d                   	pop    %ebp
  801679:	c3                   	ret    
		fd_close(fd, 0);
  80167a:	83 ec 08             	sub    $0x8,%esp
  80167d:	6a 00                	push   $0x0
  80167f:	ff 75 f4             	pushl  -0xc(%ebp)
  801682:	e8 0c f9 ff ff       	call   800f93 <fd_close>
		return r;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	eb e5                	jmp    801671 <open+0x6c>
		return -E_BAD_PATH;
  80168c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801691:	eb de                	jmp    801671 <open+0x6c>

00801693 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801699:	ba 00 00 00 00       	mov    $0x0,%edx
  80169e:	b8 08 00 00 00       	mov    $0x8,%eax
  8016a3:	e8 56 fd ff ff       	call   8013fe <fsipc>
}
  8016a8:	c9                   	leave  
  8016a9:	c3                   	ret    

008016aa <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  8016aa:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  8016ae:	7e 38                	jle    8016e8 <writebuf+0x3e>
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	53                   	push   %ebx
  8016b4:	83 ec 08             	sub    $0x8,%esp
  8016b7:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  8016b9:	ff 70 04             	pushl  0x4(%eax)
  8016bc:	8d 40 10             	lea    0x10(%eax),%eax
  8016bf:	50                   	push   %eax
  8016c0:	ff 33                	pushl  (%ebx)
  8016c2:	e8 5a fb ff ff       	call   801221 <write>
		if (result > 0)
  8016c7:	83 c4 10             	add    $0x10,%esp
  8016ca:	85 c0                	test   %eax,%eax
  8016cc:	7e 03                	jle    8016d1 <writebuf+0x27>
			b->result += result;
  8016ce:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  8016d1:	3b 43 04             	cmp    0x4(%ebx),%eax
  8016d4:	74 0e                	je     8016e4 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  8016d6:	89 c2                	mov    %eax,%edx
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	7e 05                	jle    8016e1 <writebuf+0x37>
  8016dc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e1:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  8016e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <putch>:

static void
putch(int ch, void *thunk)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	53                   	push   %ebx
  8016ed:	83 ec 04             	sub    $0x4,%esp
  8016f0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  8016f3:	8b 53 04             	mov    0x4(%ebx),%edx
  8016f6:	8d 42 01             	lea    0x1(%edx),%eax
  8016f9:	89 43 04             	mov    %eax,0x4(%ebx)
  8016fc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8016ff:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  801703:	3d 00 01 00 00       	cmp    $0x100,%eax
  801708:	74 06                	je     801710 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80170a:	83 c4 04             	add    $0x4,%esp
  80170d:	5b                   	pop    %ebx
  80170e:	5d                   	pop    %ebp
  80170f:	c3                   	ret    
		writebuf(b);
  801710:	89 d8                	mov    %ebx,%eax
  801712:	e8 93 ff ff ff       	call   8016aa <writebuf>
		b->idx = 0;
  801717:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  80171e:	eb ea                	jmp    80170a <putch+0x21>

00801720 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
  801723:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  801732:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  801739:	00 00 00 
	b.result = 0;
  80173c:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801743:	00 00 00 
	b.error = 1;
  801746:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  80174d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  801750:	ff 75 10             	pushl  0x10(%ebp)
  801753:	ff 75 0c             	pushl  0xc(%ebp)
  801756:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  80175c:	50                   	push   %eax
  80175d:	68 e9 16 80 00       	push   $0x8016e9
  801762:	e8 91 eb ff ff       	call   8002f8 <vprintfmt>
	if (b.idx > 0)
  801767:	83 c4 10             	add    $0x10,%esp
  80176a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  801771:	7e 0b                	jle    80177e <vfprintf+0x5e>
		writebuf(&b);
  801773:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  801779:	e8 2c ff ff ff       	call   8016aa <writebuf>

	return (b.result ? b.result : b.error);
  80177e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  801784:	85 c0                	test   %eax,%eax
  801786:	75 06                	jne    80178e <vfprintf+0x6e>
  801788:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80178e:	c9                   	leave  
  80178f:	c3                   	ret    

00801790 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  801790:	55                   	push   %ebp
  801791:	89 e5                	mov    %esp,%ebp
  801793:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801796:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  801799:	50                   	push   %eax
  80179a:	ff 75 0c             	pushl  0xc(%ebp)
  80179d:	ff 75 08             	pushl  0x8(%ebp)
  8017a0:	e8 7b ff ff ff       	call   801720 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017a5:	c9                   	leave  
  8017a6:	c3                   	ret    

008017a7 <printf>:

int
printf(const char *fmt, ...)
{
  8017a7:	55                   	push   %ebp
  8017a8:	89 e5                	mov    %esp,%ebp
  8017aa:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8017ad:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  8017b0:	50                   	push   %eax
  8017b1:	ff 75 08             	pushl  0x8(%ebp)
  8017b4:	6a 01                	push   $0x1
  8017b6:	e8 65 ff ff ff       	call   801720 <vfprintf>
	va_end(ap);

	return cnt;
}
  8017bb:	c9                   	leave  
  8017bc:	c3                   	ret    

008017bd <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  8017bd:	55                   	push   %ebp
  8017be:	89 e5                	mov    %esp,%ebp
  8017c0:	56                   	push   %esi
  8017c1:	53                   	push   %ebx
  8017c2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  8017c5:	83 ec 0c             	sub    $0xc,%esp
  8017c8:	ff 75 08             	pushl  0x8(%ebp)
  8017cb:	e8 b0 f6 ff ff       	call   800e80 <fd2data>
  8017d0:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  8017d2:	83 c4 08             	add    $0x8,%esp
  8017d5:	68 6b 25 80 00       	push   $0x80256b
  8017da:	53                   	push   %ebx
  8017db:	e8 26 f0 ff ff       	call   800806 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  8017e0:	8b 46 04             	mov    0x4(%esi),%eax
  8017e3:	2b 06                	sub    (%esi),%eax
  8017e5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  8017eb:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  8017f2:	10 00 00 
	stat->st_dev = &devpipe;
  8017f5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  8017fc:	30 80 00 
	return 0;
}
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801807:	5b                   	pop    %ebx
  801808:	5e                   	pop    %esi
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	53                   	push   %ebx
  80180f:	83 ec 0c             	sub    $0xc,%esp
  801812:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801815:	53                   	push   %ebx
  801816:	6a 00                	push   $0x0
  801818:	e8 23 f4 ff ff       	call   800c40 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80181d:	89 1c 24             	mov    %ebx,(%esp)
  801820:	e8 5b f6 ff ff       	call   800e80 <fd2data>
  801825:	83 c4 08             	add    $0x8,%esp
  801828:	50                   	push   %eax
  801829:	6a 00                	push   $0x0
  80182b:	e8 10 f4 ff ff       	call   800c40 <sys_page_unmap>
}
  801830:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <_pipeisclosed>:
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	57                   	push   %edi
  801839:	56                   	push   %esi
  80183a:	53                   	push   %ebx
  80183b:	83 ec 1c             	sub    $0x1c,%esp
  80183e:	89 c7                	mov    %eax,%edi
  801840:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801842:	a1 20 60 80 00       	mov    0x806020,%eax
  801847:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80184a:	83 ec 0c             	sub    $0xc,%esp
  80184d:	57                   	push   %edi
  80184e:	e8 0a 06 00 00       	call   801e5d <pageref>
  801853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801856:	89 34 24             	mov    %esi,(%esp)
  801859:	e8 ff 05 00 00       	call   801e5d <pageref>
		nn = thisenv->env_runs;
  80185e:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801864:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801867:	83 c4 10             	add    $0x10,%esp
  80186a:	39 cb                	cmp    %ecx,%ebx
  80186c:	74 1b                	je     801889 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  80186e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801871:	75 cf                	jne    801842 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801873:	8b 42 58             	mov    0x58(%edx),%eax
  801876:	6a 01                	push   $0x1
  801878:	50                   	push   %eax
  801879:	53                   	push   %ebx
  80187a:	68 72 25 80 00       	push   $0x802572
  80187f:	e8 9e 04 00 00       	call   801d22 <cprintf>
  801884:	83 c4 10             	add    $0x10,%esp
  801887:	eb b9                	jmp    801842 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801889:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80188c:	0f 94 c0             	sete   %al
  80188f:	0f b6 c0             	movzbl %al,%eax
}
  801892:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801895:	5b                   	pop    %ebx
  801896:	5e                   	pop    %esi
  801897:	5f                   	pop    %edi
  801898:	5d                   	pop    %ebp
  801899:	c3                   	ret    

0080189a <devpipe_write>:
{
  80189a:	55                   	push   %ebp
  80189b:	89 e5                	mov    %esp,%ebp
  80189d:	57                   	push   %edi
  80189e:	56                   	push   %esi
  80189f:	53                   	push   %ebx
  8018a0:	83 ec 18             	sub    $0x18,%esp
  8018a3:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  8018a6:	56                   	push   %esi
  8018a7:	e8 d4 f5 ff ff       	call   800e80 <fd2data>
  8018ac:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8018ae:	83 c4 10             	add    $0x10,%esp
  8018b1:	bf 00 00 00 00       	mov    $0x0,%edi
  8018b6:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8018b9:	74 41                	je     8018fc <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8018bb:	8b 53 04             	mov    0x4(%ebx),%edx
  8018be:	8b 03                	mov    (%ebx),%eax
  8018c0:	83 c0 20             	add    $0x20,%eax
  8018c3:	39 c2                	cmp    %eax,%edx
  8018c5:	72 14                	jb     8018db <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8018c7:	89 da                	mov    %ebx,%edx
  8018c9:	89 f0                	mov    %esi,%eax
  8018cb:	e8 65 ff ff ff       	call   801835 <_pipeisclosed>
  8018d0:	85 c0                	test   %eax,%eax
  8018d2:	75 2c                	jne    801900 <devpipe_write+0x66>
			sys_yield();
  8018d4:	e8 a9 f3 ff ff       	call   800c82 <sys_yield>
  8018d9:	eb e0                	jmp    8018bb <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018de:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8018e1:	89 d0                	mov    %edx,%eax
  8018e3:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8018e8:	78 0b                	js     8018f5 <devpipe_write+0x5b>
  8018ea:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8018ee:	42                   	inc    %edx
  8018ef:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8018f2:	47                   	inc    %edi
  8018f3:	eb c1                	jmp    8018b6 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8018f5:	48                   	dec    %eax
  8018f6:	83 c8 e0             	or     $0xffffffe0,%eax
  8018f9:	40                   	inc    %eax
  8018fa:	eb ee                	jmp    8018ea <devpipe_write+0x50>
	return i;
  8018fc:	89 f8                	mov    %edi,%eax
  8018fe:	eb 05                	jmp    801905 <devpipe_write+0x6b>
				return 0;
  801900:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801905:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801908:	5b                   	pop    %ebx
  801909:	5e                   	pop    %esi
  80190a:	5f                   	pop    %edi
  80190b:	5d                   	pop    %ebp
  80190c:	c3                   	ret    

0080190d <devpipe_read>:
{
  80190d:	55                   	push   %ebp
  80190e:	89 e5                	mov    %esp,%ebp
  801910:	57                   	push   %edi
  801911:	56                   	push   %esi
  801912:	53                   	push   %ebx
  801913:	83 ec 18             	sub    $0x18,%esp
  801916:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801919:	57                   	push   %edi
  80191a:	e8 61 f5 ff ff       	call   800e80 <fd2data>
  80191f:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801921:	83 c4 10             	add    $0x10,%esp
  801924:	bb 00 00 00 00       	mov    $0x0,%ebx
  801929:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80192c:	74 46                	je     801974 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  80192e:	8b 06                	mov    (%esi),%eax
  801930:	3b 46 04             	cmp    0x4(%esi),%eax
  801933:	75 22                	jne    801957 <devpipe_read+0x4a>
			if (i > 0)
  801935:	85 db                	test   %ebx,%ebx
  801937:	74 0a                	je     801943 <devpipe_read+0x36>
				return i;
  801939:	89 d8                	mov    %ebx,%eax
}
  80193b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80193e:	5b                   	pop    %ebx
  80193f:	5e                   	pop    %esi
  801940:	5f                   	pop    %edi
  801941:	5d                   	pop    %ebp
  801942:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801943:	89 f2                	mov    %esi,%edx
  801945:	89 f8                	mov    %edi,%eax
  801947:	e8 e9 fe ff ff       	call   801835 <_pipeisclosed>
  80194c:	85 c0                	test   %eax,%eax
  80194e:	75 28                	jne    801978 <devpipe_read+0x6b>
			sys_yield();
  801950:	e8 2d f3 ff ff       	call   800c82 <sys_yield>
  801955:	eb d7                	jmp    80192e <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801957:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80195c:	78 0f                	js     80196d <devpipe_read+0x60>
  80195e:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801962:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801965:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801968:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  80196a:	43                   	inc    %ebx
  80196b:	eb bc                	jmp    801929 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80196d:	48                   	dec    %eax
  80196e:	83 c8 e0             	or     $0xffffffe0,%eax
  801971:	40                   	inc    %eax
  801972:	eb ea                	jmp    80195e <devpipe_read+0x51>
	return i;
  801974:	89 d8                	mov    %ebx,%eax
  801976:	eb c3                	jmp    80193b <devpipe_read+0x2e>
				return 0;
  801978:	b8 00 00 00 00       	mov    $0x0,%eax
  80197d:	eb bc                	jmp    80193b <devpipe_read+0x2e>

0080197f <pipe>:
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801987:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198a:	50                   	push   %eax
  80198b:	e8 07 f5 ff ff       	call   800e97 <fd_alloc>
  801990:	89 c3                	mov    %eax,%ebx
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	85 c0                	test   %eax,%eax
  801997:	0f 88 2a 01 00 00    	js     801ac7 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	68 07 04 00 00       	push   $0x407
  8019a5:	ff 75 f4             	pushl  -0xc(%ebp)
  8019a8:	6a 00                	push   $0x0
  8019aa:	e8 0c f2 ff ff       	call   800bbb <sys_page_alloc>
  8019af:	89 c3                	mov    %eax,%ebx
  8019b1:	83 c4 10             	add    $0x10,%esp
  8019b4:	85 c0                	test   %eax,%eax
  8019b6:	0f 88 0b 01 00 00    	js     801ac7 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8019bc:	83 ec 0c             	sub    $0xc,%esp
  8019bf:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019c2:	50                   	push   %eax
  8019c3:	e8 cf f4 ff ff       	call   800e97 <fd_alloc>
  8019c8:	89 c3                	mov    %eax,%ebx
  8019ca:	83 c4 10             	add    $0x10,%esp
  8019cd:	85 c0                	test   %eax,%eax
  8019cf:	0f 88 e2 00 00 00    	js     801ab7 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8019d5:	83 ec 04             	sub    $0x4,%esp
  8019d8:	68 07 04 00 00       	push   $0x407
  8019dd:	ff 75 f0             	pushl  -0x10(%ebp)
  8019e0:	6a 00                	push   $0x0
  8019e2:	e8 d4 f1 ff ff       	call   800bbb <sys_page_alloc>
  8019e7:	89 c3                	mov    %eax,%ebx
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	85 c0                	test   %eax,%eax
  8019ee:	0f 88 c3 00 00 00    	js     801ab7 <pipe+0x138>
	va = fd2data(fd0);
  8019f4:	83 ec 0c             	sub    $0xc,%esp
  8019f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8019fa:	e8 81 f4 ff ff       	call   800e80 <fd2data>
  8019ff:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a01:	83 c4 0c             	add    $0xc,%esp
  801a04:	68 07 04 00 00       	push   $0x407
  801a09:	50                   	push   %eax
  801a0a:	6a 00                	push   $0x0
  801a0c:	e8 aa f1 ff ff       	call   800bbb <sys_page_alloc>
  801a11:	89 c3                	mov    %eax,%ebx
  801a13:	83 c4 10             	add    $0x10,%esp
  801a16:	85 c0                	test   %eax,%eax
  801a18:	0f 88 89 00 00 00    	js     801aa7 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801a1e:	83 ec 0c             	sub    $0xc,%esp
  801a21:	ff 75 f0             	pushl  -0x10(%ebp)
  801a24:	e8 57 f4 ff ff       	call   800e80 <fd2data>
  801a29:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801a30:	50                   	push   %eax
  801a31:	6a 00                	push   $0x0
  801a33:	56                   	push   %esi
  801a34:	6a 00                	push   $0x0
  801a36:	e8 c3 f1 ff ff       	call   800bfe <sys_page_map>
  801a3b:	89 c3                	mov    %eax,%ebx
  801a3d:	83 c4 20             	add    $0x20,%esp
  801a40:	85 c0                	test   %eax,%eax
  801a42:	78 55                	js     801a99 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801a44:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a4d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a52:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801a59:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801a5f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a62:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801a64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a67:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801a6e:	83 ec 0c             	sub    $0xc,%esp
  801a71:	ff 75 f4             	pushl  -0xc(%ebp)
  801a74:	e8 f7 f3 ff ff       	call   800e70 <fd2num>
  801a79:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a7c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801a7e:	83 c4 04             	add    $0x4,%esp
  801a81:	ff 75 f0             	pushl  -0x10(%ebp)
  801a84:	e8 e7 f3 ff ff       	call   800e70 <fd2num>
  801a89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a8c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801a8f:	83 c4 10             	add    $0x10,%esp
  801a92:	bb 00 00 00 00       	mov    $0x0,%ebx
  801a97:	eb 2e                	jmp    801ac7 <pipe+0x148>
	sys_page_unmap(0, va);
  801a99:	83 ec 08             	sub    $0x8,%esp
  801a9c:	56                   	push   %esi
  801a9d:	6a 00                	push   $0x0
  801a9f:	e8 9c f1 ff ff       	call   800c40 <sys_page_unmap>
  801aa4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801aa7:	83 ec 08             	sub    $0x8,%esp
  801aaa:	ff 75 f0             	pushl  -0x10(%ebp)
  801aad:	6a 00                	push   $0x0
  801aaf:	e8 8c f1 ff ff       	call   800c40 <sys_page_unmap>
  801ab4:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801ab7:	83 ec 08             	sub    $0x8,%esp
  801aba:	ff 75 f4             	pushl  -0xc(%ebp)
  801abd:	6a 00                	push   $0x0
  801abf:	e8 7c f1 ff ff       	call   800c40 <sys_page_unmap>
  801ac4:	83 c4 10             	add    $0x10,%esp
}
  801ac7:	89 d8                	mov    %ebx,%eax
  801ac9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801acc:	5b                   	pop    %ebx
  801acd:	5e                   	pop    %esi
  801ace:	5d                   	pop    %ebp
  801acf:	c3                   	ret    

00801ad0 <pipeisclosed>:
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
  801ad3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801ad6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ad9:	50                   	push   %eax
  801ada:	ff 75 08             	pushl  0x8(%ebp)
  801add:	e8 04 f4 ff ff       	call   800ee6 <fd_lookup>
  801ae2:	83 c4 10             	add    $0x10,%esp
  801ae5:	85 c0                	test   %eax,%eax
  801ae7:	78 18                	js     801b01 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	ff 75 f4             	pushl  -0xc(%ebp)
  801aef:	e8 8c f3 ff ff       	call   800e80 <fd2data>
	return _pipeisclosed(fd, p);
  801af4:	89 c2                	mov    %eax,%edx
  801af6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801af9:	e8 37 fd ff ff       	call   801835 <_pipeisclosed>
  801afe:	83 c4 10             	add    $0x10,%esp
}
  801b01:	c9                   	leave  
  801b02:	c3                   	ret    

00801b03 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801b03:	55                   	push   %ebp
  801b04:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801b06:	b8 00 00 00 00       	mov    $0x0,%eax
  801b0b:	5d                   	pop    %ebp
  801b0c:	c3                   	ret    

00801b0d <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
  801b11:	83 ec 0c             	sub    $0xc,%esp
  801b14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801b17:	68 8a 25 80 00       	push   $0x80258a
  801b1c:	53                   	push   %ebx
  801b1d:	e8 e4 ec ff ff       	call   800806 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801b22:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801b29:	20 00 00 
	return 0;
}
  801b2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801b31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b34:	c9                   	leave  
  801b35:	c3                   	ret    

00801b36 <devcons_write>:
{
  801b36:	55                   	push   %ebp
  801b37:	89 e5                	mov    %esp,%ebp
  801b39:	57                   	push   %edi
  801b3a:	56                   	push   %esi
  801b3b:	53                   	push   %ebx
  801b3c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801b42:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801b47:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801b4d:	eb 1d                	jmp    801b6c <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801b4f:	83 ec 04             	sub    $0x4,%esp
  801b52:	53                   	push   %ebx
  801b53:	03 45 0c             	add    0xc(%ebp),%eax
  801b56:	50                   	push   %eax
  801b57:	57                   	push   %edi
  801b58:	e8 1c ee ff ff       	call   800979 <memmove>
		sys_cputs(buf, m);
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	53                   	push   %ebx
  801b61:	57                   	push   %edi
  801b62:	e8 b7 ef ff ff       	call   800b1e <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801b67:	01 de                	add    %ebx,%esi
  801b69:	83 c4 10             	add    $0x10,%esp
  801b6c:	89 f0                	mov    %esi,%eax
  801b6e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801b71:	73 11                	jae    801b84 <devcons_write+0x4e>
		m = n - tot;
  801b73:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801b76:	29 f3                	sub    %esi,%ebx
  801b78:	83 fb 7f             	cmp    $0x7f,%ebx
  801b7b:	76 d2                	jbe    801b4f <devcons_write+0x19>
  801b7d:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801b82:	eb cb                	jmp    801b4f <devcons_write+0x19>
}
  801b84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    

00801b8c <devcons_read>:
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801b92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801b96:	75 0c                	jne    801ba4 <devcons_read+0x18>
		return 0;
  801b98:	b8 00 00 00 00       	mov    $0x0,%eax
  801b9d:	eb 21                	jmp    801bc0 <devcons_read+0x34>
		sys_yield();
  801b9f:	e8 de f0 ff ff       	call   800c82 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801ba4:	e8 93 ef ff ff       	call   800b3c <sys_cgetc>
  801ba9:	85 c0                	test   %eax,%eax
  801bab:	74 f2                	je     801b9f <devcons_read+0x13>
	if (c < 0)
  801bad:	85 c0                	test   %eax,%eax
  801baf:	78 0f                	js     801bc0 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801bb1:	83 f8 04             	cmp    $0x4,%eax
  801bb4:	74 0c                	je     801bc2 <devcons_read+0x36>
	*(char*)vbuf = c;
  801bb6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb9:	88 02                	mov    %al,(%edx)
	return 1;
  801bbb:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    
		return 0;
  801bc2:	b8 00 00 00 00       	mov    $0x0,%eax
  801bc7:	eb f7                	jmp    801bc0 <devcons_read+0x34>

00801bc9 <cputchar>:
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801bd5:	6a 01                	push   $0x1
  801bd7:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bda:	50                   	push   %eax
  801bdb:	e8 3e ef ff ff       	call   800b1e <sys_cputs>
}
  801be0:	83 c4 10             	add    $0x10,%esp
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <getchar>:
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
  801be8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801beb:	6a 01                	push   $0x1
  801bed:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801bf0:	50                   	push   %eax
  801bf1:	6a 00                	push   $0x0
  801bf3:	e8 5b f5 ff ff       	call   801153 <read>
	if (r < 0)
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	85 c0                	test   %eax,%eax
  801bfd:	78 08                	js     801c07 <getchar+0x22>
	if (r < 1)
  801bff:	85 c0                	test   %eax,%eax
  801c01:	7e 06                	jle    801c09 <getchar+0x24>
	return c;
  801c03:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    
		return -E_EOF;
  801c09:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801c0e:	eb f7                	jmp    801c07 <getchar+0x22>

00801c10 <iscons>:
{
  801c10:	55                   	push   %ebp
  801c11:	89 e5                	mov    %esp,%ebp
  801c13:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801c16:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c19:	50                   	push   %eax
  801c1a:	ff 75 08             	pushl  0x8(%ebp)
  801c1d:	e8 c4 f2 ff ff       	call   800ee6 <fd_lookup>
  801c22:	83 c4 10             	add    $0x10,%esp
  801c25:	85 c0                	test   %eax,%eax
  801c27:	78 11                	js     801c3a <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801c29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2c:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c32:	39 10                	cmp    %edx,(%eax)
  801c34:	0f 94 c0             	sete   %al
  801c37:	0f b6 c0             	movzbl %al,%eax
}
  801c3a:	c9                   	leave  
  801c3b:	c3                   	ret    

00801c3c <opencons>:
{
  801c3c:	55                   	push   %ebp
  801c3d:	89 e5                	mov    %esp,%ebp
  801c3f:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801c42:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c45:	50                   	push   %eax
  801c46:	e8 4c f2 ff ff       	call   800e97 <fd_alloc>
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	78 3a                	js     801c8c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801c52:	83 ec 04             	sub    $0x4,%esp
  801c55:	68 07 04 00 00       	push   $0x407
  801c5a:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5d:	6a 00                	push   $0x0
  801c5f:	e8 57 ef ff ff       	call   800bbb <sys_page_alloc>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	85 c0                	test   %eax,%eax
  801c69:	78 21                	js     801c8c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801c6b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c74:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c79:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801c80:	83 ec 0c             	sub    $0xc,%esp
  801c83:	50                   	push   %eax
  801c84:	e8 e7 f1 ff ff       	call   800e70 <fd2num>
  801c89:	83 c4 10             	add    $0x10,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	53                   	push   %ebx
  801c92:	83 ec 04             	sub    $0x4,%esp
  801c95:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801c98:	8b 13                	mov    (%ebx),%edx
  801c9a:	8d 42 01             	lea    0x1(%edx),%eax
  801c9d:	89 03                	mov    %eax,(%ebx)
  801c9f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ca2:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801ca6:	3d ff 00 00 00       	cmp    $0xff,%eax
  801cab:	74 08                	je     801cb5 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  801cad:	ff 43 04             	incl   0x4(%ebx)
}
  801cb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  801cb5:	83 ec 08             	sub    $0x8,%esp
  801cb8:	68 ff 00 00 00       	push   $0xff
  801cbd:	8d 43 08             	lea    0x8(%ebx),%eax
  801cc0:	50                   	push   %eax
  801cc1:	e8 58 ee ff ff       	call   800b1e <sys_cputs>
		b->idx = 0;
  801cc6:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	eb dc                	jmp    801cad <putch+0x1f>

00801cd1 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
  801cd4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801cda:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801ce1:	00 00 00 
	b.cnt = 0;
  801ce4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801ceb:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801cee:	ff 75 0c             	pushl  0xc(%ebp)
  801cf1:	ff 75 08             	pushl  0x8(%ebp)
  801cf4:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801cfa:	50                   	push   %eax
  801cfb:	68 8e 1c 80 00       	push   $0x801c8e
  801d00:	e8 f3 e5 ff ff       	call   8002f8 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801d05:	83 c4 08             	add    $0x8,%esp
  801d08:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801d0e:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801d14:	50                   	push   %eax
  801d15:	e8 04 ee ff ff       	call   800b1e <sys_cputs>

	return b.cnt;
}
  801d1a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
  801d25:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801d28:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801d2b:	50                   	push   %eax
  801d2c:	ff 75 08             	pushl  0x8(%ebp)
  801d2f:	e8 9d ff ff ff       	call   801cd1 <vcprintf>
	va_end(ap);

	return cnt;
}
  801d34:	c9                   	leave  
  801d35:	c3                   	ret    

00801d36 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801d36:	55                   	push   %ebp
  801d37:	89 e5                	mov    %esp,%ebp
  801d39:	57                   	push   %edi
  801d3a:	56                   	push   %esi
  801d3b:	53                   	push   %ebx
  801d3c:	83 ec 0c             	sub    $0xc,%esp
  801d3f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801d42:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801d45:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801d48:	85 ff                	test   %edi,%edi
  801d4a:	74 53                	je     801d9f <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801d4c:	83 ec 0c             	sub    $0xc,%esp
  801d4f:	57                   	push   %edi
  801d50:	e8 76 f0 ff ff       	call   800dcb <sys_ipc_recv>
  801d55:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801d58:	85 db                	test   %ebx,%ebx
  801d5a:	74 0b                	je     801d67 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801d5c:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d62:	8b 52 74             	mov    0x74(%edx),%edx
  801d65:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801d67:	85 f6                	test   %esi,%esi
  801d69:	74 0f                	je     801d7a <ipc_recv+0x44>
  801d6b:	85 ff                	test   %edi,%edi
  801d6d:	74 0b                	je     801d7a <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801d6f:	8b 15 20 60 80 00    	mov    0x806020,%edx
  801d75:	8b 52 78             	mov    0x78(%edx),%edx
  801d78:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801d7a:	85 c0                	test   %eax,%eax
  801d7c:	74 30                	je     801dae <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801d7e:	85 db                	test   %ebx,%ebx
  801d80:	74 06                	je     801d88 <ipc_recv+0x52>
      		*from_env_store = 0;
  801d82:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801d88:	85 f6                	test   %esi,%esi
  801d8a:	74 2c                	je     801db8 <ipc_recv+0x82>
      		*perm_store = 0;
  801d8c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801d92:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801d97:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d9a:	5b                   	pop    %ebx
  801d9b:	5e                   	pop    %esi
  801d9c:	5f                   	pop    %edi
  801d9d:	5d                   	pop    %ebp
  801d9e:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801d9f:	83 ec 0c             	sub    $0xc,%esp
  801da2:	6a ff                	push   $0xffffffff
  801da4:	e8 22 f0 ff ff       	call   800dcb <sys_ipc_recv>
  801da9:	83 c4 10             	add    $0x10,%esp
  801dac:	eb aa                	jmp    801d58 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801dae:	a1 20 60 80 00       	mov    0x806020,%eax
  801db3:	8b 40 70             	mov    0x70(%eax),%eax
  801db6:	eb df                	jmp    801d97 <ipc_recv+0x61>
		return -1;
  801db8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801dbd:	eb d8                	jmp    801d97 <ipc_recv+0x61>

00801dbf <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801dbf:	55                   	push   %ebp
  801dc0:	89 e5                	mov    %esp,%ebp
  801dc2:	57                   	push   %edi
  801dc3:	56                   	push   %esi
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	8b 75 0c             	mov    0xc(%ebp),%esi
  801dcb:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801dce:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801dd1:	85 db                	test   %ebx,%ebx
  801dd3:	75 22                	jne    801df7 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801dd5:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801dda:	eb 1b                	jmp    801df7 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801ddc:	68 98 25 80 00       	push   $0x802598
  801de1:	68 3f 25 80 00       	push   $0x80253f
  801de6:	6a 48                	push   $0x48
  801de8:	68 bc 25 80 00       	push   $0x8025bc
  801ded:	e8 a1 e3 ff ff       	call   800193 <_panic>
		sys_yield();
  801df2:	e8 8b ee ff ff       	call   800c82 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801df7:	57                   	push   %edi
  801df8:	53                   	push   %ebx
  801df9:	56                   	push   %esi
  801dfa:	ff 75 08             	pushl  0x8(%ebp)
  801dfd:	e8 a6 ef ff ff       	call   800da8 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801e02:	83 c4 10             	add    $0x10,%esp
  801e05:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801e08:	74 e8                	je     801df2 <ipc_send+0x33>
  801e0a:	85 c0                	test   %eax,%eax
  801e0c:	75 ce                	jne    801ddc <ipc_send+0x1d>
		sys_yield();
  801e0e:	e8 6f ee ff ff       	call   800c82 <sys_yield>
		
	}
	
}
  801e13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e16:	5b                   	pop    %ebx
  801e17:	5e                   	pop    %esi
  801e18:	5f                   	pop    %edi
  801e19:	5d                   	pop    %ebp
  801e1a:	c3                   	ret    

00801e1b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801e21:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801e26:	89 c2                	mov    %eax,%edx
  801e28:	c1 e2 05             	shl    $0x5,%edx
  801e2b:	29 c2                	sub    %eax,%edx
  801e2d:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801e34:	8b 52 50             	mov    0x50(%edx),%edx
  801e37:	39 ca                	cmp    %ecx,%edx
  801e39:	74 0f                	je     801e4a <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801e3b:	40                   	inc    %eax
  801e3c:	3d 00 04 00 00       	cmp    $0x400,%eax
  801e41:	75 e3                	jne    801e26 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801e43:	b8 00 00 00 00       	mov    $0x0,%eax
  801e48:	eb 11                	jmp    801e5b <ipc_find_env+0x40>
			return envs[i].env_id;
  801e4a:	89 c2                	mov    %eax,%edx
  801e4c:	c1 e2 05             	shl    $0x5,%edx
  801e4f:	29 c2                	sub    %eax,%edx
  801e51:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801e58:	8b 40 48             	mov    0x48(%eax),%eax
}
  801e5b:	5d                   	pop    %ebp
  801e5c:	c3                   	ret    

00801e5d <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801e5d:	55                   	push   %ebp
  801e5e:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801e60:	8b 45 08             	mov    0x8(%ebp),%eax
  801e63:	c1 e8 16             	shr    $0x16,%eax
  801e66:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e6d:	a8 01                	test   $0x1,%al
  801e6f:	74 21                	je     801e92 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	c1 e8 0c             	shr    $0xc,%eax
  801e77:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801e7e:	a8 01                	test   $0x1,%al
  801e80:	74 17                	je     801e99 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801e82:	c1 e8 0c             	shr    $0xc,%eax
  801e85:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801e8c:	ef 
  801e8d:	0f b7 c0             	movzwl %ax,%eax
  801e90:	eb 05                	jmp    801e97 <pageref+0x3a>
		return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    
		return 0;
  801e99:	b8 00 00 00 00       	mov    $0x0,%eax
  801e9e:	eb f7                	jmp    801e97 <pageref+0x3a>

00801ea0 <__udivdi3>:
  801ea0:	55                   	push   %ebp
  801ea1:	57                   	push   %edi
  801ea2:	56                   	push   %esi
  801ea3:	53                   	push   %ebx
  801ea4:	83 ec 1c             	sub    $0x1c,%esp
  801ea7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801eab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801eaf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801eb3:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801eb7:	89 ca                	mov    %ecx,%edx
  801eb9:	89 f8                	mov    %edi,%eax
  801ebb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ebf:	85 f6                	test   %esi,%esi
  801ec1:	75 2d                	jne    801ef0 <__udivdi3+0x50>
  801ec3:	39 cf                	cmp    %ecx,%edi
  801ec5:	77 65                	ja     801f2c <__udivdi3+0x8c>
  801ec7:	89 fd                	mov    %edi,%ebp
  801ec9:	85 ff                	test   %edi,%edi
  801ecb:	75 0b                	jne    801ed8 <__udivdi3+0x38>
  801ecd:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed2:	31 d2                	xor    %edx,%edx
  801ed4:	f7 f7                	div    %edi
  801ed6:	89 c5                	mov    %eax,%ebp
  801ed8:	31 d2                	xor    %edx,%edx
  801eda:	89 c8                	mov    %ecx,%eax
  801edc:	f7 f5                	div    %ebp
  801ede:	89 c1                	mov    %eax,%ecx
  801ee0:	89 d8                	mov    %ebx,%eax
  801ee2:	f7 f5                	div    %ebp
  801ee4:	89 cf                	mov    %ecx,%edi
  801ee6:	89 fa                	mov    %edi,%edx
  801ee8:	83 c4 1c             	add    $0x1c,%esp
  801eeb:	5b                   	pop    %ebx
  801eec:	5e                   	pop    %esi
  801eed:	5f                   	pop    %edi
  801eee:	5d                   	pop    %ebp
  801eef:	c3                   	ret    
  801ef0:	39 ce                	cmp    %ecx,%esi
  801ef2:	77 28                	ja     801f1c <__udivdi3+0x7c>
  801ef4:	0f bd fe             	bsr    %esi,%edi
  801ef7:	83 f7 1f             	xor    $0x1f,%edi
  801efa:	75 40                	jne    801f3c <__udivdi3+0x9c>
  801efc:	39 ce                	cmp    %ecx,%esi
  801efe:	72 0a                	jb     801f0a <__udivdi3+0x6a>
  801f00:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801f04:	0f 87 9e 00 00 00    	ja     801fa8 <__udivdi3+0x108>
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0f:	89 fa                	mov    %edi,%edx
  801f11:	83 c4 1c             	add    $0x1c,%esp
  801f14:	5b                   	pop    %ebx
  801f15:	5e                   	pop    %esi
  801f16:	5f                   	pop    %edi
  801f17:	5d                   	pop    %ebp
  801f18:	c3                   	ret    
  801f19:	8d 76 00             	lea    0x0(%esi),%esi
  801f1c:	31 ff                	xor    %edi,%edi
  801f1e:	31 c0                	xor    %eax,%eax
  801f20:	89 fa                	mov    %edi,%edx
  801f22:	83 c4 1c             	add    $0x1c,%esp
  801f25:	5b                   	pop    %ebx
  801f26:	5e                   	pop    %esi
  801f27:	5f                   	pop    %edi
  801f28:	5d                   	pop    %ebp
  801f29:	c3                   	ret    
  801f2a:	66 90                	xchg   %ax,%ax
  801f2c:	89 d8                	mov    %ebx,%eax
  801f2e:	f7 f7                	div    %edi
  801f30:	31 ff                	xor    %edi,%edi
  801f32:	89 fa                	mov    %edi,%edx
  801f34:	83 c4 1c             	add    $0x1c,%esp
  801f37:	5b                   	pop    %ebx
  801f38:	5e                   	pop    %esi
  801f39:	5f                   	pop    %edi
  801f3a:	5d                   	pop    %ebp
  801f3b:	c3                   	ret    
  801f3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801f41:	29 fd                	sub    %edi,%ebp
  801f43:	89 f9                	mov    %edi,%ecx
  801f45:	d3 e6                	shl    %cl,%esi
  801f47:	89 c3                	mov    %eax,%ebx
  801f49:	89 e9                	mov    %ebp,%ecx
  801f4b:	d3 eb                	shr    %cl,%ebx
  801f4d:	89 d9                	mov    %ebx,%ecx
  801f4f:	09 f1                	or     %esi,%ecx
  801f51:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f55:	89 f9                	mov    %edi,%ecx
  801f57:	d3 e0                	shl    %cl,%eax
  801f59:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f5d:	89 d6                	mov    %edx,%esi
  801f5f:	89 e9                	mov    %ebp,%ecx
  801f61:	d3 ee                	shr    %cl,%esi
  801f63:	89 f9                	mov    %edi,%ecx
  801f65:	d3 e2                	shl    %cl,%edx
  801f67:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801f6b:	89 e9                	mov    %ebp,%ecx
  801f6d:	d3 eb                	shr    %cl,%ebx
  801f6f:	09 da                	or     %ebx,%edx
  801f71:	89 d0                	mov    %edx,%eax
  801f73:	89 f2                	mov    %esi,%edx
  801f75:	f7 74 24 08          	divl   0x8(%esp)
  801f79:	89 d6                	mov    %edx,%esi
  801f7b:	89 c3                	mov    %eax,%ebx
  801f7d:	f7 64 24 0c          	mull   0xc(%esp)
  801f81:	39 d6                	cmp    %edx,%esi
  801f83:	72 17                	jb     801f9c <__udivdi3+0xfc>
  801f85:	74 09                	je     801f90 <__udivdi3+0xf0>
  801f87:	89 d8                	mov    %ebx,%eax
  801f89:	31 ff                	xor    %edi,%edi
  801f8b:	e9 56 ff ff ff       	jmp    801ee6 <__udivdi3+0x46>
  801f90:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f94:	89 f9                	mov    %edi,%ecx
  801f96:	d3 e2                	shl    %cl,%edx
  801f98:	39 c2                	cmp    %eax,%edx
  801f9a:	73 eb                	jae    801f87 <__udivdi3+0xe7>
  801f9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801f9f:	31 ff                	xor    %edi,%edi
  801fa1:	e9 40 ff ff ff       	jmp    801ee6 <__udivdi3+0x46>
  801fa6:	66 90                	xchg   %ax,%ax
  801fa8:	31 c0                	xor    %eax,%eax
  801faa:	e9 37 ff ff ff       	jmp    801ee6 <__udivdi3+0x46>
  801faf:	90                   	nop

00801fb0 <__umoddi3>:
  801fb0:	55                   	push   %ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 1c             	sub    $0x1c,%esp
  801fb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801fbb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801fbf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801fc3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801fc7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801fcb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801fcf:	89 3c 24             	mov    %edi,(%esp)
  801fd2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd6:	89 f2                	mov    %esi,%edx
  801fd8:	85 c0                	test   %eax,%eax
  801fda:	75 18                	jne    801ff4 <__umoddi3+0x44>
  801fdc:	39 f7                	cmp    %esi,%edi
  801fde:	0f 86 a0 00 00 00    	jbe    802084 <__umoddi3+0xd4>
  801fe4:	89 c8                	mov    %ecx,%eax
  801fe6:	f7 f7                	div    %edi
  801fe8:	89 d0                	mov    %edx,%eax
  801fea:	31 d2                	xor    %edx,%edx
  801fec:	83 c4 1c             	add    $0x1c,%esp
  801fef:	5b                   	pop    %ebx
  801ff0:	5e                   	pop    %esi
  801ff1:	5f                   	pop    %edi
  801ff2:	5d                   	pop    %ebp
  801ff3:	c3                   	ret    
  801ff4:	89 f3                	mov    %esi,%ebx
  801ff6:	39 f0                	cmp    %esi,%eax
  801ff8:	0f 87 a6 00 00 00    	ja     8020a4 <__umoddi3+0xf4>
  801ffe:	0f bd e8             	bsr    %eax,%ebp
  802001:	83 f5 1f             	xor    $0x1f,%ebp
  802004:	0f 84 a6 00 00 00    	je     8020b0 <__umoddi3+0x100>
  80200a:	bf 20 00 00 00       	mov    $0x20,%edi
  80200f:	29 ef                	sub    %ebp,%edi
  802011:	89 e9                	mov    %ebp,%ecx
  802013:	d3 e0                	shl    %cl,%eax
  802015:	8b 34 24             	mov    (%esp),%esi
  802018:	89 f2                	mov    %esi,%edx
  80201a:	89 f9                	mov    %edi,%ecx
  80201c:	d3 ea                	shr    %cl,%edx
  80201e:	09 c2                	or     %eax,%edx
  802020:	89 14 24             	mov    %edx,(%esp)
  802023:	89 f2                	mov    %esi,%edx
  802025:	89 e9                	mov    %ebp,%ecx
  802027:	d3 e2                	shl    %cl,%edx
  802029:	89 54 24 04          	mov    %edx,0x4(%esp)
  80202d:	89 de                	mov    %ebx,%esi
  80202f:	89 f9                	mov    %edi,%ecx
  802031:	d3 ee                	shr    %cl,%esi
  802033:	89 e9                	mov    %ebp,%ecx
  802035:	d3 e3                	shl    %cl,%ebx
  802037:	8b 54 24 08          	mov    0x8(%esp),%edx
  80203b:	89 d0                	mov    %edx,%eax
  80203d:	89 f9                	mov    %edi,%ecx
  80203f:	d3 e8                	shr    %cl,%eax
  802041:	09 d8                	or     %ebx,%eax
  802043:	89 d3                	mov    %edx,%ebx
  802045:	89 e9                	mov    %ebp,%ecx
  802047:	d3 e3                	shl    %cl,%ebx
  802049:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80204d:	89 f2                	mov    %esi,%edx
  80204f:	f7 34 24             	divl   (%esp)
  802052:	89 d6                	mov    %edx,%esi
  802054:	f7 64 24 04          	mull   0x4(%esp)
  802058:	89 c3                	mov    %eax,%ebx
  80205a:	89 d1                	mov    %edx,%ecx
  80205c:	39 d6                	cmp    %edx,%esi
  80205e:	72 7c                	jb     8020dc <__umoddi3+0x12c>
  802060:	74 72                	je     8020d4 <__umoddi3+0x124>
  802062:	8b 54 24 08          	mov    0x8(%esp),%edx
  802066:	29 da                	sub    %ebx,%edx
  802068:	19 ce                	sbb    %ecx,%esi
  80206a:	89 f0                	mov    %esi,%eax
  80206c:	89 f9                	mov    %edi,%ecx
  80206e:	d3 e0                	shl    %cl,%eax
  802070:	89 e9                	mov    %ebp,%ecx
  802072:	d3 ea                	shr    %cl,%edx
  802074:	09 d0                	or     %edx,%eax
  802076:	89 e9                	mov    %ebp,%ecx
  802078:	d3 ee                	shr    %cl,%esi
  80207a:	89 f2                	mov    %esi,%edx
  80207c:	83 c4 1c             	add    $0x1c,%esp
  80207f:	5b                   	pop    %ebx
  802080:	5e                   	pop    %esi
  802081:	5f                   	pop    %edi
  802082:	5d                   	pop    %ebp
  802083:	c3                   	ret    
  802084:	89 fd                	mov    %edi,%ebp
  802086:	85 ff                	test   %edi,%edi
  802088:	75 0b                	jne    802095 <__umoddi3+0xe5>
  80208a:	b8 01 00 00 00       	mov    $0x1,%eax
  80208f:	31 d2                	xor    %edx,%edx
  802091:	f7 f7                	div    %edi
  802093:	89 c5                	mov    %eax,%ebp
  802095:	89 f0                	mov    %esi,%eax
  802097:	31 d2                	xor    %edx,%edx
  802099:	f7 f5                	div    %ebp
  80209b:	89 c8                	mov    %ecx,%eax
  80209d:	f7 f5                	div    %ebp
  80209f:	e9 44 ff ff ff       	jmp    801fe8 <__umoddi3+0x38>
  8020a4:	89 c8                	mov    %ecx,%eax
  8020a6:	89 f2                	mov    %esi,%edx
  8020a8:	83 c4 1c             	add    $0x1c,%esp
  8020ab:	5b                   	pop    %ebx
  8020ac:	5e                   	pop    %esi
  8020ad:	5f                   	pop    %edi
  8020ae:	5d                   	pop    %ebp
  8020af:	c3                   	ret    
  8020b0:	39 f0                	cmp    %esi,%eax
  8020b2:	72 05                	jb     8020b9 <__umoddi3+0x109>
  8020b4:	39 0c 24             	cmp    %ecx,(%esp)
  8020b7:	77 0c                	ja     8020c5 <__umoddi3+0x115>
  8020b9:	89 f2                	mov    %esi,%edx
  8020bb:	29 f9                	sub    %edi,%ecx
  8020bd:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8020c1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8020c5:	8b 44 24 04          	mov    0x4(%esp),%eax
  8020c9:	83 c4 1c             	add    $0x1c,%esp
  8020cc:	5b                   	pop    %ebx
  8020cd:	5e                   	pop    %esi
  8020ce:	5f                   	pop    %edi
  8020cf:	5d                   	pop    %ebp
  8020d0:	c3                   	ret    
  8020d1:	8d 76 00             	lea    0x0(%esi),%esi
  8020d4:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8020d8:	73 88                	jae    802062 <__umoddi3+0xb2>
  8020da:	66 90                	xchg   %ax,%ax
  8020dc:	2b 44 24 04          	sub    0x4(%esp),%eax
  8020e0:	1b 14 24             	sbb    (%esp),%edx
  8020e3:	89 d1                	mov    %edx,%ecx
  8020e5:	89 c3                	mov    %eax,%ebx
  8020e7:	e9 76 ff ff ff       	jmp    802062 <__umoddi3+0xb2>
