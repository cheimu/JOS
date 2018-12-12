
obj/user/testpiperace2.debug:     file format elf32-i386


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
  80002c:	e8 96 01 00 00       	call   8001c7 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 28             	sub    $0x28,%esp
	int p[2], r, i;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for pipeisclosed race...\n");
  80003c:	68 80 23 80 00       	push   $0x802380
  800041:	e8 fa 02 00 00       	call   800340 <cprintf>
	if ((r = pipe(p)) < 0)
  800046:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800049:	89 04 24             	mov    %eax,(%esp)
  80004c:	e8 e2 1b 00 00       	call   801c33 <pipe>
  800051:	83 c4 10             	add    $0x10,%esp
  800054:	85 c0                	test   %eax,%eax
  800056:	78 62                	js     8000ba <umain+0x87>
		panic("pipe: %e", r);
	if ((r = fork()) < 0)
  800058:	e8 19 10 00 00       	call   801076 <fork>
  80005d:	89 c7                	mov    %eax,%edi
  80005f:	85 c0                	test   %eax,%eax
  800061:	78 69                	js     8000cc <umain+0x99>
		panic("fork: %e", r);
	if (r == 0) {
  800063:	85 c0                	test   %eax,%eax
  800065:	74 77                	je     8000de <umain+0xab>
	// pageref(p[0]) and gets 3, then it will return true when
	// it shouldn't.
	//
	// So either way, pipeisclosed is going give a wrong answer.
	//
	kid = &envs[ENVX(r)];
  800067:	89 fa                	mov    %edi,%edx
  800069:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (kid->env_status == ENV_RUNNABLE)
  80006f:	89 d0                	mov    %edx,%eax
  800071:	c1 e0 05             	shl    $0x5,%eax
  800074:	29 d0                	sub    %edx,%eax
  800076:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  80007d:	8b 43 54             	mov    0x54(%ebx),%eax
  800080:	83 f8 02             	cmp    $0x2,%eax
  800083:	0f 85 c1 00 00 00    	jne    80014a <umain+0x117>
		if (pipeisclosed(p[0]) != 0) {
  800089:	83 ec 0c             	sub    $0xc,%esp
  80008c:	ff 75 e0             	pushl  -0x20(%ebp)
  80008f:	e8 f0 1c 00 00       	call   801d84 <pipeisclosed>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	85 c0                	test   %eax,%eax
  800099:	74 e2                	je     80007d <umain+0x4a>
			cprintf("\nRACE: pipe appears closed\n");
  80009b:	83 ec 0c             	sub    $0xc,%esp
  80009e:	68 f9 23 80 00       	push   $0x8023f9
  8000a3:	e8 98 02 00 00       	call   800340 <cprintf>
			sys_env_destroy(r);
  8000a8:	89 3c 24             	mov    %edi,(%esp)
  8000ab:	e8 ed 0b 00 00       	call   800c9d <sys_env_destroy>
			exit();
  8000b0:	e8 5e 01 00 00       	call   800213 <exit>
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	eb c3                	jmp    80007d <umain+0x4a>
		panic("pipe: %e", r);
  8000ba:	50                   	push   %eax
  8000bb:	68 ce 23 80 00       	push   $0x8023ce
  8000c0:	6a 0d                	push   $0xd
  8000c2:	68 d7 23 80 00       	push   $0x8023d7
  8000c7:	e8 61 01 00 00       	call   80022d <_panic>
		panic("fork: %e", r);
  8000cc:	50                   	push   %eax
  8000cd:	68 ec 23 80 00       	push   $0x8023ec
  8000d2:	6a 0f                	push   $0xf
  8000d4:	68 d7 23 80 00       	push   $0x8023d7
  8000d9:	e8 4f 01 00 00       	call   80022d <_panic>
		close(p[1]);
  8000de:	83 ec 0c             	sub    $0xc,%esp
  8000e1:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e4:	e8 f7 12 00 00       	call   8013e0 <close>
  8000e9:	83 c4 10             	add    $0x10,%esp
		for (i = 0; i < 200; i++) {
  8000ec:	89 fb                	mov    %edi,%ebx
			if (i % 10 == 0)
  8000ee:	be 0a 00 00 00       	mov    $0xa,%esi
  8000f3:	eb 2f                	jmp    800124 <umain+0xf1>
			dup(p[0], 10);
  8000f5:	83 ec 08             	sub    $0x8,%esp
  8000f8:	6a 0a                	push   $0xa
  8000fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8000fd:	e8 2c 13 00 00       	call   80142e <dup>
			sys_yield();
  800102:	e8 bd 0c 00 00       	call   800dc4 <sys_yield>
			close(10);
  800107:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80010e:	e8 cd 12 00 00       	call   8013e0 <close>
			sys_yield();
  800113:	e8 ac 0c 00 00       	call   800dc4 <sys_yield>
		for (i = 0; i < 200; i++) {
  800118:	43                   	inc    %ebx
  800119:	83 c4 10             	add    $0x10,%esp
  80011c:	81 fb c8 00 00 00    	cmp    $0xc8,%ebx
  800122:	74 1c                	je     800140 <umain+0x10d>
			if (i % 10 == 0)
  800124:	89 d8                	mov    %ebx,%eax
  800126:	99                   	cltd   
  800127:	f7 fe                	idiv   %esi
  800129:	85 d2                	test   %edx,%edx
  80012b:	75 c8                	jne    8000f5 <umain+0xc2>
				cprintf("%d.", i);
  80012d:	83 ec 08             	sub    $0x8,%esp
  800130:	53                   	push   %ebx
  800131:	68 f5 23 80 00       	push   $0x8023f5
  800136:	e8 05 02 00 00       	call   800340 <cprintf>
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	eb b5                	jmp    8000f5 <umain+0xc2>
		exit();
  800140:	e8 ce 00 00 00       	call   800213 <exit>
  800145:	e9 1d ff ff ff       	jmp    800067 <umain+0x34>
		}
	cprintf("child done with loop\n");
  80014a:	83 ec 0c             	sub    $0xc,%esp
  80014d:	68 15 24 80 00       	push   $0x802415
  800152:	e8 e9 01 00 00       	call   800340 <cprintf>
	if (pipeisclosed(p[0]))
  800157:	83 c4 04             	add    $0x4,%esp
  80015a:	ff 75 e0             	pushl  -0x20(%ebp)
  80015d:	e8 22 1c 00 00       	call   801d84 <pipeisclosed>
  800162:	83 c4 10             	add    $0x10,%esp
  800165:	85 c0                	test   %eax,%eax
  800167:	75 38                	jne    8001a1 <umain+0x16e>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  800169:	83 ec 08             	sub    $0x8,%esp
  80016c:	8d 45 dc             	lea    -0x24(%ebp),%eax
  80016f:	50                   	push   %eax
  800170:	ff 75 e0             	pushl  -0x20(%ebp)
  800173:	e8 35 11 00 00       	call   8012ad <fd_lookup>
  800178:	83 c4 10             	add    $0x10,%esp
  80017b:	85 c0                	test   %eax,%eax
  80017d:	78 36                	js     8001b5 <umain+0x182>
		panic("cannot look up p[0]: %e", r);
	(void) fd2data(fd);
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	ff 75 dc             	pushl  -0x24(%ebp)
  800185:	e8 bd 10 00 00       	call   801247 <fd2data>
	cprintf("race didn't happen\n");
  80018a:	c7 04 24 43 24 80 00 	movl   $0x802443,(%esp)
  800191:	e8 aa 01 00 00       	call   800340 <cprintf>
}
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80019c:	5b                   	pop    %ebx
  80019d:	5e                   	pop    %esi
  80019e:	5f                   	pop    %edi
  80019f:	5d                   	pop    %ebp
  8001a0:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001a1:	83 ec 04             	sub    $0x4,%esp
  8001a4:	68 a4 23 80 00       	push   $0x8023a4
  8001a9:	6a 40                	push   $0x40
  8001ab:	68 d7 23 80 00       	push   $0x8023d7
  8001b0:	e8 78 00 00 00       	call   80022d <_panic>
		panic("cannot look up p[0]: %e", r);
  8001b5:	50                   	push   %eax
  8001b6:	68 2b 24 80 00       	push   $0x80242b
  8001bb:	6a 42                	push   $0x42
  8001bd:	68 d7 23 80 00       	push   $0x8023d7
  8001c2:	e8 66 00 00 00       	call   80022d <_panic>

008001c7 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001c7:	55                   	push   %ebp
  8001c8:	89 e5                	mov    %esp,%ebp
  8001ca:	56                   	push   %esi
  8001cb:	53                   	push   %ebx
  8001cc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001cf:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d2:	e8 07 0b 00 00       	call   800cde <sys_getenvid>
  8001d7:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001dc:	89 c2                	mov    %eax,%edx
  8001de:	c1 e2 05             	shl    $0x5,%edx
  8001e1:	29 c2                	sub    %eax,%edx
  8001e3:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001ea:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ef:	85 db                	test   %ebx,%ebx
  8001f1:	7e 07                	jle    8001fa <libmain+0x33>
		binaryname = argv[0];
  8001f3:	8b 06                	mov    (%esi),%eax
  8001f5:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001fa:	83 ec 08             	sub    $0x8,%esp
  8001fd:	56                   	push   %esi
  8001fe:	53                   	push   %ebx
  8001ff:	e8 2f fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800204:	e8 0a 00 00 00       	call   800213 <exit>
}
  800209:	83 c4 10             	add    $0x10,%esp
  80020c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80020f:	5b                   	pop    %ebx
  800210:	5e                   	pop    %esi
  800211:	5d                   	pop    %ebp
  800212:	c3                   	ret    

00800213 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800213:	55                   	push   %ebp
  800214:	89 e5                	mov    %esp,%ebp
  800216:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800219:	e8 ed 11 00 00       	call   80140b <close_all>
	sys_env_destroy(0);
  80021e:	83 ec 0c             	sub    $0xc,%esp
  800221:	6a 00                	push   $0x0
  800223:	e8 75 0a 00 00       	call   800c9d <sys_env_destroy>
}
  800228:	83 c4 10             	add    $0x10,%esp
  80022b:	c9                   	leave  
  80022c:	c3                   	ret    

0080022d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80022d:	55                   	push   %ebp
  80022e:	89 e5                	mov    %esp,%ebp
  800230:	57                   	push   %edi
  800231:	56                   	push   %esi
  800232:	53                   	push   %ebx
  800233:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800239:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80023c:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800242:	e8 97 0a 00 00       	call   800cde <sys_getenvid>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	ff 75 0c             	pushl  0xc(%ebp)
  80024d:	ff 75 08             	pushl  0x8(%ebp)
  800250:	53                   	push   %ebx
  800251:	50                   	push   %eax
  800252:	68 64 24 80 00       	push   $0x802464
  800257:	68 00 01 00 00       	push   $0x100
  80025c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800262:	56                   	push   %esi
  800263:	e8 93 06 00 00       	call   8008fb <snprintf>
  800268:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80026a:	83 c4 20             	add    $0x20,%esp
  80026d:	57                   	push   %edi
  80026e:	ff 75 10             	pushl  0x10(%ebp)
  800271:	bf 00 01 00 00       	mov    $0x100,%edi
  800276:	89 f8                	mov    %edi,%eax
  800278:	29 d8                	sub    %ebx,%eax
  80027a:	50                   	push   %eax
  80027b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80027e:	50                   	push   %eax
  80027f:	e8 22 06 00 00       	call   8008a6 <vsnprintf>
  800284:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800286:	83 c4 0c             	add    $0xc,%esp
  800289:	68 2e 29 80 00       	push   $0x80292e
  80028e:	29 df                	sub    %ebx,%edi
  800290:	57                   	push   %edi
  800291:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800294:	50                   	push   %eax
  800295:	e8 61 06 00 00       	call   8008fb <snprintf>
	sys_cputs(buf, r);
  80029a:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80029d:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80029f:	53                   	push   %ebx
  8002a0:	56                   	push   %esi
  8002a1:	e8 ba 09 00 00       	call   800c60 <sys_cputs>
  8002a6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002a9:	cc                   	int3   
  8002aa:	eb fd                	jmp    8002a9 <_panic+0x7c>

008002ac <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002ac:	55                   	push   %ebp
  8002ad:	89 e5                	mov    %esp,%ebp
  8002af:	53                   	push   %ebx
  8002b0:	83 ec 04             	sub    $0x4,%esp
  8002b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002b6:	8b 13                	mov    (%ebx),%edx
  8002b8:	8d 42 01             	lea    0x1(%edx),%eax
  8002bb:	89 03                	mov    %eax,(%ebx)
  8002bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002c9:	74 08                	je     8002d3 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002cb:	ff 43 04             	incl   0x4(%ebx)
}
  8002ce:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d1:	c9                   	leave  
  8002d2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	68 ff 00 00 00       	push   $0xff
  8002db:	8d 43 08             	lea    0x8(%ebx),%eax
  8002de:	50                   	push   %eax
  8002df:	e8 7c 09 00 00       	call   800c60 <sys_cputs>
		b->idx = 0;
  8002e4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002ea:	83 c4 10             	add    $0x10,%esp
  8002ed:	eb dc                	jmp    8002cb <putch+0x1f>

008002ef <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002ef:	55                   	push   %ebp
  8002f0:	89 e5                	mov    %esp,%ebp
  8002f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8002ff:	00 00 00 
	b.cnt = 0;
  800302:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800309:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80030c:	ff 75 0c             	pushl  0xc(%ebp)
  80030f:	ff 75 08             	pushl  0x8(%ebp)
  800312:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800318:	50                   	push   %eax
  800319:	68 ac 02 80 00       	push   $0x8002ac
  80031e:	e8 17 01 00 00       	call   80043a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800323:	83 c4 08             	add    $0x8,%esp
  800326:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80032c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800332:	50                   	push   %eax
  800333:	e8 28 09 00 00       	call   800c60 <sys_cputs>

	return b.cnt;
}
  800338:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80033e:	c9                   	leave  
  80033f:	c3                   	ret    

00800340 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800346:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800349:	50                   	push   %eax
  80034a:	ff 75 08             	pushl  0x8(%ebp)
  80034d:	e8 9d ff ff ff       	call   8002ef <vcprintf>
	va_end(ap);

	return cnt;
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	57                   	push   %edi
  800358:	56                   	push   %esi
  800359:	53                   	push   %ebx
  80035a:	83 ec 1c             	sub    $0x1c,%esp
  80035d:	89 c7                	mov    %eax,%edi
  80035f:	89 d6                	mov    %edx,%esi
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	8b 55 0c             	mov    0xc(%ebp),%edx
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80036d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800370:	bb 00 00 00 00       	mov    $0x0,%ebx
  800375:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800378:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80037b:	39 d3                	cmp    %edx,%ebx
  80037d:	72 05                	jb     800384 <printnum+0x30>
  80037f:	39 45 10             	cmp    %eax,0x10(%ebp)
  800382:	77 78                	ja     8003fc <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	ff 75 18             	pushl  0x18(%ebp)
  80038a:	8b 45 14             	mov    0x14(%ebp),%eax
  80038d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800390:	53                   	push   %ebx
  800391:	ff 75 10             	pushl  0x10(%ebp)
  800394:	83 ec 08             	sub    $0x8,%esp
  800397:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039a:	ff 75 e0             	pushl  -0x20(%ebp)
  80039d:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a0:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a3:	e8 70 1d 00 00       	call   802118 <__udivdi3>
  8003a8:	83 c4 18             	add    $0x18,%esp
  8003ab:	52                   	push   %edx
  8003ac:	50                   	push   %eax
  8003ad:	89 f2                	mov    %esi,%edx
  8003af:	89 f8                	mov    %edi,%eax
  8003b1:	e8 9e ff ff ff       	call   800354 <printnum>
  8003b6:	83 c4 20             	add    $0x20,%esp
  8003b9:	eb 11                	jmp    8003cc <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003bb:	83 ec 08             	sub    $0x8,%esp
  8003be:	56                   	push   %esi
  8003bf:	ff 75 18             	pushl  0x18(%ebp)
  8003c2:	ff d7                	call   *%edi
  8003c4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003c7:	4b                   	dec    %ebx
  8003c8:	85 db                	test   %ebx,%ebx
  8003ca:	7f ef                	jg     8003bb <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003cc:	83 ec 08             	sub    $0x8,%esp
  8003cf:	56                   	push   %esi
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003d6:	ff 75 e0             	pushl  -0x20(%ebp)
  8003d9:	ff 75 dc             	pushl  -0x24(%ebp)
  8003dc:	ff 75 d8             	pushl  -0x28(%ebp)
  8003df:	e8 44 1e 00 00       	call   802228 <__umoddi3>
  8003e4:	83 c4 14             	add    $0x14,%esp
  8003e7:	0f be 80 87 24 80 00 	movsbl 0x802487(%eax),%eax
  8003ee:	50                   	push   %eax
  8003ef:	ff d7                	call   *%edi
}
  8003f1:	83 c4 10             	add    $0x10,%esp
  8003f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003f7:	5b                   	pop    %ebx
  8003f8:	5e                   	pop    %esi
  8003f9:	5f                   	pop    %edi
  8003fa:	5d                   	pop    %ebp
  8003fb:	c3                   	ret    
  8003fc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8003ff:	eb c6                	jmp    8003c7 <printnum+0x73>

00800401 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
  800404:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800407:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80040a:	8b 10                	mov    (%eax),%edx
  80040c:	3b 50 04             	cmp    0x4(%eax),%edx
  80040f:	73 0a                	jae    80041b <sprintputch+0x1a>
		*b->buf++ = ch;
  800411:	8d 4a 01             	lea    0x1(%edx),%ecx
  800414:	89 08                	mov    %ecx,(%eax)
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	88 02                	mov    %al,(%edx)
}
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    

0080041d <printfmt>:
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
  800420:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800423:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800426:	50                   	push   %eax
  800427:	ff 75 10             	pushl  0x10(%ebp)
  80042a:	ff 75 0c             	pushl  0xc(%ebp)
  80042d:	ff 75 08             	pushl  0x8(%ebp)
  800430:	e8 05 00 00 00       	call   80043a <vprintfmt>
}
  800435:	83 c4 10             	add    $0x10,%esp
  800438:	c9                   	leave  
  800439:	c3                   	ret    

