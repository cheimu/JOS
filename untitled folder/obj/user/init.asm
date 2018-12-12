
obj/user/init.debug:     file format elf32-i386


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
  80002c:	e8 70 03 00 00       	call   8003a1 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <sum>:

char bss[6000];

int
sum(const char *s, int n)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	56                   	push   %esi
  800037:	53                   	push   %ebx
  800038:	8b 75 08             	mov    0x8(%ebp),%esi
  80003b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int i, tot = 0;
  80003e:	b8 00 00 00 00       	mov    $0x0,%eax
	for (i = 0; i < n; i++)
  800043:	ba 00 00 00 00       	mov    $0x0,%edx
  800048:	eb 0a                	jmp    800054 <sum+0x21>
		tot ^= i * s[i];
  80004a:	0f be 0c 16          	movsbl (%esi,%edx,1),%ecx
  80004e:	0f af ca             	imul   %edx,%ecx
  800051:	31 c8                	xor    %ecx,%eax
	for (i = 0; i < n; i++)
  800053:	42                   	inc    %edx
  800054:	39 da                	cmp    %ebx,%edx
  800056:	7c f2                	jl     80004a <sum+0x17>
	return tot;
}
  800058:	5b                   	pop    %ebx
  800059:	5e                   	pop    %esi
  80005a:	5d                   	pop    %ebp
  80005b:	c3                   	ret    

0080005c <umain>:

void
umain(int argc, char **argv)
{
  80005c:	55                   	push   %ebp
  80005d:	89 e5                	mov    %esp,%ebp
  80005f:	57                   	push   %edi
  800060:	56                   	push   %esi
  800061:	53                   	push   %ebx
  800062:	81 ec 18 01 00 00    	sub    $0x118,%esp
  800068:	8b 7d 0c             	mov    0xc(%ebp),%edi
	int i, r, x, want;
	char args[256];

	cprintf("init: running\n");
  80006b:	68 00 27 80 00       	push   $0x802700
  800070:	e8 a5 04 00 00       	call   80051a <cprintf>

	want = 0xf989e;
	if ((x = sum((char*)&data, sizeof data)) != want)
  800075:	83 c4 08             	add    $0x8,%esp
  800078:	68 70 17 00 00       	push   $0x1770
  80007d:	68 00 30 80 00       	push   $0x803000
  800082:	e8 ac ff ff ff       	call   800033 <sum>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	3d 9e 98 0f 00       	cmp    $0xf989e,%eax
  80008f:	74 64                	je     8000f5 <umain+0x99>
		cprintf("init: data is not initialized: got sum %08x wanted %08x\n",
  800091:	83 ec 04             	sub    $0x4,%esp
  800094:	68 9e 98 0f 00       	push   $0xf989e
  800099:	50                   	push   %eax
  80009a:	68 c8 27 80 00       	push   $0x8027c8
  80009f:	e8 76 04 00 00       	call   80051a <cprintf>
  8000a4:	83 c4 10             	add    $0x10,%esp
			x, want);
	else
		cprintf("init: data seems okay\n");
	if ((x = sum(bss, sizeof bss)) != 0)
  8000a7:	83 ec 08             	sub    $0x8,%esp
  8000aa:	68 70 17 00 00       	push   $0x1770
  8000af:	68 20 50 80 00       	push   $0x805020
  8000b4:	e8 7a ff ff ff       	call   800033 <sum>
  8000b9:	83 c4 10             	add    $0x10,%esp
  8000bc:	85 c0                	test   %eax,%eax
  8000be:	74 47                	je     800107 <umain+0xab>
		cprintf("bss is not initialized: wanted sum 0 got %08x\n", x);
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	50                   	push   %eax
  8000c4:	68 04 28 80 00       	push   $0x802804
  8000c9:	e8 4c 04 00 00       	call   80051a <cprintf>
  8000ce:	83 c4 10             	add    $0x10,%esp
	else
		cprintf("init: bss seems okay\n");

	// output in one syscall per line to avoid output interleaving 
	strcat(args, "init: args:");
  8000d1:	83 ec 08             	sub    $0x8,%esp
  8000d4:	68 3c 27 80 00       	push   $0x80273c
  8000d9:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8000df:	50                   	push   %eax
  8000e0:	e8 58 0a 00 00       	call   800b3d <strcat>
	for (i = 0; i < argc; i++) {
  8000e5:	83 c4 10             	add    $0x10,%esp
  8000e8:	bb 00 00 00 00       	mov    $0x0,%ebx
		strcat(args, " '");
  8000ed:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
	for (i = 0; i < argc; i++) {
  8000f3:	eb 50                	jmp    800145 <umain+0xe9>
		cprintf("init: data seems okay\n");
  8000f5:	83 ec 0c             	sub    $0xc,%esp
  8000f8:	68 0f 27 80 00       	push   $0x80270f
  8000fd:	e8 18 04 00 00       	call   80051a <cprintf>
  800102:	83 c4 10             	add    $0x10,%esp
  800105:	eb a0                	jmp    8000a7 <umain+0x4b>
		cprintf("init: bss seems okay\n");
  800107:	83 ec 0c             	sub    $0xc,%esp
  80010a:	68 26 27 80 00       	push   $0x802726
  80010f:	e8 06 04 00 00       	call   80051a <cprintf>
  800114:	83 c4 10             	add    $0x10,%esp
  800117:	eb b8                	jmp    8000d1 <umain+0x75>
		strcat(args, " '");
  800119:	83 ec 08             	sub    $0x8,%esp
  80011c:	68 48 27 80 00       	push   $0x802748
  800121:	56                   	push   %esi
  800122:	e8 16 0a 00 00       	call   800b3d <strcat>
		strcat(args, argv[i]);
  800127:	83 c4 08             	add    $0x8,%esp
  80012a:	ff 34 9f             	pushl  (%edi,%ebx,4)
  80012d:	56                   	push   %esi
  80012e:	e8 0a 0a 00 00       	call   800b3d <strcat>
		strcat(args, "'");
  800133:	83 c4 08             	add    $0x8,%esp
  800136:	68 49 27 80 00       	push   $0x802749
  80013b:	56                   	push   %esi
  80013c:	e8 fc 09 00 00       	call   800b3d <strcat>
	for (i = 0; i < argc; i++) {
  800141:	43                   	inc    %ebx
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	3b 5d 08             	cmp    0x8(%ebp),%ebx
  800148:	7c cf                	jl     800119 <umain+0xbd>
	}
	cprintf("%s\n", args);
  80014a:	83 ec 08             	sub    $0x8,%esp
  80014d:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800153:	50                   	push   %eax
  800154:	68 4b 27 80 00       	push   $0x80274b
  800159:	e8 bc 03 00 00       	call   80051a <cprintf>

	cprintf("init: running sh\n");
  80015e:	c7 04 24 4f 27 80 00 	movl   $0x80274f,(%esp)
  800165:	e8 b0 03 00 00       	call   80051a <cprintf>

	// being run directly from kernel, so no file descriptors open yet
	close(0);
  80016a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800171:	e8 bf 11 00 00       	call   801335 <close>
	if ((r = opencons()) < 0)
  800176:	e8 d4 01 00 00       	call   80034f <opencons>
  80017b:	83 c4 10             	add    $0x10,%esp
  80017e:	85 c0                	test   %eax,%eax
  800180:	78 16                	js     800198 <umain+0x13c>
		panic("opencons: %e", r);
	if (r != 0)
  800182:	85 c0                	test   %eax,%eax
  800184:	74 24                	je     8001aa <umain+0x14e>
		panic("first opencons used fd %d", r);
  800186:	50                   	push   %eax
  800187:	68 7a 27 80 00       	push   $0x80277a
  80018c:	6a 39                	push   $0x39
  80018e:	68 6e 27 80 00       	push   $0x80276e
  800193:	e8 6f 02 00 00       	call   800407 <_panic>
		panic("opencons: %e", r);
  800198:	50                   	push   %eax
  800199:	68 61 27 80 00       	push   $0x802761
  80019e:	6a 37                	push   $0x37
  8001a0:	68 6e 27 80 00       	push   $0x80276e
  8001a5:	e8 5d 02 00 00       	call   800407 <_panic>
	if ((r = dup(0, 1)) < 0)
  8001aa:	83 ec 08             	sub    $0x8,%esp
  8001ad:	6a 01                	push   $0x1
  8001af:	6a 00                	push   $0x0
  8001b1:	e8 cd 11 00 00       	call   801383 <dup>
  8001b6:	83 c4 10             	add    $0x10,%esp
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	79 23                	jns    8001e0 <umain+0x184>
		panic("dup: %e", r);
  8001bd:	50                   	push   %eax
  8001be:	68 94 27 80 00       	push   $0x802794
  8001c3:	6a 3b                	push   $0x3b
  8001c5:	68 6e 27 80 00       	push   $0x80276e
  8001ca:	e8 38 02 00 00       	call   800407 <_panic>
	while (1) {
		cprintf("init: starting sh\n");
		r = spawnl("/sh", "sh", (char*)0);
		if (r < 0) {
			cprintf("init: spawn sh: %e\n", r);
  8001cf:	83 ec 08             	sub    $0x8,%esp
  8001d2:	50                   	push   %eax
  8001d3:	68 b3 27 80 00       	push   $0x8027b3
  8001d8:	e8 3d 03 00 00       	call   80051a <cprintf>
			continue;
  8001dd:	83 c4 10             	add    $0x10,%esp
		cprintf("init: starting sh\n");
  8001e0:	83 ec 0c             	sub    $0xc,%esp
  8001e3:	68 9c 27 80 00       	push   $0x80279c
  8001e8:	e8 2d 03 00 00       	call   80051a <cprintf>
		r = spawnl("/sh", "sh", (char*)0);
  8001ed:	83 c4 0c             	add    $0xc,%esp
  8001f0:	6a 00                	push   $0x0
  8001f2:	68 b0 27 80 00       	push   $0x8027b0
  8001f7:	68 af 27 80 00       	push   $0x8027af
  8001fc:	e8 35 1d 00 00       	call   801f36 <spawnl>
		if (r < 0) {
  800201:	83 c4 10             	add    $0x10,%esp
  800204:	85 c0                	test   %eax,%eax
  800206:	78 c7                	js     8001cf <umain+0x173>
		}
		wait(r);
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	50                   	push   %eax
  80020c:	e8 e4 20 00 00       	call   8022f5 <wait>
  800211:	83 c4 10             	add    $0x10,%esp
  800214:	eb ca                	jmp    8001e0 <umain+0x184>

00800216 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800216:	55                   	push   %ebp
  800217:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800219:	b8 00 00 00 00       	mov    $0x0,%eax
  80021e:	5d                   	pop    %ebp
  80021f:	c3                   	ret    

00800220 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800220:	55                   	push   %ebp
  800221:	89 e5                	mov    %esp,%ebp
  800223:	53                   	push   %ebx
  800224:	83 ec 0c             	sub    $0xc,%esp
  800227:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80022a:	68 33 28 80 00       	push   $0x802833
  80022f:	53                   	push   %ebx
  800230:	e8 ed 08 00 00       	call   800b22 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800235:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  80023c:	20 00 00 
	return 0;
}
  80023f:	b8 00 00 00 00       	mov    $0x0,%eax
  800244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800247:	c9                   	leave  
  800248:	c3                   	ret    

00800249 <devcons_write>:
{
  800249:	55                   	push   %ebp
  80024a:	89 e5                	mov    %esp,%ebp
  80024c:	57                   	push   %edi
  80024d:	56                   	push   %esi
  80024e:	53                   	push   %ebx
  80024f:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800255:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80025a:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800260:	eb 1d                	jmp    80027f <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800262:	83 ec 04             	sub    $0x4,%esp
  800265:	53                   	push   %ebx
  800266:	03 45 0c             	add    0xc(%ebp),%eax
  800269:	50                   	push   %eax
  80026a:	57                   	push   %edi
  80026b:	e8 25 0a 00 00       	call   800c95 <memmove>
		sys_cputs(buf, m);
  800270:	83 c4 08             	add    $0x8,%esp
  800273:	53                   	push   %ebx
  800274:	57                   	push   %edi
  800275:	e8 c0 0b 00 00       	call   800e3a <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80027a:	01 de                	add    %ebx,%esi
  80027c:	83 c4 10             	add    $0x10,%esp
  80027f:	89 f0                	mov    %esi,%eax
  800281:	3b 75 10             	cmp    0x10(%ebp),%esi
  800284:	73 11                	jae    800297 <devcons_write+0x4e>
		m = n - tot;
  800286:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800289:	29 f3                	sub    %esi,%ebx
  80028b:	83 fb 7f             	cmp    $0x7f,%ebx
  80028e:	76 d2                	jbe    800262 <devcons_write+0x19>
  800290:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800295:	eb cb                	jmp    800262 <devcons_write+0x19>
}
  800297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    

0080029f <devcons_read>:
{
  80029f:	55                   	push   %ebp
  8002a0:	89 e5                	mov    %esp,%ebp
  8002a2:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  8002a5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8002a9:	75 0c                	jne    8002b7 <devcons_read+0x18>
		return 0;
  8002ab:	b8 00 00 00 00       	mov    $0x0,%eax
  8002b0:	eb 21                	jmp    8002d3 <devcons_read+0x34>
		sys_yield();
  8002b2:	e8 e7 0c 00 00       	call   800f9e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  8002b7:	e8 9c 0b 00 00       	call   800e58 <sys_cgetc>
  8002bc:	85 c0                	test   %eax,%eax
  8002be:	74 f2                	je     8002b2 <devcons_read+0x13>
	if (c < 0)
  8002c0:	85 c0                	test   %eax,%eax
  8002c2:	78 0f                	js     8002d3 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8002c4:	83 f8 04             	cmp    $0x4,%eax
  8002c7:	74 0c                	je     8002d5 <devcons_read+0x36>
	*(char*)vbuf = c;
  8002c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002cc:	88 02                	mov    %al,(%edx)
	return 1;
  8002ce:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8002d3:	c9                   	leave  
  8002d4:	c3                   	ret    
		return 0;
  8002d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8002da:	eb f7                	jmp    8002d3 <devcons_read+0x34>

008002dc <cputchar>:
{
  8002dc:	55                   	push   %ebp
  8002dd:	89 e5                	mov    %esp,%ebp
  8002df:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8002e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e5:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8002e8:	6a 01                	push   $0x1
  8002ea:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8002ed:	50                   	push   %eax
  8002ee:	e8 47 0b 00 00       	call   800e3a <sys_cputs>
}
  8002f3:	83 c4 10             	add    $0x10,%esp
  8002f6:	c9                   	leave  
  8002f7:	c3                   	ret    

008002f8 <getchar>:
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8002fe:	6a 01                	push   $0x1
  800300:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800303:	50                   	push   %eax
  800304:	6a 00                	push   $0x0
  800306:	e8 64 11 00 00       	call   80146f <read>
	if (r < 0)
  80030b:	83 c4 10             	add    $0x10,%esp
  80030e:	85 c0                	test   %eax,%eax
  800310:	78 08                	js     80031a <getchar+0x22>
	if (r < 1)
  800312:	85 c0                	test   %eax,%eax
  800314:	7e 06                	jle    80031c <getchar+0x24>
	return c;
  800316:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    
		return -E_EOF;
  80031c:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  800321:	eb f7                	jmp    80031a <getchar+0x22>

00800323 <iscons>:
{
  800323:	55                   	push   %ebp
  800324:	89 e5                	mov    %esp,%ebp
  800326:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800329:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80032c:	50                   	push   %eax
  80032d:	ff 75 08             	pushl  0x8(%ebp)
  800330:	e8 cd 0e 00 00       	call   801202 <fd_lookup>
  800335:	83 c4 10             	add    $0x10,%esp
  800338:	85 c0                	test   %eax,%eax
  80033a:	78 11                	js     80034d <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  80033c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80033f:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800345:	39 10                	cmp    %edx,(%eax)
  800347:	0f 94 c0             	sete   %al
  80034a:	0f b6 c0             	movzbl %al,%eax
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <opencons>:
{
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  800355:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800358:	50                   	push   %eax
  800359:	e8 55 0e 00 00       	call   8011b3 <fd_alloc>
  80035e:	83 c4 10             	add    $0x10,%esp
  800361:	85 c0                	test   %eax,%eax
  800363:	78 3a                	js     80039f <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  800365:	83 ec 04             	sub    $0x4,%esp
  800368:	68 07 04 00 00       	push   $0x407
  80036d:	ff 75 f4             	pushl  -0xc(%ebp)
  800370:	6a 00                	push   $0x0
  800372:	e8 60 0b 00 00       	call   800ed7 <sys_page_alloc>
  800377:	83 c4 10             	add    $0x10,%esp
  80037a:	85 c0                	test   %eax,%eax
  80037c:	78 21                	js     80039f <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80037e:	8b 15 70 47 80 00    	mov    0x804770,%edx
  800384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800387:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038c:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800393:	83 ec 0c             	sub    $0xc,%esp
  800396:	50                   	push   %eax
  800397:	e8 f0 0d 00 00       	call   80118c <fd2num>
  80039c:	83 c4 10             	add    $0x10,%esp
}
  80039f:	c9                   	leave  
  8003a0:	c3                   	ret    

008003a1 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  8003a1:	55                   	push   %ebp
  8003a2:	89 e5                	mov    %esp,%ebp
  8003a4:	56                   	push   %esi
  8003a5:	53                   	push   %ebx
  8003a6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  8003a9:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  8003ac:	e8 07 0b 00 00       	call   800eb8 <sys_getenvid>
  8003b1:	25 ff 03 00 00       	and    $0x3ff,%eax
  8003b6:	89 c2                	mov    %eax,%edx
  8003b8:	c1 e2 05             	shl    $0x5,%edx
  8003bb:	29 c2                	sub    %eax,%edx
  8003bd:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  8003c4:	a3 90 67 80 00       	mov    %eax,0x806790

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c9:	85 db                	test   %ebx,%ebx
  8003cb:	7e 07                	jle    8003d4 <libmain+0x33>
		binaryname = argv[0];
  8003cd:	8b 06                	mov    (%esi),%eax
  8003cf:	a3 8c 47 80 00       	mov    %eax,0x80478c

	// call user main routine
	umain(argc, argv);
  8003d4:	83 ec 08             	sub    $0x8,%esp
  8003d7:	56                   	push   %esi
  8003d8:	53                   	push   %ebx
  8003d9:	e8 7e fc ff ff       	call   80005c <umain>

	// exit gracefully
	exit();
  8003de:	e8 0a 00 00 00       	call   8003ed <exit>
}
  8003e3:	83 c4 10             	add    $0x10,%esp
  8003e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5d                   	pop    %ebp
  8003ec:	c3                   	ret    

008003ed <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8003ed:	55                   	push   %ebp
  8003ee:	89 e5                	mov    %esp,%ebp
  8003f0:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8003f3:	e8 68 0f 00 00       	call   801360 <close_all>
	sys_env_destroy(0);
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 00                	push   $0x0
  8003fd:	e8 75 0a 00 00       	call   800e77 <sys_env_destroy>
}
  800402:	83 c4 10             	add    $0x10,%esp
  800405:	c9                   	leave  
  800406:	c3                   	ret    

00800407 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800407:	55                   	push   %ebp
  800408:	89 e5                	mov    %esp,%ebp
  80040a:	57                   	push   %edi
  80040b:	56                   	push   %esi
  80040c:	53                   	push   %ebx
  80040d:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800413:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800416:	8b 1d 8c 47 80 00    	mov    0x80478c,%ebx
  80041c:	e8 97 0a 00 00       	call   800eb8 <sys_getenvid>
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 0c             	pushl  0xc(%ebp)
  800427:	ff 75 08             	pushl  0x8(%ebp)
  80042a:	53                   	push   %ebx
  80042b:	50                   	push   %eax
  80042c:	68 4c 28 80 00       	push   $0x80284c
  800431:	68 00 01 00 00       	push   $0x100
  800436:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80043c:	56                   	push   %esi
  80043d:	e8 93 06 00 00       	call   800ad5 <snprintf>
  800442:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800444:	83 c4 20             	add    $0x20,%esp
  800447:	57                   	push   %edi
  800448:	ff 75 10             	pushl  0x10(%ebp)
  80044b:	bf 00 01 00 00       	mov    $0x100,%edi
  800450:	89 f8                	mov    %edi,%eax
  800452:	29 d8                	sub    %ebx,%eax
  800454:	50                   	push   %eax
  800455:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800458:	50                   	push   %eax
  800459:	e8 22 06 00 00       	call   800a80 <vsnprintf>
  80045e:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800460:	83 c4 0c             	add    $0xc,%esp
  800463:	68 36 2d 80 00       	push   $0x802d36
  800468:	29 df                	sub    %ebx,%edi
  80046a:	57                   	push   %edi
  80046b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80046e:	50                   	push   %eax
  80046f:	e8 61 06 00 00       	call   800ad5 <snprintf>
	sys_cputs(buf, r);
  800474:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800477:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800479:	53                   	push   %ebx
  80047a:	56                   	push   %esi
  80047b:	e8 ba 09 00 00       	call   800e3a <sys_cputs>
  800480:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800483:	cc                   	int3   
  800484:	eb fd                	jmp    800483 <_panic+0x7c>

00800486 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800486:	55                   	push   %ebp
  800487:	89 e5                	mov    %esp,%ebp
  800489:	53                   	push   %ebx
  80048a:	83 ec 04             	sub    $0x4,%esp
  80048d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800490:	8b 13                	mov    (%ebx),%edx
  800492:	8d 42 01             	lea    0x1(%edx),%eax
  800495:	89 03                	mov    %eax,(%ebx)
  800497:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80049a:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80049e:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004a3:	74 08                	je     8004ad <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8004a5:	ff 43 04             	incl   0x4(%ebx)
}
  8004a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8004ab:	c9                   	leave  
  8004ac:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8004ad:	83 ec 08             	sub    $0x8,%esp
  8004b0:	68 ff 00 00 00       	push   $0xff
  8004b5:	8d 43 08             	lea    0x8(%ebx),%eax
  8004b8:	50                   	push   %eax
  8004b9:	e8 7c 09 00 00       	call   800e3a <sys_cputs>
		b->idx = 0;
  8004be:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8004c4:	83 c4 10             	add    $0x10,%esp
  8004c7:	eb dc                	jmp    8004a5 <putch+0x1f>

008004c9 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d9:	00 00 00 
	b.cnt = 0;
  8004dc:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e3:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f2:	50                   	push   %eax
  8004f3:	68 86 04 80 00       	push   $0x800486
  8004f8:	e8 17 01 00 00       	call   800614 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8004fd:	83 c4 08             	add    $0x8,%esp
  800500:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800506:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80050c:	50                   	push   %eax
  80050d:	e8 28 09 00 00       	call   800e3a <sys_cputs>

	return b.cnt;
}
  800512:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800520:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800523:	50                   	push   %eax
  800524:	ff 75 08             	pushl  0x8(%ebp)
  800527:	e8 9d ff ff ff       	call   8004c9 <vcprintf>
	va_end(ap);

	return cnt;
}
  80052c:	c9                   	leave  
  80052d:	c3                   	ret    

0080052e <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80052e:	55                   	push   %ebp
  80052f:	89 e5                	mov    %esp,%ebp
  800531:	57                   	push   %edi
  800532:	56                   	push   %esi
  800533:	53                   	push   %ebx
  800534:	83 ec 1c             	sub    $0x1c,%esp
  800537:	89 c7                	mov    %eax,%edi
  800539:	89 d6                	mov    %edx,%esi
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800541:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800544:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800547:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80054a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80054f:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800552:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800555:	39 d3                	cmp    %edx,%ebx
  800557:	72 05                	jb     80055e <printnum+0x30>
  800559:	39 45 10             	cmp    %eax,0x10(%ebp)
  80055c:	77 78                	ja     8005d6 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80055e:	83 ec 0c             	sub    $0xc,%esp
  800561:	ff 75 18             	pushl  0x18(%ebp)
  800564:	8b 45 14             	mov    0x14(%ebp),%eax
  800567:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80056a:	53                   	push   %ebx
  80056b:	ff 75 10             	pushl  0x10(%ebp)
  80056e:	83 ec 08             	sub    $0x8,%esp
  800571:	ff 75 e4             	pushl  -0x1c(%ebp)
  800574:	ff 75 e0             	pushl  -0x20(%ebp)
  800577:	ff 75 dc             	pushl  -0x24(%ebp)
  80057a:	ff 75 d8             	pushl  -0x28(%ebp)
  80057d:	e8 32 1f 00 00       	call   8024b4 <__udivdi3>
  800582:	83 c4 18             	add    $0x18,%esp
  800585:	52                   	push   %edx
  800586:	50                   	push   %eax
  800587:	89 f2                	mov    %esi,%edx
  800589:	89 f8                	mov    %edi,%eax
  80058b:	e8 9e ff ff ff       	call   80052e <printnum>
  800590:	83 c4 20             	add    $0x20,%esp
  800593:	eb 11                	jmp    8005a6 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800595:	83 ec 08             	sub    $0x8,%esp
  800598:	56                   	push   %esi
  800599:	ff 75 18             	pushl  0x18(%ebp)
  80059c:	ff d7                	call   *%edi
  80059e:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8005a1:	4b                   	dec    %ebx
  8005a2:	85 db                	test   %ebx,%ebx
  8005a4:	7f ef                	jg     800595 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005a6:	83 ec 08             	sub    $0x8,%esp
  8005a9:	56                   	push   %esi
  8005aa:	83 ec 04             	sub    $0x4,%esp
  8005ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8005b0:	ff 75 e0             	pushl  -0x20(%ebp)
  8005b3:	ff 75 dc             	pushl  -0x24(%ebp)
  8005b6:	ff 75 d8             	pushl  -0x28(%ebp)
  8005b9:	e8 06 20 00 00       	call   8025c4 <__umoddi3>
  8005be:	83 c4 14             	add    $0x14,%esp
  8005c1:	0f be 80 6f 28 80 00 	movsbl 0x80286f(%eax),%eax
  8005c8:	50                   	push   %eax
  8005c9:	ff d7                	call   *%edi
}
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005d1:	5b                   	pop    %ebx
  8005d2:	5e                   	pop    %esi
  8005d3:	5f                   	pop    %edi
  8005d4:	5d                   	pop    %ebp
  8005d5:	c3                   	ret    
  8005d6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8005d9:	eb c6                	jmp    8005a1 <printnum+0x73>

