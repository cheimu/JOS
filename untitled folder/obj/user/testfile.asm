
obj/user/testfile.debug:     file format elf32-i386


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
  80002c:	e8 37 06 00 00       	call   800668 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <xopen>:

#define FVA ((struct Fd*)0xCCCCC000)

static int
xopen(const char *path, int mode)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	53                   	push   %ebx
  800037:	83 ec 0c             	sub    $0xc,%esp
  80003a:	89 d3                	mov    %edx,%ebx
	extern union Fsipc fsipcbuf;
	envid_t fsenv;
	
	strcpy(fsipcbuf.open.req_path, path);
  80003c:	50                   	push   %eax
  80003d:	68 00 50 80 00       	push   $0x805000
  800042:	e8 a2 0d 00 00       	call   800de9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800047:	89 1d 00 54 80 00    	mov    %ebx,0x805400

	fsenv = ipc_find_env(ENV_TYPE_FS);
  80004d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800054:	e8 df 14 00 00       	call   801538 <ipc_find_env>
	ipc_send(fsenv, FSREQ_OPEN, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800059:	6a 07                	push   $0x7
  80005b:	68 00 50 80 00       	push   $0x805000
  800060:	6a 01                	push   $0x1
  800062:	50                   	push   %eax
  800063:	e8 74 14 00 00       	call   8014dc <ipc_send>
	return ipc_recv(NULL, FVA, NULL);
  800068:	83 c4 1c             	add    $0x1c,%esp
  80006b:	6a 00                	push   $0x0
  80006d:	68 00 c0 cc cc       	push   $0xccccc000
  800072:	6a 00                	push   $0x0
  800074:	e8 da 13 00 00       	call   801453 <ipc_recv>
}
  800079:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80007c:	c9                   	leave  
  80007d:	c3                   	ret    

0080007e <umain>:

void
umain(int argc, char **argv)
{
  80007e:	55                   	push   %ebp
  80007f:	89 e5                	mov    %esp,%ebp
  800081:	57                   	push   %edi
  800082:	56                   	push   %esi
  800083:	53                   	push   %ebx
  800084:	81 ec ac 02 00 00    	sub    $0x2ac,%esp
	struct Fd fdcopy;
	struct Stat st;
	char buf[512];

	// We open files manually first, to avoid the FD layer
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  80008a:	ba 00 00 00 00       	mov    $0x0,%edx
  80008f:	b8 20 25 80 00       	mov    $0x802520,%eax
  800094:	e8 9a ff ff ff       	call   800033 <xopen>
  800099:	85 c0                	test   %eax,%eax
  80009b:	78 14                	js     8000b1 <umain+0x33>
		panic("serve_open /not-found: %e", r);
	else if (r >= 0)
		panic("serve_open /not-found succeeded!");
  80009d:	83 ec 04             	sub    $0x4,%esp
  8000a0:	68 e0 26 80 00       	push   $0x8026e0
  8000a5:	6a 22                	push   $0x22
  8000a7:	68 45 25 80 00       	push   $0x802545
  8000ac:	e8 1d 06 00 00       	call   8006ce <_panic>
	if ((r = xopen("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  8000b1:	83 f8 f5             	cmp    $0xfffffff5,%eax
  8000b4:	0f 85 85 02 00 00    	jne    80033f <umain+0x2c1>

	if ((r = xopen("/newmotd", O_RDONLY)) < 0)
  8000ba:	ba 00 00 00 00       	mov    $0x0,%edx
  8000bf:	b8 55 25 80 00       	mov    $0x802555,%eax
  8000c4:	e8 6a ff ff ff       	call   800033 <xopen>
  8000c9:	85 c0                	test   %eax,%eax
  8000cb:	0f 88 80 02 00 00    	js     800351 <umain+0x2d3>
		panic("serve_open /newmotd: %e", r);
	if (FVA->fd_dev_id != 'f' || FVA->fd_offset != 0 || FVA->fd_omode != O_RDONLY)
  8000d1:	83 3d 00 c0 cc cc 66 	cmpl   $0x66,0xccccc000
  8000d8:	0f 85 85 02 00 00    	jne    800363 <umain+0x2e5>
  8000de:	83 3d 04 c0 cc cc 00 	cmpl   $0x0,0xccccc004
  8000e5:	0f 85 78 02 00 00    	jne    800363 <umain+0x2e5>
  8000eb:	83 3d 08 c0 cc cc 00 	cmpl   $0x0,0xccccc008
  8000f2:	0f 85 6b 02 00 00    	jne    800363 <umain+0x2e5>
		panic("serve_open did not fill struct Fd correctly\n");
	cprintf("serve_open is good\n");
  8000f8:	83 ec 0c             	sub    $0xc,%esp
  8000fb:	68 76 25 80 00       	push   $0x802576
  800100:	e8 dc 06 00 00       	call   8007e1 <cprintf>

	if ((r = devfile.dev_stat(FVA, &st)) < 0)
  800105:	83 c4 08             	add    $0x8,%esp
  800108:	8d 85 4c ff ff ff    	lea    -0xb4(%ebp),%eax
  80010e:	50                   	push   %eax
  80010f:	68 00 c0 cc cc       	push   $0xccccc000
  800114:	ff 15 1c 30 80 00    	call   *0x80301c
  80011a:	83 c4 10             	add    $0x10,%esp
  80011d:	85 c0                	test   %eax,%eax
  80011f:	0f 88 52 02 00 00    	js     800377 <umain+0x2f9>
		panic("file_stat: %e", r);
	if (strlen(msg) != st.st_size)
  800125:	83 ec 0c             	sub    $0xc,%esp
  800128:	ff 35 00 30 80 00    	pushl  0x803000
  80012e:	e8 83 0c 00 00       	call   800db6 <strlen>
  800133:	83 c4 10             	add    $0x10,%esp
  800136:	3b 45 cc             	cmp    -0x34(%ebp),%eax
  800139:	0f 85 4a 02 00 00    	jne    800389 <umain+0x30b>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
	cprintf("file_stat is good\n");
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 98 25 80 00       	push   $0x802598
  800147:	e8 95 06 00 00       	call   8007e1 <cprintf>

	memset(buf, 0, sizeof buf);
  80014c:	83 c4 0c             	add    $0xc,%esp
  80014f:	68 00 02 00 00       	push   $0x200
  800154:	6a 00                	push   $0x0
  800156:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  80015c:	53                   	push   %ebx
  80015d:	e8 ad 0d 00 00       	call   800f0f <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  800162:	83 c4 0c             	add    $0xc,%esp
  800165:	68 00 02 00 00       	push   $0x200
  80016a:	53                   	push   %ebx
  80016b:	68 00 c0 cc cc       	push   $0xccccc000
  800170:	ff 15 10 30 80 00    	call   *0x803010
  800176:	83 c4 10             	add    $0x10,%esp
  800179:	85 c0                	test   %eax,%eax
  80017b:	0f 88 2d 02 00 00    	js     8003ae <umain+0x330>
		panic("file_read: %e", r);
	if (strcmp(buf, msg) != 0)
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	ff 35 00 30 80 00    	pushl  0x803000
  80018a:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  800190:	50                   	push   %eax
  800191:	e8 f0 0c 00 00       	call   800e86 <strcmp>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	85 c0                	test   %eax,%eax
  80019b:	0f 85 1f 02 00 00    	jne    8003c0 <umain+0x342>
		panic("file_read returned wrong data");
	cprintf("file_read is good\n");
  8001a1:	83 ec 0c             	sub    $0xc,%esp
  8001a4:	68 d7 25 80 00       	push   $0x8025d7
  8001a9:	e8 33 06 00 00       	call   8007e1 <cprintf>

	if ((r = devfile.dev_close(FVA)) < 0)
  8001ae:	c7 04 24 00 c0 cc cc 	movl   $0xccccc000,(%esp)
  8001b5:	ff 15 18 30 80 00    	call   *0x803018
  8001bb:	83 c4 10             	add    $0x10,%esp
  8001be:	85 c0                	test   %eax,%eax
  8001c0:	0f 88 0e 02 00 00    	js     8003d4 <umain+0x356>
		panic("file_close: %e", r);
	cprintf("file_close is good\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 f9 25 80 00       	push   $0x8025f9
  8001ce:	e8 0e 06 00 00       	call   8007e1 <cprintf>

	// We're about to unmap the FD, but still need a way to get
	// the stale filenum to serve_read, so we make a local copy.
	// The file server won't think it's stale until we unmap the
	// FD page.
	fdcopy = *FVA;
  8001d3:	be 00 c0 cc cc       	mov    $0xccccc000,%esi
  8001d8:	8d 7d d8             	lea    -0x28(%ebp),%edi
  8001db:	b9 04 00 00 00       	mov    $0x4,%ecx
  8001e0:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
	sys_page_unmap(0, FVA);
  8001e2:	83 c4 08             	add    $0x8,%esp
  8001e5:	68 00 c0 cc cc       	push   $0xccccc000
  8001ea:	6a 00                	push   $0x0
  8001ec:	e8 32 10 00 00       	call   801223 <sys_page_unmap>

	if ((r = devfile.dev_read(&fdcopy, buf, sizeof buf)) != -E_INVAL)
  8001f1:	83 c4 0c             	add    $0xc,%esp
  8001f4:	68 00 02 00 00       	push   $0x200
  8001f9:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8001ff:	50                   	push   %eax
  800200:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800203:	50                   	push   %eax
  800204:	ff 15 10 30 80 00    	call   *0x803010
  80020a:	83 c4 10             	add    $0x10,%esp
  80020d:	83 f8 fd             	cmp    $0xfffffffd,%eax
  800210:	0f 85 d0 01 00 00    	jne    8003e6 <umain+0x368>
		panic("serve_read does not handle stale fileids correctly: %e", r);
	cprintf("stale fileid is good\n");
  800216:	83 ec 0c             	sub    $0xc,%esp
  800219:	68 0d 26 80 00       	push   $0x80260d
  80021e:	e8 be 05 00 00       	call   8007e1 <cprintf>

	// Try writing
	if ((r = xopen("/new-file", O_RDWR|O_CREAT)) < 0)
  800223:	ba 02 01 00 00       	mov    $0x102,%edx
  800228:	b8 23 26 80 00       	mov    $0x802623,%eax
  80022d:	e8 01 fe ff ff       	call   800033 <xopen>
  800232:	83 c4 10             	add    $0x10,%esp
  800235:	85 c0                	test   %eax,%eax
  800237:	0f 88 bb 01 00 00    	js     8003f8 <umain+0x37a>
		panic("serve_open /new-file: %e", r);

	if ((r = devfile.dev_write(FVA, msg, strlen(msg))) != strlen(msg))
  80023d:	8b 1d 14 30 80 00    	mov    0x803014,%ebx
  800243:	83 ec 0c             	sub    $0xc,%esp
  800246:	ff 35 00 30 80 00    	pushl  0x803000
  80024c:	e8 65 0b 00 00       	call   800db6 <strlen>
  800251:	83 c4 0c             	add    $0xc,%esp
  800254:	50                   	push   %eax
  800255:	ff 35 00 30 80 00    	pushl  0x803000
  80025b:	68 00 c0 cc cc       	push   $0xccccc000
  800260:	ff d3                	call   *%ebx
  800262:	89 c3                	mov    %eax,%ebx
  800264:	83 c4 04             	add    $0x4,%esp
  800267:	ff 35 00 30 80 00    	pushl  0x803000
  80026d:	e8 44 0b 00 00       	call   800db6 <strlen>
  800272:	83 c4 10             	add    $0x10,%esp
  800275:	39 c3                	cmp    %eax,%ebx
  800277:	0f 85 8d 01 00 00    	jne    80040a <umain+0x38c>
		panic("file_write: %e", r);
	cprintf("file_write is good\n");
  80027d:	83 ec 0c             	sub    $0xc,%esp
  800280:	68 55 26 80 00       	push   $0x802655
  800285:	e8 57 05 00 00       	call   8007e1 <cprintf>

	FVA->fd_offset = 0;
  80028a:	c7 05 04 c0 cc cc 00 	movl   $0x0,0xccccc004
  800291:	00 00 00 
	memset(buf, 0, sizeof buf);
  800294:	83 c4 0c             	add    $0xc,%esp
  800297:	68 00 02 00 00       	push   $0x200
  80029c:	6a 00                	push   $0x0
  80029e:	8d 9d 4c fd ff ff    	lea    -0x2b4(%ebp),%ebx
  8002a4:	53                   	push   %ebx
  8002a5:	e8 65 0c 00 00       	call   800f0f <memset>
	if ((r = devfile.dev_read(FVA, buf, sizeof buf)) < 0)
  8002aa:	83 c4 0c             	add    $0xc,%esp
  8002ad:	68 00 02 00 00       	push   $0x200
  8002b2:	53                   	push   %ebx
  8002b3:	68 00 c0 cc cc       	push   $0xccccc000
  8002b8:	ff 15 10 30 80 00    	call   *0x803010
  8002be:	89 c3                	mov    %eax,%ebx
  8002c0:	83 c4 10             	add    $0x10,%esp
  8002c3:	85 c0                	test   %eax,%eax
  8002c5:	0f 88 51 01 00 00    	js     80041c <umain+0x39e>
		panic("file_read after file_write: %e", r);
	if (r != strlen(msg))
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	ff 35 00 30 80 00    	pushl  0x803000
  8002d4:	e8 dd 0a 00 00       	call   800db6 <strlen>
  8002d9:	83 c4 10             	add    $0x10,%esp
  8002dc:	39 c3                	cmp    %eax,%ebx
  8002de:	0f 85 4a 01 00 00    	jne    80042e <umain+0x3b0>
		panic("file_read after file_write returned wrong length: %d", r);
	if (strcmp(buf, msg) != 0)
  8002e4:	83 ec 08             	sub    $0x8,%esp
  8002e7:	ff 35 00 30 80 00    	pushl  0x803000
  8002ed:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8002f3:	50                   	push   %eax
  8002f4:	e8 8d 0b 00 00       	call   800e86 <strcmp>
  8002f9:	83 c4 10             	add    $0x10,%esp
  8002fc:	85 c0                	test   %eax,%eax
  8002fe:	0f 85 3c 01 00 00    	jne    800440 <umain+0x3c2>
		panic("file_read after file_write returned wrong data");
	cprintf("file_read after file_write is good\n");
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	68 1c 28 80 00       	push   $0x80281c
  80030c:	e8 d0 04 00 00       	call   8007e1 <cprintf>

	// Now we'll try out open
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800311:	83 c4 08             	add    $0x8,%esp
  800314:	6a 00                	push   $0x0
  800316:	68 20 25 80 00       	push   $0x802520
  80031b:	e8 ef 19 00 00       	call   801d0f <open>
  800320:	83 c4 10             	add    $0x10,%esp
  800323:	85 c0                	test   %eax,%eax
  800325:	0f 88 29 01 00 00    	js     800454 <umain+0x3d6>
		panic("open /not-found: %e", r);
	else if (r >= 0)
		panic("open /not-found succeeded!");
  80032b:	83 ec 04             	sub    $0x4,%esp
  80032e:	68 69 26 80 00       	push   $0x802669
  800333:	6a 5c                	push   $0x5c
  800335:	68 45 25 80 00       	push   $0x802545
  80033a:	e8 8f 03 00 00       	call   8006ce <_panic>
		panic("serve_open /not-found: %e", r);
  80033f:	50                   	push   %eax
  800340:	68 2b 25 80 00       	push   $0x80252b
  800345:	6a 20                	push   $0x20
  800347:	68 45 25 80 00       	push   $0x802545
  80034c:	e8 7d 03 00 00       	call   8006ce <_panic>
		panic("serve_open /newmotd: %e", r);
  800351:	50                   	push   %eax
  800352:	68 5e 25 80 00       	push   $0x80255e
  800357:	6a 25                	push   $0x25
  800359:	68 45 25 80 00       	push   $0x802545
  80035e:	e8 6b 03 00 00       	call   8006ce <_panic>
		panic("serve_open did not fill struct Fd correctly\n");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 04 27 80 00       	push   $0x802704
  80036b:	6a 27                	push   $0x27
  80036d:	68 45 25 80 00       	push   $0x802545
  800372:	e8 57 03 00 00       	call   8006ce <_panic>
		panic("file_stat: %e", r);
  800377:	50                   	push   %eax
  800378:	68 8a 25 80 00       	push   $0x80258a
  80037d:	6a 2b                	push   $0x2b
  80037f:	68 45 25 80 00       	push   $0x802545
  800384:	e8 45 03 00 00       	call   8006ce <_panic>
		panic("file_stat returned size %d wanted %d\n", st.st_size, strlen(msg));
  800389:	83 ec 0c             	sub    $0xc,%esp
  80038c:	ff 35 00 30 80 00    	pushl  0x803000
  800392:	e8 1f 0a 00 00       	call   800db6 <strlen>
  800397:	89 04 24             	mov    %eax,(%esp)
  80039a:	ff 75 cc             	pushl  -0x34(%ebp)
  80039d:	68 34 27 80 00       	push   $0x802734
  8003a2:	6a 2d                	push   $0x2d
  8003a4:	68 45 25 80 00       	push   $0x802545
  8003a9:	e8 20 03 00 00       	call   8006ce <_panic>
		panic("file_read: %e", r);
  8003ae:	50                   	push   %eax
  8003af:	68 ab 25 80 00       	push   $0x8025ab
  8003b4:	6a 32                	push   $0x32
  8003b6:	68 45 25 80 00       	push   $0x802545
  8003bb:	e8 0e 03 00 00       	call   8006ce <_panic>
		panic("file_read returned wrong data");
  8003c0:	83 ec 04             	sub    $0x4,%esp
  8003c3:	68 b9 25 80 00       	push   $0x8025b9
  8003c8:	6a 34                	push   $0x34
  8003ca:	68 45 25 80 00       	push   $0x802545
  8003cf:	e8 fa 02 00 00       	call   8006ce <_panic>
		panic("file_close: %e", r);
  8003d4:	50                   	push   %eax
  8003d5:	68 ea 25 80 00       	push   $0x8025ea
  8003da:	6a 38                	push   $0x38
  8003dc:	68 45 25 80 00       	push   $0x802545
  8003e1:	e8 e8 02 00 00       	call   8006ce <_panic>
		panic("serve_read does not handle stale fileids correctly: %e", r);
  8003e6:	50                   	push   %eax
  8003e7:	68 5c 27 80 00       	push   $0x80275c
  8003ec:	6a 43                	push   $0x43
  8003ee:	68 45 25 80 00       	push   $0x802545
  8003f3:	e8 d6 02 00 00       	call   8006ce <_panic>
		panic("serve_open /new-file: %e", r);
  8003f8:	50                   	push   %eax
  8003f9:	68 2d 26 80 00       	push   $0x80262d
  8003fe:	6a 48                	push   $0x48
  800400:	68 45 25 80 00       	push   $0x802545
  800405:	e8 c4 02 00 00       	call   8006ce <_panic>
		panic("file_write: %e", r);
  80040a:	53                   	push   %ebx
  80040b:	68 46 26 80 00       	push   $0x802646
  800410:	6a 4b                	push   $0x4b
  800412:	68 45 25 80 00       	push   $0x802545
  800417:	e8 b2 02 00 00       	call   8006ce <_panic>
		panic("file_read after file_write: %e", r);
  80041c:	50                   	push   %eax
  80041d:	68 94 27 80 00       	push   $0x802794
  800422:	6a 51                	push   $0x51
  800424:	68 45 25 80 00       	push   $0x802545
  800429:	e8 a0 02 00 00       	call   8006ce <_panic>
		panic("file_read after file_write returned wrong length: %d", r);
  80042e:	53                   	push   %ebx
  80042f:	68 b4 27 80 00       	push   $0x8027b4
  800434:	6a 53                	push   $0x53
  800436:	68 45 25 80 00       	push   $0x802545
  80043b:	e8 8e 02 00 00       	call   8006ce <_panic>
		panic("file_read after file_write returned wrong data");
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 ec 27 80 00       	push   $0x8027ec
  800448:	6a 55                	push   $0x55
  80044a:	68 45 25 80 00       	push   $0x802545
  80044f:	e8 7a 02 00 00       	call   8006ce <_panic>
	if ((r = open("/not-found", O_RDONLY)) < 0 && r != -E_NOT_FOUND)
  800454:	83 f8 f5             	cmp    $0xfffffff5,%eax
  800457:	0f 85 52 01 00 00    	jne    8005af <umain+0x531>

	if ((r = open("/newmotd", O_RDONLY)) < 0)
  80045d:	83 ec 08             	sub    $0x8,%esp
  800460:	6a 00                	push   $0x0
  800462:	68 55 25 80 00       	push   $0x802555
  800467:	e8 a3 18 00 00       	call   801d0f <open>
  80046c:	83 c4 10             	add    $0x10,%esp
  80046f:	85 c0                	test   %eax,%eax
  800471:	0f 88 4a 01 00 00    	js     8005c1 <umain+0x543>
		panic("open /newmotd: %e", r);
	fd = (struct Fd*) (0xD0000000 + r*PGSIZE);
  800477:	c1 e0 0c             	shl    $0xc,%eax
	if (fd->fd_dev_id != 'f' || fd->fd_offset != 0 || fd->fd_omode != O_RDONLY)
  80047a:	83 b8 00 00 00 d0 66 	cmpl   $0x66,-0x30000000(%eax)
  800481:	0f 85 4c 01 00 00    	jne    8005d3 <umain+0x555>
  800487:	83 b8 04 00 00 d0 00 	cmpl   $0x0,-0x2ffffffc(%eax)
  80048e:	0f 85 3f 01 00 00    	jne    8005d3 <umain+0x555>
  800494:	8b 98 08 00 00 d0    	mov    -0x2ffffff8(%eax),%ebx
  80049a:	85 db                	test   %ebx,%ebx
  80049c:	0f 85 31 01 00 00    	jne    8005d3 <umain+0x555>
		panic("open did not fill struct Fd correctly\n");
	cprintf("open is good\n");
  8004a2:	83 ec 0c             	sub    $0xc,%esp
  8004a5:	68 7c 25 80 00       	push   $0x80257c
  8004aa:	e8 32 03 00 00       	call   8007e1 <cprintf>

	// Try files with indirect blocks
	if ((f = open("/big", O_WRONLY|O_CREAT)) < 0)
  8004af:	83 c4 08             	add    $0x8,%esp
  8004b2:	68 01 01 00 00       	push   $0x101
  8004b7:	68 84 26 80 00       	push   $0x802684
  8004bc:	e8 4e 18 00 00       	call   801d0f <open>
  8004c1:	89 c7                	mov    %eax,%edi
  8004c3:	83 c4 10             	add    $0x10,%esp
  8004c6:	85 c0                	test   %eax,%eax
  8004c8:	0f 88 19 01 00 00    	js     8005e7 <umain+0x569>
		panic("creat /big: %e", f);
	memset(buf, 0, sizeof(buf));
  8004ce:	83 ec 04             	sub    $0x4,%esp
  8004d1:	68 00 02 00 00       	push   $0x200
  8004d6:	6a 00                	push   $0x0
  8004d8:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004de:	50                   	push   %eax
  8004df:	e8 2b 0a 00 00       	call   800f0f <memset>
  8004e4:	83 c4 10             	add    $0x10,%esp
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  8004e7:	89 de                	mov    %ebx,%esi
		*(int*)buf = i;
  8004e9:	89 b5 4c fd ff ff    	mov    %esi,-0x2b4(%ebp)
		if ((r = write(f, buf, sizeof(buf))) < 0)
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 00 02 00 00       	push   $0x200
  8004f7:	8d 85 4c fd ff ff    	lea    -0x2b4(%ebp),%eax
  8004fd:	50                   	push   %eax
  8004fe:	57                   	push   %edi
  8004ff:	e8 27 14 00 00       	call   80192b <write>
  800504:	83 c4 10             	add    $0x10,%esp
  800507:	85 c0                	test   %eax,%eax
  800509:	0f 88 ea 00 00 00    	js     8005f9 <umain+0x57b>
  80050f:	81 c6 00 02 00 00    	add    $0x200,%esi
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800515:	81 fe 00 e0 01 00    	cmp    $0x1e000,%esi
  80051b:	75 cc                	jne    8004e9 <umain+0x46b>
			panic("write /big@%d: %e", i, r);
	}
	close(f);
  80051d:	83 ec 0c             	sub    $0xc,%esp
  800520:	57                   	push   %edi
  800521:	e8 fd 11 00 00       	call   801723 <close>

	if ((f = open("/big", O_RDONLY)) < 0)
  800526:	83 c4 08             	add    $0x8,%esp
  800529:	6a 00                	push   $0x0
  80052b:	68 84 26 80 00       	push   $0x802684
  800530:	e8 da 17 00 00       	call   801d0f <open>
  800535:	89 c6                	mov    %eax,%esi
  800537:	83 c4 10             	add    $0x10,%esp
  80053a:	85 c0                	test   %eax,%eax
  80053c:	0f 88 cd 00 00 00    	js     80060f <umain+0x591>
		panic("open /big: %e", f);
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
		*(int*)buf = i;
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  800542:	8d bd 4c fd ff ff    	lea    -0x2b4(%ebp),%edi
		*(int*)buf = i;
  800548:	89 9d 4c fd ff ff    	mov    %ebx,-0x2b4(%ebp)
		if ((r = readn(f, buf, sizeof(buf))) < 0)
  80054e:	83 ec 04             	sub    $0x4,%esp
  800551:	68 00 02 00 00       	push   $0x200
  800556:	57                   	push   %edi
  800557:	56                   	push   %esi
  800558:	e8 87 13 00 00       	call   8018e4 <readn>
  80055d:	83 c4 10             	add    $0x10,%esp
  800560:	85 c0                	test   %eax,%eax
  800562:	0f 88 b9 00 00 00    	js     800621 <umain+0x5a3>
			panic("read /big@%d: %e", i, r);
		if (r != sizeof(buf))
  800568:	3d 00 02 00 00       	cmp    $0x200,%eax
  80056d:	0f 85 c4 00 00 00    	jne    800637 <umain+0x5b9>
			panic("read /big from %d returned %d < %d bytes",
			      i, r, sizeof(buf));
		if (*(int*)buf != i)
  800573:	8b 85 4c fd ff ff    	mov    -0x2b4(%ebp),%eax
  800579:	39 d8                	cmp    %ebx,%eax
  80057b:	0f 85 d1 00 00 00    	jne    800652 <umain+0x5d4>
  800581:	81 c3 00 02 00 00    	add    $0x200,%ebx
	for (i = 0; i < (NDIRECT*3)*BLKSIZE; i += sizeof(buf)) {
  800587:	81 fb 00 e0 01 00    	cmp    $0x1e000,%ebx
  80058d:	75 b9                	jne    800548 <umain+0x4ca>
			panic("read /big from %d returned bad data %d",
			      i, *(int*)buf);
	}
	close(f);
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	56                   	push   %esi
  800593:	e8 8b 11 00 00       	call   801723 <close>
	cprintf("large file is good\n");
  800598:	c7 04 24 c9 26 80 00 	movl   $0x8026c9,(%esp)
  80059f:	e8 3d 02 00 00       	call   8007e1 <cprintf>
}
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005aa:	5b                   	pop    %ebx
  8005ab:	5e                   	pop    %esi
  8005ac:	5f                   	pop    %edi
  8005ad:	5d                   	pop    %ebp
  8005ae:	c3                   	ret    
		panic("open /not-found: %e", r);
  8005af:	50                   	push   %eax
  8005b0:	68 31 25 80 00       	push   $0x802531
  8005b5:	6a 5a                	push   $0x5a
  8005b7:	68 45 25 80 00       	push   $0x802545
  8005bc:	e8 0d 01 00 00       	call   8006ce <_panic>
		panic("open /newmotd: %e", r);
  8005c1:	50                   	push   %eax
  8005c2:	68 64 25 80 00       	push   $0x802564
  8005c7:	6a 5f                	push   $0x5f
  8005c9:	68 45 25 80 00       	push   $0x802545
  8005ce:	e8 fb 00 00 00       	call   8006ce <_panic>
		panic("open did not fill struct Fd correctly\n");
  8005d3:	83 ec 04             	sub    $0x4,%esp
  8005d6:	68 40 28 80 00       	push   $0x802840
  8005db:	6a 62                	push   $0x62
  8005dd:	68 45 25 80 00       	push   $0x802545
  8005e2:	e8 e7 00 00 00       	call   8006ce <_panic>
		panic("creat /big: %e", f);
  8005e7:	50                   	push   %eax
  8005e8:	68 89 26 80 00       	push   $0x802689
  8005ed:	6a 67                	push   $0x67
  8005ef:	68 45 25 80 00       	push   $0x802545
  8005f4:	e8 d5 00 00 00       	call   8006ce <_panic>
			panic("write /big@%d: %e", i, r);
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	56                   	push   %esi
  8005fe:	68 98 26 80 00       	push   $0x802698
  800603:	6a 6c                	push   $0x6c
  800605:	68 45 25 80 00       	push   $0x802545
  80060a:	e8 bf 00 00 00       	call   8006ce <_panic>
		panic("open /big: %e", f);
  80060f:	50                   	push   %eax
  800610:	68 aa 26 80 00       	push   $0x8026aa
  800615:	6a 71                	push   $0x71
  800617:	68 45 25 80 00       	push   $0x802545
  80061c:	e8 ad 00 00 00       	call   8006ce <_panic>
			panic("read /big@%d: %e", i, r);
  800621:	83 ec 0c             	sub    $0xc,%esp
  800624:	50                   	push   %eax
  800625:	53                   	push   %ebx
  800626:	68 b8 26 80 00       	push   $0x8026b8
  80062b:	6a 75                	push   $0x75
  80062d:	68 45 25 80 00       	push   $0x802545
  800632:	e8 97 00 00 00       	call   8006ce <_panic>
			panic("read /big from %d returned %d < %d bytes",
  800637:	83 ec 08             	sub    $0x8,%esp
  80063a:	68 00 02 00 00       	push   $0x200
  80063f:	50                   	push   %eax
  800640:	53                   	push   %ebx
  800641:	68 68 28 80 00       	push   $0x802868
  800646:	6a 78                	push   $0x78
  800648:	68 45 25 80 00       	push   $0x802545
  80064d:	e8 7c 00 00 00       	call   8006ce <_panic>
			panic("read /big from %d returned bad data %d",
  800652:	83 ec 0c             	sub    $0xc,%esp
  800655:	50                   	push   %eax
  800656:	53                   	push   %ebx
  800657:	68 94 28 80 00       	push   $0x802894
  80065c:	6a 7b                	push   $0x7b
  80065e:	68 45 25 80 00       	push   $0x802545
  800663:	e8 66 00 00 00       	call   8006ce <_panic>

00800668 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800668:	55                   	push   %ebp
  800669:	89 e5                	mov    %esp,%ebp
  80066b:	56                   	push   %esi
  80066c:	53                   	push   %ebx
  80066d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800670:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800673:	e8 07 0b 00 00       	call   80117f <sys_getenvid>
  800678:	25 ff 03 00 00       	and    $0x3ff,%eax
  80067d:	89 c2                	mov    %eax,%edx
  80067f:	c1 e2 05             	shl    $0x5,%edx
  800682:	29 c2                	sub    %eax,%edx
  800684:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80068b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800690:	85 db                	test   %ebx,%ebx
  800692:	7e 07                	jle    80069b <libmain+0x33>
		binaryname = argv[0];
  800694:	8b 06                	mov    (%esi),%eax
  800696:	a3 04 30 80 00       	mov    %eax,0x803004

	// call user main routine
	umain(argc, argv);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	56                   	push   %esi
  80069f:	53                   	push   %ebx
  8006a0:	e8 d9 f9 ff ff       	call   80007e <umain>

	// exit gracefully
	exit();
  8006a5:	e8 0a 00 00 00       	call   8006b4 <exit>
}
  8006aa:	83 c4 10             	add    $0x10,%esp
  8006ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8006b0:	5b                   	pop    %ebx
  8006b1:	5e                   	pop    %esi
  8006b2:	5d                   	pop    %ebp
  8006b3:	c3                   	ret    

008006b4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8006b4:	55                   	push   %ebp
  8006b5:	89 e5                	mov    %esp,%ebp
  8006b7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8006ba:	e8 8f 10 00 00       	call   80174e <close_all>
	sys_env_destroy(0);
  8006bf:	83 ec 0c             	sub    $0xc,%esp
  8006c2:	6a 00                	push   $0x0
  8006c4:	e8 75 0a 00 00       	call   80113e <sys_env_destroy>
}
  8006c9:	83 c4 10             	add    $0x10,%esp
  8006cc:	c9                   	leave  
  8006cd:	c3                   	ret    

008006ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8006ce:	55                   	push   %ebp
  8006cf:	89 e5                	mov    %esp,%ebp
  8006d1:	57                   	push   %edi
  8006d2:	56                   	push   %esi
  8006d3:	53                   	push   %ebx
  8006d4:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  8006da:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  8006dd:	8b 1d 04 30 80 00    	mov    0x803004,%ebx
  8006e3:	e8 97 0a 00 00       	call   80117f <sys_getenvid>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	ff 75 08             	pushl  0x8(%ebp)
  8006f1:	53                   	push   %ebx
  8006f2:	50                   	push   %eax
  8006f3:	68 ec 28 80 00       	push   $0x8028ec
  8006f8:	68 00 01 00 00       	push   $0x100
  8006fd:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  800703:	56                   	push   %esi
  800704:	e8 93 06 00 00       	call   800d9c <snprintf>
  800709:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80070b:	83 c4 20             	add    $0x20,%esp
  80070e:	57                   	push   %edi
  80070f:	ff 75 10             	pushl  0x10(%ebp)
  800712:	bf 00 01 00 00       	mov    $0x100,%edi
  800717:	89 f8                	mov    %edi,%eax
  800719:	29 d8                	sub    %ebx,%eax
  80071b:	50                   	push   %eax
  80071c:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80071f:	50                   	push   %eax
  800720:	e8 22 06 00 00       	call   800d47 <vsnprintf>
  800725:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  800727:	83 c4 0c             	add    $0xc,%esp
  80072a:	68 56 2d 80 00       	push   $0x802d56
  80072f:	29 df                	sub    %ebx,%edi
  800731:	57                   	push   %edi
  800732:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  800735:	50                   	push   %eax
  800736:	e8 61 06 00 00       	call   800d9c <snprintf>
	sys_cputs(buf, r);
  80073b:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80073e:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  800740:	53                   	push   %ebx
  800741:	56                   	push   %esi
  800742:	e8 ba 09 00 00       	call   801101 <sys_cputs>
  800747:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  80074a:	cc                   	int3   
  80074b:	eb fd                	jmp    80074a <_panic+0x7c>

0080074d <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80074d:	55                   	push   %ebp
  80074e:	89 e5                	mov    %esp,%ebp
  800750:	53                   	push   %ebx
  800751:	83 ec 04             	sub    $0x4,%esp
  800754:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  800757:	8b 13                	mov    (%ebx),%edx
  800759:	8d 42 01             	lea    0x1(%edx),%eax
  80075c:	89 03                	mov    %eax,(%ebx)
  80075e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800761:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  800765:	3d ff 00 00 00       	cmp    $0xff,%eax
  80076a:	74 08                	je     800774 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80076c:	ff 43 04             	incl   0x4(%ebx)
}
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  800774:	83 ec 08             	sub    $0x8,%esp
  800777:	68 ff 00 00 00       	push   $0xff
  80077c:	8d 43 08             	lea    0x8(%ebx),%eax
  80077f:	50                   	push   %eax
  800780:	e8 7c 09 00 00       	call   801101 <sys_cputs>
		b->idx = 0;
  800785:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	eb dc                	jmp    80076c <putch+0x1f>

00800790 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800799:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8007a0:	00 00 00 
	b.cnt = 0;
  8007a3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8007aa:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b9:	50                   	push   %eax
  8007ba:	68 4d 07 80 00       	push   $0x80074d
  8007bf:	e8 17 01 00 00       	call   8008db <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8007c4:	83 c4 08             	add    $0x8,%esp
  8007c7:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8007cd:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  8007d3:	50                   	push   %eax
  8007d4:	e8 28 09 00 00       	call   801101 <sys_cputs>

	return b.cnt;
}
  8007d9:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  8007df:	c9                   	leave  
  8007e0:	c3                   	ret    

008007e1 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007e7:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  8007ea:	50                   	push   %eax
  8007eb:	ff 75 08             	pushl  0x8(%ebp)
  8007ee:	e8 9d ff ff ff       	call   800790 <vcprintf>
	va_end(ap);

	return cnt;
}
  8007f3:	c9                   	leave  
  8007f4:	c3                   	ret    

