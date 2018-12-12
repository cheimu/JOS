
obj/user/testshell.debug:     file format elf32-i386


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
  80002c:	e8 6f 04 00 00       	call   8004a0 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <wrong>:
	breakpoint();
}

void
wrong(int rfd, int kfd, int off)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	81 ec 84 00 00 00    	sub    $0x84,%esp
  80003f:	8b 75 08             	mov    0x8(%ebp),%esi
  800042:	8b 7d 0c             	mov    0xc(%ebp),%edi
  800045:	8b 5d 10             	mov    0x10(%ebp),%ebx
	char buf[100];
	int n;

	seek(rfd, off);
  800048:	53                   	push   %ebx
  800049:	56                   	push   %esi
  80004a:	e8 f4 18 00 00       	call   801943 <seek>
	seek(kfd, off);
  80004f:	83 c4 08             	add    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	57                   	push   %edi
  800054:	e8 ea 18 00 00       	call   801943 <seek>

	cprintf("shell produced incorrect output.\n");
  800059:	c7 04 24 00 2b 80 00 	movl   $0x802b00,(%esp)
  800060:	e8 b4 05 00 00       	call   800619 <cprintf>
	cprintf("expected:\n===\n");
  800065:	c7 04 24 6b 2b 80 00 	movl   $0x802b6b,(%esp)
  80006c:	e8 a8 05 00 00       	call   800619 <cprintf>
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800071:	83 c4 10             	add    $0x10,%esp
  800074:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  800077:	eb 0d                	jmp    800086 <wrong+0x53>
		sys_cputs(buf, n);
  800079:	83 ec 08             	sub    $0x8,%esp
  80007c:	50                   	push   %eax
  80007d:	53                   	push   %ebx
  80007e:	e8 b6 0e 00 00       	call   800f39 <sys_cputs>
  800083:	83 c4 10             	add    $0x10,%esp
	while ((n = read(kfd, buf, sizeof buf-1)) > 0)
  800086:	83 ec 04             	sub    $0x4,%esp
  800089:	6a 63                	push   $0x63
  80008b:	53                   	push   %ebx
  80008c:	57                   	push   %edi
  80008d:	e8 61 17 00 00       	call   8017f3 <read>
  800092:	83 c4 10             	add    $0x10,%esp
  800095:	85 c0                	test   %eax,%eax
  800097:	7f e0                	jg     800079 <wrong+0x46>
	cprintf("===\ngot:\n===\n");
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	68 7a 2b 80 00       	push   $0x802b7a
  8000a1:	e8 73 05 00 00       	call   800619 <cprintf>
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000a6:	83 c4 10             	add    $0x10,%esp
  8000a9:	8d 5d 84             	lea    -0x7c(%ebp),%ebx
  8000ac:	eb 0d                	jmp    8000bb <wrong+0x88>
		sys_cputs(buf, n);
  8000ae:	83 ec 08             	sub    $0x8,%esp
  8000b1:	50                   	push   %eax
  8000b2:	53                   	push   %ebx
  8000b3:	e8 81 0e 00 00       	call   800f39 <sys_cputs>
  8000b8:	83 c4 10             	add    $0x10,%esp
	while ((n = read(rfd, buf, sizeof buf-1)) > 0)
  8000bb:	83 ec 04             	sub    $0x4,%esp
  8000be:	6a 63                	push   $0x63
  8000c0:	53                   	push   %ebx
  8000c1:	56                   	push   %esi
  8000c2:	e8 2c 17 00 00       	call   8017f3 <read>
  8000c7:	83 c4 10             	add    $0x10,%esp
  8000ca:	85 c0                	test   %eax,%eax
  8000cc:	7f e0                	jg     8000ae <wrong+0x7b>
	cprintf("===\n");
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	68 75 2b 80 00       	push   $0x802b75
  8000d6:	e8 3e 05 00 00       	call   800619 <cprintf>
	exit();
  8000db:	e8 0c 04 00 00       	call   8004ec <exit>
}
  8000e0:	83 c4 10             	add    $0x10,%esp
  8000e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000e6:	5b                   	pop    %ebx
  8000e7:	5e                   	pop    %esi
  8000e8:	5f                   	pop    %edi
  8000e9:	5d                   	pop    %ebp
  8000ea:	c3                   	ret    

008000eb <umain>:
{
  8000eb:	55                   	push   %ebp
  8000ec:	89 e5                	mov    %esp,%ebp
  8000ee:	57                   	push   %edi
  8000ef:	56                   	push   %esi
  8000f0:	53                   	push   %ebx
  8000f1:	83 ec 38             	sub    $0x38,%esp
	close(0);
  8000f4:	6a 00                	push   $0x0
  8000f6:	e8 be 15 00 00       	call   8016b9 <close>
	close(1);
  8000fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800102:	e8 b2 15 00 00       	call   8016b9 <close>
	opencons();
  800107:	e8 42 03 00 00       	call   80044e <opencons>
	opencons();
  80010c:	e8 3d 03 00 00       	call   80044e <opencons>
	if ((rfd = open("testshell.sh", O_RDONLY)) < 0)
  800111:	83 c4 08             	add    $0x8,%esp
  800114:	6a 00                	push   $0x0
  800116:	68 88 2b 80 00       	push   $0x802b88
  80011b:	e8 85 1b 00 00       	call   801ca5 <open>
  800120:	89 c3                	mov    %eax,%ebx
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	85 c0                	test   %eax,%eax
  800127:	0f 88 e9 00 00 00    	js     800216 <umain+0x12b>
	if ((wfd = pipe(pfds)) < 0)
  80012d:	83 ec 0c             	sub    $0xc,%esp
  800130:	8d 45 dc             	lea    -0x24(%ebp),%eax
  800133:	50                   	push   %eax
  800134:	e8 bc 23 00 00       	call   8024f5 <pipe>
  800139:	83 c4 10             	add    $0x10,%esp
  80013c:	85 c0                	test   %eax,%eax
  80013e:	0f 88 e4 00 00 00    	js     800228 <umain+0x13d>
	wfd = pfds[1];
  800144:	8b 75 e0             	mov    -0x20(%ebp),%esi
	cprintf("running sh -x < testshell.sh | cat\n");
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	68 24 2b 80 00       	push   $0x802b24
  80014f:	e8 c5 04 00 00       	call   800619 <cprintf>
	if ((r = fork()) < 0)
  800154:	e8 f6 11 00 00       	call   80134f <fork>
  800159:	83 c4 10             	add    $0x10,%esp
  80015c:	85 c0                	test   %eax,%eax
  80015e:	0f 88 d6 00 00 00    	js     80023a <umain+0x14f>
	if (r == 0) {
  800164:	85 c0                	test   %eax,%eax
  800166:	75 6f                	jne    8001d7 <umain+0xec>
		dup(rfd, 0);
  800168:	83 ec 08             	sub    $0x8,%esp
  80016b:	6a 00                	push   $0x0
  80016d:	53                   	push   %ebx
  80016e:	e8 94 15 00 00       	call   801707 <dup>
		dup(wfd, 1);
  800173:	83 c4 08             	add    $0x8,%esp
  800176:	6a 01                	push   $0x1
  800178:	56                   	push   %esi
  800179:	e8 89 15 00 00       	call   801707 <dup>
		close(rfd);
  80017e:	89 1c 24             	mov    %ebx,(%esp)
  800181:	e8 33 15 00 00       	call   8016b9 <close>
		close(wfd);
  800186:	89 34 24             	mov    %esi,(%esp)
  800189:	e8 2b 15 00 00       	call   8016b9 <close>
		if ((r = spawnl("/sh", "sh", "-x", 0)) < 0)
  80018e:	6a 00                	push   $0x0
  800190:	68 ce 2b 80 00       	push   $0x802bce
  800195:	68 92 2b 80 00       	push   $0x802b92
  80019a:	68 d1 2b 80 00       	push   $0x802bd1
  80019f:	e8 16 21 00 00       	call   8022ba <spawnl>
  8001a4:	89 c7                	mov    %eax,%edi
  8001a6:	83 c4 20             	add    $0x20,%esp
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	0f 88 9b 00 00 00    	js     80024c <umain+0x161>
		close(0);
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	6a 00                	push   $0x0
  8001b6:	e8 fe 14 00 00       	call   8016b9 <close>
		close(1);
  8001bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  8001c2:	e8 f2 14 00 00       	call   8016b9 <close>
		wait(r);
  8001c7:	89 3c 24             	mov    %edi,(%esp)
  8001ca:	e8 aa 24 00 00       	call   802679 <wait>
		exit();
  8001cf:	e8 18 03 00 00       	call   8004ec <exit>
  8001d4:	83 c4 10             	add    $0x10,%esp
	close(rfd);
  8001d7:	83 ec 0c             	sub    $0xc,%esp
  8001da:	53                   	push   %ebx
  8001db:	e8 d9 14 00 00       	call   8016b9 <close>
	close(wfd);
  8001e0:	89 34 24             	mov    %esi,(%esp)
  8001e3:	e8 d1 14 00 00       	call   8016b9 <close>
	rfd = pfds[0];
  8001e8:	8b 7d dc             	mov    -0x24(%ebp),%edi
	if ((kfd = open("testshell.key", O_RDONLY)) < 0)
  8001eb:	83 c4 08             	add    $0x8,%esp
  8001ee:	6a 00                	push   $0x0
  8001f0:	68 df 2b 80 00       	push   $0x802bdf
  8001f5:	e8 ab 1a 00 00       	call   801ca5 <open>
  8001fa:	89 c6                	mov    %eax,%esi
  8001fc:	83 c4 10             	add    $0x10,%esp
  8001ff:	85 c0                	test   %eax,%eax
  800201:	78 5b                	js     80025e <umain+0x173>
  800203:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  80020a:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  800211:	e9 a1 00 00 00       	jmp    8002b7 <umain+0x1cc>
		panic("open testshell.sh: %e", rfd);
  800216:	50                   	push   %eax
  800217:	68 95 2b 80 00       	push   $0x802b95
  80021c:	6a 13                	push   $0x13
  80021e:	68 ab 2b 80 00       	push   $0x802bab
  800223:	e8 de 02 00 00       	call   800506 <_panic>
		panic("pipe: %e", wfd);
  800228:	50                   	push   %eax
  800229:	68 bc 2b 80 00       	push   $0x802bbc
  80022e:	6a 15                	push   $0x15
  800230:	68 ab 2b 80 00       	push   $0x802bab
  800235:	e8 cc 02 00 00       	call   800506 <_panic>
		panic("fork: %e", r);
  80023a:	50                   	push   %eax
  80023b:	68 c5 2b 80 00       	push   $0x802bc5
  800240:	6a 1a                	push   $0x1a
  800242:	68 ab 2b 80 00       	push   $0x802bab
  800247:	e8 ba 02 00 00       	call   800506 <_panic>
			panic("spawn: %e", r);
  80024c:	50                   	push   %eax
  80024d:	68 d5 2b 80 00       	push   $0x802bd5
  800252:	6a 21                	push   $0x21
  800254:	68 ab 2b 80 00       	push   $0x802bab
  800259:	e8 a8 02 00 00       	call   800506 <_panic>
		panic("open testshell.key for reading: %e", kfd);
  80025e:	50                   	push   %eax
  80025f:	68 48 2b 80 00       	push   $0x802b48
  800264:	6a 2c                	push   $0x2c
  800266:	68 ab 2b 80 00       	push   $0x802bab
  80026b:	e8 96 02 00 00       	call   800506 <_panic>
			panic("reading testshell.out: %e", n1);
  800270:	53                   	push   %ebx
  800271:	68 ed 2b 80 00       	push   $0x802bed
  800276:	6a 33                	push   $0x33
  800278:	68 ab 2b 80 00       	push   $0x802bab
  80027d:	e8 84 02 00 00       	call   800506 <_panic>
			panic("reading testshell.key: %e", n2);
  800282:	50                   	push   %eax
  800283:	68 07 2c 80 00       	push   $0x802c07
  800288:	6a 35                	push   $0x35
  80028a:	68 ab 2b 80 00       	push   $0x802bab
  80028f:	e8 72 02 00 00       	call   800506 <_panic>
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800294:	83 fb 01             	cmp    $0x1,%ebx
  800297:	75 05                	jne    80029e <umain+0x1b3>
  800299:	83 f8 01             	cmp    $0x1,%eax
  80029c:	74 65                	je     800303 <umain+0x218>
			wrong(rfd, kfd, nloff);
  80029e:	83 ec 04             	sub    $0x4,%esp
  8002a1:	ff 75 d0             	pushl  -0x30(%ebp)
  8002a4:	56                   	push   %esi
  8002a5:	57                   	push   %edi
  8002a6:	e8 88 fd ff ff       	call   800033 <wrong>
  8002ab:	83 c4 10             	add    $0x10,%esp
		if (c1 == '\n')
  8002ae:	80 7d e7 0a          	cmpb   $0xa,-0x19(%ebp)
  8002b2:	74 59                	je     80030d <umain+0x222>
  8002b4:	ff 45 d4             	incl   -0x2c(%ebp)
		n1 = read(rfd, &c1, 1);
  8002b7:	83 ec 04             	sub    $0x4,%esp
  8002ba:	6a 01                	push   $0x1
  8002bc:	8d 45 e7             	lea    -0x19(%ebp),%eax
  8002bf:	50                   	push   %eax
  8002c0:	57                   	push   %edi
  8002c1:	e8 2d 15 00 00       	call   8017f3 <read>
  8002c6:	89 c3                	mov    %eax,%ebx
		n2 = read(kfd, &c2, 1);
  8002c8:	83 c4 0c             	add    $0xc,%esp
  8002cb:	6a 01                	push   $0x1
  8002cd:	8d 45 e6             	lea    -0x1a(%ebp),%eax
  8002d0:	50                   	push   %eax
  8002d1:	56                   	push   %esi
  8002d2:	e8 1c 15 00 00       	call   8017f3 <read>
		if (n1 < 0)
  8002d7:	83 c4 10             	add    $0x10,%esp
  8002da:	85 db                	test   %ebx,%ebx
  8002dc:	78 92                	js     800270 <umain+0x185>
		if (n2 < 0)
  8002de:	85 c0                	test   %eax,%eax
  8002e0:	78 a0                	js     800282 <umain+0x197>
		if (n1 == 0 && n2 == 0)
  8002e2:	85 db                	test   %ebx,%ebx
  8002e4:	75 ae                	jne    800294 <umain+0x1a9>
  8002e6:	85 c0                	test   %eax,%eax
  8002e8:	75 b4                	jne    80029e <umain+0x1b3>
	cprintf("shell ran correctly\n");
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	68 21 2c 80 00       	push   $0x802c21
  8002f2:	e8 22 03 00 00       	call   800619 <cprintf>
#include <inc/types.h>

static inline void
breakpoint(void)
{
	asm volatile("int3");
  8002f7:	cc                   	int3   
}
  8002f8:	83 c4 10             	add    $0x10,%esp
  8002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002fe:	5b                   	pop    %ebx
  8002ff:	5e                   	pop    %esi
  800300:	5f                   	pop    %edi
  800301:	5d                   	pop    %ebp
  800302:	c3                   	ret    
		if (n1 != 1 || n2 != 1 || c1 != c2)
  800303:	8a 45 e6             	mov    -0x1a(%ebp),%al
  800306:	38 45 e7             	cmp    %al,-0x19(%ebp)
  800309:	75 93                	jne    80029e <umain+0x1b3>
  80030b:	eb a1                	jmp    8002ae <umain+0x1c3>
			nloff = off+1;
  80030d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800313:	eb 9f                	jmp    8002b4 <umain+0x1c9>

00800315 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800318:	b8 00 00 00 00       	mov    $0x0,%eax
  80031d:	5d                   	pop    %ebp
  80031e:	c3                   	ret    

0080031f <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  80031f:	55                   	push   %ebp
  800320:	89 e5                	mov    %esp,%ebp
  800322:	53                   	push   %ebx
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800329:	68 36 2c 80 00       	push   $0x802c36
  80032e:	53                   	push   %ebx
  80032f:	e8 ed 08 00 00       	call   800c21 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800334:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  80033b:	20 00 00 
	return 0;
}
  80033e:	b8 00 00 00 00       	mov    $0x0,%eax
  800343:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800346:	c9                   	leave  
  800347:	c3                   	ret    

00800348 <devcons_write>:
{
  800348:	55                   	push   %ebp
  800349:	89 e5                	mov    %esp,%ebp
  80034b:	57                   	push   %edi
  80034c:	56                   	push   %esi
  80034d:	53                   	push   %ebx
  80034e:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800354:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800359:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80035f:	eb 1d                	jmp    80037e <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800361:	83 ec 04             	sub    $0x4,%esp
  800364:	53                   	push   %ebx
  800365:	03 45 0c             	add    0xc(%ebp),%eax
  800368:	50                   	push   %eax
  800369:	57                   	push   %edi
  80036a:	e8 25 0a 00 00       	call   800d94 <memmove>
		sys_cputs(buf, m);
  80036f:	83 c4 08             	add    $0x8,%esp
  800372:	53                   	push   %ebx
  800373:	57                   	push   %edi
  800374:	e8 c0 0b 00 00       	call   800f39 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800379:	01 de                	add    %ebx,%esi
  80037b:	83 c4 10             	add    $0x10,%esp
  80037e:	89 f0                	mov    %esi,%eax
  800380:	3b 75 10             	cmp    0x10(%ebp),%esi
  800383:	73 11                	jae    800396 <devcons_write+0x4e>
		m = n - tot;
  800385:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800388:	29 f3                	sub    %esi,%ebx
  80038a:	83 fb 7f             	cmp    $0x7f,%ebx
  80038d:	76 d2                	jbe    800361 <devcons_write+0x19>
  80038f:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800394:	eb cb                	jmp    800361 <devcons_write+0x19>
}
  800396:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800399:	5b                   	pop    %ebx
  80039a:	5e                   	pop    %esi
  80039b:	5f                   	pop    %edi
  80039c:	5d                   	pop    %ebp
  80039d:	c3                   	ret    

0080039e <devcons_read>:
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8003a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8003a8:	75 0c                	jne    8003b6 <devcons_read+0x18>
		return 0;
  8003aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8003af:	eb 21                	jmp    8003d2 <devcons_read+0x34>
		sys_yield();
  8003b1:	e8 e7 0c 00 00       	call   80109d <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8003b6:	e8 9c 0b 00 00       	call   800f57 <sys_cgetc>
  8003bb:	85 c0                	test   %eax,%eax
  8003bd:	74 f2                	je     8003b1 <devcons_read+0x13>
	if (c < 0)
  8003bf:	85 c0                	test   %eax,%eax
  8003c1:	78 0f                	js     8003d2 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8003c3:	83 f8 04             	cmp    $0x4,%eax
  8003c6:	74 0c                	je     8003d4 <devcons_read+0x36>
	*(char*)vbuf = c;
  8003c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003cb:	88 02                	mov    %al,(%edx)
	return 1;
  8003cd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8003d2:	c9                   	leave  
  8003d3:	c3                   	ret    
		return 0;
  8003d4:	b8 00 00 00 00       	mov    $0x0,%eax
  8003d9:	eb f7                	jmp    8003d2 <devcons_read+0x34>

008003db <cputchar>:
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8003e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e4:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8003e7:	6a 01                	push   $0x1
  8003e9:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8003ec:	50                   	push   %eax
  8003ed:	e8 47 0b 00 00       	call   800f39 <sys_cputs>
}
  8003f2:	83 c4 10             	add    $0x10,%esp
  8003f5:	c9                   	leave  
  8003f6:	c3                   	ret    

008003f7 <getchar>:
{
  8003f7:	55                   	push   %ebp
  8003f8:	89 e5                	mov    %esp,%ebp
  8003fa:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8003fd:	6a 01                	push   $0x1
  8003ff:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800402:	50                   	push   %eax
  800403:	6a 00                	push   $0x0
  800405:	e8 e9 13 00 00       	call   8017f3 <read>
	if (r < 0)
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	85 c0                	test   %eax,%eax
  80040f:	78 08                	js     800419 <getchar+0x22>
	if (r < 1)
  800411:	85 c0                	test   %eax,%eax
  800413:	7e 06                	jle    80041b <getchar+0x24>
	return c;
  800415:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  800419:	c9                   	leave  
  80041a:	c3                   	ret    
		return -E_EOF;
  80041b:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800420:	eb f7                	jmp    800419 <getchar+0x22>

00800422 <iscons>:
{
  800422:	55                   	push   %ebp
  800423:	89 e5                	mov    %esp,%ebp
  800425:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800428:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80042b:	50                   	push   %eax
  80042c:	ff 75 08             	pushl  0x8(%ebp)
  80042f:	e8 52 11 00 00       	call   801586 <fd_lookup>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	85 c0                	test   %eax,%eax
  800439:	78 11                	js     80044c <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80043b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043e:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800444:	39 10                	cmp    %edx,(%eax)
  800446:	0f 94 c0             	sete   %al
  800449:	0f b6 c0             	movzbl %al,%eax
}
  80044c:	c9                   	leave  
  80044d:	c3                   	ret    

0080044e <opencons>:
{
  80044e:	55                   	push   %ebp
  80044f:	89 e5                	mov    %esp,%ebp
  800451:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800454:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800457:	50                   	push   %eax
  800458:	e8 da 10 00 00       	call   801537 <fd_alloc>
  80045d:	83 c4 10             	add    $0x10,%esp
  800460:	85 c0                	test   %eax,%eax
  800462:	78 3a                	js     80049e <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800464:	83 ec 04             	sub    $0x4,%esp
  800467:	68 07 04 00 00       	push   $0x407
  80046c:	ff 75 f4             	pushl  -0xc(%ebp)
  80046f:	6a 00                	push   $0x0
  800471:	e8 60 0b 00 00       	call   800fd6 <sys_page_alloc>
  800476:	83 c4 10             	add    $0x10,%esp
  800479:	85 c0                	test   %eax,%eax
  80047b:	78 21                	js     80049e <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80047d:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800483:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800486:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80048b:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800492:	83 ec 0c             	sub    $0xc,%esp
  800495:	50                   	push   %eax
  800496:	e8 75 10 00 00       	call   801510 <fd2num>
  80049b:	83 c4 10             	add    $0x10,%esp
}
  80049e:	c9                   	leave  
  80049f:	c3                   	ret    

008004a0 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8004a0:	55                   	push   %ebp
  8004a1:	89 e5                	mov    %esp,%ebp
  8004a3:	56                   	push   %esi
  8004a4:	53                   	push   %ebx
  8004a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8004a8:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8004ab:	e8 07 0b 00 00       	call   800fb7 <sys_getenvid>
  8004b0:	25 ff 03 00 00       	and    $0x3ff,%eax
  8004b5:	89 c2                	mov    %eax,%edx
  8004b7:	c1 e2 05             	shl    $0x5,%edx
  8004ba:	29 c2                	sub    %eax,%edx
  8004bc:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8004c3:	a3 04 50 80 00       	mov    %eax,0x805004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8004c8:	85 db                	test   %ebx,%ebx
  8004ca:	7e 07                	jle    8004d3 <libmain+0x33>
		binaryname = argv[0];
  8004cc:	8b 06                	mov    (%esi),%eax
  8004ce:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  8004d3:	83 ec 08             	sub    $0x8,%esp
  8004d6:	56                   	push   %esi
  8004d7:	53                   	push   %ebx
  8004d8:	e8 0e fc ff ff       	call   8000eb <umain>

	// exit gracefully
	exit();
  8004dd:	e8 0a 00 00 00       	call   8004ec <exit>
}
  8004e2:	83 c4 10             	add    $0x10,%esp
  8004e5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8004e8:	5b                   	pop    %ebx
  8004e9:	5e                   	pop    %esi
  8004ea:	5d                   	pop    %ebp
  8004eb:	c3                   	ret    