008005db <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8005e1:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8005e4:	8b 10                	mov    (%eax),%edx
  8005e6:	3b 50 04             	cmp    0x4(%eax),%edx
  8005e9:	73 0a                	jae    8005f5 <sprintputch+0x1a>
		*b->buf++ = ch;
  8005eb:	8d 4a 01             	lea    0x1(%edx),%ecx
  8005ee:	89 08                	mov    %ecx,(%eax)
  8005f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f3:	88 02                	mov    %al,(%edx)
}
  8005f5:	5d                   	pop    %ebp
  8005f6:	c3                   	ret    

008005f7 <printfmt>:
{
  8005f7:	55                   	push   %ebp
  8005f8:	89 e5                	mov    %esp,%ebp
  8005fa:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8005fd:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800600:	50                   	push   %eax
  800601:	ff 75 10             	pushl  0x10(%ebp)
  800604:	ff 75 0c             	pushl  0xc(%ebp)
  800607:	ff 75 08             	pushl  0x8(%ebp)
  80060a:	e8 05 00 00 00       	call   800614 <vprintfmt>
}
  80060f:	83 c4 10             	add    $0x10,%esp
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <vprintfmt>:
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	57                   	push   %edi
  800618:	56                   	push   %esi
  800619:	53                   	push   %ebx
  80061a:	83 ec 2c             	sub    $0x2c,%esp
  80061d:	8b 75 08             	mov    0x8(%ebp),%esi
  800620:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800623:	8b 7d 10             	mov    0x10(%ebp),%edi
  800626:	e9 ae 03 00 00       	jmp    8009d9 <vprintfmt+0x3c5>
  80062b:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80062f:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800636:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80063d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800644:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800649:	8d 47 01             	lea    0x1(%edi),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	8a 17                	mov    (%edi),%dl
  800651:	8d 42 dd             	lea    -0x23(%edx),%eax
  800654:	3c 55                	cmp    $0x55,%al
  800656:	0f 87 fe 03 00 00    	ja     800a5a <vprintfmt+0x446>
  80065c:	0f b6 c0             	movzbl %al,%eax
  80065f:	ff 24 85 c0 29 80 00 	jmp    *0x8029c0(,%eax,4)
  800666:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800669:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80066d:	eb da                	jmp    800649 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80066f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800672:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800676:	eb d1                	jmp    800649 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800678:	0f b6 d2             	movzbl %dl,%edx
  80067b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80067e:	b8 00 00 00 00       	mov    $0x0,%eax
  800683:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800686:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800689:	01 c0                	add    %eax,%eax
  80068b:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80068f:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800692:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800695:	83 f9 09             	cmp    $0x9,%ecx
  800698:	77 52                	ja     8006ec <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80069a:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  80069b:	eb e9                	jmp    800686 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80069d:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006a8:	8d 40 04             	lea    0x4(%eax),%eax
  8006ab:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8006ae:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8006b1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006b5:	79 92                	jns    800649 <vprintfmt+0x35>
				width = precision, precision = -1;
  8006b7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8006ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8006bd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8006c4:	eb 83                	jmp    800649 <vprintfmt+0x35>
  8006c6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8006ca:	78 08                	js     8006d4 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8006cc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8006cf:	e9 75 ff ff ff       	jmp    800649 <vprintfmt+0x35>
  8006d4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006db:	eb ef                	jmp    8006cc <vprintfmt+0xb8>
  8006dd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8006e0:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8006e7:	e9 5d ff ff ff       	jmp    800649 <vprintfmt+0x35>
  8006ec:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8006ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8006f2:	eb bd                	jmp    8006b1 <vprintfmt+0x9d>
			lflag++;
  8006f4:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8006f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8006f8:	e9 4c ff ff ff       	jmp    800649 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8006fd:	8b 45 14             	mov    0x14(%ebp),%eax
  800700:	8d 78 04             	lea    0x4(%eax),%edi
  800703:	83 ec 08             	sub    $0x8,%esp
  800706:	53                   	push   %ebx
  800707:	ff 30                	pushl  (%eax)
  800709:	ff d6                	call   *%esi
			break;
  80070b:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80070e:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800711:	e9 c0 02 00 00       	jmp    8009d6 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800716:	8b 45 14             	mov    0x14(%ebp),%eax
  800719:	8d 78 04             	lea    0x4(%eax),%edi
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	85 c0                	test   %eax,%eax
  800720:	78 2a                	js     80074c <vprintfmt+0x138>
  800722:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800724:	83 f8 0f             	cmp    $0xf,%eax
  800727:	7f 27                	jg     800750 <vprintfmt+0x13c>
  800729:	8b 04 85 20 2b 80 00 	mov    0x802b20(,%eax,4),%eax
  800730:	85 c0                	test   %eax,%eax
  800732:	74 1c                	je     800750 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800734:	50                   	push   %eax
  800735:	68 51 2c 80 00       	push   $0x802c51
  80073a:	53                   	push   %ebx
  80073b:	56                   	push   %esi
  80073c:	e8 b6 fe ff ff       	call   8005f7 <printfmt>
  800741:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800744:	89 7d 14             	mov    %edi,0x14(%ebp)
  800747:	e9 8a 02 00 00       	jmp    8009d6 <vprintfmt+0x3c2>
  80074c:	f7 d8                	neg    %eax
  80074e:	eb d2                	jmp    800722 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800750:	52                   	push   %edx
  800751:	68 87 28 80 00       	push   $0x802887
  800756:	53                   	push   %ebx
  800757:	56                   	push   %esi
  800758:	e8 9a fe ff ff       	call   8005f7 <printfmt>
  80075d:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800760:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800763:	e9 6e 02 00 00       	jmp    8009d6 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800768:	8b 45 14             	mov    0x14(%ebp),%eax
  80076b:	83 c0 04             	add    $0x4,%eax
  80076e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800771:	8b 45 14             	mov    0x14(%ebp),%eax
  800774:	8b 38                	mov    (%eax),%edi
  800776:	85 ff                	test   %edi,%edi
  800778:	74 39                	je     8007b3 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80077a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80077e:	0f 8e a9 00 00 00    	jle    80082d <vprintfmt+0x219>
  800784:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800788:	0f 84 a7 00 00 00    	je     800835 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 d0             	pushl  -0x30(%ebp)
  800794:	57                   	push   %edi
  800795:	e8 6b 03 00 00       	call   800b05 <strnlen>
  80079a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80079d:	29 c1                	sub    %eax,%ecx
  80079f:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8007a2:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8007a5:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8007a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8007ac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8007af:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007b1:	eb 14                	jmp    8007c7 <vprintfmt+0x1b3>
				p = "(null)";
  8007b3:	bf 80 28 80 00       	mov    $0x802880,%edi
  8007b8:	eb c0                	jmp    80077a <vprintfmt+0x166>
					putch(padc, putdat);
  8007ba:	83 ec 08             	sub    $0x8,%esp
  8007bd:	53                   	push   %ebx
  8007be:	ff 75 e0             	pushl  -0x20(%ebp)
  8007c1:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8007c3:	4f                   	dec    %edi
  8007c4:	83 c4 10             	add    $0x10,%esp
  8007c7:	85 ff                	test   %edi,%edi
  8007c9:	7f ef                	jg     8007ba <vprintfmt+0x1a6>
  8007cb:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8007ce:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007d1:	89 c8                	mov    %ecx,%eax
  8007d3:	85 c9                	test   %ecx,%ecx
  8007d5:	78 10                	js     8007e7 <vprintfmt+0x1d3>
  8007d7:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8007da:	29 c1                	sub    %eax,%ecx
  8007dc:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8007df:	89 75 08             	mov    %esi,0x8(%ebp)
  8007e2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8007e5:	eb 15                	jmp    8007fc <vprintfmt+0x1e8>
  8007e7:	b8 00 00 00 00       	mov    $0x0,%eax
  8007ec:	eb e9                	jmp    8007d7 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8007ee:	83 ec 08             	sub    $0x8,%esp
  8007f1:	53                   	push   %ebx
  8007f2:	52                   	push   %edx
  8007f3:	ff 55 08             	call   *0x8(%ebp)
  8007f6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8007f9:	ff 4d e0             	decl   -0x20(%ebp)
  8007fc:	47                   	inc    %edi
  8007fd:	8a 47 ff             	mov    -0x1(%edi),%al
  800800:	0f be d0             	movsbl %al,%edx
  800803:	85 d2                	test   %edx,%edx
  800805:	74 59                	je     800860 <vprintfmt+0x24c>
  800807:	85 f6                	test   %esi,%esi
  800809:	78 03                	js     80080e <vprintfmt+0x1fa>
  80080b:	4e                   	dec    %esi
  80080c:	78 2f                	js     80083d <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80080e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800812:	74 da                	je     8007ee <vprintfmt+0x1da>
  800814:	0f be c0             	movsbl %al,%eax
  800817:	83 e8 20             	sub    $0x20,%eax
  80081a:	83 f8 5e             	cmp    $0x5e,%eax
  80081d:	76 cf                	jbe    8007ee <vprintfmt+0x1da>
					putch('?', putdat);
  80081f:	83 ec 08             	sub    $0x8,%esp
  800822:	53                   	push   %ebx
  800823:	6a 3f                	push   $0x3f
  800825:	ff 55 08             	call   *0x8(%ebp)
  800828:	83 c4 10             	add    $0x10,%esp
  80082b:	eb cc                	jmp    8007f9 <vprintfmt+0x1e5>
  80082d:	89 75 08             	mov    %esi,0x8(%ebp)
  800830:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800833:	eb c7                	jmp    8007fc <vprintfmt+0x1e8>
  800835:	89 75 08             	mov    %esi,0x8(%ebp)
  800838:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80083b:	eb bf                	jmp    8007fc <vprintfmt+0x1e8>
  80083d:	8b 75 08             	mov    0x8(%ebp),%esi
  800840:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800843:	eb 0c                	jmp    800851 <vprintfmt+0x23d>
				putch(' ', putdat);
  800845:	83 ec 08             	sub    $0x8,%esp
  800848:	53                   	push   %ebx
  800849:	6a 20                	push   $0x20
  80084b:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80084d:	4f                   	dec    %edi
  80084e:	83 c4 10             	add    $0x10,%esp
  800851:	85 ff                	test   %edi,%edi
  800853:	7f f0                	jg     800845 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800855:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	e9 76 01 00 00       	jmp    8009d6 <vprintfmt+0x3c2>
  800860:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800863:	8b 75 08             	mov    0x8(%ebp),%esi
  800866:	eb e9                	jmp    800851 <vprintfmt+0x23d>
	if (lflag >= 2)
  800868:	83 f9 01             	cmp    $0x1,%ecx
  80086b:	7f 1f                	jg     80088c <vprintfmt+0x278>
	else if (lflag)
  80086d:	85 c9                	test   %ecx,%ecx
  80086f:	75 48                	jne    8008b9 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800871:	8b 45 14             	mov    0x14(%ebp),%eax
  800874:	8b 00                	mov    (%eax),%eax
  800876:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800879:	89 c1                	mov    %eax,%ecx
  80087b:	c1 f9 1f             	sar    $0x1f,%ecx
  80087e:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	8d 40 04             	lea    0x4(%eax),%eax
  800887:	89 45 14             	mov    %eax,0x14(%ebp)
  80088a:	eb 17                	jmp    8008a3 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80088c:	8b 45 14             	mov    0x14(%ebp),%eax
  80088f:	8b 50 04             	mov    0x4(%eax),%edx
  800892:	8b 00                	mov    (%eax),%eax
  800894:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800897:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	8d 40 08             	lea    0x8(%eax),%eax
  8008a0:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8008a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008a6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8008a9:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ad:	78 25                	js     8008d4 <vprintfmt+0x2c0>
			base = 10;
  8008af:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008b4:	e9 03 01 00 00       	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8008b9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8008c1:	89 c1                	mov    %eax,%ecx
  8008c3:	c1 f9 1f             	sar    $0x1f,%ecx
  8008c6:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8008c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008cc:	8d 40 04             	lea    0x4(%eax),%eax
  8008cf:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d2:	eb cf                	jmp    8008a3 <vprintfmt+0x28f>
				putch('-', putdat);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	53                   	push   %ebx
  8008d8:	6a 2d                	push   $0x2d
  8008da:	ff d6                	call   *%esi
				num = -(long long) num;
  8008dc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8008df:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8008e2:	f7 da                	neg    %edx
  8008e4:	83 d1 00             	adc    $0x0,%ecx
  8008e7:	f7 d9                	neg    %ecx
  8008e9:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8008ec:	b8 0a 00 00 00       	mov    $0xa,%eax
  8008f1:	e9 c6 00 00 00       	jmp    8009bc <vprintfmt+0x3a8>
	if (lflag >= 2)
  8008f6:	83 f9 01             	cmp    $0x1,%ecx
  8008f9:	7f 1e                	jg     800919 <vprintfmt+0x305>
	else if (lflag)
  8008fb:	85 c9                	test   %ecx,%ecx
  8008fd:	75 32                	jne    800931 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	8b 10                	mov    (%eax),%edx
  800904:	b9 00 00 00 00       	mov    $0x0,%ecx
  800909:	8d 40 04             	lea    0x4(%eax),%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80090f:	b8 0a 00 00 00       	mov    $0xa,%eax
  800914:	e9 a3 00 00 00       	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800919:	8b 45 14             	mov    0x14(%ebp),%eax
  80091c:	8b 10                	mov    (%eax),%edx
  80091e:	8b 48 04             	mov    0x4(%eax),%ecx
  800921:	8d 40 08             	lea    0x8(%eax),%eax
  800924:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800927:	b8 0a 00 00 00       	mov    $0xa,%eax
  80092c:	e9 8b 00 00 00       	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800931:	8b 45 14             	mov    0x14(%ebp),%eax
  800934:	8b 10                	mov    (%eax),%edx
  800936:	b9 00 00 00 00       	mov    $0x0,%ecx
  80093b:	8d 40 04             	lea    0x4(%eax),%eax
  80093e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800941:	b8 0a 00 00 00       	mov    $0xa,%eax
  800946:	eb 74                	jmp    8009bc <vprintfmt+0x3a8>
	if (lflag >= 2)
  800948:	83 f9 01             	cmp    $0x1,%ecx
  80094b:	7f 1b                	jg     800968 <vprintfmt+0x354>
	else if (lflag)
  80094d:	85 c9                	test   %ecx,%ecx
  80094f:	75 2c                	jne    80097d <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	8b 10                	mov    (%eax),%edx
  800956:	b9 00 00 00 00       	mov    $0x0,%ecx
  80095b:	8d 40 04             	lea    0x4(%eax),%eax
  80095e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800961:	b8 08 00 00 00       	mov    $0x8,%eax
  800966:	eb 54                	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800968:	8b 45 14             	mov    0x14(%ebp),%eax
  80096b:	8b 10                	mov    (%eax),%edx
  80096d:	8b 48 04             	mov    0x4(%eax),%ecx
  800970:	8d 40 08             	lea    0x8(%eax),%eax
  800973:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800976:	b8 08 00 00 00       	mov    $0x8,%eax
  80097b:	eb 3f                	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80097d:	8b 45 14             	mov    0x14(%ebp),%eax
  800980:	8b 10                	mov    (%eax),%edx
  800982:	b9 00 00 00 00       	mov    $0x0,%ecx
  800987:	8d 40 04             	lea    0x4(%eax),%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80098d:	b8 08 00 00 00       	mov    $0x8,%eax
  800992:	eb 28                	jmp    8009bc <vprintfmt+0x3a8>
			putch('0', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	53                   	push   %ebx
  800998:	6a 30                	push   $0x30
  80099a:	ff d6                	call   *%esi
			putch('x', putdat);
  80099c:	83 c4 08             	add    $0x8,%esp
  80099f:	53                   	push   %ebx
  8009a0:	6a 78                	push   $0x78
  8009a2:	ff d6                	call   *%esi
			num = (unsigned long long)
  8009a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009a7:	8b 10                	mov    (%eax),%edx
  8009a9:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8009ae:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8009b1:	8d 40 04             	lea    0x4(%eax),%eax
  8009b4:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8009b7:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8009bc:	83 ec 0c             	sub    $0xc,%esp
  8009bf:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8009c3:	57                   	push   %edi
  8009c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8009c7:	50                   	push   %eax
  8009c8:	51                   	push   %ecx
  8009c9:	52                   	push   %edx
  8009ca:	89 da                	mov    %ebx,%edx
  8009cc:	89 f0                	mov    %esi,%eax
  8009ce:	e8 5b fb ff ff       	call   80052e <printnum>
			break;
  8009d3:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8009d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009d9:	47                   	inc    %edi
  8009da:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8009de:	83 f8 25             	cmp    $0x25,%eax
  8009e1:	0f 84 44 fc ff ff    	je     80062b <vprintfmt+0x17>
			if (ch == '\0')
  8009e7:	85 c0                	test   %eax,%eax
  8009e9:	0f 84 89 00 00 00    	je     800a78 <vprintfmt+0x464>
			putch(ch, putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	53                   	push   %ebx
  8009f3:	50                   	push   %eax
  8009f4:	ff d6                	call   *%esi
  8009f6:	83 c4 10             	add    $0x10,%esp
  8009f9:	eb de                	jmp    8009d9 <vprintfmt+0x3c5>
	if (lflag >= 2)
  8009fb:	83 f9 01             	cmp    $0x1,%ecx
  8009fe:	7f 1b                	jg     800a1b <vprintfmt+0x407>
	else if (lflag)
  800a00:	85 c9                	test   %ecx,%ecx
  800a02:	75 2c                	jne    800a30 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800a04:	8b 45 14             	mov    0x14(%ebp),%eax
  800a07:	8b 10                	mov    (%eax),%edx
  800a09:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a0e:	8d 40 04             	lea    0x4(%eax),%eax
  800a11:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a14:	b8 10 00 00 00       	mov    $0x10,%eax
  800a19:	eb a1                	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800a1b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a1e:	8b 10                	mov    (%eax),%edx
  800a20:	8b 48 04             	mov    0x4(%eax),%ecx
  800a23:	8d 40 08             	lea    0x8(%eax),%eax
  800a26:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a29:	b8 10 00 00 00       	mov    $0x10,%eax
  800a2e:	eb 8c                	jmp    8009bc <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	8b 10                	mov    (%eax),%edx
  800a35:	b9 00 00 00 00       	mov    $0x0,%ecx
  800a3a:	8d 40 04             	lea    0x4(%eax),%eax
  800a3d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800a40:	b8 10 00 00 00       	mov    $0x10,%eax
  800a45:	e9 72 ff ff ff       	jmp    8009bc <vprintfmt+0x3a8>
			putch(ch, putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	53                   	push   %ebx
  800a4e:	6a 25                	push   $0x25
  800a50:	ff d6                	call   *%esi
			break;
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	e9 7c ff ff ff       	jmp    8009d6 <vprintfmt+0x3c2>
			putch('%', putdat);
  800a5a:	83 ec 08             	sub    $0x8,%esp
  800a5d:	53                   	push   %ebx
  800a5e:	6a 25                	push   $0x25
  800a60:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a62:	83 c4 10             	add    $0x10,%esp
  800a65:	89 f8                	mov    %edi,%eax
  800a67:	eb 01                	jmp    800a6a <vprintfmt+0x456>
  800a69:	48                   	dec    %eax
  800a6a:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800a6e:	75 f9                	jne    800a69 <vprintfmt+0x455>
  800a70:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a73:	e9 5e ff ff ff       	jmp    8009d6 <vprintfmt+0x3c2>
}
  800a78:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800a7b:	5b                   	pop    %ebx
  800a7c:	5e                   	pop    %esi
  800a7d:	5f                   	pop    %edi
  800a7e:	5d                   	pop    %ebp
  800a7f:	c3                   	ret    

00800a80 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a80:	55                   	push   %ebp
  800a81:	89 e5                	mov    %esp,%ebp
  800a83:	83 ec 18             	sub    $0x18,%esp
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a8c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a8f:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800a93:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800a96:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a9d:	85 c0                	test   %eax,%eax
  800a9f:	74 26                	je     800ac7 <vsnprintf+0x47>
  800aa1:	85 d2                	test   %edx,%edx
  800aa3:	7e 29                	jle    800ace <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800aa5:	ff 75 14             	pushl  0x14(%ebp)
  800aa8:	ff 75 10             	pushl  0x10(%ebp)
  800aab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aae:	50                   	push   %eax
  800aaf:	68 db 05 80 00       	push   $0x8005db
  800ab4:	e8 5b fb ff ff       	call   800614 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800ab9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800abc:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
}
  800ac5:	c9                   	leave  
  800ac6:	c3                   	ret    
		return -E_INVAL;
  800ac7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800acc:	eb f7                	jmp    800ac5 <vsnprintf+0x45>
  800ace:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800ad3:	eb f0                	jmp    800ac5 <vsnprintf+0x45>

00800ad5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ad5:	55                   	push   %ebp
  800ad6:	89 e5                	mov    %esp,%ebp
  800ad8:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800adb:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800ade:	50                   	push   %eax
  800adf:	ff 75 10             	pushl  0x10(%ebp)
  800ae2:	ff 75 0c             	pushl  0xc(%ebp)
  800ae5:	ff 75 08             	pushl  0x8(%ebp)
  800ae8:	e8 93 ff ff ff       	call   800a80 <vsnprintf>
	va_end(ap);

	return rc;
}
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
  800af2:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800af5:	b8 00 00 00 00       	mov    $0x0,%eax
  800afa:	eb 01                	jmp    800afd <strlen+0xe>
		n++;
  800afc:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800afd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800b01:	75 f9                	jne    800afc <strlen+0xd>
	return n;
}
  800b03:	5d                   	pop    %ebp
  800b04:	c3                   	ret    