008007f5 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f5:	55                   	push   %ebp
  8007f6:	89 e5                	mov    %esp,%ebp
  8007f8:	57                   	push   %edi
  8007f9:	56                   	push   %esi
  8007fa:	53                   	push   %ebx
  8007fb:	83 ec 1c             	sub    $0x1c,%esp
  8007fe:	89 c7                	mov    %eax,%edi
  800800:	89 d6                	mov    %edx,%esi
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	8b 55 0c             	mov    0xc(%ebp),%edx
  800808:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80080b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  800811:	bb 00 00 00 00       	mov    $0x0,%ebx
  800816:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800819:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80081c:	39 d3                	cmp    %edx,%ebx
  80081e:	72 05                	jb     800825 <printnum+0x30>
  800820:	39 45 10             	cmp    %eax,0x10(%ebp)
  800823:	77 78                	ja     80089d <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800825:	83 ec 0c             	sub    $0xc,%esp
  800828:	ff 75 18             	pushl  0x18(%ebp)
  80082b:	8b 45 14             	mov    0x14(%ebp),%eax
  80082e:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800831:	53                   	push   %ebx
  800832:	ff 75 10             	pushl  0x10(%ebp)
  800835:	83 ec 08             	sub    $0x8,%esp
  800838:	ff 75 e4             	pushl  -0x1c(%ebp)
  80083b:	ff 75 e0             	pushl  -0x20(%ebp)
  80083e:	ff 75 dc             	pushl  -0x24(%ebp)
  800841:	ff 75 d8             	pushl  -0x28(%ebp)
  800844:	e8 7f 1a 00 00       	call   8022c8 <__udivdi3>
  800849:	83 c4 18             	add    $0x18,%esp
  80084c:	52                   	push   %edx
  80084d:	50                   	push   %eax
  80084e:	89 f2                	mov    %esi,%edx
  800850:	89 f8                	mov    %edi,%eax
  800852:	e8 9e ff ff ff       	call   8007f5 <printnum>
  800857:	83 c4 20             	add    $0x20,%esp
  80085a:	eb 11                	jmp    80086d <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085c:	83 ec 08             	sub    $0x8,%esp
  80085f:	56                   	push   %esi
  800860:	ff 75 18             	pushl  0x18(%ebp)
  800863:	ff d7                	call   *%edi
  800865:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  800868:	4b                   	dec    %ebx
  800869:	85 db                	test   %ebx,%ebx
  80086b:	7f ef                	jg     80085c <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80086d:	83 ec 08             	sub    $0x8,%esp
  800870:	56                   	push   %esi
  800871:	83 ec 04             	sub    $0x4,%esp
  800874:	ff 75 e4             	pushl  -0x1c(%ebp)
  800877:	ff 75 e0             	pushl  -0x20(%ebp)
  80087a:	ff 75 dc             	pushl  -0x24(%ebp)
  80087d:	ff 75 d8             	pushl  -0x28(%ebp)
  800880:	e8 53 1b 00 00       	call   8023d8 <__umoddi3>
  800885:	83 c4 14             	add    $0x14,%esp
  800888:	0f be 80 0f 29 80 00 	movsbl 0x80290f(%eax),%eax
  80088f:	50                   	push   %eax
  800890:	ff d7                	call   *%edi
}
  800892:	83 c4 10             	add    $0x10,%esp
  800895:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800898:	5b                   	pop    %ebx
  800899:	5e                   	pop    %esi
  80089a:	5f                   	pop    %edi
  80089b:	5d                   	pop    %ebp
  80089c:	c3                   	ret    
  80089d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8008a0:	eb c6                	jmp    800868 <printnum+0x73>

008008a2 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8008a2:	55                   	push   %ebp
  8008a3:	89 e5                	mov    %esp,%ebp
  8008a5:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8008a8:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8008ab:	8b 10                	mov    (%eax),%edx
  8008ad:	3b 50 04             	cmp    0x4(%eax),%edx
  8008b0:	73 0a                	jae    8008bc <sprintputch+0x1a>
		*b->buf++ = ch;
  8008b2:	8d 4a 01             	lea    0x1(%edx),%ecx
  8008b5:	89 08                	mov    %ecx,(%eax)
  8008b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ba:	88 02                	mov    %al,(%edx)
}
  8008bc:	5d                   	pop    %ebp
  8008bd:	c3                   	ret    

008008be <printfmt>:
{
  8008be:	55                   	push   %ebp
  8008bf:	89 e5                	mov    %esp,%ebp
  8008c1:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8008c4:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 10             	pushl  0x10(%ebp)
  8008cb:	ff 75 0c             	pushl  0xc(%ebp)
  8008ce:	ff 75 08             	pushl  0x8(%ebp)
  8008d1:	e8 05 00 00 00       	call   8008db <vprintfmt>
}
  8008d6:	83 c4 10             	add    $0x10,%esp
  8008d9:	c9                   	leave  
  8008da:	c3                   	ret    