008004ec <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8004ec:	55                   	push   %ebp
  8004ed:	89 e5                	mov    %esp,%ebp
  8004ef:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8004f2:	e8 ed 11 00 00       	call   8016e4 <close_all>
	sys_env_destroy(0);
  8004f7:	83 ec 0c             	sub    $0xc,%esp
  8004fa:	6a 00                	push   $0x0
  8004fc:	e8 75 0a 00 00       	call   800f76 <sys_env_destroy>
}
  800501:	83 c4 10             	add    $0x10,%esp
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	57                   	push   %edi
  80050a:	56                   	push   %esi
  80050b:	53                   	push   %ebx
  80050c:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800512:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800515:	8b 1d 1c 40 80 00    	mov    0x80401c,%ebx
  80051b:	e8 97 0a 00 00       	call   800fb7 <sys_getenvid>
  800520:	83 ec 04             	sub    $0x4,%esp
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	53                   	push   %ebx
  80052a:	50                   	push   %eax
  80052b:	68 4c 2c 80 00       	push   $0x802c4c
  800530:	68 00 01 00 00       	push   $0x100
  800535:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80053b:	56                   	push   %esi
  80053c:	e8 93 06 00 00       	call   800bd4 <snprintf>
  800541:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800543:	83 c4 20             	add    $0x20,%esp
  800546:	57                   	push   %edi
  800547:	ff 75 10             	pushl  0x10(%ebp)
  80054a:	bf 00 01 00 00       	mov    $0x100,%edi
  80054f:	89 f8                	mov    %edi,%eax
  800551:	29 d8                	sub    %ebx,%eax
  800553:	50                   	push   %eax
  800554:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800557:	50                   	push   %eax
  800558:	e8 22 06 00 00       	call   800b7f <vsnprintf>
  80055d:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80055f:	83 c4 0c             	add    $0xc,%esp
  800562:	68 78 2b 80 00       	push   $0x802b78
  800567:	29 df                	sub    %ebx,%edi
  800569:	57                   	push   %edi
  80056a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80056d:	50                   	push   %eax
  80056e:	e8 61 06 00 00       	call   800bd4 <snprintf>
	sys_cputs(buf, r);
  800573:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800576:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800578:	53                   	push   %ebx
  800579:	56                   	push   %esi
  80057a:	e8 ba 09 00 00       	call   800f39 <sys_cputs>
  80057f:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800582:	cc                   	int3   
  800583:	eb fd                	jmp    800582 <_panic+0x7c>

00800585 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	53                   	push   %ebx
  800589:	83 ec 04             	sub    $0x4,%esp
  80058c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80058f:	8b 13                	mov    (%ebx),%edx
  800591:	8d 42 01             	lea    0x1(%edx),%eax
  800594:	89 03                	mov    %eax,(%ebx)
  800596:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800599:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80059d:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a2:	74 08                	je     8005ac <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8005a4:	ff 43 04             	incl   0x4(%ebx)
}
  8005a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005aa:	c9                   	leave  
  8005ab:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8005ac:	83 ec 08             	sub    $0x8,%esp
  8005af:	68 ff 00 00 00       	push   $0xff
  8005b4:	8d 43 08             	lea    0x8(%ebx),%eax
  8005b7:	50                   	push   %eax
  8005b8:	e8 7c 09 00 00       	call   800f39 <sys_cputs>
		b->idx = 0;
  8005bd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8005c3:	83 c4 10             	add    $0x10,%esp
  8005c6:	eb dc                	jmp    8005a4 <putch+0x1f>

008005c8 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8005c8:	55                   	push   %ebp
  8005c9:	89 e5                	mov    %esp,%ebp
  8005cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005d8:	00 00 00 
	b.cnt = 0;
  8005db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005e2:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8005e5:	ff 75 0c             	pushl  0xc(%ebp)
  8005e8:	ff 75 08             	pushl  0x8(%ebp)
  8005eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005f1:	50                   	push   %eax
  8005f2:	68 85 05 80 00       	push   $0x800585
  8005f7:	e8 17 01 00 00       	call   800713 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8005fc:	83 c4 08             	add    $0x8,%esp
  8005ff:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800605:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80060b:	50                   	push   %eax
  80060c:	e8 28 09 00 00       	call   800f39 <sys_cputs>

	return b.cnt;
}
  800611:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800617:	c9                   	leave  
  800618:	c3                   	ret    

00800619 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800619:	55                   	push   %ebp
  80061a:	89 e5                	mov    %esp,%ebp
  80061c:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80061f:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800622:	50                   	push   %eax
  800623:	ff 75 08             	pushl  0x8(%ebp)
  800626:	e8 9d ff ff ff       	call   8005c8 <vcprintf>
	va_end(ap);

	return cnt;
}
  80062b:	c9                   	leave  
  80062c:	c3                   	ret    

0080062d <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80062d:	55                   	push   %ebp
  80062e:	89 e5                	mov    %esp,%ebp
  800630:	57                   	push   %edi
  800631:	56                   	push   %esi
  800632:	53                   	push   %ebx
  800633:	83 ec 1c             	sub    $0x1c,%esp
  800636:	89 c7                	mov    %eax,%edi
  800638:	89 d6                	mov    %edx,%esi
  80063a:	8b 45 08             	mov    0x8(%ebp),%eax
  80063d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800640:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800643:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800646:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800649:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800651:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800654:	39 d3                	cmp    %edx,%ebx
  800656:	72 05                	jb     80065d <printnum+0x30>
  800658:	39 45 10             	cmp    %eax,0x10(%ebp)
  80065b:	77 78                	ja     8006d5 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80065d:	83 ec 0c             	sub    $0xc,%esp
  800660:	ff 75 18             	pushl  0x18(%ebp)
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800669:	53                   	push   %ebx
  80066a:	ff 75 10             	pushl  0x10(%ebp)
  80066d:	83 ec 08             	sub    $0x8,%esp
  800670:	ff 75 e4             	pushl  -0x1c(%ebp)
  800673:	ff 75 e0             	pushl  -0x20(%ebp)
  800676:	ff 75 dc             	pushl  -0x24(%ebp)
  800679:	ff 75 d8             	pushl  -0x28(%ebp)
  80067c:	e8 23 22 00 00       	call   8028a4 <__udivdi3>
  800681:	83 c4 18             	add    $0x18,%esp
  800684:	52                   	push   %edx
  800685:	50                   	push   %eax
  800686:	89 f2                	mov    %esi,%edx
  800688:	89 f8                	mov    %edi,%eax
  80068a:	e8 9e ff ff ff       	call   80062d <printnum>
  80068f:	83 c4 20             	add    $0x20,%esp
  800692:	eb 11                	jmp    8006a5 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800694:	83 ec 08             	sub    $0x8,%esp
  800697:	56                   	push   %esi
  800698:	ff 75 18             	pushl  0x18(%ebp)
  80069b:	ff d7                	call   *%edi
  80069d:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8006a0:	4b                   	dec    %ebx
  8006a1:	85 db                	test   %ebx,%ebx
  8006a3:	7f ef                	jg     800694 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a5:	83 ec 08             	sub    $0x8,%esp
  8006a8:	56                   	push   %esi
  8006a9:	83 ec 04             	sub    $0x4,%esp
  8006ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8006af:	ff 75 e0             	pushl  -0x20(%ebp)
  8006b2:	ff 75 dc             	pushl  -0x24(%ebp)
  8006b5:	ff 75 d8             	pushl  -0x28(%ebp)
  8006b8:	e8 f7 22 00 00       	call   8029b4 <__umoddi3>
  8006bd:	83 c4 14             	add    $0x14,%esp
  8006c0:	0f be 80 6f 2c 80 00 	movsbl 0x802c6f(%eax),%eax
  8006c7:	50                   	push   %eax
  8006c8:	ff d7                	call   *%edi
}
  8006ca:	83 c4 10             	add    $0x10,%esp
  8006cd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d0:	5b                   	pop    %ebx
  8006d1:	5e                   	pop    %esi
  8006d2:	5f                   	pop    %edi
  8006d3:	5d                   	pop    %ebp
  8006d4:	c3                   	ret    
  8006d5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8006d8:	eb c6                	jmp    8006a0 <printnum+0x73>

008006da <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8006da:	55                   	push   %ebp
  8006db:	89 e5                	mov    %esp,%ebp
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8006e0:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8006e3:	8b 10                	mov    (%eax),%edx
  8006e5:	3b 50 04             	cmp    0x4(%eax),%edx
  8006e8:	73 0a                	jae    8006f4 <sprintputch+0x1a>
		*b->buf++ = ch;
  8006ea:	8d 4a 01             	lea    0x1(%edx),%ecx
  8006ed:	89 08                	mov    %ecx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	88 02                	mov    %al,(%edx)
}
  8006f4:	5d                   	pop    %ebp
  8006f5:	c3                   	ret    

008006f6 <printfmt>:
{
  8006f6:	55                   	push   %ebp
  8006f7:	89 e5                	mov    %esp,%ebp
  8006f9:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8006fc:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8006ff:	50                   	push   %eax
  800700:	ff 75 10             	pushl  0x10(%ebp)
  800703:	ff 75 0c             	pushl  0xc(%ebp)
  800706:	ff 75 08             	pushl  0x8(%ebp)
  800709:	e8 05 00 00 00       	call   800713 <vprintfmt>
}
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	c9                   	leave  
  800712:	c3                   	ret    

00800713 <vprintfmt>:
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	57                   	push   %edi
  800717:	56                   	push   %esi
  800718:	53                   	push   %ebx
  800719:	83 ec 2c             	sub    $0x2c,%esp
  80071c:	8b 75 08             	mov    0x8(%ebp),%esi
  80071f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800722:	8b 7d 10             	mov    0x10(%ebp),%edi
  800725:	e9 ae 03 00 00       	jmp    800ad8 <vprintfmt+0x3c5>
  80072a:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80072e:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800735:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80073c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800743:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800748:	8d 47 01             	lea    0x1(%edi),%eax
  80074b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80074e:	8a 17                	mov    (%edi),%dl
  800750:	8d 42 dd             	lea    -0x23(%edx),%eax
  800753:	3c 55                	cmp    $0x55,%al
  800755:	0f 87 fe 03 00 00    	ja     800b59 <vprintfmt+0x446>
  80075b:	0f b6 c0             	movzbl %al,%eax
  80075e:	ff 24 85 c0 2d 80 00 	jmp    *0x802dc0(,%eax,4)
  800765:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800768:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80076c:	eb da                	jmp    800748 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80076e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800771:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800775:	eb d1                	jmp    800748 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800777:	0f b6 d2             	movzbl %dl,%edx
  80077a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80077d:	b8 00 00 00 00       	mov    $0x0,%eax
  800782:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800785:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800788:	01 c0                	add    %eax,%eax
  80078a:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80078e:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800791:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800794:	83 f9 09             	cmp    $0x9,%ecx
  800797:	77 52                	ja     8007eb <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800799:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80079a:	eb e9                	jmp    800785 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80079c:	8b 45 14             	mov    0x14(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a7:	8d 40 04             	lea    0x4(%eax),%eax
  8007aa:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8007ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8007b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007b4:	79 92                	jns    800748 <vprintfmt+0x35>
				width = precision, precision = -1;
  8007b6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007bc:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8007c3:	eb 83                	jmp    800748 <vprintfmt+0x35>
  8007c5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8007c9:	78 08                	js     8007d3 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8007ce:	e9 75 ff ff ff       	jmp    800748 <vprintfmt+0x35>
  8007d3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8007da:	eb ef                	jmp    8007cb <vprintfmt+0xb8>
  8007dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8007df:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8007e6:	e9 5d ff ff ff       	jmp    800748 <vprintfmt+0x35>
  8007eb:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8007ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8007f1:	eb bd                	jmp    8007b0 <vprintfmt+0x9d>
			lflag++;
  8007f3:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8007f4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8007f7:	e9 4c ff ff ff       	jmp    800748 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8007fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ff:	8d 78 04             	lea    0x4(%eax),%edi
  800802:	83 ec 08             	sub    $0x8,%esp
  800805:	53                   	push   %ebx
  800806:	ff 30                	pushl  (%eax)
  800808:	ff d6                	call   *%esi
			break;
  80080a:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80080d:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800810:	e9 c0 02 00 00       	jmp    800ad5 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800815:	8b 45 14             	mov    0x14(%ebp),%eax
  800818:	8d 78 04             	lea    0x4(%eax),%edi
  80081b:	8b 00                	mov    (%eax),%eax
  80081d:	85 c0                	test   %eax,%eax
  80081f:	78 2a                	js     80084b <vprintfmt+0x138>
  800821:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800823:	83 f8 0f             	cmp    $0xf,%eax
  800826:	7f 27                	jg     80084f <vprintfmt+0x13c>
  800828:	8b 04 85 20 2f 80 00 	mov    0x802f20(,%eax,4),%eax
  80082f:	85 c0                	test   %eax,%eax
  800831:	74 1c                	je     80084f <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800833:	50                   	push   %eax
  800834:	68 48 30 80 00       	push   $0x803048
  800839:	53                   	push   %ebx
  80083a:	56                   	push   %esi
  80083b:	e8 b6 fe ff ff       	call   8006f6 <printfmt>
  800840:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800843:	89 7d 14             	mov    %edi,0x14(%ebp)
  800846:	e9 8a 02 00 00       	jmp    800ad5 <vprintfmt+0x3c2>
  80084b:	f7 d8                	neg    %eax
  80084d:	eb d2                	jmp    800821 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80084f:	52                   	push   %edx
  800850:	68 87 2c 80 00       	push   $0x802c87
  800855:	53                   	push   %ebx
  800856:	56                   	push   %esi
  800857:	e8 9a fe ff ff       	call   8006f6 <printfmt>
  80085c:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80085f:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800862:	e9 6e 02 00 00       	jmp    800ad5 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800867:	8b 45 14             	mov    0x14(%ebp),%eax
  80086a:	83 c0 04             	add    $0x4,%eax
  80086d:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800870:	8b 45 14             	mov    0x14(%ebp),%eax
  800873:	8b 38                	mov    (%eax),%edi
  800875:	85 ff                	test   %edi,%edi
  800877:	74 39                	je     8008b2 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800879:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80087d:	0f 8e a9 00 00 00    	jle    80092c <vprintfmt+0x219>
  800883:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800887:	0f 84 a7 00 00 00    	je     800934 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80088d:	83 ec 08             	sub    $0x8,%esp
  800890:	ff 75 d0             	pushl  -0x30(%ebp)
  800893:	57                   	push   %edi
  800894:	e8 6b 03 00 00       	call   800c04 <strnlen>
  800899:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80089c:	29 c1                	sub    %eax,%ecx
  80089e:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8008a1:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8008a4:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8008a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8008ab:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8008ae:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b0:	eb 14                	jmp    8008c6 <vprintfmt+0x1b3>
				p = "(null)";
  8008b2:	bf 80 2c 80 00       	mov    $0x802c80,%edi
  8008b7:	eb c0                	jmp    800879 <vprintfmt+0x166>
					putch(padc, putdat);
  8008b9:	83 ec 08             	sub    $0x8,%esp
  8008bc:	53                   	push   %ebx
  8008bd:	ff 75 e0             	pushl  -0x20(%ebp)
  8008c0:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	4f                   	dec    %edi
  8008c3:	83 c4 10             	add    $0x10,%esp
  8008c6:	85 ff                	test   %edi,%edi
  8008c8:	7f ef                	jg     8008b9 <vprintfmt+0x1a6>
  8008ca:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8008cd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008d0:	89 c8                	mov    %ecx,%eax
  8008d2:	85 c9                	test   %ecx,%ecx
  8008d4:	78 10                	js     8008e6 <vprintfmt+0x1d3>
  8008d6:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8008d9:	29 c1                	sub    %eax,%ecx
  8008db:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8008de:	89 75 08             	mov    %esi,0x8(%ebp)
  8008e1:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8008e4:	eb 15                	jmp    8008fb <vprintfmt+0x1e8>
  8008e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8008eb:	eb e9                	jmp    8008d6 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8008ed:	83 ec 08             	sub    $0x8,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	52                   	push   %edx
  8008f2:	ff 55 08             	call   *0x8(%ebp)
  8008f5:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f8:	ff 4d e0             	decl   -0x20(%ebp)
  8008fb:	47                   	inc    %edi
  8008fc:	8a 47 ff             	mov    -0x1(%edi),%al
  8008ff:	0f be d0             	movsbl %al,%edx
  800902:	85 d2                	test   %edx,%edx
  800904:	74 59                	je     80095f <vprintfmt+0x24c>
  800906:	85 f6                	test   %esi,%esi
  800908:	78 03                	js     80090d <vprintfmt+0x1fa>
  80090a:	4e                   	dec    %esi
  80090b:	78 2f                	js     80093c <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80090d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800911:	74 da                	je     8008ed <vprintfmt+0x1da>
  800913:	0f be c0             	movsbl %al,%eax
  800916:	83 e8 20             	sub    $0x20,%eax
  800919:	83 f8 5e             	cmp    $0x5e,%eax
  80091c:	76 cf                	jbe    8008ed <vprintfmt+0x1da>
					putch('?', putdat);
  80091e:	83 ec 08             	sub    $0x8,%esp
  800921:	53                   	push   %ebx
  800922:	6a 3f                	push   $0x3f
  800924:	ff 55 08             	call   *0x8(%ebp)
  800927:	83 c4 10             	add    $0x10,%esp
  80092a:	eb cc                	jmp    8008f8 <vprintfmt+0x1e5>
  80092c:	89 75 08             	mov    %esi,0x8(%ebp)
  80092f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800932:	eb c7                	jmp    8008fb <vprintfmt+0x1e8>
  800934:	89 75 08             	mov    %esi,0x8(%ebp)
  800937:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80093a:	eb bf                	jmp    8008fb <vprintfmt+0x1e8>
  80093c:	8b 75 08             	mov    0x8(%ebp),%esi
  80093f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800942:	eb 0c                	jmp    800950 <vprintfmt+0x23d>
				putch(' ', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	53                   	push   %ebx
  800948:	6a 20                	push   $0x20
  80094a:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80094c:	4f                   	dec    %edi
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	85 ff                	test   %edi,%edi
  800952:	7f f0                	jg     800944 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800954:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	e9 76 01 00 00       	jmp    800ad5 <vprintfmt+0x3c2>
  80095f:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800962:	8b 75 08             	mov    0x8(%ebp),%esi
  800965:	eb e9                	jmp    800950 <vprintfmt+0x23d>
	if (lflag >= 2)
  800967:	83 f9 01             	cmp    $0x1,%ecx
  80096a:	7f 1f                	jg     80098b <vprintfmt+0x278>
	else if (lflag)
  80096c:	85 c9                	test   %ecx,%ecx
  80096e:	75 48                	jne    8009b8 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800970:	8b 45 14             	mov    0x14(%ebp),%eax
  800973:	8b 00                	mov    (%eax),%eax
  800975:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800978:	89 c1                	mov    %eax,%ecx
  80097a:	c1 f9 1f             	sar    $0x1f,%ecx
  80097d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800980:	8b 45 14             	mov    0x14(%ebp),%eax
  800983:	8d 40 04             	lea    0x4(%eax),%eax
  800986:	89 45 14             	mov    %eax,0x14(%ebp)
  800989:	eb 17                	jmp    8009a2 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80098b:	8b 45 14             	mov    0x14(%ebp),%eax
  80098e:	8b 50 04             	mov    0x4(%eax),%edx
  800991:	8b 00                	mov    (%eax),%eax
  800993:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800996:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800999:	8b 45 14             	mov    0x14(%ebp),%eax
  80099c:	8d 40 08             	lea    0x8(%eax),%eax
  80099f:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8009a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009a5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	78 25                	js     8009d3 <vprintfmt+0x2c0>
			base = 10;
  8009ae:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009b3:	e9 03 01 00 00       	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8009b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009bb:	8b 00                	mov    (%eax),%eax
  8009bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8009c0:	89 c1                	mov    %eax,%ecx
  8009c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8009c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8009c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8009cb:	8d 40 04             	lea    0x4(%eax),%eax
  8009ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8009d1:	eb cf                	jmp    8009a2 <vprintfmt+0x28f>
				putch('-', putdat);
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	53                   	push   %ebx
  8009d7:	6a 2d                	push   $0x2d
  8009d9:	ff d6                	call   *%esi
				num = -(long long) num;
  8009db:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8009de:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8009e1:	f7 da                	neg    %edx
  8009e3:	83 d1 00             	adc    $0x0,%ecx
  8009e6:	f7 d9                	neg    %ecx
  8009e8:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8009eb:	b8 0a 00 00 00       	mov    $0xa,%eax
  8009f0:	e9 c6 00 00 00       	jmp    800abb <vprintfmt+0x3a8>
	if (lflag >= 2)
  8009f5:	83 f9 01             	cmp    $0x1,%ecx
  8009f8:	7f 1e                	jg     800a18 <vprintfmt+0x305>
	else if (lflag)
  8009fa:	85 c9                	test   %ecx,%ecx
  8009fc:	75 32                	jne    800a30 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8009fe:	8b 45 14             	mov    0x14(%ebp),%eax
  800a01:	8b 10                	mov    (%eax),%edx
  800a03:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a08:	8d 40 04             	lea    0x4(%eax),%eax
  800a0b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a0e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a13:	e9 a3 00 00 00       	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800a18:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1b:	8b 10                	mov    (%eax),%edx
  800a1d:	8b 48 04             	mov    0x4(%eax),%ecx
  800a20:	8d 40 08             	lea    0x8(%eax),%eax
  800a23:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a26:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a2b:	e9 8b 00 00 00       	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	8b 10                	mov    (%eax),%edx
  800a35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a3a:	8d 40 04             	lea    0x4(%eax),%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800a40:	b8 0a 00 00 00       	mov    $0xa,%eax
  800a45:	eb 74                	jmp    800abb <vprintfmt+0x3a8>
	if (lflag >= 2)
  800a47:	83 f9 01             	cmp    $0x1,%ecx
  800a4a:	7f 1b                	jg     800a67 <vprintfmt+0x354>
	else if (lflag)
  800a4c:	85 c9                	test   %ecx,%ecx
  800a4e:	75 2c                	jne    800a7c <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800a50:	8b 45 14             	mov    0x14(%ebp),%eax
  800a53:	8b 10                	mov    (%eax),%edx
  800a55:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a5a:	8d 40 04             	lea    0x4(%eax),%eax
  800a5d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a60:	b8 08 00 00 00       	mov    $0x8,%eax
  800a65:	eb 54                	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800a67:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6a:	8b 10                	mov    (%eax),%edx
  800a6c:	8b 48 04             	mov    0x4(%eax),%ecx
  800a6f:	8d 40 08             	lea    0x8(%eax),%eax
  800a72:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a75:	b8 08 00 00 00       	mov    $0x8,%eax
  800a7a:	eb 3f                	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	8b 10                	mov    (%eax),%edx
  800a81:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a86:	8d 40 04             	lea    0x4(%eax),%eax
  800a89:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800a8c:	b8 08 00 00 00       	mov    $0x8,%eax
  800a91:	eb 28                	jmp    800abb <vprintfmt+0x3a8>
			putch('0', putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	53                   	push   %ebx
  800a97:	6a 30                	push   $0x30
  800a99:	ff d6                	call   *%esi
			putch('x', putdat);
  800a9b:	83 c4 08             	add    $0x8,%esp
  800a9e:	53                   	push   %ebx
  800a9f:	6a 78                	push   $0x78
  800aa1:	ff d6                	call   *%esi
			num = (unsigned long long)
  800aa3:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa6:	8b 10                	mov    (%eax),%edx
  800aa8:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800aad:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800ab0:	8d 40 04             	lea    0x4(%eax),%eax
  800ab3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800ab6:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800abb:	83 ec 0c             	sub    $0xc,%esp
  800abe:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800ac2:	57                   	push   %edi
  800ac3:	ff 75 e0             	pushl  -0x20(%ebp)
  800ac6:	50                   	push   %eax
  800ac7:	51                   	push   %ecx
  800ac8:	52                   	push   %edx
  800ac9:	89 da                	mov    %ebx,%edx
  800acb:	89 f0                	mov    %esi,%eax
  800acd:	e8 5b fb ff ff       	call   80062d <printnum>
			break;
  800ad2:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800ad5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ad8:	47                   	inc    %edi
  800ad9:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800add:	83 f8 25             	cmp    $0x25,%eax
  800ae0:	0f 84 44 fc ff ff    	je     80072a <vprintfmt+0x17>
			if (ch == '\0')
  800ae6:	85 c0                	test   %eax,%eax
  800ae8:	0f 84 89 00 00 00    	je     800b77 <vprintfmt+0x464>
			putch(ch, putdat);
  800aee:	83 ec 08             	sub    $0x8,%esp
  800af1:	53                   	push   %ebx
  800af2:	50                   	push   %eax
  800af3:	ff d6                	call   *%esi
  800af5:	83 c4 10             	add    $0x10,%esp
  800af8:	eb de                	jmp    800ad8 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800afa:	83 f9 01             	cmp    $0x1,%ecx
  800afd:	7f 1b                	jg     800b1a <vprintfmt+0x407>
	else if (lflag)
  800aff:	85 c9                	test   %ecx,%ecx
  800b01:	75 2c                	jne    800b2f <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800b03:	8b 45 14             	mov    0x14(%ebp),%eax
  800b06:	8b 10                	mov    (%eax),%edx
  800b08:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b0d:	8d 40 04             	lea    0x4(%eax),%eax
  800b10:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b13:	b8 10 00 00 00       	mov    $0x10,%eax
  800b18:	eb a1                	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800b1a:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1d:	8b 10                	mov    (%eax),%edx
  800b1f:	8b 48 04             	mov    0x4(%eax),%ecx
  800b22:	8d 40 08             	lea    0x8(%eax),%eax
  800b25:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b28:	b8 10 00 00 00       	mov    $0x10,%eax
  800b2d:	eb 8c                	jmp    800abb <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800b2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800b32:	8b 10                	mov    (%eax),%edx
  800b34:	b9 00 00 00 00       	mov    $0x0,%ecx
  800b39:	8d 40 04             	lea    0x4(%eax),%eax
  800b3c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800b3f:	b8 10 00 00 00       	mov    $0x10,%eax
  800b44:	e9 72 ff ff ff       	jmp    800abb <vprintfmt+0x3a8>
			putch(ch, putdat);
  800b49:	83 ec 08             	sub    $0x8,%esp
  800b4c:	53                   	push   %ebx
  800b4d:	6a 25                	push   $0x25
  800b4f:	ff d6                	call   *%esi
			break;
  800b51:	83 c4 10             	add    $0x10,%esp
  800b54:	e9 7c ff ff ff       	jmp    800ad5 <vprintfmt+0x3c2>
			putch('%', putdat);
  800b59:	83 ec 08             	sub    $0x8,%esp
  800b5c:	53                   	push   %ebx
  800b5d:	6a 25                	push   $0x25
  800b5f:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b61:	83 c4 10             	add    $0x10,%esp
  800b64:	89 f8                	mov    %edi,%eax
  800b66:	eb 01                	jmp    800b69 <vprintfmt+0x456>
  800b68:	48                   	dec    %eax
  800b69:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800b6d:	75 f9                	jne    800b68 <vprintfmt+0x455>
  800b6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b72:	e9 5e ff ff ff       	jmp    800ad5 <vprintfmt+0x3c2>
}
  800b77:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800b7a:	5b                   	pop    %ebx
  800b7b:	5e                   	pop    %esi
  800b7c:	5f                   	pop    %edi
  800b7d:	5d                   	pop    %ebp
  800b7e:	c3                   	ret    

00800b7f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b7f:	55                   	push   %ebp
  800b80:	89 e5                	mov    %esp,%ebp
  800b82:	83 ec 18             	sub    $0x18,%esp
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800b92:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800b95:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b9c:	85 c0                	test   %eax,%eax
  800b9e:	74 26                	je     800bc6 <vsnprintf+0x47>
  800ba0:	85 d2                	test   %edx,%edx
  800ba2:	7e 29                	jle    800bcd <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba4:	ff 75 14             	pushl  0x14(%ebp)
  800ba7:	ff 75 10             	pushl  0x10(%ebp)
  800baa:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bad:	50                   	push   %eax
  800bae:	68 da 06 80 00       	push   $0x8006da
  800bb3:	e8 5b fb ff ff       	call   800713 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800bb8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800bc1:	83 c4 10             	add    $0x10,%esp
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    
		return -E_INVAL;
  800bc6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bcb:	eb f7                	jmp    800bc4 <vsnprintf+0x45>
  800bcd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800bd2:	eb f0                	jmp    800bc4 <vsnprintf+0x45>

00800bd4 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd4:	55                   	push   %ebp
  800bd5:	89 e5                	mov    %esp,%ebp
  800bd7:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bda:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800bdd:	50                   	push   %eax
  800bde:	ff 75 10             	pushl  0x10(%ebp)
  800be1:	ff 75 0c             	pushl  0xc(%ebp)
  800be4:	ff 75 08             	pushl  0x8(%ebp)
  800be7:	e8 93 ff ff ff       	call   800b7f <vsnprintf>
	va_end(ap);

	return rc;
}
  800bec:	c9                   	leave  
  800bed:	c3                   	ret    

00800bee <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800bee:	55                   	push   %ebp
  800bef:	89 e5                	mov    %esp,%ebp
  800bf1:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf4:	b8 00 00 00 00       	mov    $0x0,%eax
  800bf9:	eb 01                	jmp    800bfc <strlen+0xe>
		n++;
  800bfb:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800bfc:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800c00:	75 f9                	jne    800bfb <strlen+0xd>
	return n;
}
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    