00800b05 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800b05:	55                   	push   %ebp
  800b06:	89 e5                	mov    %esp,%ebp
  800b08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b0b:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b0e:	b8 00 00 00 00       	mov    $0x0,%eax
  800b13:	eb 01                	jmp    800b16 <strnlen+0x11>
		n++;
  800b15:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b16:	39 d0                	cmp    %edx,%eax
  800b18:	74 06                	je     800b20 <strnlen+0x1b>
  800b1a:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800b1e:	75 f5                	jne    800b15 <strnlen+0x10>
	return n;
}
  800b20:	5d                   	pop    %ebp
  800b21:	c3                   	ret    

00800b22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b22:	55                   	push   %ebp
  800b23:	89 e5                	mov    %esp,%ebp
  800b25:	53                   	push   %ebx
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800b2c:	89 c2                	mov    %eax,%edx
  800b2e:	42                   	inc    %edx
  800b2f:	41                   	inc    %ecx
  800b30:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800b33:	88 5a ff             	mov    %bl,-0x1(%edx)
  800b36:	84 db                	test   %bl,%bl
  800b38:	75 f4                	jne    800b2e <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800b3a:	5b                   	pop    %ebx
  800b3b:	5d                   	pop    %ebp
  800b3c:	c3                   	ret    

00800b3d <strcat>:

char *
strcat(char *dst, const char *src)
{
  800b3d:	55                   	push   %ebp
  800b3e:	89 e5                	mov    %esp,%ebp
  800b40:	53                   	push   %ebx
  800b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800b44:	53                   	push   %ebx
  800b45:	e8 a5 ff ff ff       	call   800aef <strlen>
  800b4a:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800b4d:	ff 75 0c             	pushl  0xc(%ebp)
  800b50:	01 d8                	add    %ebx,%eax
  800b52:	50                   	push   %eax
  800b53:	e8 ca ff ff ff       	call   800b22 <strcpy>
	return dst;
}
  800b58:	89 d8                	mov    %ebx,%eax
  800b5a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b5d:	c9                   	leave  
  800b5e:	c3                   	ret    

00800b5f <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800b5f:	55                   	push   %ebp
  800b60:	89 e5                	mov    %esp,%ebp
  800b62:	56                   	push   %esi
  800b63:	53                   	push   %ebx
  800b64:	8b 75 08             	mov    0x8(%ebp),%esi
  800b67:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800b6a:	89 f3                	mov    %esi,%ebx
  800b6c:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b6f:	89 f2                	mov    %esi,%edx
  800b71:	eb 0c                	jmp    800b7f <strncpy+0x20>
		*dst++ = *src;
  800b73:	42                   	inc    %edx
  800b74:	8a 01                	mov    (%ecx),%al
  800b76:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800b79:	80 39 01             	cmpb   $0x1,(%ecx)
  800b7c:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800b7f:	39 da                	cmp    %ebx,%edx
  800b81:	75 f0                	jne    800b73 <strncpy+0x14>
	}
	return ret;
}
  800b83:	89 f0                	mov    %esi,%eax
  800b85:	5b                   	pop    %ebx
  800b86:	5e                   	pop    %esi
  800b87:	5d                   	pop    %ebp
  800b88:	c3                   	ret    

00800b89 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	56                   	push   %esi
  800b8d:	53                   	push   %ebx
  800b8e:	8b 75 08             	mov    0x8(%ebp),%esi
  800b91:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b94:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800b97:	85 c0                	test   %eax,%eax
  800b99:	74 20                	je     800bbb <strlcpy+0x32>
  800b9b:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800b9f:	89 f0                	mov    %esi,%eax
  800ba1:	eb 05                	jmp    800ba8 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800ba3:	40                   	inc    %eax
  800ba4:	42                   	inc    %edx
  800ba5:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800ba8:	39 d8                	cmp    %ebx,%eax
  800baa:	74 06                	je     800bb2 <strlcpy+0x29>
  800bac:	8a 0a                	mov    (%edx),%cl
  800bae:	84 c9                	test   %cl,%cl
  800bb0:	75 f1                	jne    800ba3 <strlcpy+0x1a>
		*dst = '\0';
  800bb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bb5:	29 f0                	sub    %esi,%eax
}
  800bb7:	5b                   	pop    %ebx
  800bb8:	5e                   	pop    %esi
  800bb9:	5d                   	pop    %ebp
  800bba:	c3                   	ret    
  800bbb:	89 f0                	mov    %esi,%eax
  800bbd:	eb f6                	jmp    800bb5 <strlcpy+0x2c>

00800bbf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800bc8:	eb 02                	jmp    800bcc <strcmp+0xd>
		p++, q++;
  800bca:	41                   	inc    %ecx
  800bcb:	42                   	inc    %edx
	while (*p && *p == *q)
  800bcc:	8a 01                	mov    (%ecx),%al
  800bce:	84 c0                	test   %al,%al
  800bd0:	74 04                	je     800bd6 <strcmp+0x17>
  800bd2:	3a 02                	cmp    (%edx),%al
  800bd4:	74 f4                	je     800bca <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800bd6:	0f b6 c0             	movzbl %al,%eax
  800bd9:	0f b6 12             	movzbl (%edx),%edx
  800bdc:	29 d0                	sub    %edx,%eax
}
  800bde:	5d                   	pop    %ebp
  800bdf:	c3                   	ret    

00800be0 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	53                   	push   %ebx
  800be4:	8b 45 08             	mov    0x8(%ebp),%eax
  800be7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bea:	89 c3                	mov    %eax,%ebx
  800bec:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800bef:	eb 02                	jmp    800bf3 <strncmp+0x13>
		n--, p++, q++;
  800bf1:	40                   	inc    %eax
  800bf2:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800bf3:	39 d8                	cmp    %ebx,%eax
  800bf5:	74 15                	je     800c0c <strncmp+0x2c>
  800bf7:	8a 08                	mov    (%eax),%cl
  800bf9:	84 c9                	test   %cl,%cl
  800bfb:	74 04                	je     800c01 <strncmp+0x21>
  800bfd:	3a 0a                	cmp    (%edx),%cl
  800bff:	74 f0                	je     800bf1 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c01:	0f b6 00             	movzbl (%eax),%eax
  800c04:	0f b6 12             	movzbl (%edx),%edx
  800c07:	29 d0                	sub    %edx,%eax
}
  800c09:	5b                   	pop    %ebx
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    
		return 0;
  800c0c:	b8 00 00 00 00       	mov    $0x0,%eax
  800c11:	eb f6                	jmp    800c09 <strncmp+0x29>

00800c13 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c13:	55                   	push   %ebp
  800c14:	89 e5                	mov    %esp,%ebp
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
  800c19:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800c1c:	8a 10                	mov    (%eax),%dl
  800c1e:	84 d2                	test   %dl,%dl
  800c20:	74 07                	je     800c29 <strchr+0x16>
		if (*s == c)
  800c22:	38 ca                	cmp    %cl,%dl
  800c24:	74 08                	je     800c2e <strchr+0x1b>
	for (; *s; s++)
  800c26:	40                   	inc    %eax
  800c27:	eb f3                	jmp    800c1c <strchr+0x9>
			return (char *) s;
	return 0;
  800c29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c2e:	5d                   	pop    %ebp
  800c2f:	c3                   	ret    

00800c30 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	8b 45 08             	mov    0x8(%ebp),%eax
  800c36:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800c39:	8a 10                	mov    (%eax),%dl
  800c3b:	84 d2                	test   %dl,%dl
  800c3d:	74 07                	je     800c46 <strfind+0x16>
		if (*s == c)
  800c3f:	38 ca                	cmp    %cl,%dl
  800c41:	74 03                	je     800c46 <strfind+0x16>
	for (; *s; s++)
  800c43:	40                   	inc    %eax
  800c44:	eb f3                	jmp    800c39 <strfind+0x9>
			break;
	return (char *) s;
}
  800c46:	5d                   	pop    %ebp
  800c47:	c3                   	ret    

00800c48 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800c48:	55                   	push   %ebp
  800c49:	89 e5                	mov    %esp,%ebp
  800c4b:	57                   	push   %edi
  800c4c:	56                   	push   %esi
  800c4d:	53                   	push   %ebx
  800c4e:	8b 7d 08             	mov    0x8(%ebp),%edi
  800c51:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800c54:	85 c9                	test   %ecx,%ecx
  800c56:	74 13                	je     800c6b <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800c58:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800c5e:	75 05                	jne    800c65 <memset+0x1d>
  800c60:	f6 c1 03             	test   $0x3,%cl
  800c63:	74 0d                	je     800c72 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800c65:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c68:	fc                   	cld    
  800c69:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800c6b:	89 f8                	mov    %edi,%eax
  800c6d:	5b                   	pop    %ebx
  800c6e:	5e                   	pop    %esi
  800c6f:	5f                   	pop    %edi
  800c70:	5d                   	pop    %ebp
  800c71:	c3                   	ret    
		c &= 0xFF;
  800c72:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800c76:	89 d3                	mov    %edx,%ebx
  800c78:	c1 e3 08             	shl    $0x8,%ebx
  800c7b:	89 d0                	mov    %edx,%eax
  800c7d:	c1 e0 18             	shl    $0x18,%eax
  800c80:	89 d6                	mov    %edx,%esi
  800c82:	c1 e6 10             	shl    $0x10,%esi
  800c85:	09 f0                	or     %esi,%eax
  800c87:	09 c2                	or     %eax,%edx
  800c89:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800c8b:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800c8e:	89 d0                	mov    %edx,%eax
  800c90:	fc                   	cld    
  800c91:	f3 ab                	rep stos %eax,%es:(%edi)
  800c93:	eb d6                	jmp    800c6b <memset+0x23>

00800c95 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800c95:	55                   	push   %ebp
  800c96:	89 e5                	mov    %esp,%ebp
  800c98:	57                   	push   %edi
  800c99:	56                   	push   %esi
  800c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9d:	8b 75 0c             	mov    0xc(%ebp),%esi
  800ca0:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca3:	39 c6                	cmp    %eax,%esi
  800ca5:	73 33                	jae    800cda <memmove+0x45>
  800ca7:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800caa:	39 d0                	cmp    %edx,%eax
  800cac:	73 2c                	jae    800cda <memmove+0x45>
		s += n;
		d += n;
  800cae:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cb1:	89 d6                	mov    %edx,%esi
  800cb3:	09 fe                	or     %edi,%esi
  800cb5:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800cbb:	75 13                	jne    800cd0 <memmove+0x3b>
  800cbd:	f6 c1 03             	test   $0x3,%cl
  800cc0:	75 0e                	jne    800cd0 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800cc2:	83 ef 04             	sub    $0x4,%edi
  800cc5:	8d 72 fc             	lea    -0x4(%edx),%esi
  800cc8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800ccb:	fd                   	std    
  800ccc:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cce:	eb 07                	jmp    800cd7 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800cd0:	4f                   	dec    %edi
  800cd1:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800cd4:	fd                   	std    
  800cd5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800cd7:	fc                   	cld    
  800cd8:	eb 13                	jmp    800ced <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800cda:	89 f2                	mov    %esi,%edx
  800cdc:	09 c2                	or     %eax,%edx
  800cde:	f6 c2 03             	test   $0x3,%dl
  800ce1:	75 05                	jne    800ce8 <memmove+0x53>
  800ce3:	f6 c1 03             	test   $0x3,%cl
  800ce6:	74 09                	je     800cf1 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800ce8:	89 c7                	mov    %eax,%edi
  800cea:	fc                   	cld    
  800ceb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800ced:	5e                   	pop    %esi
  800cee:	5f                   	pop    %edi
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800cf1:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800cf4:	89 c7                	mov    %eax,%edi
  800cf6:	fc                   	cld    
  800cf7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800cf9:	eb f2                	jmp    800ced <memmove+0x58>

00800cfb <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800cfb:	55                   	push   %ebp
  800cfc:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800cfe:	ff 75 10             	pushl  0x10(%ebp)
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	ff 75 08             	pushl  0x8(%ebp)
  800d07:	e8 89 ff ff ff       	call   800c95 <memmove>
}
  800d0c:	c9                   	leave  
  800d0d:	c3                   	ret    

00800d0e <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800d0e:	55                   	push   %ebp
  800d0f:	89 e5                	mov    %esp,%ebp
  800d11:	56                   	push   %esi
  800d12:	53                   	push   %ebx
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	89 c6                	mov    %eax,%esi
  800d18:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800d1b:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800d1e:	39 f0                	cmp    %esi,%eax
  800d20:	74 16                	je     800d38 <memcmp+0x2a>
		if (*s1 != *s2)
  800d22:	8a 08                	mov    (%eax),%cl
  800d24:	8a 1a                	mov    (%edx),%bl
  800d26:	38 d9                	cmp    %bl,%cl
  800d28:	75 04                	jne    800d2e <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800d2a:	40                   	inc    %eax
  800d2b:	42                   	inc    %edx
  800d2c:	eb f0                	jmp    800d1e <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800d2e:	0f b6 c1             	movzbl %cl,%eax
  800d31:	0f b6 db             	movzbl %bl,%ebx
  800d34:	29 d8                	sub    %ebx,%eax
  800d36:	eb 05                	jmp    800d3d <memcmp+0x2f>
	}

	return 0;
  800d38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3d:	5b                   	pop    %ebx
  800d3e:	5e                   	pop    %esi
  800d3f:	5d                   	pop    %ebp
  800d40:	c3                   	ret    

00800d41 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  800d41:	55                   	push   %ebp
  800d42:	89 e5                	mov    %esp,%ebp
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  800d4a:	89 c2                	mov    %eax,%edx
  800d4c:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  800d4f:	39 d0                	cmp    %edx,%eax
  800d51:	73 07                	jae    800d5a <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d53:	38 08                	cmp    %cl,(%eax)
  800d55:	74 03                	je     800d5a <memfind+0x19>
	for (; s < ends; s++)
  800d57:	40                   	inc    %eax
  800d58:	eb f5                	jmp    800d4f <memfind+0xe>
			break;
	return (void *) s;
}
  800d5a:	5d                   	pop    %ebp
  800d5b:	c3                   	ret    

00800d5c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5c:	55                   	push   %ebp
  800d5d:	89 e5                	mov    %esp,%ebp
  800d5f:	57                   	push   %edi
  800d60:	56                   	push   %esi
  800d61:	53                   	push   %ebx
  800d62:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d65:	eb 01                	jmp    800d68 <strtol+0xc>
		s++;
  800d67:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  800d68:	8a 01                	mov    (%ecx),%al
  800d6a:	3c 20                	cmp    $0x20,%al
  800d6c:	74 f9                	je     800d67 <strtol+0xb>
  800d6e:	3c 09                	cmp    $0x9,%al
  800d70:	74 f5                	je     800d67 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  800d72:	3c 2b                	cmp    $0x2b,%al
  800d74:	74 2b                	je     800da1 <strtol+0x45>
		s++;
	else if (*s == '-')
  800d76:	3c 2d                	cmp    $0x2d,%al
  800d78:	74 2f                	je     800da9 <strtol+0x4d>
	int neg = 0;
  800d7a:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800d7f:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  800d86:	75 12                	jne    800d9a <strtol+0x3e>
  800d88:	80 39 30             	cmpb   $0x30,(%ecx)
  800d8b:	74 24                	je     800db1 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  800d8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d91:	75 07                	jne    800d9a <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  800d93:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  800d9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d9f:	eb 4e                	jmp    800def <strtol+0x93>
		s++;
  800da1:	41                   	inc    %ecx
	int neg = 0;
  800da2:	bf 00 00 00 00       	mov    $0x0,%edi
  800da7:	eb d6                	jmp    800d7f <strtol+0x23>
		s++, neg = 1;
  800da9:	41                   	inc    %ecx
  800daa:	bf 01 00 00 00       	mov    $0x1,%edi
  800daf:	eb ce                	jmp    800d7f <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800db1:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  800db5:	74 10                	je     800dc7 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  800db7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbb:	75 dd                	jne    800d9a <strtol+0x3e>
		s++, base = 8;
  800dbd:	41                   	inc    %ecx
  800dbe:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dc5:	eb d3                	jmp    800d9a <strtol+0x3e>
		s += 2, base = 16;
  800dc7:	83 c1 02             	add    $0x2,%ecx
  800dca:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd1:	eb c7                	jmp    800d9a <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  800dd3:	8d 72 9f             	lea    -0x61(%edx),%esi
  800dd6:	89 f3                	mov    %esi,%ebx
  800dd8:	80 fb 19             	cmp    $0x19,%bl
  800ddb:	77 24                	ja     800e01 <strtol+0xa5>
			dig = *s - 'a' + 10;
  800ddd:	0f be d2             	movsbl %dl,%edx
  800de0:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  800de3:	3b 55 10             	cmp    0x10(%ebp),%edx
  800de6:	7d 2b                	jge    800e13 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  800de8:	41                   	inc    %ecx
  800de9:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ded:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  800def:	8a 11                	mov    (%ecx),%dl
  800df1:	8d 5a d0             	lea    -0x30(%edx),%ebx
  800df4:	80 fb 09             	cmp    $0x9,%bl
  800df7:	77 da                	ja     800dd3 <strtol+0x77>
			dig = *s - '0';
  800df9:	0f be d2             	movsbl %dl,%edx
  800dfc:	83 ea 30             	sub    $0x30,%edx
  800dff:	eb e2                	jmp    800de3 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  800e01:	8d 72 bf             	lea    -0x41(%edx),%esi
  800e04:	89 f3                	mov    %esi,%ebx
  800e06:	80 fb 19             	cmp    $0x19,%bl
  800e09:	77 08                	ja     800e13 <strtol+0xb7>
			dig = *s - 'A' + 10;
  800e0b:	0f be d2             	movsbl %dl,%edx
  800e0e:	83 ea 37             	sub    $0x37,%edx
  800e11:	eb d0                	jmp    800de3 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  800e13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e17:	74 05                	je     800e1e <strtol+0xc2>
		*endptr = (char *) s;
  800e19:	8b 75 0c             	mov    0xc(%ebp),%esi
  800e1c:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  800e1e:	85 ff                	test   %edi,%edi
  800e20:	74 02                	je     800e24 <strtol+0xc8>
  800e22:	f7 d8                	neg    %eax
}
  800e24:	5b                   	pop    %ebx
  800e25:	5e                   	pop    %esi
  800e26:	5f                   	pop    %edi
  800e27:	5d                   	pop    %ebp
  800e28:	c3                   	ret    

00800e29 <atoi>:

