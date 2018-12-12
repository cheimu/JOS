
obj/user/testpiperace.debug:     file format elf32-i386


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
  80002c:	e8 e1 01 00 00       	call   800212 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	83 ec 1c             	sub    $0x1c,%esp
	int p[2], r, pid, i, max;
	void *va;
	struct Fd *fd;
	const volatile struct Env *kid;

	cprintf("testing for dup race...\n");
  80003b:	68 c0 23 80 00       	push   $0x8023c0
  800040:	e8 46 03 00 00       	call   80038b <cprintf>
	if ((r = pipe(p)) < 0)
  800045:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800048:	89 04 24             	mov    %eax,(%esp)
  80004b:	e8 98 1d 00 00       	call   801de8 <pipe>
  800050:	83 c4 10             	add    $0x10,%esp
  800053:	85 c0                	test   %eax,%eax
  800055:	78 7f                	js     8000d6 <umain+0xa3>
		panic("pipe: %e", r);
	max = 200;
	if ((r = fork()) < 0)
  800057:	e8 65 10 00 00       	call   8010c1 <fork>
  80005c:	89 c6                	mov    %eax,%esi
  80005e:	85 c0                	test   %eax,%eax
  800060:	0f 88 82 00 00 00    	js     8000e8 <umain+0xb5>
		panic("fork: %e", r);
	if (r == 0) {
  800066:	85 c0                	test   %eax,%eax
  800068:	0f 84 8c 00 00 00    	je     8000fa <umain+0xc7>
		}
		// do something to be not runnable besides exiting
		ipc_recv(0,0,0);
	}
	pid = r;
	cprintf("pid is %d\n", pid);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	56                   	push   %esi
  800072:	68 1a 24 80 00       	push   $0x80241a
  800077:	e8 0f 03 00 00       	call   80038b <cprintf>
	va = 0;
	kid = &envs[ENVX(pid)];
  80007c:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
	cprintf("kid is %d\n", kid-envs);
  800082:	83 c4 08             	add    $0x8,%esp
  800085:	89 f2                	mov    %esi,%edx
  800087:	c1 e2 05             	shl    $0x5,%edx
  80008a:	89 d0                	mov    %edx,%eax
  80008c:	29 f0                	sub    %esi,%eax
  80008e:	89 c2                	mov    %eax,%edx
  800090:	c1 e2 05             	shl    $0x5,%edx
  800093:	01 c2                	add    %eax,%edx
  800095:	c1 e2 05             	shl    $0x5,%edx
  800098:	01 c2                	add    %eax,%edx
  80009a:	89 d1                	mov    %edx,%ecx
  80009c:	c1 e1 0f             	shl    $0xf,%ecx
  80009f:	01 ca                	add    %ecx,%edx
  8000a1:	c1 e2 05             	shl    $0x5,%edx
  8000a4:	01 c2                	add    %eax,%edx
  8000a6:	f7 da                	neg    %edx
  8000a8:	52                   	push   %edx
  8000a9:	68 25 24 80 00       	push   $0x802425
  8000ae:	e8 d8 02 00 00       	call   80038b <cprintf>
	dup(p[0], 10);
  8000b3:	83 c4 08             	add    $0x8,%esp
  8000b6:	6a 0a                	push   $0xa
  8000b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8000bb:	e8 e0 14 00 00       	call   8015a0 <dup>
	while (kid->env_status == ENV_RUNNABLE)
  8000c0:	83 c4 10             	add    $0x10,%esp
  8000c3:	89 f0                	mov    %esi,%eax
  8000c5:	c1 e0 05             	shl    $0x5,%eax
  8000c8:	29 f0                	sub    %esi,%eax
  8000ca:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  8000d1:	e9 90 00 00 00       	jmp    800166 <umain+0x133>
		panic("pipe: %e", r);
  8000d6:	50                   	push   %eax
  8000d7:	68 d9 23 80 00       	push   $0x8023d9
  8000dc:	6a 0d                	push   $0xd
  8000de:	68 e2 23 80 00       	push   $0x8023e2
  8000e3:	e8 90 01 00 00       	call   800278 <_panic>
		panic("fork: %e", r);
  8000e8:	50                   	push   %eax
  8000e9:	68 f6 23 80 00       	push   $0x8023f6
  8000ee:	6a 10                	push   $0x10
  8000f0:	68 e2 23 80 00       	push   $0x8023e2
  8000f5:	e8 7e 01 00 00       	call   800278 <_panic>
		close(p[1]);
  8000fa:	83 ec 0c             	sub    $0xc,%esp
  8000fd:	ff 75 f4             	pushl  -0xc(%ebp)
  800100:	e8 4d 14 00 00       	call   801552 <close>
  800105:	83 c4 10             	add    $0x10,%esp
  800108:	bb c8 00 00 00       	mov    $0xc8,%ebx
  80010d:	eb 08                	jmp    800117 <umain+0xe4>
			sys_yield();
  80010f:	e8 fb 0c 00 00       	call   800e0f <sys_yield>
		for (i=0; i<max; i++) {
  800114:	4b                   	dec    %ebx
  800115:	74 29                	je     800140 <umain+0x10d>
			if(pipeisclosed(p[0])){
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	ff 75 f0             	pushl  -0x10(%ebp)
  80011d:	e8 17 1e 00 00       	call   801f39 <pipeisclosed>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	74 e6                	je     80010f <umain+0xdc>
				cprintf("RACE: pipe appears closed\n");
  800129:	83 ec 0c             	sub    $0xc,%esp
  80012c:	68 ff 23 80 00       	push   $0x8023ff
  800131:	e8 55 02 00 00       	call   80038b <cprintf>
				exit();
  800136:	e8 23 01 00 00       	call   80025e <exit>
  80013b:	83 c4 10             	add    $0x10,%esp
  80013e:	eb cf                	jmp    80010f <umain+0xdc>
		ipc_recv(0,0,0);
  800140:	83 ec 04             	sub    $0x4,%esp
  800143:	6a 00                	push   $0x0
  800145:	6a 00                	push   $0x0
  800147:	6a 00                	push   $0x0
  800149:	e8 34 11 00 00       	call   801282 <ipc_recv>
  80014e:	83 c4 10             	add    $0x10,%esp
  800151:	e9 18 ff ff ff       	jmp    80006e <umain+0x3b>
		dup(p[0], 10);
  800156:	83 ec 08             	sub    $0x8,%esp
  800159:	6a 0a                	push   $0xa
  80015b:	ff 75 f0             	pushl  -0x10(%ebp)
  80015e:	e8 3d 14 00 00       	call   8015a0 <dup>
  800163:	83 c4 10             	add    $0x10,%esp
	while (kid->env_status == ENV_RUNNABLE)
  800166:	8b 43 54             	mov    0x54(%ebx),%eax
  800169:	83 f8 02             	cmp    $0x2,%eax
  80016c:	74 e8                	je     800156 <umain+0x123>

	cprintf("child done with loop\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 30 24 80 00       	push   $0x802430
  800176:	e8 10 02 00 00       	call   80038b <cprintf>
	if (pipeisclosed(p[0]))
  80017b:	83 c4 04             	add    $0x4,%esp
  80017e:	ff 75 f0             	pushl  -0x10(%ebp)
  800181:	e8 b3 1d 00 00       	call   801f39 <pipeisclosed>
  800186:	83 c4 10             	add    $0x10,%esp
  800189:	85 c0                	test   %eax,%eax
  80018b:	75 48                	jne    8001d5 <umain+0x1a2>
		panic("somehow the other end of p[0] got closed!");
	if ((r = fd_lookup(p[0], &fd)) < 0)
  80018d:	83 ec 08             	sub    $0x8,%esp
  800190:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800193:	50                   	push   %eax
  800194:	ff 75 f0             	pushl  -0x10(%ebp)
  800197:	e8 83 12 00 00       	call   80141f <fd_lookup>
  80019c:	83 c4 10             	add    $0x10,%esp
  80019f:	85 c0                	test   %eax,%eax
  8001a1:	78 46                	js     8001e9 <umain+0x1b6>
		panic("cannot look up p[0]: %e", r);
	va = fd2data(fd);
  8001a3:	83 ec 0c             	sub    $0xc,%esp
  8001a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a9:	e8 0b 12 00 00       	call   8013b9 <fd2data>
	if (pageref(va) != 3+1)
  8001ae:	89 04 24             	mov    %eax,(%esp)
  8001b1:	e8 2d 1a 00 00       	call   801be3 <pageref>
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	83 f8 04             	cmp    $0x4,%eax
  8001bc:	74 3d                	je     8001fb <umain+0x1c8>
		cprintf("\nchild detected race\n");
  8001be:	83 ec 0c             	sub    $0xc,%esp
  8001c1:	68 5e 24 80 00       	push   $0x80245e
  8001c6:	e8 c0 01 00 00       	call   80038b <cprintf>
  8001cb:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("\nrace didn't happen\n", max);
}
  8001ce:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5d                   	pop    %ebp
  8001d4:	c3                   	ret    
		panic("somehow the other end of p[0] got closed!");
  8001d5:	83 ec 04             	sub    $0x4,%esp
  8001d8:	68 8c 24 80 00       	push   $0x80248c
  8001dd:	6a 3a                	push   $0x3a
  8001df:	68 e2 23 80 00       	push   $0x8023e2
  8001e4:	e8 8f 00 00 00       	call   800278 <_panic>
		panic("cannot look up p[0]: %e", r);
  8001e9:	50                   	push   %eax
  8001ea:	68 46 24 80 00       	push   $0x802446
  8001ef:	6a 3c                	push   $0x3c
  8001f1:	68 e2 23 80 00       	push   $0x8023e2
  8001f6:	e8 7d 00 00 00       	call   800278 <_panic>
		cprintf("\nrace didn't happen\n", max);
  8001fb:	83 ec 08             	sub    $0x8,%esp
  8001fe:	68 c8 00 00 00       	push   $0xc8
  800203:	68 74 24 80 00       	push   $0x802474
  800208:	e8 7e 01 00 00       	call   80038b <cprintf>
  80020d:	83 c4 10             	add    $0x10,%esp
}
  800210:	eb bc                	jmp    8001ce <umain+0x19b>

00800212 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800212:	55                   	push   %ebp
  800213:	89 e5                	mov    %esp,%ebp
  800215:	56                   	push   %esi
  800216:	53                   	push   %ebx
  800217:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80021a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80021d:	e8 07 0b 00 00       	call   800d29 <sys_getenvid>
  800222:	25 ff 03 00 00       	and    $0x3ff,%eax
  800227:	89 c2                	mov    %eax,%edx
  800229:	c1 e2 05             	shl    $0x5,%edx
  80022c:	29 c2                	sub    %eax,%edx
  80022e:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800235:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	85 db                	test   %ebx,%ebx
  80023c:	7e 07                	jle    800245 <libmain+0x33>
		binaryname = argv[0];
  80023e:	8b 06                	mov    (%esi),%eax
  800240:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800245:	83 ec 08             	sub    $0x8,%esp
  800248:	56                   	push   %esi
  800249:	53                   	push   %ebx
  80024a:	e8 e4 fd ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80024f:	e8 0a 00 00 00       	call   80025e <exit>
}
  800254:	83 c4 10             	add    $0x10,%esp
  800257:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80025a:	5b                   	pop    %ebx
  80025b:	5e                   	pop    %esi
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    

0080025e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800264:	e8 14 13 00 00       	call   80157d <close_all>
	sys_env_destroy(0);
  800269:	83 ec 0c             	sub    $0xc,%esp
  80026c:	6a 00                	push   $0x0
  80026e:	e8 75 0a 00 00       	call   800ce8 <sys_env_destroy>
}
  800273:	83 c4 10             	add    $0x10,%esp
  800276:	c9                   	leave  
  800277:	c3                   	ret    

00800278 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800278:	55                   	push   %ebp
  800279:	89 e5                	mov    %esp,%ebp
  80027b:	57                   	push   %edi
  80027c:	56                   	push   %esi
  80027d:	53                   	push   %ebx
  80027e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800284:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800287:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  80028d:	e8 97 0a 00 00       	call   800d29 <sys_getenvid>
  800292:	83 ec 04             	sub    $0x4,%esp
  800295:	ff 75 0c             	pushl  0xc(%ebp)
  800298:	ff 75 08             	pushl  0x8(%ebp)
  80029b:	53                   	push   %ebx
  80029c:	50                   	push   %eax
  80029d:	68 c0 24 80 00       	push   $0x8024c0
  8002a2:	68 00 01 00 00       	push   $0x100
  8002a7:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  8002ad:	56                   	push   %esi
  8002ae:	e8 93 06 00 00       	call   800946 <snprintf>
  8002b3:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  8002b5:	83 c4 20             	add    $0x20,%esp
  8002b8:	57                   	push   %edi
  8002b9:	ff 75 10             	pushl  0x10(%ebp)
  8002bc:	bf 00 01 00 00       	mov    $0x100,%edi
  8002c1:	89 f8                	mov    %edi,%eax
  8002c3:	29 d8                	sub    %ebx,%eax
  8002c5:	50                   	push   %eax
  8002c6:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8002c9:	50                   	push   %eax
  8002ca:	e8 22 06 00 00       	call   8008f1 <vsnprintf>
  8002cf:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8002d1:	83 c4 0c             	add    $0xc,%esp
  8002d4:	68 d7 23 80 00       	push   $0x8023d7
  8002d9:	29 df                	sub    %ebx,%edi
  8002db:	57                   	push   %edi
  8002dc:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8002df:	50                   	push   %eax
  8002e0:	e8 61 06 00 00       	call   800946 <snprintf>
	sys_cputs(buf, r);
  8002e5:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8002e8:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8002ea:	53                   	push   %ebx
  8002eb:	56                   	push   %esi
  8002ec:	e8 ba 09 00 00       	call   800cab <sys_cputs>
  8002f1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8002f4:	cc                   	int3   
  8002f5:	eb fd                	jmp    8002f4 <_panic+0x7c>

008002f7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8002f7:	55                   	push   %ebp
  8002f8:	89 e5                	mov    %esp,%ebp
  8002fa:	53                   	push   %ebx
  8002fb:	83 ec 04             	sub    $0x4,%esp
  8002fe:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800301:	8b 13                	mov    (%ebx),%edx
  800303:	8d 42 01             	lea    0x1(%edx),%eax
  800306:	89 03                	mov    %eax,(%ebx)
  800308:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80030b:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80030f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800314:	74 08                	je     80031e <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800316:	ff 43 04             	incl   0x4(%ebx)
}
  800319:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80031c:	c9                   	leave  
  80031d:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  80031e:	83 ec 08             	sub    $0x8,%esp
  800321:	68 ff 00 00 00       	push   $0xff
  800326:	8d 43 08             	lea    0x8(%ebx),%eax
  800329:	50                   	push   %eax
  80032a:	e8 7c 09 00 00       	call   800cab <sys_cputs>
		b->idx = 0;
  80032f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	eb dc                	jmp    800316 <putch+0x1f>

0080033a <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800343:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80034a:	00 00 00 
	b.cnt = 0;
  80034d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800354:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800357:	ff 75 0c             	pushl  0xc(%ebp)
  80035a:	ff 75 08             	pushl  0x8(%ebp)
  80035d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800363:	50                   	push   %eax
  800364:	68 f7 02 80 00       	push   $0x8002f7
  800369:	e8 17 01 00 00       	call   800485 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80036e:	83 c4 08             	add    $0x8,%esp
  800371:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800377:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80037d:	50                   	push   %eax
  80037e:	e8 28 09 00 00       	call   800cab <sys_cputs>

	return b.cnt;
}
  800383:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800389:	c9                   	leave  
  80038a:	c3                   	ret    

0080038b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800391:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800394:	50                   	push   %eax
  800395:	ff 75 08             	pushl  0x8(%ebp)
  800398:	e8 9d ff ff ff       	call   80033a <vcprintf>
	va_end(ap);

	return cnt;
}
  80039d:	c9                   	leave  
  80039e:	c3                   	ret    

0080039f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80039f:	55                   	push   %ebp
  8003a0:	89 e5                	mov    %esp,%ebp
  8003a2:	57                   	push   %edi
  8003a3:	56                   	push   %esi
  8003a4:	53                   	push   %ebx
  8003a5:	83 ec 1c             	sub    $0x1c,%esp
  8003a8:	89 c7                	mov    %eax,%edi
  8003aa:	89 d6                	mov    %edx,%esi
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003b2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8003b5:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8003bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8003c0:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8003c3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  8003c6:	39 d3                	cmp    %edx,%ebx
  8003c8:	72 05                	jb     8003cf <printnum+0x30>
  8003ca:	39 45 10             	cmp    %eax,0x10(%ebp)
  8003cd:	77 78                	ja     800447 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8003cf:	83 ec 0c             	sub    $0xc,%esp
  8003d2:	ff 75 18             	pushl  0x18(%ebp)
  8003d5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003d8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8003db:	53                   	push   %ebx
  8003dc:	ff 75 10             	pushl  0x10(%ebp)
  8003df:	83 ec 08             	sub    $0x8,%esp
  8003e2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8003e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8003e8:	ff 75 dc             	pushl  -0x24(%ebp)
  8003eb:	ff 75 d8             	pushl  -0x28(%ebp)
  8003ee:	e8 71 1d 00 00       	call   802164 <__udivdi3>
  8003f3:	83 c4 18             	add    $0x18,%esp
  8003f6:	52                   	push   %edx
  8003f7:	50                   	push   %eax
  8003f8:	89 f2                	mov    %esi,%edx
  8003fa:	89 f8                	mov    %edi,%eax
  8003fc:	e8 9e ff ff ff       	call   80039f <printnum>
  800401:	83 c4 20             	add    $0x20,%esp
  800404:	eb 11                	jmp    800417 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	56                   	push   %esi
  80040a:	ff 75 18             	pushl  0x18(%ebp)
  80040d:	ff d7                	call   *%edi
  80040f:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800412:	4b                   	dec    %ebx
  800413:	85 db                	test   %ebx,%ebx
  800415:	7f ef                	jg     800406 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800417:	83 ec 08             	sub    $0x8,%esp
  80041a:	56                   	push   %esi
  80041b:	83 ec 04             	sub    $0x4,%esp
  80041e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800421:	ff 75 e0             	pushl  -0x20(%ebp)
  800424:	ff 75 dc             	pushl  -0x24(%ebp)
  800427:	ff 75 d8             	pushl  -0x28(%ebp)
  80042a:	e8 45 1e 00 00       	call   802274 <__umoddi3>
  80042f:	83 c4 14             	add    $0x14,%esp
  800432:	0f be 80 e3 24 80 00 	movsbl 0x8024e3(%eax),%eax
  800439:	50                   	push   %eax
  80043a:	ff d7                	call   *%edi
}
  80043c:	83 c4 10             	add    $0x10,%esp
  80043f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800442:	5b                   	pop    %ebx
  800443:	5e                   	pop    %esi
  800444:	5f                   	pop    %edi
  800445:	5d                   	pop    %ebp
  800446:	c3                   	ret    
  800447:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80044a:	eb c6                	jmp    800412 <printnum+0x73>

0080044c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80044c:	55                   	push   %ebp
  80044d:	89 e5                	mov    %esp,%ebp
  80044f:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800452:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800455:	8b 10                	mov    (%eax),%edx
  800457:	3b 50 04             	cmp    0x4(%eax),%edx
  80045a:	73 0a                	jae    800466 <sprintputch+0x1a>
		*b->buf++ = ch;
  80045c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80045f:	89 08                	mov    %ecx,(%eax)
  800461:	8b 45 08             	mov    0x8(%ebp),%eax
  800464:	88 02                	mov    %al,(%edx)
}
  800466:	5d                   	pop    %ebp
  800467:	c3                   	ret    

00800468 <printfmt>:
{
  800468:	55                   	push   %ebp
  800469:	89 e5                	mov    %esp,%ebp
  80046b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80046e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800471:	50                   	push   %eax
  800472:	ff 75 10             	pushl  0x10(%ebp)
  800475:	ff 75 0c             	pushl  0xc(%ebp)
  800478:	ff 75 08             	pushl  0x8(%ebp)
  80047b:	e8 05 00 00 00       	call   800485 <vprintfmt>
}
  800480:	83 c4 10             	add    $0x10,%esp
  800483:	c9                   	leave  
  800484:	c3                   	ret    