0080043a <vprintfmt>:
{
  80043a:	55                   	push   %ebp
  80043b:	89 e5                	mov    %esp,%ebp
  80043d:	57                   	push   %edi
  80043e:	56                   	push   %esi
  80043f:	53                   	push   %ebx
  800440:	83 ec 2c             	sub    $0x2c,%esp
  800443:	8b 75 08             	mov    0x8(%ebp),%esi
  800446:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800449:	8b 7d 10             	mov    0x10(%ebp),%edi
  80044c:	e9 ae 03 00 00       	jmp    8007ff <vprintfmt+0x3c5>
  800451:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800455:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80045c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800463:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80046a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80046f:	8d 47 01             	lea    0x1(%edi),%eax
  800472:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800475:	8a 17                	mov    (%edi),%dl
  800477:	8d 42 dd             	lea    -0x23(%edx),%eax
  80047a:	3c 55                	cmp    $0x55,%al
  80047c:	0f 87 fe 03 00 00    	ja     800880 <vprintfmt+0x446>
  800482:	0f b6 c0             	movzbl %al,%eax
  800485:	ff 24 85 c0 25 80 00 	jmp    *0x8025c0(,%eax,4)
  80048c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80048f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800493:	eb da                	jmp    80046f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800495:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800498:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80049c:	eb d1                	jmp    80046f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80049e:	0f b6 d2             	movzbl %dl,%edx
  8004a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8004a9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004ac:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004af:	01 c0                	add    %eax,%eax
  8004b1:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8004b5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004b8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004bb:	83 f9 09             	cmp    $0x9,%ecx
  8004be:	77 52                	ja     800512 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8004c0:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8004c1:	eb e9                	jmp    8004ac <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8004c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c6:	8b 00                	mov    (%eax),%eax
  8004c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8004ce:	8d 40 04             	lea    0x4(%eax),%eax
  8004d1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004d7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004db:	79 92                	jns    80046f <vprintfmt+0x35>
				width = precision, precision = -1;
  8004dd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ea:	eb 83                	jmp    80046f <vprintfmt+0x35>
  8004ec:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f0:	78 08                	js     8004fa <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8004f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004f5:	e9 75 ff ff ff       	jmp    80046f <vprintfmt+0x35>
  8004fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800501:	eb ef                	jmp    8004f2 <vprintfmt+0xb8>
  800503:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800506:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80050d:	e9 5d ff ff ff       	jmp    80046f <vprintfmt+0x35>
  800512:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800515:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800518:	eb bd                	jmp    8004d7 <vprintfmt+0x9d>
			lflag++;
  80051a:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80051b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80051e:	e9 4c ff ff ff       	jmp    80046f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800523:	8b 45 14             	mov    0x14(%ebp),%eax
  800526:	8d 78 04             	lea    0x4(%eax),%edi
  800529:	83 ec 08             	sub    $0x8,%esp
  80052c:	53                   	push   %ebx
  80052d:	ff 30                	pushl  (%eax)
  80052f:	ff d6                	call   *%esi
			break;
  800531:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800534:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800537:	e9 c0 02 00 00       	jmp    8007fc <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80053c:	8b 45 14             	mov    0x14(%ebp),%eax
  80053f:	8d 78 04             	lea    0x4(%eax),%edi
  800542:	8b 00                	mov    (%eax),%eax
  800544:	85 c0                	test   %eax,%eax
  800546:	78 2a                	js     800572 <vprintfmt+0x138>
  800548:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054a:	83 f8 0f             	cmp    $0xf,%eax
  80054d:	7f 27                	jg     800576 <vprintfmt+0x13c>
  80054f:	8b 04 85 20 27 80 00 	mov    0x802720(,%eax,4),%eax
  800556:	85 c0                	test   %eax,%eax
  800558:	74 1c                	je     800576 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80055a:	50                   	push   %eax
  80055b:	68 48 28 80 00       	push   $0x802848
  800560:	53                   	push   %ebx
  800561:	56                   	push   %esi
  800562:	e8 b6 fe ff ff       	call   80041d <printfmt>
  800567:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80056d:	e9 8a 02 00 00       	jmp    8007fc <vprintfmt+0x3c2>
  800572:	f7 d8                	neg    %eax
  800574:	eb d2                	jmp    800548 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800576:	52                   	push   %edx
  800577:	68 9f 24 80 00       	push   $0x80249f
  80057c:	53                   	push   %ebx
  80057d:	56                   	push   %esi
  80057e:	e8 9a fe ff ff       	call   80041d <printfmt>
  800583:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800586:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800589:	e9 6e 02 00 00       	jmp    8007fc <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80058e:	8b 45 14             	mov    0x14(%ebp),%eax
  800591:	83 c0 04             	add    $0x4,%eax
  800594:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800597:	8b 45 14             	mov    0x14(%ebp),%eax
  80059a:	8b 38                	mov    (%eax),%edi
  80059c:	85 ff                	test   %edi,%edi
  80059e:	74 39                	je     8005d9 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8005a0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a4:	0f 8e a9 00 00 00    	jle    800653 <vprintfmt+0x219>
  8005aa:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005ae:	0f 84 a7 00 00 00    	je     80065b <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b4:	83 ec 08             	sub    $0x8,%esp
  8005b7:	ff 75 d0             	pushl  -0x30(%ebp)
  8005ba:	57                   	push   %edi
  8005bb:	e8 6b 03 00 00       	call   80092b <strnlen>
  8005c0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c3:	29 c1                	sub    %eax,%ecx
  8005c5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005c8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005cb:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005d5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005d7:	eb 14                	jmp    8005ed <vprintfmt+0x1b3>
				p = "(null)";
  8005d9:	bf 98 24 80 00       	mov    $0x802498,%edi
  8005de:	eb c0                	jmp    8005a0 <vprintfmt+0x166>
					putch(padc, putdat);
  8005e0:	83 ec 08             	sub    $0x8,%esp
  8005e3:	53                   	push   %ebx
  8005e4:	ff 75 e0             	pushl  -0x20(%ebp)
  8005e7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005e9:	4f                   	dec    %edi
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	85 ff                	test   %edi,%edi
  8005ef:	7f ef                	jg     8005e0 <vprintfmt+0x1a6>
  8005f1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005f4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005f7:	89 c8                	mov    %ecx,%eax
  8005f9:	85 c9                	test   %ecx,%ecx
  8005fb:	78 10                	js     80060d <vprintfmt+0x1d3>
  8005fd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800600:	29 c1                	sub    %eax,%ecx
  800602:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800605:	89 75 08             	mov    %esi,0x8(%ebp)
  800608:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80060b:	eb 15                	jmp    800622 <vprintfmt+0x1e8>
  80060d:	b8 00 00 00 00       	mov    $0x0,%eax
  800612:	eb e9                	jmp    8005fd <vprintfmt+0x1c3>
					putch(ch, putdat);
  800614:	83 ec 08             	sub    $0x8,%esp
  800617:	53                   	push   %ebx
  800618:	52                   	push   %edx
  800619:	ff 55 08             	call   *0x8(%ebp)
  80061c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80061f:	ff 4d e0             	decl   -0x20(%ebp)
  800622:	47                   	inc    %edi
  800623:	8a 47 ff             	mov    -0x1(%edi),%al
  800626:	0f be d0             	movsbl %al,%edx
  800629:	85 d2                	test   %edx,%edx
  80062b:	74 59                	je     800686 <vprintfmt+0x24c>
  80062d:	85 f6                	test   %esi,%esi
  80062f:	78 03                	js     800634 <vprintfmt+0x1fa>
  800631:	4e                   	dec    %esi
  800632:	78 2f                	js     800663 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800634:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800638:	74 da                	je     800614 <vprintfmt+0x1da>
  80063a:	0f be c0             	movsbl %al,%eax
  80063d:	83 e8 20             	sub    $0x20,%eax
  800640:	83 f8 5e             	cmp    $0x5e,%eax
  800643:	76 cf                	jbe    800614 <vprintfmt+0x1da>
					putch('?', putdat);
  800645:	83 ec 08             	sub    $0x8,%esp
  800648:	53                   	push   %ebx
  800649:	6a 3f                	push   $0x3f
  80064b:	ff 55 08             	call   *0x8(%ebp)
  80064e:	83 c4 10             	add    $0x10,%esp
  800651:	eb cc                	jmp    80061f <vprintfmt+0x1e5>
  800653:	89 75 08             	mov    %esi,0x8(%ebp)
  800656:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800659:	eb c7                	jmp    800622 <vprintfmt+0x1e8>
  80065b:	89 75 08             	mov    %esi,0x8(%ebp)
  80065e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800661:	eb bf                	jmp    800622 <vprintfmt+0x1e8>
  800663:	8b 75 08             	mov    0x8(%ebp),%esi
  800666:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800669:	eb 0c                	jmp    800677 <vprintfmt+0x23d>
				putch(' ', putdat);
  80066b:	83 ec 08             	sub    $0x8,%esp
  80066e:	53                   	push   %ebx
  80066f:	6a 20                	push   $0x20
  800671:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800673:	4f                   	dec    %edi
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	85 ff                	test   %edi,%edi
  800679:	7f f0                	jg     80066b <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80067b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80067e:	89 45 14             	mov    %eax,0x14(%ebp)
  800681:	e9 76 01 00 00       	jmp    8007fc <vprintfmt+0x3c2>
  800686:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800689:	8b 75 08             	mov    0x8(%ebp),%esi
  80068c:	eb e9                	jmp    800677 <vprintfmt+0x23d>
	if (lflag >= 2)
  80068e:	83 f9 01             	cmp    $0x1,%ecx
  800691:	7f 1f                	jg     8006b2 <vprintfmt+0x278>
	else if (lflag)
  800693:	85 c9                	test   %ecx,%ecx
  800695:	75 48                	jne    8006df <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800697:	8b 45 14             	mov    0x14(%ebp),%eax
  80069a:	8b 00                	mov    (%eax),%eax
  80069c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80069f:	89 c1                	mov    %eax,%ecx
  8006a1:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006aa:	8d 40 04             	lea    0x4(%eax),%eax
  8006ad:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b0:	eb 17                	jmp    8006c9 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b5:	8b 50 04             	mov    0x4(%eax),%edx
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006bd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c3:	8d 40 08             	lea    0x8(%eax),%eax
  8006c6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006cc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8006cf:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d3:	78 25                	js     8006fa <vprintfmt+0x2c0>
			base = 10;
  8006d5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006da:	e9 03 01 00 00       	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8006df:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006e7:	89 c1                	mov    %eax,%ecx
  8006e9:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ec:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f2:	8d 40 04             	lea    0x4(%eax),%eax
  8006f5:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f8:	eb cf                	jmp    8006c9 <vprintfmt+0x28f>
				putch('-', putdat);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	53                   	push   %ebx
  8006fe:	6a 2d                	push   $0x2d
  800700:	ff d6                	call   *%esi
				num = -(long long) num;
  800702:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800705:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800708:	f7 da                	neg    %edx
  80070a:	83 d1 00             	adc    $0x0,%ecx
  80070d:	f7 d9                	neg    %ecx
  80070f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800712:	b8 0a 00 00 00       	mov    $0xa,%eax
  800717:	e9 c6 00 00 00       	jmp    8007e2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80071c:	83 f9 01             	cmp    $0x1,%ecx
  80071f:	7f 1e                	jg     80073f <vprintfmt+0x305>
	else if (lflag)
  800721:	85 c9                	test   %ecx,%ecx
  800723:	75 32                	jne    800757 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800725:	8b 45 14             	mov    0x14(%ebp),%eax
  800728:	8b 10                	mov    (%eax),%edx
  80072a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80072f:	8d 40 04             	lea    0x4(%eax),%eax
  800732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800735:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073a:	e9 a3 00 00 00       	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80073f:	8b 45 14             	mov    0x14(%ebp),%eax
  800742:	8b 10                	mov    (%eax),%edx
  800744:	8b 48 04             	mov    0x4(%eax),%ecx
  800747:	8d 40 08             	lea    0x8(%eax),%eax
  80074a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80074d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800752:	e9 8b 00 00 00       	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800757:	8b 45 14             	mov    0x14(%ebp),%eax
  80075a:	8b 10                	mov    (%eax),%edx
  80075c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800761:	8d 40 04             	lea    0x4(%eax),%eax
  800764:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800767:	b8 0a 00 00 00       	mov    $0xa,%eax
  80076c:	eb 74                	jmp    8007e2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80076e:	83 f9 01             	cmp    $0x1,%ecx
  800771:	7f 1b                	jg     80078e <vprintfmt+0x354>
	else if (lflag)
  800773:	85 c9                	test   %ecx,%ecx
  800775:	75 2c                	jne    8007a3 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800777:	8b 45 14             	mov    0x14(%ebp),%eax
  80077a:	8b 10                	mov    (%eax),%edx
  80077c:	b9 00 00 00 00       	mov    $0x0,%ecx
  800781:	8d 40 04             	lea    0x4(%eax),%eax
  800784:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800787:	b8 08 00 00 00       	mov    $0x8,%eax
  80078c:	eb 54                	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80078e:	8b 45 14             	mov    0x14(%ebp),%eax
  800791:	8b 10                	mov    (%eax),%edx
  800793:	8b 48 04             	mov    0x4(%eax),%ecx
  800796:	8d 40 08             	lea    0x8(%eax),%eax
  800799:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80079c:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a1:	eb 3f                	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a6:	8b 10                	mov    (%eax),%edx
  8007a8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ad:	8d 40 04             	lea    0x4(%eax),%eax
  8007b0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b3:	b8 08 00 00 00       	mov    $0x8,%eax
  8007b8:	eb 28                	jmp    8007e2 <vprintfmt+0x3a8>
			putch('0', putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	6a 30                	push   $0x30
  8007c0:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c2:	83 c4 08             	add    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	6a 78                	push   $0x78
  8007c8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007ca:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cd:	8b 10                	mov    (%eax),%edx
  8007cf:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007d4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007d7:	8d 40 04             	lea    0x4(%eax),%eax
  8007da:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007dd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e2:	83 ec 0c             	sub    $0xc,%esp
  8007e5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007e9:	57                   	push   %edi
  8007ea:	ff 75 e0             	pushl  -0x20(%ebp)
  8007ed:	50                   	push   %eax
  8007ee:	51                   	push   %ecx
  8007ef:	52                   	push   %edx
  8007f0:	89 da                	mov    %ebx,%edx
  8007f2:	89 f0                	mov    %esi,%eax
  8007f4:	e8 5b fb ff ff       	call   800354 <printnum>
			break;
  8007f9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8007fc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ff:	47                   	inc    %edi
  800800:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800804:	83 f8 25             	cmp    $0x25,%eax
  800807:	0f 84 44 fc ff ff    	je     800451 <vprintfmt+0x17>
			if (ch == '\0')
  80080d:	85 c0                	test   %eax,%eax
  80080f:	0f 84 89 00 00 00    	je     80089e <vprintfmt+0x464>
			putch(ch, putdat);
  800815:	83 ec 08             	sub    $0x8,%esp
  800818:	53                   	push   %ebx
  800819:	50                   	push   %eax
  80081a:	ff d6                	call   *%esi
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	eb de                	jmp    8007ff <vprintfmt+0x3c5>
	if (lflag >= 2)
  800821:	83 f9 01             	cmp    $0x1,%ecx
  800824:	7f 1b                	jg     800841 <vprintfmt+0x407>
	else if (lflag)
  800826:	85 c9                	test   %ecx,%ecx
  800828:	75 2c                	jne    800856 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80082a:	8b 45 14             	mov    0x14(%ebp),%eax
  80082d:	8b 10                	mov    (%eax),%edx
  80082f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800834:	8d 40 04             	lea    0x4(%eax),%eax
  800837:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083a:	b8 10 00 00 00       	mov    $0x10,%eax
  80083f:	eb a1                	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	8b 10                	mov    (%eax),%edx
  800846:	8b 48 04             	mov    0x4(%eax),%ecx
  800849:	8d 40 08             	lea    0x8(%eax),%eax
  80084c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80084f:	b8 10 00 00 00       	mov    $0x10,%eax
  800854:	eb 8c                	jmp    8007e2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800856:	8b 45 14             	mov    0x14(%ebp),%eax
  800859:	8b 10                	mov    (%eax),%edx
  80085b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800860:	8d 40 04             	lea    0x4(%eax),%eax
  800863:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800866:	b8 10 00 00 00       	mov    $0x10,%eax
  80086b:	e9 72 ff ff ff       	jmp    8007e2 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800870:	83 ec 08             	sub    $0x8,%esp
  800873:	53                   	push   %ebx
  800874:	6a 25                	push   $0x25
  800876:	ff d6                	call   *%esi
			break;
  800878:	83 c4 10             	add    $0x10,%esp
  80087b:	e9 7c ff ff ff       	jmp    8007fc <vprintfmt+0x3c2>
			putch('%', putdat);
  800880:	83 ec 08             	sub    $0x8,%esp
  800883:	53                   	push   %ebx
  800884:	6a 25                	push   $0x25
  800886:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800888:	83 c4 10             	add    $0x10,%esp
  80088b:	89 f8                	mov    %edi,%eax
  80088d:	eb 01                	jmp    800890 <vprintfmt+0x456>
  80088f:	48                   	dec    %eax
  800890:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800894:	75 f9                	jne    80088f <vprintfmt+0x455>
  800896:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800899:	e9 5e ff ff ff       	jmp    8007fc <vprintfmt+0x3c2>
}
  80089e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a1:	5b                   	pop    %ebx
  8008a2:	5e                   	pop    %esi
  8008a3:	5f                   	pop    %edi
  8008a4:	5d                   	pop    %ebp
  8008a5:	c3                   	ret    

008008a6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008a6:	55                   	push   %ebp
  8008a7:	89 e5                	mov    %esp,%ebp
  8008a9:	83 ec 18             	sub    $0x18,%esp
  8008ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8008af:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008b5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008b9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008bc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c3:	85 c0                	test   %eax,%eax
  8008c5:	74 26                	je     8008ed <vsnprintf+0x47>
  8008c7:	85 d2                	test   %edx,%edx
  8008c9:	7e 29                	jle    8008f4 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008cb:	ff 75 14             	pushl  0x14(%ebp)
  8008ce:	ff 75 10             	pushl  0x10(%ebp)
  8008d1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d4:	50                   	push   %eax
  8008d5:	68 01 04 80 00       	push   $0x800401
  8008da:	e8 5b fb ff ff       	call   80043a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e8:	83 c4 10             	add    $0x10,%esp
}
  8008eb:	c9                   	leave  
  8008ec:	c3                   	ret    
		return -E_INVAL;
  8008ed:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f2:	eb f7                	jmp    8008eb <vsnprintf+0x45>
  8008f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f9:	eb f0                	jmp    8008eb <vsnprintf+0x45>

008008fb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8008fb:	55                   	push   %ebp
  8008fc:	89 e5                	mov    %esp,%ebp
  8008fe:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800901:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800904:	50                   	push   %eax
  800905:	ff 75 10             	pushl  0x10(%ebp)
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	ff 75 08             	pushl  0x8(%ebp)
  80090e:	e8 93 ff ff ff       	call   8008a6 <vsnprintf>
	va_end(ap);

	return rc;
}
  800913:	c9                   	leave  
  800914:	c3                   	ret    

00800915 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800915:	55                   	push   %ebp
  800916:	89 e5                	mov    %esp,%ebp
  800918:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80091b:	b8 00 00 00 00       	mov    $0x0,%eax
  800920:	eb 01                	jmp    800923 <strlen+0xe>
		n++;
  800922:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800923:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800927:	75 f9                	jne    800922 <strlen+0xd>
	return n;
}
  800929:	5d                   	pop    %ebp
  80092a:	c3                   	ret    

0080092b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80092b:	55                   	push   %ebp
  80092c:	89 e5                	mov    %esp,%ebp
  80092e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800934:	b8 00 00 00 00       	mov    $0x0,%eax
  800939:	eb 01                	jmp    80093c <strnlen+0x11>
		n++;
  80093b:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80093c:	39 d0                	cmp    %edx,%eax
  80093e:	74 06                	je     800946 <strnlen+0x1b>
  800940:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800944:	75 f5                	jne    80093b <strnlen+0x10>
	return n;
}
  800946:	5d                   	pop    %ebp
  800947:	c3                   	ret    

00800948 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800948:	55                   	push   %ebp
  800949:	89 e5                	mov    %esp,%ebp
  80094b:	53                   	push   %ebx
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800952:	89 c2                	mov    %eax,%edx
  800954:	42                   	inc    %edx
  800955:	41                   	inc    %ecx
  800956:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800959:	88 5a ff             	mov    %bl,-0x1(%edx)
  80095c:	84 db                	test   %bl,%bl
  80095e:	75 f4                	jne    800954 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800960:	5b                   	pop    %ebx
  800961:	5d                   	pop    %ebp
  800962:	c3                   	ret    