int
atoi(const char *s)
{
  800e29:	55                   	push   %ebp
  800e2a:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  800e2c:	6a 0a                	push   $0xa
  800e2e:	6a 00                	push   $0x0
  800e30:	ff 75 08             	pushl  0x8(%ebp)
  800e33:	e8 24 ff ff ff       	call   800d5c <strtol>
}
  800e38:	c9                   	leave  
  800e39:	c3                   	ret    

00800e3a <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  800e3a:	55                   	push   %ebp
  800e3b:	89 e5                	mov    %esp,%ebp
  800e3d:	57                   	push   %edi
  800e3e:	56                   	push   %esi
  800e3f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e40:	b8 00 00 00 00       	mov    $0x0,%eax
  800e45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e48:	8b 55 08             	mov    0x8(%ebp),%edx
  800e4b:	89 c3                	mov    %eax,%ebx
  800e4d:	89 c7                	mov    %eax,%edi
  800e4f:	89 c6                	mov    %eax,%esi
  800e51:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  800e53:	5b                   	pop    %ebx
  800e54:	5e                   	pop    %esi
  800e55:	5f                   	pop    %edi
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <sys_cgetc>:

int
sys_cgetc(void)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	57                   	push   %edi
  800e5c:	56                   	push   %esi
  800e5d:	53                   	push   %ebx
	asm volatile("int %1\n"
  800e5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800e63:	b8 01 00 00 00       	mov    $0x1,%eax
  800e68:	89 d1                	mov    %edx,%ecx
  800e6a:	89 d3                	mov    %edx,%ebx
  800e6c:	89 d7                	mov    %edx,%edi
  800e6e:	89 d6                	mov    %edx,%esi
  800e70:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800e72:	5b                   	pop    %ebx
  800e73:	5e                   	pop    %esi
  800e74:	5f                   	pop    %edi
  800e75:	5d                   	pop    %ebp
  800e76:	c3                   	ret    

00800e77 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	57                   	push   %edi
  800e7b:	56                   	push   %esi
  800e7c:	53                   	push   %ebx
  800e7d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800e80:	b9 00 00 00 00       	mov    $0x0,%ecx
  800e85:	b8 03 00 00 00       	mov    $0x3,%eax
  800e8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8d:	89 cb                	mov    %ecx,%ebx
  800e8f:	89 cf                	mov    %ecx,%edi
  800e91:	89 ce                	mov    %ecx,%esi
  800e93:	cd 30                	int    $0x30
	if(check && ret > 0)
  800e95:	85 c0                	test   %eax,%eax
  800e97:	7f 08                	jg     800ea1 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800e99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e9c:	5b                   	pop    %ebx
  800e9d:	5e                   	pop    %esi
  800e9e:	5f                   	pop    %edi
  800e9f:	5d                   	pop    %ebp
  800ea0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800ea1:	83 ec 0c             	sub    $0xc,%esp
  800ea4:	50                   	push   %eax
  800ea5:	6a 03                	push   $0x3
  800ea7:	68 7f 2b 80 00       	push   $0x802b7f
  800eac:	6a 23                	push   $0x23
  800eae:	68 9c 2b 80 00       	push   $0x802b9c
  800eb3:	e8 4f f5 ff ff       	call   800407 <_panic>

00800eb8 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800eb8:	55                   	push   %ebp
  800eb9:	89 e5                	mov    %esp,%ebp
  800ebb:	57                   	push   %edi
  800ebc:	56                   	push   %esi
  800ebd:	53                   	push   %ebx
	asm volatile("int %1\n"
  800ebe:	ba 00 00 00 00       	mov    $0x0,%edx
  800ec3:	b8 02 00 00 00       	mov    $0x2,%eax
  800ec8:	89 d1                	mov    %edx,%ecx
  800eca:	89 d3                	mov    %edx,%ebx
  800ecc:	89 d7                	mov    %edx,%edi
  800ece:	89 d6                	mov    %edx,%esi
  800ed0:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800ed2:	5b                   	pop    %ebx
  800ed3:	5e                   	pop    %esi
  800ed4:	5f                   	pop    %edi
  800ed5:	5d                   	pop    %ebp
  800ed6:	c3                   	ret    

00800ed7 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800ed7:	55                   	push   %ebp
  800ed8:	89 e5                	mov    %esp,%ebp
  800eda:	57                   	push   %edi
  800edb:	56                   	push   %esi
  800edc:	53                   	push   %ebx
  800edd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800ee0:	be 00 00 00 00       	mov    $0x0,%esi
  800ee5:	b8 04 00 00 00       	mov    $0x4,%eax
  800eea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800eed:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ef3:	89 f7                	mov    %esi,%edi
  800ef5:	cd 30                	int    $0x30
	if(check && ret > 0)
  800ef7:	85 c0                	test   %eax,%eax
  800ef9:	7f 08                	jg     800f03 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f03:	83 ec 0c             	sub    $0xc,%esp
  800f06:	50                   	push   %eax
  800f07:	6a 04                	push   $0x4
  800f09:	68 7f 2b 80 00       	push   $0x802b7f
  800f0e:	6a 23                	push   $0x23
  800f10:	68 9c 2b 80 00       	push   $0x802b9c
  800f15:	e8 ed f4 ff ff       	call   800407 <_panic>

00800f1a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800f1a:	55                   	push   %ebp
  800f1b:	89 e5                	mov    %esp,%ebp
  800f1d:	57                   	push   %edi
  800f1e:	56                   	push   %esi
  800f1f:	53                   	push   %ebx
  800f20:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f23:	b8 05 00 00 00       	mov    $0x5,%eax
  800f28:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f2e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800f31:	8b 7d 14             	mov    0x14(%ebp),%edi
  800f34:	8b 75 18             	mov    0x18(%ebp),%esi
  800f37:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f39:	85 c0                	test   %eax,%eax
  800f3b:	7f 08                	jg     800f45 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  800f3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f40:	5b                   	pop    %ebx
  800f41:	5e                   	pop    %esi
  800f42:	5f                   	pop    %edi
  800f43:	5d                   	pop    %ebp
  800f44:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f45:	83 ec 0c             	sub    $0xc,%esp
  800f48:	50                   	push   %eax
  800f49:	6a 05                	push   $0x5
  800f4b:	68 7f 2b 80 00       	push   $0x802b7f
  800f50:	6a 23                	push   $0x23
  800f52:	68 9c 2b 80 00       	push   $0x802b9c
  800f57:	e8 ab f4 ff ff       	call   800407 <_panic>

00800f5c <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	53                   	push   %ebx
  800f62:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800f65:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f6a:	b8 06 00 00 00       	mov    $0x6,%eax
  800f6f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f72:	8b 55 08             	mov    0x8(%ebp),%edx
  800f75:	89 df                	mov    %ebx,%edi
  800f77:	89 de                	mov    %ebx,%esi
  800f79:	cd 30                	int    $0x30
	if(check && ret > 0)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	7f 08                	jg     800f87 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800f7f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800f82:	5b                   	pop    %ebx
  800f83:	5e                   	pop    %esi
  800f84:	5f                   	pop    %edi
  800f85:	5d                   	pop    %ebp
  800f86:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800f87:	83 ec 0c             	sub    $0xc,%esp
  800f8a:	50                   	push   %eax
  800f8b:	6a 06                	push   $0x6
  800f8d:	68 7f 2b 80 00       	push   $0x802b7f
  800f92:	6a 23                	push   $0x23
  800f94:	68 9c 2b 80 00       	push   $0x802b9c
  800f99:	e8 69 f4 ff ff       	call   800407 <_panic>

00800f9e <sys_yield>:

void
sys_yield(void)
{
  800f9e:	55                   	push   %ebp
  800f9f:	89 e5                	mov    %esp,%ebp
  800fa1:	57                   	push   %edi
  800fa2:	56                   	push   %esi
  800fa3:	53                   	push   %ebx
	asm volatile("int %1\n"
  800fa4:	ba 00 00 00 00       	mov    $0x0,%edx
  800fa9:	b8 0b 00 00 00       	mov    $0xb,%eax
  800fae:	89 d1                	mov    %edx,%ecx
  800fb0:	89 d3                	mov    %edx,%ebx
  800fb2:	89 d7                	mov    %edx,%edi
  800fb4:	89 d6                	mov    %edx,%esi
  800fb6:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800fb8:	5b                   	pop    %ebx
  800fb9:	5e                   	pop    %esi
  800fba:	5f                   	pop    %edi
  800fbb:	5d                   	pop    %ebp
  800fbc:	c3                   	ret    

00800fbd <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800fbd:	55                   	push   %ebp
  800fbe:	89 e5                	mov    %esp,%ebp
  800fc0:	57                   	push   %edi
  800fc1:	56                   	push   %esi
  800fc2:	53                   	push   %ebx
  800fc3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800fc6:	bb 00 00 00 00       	mov    $0x0,%ebx
  800fcb:	b8 08 00 00 00       	mov    $0x8,%eax
  800fd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800fd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd6:	89 df                	mov    %ebx,%edi
  800fd8:	89 de                	mov    %ebx,%esi
  800fda:	cd 30                	int    $0x30
	if(check && ret > 0)
  800fdc:	85 c0                	test   %eax,%eax
  800fde:	7f 08                	jg     800fe8 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800fe0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800fe3:	5b                   	pop    %ebx
  800fe4:	5e                   	pop    %esi
  800fe5:	5f                   	pop    %edi
  800fe6:	5d                   	pop    %ebp
  800fe7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800fe8:	83 ec 0c             	sub    $0xc,%esp
  800feb:	50                   	push   %eax
  800fec:	6a 08                	push   $0x8
  800fee:	68 7f 2b 80 00       	push   $0x802b7f
  800ff3:	6a 23                	push   $0x23
  800ff5:	68 9c 2b 80 00       	push   $0x802b9c
  800ffa:	e8 08 f4 ff ff       	call   800407 <_panic>

00800fff <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800fff:	55                   	push   %ebp
  801000:	89 e5                	mov    %esp,%ebp
  801002:	57                   	push   %edi
  801003:	56                   	push   %esi
  801004:	53                   	push   %ebx
  801005:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801008:	b9 00 00 00 00       	mov    $0x0,%ecx
  80100d:	b8 0c 00 00 00       	mov    $0xc,%eax
  801012:	8b 55 08             	mov    0x8(%ebp),%edx
  801015:	89 cb                	mov    %ecx,%ebx
  801017:	89 cf                	mov    %ecx,%edi
  801019:	89 ce                	mov    %ecx,%esi
  80101b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80101d:	85 c0                	test   %eax,%eax
  80101f:	7f 08                	jg     801029 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  801021:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801024:	5b                   	pop    %ebx
  801025:	5e                   	pop    %esi
  801026:	5f                   	pop    %edi
  801027:	5d                   	pop    %ebp
  801028:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801029:	83 ec 0c             	sub    $0xc,%esp
  80102c:	50                   	push   %eax
  80102d:	6a 0c                	push   $0xc
  80102f:	68 7f 2b 80 00       	push   $0x802b7f
  801034:	6a 23                	push   $0x23
  801036:	68 9c 2b 80 00       	push   $0x802b9c
  80103b:	e8 c7 f3 ff ff       	call   800407 <_panic>

00801040 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	57                   	push   %edi
  801044:	56                   	push   %esi
  801045:	53                   	push   %ebx
  801046:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801049:	bb 00 00 00 00       	mov    $0x0,%ebx
  80104e:	b8 09 00 00 00       	mov    $0x9,%eax
  801053:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801056:	8b 55 08             	mov    0x8(%ebp),%edx
  801059:	89 df                	mov    %ebx,%edi
  80105b:	89 de                	mov    %ebx,%esi
  80105d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80105f:	85 c0                	test   %eax,%eax
  801061:	7f 08                	jg     80106b <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  801063:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801066:	5b                   	pop    %ebx
  801067:	5e                   	pop    %esi
  801068:	5f                   	pop    %edi
  801069:	5d                   	pop    %ebp
  80106a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80106b:	83 ec 0c             	sub    $0xc,%esp
  80106e:	50                   	push   %eax
  80106f:	6a 09                	push   $0x9
  801071:	68 7f 2b 80 00       	push   $0x802b7f
  801076:	6a 23                	push   $0x23
  801078:	68 9c 2b 80 00       	push   $0x802b9c
  80107d:	e8 85 f3 ff ff       	call   800407 <_panic>

00801082 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801082:	55                   	push   %ebp
  801083:	89 e5                	mov    %esp,%ebp
  801085:	57                   	push   %edi
  801086:	56                   	push   %esi
  801087:	53                   	push   %ebx
  801088:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80108b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801090:	b8 0a 00 00 00       	mov    $0xa,%eax
  801095:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801098:	8b 55 08             	mov    0x8(%ebp),%edx
  80109b:	89 df                	mov    %ebx,%edi
  80109d:	89 de                	mov    %ebx,%esi
  80109f:	cd 30                	int    $0x30
	if(check && ret > 0)
  8010a1:	85 c0                	test   %eax,%eax
  8010a3:	7f 08                	jg     8010ad <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  8010a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010a8:	5b                   	pop    %ebx
  8010a9:	5e                   	pop    %esi
  8010aa:	5f                   	pop    %edi
  8010ab:	5d                   	pop    %ebp
  8010ac:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8010ad:	83 ec 0c             	sub    $0xc,%esp
  8010b0:	50                   	push   %eax
  8010b1:	6a 0a                	push   $0xa
  8010b3:	68 7f 2b 80 00       	push   $0x802b7f
  8010b8:	6a 23                	push   $0x23
  8010ba:	68 9c 2b 80 00       	push   $0x802b9c
  8010bf:	e8 43 f3 ff ff       	call   800407 <_panic>

008010c4 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  8010c4:	55                   	push   %ebp
  8010c5:	89 e5                	mov    %esp,%ebp
  8010c7:	57                   	push   %edi
  8010c8:	56                   	push   %esi
  8010c9:	53                   	push   %ebx
	asm volatile("int %1\n"
  8010ca:	be 00 00 00 00       	mov    $0x0,%esi
  8010cf:	b8 0d 00 00 00       	mov    $0xd,%eax
  8010d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8010d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8010da:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8010dd:	8b 7d 14             	mov    0x14(%ebp),%edi
  8010e0:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8010e2:	5b                   	pop    %ebx
  8010e3:	5e                   	pop    %esi
  8010e4:	5f                   	pop    %edi
  8010e5:	5d                   	pop    %ebp
  8010e6:	c3                   	ret    

008010e7 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8010e7:	55                   	push   %ebp
  8010e8:	89 e5                	mov    %esp,%ebp
  8010ea:	57                   	push   %edi
  8010eb:	56                   	push   %esi
  8010ec:	53                   	push   %ebx
  8010ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8010f0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010f5:	b8 0e 00 00 00       	mov    $0xe,%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 cb                	mov    %ecx,%ebx
  8010ff:	89 cf                	mov    %ecx,%edi
  801101:	89 ce                	mov    %ecx,%esi
  801103:	cd 30                	int    $0x30
	if(check && ret > 0)
  801105:	85 c0                	test   %eax,%eax
  801107:	7f 08                	jg     801111 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801109:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80110c:	5b                   	pop    %ebx
  80110d:	5e                   	pop    %esi
  80110e:	5f                   	pop    %edi
  80110f:	5d                   	pop    %ebp
  801110:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801111:	83 ec 0c             	sub    $0xc,%esp
  801114:	50                   	push   %eax
  801115:	6a 0e                	push   $0xe
  801117:	68 7f 2b 80 00       	push   $0x802b7f
  80111c:	6a 23                	push   $0x23
  80111e:	68 9c 2b 80 00       	push   $0x802b9c
  801123:	e8 df f2 ff ff       	call   800407 <_panic>

00801128 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80112e:	be 00 00 00 00       	mov    $0x0,%esi
  801133:	b8 0f 00 00 00       	mov    $0xf,%eax
  801138:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80113b:	8b 55 08             	mov    0x8(%ebp),%edx
  80113e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801141:	89 f7                	mov    %esi,%edi
  801143:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801145:	5b                   	pop    %ebx
  801146:	5e                   	pop    %esi
  801147:	5f                   	pop    %edi
  801148:	5d                   	pop    %ebp
  801149:	c3                   	ret    

0080114a <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  80114a:	55                   	push   %ebp
  80114b:	89 e5                	mov    %esp,%ebp
  80114d:	57                   	push   %edi
  80114e:	56                   	push   %esi
  80114f:	53                   	push   %ebx
	asm volatile("int %1\n"
  801150:	be 00 00 00 00       	mov    $0x0,%esi
  801155:	b8 10 00 00 00       	mov    $0x10,%eax
  80115a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801163:	89 f7                	mov    %esi,%edi
  801165:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  801167:	5b                   	pop    %ebx
  801168:	5e                   	pop    %esi
  801169:	5f                   	pop    %edi
  80116a:	5d                   	pop    %ebp
  80116b:	c3                   	ret    

0080116c <sys_set_console_color>:

void sys_set_console_color(int color) {
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	57                   	push   %edi
  801170:	56                   	push   %esi
  801171:	53                   	push   %ebx
	asm volatile("int %1\n"
  801172:	b9 00 00 00 00       	mov    $0x0,%ecx
  801177:	b8 11 00 00 00       	mov    $0x11,%eax
  80117c:	8b 55 08             	mov    0x8(%ebp),%edx
  80117f:	89 cb                	mov    %ecx,%ebx
  801181:	89 cf                	mov    %ecx,%edi
  801183:	89 ce                	mov    %ecx,%esi
  801185:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  801187:	5b                   	pop    %ebx
  801188:	5e                   	pop    %esi
  801189:	5f                   	pop    %edi
  80118a:	5d                   	pop    %ebp
  80118b:	c3                   	ret    

0080118c <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	05 00 00 00 30       	add    $0x30000000,%eax
  801197:	c1 e8 0c             	shr    $0xc,%eax
}
  80119a:	5d                   	pop    %ebp
  80119b:	c3                   	ret    

0080119c <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  8011a7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ac:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  8011b1:	5d                   	pop    %ebp
  8011b2:	c3                   	ret    

008011b3 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8011b3:	55                   	push   %ebp
  8011b4:	89 e5                	mov    %esp,%ebp
  8011b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b9:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8011be:	89 c2                	mov    %eax,%edx
  8011c0:	c1 ea 16             	shr    $0x16,%edx
  8011c3:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8011ca:	f6 c2 01             	test   $0x1,%dl
  8011cd:	74 2a                	je     8011f9 <fd_alloc+0x46>
  8011cf:	89 c2                	mov    %eax,%edx
  8011d1:	c1 ea 0c             	shr    $0xc,%edx
  8011d4:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8011db:	f6 c2 01             	test   $0x1,%dl
  8011de:	74 19                	je     8011f9 <fd_alloc+0x46>
  8011e0:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8011e5:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8011ea:	75 d2                	jne    8011be <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8011ec:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8011f2:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8011f7:	eb 07                	jmp    801200 <fd_alloc+0x4d>
			*fd_store = fd;
  8011f9:	89 01                	mov    %eax,(%ecx)
			return 0;
  8011fb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801200:	5d                   	pop    %ebp
  801201:	c3                   	ret    

00801202 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801202:	55                   	push   %ebp
  801203:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801205:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801209:	77 39                	ja     801244 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	c1 e0 0c             	shl    $0xc,%eax
  801211:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801216:	89 c2                	mov    %eax,%edx
  801218:	c1 ea 16             	shr    $0x16,%edx
  80121b:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801222:	f6 c2 01             	test   $0x1,%dl
  801225:	74 24                	je     80124b <fd_lookup+0x49>
  801227:	89 c2                	mov    %eax,%edx
  801229:	c1 ea 0c             	shr    $0xc,%edx
  80122c:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801233:	f6 c2 01             	test   $0x1,%dl
  801236:	74 1a                	je     801252 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801238:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123b:	89 02                	mov    %eax,(%edx)
	return 0;
  80123d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801242:	5d                   	pop    %ebp
  801243:	c3                   	ret    
		return -E_INVAL;
  801244:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801249:	eb f7                	jmp    801242 <fd_lookup+0x40>
		return -E_INVAL;
  80124b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801250:	eb f0                	jmp    801242 <fd_lookup+0x40>
  801252:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801257:	eb e9                	jmp    801242 <fd_lookup+0x40>

00801259 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801259:	55                   	push   %ebp
  80125a:	89 e5                	mov    %esp,%ebp
  80125c:	83 ec 08             	sub    $0x8,%esp
  80125f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801262:	ba 28 2c 80 00       	mov    $0x802c28,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801267:	b8 90 47 80 00       	mov    $0x804790,%eax
		if (devtab[i]->dev_id == dev_id) {
  80126c:	39 08                	cmp    %ecx,(%eax)
  80126e:	74 33                	je     8012a3 <dev_lookup+0x4a>
  801270:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801273:	8b 02                	mov    (%edx),%eax
  801275:	85 c0                	test   %eax,%eax
  801277:	75 f3                	jne    80126c <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801279:	a1 90 67 80 00       	mov    0x806790,%eax
  80127e:	8b 40 48             	mov    0x48(%eax),%eax
  801281:	83 ec 04             	sub    $0x4,%esp
  801284:	51                   	push   %ecx
  801285:	50                   	push   %eax
  801286:	68 ac 2b 80 00       	push   $0x802bac
  80128b:	e8 8a f2 ff ff       	call   80051a <cprintf>
	*dev = 0;
  801290:	8b 45 0c             	mov    0xc(%ebp),%eax
  801293:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801299:	83 c4 10             	add    $0x10,%esp
  80129c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  8012a1:	c9                   	leave  
  8012a2:	c3                   	ret    
			*dev = devtab[i];
  8012a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012a6:	89 01                	mov    %eax,(%ecx)
			return 0;
  8012a8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012ad:	eb f2                	jmp    8012a1 <dev_lookup+0x48>

008012af <fd_close>:
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	57                   	push   %edi
  8012b3:	56                   	push   %esi
  8012b4:	53                   	push   %ebx
  8012b5:	83 ec 1c             	sub    $0x1c,%esp
  8012b8:	8b 75 08             	mov    0x8(%ebp),%esi
  8012bb:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012be:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8012c1:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8012c2:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8012c8:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8012cb:	50                   	push   %eax
  8012cc:	e8 31 ff ff ff       	call   801202 <fd_lookup>
  8012d1:	89 c7                	mov    %eax,%edi
  8012d3:	83 c4 08             	add    $0x8,%esp
  8012d6:	85 c0                	test   %eax,%eax
  8012d8:	78 05                	js     8012df <fd_close+0x30>
	    || fd != fd2)
  8012da:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8012dd:	74 13                	je     8012f2 <fd_close+0x43>
		return (must_exist ? r : 0);
  8012df:	84 db                	test   %bl,%bl
  8012e1:	75 05                	jne    8012e8 <fd_close+0x39>
  8012e3:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8012e8:	89 f8                	mov    %edi,%eax
  8012ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012ed:	5b                   	pop    %ebx
  8012ee:	5e                   	pop    %esi
  8012ef:	5f                   	pop    %edi
  8012f0:	5d                   	pop    %ebp
  8012f1:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8012f2:	83 ec 08             	sub    $0x8,%esp
  8012f5:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8012f8:	50                   	push   %eax
  8012f9:	ff 36                	pushl  (%esi)
  8012fb:	e8 59 ff ff ff       	call   801259 <dev_lookup>
  801300:	89 c7                	mov    %eax,%edi
  801302:	83 c4 10             	add    $0x10,%esp
  801305:	85 c0                	test   %eax,%eax
  801307:	78 15                	js     80131e <fd_close+0x6f>
		if (dev->dev_close)
  801309:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80130c:	8b 40 10             	mov    0x10(%eax),%eax
  80130f:	85 c0                	test   %eax,%eax
  801311:	74 1b                	je     80132e <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801313:	83 ec 0c             	sub    $0xc,%esp
  801316:	56                   	push   %esi
  801317:	ff d0                	call   *%eax
  801319:	89 c7                	mov    %eax,%edi
  80131b:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80131e:	83 ec 08             	sub    $0x8,%esp
  801321:	56                   	push   %esi
  801322:	6a 00                	push   $0x0
  801324:	e8 33 fc ff ff       	call   800f5c <sys_page_unmap>
	return r;
  801329:	83 c4 10             	add    $0x10,%esp
  80132c:	eb ba                	jmp    8012e8 <fd_close+0x39>
			r = 0;
  80132e:	bf 00 00 00 00       	mov    $0x0,%edi
  801333:	eb e9                	jmp    80131e <fd_close+0x6f>

00801335 <close>:

int
close(int fdnum)
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80133b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80133e:	50                   	push   %eax
  80133f:	ff 75 08             	pushl  0x8(%ebp)
  801342:	e8 bb fe ff ff       	call   801202 <fd_lookup>
  801347:	83 c4 08             	add    $0x8,%esp
  80134a:	85 c0                	test   %eax,%eax
  80134c:	78 10                	js     80135e <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80134e:	83 ec 08             	sub    $0x8,%esp
  801351:	6a 01                	push   $0x1
  801353:	ff 75 f4             	pushl  -0xc(%ebp)
  801356:	e8 54 ff ff ff       	call   8012af <fd_close>
  80135b:	83 c4 10             	add    $0x10,%esp
}
  80135e:	c9                   	leave  
  80135f:	c3                   	ret    

00801360 <close_all>:

void
close_all(void)
{
  801360:	55                   	push   %ebp
  801361:	89 e5                	mov    %esp,%ebp
  801363:	53                   	push   %ebx
  801364:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801367:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80136c:	83 ec 0c             	sub    $0xc,%esp
  80136f:	53                   	push   %ebx
  801370:	e8 c0 ff ff ff       	call   801335 <close>
	for (i = 0; i < MAXFD; i++)
  801375:	43                   	inc    %ebx
  801376:	83 c4 10             	add    $0x10,%esp
  801379:	83 fb 20             	cmp    $0x20,%ebx
  80137c:	75 ee                	jne    80136c <close_all+0xc>
}
  80137e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801381:	c9                   	leave  
  801382:	c3                   	ret    

00801383 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801383:	55                   	push   %ebp
  801384:	89 e5                	mov    %esp,%ebp
  801386:	57                   	push   %edi
  801387:	56                   	push   %esi
  801388:	53                   	push   %ebx
  801389:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80138c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80138f:	50                   	push   %eax
  801390:	ff 75 08             	pushl  0x8(%ebp)
  801393:	e8 6a fe ff ff       	call   801202 <fd_lookup>
  801398:	89 c3                	mov    %eax,%ebx
  80139a:	83 c4 08             	add    $0x8,%esp
  80139d:	85 c0                	test   %eax,%eax
  80139f:	0f 88 81 00 00 00    	js     801426 <dup+0xa3>
		return r;
	close(newfdnum);
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 85 ff ff ff       	call   801335 <close>

	newfd = INDEX2FD(newfdnum);
  8013b0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8013b3:	c1 e6 0c             	shl    $0xc,%esi
  8013b6:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8013bc:	83 c4 04             	add    $0x4,%esp
  8013bf:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013c2:	e8 d5 fd ff ff       	call   80119c <fd2data>
  8013c7:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8013c9:	89 34 24             	mov    %esi,(%esp)
  8013cc:	e8 cb fd ff ff       	call   80119c <fd2data>
  8013d1:	83 c4 10             	add    $0x10,%esp
  8013d4:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8013d6:	89 d8                	mov    %ebx,%eax
  8013d8:	c1 e8 16             	shr    $0x16,%eax
  8013db:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8013e2:	a8 01                	test   $0x1,%al
  8013e4:	74 11                	je     8013f7 <dup+0x74>
  8013e6:	89 d8                	mov    %ebx,%eax
  8013e8:	c1 e8 0c             	shr    $0xc,%eax
  8013eb:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8013f2:	f6 c2 01             	test   $0x1,%dl
  8013f5:	75 39                	jne    801430 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8013f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8013fa:	89 d0                	mov    %edx,%eax
  8013fc:	c1 e8 0c             	shr    $0xc,%eax
  8013ff:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801406:	83 ec 0c             	sub    $0xc,%esp
  801409:	25 07 0e 00 00       	and    $0xe07,%eax
  80140e:	50                   	push   %eax
  80140f:	56                   	push   %esi
  801410:	6a 00                	push   $0x0
  801412:	52                   	push   %edx
  801413:	6a 00                	push   $0x0
  801415:	e8 00 fb ff ff       	call   800f1a <sys_page_map>
  80141a:	89 c3                	mov    %eax,%ebx
  80141c:	83 c4 20             	add    $0x20,%esp
  80141f:	85 c0                	test   %eax,%eax
  801421:	78 31                	js     801454 <dup+0xd1>
		goto err;

	return newfdnum;
  801423:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801426:	89 d8                	mov    %ebx,%eax
  801428:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80142b:	5b                   	pop    %ebx
  80142c:	5e                   	pop    %esi
  80142d:	5f                   	pop    %edi
  80142e:	5d                   	pop    %ebp
  80142f:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801430:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801437:	83 ec 0c             	sub    $0xc,%esp
  80143a:	25 07 0e 00 00       	and    $0xe07,%eax
  80143f:	50                   	push   %eax
  801440:	57                   	push   %edi
  801441:	6a 00                	push   $0x0
  801443:	53                   	push   %ebx
  801444:	6a 00                	push   $0x0
  801446:	e8 cf fa ff ff       	call   800f1a <sys_page_map>
  80144b:	89 c3                	mov    %eax,%ebx
  80144d:	83 c4 20             	add    $0x20,%esp
  801450:	85 c0                	test   %eax,%eax
  801452:	79 a3                	jns    8013f7 <dup+0x74>
	sys_page_unmap(0, newfd);
  801454:	83 ec 08             	sub    $0x8,%esp
  801457:	56                   	push   %esi
  801458:	6a 00                	push   $0x0
  80145a:	e8 fd fa ff ff       	call   800f5c <sys_page_unmap>
	sys_page_unmap(0, nva);
  80145f:	83 c4 08             	add    $0x8,%esp
  801462:	57                   	push   %edi
  801463:	6a 00                	push   $0x0
  801465:	e8 f2 fa ff ff       	call   800f5c <sys_page_unmap>
	return r;
  80146a:	83 c4 10             	add    $0x10,%esp
  80146d:	eb b7                	jmp    801426 <dup+0xa3>

0080146f <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80146f:	55                   	push   %ebp
  801470:	89 e5                	mov    %esp,%ebp
  801472:	53                   	push   %ebx
  801473:	83 ec 14             	sub    $0x14,%esp
  801476:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801479:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80147c:	50                   	push   %eax
  80147d:	53                   	push   %ebx
  80147e:	e8 7f fd ff ff       	call   801202 <fd_lookup>
  801483:	83 c4 08             	add    $0x8,%esp
  801486:	85 c0                	test   %eax,%eax
  801488:	78 3f                	js     8014c9 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80148a:	83 ec 08             	sub    $0x8,%esp
  80148d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801490:	50                   	push   %eax
  801491:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801494:	ff 30                	pushl  (%eax)
  801496:	e8 be fd ff ff       	call   801259 <dev_lookup>
  80149b:	83 c4 10             	add    $0x10,%esp
  80149e:	85 c0                	test   %eax,%eax
  8014a0:	78 27                	js     8014c9 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  8014a2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014a5:	8b 42 08             	mov    0x8(%edx),%eax
  8014a8:	83 e0 03             	and    $0x3,%eax
  8014ab:	83 f8 01             	cmp    $0x1,%eax
  8014ae:	74 1e                	je     8014ce <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  8014b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b3:	8b 40 08             	mov    0x8(%eax),%eax
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	74 35                	je     8014ef <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8014ba:	83 ec 04             	sub    $0x4,%esp
  8014bd:	ff 75 10             	pushl  0x10(%ebp)
  8014c0:	ff 75 0c             	pushl  0xc(%ebp)
  8014c3:	52                   	push   %edx
  8014c4:	ff d0                	call   *%eax
  8014c6:	83 c4 10             	add    $0x10,%esp
}
  8014c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8014cc:	c9                   	leave  
  8014cd:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8014ce:	a1 90 67 80 00       	mov    0x806790,%eax
  8014d3:	8b 40 48             	mov    0x48(%eax),%eax
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	53                   	push   %ebx
  8014da:	50                   	push   %eax
  8014db:	68 ed 2b 80 00       	push   $0x802bed
  8014e0:	e8 35 f0 ff ff       	call   80051a <cprintf>
		return -E_INVAL;
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8014ed:	eb da                	jmp    8014c9 <read+0x5a>
		return -E_NOT_SUPP;
  8014ef:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8014f4:	eb d3                	jmp    8014c9 <read+0x5a>

008014f6 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8014f6:	55                   	push   %ebp
  8014f7:	89 e5                	mov    %esp,%ebp
  8014f9:	57                   	push   %edi
  8014fa:	56                   	push   %esi
  8014fb:	53                   	push   %ebx
  8014fc:	83 ec 0c             	sub    $0xc,%esp
  8014ff:	8b 7d 08             	mov    0x8(%ebp),%edi
  801502:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  801505:	bb 00 00 00 00       	mov    $0x0,%ebx
  80150a:	39 f3                	cmp    %esi,%ebx
  80150c:	73 25                	jae    801533 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80150e:	83 ec 04             	sub    $0x4,%esp
  801511:	89 f0                	mov    %esi,%eax
  801513:	29 d8                	sub    %ebx,%eax
  801515:	50                   	push   %eax
  801516:	89 d8                	mov    %ebx,%eax
  801518:	03 45 0c             	add    0xc(%ebp),%eax
  80151b:	50                   	push   %eax
  80151c:	57                   	push   %edi
  80151d:	e8 4d ff ff ff       	call   80146f <read>
		if (m < 0)
  801522:	83 c4 10             	add    $0x10,%esp
  801525:	85 c0                	test   %eax,%eax
  801527:	78 08                	js     801531 <readn+0x3b>
			return m;
		if (m == 0)
  801529:	85 c0                	test   %eax,%eax
  80152b:	74 06                	je     801533 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80152d:	01 c3                	add    %eax,%ebx
  80152f:	eb d9                	jmp    80150a <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  801531:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801533:	89 d8                	mov    %ebx,%eax
  801535:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801538:	5b                   	pop    %ebx
  801539:	5e                   	pop    %esi
  80153a:	5f                   	pop    %edi
  80153b:	5d                   	pop    %ebp
  80153c:	c3                   	ret    

0080153d <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80153d:	55                   	push   %ebp
  80153e:	89 e5                	mov    %esp,%ebp
  801540:	53                   	push   %ebx
  801541:	83 ec 14             	sub    $0x14,%esp
  801544:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801547:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80154a:	50                   	push   %eax
  80154b:	53                   	push   %ebx
  80154c:	e8 b1 fc ff ff       	call   801202 <fd_lookup>
  801551:	83 c4 08             	add    $0x8,%esp
  801554:	85 c0                	test   %eax,%eax
  801556:	78 3a                	js     801592 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801558:	83 ec 08             	sub    $0x8,%esp
  80155b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80155e:	50                   	push   %eax
  80155f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801562:	ff 30                	pushl  (%eax)
  801564:	e8 f0 fc ff ff       	call   801259 <dev_lookup>
  801569:	83 c4 10             	add    $0x10,%esp
  80156c:	85 c0                	test   %eax,%eax
  80156e:	78 22                	js     801592 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801577:	74 1e                	je     801597 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801579:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157c:	8b 52 0c             	mov    0xc(%edx),%edx
  80157f:	85 d2                	test   %edx,%edx
  801581:	74 35                	je     8015b8 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801583:	83 ec 04             	sub    $0x4,%esp
  801586:	ff 75 10             	pushl  0x10(%ebp)
  801589:	ff 75 0c             	pushl  0xc(%ebp)
  80158c:	50                   	push   %eax
  80158d:	ff d2                	call   *%edx
  80158f:	83 c4 10             	add    $0x10,%esp
}
  801592:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801595:	c9                   	leave  
  801596:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801597:	a1 90 67 80 00       	mov    0x806790,%eax
  80159c:	8b 40 48             	mov    0x48(%eax),%eax
  80159f:	83 ec 04             	sub    $0x4,%esp
  8015a2:	53                   	push   %ebx
  8015a3:	50                   	push   %eax
  8015a4:	68 09 2c 80 00       	push   $0x802c09
  8015a9:	e8 6c ef ff ff       	call   80051a <cprintf>
		return -E_INVAL;
  8015ae:	83 c4 10             	add    $0x10,%esp
  8015b1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8015b6:	eb da                	jmp    801592 <write+0x55>
		return -E_NOT_SUPP;
  8015b8:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8015bd:	eb d3                	jmp    801592 <write+0x55>

008015bf <seek>:

int
seek(int fdnum, off_t offset)
{
  8015bf:	55                   	push   %ebp
  8015c0:	89 e5                	mov    %esp,%ebp
  8015c2:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8015c5:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8015c8:	50                   	push   %eax
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 31 fc ff ff       	call   801202 <fd_lookup>
  8015d1:	83 c4 08             	add    $0x8,%esp
  8015d4:	85 c0                	test   %eax,%eax
  8015d6:	78 0e                	js     8015e6 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8015d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015de:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8015e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015e6:	c9                   	leave  
  8015e7:	c3                   	ret    

008015e8 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
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
  8015f7:	e8 06 fc ff ff       	call   801202 <fd_lookup>
  8015fc:	83 c4 08             	add    $0x8,%esp
  8015ff:	85 c0                	test   %eax,%eax
  801601:	78 37                	js     80163a <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801603:	83 ec 08             	sub    $0x8,%esp
  801606:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801609:	50                   	push   %eax
  80160a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160d:	ff 30                	pushl  (%eax)
  80160f:	e8 45 fc ff ff       	call   801259 <dev_lookup>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	85 c0                	test   %eax,%eax
  801619:	78 1f                	js     80163a <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80161b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161e:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801622:	74 1b                	je     80163f <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801624:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801627:	8b 52 18             	mov    0x18(%edx),%edx
  80162a:	85 d2                	test   %edx,%edx
  80162c:	74 32                	je     801660 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80162e:	83 ec 08             	sub    $0x8,%esp
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	50                   	push   %eax
  801635:	ff d2                	call   *%edx
  801637:	83 c4 10             	add    $0x10,%esp
}
  80163a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    
			thisenv->env_id, fdnum);
  80163f:	a1 90 67 80 00       	mov    0x806790,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801644:	8b 40 48             	mov    0x48(%eax),%eax
  801647:	83 ec 04             	sub    $0x4,%esp
  80164a:	53                   	push   %ebx
  80164b:	50                   	push   %eax
  80164c:	68 cc 2b 80 00       	push   $0x802bcc
  801651:	e8 c4 ee ff ff       	call   80051a <cprintf>
		return -E_INVAL;
  801656:	83 c4 10             	add    $0x10,%esp
  801659:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80165e:	eb da                	jmp    80163a <ftruncate+0x52>
		return -E_NOT_SUPP;
  801660:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801665:	eb d3                	jmp    80163a <ftruncate+0x52>

00801667 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801667:	55                   	push   %ebp
  801668:	89 e5                	mov    %esp,%ebp
  80166a:	53                   	push   %ebx
  80166b:	83 ec 14             	sub    $0x14,%esp
  80166e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801671:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801674:	50                   	push   %eax
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 85 fb ff ff       	call   801202 <fd_lookup>
  80167d:	83 c4 08             	add    $0x8,%esp
  801680:	85 c0                	test   %eax,%eax
  801682:	78 4b                	js     8016cf <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801684:	83 ec 08             	sub    $0x8,%esp
  801687:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80168a:	50                   	push   %eax
  80168b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168e:	ff 30                	pushl  (%eax)
  801690:	e8 c4 fb ff ff       	call   801259 <dev_lookup>
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 c0                	test   %eax,%eax
  80169a:	78 33                	js     8016cf <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80169c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80169f:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8016a3:	74 2f                	je     8016d4 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8016a5:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  8016a8:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  8016af:	00 00 00 
	stat->st_type = 0;
  8016b2:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  8016b9:	00 00 00 
	stat->st_dev = dev;
  8016bc:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  8016c2:	83 ec 08             	sub    $0x8,%esp
  8016c5:	53                   	push   %ebx
  8016c6:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c9:	ff 50 14             	call   *0x14(%eax)
  8016cc:	83 c4 10             	add    $0x10,%esp
}
  8016cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8016d2:	c9                   	leave  
  8016d3:	c3                   	ret    
		return -E_NOT_SUPP;
  8016d4:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8016d9:	eb f4                	jmp    8016cf <fstat+0x68>

008016db <stat>:

int
stat(const char *path, struct Stat *stat)
{
  8016db:	55                   	push   %ebp
  8016dc:	89 e5                	mov    %esp,%ebp
  8016de:	56                   	push   %esi
  8016df:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	6a 00                	push   $0x0
  8016e5:	ff 75 08             	pushl  0x8(%ebp)
  8016e8:	e8 34 02 00 00       	call   801921 <open>
  8016ed:	89 c3                	mov    %eax,%ebx
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	85 c0                	test   %eax,%eax
  8016f4:	78 1b                	js     801711 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  8016f6:	83 ec 08             	sub    $0x8,%esp
  8016f9:	ff 75 0c             	pushl  0xc(%ebp)
  8016fc:	50                   	push   %eax
  8016fd:	e8 65 ff ff ff       	call   801667 <fstat>
  801702:	89 c6                	mov    %eax,%esi
	close(fd);
  801704:	89 1c 24             	mov    %ebx,(%esp)
  801707:	e8 29 fc ff ff       	call   801335 <close>
	return r;
  80170c:	83 c4 10             	add    $0x10,%esp
  80170f:	89 f3                	mov    %esi,%ebx
}
  801711:	89 d8                	mov    %ebx,%eax
  801713:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801716:	5b                   	pop    %ebx
  801717:	5e                   	pop    %esi
  801718:	5d                   	pop    %ebp
  801719:	c3                   	ret    

0080171a <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
  80171f:	89 c6                	mov    %eax,%esi
  801721:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801723:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80172a:	74 27                	je     801753 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80172c:	6a 07                	push   $0x7
  80172e:	68 00 70 80 00       	push   $0x807000
  801733:	56                   	push   %esi
  801734:	ff 35 00 50 80 00    	pushl  0x805000
  80173a:	e8 93 0c 00 00       	call   8023d2 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  80173f:	83 c4 0c             	add    $0xc,%esp
  801742:	6a 00                	push   $0x0
  801744:	53                   	push   %ebx
  801745:	6a 00                	push   $0x0
  801747:	e8 fd 0b 00 00       	call   802349 <ipc_recv>
}
  80174c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80174f:	5b                   	pop    %ebx
  801750:	5e                   	pop    %esi
  801751:	5d                   	pop    %ebp
  801752:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801753:	83 ec 0c             	sub    $0xc,%esp
  801756:	6a 01                	push   $0x1
  801758:	e8 d1 0c 00 00       	call   80242e <ipc_find_env>
  80175d:	a3 00 50 80 00       	mov    %eax,0x805000
  801762:	83 c4 10             	add    $0x10,%esp
  801765:	eb c5                	jmp    80172c <fsipc+0x12>

00801767 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801767:	55                   	push   %ebp
  801768:	89 e5                	mov    %esp,%ebp
  80176a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  80176d:	8b 45 08             	mov    0x8(%ebp),%eax
  801770:	8b 40 0c             	mov    0xc(%eax),%eax
  801773:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.set_size.req_size = newsize;
  801778:	8b 45 0c             	mov    0xc(%ebp),%eax
  80177b:	a3 04 70 80 00       	mov    %eax,0x807004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801780:	ba 00 00 00 00       	mov    $0x0,%edx
  801785:	b8 02 00 00 00       	mov    $0x2,%eax
  80178a:	e8 8b ff ff ff       	call   80171a <fsipc>
}
  80178f:	c9                   	leave  
  801790:	c3                   	ret    