00800485 <vprintfmt>:
{
  800485:	55                   	push   %ebp
  800486:	89 e5                	mov    %esp,%ebp
  800488:	57                   	push   %edi
  800489:	56                   	push   %esi
  80048a:	53                   	push   %ebx
  80048b:	83 ec 2c             	sub    $0x2c,%esp
  80048e:	8b 75 08             	mov    0x8(%ebp),%esi
  800491:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800494:	8b 7d 10             	mov    0x10(%ebp),%edi
  800497:	e9 ae 03 00 00       	jmp    80084a <vprintfmt+0x3c5>
  80049c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8004a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8004a7:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8004ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  8004b5:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  8004ba:	8d 47 01             	lea    0x1(%edi),%eax
  8004bd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8004c0:	8a 17                	mov    (%edi),%dl
  8004c2:	8d 42 dd             	lea    -0x23(%edx),%eax
  8004c5:	3c 55                	cmp    $0x55,%al
  8004c7:	0f 87 fe 03 00 00    	ja     8008cb <vprintfmt+0x446>
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	ff 24 85 20 26 80 00 	jmp    *0x802620(,%eax,4)
  8004d7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8004da:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8004de:	eb da                	jmp    8004ba <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004e0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8004e3:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8004e7:	eb d1                	jmp    8004ba <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8004e9:	0f b6 d2             	movzbl %dl,%edx
  8004ec:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8004ef:	b8 00 00 00 00       	mov    $0x0,%eax
  8004f4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8004f7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8004fa:	01 c0                	add    %eax,%eax
  8004fc:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800500:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800503:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800506:	83 f9 09             	cmp    $0x9,%ecx
  800509:	77 52                	ja     80055d <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80050b:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80050c:	eb e9                	jmp    8004f7 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80050e:	8b 45 14             	mov    0x14(%ebp),%eax
  800511:	8b 00                	mov    (%eax),%eax
  800513:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800516:	8b 45 14             	mov    0x14(%ebp),%eax
  800519:	8d 40 04             	lea    0x4(%eax),%eax
  80051c:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  80051f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800522:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800526:	79 92                	jns    8004ba <vprintfmt+0x35>
				width = precision, precision = -1;
  800528:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80052b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80052e:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800535:	eb 83                	jmp    8004ba <vprintfmt+0x35>
  800537:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80053b:	78 08                	js     800545 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  80053d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800540:	e9 75 ff ff ff       	jmp    8004ba <vprintfmt+0x35>
  800545:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80054c:	eb ef                	jmp    80053d <vprintfmt+0xb8>
  80054e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800551:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800558:	e9 5d ff ff ff       	jmp    8004ba <vprintfmt+0x35>
  80055d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800560:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800563:	eb bd                	jmp    800522 <vprintfmt+0x9d>
			lflag++;
  800565:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800566:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800569:	e9 4c ff ff ff       	jmp    8004ba <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80056e:	8b 45 14             	mov    0x14(%ebp),%eax
  800571:	8d 78 04             	lea    0x4(%eax),%edi
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	53                   	push   %ebx
  800578:	ff 30                	pushl  (%eax)
  80057a:	ff d6                	call   *%esi
			break;
  80057c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80057f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800582:	e9 c0 02 00 00       	jmp    800847 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800587:	8b 45 14             	mov    0x14(%ebp),%eax
  80058a:	8d 78 04             	lea    0x4(%eax),%edi
  80058d:	8b 00                	mov    (%eax),%eax
  80058f:	85 c0                	test   %eax,%eax
  800591:	78 2a                	js     8005bd <vprintfmt+0x138>
  800593:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800595:	83 f8 0f             	cmp    $0xf,%eax
  800598:	7f 27                	jg     8005c1 <vprintfmt+0x13c>
  80059a:	8b 04 85 80 27 80 00 	mov    0x802780(,%eax,4),%eax
  8005a1:	85 c0                	test   %eax,%eax
  8005a3:	74 1c                	je     8005c1 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8005a5:	50                   	push   %eax
  8005a6:	68 a8 28 80 00       	push   $0x8028a8
  8005ab:	53                   	push   %ebx
  8005ac:	56                   	push   %esi
  8005ad:	e8 b6 fe ff ff       	call   800468 <printfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005b5:	89 7d 14             	mov    %edi,0x14(%ebp)
  8005b8:	e9 8a 02 00 00       	jmp    800847 <vprintfmt+0x3c2>
  8005bd:	f7 d8                	neg    %eax
  8005bf:	eb d2                	jmp    800593 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  8005c1:	52                   	push   %edx
  8005c2:	68 fb 24 80 00       	push   $0x8024fb
  8005c7:	53                   	push   %ebx
  8005c8:	56                   	push   %esi
  8005c9:	e8 9a fe ff ff       	call   800468 <printfmt>
  8005ce:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8005d1:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8005d4:	e9 6e 02 00 00       	jmp    800847 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8005d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8005dc:	83 c0 04             	add    $0x4,%eax
  8005df:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8005e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8005e5:	8b 38                	mov    (%eax),%edi
  8005e7:	85 ff                	test   %edi,%edi
  8005e9:	74 39                	je     800624 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8005eb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8005ef:	0f 8e a9 00 00 00    	jle    80069e <vprintfmt+0x219>
  8005f5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8005f9:	0f 84 a7 00 00 00    	je     8006a6 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 d0             	pushl  -0x30(%ebp)
  800605:	57                   	push   %edi
  800606:	e8 6b 03 00 00       	call   800976 <strnlen>
  80060b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80060e:	29 c1                	sub    %eax,%ecx
  800610:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800613:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800616:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80061a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80061d:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800620:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800622:	eb 14                	jmp    800638 <vprintfmt+0x1b3>
				p = "(null)";
  800624:	bf f4 24 80 00       	mov    $0x8024f4,%edi
  800629:	eb c0                	jmp    8005eb <vprintfmt+0x166>
					putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	53                   	push   %ebx
  80062f:	ff 75 e0             	pushl  -0x20(%ebp)
  800632:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800634:	4f                   	dec    %edi
  800635:	83 c4 10             	add    $0x10,%esp
  800638:	85 ff                	test   %edi,%edi
  80063a:	7f ef                	jg     80062b <vprintfmt+0x1a6>
  80063c:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  80063f:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800642:	89 c8                	mov    %ecx,%eax
  800644:	85 c9                	test   %ecx,%ecx
  800646:	78 10                	js     800658 <vprintfmt+0x1d3>
  800648:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  80064b:	29 c1                	sub    %eax,%ecx
  80064d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800650:	89 75 08             	mov    %esi,0x8(%ebp)
  800653:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800656:	eb 15                	jmp    80066d <vprintfmt+0x1e8>
  800658:	b8 00 00 00 00       	mov    $0x0,%eax
  80065d:	eb e9                	jmp    800648 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	53                   	push   %ebx
  800663:	52                   	push   %edx
  800664:	ff 55 08             	call   *0x8(%ebp)
  800667:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80066a:	ff 4d e0             	decl   -0x20(%ebp)
  80066d:	47                   	inc    %edi
  80066e:	8a 47 ff             	mov    -0x1(%edi),%al
  800671:	0f be d0             	movsbl %al,%edx
  800674:	85 d2                	test   %edx,%edx
  800676:	74 59                	je     8006d1 <vprintfmt+0x24c>
  800678:	85 f6                	test   %esi,%esi
  80067a:	78 03                	js     80067f <vprintfmt+0x1fa>
  80067c:	4e                   	dec    %esi
  80067d:	78 2f                	js     8006ae <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80067f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800683:	74 da                	je     80065f <vprintfmt+0x1da>
  800685:	0f be c0             	movsbl %al,%eax
  800688:	83 e8 20             	sub    $0x20,%eax
  80068b:	83 f8 5e             	cmp    $0x5e,%eax
  80068e:	76 cf                	jbe    80065f <vprintfmt+0x1da>
					putch('?', putdat);
  800690:	83 ec 08             	sub    $0x8,%esp
  800693:	53                   	push   %ebx
  800694:	6a 3f                	push   $0x3f
  800696:	ff 55 08             	call   *0x8(%ebp)
  800699:	83 c4 10             	add    $0x10,%esp
  80069c:	eb cc                	jmp    80066a <vprintfmt+0x1e5>
  80069e:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006a4:	eb c7                	jmp    80066d <vprintfmt+0x1e8>
  8006a6:	89 75 08             	mov    %esi,0x8(%ebp)
  8006a9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8006ac:	eb bf                	jmp    80066d <vprintfmt+0x1e8>
  8006ae:	8b 75 08             	mov    0x8(%ebp),%esi
  8006b1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006b4:	eb 0c                	jmp    8006c2 <vprintfmt+0x23d>
				putch(' ', putdat);
  8006b6:	83 ec 08             	sub    $0x8,%esp
  8006b9:	53                   	push   %ebx
  8006ba:	6a 20                	push   $0x20
  8006bc:	ff d6                	call   *%esi
			for (; width > 0; width--)
  8006be:	4f                   	dec    %edi
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	85 ff                	test   %edi,%edi
  8006c4:	7f f0                	jg     8006b6 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  8006c6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8006c9:	89 45 14             	mov    %eax,0x14(%ebp)
  8006cc:	e9 76 01 00 00       	jmp    800847 <vprintfmt+0x3c2>
  8006d1:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8006d4:	8b 75 08             	mov    0x8(%ebp),%esi
  8006d7:	eb e9                	jmp    8006c2 <vprintfmt+0x23d>
	if (lflag >= 2)
  8006d9:	83 f9 01             	cmp    $0x1,%ecx
  8006dc:	7f 1f                	jg     8006fd <vprintfmt+0x278>
	else if (lflag)
  8006de:	85 c9                	test   %ecx,%ecx
  8006e0:	75 48                	jne    80072a <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8006ea:	89 c1                	mov    %eax,%ecx
  8006ec:	c1 f9 1f             	sar    $0x1f,%ecx
  8006ef:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	8d 40 04             	lea    0x4(%eax),%eax
  8006f8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006fb:	eb 17                	jmp    800714 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8b 50 04             	mov    0x4(%eax),%edx
  800703:	8b 00                	mov    (%eax),%eax
  800705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800708:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80070b:	8b 45 14             	mov    0x14(%ebp),%eax
  80070e:	8d 40 08             	lea    0x8(%eax),%eax
  800711:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800714:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800717:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80071a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80071e:	78 25                	js     800745 <vprintfmt+0x2c0>
			base = 10;
  800720:	b8 0a 00 00 00       	mov    $0xa,%eax
  800725:	e9 03 01 00 00       	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  80072a:	8b 45 14             	mov    0x14(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800732:	89 c1                	mov    %eax,%ecx
  800734:	c1 f9 1f             	sar    $0x1f,%ecx
  800737:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80073a:	8b 45 14             	mov    0x14(%ebp),%eax
  80073d:	8d 40 04             	lea    0x4(%eax),%eax
  800740:	89 45 14             	mov    %eax,0x14(%ebp)
  800743:	eb cf                	jmp    800714 <vprintfmt+0x28f>
				putch('-', putdat);
  800745:	83 ec 08             	sub    $0x8,%esp
  800748:	53                   	push   %ebx
  800749:	6a 2d                	push   $0x2d
  80074b:	ff d6                	call   *%esi
				num = -(long long) num;
  80074d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800750:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800753:	f7 da                	neg    %edx
  800755:	83 d1 00             	adc    $0x0,%ecx
  800758:	f7 d9                	neg    %ecx
  80075a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80075d:	b8 0a 00 00 00       	mov    $0xa,%eax
  800762:	e9 c6 00 00 00       	jmp    80082d <vprintfmt+0x3a8>
	if (lflag >= 2)
  800767:	83 f9 01             	cmp    $0x1,%ecx
  80076a:	7f 1e                	jg     80078a <vprintfmt+0x305>
	else if (lflag)
  80076c:	85 c9                	test   %ecx,%ecx
  80076e:	75 32                	jne    8007a2 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	8b 10                	mov    (%eax),%edx
  800775:	b9 00 00 00 00       	mov    $0x0,%ecx
  80077a:	8d 40 04             	lea    0x4(%eax),%eax
  80077d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800780:	b8 0a 00 00 00       	mov    $0xa,%eax
  800785:	e9 a3 00 00 00       	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80078a:	8b 45 14             	mov    0x14(%ebp),%eax
  80078d:	8b 10                	mov    (%eax),%edx
  80078f:	8b 48 04             	mov    0x4(%eax),%ecx
  800792:	8d 40 08             	lea    0x8(%eax),%eax
  800795:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800798:	b8 0a 00 00 00       	mov    $0xa,%eax
  80079d:	e9 8b 00 00 00       	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a5:	8b 10                	mov    (%eax),%edx
  8007a7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007ac:	8d 40 04             	lea    0x4(%eax),%eax
  8007af:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  8007b2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8007b7:	eb 74                	jmp    80082d <vprintfmt+0x3a8>
	if (lflag >= 2)
  8007b9:	83 f9 01             	cmp    $0x1,%ecx
  8007bc:	7f 1b                	jg     8007d9 <vprintfmt+0x354>
	else if (lflag)
  8007be:	85 c9                	test   %ecx,%ecx
  8007c0:	75 2c                	jne    8007ee <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	8b 10                	mov    (%eax),%edx
  8007c7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007cc:	8d 40 04             	lea    0x4(%eax),%eax
  8007cf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007d2:	b8 08 00 00 00       	mov    $0x8,%eax
  8007d7:	eb 54                	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8007d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007dc:	8b 10                	mov    (%eax),%edx
  8007de:	8b 48 04             	mov    0x4(%eax),%ecx
  8007e1:	8d 40 08             	lea    0x8(%eax),%eax
  8007e4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007e7:	b8 08 00 00 00       	mov    $0x8,%eax
  8007ec:	eb 3f                	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8007ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8007f1:	8b 10                	mov    (%eax),%edx
  8007f3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8007f8:	8d 40 04             	lea    0x4(%eax),%eax
  8007fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8007fe:	b8 08 00 00 00       	mov    $0x8,%eax
  800803:	eb 28                	jmp    80082d <vprintfmt+0x3a8>
			putch('0', putdat);
  800805:	83 ec 08             	sub    $0x8,%esp
  800808:	53                   	push   %ebx
  800809:	6a 30                	push   $0x30
  80080b:	ff d6                	call   *%esi
			putch('x', putdat);
  80080d:	83 c4 08             	add    $0x8,%esp
  800810:	53                   	push   %ebx
  800811:	6a 78                	push   $0x78
  800813:	ff d6                	call   *%esi
			num = (unsigned long long)
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8b 10                	mov    (%eax),%edx
  80081a:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  80081f:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800822:	8d 40 04             	lea    0x4(%eax),%eax
  800825:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800828:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80082d:	83 ec 0c             	sub    $0xc,%esp
  800830:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800834:	57                   	push   %edi
  800835:	ff 75 e0             	pushl  -0x20(%ebp)
  800838:	50                   	push   %eax
  800839:	51                   	push   %ecx
  80083a:	52                   	push   %edx
  80083b:	89 da                	mov    %ebx,%edx
  80083d:	89 f0                	mov    %esi,%eax
  80083f:	e8 5b fb ff ff       	call   80039f <printnum>
			break;
  800844:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800847:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084a:	47                   	inc    %edi
  80084b:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  80084f:	83 f8 25             	cmp    $0x25,%eax
  800852:	0f 84 44 fc ff ff    	je     80049c <vprintfmt+0x17>
			if (ch == '\0')
  800858:	85 c0                	test   %eax,%eax
  80085a:	0f 84 89 00 00 00    	je     8008e9 <vprintfmt+0x464>
			putch(ch, putdat);
  800860:	83 ec 08             	sub    $0x8,%esp
  800863:	53                   	push   %ebx
  800864:	50                   	push   %eax
  800865:	ff d6                	call   *%esi
  800867:	83 c4 10             	add    $0x10,%esp
  80086a:	eb de                	jmp    80084a <vprintfmt+0x3c5>
	if (lflag >= 2)
  80086c:	83 f9 01             	cmp    $0x1,%ecx
  80086f:	7f 1b                	jg     80088c <vprintfmt+0x407>
	else if (lflag)
  800871:	85 c9                	test   %ecx,%ecx
  800873:	75 2c                	jne    8008a1 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	8b 10                	mov    (%eax),%edx
  80087a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80087f:	8d 40 04             	lea    0x4(%eax),%eax
  800882:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800885:	b8 10 00 00 00       	mov    $0x10,%eax
  80088a:	eb a1                	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 10                	mov    (%eax),%edx
  800891:	8b 48 04             	mov    0x4(%eax),%ecx
  800894:	8d 40 08             	lea    0x8(%eax),%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80089a:	b8 10 00 00 00       	mov    $0x10,%eax
  80089f:	eb 8c                	jmp    80082d <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8008a1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a4:	8b 10                	mov    (%eax),%edx
  8008a6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8008ab:	8d 40 04             	lea    0x4(%eax),%eax
  8008ae:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8008b1:	b8 10 00 00 00       	mov    $0x10,%eax
  8008b6:	e9 72 ff ff ff       	jmp    80082d <vprintfmt+0x3a8>
			putch(ch, putdat);
  8008bb:	83 ec 08             	sub    $0x8,%esp
  8008be:	53                   	push   %ebx
  8008bf:	6a 25                	push   $0x25
  8008c1:	ff d6                	call   *%esi
			break;
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	e9 7c ff ff ff       	jmp    800847 <vprintfmt+0x3c2>
			putch('%', putdat);
  8008cb:	83 ec 08             	sub    $0x8,%esp
  8008ce:	53                   	push   %ebx
  8008cf:	6a 25                	push   $0x25
  8008d1:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008d3:	83 c4 10             	add    $0x10,%esp
  8008d6:	89 f8                	mov    %edi,%eax
  8008d8:	eb 01                	jmp    8008db <vprintfmt+0x456>
  8008da:	48                   	dec    %eax
  8008db:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8008df:	75 f9                	jne    8008da <vprintfmt+0x455>
  8008e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008e4:	e9 5e ff ff ff       	jmp    800847 <vprintfmt+0x3c2>
}
  8008e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8008ec:	5b                   	pop    %ebx
  8008ed:	5e                   	pop    %esi
  8008ee:	5f                   	pop    %edi
  8008ef:	5d                   	pop    %ebp
  8008f0:	c3                   	ret    

008008f1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8008f1:	55                   	push   %ebp
  8008f2:	89 e5                	mov    %esp,%ebp
  8008f4:	83 ec 18             	sub    $0x18,%esp
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8008fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800900:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800904:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800907:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80090e:	85 c0                	test   %eax,%eax
  800910:	74 26                	je     800938 <vsnprintf+0x47>
  800912:	85 d2                	test   %edx,%edx
  800914:	7e 29                	jle    80093f <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800916:	ff 75 14             	pushl  0x14(%ebp)
  800919:	ff 75 10             	pushl  0x10(%ebp)
  80091c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80091f:	50                   	push   %eax
  800920:	68 4c 04 80 00       	push   $0x80044c
  800925:	e8 5b fb ff ff       	call   800485 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80092a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80092d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800930:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800933:	83 c4 10             	add    $0x10,%esp
}
  800936:	c9                   	leave  
  800937:	c3                   	ret    
		return -E_INVAL;
  800938:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80093d:	eb f7                	jmp    800936 <vsnprintf+0x45>
  80093f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800944:	eb f0                	jmp    800936 <vsnprintf+0x45>

00800946 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
  800949:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80094c:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  80094f:	50                   	push   %eax
  800950:	ff 75 10             	pushl  0x10(%ebp)
  800953:	ff 75 0c             	pushl  0xc(%ebp)
  800956:	ff 75 08             	pushl  0x8(%ebp)
  800959:	e8 93 ff ff ff       	call   8008f1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80095e:	c9                   	leave  
  80095f:	c3                   	ret    

00800960 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800960:	55                   	push   %ebp
  800961:	89 e5                	mov    %esp,%ebp
  800963:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800966:	b8 00 00 00 00       	mov    $0x0,%eax
  80096b:	eb 01                	jmp    80096e <strlen+0xe>
		n++;
  80096d:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80096e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800972:	75 f9                	jne    80096d <strlen+0xd>
	return n;
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80097c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80097f:	b8 00 00 00 00       	mov    $0x0,%eax
  800984:	eb 01                	jmp    800987 <strnlen+0x11>
		n++;
  800986:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800987:	39 d0                	cmp    %edx,%eax
  800989:	74 06                	je     800991 <strnlen+0x1b>
  80098b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80098f:	75 f5                	jne    800986 <strnlen+0x10>
	return n;
}
  800991:	5d                   	pop    %ebp
  800992:	c3                   	ret    