008008db <vprintfmt>:
{
  8008db:	55                   	push   %ebp
  8008dc:	89 e5                	mov    %esp,%ebp
  8008de:	57                   	push   %edi
  8008df:	56                   	push   %esi
  8008e0:	53                   	push   %ebx
  8008e1:	83 ec 2c             	sub    $0x2c,%esp
  8008e4:	8b 75 08             	mov    0x8(%ebp),%esi
  8008e7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  8008ea:	8b 7d 10             	mov    0x10(%ebp),%edi
  8008ed:	e9 ae 03 00 00       	jmp    800ca0 <vprintfmt+0x3c5>
  8008f2:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  8008f6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  8008fd:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  800904:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80090b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  800910:	8d 47 01             	lea    0x1(%edi),%eax
  800913:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800916:	8a 17                	mov    (%edi),%dl
  800918:	8d 42 dd             	lea    -0x23(%edx),%eax
  80091b:	3c 55                	cmp    $0x55,%al
  80091d:	0f 87 fe 03 00 00    	ja     800d21 <vprintfmt+0x446>
  800923:	0f b6 c0             	movzbl %al,%eax
  800926:	ff 24 85 60 2a 80 00 	jmp    *0x802a60(,%eax,4)
  80092d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  800930:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  800934:	eb da                	jmp    800910 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  800936:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  800939:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80093d:	eb d1                	jmp    800910 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80093f:	0f b6 d2             	movzbl %dl,%edx
  800942:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800945:	b8 00 00 00 00       	mov    $0x0,%eax
  80094a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80094d:	8d 04 80             	lea    (%eax,%eax,4),%eax
  800950:	01 c0                	add    %eax,%eax
  800952:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  800956:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  800959:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80095c:	83 f9 09             	cmp    $0x9,%ecx
  80095f:	77 52                	ja     8009b3 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  800961:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  800962:	eb e9                	jmp    80094d <vprintfmt+0x72>
			precision = va_arg(ap, int);
  800964:	8b 45 14             	mov    0x14(%ebp),%eax
  800967:	8b 00                	mov    (%eax),%eax
  800969:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80096c:	8b 45 14             	mov    0x14(%ebp),%eax
  80096f:	8d 40 04             	lea    0x4(%eax),%eax
  800972:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  800975:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  800978:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097c:	79 92                	jns    800910 <vprintfmt+0x35>
				width = precision, precision = -1;
  80097e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800981:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800984:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80098b:	eb 83                	jmp    800910 <vprintfmt+0x35>
  80098d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800991:	78 08                	js     80099b <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  800993:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  800996:	e9 75 ff ff ff       	jmp    800910 <vprintfmt+0x35>
  80099b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8009a2:	eb ef                	jmp    800993 <vprintfmt+0xb8>
  8009a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8009a7:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8009ae:	e9 5d ff ff ff       	jmp    800910 <vprintfmt+0x35>
  8009b3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8009b6:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8009b9:	eb bd                	jmp    800978 <vprintfmt+0x9d>
			lflag++;
  8009bb:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8009bc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8009bf:	e9 4c ff ff ff       	jmp    800910 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8009c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c7:	8d 78 04             	lea    0x4(%eax),%edi
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	53                   	push   %ebx
  8009ce:	ff 30                	pushl  (%eax)
  8009d0:	ff d6                	call   *%esi
			break;
  8009d2:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  8009d5:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  8009d8:	e9 c0 02 00 00       	jmp    800c9d <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  8009dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8009e0:	8d 78 04             	lea    0x4(%eax),%edi
  8009e3:	8b 00                	mov    (%eax),%eax
  8009e5:	85 c0                	test   %eax,%eax
  8009e7:	78 2a                	js     800a13 <vprintfmt+0x138>
  8009e9:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  8009eb:	83 f8 0f             	cmp    $0xf,%eax
  8009ee:	7f 27                	jg     800a17 <vprintfmt+0x13c>
  8009f0:	8b 04 85 c0 2b 80 00 	mov    0x802bc0(,%eax,4),%eax
  8009f7:	85 c0                	test   %eax,%eax
  8009f9:	74 1c                	je     800a17 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  8009fb:	50                   	push   %eax
  8009fc:	68 81 2c 80 00       	push   $0x802c81
  800a01:	53                   	push   %ebx
  800a02:	56                   	push   %esi
  800a03:	e8 b6 fe ff ff       	call   8008be <printfmt>
  800a08:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a0b:	89 7d 14             	mov    %edi,0x14(%ebp)
  800a0e:	e9 8a 02 00 00       	jmp    800c9d <vprintfmt+0x3c2>
  800a13:	f7 d8                	neg    %eax
  800a15:	eb d2                	jmp    8009e9 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  800a17:	52                   	push   %edx
  800a18:	68 27 29 80 00       	push   $0x802927
  800a1d:	53                   	push   %ebx
  800a1e:	56                   	push   %esi
  800a1f:	e8 9a fe ff ff       	call   8008be <printfmt>
  800a24:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  800a27:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  800a2a:	e9 6e 02 00 00       	jmp    800c9d <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  800a2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a32:	83 c0 04             	add    $0x4,%eax
  800a35:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800a38:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3b:	8b 38                	mov    (%eax),%edi
  800a3d:	85 ff                	test   %edi,%edi
  800a3f:	74 39                	je     800a7a <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  800a41:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a45:	0f 8e a9 00 00 00    	jle    800af4 <vprintfmt+0x219>
  800a4b:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  800a4f:	0f 84 a7 00 00 00    	je     800afc <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a55:	83 ec 08             	sub    $0x8,%esp
  800a58:	ff 75 d0             	pushl  -0x30(%ebp)
  800a5b:	57                   	push   %edi
  800a5c:	e8 6b 03 00 00       	call   800dcc <strnlen>
  800a61:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  800a64:	29 c1                	sub    %eax,%ecx
  800a66:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  800a69:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  800a6c:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  800a70:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800a73:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800a76:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a78:	eb 14                	jmp    800a8e <vprintfmt+0x1b3>
				p = "(null)";
  800a7a:	bf 20 29 80 00       	mov    $0x802920,%edi
  800a7f:	eb c0                	jmp    800a41 <vprintfmt+0x166>
					putch(padc, putdat);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	53                   	push   %ebx
  800a85:	ff 75 e0             	pushl  -0x20(%ebp)
  800a88:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  800a8a:	4f                   	dec    %edi
  800a8b:	83 c4 10             	add    $0x10,%esp
  800a8e:	85 ff                	test   %edi,%edi
  800a90:	7f ef                	jg     800a81 <vprintfmt+0x1a6>
  800a92:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  800a95:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800a98:	89 c8                	mov    %ecx,%eax
  800a9a:	85 c9                	test   %ecx,%ecx
  800a9c:	78 10                	js     800aae <vprintfmt+0x1d3>
  800a9e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  800aa1:	29 c1                	sub    %eax,%ecx
  800aa3:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  800aa6:	89 75 08             	mov    %esi,0x8(%ebp)
  800aa9:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800aac:	eb 15                	jmp    800ac3 <vprintfmt+0x1e8>
  800aae:	b8 00 00 00 00       	mov    $0x0,%eax
  800ab3:	eb e9                	jmp    800a9e <vprintfmt+0x1c3>
					putch(ch, putdat);
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	53                   	push   %ebx
  800ab9:	52                   	push   %edx
  800aba:	ff 55 08             	call   *0x8(%ebp)
  800abd:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800ac0:	ff 4d e0             	decl   -0x20(%ebp)
  800ac3:	47                   	inc    %edi
  800ac4:	8a 47 ff             	mov    -0x1(%edi),%al
  800ac7:	0f be d0             	movsbl %al,%edx
  800aca:	85 d2                	test   %edx,%edx
  800acc:	74 59                	je     800b27 <vprintfmt+0x24c>
  800ace:	85 f6                	test   %esi,%esi
  800ad0:	78 03                	js     800ad5 <vprintfmt+0x1fa>
  800ad2:	4e                   	dec    %esi
  800ad3:	78 2f                	js     800b04 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  800ad5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  800ad9:	74 da                	je     800ab5 <vprintfmt+0x1da>
  800adb:	0f be c0             	movsbl %al,%eax
  800ade:	83 e8 20             	sub    $0x20,%eax
  800ae1:	83 f8 5e             	cmp    $0x5e,%eax
  800ae4:	76 cf                	jbe    800ab5 <vprintfmt+0x1da>
					putch('?', putdat);
  800ae6:	83 ec 08             	sub    $0x8,%esp
  800ae9:	53                   	push   %ebx
  800aea:	6a 3f                	push   $0x3f
  800aec:	ff 55 08             	call   *0x8(%ebp)
  800aef:	83 c4 10             	add    $0x10,%esp
  800af2:	eb cc                	jmp    800ac0 <vprintfmt+0x1e5>
  800af4:	89 75 08             	mov    %esi,0x8(%ebp)
  800af7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800afa:	eb c7                	jmp    800ac3 <vprintfmt+0x1e8>
  800afc:	89 75 08             	mov    %esi,0x8(%ebp)
  800aff:	8b 75 d0             	mov    -0x30(%ebp),%esi
  800b02:	eb bf                	jmp    800ac3 <vprintfmt+0x1e8>
  800b04:	8b 75 08             	mov    0x8(%ebp),%esi
  800b07:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800b0a:	eb 0c                	jmp    800b18 <vprintfmt+0x23d>
				putch(' ', putdat);
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	53                   	push   %ebx
  800b10:	6a 20                	push   $0x20
  800b12:	ff d6                	call   *%esi
			for (; width > 0; width--)
  800b14:	4f                   	dec    %edi
  800b15:	83 c4 10             	add    $0x10,%esp
  800b18:	85 ff                	test   %edi,%edi
  800b1a:	7f f0                	jg     800b0c <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  800b1c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1f:	89 45 14             	mov    %eax,0x14(%ebp)
  800b22:	e9 76 01 00 00       	jmp    800c9d <vprintfmt+0x3c2>
  800b27:	8b 7d e0             	mov    -0x20(%ebp),%edi
  800b2a:	8b 75 08             	mov    0x8(%ebp),%esi
  800b2d:	eb e9                	jmp    800b18 <vprintfmt+0x23d>
	if (lflag >= 2)
  800b2f:	83 f9 01             	cmp    $0x1,%ecx
  800b32:	7f 1f                	jg     800b53 <vprintfmt+0x278>
	else if (lflag)
  800b34:	85 c9                	test   %ecx,%ecx
  800b36:	75 48                	jne    800b80 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	8b 00                	mov    (%eax),%eax
  800b3d:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b40:	89 c1                	mov    %eax,%ecx
  800b42:	c1 f9 1f             	sar    $0x1f,%ecx
  800b45:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b48:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4b:	8d 40 04             	lea    0x4(%eax),%eax
  800b4e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b51:	eb 17                	jmp    800b6a <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  800b53:	8b 45 14             	mov    0x14(%ebp),%eax
  800b56:	8b 50 04             	mov    0x4(%eax),%edx
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b5e:	89 55 dc             	mov    %edx,-0x24(%ebp)
  800b61:	8b 45 14             	mov    0x14(%ebp),%eax
  800b64:	8d 40 08             	lea    0x8(%eax),%eax
  800b67:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  800b6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b6d:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  800b70:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b74:	78 25                	js     800b9b <vprintfmt+0x2c0>
			base = 10;
  800b76:	b8 0a 00 00 00       	mov    $0xa,%eax
  800b7b:	e9 03 01 00 00       	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  800b80:	8b 45 14             	mov    0x14(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800b88:	89 c1                	mov    %eax,%ecx
  800b8a:	c1 f9 1f             	sar    $0x1f,%ecx
  800b8d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  800b90:	8b 45 14             	mov    0x14(%ebp),%eax
  800b93:	8d 40 04             	lea    0x4(%eax),%eax
  800b96:	89 45 14             	mov    %eax,0x14(%ebp)
  800b99:	eb cf                	jmp    800b6a <vprintfmt+0x28f>
				putch('-', putdat);
  800b9b:	83 ec 08             	sub    $0x8,%esp
  800b9e:	53                   	push   %ebx
  800b9f:	6a 2d                	push   $0x2d
  800ba1:	ff d6                	call   *%esi
				num = -(long long) num;
  800ba3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800ba6:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800ba9:	f7 da                	neg    %edx
  800bab:	83 d1 00             	adc    $0x0,%ecx
  800bae:	f7 d9                	neg    %ecx
  800bb0:	83 c4 10             	add    $0x10,%esp
			base = 10;
  800bb3:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bb8:	e9 c6 00 00 00       	jmp    800c83 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800bbd:	83 f9 01             	cmp    $0x1,%ecx
  800bc0:	7f 1e                	jg     800be0 <vprintfmt+0x305>
	else if (lflag)
  800bc2:	85 c9                	test   %ecx,%ecx
  800bc4:	75 32                	jne    800bf8 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  800bc6:	8b 45 14             	mov    0x14(%ebp),%eax
  800bc9:	8b 10                	mov    (%eax),%edx
  800bcb:	b9 00 00 00 00       	mov    $0x0,%ecx
  800bd0:	8d 40 04             	lea    0x4(%eax),%eax
  800bd3:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bd6:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bdb:	e9 a3 00 00 00       	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800be0:	8b 45 14             	mov    0x14(%ebp),%eax
  800be3:	8b 10                	mov    (%eax),%edx
  800be5:	8b 48 04             	mov    0x4(%eax),%ecx
  800be8:	8d 40 08             	lea    0x8(%eax),%eax
  800beb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800bee:	b8 0a 00 00 00       	mov    $0xa,%eax
  800bf3:	e9 8b 00 00 00       	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800bf8:	8b 45 14             	mov    0x14(%ebp),%eax
  800bfb:	8b 10                	mov    (%eax),%edx
  800bfd:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c02:	8d 40 04             	lea    0x4(%eax),%eax
  800c05:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  800c08:	b8 0a 00 00 00       	mov    $0xa,%eax
  800c0d:	eb 74                	jmp    800c83 <vprintfmt+0x3a8>
	if (lflag >= 2)
  800c0f:	83 f9 01             	cmp    $0x1,%ecx
  800c12:	7f 1b                	jg     800c2f <vprintfmt+0x354>
	else if (lflag)
  800c14:	85 c9                	test   %ecx,%ecx
  800c16:	75 2c                	jne    800c44 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  800c18:	8b 45 14             	mov    0x14(%ebp),%eax
  800c1b:	8b 10                	mov    (%eax),%edx
  800c1d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c22:	8d 40 04             	lea    0x4(%eax),%eax
  800c25:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c28:	b8 08 00 00 00       	mov    $0x8,%eax
  800c2d:	eb 54                	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800c2f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c32:	8b 10                	mov    (%eax),%edx
  800c34:	8b 48 04             	mov    0x4(%eax),%ecx
  800c37:	8d 40 08             	lea    0x8(%eax),%eax
  800c3a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c3d:	b8 08 00 00 00       	mov    $0x8,%eax
  800c42:	eb 3f                	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800c44:	8b 45 14             	mov    0x14(%ebp),%eax
  800c47:	8b 10                	mov    (%eax),%edx
  800c49:	b9 00 00 00 00       	mov    $0x0,%ecx
  800c4e:	8d 40 04             	lea    0x4(%eax),%eax
  800c51:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  800c54:	b8 08 00 00 00       	mov    $0x8,%eax
  800c59:	eb 28                	jmp    800c83 <vprintfmt+0x3a8>
			putch('0', putdat);
  800c5b:	83 ec 08             	sub    $0x8,%esp
  800c5e:	53                   	push   %ebx
  800c5f:	6a 30                	push   $0x30
  800c61:	ff d6                	call   *%esi
			putch('x', putdat);
  800c63:	83 c4 08             	add    $0x8,%esp
  800c66:	53                   	push   %ebx
  800c67:	6a 78                	push   $0x78
  800c69:	ff d6                	call   *%esi
			num = (unsigned long long)
  800c6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6e:	8b 10                	mov    (%eax),%edx
  800c70:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  800c75:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  800c78:	8d 40 04             	lea    0x4(%eax),%eax
  800c7b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800c7e:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  800c83:	83 ec 0c             	sub    $0xc,%esp
  800c86:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  800c8a:	57                   	push   %edi
  800c8b:	ff 75 e0             	pushl  -0x20(%ebp)
  800c8e:	50                   	push   %eax
  800c8f:	51                   	push   %ecx
  800c90:	52                   	push   %edx
  800c91:	89 da                	mov    %ebx,%edx
  800c93:	89 f0                	mov    %esi,%eax
  800c95:	e8 5b fb ff ff       	call   8007f5 <printnum>
			break;
  800c9a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  800c9d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800ca0:	47                   	inc    %edi
  800ca1:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  800ca5:	83 f8 25             	cmp    $0x25,%eax
  800ca8:	0f 84 44 fc ff ff    	je     8008f2 <vprintfmt+0x17>
			if (ch == '\0')
  800cae:	85 c0                	test   %eax,%eax
  800cb0:	0f 84 89 00 00 00    	je     800d3f <vprintfmt+0x464>
			putch(ch, putdat);
  800cb6:	83 ec 08             	sub    $0x8,%esp
  800cb9:	53                   	push   %ebx
  800cba:	50                   	push   %eax
  800cbb:	ff d6                	call   *%esi
  800cbd:	83 c4 10             	add    $0x10,%esp
  800cc0:	eb de                	jmp    800ca0 <vprintfmt+0x3c5>
	if (lflag >= 2)
  800cc2:	83 f9 01             	cmp    $0x1,%ecx
  800cc5:	7f 1b                	jg     800ce2 <vprintfmt+0x407>
	else if (lflag)
  800cc7:	85 c9                	test   %ecx,%ecx
  800cc9:	75 2c                	jne    800cf7 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	8b 10                	mov    (%eax),%edx
  800cd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  800cd5:	8d 40 04             	lea    0x4(%eax),%eax
  800cd8:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cdb:	b8 10 00 00 00       	mov    $0x10,%eax
  800ce0:	eb a1                	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  800ce2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce5:	8b 10                	mov    (%eax),%edx
  800ce7:	8b 48 04             	mov    0x4(%eax),%ecx
  800cea:	8d 40 08             	lea    0x8(%eax),%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800cf0:	b8 10 00 00 00       	mov    $0x10,%eax
  800cf5:	eb 8c                	jmp    800c83 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  800cf7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfa:	8b 10                	mov    (%eax),%edx
  800cfc:	b9 00 00 00 00       	mov    $0x0,%ecx
  800d01:	8d 40 04             	lea    0x4(%eax),%eax
  800d04:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  800d07:	b8 10 00 00 00       	mov    $0x10,%eax
  800d0c:	e9 72 ff ff ff       	jmp    800c83 <vprintfmt+0x3a8>
			putch(ch, putdat);
  800d11:	83 ec 08             	sub    $0x8,%esp
  800d14:	53                   	push   %ebx
  800d15:	6a 25                	push   $0x25
  800d17:	ff d6                	call   *%esi
			break;
  800d19:	83 c4 10             	add    $0x10,%esp
  800d1c:	e9 7c ff ff ff       	jmp    800c9d <vprintfmt+0x3c2>
			putch('%', putdat);
  800d21:	83 ec 08             	sub    $0x8,%esp
  800d24:	53                   	push   %ebx
  800d25:	6a 25                	push   $0x25
  800d27:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d29:	83 c4 10             	add    $0x10,%esp
  800d2c:	89 f8                	mov    %edi,%eax
  800d2e:	eb 01                	jmp    800d31 <vprintfmt+0x456>
  800d30:	48                   	dec    %eax
  800d31:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  800d35:	75 f9                	jne    800d30 <vprintfmt+0x455>
  800d37:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d3a:	e9 5e ff ff ff       	jmp    800c9d <vprintfmt+0x3c2>
}
  800d3f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d42:	5b                   	pop    %ebx
  800d43:	5e                   	pop    %esi
  800d44:	5f                   	pop    %edi
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 18             	sub    $0x18,%esp
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d53:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d56:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  800d5a:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  800d5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d64:	85 c0                	test   %eax,%eax
  800d66:	74 26                	je     800d8e <vsnprintf+0x47>
  800d68:	85 d2                	test   %edx,%edx
  800d6a:	7e 29                	jle    800d95 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d6c:	ff 75 14             	pushl  0x14(%ebp)
  800d6f:	ff 75 10             	pushl  0x10(%ebp)
  800d72:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800d75:	50                   	push   %eax
  800d76:	68 a2 08 80 00       	push   $0x8008a2
  800d7b:	e8 5b fb ff ff       	call   8008db <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  800d80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d83:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d89:	83 c4 10             	add    $0x10,%esp
}
  800d8c:	c9                   	leave  
  800d8d:	c3                   	ret    
		return -E_INVAL;
  800d8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d93:	eb f7                	jmp    800d8c <vsnprintf+0x45>
  800d95:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800d9a:	eb f0                	jmp    800d8c <vsnprintf+0x45>

00800d9c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800da2:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  800da5:	50                   	push   %eax
  800da6:	ff 75 10             	pushl  0x10(%ebp)
  800da9:	ff 75 0c             	pushl  0xc(%ebp)
  800dac:	ff 75 08             	pushl  0x8(%ebp)
  800daf:	e8 93 ff ff ff       	call   800d47 <vsnprintf>
	va_end(ap);

	return rc;
}
  800db4:	c9                   	leave  
  800db5:	c3                   	ret    

00800db6 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  800db6:	55                   	push   %ebp
  800db7:	89 e5                	mov    %esp,%ebp
  800db9:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  800dbc:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc1:	eb 01                	jmp    800dc4 <strlen+0xe>
		n++;
  800dc3:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  800dc4:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  800dc8:	75 f9                	jne    800dc3 <strlen+0xd>
	return n;
}
  800dca:	5d                   	pop    %ebp
  800dcb:	c3                   	ret    

00800dcc <strnlen>:

int
strnlen(const char *s, size_t size)
{
  800dcc:	55                   	push   %ebp
  800dcd:	89 e5                	mov    %esp,%ebp
  800dcf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800dd2:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800dd5:	b8 00 00 00 00       	mov    $0x0,%eax
  800dda:	eb 01                	jmp    800ddd <strnlen+0x11>
		n++;
  800ddc:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ddd:	39 d0                	cmp    %edx,%eax
  800ddf:	74 06                	je     800de7 <strnlen+0x1b>
  800de1:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  800de5:	75 f5                	jne    800ddc <strnlen+0x10>
	return n;
}
  800de7:	5d                   	pop    %ebp
  800de8:	c3                   	ret    

00800de9 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	53                   	push   %ebx
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
  800df0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  800df3:	89 c2                	mov    %eax,%edx
  800df5:	42                   	inc    %edx
  800df6:	41                   	inc    %ecx
  800df7:	8a 59 ff             	mov    -0x1(%ecx),%bl
  800dfa:	88 5a ff             	mov    %bl,-0x1(%edx)
  800dfd:	84 db                	test   %bl,%bl
  800dff:	75 f4                	jne    800df5 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  800e01:	5b                   	pop    %ebx
  800e02:	5d                   	pop    %ebp
  800e03:	c3                   	ret    

00800e04 <strcat>:

char *
strcat(char *dst, const char *src)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	53                   	push   %ebx
  800e08:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  800e0b:	53                   	push   %ebx
  800e0c:	e8 a5 ff ff ff       	call   800db6 <strlen>
  800e11:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  800e14:	ff 75 0c             	pushl  0xc(%ebp)
  800e17:	01 d8                	add    %ebx,%eax
  800e19:	50                   	push   %eax
  800e1a:	e8 ca ff ff ff       	call   800de9 <strcpy>
	return dst;
}
  800e1f:	89 d8                	mov    %ebx,%eax
  800e21:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e24:	c9                   	leave  
  800e25:	c3                   	ret    

00800e26 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  800e26:	55                   	push   %ebp
  800e27:	89 e5                	mov    %esp,%ebp
  800e29:	56                   	push   %esi
  800e2a:	53                   	push   %ebx
  800e2b:	8b 75 08             	mov    0x8(%ebp),%esi
  800e2e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e31:	89 f3                	mov    %esi,%ebx
  800e33:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e36:	89 f2                	mov    %esi,%edx
  800e38:	eb 0c                	jmp    800e46 <strncpy+0x20>
		*dst++ = *src;
  800e3a:	42                   	inc    %edx
  800e3b:	8a 01                	mov    (%ecx),%al
  800e3d:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  800e40:	80 39 01             	cmpb   $0x1,(%ecx)
  800e43:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  800e46:	39 da                	cmp    %ebx,%edx
  800e48:	75 f0                	jne    800e3a <strncpy+0x14>
	}
	return ret;
}
  800e4a:	89 f0                	mov    %esi,%eax
  800e4c:	5b                   	pop    %ebx
  800e4d:	5e                   	pop    %esi
  800e4e:	5d                   	pop    %ebp
  800e4f:	c3                   	ret    

