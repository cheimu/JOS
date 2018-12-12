
obj/user/testfdsharing.debug:     file format elf32-i386


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
  80002c:	e8 9b 01 00 00       	call   8001cc <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

char buf[512], buf2[512];

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 14             	sub    $0x14,%esp
	int fd, r, n, n2;

	if ((fd = open("motd", O_RDONLY)) < 0)
  80003c:	6a 00                	push   $0x0
  80003e:	68 c0 23 80 00       	push   $0x8023c0
  800043:	e8 89 19 00 00       	call   8019d1 <open>
  800048:	89 c3                	mov    %eax,%ebx
  80004a:	83 c4 10             	add    $0x10,%esp
  80004d:	85 c0                	test   %eax,%eax
  80004f:	0f 88 01 01 00 00    	js     800156 <umain+0x123>
		panic("open motd: %e", fd);
	seek(fd, 0);
  800055:	83 ec 08             	sub    $0x8,%esp
  800058:	6a 00                	push   $0x0
  80005a:	50                   	push   %eax
  80005b:	e8 0f 16 00 00       	call   80166f <seek>
	if ((n = readn(fd, buf, sizeof buf)) <= 0)
  800060:	83 c4 0c             	add    $0xc,%esp
  800063:	68 00 02 00 00       	push   $0x200
  800068:	68 20 42 80 00       	push   $0x804220
  80006d:	53                   	push   %ebx
  80006e:	e8 33 15 00 00       	call   8015a6 <readn>
  800073:	89 c6                	mov    %eax,%esi
  800075:	83 c4 10             	add    $0x10,%esp
  800078:	85 c0                	test   %eax,%eax
  80007a:	0f 8e e8 00 00 00    	jle    800168 <umain+0x135>
		panic("readn: %e", n);

	if ((r = fork()) < 0)
  800080:	e8 f6 0f 00 00       	call   80107b <fork>
  800085:	89 c7                	mov    %eax,%edi
  800087:	85 c0                	test   %eax,%eax
  800089:	0f 88 eb 00 00 00    	js     80017a <umain+0x147>
		panic("fork: %e", r);
	if (r == 0) {
  80008f:	85 c0                	test   %eax,%eax
  800091:	75 7b                	jne    80010e <umain+0xdb>
		seek(fd, 0);
  800093:	83 ec 08             	sub    $0x8,%esp
  800096:	6a 00                	push   $0x0
  800098:	53                   	push   %ebx
  800099:	e8 d1 15 00 00       	call   80166f <seek>
		cprintf("going to read in child (might page fault if your sharing is buggy)\n");
  80009e:	c7 04 24 30 24 80 00 	movl   $0x802430,(%esp)
  8000a5:	e8 9b 02 00 00       	call   800345 <cprintf>
		if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  8000aa:	83 c4 0c             	add    $0xc,%esp
  8000ad:	68 00 02 00 00       	push   $0x200
  8000b2:	68 20 40 80 00       	push   $0x804020
  8000b7:	53                   	push   %ebx
  8000b8:	e8 e9 14 00 00       	call   8015a6 <readn>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	39 c6                	cmp    %eax,%esi
  8000c2:	0f 85 c4 00 00 00    	jne    80018c <umain+0x159>
			panic("read in parent got %d, read in child got %d", n, n2);
		if (memcmp(buf, buf2, n) != 0)
  8000c8:	83 ec 04             	sub    $0x4,%esp
  8000cb:	56                   	push   %esi
  8000cc:	68 20 40 80 00       	push   $0x804020
  8000d1:	68 20 42 80 00       	push   $0x804220
  8000d6:	e8 5e 0a 00 00       	call   800b39 <memcmp>
  8000db:	83 c4 10             	add    $0x10,%esp
  8000de:	85 c0                	test   %eax,%eax
  8000e0:	0f 85 bc 00 00 00    	jne    8001a2 <umain+0x16f>
			panic("read in parent got different bytes from read in child");
		cprintf("read in child succeeded\n");
  8000e6:	83 ec 0c             	sub    $0xc,%esp
  8000e9:	68 fb 23 80 00       	push   $0x8023fb
  8000ee:	e8 52 02 00 00       	call   800345 <cprintf>
		seek(fd, 0);
  8000f3:	83 c4 08             	add    $0x8,%esp
  8000f6:	6a 00                	push   $0x0
  8000f8:	53                   	push   %ebx
  8000f9:	e8 71 15 00 00       	call   80166f <seek>
		close(fd);
  8000fe:	89 1c 24             	mov    %ebx,(%esp)
  800101:	e8 df 12 00 00       	call   8013e5 <close>
		exit();
  800106:	e8 0d 01 00 00       	call   800218 <exit>
  80010b:	83 c4 10             	add    $0x10,%esp
	}
	wait(r);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	57                   	push   %edi
  800112:	e8 a5 1c 00 00       	call   801dbc <wait>
	if ((n2 = readn(fd, buf2, sizeof buf2)) != n)
  800117:	83 c4 0c             	add    $0xc,%esp
  80011a:	68 00 02 00 00       	push   $0x200
  80011f:	68 20 40 80 00       	push   $0x804020
  800124:	53                   	push   %ebx
  800125:	e8 7c 14 00 00       	call   8015a6 <readn>
  80012a:	83 c4 10             	add    $0x10,%esp
  80012d:	39 c6                	cmp    %eax,%esi
  80012f:	0f 85 81 00 00 00    	jne    8001b6 <umain+0x183>
		panic("read in parent got %d, then got %d", n, n2);
	cprintf("read in parent succeeded\n");
  800135:	83 ec 0c             	sub    $0xc,%esp
  800138:	68 14 24 80 00       	push   $0x802414
  80013d:	e8 03 02 00 00       	call   800345 <cprintf>
	close(fd);
  800142:	89 1c 24             	mov    %ebx,(%esp)
  800145:	e8 9b 12 00 00       	call   8013e5 <close>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  80014a:	cc                   	int3   

	breakpoint();
}
  80014b:	83 c4 10             	add    $0x10,%esp
  80014e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800151:	5b                   	pop    %ebx
  800152:	5e                   	pop    %esi
  800153:	5f                   	pop    %edi
  800154:	5d                   	pop    %ebp
  800155:	c3                   	ret    
		panic("open motd: %e", fd);
  800156:	50                   	push   %eax
  800157:	68 c5 23 80 00       	push   $0x8023c5
  80015c:	6a 0c                	push   $0xc
  80015e:	68 d3 23 80 00       	push   $0x8023d3
  800163:	e8 ca 00 00 00       	call   800232 <_panic>
		panic("readn: %e", n);
  800168:	50                   	push   %eax
  800169:	68 e8 23 80 00       	push   $0x8023e8
  80016e:	6a 0f                	push   $0xf
  800170:	68 d3 23 80 00       	push   $0x8023d3
  800175:	e8 b8 00 00 00       	call   800232 <_panic>
		panic("fork: %e", r);
  80017a:	50                   	push   %eax
  80017b:	68 f2 23 80 00       	push   $0x8023f2
  800180:	6a 12                	push   $0x12
  800182:	68 d3 23 80 00       	push   $0x8023d3
  800187:	e8 a6 00 00 00       	call   800232 <_panic>
			panic("read in parent got %d, read in child got %d", n, n2);
  80018c:	83 ec 0c             	sub    $0xc,%esp
  80018f:	50                   	push   %eax
  800190:	56                   	push   %esi
  800191:	68 74 24 80 00       	push   $0x802474
  800196:	6a 17                	push   $0x17
  800198:	68 d3 23 80 00       	push   $0x8023d3
  80019d:	e8 90 00 00 00       	call   800232 <_panic>
			panic("read in parent got different bytes from read in child");
  8001a2:	83 ec 04             	sub    $0x4,%esp
  8001a5:	68 a0 24 80 00       	push   $0x8024a0
  8001aa:	6a 19                	push   $0x19
  8001ac:	68 d3 23 80 00       	push   $0x8023d3
  8001b1:	e8 7c 00 00 00       	call   800232 <_panic>
		panic("read in parent got %d, then got %d", n, n2);
  8001b6:	83 ec 0c             	sub    $0xc,%esp
  8001b9:	50                   	push   %eax
  8001ba:	56                   	push   %esi
  8001bb:	68 d8 24 80 00       	push   $0x8024d8
  8001c0:	6a 21                	push   $0x21
  8001c2:	68 d3 23 80 00       	push   $0x8023d3
  8001c7:	e8 66 00 00 00       	call   800232 <_panic>

008001cc <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8001cc:	55                   	push   %ebp
  8001cd:	89 e5                	mov    %esp,%ebp
  8001cf:	56                   	push   %esi
  8001d0:	53                   	push   %ebx
  8001d1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8001d4:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8001d7:	e8 07 0b 00 00       	call   800ce3 <sys_getenvid>
  8001dc:	25 ff 03 00 00       	and    $0x3ff,%eax
  8001e1:	89 c2                	mov    %eax,%edx
  8001e3:	c1 e2 05             	shl    $0x5,%edx
  8001e6:	29 c2                	sub    %eax,%edx
  8001e8:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8001ef:	a3 20 44 80 00       	mov    %eax,0x804420

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001f4:	85 db                	test   %ebx,%ebx
  8001f6:	7e 07                	jle    8001ff <libmain+0x33>
		binaryname = argv[0];
  8001f8:	8b 06                	mov    (%esi),%eax
  8001fa:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8001ff:	83 ec 08             	sub    $0x8,%esp
  800202:	56                   	push   %esi
  800203:	53                   	push   %ebx
  800204:	e8 2a fe ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800209:	e8 0a 00 00 00       	call   800218 <exit>
}
  80020e:	83 c4 10             	add    $0x10,%esp
  800211:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800214:	5b                   	pop    %ebx
  800215:	5e                   	pop    %esi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    

00800218 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800218:	55                   	push   %ebp
  800219:	89 e5                	mov    %esp,%ebp
  80021b:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80021e:	e8 ed 11 00 00       	call   801410 <close_all>
	sys_env_destroy(0);
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	6a 00                	push   $0x0
  800228:	e8 75 0a 00 00       	call   800ca2 <sys_env_destroy>
}
  80022d:	83 c4 10             	add    $0x10,%esp
  800230:	c9                   	leave  
  800231:	c3                   	ret    

00800232 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800232:	55                   	push   %ebp
  800233:	89 e5                	mov    %esp,%ebp
  800235:	57                   	push   %edi
  800236:	56                   	push   %esi
  800237:	53                   	push   %ebx
  800238:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80023e:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800241:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  800247:	e8 97 0a 00 00       	call   800ce3 <sys_getenvid>
  80024c:	83 ec 04             	sub    $0x4,%esp
  80024f:	ff 75 0c             	pushl  0xc(%ebp)
  800252:	ff 75 08             	pushl  0x8(%ebp)
  800255:	53                   	push   %ebx
  800256:	50                   	push   %eax
  800257:	68 08 25 80 00       	push   $0x802508
  80025c:	68 00 01 00 00       	push   $0x100
  800261:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800267:	56                   	push   %esi
  800268:	e8 93 06 00 00       	call   800900 <snprintf>
  80026d:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80026f:	83 c4 20             	add    $0x20,%esp
  800272:	57                   	push   %edi
  800273:	ff 75 10             	pushl  0x10(%ebp)
  800276:	bf 00 01 00 00       	mov    $0x100,%edi
  80027b:	89 f8                	mov    %edi,%eax
  80027d:	29 d8                	sub    %ebx,%eax
  80027f:	50                   	push   %eax
  800280:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800283:	50                   	push   %eax
  800284:	e8 22 06 00 00       	call   8008ab <vsnprintf>
  800289:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80028b:	83 c4 0c             	add    $0xc,%esp
  80028e:	68 12 24 80 00       	push   $0x802412
  800293:	29 df                	sub    %ebx,%edi
  800295:	57                   	push   %edi
  800296:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800299:	50                   	push   %eax
  80029a:	e8 61 06 00 00       	call   800900 <snprintf>
	sys_cputs(buf, r);
  80029f:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8002a2:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8002a4:	53                   	push   %ebx
  8002a5:	56                   	push   %esi
  8002a6:	e8 ba 09 00 00       	call   800c65 <sys_cputs>
  8002ab:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002ae:	cc                   	int3   
  8002af:	eb fd                	jmp    8002ae <_panic+0x7c>

008002b1 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002b1:	55                   	push   %ebp
  8002b2:	89 e5                	mov    %esp,%ebp
  8002b4:	53                   	push   %ebx
  8002b5:	83 ec 04             	sub    $0x4,%esp
  8002b8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8002bb:	8b 13                	mov    (%ebx),%edx
  8002bd:	8d 42 01             	lea    0x1(%edx),%eax
  8002c0:	89 03                	mov    %eax,(%ebx)
  8002c2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8002c5:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8002c9:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002ce:	74 08                	je     8002d8 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8002d0:	ff 43 04             	incl   0x4(%ebx)
}
  8002d3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8002d6:	c9                   	leave  
  8002d7:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	68 ff 00 00 00       	push   $0xff
  8002e0:	8d 43 08             	lea    0x8(%ebx),%eax
  8002e3:	50                   	push   %eax
  8002e4:	e8 7c 09 00 00       	call   800c65 <sys_cputs>
		b->idx = 0;
  8002e9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8002ef:	83 c4 10             	add    $0x10,%esp
  8002f2:	eb dc                	jmp    8002d0 <putch+0x1f>

008002f4 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8002fd:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800304:	00 00 00 
	b.cnt = 0;
  800307:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80030e:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800311:	ff 75 0c             	pushl  0xc(%ebp)
  800314:	ff 75 08             	pushl  0x8(%ebp)
  800317:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80031d:	50                   	push   %eax
  80031e:	68 b1 02 80 00       	push   $0x8002b1
  800323:	e8 17 01 00 00       	call   80043f <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800328:	83 c4 08             	add    $0x8,%esp
  80032b:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800331:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800337:	50                   	push   %eax
  800338:	e8 28 09 00 00       	call   800c65 <sys_cputs>

	return b.cnt;
}
  80033d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800343:	c9                   	leave  
  800344:	c3                   	ret    

00800345 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800345:	55                   	push   %ebp
  800346:	89 e5                	mov    %esp,%ebp
  800348:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80034b:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80034e:	50                   	push   %eax
  80034f:	ff 75 08             	pushl  0x8(%ebp)
  800352:	e8 9d ff ff ff       	call   8002f4 <vcprintf>
	va_end(ap);

	return cnt;
}
  800357:	c9                   	leave  
  800358:	c3                   	ret    

00800359 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800359:	55                   	push   %ebp
  80035a:	89 e5                	mov    %esp,%ebp
  80035c:	57                   	push   %edi
  80035d:	56                   	push   %esi
  80035e:	53                   	push   %ebx
  80035f:	83 ec 1c             	sub    $0x1c,%esp
  800362:	89 c7                	mov    %eax,%edi
  800364:	89 d6                	mov    %edx,%esi
  800366:	8b 45 08             	mov    0x8(%ebp),%eax
  800369:	8b 55 0c             	mov    0xc(%ebp),%edx
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80036f:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800372:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800375:	bb 00 00 00 00       	mov    $0x0,%ebx
  80037a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80037d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800380:	39 d3                	cmp    %edx,%ebx
  800382:	72 05                	jb     800389 <printnum+0x30>
  800384:	39 45 10             	cmp    %eax,0x10(%ebp)
  800387:	77 78                	ja     800401 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800389:	83 ec 0c             	sub    $0xc,%esp
  80038c:	ff 75 18             	pushl  0x18(%ebp)
  80038f:	8b 45 14             	mov    0x14(%ebp),%eax
  800392:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800395:	53                   	push   %ebx
  800396:	ff 75 10             	pushl  0x10(%ebp)
  800399:	83 ec 08             	sub    $0x8,%esp
  80039c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80039f:	ff 75 e0             	pushl  -0x20(%ebp)
  8003a2:	ff 75 dc             	pushl  -0x24(%ebp)
  8003a5:	ff 75 d8             	pushl  -0x28(%ebp)
  8003a8:	e8 c7 1d 00 00       	call   802174 <__udivdi3>
  8003ad:	83 c4 18             	add    $0x18,%esp
  8003b0:	52                   	push   %edx
  8003b1:	50                   	push   %eax
  8003b2:	89 f2                	mov    %esi,%edx
  8003b4:	89 f8                	mov    %edi,%eax
  8003b6:	e8 9e ff ff ff       	call   800359 <printnum>
  8003bb:	83 c4 20             	add    $0x20,%esp
  8003be:	eb 11                	jmp    8003d1 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8003c0:	83 ec 08             	sub    $0x8,%esp
  8003c3:	56                   	push   %esi
  8003c4:	ff 75 18             	pushl  0x18(%ebp)
  8003c7:	ff d7                	call   *%edi
  8003c9:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8003cc:	4b                   	dec    %ebx
  8003cd:	85 db                	test   %ebx,%ebx
  8003cf:	7f ef                	jg     8003c0 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8003d1:	83 ec 08             	sub    $0x8,%esp
  8003d4:	56                   	push   %esi
  8003d5:	83 ec 04             	sub    $0x4,%esp
  8003d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003db:	ff 75 e0             	pushl  -0x20(%ebp)
  8003de:	ff 75 dc             	pushl  -0x24(%ebp)
  8003e1:	ff 75 d8             	pushl  -0x28(%ebp)
  8003e4:	e8 9b 1e 00 00       	call   802284 <__umoddi3>
  8003e9:	83 c4 14             	add    $0x14,%esp
  8003ec:	0f be 80 2b 25 80 00 	movsbl 0x80252b(%eax),%eax
  8003f3:	50                   	push   %eax
  8003f4:	ff d7                	call   *%edi
}
  8003f6:	83 c4 10             	add    $0x10,%esp
  8003f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003fc:	5b                   	pop    %ebx
  8003fd:	5e                   	pop    %esi
  8003fe:	5f                   	pop    %edi
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    
  800401:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800404:	eb c6                	jmp    8003cc <printnum+0x73>

00800406 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800406:	55                   	push   %ebp
  800407:	89 e5                	mov    %esp,%ebp
  800409:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  80040c:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80040f:	8b 10                	mov    (%eax),%edx
  800411:	3b 50 04             	cmp    0x4(%eax),%edx
  800414:	73 0a                	jae    800420 <sprintputch+0x1a>
		*b->buf++ = ch;
  800416:	8d 4a 01             	lea    0x1(%edx),%ecx
  800419:	89 08                	mov    %ecx,(%eax)
  80041b:	8b 45 08             	mov    0x8(%ebp),%eax
  80041e:	88 02                	mov    %al,(%edx)
}
  800420:	5d                   	pop    %ebp
  800421:	c3                   	ret    

00800422 <printfmt>:
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800428:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  80042b:	50                   	push   %eax
  80042c:	ff 75 10             	pushl  0x10(%ebp)
  80042f:	ff 75 0c             	pushl  0xc(%ebp)
  800432:	ff 75 08             	pushl  0x8(%ebp)
  800435:	e8 05 00 00 00       	call   80043f <vprintfmt>
}
  80043a:	83 c4 10             	add    $0x10,%esp
  80043d:	c9                   	leave  
  80043e:	c3                   	ret    