00800993 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800993:	55                   	push   %ebp
  800994:	89 e5                	mov    %esp,%ebp
  800996:	53                   	push   %ebx
  800997:	8b 45 08             	mov    0x8(%ebp),%eax
  80099a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80099d:	89 c2                	mov    %eax,%edx
  80099f:	42                   	inc    %edx
  8009a0:	41                   	inc    %ecx
  8009a1:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8009a4:	88 5a ff             	mov    %bl,-0x1(%edx)
  8009a7:	84 db                	test   %bl,%bl
  8009a9:	75 f4                	jne    80099f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8009ab:	5b                   	pop    %ebx
  8009ac:	5d                   	pop    %ebp
  8009ad:	c3                   	ret    

008009ae <strcat>:

char *
strcat(char *dst, const char *src)
{
  8009ae:	55                   	push   %ebp
  8009af:	89 e5                	mov    %esp,%ebp
  8009b1:	53                   	push   %ebx
  8009b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8009b5:	53                   	push   %ebx
  8009b6:	e8 a5 ff ff ff       	call   800960 <strlen>
  8009bb:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	01 d8                	add    %ebx,%eax
  8009c3:	50                   	push   %eax
  8009c4:	e8 ca ff ff ff       	call   800993 <strcpy>
	return dst;
}
  8009c9:	89 d8                	mov    %ebx,%eax
  8009cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8009ce:	c9                   	leave  
  8009cf:	c3                   	ret    

008009d0 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8009d0:	55                   	push   %ebp
  8009d1:	89 e5                	mov    %esp,%ebp
  8009d3:	56                   	push   %esi
  8009d4:	53                   	push   %ebx
  8009d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8009d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8009db:	89 f3                	mov    %esi,%ebx
  8009dd:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8009e0:	89 f2                	mov    %esi,%edx
  8009e2:	eb 0c                	jmp    8009f0 <strncpy+0x20>
		*dst++ = *src;
  8009e4:	42                   	inc    %edx
  8009e5:	8a 01                	mov    (%ecx),%al
  8009e7:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8009ea:	80 39 01             	cmpb   $0x1,(%ecx)
  8009ed:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8009f0:	39 da                	cmp    %ebx,%edx
  8009f2:	75 f0                	jne    8009e4 <strncpy+0x14>
	}
	return ret;
}
  8009f4:	89 f0                	mov    %esi,%eax
  8009f6:	5b                   	pop    %ebx
  8009f7:	5e                   	pop    %esi
  8009f8:	5d                   	pop    %ebp
  8009f9:	c3                   	ret    

008009fa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8009fa:	55                   	push   %ebp
  8009fb:	89 e5                	mov    %esp,%ebp
  8009fd:	56                   	push   %esi
  8009fe:	53                   	push   %ebx
  8009ff:	8b 75 08             	mov    0x8(%ebp),%esi
  800a02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a05:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800a08:	85 c0                	test   %eax,%eax
  800a0a:	74 20                	je     800a2c <strlcpy+0x32>
  800a0c:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800a10:	89 f0                	mov    %esi,%eax
  800a12:	eb 05                	jmp    800a19 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800a14:	40                   	inc    %eax
  800a15:	42                   	inc    %edx
  800a16:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800a19:	39 d8                	cmp    %ebx,%eax
  800a1b:	74 06                	je     800a23 <strlcpy+0x29>
  800a1d:	8a 0a                	mov    (%edx),%cl
  800a1f:	84 c9                	test   %cl,%cl
  800a21:	75 f1                	jne    800a14 <strlcpy+0x1a>
		*dst = '\0';
  800a23:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800a26:	29 f0                	sub    %esi,%eax
}
  800a28:	5b                   	pop    %ebx
  800a29:	5e                   	pop    %esi
  800a2a:	5d                   	pop    %ebp
  800a2b:	c3                   	ret    
  800a2c:	89 f0                	mov    %esi,%eax
  800a2e:	eb f6                	jmp    800a26 <strlcpy+0x2c>

00800a30 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800a30:	55                   	push   %ebp
  800a31:	89 e5                	mov    %esp,%ebp
  800a33:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800a36:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800a39:	eb 02                	jmp    800a3d <strcmp+0xd>
		p++, q++;
  800a3b:	41                   	inc    %ecx
  800a3c:	42                   	inc    %edx
	while (*p && *p == *q)
  800a3d:	8a 01                	mov    (%ecx),%al
  800a3f:	84 c0                	test   %al,%al
  800a41:	74 04                	je     800a47 <strcmp+0x17>
  800a43:	3a 02                	cmp    (%edx),%al
  800a45:	74 f4                	je     800a3b <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800a47:	0f b6 c0             	movzbl %al,%eax
  800a4a:	0f b6 12             	movzbl (%edx),%edx
  800a4d:	29 d0                	sub    %edx,%eax
}
  800a4f:	5d                   	pop    %ebp
  800a50:	c3                   	ret    

00800a51 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800a51:	55                   	push   %ebp
  800a52:	89 e5                	mov    %esp,%ebp
  800a54:	53                   	push   %ebx
  800a55:	8b 45 08             	mov    0x8(%ebp),%eax
  800a58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a5b:	89 c3                	mov    %eax,%ebx
  800a5d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800a60:	eb 02                	jmp    800a64 <strncmp+0x13>
		n--, p++, q++;
  800a62:	40                   	inc    %eax
  800a63:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800a64:	39 d8                	cmp    %ebx,%eax
  800a66:	74 15                	je     800a7d <strncmp+0x2c>
  800a68:	8a 08                	mov    (%eax),%cl
  800a6a:	84 c9                	test   %cl,%cl
  800a6c:	74 04                	je     800a72 <strncmp+0x21>
  800a6e:	3a 0a                	cmp    (%edx),%cl
  800a70:	74 f0                	je     800a62 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800a72:	0f b6 00             	movzbl (%eax),%eax
  800a75:	0f b6 12             	movzbl (%edx),%edx
  800a78:	29 d0                	sub    %edx,%eax
}
  800a7a:	5b                   	pop    %ebx
  800a7b:	5d                   	pop    %ebp
  800a7c:	c3                   	ret    
		return 0;
  800a7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800a82:	eb f6                	jmp    800a7a <strncmp+0x29>

00800a84 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800a84:	55                   	push   %ebp
  800a85:	89 e5                	mov    %esp,%ebp
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800a8d:	8a 10                	mov    (%eax),%dl
  800a8f:	84 d2                	test   %dl,%dl
  800a91:	74 07                	je     800a9a <strchr+0x16>
		if (*s == c)
  800a93:	38 ca                	cmp    %cl,%dl
  800a95:	74 08                	je     800a9f <strchr+0x1b>
	for (; *s; s++)
  800a97:	40                   	inc    %eax
  800a98:	eb f3                	jmp    800a8d <strchr+0x9>
			return (char *) s;
	return 0;
  800a9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a9f:	5d                   	pop    %ebp
  800aa0:	c3                   	ret    

00800aa1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800aa1:	55                   	push   %ebp
  800aa2:	89 e5                	mov    %esp,%ebp
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800aaa:	8a 10                	mov    (%eax),%dl
  800aac:	84 d2                	test   %dl,%dl
  800aae:	74 07                	je     800ab7 <strfind+0x16>
		if (*s == c)
  800ab0:	38 ca                	cmp    %cl,%dl
  800ab2:	74 03                	je     800ab7 <strfind+0x16>
	for (; *s; s++)
  800ab4:	40                   	inc    %eax
  800ab5:	eb f3                	jmp    800aaa <strfind+0x9>
			break;
	return (char *) s;
}
  800ab7:	5d                   	pop    %ebp
  800ab8:	c3                   	ret    

00800ab9 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800ab9:	55                   	push   %ebp
  800aba:	89 e5                	mov    %esp,%ebp
  800abc:	57                   	push   %edi
  800abd:	56                   	push   %esi
  800abe:	53                   	push   %ebx
  800abf:	8b 7d 08             	mov    0x8(%ebp),%edi
  800ac2:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800ac5:	85 c9                	test   %ecx,%ecx
  800ac7:	74 13                	je     800adc <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800ac9:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800acf:	75 05                	jne    800ad6 <memset+0x1d>
  800ad1:	f6 c1 03             	test   $0x3,%cl
  800ad4:	74 0d                	je     800ae3 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800ad6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad9:	fc                   	cld    
  800ada:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800adc:	89 f8                	mov    %edi,%eax
  800ade:	5b                   	pop    %ebx
  800adf:	5e                   	pop    %esi
  800ae0:	5f                   	pop    %edi
  800ae1:	5d                   	pop    %ebp
  800ae2:	c3                   	ret    
		c &= 0xFF;
  800ae3:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800ae7:	89 d3                	mov    %edx,%ebx
  800ae9:	c1 e3 08             	shl    $0x8,%ebx
  800aec:	89 d0                	mov    %edx,%eax
  800aee:	c1 e0 18             	shl    $0x18,%eax
  800af1:	89 d6                	mov    %edx,%esi
  800af3:	c1 e6 10             	shl    $0x10,%esi
  800af6:	09 f0                	or     %esi,%eax
  800af8:	09 c2                	or     %eax,%edx
  800afa:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800afc:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800aff:	89 d0                	mov    %edx,%eax
  800b01:	fc                   	cld    
  800b02:	f3 ab                	rep stos %eax,%es:(%edi)
  800b04:	eb d6                	jmp    800adc <memset+0x23>

00800b06 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800b06:	55                   	push   %ebp
  800b07:	89 e5                	mov    %esp,%ebp
  800b09:	57                   	push   %edi
  800b0a:	56                   	push   %esi
  800b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800b11:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800b14:	39 c6                	cmp    %eax,%esi
  800b16:	73 33                	jae    800b4b <memmove+0x45>
  800b18:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800b1b:	39 d0                	cmp    %edx,%eax
  800b1d:	73 2c                	jae    800b4b <memmove+0x45>
		s += n;
		d += n;
  800b1f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b22:	89 d6                	mov    %edx,%esi
  800b24:	09 fe                	or     %edi,%esi
  800b26:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800b2c:	75 13                	jne    800b41 <memmove+0x3b>
  800b2e:	f6 c1 03             	test   $0x3,%cl
  800b31:	75 0e                	jne    800b41 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800b33:	83 ef 04             	sub    $0x4,%edi
  800b36:	8d 72 fc             	lea    -0x4(%edx),%esi
  800b39:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800b3c:	fd                   	std    
  800b3d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b3f:	eb 07                	jmp    800b48 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800b41:	4f                   	dec    %edi
  800b42:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800b45:	fd                   	std    
  800b46:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800b48:	fc                   	cld    
  800b49:	eb 13                	jmp    800b5e <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800b4b:	89 f2                	mov    %esi,%edx
  800b4d:	09 c2                	or     %eax,%edx
  800b4f:	f6 c2 03             	test   $0x3,%dl
  800b52:	75 05                	jne    800b59 <memmove+0x53>
  800b54:	f6 c1 03             	test   $0x3,%cl
  800b57:	74 09                	je     800b62 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800b59:	89 c7                	mov    %eax,%edi
  800b5b:	fc                   	cld    
  800b5c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800b5e:	5e                   	pop    %esi
  800b5f:	5f                   	pop    %edi
  800b60:	5d                   	pop    %ebp
  800b61:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800b62:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800b65:	89 c7                	mov    %eax,%edi
  800b67:	fc                   	cld    
  800b68:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800b6a:	eb f2                	jmp    800b5e <memmove+0x58>

00800b6c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800b6f:	ff 75 10             	pushl  0x10(%ebp)
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	ff 75 08             	pushl  0x8(%ebp)
  800b78:	e8 89 ff ff ff       	call   800b06 <memmove>
}
  800b7d:	c9                   	leave  
  800b7e:	c3                   	ret    

00800b7f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	56                   	push   %esi
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	89 c6                	mov    %eax,%esi
  800b89:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800b8c:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800b8f:	39 f0                	cmp    %esi,%eax
  800b91:	74 16                	je     800ba9 <memcmp+0x2a>
		if (*s1 != *s2)
  800b93:	8a 08                	mov    (%eax),%cl
  800b95:	8a 1a                	mov    (%edx),%bl
  800b97:	38 d9                	cmp    %bl,%cl
  800b99:	75 04                	jne    800b9f <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800b9b:	40                   	inc    %eax
  800b9c:	42                   	inc    %edx
  800b9d:	eb f0                	jmp    800b8f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800b9f:	0f b6 c1             	movzbl %cl,%eax
  800ba2:	0f b6 db             	movzbl %bl,%ebx
  800ba5:	29 d8                	sub    %ebx,%eax
  800ba7:	eb 05                	jmp    800bae <memcmp+0x2f>
	}

	return 0;
  800ba9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bae:	5b                   	pop    %ebx
  800baf:	5e                   	pop    %esi
  800bb0:	5d                   	pop    %ebp
  800bb1:	c3                   	ret    

00800bb2 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800bbb:	89 c2                	mov    %eax,%edx
  800bbd:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800bc0:	39 d0                	cmp    %edx,%eax
  800bc2:	73 07                	jae    800bcb <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800bc4:	38 08                	cmp    %cl,(%eax)
  800bc6:	74 03                	je     800bcb <memfind+0x19>
	for (; s < ends; s++)
  800bc8:	40                   	inc    %eax
  800bc9:	eb f5                	jmp    800bc0 <memfind+0xe>
			break;
	return (void *) s;
}
  800bcb:	5d                   	pop    %ebp
  800bcc:	c3                   	ret    

00800bcd <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800bcd:	55                   	push   %ebp
  800bce:	89 e5                	mov    %esp,%ebp
  800bd0:	57                   	push   %edi
  800bd1:	56                   	push   %esi
  800bd2:	53                   	push   %ebx
  800bd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800bd6:	eb 01                	jmp    800bd9 <strtol+0xc>
		s++;
  800bd8:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800bd9:	8a 01                	mov    (%ecx),%al
  800bdb:	3c 20                	cmp    $0x20,%al
  800bdd:	74 f9                	je     800bd8 <strtol+0xb>
  800bdf:	3c 09                	cmp    $0x9,%al
  800be1:	74 f5                	je     800bd8 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800be3:	3c 2b                	cmp    $0x2b,%al
  800be5:	74 2b                	je     800c12 <strtol+0x45>
		s++;
	else if (*s == '-')
  800be7:	3c 2d                	cmp    $0x2d,%al
  800be9:	74 2f                	je     800c1a <strtol+0x4d>
	int neg = 0;
  800beb:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800bf0:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800bf7:	75 12                	jne    800c0b <strtol+0x3e>
  800bf9:	80 39 30             	cmpb   $0x30,(%ecx)
  800bfc:	74 24                	je     800c22 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800bfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c02:	75 07                	jne    800c0b <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800c04:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800c0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800c10:	eb 4e                	jmp    800c60 <strtol+0x93>
		s++;
  800c12:	41                   	inc    %ecx
	int neg = 0;
  800c13:	bf 00 00 00 00       	mov    $0x0,%edi
  800c18:	eb d6                	jmp    800bf0 <strtol+0x23>
		s++, neg = 1;
  800c1a:	41                   	inc    %ecx
  800c1b:	bf 01 00 00 00       	mov    $0x1,%edi
  800c20:	eb ce                	jmp    800bf0 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800c22:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800c26:	74 10                	je     800c38 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800c28:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c2c:	75 dd                	jne    800c0b <strtol+0x3e>
		s++, base = 8;
  800c2e:	41                   	inc    %ecx
  800c2f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800c36:	eb d3                	jmp    800c0b <strtol+0x3e>
		s += 2, base = 16;
  800c38:	83 c1 02             	add    $0x2,%ecx
  800c3b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800c42:	eb c7                	jmp    800c0b <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800c44:	8d 72 9f             	lea    -0x61(%edx),%esi
  800c47:	89 f3                	mov    %esi,%ebx
  800c49:	80 fb 19             	cmp    $0x19,%bl
  800c4c:	77 24                	ja     800c72 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800c4e:	0f be d2             	movsbl %dl,%edx
  800c51:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800c54:	3b 55 10             	cmp    0x10(%ebp),%edx
  800c57:	7d 2b                	jge    800c84 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800c59:	41                   	inc    %ecx
  800c5a:	0f af 45 10          	imul   0x10(%ebp),%eax
  800c5e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800c60:	8a 11                	mov    (%ecx),%dl
  800c62:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800c65:	80 fb 09             	cmp    $0x9,%bl
  800c68:	77 da                	ja     800c44 <strtol+0x77>
			dig = *s - '0';
  800c6a:	0f be d2             	movsbl %dl,%edx
  800c6d:	83 ea 30             	sub    $0x30,%edx
  800c70:	eb e2                	jmp    800c54 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800c72:	8d 72 bf             	lea    -0x41(%edx),%esi
  800c75:	89 f3                	mov    %esi,%ebx
  800c77:	80 fb 19             	cmp    $0x19,%bl
  800c7a:	77 08                	ja     800c84 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800c7c:	0f be d2             	movsbl %dl,%edx
  800c7f:	83 ea 37             	sub    $0x37,%edx
  800c82:	eb d0                	jmp    800c54 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800c84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c88:	74 05                	je     800c8f <strtol+0xc2>
		*endptr = (char *) s;
  800c8a:	8b 75 0c             	mov    0xc(%ebp),%esi
  800c8d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800c8f:	85 ff                	test   %edi,%edi
  800c91:	74 02                	je     800c95 <strtol+0xc8>
  800c93:	f7 d8                	neg    %eax
}
  800c95:	5b                   	pop    %ebx
  800c96:	5e                   	pop    %esi
  800c97:	5f                   	pop    %edi
  800c98:	5d                   	pop    %ebp
  800c99:	c3                   	ret    

00800c9a <atoi>:

int
atoi(const char *s)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800c9d:	6a 0a                	push   $0xa
  800c9f:	6a 00                	push   $0x0
  800ca1:	ff 75 08             	pushl  0x8(%ebp)
  800ca4:	e8 24 ff ff ff       	call   800bcd <strtol>
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	57                   	push   %edi
  800caf:	56                   	push   %esi
  800cb0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800cb1:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800cb9:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbc:	89 c3                	mov    %eax,%ebx
  800cbe:	89 c7                	mov    %eax,%edi
  800cc0:	89 c6                	mov    %eax,%esi
  800cc2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800cc4:	5b                   	pop    %ebx
  800cc5:	5e                   	pop    %esi
  800cc6:	5f                   	pop    %edi
  800cc7:	5d                   	pop    %ebp
  800cc8:	c3                   	ret    

00800cc9 <sys_cgetc>:

int
sys_cgetc(void)
{
  800cc9:	55                   	push   %ebp
  800cca:	89 e5                	mov    %esp,%ebp
  800ccc:	57                   	push   %edi
  800ccd:	56                   	push   %esi
  800cce:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ccf:	ba 00 00 00 00       	mov    $0x0,%edx
  800cd4:	b8 01 00 00 00       	mov    $0x1,%eax
  800cd9:	89 d1                	mov    %edx,%ecx
  800cdb:	89 d3                	mov    %edx,%ebx
  800cdd:	89 d7                	mov    %edx,%edi
  800cdf:	89 d6                	mov    %edx,%esi
  800ce1:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	57                   	push   %edi
  800cec:	56                   	push   %esi
  800ced:	53                   	push   %ebx
  800cee:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800cf1:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800cfb:	8b 55 08             	mov    0x8(%ebp),%edx
  800cfe:	89 cb                	mov    %ecx,%ebx
  800d00:	89 cf                	mov    %ecx,%edi
  800d02:	89 ce                	mov    %ecx,%esi
  800d04:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d06:	85 c0                	test   %eax,%eax
  800d08:	7f 08                	jg     800d12 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800d0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0d:	5b                   	pop    %ebx
  800d0e:	5e                   	pop    %esi
  800d0f:	5f                   	pop    %edi
  800d10:	5d                   	pop    %ebp
  800d11:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d12:	83 ec 0c             	sub    $0xc,%esp
  800d15:	50                   	push   %eax
  800d16:	6a 03                	push   $0x3
  800d18:	68 df 27 80 00       	push   $0x8027df
  800d1d:	6a 23                	push   $0x23
  800d1f:	68 fc 27 80 00       	push   $0x8027fc
  800d24:	e8 4f f5 ff ff       	call   800278 <_panic>

00800d29 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	57                   	push   %edi
  800d2d:	56                   	push   %esi
  800d2e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800d2f:	ba 00 00 00 00       	mov    $0x0,%edx
  800d34:	b8 02 00 00 00       	mov    $0x2,%eax
  800d39:	89 d1                	mov    %edx,%ecx
  800d3b:	89 d3                	mov    %edx,%ebx
  800d3d:	89 d7                	mov    %edx,%edi
  800d3f:	89 d6                	mov    %edx,%esi
  800d41:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800d43:	5b                   	pop    %ebx
  800d44:	5e                   	pop    %esi
  800d45:	5f                   	pop    %edi
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
  800d4b:	57                   	push   %edi
  800d4c:	56                   	push   %esi
  800d4d:	53                   	push   %ebx
  800d4e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d51:	be 00 00 00 00       	mov    $0x0,%esi
  800d56:	b8 04 00 00 00       	mov    $0x4,%eax
  800d5b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d5e:	8b 55 08             	mov    0x8(%ebp),%edx
  800d61:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800d64:	89 f7                	mov    %esi,%edi
  800d66:	cd 30                	int    $0x30
	if(check && ret > 0)
  800d68:	85 c0                	test   %eax,%eax
  800d6a:	7f 08                	jg     800d74 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800d6c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d6f:	5b                   	pop    %ebx
  800d70:	5e                   	pop    %esi
  800d71:	5f                   	pop    %edi
  800d72:	5d                   	pop    %ebp
  800d73:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800d74:	83 ec 0c             	sub    $0xc,%esp
  800d77:	50                   	push   %eax
  800d78:	6a 04                	push   $0x4
  800d7a:	68 df 27 80 00       	push   $0x8027df
  800d7f:	6a 23                	push   $0x23
  800d81:	68 fc 27 80 00       	push   $0x8027fc
  800d86:	e8 ed f4 ff ff       	call   800278 <_panic>

00800d8b <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800d8b:	55                   	push   %ebp
  800d8c:	89 e5                	mov    %esp,%ebp
  800d8e:	57                   	push   %edi
  800d8f:	56                   	push   %esi
  800d90:	53                   	push   %ebx
  800d91:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800d94:	b8 05 00 00 00       	mov    $0x5,%eax
  800d99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800d9c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d9f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800da2:	8b 7d 14             	mov    0x14(%ebp),%edi
  800da5:	8b 75 18             	mov    0x18(%ebp),%esi
  800da8:	cd 30                	int    $0x30
	if(check && ret > 0)
  800daa:	85 c0                	test   %eax,%eax
  800dac:	7f 08                	jg     800db6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800dae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db1:	5b                   	pop    %ebx
  800db2:	5e                   	pop    %esi
  800db3:	5f                   	pop    %edi
  800db4:	5d                   	pop    %ebp
  800db5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800db6:	83 ec 0c             	sub    $0xc,%esp
  800db9:	50                   	push   %eax
  800dba:	6a 05                	push   $0x5
  800dbc:	68 df 27 80 00       	push   $0x8027df
  800dc1:	6a 23                	push   $0x23
  800dc3:	68 fc 27 80 00       	push   $0x8027fc
  800dc8:	e8 ab f4 ff ff       	call   800278 <_panic>

00800dcd <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800dcd:	55                   	push   %ebp
  800dce:	89 e5                	mov    %esp,%ebp
  800dd0:	57                   	push   %edi
  800dd1:	56                   	push   %esi
  800dd2:	53                   	push   %ebx
  800dd3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800dd6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ddb:	b8 06 00 00 00       	mov    $0x6,%eax
  800de0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de3:	8b 55 08             	mov    0x8(%ebp),%edx
  800de6:	89 df                	mov    %ebx,%edi
  800de8:	89 de                	mov    %ebx,%esi
  800dea:	cd 30                	int    $0x30
	if(check && ret > 0)
  800dec:	85 c0                	test   %eax,%eax
  800dee:	7f 08                	jg     800df8 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800df0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800df3:	5b                   	pop    %ebx
  800df4:	5e                   	pop    %esi
  800df5:	5f                   	pop    %edi
  800df6:	5d                   	pop    %ebp
  800df7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800df8:	83 ec 0c             	sub    $0xc,%esp
  800dfb:	50                   	push   %eax
  800dfc:	6a 06                	push   $0x6
  800dfe:	68 df 27 80 00       	push   $0x8027df
  800e03:	6a 23                	push   $0x23
  800e05:	68 fc 27 80 00       	push   $0x8027fc
  800e0a:	e8 69 f4 ff ff       	call   800278 <_panic>

00800e0f <sys_yield>:

void
sys_yield(void)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	57                   	push   %edi
  800e13:	56                   	push   %esi
  800e14:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e15:	ba 00 00 00 00       	mov    $0x0,%edx
  800e1a:	b8 0b 00 00 00       	mov    $0xb,%eax
  800e1f:	89 d1                	mov    %edx,%ecx
  800e21:	89 d3                	mov    %edx,%ebx
  800e23:	89 d7                	mov    %edx,%edi
  800e25:	89 d6                	mov    %edx,%esi
  800e27:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800e29:	5b                   	pop    %ebx
  800e2a:	5e                   	pop    %esi
  800e2b:	5f                   	pop    %edi
  800e2c:	5d                   	pop    %ebp
  800e2d:	c3                   	ret    

00800e2e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	57                   	push   %edi
  800e32:	56                   	push   %esi
  800e33:	53                   	push   %ebx
  800e34:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e37:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e3c:	b8 08 00 00 00       	mov    $0x8,%eax
  800e41:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e44:	8b 55 08             	mov    0x8(%ebp),%edx
  800e47:	89 df                	mov    %ebx,%edi
  800e49:	89 de                	mov    %ebx,%esi
  800e4b:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e4d:	85 c0                	test   %eax,%eax
  800e4f:	7f 08                	jg     800e59 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800e51:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e54:	5b                   	pop    %ebx
  800e55:	5e                   	pop    %esi
  800e56:	5f                   	pop    %edi
  800e57:	5d                   	pop    %ebp
  800e58:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e59:	83 ec 0c             	sub    $0xc,%esp
  800e5c:	50                   	push   %eax
  800e5d:	6a 08                	push   $0x8
  800e5f:	68 df 27 80 00       	push   $0x8027df
  800e64:	6a 23                	push   $0x23
  800e66:	68 fc 27 80 00       	push   $0x8027fc
  800e6b:	e8 08 f4 ff ff       	call   800278 <_panic>

00800e70 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800e70:	55                   	push   %ebp
  800e71:	89 e5                	mov    %esp,%ebp
  800e73:	57                   	push   %edi
  800e74:	56                   	push   %esi
  800e75:	53                   	push   %ebx
  800e76:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e79:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e7e:	b8 0c 00 00 00       	mov    $0xc,%eax
  800e83:	8b 55 08             	mov    0x8(%ebp),%edx
  800e86:	89 cb                	mov    %ecx,%ebx
  800e88:	89 cf                	mov    %ecx,%edi
  800e8a:	89 ce                	mov    %ecx,%esi
  800e8c:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e8e:	85 c0                	test   %eax,%eax
  800e90:	7f 08                	jg     800e9a <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800e92:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e95:	5b                   	pop    %ebx
  800e96:	5e                   	pop    %esi
  800e97:	5f                   	pop    %edi
  800e98:	5d                   	pop    %ebp
  800e99:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800e9a:	83 ec 0c             	sub    $0xc,%esp
  800e9d:	50                   	push   %eax
  800e9e:	6a 0c                	push   $0xc
  800ea0:	68 df 27 80 00       	push   $0x8027df
  800ea5:	6a 23                	push   $0x23
  800ea7:	68 fc 27 80 00       	push   $0x8027fc
  800eac:	e8 c7 f3 ff ff       	call   800278 <_panic>

00800eb1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	57                   	push   %edi
  800eb5:	56                   	push   %esi
  800eb6:	53                   	push   %ebx
  800eb7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800eba:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ebf:	b8 09 00 00 00       	mov    $0x9,%eax
  800ec4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ec7:	8b 55 08             	mov    0x8(%ebp),%edx
  800eca:	89 df                	mov    %ebx,%edi
  800ecc:	89 de                	mov    %ebx,%esi
  800ece:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ed0:	85 c0                	test   %eax,%eax
  800ed2:	7f 08                	jg     800edc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800ed4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ed7:	5b                   	pop    %ebx
  800ed8:	5e                   	pop    %esi
  800ed9:	5f                   	pop    %edi
  800eda:	5d                   	pop    %ebp
  800edb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	50                   	push   %eax
  800ee0:	6a 09                	push   $0x9
  800ee2:	68 df 27 80 00       	push   $0x8027df
  800ee7:	6a 23                	push   $0x23
  800ee9:	68 fc 27 80 00       	push   $0x8027fc
  800eee:	e8 85 f3 ff ff       	call   800278 <_panic>

00800ef3 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800ef3:	55                   	push   %ebp
  800ef4:	89 e5                	mov    %esp,%ebp
  800ef6:	57                   	push   %edi
  800ef7:	56                   	push   %esi
  800ef8:	53                   	push   %ebx
  800ef9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800efc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f01:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f06:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f09:	8b 55 08             	mov    0x8(%ebp),%edx
  800f0c:	89 df                	mov    %ebx,%edi
  800f0e:	89 de                	mov    %ebx,%esi
  800f10:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f12:	85 c0                	test   %eax,%eax
  800f14:	7f 08                	jg     800f1e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800f16:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f19:	5b                   	pop    %ebx
  800f1a:	5e                   	pop    %esi
  800f1b:	5f                   	pop    %edi
  800f1c:	5d                   	pop    %ebp
  800f1d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f1e:	83 ec 0c             	sub    $0xc,%esp
  800f21:	50                   	push   %eax
  800f22:	6a 0a                	push   $0xa
  800f24:	68 df 27 80 00       	push   $0x8027df
  800f29:	6a 23                	push   $0x23
  800f2b:	68 fc 27 80 00       	push   $0x8027fc
  800f30:	e8 43 f3 ff ff       	call   800278 <_panic>

00800f35 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800f35:	55                   	push   %ebp
  800f36:	89 e5                	mov    %esp,%ebp
  800f38:	57                   	push   %edi
  800f39:	56                   	push   %esi
  800f3a:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3b:	be 00 00 00 00       	mov    $0x0,%esi
  800f40:	b8 0d 00 00 00       	mov    $0xd,%eax
  800f45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f48:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f4e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f51:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800f53:	5b                   	pop    %ebx
  800f54:	5e                   	pop    %esi
  800f55:	5f                   	pop    %edi
  800f56:	5d                   	pop    %ebp
  800f57:	c3                   	ret    

00800f58 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800f58:	55                   	push   %ebp
  800f59:	89 e5                	mov    %esp,%ebp
  800f5b:	57                   	push   %edi
  800f5c:	56                   	push   %esi
  800f5d:	53                   	push   %ebx
  800f5e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f61:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f66:	b8 0e 00 00 00       	mov    $0xe,%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 cb                	mov    %ecx,%ebx
  800f70:	89 cf                	mov    %ecx,%edi
  800f72:	89 ce                	mov    %ecx,%esi
  800f74:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f76:	85 c0                	test   %eax,%eax
  800f78:	7f 08                	jg     800f82 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800f7a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f7d:	5b                   	pop    %ebx
  800f7e:	5e                   	pop    %esi
  800f7f:	5f                   	pop    %edi
  800f80:	5d                   	pop    %ebp
  800f81:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f82:	83 ec 0c             	sub    $0xc,%esp
  800f85:	50                   	push   %eax
  800f86:	6a 0e                	push   $0xe
  800f88:	68 df 27 80 00       	push   $0x8027df
  800f8d:	6a 23                	push   $0x23
  800f8f:	68 fc 27 80 00       	push   $0x8027fc
  800f94:	e8 df f2 ff ff       	call   800278 <_panic>

00800f99 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800f99:	55                   	push   %ebp
  800f9a:	89 e5                	mov    %esp,%ebp
  800f9c:	57                   	push   %edi
  800f9d:	56                   	push   %esi
  800f9e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f9f:	be 00 00 00 00       	mov    $0x0,%esi
  800fa4:	b8 0f 00 00 00       	mov    $0xf,%eax
  800fa9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fac:	8b 55 08             	mov    0x8(%ebp),%edx
  800faf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fb2:	89 f7                	mov    %esi,%edi
  800fb4:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800fb6:	5b                   	pop    %ebx
  800fb7:	5e                   	pop    %esi
  800fb8:	5f                   	pop    %edi
  800fb9:	5d                   	pop    %ebp
  800fba:	c3                   	ret    

00800fbb <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  800fbb:	55                   	push   %ebp
  800fbc:	89 e5                	mov    %esp,%ebp
  800fbe:	57                   	push   %edi
  800fbf:	56                   	push   %esi
  800fc0:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fc1:	be 00 00 00 00       	mov    $0x0,%esi
  800fc6:	b8 10 00 00 00       	mov    $0x10,%eax
  800fcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fd4:	89 f7                	mov    %esi,%edi
  800fd6:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  800fd8:	5b                   	pop    %ebx
  800fd9:	5e                   	pop    %esi
  800fda:	5f                   	pop    %edi
  800fdb:	5d                   	pop    %ebp
  800fdc:	c3                   	ret    

00800fdd <sys_set_console_color>:

void sys_set_console_color(int color) {
  800fdd:	55                   	push   %ebp
  800fde:	89 e5                	mov    %esp,%ebp
  800fe0:	57                   	push   %edi
  800fe1:	56                   	push   %esi
  800fe2:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fe3:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fe8:	b8 11 00 00 00       	mov    $0x11,%eax
  800fed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff0:	89 cb                	mov    %ecx,%ebx
  800ff2:	89 cf                	mov    %ecx,%edi
  800ff4:	89 ce                	mov    %ecx,%esi
  800ff6:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800ff8:	5b                   	pop    %ebx
  800ff9:	5e                   	pop    %esi
  800ffa:	5f                   	pop    %edi
  800ffb:	5d                   	pop    %ebp
  800ffc:	c3                   	ret    

00800ffd <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  800ffd:	55                   	push   %ebp
  800ffe:	89 e5                	mov    %esp,%ebp
  801000:	56                   	push   %esi
  801001:	53                   	push   %ebx
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801005:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801007:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  80100b:	0f 84 84 00 00 00    	je     801095 <pgfault+0x98>
  801011:	89 d8                	mov    %ebx,%eax
  801013:	c1 e8 16             	shr    $0x16,%eax
  801016:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  80101d:	a8 01                	test   $0x1,%al
  80101f:	74 74                	je     801095 <pgfault+0x98>
  801021:	89 d8                	mov    %ebx,%eax
  801023:	c1 e8 0c             	shr    $0xc,%eax
  801026:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80102d:	f6 c4 08             	test   $0x8,%ah
  801030:	74 63                	je     801095 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  801032:	e8 f2 fc ff ff       	call   800d29 <sys_getenvid>
  801037:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801039:	83 ec 04             	sub    $0x4,%esp
  80103c:	6a 07                	push   $0x7
  80103e:	68 00 f0 7f 00       	push   $0x7ff000
  801043:	50                   	push   %eax
  801044:	e8 ff fc ff ff       	call   800d48 <sys_page_alloc>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	85 c0                	test   %eax,%eax
  80104e:	78 5b                	js     8010ab <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  801050:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  801056:	83 ec 04             	sub    $0x4,%esp
  801059:	68 00 10 00 00       	push   $0x1000
  80105e:	53                   	push   %ebx
  80105f:	68 00 f0 7f 00       	push   $0x7ff000
  801064:	e8 03 fb ff ff       	call   800b6c <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  801069:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  801070:	53                   	push   %ebx
  801071:	56                   	push   %esi
  801072:	68 00 f0 7f 00       	push   $0x7ff000
  801077:	56                   	push   %esi
  801078:	e8 0e fd ff ff       	call   800d8b <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  80107d:	83 c4 18             	add    $0x18,%esp
  801080:	68 00 f0 7f 00       	push   $0x7ff000
  801085:	56                   	push   %esi
  801086:	e8 42 fd ff ff       	call   800dcd <sys_page_unmap>

}
  80108b:	83 c4 10             	add    $0x10,%esp
  80108e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801091:	5b                   	pop    %ebx
  801092:	5e                   	pop    %esi
  801093:	5d                   	pop    %ebp
  801094:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801095:	68 0c 28 80 00       	push   $0x80280c
  80109a:	68 96 28 80 00       	push   $0x802896
  80109f:	6a 1c                	push   $0x1c
  8010a1:	68 ab 28 80 00       	push   $0x8028ab
  8010a6:	e8 cd f1 ff ff       	call   800278 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  8010ab:	68 5c 28 80 00       	push   $0x80285c
  8010b0:	68 96 28 80 00       	push   $0x802896
  8010b5:	6a 26                	push   $0x26
  8010b7:	68 ab 28 80 00       	push   $0x8028ab
  8010bc:	e8 b7 f1 ff ff       	call   800278 <_panic>

008010c1 <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8010c1:	55                   	push   %ebp
  8010c2:	89 e5                	mov    %esp,%ebp
  8010c4:	57                   	push   %edi
  8010c5:	56                   	push   %esi
  8010c6:	53                   	push   %ebx
  8010c7:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8010ca:	68 fd 0f 80 00       	push   $0x800ffd
  8010cf:	e8 23 10 00 00       	call   8020f7 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8010d4:	b8 07 00 00 00       	mov    $0x7,%eax
  8010d9:	cd 30                	int    $0x30
  8010db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8010de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  8010e1:	83 c4 10             	add    $0x10,%esp
  8010e4:	85 c0                	test   %eax,%eax
  8010e6:	0f 88 58 01 00 00    	js     801244 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  8010ec:	85 c0                	test   %eax,%eax
  8010ee:	74 07                	je     8010f7 <fork+0x36>
  8010f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010f5:	eb 72                	jmp    801169 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  8010f7:	e8 2d fc ff ff       	call   800d29 <sys_getenvid>
  8010fc:	25 ff 03 00 00       	and    $0x3ff,%eax
  801101:	89 c2                	mov    %eax,%edx
  801103:	c1 e2 05             	shl    $0x5,%edx
  801106:	29 c2                	sub    %eax,%edx
  801108:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80110f:	a3 04 40 80 00       	mov    %eax,0x804004
		return 0;
  801114:	e9 20 01 00 00       	jmp    801239 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  801119:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801120:	e8 04 fc ff ff       	call   800d29 <sys_getenvid>
  801125:	83 ec 0c             	sub    $0xc,%esp
  801128:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  80112e:	57                   	push   %edi
  80112f:	56                   	push   %esi
  801130:	ff 75 e4             	pushl  -0x1c(%ebp)
  801133:	56                   	push   %esi
  801134:	50                   	push   %eax
  801135:	e8 51 fc ff ff       	call   800d8b <sys_page_map>
  80113a:	83 c4 20             	add    $0x20,%esp
  80113d:	eb 18                	jmp    801157 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  80113f:	e8 e5 fb ff ff       	call   800d29 <sys_getenvid>
  801144:	83 ec 0c             	sub    $0xc,%esp
  801147:	6a 05                	push   $0x5
  801149:	56                   	push   %esi
  80114a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80114d:	56                   	push   %esi
  80114e:	50                   	push   %eax
  80114f:	e8 37 fc ff ff       	call   800d8b <sys_page_map>
  801154:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801157:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  80115d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801163:	0f 84 8f 00 00 00    	je     8011f8 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  801169:	89 d8                	mov    %ebx,%eax
  80116b:	c1 e8 16             	shr    $0x16,%eax
  80116e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801175:	a8 01                	test   $0x1,%al
  801177:	74 de                	je     801157 <fork+0x96>
  801179:	89 d8                	mov    %ebx,%eax
  80117b:	c1 e8 0c             	shr    $0xc,%eax
  80117e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801185:	a8 04                	test   $0x4,%al
  801187:	74 ce                	je     801157 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801189:	89 de                	mov    %ebx,%esi
  80118b:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801191:	89 f0                	mov    %esi,%eax
  801193:	c1 e8 0c             	shr    $0xc,%eax
  801196:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80119d:	f6 c6 04             	test   $0x4,%dh
  8011a0:	0f 85 73 ff ff ff    	jne    801119 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  8011a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8011ad:	a9 02 08 00 00       	test   $0x802,%eax
  8011b2:	74 8b                	je     80113f <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8011b4:	e8 70 fb ff ff       	call   800d29 <sys_getenvid>
  8011b9:	83 ec 0c             	sub    $0xc,%esp
  8011bc:	68 05 08 00 00       	push   $0x805
  8011c1:	56                   	push   %esi
  8011c2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011c5:	56                   	push   %esi
  8011c6:	50                   	push   %eax
  8011c7:	e8 bf fb ff ff       	call   800d8b <sys_page_map>
  8011cc:	83 c4 20             	add    $0x20,%esp
  8011cf:	85 c0                	test   %eax,%eax
  8011d1:	78 84                	js     801157 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  8011d3:	e8 51 fb ff ff       	call   800d29 <sys_getenvid>
  8011d8:	89 c7                	mov    %eax,%edi
  8011da:	e8 4a fb ff ff       	call   800d29 <sys_getenvid>
  8011df:	83 ec 0c             	sub    $0xc,%esp
  8011e2:	68 05 08 00 00       	push   $0x805
  8011e7:	56                   	push   %esi
  8011e8:	57                   	push   %edi
  8011e9:	56                   	push   %esi
  8011ea:	50                   	push   %eax
  8011eb:	e8 9b fb ff ff       	call   800d8b <sys_page_map>
  8011f0:	83 c4 20             	add    $0x20,%esp
  8011f3:	e9 5f ff ff ff       	jmp    801157 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  8011f8:	83 ec 04             	sub    $0x4,%esp
  8011fb:	6a 07                	push   $0x7
  8011fd:	68 00 f0 bf ee       	push   $0xeebff000
  801202:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801205:	57                   	push   %edi
  801206:	e8 3d fb ff ff       	call   800d48 <sys_page_alloc>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 3b                	js     80124d <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801212:	83 ec 08             	sub    $0x8,%esp
  801215:	68 3d 21 80 00       	push   $0x80213d
  80121a:	57                   	push   %edi
  80121b:	e8 d3 fc ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
  801220:	83 c4 10             	add    $0x10,%esp
  801223:	85 c0                	test   %eax,%eax
  801225:	78 2f                	js     801256 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801227:	83 ec 08             	sub    $0x8,%esp
  80122a:	6a 02                	push   $0x2
  80122c:	57                   	push   %edi
  80122d:	e8 fc fb ff ff       	call   800e2e <sys_env_set_status>
	if (temp < 0) {
  801232:	83 c4 10             	add    $0x10,%esp
  801235:	85 c0                	test   %eax,%eax
  801237:	78 26                	js     80125f <fork+0x19e>
		return -1;
	}

	return childid;
}
  801239:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80123c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80123f:	5b                   	pop    %ebx
  801240:	5e                   	pop    %esi
  801241:	5f                   	pop    %edi
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    
		return -1;
  801244:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80124b:	eb ec                	jmp    801239 <fork+0x178>
		return -1;
  80124d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801254:	eb e3                	jmp    801239 <fork+0x178>
		return -1;
  801256:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80125d:	eb da                	jmp    801239 <fork+0x178>
		return -1;
  80125f:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801266:	eb d1                	jmp    801239 <fork+0x178>