00800e50 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  800e50:	55                   	push   %ebp
  800e51:	89 e5                	mov    %esp,%ebp
  800e53:	56                   	push   %esi
  800e54:	53                   	push   %ebx
  800e55:	8b 75 08             	mov    0x8(%ebp),%esi
  800e58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e5b:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	74 20                	je     800e82 <strlcpy+0x32>
  800e62:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  800e66:	89 f0                	mov    %esi,%eax
  800e68:	eb 05                	jmp    800e6f <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  800e6a:	40                   	inc    %eax
  800e6b:	42                   	inc    %edx
  800e6c:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  800e6f:	39 d8                	cmp    %ebx,%eax
  800e71:	74 06                	je     800e79 <strlcpy+0x29>
  800e73:	8a 0a                	mov    (%edx),%cl
  800e75:	84 c9                	test   %cl,%cl
  800e77:	75 f1                	jne    800e6a <strlcpy+0x1a>
		*dst = '\0';
  800e79:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e7c:	29 f0                	sub    %esi,%eax
}
  800e7e:	5b                   	pop    %ebx
  800e7f:	5e                   	pop    %esi
  800e80:	5d                   	pop    %ebp
  800e81:	c3                   	ret    
  800e82:	89 f0                	mov    %esi,%eax
  800e84:	eb f6                	jmp    800e7c <strlcpy+0x2c>

00800e86 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e86:	55                   	push   %ebp
  800e87:	89 e5                	mov    %esp,%ebp
  800e89:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800e8c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  800e8f:	eb 02                	jmp    800e93 <strcmp+0xd>
		p++, q++;
  800e91:	41                   	inc    %ecx
  800e92:	42                   	inc    %edx
	while (*p && *p == *q)
  800e93:	8a 01                	mov    (%ecx),%al
  800e95:	84 c0                	test   %al,%al
  800e97:	74 04                	je     800e9d <strcmp+0x17>
  800e99:	3a 02                	cmp    (%edx),%al
  800e9b:	74 f4                	je     800e91 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9d:	0f b6 c0             	movzbl %al,%eax
  800ea0:	0f b6 12             	movzbl (%edx),%edx
  800ea3:	29 d0                	sub    %edx,%eax
}
  800ea5:	5d                   	pop    %ebp
  800ea6:	c3                   	ret    

00800ea7 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	53                   	push   %ebx
  800eab:	8b 45 08             	mov    0x8(%ebp),%eax
  800eae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eb1:	89 c3                	mov    %eax,%ebx
  800eb3:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  800eb6:	eb 02                	jmp    800eba <strncmp+0x13>
		n--, p++, q++;
  800eb8:	40                   	inc    %eax
  800eb9:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  800eba:	39 d8                	cmp    %ebx,%eax
  800ebc:	74 15                	je     800ed3 <strncmp+0x2c>
  800ebe:	8a 08                	mov    (%eax),%cl
  800ec0:	84 c9                	test   %cl,%cl
  800ec2:	74 04                	je     800ec8 <strncmp+0x21>
  800ec4:	3a 0a                	cmp    (%edx),%cl
  800ec6:	74 f0                	je     800eb8 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800ec8:	0f b6 00             	movzbl (%eax),%eax
  800ecb:	0f b6 12             	movzbl (%edx),%edx
  800ece:	29 d0                	sub    %edx,%eax
}
  800ed0:	5b                   	pop    %ebx
  800ed1:	5d                   	pop    %ebp
  800ed2:	c3                   	ret    
		return 0;
  800ed3:	b8 00 00 00 00       	mov    $0x0,%eax
  800ed8:	eb f6                	jmp    800ed0 <strncmp+0x29>

00800eda <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	84 d2                	test   %dl,%dl
  800ee7:	74 07                	je     800ef0 <strchr+0x16>
		if (*s == c)
  800ee9:	38 ca                	cmp    %cl,%dl
  800eeb:	74 08                	je     800ef5 <strchr+0x1b>
	for (; *s; s++)
  800eed:	40                   	inc    %eax
  800eee:	eb f3                	jmp    800ee3 <strchr+0x9>
			return (char *) s;
	return 0;
  800ef0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ef5:	5d                   	pop    %ebp
  800ef6:	c3                   	ret    

00800ef7 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ef7:	55                   	push   %ebp
  800ef8:	89 e5                	mov    %esp,%ebp
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  800f00:	8a 10                	mov    (%eax),%dl
  800f02:	84 d2                	test   %dl,%dl
  800f04:	74 07                	je     800f0d <strfind+0x16>
		if (*s == c)
  800f06:	38 ca                	cmp    %cl,%dl
  800f08:	74 03                	je     800f0d <strfind+0x16>
	for (; *s; s++)
  800f0a:	40                   	inc    %eax
  800f0b:	eb f3                	jmp    800f00 <strfind+0x9>
			break;
	return (char *) s;
}
  800f0d:	5d                   	pop    %ebp
  800f0e:	c3                   	ret    

00800f0f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  800f0f:	55                   	push   %ebp
  800f10:	89 e5                	mov    %esp,%ebp
  800f12:	57                   	push   %edi
  800f13:	56                   	push   %esi
  800f14:	53                   	push   %ebx
  800f15:	8b 7d 08             	mov    0x8(%ebp),%edi
  800f18:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  800f1b:	85 c9                	test   %ecx,%ecx
  800f1d:	74 13                	je     800f32 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  800f1f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  800f25:	75 05                	jne    800f2c <memset+0x1d>
  800f27:	f6 c1 03             	test   $0x3,%cl
  800f2a:	74 0d                	je     800f39 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  800f2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f2f:	fc                   	cld    
  800f30:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  800f32:	89 f8                	mov    %edi,%eax
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5f                   	pop    %edi
  800f37:	5d                   	pop    %ebp
  800f38:	c3                   	ret    
		c &= 0xFF;
  800f39:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  800f3d:	89 d3                	mov    %edx,%ebx
  800f3f:	c1 e3 08             	shl    $0x8,%ebx
  800f42:	89 d0                	mov    %edx,%eax
  800f44:	c1 e0 18             	shl    $0x18,%eax
  800f47:	89 d6                	mov    %edx,%esi
  800f49:	c1 e6 10             	shl    $0x10,%esi
  800f4c:	09 f0                	or     %esi,%eax
  800f4e:	09 c2                	or     %eax,%edx
  800f50:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  800f52:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	fc                   	cld    
  800f58:	f3 ab                	rep stos %eax,%es:(%edi)
  800f5a:	eb d6                	jmp    800f32 <memset+0x23>

00800f5c <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  800f5c:	55                   	push   %ebp
  800f5d:	89 e5                	mov    %esp,%ebp
  800f5f:	57                   	push   %edi
  800f60:	56                   	push   %esi
  800f61:	8b 45 08             	mov    0x8(%ebp),%eax
  800f64:	8b 75 0c             	mov    0xc(%ebp),%esi
  800f67:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f6a:	39 c6                	cmp    %eax,%esi
  800f6c:	73 33                	jae    800fa1 <memmove+0x45>
  800f6e:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  800f71:	39 d0                	cmp    %edx,%eax
  800f73:	73 2c                	jae    800fa1 <memmove+0x45>
		s += n;
		d += n;
  800f75:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800f78:	89 d6                	mov    %edx,%esi
  800f7a:	09 fe                	or     %edi,%esi
  800f7c:	f7 c6 03 00 00 00    	test   $0x3,%esi
  800f82:	75 13                	jne    800f97 <memmove+0x3b>
  800f84:	f6 c1 03             	test   $0x3,%cl
  800f87:	75 0e                	jne    800f97 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  800f89:	83 ef 04             	sub    $0x4,%edi
  800f8c:	8d 72 fc             	lea    -0x4(%edx),%esi
  800f8f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  800f92:	fd                   	std    
  800f93:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f95:	eb 07                	jmp    800f9e <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  800f97:	4f                   	dec    %edi
  800f98:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  800f9b:	fd                   	std    
  800f9c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  800f9e:	fc                   	cld    
  800f9f:	eb 13                	jmp    800fb4 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  800fa1:	89 f2                	mov    %esi,%edx
  800fa3:	09 c2                	or     %eax,%edx
  800fa5:	f6 c2 03             	test   $0x3,%dl
  800fa8:	75 05                	jne    800faf <memmove+0x53>
  800faa:	f6 c1 03             	test   $0x3,%cl
  800fad:	74 09                	je     800fb8 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  800faf:	89 c7                	mov    %eax,%edi
  800fb1:	fc                   	cld    
  800fb2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  800fb4:	5e                   	pop    %esi
  800fb5:	5f                   	pop    %edi
  800fb6:	5d                   	pop    %ebp
  800fb7:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  800fb8:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  800fbb:	89 c7                	mov    %eax,%edi
  800fbd:	fc                   	cld    
  800fbe:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fc0:	eb f2                	jmp    800fb4 <memmove+0x58>

00800fc2 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  800fc2:	55                   	push   %ebp
  800fc3:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  800fc5:	ff 75 10             	pushl  0x10(%ebp)
  800fc8:	ff 75 0c             	pushl  0xc(%ebp)
  800fcb:	ff 75 08             	pushl  0x8(%ebp)
  800fce:	e8 89 ff ff ff       	call   800f5c <memmove>
}
  800fd3:	c9                   	leave  
  800fd4:	c3                   	ret    

00800fd5 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  800fd5:	55                   	push   %ebp
  800fd6:	89 e5                	mov    %esp,%ebp
  800fd8:	56                   	push   %esi
  800fd9:	53                   	push   %ebx
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	89 c6                	mov    %eax,%esi
  800fdf:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  800fe2:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  800fe5:	39 f0                	cmp    %esi,%eax
  800fe7:	74 16                	je     800fff <memcmp+0x2a>
		if (*s1 != *s2)
  800fe9:	8a 08                	mov    (%eax),%cl
  800feb:	8a 1a                	mov    (%edx),%bl
  800fed:	38 d9                	cmp    %bl,%cl
  800fef:	75 04                	jne    800ff5 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  800ff1:	40                   	inc    %eax
  800ff2:	42                   	inc    %edx
  800ff3:	eb f0                	jmp    800fe5 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  800ff5:	0f b6 c1             	movzbl %cl,%eax
  800ff8:	0f b6 db             	movzbl %bl,%ebx
  800ffb:	29 d8                	sub    %ebx,%eax
  800ffd:	eb 05                	jmp    801004 <memcmp+0x2f>
	}

	return 0;
  800fff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801004:	5b                   	pop    %ebx
  801005:	5e                   	pop    %esi
  801006:	5d                   	pop    %ebp
  801007:	c3                   	ret    

00801008 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801008:	55                   	push   %ebp
  801009:	89 e5                	mov    %esp,%ebp
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801011:	89 c2                	mov    %eax,%edx
  801013:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801016:	39 d0                	cmp    %edx,%eax
  801018:	73 07                	jae    801021 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  80101a:	38 08                	cmp    %cl,(%eax)
  80101c:	74 03                	je     801021 <memfind+0x19>
	for (; s < ends; s++)
  80101e:	40                   	inc    %eax
  80101f:	eb f5                	jmp    801016 <memfind+0xe>
			break;
	return (void *) s;
}
  801021:	5d                   	pop    %ebp
  801022:	c3                   	ret    

00801023 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801023:	55                   	push   %ebp
  801024:	89 e5                	mov    %esp,%ebp
  801026:	57                   	push   %edi
  801027:	56                   	push   %esi
  801028:	53                   	push   %ebx
  801029:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80102c:	eb 01                	jmp    80102f <strtol+0xc>
		s++;
  80102e:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  80102f:	8a 01                	mov    (%ecx),%al
  801031:	3c 20                	cmp    $0x20,%al
  801033:	74 f9                	je     80102e <strtol+0xb>
  801035:	3c 09                	cmp    $0x9,%al
  801037:	74 f5                	je     80102e <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801039:	3c 2b                	cmp    $0x2b,%al
  80103b:	74 2b                	je     801068 <strtol+0x45>
		s++;
	else if (*s == '-')
  80103d:	3c 2d                	cmp    $0x2d,%al
  80103f:	74 2f                	je     801070 <strtol+0x4d>
	int neg = 0;
  801041:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801046:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  80104d:	75 12                	jne    801061 <strtol+0x3e>
  80104f:	80 39 30             	cmpb   $0x30,(%ecx)
  801052:	74 24                	je     801078 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801054:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801058:	75 07                	jne    801061 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  80105a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801061:	b8 00 00 00 00       	mov    $0x0,%eax
  801066:	eb 4e                	jmp    8010b6 <strtol+0x93>
		s++;
  801068:	41                   	inc    %ecx
	int neg = 0;
  801069:	bf 00 00 00 00       	mov    $0x0,%edi
  80106e:	eb d6                	jmp    801046 <strtol+0x23>
		s++, neg = 1;
  801070:	41                   	inc    %ecx
  801071:	bf 01 00 00 00       	mov    $0x1,%edi
  801076:	eb ce                	jmp    801046 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801078:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  80107c:	74 10                	je     80108e <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  80107e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801082:	75 dd                	jne    801061 <strtol+0x3e>
		s++, base = 8;
  801084:	41                   	inc    %ecx
  801085:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80108c:	eb d3                	jmp    801061 <strtol+0x3e>
		s += 2, base = 16;
  80108e:	83 c1 02             	add    $0x2,%ecx
  801091:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801098:	eb c7                	jmp    801061 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  80109a:	8d 72 9f             	lea    -0x61(%edx),%esi
  80109d:	89 f3                	mov    %esi,%ebx
  80109f:	80 fb 19             	cmp    $0x19,%bl
  8010a2:	77 24                	ja     8010c8 <strtol+0xa5>
			dig = *s - 'a' + 10;
  8010a4:	0f be d2             	movsbl %dl,%edx
  8010a7:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  8010aa:	3b 55 10             	cmp    0x10(%ebp),%edx
  8010ad:	7d 2b                	jge    8010da <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  8010af:	41                   	inc    %ecx
  8010b0:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010b4:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  8010b6:	8a 11                	mov    (%ecx),%dl
  8010b8:	8d 5a d0             	lea    -0x30(%edx),%ebx
  8010bb:	80 fb 09             	cmp    $0x9,%bl
  8010be:	77 da                	ja     80109a <strtol+0x77>
			dig = *s - '0';
  8010c0:	0f be d2             	movsbl %dl,%edx
  8010c3:	83 ea 30             	sub    $0x30,%edx
  8010c6:	eb e2                	jmp    8010aa <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  8010c8:	8d 72 bf             	lea    -0x41(%edx),%esi
  8010cb:	89 f3                	mov    %esi,%ebx
  8010cd:	80 fb 19             	cmp    $0x19,%bl
  8010d0:	77 08                	ja     8010da <strtol+0xb7>
			dig = *s - 'A' + 10;
  8010d2:	0f be d2             	movsbl %dl,%edx
  8010d5:	83 ea 37             	sub    $0x37,%edx
  8010d8:	eb d0                	jmp    8010aa <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  8010da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010de:	74 05                	je     8010e5 <strtol+0xc2>
		*endptr = (char *) s;
  8010e0:	8b 75 0c             	mov    0xc(%ebp),%esi
  8010e3:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  8010e5:	85 ff                	test   %edi,%edi
  8010e7:	74 02                	je     8010eb <strtol+0xc8>
  8010e9:	f7 d8                	neg    %eax
}
  8010eb:	5b                   	pop    %ebx
  8010ec:	5e                   	pop    %esi
  8010ed:	5f                   	pop    %edi
  8010ee:	5d                   	pop    %ebp
  8010ef:	c3                   	ret    

008010f0 <atoi>:

int
atoi(const char *s)
{
  8010f0:	55                   	push   %ebp
  8010f1:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  8010f3:	6a 0a                	push   $0xa
  8010f5:	6a 00                	push   $0x0
  8010f7:	ff 75 08             	pushl  0x8(%ebp)
  8010fa:	e8 24 ff ff ff       	call   801023 <strtol>
}
  8010ff:	c9                   	leave  
  801100:	c3                   	ret    