00800963 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800963:	55                   	push   %ebp
  800964:	89 e5                	mov    %esp,%ebp
  800966:	53                   	push   %ebx
  800967:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096a:	53                   	push   %ebx
  80096b:	e8 a5 ff ff ff       	call   800915 <strlen>
  800970:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800973:	ff 75 0c             	pushl  0xc(%ebp)
  800976:	01 d8                	add    %ebx,%eax
  800978:	50                   	push   %eax
  800979:	e8 ca ff ff ff       	call   800948 <strcpy>
	return dst;
}
  80097e:	89 d8                	mov    %ebx,%eax
  800980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800983:	c9                   	leave  
  800984:	c3                   	ret    

00800985 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800985:	55                   	push   %ebp
  800986:	89 e5                	mov    %esp,%ebp
  800988:	56                   	push   %esi
  800989:	53                   	push   %ebx
  80098a:	8b 75 08             	mov    0x8(%ebp),%esi
  80098d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800990:	89 f3                	mov    %esi,%ebx
  800992:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800995:	89 f2                	mov    %esi,%edx
  800997:	eb 0c                	jmp    8009a5 <strncpy+0x20>
		*dst++ = *src;
  800999:	42                   	inc    %edx
  80099a:	8a 01                	mov    (%ecx),%al
  80099c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80099f:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009a5:	39 da                	cmp    %ebx,%edx
  8009a7:	75 f0                	jne    800999 <strncpy+0x14>
	}
	return ret;
}
  8009a9:	89 f0                	mov    %esi,%eax
  8009ab:	5b                   	pop    %ebx
  8009ac:	5e                   	pop    %esi
  8009ad:	5d                   	pop    %ebp
  8009ae:	c3                   	ret    

008009af <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009af:	55                   	push   %ebp
  8009b0:	89 e5                	mov    %esp,%ebp
  8009b2:	56                   	push   %esi
  8009b3:	53                   	push   %ebx
  8009b4:	8b 75 08             	mov    0x8(%ebp),%esi
  8009b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009ba:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009bd:	85 c0                	test   %eax,%eax
  8009bf:	74 20                	je     8009e1 <strlcpy+0x32>
  8009c1:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8009c5:	89 f0                	mov    %esi,%eax
  8009c7:	eb 05                	jmp    8009ce <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009c9:	40                   	inc    %eax
  8009ca:	42                   	inc    %edx
  8009cb:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009ce:	39 d8                	cmp    %ebx,%eax
  8009d0:	74 06                	je     8009d8 <strlcpy+0x29>
  8009d2:	8a 0a                	mov    (%edx),%cl
  8009d4:	84 c9                	test   %cl,%cl
  8009d6:	75 f1                	jne    8009c9 <strlcpy+0x1a>
		*dst = '\0';
  8009d8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009db:	29 f0                	sub    %esi,%eax
}
  8009dd:	5b                   	pop    %ebx
  8009de:	5e                   	pop    %esi
  8009df:	5d                   	pop    %ebp
  8009e0:	c3                   	ret    
  8009e1:	89 f0                	mov    %esi,%eax
  8009e3:	eb f6                	jmp    8009db <strlcpy+0x2c>

008009e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009e5:	55                   	push   %ebp
  8009e6:	89 e5                	mov    %esp,%ebp
  8009e8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009eb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009ee:	eb 02                	jmp    8009f2 <strcmp+0xd>
		p++, q++;
  8009f0:	41                   	inc    %ecx
  8009f1:	42                   	inc    %edx
	while (*p && *p == *q)
  8009f2:	8a 01                	mov    (%ecx),%al
  8009f4:	84 c0                	test   %al,%al
  8009f6:	74 04                	je     8009fc <strcmp+0x17>
  8009f8:	3a 02                	cmp    (%edx),%al
  8009fa:	74 f4                	je     8009f0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8009fc:	0f b6 c0             	movzbl %al,%eax
  8009ff:	0f b6 12             	movzbl (%edx),%edx
  800a02:	29 d0                	sub    %edx,%eax
}
  800a04:	5d                   	pop    %ebp
  800a05:	c3                   	ret    

00800a06 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a06:	55                   	push   %ebp
  800a07:	89 e5                	mov    %esp,%ebp
  800a09:	53                   	push   %ebx
  800a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a10:	89 c3                	mov    %eax,%ebx
  800a12:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a15:	eb 02                	jmp    800a19 <strncmp+0x13>
		n--, p++, q++;
  800a17:	40                   	inc    %eax
  800a18:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 15                	je     800a32 <strncmp+0x2c>
  800a1d:	8a 08                	mov    (%eax),%cl
  800a1f:	84 c9                	test   %cl,%cl
  800a21:	74 04                	je     800a27 <strncmp+0x21>
  800a23:	3a 0a                	cmp    (%edx),%cl
  800a25:	74 f0                	je     800a17 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a27:	0f b6 00             	movzbl (%eax),%eax
  800a2a:	0f b6 12             	movzbl (%edx),%edx
  800a2d:	29 d0                	sub    %edx,%eax
}
  800a2f:	5b                   	pop    %ebx
  800a30:	5d                   	pop    %ebp
  800a31:	c3                   	ret    
		return 0;
  800a32:	b8 00 00 00 00       	mov    $0x0,%eax
  800a37:	eb f6                	jmp    800a2f <strncmp+0x29>

00800a39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a39:	55                   	push   %ebp
  800a3a:	89 e5                	mov    %esp,%ebp
  800a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a42:	8a 10                	mov    (%eax),%dl
  800a44:	84 d2                	test   %dl,%dl
  800a46:	74 07                	je     800a4f <strchr+0x16>
		if (*s == c)
  800a48:	38 ca                	cmp    %cl,%dl
  800a4a:	74 08                	je     800a54 <strchr+0x1b>
	for (; *s; s++)
  800a4c:	40                   	inc    %eax
  800a4d:	eb f3                	jmp    800a42 <strchr+0x9>
			return (char *) s;
	return 0;
  800a4f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a54:	5d                   	pop    %ebp
  800a55:	c3                   	ret    

00800a56 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a5f:	8a 10                	mov    (%eax),%dl
  800a61:	84 d2                	test   %dl,%dl
  800a63:	74 07                	je     800a6c <strfind+0x16>
		if (*s == c)
  800a65:	38 ca                	cmp    %cl,%dl
  800a67:	74 03                	je     800a6c <strfind+0x16>
	for (; *s; s++)
  800a69:	40                   	inc    %eax
  800a6a:	eb f3                	jmp    800a5f <strfind+0x9>
			break;
	return (char *) s;
}
  800a6c:	5d                   	pop    %ebp
  800a6d:	c3                   	ret    

00800a6e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a6e:	55                   	push   %ebp
  800a6f:	89 e5                	mov    %esp,%ebp
  800a71:	57                   	push   %edi
  800a72:	56                   	push   %esi
  800a73:	53                   	push   %ebx
  800a74:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a77:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7a:	85 c9                	test   %ecx,%ecx
  800a7c:	74 13                	je     800a91 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a7e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a84:	75 05                	jne    800a8b <memset+0x1d>
  800a86:	f6 c1 03             	test   $0x3,%cl
  800a89:	74 0d                	je     800a98 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a8e:	fc                   	cld    
  800a8f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a91:	89 f8                	mov    %edi,%eax
  800a93:	5b                   	pop    %ebx
  800a94:	5e                   	pop    %esi
  800a95:	5f                   	pop    %edi
  800a96:	5d                   	pop    %ebp
  800a97:	c3                   	ret    
		c &= 0xFF;
  800a98:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800a9c:	89 d3                	mov    %edx,%ebx
  800a9e:	c1 e3 08             	shl    $0x8,%ebx
  800aa1:	89 d0                	mov    %edx,%eax
  800aa3:	c1 e0 18             	shl    $0x18,%eax
  800aa6:	89 d6                	mov    %edx,%esi
  800aa8:	c1 e6 10             	shl    $0x10,%esi
  800aab:	09 f0                	or     %esi,%eax
  800aad:	09 c2                	or     %eax,%edx
  800aaf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab4:	89 d0                	mov    %edx,%eax
  800ab6:	fc                   	cld    
  800ab7:	f3 ab                	rep stos %eax,%es:(%edi)
  800ab9:	eb d6                	jmp    800a91 <memset+0x23>

00800abb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	57                   	push   %edi
  800abf:	56                   	push   %esi
  800ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac3:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ac6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ac9:	39 c6                	cmp    %eax,%esi
  800acb:	73 33                	jae    800b00 <memmove+0x45>
  800acd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad0:	39 d0                	cmp    %edx,%eax
  800ad2:	73 2c                	jae    800b00 <memmove+0x45>
		s += n;
		d += n;
  800ad4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800ad7:	89 d6                	mov    %edx,%esi
  800ad9:	09 fe                	or     %edi,%esi
  800adb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae1:	75 13                	jne    800af6 <memmove+0x3b>
  800ae3:	f6 c1 03             	test   $0x3,%cl
  800ae6:	75 0e                	jne    800af6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800ae8:	83 ef 04             	sub    $0x4,%edi
  800aeb:	8d 72 fc             	lea    -0x4(%edx),%esi
  800aee:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af1:	fd                   	std    
  800af2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af4:	eb 07                	jmp    800afd <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800af6:	4f                   	dec    %edi
  800af7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800afa:	fd                   	std    
  800afb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800afd:	fc                   	cld    
  800afe:	eb 13                	jmp    800b13 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b00:	89 f2                	mov    %esi,%edx
  800b02:	09 c2                	or     %eax,%edx
  800b04:	f6 c2 03             	test   $0x3,%dl
  800b07:	75 05                	jne    800b0e <memmove+0x53>
  800b09:	f6 c1 03             	test   $0x3,%cl
  800b0c:	74 09                	je     800b17 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b0e:	89 c7                	mov    %eax,%edi
  800b10:	fc                   	cld    
  800b11:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b13:	5e                   	pop    %esi
  800b14:	5f                   	pop    %edi
  800b15:	5d                   	pop    %ebp
  800b16:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b17:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1a:	89 c7                	mov    %eax,%edi
  800b1c:	fc                   	cld    
  800b1d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b1f:	eb f2                	jmp    800b13 <memmove+0x58>

00800b21 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b21:	55                   	push   %ebp
  800b22:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b24:	ff 75 10             	pushl  0x10(%ebp)
  800b27:	ff 75 0c             	pushl  0xc(%ebp)
  800b2a:	ff 75 08             	pushl  0x8(%ebp)
  800b2d:	e8 89 ff ff ff       	call   800abb <memmove>
}
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
  800b37:	56                   	push   %esi
  800b38:	53                   	push   %ebx
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 c6                	mov    %eax,%esi
  800b3e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800b44:	39 f0                	cmp    %esi,%eax
  800b46:	74 16                	je     800b5e <memcmp+0x2a>
		if (*s1 != *s2)
  800b48:	8a 08                	mov    (%eax),%cl
  800b4a:	8a 1a                	mov    (%edx),%bl
  800b4c:	38 d9                	cmp    %bl,%cl
  800b4e:	75 04                	jne    800b54 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b50:	40                   	inc    %eax
  800b51:	42                   	inc    %edx
  800b52:	eb f0                	jmp    800b44 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b54:	0f b6 c1             	movzbl %cl,%eax
  800b57:	0f b6 db             	movzbl %bl,%ebx
  800b5a:	29 d8                	sub    %ebx,%eax
  800b5c:	eb 05                	jmp    800b63 <memcmp+0x2f>
	}

	return 0;
  800b5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b63:	5b                   	pop    %ebx
  800b64:	5e                   	pop    %esi
  800b65:	5d                   	pop    %ebp
  800b66:	c3                   	ret    

00800b67 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b70:	89 c2                	mov    %eax,%edx
  800b72:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b75:	39 d0                	cmp    %edx,%eax
  800b77:	73 07                	jae    800b80 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b79:	38 08                	cmp    %cl,(%eax)
  800b7b:	74 03                	je     800b80 <memfind+0x19>
	for (; s < ends; s++)
  800b7d:	40                   	inc    %eax
  800b7e:	eb f5                	jmp    800b75 <memfind+0xe>
			break;
	return (void *) s;
}
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	57                   	push   %edi
  800b86:	56                   	push   %esi
  800b87:	53                   	push   %ebx
  800b88:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b8b:	eb 01                	jmp    800b8e <strtol+0xc>
		s++;
  800b8d:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800b8e:	8a 01                	mov    (%ecx),%al
  800b90:	3c 20                	cmp    $0x20,%al
  800b92:	74 f9                	je     800b8d <strtol+0xb>
  800b94:	3c 09                	cmp    $0x9,%al
  800b96:	74 f5                	je     800b8d <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800b98:	3c 2b                	cmp    $0x2b,%al
  800b9a:	74 2b                	je     800bc7 <strtol+0x45>
		s++;
	else if (*s == '-')
  800b9c:	3c 2d                	cmp    $0x2d,%al
  800b9e:	74 2f                	je     800bcf <strtol+0x4d>
	int neg = 0;
  800ba0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ba5:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800bac:	75 12                	jne    800bc0 <strtol+0x3e>
  800bae:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb1:	74 24                	je     800bd7 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bb7:	75 07                	jne    800bc0 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bb9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800bc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800bc5:	eb 4e                	jmp    800c15 <strtol+0x93>
		s++;
  800bc7:	41                   	inc    %ecx
	int neg = 0;
  800bc8:	bf 00 00 00 00       	mov    $0x0,%edi
  800bcd:	eb d6                	jmp    800ba5 <strtol+0x23>
		s++, neg = 1;
  800bcf:	41                   	inc    %ecx
  800bd0:	bf 01 00 00 00       	mov    $0x1,%edi
  800bd5:	eb ce                	jmp    800ba5 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bd7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800bdb:	74 10                	je     800bed <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800bdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be1:	75 dd                	jne    800bc0 <strtol+0x3e>
		s++, base = 8;
  800be3:	41                   	inc    %ecx
  800be4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800beb:	eb d3                	jmp    800bc0 <strtol+0x3e>
		s += 2, base = 16;
  800bed:	83 c1 02             	add    $0x2,%ecx
  800bf0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800bf7:	eb c7                	jmp    800bc0 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bf9:	8d 72 9f             	lea    -0x61(%edx),%esi
  800bfc:	89 f3                	mov    %esi,%ebx
  800bfe:	80 fb 19             	cmp    $0x19,%bl
  800c01:	77 24                	ja     800c27 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c03:	0f be d2             	movsbl %dl,%edx
  800c06:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c09:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c0c:	7d 2b                	jge    800c39 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c0e:	41                   	inc    %ecx
  800c0f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c13:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c15:	8a 11                	mov    (%ecx),%dl
  800c17:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c1a:	80 fb 09             	cmp    $0x9,%bl
  800c1d:	77 da                	ja     800bf9 <strtol+0x77>
			dig = *s - '0';
  800c1f:	0f be d2             	movsbl %dl,%edx
  800c22:	83 ea 30             	sub    $0x30,%edx
  800c25:	eb e2                	jmp    800c09 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c27:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2a:	89 f3                	mov    %esi,%ebx
  800c2c:	80 fb 19             	cmp    $0x19,%bl
  800c2f:	77 08                	ja     800c39 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800c31:	0f be d2             	movsbl %dl,%edx
  800c34:	83 ea 37             	sub    $0x37,%edx
  800c37:	eb d0                	jmp    800c09 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c3d:	74 05                	je     800c44 <strtol+0xc2>
		*endptr = (char *) s;
  800c3f:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c42:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c44:	85 ff                	test   %edi,%edi
  800c46:	74 02                	je     800c4a <strtol+0xc8>
  800c48:	f7 d8                	neg    %eax
}
  800c4a:	5b                   	pop    %ebx
  800c4b:	5e                   	pop    %esi
  800c4c:	5f                   	pop    %edi
  800c4d:	5d                   	pop    %ebp
  800c4e:	c3                   	ret    

00800c4f <atoi>:

int
atoi(const char *s)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800c52:	6a 0a                	push   $0xa
  800c54:	6a 00                	push   $0x0
  800c56:	ff 75 08             	pushl  0x8(%ebp)
  800c59:	e8 24 ff ff ff       	call   800b82 <strtol>
}
  800c5e:	c9                   	leave  
  800c5f:	c3                   	ret    

00800c60 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c60:	55                   	push   %ebp
  800c61:	89 e5                	mov    %esp,%ebp
  800c63:	57                   	push   %edi
  800c64:	56                   	push   %esi
  800c65:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c66:	b8 00 00 00 00       	mov    $0x0,%eax
  800c6b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c6e:	8b 55 08             	mov    0x8(%ebp),%edx
  800c71:	89 c3                	mov    %eax,%ebx
  800c73:	89 c7                	mov    %eax,%edi
  800c75:	89 c6                	mov    %eax,%esi
  800c77:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c79:	5b                   	pop    %ebx
  800c7a:	5e                   	pop    %esi
  800c7b:	5f                   	pop    %edi
  800c7c:	5d                   	pop    %ebp
  800c7d:	c3                   	ret    

00800c7e <sys_cgetc>:

int
sys_cgetc(void)
{
  800c7e:	55                   	push   %ebp
  800c7f:	89 e5                	mov    %esp,%ebp
  800c81:	57                   	push   %edi
  800c82:	56                   	push   %esi
  800c83:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c84:	ba 00 00 00 00       	mov    $0x0,%edx
  800c89:	b8 01 00 00 00       	mov    $0x1,%eax
  800c8e:	89 d1                	mov    %edx,%ecx
  800c90:	89 d3                	mov    %edx,%ebx
  800c92:	89 d7                	mov    %edx,%edi
  800c94:	89 d6                	mov    %edx,%esi
  800c96:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c98:	5b                   	pop    %ebx
  800c99:	5e                   	pop    %esi
  800c9a:	5f                   	pop    %edi
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	57                   	push   %edi
  800ca1:	56                   	push   %esi
  800ca2:	53                   	push   %ebx
  800ca3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ca6:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cab:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	89 cb                	mov    %ecx,%ebx
  800cb5:	89 cf                	mov    %ecx,%edi
  800cb7:	89 ce                	mov    %ecx,%esi
  800cb9:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cbb:	85 c0                	test   %eax,%eax
  800cbd:	7f 08                	jg     800cc7 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800cbf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800cc2:	5b                   	pop    %ebx
  800cc3:	5e                   	pop    %esi
  800cc4:	5f                   	pop    %edi
  800cc5:	5d                   	pop    %ebp
  800cc6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800cc7:	83 ec 0c             	sub    $0xc,%esp
  800cca:	50                   	push   %eax
  800ccb:	6a 03                	push   $0x3
  800ccd:	68 7f 27 80 00       	push   $0x80277f
  800cd2:	6a 23                	push   $0x23
  800cd4:	68 9c 27 80 00       	push   $0x80279c
  800cd9:	e8 4f f5 ff ff       	call   80022d <_panic>

00800cde <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800cde:	55                   	push   %ebp
  800cdf:	89 e5                	mov    %esp,%ebp
  800ce1:	57                   	push   %edi
  800ce2:	56                   	push   %esi
  800ce3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce4:	ba 00 00 00 00       	mov    $0x0,%edx
  800ce9:	b8 02 00 00 00       	mov    $0x2,%eax
  800cee:	89 d1                	mov    %edx,%ecx
  800cf0:	89 d3                	mov    %edx,%ebx
  800cf2:	89 d7                	mov    %edx,%edi
  800cf4:	89 d6                	mov    %edx,%esi
  800cf6:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cf8:	5b                   	pop    %ebx
  800cf9:	5e                   	pop    %esi
  800cfa:	5f                   	pop    %edi
  800cfb:	5d                   	pop    %ebp
  800cfc:	c3                   	ret    

00800cfd <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800cfd:	55                   	push   %ebp
  800cfe:	89 e5                	mov    %esp,%ebp
  800d00:	57                   	push   %edi
  800d01:	56                   	push   %esi
  800d02:	53                   	push   %ebx
  800d03:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d06:	be 00 00 00 00       	mov    $0x0,%esi
  800d0b:	b8 04 00 00 00       	mov    $0x4,%eax
  800d10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d13:	8b 55 08             	mov    0x8(%ebp),%edx
  800d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d19:	89 f7                	mov    %esi,%edi
  800d1b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d1d:	85 c0                	test   %eax,%eax
  800d1f:	7f 08                	jg     800d29 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d21:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d24:	5b                   	pop    %ebx
  800d25:	5e                   	pop    %esi
  800d26:	5f                   	pop    %edi
  800d27:	5d                   	pop    %ebp
  800d28:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d29:	83 ec 0c             	sub    $0xc,%esp
  800d2c:	50                   	push   %eax
  800d2d:	6a 04                	push   $0x4
  800d2f:	68 7f 27 80 00       	push   $0x80277f
  800d34:	6a 23                	push   $0x23
  800d36:	68 9c 27 80 00       	push   $0x80279c
  800d3b:	e8 ed f4 ff ff       	call   80022d <_panic>

00800d40 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	57                   	push   %edi
  800d44:	56                   	push   %esi
  800d45:	53                   	push   %ebx
  800d46:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d49:	b8 05 00 00 00       	mov    $0x5,%eax
  800d4e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d51:	8b 55 08             	mov    0x8(%ebp),%edx
  800d54:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d57:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5a:	8b 75 18             	mov    0x18(%ebp),%esi
  800d5d:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d5f:	85 c0                	test   %eax,%eax
  800d61:	7f 08                	jg     800d6b <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d66:	5b                   	pop    %ebx
  800d67:	5e                   	pop    %esi
  800d68:	5f                   	pop    %edi
  800d69:	5d                   	pop    %ebp
  800d6a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d6b:	83 ec 0c             	sub    $0xc,%esp
  800d6e:	50                   	push   %eax
  800d6f:	6a 05                	push   $0x5
  800d71:	68 7f 27 80 00       	push   $0x80277f
  800d76:	6a 23                	push   $0x23
  800d78:	68 9c 27 80 00       	push   $0x80279c
  800d7d:	e8 ab f4 ff ff       	call   80022d <_panic>

00800d82 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d82:	55                   	push   %ebp
  800d83:	89 e5                	mov    %esp,%ebp
  800d85:	57                   	push   %edi
  800d86:	56                   	push   %esi
  800d87:	53                   	push   %ebx
  800d88:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d8b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d90:	b8 06 00 00 00       	mov    $0x6,%eax
  800d95:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d98:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9b:	89 df                	mov    %ebx,%edi
  800d9d:	89 de                	mov    %ebx,%esi
  800d9f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da1:	85 c0                	test   %eax,%eax
  800da3:	7f 08                	jg     800dad <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800da5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da8:	5b                   	pop    %ebx
  800da9:	5e                   	pop    %esi
  800daa:	5f                   	pop    %edi
  800dab:	5d                   	pop    %ebp
  800dac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800dad:	83 ec 0c             	sub    $0xc,%esp
  800db0:	50                   	push   %eax
  800db1:	6a 06                	push   $0x6
  800db3:	68 7f 27 80 00       	push   $0x80277f
  800db8:	6a 23                	push   $0x23
  800dba:	68 9c 27 80 00       	push   $0x80279c
  800dbf:	e8 69 f4 ff ff       	call   80022d <_panic>

00800dc4 <sys_yield>:

void
sys_yield(void)
{
  800dc4:	55                   	push   %ebp
  800dc5:	89 e5                	mov    %esp,%ebp
  800dc7:	57                   	push   %edi
  800dc8:	56                   	push   %esi
  800dc9:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
  800dcf:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd4:	89 d1                	mov    %edx,%ecx
  800dd6:	89 d3                	mov    %edx,%ebx
  800dd8:	89 d7                	mov    %edx,%edi
  800dda:	89 d6                	mov    %edx,%esi
  800ddc:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800dde:	5b                   	pop    %ebx
  800ddf:	5e                   	pop    %esi
  800de0:	5f                   	pop    %edi
  800de1:	5d                   	pop    %ebp
  800de2:	c3                   	ret    

00800de3 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de3:	55                   	push   %ebp
  800de4:	89 e5                	mov    %esp,%ebp
  800de6:	57                   	push   %edi
  800de7:	56                   	push   %esi
  800de8:	53                   	push   %ebx
  800de9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dec:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df1:	b8 08 00 00 00       	mov    $0x8,%eax
  800df6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800df9:	8b 55 08             	mov    0x8(%ebp),%edx
  800dfc:	89 df                	mov    %ebx,%edi
  800dfe:	89 de                	mov    %ebx,%esi
  800e00:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e02:	85 c0                	test   %eax,%eax
  800e04:	7f 08                	jg     800e0e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e06:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e09:	5b                   	pop    %ebx
  800e0a:	5e                   	pop    %esi
  800e0b:	5f                   	pop    %edi
  800e0c:	5d                   	pop    %ebp
  800e0d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e0e:	83 ec 0c             	sub    $0xc,%esp
  800e11:	50                   	push   %eax
  800e12:	6a 08                	push   $0x8
  800e14:	68 7f 27 80 00       	push   $0x80277f
  800e19:	6a 23                	push   $0x23
  800e1b:	68 9c 27 80 00       	push   $0x80279c
  800e20:	e8 08 f4 ff ff       	call   80022d <_panic>

00800e25 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	57                   	push   %edi
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e2e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e33:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e38:	8b 55 08             	mov    0x8(%ebp),%edx
  800e3b:	89 cb                	mov    %ecx,%ebx
  800e3d:	89 cf                	mov    %ecx,%edi
  800e3f:	89 ce                	mov    %ecx,%esi
  800e41:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e43:	85 c0                	test   %eax,%eax
  800e45:	7f 08                	jg     800e4f <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4a:	5b                   	pop    %ebx
  800e4b:	5e                   	pop    %esi
  800e4c:	5f                   	pop    %edi
  800e4d:	5d                   	pop    %ebp
  800e4e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e4f:	83 ec 0c             	sub    $0xc,%esp
  800e52:	50                   	push   %eax
  800e53:	6a 0c                	push   $0xc
  800e55:	68 7f 27 80 00       	push   $0x80277f
  800e5a:	6a 23                	push   $0x23
  800e5c:	68 9c 27 80 00       	push   $0x80279c
  800e61:	e8 c7 f3 ff ff       	call   80022d <_panic>

00800e66 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	57                   	push   %edi
  800e6a:	56                   	push   %esi
  800e6b:	53                   	push   %ebx
  800e6c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e6f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e74:	b8 09 00 00 00       	mov    $0x9,%eax
  800e79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e7c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e7f:	89 df                	mov    %ebx,%edi
  800e81:	89 de                	mov    %ebx,%esi
  800e83:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	7f 08                	jg     800e91 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e8c:	5b                   	pop    %ebx
  800e8d:	5e                   	pop    %esi
  800e8e:	5f                   	pop    %edi
  800e8f:	5d                   	pop    %ebp
  800e90:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e91:	83 ec 0c             	sub    $0xc,%esp
  800e94:	50                   	push   %eax
  800e95:	6a 09                	push   $0x9
  800e97:	68 7f 27 80 00       	push   $0x80277f
  800e9c:	6a 23                	push   $0x23
  800e9e:	68 9c 27 80 00       	push   $0x80279c
  800ea3:	e8 85 f3 ff ff       	call   80022d <_panic>

00800ea8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ea8:	55                   	push   %ebp
  800ea9:	89 e5                	mov    %esp,%ebp
  800eab:	57                   	push   %edi
  800eac:	56                   	push   %esi
  800ead:	53                   	push   %ebx
  800eae:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800eb6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ebb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	89 df                	mov    %ebx,%edi
  800ec3:	89 de                	mov    %ebx,%esi
  800ec5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	7f 08                	jg     800ed3 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ecb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ece:	5b                   	pop    %ebx
  800ecf:	5e                   	pop    %esi
  800ed0:	5f                   	pop    %edi
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed3:	83 ec 0c             	sub    $0xc,%esp
  800ed6:	50                   	push   %eax
  800ed7:	6a 0a                	push   $0xa
  800ed9:	68 7f 27 80 00       	push   $0x80277f
  800ede:	6a 23                	push   $0x23
  800ee0:	68 9c 27 80 00       	push   $0x80279c
  800ee5:	e8 43 f3 ff ff       	call   80022d <_panic>

00800eea <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eea:	55                   	push   %ebp
  800eeb:	89 e5                	mov    %esp,%ebp
  800eed:	57                   	push   %edi
  800eee:	56                   	push   %esi
  800eef:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef0:	be 00 00 00 00       	mov    $0x0,%esi
  800ef5:	b8 0d 00 00 00       	mov    $0xd,%eax
  800efa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800efd:	8b 55 08             	mov    0x8(%ebp),%edx
  800f00:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f03:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f06:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f08:	5b                   	pop    %ebx
  800f09:	5e                   	pop    %esi
  800f0a:	5f                   	pop    %edi
  800f0b:	5d                   	pop    %ebp
  800f0c:	c3                   	ret    

00800f0d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	57                   	push   %edi
  800f11:	56                   	push   %esi
  800f12:	53                   	push   %ebx
  800f13:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f16:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f1b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f20:	8b 55 08             	mov    0x8(%ebp),%edx
  800f23:	89 cb                	mov    %ecx,%ebx
  800f25:	89 cf                	mov    %ecx,%edi
  800f27:	89 ce                	mov    %ecx,%esi
  800f29:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f2b:	85 c0                	test   %eax,%eax
  800f2d:	7f 08                	jg     800f37 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f2f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f32:	5b                   	pop    %ebx
  800f33:	5e                   	pop    %esi
  800f34:	5f                   	pop    %edi
  800f35:	5d                   	pop    %ebp
  800f36:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f37:	83 ec 0c             	sub    $0xc,%esp
  800f3a:	50                   	push   %eax
  800f3b:	6a 0e                	push   $0xe
  800f3d:	68 7f 27 80 00       	push   $0x80277f
  800f42:	6a 23                	push   $0x23
  800f44:	68 9c 27 80 00       	push   $0x80279c
  800f49:	e8 df f2 ff ff       	call   80022d <_panic>

00800f4e <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800f4e:	55                   	push   %ebp
  800f4f:	89 e5                	mov    %esp,%ebp
  800f51:	57                   	push   %edi
  800f52:	56                   	push   %esi
  800f53:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f54:	be 00 00 00 00       	mov    $0x0,%esi
  800f59:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f5e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f61:	8b 55 08             	mov    0x8(%ebp),%edx
  800f64:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f67:	89 f7                	mov    %esi,%edi
  800f69:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f6b:	5b                   	pop    %ebx
  800f6c:	5e                   	pop    %esi
  800f6d:	5f                   	pop    %edi
  800f6e:	5d                   	pop    %ebp
  800f6f:	c3                   	ret    

00800f70 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800f70:	55                   	push   %ebp
  800f71:	89 e5                	mov    %esp,%ebp
  800f73:	57                   	push   %edi
  800f74:	56                   	push   %esi
  800f75:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f76:	be 00 00 00 00       	mov    $0x0,%esi
  800f7b:	b8 10 00 00 00       	mov    $0x10,%eax
  800f80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f83:	8b 55 08             	mov    0x8(%ebp),%edx
  800f86:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f89:	89 f7                	mov    %esi,%edi
  800f8b:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f8d:	5b                   	pop    %ebx
  800f8e:	5e                   	pop    %esi
  800f8f:	5f                   	pop    %edi
  800f90:	5d                   	pop    %ebp
  800f91:	c3                   	ret    

00800f92 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800f92:	55                   	push   %ebp
  800f93:	89 e5                	mov    %esp,%ebp
  800f95:	57                   	push   %edi
  800f96:	56                   	push   %esi
  800f97:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f98:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f9d:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fa5:	89 cb                	mov    %ecx,%ebx
  800fa7:	89 cf                	mov    %ecx,%edi
  800fa9:	89 ce                	mov    %ecx,%esi
  800fab:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800fad:	5b                   	pop    %ebx
  800fae:	5e                   	pop    %esi
  800faf:	5f                   	pop    %edi
  800fb0:	5d                   	pop    %ebp
  800fb1:	c3                   	ret    

00800fb2 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
  800fb5:	56                   	push   %esi
  800fb6:	53                   	push   %ebx
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fba:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800fbc:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fc0:	0f 84 84 00 00 00    	je     80104a <pgfault+0x98>
  800fc6:	89 d8                	mov    %ebx,%eax
  800fc8:	c1 e8 16             	shr    $0x16,%eax
  800fcb:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd2:	a8 01                	test   $0x1,%al
  800fd4:	74 74                	je     80104a <pgfault+0x98>
  800fd6:	89 d8                	mov    %ebx,%eax
  800fd8:	c1 e8 0c             	shr    $0xc,%eax
  800fdb:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe2:	f6 c4 08             	test   $0x8,%ah
  800fe5:	74 63                	je     80104a <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800fe7:	e8 f2 fc ff ff       	call   800cde <sys_getenvid>
  800fec:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800fee:	83 ec 04             	sub    $0x4,%esp
  800ff1:	6a 07                	push   $0x7
  800ff3:	68 00 f0 7f 00       	push   $0x7ff000
  800ff8:	50                   	push   %eax
  800ff9:	e8 ff fc ff ff       	call   800cfd <sys_page_alloc>
  800ffe:	83 c4 10             	add    $0x10,%esp
  801001:	85 c0                	test   %eax,%eax
  801003:	78 5b                	js     801060 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  801005:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  80100b:	83 ec 04             	sub    $0x4,%esp
  80100e:	68 00 10 00 00       	push   $0x1000
  801013:	53                   	push   %ebx
  801014:	68 00 f0 7f 00       	push   $0x7ff000
  801019:	e8 03 fb ff ff       	call   800b21 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  80101e:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801025:	53                   	push   %ebx
  801026:	56                   	push   %esi
  801027:	68 00 f0 7f 00       	push   $0x7ff000
  80102c:	56                   	push   %esi
  80102d:	e8 0e fd ff ff       	call   800d40 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  801032:	83 c4 18             	add    $0x18,%esp
  801035:	68 00 f0 7f 00       	push   $0x7ff000
  80103a:	56                   	push   %esi
  80103b:	e8 42 fd ff ff       	call   800d82 <sys_page_unmap>

}
  801040:	83 c4 10             	add    $0x10,%esp
  801043:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801046:	5b                   	pop    %ebx
  801047:	5e                   	pop    %esi
  801048:	5d                   	pop    %ebp
  801049:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  80104a:	68 ac 27 80 00       	push   $0x8027ac
  80104f:	68 36 28 80 00       	push   $0x802836
  801054:	6a 1c                	push   $0x1c
  801056:	68 4b 28 80 00       	push   $0x80284b
  80105b:	e8 cd f1 ff ff       	call   80022d <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801060:	68 fc 27 80 00       	push   $0x8027fc
  801065:	68 36 28 80 00       	push   $0x802836
  80106a:	6a 26                	push   $0x26
  80106c:	68 4b 28 80 00       	push   $0x80284b
  801071:	e8 b7 f1 ff ff       	call   80022d <_panic>

00801076 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  801076:	55                   	push   %ebp
  801077:	89 e5                	mov    %esp,%ebp
  801079:	57                   	push   %edi
  80107a:	56                   	push   %esi
  80107b:	53                   	push   %ebx
  80107c:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  80107f:	68 b2 0f 80 00       	push   $0x800fb2
  801084:	e8 b9 0e 00 00       	call   801f42 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801089:	b8 07 00 00 00       	mov    $0x7,%eax
  80108e:	cd 30                	int    $0x30
  801090:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801093:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  801096:	83 c4 10             	add    $0x10,%esp
  801099:	85 c0                	test   %eax,%eax
  80109b:	0f 88 58 01 00 00    	js     8011f9 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	74 07                	je     8010ac <fork+0x36>
  8010a5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010aa:	eb 72                	jmp    80111e <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010ac:	e8 2d fc ff ff       	call   800cde <sys_getenvid>
  8010b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010b6:	89 c2                	mov    %eax,%edx
  8010b8:	c1 e2 05             	shl    $0x5,%edx
  8010bb:	29 c2                	sub    %eax,%edx
  8010bd:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8010c4:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  8010c9:	e9 20 01 00 00       	jmp    8011ee <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  8010ce:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8010d5:	e8 04 fc ff ff       	call   800cde <sys_getenvid>
  8010da:	83 ec 0c             	sub    $0xc,%esp
  8010dd:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8010e3:	57                   	push   %edi
  8010e4:	56                   	push   %esi
  8010e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010e8:	56                   	push   %esi
  8010e9:	50                   	push   %eax
  8010ea:	e8 51 fc ff ff       	call   800d40 <sys_page_map>
  8010ef:	83 c4 20             	add    $0x20,%esp
  8010f2:	eb 18                	jmp    80110c <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  8010f4:	e8 e5 fb ff ff       	call   800cde <sys_getenvid>
  8010f9:	83 ec 0c             	sub    $0xc,%esp
  8010fc:	6a 05                	push   $0x5
  8010fe:	56                   	push   %esi
  8010ff:	ff 75 e4             	pushl  -0x1c(%ebp)
  801102:	56                   	push   %esi
  801103:	50                   	push   %eax
  801104:	e8 37 fc ff ff       	call   800d40 <sys_page_map>
  801109:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80110c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801112:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801118:	0f 84 8f 00 00 00    	je     8011ad <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  80111e:	89 d8                	mov    %ebx,%eax
  801120:	c1 e8 16             	shr    $0x16,%eax
  801123:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112a:	a8 01                	test   $0x1,%al
  80112c:	74 de                	je     80110c <fork+0x96>
  80112e:	89 d8                	mov    %ebx,%eax
  801130:	c1 e8 0c             	shr    $0xc,%eax
  801133:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113a:	a8 04                	test   $0x4,%al
  80113c:	74 ce                	je     80110c <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  80113e:	89 de                	mov    %ebx,%esi
  801140:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801146:	89 f0                	mov    %esi,%eax
  801148:	c1 e8 0c             	shr    $0xc,%eax
  80114b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801152:	f6 c6 04             	test   $0x4,%dh
  801155:	0f 85 73 ff ff ff    	jne    8010ce <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  80115b:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801162:	a9 02 08 00 00       	test   $0x802,%eax
  801167:	74 8b                	je     8010f4 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801169:	e8 70 fb ff ff       	call   800cde <sys_getenvid>
  80116e:	83 ec 0c             	sub    $0xc,%esp
  801171:	68 05 08 00 00       	push   $0x805
  801176:	56                   	push   %esi
  801177:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117a:	56                   	push   %esi
  80117b:	50                   	push   %eax
  80117c:	e8 bf fb ff ff       	call   800d40 <sys_page_map>
  801181:	83 c4 20             	add    $0x20,%esp
  801184:	85 c0                	test   %eax,%eax
  801186:	78 84                	js     80110c <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801188:	e8 51 fb ff ff       	call   800cde <sys_getenvid>
  80118d:	89 c7                	mov    %eax,%edi
  80118f:	e8 4a fb ff ff       	call   800cde <sys_getenvid>
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	68 05 08 00 00       	push   $0x805
  80119c:	56                   	push   %esi
  80119d:	57                   	push   %edi
  80119e:	56                   	push   %esi
  80119f:	50                   	push   %eax
  8011a0:	e8 9b fb ff ff       	call   800d40 <sys_page_map>
  8011a5:	83 c4 20             	add    $0x20,%esp
  8011a8:	e9 5f ff ff ff       	jmp    80110c <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8011ad:	83 ec 04             	sub    $0x4,%esp
  8011b0:	6a 07                	push   $0x7
  8011b2:	68 00 f0 bf ee       	push   $0xeebff000
  8011b7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8011ba:	57                   	push   %edi
  8011bb:	e8 3d fb ff ff       	call   800cfd <sys_page_alloc>
  8011c0:	83 c4 10             	add    $0x10,%esp
  8011c3:	85 c0                	test   %eax,%eax
  8011c5:	78 3b                	js     801202 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8011c7:	83 ec 08             	sub    $0x8,%esp
  8011ca:	68 88 1f 80 00       	push   $0x801f88
  8011cf:	57                   	push   %edi
  8011d0:	e8 d3 fc ff ff       	call   800ea8 <sys_env_set_pgfault_upcall>
  8011d5:	83 c4 10             	add    $0x10,%esp
  8011d8:	85 c0                	test   %eax,%eax
  8011da:	78 2f                	js     80120b <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8011dc:	83 ec 08             	sub    $0x8,%esp
  8011df:	6a 02                	push   $0x2
  8011e1:	57                   	push   %edi
  8011e2:	e8 fc fb ff ff       	call   800de3 <sys_env_set_status>
	if (temp < 0) {
  8011e7:	83 c4 10             	add    $0x10,%esp
  8011ea:	85 c0                	test   %eax,%eax
  8011ec:	78 26                	js     801214 <fork+0x19e>
		return -1;
	}

	return childid;
}
  8011ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f4:	5b                   	pop    %ebx
  8011f5:	5e                   	pop    %esi
  8011f6:	5f                   	pop    %edi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    
		return -1;
  8011f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801200:	eb ec                	jmp    8011ee <fork+0x178>
		return -1;
  801202:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801209:	eb e3                	jmp    8011ee <fork+0x178>
		return -1;
  80120b:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801212:	eb da                	jmp    8011ee <fork+0x178>
		return -1;
  801214:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80121b:	eb d1                	jmp    8011ee <fork+0x178>