00801791 <devfile_flush>:
{
  801791:	55                   	push   %ebp
  801792:	89 e5                	mov    %esp,%ebp
  801794:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801797:	8b 45 08             	mov    0x8(%ebp),%eax
  80179a:	8b 40 0c             	mov    0xc(%eax),%eax
  80179d:	a3 00 70 80 00       	mov    %eax,0x807000
	return fsipc(FSREQ_FLUSH, NULL);
  8017a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017a7:	b8 06 00 00 00       	mov    $0x6,%eax
  8017ac:	e8 69 ff ff ff       	call   80171a <fsipc>
}
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <devfile_stat>:
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	53                   	push   %ebx
  8017b7:	83 ec 04             	sub    $0x4,%esp
  8017ba:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  8017bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8017c3:	a3 00 70 80 00       	mov    %eax,0x807000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  8017c8:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cd:	b8 05 00 00 00       	mov    $0x5,%eax
  8017d2:	e8 43 ff ff ff       	call   80171a <fsipc>
  8017d7:	85 c0                	test   %eax,%eax
  8017d9:	78 2c                	js     801807 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	68 00 70 80 00       	push   $0x807000
  8017e3:	53                   	push   %ebx
  8017e4:	e8 39 f3 ff ff       	call   800b22 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  8017e9:	a1 80 70 80 00       	mov    0x807080,%eax
  8017ee:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  8017f4:	a1 84 70 80 00       	mov    0x807084,%eax
  8017f9:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  8017ff:	83 c4 10             	add    $0x10,%esp
  801802:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801807:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <devfile_write>:
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
  80180f:	53                   	push   %ebx
  801810:	83 ec 04             	sub    $0x4,%esp
  801813:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801816:	89 d8                	mov    %ebx,%eax
  801818:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  80181e:	76 05                	jbe    801825 <devfile_write+0x19>
  801820:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801825:	8b 55 08             	mov    0x8(%ebp),%edx
  801828:	8b 52 0c             	mov    0xc(%edx),%edx
  80182b:	89 15 00 70 80 00    	mov    %edx,0x807000
	fsipcbuf.write.req_n = size;
  801831:	a3 04 70 80 00       	mov    %eax,0x807004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	50                   	push   %eax
  80183a:	ff 75 0c             	pushl  0xc(%ebp)
  80183d:	68 08 70 80 00       	push   $0x807008
  801842:	e8 4e f4 ff ff       	call   800c95 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801847:	ba 00 00 00 00       	mov    $0x0,%edx
  80184c:	b8 04 00 00 00       	mov    $0x4,%eax
  801851:	e8 c4 fe ff ff       	call   80171a <fsipc>
  801856:	83 c4 10             	add    $0x10,%esp
  801859:	85 c0                	test   %eax,%eax
  80185b:	78 0b                	js     801868 <devfile_write+0x5c>
	assert(r <= n);
  80185d:	39 c3                	cmp    %eax,%ebx
  80185f:	72 0c                	jb     80186d <devfile_write+0x61>
	assert(r <= PGSIZE);
  801861:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801866:	7f 1e                	jg     801886 <devfile_write+0x7a>
}
  801868:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    
	assert(r <= n);
  80186d:	68 38 2c 80 00       	push   $0x802c38
  801872:	68 3f 2c 80 00       	push   $0x802c3f
  801877:	68 98 00 00 00       	push   $0x98
  80187c:	68 54 2c 80 00       	push   $0x802c54
  801881:	e8 81 eb ff ff       	call   800407 <_panic>
	assert(r <= PGSIZE);
  801886:	68 5f 2c 80 00       	push   $0x802c5f
  80188b:	68 3f 2c 80 00       	push   $0x802c3f
  801890:	68 99 00 00 00       	push   $0x99
  801895:	68 54 2c 80 00       	push   $0x802c54
  80189a:	e8 68 eb ff ff       	call   800407 <_panic>