00800c04 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800c0a:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c0d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c12:	eb 01                	jmp    800c15 <strnlen+0x11>
		n++;
  800c14:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	39 d0                	cmp    %edx,%eax
  800c17:	74 06                	je     800c1f <strnlen+0x1b>
  800c19:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800c1d:	75 f5                	jne    800c14 <strnlen+0x10>
	return n;
}
  800c1f:	5d                   	pop    %ebp
  800c20:	c3                   	ret    

00800c21 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c21:	55                   	push   %ebp
  800c22:	89 e5                	mov    %esp,%ebp
  800c24:	53                   	push   %ebx
  800c25:	8b 45 08             	mov    0x8(%ebp),%eax
  800c28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800c2b:	89 c2                	mov    %eax,%edx
  800c2d:	42                   	inc    %edx
  800c2e:	41                   	inc    %ecx
  800c2f:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800c32:	88 5a ff             	mov    %bl,-0x1(%edx)
  800c35:	84 db                	test   %bl,%bl
  800c37:	75 f4                	jne    800c2d <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800c39:	5b                   	pop    %ebx
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    

00800c3c <strcat>:

char *
strcat(char *dst, const char *src)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	53                   	push   %ebx
  800c40:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800c43:	53                   	push   %ebx
  800c44:	e8 a5 ff ff ff       	call   800bee <strlen>
  800c49:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800c4c:	ff 75 0c             	pushl  0xc(%ebp)
  800c4f:	01 d8                	add    %ebx,%eax
  800c51:	50                   	push   %eax
  800c52:	e8 ca ff ff ff       	call   800c21 <strcpy>
	return dst;
}
  800c57:	89 d8                	mov    %ebx,%eax
  800c59:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c5c:	c9                   	leave  
  800c5d:	c3                   	ret    

00800c5e <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800c5e:	55                   	push   %ebp
  800c5f:	89 e5                	mov    %esp,%ebp
  800c61:	56                   	push   %esi
  800c62:	53                   	push   %ebx
  800c63:	8b 75 08             	mov    0x8(%ebp),%esi
  800c66:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800c69:	89 f3                	mov    %esi,%ebx
  800c6b:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c6e:	89 f2                	mov    %esi,%edx
  800c70:	eb 0c                	jmp    800c7e <strncpy+0x20>
		*dst++ = *src;
  800c72:	42                   	inc    %edx
  800c73:	8a 01                	mov    (%ecx),%al
  800c75:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800c78:	80 39 01             	cmpb   $0x1,(%ecx)
  800c7b:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800c7e:	39 da                	cmp    %ebx,%edx
  800c80:	75 f0                	jne    800c72 <strncpy+0x14>
	}
	return ret;
}
  800c82:	89 f0                	mov    %esi,%eax
  800c84:	5b                   	pop    %ebx
  800c85:	5e                   	pop    %esi
  800c86:	5d                   	pop    %ebp
  800c87:	c3                   	ret    

00800c88 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800c88:	55                   	push   %ebp
  800c89:	89 e5                	mov    %esp,%ebp
  800c8b:	56                   	push   %esi
  800c8c:	53                   	push   %ebx
  800c8d:	8b 75 08             	mov    0x8(%ebp),%esi
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800c96:	85 c0                	test   %eax,%eax
  800c98:	74 20                	je     800cba <strlcpy+0x32>
  800c9a:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800c9e:	89 f0                	mov    %esi,%eax
  800ca0:	eb 05                	jmp    800ca7 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ca2:	40                   	inc    %eax
  800ca3:	42                   	inc    %edx
  800ca4:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ca7:	39 d8                	cmp    %ebx,%eax
  800ca9:	74 06                	je     800cb1 <strlcpy+0x29>
  800cab:	8a 0a                	mov    (%edx),%cl
  800cad:	84 c9                	test   %cl,%cl
  800caf:	75 f1                	jne    800ca2 <strlcpy+0x1a>
		*dst = '\0';
  800cb1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb4:	29 f0                	sub    %esi,%eax
}
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    
  800cba:	89 f0                	mov    %esi,%eax
  800cbc:	eb f6                	jmp    800cb4 <strlcpy+0x2c>

00800cbe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cbe:	55                   	push   %ebp
  800cbf:	89 e5                	mov    %esp,%ebp
  800cc1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cc4:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800cc7:	eb 02                	jmp    800ccb <strcmp+0xd>
		p++, q++;
  800cc9:	41                   	inc    %ecx
  800cca:	42                   	inc    %edx
	while (*p && *p == *q)
  800ccb:	8a 01                	mov    (%ecx),%al
  800ccd:	84 c0                	test   %al,%al
  800ccf:	74 04                	je     800cd5 <strcmp+0x17>
  800cd1:	3a 02                	cmp    (%edx),%al
  800cd3:	74 f4                	je     800cc9 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	0f b6 c0             	movzbl %al,%eax
  800cd8:	0f b6 12             	movzbl (%edx),%edx
  800cdb:	29 d0                	sub    %edx,%eax
}
  800cdd:	5d                   	pop    %ebp
  800cde:	c3                   	ret    

00800cdf <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800cdf:	55                   	push   %ebp
  800ce0:	89 e5                	mov    %esp,%ebp
  800ce2:	53                   	push   %ebx
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	89 c3                	mov    %eax,%ebx
  800ceb:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800cee:	eb 02                	jmp    800cf2 <strncmp+0x13>
		n--, p++, q++;
  800cf0:	40                   	inc    %eax
  800cf1:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800cf2:	39 d8                	cmp    %ebx,%eax
  800cf4:	74 15                	je     800d0b <strncmp+0x2c>
  800cf6:	8a 08                	mov    (%eax),%cl
  800cf8:	84 c9                	test   %cl,%cl
  800cfa:	74 04                	je     800d00 <strncmp+0x21>
  800cfc:	3a 0a                	cmp    (%edx),%cl
  800cfe:	74 f0                	je     800cf0 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d00:	0f b6 00             	movzbl (%eax),%eax
  800d03:	0f b6 12             	movzbl (%edx),%edx
  800d06:	29 d0                	sub    %edx,%eax
}
  800d08:	5b                   	pop    %ebx
  800d09:	5d                   	pop    %ebp
  800d0a:	c3                   	ret    
		return 0;
  800d0b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d10:	eb f6                	jmp    800d08 <strncmp+0x29>

00800d12 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d12:	55                   	push   %ebp
  800d13:	89 e5                	mov    %esp,%ebp
  800d15:	8b 45 08             	mov    0x8(%ebp),%eax
  800d18:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800d1b:	8a 10                	mov    (%eax),%dl
  800d1d:	84 d2                	test   %dl,%dl
  800d1f:	74 07                	je     800d28 <strchr+0x16>
		if (*s == c)
  800d21:	38 ca                	cmp    %cl,%dl
  800d23:	74 08                	je     800d2d <strchr+0x1b>
	for (; *s; s++)
  800d25:	40                   	inc    %eax
  800d26:	eb f3                	jmp    800d1b <strchr+0x9>
			return (char *) s;
	return 0;
  800d28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d2d:	5d                   	pop    %ebp
  800d2e:	c3                   	ret    

00800d2f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d2f:	55                   	push   %ebp
  800d30:	89 e5                	mov    %esp,%ebp
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800d38:	8a 10                	mov    (%eax),%dl
  800d3a:	84 d2                	test   %dl,%dl
  800d3c:	74 07                	je     800d45 <strfind+0x16>
		if (*s == c)
  800d3e:	38 ca                	cmp    %cl,%dl
  800d40:	74 03                	je     800d45 <strfind+0x16>
	for (; *s; s++)
  800d42:	40                   	inc    %eax
  800d43:	eb f3                	jmp    800d38 <strfind+0x9>
			break;
	return (char *) s;
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	57                   	push   %edi
  800d4b:	56                   	push   %esi
  800d4c:	53                   	push   %ebx
  800d4d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800d50:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800d53:	85 c9                	test   %ecx,%ecx
  800d55:	74 13                	je     800d6a <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800d57:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800d5d:	75 05                	jne    800d64 <memset+0x1d>
  800d5f:	f6 c1 03             	test   $0x3,%cl
  800d62:	74 0d                	je     800d71 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800d64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d67:	fc                   	cld    
  800d68:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800d6a:	89 f8                	mov    %edi,%eax
  800d6c:	5b                   	pop    %ebx
  800d6d:	5e                   	pop    %esi
  800d6e:	5f                   	pop    %edi
  800d6f:	5d                   	pop    %ebp
  800d70:	c3                   	ret    
		c &= 0xFF;
  800d71:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800d75:	89 d3                	mov    %edx,%ebx
  800d77:	c1 e3 08             	shl    $0x8,%ebx
  800d7a:	89 d0                	mov    %edx,%eax
  800d7c:	c1 e0 18             	shl    $0x18,%eax
  800d7f:	89 d6                	mov    %edx,%esi
  800d81:	c1 e6 10             	shl    $0x10,%esi
  800d84:	09 f0                	or     %esi,%eax
  800d86:	09 c2                	or     %eax,%edx
  800d88:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800d8a:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800d8d:	89 d0                	mov    %edx,%eax
  800d8f:	fc                   	cld    
  800d90:	f3 ab                	rep stos %eax,%es:(%edi)
  800d92:	eb d6                	jmp    800d6a <memset+0x23>

00800d94 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800d94:	55                   	push   %ebp
  800d95:	89 e5                	mov    %esp,%ebp
  800d97:	57                   	push   %edi
  800d98:	56                   	push   %esi
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  800d9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800da2:	39 c6                	cmp    %eax,%esi
  800da4:	73 33                	jae    800dd9 <memmove+0x45>
  800da6:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800da9:	39 d0                	cmp    %edx,%eax
  800dab:	73 2c                	jae    800dd9 <memmove+0x45>
		s += n;
		d += n;
  800dad:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800db0:	89 d6                	mov    %edx,%esi
  800db2:	09 fe                	or     %edi,%esi
  800db4:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800dba:	75 13                	jne    800dcf <memmove+0x3b>
  800dbc:	f6 c1 03             	test   $0x3,%cl
  800dbf:	75 0e                	jne    800dcf <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800dc1:	83 ef 04             	sub    $0x4,%edi
  800dc4:	8d 72 fc             	lea    -0x4(%edx),%esi
  800dc7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800dca:	fd                   	std    
  800dcb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800dcd:	eb 07                	jmp    800dd6 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800dcf:	4f                   	dec    %edi
  800dd0:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800dd3:	fd                   	std    
  800dd4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800dd6:	fc                   	cld    
  800dd7:	eb 13                	jmp    800dec <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800dd9:	89 f2                	mov    %esi,%edx
  800ddb:	09 c2                	or     %eax,%edx
  800ddd:	f6 c2 03             	test   $0x3,%dl
  800de0:	75 05                	jne    800de7 <memmove+0x53>
  800de2:	f6 c1 03             	test   $0x3,%cl
  800de5:	74 09                	je     800df0 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800de7:	89 c7                	mov    %eax,%edi
  800de9:	fc                   	cld    
  800dea:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800dec:	5e                   	pop    %esi
  800ded:	5f                   	pop    %edi
  800dee:	5d                   	pop    %ebp
  800def:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800df0:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800df3:	89 c7                	mov    %eax,%edi
  800df5:	fc                   	cld    
  800df6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800df8:	eb f2                	jmp    800dec <memmove+0x58>

00800dfa <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800dfa:	55                   	push   %ebp
  800dfb:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800dfd:	ff 75 10             	pushl  0x10(%ebp)
  800e00:	ff 75 0c             	pushl  0xc(%ebp)
  800e03:	ff 75 08             	pushl  0x8(%ebp)
  800e06:	e8 89 ff ff ff       	call   800d94 <memmove>
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	56                   	push   %esi
  800e11:	53                   	push   %ebx
  800e12:	8b 45 08             	mov    0x8(%ebp),%eax
  800e15:	89 c6                	mov    %eax,%esi
  800e17:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800e1a:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800e1d:	39 f0                	cmp    %esi,%eax
  800e1f:	74 16                	je     800e37 <memcmp+0x2a>
		if (*s1 != *s2)
  800e21:	8a 08                	mov    (%eax),%cl
  800e23:	8a 1a                	mov    (%edx),%bl
  800e25:	38 d9                	cmp    %bl,%cl
  800e27:	75 04                	jne    800e2d <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800e29:	40                   	inc    %eax
  800e2a:	42                   	inc    %edx
  800e2b:	eb f0                	jmp    800e1d <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800e2d:	0f b6 c1             	movzbl %cl,%eax
  800e30:	0f b6 db             	movzbl %bl,%ebx
  800e33:	29 d8                	sub    %ebx,%eax
  800e35:	eb 05                	jmp    800e3c <memcmp+0x2f>
	}

	return 0;
  800e37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e3c:	5b                   	pop    %ebx
  800e3d:	5e                   	pop    %esi
  800e3e:	5d                   	pop    %ebp
  800e3f:	c3                   	ret    

00800e40 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800e40:	55                   	push   %ebp
  800e41:	89 e5                	mov    %esp,%ebp
  800e43:	8b 45 08             	mov    0x8(%ebp),%eax
  800e46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800e49:	89 c2                	mov    %eax,%edx
  800e4b:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800e4e:	39 d0                	cmp    %edx,%eax
  800e50:	73 07                	jae    800e59 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e52:	38 08                	cmp    %cl,(%eax)
  800e54:	74 03                	je     800e59 <memfind+0x19>
	for (; s < ends; s++)
  800e56:	40                   	inc    %eax
  800e57:	eb f5                	jmp    800e4e <memfind+0xe>
			break;
	return (void *) s;
}
  800e59:	5d                   	pop    %ebp
  800e5a:	c3                   	ret    

00800e5b <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e5b:	55                   	push   %ebp
  800e5c:	89 e5                	mov    %esp,%ebp
  800e5e:	57                   	push   %edi
  800e5f:	56                   	push   %esi
  800e60:	53                   	push   %ebx
  800e61:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e64:	eb 01                	jmp    800e67 <strtol+0xc>
		s++;
  800e66:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800e67:	8a 01                	mov    (%ecx),%al
  800e69:	3c 20                	cmp    $0x20,%al
  800e6b:	74 f9                	je     800e66 <strtol+0xb>
  800e6d:	3c 09                	cmp    $0x9,%al
  800e6f:	74 f5                	je     800e66 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800e71:	3c 2b                	cmp    $0x2b,%al
  800e73:	74 2b                	je     800ea0 <strtol+0x45>
		s++;
	else if (*s == '-')
  800e75:	3c 2d                	cmp    $0x2d,%al
  800e77:	74 2f                	je     800ea8 <strtol+0x4d>
	int neg = 0;
  800e79:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e7e:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800e85:	75 12                	jne    800e99 <strtol+0x3e>
  800e87:	80 39 30             	cmpb   $0x30,(%ecx)
  800e8a:	74 24                	je     800eb0 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800e8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e90:	75 07                	jne    800e99 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800e92:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800e99:	b8 00 00 00 00       	mov    $0x0,%eax
  800e9e:	eb 4e                	jmp    800eee <strtol+0x93>
		s++;
  800ea0:	41                   	inc    %ecx
	int neg = 0;
  800ea1:	bf 00 00 00 00       	mov    $0x0,%edi
  800ea6:	eb d6                	jmp    800e7e <strtol+0x23>
		s++, neg = 1;
  800ea8:	41                   	inc    %ecx
  800ea9:	bf 01 00 00 00       	mov    $0x1,%edi
  800eae:	eb ce                	jmp    800e7e <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800eb0:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800eb4:	74 10                	je     800ec6 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800eb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eba:	75 dd                	jne    800e99 <strtol+0x3e>
		s++, base = 8;
  800ebc:	41                   	inc    %ecx
  800ebd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ec4:	eb d3                	jmp    800e99 <strtol+0x3e>
		s += 2, base = 16;
  800ec6:	83 c1 02             	add    $0x2,%ecx
  800ec9:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ed0:	eb c7                	jmp    800e99 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800ed2:	8d 72 9f             	lea    -0x61(%edx),%esi
  800ed5:	89 f3                	mov    %esi,%ebx
  800ed7:	80 fb 19             	cmp    $0x19,%bl
  800eda:	77 24                	ja     800f00 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800edc:	0f be d2             	movsbl %dl,%edx
  800edf:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800ee2:	3b 55 10             	cmp    0x10(%ebp),%edx
  800ee5:	7d 2b                	jge    800f12 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800ee7:	41                   	inc    %ecx
  800ee8:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800eee:	8a 11                	mov    (%ecx),%dl
  800ef0:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800ef3:	80 fb 09             	cmp    $0x9,%bl
  800ef6:	77 da                	ja     800ed2 <strtol+0x77>
			dig = *s - '0';
  800ef8:	0f be d2             	movsbl %dl,%edx
  800efb:	83 ea 30             	sub    $0x30,%edx
  800efe:	eb e2                	jmp    800ee2 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800f00:	8d 72 bf             	lea    -0x41(%edx),%esi
  800f03:	89 f3                	mov    %esi,%ebx
  800f05:	80 fb 19             	cmp    $0x19,%bl
  800f08:	77 08                	ja     800f12 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800f0a:	0f be d2             	movsbl %dl,%edx
  800f0d:	83 ea 37             	sub    $0x37,%edx
  800f10:	eb d0                	jmp    800ee2 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800f12:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f16:	74 05                	je     800f1d <strtol+0xc2>
		*endptr = (char *) s;
  800f18:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f1b:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800f1d:	85 ff                	test   %edi,%edi
  800f1f:	74 02                	je     800f23 <strtol+0xc8>
  800f21:	f7 d8                	neg    %eax
}
  800f23:	5b                   	pop    %ebx
  800f24:	5e                   	pop    %esi
  800f25:	5f                   	pop    %edi
  800f26:	5d                   	pop    %ebp
  800f27:	c3                   	ret    

00800f28 <atoi>:

int
atoi(const char *s)
{
  800f28:	55                   	push   %ebp
  800f29:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800f2b:	6a 0a                	push   $0xa
  800f2d:	6a 00                	push   $0x0
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 24 ff ff ff       	call   800e5b <strtol>
}
  800f37:	c9                   	leave  
  800f38:	c3                   	ret    