0080043f <vprintfmt>:
{
  80043f:	55                   	push   %ebp
  800440:	89 e5                	mov    %esp,%ebp
  800442:	57                   	push   %edi
  800443:	56                   	push   %esi
  800444:	53                   	push   %ebx
  800445:	83 ec 2c             	sub    $0x2c,%esp
  800448:	8b 75 08             	mov    0x8(%ebp),%esi
  80044b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80044e:	8b 7d 10             	mov    0x10(%ebp),%edi
  800451:	e9 ae 03 00 00       	jmp    800804 <vprintfmt+0x3c5>
  800456:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80045a:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800461:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800468:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80046f:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800474:	8d 47 01             	lea    0x1(%edi),%eax
  800477:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80047a:	8a 17                	mov    (%edi),%dl
  80047c:	8d 42 dd             	lea    -0x23(%edx),%eax
  80047f:	3c 55                	cmp    $0x55,%al
  800481:	0f 87 fe 03 00 00    	ja     800885 <vprintfmt+0x446>
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	ff 24 85 60 26 80 00 	jmp    *0x802660(,%eax,4)
  800491:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800494:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800498:	eb da                	jmp    800474 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80049a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  80049d:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004a1:	eb d1                	jmp    800474 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004a3:	0f b6 d2             	movzbl %dl,%edx
  8004a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8004ae:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004b1:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004b4:	01 c0                	add    %eax,%eax
  8004b6:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8004ba:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8004bd:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8004c0:	83 f9 09             	cmp    $0x9,%ecx
  8004c3:	77 52                	ja     800517 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8004c5:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8004c6:	eb e9                	jmp    8004b1 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8004c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8004d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8004d3:	8d 40 04             	lea    0x4(%eax),%eax
  8004d6:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8004d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8004dc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004e0:	79 92                	jns    800474 <vprintfmt+0x35>
				width = precision, precision = -1;
  8004e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8004e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8004e8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ef:	eb 83                	jmp    800474 <vprintfmt+0x35>
  8004f1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8004f5:	78 08                	js     8004ff <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8004f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004fa:	e9 75 ff ff ff       	jmp    800474 <vprintfmt+0x35>
  8004ff:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800506:	eb ef                	jmp    8004f7 <vprintfmt+0xb8>
  800508:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  80050b:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800512:	e9 5d ff ff ff       	jmp    800474 <vprintfmt+0x35>
  800517:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  80051a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80051d:	eb bd                	jmp    8004dc <vprintfmt+0x9d>
			lflag++;
  80051f:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800520:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800523:	e9 4c ff ff ff       	jmp    800474 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800528:	8b 45 14             	mov    0x14(%ebp),%eax
  80052b:	8d 78 04             	lea    0x4(%eax),%edi
  80052e:	83 ec 08             	sub    $0x8,%esp
  800531:	53                   	push   %ebx
  800532:	ff 30                	pushl  (%eax)
  800534:	ff d6                	call   *%esi
			break;
  800536:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800539:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80053c:	e9 c0 02 00 00       	jmp    800801 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800541:	8b 45 14             	mov    0x14(%ebp),%eax
  800544:	8d 78 04             	lea    0x4(%eax),%edi
  800547:	8b 00                	mov    (%eax),%eax
  800549:	85 c0                	test   %eax,%eax
  80054b:	78 2a                	js     800577 <vprintfmt+0x138>
  80054d:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80054f:	83 f8 0f             	cmp    $0xf,%eax
  800552:	7f 27                	jg     80057b <vprintfmt+0x13c>
  800554:	8b 04 85 c0 27 80 00 	mov    0x8027c0(,%eax,4),%eax
  80055b:	85 c0                	test   %eax,%eax
  80055d:	74 1c                	je     80057b <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80055f:	50                   	push   %eax
  800560:	68 e8 28 80 00       	push   $0x8028e8
  800565:	53                   	push   %ebx
  800566:	56                   	push   %esi
  800567:	e8 b6 fe ff ff       	call   800422 <printfmt>
  80056c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80056f:	89 7d 14             	mov    %edi,0x14(%ebp)
  800572:	e9 8a 02 00 00       	jmp    800801 <vprintfmt+0x3c2>
  800577:	f7 d8                	neg    %eax
  800579:	eb d2                	jmp    80054d <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80057b:	52                   	push   %edx
  80057c:	68 43 25 80 00       	push   $0x802543
  800581:	53                   	push   %ebx
  800582:	56                   	push   %esi
  800583:	e8 9a fe ff ff       	call   800422 <printfmt>
  800588:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80058b:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  80058e:	e9 6e 02 00 00       	jmp    800801 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800593:	8b 45 14             	mov    0x14(%ebp),%eax
  800596:	83 c0 04             	add    $0x4,%eax
  800599:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80059c:	8b 45 14             	mov    0x14(%ebp),%eax
  80059f:	8b 38                	mov    (%eax),%edi
  8005a1:	85 ff                	test   %edi,%edi
  8005a3:	74 39                	je     8005de <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8005a5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005a9:	0f 8e a9 00 00 00    	jle    800658 <vprintfmt+0x219>
  8005af:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005b3:	0f 84 a7 00 00 00    	je     800660 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005b9:	83 ec 08             	sub    $0x8,%esp
  8005bc:	ff 75 d0             	pushl  -0x30(%ebp)
  8005bf:	57                   	push   %edi
  8005c0:	e8 6b 03 00 00       	call   800930 <strnlen>
  8005c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8005c8:	29 c1                	sub    %eax,%ecx
  8005ca:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8005cd:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8005d0:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8005d4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8005d7:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8005da:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005dc:	eb 14                	jmp    8005f2 <vprintfmt+0x1b3>
				p = "(null)";
  8005de:	bf 3c 25 80 00       	mov    $0x80253c,%edi
  8005e3:	eb c0                	jmp    8005a5 <vprintfmt+0x166>
					putch(padc, putdat);
  8005e5:	83 ec 08             	sub    $0x8,%esp
  8005e8:	53                   	push   %ebx
  8005e9:	ff 75 e0             	pushl  -0x20(%ebp)
  8005ec:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ee:	4f                   	dec    %edi
  8005ef:	83 c4 10             	add    $0x10,%esp
  8005f2:	85 ff                	test   %edi,%edi
  8005f4:	7f ef                	jg     8005e5 <vprintfmt+0x1a6>
  8005f6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8005f9:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8005fc:	89 c8                	mov    %ecx,%eax
  8005fe:	85 c9                	test   %ecx,%ecx
  800600:	78 10                	js     800612 <vprintfmt+0x1d3>
  800602:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800605:	29 c1                	sub    %eax,%ecx
  800607:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  80060a:	89 75 08             	mov    %esi,0x8(%ebp)
  80060d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800610:	eb 15                	jmp    800627 <vprintfmt+0x1e8>
  800612:	b8 00 00 00 00       	mov    $0x0,%eax
  800617:	eb e9                	jmp    800602 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800619:	83 ec 08             	sub    $0x8,%esp
  80061c:	53                   	push   %ebx
  80061d:	52                   	push   %edx
  80061e:	ff 55 08             	call   *0x8(%ebp)
  800621:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800624:	ff 4d e0             	decl   -0x20(%ebp)
  800627:	47                   	inc    %edi
  800628:	8a 47 ff             	mov    -0x1(%edi),%al
  80062b:	0f be d0             	movsbl %al,%edx
  80062e:	85 d2                	test   %edx,%edx
  800630:	74 59                	je     80068b <vprintfmt+0x24c>
  800632:	85 f6                	test   %esi,%esi
  800634:	78 03                	js     800639 <vprintfmt+0x1fa>
  800636:	4e                   	dec    %esi
  800637:	78 2f                	js     800668 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800639:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80063d:	74 da                	je     800619 <vprintfmt+0x1da>
  80063f:	0f be c0             	movsbl %al,%eax
  800642:	83 e8 20             	sub    $0x20,%eax
  800645:	83 f8 5e             	cmp    $0x5e,%eax
  800648:	76 cf                	jbe    800619 <vprintfmt+0x1da>
					putch('?', putdat);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	53                   	push   %ebx
  80064e:	6a 3f                	push   $0x3f
  800650:	ff 55 08             	call   *0x8(%ebp)
  800653:	83 c4 10             	add    $0x10,%esp
  800656:	eb cc                	jmp    800624 <vprintfmt+0x1e5>
  800658:	89 75 08             	mov    %esi,0x8(%ebp)
  80065b:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80065e:	eb c7                	jmp    800627 <vprintfmt+0x1e8>
  800660:	89 75 08             	mov    %esi,0x8(%ebp)
  800663:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800666:	eb bf                	jmp    800627 <vprintfmt+0x1e8>
  800668:	8b 75 08             	mov    0x8(%ebp),%esi
  80066b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80066e:	eb 0c                	jmp    80067c <vprintfmt+0x23d>
				putch(' ', putdat);
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	53                   	push   %ebx
  800674:	6a 20                	push   $0x20
  800676:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800678:	4f                   	dec    %edi
  800679:	83 c4 10             	add    $0x10,%esp
  80067c:	85 ff                	test   %edi,%edi
  80067e:	7f f0                	jg     800670 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800680:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800683:	89 45 14             	mov    %eax,0x14(%ebp)
  800686:	e9 76 01 00 00       	jmp    800801 <vprintfmt+0x3c2>
  80068b:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80068e:	8b 75 08             	mov    0x8(%ebp),%esi
  800691:	eb e9                	jmp    80067c <vprintfmt+0x23d>
	if (lflag >= 2)
  800693:	83 f9 01             	cmp    $0x1,%ecx
  800696:	7f 1f                	jg     8006b7 <vprintfmt+0x278>
	else if (lflag)
  800698:	85 c9                	test   %ecx,%ecx
  80069a:	75 48                	jne    8006e4 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80069c:	8b 45 14             	mov    0x14(%ebp),%eax
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006a4:	89 c1                	mov    %eax,%ecx
  8006a6:	c1 f9 1f             	sar    $0x1f,%ecx
  8006a9:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006ac:	8b 45 14             	mov    0x14(%ebp),%eax
  8006af:	8d 40 04             	lea    0x4(%eax),%eax
  8006b2:	89 45 14             	mov    %eax,0x14(%ebp)
  8006b5:	eb 17                	jmp    8006ce <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ba:	8b 50 04             	mov    0x4(%eax),%edx
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006c2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8006c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c8:	8d 40 08             	lea    0x8(%eax),%eax
  8006cb:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8006ce:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8006d1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8006d4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8006d8:	78 25                	js     8006ff <vprintfmt+0x2c0>
			base = 10;
  8006da:	b8 0a 00 00 00       	mov    $0xa,%eax
  8006df:	e9 03 01 00 00       	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8006e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e7:	8b 00                	mov    (%eax),%eax
  8006e9:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ec:	89 c1                	mov    %eax,%ecx
  8006ee:	c1 f9 1f             	sar    $0x1f,%ecx
  8006f1:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f7:	8d 40 04             	lea    0x4(%eax),%eax
  8006fa:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fd:	eb cf                	jmp    8006ce <vprintfmt+0x28f>
				putch('-', putdat);
  8006ff:	83 ec 08             	sub    $0x8,%esp
  800702:	53                   	push   %ebx
  800703:	6a 2d                	push   $0x2d
  800705:	ff d6                	call   *%esi
				num = -(long long) num;
  800707:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80070a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  80070d:	f7 da                	neg    %edx
  80070f:	83 d1 00             	adc    $0x0,%ecx
  800712:	f7 d9                	neg    %ecx
  800714:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800717:	b8 0a 00 00 00       	mov    $0xa,%eax
  80071c:	e9 c6 00 00 00       	jmp    8007e7 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800721:	83 f9 01             	cmp    $0x1,%ecx
  800724:	7f 1e                	jg     800744 <vprintfmt+0x305>
	else if (lflag)
  800726:	85 c9                	test   %ecx,%ecx
  800728:	75 32                	jne    80075c <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 10                	mov    (%eax),%edx
  80072f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800734:	8d 40 04             	lea    0x4(%eax),%eax
  800737:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80073a:	b8 0a 00 00 00       	mov    $0xa,%eax
  80073f:	e9 a3 00 00 00       	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8b 10                	mov    (%eax),%edx
  800749:	8b 48 04             	mov    0x4(%eax),%ecx
  80074c:	8d 40 08             	lea    0x8(%eax),%eax
  80074f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800752:	b8 0a 00 00 00       	mov    $0xa,%eax
  800757:	e9 8b 00 00 00       	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80075c:	8b 45 14             	mov    0x14(%ebp),%eax
  80075f:	8b 10                	mov    (%eax),%edx
  800761:	b9 00 00 00 00       	mov    $0x0,%ecx
  800766:	8d 40 04             	lea    0x4(%eax),%eax
  800769:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80076c:	b8 0a 00 00 00       	mov    $0xa,%eax
  800771:	eb 74                	jmp    8007e7 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800773:	83 f9 01             	cmp    $0x1,%ecx
  800776:	7f 1b                	jg     800793 <vprintfmt+0x354>
	else if (lflag)
  800778:	85 c9                	test   %ecx,%ecx
  80077a:	75 2c                	jne    8007a8 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80077c:	8b 45 14             	mov    0x14(%ebp),%eax
  80077f:	8b 10                	mov    (%eax),%edx
  800781:	b9 00 00 00 00       	mov    $0x0,%ecx
  800786:	8d 40 04             	lea    0x4(%eax),%eax
  800789:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80078c:	b8 08 00 00 00       	mov    $0x8,%eax
  800791:	eb 54                	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800793:	8b 45 14             	mov    0x14(%ebp),%eax
  800796:	8b 10                	mov    (%eax),%edx
  800798:	8b 48 04             	mov    0x4(%eax),%ecx
  80079b:	8d 40 08             	lea    0x8(%eax),%eax
  80079e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007a1:	b8 08 00 00 00       	mov    $0x8,%eax
  8007a6:	eb 3f                	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007a8:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ab:	8b 10                	mov    (%eax),%edx
  8007ad:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007b2:	8d 40 04             	lea    0x4(%eax),%eax
  8007b5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007b8:	b8 08 00 00 00       	mov    $0x8,%eax
  8007bd:	eb 28                	jmp    8007e7 <vprintfmt+0x3a8>
			putch('0', putdat);
  8007bf:	83 ec 08             	sub    $0x8,%esp
  8007c2:	53                   	push   %ebx
  8007c3:	6a 30                	push   $0x30
  8007c5:	ff d6                	call   *%esi
			putch('x', putdat);
  8007c7:	83 c4 08             	add    $0x8,%esp
  8007ca:	53                   	push   %ebx
  8007cb:	6a 78                	push   $0x78
  8007cd:	ff d6                	call   *%esi
			num = (unsigned long long)
  8007cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d2:	8b 10                	mov    (%eax),%edx
  8007d4:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8007d9:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8007dc:	8d 40 04             	lea    0x4(%eax),%eax
  8007df:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8007e2:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8007e7:	83 ec 0c             	sub    $0xc,%esp
  8007ea:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8007ee:	57                   	push   %edi
  8007ef:	ff 75 e0             	pushl  -0x20(%ebp)
  8007f2:	50                   	push   %eax
  8007f3:	51                   	push   %ecx
  8007f4:	52                   	push   %edx
  8007f5:	89 da                	mov    %ebx,%edx
  8007f7:	89 f0                	mov    %esi,%eax
  8007f9:	e8 5b fb ff ff       	call   800359 <printnum>
			break;
  8007fe:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800801:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800804:	47                   	inc    %edi
  800805:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800809:	83 f8 25             	cmp    $0x25,%eax
  80080c:	0f 84 44 fc ff ff    	je     800456 <vprintfmt+0x17>
			if (ch == '\0')
  800812:	85 c0                	test   %eax,%eax
  800814:	0f 84 89 00 00 00    	je     8008a3 <vprintfmt+0x464>
			putch(ch, putdat);
  80081a:	83 ec 08             	sub    $0x8,%esp
  80081d:	53                   	push   %ebx
  80081e:	50                   	push   %eax
  80081f:	ff d6                	call   *%esi
  800821:	83 c4 10             	add    $0x10,%esp
  800824:	eb de                	jmp    800804 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800826:	83 f9 01             	cmp    $0x1,%ecx
  800829:	7f 1b                	jg     800846 <vprintfmt+0x407>
	else if (lflag)
  80082b:	85 c9                	test   %ecx,%ecx
  80082d:	75 2c                	jne    80085b <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80082f:	8b 45 14             	mov    0x14(%ebp),%eax
  800832:	8b 10                	mov    (%eax),%edx
  800834:	b9 00 00 00 00       	mov    $0x0,%ecx
  800839:	8d 40 04             	lea    0x4(%eax),%eax
  80083c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80083f:	b8 10 00 00 00       	mov    $0x10,%eax
  800844:	eb a1                	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800846:	8b 45 14             	mov    0x14(%ebp),%eax
  800849:	8b 10                	mov    (%eax),%edx
  80084b:	8b 48 04             	mov    0x4(%eax),%ecx
  80084e:	8d 40 08             	lea    0x8(%eax),%eax
  800851:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800854:	b8 10 00 00 00       	mov    $0x10,%eax
  800859:	eb 8c                	jmp    8007e7 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	8b 10                	mov    (%eax),%edx
  800860:	b9 00 00 00 00       	mov    $0x0,%ecx
  800865:	8d 40 04             	lea    0x4(%eax),%eax
  800868:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80086b:	b8 10 00 00 00       	mov    $0x10,%eax
  800870:	e9 72 ff ff ff       	jmp    8007e7 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800875:	83 ec 08             	sub    $0x8,%esp
  800878:	53                   	push   %ebx
  800879:	6a 25                	push   $0x25
  80087b:	ff d6                	call   *%esi
			break;
  80087d:	83 c4 10             	add    $0x10,%esp
  800880:	e9 7c ff ff ff       	jmp    800801 <vprintfmt+0x3c2>
			putch('%', putdat);
  800885:	83 ec 08             	sub    $0x8,%esp
  800888:	53                   	push   %ebx
  800889:	6a 25                	push   $0x25
  80088b:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  80088d:	83 c4 10             	add    $0x10,%esp
  800890:	89 f8                	mov    %edi,%eax
  800892:	eb 01                	jmp    800895 <vprintfmt+0x456>
  800894:	48                   	dec    %eax
  800895:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800899:	75 f9                	jne    800894 <vprintfmt+0x455>
  80089b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089e:	e9 5e ff ff ff       	jmp    800801 <vprintfmt+0x3c2>
}
  8008a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008a6:	5b                   	pop    %ebx
  8008a7:	5e                   	pop    %esi
  8008a8:	5f                   	pop    %edi
  8008a9:	5d                   	pop    %ebp
  8008aa:	c3                   	ret    

008008ab <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008ab:	55                   	push   %ebp
  8008ac:	89 e5                	mov    %esp,%ebp
  8008ae:	83 ec 18             	sub    $0x18,%esp
  8008b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b4:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008b7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8008ba:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8008be:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8008c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8008c8:	85 c0                	test   %eax,%eax
  8008ca:	74 26                	je     8008f2 <vsnprintf+0x47>
  8008cc:	85 d2                	test   %edx,%edx
  8008ce:	7e 29                	jle    8008f9 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8008d0:	ff 75 14             	pushl  0x14(%ebp)
  8008d3:	ff 75 10             	pushl  0x10(%ebp)
  8008d6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8008d9:	50                   	push   %eax
  8008da:	68 06 04 80 00       	push   $0x800406
  8008df:	e8 5b fb ff ff       	call   80043f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8008e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008e7:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8008ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ed:	83 c4 10             	add    $0x10,%esp
}
  8008f0:	c9                   	leave  
  8008f1:	c3                   	ret    
		return -E_INVAL;
  8008f2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008f7:	eb f7                	jmp    8008f0 <vsnprintf+0x45>
  8008f9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008fe:	eb f0                	jmp    8008f0 <vsnprintf+0x45>

00800900 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800900:	55                   	push   %ebp
  800901:	89 e5                	mov    %esp,%ebp
  800903:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800906:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800909:	50                   	push   %eax
  80090a:	ff 75 10             	pushl  0x10(%ebp)
  80090d:	ff 75 0c             	pushl  0xc(%ebp)
  800910:	ff 75 08             	pushl  0x8(%ebp)
  800913:	e8 93 ff ff ff       	call   8008ab <vsnprintf>
	va_end(ap);

	return rc;
}
  800918:	c9                   	leave  
  800919:	c3                   	ret    

0080091a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80091a:	55                   	push   %ebp
  80091b:	89 e5                	mov    %esp,%ebp
  80091d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800920:	b8 00 00 00 00       	mov    $0x0,%eax
  800925:	eb 01                	jmp    800928 <strlen+0xe>
		n++;
  800927:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800928:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80092c:	75 f9                	jne    800927 <strlen+0xd>
	return n;
}
  80092e:	5d                   	pop    %ebp
  80092f:	c3                   	ret    

00800930 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800930:	55                   	push   %ebp
  800931:	89 e5                	mov    %esp,%ebp
  800933:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800936:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800939:	b8 00 00 00 00       	mov    $0x0,%eax
  80093e:	eb 01                	jmp    800941 <strnlen+0x11>
		n++;
  800940:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800941:	39 d0                	cmp    %edx,%eax
  800943:	74 06                	je     80094b <strnlen+0x1b>
  800945:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800949:	75 f5                	jne    800940 <strnlen+0x10>
	return n;
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	53                   	push   %ebx
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800957:	89 c2                	mov    %eax,%edx
  800959:	42                   	inc    %edx
  80095a:	41                   	inc    %ecx
  80095b:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80095e:	88 5a ff             	mov    %bl,-0x1(%edx)
  800961:	84 db                	test   %bl,%bl
  800963:	75 f4                	jne    800959 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800965:	5b                   	pop    %ebx
  800966:	5d                   	pop    %ebp
  800967:	c3                   	ret    