0080121d <sfork>:

// Challenge!
int
sfork(void)
{
  80121d:	55                   	push   %ebp
  80121e:	89 e5                	mov    %esp,%ebp
  801220:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801223:	68 56 28 80 00       	push   $0x802856
  801228:	68 85 00 00 00       	push   $0x85
  80122d:	68 4b 28 80 00       	push   $0x80284b
  801232:	e8 f6 ef ff ff       	call   80022d <_panic>

00801237 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801237:	55                   	push   %ebp
  801238:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123a:	8b 45 08             	mov    0x8(%ebp),%eax
  80123d:	05 00 00 00 30       	add    $0x30000000,%eax
  801242:	c1 e8 0c             	shr    $0xc,%eax
}
  801245:	5d                   	pop    %ebp
  801246:	c3                   	ret    

00801247 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801247:	55                   	push   %ebp
  801248:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801252:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801257:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80125c:	5d                   	pop    %ebp
  80125d:	c3                   	ret    

0080125e <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  80125e:	55                   	push   %ebp
  80125f:	89 e5                	mov    %esp,%ebp
  801261:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801264:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801269:	89 c2                	mov    %eax,%edx
  80126b:	c1 ea 16             	shr    $0x16,%edx
  80126e:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801275:	f6 c2 01             	test   $0x1,%dl
  801278:	74 2a                	je     8012a4 <fd_alloc+0x46>
  80127a:	89 c2                	mov    %eax,%edx
  80127c:	c1 ea 0c             	shr    $0xc,%edx
  80127f:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801286:	f6 c2 01             	test   $0x1,%dl
  801289:	74 19                	je     8012a4 <fd_alloc+0x46>
  80128b:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801290:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801295:	75 d2                	jne    801269 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801297:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80129d:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012a2:	eb 07                	jmp    8012ab <fd_alloc+0x4d>
			*fd_store = fd;
  8012a4:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ab:	5d                   	pop    %ebp
  8012ac:	c3                   	ret    

008012ad <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012ad:	55                   	push   %ebp
  8012ae:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012b0:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8012b4:	77 39                	ja     8012ef <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	c1 e0 0c             	shl    $0xc,%eax
  8012bc:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012c1:	89 c2                	mov    %eax,%edx
  8012c3:	c1 ea 16             	shr    $0x16,%edx
  8012c6:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012cd:	f6 c2 01             	test   $0x1,%dl
  8012d0:	74 24                	je     8012f6 <fd_lookup+0x49>
  8012d2:	89 c2                	mov    %eax,%edx
  8012d4:	c1 ea 0c             	shr    $0xc,%edx
  8012d7:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012de:	f6 c2 01             	test   $0x1,%dl
  8012e1:	74 1a                	je     8012fd <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012e6:	89 02                	mov    %eax,(%edx)
	return 0;
  8012e8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    
		return -E_INVAL;
  8012ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f4:	eb f7                	jmp    8012ed <fd_lookup+0x40>
		return -E_INVAL;
  8012f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012fb:	eb f0                	jmp    8012ed <fd_lookup+0x40>
  8012fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801302:	eb e9                	jmp    8012ed <fd_lookup+0x40>

00801304 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	83 ec 08             	sub    $0x8,%esp
  80130a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80130d:	ba e8 28 80 00       	mov    $0x8028e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801312:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801317:	39 08                	cmp    %ecx,(%eax)
  801319:	74 33                	je     80134e <dev_lookup+0x4a>
  80131b:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  80131e:	8b 02                	mov    (%edx),%eax
  801320:	85 c0                	test   %eax,%eax
  801322:	75 f3                	jne    801317 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801324:	a1 04 40 80 00       	mov    0x804004,%eax
  801329:	8b 40 48             	mov    0x48(%eax),%eax
  80132c:	83 ec 04             	sub    $0x4,%esp
  80132f:	51                   	push   %ecx
  801330:	50                   	push   %eax
  801331:	68 6c 28 80 00       	push   $0x80286c
  801336:	e8 05 f0 ff ff       	call   800340 <cprintf>
	*dev = 0;
  80133b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801344:	83 c4 10             	add    $0x10,%esp
  801347:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80134c:	c9                   	leave  
  80134d:	c3                   	ret    
			*dev = devtab[i];
  80134e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801351:	89 01                	mov    %eax,(%ecx)
			return 0;
  801353:	b8 00 00 00 00       	mov    $0x0,%eax
  801358:	eb f2                	jmp    80134c <dev_lookup+0x48>

0080135a <fd_close>:
{
  80135a:	55                   	push   %ebp
  80135b:	89 e5                	mov    %esp,%ebp
  80135d:	57                   	push   %edi
  80135e:	56                   	push   %esi
  80135f:	53                   	push   %ebx
  801360:	83 ec 1c             	sub    $0x1c,%esp
  801363:	8b 75 08             	mov    0x8(%ebp),%esi
  801366:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801369:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80136c:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80136d:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801373:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801376:	50                   	push   %eax
  801377:	e8 31 ff ff ff       	call   8012ad <fd_lookup>
  80137c:	89 c7                	mov    %eax,%edi
  80137e:	83 c4 08             	add    $0x8,%esp
  801381:	85 c0                	test   %eax,%eax
  801383:	78 05                	js     80138a <fd_close+0x30>
	    || fd != fd2)
  801385:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801388:	74 13                	je     80139d <fd_close+0x43>
		return (must_exist ? r : 0);
  80138a:	84 db                	test   %bl,%bl
  80138c:	75 05                	jne    801393 <fd_close+0x39>
  80138e:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801393:	89 f8                	mov    %edi,%eax
  801395:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801398:	5b                   	pop    %ebx
  801399:	5e                   	pop    %esi
  80139a:	5f                   	pop    %edi
  80139b:	5d                   	pop    %ebp
  80139c:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80139d:	83 ec 08             	sub    $0x8,%esp
  8013a0:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013a3:	50                   	push   %eax
  8013a4:	ff 36                	pushl  (%esi)
  8013a6:	e8 59 ff ff ff       	call   801304 <dev_lookup>
  8013ab:	89 c7                	mov    %eax,%edi
  8013ad:	83 c4 10             	add    $0x10,%esp
  8013b0:	85 c0                	test   %eax,%eax
  8013b2:	78 15                	js     8013c9 <fd_close+0x6f>
		if (dev->dev_close)
  8013b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013b7:	8b 40 10             	mov    0x10(%eax),%eax
  8013ba:	85 c0                	test   %eax,%eax
  8013bc:	74 1b                	je     8013d9 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	56                   	push   %esi
  8013c2:	ff d0                	call   *%eax
  8013c4:	89 c7                	mov    %eax,%edi
  8013c6:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013c9:	83 ec 08             	sub    $0x8,%esp
  8013cc:	56                   	push   %esi
  8013cd:	6a 00                	push   $0x0
  8013cf:	e8 ae f9 ff ff       	call   800d82 <sys_page_unmap>
	return r;
  8013d4:	83 c4 10             	add    $0x10,%esp
  8013d7:	eb ba                	jmp    801393 <fd_close+0x39>
			r = 0;
  8013d9:	bf 00 00 00 00       	mov    $0x0,%edi
  8013de:	eb e9                	jmp    8013c9 <fd_close+0x6f>

008013e0 <close>:

int
close(int fdnum)
{
  8013e0:	55                   	push   %ebp
  8013e1:	89 e5                	mov    %esp,%ebp
  8013e3:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013e9:	50                   	push   %eax
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	e8 bb fe ff ff       	call   8012ad <fd_lookup>
  8013f2:	83 c4 08             	add    $0x8,%esp
  8013f5:	85 c0                	test   %eax,%eax
  8013f7:	78 10                	js     801409 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013f9:	83 ec 08             	sub    $0x8,%esp
  8013fc:	6a 01                	push   $0x1
  8013fe:	ff 75 f4             	pushl  -0xc(%ebp)
  801401:	e8 54 ff ff ff       	call   80135a <fd_close>
  801406:	83 c4 10             	add    $0x10,%esp
}
  801409:	c9                   	leave  
  80140a:	c3                   	ret    

0080140b <close_all>:

void
close_all(void)
{
  80140b:	55                   	push   %ebp
  80140c:	89 e5                	mov    %esp,%ebp
  80140e:	53                   	push   %ebx
  80140f:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801412:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801417:	83 ec 0c             	sub    $0xc,%esp
  80141a:	53                   	push   %ebx
  80141b:	e8 c0 ff ff ff       	call   8013e0 <close>
	for (i = 0; i < MAXFD; i++)
  801420:	43                   	inc    %ebx
  801421:	83 c4 10             	add    $0x10,%esp
  801424:	83 fb 20             	cmp    $0x20,%ebx
  801427:	75 ee                	jne    801417 <close_all+0xc>
}
  801429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80142c:	c9                   	leave  
  80142d:	c3                   	ret    

0080142e <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  80142e:	55                   	push   %ebp
  80142f:	89 e5                	mov    %esp,%ebp
  801431:	57                   	push   %edi
  801432:	56                   	push   %esi
  801433:	53                   	push   %ebx
  801434:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801437:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143a:	50                   	push   %eax
  80143b:	ff 75 08             	pushl  0x8(%ebp)
  80143e:	e8 6a fe ff ff       	call   8012ad <fd_lookup>
  801443:	89 c3                	mov    %eax,%ebx
  801445:	83 c4 08             	add    $0x8,%esp
  801448:	85 c0                	test   %eax,%eax
  80144a:	0f 88 81 00 00 00    	js     8014d1 <dup+0xa3>
		return r;
	close(newfdnum);
  801450:	83 ec 0c             	sub    $0xc,%esp
  801453:	ff 75 0c             	pushl  0xc(%ebp)
  801456:	e8 85 ff ff ff       	call   8013e0 <close>

	newfd = INDEX2FD(newfdnum);
  80145b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80145e:	c1 e6 0c             	shl    $0xc,%esi
  801461:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801467:	83 c4 04             	add    $0x4,%esp
  80146a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80146d:	e8 d5 fd ff ff       	call   801247 <fd2data>
  801472:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801474:	89 34 24             	mov    %esi,(%esp)
  801477:	e8 cb fd ff ff       	call   801247 <fd2data>
  80147c:	83 c4 10             	add    $0x10,%esp
  80147f:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801481:	89 d8                	mov    %ebx,%eax
  801483:	c1 e8 16             	shr    $0x16,%eax
  801486:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80148d:	a8 01                	test   $0x1,%al
  80148f:	74 11                	je     8014a2 <dup+0x74>
  801491:	89 d8                	mov    %ebx,%eax
  801493:	c1 e8 0c             	shr    $0xc,%eax
  801496:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80149d:	f6 c2 01             	test   $0x1,%dl
  8014a0:	75 39                	jne    8014db <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014a5:	89 d0                	mov    %edx,%eax
  8014a7:	c1 e8 0c             	shr    $0xc,%eax
  8014aa:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b1:	83 ec 0c             	sub    $0xc,%esp
  8014b4:	25 07 0e 00 00       	and    $0xe07,%eax
  8014b9:	50                   	push   %eax
  8014ba:	56                   	push   %esi
  8014bb:	6a 00                	push   $0x0
  8014bd:	52                   	push   %edx
  8014be:	6a 00                	push   $0x0
  8014c0:	e8 7b f8 ff ff       	call   800d40 <sys_page_map>
  8014c5:	89 c3                	mov    %eax,%ebx
  8014c7:	83 c4 20             	add    $0x20,%esp
  8014ca:	85 c0                	test   %eax,%eax
  8014cc:	78 31                	js     8014ff <dup+0xd1>
		goto err;

	return newfdnum;
  8014ce:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014d1:	89 d8                	mov    %ebx,%eax
  8014d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014d6:	5b                   	pop    %ebx
  8014d7:	5e                   	pop    %esi
  8014d8:	5f                   	pop    %edi
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014db:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ea:	50                   	push   %eax
  8014eb:	57                   	push   %edi
  8014ec:	6a 00                	push   $0x0
  8014ee:	53                   	push   %ebx
  8014ef:	6a 00                	push   $0x0
  8014f1:	e8 4a f8 ff ff       	call   800d40 <sys_page_map>
  8014f6:	89 c3                	mov    %eax,%ebx
  8014f8:	83 c4 20             	add    $0x20,%esp
  8014fb:	85 c0                	test   %eax,%eax
  8014fd:	79 a3                	jns    8014a2 <dup+0x74>
	sys_page_unmap(0, newfd);
  8014ff:	83 ec 08             	sub    $0x8,%esp
  801502:	56                   	push   %esi
  801503:	6a 00                	push   $0x0
  801505:	e8 78 f8 ff ff       	call   800d82 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80150a:	83 c4 08             	add    $0x8,%esp
  80150d:	57                   	push   %edi
  80150e:	6a 00                	push   $0x0
  801510:	e8 6d f8 ff ff       	call   800d82 <sys_page_unmap>
	return r;
  801515:	83 c4 10             	add    $0x10,%esp
  801518:	eb b7                	jmp    8014d1 <dup+0xa3>

0080151a <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80151a:	55                   	push   %ebp
  80151b:	89 e5                	mov    %esp,%ebp
  80151d:	53                   	push   %ebx
  80151e:	83 ec 14             	sub    $0x14,%esp
  801521:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801524:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801527:	50                   	push   %eax
  801528:	53                   	push   %ebx
  801529:	e8 7f fd ff ff       	call   8012ad <fd_lookup>
  80152e:	83 c4 08             	add    $0x8,%esp
  801531:	85 c0                	test   %eax,%eax
  801533:	78 3f                	js     801574 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801535:	83 ec 08             	sub    $0x8,%esp
  801538:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80153b:	50                   	push   %eax
  80153c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80153f:	ff 30                	pushl  (%eax)
  801541:	e8 be fd ff ff       	call   801304 <dev_lookup>
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	85 c0                	test   %eax,%eax
  80154b:	78 27                	js     801574 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  80154d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801550:	8b 42 08             	mov    0x8(%edx),%eax
  801553:	83 e0 03             	and    $0x3,%eax
  801556:	83 f8 01             	cmp    $0x1,%eax
  801559:	74 1e                	je     801579 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80155b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80155e:	8b 40 08             	mov    0x8(%eax),%eax
  801561:	85 c0                	test   %eax,%eax
  801563:	74 35                	je     80159a <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  801565:	83 ec 04             	sub    $0x4,%esp
  801568:	ff 75 10             	pushl  0x10(%ebp)
  80156b:	ff 75 0c             	pushl  0xc(%ebp)
  80156e:	52                   	push   %edx
  80156f:	ff d0                	call   *%eax
  801571:	83 c4 10             	add    $0x10,%esp
}
  801574:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801577:	c9                   	leave  
  801578:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801579:	a1 04 40 80 00       	mov    0x804004,%eax
  80157e:	8b 40 48             	mov    0x48(%eax),%eax
  801581:	83 ec 04             	sub    $0x4,%esp
  801584:	53                   	push   %ebx
  801585:	50                   	push   %eax
  801586:	68 ad 28 80 00       	push   $0x8028ad
  80158b:	e8 b0 ed ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801598:	eb da                	jmp    801574 <read+0x5a>
		return -E_NOT_SUPP;
  80159a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80159f:	eb d3                	jmp    801574 <read+0x5a>

008015a1 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	57                   	push   %edi
  8015a5:	56                   	push   %esi
  8015a6:	53                   	push   %ebx
  8015a7:	83 ec 0c             	sub    $0xc,%esp
  8015aa:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015ad:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015b5:	39 f3                	cmp    %esi,%ebx
  8015b7:	73 25                	jae    8015de <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015b9:	83 ec 04             	sub    $0x4,%esp
  8015bc:	89 f0                	mov    %esi,%eax
  8015be:	29 d8                	sub    %ebx,%eax
  8015c0:	50                   	push   %eax
  8015c1:	89 d8                	mov    %ebx,%eax
  8015c3:	03 45 0c             	add    0xc(%ebp),%eax
  8015c6:	50                   	push   %eax
  8015c7:	57                   	push   %edi
  8015c8:	e8 4d ff ff ff       	call   80151a <read>
		if (m < 0)
  8015cd:	83 c4 10             	add    $0x10,%esp
  8015d0:	85 c0                	test   %eax,%eax
  8015d2:	78 08                	js     8015dc <readn+0x3b>
			return m;
		if (m == 0)
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	74 06                	je     8015de <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015d8:	01 c3                	add    %eax,%ebx
  8015da:	eb d9                	jmp    8015b5 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015dc:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015de:	89 d8                	mov    %ebx,%eax
  8015e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e3:	5b                   	pop    %ebx
  8015e4:	5e                   	pop    %esi
  8015e5:	5f                   	pop    %edi
  8015e6:	5d                   	pop    %ebp
  8015e7:	c3                   	ret    