00801101 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  801101:	55                   	push   %ebp
  801102:	89 e5                	mov    %esp,%ebp
  801104:	57                   	push   %edi
  801105:	56                   	push   %esi
  801106:	53                   	push   %ebx
	asm volatile("int %1\n"
  801107:	b8 00 00 00 00       	mov    $0x0,%eax
  80110c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80110f:	8b 55 08             	mov    0x8(%ebp),%edx
  801112:	89 c3                	mov    %eax,%ebx
  801114:	89 c7                	mov    %eax,%edi
  801116:	89 c6                	mov    %eax,%esi
  801118:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  80111a:	5b                   	pop    %ebx
  80111b:	5e                   	pop    %esi
  80111c:	5f                   	pop    %edi
  80111d:	5d                   	pop    %ebp
  80111e:	c3                   	ret    

0080111f <sys_cgetc>:

int
sys_cgetc(void)
{
  80111f:	55                   	push   %ebp
  801120:	89 e5                	mov    %esp,%ebp
  801122:	57                   	push   %edi
  801123:	56                   	push   %esi
  801124:	53                   	push   %ebx
	asm volatile("int %1\n"
  801125:	ba 00 00 00 00       	mov    $0x0,%edx
  80112a:	b8 01 00 00 00       	mov    $0x1,%eax
  80112f:	89 d1                	mov    %edx,%ecx
  801131:	89 d3                	mov    %edx,%ebx
  801133:	89 d7                	mov    %edx,%edi
  801135:	89 d6                	mov    %edx,%esi
  801137:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  801139:	5b                   	pop    %ebx
  80113a:	5e                   	pop    %esi
  80113b:	5f                   	pop    %edi
  80113c:	5d                   	pop    %ebp
  80113d:	c3                   	ret    

0080113e <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80113e:	55                   	push   %ebp
  80113f:	89 e5                	mov    %esp,%ebp
  801141:	57                   	push   %edi
  801142:	56                   	push   %esi
  801143:	53                   	push   %ebx
  801144:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801147:	b9 00 00 00 00       	mov    $0x0,%ecx
  80114c:	b8 03 00 00 00       	mov    $0x3,%eax
  801151:	8b 55 08             	mov    0x8(%ebp),%edx
  801154:	89 cb                	mov    %ecx,%ebx
  801156:	89 cf                	mov    %ecx,%edi
  801158:	89 ce                	mov    %ecx,%esi
  80115a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80115c:	85 c0                	test   %eax,%eax
  80115e:	7f 08                	jg     801168 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  801160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801163:	5b                   	pop    %ebx
  801164:	5e                   	pop    %esi
  801165:	5f                   	pop    %edi
  801166:	5d                   	pop    %ebp
  801167:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801168:	83 ec 0c             	sub    $0xc,%esp
  80116b:	50                   	push   %eax
  80116c:	6a 03                	push   $0x3
  80116e:	68 1f 2c 80 00       	push   $0x802c1f
  801173:	6a 23                	push   $0x23
  801175:	68 3c 2c 80 00       	push   $0x802c3c
  80117a:	e8 4f f5 ff ff       	call   8006ce <_panic>

0080117f <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80117f:	55                   	push   %ebp
  801180:	89 e5                	mov    %esp,%ebp
  801182:	57                   	push   %edi
  801183:	56                   	push   %esi
  801184:	53                   	push   %ebx
	asm volatile("int %1\n"
  801185:	ba 00 00 00 00       	mov    $0x0,%edx
  80118a:	b8 02 00 00 00       	mov    $0x2,%eax
  80118f:	89 d1                	mov    %edx,%ecx
  801191:	89 d3                	mov    %edx,%ebx
  801193:	89 d7                	mov    %edx,%edi
  801195:	89 d6                	mov    %edx,%esi
  801197:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  801199:	5b                   	pop    %ebx
  80119a:	5e                   	pop    %esi
  80119b:	5f                   	pop    %edi
  80119c:	5d                   	pop    %ebp
  80119d:	c3                   	ret    

0080119e <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80119e:	55                   	push   %ebp
  80119f:	89 e5                	mov    %esp,%ebp
  8011a1:	57                   	push   %edi
  8011a2:	56                   	push   %esi
  8011a3:	53                   	push   %ebx
  8011a4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011a7:	be 00 00 00 00       	mov    $0x0,%esi
  8011ac:	b8 04 00 00 00       	mov    $0x4,%eax
  8011b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b7:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011ba:	89 f7                	mov    %esi,%edi
  8011bc:	cd 30                	int    $0x30
	if(check && ret > 0)
  8011be:	85 c0                	test   %eax,%eax
  8011c0:	7f 08                	jg     8011ca <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  8011c2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8011c5:	5b                   	pop    %ebx
  8011c6:	5e                   	pop    %esi
  8011c7:	5f                   	pop    %edi
  8011c8:	5d                   	pop    %ebp
  8011c9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8011ca:	83 ec 0c             	sub    $0xc,%esp
  8011cd:	50                   	push   %eax
  8011ce:	6a 04                	push   $0x4
  8011d0:	68 1f 2c 80 00       	push   $0x802c1f
  8011d5:	6a 23                	push   $0x23
  8011d7:	68 3c 2c 80 00       	push   $0x802c3c
  8011dc:	e8 ed f4 ff ff       	call   8006ce <_panic>

008011e1 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
  8011e4:	57                   	push   %edi
  8011e5:	56                   	push   %esi
  8011e6:	53                   	push   %ebx
  8011e7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8011ea:	b8 05 00 00 00       	mov    $0x5,%eax
  8011ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8011f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8011f5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8011f8:	8b 7d 14             	mov    0x14(%ebp),%edi
  8011fb:	8b 75 18             	mov    0x18(%ebp),%esi
  8011fe:	cd 30                	int    $0x30
	if(check && ret > 0)
  801200:	85 c0                	test   %eax,%eax
  801202:	7f 08                	jg     80120c <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  801204:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801207:	5b                   	pop    %ebx
  801208:	5e                   	pop    %esi
  801209:	5f                   	pop    %edi
  80120a:	5d                   	pop    %ebp
  80120b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80120c:	83 ec 0c             	sub    $0xc,%esp
  80120f:	50                   	push   %eax
  801210:	6a 05                	push   $0x5
  801212:	68 1f 2c 80 00       	push   $0x802c1f
  801217:	6a 23                	push   $0x23
  801219:	68 3c 2c 80 00       	push   $0x802c3c
  80121e:	e8 ab f4 ff ff       	call   8006ce <_panic>

00801223 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	57                   	push   %edi
  801227:	56                   	push   %esi
  801228:	53                   	push   %ebx
  801229:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80122c:	bb 00 00 00 00       	mov    $0x0,%ebx
  801231:	b8 06 00 00 00       	mov    $0x6,%eax
  801236:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801239:	8b 55 08             	mov    0x8(%ebp),%edx
  80123c:	89 df                	mov    %ebx,%edi
  80123e:	89 de                	mov    %ebx,%esi
  801240:	cd 30                	int    $0x30
	if(check && ret > 0)
  801242:	85 c0                	test   %eax,%eax
  801244:	7f 08                	jg     80124e <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  801246:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801249:	5b                   	pop    %ebx
  80124a:	5e                   	pop    %esi
  80124b:	5f                   	pop    %edi
  80124c:	5d                   	pop    %ebp
  80124d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	50                   	push   %eax
  801252:	6a 06                	push   $0x6
  801254:	68 1f 2c 80 00       	push   $0x802c1f
  801259:	6a 23                	push   $0x23
  80125b:	68 3c 2c 80 00       	push   $0x802c3c
  801260:	e8 69 f4 ff ff       	call   8006ce <_panic>

00801265 <sys_yield>:

void
sys_yield(void)
{
  801265:	55                   	push   %ebp
  801266:	89 e5                	mov    %esp,%ebp
  801268:	57                   	push   %edi
  801269:	56                   	push   %esi
  80126a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80126b:	ba 00 00 00 00       	mov    $0x0,%edx
  801270:	b8 0b 00 00 00       	mov    $0xb,%eax
  801275:	89 d1                	mov    %edx,%ecx
  801277:	89 d3                	mov    %edx,%ebx
  801279:	89 d7                	mov    %edx,%edi
  80127b:	89 d6                	mov    %edx,%esi
  80127d:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80127f:	5b                   	pop    %ebx
  801280:	5e                   	pop    %esi
  801281:	5f                   	pop    %edi
  801282:	5d                   	pop    %ebp
  801283:	c3                   	ret    

00801284 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  801284:	55                   	push   %ebp
  801285:	89 e5                	mov    %esp,%ebp
  801287:	57                   	push   %edi
  801288:	56                   	push   %esi
  801289:	53                   	push   %ebx
  80128a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80128d:	bb 00 00 00 00       	mov    $0x0,%ebx
  801292:	b8 08 00 00 00       	mov    $0x8,%eax
  801297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80129a:	8b 55 08             	mov    0x8(%ebp),%edx
  80129d:	89 df                	mov    %ebx,%edi
  80129f:	89 de                	mov    %ebx,%esi
  8012a1:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012a3:	85 c0                	test   %eax,%eax
  8012a5:	7f 08                	jg     8012af <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  8012a7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012aa:	5b                   	pop    %ebx
  8012ab:	5e                   	pop    %esi
  8012ac:	5f                   	pop    %edi
  8012ad:	5d                   	pop    %ebp
  8012ae:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012af:	83 ec 0c             	sub    $0xc,%esp
  8012b2:	50                   	push   %eax
  8012b3:	6a 08                	push   $0x8
  8012b5:	68 1f 2c 80 00       	push   $0x802c1f
  8012ba:	6a 23                	push   $0x23
  8012bc:	68 3c 2c 80 00       	push   $0x802c3c
  8012c1:	e8 08 f4 ff ff       	call   8006ce <_panic>

008012c6 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  8012c6:	55                   	push   %ebp
  8012c7:	89 e5                	mov    %esp,%ebp
  8012c9:	57                   	push   %edi
  8012ca:	56                   	push   %esi
  8012cb:	53                   	push   %ebx
  8012cc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8012cf:	b9 00 00 00 00       	mov    $0x0,%ecx
  8012d4:	b8 0c 00 00 00       	mov    $0xc,%eax
  8012d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8012dc:	89 cb                	mov    %ecx,%ebx
  8012de:	89 cf                	mov    %ecx,%edi
  8012e0:	89 ce                	mov    %ecx,%esi
  8012e2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	7f 08                	jg     8012f0 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  8012e8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5f                   	pop    %edi
  8012ee:	5d                   	pop    %ebp
  8012ef:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8012f0:	83 ec 0c             	sub    $0xc,%esp
  8012f3:	50                   	push   %eax
  8012f4:	6a 0c                	push   $0xc
  8012f6:	68 1f 2c 80 00       	push   $0x802c1f
  8012fb:	6a 23                	push   $0x23
  8012fd:	68 3c 2c 80 00       	push   $0x802c3c
  801302:	e8 c7 f3 ff ff       	call   8006ce <_panic>

00801307 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
  80130a:	57                   	push   %edi
  80130b:	56                   	push   %esi
  80130c:	53                   	push   %ebx
  80130d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801310:	bb 00 00 00 00       	mov    $0x0,%ebx
  801315:	b8 09 00 00 00       	mov    $0x9,%eax
  80131a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80131d:	8b 55 08             	mov    0x8(%ebp),%edx
  801320:	89 df                	mov    %ebx,%edi
  801322:	89 de                	mov    %ebx,%esi
  801324:	cd 30                	int    $0x30
	if(check && ret > 0)
  801326:	85 c0                	test   %eax,%eax
  801328:	7f 08                	jg     801332 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  80132a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80132d:	5b                   	pop    %ebx
  80132e:	5e                   	pop    %esi
  80132f:	5f                   	pop    %edi
  801330:	5d                   	pop    %ebp
  801331:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801332:	83 ec 0c             	sub    $0xc,%esp
  801335:	50                   	push   %eax
  801336:	6a 09                	push   $0x9
  801338:	68 1f 2c 80 00       	push   $0x802c1f
  80133d:	6a 23                	push   $0x23
  80133f:	68 3c 2c 80 00       	push   $0x802c3c
  801344:	e8 85 f3 ff ff       	call   8006ce <_panic>

00801349 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  801349:	55                   	push   %ebp
  80134a:	89 e5                	mov    %esp,%ebp
  80134c:	57                   	push   %edi
  80134d:	56                   	push   %esi
  80134e:	53                   	push   %ebx
  80134f:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  801352:	bb 00 00 00 00       	mov    $0x0,%ebx
  801357:	b8 0a 00 00 00       	mov    $0xa,%eax
  80135c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80135f:	8b 55 08             	mov    0x8(%ebp),%edx
  801362:	89 df                	mov    %ebx,%edi
  801364:	89 de                	mov    %ebx,%esi
  801366:	cd 30                	int    $0x30
	if(check && ret > 0)
  801368:	85 c0                	test   %eax,%eax
  80136a:	7f 08                	jg     801374 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80136c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80136f:	5b                   	pop    %ebx
  801370:	5e                   	pop    %esi
  801371:	5f                   	pop    %edi
  801372:	5d                   	pop    %ebp
  801373:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  801374:	83 ec 0c             	sub    $0xc,%esp
  801377:	50                   	push   %eax
  801378:	6a 0a                	push   $0xa
  80137a:	68 1f 2c 80 00       	push   $0x802c1f
  80137f:	6a 23                	push   $0x23
  801381:	68 3c 2c 80 00       	push   $0x802c3c
  801386:	e8 43 f3 ff ff       	call   8006ce <_panic>

0080138b <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80138b:	55                   	push   %ebp
  80138c:	89 e5                	mov    %esp,%ebp
  80138e:	57                   	push   %edi
  80138f:	56                   	push   %esi
  801390:	53                   	push   %ebx
	asm volatile("int %1\n"
  801391:	be 00 00 00 00       	mov    $0x0,%esi
  801396:	b8 0d 00 00 00       	mov    $0xd,%eax
  80139b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80139e:	8b 55 08             	mov    0x8(%ebp),%edx
  8013a1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8013a4:	8b 7d 14             	mov    0x14(%ebp),%edi
  8013a7:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  8013a9:	5b                   	pop    %ebx
  8013aa:	5e                   	pop    %esi
  8013ab:	5f                   	pop    %edi
  8013ac:	5d                   	pop    %ebp
  8013ad:	c3                   	ret    

008013ae <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  8013ae:	55                   	push   %ebp
  8013af:	89 e5                	mov    %esp,%ebp
  8013b1:	57                   	push   %edi
  8013b2:	56                   	push   %esi
  8013b3:	53                   	push   %ebx
  8013b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8013b7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8013bc:	b8 0e 00 00 00       	mov    $0xe,%eax
  8013c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8013c4:	89 cb                	mov    %ecx,%ebx
  8013c6:	89 cf                	mov    %ecx,%edi
  8013c8:	89 ce                	mov    %ecx,%esi
  8013ca:	cd 30                	int    $0x30
	if(check && ret > 0)
  8013cc:	85 c0                	test   %eax,%eax
  8013ce:	7f 08                	jg     8013d8 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8013d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8013d3:	5b                   	pop    %ebx
  8013d4:	5e                   	pop    %esi
  8013d5:	5f                   	pop    %edi
  8013d6:	5d                   	pop    %ebp
  8013d7:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8013d8:	83 ec 0c             	sub    $0xc,%esp
  8013db:	50                   	push   %eax
  8013dc:	6a 0e                	push   $0xe
  8013de:	68 1f 2c 80 00       	push   $0x802c1f
  8013e3:	6a 23                	push   $0x23
  8013e5:	68 3c 2c 80 00       	push   $0x802c3c
  8013ea:	e8 df f2 ff ff       	call   8006ce <_panic>

008013ef <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8013ef:	55                   	push   %ebp
  8013f0:	89 e5                	mov    %esp,%ebp
  8013f2:	57                   	push   %edi
  8013f3:	56                   	push   %esi
  8013f4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8013f5:	be 00 00 00 00       	mov    $0x0,%esi
  8013fa:	b8 0f 00 00 00       	mov    $0xf,%eax
  8013ff:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801402:	8b 55 08             	mov    0x8(%ebp),%edx
  801405:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801408:	89 f7                	mov    %esi,%edi
  80140a:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80140c:	5b                   	pop    %ebx
  80140d:	5e                   	pop    %esi
  80140e:	5f                   	pop    %edi
  80140f:	5d                   	pop    %ebp
  801410:	c3                   	ret    

00801411 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  801411:	55                   	push   %ebp
  801412:	89 e5                	mov    %esp,%ebp
  801414:	57                   	push   %edi
  801415:	56                   	push   %esi
  801416:	53                   	push   %ebx
	asm volatile("int %1\n"
  801417:	be 00 00 00 00       	mov    $0x0,%esi
  80141c:	b8 10 00 00 00       	mov    $0x10,%eax
  801421:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801424:	8b 55 08             	mov    0x8(%ebp),%edx
  801427:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80142a:	89 f7                	mov    %esi,%edi
  80142c:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80142e:	5b                   	pop    %ebx
  80142f:	5e                   	pop    %esi
  801430:	5f                   	pop    %edi
  801431:	5d                   	pop    %ebp
  801432:	c3                   	ret    

00801433 <sys_set_console_color>:

void sys_set_console_color(int color) {
  801433:	55                   	push   %ebp
  801434:	89 e5                	mov    %esp,%ebp
  801436:	57                   	push   %edi
  801437:	56                   	push   %esi
  801438:	53                   	push   %ebx
	asm volatile("int %1\n"
  801439:	b9 00 00 00 00       	mov    $0x0,%ecx
  80143e:	b8 11 00 00 00       	mov    $0x11,%eax
  801443:	8b 55 08             	mov    0x8(%ebp),%edx
  801446:	89 cb                	mov    %ecx,%ebx
  801448:	89 cf                	mov    %ecx,%edi
  80144a:	89 ce                	mov    %ecx,%esi
  80144c:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  80144e:	5b                   	pop    %ebx
  80144f:	5e                   	pop    %esi
  801450:	5f                   	pop    %edi
  801451:	5d                   	pop    %ebp
  801452:	c3                   	ret    

00801453 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801453:	55                   	push   %ebp
  801454:	89 e5                	mov    %esp,%ebp
  801456:	57                   	push   %edi
  801457:	56                   	push   %esi
  801458:	53                   	push   %ebx
  801459:	83 ec 0c             	sub    $0xc,%esp
  80145c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80145f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801462:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801465:	85 ff                	test   %edi,%edi
  801467:	74 53                	je     8014bc <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801469:	83 ec 0c             	sub    $0xc,%esp
  80146c:	57                   	push   %edi
  80146d:	e8 3c ff ff ff       	call   8013ae <sys_ipc_recv>
  801472:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801475:	85 db                	test   %ebx,%ebx
  801477:	74 0b                	je     801484 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801479:	8b 15 04 40 80 00    	mov    0x804004,%edx
  80147f:	8b 52 74             	mov    0x74(%edx),%edx
  801482:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801484:	85 f6                	test   %esi,%esi
  801486:	74 0f                	je     801497 <ipc_recv+0x44>
  801488:	85 ff                	test   %edi,%edi
  80148a:	74 0b                	je     801497 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  80148c:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801492:	8b 52 78             	mov    0x78(%edx),%edx
  801495:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801497:	85 c0                	test   %eax,%eax
  801499:	74 30                	je     8014cb <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  80149b:	85 db                	test   %ebx,%ebx
  80149d:	74 06                	je     8014a5 <ipc_recv+0x52>
      		*from_env_store = 0;
  80149f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  8014a5:	85 f6                	test   %esi,%esi
  8014a7:	74 2c                	je     8014d5 <ipc_recv+0x82>
      		*perm_store = 0;
  8014a9:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  8014af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  8014b4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8014b7:	5b                   	pop    %ebx
  8014b8:	5e                   	pop    %esi
  8014b9:	5f                   	pop    %edi
  8014ba:	5d                   	pop    %ebp
  8014bb:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  8014bc:	83 ec 0c             	sub    $0xc,%esp
  8014bf:	6a ff                	push   $0xffffffff
  8014c1:	e8 e8 fe ff ff       	call   8013ae <sys_ipc_recv>
  8014c6:	83 c4 10             	add    $0x10,%esp
  8014c9:	eb aa                	jmp    801475 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  8014cb:	a1 04 40 80 00       	mov    0x804004,%eax
  8014d0:	8b 40 70             	mov    0x70(%eax),%eax
  8014d3:	eb df                	jmp    8014b4 <ipc_recv+0x61>
		return -1;
  8014d5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  8014da:	eb d8                	jmp    8014b4 <ipc_recv+0x61>

008014dc <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  8014dc:	55                   	push   %ebp
  8014dd:	89 e5                	mov    %esp,%ebp
  8014df:	57                   	push   %edi
  8014e0:	56                   	push   %esi
  8014e1:	53                   	push   %ebx
  8014e2:	83 ec 0c             	sub    $0xc,%esp
  8014e5:	8b 75 0c             	mov    0xc(%ebp),%esi
  8014e8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8014eb:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  8014ee:	85 db                	test   %ebx,%ebx
  8014f0:	75 22                	jne    801514 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  8014f2:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  8014f7:	eb 1b                	jmp    801514 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  8014f9:	68 4c 2c 80 00       	push   $0x802c4c
  8014fe:	68 6f 2c 80 00       	push   $0x802c6f
  801503:	6a 48                	push   $0x48
  801505:	68 84 2c 80 00       	push   $0x802c84
  80150a:	e8 bf f1 ff ff       	call   8006ce <_panic>
		sys_yield();
  80150f:	e8 51 fd ff ff       	call   801265 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801514:	57                   	push   %edi
  801515:	53                   	push   %ebx
  801516:	56                   	push   %esi
  801517:	ff 75 08             	pushl  0x8(%ebp)
  80151a:	e8 6c fe ff ff       	call   80138b <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  80151f:	83 c4 10             	add    $0x10,%esp
  801522:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801525:	74 e8                	je     80150f <ipc_send+0x33>
  801527:	85 c0                	test   %eax,%eax
  801529:	75 ce                	jne    8014f9 <ipc_send+0x1d>
		sys_yield();
  80152b:	e8 35 fd ff ff       	call   801265 <sys_yield>
		
	}
	
}
  801530:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801533:	5b                   	pop    %ebx
  801534:	5e                   	pop    %esi
  801535:	5f                   	pop    %edi
  801536:	5d                   	pop    %ebp
  801537:	c3                   	ret    

00801538 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  80153e:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801543:	89 c2                	mov    %eax,%edx
  801545:	c1 e2 05             	shl    $0x5,%edx
  801548:	29 c2                	sub    %eax,%edx
  80154a:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801551:	8b 52 50             	mov    0x50(%edx),%edx
  801554:	39 ca                	cmp    %ecx,%edx
  801556:	74 0f                	je     801567 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801558:	40                   	inc    %eax
  801559:	3d 00 04 00 00       	cmp    $0x400,%eax
  80155e:	75 e3                	jne    801543 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 11                	jmp    801578 <ipc_find_env+0x40>
			return envs[i].env_id;
  801567:	89 c2                	mov    %eax,%edx
  801569:	c1 e2 05             	shl    $0x5,%edx
  80156c:	29 c2                	sub    %eax,%edx
  80156e:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801575:	8b 40 48             	mov    0x48(%eax),%eax
}
  801578:	5d                   	pop    %ebp
  801579:	c3                   	ret    

0080157a <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80157d:	8b 45 08             	mov    0x8(%ebp),%eax
  801580:	05 00 00 00 30       	add    $0x30000000,%eax
  801585:	c1 e8 0c             	shr    $0xc,%eax
}
  801588:	5d                   	pop    %ebp
  801589:	c3                   	ret    

0080158a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80158d:	8b 45 08             	mov    0x8(%ebp),%eax
  801590:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  801595:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80159a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80159f:	5d                   	pop    %ebp
  8015a0:	c3                   	ret    

008015a1 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  8015a1:	55                   	push   %ebp
  8015a2:	89 e5                	mov    %esp,%ebp
  8015a4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015a7:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  8015ac:	89 c2                	mov    %eax,%edx
  8015ae:	c1 ea 16             	shr    $0x16,%edx
  8015b1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8015b8:	f6 c2 01             	test   $0x1,%dl
  8015bb:	74 2a                	je     8015e7 <fd_alloc+0x46>
  8015bd:	89 c2                	mov    %eax,%edx
  8015bf:	c1 ea 0c             	shr    $0xc,%edx
  8015c2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8015c9:	f6 c2 01             	test   $0x1,%dl
  8015cc:	74 19                	je     8015e7 <fd_alloc+0x46>
  8015ce:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  8015d3:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  8015d8:	75 d2                	jne    8015ac <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  8015da:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  8015e0:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  8015e5:	eb 07                	jmp    8015ee <fd_alloc+0x4d>
			*fd_store = fd;
  8015e7:	89 01                	mov    %eax,(%ecx)
			return 0;
  8015e9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ee:	5d                   	pop    %ebp
  8015ef:	c3                   	ret    

008015f0 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8015f3:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8015f7:	77 39                	ja     801632 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8015f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fc:	c1 e0 0c             	shl    $0xc,%eax
  8015ff:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  801604:	89 c2                	mov    %eax,%edx
  801606:	c1 ea 16             	shr    $0x16,%edx
  801609:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  801610:	f6 c2 01             	test   $0x1,%dl
  801613:	74 24                	je     801639 <fd_lookup+0x49>
  801615:	89 c2                	mov    %eax,%edx
  801617:	c1 ea 0c             	shr    $0xc,%edx
  80161a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  801621:	f6 c2 01             	test   $0x1,%dl
  801624:	74 1a                	je     801640 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  801626:	8b 55 0c             	mov    0xc(%ebp),%edx
  801629:	89 02                	mov    %eax,(%edx)
	return 0;
  80162b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801630:	5d                   	pop    %ebp
  801631:	c3                   	ret    
		return -E_INVAL;
  801632:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801637:	eb f7                	jmp    801630 <fd_lookup+0x40>
		return -E_INVAL;
  801639:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80163e:	eb f0                	jmp    801630 <fd_lookup+0x40>
  801640:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801645:	eb e9                	jmp    801630 <fd_lookup+0x40>

00801647 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  801647:	55                   	push   %ebp
  801648:	89 e5                	mov    %esp,%ebp
  80164a:	83 ec 08             	sub    $0x8,%esp
  80164d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801650:	ba 10 2d 80 00       	mov    $0x802d10,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  801655:	b8 08 30 80 00       	mov    $0x803008,%eax
		if (devtab[i]->dev_id == dev_id) {
  80165a:	39 08                	cmp    %ecx,(%eax)
  80165c:	74 33                	je     801691 <dev_lookup+0x4a>
  80165e:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  801661:	8b 02                	mov    (%edx),%eax
  801663:	85 c0                	test   %eax,%eax
  801665:	75 f3                	jne    80165a <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  801667:	a1 04 40 80 00       	mov    0x804004,%eax
  80166c:	8b 40 48             	mov    0x48(%eax),%eax
  80166f:	83 ec 04             	sub    $0x4,%esp
  801672:	51                   	push   %ecx
  801673:	50                   	push   %eax
  801674:	68 90 2c 80 00       	push   $0x802c90
  801679:	e8 63 f1 ff ff       	call   8007e1 <cprintf>
	*dev = 0;
  80167e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801681:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  801687:	83 c4 10             	add    $0x10,%esp
  80168a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80168f:	c9                   	leave  
  801690:	c3                   	ret    
			*dev = devtab[i];
  801691:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801694:	89 01                	mov    %eax,(%ecx)
			return 0;
  801696:	b8 00 00 00 00       	mov    $0x0,%eax
  80169b:	eb f2                	jmp    80168f <dev_lookup+0x48>

0080169d <fd_close>:
{
  80169d:	55                   	push   %ebp
  80169e:	89 e5                	mov    %esp,%ebp
  8016a0:	57                   	push   %edi
  8016a1:	56                   	push   %esi
  8016a2:	53                   	push   %ebx
  8016a3:	83 ec 1c             	sub    $0x1c,%esp
  8016a6:	8b 75 08             	mov    0x8(%ebp),%esi
  8016a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016ac:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8016af:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8016b0:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  8016b6:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  8016b9:	50                   	push   %eax
  8016ba:	e8 31 ff ff ff       	call   8015f0 <fd_lookup>
  8016bf:	89 c7                	mov    %eax,%edi
  8016c1:	83 c4 08             	add    $0x8,%esp
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	78 05                	js     8016cd <fd_close+0x30>
	    || fd != fd2)
  8016c8:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  8016cb:	74 13                	je     8016e0 <fd_close+0x43>
		return (must_exist ? r : 0);
  8016cd:	84 db                	test   %bl,%bl
  8016cf:	75 05                	jne    8016d6 <fd_close+0x39>
  8016d1:	bf 00 00 00 00       	mov    $0x0,%edi
}
  8016d6:	89 f8                	mov    %edi,%eax
  8016d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8016db:	5b                   	pop    %ebx
  8016dc:	5e                   	pop    %esi
  8016dd:	5f                   	pop    %edi
  8016de:	5d                   	pop    %ebp
  8016df:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8016e6:	50                   	push   %eax
  8016e7:	ff 36                	pushl  (%esi)
  8016e9:	e8 59 ff ff ff       	call   801647 <dev_lookup>
  8016ee:	89 c7                	mov    %eax,%edi
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	85 c0                	test   %eax,%eax
  8016f5:	78 15                	js     80170c <fd_close+0x6f>
		if (dev->dev_close)
  8016f7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8016fa:	8b 40 10             	mov    0x10(%eax),%eax
  8016fd:	85 c0                	test   %eax,%eax
  8016ff:	74 1b                	je     80171c <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  801701:	83 ec 0c             	sub    $0xc,%esp
  801704:	56                   	push   %esi
  801705:	ff d0                	call   *%eax
  801707:	89 c7                	mov    %eax,%edi
  801709:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80170c:	83 ec 08             	sub    $0x8,%esp
  80170f:	56                   	push   %esi
  801710:	6a 00                	push   $0x0
  801712:	e8 0c fb ff ff       	call   801223 <sys_page_unmap>
	return r;
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	eb ba                	jmp    8016d6 <fd_close+0x39>
			r = 0;
  80171c:	bf 00 00 00 00       	mov    $0x0,%edi
  801721:	eb e9                	jmp    80170c <fd_close+0x6f>

00801723 <close>:

int
close(int fdnum)
{
  801723:	55                   	push   %ebp
  801724:	89 e5                	mov    %esp,%ebp
  801726:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801729:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80172c:	50                   	push   %eax
  80172d:	ff 75 08             	pushl  0x8(%ebp)
  801730:	e8 bb fe ff ff       	call   8015f0 <fd_lookup>
  801735:	83 c4 08             	add    $0x8,%esp
  801738:	85 c0                	test   %eax,%eax
  80173a:	78 10                	js     80174c <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  80173c:	83 ec 08             	sub    $0x8,%esp
  80173f:	6a 01                	push   $0x1
  801741:	ff 75 f4             	pushl  -0xc(%ebp)
  801744:	e8 54 ff ff ff       	call   80169d <fd_close>
  801749:	83 c4 10             	add    $0x10,%esp
}
  80174c:	c9                   	leave  
  80174d:	c3                   	ret    

0080174e <close_all>:

void
close_all(void)
{
  80174e:	55                   	push   %ebp
  80174f:	89 e5                	mov    %esp,%ebp
  801751:	53                   	push   %ebx
  801752:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  801755:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  80175a:	83 ec 0c             	sub    $0xc,%esp
  80175d:	53                   	push   %ebx
  80175e:	e8 c0 ff ff ff       	call   801723 <close>
	for (i = 0; i < MAXFD; i++)
  801763:	43                   	inc    %ebx
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	83 fb 20             	cmp    $0x20,%ebx
  80176a:	75 ee                	jne    80175a <close_all+0xc>
}
  80176c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	57                   	push   %edi
  801775:	56                   	push   %esi
  801776:	53                   	push   %ebx
  801777:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80177a:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80177d:	50                   	push   %eax
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 6a fe ff ff       	call   8015f0 <fd_lookup>
  801786:	89 c3                	mov    %eax,%ebx
  801788:	83 c4 08             	add    $0x8,%esp
  80178b:	85 c0                	test   %eax,%eax
  80178d:	0f 88 81 00 00 00    	js     801814 <dup+0xa3>
		return r;
	close(newfdnum);
  801793:	83 ec 0c             	sub    $0xc,%esp
  801796:	ff 75 0c             	pushl  0xc(%ebp)
  801799:	e8 85 ff ff ff       	call   801723 <close>

	newfd = INDEX2FD(newfdnum);
  80179e:	8b 75 0c             	mov    0xc(%ebp),%esi
  8017a1:	c1 e6 0c             	shl    $0xc,%esi
  8017a4:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  8017aa:	83 c4 04             	add    $0x4,%esp
  8017ad:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017b0:	e8 d5 fd ff ff       	call   80158a <fd2data>
  8017b5:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  8017b7:	89 34 24             	mov    %esi,(%esp)
  8017ba:	e8 cb fd ff ff       	call   80158a <fd2data>
  8017bf:	83 c4 10             	add    $0x10,%esp
  8017c2:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  8017c4:	89 d8                	mov    %ebx,%eax
  8017c6:	c1 e8 16             	shr    $0x16,%eax
  8017c9:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  8017d0:	a8 01                	test   $0x1,%al
  8017d2:	74 11                	je     8017e5 <dup+0x74>
  8017d4:	89 d8                	mov    %ebx,%eax
  8017d6:	c1 e8 0c             	shr    $0xc,%eax
  8017d9:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  8017e0:	f6 c2 01             	test   $0x1,%dl
  8017e3:	75 39                	jne    80181e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  8017e5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	c1 e8 0c             	shr    $0xc,%eax
  8017ed:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8017f4:	83 ec 0c             	sub    $0xc,%esp
  8017f7:	25 07 0e 00 00       	and    $0xe07,%eax
  8017fc:	50                   	push   %eax
  8017fd:	56                   	push   %esi
  8017fe:	6a 00                	push   $0x0
  801800:	52                   	push   %edx
  801801:	6a 00                	push   $0x0
  801803:	e8 d9 f9 ff ff       	call   8011e1 <sys_page_map>
  801808:	89 c3                	mov    %eax,%ebx
  80180a:	83 c4 20             	add    $0x20,%esp
  80180d:	85 c0                	test   %eax,%eax
  80180f:	78 31                	js     801842 <dup+0xd1>
		goto err;

	return newfdnum;
  801811:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  801814:	89 d8                	mov    %ebx,%eax
  801816:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801819:	5b                   	pop    %ebx
  80181a:	5e                   	pop    %esi
  80181b:	5f                   	pop    %edi
  80181c:	5d                   	pop    %ebp
  80181d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80181e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  801825:	83 ec 0c             	sub    $0xc,%esp
  801828:	25 07 0e 00 00       	and    $0xe07,%eax
  80182d:	50                   	push   %eax
  80182e:	57                   	push   %edi
  80182f:	6a 00                	push   $0x0
  801831:	53                   	push   %ebx
  801832:	6a 00                	push   $0x0
  801834:	e8 a8 f9 ff ff       	call   8011e1 <sys_page_map>
  801839:	89 c3                	mov    %eax,%ebx
  80183b:	83 c4 20             	add    $0x20,%esp
  80183e:	85 c0                	test   %eax,%eax
  801840:	79 a3                	jns    8017e5 <dup+0x74>
	sys_page_unmap(0, newfd);
  801842:	83 ec 08             	sub    $0x8,%esp
  801845:	56                   	push   %esi
  801846:	6a 00                	push   $0x0
  801848:	e8 d6 f9 ff ff       	call   801223 <sys_page_unmap>
	sys_page_unmap(0, nva);
  80184d:	83 c4 08             	add    $0x8,%esp
  801850:	57                   	push   %edi
  801851:	6a 00                	push   $0x0
  801853:	e8 cb f9 ff ff       	call   801223 <sys_page_unmap>
	return r;
  801858:	83 c4 10             	add    $0x10,%esp
  80185b:	eb b7                	jmp    801814 <dup+0xa3>

0080185d <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	53                   	push   %ebx
  801861:	83 ec 14             	sub    $0x14,%esp
  801864:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801867:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80186a:	50                   	push   %eax
  80186b:	53                   	push   %ebx
  80186c:	e8 7f fd ff ff       	call   8015f0 <fd_lookup>
  801871:	83 c4 08             	add    $0x8,%esp
  801874:	85 c0                	test   %eax,%eax
  801876:	78 3f                	js     8018b7 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801878:	83 ec 08             	sub    $0x8,%esp
  80187b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80187e:	50                   	push   %eax
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801882:	ff 30                	pushl  (%eax)
  801884:	e8 be fd ff ff       	call   801647 <dev_lookup>
  801889:	83 c4 10             	add    $0x10,%esp
  80188c:	85 c0                	test   %eax,%eax
  80188e:	78 27                	js     8018b7 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  801890:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801893:	8b 42 08             	mov    0x8(%edx),%eax
  801896:	83 e0 03             	and    $0x3,%eax
  801899:	83 f8 01             	cmp    $0x1,%eax
  80189c:	74 1e                	je     8018bc <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80189e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8018a1:	8b 40 08             	mov    0x8(%eax),%eax
  8018a4:	85 c0                	test   %eax,%eax
  8018a6:	74 35                	je     8018dd <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	ff 75 10             	pushl  0x10(%ebp)
  8018ae:	ff 75 0c             	pushl  0xc(%ebp)
  8018b1:	52                   	push   %edx
  8018b2:	ff d0                	call   *%eax
  8018b4:	83 c4 10             	add    $0x10,%esp
}
  8018b7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8018ba:	c9                   	leave  
  8018bb:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  8018bc:	a1 04 40 80 00       	mov    0x804004,%eax
  8018c1:	8b 40 48             	mov    0x48(%eax),%eax
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	53                   	push   %ebx
  8018c8:	50                   	push   %eax
  8018c9:	68 d4 2c 80 00       	push   $0x802cd4
  8018ce:	e8 0e ef ff ff       	call   8007e1 <cprintf>
		return -E_INVAL;
  8018d3:	83 c4 10             	add    $0x10,%esp
  8018d6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8018db:	eb da                	jmp    8018b7 <read+0x5a>
		return -E_NOT_SUPP;
  8018dd:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8018e2:	eb d3                	jmp    8018b7 <read+0x5a>

008018e4 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  8018e4:	55                   	push   %ebp
  8018e5:	89 e5                	mov    %esp,%ebp
  8018e7:	57                   	push   %edi
  8018e8:	56                   	push   %esi
  8018e9:	53                   	push   %ebx
  8018ea:	83 ec 0c             	sub    $0xc,%esp
  8018ed:	8b 7d 08             	mov    0x8(%ebp),%edi
  8018f0:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8018f3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8018f8:	39 f3                	cmp    %esi,%ebx
  8018fa:	73 25                	jae    801921 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8018fc:	83 ec 04             	sub    $0x4,%esp
  8018ff:	89 f0                	mov    %esi,%eax
  801901:	29 d8                	sub    %ebx,%eax
  801903:	50                   	push   %eax
  801904:	89 d8                	mov    %ebx,%eax
  801906:	03 45 0c             	add    0xc(%ebp),%eax
  801909:	50                   	push   %eax
  80190a:	57                   	push   %edi
  80190b:	e8 4d ff ff ff       	call   80185d <read>
		if (m < 0)
  801910:	83 c4 10             	add    $0x10,%esp
  801913:	85 c0                	test   %eax,%eax
  801915:	78 08                	js     80191f <readn+0x3b>
			return m;
		if (m == 0)
  801917:	85 c0                	test   %eax,%eax
  801919:	74 06                	je     801921 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80191b:	01 c3                	add    %eax,%ebx
  80191d:	eb d9                	jmp    8018f8 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80191f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  801921:	89 d8                	mov    %ebx,%eax
  801923:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5f                   	pop    %edi
  801929:	5d                   	pop    %ebp
  80192a:	c3                   	ret    

0080192b <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	53                   	push   %ebx
  80192f:	83 ec 14             	sub    $0x14,%esp
  801932:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801935:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801938:	50                   	push   %eax
  801939:	53                   	push   %ebx
  80193a:	e8 b1 fc ff ff       	call   8015f0 <fd_lookup>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	78 3a                	js     801980 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801946:	83 ec 08             	sub    $0x8,%esp
  801949:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80194c:	50                   	push   %eax
  80194d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801950:	ff 30                	pushl  (%eax)
  801952:	e8 f0 fc ff ff       	call   801647 <dev_lookup>
  801957:	83 c4 10             	add    $0x10,%esp
  80195a:	85 c0                	test   %eax,%eax
  80195c:	78 22                	js     801980 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  80195e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801961:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801965:	74 1e                	je     801985 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  801967:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80196a:	8b 52 0c             	mov    0xc(%edx),%edx
  80196d:	85 d2                	test   %edx,%edx
  80196f:	74 35                	je     8019a6 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  801971:	83 ec 04             	sub    $0x4,%esp
  801974:	ff 75 10             	pushl  0x10(%ebp)
  801977:	ff 75 0c             	pushl  0xc(%ebp)
  80197a:	50                   	push   %eax
  80197b:	ff d2                	call   *%edx
  80197d:	83 c4 10             	add    $0x10,%esp
}
  801980:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801983:	c9                   	leave  
  801984:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  801985:	a1 04 40 80 00       	mov    0x804004,%eax
  80198a:	8b 40 48             	mov    0x48(%eax),%eax
  80198d:	83 ec 04             	sub    $0x4,%esp
  801990:	53                   	push   %ebx
  801991:	50                   	push   %eax
  801992:	68 f0 2c 80 00       	push   $0x802cf0
  801997:	e8 45 ee ff ff       	call   8007e1 <cprintf>
		return -E_INVAL;
  80199c:	83 c4 10             	add    $0x10,%esp
  80199f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8019a4:	eb da                	jmp    801980 <write+0x55>
		return -E_NOT_SUPP;
  8019a6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8019ab:	eb d3                	jmp    801980 <write+0x55>

008019ad <seek>:

int
seek(int fdnum, off_t offset)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
  8019b0:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8019b3:	8d 45 fc             	lea    -0x4(%ebp),%eax
  8019b6:	50                   	push   %eax
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	e8 31 fc ff ff       	call   8015f0 <fd_lookup>
  8019bf:	83 c4 08             	add    $0x8,%esp
  8019c2:	85 c0                	test   %eax,%eax
  8019c4:	78 0e                	js     8019d4 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  8019c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cc:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  8019cf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
  8019d9:	53                   	push   %ebx
  8019da:	83 ec 14             	sub    $0x14,%esp
  8019dd:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  8019e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8019e3:	50                   	push   %eax
  8019e4:	53                   	push   %ebx
  8019e5:	e8 06 fc ff ff       	call   8015f0 <fd_lookup>
  8019ea:	83 c4 08             	add    $0x8,%esp
  8019ed:	85 c0                	test   %eax,%eax
  8019ef:	78 37                	js     801a28 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8019f1:	83 ec 08             	sub    $0x8,%esp
  8019f4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8019f7:	50                   	push   %eax
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	ff 30                	pushl  (%eax)
  8019fd:	e8 45 fc ff ff       	call   801647 <dev_lookup>
  801a02:	83 c4 10             	add    $0x10,%esp
  801a05:	85 c0                	test   %eax,%eax
  801a07:	78 1f                	js     801a28 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  801a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a0c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  801a10:	74 1b                	je     801a2d <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  801a12:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a15:	8b 52 18             	mov    0x18(%edx),%edx
  801a18:	85 d2                	test   %edx,%edx
  801a1a:	74 32                	je     801a4e <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  801a1c:	83 ec 08             	sub    $0x8,%esp
  801a1f:	ff 75 0c             	pushl  0xc(%ebp)
  801a22:	50                   	push   %eax
  801a23:	ff d2                	call   *%edx
  801a25:	83 c4 10             	add    $0x10,%esp
}
  801a28:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    
			thisenv->env_id, fdnum);
  801a2d:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  801a32:	8b 40 48             	mov    0x48(%eax),%eax
  801a35:	83 ec 04             	sub    $0x4,%esp
  801a38:	53                   	push   %ebx
  801a39:	50                   	push   %eax
  801a3a:	68 b0 2c 80 00       	push   $0x802cb0
  801a3f:	e8 9d ed ff ff       	call   8007e1 <cprintf>
		return -E_INVAL;
  801a44:	83 c4 10             	add    $0x10,%esp
  801a47:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801a4c:	eb da                	jmp    801a28 <ftruncate+0x52>
		return -E_NOT_SUPP;
  801a4e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801a53:	eb d3                	jmp    801a28 <ftruncate+0x52>

00801a55 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
  801a58:	53                   	push   %ebx
  801a59:	83 ec 14             	sub    $0x14,%esp
  801a5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  801a5f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801a62:	50                   	push   %eax
  801a63:	ff 75 08             	pushl  0x8(%ebp)
  801a66:	e8 85 fb ff ff       	call   8015f0 <fd_lookup>
  801a6b:	83 c4 08             	add    $0x8,%esp
  801a6e:	85 c0                	test   %eax,%eax
  801a70:	78 4b                	js     801abd <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  801a72:	83 ec 08             	sub    $0x8,%esp
  801a75:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801a78:	50                   	push   %eax
  801a79:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7c:	ff 30                	pushl  (%eax)
  801a7e:	e8 c4 fb ff ff       	call   801647 <dev_lookup>
  801a83:	83 c4 10             	add    $0x10,%esp
  801a86:	85 c0                	test   %eax,%eax
  801a88:	78 33                	js     801abd <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  801a8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a8d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  801a91:	74 2f                	je     801ac2 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  801a93:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  801a96:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  801a9d:	00 00 00 
	stat->st_type = 0;
  801aa0:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  801aa7:	00 00 00 
	stat->st_dev = dev;
  801aaa:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  801ab0:	83 ec 08             	sub    $0x8,%esp
  801ab3:	53                   	push   %ebx
  801ab4:	ff 75 f0             	pushl  -0x10(%ebp)
  801ab7:	ff 50 14             	call   *0x14(%eax)
  801aba:	83 c4 10             	add    $0x10,%esp
}
  801abd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    
		return -E_NOT_SUPP;
  801ac2:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  801ac7:	eb f4                	jmp    801abd <fstat+0x68>