00800f39 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800f39:	55                   	push   %ebp
  800f3a:	89 e5                	mov    %esp,%ebp
  800f3c:	57                   	push   %edi
  800f3d:	56                   	push   %esi
  800f3e:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f3f:	b8 00 00 00 00       	mov    $0x0,%eax
  800f44:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f47:	8b 55 08             	mov    0x8(%ebp),%edx
  800f4a:	89 c3                	mov    %eax,%ebx
  800f4c:	89 c7                	mov    %eax,%edi
  800f4e:	89 c6                	mov    %eax,%esi
  800f50:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800f52:	5b                   	pop    %ebx
  800f53:	5e                   	pop    %esi
  800f54:	5f                   	pop    %edi
  800f55:	5d                   	pop    %ebp
  800f56:	c3                   	ret    

00800f57 <sys_cgetc>:

int
sys_cgetc(void)
{
  800f57:	55                   	push   %ebp
  800f58:	89 e5                	mov    %esp,%ebp
  800f5a:	57                   	push   %edi
  800f5b:	56                   	push   %esi
  800f5c:	53                   	push   %ebx
	asm volatile("int %1\n"
  800f5d:	ba 00 00 00 00       	mov    $0x0,%edx
  800f62:	b8 01 00 00 00       	mov    $0x1,%eax
  800f67:	89 d1                	mov    %edx,%ecx
  800f69:	89 d3                	mov    %edx,%ebx
  800f6b:	89 d7                	mov    %edx,%edi
  800f6d:	89 d6                	mov    %edx,%esi
  800f6f:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
  800f7c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f7f:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f84:	b8 03 00 00 00       	mov    $0x3,%eax
  800f89:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8c:	89 cb                	mov    %ecx,%ebx
  800f8e:	89 cf                	mov    %ecx,%edi
  800f90:	89 ce                	mov    %ecx,%esi
  800f92:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f94:	85 c0                	test   %eax,%eax
  800f96:	7f 08                	jg     800fa0 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800f98:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f9b:	5b                   	pop    %ebx
  800f9c:	5e                   	pop    %esi
  800f9d:	5f                   	pop    %edi
  800f9e:	5d                   	pop    %ebp
  800f9f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fa0:	83 ec 0c             	sub    $0xc,%esp
  800fa3:	50                   	push   %eax
  800fa4:	6a 03                	push   $0x3
  800fa6:	68 7f 2f 80 00       	push   $0x802f7f
  800fab:	6a 23                	push   $0x23
  800fad:	68 9c 2f 80 00       	push   $0x802f9c
  800fb2:	e8 4f f5 ff ff       	call   800506 <_panic>

00800fb7 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	57                   	push   %edi
  800fbb:	56                   	push   %esi
  800fbc:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fbd:	ba 00 00 00 00       	mov    $0x0,%edx
  800fc2:	b8 02 00 00 00       	mov    $0x2,%eax
  800fc7:	89 d1                	mov    %edx,%ecx
  800fc9:	89 d3                	mov    %edx,%ebx
  800fcb:	89 d7                	mov    %edx,%edi
  800fcd:	89 d6                	mov    %edx,%esi
  800fcf:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800fd1:	5b                   	pop    %ebx
  800fd2:	5e                   	pop    %esi
  800fd3:	5f                   	pop    %edi
  800fd4:	5d                   	pop    %ebp
  800fd5:	c3                   	ret    

00800fd6 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800fd6:	55                   	push   %ebp
  800fd7:	89 e5                	mov    %esp,%ebp
  800fd9:	57                   	push   %edi
  800fda:	56                   	push   %esi
  800fdb:	53                   	push   %ebx
  800fdc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fdf:	be 00 00 00 00       	mov    $0x0,%esi
  800fe4:	b8 04 00 00 00       	mov    $0x4,%eax
  800fe9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fec:	8b 55 08             	mov    0x8(%ebp),%edx
  800fef:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff2:	89 f7                	mov    %esi,%edi
  800ff4:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ff6:	85 c0                	test   %eax,%eax
  800ff8:	7f 08                	jg     801002 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800ffa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffd:	5b                   	pop    %ebx
  800ffe:	5e                   	pop    %esi
  800fff:	5f                   	pop    %edi
  801000:	5d                   	pop    %ebp
  801001:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801002:	83 ec 0c             	sub    $0xc,%esp
  801005:	50                   	push   %eax
  801006:	6a 04                	push   $0x4
  801008:	68 7f 2f 80 00       	push   $0x802f7f
  80100d:	6a 23                	push   $0x23
  80100f:	68 9c 2f 80 00       	push   $0x802f9c
  801014:	e8 ed f4 ff ff       	call   800506 <_panic>

00801019 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
  80101c:	57                   	push   %edi
  80101d:	56                   	push   %esi
  80101e:	53                   	push   %ebx
  80101f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801022:	b8 05 00 00 00       	mov    $0x5,%eax
  801027:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80102a:	8b 55 08             	mov    0x8(%ebp),%edx
  80102d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801030:	8b 7d 14             	mov    0x14(%ebp),%edi
  801033:	8b 75 18             	mov    0x18(%ebp),%esi
  801036:	cd 30                	int    $0x30
	if(check && ret > 0)
  801038:	85 c0                	test   %eax,%eax
  80103a:	7f 08                	jg     801044 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  80103c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80103f:	5b                   	pop    %ebx
  801040:	5e                   	pop    %esi
  801041:	5f                   	pop    %edi
  801042:	5d                   	pop    %ebp
  801043:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801044:	83 ec 0c             	sub    $0xc,%esp
  801047:	50                   	push   %eax
  801048:	6a 05                	push   $0x5
  80104a:	68 7f 2f 80 00       	push   $0x802f7f
  80104f:	6a 23                	push   $0x23
  801051:	68 9c 2f 80 00       	push   $0x802f9c
  801056:	e8 ab f4 ff ff       	call   800506 <_panic>

0080105b <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	57                   	push   %edi
  80105f:	56                   	push   %esi
  801060:	53                   	push   %ebx
  801061:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801064:	bb 00 00 00 00       	mov    $0x0,%ebx
  801069:	b8 06 00 00 00       	mov    $0x6,%eax
  80106e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801071:	8b 55 08             	mov    0x8(%ebp),%edx
  801074:	89 df                	mov    %ebx,%edi
  801076:	89 de                	mov    %ebx,%esi
  801078:	cd 30                	int    $0x30
	if(check && ret > 0)
  80107a:	85 c0                	test   %eax,%eax
  80107c:	7f 08                	jg     801086 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  80107e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801081:	5b                   	pop    %ebx
  801082:	5e                   	pop    %esi
  801083:	5f                   	pop    %edi
  801084:	5d                   	pop    %ebp
  801085:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801086:	83 ec 0c             	sub    $0xc,%esp
  801089:	50                   	push   %eax
  80108a:	6a 06                	push   $0x6
  80108c:	68 7f 2f 80 00       	push   $0x802f7f
  801091:	6a 23                	push   $0x23
  801093:	68 9c 2f 80 00       	push   $0x802f9c
  801098:	e8 69 f4 ff ff       	call   800506 <_panic>

0080109d <sys_yield>:

void
sys_yield(void)
{
  80109d:	55                   	push   %ebp
  80109e:	89 e5                	mov    %esp,%ebp
  8010a0:	57                   	push   %edi
  8010a1:	56                   	push   %esi
  8010a2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8010a8:	b8 0b 00 00 00       	mov    $0xb,%eax
  8010ad:	89 d1                	mov    %edx,%ecx
  8010af:	89 d3                	mov    %edx,%ebx
  8010b1:	89 d7                	mov    %edx,%edi
  8010b3:	89 d6                	mov    %edx,%esi
  8010b5:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  8010b7:	5b                   	pop    %ebx
  8010b8:	5e                   	pop    %esi
  8010b9:	5f                   	pop    %edi
  8010ba:	5d                   	pop    %ebp
  8010bb:	c3                   	ret    

008010bc <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  8010bc:	55                   	push   %ebp
  8010bd:	89 e5                	mov    %esp,%ebp
  8010bf:	57                   	push   %edi
  8010c0:	56                   	push   %esi
  8010c1:	53                   	push   %ebx
  8010c2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010c5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8010ca:	b8 08 00 00 00       	mov    $0x8,%eax
  8010cf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d2:	8b 55 08             	mov    0x8(%ebp),%edx
  8010d5:	89 df                	mov    %ebx,%edi
  8010d7:	89 de                	mov    %ebx,%esi
  8010d9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010db:	85 c0                	test   %eax,%eax
  8010dd:	7f 08                	jg     8010e7 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8010df:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010e7:	83 ec 0c             	sub    $0xc,%esp
  8010ea:	50                   	push   %eax
  8010eb:	6a 08                	push   $0x8
  8010ed:	68 7f 2f 80 00       	push   $0x802f7f
  8010f2:	6a 23                	push   $0x23
  8010f4:	68 9c 2f 80 00       	push   $0x802f9c
  8010f9:	e8 08 f4 ff ff       	call   800506 <_panic>

008010fe <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  8010fe:	55                   	push   %ebp
  8010ff:	89 e5                	mov    %esp,%ebp
  801101:	57                   	push   %edi
  801102:	56                   	push   %esi
  801103:	53                   	push   %ebx
  801104:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801107:	b9 00 00 00 00       	mov    $0x0,%ecx
  80110c:	b8 0c 00 00 00       	mov    $0xc,%eax
  801111:	8b 55 08             	mov    0x8(%ebp),%edx
  801114:	89 cb                	mov    %ecx,%ebx
  801116:	89 cf                	mov    %ecx,%edi
  801118:	89 ce                	mov    %ecx,%esi
  80111a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80111c:	85 c0                	test   %eax,%eax
  80111e:	7f 08                	jg     801128 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  801120:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801123:	5b                   	pop    %ebx
  801124:	5e                   	pop    %esi
  801125:	5f                   	pop    %edi
  801126:	5d                   	pop    %ebp
  801127:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801128:	83 ec 0c             	sub    $0xc,%esp
  80112b:	50                   	push   %eax
  80112c:	6a 0c                	push   $0xc
  80112e:	68 7f 2f 80 00       	push   $0x802f7f
  801133:	6a 23                	push   $0x23
  801135:	68 9c 2f 80 00       	push   $0x802f9c
  80113a:	e8 c7 f3 ff ff       	call   800506 <_panic>

0080113f <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  80113f:	55                   	push   %ebp
  801140:	89 e5                	mov    %esp,%ebp
  801142:	57                   	push   %edi
  801143:	56                   	push   %esi
  801144:	53                   	push   %ebx
  801145:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801148:	bb 00 00 00 00       	mov    $0x0,%ebx
  80114d:	b8 09 00 00 00       	mov    $0x9,%eax
  801152:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 df                	mov    %ebx,%edi
  80115a:	89 de                	mov    %ebx,%esi
  80115c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80115e:	85 c0                	test   %eax,%eax
  801160:	7f 08                	jg     80116a <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801162:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801165:	5b                   	pop    %ebx
  801166:	5e                   	pop    %esi
  801167:	5f                   	pop    %edi
  801168:	5d                   	pop    %ebp
  801169:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80116a:	83 ec 0c             	sub    $0xc,%esp
  80116d:	50                   	push   %eax
  80116e:	6a 09                	push   $0x9
  801170:	68 7f 2f 80 00       	push   $0x802f7f
  801175:	6a 23                	push   $0x23
  801177:	68 9c 2f 80 00       	push   $0x802f9c
  80117c:	e8 85 f3 ff ff       	call   800506 <_panic>

00801181 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801181:	55                   	push   %ebp
  801182:	89 e5                	mov    %esp,%ebp
  801184:	57                   	push   %edi
  801185:	56                   	push   %esi
  801186:	53                   	push   %ebx
  801187:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80118a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80118f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801194:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801197:	8b 55 08             	mov    0x8(%ebp),%edx
  80119a:	89 df                	mov    %ebx,%edi
  80119c:	89 de                	mov    %ebx,%esi
  80119e:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011a0:	85 c0                	test   %eax,%eax
  8011a2:	7f 08                	jg     8011ac <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8011a4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011a7:	5b                   	pop    %ebx
  8011a8:	5e                   	pop    %esi
  8011a9:	5f                   	pop    %edi
  8011aa:	5d                   	pop    %ebp
  8011ab:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ac:	83 ec 0c             	sub    $0xc,%esp
  8011af:	50                   	push   %eax
  8011b0:	6a 0a                	push   $0xa
  8011b2:	68 7f 2f 80 00       	push   $0x802f7f
  8011b7:	6a 23                	push   $0x23
  8011b9:	68 9c 2f 80 00       	push   $0x802f9c
  8011be:	e8 43 f3 ff ff       	call   800506 <_panic>

008011c3 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8011c3:	55                   	push   %ebp
  8011c4:	89 e5                	mov    %esp,%ebp
  8011c6:	57                   	push   %edi
  8011c7:	56                   	push   %esi
  8011c8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8011c9:	be 00 00 00 00       	mov    $0x0,%esi
  8011ce:	b8 0d 00 00 00       	mov    $0xd,%eax
  8011d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011dc:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011df:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8011e1:	5b                   	pop    %ebx
  8011e2:	5e                   	pop    %esi
  8011e3:	5f                   	pop    %edi
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	57                   	push   %edi
  8011ea:	56                   	push   %esi
  8011eb:	53                   	push   %ebx
  8011ec:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ef:	b9 00 00 00 00       	mov    $0x0,%ecx
  8011f4:	b8 0e 00 00 00       	mov    $0xe,%eax
  8011f9:	8b 55 08             	mov    0x8(%ebp),%edx
  8011fc:	89 cb                	mov    %ecx,%ebx
  8011fe:	89 cf                	mov    %ecx,%edi
  801200:	89 ce                	mov    %ecx,%esi
  801202:	cd 30                	int    $0x30
	if(check && ret > 0)
  801204:	85 c0                	test   %eax,%eax
  801206:	7f 08                	jg     801210 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801208:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80120b:	5b                   	pop    %ebx
  80120c:	5e                   	pop    %esi
  80120d:	5f                   	pop    %edi
  80120e:	5d                   	pop    %ebp
  80120f:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801210:	83 ec 0c             	sub    $0xc,%esp
  801213:	50                   	push   %eax
  801214:	6a 0e                	push   $0xe
  801216:	68 7f 2f 80 00       	push   $0x802f7f
  80121b:	6a 23                	push   $0x23
  80121d:	68 9c 2f 80 00       	push   $0x802f9c
  801222:	e8 df f2 ff ff       	call   800506 <_panic>

00801227 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	57                   	push   %edi
  80122b:	56                   	push   %esi
  80122c:	53                   	push   %ebx
	asm volatile("int %1\n"
  80122d:	be 00 00 00 00       	mov    $0x0,%esi
  801232:	b8 0f 00 00 00       	mov    $0xf,%eax
  801237:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80123a:	8b 55 08             	mov    0x8(%ebp),%edx
  80123d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801240:	89 f7                	mov    %esi,%edi
  801242:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801244:	5b                   	pop    %ebx
  801245:	5e                   	pop    %esi
  801246:	5f                   	pop    %edi
  801247:	5d                   	pop    %ebp
  801248:	c3                   	ret    

00801249 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  801249:	55                   	push   %ebp
  80124a:	89 e5                	mov    %esp,%ebp
  80124c:	57                   	push   %edi
  80124d:	56                   	push   %esi
  80124e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80124f:	be 00 00 00 00       	mov    $0x0,%esi
  801254:	b8 10 00 00 00       	mov    $0x10,%eax
  801259:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80125c:	8b 55 08             	mov    0x8(%ebp),%edx
  80125f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801262:	89 f7                	mov    %esi,%edi
  801264:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801266:	5b                   	pop    %ebx
  801267:	5e                   	pop    %esi
  801268:	5f                   	pop    %edi
  801269:	5d                   	pop    %ebp
  80126a:	c3                   	ret    

0080126b <sys_set_console_color>:

void sys_set_console_color(int color) {
  80126b:	55                   	push   %ebp
  80126c:	89 e5                	mov    %esp,%ebp
  80126e:	57                   	push   %edi
  80126f:	56                   	push   %esi
  801270:	53                   	push   %ebx
	asm volatile("int %1\n"
  801271:	b9 00 00 00 00       	mov    $0x0,%ecx
  801276:	b8 11 00 00 00       	mov    $0x11,%eax
  80127b:	8b 55 08             	mov    0x8(%ebp),%edx
  80127e:	89 cb                	mov    %ecx,%ebx
  801280:	89 cf                	mov    %ecx,%edi
  801282:	89 ce                	mov    %ecx,%esi
  801284:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  801286:	5b                   	pop    %ebx
  801287:	5e                   	pop    %esi
  801288:	5f                   	pop    %edi
  801289:	5d                   	pop    %ebp
  80128a:	c3                   	ret    

0080128b <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  80128b:	55                   	push   %ebp
  80128c:	89 e5                	mov    %esp,%ebp
  80128e:	56                   	push   %esi
  80128f:	53                   	push   %ebx
  801290:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  801293:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801295:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801299:	0f 84 84 00 00 00    	je     801323 <pgfault+0x98>
  80129f:	89 d8                	mov    %ebx,%eax
  8012a1:	c1 e8 16             	shr    $0x16,%eax
  8012a4:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8012ab:	a8 01                	test   $0x1,%al
  8012ad:	74 74                	je     801323 <pgfault+0x98>
  8012af:	89 d8                	mov    %ebx,%eax
  8012b1:	c1 e8 0c             	shr    $0xc,%eax
  8012b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8012bb:	f6 c4 08             	test   $0x8,%ah
  8012be:	74 63                	je     801323 <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  8012c0:	e8 f2 fc ff ff       	call   800fb7 <sys_getenvid>
  8012c5:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  8012c7:	83 ec 04             	sub    $0x4,%esp
  8012ca:	6a 07                	push   $0x7
  8012cc:	68 00 f0 7f 00       	push   $0x7ff000
  8012d1:	50                   	push   %eax
  8012d2:	e8 ff fc ff ff       	call   800fd6 <sys_page_alloc>
  8012d7:	83 c4 10             	add    $0x10,%esp
  8012da:	85 c0                	test   %eax,%eax
  8012dc:	78 5b                	js     801339 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  8012de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  8012e4:	83 ec 04             	sub    $0x4,%esp
  8012e7:	68 00 10 00 00       	push   $0x1000
  8012ec:	53                   	push   %ebx
  8012ed:	68 00 f0 7f 00       	push   $0x7ff000
  8012f2:	e8 03 fb ff ff       	call   800dfa <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  8012f7:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  8012fe:	53                   	push   %ebx
  8012ff:	56                   	push   %esi
  801300:	68 00 f0 7f 00       	push   $0x7ff000
  801305:	56                   	push   %esi
  801306:	e8 0e fd ff ff       	call   801019 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  80130b:	83 c4 18             	add    $0x18,%esp
  80130e:	68 00 f0 7f 00       	push   $0x7ff000
  801313:	56                   	push   %esi
  801314:	e8 42 fd ff ff       	call   80105b <sys_page_unmap>

}
  801319:	83 c4 10             	add    $0x10,%esp
  80131c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80131f:	5b                   	pop    %ebx
  801320:	5e                   	pop    %esi
  801321:	5d                   	pop    %ebp
  801322:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801323:	68 ac 2f 80 00       	push   $0x802fac
  801328:	68 36 30 80 00       	push   $0x803036
  80132d:	6a 1c                	push   $0x1c
  80132f:	68 4b 30 80 00       	push   $0x80304b
  801334:	e8 cd f1 ff ff       	call   800506 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801339:	68 fc 2f 80 00       	push   $0x802ffc
  80133e:	68 36 30 80 00       	push   $0x803036
  801343:	6a 26                	push   $0x26
  801345:	68 4b 30 80 00       	push   $0x80304b
  80134a:	e8 b7 f1 ff ff       	call   800506 <_panic>

0080134f <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  80134f:	55                   	push   %ebp
  801350:	89 e5                	mov    %esp,%ebp
  801352:	57                   	push   %edi
  801353:	56                   	push   %esi
  801354:	53                   	push   %ebx
  801355:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  801358:	68 8b 12 80 00       	push   $0x80128b
  80135d:	e8 6b 13 00 00       	call   8026cd <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801362:	b8 07 00 00 00       	mov    $0x7,%eax
  801367:	cd 30                	int    $0x30
  801369:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80136c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  80136f:	83 c4 10             	add    $0x10,%esp
  801372:	85 c0                	test   %eax,%eax
  801374:	0f 88 58 01 00 00    	js     8014d2 <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  80137a:	85 c0                	test   %eax,%eax
  80137c:	74 07                	je     801385 <fork+0x36>
  80137e:	bb 00 00 00 00       	mov    $0x0,%ebx
  801383:	eb 72                	jmp    8013f7 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  801385:	e8 2d fc ff ff       	call   800fb7 <sys_getenvid>
  80138a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80138f:	89 c2                	mov    %eax,%edx
  801391:	c1 e2 05             	shl    $0x5,%edx
  801394:	29 c2                	sub    %eax,%edx
  801396:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80139d:	a3 04 50 80 00       	mov    %eax,0x805004
		return 0;
  8013a2:	e9 20 01 00 00       	jmp    8014c7 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  8013a7:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8013ae:	e8 04 fc ff ff       	call   800fb7 <sys_getenvid>
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8013bc:	57                   	push   %edi
  8013bd:	56                   	push   %esi
  8013be:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c1:	56                   	push   %esi
  8013c2:	50                   	push   %eax
  8013c3:	e8 51 fc ff ff       	call   801019 <sys_page_map>
  8013c8:	83 c4 20             	add    $0x20,%esp
  8013cb:	eb 18                	jmp    8013e5 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  8013cd:	e8 e5 fb ff ff       	call   800fb7 <sys_getenvid>
  8013d2:	83 ec 0c             	sub    $0xc,%esp
  8013d5:	6a 05                	push   $0x5
  8013d7:	56                   	push   %esi
  8013d8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013db:	56                   	push   %esi
  8013dc:	50                   	push   %eax
  8013dd:	e8 37 fc ff ff       	call   801019 <sys_page_map>
  8013e2:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  8013e5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  8013eb:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  8013f1:	0f 84 8f 00 00 00    	je     801486 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  8013f7:	89 d8                	mov    %ebx,%eax
  8013f9:	c1 e8 16             	shr    $0x16,%eax
  8013fc:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801403:	a8 01                	test   $0x1,%al
  801405:	74 de                	je     8013e5 <fork+0x96>
  801407:	89 d8                	mov    %ebx,%eax
  801409:	c1 e8 0c             	shr    $0xc,%eax
  80140c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801413:	a8 04                	test   $0x4,%al
  801415:	74 ce                	je     8013e5 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801417:	89 de                	mov    %ebx,%esi
  801419:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  80141f:	89 f0                	mov    %esi,%eax
  801421:	c1 e8 0c             	shr    $0xc,%eax
  801424:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  80142b:	f6 c6 04             	test   $0x4,%dh
  80142e:	0f 85 73 ff ff ff    	jne    8013a7 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  801434:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80143b:	a9 02 08 00 00       	test   $0x802,%eax
  801440:	74 8b                	je     8013cd <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801442:	e8 70 fb ff ff       	call   800fb7 <sys_getenvid>
  801447:	83 ec 0c             	sub    $0xc,%esp
  80144a:	68 05 08 00 00       	push   $0x805
  80144f:	56                   	push   %esi
  801450:	ff 75 e4             	pushl  -0x1c(%ebp)
  801453:	56                   	push   %esi
  801454:	50                   	push   %eax
  801455:	e8 bf fb ff ff       	call   801019 <sys_page_map>
  80145a:	83 c4 20             	add    $0x20,%esp
  80145d:	85 c0                	test   %eax,%eax
  80145f:	78 84                	js     8013e5 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801461:	e8 51 fb ff ff       	call   800fb7 <sys_getenvid>
  801466:	89 c7                	mov    %eax,%edi
  801468:	e8 4a fb ff ff       	call   800fb7 <sys_getenvid>
  80146d:	83 ec 0c             	sub    $0xc,%esp
  801470:	68 05 08 00 00       	push   $0x805
  801475:	56                   	push   %esi
  801476:	57                   	push   %edi
  801477:	56                   	push   %esi
  801478:	50                   	push   %eax
  801479:	e8 9b fb ff ff       	call   801019 <sys_page_map>
  80147e:	83 c4 20             	add    $0x20,%esp
  801481:	e9 5f ff ff ff       	jmp    8013e5 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	6a 07                	push   $0x7
  80148b:	68 00 f0 bf ee       	push   $0xeebff000
  801490:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801493:	57                   	push   %edi
  801494:	e8 3d fb ff ff       	call   800fd6 <sys_page_alloc>
  801499:	83 c4 10             	add    $0x10,%esp
  80149c:	85 c0                	test   %eax,%eax
  80149e:	78 3b                	js     8014db <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  8014a0:	83 ec 08             	sub    $0x8,%esp
  8014a3:	68 13 27 80 00       	push   $0x802713
  8014a8:	57                   	push   %edi
  8014a9:	e8 d3 fc ff ff       	call   801181 <sys_env_set_pgfault_upcall>
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	78 2f                	js     8014e4 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  8014b5:	83 ec 08             	sub    $0x8,%esp
  8014b8:	6a 02                	push   $0x2
  8014ba:	57                   	push   %edi
  8014bb:	e8 fc fb ff ff       	call   8010bc <sys_env_set_status>
	if (temp < 0) {
  8014c0:	83 c4 10             	add    $0x10,%esp
  8014c3:	85 c0                	test   %eax,%eax
  8014c5:	78 26                	js     8014ed <fork+0x19e>
		return -1;
	}

	return childid;
}
  8014c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8014ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014cd:	5b                   	pop    %ebx
  8014ce:	5e                   	pop    %esi
  8014cf:	5f                   	pop    %edi
  8014d0:	5d                   	pop    %ebp
  8014d1:	c3                   	ret    
		return -1;
  8014d2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014d9:	eb ec                	jmp    8014c7 <fork+0x178>
		return -1;
  8014db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014e2:	eb e3                	jmp    8014c7 <fork+0x178>
		return -1;
  8014e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014eb:	eb da                	jmp    8014c7 <fork+0x178>
		return -1;
  8014ed:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8014f4:	eb d1                	jmp    8014c7 <fork+0x178>

008014f6 <sfork>:

// Challenge!
int
sfork(void)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  8014fc:	68 56 30 80 00       	push   $0x803056
  801501:	68 85 00 00 00       	push   $0x85
  801506:	68 4b 30 80 00       	push   $0x80304b
  80150b:	e8 f6 ef ff ff       	call   800506 <_panic>

00801510 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801513:	8b 45 08             	mov    0x8(%ebp),%eax
  801516:	05 00 00 00 30       	add    $0x30000000,%eax
  80151b:	c1 e8 0c             	shr    $0xc,%eax
}
  80151e:	5d                   	pop    %ebp
  80151f:	c3                   	ret    

00801520 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801520:	55                   	push   %ebp
  801521:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801523:	8b 45 08             	mov    0x8(%ebp),%eax
  801526:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80152b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801530:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801535:	5d                   	pop    %ebp
  801536:	c3                   	ret    

00801537 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801537:	55                   	push   %ebp
  801538:	89 e5                	mov    %esp,%ebp
  80153a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80153d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801542:	89 c2                	mov    %eax,%edx
  801544:	c1 ea 16             	shr    $0x16,%edx
  801547:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80154e:	f6 c2 01             	test   $0x1,%dl
  801551:	74 2a                	je     80157d <fd_alloc+0x46>
  801553:	89 c2                	mov    %eax,%edx
  801555:	c1 ea 0c             	shr    $0xc,%edx
  801558:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80155f:	f6 c2 01             	test   $0x1,%dl
  801562:	74 19                	je     80157d <fd_alloc+0x46>
  801564:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801569:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80156e:	75 d2                	jne    801542 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801570:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801576:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80157b:	eb 07                	jmp    801584 <fd_alloc+0x4d>
			*fd_store = fd;
  80157d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80157f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801584:	5d                   	pop    %ebp
  801585:	c3                   	ret    

00801586 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801586:	55                   	push   %ebp
  801587:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801589:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80158d:	77 39                	ja     8015c8 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80158f:	8b 45 08             	mov    0x8(%ebp),%eax
  801592:	c1 e0 0c             	shl    $0xc,%eax
  801595:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80159a:	89 c2                	mov    %eax,%edx
  80159c:	c1 ea 16             	shr    $0x16,%edx
  80159f:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015a6:	f6 c2 01             	test   $0x1,%dl
  8015a9:	74 24                	je     8015cf <fd_lookup+0x49>
  8015ab:	89 c2                	mov    %eax,%edx
  8015ad:	c1 ea 0c             	shr    $0xc,%edx
  8015b0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015b7:	f6 c2 01             	test   $0x1,%dl
  8015ba:	74 1a                	je     8015d6 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8015bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bf:	89 02                	mov    %eax,(%edx)
	return 0;
  8015c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015c6:	5d                   	pop    %ebp
  8015c7:	c3                   	ret    
		return -E_INVAL;
  8015c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015cd:	eb f7                	jmp    8015c6 <fd_lookup+0x40>
		return -E_INVAL;
  8015cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015d4:	eb f0                	jmp    8015c6 <fd_lookup+0x40>
  8015d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015db:	eb e9                	jmp    8015c6 <fd_lookup+0x40>

008015dd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
  8015e0:	83 ec 08             	sub    $0x8,%esp
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	ba e8 30 80 00       	mov    $0x8030e8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8015eb:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  8015f0:	39 08                	cmp    %ecx,(%eax)
  8015f2:	74 33                	je     801627 <dev_lookup+0x4a>
  8015f4:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8015f7:	8b 02                	mov    (%edx),%eax
  8015f9:	85 c0                	test   %eax,%eax
  8015fb:	75 f3                	jne    8015f0 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8015fd:	a1 04 50 80 00       	mov    0x805004,%eax
  801602:	8b 40 48             	mov    0x48(%eax),%eax
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	51                   	push   %ecx
  801609:	50                   	push   %eax
  80160a:	68 6c 30 80 00       	push   $0x80306c
  80160f:	e8 05 f0 ff ff       	call   800619 <cprintf>
	*dev = 0;
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801625:	c9                   	leave  
  801626:	c3                   	ret    
			*dev = devtab[i];
  801627:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80162a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80162c:	b8 00 00 00 00       	mov    $0x0,%eax
  801631:	eb f2                	jmp    801625 <dev_lookup+0x48>

00801633 <fd_close>:
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	57                   	push   %edi
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
  801639:	83 ec 1c             	sub    $0x1c,%esp
  80163c:	8b 75 08             	mov    0x8(%ebp),%esi
  80163f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801642:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801645:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801646:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80164c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80164f:	50                   	push   %eax
  801650:	e8 31 ff ff ff       	call   801586 <fd_lookup>
  801655:	89 c7                	mov    %eax,%edi
  801657:	83 c4 08             	add    $0x8,%esp
  80165a:	85 c0                	test   %eax,%eax
  80165c:	78 05                	js     801663 <fd_close+0x30>
	    || fd != fd2)
  80165e:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801661:	74 13                	je     801676 <fd_close+0x43>
		return (must_exist ? r : 0);
  801663:	84 db                	test   %bl,%bl
  801665:	75 05                	jne    80166c <fd_close+0x39>
  801667:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80166c:	89 f8                	mov    %edi,%eax
  80166e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801671:	5b                   	pop    %ebx
  801672:	5e                   	pop    %esi
  801673:	5f                   	pop    %edi
  801674:	5d                   	pop    %ebp
  801675:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801676:	83 ec 08             	sub    $0x8,%esp
  801679:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80167c:	50                   	push   %eax
  80167d:	ff 36                	pushl  (%esi)
  80167f:	e8 59 ff ff ff       	call   8015dd <dev_lookup>
  801684:	89 c7                	mov    %eax,%edi
  801686:	83 c4 10             	add    $0x10,%esp
  801689:	85 c0                	test   %eax,%eax
  80168b:	78 15                	js     8016a2 <fd_close+0x6f>
		if (dev->dev_close)
  80168d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801690:	8b 40 10             	mov    0x10(%eax),%eax
  801693:	85 c0                	test   %eax,%eax
  801695:	74 1b                	je     8016b2 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	56                   	push   %esi
  80169b:	ff d0                	call   *%eax
  80169d:	89 c7                	mov    %eax,%edi
  80169f:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8016a2:	83 ec 08             	sub    $0x8,%esp
  8016a5:	56                   	push   %esi
  8016a6:	6a 00                	push   $0x0
  8016a8:	e8 ae f9 ff ff       	call   80105b <sys_page_unmap>
	return r;
  8016ad:	83 c4 10             	add    $0x10,%esp
  8016b0:	eb ba                	jmp    80166c <fd_close+0x39>
			r = 0;
  8016b2:	bf 00 00 00 00       	mov    $0x0,%edi
  8016b7:	eb e9                	jmp    8016a2 <fd_close+0x6f>

008016b9 <close>:

int
close(int fdnum)
{
  8016b9:	55                   	push   %ebp
  8016ba:	89 e5                	mov    %esp,%ebp
  8016bc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8016bf:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8016c2:	50                   	push   %eax
  8016c3:	ff 75 08             	pushl  0x8(%ebp)
  8016c6:	e8 bb fe ff ff       	call   801586 <fd_lookup>
  8016cb:	83 c4 08             	add    $0x8,%esp
  8016ce:	85 c0                	test   %eax,%eax
  8016d0:	78 10                	js     8016e2 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8016d2:	83 ec 08             	sub    $0x8,%esp
  8016d5:	6a 01                	push   $0x1
  8016d7:	ff 75 f4             	pushl  -0xc(%ebp)
  8016da:	e8 54 ff ff ff       	call   801633 <fd_close>
  8016df:	83 c4 10             	add    $0x10,%esp
}
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <close_all>:

void
close_all(void)
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
  8016e7:	53                   	push   %ebx
  8016e8:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8016eb:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8016f0:	83 ec 0c             	sub    $0xc,%esp
  8016f3:	53                   	push   %ebx
  8016f4:	e8 c0 ff ff ff       	call   8016b9 <close>
	for (i = 0; i < MAXFD; i++)
  8016f9:	43                   	inc    %ebx
  8016fa:	83 c4 10             	add    $0x10,%esp
  8016fd:	83 fb 20             	cmp    $0x20,%ebx
  801700:	75 ee                	jne    8016f0 <close_all+0xc>
}
  801702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801705:	c9                   	leave  
  801706:	c3                   	ret    

00801707 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801707:	55                   	push   %ebp
  801708:	89 e5                	mov    %esp,%ebp
  80170a:	57                   	push   %edi
  80170b:	56                   	push   %esi
  80170c:	53                   	push   %ebx
  80170d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801710:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801713:	50                   	push   %eax
  801714:	ff 75 08             	pushl  0x8(%ebp)
  801717:	e8 6a fe ff ff       	call   801586 <fd_lookup>
  80171c:	89 c3                	mov    %eax,%ebx
  80171e:	83 c4 08             	add    $0x8,%esp
  801721:	85 c0                	test   %eax,%eax
  801723:	0f 88 81 00 00 00    	js     8017aa <dup+0xa3>
		return r;
	close(newfdnum);
  801729:	83 ec 0c             	sub    $0xc,%esp
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	e8 85 ff ff ff       	call   8016b9 <close>

	newfd = INDEX2FD(newfdnum);
  801734:	8b 75 0c             	mov    0xc(%ebp),%esi
  801737:	c1 e6 0c             	shl    $0xc,%esi
  80173a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801740:	83 c4 04             	add    $0x4,%esp
  801743:	ff 75 e4             	pushl  -0x1c(%ebp)
  801746:	e8 d5 fd ff ff       	call   801520 <fd2data>
  80174b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80174d:	89 34 24             	mov    %esi,(%esp)
  801750:	e8 cb fd ff ff       	call   801520 <fd2data>
  801755:	83 c4 10             	add    $0x10,%esp
  801758:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80175a:	89 d8                	mov    %ebx,%eax
  80175c:	c1 e8 16             	shr    $0x16,%eax
  80175f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801766:	a8 01                	test   $0x1,%al
  801768:	74 11                	je     80177b <dup+0x74>
  80176a:	89 d8                	mov    %ebx,%eax
  80176c:	c1 e8 0c             	shr    $0xc,%eax
  80176f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801776:	f6 c2 01             	test   $0x1,%dl
  801779:	75 39                	jne    8017b4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80177b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80177e:	89 d0                	mov    %edx,%eax
  801780:	c1 e8 0c             	shr    $0xc,%eax
  801783:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80178a:	83 ec 0c             	sub    $0xc,%esp
  80178d:	25 07 0e 00 00       	and    $0xe07,%eax
  801792:	50                   	push   %eax
  801793:	56                   	push   %esi
  801794:	6a 00                	push   $0x0
  801796:	52                   	push   %edx
  801797:	6a 00                	push   $0x0
  801799:	e8 7b f8 ff ff       	call   801019 <sys_page_map>
  80179e:	89 c3                	mov    %eax,%ebx
  8017a0:	83 c4 20             	add    $0x20,%esp
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	78 31                	js     8017d8 <dup+0xd1>
		goto err;

	return newfdnum;
  8017a7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8017aa:	89 d8                	mov    %ebx,%eax
  8017ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017af:	5b                   	pop    %ebx
  8017b0:	5e                   	pop    %esi
  8017b1:	5f                   	pop    %edi
  8017b2:	5d                   	pop    %ebp
  8017b3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8017b4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017bb:	83 ec 0c             	sub    $0xc,%esp
  8017be:	25 07 0e 00 00       	and    $0xe07,%eax
  8017c3:	50                   	push   %eax
  8017c4:	57                   	push   %edi
  8017c5:	6a 00                	push   $0x0
  8017c7:	53                   	push   %ebx
  8017c8:	6a 00                	push   $0x0
  8017ca:	e8 4a f8 ff ff       	call   801019 <sys_page_map>
  8017cf:	89 c3                	mov    %eax,%ebx
  8017d1:	83 c4 20             	add    $0x20,%esp
  8017d4:	85 c0                	test   %eax,%eax
  8017d6:	79 a3                	jns    80177b <dup+0x74>
	sys_page_unmap(0, newfd);
  8017d8:	83 ec 08             	sub    $0x8,%esp
  8017db:	56                   	push   %esi
  8017dc:	6a 00                	push   $0x0
  8017de:	e8 78 f8 ff ff       	call   80105b <sys_page_unmap>
	sys_page_unmap(0, nva);
  8017e3:	83 c4 08             	add    $0x8,%esp
  8017e6:	57                   	push   %edi
  8017e7:	6a 00                	push   $0x0
  8017e9:	e8 6d f8 ff ff       	call   80105b <sys_page_unmap>
	return r;
  8017ee:	83 c4 10             	add    $0x10,%esp
  8017f1:	eb b7                	jmp    8017aa <dup+0xa3>

008017f3 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	53                   	push   %ebx
  8017f7:	83 ec 14             	sub    $0x14,%esp
  8017fa:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8017fd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801800:	50                   	push   %eax
  801801:	53                   	push   %ebx
  801802:	e8 7f fd ff ff       	call   801586 <fd_lookup>
  801807:	83 c4 08             	add    $0x8,%esp
  80180a:	85 c0                	test   %eax,%eax
  80180c:	78 3f                	js     80184d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80180e:	83 ec 08             	sub    $0x8,%esp
  801811:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801814:	50                   	push   %eax
  801815:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801818:	ff 30                	pushl  (%eax)
  80181a:	e8 be fd ff ff       	call   8015dd <dev_lookup>
  80181f:	83 c4 10             	add    $0x10,%esp
  801822:	85 c0                	test   %eax,%eax
  801824:	78 27                	js     80184d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801826:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801829:	8b 42 08             	mov    0x8(%edx),%eax
  80182c:	83 e0 03             	and    $0x3,%eax
  80182f:	83 f8 01             	cmp    $0x1,%eax
  801832:	74 1e                	je     801852 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  801834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801837:	8b 40 08             	mov    0x8(%eax),%eax
  80183a:	85 c0                	test   %eax,%eax
  80183c:	74 35                	je     801873 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80183e:	83 ec 04             	sub    $0x4,%esp
  801841:	ff 75 10             	pushl  0x10(%ebp)
  801844:	ff 75 0c             	pushl  0xc(%ebp)
  801847:	52                   	push   %edx
  801848:	ff d0                	call   *%eax
  80184a:	83 c4 10             	add    $0x10,%esp
}
  80184d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801850:	c9                   	leave  
  801851:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  801852:	a1 04 50 80 00       	mov    0x805004,%eax
  801857:	8b 40 48             	mov    0x48(%eax),%eax
  80185a:	83 ec 04             	sub    $0x4,%esp
  80185d:	53                   	push   %ebx
  80185e:	50                   	push   %eax
  80185f:	68 ad 30 80 00       	push   $0x8030ad
  801864:	e8 b0 ed ff ff       	call   800619 <cprintf>
		return -E_INVAL;
  801869:	83 c4 10             	add    $0x10,%esp
  80186c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801871:	eb da                	jmp    80184d <read+0x5a>
		return -E_NOT_SUPP;
  801873:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801878:	eb d3                	jmp    80184d <read+0x5a>