0080189f <devfile_read>:
{
  80189f:	55                   	push   %ebp
  8018a0:	89 e5                	mov    %esp,%ebp
  8018a2:	56                   	push   %esi
  8018a3:	53                   	push   %ebx
  8018a4:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  8018a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8018ad:	a3 00 70 80 00       	mov    %eax,0x807000
	fsipcbuf.read.req_n = n;
  8018b2:	89 35 04 70 80 00    	mov    %esi,0x807004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  8018b8:	ba 00 00 00 00       	mov    $0x0,%edx
  8018bd:	b8 03 00 00 00       	mov    $0x3,%eax
  8018c2:	e8 53 fe ff ff       	call   80171a <fsipc>
  8018c7:	89 c3                	mov    %eax,%ebx
  8018c9:	85 c0                	test   %eax,%eax
  8018cb:	78 1f                	js     8018ec <devfile_read+0x4d>
	assert(r <= n);
  8018cd:	39 c6                	cmp    %eax,%esi
  8018cf:	72 24                	jb     8018f5 <devfile_read+0x56>
	assert(r <= PGSIZE);
  8018d1:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8018d6:	7f 33                	jg     80190b <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  8018d8:	83 ec 04             	sub    $0x4,%esp
  8018db:	50                   	push   %eax
  8018dc:	68 00 70 80 00       	push   $0x807000
  8018e1:	ff 75 0c             	pushl  0xc(%ebp)
  8018e4:	e8 ac f3 ff ff       	call   800c95 <memmove>
	return r;
  8018e9:	83 c4 10             	add    $0x10,%esp
}
  8018ec:	89 d8                	mov    %ebx,%eax
  8018ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8018f1:	5b                   	pop    %ebx
  8018f2:	5e                   	pop    %esi
  8018f3:	5d                   	pop    %ebp
  8018f4:	c3                   	ret    
	assert(r <= n);
  8018f5:	68 38 2c 80 00       	push   $0x802c38
  8018fa:	68 3f 2c 80 00       	push   $0x802c3f
  8018ff:	6a 7c                	push   $0x7c
  801901:	68 54 2c 80 00       	push   $0x802c54
  801906:	e8 fc ea ff ff       	call   800407 <_panic>
	assert(r <= PGSIZE);
  80190b:	68 5f 2c 80 00       	push   $0x802c5f
  801910:	68 3f 2c 80 00       	push   $0x802c3f
  801915:	6a 7d                	push   $0x7d
  801917:	68 54 2c 80 00       	push   $0x802c54
  80191c:	e8 e6 ea ff ff       	call   800407 <_panic>

00801921 <open>:
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	56                   	push   %esi
  801925:	53                   	push   %ebx
  801926:	83 ec 1c             	sub    $0x1c,%esp
  801929:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  80192c:	56                   	push   %esi
  80192d:	e8 bd f1 ff ff       	call   800aef <strlen>
  801932:	83 c4 10             	add    $0x10,%esp
  801935:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  80193a:	7f 6c                	jg     8019a8 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  80193c:	83 ec 0c             	sub    $0xc,%esp
  80193f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801942:	50                   	push   %eax
  801943:	e8 6b f8 ff ff       	call   8011b3 <fd_alloc>
  801948:	89 c3                	mov    %eax,%ebx
  80194a:	83 c4 10             	add    $0x10,%esp
  80194d:	85 c0                	test   %eax,%eax
  80194f:	78 3c                	js     80198d <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801951:	83 ec 08             	sub    $0x8,%esp
  801954:	56                   	push   %esi
  801955:	68 00 70 80 00       	push   $0x807000
  80195a:	e8 c3 f1 ff ff       	call   800b22 <strcpy>
	fsipcbuf.open.req_omode = mode;
  80195f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801962:	a3 00 74 80 00       	mov    %eax,0x807400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	b8 01 00 00 00       	mov    $0x1,%eax
  80196f:	e8 a6 fd ff ff       	call   80171a <fsipc>
  801974:	89 c3                	mov    %eax,%ebx
  801976:	83 c4 10             	add    $0x10,%esp
  801979:	85 c0                	test   %eax,%eax
  80197b:	78 19                	js     801996 <open+0x75>
	return fd2num(fd);
  80197d:	83 ec 0c             	sub    $0xc,%esp
  801980:	ff 75 f4             	pushl  -0xc(%ebp)
  801983:	e8 04 f8 ff ff       	call   80118c <fd2num>
  801988:	89 c3                	mov    %eax,%ebx
  80198a:	83 c4 10             	add    $0x10,%esp
}
  80198d:	89 d8                	mov    %ebx,%eax
  80198f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801992:	5b                   	pop    %ebx
  801993:	5e                   	pop    %esi
  801994:	5d                   	pop    %ebp
  801995:	c3                   	ret    
		fd_close(fd, 0);
  801996:	83 ec 08             	sub    $0x8,%esp
  801999:	6a 00                	push   $0x0
  80199b:	ff 75 f4             	pushl  -0xc(%ebp)
  80199e:	e8 0c f9 ff ff       	call   8012af <fd_close>
		return r;
  8019a3:	83 c4 10             	add    $0x10,%esp
  8019a6:	eb e5                	jmp    80198d <open+0x6c>
		return -E_BAD_PATH;
  8019a8:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  8019ad:	eb de                	jmp    80198d <open+0x6c>

008019af <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  8019af:	55                   	push   %ebp
  8019b0:	89 e5                	mov    %esp,%ebp
  8019b2:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  8019b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ba:	b8 08 00 00 00       	mov    $0x8,%eax
  8019bf:	e8 56 fd ff ff       	call   80171a <fsipc>
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	57                   	push   %edi
  8019ca:	56                   	push   %esi
  8019cb:	53                   	push   %ebx
  8019cc:	81 ec 94 02 00 00    	sub    $0x294,%esp
  8019d2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  8019d5:	6a 00                	push   $0x0
  8019d7:	ff 75 08             	pushl  0x8(%ebp)
  8019da:	e8 42 ff ff ff       	call   801921 <open>
  8019df:	89 c1                	mov    %eax,%ecx
  8019e1:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  8019e7:	83 c4 10             	add    $0x10,%esp
  8019ea:	85 c0                	test   %eax,%eax
  8019ec:	0f 88 ba 04 00 00    	js     801eac <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  8019f2:	83 ec 04             	sub    $0x4,%esp
  8019f5:	68 00 02 00 00       	push   $0x200
  8019fa:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  801a00:	50                   	push   %eax
  801a01:	51                   	push   %ecx
  801a02:	e8 ef fa ff ff       	call   8014f6 <readn>
  801a07:	83 c4 10             	add    $0x10,%esp
  801a0a:	3d 00 02 00 00       	cmp    $0x200,%eax
  801a0f:	0f 85 93 00 00 00    	jne    801aa8 <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  801a15:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  801a1c:	45 4c 46 
  801a1f:	0f 85 83 00 00 00    	jne    801aa8 <spawn+0xe2>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  801a25:	b8 07 00 00 00       	mov    $0x7,%eax
  801a2a:	cd 30                	int    $0x30
  801a2c:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  801a32:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  801a38:	85 c0                	test   %eax,%eax
  801a3a:	0f 88 77 04 00 00    	js     801eb7 <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  801a40:	89 c2                	mov    %eax,%edx
  801a42:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  801a48:	89 d0                	mov    %edx,%eax
  801a4a:	c1 e0 05             	shl    $0x5,%eax
  801a4d:	29 d0                	sub    %edx,%eax
  801a4f:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  801a56:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  801a5c:	b9 11 00 00 00       	mov    $0x11,%ecx
  801a61:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  801a63:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  801a69:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  801a6f:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  801a74:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  801a79:	bf 00 00 00 00       	mov    $0x0,%edi
  801a7e:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  801a81:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  801a83:	89 d9                	mov    %ebx,%ecx
  801a85:	8d 72 04             	lea    0x4(%edx),%esi
  801a88:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a8b:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	74 48                	je     801adb <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  801a93:	83 ec 0c             	sub    $0xc,%esp
  801a96:	50                   	push   %eax
  801a97:	e8 53 f0 ff ff       	call   800aef <strlen>
  801a9c:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  801aa0:	43                   	inc    %ebx
  801aa1:	83 c4 10             	add    $0x10,%esp
  801aa4:	89 f2                	mov    %esi,%edx
  801aa6:	eb db                	jmp    801a83 <spawn+0xbd>
		close(fd);
  801aa8:	83 ec 0c             	sub    $0xc,%esp
  801aab:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801ab1:	e8 7f f8 ff ff       	call   801335 <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  801ab6:	83 c4 0c             	add    $0xc,%esp
  801ab9:	68 7f 45 4c 46       	push   $0x464c457f
  801abe:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  801ac4:	68 6b 2c 80 00       	push   $0x802c6b
  801ac9:	e8 4c ea ff ff       	call   80051a <cprintf>
		return -E_NOT_EXEC;
  801ace:	83 c4 10             	add    $0x10,%esp
  801ad1:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  801ad6:	e9 62 02 00 00       	jmp    801d3d <spawn+0x377>
  801adb:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  801ae1:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  801ae7:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  801aed:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  801af0:	be 00 10 40 00       	mov    $0x401000,%esi
  801af5:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  801af7:	89 f2                	mov    %esi,%edx
  801af9:	83 e2 fc             	and    $0xfffffffc,%edx
  801afc:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  801b03:	29 c2                	sub    %eax,%edx
  801b05:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  801b0b:	8d 42 f8             	lea    -0x8(%edx),%eax
  801b0e:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  801b13:	0f 86 a9 03 00 00    	jbe    801ec2 <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801b19:	83 ec 04             	sub    $0x4,%esp
  801b1c:	6a 07                	push   $0x7
  801b1e:	68 00 00 40 00       	push   $0x400000
  801b23:	6a 00                	push   $0x0
  801b25:	e8 ad f3 ff ff       	call   800ed7 <sys_page_alloc>
  801b2a:	89 c7                	mov    %eax,%edi
  801b2c:	83 c4 10             	add    $0x10,%esp
  801b2f:	85 c0                	test   %eax,%eax
  801b31:	0f 88 06 02 00 00    	js     801d3d <spawn+0x377>
  801b37:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  801b3c:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  801b42:	7e 30                	jle    801b74 <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  801b44:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  801b4a:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b50:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  801b53:	83 ec 08             	sub    $0x8,%esp
  801b56:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801b59:	56                   	push   %esi
  801b5a:	e8 c3 ef ff ff       	call   800b22 <strcpy>
		string_store += strlen(argv[i]) + 1;
  801b5f:	83 c4 04             	add    $0x4,%esp
  801b62:	ff 34 bb             	pushl  (%ebx,%edi,4)
  801b65:	e8 85 ef ff ff       	call   800aef <strlen>
  801b6a:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  801b6e:	47                   	inc    %edi
  801b6f:	83 c4 10             	add    $0x10,%esp
  801b72:	eb c8                	jmp    801b3c <spawn+0x176>
	}
	argv_store[argc] = 0;
  801b74:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801b7a:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  801b80:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  801b87:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  801b8d:	0f 85 8c 00 00 00    	jne    801c1f <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  801b93:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  801b99:	89 c8                	mov    %ecx,%eax
  801b9b:	2d 00 30 80 11       	sub    $0x11803000,%eax
  801ba0:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  801ba3:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  801ba9:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  801bac:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  801bb2:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  801bb8:	83 ec 0c             	sub    $0xc,%esp
  801bbb:	6a 07                	push   $0x7
  801bbd:	68 00 d0 bf ee       	push   $0xeebfd000
  801bc2:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801bc8:	68 00 00 40 00       	push   $0x400000
  801bcd:	6a 00                	push   $0x0
  801bcf:	e8 46 f3 ff ff       	call   800f1a <sys_page_map>
  801bd4:	89 c7                	mov    %eax,%edi
  801bd6:	83 c4 20             	add    $0x20,%esp
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	0f 88 3e 03 00 00    	js     801f1f <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  801be1:	83 ec 08             	sub    $0x8,%esp
  801be4:	68 00 00 40 00       	push   $0x400000
  801be9:	6a 00                	push   $0x0
  801beb:	e8 6c f3 ff ff       	call   800f5c <sys_page_unmap>
  801bf0:	89 c7                	mov    %eax,%edi
  801bf2:	83 c4 10             	add    $0x10,%esp
  801bf5:	85 c0                	test   %eax,%eax
  801bf7:	0f 88 22 03 00 00    	js     801f1f <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  801bfd:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  801c03:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  801c0a:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801c10:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  801c17:	00 00 00 
  801c1a:	e9 4a 01 00 00       	jmp    801d69 <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  801c1f:	68 f8 2c 80 00       	push   $0x802cf8
  801c24:	68 3f 2c 80 00       	push   $0x802c3f
  801c29:	68 f1 00 00 00       	push   $0xf1
  801c2e:	68 85 2c 80 00       	push   $0x802c85
  801c33:	e8 cf e7 ff ff       	call   800407 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  801c38:	83 ec 04             	sub    $0x4,%esp
  801c3b:	6a 07                	push   $0x7
  801c3d:	68 00 00 40 00       	push   $0x400000
  801c42:	6a 00                	push   $0x0
  801c44:	e8 8e f2 ff ff       	call   800ed7 <sys_page_alloc>
  801c49:	83 c4 10             	add    $0x10,%esp
  801c4c:	85 c0                	test   %eax,%eax
  801c4e:	0f 88 78 02 00 00    	js     801ecc <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  801c54:	83 ec 08             	sub    $0x8,%esp
  801c57:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  801c5d:	01 f8                	add    %edi,%eax
  801c5f:	50                   	push   %eax
  801c60:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c66:	e8 54 f9 ff ff       	call   8015bf <seek>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	85 c0                	test   %eax,%eax
  801c70:	0f 88 5d 02 00 00    	js     801ed3 <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  801c76:	83 ec 04             	sub    $0x4,%esp
  801c79:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  801c7f:	29 f8                	sub    %edi,%eax
  801c81:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c86:	76 05                	jbe    801c8d <spawn+0x2c7>
  801c88:	b8 00 10 00 00       	mov    $0x1000,%eax
  801c8d:	50                   	push   %eax
  801c8e:	68 00 00 40 00       	push   $0x400000
  801c93:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801c99:	e8 58 f8 ff ff       	call   8014f6 <readn>
  801c9e:	83 c4 10             	add    $0x10,%esp
  801ca1:	85 c0                	test   %eax,%eax
  801ca3:	0f 88 31 02 00 00    	js     801eda <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  801ca9:	83 ec 0c             	sub    $0xc,%esp
  801cac:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801cb2:	56                   	push   %esi
  801cb3:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801cb9:	68 00 00 40 00       	push   $0x400000
  801cbe:	6a 00                	push   $0x0
  801cc0:	e8 55 f2 ff ff       	call   800f1a <sys_page_map>
  801cc5:	83 c4 20             	add    $0x20,%esp
  801cc8:	85 c0                	test   %eax,%eax
  801cca:	78 7b                	js     801d47 <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  801ccc:	83 ec 08             	sub    $0x8,%esp
  801ccf:	68 00 00 40 00       	push   $0x400000
  801cd4:	6a 00                	push   $0x0
  801cd6:	e8 81 f2 ff ff       	call   800f5c <sys_page_unmap>
  801cdb:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  801cde:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801ce4:	81 c6 00 10 00 00    	add    $0x1000,%esi
  801cea:	89 df                	mov    %ebx,%edi
  801cec:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  801cf2:	73 68                	jae    801d5c <spawn+0x396>
		if (i >= filesz) {
  801cf4:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  801cfa:	0f 82 38 ff ff ff    	jb     801c38 <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  801d00:	83 ec 04             	sub    $0x4,%esp
  801d03:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  801d09:	56                   	push   %esi
  801d0a:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  801d10:	e8 c2 f1 ff ff       	call   800ed7 <sys_page_alloc>
  801d15:	83 c4 10             	add    $0x10,%esp
  801d18:	85 c0                	test   %eax,%eax
  801d1a:	79 c2                	jns    801cde <spawn+0x318>
  801d1c:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  801d1e:	83 ec 0c             	sub    $0xc,%esp
  801d21:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801d27:	e8 4b f1 ff ff       	call   800e77 <sys_env_destroy>
	close(fd);
  801d2c:	83 c4 04             	add    $0x4,%esp
  801d2f:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801d35:	e8 fb f5 ff ff       	call   801335 <close>
	return r;
  801d3a:	83 c4 10             	add    $0x10,%esp
}
  801d3d:	89 f8                	mov    %edi,%eax
  801d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d42:	5b                   	pop    %ebx
  801d43:	5e                   	pop    %esi
  801d44:	5f                   	pop    %edi
  801d45:	5d                   	pop    %ebp
  801d46:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  801d47:	50                   	push   %eax
  801d48:	68 91 2c 80 00       	push   $0x802c91
  801d4d:	68 24 01 00 00       	push   $0x124
  801d52:	68 85 2c 80 00       	push   $0x802c85
  801d57:	e8 ab e6 ff ff       	call   800407 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  801d5c:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  801d62:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  801d69:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  801d70:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  801d76:	7d 71                	jge    801de9 <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  801d78:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  801d7e:	83 38 01             	cmpl   $0x1,(%eax)
  801d81:	75 d9                	jne    801d5c <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  801d83:	89 c1                	mov    %eax,%ecx
  801d85:	8b 40 18             	mov    0x18(%eax),%eax
  801d88:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  801d8b:	83 f8 01             	cmp    $0x1,%eax
  801d8e:	19 c0                	sbb    %eax,%eax
  801d90:	83 e0 fe             	and    $0xfffffffe,%eax
  801d93:	83 c0 07             	add    $0x7,%eax
  801d96:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  801d9c:	89 c8                	mov    %ecx,%eax
  801d9e:	8b 49 04             	mov    0x4(%ecx),%ecx
  801da1:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  801da7:	8b 50 10             	mov    0x10(%eax),%edx
  801daa:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  801db0:	8b 78 14             	mov    0x14(%eax),%edi
  801db3:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  801db9:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  801dbc:	89 f0                	mov    %esi,%eax
  801dbe:	25 ff 0f 00 00       	and    $0xfff,%eax
  801dc3:	74 1a                	je     801ddf <spawn+0x419>
		va -= i;
  801dc5:	29 c6                	sub    %eax,%esi
		memsz += i;
  801dc7:	01 c7                	add    %eax,%edi
  801dc9:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  801dcf:	01 c2                	add    %eax,%edx
  801dd1:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  801dd7:	29 c1                	sub    %eax,%ecx
  801dd9:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  801ddf:	bb 00 00 00 00       	mov    $0x0,%ebx
  801de4:	e9 01 ff ff ff       	jmp    801cea <spawn+0x324>
	close(fd);
  801de9:	83 ec 0c             	sub    $0xc,%esp
  801dec:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  801df2:	e8 3e f5 ff ff       	call   801335 <close>
  801df7:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801dfa:	bb 00 00 00 00       	mov    $0x0,%ebx
  801dff:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  801e05:	eb 12                	jmp    801e19 <spawn+0x453>
  801e07:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801e0d:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801e13:	0f 84 c8 00 00 00    	je     801ee1 <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  801e19:	89 d8                	mov    %ebx,%eax
  801e1b:	c1 e8 16             	shr    $0x16,%eax
  801e1e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801e25:	a8 01                	test   $0x1,%al
  801e27:	74 de                	je     801e07 <spawn+0x441>
  801e29:	89 d8                	mov    %ebx,%eax
  801e2b:	c1 e8 0c             	shr    $0xc,%eax
  801e2e:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e35:	f6 c2 04             	test   $0x4,%dl
  801e38:	74 cd                	je     801e07 <spawn+0x441>
  801e3a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801e41:	f6 c6 04             	test   $0x4,%dh
  801e44:	74 c1                	je     801e07 <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  801e46:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801e4d:	e8 66 f0 ff ff       	call   800eb8 <sys_getenvid>
  801e52:	83 ec 0c             	sub    $0xc,%esp
  801e55:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801e5b:	57                   	push   %edi
  801e5c:	53                   	push   %ebx
  801e5d:	56                   	push   %esi
  801e5e:	53                   	push   %ebx
  801e5f:	50                   	push   %eax
  801e60:	e8 b5 f0 ff ff       	call   800f1a <sys_page_map>
  801e65:	83 c4 20             	add    $0x20,%esp
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	79 9b                	jns    801e07 <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  801e6c:	6a ff                	push   $0xffffffff
  801e6e:	68 df 2c 80 00       	push   $0x802cdf
  801e73:	68 82 00 00 00       	push   $0x82
  801e78:	68 85 2c 80 00       	push   $0x802c85
  801e7d:	e8 85 e5 ff ff       	call   800407 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  801e82:	50                   	push   %eax
  801e83:	68 ae 2c 80 00       	push   $0x802cae
  801e88:	68 85 00 00 00       	push   $0x85
  801e8d:	68 85 2c 80 00       	push   $0x802c85
  801e92:	e8 70 e5 ff ff       	call   800407 <_panic>
		panic("sys_env_set_status: %e", r);
  801e97:	50                   	push   %eax
  801e98:	68 c8 2c 80 00       	push   $0x802cc8
  801e9d:	68 88 00 00 00       	push   $0x88
  801ea2:	68 85 2c 80 00       	push   $0x802c85
  801ea7:	e8 5b e5 ff ff       	call   800407 <_panic>
		return r;
  801eac:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  801eb2:	e9 86 fe ff ff       	jmp    801d3d <spawn+0x377>
		return r;
  801eb7:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801ebd:	e9 7b fe ff ff       	jmp    801d3d <spawn+0x377>
		return -E_NO_MEM;
  801ec2:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  801ec7:	e9 71 fe ff ff       	jmp    801d3d <spawn+0x377>
  801ecc:	89 c7                	mov    %eax,%edi
  801ece:	e9 4b fe ff ff       	jmp    801d1e <spawn+0x358>
  801ed3:	89 c7                	mov    %eax,%edi
  801ed5:	e9 44 fe ff ff       	jmp    801d1e <spawn+0x358>
  801eda:	89 c7                	mov    %eax,%edi
  801edc:	e9 3d fe ff ff       	jmp    801d1e <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  801ee1:	83 ec 08             	sub    $0x8,%esp
  801ee4:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  801eea:	50                   	push   %eax
  801eeb:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801ef1:	e8 4a f1 ff ff       	call   801040 <sys_env_set_trapframe>
  801ef6:	83 c4 10             	add    $0x10,%esp
  801ef9:	85 c0                	test   %eax,%eax
  801efb:	78 85                	js     801e82 <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  801efd:	83 ec 08             	sub    $0x8,%esp
  801f00:	6a 02                	push   $0x2
  801f02:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  801f08:	e8 b0 f0 ff ff       	call   800fbd <sys_env_set_status>
  801f0d:	83 c4 10             	add    $0x10,%esp
  801f10:	85 c0                	test   %eax,%eax
  801f12:	78 83                	js     801e97 <spawn+0x4d1>
	return child;
  801f14:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  801f1a:	e9 1e fe ff ff       	jmp    801d3d <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  801f1f:	83 ec 08             	sub    $0x8,%esp
  801f22:	68 00 00 40 00       	push   $0x400000
  801f27:	6a 00                	push   $0x0
  801f29:	e8 2e f0 ff ff       	call   800f5c <sys_page_unmap>
  801f2e:	83 c4 10             	add    $0x10,%esp
  801f31:	e9 07 fe ff ff       	jmp    801d3d <spawn+0x377>