00801ac9 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
  801acc:	56                   	push   %esi
  801acd:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  801ace:	83 ec 08             	sub    $0x8,%esp
  801ad1:	6a 00                	push   $0x0
  801ad3:	ff 75 08             	pushl  0x8(%ebp)
  801ad6:	e8 34 02 00 00       	call   801d0f <open>
  801adb:	89 c3                	mov    %eax,%ebx
  801add:	83 c4 10             	add    $0x10,%esp
  801ae0:	85 c0                	test   %eax,%eax
  801ae2:	78 1b                	js     801aff <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  801ae4:	83 ec 08             	sub    $0x8,%esp
  801ae7:	ff 75 0c             	pushl  0xc(%ebp)
  801aea:	50                   	push   %eax
  801aeb:	e8 65 ff ff ff       	call   801a55 <fstat>
  801af0:	89 c6                	mov    %eax,%esi
	close(fd);
  801af2:	89 1c 24             	mov    %ebx,(%esp)
  801af5:	e8 29 fc ff ff       	call   801723 <close>
	return r;
  801afa:	83 c4 10             	add    $0x10,%esp
  801afd:	89 f3                	mov    %esi,%ebx
}
  801aff:	89 d8                	mov    %ebx,%eax
  801b01:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b04:	5b                   	pop    %ebx
  801b05:	5e                   	pop    %esi
  801b06:	5d                   	pop    %ebp
  801b07:	c3                   	ret    

00801b08 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
  801b0b:	56                   	push   %esi
  801b0c:	53                   	push   %ebx
  801b0d:	89 c6                	mov    %eax,%esi
  801b0f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  801b11:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  801b18:	74 27                	je     801b41 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  801b1a:	6a 07                	push   $0x7
  801b1c:	68 00 50 80 00       	push   $0x805000
  801b21:	56                   	push   %esi
  801b22:	ff 35 00 40 80 00    	pushl  0x804000
  801b28:	e8 af f9 ff ff       	call   8014dc <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  801b2d:	83 c4 0c             	add    $0xc,%esp
  801b30:	6a 00                	push   $0x0
  801b32:	53                   	push   %ebx
  801b33:	6a 00                	push   $0x0
  801b35:	e8 19 f9 ff ff       	call   801453 <ipc_recv>
}
  801b3a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b3d:	5b                   	pop    %ebx
  801b3e:	5e                   	pop    %esi
  801b3f:	5d                   	pop    %ebp
  801b40:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  801b41:	83 ec 0c             	sub    $0xc,%esp
  801b44:	6a 01                	push   $0x1
  801b46:	e8 ed f9 ff ff       	call   801538 <ipc_find_env>
  801b4b:	a3 00 40 80 00       	mov    %eax,0x804000
  801b50:	83 c4 10             	add    $0x10,%esp
  801b53:	eb c5                	jmp    801b1a <fsipc+0x12>

00801b55 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  801b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5e:	8b 40 0c             	mov    0xc(%eax),%eax
  801b61:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  801b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  801b69:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  801b6e:	ba 00 00 00 00       	mov    $0x0,%edx
  801b73:	b8 02 00 00 00       	mov    $0x2,%eax
  801b78:	e8 8b ff ff ff       	call   801b08 <fsipc>
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <devfile_flush>:
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	8b 40 0c             	mov    0xc(%eax),%eax
  801b8b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  801b90:	ba 00 00 00 00       	mov    $0x0,%edx
  801b95:	b8 06 00 00 00       	mov    $0x6,%eax
  801b9a:	e8 69 ff ff ff       	call   801b08 <fsipc>
}
  801b9f:	c9                   	leave  
  801ba0:	c3                   	ret    