0080187a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	57                   	push   %edi
  80187e:	56                   	push   %esi
  80187f:	53                   	push   %ebx
  801880:	83 ec 0c             	sub    $0xc,%esp
  801883:	8b 7d 08             	mov    0x8(%ebp),%edi
  801886:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801889:	bb 00 00 00 00       	mov    $0x0,%ebx
  80188e:	39 f3                	cmp    %esi,%ebx
  801890:	73 25                	jae    8018b7 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801892:	83 ec 04             	sub    $0x4,%esp
  801895:	89 f0                	mov    %esi,%eax
  801897:	29 d8                	sub    %ebx,%eax
  801899:	50                   	push   %eax
  80189a:	89 d8                	mov    %ebx,%eax
  80189c:	03 45 0c             	add    0xc(%ebp),%eax
  80189f:	50                   	push   %eax
  8018a0:	57                   	push   %edi
  8018a1:	e8 4d ff ff ff       	call   8017f3 <read>
		if (m < 0)
  8018a6:	83 c4 10             	add    $0x10,%esp
  8018a9:	85 c0                	test   %eax,%eax
  8018ab:	78 08                	js     8018b5 <readn+0x3b>
			return m;
		if (m == 0)
  8018ad:	85 c0                	test   %eax,%eax
  8018af:	74 06                	je     8018b7 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8018b1:	01 c3                	add    %eax,%ebx
  8018b3:	eb d9                	jmp    80188e <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018b5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8018b7:	89 d8                	mov    %ebx,%eax
  8018b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018bc:	5b                   	pop    %ebx
  8018bd:	5e                   	pop    %esi
  8018be:	5f                   	pop    %edi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    

008018c1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8018c1:	55                   	push   %ebp
  8018c2:	89 e5                	mov    %esp,%ebp
  8018c4:	53                   	push   %ebx
  8018c5:	83 ec 14             	sub    $0x14,%esp
  8018c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8018cb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8018ce:	50                   	push   %eax
  8018cf:	53                   	push   %ebx
  8018d0:	e8 b1 fc ff ff       	call   801586 <fd_lookup>
  8018d5:	83 c4 08             	add    $0x8,%esp
  8018d8:	85 c0                	test   %eax,%eax
  8018da:	78 3a                	js     801916 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8018dc:	83 ec 08             	sub    $0x8,%esp
  8018df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8018e2:	50                   	push   %eax
  8018e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018e6:	ff 30                	pushl  (%eax)
  8018e8:	e8 f0 fc ff ff       	call   8015dd <dev_lookup>
  8018ed:	83 c4 10             	add    $0x10,%esp
  8018f0:	85 c0                	test   %eax,%eax
  8018f2:	78 22                	js     801916 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8018f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f7:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8018fb:	74 1e                	je     80191b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8018fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801900:	8b 52 0c             	mov    0xc(%edx),%edx
  801903:	85 d2                	test   %edx,%edx
  801905:	74 35                	je     80193c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801907:	83 ec 04             	sub    $0x4,%esp
  80190a:	ff 75 10             	pushl  0x10(%ebp)
  80190d:	ff 75 0c             	pushl  0xc(%ebp)
  801910:	50                   	push   %eax
  801911:	ff d2                	call   *%edx
  801913:	83 c4 10             	add    $0x10,%esp
}
  801916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801919:	c9                   	leave  
  80191a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80191b:	a1 04 50 80 00       	mov    0x805004,%eax
  801920:	8b 40 48             	mov    0x48(%eax),%eax
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	53                   	push   %ebx
  801927:	50                   	push   %eax
  801928:	68 c9 30 80 00       	push   $0x8030c9
  80192d:	e8 e7 ec ff ff       	call   800619 <cprintf>
		return -E_INVAL;
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80193a:	eb da                	jmp    801916 <write+0x55>
		return -E_NOT_SUPP;
  80193c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801941:	eb d3                	jmp    801916 <write+0x55>

00801943 <seek>:

int
seek(int fdnum, off_t offset)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
  801946:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801949:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	ff 75 08             	pushl  0x8(%ebp)
  801950:	e8 31 fc ff ff       	call   801586 <fd_lookup>
  801955:	83 c4 08             	add    $0x8,%esp
  801958:	85 c0                	test   %eax,%eax
  80195a:	78 0e                	js     80196a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80195c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80195f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801962:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  801965:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	53                   	push   %ebx
  801970:	83 ec 14             	sub    $0x14,%esp
  801973:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  801976:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801979:	50                   	push   %eax
  80197a:	53                   	push   %ebx
  80197b:	e8 06 fc ff ff       	call   801586 <fd_lookup>
  801980:	83 c4 08             	add    $0x8,%esp
  801983:	85 c0                	test   %eax,%eax
  801985:	78 37                	js     8019be <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801987:	83 ec 08             	sub    $0x8,%esp
  80198a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80198d:	50                   	push   %eax
  80198e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801991:	ff 30                	pushl  (%eax)
  801993:	e8 45 fc ff ff       	call   8015dd <dev_lookup>
  801998:	83 c4 10             	add    $0x10,%esp
  80199b:	85 c0                	test   %eax,%eax
  80199d:	78 1f                	js     8019be <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80199f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8019a6:	74 1b                	je     8019c3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8019a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8019ab:	8b 52 18             	mov    0x18(%edx),%edx
  8019ae:	85 d2                	test   %edx,%edx
  8019b0:	74 32                	je     8019e4 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8019b2:	83 ec 08             	sub    $0x8,%esp
  8019b5:	ff 75 0c             	pushl  0xc(%ebp)
  8019b8:	50                   	push   %eax
  8019b9:	ff d2                	call   *%edx
  8019bb:	83 c4 10             	add    $0x10,%esp
}
  8019be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8019c3:	a1 04 50 80 00       	mov    0x805004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8019c8:	8b 40 48             	mov    0x48(%eax),%eax
  8019cb:	83 ec 04             	sub    $0x4,%esp
  8019ce:	53                   	push   %ebx
  8019cf:	50                   	push   %eax
  8019d0:	68 8c 30 80 00       	push   $0x80308c
  8019d5:	e8 3f ec ff ff       	call   800619 <cprintf>
		return -E_INVAL;
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019e2:	eb da                	jmp    8019be <ftruncate+0x52>
		return -E_NOT_SUPP;
  8019e4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019e9:	eb d3                	jmp    8019be <ftruncate+0x52>