00800968 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800968:	55                   	push   %ebp
  800969:	89 e5                	mov    %esp,%ebp
  80096b:	53                   	push   %ebx
  80096c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80096f:	53                   	push   %ebx
  800970:	e8 a5 ff ff ff       	call   80091a <strlen>
  800975:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800978:	ff 75 0c             	pushl  0xc(%ebp)
  80097b:	01 d8                	add    %ebx,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 ca ff ff ff       	call   80094d <strcpy>
	return dst;
}
  800983:	89 d8                	mov    %ebx,%eax
  800985:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800988:	c9                   	leave  
  800989:	c3                   	ret    

0080098a <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80098a:	55                   	push   %ebp
  80098b:	89 e5                	mov    %esp,%ebp
  80098d:	56                   	push   %esi
  80098e:	53                   	push   %ebx
  80098f:	8b 75 08             	mov    0x8(%ebp),%esi
  800992:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800995:	89 f3                	mov    %esi,%ebx
  800997:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80099a:	89 f2                	mov    %esi,%edx
  80099c:	eb 0c                	jmp    8009aa <strncpy+0x20>
		*dst++ = *src;
  80099e:	42                   	inc    %edx
  80099f:	8a 01                	mov    (%ecx),%al
  8009a1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009a4:	80 39 01             	cmpb   $0x1,(%ecx)
  8009a7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009aa:	39 da                	cmp    %ebx,%edx
  8009ac:	75 f0                	jne    80099e <strncpy+0x14>
	}
	return ret;
}
  8009ae:	89 f0                	mov    %esi,%eax
  8009b0:	5b                   	pop    %ebx
  8009b1:	5e                   	pop    %esi
  8009b2:	5d                   	pop    %ebp
  8009b3:	c3                   	ret    

008009b4 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009b4:	55                   	push   %ebp
  8009b5:	89 e5                	mov    %esp,%ebp
  8009b7:	56                   	push   %esi
  8009b8:	53                   	push   %ebx
  8009b9:	8b 75 08             	mov    0x8(%ebp),%esi
  8009bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009bf:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8009c2:	85 c0                	test   %eax,%eax
  8009c4:	74 20                	je     8009e6 <strlcpy+0x32>
  8009c6:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8009ca:	89 f0                	mov    %esi,%eax
  8009cc:	eb 05                	jmp    8009d3 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8009ce:	40                   	inc    %eax
  8009cf:	42                   	inc    %edx
  8009d0:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8009d3:	39 d8                	cmp    %ebx,%eax
  8009d5:	74 06                	je     8009dd <strlcpy+0x29>
  8009d7:	8a 0a                	mov    (%edx),%cl
  8009d9:	84 c9                	test   %cl,%cl
  8009db:	75 f1                	jne    8009ce <strlcpy+0x1a>
		*dst = '\0';
  8009dd:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8009e0:	29 f0                	sub    %esi,%eax
}
  8009e2:	5b                   	pop    %ebx
  8009e3:	5e                   	pop    %esi
  8009e4:	5d                   	pop    %ebp
  8009e5:	c3                   	ret    
  8009e6:	89 f0                	mov    %esi,%eax
  8009e8:	eb f6                	jmp    8009e0 <strlcpy+0x2c>

008009ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8009ea:	55                   	push   %ebp
  8009eb:	89 e5                	mov    %esp,%ebp
  8009ed:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8009f0:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8009f3:	eb 02                	jmp    8009f7 <strcmp+0xd>
		p++, q++;
  8009f5:	41                   	inc    %ecx
  8009f6:	42                   	inc    %edx
	while (*p && *p == *q)
  8009f7:	8a 01                	mov    (%ecx),%al
  8009f9:	84 c0                	test   %al,%al
  8009fb:	74 04                	je     800a01 <strcmp+0x17>
  8009fd:	3a 02                	cmp    (%edx),%al
  8009ff:	74 f4                	je     8009f5 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a01:	0f b6 c0             	movzbl %al,%eax
  800a04:	0f b6 12             	movzbl (%edx),%edx
  800a07:	29 d0                	sub    %edx,%eax
}
  800a09:	5d                   	pop    %ebp
  800a0a:	c3                   	ret    

00800a0b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	53                   	push   %ebx
  800a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a15:	89 c3                	mov    %eax,%ebx
  800a17:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a1a:	eb 02                	jmp    800a1e <strncmp+0x13>
		n--, p++, q++;
  800a1c:	40                   	inc    %eax
  800a1d:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a1e:	39 d8                	cmp    %ebx,%eax
  800a20:	74 15                	je     800a37 <strncmp+0x2c>
  800a22:	8a 08                	mov    (%eax),%cl
  800a24:	84 c9                	test   %cl,%cl
  800a26:	74 04                	je     800a2c <strncmp+0x21>
  800a28:	3a 0a                	cmp    (%edx),%cl
  800a2a:	74 f0                	je     800a1c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a2c:	0f b6 00             	movzbl (%eax),%eax
  800a2f:	0f b6 12             	movzbl (%edx),%edx
  800a32:	29 d0                	sub    %edx,%eax
}
  800a34:	5b                   	pop    %ebx
  800a35:	5d                   	pop    %ebp
  800a36:	c3                   	ret    
		return 0;
  800a37:	b8 00 00 00 00       	mov    $0x0,%eax
  800a3c:	eb f6                	jmp    800a34 <strncmp+0x29>

00800a3e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a3e:	55                   	push   %ebp
  800a3f:	89 e5                	mov    %esp,%ebp
  800a41:	8b 45 08             	mov    0x8(%ebp),%eax
  800a44:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a47:	8a 10                	mov    (%eax),%dl
  800a49:	84 d2                	test   %dl,%dl
  800a4b:	74 07                	je     800a54 <strchr+0x16>
		if (*s == c)
  800a4d:	38 ca                	cmp    %cl,%dl
  800a4f:	74 08                	je     800a59 <strchr+0x1b>
	for (; *s; s++)
  800a51:	40                   	inc    %eax
  800a52:	eb f3                	jmp    800a47 <strchr+0x9>
			return (char *) s;
	return 0;
  800a54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a59:	5d                   	pop    %ebp
  800a5a:	c3                   	ret    

00800a5b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800a5b:	55                   	push   %ebp
  800a5c:	89 e5                	mov    %esp,%ebp
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a64:	8a 10                	mov    (%eax),%dl
  800a66:	84 d2                	test   %dl,%dl
  800a68:	74 07                	je     800a71 <strfind+0x16>
		if (*s == c)
  800a6a:	38 ca                	cmp    %cl,%dl
  800a6c:	74 03                	je     800a71 <strfind+0x16>
	for (; *s; s++)
  800a6e:	40                   	inc    %eax
  800a6f:	eb f3                	jmp    800a64 <strfind+0x9>
			break;
	return (char *) s;
}
  800a71:	5d                   	pop    %ebp
  800a72:	c3                   	ret    

00800a73 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800a73:	55                   	push   %ebp
  800a74:	89 e5                	mov    %esp,%ebp
  800a76:	57                   	push   %edi
  800a77:	56                   	push   %esi
  800a78:	53                   	push   %ebx
  800a79:	8b 7d 08             	mov    0x8(%ebp),%edi
  800a7c:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800a7f:	85 c9                	test   %ecx,%ecx
  800a81:	74 13                	je     800a96 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800a83:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800a89:	75 05                	jne    800a90 <memset+0x1d>
  800a8b:	f6 c1 03             	test   $0x3,%cl
  800a8e:	74 0d                	je     800a9d <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800a90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a93:	fc                   	cld    
  800a94:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800a96:	89 f8                	mov    %edi,%eax
  800a98:	5b                   	pop    %ebx
  800a99:	5e                   	pop    %esi
  800a9a:	5f                   	pop    %edi
  800a9b:	5d                   	pop    %ebp
  800a9c:	c3                   	ret    
		c &= 0xFF;
  800a9d:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800aa1:	89 d3                	mov    %edx,%ebx
  800aa3:	c1 e3 08             	shl    $0x8,%ebx
  800aa6:	89 d0                	mov    %edx,%eax
  800aa8:	c1 e0 18             	shl    $0x18,%eax
  800aab:	89 d6                	mov    %edx,%esi
  800aad:	c1 e6 10             	shl    $0x10,%esi
  800ab0:	09 f0                	or     %esi,%eax
  800ab2:	09 c2                	or     %eax,%edx
  800ab4:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800ab6:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800ab9:	89 d0                	mov    %edx,%eax
  800abb:	fc                   	cld    
  800abc:	f3 ab                	rep stos %eax,%es:(%edi)
  800abe:	eb d6                	jmp    800a96 <memset+0x23>

00800ac0 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800ac0:	55                   	push   %ebp
  800ac1:	89 e5                	mov    %esp,%ebp
  800ac3:	57                   	push   %edi
  800ac4:	56                   	push   %esi
  800ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac8:	8b 75 0c             	mov    0xc(%ebp),%esi
  800acb:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ace:	39 c6                	cmp    %eax,%esi
  800ad0:	73 33                	jae    800b05 <memmove+0x45>
  800ad2:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800ad5:	39 d0                	cmp    %edx,%eax
  800ad7:	73 2c                	jae    800b05 <memmove+0x45>
		s += n;
		d += n;
  800ad9:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800adc:	89 d6                	mov    %edx,%esi
  800ade:	09 fe                	or     %edi,%esi
  800ae0:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800ae6:	75 13                	jne    800afb <memmove+0x3b>
  800ae8:	f6 c1 03             	test   $0x3,%cl
  800aeb:	75 0e                	jne    800afb <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800aed:	83 ef 04             	sub    $0x4,%edi
  800af0:	8d 72 fc             	lea    -0x4(%edx),%esi
  800af3:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800af6:	fd                   	std    
  800af7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800af9:	eb 07                	jmp    800b02 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800afb:	4f                   	dec    %edi
  800afc:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800aff:	fd                   	std    
  800b00:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b02:	fc                   	cld    
  800b03:	eb 13                	jmp    800b18 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b05:	89 f2                	mov    %esi,%edx
  800b07:	09 c2                	or     %eax,%edx
  800b09:	f6 c2 03             	test   $0x3,%dl
  800b0c:	75 05                	jne    800b13 <memmove+0x53>
  800b0e:	f6 c1 03             	test   $0x3,%cl
  800b11:	74 09                	je     800b1c <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b13:	89 c7                	mov    %eax,%edi
  800b15:	fc                   	cld    
  800b16:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b18:	5e                   	pop    %esi
  800b19:	5f                   	pop    %edi
  800b1a:	5d                   	pop    %ebp
  800b1b:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b1c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b1f:	89 c7                	mov    %eax,%edi
  800b21:	fc                   	cld    
  800b22:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b24:	eb f2                	jmp    800b18 <memmove+0x58>

00800b26 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b26:	55                   	push   %ebp
  800b27:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b29:	ff 75 10             	pushl  0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 89 ff ff ff       	call   800ac0 <memmove>
}
  800b37:	c9                   	leave  
  800b38:	c3                   	ret    

00800b39 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b39:	55                   	push   %ebp
  800b3a:	89 e5                	mov    %esp,%ebp
  800b3c:	56                   	push   %esi
  800b3d:	53                   	push   %ebx
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	89 c6                	mov    %eax,%esi
  800b43:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800b46:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800b49:	39 f0                	cmp    %esi,%eax
  800b4b:	74 16                	je     800b63 <memcmp+0x2a>
		if (*s1 != *s2)
  800b4d:	8a 08                	mov    (%eax),%cl
  800b4f:	8a 1a                	mov    (%edx),%bl
  800b51:	38 d9                	cmp    %bl,%cl
  800b53:	75 04                	jne    800b59 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b55:	40                   	inc    %eax
  800b56:	42                   	inc    %edx
  800b57:	eb f0                	jmp    800b49 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b59:	0f b6 c1             	movzbl %cl,%eax
  800b5c:	0f b6 db             	movzbl %bl,%ebx
  800b5f:	29 d8                	sub    %ebx,%eax
  800b61:	eb 05                	jmp    800b68 <memcmp+0x2f>
	}

	return 0;
  800b63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b72:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800b75:	89 c2                	mov    %eax,%edx
  800b77:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800b7a:	39 d0                	cmp    %edx,%eax
  800b7c:	73 07                	jae    800b85 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800b7e:	38 08                	cmp    %cl,(%eax)
  800b80:	74 03                	je     800b85 <memfind+0x19>
	for (; s < ends; s++)
  800b82:	40                   	inc    %eax
  800b83:	eb f5                	jmp    800b7a <memfind+0xe>
			break;
	return (void *) s;
}
  800b85:	5d                   	pop    %ebp
  800b86:	c3                   	ret    

00800b87 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800b87:	55                   	push   %ebp
  800b88:	89 e5                	mov    %esp,%ebp
  800b8a:	57                   	push   %edi
  800b8b:	56                   	push   %esi
  800b8c:	53                   	push   %ebx
  800b8d:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800b90:	eb 01                	jmp    800b93 <strtol+0xc>
		s++;
  800b92:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800b93:	8a 01                	mov    (%ecx),%al
  800b95:	3c 20                	cmp    $0x20,%al
  800b97:	74 f9                	je     800b92 <strtol+0xb>
  800b99:	3c 09                	cmp    $0x9,%al
  800b9b:	74 f5                	je     800b92 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800b9d:	3c 2b                	cmp    $0x2b,%al
  800b9f:	74 2b                	je     800bcc <strtol+0x45>
		s++;
	else if (*s == '-')
  800ba1:	3c 2d                	cmp    $0x2d,%al
  800ba3:	74 2f                	je     800bd4 <strtol+0x4d>
	int neg = 0;
  800ba5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800baa:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800bb1:	75 12                	jne    800bc5 <strtol+0x3e>
  800bb3:	80 39 30             	cmpb   $0x30,(%ecx)
  800bb6:	74 24                	je     800bdc <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bb8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bbc:	75 07                	jne    800bc5 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800bbe:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800bc5:	b8 00 00 00 00       	mov    $0x0,%eax
  800bca:	eb 4e                	jmp    800c1a <strtol+0x93>
		s++;
  800bcc:	41                   	inc    %ecx
	int neg = 0;
  800bcd:	bf 00 00 00 00       	mov    $0x0,%edi
  800bd2:	eb d6                	jmp    800baa <strtol+0x23>
		s++, neg = 1;
  800bd4:	41                   	inc    %ecx
  800bd5:	bf 01 00 00 00       	mov    $0x1,%edi
  800bda:	eb ce                	jmp    800baa <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bdc:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800be0:	74 10                	je     800bf2 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800be2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800be6:	75 dd                	jne    800bc5 <strtol+0x3e>
		s++, base = 8;
  800be8:	41                   	inc    %ecx
  800be9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800bf0:	eb d3                	jmp    800bc5 <strtol+0x3e>
		s += 2, base = 16;
  800bf2:	83 c1 02             	add    $0x2,%ecx
  800bf5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800bfc:	eb c7                	jmp    800bc5 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800bfe:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c01:	89 f3                	mov    %esi,%ebx
  800c03:	80 fb 19             	cmp    $0x19,%bl
  800c06:	77 24                	ja     800c2c <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c08:	0f be d2             	movsbl %dl,%edx
  800c0b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c0e:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c11:	7d 2b                	jge    800c3e <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c13:	41                   	inc    %ecx
  800c14:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c18:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c1a:	8a 11                	mov    (%ecx),%dl
  800c1c:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c1f:	80 fb 09             	cmp    $0x9,%bl
  800c22:	77 da                	ja     800bfe <strtol+0x77>
			dig = *s - '0';
  800c24:	0f be d2             	movsbl %dl,%edx
  800c27:	83 ea 30             	sub    $0x30,%edx
  800c2a:	eb e2                	jmp    800c0e <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c2c:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c2f:	89 f3                	mov    %esi,%ebx
  800c31:	80 fb 19             	cmp    $0x19,%bl
  800c34:	77 08                	ja     800c3e <strtol+0xb7>
			dig = *s - 'A' + 10;
  800c36:	0f be d2             	movsbl %dl,%edx
  800c39:	83 ea 37             	sub    $0x37,%edx
  800c3c:	eb d0                	jmp    800c0e <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c3e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c42:	74 05                	je     800c49 <strtol+0xc2>
		*endptr = (char *) s;
  800c44:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c47:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c49:	85 ff                	test   %edi,%edi
  800c4b:	74 02                	je     800c4f <strtol+0xc8>
  800c4d:	f7 d8                	neg    %eax
}
  800c4f:	5b                   	pop    %ebx
  800c50:	5e                   	pop    %esi
  800c51:	5f                   	pop    %edi
  800c52:	5d                   	pop    %ebp
  800c53:	c3                   	ret    

00800c54 <atoi>:

int
atoi(const char *s)
{
  800c54:	55                   	push   %ebp
  800c55:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800c57:	6a 0a                	push   $0xa
  800c59:	6a 00                	push   $0x0
  800c5b:	ff 75 08             	pushl  0x8(%ebp)
  800c5e:	e8 24 ff ff ff       	call   800b87 <strtol>
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	57                   	push   %edi
  800c69:	56                   	push   %esi
  800c6a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c6b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c73:	8b 55 08             	mov    0x8(%ebp),%edx
  800c76:	89 c3                	mov    %eax,%ebx
  800c78:	89 c7                	mov    %eax,%edi
  800c7a:	89 c6                	mov    %eax,%esi
  800c7c:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5f                   	pop    %edi
  800c81:	5d                   	pop    %ebp
  800c82:	c3                   	ret    

00800c83 <sys_cgetc>:

int
sys_cgetc(void)
{
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	57                   	push   %edi
  800c87:	56                   	push   %esi
  800c88:	53                   	push   %ebx
	asm volatile("int %1\n"
  800c89:	ba 00 00 00 00       	mov    $0x0,%edx
  800c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c93:	89 d1                	mov    %edx,%ecx
  800c95:	89 d3                	mov    %edx,%ebx
  800c97:	89 d7                	mov    %edx,%edi
  800c99:	89 d6                	mov    %edx,%esi
  800c9b:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800c9d:	5b                   	pop    %ebx
  800c9e:	5e                   	pop    %esi
  800c9f:	5f                   	pop    %edi
  800ca0:	5d                   	pop    %ebp
  800ca1:	c3                   	ret    

00800ca2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ca2:	55                   	push   %ebp
  800ca3:	89 e5                	mov    %esp,%ebp
  800ca5:	57                   	push   %edi
  800ca6:	56                   	push   %esi
  800ca7:	53                   	push   %ebx
  800ca8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cab:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cb0:	b8 03 00 00 00       	mov    $0x3,%eax
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	89 cb                	mov    %ecx,%ebx
  800cba:	89 cf                	mov    %ecx,%edi
  800cbc:	89 ce                	mov    %ecx,%esi
  800cbe:	cd 30                	int    $0x30
	if(check && ret > 0)
  800cc0:	85 c0                	test   %eax,%eax
  800cc2:	7f 08                	jg     800ccc <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
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
  800cd0:	6a 03                	push   $0x3
  800cd2:	68 1f 28 80 00       	push   $0x80281f
  800cd7:	6a 23                	push   $0x23
  800cd9:	68 3c 28 80 00       	push   $0x80283c
  800cde:	e8 4f f5 ff ff       	call   800232 <_panic>

00800ce3 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800ce3:	55                   	push   %ebp
  800ce4:	89 e5                	mov    %esp,%ebp
  800ce6:	57                   	push   %edi
  800ce7:	56                   	push   %esi
  800ce8:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ce9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cee:	b8 02 00 00 00       	mov    $0x2,%eax
  800cf3:	89 d1                	mov    %edx,%ecx
  800cf5:	89 d3                	mov    %edx,%ebx
  800cf7:	89 d7                	mov    %edx,%edi
  800cf9:	89 d6                	mov    %edx,%esi
  800cfb:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800cfd:	5b                   	pop    %ebx
  800cfe:	5e                   	pop    %esi
  800cff:	5f                   	pop    %edi
  800d00:	5d                   	pop    %ebp
  800d01:	c3                   	ret    

00800d02 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d02:	55                   	push   %ebp
  800d03:	89 e5                	mov    %esp,%ebp
  800d05:	57                   	push   %edi
  800d06:	56                   	push   %esi
  800d07:	53                   	push   %ebx
  800d08:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d0b:	be 00 00 00 00       	mov    $0x0,%esi
  800d10:	b8 04 00 00 00       	mov    $0x4,%eax
  800d15:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d18:	8b 55 08             	mov    0x8(%ebp),%edx
  800d1b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d1e:	89 f7                	mov    %esi,%edi
  800d20:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d22:	85 c0                	test   %eax,%eax
  800d24:	7f 08                	jg     800d2e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
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
  800d32:	6a 04                	push   $0x4
  800d34:	68 1f 28 80 00       	push   $0x80281f
  800d39:	6a 23                	push   $0x23
  800d3b:	68 3c 28 80 00       	push   $0x80283c
  800d40:	e8 ed f4 ff ff       	call   800232 <_panic>

00800d45 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d45:	55                   	push   %ebp
  800d46:	89 e5                	mov    %esp,%ebp
  800d48:	57                   	push   %edi
  800d49:	56                   	push   %esi
  800d4a:	53                   	push   %ebx
  800d4b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d4e:	b8 05 00 00 00       	mov    $0x5,%eax
  800d53:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d56:	8b 55 08             	mov    0x8(%ebp),%edx
  800d59:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d5c:	8b 7d 14             	mov    0x14(%ebp),%edi
  800d5f:	8b 75 18             	mov    0x18(%ebp),%esi
  800d62:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	7f 08                	jg     800d70 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
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
  800d74:	6a 05                	push   $0x5
  800d76:	68 1f 28 80 00       	push   $0x80281f
  800d7b:	6a 23                	push   $0x23
  800d7d:	68 3c 28 80 00       	push   $0x80283c
  800d82:	e8 ab f4 ff ff       	call   800232 <_panic>

00800d87 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800d87:	55                   	push   %ebp
  800d88:	89 e5                	mov    %esp,%ebp
  800d8a:	57                   	push   %edi
  800d8b:	56                   	push   %esi
  800d8c:	53                   	push   %ebx
  800d8d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d90:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d95:	b8 06 00 00 00       	mov    $0x6,%eax
  800d9a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9d:	8b 55 08             	mov    0x8(%ebp),%edx
  800da0:	89 df                	mov    %ebx,%edi
  800da2:	89 de                	mov    %ebx,%esi
  800da4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800da6:	85 c0                	test   %eax,%eax
  800da8:	7f 08                	jg     800db2 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800daa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dad:	5b                   	pop    %ebx
  800dae:	5e                   	pop    %esi
  800daf:	5f                   	pop    %edi
  800db0:	5d                   	pop    %ebp
  800db1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db2:	83 ec 0c             	sub    $0xc,%esp
  800db5:	50                   	push   %eax
  800db6:	6a 06                	push   $0x6
  800db8:	68 1f 28 80 00       	push   $0x80281f
  800dbd:	6a 23                	push   $0x23
  800dbf:	68 3c 28 80 00       	push   $0x80283c
  800dc4:	e8 69 f4 ff ff       	call   800232 <_panic>

00800dc9 <sys_yield>:

void
sys_yield(void)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	57                   	push   %edi
  800dcd:	56                   	push   %esi
  800dce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800dcf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dd4:	b8 0b 00 00 00       	mov    $0xb,%eax
  800dd9:	89 d1                	mov    %edx,%ecx
  800ddb:	89 d3                	mov    %edx,%ebx
  800ddd:	89 d7                	mov    %edx,%edi
  800ddf:	89 d6                	mov    %edx,%esi
  800de1:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800de3:	5b                   	pop    %ebx
  800de4:	5e                   	pop    %esi
  800de5:	5f                   	pop    %edi
  800de6:	5d                   	pop    %ebp
  800de7:	c3                   	ret    

00800de8 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800de8:	55                   	push   %ebp
  800de9:	89 e5                	mov    %esp,%ebp
  800deb:	57                   	push   %edi
  800dec:	56                   	push   %esi
  800ded:	53                   	push   %ebx
  800dee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800df1:	bb 00 00 00 00       	mov    $0x0,%ebx
  800df6:	b8 08 00 00 00       	mov    $0x8,%eax
  800dfb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  800e01:	89 df                	mov    %ebx,%edi
  800e03:	89 de                	mov    %ebx,%esi
  800e05:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e07:	85 c0                	test   %eax,%eax
  800e09:	7f 08                	jg     800e13 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e0b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e0e:	5b                   	pop    %ebx
  800e0f:	5e                   	pop    %esi
  800e10:	5f                   	pop    %edi
  800e11:	5d                   	pop    %ebp
  800e12:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e13:	83 ec 0c             	sub    $0xc,%esp
  800e16:	50                   	push   %eax
  800e17:	6a 08                	push   $0x8
  800e19:	68 1f 28 80 00       	push   $0x80281f
  800e1e:	6a 23                	push   $0x23
  800e20:	68 3c 28 80 00       	push   $0x80283c
  800e25:	e8 08 f4 ff ff       	call   800232 <_panic>

00800e2a <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e2a:	55                   	push   %ebp
  800e2b:	89 e5                	mov    %esp,%ebp
  800e2d:	57                   	push   %edi
  800e2e:	56                   	push   %esi
  800e2f:	53                   	push   %ebx
  800e30:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e33:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e38:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e40:	89 cb                	mov    %ecx,%ebx
  800e42:	89 cf                	mov    %ecx,%edi
  800e44:	89 ce                	mov    %ecx,%esi
  800e46:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e48:	85 c0                	test   %eax,%eax
  800e4a:	7f 08                	jg     800e54 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800e4c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e4f:	5b                   	pop    %ebx
  800e50:	5e                   	pop    %esi
  800e51:	5f                   	pop    %edi
  800e52:	5d                   	pop    %ebp
  800e53:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e54:	83 ec 0c             	sub    $0xc,%esp
  800e57:	50                   	push   %eax
  800e58:	6a 0c                	push   $0xc
  800e5a:	68 1f 28 80 00       	push   $0x80281f
  800e5f:	6a 23                	push   $0x23
  800e61:	68 3c 28 80 00       	push   $0x80283c
  800e66:	e8 c7 f3 ff ff       	call   800232 <_panic>

00800e6b <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800e6b:	55                   	push   %ebp
  800e6c:	89 e5                	mov    %esp,%ebp
  800e6e:	57                   	push   %edi
  800e6f:	56                   	push   %esi
  800e70:	53                   	push   %ebx
  800e71:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e74:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e79:	b8 09 00 00 00       	mov    $0x9,%eax
  800e7e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e81:	8b 55 08             	mov    0x8(%ebp),%edx
  800e84:	89 df                	mov    %ebx,%edi
  800e86:	89 de                	mov    %ebx,%esi
  800e88:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8a:	85 c0                	test   %eax,%eax
  800e8c:	7f 08                	jg     800e96 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800e8e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e91:	5b                   	pop    %ebx
  800e92:	5e                   	pop    %esi
  800e93:	5f                   	pop    %edi
  800e94:	5d                   	pop    %ebp
  800e95:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e96:	83 ec 0c             	sub    $0xc,%esp
  800e99:	50                   	push   %eax
  800e9a:	6a 09                	push   $0x9
  800e9c:	68 1f 28 80 00       	push   $0x80281f
  800ea1:	6a 23                	push   $0x23
  800ea3:	68 3c 28 80 00       	push   $0x80283c
  800ea8:	e8 85 f3 ff ff       	call   800232 <_panic>

00800ead <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ead:	55                   	push   %ebp
  800eae:	89 e5                	mov    %esp,%ebp
  800eb0:	57                   	push   %edi
  800eb1:	56                   	push   %esi
  800eb2:	53                   	push   %ebx
  800eb3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eb6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebb:	b8 0a 00 00 00       	mov    $0xa,%eax
  800ec0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec6:	89 df                	mov    %ebx,%edi
  800ec8:	89 de                	mov    %ebx,%esi
  800eca:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ecc:	85 c0                	test   %eax,%eax
  800ece:	7f 08                	jg     800ed8 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800ed0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed3:	5b                   	pop    %ebx
  800ed4:	5e                   	pop    %esi
  800ed5:	5f                   	pop    %edi
  800ed6:	5d                   	pop    %ebp
  800ed7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ed8:	83 ec 0c             	sub    $0xc,%esp
  800edb:	50                   	push   %eax
  800edc:	6a 0a                	push   $0xa
  800ede:	68 1f 28 80 00       	push   $0x80281f
  800ee3:	6a 23                	push   $0x23
  800ee5:	68 3c 28 80 00       	push   $0x80283c
  800eea:	e8 43 f3 ff ff       	call   800232 <_panic>

00800eef <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800eef:	55                   	push   %ebp
  800ef0:	89 e5                	mov    %esp,%ebp
  800ef2:	57                   	push   %edi
  800ef3:	56                   	push   %esi
  800ef4:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ef5:	be 00 00 00 00       	mov    $0x0,%esi
  800efa:	b8 0d 00 00 00       	mov    $0xd,%eax
  800eff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f02:	8b 55 08             	mov    0x8(%ebp),%edx
  800f05:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f08:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f0b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f0d:	5b                   	pop    %ebx
  800f0e:	5e                   	pop    %esi
  800f0f:	5f                   	pop    %edi
  800f10:	5d                   	pop    %ebp
  800f11:	c3                   	ret    

00800f12 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	57                   	push   %edi
  800f16:	56                   	push   %esi
  800f17:	53                   	push   %ebx
  800f18:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f1b:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f20:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f25:	8b 55 08             	mov    0x8(%ebp),%edx
  800f28:	89 cb                	mov    %ecx,%ebx
  800f2a:	89 cf                	mov    %ecx,%edi
  800f2c:	89 ce                	mov    %ecx,%esi
  800f2e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f30:	85 c0                	test   %eax,%eax
  800f32:	7f 08                	jg     800f3c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f37:	5b                   	pop    %ebx
  800f38:	5e                   	pop    %esi
  800f39:	5f                   	pop    %edi
  800f3a:	5d                   	pop    %ebp
  800f3b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f3c:	83 ec 0c             	sub    $0xc,%esp
  800f3f:	50                   	push   %eax
  800f40:	6a 0e                	push   $0xe
  800f42:	68 1f 28 80 00       	push   $0x80281f
  800f47:	6a 23                	push   $0x23
  800f49:	68 3c 28 80 00       	push   $0x80283c
  800f4e:	e8 df f2 ff ff       	call   800232 <_panic>

00800f53 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	57                   	push   %edi
  800f57:	56                   	push   %esi
  800f58:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f59:	be 00 00 00 00       	mov    $0x0,%esi
  800f5e:	b8 0f 00 00 00       	mov    $0xf,%eax
  800f63:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f66:	8b 55 08             	mov    0x8(%ebp),%edx
  800f69:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f6c:	89 f7                	mov    %esi,%edi
  800f6e:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f70:	5b                   	pop    %ebx
  800f71:	5e                   	pop    %esi
  800f72:	5f                   	pop    %edi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	57                   	push   %edi
  800f79:	56                   	push   %esi
  800f7a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f7b:	be 00 00 00 00       	mov    $0x0,%esi
  800f80:	b8 10 00 00 00       	mov    $0x10,%eax
  800f85:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f88:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f8e:	89 f7                	mov    %esi,%edi
  800f90:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800f92:	5b                   	pop    %ebx
  800f93:	5e                   	pop    %esi
  800f94:	5f                   	pop    %edi
  800f95:	5d                   	pop    %ebp
  800f96:	c3                   	ret    

00800f97 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800f97:	55                   	push   %ebp
  800f98:	89 e5                	mov    %esp,%ebp
  800f9a:	57                   	push   %edi
  800f9b:	56                   	push   %esi
  800f9c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fa2:	b8 11 00 00 00       	mov    $0x11,%eax
  800fa7:	8b 55 08             	mov    0x8(%ebp),%edx
  800faa:	89 cb                	mov    %ecx,%ebx
  800fac:	89 cf                	mov    %ecx,%edi
  800fae:	89 ce                	mov    %ecx,%esi
  800fb0:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800fb2:	5b                   	pop    %ebx
  800fb3:	5e                   	pop    %esi
  800fb4:	5f                   	pop    %edi
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	56                   	push   %esi
  800fbb:	53                   	push   %ebx
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  800fbf:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  800fc1:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  800fc5:	0f 84 84 00 00 00    	je     80104f <pgfault+0x98>
  800fcb:	89 d8                	mov    %ebx,%eax
  800fcd:	c1 e8 16             	shr    $0x16,%eax
  800fd0:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800fd7:	a8 01                	test   $0x1,%al
  800fd9:	74 74                	je     80104f <pgfault+0x98>
  800fdb:	89 d8                	mov    %ebx,%eax
  800fdd:	c1 e8 0c             	shr    $0xc,%eax
  800fe0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800fe7:	f6 c4 08             	test   $0x8,%ah
  800fea:	74 63                	je     80104f <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  800fec:	e8 f2 fc ff ff       	call   800ce3 <sys_getenvid>
  800ff1:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  800ff3:	83 ec 04             	sub    $0x4,%esp
  800ff6:	6a 07                	push   $0x7
  800ff8:	68 00 f0 7f 00       	push   $0x7ff000
  800ffd:	50                   	push   %eax
  800ffe:	e8 ff fc ff ff       	call   800d02 <sys_page_alloc>
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	85 c0                	test   %eax,%eax
  801008:	78 5b                	js     801065 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  80100a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  801010:	83 ec 04             	sub    $0x4,%esp
  801013:	68 00 10 00 00       	push   $0x1000
  801018:	53                   	push   %ebx
  801019:	68 00 f0 7f 00       	push   $0x7ff000
  80101e:	e8 03 fb ff ff       	call   800b26 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  801023:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80102a:	53                   	push   %ebx
  80102b:	56                   	push   %esi
  80102c:	68 00 f0 7f 00       	push   $0x7ff000
  801031:	56                   	push   %esi
  801032:	e8 0e fd ff ff       	call   800d45 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  801037:	83 c4 18             	add    $0x18,%esp
  80103a:	68 00 f0 7f 00       	push   $0x7ff000
  80103f:	56                   	push   %esi
  801040:	e8 42 fd ff ff       	call   800d87 <sys_page_unmap>

}
  801045:	83 c4 10             	add    $0x10,%esp
  801048:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80104b:	5b                   	pop    %ebx
  80104c:	5e                   	pop    %esi
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  80104f:	68 4c 28 80 00       	push   $0x80284c
  801054:	68 d6 28 80 00       	push   $0x8028d6
  801059:	6a 1c                	push   $0x1c
  80105b:	68 eb 28 80 00       	push   $0x8028eb
  801060:	e8 cd f1 ff ff       	call   800232 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801065:	68 9c 28 80 00       	push   $0x80289c
  80106a:	68 d6 28 80 00       	push   $0x8028d6
  80106f:	6a 26                	push   $0x26
  801071:	68 eb 28 80 00       	push   $0x8028eb
  801076:	e8 b7 f1 ff ff       	call   800232 <_panic>

0080107b <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80107b:	55                   	push   %ebp
  80107c:	89 e5                	mov    %esp,%ebp
  80107e:	57                   	push   %edi
  80107f:	56                   	push   %esi
  801080:	53                   	push   %ebx
  801081:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801084:	68 b7 0f 80 00       	push   $0x800fb7
  801089:	e8 0d 0f 00 00       	call   801f9b <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  80108e:	b8 07 00 00 00       	mov    $0x7,%eax
  801093:	cd 30                	int    $0x30
  801095:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801098:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  80109b:	83 c4 10             	add    $0x10,%esp
  80109e:	85 c0                	test   %eax,%eax
  8010a0:	0f 88 58 01 00 00    	js     8011fe <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  8010a6:	85 c0                	test   %eax,%eax
  8010a8:	74 07                	je     8010b1 <fork+0x36>
  8010aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010af:	eb 72                	jmp    801123 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010b1:	e8 2d fc ff ff       	call   800ce3 <sys_getenvid>
  8010b6:	25 ff 03 00 00       	and    $0x3ff,%eax
  8010bb:	89 c2                	mov    %eax,%edx
  8010bd:	c1 e2 05             	shl    $0x5,%edx
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8010c9:	a3 20 44 80 00       	mov    %eax,0x804420
		return 0;
  8010ce:	e9 20 01 00 00       	jmp    8011f3 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  8010d3:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8010da:	e8 04 fc ff ff       	call   800ce3 <sys_getenvid>
  8010df:	83 ec 0c             	sub    $0xc,%esp
  8010e2:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8010e8:	57                   	push   %edi
  8010e9:	56                   	push   %esi
  8010ea:	ff 75 e4             	pushl  -0x1c(%ebp)
  8010ed:	56                   	push   %esi
  8010ee:	50                   	push   %eax
  8010ef:	e8 51 fc ff ff       	call   800d45 <sys_page_map>
  8010f4:	83 c4 20             	add    $0x20,%esp
  8010f7:	eb 18                	jmp    801111 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  8010f9:	e8 e5 fb ff ff       	call   800ce3 <sys_getenvid>
  8010fe:	83 ec 0c             	sub    $0xc,%esp
  801101:	6a 05                	push   $0x5
  801103:	56                   	push   %esi
  801104:	ff 75 e4             	pushl  -0x1c(%ebp)
  801107:	56                   	push   %esi
  801108:	50                   	push   %eax
  801109:	e8 37 fc ff ff       	call   800d45 <sys_page_map>
  80110e:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801111:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801117:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  80111d:	0f 84 8f 00 00 00    	je     8011b2 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  801123:	89 d8                	mov    %ebx,%eax
  801125:	c1 e8 16             	shr    $0x16,%eax
  801128:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80112f:	a8 01                	test   $0x1,%al
  801131:	74 de                	je     801111 <fork+0x96>
  801133:	89 d8                	mov    %ebx,%eax
  801135:	c1 e8 0c             	shr    $0xc,%eax
  801138:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80113f:	a8 04                	test   $0x4,%al
  801141:	74 ce                	je     801111 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801143:	89 de                	mov    %ebx,%esi
  801145:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80114b:	89 f0                	mov    %esi,%eax
  80114d:	c1 e8 0c             	shr    $0xc,%eax
  801150:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801157:	f6 c6 04             	test   $0x4,%dh
  80115a:	0f 85 73 ff ff ff    	jne    8010d3 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  801160:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801167:	a9 02 08 00 00       	test   $0x802,%eax
  80116c:	74 8b                	je     8010f9 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  80116e:	e8 70 fb ff ff       	call   800ce3 <sys_getenvid>
  801173:	83 ec 0c             	sub    $0xc,%esp
  801176:	68 05 08 00 00       	push   $0x805
  80117b:	56                   	push   %esi
  80117c:	ff 75 e4             	pushl  -0x1c(%ebp)
  80117f:	56                   	push   %esi
  801180:	50                   	push   %eax
  801181:	e8 bf fb ff ff       	call   800d45 <sys_page_map>
  801186:	83 c4 20             	add    $0x20,%esp
  801189:	85 c0                	test   %eax,%eax
  80118b:	78 84                	js     801111 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  80118d:	e8 51 fb ff ff       	call   800ce3 <sys_getenvid>
  801192:	89 c7                	mov    %eax,%edi
  801194:	e8 4a fb ff ff       	call   800ce3 <sys_getenvid>
  801199:	83 ec 0c             	sub    $0xc,%esp
  80119c:	68 05 08 00 00       	push   $0x805
  8011a1:	56                   	push   %esi
  8011a2:	57                   	push   %edi
  8011a3:	56                   	push   %esi
  8011a4:	50                   	push   %eax
  8011a5:	e8 9b fb ff ff       	call   800d45 <sys_page_map>
  8011aa:	83 c4 20             	add    $0x20,%esp
  8011ad:	e9 5f ff ff ff       	jmp    801111 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8011b2:	83 ec 04             	sub    $0x4,%esp
  8011b5:	6a 07                	push   $0x7
  8011b7:	68 00 f0 bf ee       	push   $0xeebff000
  8011bc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8011bf:	57                   	push   %edi
  8011c0:	e8 3d fb ff ff       	call   800d02 <sys_page_alloc>
  8011c5:	83 c4 10             	add    $0x10,%esp
  8011c8:	85 c0                	test   %eax,%eax
  8011ca:	78 3b                	js     801207 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8011cc:	83 ec 08             	sub    $0x8,%esp
  8011cf:	68 e1 1f 80 00       	push   $0x801fe1
  8011d4:	57                   	push   %edi
  8011d5:	e8 d3 fc ff ff       	call   800ead <sys_env_set_pgfault_upcall>
  8011da:	83 c4 10             	add    $0x10,%esp
  8011dd:	85 c0                	test   %eax,%eax
  8011df:	78 2f                	js     801210 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8011e1:	83 ec 08             	sub    $0x8,%esp
  8011e4:	6a 02                	push   $0x2
  8011e6:	57                   	push   %edi
  8011e7:	e8 fc fb ff ff       	call   800de8 <sys_env_set_status>
	if (temp < 0) {
  8011ec:	83 c4 10             	add    $0x10,%esp
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	78 26                	js     801219 <fork+0x19e>
		return -1;
	}

	return childid;
}
  8011f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011f9:	5b                   	pop    %ebx
  8011fa:	5e                   	pop    %esi
  8011fb:	5f                   	pop    %edi
  8011fc:	5d                   	pop    %ebp
  8011fd:	c3                   	ret    
		return -1;
  8011fe:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801205:	eb ec                	jmp    8011f3 <fork+0x178>
		return -1;
  801207:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80120e:	eb e3                	jmp    8011f3 <fork+0x178>
		return -1;
  801210:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801217:	eb da                	jmp    8011f3 <fork+0x178>
		return -1;
  801219:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801220:	eb d1                	jmp    8011f3 <fork+0x178>

00801222 <sfork>:

// Challenge!
int
sfork(void)
{
  801222:	55                   	push   %ebp
  801223:	89 e5                	mov    %esp,%ebp
  801225:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801228:	68 f6 28 80 00       	push   $0x8028f6
  80122d:	68 85 00 00 00       	push   $0x85
  801232:	68 eb 28 80 00       	push   $0x8028eb
  801237:	e8 f6 ef ff ff       	call   800232 <_panic>

0080123c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80123c:	55                   	push   %ebp
  80123d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	05 00 00 00 30       	add    $0x30000000,%eax
  801247:	c1 e8 0c             	shr    $0xc,%eax
}
  80124a:	5d                   	pop    %ebp
  80124b:	c3                   	ret    

0080124c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80124c:	55                   	push   %ebp
  80124d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80124f:	8b 45 08             	mov    0x8(%ebp),%eax
  801252:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801257:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80125c:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801269:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80126e:	89 c2                	mov    %eax,%edx
  801270:	c1 ea 16             	shr    $0x16,%edx
  801273:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80127a:	f6 c2 01             	test   $0x1,%dl
  80127d:	74 2a                	je     8012a9 <fd_alloc+0x46>
  80127f:	89 c2                	mov    %eax,%edx
  801281:	c1 ea 0c             	shr    $0xc,%edx
  801284:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80128b:	f6 c2 01             	test   $0x1,%dl
  80128e:	74 19                	je     8012a9 <fd_alloc+0x46>
  801290:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801295:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80129a:	75 d2                	jne    80126e <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80129c:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8012a2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8012a7:	eb 07                	jmp    8012b0 <fd_alloc+0x4d>
			*fd_store = fd;
  8012a9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012b0:	5d                   	pop    %ebp
  8012b1:	c3                   	ret    

008012b2 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8012b2:	55                   	push   %ebp
  8012b3:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8012b5:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8012b9:	77 39                	ja     8012f4 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8012bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012be:	c1 e0 0c             	shl    $0xc,%eax
  8012c1:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8012c6:	89 c2                	mov    %eax,%edx
  8012c8:	c1 ea 16             	shr    $0x16,%edx
  8012cb:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8012d2:	f6 c2 01             	test   $0x1,%dl
  8012d5:	74 24                	je     8012fb <fd_lookup+0x49>
  8012d7:	89 c2                	mov    %eax,%edx
  8012d9:	c1 ea 0c             	shr    $0xc,%edx
  8012dc:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8012e3:	f6 c2 01             	test   $0x1,%dl
  8012e6:	74 1a                	je     801302 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8012e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012eb:	89 02                	mov    %eax,(%edx)
	return 0;
  8012ed:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8012f2:	5d                   	pop    %ebp
  8012f3:	c3                   	ret    
		return -E_INVAL;
  8012f4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8012f9:	eb f7                	jmp    8012f2 <fd_lookup+0x40>
		return -E_INVAL;
  8012fb:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801300:	eb f0                	jmp    8012f2 <fd_lookup+0x40>
  801302:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801307:	eb e9                	jmp    8012f2 <fd_lookup+0x40>

00801309 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	83 ec 08             	sub    $0x8,%esp
  80130f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801312:	ba 88 29 80 00       	mov    $0x802988,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801317:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  80131c:	39 08                	cmp    %ecx,(%eax)
  80131e:	74 33                	je     801353 <dev_lookup+0x4a>
  801320:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801323:	8b 02                	mov    (%edx),%eax
  801325:	85 c0                	test   %eax,%eax
  801327:	75 f3                	jne    80131c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801329:	a1 20 44 80 00       	mov    0x804420,%eax
  80132e:	8b 40 48             	mov    0x48(%eax),%eax
  801331:	83 ec 04             	sub    $0x4,%esp
  801334:	51                   	push   %ecx
  801335:	50                   	push   %eax
  801336:	68 0c 29 80 00       	push   $0x80290c
  80133b:	e8 05 f0 ff ff       	call   800345 <cprintf>
	*dev = 0;
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801349:	83 c4 10             	add    $0x10,%esp
  80134c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    
			*dev = devtab[i];
  801353:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801356:	89 01                	mov    %eax,(%ecx)
			return 0;
  801358:	b8 00 00 00 00       	mov    $0x0,%eax
  80135d:	eb f2                	jmp    801351 <dev_lookup+0x48>

0080135f <fd_close>:
{
  80135f:	55                   	push   %ebp
  801360:	89 e5                	mov    %esp,%ebp
  801362:	57                   	push   %edi
  801363:	56                   	push   %esi
  801364:	53                   	push   %ebx
  801365:	83 ec 1c             	sub    $0x1c,%esp
  801368:	8b 75 08             	mov    0x8(%ebp),%esi
  80136b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80136e:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801371:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801372:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801378:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80137b:	50                   	push   %eax
  80137c:	e8 31 ff ff ff       	call   8012b2 <fd_lookup>
  801381:	89 c7                	mov    %eax,%edi
  801383:	83 c4 08             	add    $0x8,%esp
  801386:	85 c0                	test   %eax,%eax
  801388:	78 05                	js     80138f <fd_close+0x30>
	    || fd != fd2)
  80138a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80138d:	74 13                	je     8013a2 <fd_close+0x43>
		return (must_exist ? r : 0);
  80138f:	84 db                	test   %bl,%bl
  801391:	75 05                	jne    801398 <fd_close+0x39>
  801393:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801398:	89 f8                	mov    %edi,%eax
  80139a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80139d:	5b                   	pop    %ebx
  80139e:	5e                   	pop    %esi
  80139f:	5f                   	pop    %edi
  8013a0:	5d                   	pop    %ebp
  8013a1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8013a2:	83 ec 08             	sub    $0x8,%esp
  8013a5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8013a8:	50                   	push   %eax
  8013a9:	ff 36                	pushl  (%esi)
  8013ab:	e8 59 ff ff ff       	call   801309 <dev_lookup>
  8013b0:	89 c7                	mov    %eax,%edi
  8013b2:	83 c4 10             	add    $0x10,%esp
  8013b5:	85 c0                	test   %eax,%eax
  8013b7:	78 15                	js     8013ce <fd_close+0x6f>
		if (dev->dev_close)
  8013b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bc:	8b 40 10             	mov    0x10(%eax),%eax
  8013bf:	85 c0                	test   %eax,%eax
  8013c1:	74 1b                	je     8013de <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8013c3:	83 ec 0c             	sub    $0xc,%esp
  8013c6:	56                   	push   %esi
  8013c7:	ff d0                	call   *%eax
  8013c9:	89 c7                	mov    %eax,%edi
  8013cb:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8013ce:	83 ec 08             	sub    $0x8,%esp
  8013d1:	56                   	push   %esi
  8013d2:	6a 00                	push   $0x0
  8013d4:	e8 ae f9 ff ff       	call   800d87 <sys_page_unmap>
	return r;
  8013d9:	83 c4 10             	add    $0x10,%esp
  8013dc:	eb ba                	jmp    801398 <fd_close+0x39>
			r = 0;
  8013de:	bf 00 00 00 00       	mov    $0x0,%edi
  8013e3:	eb e9                	jmp    8013ce <fd_close+0x6f>

008013e5 <close>:

int
close(int fdnum)
{
  8013e5:	55                   	push   %ebp
  8013e6:	89 e5                	mov    %esp,%ebp
  8013e8:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8013eb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8013ee:	50                   	push   %eax
  8013ef:	ff 75 08             	pushl  0x8(%ebp)
  8013f2:	e8 bb fe ff ff       	call   8012b2 <fd_lookup>
  8013f7:	83 c4 08             	add    $0x8,%esp
  8013fa:	85 c0                	test   %eax,%eax
  8013fc:	78 10                	js     80140e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8013fe:	83 ec 08             	sub    $0x8,%esp
  801401:	6a 01                	push   $0x1
  801403:	ff 75 f4             	pushl  -0xc(%ebp)
  801406:	e8 54 ff ff ff       	call   80135f <fd_close>
  80140b:	83 c4 10             	add    $0x10,%esp
}
  80140e:	c9                   	leave  
  80140f:	c3                   	ret    

00801410 <close_all>:

void
close_all(void)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	53                   	push   %ebx
  801414:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801417:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80141c:	83 ec 0c             	sub    $0xc,%esp
  80141f:	53                   	push   %ebx
  801420:	e8 c0 ff ff ff       	call   8013e5 <close>
	for (i = 0; i < MAXFD; i++)
  801425:	43                   	inc    %ebx
  801426:	83 c4 10             	add    $0x10,%esp
  801429:	83 fb 20             	cmp    $0x20,%ebx
  80142c:	75 ee                	jne    80141c <close_all+0xc>
}
  80142e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801431:	c9                   	leave  
  801432:	c3                   	ret    