00801ba1 <devfile_stat>:
{
  801ba1:	55                   	push   %ebp
  801ba2:	89 e5                	mov    %esp,%ebp
  801ba4:	53                   	push   %ebx
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	8b 40 0c             	mov    0xc(%eax),%eax
  801bb1:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  801bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbb:	b8 05 00 00 00       	mov    $0x5,%eax
  801bc0:	e8 43 ff ff ff       	call   801b08 <fsipc>
  801bc5:	85 c0                	test   %eax,%eax
  801bc7:	78 2c                	js     801bf5 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  801bc9:	83 ec 08             	sub    $0x8,%esp
  801bcc:	68 00 50 80 00       	push   $0x805000
  801bd1:	53                   	push   %ebx
  801bd2:	e8 12 f2 ff ff       	call   800de9 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  801bd7:	a1 80 50 80 00       	mov    0x805080,%eax
  801bdc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  801be2:	a1 84 50 80 00       	mov    0x805084,%eax
  801be7:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  801bed:	83 c4 10             	add    $0x10,%esp
  801bf0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801bf8:	c9                   	leave  
  801bf9:	c3                   	ret    

00801bfa <devfile_write>:
{
  801bfa:	55                   	push   %ebp
  801bfb:	89 e5                	mov    %esp,%ebp
  801bfd:	53                   	push   %ebx
  801bfe:	83 ec 04             	sub    $0x4,%esp
  801c01:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  801c04:	89 d8                	mov    %ebx,%eax
  801c06:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  801c0c:	76 05                	jbe    801c13 <devfile_write+0x19>
  801c0e:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  801c13:	8b 55 08             	mov    0x8(%ebp),%edx
  801c16:	8b 52 0c             	mov    0xc(%edx),%edx
  801c19:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  801c1f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  801c24:	83 ec 04             	sub    $0x4,%esp
  801c27:	50                   	push   %eax
  801c28:	ff 75 0c             	pushl  0xc(%ebp)
  801c2b:	68 08 50 80 00       	push   $0x805008
  801c30:	e8 27 f3 ff ff       	call   800f5c <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  801c35:	ba 00 00 00 00       	mov    $0x0,%edx
  801c3a:	b8 04 00 00 00       	mov    $0x4,%eax
  801c3f:	e8 c4 fe ff ff       	call   801b08 <fsipc>
  801c44:	83 c4 10             	add    $0x10,%esp
  801c47:	85 c0                	test   %eax,%eax
  801c49:	78 0b                	js     801c56 <devfile_write+0x5c>
	assert(r <= n);
  801c4b:	39 c3                	cmp    %eax,%ebx
  801c4d:	72 0c                	jb     801c5b <devfile_write+0x61>
	assert(r <= PGSIZE);
  801c4f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801c54:	7f 1e                	jg     801c74 <devfile_write+0x7a>
}
  801c56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    
	assert(r <= n);
  801c5b:	68 20 2d 80 00       	push   $0x802d20
  801c60:	68 6f 2c 80 00       	push   $0x802c6f
  801c65:	68 98 00 00 00       	push   $0x98
  801c6a:	68 27 2d 80 00       	push   $0x802d27
  801c6f:	e8 5a ea ff ff       	call   8006ce <_panic>
	assert(r <= PGSIZE);
  801c74:	68 32 2d 80 00       	push   $0x802d32
  801c79:	68 6f 2c 80 00       	push   $0x802c6f
  801c7e:	68 99 00 00 00       	push   $0x99
  801c83:	68 27 2d 80 00       	push   $0x802d27
  801c88:	e8 41 ea ff ff       	call   8006ce <_panic>

00801c8d <devfile_read>:
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	56                   	push   %esi
  801c91:	53                   	push   %ebx
  801c92:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  801c95:	8b 45 08             	mov    0x8(%ebp),%eax
  801c98:	8b 40 0c             	mov    0xc(%eax),%eax
  801c9b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  801ca0:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  801ca6:	ba 00 00 00 00       	mov    $0x0,%edx
  801cab:	b8 03 00 00 00       	mov    $0x3,%eax
  801cb0:	e8 53 fe ff ff       	call   801b08 <fsipc>
  801cb5:	89 c3                	mov    %eax,%ebx
  801cb7:	85 c0                	test   %eax,%eax
  801cb9:	78 1f                	js     801cda <devfile_read+0x4d>
	assert(r <= n);
  801cbb:	39 c6                	cmp    %eax,%esi
  801cbd:	72 24                	jb     801ce3 <devfile_read+0x56>
	assert(r <= PGSIZE);
  801cbf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  801cc4:	7f 33                	jg     801cf9 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  801cc6:	83 ec 04             	sub    $0x4,%esp
  801cc9:	50                   	push   %eax
  801cca:	68 00 50 80 00       	push   $0x805000
  801ccf:	ff 75 0c             	pushl  0xc(%ebp)
  801cd2:	e8 85 f2 ff ff       	call   800f5c <memmove>
	return r;
  801cd7:	83 c4 10             	add    $0x10,%esp
}
  801cda:	89 d8                	mov    %ebx,%eax
  801cdc:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801cdf:	5b                   	pop    %ebx
  801ce0:	5e                   	pop    %esi
  801ce1:	5d                   	pop    %ebp
  801ce2:	c3                   	ret    
	assert(r <= n);
  801ce3:	68 20 2d 80 00       	push   $0x802d20
  801ce8:	68 6f 2c 80 00       	push   $0x802c6f
  801ced:	6a 7c                	push   $0x7c
  801cef:	68 27 2d 80 00       	push   $0x802d27
  801cf4:	e8 d5 e9 ff ff       	call   8006ce <_panic>
	assert(r <= PGSIZE);
  801cf9:	68 32 2d 80 00       	push   $0x802d32
  801cfe:	68 6f 2c 80 00       	push   $0x802c6f
  801d03:	6a 7d                	push   $0x7d
  801d05:	68 27 2d 80 00       	push   $0x802d27
  801d0a:	e8 bf e9 ff ff       	call   8006ce <_panic>

00801d0f <open>:
{
  801d0f:	55                   	push   %ebp
  801d10:	89 e5                	mov    %esp,%ebp
  801d12:	56                   	push   %esi
  801d13:	53                   	push   %ebx
  801d14:	83 ec 1c             	sub    $0x1c,%esp
  801d17:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  801d1a:	56                   	push   %esi
  801d1b:	e8 96 f0 ff ff       	call   800db6 <strlen>
  801d20:	83 c4 10             	add    $0x10,%esp
  801d23:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  801d28:	7f 6c                	jg     801d96 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  801d2a:	83 ec 0c             	sub    $0xc,%esp
  801d2d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801d30:	50                   	push   %eax
  801d31:	e8 6b f8 ff ff       	call   8015a1 <fd_alloc>
  801d36:	89 c3                	mov    %eax,%ebx
  801d38:	83 c4 10             	add    $0x10,%esp
  801d3b:	85 c0                	test   %eax,%eax
  801d3d:	78 3c                	js     801d7b <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  801d3f:	83 ec 08             	sub    $0x8,%esp
  801d42:	56                   	push   %esi
  801d43:	68 00 50 80 00       	push   $0x805000
  801d48:	e8 9c f0 ff ff       	call   800de9 <strcpy>
	fsipcbuf.open.req_omode = mode;
  801d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801d50:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  801d55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801d58:	b8 01 00 00 00       	mov    $0x1,%eax
  801d5d:	e8 a6 fd ff ff       	call   801b08 <fsipc>
  801d62:	89 c3                	mov    %eax,%ebx
  801d64:	83 c4 10             	add    $0x10,%esp
  801d67:	85 c0                	test   %eax,%eax
  801d69:	78 19                	js     801d84 <open+0x75>
	return fd2num(fd);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	ff 75 f4             	pushl  -0xc(%ebp)
  801d71:	e8 04 f8 ff ff       	call   80157a <fd2num>
  801d76:	89 c3                	mov    %eax,%ebx
  801d78:	83 c4 10             	add    $0x10,%esp
}
  801d7b:	89 d8                	mov    %ebx,%eax
  801d7d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d80:	5b                   	pop    %ebx
  801d81:	5e                   	pop    %esi
  801d82:	5d                   	pop    %ebp
  801d83:	c3                   	ret    
		fd_close(fd, 0);
  801d84:	83 ec 08             	sub    $0x8,%esp
  801d87:	6a 00                	push   $0x0
  801d89:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8c:	e8 0c f9 ff ff       	call   80169d <fd_close>
		return r;
  801d91:	83 c4 10             	add    $0x10,%esp
  801d94:	eb e5                	jmp    801d7b <open+0x6c>
		return -E_BAD_PATH;
  801d96:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  801d9b:	eb de                	jmp    801d7b <open+0x6c>

00801d9d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  801da3:	ba 00 00 00 00       	mov    $0x0,%edx
  801da8:	b8 08 00 00 00       	mov    $0x8,%eax
  801dad:	e8 56 fd ff ff       	call   801b08 <fsipc>
}
  801db2:	c9                   	leave  
  801db3:	c3                   	ret    

00801db4 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  801db4:	55                   	push   %ebp
  801db5:	89 e5                	mov    %esp,%ebp
  801db7:	56                   	push   %esi
  801db8:	53                   	push   %ebx
  801db9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  801dbc:	83 ec 0c             	sub    $0xc,%esp
  801dbf:	ff 75 08             	pushl  0x8(%ebp)
  801dc2:	e8 c3 f7 ff ff       	call   80158a <fd2data>
  801dc7:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  801dc9:	83 c4 08             	add    $0x8,%esp
  801dcc:	68 3e 2d 80 00       	push   $0x802d3e
  801dd1:	53                   	push   %ebx
  801dd2:	e8 12 f0 ff ff       	call   800de9 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  801dd7:	8b 46 04             	mov    0x4(%esi),%eax
  801dda:	2b 06                	sub    (%esi),%eax
  801ddc:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  801de2:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  801de9:	10 00 00 
	stat->st_dev = &devpipe;
  801dec:	c7 83 88 00 00 00 24 	movl   $0x803024,0x88(%ebx)
  801df3:	30 80 00 
	return 0;
}
  801df6:	b8 00 00 00 00       	mov    $0x0,%eax
  801dfb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dfe:	5b                   	pop    %ebx
  801dff:	5e                   	pop    %esi
  801e00:	5d                   	pop    %ebp
  801e01:	c3                   	ret    

00801e02 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  801e02:	55                   	push   %ebp
  801e03:	89 e5                	mov    %esp,%ebp
  801e05:	53                   	push   %ebx
  801e06:	83 ec 0c             	sub    $0xc,%esp
  801e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  801e0c:	53                   	push   %ebx
  801e0d:	6a 00                	push   $0x0
  801e0f:	e8 0f f4 ff ff       	call   801223 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  801e14:	89 1c 24             	mov    %ebx,(%esp)
  801e17:	e8 6e f7 ff ff       	call   80158a <fd2data>
  801e1c:	83 c4 08             	add    $0x8,%esp
  801e1f:	50                   	push   %eax
  801e20:	6a 00                	push   $0x0
  801e22:	e8 fc f3 ff ff       	call   801223 <sys_page_unmap>
}
  801e27:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e2a:	c9                   	leave  
  801e2b:	c3                   	ret    

00801e2c <_pipeisclosed>:
{
  801e2c:	55                   	push   %ebp
  801e2d:	89 e5                	mov    %esp,%ebp
  801e2f:	57                   	push   %edi
  801e30:	56                   	push   %esi
  801e31:	53                   	push   %ebx
  801e32:	83 ec 1c             	sub    $0x1c,%esp
  801e35:	89 c7                	mov    %eax,%edi
  801e37:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  801e39:	a1 04 40 80 00       	mov    0x804004,%eax
  801e3e:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  801e41:	83 ec 0c             	sub    $0xc,%esp
  801e44:	57                   	push   %edi
  801e45:	e8 3b 04 00 00       	call   802285 <pageref>
  801e4a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801e4d:	89 34 24             	mov    %esi,(%esp)
  801e50:	e8 30 04 00 00       	call   802285 <pageref>
		nn = thisenv->env_runs;
  801e55:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801e5b:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  801e5e:	83 c4 10             	add    $0x10,%esp
  801e61:	39 cb                	cmp    %ecx,%ebx
  801e63:	74 1b                	je     801e80 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  801e65:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e68:	75 cf                	jne    801e39 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  801e6a:	8b 42 58             	mov    0x58(%edx),%eax
  801e6d:	6a 01                	push   $0x1
  801e6f:	50                   	push   %eax
  801e70:	53                   	push   %ebx
  801e71:	68 45 2d 80 00       	push   $0x802d45
  801e76:	e8 66 e9 ff ff       	call   8007e1 <cprintf>
  801e7b:	83 c4 10             	add    $0x10,%esp
  801e7e:	eb b9                	jmp    801e39 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  801e80:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  801e83:	0f 94 c0             	sete   %al
  801e86:	0f b6 c0             	movzbl %al,%eax
}
  801e89:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801e8c:	5b                   	pop    %ebx
  801e8d:	5e                   	pop    %esi
  801e8e:	5f                   	pop    %edi
  801e8f:	5d                   	pop    %ebp
  801e90:	c3                   	ret    

00801e91 <devpipe_write>:
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
  801e94:	57                   	push   %edi
  801e95:	56                   	push   %esi
  801e96:	53                   	push   %ebx
  801e97:	83 ec 18             	sub    $0x18,%esp
  801e9a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  801e9d:	56                   	push   %esi
  801e9e:	e8 e7 f6 ff ff       	call   80158a <fd2data>
  801ea3:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  801ea5:	83 c4 10             	add    $0x10,%esp
  801ea8:	bf 00 00 00 00       	mov    $0x0,%edi
  801ead:	3b 7d 10             	cmp    0x10(%ebp),%edi
  801eb0:	74 41                	je     801ef3 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  801eb2:	8b 53 04             	mov    0x4(%ebx),%edx
  801eb5:	8b 03                	mov    (%ebx),%eax
  801eb7:	83 c0 20             	add    $0x20,%eax
  801eba:	39 c2                	cmp    %eax,%edx
  801ebc:	72 14                	jb     801ed2 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  801ebe:	89 da                	mov    %ebx,%edx
  801ec0:	89 f0                	mov    %esi,%eax
  801ec2:	e8 65 ff ff ff       	call   801e2c <_pipeisclosed>
  801ec7:	85 c0                	test   %eax,%eax
  801ec9:	75 2c                	jne    801ef7 <devpipe_write+0x66>
			sys_yield();
  801ecb:	e8 95 f3 ff ff       	call   801265 <sys_yield>
  801ed0:	eb e0                	jmp    801eb2 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801ed2:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ed5:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  801ed8:	89 d0                	mov    %edx,%eax
  801eda:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801edf:	78 0b                	js     801eec <devpipe_write+0x5b>
  801ee1:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  801ee5:	42                   	inc    %edx
  801ee6:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  801ee9:	47                   	inc    %edi
  801eea:	eb c1                	jmp    801ead <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  801eec:	48                   	dec    %eax
  801eed:	83 c8 e0             	or     $0xffffffe0,%eax
  801ef0:	40                   	inc    %eax
  801ef1:	eb ee                	jmp    801ee1 <devpipe_write+0x50>
	return i;
  801ef3:	89 f8                	mov    %edi,%eax
  801ef5:	eb 05                	jmp    801efc <devpipe_write+0x6b>
				return 0;
  801ef7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801efc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    

00801f04 <devpipe_read>:
{
  801f04:	55                   	push   %ebp
  801f05:	89 e5                	mov    %esp,%ebp
  801f07:	57                   	push   %edi
  801f08:	56                   	push   %esi
  801f09:	53                   	push   %ebx
  801f0a:	83 ec 18             	sub    $0x18,%esp
  801f0d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  801f10:	57                   	push   %edi
  801f11:	e8 74 f6 ff ff       	call   80158a <fd2data>
  801f16:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  801f18:	83 c4 10             	add    $0x10,%esp
  801f1b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801f20:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  801f23:	74 46                	je     801f6b <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  801f25:	8b 06                	mov    (%esi),%eax
  801f27:	3b 46 04             	cmp    0x4(%esi),%eax
  801f2a:	75 22                	jne    801f4e <devpipe_read+0x4a>
			if (i > 0)
  801f2c:	85 db                	test   %ebx,%ebx
  801f2e:	74 0a                	je     801f3a <devpipe_read+0x36>
				return i;
  801f30:	89 d8                	mov    %ebx,%eax
}
  801f32:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801f35:	5b                   	pop    %ebx
  801f36:	5e                   	pop    %esi
  801f37:	5f                   	pop    %edi
  801f38:	5d                   	pop    %ebp
  801f39:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  801f3a:	89 f2                	mov    %esi,%edx
  801f3c:	89 f8                	mov    %edi,%eax
  801f3e:	e8 e9 fe ff ff       	call   801e2c <_pipeisclosed>
  801f43:	85 c0                	test   %eax,%eax
  801f45:	75 28                	jne    801f6f <devpipe_read+0x6b>
			sys_yield();
  801f47:	e8 19 f3 ff ff       	call   801265 <sys_yield>
  801f4c:	eb d7                	jmp    801f25 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f4e:	25 1f 00 00 80       	and    $0x8000001f,%eax
  801f53:	78 0f                	js     801f64 <devpipe_read+0x60>
  801f55:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  801f59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801f5c:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  801f5f:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  801f61:	43                   	inc    %ebx
  801f62:	eb bc                	jmp    801f20 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  801f64:	48                   	dec    %eax
  801f65:	83 c8 e0             	or     $0xffffffe0,%eax
  801f68:	40                   	inc    %eax
  801f69:	eb ea                	jmp    801f55 <devpipe_read+0x51>
	return i;
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	eb c3                	jmp    801f32 <devpipe_read+0x2e>
				return 0;
  801f6f:	b8 00 00 00 00       	mov    $0x0,%eax
  801f74:	eb bc                	jmp    801f32 <devpipe_read+0x2e>

00801f76 <pipe>:
{
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	56                   	push   %esi
  801f7a:	53                   	push   %ebx
  801f7b:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  801f7e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801f81:	50                   	push   %eax
  801f82:	e8 1a f6 ff ff       	call   8015a1 <fd_alloc>
  801f87:	89 c3                	mov    %eax,%ebx
  801f89:	83 c4 10             	add    $0x10,%esp
  801f8c:	85 c0                	test   %eax,%eax
  801f8e:	0f 88 2a 01 00 00    	js     8020be <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801f94:	83 ec 04             	sub    $0x4,%esp
  801f97:	68 07 04 00 00       	push   $0x407
  801f9c:	ff 75 f4             	pushl  -0xc(%ebp)
  801f9f:	6a 00                	push   $0x0
  801fa1:	e8 f8 f1 ff ff       	call   80119e <sys_page_alloc>
  801fa6:	89 c3                	mov    %eax,%ebx
  801fa8:	83 c4 10             	add    $0x10,%esp
  801fab:	85 c0                	test   %eax,%eax
  801fad:	0f 88 0b 01 00 00    	js     8020be <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  801fb3:	83 ec 0c             	sub    $0xc,%esp
  801fb6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  801fb9:	50                   	push   %eax
  801fba:	e8 e2 f5 ff ff       	call   8015a1 <fd_alloc>
  801fbf:	89 c3                	mov    %eax,%ebx
  801fc1:	83 c4 10             	add    $0x10,%esp
  801fc4:	85 c0                	test   %eax,%eax
  801fc6:	0f 88 e2 00 00 00    	js     8020ae <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801fcc:	83 ec 04             	sub    $0x4,%esp
  801fcf:	68 07 04 00 00       	push   $0x407
  801fd4:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd7:	6a 00                	push   $0x0
  801fd9:	e8 c0 f1 ff ff       	call   80119e <sys_page_alloc>
  801fde:	89 c3                	mov    %eax,%ebx
  801fe0:	83 c4 10             	add    $0x10,%esp
  801fe3:	85 c0                	test   %eax,%eax
  801fe5:	0f 88 c3 00 00 00    	js     8020ae <pipe+0x138>
	va = fd2data(fd0);
  801feb:	83 ec 0c             	sub    $0xc,%esp
  801fee:	ff 75 f4             	pushl  -0xc(%ebp)
  801ff1:	e8 94 f5 ff ff       	call   80158a <fd2data>
  801ff6:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  801ff8:	83 c4 0c             	add    $0xc,%esp
  801ffb:	68 07 04 00 00       	push   $0x407
  802000:	50                   	push   %eax
  802001:	6a 00                	push   $0x0
  802003:	e8 96 f1 ff ff       	call   80119e <sys_page_alloc>
  802008:	89 c3                	mov    %eax,%ebx
  80200a:	83 c4 10             	add    $0x10,%esp
  80200d:	85 c0                	test   %eax,%eax
  80200f:	0f 88 89 00 00 00    	js     80209e <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  802015:	83 ec 0c             	sub    $0xc,%esp
  802018:	ff 75 f0             	pushl  -0x10(%ebp)
  80201b:	e8 6a f5 ff ff       	call   80158a <fd2data>
  802020:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  802027:	50                   	push   %eax
  802028:	6a 00                	push   $0x0
  80202a:	56                   	push   %esi
  80202b:	6a 00                	push   $0x0
  80202d:	e8 af f1 ff ff       	call   8011e1 <sys_page_map>
  802032:	89 c3                	mov    %eax,%ebx
  802034:	83 c4 20             	add    $0x20,%esp
  802037:	85 c0                	test   %eax,%eax
  802039:	78 55                	js     802090 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  80203b:	8b 15 24 30 80 00    	mov    0x803024,%edx
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  802046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802049:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  802050:	8b 15 24 30 80 00    	mov    0x803024,%edx
  802056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802059:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  80205b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80205e:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  802065:	83 ec 0c             	sub    $0xc,%esp
  802068:	ff 75 f4             	pushl  -0xc(%ebp)
  80206b:	e8 0a f5 ff ff       	call   80157a <fd2num>
  802070:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802073:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  802075:	83 c4 04             	add    $0x4,%esp
  802078:	ff 75 f0             	pushl  -0x10(%ebp)
  80207b:	e8 fa f4 ff ff       	call   80157a <fd2num>
  802080:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802083:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  802086:	83 c4 10             	add    $0x10,%esp
  802089:	bb 00 00 00 00       	mov    $0x0,%ebx
  80208e:	eb 2e                	jmp    8020be <pipe+0x148>
	sys_page_unmap(0, va);
  802090:	83 ec 08             	sub    $0x8,%esp
  802093:	56                   	push   %esi
  802094:	6a 00                	push   $0x0
  802096:	e8 88 f1 ff ff       	call   801223 <sys_page_unmap>
  80209b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  80209e:	83 ec 08             	sub    $0x8,%esp
  8020a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8020a4:	6a 00                	push   $0x0
  8020a6:	e8 78 f1 ff ff       	call   801223 <sys_page_unmap>
  8020ab:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  8020ae:	83 ec 08             	sub    $0x8,%esp
  8020b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8020b4:	6a 00                	push   $0x0
  8020b6:	e8 68 f1 ff ff       	call   801223 <sys_page_unmap>
  8020bb:	83 c4 10             	add    $0x10,%esp
}
  8020be:	89 d8                	mov    %ebx,%eax
  8020c0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8020c3:	5b                   	pop    %ebx
  8020c4:	5e                   	pop    %esi
  8020c5:	5d                   	pop    %ebp
  8020c6:	c3                   	ret    

008020c7 <pipeisclosed>:
{
  8020c7:	55                   	push   %ebp
  8020c8:	89 e5                	mov    %esp,%ebp
  8020ca:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8020cd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8020d0:	50                   	push   %eax
  8020d1:	ff 75 08             	pushl  0x8(%ebp)
  8020d4:	e8 17 f5 ff ff       	call   8015f0 <fd_lookup>
  8020d9:	83 c4 10             	add    $0x10,%esp
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	78 18                	js     8020f8 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8020e0:	83 ec 0c             	sub    $0xc,%esp
  8020e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8020e6:	e8 9f f4 ff ff       	call   80158a <fd2data>
	return _pipeisclosed(fd, p);
  8020eb:	89 c2                	mov    %eax,%edx
  8020ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f0:	e8 37 fd ff ff       	call   801e2c <_pipeisclosed>
  8020f5:	83 c4 10             	add    $0x10,%esp
}
  8020f8:	c9                   	leave  
  8020f9:	c3                   	ret    