008015e8 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015e8:	55                   	push   %ebp
  8015e9:	89 e5                	mov    %esp,%ebp
  8015eb:	53                   	push   %ebx
  8015ec:	83 ec 14             	sub    $0x14,%esp
  8015ef:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015f5:	50                   	push   %eax
  8015f6:	53                   	push   %ebx
  8015f7:	e8 b1 fc ff ff       	call   8012ad <fd_lookup>
  8015fc:	83 c4 08             	add    $0x8,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 3a                	js     80163d <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801609:	50                   	push   %eax
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	ff 30                	pushl  (%eax)
  80160f:	e8 f0 fc ff ff       	call   801304 <dev_lookup>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	78 22                	js     80163d <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801622:	74 1e                	je     801642 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801627:	8b 52 0c             	mov    0xc(%edx),%edx
  80162a:	85 d2                	test   %edx,%edx
  80162c:	74 35                	je     801663 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  80162e:	83 ec 04             	sub    $0x4,%esp
  801631:	ff 75 10             	pushl  0x10(%ebp)
  801634:	ff 75 0c             	pushl  0xc(%ebp)
  801637:	50                   	push   %eax
  801638:	ff d2                	call   *%edx
  80163a:	83 c4 10             	add    $0x10,%esp
}
  80163d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801640:	c9                   	leave  
  801641:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801642:	a1 04 40 80 00       	mov    0x804004,%eax
  801647:	8b 40 48             	mov    0x48(%eax),%eax
  80164a:	83 ec 04             	sub    $0x4,%esp
  80164d:	53                   	push   %ebx
  80164e:	50                   	push   %eax
  80164f:	68 c9 28 80 00       	push   $0x8028c9
  801654:	e8 e7 ec ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801661:	eb da                	jmp    80163d <write+0x55>
		return -E_NOT_SUPP;
  801663:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801668:	eb d3                	jmp    80163d <write+0x55>

0080166a <seek>:

int
seek(int fdnum, off_t offset)
{
  80166a:	55                   	push   %ebp
  80166b:	89 e5                	mov    %esp,%ebp
  80166d:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801670:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801673:	50                   	push   %eax
  801674:	ff 75 08             	pushl  0x8(%ebp)
  801677:	e8 31 fc ff ff       	call   8012ad <fd_lookup>
  80167c:	83 c4 08             	add    $0x8,%esp
  80167f:	85 c0                	test   %eax,%eax
  801681:	78 0e                	js     801691 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801683:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801686:	8b 55 0c             	mov    0xc(%ebp),%edx
  801689:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80168c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	53                   	push   %ebx
  801697:	83 ec 14             	sub    $0x14,%esp
  80169a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80169d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a0:	50                   	push   %eax
  8016a1:	53                   	push   %ebx
  8016a2:	e8 06 fc ff ff       	call   8012ad <fd_lookup>
  8016a7:	83 c4 08             	add    $0x8,%esp
  8016aa:	85 c0                	test   %eax,%eax
  8016ac:	78 37                	js     8016e5 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016ae:	83 ec 08             	sub    $0x8,%esp
  8016b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b4:	50                   	push   %eax
  8016b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b8:	ff 30                	pushl  (%eax)
  8016ba:	e8 45 fc ff ff       	call   801304 <dev_lookup>
  8016bf:	83 c4 10             	add    $0x10,%esp
  8016c2:	85 c0                	test   %eax,%eax
  8016c4:	78 1f                	js     8016e5 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016cd:	74 1b                	je     8016ea <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d2:	8b 52 18             	mov    0x18(%edx),%edx
  8016d5:	85 d2                	test   %edx,%edx
  8016d7:	74 32                	je     80170b <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016d9:	83 ec 08             	sub    $0x8,%esp
  8016dc:	ff 75 0c             	pushl  0xc(%ebp)
  8016df:	50                   	push   %eax
  8016e0:	ff d2                	call   *%edx
  8016e2:	83 c4 10             	add    $0x10,%esp
}
  8016e5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e8:	c9                   	leave  
  8016e9:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ea:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016ef:	8b 40 48             	mov    0x48(%eax),%eax
  8016f2:	83 ec 04             	sub    $0x4,%esp
  8016f5:	53                   	push   %ebx
  8016f6:	50                   	push   %eax
  8016f7:	68 8c 28 80 00       	push   $0x80288c
  8016fc:	e8 3f ec ff ff       	call   800340 <cprintf>
		return -E_INVAL;
  801701:	83 c4 10             	add    $0x10,%esp
  801704:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801709:	eb da                	jmp    8016e5 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80170b:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801710:	eb d3                	jmp    8016e5 <ftruncate+0x52>

00801712 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801712:	55                   	push   %ebp
  801713:	89 e5                	mov    %esp,%ebp
  801715:	53                   	push   %ebx
  801716:	83 ec 14             	sub    $0x14,%esp
  801719:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80171c:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80171f:	50                   	push   %eax
  801720:	ff 75 08             	pushl  0x8(%ebp)
  801723:	e8 85 fb ff ff       	call   8012ad <fd_lookup>
  801728:	83 c4 08             	add    $0x8,%esp
  80172b:	85 c0                	test   %eax,%eax
  80172d:	78 4b                	js     80177a <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80172f:	83 ec 08             	sub    $0x8,%esp
  801732:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801735:	50                   	push   %eax
  801736:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801739:	ff 30                	pushl  (%eax)
  80173b:	e8 c4 fb ff ff       	call   801304 <dev_lookup>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	85 c0                	test   %eax,%eax
  801745:	78 33                	js     80177a <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174a:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  80174e:	74 2f                	je     80177f <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801750:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801753:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175a:	00 00 00 
	stat->st_type = 0;
  80175d:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801764:	00 00 00 
	stat->st_dev = dev;
  801767:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80176d:	83 ec 08             	sub    $0x8,%esp
  801770:	53                   	push   %ebx
  801771:	ff 75 f0             	pushl  -0x10(%ebp)
  801774:	ff 50 14             	call   *0x14(%eax)
  801777:	83 c4 10             	add    $0x10,%esp
}
  80177a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80177d:	c9                   	leave  
  80177e:	c3                   	ret    
		return -E_NOT_SUPP;
  80177f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801784:	eb f4                	jmp    80177a <fstat+0x68>

00801786 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	56                   	push   %esi
  80178a:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80178b:	83 ec 08             	sub    $0x8,%esp
  80178e:	6a 00                	push   $0x0
  801790:	ff 75 08             	pushl  0x8(%ebp)
  801793:	e8 34 02 00 00       	call   8019cc <open>
  801798:	89 c3                	mov    %eax,%ebx
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	85 c0                	test   %eax,%eax
  80179f:	78 1b                	js     8017bc <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017a1:	83 ec 08             	sub    $0x8,%esp
  8017a4:	ff 75 0c             	pushl  0xc(%ebp)
  8017a7:	50                   	push   %eax
  8017a8:	e8 65 ff ff ff       	call   801712 <fstat>
  8017ad:	89 c6                	mov    %eax,%esi
	close(fd);
  8017af:	89 1c 24             	mov    %ebx,(%esp)
  8017b2:	e8 29 fc ff ff       	call   8013e0 <close>
	return r;
  8017b7:	83 c4 10             	add    $0x10,%esp
  8017ba:	89 f3                	mov    %esi,%ebx
}
  8017bc:	89 d8                	mov    %ebx,%eax
  8017be:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c1:	5b                   	pop    %ebx
  8017c2:	5e                   	pop    %esi
  8017c3:	5d                   	pop    %ebp
  8017c4:	c3                   	ret    

008017c5 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
  8017c8:	56                   	push   %esi
  8017c9:	53                   	push   %ebx
  8017ca:	89 c6                	mov    %eax,%esi
  8017cc:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017ce:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017d5:	74 27                	je     8017fe <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017d7:	6a 07                	push   $0x7
  8017d9:	68 00 50 80 00       	push   $0x805000
  8017de:	56                   	push   %esi
  8017df:	ff 35 00 40 80 00    	pushl  0x804000
  8017e5:	e8 4d 08 00 00       	call   802037 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ea:	83 c4 0c             	add    $0xc,%esp
  8017ed:	6a 00                	push   $0x0
  8017ef:	53                   	push   %ebx
  8017f0:	6a 00                	push   $0x0
  8017f2:	e8 b7 07 00 00       	call   801fae <ipc_recv>
}
  8017f7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017fa:	5b                   	pop    %ebx
  8017fb:	5e                   	pop    %esi
  8017fc:	5d                   	pop    %ebp
  8017fd:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8017fe:	83 ec 0c             	sub    $0xc,%esp
  801801:	6a 01                	push   $0x1
  801803:	e8 8b 08 00 00       	call   802093 <ipc_find_env>
  801808:	a3 00 40 80 00       	mov    %eax,0x804000
  80180d:	83 c4 10             	add    $0x10,%esp
  801810:	eb c5                	jmp    8017d7 <fsipc+0x12>

00801812 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
  801815:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	8b 40 0c             	mov    0xc(%eax),%eax
  80181e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801823:	8b 45 0c             	mov    0xc(%ebp),%eax
  801826:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80182b:	ba 00 00 00 00       	mov    $0x0,%edx
  801830:	b8 02 00 00 00       	mov    $0x2,%eax
  801835:	e8 8b ff ff ff       	call   8017c5 <fsipc>
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <devfile_flush>:
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	8b 40 0c             	mov    0xc(%eax),%eax
  801848:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  80184d:	ba 00 00 00 00       	mov    $0x0,%edx
  801852:	b8 06 00 00 00       	mov    $0x6,%eax
  801857:	e8 69 ff ff ff       	call   8017c5 <fsipc>
}
  80185c:	c9                   	leave  
  80185d:	c3                   	ret    

0080185e <devfile_stat>:
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	83 ec 04             	sub    $0x4,%esp
  801865:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801868:	8b 45 08             	mov    0x8(%ebp),%eax
  80186b:	8b 40 0c             	mov    0xc(%eax),%eax
  80186e:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801873:	ba 00 00 00 00       	mov    $0x0,%edx
  801878:	b8 05 00 00 00       	mov    $0x5,%eax
  80187d:	e8 43 ff ff ff       	call   8017c5 <fsipc>
  801882:	85 c0                	test   %eax,%eax
  801884:	78 2c                	js     8018b2 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801886:	83 ec 08             	sub    $0x8,%esp
  801889:	68 00 50 80 00       	push   $0x805000
  80188e:	53                   	push   %ebx
  80188f:	e8 b4 f0 ff ff       	call   800948 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801894:	a1 80 50 80 00       	mov    0x805080,%eax
  801899:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80189f:	a1 84 50 80 00       	mov    0x805084,%eax
  8018a4:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018b5:	c9                   	leave  
  8018b6:	c3                   	ret    

008018b7 <devfile_write>:
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	53                   	push   %ebx
  8018bb:	83 ec 04             	sub    $0x4,%esp
  8018be:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8018c1:	89 d8                	mov    %ebx,%eax
  8018c3:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018c9:	76 05                	jbe    8018d0 <devfile_write+0x19>
  8018cb:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d3:	8b 52 0c             	mov    0xc(%edx),%edx
  8018d6:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8018dc:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8018e1:	83 ec 04             	sub    $0x4,%esp
  8018e4:	50                   	push   %eax
  8018e5:	ff 75 0c             	pushl  0xc(%ebp)
  8018e8:	68 08 50 80 00       	push   $0x805008
  8018ed:	e8 c9 f1 ff ff       	call   800abb <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8018f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8018f7:	b8 04 00 00 00       	mov    $0x4,%eax
  8018fc:	e8 c4 fe ff ff       	call   8017c5 <fsipc>
  801901:	83 c4 10             	add    $0x10,%esp
  801904:	85 c0                	test   %eax,%eax
  801906:	78 0b                	js     801913 <devfile_write+0x5c>
	assert(r <= n);
  801908:	39 c3                	cmp    %eax,%ebx
  80190a:	72 0c                	jb     801918 <devfile_write+0x61>
	assert(r <= PGSIZE);
  80190c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801911:	7f 1e                	jg     801931 <devfile_write+0x7a>
}
  801913:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801916:	c9                   	leave  
  801917:	c3                   	ret    
	assert(r <= n);
  801918:	68 f8 28 80 00       	push   $0x8028f8
  80191d:	68 36 28 80 00       	push   $0x802836
  801922:	68 98 00 00 00       	push   $0x98
  801927:	68 ff 28 80 00       	push   $0x8028ff
  80192c:	e8 fc e8 ff ff       	call   80022d <_panic>
	assert(r <= PGSIZE);
  801931:	68 0a 29 80 00       	push   $0x80290a
  801936:	68 36 28 80 00       	push   $0x802836
  80193b:	68 99 00 00 00       	push   $0x99
  801940:	68 ff 28 80 00       	push   $0x8028ff
  801945:	e8 e3 e8 ff ff       	call   80022d <_panic>

0080194a <devfile_read>:
{
  80194a:	55                   	push   %ebp
  80194b:	89 e5                	mov    %esp,%ebp
  80194d:	56                   	push   %esi
  80194e:	53                   	push   %ebx
  80194f:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801952:	8b 45 08             	mov    0x8(%ebp),%eax
  801955:	8b 40 0c             	mov    0xc(%eax),%eax
  801958:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  80195d:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801963:	ba 00 00 00 00       	mov    $0x0,%edx
  801968:	b8 03 00 00 00       	mov    $0x3,%eax
  80196d:	e8 53 fe ff ff       	call   8017c5 <fsipc>
  801972:	89 c3                	mov    %eax,%ebx
  801974:	85 c0                	test   %eax,%eax
  801976:	78 1f                	js     801997 <devfile_read+0x4d>
	assert(r <= n);
  801978:	39 c6                	cmp    %eax,%esi
  80197a:	72 24                	jb     8019a0 <devfile_read+0x56>
	assert(r <= PGSIZE);
  80197c:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801981:	7f 33                	jg     8019b6 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801983:	83 ec 04             	sub    $0x4,%esp
  801986:	50                   	push   %eax
  801987:	68 00 50 80 00       	push   $0x805000
  80198c:	ff 75 0c             	pushl  0xc(%ebp)
  80198f:	e8 27 f1 ff ff       	call   800abb <memmove>
	return r;
  801994:	83 c4 10             	add    $0x10,%esp
}
  801997:	89 d8                	mov    %ebx,%eax
  801999:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199c:	5b                   	pop    %ebx
  80199d:	5e                   	pop    %esi
  80199e:	5d                   	pop    %ebp
  80199f:	c3                   	ret    
	assert(r <= n);
  8019a0:	68 f8 28 80 00       	push   $0x8028f8
  8019a5:	68 36 28 80 00       	push   $0x802836
  8019aa:	6a 7c                	push   $0x7c
  8019ac:	68 ff 28 80 00       	push   $0x8028ff
  8019b1:	e8 77 e8 ff ff       	call   80022d <_panic>
	assert(r <= PGSIZE);
  8019b6:	68 0a 29 80 00       	push   $0x80290a
  8019bb:	68 36 28 80 00       	push   $0x802836
  8019c0:	6a 7d                	push   $0x7d
  8019c2:	68 ff 28 80 00       	push   $0x8028ff
  8019c7:	e8 61 e8 ff ff       	call   80022d <_panic>

008019cc <open>:
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 1c             	sub    $0x1c,%esp
  8019d4:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019d7:	56                   	push   %esi
  8019d8:	e8 38 ef ff ff       	call   800915 <strlen>
  8019dd:	83 c4 10             	add    $0x10,%esp
  8019e0:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019e5:	7f 6c                	jg     801a53 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019e7:	83 ec 0c             	sub    $0xc,%esp
  8019ea:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019ed:	50                   	push   %eax
  8019ee:	e8 6b f8 ff ff       	call   80125e <fd_alloc>
  8019f3:	89 c3                	mov    %eax,%ebx
  8019f5:	83 c4 10             	add    $0x10,%esp
  8019f8:	85 c0                	test   %eax,%eax
  8019fa:	78 3c                	js     801a38 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8019fc:	83 ec 08             	sub    $0x8,%esp
  8019ff:	56                   	push   %esi
  801a00:	68 00 50 80 00       	push   $0x805000
  801a05:	e8 3e ef ff ff       	call   800948 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a0d:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a15:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1a:	e8 a6 fd ff ff       	call   8017c5 <fsipc>
  801a1f:	89 c3                	mov    %eax,%ebx
  801a21:	83 c4 10             	add    $0x10,%esp
  801a24:	85 c0                	test   %eax,%eax
  801a26:	78 19                	js     801a41 <open+0x75>
	return fd2num(fd);
  801a28:	83 ec 0c             	sub    $0xc,%esp
  801a2b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a2e:	e8 04 f8 ff ff       	call   801237 <fd2num>
  801a33:	89 c3                	mov    %eax,%ebx
  801a35:	83 c4 10             	add    $0x10,%esp
}
  801a38:	89 d8                	mov    %ebx,%eax
  801a3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a3d:	5b                   	pop    %ebx
  801a3e:	5e                   	pop    %esi
  801a3f:	5d                   	pop    %ebp
  801a40:	c3                   	ret    
		fd_close(fd, 0);
  801a41:	83 ec 08             	sub    $0x8,%esp
  801a44:	6a 00                	push   $0x0
  801a46:	ff 75 f4             	pushl  -0xc(%ebp)
  801a49:	e8 0c f9 ff ff       	call   80135a <fd_close>
		return r;
  801a4e:	83 c4 10             	add    $0x10,%esp
  801a51:	eb e5                	jmp    801a38 <open+0x6c>
		return -E_BAD_PATH;
  801a53:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a58:	eb de                	jmp    801a38 <open+0x6c>

00801a5a <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a60:	ba 00 00 00 00       	mov    $0x0,%edx
  801a65:	b8 08 00 00 00       	mov    $0x8,%eax
  801a6a:	e8 56 fd ff ff       	call   8017c5 <fsipc>
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
  801a74:	56                   	push   %esi
  801a75:	53                   	push   %ebx
  801a76:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a79:	83 ec 0c             	sub    $0xc,%esp
  801a7c:	ff 75 08             	pushl  0x8(%ebp)
  801a7f:	e8 c3 f7 ff ff       	call   801247 <fd2data>
  801a84:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a86:	83 c4 08             	add    $0x8,%esp
  801a89:	68 16 29 80 00       	push   $0x802916
  801a8e:	53                   	push   %ebx
  801a8f:	e8 b4 ee ff ff       	call   800948 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a94:	8b 46 04             	mov    0x4(%esi),%eax
  801a97:	2b 06                	sub    (%esi),%eax
  801a99:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801a9f:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801aa6:	10 00 00 
	stat->st_dev = &devpipe;
  801aa9:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ab0:	30 80 00 
	return 0;
}
  801ab3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ab8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801abb:	5b                   	pop    %ebx
  801abc:	5e                   	pop    %esi
  801abd:	5d                   	pop    %ebp
  801abe:	c3                   	ret    

00801abf <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
  801ac2:	53                   	push   %ebx
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ac9:	53                   	push   %ebx
  801aca:	6a 00                	push   $0x0
  801acc:	e8 b1 f2 ff ff       	call   800d82 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ad1:	89 1c 24             	mov    %ebx,(%esp)
  801ad4:	e8 6e f7 ff ff       	call   801247 <fd2data>
  801ad9:	83 c4 08             	add    $0x8,%esp
  801adc:	50                   	push   %eax
  801add:	6a 00                	push   $0x0
  801adf:	e8 9e f2 ff ff       	call   800d82 <sys_page_unmap>
}
  801ae4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ae7:	c9                   	leave  
  801ae8:	c3                   	ret    