00801433 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
  801439:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80143c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80143f:	50                   	push   %eax
  801440:	ff 75 08             	pushl  0x8(%ebp)
  801443:	e8 6a fe ff ff       	call   8012b2 <fd_lookup>
  801448:	89 c3                	mov    %eax,%ebx
  80144a:	83 c4 08             	add    $0x8,%esp
  80144d:	85 c0                	test   %eax,%eax
  80144f:	0f 88 81 00 00 00    	js     8014d6 <dup+0xa3>
		return r;
	close(newfdnum);
  801455:	83 ec 0c             	sub    $0xc,%esp
  801458:	ff 75 0c             	pushl  0xc(%ebp)
  80145b:	e8 85 ff ff ff       	call   8013e5 <close>

	newfd = INDEX2FD(newfdnum);
  801460:	8b 75 0c             	mov    0xc(%ebp),%esi
  801463:	c1 e6 0c             	shl    $0xc,%esi
  801466:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80146c:	83 c4 04             	add    $0x4,%esp
  80146f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801472:	e8 d5 fd ff ff       	call   80124c <fd2data>
  801477:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801479:	89 34 24             	mov    %esi,(%esp)
  80147c:	e8 cb fd ff ff       	call   80124c <fd2data>
  801481:	83 c4 10             	add    $0x10,%esp
  801484:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801486:	89 d8                	mov    %ebx,%eax
  801488:	c1 e8 16             	shr    $0x16,%eax
  80148b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801492:	a8 01                	test   $0x1,%al
  801494:	74 11                	je     8014a7 <dup+0x74>
  801496:	89 d8                	mov    %ebx,%eax
  801498:	c1 e8 0c             	shr    $0xc,%eax
  80149b:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8014a2:	f6 c2 01             	test   $0x1,%dl
  8014a5:	75 39                	jne    8014e0 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8014a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8014aa:	89 d0                	mov    %edx,%eax
  8014ac:	c1 e8 0c             	shr    $0xc,%eax
  8014af:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014b6:	83 ec 0c             	sub    $0xc,%esp
  8014b9:	25 07 0e 00 00       	and    $0xe07,%eax
  8014be:	50                   	push   %eax
  8014bf:	56                   	push   %esi
  8014c0:	6a 00                	push   $0x0
  8014c2:	52                   	push   %edx
  8014c3:	6a 00                	push   $0x0
  8014c5:	e8 7b f8 ff ff       	call   800d45 <sys_page_map>
  8014ca:	89 c3                	mov    %eax,%ebx
  8014cc:	83 c4 20             	add    $0x20,%esp
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	78 31                	js     801504 <dup+0xd1>
		goto err;

	return newfdnum;
  8014d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8014d6:	89 d8                	mov    %ebx,%eax
  8014d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014db:	5b                   	pop    %ebx
  8014dc:	5e                   	pop    %esi
  8014dd:	5f                   	pop    %edi
  8014de:	5d                   	pop    %ebp
  8014df:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8014e0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8014e7:	83 ec 0c             	sub    $0xc,%esp
  8014ea:	25 07 0e 00 00       	and    $0xe07,%eax
  8014ef:	50                   	push   %eax
  8014f0:	57                   	push   %edi
  8014f1:	6a 00                	push   $0x0
  8014f3:	53                   	push   %ebx
  8014f4:	6a 00                	push   $0x0
  8014f6:	e8 4a f8 ff ff       	call   800d45 <sys_page_map>
  8014fb:	89 c3                	mov    %eax,%ebx
  8014fd:	83 c4 20             	add    $0x20,%esp
  801500:	85 c0                	test   %eax,%eax
  801502:	79 a3                	jns    8014a7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801504:	83 ec 08             	sub    $0x8,%esp
  801507:	56                   	push   %esi
  801508:	6a 00                	push   $0x0
  80150a:	e8 78 f8 ff ff       	call   800d87 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80150f:	83 c4 08             	add    $0x8,%esp
  801512:	57                   	push   %edi
  801513:	6a 00                	push   $0x0
  801515:	e8 6d f8 ff ff       	call   800d87 <sys_page_unmap>
	return r;
  80151a:	83 c4 10             	add    $0x10,%esp
  80151d:	eb b7                	jmp    8014d6 <dup+0xa3>

0080151f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80151f:	55                   	push   %ebp
  801520:	89 e5                	mov    %esp,%ebp
  801522:	53                   	push   %ebx
  801523:	83 ec 14             	sub    $0x14,%esp
  801526:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801529:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80152c:	50                   	push   %eax
  80152d:	53                   	push   %ebx
  80152e:	e8 7f fd ff ff       	call   8012b2 <fd_lookup>
  801533:	83 c4 08             	add    $0x8,%esp
  801536:	85 c0                	test   %eax,%eax
  801538:	78 3f                	js     801579 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801540:	50                   	push   %eax
  801541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801544:	ff 30                	pushl  (%eax)
  801546:	e8 be fd ff ff       	call   801309 <dev_lookup>
  80154b:	83 c4 10             	add    $0x10,%esp
  80154e:	85 c0                	test   %eax,%eax
  801550:	78 27                	js     801579 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801552:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801555:	8b 42 08             	mov    0x8(%edx),%eax
  801558:	83 e0 03             	and    $0x3,%eax
  80155b:	83 f8 01             	cmp    $0x1,%eax
  80155e:	74 1e                	je     80157e <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801563:	8b 40 08             	mov    0x8(%eax),%eax
  801566:	85 c0                	test   %eax,%eax
  801568:	74 35                	je     80159f <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80156a:	83 ec 04             	sub    $0x4,%esp
  80156d:	ff 75 10             	pushl  0x10(%ebp)
  801570:	ff 75 0c             	pushl  0xc(%ebp)
  801573:	52                   	push   %edx
  801574:	ff d0                	call   *%eax
  801576:	83 c4 10             	add    $0x10,%esp
}
  801579:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80157c:	c9                   	leave  
  80157d:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80157e:	a1 20 44 80 00       	mov    0x804420,%eax
  801583:	8b 40 48             	mov    0x48(%eax),%eax
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	53                   	push   %ebx
  80158a:	50                   	push   %eax
  80158b:	68 4d 29 80 00       	push   $0x80294d
  801590:	e8 b0 ed ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  801595:	83 c4 10             	add    $0x10,%esp
  801598:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80159d:	eb da                	jmp    801579 <read+0x5a>
		return -E_NOT_SUPP;
  80159f:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015a4:	eb d3                	jmp    801579 <read+0x5a>

008015a6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8015a6:	55                   	push   %ebp
  8015a7:	89 e5                	mov    %esp,%ebp
  8015a9:	57                   	push   %edi
  8015aa:	56                   	push   %esi
  8015ab:	53                   	push   %ebx
  8015ac:	83 ec 0c             	sub    $0xc,%esp
  8015af:	8b 7d 08             	mov    0x8(%ebp),%edi
  8015b2:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8015b5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8015ba:	39 f3                	cmp    %esi,%ebx
  8015bc:	73 25                	jae    8015e3 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015be:	83 ec 04             	sub    $0x4,%esp
  8015c1:	89 f0                	mov    %esi,%eax
  8015c3:	29 d8                	sub    %ebx,%eax
  8015c5:	50                   	push   %eax
  8015c6:	89 d8                	mov    %ebx,%eax
  8015c8:	03 45 0c             	add    0xc(%ebp),%eax
  8015cb:	50                   	push   %eax
  8015cc:	57                   	push   %edi
  8015cd:	e8 4d ff ff ff       	call   80151f <read>
		if (m < 0)
  8015d2:	83 c4 10             	add    $0x10,%esp
  8015d5:	85 c0                	test   %eax,%eax
  8015d7:	78 08                	js     8015e1 <readn+0x3b>
			return m;
		if (m == 0)
  8015d9:	85 c0                	test   %eax,%eax
  8015db:	74 06                	je     8015e3 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8015dd:	01 c3                	add    %eax,%ebx
  8015df:	eb d9                	jmp    8015ba <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8015e1:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8015e3:	89 d8                	mov    %ebx,%eax
  8015e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8015e8:	5b                   	pop    %ebx
  8015e9:	5e                   	pop    %esi
  8015ea:	5f                   	pop    %edi
  8015eb:	5d                   	pop    %ebp
  8015ec:	c3                   	ret    

008015ed <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8015ed:	55                   	push   %ebp
  8015ee:	89 e5                	mov    %esp,%ebp
  8015f0:	53                   	push   %ebx
  8015f1:	83 ec 14             	sub    $0x14,%esp
  8015f4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8015f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8015fa:	50                   	push   %eax
  8015fb:	53                   	push   %ebx
  8015fc:	e8 b1 fc ff ff       	call   8012b2 <fd_lookup>
  801601:	83 c4 08             	add    $0x8,%esp
  801604:	85 c0                	test   %eax,%eax
  801606:	78 3a                	js     801642 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801608:	83 ec 08             	sub    $0x8,%esp
  80160b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80160e:	50                   	push   %eax
  80160f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801612:	ff 30                	pushl  (%eax)
  801614:	e8 f0 fc ff ff       	call   801309 <dev_lookup>
  801619:	83 c4 10             	add    $0x10,%esp
  80161c:	85 c0                	test   %eax,%eax
  80161e:	78 22                	js     801642 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801627:	74 1e                	je     801647 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801629:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80162c:	8b 52 0c             	mov    0xc(%edx),%edx
  80162f:	85 d2                	test   %edx,%edx
  801631:	74 35                	je     801668 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801633:	83 ec 04             	sub    $0x4,%esp
  801636:	ff 75 10             	pushl  0x10(%ebp)
  801639:	ff 75 0c             	pushl  0xc(%ebp)
  80163c:	50                   	push   %eax
  80163d:	ff d2                	call   *%edx
  80163f:	83 c4 10             	add    $0x10,%esp
}
  801642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801645:	c9                   	leave  
  801646:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801647:	a1 20 44 80 00       	mov    0x804420,%eax
  80164c:	8b 40 48             	mov    0x48(%eax),%eax
  80164f:	83 ec 04             	sub    $0x4,%esp
  801652:	53                   	push   %ebx
  801653:	50                   	push   %eax
  801654:	68 69 29 80 00       	push   $0x802969
  801659:	e8 e7 ec ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  80165e:	83 c4 10             	add    $0x10,%esp
  801661:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801666:	eb da                	jmp    801642 <write+0x55>
		return -E_NOT_SUPP;
  801668:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80166d:	eb d3                	jmp    801642 <write+0x55>

0080166f <seek>:

int
seek(int fdnum, off_t offset)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801675:	8d 45 fc             	lea    -0x4(%ebp),%eax
  801678:	50                   	push   %eax
  801679:	ff 75 08             	pushl  0x8(%ebp)
  80167c:	e8 31 fc ff ff       	call   8012b2 <fd_lookup>
  801681:	83 c4 08             	add    $0x8,%esp
  801684:	85 c0                	test   %eax,%eax
  801686:	78 0e                	js     801696 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  801688:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80168b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80168e:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801691:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801696:	c9                   	leave  
  801697:	c3                   	ret    