008019eb <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
  8019ee:	53                   	push   %ebx
  8019ef:	83 ec 14             	sub    $0x14,%esp
  8019f2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019f5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019f8:	50                   	push   %eax
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 85 fb ff ff       	call   801586 <fd_lookup>
  801a01:	83 c4 08             	add    $0x8,%esp
  801a04:	85 c0                	test   %eax,%eax
  801a06:	78 4b                	js     801a53 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a08:	83 ec 08             	sub    $0x8,%esp
  801a0b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a0e:	50                   	push   %eax
  801a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a12:	ff 30                	pushl  (%eax)
  801a14:	e8 c4 fb ff ff       	call   8015dd <dev_lookup>
  801a19:	83 c4 10             	add    $0x10,%esp
  801a1c:	85 c0                	test   %eax,%eax
  801a1e:	78 33                	js     801a53 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a23:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a27:	74 2f                	je     801a58 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a29:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a2c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a33:	00 00 00 
	stat->st_type = 0;
  801a36:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801a3d:	00 00 00 
	stat->st_dev = dev;
  801a40:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801a46:	83 ec 08             	sub    $0x8,%esp
  801a49:	53                   	push   %ebx
  801a4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801a4d:	ff 50 14             	call   *0x14(%eax)
  801a50:	83 c4 10             	add    $0x10,%esp
}
  801a53:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    
		return -E_NOT_SUPP;
  801a58:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a5d:	eb f4                	jmp    801a53 <fstat+0x68>

00801a5f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	56                   	push   %esi
  801a63:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801a64:	83 ec 08             	sub    $0x8,%esp
  801a67:	6a 00                	push   $0x0
  801a69:	ff 75 08             	pushl  0x8(%ebp)
  801a6c:	e8 34 02 00 00       	call   801ca5 <open>
  801a71:	89 c3                	mov    %eax,%ebx
  801a73:	83 c4 10             	add    $0x10,%esp
  801a76:	85 c0                	test   %eax,%eax
  801a78:	78 1b                	js     801a95 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801a7a:	83 ec 08             	sub    $0x8,%esp
  801a7d:	ff 75 0c             	pushl  0xc(%ebp)
  801a80:	50                   	push   %eax
  801a81:	e8 65 ff ff ff       	call   8019eb <fstat>
  801a86:	89 c6                	mov    %eax,%esi
	close(fd);
  801a88:	89 1c 24             	mov    %ebx,(%esp)
  801a8b:	e8 29 fc ff ff       	call   8016b9 <close>
	return r;
  801a90:	83 c4 10             	add    $0x10,%esp
  801a93:	89 f3                	mov    %esi,%ebx
}
  801a95:	89 d8                	mov    %ebx,%eax
  801a97:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a9a:	5b                   	pop    %ebx
  801a9b:	5e                   	pop    %esi
  801a9c:	5d                   	pop    %ebp
  801a9d:	c3                   	ret    

00801a9e <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801a9e:	55                   	push   %ebp
  801a9f:	89 e5                	mov    %esp,%ebp
  801aa1:	56                   	push   %esi
  801aa2:	53                   	push   %ebx
  801aa3:	89 c6                	mov    %eax,%esi
  801aa5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801aa7:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  801aae:	74 27                	je     801ad7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801ab0:	6a 07                	push   $0x7
  801ab2:	68 00 60 80 00       	push   $0x806000
  801ab7:	56                   	push   %esi
  801ab8:	ff 35 00 50 80 00    	pushl  0x805000
  801abe:	e8 ff 0c 00 00       	call   8027c2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801ac3:	83 c4 0c             	add    $0xc,%esp
  801ac6:	6a 00                	push   $0x0
  801ac8:	53                   	push   %ebx
  801ac9:	6a 00                	push   $0x0
  801acb:	e8 69 0c 00 00       	call   802739 <ipc_recv>
}
  801ad0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ad3:	5b                   	pop    %ebx
  801ad4:	5e                   	pop    %esi
  801ad5:	5d                   	pop    %ebp
  801ad6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801ad7:	83 ec 0c             	sub    $0xc,%esp
  801ada:	6a 01                	push   $0x1
  801adc:	e8 3d 0d 00 00       	call   80281e <ipc_find_env>
  801ae1:	a3 00 50 80 00       	mov    %eax,0x805000
  801ae6:	83 c4 10             	add    $0x10,%esp
  801ae9:	eb c5                	jmp    801ab0 <fsipc+0x12>

00801aeb <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801aeb:	55                   	push   %ebp
  801aec:	89 e5                	mov    %esp,%ebp
  801aee:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801af1:	8b 45 08             	mov    0x8(%ebp),%eax
  801af4:	8b 40 0c             	mov    0xc(%eax),%eax
  801af7:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  801afc:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aff:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b04:	ba 00 00 00 00       	mov    $0x0,%edx
  801b09:	b8 02 00 00 00       	mov    $0x2,%eax
  801b0e:	e8 8b ff ff ff       	call   801a9e <fsipc>
}
  801b13:	c9                   	leave  
  801b14:	c3                   	ret    

00801b15 <devfile_flush>:
{
  801b15:	55                   	push   %ebp
  801b16:	89 e5                	mov    %esp,%ebp
  801b18:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b21:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  801b26:	ba 00 00 00 00       	mov    $0x0,%edx
  801b2b:	b8 06 00 00 00       	mov    $0x6,%eax
  801b30:	e8 69 ff ff ff       	call   801a9e <fsipc>
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <devfile_stat>:
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
  801b3a:	53                   	push   %ebx
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801b41:	8b 45 08             	mov    0x8(%ebp),%eax
  801b44:	8b 40 0c             	mov    0xc(%eax),%eax
  801b47:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801b4c:	ba 00 00 00 00       	mov    $0x0,%edx
  801b51:	b8 05 00 00 00       	mov    $0x5,%eax
  801b56:	e8 43 ff ff ff       	call   801a9e <fsipc>
  801b5b:	85 c0                	test   %eax,%eax
  801b5d:	78 2c                	js     801b8b <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801b5f:	83 ec 08             	sub    $0x8,%esp
  801b62:	68 00 60 80 00       	push   $0x806000
  801b67:	53                   	push   %ebx
  801b68:	e8 b4 f0 ff ff       	call   800c21 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801b6d:	a1 80 60 80 00       	mov    0x806080,%eax
  801b72:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801b78:	a1 84 60 80 00       	mov    0x806084,%eax
  801b7d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801b83:	83 c4 10             	add    $0x10,%esp
  801b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b8b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <devfile_write>:
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	53                   	push   %ebx
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801b9a:	89 d8                	mov    %ebx,%eax
  801b9c:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801ba2:	76 05                	jbe    801ba9 <devfile_write+0x19>
  801ba4:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  801bac:	8b 52 0c             	mov    0xc(%edx),%edx
  801baf:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = size;
  801bb5:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801bba:	83 ec 04             	sub    $0x4,%esp
  801bbd:	50                   	push   %eax
  801bbe:	ff 75 0c             	pushl  0xc(%ebp)
  801bc1:	68 08 60 80 00       	push   $0x806008
  801bc6:	e8 c9 f1 ff ff       	call   800d94 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801bcb:	ba 00 00 00 00       	mov    $0x0,%edx
  801bd0:	b8 04 00 00 00       	mov    $0x4,%eax
  801bd5:	e8 c4 fe ff ff       	call   801a9e <fsipc>
  801bda:	83 c4 10             	add    $0x10,%esp
  801bdd:	85 c0                	test   %eax,%eax
  801bdf:	78 0b                	js     801bec <devfile_write+0x5c>
	assert(r <= n);
  801be1:	39 c3                	cmp    %eax,%ebx
  801be3:	72 0c                	jb     801bf1 <devfile_write+0x61>
	assert(r <= PGSIZE);
  801be5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801bea:	7f 1e                	jg     801c0a <devfile_write+0x7a>
}
  801bec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    
	assert(r <= n);
  801bf1:	68 f8 30 80 00       	push   $0x8030f8
  801bf6:	68 36 30 80 00       	push   $0x803036
  801bfb:	68 98 00 00 00       	push   $0x98
  801c00:	68 ff 30 80 00       	push   $0x8030ff
  801c05:	e8 fc e8 ff ff       	call   800506 <_panic>
	assert(r <= PGSIZE);
  801c0a:	68 0a 31 80 00       	push   $0x80310a
  801c0f:	68 36 30 80 00       	push   $0x803036
  801c14:	68 99 00 00 00       	push   $0x99
  801c19:	68 ff 30 80 00       	push   $0x8030ff
  801c1e:	e8 e3 e8 ff ff       	call   800506 <_panic>

00801c23 <devfile_read>:
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
  801c26:	56                   	push   %esi
  801c27:	53                   	push   %ebx
  801c28:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2e:	8b 40 0c             	mov    0xc(%eax),%eax
  801c31:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  801c36:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801c3c:	ba 00 00 00 00       	mov    $0x0,%edx
  801c41:	b8 03 00 00 00       	mov    $0x3,%eax
  801c46:	e8 53 fe ff ff       	call   801a9e <fsipc>
  801c4b:	89 c3                	mov    %eax,%ebx
  801c4d:	85 c0                	test   %eax,%eax
  801c4f:	78 1f                	js     801c70 <devfile_read+0x4d>
	assert(r <= n);
  801c51:	39 c6                	cmp    %eax,%esi
  801c53:	72 24                	jb     801c79 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801c55:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c5a:	7f 33                	jg     801c8f <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	50                   	push   %eax
  801c60:	68 00 60 80 00       	push   $0x806000
  801c65:	ff 75 0c             	pushl  0xc(%ebp)
  801c68:	e8 27 f1 ff ff       	call   800d94 <memmove>
	return r;
  801c6d:	83 c4 10             	add    $0x10,%esp
}
  801c70:	89 d8                	mov    %ebx,%eax
  801c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c75:	5b                   	pop    %ebx
  801c76:	5e                   	pop    %esi
  801c77:	5d                   	pop    %ebp
  801c78:	c3                   	ret    
	assert(r <= n);
  801c79:	68 f8 30 80 00       	push   $0x8030f8
  801c7e:	68 36 30 80 00       	push   $0x803036
  801c83:	6a 7c                	push   $0x7c
  801c85:	68 ff 30 80 00       	push   $0x8030ff
  801c8a:	e8 77 e8 ff ff       	call   800506 <_panic>
	assert(r <= PGSIZE);
  801c8f:	68 0a 31 80 00       	push   $0x80310a
  801c94:	68 36 30 80 00       	push   $0x803036
  801c99:	6a 7d                	push   $0x7d
  801c9b:	68 ff 30 80 00       	push   $0x8030ff
  801ca0:	e8 61 e8 ff ff       	call   800506 <_panic>

00801ca5 <open>:
{
  801ca5:	55                   	push   %ebp
  801ca6:	89 e5                	mov    %esp,%ebp
  801ca8:	56                   	push   %esi
  801ca9:	53                   	push   %ebx
  801caa:	83 ec 1c             	sub    $0x1c,%esp
  801cad:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801cb0:	56                   	push   %esi
  801cb1:	e8 38 ef ff ff       	call   800bee <strlen>
  801cb6:	83 c4 10             	add    $0x10,%esp
  801cb9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801cbe:	7f 6c                	jg     801d2c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801cc0:	83 ec 0c             	sub    $0xc,%esp
  801cc3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801cc6:	50                   	push   %eax
  801cc7:	e8 6b f8 ff ff       	call   801537 <fd_alloc>
  801ccc:	89 c3                	mov    %eax,%ebx
  801cce:	83 c4 10             	add    $0x10,%esp
  801cd1:	85 c0                	test   %eax,%eax
  801cd3:	78 3c                	js     801d11 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801cd5:	83 ec 08             	sub    $0x8,%esp
  801cd8:	56                   	push   %esi
  801cd9:	68 00 60 80 00       	push   $0x806000
  801cde:	e8 3e ef ff ff       	call   800c21 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ce6:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801ceb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801cee:	b8 01 00 00 00       	mov    $0x1,%eax
  801cf3:	e8 a6 fd ff ff       	call   801a9e <fsipc>
  801cf8:	89 c3                	mov    %eax,%ebx
  801cfa:	83 c4 10             	add    $0x10,%esp
  801cfd:	85 c0                	test   %eax,%eax
  801cff:	78 19                	js     801d1a <open+0x75>
	return fd2num(fd);
  801d01:	83 ec 0c             	sub    $0xc,%esp
  801d04:	ff 75 f4             	pushl  -0xc(%ebp)
  801d07:	e8 04 f8 ff ff       	call   801510 <fd2num>
  801d0c:	89 c3                	mov    %eax,%ebx
  801d0e:	83 c4 10             	add    $0x10,%esp
}
  801d11:	89 d8                	mov    %ebx,%eax
  801d13:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d16:	5b                   	pop    %ebx
  801d17:	5e                   	pop    %esi
  801d18:	5d                   	pop    %ebp
  801d19:	c3                   	ret    
		fd_close(fd, 0);
  801d1a:	83 ec 08             	sub    $0x8,%esp
  801d1d:	6a 00                	push   $0x0
  801d1f:	ff 75 f4             	pushl  -0xc(%ebp)
  801d22:	e8 0c f9 ff ff       	call   801633 <fd_close>
		return r;
  801d27:	83 c4 10             	add    $0x10,%esp
  801d2a:	eb e5                	jmp    801d11 <open+0x6c>
		return -E_BAD_PATH;
  801d2c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d31:	eb de                	jmp    801d11 <open+0x6c>

00801d33 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801d39:	ba 00 00 00 00       	mov    $0x0,%edx
  801d3e:	b8 08 00 00 00       	mov    $0x8,%eax
  801d43:	e8 56 fd ff ff       	call   801a9e <fsipc>
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	57                   	push   %edi
  801d4e:	56                   	push   %esi
  801d4f:	53                   	push   %ebx
  801d50:	81 ec 94 02 00 00    	sub    $0x294,%esp
  801d56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  801d59:	6a 00                	push   $0x0
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	e8 42 ff ff ff       	call   801ca5 <open>
  801d63:	89 c1                	mov    %eax,%ecx
  801d65:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  801d6b:	83 c4 10             	add    $0x10,%esp
  801d6e:	85 c0                	test   %eax,%eax
  801d70:	0f 88 ba 04 00 00    	js     802230 <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  801d76:	83 ec 04             	sub    $0x4,%esp
  801d79:	68 00 02 00 00       	push   $0x200
  801d7e:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801d84:	50                   	push   %eax
  801d85:	51                   	push   %ecx
  801d86:	e8 ef fa ff ff       	call   80187a <readn>
  801d8b:	83 c4 10             	add    $0x10,%esp
  801d8e:	3d 00 02 00 00       	cmp    $0x200,%eax
  801d93:	0f 85 93 00 00 00    	jne    801e2c <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  801d99:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801da0:	45 4c 46 
  801da3:	0f 85 83 00 00 00    	jne    801e2c <spawn+0xe2>
  801da9:	b8 07 00 00 00       	mov    $0x7,%eax
  801dae:	cd 30                	int    $0x30
  801db0:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801db6:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801dbc:	85 c0                	test   %eax,%eax
  801dbe:	0f 88 77 04 00 00    	js     80223b <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801dc4:	89 c2                	mov    %eax,%edx
  801dc6:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801dcc:	89 d0                	mov    %edx,%eax
  801dce:	c1 e0 05             	shl    $0x5,%eax
  801dd1:	29 d0                	sub    %edx,%eax
  801dd3:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  801dda:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801de0:	b9 11 00 00 00       	mov    $0x11,%ecx
  801de5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801de7:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801ded:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801df3:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  801dfd:	bf 00 00 00 00       	mov    $0x0,%edi
  801e02:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801e05:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801e07:	89 d9                	mov    %ebx,%ecx
  801e09:	8d 72 04             	lea    0x4(%edx),%esi
  801e0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e0f:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  801e13:	85 c0                	test   %eax,%eax
  801e15:	74 48                	je     801e5f <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  801e17:	83 ec 0c             	sub    $0xc,%esp
  801e1a:	50                   	push   %eax
  801e1b:	e8 ce ed ff ff       	call   800bee <strlen>
  801e20:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801e24:	43                   	inc    %ebx
  801e25:	83 c4 10             	add    $0x10,%esp
  801e28:	89 f2                	mov    %esi,%edx
  801e2a:	eb db                	jmp    801e07 <spawn+0xbd>
		close(fd);
  801e2c:	83 ec 0c             	sub    $0xc,%esp
  801e2f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801e35:	e8 7f f8 ff ff       	call   8016b9 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801e3a:	83 c4 0c             	add    $0xc,%esp
  801e3d:	68 7f 45 4c 46       	push   $0x464c457f
  801e42:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801e48:	68 16 31 80 00       	push   $0x803116
  801e4d:	e8 c7 e7 ff ff       	call   800619 <cprintf>
		return -E_NOT_EXEC;
  801e52:	83 c4 10             	add    $0x10,%esp
  801e55:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  801e5a:	e9 62 02 00 00       	jmp    8020c1 <spawn+0x377>
  801e5f:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801e65:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801e6b:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801e71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801e74:	be 00 10 40 00       	mov    $0x401000,%esi
  801e79:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801e7b:	89 f2                	mov    %esi,%edx
  801e7d:	83 e2 fc             	and    $0xfffffffc,%edx
  801e80:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  801e87:	29 c2                	sub    %eax,%edx
  801e89:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801e8f:	8d 42 f8             	lea    -0x8(%edx),%eax
  801e92:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801e97:	0f 86 a9 03 00 00    	jbe    802246 <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801e9d:	83 ec 04             	sub    $0x4,%esp
  801ea0:	6a 07                	push   $0x7
  801ea2:	68 00 00 40 00       	push   $0x400000
  801ea7:	6a 00                	push   $0x0
  801ea9:	e8 28 f1 ff ff       	call   800fd6 <sys_page_alloc>
  801eae:	89 c7                	mov    %eax,%edi
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	85 c0                	test   %eax,%eax
  801eb5:	0f 88 06 02 00 00    	js     8020c1 <spawn+0x377>
  801ebb:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801ec0:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801ec6:	7e 30                	jle    801ef8 <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  801ec8:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  801ece:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801ed4:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  801ed7:	83 ec 08             	sub    $0x8,%esp
  801eda:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801edd:	56                   	push   %esi
  801ede:	e8 3e ed ff ff       	call   800c21 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801ee3:	83 c4 04             	add    $0x4,%esp
  801ee6:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801ee9:	e8 00 ed ff ff       	call   800bee <strlen>
  801eee:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  801ef2:	47                   	inc    %edi
  801ef3:	83 c4 10             	add    $0x10,%esp
  801ef6:	eb c8                	jmp    801ec0 <spawn+0x176>
	}
	argv_store[argc] = 0;
  801ef8:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801efe:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801f04:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801f0b:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  801f11:	0f 85 8c 00 00 00    	jne    801fa3 <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801f17:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801f1d:	89 c8                	mov    %ecx,%eax
  801f1f:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801f24:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801f27:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801f2d:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801f30:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801f36:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801f3c:	83 ec 0c             	sub    $0xc,%esp
  801f3f:	6a 07                	push   $0x7
  801f41:	68 00 d0 bf ee       	push   $0xeebfd000
  801f46:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f4c:	68 00 00 40 00       	push   $0x400000
  801f51:	6a 00                	push   $0x0
  801f53:	e8 c1 f0 ff ff       	call   801019 <sys_page_map>
  801f58:	89 c7                	mov    %eax,%edi
  801f5a:	83 c4 20             	add    $0x20,%esp
  801f5d:	85 c0                	test   %eax,%eax
  801f5f:	0f 88 3e 03 00 00    	js     8022a3 <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801f65:	83 ec 08             	sub    $0x8,%esp
  801f68:	68 00 00 40 00       	push   $0x400000
  801f6d:	6a 00                	push   $0x0
  801f6f:	e8 e7 f0 ff ff       	call   80105b <sys_page_unmap>
  801f74:	89 c7                	mov    %eax,%edi
  801f76:	83 c4 10             	add    $0x10,%esp
  801f79:	85 c0                	test   %eax,%eax
  801f7b:	0f 88 22 03 00 00    	js     8022a3 <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801f81:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801f87:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801f8e:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801f94:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801f9b:	00 00 00 
  801f9e:	e9 4a 01 00 00       	jmp    8020ed <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801fa3:	68 a0 31 80 00       	push   $0x8031a0
  801fa8:	68 36 30 80 00       	push   $0x803036
  801fad:	68 f1 00 00 00       	push   $0xf1
  801fb2:	68 30 31 80 00       	push   $0x803130
  801fb7:	e8 4a e5 ff ff       	call   800506 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801fbc:	83 ec 04             	sub    $0x4,%esp
  801fbf:	6a 07                	push   $0x7
  801fc1:	68 00 00 40 00       	push   $0x400000
  801fc6:	6a 00                	push   $0x0
  801fc8:	e8 09 f0 ff ff       	call   800fd6 <sys_page_alloc>
  801fcd:	83 c4 10             	add    $0x10,%esp
  801fd0:	85 c0                	test   %eax,%eax
  801fd2:	0f 88 78 02 00 00    	js     802250 <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801fd8:	83 ec 08             	sub    $0x8,%esp
  801fdb:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801fe1:	01 f8                	add    %edi,%eax
  801fe3:	50                   	push   %eax
  801fe4:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801fea:	e8 54 f9 ff ff       	call   801943 <seek>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	85 c0                	test   %eax,%eax
  801ff4:	0f 88 5d 02 00 00    	js     802257 <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  802003:	29 f8                	sub    %edi,%eax
  802005:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80200a:	76 05                	jbe    802011 <spawn+0x2c7>
  80200c:	b8 00 10 00 00       	mov    $0x1000,%eax
  802011:	50                   	push   %eax
  802012:	68 00 00 40 00       	push   $0x400000
  802017:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80201d:	e8 58 f8 ff ff       	call   80187a <readn>
  802022:	83 c4 10             	add    $0x10,%esp
  802025:	85 c0                	test   %eax,%eax
  802027:	0f 88 31 02 00 00    	js     80225e <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  80202d:	83 ec 0c             	sub    $0xc,%esp
  802030:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802036:	56                   	push   %esi
  802037:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80203d:	68 00 00 40 00       	push   $0x400000
  802042:	6a 00                	push   $0x0
  802044:	e8 d0 ef ff ff       	call   801019 <sys_page_map>
  802049:	83 c4 20             	add    $0x20,%esp
  80204c:	85 c0                	test   %eax,%eax
  80204e:	78 7b                	js     8020cb <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802050:	83 ec 08             	sub    $0x8,%esp
  802053:	68 00 00 40 00       	push   $0x400000
  802058:	6a 00                	push   $0x0
  80205a:	e8 fc ef ff ff       	call   80105b <sys_page_unmap>
  80205f:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  802062:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802068:	81 c6 00 10 00 00    	add    $0x1000,%esi
  80206e:	89 df                	mov    %ebx,%edi
  802070:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  802076:	73 68                	jae    8020e0 <spawn+0x396>
		if (i >= filesz) {
  802078:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  80207e:	0f 82 38 ff ff ff    	jb     801fbc <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  802084:	83 ec 04             	sub    $0x4,%esp
  802087:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80208d:	56                   	push   %esi
  80208e:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  802094:	e8 3d ef ff ff       	call   800fd6 <sys_page_alloc>
  802099:	83 c4 10             	add    $0x10,%esp
  80209c:	85 c0                	test   %eax,%eax
  80209e:	79 c2                	jns    802062 <spawn+0x318>
  8020a0:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  8020a2:	83 ec 0c             	sub    $0xc,%esp
  8020a5:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  8020ab:	e8 c6 ee ff ff       	call   800f76 <sys_env_destroy>
	close(fd);
  8020b0:	83 c4 04             	add    $0x4,%esp
  8020b3:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8020b9:	e8 fb f5 ff ff       	call   8016b9 <close>
	return r;
  8020be:	83 c4 10             	add    $0x10,%esp
}
  8020c1:	89 f8                	mov    %edi,%eax
  8020c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020c6:	5b                   	pop    %ebx
  8020c7:	5e                   	pop    %esi
  8020c8:	5f                   	pop    %edi
  8020c9:	5d                   	pop    %ebp
  8020ca:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8020cb:	50                   	push   %eax
  8020cc:	68 3c 31 80 00       	push   $0x80313c
  8020d1:	68 24 01 00 00       	push   $0x124
  8020d6:	68 30 31 80 00       	push   $0x803130
  8020db:	e8 26 e4 ff ff       	call   800506 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8020e0:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  8020e6:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8020ed:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8020f4:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8020fa:	7d 71                	jge    80216d <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  8020fc:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  802102:	83 38 01             	cmpl   $0x1,(%eax)
  802105:	75 d9                	jne    8020e0 <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  802107:	89 c1                	mov    %eax,%ecx
  802109:	8b 40 18             	mov    0x18(%eax),%eax
  80210c:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  80210f:	83 f8 01             	cmp    $0x1,%eax
  802112:	19 c0                	sbb    %eax,%eax
  802114:	83 e0 fe             	and    $0xfffffffe,%eax
  802117:	83 c0 07             	add    $0x7,%eax
  80211a:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802120:	89 c8                	mov    %ecx,%eax
  802122:	8b 49 04             	mov    0x4(%ecx),%ecx
  802125:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  80212b:	8b 50 10             	mov    0x10(%eax),%edx
  80212e:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802134:	8b 78 14             	mov    0x14(%eax),%edi
  802137:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  80213d:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  802140:	89 f0                	mov    %esi,%eax
  802142:	25 ff 0f 00 00       	and    $0xfff,%eax
  802147:	74 1a                	je     802163 <spawn+0x419>
		va -= i;
  802149:	29 c6                	sub    %eax,%esi
		memsz += i;
  80214b:	01 c7                	add    %eax,%edi
  80214d:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  802153:	01 c2                	add    %eax,%edx
  802155:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  80215b:	29 c1                	sub    %eax,%ecx
  80215d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802163:	bb 00 00 00 00       	mov    $0x0,%ebx
  802168:	e9 01 ff ff ff       	jmp    80206e <spawn+0x324>
	close(fd);
  80216d:	83 ec 0c             	sub    $0xc,%esp
  802170:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802176:	e8 3e f5 ff ff       	call   8016b9 <close>
  80217b:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  80217e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802183:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  802189:	eb 12                	jmp    80219d <spawn+0x453>
  80218b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802191:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802197:	0f 84 c8 00 00 00    	je     802265 <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  80219d:	89 d8                	mov    %ebx,%eax
  80219f:	c1 e8 16             	shr    $0x16,%eax
  8021a2:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8021a9:	a8 01                	test   $0x1,%al
  8021ab:	74 de                	je     80218b <spawn+0x441>
  8021ad:	89 d8                	mov    %ebx,%eax
  8021af:	c1 e8 0c             	shr    $0xc,%eax
  8021b2:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021b9:	f6 c2 04             	test   $0x4,%dl
  8021bc:	74 cd                	je     80218b <spawn+0x441>
  8021be:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8021c5:	f6 c6 04             	test   $0x4,%dh
  8021c8:	74 c1                	je     80218b <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  8021ca:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  8021d1:	e8 e1 ed ff ff       	call   800fb7 <sys_getenvid>
  8021d6:	83 ec 0c             	sub    $0xc,%esp
  8021d9:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  8021df:	57                   	push   %edi
  8021e0:	53                   	push   %ebx
  8021e1:	56                   	push   %esi
  8021e2:	53                   	push   %ebx
  8021e3:	50                   	push   %eax
  8021e4:	e8 30 ee ff ff       	call   801019 <sys_page_map>
  8021e9:	83 c4 20             	add    $0x20,%esp
  8021ec:	85 c0                	test   %eax,%eax
  8021ee:	79 9b                	jns    80218b <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  8021f0:	6a ff                	push   $0xffffffff
  8021f2:	68 8a 31 80 00       	push   $0x80318a
  8021f7:	68 82 00 00 00       	push   $0x82
  8021fc:	68 30 31 80 00       	push   $0x803130
  802201:	e8 00 e3 ff ff       	call   800506 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  802206:	50                   	push   %eax
  802207:	68 59 31 80 00       	push   $0x803159
  80220c:	68 85 00 00 00       	push   $0x85
  802211:	68 30 31 80 00       	push   $0x803130
  802216:	e8 eb e2 ff ff       	call   800506 <_panic>
		panic("sys_env_set_status: %e", r);
  80221b:	50                   	push   %eax
  80221c:	68 73 31 80 00       	push   $0x803173
  802221:	68 88 00 00 00       	push   $0x88
  802226:	68 30 31 80 00       	push   $0x803130
  80222b:	e8 d6 e2 ff ff       	call   800506 <_panic>
		return r;
  802230:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  802236:	e9 86 fe ff ff       	jmp    8020c1 <spawn+0x377>
		return r;
  80223b:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  802241:	e9 7b fe ff ff       	jmp    8020c1 <spawn+0x377>
		return -E_NO_MEM;
  802246:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  80224b:	e9 71 fe ff ff       	jmp    8020c1 <spawn+0x377>
  802250:	89 c7                	mov    %eax,%edi
  802252:	e9 4b fe ff ff       	jmp    8020a2 <spawn+0x358>
  802257:	89 c7                	mov    %eax,%edi
  802259:	e9 44 fe ff ff       	jmp    8020a2 <spawn+0x358>
  80225e:	89 c7                	mov    %eax,%edi
  802260:	e9 3d fe ff ff       	jmp    8020a2 <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802265:	83 ec 08             	sub    $0x8,%esp
  802268:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  80226e:	50                   	push   %eax
  80226f:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802275:	e8 c5 ee ff ff       	call   80113f <sys_env_set_trapframe>
  80227a:	83 c4 10             	add    $0x10,%esp
  80227d:	85 c0                	test   %eax,%eax
  80227f:	78 85                	js     802206 <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802281:	83 ec 08             	sub    $0x8,%esp
  802284:	6a 02                	push   $0x2
  802286:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  80228c:	e8 2b ee ff ff       	call   8010bc <sys_env_set_status>
  802291:	83 c4 10             	add    $0x10,%esp
  802294:	85 c0                	test   %eax,%eax
  802296:	78 83                	js     80221b <spawn+0x4d1>
	return child;
  802298:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  80229e:	e9 1e fe ff ff       	jmp    8020c1 <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  8022a3:	83 ec 08             	sub    $0x8,%esp
  8022a6:	68 00 00 40 00       	push   $0x400000
  8022ab:	6a 00                	push   $0x0
  8022ad:	e8 a9 ed ff ff       	call   80105b <sys_page_unmap>
  8022b2:	83 c4 10             	add    $0x10,%esp
  8022b5:	e9 07 fe ff ff       	jmp    8020c1 <spawn+0x377>