00801268 <sfork>:

// Challenge!
int
sfork(void)
{
  801268:	55                   	push   %ebp
  801269:	89 e5                	mov    %esp,%ebp
  80126b:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  80126e:	68 b6 28 80 00       	push   $0x8028b6
  801273:	68 85 00 00 00       	push   $0x85
  801278:	68 ab 28 80 00       	push   $0x8028ab
  80127d:	e8 f6 ef ff ff       	call   800278 <_panic>

00801282 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801282:	55                   	push   %ebp
  801283:	89 e5                	mov    %esp,%ebp
  801285:	57                   	push   %edi
  801286:	56                   	push   %esi
  801287:	53                   	push   %ebx
  801288:	83 ec 0c             	sub    $0xc,%esp
  80128b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80128e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801291:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801294:	85 ff                	test   %edi,%edi
  801296:	74 53                	je     8012eb <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801298:	83 ec 0c             	sub    $0xc,%esp
  80129b:	57                   	push   %edi
  80129c:	e8 b7 fc ff ff       	call   800f58 <sys_ipc_recv>
  8012a1:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  8012a4:	85 db                	test   %ebx,%ebx
  8012a6:	74 0b                	je     8012b3 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  8012a8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012ae:	8b 52 74             	mov    0x74(%edx),%edx
  8012b1:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  8012b3:	85 f6                	test   %esi,%esi
  8012b5:	74 0f                	je     8012c6 <ipc_recv+0x44>
  8012b7:	85 ff                	test   %edi,%edi
  8012b9:	74 0b                	je     8012c6 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  8012bb:	8b 15 04 40 80 00    	mov    0x804004,%edx
  8012c1:	8b 52 78             	mov    0x78(%edx),%edx
  8012c4:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  8012c6:	85 c0                	test   %eax,%eax
  8012c8:	74 30                	je     8012fa <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  8012ca:	85 db                	test   %ebx,%ebx
  8012cc:	74 06                	je     8012d4 <ipc_recv+0x52>
      		*from_env_store = 0;
  8012ce:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8012d4:	85 f6                	test   %esi,%esi
  8012d6:	74 2c                	je     801304 <ipc_recv+0x82>
      		*perm_store = 0;
  8012d8:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8012de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8012e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012e6:	5b                   	pop    %ebx
  8012e7:	5e                   	pop    %esi
  8012e8:	5f                   	pop    %edi
  8012e9:	5d                   	pop    %ebp
  8012ea:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8012eb:	83 ec 0c             	sub    $0xc,%esp
  8012ee:	6a ff                	push   $0xffffffff
  8012f0:	e8 63 fc ff ff       	call   800f58 <sys_ipc_recv>
  8012f5:	83 c4 10             	add    $0x10,%esp
  8012f8:	eb aa                	jmp    8012a4 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	8b 40 70             	mov    0x70(%eax),%eax
  801302:	eb df                	jmp    8012e3 <ipc_recv+0x61>
		return -1;
  801304:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801309:	eb d8                	jmp    8012e3 <ipc_recv+0x61>

0080130b <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  80130b:	55                   	push   %ebp
  80130c:	89 e5                	mov    %esp,%ebp
  80130e:	57                   	push   %edi
  80130f:	56                   	push   %esi
  801310:	53                   	push   %ebx
  801311:	83 ec 0c             	sub    $0xc,%esp
  801314:	8b 75 0c             	mov    0xc(%ebp),%esi
  801317:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80131a:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  80131d:	85 db                	test   %ebx,%ebx
  80131f:	75 22                	jne    801343 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801321:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801326:	eb 1b                	jmp    801343 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801328:	68 cc 28 80 00       	push   $0x8028cc
  80132d:	68 96 28 80 00       	push   $0x802896
  801332:	6a 48                	push   $0x48
  801334:	68 ef 28 80 00       	push   $0x8028ef
  801339:	e8 3a ef ff ff       	call   800278 <_panic>
		sys_yield();
  80133e:	e8 cc fa ff ff       	call   800e0f <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801343:	57                   	push   %edi
  801344:	53                   	push   %ebx
  801345:	56                   	push   %esi
  801346:	ff 75 08             	pushl  0x8(%ebp)
  801349:	e8 e7 fb ff ff       	call   800f35 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80134e:	83 c4 10             	add    $0x10,%esp
  801351:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801354:	74 e8                	je     80133e <ipc_send+0x33>
  801356:	85 c0                	test   %eax,%eax
  801358:	75 ce                	jne    801328 <ipc_send+0x1d>
		sys_yield();
  80135a:	e8 b0 fa ff ff       	call   800e0f <sys_yield>
		
	}
	
}
  80135f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801362:	5b                   	pop    %ebx
  801363:	5e                   	pop    %esi
  801364:	5f                   	pop    %edi
  801365:	5d                   	pop    %ebp
  801366:	c3                   	ret    

00801367 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801367:	55                   	push   %ebp
  801368:	89 e5                	mov    %esp,%ebp
  80136a:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80136d:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801372:	89 c2                	mov    %eax,%edx
  801374:	c1 e2 05             	shl    $0x5,%edx
  801377:	29 c2                	sub    %eax,%edx
  801379:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801380:	8b 52 50             	mov    0x50(%edx),%edx
  801383:	39 ca                	cmp    %ecx,%edx
  801385:	74 0f                	je     801396 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801387:	40                   	inc    %eax
  801388:	3d 00 04 00 00       	cmp    $0x400,%eax
  80138d:	75 e3                	jne    801372 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80138f:	b8 00 00 00 00       	mov    $0x0,%eax
  801394:	eb 11                	jmp    8013a7 <ipc_find_env+0x40>
			return envs[i].env_id;
  801396:	89 c2                	mov    %eax,%edx
  801398:	c1 e2 05             	shl    $0x5,%edx
  80139b:	29 c2                	sub    %eax,%edx
  80139d:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8013a4:	8b 40 48             	mov    0x48(%eax),%eax
}
  8013a7:	5d                   	pop    %ebp
  8013a8:	c3                   	ret    

008013a9 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8013a9:	55                   	push   %ebp
  8013aa:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8013af:	05 00 00 00 30       	add    $0x30000000,%eax
  8013b4:	c1 e8 0c             	shr    $0xc,%eax
}
  8013b7:	5d                   	pop    %ebp
  8013b8:	c3                   	ret    

008013b9 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  8013b9:	55                   	push   %ebp
  8013ba:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8013bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bf:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8013c4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013c9:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8013ce:	5d                   	pop    %ebp
  8013cf:	c3                   	ret    

008013d0 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8013d0:	55                   	push   %ebp
  8013d1:	89 e5                	mov    %esp,%ebp
  8013d3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8013d6:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8013db:	89 c2                	mov    %eax,%edx
  8013dd:	c1 ea 16             	shr    $0x16,%edx
  8013e0:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8013e7:	f6 c2 01             	test   $0x1,%dl
  8013ea:	74 2a                	je     801416 <fd_alloc+0x46>
  8013ec:	89 c2                	mov    %eax,%edx
  8013ee:	c1 ea 0c             	shr    $0xc,%edx
  8013f1:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8013f8:	f6 c2 01             	test   $0x1,%dl
  8013fb:	74 19                	je     801416 <fd_alloc+0x46>
  8013fd:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801402:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801407:	75 d2                	jne    8013db <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801409:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  80140f:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801414:	eb 07                	jmp    80141d <fd_alloc+0x4d>
			*fd_store = fd;
  801416:	89 01                	mov    %eax,(%ecx)
			return 0;
  801418:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80141d:	5d                   	pop    %ebp
  80141e:	c3                   	ret    

0080141f <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  80141f:	55                   	push   %ebp
  801420:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801422:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801426:	77 39                	ja     801461 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801428:	8b 45 08             	mov    0x8(%ebp),%eax
  80142b:	c1 e0 0c             	shl    $0xc,%eax
  80142e:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801433:	89 c2                	mov    %eax,%edx
  801435:	c1 ea 16             	shr    $0x16,%edx
  801438:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80143f:	f6 c2 01             	test   $0x1,%dl
  801442:	74 24                	je     801468 <fd_lookup+0x49>
  801444:	89 c2                	mov    %eax,%edx
  801446:	c1 ea 0c             	shr    $0xc,%edx
  801449:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801450:	f6 c2 01             	test   $0x1,%dl
  801453:	74 1a                	je     80146f <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801455:	8b 55 0c             	mov    0xc(%ebp),%edx
  801458:	89 02                	mov    %eax,(%edx)
	return 0;
  80145a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80145f:	5d                   	pop    %ebp
  801460:	c3                   	ret    
		return -E_INVAL;
  801461:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801466:	eb f7                	jmp    80145f <fd_lookup+0x40>
		return -E_INVAL;
  801468:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80146d:	eb f0                	jmp    80145f <fd_lookup+0x40>
  80146f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801474:	eb e9                	jmp    80145f <fd_lookup+0x40>

00801476 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
  801479:	83 ec 08             	sub    $0x8,%esp
  80147c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80147f:	ba 7c 29 80 00       	mov    $0x80297c,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801484:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  801489:	39 08                	cmp    %ecx,(%eax)
  80148b:	74 33                	je     8014c0 <dev_lookup+0x4a>
  80148d:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801490:	8b 02                	mov    (%edx),%eax
  801492:	85 c0                	test   %eax,%eax
  801494:	75 f3                	jne    801489 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801496:	a1 04 40 80 00       	mov    0x804004,%eax
  80149b:	8b 40 48             	mov    0x48(%eax),%eax
  80149e:	83 ec 04             	sub    $0x4,%esp
  8014a1:	51                   	push   %ecx
  8014a2:	50                   	push   %eax
  8014a3:	68 fc 28 80 00       	push   $0x8028fc
  8014a8:	e8 de ee ff ff       	call   80038b <cprintf>
	*dev = 0;
  8014ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8014b6:	83 c4 10             	add    $0x10,%esp
  8014b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8014be:	c9                   	leave  
  8014bf:	c3                   	ret    
			*dev = devtab[i];
  8014c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8014c3:	89 01                	mov    %eax,(%ecx)
			return 0;
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	eb f2                	jmp    8014be <dev_lookup+0x48>

008014cc <fd_close>:
{
  8014cc:	55                   	push   %ebp
  8014cd:	89 e5                	mov    %esp,%ebp
  8014cf:	57                   	push   %edi
  8014d0:	56                   	push   %esi
  8014d1:	53                   	push   %ebx
  8014d2:	83 ec 1c             	sub    $0x1c,%esp
  8014d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8014d8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014db:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8014de:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8014df:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8014e5:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8014e8:	50                   	push   %eax
  8014e9:	e8 31 ff ff ff       	call   80141f <fd_lookup>
  8014ee:	89 c7                	mov    %eax,%edi
  8014f0:	83 c4 08             	add    $0x8,%esp
  8014f3:	85 c0                	test   %eax,%eax
  8014f5:	78 05                	js     8014fc <fd_close+0x30>
	    || fd != fd2)
  8014f7:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8014fa:	74 13                	je     80150f <fd_close+0x43>
		return (must_exist ? r : 0);
  8014fc:	84 db                	test   %bl,%bl
  8014fe:	75 05                	jne    801505 <fd_close+0x39>
  801500:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801505:	89 f8                	mov    %edi,%eax
  801507:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80150a:	5b                   	pop    %ebx
  80150b:	5e                   	pop    %esi
  80150c:	5f                   	pop    %edi
  80150d:	5d                   	pop    %ebp
  80150e:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801515:	50                   	push   %eax
  801516:	ff 36                	pushl  (%esi)
  801518:	e8 59 ff ff ff       	call   801476 <dev_lookup>
  80151d:	89 c7                	mov    %eax,%edi
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	85 c0                	test   %eax,%eax
  801524:	78 15                	js     80153b <fd_close+0x6f>
		if (dev->dev_close)
  801526:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801529:	8b 40 10             	mov    0x10(%eax),%eax
  80152c:	85 c0                	test   %eax,%eax
  80152e:	74 1b                	je     80154b <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	56                   	push   %esi
  801534:	ff d0                	call   *%eax
  801536:	89 c7                	mov    %eax,%edi
  801538:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80153b:	83 ec 08             	sub    $0x8,%esp
  80153e:	56                   	push   %esi
  80153f:	6a 00                	push   $0x0
  801541:	e8 87 f8 ff ff       	call   800dcd <sys_page_unmap>
	return r;
  801546:	83 c4 10             	add    $0x10,%esp
  801549:	eb ba                	jmp    801505 <fd_close+0x39>
			r = 0;
  80154b:	bf 00 00 00 00       	mov    $0x0,%edi
  801550:	eb e9                	jmp    80153b <fd_close+0x6f>

00801552 <close>:

int
close(int fdnum)
{
  801552:	55                   	push   %ebp
  801553:	89 e5                	mov    %esp,%ebp
  801555:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801558:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155b:	50                   	push   %eax
  80155c:	ff 75 08             	pushl  0x8(%ebp)
  80155f:	e8 bb fe ff ff       	call   80141f <fd_lookup>
  801564:	83 c4 08             	add    $0x8,%esp
  801567:	85 c0                	test   %eax,%eax
  801569:	78 10                	js     80157b <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80156b:	83 ec 08             	sub    $0x8,%esp
  80156e:	6a 01                	push   $0x1
  801570:	ff 75 f4             	pushl  -0xc(%ebp)
  801573:	e8 54 ff ff ff       	call   8014cc <fd_close>
  801578:	83 c4 10             	add    $0x10,%esp
}
  80157b:	c9                   	leave  
  80157c:	c3                   	ret    

0080157d <close_all>:

void
close_all(void)
{
  80157d:	55                   	push   %ebp
  80157e:	89 e5                	mov    %esp,%ebp
  801580:	53                   	push   %ebx
  801581:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801584:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801589:	83 ec 0c             	sub    $0xc,%esp
  80158c:	53                   	push   %ebx
  80158d:	e8 c0 ff ff ff       	call   801552 <close>
	for (i = 0; i < MAXFD; i++)
  801592:	43                   	inc    %ebx
  801593:	83 c4 10             	add    $0x10,%esp
  801596:	83 fb 20             	cmp    $0x20,%ebx
  801599:	75 ee                	jne    801589 <close_all+0xc>
}
  80159b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80159e:	c9                   	leave  
  80159f:	c3                   	ret    

008015a0 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8015a0:	55                   	push   %ebp
  8015a1:	89 e5                	mov    %esp,%ebp
  8015a3:	57                   	push   %edi
  8015a4:	56                   	push   %esi
  8015a5:	53                   	push   %ebx
  8015a6:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8015a9:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8015ac:	50                   	push   %eax
  8015ad:	ff 75 08             	pushl  0x8(%ebp)
  8015b0:	e8 6a fe ff ff       	call   80141f <fd_lookup>
  8015b5:	89 c3                	mov    %eax,%ebx
  8015b7:	83 c4 08             	add    $0x8,%esp
  8015ba:	85 c0                	test   %eax,%eax
  8015bc:	0f 88 81 00 00 00    	js     801643 <dup+0xa3>
		return r;
	close(newfdnum);
  8015c2:	83 ec 0c             	sub    $0xc,%esp
  8015c5:	ff 75 0c             	pushl  0xc(%ebp)
  8015c8:	e8 85 ff ff ff       	call   801552 <close>

	newfd = INDEX2FD(newfdnum);
  8015cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  8015d0:	c1 e6 0c             	shl    $0xc,%esi
  8015d3:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8015d9:	83 c4 04             	add    $0x4,%esp
  8015dc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015df:	e8 d5 fd ff ff       	call   8013b9 <fd2data>
  8015e4:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8015e6:	89 34 24             	mov    %esi,(%esp)
  8015e9:	e8 cb fd ff ff       	call   8013b9 <fd2data>
  8015ee:	83 c4 10             	add    $0x10,%esp
  8015f1:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8015f3:	89 d8                	mov    %ebx,%eax
  8015f5:	c1 e8 16             	shr    $0x16,%eax
  8015f8:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8015ff:	a8 01                	test   $0x1,%al
  801601:	74 11                	je     801614 <dup+0x74>
  801603:	89 d8                	mov    %ebx,%eax
  801605:	c1 e8 0c             	shr    $0xc,%eax
  801608:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80160f:	f6 c2 01             	test   $0x1,%dl
  801612:	75 39                	jne    80164d <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801614:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801617:	89 d0                	mov    %edx,%eax
  801619:	c1 e8 0c             	shr    $0xc,%eax
  80161c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	25 07 0e 00 00       	and    $0xe07,%eax
  80162b:	50                   	push   %eax
  80162c:	56                   	push   %esi
  80162d:	6a 00                	push   $0x0
  80162f:	52                   	push   %edx
  801630:	6a 00                	push   $0x0
  801632:	e8 54 f7 ff ff       	call   800d8b <sys_page_map>
  801637:	89 c3                	mov    %eax,%ebx
  801639:	83 c4 20             	add    $0x20,%esp
  80163c:	85 c0                	test   %eax,%eax
  80163e:	78 31                	js     801671 <dup+0xd1>
		goto err;

	return newfdnum;
  801640:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801643:	89 d8                	mov    %ebx,%eax
  801645:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801648:	5b                   	pop    %ebx
  801649:	5e                   	pop    %esi
  80164a:	5f                   	pop    %edi
  80164b:	5d                   	pop    %ebp
  80164c:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80164d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801654:	83 ec 0c             	sub    $0xc,%esp
  801657:	25 07 0e 00 00       	and    $0xe07,%eax
  80165c:	50                   	push   %eax
  80165d:	57                   	push   %edi
  80165e:	6a 00                	push   $0x0
  801660:	53                   	push   %ebx
  801661:	6a 00                	push   $0x0
  801663:	e8 23 f7 ff ff       	call   800d8b <sys_page_map>
  801668:	89 c3                	mov    %eax,%ebx
  80166a:	83 c4 20             	add    $0x20,%esp
  80166d:	85 c0                	test   %eax,%eax
  80166f:	79 a3                	jns    801614 <dup+0x74>
	sys_page_unmap(0, newfd);
  801671:	83 ec 08             	sub    $0x8,%esp
  801674:	56                   	push   %esi
  801675:	6a 00                	push   $0x0
  801677:	e8 51 f7 ff ff       	call   800dcd <sys_page_unmap>
	sys_page_unmap(0, nva);
  80167c:	83 c4 08             	add    $0x8,%esp
  80167f:	57                   	push   %edi
  801680:	6a 00                	push   $0x0
  801682:	e8 46 f7 ff ff       	call   800dcd <sys_page_unmap>
	return r;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	eb b7                	jmp    801643 <dup+0xa3>