00801698 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801698:	55                   	push   %ebp
  801699:	89 e5                	mov    %esp,%ebp
  80169b:	53                   	push   %ebx
  80169c:	83 ec 14             	sub    $0x14,%esp
  80169f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8016a2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8016a5:	50                   	push   %eax
  8016a6:	53                   	push   %ebx
  8016a7:	e8 06 fc ff ff       	call   8012b2 <fd_lookup>
  8016ac:	83 c4 08             	add    $0x8,%esp
  8016af:	85 c0                	test   %eax,%eax
  8016b1:	78 37                	js     8016ea <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016b3:	83 ec 08             	sub    $0x8,%esp
  8016b6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016b9:	50                   	push   %eax
  8016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bd:	ff 30                	pushl  (%eax)
  8016bf:	e8 45 fc ff ff       	call   801309 <dev_lookup>
  8016c4:	83 c4 10             	add    $0x10,%esp
  8016c7:	85 c0                	test   %eax,%eax
  8016c9:	78 1f                	js     8016ea <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8016cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ce:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8016d2:	74 1b                	je     8016ef <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8016d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8016d7:	8b 52 18             	mov    0x18(%edx),%edx
  8016da:	85 d2                	test   %edx,%edx
  8016dc:	74 32                	je     801710 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8016de:	83 ec 08             	sub    $0x8,%esp
  8016e1:	ff 75 0c             	pushl  0xc(%ebp)
  8016e4:	50                   	push   %eax
  8016e5:	ff d2                	call   *%edx
  8016e7:	83 c4 10             	add    $0x10,%esp
}
  8016ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016ed:	c9                   	leave  
  8016ee:	c3                   	ret    
			thisenv->env_id, fdnum);
  8016ef:	a1 20 44 80 00       	mov    0x804420,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8016f4:	8b 40 48             	mov    0x48(%eax),%eax
  8016f7:	83 ec 04             	sub    $0x4,%esp
  8016fa:	53                   	push   %ebx
  8016fb:	50                   	push   %eax
  8016fc:	68 2c 29 80 00       	push   $0x80292c
  801701:	e8 3f ec ff ff       	call   800345 <cprintf>
		return -E_INVAL;
  801706:	83 c4 10             	add    $0x10,%esp
  801709:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170e:	eb da                	jmp    8016ea <ftruncate+0x52>
		return -E_NOT_SUPP;
  801710:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801715:	eb d3                	jmp    8016ea <ftruncate+0x52>

00801717 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801717:	55                   	push   %ebp
  801718:	89 e5                	mov    %esp,%ebp
  80171a:	53                   	push   %ebx
  80171b:	83 ec 14             	sub    $0x14,%esp
  80171e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801721:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801724:	50                   	push   %eax
  801725:	ff 75 08             	pushl  0x8(%ebp)
  801728:	e8 85 fb ff ff       	call   8012b2 <fd_lookup>
  80172d:	83 c4 08             	add    $0x8,%esp
  801730:	85 c0                	test   %eax,%eax
  801732:	78 4b                	js     80177f <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801734:	83 ec 08             	sub    $0x8,%esp
  801737:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80173a:	50                   	push   %eax
  80173b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80173e:	ff 30                	pushl  (%eax)
  801740:	e8 c4 fb ff ff       	call   801309 <dev_lookup>
  801745:	83 c4 10             	add    $0x10,%esp
  801748:	85 c0                	test   %eax,%eax
  80174a:	78 33                	js     80177f <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80174c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801753:	74 2f                	je     801784 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801755:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801758:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80175f:	00 00 00 
	stat->st_type = 0;
  801762:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801769:	00 00 00 
	stat->st_dev = dev;
  80176c:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801772:	83 ec 08             	sub    $0x8,%esp
  801775:	53                   	push   %ebx
  801776:	ff 75 f0             	pushl  -0x10(%ebp)
  801779:	ff 50 14             	call   *0x14(%eax)
  80177c:	83 c4 10             	add    $0x10,%esp
}
  80177f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801782:	c9                   	leave  
  801783:	c3                   	ret    
		return -E_NOT_SUPP;
  801784:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801789:	eb f4                	jmp    80177f <fstat+0x68>

0080178b <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80178b:	55                   	push   %ebp
  80178c:	89 e5                	mov    %esp,%ebp
  80178e:	56                   	push   %esi
  80178f:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	6a 00                	push   $0x0
  801795:	ff 75 08             	pushl  0x8(%ebp)
  801798:	e8 34 02 00 00       	call   8019d1 <open>
  80179d:	89 c3                	mov    %eax,%ebx
  80179f:	83 c4 10             	add    $0x10,%esp
  8017a2:	85 c0                	test   %eax,%eax
  8017a4:	78 1b                	js     8017c1 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8017a6:	83 ec 08             	sub    $0x8,%esp
  8017a9:	ff 75 0c             	pushl  0xc(%ebp)
  8017ac:	50                   	push   %eax
  8017ad:	e8 65 ff ff ff       	call   801717 <fstat>
  8017b2:	89 c6                	mov    %eax,%esi
	close(fd);
  8017b4:	89 1c 24             	mov    %ebx,(%esp)
  8017b7:	e8 29 fc ff ff       	call   8013e5 <close>
	return r;
  8017bc:	83 c4 10             	add    $0x10,%esp
  8017bf:	89 f3                	mov    %esi,%ebx
}
  8017c1:	89 d8                	mov    %ebx,%eax
  8017c3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017c6:	5b                   	pop    %ebx
  8017c7:	5e                   	pop    %esi
  8017c8:	5d                   	pop    %ebp
  8017c9:	c3                   	ret    

008017ca <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	56                   	push   %esi
  8017ce:	53                   	push   %ebx
  8017cf:	89 c6                	mov    %eax,%esi
  8017d1:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8017d3:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8017da:	74 27                	je     801803 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8017dc:	6a 07                	push   $0x7
  8017de:	68 00 50 80 00       	push   $0x805000
  8017e3:	56                   	push   %esi
  8017e4:	ff 35 00 40 80 00    	pushl  0x804000
  8017ea:	e8 a1 08 00 00       	call   802090 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8017ef:	83 c4 0c             	add    $0xc,%esp
  8017f2:	6a 00                	push   $0x0
  8017f4:	53                   	push   %ebx
  8017f5:	6a 00                	push   $0x0
  8017f7:	e8 0b 08 00 00       	call   802007 <ipc_recv>
}
  8017fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017ff:	5b                   	pop    %ebx
  801800:	5e                   	pop    %esi
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	6a 01                	push   $0x1
  801808:	e8 df 08 00 00       	call   8020ec <ipc_find_env>
  80180d:	a3 00 40 80 00       	mov    %eax,0x804000
  801812:	83 c4 10             	add    $0x10,%esp
  801815:	eb c5                	jmp    8017dc <fsipc+0x12>

00801817 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8b 40 0c             	mov    0xc(%eax),%eax
  801823:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801828:	8b 45 0c             	mov    0xc(%ebp),%eax
  80182b:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801830:	ba 00 00 00 00       	mov    $0x0,%edx
  801835:	b8 02 00 00 00       	mov    $0x2,%eax
  80183a:	e8 8b ff ff ff       	call   8017ca <fsipc>
}
  80183f:	c9                   	leave  
  801840:	c3                   	ret    

00801841 <devfile_flush>:
{
  801841:	55                   	push   %ebp
  801842:	89 e5                	mov    %esp,%ebp
  801844:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 40 0c             	mov    0xc(%eax),%eax
  80184d:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801852:	ba 00 00 00 00       	mov    $0x0,%edx
  801857:	b8 06 00 00 00       	mov    $0x6,%eax
  80185c:	e8 69 ff ff ff       	call   8017ca <fsipc>
}
  801861:	c9                   	leave  
  801862:	c3                   	ret    

00801863 <devfile_stat>:
{
  801863:	55                   	push   %ebp
  801864:	89 e5                	mov    %esp,%ebp
  801866:	53                   	push   %ebx
  801867:	83 ec 04             	sub    $0x4,%esp
  80186a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  80186d:	8b 45 08             	mov    0x8(%ebp),%eax
  801870:	8b 40 0c             	mov    0xc(%eax),%eax
  801873:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801878:	ba 00 00 00 00       	mov    $0x0,%edx
  80187d:	b8 05 00 00 00       	mov    $0x5,%eax
  801882:	e8 43 ff ff ff       	call   8017ca <fsipc>
  801887:	85 c0                	test   %eax,%eax
  801889:	78 2c                	js     8018b7 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  80188b:	83 ec 08             	sub    $0x8,%esp
  80188e:	68 00 50 80 00       	push   $0x805000
  801893:	53                   	push   %ebx
  801894:	e8 b4 f0 ff ff       	call   80094d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801899:	a1 80 50 80 00       	mov    0x805080,%eax
  80189e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8018a4:	a1 84 50 80 00       	mov    0x805084,%eax
  8018a9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8018af:	83 c4 10             	add    $0x10,%esp
  8018b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    

008018bc <devfile_write>:
{
  8018bc:	55                   	push   %ebp
  8018bd:	89 e5                	mov    %esp,%ebp
  8018bf:	53                   	push   %ebx
  8018c0:	83 ec 04             	sub    $0x4,%esp
  8018c3:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  8018c6:	89 d8                	mov    %ebx,%eax
  8018c8:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  8018ce:	76 05                	jbe    8018d5 <devfile_write+0x19>
  8018d0:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  8018d5:	8b 55 08             	mov    0x8(%ebp),%edx
  8018d8:	8b 52 0c             	mov    0xc(%edx),%edx
  8018db:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  8018e1:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	50                   	push   %eax
  8018ea:	ff 75 0c             	pushl  0xc(%ebp)
  8018ed:	68 08 50 80 00       	push   $0x805008
  8018f2:	e8 c9 f1 ff ff       	call   800ac0 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8018f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8018fc:	b8 04 00 00 00       	mov    $0x4,%eax
  801901:	e8 c4 fe ff ff       	call   8017ca <fsipc>
  801906:	83 c4 10             	add    $0x10,%esp
  801909:	85 c0                	test   %eax,%eax
  80190b:	78 0b                	js     801918 <devfile_write+0x5c>
	assert(r <= n);
  80190d:	39 c3                	cmp    %eax,%ebx
  80190f:	72 0c                	jb     80191d <devfile_write+0x61>
	assert(r <= PGSIZE);
  801911:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801916:	7f 1e                	jg     801936 <devfile_write+0x7a>
}
  801918:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80191b:	c9                   	leave  
  80191c:	c3                   	ret    
	assert(r <= n);
  80191d:	68 98 29 80 00       	push   $0x802998
  801922:	68 d6 28 80 00       	push   $0x8028d6
  801927:	68 98 00 00 00       	push   $0x98
  80192c:	68 9f 29 80 00       	push   $0x80299f
  801931:	e8 fc e8 ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  801936:	68 aa 29 80 00       	push   $0x8029aa
  80193b:	68 d6 28 80 00       	push   $0x8028d6
  801940:	68 99 00 00 00       	push   $0x99
  801945:	68 9f 29 80 00       	push   $0x80299f
  80194a:	e8 e3 e8 ff ff       	call   800232 <_panic>

0080194f <devfile_read>:
{
  80194f:	55                   	push   %ebp
  801950:	89 e5                	mov    %esp,%ebp
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801957:	8b 45 08             	mov    0x8(%ebp),%eax
  80195a:	8b 40 0c             	mov    0xc(%eax),%eax
  80195d:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801962:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801968:	ba 00 00 00 00       	mov    $0x0,%edx
  80196d:	b8 03 00 00 00       	mov    $0x3,%eax
  801972:	e8 53 fe ff ff       	call   8017ca <fsipc>
  801977:	89 c3                	mov    %eax,%ebx
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 1f                	js     80199c <devfile_read+0x4d>
	assert(r <= n);
  80197d:	39 c6                	cmp    %eax,%esi
  80197f:	72 24                	jb     8019a5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801981:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801986:	7f 33                	jg     8019bb <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801988:	83 ec 04             	sub    $0x4,%esp
  80198b:	50                   	push   %eax
  80198c:	68 00 50 80 00       	push   $0x805000
  801991:	ff 75 0c             	pushl  0xc(%ebp)
  801994:	e8 27 f1 ff ff       	call   800ac0 <memmove>
	return r;
  801999:	83 c4 10             	add    $0x10,%esp
}
  80199c:	89 d8                	mov    %ebx,%eax
  80199e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019a1:	5b                   	pop    %ebx
  8019a2:	5e                   	pop    %esi
  8019a3:	5d                   	pop    %ebp
  8019a4:	c3                   	ret    
	assert(r <= n);
  8019a5:	68 98 29 80 00       	push   $0x802998
  8019aa:	68 d6 28 80 00       	push   $0x8028d6
  8019af:	6a 7c                	push   $0x7c
  8019b1:	68 9f 29 80 00       	push   $0x80299f
  8019b6:	e8 77 e8 ff ff       	call   800232 <_panic>
	assert(r <= PGSIZE);
  8019bb:	68 aa 29 80 00       	push   $0x8029aa
  8019c0:	68 d6 28 80 00       	push   $0x8028d6
  8019c5:	6a 7d                	push   $0x7d
  8019c7:	68 9f 29 80 00       	push   $0x80299f
  8019cc:	e8 61 e8 ff ff       	call   800232 <_panic>

008019d1 <open>:
{
  8019d1:	55                   	push   %ebp
  8019d2:	89 e5                	mov    %esp,%ebp
  8019d4:	56                   	push   %esi
  8019d5:	53                   	push   %ebx
  8019d6:	83 ec 1c             	sub    $0x1c,%esp
  8019d9:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  8019dc:	56                   	push   %esi
  8019dd:	e8 38 ef ff ff       	call   80091a <strlen>
  8019e2:	83 c4 10             	add    $0x10,%esp
  8019e5:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  8019ea:	7f 6c                	jg     801a58 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  8019ec:	83 ec 0c             	sub    $0xc,%esp
  8019ef:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f2:	50                   	push   %eax
  8019f3:	e8 6b f8 ff ff       	call   801263 <fd_alloc>
  8019f8:	89 c3                	mov    %eax,%ebx
  8019fa:	83 c4 10             	add    $0x10,%esp
  8019fd:	85 c0                	test   %eax,%eax
  8019ff:	78 3c                	js     801a3d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801a01:	83 ec 08             	sub    $0x8,%esp
  801a04:	56                   	push   %esi
  801a05:	68 00 50 80 00       	push   $0x805000
  801a0a:	e8 3e ef ff ff       	call   80094d <strcpy>
	fsipcbuf.open.req_omode = mode;
  801a0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a12:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	e8 a6 fd ff ff       	call   8017ca <fsipc>
  801a24:	89 c3                	mov    %eax,%ebx
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	85 c0                	test   %eax,%eax
  801a2b:	78 19                	js     801a46 <open+0x75>
	return fd2num(fd);
  801a2d:	83 ec 0c             	sub    $0xc,%esp
  801a30:	ff 75 f4             	pushl  -0xc(%ebp)
  801a33:	e8 04 f8 ff ff       	call   80123c <fd2num>
  801a38:	89 c3                	mov    %eax,%ebx
  801a3a:	83 c4 10             	add    $0x10,%esp
}
  801a3d:	89 d8                	mov    %ebx,%eax
  801a3f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a42:	5b                   	pop    %ebx
  801a43:	5e                   	pop    %esi
  801a44:	5d                   	pop    %ebp
  801a45:	c3                   	ret    
		fd_close(fd, 0);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	6a 00                	push   $0x0
  801a4b:	ff 75 f4             	pushl  -0xc(%ebp)
  801a4e:	e8 0c f9 ff ff       	call   80135f <fd_close>
		return r;
  801a53:	83 c4 10             	add    $0x10,%esp
  801a56:	eb e5                	jmp    801a3d <open+0x6c>
		return -E_BAD_PATH;
  801a58:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801a5d:	eb de                	jmp    801a3d <open+0x6c>

00801a5f <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801a65:	ba 00 00 00 00       	mov    $0x0,%edx
  801a6a:	b8 08 00 00 00       	mov    $0x8,%eax
  801a6f:	e8 56 fd ff ff       	call   8017ca <fsipc>
}
  801a74:	c9                   	leave  
  801a75:	c3                   	ret    

00801a76 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801a76:	55                   	push   %ebp
  801a77:	89 e5                	mov    %esp,%ebp
  801a79:	56                   	push   %esi
  801a7a:	53                   	push   %ebx
  801a7b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801a7e:	83 ec 0c             	sub    $0xc,%esp
  801a81:	ff 75 08             	pushl  0x8(%ebp)
  801a84:	e8 c3 f7 ff ff       	call   80124c <fd2data>
  801a89:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801a8b:	83 c4 08             	add    $0x8,%esp
  801a8e:	68 b6 29 80 00       	push   $0x8029b6
  801a93:	53                   	push   %ebx
  801a94:	e8 b4 ee ff ff       	call   80094d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801a99:	8b 46 04             	mov    0x4(%esi),%eax
  801a9c:	2b 06                	sub    (%esi),%eax
  801a9e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801aa4:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801aab:	10 00 00 
	stat->st_dev = &devpipe;
  801aae:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801ab5:	30 80 00 
	return 0;
}
  801ab8:	b8 00 00 00 00       	mov    $0x0,%eax
  801abd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ac0:	5b                   	pop    %ebx
  801ac1:	5e                   	pop    %esi
  801ac2:	5d                   	pop    %ebp
  801ac3:	c3                   	ret    

00801ac4 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ac4:	55                   	push   %ebp
  801ac5:	89 e5                	mov    %esp,%ebp
  801ac7:	53                   	push   %ebx
  801ac8:	83 ec 0c             	sub    $0xc,%esp
  801acb:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801ace:	53                   	push   %ebx
  801acf:	6a 00                	push   $0x0
  801ad1:	e8 b1 f2 ff ff       	call   800d87 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801ad6:	89 1c 24             	mov    %ebx,(%esp)
  801ad9:	e8 6e f7 ff ff       	call   80124c <fd2data>
  801ade:	83 c4 08             	add    $0x8,%esp
  801ae1:	50                   	push   %eax
  801ae2:	6a 00                	push   $0x0
  801ae4:	e8 9e f2 ff ff       	call   800d87 <sys_page_unmap>
}
  801ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <_pipeisclosed>:
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
  801af1:	57                   	push   %edi
  801af2:	56                   	push   %esi
  801af3:	53                   	push   %ebx
  801af4:	83 ec 1c             	sub    $0x1c,%esp
  801af7:	89 c7                	mov    %eax,%edi
  801af9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801afb:	a1 20 44 80 00       	mov    0x804420,%eax
  801b00:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801b03:	83 ec 0c             	sub    $0xc,%esp
  801b06:	57                   	push   %edi
  801b07:	e8 22 06 00 00       	call   80212e <pageref>
  801b0c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801b0f:	89 34 24             	mov    %esi,(%esp)
  801b12:	e8 17 06 00 00       	call   80212e <pageref>
		nn = thisenv->env_runs;
  801b17:	8b 15 20 44 80 00    	mov    0x804420,%edx
  801b1d:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801b20:	83 c4 10             	add    $0x10,%esp
  801b23:	39 cb                	cmp    %ecx,%ebx
  801b25:	74 1b                	je     801b42 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801b27:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b2a:	75 cf                	jne    801afb <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801b2c:	8b 42 58             	mov    0x58(%edx),%eax
  801b2f:	6a 01                	push   $0x1
  801b31:	50                   	push   %eax
  801b32:	53                   	push   %ebx
  801b33:	68 bd 29 80 00       	push   $0x8029bd
  801b38:	e8 08 e8 ff ff       	call   800345 <cprintf>
  801b3d:	83 c4 10             	add    $0x10,%esp
  801b40:	eb b9                	jmp    801afb <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801b42:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801b45:	0f 94 c0             	sete   %al
  801b48:	0f b6 c0             	movzbl %al,%eax
}
  801b4b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b4e:	5b                   	pop    %ebx
  801b4f:	5e                   	pop    %esi
  801b50:	5f                   	pop    %edi
  801b51:	5d                   	pop    %ebp
  801b52:	c3                   	ret    