008022ba <spawnl>:
{
  8022ba:	55                   	push   %ebp
  8022bb:	89 e5                	mov    %esp,%ebp
  8022bd:	57                   	push   %edi
  8022be:	56                   	push   %esi
  8022bf:	53                   	push   %ebx
  8022c0:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  8022c3:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  8022c6:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  8022cb:	eb 03                	jmp    8022d0 <spawnl+0x16>
		argc++;
  8022cd:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  8022ce:	89 ca                	mov    %ecx,%edx
  8022d0:	8d 4a 04             	lea    0x4(%edx),%ecx
  8022d3:	83 3a 00             	cmpl   $0x0,(%edx)
  8022d6:	75 f5                	jne    8022cd <spawnl+0x13>
	const char *argv[argc+2];
  8022d8:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  8022df:	83 e2 f0             	and    $0xfffffff0,%edx
  8022e2:	29 d4                	sub    %edx,%esp
  8022e4:	8d 54 24 03          	lea    0x3(%esp),%edx
  8022e8:	c1 ea 02             	shr    $0x2,%edx
  8022eb:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  8022f2:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  8022f4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8022f7:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  8022fe:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802305:	00 
	va_start(vl, arg0);
  802306:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802309:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  80230b:	b8 00 00 00 00       	mov    $0x0,%eax
  802310:	eb 09                	jmp    80231b <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  802312:	40                   	inc    %eax
  802313:	8b 39                	mov    (%ecx),%edi
  802315:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802318:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  80231b:	39 d0                	cmp    %edx,%eax
  80231d:	75 f3                	jne    802312 <spawnl+0x58>
	return spawn(prog, argv);
  80231f:	83 ec 08             	sub    $0x8,%esp
  802322:	56                   	push   %esi
  802323:	ff 75 08             	pushl  0x8(%ebp)
  802326:	e8 1f fa ff ff       	call   801d4a <spawn>
}
  80232b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80232e:	5b                   	pop    %ebx
  80232f:	5e                   	pop    %esi
  802330:	5f                   	pop    %edi
  802331:	5d                   	pop    %ebp
  802332:	c3                   	ret    

00802333 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802333:	55                   	push   %ebp
  802334:	89 e5                	mov    %esp,%ebp
  802336:	56                   	push   %esi
  802337:	53                   	push   %ebx
  802338:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  80233b:	83 ec 0c             	sub    $0xc,%esp
  80233e:	ff 75 08             	pushl  0x8(%ebp)
  802341:	e8 da f1 ff ff       	call   801520 <fd2data>
  802346:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802348:	83 c4 08             	add    $0x8,%esp
  80234b:	68 c6 31 80 00       	push   $0x8031c6
  802350:	53                   	push   %ebx
  802351:	e8 cb e8 ff ff       	call   800c21 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802356:	8b 46 04             	mov    0x4(%esi),%eax
  802359:	2b 06                	sub    (%esi),%eax
  80235b:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  802361:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  802368:	10 00 00 
	stat->st_dev = &devpipe;
  80236b:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802372:	40 80 00 
	return 0;
}
  802375:	b8 00 00 00 00       	mov    $0x0,%eax
  80237a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80237d:	5b                   	pop    %ebx
  80237e:	5e                   	pop    %esi
  80237f:	5d                   	pop    %ebp
  802380:	c3                   	ret    

00802381 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	53                   	push   %ebx
  802385:	83 ec 0c             	sub    $0xc,%esp
  802388:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  80238b:	53                   	push   %ebx
  80238c:	6a 00                	push   $0x0
  80238e:	e8 c8 ec ff ff       	call   80105b <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802393:	89 1c 24             	mov    %ebx,(%esp)
  802396:	e8 85 f1 ff ff       	call   801520 <fd2data>
  80239b:	83 c4 08             	add    $0x8,%esp
  80239e:	50                   	push   %eax
  80239f:	6a 00                	push   $0x0
  8023a1:	e8 b5 ec ff ff       	call   80105b <sys_page_unmap>
}
  8023a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023a9:	c9                   	leave  
  8023aa:	c3                   	ret    

008023ab <_pipeisclosed>:
{
  8023ab:	55                   	push   %ebp
  8023ac:	89 e5                	mov    %esp,%ebp
  8023ae:	57                   	push   %edi
  8023af:	56                   	push   %esi
  8023b0:	53                   	push   %ebx
  8023b1:	83 ec 1c             	sub    $0x1c,%esp
  8023b4:	89 c7                	mov    %eax,%edi
  8023b6:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  8023b8:	a1 04 50 80 00       	mov    0x805004,%eax
  8023bd:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  8023c0:	83 ec 0c             	sub    $0xc,%esp
  8023c3:	57                   	push   %edi
  8023c4:	e8 97 04 00 00       	call   802860 <pageref>
  8023c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8023cc:	89 34 24             	mov    %esi,(%esp)
  8023cf:	e8 8c 04 00 00       	call   802860 <pageref>
		nn = thisenv->env_runs;
  8023d4:	8b 15 04 50 80 00    	mov    0x805004,%edx
  8023da:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  8023dd:	83 c4 10             	add    $0x10,%esp
  8023e0:	39 cb                	cmp    %ecx,%ebx
  8023e2:	74 1b                	je     8023ff <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  8023e4:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  8023e7:	75 cf                	jne    8023b8 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  8023e9:	8b 42 58             	mov    0x58(%edx),%eax
  8023ec:	6a 01                	push   $0x1
  8023ee:	50                   	push   %eax
  8023ef:	53                   	push   %ebx
  8023f0:	68 cd 31 80 00       	push   $0x8031cd
  8023f5:	e8 1f e2 ff ff       	call   800619 <cprintf>
  8023fa:	83 c4 10             	add    $0x10,%esp
  8023fd:	eb b9                	jmp    8023b8 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  8023ff:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802402:	0f 94 c0             	sete   %al
  802405:	0f b6 c0             	movzbl %al,%eax
}
  802408:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80240b:	5b                   	pop    %ebx
  80240c:	5e                   	pop    %esi
  80240d:	5f                   	pop    %edi
  80240e:	5d                   	pop    %ebp
  80240f:	c3                   	ret    

00802410 <devpipe_write>:
{
  802410:	55                   	push   %ebp
  802411:	89 e5                	mov    %esp,%ebp
  802413:	57                   	push   %edi
  802414:	56                   	push   %esi
  802415:	53                   	push   %ebx
  802416:	83 ec 18             	sub    $0x18,%esp
  802419:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  80241c:	56                   	push   %esi
  80241d:	e8 fe f0 ff ff       	call   801520 <fd2data>
  802422:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802424:	83 c4 10             	add    $0x10,%esp
  802427:	bf 00 00 00 00       	mov    $0x0,%edi
  80242c:	3b 7d 10             	cmp    0x10(%ebp),%edi
  80242f:	74 41                	je     802472 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802431:	8b 53 04             	mov    0x4(%ebx),%edx
  802434:	8b 03                	mov    (%ebx),%eax
  802436:	83 c0 20             	add    $0x20,%eax
  802439:	39 c2                	cmp    %eax,%edx
  80243b:	72 14                	jb     802451 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  80243d:	89 da                	mov    %ebx,%edx
  80243f:	89 f0                	mov    %esi,%eax
  802441:	e8 65 ff ff ff       	call   8023ab <_pipeisclosed>
  802446:	85 c0                	test   %eax,%eax
  802448:	75 2c                	jne    802476 <devpipe_write+0x66>
			sys_yield();
  80244a:	e8 4e ec ff ff       	call   80109d <sys_yield>
  80244f:	eb e0                	jmp    802431 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802451:	8b 45 0c             	mov    0xc(%ebp),%eax
  802454:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  802457:	89 d0                	mov    %edx,%eax
  802459:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80245e:	78 0b                	js     80246b <devpipe_write+0x5b>
  802460:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  802464:	42                   	inc    %edx
  802465:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802468:	47                   	inc    %edi
  802469:	eb c1                	jmp    80242c <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  80246b:	48                   	dec    %eax
  80246c:	83 c8 e0             	or     $0xffffffe0,%eax
  80246f:	40                   	inc    %eax
  802470:	eb ee                	jmp    802460 <devpipe_write+0x50>
	return i;
  802472:	89 f8                	mov    %edi,%eax
  802474:	eb 05                	jmp    80247b <devpipe_write+0x6b>
				return 0;
  802476:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80247b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80247e:	5b                   	pop    %ebx
  80247f:	5e                   	pop    %esi
  802480:	5f                   	pop    %edi
  802481:	5d                   	pop    %ebp
  802482:	c3                   	ret    

00802483 <devpipe_read>:
{
  802483:	55                   	push   %ebp
  802484:	89 e5                	mov    %esp,%ebp
  802486:	57                   	push   %edi
  802487:	56                   	push   %esi
  802488:	53                   	push   %ebx
  802489:	83 ec 18             	sub    $0x18,%esp
  80248c:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80248f:	57                   	push   %edi
  802490:	e8 8b f0 ff ff       	call   801520 <fd2data>
  802495:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  802497:	83 c4 10             	add    $0x10,%esp
  80249a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80249f:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  8024a2:	74 46                	je     8024ea <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  8024a4:	8b 06                	mov    (%esi),%eax
  8024a6:	3b 46 04             	cmp    0x4(%esi),%eax
  8024a9:	75 22                	jne    8024cd <devpipe_read+0x4a>
			if (i > 0)
  8024ab:	85 db                	test   %ebx,%ebx
  8024ad:	74 0a                	je     8024b9 <devpipe_read+0x36>
				return i;
  8024af:	89 d8                	mov    %ebx,%eax
}
  8024b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8024b4:	5b                   	pop    %ebx
  8024b5:	5e                   	pop    %esi
  8024b6:	5f                   	pop    %edi
  8024b7:	5d                   	pop    %ebp
  8024b8:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  8024b9:	89 f2                	mov    %esi,%edx
  8024bb:	89 f8                	mov    %edi,%eax
  8024bd:	e8 e9 fe ff ff       	call   8023ab <_pipeisclosed>
  8024c2:	85 c0                	test   %eax,%eax
  8024c4:	75 28                	jne    8024ee <devpipe_read+0x6b>
			sys_yield();
  8024c6:	e8 d2 eb ff ff       	call   80109d <sys_yield>
  8024cb:	eb d7                	jmp    8024a4 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024cd:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8024d2:	78 0f                	js     8024e3 <devpipe_read+0x60>
  8024d4:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  8024d8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8024db:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  8024de:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  8024e0:	43                   	inc    %ebx
  8024e1:	eb bc                	jmp    80249f <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  8024e3:	48                   	dec    %eax
  8024e4:	83 c8 e0             	or     $0xffffffe0,%eax
  8024e7:	40                   	inc    %eax
  8024e8:	eb ea                	jmp    8024d4 <devpipe_read+0x51>
	return i;
  8024ea:	89 d8                	mov    %ebx,%eax
  8024ec:	eb c3                	jmp    8024b1 <devpipe_read+0x2e>
				return 0;
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	eb bc                	jmp    8024b1 <devpipe_read+0x2e>

008024f5 <pipe>:
{
  8024f5:	55                   	push   %ebp
  8024f6:	89 e5                	mov    %esp,%ebp
  8024f8:	56                   	push   %esi
  8024f9:	53                   	push   %ebx
  8024fa:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  8024fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802500:	50                   	push   %eax
  802501:	e8 31 f0 ff ff       	call   801537 <fd_alloc>
  802506:	89 c3                	mov    %eax,%ebx
  802508:	83 c4 10             	add    $0x10,%esp
  80250b:	85 c0                	test   %eax,%eax
  80250d:	0f 88 2a 01 00 00    	js     80263d <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802513:	83 ec 04             	sub    $0x4,%esp
  802516:	68 07 04 00 00       	push   $0x407
  80251b:	ff 75 f4             	pushl  -0xc(%ebp)
  80251e:	6a 00                	push   $0x0
  802520:	e8 b1 ea ff ff       	call   800fd6 <sys_page_alloc>
  802525:	89 c3                	mov    %eax,%ebx
  802527:	83 c4 10             	add    $0x10,%esp
  80252a:	85 c0                	test   %eax,%eax
  80252c:	0f 88 0b 01 00 00    	js     80263d <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  802532:	83 ec 0c             	sub    $0xc,%esp
  802535:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802538:	50                   	push   %eax
  802539:	e8 f9 ef ff ff       	call   801537 <fd_alloc>
  80253e:	89 c3                	mov    %eax,%ebx
  802540:	83 c4 10             	add    $0x10,%esp
  802543:	85 c0                	test   %eax,%eax
  802545:	0f 88 e2 00 00 00    	js     80262d <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80254b:	83 ec 04             	sub    $0x4,%esp
  80254e:	68 07 04 00 00       	push   $0x407
  802553:	ff 75 f0             	pushl  -0x10(%ebp)
  802556:	6a 00                	push   $0x0
  802558:	e8 79 ea ff ff       	call   800fd6 <sys_page_alloc>
  80255d:	89 c3                	mov    %eax,%ebx
  80255f:	83 c4 10             	add    $0x10,%esp
  802562:	85 c0                	test   %eax,%eax
  802564:	0f 88 c3 00 00 00    	js     80262d <pipe+0x138>
	va = fd2data(fd0);
  80256a:	83 ec 0c             	sub    $0xc,%esp
  80256d:	ff 75 f4             	pushl  -0xc(%ebp)
  802570:	e8 ab ef ff ff       	call   801520 <fd2data>
  802575:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802577:	83 c4 0c             	add    $0xc,%esp
  80257a:	68 07 04 00 00       	push   $0x407
  80257f:	50                   	push   %eax
  802580:	6a 00                	push   $0x0
  802582:	e8 4f ea ff ff       	call   800fd6 <sys_page_alloc>
  802587:	89 c3                	mov    %eax,%ebx
  802589:	83 c4 10             	add    $0x10,%esp
  80258c:	85 c0                	test   %eax,%eax
  80258e:	0f 88 89 00 00 00    	js     80261d <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802594:	83 ec 0c             	sub    $0xc,%esp
  802597:	ff 75 f0             	pushl  -0x10(%ebp)
  80259a:	e8 81 ef ff ff       	call   801520 <fd2data>
  80259f:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  8025a6:	50                   	push   %eax
  8025a7:	6a 00                	push   $0x0
  8025a9:	56                   	push   %esi
  8025aa:	6a 00                	push   $0x0
  8025ac:	e8 68 ea ff ff       	call   801019 <sys_page_map>
  8025b1:	89 c3                	mov    %eax,%ebx
  8025b3:	83 c4 20             	add    $0x20,%esp
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	78 55                	js     80260f <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  8025ba:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  8025c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  8025cf:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  8025d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d8:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  8025da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025dd:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  8025e4:	83 ec 0c             	sub    $0xc,%esp
  8025e7:	ff 75 f4             	pushl  -0xc(%ebp)
  8025ea:	e8 21 ef ff ff       	call   801510 <fd2num>
  8025ef:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025f2:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  8025f4:	83 c4 04             	add    $0x4,%esp
  8025f7:	ff 75 f0             	pushl  -0x10(%ebp)
  8025fa:	e8 11 ef ff ff       	call   801510 <fd2num>
  8025ff:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802602:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802605:	83 c4 10             	add    $0x10,%esp
  802608:	bb 00 00 00 00       	mov    $0x0,%ebx
  80260d:	eb 2e                	jmp    80263d <pipe+0x148>
	sys_page_unmap(0, va);
  80260f:	83 ec 08             	sub    $0x8,%esp
  802612:	56                   	push   %esi
  802613:	6a 00                	push   $0x0
  802615:	e8 41 ea ff ff       	call   80105b <sys_page_unmap>
  80261a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80261d:	83 ec 08             	sub    $0x8,%esp
  802620:	ff 75 f0             	pushl  -0x10(%ebp)
  802623:	6a 00                	push   $0x0
  802625:	e8 31 ea ff ff       	call   80105b <sys_page_unmap>
  80262a:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  80262d:	83 ec 08             	sub    $0x8,%esp
  802630:	ff 75 f4             	pushl  -0xc(%ebp)
  802633:	6a 00                	push   $0x0
  802635:	e8 21 ea ff ff       	call   80105b <sys_page_unmap>
  80263a:	83 c4 10             	add    $0x10,%esp
}
  80263d:	89 d8                	mov    %ebx,%eax
  80263f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802642:	5b                   	pop    %ebx
  802643:	5e                   	pop    %esi
  802644:	5d                   	pop    %ebp
  802645:	c3                   	ret    

00802646 <pipeisclosed>:
{
  802646:	55                   	push   %ebp
  802647:	89 e5                	mov    %esp,%ebp
  802649:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80264c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80264f:	50                   	push   %eax
  802650:	ff 75 08             	pushl  0x8(%ebp)
  802653:	e8 2e ef ff ff       	call   801586 <fd_lookup>
  802658:	83 c4 10             	add    $0x10,%esp
  80265b:	85 c0                	test   %eax,%eax
  80265d:	78 18                	js     802677 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  80265f:	83 ec 0c             	sub    $0xc,%esp
  802662:	ff 75 f4             	pushl  -0xc(%ebp)
  802665:	e8 b6 ee ff ff       	call   801520 <fd2data>
	return _pipeisclosed(fd, p);
  80266a:	89 c2                	mov    %eax,%edx
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	e8 37 fd ff ff       	call   8023ab <_pipeisclosed>
  802674:	83 c4 10             	add    $0x10,%esp
}
  802677:	c9                   	leave  
  802678:	c3                   	ret    

00802679 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802679:	55                   	push   %ebp
  80267a:	89 e5                	mov    %esp,%ebp
  80267c:	56                   	push   %esi
  80267d:	53                   	push   %ebx
  80267e:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802681:	85 f6                	test   %esi,%esi
  802683:	74 18                	je     80269d <wait+0x24>
	e = &envs[ENVX(envid)];
  802685:	89 f2                	mov    %esi,%edx
  802687:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  80268d:	89 d0                	mov    %edx,%eax
  80268f:	c1 e0 05             	shl    $0x5,%eax
  802692:	29 d0                	sub    %edx,%eax
  802694:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  80269b:	eb 1b                	jmp    8026b8 <wait+0x3f>
	assert(envid != 0);
  80269d:	68 e5 31 80 00       	push   $0x8031e5
  8026a2:	68 36 30 80 00       	push   $0x803036
  8026a7:	6a 09                	push   $0x9
  8026a9:	68 f0 31 80 00       	push   $0x8031f0
  8026ae:	e8 53 de ff ff       	call   800506 <_panic>
		sys_yield();
  8026b3:	e8 e5 e9 ff ff       	call   80109d <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  8026b8:	8b 43 48             	mov    0x48(%ebx),%eax
  8026bb:	39 c6                	cmp    %eax,%esi
  8026bd:	75 07                	jne    8026c6 <wait+0x4d>
  8026bf:	8b 43 54             	mov    0x54(%ebx),%eax
  8026c2:	85 c0                	test   %eax,%eax
  8026c4:	75 ed                	jne    8026b3 <wait+0x3a>
}
  8026c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8026c9:	5b                   	pop    %ebx
  8026ca:	5e                   	pop    %esi
  8026cb:	5d                   	pop    %ebp
  8026cc:	c3                   	ret    