00801f36 <spawnl>:
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	57                   	push   %edi
  801f3a:	56                   	push   %esi
  801f3b:	53                   	push   %ebx
  801f3c:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  801f3f:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  801f42:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  801f47:	eb 03                	jmp    801f4c <spawnl+0x16>
		argc++;
  801f49:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  801f4a:	89 ca                	mov    %ecx,%edx
  801f4c:	8d 4a 04             	lea    0x4(%edx),%ecx
  801f4f:	83 3a 00             	cmpl   $0x0,(%edx)
  801f52:	75 f5                	jne    801f49 <spawnl+0x13>
	const char *argv[argc+2];
  801f54:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  801f5b:	83 e2 f0             	and    $0xfffffff0,%edx
  801f5e:	29 d4                	sub    %edx,%esp
  801f60:	8d 54 24 03          	lea    0x3(%esp),%edx
  801f64:	c1 ea 02             	shr    $0x2,%edx
  801f67:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  801f6e:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  801f70:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f73:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  801f7a:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  801f81:	00 
	va_start(vl, arg0);
  801f82:	8d 4d 10             	lea    0x10(%ebp),%ecx
  801f85:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  801f87:	b8 00 00 00 00       	mov    $0x0,%eax
  801f8c:	eb 09                	jmp    801f97 <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  801f8e:	40                   	inc    %eax
  801f8f:	8b 39                	mov    (%ecx),%edi
  801f91:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  801f94:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  801f97:	39 d0                	cmp    %edx,%eax
  801f99:	75 f3                	jne    801f8e <spawnl+0x58>
	return spawn(prog, argv);
  801f9b:	83 ec 08             	sub    $0x8,%esp
  801f9e:	56                   	push   %esi
  801f9f:	ff 75 08             	pushl  0x8(%ebp)
  801fa2:	e8 1f fa ff ff       	call   8019c6 <spawn>
}
  801fa7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801faa:	5b                   	pop    %ebx
  801fab:	5e                   	pop    %esi
  801fac:	5f                   	pop    %edi
  801fad:	5d                   	pop    %ebp
  801fae:	c3                   	ret    

00801faf <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801faf:	55                   	push   %ebp
  801fb0:	89 e5                	mov    %esp,%ebp
  801fb2:	56                   	push   %esi
  801fb3:	53                   	push   %ebx
  801fb4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801fb7:	83 ec 0c             	sub    $0xc,%esp
  801fba:	ff 75 08             	pushl  0x8(%ebp)
  801fbd:	e8 da f1 ff ff       	call   80119c <fd2data>
  801fc2:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801fc4:	83 c4 08             	add    $0x8,%esp
  801fc7:	68 1e 2d 80 00       	push   $0x802d1e
  801fcc:	53                   	push   %ebx
  801fcd:	e8 50 eb ff ff       	call   800b22 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801fd2:	8b 46 04             	mov    0x4(%esi),%eax
  801fd5:	2b 06                	sub    (%esi),%eax
  801fd7:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801fdd:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801fe4:	10 00 00 
	stat->st_dev = &devpipe;
  801fe7:	c7 83 88 00 00 00 ac 	movl   $0x8047ac,0x88(%ebx)
  801fee:	47 80 00 
	return 0;
}
  801ff1:	b8 00 00 00 00       	mov    $0x0,%eax
  801ff6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801ff9:	5b                   	pop    %ebx
  801ffa:	5e                   	pop    %esi
  801ffb:	5d                   	pop    %ebp
  801ffc:	c3                   	ret    

00801ffd <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801ffd:	55                   	push   %ebp
  801ffe:	89 e5                	mov    %esp,%ebp
  802000:	53                   	push   %ebx
  802001:	83 ec 0c             	sub    $0xc,%esp
  802004:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802007:	53                   	push   %ebx
  802008:	6a 00                	push   $0x0
  80200a:	e8 4d ef ff ff       	call   800f5c <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  80200f:	89 1c 24             	mov    %ebx,(%esp)
  802012:	e8 85 f1 ff ff       	call   80119c <fd2data>
  802017:	83 c4 08             	add    $0x8,%esp
  80201a:	50                   	push   %eax
  80201b:	6a 00                	push   $0x0
  80201d:	e8 3a ef ff ff       	call   800f5c <sys_page_unmap>
}
  802022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802025:	c9                   	leave  
  802026:	c3                   	ret    

00802027 <_pipeisclosed>:
{
  802027:	55                   	push   %ebp
  802028:	89 e5                	mov    %esp,%ebp
  80202a:	57                   	push   %edi
  80202b:	56                   	push   %esi
  80202c:	53                   	push   %ebx
  80202d:	83 ec 1c             	sub    $0x1c,%esp
  802030:	89 c7                	mov    %eax,%edi
  802032:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802034:	a1 90 67 80 00       	mov    0x806790,%eax
  802039:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  80203c:	83 ec 0c             	sub    $0xc,%esp
  80203f:	57                   	push   %edi
  802040:	e8 2b 04 00 00       	call   802470 <pageref>
  802045:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802048:	89 34 24             	mov    %esi,(%esp)
  80204b:	e8 20 04 00 00       	call   802470 <pageref>
		nn = thisenv->env_runs;
  802050:	8b 15 90 67 80 00    	mov    0x806790,%edx
  802056:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802059:	83 c4 10             	add    $0x10,%esp
  80205c:	39 cb                	cmp    %ecx,%ebx
  80205e:	74 1b                	je     80207b <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802060:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802063:	75 cf                	jne    802034 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802065:	8b 42 58             	mov    0x58(%edx),%eax
  802068:	6a 01                	push   $0x1
  80206a:	50                   	push   %eax
  80206b:	53                   	push   %ebx
  80206c:	68 25 2d 80 00       	push   $0x802d25
  802071:	e8 a4 e4 ff ff       	call   80051a <cprintf>
  802076:	83 c4 10             	add    $0x10,%esp
  802079:	eb b9                	jmp    802034 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  80207b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  80207e:	0f 94 c0             	sete   %al
  802081:	0f b6 c0             	movzbl %al,%eax
}
  802084:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802087:	5b                   	pop    %ebx
  802088:	5e                   	pop    %esi
  802089:	5f                   	pop    %edi
  80208a:	5d                   	pop    %ebp
  80208b:	c3                   	ret    

0080208c <devpipe_write>:
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
  80208f:	57                   	push   %edi
  802090:	56                   	push   %esi
  802091:	53                   	push   %ebx
  802092:	83 ec 18             	sub    $0x18,%esp
  802095:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802098:	56                   	push   %esi
  802099:	e8 fe f0 ff ff       	call   80119c <fd2data>
  80209e:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  8020a0:	83 c4 10             	add    $0x10,%esp
  8020a3:	bf 00 00 00 00       	mov    $0x0,%edi
  8020a8:	3b 7d 10             	cmp    0x10(%ebp),%edi
  8020ab:	74 41                	je     8020ee <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  8020ad:	8b 53 04             	mov    0x4(%ebx),%edx
  8020b0:	8b 03                	mov    (%ebx),%eax
  8020b2:	83 c0 20             	add    $0x20,%eax
  8020b5:	39 c2                	cmp    %eax,%edx
  8020b7:	72 14                	jb     8020cd <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  8020b9:	89 da                	mov    %ebx,%edx
  8020bb:	89 f0                	mov    %esi,%eax
  8020bd:	e8 65 ff ff ff       	call   802027 <_pipeisclosed>
  8020c2:	85 c0                	test   %eax,%eax
  8020c4:	75 2c                	jne    8020f2 <devpipe_write+0x66>
			sys_yield();
  8020c6:	e8 d3 ee ff ff       	call   800f9e <sys_yield>
  8020cb:	eb e0                	jmp    8020ad <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020d0:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  8020d3:	89 d0                	mov    %edx,%eax
  8020d5:	25 1f 00 00 80       	and    $0x8000001f,%eax
  8020da:	78 0b                	js     8020e7 <devpipe_write+0x5b>
  8020dc:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  8020e0:	42                   	inc    %edx
  8020e1:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  8020e4:	47                   	inc    %edi
  8020e5:	eb c1                	jmp    8020a8 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  8020e7:	48                   	dec    %eax
  8020e8:	83 c8 e0             	or     $0xffffffe0,%eax
  8020eb:	40                   	inc    %eax
  8020ec:	eb ee                	jmp    8020dc <devpipe_write+0x50>
	return i;
  8020ee:	89 f8                	mov    %edi,%eax
  8020f0:	eb 05                	jmp    8020f7 <devpipe_write+0x6b>
				return 0;
  8020f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8020fa:	5b                   	pop    %ebx
  8020fb:	5e                   	pop    %esi
  8020fc:	5f                   	pop    %edi
  8020fd:	5d                   	pop    %ebp
  8020fe:	c3                   	ret    

008020ff <devpipe_read>:
{
  8020ff:	55                   	push   %ebp
  802100:	89 e5                	mov    %esp,%ebp
  802102:	57                   	push   %edi
  802103:	56                   	push   %esi
  802104:	53                   	push   %ebx
  802105:	83 ec 18             	sub    $0x18,%esp
  802108:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  80210b:	57                   	push   %edi
  80210c:	e8 8b f0 ff ff       	call   80119c <fd2data>
  802111:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  802113:	83 c4 10             	add    $0x10,%esp
  802116:	bb 00 00 00 00       	mov    $0x0,%ebx
  80211b:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  80211e:	74 46                	je     802166 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  802120:	8b 06                	mov    (%esi),%eax
  802122:	3b 46 04             	cmp    0x4(%esi),%eax
  802125:	75 22                	jne    802149 <devpipe_read+0x4a>
			if (i > 0)
  802127:	85 db                	test   %ebx,%ebx
  802129:	74 0a                	je     802135 <devpipe_read+0x36>
				return i;
  80212b:	89 d8                	mov    %ebx,%eax
}
  80212d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802130:	5b                   	pop    %ebx
  802131:	5e                   	pop    %esi
  802132:	5f                   	pop    %edi
  802133:	5d                   	pop    %ebp
  802134:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  802135:	89 f2                	mov    %esi,%edx
  802137:	89 f8                	mov    %edi,%eax
  802139:	e8 e9 fe ff ff       	call   802027 <_pipeisclosed>
  80213e:	85 c0                	test   %eax,%eax
  802140:	75 28                	jne    80216a <devpipe_read+0x6b>
			sys_yield();
  802142:	e8 57 ee ff ff       	call   800f9e <sys_yield>
  802147:	eb d7                	jmp    802120 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802149:	25 1f 00 00 80       	and    $0x8000001f,%eax
  80214e:	78 0f                	js     80215f <devpipe_read+0x60>
  802150:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  802154:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802157:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  80215a:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  80215c:	43                   	inc    %ebx
  80215d:	eb bc                	jmp    80211b <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  80215f:	48                   	dec    %eax
  802160:	83 c8 e0             	or     $0xffffffe0,%eax
  802163:	40                   	inc    %eax
  802164:	eb ea                	jmp    802150 <devpipe_read+0x51>
	return i;
  802166:	89 d8                	mov    %ebx,%eax
  802168:	eb c3                	jmp    80212d <devpipe_read+0x2e>
				return 0;
  80216a:	b8 00 00 00 00       	mov    $0x0,%eax
  80216f:	eb bc                	jmp    80212d <devpipe_read+0x2e>

00802171 <pipe>:
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
  802174:	56                   	push   %esi
  802175:	53                   	push   %ebx
  802176:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802179:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80217c:	50                   	push   %eax
  80217d:	e8 31 f0 ff ff       	call   8011b3 <fd_alloc>
  802182:	89 c3                	mov    %eax,%ebx
  802184:	83 c4 10             	add    $0x10,%esp
  802187:	85 c0                	test   %eax,%eax
  802189:	0f 88 2a 01 00 00    	js     8022b9 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  80218f:	83 ec 04             	sub    $0x4,%esp
  802192:	68 07 04 00 00       	push   $0x407
  802197:	ff 75 f4             	pushl  -0xc(%ebp)
  80219a:	6a 00                	push   $0x0
  80219c:	e8 36 ed ff ff       	call   800ed7 <sys_page_alloc>
  8021a1:	89 c3                	mov    %eax,%ebx
  8021a3:	83 c4 10             	add    $0x10,%esp
  8021a6:	85 c0                	test   %eax,%eax
  8021a8:	0f 88 0b 01 00 00    	js     8022b9 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  8021ae:	83 ec 0c             	sub    $0xc,%esp
  8021b1:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021b4:	50                   	push   %eax
  8021b5:	e8 f9 ef ff ff       	call   8011b3 <fd_alloc>
  8021ba:	89 c3                	mov    %eax,%ebx
  8021bc:	83 c4 10             	add    $0x10,%esp
  8021bf:	85 c0                	test   %eax,%eax
  8021c1:	0f 88 e2 00 00 00    	js     8022a9 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021c7:	83 ec 04             	sub    $0x4,%esp
  8021ca:	68 07 04 00 00       	push   $0x407
  8021cf:	ff 75 f0             	pushl  -0x10(%ebp)
  8021d2:	6a 00                	push   $0x0
  8021d4:	e8 fe ec ff ff       	call   800ed7 <sys_page_alloc>
  8021d9:	89 c3                	mov    %eax,%ebx
  8021db:	83 c4 10             	add    $0x10,%esp
  8021de:	85 c0                	test   %eax,%eax
  8021e0:	0f 88 c3 00 00 00    	js     8022a9 <pipe+0x138>
	va = fd2data(fd0);
  8021e6:	83 ec 0c             	sub    $0xc,%esp
  8021e9:	ff 75 f4             	pushl  -0xc(%ebp)
  8021ec:	e8 ab ef ff ff       	call   80119c <fd2data>
  8021f1:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  8021f3:	83 c4 0c             	add    $0xc,%esp
  8021f6:	68 07 04 00 00       	push   $0x407
  8021fb:	50                   	push   %eax
  8021fc:	6a 00                	push   $0x0
  8021fe:	e8 d4 ec ff ff       	call   800ed7 <sys_page_alloc>
  802203:	89 c3                	mov    %eax,%ebx
  802205:	83 c4 10             	add    $0x10,%esp
  802208:	85 c0                	test   %eax,%eax
  80220a:	0f 88 89 00 00 00    	js     802299 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802210:	83 ec 0c             	sub    $0xc,%esp
  802213:	ff 75 f0             	pushl  -0x10(%ebp)
  802216:	e8 81 ef ff ff       	call   80119c <fd2data>
  80221b:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802222:	50                   	push   %eax
  802223:	6a 00                	push   $0x0
  802225:	56                   	push   %esi
  802226:	6a 00                	push   $0x0
  802228:	e8 ed ec ff ff       	call   800f1a <sys_page_map>
  80222d:	89 c3                	mov    %eax,%ebx
  80222f:	83 c4 20             	add    $0x20,%esp
  802232:	85 c0                	test   %eax,%eax
  802234:	78 55                	js     80228b <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  802236:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  80223c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80223f:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802241:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802244:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  80224b:	8b 15 ac 47 80 00    	mov    0x8047ac,%edx
  802251:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802254:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802256:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802259:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802260:	83 ec 0c             	sub    $0xc,%esp
  802263:	ff 75 f4             	pushl  -0xc(%ebp)
  802266:	e8 21 ef ff ff       	call   80118c <fd2num>
  80226b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80226e:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802270:	83 c4 04             	add    $0x4,%esp
  802273:	ff 75 f0             	pushl  -0x10(%ebp)
  802276:	e8 11 ef ff ff       	call   80118c <fd2num>
  80227b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80227e:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802281:	83 c4 10             	add    $0x10,%esp
  802284:	bb 00 00 00 00       	mov    $0x0,%ebx
  802289:	eb 2e                	jmp    8022b9 <pipe+0x148>
	sys_page_unmap(0, va);
  80228b:	83 ec 08             	sub    $0x8,%esp
  80228e:	56                   	push   %esi
  80228f:	6a 00                	push   $0x0
  802291:	e8 c6 ec ff ff       	call   800f5c <sys_page_unmap>
  802296:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802299:	83 ec 08             	sub    $0x8,%esp
  80229c:	ff 75 f0             	pushl  -0x10(%ebp)
  80229f:	6a 00                	push   $0x0
  8022a1:	e8 b6 ec ff ff       	call   800f5c <sys_page_unmap>
  8022a6:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8022a9:	83 ec 08             	sub    $0x8,%esp
  8022ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8022af:	6a 00                	push   $0x0
  8022b1:	e8 a6 ec ff ff       	call   800f5c <sys_page_unmap>
  8022b6:	83 c4 10             	add    $0x10,%esp
}
  8022b9:	89 d8                	mov    %ebx,%eax
  8022bb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022be:	5b                   	pop    %ebx
  8022bf:	5e                   	pop    %esi
  8022c0:	5d                   	pop    %ebp
  8022c1:	c3                   	ret    