008020fa <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8020fa:	55                   	push   %ebp
  8020fb:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8020fd:	b8 00 00 00 00       	mov    $0x0,%eax
  802102:	5d                   	pop    %ebp
  802103:	c3                   	ret    

00802104 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  802104:	55                   	push   %ebp
  802105:	89 e5                	mov    %esp,%ebp
  802107:	53                   	push   %ebx
  802108:	83 ec 0c             	sub    $0xc,%esp
  80210b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  80210e:	68 5d 2d 80 00       	push   $0x802d5d
  802113:	53                   	push   %ebx
  802114:	e8 d0 ec ff ff       	call   800de9 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  802119:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  802120:	20 00 00 
	return 0;
}
  802123:	b8 00 00 00 00       	mov    $0x0,%eax
  802128:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80212b:	c9                   	leave  
  80212c:	c3                   	ret    

0080212d <devcons_write>:
{
  80212d:	55                   	push   %ebp
  80212e:	89 e5                	mov    %esp,%ebp
  802130:	57                   	push   %edi
  802131:	56                   	push   %esi
  802132:	53                   	push   %ebx
  802133:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  802139:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  80213e:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  802144:	eb 1d                	jmp    802163 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  802146:	83 ec 04             	sub    $0x4,%esp
  802149:	53                   	push   %ebx
  80214a:	03 45 0c             	add    0xc(%ebp),%eax
  80214d:	50                   	push   %eax
  80214e:	57                   	push   %edi
  80214f:	e8 08 ee ff ff       	call   800f5c <memmove>
		sys_cputs(buf, m);
  802154:	83 c4 08             	add    $0x8,%esp
  802157:	53                   	push   %ebx
  802158:	57                   	push   %edi
  802159:	e8 a3 ef ff ff       	call   801101 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  80215e:	01 de                	add    %ebx,%esi
  802160:	83 c4 10             	add    $0x10,%esp
  802163:	89 f0                	mov    %esi,%eax
  802165:	3b 75 10             	cmp    0x10(%ebp),%esi
  802168:	73 11                	jae    80217b <devcons_write+0x4e>
		m = n - tot;
  80216a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80216d:	29 f3                	sub    %esi,%ebx
  80216f:	83 fb 7f             	cmp    $0x7f,%ebx
  802172:	76 d2                	jbe    802146 <devcons_write+0x19>
  802174:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  802179:	eb cb                	jmp    802146 <devcons_write+0x19>
}
  80217b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80217e:	5b                   	pop    %ebx
  80217f:	5e                   	pop    %esi
  802180:	5f                   	pop    %edi
  802181:	5d                   	pop    %ebp
  802182:	c3                   	ret    

00802183 <devcons_read>:
{
  802183:	55                   	push   %ebp
  802184:	89 e5                	mov    %esp,%ebp
  802186:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  802189:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80218d:	75 0c                	jne    80219b <devcons_read+0x18>
		return 0;
  80218f:	b8 00 00 00 00       	mov    $0x0,%eax
  802194:	eb 21                	jmp    8021b7 <devcons_read+0x34>
		sys_yield();
  802196:	e8 ca f0 ff ff       	call   801265 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80219b:	e8 7f ef ff ff       	call   80111f <sys_cgetc>
  8021a0:	85 c0                	test   %eax,%eax
  8021a2:	74 f2                	je     802196 <devcons_read+0x13>
	if (c < 0)
  8021a4:	85 c0                	test   %eax,%eax
  8021a6:	78 0f                	js     8021b7 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  8021a8:	83 f8 04             	cmp    $0x4,%eax
  8021ab:	74 0c                	je     8021b9 <devcons_read+0x36>
	*(char*)vbuf = c;
  8021ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021b0:	88 02                	mov    %al,(%edx)
	return 1;
  8021b2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8021b7:	c9                   	leave  
  8021b8:	c3                   	ret    
		return 0;
  8021b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8021be:	eb f7                	jmp    8021b7 <devcons_read+0x34>

008021c0 <cputchar>:
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  8021cc:	6a 01                	push   $0x1
  8021ce:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021d1:	50                   	push   %eax
  8021d2:	e8 2a ef ff ff       	call   801101 <sys_cputs>
}
  8021d7:	83 c4 10             	add    $0x10,%esp
  8021da:	c9                   	leave  
  8021db:	c3                   	ret    

008021dc <getchar>:
{
  8021dc:	55                   	push   %ebp
  8021dd:	89 e5                	mov    %esp,%ebp
  8021df:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8021e2:	6a 01                	push   $0x1
  8021e4:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8021e7:	50                   	push   %eax
  8021e8:	6a 00                	push   $0x0
  8021ea:	e8 6e f6 ff ff       	call   80185d <read>
	if (r < 0)
  8021ef:	83 c4 10             	add    $0x10,%esp
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	78 08                	js     8021fe <getchar+0x22>
	if (r < 1)
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	7e 06                	jle    802200 <getchar+0x24>
	return c;
  8021fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8021fe:	c9                   	leave  
  8021ff:	c3                   	ret    
		return -E_EOF;
  802200:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  802205:	eb f7                	jmp    8021fe <getchar+0x22>

00802207 <iscons>:
{
  802207:	55                   	push   %ebp
  802208:	89 e5                	mov    %esp,%ebp
  80220a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80220d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  802210:	50                   	push   %eax
  802211:	ff 75 08             	pushl  0x8(%ebp)
  802214:	e8 d7 f3 ff ff       	call   8015f0 <fd_lookup>
  802219:	83 c4 10             	add    $0x10,%esp
  80221c:	85 c0                	test   %eax,%eax
  80221e:	78 11                	js     802231 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  802220:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802223:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802229:	39 10                	cmp    %edx,(%eax)
  80222b:	0f 94 c0             	sete   %al
  80222e:	0f b6 c0             	movzbl %al,%eax
}
  802231:	c9                   	leave  
  802232:	c3                   	ret    

00802233 <opencons>:
{
  802233:	55                   	push   %ebp
  802234:	89 e5                	mov    %esp,%ebp
  802236:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  802239:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80223c:	50                   	push   %eax
  80223d:	e8 5f f3 ff ff       	call   8015a1 <fd_alloc>
  802242:	83 c4 10             	add    $0x10,%esp
  802245:	85 c0                	test   %eax,%eax
  802247:	78 3a                	js     802283 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  802249:	83 ec 04             	sub    $0x4,%esp
  80224c:	68 07 04 00 00       	push   $0x407
  802251:	ff 75 f4             	pushl  -0xc(%ebp)
  802254:	6a 00                	push   $0x0
  802256:	e8 43 ef ff ff       	call   80119e <sys_page_alloc>
  80225b:	83 c4 10             	add    $0x10,%esp
  80225e:	85 c0                	test   %eax,%eax
  802260:	78 21                	js     802283 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  802262:	8b 15 40 30 80 00    	mov    0x803040,%edx
  802268:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80226b:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  80226d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802270:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  802277:	83 ec 0c             	sub    $0xc,%esp
  80227a:	50                   	push   %eax
  80227b:	e8 fa f2 ff ff       	call   80157a <fd2num>
  802280:	83 c4 10             	add    $0x10,%esp
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  802288:	8b 45 08             	mov    0x8(%ebp),%eax
  80228b:	c1 e8 16             	shr    $0x16,%eax
  80228e:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  802295:	a8 01                	test   $0x1,%al
  802297:	74 21                	je     8022ba <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  802299:	8b 45 08             	mov    0x8(%ebp),%eax
  80229c:	c1 e8 0c             	shr    $0xc,%eax
  80229f:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  8022a6:	a8 01                	test   $0x1,%al
  8022a8:	74 17                	je     8022c1 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  8022aa:	c1 e8 0c             	shr    $0xc,%eax
  8022ad:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  8022b4:	ef 
  8022b5:	0f b7 c0             	movzwl %ax,%eax
  8022b8:	eb 05                	jmp    8022bf <pageref+0x3a>
		return 0;
  8022ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022bf:	5d                   	pop    %ebp
  8022c0:	c3                   	ret    
		return 0;
  8022c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8022c6:	eb f7                	jmp    8022bf <pageref+0x3a>

008022c8 <__udivdi3>:
  8022c8:	55                   	push   %ebp
  8022c9:	57                   	push   %edi
  8022ca:	56                   	push   %esi
  8022cb:	53                   	push   %ebx
  8022cc:	83 ec 1c             	sub    $0x1c,%esp
  8022cf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8022d3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8022d7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8022db:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  8022df:	89 ca                	mov    %ecx,%edx
  8022e1:	89 f8                	mov    %edi,%eax
  8022e3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8022e7:	85 f6                	test   %esi,%esi
  8022e9:	75 2d                	jne    802318 <__udivdi3+0x50>
  8022eb:	39 cf                	cmp    %ecx,%edi
  8022ed:	77 65                	ja     802354 <__udivdi3+0x8c>
  8022ef:	89 fd                	mov    %edi,%ebp
  8022f1:	85 ff                	test   %edi,%edi
  8022f3:	75 0b                	jne    802300 <__udivdi3+0x38>
  8022f5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022fa:	31 d2                	xor    %edx,%edx
  8022fc:	f7 f7                	div    %edi
  8022fe:	89 c5                	mov    %eax,%ebp
  802300:	31 d2                	xor    %edx,%edx
  802302:	89 c8                	mov    %ecx,%eax
  802304:	f7 f5                	div    %ebp
  802306:	89 c1                	mov    %eax,%ecx
  802308:	89 d8                	mov    %ebx,%eax
  80230a:	f7 f5                	div    %ebp
  80230c:	89 cf                	mov    %ecx,%edi
  80230e:	89 fa                	mov    %edi,%edx
  802310:	83 c4 1c             	add    $0x1c,%esp
  802313:	5b                   	pop    %ebx
  802314:	5e                   	pop    %esi
  802315:	5f                   	pop    %edi
  802316:	5d                   	pop    %ebp
  802317:	c3                   	ret    
  802318:	39 ce                	cmp    %ecx,%esi
  80231a:	77 28                	ja     802344 <__udivdi3+0x7c>
  80231c:	0f bd fe             	bsr    %esi,%edi
  80231f:	83 f7 1f             	xor    $0x1f,%edi
  802322:	75 40                	jne    802364 <__udivdi3+0x9c>
  802324:	39 ce                	cmp    %ecx,%esi
  802326:	72 0a                	jb     802332 <__udivdi3+0x6a>
  802328:	3b 44 24 04          	cmp    0x4(%esp),%eax
  80232c:	0f 87 9e 00 00 00    	ja     8023d0 <__udivdi3+0x108>
  802332:	b8 01 00 00 00       	mov    $0x1,%eax
  802337:	89 fa                	mov    %edi,%edx
  802339:	83 c4 1c             	add    $0x1c,%esp
  80233c:	5b                   	pop    %ebx
  80233d:	5e                   	pop    %esi
  80233e:	5f                   	pop    %edi
  80233f:	5d                   	pop    %ebp
  802340:	c3                   	ret    
  802341:	8d 76 00             	lea    0x0(%esi),%esi
  802344:	31 ff                	xor    %edi,%edi
  802346:	31 c0                	xor    %eax,%eax
  802348:	89 fa                	mov    %edi,%edx
  80234a:	83 c4 1c             	add    $0x1c,%esp
  80234d:	5b                   	pop    %ebx
  80234e:	5e                   	pop    %esi
  80234f:	5f                   	pop    %edi
  802350:	5d                   	pop    %ebp
  802351:	c3                   	ret    
  802352:	66 90                	xchg   %ax,%ax
  802354:	89 d8                	mov    %ebx,%eax
  802356:	f7 f7                	div    %edi
  802358:	31 ff                	xor    %edi,%edi
  80235a:	89 fa                	mov    %edi,%edx
  80235c:	83 c4 1c             	add    $0x1c,%esp
  80235f:	5b                   	pop    %ebx
  802360:	5e                   	pop    %esi
  802361:	5f                   	pop    %edi
  802362:	5d                   	pop    %ebp
  802363:	c3                   	ret    
  802364:	bd 20 00 00 00       	mov    $0x20,%ebp
  802369:	29 fd                	sub    %edi,%ebp
  80236b:	89 f9                	mov    %edi,%ecx
  80236d:	d3 e6                	shl    %cl,%esi
  80236f:	89 c3                	mov    %eax,%ebx
  802371:	89 e9                	mov    %ebp,%ecx
  802373:	d3 eb                	shr    %cl,%ebx
  802375:	89 d9                	mov    %ebx,%ecx
  802377:	09 f1                	or     %esi,%ecx
  802379:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80237d:	89 f9                	mov    %edi,%ecx
  80237f:	d3 e0                	shl    %cl,%eax
  802381:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802385:	89 d6                	mov    %edx,%esi
  802387:	89 e9                	mov    %ebp,%ecx
  802389:	d3 ee                	shr    %cl,%esi
  80238b:	89 f9                	mov    %edi,%ecx
  80238d:	d3 e2                	shl    %cl,%edx
  80238f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  802393:	89 e9                	mov    %ebp,%ecx
  802395:	d3 eb                	shr    %cl,%ebx
  802397:	09 da                	or     %ebx,%edx
  802399:	89 d0                	mov    %edx,%eax
  80239b:	89 f2                	mov    %esi,%edx
  80239d:	f7 74 24 08          	divl   0x8(%esp)
  8023a1:	89 d6                	mov    %edx,%esi
  8023a3:	89 c3                	mov    %eax,%ebx
  8023a5:	f7 64 24 0c          	mull   0xc(%esp)
  8023a9:	39 d6                	cmp    %edx,%esi
  8023ab:	72 17                	jb     8023c4 <__udivdi3+0xfc>
  8023ad:	74 09                	je     8023b8 <__udivdi3+0xf0>
  8023af:	89 d8                	mov    %ebx,%eax
  8023b1:	31 ff                	xor    %edi,%edi
  8023b3:	e9 56 ff ff ff       	jmp    80230e <__udivdi3+0x46>
  8023b8:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023bc:	89 f9                	mov    %edi,%ecx
  8023be:	d3 e2                	shl    %cl,%edx
  8023c0:	39 c2                	cmp    %eax,%edx
  8023c2:	73 eb                	jae    8023af <__udivdi3+0xe7>
  8023c4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8023c7:	31 ff                	xor    %edi,%edi
  8023c9:	e9 40 ff ff ff       	jmp    80230e <__udivdi3+0x46>
  8023ce:	66 90                	xchg   %ax,%ax
  8023d0:	31 c0                	xor    %eax,%eax
  8023d2:	e9 37 ff ff ff       	jmp    80230e <__udivdi3+0x46>
  8023d7:	90                   	nop

008023d8 <__umoddi3>:
  8023d8:	55                   	push   %ebp
  8023d9:	57                   	push   %edi
  8023da:	56                   	push   %esi
  8023db:	53                   	push   %ebx
  8023dc:	83 ec 1c             	sub    $0x1c,%esp
  8023df:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8023e3:	8b 74 24 34          	mov    0x34(%esp),%esi
  8023e7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8023eb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8023ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8023f3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8023f7:	89 3c 24             	mov    %edi,(%esp)
  8023fa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8023fe:	89 f2                	mov    %esi,%edx
  802400:	85 c0                	test   %eax,%eax
  802402:	75 18                	jne    80241c <__umoddi3+0x44>
  802404:	39 f7                	cmp    %esi,%edi
  802406:	0f 86 a0 00 00 00    	jbe    8024ac <__umoddi3+0xd4>
  80240c:	89 c8                	mov    %ecx,%eax
  80240e:	f7 f7                	div    %edi
  802410:	89 d0                	mov    %edx,%eax
  802412:	31 d2                	xor    %edx,%edx
  802414:	83 c4 1c             	add    $0x1c,%esp
  802417:	5b                   	pop    %ebx
  802418:	5e                   	pop    %esi
  802419:	5f                   	pop    %edi
  80241a:	5d                   	pop    %ebp
  80241b:	c3                   	ret    
  80241c:	89 f3                	mov    %esi,%ebx
  80241e:	39 f0                	cmp    %esi,%eax
  802420:	0f 87 a6 00 00 00    	ja     8024cc <__umoddi3+0xf4>
  802426:	0f bd e8             	bsr    %eax,%ebp
  802429:	83 f5 1f             	xor    $0x1f,%ebp
  80242c:	0f 84 a6 00 00 00    	je     8024d8 <__umoddi3+0x100>
  802432:	bf 20 00 00 00       	mov    $0x20,%edi
  802437:	29 ef                	sub    %ebp,%edi
  802439:	89 e9                	mov    %ebp,%ecx
  80243b:	d3 e0                	shl    %cl,%eax
  80243d:	8b 34 24             	mov    (%esp),%esi
  802440:	89 f2                	mov    %esi,%edx
  802442:	89 f9                	mov    %edi,%ecx
  802444:	d3 ea                	shr    %cl,%edx
  802446:	09 c2                	or     %eax,%edx
  802448:	89 14 24             	mov    %edx,(%esp)
  80244b:	89 f2                	mov    %esi,%edx
  80244d:	89 e9                	mov    %ebp,%ecx
  80244f:	d3 e2                	shl    %cl,%edx
  802451:	89 54 24 04          	mov    %edx,0x4(%esp)
  802455:	89 de                	mov    %ebx,%esi
  802457:	89 f9                	mov    %edi,%ecx
  802459:	d3 ee                	shr    %cl,%esi
  80245b:	89 e9                	mov    %ebp,%ecx
  80245d:	d3 e3                	shl    %cl,%ebx
  80245f:	8b 54 24 08          	mov    0x8(%esp),%edx
  802463:	89 d0                	mov    %edx,%eax
  802465:	89 f9                	mov    %edi,%ecx
  802467:	d3 e8                	shr    %cl,%eax
  802469:	09 d8                	or     %ebx,%eax
  80246b:	89 d3                	mov    %edx,%ebx
  80246d:	89 e9                	mov    %ebp,%ecx
  80246f:	d3 e3                	shl    %cl,%ebx
  802471:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  802475:	89 f2                	mov    %esi,%edx
  802477:	f7 34 24             	divl   (%esp)
  80247a:	89 d6                	mov    %edx,%esi
  80247c:	f7 64 24 04          	mull   0x4(%esp)
  802480:	89 c3                	mov    %eax,%ebx
  802482:	89 d1                	mov    %edx,%ecx
  802484:	39 d6                	cmp    %edx,%esi
  802486:	72 7c                	jb     802504 <__umoddi3+0x12c>
  802488:	74 72                	je     8024fc <__umoddi3+0x124>
  80248a:	8b 54 24 08          	mov    0x8(%esp),%edx
  80248e:	29 da                	sub    %ebx,%edx
  802490:	19 ce                	sbb    %ecx,%esi
  802492:	89 f0                	mov    %esi,%eax
  802494:	89 f9                	mov    %edi,%ecx
  802496:	d3 e0                	shl    %cl,%eax
  802498:	89 e9                	mov    %ebp,%ecx
  80249a:	d3 ea                	shr    %cl,%edx
  80249c:	09 d0                	or     %edx,%eax
  80249e:	89 e9                	mov    %ebp,%ecx
  8024a0:	d3 ee                	shr    %cl,%esi
  8024a2:	89 f2                	mov    %esi,%edx
  8024a4:	83 c4 1c             	add    $0x1c,%esp
  8024a7:	5b                   	pop    %ebx
  8024a8:	5e                   	pop    %esi
  8024a9:	5f                   	pop    %edi
  8024aa:	5d                   	pop    %ebp
  8024ab:	c3                   	ret    
  8024ac:	89 fd                	mov    %edi,%ebp
  8024ae:	85 ff                	test   %edi,%edi
  8024b0:	75 0b                	jne    8024bd <__umoddi3+0xe5>
  8024b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024b7:	31 d2                	xor    %edx,%edx
  8024b9:	f7 f7                	div    %edi
  8024bb:	89 c5                	mov    %eax,%ebp
  8024bd:	89 f0                	mov    %esi,%eax
  8024bf:	31 d2                	xor    %edx,%edx
  8024c1:	f7 f5                	div    %ebp
  8024c3:	89 c8                	mov    %ecx,%eax
  8024c5:	f7 f5                	div    %ebp
  8024c7:	e9 44 ff ff ff       	jmp    802410 <__umoddi3+0x38>
  8024cc:	89 c8                	mov    %ecx,%eax
  8024ce:	89 f2                	mov    %esi,%edx
  8024d0:	83 c4 1c             	add    $0x1c,%esp
  8024d3:	5b                   	pop    %ebx
  8024d4:	5e                   	pop    %esi
  8024d5:	5f                   	pop    %edi
  8024d6:	5d                   	pop    %ebp
  8024d7:	c3                   	ret    
  8024d8:	39 f0                	cmp    %esi,%eax
  8024da:	72 05                	jb     8024e1 <__umoddi3+0x109>
  8024dc:	39 0c 24             	cmp    %ecx,(%esp)
  8024df:	77 0c                	ja     8024ed <__umoddi3+0x115>
  8024e1:	89 f2                	mov    %esi,%edx
  8024e3:	29 f9                	sub    %edi,%ecx
  8024e5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8024e9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8024ed:	8b 44 24 04          	mov    0x4(%esp),%eax
  8024f1:	83 c4 1c             	add    $0x1c,%esp
  8024f4:	5b                   	pop    %ebx
  8024f5:	5e                   	pop    %esi
  8024f6:	5f                   	pop    %edi
  8024f7:	5d                   	pop    %ebp
  8024f8:	c3                   	ret    
  8024f9:	8d 76 00             	lea    0x0(%esi),%esi
  8024fc:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802500:	73 88                	jae    80248a <__umoddi3+0xb2>
  802502:	66 90                	xchg   %ax,%ax
  802504:	2b 44 24 04          	sub    0x4(%esp),%eax
  802508:	1b 14 24             	sbb    (%esp),%edx
  80250b:	89 d1                	mov    %edx,%ecx
  80250d:	89 c3                	mov    %eax,%ebx
  80250f:	e9 76 ff ff ff       	jmp    80248a <__umoddi3+0xb2>