00801b53 <devpipe_write>:
{
  801b53:	55                   	push   %ebp
  801b54:	89 e5                	mov    %esp,%ebp
  801b56:	57                   	push   %edi
  801b57:	56                   	push   %esi
  801b58:	53                   	push   %ebx
  801b59:	83 ec 18             	sub    $0x18,%esp
  801b5c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801b5f:	56                   	push   %esi
  801b60:	e8 e7 f6 ff ff       	call   80124c <fd2data>
  801b65:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	bf 00 00 00 00       	mov    $0x0,%edi
  801b6f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801b72:	74 41                	je     801bb5 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801b74:	8b 53 04             	mov    0x4(%ebx),%edx
  801b77:	8b 03                	mov    (%ebx),%eax
  801b79:	83 c0 20             	add    $0x20,%eax
  801b7c:	39 c2                	cmp    %eax,%edx
  801b7e:	72 14                	jb     801b94 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801b80:	89 da                	mov    %ebx,%edx
  801b82:	89 f0                	mov    %esi,%eax
  801b84:	e8 65 ff ff ff       	call   801aee <_pipeisclosed>
  801b89:	85 c0                	test   %eax,%eax
  801b8b:	75 2c                	jne    801bb9 <devpipe_write+0x66>
			sys_yield();
  801b8d:	e8 37 f2 ff ff       	call   800dc9 <sys_yield>
  801b92:	eb e0                	jmp    801b74 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801b94:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b97:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801b9a:	89 d0                	mov    %edx,%eax
  801b9c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801ba1:	78 0b                	js     801bae <devpipe_write+0x5b>
  801ba3:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801ba7:	42                   	inc    %edx
  801ba8:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801bab:	47                   	inc    %edi
  801bac:	eb c1                	jmp    801b6f <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801bae:	48                   	dec    %eax
  801baf:	83 c8 e0             	or     $0xffffffe0,%eax
  801bb2:	40                   	inc    %eax
  801bb3:	eb ee                	jmp    801ba3 <devpipe_write+0x50>
	return i;
  801bb5:	89 f8                	mov    %edi,%eax
  801bb7:	eb 05                	jmp    801bbe <devpipe_write+0x6b>
				return 0;
  801bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5e                   	pop    %esi
  801bc3:	5f                   	pop    %edi
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    

00801bc6 <devpipe_read>:
{
  801bc6:	55                   	push   %ebp
  801bc7:	89 e5                	mov    %esp,%ebp
  801bc9:	57                   	push   %edi
  801bca:	56                   	push   %esi
  801bcb:	53                   	push   %ebx
  801bcc:	83 ec 18             	sub    $0x18,%esp
  801bcf:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801bd2:	57                   	push   %edi
  801bd3:	e8 74 f6 ff ff       	call   80124c <fd2data>
  801bd8:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
  801be2:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801be5:	74 46                	je     801c2d <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801be7:	8b 06                	mov    (%esi),%eax
  801be9:	3b 46 04             	cmp    0x4(%esi),%eax
  801bec:	75 22                	jne    801c10 <devpipe_read+0x4a>
			if (i > 0)
  801bee:	85 db                	test   %ebx,%ebx
  801bf0:	74 0a                	je     801bfc <devpipe_read+0x36>
				return i;
  801bf2:	89 d8                	mov    %ebx,%eax
}
  801bf4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bf7:	5b                   	pop    %ebx
  801bf8:	5e                   	pop    %esi
  801bf9:	5f                   	pop    %edi
  801bfa:	5d                   	pop    %ebp
  801bfb:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801bfc:	89 f2                	mov    %esi,%edx
  801bfe:	89 f8                	mov    %edi,%eax
  801c00:	e8 e9 fe ff ff       	call   801aee <_pipeisclosed>
  801c05:	85 c0                	test   %eax,%eax
  801c07:	75 28                	jne    801c31 <devpipe_read+0x6b>
			sys_yield();
  801c09:	e8 bb f1 ff ff       	call   800dc9 <sys_yield>
  801c0e:	eb d7                	jmp    801be7 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c10:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801c15:	78 0f                	js     801c26 <devpipe_read+0x60>
  801c17:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801c1b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801c1e:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801c21:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801c23:	43                   	inc    %ebx
  801c24:	eb bc                	jmp    801be2 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801c26:	48                   	dec    %eax
  801c27:	83 c8 e0             	or     $0xffffffe0,%eax
  801c2a:	40                   	inc    %eax
  801c2b:	eb ea                	jmp    801c17 <devpipe_read+0x51>
	return i;
  801c2d:	89 d8                	mov    %ebx,%eax
  801c2f:	eb c3                	jmp    801bf4 <devpipe_read+0x2e>
				return 0;
  801c31:	b8 00 00 00 00       	mov    $0x0,%eax
  801c36:	eb bc                	jmp    801bf4 <devpipe_read+0x2e>

00801c38 <pipe>:
{
  801c38:	55                   	push   %ebp
  801c39:	89 e5                	mov    %esp,%ebp
  801c3b:	56                   	push   %esi
  801c3c:	53                   	push   %ebx
  801c3d:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801c40:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801c43:	50                   	push   %eax
  801c44:	e8 1a f6 ff ff       	call   801263 <fd_alloc>
  801c49:	89 c3                	mov    %eax,%ebx
  801c4b:	83 c4 10             	add    $0x10,%esp
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	0f 88 2a 01 00 00    	js     801d80 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c56:	83 ec 04             	sub    $0x4,%esp
  801c59:	68 07 04 00 00       	push   $0x407
  801c5e:	ff 75 f4             	pushl  -0xc(%ebp)
  801c61:	6a 00                	push   $0x0
  801c63:	e8 9a f0 ff ff       	call   800d02 <sys_page_alloc>
  801c68:	89 c3                	mov    %eax,%ebx
  801c6a:	83 c4 10             	add    $0x10,%esp
  801c6d:	85 c0                	test   %eax,%eax
  801c6f:	0f 88 0b 01 00 00    	js     801d80 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801c75:	83 ec 0c             	sub    $0xc,%esp
  801c78:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801c7b:	50                   	push   %eax
  801c7c:	e8 e2 f5 ff ff       	call   801263 <fd_alloc>
  801c81:	89 c3                	mov    %eax,%ebx
  801c83:	83 c4 10             	add    $0x10,%esp
  801c86:	85 c0                	test   %eax,%eax
  801c88:	0f 88 e2 00 00 00    	js     801d70 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801c8e:	83 ec 04             	sub    $0x4,%esp
  801c91:	68 07 04 00 00       	push   $0x407
  801c96:	ff 75 f0             	pushl  -0x10(%ebp)
  801c99:	6a 00                	push   $0x0
  801c9b:	e8 62 f0 ff ff       	call   800d02 <sys_page_alloc>
  801ca0:	89 c3                	mov    %eax,%ebx
  801ca2:	83 c4 10             	add    $0x10,%esp
  801ca5:	85 c0                	test   %eax,%eax
  801ca7:	0f 88 c3 00 00 00    	js     801d70 <pipe+0x138>
	va = fd2data(fd0);
  801cad:	83 ec 0c             	sub    $0xc,%esp
  801cb0:	ff 75 f4             	pushl  -0xc(%ebp)
  801cb3:	e8 94 f5 ff ff       	call   80124c <fd2data>
  801cb8:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cba:	83 c4 0c             	add    $0xc,%esp
  801cbd:	68 07 04 00 00       	push   $0x407
  801cc2:	50                   	push   %eax
  801cc3:	6a 00                	push   $0x0
  801cc5:	e8 38 f0 ff ff       	call   800d02 <sys_page_alloc>
  801cca:	89 c3                	mov    %eax,%ebx
  801ccc:	83 c4 10             	add    $0x10,%esp
  801ccf:	85 c0                	test   %eax,%eax
  801cd1:	0f 88 89 00 00 00    	js     801d60 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	ff 75 f0             	pushl  -0x10(%ebp)
  801cdd:	e8 6a f5 ff ff       	call   80124c <fd2data>
  801ce2:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801ce9:	50                   	push   %eax
  801cea:	6a 00                	push   $0x0
  801cec:	56                   	push   %esi
  801ced:	6a 00                	push   $0x0
  801cef:	e8 51 f0 ff ff       	call   800d45 <sys_page_map>
  801cf4:	89 c3                	mov    %eax,%ebx
  801cf6:	83 c4 20             	add    $0x20,%esp
  801cf9:	85 c0                	test   %eax,%eax
  801cfb:	78 55                	js     801d52 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801cfd:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d06:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801d12:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801d18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d1b:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801d1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d20:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801d27:	83 ec 0c             	sub    $0xc,%esp
  801d2a:	ff 75 f4             	pushl  -0xc(%ebp)
  801d2d:	e8 0a f5 ff ff       	call   80123c <fd2num>
  801d32:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d35:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801d37:	83 c4 04             	add    $0x4,%esp
  801d3a:	ff 75 f0             	pushl  -0x10(%ebp)
  801d3d:	e8 fa f4 ff ff       	call   80123c <fd2num>
  801d42:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d45:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801d48:	83 c4 10             	add    $0x10,%esp
  801d4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d50:	eb 2e                	jmp    801d80 <pipe+0x148>
	sys_page_unmap(0, va);
  801d52:	83 ec 08             	sub    $0x8,%esp
  801d55:	56                   	push   %esi
  801d56:	6a 00                	push   $0x0
  801d58:	e8 2a f0 ff ff       	call   800d87 <sys_page_unmap>
  801d5d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801d60:	83 ec 08             	sub    $0x8,%esp
  801d63:	ff 75 f0             	pushl  -0x10(%ebp)
  801d66:	6a 00                	push   $0x0
  801d68:	e8 1a f0 ff ff       	call   800d87 <sys_page_unmap>
  801d6d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801d70:	83 ec 08             	sub    $0x8,%esp
  801d73:	ff 75 f4             	pushl  -0xc(%ebp)
  801d76:	6a 00                	push   $0x0
  801d78:	e8 0a f0 ff ff       	call   800d87 <sys_page_unmap>
  801d7d:	83 c4 10             	add    $0x10,%esp
}
  801d80:	89 d8                	mov    %ebx,%eax
  801d82:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d85:	5b                   	pop    %ebx
  801d86:	5e                   	pop    %esi
  801d87:	5d                   	pop    %ebp
  801d88:	c3                   	ret    

00801d89 <pipeisclosed>:
{
  801d89:	55                   	push   %ebp
  801d8a:	89 e5                	mov    %esp,%ebp
  801d8c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801d8f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d92:	50                   	push   %eax
  801d93:	ff 75 08             	pushl  0x8(%ebp)
  801d96:	e8 17 f5 ff ff       	call   8012b2 <fd_lookup>
  801d9b:	83 c4 10             	add    $0x10,%esp
  801d9e:	85 c0                	test   %eax,%eax
  801da0:	78 18                	js     801dba <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801da2:	83 ec 0c             	sub    $0xc,%esp
  801da5:	ff 75 f4             	pushl  -0xc(%ebp)
  801da8:	e8 9f f4 ff ff       	call   80124c <fd2data>
	return _pipeisclosed(fd, p);
  801dad:	89 c2                	mov    %eax,%edx
  801daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db2:	e8 37 fd ff ff       	call   801aee <_pipeisclosed>
  801db7:	83 c4 10             	add    $0x10,%esp
}
  801dba:	c9                   	leave  
  801dbb:	c3                   	ret    

00801dbc <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  801dbc:	55                   	push   %ebp
  801dbd:	89 e5                	mov    %esp,%ebp
  801dbf:	56                   	push   %esi
  801dc0:	53                   	push   %ebx
  801dc1:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  801dc4:	85 f6                	test   %esi,%esi
  801dc6:	74 18                	je     801de0 <wait+0x24>
	e = &envs[ENVX(envid)];
  801dc8:	89 f2                	mov    %esi,%edx
  801dca:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801dd0:	89 d0                	mov    %edx,%eax
  801dd2:	c1 e0 05             	shl    $0x5,%eax
  801dd5:	29 d0                	sub    %edx,%eax
  801dd7:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  801dde:	eb 1b                	jmp    801dfb <wait+0x3f>
	assert(envid != 0);
  801de0:	68 d5 29 80 00       	push   $0x8029d5
  801de5:	68 d6 28 80 00       	push   $0x8028d6
  801dea:	6a 09                	push   $0x9
  801dec:	68 e0 29 80 00       	push   $0x8029e0
  801df1:	e8 3c e4 ff ff       	call   800232 <_panic>
		sys_yield();
  801df6:	e8 ce ef ff ff       	call   800dc9 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  801dfb:	8b 43 48             	mov    0x48(%ebx),%eax
  801dfe:	39 c6                	cmp    %eax,%esi
  801e00:	75 07                	jne    801e09 <wait+0x4d>
  801e02:	8b 43 54             	mov    0x54(%ebx),%eax
  801e05:	85 c0                	test   %eax,%eax
  801e07:	75 ed                	jne    801df6 <wait+0x3a>
}
  801e09:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e0c:	5b                   	pop    %ebx
  801e0d:	5e                   	pop    %esi
  801e0e:	5d                   	pop    %ebp
  801e0f:	c3                   	ret    

00801e10 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801e13:	b8 00 00 00 00       	mov    $0x0,%eax
  801e18:	5d                   	pop    %ebp
  801e19:	c3                   	ret    

00801e1a <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
  801e1d:	53                   	push   %ebx
  801e1e:	83 ec 0c             	sub    $0xc,%esp
  801e21:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801e24:	68 eb 29 80 00       	push   $0x8029eb
  801e29:	53                   	push   %ebx
  801e2a:	e8 1e eb ff ff       	call   80094d <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801e2f:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801e36:	20 00 00 
	return 0;
}
  801e39:	b8 00 00 00 00       	mov    $0x0,%eax
  801e3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e41:	c9                   	leave  
  801e42:	c3                   	ret    

00801e43 <devcons_write>:
{
  801e43:	55                   	push   %ebp
  801e44:	89 e5                	mov    %esp,%ebp
  801e46:	57                   	push   %edi
  801e47:	56                   	push   %esi
  801e48:	53                   	push   %ebx
  801e49:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801e4f:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801e54:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801e5a:	eb 1d                	jmp    801e79 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	53                   	push   %ebx
  801e60:	03 45 0c             	add    0xc(%ebp),%eax
  801e63:	50                   	push   %eax
  801e64:	57                   	push   %edi
  801e65:	e8 56 ec ff ff       	call   800ac0 <memmove>
		sys_cputs(buf, m);
  801e6a:	83 c4 08             	add    $0x8,%esp
  801e6d:	53                   	push   %ebx
  801e6e:	57                   	push   %edi
  801e6f:	e8 f1 ed ff ff       	call   800c65 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801e74:	01 de                	add    %ebx,%esi
  801e76:	83 c4 10             	add    $0x10,%esp
  801e79:	89 f0                	mov    %esi,%eax
  801e7b:	3b 75 10             	cmp    0x10(%ebp),%esi
  801e7e:	73 11                	jae    801e91 <devcons_write+0x4e>
		m = n - tot;
  801e80:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801e83:	29 f3                	sub    %esi,%ebx
  801e85:	83 fb 7f             	cmp    $0x7f,%ebx
  801e88:	76 d2                	jbe    801e5c <devcons_write+0x19>
  801e8a:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801e8f:	eb cb                	jmp    801e5c <devcons_write+0x19>
}
  801e91:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e94:	5b                   	pop    %ebx
  801e95:	5e                   	pop    %esi
  801e96:	5f                   	pop    %edi
  801e97:	5d                   	pop    %ebp
  801e98:	c3                   	ret    

00801e99 <devcons_read>:
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801e9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ea3:	75 0c                	jne    801eb1 <devcons_read+0x18>
		return 0;
  801ea5:	b8 00 00 00 00       	mov    $0x0,%eax
  801eaa:	eb 21                	jmp    801ecd <devcons_read+0x34>
		sys_yield();
  801eac:	e8 18 ef ff ff       	call   800dc9 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801eb1:	e8 cd ed ff ff       	call   800c83 <sys_cgetc>
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	74 f2                	je     801eac <devcons_read+0x13>
	if (c < 0)
  801eba:	85 c0                	test   %eax,%eax
  801ebc:	78 0f                	js     801ecd <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801ebe:	83 f8 04             	cmp    $0x4,%eax
  801ec1:	74 0c                	je     801ecf <devcons_read+0x36>
	*(char*)vbuf = c;
  801ec3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec6:	88 02                	mov    %al,(%edx)
	return 1;
  801ec8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ecd:	c9                   	leave  
  801ece:	c3                   	ret    
		return 0;
  801ecf:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed4:	eb f7                	jmp    801ecd <devcons_read+0x34>

00801ed6 <cputchar>:
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
  801ed9:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801ee2:	6a 01                	push   $0x1
  801ee4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801ee7:	50                   	push   %eax
  801ee8:	e8 78 ed ff ff       	call   800c65 <sys_cputs>
}
  801eed:	83 c4 10             	add    $0x10,%esp
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <getchar>:
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801ef8:	6a 01                	push   $0x1
  801efa:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801efd:	50                   	push   %eax
  801efe:	6a 00                	push   $0x0
  801f00:	e8 1a f6 ff ff       	call   80151f <read>
	if (r < 0)
  801f05:	83 c4 10             	add    $0x10,%esp
  801f08:	85 c0                	test   %eax,%eax
  801f0a:	78 08                	js     801f14 <getchar+0x22>
	if (r < 1)
  801f0c:	85 c0                	test   %eax,%eax
  801f0e:	7e 06                	jle    801f16 <getchar+0x24>
	return c;
  801f10:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    
		return -E_EOF;
  801f16:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801f1b:	eb f7                	jmp    801f14 <getchar+0x22>

00801f1d <iscons>:
{
  801f1d:	55                   	push   %ebp
  801f1e:	89 e5                	mov    %esp,%ebp
  801f20:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f23:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f26:	50                   	push   %eax
  801f27:	ff 75 08             	pushl  0x8(%ebp)
  801f2a:	e8 83 f3 ff ff       	call   8012b2 <fd_lookup>
  801f2f:	83 c4 10             	add    $0x10,%esp
  801f32:	85 c0                	test   %eax,%eax
  801f34:	78 11                	js     801f47 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f39:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f3f:	39 10                	cmp    %edx,(%eax)
  801f41:	0f 94 c0             	sete   %al
  801f44:	0f b6 c0             	movzbl %al,%eax
}
  801f47:	c9                   	leave  
  801f48:	c3                   	ret    

00801f49 <opencons>:
{
  801f49:	55                   	push   %ebp
  801f4a:	89 e5                	mov    %esp,%ebp
  801f4c:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801f4f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f52:	50                   	push   %eax
  801f53:	e8 0b f3 ff ff       	call   801263 <fd_alloc>
  801f58:	83 c4 10             	add    $0x10,%esp
  801f5b:	85 c0                	test   %eax,%eax
  801f5d:	78 3a                	js     801f99 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	68 07 04 00 00       	push   $0x407
  801f67:	ff 75 f4             	pushl  -0xc(%ebp)
  801f6a:	6a 00                	push   $0x0
  801f6c:	e8 91 ed ff ff       	call   800d02 <sys_page_alloc>
  801f71:	83 c4 10             	add    $0x10,%esp
  801f74:	85 c0                	test   %eax,%eax
  801f76:	78 21                	js     801f99 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801f78:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f81:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	50                   	push   %eax
  801f91:	e8 a6 f2 ff ff       	call   80123c <fd2num>
  801f96:	83 c4 10             	add    $0x10,%esp
}
  801f99:	c9                   	leave  
  801f9a:	c3                   	ret    

00801f9b <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801f9b:	55                   	push   %ebp
  801f9c:	89 e5                	mov    %esp,%ebp
  801f9e:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801fa1:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801fa8:	74 0a                	je     801fb4 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801faa:	8b 45 08             	mov    0x8(%ebp),%eax
  801fad:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801fb2:	c9                   	leave  
  801fb3:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801fb4:	e8 2a ed ff ff       	call   800ce3 <sys_getenvid>
  801fb9:	83 ec 04             	sub    $0x4,%esp
  801fbc:	6a 07                	push   $0x7
  801fbe:	68 00 f0 bf ee       	push   $0xeebff000
  801fc3:	50                   	push   %eax
  801fc4:	e8 39 ed ff ff       	call   800d02 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801fc9:	e8 15 ed ff ff       	call   800ce3 <sys_getenvid>
  801fce:	83 c4 08             	add    $0x8,%esp
  801fd1:	68 e1 1f 80 00       	push   $0x801fe1
  801fd6:	50                   	push   %eax
  801fd7:	e8 d1 ee ff ff       	call   800ead <sys_env_set_pgfault_upcall>
  801fdc:	83 c4 10             	add    $0x10,%esp
  801fdf:	eb c9                	jmp    801faa <set_pgfault_handler+0xf>