008022c2 <pipeisclosed>:
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8022c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8022cb:	50                   	push   %eax
  8022cc:	ff 75 08             	pushl  0x8(%ebp)
  8022cf:	e8 2e ef ff ff       	call   801202 <fd_lookup>
  8022d4:	83 c4 10             	add    $0x10,%esp
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	78 18                	js     8022f3 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8022db:	83 ec 0c             	sub    $0xc,%esp
  8022de:	ff 75 f4             	pushl  -0xc(%ebp)
  8022e1:	e8 b6 ee ff ff       	call   80119c <fd2data>
	return _pipeisclosed(fd, p);
  8022e6:	89 c2                	mov    %eax,%edx
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	e8 37 fd ff ff       	call   802027 <_pipeisclosed>
  8022f0:	83 c4 10             	add    $0x10,%esp
}
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
  8022f8:	56                   	push   %esi
  8022f9:	53                   	push   %ebx
  8022fa:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  8022fd:	85 f6                	test   %esi,%esi
  8022ff:	74 18                	je     802319 <wait+0x24>
	e = &envs[ENVX(envid)];
  802301:	89 f2                	mov    %esi,%edx
  802303:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802309:	89 d0                	mov    %edx,%eax
  80230b:	c1 e0 05             	shl    $0x5,%eax
  80230e:	29 d0                	sub    %edx,%eax
  802310:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  802317:	eb 1b                	jmp    802334 <wait+0x3f>
	assert(envid != 0);
  802319:	68 3d 2d 80 00       	push   $0x802d3d
  80231e:	68 3f 2c 80 00       	push   $0x802c3f
  802323:	6a 09                	push   $0x9
  802325:	68 48 2d 80 00       	push   $0x802d48
  80232a:	e8 d8 e0 ff ff       	call   800407 <_panic>
		sys_yield();
  80232f:	e8 6a ec ff ff       	call   800f9e <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802334:	8b 43 48             	mov    0x48(%ebx),%eax
  802337:	39 c6                	cmp    %eax,%esi
  802339:	75 07                	jne    802342 <wait+0x4d>
  80233b:	8b 43 54             	mov    0x54(%ebx),%eax
  80233e:	85 c0                	test   %eax,%eax
  802340:	75 ed                	jne    80232f <wait+0x3a>
}
  802342:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802345:	5b                   	pop    %ebx
  802346:	5e                   	pop    %esi
  802347:	5d                   	pop    %ebp
  802348:	c3                   	ret    

00802349 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	57                   	push   %edi
  80234d:	56                   	push   %esi
  80234e:	53                   	push   %ebx
  80234f:	83 ec 0c             	sub    $0xc,%esp
  802352:	8b 5d 08             	mov    0x8(%ebp),%ebx
  802355:	8b 7d 0c             	mov    0xc(%ebp),%edi
  802358:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  80235b:	85 ff                	test   %edi,%edi
  80235d:	74 53                	je     8023b2 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  80235f:	83 ec 0c             	sub    $0xc,%esp
  802362:	57                   	push   %edi
  802363:	e8 7f ed ff ff       	call   8010e7 <sys_ipc_recv>
  802368:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  80236b:	85 db                	test   %ebx,%ebx
  80236d:	74 0b                	je     80237a <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  80236f:	8b 15 90 67 80 00    	mov    0x806790,%edx
  802375:	8b 52 74             	mov    0x74(%edx),%edx
  802378:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  80237a:	85 f6                	test   %esi,%esi
  80237c:	74 0f                	je     80238d <ipc_recv+0x44>
  80237e:	85 ff                	test   %edi,%edi
  802380:	74 0b                	je     80238d <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  802382:	8b 15 90 67 80 00    	mov    0x806790,%edx
  802388:	8b 52 78             	mov    0x78(%edx),%edx
  80238b:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  80238d:	85 c0                	test   %eax,%eax
  80238f:	74 30                	je     8023c1 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  802391:	85 db                	test   %ebx,%ebx
  802393:	74 06                	je     80239b <ipc_recv+0x52>
      		*from_env_store = 0;
  802395:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  80239b:	85 f6                	test   %esi,%esi
  80239d:	74 2c                	je     8023cb <ipc_recv+0x82>
      		*perm_store = 0;
  80239f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8023a5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8023aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8023ad:	5b                   	pop    %ebx
  8023ae:	5e                   	pop    %esi
  8023af:	5f                   	pop    %edi
  8023b0:	5d                   	pop    %ebp
  8023b1:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8023b2:	83 ec 0c             	sub    $0xc,%esp
  8023b5:	6a ff                	push   $0xffffffff
  8023b7:	e8 2b ed ff ff       	call   8010e7 <sys_ipc_recv>
  8023bc:	83 c4 10             	add    $0x10,%esp
  8023bf:	eb aa                	jmp    80236b <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8023c1:	a1 90 67 80 00       	mov    0x806790,%eax
  8023c6:	8b 40 70             	mov    0x70(%eax),%eax
  8023c9:	eb df                	jmp    8023aa <ipc_recv+0x61>
		return -1;
  8023cb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8023d0:	eb d8                	jmp    8023aa <ipc_recv+0x61>

008023d2 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8023d2:	55                   	push   %ebp
  8023d3:	89 e5                	mov    %esp,%ebp
  8023d5:	57                   	push   %edi
  8023d6:	56                   	push   %esi
  8023d7:	53                   	push   %ebx
  8023d8:	83 ec 0c             	sub    $0xc,%esp
  8023db:	8b 75 0c             	mov    0xc(%ebp),%esi
  8023de:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8023e1:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8023e4:	85 db                	test   %ebx,%ebx
  8023e6:	75 22                	jne    80240a <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8023e8:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8023ed:	eb 1b                	jmp    80240a <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8023ef:	68 54 2d 80 00       	push   $0x802d54
  8023f4:	68 3f 2c 80 00       	push   $0x802c3f
  8023f9:	6a 48                	push   $0x48
  8023fb:	68 78 2d 80 00       	push   $0x802d78
  802400:	e8 02 e0 ff ff       	call   800407 <_panic>
		sys_yield();
  802405:	e8 94 eb ff ff       	call   800f9e <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  80240a:	57                   	push   %edi
  80240b:	53                   	push   %ebx
  80240c:	56                   	push   %esi
  80240d:	ff 75 08             	pushl  0x8(%ebp)
  802410:	e8 af ec ff ff       	call   8010c4 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  802415:	83 c4 10             	add    $0x10,%esp
  802418:	83 f8 f9             	cmp    $0xfffffff9,%eax
  80241b:	74 e8                	je     802405 <ipc_send+0x33>
  80241d:	85 c0                	test   %eax,%eax
  80241f:	75 ce                	jne    8023ef <ipc_send+0x1d>
		sys_yield();
  802421:	e8 78 eb ff ff       	call   800f9e <sys_yield>
		
	}
	
}
  802426:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802429:	5b                   	pop    %ebx
  80242a:	5e                   	pop    %esi
  80242b:	5f                   	pop    %edi
  80242c:	5d                   	pop    %ebp
  80242d:	c3                   	ret    

0080242e <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  80242e:	55                   	push   %ebp
  80242f:	89 e5                	mov    %esp,%ebp
  802431:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  802434:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  802439:	89 c2                	mov    %eax,%edx
  80243b:	c1 e2 05             	shl    $0x5,%edx
  80243e:	29 c2                	sub    %eax,%edx
  802440:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  802447:	8b 52 50             	mov    0x50(%edx),%edx
  80244a:	39 ca                	cmp    %ecx,%edx
  80244c:	74 0f                	je     80245d <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  80244e:	40                   	inc    %eax
  80244f:	3d 00 04 00 00       	cmp    $0x400,%eax
  802454:	75 e3                	jne    802439 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  802456:	b8 00 00 00 00       	mov    $0x0,%eax
  80245b:	eb 11                	jmp    80246e <ipc_find_env+0x40>
			return envs[i].env_id;
  80245d:	89 c2                	mov    %eax,%edx
  80245f:	c1 e2 05             	shl    $0x5,%edx
  802462:	29 c2                	sub    %eax,%edx
  802464:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80246b:	8b 40 48             	mov    0x48(%eax),%eax
}
  80246e:	5d                   	pop    %ebp
  80246f:	c3                   	ret    

00802470 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802470:	55                   	push   %ebp
  802471:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802473:	8b 45 08             	mov    0x8(%ebp),%eax
  802476:	c1 e8 16             	shr    $0x16,%eax
  802479:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802480:	a8 01                	test   $0x1,%al
  802482:	74 21                	je     8024a5 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802484:	8b 45 08             	mov    0x8(%ebp),%eax
  802487:	c1 e8 0c             	shr    $0xc,%eax
  80248a:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  802491:	a8 01                	test   $0x1,%al
  802493:	74 17                	je     8024ac <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  802495:	c1 e8 0c             	shr    $0xc,%eax
  802498:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  80249f:	ef 
  8024a0:	0f b7 c0             	movzwl %ax,%eax
  8024a3:	eb 05                	jmp    8024aa <pageref+0x3a>
		return 0;
  8024a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024aa:	5d                   	pop    %ebp
  8024ab:	c3                   	ret    
		return 0;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8024b1:	eb f7                	jmp    8024aa <pageref+0x3a>
  8024b3:	90                   	nop

008024b4 <__udivdi3>:
  8024b4:	55                   	push   %ebp
  8024b5:	57                   	push   %edi
  8024b6:	56                   	push   %esi
  8024b7:	53                   	push   %ebx
  8024b8:	83 ec 1c             	sub    $0x1c,%esp
  8024bb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8024bf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8024c3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8024c7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8024cb:	89 ca                	mov    %ecx,%edx
  8024cd:	89 f8                	mov    %edi,%eax
  8024cf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8024d3:	85 f6                	test   %esi,%esi
  8024d5:	75 2d                	jne    802504 <__udivdi3+0x50>
  8024d7:	39 cf                	cmp    %ecx,%edi
  8024d9:	77 65                	ja     802540 <__udivdi3+0x8c>
  8024db:	89 fd                	mov    %edi,%ebp
  8024dd:	85 ff                	test   %edi,%edi
  8024df:	75 0b                	jne    8024ec <__udivdi3+0x38>
  8024e1:	b8 01 00 00 00       	mov    $0x1,%eax
  8024e6:	31 d2                	xor    %edx,%edx
  8024e8:	f7 f7                	div    %edi
  8024ea:	89 c5                	mov    %eax,%ebp
  8024ec:	31 d2                	xor    %edx,%edx
  8024ee:	89 c8                	mov    %ecx,%eax
  8024f0:	f7 f5                	div    %ebp
  8024f2:	89 c1                	mov    %eax,%ecx
  8024f4:	89 d8                	mov    %ebx,%eax
  8024f6:	f7 f5                	div    %ebp
  8024f8:	89 cf                	mov    %ecx,%edi
  8024fa:	89 fa                	mov    %edi,%edx
  8024fc:	83 c4 1c             	add    $0x1c,%esp
  8024ff:	5b                   	pop    %ebx
  802500:	5e                   	pop    %esi
  802501:	5f                   	pop    %edi
  802502:	5d                   	pop    %ebp
  802503:	c3                   	ret    
  802504:	39 ce                	cmp    %ecx,%esi
  802506:	77 28                	ja     802530 <__udivdi3+0x7c>
  802508:	0f bd fe             	bsr    %esi,%edi
  80250b:	83 f7 1f             	xor    $0x1f,%edi
  80250e:	75 40                	jne    802550 <__udivdi3+0x9c>
  802510:	39 ce                	cmp    %ecx,%esi
  802512:	72 0a                	jb     80251e <__udivdi3+0x6a>
  802514:	3b 44 24 04          	cmp    0x4(%esp),%eax
  802518:	0f 87 9e 00 00 00    	ja     8025bc <__udivdi3+0x108>
  80251e:	b8 01 00 00 00       	mov    $0x1,%eax
  802523:	89 fa                	mov    %edi,%edx
  802525:	83 c4 1c             	add    $0x1c,%esp
  802528:	5b                   	pop    %ebx
  802529:	5e                   	pop    %esi
  80252a:	5f                   	pop    %edi
  80252b:	5d                   	pop    %ebp
  80252c:	c3                   	ret    
  80252d:	8d 76 00             	lea    0x0(%esi),%esi
  802530:	31 ff                	xor    %edi,%edi
  802532:	31 c0                	xor    %eax,%eax
  802534:	89 fa                	mov    %edi,%edx
  802536:	83 c4 1c             	add    $0x1c,%esp
  802539:	5b                   	pop    %ebx
  80253a:	5e                   	pop    %esi
  80253b:	5f                   	pop    %edi
  80253c:	5d                   	pop    %ebp
  80253d:	c3                   	ret    
  80253e:	66 90                	xchg   %ax,%ax
  802540:	89 d8                	mov    %ebx,%eax
  802542:	f7 f7                	div    %edi
  802544:	31 ff                	xor    %edi,%edi
  802546:	89 fa                	mov    %edi,%edx
  802548:	83 c4 1c             	add    $0x1c,%esp
  80254b:	5b                   	pop    %ebx
  80254c:	5e                   	pop    %esi
  80254d:	5f                   	pop    %edi
  80254e:	5d                   	pop    %ebp
  80254f:	c3                   	ret    
  802550:	bd 20 00 00 00       	mov    $0x20,%ebp
  802555:	29 fd                	sub    %edi,%ebp
  802557:	89 f9                	mov    %edi,%ecx
  802559:	d3 e6                	shl    %cl,%esi
  80255b:	89 c3                	mov    %eax,%ebx
  80255d:	89 e9                	mov    %ebp,%ecx
  80255f:	d3 eb                	shr    %cl,%ebx
  802561:	89 d9                	mov    %ebx,%ecx
  802563:	09 f1                	or     %esi,%ecx
  802565:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802569:	89 f9                	mov    %edi,%ecx
  80256b:	d3 e0                	shl    %cl,%eax
  80256d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802571:	89 d6                	mov    %edx,%esi
  802573:	89 e9                	mov    %ebp,%ecx
  802575:	d3 ee                	shr    %cl,%esi
  802577:	89 f9                	mov    %edi,%ecx
  802579:	d3 e2                	shl    %cl,%edx
  80257b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  80257f:	89 e9                	mov    %ebp,%ecx
  802581:	d3 eb                	shr    %cl,%ebx
  802583:	09 da                	or     %ebx,%edx
  802585:	89 d0                	mov    %edx,%eax
  802587:	89 f2                	mov    %esi,%edx
  802589:	f7 74 24 08          	divl   0x8(%esp)
  80258d:	89 d6                	mov    %edx,%esi
  80258f:	89 c3                	mov    %eax,%ebx
  802591:	f7 64 24 0c          	mull   0xc(%esp)
  802595:	39 d6                	cmp    %edx,%esi
  802597:	72 17                	jb     8025b0 <__udivdi3+0xfc>
  802599:	74 09                	je     8025a4 <__udivdi3+0xf0>
  80259b:	89 d8                	mov    %ebx,%eax
  80259d:	31 ff                	xor    %edi,%edi
  80259f:	e9 56 ff ff ff       	jmp    8024fa <__udivdi3+0x46>
  8025a4:	8b 54 24 04          	mov    0x4(%esp),%edx
  8025a8:	89 f9                	mov    %edi,%ecx
  8025aa:	d3 e2                	shl    %cl,%edx
  8025ac:	39 c2                	cmp    %eax,%edx
  8025ae:	73 eb                	jae    80259b <__udivdi3+0xe7>
  8025b0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8025b3:	31 ff                	xor    %edi,%edi
  8025b5:	e9 40 ff ff ff       	jmp    8024fa <__udivdi3+0x46>
  8025ba:	66 90                	xchg   %ax,%ax
  8025bc:	31 c0                	xor    %eax,%eax
  8025be:	e9 37 ff ff ff       	jmp    8024fa <__udivdi3+0x46>
  8025c3:	90                   	nop

008025c4 <__umoddi3>:
  8025c4:	55                   	push   %ebp
  8025c5:	57                   	push   %edi
  8025c6:	56                   	push   %esi
  8025c7:	53                   	push   %ebx
  8025c8:	83 ec 1c             	sub    $0x1c,%esp
  8025cb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8025cf:	8b 74 24 34          	mov    0x34(%esp),%esi
  8025d3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8025d7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8025db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8025df:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8025e3:	89 3c 24             	mov    %edi,(%esp)
  8025e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8025ea:	89 f2                	mov    %esi,%edx
  8025ec:	85 c0                	test   %eax,%eax
  8025ee:	75 18                	jne    802608 <__umoddi3+0x44>
  8025f0:	39 f7                	cmp    %esi,%edi
  8025f2:	0f 86 a0 00 00 00    	jbe    802698 <__umoddi3+0xd4>
  8025f8:	89 c8                	mov    %ecx,%eax
  8025fa:	f7 f7                	div    %edi
  8025fc:	89 d0                	mov    %edx,%eax
  8025fe:	31 d2                	xor    %edx,%edx
  802600:	83 c4 1c             	add    $0x1c,%esp
  802603:	5b                   	pop    %ebx
  802604:	5e                   	pop    %esi
  802605:	5f                   	pop    %edi
  802606:	5d                   	pop    %ebp
  802607:	c3                   	ret    
  802608:	89 f3                	mov    %esi,%ebx
  80260a:	39 f0                	cmp    %esi,%eax
  80260c:	0f 87 a6 00 00 00    	ja     8026b8 <__umoddi3+0xf4>
  802612:	0f bd e8             	bsr    %eax,%ebp
  802615:	83 f5 1f             	xor    $0x1f,%ebp
  802618:	0f 84 a6 00 00 00    	je     8026c4 <__umoddi3+0x100>
  80261e:	bf 20 00 00 00       	mov    $0x20,%edi
  802623:	29 ef                	sub    %ebp,%edi
  802625:	89 e9                	mov    %ebp,%ecx
  802627:	d3 e0                	shl    %cl,%eax
  802629:	8b 34 24             	mov    (%esp),%esi
  80262c:	89 f2                	mov    %esi,%edx
  80262e:	89 f9                	mov    %edi,%ecx
  802630:	d3 ea                	shr    %cl,%edx
  802632:	09 c2                	or     %eax,%edx
  802634:	89 14 24             	mov    %edx,(%esp)
  802637:	89 f2                	mov    %esi,%edx
  802639:	89 e9                	mov    %ebp,%ecx
  80263b:	d3 e2                	shl    %cl,%edx
  80263d:	89 54 24 04          	mov    %edx,0x4(%esp)
  802641:	89 de                	mov    %ebx,%esi
  802643:	89 f9                	mov    %edi,%ecx
  802645:	d3 ee                	shr    %cl,%esi
  802647:	89 e9                	mov    %ebp,%ecx
  802649:	d3 e3                	shl    %cl,%ebx
  80264b:	8b 54 24 08          	mov    0x8(%esp),%edx
  80264f:	89 d0                	mov    %edx,%eax
  802651:	89 f9                	mov    %edi,%ecx
  802653:	d3 e8                	shr    %cl,%eax
  802655:	09 d8                	or     %ebx,%eax
  802657:	89 d3                	mov    %edx,%ebx
  802659:	89 e9                	mov    %ebp,%ecx
  80265b:	d3 e3                	shl    %cl,%ebx
  80265d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802661:	89 f2                	mov    %esi,%edx
  802663:	f7 34 24             	divl   (%esp)
  802666:	89 d6                	mov    %edx,%esi
  802668:	f7 64 24 04          	mull   0x4(%esp)
  80266c:	89 c3                	mov    %eax,%ebx
  80266e:	89 d1                	mov    %edx,%ecx
  802670:	39 d6                	cmp    %edx,%esi
  802672:	72 7c                	jb     8026f0 <__umoddi3+0x12c>
  802674:	74 72                	je     8026e8 <__umoddi3+0x124>
  802676:	8b 54 24 08          	mov    0x8(%esp),%edx
  80267a:	29 da                	sub    %ebx,%edx
  80267c:	19 ce                	sbb    %ecx,%esi
  80267e:	89 f0                	mov    %esi,%eax
  802680:	89 f9                	mov    %edi,%ecx
  802682:	d3 e0                	shl    %cl,%eax
  802684:	89 e9                	mov    %ebp,%ecx
  802686:	d3 ea                	shr    %cl,%edx
  802688:	09 d0                	or     %edx,%eax
  80268a:	89 e9                	mov    %ebp,%ecx
  80268c:	d3 ee                	shr    %cl,%esi
  80268e:	89 f2                	mov    %esi,%edx
  802690:	83 c4 1c             	add    $0x1c,%esp
  802693:	5b                   	pop    %ebx
  802694:	5e                   	pop    %esi
  802695:	5f                   	pop    %edi
  802696:	5d                   	pop    %ebp
  802697:	c3                   	ret    
  802698:	89 fd                	mov    %edi,%ebp
  80269a:	85 ff                	test   %edi,%edi
  80269c:	75 0b                	jne    8026a9 <__umoddi3+0xe5>
  80269e:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a3:	31 d2                	xor    %edx,%edx
  8026a5:	f7 f7                	div    %edi
  8026a7:	89 c5                	mov    %eax,%ebp
  8026a9:	89 f0                	mov    %esi,%eax
  8026ab:	31 d2                	xor    %edx,%edx
  8026ad:	f7 f5                	div    %ebp
  8026af:	89 c8                	mov    %ecx,%eax
  8026b1:	f7 f5                	div    %ebp
  8026b3:	e9 44 ff ff ff       	jmp    8025fc <__umoddi3+0x38>
  8026b8:	89 c8                	mov    %ecx,%eax
  8026ba:	89 f2                	mov    %esi,%edx
  8026bc:	83 c4 1c             	add    $0x1c,%esp
  8026bf:	5b                   	pop    %ebx
  8026c0:	5e                   	pop    %esi
  8026c1:	5f                   	pop    %edi
  8026c2:	5d                   	pop    %ebp
  8026c3:	c3                   	ret    
  8026c4:	39 f0                	cmp    %esi,%eax
  8026c6:	72 05                	jb     8026cd <__umoddi3+0x109>
  8026c8:	39 0c 24             	cmp    %ecx,(%esp)
  8026cb:	77 0c                	ja     8026d9 <__umoddi3+0x115>
  8026cd:	89 f2                	mov    %esi,%edx
  8026cf:	29 f9                	sub    %edi,%ecx
  8026d1:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8026d5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8026d9:	8b 44 24 04          	mov    0x4(%esp),%eax
  8026dd:	83 c4 1c             	add    $0x1c,%esp
  8026e0:	5b                   	pop    %ebx
  8026e1:	5e                   	pop    %esi
  8026e2:	5f                   	pop    %edi
  8026e3:	5d                   	pop    %ebp
  8026e4:	c3                   	ret    
  8026e5:	8d 76 00             	lea    0x0(%esi),%esi
  8026e8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8026ec:	73 88                	jae    802676 <__umoddi3+0xb2>
  8026ee:	66 90                	xchg   %ax,%ax
  8026f0:	2b 44 24 04          	sub    0x4(%esp),%eax
  8026f4:	1b 14 24             	sbb    (%esp),%edx
  8026f7:	89 d1                	mov    %edx,%ecx
  8026f9:	89 c3                	mov    %eax,%ebx
  8026fb:	e9 76 ff ff ff       	jmp    802676 <__umoddi3+0xb2>