0080168c <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80168c:	55                   	push   %ebp
  80168d:	89 e5                	mov    %esp,%ebp
  80168f:	53                   	push   %ebx
  801690:	83 ec 14             	sub    $0x14,%esp
  801693:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801696:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801699:	50                   	push   %eax
  80169a:	53                   	push   %ebx
  80169b:	e8 7f fd ff ff       	call   80141f <fd_lookup>
  8016a0:	83 c4 08             	add    $0x8,%esp
  8016a3:	85 c0                	test   %eax,%eax
  8016a5:	78 3f                	js     8016e6 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8016a7:	83 ec 08             	sub    $0x8,%esp
  8016aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016ad:	50                   	push   %eax
  8016ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b1:	ff 30                	pushl  (%eax)
  8016b3:	e8 be fd ff ff       	call   801476 <dev_lookup>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	78 27                	js     8016e6 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8016bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c2:	8b 42 08             	mov    0x8(%edx),%eax
  8016c5:	83 e0 03             	and    $0x3,%eax
  8016c8:	83 f8 01             	cmp    $0x1,%eax
  8016cb:	74 1e                	je     8016eb <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8016cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016d0:	8b 40 08             	mov    0x8(%eax),%eax
  8016d3:	85 c0                	test   %eax,%eax
  8016d5:	74 35                	je     80170c <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8016d7:	83 ec 04             	sub    $0x4,%esp
  8016da:	ff 75 10             	pushl  0x10(%ebp)
  8016dd:	ff 75 0c             	pushl  0xc(%ebp)
  8016e0:	52                   	push   %edx
  8016e1:	ff d0                	call   *%eax
  8016e3:	83 c4 10             	add    $0x10,%esp
}
  8016e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016e9:	c9                   	leave  
  8016ea:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8016eb:	a1 04 40 80 00       	mov    0x804004,%eax
  8016f0:	8b 40 48             	mov    0x48(%eax),%eax
  8016f3:	83 ec 04             	sub    $0x4,%esp
  8016f6:	53                   	push   %ebx
  8016f7:	50                   	push   %eax
  8016f8:	68 40 29 80 00       	push   $0x802940
  8016fd:	e8 89 ec ff ff       	call   80038b <cprintf>
		return -E_INVAL;
  801702:	83 c4 10             	add    $0x10,%esp
  801705:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80170a:	eb da                	jmp    8016e6 <read+0x5a>
		return -E_NOT_SUPP;
  80170c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801711:	eb d3                	jmp    8016e6 <read+0x5a>

00801713 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
  801716:	57                   	push   %edi
  801717:	56                   	push   %esi
  801718:	53                   	push   %ebx
  801719:	83 ec 0c             	sub    $0xc,%esp
  80171c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80171f:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801722:	bb 00 00 00 00       	mov    $0x0,%ebx
  801727:	39 f3                	cmp    %esi,%ebx
  801729:	73 25                	jae    801750 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80172b:	83 ec 04             	sub    $0x4,%esp
  80172e:	89 f0                	mov    %esi,%eax
  801730:	29 d8                	sub    %ebx,%eax
  801732:	50                   	push   %eax
  801733:	89 d8                	mov    %ebx,%eax
  801735:	03 45 0c             	add    0xc(%ebp),%eax
  801738:	50                   	push   %eax
  801739:	57                   	push   %edi
  80173a:	e8 4d ff ff ff       	call   80168c <read>
		if (m < 0)
  80173f:	83 c4 10             	add    $0x10,%esp
  801742:	85 c0                	test   %eax,%eax
  801744:	78 08                	js     80174e <readn+0x3b>
			return m;
		if (m == 0)
  801746:	85 c0                	test   %eax,%eax
  801748:	74 06                	je     801750 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80174a:	01 c3                	add    %eax,%ebx
  80174c:	eb d9                	jmp    801727 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80174e:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801750:	89 d8                	mov    %ebx,%eax
  801752:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801755:	5b                   	pop    %ebx
  801756:	5e                   	pop    %esi
  801757:	5f                   	pop    %edi
  801758:	5d                   	pop    %ebp
  801759:	c3                   	ret    

0080175a <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
  80175d:	53                   	push   %ebx
  80175e:	83 ec 14             	sub    $0x14,%esp
  801761:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801764:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801767:	50                   	push   %eax
  801768:	53                   	push   %ebx
  801769:	e8 b1 fc ff ff       	call   80141f <fd_lookup>
  80176e:	83 c4 08             	add    $0x8,%esp
  801771:	85 c0                	test   %eax,%eax
  801773:	78 3a                	js     8017af <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801775:	83 ec 08             	sub    $0x8,%esp
  801778:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80177b:	50                   	push   %eax
  80177c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80177f:	ff 30                	pushl  (%eax)
  801781:	e8 f0 fc ff ff       	call   801476 <dev_lookup>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	85 c0                	test   %eax,%eax
  80178b:	78 22                	js     8017af <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80178d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801790:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801794:	74 1e                	je     8017b4 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801796:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801799:	8b 52 0c             	mov    0xc(%edx),%edx
  80179c:	85 d2                	test   %edx,%edx
  80179e:	74 35                	je     8017d5 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8017a0:	83 ec 04             	sub    $0x4,%esp
  8017a3:	ff 75 10             	pushl  0x10(%ebp)
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	50                   	push   %eax
  8017aa:	ff d2                	call   *%edx
  8017ac:	83 c4 10             	add    $0x10,%esp
}
  8017af:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8017b4:	a1 04 40 80 00       	mov    0x804004,%eax
  8017b9:	8b 40 48             	mov    0x48(%eax),%eax
  8017bc:	83 ec 04             	sub    $0x4,%esp
  8017bf:	53                   	push   %ebx
  8017c0:	50                   	push   %eax
  8017c1:	68 5c 29 80 00       	push   $0x80295c
  8017c6:	e8 c0 eb ff ff       	call   80038b <cprintf>
		return -E_INVAL;
  8017cb:	83 c4 10             	add    $0x10,%esp
  8017ce:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d3:	eb da                	jmp    8017af <write+0x55>
		return -E_NOT_SUPP;
  8017d5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8017da:	eb d3                	jmp    8017af <write+0x55>

008017dc <seek>:

int
seek(int fdnum, off_t offset)
{
  8017dc:	55                   	push   %ebp
  8017dd:	89 e5                	mov    %esp,%ebp
  8017df:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8017e2:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8017e5:	50                   	push   %eax
  8017e6:	ff 75 08             	pushl  0x8(%ebp)
  8017e9:	e8 31 fc ff ff       	call   80141f <fd_lookup>
  8017ee:	83 c4 08             	add    $0x8,%esp
  8017f1:	85 c0                	test   %eax,%eax
  8017f3:	78 0e                	js     801803 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8017f5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8017fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801803:	c9                   	leave  
  801804:	c3                   	ret    

00801805 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  801805:	55                   	push   %ebp
  801806:	89 e5                	mov    %esp,%ebp
  801808:	53                   	push   %ebx
  801809:	83 ec 14             	sub    $0x14,%esp
  80180c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80180f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801812:	50                   	push   %eax
  801813:	53                   	push   %ebx
  801814:	e8 06 fc ff ff       	call   80141f <fd_lookup>
  801819:	83 c4 08             	add    $0x8,%esp
  80181c:	85 c0                	test   %eax,%eax
  80181e:	78 37                	js     801857 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801820:	83 ec 08             	sub    $0x8,%esp
  801823:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801826:	50                   	push   %eax
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	ff 30                	pushl  (%eax)
  80182c:	e8 45 fc ff ff       	call   801476 <dev_lookup>
  801831:	83 c4 10             	add    $0x10,%esp
  801834:	85 c0                	test   %eax,%eax
  801836:	78 1f                	js     801857 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801838:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80183b:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80183f:	74 1b                	je     80185c <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801841:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801844:	8b 52 18             	mov    0x18(%edx),%edx
  801847:	85 d2                	test   %edx,%edx
  801849:	74 32                	je     80187d <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	50                   	push   %eax
  801852:	ff d2                	call   *%edx
  801854:	83 c4 10             	add    $0x10,%esp
}
  801857:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185a:	c9                   	leave  
  80185b:	c3                   	ret    
			thisenv->env_id, fdnum);
  80185c:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801861:	8b 40 48             	mov    0x48(%eax),%eax
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	53                   	push   %ebx
  801868:	50                   	push   %eax
  801869:	68 1c 29 80 00       	push   $0x80291c
  80186e:	e8 18 eb ff ff       	call   80038b <cprintf>
		return -E_INVAL;
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80187b:	eb da                	jmp    801857 <ftruncate+0x52>
		return -E_NOT_SUPP;
  80187d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801882:	eb d3                	jmp    801857 <ftruncate+0x52>

00801884 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	53                   	push   %ebx
  801888:	83 ec 14             	sub    $0x14,%esp
  80188b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80188e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801891:	50                   	push   %eax
  801892:	ff 75 08             	pushl  0x8(%ebp)
  801895:	e8 85 fb ff ff       	call   80141f <fd_lookup>
  80189a:	83 c4 08             	add    $0x8,%esp
  80189d:	85 c0                	test   %eax,%eax
  80189f:	78 4b                	js     8018ec <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018a7:	50                   	push   %eax
  8018a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ab:	ff 30                	pushl  (%eax)
  8018ad:	e8 c4 fb ff ff       	call   801476 <dev_lookup>
  8018b2:	83 c4 10             	add    $0x10,%esp
  8018b5:	85 c0                	test   %eax,%eax
  8018b7:	78 33                	js     8018ec <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8018b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018bc:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8018c0:	74 2f                	je     8018f1 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8018c2:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8018c5:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8018cc:	00 00 00 
	stat->st_type = 0;
  8018cf:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8018d6:	00 00 00 
	stat->st_dev = dev;
  8018d9:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8018df:	83 ec 08             	sub    $0x8,%esp
  8018e2:	53                   	push   %ebx
  8018e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8018e6:	ff 50 14             	call   *0x14(%eax)
  8018e9:	83 c4 10             	add    $0x10,%esp
}
  8018ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    
		return -E_NOT_SUPP;
  8018f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018f6:	eb f4                	jmp    8018ec <fstat+0x68>

008018f8 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8018f8:	55                   	push   %ebp
  8018f9:	89 e5                	mov    %esp,%ebp
  8018fb:	56                   	push   %esi
  8018fc:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8018fd:	83 ec 08             	sub    $0x8,%esp
  801900:	6a 00                	push   $0x0
  801902:	ff 75 08             	pushl  0x8(%ebp)
  801905:	e8 34 02 00 00       	call   801b3e <open>
  80190a:	89 c3                	mov    %eax,%ebx
  80190c:	83 c4 10             	add    $0x10,%esp
  80190f:	85 c0                	test   %eax,%eax
  801911:	78 1b                	js     80192e <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801913:	83 ec 08             	sub    $0x8,%esp
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	50                   	push   %eax
  80191a:	e8 65 ff ff ff       	call   801884 <fstat>
  80191f:	89 c6                	mov    %eax,%esi
	close(fd);
  801921:	89 1c 24             	mov    %ebx,(%esp)
  801924:	e8 29 fc ff ff       	call   801552 <close>
	return r;
  801929:	83 c4 10             	add    $0x10,%esp
  80192c:	89 f3                	mov    %esi,%ebx
}
  80192e:	89 d8                	mov    %ebx,%eax
  801930:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801933:	5b                   	pop    %ebx
  801934:	5e                   	pop    %esi
  801935:	5d                   	pop    %ebp
  801936:	c3                   	ret    

00801937 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
  80193a:	56                   	push   %esi
  80193b:	53                   	push   %ebx
  80193c:	89 c6                	mov    %eax,%esi
  80193e:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801940:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801947:	74 27                	je     801970 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801949:	6a 07                	push   $0x7
  80194b:	68 00 50 80 00       	push   $0x805000
  801950:	56                   	push   %esi
  801951:	ff 35 00 40 80 00    	pushl  0x804000
  801957:	e8 af f9 ff ff       	call   80130b <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80195c:	83 c4 0c             	add    $0xc,%esp
  80195f:	6a 00                	push   $0x0
  801961:	53                   	push   %ebx
  801962:	6a 00                	push   $0x0
  801964:	e8 19 f9 ff ff       	call   801282 <ipc_recv>
}
  801969:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196c:	5b                   	pop    %ebx
  80196d:	5e                   	pop    %esi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801970:	83 ec 0c             	sub    $0xc,%esp
  801973:	6a 01                	push   $0x1
  801975:	e8 ed f9 ff ff       	call   801367 <ipc_find_env>
  80197a:	a3 00 40 80 00       	mov    %eax,0x804000
  80197f:	83 c4 10             	add    $0x10,%esp
  801982:	eb c5                	jmp    801949 <fsipc+0x12>

00801984 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80198a:	8b 45 08             	mov    0x8(%ebp),%eax
  80198d:	8b 40 0c             	mov    0xc(%eax),%eax
  801990:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801995:	8b 45 0c             	mov    0xc(%ebp),%eax
  801998:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  80199d:	ba 00 00 00 00       	mov    $0x0,%edx
  8019a2:	b8 02 00 00 00       	mov    $0x2,%eax
  8019a7:	e8 8b ff ff ff       	call   801937 <fsipc>
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <devfile_flush>:
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
  8019b1:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8019ba:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  8019bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8019c4:	b8 06 00 00 00       	mov    $0x6,%eax
  8019c9:	e8 69 ff ff ff       	call   801937 <fsipc>
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <devfile_stat>:
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	53                   	push   %ebx
  8019d4:	83 ec 04             	sub    $0x4,%esp
  8019d7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8019da:	8b 45 08             	mov    0x8(%ebp),%eax
  8019dd:	8b 40 0c             	mov    0xc(%eax),%eax
  8019e0:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8019e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8019ef:	e8 43 ff ff ff       	call   801937 <fsipc>
  8019f4:	85 c0                	test   %eax,%eax
  8019f6:	78 2c                	js     801a24 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8019f8:	83 ec 08             	sub    $0x8,%esp
  8019fb:	68 00 50 80 00       	push   $0x805000
  801a00:	53                   	push   %ebx
  801a01:	e8 8d ef ff ff       	call   800993 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801a06:	a1 80 50 80 00       	mov    0x805080,%eax
  801a0b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801a11:	a1 84 50 80 00       	mov    0x805084,%eax
  801a16:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801a1c:	83 c4 10             	add    $0x10,%esp
  801a1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <devfile_write>:
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
  801a2c:	53                   	push   %ebx
  801a2d:	83 ec 04             	sub    $0x4,%esp
  801a30:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801a33:	89 d8                	mov    %ebx,%eax
  801a35:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801a3b:	76 05                	jbe    801a42 <devfile_write+0x19>
  801a3d:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801a42:	8b 55 08             	mov    0x8(%ebp),%edx
  801a45:	8b 52 0c             	mov    0xc(%edx),%edx
  801a48:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801a4e:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801a53:	83 ec 04             	sub    $0x4,%esp
  801a56:	50                   	push   %eax
  801a57:	ff 75 0c             	pushl  0xc(%ebp)
  801a5a:	68 08 50 80 00       	push   $0x805008
  801a5f:	e8 a2 f0 ff ff       	call   800b06 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801a64:	ba 00 00 00 00       	mov    $0x0,%edx
  801a69:	b8 04 00 00 00       	mov    $0x4,%eax
  801a6e:	e8 c4 fe ff ff       	call   801937 <fsipc>
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 0b                	js     801a85 <devfile_write+0x5c>
	assert(r <= n);
  801a7a:	39 c3                	cmp    %eax,%ebx
  801a7c:	72 0c                	jb     801a8a <devfile_write+0x61>
	assert(r <= PGSIZE);
  801a7e:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801a83:	7f 1e                	jg     801aa3 <devfile_write+0x7a>
}
  801a85:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a88:	c9                   	leave  
  801a89:	c3                   	ret    
	assert(r <= n);
  801a8a:	68 8c 29 80 00       	push   $0x80298c
  801a8f:	68 96 28 80 00       	push   $0x802896
  801a94:	68 98 00 00 00       	push   $0x98
  801a99:	68 93 29 80 00       	push   $0x802993
  801a9e:	e8 d5 e7 ff ff       	call   800278 <_panic>
	assert(r <= PGSIZE);
  801aa3:	68 9e 29 80 00       	push   $0x80299e
  801aa8:	68 96 28 80 00       	push   $0x802896
  801aad:	68 99 00 00 00       	push   $0x99
  801ab2:	68 93 29 80 00       	push   $0x802993
  801ab7:	e8 bc e7 ff ff       	call   800278 <_panic>

00801abc <devfile_read>:
{
  801abc:	55                   	push   %ebp
  801abd:	89 e5                	mov    %esp,%ebp
  801abf:	56                   	push   %esi
  801ac0:	53                   	push   %ebx
  801ac1:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac7:	8b 40 0c             	mov    0xc(%eax),%eax
  801aca:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801acf:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ad5:	ba 00 00 00 00       	mov    $0x0,%edx
  801ada:	b8 03 00 00 00       	mov    $0x3,%eax
  801adf:	e8 53 fe ff ff       	call   801937 <fsipc>
  801ae4:	89 c3                	mov    %eax,%ebx
  801ae6:	85 c0                	test   %eax,%eax
  801ae8:	78 1f                	js     801b09 <devfile_read+0x4d>
	assert(r <= n);
  801aea:	39 c6                	cmp    %eax,%esi
  801aec:	72 24                	jb     801b12 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801aee:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801af3:	7f 33                	jg     801b28 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801af5:	83 ec 04             	sub    $0x4,%esp
  801af8:	50                   	push   %eax
  801af9:	68 00 50 80 00       	push   $0x805000
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	e8 00 f0 ff ff       	call   800b06 <memmove>
	return r;
  801b06:	83 c4 10             	add    $0x10,%esp
}
  801b09:	89 d8                	mov    %ebx,%eax
  801b0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b0e:	5b                   	pop    %ebx
  801b0f:	5e                   	pop    %esi
  801b10:	5d                   	pop    %ebp
  801b11:	c3                   	ret    
	assert(r <= n);
  801b12:	68 8c 29 80 00       	push   $0x80298c
  801b17:	68 96 28 80 00       	push   $0x802896
  801b1c:	6a 7c                	push   $0x7c
  801b1e:	68 93 29 80 00       	push   $0x802993
  801b23:	e8 50 e7 ff ff       	call   800278 <_panic>
	assert(r <= PGSIZE);
  801b28:	68 9e 29 80 00       	push   $0x80299e
  801b2d:	68 96 28 80 00       	push   $0x802896
  801b32:	6a 7d                	push   $0x7d
  801b34:	68 93 29 80 00       	push   $0x802993
  801b39:	e8 3a e7 ff ff       	call   800278 <_panic>