008026cd <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  8026cd:	55                   	push   %ebp
  8026ce:	89 e5                	mov    %esp,%ebp
  8026d0:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  8026d3:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  8026da:	74 0a                	je     8026e6 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	a3 00 70 80 00       	mov    %eax,0x807000
}
  8026e4:	c9                   	leave  
  8026e5:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  8026e6:	e8 cc e8 ff ff       	call   800fb7 <sys_getenvid>
  8026eb:	83 ec 04             	sub    $0x4,%esp
  8026ee:	6a 07                	push   $0x7
  8026f0:	68 00 f0 bf ee       	push   $0xeebff000
  8026f5:	50                   	push   %eax
  8026f6:	e8 db e8 ff ff       	call   800fd6 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  8026fb:	e8 b7 e8 ff ff       	call   800fb7 <sys_getenvid>
  802700:	83 c4 08             	add    $0x8,%esp
  802703:	68 13 27 80 00       	push   $0x802713
  802708:	50                   	push   %eax
  802709:	e8 73 ea ff ff       	call   801181 <sys_env_set_pgfault_upcall>
  80270e:	83 c4 10             	add    $0x10,%esp
  802711:	eb c9                	jmp    8026dc <set_pgfault_handler+0xf>

00802713 <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802713:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802714:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  802719:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  80271b:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  80271e:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  802722:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  802726:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  802729:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  80272b:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  80272f:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  802732:	61                   	popa   
	addl $4, %esp
  802733:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  802736:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  802737:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  802738:	c3                   	ret    

00802739 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802739:	55                   	push   %ebp
  80273a:	89 e5                	mov    %esp,%ebp
  80273c:	57                   	push   %edi
  80273d:	56                   	push   %esi
  80273e:	53                   	push   %ebx
  80273f:	83 ec 0c             	sub    $0xc,%esp
  802742:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802745:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802748:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80274b:	85 ff                	test   %edi,%edi
  80274d:	74 53                	je     8027a2 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80274f:	83 ec 0c             	sub    $0xc,%esp
  802752:	57                   	push   %edi
  802753:	e8 8e ea ff ff       	call   8011e6 <sys_ipc_recv>
  802758:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80275b:	85 db                	test   %ebx,%ebx
  80275d:	74 0b                	je     80276a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80275f:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802765:	8b 52 74             	mov    0x74(%edx),%edx
  802768:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  80276a:	85 f6                	test   %esi,%esi
  80276c:	74 0f                	je     80277d <ipc_recv+0x44>
  80276e:	85 ff                	test   %edi,%edi
  802770:	74 0b                	je     80277d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802772:	8b 15 04 50 80 00    	mov    0x805004,%edx
  802778:	8b 52 78             	mov    0x78(%edx),%edx
  80277b:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  80277d:	85 c0                	test   %eax,%eax
  80277f:	74 30                	je     8027b1 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802781:	85 db                	test   %ebx,%ebx
  802783:	74 06                	je     80278b <ipc_recv+0x52>
      		*from_env_store = 0;
  802785:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  80278b:	85 f6                	test   %esi,%esi
  80278d:	74 2c                	je     8027bb <ipc_recv+0x82>
      		*perm_store = 0;
  80278f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  802795:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  80279a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80279d:	5b                   	pop    %ebx
  80279e:	5e                   	pop    %esi
  80279f:	5f                   	pop    %edi
  8027a0:	5d                   	pop    %ebp
  8027a1:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8027a2:	83 ec 0c             	sub    $0xc,%esp
  8027a5:	6a ff                	push   $0xffffffff
  8027a7:	e8 3a ea ff ff       	call   8011e6 <sys_ipc_recv>
  8027ac:	83 c4 10             	add    $0x10,%esp
  8027af:	eb aa                	jmp    80275b <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8027b1:	a1 04 50 80 00       	mov    0x805004,%eax
  8027b6:	8b 40 70             	mov    0x70(%eax),%eax
  8027b9:	eb df                	jmp    80279a <ipc_recv+0x61>
		return -1;
  8027bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8027c0:	eb d8                	jmp    80279a <ipc_recv+0x61>

008027c2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8027c2:	55                   	push   %ebp
  8027c3:	89 e5                	mov    %esp,%ebp
  8027c5:	57                   	push   %edi
  8027c6:	56                   	push   %esi
  8027c7:	53                   	push   %ebx
  8027c8:	83 ec 0c             	sub    $0xc,%esp
  8027cb:	8b 75 0c             	mov    0xc(%ebp),%esi
  8027ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8027d1:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8027d4:	85 db                	test   %ebx,%ebx
  8027d6:	75 22                	jne    8027fa <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8027d8:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8027dd:	eb 1b                	jmp    8027fa <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8027df:	68 fc 31 80 00       	push   $0x8031fc
  8027e4:	68 36 30 80 00       	push   $0x803036
  8027e9:	6a 48                	push   $0x48
  8027eb:	68 20 32 80 00       	push   $0x803220
  8027f0:	e8 11 dd ff ff       	call   800506 <_panic>
		sys_yield();
  8027f5:	e8 a3 e8 ff ff       	call   80109d <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8027fa:	57                   	push   %edi
  8027fb:	53                   	push   %ebx
  8027fc:	56                   	push   %esi
  8027fd:	ff 75 08             	pushl  0x8(%ebp)
  802800:	e8 be e9 ff ff       	call   8011c3 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802805:	83 c4 10             	add    $0x10,%esp
  802808:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80280b:	74 e8                	je     8027f5 <ipc_send+0x33>
  80280d:	85 c0                	test   %eax,%eax
  80280f:	75 ce                	jne    8027df <ipc_send+0x1d>
		sys_yield();
  802811:	e8 87 e8 ff ff       	call   80109d <sys_yield>
		
	}
	
}
  802816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802819:	5b                   	pop    %ebx
  80281a:	5e                   	pop    %esi
  80281b:	5f                   	pop    %edi
  80281c:	5d                   	pop    %ebp
  80281d:	c3                   	ret    

0080281e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80281e:	55                   	push   %ebp
  80281f:	89 e5                	mov    %esp,%ebp
  802821:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802824:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802829:	89 c2                	mov    %eax,%edx
  80282b:	c1 e2 05             	shl    $0x5,%edx
  80282e:	29 c2                	sub    %eax,%edx
  802830:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802837:	8b 52 50             	mov    0x50(%edx),%edx
  80283a:	39 ca                	cmp    %ecx,%edx
  80283c:	74 0f                	je     80284d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80283e:	40                   	inc    %eax
  80283f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802844:	75 e3                	jne    802829 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802846:	b8 00 00 00 00       	mov    $0x0,%eax
  80284b:	eb 11                	jmp    80285e <ipc_find_env+0x40>
			return envs[i].env_id;
  80284d:	89 c2                	mov    %eax,%edx
  80284f:	c1 e2 05             	shl    $0x5,%edx
  802852:	29 c2                	sub    %eax,%edx
  802854:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80285b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80285e:	5d                   	pop    %ebp
  80285f:	c3                   	ret    

00802860 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802860:	55                   	push   %ebp
  802861:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802863:	8b 45 08             	mov    0x8(%ebp),%eax
  802866:	c1 e8 16             	shr    $0x16,%eax
  802869:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802870:	a8 01                	test   $0x1,%al
  802872:	74 21                	je     802895 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802874:	8b 45 08             	mov    0x8(%ebp),%eax
  802877:	c1 e8 0c             	shr    $0xc,%eax
  80287a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802881:	a8 01                	test   $0x1,%al
  802883:	74 17                	je     80289c <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802885:	c1 e8 0c             	shr    $0xc,%eax
  802888:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80288f:	ef 
  802890:	0f b7 c0             	movzwl %ax,%eax
  802893:	eb 05                	jmp    80289a <pageref+0x3a>
		return 0;
  802895:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80289a:	5d                   	pop    %ebp
  80289b:	c3                   	ret    
		return 0;
  80289c:	b8 00 00 00 00       	mov    $0x0,%eax
  8028a1:	eb f7                	jmp    80289a <pageref+0x3a>
  8028a3:	90                   	nop

008028a4 <__udivdi3>:
  8028a4:	55                   	push   %ebp
  8028a5:	57                   	push   %edi
  8028a6:	56                   	push   %esi
  8028a7:	53                   	push   %ebx
  8028a8:	83 ec 1c             	sub    $0x1c,%esp
  8028ab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8028af:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8028b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8028b7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8028bb:	89 ca                	mov    %ecx,%edx
  8028bd:	89 f8                	mov    %edi,%eax
  8028bf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8028c3:	85 f6                	test   %esi,%esi
  8028c5:	75 2d                	jne    8028f4 <__udivdi3+0x50>
  8028c7:	39 cf                	cmp    %ecx,%edi
  8028c9:	77 65                	ja     802930 <__udivdi3+0x8c>
  8028cb:	89 fd                	mov    %edi,%ebp
  8028cd:	85 ff                	test   %edi,%edi
  8028cf:	75 0b                	jne    8028dc <__udivdi3+0x38>
  8028d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8028d6:	31 d2                	xor    %edx,%edx
  8028d8:	f7 f7                	div    %edi
  8028da:	89 c5                	mov    %eax,%ebp
  8028dc:	31 d2                	xor    %edx,%edx
  8028de:	89 c8                	mov    %ecx,%eax
  8028e0:	f7 f5                	div    %ebp
  8028e2:	89 c1                	mov    %eax,%ecx
  8028e4:	89 d8                	mov    %ebx,%eax
  8028e6:	f7 f5                	div    %ebp
  8028e8:	89 cf                	mov    %ecx,%edi
  8028ea:	89 fa                	mov    %edi,%edx
  8028ec:	83 c4 1c             	add    $0x1c,%esp
  8028ef:	5b                   	pop    %ebx
  8028f0:	5e                   	pop    %esi
  8028f1:	5f                   	pop    %edi
  8028f2:	5d                   	pop    %ebp
  8028f3:	c3                   	ret    
  8028f4:	39 ce                	cmp    %ecx,%esi
  8028f6:	77 28                	ja     802920 <__udivdi3+0x7c>
  8028f8:	0f bd fe             	bsr    %esi,%edi
  8028fb:	83 f7 1f             	xor    $0x1f,%edi
  8028fe:	75 40                	jne    802940 <__udivdi3+0x9c>
  802900:	39 ce                	cmp    %ecx,%esi
  802902:	72 0a                	jb     80290e <__udivdi3+0x6a>
  802904:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802908:	0f 87 9e 00 00 00    	ja     8029ac <__udivdi3+0x108>
  80290e:	b8 01 00 00 00       	mov    $0x1,%eax
  802913:	89 fa                	mov    %edi,%edx
  802915:	83 c4 1c             	add    $0x1c,%esp
  802918:	5b                   	pop    %ebx
  802919:	5e                   	pop    %esi
  80291a:	5f                   	pop    %edi
  80291b:	5d                   	pop    %ebp
  80291c:	c3                   	ret    
  80291d:	8d 76 00             	lea    0x0(%esi),%esi
  802920:	31 ff                	xor    %edi,%edi
  802922:	31 c0                	xor    %eax,%eax
  802924:	89 fa                	mov    %edi,%edx
  802926:	83 c4 1c             	add    $0x1c,%esp
  802929:	5b                   	pop    %ebx
  80292a:	5e                   	pop    %esi
  80292b:	5f                   	pop    %edi
  80292c:	5d                   	pop    %ebp
  80292d:	c3                   	ret    
  80292e:	66 90                	xchg   %ax,%ax
  802930:	89 d8                	mov    %ebx,%eax
  802932:	f7 f7                	div    %edi
  802934:	31 ff                	xor    %edi,%edi
  802936:	89 fa                	mov    %edi,%edx
  802938:	83 c4 1c             	add    $0x1c,%esp
  80293b:	5b                   	pop    %ebx
  80293c:	5e                   	pop    %esi
  80293d:	5f                   	pop    %edi
  80293e:	5d                   	pop    %ebp
  80293f:	c3                   	ret    
  802940:	bd 20 00 00 00       	mov    $0x20,%ebp
  802945:	29 fd                	sub    %edi,%ebp
  802947:	89 f9                	mov    %edi,%ecx
  802949:	d3 e6                	shl    %cl,%esi
  80294b:	89 c3                	mov    %eax,%ebx
  80294d:	89 e9                	mov    %ebp,%ecx
  80294f:	d3 eb                	shr    %cl,%ebx
  802951:	89 d9                	mov    %ebx,%ecx
  802953:	09 f1                	or     %esi,%ecx
  802955:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802959:	89 f9                	mov    %edi,%ecx
  80295b:	d3 e0                	shl    %cl,%eax
  80295d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802961:	89 d6                	mov    %edx,%esi
  802963:	89 e9                	mov    %ebp,%ecx
  802965:	d3 ee                	shr    %cl,%esi
  802967:	89 f9                	mov    %edi,%ecx
  802969:	d3 e2                	shl    %cl,%edx
  80296b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80296f:	89 e9                	mov    %ebp,%ecx
  802971:	d3 eb                	shr    %cl,%ebx
  802973:	09 da                	or     %ebx,%edx
  802975:	89 d0                	mov    %edx,%eax
  802977:	89 f2                	mov    %esi,%edx
  802979:	f7 74 24 08          	divl   0x8(%esp)
  80297d:	89 d6                	mov    %edx,%esi
  80297f:	89 c3                	mov    %eax,%ebx
  802981:	f7 64 24 0c          	mull   0xc(%esp)
  802985:	39 d6                	cmp    %edx,%esi
  802987:	72 17                	jb     8029a0 <__udivdi3+0xfc>
  802989:	74 09                	je     802994 <__udivdi3+0xf0>
  80298b:	89 d8                	mov    %ebx,%eax
  80298d:	31 ff                	xor    %edi,%edi
  80298f:	e9 56 ff ff ff       	jmp    8028ea <__udivdi3+0x46>
  802994:	8b 54 24 04          	mov    0x4(%esp),%edx
  802998:	89 f9                	mov    %edi,%ecx
  80299a:	d3 e2                	shl    %cl,%edx
  80299c:	39 c2                	cmp    %eax,%edx
  80299e:	73 eb                	jae    80298b <__udivdi3+0xe7>
  8029a0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8029a3:	31 ff                	xor    %edi,%edi
  8029a5:	e9 40 ff ff ff       	jmp    8028ea <__udivdi3+0x46>
  8029aa:	66 90                	xchg   %ax,%ax
  8029ac:	31 c0                	xor    %eax,%eax
  8029ae:	e9 37 ff ff ff       	jmp    8028ea <__udivdi3+0x46>
  8029b3:	90                   	nop

008029b4 <__umoddi3>:
  8029b4:	55                   	push   %ebp
  8029b5:	57                   	push   %edi
  8029b6:	56                   	push   %esi
  8029b7:	53                   	push   %ebx
  8029b8:	83 ec 1c             	sub    $0x1c,%esp
  8029bb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8029bf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8029c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8029c7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8029cb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8029cf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8029d3:	89 3c 24             	mov    %edi,(%esp)
  8029d6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8029da:	89 f2                	mov    %esi,%edx
  8029dc:	85 c0                	test   %eax,%eax
  8029de:	75 18                	jne    8029f8 <__umoddi3+0x44>
  8029e0:	39 f7                	cmp    %esi,%edi
  8029e2:	0f 86 a0 00 00 00    	jbe    802a88 <__umoddi3+0xd4>
  8029e8:	89 c8                	mov    %ecx,%eax
  8029ea:	f7 f7                	div    %edi
  8029ec:	89 d0                	mov    %edx,%eax
  8029ee:	31 d2                	xor    %edx,%edx
  8029f0:	83 c4 1c             	add    $0x1c,%esp
  8029f3:	5b                   	pop    %ebx
  8029f4:	5e                   	pop    %esi
  8029f5:	5f                   	pop    %edi
  8029f6:	5d                   	pop    %ebp
  8029f7:	c3                   	ret    
  8029f8:	89 f3                	mov    %esi,%ebx
  8029fa:	39 f0                	cmp    %esi,%eax
  8029fc:	0f 87 a6 00 00 00    	ja     802aa8 <__umoddi3+0xf4>
  802a02:	0f bd e8             	bsr    %eax,%ebp
  802a05:	83 f5 1f             	xor    $0x1f,%ebp
  802a08:	0f 84 a6 00 00 00    	je     802ab4 <__umoddi3+0x100>
  802a0e:	bf 20 00 00 00       	mov    $0x20,%edi
  802a13:	29 ef                	sub    %ebp,%edi
  802a15:	89 e9                	mov    %ebp,%ecx
  802a17:	d3 e0                	shl    %cl,%eax
  802a19:	8b 34 24             	mov    (%esp),%esi
  802a1c:	89 f2                	mov    %esi,%edx
  802a1e:	89 f9                	mov    %edi,%ecx
  802a20:	d3 ea                	shr    %cl,%edx
  802a22:	09 c2                	or     %eax,%edx
  802a24:	89 14 24             	mov    %edx,(%esp)
  802a27:	89 f2                	mov    %esi,%edx
  802a29:	89 e9                	mov    %ebp,%ecx
  802a2b:	d3 e2                	shl    %cl,%edx
  802a2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802a31:	89 de                	mov    %ebx,%esi
  802a33:	89 f9                	mov    %edi,%ecx
  802a35:	d3 ee                	shr    %cl,%esi
  802a37:	89 e9                	mov    %ebp,%ecx
  802a39:	d3 e3                	shl    %cl,%ebx
  802a3b:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a3f:	89 d0                	mov    %edx,%eax
  802a41:	89 f9                	mov    %edi,%ecx
  802a43:	d3 e8                	shr    %cl,%eax
  802a45:	09 d8                	or     %ebx,%eax
  802a47:	89 d3                	mov    %edx,%ebx
  802a49:	89 e9                	mov    %ebp,%ecx
  802a4b:	d3 e3                	shl    %cl,%ebx
  802a4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802a51:	89 f2                	mov    %esi,%edx
  802a53:	f7 34 24             	divl   (%esp)
  802a56:	89 d6                	mov    %edx,%esi
  802a58:	f7 64 24 04          	mull   0x4(%esp)
  802a5c:	89 c3                	mov    %eax,%ebx
  802a5e:	89 d1                	mov    %edx,%ecx
  802a60:	39 d6                	cmp    %edx,%esi
  802a62:	72 7c                	jb     802ae0 <__umoddi3+0x12c>
  802a64:	74 72                	je     802ad8 <__umoddi3+0x124>
  802a66:	8b 54 24 08          	mov    0x8(%esp),%edx
  802a6a:	29 da                	sub    %ebx,%edx
  802a6c:	19 ce                	sbb    %ecx,%esi
  802a6e:	89 f0                	mov    %esi,%eax
  802a70:	89 f9                	mov    %edi,%ecx
  802a72:	d3 e0                	shl    %cl,%eax
  802a74:	89 e9                	mov    %ebp,%ecx
  802a76:	d3 ea                	shr    %cl,%edx
  802a78:	09 d0                	or     %edx,%eax
  802a7a:	89 e9                	mov    %ebp,%ecx
  802a7c:	d3 ee                	shr    %cl,%esi
  802a7e:	89 f2                	mov    %esi,%edx
  802a80:	83 c4 1c             	add    $0x1c,%esp
  802a83:	5b                   	pop    %ebx
  802a84:	5e                   	pop    %esi
  802a85:	5f                   	pop    %edi
  802a86:	5d                   	pop    %ebp
  802a87:	c3                   	ret    
  802a88:	89 fd                	mov    %edi,%ebp
  802a8a:	85 ff                	test   %edi,%edi
  802a8c:	75 0b                	jne    802a99 <__umoddi3+0xe5>
  802a8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802a93:	31 d2                	xor    %edx,%edx
  802a95:	f7 f7                	div    %edi
  802a97:	89 c5                	mov    %eax,%ebp
  802a99:	89 f0                	mov    %esi,%eax
  802a9b:	31 d2                	xor    %edx,%edx
  802a9d:	f7 f5                	div    %ebp
  802a9f:	89 c8                	mov    %ecx,%eax
  802aa1:	f7 f5                	div    %ebp
  802aa3:	e9 44 ff ff ff       	jmp    8029ec <__umoddi3+0x38>
  802aa8:	89 c8                	mov    %ecx,%eax
  802aaa:	89 f2                	mov    %esi,%edx
  802aac:	83 c4 1c             	add    $0x1c,%esp
  802aaf:	5b                   	pop    %ebx
  802ab0:	5e                   	pop    %esi
  802ab1:	5f                   	pop    %edi
  802ab2:	5d                   	pop    %ebp
  802ab3:	c3                   	ret    
  802ab4:	39 f0                	cmp    %esi,%eax
  802ab6:	72 05                	jb     802abd <__umoddi3+0x109>
  802ab8:	39 0c 24             	cmp    %ecx,(%esp)
  802abb:	77 0c                	ja     802ac9 <__umoddi3+0x115>
  802abd:	89 f2                	mov    %esi,%edx
  802abf:	29 f9                	sub    %edi,%ecx
  802ac1:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802ac5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802ac9:	8b 44 24 04          	mov    0x4(%esp),%eax
  802acd:	83 c4 1c             	add    $0x1c,%esp
  802ad0:	5b                   	pop    %ebx
  802ad1:	5e                   	pop    %esi
  802ad2:	5f                   	pop    %edi
  802ad3:	5d                   	pop    %ebp
  802ad4:	c3                   	ret    
  802ad5:	8d 76 00             	lea    0x0(%esi),%esi
  802ad8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802adc:	73 88                	jae    802a66 <__umoddi3+0xb2>
  802ade:	66 90                	xchg   %ax,%ax
  802ae0:	2b 44 24 04          	sub    0x4(%esp),%eax
  802ae4:	1b 14 24             	sbb    (%esp),%edx
  802ae7:	89 d1                	mov    %edx,%ecx
  802ae9:	89 c3                	mov    %eax,%ebx
  802aeb:	e9 76 ff ff ff       	jmp    802a66 <__umoddi3+0xb2>