00801ae9 <_pipeisclosed>:
{
  801ae9:	55                   	push   %ebp
  801aea:	89 e5                	mov    %esp,%ebp
  801aec:	57                   	push   %edi
  801aed:	56                   	push   %esi
  801aee:	53                   	push   %ebx
  801aef:	83 ec 1c             	sub    $0x1c,%esp
  801af2:	89 c7                	mov    %eax,%edi
  801af4:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801af6:	a1 04 40 80 00       	mov    0x804004,%eax
  801afb:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801afe:	83 ec 0c             	sub    $0xc,%esp
  801b01:	57                   	push   %edi
  801b02:	e8 ce 05 00 00       	call   8020d5 <pageref>
  801b07:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b0a:	89 34 24             	mov    %esi,(%esp)
  801b0d:	e8 c3 05 00 00       	call   8020d5 <pageref>
		nn = thisenv->env_runs;
  801b12:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b18:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b1b:	83 c4 10             	add    $0x10,%esp
  801b1e:	39 cb                	cmp    %ecx,%ebx
  801b20:	74 1b                	je     801b3d <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b22:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b25:	75 cf                	jne    801af6 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b27:	8b 42 58             	mov    0x58(%edx),%eax
  801b2a:	6a 01                	push   $0x1
  801b2c:	50                   	push   %eax
  801b2d:	53                   	push   %ebx
  801b2e:	68 1d 29 80 00       	push   $0x80291d
  801b33:	e8 08 e8 ff ff       	call   800340 <cprintf>
  801b38:	83 c4 10             	add    $0x10,%esp
  801b3b:	eb b9                	jmp    801af6 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b3d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b40:	0f 94 c0             	sete   %al
  801b43:	0f b6 c0             	movzbl %al,%eax
}
  801b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    

00801b4e <devpipe_write>:
{
  801b4e:	55                   	push   %ebp
  801b4f:	89 e5                	mov    %esp,%ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 18             	sub    $0x18,%esp
  801b57:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b5a:	56                   	push   %esi
  801b5b:	e8 e7 f6 ff ff       	call   801247 <fd2data>
  801b60:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6a:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b6d:	74 41                	je     801bb0 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b6f:	8b 53 04             	mov    0x4(%ebx),%edx
  801b72:	8b 03                	mov    (%ebx),%eax
  801b74:	83 c0 20             	add    $0x20,%eax
  801b77:	39 c2                	cmp    %eax,%edx
  801b79:	72 14                	jb     801b8f <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b7b:	89 da                	mov    %ebx,%edx
  801b7d:	89 f0                	mov    %esi,%eax
  801b7f:	e8 65 ff ff ff       	call   801ae9 <_pipeisclosed>
  801b84:	85 c0                	test   %eax,%eax
  801b86:	75 2c                	jne    801bb4 <devpipe_write+0x66>
			sys_yield();
  801b88:	e8 37 f2 ff ff       	call   800dc4 <sys_yield>
  801b8d:	eb e0                	jmp    801b6f <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b92:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801b95:	89 d0                	mov    %edx,%eax
  801b97:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801b9c:	78 0b                	js     801ba9 <devpipe_write+0x5b>
  801b9e:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801ba2:	42                   	inc    %edx
  801ba3:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ba6:	47                   	inc    %edi
  801ba7:	eb c1                	jmp    801b6a <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ba9:	48                   	dec    %eax
  801baa:	83 c8 e0             	or     $0xffffffe0,%eax
  801bad:	40                   	inc    %eax
  801bae:	eb ee                	jmp    801b9e <devpipe_write+0x50>
	return i;
  801bb0:	89 f8                	mov    %edi,%eax
  801bb2:	eb 05                	jmp    801bb9 <devpipe_write+0x6b>
				return 0;
  801bb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbc:	5b                   	pop    %ebx
  801bbd:	5e                   	pop    %esi
  801bbe:	5f                   	pop    %edi
  801bbf:	5d                   	pop    %ebp
  801bc0:	c3                   	ret    

00801bc1 <devpipe_read>:
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	57                   	push   %edi
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 18             	sub    $0x18,%esp
  801bca:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bcd:	57                   	push   %edi
  801bce:	e8 74 f6 ff ff       	call   801247 <fd2data>
  801bd3:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801bd5:	83 c4 10             	add    $0x10,%esp
  801bd8:	bb 00 00 00 00       	mov    $0x0,%ebx
  801bdd:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801be0:	74 46                	je     801c28 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801be2:	8b 06                	mov    (%esi),%eax
  801be4:	3b 46 04             	cmp    0x4(%esi),%eax
  801be7:	75 22                	jne    801c0b <devpipe_read+0x4a>
			if (i > 0)
  801be9:	85 db                	test   %ebx,%ebx
  801beb:	74 0a                	je     801bf7 <devpipe_read+0x36>
				return i;
  801bed:	89 d8                	mov    %ebx,%eax
}
  801bef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf2:	5b                   	pop    %ebx
  801bf3:	5e                   	pop    %esi
  801bf4:	5f                   	pop    %edi
  801bf5:	5d                   	pop    %ebp
  801bf6:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801bf7:	89 f2                	mov    %esi,%edx
  801bf9:	89 f8                	mov    %edi,%eax
  801bfb:	e8 e9 fe ff ff       	call   801ae9 <_pipeisclosed>
  801c00:	85 c0                	test   %eax,%eax
  801c02:	75 28                	jne    801c2c <devpipe_read+0x6b>
			sys_yield();
  801c04:	e8 bb f1 ff ff       	call   800dc4 <sys_yield>
  801c09:	eb d7                	jmp    801be2 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c0b:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c10:	78 0f                	js     801c21 <devpipe_read+0x60>
  801c12:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c16:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c19:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c1c:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c1e:	43                   	inc    %ebx
  801c1f:	eb bc                	jmp    801bdd <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c21:	48                   	dec    %eax
  801c22:	83 c8 e0             	or     $0xffffffe0,%eax
  801c25:	40                   	inc    %eax
  801c26:	eb ea                	jmp    801c12 <devpipe_read+0x51>
	return i;
  801c28:	89 d8                	mov    %ebx,%eax
  801c2a:	eb c3                	jmp    801bef <devpipe_read+0x2e>
				return 0;
  801c2c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c31:	eb bc                	jmp    801bef <devpipe_read+0x2e>

00801c33 <pipe>:
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
  801c36:	56                   	push   %esi
  801c37:	53                   	push   %ebx
  801c38:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c3b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c3e:	50                   	push   %eax
  801c3f:	e8 1a f6 ff ff       	call   80125e <fd_alloc>
  801c44:	89 c3                	mov    %eax,%ebx
  801c46:	83 c4 10             	add    $0x10,%esp
  801c49:	85 c0                	test   %eax,%eax
  801c4b:	0f 88 2a 01 00 00    	js     801d7b <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c51:	83 ec 04             	sub    $0x4,%esp
  801c54:	68 07 04 00 00       	push   $0x407
  801c59:	ff 75 f4             	pushl  -0xc(%ebp)
  801c5c:	6a 00                	push   $0x0
  801c5e:	e8 9a f0 ff ff       	call   800cfd <sys_page_alloc>
  801c63:	89 c3                	mov    %eax,%ebx
  801c65:	83 c4 10             	add    $0x10,%esp
  801c68:	85 c0                	test   %eax,%eax
  801c6a:	0f 88 0b 01 00 00    	js     801d7b <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801c70:	83 ec 0c             	sub    $0xc,%esp
  801c73:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c76:	50                   	push   %eax
  801c77:	e8 e2 f5 ff ff       	call   80125e <fd_alloc>
  801c7c:	89 c3                	mov    %eax,%ebx
  801c7e:	83 c4 10             	add    $0x10,%esp
  801c81:	85 c0                	test   %eax,%eax
  801c83:	0f 88 e2 00 00 00    	js     801d6b <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	68 07 04 00 00       	push   $0x407
  801c91:	ff 75 f0             	pushl  -0x10(%ebp)
  801c94:	6a 00                	push   $0x0
  801c96:	e8 62 f0 ff ff       	call   800cfd <sys_page_alloc>
  801c9b:	89 c3                	mov    %eax,%ebx
  801c9d:	83 c4 10             	add    $0x10,%esp
  801ca0:	85 c0                	test   %eax,%eax
  801ca2:	0f 88 c3 00 00 00    	js     801d6b <pipe+0x138>
	va = fd2data(fd0);
  801ca8:	83 ec 0c             	sub    $0xc,%esp
  801cab:	ff 75 f4             	pushl  -0xc(%ebp)
  801cae:	e8 94 f5 ff ff       	call   801247 <fd2data>
  801cb3:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cb5:	83 c4 0c             	add    $0xc,%esp
  801cb8:	68 07 04 00 00       	push   $0x407
  801cbd:	50                   	push   %eax
  801cbe:	6a 00                	push   $0x0
  801cc0:	e8 38 f0 ff ff       	call   800cfd <sys_page_alloc>
  801cc5:	89 c3                	mov    %eax,%ebx
  801cc7:	83 c4 10             	add    $0x10,%esp
  801cca:	85 c0                	test   %eax,%eax
  801ccc:	0f 88 89 00 00 00    	js     801d5b <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd2:	83 ec 0c             	sub    $0xc,%esp
  801cd5:	ff 75 f0             	pushl  -0x10(%ebp)
  801cd8:	e8 6a f5 ff ff       	call   801247 <fd2data>
  801cdd:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ce4:	50                   	push   %eax
  801ce5:	6a 00                	push   $0x0
  801ce7:	56                   	push   %esi
  801ce8:	6a 00                	push   $0x0
  801cea:	e8 51 f0 ff ff       	call   800d40 <sys_page_map>
  801cef:	89 c3                	mov    %eax,%ebx
  801cf1:	83 c4 20             	add    $0x20,%esp
  801cf4:	85 c0                	test   %eax,%eax
  801cf6:	78 55                	js     801d4d <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801cf8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801cfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d01:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d0d:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d16:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d22:	83 ec 0c             	sub    $0xc,%esp
  801d25:	ff 75 f4             	pushl  -0xc(%ebp)
  801d28:	e8 0a f5 ff ff       	call   801237 <fd2num>
  801d2d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d30:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d32:	83 c4 04             	add    $0x4,%esp
  801d35:	ff 75 f0             	pushl  -0x10(%ebp)
  801d38:	e8 fa f4 ff ff       	call   801237 <fd2num>
  801d3d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d40:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d43:	83 c4 10             	add    $0x10,%esp
  801d46:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d4b:	eb 2e                	jmp    801d7b <pipe+0x148>
	sys_page_unmap(0, va);
  801d4d:	83 ec 08             	sub    $0x8,%esp
  801d50:	56                   	push   %esi
  801d51:	6a 00                	push   $0x0
  801d53:	e8 2a f0 ff ff       	call   800d82 <sys_page_unmap>
  801d58:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d5b:	83 ec 08             	sub    $0x8,%esp
  801d5e:	ff 75 f0             	pushl  -0x10(%ebp)
  801d61:	6a 00                	push   $0x0
  801d63:	e8 1a f0 ff ff       	call   800d82 <sys_page_unmap>
  801d68:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d6b:	83 ec 08             	sub    $0x8,%esp
  801d6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d71:	6a 00                	push   $0x0
  801d73:	e8 0a f0 ff ff       	call   800d82 <sys_page_unmap>
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	89 d8                	mov    %ebx,%eax
  801d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    

00801d84 <pipeisclosed>:
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
  801d87:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d8d:	50                   	push   %eax
  801d8e:	ff 75 08             	pushl  0x8(%ebp)
  801d91:	e8 17 f5 ff ff       	call   8012ad <fd_lookup>
  801d96:	83 c4 10             	add    $0x10,%esp
  801d99:	85 c0                	test   %eax,%eax
  801d9b:	78 18                	js     801db5 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801d9d:	83 ec 0c             	sub    $0xc,%esp
  801da0:	ff 75 f4             	pushl  -0xc(%ebp)
  801da3:	e8 9f f4 ff ff       	call   801247 <fd2data>
	return _pipeisclosed(fd, p);
  801da8:	89 c2                	mov    %eax,%edx
  801daa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dad:	e8 37 fd ff ff       	call   801ae9 <_pipeisclosed>
  801db2:	83 c4 10             	add    $0x10,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801dba:	b8 00 00 00 00       	mov    $0x0,%eax
  801dbf:	5d                   	pop    %ebp
  801dc0:	c3                   	ret    

00801dc1 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	53                   	push   %ebx
  801dc5:	83 ec 0c             	sub    $0xc,%esp
  801dc8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801dcb:	68 35 29 80 00       	push   $0x802935
  801dd0:	53                   	push   %ebx
  801dd1:	e8 72 eb ff ff       	call   800948 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801dd6:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801ddd:	20 00 00 
	return 0;
}
  801de0:	b8 00 00 00 00       	mov    $0x0,%eax
  801de5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <devcons_write>:
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	57                   	push   %edi
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801df6:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801dfb:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e01:	eb 1d                	jmp    801e20 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e03:	83 ec 04             	sub    $0x4,%esp
  801e06:	53                   	push   %ebx
  801e07:	03 45 0c             	add    0xc(%ebp),%eax
  801e0a:	50                   	push   %eax
  801e0b:	57                   	push   %edi
  801e0c:	e8 aa ec ff ff       	call   800abb <memmove>
		sys_cputs(buf, m);
  801e11:	83 c4 08             	add    $0x8,%esp
  801e14:	53                   	push   %ebx
  801e15:	57                   	push   %edi
  801e16:	e8 45 ee ff ff       	call   800c60 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e1b:	01 de                	add    %ebx,%esi
  801e1d:	83 c4 10             	add    $0x10,%esp
  801e20:	89 f0                	mov    %esi,%eax
  801e22:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e25:	73 11                	jae    801e38 <devcons_write+0x4e>
		m = n - tot;
  801e27:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e2a:	29 f3                	sub    %esi,%ebx
  801e2c:	83 fb 7f             	cmp    $0x7f,%ebx
  801e2f:	76 d2                	jbe    801e03 <devcons_write+0x19>
  801e31:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801e36:	eb cb                	jmp    801e03 <devcons_write+0x19>
}
  801e38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e3b:	5b                   	pop    %ebx
  801e3c:	5e                   	pop    %esi
  801e3d:	5f                   	pop    %edi
  801e3e:	5d                   	pop    %ebp
  801e3f:	c3                   	ret    

00801e40 <devcons_read>:
{
  801e40:	55                   	push   %ebp
  801e41:	89 e5                	mov    %esp,%ebp
  801e43:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801e46:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4a:	75 0c                	jne    801e58 <devcons_read+0x18>
		return 0;
  801e4c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e51:	eb 21                	jmp    801e74 <devcons_read+0x34>
		sys_yield();
  801e53:	e8 6c ef ff ff       	call   800dc4 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801e58:	e8 21 ee ff ff       	call   800c7e <sys_cgetc>
  801e5d:	85 c0                	test   %eax,%eax
  801e5f:	74 f2                	je     801e53 <devcons_read+0x13>
	if (c < 0)
  801e61:	85 c0                	test   %eax,%eax
  801e63:	78 0f                	js     801e74 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801e65:	83 f8 04             	cmp    $0x4,%eax
  801e68:	74 0c                	je     801e76 <devcons_read+0x36>
	*(char*)vbuf = c;
  801e6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e6d:	88 02                	mov    %al,(%edx)
	return 1;
  801e6f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    
		return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
  801e7b:	eb f7                	jmp    801e74 <devcons_read+0x34>

00801e7d <cputchar>:
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
  801e80:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801e83:	8b 45 08             	mov    0x8(%ebp),%eax
  801e86:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801e89:	6a 01                	push   $0x1
  801e8b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801e8e:	50                   	push   %eax
  801e8f:	e8 cc ed ff ff       	call   800c60 <sys_cputs>
}
  801e94:	83 c4 10             	add    $0x10,%esp
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <getchar>:
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801e9f:	6a 01                	push   $0x1
  801ea1:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ea4:	50                   	push   %eax
  801ea5:	6a 00                	push   $0x0
  801ea7:	e8 6e f6 ff ff       	call   80151a <read>
	if (r < 0)
  801eac:	83 c4 10             	add    $0x10,%esp
  801eaf:	85 c0                	test   %eax,%eax
  801eb1:	78 08                	js     801ebb <getchar+0x22>
	if (r < 1)
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	7e 06                	jle    801ebd <getchar+0x24>
	return c;
  801eb7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    
		return -E_EOF;
  801ebd:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801ec2:	eb f7                	jmp    801ebb <getchar+0x22>

00801ec4 <iscons>:
{
  801ec4:	55                   	push   %ebp
  801ec5:	89 e5                	mov    %esp,%ebp
  801ec7:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801eca:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ecd:	50                   	push   %eax
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	e8 d7 f3 ff ff       	call   8012ad <fd_lookup>
  801ed6:	83 c4 10             	add    $0x10,%esp
  801ed9:	85 c0                	test   %eax,%eax
  801edb:	78 11                	js     801eee <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ee0:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801ee6:	39 10                	cmp    %edx,(%eax)
  801ee8:	0f 94 c0             	sete   %al
  801eeb:	0f b6 c0             	movzbl %al,%eax
}
  801eee:	c9                   	leave  
  801eef:	c3                   	ret    

00801ef0 <opencons>:
{
  801ef0:	55                   	push   %ebp
  801ef1:	89 e5                	mov    %esp,%ebp
  801ef3:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801ef6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801ef9:	50                   	push   %eax
  801efa:	e8 5f f3 ff ff       	call   80125e <fd_alloc>
  801eff:	83 c4 10             	add    $0x10,%esp
  801f02:	85 c0                	test   %eax,%eax
  801f04:	78 3a                	js     801f40 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f06:	83 ec 04             	sub    $0x4,%esp
  801f09:	68 07 04 00 00       	push   $0x407
  801f0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801f11:	6a 00                	push   $0x0
  801f13:	e8 e5 ed ff ff       	call   800cfd <sys_page_alloc>
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	85 c0                	test   %eax,%eax
  801f1d:	78 21                	js     801f40 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f1f:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f28:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2d:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f34:	83 ec 0c             	sub    $0xc,%esp
  801f37:	50                   	push   %eax
  801f38:	e8 fa f2 ff ff       	call   801237 <fd2num>
  801f3d:	83 c4 10             	add    $0x10,%esp
}
  801f40:	c9                   	leave  
  801f41:	c3                   	ret    

00801f42 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f42:	55                   	push   %ebp
  801f43:	89 e5                	mov    %esp,%ebp
  801f45:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801f48:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801f4f:	74 0a                	je     801f5b <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801f51:	8b 45 08             	mov    0x8(%ebp),%eax
  801f54:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801f5b:	e8 7e ed ff ff       	call   800cde <sys_getenvid>
  801f60:	83 ec 04             	sub    $0x4,%esp
  801f63:	6a 07                	push   $0x7
  801f65:	68 00 f0 bf ee       	push   $0xeebff000
  801f6a:	50                   	push   %eax
  801f6b:	e8 8d ed ff ff       	call   800cfd <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801f70:	e8 69 ed ff ff       	call   800cde <sys_getenvid>
  801f75:	83 c4 08             	add    $0x8,%esp
  801f78:	68 88 1f 80 00       	push   $0x801f88
  801f7d:	50                   	push   %eax
  801f7e:	e8 25 ef ff ff       	call   800ea8 <sys_env_set_pgfault_upcall>
  801f83:	83 c4 10             	add    $0x10,%esp
  801f86:	eb c9                	jmp    801f51 <set_pgfault_handler+0xf>

00801f88 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801f88:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801f89:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801f8e:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801f90:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801f93:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801f97:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801f9b:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801f9e:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801fa0:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801fa4:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  801fa7:	61                   	popa   
	addl $4, %esp
  801fa8:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  801fab:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  801fac:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  801fad:	c3                   	ret    