00801b3e <open>:
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	56                   	push   %esi
  801b42:	53                   	push   %ebx
  801b43:	83 ec 1c             	sub    $0x1c,%esp
  801b46:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801b49:	56                   	push   %esi
  801b4a:	e8 11 ee ff ff       	call   800960 <strlen>
  801b4f:	83 c4 10             	add    $0x10,%esp
  801b52:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801b57:	7f 6c                	jg     801bc5 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801b59:	83 ec 0c             	sub    $0xc,%esp
  801b5c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801b5f:	50                   	push   %eax
  801b60:	e8 6b f8 ff ff       	call   8013d0 <fd_alloc>
  801b65:	89 c3                	mov    %eax,%ebx
  801b67:	83 c4 10             	add    $0x10,%esp
  801b6a:	85 c0                	test   %eax,%eax
  801b6c:	78 3c                	js     801baa <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801b6e:	83 ec 08             	sub    $0x8,%esp
  801b71:	56                   	push   %esi
  801b72:	68 00 50 80 00       	push   $0x805000
  801b77:	e8 17 ee ff ff       	call   800993 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801b7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b7f:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801b84:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b87:	b8 01 00 00 00       	mov    $0x1,%eax
  801b8c:	e8 a6 fd ff ff       	call   801937 <fsipc>
  801b91:	89 c3                	mov    %eax,%ebx
  801b93:	83 c4 10             	add    $0x10,%esp
  801b96:	85 c0                	test   %eax,%eax
  801b98:	78 19                	js     801bb3 <open+0x75>
	return fd2num(fd);
  801b9a:	83 ec 0c             	sub    $0xc,%esp
  801b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  801ba0:	e8 04 f8 ff ff       	call   8013a9 <fd2num>
  801ba5:	89 c3                	mov    %eax,%ebx
  801ba7:	83 c4 10             	add    $0x10,%esp
}
  801baa:	89 d8                	mov    %ebx,%eax
  801bac:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801baf:	5b                   	pop    %ebx
  801bb0:	5e                   	pop    %esi
  801bb1:	5d                   	pop    %ebp
  801bb2:	c3                   	ret    
		fd_close(fd, 0);
  801bb3:	83 ec 08             	sub    $0x8,%esp
  801bb6:	6a 00                	push   $0x0
  801bb8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bbb:	e8 0c f9 ff ff       	call   8014cc <fd_close>
		return r;
  801bc0:	83 c4 10             	add    $0x10,%esp
  801bc3:	eb e5                	jmp    801baa <open+0x6c>
		return -E_BAD_PATH;
  801bc5:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801bca:	eb de                	jmp    801baa <open+0x6c>

00801bcc <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
  801bcf:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801bd2:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd7:	b8 08 00 00 00       	mov    $0x8,%eax
  801bdc:	e8 56 fd ff ff       	call   801937 <fsipc>
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801be6:	8b 45 08             	mov    0x8(%ebp),%eax
  801be9:	c1 e8 16             	shr    $0x16,%eax
  801bec:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801bf3:	a8 01                	test   $0x1,%al
  801bf5:	74 21                	je     801c18 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfa:	c1 e8 0c             	shr    $0xc,%eax
  801bfd:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c04:	a8 01                	test   $0x1,%al
  801c06:	74 17                	je     801c1f <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c08:	c1 e8 0c             	shr    $0xc,%eax
  801c0b:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c12:	ef 
  801c13:	0f b7 c0             	movzwl %ax,%eax
  801c16:	eb 05                	jmp    801c1d <pageref+0x3a>
		return 0;
  801c18:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    
		return 0;
  801c1f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c24:	eb f7                	jmp    801c1d <pageref+0x3a>

00801c26 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
  801c29:	56                   	push   %esi
  801c2a:	53                   	push   %ebx
  801c2b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801c2e:	83 ec 0c             	sub    $0xc,%esp
  801c31:	ff 75 08             	pushl  0x8(%ebp)
  801c34:	e8 80 f7 ff ff       	call   8013b9 <fd2data>
  801c39:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801c3b:	83 c4 08             	add    $0x8,%esp
  801c3e:	68 aa 29 80 00       	push   $0x8029aa
  801c43:	53                   	push   %ebx
  801c44:	e8 4a ed ff ff       	call   800993 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801c49:	8b 46 04             	mov    0x4(%esi),%eax
  801c4c:	2b 06                	sub    (%esi),%eax
  801c4e:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801c54:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801c5b:	10 00 00 
	stat->st_dev = &devpipe;
  801c5e:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  801c65:	30 80 00 
	return 0;
}
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c70:	5b                   	pop    %ebx
  801c71:	5e                   	pop    %esi
  801c72:	5d                   	pop    %ebp
  801c73:	c3                   	ret    

00801c74 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
  801c77:	53                   	push   %ebx
  801c78:	83 ec 0c             	sub    $0xc,%esp
  801c7b:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801c7e:	53                   	push   %ebx
  801c7f:	6a 00                	push   $0x0
  801c81:	e8 47 f1 ff ff       	call   800dcd <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801c86:	89 1c 24             	mov    %ebx,(%esp)
  801c89:	e8 2b f7 ff ff       	call   8013b9 <fd2data>
  801c8e:	83 c4 08             	add    $0x8,%esp
  801c91:	50                   	push   %eax
  801c92:	6a 00                	push   $0x0
  801c94:	e8 34 f1 ff ff       	call   800dcd <sys_page_unmap>
}
  801c99:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <_pipeisclosed>:
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
  801ca1:	57                   	push   %edi
  801ca2:	56                   	push   %esi
  801ca3:	53                   	push   %ebx
  801ca4:	83 ec 1c             	sub    $0x1c,%esp
  801ca7:	89 c7                	mov    %eax,%edi
  801ca9:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801cab:	a1 04 40 80 00       	mov    0x804004,%eax
  801cb0:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801cb3:	83 ec 0c             	sub    $0xc,%esp
  801cb6:	57                   	push   %edi
  801cb7:	e8 27 ff ff ff       	call   801be3 <pageref>
  801cbc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801cbf:	89 34 24             	mov    %esi,(%esp)
  801cc2:	e8 1c ff ff ff       	call   801be3 <pageref>
		nn = thisenv->env_runs;
  801cc7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801ccd:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801cd0:	83 c4 10             	add    $0x10,%esp
  801cd3:	39 cb                	cmp    %ecx,%ebx
  801cd5:	74 1b                	je     801cf2 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801cd7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cda:	75 cf                	jne    801cab <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801cdc:	8b 42 58             	mov    0x58(%edx),%eax
  801cdf:	6a 01                	push   $0x1
  801ce1:	50                   	push   %eax
  801ce2:	53                   	push   %ebx
  801ce3:	68 b1 29 80 00       	push   $0x8029b1
  801ce8:	e8 9e e6 ff ff       	call   80038b <cprintf>
  801ced:	83 c4 10             	add    $0x10,%esp
  801cf0:	eb b9                	jmp    801cab <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801cf2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801cf5:	0f 94 c0             	sete   %al
  801cf8:	0f b6 c0             	movzbl %al,%eax
}
  801cfb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801cfe:	5b                   	pop    %ebx
  801cff:	5e                   	pop    %esi
  801d00:	5f                   	pop    %edi
  801d01:	5d                   	pop    %ebp
  801d02:	c3                   	ret    

00801d03 <devpipe_write>:
{
  801d03:	55                   	push   %ebp
  801d04:	89 e5                	mov    %esp,%ebp
  801d06:	57                   	push   %edi
  801d07:	56                   	push   %esi
  801d08:	53                   	push   %ebx
  801d09:	83 ec 18             	sub    $0x18,%esp
  801d0c:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801d0f:	56                   	push   %esi
  801d10:	e8 a4 f6 ff ff       	call   8013b9 <fd2data>
  801d15:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801d17:	83 c4 10             	add    $0x10,%esp
  801d1a:	bf 00 00 00 00       	mov    $0x0,%edi
  801d1f:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801d22:	74 41                	je     801d65 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801d24:	8b 53 04             	mov    0x4(%ebx),%edx
  801d27:	8b 03                	mov    (%ebx),%eax
  801d29:	83 c0 20             	add    $0x20,%eax
  801d2c:	39 c2                	cmp    %eax,%edx
  801d2e:	72 14                	jb     801d44 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801d30:	89 da                	mov    %ebx,%edx
  801d32:	89 f0                	mov    %esi,%eax
  801d34:	e8 65 ff ff ff       	call   801c9e <_pipeisclosed>
  801d39:	85 c0                	test   %eax,%eax
  801d3b:	75 2c                	jne    801d69 <devpipe_write+0x66>
			sys_yield();
  801d3d:	e8 cd f0 ff ff       	call   800e0f <sys_yield>
  801d42:	eb e0                	jmp    801d24 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d47:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801d4a:	89 d0                	mov    %edx,%eax
  801d4c:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801d51:	78 0b                	js     801d5e <devpipe_write+0x5b>
  801d53:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801d57:	42                   	inc    %edx
  801d58:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801d5b:	47                   	inc    %edi
  801d5c:	eb c1                	jmp    801d1f <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801d5e:	48                   	dec    %eax
  801d5f:	83 c8 e0             	or     $0xffffffe0,%eax
  801d62:	40                   	inc    %eax
  801d63:	eb ee                	jmp    801d53 <devpipe_write+0x50>
	return i;
  801d65:	89 f8                	mov    %edi,%eax
  801d67:	eb 05                	jmp    801d6e <devpipe_write+0x6b>
				return 0;
  801d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d6e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d71:	5b                   	pop    %ebx
  801d72:	5e                   	pop    %esi
  801d73:	5f                   	pop    %edi
  801d74:	5d                   	pop    %ebp
  801d75:	c3                   	ret    

00801d76 <devpipe_read>:
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
  801d79:	57                   	push   %edi
  801d7a:	56                   	push   %esi
  801d7b:	53                   	push   %ebx
  801d7c:	83 ec 18             	sub    $0x18,%esp
  801d7f:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801d82:	57                   	push   %edi
  801d83:	e8 31 f6 ff ff       	call   8013b9 <fd2data>
  801d88:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801d8a:	83 c4 10             	add    $0x10,%esp
  801d8d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801d92:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801d95:	74 46                	je     801ddd <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801d97:	8b 06                	mov    (%esi),%eax
  801d99:	3b 46 04             	cmp    0x4(%esi),%eax
  801d9c:	75 22                	jne    801dc0 <devpipe_read+0x4a>
			if (i > 0)
  801d9e:	85 db                	test   %ebx,%ebx
  801da0:	74 0a                	je     801dac <devpipe_read+0x36>
				return i;
  801da2:	89 d8                	mov    %ebx,%eax
}
  801da4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801da7:	5b                   	pop    %ebx
  801da8:	5e                   	pop    %esi
  801da9:	5f                   	pop    %edi
  801daa:	5d                   	pop    %ebp
  801dab:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801dac:	89 f2                	mov    %esi,%edx
  801dae:	89 f8                	mov    %edi,%eax
  801db0:	e8 e9 fe ff ff       	call   801c9e <_pipeisclosed>
  801db5:	85 c0                	test   %eax,%eax
  801db7:	75 28                	jne    801de1 <devpipe_read+0x6b>
			sys_yield();
  801db9:	e8 51 f0 ff ff       	call   800e0f <sys_yield>
  801dbe:	eb d7                	jmp    801d97 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dc0:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801dc5:	78 0f                	js     801dd6 <devpipe_read+0x60>
  801dc7:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801dcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dce:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801dd1:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801dd3:	43                   	inc    %ebx
  801dd4:	eb bc                	jmp    801d92 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801dd6:	48                   	dec    %eax
  801dd7:	83 c8 e0             	or     $0xffffffe0,%eax
  801dda:	40                   	inc    %eax
  801ddb:	eb ea                	jmp    801dc7 <devpipe_read+0x51>
	return i;
  801ddd:	89 d8                	mov    %ebx,%eax
  801ddf:	eb c3                	jmp    801da4 <devpipe_read+0x2e>
				return 0;
  801de1:	b8 00 00 00 00       	mov    $0x0,%eax
  801de6:	eb bc                	jmp    801da4 <devpipe_read+0x2e>

00801de8 <pipe>:
{
  801de8:	55                   	push   %ebp
  801de9:	89 e5                	mov    %esp,%ebp
  801deb:	56                   	push   %esi
  801dec:	53                   	push   %ebx
  801ded:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801df0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801df3:	50                   	push   %eax
  801df4:	e8 d7 f5 ff ff       	call   8013d0 <fd_alloc>
  801df9:	89 c3                	mov    %eax,%ebx
  801dfb:	83 c4 10             	add    $0x10,%esp
  801dfe:	85 c0                	test   %eax,%eax
  801e00:	0f 88 2a 01 00 00    	js     801f30 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e06:	83 ec 04             	sub    $0x4,%esp
  801e09:	68 07 04 00 00       	push   $0x407
  801e0e:	ff 75 f4             	pushl  -0xc(%ebp)
  801e11:	6a 00                	push   $0x0
  801e13:	e8 30 ef ff ff       	call   800d48 <sys_page_alloc>
  801e18:	89 c3                	mov    %eax,%ebx
  801e1a:	83 c4 10             	add    $0x10,%esp
  801e1d:	85 c0                	test   %eax,%eax
  801e1f:	0f 88 0b 01 00 00    	js     801f30 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801e25:	83 ec 0c             	sub    $0xc,%esp
  801e28:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801e2b:	50                   	push   %eax
  801e2c:	e8 9f f5 ff ff       	call   8013d0 <fd_alloc>
  801e31:	89 c3                	mov    %eax,%ebx
  801e33:	83 c4 10             	add    $0x10,%esp
  801e36:	85 c0                	test   %eax,%eax
  801e38:	0f 88 e2 00 00 00    	js     801f20 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e3e:	83 ec 04             	sub    $0x4,%esp
  801e41:	68 07 04 00 00       	push   $0x407
  801e46:	ff 75 f0             	pushl  -0x10(%ebp)
  801e49:	6a 00                	push   $0x0
  801e4b:	e8 f8 ee ff ff       	call   800d48 <sys_page_alloc>
  801e50:	89 c3                	mov    %eax,%ebx
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	85 c0                	test   %eax,%eax
  801e57:	0f 88 c3 00 00 00    	js     801f20 <pipe+0x138>
	va = fd2data(fd0);
  801e5d:	83 ec 0c             	sub    $0xc,%esp
  801e60:	ff 75 f4             	pushl  -0xc(%ebp)
  801e63:	e8 51 f5 ff ff       	call   8013b9 <fd2data>
  801e68:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e6a:	83 c4 0c             	add    $0xc,%esp
  801e6d:	68 07 04 00 00       	push   $0x407
  801e72:	50                   	push   %eax
  801e73:	6a 00                	push   $0x0
  801e75:	e8 ce ee ff ff       	call   800d48 <sys_page_alloc>
  801e7a:	89 c3                	mov    %eax,%ebx
  801e7c:	83 c4 10             	add    $0x10,%esp
  801e7f:	85 c0                	test   %eax,%eax
  801e81:	0f 88 89 00 00 00    	js     801f10 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801e87:	83 ec 0c             	sub    $0xc,%esp
  801e8a:	ff 75 f0             	pushl  -0x10(%ebp)
  801e8d:	e8 27 f5 ff ff       	call   8013b9 <fd2data>
  801e92:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  801e99:	50                   	push   %eax
  801e9a:	6a 00                	push   $0x0
  801e9c:	56                   	push   %esi
  801e9d:	6a 00                	push   $0x0
  801e9f:	e8 e7 ee ff ff       	call   800d8b <sys_page_map>
  801ea4:	89 c3                	mov    %eax,%ebx
  801ea6:	83 c4 20             	add    $0x20,%esp
  801ea9:	85 c0                	test   %eax,%eax
  801eab:	78 55                	js     801f02 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801ead:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801eb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801eb6:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  801eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ebb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801ec2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  801ec8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ecb:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ed0:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  801ed7:	83 ec 0c             	sub    $0xc,%esp
  801eda:	ff 75 f4             	pushl  -0xc(%ebp)
  801edd:	e8 c7 f4 ff ff       	call   8013a9 <fd2num>
  801ee2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ee5:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  801ee7:	83 c4 04             	add    $0x4,%esp
  801eea:	ff 75 f0             	pushl  -0x10(%ebp)
  801eed:	e8 b7 f4 ff ff       	call   8013a9 <fd2num>
  801ef2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801ef5:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  801ef8:	83 c4 10             	add    $0x10,%esp
  801efb:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f00:	eb 2e                	jmp    801f30 <pipe+0x148>
	sys_page_unmap(0, va);
  801f02:	83 ec 08             	sub    $0x8,%esp
  801f05:	56                   	push   %esi
  801f06:	6a 00                	push   $0x0
  801f08:	e8 c0 ee ff ff       	call   800dcd <sys_page_unmap>
  801f0d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801f10:	83 ec 08             	sub    $0x8,%esp
  801f13:	ff 75 f0             	pushl  -0x10(%ebp)
  801f16:	6a 00                	push   $0x0
  801f18:	e8 b0 ee ff ff       	call   800dcd <sys_page_unmap>
  801f1d:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801f20:	83 ec 08             	sub    $0x8,%esp
  801f23:	ff 75 f4             	pushl  -0xc(%ebp)
  801f26:	6a 00                	push   $0x0
  801f28:	e8 a0 ee ff ff       	call   800dcd <sys_page_unmap>
  801f2d:	83 c4 10             	add    $0x10,%esp
}
  801f30:	89 d8                	mov    %ebx,%eax
  801f32:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5d                   	pop    %ebp
  801f38:	c3                   	ret    

00801f39 <pipeisclosed>:
{
  801f39:	55                   	push   %ebp
  801f3a:	89 e5                	mov    %esp,%ebp
  801f3c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801f3f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f42:	50                   	push   %eax
  801f43:	ff 75 08             	pushl  0x8(%ebp)
  801f46:	e8 d4 f4 ff ff       	call   80141f <fd_lookup>
  801f4b:	83 c4 10             	add    $0x10,%esp
  801f4e:	85 c0                	test   %eax,%eax
  801f50:	78 18                	js     801f6a <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	ff 75 f4             	pushl  -0xc(%ebp)
  801f58:	e8 5c f4 ff ff       	call   8013b9 <fd2data>
	return _pipeisclosed(fd, p);
  801f5d:	89 c2                	mov    %eax,%edx
  801f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f62:	e8 37 fd ff ff       	call   801c9e <_pipeisclosed>
  801f67:	83 c4 10             	add    $0x10,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	5d                   	pop    %ebp
  801f75:	c3                   	ret    

00801f76 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	53                   	push   %ebx
  801f7a:	83 ec 0c             	sub    $0xc,%esp
  801f7d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  801f80:	68 c9 29 80 00       	push   $0x8029c9
  801f85:	53                   	push   %ebx
  801f86:	e8 08 ea ff ff       	call   800993 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  801f8b:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  801f92:	20 00 00 
	return 0;
}
  801f95:	b8 00 00 00 00       	mov    $0x0,%eax
  801f9a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <devcons_write>:
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	57                   	push   %edi
  801fa3:	56                   	push   %esi
  801fa4:	53                   	push   %ebx
  801fa5:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801fab:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801fb0:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  801fb6:	eb 1d                	jmp    801fd5 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  801fb8:	83 ec 04             	sub    $0x4,%esp
  801fbb:	53                   	push   %ebx
  801fbc:	03 45 0c             	add    0xc(%ebp),%eax
  801fbf:	50                   	push   %eax
  801fc0:	57                   	push   %edi
  801fc1:	e8 40 eb ff ff       	call   800b06 <memmove>
		sys_cputs(buf, m);
  801fc6:	83 c4 08             	add    $0x8,%esp
  801fc9:	53                   	push   %ebx
  801fca:	57                   	push   %edi
  801fcb:	e8 db ec ff ff       	call   800cab <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801fd0:	01 de                	add    %ebx,%esi
  801fd2:	83 c4 10             	add    $0x10,%esp
  801fd5:	89 f0                	mov    %esi,%eax
  801fd7:	3b 75 10             	cmp    0x10(%ebp),%esi
  801fda:	73 11                	jae    801fed <devcons_write+0x4e>
		m = n - tot;
  801fdc:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801fdf:	29 f3                	sub    %esi,%ebx
  801fe1:	83 fb 7f             	cmp    $0x7f,%ebx
  801fe4:	76 d2                	jbe    801fb8 <devcons_write+0x19>
  801fe6:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801feb:	eb cb                	jmp    801fb8 <devcons_write+0x19>
}
  801fed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ff0:	5b                   	pop    %ebx
  801ff1:	5e                   	pop    %esi
  801ff2:	5f                   	pop    %edi
  801ff3:	5d                   	pop    %ebp
  801ff4:	c3                   	ret    