00801fe1 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  801fe1:	54                   	push   %esp
	movl _pgfault_handler, %eax
  801fe2:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  801fe7:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  801fe9:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  801fec:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  801ff0:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  801ff4:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  801ff7:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  801ff9:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  801ffd:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802000:	61                   	popa   
	addl $4, %esp
  802001:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802004:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802005:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802006:	c3                   	ret    

00802007 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802007:	55                   	push   %ebp
  802008:	89 e5                	mov    %esp,%ebp
  80200a:	57                   	push   %edi
  80200b:	56                   	push   %esi
  80200c:	53                   	push   %ebx
  80200d:	83 ec 0c             	sub    $0xc,%esp
  802010:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802013:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802016:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  802019:	85 ff                	test   %edi,%edi
  80201b:	74 53                	je     802070 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	57                   	push   %edi
  802021:	e8 ec ee ff ff       	call   800f12 <sys_ipc_recv>
  802026:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  802029:	85 db                	test   %ebx,%ebx
  80202b:	74 0b                	je     802038 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80202d:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802033:	8b 52 74             	mov    0x74(%edx),%edx
  802036:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  802038:	85 f6                	test   %esi,%esi
  80203a:	74 0f                	je     80204b <ipc_recv+0x44>
  80203c:	85 ff                	test   %edi,%edi
  80203e:	74 0b                	je     80204b <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802040:	8b 15 20 44 80 00    	mov    0x804420,%edx
  802046:	8b 52 78             	mov    0x78(%edx),%edx
  802049:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  80204b:	85 c0                	test   %eax,%eax
  80204d:	74 30                	je     80207f <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  80204f:	85 db                	test   %ebx,%ebx
  802051:	74 06                	je     802059 <ipc_recv+0x52>
      		*from_env_store = 0;
  802053:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  802059:	85 f6                	test   %esi,%esi
  80205b:	74 2c                	je     802089 <ipc_recv+0x82>
      		*perm_store = 0;
  80205d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  802063:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  802068:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80206b:	5b                   	pop    %ebx
  80206c:	5e                   	pop    %esi
  80206d:	5f                   	pop    %edi
  80206e:	5d                   	pop    %ebp
  80206f:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  802070:	83 ec 0c             	sub    $0xc,%esp
  802073:	6a ff                	push   $0xffffffff
  802075:	e8 98 ee ff ff       	call   800f12 <sys_ipc_recv>
  80207a:	83 c4 10             	add    $0x10,%esp
  80207d:	eb aa                	jmp    802029 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  80207f:	a1 20 44 80 00       	mov    0x804420,%eax
  802084:	8b 40 70             	mov    0x70(%eax),%eax
  802087:	eb df                	jmp    802068 <ipc_recv+0x61>
		return -1;
  802089:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  80208e:	eb d8                	jmp    802068 <ipc_recv+0x61>

00802090 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  802090:	55                   	push   %ebp
  802091:	89 e5                	mov    %esp,%ebp
  802093:	57                   	push   %edi
  802094:	56                   	push   %esi
  802095:	53                   	push   %ebx
  802096:	83 ec 0c             	sub    $0xc,%esp
  802099:	8b 75 0c             	mov    0xc(%ebp),%esi
  80209c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80209f:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8020a2:	85 db                	test   %ebx,%ebx
  8020a4:	75 22                	jne    8020c8 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8020a6:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8020ab:	eb 1b                	jmp    8020c8 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8020ad:	68 f8 29 80 00       	push   $0x8029f8
  8020b2:	68 d6 28 80 00       	push   $0x8028d6
  8020b7:	6a 48                	push   $0x48
  8020b9:	68 1c 2a 80 00       	push   $0x802a1c
  8020be:	e8 6f e1 ff ff       	call   800232 <_panic>
		sys_yield();
  8020c3:	e8 01 ed ff ff       	call   800dc9 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8020c8:	57                   	push   %edi
  8020c9:	53                   	push   %ebx
  8020ca:	56                   	push   %esi
  8020cb:	ff 75 08             	pushl  0x8(%ebp)
  8020ce:	e8 1c ee ff ff       	call   800eef <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8020d3:	83 c4 10             	add    $0x10,%esp
  8020d6:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8020d9:	74 e8                	je     8020c3 <ipc_send+0x33>
  8020db:	85 c0                	test   %eax,%eax
  8020dd:	75 ce                	jne    8020ad <ipc_send+0x1d>
		sys_yield();
  8020df:	e8 e5 ec ff ff       	call   800dc9 <sys_yield>
		
	}
	
}
  8020e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020e7:	5b                   	pop    %ebx
  8020e8:	5e                   	pop    %esi
  8020e9:	5f                   	pop    %edi
  8020ea:	5d                   	pop    %ebp
  8020eb:	c3                   	ret    

008020ec <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  8020ec:	55                   	push   %ebp
  8020ed:	89 e5                	mov    %esp,%ebp
  8020ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  8020f7:	89 c2                	mov    %eax,%edx
  8020f9:	c1 e2 05             	shl    $0x5,%edx
  8020fc:	29 c2                	sub    %eax,%edx
  8020fe:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802105:	8b 52 50             	mov    0x50(%edx),%edx
  802108:	39 ca                	cmp    %ecx,%edx
  80210a:	74 0f                	je     80211b <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80210c:	40                   	inc    %eax
  80210d:	3d 00 04 00 00       	cmp    $0x400,%eax
  802112:	75 e3                	jne    8020f7 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802114:	b8 00 00 00 00       	mov    $0x0,%eax
  802119:	eb 11                	jmp    80212c <ipc_find_env+0x40>
			return envs[i].env_id;
  80211b:	89 c2                	mov    %eax,%edx
  80211d:	c1 e2 05             	shl    $0x5,%edx
  802120:	29 c2                	sub    %eax,%edx
  802122:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  802129:	8b 40 48             	mov    0x48(%eax),%eax
}
  80212c:	5d                   	pop    %ebp
  80212d:	c3                   	ret    

0080212e <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  80212e:	55                   	push   %ebp
  80212f:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	c1 e8 16             	shr    $0x16,%eax
  802137:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80213e:	a8 01                	test   $0x1,%al
  802140:	74 21                	je     802163 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802142:	8b 45 08             	mov    0x8(%ebp),%eax
  802145:	c1 e8 0c             	shr    $0xc,%eax
  802148:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  80214f:	a8 01                	test   $0x1,%al
  802151:	74 17                	je     80216a <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802153:	c1 e8 0c             	shr    $0xc,%eax
  802156:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80215d:	ef 
  80215e:	0f b7 c0             	movzwl %ax,%eax
  802161:	eb 05                	jmp    802168 <pageref+0x3a>
		return 0;
  802163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802168:	5d                   	pop    %ebp
  802169:	c3                   	ret    
		return 0;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
  80216f:	eb f7                	jmp    802168 <pageref+0x3a>
  802171:	66 90                	xchg   %ax,%ax
  802173:	90                   	nop

00802174 <__udivdi3>:
  802174:	55                   	push   %ebp
  802175:	57                   	push   %edi
  802176:	56                   	push   %esi
  802177:	53                   	push   %ebx
  802178:	83 ec 1c             	sub    $0x1c,%esp
  80217b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80217f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802183:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802187:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80218b:	89 ca                	mov    %ecx,%edx
  80218d:	89 f8                	mov    %edi,%eax
  80218f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802193:	85 f6                	test   %esi,%esi
  802195:	75 2d                	jne    8021c4 <__udivdi3+0x50>
  802197:	39 cf                	cmp    %ecx,%edi
  802199:	77 65                	ja     802200 <__udivdi3+0x8c>
  80219b:	89 fd                	mov    %edi,%ebp
  80219d:	85 ff                	test   %edi,%edi
  80219f:	75 0b                	jne    8021ac <__udivdi3+0x38>
  8021a1:	b8 01 00 00 00       	mov    $0x1,%eax
  8021a6:	31 d2                	xor    %edx,%edx
  8021a8:	f7 f7                	div    %edi
  8021aa:	89 c5                	mov    %eax,%ebp
  8021ac:	31 d2                	xor    %edx,%edx
  8021ae:	89 c8                	mov    %ecx,%eax
  8021b0:	f7 f5                	div    %ebp
  8021b2:	89 c1                	mov    %eax,%ecx
  8021b4:	89 d8                	mov    %ebx,%eax
  8021b6:	f7 f5                	div    %ebp
  8021b8:	89 cf                	mov    %ecx,%edi
  8021ba:	89 fa                	mov    %edi,%edx
  8021bc:	83 c4 1c             	add    $0x1c,%esp
  8021bf:	5b                   	pop    %ebx
  8021c0:	5e                   	pop    %esi
  8021c1:	5f                   	pop    %edi
  8021c2:	5d                   	pop    %ebp
  8021c3:	c3                   	ret    
  8021c4:	39 ce                	cmp    %ecx,%esi
  8021c6:	77 28                	ja     8021f0 <__udivdi3+0x7c>
  8021c8:	0f bd fe             	bsr    %esi,%edi
  8021cb:	83 f7 1f             	xor    $0x1f,%edi
  8021ce:	75 40                	jne    802210 <__udivdi3+0x9c>
  8021d0:	39 ce                	cmp    %ecx,%esi
  8021d2:	72 0a                	jb     8021de <__udivdi3+0x6a>
  8021d4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8021d8:	0f 87 9e 00 00 00    	ja     80227c <__udivdi3+0x108>
  8021de:	b8 01 00 00 00       	mov    $0x1,%eax
  8021e3:	89 fa                	mov    %edi,%edx
  8021e5:	83 c4 1c             	add    $0x1c,%esp
  8021e8:	5b                   	pop    %ebx
  8021e9:	5e                   	pop    %esi
  8021ea:	5f                   	pop    %edi
  8021eb:	5d                   	pop    %ebp
  8021ec:	c3                   	ret    
  8021ed:	8d 76 00             	lea    0x0(%esi),%esi
  8021f0:	31 ff                	xor    %edi,%edi
  8021f2:	31 c0                	xor    %eax,%eax
  8021f4:	89 fa                	mov    %edi,%edx
  8021f6:	83 c4 1c             	add    $0x1c,%esp
  8021f9:	5b                   	pop    %ebx
  8021fa:	5e                   	pop    %esi
  8021fb:	5f                   	pop    %edi
  8021fc:	5d                   	pop    %ebp
  8021fd:	c3                   	ret    
  8021fe:	66 90                	xchg   %ax,%ax
  802200:	89 d8                	mov    %ebx,%eax
  802202:	f7 f7                	div    %edi
  802204:	31 ff                	xor    %edi,%edi
  802206:	89 fa                	mov    %edi,%edx
  802208:	83 c4 1c             	add    $0x1c,%esp
  80220b:	5b                   	pop    %ebx
  80220c:	5e                   	pop    %esi
  80220d:	5f                   	pop    %edi
  80220e:	5d                   	pop    %ebp
  80220f:	c3                   	ret    
  802210:	bd 20 00 00 00       	mov    $0x20,%ebp
  802215:	29 fd                	sub    %edi,%ebp
  802217:	89 f9                	mov    %edi,%ecx
  802219:	d3 e6                	shl    %cl,%esi
  80221b:	89 c3                	mov    %eax,%ebx
  80221d:	89 e9                	mov    %ebp,%ecx
  80221f:	d3 eb                	shr    %cl,%ebx
  802221:	89 d9                	mov    %ebx,%ecx
  802223:	09 f1                	or     %esi,%ecx
  802225:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802229:	89 f9                	mov    %edi,%ecx
  80222b:	d3 e0                	shl    %cl,%eax
  80222d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802231:	89 d6                	mov    %edx,%esi
  802233:	89 e9                	mov    %ebp,%ecx
  802235:	d3 ee                	shr    %cl,%esi
  802237:	89 f9                	mov    %edi,%ecx
  802239:	d3 e2                	shl    %cl,%edx
  80223b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80223f:	89 e9                	mov    %ebp,%ecx
  802241:	d3 eb                	shr    %cl,%ebx
  802243:	09 da                	or     %ebx,%edx
  802245:	89 d0                	mov    %edx,%eax
  802247:	89 f2                	mov    %esi,%edx
  802249:	f7 74 24 08          	divl   0x8(%esp)
  80224d:	89 d6                	mov    %edx,%esi
  80224f:	89 c3                	mov    %eax,%ebx
  802251:	f7 64 24 0c          	mull   0xc(%esp)
  802255:	39 d6                	cmp    %edx,%esi
  802257:	72 17                	jb     802270 <__udivdi3+0xfc>
  802259:	74 09                	je     802264 <__udivdi3+0xf0>
  80225b:	89 d8                	mov    %ebx,%eax
  80225d:	31 ff                	xor    %edi,%edi
  80225f:	e9 56 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  802264:	8b 54 24 04          	mov    0x4(%esp),%edx
  802268:	89 f9                	mov    %edi,%ecx
  80226a:	d3 e2                	shl    %cl,%edx
  80226c:	39 c2                	cmp    %eax,%edx
  80226e:	73 eb                	jae    80225b <__udivdi3+0xe7>
  802270:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802273:	31 ff                	xor    %edi,%edi
  802275:	e9 40 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  80227a:	66 90                	xchg   %ax,%ax
  80227c:	31 c0                	xor    %eax,%eax
  80227e:	e9 37 ff ff ff       	jmp    8021ba <__udivdi3+0x46>
  802283:	90                   	nop

00802284 <__umoddi3>:
  802284:	55                   	push   %ebp
  802285:	57                   	push   %edi
  802286:	56                   	push   %esi
  802287:	53                   	push   %ebx
  802288:	83 ec 1c             	sub    $0x1c,%esp
  80228b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80228f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802293:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802297:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80229b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80229f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8022a3:	89 3c 24             	mov    %edi,(%esp)
  8022a6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8022aa:	89 f2                	mov    %esi,%edx
  8022ac:	85 c0                	test   %eax,%eax
  8022ae:	75 18                	jne    8022c8 <__umoddi3+0x44>
  8022b0:	39 f7                	cmp    %esi,%edi
  8022b2:	0f 86 a0 00 00 00    	jbe    802358 <__umoddi3+0xd4>
  8022b8:	89 c8                	mov    %ecx,%eax
  8022ba:	f7 f7                	div    %edi
  8022bc:	89 d0                	mov    %edx,%eax
  8022be:	31 d2                	xor    %edx,%edx
  8022c0:	83 c4 1c             	add    $0x1c,%esp
  8022c3:	5b                   	pop    %ebx
  8022c4:	5e                   	pop    %esi
  8022c5:	5f                   	pop    %edi
  8022c6:	5d                   	pop    %ebp
  8022c7:	c3                   	ret    
  8022c8:	89 f3                	mov    %esi,%ebx
  8022ca:	39 f0                	cmp    %esi,%eax
  8022cc:	0f 87 a6 00 00 00    	ja     802378 <__umoddi3+0xf4>
  8022d2:	0f bd e8             	bsr    %eax,%ebp
  8022d5:	83 f5 1f             	xor    $0x1f,%ebp
  8022d8:	0f 84 a6 00 00 00    	je     802384 <__umoddi3+0x100>
  8022de:	bf 20 00 00 00       	mov    $0x20,%edi
  8022e3:	29 ef                	sub    %ebp,%edi
  8022e5:	89 e9                	mov    %ebp,%ecx
  8022e7:	d3 e0                	shl    %cl,%eax
  8022e9:	8b 34 24             	mov    (%esp),%esi
  8022ec:	89 f2                	mov    %esi,%edx
  8022ee:	89 f9                	mov    %edi,%ecx
  8022f0:	d3 ea                	shr    %cl,%edx
  8022f2:	09 c2                	or     %eax,%edx
  8022f4:	89 14 24             	mov    %edx,(%esp)
  8022f7:	89 f2                	mov    %esi,%edx
  8022f9:	89 e9                	mov    %ebp,%ecx
  8022fb:	d3 e2                	shl    %cl,%edx
  8022fd:	89 54 24 04          	mov    %edx,0x4(%esp)
  802301:	89 de                	mov    %ebx,%esi
  802303:	89 f9                	mov    %edi,%ecx
  802305:	d3 ee                	shr    %cl,%esi
  802307:	89 e9                	mov    %ebp,%ecx
  802309:	d3 e3                	shl    %cl,%ebx
  80230b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80230f:	89 d0                	mov    %edx,%eax
  802311:	89 f9                	mov    %edi,%ecx
  802313:	d3 e8                	shr    %cl,%eax
  802315:	09 d8                	or     %ebx,%eax
  802317:	89 d3                	mov    %edx,%ebx
  802319:	89 e9                	mov    %ebp,%ecx
  80231b:	d3 e3                	shl    %cl,%ebx
  80231d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802321:	89 f2                	mov    %esi,%edx
  802323:	f7 34 24             	divl   (%esp)
  802326:	89 d6                	mov    %edx,%esi
  802328:	f7 64 24 04          	mull   0x4(%esp)
  80232c:	89 c3                	mov    %eax,%ebx
  80232e:	89 d1                	mov    %edx,%ecx
  802330:	39 d6                	cmp    %edx,%esi
  802332:	72 7c                	jb     8023b0 <__umoddi3+0x12c>
  802334:	74 72                	je     8023a8 <__umoddi3+0x124>
  802336:	8b 54 24 08          	mov    0x8(%esp),%edx
  80233a:	29 da                	sub    %ebx,%edx
  80233c:	19 ce                	sbb    %ecx,%esi
  80233e:	89 f0                	mov    %esi,%eax
  802340:	89 f9                	mov    %edi,%ecx
  802342:	d3 e0                	shl    %cl,%eax
  802344:	89 e9                	mov    %ebp,%ecx
  802346:	d3 ea                	shr    %cl,%edx
  802348:	09 d0                	or     %edx,%eax
  80234a:	89 e9                	mov    %ebp,%ecx
  80234c:	d3 ee                	shr    %cl,%esi
  80234e:	89 f2                	mov    %esi,%edx
  802350:	83 c4 1c             	add    $0x1c,%esp
  802353:	5b                   	pop    %ebx
  802354:	5e                   	pop    %esi
  802355:	5f                   	pop    %edi
  802356:	5d                   	pop    %ebp
  802357:	c3                   	ret    
  802358:	89 fd                	mov    %edi,%ebp
  80235a:	85 ff                	test   %edi,%edi
  80235c:	75 0b                	jne    802369 <__umoddi3+0xe5>
  80235e:	b8 01 00 00 00       	mov    $0x1,%eax
  802363:	31 d2                	xor    %edx,%edx
  802365:	f7 f7                	div    %edi
  802367:	89 c5                	mov    %eax,%ebp
  802369:	89 f0                	mov    %esi,%eax
  80236b:	31 d2                	xor    %edx,%edx
  80236d:	f7 f5                	div    %ebp
  80236f:	89 c8                	mov    %ecx,%eax
  802371:	f7 f5                	div    %ebp
  802373:	e9 44 ff ff ff       	jmp    8022bc <__umoddi3+0x38>
  802378:	89 c8                	mov    %ecx,%eax
  80237a:	89 f2                	mov    %esi,%edx
  80237c:	83 c4 1c             	add    $0x1c,%esp
  80237f:	5b                   	pop    %ebx
  802380:	5e                   	pop    %esi
  802381:	5f                   	pop    %edi
  802382:	5d                   	pop    %ebp
  802383:	c3                   	ret    
  802384:	39 f0                	cmp    %esi,%eax
  802386:	72 05                	jb     80238d <__umoddi3+0x109>
  802388:	39 0c 24             	cmp    %ecx,(%esp)
  80238b:	77 0c                	ja     802399 <__umoddi3+0x115>
  80238d:	89 f2                	mov    %esi,%edx
  80238f:	29 f9                	sub    %edi,%ecx
  802391:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802395:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802399:	8b 44 24 04          	mov    0x4(%esp),%eax
  80239d:	83 c4 1c             	add    $0x1c,%esp
  8023a0:	5b                   	pop    %ebx
  8023a1:	5e                   	pop    %esi
  8023a2:	5f                   	pop    %edi
  8023a3:	5d                   	pop    %ebp
  8023a4:	c3                   	ret    
  8023a5:	8d 76 00             	lea    0x0(%esi),%esi
  8023a8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8023ac:	73 88                	jae    802336 <__umoddi3+0xb2>
  8023ae:	66 90                	xchg   %ax,%ax
  8023b0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023b4:	1b 14 24             	sbb    (%esp),%edx
  8023b7:	89 d1                	mov    %edx,%ecx
  8023b9:	89 c3                	mov    %eax,%ebx
  8023bb:	e9 76 ff ff ff       	jmp    802336 <__umoddi3+0xb2>