00801fae <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801fae:	55                   	push   %ebp
  801faf:	89 e5                	mov    %esp,%ebp
  801fb1:	57                   	push   %edi
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	83 ec 0c             	sub    $0xc,%esp
  801fb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801fba:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801fbd:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801fc0:	85 ff                	test   %edi,%edi
  801fc2:	74 53                	je     802017 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801fc4:	83 ec 0c             	sub    $0xc,%esp
  801fc7:	57                   	push   %edi
  801fc8:	e8 40 ef ff ff       	call   800f0d <sys_ipc_recv>
  801fcd:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801fd0:	85 db                	test   %ebx,%ebx
  801fd2:	74 0b                	je     801fdf <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801fd4:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fda:	8b 52 74             	mov    0x74(%edx),%edx
  801fdd:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801fdf:	85 f6                	test   %esi,%esi
  801fe1:	74 0f                	je     801ff2 <ipc_recv+0x44>
  801fe3:	85 ff                	test   %edi,%edi
  801fe5:	74 0b                	je     801ff2 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801fe7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801fed:	8b 52 78             	mov    0x78(%edx),%edx
  801ff0:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	74 30                	je     802026 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801ff6:	85 db                	test   %ebx,%ebx
  801ff8:	74 06                	je     802000 <ipc_recv+0x52>
      		*from_env_store = 0;
  801ffa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802000:	85 f6                	test   %esi,%esi
  802002:	74 2c                	je     802030 <ipc_recv+0x82>
      		*perm_store = 0;
  802004:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80200a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  80200f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802012:	5b                   	pop    %ebx
  802013:	5e                   	pop    %esi
  802014:	5f                   	pop    %edi
  802015:	5d                   	pop    %ebp
  802016:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802017:	83 ec 0c             	sub    $0xc,%esp
  80201a:	6a ff                	push   $0xffffffff
  80201c:	e8 ec ee ff ff       	call   800f0d <sys_ipc_recv>
  802021:	83 c4 10             	add    $0x10,%esp
  802024:	eb aa                	jmp    801fd0 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  802026:	a1 04 40 80 00       	mov    0x804004,%eax
  80202b:	8b 40 70             	mov    0x70(%eax),%eax
  80202e:	eb df                	jmp    80200f <ipc_recv+0x61>
		return -1;
  802030:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  802035:	eb d8                	jmp    80200f <ipc_recv+0x61>

00802037 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802037:	55                   	push   %ebp
  802038:	89 e5                	mov    %esp,%ebp
  80203a:	57                   	push   %edi
  80203b:	56                   	push   %esi
  80203c:	53                   	push   %ebx
  80203d:	83 ec 0c             	sub    $0xc,%esp
  802040:	8b 75 0c             	mov    0xc(%ebp),%esi
  802043:	8b 5d 10             	mov    0x10(%ebp),%ebx
  802046:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  802049:	85 db                	test   %ebx,%ebx
  80204b:	75 22                	jne    80206f <ipc_send+0x38>
		pg = (void *) UTOP+1;
  80204d:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  802052:	eb 1b                	jmp    80206f <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802054:	68 44 29 80 00       	push   $0x802944
  802059:	68 36 28 80 00       	push   $0x802836
  80205e:	6a 48                	push   $0x48
  802060:	68 68 29 80 00       	push   $0x802968
  802065:	e8 c3 e1 ff ff       	call   80022d <_panic>
		sys_yield();
  80206a:	e8 55 ed ff ff       	call   800dc4 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80206f:	57                   	push   %edi
  802070:	53                   	push   %ebx
  802071:	56                   	push   %esi
  802072:	ff 75 08             	pushl  0x8(%ebp)
  802075:	e8 70 ee ff ff       	call   800eea <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	83 f8 f9             	cmp    $0xfffffff9,%eax
  802080:	74 e8                	je     80206a <ipc_send+0x33>
  802082:	85 c0                	test   %eax,%eax
  802084:	75 ce                	jne    802054 <ipc_send+0x1d>
		sys_yield();
  802086:	e8 39 ed ff ff       	call   800dc4 <sys_yield>
		
	}
	
}
  80208b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80208e:	5b                   	pop    %ebx
  80208f:	5e                   	pop    %esi
  802090:	5f                   	pop    %edi
  802091:	5d                   	pop    %ebp
  802092:	c3                   	ret    

00802093 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  802093:	55                   	push   %ebp
  802094:	89 e5                	mov    %esp,%ebp
  802096:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802099:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  80209e:	89 c2                	mov    %eax,%edx
  8020a0:	c1 e2 05             	shl    $0x5,%edx
  8020a3:	29 c2                	sub    %eax,%edx
  8020a5:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  8020ac:	8b 52 50             	mov    0x50(%edx),%edx
  8020af:	39 ca                	cmp    %ecx,%edx
  8020b1:	74 0f                	je     8020c2 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  8020b3:	40                   	inc    %eax
  8020b4:	3d 00 04 00 00       	cmp    $0x400,%eax
  8020b9:	75 e3                	jne    80209e <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  8020bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020c0:	eb 11                	jmp    8020d3 <ipc_find_env+0x40>
			return envs[i].env_id;
  8020c2:	89 c2                	mov    %eax,%edx
  8020c4:	c1 e2 05             	shl    $0x5,%edx
  8020c7:	29 c2                	sub    %eax,%edx
  8020c9:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8020d0:	8b 40 48             	mov    0x48(%eax),%eax
}
  8020d3:	5d                   	pop    %ebp
  8020d4:	c3                   	ret    

008020d5 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  8020d5:	55                   	push   %ebp
  8020d6:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	c1 e8 16             	shr    $0x16,%eax
  8020de:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8020e5:	a8 01                	test   $0x1,%al
  8020e7:	74 21                	je     80210a <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  8020e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ec:	c1 e8 0c             	shr    $0xc,%eax
  8020ef:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8020f6:	a8 01                	test   $0x1,%al
  8020f8:	74 17                	je     802111 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8020fa:	c1 e8 0c             	shr    $0xc,%eax
  8020fd:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  802104:	ef 
  802105:	0f b7 c0             	movzwl %ax,%eax
  802108:	eb 05                	jmp    80210f <pageref+0x3a>
		return 0;
  80210a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80210f:	5d                   	pop    %ebp
  802110:	c3                   	ret    
		return 0;
  802111:	b8 00 00 00 00       	mov    $0x0,%eax
  802116:	eb f7                	jmp    80210f <pageref+0x3a>

00802118 <__udivdi3>:
  802118:	55                   	push   %ebp
  802119:	57                   	push   %edi
  80211a:	56                   	push   %esi
  80211b:	53                   	push   %ebx
  80211c:	83 ec 1c             	sub    $0x1c,%esp
  80211f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  802123:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802127:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80212b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80212f:	89 ca                	mov    %ecx,%edx
  802131:	89 f8                	mov    %edi,%eax
  802133:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802137:	85 f6                	test   %esi,%esi
  802139:	75 2d                	jne    802168 <__udivdi3+0x50>
  80213b:	39 cf                	cmp    %ecx,%edi
  80213d:	77 65                	ja     8021a4 <__udivdi3+0x8c>
  80213f:	89 fd                	mov    %edi,%ebp
  802141:	85 ff                	test   %edi,%edi
  802143:	75 0b                	jne    802150 <__udivdi3+0x38>
  802145:	b8 01 00 00 00       	mov    $0x1,%eax
  80214a:	31 d2                	xor    %edx,%edx
  80214c:	f7 f7                	div    %edi
  80214e:	89 c5                	mov    %eax,%ebp
  802150:	31 d2                	xor    %edx,%edx
  802152:	89 c8                	mov    %ecx,%eax
  802154:	f7 f5                	div    %ebp
  802156:	89 c1                	mov    %eax,%ecx
  802158:	89 d8                	mov    %ebx,%eax
  80215a:	f7 f5                	div    %ebp
  80215c:	89 cf                	mov    %ecx,%edi
  80215e:	89 fa                	mov    %edi,%edx
  802160:	83 c4 1c             	add    $0x1c,%esp
  802163:	5b                   	pop    %ebx
  802164:	5e                   	pop    %esi
  802165:	5f                   	pop    %edi
  802166:	5d                   	pop    %ebp
  802167:	c3                   	ret    
  802168:	39 ce                	cmp    %ecx,%esi
  80216a:	77 28                	ja     802194 <__udivdi3+0x7c>
  80216c:	0f bd fe             	bsr    %esi,%edi
  80216f:	83 f7 1f             	xor    $0x1f,%edi
  802172:	75 40                	jne    8021b4 <__udivdi3+0x9c>
  802174:	39 ce                	cmp    %ecx,%esi
  802176:	72 0a                	jb     802182 <__udivdi3+0x6a>
  802178:	3b 44 24 04          	cmp    0x4(%esp),%eax
  80217c:	0f 87 9e 00 00 00    	ja     802220 <__udivdi3+0x108>
  802182:	b8 01 00 00 00       	mov    $0x1,%eax
  802187:	89 fa                	mov    %edi,%edx
  802189:	83 c4 1c             	add    $0x1c,%esp
  80218c:	5b                   	pop    %ebx
  80218d:	5e                   	pop    %esi
  80218e:	5f                   	pop    %edi
  80218f:	5d                   	pop    %ebp
  802190:	c3                   	ret    
  802191:	8d 76 00             	lea    0x0(%esi),%esi
  802194:	31 ff                	xor    %edi,%edi
  802196:	31 c0                	xor    %eax,%eax
  802198:	89 fa                	mov    %edi,%edx
  80219a:	83 c4 1c             	add    $0x1c,%esp
  80219d:	5b                   	pop    %ebx
  80219e:	5e                   	pop    %esi
  80219f:	5f                   	pop    %edi
  8021a0:	5d                   	pop    %ebp
  8021a1:	c3                   	ret    
  8021a2:	66 90                	xchg   %ax,%ax
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	f7 f7                	div    %edi
  8021a8:	31 ff                	xor    %edi,%edi
  8021aa:	89 fa                	mov    %edi,%edx
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
  8021b4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8021b9:	29 fd                	sub    %edi,%ebp
  8021bb:	89 f9                	mov    %edi,%ecx
  8021bd:	d3 e6                	shl    %cl,%esi
  8021bf:	89 c3                	mov    %eax,%ebx
  8021c1:	89 e9                	mov    %ebp,%ecx
  8021c3:	d3 eb                	shr    %cl,%ebx
  8021c5:	89 d9                	mov    %ebx,%ecx
  8021c7:	09 f1                	or     %esi,%ecx
  8021c9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8021cd:	89 f9                	mov    %edi,%ecx
  8021cf:	d3 e0                	shl    %cl,%eax
  8021d1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8021d5:	89 d6                	mov    %edx,%esi
  8021d7:	89 e9                	mov    %ebp,%ecx
  8021d9:	d3 ee                	shr    %cl,%esi
  8021db:	89 f9                	mov    %edi,%ecx
  8021dd:	d3 e2                	shl    %cl,%edx
  8021df:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  8021e3:	89 e9                	mov    %ebp,%ecx
  8021e5:	d3 eb                	shr    %cl,%ebx
  8021e7:	09 da                	or     %ebx,%edx
  8021e9:	89 d0                	mov    %edx,%eax
  8021eb:	89 f2                	mov    %esi,%edx
  8021ed:	f7 74 24 08          	divl   0x8(%esp)
  8021f1:	89 d6                	mov    %edx,%esi
  8021f3:	89 c3                	mov    %eax,%ebx
  8021f5:	f7 64 24 0c          	mull   0xc(%esp)
  8021f9:	39 d6                	cmp    %edx,%esi
  8021fb:	72 17                	jb     802214 <__udivdi3+0xfc>
  8021fd:	74 09                	je     802208 <__udivdi3+0xf0>
  8021ff:	89 d8                	mov    %ebx,%eax
  802201:	31 ff                	xor    %edi,%edi
  802203:	e9 56 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  802208:	8b 54 24 04          	mov    0x4(%esp),%edx
  80220c:	89 f9                	mov    %edi,%ecx
  80220e:	d3 e2                	shl    %cl,%edx
  802210:	39 c2                	cmp    %eax,%edx
  802212:	73 eb                	jae    8021ff <__udivdi3+0xe7>
  802214:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802217:	31 ff                	xor    %edi,%edi
  802219:	e9 40 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  80221e:	66 90                	xchg   %ax,%ax
  802220:	31 c0                	xor    %eax,%eax
  802222:	e9 37 ff ff ff       	jmp    80215e <__udivdi3+0x46>
  802227:	90                   	nop

00802228 <__umoddi3>:
  802228:	55                   	push   %ebp
  802229:	57                   	push   %edi
  80222a:	56                   	push   %esi
  80222b:	53                   	push   %ebx
  80222c:	83 ec 1c             	sub    $0x1c,%esp
  80222f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802233:	8b 74 24 34          	mov    0x34(%esp),%esi
  802237:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80223b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80223f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802243:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802247:	89 3c 24             	mov    %edi,(%esp)
  80224a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80224e:	89 f2                	mov    %esi,%edx
  802250:	85 c0                	test   %eax,%eax
  802252:	75 18                	jne    80226c <__umoddi3+0x44>
  802254:	39 f7                	cmp    %esi,%edi
  802256:	0f 86 a0 00 00 00    	jbe    8022fc <__umoddi3+0xd4>
  80225c:	89 c8                	mov    %ecx,%eax
  80225e:	f7 f7                	div    %edi
  802260:	89 d0                	mov    %edx,%eax
  802262:	31 d2                	xor    %edx,%edx
  802264:	83 c4 1c             	add    $0x1c,%esp
  802267:	5b                   	pop    %ebx
  802268:	5e                   	pop    %esi
  802269:	5f                   	pop    %edi
  80226a:	5d                   	pop    %ebp
  80226b:	c3                   	ret    
  80226c:	89 f3                	mov    %esi,%ebx
  80226e:	39 f0                	cmp    %esi,%eax
  802270:	0f 87 a6 00 00 00    	ja     80231c <__umoddi3+0xf4>
  802276:	0f bd e8             	bsr    %eax,%ebp
  802279:	83 f5 1f             	xor    $0x1f,%ebp
  80227c:	0f 84 a6 00 00 00    	je     802328 <__umoddi3+0x100>
  802282:	bf 20 00 00 00       	mov    $0x20,%edi
  802287:	29 ef                	sub    %ebp,%edi
  802289:	89 e9                	mov    %ebp,%ecx
  80228b:	d3 e0                	shl    %cl,%eax
  80228d:	8b 34 24             	mov    (%esp),%esi
  802290:	89 f2                	mov    %esi,%edx
  802292:	89 f9                	mov    %edi,%ecx
  802294:	d3 ea                	shr    %cl,%edx
  802296:	09 c2                	or     %eax,%edx
  802298:	89 14 24             	mov    %edx,(%esp)
  80229b:	89 f2                	mov    %esi,%edx
  80229d:	89 e9                	mov    %ebp,%ecx
  80229f:	d3 e2                	shl    %cl,%edx
  8022a1:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022a5:	89 de                	mov    %ebx,%esi
  8022a7:	89 f9                	mov    %edi,%ecx
  8022a9:	d3 ee                	shr    %cl,%esi
  8022ab:	89 e9                	mov    %ebp,%ecx
  8022ad:	d3 e3                	shl    %cl,%ebx
  8022af:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022b3:	89 d0                	mov    %edx,%eax
  8022b5:	89 f9                	mov    %edi,%ecx
  8022b7:	d3 e8                	shr    %cl,%eax
  8022b9:	09 d8                	or     %ebx,%eax
  8022bb:	89 d3                	mov    %edx,%ebx
  8022bd:	89 e9                	mov    %ebp,%ecx
  8022bf:	d3 e3                	shl    %cl,%ebx
  8022c1:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8022c5:	89 f2                	mov    %esi,%edx
  8022c7:	f7 34 24             	divl   (%esp)
  8022ca:	89 d6                	mov    %edx,%esi
  8022cc:	f7 64 24 04          	mull   0x4(%esp)
  8022d0:	89 c3                	mov    %eax,%ebx
  8022d2:	89 d1                	mov    %edx,%ecx
  8022d4:	39 d6                	cmp    %edx,%esi
  8022d6:	72 7c                	jb     802354 <__umoddi3+0x12c>
  8022d8:	74 72                	je     80234c <__umoddi3+0x124>
  8022da:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022de:	29 da                	sub    %ebx,%edx
  8022e0:	19 ce                	sbb    %ecx,%esi
  8022e2:	89 f0                	mov    %esi,%eax
  8022e4:	89 f9                	mov    %edi,%ecx
  8022e6:	d3 e0                	shl    %cl,%eax
  8022e8:	89 e9                	mov    %ebp,%ecx
  8022ea:	d3 ea                	shr    %cl,%edx
  8022ec:	09 d0                	or     %edx,%eax
  8022ee:	89 e9                	mov    %ebp,%ecx
  8022f0:	d3 ee                	shr    %cl,%esi
  8022f2:	89 f2                	mov    %esi,%edx
  8022f4:	83 c4 1c             	add    $0x1c,%esp
  8022f7:	5b                   	pop    %ebx
  8022f8:	5e                   	pop    %esi
  8022f9:	5f                   	pop    %edi
  8022fa:	5d                   	pop    %ebp
  8022fb:	c3                   	ret    
  8022fc:	89 fd                	mov    %edi,%ebp
  8022fe:	85 ff                	test   %edi,%edi
  802300:	75 0b                	jne    80230d <__umoddi3+0xe5>
  802302:	b8 01 00 00 00       	mov    $0x1,%eax
  802307:	31 d2                	xor    %edx,%edx
  802309:	f7 f7                	div    %edi
  80230b:	89 c5                	mov    %eax,%ebp
  80230d:	89 f0                	mov    %esi,%eax
  80230f:	31 d2                	xor    %edx,%edx
  802311:	f7 f5                	div    %ebp
  802313:	89 c8                	mov    %ecx,%eax
  802315:	f7 f5                	div    %ebp
  802317:	e9 44 ff ff ff       	jmp    802260 <__umoddi3+0x38>
  80231c:	89 c8                	mov    %ecx,%eax
  80231e:	89 f2                	mov    %esi,%edx
  802320:	83 c4 1c             	add    $0x1c,%esp
  802323:	5b                   	pop    %ebx
  802324:	5e                   	pop    %esi
  802325:	5f                   	pop    %edi
  802326:	5d                   	pop    %ebp
  802327:	c3                   	ret    
  802328:	39 f0                	cmp    %esi,%eax
  80232a:	72 05                	jb     802331 <__umoddi3+0x109>
  80232c:	39 0c 24             	cmp    %ecx,(%esp)
  80232f:	77 0c                	ja     80233d <__umoddi3+0x115>
  802331:	89 f2                	mov    %esi,%edx
  802333:	29 f9                	sub    %edi,%ecx
  802335:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802339:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80233d:	8b 44 24 04          	mov    0x4(%esp),%eax
  802341:	83 c4 1c             	add    $0x1c,%esp
  802344:	5b                   	pop    %ebx
  802345:	5e                   	pop    %esi
  802346:	5f                   	pop    %edi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    
  802349:	8d 76 00             	lea    0x0(%esi),%esi
  80234c:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802350:	73 88                	jae    8022da <__umoddi3+0xb2>
  802352:	66 90                	xchg   %ax,%ax
  802354:	2b 44 24 04          	sub    0x4(%esp),%eax
  802358:	1b 14 24             	sbb    (%esp),%edx
  80235b:	89 d1                	mov    %edx,%ecx
  80235d:	89 c3                	mov    %eax,%ebx
  80235f:	e9 76 ff ff ff       	jmp    8022da <__umoddi3+0xb2>