00801ff5 <devcons_read>:
{
  801ff5:	55                   	push   %ebp
  801ff6:	89 e5                	mov    %esp,%ebp
  801ff8:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801ffb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801fff:	75 0c                	jne    80200d <devcons_read+0x18>
		return 0;
  802001:	b8 00 00 00 00       	mov    $0x0,%eax
  802006:	eb 21                	jmp    802029 <devcons_read+0x34>
		sys_yield();
  802008:	e8 02 ee ff ff       	call   800e0f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80200d:	e8 b7 ec ff ff       	call   800cc9 <sys_cgetc>
  802012:	85 c0                	test   %eax,%eax
  802014:	74 f2                	je     802008 <devcons_read+0x13>
	if (c < 0)
  802016:	85 c0                	test   %eax,%eax
  802018:	78 0f                	js     802029 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80201a:	83 f8 04             	cmp    $0x4,%eax
  80201d:	74 0c                	je     80202b <devcons_read+0x36>
	*(char*)vbuf = c;
  80201f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802022:	88 02                	mov    %al,(%edx)
	return 1;
  802024:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    
		return 0;
  80202b:	b8 00 00 00 00       	mov    $0x0,%eax
  802030:	eb f7                	jmp    802029 <devcons_read+0x34>

00802032 <cputchar>:
{
  802032:	55                   	push   %ebp
  802033:	89 e5                	mov    %esp,%ebp
  802035:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80203e:	6a 01                	push   $0x1
  802040:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802043:	50                   	push   %eax
  802044:	e8 62 ec ff ff       	call   800cab <sys_cputs>
}
  802049:	83 c4 10             	add    $0x10,%esp
  80204c:	c9                   	leave  
  80204d:	c3                   	ret    

0080204e <getchar>:
{
  80204e:	55                   	push   %ebp
  80204f:	89 e5                	mov    %esp,%ebp
  802051:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  802054:	6a 01                	push   $0x1
  802056:	8d 45 f7             	lea    -0x9(%ebp),%eax
  802059:	50                   	push   %eax
  80205a:	6a 00                	push   $0x0
  80205c:	e8 2b f6 ff ff       	call   80168c <read>
	if (r < 0)
  802061:	83 c4 10             	add    $0x10,%esp
  802064:	85 c0                	test   %eax,%eax
  802066:	78 08                	js     802070 <getchar+0x22>
	if (r < 1)
  802068:	85 c0                	test   %eax,%eax
  80206a:	7e 06                	jle    802072 <getchar+0x24>
	return c;
  80206c:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  802070:	c9                   	leave  
  802071:	c3                   	ret    
		return -E_EOF;
  802072:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802077:	eb f7                	jmp    802070 <getchar+0x22>

00802079 <iscons>:
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80207f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802082:	50                   	push   %eax
  802083:	ff 75 08             	pushl  0x8(%ebp)
  802086:	e8 94 f3 ff ff       	call   80141f <fd_lookup>
  80208b:	83 c4 10             	add    $0x10,%esp
  80208e:	85 c0                	test   %eax,%eax
  802090:	78 11                	js     8020a3 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80209b:	39 10                	cmp    %edx,(%eax)
  80209d:	0f 94 c0             	sete   %al
  8020a0:	0f b6 c0             	movzbl %al,%eax
}
  8020a3:	c9                   	leave  
  8020a4:	c3                   	ret    

008020a5 <opencons>:
{
  8020a5:	55                   	push   %ebp
  8020a6:	89 e5                	mov    %esp,%ebp
  8020a8:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8020ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020ae:	50                   	push   %eax
  8020af:	e8 1c f3 ff ff       	call   8013d0 <fd_alloc>
  8020b4:	83 c4 10             	add    $0x10,%esp
  8020b7:	85 c0                	test   %eax,%eax
  8020b9:	78 3a                	js     8020f5 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8020bb:	83 ec 04             	sub    $0x4,%esp
  8020be:	68 07 04 00 00       	push   $0x407
  8020c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020c6:	6a 00                	push   $0x0
  8020c8:	e8 7b ec ff ff       	call   800d48 <sys_page_alloc>
  8020cd:	83 c4 10             	add    $0x10,%esp
  8020d0:	85 c0                	test   %eax,%eax
  8020d2:	78 21                	js     8020f5 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8020d4:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8020da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020dd:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8020df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e2:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8020e9:	83 ec 0c             	sub    $0xc,%esp
  8020ec:	50                   	push   %eax
  8020ed:	e8 b7 f2 ff ff       	call   8013a9 <fd2num>
  8020f2:	83 c4 10             	add    $0x10,%esp
}
  8020f5:	c9                   	leave  
  8020f6:	c3                   	ret    

008020f7 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8020f7:	55                   	push   %ebp
  8020f8:	89 e5                	mov    %esp,%ebp
  8020fa:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8020fd:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  802104:	74 0a                	je     802110 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802106:	8b 45 08             	mov    0x8(%ebp),%eax
  802109:	a3 00 60 80 00       	mov    %eax,0x806000
}
  80210e:	c9                   	leave  
  80210f:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  802110:	e8 14 ec ff ff       	call   800d29 <sys_getenvid>
  802115:	83 ec 04             	sub    $0x4,%esp
  802118:	6a 07                	push   $0x7
  80211a:	68 00 f0 bf ee       	push   $0xeebff000
  80211f:	50                   	push   %eax
  802120:	e8 23 ec ff ff       	call   800d48 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802125:	e8 ff eb ff ff       	call   800d29 <sys_getenvid>
  80212a:	83 c4 08             	add    $0x8,%esp
  80212d:	68 3d 21 80 00       	push   $0x80213d
  802132:	50                   	push   %eax
  802133:	e8 bb ed ff ff       	call   800ef3 <sys_env_set_pgfault_upcall>
  802138:	83 c4 10             	add    $0x10,%esp
  80213b:	eb c9                	jmp    802106 <set_pgfault_handler+0xf>

0080213d <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80213d:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80213e:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  802143:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  802145:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  802148:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80214c:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802150:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802153:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  802155:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  802159:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80215c:	61                   	popa   
	addl $4, %esp
  80215d:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802160:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802161:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802162:	c3                   	ret    
  802163:	90                   	nop

00802164 <__udivdi3>:
  802164:	55                   	push   %ebp
  802165:	57                   	push   %edi
  802166:	56                   	push   %esi
  802167:	53                   	push   %ebx
  802168:	83 ec 1c             	sub    $0x1c,%esp
  80216b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80216f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  802173:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802177:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  80217b:	89 ca                	mov    %ecx,%edx
  80217d:	89 f8                	mov    %edi,%eax
  80217f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802183:	85 f6                	test   %esi,%esi
  802185:	75 2d                	jne    8021b4 <__udivdi3+0x50>
  802187:	39 cf                	cmp    %ecx,%edi
  802189:	77 65                	ja     8021f0 <__udivdi3+0x8c>
  80218b:	89 fd                	mov    %edi,%ebp
  80218d:	85 ff                	test   %edi,%edi
  80218f:	75 0b                	jne    80219c <__udivdi3+0x38>
  802191:	b8 01 00 00 00       	mov    $0x1,%eax
  802196:	31 d2                	xor    %edx,%edx
  802198:	f7 f7                	div    %edi
  80219a:	89 c5                	mov    %eax,%ebp
  80219c:	31 d2                	xor    %edx,%edx
  80219e:	89 c8                	mov    %ecx,%eax
  8021a0:	f7 f5                	div    %ebp
  8021a2:	89 c1                	mov    %eax,%ecx
  8021a4:	89 d8                	mov    %ebx,%eax
  8021a6:	f7 f5                	div    %ebp
  8021a8:	89 cf                	mov    %ecx,%edi
  8021aa:	89 fa                	mov    %edi,%edx
  8021ac:	83 c4 1c             	add    $0x1c,%esp
  8021af:	5b                   	pop    %ebx
  8021b0:	5e                   	pop    %esi
  8021b1:	5f                   	pop    %edi
  8021b2:	5d                   	pop    %ebp
  8021b3:	c3                   	ret    
  8021b4:	39 ce                	cmp    %ecx,%esi
  8021b6:	77 28                	ja     8021e0 <__udivdi3+0x7c>
  8021b8:	0f bd fe             	bsr    %esi,%edi
  8021bb:	83 f7 1f             	xor    $0x1f,%edi
  8021be:	75 40                	jne    802200 <__udivdi3+0x9c>
  8021c0:	39 ce                	cmp    %ecx,%esi
  8021c2:	72 0a                	jb     8021ce <__udivdi3+0x6a>
  8021c4:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8021c8:	0f 87 9e 00 00 00    	ja     80226c <__udivdi3+0x108>
  8021ce:	b8 01 00 00 00       	mov    $0x1,%eax
  8021d3:	89 fa                	mov    %edi,%edx
  8021d5:	83 c4 1c             	add    $0x1c,%esp
  8021d8:	5b                   	pop    %ebx
  8021d9:	5e                   	pop    %esi
  8021da:	5f                   	pop    %edi
  8021db:	5d                   	pop    %ebp
  8021dc:	c3                   	ret    
  8021dd:	8d 76 00             	lea    0x0(%esi),%esi
  8021e0:	31 ff                	xor    %edi,%edi
  8021e2:	31 c0                	xor    %eax,%eax
  8021e4:	89 fa                	mov    %edi,%edx
  8021e6:	83 c4 1c             	add    $0x1c,%esp
  8021e9:	5b                   	pop    %ebx
  8021ea:	5e                   	pop    %esi
  8021eb:	5f                   	pop    %edi
  8021ec:	5d                   	pop    %ebp
  8021ed:	c3                   	ret    
  8021ee:	66 90                	xchg   %ax,%ax
  8021f0:	89 d8                	mov    %ebx,%eax
  8021f2:	f7 f7                	div    %edi
  8021f4:	31 ff                	xor    %edi,%edi
  8021f6:	89 fa                	mov    %edi,%edx
  8021f8:	83 c4 1c             	add    $0x1c,%esp
  8021fb:	5b                   	pop    %ebx
  8021fc:	5e                   	pop    %esi
  8021fd:	5f                   	pop    %edi
  8021fe:	5d                   	pop    %ebp
  8021ff:	c3                   	ret    
  802200:	bd 20 00 00 00       	mov    $0x20,%ebp
  802205:	29 fd                	sub    %edi,%ebp
  802207:	89 f9                	mov    %edi,%ecx
  802209:	d3 e6                	shl    %cl,%esi
  80220b:	89 c3                	mov    %eax,%ebx
  80220d:	89 e9                	mov    %ebp,%ecx
  80220f:	d3 eb                	shr    %cl,%ebx
  802211:	89 d9                	mov    %ebx,%ecx
  802213:	09 f1                	or     %esi,%ecx
  802215:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802219:	89 f9                	mov    %edi,%ecx
  80221b:	d3 e0                	shl    %cl,%eax
  80221d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802221:	89 d6                	mov    %edx,%esi
  802223:	89 e9                	mov    %ebp,%ecx
  802225:	d3 ee                	shr    %cl,%esi
  802227:	89 f9                	mov    %edi,%ecx
  802229:	d3 e2                	shl    %cl,%edx
  80222b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80222f:	89 e9                	mov    %ebp,%ecx
  802231:	d3 eb                	shr    %cl,%ebx
  802233:	09 da                	or     %ebx,%edx
  802235:	89 d0                	mov    %edx,%eax
  802237:	89 f2                	mov    %esi,%edx
  802239:	f7 74 24 08          	divl   0x8(%esp)
  80223d:	89 d6                	mov    %edx,%esi
  80223f:	89 c3                	mov    %eax,%ebx
  802241:	f7 64 24 0c          	mull   0xc(%esp)
  802245:	39 d6                	cmp    %edx,%esi
  802247:	72 17                	jb     802260 <__udivdi3+0xfc>
  802249:	74 09                	je     802254 <__udivdi3+0xf0>
  80224b:	89 d8                	mov    %ebx,%eax
  80224d:	31 ff                	xor    %edi,%edi
  80224f:	e9 56 ff ff ff       	jmp    8021aa <__udivdi3+0x46>
  802254:	8b 54 24 04          	mov    0x4(%esp),%edx
  802258:	89 f9                	mov    %edi,%ecx
  80225a:	d3 e2                	shl    %cl,%edx
  80225c:	39 c2                	cmp    %eax,%edx
  80225e:	73 eb                	jae    80224b <__udivdi3+0xe7>
  802260:	8d 43 ff             	lea    -0x1(%ebx),%eax
  802263:	31 ff                	xor    %edi,%edi
  802265:	e9 40 ff ff ff       	jmp    8021aa <__udivdi3+0x46>
  80226a:	66 90                	xchg   %ax,%ax
  80226c:	31 c0                	xor    %eax,%eax
  80226e:	e9 37 ff ff ff       	jmp    8021aa <__udivdi3+0x46>
  802273:	90                   	nop

00802274 <__umoddi3>:
  802274:	55                   	push   %ebp
  802275:	57                   	push   %edi
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	83 ec 1c             	sub    $0x1c,%esp
  80227b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80227f:	8b 74 24 34          	mov    0x34(%esp),%esi
  802283:	8b 7c 24 38          	mov    0x38(%esp),%edi
  802287:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80228b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80228f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802293:	89 3c 24             	mov    %edi,(%esp)
  802296:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80229a:	89 f2                	mov    %esi,%edx
  80229c:	85 c0                	test   %eax,%eax
  80229e:	75 18                	jne    8022b8 <__umoddi3+0x44>
  8022a0:	39 f7                	cmp    %esi,%edi
  8022a2:	0f 86 a0 00 00 00    	jbe    802348 <__umoddi3+0xd4>
  8022a8:	89 c8                	mov    %ecx,%eax
  8022aa:	f7 f7                	div    %edi
  8022ac:	89 d0                	mov    %edx,%eax
  8022ae:	31 d2                	xor    %edx,%edx
  8022b0:	83 c4 1c             	add    $0x1c,%esp
  8022b3:	5b                   	pop    %ebx
  8022b4:	5e                   	pop    %esi
  8022b5:	5f                   	pop    %edi
  8022b6:	5d                   	pop    %ebp
  8022b7:	c3                   	ret    
  8022b8:	89 f3                	mov    %esi,%ebx
  8022ba:	39 f0                	cmp    %esi,%eax
  8022bc:	0f 87 a6 00 00 00    	ja     802368 <__umoddi3+0xf4>
  8022c2:	0f bd e8             	bsr    %eax,%ebp
  8022c5:	83 f5 1f             	xor    $0x1f,%ebp
  8022c8:	0f 84 a6 00 00 00    	je     802374 <__umoddi3+0x100>
  8022ce:	bf 20 00 00 00       	mov    $0x20,%edi
  8022d3:	29 ef                	sub    %ebp,%edi
  8022d5:	89 e9                	mov    %ebp,%ecx
  8022d7:	d3 e0                	shl    %cl,%eax
  8022d9:	8b 34 24             	mov    (%esp),%esi
  8022dc:	89 f2                	mov    %esi,%edx
  8022de:	89 f9                	mov    %edi,%ecx
  8022e0:	d3 ea                	shr    %cl,%edx
  8022e2:	09 c2                	or     %eax,%edx
  8022e4:	89 14 24             	mov    %edx,(%esp)
  8022e7:	89 f2                	mov    %esi,%edx
  8022e9:	89 e9                	mov    %ebp,%ecx
  8022eb:	d3 e2                	shl    %cl,%edx
  8022ed:	89 54 24 04          	mov    %edx,0x4(%esp)
  8022f1:	89 de                	mov    %ebx,%esi
  8022f3:	89 f9                	mov    %edi,%ecx
  8022f5:	d3 ee                	shr    %cl,%esi
  8022f7:	89 e9                	mov    %ebp,%ecx
  8022f9:	d3 e3                	shl    %cl,%ebx
  8022fb:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022ff:	89 d0                	mov    %edx,%eax
  802301:	89 f9                	mov    %edi,%ecx
  802303:	d3 e8                	shr    %cl,%eax
  802305:	09 d8                	or     %ebx,%eax
  802307:	89 d3                	mov    %edx,%ebx
  802309:	89 e9                	mov    %ebp,%ecx
  80230b:	d3 e3                	shl    %cl,%ebx
  80230d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802311:	89 f2                	mov    %esi,%edx
  802313:	f7 34 24             	divl   (%esp)
  802316:	89 d6                	mov    %edx,%esi
  802318:	f7 64 24 04          	mull   0x4(%esp)
  80231c:	89 c3                	mov    %eax,%ebx
  80231e:	89 d1                	mov    %edx,%ecx
  802320:	39 d6                	cmp    %edx,%esi
  802322:	72 7c                	jb     8023a0 <__umoddi3+0x12c>
  802324:	74 72                	je     802398 <__umoddi3+0x124>
  802326:	8b 54 24 08          	mov    0x8(%esp),%edx
  80232a:	29 da                	sub    %ebx,%edx
  80232c:	19 ce                	sbb    %ecx,%esi
  80232e:	89 f0                	mov    %esi,%eax
  802330:	89 f9                	mov    %edi,%ecx
  802332:	d3 e0                	shl    %cl,%eax
  802334:	89 e9                	mov    %ebp,%ecx
  802336:	d3 ea                	shr    %cl,%edx
  802338:	09 d0                	or     %edx,%eax
  80233a:	89 e9                	mov    %ebp,%ecx
  80233c:	d3 ee                	shr    %cl,%esi
  80233e:	89 f2                	mov    %esi,%edx
  802340:	83 c4 1c             	add    $0x1c,%esp
  802343:	5b                   	pop    %ebx
  802344:	5e                   	pop    %esi
  802345:	5f                   	pop    %edi
  802346:	5d                   	pop    %ebp
  802347:	c3                   	ret    
  802348:	89 fd                	mov    %edi,%ebp
  80234a:	85 ff                	test   %edi,%edi
  80234c:	75 0b                	jne    802359 <__umoddi3+0xe5>
  80234e:	b8 01 00 00 00       	mov    $0x1,%eax
  802353:	31 d2                	xor    %edx,%edx
  802355:	f7 f7                	div    %edi
  802357:	89 c5                	mov    %eax,%ebp
  802359:	89 f0                	mov    %esi,%eax
  80235b:	31 d2                	xor    %edx,%edx
  80235d:	f7 f5                	div    %ebp
  80235f:	89 c8                	mov    %ecx,%eax
  802361:	f7 f5                	div    %ebp
  802363:	e9 44 ff ff ff       	jmp    8022ac <__umoddi3+0x38>
  802368:	89 c8                	mov    %ecx,%eax
  80236a:	89 f2                	mov    %esi,%edx
  80236c:	83 c4 1c             	add    $0x1c,%esp
  80236f:	5b                   	pop    %ebx
  802370:	5e                   	pop    %esi
  802371:	5f                   	pop    %edi
  802372:	5d                   	pop    %ebp
  802373:	c3                   	ret    
  802374:	39 f0                	cmp    %esi,%eax
  802376:	72 05                	jb     80237d <__umoddi3+0x109>
  802378:	39 0c 24             	cmp    %ecx,(%esp)
  80237b:	77 0c                	ja     802389 <__umoddi3+0x115>
  80237d:	89 f2                	mov    %esi,%edx
  80237f:	29 f9                	sub    %edi,%ecx
  802381:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802385:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802389:	8b 44 24 04          	mov    0x4(%esp),%eax
  80238d:	83 c4 1c             	add    $0x1c,%esp
  802390:	5b                   	pop    %ebx
  802391:	5e                   	pop    %esi
  802392:	5f                   	pop    %edi
  802393:	5d                   	pop    %ebp
  802394:	c3                   	ret    
  802395:	8d 76 00             	lea    0x0(%esi),%esi
  802398:	39 44 24 08          	cmp    %eax,0x8(%esp)
  80239c:	73 88                	jae    802326 <__umoddi3+0xb2>
  80239e:	66 90                	xchg   %ax,%ax
  8023a0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8023a4:	1b 14 24             	sbb    (%esp),%edx
  8023a7:	89 d1                	mov    %edx,%ecx
  8023a9:	89 c3                	mov    %eax,%ebx
  8023ab:	e9 76 ff ff ff       	jmp    802326 <__umoddi3+0xb2>
