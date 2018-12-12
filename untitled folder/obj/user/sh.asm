
obj/user/sh.debug:     file format elf32-i386


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
  80002c:	e8 f2 09 00 00       	call   800a23 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <_gettoken>:
#define WHITESPACE " \t\r\n"
#define SYMBOLS "<|>&;()"

int
_gettoken(char *s, char **p1, char **p2)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	57                   	push   %edi
  800037:	56                   	push   %esi
  800038:	53                   	push   %ebx
  800039:	83 ec 0c             	sub    $0xc,%esp
  80003c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80003f:	8b 75 0c             	mov    0xc(%ebp),%esi
	int t;

	if (s == 0) {
  800042:	85 db                	test   %ebx,%ebx
  800044:	74 2b                	je     800071 <_gettoken+0x3e>
		if (debug > 1)
			cprintf("GETTOKEN NULL\n");
		return 0;
	}

	if (debug > 1)
  800046:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  80004d:	7e 11                	jle    800060 <_gettoken+0x2d>
		cprintf("GETTOKEN: %s\n", s);
  80004f:	83 ec 08             	sub    $0x8,%esp
  800052:	53                   	push   %ebx
  800053:	68 ef 33 80 00       	push   $0x8033ef
  800058:	e8 3f 0b 00 00       	call   800b9c <cprintf>
  80005d:	83 c4 10             	add    $0x10,%esp

	*p1 = 0;
  800060:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
	*p2 = 0;
  800066:	8b 45 10             	mov    0x10(%ebp),%eax
  800069:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	while (strchr(WHITESPACE, *s))
  80006f:	eb 29                	jmp    80009a <_gettoken+0x67>
		if (debug > 1)
  800071:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800078:	0f 8e 04 01 00 00    	jle    800182 <_gettoken+0x14f>
			cprintf("GETTOKEN NULL\n");
  80007e:	83 ec 0c             	sub    $0xc,%esp
  800081:	68 e0 33 80 00       	push   $0x8033e0
  800086:	e8 11 0b 00 00       	call   800b9c <cprintf>
  80008b:	83 c4 10             	add    $0x10,%esp
		return 0;
  80008e:	bf 00 00 00 00       	mov    $0x0,%edi
  800093:	eb 45                	jmp    8000da <_gettoken+0xa7>
		*s++ = 0;
  800095:	43                   	inc    %ebx
  800096:	c6 43 ff 00          	movb   $0x0,-0x1(%ebx)
	while (strchr(WHITESPACE, *s))
  80009a:	83 ec 08             	sub    $0x8,%esp
  80009d:	0f be 03             	movsbl (%ebx),%eax
  8000a0:	50                   	push   %eax
  8000a1:	68 fd 33 80 00       	push   $0x8033fd
  8000a6:	e8 e3 12 00 00       	call   80138e <strchr>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	85 c0                	test   %eax,%eax
  8000b0:	75 e3                	jne    800095 <_gettoken+0x62>
	if (*s == 0) {
  8000b2:	8a 03                	mov    (%ebx),%al
  8000b4:	84 c0                	test   %al,%al
  8000b6:	75 2c                	jne    8000e4 <_gettoken+0xb1>
		if (debug > 1)
  8000b8:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  8000bf:	0f 8e c7 00 00 00    	jle    80018c <_gettoken+0x159>
			cprintf("EOL\n");
  8000c5:	83 ec 0c             	sub    $0xc,%esp
  8000c8:	68 02 34 80 00       	push   $0x803402
  8000cd:	e8 ca 0a 00 00       	call   800b9c <cprintf>
  8000d2:	83 c4 10             	add    $0x10,%esp
		return 0;
  8000d5:	bf 00 00 00 00       	mov    $0x0,%edi
		**p2 = 0;
		cprintf("WORD: %s\n", *p1);
		**p2 = t;
	}
	return 'w';
}
  8000da:	89 f8                	mov    %edi,%eax
  8000dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8000df:	5b                   	pop    %ebx
  8000e0:	5e                   	pop    %esi
  8000e1:	5f                   	pop    %edi
  8000e2:	5d                   	pop    %ebp
  8000e3:	c3                   	ret    
	if (strchr(SYMBOLS, *s)) {
  8000e4:	83 ec 08             	sub    $0x8,%esp
  8000e7:	0f be c0             	movsbl %al,%eax
  8000ea:	50                   	push   %eax
  8000eb:	68 13 34 80 00       	push   $0x803413
  8000f0:	e8 99 12 00 00       	call   80138e <strchr>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	85 c0                	test   %eax,%eax
  8000fa:	74 2a                	je     800126 <_gettoken+0xf3>
		t = *s;
  8000fc:	0f be 3b             	movsbl (%ebx),%edi
		*p1 = s;
  8000ff:	89 1e                	mov    %ebx,(%esi)
		*s++ = 0;
  800101:	c6 03 00             	movb   $0x0,(%ebx)
  800104:	43                   	inc    %ebx
  800105:	8b 45 10             	mov    0x10(%ebp),%eax
  800108:	89 18                	mov    %ebx,(%eax)
		if (debug > 1)
  80010a:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800111:	7e c7                	jle    8000da <_gettoken+0xa7>
			cprintf("TOK %c\n", t);
  800113:	83 ec 08             	sub    $0x8,%esp
  800116:	57                   	push   %edi
  800117:	68 07 34 80 00       	push   $0x803407
  80011c:	e8 7b 0a 00 00       	call   800b9c <cprintf>
  800121:	83 c4 10             	add    $0x10,%esp
  800124:	eb b4                	jmp    8000da <_gettoken+0xa7>
	*p1 = s;
  800126:	89 1e                	mov    %ebx,(%esi)
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  800128:	eb 01                	jmp    80012b <_gettoken+0xf8>
		s++;
  80012a:	43                   	inc    %ebx
	while (*s && !strchr(WHITESPACE SYMBOLS, *s))
  80012b:	8a 03                	mov    (%ebx),%al
  80012d:	84 c0                	test   %al,%al
  80012f:	74 18                	je     800149 <_gettoken+0x116>
  800131:	83 ec 08             	sub    $0x8,%esp
  800134:	0f be c0             	movsbl %al,%eax
  800137:	50                   	push   %eax
  800138:	68 0f 34 80 00       	push   $0x80340f
  80013d:	e8 4c 12 00 00       	call   80138e <strchr>
  800142:	83 c4 10             	add    $0x10,%esp
  800145:	85 c0                	test   %eax,%eax
  800147:	74 e1                	je     80012a <_gettoken+0xf7>
	*p2 = s;
  800149:	8b 45 10             	mov    0x10(%ebp),%eax
  80014c:	89 18                	mov    %ebx,(%eax)
	if (debug > 1) {
  80014e:	83 3d 00 50 80 00 01 	cmpl   $0x1,0x805000
  800155:	7e 3f                	jle    800196 <_gettoken+0x163>
		t = **p2;
  800157:	0f b6 3b             	movzbl (%ebx),%edi
		**p2 = 0;
  80015a:	c6 03 00             	movb   $0x0,(%ebx)
		cprintf("WORD: %s\n", *p1);
  80015d:	83 ec 08             	sub    $0x8,%esp
  800160:	ff 36                	pushl  (%esi)
  800162:	68 1b 34 80 00       	push   $0x80341b
  800167:	e8 30 0a 00 00       	call   800b9c <cprintf>
		**p2 = t;
  80016c:	8b 45 10             	mov    0x10(%ebp),%eax
  80016f:	8b 00                	mov    (%eax),%eax
  800171:	89 fa                	mov    %edi,%edx
  800173:	88 10                	mov    %dl,(%eax)
  800175:	83 c4 10             	add    $0x10,%esp
	return 'w';
  800178:	bf 77 00 00 00       	mov    $0x77,%edi
  80017d:	e9 58 ff ff ff       	jmp    8000da <_gettoken+0xa7>
		return 0;
  800182:	bf 00 00 00 00       	mov    $0x0,%edi
  800187:	e9 4e ff ff ff       	jmp    8000da <_gettoken+0xa7>
		return 0;
  80018c:	bf 00 00 00 00       	mov    $0x0,%edi
  800191:	e9 44 ff ff ff       	jmp    8000da <_gettoken+0xa7>
	return 'w';
  800196:	bf 77 00 00 00       	mov    $0x77,%edi
  80019b:	e9 3a ff ff ff       	jmp    8000da <_gettoken+0xa7>

008001a0 <gettoken>:

int
gettoken(char *s, char **p1)
{
  8001a0:	55                   	push   %ebp
  8001a1:	89 e5                	mov    %esp,%ebp
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	8b 45 08             	mov    0x8(%ebp),%eax
	static int c, nc;
	static char* np1, *np2;

	if (s) {
  8001a9:	85 c0                	test   %eax,%eax
  8001ab:	74 22                	je     8001cf <gettoken+0x2f>
		nc = _gettoken(s, &np1, &np2);
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 0c 50 80 00       	push   $0x80500c
  8001b5:	68 10 50 80 00       	push   $0x805010
  8001ba:	50                   	push   %eax
  8001bb:	e8 73 fe ff ff       	call   800033 <_gettoken>
  8001c0:	a3 08 50 80 00       	mov    %eax,0x805008
		return 0;
  8001c5:	83 c4 10             	add    $0x10,%esp
  8001c8:	b8 00 00 00 00       	mov    $0x0,%eax
	}
	c = nc;
	*p1 = np1;
	nc = _gettoken(np2, &np1, &np2);
	return c;
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    
	c = nc;
  8001cf:	a1 08 50 80 00       	mov    0x805008,%eax
  8001d4:	a3 04 50 80 00       	mov    %eax,0x805004
	*p1 = np1;
  8001d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001dc:	8b 15 10 50 80 00    	mov    0x805010,%edx
  8001e2:	89 10                	mov    %edx,(%eax)
	nc = _gettoken(np2, &np1, &np2);
  8001e4:	83 ec 04             	sub    $0x4,%esp
  8001e7:	68 0c 50 80 00       	push   $0x80500c
  8001ec:	68 10 50 80 00       	push   $0x805010
  8001f1:	ff 35 0c 50 80 00    	pushl  0x80500c
  8001f7:	e8 37 fe ff ff       	call   800033 <_gettoken>
  8001fc:	a3 08 50 80 00       	mov    %eax,0x805008
	return c;
  800201:	a1 04 50 80 00       	mov    0x805004,%eax
  800206:	83 c4 10             	add    $0x10,%esp
  800209:	eb c2                	jmp    8001cd <gettoken+0x2d>

0080020b <runcmd>:
{
  80020b:	55                   	push   %ebp
  80020c:	89 e5                	mov    %esp,%ebp
  80020e:	57                   	push   %edi
  80020f:	56                   	push   %esi
  800210:	53                   	push   %ebx
  800211:	81 ec 64 04 00 00    	sub    $0x464,%esp
	gettoken(s, 0);
  800217:	6a 00                	push   $0x0
  800219:	ff 75 08             	pushl  0x8(%ebp)
  80021c:	e8 7f ff ff ff       	call   8001a0 <gettoken>
  800221:	83 c4 10             	add    $0x10,%esp
		switch ((c = gettoken(0, &t))) {
  800224:	8d 75 a4             	lea    -0x5c(%ebp),%esi
	argc = 0;
  800227:	bf 00 00 00 00       	mov    $0x0,%edi
		switch ((c = gettoken(0, &t))) {
  80022c:	83 ec 08             	sub    $0x8,%esp
  80022f:	56                   	push   %esi
  800230:	6a 00                	push   $0x0
  800232:	e8 69 ff ff ff       	call   8001a0 <gettoken>
  800237:	89 c3                	mov    %eax,%ebx
  800239:	83 c4 10             	add    $0x10,%esp
  80023c:	83 f8 3e             	cmp    $0x3e,%eax
  80023f:	0f 84 30 01 00 00    	je     800375 <runcmd+0x16a>
  800245:	83 f8 3e             	cmp    $0x3e,%eax
  800248:	7f 72                	jg     8002bc <runcmd+0xb1>
  80024a:	85 c0                	test   %eax,%eax
  80024c:	0f 84 2d 02 00 00    	je     80047f <runcmd+0x274>
  800252:	83 f8 3c             	cmp    $0x3c,%eax
  800255:	0f 85 6b 02 00 00    	jne    8004c6 <runcmd+0x2bb>
			if (gettoken(0, &t) != 'w') {
  80025b:	83 ec 08             	sub    $0x8,%esp
  80025e:	56                   	push   %esi
  80025f:	6a 00                	push   $0x0
  800261:	e8 3a ff ff ff       	call   8001a0 <gettoken>
  800266:	83 c4 10             	add    $0x10,%esp
  800269:	83 f8 77             	cmp    $0x77,%eax
  80026c:	74 15                	je     800283 <runcmd+0x78>
				cprintf("syntax error: < not followed by word\n");
  80026e:	83 ec 0c             	sub    $0xc,%esp
  800271:	68 64 35 80 00       	push   $0x803564
  800276:	e8 21 09 00 00       	call   800b9c <cprintf>
				exit();
  80027b:	e8 ef 07 00 00       	call   800a6f <exit>
  800280:	83 c4 10             	add    $0x10,%esp
			if ((fd = open(t, O_RDONLY)) < 0) {
  800283:	83 ec 08             	sub    $0x8,%esp
  800286:	6a 00                	push   $0x0
  800288:	ff 75 a4             	pushl  -0x5c(%ebp)
  80028b:	e8 ea 21 00 00       	call   80247a <open>
  800290:	89 c3                	mov    %eax,%ebx
  800292:	83 c4 10             	add    $0x10,%esp
  800295:	85 c0                	test   %eax,%eax
  800297:	0f 88 ba 00 00 00    	js     800357 <runcmd+0x14c>
			if (fd != 0) {
  80029d:	85 c0                	test   %eax,%eax
  80029f:	74 8b                	je     80022c <runcmd+0x21>
				dup(fd, 0);
  8002a1:	83 ec 08             	sub    $0x8,%esp
  8002a4:	6a 00                	push   $0x0
  8002a6:	53                   	push   %ebx
  8002a7:	e8 30 1c 00 00       	call   801edc <dup>
				close(fd);
  8002ac:	89 1c 24             	mov    %ebx,(%esp)
  8002af:	e8 da 1b 00 00       	call   801e8e <close>
  8002b4:	83 c4 10             	add    $0x10,%esp
  8002b7:	e9 70 ff ff ff       	jmp    80022c <runcmd+0x21>
		switch ((c = gettoken(0, &t))) {
  8002bc:	83 f8 77             	cmp    $0x77,%eax
  8002bf:	74 6b                	je     80032c <runcmd+0x121>
  8002c1:	83 f8 7c             	cmp    $0x7c,%eax
  8002c4:	0f 85 fc 01 00 00    	jne    8004c6 <runcmd+0x2bb>
			if ((r = pipe(p)) < 0) {
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	8d 85 9c fb ff ff    	lea    -0x464(%ebp),%eax
  8002d3:	50                   	push   %eax
  8002d4:	e8 04 2b 00 00       	call   802ddd <pipe>
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	85 c0                	test   %eax,%eax
  8002de:	0f 88 11 01 00 00    	js     8003f5 <runcmd+0x1ea>
			if (debug)
  8002e4:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8002eb:	0f 85 1f 01 00 00    	jne    800410 <runcmd+0x205>
			if ((r = fork()) < 0) {
  8002f1:	e8 d5 16 00 00       	call   8019cb <fork>
  8002f6:	89 c3                	mov    %eax,%ebx
  8002f8:	85 c0                	test   %eax,%eax
  8002fa:	0f 88 31 01 00 00    	js     800431 <runcmd+0x226>
			if (r == 0) {
  800300:	85 c0                	test   %eax,%eax
  800302:	0f 85 3f 01 00 00    	jne    800447 <runcmd+0x23c>
				if (p[0] != 0) {
  800308:	8b 85 9c fb ff ff    	mov    -0x464(%ebp),%eax
  80030e:	85 c0                	test   %eax,%eax
  800310:	0f 85 8f 01 00 00    	jne    8004a5 <runcmd+0x29a>
				close(p[1]);
  800316:	83 ec 0c             	sub    $0xc,%esp
  800319:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  80031f:	e8 6a 1b 00 00       	call   801e8e <close>
				goto again;
  800324:	83 c4 10             	add    $0x10,%esp
  800327:	e9 fb fe ff ff       	jmp    800227 <runcmd+0x1c>
			if (argc == MAXARGS) {
  80032c:	83 ff 10             	cmp    $0x10,%edi
  80032f:	74 0f                	je     800340 <runcmd+0x135>
			argv[argc++] = t;
  800331:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  800334:	89 44 bd a8          	mov    %eax,-0x58(%ebp,%edi,4)
  800338:	8d 7f 01             	lea    0x1(%edi),%edi
			break;
  80033b:	e9 ec fe ff ff       	jmp    80022c <runcmd+0x21>
				cprintf("too many arguments\n");
  800340:	83 ec 0c             	sub    $0xc,%esp
  800343:	68 25 34 80 00       	push   $0x803425
  800348:	e8 4f 08 00 00       	call   800b9c <cprintf>
				exit();
  80034d:	e8 1d 07 00 00       	call   800a6f <exit>
  800352:	83 c4 10             	add    $0x10,%esp
  800355:	eb da                	jmp    800331 <runcmd+0x126>
				cprintf("open %s for write: %e", t, fd);
  800357:	83 ec 04             	sub    $0x4,%esp
  80035a:	50                   	push   %eax
  80035b:	ff 75 a4             	pushl  -0x5c(%ebp)
  80035e:	68 39 34 80 00       	push   $0x803439
  800363:	e8 34 08 00 00       	call   800b9c <cprintf>
				exit();
  800368:	e8 02 07 00 00       	call   800a6f <exit>
  80036d:	83 c4 10             	add    $0x10,%esp
  800370:	e9 2c ff ff ff       	jmp    8002a1 <runcmd+0x96>
			if (gettoken(0, &t) != 'w') {
  800375:	83 ec 08             	sub    $0x8,%esp
  800378:	56                   	push   %esi
  800379:	6a 00                	push   $0x0
  80037b:	e8 20 fe ff ff       	call   8001a0 <gettoken>
  800380:	83 c4 10             	add    $0x10,%esp
  800383:	83 f8 77             	cmp    $0x77,%eax
  800386:	74 15                	je     80039d <runcmd+0x192>
				cprintf("syntax error: > not followed by word\n");
  800388:	83 ec 0c             	sub    $0xc,%esp
  80038b:	68 8c 35 80 00       	push   $0x80358c
  800390:	e8 07 08 00 00       	call   800b9c <cprintf>
				exit();
  800395:	e8 d5 06 00 00       	call   800a6f <exit>
  80039a:	83 c4 10             	add    $0x10,%esp
			if ((fd = open(t, O_WRONLY|O_CREAT|O_TRUNC)) < 0) {
  80039d:	83 ec 08             	sub    $0x8,%esp
  8003a0:	68 01 03 00 00       	push   $0x301
  8003a5:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003a8:	e8 cd 20 00 00       	call   80247a <open>
  8003ad:	89 c3                	mov    %eax,%ebx
  8003af:	83 c4 10             	add    $0x10,%esp
  8003b2:	85 c0                	test   %eax,%eax
  8003b4:	78 24                	js     8003da <runcmd+0x1cf>
			if (fd != 1) {
  8003b6:	83 fb 01             	cmp    $0x1,%ebx
  8003b9:	0f 84 6d fe ff ff    	je     80022c <runcmd+0x21>
				dup(fd, 1);
  8003bf:	83 ec 08             	sub    $0x8,%esp
  8003c2:	6a 01                	push   $0x1
  8003c4:	53                   	push   %ebx
  8003c5:	e8 12 1b 00 00       	call   801edc <dup>
				close(fd);
  8003ca:	89 1c 24             	mov    %ebx,(%esp)
  8003cd:	e8 bc 1a 00 00       	call   801e8e <close>
  8003d2:	83 c4 10             	add    $0x10,%esp
  8003d5:	e9 52 fe ff ff       	jmp    80022c <runcmd+0x21>
				cprintf("open %s for write: %e", t, fd);
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	50                   	push   %eax
  8003de:	ff 75 a4             	pushl  -0x5c(%ebp)
  8003e1:	68 39 34 80 00       	push   $0x803439
  8003e6:	e8 b1 07 00 00       	call   800b9c <cprintf>
				exit();
  8003eb:	e8 7f 06 00 00       	call   800a6f <exit>
  8003f0:	83 c4 10             	add    $0x10,%esp
  8003f3:	eb c1                	jmp    8003b6 <runcmd+0x1ab>
				cprintf("pipe: %e", r);
  8003f5:	83 ec 08             	sub    $0x8,%esp
  8003f8:	50                   	push   %eax
  8003f9:	68 4f 34 80 00       	push   $0x80344f
  8003fe:	e8 99 07 00 00       	call   800b9c <cprintf>
				exit();
  800403:	e8 67 06 00 00       	call   800a6f <exit>
  800408:	83 c4 10             	add    $0x10,%esp
  80040b:	e9 d4 fe ff ff       	jmp    8002e4 <runcmd+0xd9>
				cprintf("PIPE: %d %d\n", p[0], p[1]);
  800410:	83 ec 04             	sub    $0x4,%esp
  800413:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800419:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  80041f:	68 58 34 80 00       	push   $0x803458
  800424:	e8 73 07 00 00       	call   800b9c <cprintf>
  800429:	83 c4 10             	add    $0x10,%esp
  80042c:	e9 c0 fe ff ff       	jmp    8002f1 <runcmd+0xe6>
				cprintf("fork: %e", r);
  800431:	83 ec 08             	sub    $0x8,%esp
  800434:	50                   	push   %eax
  800435:	68 65 34 80 00       	push   $0x803465
  80043a:	e8 5d 07 00 00       	call   800b9c <cprintf>
				exit();
  80043f:	e8 2b 06 00 00       	call   800a6f <exit>
  800444:	83 c4 10             	add    $0x10,%esp
				if (p[1] != 1) {
  800447:	8b 85 a0 fb ff ff    	mov    -0x460(%ebp),%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 1c                	je     80046e <runcmd+0x263>
					dup(p[1], 1);
  800452:	83 ec 08             	sub    $0x8,%esp
  800455:	6a 01                	push   $0x1
  800457:	50                   	push   %eax
  800458:	e8 7f 1a 00 00       	call   801edc <dup>
					close(p[1]);
  80045d:	83 c4 04             	add    $0x4,%esp
  800460:	ff b5 a0 fb ff ff    	pushl  -0x460(%ebp)
  800466:	e8 23 1a 00 00       	call   801e8e <close>
  80046b:	83 c4 10             	add    $0x10,%esp
				close(p[0]);
  80046e:	83 ec 0c             	sub    $0xc,%esp
  800471:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  800477:	e8 12 1a 00 00       	call   801e8e <close>
				goto runit;
  80047c:	83 c4 10             	add    $0x10,%esp
	if(argc == 0) {
  80047f:	85 ff                	test   %edi,%edi
  800481:	75 55                	jne    8004d8 <runcmd+0x2cd>
		if (debug)
  800483:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80048a:	0f 84 ed 00 00 00    	je     80057d <runcmd+0x372>
			cprintf("EMPTY COMMAND\n");
  800490:	83 ec 0c             	sub    $0xc,%esp
  800493:	68 94 34 80 00       	push   $0x803494
  800498:	e8 ff 06 00 00       	call   800b9c <cprintf>
  80049d:	83 c4 10             	add    $0x10,%esp
  8004a0:	e9 d8 00 00 00       	jmp    80057d <runcmd+0x372>
					dup(p[0], 0);
  8004a5:	83 ec 08             	sub    $0x8,%esp
  8004a8:	6a 00                	push   $0x0
  8004aa:	50                   	push   %eax
  8004ab:	e8 2c 1a 00 00       	call   801edc <dup>
					close(p[0]);
  8004b0:	83 c4 04             	add    $0x4,%esp
  8004b3:	ff b5 9c fb ff ff    	pushl  -0x464(%ebp)
  8004b9:	e8 d0 19 00 00       	call   801e8e <close>
  8004be:	83 c4 10             	add    $0x10,%esp
  8004c1:	e9 50 fe ff ff       	jmp    800316 <runcmd+0x10b>
			panic("bad return %d from gettoken", c);
  8004c6:	53                   	push   %ebx
  8004c7:	68 6e 34 80 00       	push   $0x80346e
  8004cc:	6a 77                	push   $0x77
  8004ce:	68 8a 34 80 00       	push   $0x80348a
  8004d3:	e8 b1 05 00 00       	call   800a89 <_panic>
	if (argv[0][0] != '/') {
  8004d8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004db:	80 38 2f             	cmpb   $0x2f,(%eax)
  8004de:	74 23                	je     800503 <runcmd+0x2f8>
		argv0buf[0] = '/';
  8004e0:	c6 85 a4 fb ff ff 2f 	movb   $0x2f,-0x45c(%ebp)
		strcpy(argv0buf + 1, argv[0]);
  8004e7:	83 ec 08             	sub    $0x8,%esp
  8004ea:	50                   	push   %eax
  8004eb:	8d b5 a4 fb ff ff    	lea    -0x45c(%ebp),%esi
  8004f1:	8d 85 a5 fb ff ff    	lea    -0x45b(%ebp),%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 a0 0d 00 00       	call   80129d <strcpy>
		argv[0] = argv0buf;
  8004fd:	89 75 a8             	mov    %esi,-0x58(%ebp)
  800500:	83 c4 10             	add    $0x10,%esp
	argv[argc] = 0;
  800503:	c7 44 bd a8 00 00 00 	movl   $0x0,-0x58(%ebp,%edi,4)
  80050a:	00 
	if (debug) {
  80050b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800512:	75 71                	jne    800585 <runcmd+0x37a>
	if ((r = spawn(argv[0], (const char**) argv)) < 0)
  800514:	83 ec 08             	sub    $0x8,%esp
  800517:	8d 45 a8             	lea    -0x58(%ebp),%eax
  80051a:	50                   	push   %eax
  80051b:	ff 75 a8             	pushl  -0x58(%ebp)
  80051e:	e8 0f 21 00 00       	call   802632 <spawn>
  800523:	89 c6                	mov    %eax,%esi
  800525:	83 c4 10             	add    $0x10,%esp
  800528:	85 c0                	test   %eax,%eax
  80052a:	0f 88 a3 00 00 00    	js     8005d3 <runcmd+0x3c8>
	close_all();
  800530:	e8 84 19 00 00       	call   801eb9 <close_all>
		if (debug)
  800535:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80053c:	0f 85 ac 00 00 00    	jne    8005ee <runcmd+0x3e3>
		wait(r);
  800542:	83 ec 0c             	sub    $0xc,%esp
  800545:	56                   	push   %esi
  800546:	e8 16 2a 00 00       	call   802f61 <wait>
		if (debug)
  80054b:	83 c4 10             	add    $0x10,%esp
  80054e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800555:	0f 85 b2 00 00 00    	jne    80060d <runcmd+0x402>
	if (pipe_child) {
  80055b:	85 db                	test   %ebx,%ebx
  80055d:	74 19                	je     800578 <runcmd+0x36d>
		wait(pipe_child);
  80055f:	83 ec 0c             	sub    $0xc,%esp
  800562:	53                   	push   %ebx
  800563:	e8 f9 29 00 00       	call   802f61 <wait>
		if (debug)
  800568:	83 c4 10             	add    $0x10,%esp
  80056b:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800572:	0f 85 e2 00 00 00    	jne    80065a <runcmd+0x44f>
	exit();
  800578:	e8 f2 04 00 00       	call   800a6f <exit>
}
  80057d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800580:	5b                   	pop    %ebx
  800581:	5e                   	pop    %esi
  800582:	5f                   	pop    %edi
  800583:	5d                   	pop    %ebp
  800584:	c3                   	ret    
		cprintf("[%08x] SPAWN:", thisenv->env_id);
  800585:	a1 24 54 80 00       	mov    0x805424,%eax
  80058a:	8b 40 48             	mov    0x48(%eax),%eax
  80058d:	83 ec 08             	sub    $0x8,%esp
  800590:	50                   	push   %eax
  800591:	68 a3 34 80 00       	push   $0x8034a3
  800596:	e8 01 06 00 00       	call   800b9c <cprintf>
  80059b:	8d 75 a8             	lea    -0x58(%ebp),%esi
		for (i = 0; argv[i]; i++)
  80059e:	83 c4 10             	add    $0x10,%esp
  8005a1:	eb 11                	jmp    8005b4 <runcmd+0x3a9>
			cprintf(" %s", argv[i]);
  8005a3:	83 ec 08             	sub    $0x8,%esp
  8005a6:	50                   	push   %eax
  8005a7:	68 2b 35 80 00       	push   $0x80352b
  8005ac:	e8 eb 05 00 00       	call   800b9c <cprintf>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 c6 04             	add    $0x4,%esi
		for (i = 0; argv[i]; i++)
  8005b7:	8b 46 fc             	mov    -0x4(%esi),%eax
  8005ba:	85 c0                	test   %eax,%eax
  8005bc:	75 e5                	jne    8005a3 <runcmd+0x398>
		cprintf("\n");
  8005be:	83 ec 0c             	sub    $0xc,%esp
  8005c1:	68 00 34 80 00       	push   $0x803400
  8005c6:	e8 d1 05 00 00       	call   800b9c <cprintf>
  8005cb:	83 c4 10             	add    $0x10,%esp
  8005ce:	e9 41 ff ff ff       	jmp    800514 <runcmd+0x309>
		cprintf("spawn %s: %e\n", argv[0], r);
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	50                   	push   %eax
  8005d7:	ff 75 a8             	pushl  -0x58(%ebp)
  8005da:	68 b1 34 80 00       	push   $0x8034b1
  8005df:	e8 b8 05 00 00       	call   800b9c <cprintf>
	close_all();
  8005e4:	e8 d0 18 00 00       	call   801eb9 <close_all>
  8005e9:	83 c4 10             	add    $0x10,%esp
  8005ec:	eb 38                	jmp    800626 <runcmd+0x41b>
			cprintf("[%08x] WAIT %s %08x\n", thisenv->env_id, argv[0], r);
  8005ee:	a1 24 54 80 00       	mov    0x805424,%eax
  8005f3:	8b 40 48             	mov    0x48(%eax),%eax
  8005f6:	56                   	push   %esi
  8005f7:	ff 75 a8             	pushl  -0x58(%ebp)
  8005fa:	50                   	push   %eax
  8005fb:	68 bf 34 80 00       	push   $0x8034bf
  800600:	e8 97 05 00 00       	call   800b9c <cprintf>
  800605:	83 c4 10             	add    $0x10,%esp
  800608:	e9 35 ff ff ff       	jmp    800542 <runcmd+0x337>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80060d:	a1 24 54 80 00       	mov    0x805424,%eax
  800612:	8b 40 48             	mov    0x48(%eax),%eax
  800615:	83 ec 08             	sub    $0x8,%esp
  800618:	50                   	push   %eax
  800619:	68 d4 34 80 00       	push   $0x8034d4
  80061e:	e8 79 05 00 00       	call   800b9c <cprintf>
  800623:	83 c4 10             	add    $0x10,%esp
	if (pipe_child) {
  800626:	85 db                	test   %ebx,%ebx
  800628:	0f 84 4a ff ff ff    	je     800578 <runcmd+0x36d>
		if (debug)
  80062e:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800635:	0f 84 24 ff ff ff    	je     80055f <runcmd+0x354>
			cprintf("[%08x] WAIT pipe_child %08x\n", thisenv->env_id, pipe_child);
  80063b:	a1 24 54 80 00       	mov    0x805424,%eax
  800640:	8b 40 48             	mov    0x48(%eax),%eax
  800643:	83 ec 04             	sub    $0x4,%esp
  800646:	53                   	push   %ebx
  800647:	50                   	push   %eax
  800648:	68 ea 34 80 00       	push   $0x8034ea
  80064d:	e8 4a 05 00 00       	call   800b9c <cprintf>
  800652:	83 c4 10             	add    $0x10,%esp
  800655:	e9 05 ff ff ff       	jmp    80055f <runcmd+0x354>
			cprintf("[%08x] wait finished\n", thisenv->env_id);
  80065a:	a1 24 54 80 00       	mov    0x805424,%eax
  80065f:	8b 40 48             	mov    0x48(%eax),%eax
  800662:	83 ec 08             	sub    $0x8,%esp
  800665:	50                   	push   %eax
  800666:	68 d4 34 80 00       	push   $0x8034d4
  80066b:	e8 2c 05 00 00       	call   800b9c <cprintf>
  800670:	83 c4 10             	add    $0x10,%esp
  800673:	e9 00 ff ff ff       	jmp    800578 <runcmd+0x36d>

00800678 <usage>:


void
usage(void)
{
  800678:	55                   	push   %ebp
  800679:	89 e5                	mov    %esp,%ebp
  80067b:	83 ec 14             	sub    $0x14,%esp
	cprintf("usage: sh [-dix] [command-file]\n");
  80067e:	68 b4 35 80 00       	push   $0x8035b4
  800683:	e8 14 05 00 00       	call   800b9c <cprintf>
	exit();
  800688:	e8 e2 03 00 00       	call   800a6f <exit>
}
  80068d:	83 c4 10             	add    $0x10,%esp
  800690:	c9                   	leave  
  800691:	c3                   	ret    

00800692 <umain>:

void
umain(int argc, char **argv)
{
  800692:	55                   	push   %ebp
  800693:	89 e5                	mov    %esp,%ebp
  800695:	57                   	push   %edi
  800696:	56                   	push   %esi
  800697:	53                   	push   %ebx
  800698:	83 ec 30             	sub    $0x30,%esp
	int r, interactive, echocmds;
	struct Argstate args;

	interactive = '?';
	echocmds = 0;
	argstart(&argc, argv, &args);
  80069b:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80069e:	50                   	push   %eax
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	8d 45 08             	lea    0x8(%ebp),%eax
  8006a5:	50                   	push   %eax
  8006a6:	e8 e1 14 00 00       	call   801b8c <argstart>
	while ((r = argnext(&args)) >= 0)
  8006ab:	83 c4 10             	add    $0x10,%esp
	echocmds = 0;
  8006ae:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
	interactive = '?';
  8006b5:	be 3f 00 00 00       	mov    $0x3f,%esi
	while ((r = argnext(&args)) >= 0)
  8006ba:	8d 5d d8             	lea    -0x28(%ebp),%ebx
		switch (r) {
		case 'd':
			debug++;
			break;
		case 'i':
			interactive = 1;
  8006bd:	bf 01 00 00 00       	mov    $0x1,%edi
	while ((r = argnext(&args)) >= 0)
  8006c2:	eb 03                	jmp    8006c7 <umain+0x35>
			break;
		case 'x':
			echocmds = 1;
  8006c4:	89 7d d4             	mov    %edi,-0x2c(%ebp)
	while ((r = argnext(&args)) >= 0)
  8006c7:	83 ec 0c             	sub    $0xc,%esp
  8006ca:	53                   	push   %ebx
  8006cb:	e8 f5 14 00 00       	call   801bc5 <argnext>
  8006d0:	83 c4 10             	add    $0x10,%esp
  8006d3:	85 c0                	test   %eax,%eax
  8006d5:	78 22                	js     8006f9 <umain+0x67>
		switch (r) {
  8006d7:	83 f8 69             	cmp    $0x69,%eax
  8006da:	74 19                	je     8006f5 <umain+0x63>
  8006dc:	83 f8 78             	cmp    $0x78,%eax
  8006df:	74 e3                	je     8006c4 <umain+0x32>
  8006e1:	83 f8 64             	cmp    $0x64,%eax
  8006e4:	74 07                	je     8006ed <umain+0x5b>
			break;
		default:
			usage();
  8006e6:	e8 8d ff ff ff       	call   800678 <usage>
  8006eb:	eb da                	jmp    8006c7 <umain+0x35>
			debug++;
  8006ed:	ff 05 00 50 80 00    	incl   0x805000
			break;
  8006f3:	eb d2                	jmp    8006c7 <umain+0x35>
			interactive = 1;
  8006f5:	89 fe                	mov    %edi,%esi
  8006f7:	eb ce                	jmp    8006c7 <umain+0x35>
		}

	if (argc > 2)
  8006f9:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  8006fd:	7f 1d                	jg     80071c <umain+0x8a>
		usage();
	if (argc == 2) {
  8006ff:	83 7d 08 02          	cmpl   $0x2,0x8(%ebp)
  800703:	74 1e                	je     800723 <umain+0x91>
		close(0);
		if ((r = open(argv[1], O_RDONLY)) < 0)
			panic("open %s: %e", argv[1], r);
		assert(r == 0);
	}
	if (interactive == '?')
  800705:	83 fe 3f             	cmp    $0x3f,%esi
  800708:	74 75                	je     80077f <umain+0xed>
  80070a:	85 f6                	test   %esi,%esi
  80070c:	0f 84 81 00 00 00    	je     800793 <umain+0x101>
  800712:	bf 2f 35 80 00       	mov    $0x80352f,%edi
  800717:	e9 12 01 00 00       	jmp    80082e <umain+0x19c>
		usage();
  80071c:	e8 57 ff ff ff       	call   800678 <usage>
  800721:	eb dc                	jmp    8006ff <umain+0x6d>
		close(0);
  800723:	83 ec 0c             	sub    $0xc,%esp
  800726:	6a 00                	push   $0x0
  800728:	e8 61 17 00 00       	call   801e8e <close>
		if ((r = open(argv[1], O_RDONLY)) < 0)
  80072d:	83 c4 08             	add    $0x8,%esp
  800730:	6a 00                	push   $0x0
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	ff 70 04             	pushl  0x4(%eax)
  800738:	e8 3d 1d 00 00       	call   80247a <open>
  80073d:	83 c4 10             	add    $0x10,%esp
  800740:	85 c0                	test   %eax,%eax
  800742:	78 1d                	js     800761 <umain+0xcf>
		assert(r == 0);
  800744:	85 c0                	test   %eax,%eax
  800746:	74 bd                	je     800705 <umain+0x73>
  800748:	68 13 35 80 00       	push   $0x803513
  80074d:	68 1a 35 80 00       	push   $0x80351a
  800752:	68 28 01 00 00       	push   $0x128
  800757:	68 8a 34 80 00       	push   $0x80348a
  80075c:	e8 28 03 00 00       	call   800a89 <_panic>
			panic("open %s: %e", argv[1], r);
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	50                   	push   %eax
  800765:	8b 45 0c             	mov    0xc(%ebp),%eax
  800768:	ff 70 04             	pushl  0x4(%eax)
  80076b:	68 07 35 80 00       	push   $0x803507
  800770:	68 27 01 00 00       	push   $0x127
  800775:	68 8a 34 80 00       	push   $0x80348a
  80077a:	e8 0a 03 00 00       	call   800a89 <_panic>
		interactive = iscons(0);
  80077f:	83 ec 0c             	sub    $0xc,%esp
  800782:	6a 00                	push   $0x0
  800784:	e8 1c 02 00 00       	call   8009a5 <iscons>
  800789:	89 c6                	mov    %eax,%esi
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	e9 77 ff ff ff       	jmp    80070a <umain+0x78>
  800793:	bf 00 00 00 00       	mov    $0x0,%edi
  800798:	e9 91 00 00 00       	jmp    80082e <umain+0x19c>
	while (1) {
		char *buf;

		buf = readline(interactive ? "$ " : NULL);
		if (buf == NULL) {
			if (debug)
  80079d:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  8007a4:	75 0a                	jne    8007b0 <umain+0x11e>
				cprintf("EXITING\n");
			exit();	// end of file
  8007a6:	e8 c4 02 00 00       	call   800a6f <exit>
  8007ab:	e9 94 00 00 00       	jmp    800844 <umain+0x1b2>
				cprintf("EXITING\n");
  8007b0:	83 ec 0c             	sub    $0xc,%esp
  8007b3:	68 32 35 80 00       	push   $0x803532
  8007b8:	e8 df 03 00 00       	call   800b9c <cprintf>
  8007bd:	83 c4 10             	add    $0x10,%esp
  8007c0:	eb e4                	jmp    8007a6 <umain+0x114>
		}
		if (debug)
			cprintf("LINE: %s\n", buf);
  8007c2:	83 ec 08             	sub    $0x8,%esp
  8007c5:	53                   	push   %ebx
  8007c6:	68 3b 35 80 00       	push   $0x80353b
  8007cb:	e8 cc 03 00 00       	call   800b9c <cprintf>
  8007d0:	83 c4 10             	add    $0x10,%esp
  8007d3:	eb 7c                	jmp    800851 <umain+0x1bf>
		if (buf[0] == '#')
			continue;
		if (echocmds)
			printf("# %s\n", buf);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	53                   	push   %ebx
  8007d9:	68 45 35 80 00       	push   $0x803545
  8007de:	e8 39 1e 00 00       	call   80261c <printf>
  8007e3:	83 c4 10             	add    $0x10,%esp
  8007e6:	eb 78                	jmp    800860 <umain+0x1ce>
		if (debug)
			cprintf("BEFORE FORK\n");
  8007e8:	83 ec 0c             	sub    $0xc,%esp
  8007eb:	68 4b 35 80 00       	push   $0x80354b
  8007f0:	e8 a7 03 00 00       	call   800b9c <cprintf>
  8007f5:	83 c4 10             	add    $0x10,%esp
  8007f8:	eb 73                	jmp    80086d <umain+0x1db>
		if ((r = fork()) < 0)
			panic("fork: %e", r);
  8007fa:	50                   	push   %eax
  8007fb:	68 65 34 80 00       	push   $0x803465
  800800:	68 3f 01 00 00       	push   $0x13f
  800805:	68 8a 34 80 00       	push   $0x80348a
  80080a:	e8 7a 02 00 00       	call   800a89 <_panic>
		if (debug)
			cprintf("FORK: %d\n", r);
  80080f:	83 ec 08             	sub    $0x8,%esp
  800812:	50                   	push   %eax
  800813:	68 58 35 80 00       	push   $0x803558
  800818:	e8 7f 03 00 00       	call   800b9c <cprintf>
  80081d:	83 c4 10             	add    $0x10,%esp
  800820:	eb 5f                	jmp    800881 <umain+0x1ef>
		if (r == 0) {
			runcmd(buf);
			exit();
		} else
			wait(r);
  800822:	83 ec 0c             	sub    $0xc,%esp
  800825:	56                   	push   %esi
  800826:	e8 36 27 00 00       	call   802f61 <wait>
  80082b:	83 c4 10             	add    $0x10,%esp
		buf = readline(interactive ? "$ " : NULL);
  80082e:	83 ec 0c             	sub    $0xc,%esp
  800831:	57                   	push   %edi
  800832:	e8 3a 09 00 00       	call   801171 <readline>
  800837:	89 c3                	mov    %eax,%ebx
		if (buf == NULL) {
  800839:	83 c4 10             	add    $0x10,%esp
  80083c:	85 c0                	test   %eax,%eax
  80083e:	0f 84 59 ff ff ff    	je     80079d <umain+0x10b>
		if (debug)
  800844:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80084b:	0f 85 71 ff ff ff    	jne    8007c2 <umain+0x130>
		if (buf[0] == '#')
  800851:	80 3b 23             	cmpb   $0x23,(%ebx)
  800854:	74 d8                	je     80082e <umain+0x19c>
		if (echocmds)
  800856:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
  80085a:	0f 85 75 ff ff ff    	jne    8007d5 <umain+0x143>
		if (debug)
  800860:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  800867:	0f 85 7b ff ff ff    	jne    8007e8 <umain+0x156>
		if ((r = fork()) < 0)
  80086d:	e8 59 11 00 00       	call   8019cb <fork>
  800872:	89 c6                	mov    %eax,%esi
  800874:	85 c0                	test   %eax,%eax
  800876:	78 82                	js     8007fa <umain+0x168>
		if (debug)
  800878:	83 3d 00 50 80 00 00 	cmpl   $0x0,0x805000
  80087f:	75 8e                	jne    80080f <umain+0x17d>
		if (r == 0) {
  800881:	85 f6                	test   %esi,%esi
  800883:	75 9d                	jne    800822 <umain+0x190>
			runcmd(buf);
  800885:	83 ec 0c             	sub    $0xc,%esp
  800888:	53                   	push   %ebx
  800889:	e8 7d f9 ff ff       	call   80020b <runcmd>
			exit();
  80088e:	e8 dc 01 00 00       	call   800a6f <exit>
  800893:	83 c4 10             	add    $0x10,%esp
  800896:	eb 96                	jmp    80082e <umain+0x19c>

00800898 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800898:	55                   	push   %ebp
  800899:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  80089b:	b8 00 00 00 00       	mov    $0x0,%eax
  8008a0:	5d                   	pop    %ebp
  8008a1:	c3                   	ret    

008008a2 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	53                   	push   %ebx
  8008a6:	83 ec 0c             	sub    $0xc,%esp
  8008a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8008ac:	68 d5 35 80 00       	push   $0x8035d5
  8008b1:	53                   	push   %ebx
  8008b2:	e8 e6 09 00 00       	call   80129d <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8008b7:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8008be:	20 00 00 
	return 0;
}
  8008c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8008c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008c9:	c9                   	leave  
  8008ca:	c3                   	ret    

008008cb <devcons_write>:
{
  8008cb:	55                   	push   %ebp
  8008cc:	89 e5                	mov    %esp,%ebp
  8008ce:	57                   	push   %edi
  8008cf:	56                   	push   %esi
  8008d0:	53                   	push   %ebx
  8008d1:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  8008d7:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  8008dc:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  8008e2:	eb 1d                	jmp    800901 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  8008e4:	83 ec 04             	sub    $0x4,%esp
  8008e7:	53                   	push   %ebx
  8008e8:	03 45 0c             	add    0xc(%ebp),%eax
  8008eb:	50                   	push   %eax
  8008ec:	57                   	push   %edi
  8008ed:	e8 1e 0b 00 00       	call   801410 <memmove>
		sys_cputs(buf, m);
  8008f2:	83 c4 08             	add    $0x8,%esp
  8008f5:	53                   	push   %ebx
  8008f6:	57                   	push   %edi
  8008f7:	e8 b9 0c 00 00       	call   8015b5 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  8008fc:	01 de                	add    %ebx,%esi
  8008fe:	83 c4 10             	add    $0x10,%esp
  800901:	89 f0                	mov    %esi,%eax
  800903:	3b 75 10             	cmp    0x10(%ebp),%esi
  800906:	73 11                	jae    800919 <devcons_write+0x4e>
		m = n - tot;
  800908:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80090b:	29 f3                	sub    %esi,%ebx
  80090d:	83 fb 7f             	cmp    $0x7f,%ebx
  800910:	76 d2                	jbe    8008e4 <devcons_write+0x19>
  800912:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800917:	eb cb                	jmp    8008e4 <devcons_write+0x19>
}
  800919:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80091c:	5b                   	pop    %ebx
  80091d:	5e                   	pop    %esi
  80091e:	5f                   	pop    %edi
  80091f:	5d                   	pop    %ebp
  800920:	c3                   	ret    

00800921 <devcons_read>:
{
  800921:	55                   	push   %ebp
  800922:	89 e5                	mov    %esp,%ebp
  800924:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  800927:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80092b:	75 0c                	jne    800939 <devcons_read+0x18>
		return 0;
  80092d:	b8 00 00 00 00       	mov    $0x0,%eax
  800932:	eb 21                	jmp    800955 <devcons_read+0x34>
		sys_yield();
  800934:	e8 e0 0d 00 00       	call   801719 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  800939:	e8 95 0c 00 00       	call   8015d3 <sys_cgetc>
  80093e:	85 c0                	test   %eax,%eax
  800940:	74 f2                	je     800934 <devcons_read+0x13>
	if (c < 0)
  800942:	85 c0                	test   %eax,%eax
  800944:	78 0f                	js     800955 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  800946:	83 f8 04             	cmp    $0x4,%eax
  800949:	74 0c                	je     800957 <devcons_read+0x36>
	*(char*)vbuf = c;
  80094b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80094e:	88 02                	mov    %al,(%edx)
	return 1;
  800950:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800955:	c9                   	leave  
  800956:	c3                   	ret    
		return 0;
  800957:	b8 00 00 00 00       	mov    $0x0,%eax
  80095c:	eb f7                	jmp    800955 <devcons_read+0x34>

0080095e <cputchar>:
{
  80095e:	55                   	push   %ebp
  80095f:	89 e5                	mov    %esp,%ebp
  800961:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80096a:	6a 01                	push   $0x1
  80096c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 40 0c 00 00       	call   8015b5 <sys_cputs>
}
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <getchar>:
{
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  800980:	6a 01                	push   $0x1
  800982:	8d 45 f7             	lea    -0x9(%ebp),%eax
  800985:	50                   	push   %eax
  800986:	6a 00                	push   $0x0
  800988:	e8 3b 16 00 00       	call   801fc8 <read>
	if (r < 0)
  80098d:	83 c4 10             	add    $0x10,%esp
  800990:	85 c0                	test   %eax,%eax
  800992:	78 08                	js     80099c <getchar+0x22>
	if (r < 1)
  800994:	85 c0                	test   %eax,%eax
  800996:	7e 06                	jle    80099e <getchar+0x24>
	return c;
  800998:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80099c:	c9                   	leave  
  80099d:	c3                   	ret    
		return -E_EOF;
  80099e:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8009a3:	eb f7                	jmp    80099c <getchar+0x22>

008009a5 <iscons>:
{
  8009a5:	55                   	push   %ebp
  8009a6:	89 e5                	mov    %esp,%ebp
  8009a8:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8009ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009ae:	50                   	push   %eax
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 a4 13 00 00       	call   801d5b <fd_lookup>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	85 c0                	test   %eax,%eax
  8009bc:	78 11                	js     8009cf <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8009be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009c1:	8b 15 00 40 80 00    	mov    0x804000,%edx
  8009c7:	39 10                	cmp    %edx,(%eax)
  8009c9:	0f 94 c0             	sete   %al
  8009cc:	0f b6 c0             	movzbl %al,%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <opencons>:
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8009d7:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8009da:	50                   	push   %eax
  8009db:	e8 2c 13 00 00       	call   801d0c <fd_alloc>
  8009e0:	83 c4 10             	add    $0x10,%esp
  8009e3:	85 c0                	test   %eax,%eax
  8009e5:	78 3a                	js     800a21 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8009e7:	83 ec 04             	sub    $0x4,%esp
  8009ea:	68 07 04 00 00       	push   $0x407
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	6a 00                	push   $0x0
  8009f4:	e8 59 0c 00 00       	call   801652 <sys_page_alloc>
  8009f9:	83 c4 10             	add    $0x10,%esp
  8009fc:	85 c0                	test   %eax,%eax
  8009fe:	78 21                	js     800a21 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  800a00:	8b 15 00 40 80 00    	mov    0x804000,%edx
  800a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a09:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  800a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a0e:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  800a15:	83 ec 0c             	sub    $0xc,%esp
  800a18:	50                   	push   %eax
  800a19:	e8 c7 12 00 00       	call   801ce5 <fd2num>
  800a1e:	83 c4 10             	add    $0x10,%esp
}
  800a21:	c9                   	leave  
  800a22:	c3                   	ret    

00800a23 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800a23:	55                   	push   %ebp
  800a24:	89 e5                	mov    %esp,%ebp
  800a26:	56                   	push   %esi
  800a27:	53                   	push   %ebx
  800a28:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800a2b:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800a2e:	e8 00 0c 00 00       	call   801633 <sys_getenvid>
  800a33:	25 ff 03 00 00       	and    $0x3ff,%eax
  800a38:	89 c2                	mov    %eax,%edx
  800a3a:	c1 e2 05             	shl    $0x5,%edx
  800a3d:	29 c2                	sub    %eax,%edx
  800a3f:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800a46:	a3 24 54 80 00       	mov    %eax,0x805424

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800a4b:	85 db                	test   %ebx,%ebx
  800a4d:	7e 07                	jle    800a56 <libmain+0x33>
		binaryname = argv[0];
  800a4f:	8b 06                	mov    (%esi),%eax
  800a51:	a3 1c 40 80 00       	mov    %eax,0x80401c

	// call user main routine
	umain(argc, argv);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	56                   	push   %esi
  800a5a:	53                   	push   %ebx
  800a5b:	e8 32 fc ff ff       	call   800692 <umain>

	// exit gracefully
	exit();
  800a60:	e8 0a 00 00 00       	call   800a6f <exit>
}
  800a65:	83 c4 10             	add    $0x10,%esp
  800a68:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800a6b:	5b                   	pop    %ebx
  800a6c:	5e                   	pop    %esi
  800a6d:	5d                   	pop    %ebp
  800a6e:	c3                   	ret    

00800a6f <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800a6f:	55                   	push   %ebp
  800a70:	89 e5                	mov    %esp,%ebp
  800a72:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800a75:	e8 3f 14 00 00       	call   801eb9 <close_all>
	sys_env_destroy(0);
  800a7a:	83 ec 0c             	sub    $0xc,%esp
  800a7d:	6a 00                	push   $0x0
  800a7f:	e8 6e 0b 00 00       	call   8015f2 <sys_env_destroy>
}
  800a84:	83 c4 10             	add    $0x10,%esp
  800a87:	c9                   	leave  
  800a88:	c3                   	ret    

00800a89 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  800a89:	55                   	push   %ebp
  800a8a:	89 e5                	mov    %esp,%ebp
  800a8c:	57                   	push   %edi
  800a8d:	56                   	push   %esi
  800a8e:	53                   	push   %ebx
  800a8f:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  800a95:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  800a98:	8b 1d 1c 40 80 00    	mov    0x80401c,%ebx
  800a9e:	e8 90 0b 00 00       	call   801633 <sys_getenvid>
  800aa3:	83 ec 04             	sub    $0x4,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	ff 75 08             	pushl  0x8(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	50                   	push   %eax
  800aae:	68 ec 35 80 00       	push   $0x8035ec
  800ab3:	68 00 01 00 00       	push   $0x100
  800ab8:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800abe:	56                   	push   %esi
  800abf:	e8 93 06 00 00       	call   801157 <snprintf>
  800ac4:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  800ac6:	83 c4 20             	add    $0x20,%esp
  800ac9:	57                   	push   %edi
  800aca:	ff 75 10             	pushl  0x10(%ebp)
  800acd:	bf 00 01 00 00       	mov    $0x100,%edi
  800ad2:	89 f8                	mov    %edi,%eax
  800ad4:	29 d8                	sub    %ebx,%eax
  800ad6:	50                   	push   %eax
  800ad7:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800ada:	50                   	push   %eax
  800adb:	e8 22 06 00 00       	call   801102 <vsnprintf>
  800ae0:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800ae2:	83 c4 0c             	add    $0xc,%esp
  800ae5:	68 00 34 80 00       	push   $0x803400
  800aea:	29 df                	sub    %ebx,%edi
  800aec:	57                   	push   %edi
  800aed:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 61 06 00 00       	call   801157 <snprintf>
	sys_cputs(buf, r);
  800af6:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800af9:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800afb:	53                   	push   %ebx
  800afc:	56                   	push   %esi
  800afd:	e8 b3 0a 00 00       	call   8015b5 <sys_cputs>
  800b02:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  800b05:	cc                   	int3   
  800b06:	eb fd                	jmp    800b05 <_panic+0x7c>

00800b08 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  800b08:	55                   	push   %ebp
  800b09:	89 e5                	mov    %esp,%ebp
  800b0b:	53                   	push   %ebx
  800b0c:	83 ec 04             	sub    $0x4,%esp
  800b0f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800b12:	8b 13                	mov    (%ebx),%edx
  800b14:	8d 42 01             	lea    0x1(%edx),%eax
  800b17:	89 03                	mov    %eax,(%ebx)
  800b19:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800b1c:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800b20:	3d ff 00 00 00       	cmp    $0xff,%eax
  800b25:	74 08                	je     800b2f <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  800b27:	ff 43 04             	incl   0x4(%ebx)
}
  800b2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b2d:	c9                   	leave  
  800b2e:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800b2f:	83 ec 08             	sub    $0x8,%esp
  800b32:	68 ff 00 00 00       	push   $0xff
  800b37:	8d 43 08             	lea    0x8(%ebx),%eax
  800b3a:	50                   	push   %eax
  800b3b:	e8 75 0a 00 00       	call   8015b5 <sys_cputs>
		b->idx = 0;
  800b40:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  800b46:	83 c4 10             	add    $0x10,%esp
  800b49:	eb dc                	jmp    800b27 <putch+0x1f>

00800b4b <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800b4b:	55                   	push   %ebp
  800b4c:	89 e5                	mov    %esp,%ebp
  800b4e:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800b54:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800b5b:	00 00 00 
	b.cnt = 0;
  800b5e:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b65:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  800b68:	ff 75 0c             	pushl  0xc(%ebp)
  800b6b:	ff 75 08             	pushl  0x8(%ebp)
  800b6e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b74:	50                   	push   %eax
  800b75:	68 08 0b 80 00       	push   $0x800b08
  800b7a:	e8 17 01 00 00       	call   800c96 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  800b7f:	83 c4 08             	add    $0x8,%esp
  800b82:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  800b88:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  800b8e:	50                   	push   %eax
  800b8f:	e8 21 0a 00 00       	call   8015b5 <sys_cputs>

	return b.cnt;
}
  800b94:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  800b9a:	c9                   	leave  
  800b9b:	c3                   	ret    

00800b9c <cprintf>:

int
cprintf(const char *fmt, ...)
{
  800b9c:	55                   	push   %ebp
  800b9d:	89 e5                	mov    %esp,%ebp
  800b9f:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800ba2:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  800ba5:	50                   	push   %eax
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 9d ff ff ff       	call   800b4b <vcprintf>
	va_end(ap);

	return cnt;
}
  800bae:	c9                   	leave  
  800baf:	c3                   	ret    

00800bb0 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bb0:	55                   	push   %ebp
  800bb1:	89 e5                	mov    %esp,%ebp
  800bb3:	57                   	push   %edi
  800bb4:	56                   	push   %esi
  800bb5:	53                   	push   %ebx
  800bb6:	83 ec 1c             	sub    $0x1c,%esp
  800bb9:	89 c7                	mov    %eax,%edi
  800bbb:	89 d6                	mov    %edx,%esi
  800bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bc3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800bc6:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800bcc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800bd1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800bd4:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800bd7:	39 d3                	cmp    %edx,%ebx
  800bd9:	72 05                	jb     800be0 <printnum+0x30>
  800bdb:	39 45 10             	cmp    %eax,0x10(%ebp)
  800bde:	77 78                	ja     800c58 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800be0:	83 ec 0c             	sub    $0xc,%esp
  800be3:	ff 75 18             	pushl  0x18(%ebp)
  800be6:	8b 45 14             	mov    0x14(%ebp),%eax
  800be9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bec:	53                   	push   %ebx
  800bed:	ff 75 10             	pushl  0x10(%ebp)
  800bf0:	83 ec 08             	sub    $0x8,%esp
  800bf3:	ff 75 e4             	pushl  -0x1c(%ebp)
  800bf6:	ff 75 e0             	pushl  -0x20(%ebp)
  800bf9:	ff 75 dc             	pushl  -0x24(%ebp)
  800bfc:	ff 75 d8             	pushl  -0x28(%ebp)
  800bff:	e8 88 25 00 00       	call   80318c <__udivdi3>
  800c04:	83 c4 18             	add    $0x18,%esp
  800c07:	52                   	push   %edx
  800c08:	50                   	push   %eax
  800c09:	89 f2                	mov    %esi,%edx
  800c0b:	89 f8                	mov    %edi,%eax
  800c0d:	e8 9e ff ff ff       	call   800bb0 <printnum>
  800c12:	83 c4 20             	add    $0x20,%esp
  800c15:	eb 11                	jmp    800c28 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c17:	83 ec 08             	sub    $0x8,%esp
  800c1a:	56                   	push   %esi
  800c1b:	ff 75 18             	pushl  0x18(%ebp)
  800c1e:	ff d7                	call   *%edi
  800c20:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800c23:	4b                   	dec    %ebx
  800c24:	85 db                	test   %ebx,%ebx
  800c26:	7f ef                	jg     800c17 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c28:	83 ec 08             	sub    $0x8,%esp
  800c2b:	56                   	push   %esi
  800c2c:	83 ec 04             	sub    $0x4,%esp
  800c2f:	ff 75 e4             	pushl  -0x1c(%ebp)
  800c32:	ff 75 e0             	pushl  -0x20(%ebp)
  800c35:	ff 75 dc             	pushl  -0x24(%ebp)
  800c38:	ff 75 d8             	pushl  -0x28(%ebp)
  800c3b:	e8 5c 26 00 00       	call   80329c <__umoddi3>
  800c40:	83 c4 14             	add    $0x14,%esp
  800c43:	0f be 80 0f 36 80 00 	movsbl 0x80360f(%eax),%eax
  800c4a:	50                   	push   %eax
  800c4b:	ff d7                	call   *%edi
}
  800c4d:	83 c4 10             	add    $0x10,%esp
  800c50:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800c53:	5b                   	pop    %ebx
  800c54:	5e                   	pop    %esi
  800c55:	5f                   	pop    %edi
  800c56:	5d                   	pop    %ebp
  800c57:	c3                   	ret    
  800c58:	8b 5d 14             	mov    0x14(%ebp),%ebx
  800c5b:	eb c6                	jmp    800c23 <printnum+0x73>

00800c5d <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c5d:	55                   	push   %ebp
  800c5e:	89 e5                	mov    %esp,%ebp
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  800c63:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  800c66:	8b 10                	mov    (%eax),%edx
  800c68:	3b 50 04             	cmp    0x4(%eax),%edx
  800c6b:	73 0a                	jae    800c77 <sprintputch+0x1a>
		*b->buf++ = ch;
  800c6d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c70:	89 08                	mov    %ecx,(%eax)
  800c72:	8b 45 08             	mov    0x8(%ebp),%eax
  800c75:	88 02                	mov    %al,(%edx)
}
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <printfmt>:
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  800c7f:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  800c82:	50                   	push   %eax
  800c83:	ff 75 10             	pushl  0x10(%ebp)
  800c86:	ff 75 0c             	pushl  0xc(%ebp)
  800c89:	ff 75 08             	pushl  0x8(%ebp)
  800c8c:	e8 05 00 00 00       	call   800c96 <vprintfmt>
}
  800c91:	83 c4 10             	add    $0x10,%esp
  800c94:	c9                   	leave  
  800c95:	c3                   	ret    

00800c96 <vprintfmt>:
{
  800c96:	55                   	push   %ebp
  800c97:	89 e5                	mov    %esp,%ebp
  800c99:	57                   	push   %edi
  800c9a:	56                   	push   %esi
  800c9b:	53                   	push   %ebx
  800c9c:	83 ec 2c             	sub    $0x2c,%esp
  800c9f:	8b 75 08             	mov    0x8(%ebp),%esi
  800ca2:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  800ca5:	8b 7d 10             	mov    0x10(%ebp),%edi
  800ca8:	e9 ae 03 00 00       	jmp    80105b <vprintfmt+0x3c5>
  800cad:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  800cb1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  800cb8:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800cbf:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  800cc6:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800ccb:	8d 47 01             	lea    0x1(%edi),%eax
  800cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd1:	8a 17                	mov    (%edi),%dl
  800cd3:	8d 42 dd             	lea    -0x23(%edx),%eax
  800cd6:	3c 55                	cmp    $0x55,%al
  800cd8:	0f 87 fe 03 00 00    	ja     8010dc <vprintfmt+0x446>
  800cde:	0f b6 c0             	movzbl %al,%eax
  800ce1:	ff 24 85 60 37 80 00 	jmp    *0x803760(,%eax,4)
  800ce8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800ceb:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800cef:	eb da                	jmp    800ccb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cf1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800cf4:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  800cf8:	eb d1                	jmp    800ccb <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800cfa:	0f b6 d2             	movzbl %dl,%edx
  800cfd:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d00:	b8 00 00 00 00       	mov    $0x0,%eax
  800d05:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  800d08:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800d0b:	01 c0                	add    %eax,%eax
  800d0d:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800d11:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800d14:	8d 4a d0             	lea    -0x30(%edx),%ecx
  800d17:	83 f9 09             	cmp    $0x9,%ecx
  800d1a:	77 52                	ja     800d6e <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800d1c:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800d1d:	eb e9                	jmp    800d08 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800d1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d22:	8b 00                	mov    (%eax),%eax
  800d24:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d27:	8b 45 14             	mov    0x14(%ebp),%eax
  800d2a:	8d 40 04             	lea    0x4(%eax),%eax
  800d2d:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800d30:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800d33:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d37:	79 92                	jns    800ccb <vprintfmt+0x35>
				width = precision, precision = -1;
  800d39:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800d3f:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800d46:	eb 83                	jmp    800ccb <vprintfmt+0x35>
  800d48:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d4c:	78 08                	js     800d56 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800d4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800d51:	e9 75 ff ff ff       	jmp    800ccb <vprintfmt+0x35>
  800d56:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800d5d:	eb ef                	jmp    800d4e <vprintfmt+0xb8>
  800d5f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  800d62:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  800d69:	e9 5d ff ff ff       	jmp    800ccb <vprintfmt+0x35>
  800d6e:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  800d71:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d74:	eb bd                	jmp    800d33 <vprintfmt+0x9d>
			lflag++;
  800d76:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  800d77:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  800d7a:	e9 4c ff ff ff       	jmp    800ccb <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  800d7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800d82:	8d 78 04             	lea    0x4(%eax),%edi
  800d85:	83 ec 08             	sub    $0x8,%esp
  800d88:	53                   	push   %ebx
  800d89:	ff 30                	pushl  (%eax)
  800d8b:	ff d6                	call   *%esi
			break;
  800d8d:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  800d90:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  800d93:	e9 c0 02 00 00       	jmp    801058 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  800d98:	8b 45 14             	mov    0x14(%ebp),%eax
  800d9b:	8d 78 04             	lea    0x4(%eax),%edi
  800d9e:	8b 00                	mov    (%eax),%eax
  800da0:	85 c0                	test   %eax,%eax
  800da2:	78 2a                	js     800dce <vprintfmt+0x138>
  800da4:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  800da6:	83 f8 0f             	cmp    $0xf,%eax
  800da9:	7f 27                	jg     800dd2 <vprintfmt+0x13c>
  800dab:	8b 04 85 c0 38 80 00 	mov    0x8038c0(,%eax,4),%eax
  800db2:	85 c0                	test   %eax,%eax
  800db4:	74 1c                	je     800dd2 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  800db6:	50                   	push   %eax
  800db7:	68 2c 35 80 00       	push   $0x80352c
  800dbc:	53                   	push   %ebx
  800dbd:	56                   	push   %esi
  800dbe:	e8 b6 fe ff ff       	call   800c79 <printfmt>
  800dc3:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800dc6:	89 7d 14             	mov    %edi,0x14(%ebp)
  800dc9:	e9 8a 02 00 00       	jmp    801058 <vprintfmt+0x3c2>
  800dce:	f7 d8                	neg    %eax
  800dd0:	eb d2                	jmp    800da4 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800dd2:	52                   	push   %edx
  800dd3:	68 27 36 80 00       	push   $0x803627
  800dd8:	53                   	push   %ebx
  800dd9:	56                   	push   %esi
  800dda:	e8 9a fe ff ff       	call   800c79 <printfmt>
  800ddf:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800de2:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800de5:	e9 6e 02 00 00       	jmp    801058 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800dea:	8b 45 14             	mov    0x14(%ebp),%eax
  800ded:	83 c0 04             	add    $0x4,%eax
  800df0:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800df3:	8b 45 14             	mov    0x14(%ebp),%eax
  800df6:	8b 38                	mov    (%eax),%edi
  800df8:	85 ff                	test   %edi,%edi
  800dfa:	74 39                	je     800e35 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800dfc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e00:	0f 8e a9 00 00 00    	jle    800eaf <vprintfmt+0x219>
  800e06:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800e0a:	0f 84 a7 00 00 00    	je     800eb7 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800e10:	83 ec 08             	sub    $0x8,%esp
  800e13:	ff 75 d0             	pushl  -0x30(%ebp)
  800e16:	57                   	push   %edi
  800e17:	e8 64 04 00 00       	call   801280 <strnlen>
  800e1c:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800e1f:	29 c1                	sub    %eax,%ecx
  800e21:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800e24:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800e27:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800e2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800e2e:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800e31:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e33:	eb 14                	jmp    800e49 <vprintfmt+0x1b3>
				p = "(null)";
  800e35:	bf 20 36 80 00       	mov    $0x803620,%edi
  800e3a:	eb c0                	jmp    800dfc <vprintfmt+0x166>
					putch(padc, putdat);
  800e3c:	83 ec 08             	sub    $0x8,%esp
  800e3f:	53                   	push   %ebx
  800e40:	ff 75 e0             	pushl  -0x20(%ebp)
  800e43:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800e45:	4f                   	dec    %edi
  800e46:	83 c4 10             	add    $0x10,%esp
  800e49:	85 ff                	test   %edi,%edi
  800e4b:	7f ef                	jg     800e3c <vprintfmt+0x1a6>
  800e4d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800e50:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800e53:	89 c8                	mov    %ecx,%eax
  800e55:	85 c9                	test   %ecx,%ecx
  800e57:	78 10                	js     800e69 <vprintfmt+0x1d3>
  800e59:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800e5c:	29 c1                	sub    %eax,%ecx
  800e5e:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800e61:	89 75 08             	mov    %esi,0x8(%ebp)
  800e64:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800e67:	eb 15                	jmp    800e7e <vprintfmt+0x1e8>
  800e69:	b8 00 00 00 00       	mov    $0x0,%eax
  800e6e:	eb e9                	jmp    800e59 <vprintfmt+0x1c3>
					putch(ch, putdat);
  800e70:	83 ec 08             	sub    $0x8,%esp
  800e73:	53                   	push   %ebx
  800e74:	52                   	push   %edx
  800e75:	ff 55 08             	call   *0x8(%ebp)
  800e78:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e7b:	ff 4d e0             	decl   -0x20(%ebp)
  800e7e:	47                   	inc    %edi
  800e7f:	8a 47 ff             	mov    -0x1(%edi),%al
  800e82:	0f be d0             	movsbl %al,%edx
  800e85:	85 d2                	test   %edx,%edx
  800e87:	74 59                	je     800ee2 <vprintfmt+0x24c>
  800e89:	85 f6                	test   %esi,%esi
  800e8b:	78 03                	js     800e90 <vprintfmt+0x1fa>
  800e8d:	4e                   	dec    %esi
  800e8e:	78 2f                	js     800ebf <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800e90:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800e94:	74 da                	je     800e70 <vprintfmt+0x1da>
  800e96:	0f be c0             	movsbl %al,%eax
  800e99:	83 e8 20             	sub    $0x20,%eax
  800e9c:	83 f8 5e             	cmp    $0x5e,%eax
  800e9f:	76 cf                	jbe    800e70 <vprintfmt+0x1da>
					putch('?', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	53                   	push   %ebx
  800ea5:	6a 3f                	push   $0x3f
  800ea7:	ff 55 08             	call   *0x8(%ebp)
  800eaa:	83 c4 10             	add    $0x10,%esp
  800ead:	eb cc                	jmp    800e7b <vprintfmt+0x1e5>
  800eaf:	89 75 08             	mov    %esi,0x8(%ebp)
  800eb2:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800eb5:	eb c7                	jmp    800e7e <vprintfmt+0x1e8>
  800eb7:	89 75 08             	mov    %esi,0x8(%ebp)
  800eba:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800ebd:	eb bf                	jmp    800e7e <vprintfmt+0x1e8>
  800ebf:	8b 75 08             	mov    0x8(%ebp),%esi
  800ec2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ec5:	eb 0c                	jmp    800ed3 <vprintfmt+0x23d>
				putch(' ', putdat);
  800ec7:	83 ec 08             	sub    $0x8,%esp
  800eca:	53                   	push   %ebx
  800ecb:	6a 20                	push   $0x20
  800ecd:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800ecf:	4f                   	dec    %edi
  800ed0:	83 c4 10             	add    $0x10,%esp
  800ed3:	85 ff                	test   %edi,%edi
  800ed5:	7f f0                	jg     800ec7 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800ed7:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	e9 76 01 00 00       	jmp    801058 <vprintfmt+0x3c2>
  800ee2:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800ee5:	8b 75 08             	mov    0x8(%ebp),%esi
  800ee8:	eb e9                	jmp    800ed3 <vprintfmt+0x23d>
	if (lflag >= 2)
  800eea:	83 f9 01             	cmp    $0x1,%ecx
  800eed:	7f 1f                	jg     800f0e <vprintfmt+0x278>
	else if (lflag)
  800eef:	85 c9                	test   %ecx,%ecx
  800ef1:	75 48                	jne    800f3b <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800ef3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef6:	8b 00                	mov    (%eax),%eax
  800ef8:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800efb:	89 c1                	mov    %eax,%ecx
  800efd:	c1 f9 1f             	sar    $0x1f,%ecx
  800f00:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f03:	8b 45 14             	mov    0x14(%ebp),%eax
  800f06:	8d 40 04             	lea    0x4(%eax),%eax
  800f09:	89 45 14             	mov    %eax,0x14(%ebp)
  800f0c:	eb 17                	jmp    800f25 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800f0e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f11:	8b 50 04             	mov    0x4(%eax),%edx
  800f14:	8b 00                	mov    (%eax),%eax
  800f16:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f19:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800f1c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f1f:	8d 40 08             	lea    0x8(%eax),%eax
  800f22:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800f25:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f28:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800f2b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f2f:	78 25                	js     800f56 <vprintfmt+0x2c0>
			base = 10;
  800f31:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f36:	e9 03 01 00 00       	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800f3b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f3e:	8b 00                	mov    (%eax),%eax
  800f40:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800f43:	89 c1                	mov    %eax,%ecx
  800f45:	c1 f9 1f             	sar    $0x1f,%ecx
  800f48:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800f4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4e:	8d 40 04             	lea    0x4(%eax),%eax
  800f51:	89 45 14             	mov    %eax,0x14(%ebp)
  800f54:	eb cf                	jmp    800f25 <vprintfmt+0x28f>
				putch('-', putdat);
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	53                   	push   %ebx
  800f5a:	6a 2d                	push   $0x2d
  800f5c:	ff d6                	call   *%esi
				num = -(long long) num;
  800f5e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800f61:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f64:	f7 da                	neg    %edx
  800f66:	83 d1 00             	adc    $0x0,%ecx
  800f69:	f7 d9                	neg    %ecx
  800f6b:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800f6e:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f73:	e9 c6 00 00 00       	jmp    80103e <vprintfmt+0x3a8>
	if (lflag >= 2)
  800f78:	83 f9 01             	cmp    $0x1,%ecx
  800f7b:	7f 1e                	jg     800f9b <vprintfmt+0x305>
	else if (lflag)
  800f7d:	85 c9                	test   %ecx,%ecx
  800f7f:	75 32                	jne    800fb3 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800f81:	8b 45 14             	mov    0x14(%ebp),%eax
  800f84:	8b 10                	mov    (%eax),%edx
  800f86:	b9 00 00 00 00       	mov    $0x0,%ecx
  800f8b:	8d 40 04             	lea    0x4(%eax),%eax
  800f8e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800f91:	b8 0a 00 00 00       	mov    $0xa,%eax
  800f96:	e9 a3 00 00 00       	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  800f9e:	8b 10                	mov    (%eax),%edx
  800fa0:	8b 48 04             	mov    0x4(%eax),%ecx
  800fa3:	8d 40 08             	lea    0x8(%eax),%eax
  800fa6:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fa9:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fae:	e9 8b 00 00 00       	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800fb3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fb6:	8b 10                	mov    (%eax),%edx
  800fb8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fbd:	8d 40 04             	lea    0x4(%eax),%eax
  800fc0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800fc3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800fc8:	eb 74                	jmp    80103e <vprintfmt+0x3a8>
	if (lflag >= 2)
  800fca:	83 f9 01             	cmp    $0x1,%ecx
  800fcd:	7f 1b                	jg     800fea <vprintfmt+0x354>
	else if (lflag)
  800fcf:	85 c9                	test   %ecx,%ecx
  800fd1:	75 2c                	jne    800fff <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800fd3:	8b 45 14             	mov    0x14(%ebp),%eax
  800fd6:	8b 10                	mov    (%eax),%edx
  800fd8:	b9 00 00 00 00       	mov    $0x0,%ecx
  800fdd:	8d 40 04             	lea    0x4(%eax),%eax
  800fe0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800fe3:	b8 08 00 00 00       	mov    $0x8,%eax
  800fe8:	eb 54                	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800fea:	8b 45 14             	mov    0x14(%ebp),%eax
  800fed:	8b 10                	mov    (%eax),%edx
  800fef:	8b 48 04             	mov    0x4(%eax),%ecx
  800ff2:	8d 40 08             	lea    0x8(%eax),%eax
  800ff5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800ff8:	b8 08 00 00 00       	mov    $0x8,%eax
  800ffd:	eb 3f                	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800fff:	8b 45 14             	mov    0x14(%ebp),%eax
  801002:	8b 10                	mov    (%eax),%edx
  801004:	b9 00 00 00 00       	mov    $0x0,%ecx
  801009:	8d 40 04             	lea    0x4(%eax),%eax
  80100c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80100f:	b8 08 00 00 00       	mov    $0x8,%eax
  801014:	eb 28                	jmp    80103e <vprintfmt+0x3a8>
			putch('0', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	53                   	push   %ebx
  80101a:	6a 30                	push   $0x30
  80101c:	ff d6                	call   *%esi
			putch('x', putdat);
  80101e:	83 c4 08             	add    $0x8,%esp
  801021:	53                   	push   %ebx
  801022:	6a 78                	push   $0x78
  801024:	ff d6                	call   *%esi
			num = (unsigned long long)
  801026:	8b 45 14             	mov    0x14(%ebp),%eax
  801029:	8b 10                	mov    (%eax),%edx
  80102b:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  801030:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  801033:	8d 40 04             	lea    0x4(%eax),%eax
  801036:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801039:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  80103e:	83 ec 0c             	sub    $0xc,%esp
  801041:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  801045:	57                   	push   %edi
  801046:	ff 75 e0             	pushl  -0x20(%ebp)
  801049:	50                   	push   %eax
  80104a:	51                   	push   %ecx
  80104b:	52                   	push   %edx
  80104c:	89 da                	mov    %ebx,%edx
  80104e:	89 f0                	mov    %esi,%eax
  801050:	e8 5b fb ff ff       	call   800bb0 <printnum>
			break;
  801055:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  801058:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80105b:	47                   	inc    %edi
  80105c:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801060:	83 f8 25             	cmp    $0x25,%eax
  801063:	0f 84 44 fc ff ff    	je     800cad <vprintfmt+0x17>
			if (ch == '\0')
  801069:	85 c0                	test   %eax,%eax
  80106b:	0f 84 89 00 00 00    	je     8010fa <vprintfmt+0x464>
			putch(ch, putdat);
  801071:	83 ec 08             	sub    $0x8,%esp
  801074:	53                   	push   %ebx
  801075:	50                   	push   %eax
  801076:	ff d6                	call   *%esi
  801078:	83 c4 10             	add    $0x10,%esp
  80107b:	eb de                	jmp    80105b <vprintfmt+0x3c5>
	if (lflag >= 2)
  80107d:	83 f9 01             	cmp    $0x1,%ecx
  801080:	7f 1b                	jg     80109d <vprintfmt+0x407>
	else if (lflag)
  801082:	85 c9                	test   %ecx,%ecx
  801084:	75 2c                	jne    8010b2 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801086:	8b 45 14             	mov    0x14(%ebp),%eax
  801089:	8b 10                	mov    (%eax),%edx
  80108b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801090:	8d 40 04             	lea    0x4(%eax),%eax
  801093:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801096:	b8 10 00 00 00       	mov    $0x10,%eax
  80109b:	eb a1                	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 10                	mov    (%eax),%edx
  8010a2:	8b 48 04             	mov    0x4(%eax),%ecx
  8010a5:	8d 40 08             	lea    0x8(%eax),%eax
  8010a8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010ab:	b8 10 00 00 00       	mov    $0x10,%eax
  8010b0:	eb 8c                	jmp    80103e <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8010b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b5:	8b 10                	mov    (%eax),%edx
  8010b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8010bc:	8d 40 04             	lea    0x4(%eax),%eax
  8010bf:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8010c2:	b8 10 00 00 00       	mov    $0x10,%eax
  8010c7:	e9 72 ff ff ff       	jmp    80103e <vprintfmt+0x3a8>
			putch(ch, putdat);
  8010cc:	83 ec 08             	sub    $0x8,%esp
  8010cf:	53                   	push   %ebx
  8010d0:	6a 25                	push   $0x25
  8010d2:	ff d6                	call   *%esi
			break;
  8010d4:	83 c4 10             	add    $0x10,%esp
  8010d7:	e9 7c ff ff ff       	jmp    801058 <vprintfmt+0x3c2>
			putch('%', putdat);
  8010dc:	83 ec 08             	sub    $0x8,%esp
  8010df:	53                   	push   %ebx
  8010e0:	6a 25                	push   $0x25
  8010e2:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010e4:	83 c4 10             	add    $0x10,%esp
  8010e7:	89 f8                	mov    %edi,%eax
  8010e9:	eb 01                	jmp    8010ec <vprintfmt+0x456>
  8010eb:	48                   	dec    %eax
  8010ec:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8010f0:	75 f9                	jne    8010eb <vprintfmt+0x455>
  8010f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8010f5:	e9 5e ff ff ff       	jmp    801058 <vprintfmt+0x3c2>
}
  8010fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8010fd:	5b                   	pop    %ebx
  8010fe:	5e                   	pop    %esi
  8010ff:	5f                   	pop    %edi
  801100:	5d                   	pop    %ebp
  801101:	c3                   	ret    

00801102 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 18             	sub    $0x18,%esp
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80110e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801111:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801115:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801118:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80111f:	85 c0                	test   %eax,%eax
  801121:	74 26                	je     801149 <vsnprintf+0x47>
  801123:	85 d2                	test   %edx,%edx
  801125:	7e 29                	jle    801150 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801127:	ff 75 14             	pushl  0x14(%ebp)
  80112a:	ff 75 10             	pushl  0x10(%ebp)
  80112d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801130:	50                   	push   %eax
  801131:	68 5d 0c 80 00       	push   $0x800c5d
  801136:	e8 5b fb ff ff       	call   800c96 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  80113b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80113e:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801144:	83 c4 10             	add    $0x10,%esp
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    
		return -E_INVAL;
  801149:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80114e:	eb f7                	jmp    801147 <vsnprintf+0x45>
  801150:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801155:	eb f0                	jmp    801147 <vsnprintf+0x45>

00801157 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801157:	55                   	push   %ebp
  801158:	89 e5                	mov    %esp,%ebp
  80115a:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80115d:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801160:	50                   	push   %eax
  801161:	ff 75 10             	pushl  0x10(%ebp)
  801164:	ff 75 0c             	pushl  0xc(%ebp)
  801167:	ff 75 08             	pushl  0x8(%ebp)
  80116a:	e8 93 ff ff ff       	call   801102 <vsnprintf>
	va_end(ap);

	return rc;
}
  80116f:	c9                   	leave  
  801170:	c3                   	ret    

00801171 <readline>:
#define BUFLEN 1024
static char buf[BUFLEN];

char *
readline(const char *prompt)
{
  801171:	55                   	push   %ebp
  801172:	89 e5                	mov    %esp,%ebp
  801174:	57                   	push   %edi
  801175:	56                   	push   %esi
  801176:	53                   	push   %ebx
  801177:	83 ec 0c             	sub    $0xc,%esp
  80117a:	8b 45 08             	mov    0x8(%ebp),%eax

#if JOS_KERNEL
	if (prompt != NULL)
		cprintf("%s", prompt);
#else
	if (prompt != NULL)
  80117d:	85 c0                	test   %eax,%eax
  80117f:	74 13                	je     801194 <readline+0x23>
		fprintf(1, "%s", prompt);
  801181:	83 ec 04             	sub    $0x4,%esp
  801184:	50                   	push   %eax
  801185:	68 2c 35 80 00       	push   $0x80352c
  80118a:	6a 01                	push   $0x1
  80118c:	e8 74 14 00 00       	call   802605 <fprintf>
  801191:	83 c4 10             	add    $0x10,%esp
#endif

	i = 0;
	echoing = iscons(0);
  801194:	83 ec 0c             	sub    $0xc,%esp
  801197:	6a 00                	push   $0x0
  801199:	e8 07 f8 ff ff       	call   8009a5 <iscons>
  80119e:	89 c7                	mov    %eax,%edi
  8011a0:	83 c4 10             	add    $0x10,%esp
	i = 0;
  8011a3:	be 00 00 00 00       	mov    $0x0,%esi
  8011a8:	eb 7b                	jmp    801225 <readline+0xb4>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
  8011aa:	83 f8 f8             	cmp    $0xfffffff8,%eax
  8011ad:	74 66                	je     801215 <readline+0xa4>
				cprintf("read error: %e\n", c);
  8011af:	83 ec 08             	sub    $0x8,%esp
  8011b2:	50                   	push   %eax
  8011b3:	68 1f 39 80 00       	push   $0x80391f
  8011b8:	e8 df f9 ff ff       	call   800b9c <cprintf>
  8011bd:	83 c4 10             	add    $0x10,%esp
			return NULL;
  8011c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8011c5:	eb 37                	jmp    8011fe <readline+0x8d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
			if (echoing)
				cputchar('\b');
  8011c7:	83 ec 0c             	sub    $0xc,%esp
  8011ca:	6a 08                	push   $0x8
  8011cc:	e8 8d f7 ff ff       	call   80095e <cputchar>
  8011d1:	83 c4 10             	add    $0x10,%esp
  8011d4:	eb 4e                	jmp    801224 <readline+0xb3>
			i--;
		} else if (c >= ' ' && i < BUFLEN-1) {
			if (echoing)
				cputchar(c);
  8011d6:	83 ec 0c             	sub    $0xc,%esp
  8011d9:	53                   	push   %ebx
  8011da:	e8 7f f7 ff ff       	call   80095e <cputchar>
  8011df:	83 c4 10             	add    $0x10,%esp
  8011e2:	eb 6b                	jmp    80124f <readline+0xde>
			buf[i++] = c;
		} else if (c == '\n' || c == '\r') {
  8011e4:	83 fb 0a             	cmp    $0xa,%ebx
  8011e7:	74 05                	je     8011ee <readline+0x7d>
  8011e9:	83 fb 0d             	cmp    $0xd,%ebx
  8011ec:	75 37                	jne    801225 <readline+0xb4>
			if (echoing)
  8011ee:	85 ff                	test   %edi,%edi
  8011f0:	75 14                	jne    801206 <readline+0x95>
				cputchar('\n');
			buf[i] = 0;
  8011f2:	c6 86 20 50 80 00 00 	movb   $0x0,0x805020(%esi)
			return buf;
  8011f9:	b8 20 50 80 00       	mov    $0x805020,%eax
		}
	}
}
  8011fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801201:	5b                   	pop    %ebx
  801202:	5e                   	pop    %esi
  801203:	5f                   	pop    %edi
  801204:	5d                   	pop    %ebp
  801205:	c3                   	ret    
				cputchar('\n');
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	6a 0a                	push   $0xa
  80120b:	e8 4e f7 ff ff       	call   80095e <cputchar>
  801210:	83 c4 10             	add    $0x10,%esp
  801213:	eb dd                	jmp    8011f2 <readline+0x81>
			return NULL;
  801215:	b8 00 00 00 00       	mov    $0x0,%eax
  80121a:	eb e2                	jmp    8011fe <readline+0x8d>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80121c:	85 f6                	test   %esi,%esi
  80121e:	7e 40                	jle    801260 <readline+0xef>
			if (echoing)
  801220:	85 ff                	test   %edi,%edi
  801222:	75 a3                	jne    8011c7 <readline+0x56>
			i--;
  801224:	4e                   	dec    %esi
		c = getchar();
  801225:	e8 50 f7 ff ff       	call   80097a <getchar>
  80122a:	89 c3                	mov    %eax,%ebx
		if (c < 0) {
  80122c:	85 c0                	test   %eax,%eax
  80122e:	0f 88 76 ff ff ff    	js     8011aa <readline+0x39>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  801234:	83 f8 08             	cmp    $0x8,%eax
  801237:	74 21                	je     80125a <readline+0xe9>
  801239:	83 f8 7f             	cmp    $0x7f,%eax
  80123c:	74 de                	je     80121c <readline+0xab>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80123e:	83 f8 1f             	cmp    $0x1f,%eax
  801241:	7e a1                	jle    8011e4 <readline+0x73>
  801243:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801249:	7f 99                	jg     8011e4 <readline+0x73>
			if (echoing)
  80124b:	85 ff                	test   %edi,%edi
  80124d:	75 87                	jne    8011d6 <readline+0x65>
			buf[i++] = c;
  80124f:	88 9e 20 50 80 00    	mov    %bl,0x805020(%esi)
  801255:	8d 76 01             	lea    0x1(%esi),%esi
  801258:	eb cb                	jmp    801225 <readline+0xb4>
		} else if ((c == '\b' || c == '\x7f') && i > 0) {
  80125a:	85 f6                	test   %esi,%esi
  80125c:	7f c2                	jg     801220 <readline+0xaf>
  80125e:	eb c5                	jmp    801225 <readline+0xb4>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801260:	81 fe fe 03 00 00    	cmp    $0x3fe,%esi
  801266:	7e e3                	jle    80124b <readline+0xda>
  801268:	eb bb                	jmp    801225 <readline+0xb4>

0080126a <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  80126a:	55                   	push   %ebp
  80126b:	89 e5                	mov    %esp,%ebp
  80126d:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801270:	b8 00 00 00 00       	mov    $0x0,%eax
  801275:	eb 01                	jmp    801278 <strlen+0xe>
		n++;
  801277:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801278:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80127c:	75 f9                	jne    801277 <strlen+0xd>
	return n;
}
  80127e:	5d                   	pop    %ebp
  80127f:	c3                   	ret    

00801280 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801280:	55                   	push   %ebp
  801281:	89 e5                	mov    %esp,%ebp
  801283:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801286:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801289:	b8 00 00 00 00       	mov    $0x0,%eax
  80128e:	eb 01                	jmp    801291 <strnlen+0x11>
		n++;
  801290:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801291:	39 d0                	cmp    %edx,%eax
  801293:	74 06                	je     80129b <strnlen+0x1b>
  801295:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801299:	75 f5                	jne    801290 <strnlen+0x10>
	return n;
}
  80129b:	5d                   	pop    %ebp
  80129c:	c3                   	ret    

0080129d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80129d:	55                   	push   %ebp
  80129e:	89 e5                	mov    %esp,%ebp
  8012a0:	53                   	push   %ebx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  8012a7:	89 c2                	mov    %eax,%edx
  8012a9:	42                   	inc    %edx
  8012aa:	41                   	inc    %ecx
  8012ab:	8a 59 ff             	mov    -0x1(%ecx),%bl
  8012ae:	88 5a ff             	mov    %bl,-0x1(%edx)
  8012b1:	84 db                	test   %bl,%bl
  8012b3:	75 f4                	jne    8012a9 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  8012b5:	5b                   	pop    %ebx
  8012b6:	5d                   	pop    %ebp
  8012b7:	c3                   	ret    

008012b8 <strcat>:

char *
strcat(char *dst, const char *src)
{
  8012b8:	55                   	push   %ebp
  8012b9:	89 e5                	mov    %esp,%ebp
  8012bb:	53                   	push   %ebx
  8012bc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  8012bf:	53                   	push   %ebx
  8012c0:	e8 a5 ff ff ff       	call   80126a <strlen>
  8012c5:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	01 d8                	add    %ebx,%eax
  8012cd:	50                   	push   %eax
  8012ce:	e8 ca ff ff ff       	call   80129d <strcpy>
	return dst;
}
  8012d3:	89 d8                	mov    %ebx,%eax
  8012d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012d8:	c9                   	leave  
  8012d9:	c3                   	ret    

008012da <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8012da:	55                   	push   %ebp
  8012db:	89 e5                	mov    %esp,%ebp
  8012dd:	56                   	push   %esi
  8012de:	53                   	push   %ebx
  8012df:	8b 75 08             	mov    0x8(%ebp),%esi
  8012e2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8012e5:	89 f3                	mov    %esi,%ebx
  8012e7:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8012ea:	89 f2                	mov    %esi,%edx
  8012ec:	eb 0c                	jmp    8012fa <strncpy+0x20>
		*dst++ = *src;
  8012ee:	42                   	inc    %edx
  8012ef:	8a 01                	mov    (%ecx),%al
  8012f1:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8012f4:	80 39 01             	cmpb   $0x1,(%ecx)
  8012f7:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8012fa:	39 da                	cmp    %ebx,%edx
  8012fc:	75 f0                	jne    8012ee <strncpy+0x14>
	}
	return ret;
}
  8012fe:	89 f0                	mov    %esi,%eax
  801300:	5b                   	pop    %ebx
  801301:	5e                   	pop    %esi
  801302:	5d                   	pop    %ebp
  801303:	c3                   	ret    

00801304 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801304:	55                   	push   %ebp
  801305:	89 e5                	mov    %esp,%ebp
  801307:	56                   	push   %esi
  801308:	53                   	push   %ebx
  801309:	8b 75 08             	mov    0x8(%ebp),%esi
  80130c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80130f:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801312:	85 c0                	test   %eax,%eax
  801314:	74 20                	je     801336 <strlcpy+0x32>
  801316:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  80131a:	89 f0                	mov    %esi,%eax
  80131c:	eb 05                	jmp    801323 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  80131e:	40                   	inc    %eax
  80131f:	42                   	inc    %edx
  801320:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  801323:	39 d8                	cmp    %ebx,%eax
  801325:	74 06                	je     80132d <strlcpy+0x29>
  801327:	8a 0a                	mov    (%edx),%cl
  801329:	84 c9                	test   %cl,%cl
  80132b:	75 f1                	jne    80131e <strlcpy+0x1a>
		*dst = '\0';
  80132d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801330:	29 f0                	sub    %esi,%eax
}
  801332:	5b                   	pop    %ebx
  801333:	5e                   	pop    %esi
  801334:	5d                   	pop    %ebp
  801335:	c3                   	ret    
  801336:	89 f0                	mov    %esi,%eax
  801338:	eb f6                	jmp    801330 <strlcpy+0x2c>

0080133a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80133a:	55                   	push   %ebp
  80133b:	89 e5                	mov    %esp,%ebp
  80133d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801340:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801343:	eb 02                	jmp    801347 <strcmp+0xd>
		p++, q++;
  801345:	41                   	inc    %ecx
  801346:	42                   	inc    %edx
	while (*p && *p == *q)
  801347:	8a 01                	mov    (%ecx),%al
  801349:	84 c0                	test   %al,%al
  80134b:	74 04                	je     801351 <strcmp+0x17>
  80134d:	3a 02                	cmp    (%edx),%al
  80134f:	74 f4                	je     801345 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801351:	0f b6 c0             	movzbl %al,%eax
  801354:	0f b6 12             	movzbl (%edx),%edx
  801357:	29 d0                	sub    %edx,%eax
}
  801359:	5d                   	pop    %ebp
  80135a:	c3                   	ret    

0080135b <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  80135b:	55                   	push   %ebp
  80135c:	89 e5                	mov    %esp,%ebp
  80135e:	53                   	push   %ebx
  80135f:	8b 45 08             	mov    0x8(%ebp),%eax
  801362:	8b 55 0c             	mov    0xc(%ebp),%edx
  801365:	89 c3                	mov    %eax,%ebx
  801367:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  80136a:	eb 02                	jmp    80136e <strncmp+0x13>
		n--, p++, q++;
  80136c:	40                   	inc    %eax
  80136d:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  80136e:	39 d8                	cmp    %ebx,%eax
  801370:	74 15                	je     801387 <strncmp+0x2c>
  801372:	8a 08                	mov    (%eax),%cl
  801374:	84 c9                	test   %cl,%cl
  801376:	74 04                	je     80137c <strncmp+0x21>
  801378:	3a 0a                	cmp    (%edx),%cl
  80137a:	74 f0                	je     80136c <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80137c:	0f b6 00             	movzbl (%eax),%eax
  80137f:	0f b6 12             	movzbl (%edx),%edx
  801382:	29 d0                	sub    %edx,%eax
}
  801384:	5b                   	pop    %ebx
  801385:	5d                   	pop    %ebp
  801386:	c3                   	ret    
		return 0;
  801387:	b8 00 00 00 00       	mov    $0x0,%eax
  80138c:	eb f6                	jmp    801384 <strncmp+0x29>

0080138e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80138e:	55                   	push   %ebp
  80138f:	89 e5                	mov    %esp,%ebp
  801391:	8b 45 08             	mov    0x8(%ebp),%eax
  801394:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801397:	8a 10                	mov    (%eax),%dl
  801399:	84 d2                	test   %dl,%dl
  80139b:	74 07                	je     8013a4 <strchr+0x16>
		if (*s == c)
  80139d:	38 ca                	cmp    %cl,%dl
  80139f:	74 08                	je     8013a9 <strchr+0x1b>
	for (; *s; s++)
  8013a1:	40                   	inc    %eax
  8013a2:	eb f3                	jmp    801397 <strchr+0x9>
			return (char *) s;
	return 0;
  8013a4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013a9:	5d                   	pop    %ebp
  8013aa:	c3                   	ret    

008013ab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8013ab:	55                   	push   %ebp
  8013ac:	89 e5                	mov    %esp,%ebp
  8013ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b1:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  8013b4:	8a 10                	mov    (%eax),%dl
  8013b6:	84 d2                	test   %dl,%dl
  8013b8:	74 07                	je     8013c1 <strfind+0x16>
		if (*s == c)
  8013ba:	38 ca                	cmp    %cl,%dl
  8013bc:	74 03                	je     8013c1 <strfind+0x16>
	for (; *s; s++)
  8013be:	40                   	inc    %eax
  8013bf:	eb f3                	jmp    8013b4 <strfind+0x9>
			break;
	return (char *) s;
}
  8013c1:	5d                   	pop    %ebp
  8013c2:	c3                   	ret    

008013c3 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  8013c3:	55                   	push   %ebp
  8013c4:	89 e5                	mov    %esp,%ebp
  8013c6:	57                   	push   %edi
  8013c7:	56                   	push   %esi
  8013c8:	53                   	push   %ebx
  8013c9:	8b 7d 08             	mov    0x8(%ebp),%edi
  8013cc:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  8013cf:	85 c9                	test   %ecx,%ecx
  8013d1:	74 13                	je     8013e6 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  8013d3:	f7 c7 03 00 00 00    	test   $0x3,%edi
  8013d9:	75 05                	jne    8013e0 <memset+0x1d>
  8013db:	f6 c1 03             	test   $0x3,%cl
  8013de:	74 0d                	je     8013ed <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  8013e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e3:	fc                   	cld    
  8013e4:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8013e6:	89 f8                	mov    %edi,%eax
  8013e8:	5b                   	pop    %ebx
  8013e9:	5e                   	pop    %esi
  8013ea:	5f                   	pop    %edi
  8013eb:	5d                   	pop    %ebp
  8013ec:	c3                   	ret    
		c &= 0xFF;
  8013ed:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8013f1:	89 d3                	mov    %edx,%ebx
  8013f3:	c1 e3 08             	shl    $0x8,%ebx
  8013f6:	89 d0                	mov    %edx,%eax
  8013f8:	c1 e0 18             	shl    $0x18,%eax
  8013fb:	89 d6                	mov    %edx,%esi
  8013fd:	c1 e6 10             	shl    $0x10,%esi
  801400:	09 f0                	or     %esi,%eax
  801402:	09 c2                	or     %eax,%edx
  801404:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801406:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801409:	89 d0                	mov    %edx,%eax
  80140b:	fc                   	cld    
  80140c:	f3 ab                	rep stos %eax,%es:(%edi)
  80140e:	eb d6                	jmp    8013e6 <memset+0x23>

00801410 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801410:	55                   	push   %ebp
  801411:	89 e5                	mov    %esp,%ebp
  801413:	57                   	push   %edi
  801414:	56                   	push   %esi
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	8b 75 0c             	mov    0xc(%ebp),%esi
  80141b:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80141e:	39 c6                	cmp    %eax,%esi
  801420:	73 33                	jae    801455 <memmove+0x45>
  801422:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801425:	39 d0                	cmp    %edx,%eax
  801427:	73 2c                	jae    801455 <memmove+0x45>
		s += n;
		d += n;
  801429:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  80142c:	89 d6                	mov    %edx,%esi
  80142e:	09 fe                	or     %edi,%esi
  801430:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801436:	75 13                	jne    80144b <memmove+0x3b>
  801438:	f6 c1 03             	test   $0x3,%cl
  80143b:	75 0e                	jne    80144b <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  80143d:	83 ef 04             	sub    $0x4,%edi
  801440:	8d 72 fc             	lea    -0x4(%edx),%esi
  801443:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801446:	fd                   	std    
  801447:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801449:	eb 07                	jmp    801452 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  80144b:	4f                   	dec    %edi
  80144c:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  80144f:	fd                   	std    
  801450:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801452:	fc                   	cld    
  801453:	eb 13                	jmp    801468 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801455:	89 f2                	mov    %esi,%edx
  801457:	09 c2                	or     %eax,%edx
  801459:	f6 c2 03             	test   $0x3,%dl
  80145c:	75 05                	jne    801463 <memmove+0x53>
  80145e:	f6 c1 03             	test   $0x3,%cl
  801461:	74 09                	je     80146c <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801463:	89 c7                	mov    %eax,%edi
  801465:	fc                   	cld    
  801466:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801468:	5e                   	pop    %esi
  801469:	5f                   	pop    %edi
  80146a:	5d                   	pop    %ebp
  80146b:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  80146c:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  80146f:	89 c7                	mov    %eax,%edi
  801471:	fc                   	cld    
  801472:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801474:	eb f2                	jmp    801468 <memmove+0x58>

00801476 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801476:	55                   	push   %ebp
  801477:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801479:	ff 75 10             	pushl  0x10(%ebp)
  80147c:	ff 75 0c             	pushl  0xc(%ebp)
  80147f:	ff 75 08             	pushl  0x8(%ebp)
  801482:	e8 89 ff ff ff       	call   801410 <memmove>
}
  801487:	c9                   	leave  
  801488:	c3                   	ret    

00801489 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801489:	55                   	push   %ebp
  80148a:	89 e5                	mov    %esp,%ebp
  80148c:	56                   	push   %esi
  80148d:	53                   	push   %ebx
  80148e:	8b 45 08             	mov    0x8(%ebp),%eax
  801491:	89 c6                	mov    %eax,%esi
  801493:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801496:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801499:	39 f0                	cmp    %esi,%eax
  80149b:	74 16                	je     8014b3 <memcmp+0x2a>
		if (*s1 != *s2)
  80149d:	8a 08                	mov    (%eax),%cl
  80149f:	8a 1a                	mov    (%edx),%bl
  8014a1:	38 d9                	cmp    %bl,%cl
  8014a3:	75 04                	jne    8014a9 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  8014a5:	40                   	inc    %eax
  8014a6:	42                   	inc    %edx
  8014a7:	eb f0                	jmp    801499 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  8014a9:	0f b6 c1             	movzbl %cl,%eax
  8014ac:	0f b6 db             	movzbl %bl,%ebx
  8014af:	29 d8                	sub    %ebx,%eax
  8014b1:	eb 05                	jmp    8014b8 <memcmp+0x2f>
	}

	return 0;
  8014b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8014b8:	5b                   	pop    %ebx
  8014b9:	5e                   	pop    %esi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    

008014bc <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c2:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  8014c5:	89 c2                	mov    %eax,%edx
  8014c7:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  8014ca:	39 d0                	cmp    %edx,%eax
  8014cc:	73 07                	jae    8014d5 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  8014ce:	38 08                	cmp    %cl,(%eax)
  8014d0:	74 03                	je     8014d5 <memfind+0x19>
	for (; s < ends; s++)
  8014d2:	40                   	inc    %eax
  8014d3:	eb f5                	jmp    8014ca <memfind+0xe>
			break;
	return (void *) s;
}
  8014d5:	5d                   	pop    %ebp
  8014d6:	c3                   	ret    

008014d7 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8014d7:	55                   	push   %ebp
  8014d8:	89 e5                	mov    %esp,%ebp
  8014da:	57                   	push   %edi
  8014db:	56                   	push   %esi
  8014dc:	53                   	push   %ebx
  8014dd:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8014e0:	eb 01                	jmp    8014e3 <strtol+0xc>
		s++;
  8014e2:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  8014e3:	8a 01                	mov    (%ecx),%al
  8014e5:	3c 20                	cmp    $0x20,%al
  8014e7:	74 f9                	je     8014e2 <strtol+0xb>
  8014e9:	3c 09                	cmp    $0x9,%al
  8014eb:	74 f5                	je     8014e2 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  8014ed:	3c 2b                	cmp    $0x2b,%al
  8014ef:	74 2b                	je     80151c <strtol+0x45>
		s++;
	else if (*s == '-')
  8014f1:	3c 2d                	cmp    $0x2d,%al
  8014f3:	74 2f                	je     801524 <strtol+0x4d>
	int neg = 0;
  8014f5:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8014fa:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801501:	75 12                	jne    801515 <strtol+0x3e>
  801503:	80 39 30             	cmpb   $0x30,(%ecx)
  801506:	74 24                	je     80152c <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801508:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80150c:	75 07                	jne    801515 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80150e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801515:	b8 00 00 00 00       	mov    $0x0,%eax
  80151a:	eb 4e                	jmp    80156a <strtol+0x93>
		s++;
  80151c:	41                   	inc    %ecx
	int neg = 0;
  80151d:	bf 00 00 00 00       	mov    $0x0,%edi
  801522:	eb d6                	jmp    8014fa <strtol+0x23>
		s++, neg = 1;
  801524:	41                   	inc    %ecx
  801525:	bf 01 00 00 00       	mov    $0x1,%edi
  80152a:	eb ce                	jmp    8014fa <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80152c:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801530:	74 10                	je     801542 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801532:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801536:	75 dd                	jne    801515 <strtol+0x3e>
		s++, base = 8;
  801538:	41                   	inc    %ecx
  801539:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801540:	eb d3                	jmp    801515 <strtol+0x3e>
		s += 2, base = 16;
  801542:	83 c1 02             	add    $0x2,%ecx
  801545:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80154c:	eb c7                	jmp    801515 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80154e:	8d 72 9f             	lea    -0x61(%edx),%esi
  801551:	89 f3                	mov    %esi,%ebx
  801553:	80 fb 19             	cmp    $0x19,%bl
  801556:	77 24                	ja     80157c <strtol+0xa5>
			dig = *s - 'a' + 10;
  801558:	0f be d2             	movsbl %dl,%edx
  80155b:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  80155e:	3b 55 10             	cmp    0x10(%ebp),%edx
  801561:	7d 2b                	jge    80158e <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801563:	41                   	inc    %ecx
  801564:	0f af 45 10          	imul   0x10(%ebp),%eax
  801568:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  80156a:	8a 11                	mov    (%ecx),%dl
  80156c:	8d 5a d0             	lea    -0x30(%edx),%ebx
  80156f:	80 fb 09             	cmp    $0x9,%bl
  801572:	77 da                	ja     80154e <strtol+0x77>
			dig = *s - '0';
  801574:	0f be d2             	movsbl %dl,%edx
  801577:	83 ea 30             	sub    $0x30,%edx
  80157a:	eb e2                	jmp    80155e <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  80157c:	8d 72 bf             	lea    -0x41(%edx),%esi
  80157f:	89 f3                	mov    %esi,%ebx
  801581:	80 fb 19             	cmp    $0x19,%bl
  801584:	77 08                	ja     80158e <strtol+0xb7>
			dig = *s - 'A' + 10;
  801586:	0f be d2             	movsbl %dl,%edx
  801589:	83 ea 37             	sub    $0x37,%edx
  80158c:	eb d0                	jmp    80155e <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  80158e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801592:	74 05                	je     801599 <strtol+0xc2>
		*endptr = (char *) s;
  801594:	8b 75 0c             	mov    0xc(%ebp),%esi
  801597:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801599:	85 ff                	test   %edi,%edi
  80159b:	74 02                	je     80159f <strtol+0xc8>
  80159d:	f7 d8                	neg    %eax
}
  80159f:	5b                   	pop    %ebx
  8015a0:	5e                   	pop    %esi
  8015a1:	5f                   	pop    %edi
  8015a2:	5d                   	pop    %ebp
  8015a3:	c3                   	ret    

008015a4 <atoi>:

int
atoi(const char *s)
{
  8015a4:	55                   	push   %ebp
  8015a5:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  8015a7:	6a 0a                	push   $0xa
  8015a9:	6a 00                	push   $0x0
  8015ab:	ff 75 08             	pushl  0x8(%ebp)
  8015ae:	e8 24 ff ff ff       	call   8014d7 <strtol>
}
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	57                   	push   %edi
  8015b9:	56                   	push   %esi
  8015ba:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8015c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8015c6:	89 c3                	mov    %eax,%ebx
  8015c8:	89 c7                	mov    %eax,%edi
  8015ca:	89 c6                	mov    %eax,%esi
  8015cc:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8015ce:	5b                   	pop    %ebx
  8015cf:	5e                   	pop    %esi
  8015d0:	5f                   	pop    %edi
  8015d1:	5d                   	pop    %ebp
  8015d2:	c3                   	ret    

008015d3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015d3:	55                   	push   %ebp
  8015d4:	89 e5                	mov    %esp,%ebp
  8015d6:	57                   	push   %edi
  8015d7:	56                   	push   %esi
  8015d8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8015d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8015de:	b8 01 00 00 00       	mov    $0x1,%eax
  8015e3:	89 d1                	mov    %edx,%ecx
  8015e5:	89 d3                	mov    %edx,%ebx
  8015e7:	89 d7                	mov    %edx,%edi
  8015e9:	89 d6                	mov    %edx,%esi
  8015eb:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8015ed:	5b                   	pop    %ebx
  8015ee:	5e                   	pop    %esi
  8015ef:	5f                   	pop    %edi
  8015f0:	5d                   	pop    %ebp
  8015f1:	c3                   	ret    

008015f2 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	57                   	push   %edi
  8015f6:	56                   	push   %esi
  8015f7:	53                   	push   %ebx
  8015f8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8015fb:	b9 00 00 00 00       	mov    $0x0,%ecx
  801600:	b8 03 00 00 00       	mov    $0x3,%eax
  801605:	8b 55 08             	mov    0x8(%ebp),%edx
  801608:	89 cb                	mov    %ecx,%ebx
  80160a:	89 cf                	mov    %ecx,%edi
  80160c:	89 ce                	mov    %ecx,%esi
  80160e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801610:	85 c0                	test   %eax,%eax
  801612:	7f 08                	jg     80161c <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801614:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801617:	5b                   	pop    %ebx
  801618:	5e                   	pop    %esi
  801619:	5f                   	pop    %edi
  80161a:	5d                   	pop    %ebp
  80161b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80161c:	83 ec 0c             	sub    $0xc,%esp
  80161f:	50                   	push   %eax
  801620:	6a 03                	push   $0x3
  801622:	68 2f 39 80 00       	push   $0x80392f
  801627:	6a 23                	push   $0x23
  801629:	68 4c 39 80 00       	push   $0x80394c
  80162e:	e8 56 f4 ff ff       	call   800a89 <_panic>

00801633 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	57                   	push   %edi
  801637:	56                   	push   %esi
  801638:	53                   	push   %ebx
	asm volatile("int %1\n"
  801639:	ba 00 00 00 00       	mov    $0x0,%edx
  80163e:	b8 02 00 00 00       	mov    $0x2,%eax
  801643:	89 d1                	mov    %edx,%ecx
  801645:	89 d3                	mov    %edx,%ebx
  801647:	89 d7                	mov    %edx,%edi
  801649:	89 d6                	mov    %edx,%esi
  80164b:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  80164d:	5b                   	pop    %ebx
  80164e:	5e                   	pop    %esi
  80164f:	5f                   	pop    %edi
  801650:	5d                   	pop    %ebp
  801651:	c3                   	ret    

00801652 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  801652:	55                   	push   %ebp
  801653:	89 e5                	mov    %esp,%ebp
  801655:	57                   	push   %edi
  801656:	56                   	push   %esi
  801657:	53                   	push   %ebx
  801658:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80165b:	be 00 00 00 00       	mov    $0x0,%esi
  801660:	b8 04 00 00 00       	mov    $0x4,%eax
  801665:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801668:	8b 55 08             	mov    0x8(%ebp),%edx
  80166b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80166e:	89 f7                	mov    %esi,%edi
  801670:	cd 30                	int    $0x30
	if(check && ret > 0)
  801672:	85 c0                	test   %eax,%eax
  801674:	7f 08                	jg     80167e <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  801676:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801679:	5b                   	pop    %ebx
  80167a:	5e                   	pop    %esi
  80167b:	5f                   	pop    %edi
  80167c:	5d                   	pop    %ebp
  80167d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80167e:	83 ec 0c             	sub    $0xc,%esp
  801681:	50                   	push   %eax
  801682:	6a 04                	push   $0x4
  801684:	68 2f 39 80 00       	push   $0x80392f
  801689:	6a 23                	push   $0x23
  80168b:	68 4c 39 80 00       	push   $0x80394c
  801690:	e8 f4 f3 ff ff       	call   800a89 <_panic>

00801695 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
  801698:	57                   	push   %edi
  801699:	56                   	push   %esi
  80169a:	53                   	push   %ebx
  80169b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80169e:	b8 05 00 00 00       	mov    $0x5,%eax
  8016a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8016a9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8016ac:	8b 7d 14             	mov    0x14(%ebp),%edi
  8016af:	8b 75 18             	mov    0x18(%ebp),%esi
  8016b2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016b4:	85 c0                	test   %eax,%eax
  8016b6:	7f 08                	jg     8016c0 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8016b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016bb:	5b                   	pop    %ebx
  8016bc:	5e                   	pop    %esi
  8016bd:	5f                   	pop    %edi
  8016be:	5d                   	pop    %ebp
  8016bf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8016c0:	83 ec 0c             	sub    $0xc,%esp
  8016c3:	50                   	push   %eax
  8016c4:	6a 05                	push   $0x5
  8016c6:	68 2f 39 80 00       	push   $0x80392f
  8016cb:	6a 23                	push   $0x23
  8016cd:	68 4c 39 80 00       	push   $0x80394c
  8016d2:	e8 b2 f3 ff ff       	call   800a89 <_panic>

008016d7 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8016d7:	55                   	push   %ebp
  8016d8:	89 e5                	mov    %esp,%ebp
  8016da:	57                   	push   %edi
  8016db:	56                   	push   %esi
  8016dc:	53                   	push   %ebx
  8016dd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8016e0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8016e5:	b8 06 00 00 00       	mov    $0x6,%eax
  8016ea:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8016ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f0:	89 df                	mov    %ebx,%edi
  8016f2:	89 de                	mov    %ebx,%esi
  8016f4:	cd 30                	int    $0x30
	if(check && ret > 0)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	7f 08                	jg     801702 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8016fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016fd:	5b                   	pop    %ebx
  8016fe:	5e                   	pop    %esi
  8016ff:	5f                   	pop    %edi
  801700:	5d                   	pop    %ebp
  801701:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801702:	83 ec 0c             	sub    $0xc,%esp
  801705:	50                   	push   %eax
  801706:	6a 06                	push   $0x6
  801708:	68 2f 39 80 00       	push   $0x80392f
  80170d:	6a 23                	push   $0x23
  80170f:	68 4c 39 80 00       	push   $0x80394c
  801714:	e8 70 f3 ff ff       	call   800a89 <_panic>

00801719 <sys_yield>:

void
sys_yield(void)
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
  80171c:	57                   	push   %edi
  80171d:	56                   	push   %esi
  80171e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80171f:	ba 00 00 00 00       	mov    $0x0,%edx
  801724:	b8 0b 00 00 00       	mov    $0xb,%eax
  801729:	89 d1                	mov    %edx,%ecx
  80172b:	89 d3                	mov    %edx,%ebx
  80172d:	89 d7                	mov    %edx,%edi
  80172f:	89 d6                	mov    %edx,%esi
  801731:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  801733:	5b                   	pop    %ebx
  801734:	5e                   	pop    %esi
  801735:	5f                   	pop    %edi
  801736:	5d                   	pop    %ebp
  801737:	c3                   	ret    

00801738 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	57                   	push   %edi
  80173c:	56                   	push   %esi
  80173d:	53                   	push   %ebx
  80173e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801741:	bb 00 00 00 00       	mov    $0x0,%ebx
  801746:	b8 08 00 00 00       	mov    $0x8,%eax
  80174b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80174e:	8b 55 08             	mov    0x8(%ebp),%edx
  801751:	89 df                	mov    %ebx,%edi
  801753:	89 de                	mov    %ebx,%esi
  801755:	cd 30                	int    $0x30
	if(check && ret > 0)
  801757:	85 c0                	test   %eax,%eax
  801759:	7f 08                	jg     801763 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80175b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80175e:	5b                   	pop    %ebx
  80175f:	5e                   	pop    %esi
  801760:	5f                   	pop    %edi
  801761:	5d                   	pop    %ebp
  801762:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801763:	83 ec 0c             	sub    $0xc,%esp
  801766:	50                   	push   %eax
  801767:	6a 08                	push   $0x8
  801769:	68 2f 39 80 00       	push   $0x80392f
  80176e:	6a 23                	push   $0x23
  801770:	68 4c 39 80 00       	push   $0x80394c
  801775:	e8 0f f3 ff ff       	call   800a89 <_panic>

0080177a <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  80177a:	55                   	push   %ebp
  80177b:	89 e5                	mov    %esp,%ebp
  80177d:	57                   	push   %edi
  80177e:	56                   	push   %esi
  80177f:	53                   	push   %ebx
  801780:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801783:	b9 00 00 00 00       	mov    $0x0,%ecx
  801788:	b8 0c 00 00 00       	mov    $0xc,%eax
  80178d:	8b 55 08             	mov    0x8(%ebp),%edx
  801790:	89 cb                	mov    %ecx,%ebx
  801792:	89 cf                	mov    %ecx,%edi
  801794:	89 ce                	mov    %ecx,%esi
  801796:	cd 30                	int    $0x30
	if(check && ret > 0)
  801798:	85 c0                	test   %eax,%eax
  80179a:	7f 08                	jg     8017a4 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80179c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179f:	5b                   	pop    %ebx
  8017a0:	5e                   	pop    %esi
  8017a1:	5f                   	pop    %edi
  8017a2:	5d                   	pop    %ebp
  8017a3:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017a4:	83 ec 0c             	sub    $0xc,%esp
  8017a7:	50                   	push   %eax
  8017a8:	6a 0c                	push   $0xc
  8017aa:	68 2f 39 80 00       	push   $0x80392f
  8017af:	6a 23                	push   $0x23
  8017b1:	68 4c 39 80 00       	push   $0x80394c
  8017b6:	e8 ce f2 ff ff       	call   800a89 <_panic>

008017bb <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8017bb:	55                   	push   %ebp
  8017bc:	89 e5                	mov    %esp,%ebp
  8017be:	57                   	push   %edi
  8017bf:	56                   	push   %esi
  8017c0:	53                   	push   %ebx
  8017c1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8017c4:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c9:	b8 09 00 00 00       	mov    $0x9,%eax
  8017ce:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8017d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8017d4:	89 df                	mov    %ebx,%edi
  8017d6:	89 de                	mov    %ebx,%esi
  8017d8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8017da:	85 c0                	test   %eax,%eax
  8017dc:	7f 08                	jg     8017e6 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8017de:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017e1:	5b                   	pop    %ebx
  8017e2:	5e                   	pop    %esi
  8017e3:	5f                   	pop    %edi
  8017e4:	5d                   	pop    %ebp
  8017e5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8017e6:	83 ec 0c             	sub    $0xc,%esp
  8017e9:	50                   	push   %eax
  8017ea:	6a 09                	push   $0x9
  8017ec:	68 2f 39 80 00       	push   $0x80392f
  8017f1:	6a 23                	push   $0x23
  8017f3:	68 4c 39 80 00       	push   $0x80394c
  8017f8:	e8 8c f2 ff ff       	call   800a89 <_panic>

008017fd <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8017fd:	55                   	push   %ebp
  8017fe:	89 e5                	mov    %esp,%ebp
  801800:	57                   	push   %edi
  801801:	56                   	push   %esi
  801802:	53                   	push   %ebx
  801803:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801806:	bb 00 00 00 00       	mov    $0x0,%ebx
  80180b:	b8 0a 00 00 00       	mov    $0xa,%eax
  801810:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
  801816:	89 df                	mov    %ebx,%edi
  801818:	89 de                	mov    %ebx,%esi
  80181a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80181c:	85 c0                	test   %eax,%eax
  80181e:	7f 08                	jg     801828 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  801820:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801823:	5b                   	pop    %ebx
  801824:	5e                   	pop    %esi
  801825:	5f                   	pop    %edi
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801828:	83 ec 0c             	sub    $0xc,%esp
  80182b:	50                   	push   %eax
  80182c:	6a 0a                	push   $0xa
  80182e:	68 2f 39 80 00       	push   $0x80392f
  801833:	6a 23                	push   $0x23
  801835:	68 4c 39 80 00       	push   $0x80394c
  80183a:	e8 4a f2 ff ff       	call   800a89 <_panic>

0080183f <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	57                   	push   %edi
  801843:	56                   	push   %esi
  801844:	53                   	push   %ebx
	asm volatile("int %1\n"
  801845:	be 00 00 00 00       	mov    $0x0,%esi
  80184a:	b8 0d 00 00 00       	mov    $0xd,%eax
  80184f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801852:	8b 55 08             	mov    0x8(%ebp),%edx
  801855:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801858:	8b 7d 14             	mov    0x14(%ebp),%edi
  80185b:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  80185d:	5b                   	pop    %ebx
  80185e:	5e                   	pop    %esi
  80185f:	5f                   	pop    %edi
  801860:	5d                   	pop    %ebp
  801861:	c3                   	ret    

00801862 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	57                   	push   %edi
  801866:	56                   	push   %esi
  801867:	53                   	push   %ebx
  801868:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80186b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801870:	b8 0e 00 00 00       	mov    $0xe,%eax
  801875:	8b 55 08             	mov    0x8(%ebp),%edx
  801878:	89 cb                	mov    %ecx,%ebx
  80187a:	89 cf                	mov    %ecx,%edi
  80187c:	89 ce                	mov    %ecx,%esi
  80187e:	cd 30                	int    $0x30
	if(check && ret > 0)
  801880:	85 c0                	test   %eax,%eax
  801882:	7f 08                	jg     80188c <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  801884:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801887:	5b                   	pop    %ebx
  801888:	5e                   	pop    %esi
  801889:	5f                   	pop    %edi
  80188a:	5d                   	pop    %ebp
  80188b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80188c:	83 ec 0c             	sub    $0xc,%esp
  80188f:	50                   	push   %eax
  801890:	6a 0e                	push   $0xe
  801892:	68 2f 39 80 00       	push   $0x80392f
  801897:	6a 23                	push   $0x23
  801899:	68 4c 39 80 00       	push   $0x80394c
  80189e:	e8 e6 f1 ff ff       	call   800a89 <_panic>

008018a3 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8018a3:	55                   	push   %ebp
  8018a4:	89 e5                	mov    %esp,%ebp
  8018a6:	57                   	push   %edi
  8018a7:	56                   	push   %esi
  8018a8:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018a9:	be 00 00 00 00       	mov    $0x0,%esi
  8018ae:	b8 0f 00 00 00       	mov    $0xf,%eax
  8018b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8018b9:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018bc:	89 f7                	mov    %esi,%edi
  8018be:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8018c0:	5b                   	pop    %ebx
  8018c1:	5e                   	pop    %esi
  8018c2:	5f                   	pop    %edi
  8018c3:	5d                   	pop    %ebp
  8018c4:	c3                   	ret    

008018c5 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	57                   	push   %edi
  8018c9:	56                   	push   %esi
  8018ca:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018cb:	be 00 00 00 00       	mov    $0x0,%esi
  8018d0:	b8 10 00 00 00       	mov    $0x10,%eax
  8018d5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8018db:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8018de:	89 f7                	mov    %esi,%edi
  8018e0:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8018e2:	5b                   	pop    %ebx
  8018e3:	5e                   	pop    %esi
  8018e4:	5f                   	pop    %edi
  8018e5:	5d                   	pop    %ebp
  8018e6:	c3                   	ret    

008018e7 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8018e7:	55                   	push   %ebp
  8018e8:	89 e5                	mov    %esp,%ebp
  8018ea:	57                   	push   %edi
  8018eb:	56                   	push   %esi
  8018ec:	53                   	push   %ebx
	asm volatile("int %1\n"
  8018ed:	b9 00 00 00 00       	mov    $0x0,%ecx
  8018f2:	b8 11 00 00 00       	mov    $0x11,%eax
  8018f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8018fa:	89 cb                	mov    %ecx,%ebx
  8018fc:	89 cf                	mov    %ecx,%edi
  8018fe:	89 ce                	mov    %ecx,%esi
  801900:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  801902:	5b                   	pop    %ebx
  801903:	5e                   	pop    %esi
  801904:	5f                   	pop    %edi
  801905:	5d                   	pop    %ebp
  801906:	c3                   	ret    

00801907 <pgfault>:
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
  801907:	55                   	push   %ebp
  801908:	89 e5                	mov    %esp,%ebp
  80190a:	56                   	push   %esi
  80190b:	53                   	push   %ebx
  80190c:	8b 45 08             	mov    0x8(%ebp),%eax
	void *addr = (void *) utf->utf_fault_va;
  80190f:	8b 18                	mov    (%eax),%ebx
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  801911:	f6 40 04 02          	testb  $0x2,0x4(%eax)
  801915:	0f 84 84 00 00 00    	je     80199f <pgfault+0x98>
  80191b:	89 d8                	mov    %ebx,%eax
  80191d:	c1 e8 16             	shr    $0x16,%eax
  801920:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801927:	a8 01                	test   $0x1,%al
  801929:	74 74                	je     80199f <pgfault+0x98>
  80192b:	89 d8                	mov    %ebx,%eax
  80192d:	c1 e8 0c             	shr    $0xc,%eax
  801930:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801937:	f6 c4 08             	test   $0x8,%ah
  80193a:	74 63                	je     80199f <pgfault+0x98>
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
  80193c:	e8 f2 fc ff ff       	call   801633 <sys_getenvid>
  801941:	89 c6                	mov    %eax,%esi
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  801943:	83 ec 04             	sub    $0x4,%esp
  801946:	6a 07                	push   $0x7
  801948:	68 00 f0 7f 00       	push   $0x7ff000
  80194d:	50                   	push   %eax
  80194e:	e8 ff fc ff ff       	call   801652 <sys_page_alloc>
  801953:	83 c4 10             	add    $0x10,%esp
  801956:	85 c0                	test   %eax,%eax
  801958:	78 5b                	js     8019b5 <pgfault+0xae>
	addr = ROUNDDOWN(addr, PGSIZE);
  80195a:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
	memcpy(PFTEMP, addr, PGSIZE);
  801960:	83 ec 04             	sub    $0x4,%esp
  801963:	68 00 10 00 00       	push   $0x1000
  801968:	53                   	push   %ebx
  801969:	68 00 f0 7f 00       	push   $0x7ff000
  80196e:	e8 03 fb ff ff       	call   801476 <memcpy>
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
  801973:	c7 04 24 07 00 00 00 	movl   $0x7,(%esp)
  80197a:	53                   	push   %ebx
  80197b:	56                   	push   %esi
  80197c:	68 00 f0 7f 00       	push   $0x7ff000
  801981:	56                   	push   %esi
  801982:	e8 0e fd ff ff       	call   801695 <sys_page_map>
	sys_page_unmap(curid, PFTEMP);
  801987:	83 c4 18             	add    $0x18,%esp
  80198a:	68 00 f0 7f 00       	push   $0x7ff000
  80198f:	56                   	push   %esi
  801990:	e8 42 fd ff ff       	call   8016d7 <sys_page_unmap>

}
  801995:	83 c4 10             	add    $0x10,%esp
  801998:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199b:	5b                   	pop    %ebx
  80199c:	5e                   	pop    %esi
  80199d:	5d                   	pop    %ebp
  80199e:	c3                   	ret    
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));
  80199f:	68 5c 39 80 00       	push   $0x80395c
  8019a4:	68 1a 35 80 00       	push   $0x80351a
  8019a9:	6a 1c                	push   $0x1c
  8019ab:	68 e6 39 80 00       	push   $0x8039e6
  8019b0:	e8 d4 f0 ff ff       	call   800a89 <_panic>
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
  8019b5:	68 ac 39 80 00       	push   $0x8039ac
  8019ba:	68 1a 35 80 00       	push   $0x80351a
  8019bf:	6a 26                	push   $0x26
  8019c1:	68 e6 39 80 00       	push   $0x8039e6
  8019c6:	e8 be f0 ff ff       	call   800a89 <_panic>

008019cb <fork>:
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	57                   	push   %edi
  8019cf:	56                   	push   %esi
  8019d0:	53                   	push   %ebx
  8019d1:	83 ec 28             	sub    $0x28,%esp
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
  8019d4:	68 07 19 80 00       	push   $0x801907
  8019d9:	e8 d7 15 00 00       	call   802fb5 <set_pgfault_handler>

static inline envid_t __attribute__((always_inline))
sys_exofork(void)
{
	envid_t ret;
	asm volatile("int %2"
  8019de:	b8 07 00 00 00       	mov    $0x7,%eax
  8019e3:	cd 30                	int    $0x30
  8019e5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8019e8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	envid_t childid = sys_exofork();
	if (childid < 0) {
  8019eb:	83 c4 10             	add    $0x10,%esp
  8019ee:	85 c0                	test   %eax,%eax
  8019f0:	0f 88 58 01 00 00    	js     801b4e <fork+0x183>
		return -1;
	} 
	if (childid == 0) {
  8019f6:	85 c0                	test   %eax,%eax
  8019f8:	74 07                	je     801a01 <fork+0x36>
  8019fa:	bb 00 00 00 00       	mov    $0x0,%ebx
  8019ff:	eb 72                	jmp    801a73 <fork+0xa8>
		thisenv = &envs[ENVX(sys_getenvid())];
  801a01:	e8 2d fc ff ff       	call   801633 <sys_getenvid>
  801a06:	25 ff 03 00 00       	and    $0x3ff,%eax
  801a0b:	89 c2                	mov    %eax,%edx
  801a0d:	c1 e2 05             	shl    $0x5,%edx
  801a10:	29 c2                	sub    %eax,%edx
  801a12:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801a19:	a3 24 54 80 00       	mov    %eax,0x805424
		return 0;
  801a1e:	e9 20 01 00 00       	jmp    801b43 <fork+0x178>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
  801a23:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  801a2a:	e8 04 fc ff ff       	call   801633 <sys_getenvid>
  801a2f:	83 ec 0c             	sub    $0xc,%esp
  801a32:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  801a38:	57                   	push   %edi
  801a39:	56                   	push   %esi
  801a3a:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a3d:	56                   	push   %esi
  801a3e:	50                   	push   %eax
  801a3f:	e8 51 fc ff ff       	call   801695 <sys_page_map>
  801a44:	83 c4 20             	add    $0x20,%esp
  801a47:	eb 18                	jmp    801a61 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
  801a49:	e8 e5 fb ff ff       	call   801633 <sys_getenvid>
  801a4e:	83 ec 0c             	sub    $0xc,%esp
  801a51:	6a 05                	push   $0x5
  801a53:	56                   	push   %esi
  801a54:	ff 75 e4             	pushl  -0x1c(%ebp)
  801a57:	56                   	push   %esi
  801a58:	50                   	push   %eax
  801a59:	e8 37 fc ff ff       	call   801695 <sys_page_map>
  801a5e:	83 c4 20             	add    $0x20,%esp
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  801a61:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  801a67:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  801a6d:	0f 84 8f 00 00 00    	je     801b02 <fork+0x137>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
  801a73:	89 d8                	mov    %ebx,%eax
  801a75:	c1 e8 16             	shr    $0x16,%eax
  801a78:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801a7f:	a8 01                	test   $0x1,%al
  801a81:	74 de                	je     801a61 <fork+0x96>
  801a83:	89 d8                	mov    %ebx,%eax
  801a85:	c1 e8 0c             	shr    $0xc,%eax
  801a88:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801a8f:	a8 04                	test   $0x4,%al
  801a91:	74 ce                	je     801a61 <fork+0x96>
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
  801a93:	89 de                	mov    %ebx,%esi
  801a95:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  801a9b:	89 f0                	mov    %esi,%eax
  801a9d:	c1 e8 0c             	shr    $0xc,%eax
  801aa0:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801aa7:	f6 c6 04             	test   $0x4,%dh
  801aaa:	0f 85 73 ff ff ff    	jne    801a23 <fork+0x58>
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
  801ab0:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801ab7:	a9 02 08 00 00       	test   $0x802,%eax
  801abc:	74 8b                	je     801a49 <fork+0x7e>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801abe:	e8 70 fb ff ff       	call   801633 <sys_getenvid>
  801ac3:	83 ec 0c             	sub    $0xc,%esp
  801ac6:	68 05 08 00 00       	push   $0x805
  801acb:	56                   	push   %esi
  801acc:	ff 75 e4             	pushl  -0x1c(%ebp)
  801acf:	56                   	push   %esi
  801ad0:	50                   	push   %eax
  801ad1:	e8 bf fb ff ff       	call   801695 <sys_page_map>
  801ad6:	83 c4 20             	add    $0x20,%esp
  801ad9:	85 c0                	test   %eax,%eax
  801adb:	78 84                	js     801a61 <fork+0x96>
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
  801add:	e8 51 fb ff ff       	call   801633 <sys_getenvid>
  801ae2:	89 c7                	mov    %eax,%edi
  801ae4:	e8 4a fb ff ff       	call   801633 <sys_getenvid>
  801ae9:	83 ec 0c             	sub    $0xc,%esp
  801aec:	68 05 08 00 00       	push   $0x805
  801af1:	56                   	push   %esi
  801af2:	57                   	push   %edi
  801af3:	56                   	push   %esi
  801af4:	50                   	push   %eax
  801af5:	e8 9b fb ff ff       	call   801695 <sys_page_map>
  801afa:	83 c4 20             	add    $0x20,%esp
  801afd:	e9 5f ff ff ff       	jmp    801a61 <fork+0x96>
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
  801b02:	83 ec 04             	sub    $0x4,%esp
  801b05:	6a 07                	push   $0x7
  801b07:	68 00 f0 bf ee       	push   $0xeebff000
  801b0c:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801b0f:	57                   	push   %edi
  801b10:	e8 3d fb ff ff       	call   801652 <sys_page_alloc>
  801b15:	83 c4 10             	add    $0x10,%esp
  801b18:	85 c0                	test   %eax,%eax
  801b1a:	78 3b                	js     801b57 <fork+0x18c>
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
  801b1c:	83 ec 08             	sub    $0x8,%esp
  801b1f:	68 fb 2f 80 00       	push   $0x802ffb
  801b24:	57                   	push   %edi
  801b25:	e8 d3 fc ff ff       	call   8017fd <sys_env_set_pgfault_upcall>
  801b2a:	83 c4 10             	add    $0x10,%esp
  801b2d:	85 c0                	test   %eax,%eax
  801b2f:	78 2f                	js     801b60 <fork+0x195>
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
  801b31:	83 ec 08             	sub    $0x8,%esp
  801b34:	6a 02                	push   $0x2
  801b36:	57                   	push   %edi
  801b37:	e8 fc fb ff ff       	call   801738 <sys_env_set_status>
	if (temp < 0) {
  801b3c:	83 c4 10             	add    $0x10,%esp
  801b3f:	85 c0                	test   %eax,%eax
  801b41:	78 26                	js     801b69 <fork+0x19e>
		return -1;
	}

	return childid;
}
  801b43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b46:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b49:	5b                   	pop    %ebx
  801b4a:	5e                   	pop    %esi
  801b4b:	5f                   	pop    %edi
  801b4c:	5d                   	pop    %ebp
  801b4d:	c3                   	ret    
		return -1;
  801b4e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801b55:	eb ec                	jmp    801b43 <fork+0x178>
		return -1;
  801b57:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801b5e:	eb e3                	jmp    801b43 <fork+0x178>
		return -1;
  801b60:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801b67:	eb da                	jmp    801b43 <fork+0x178>
		return -1;
  801b69:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  801b70:	eb d1                	jmp    801b43 <fork+0x178>

00801b72 <sfork>:

// Challenge!
int
sfork(void)
{
  801b72:	55                   	push   %ebp
  801b73:	89 e5                	mov    %esp,%ebp
  801b75:	83 ec 0c             	sub    $0xc,%esp
	panic("sfork not implemented");
  801b78:	68 f1 39 80 00       	push   $0x8039f1
  801b7d:	68 85 00 00 00       	push   $0x85
  801b82:	68 e6 39 80 00       	push   $0x8039e6
  801b87:	e8 fd ee ff ff       	call   800a89 <_panic>

00801b8c <argstart>:
#include <inc/args.h>
#include <inc/string.h>

void
argstart(int *argc, char **argv, struct Argstate *args)
{
  801b8c:	55                   	push   %ebp
  801b8d:	89 e5                	mov    %esp,%ebp
  801b8f:	8b 55 08             	mov    0x8(%ebp),%edx
  801b92:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801b95:	8b 45 10             	mov    0x10(%ebp),%eax
	args->argc = argc;
  801b98:	89 10                	mov    %edx,(%eax)
	args->argv = (const char **) argv;
  801b9a:	89 48 04             	mov    %ecx,0x4(%eax)
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801b9d:	83 3a 01             	cmpl   $0x1,(%edx)
  801ba0:	7e 15                	jle    801bb7 <argstart+0x2b>
  801ba2:	85 c9                	test   %ecx,%ecx
  801ba4:	74 18                	je     801bbe <argstart+0x32>
  801ba6:	ba 01 34 80 00       	mov    $0x803401,%edx
  801bab:	89 50 08             	mov    %edx,0x8(%eax)
	args->argvalue = 0;
  801bae:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
}
  801bb5:	5d                   	pop    %ebp
  801bb6:	c3                   	ret    
	args->curarg = (*argc > 1 && argv ? "" : 0);
  801bb7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbc:	eb ed                	jmp    801bab <argstart+0x1f>
  801bbe:	ba 00 00 00 00       	mov    $0x0,%edx
  801bc3:	eb e6                	jmp    801bab <argstart+0x1f>

00801bc5 <argnext>:

int
argnext(struct Argstate *args)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	53                   	push   %ebx
  801bc9:	83 ec 04             	sub    $0x4,%esp
  801bcc:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int arg;

	args->argvalue = 0;
  801bcf:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)

	// Done processing arguments if args->curarg == 0
	if (args->curarg == 0)
  801bd6:	8b 43 08             	mov    0x8(%ebx),%eax
  801bd9:	85 c0                	test   %eax,%eax
  801bdb:	74 6d                	je     801c4a <argnext+0x85>
		return -1;

	if (!*args->curarg) {
  801bdd:	80 38 00             	cmpb   $0x0,(%eax)
  801be0:	75 45                	jne    801c27 <argnext+0x62>
		// Need to process the next argument
		// Check for end of argument list
		if (*args->argc == 1
  801be2:	8b 0b                	mov    (%ebx),%ecx
  801be4:	83 39 01             	cmpl   $0x1,(%ecx)
  801be7:	74 53                	je     801c3c <argnext+0x77>
		    || args->argv[1][0] != '-'
  801be9:	8b 53 04             	mov    0x4(%ebx),%edx
  801bec:	8b 42 04             	mov    0x4(%edx),%eax
  801bef:	80 38 2d             	cmpb   $0x2d,(%eax)
  801bf2:	75 48                	jne    801c3c <argnext+0x77>
		    || args->argv[1][1] == '\0')
  801bf4:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801bf8:	74 42                	je     801c3c <argnext+0x77>
			goto endofargs;
		// Shift arguments down one
		args->curarg = args->argv[1] + 1;
  801bfa:	40                   	inc    %eax
  801bfb:	89 43 08             	mov    %eax,0x8(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	8b 01                	mov    (%ecx),%eax
  801c03:	8d 04 85 fc ff ff ff 	lea    -0x4(,%eax,4),%eax
  801c0a:	50                   	push   %eax
  801c0b:	8d 42 08             	lea    0x8(%edx),%eax
  801c0e:	50                   	push   %eax
  801c0f:	83 c2 04             	add    $0x4,%edx
  801c12:	52                   	push   %edx
  801c13:	e8 f8 f7 ff ff       	call   801410 <memmove>
		(*args->argc)--;
  801c18:	8b 03                	mov    (%ebx),%eax
  801c1a:	ff 08                	decl   (%eax)
		// Check for "--": end of argument list
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c1c:	8b 43 08             	mov    0x8(%ebx),%eax
  801c1f:	83 c4 10             	add    $0x10,%esp
  801c22:	80 38 2d             	cmpb   $0x2d,(%eax)
  801c25:	74 0f                	je     801c36 <argnext+0x71>
			goto endofargs;
	}

	arg = (unsigned char) *args->curarg;
  801c27:	8b 53 08             	mov    0x8(%ebx),%edx
  801c2a:	0f b6 02             	movzbl (%edx),%eax
	args->curarg++;
  801c2d:	42                   	inc    %edx
  801c2e:	89 53 08             	mov    %edx,0x8(%ebx)
	return arg;

    endofargs:
	args->curarg = 0;
	return -1;
}
  801c31:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c34:	c9                   	leave  
  801c35:	c3                   	ret    
		if (args->curarg[0] == '-' && args->curarg[1] == '\0')
  801c36:	80 78 01 00          	cmpb   $0x0,0x1(%eax)
  801c3a:	75 eb                	jne    801c27 <argnext+0x62>
	args->curarg = 0;
  801c3c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
	return -1;
  801c43:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c48:	eb e7                	jmp    801c31 <argnext+0x6c>
		return -1;
  801c4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c4f:	eb e0                	jmp    801c31 <argnext+0x6c>

00801c51 <argnextvalue>:
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
}

char *
argnextvalue(struct Argstate *args)
{
  801c51:	55                   	push   %ebp
  801c52:	89 e5                	mov    %esp,%ebp
  801c54:	53                   	push   %ebx
  801c55:	83 ec 04             	sub    $0x4,%esp
  801c58:	8b 5d 08             	mov    0x8(%ebp),%ebx
	if (!args->curarg)
  801c5b:	8b 43 08             	mov    0x8(%ebx),%eax
  801c5e:	85 c0                	test   %eax,%eax
  801c60:	74 5a                	je     801cbc <argnextvalue+0x6b>
		return 0;
	if (*args->curarg) {
  801c62:	80 38 00             	cmpb   $0x0,(%eax)
  801c65:	74 12                	je     801c79 <argnextvalue+0x28>
		args->argvalue = args->curarg;
  801c67:	89 43 0c             	mov    %eax,0xc(%ebx)
		args->curarg = "";
  801c6a:	c7 43 08 01 34 80 00 	movl   $0x803401,0x8(%ebx)
		(*args->argc)--;
	} else {
		args->argvalue = 0;
		args->curarg = 0;
	}
	return (char*) args->argvalue;
  801c71:	8b 43 0c             	mov    0xc(%ebx),%eax
}
  801c74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c77:	c9                   	leave  
  801c78:	c3                   	ret    
	} else if (*args->argc > 1) {
  801c79:	8b 13                	mov    (%ebx),%edx
  801c7b:	83 3a 01             	cmpl   $0x1,(%edx)
  801c7e:	7e 2c                	jle    801cac <argnextvalue+0x5b>
		args->argvalue = args->argv[1];
  801c80:	8b 43 04             	mov    0x4(%ebx),%eax
  801c83:	8b 48 04             	mov    0x4(%eax),%ecx
  801c86:	89 4b 0c             	mov    %ecx,0xc(%ebx)
		memmove(args->argv + 1, args->argv + 2, sizeof(const char *) * (*args->argc - 1));
  801c89:	83 ec 04             	sub    $0x4,%esp
  801c8c:	8b 12                	mov    (%edx),%edx
  801c8e:	8d 14 95 fc ff ff ff 	lea    -0x4(,%edx,4),%edx
  801c95:	52                   	push   %edx
  801c96:	8d 50 08             	lea    0x8(%eax),%edx
  801c99:	52                   	push   %edx
  801c9a:	83 c0 04             	add    $0x4,%eax
  801c9d:	50                   	push   %eax
  801c9e:	e8 6d f7 ff ff       	call   801410 <memmove>
		(*args->argc)--;
  801ca3:	8b 03                	mov    (%ebx),%eax
  801ca5:	ff 08                	decl   (%eax)
  801ca7:	83 c4 10             	add    $0x10,%esp
  801caa:	eb c5                	jmp    801c71 <argnextvalue+0x20>
		args->argvalue = 0;
  801cac:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
		args->curarg = 0;
  801cb3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  801cba:	eb b5                	jmp    801c71 <argnextvalue+0x20>
		return 0;
  801cbc:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc1:	eb b1                	jmp    801c74 <argnextvalue+0x23>

00801cc3 <argvalue>:
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
  801cc6:	83 ec 08             	sub    $0x8,%esp
  801cc9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801ccc:	8b 51 0c             	mov    0xc(%ecx),%edx
  801ccf:	89 d0                	mov    %edx,%eax
  801cd1:	85 d2                	test   %edx,%edx
  801cd3:	74 02                	je     801cd7 <argvalue+0x14>
}
  801cd5:	c9                   	leave  
  801cd6:	c3                   	ret    
	return (char*) (args->argvalue ? args->argvalue : argnextvalue(args));
  801cd7:	83 ec 0c             	sub    $0xc,%esp
  801cda:	51                   	push   %ecx
  801cdb:	e8 71 ff ff ff       	call   801c51 <argnextvalue>
  801ce0:	83 c4 10             	add    $0x10,%esp
  801ce3:	eb f0                	jmp    801cd5 <argvalue+0x12>

00801ce5 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  801ce5:	55                   	push   %ebp
  801ce6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ceb:	05 00 00 00 30       	add    $0x30000000,%eax
  801cf0:	c1 e8 0c             	shr    $0xc,%eax
}
  801cf3:	5d                   	pop    %ebp
  801cf4:	c3                   	ret    

00801cf5 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  801cf5:	55                   	push   %ebp
  801cf6:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  801cfb:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801d00:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801d05:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  801d0a:	5d                   	pop    %ebp
  801d0b:	c3                   	ret    

00801d0c <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  801d0c:	55                   	push   %ebp
  801d0d:	89 e5                	mov    %esp,%ebp
  801d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d12:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  801d17:	89 c2                	mov    %eax,%edx
  801d19:	c1 ea 16             	shr    $0x16,%edx
  801d1c:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d23:	f6 c2 01             	test   $0x1,%dl
  801d26:	74 2a                	je     801d52 <fd_alloc+0x46>
  801d28:	89 c2                	mov    %eax,%edx
  801d2a:	c1 ea 0c             	shr    $0xc,%edx
  801d2d:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d34:	f6 c2 01             	test   $0x1,%dl
  801d37:	74 19                	je     801d52 <fd_alloc+0x46>
  801d39:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  801d3e:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  801d43:	75 d2                	jne    801d17 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  801d45:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  801d4b:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  801d50:	eb 07                	jmp    801d59 <fd_alloc+0x4d>
			*fd_store = fd;
  801d52:	89 01                	mov    %eax,(%ecx)
			return 0;
  801d54:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d59:	5d                   	pop    %ebp
  801d5a:	c3                   	ret    

00801d5b <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  801d5b:	55                   	push   %ebp
  801d5c:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  801d5e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  801d62:	77 39                	ja     801d9d <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  801d64:	8b 45 08             	mov    0x8(%ebp),%eax
  801d67:	c1 e0 0c             	shl    $0xc,%eax
  801d6a:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801d6f:	89 c2                	mov    %eax,%edx
  801d71:	c1 ea 16             	shr    $0x16,%edx
  801d74:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801d7b:	f6 c2 01             	test   $0x1,%dl
  801d7e:	74 24                	je     801da4 <fd_lookup+0x49>
  801d80:	89 c2                	mov    %eax,%edx
  801d82:	c1 ea 0c             	shr    $0xc,%edx
  801d85:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801d8c:	f6 c2 01             	test   $0x1,%dl
  801d8f:	74 1a                	je     801dab <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801d91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d94:	89 02                	mov    %eax,(%edx)
	return 0;
  801d96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d9b:	5d                   	pop    %ebp
  801d9c:	c3                   	ret    
		return -E_INVAL;
  801d9d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da2:	eb f7                	jmp    801d9b <fd_lookup+0x40>
		return -E_INVAL;
  801da4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801da9:	eb f0                	jmp    801d9b <fd_lookup+0x40>
  801dab:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801db0:	eb e9                	jmp    801d9b <fd_lookup+0x40>

00801db2 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 08             	sub    $0x8,%esp
  801db8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dbb:	ba 84 3a 80 00       	mov    $0x803a84,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801dc0:	b8 20 40 80 00       	mov    $0x804020,%eax
		if (devtab[i]->dev_id == dev_id) {
  801dc5:	39 08                	cmp    %ecx,(%eax)
  801dc7:	74 33                	je     801dfc <dev_lookup+0x4a>
  801dc9:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801dcc:	8b 02                	mov    (%edx),%eax
  801dce:	85 c0                	test   %eax,%eax
  801dd0:	75 f3                	jne    801dc5 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801dd2:	a1 24 54 80 00       	mov    0x805424,%eax
  801dd7:	8b 40 48             	mov    0x48(%eax),%eax
  801dda:	83 ec 04             	sub    $0x4,%esp
  801ddd:	51                   	push   %ecx
  801dde:	50                   	push   %eax
  801ddf:	68 08 3a 80 00       	push   $0x803a08
  801de4:	e8 b3 ed ff ff       	call   800b9c <cprintf>
	*dev = 0;
  801de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801dec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801df2:	83 c4 10             	add    $0x10,%esp
  801df5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  801dfa:	c9                   	leave  
  801dfb:	c3                   	ret    
			*dev = devtab[i];
  801dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801dff:	89 01                	mov    %eax,(%ecx)
			return 0;
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
  801e06:	eb f2                	jmp    801dfa <dev_lookup+0x48>

00801e08 <fd_close>:
{
  801e08:	55                   	push   %ebp
  801e09:	89 e5                	mov    %esp,%ebp
  801e0b:	57                   	push   %edi
  801e0c:	56                   	push   %esi
  801e0d:	53                   	push   %ebx
  801e0e:	83 ec 1c             	sub    $0x1c,%esp
  801e11:	8b 75 08             	mov    0x8(%ebp),%esi
  801e14:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e17:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801e1a:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  801e1b:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  801e21:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  801e24:	50                   	push   %eax
  801e25:	e8 31 ff ff ff       	call   801d5b <fd_lookup>
  801e2a:	89 c7                	mov    %eax,%edi
  801e2c:	83 c4 08             	add    $0x8,%esp
  801e2f:	85 c0                	test   %eax,%eax
  801e31:	78 05                	js     801e38 <fd_close+0x30>
	    || fd != fd2)
  801e33:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  801e36:	74 13                	je     801e4b <fd_close+0x43>
		return (must_exist ? r : 0);
  801e38:	84 db                	test   %bl,%bl
  801e3a:	75 05                	jne    801e41 <fd_close+0x39>
  801e3c:	bf 00 00 00 00       	mov    $0x0,%edi
}
  801e41:	89 f8                	mov    %edi,%eax
  801e43:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e46:	5b                   	pop    %ebx
  801e47:	5e                   	pop    %esi
  801e48:	5f                   	pop    %edi
  801e49:	5d                   	pop    %ebp
  801e4a:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  801e4b:	83 ec 08             	sub    $0x8,%esp
  801e4e:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801e51:	50                   	push   %eax
  801e52:	ff 36                	pushl  (%esi)
  801e54:	e8 59 ff ff ff       	call   801db2 <dev_lookup>
  801e59:	89 c7                	mov    %eax,%edi
  801e5b:	83 c4 10             	add    $0x10,%esp
  801e5e:	85 c0                	test   %eax,%eax
  801e60:	78 15                	js     801e77 <fd_close+0x6f>
		if (dev->dev_close)
  801e62:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801e65:	8b 40 10             	mov    0x10(%eax),%eax
  801e68:	85 c0                	test   %eax,%eax
  801e6a:	74 1b                	je     801e87 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801e6c:	83 ec 0c             	sub    $0xc,%esp
  801e6f:	56                   	push   %esi
  801e70:	ff d0                	call   *%eax
  801e72:	89 c7                	mov    %eax,%edi
  801e74:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  801e77:	83 ec 08             	sub    $0x8,%esp
  801e7a:	56                   	push   %esi
  801e7b:	6a 00                	push   $0x0
  801e7d:	e8 55 f8 ff ff       	call   8016d7 <sys_page_unmap>
	return r;
  801e82:	83 c4 10             	add    $0x10,%esp
  801e85:	eb ba                	jmp    801e41 <fd_close+0x39>
			r = 0;
  801e87:	bf 00 00 00 00       	mov    $0x0,%edi
  801e8c:	eb e9                	jmp    801e77 <fd_close+0x6f>

00801e8e <close>:

int
close(int fdnum)
{
  801e8e:	55                   	push   %ebp
  801e8f:	89 e5                	mov    %esp,%ebp
  801e91:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801e94:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801e97:	50                   	push   %eax
  801e98:	ff 75 08             	pushl  0x8(%ebp)
  801e9b:	e8 bb fe ff ff       	call   801d5b <fd_lookup>
  801ea0:	83 c4 08             	add    $0x8,%esp
  801ea3:	85 c0                	test   %eax,%eax
  801ea5:	78 10                	js     801eb7 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  801ea7:	83 ec 08             	sub    $0x8,%esp
  801eaa:	6a 01                	push   $0x1
  801eac:	ff 75 f4             	pushl  -0xc(%ebp)
  801eaf:	e8 54 ff ff ff       	call   801e08 <fd_close>
  801eb4:	83 c4 10             	add    $0x10,%esp
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <close_all>:

void
close_all(void)
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	53                   	push   %ebx
  801ebd:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801ec0:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  801ec5:	83 ec 0c             	sub    $0xc,%esp
  801ec8:	53                   	push   %ebx
  801ec9:	e8 c0 ff ff ff       	call   801e8e <close>
	for (i = 0; i < MAXFD; i++)
  801ece:	43                   	inc    %ebx
  801ecf:	83 c4 10             	add    $0x10,%esp
  801ed2:	83 fb 20             	cmp    $0x20,%ebx
  801ed5:	75 ee                	jne    801ec5 <close_all+0xc>
}
  801ed7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eda:	c9                   	leave  
  801edb:	c3                   	ret    

00801edc <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801edc:	55                   	push   %ebp
  801edd:	89 e5                	mov    %esp,%ebp
  801edf:	57                   	push   %edi
  801ee0:	56                   	push   %esi
  801ee1:	53                   	push   %ebx
  801ee2:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  801ee5:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  801ee8:	50                   	push   %eax
  801ee9:	ff 75 08             	pushl  0x8(%ebp)
  801eec:	e8 6a fe ff ff       	call   801d5b <fd_lookup>
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	83 c4 08             	add    $0x8,%esp
  801ef6:	85 c0                	test   %eax,%eax
  801ef8:	0f 88 81 00 00 00    	js     801f7f <dup+0xa3>
		return r;
	close(newfdnum);
  801efe:	83 ec 0c             	sub    $0xc,%esp
  801f01:	ff 75 0c             	pushl  0xc(%ebp)
  801f04:	e8 85 ff ff ff       	call   801e8e <close>

	newfd = INDEX2FD(newfdnum);
  801f09:	8b 75 0c             	mov    0xc(%ebp),%esi
  801f0c:	c1 e6 0c             	shl    $0xc,%esi
  801f0f:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  801f15:	83 c4 04             	add    $0x4,%esp
  801f18:	ff 75 e4             	pushl  -0x1c(%ebp)
  801f1b:	e8 d5 fd ff ff       	call   801cf5 <fd2data>
  801f20:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  801f22:	89 34 24             	mov    %esi,(%esp)
  801f25:	e8 cb fd ff ff       	call   801cf5 <fd2data>
  801f2a:	83 c4 10             	add    $0x10,%esp
  801f2d:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  801f2f:	89 d8                	mov    %ebx,%eax
  801f31:	c1 e8 16             	shr    $0x16,%eax
  801f34:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801f3b:	a8 01                	test   $0x1,%al
  801f3d:	74 11                	je     801f50 <dup+0x74>
  801f3f:	89 d8                	mov    %ebx,%eax
  801f41:	c1 e8 0c             	shr    $0xc,%eax
  801f44:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  801f4b:	f6 c2 01             	test   $0x1,%dl
  801f4e:	75 39                	jne    801f89 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  801f50:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801f53:	89 d0                	mov    %edx,%eax
  801f55:	c1 e8 0c             	shr    $0xc,%eax
  801f58:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f5f:	83 ec 0c             	sub    $0xc,%esp
  801f62:	25 07 0e 00 00       	and    $0xe07,%eax
  801f67:	50                   	push   %eax
  801f68:	56                   	push   %esi
  801f69:	6a 00                	push   $0x0
  801f6b:	52                   	push   %edx
  801f6c:	6a 00                	push   $0x0
  801f6e:	e8 22 f7 ff ff       	call   801695 <sys_page_map>
  801f73:	89 c3                	mov    %eax,%ebx
  801f75:	83 c4 20             	add    $0x20,%esp
  801f78:	85 c0                	test   %eax,%eax
  801f7a:	78 31                	js     801fad <dup+0xd1>
		goto err;

	return newfdnum;
  801f7c:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801f7f:	89 d8                	mov    %ebx,%eax
  801f81:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f84:	5b                   	pop    %ebx
  801f85:	5e                   	pop    %esi
  801f86:	5f                   	pop    %edi
  801f87:	5d                   	pop    %ebp
  801f88:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  801f89:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801f90:	83 ec 0c             	sub    $0xc,%esp
  801f93:	25 07 0e 00 00       	and    $0xe07,%eax
  801f98:	50                   	push   %eax
  801f99:	57                   	push   %edi
  801f9a:	6a 00                	push   $0x0
  801f9c:	53                   	push   %ebx
  801f9d:	6a 00                	push   $0x0
  801f9f:	e8 f1 f6 ff ff       	call   801695 <sys_page_map>
  801fa4:	89 c3                	mov    %eax,%ebx
  801fa6:	83 c4 20             	add    $0x20,%esp
  801fa9:	85 c0                	test   %eax,%eax
  801fab:	79 a3                	jns    801f50 <dup+0x74>
	sys_page_unmap(0, newfd);
  801fad:	83 ec 08             	sub    $0x8,%esp
  801fb0:	56                   	push   %esi
  801fb1:	6a 00                	push   $0x0
  801fb3:	e8 1f f7 ff ff       	call   8016d7 <sys_page_unmap>
	sys_page_unmap(0, nva);
  801fb8:	83 c4 08             	add    $0x8,%esp
  801fbb:	57                   	push   %edi
  801fbc:	6a 00                	push   $0x0
  801fbe:	e8 14 f7 ff ff       	call   8016d7 <sys_page_unmap>
	return r;
  801fc3:	83 c4 10             	add    $0x10,%esp
  801fc6:	eb b7                	jmp    801f7f <dup+0xa3>

00801fc8 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  801fc8:	55                   	push   %ebp
  801fc9:	89 e5                	mov    %esp,%ebp
  801fcb:	53                   	push   %ebx
  801fcc:	83 ec 14             	sub    $0x14,%esp
  801fcf:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801fd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fd5:	50                   	push   %eax
  801fd6:	53                   	push   %ebx
  801fd7:	e8 7f fd ff ff       	call   801d5b <fd_lookup>
  801fdc:	83 c4 08             	add    $0x8,%esp
  801fdf:	85 c0                	test   %eax,%eax
  801fe1:	78 3f                	js     802022 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801fe3:	83 ec 08             	sub    $0x8,%esp
  801fe6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801fe9:	50                   	push   %eax
  801fea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fed:	ff 30                	pushl  (%eax)
  801fef:	e8 be fd ff ff       	call   801db2 <dev_lookup>
  801ff4:	83 c4 10             	add    $0x10,%esp
  801ff7:	85 c0                	test   %eax,%eax
  801ff9:	78 27                	js     802022 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801ffb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801ffe:	8b 42 08             	mov    0x8(%edx),%eax
  802001:	83 e0 03             	and    $0x3,%eax
  802004:	83 f8 01             	cmp    $0x1,%eax
  802007:	74 1e                	je     802027 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  802009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200c:	8b 40 08             	mov    0x8(%eax),%eax
  80200f:	85 c0                	test   %eax,%eax
  802011:	74 35                	je     802048 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  802013:	83 ec 04             	sub    $0x4,%esp
  802016:	ff 75 10             	pushl  0x10(%ebp)
  802019:	ff 75 0c             	pushl  0xc(%ebp)
  80201c:	52                   	push   %edx
  80201d:	ff d0                	call   *%eax
  80201f:	83 c4 10             	add    $0x10,%esp
}
  802022:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802025:	c9                   	leave  
  802026:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  802027:	a1 24 54 80 00       	mov    0x805424,%eax
  80202c:	8b 40 48             	mov    0x48(%eax),%eax
  80202f:	83 ec 04             	sub    $0x4,%esp
  802032:	53                   	push   %ebx
  802033:	50                   	push   %eax
  802034:	68 49 3a 80 00       	push   $0x803a49
  802039:	e8 5e eb ff ff       	call   800b9c <cprintf>
		return -E_INVAL;
  80203e:	83 c4 10             	add    $0x10,%esp
  802041:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  802046:	eb da                	jmp    802022 <read+0x5a>
		return -E_NOT_SUPP;
  802048:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80204d:	eb d3                	jmp    802022 <read+0x5a>

0080204f <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
  802052:	57                   	push   %edi
  802053:	56                   	push   %esi
  802054:	53                   	push   %ebx
  802055:	83 ec 0c             	sub    $0xc,%esp
  802058:	8b 7d 08             	mov    0x8(%ebp),%edi
  80205b:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80205e:	bb 00 00 00 00       	mov    $0x0,%ebx
  802063:	39 f3                	cmp    %esi,%ebx
  802065:	73 25                	jae    80208c <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  802067:	83 ec 04             	sub    $0x4,%esp
  80206a:	89 f0                	mov    %esi,%eax
  80206c:	29 d8                	sub    %ebx,%eax
  80206e:	50                   	push   %eax
  80206f:	89 d8                	mov    %ebx,%eax
  802071:	03 45 0c             	add    0xc(%ebp),%eax
  802074:	50                   	push   %eax
  802075:	57                   	push   %edi
  802076:	e8 4d ff ff ff       	call   801fc8 <read>
		if (m < 0)
  80207b:	83 c4 10             	add    $0x10,%esp
  80207e:	85 c0                	test   %eax,%eax
  802080:	78 08                	js     80208a <readn+0x3b>
			return m;
		if (m == 0)
  802082:	85 c0                	test   %eax,%eax
  802084:	74 06                	je     80208c <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  802086:	01 c3                	add    %eax,%ebx
  802088:	eb d9                	jmp    802063 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80208a:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  80208c:	89 d8                	mov    %ebx,%eax
  80208e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802091:	5b                   	pop    %ebx
  802092:	5e                   	pop    %esi
  802093:	5f                   	pop    %edi
  802094:	5d                   	pop    %ebp
  802095:	c3                   	ret    

00802096 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  802096:	55                   	push   %ebp
  802097:	89 e5                	mov    %esp,%ebp
  802099:	53                   	push   %ebx
  80209a:	83 ec 14             	sub    $0x14,%esp
  80209d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8020a0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8020a3:	50                   	push   %eax
  8020a4:	53                   	push   %ebx
  8020a5:	e8 b1 fc ff ff       	call   801d5b <fd_lookup>
  8020aa:	83 c4 08             	add    $0x8,%esp
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	78 3a                	js     8020eb <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8020b1:	83 ec 08             	sub    $0x8,%esp
  8020b4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020b7:	50                   	push   %eax
  8020b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020bb:	ff 30                	pushl  (%eax)
  8020bd:	e8 f0 fc ff ff       	call   801db2 <dev_lookup>
  8020c2:	83 c4 10             	add    $0x10,%esp
  8020c5:	85 c0                	test   %eax,%eax
  8020c7:	78 22                	js     8020eb <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8020c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020cc:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8020d0:	74 1e                	je     8020f0 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8020d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d5:	8b 52 0c             	mov    0xc(%edx),%edx
  8020d8:	85 d2                	test   %edx,%edx
  8020da:	74 35                	je     802111 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8020dc:	83 ec 04             	sub    $0x4,%esp
  8020df:	ff 75 10             	pushl  0x10(%ebp)
  8020e2:	ff 75 0c             	pushl  0xc(%ebp)
  8020e5:	50                   	push   %eax
  8020e6:	ff d2                	call   *%edx
  8020e8:	83 c4 10             	add    $0x10,%esp
}
  8020eb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8020f0:	a1 24 54 80 00       	mov    0x805424,%eax
  8020f5:	8b 40 48             	mov    0x48(%eax),%eax
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	53                   	push   %ebx
  8020fc:	50                   	push   %eax
  8020fd:	68 65 3a 80 00       	push   $0x803a65
  802102:	e8 95 ea ff ff       	call   800b9c <cprintf>
		return -E_INVAL;
  802107:	83 c4 10             	add    $0x10,%esp
  80210a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80210f:	eb da                	jmp    8020eb <write+0x55>
		return -E_NOT_SUPP;
  802111:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802116:	eb d3                	jmp    8020eb <write+0x55>

00802118 <seek>:

int
seek(int fdnum, off_t offset)
{
  802118:	55                   	push   %ebp
  802119:	89 e5                	mov    %esp,%ebp
  80211b:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80211e:	8d 45 fc             	lea    -0x4(%ebp),%eax
  802121:	50                   	push   %eax
  802122:	ff 75 08             	pushl  0x8(%ebp)
  802125:	e8 31 fc ff ff       	call   801d5b <fd_lookup>
  80212a:	83 c4 08             	add    $0x8,%esp
  80212d:	85 c0                	test   %eax,%eax
  80212f:	78 0e                	js     80213f <seek+0x27>
		return r;
	fd->fd_offset = offset;
  802131:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802134:	8b 55 0c             	mov    0xc(%ebp),%edx
  802137:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80213a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80213f:	c9                   	leave  
  802140:	c3                   	ret    

00802141 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  802141:	55                   	push   %ebp
  802142:	89 e5                	mov    %esp,%ebp
  802144:	53                   	push   %ebx
  802145:	83 ec 14             	sub    $0x14,%esp
  802148:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  80214b:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80214e:	50                   	push   %eax
  80214f:	53                   	push   %ebx
  802150:	e8 06 fc ff ff       	call   801d5b <fd_lookup>
  802155:	83 c4 08             	add    $0x8,%esp
  802158:	85 c0                	test   %eax,%eax
  80215a:	78 37                	js     802193 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80215c:	83 ec 08             	sub    $0x8,%esp
  80215f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802162:	50                   	push   %eax
  802163:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802166:	ff 30                	pushl  (%eax)
  802168:	e8 45 fc ff ff       	call   801db2 <dev_lookup>
  80216d:	83 c4 10             	add    $0x10,%esp
  802170:	85 c0                	test   %eax,%eax
  802172:	78 1f                	js     802193 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  802174:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802177:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80217b:	74 1b                	je     802198 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80217d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802180:	8b 52 18             	mov    0x18(%edx),%edx
  802183:	85 d2                	test   %edx,%edx
  802185:	74 32                	je     8021b9 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  802187:	83 ec 08             	sub    $0x8,%esp
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	ff d2                	call   *%edx
  802190:	83 c4 10             	add    $0x10,%esp
}
  802193:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802196:	c9                   	leave  
  802197:	c3                   	ret    
			thisenv->env_id, fdnum);
  802198:	a1 24 54 80 00       	mov    0x805424,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  80219d:	8b 40 48             	mov    0x48(%eax),%eax
  8021a0:	83 ec 04             	sub    $0x4,%esp
  8021a3:	53                   	push   %ebx
  8021a4:	50                   	push   %eax
  8021a5:	68 28 3a 80 00       	push   $0x803a28
  8021aa:	e8 ed e9 ff ff       	call   800b9c <cprintf>
		return -E_INVAL;
  8021af:	83 c4 10             	add    $0x10,%esp
  8021b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8021b7:	eb da                	jmp    802193 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8021b9:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8021be:	eb d3                	jmp    802193 <ftruncate+0x52>

008021c0 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	53                   	push   %ebx
  8021c4:	83 ec 14             	sub    $0x14,%esp
  8021c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8021ca:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8021cd:	50                   	push   %eax
  8021ce:	ff 75 08             	pushl  0x8(%ebp)
  8021d1:	e8 85 fb ff ff       	call   801d5b <fd_lookup>
  8021d6:	83 c4 08             	add    $0x8,%esp
  8021d9:	85 c0                	test   %eax,%eax
  8021db:	78 4b                	js     802228 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8021dd:	83 ec 08             	sub    $0x8,%esp
  8021e0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8021e3:	50                   	push   %eax
  8021e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8021e7:	ff 30                	pushl  (%eax)
  8021e9:	e8 c4 fb ff ff       	call   801db2 <dev_lookup>
  8021ee:	83 c4 10             	add    $0x10,%esp
  8021f1:	85 c0                	test   %eax,%eax
  8021f3:	78 33                	js     802228 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  8021f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f8:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  8021fc:	74 2f                	je     80222d <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  8021fe:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  802201:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  802208:	00 00 00 
	stat->st_type = 0;
  80220b:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  802212:	00 00 00 
	stat->st_dev = dev;
  802215:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  80221b:	83 ec 08             	sub    $0x8,%esp
  80221e:	53                   	push   %ebx
  80221f:	ff 75 f0             	pushl  -0x10(%ebp)
  802222:	ff 50 14             	call   *0x14(%eax)
  802225:	83 c4 10             	add    $0x10,%esp
}
  802228:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    
		return -E_NOT_SUPP;
  80222d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  802232:	eb f4                	jmp    802228 <fstat+0x68>

00802234 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
  802237:	56                   	push   %esi
  802238:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  802239:	83 ec 08             	sub    $0x8,%esp
  80223c:	6a 00                	push   $0x0
  80223e:	ff 75 08             	pushl  0x8(%ebp)
  802241:	e8 34 02 00 00       	call   80247a <open>
  802246:	89 c3                	mov    %eax,%ebx
  802248:	83 c4 10             	add    $0x10,%esp
  80224b:	85 c0                	test   %eax,%eax
  80224d:	78 1b                	js     80226a <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80224f:	83 ec 08             	sub    $0x8,%esp
  802252:	ff 75 0c             	pushl  0xc(%ebp)
  802255:	50                   	push   %eax
  802256:	e8 65 ff ff ff       	call   8021c0 <fstat>
  80225b:	89 c6                	mov    %eax,%esi
	close(fd);
  80225d:	89 1c 24             	mov    %ebx,(%esp)
  802260:	e8 29 fc ff ff       	call   801e8e <close>
	return r;
  802265:	83 c4 10             	add    $0x10,%esp
  802268:	89 f3                	mov    %esi,%ebx
}
  80226a:	89 d8                	mov    %ebx,%eax
  80226c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80226f:	5b                   	pop    %ebx
  802270:	5e                   	pop    %esi
  802271:	5d                   	pop    %ebp
  802272:	c3                   	ret    

00802273 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  802273:	55                   	push   %ebp
  802274:	89 e5                	mov    %esp,%ebp
  802276:	56                   	push   %esi
  802277:	53                   	push   %ebx
  802278:	89 c6                	mov    %eax,%esi
  80227a:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  80227c:	83 3d 20 54 80 00 00 	cmpl   $0x0,0x805420
  802283:	74 27                	je     8022ac <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  802285:	6a 07                	push   $0x7
  802287:	68 00 60 80 00       	push   $0x806000
  80228c:	56                   	push   %esi
  80228d:	ff 35 20 54 80 00    	pushl  0x805420
  802293:	e8 12 0e 00 00       	call   8030aa <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  802298:	83 c4 0c             	add    $0xc,%esp
  80229b:	6a 00                	push   $0x0
  80229d:	53                   	push   %ebx
  80229e:	6a 00                	push   $0x0
  8022a0:	e8 7c 0d 00 00       	call   803021 <ipc_recv>
}
  8022a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8022a8:	5b                   	pop    %ebx
  8022a9:	5e                   	pop    %esi
  8022aa:	5d                   	pop    %ebp
  8022ab:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8022ac:	83 ec 0c             	sub    $0xc,%esp
  8022af:	6a 01                	push   $0x1
  8022b1:	e8 50 0e 00 00       	call   803106 <ipc_find_env>
  8022b6:	a3 20 54 80 00       	mov    %eax,0x805420
  8022bb:	83 c4 10             	add    $0x10,%esp
  8022be:	eb c5                	jmp    802285 <fsipc+0x12>

008022c0 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8022c0:	55                   	push   %ebp
  8022c1:	89 e5                	mov    %esp,%ebp
  8022c3:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8022cc:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.set_size.req_size = newsize;
  8022d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022d4:	a3 04 60 80 00       	mov    %eax,0x806004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8022d9:	ba 00 00 00 00       	mov    $0x0,%edx
  8022de:	b8 02 00 00 00       	mov    $0x2,%eax
  8022e3:	e8 8b ff ff ff       	call   802273 <fsipc>
}
  8022e8:	c9                   	leave  
  8022e9:	c3                   	ret    

008022ea <devfile_flush>:
{
  8022ea:	55                   	push   %ebp
  8022eb:	89 e5                	mov    %esp,%ebp
  8022ed:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8022f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8022f6:	a3 00 60 80 00       	mov    %eax,0x806000
	return fsipc(FSREQ_FLUSH, NULL);
  8022fb:	ba 00 00 00 00       	mov    $0x0,%edx
  802300:	b8 06 00 00 00       	mov    $0x6,%eax
  802305:	e8 69 ff ff ff       	call   802273 <fsipc>
}
  80230a:	c9                   	leave  
  80230b:	c3                   	ret    

0080230c <devfile_stat>:
{
  80230c:	55                   	push   %ebp
  80230d:	89 e5                	mov    %esp,%ebp
  80230f:	53                   	push   %ebx
  802310:	83 ec 04             	sub    $0x4,%esp
  802313:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	8b 40 0c             	mov    0xc(%eax),%eax
  80231c:	a3 00 60 80 00       	mov    %eax,0x806000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  802321:	ba 00 00 00 00       	mov    $0x0,%edx
  802326:	b8 05 00 00 00       	mov    $0x5,%eax
  80232b:	e8 43 ff ff ff       	call   802273 <fsipc>
  802330:	85 c0                	test   %eax,%eax
  802332:	78 2c                	js     802360 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  802334:	83 ec 08             	sub    $0x8,%esp
  802337:	68 00 60 80 00       	push   $0x806000
  80233c:	53                   	push   %ebx
  80233d:	e8 5b ef ff ff       	call   80129d <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  802342:	a1 80 60 80 00       	mov    0x806080,%eax
  802347:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  80234d:	a1 84 60 80 00       	mov    0x806084,%eax
  802352:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  802358:	83 c4 10             	add    $0x10,%esp
  80235b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802360:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802363:	c9                   	leave  
  802364:	c3                   	ret    

00802365 <devfile_write>:
{
  802365:	55                   	push   %ebp
  802366:	89 e5                	mov    %esp,%ebp
  802368:	53                   	push   %ebx
  802369:	83 ec 04             	sub    $0x4,%esp
  80236c:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  80236f:	89 d8                	mov    %ebx,%eax
  802371:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  802377:	76 05                	jbe    80237e <devfile_write+0x19>
  802379:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  80237e:	8b 55 08             	mov    0x8(%ebp),%edx
  802381:	8b 52 0c             	mov    0xc(%edx),%edx
  802384:	89 15 00 60 80 00    	mov    %edx,0x806000
	fsipcbuf.write.req_n = size;
  80238a:	a3 04 60 80 00       	mov    %eax,0x806004
	memmove(fsipcbuf.write.req_buf, buf, size);
  80238f:	83 ec 04             	sub    $0x4,%esp
  802392:	50                   	push   %eax
  802393:	ff 75 0c             	pushl  0xc(%ebp)
  802396:	68 08 60 80 00       	push   $0x806008
  80239b:	e8 70 f0 ff ff       	call   801410 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  8023a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8023a5:	b8 04 00 00 00       	mov    $0x4,%eax
  8023aa:	e8 c4 fe ff ff       	call   802273 <fsipc>
  8023af:	83 c4 10             	add    $0x10,%esp
  8023b2:	85 c0                	test   %eax,%eax
  8023b4:	78 0b                	js     8023c1 <devfile_write+0x5c>
	assert(r <= n);
  8023b6:	39 c3                	cmp    %eax,%ebx
  8023b8:	72 0c                	jb     8023c6 <devfile_write+0x61>
	assert(r <= PGSIZE);
  8023ba:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8023bf:	7f 1e                	jg     8023df <devfile_write+0x7a>
}
  8023c1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023c4:	c9                   	leave  
  8023c5:	c3                   	ret    
	assert(r <= n);
  8023c6:	68 94 3a 80 00       	push   $0x803a94
  8023cb:	68 1a 35 80 00       	push   $0x80351a
  8023d0:	68 98 00 00 00       	push   $0x98
  8023d5:	68 9b 3a 80 00       	push   $0x803a9b
  8023da:	e8 aa e6 ff ff       	call   800a89 <_panic>
	assert(r <= PGSIZE);
  8023df:	68 a6 3a 80 00       	push   $0x803aa6
  8023e4:	68 1a 35 80 00       	push   $0x80351a
  8023e9:	68 99 00 00 00       	push   $0x99
  8023ee:	68 9b 3a 80 00       	push   $0x803a9b
  8023f3:	e8 91 e6 ff ff       	call   800a89 <_panic>

008023f8 <devfile_read>:
{
  8023f8:	55                   	push   %ebp
  8023f9:	89 e5                	mov    %esp,%ebp
  8023fb:	56                   	push   %esi
  8023fc:	53                   	push   %ebx
  8023fd:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  802400:	8b 45 08             	mov    0x8(%ebp),%eax
  802403:	8b 40 0c             	mov    0xc(%eax),%eax
  802406:	a3 00 60 80 00       	mov    %eax,0x806000
	fsipcbuf.read.req_n = n;
  80240b:	89 35 04 60 80 00    	mov    %esi,0x806004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  802411:	ba 00 00 00 00       	mov    $0x0,%edx
  802416:	b8 03 00 00 00       	mov    $0x3,%eax
  80241b:	e8 53 fe ff ff       	call   802273 <fsipc>
  802420:	89 c3                	mov    %eax,%ebx
  802422:	85 c0                	test   %eax,%eax
  802424:	78 1f                	js     802445 <devfile_read+0x4d>
	assert(r <= n);
  802426:	39 c6                	cmp    %eax,%esi
  802428:	72 24                	jb     80244e <devfile_read+0x56>
	assert(r <= PGSIZE);
  80242a:	3d 00 10 00 00       	cmp    $0x1000,%eax
  80242f:	7f 33                	jg     802464 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  802431:	83 ec 04             	sub    $0x4,%esp
  802434:	50                   	push   %eax
  802435:	68 00 60 80 00       	push   $0x806000
  80243a:	ff 75 0c             	pushl  0xc(%ebp)
  80243d:	e8 ce ef ff ff       	call   801410 <memmove>
	return r;
  802442:	83 c4 10             	add    $0x10,%esp
}
  802445:	89 d8                	mov    %ebx,%eax
  802447:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80244a:	5b                   	pop    %ebx
  80244b:	5e                   	pop    %esi
  80244c:	5d                   	pop    %ebp
  80244d:	c3                   	ret    
	assert(r <= n);
  80244e:	68 94 3a 80 00       	push   $0x803a94
  802453:	68 1a 35 80 00       	push   $0x80351a
  802458:	6a 7c                	push   $0x7c
  80245a:	68 9b 3a 80 00       	push   $0x803a9b
  80245f:	e8 25 e6 ff ff       	call   800a89 <_panic>
	assert(r <= PGSIZE);
  802464:	68 a6 3a 80 00       	push   $0x803aa6
  802469:	68 1a 35 80 00       	push   $0x80351a
  80246e:	6a 7d                	push   $0x7d
  802470:	68 9b 3a 80 00       	push   $0x803a9b
  802475:	e8 0f e6 ff ff       	call   800a89 <_panic>

0080247a <open>:
{
  80247a:	55                   	push   %ebp
  80247b:	89 e5                	mov    %esp,%ebp
  80247d:	56                   	push   %esi
  80247e:	53                   	push   %ebx
  80247f:	83 ec 1c             	sub    $0x1c,%esp
  802482:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  802485:	56                   	push   %esi
  802486:	e8 df ed ff ff       	call   80126a <strlen>
  80248b:	83 c4 10             	add    $0x10,%esp
  80248e:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  802493:	7f 6c                	jg     802501 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  802495:	83 ec 0c             	sub    $0xc,%esp
  802498:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80249b:	50                   	push   %eax
  80249c:	e8 6b f8 ff ff       	call   801d0c <fd_alloc>
  8024a1:	89 c3                	mov    %eax,%ebx
  8024a3:	83 c4 10             	add    $0x10,%esp
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	78 3c                	js     8024e6 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  8024aa:	83 ec 08             	sub    $0x8,%esp
  8024ad:	56                   	push   %esi
  8024ae:	68 00 60 80 00       	push   $0x806000
  8024b3:	e8 e5 ed ff ff       	call   80129d <strcpy>
	fsipcbuf.open.req_omode = mode;
  8024b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8024bb:	a3 00 64 80 00       	mov    %eax,0x806400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  8024c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c8:	e8 a6 fd ff ff       	call   802273 <fsipc>
  8024cd:	89 c3                	mov    %eax,%ebx
  8024cf:	83 c4 10             	add    $0x10,%esp
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	78 19                	js     8024ef <open+0x75>
	return fd2num(fd);
  8024d6:	83 ec 0c             	sub    $0xc,%esp
  8024d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8024dc:	e8 04 f8 ff ff       	call   801ce5 <fd2num>
  8024e1:	89 c3                	mov    %eax,%ebx
  8024e3:	83 c4 10             	add    $0x10,%esp
}
  8024e6:	89 d8                	mov    %ebx,%eax
  8024e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8024eb:	5b                   	pop    %ebx
  8024ec:	5e                   	pop    %esi
  8024ed:	5d                   	pop    %ebp
  8024ee:	c3                   	ret    
		fd_close(fd, 0);
  8024ef:	83 ec 08             	sub    $0x8,%esp
  8024f2:	6a 00                	push   $0x0
  8024f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8024f7:	e8 0c f9 ff ff       	call   801e08 <fd_close>
		return r;
  8024fc:	83 c4 10             	add    $0x10,%esp
  8024ff:	eb e5                	jmp    8024e6 <open+0x6c>
		return -E_BAD_PATH;
  802501:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  802506:	eb de                	jmp    8024e6 <open+0x6c>

00802508 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  80250e:	ba 00 00 00 00       	mov    $0x0,%edx
  802513:	b8 08 00 00 00       	mov    $0x8,%eax
  802518:	e8 56 fd ff ff       	call   802273 <fsipc>
}
  80251d:	c9                   	leave  
  80251e:	c3                   	ret    

0080251f <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  80251f:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  802523:	7e 38                	jle    80255d <writebuf+0x3e>
{
  802525:	55                   	push   %ebp
  802526:	89 e5                	mov    %esp,%ebp
  802528:	53                   	push   %ebx
  802529:	83 ec 08             	sub    $0x8,%esp
  80252c:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  80252e:	ff 70 04             	pushl  0x4(%eax)
  802531:	8d 40 10             	lea    0x10(%eax),%eax
  802534:	50                   	push   %eax
  802535:	ff 33                	pushl  (%ebx)
  802537:	e8 5a fb ff ff       	call   802096 <write>
		if (result > 0)
  80253c:	83 c4 10             	add    $0x10,%esp
  80253f:	85 c0                	test   %eax,%eax
  802541:	7e 03                	jle    802546 <writebuf+0x27>
			b->result += result;
  802543:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  802546:	3b 43 04             	cmp    0x4(%ebx),%eax
  802549:	74 0e                	je     802559 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  80254b:	89 c2                	mov    %eax,%edx
  80254d:	85 c0                	test   %eax,%eax
  80254f:	7e 05                	jle    802556 <writebuf+0x37>
  802551:	ba 00 00 00 00       	mov    $0x0,%edx
  802556:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  802559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80255c:	c9                   	leave  
  80255d:	c3                   	ret    

0080255e <putch>:

static void
putch(int ch, void *thunk)
{
  80255e:	55                   	push   %ebp
  80255f:	89 e5                	mov    %esp,%ebp
  802561:	53                   	push   %ebx
  802562:	83 ec 04             	sub    $0x4,%esp
  802565:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  802568:	8b 53 04             	mov    0x4(%ebx),%edx
  80256b:	8d 42 01             	lea    0x1(%edx),%eax
  80256e:	89 43 04             	mov    %eax,0x4(%ebx)
  802571:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802574:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  802578:	3d 00 01 00 00       	cmp    $0x100,%eax
  80257d:	74 06                	je     802585 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  80257f:	83 c4 04             	add    $0x4,%esp
  802582:	5b                   	pop    %ebx
  802583:	5d                   	pop    %ebp
  802584:	c3                   	ret    
		writebuf(b);
  802585:	89 d8                	mov    %ebx,%eax
  802587:	e8 93 ff ff ff       	call   80251f <writebuf>
		b->idx = 0;
  80258c:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  802593:	eb ea                	jmp    80257f <putch+0x21>

00802595 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  80259e:	8b 45 08             	mov    0x8(%ebp),%eax
  8025a1:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  8025a7:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  8025ae:	00 00 00 
	b.result = 0;
  8025b1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8025b8:	00 00 00 
	b.error = 1;
  8025bb:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  8025c2:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  8025c5:	ff 75 10             	pushl  0x10(%ebp)
  8025c8:	ff 75 0c             	pushl  0xc(%ebp)
  8025cb:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025d1:	50                   	push   %eax
  8025d2:	68 5e 25 80 00       	push   $0x80255e
  8025d7:	e8 ba e6 ff ff       	call   800c96 <vprintfmt>
	if (b.idx > 0)
  8025dc:	83 c4 10             	add    $0x10,%esp
  8025df:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  8025e6:	7e 0b                	jle    8025f3 <vfprintf+0x5e>
		writebuf(&b);
  8025e8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  8025ee:	e8 2c ff ff ff       	call   80251f <writebuf>

	return (b.result ? b.result : b.error);
  8025f3:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  8025f9:	85 c0                	test   %eax,%eax
  8025fb:	75 06                	jne    802603 <vfprintf+0x6e>
  8025fd:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  802603:	c9                   	leave  
  802604:	c3                   	ret    

00802605 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  802605:	55                   	push   %ebp
  802606:	89 e5                	mov    %esp,%ebp
  802608:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80260b:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  80260e:	50                   	push   %eax
  80260f:	ff 75 0c             	pushl  0xc(%ebp)
  802612:	ff 75 08             	pushl  0x8(%ebp)
  802615:	e8 7b ff ff ff       	call   802595 <vfprintf>
	va_end(ap);

	return cnt;
}
  80261a:	c9                   	leave  
  80261b:	c3                   	ret    

0080261c <printf>:

int
printf(const char *fmt, ...)
{
  80261c:	55                   	push   %ebp
  80261d:	89 e5                	mov    %esp,%ebp
  80261f:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  802622:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  802625:	50                   	push   %eax
  802626:	ff 75 08             	pushl  0x8(%ebp)
  802629:	6a 01                	push   $0x1
  80262b:	e8 65 ff ff ff       	call   802595 <vfprintf>
	va_end(ap);

	return cnt;
}
  802630:	c9                   	leave  
  802631:	c3                   	ret    

00802632 <spawn>:
// argv: pointer to null-terminated array of pointers to strings,
// 	 which will be passed to the child as its command-line arguments.
// Returns child envid on success, < 0 on failure.
int
spawn(const char *prog, const char **argv)
{
  802632:	55                   	push   %ebp
  802633:	89 e5                	mov    %esp,%ebp
  802635:	57                   	push   %edi
  802636:	56                   	push   %esi
  802637:	53                   	push   %ebx
  802638:	81 ec 94 02 00 00    	sub    $0x294,%esp
  80263e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	//   - Call sys_env_set_trapframe(child, &child_tf) to set up the
	//     correct initial eip and esp values in the child.
	//
	//   - Start the child process running with sys_env_set_status().

	if ((r = open(prog, O_RDONLY)) < 0)
  802641:	6a 00                	push   $0x0
  802643:	ff 75 08             	pushl  0x8(%ebp)
  802646:	e8 2f fe ff ff       	call   80247a <open>
  80264b:	89 c1                	mov    %eax,%ecx
  80264d:	89 85 8c fd ff ff    	mov    %eax,-0x274(%ebp)
  802653:	83 c4 10             	add    $0x10,%esp
  802656:	85 c0                	test   %eax,%eax
  802658:	0f 88 ba 04 00 00    	js     802b18 <spawn+0x4e6>
		return r;
	fd = r;

	// Read elf header
	elf = (struct Elf*) elf_buf;
	if (readn(fd, elf_buf, sizeof(elf_buf)) != sizeof(elf_buf)
  80265e:	83 ec 04             	sub    $0x4,%esp
  802661:	68 00 02 00 00       	push   $0x200
  802666:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
  80266c:	50                   	push   %eax
  80266d:	51                   	push   %ecx
  80266e:	e8 dc f9 ff ff       	call   80204f <readn>
  802673:	83 c4 10             	add    $0x10,%esp
  802676:	3d 00 02 00 00       	cmp    $0x200,%eax
  80267b:	0f 85 93 00 00 00    	jne    802714 <spawn+0xe2>
	    || elf->e_magic != ELF_MAGIC) {
  802681:	81 bd e8 fd ff ff 7f 	cmpl   $0x464c457f,-0x218(%ebp)
  802688:	45 4c 46 
  80268b:	0f 85 83 00 00 00    	jne    802714 <spawn+0xe2>
  802691:	b8 07 00 00 00       	mov    $0x7,%eax
  802696:	cd 30                	int    $0x30
  802698:	89 85 74 fd ff ff    	mov    %eax,-0x28c(%ebp)
  80269e:	89 85 84 fd ff ff    	mov    %eax,-0x27c(%ebp)
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
		return -E_NOT_EXEC;
	}

	// Create new child environment
	if ((r = sys_exofork()) < 0)
  8026a4:	85 c0                	test   %eax,%eax
  8026a6:	0f 88 77 04 00 00    	js     802b23 <spawn+0x4f1>
		return r;
	child = r;

	// Set up trap frame, including initial stack.
	child_tf = envs[ENVX(child)].env_tf;
  8026ac:	89 c2                	mov    %eax,%edx
  8026ae:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  8026b4:	89 d0                	mov    %edx,%eax
  8026b6:	c1 e0 05             	shl    $0x5,%eax
  8026b9:	29 d0                	sub    %edx,%eax
  8026bb:	8d 34 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%esi
  8026c2:	8d bd a4 fd ff ff    	lea    -0x25c(%ebp),%edi
  8026c8:	b9 11 00 00 00       	mov    $0x11,%ecx
  8026cd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	child_tf.tf_eip = elf->e_entry;
  8026cf:	8b 85 00 fe ff ff    	mov    -0x200(%ebp),%eax
  8026d5:	89 85 d4 fd ff ff    	mov    %eax,-0x22c(%ebp)
  8026db:	ba 00 00 00 00       	mov    $0x0,%edx
	uintptr_t *argv_store;

	// Count the number of arguments (argc)
	// and the total amount of space needed for strings (string_size).
	string_size = 0;
	for (argc = 0; argv[argc] != 0; argc++)
  8026e0:	b8 00 00 00 00       	mov    $0x0,%eax
	string_size = 0;
  8026e5:	bf 00 00 00 00       	mov    $0x0,%edi
  8026ea:	89 5d 0c             	mov    %ebx,0xc(%ebp)
  8026ed:	89 c3                	mov    %eax,%ebx
	for (argc = 0; argv[argc] != 0; argc++)
  8026ef:	89 d9                	mov    %ebx,%ecx
  8026f1:	8d 72 04             	lea    0x4(%edx),%esi
  8026f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8026f7:	8b 44 30 fc          	mov    -0x4(%eax,%esi,1),%eax
  8026fb:	85 c0                	test   %eax,%eax
  8026fd:	74 48                	je     802747 <spawn+0x115>
		string_size += strlen(argv[argc]) + 1;
  8026ff:	83 ec 0c             	sub    $0xc,%esp
  802702:	50                   	push   %eax
  802703:	e8 62 eb ff ff       	call   80126a <strlen>
  802708:	8d 7c 38 01          	lea    0x1(%eax,%edi,1),%edi
	for (argc = 0; argv[argc] != 0; argc++)
  80270c:	43                   	inc    %ebx
  80270d:	83 c4 10             	add    $0x10,%esp
  802710:	89 f2                	mov    %esi,%edx
  802712:	eb db                	jmp    8026ef <spawn+0xbd>
		close(fd);
  802714:	83 ec 0c             	sub    $0xc,%esp
  802717:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  80271d:	e8 6c f7 ff ff       	call   801e8e <close>
		cprintf("elf magic %08x want %08x\n", elf->e_magic, ELF_MAGIC);
  802722:	83 c4 0c             	add    $0xc,%esp
  802725:	68 7f 45 4c 46       	push   $0x464c457f
  80272a:	ff b5 e8 fd ff ff    	pushl  -0x218(%ebp)
  802730:	68 b2 3a 80 00       	push   $0x803ab2
  802735:	e8 62 e4 ff ff       	call   800b9c <cprintf>
		return -E_NOT_EXEC;
  80273a:	83 c4 10             	add    $0x10,%esp
  80273d:	bf f2 ff ff ff       	mov    $0xfffffff2,%edi
  802742:	e9 62 02 00 00       	jmp    8029a9 <spawn+0x377>
  802747:	89 9d 90 fd ff ff    	mov    %ebx,-0x270(%ebp)
  80274d:	89 9d 88 fd ff ff    	mov    %ebx,-0x278(%ebp)
  802753:	89 95 80 fd ff ff    	mov    %edx,-0x280(%ebp)
  802759:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	// Determine where to place the strings and the argv array.
	// Set up pointers into the temporary page 'UTEMP'; we'll map a page
	// there later, then remap that page into the child environment
	// at (USTACKTOP - PGSIZE).
	// strings is the topmost thing on the stack.
	string_store = (char*) UTEMP + PGSIZE - string_size;
  80275c:	be 00 10 40 00       	mov    $0x401000,%esi
  802761:	29 fe                	sub    %edi,%esi
	// argv is below that.  There's one argument pointer per argument, plus
	// a null pointer.
	argv_store = (uintptr_t*) (ROUNDDOWN(string_store, 4) - 4 * (argc + 1));
  802763:	89 f2                	mov    %esi,%edx
  802765:	83 e2 fc             	and    $0xfffffffc,%edx
  802768:	8d 04 8d 04 00 00 00 	lea    0x4(,%ecx,4),%eax
  80276f:	29 c2                	sub    %eax,%edx
  802771:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)

	// Make sure that argv, strings, and the 2 words that hold 'argc'
	// and 'argv' themselves will all fit in a single stack page.
	if ((void*) (argv_store - 2) < (void*) UTEMP)
  802777:	8d 42 f8             	lea    -0x8(%edx),%eax
  80277a:	3d ff ff 3f 00       	cmp    $0x3fffff,%eax
  80277f:	0f 86 a9 03 00 00    	jbe    802b2e <spawn+0x4fc>
		return -E_NO_MEM;

	// Allocate the single stack page at UTEMP.
	if ((r = sys_page_alloc(0, (void*) UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  802785:	83 ec 04             	sub    $0x4,%esp
  802788:	6a 07                	push   $0x7
  80278a:	68 00 00 40 00       	push   $0x400000
  80278f:	6a 00                	push   $0x0
  802791:	e8 bc ee ff ff       	call   801652 <sys_page_alloc>
  802796:	89 c7                	mov    %eax,%edi
  802798:	83 c4 10             	add    $0x10,%esp
  80279b:	85 c0                	test   %eax,%eax
  80279d:	0f 88 06 02 00 00    	js     8029a9 <spawn+0x377>
  8027a3:	bf 00 00 00 00       	mov    $0x0,%edi
	//	  (Again, argv should use an address valid in the child's
	//	  environment.)
	//
	//	* Set *init_esp to the initial stack pointer for the child,
	//	  (Again, use an address valid in the child's environment.)
	for (i = 0; i < argc; i++) {
  8027a8:	39 bd 90 fd ff ff    	cmp    %edi,-0x270(%ebp)
  8027ae:	7e 30                	jle    8027e0 <spawn+0x1ae>
		argv_store[i] = UTEMP2USTACK(string_store);
  8027b0:	8d 86 00 d0 7f ee    	lea    -0x11803000(%esi),%eax
  8027b6:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  8027bc:	89 04 b9             	mov    %eax,(%ecx,%edi,4)
		strcpy(string_store, argv[i]);
  8027bf:	83 ec 08             	sub    $0x8,%esp
  8027c2:	ff 34 bb             	pushl  (%ebx,%edi,4)
  8027c5:	56                   	push   %esi
  8027c6:	e8 d2 ea ff ff       	call   80129d <strcpy>
		string_store += strlen(argv[i]) + 1;
  8027cb:	83 c4 04             	add    $0x4,%esp
  8027ce:	ff 34 bb             	pushl  (%ebx,%edi,4)
  8027d1:	e8 94 ea ff ff       	call   80126a <strlen>
  8027d6:	8d 74 06 01          	lea    0x1(%esi,%eax,1),%esi
	for (i = 0; i < argc; i++) {
  8027da:	47                   	inc    %edi
  8027db:	83 c4 10             	add    $0x10,%esp
  8027de:	eb c8                	jmp    8027a8 <spawn+0x176>
	}
	argv_store[argc] = 0;
  8027e0:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8027e6:	8b 8d 80 fd ff ff    	mov    -0x280(%ebp),%ecx
  8027ec:	c7 04 08 00 00 00 00 	movl   $0x0,(%eax,%ecx,1)
	assert(string_store == (char*)UTEMP + PGSIZE);
  8027f3:	81 fe 00 10 40 00    	cmp    $0x401000,%esi
  8027f9:	0f 85 8c 00 00 00    	jne    80288b <spawn+0x259>

	argv_store[-1] = UTEMP2USTACK(argv_store);
  8027ff:	8b 8d 94 fd ff ff    	mov    -0x26c(%ebp),%ecx
  802805:	89 c8                	mov    %ecx,%eax
  802807:	2d 00 30 80 11       	sub    $0x11803000,%eax
  80280c:	89 41 fc             	mov    %eax,-0x4(%ecx)
	argv_store[-2] = argc;
  80280f:	8b 85 88 fd ff ff    	mov    -0x278(%ebp),%eax
  802815:	89 41 f8             	mov    %eax,-0x8(%ecx)

	*init_esp = UTEMP2USTACK(&argv_store[-2]);
  802818:	8d 81 f8 cf 7f ee    	lea    -0x11803008(%ecx),%eax
  80281e:	89 85 e0 fd ff ff    	mov    %eax,-0x220(%ebp)

	// After completing the stack, map it into the child's address space
	// and unmap it from ours!
	if ((r = sys_page_map(0, UTEMP, child, (void*) (USTACKTOP - PGSIZE), PTE_P | PTE_U | PTE_W)) < 0)
  802824:	83 ec 0c             	sub    $0xc,%esp
  802827:	6a 07                	push   $0x7
  802829:	68 00 d0 bf ee       	push   $0xeebfd000
  80282e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802834:	68 00 00 40 00       	push   $0x400000
  802839:	6a 00                	push   $0x0
  80283b:	e8 55 ee ff ff       	call   801695 <sys_page_map>
  802840:	89 c7                	mov    %eax,%edi
  802842:	83 c4 20             	add    $0x20,%esp
  802845:	85 c0                	test   %eax,%eax
  802847:	0f 88 3e 03 00 00    	js     802b8b <spawn+0x559>
		goto error;
	if ((r = sys_page_unmap(0, UTEMP)) < 0)
  80284d:	83 ec 08             	sub    $0x8,%esp
  802850:	68 00 00 40 00       	push   $0x400000
  802855:	6a 00                	push   $0x0
  802857:	e8 7b ee ff ff       	call   8016d7 <sys_page_unmap>
  80285c:	89 c7                	mov    %eax,%edi
  80285e:	83 c4 10             	add    $0x10,%esp
  802861:	85 c0                	test   %eax,%eax
  802863:	0f 88 22 03 00 00    	js     802b8b <spawn+0x559>
	ph = (struct Proghdr*) (elf_buf + elf->e_phoff);
  802869:	8b 85 04 fe ff ff    	mov    -0x1fc(%ebp),%eax
  80286f:	8d 84 05 e8 fd ff ff 	lea    -0x218(%ebp,%eax,1),%eax
  802876:	89 85 7c fd ff ff    	mov    %eax,-0x284(%ebp)
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  80287c:	c7 85 78 fd ff ff 00 	movl   $0x0,-0x288(%ebp)
  802883:	00 00 00 
  802886:	e9 4a 01 00 00       	jmp    8029d5 <spawn+0x3a3>
	assert(string_store == (char*)UTEMP + PGSIZE);
  80288b:	68 3c 3b 80 00       	push   $0x803b3c
  802890:	68 1a 35 80 00       	push   $0x80351a
  802895:	68 f1 00 00 00       	push   $0xf1
  80289a:	68 cc 3a 80 00       	push   $0x803acc
  80289f:	e8 e5 e1 ff ff       	call   800a89 <_panic>
			// allocate a blank page
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
				return r;
		} else {
			// from file
			if ((r = sys_page_alloc(0, UTEMP, PTE_P|PTE_U|PTE_W)) < 0)
  8028a4:	83 ec 04             	sub    $0x4,%esp
  8028a7:	6a 07                	push   $0x7
  8028a9:	68 00 00 40 00       	push   $0x400000
  8028ae:	6a 00                	push   $0x0
  8028b0:	e8 9d ed ff ff       	call   801652 <sys_page_alloc>
  8028b5:	83 c4 10             	add    $0x10,%esp
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	0f 88 78 02 00 00    	js     802b38 <spawn+0x506>
				return r;
			if ((r = seek(fd, fileoffset + i)) < 0)
  8028c0:	83 ec 08             	sub    $0x8,%esp
  8028c3:	8b 85 80 fd ff ff    	mov    -0x280(%ebp),%eax
  8028c9:	01 f8                	add    %edi,%eax
  8028cb:	50                   	push   %eax
  8028cc:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8028d2:	e8 41 f8 ff ff       	call   802118 <seek>
  8028d7:	83 c4 10             	add    $0x10,%esp
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	0f 88 5d 02 00 00    	js     802b3f <spawn+0x50d>
				return r;
			if ((r = readn(fd, UTEMP, MIN(PGSIZE, filesz-i))) < 0)
  8028e2:	83 ec 04             	sub    $0x4,%esp
  8028e5:	8b 85 94 fd ff ff    	mov    -0x26c(%ebp),%eax
  8028eb:	29 f8                	sub    %edi,%eax
  8028ed:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8028f2:	76 05                	jbe    8028f9 <spawn+0x2c7>
  8028f4:	b8 00 10 00 00       	mov    $0x1000,%eax
  8028f9:	50                   	push   %eax
  8028fa:	68 00 00 40 00       	push   $0x400000
  8028ff:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802905:	e8 45 f7 ff ff       	call   80204f <readn>
  80290a:	83 c4 10             	add    $0x10,%esp
  80290d:	85 c0                	test   %eax,%eax
  80290f:	0f 88 31 02 00 00    	js     802b46 <spawn+0x514>
				return r;
			if ((r = sys_page_map(0, UTEMP, child, (void*) (va + i), perm)) < 0)
  802915:	83 ec 0c             	sub    $0xc,%esp
  802918:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  80291e:	56                   	push   %esi
  80291f:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  802925:	68 00 00 40 00       	push   $0x400000
  80292a:	6a 00                	push   $0x0
  80292c:	e8 64 ed ff ff       	call   801695 <sys_page_map>
  802931:	83 c4 20             	add    $0x20,%esp
  802934:	85 c0                	test   %eax,%eax
  802936:	78 7b                	js     8029b3 <spawn+0x381>
				panic("spawn: sys_page_map data: %e", r);
			sys_page_unmap(0, UTEMP);
  802938:	83 ec 08             	sub    $0x8,%esp
  80293b:	68 00 00 40 00       	push   $0x400000
  802940:	6a 00                	push   $0x0
  802942:	e8 90 ed ff ff       	call   8016d7 <sys_page_unmap>
  802947:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < memsz; i += PGSIZE) {
  80294a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802950:	81 c6 00 10 00 00    	add    $0x1000,%esi
  802956:	89 df                	mov    %ebx,%edi
  802958:	3b 9d 90 fd ff ff    	cmp    -0x270(%ebp),%ebx
  80295e:	73 68                	jae    8029c8 <spawn+0x396>
		if (i >= filesz) {
  802960:	3b 9d 94 fd ff ff    	cmp    -0x26c(%ebp),%ebx
  802966:	0f 82 38 ff ff ff    	jb     8028a4 <spawn+0x272>
			if ((r = sys_page_alloc(child, (void*) (va + i), perm)) < 0)
  80296c:	83 ec 04             	sub    $0x4,%esp
  80296f:	ff b5 88 fd ff ff    	pushl  -0x278(%ebp)
  802975:	56                   	push   %esi
  802976:	ff b5 84 fd ff ff    	pushl  -0x27c(%ebp)
  80297c:	e8 d1 ec ff ff       	call   801652 <sys_page_alloc>
  802981:	83 c4 10             	add    $0x10,%esp
  802984:	85 c0                	test   %eax,%eax
  802986:	79 c2                	jns    80294a <spawn+0x318>
  802988:	89 c7                	mov    %eax,%edi
	sys_env_destroy(child);
  80298a:	83 ec 0c             	sub    $0xc,%esp
  80298d:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802993:	e8 5a ec ff ff       	call   8015f2 <sys_env_destroy>
	close(fd);
  802998:	83 c4 04             	add    $0x4,%esp
  80299b:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  8029a1:	e8 e8 f4 ff ff       	call   801e8e <close>
	return r;
  8029a6:	83 c4 10             	add    $0x10,%esp
}
  8029a9:	89 f8                	mov    %edi,%eax
  8029ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8029ae:	5b                   	pop    %ebx
  8029af:	5e                   	pop    %esi
  8029b0:	5f                   	pop    %edi
  8029b1:	5d                   	pop    %ebp
  8029b2:	c3                   	ret    
				panic("spawn: sys_page_map data: %e", r);
  8029b3:	50                   	push   %eax
  8029b4:	68 d8 3a 80 00       	push   $0x803ad8
  8029b9:	68 24 01 00 00       	push   $0x124
  8029be:	68 cc 3a 80 00       	push   $0x803acc
  8029c3:	e8 c1 e0 ff ff       	call   800a89 <_panic>
	for (i = 0; i < elf->e_phnum; i++, ph++) {
  8029c8:	ff 85 78 fd ff ff    	incl   -0x288(%ebp)
  8029ce:	83 85 7c fd ff ff 20 	addl   $0x20,-0x284(%ebp)
  8029d5:	0f b7 85 14 fe ff ff 	movzwl -0x1ec(%ebp),%eax
  8029dc:	39 85 78 fd ff ff    	cmp    %eax,-0x288(%ebp)
  8029e2:	7d 71                	jge    802a55 <spawn+0x423>
		if (ph->p_type != ELF_PROG_LOAD)
  8029e4:	8b 85 7c fd ff ff    	mov    -0x284(%ebp),%eax
  8029ea:	83 38 01             	cmpl   $0x1,(%eax)
  8029ed:	75 d9                	jne    8029c8 <spawn+0x396>
		if (ph->p_flags & ELF_PROG_FLAG_WRITE)
  8029ef:	89 c1                	mov    %eax,%ecx
  8029f1:	8b 40 18             	mov    0x18(%eax),%eax
  8029f4:	83 e0 02             	and    $0x2,%eax
			perm |= PTE_W;
  8029f7:	83 f8 01             	cmp    $0x1,%eax
  8029fa:	19 c0                	sbb    %eax,%eax
  8029fc:	83 e0 fe             	and    $0xfffffffe,%eax
  8029ff:	83 c0 07             	add    $0x7,%eax
  802a02:	89 85 88 fd ff ff    	mov    %eax,-0x278(%ebp)
		if ((r = map_segment(child, ph->p_va, ph->p_memsz,
  802a08:	89 c8                	mov    %ecx,%eax
  802a0a:	8b 49 04             	mov    0x4(%ecx),%ecx
  802a0d:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
  802a13:	8b 50 10             	mov    0x10(%eax),%edx
  802a16:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
  802a1c:	8b 78 14             	mov    0x14(%eax),%edi
  802a1f:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
  802a25:	8b 70 08             	mov    0x8(%eax),%esi
	if ((i = PGOFF(va))) {
  802a28:	89 f0                	mov    %esi,%eax
  802a2a:	25 ff 0f 00 00       	and    $0xfff,%eax
  802a2f:	74 1a                	je     802a4b <spawn+0x419>
		va -= i;
  802a31:	29 c6                	sub    %eax,%esi
		memsz += i;
  802a33:	01 c7                	add    %eax,%edi
  802a35:	89 bd 90 fd ff ff    	mov    %edi,-0x270(%ebp)
		filesz += i;
  802a3b:	01 c2                	add    %eax,%edx
  802a3d:	89 95 94 fd ff ff    	mov    %edx,-0x26c(%ebp)
		fileoffset -= i;
  802a43:	29 c1                	sub    %eax,%ecx
  802a45:	89 8d 80 fd ff ff    	mov    %ecx,-0x280(%ebp)
	for (i = 0; i < memsz; i += PGSIZE) {
  802a4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a50:	e9 01 ff ff ff       	jmp    802956 <spawn+0x324>
	close(fd);
  802a55:	83 ec 0c             	sub    $0xc,%esp
  802a58:	ff b5 8c fd ff ff    	pushl  -0x274(%ebp)
  802a5e:	e8 2b f4 ff ff       	call   801e8e <close>
  802a63:	83 c4 10             	add    $0x10,%esp
// Copy the mappings for shared pages into the child address space.
static int
copy_shared_pages(envid_t child)
{
	// LAB 5: Your code here.
	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
  802a66:	bb 00 00 00 00       	mov    $0x0,%ebx
  802a6b:	8b b5 84 fd ff ff    	mov    -0x27c(%ebp),%esi
  802a71:	eb 12                	jmp    802a85 <spawn+0x453>
  802a73:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  802a79:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
  802a7f:	0f 84 c8 00 00 00    	je     802b4d <spawn+0x51b>
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U) && (uvpt[PGNUM(pn)] & PTE_SHARE)) {
  802a85:	89 d8                	mov    %ebx,%eax
  802a87:	c1 e8 16             	shr    $0x16,%eax
  802a8a:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802a91:	a8 01                	test   $0x1,%al
  802a93:	74 de                	je     802a73 <spawn+0x441>
  802a95:	89 d8                	mov    %ebx,%eax
  802a97:	c1 e8 0c             	shr    $0xc,%eax
  802a9a:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802aa1:	f6 c2 04             	test   $0x4,%dl
  802aa4:	74 cd                	je     802a73 <spawn+0x441>
  802aa6:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  802aad:	f6 c6 04             	test   $0x4,%dh
  802ab0:	74 c1                	je     802a73 <spawn+0x441>
			if (sys_page_map(sys_getenvid(), (void*)(pn), child, (void*)(pn), uvpt[PGNUM(pn)] & PTE_SYSCALL) < 0) {
  802ab2:	8b 3c 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edi
  802ab9:	e8 75 eb ff ff       	call   801633 <sys_getenvid>
  802abe:	83 ec 0c             	sub    $0xc,%esp
  802ac1:	81 e7 07 0e 00 00    	and    $0xe07,%edi
  802ac7:	57                   	push   %edi
  802ac8:	53                   	push   %ebx
  802ac9:	56                   	push   %esi
  802aca:	53                   	push   %ebx
  802acb:	50                   	push   %eax
  802acc:	e8 c4 eb ff ff       	call   801695 <sys_page_map>
  802ad1:	83 c4 20             	add    $0x20,%esp
  802ad4:	85 c0                	test   %eax,%eax
  802ad6:	79 9b                	jns    802a73 <spawn+0x441>
		panic("copy_shared_pages: %e", r);
  802ad8:	6a ff                	push   $0xffffffff
  802ada:	68 26 3b 80 00       	push   $0x803b26
  802adf:	68 82 00 00 00       	push   $0x82
  802ae4:	68 cc 3a 80 00       	push   $0x803acc
  802ae9:	e8 9b df ff ff       	call   800a89 <_panic>
		panic("sys_env_set_trapframe: %e", r);
  802aee:	50                   	push   %eax
  802aef:	68 f5 3a 80 00       	push   $0x803af5
  802af4:	68 85 00 00 00       	push   $0x85
  802af9:	68 cc 3a 80 00       	push   $0x803acc
  802afe:	e8 86 df ff ff       	call   800a89 <_panic>
		panic("sys_env_set_status: %e", r);
  802b03:	50                   	push   %eax
  802b04:	68 0f 3b 80 00       	push   $0x803b0f
  802b09:	68 88 00 00 00       	push   $0x88
  802b0e:	68 cc 3a 80 00       	push   $0x803acc
  802b13:	e8 71 df ff ff       	call   800a89 <_panic>
		return r;
  802b18:	8b bd 8c fd ff ff    	mov    -0x274(%ebp),%edi
  802b1e:	e9 86 fe ff ff       	jmp    8029a9 <spawn+0x377>
		return r;
  802b23:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  802b29:	e9 7b fe ff ff       	jmp    8029a9 <spawn+0x377>
		return -E_NO_MEM;
  802b2e:	bf fc ff ff ff       	mov    $0xfffffffc,%edi
  802b33:	e9 71 fe ff ff       	jmp    8029a9 <spawn+0x377>
  802b38:	89 c7                	mov    %eax,%edi
  802b3a:	e9 4b fe ff ff       	jmp    80298a <spawn+0x358>
  802b3f:	89 c7                	mov    %eax,%edi
  802b41:	e9 44 fe ff ff       	jmp    80298a <spawn+0x358>
  802b46:	89 c7                	mov    %eax,%edi
  802b48:	e9 3d fe ff ff       	jmp    80298a <spawn+0x358>
	if ((r = sys_env_set_trapframe(child, &child_tf)) < 0)
  802b4d:	83 ec 08             	sub    $0x8,%esp
  802b50:	8d 85 a4 fd ff ff    	lea    -0x25c(%ebp),%eax
  802b56:	50                   	push   %eax
  802b57:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b5d:	e8 59 ec ff ff       	call   8017bb <sys_env_set_trapframe>
  802b62:	83 c4 10             	add    $0x10,%esp
  802b65:	85 c0                	test   %eax,%eax
  802b67:	78 85                	js     802aee <spawn+0x4bc>
	if ((r = sys_env_set_status(child, ENV_RUNNABLE)) < 0)
  802b69:	83 ec 08             	sub    $0x8,%esp
  802b6c:	6a 02                	push   $0x2
  802b6e:	ff b5 74 fd ff ff    	pushl  -0x28c(%ebp)
  802b74:	e8 bf eb ff ff       	call   801738 <sys_env_set_status>
  802b79:	83 c4 10             	add    $0x10,%esp
  802b7c:	85 c0                	test   %eax,%eax
  802b7e:	78 83                	js     802b03 <spawn+0x4d1>
	return child;
  802b80:	8b bd 74 fd ff ff    	mov    -0x28c(%ebp),%edi
  802b86:	e9 1e fe ff ff       	jmp    8029a9 <spawn+0x377>
	sys_page_unmap(0, UTEMP);
  802b8b:	83 ec 08             	sub    $0x8,%esp
  802b8e:	68 00 00 40 00       	push   $0x400000
  802b93:	6a 00                	push   $0x0
  802b95:	e8 3d eb ff ff       	call   8016d7 <sys_page_unmap>
  802b9a:	83 c4 10             	add    $0x10,%esp
  802b9d:	e9 07 fe ff ff       	jmp    8029a9 <spawn+0x377>

00802ba2 <spawnl>:
{
  802ba2:	55                   	push   %ebp
  802ba3:	89 e5                	mov    %esp,%ebp
  802ba5:	57                   	push   %edi
  802ba6:	56                   	push   %esi
  802ba7:	53                   	push   %ebx
  802ba8:	83 ec 0c             	sub    $0xc,%esp
	va_start(vl, arg0);
  802bab:	8d 55 10             	lea    0x10(%ebp),%edx
	int argc=0;
  802bae:	b8 00 00 00 00       	mov    $0x0,%eax
	while(va_arg(vl, void *) != NULL)
  802bb3:	eb 03                	jmp    802bb8 <spawnl+0x16>
		argc++;
  802bb5:	40                   	inc    %eax
	while(va_arg(vl, void *) != NULL)
  802bb6:	89 ca                	mov    %ecx,%edx
  802bb8:	8d 4a 04             	lea    0x4(%edx),%ecx
  802bbb:	83 3a 00             	cmpl   $0x0,(%edx)
  802bbe:	75 f5                	jne    802bb5 <spawnl+0x13>
	const char *argv[argc+2];
  802bc0:	8d 14 85 1a 00 00 00 	lea    0x1a(,%eax,4),%edx
  802bc7:	83 e2 f0             	and    $0xfffffff0,%edx
  802bca:	29 d4                	sub    %edx,%esp
  802bcc:	8d 54 24 03          	lea    0x3(%esp),%edx
  802bd0:	c1 ea 02             	shr    $0x2,%edx
  802bd3:	8d 34 95 00 00 00 00 	lea    0x0(,%edx,4),%esi
  802bda:	89 f3                	mov    %esi,%ebx
	argv[0] = arg0;
  802bdc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802bdf:	89 0c 95 00 00 00 00 	mov    %ecx,0x0(,%edx,4)
	argv[argc+1] = NULL;
  802be6:	c7 44 86 04 00 00 00 	movl   $0x0,0x4(%esi,%eax,4)
  802bed:	00 
	va_start(vl, arg0);
  802bee:	8d 4d 10             	lea    0x10(%ebp),%ecx
  802bf1:	89 c2                	mov    %eax,%edx
	for(i=0;i<argc;i++)
  802bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  802bf8:	eb 09                	jmp    802c03 <spawnl+0x61>
		argv[i+1] = va_arg(vl, const char *);
  802bfa:	40                   	inc    %eax
  802bfb:	8b 39                	mov    (%ecx),%edi
  802bfd:	89 3c 83             	mov    %edi,(%ebx,%eax,4)
  802c00:	8d 49 04             	lea    0x4(%ecx),%ecx
	for(i=0;i<argc;i++)
  802c03:	39 d0                	cmp    %edx,%eax
  802c05:	75 f3                	jne    802bfa <spawnl+0x58>
	return spawn(prog, argv);
  802c07:	83 ec 08             	sub    $0x8,%esp
  802c0a:	56                   	push   %esi
  802c0b:	ff 75 08             	pushl  0x8(%ebp)
  802c0e:	e8 1f fa ff ff       	call   802632 <spawn>
}
  802c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802c16:	5b                   	pop    %ebx
  802c17:	5e                   	pop    %esi
  802c18:	5f                   	pop    %edi
  802c19:	5d                   	pop    %ebp
  802c1a:	c3                   	ret    

00802c1b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  802c1b:	55                   	push   %ebp
  802c1c:	89 e5                	mov    %esp,%ebp
  802c1e:	56                   	push   %esi
  802c1f:	53                   	push   %ebx
  802c20:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  802c23:	83 ec 0c             	sub    $0xc,%esp
  802c26:	ff 75 08             	pushl  0x8(%ebp)
  802c29:	e8 c7 f0 ff ff       	call   801cf5 <fd2data>
  802c2e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  802c30:	83 c4 08             	add    $0x8,%esp
  802c33:	68 62 3b 80 00       	push   $0x803b62
  802c38:	53                   	push   %ebx
  802c39:	e8 5f e6 ff ff       	call   80129d <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  802c3e:	8b 46 04             	mov    0x4(%esi),%eax
  802c41:	2b 06                	sub    (%esi),%eax
  802c43:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  802c49:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  802c50:	10 00 00 
	stat->st_dev = &devpipe;
  802c53:	c7 83 88 00 00 00 3c 	movl   $0x80403c,0x88(%ebx)
  802c5a:	40 80 00 
	return 0;
}
  802c5d:	b8 00 00 00 00       	mov    $0x0,%eax
  802c62:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802c65:	5b                   	pop    %ebx
  802c66:	5e                   	pop    %esi
  802c67:	5d                   	pop    %ebp
  802c68:	c3                   	ret    

00802c69 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  802c69:	55                   	push   %ebp
  802c6a:	89 e5                	mov    %esp,%ebp
  802c6c:	53                   	push   %ebx
  802c6d:	83 ec 0c             	sub    $0xc,%esp
  802c70:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  802c73:	53                   	push   %ebx
  802c74:	6a 00                	push   $0x0
  802c76:	e8 5c ea ff ff       	call   8016d7 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  802c7b:	89 1c 24             	mov    %ebx,(%esp)
  802c7e:	e8 72 f0 ff ff       	call   801cf5 <fd2data>
  802c83:	83 c4 08             	add    $0x8,%esp
  802c86:	50                   	push   %eax
  802c87:	6a 00                	push   $0x0
  802c89:	e8 49 ea ff ff       	call   8016d7 <sys_page_unmap>
}
  802c8e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802c91:	c9                   	leave  
  802c92:	c3                   	ret    

00802c93 <_pipeisclosed>:
{
  802c93:	55                   	push   %ebp
  802c94:	89 e5                	mov    %esp,%ebp
  802c96:	57                   	push   %edi
  802c97:	56                   	push   %esi
  802c98:	53                   	push   %ebx
  802c99:	83 ec 1c             	sub    $0x1c,%esp
  802c9c:	89 c7                	mov    %eax,%edi
  802c9e:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  802ca0:	a1 24 54 80 00       	mov    0x805424,%eax
  802ca5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  802ca8:	83 ec 0c             	sub    $0xc,%esp
  802cab:	57                   	push   %edi
  802cac:	e8 97 04 00 00       	call   803148 <pageref>
  802cb1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  802cb4:	89 34 24             	mov    %esi,(%esp)
  802cb7:	e8 8c 04 00 00       	call   803148 <pageref>
		nn = thisenv->env_runs;
  802cbc:	8b 15 24 54 80 00    	mov    0x805424,%edx
  802cc2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  802cc5:	83 c4 10             	add    $0x10,%esp
  802cc8:	39 cb                	cmp    %ecx,%ebx
  802cca:	74 1b                	je     802ce7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  802ccc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802ccf:	75 cf                	jne    802ca0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  802cd1:	8b 42 58             	mov    0x58(%edx),%eax
  802cd4:	6a 01                	push   $0x1
  802cd6:	50                   	push   %eax
  802cd7:	53                   	push   %ebx
  802cd8:	68 69 3b 80 00       	push   $0x803b69
  802cdd:	e8 ba de ff ff       	call   800b9c <cprintf>
  802ce2:	83 c4 10             	add    $0x10,%esp
  802ce5:	eb b9                	jmp    802ca0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  802ce7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  802cea:	0f 94 c0             	sete   %al
  802ced:	0f b6 c0             	movzbl %al,%eax
}
  802cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802cf3:	5b                   	pop    %ebx
  802cf4:	5e                   	pop    %esi
  802cf5:	5f                   	pop    %edi
  802cf6:	5d                   	pop    %ebp
  802cf7:	c3                   	ret    

00802cf8 <devpipe_write>:
{
  802cf8:	55                   	push   %ebp
  802cf9:	89 e5                	mov    %esp,%ebp
  802cfb:	57                   	push   %edi
  802cfc:	56                   	push   %esi
  802cfd:	53                   	push   %ebx
  802cfe:	83 ec 18             	sub    $0x18,%esp
  802d01:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  802d04:	56                   	push   %esi
  802d05:	e8 eb ef ff ff       	call   801cf5 <fd2data>
  802d0a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  802d0c:	83 c4 10             	add    $0x10,%esp
  802d0f:	bf 00 00 00 00       	mov    $0x0,%edi
  802d14:	3b 7d 10             	cmp    0x10(%ebp),%edi
  802d17:	74 41                	je     802d5a <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  802d19:	8b 53 04             	mov    0x4(%ebx),%edx
  802d1c:	8b 03                	mov    (%ebx),%eax
  802d1e:	83 c0 20             	add    $0x20,%eax
  802d21:	39 c2                	cmp    %eax,%edx
  802d23:	72 14                	jb     802d39 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  802d25:	89 da                	mov    %ebx,%edx
  802d27:	89 f0                	mov    %esi,%eax
  802d29:	e8 65 ff ff ff       	call   802c93 <_pipeisclosed>
  802d2e:	85 c0                	test   %eax,%eax
  802d30:	75 2c                	jne    802d5e <devpipe_write+0x66>
			sys_yield();
  802d32:	e8 e2 e9 ff ff       	call   801719 <sys_yield>
  802d37:	eb e0                	jmp    802d19 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  802d3c:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  802d3f:	89 d0                	mov    %edx,%eax
  802d41:	25 1f 00 00 80       	and    $0x8000001f,%eax
  802d46:	78 0b                	js     802d53 <devpipe_write+0x5b>
  802d48:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  802d4c:	42                   	inc    %edx
  802d4d:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  802d50:	47                   	inc    %edi
  802d51:	eb c1                	jmp    802d14 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  802d53:	48                   	dec    %eax
  802d54:	83 c8 e0             	or     $0xffffffe0,%eax
  802d57:	40                   	inc    %eax
  802d58:	eb ee                	jmp    802d48 <devpipe_write+0x50>
	return i;
  802d5a:	89 f8                	mov    %edi,%eax
  802d5c:	eb 05                	jmp    802d63 <devpipe_write+0x6b>
				return 0;
  802d5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d63:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d66:	5b                   	pop    %ebx
  802d67:	5e                   	pop    %esi
  802d68:	5f                   	pop    %edi
  802d69:	5d                   	pop    %ebp
  802d6a:	c3                   	ret    

00802d6b <devpipe_read>:
{
  802d6b:	55                   	push   %ebp
  802d6c:	89 e5                	mov    %esp,%ebp
  802d6e:	57                   	push   %edi
  802d6f:	56                   	push   %esi
  802d70:	53                   	push   %ebx
  802d71:	83 ec 18             	sub    $0x18,%esp
  802d74:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  802d77:	57                   	push   %edi
  802d78:	e8 78 ef ff ff       	call   801cf5 <fd2data>
  802d7d:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  802d7f:	83 c4 10             	add    $0x10,%esp
  802d82:	bb 00 00 00 00       	mov    $0x0,%ebx
  802d87:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  802d8a:	74 46                	je     802dd2 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  802d8c:	8b 06                	mov    (%esi),%eax
  802d8e:	3b 46 04             	cmp    0x4(%esi),%eax
  802d91:	75 22                	jne    802db5 <devpipe_read+0x4a>
			if (i > 0)
  802d93:	85 db                	test   %ebx,%ebx
  802d95:	74 0a                	je     802da1 <devpipe_read+0x36>
				return i;
  802d97:	89 d8                	mov    %ebx,%eax
}
  802d99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  802d9c:	5b                   	pop    %ebx
  802d9d:	5e                   	pop    %esi
  802d9e:	5f                   	pop    %edi
  802d9f:	5d                   	pop    %ebp
  802da0:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  802da1:	89 f2                	mov    %esi,%edx
  802da3:	89 f8                	mov    %edi,%eax
  802da5:	e8 e9 fe ff ff       	call   802c93 <_pipeisclosed>
  802daa:	85 c0                	test   %eax,%eax
  802dac:	75 28                	jne    802dd6 <devpipe_read+0x6b>
			sys_yield();
  802dae:	e8 66 e9 ff ff       	call   801719 <sys_yield>
  802db3:	eb d7                	jmp    802d8c <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802db5:	25 1f 00 00 80       	and    $0x8000001f,%eax
  802dba:	78 0f                	js     802dcb <devpipe_read+0x60>
  802dbc:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  802dc0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  802dc3:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  802dc6:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  802dc8:	43                   	inc    %ebx
  802dc9:	eb bc                	jmp    802d87 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  802dcb:	48                   	dec    %eax
  802dcc:	83 c8 e0             	or     $0xffffffe0,%eax
  802dcf:	40                   	inc    %eax
  802dd0:	eb ea                	jmp    802dbc <devpipe_read+0x51>
	return i;
  802dd2:	89 d8                	mov    %ebx,%eax
  802dd4:	eb c3                	jmp    802d99 <devpipe_read+0x2e>
				return 0;
  802dd6:	b8 00 00 00 00       	mov    $0x0,%eax
  802ddb:	eb bc                	jmp    802d99 <devpipe_read+0x2e>

00802ddd <pipe>:
{
  802ddd:	55                   	push   %ebp
  802dde:	89 e5                	mov    %esp,%ebp
  802de0:	56                   	push   %esi
  802de1:	53                   	push   %ebx
  802de2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  802de5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802de8:	50                   	push   %eax
  802de9:	e8 1e ef ff ff       	call   801d0c <fd_alloc>
  802dee:	89 c3                	mov    %eax,%ebx
  802df0:	83 c4 10             	add    $0x10,%esp
  802df3:	85 c0                	test   %eax,%eax
  802df5:	0f 88 2a 01 00 00    	js     802f25 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802dfb:	83 ec 04             	sub    $0x4,%esp
  802dfe:	68 07 04 00 00       	push   $0x407
  802e03:	ff 75 f4             	pushl  -0xc(%ebp)
  802e06:	6a 00                	push   $0x0
  802e08:	e8 45 e8 ff ff       	call   801652 <sys_page_alloc>
  802e0d:	89 c3                	mov    %eax,%ebx
  802e0f:	83 c4 10             	add    $0x10,%esp
  802e12:	85 c0                	test   %eax,%eax
  802e14:	0f 88 0b 01 00 00    	js     802f25 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  802e1a:	83 ec 0c             	sub    $0xc,%esp
  802e1d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  802e20:	50                   	push   %eax
  802e21:	e8 e6 ee ff ff       	call   801d0c <fd_alloc>
  802e26:	89 c3                	mov    %eax,%ebx
  802e28:	83 c4 10             	add    $0x10,%esp
  802e2b:	85 c0                	test   %eax,%eax
  802e2d:	0f 88 e2 00 00 00    	js     802f15 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e33:	83 ec 04             	sub    $0x4,%esp
  802e36:	68 07 04 00 00       	push   $0x407
  802e3b:	ff 75 f0             	pushl  -0x10(%ebp)
  802e3e:	6a 00                	push   $0x0
  802e40:	e8 0d e8 ff ff       	call   801652 <sys_page_alloc>
  802e45:	89 c3                	mov    %eax,%ebx
  802e47:	83 c4 10             	add    $0x10,%esp
  802e4a:	85 c0                	test   %eax,%eax
  802e4c:	0f 88 c3 00 00 00    	js     802f15 <pipe+0x138>
	va = fd2data(fd0);
  802e52:	83 ec 0c             	sub    $0xc,%esp
  802e55:	ff 75 f4             	pushl  -0xc(%ebp)
  802e58:	e8 98 ee ff ff       	call   801cf5 <fd2data>
  802e5d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e5f:	83 c4 0c             	add    $0xc,%esp
  802e62:	68 07 04 00 00       	push   $0x407
  802e67:	50                   	push   %eax
  802e68:	6a 00                	push   $0x0
  802e6a:	e8 e3 e7 ff ff       	call   801652 <sys_page_alloc>
  802e6f:	89 c3                	mov    %eax,%ebx
  802e71:	83 c4 10             	add    $0x10,%esp
  802e74:	85 c0                	test   %eax,%eax
  802e76:	0f 88 89 00 00 00    	js     802f05 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802e7c:	83 ec 0c             	sub    $0xc,%esp
  802e7f:	ff 75 f0             	pushl  -0x10(%ebp)
  802e82:	e8 6e ee ff ff       	call   801cf5 <fd2data>
  802e87:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802e8e:	50                   	push   %eax
  802e8f:	6a 00                	push   $0x0
  802e91:	56                   	push   %esi
  802e92:	6a 00                	push   $0x0
  802e94:	e8 fc e7 ff ff       	call   801695 <sys_page_map>
  802e99:	89 c3                	mov    %eax,%ebx
  802e9b:	83 c4 20             	add    $0x20,%esp
  802e9e:	85 c0                	test   %eax,%eax
  802ea0:	78 55                	js     802ef7 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  802ea2:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802ea8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eab:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802eb7:	8b 15 3c 40 80 00    	mov    0x80403c,%edx
  802ebd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  802ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ec5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802ecc:	83 ec 0c             	sub    $0xc,%esp
  802ecf:	ff 75 f4             	pushl  -0xc(%ebp)
  802ed2:	e8 0e ee ff ff       	call   801ce5 <fd2num>
  802ed7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eda:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802edc:	83 c4 04             	add    $0x4,%esp
  802edf:	ff 75 f0             	pushl  -0x10(%ebp)
  802ee2:	e8 fe ed ff ff       	call   801ce5 <fd2num>
  802ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802eea:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802eed:	83 c4 10             	add    $0x10,%esp
  802ef0:	bb 00 00 00 00       	mov    $0x0,%ebx
  802ef5:	eb 2e                	jmp    802f25 <pipe+0x148>
	sys_page_unmap(0, va);
  802ef7:	83 ec 08             	sub    $0x8,%esp
  802efa:	56                   	push   %esi
  802efb:	6a 00                	push   $0x0
  802efd:	e8 d5 e7 ff ff       	call   8016d7 <sys_page_unmap>
  802f02:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  802f05:	83 ec 08             	sub    $0x8,%esp
  802f08:	ff 75 f0             	pushl  -0x10(%ebp)
  802f0b:	6a 00                	push   $0x0
  802f0d:	e8 c5 e7 ff ff       	call   8016d7 <sys_page_unmap>
  802f12:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  802f15:	83 ec 08             	sub    $0x8,%esp
  802f18:	ff 75 f4             	pushl  -0xc(%ebp)
  802f1b:	6a 00                	push   $0x0
  802f1d:	e8 b5 e7 ff ff       	call   8016d7 <sys_page_unmap>
  802f22:	83 c4 10             	add    $0x10,%esp
}
  802f25:	89 d8                	mov    %ebx,%eax
  802f27:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802f2a:	5b                   	pop    %ebx
  802f2b:	5e                   	pop    %esi
  802f2c:	5d                   	pop    %ebp
  802f2d:	c3                   	ret    

00802f2e <pipeisclosed>:
{
  802f2e:	55                   	push   %ebp
  802f2f:	89 e5                	mov    %esp,%ebp
  802f31:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  802f34:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802f37:	50                   	push   %eax
  802f38:	ff 75 08             	pushl  0x8(%ebp)
  802f3b:	e8 1b ee ff ff       	call   801d5b <fd_lookup>
  802f40:	83 c4 10             	add    $0x10,%esp
  802f43:	85 c0                	test   %eax,%eax
  802f45:	78 18                	js     802f5f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  802f47:	83 ec 0c             	sub    $0xc,%esp
  802f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  802f4d:	e8 a3 ed ff ff       	call   801cf5 <fd2data>
	return _pipeisclosed(fd, p);
  802f52:	89 c2                	mov    %eax,%edx
  802f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f57:	e8 37 fd ff ff       	call   802c93 <_pipeisclosed>
  802f5c:	83 c4 10             	add    $0x10,%esp
}
  802f5f:	c9                   	leave  
  802f60:	c3                   	ret    

00802f61 <wait>:
#include <inc/lib.h>

// Waits until 'envid' exits.
void
wait(envid_t envid)
{
  802f61:	55                   	push   %ebp
  802f62:	89 e5                	mov    %esp,%ebp
  802f64:	56                   	push   %esi
  802f65:	53                   	push   %ebx
  802f66:	8b 75 08             	mov    0x8(%ebp),%esi
	const volatile struct Env *e;

	assert(envid != 0);
  802f69:	85 f6                	test   %esi,%esi
  802f6b:	74 18                	je     802f85 <wait+0x24>
	e = &envs[ENVX(envid)];
  802f6d:	89 f2                	mov    %esi,%edx
  802f6f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802f75:	89 d0                	mov    %edx,%eax
  802f77:	c1 e0 05             	shl    $0x5,%eax
  802f7a:	29 d0                	sub    %edx,%eax
  802f7c:	8d 1c 85 00 00 c0 ee 	lea    -0x11400000(,%eax,4),%ebx
  802f83:	eb 1b                	jmp    802fa0 <wait+0x3f>
	assert(envid != 0);
  802f85:	68 81 3b 80 00       	push   $0x803b81
  802f8a:	68 1a 35 80 00       	push   $0x80351a
  802f8f:	6a 09                	push   $0x9
  802f91:	68 8c 3b 80 00       	push   $0x803b8c
  802f96:	e8 ee da ff ff       	call   800a89 <_panic>
		sys_yield();
  802f9b:	e8 79 e7 ff ff       	call   801719 <sys_yield>
	while (e->env_id == envid && e->env_status != ENV_FREE)
  802fa0:	8b 43 48             	mov    0x48(%ebx),%eax
  802fa3:	39 c6                	cmp    %eax,%esi
  802fa5:	75 07                	jne    802fae <wait+0x4d>
  802fa7:	8b 43 54             	mov    0x54(%ebx),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	75 ed                	jne    802f9b <wait+0x3a>
}
  802fae:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802fb1:	5b                   	pop    %ebx
  802fb2:	5e                   	pop    %esi
  802fb3:	5d                   	pop    %ebp
  802fb4:	c3                   	ret    

00802fb5 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  802fb5:	55                   	push   %ebp
  802fb6:	89 e5                	mov    %esp,%ebp
  802fb8:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  802fbb:	83 3d 00 70 80 00 00 	cmpl   $0x0,0x807000
  802fc2:	74 0a                	je     802fce <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	a3 00 70 80 00       	mov    %eax,0x807000
}
  802fcc:	c9                   	leave  
  802fcd:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  802fce:	e8 60 e6 ff ff       	call   801633 <sys_getenvid>
  802fd3:	83 ec 04             	sub    $0x4,%esp
  802fd6:	6a 07                	push   $0x7
  802fd8:	68 00 f0 bf ee       	push   $0xeebff000
  802fdd:	50                   	push   %eax
  802fde:	e8 6f e6 ff ff       	call   801652 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  802fe3:	e8 4b e6 ff ff       	call   801633 <sys_getenvid>
  802fe8:	83 c4 08             	add    $0x8,%esp
  802feb:	68 fb 2f 80 00       	push   $0x802ffb
  802ff0:	50                   	push   %eax
  802ff1:	e8 07 e8 ff ff       	call   8017fd <sys_env_set_pgfault_upcall>
  802ff6:	83 c4 10             	add    $0x10,%esp
  802ff9:	eb c9                	jmp    802fc4 <set_pgfault_handler+0xf>

00802ffb <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  802ffb:	54                   	push   %esp
	movl _pgfault_handler, %eax
  802ffc:	a1 00 70 80 00       	mov    0x807000,%eax
	call *%eax
  803001:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  803003:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  803006:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80300a:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80300e:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  803011:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  803013:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  803017:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80301a:	61                   	popa   
	addl $4, %esp
  80301b:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80301e:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  80301f:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  803020:	c3                   	ret    

00803021 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  803021:	55                   	push   %ebp
  803022:	89 e5                	mov    %esp,%ebp
  803024:	57                   	push   %edi
  803025:	56                   	push   %esi
  803026:	53                   	push   %ebx
  803027:	83 ec 0c             	sub    $0xc,%esp
  80302a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80302d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  803030:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  803033:	85 ff                	test   %edi,%edi
  803035:	74 53                	je     80308a <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  803037:	83 ec 0c             	sub    $0xc,%esp
  80303a:	57                   	push   %edi
  80303b:	e8 22 e8 ff ff       	call   801862 <sys_ipc_recv>
  803040:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  803043:	85 db                	test   %ebx,%ebx
  803045:	74 0b                	je     803052 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  803047:	8b 15 24 54 80 00    	mov    0x805424,%edx
  80304d:	8b 52 74             	mov    0x74(%edx),%edx
  803050:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  803052:	85 f6                	test   %esi,%esi
  803054:	74 0f                	je     803065 <ipc_recv+0x44>
  803056:	85 ff                	test   %edi,%edi
  803058:	74 0b                	je     803065 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80305a:	8b 15 24 54 80 00    	mov    0x805424,%edx
  803060:	8b 52 78             	mov    0x78(%edx),%edx
  803063:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  803065:	85 c0                	test   %eax,%eax
  803067:	74 30                	je     803099 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  803069:	85 db                	test   %ebx,%ebx
  80306b:	74 06                	je     803073 <ipc_recv+0x52>
      		*from_env_store = 0;
  80306d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  803073:	85 f6                	test   %esi,%esi
  803075:	74 2c                	je     8030a3 <ipc_recv+0x82>
      		*perm_store = 0;
  803077:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  80307d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  803082:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803085:	5b                   	pop    %ebx
  803086:	5e                   	pop    %esi
  803087:	5f                   	pop    %edi
  803088:	5d                   	pop    %ebp
  803089:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  80308a:	83 ec 0c             	sub    $0xc,%esp
  80308d:	6a ff                	push   $0xffffffff
  80308f:	e8 ce e7 ff ff       	call   801862 <sys_ipc_recv>
  803094:	83 c4 10             	add    $0x10,%esp
  803097:	eb aa                	jmp    803043 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  803099:	a1 24 54 80 00       	mov    0x805424,%eax
  80309e:	8b 40 70             	mov    0x70(%eax),%eax
  8030a1:	eb df                	jmp    803082 <ipc_recv+0x61>
		return -1;
  8030a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8030a8:	eb d8                	jmp    803082 <ipc_recv+0x61>

008030aa <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8030aa:	55                   	push   %ebp
  8030ab:	89 e5                	mov    %esp,%ebp
  8030ad:	57                   	push   %edi
  8030ae:	56                   	push   %esi
  8030af:	53                   	push   %ebx
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8030b6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8030b9:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8030bc:	85 db                	test   %ebx,%ebx
  8030be:	75 22                	jne    8030e2 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8030c0:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8030c5:	eb 1b                	jmp    8030e2 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8030c7:	68 98 3b 80 00       	push   $0x803b98
  8030cc:	68 1a 35 80 00       	push   $0x80351a
  8030d1:	6a 48                	push   $0x48
  8030d3:	68 bc 3b 80 00       	push   $0x803bbc
  8030d8:	e8 ac d9 ff ff       	call   800a89 <_panic>
		sys_yield();
  8030dd:	e8 37 e6 ff ff       	call   801719 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  8030e2:	57                   	push   %edi
  8030e3:	53                   	push   %ebx
  8030e4:	56                   	push   %esi
  8030e5:	ff 75 08             	pushl  0x8(%ebp)
  8030e8:	e8 52 e7 ff ff       	call   80183f <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8030ed:	83 c4 10             	add    $0x10,%esp
  8030f0:	83 f8 f9             	cmp    $0xfffffff9,%eax
  8030f3:	74 e8                	je     8030dd <ipc_send+0x33>
  8030f5:	85 c0                	test   %eax,%eax
  8030f7:	75 ce                	jne    8030c7 <ipc_send+0x1d>
		sys_yield();
  8030f9:	e8 1b e6 ff ff       	call   801719 <sys_yield>
		
	}
	
}
  8030fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  803101:	5b                   	pop    %ebx
  803102:	5e                   	pop    %esi
  803103:	5f                   	pop    %edi
  803104:	5d                   	pop    %ebp
  803105:	c3                   	ret    

00803106 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  803106:	55                   	push   %ebp
  803107:	89 e5                	mov    %esp,%ebp
  803109:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80310c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  803111:	89 c2                	mov    %eax,%edx
  803113:	c1 e2 05             	shl    $0x5,%edx
  803116:	29 c2                	sub    %eax,%edx
  803118:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  80311f:	8b 52 50             	mov    0x50(%edx),%edx
  803122:	39 ca                	cmp    %ecx,%edx
  803124:	74 0f                	je     803135 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  803126:	40                   	inc    %eax
  803127:	3d 00 04 00 00       	cmp    $0x400,%eax
  80312c:	75 e3                	jne    803111 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  80312e:	b8 00 00 00 00       	mov    $0x0,%eax
  803133:	eb 11                	jmp    803146 <ipc_find_env+0x40>
			return envs[i].env_id;
  803135:	89 c2                	mov    %eax,%edx
  803137:	c1 e2 05             	shl    $0x5,%edx
  80313a:	29 c2                	sub    %eax,%edx
  80313c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  803143:	8b 40 48             	mov    0x48(%eax),%eax
}
  803146:	5d                   	pop    %ebp
  803147:	c3                   	ret    

00803148 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  803148:	55                   	push   %ebp
  803149:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  80314b:	8b 45 08             	mov    0x8(%ebp),%eax
  80314e:	c1 e8 16             	shr    $0x16,%eax
  803151:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  803158:	a8 01                	test   $0x1,%al
  80315a:	74 21                	je     80317d <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	c1 e8 0c             	shr    $0xc,%eax
  803162:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  803169:	a8 01                	test   $0x1,%al
  80316b:	74 17                	je     803184 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  80316d:	c1 e8 0c             	shr    $0xc,%eax
  803170:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  803177:	ef 
  803178:	0f b7 c0             	movzwl %ax,%eax
  80317b:	eb 05                	jmp    803182 <pageref+0x3a>
		return 0;
  80317d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    
		return 0;
  803184:	b8 00 00 00 00       	mov    $0x0,%eax
  803189:	eb f7                	jmp    803182 <pageref+0x3a>
  80318b:	90                   	nop

0080318c <__udivdi3>:
  80318c:	55                   	push   %ebp
  80318d:	57                   	push   %edi
  80318e:	56                   	push   %esi
  80318f:	53                   	push   %ebx
  803190:	83 ec 1c             	sub    $0x1c,%esp
  803193:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803197:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80319b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80319f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8031a3:	89 ca                	mov    %ecx,%edx
  8031a5:	89 f8                	mov    %edi,%eax
  8031a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031ab:	85 f6                	test   %esi,%esi
  8031ad:	75 2d                	jne    8031dc <__udivdi3+0x50>
  8031af:	39 cf                	cmp    %ecx,%edi
  8031b1:	77 65                	ja     803218 <__udivdi3+0x8c>
  8031b3:	89 fd                	mov    %edi,%ebp
  8031b5:	85 ff                	test   %edi,%edi
  8031b7:	75 0b                	jne    8031c4 <__udivdi3+0x38>
  8031b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8031be:	31 d2                	xor    %edx,%edx
  8031c0:	f7 f7                	div    %edi
  8031c2:	89 c5                	mov    %eax,%ebp
  8031c4:	31 d2                	xor    %edx,%edx
  8031c6:	89 c8                	mov    %ecx,%eax
  8031c8:	f7 f5                	div    %ebp
  8031ca:	89 c1                	mov    %eax,%ecx
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f5                	div    %ebp
  8031d0:	89 cf                	mov    %ecx,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	39 ce                	cmp    %ecx,%esi
  8031de:	77 28                	ja     803208 <__udivdi3+0x7c>
  8031e0:	0f bd fe             	bsr    %esi,%edi
  8031e3:	83 f7 1f             	xor    $0x1f,%edi
  8031e6:	75 40                	jne    803228 <__udivdi3+0x9c>
  8031e8:	39 ce                	cmp    %ecx,%esi
  8031ea:	72 0a                	jb     8031f6 <__udivdi3+0x6a>
  8031ec:	3b 44 24 04          	cmp    0x4(%esp),%eax
  8031f0:	0f 87 9e 00 00 00    	ja     803294 <__udivdi3+0x108>
  8031f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031fb:	89 fa                	mov    %edi,%edx
  8031fd:	83 c4 1c             	add    $0x1c,%esp
  803200:	5b                   	pop    %ebx
  803201:	5e                   	pop    %esi
  803202:	5f                   	pop    %edi
  803203:	5d                   	pop    %ebp
  803204:	c3                   	ret    
  803205:	8d 76 00             	lea    0x0(%esi),%esi
  803208:	31 ff                	xor    %edi,%edi
  80320a:	31 c0                	xor    %eax,%eax
  80320c:	89 fa                	mov    %edi,%edx
  80320e:	83 c4 1c             	add    $0x1c,%esp
  803211:	5b                   	pop    %ebx
  803212:	5e                   	pop    %esi
  803213:	5f                   	pop    %edi
  803214:	5d                   	pop    %ebp
  803215:	c3                   	ret    
  803216:	66 90                	xchg   %ax,%ax
  803218:	89 d8                	mov    %ebx,%eax
  80321a:	f7 f7                	div    %edi
  80321c:	31 ff                	xor    %edi,%edi
  80321e:	89 fa                	mov    %edi,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	bd 20 00 00 00       	mov    $0x20,%ebp
  80322d:	29 fd                	sub    %edi,%ebp
  80322f:	89 f9                	mov    %edi,%ecx
  803231:	d3 e6                	shl    %cl,%esi
  803233:	89 c3                	mov    %eax,%ebx
  803235:	89 e9                	mov    %ebp,%ecx
  803237:	d3 eb                	shr    %cl,%ebx
  803239:	89 d9                	mov    %ebx,%ecx
  80323b:	09 f1                	or     %esi,%ecx
  80323d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803241:	89 f9                	mov    %edi,%ecx
  803243:	d3 e0                	shl    %cl,%eax
  803245:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803249:	89 d6                	mov    %edx,%esi
  80324b:	89 e9                	mov    %ebp,%ecx
  80324d:	d3 ee                	shr    %cl,%esi
  80324f:	89 f9                	mov    %edi,%ecx
  803251:	d3 e2                	shl    %cl,%edx
  803253:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  803257:	89 e9                	mov    %ebp,%ecx
  803259:	d3 eb                	shr    %cl,%ebx
  80325b:	09 da                	or     %ebx,%edx
  80325d:	89 d0                	mov    %edx,%eax
  80325f:	89 f2                	mov    %esi,%edx
  803261:	f7 74 24 08          	divl   0x8(%esp)
  803265:	89 d6                	mov    %edx,%esi
  803267:	89 c3                	mov    %eax,%ebx
  803269:	f7 64 24 0c          	mull   0xc(%esp)
  80326d:	39 d6                	cmp    %edx,%esi
  80326f:	72 17                	jb     803288 <__udivdi3+0xfc>
  803271:	74 09                	je     80327c <__udivdi3+0xf0>
  803273:	89 d8                	mov    %ebx,%eax
  803275:	31 ff                	xor    %edi,%edi
  803277:	e9 56 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  80327c:	8b 54 24 04          	mov    0x4(%esp),%edx
  803280:	89 f9                	mov    %edi,%ecx
  803282:	d3 e2                	shl    %cl,%edx
  803284:	39 c2                	cmp    %eax,%edx
  803286:	73 eb                	jae    803273 <__udivdi3+0xe7>
  803288:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80328b:	31 ff                	xor    %edi,%edi
  80328d:	e9 40 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  803292:	66 90                	xchg   %ax,%ax
  803294:	31 c0                	xor    %eax,%eax
  803296:	e9 37 ff ff ff       	jmp    8031d2 <__udivdi3+0x46>
  80329b:	90                   	nop

0080329c <__umoddi3>:
  80329c:	55                   	push   %ebp
  80329d:	57                   	push   %edi
  80329e:	56                   	push   %esi
  80329f:	53                   	push   %ebx
  8032a0:	83 ec 1c             	sub    $0x1c,%esp
  8032a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032bb:	89 3c 24             	mov    %edi,(%esp)
  8032be:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032c2:	89 f2                	mov    %esi,%edx
  8032c4:	85 c0                	test   %eax,%eax
  8032c6:	75 18                	jne    8032e0 <__umoddi3+0x44>
  8032c8:	39 f7                	cmp    %esi,%edi
  8032ca:	0f 86 a0 00 00 00    	jbe    803370 <__umoddi3+0xd4>
  8032d0:	89 c8                	mov    %ecx,%eax
  8032d2:	f7 f7                	div    %edi
  8032d4:	89 d0                	mov    %edx,%eax
  8032d6:	31 d2                	xor    %edx,%edx
  8032d8:	83 c4 1c             	add    $0x1c,%esp
  8032db:	5b                   	pop    %ebx
  8032dc:	5e                   	pop    %esi
  8032dd:	5f                   	pop    %edi
  8032de:	5d                   	pop    %ebp
  8032df:	c3                   	ret    
  8032e0:	89 f3                	mov    %esi,%ebx
  8032e2:	39 f0                	cmp    %esi,%eax
  8032e4:	0f 87 a6 00 00 00    	ja     803390 <__umoddi3+0xf4>
  8032ea:	0f bd e8             	bsr    %eax,%ebp
  8032ed:	83 f5 1f             	xor    $0x1f,%ebp
  8032f0:	0f 84 a6 00 00 00    	je     80339c <__umoddi3+0x100>
  8032f6:	bf 20 00 00 00       	mov    $0x20,%edi
  8032fb:	29 ef                	sub    %ebp,%edi
  8032fd:	89 e9                	mov    %ebp,%ecx
  8032ff:	d3 e0                	shl    %cl,%eax
  803301:	8b 34 24             	mov    (%esp),%esi
  803304:	89 f2                	mov    %esi,%edx
  803306:	89 f9                	mov    %edi,%ecx
  803308:	d3 ea                	shr    %cl,%edx
  80330a:	09 c2                	or     %eax,%edx
  80330c:	89 14 24             	mov    %edx,(%esp)
  80330f:	89 f2                	mov    %esi,%edx
  803311:	89 e9                	mov    %ebp,%ecx
  803313:	d3 e2                	shl    %cl,%edx
  803315:	89 54 24 04          	mov    %edx,0x4(%esp)
  803319:	89 de                	mov    %ebx,%esi
  80331b:	89 f9                	mov    %edi,%ecx
  80331d:	d3 ee                	shr    %cl,%esi
  80331f:	89 e9                	mov    %ebp,%ecx
  803321:	d3 e3                	shl    %cl,%ebx
  803323:	8b 54 24 08          	mov    0x8(%esp),%edx
  803327:	89 d0                	mov    %edx,%eax
  803329:	89 f9                	mov    %edi,%ecx
  80332b:	d3 e8                	shr    %cl,%eax
  80332d:	09 d8                	or     %ebx,%eax
  80332f:	89 d3                	mov    %edx,%ebx
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 e3                	shl    %cl,%ebx
  803335:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803339:	89 f2                	mov    %esi,%edx
  80333b:	f7 34 24             	divl   (%esp)
  80333e:	89 d6                	mov    %edx,%esi
  803340:	f7 64 24 04          	mull   0x4(%esp)
  803344:	89 c3                	mov    %eax,%ebx
  803346:	89 d1                	mov    %edx,%ecx
  803348:	39 d6                	cmp    %edx,%esi
  80334a:	72 7c                	jb     8033c8 <__umoddi3+0x12c>
  80334c:	74 72                	je     8033c0 <__umoddi3+0x124>
  80334e:	8b 54 24 08          	mov    0x8(%esp),%edx
  803352:	29 da                	sub    %ebx,%edx
  803354:	19 ce                	sbb    %ecx,%esi
  803356:	89 f0                	mov    %esi,%eax
  803358:	89 f9                	mov    %edi,%ecx
  80335a:	d3 e0                	shl    %cl,%eax
  80335c:	89 e9                	mov    %ebp,%ecx
  80335e:	d3 ea                	shr    %cl,%edx
  803360:	09 d0                	or     %edx,%eax
  803362:	89 e9                	mov    %ebp,%ecx
  803364:	d3 ee                	shr    %cl,%esi
  803366:	89 f2                	mov    %esi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	89 fd                	mov    %edi,%ebp
  803372:	85 ff                	test   %edi,%edi
  803374:	75 0b                	jne    803381 <__umoddi3+0xe5>
  803376:	b8 01 00 00 00       	mov    $0x1,%eax
  80337b:	31 d2                	xor    %edx,%edx
  80337d:	f7 f7                	div    %edi
  80337f:	89 c5                	mov    %eax,%ebp
  803381:	89 f0                	mov    %esi,%eax
  803383:	31 d2                	xor    %edx,%edx
  803385:	f7 f5                	div    %ebp
  803387:	89 c8                	mov    %ecx,%eax
  803389:	f7 f5                	div    %ebp
  80338b:	e9 44 ff ff ff       	jmp    8032d4 <__umoddi3+0x38>
  803390:	89 c8                	mov    %ecx,%eax
  803392:	89 f2                	mov    %esi,%edx
  803394:	83 c4 1c             	add    $0x1c,%esp
  803397:	5b                   	pop    %ebx
  803398:	5e                   	pop    %esi
  803399:	5f                   	pop    %edi
  80339a:	5d                   	pop    %ebp
  80339b:	c3                   	ret    
  80339c:	39 f0                	cmp    %esi,%eax
  80339e:	72 05                	jb     8033a5 <__umoddi3+0x109>
  8033a0:	39 0c 24             	cmp    %ecx,(%esp)
  8033a3:	77 0c                	ja     8033b1 <__umoddi3+0x115>
  8033a5:	89 f2                	mov    %esi,%edx
  8033a7:	29 f9                	sub    %edi,%ecx
  8033a9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033ad:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033b1:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033b5:	83 c4 1c             	add    $0x1c,%esp
  8033b8:	5b                   	pop    %ebx
  8033b9:	5e                   	pop    %esi
  8033ba:	5f                   	pop    %edi
  8033bb:	5d                   	pop    %ebp
  8033bc:	c3                   	ret    
  8033bd:	8d 76 00             	lea    0x0(%esi),%esi
  8033c0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  8033c4:	73 88                	jae    80334e <__umoddi3+0xb2>
  8033c6:	66 90                	xchg   %ax,%ax
  8033c8:	2b 44 24 04          	sub    0x4(%esp),%eax
  8033cc:	1b 14 24             	sbb    (%esp),%edx
  8033cf:	89 d1                	mov    %edx,%ecx
  8033d1:	89 c3                	mov    %eax,%ebx
  8033d3:	e9 76 ff ff ff       	jmp    80334e <__umoddi3+0xb2>
