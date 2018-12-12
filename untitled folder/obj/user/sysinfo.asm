
obj/user/sysinfo.debug:     file format elf32-i386


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
  80002c:	e8 47 00 00 00       	call   800078 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 44             	sub    $0x44,%esp
		"inpackets  \t%llu\n"
		"outpackets \t%llu\n"
		;
	char buf[64];

	sys_sysinfo(&info);
  800039:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80003c:	50                   	push   %eax
  80003d:	e8 61 02 00 00       	call   8002a3 <sys_sysinfo>
	printf(fmt, info.uptime,
  800042:	83 c4 04             	add    $0x4,%esp
  800045:	ff 75 f4             	pushl  -0xc(%ebp)
  800048:	ff 75 f0             	pushl  -0x10(%ebp)
  80004b:	ff 75 ec             	pushl  -0x14(%ebp)
  80004e:	ff 75 e8             	pushl  -0x18(%ebp)
  800051:	ff 75 e4             	pushl  -0x1c(%ebp)
  800054:	ff 75 e0             	pushl  -0x20(%ebp)
  800057:	ff 75 dc             	pushl  -0x24(%ebp)
  80005a:	ff 75 d8             	pushl  -0x28(%ebp)
  80005d:	ff 75 d4             	pushl  -0x2c(%ebp)
  800060:	ff 75 d0             	pushl  -0x30(%ebp)
  800063:	ff 75 cc             	pushl  -0x34(%ebp)
  800066:	ff 75 c8             	pushl  -0x38(%ebp)
  800069:	68 40 20 80 00       	push   $0x802040
  80006e:	e8 f4 0c 00 00       	call   800d67 <printf>
	       info.totalpages, info.freepages,
	       info.inblocks, info.outblocks,
	       info.inpackets, info.outpackets);
}
  800073:	83 c4 40             	add    $0x40,%esp
  800076:	c9                   	leave  
  800077:	c3                   	ret    

00800078 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800078:	55                   	push   %ebp
  800079:	89 e5                	mov    %esp,%ebp
  80007b:	56                   	push   %esi
  80007c:	53                   	push   %ebx
  80007d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800080:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800083:	e8 d4 00 00 00       	call   80015c <sys_getenvid>
  800088:	25 ff 03 00 00       	and    $0x3ff,%eax
  80008d:	89 c2                	mov    %eax,%edx
  80008f:	c1 e2 05             	shl    $0x5,%edx
  800092:	29 c2                	sub    %eax,%edx
  800094:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80009b:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8000a0:	85 db                	test   %ebx,%ebx
  8000a2:	7e 07                	jle    8000ab <libmain+0x33>
		binaryname = argv[0];
  8000a4:	8b 06                	mov    (%esi),%eax
  8000a6:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  8000ab:	83 ec 08             	sub    $0x8,%esp
  8000ae:	56                   	push   %esi
  8000af:	53                   	push   %ebx
  8000b0:	e8 7e ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000b5:	e8 0a 00 00 00       	call   8000c4 <exit>
}
  8000ba:	83 c4 10             	add    $0x10,%esp
  8000bd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000c0:	5b                   	pop    %ebx
  8000c1:	5e                   	pop    %esi
  8000c2:	5d                   	pop    %ebp
  8000c3:	c3                   	ret    

008000c4 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000c4:	55                   	push   %ebp
  8000c5:	89 e5                	mov    %esp,%ebp
  8000c7:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000ca:	e8 35 05 00 00       	call   800604 <close_all>
	sys_env_destroy(0);
  8000cf:	83 ec 0c             	sub    $0xc,%esp
  8000d2:	6a 00                	push   $0x0
  8000d4:	e8 42 00 00 00       	call   80011b <sys_env_destroy>
}
  8000d9:	83 c4 10             	add    $0x10,%esp
  8000dc:	c9                   	leave  
  8000dd:	c3                   	ret    

008000de <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000de:	55                   	push   %ebp
  8000df:	89 e5                	mov    %esp,%ebp
  8000e1:	57                   	push   %edi
  8000e2:	56                   	push   %esi
  8000e3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8000ef:	89 c3                	mov    %eax,%ebx
  8000f1:	89 c7                	mov    %eax,%edi
  8000f3:	89 c6                	mov    %eax,%esi
  8000f5:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000f7:	5b                   	pop    %ebx
  8000f8:	5e                   	pop    %esi
  8000f9:	5f                   	pop    %edi
  8000fa:	5d                   	pop    %ebp
  8000fb:	c3                   	ret    

008000fc <sys_cgetc>:

int
sys_cgetc(void)
{
  8000fc:	55                   	push   %ebp
  8000fd:	89 e5                	mov    %esp,%ebp
  8000ff:	57                   	push   %edi
  800100:	56                   	push   %esi
  800101:	53                   	push   %ebx
	asm volatile("int %1\n"
  800102:	ba 00 00 00 00       	mov    $0x0,%edx
  800107:	b8 01 00 00 00       	mov    $0x1,%eax
  80010c:	89 d1                	mov    %edx,%ecx
  80010e:	89 d3                	mov    %edx,%ebx
  800110:	89 d7                	mov    %edx,%edi
  800112:	89 d6                	mov    %edx,%esi
  800114:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800116:	5b                   	pop    %ebx
  800117:	5e                   	pop    %esi
  800118:	5f                   	pop    %edi
  800119:	5d                   	pop    %ebp
  80011a:	c3                   	ret    

0080011b <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  80011b:	55                   	push   %ebp
  80011c:	89 e5                	mov    %esp,%ebp
  80011e:	57                   	push   %edi
  80011f:	56                   	push   %esi
  800120:	53                   	push   %ebx
  800121:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800124:	b9 00 00 00 00       	mov    $0x0,%ecx
  800129:	b8 03 00 00 00       	mov    $0x3,%eax
  80012e:	8b 55 08             	mov    0x8(%ebp),%edx
  800131:	89 cb                	mov    %ecx,%ebx
  800133:	89 cf                	mov    %ecx,%edi
  800135:	89 ce                	mov    %ecx,%esi
  800137:	cd 30                	int    $0x30
	if(check && ret > 0)
  800139:	85 c0                	test   %eax,%eax
  80013b:	7f 08                	jg     800145 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80013d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800140:	5b                   	pop    %ebx
  800141:	5e                   	pop    %esi
  800142:	5f                   	pop    %edi
  800143:	5d                   	pop    %ebp
  800144:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	50                   	push   %eax
  800149:	6a 03                	push   $0x3
  80014b:	68 be 20 80 00       	push   $0x8020be
  800150:	6a 23                	push   $0x23
  800152:	68 db 20 80 00       	push   $0x8020db
  800157:	e8 f2 10 00 00       	call   80124e <_panic>

0080015c <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80015c:	55                   	push   %ebp
  80015d:	89 e5                	mov    %esp,%ebp
  80015f:	57                   	push   %edi
  800160:	56                   	push   %esi
  800161:	53                   	push   %ebx
	asm volatile("int %1\n"
  800162:	ba 00 00 00 00       	mov    $0x0,%edx
  800167:	b8 02 00 00 00       	mov    $0x2,%eax
  80016c:	89 d1                	mov    %edx,%ecx
  80016e:	89 d3                	mov    %edx,%ebx
  800170:	89 d7                	mov    %edx,%edi
  800172:	89 d6                	mov    %edx,%esi
  800174:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800176:	5b                   	pop    %ebx
  800177:	5e                   	pop    %esi
  800178:	5f                   	pop    %edi
  800179:	5d                   	pop    %ebp
  80017a:	c3                   	ret    

0080017b <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80017b:	55                   	push   %ebp
  80017c:	89 e5                	mov    %esp,%ebp
  80017e:	57                   	push   %edi
  80017f:	56                   	push   %esi
  800180:	53                   	push   %ebx
  800181:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800184:	be 00 00 00 00       	mov    $0x0,%esi
  800189:	b8 04 00 00 00       	mov    $0x4,%eax
  80018e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800191:	8b 55 08             	mov    0x8(%ebp),%edx
  800194:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800197:	89 f7                	mov    %esi,%edi
  800199:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019b:	85 c0                	test   %eax,%eax
  80019d:	7f 08                	jg     8001a7 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80019f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a2:	5b                   	pop    %ebx
  8001a3:	5e                   	pop    %esi
  8001a4:	5f                   	pop    %edi
  8001a5:	5d                   	pop    %ebp
  8001a6:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	50                   	push   %eax
  8001ab:	6a 04                	push   $0x4
  8001ad:	68 be 20 80 00       	push   $0x8020be
  8001b2:	6a 23                	push   $0x23
  8001b4:	68 db 20 80 00       	push   $0x8020db
  8001b9:	e8 90 10 00 00       	call   80124e <_panic>

008001be <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001be:	55                   	push   %ebp
  8001bf:	89 e5                	mov    %esp,%ebp
  8001c1:	57                   	push   %edi
  8001c2:	56                   	push   %esi
  8001c3:	53                   	push   %ebx
  8001c4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001c7:	b8 05 00 00 00       	mov    $0x5,%eax
  8001cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8001d2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001d5:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001d8:	8b 75 18             	mov    0x18(%ebp),%esi
  8001db:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001dd:	85 c0                	test   %eax,%eax
  8001df:	7f 08                	jg     8001e9 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e4:	5b                   	pop    %ebx
  8001e5:	5e                   	pop    %esi
  8001e6:	5f                   	pop    %edi
  8001e7:	5d                   	pop    %ebp
  8001e8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001e9:	83 ec 0c             	sub    $0xc,%esp
  8001ec:	50                   	push   %eax
  8001ed:	6a 05                	push   $0x5
  8001ef:	68 be 20 80 00       	push   $0x8020be
  8001f4:	6a 23                	push   $0x23
  8001f6:	68 db 20 80 00       	push   $0x8020db
  8001fb:	e8 4e 10 00 00       	call   80124e <_panic>

00800200 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  800200:	55                   	push   %ebp
  800201:	89 e5                	mov    %esp,%ebp
  800203:	57                   	push   %edi
  800204:	56                   	push   %esi
  800205:	53                   	push   %ebx
  800206:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800209:	bb 00 00 00 00       	mov    $0x0,%ebx
  80020e:	b8 06 00 00 00       	mov    $0x6,%eax
  800213:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800216:	8b 55 08             	mov    0x8(%ebp),%edx
  800219:	89 df                	mov    %ebx,%edi
  80021b:	89 de                	mov    %ebx,%esi
  80021d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80021f:	85 c0                	test   %eax,%eax
  800221:	7f 08                	jg     80022b <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800223:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800226:	5b                   	pop    %ebx
  800227:	5e                   	pop    %esi
  800228:	5f                   	pop    %edi
  800229:	5d                   	pop    %ebp
  80022a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80022b:	83 ec 0c             	sub    $0xc,%esp
  80022e:	50                   	push   %eax
  80022f:	6a 06                	push   $0x6
  800231:	68 be 20 80 00       	push   $0x8020be
  800236:	6a 23                	push   $0x23
  800238:	68 db 20 80 00       	push   $0x8020db
  80023d:	e8 0c 10 00 00       	call   80124e <_panic>

00800242 <sys_yield>:

void
sys_yield(void)
{
  800242:	55                   	push   %ebp
  800243:	89 e5                	mov    %esp,%ebp
  800245:	57                   	push   %edi
  800246:	56                   	push   %esi
  800247:	53                   	push   %ebx
	asm volatile("int %1\n"
  800248:	ba 00 00 00 00       	mov    $0x0,%edx
  80024d:	b8 0b 00 00 00       	mov    $0xb,%eax
  800252:	89 d1                	mov    %edx,%ecx
  800254:	89 d3                	mov    %edx,%ebx
  800256:	89 d7                	mov    %edx,%edi
  800258:	89 d6                	mov    %edx,%esi
  80025a:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80025c:	5b                   	pop    %ebx
  80025d:	5e                   	pop    %esi
  80025e:	5f                   	pop    %edi
  80025f:	5d                   	pop    %ebp
  800260:	c3                   	ret    

00800261 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	57                   	push   %edi
  800265:	56                   	push   %esi
  800266:	53                   	push   %ebx
  800267:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80026f:	b8 08 00 00 00       	mov    $0x8,%eax
  800274:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800277:	8b 55 08             	mov    0x8(%ebp),%edx
  80027a:	89 df                	mov    %ebx,%edi
  80027c:	89 de                	mov    %ebx,%esi
  80027e:	cd 30                	int    $0x30
	if(check && ret > 0)
  800280:	85 c0                	test   %eax,%eax
  800282:	7f 08                	jg     80028c <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800284:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800287:	5b                   	pop    %ebx
  800288:	5e                   	pop    %esi
  800289:	5f                   	pop    %edi
  80028a:	5d                   	pop    %ebp
  80028b:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	6a 08                	push   $0x8
  800292:	68 be 20 80 00       	push   $0x8020be
  800297:	6a 23                	push   $0x23
  800299:	68 db 20 80 00       	push   $0x8020db
  80029e:	e8 ab 0f 00 00       	call   80124e <_panic>

008002a3 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  8002a3:	55                   	push   %ebp
  8002a4:	89 e5                	mov    %esp,%ebp
  8002a6:	57                   	push   %edi
  8002a7:	56                   	push   %esi
  8002a8:	53                   	push   %ebx
  8002a9:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ac:	b9 00 00 00 00       	mov    $0x0,%ecx
  8002b1:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002b9:	89 cb                	mov    %ecx,%ebx
  8002bb:	89 cf                	mov    %ecx,%edi
  8002bd:	89 ce                	mov    %ecx,%esi
  8002bf:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c1:	85 c0                	test   %eax,%eax
  8002c3:	7f 08                	jg     8002cd <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  8002c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002c8:	5b                   	pop    %ebx
  8002c9:	5e                   	pop    %esi
  8002ca:	5f                   	pop    %edi
  8002cb:	5d                   	pop    %ebp
  8002cc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002cd:	83 ec 0c             	sub    $0xc,%esp
  8002d0:	50                   	push   %eax
  8002d1:	6a 0c                	push   $0xc
  8002d3:	68 be 20 80 00       	push   $0x8020be
  8002d8:	6a 23                	push   $0x23
  8002da:	68 db 20 80 00       	push   $0x8020db
  8002df:	e8 6a 0f 00 00       	call   80124e <_panic>

008002e4 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002e4:	55                   	push   %ebp
  8002e5:	89 e5                	mov    %esp,%ebp
  8002e7:	57                   	push   %edi
  8002e8:	56                   	push   %esi
  8002e9:	53                   	push   %ebx
  8002ea:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f2:	b8 09 00 00 00       	mov    $0x9,%eax
  8002f7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8002fd:	89 df                	mov    %ebx,%edi
  8002ff:	89 de                	mov    %ebx,%esi
  800301:	cd 30                	int    $0x30
	if(check && ret > 0)
  800303:	85 c0                	test   %eax,%eax
  800305:	7f 08                	jg     80030f <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  800307:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030a:	5b                   	pop    %ebx
  80030b:	5e                   	pop    %esi
  80030c:	5f                   	pop    %edi
  80030d:	5d                   	pop    %ebp
  80030e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80030f:	83 ec 0c             	sub    $0xc,%esp
  800312:	50                   	push   %eax
  800313:	6a 09                	push   $0x9
  800315:	68 be 20 80 00       	push   $0x8020be
  80031a:	6a 23                	push   $0x23
  80031c:	68 db 20 80 00       	push   $0x8020db
  800321:	e8 28 0f 00 00       	call   80124e <_panic>

00800326 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	57                   	push   %edi
  80032a:	56                   	push   %esi
  80032b:	53                   	push   %ebx
  80032c:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80032f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800334:	b8 0a 00 00 00       	mov    $0xa,%eax
  800339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033c:	8b 55 08             	mov    0x8(%ebp),%edx
  80033f:	89 df                	mov    %ebx,%edi
  800341:	89 de                	mov    %ebx,%esi
  800343:	cd 30                	int    $0x30
	if(check && ret > 0)
  800345:	85 c0                	test   %eax,%eax
  800347:	7f 08                	jg     800351 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800349:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80034c:	5b                   	pop    %ebx
  80034d:	5e                   	pop    %esi
  80034e:	5f                   	pop    %edi
  80034f:	5d                   	pop    %ebp
  800350:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800351:	83 ec 0c             	sub    $0xc,%esp
  800354:	50                   	push   %eax
  800355:	6a 0a                	push   $0xa
  800357:	68 be 20 80 00       	push   $0x8020be
  80035c:	6a 23                	push   $0x23
  80035e:	68 db 20 80 00       	push   $0x8020db
  800363:	e8 e6 0e 00 00       	call   80124e <_panic>

00800368 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	57                   	push   %edi
  80036c:	56                   	push   %esi
  80036d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80036e:	be 00 00 00 00       	mov    $0x0,%esi
  800373:	b8 0d 00 00 00       	mov    $0xd,%eax
  800378:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80037b:	8b 55 08             	mov    0x8(%ebp),%edx
  80037e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800381:	8b 7d 14             	mov    0x14(%ebp),%edi
  800384:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800386:	5b                   	pop    %ebx
  800387:	5e                   	pop    %esi
  800388:	5f                   	pop    %edi
  800389:	5d                   	pop    %ebp
  80038a:	c3                   	ret    

0080038b <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80038b:	55                   	push   %ebp
  80038c:	89 e5                	mov    %esp,%ebp
  80038e:	57                   	push   %edi
  80038f:	56                   	push   %esi
  800390:	53                   	push   %ebx
  800391:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800394:	b9 00 00 00 00       	mov    $0x0,%ecx
  800399:	b8 0e 00 00 00       	mov    $0xe,%eax
  80039e:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a1:	89 cb                	mov    %ecx,%ebx
  8003a3:	89 cf                	mov    %ecx,%edi
  8003a5:	89 ce                	mov    %ecx,%esi
  8003a7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8003a9:	85 c0                	test   %eax,%eax
  8003ab:	7f 08                	jg     8003b5 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  8003ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8003b0:	5b                   	pop    %ebx
  8003b1:	5e                   	pop    %esi
  8003b2:	5f                   	pop    %edi
  8003b3:	5d                   	pop    %ebp
  8003b4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003b5:	83 ec 0c             	sub    $0xc,%esp
  8003b8:	50                   	push   %eax
  8003b9:	6a 0e                	push   $0xe
  8003bb:	68 be 20 80 00       	push   $0x8020be
  8003c0:	6a 23                	push   $0x23
  8003c2:	68 db 20 80 00       	push   $0x8020db
  8003c7:	e8 82 0e 00 00       	call   80124e <_panic>

008003cc <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8003cc:	55                   	push   %ebp
  8003cd:	89 e5                	mov    %esp,%ebp
  8003cf:	57                   	push   %edi
  8003d0:	56                   	push   %esi
  8003d1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003d2:	be 00 00 00 00       	mov    $0x0,%esi
  8003d7:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003dc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003df:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003e5:	89 f7                	mov    %esi,%edi
  8003e7:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003e9:	5b                   	pop    %ebx
  8003ea:	5e                   	pop    %esi
  8003eb:	5f                   	pop    %edi
  8003ec:	5d                   	pop    %ebp
  8003ed:	c3                   	ret    

008003ee <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003ee:	55                   	push   %ebp
  8003ef:	89 e5                	mov    %esp,%ebp
  8003f1:	57                   	push   %edi
  8003f2:	56                   	push   %esi
  8003f3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003f4:	be 00 00 00 00       	mov    $0x0,%esi
  8003f9:	b8 10 00 00 00       	mov    $0x10,%eax
  8003fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800401:	8b 55 08             	mov    0x8(%ebp),%edx
  800404:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800407:	89 f7                	mov    %esi,%edi
  800409:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  80040b:	5b                   	pop    %ebx
  80040c:	5e                   	pop    %esi
  80040d:	5f                   	pop    %edi
  80040e:	5d                   	pop    %ebp
  80040f:	c3                   	ret    

00800410 <sys_set_console_color>:

void sys_set_console_color(int color) {
  800410:	55                   	push   %ebp
  800411:	89 e5                	mov    %esp,%ebp
  800413:	57                   	push   %edi
  800414:	56                   	push   %esi
  800415:	53                   	push   %ebx
	asm volatile("int %1\n"
  800416:	b9 00 00 00 00       	mov    $0x0,%ecx
  80041b:	b8 11 00 00 00       	mov    $0x11,%eax
  800420:	8b 55 08             	mov    0x8(%ebp),%edx
  800423:	89 cb                	mov    %ecx,%ebx
  800425:	89 cf                	mov    %ecx,%edi
  800427:	89 ce                	mov    %ecx,%esi
  800429:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  80042b:	5b                   	pop    %ebx
  80042c:	5e                   	pop    %esi
  80042d:	5f                   	pop    %edi
  80042e:	5d                   	pop    %ebp
  80042f:	c3                   	ret    

00800430 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800430:	55                   	push   %ebp
  800431:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800433:	8b 45 08             	mov    0x8(%ebp),%eax
  800436:	05 00 00 00 30       	add    $0x30000000,%eax
  80043b:	c1 e8 0c             	shr    $0xc,%eax
}
  80043e:	5d                   	pop    %ebp
  80043f:	c3                   	ret    

00800440 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800440:	55                   	push   %ebp
  800441:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800443:	8b 45 08             	mov    0x8(%ebp),%eax
  800446:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80044b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800450:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800455:	5d                   	pop    %ebp
  800456:	c3                   	ret    

00800457 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045d:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800462:	89 c2                	mov    %eax,%edx
  800464:	c1 ea 16             	shr    $0x16,%edx
  800467:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80046e:	f6 c2 01             	test   $0x1,%dl
  800471:	74 2a                	je     80049d <fd_alloc+0x46>
  800473:	89 c2                	mov    %eax,%edx
  800475:	c1 ea 0c             	shr    $0xc,%edx
  800478:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80047f:	f6 c2 01             	test   $0x1,%dl
  800482:	74 19                	je     80049d <fd_alloc+0x46>
  800484:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800489:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80048e:	75 d2                	jne    800462 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800490:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800496:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80049b:	eb 07                	jmp    8004a4 <fd_alloc+0x4d>
			*fd_store = fd;
  80049d:	89 01                	mov    %eax,(%ecx)
			return 0;
  80049f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a4:	5d                   	pop    %ebp
  8004a5:	c3                   	ret    

008004a6 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004a6:	55                   	push   %ebp
  8004a7:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004a9:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8004ad:	77 39                	ja     8004e8 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004af:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b2:	c1 e0 0c             	shl    $0xc,%eax
  8004b5:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004ba:	89 c2                	mov    %eax,%edx
  8004bc:	c1 ea 16             	shr    $0x16,%edx
  8004bf:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004c6:	f6 c2 01             	test   $0x1,%dl
  8004c9:	74 24                	je     8004ef <fd_lookup+0x49>
  8004cb:	89 c2                	mov    %eax,%edx
  8004cd:	c1 ea 0c             	shr    $0xc,%edx
  8004d0:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004d7:	f6 c2 01             	test   $0x1,%dl
  8004da:	74 1a                	je     8004f6 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004df:	89 02                	mov    %eax,(%edx)
	return 0;
  8004e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004e6:	5d                   	pop    %ebp
  8004e7:	c3                   	ret    
		return -E_INVAL;
  8004e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ed:	eb f7                	jmp    8004e6 <fd_lookup+0x40>
		return -E_INVAL;
  8004ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004f4:	eb f0                	jmp    8004e6 <fd_lookup+0x40>
  8004f6:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004fb:	eb e9                	jmp    8004e6 <fd_lookup+0x40>

008004fd <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004fd:	55                   	push   %ebp
  8004fe:	89 e5                	mov    %esp,%ebp
  800500:	83 ec 08             	sub    $0x8,%esp
  800503:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800506:	ba 68 21 80 00       	mov    $0x802168,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80050b:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800510:	39 08                	cmp    %ecx,(%eax)
  800512:	74 33                	je     800547 <dev_lookup+0x4a>
  800514:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800517:	8b 02                	mov    (%edx),%eax
  800519:	85 c0                	test   %eax,%eax
  80051b:	75 f3                	jne    800510 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80051d:	a1 04 40 80 00       	mov    0x804004,%eax
  800522:	8b 40 48             	mov    0x48(%eax),%eax
  800525:	83 ec 04             	sub    $0x4,%esp
  800528:	51                   	push   %ecx
  800529:	50                   	push   %eax
  80052a:	68 ec 20 80 00       	push   $0x8020ec
  80052f:	e8 2d 0e 00 00       	call   801361 <cprintf>
	*dev = 0;
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80053d:	83 c4 10             	add    $0x10,%esp
  800540:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    
			*dev = devtab[i];
  800547:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80054c:	b8 00 00 00 00       	mov    $0x0,%eax
  800551:	eb f2                	jmp    800545 <dev_lookup+0x48>

00800553 <fd_close>:
{
  800553:	55                   	push   %ebp
  800554:	89 e5                	mov    %esp,%ebp
  800556:	57                   	push   %edi
  800557:	56                   	push   %esi
  800558:	53                   	push   %ebx
  800559:	83 ec 1c             	sub    $0x1c,%esp
  80055c:	8b 75 08             	mov    0x8(%ebp),%esi
  80055f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800562:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800565:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800566:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80056c:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80056f:	50                   	push   %eax
  800570:	e8 31 ff ff ff       	call   8004a6 <fd_lookup>
  800575:	89 c7                	mov    %eax,%edi
  800577:	83 c4 08             	add    $0x8,%esp
  80057a:	85 c0                	test   %eax,%eax
  80057c:	78 05                	js     800583 <fd_close+0x30>
	    || fd != fd2)
  80057e:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800581:	74 13                	je     800596 <fd_close+0x43>
		return (must_exist ? r : 0);
  800583:	84 db                	test   %bl,%bl
  800585:	75 05                	jne    80058c <fd_close+0x39>
  800587:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80058c:	89 f8                	mov    %edi,%eax
  80058e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800591:	5b                   	pop    %ebx
  800592:	5e                   	pop    %esi
  800593:	5f                   	pop    %edi
  800594:	5d                   	pop    %ebp
  800595:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800596:	83 ec 08             	sub    $0x8,%esp
  800599:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80059c:	50                   	push   %eax
  80059d:	ff 36                	pushl  (%esi)
  80059f:	e8 59 ff ff ff       	call   8004fd <dev_lookup>
  8005a4:	89 c7                	mov    %eax,%edi
  8005a6:	83 c4 10             	add    $0x10,%esp
  8005a9:	85 c0                	test   %eax,%eax
  8005ab:	78 15                	js     8005c2 <fd_close+0x6f>
		if (dev->dev_close)
  8005ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b0:	8b 40 10             	mov    0x10(%eax),%eax
  8005b3:	85 c0                	test   %eax,%eax
  8005b5:	74 1b                	je     8005d2 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8005b7:	83 ec 0c             	sub    $0xc,%esp
  8005ba:	56                   	push   %esi
  8005bb:	ff d0                	call   *%eax
  8005bd:	89 c7                	mov    %eax,%edi
  8005bf:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005c2:	83 ec 08             	sub    $0x8,%esp
  8005c5:	56                   	push   %esi
  8005c6:	6a 00                	push   $0x0
  8005c8:	e8 33 fc ff ff       	call   800200 <sys_page_unmap>
	return r;
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	eb ba                	jmp    80058c <fd_close+0x39>
			r = 0;
  8005d2:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d7:	eb e9                	jmp    8005c2 <fd_close+0x6f>

008005d9 <close>:

int
close(int fdnum)
{
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005df:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005e2:	50                   	push   %eax
  8005e3:	ff 75 08             	pushl  0x8(%ebp)
  8005e6:	e8 bb fe ff ff       	call   8004a6 <fd_lookup>
  8005eb:	83 c4 08             	add    $0x8,%esp
  8005ee:	85 c0                	test   %eax,%eax
  8005f0:	78 10                	js     800602 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005f2:	83 ec 08             	sub    $0x8,%esp
  8005f5:	6a 01                	push   $0x1
  8005f7:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fa:	e8 54 ff ff ff       	call   800553 <fd_close>
  8005ff:	83 c4 10             	add    $0x10,%esp
}
  800602:	c9                   	leave  
  800603:	c3                   	ret    

00800604 <close_all>:

void
close_all(void)
{
  800604:	55                   	push   %ebp
  800605:	89 e5                	mov    %esp,%ebp
  800607:	53                   	push   %ebx
  800608:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80060b:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800610:	83 ec 0c             	sub    $0xc,%esp
  800613:	53                   	push   %ebx
  800614:	e8 c0 ff ff ff       	call   8005d9 <close>
	for (i = 0; i < MAXFD; i++)
  800619:	43                   	inc    %ebx
  80061a:	83 c4 10             	add    $0x10,%esp
  80061d:	83 fb 20             	cmp    $0x20,%ebx
  800620:	75 ee                	jne    800610 <close_all+0xc>
}
  800622:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800625:	c9                   	leave  
  800626:	c3                   	ret    

00800627 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800627:	55                   	push   %ebp
  800628:	89 e5                	mov    %esp,%ebp
  80062a:	57                   	push   %edi
  80062b:	56                   	push   %esi
  80062c:	53                   	push   %ebx
  80062d:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800630:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800633:	50                   	push   %eax
  800634:	ff 75 08             	pushl  0x8(%ebp)
  800637:	e8 6a fe ff ff       	call   8004a6 <fd_lookup>
  80063c:	89 c3                	mov    %eax,%ebx
  80063e:	83 c4 08             	add    $0x8,%esp
  800641:	85 c0                	test   %eax,%eax
  800643:	0f 88 81 00 00 00    	js     8006ca <dup+0xa3>
		return r;
	close(newfdnum);
  800649:	83 ec 0c             	sub    $0xc,%esp
  80064c:	ff 75 0c             	pushl  0xc(%ebp)
  80064f:	e8 85 ff ff ff       	call   8005d9 <close>

	newfd = INDEX2FD(newfdnum);
  800654:	8b 75 0c             	mov    0xc(%ebp),%esi
  800657:	c1 e6 0c             	shl    $0xc,%esi
  80065a:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800660:	83 c4 04             	add    $0x4,%esp
  800663:	ff 75 e4             	pushl  -0x1c(%ebp)
  800666:	e8 d5 fd ff ff       	call   800440 <fd2data>
  80066b:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80066d:	89 34 24             	mov    %esi,(%esp)
  800670:	e8 cb fd ff ff       	call   800440 <fd2data>
  800675:	83 c4 10             	add    $0x10,%esp
  800678:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80067a:	89 d8                	mov    %ebx,%eax
  80067c:	c1 e8 16             	shr    $0x16,%eax
  80067f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800686:	a8 01                	test   $0x1,%al
  800688:	74 11                	je     80069b <dup+0x74>
  80068a:	89 d8                	mov    %ebx,%eax
  80068c:	c1 e8 0c             	shr    $0xc,%eax
  80068f:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800696:	f6 c2 01             	test   $0x1,%dl
  800699:	75 39                	jne    8006d4 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80069b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80069e:	89 d0                	mov    %edx,%eax
  8006a0:	c1 e8 0c             	shr    $0xc,%eax
  8006a3:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006aa:	83 ec 0c             	sub    $0xc,%esp
  8006ad:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b2:	50                   	push   %eax
  8006b3:	56                   	push   %esi
  8006b4:	6a 00                	push   $0x0
  8006b6:	52                   	push   %edx
  8006b7:	6a 00                	push   $0x0
  8006b9:	e8 00 fb ff ff       	call   8001be <sys_page_map>
  8006be:	89 c3                	mov    %eax,%ebx
  8006c0:	83 c4 20             	add    $0x20,%esp
  8006c3:	85 c0                	test   %eax,%eax
  8006c5:	78 31                	js     8006f8 <dup+0xd1>
		goto err;

	return newfdnum;
  8006c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006ca:	89 d8                	mov    %ebx,%eax
  8006cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006cf:	5b                   	pop    %ebx
  8006d0:	5e                   	pop    %esi
  8006d1:	5f                   	pop    %edi
  8006d2:	5d                   	pop    %ebp
  8006d3:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006d4:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006db:	83 ec 0c             	sub    $0xc,%esp
  8006de:	25 07 0e 00 00       	and    $0xe07,%eax
  8006e3:	50                   	push   %eax
  8006e4:	57                   	push   %edi
  8006e5:	6a 00                	push   $0x0
  8006e7:	53                   	push   %ebx
  8006e8:	6a 00                	push   $0x0
  8006ea:	e8 cf fa ff ff       	call   8001be <sys_page_map>
  8006ef:	89 c3                	mov    %eax,%ebx
  8006f1:	83 c4 20             	add    $0x20,%esp
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	79 a3                	jns    80069b <dup+0x74>
	sys_page_unmap(0, newfd);
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	56                   	push   %esi
  8006fc:	6a 00                	push   $0x0
  8006fe:	e8 fd fa ff ff       	call   800200 <sys_page_unmap>
	sys_page_unmap(0, nva);
  800703:	83 c4 08             	add    $0x8,%esp
  800706:	57                   	push   %edi
  800707:	6a 00                	push   $0x0
  800709:	e8 f2 fa ff ff       	call   800200 <sys_page_unmap>
	return r;
  80070e:	83 c4 10             	add    $0x10,%esp
  800711:	eb b7                	jmp    8006ca <dup+0xa3>

00800713 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800713:	55                   	push   %ebp
  800714:	89 e5                	mov    %esp,%ebp
  800716:	53                   	push   %ebx
  800717:	83 ec 14             	sub    $0x14,%esp
  80071a:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80071d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800720:	50                   	push   %eax
  800721:	53                   	push   %ebx
  800722:	e8 7f fd ff ff       	call   8004a6 <fd_lookup>
  800727:	83 c4 08             	add    $0x8,%esp
  80072a:	85 c0                	test   %eax,%eax
  80072c:	78 3f                	js     80076d <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80072e:	83 ec 08             	sub    $0x8,%esp
  800731:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800734:	50                   	push   %eax
  800735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800738:	ff 30                	pushl  (%eax)
  80073a:	e8 be fd ff ff       	call   8004fd <dev_lookup>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	85 c0                	test   %eax,%eax
  800744:	78 27                	js     80076d <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800746:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800749:	8b 42 08             	mov    0x8(%edx),%eax
  80074c:	83 e0 03             	and    $0x3,%eax
  80074f:	83 f8 01             	cmp    $0x1,%eax
  800752:	74 1e                	je     800772 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800757:	8b 40 08             	mov    0x8(%eax),%eax
  80075a:	85 c0                	test   %eax,%eax
  80075c:	74 35                	je     800793 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80075e:	83 ec 04             	sub    $0x4,%esp
  800761:	ff 75 10             	pushl  0x10(%ebp)
  800764:	ff 75 0c             	pushl  0xc(%ebp)
  800767:	52                   	push   %edx
  800768:	ff d0                	call   *%eax
  80076a:	83 c4 10             	add    $0x10,%esp
}
  80076d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800770:	c9                   	leave  
  800771:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800772:	a1 04 40 80 00       	mov    0x804004,%eax
  800777:	8b 40 48             	mov    0x48(%eax),%eax
  80077a:	83 ec 04             	sub    $0x4,%esp
  80077d:	53                   	push   %ebx
  80077e:	50                   	push   %eax
  80077f:	68 2d 21 80 00       	push   $0x80212d
  800784:	e8 d8 0b 00 00       	call   801361 <cprintf>
		return -E_INVAL;
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800791:	eb da                	jmp    80076d <read+0x5a>
		return -E_NOT_SUPP;
  800793:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800798:	eb d3                	jmp    80076d <read+0x5a>

0080079a <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80079a:	55                   	push   %ebp
  80079b:	89 e5                	mov    %esp,%ebp
  80079d:	57                   	push   %edi
  80079e:	56                   	push   %esi
  80079f:	53                   	push   %ebx
  8007a0:	83 ec 0c             	sub    $0xc,%esp
  8007a3:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007a6:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007a9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007ae:	39 f3                	cmp    %esi,%ebx
  8007b0:	73 25                	jae    8007d7 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007b2:	83 ec 04             	sub    $0x4,%esp
  8007b5:	89 f0                	mov    %esi,%eax
  8007b7:	29 d8                	sub    %ebx,%eax
  8007b9:	50                   	push   %eax
  8007ba:	89 d8                	mov    %ebx,%eax
  8007bc:	03 45 0c             	add    0xc(%ebp),%eax
  8007bf:	50                   	push   %eax
  8007c0:	57                   	push   %edi
  8007c1:	e8 4d ff ff ff       	call   800713 <read>
		if (m < 0)
  8007c6:	83 c4 10             	add    $0x10,%esp
  8007c9:	85 c0                	test   %eax,%eax
  8007cb:	78 08                	js     8007d5 <readn+0x3b>
			return m;
		if (m == 0)
  8007cd:	85 c0                	test   %eax,%eax
  8007cf:	74 06                	je     8007d7 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007d1:	01 c3                	add    %eax,%ebx
  8007d3:	eb d9                	jmp    8007ae <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007d5:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007d7:	89 d8                	mov    %ebx,%eax
  8007d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007dc:	5b                   	pop    %ebx
  8007dd:	5e                   	pop    %esi
  8007de:	5f                   	pop    %edi
  8007df:	5d                   	pop    %ebp
  8007e0:	c3                   	ret    

008007e1 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007e1:	55                   	push   %ebp
  8007e2:	89 e5                	mov    %esp,%ebp
  8007e4:	53                   	push   %ebx
  8007e5:	83 ec 14             	sub    $0x14,%esp
  8007e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007eb:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007ee:	50                   	push   %eax
  8007ef:	53                   	push   %ebx
  8007f0:	e8 b1 fc ff ff       	call   8004a6 <fd_lookup>
  8007f5:	83 c4 08             	add    $0x8,%esp
  8007f8:	85 c0                	test   %eax,%eax
  8007fa:	78 3a                	js     800836 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800802:	50                   	push   %eax
  800803:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800806:	ff 30                	pushl  (%eax)
  800808:	e8 f0 fc ff ff       	call   8004fd <dev_lookup>
  80080d:	83 c4 10             	add    $0x10,%esp
  800810:	85 c0                	test   %eax,%eax
  800812:	78 22                	js     800836 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800817:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80081b:	74 1e                	je     80083b <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80081d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800820:	8b 52 0c             	mov    0xc(%edx),%edx
  800823:	85 d2                	test   %edx,%edx
  800825:	74 35                	je     80085c <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800827:	83 ec 04             	sub    $0x4,%esp
  80082a:	ff 75 10             	pushl  0x10(%ebp)
  80082d:	ff 75 0c             	pushl  0xc(%ebp)
  800830:	50                   	push   %eax
  800831:	ff d2                	call   *%edx
  800833:	83 c4 10             	add    $0x10,%esp
}
  800836:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800839:	c9                   	leave  
  80083a:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80083b:	a1 04 40 80 00       	mov    0x804004,%eax
  800840:	8b 40 48             	mov    0x48(%eax),%eax
  800843:	83 ec 04             	sub    $0x4,%esp
  800846:	53                   	push   %ebx
  800847:	50                   	push   %eax
  800848:	68 49 21 80 00       	push   $0x802149
  80084d:	e8 0f 0b 00 00       	call   801361 <cprintf>
		return -E_INVAL;
  800852:	83 c4 10             	add    $0x10,%esp
  800855:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085a:	eb da                	jmp    800836 <write+0x55>
		return -E_NOT_SUPP;
  80085c:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800861:	eb d3                	jmp    800836 <write+0x55>

00800863 <seek>:

int
seek(int fdnum, off_t offset)
{
  800863:	55                   	push   %ebp
  800864:	89 e5                	mov    %esp,%ebp
  800866:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800869:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80086c:	50                   	push   %eax
  80086d:	ff 75 08             	pushl  0x8(%ebp)
  800870:	e8 31 fc ff ff       	call   8004a6 <fd_lookup>
  800875:	83 c4 08             	add    $0x8,%esp
  800878:	85 c0                	test   %eax,%eax
  80087a:	78 0e                	js     80088a <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80087c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80087f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800882:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800885:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088a:	c9                   	leave  
  80088b:	c3                   	ret    

0080088c <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80088c:	55                   	push   %ebp
  80088d:	89 e5                	mov    %esp,%ebp
  80088f:	53                   	push   %ebx
  800890:	83 ec 14             	sub    $0x14,%esp
  800893:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800896:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800899:	50                   	push   %eax
  80089a:	53                   	push   %ebx
  80089b:	e8 06 fc ff ff       	call   8004a6 <fd_lookup>
  8008a0:	83 c4 08             	add    $0x8,%esp
  8008a3:	85 c0                	test   %eax,%eax
  8008a5:	78 37                	js     8008de <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a7:	83 ec 08             	sub    $0x8,%esp
  8008aa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ad:	50                   	push   %eax
  8008ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b1:	ff 30                	pushl  (%eax)
  8008b3:	e8 45 fc ff ff       	call   8004fd <dev_lookup>
  8008b8:	83 c4 10             	add    $0x10,%esp
  8008bb:	85 c0                	test   %eax,%eax
  8008bd:	78 1f                	js     8008de <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c2:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008c6:	74 1b                	je     8008e3 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8008c8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cb:	8b 52 18             	mov    0x18(%edx),%edx
  8008ce:	85 d2                	test   %edx,%edx
  8008d0:	74 32                	je     800904 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008d2:	83 ec 08             	sub    $0x8,%esp
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	50                   	push   %eax
  8008d9:	ff d2                	call   *%edx
  8008db:	83 c4 10             	add    $0x10,%esp
}
  8008de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008e3:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008e8:	8b 40 48             	mov    0x48(%eax),%eax
  8008eb:	83 ec 04             	sub    $0x4,%esp
  8008ee:	53                   	push   %ebx
  8008ef:	50                   	push   %eax
  8008f0:	68 0c 21 80 00       	push   $0x80210c
  8008f5:	e8 67 0a 00 00       	call   801361 <cprintf>
		return -E_INVAL;
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800902:	eb da                	jmp    8008de <ftruncate+0x52>
		return -E_NOT_SUPP;
  800904:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800909:	eb d3                	jmp    8008de <ftruncate+0x52>

0080090b <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80090b:	55                   	push   %ebp
  80090c:	89 e5                	mov    %esp,%ebp
  80090e:	53                   	push   %ebx
  80090f:	83 ec 14             	sub    $0x14,%esp
  800912:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800915:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800918:	50                   	push   %eax
  800919:	ff 75 08             	pushl  0x8(%ebp)
  80091c:	e8 85 fb ff ff       	call   8004a6 <fd_lookup>
  800921:	83 c4 08             	add    $0x8,%esp
  800924:	85 c0                	test   %eax,%eax
  800926:	78 4b                	js     800973 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800928:	83 ec 08             	sub    $0x8,%esp
  80092b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80092e:	50                   	push   %eax
  80092f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800932:	ff 30                	pushl  (%eax)
  800934:	e8 c4 fb ff ff       	call   8004fd <dev_lookup>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	85 c0                	test   %eax,%eax
  80093e:	78 33                	js     800973 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800943:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800947:	74 2f                	je     800978 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800949:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80094c:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800953:	00 00 00 
	stat->st_type = 0;
  800956:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80095d:	00 00 00 
	stat->st_dev = dev;
  800960:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	53                   	push   %ebx
  80096a:	ff 75 f0             	pushl  -0x10(%ebp)
  80096d:	ff 50 14             	call   *0x14(%eax)
  800970:	83 c4 10             	add    $0x10,%esp
}
  800973:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800976:	c9                   	leave  
  800977:	c3                   	ret    
		return -E_NOT_SUPP;
  800978:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80097d:	eb f4                	jmp    800973 <fstat+0x68>

0080097f <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800984:	83 ec 08             	sub    $0x8,%esp
  800987:	6a 00                	push   $0x0
  800989:	ff 75 08             	pushl  0x8(%ebp)
  80098c:	e8 34 02 00 00       	call   800bc5 <open>
  800991:	89 c3                	mov    %eax,%ebx
  800993:	83 c4 10             	add    $0x10,%esp
  800996:	85 c0                	test   %eax,%eax
  800998:	78 1b                	js     8009b5 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 0c             	pushl  0xc(%ebp)
  8009a0:	50                   	push   %eax
  8009a1:	e8 65 ff ff ff       	call   80090b <fstat>
  8009a6:	89 c6                	mov    %eax,%esi
	close(fd);
  8009a8:	89 1c 24             	mov    %ebx,(%esp)
  8009ab:	e8 29 fc ff ff       	call   8005d9 <close>
	return r;
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 f3                	mov    %esi,%ebx
}
  8009b5:	89 d8                	mov    %ebx,%eax
  8009b7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009ba:	5b                   	pop    %ebx
  8009bb:	5e                   	pop    %esi
  8009bc:	5d                   	pop    %ebp
  8009bd:	c3                   	ret    

008009be <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8009be:	55                   	push   %ebp
  8009bf:	89 e5                	mov    %esp,%ebp
  8009c1:	56                   	push   %esi
  8009c2:	53                   	push   %ebx
  8009c3:	89 c6                	mov    %eax,%esi
  8009c5:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8009c7:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009ce:	74 27                	je     8009f7 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009d0:	6a 07                	push   $0x7
  8009d2:	68 00 50 80 00       	push   $0x805000
  8009d7:	56                   	push   %esi
  8009d8:	ff 35 00 40 80 00    	pushl  0x804000
  8009de:	e8 27 13 00 00       	call   801d0a <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009e3:	83 c4 0c             	add    $0xc,%esp
  8009e6:	6a 00                	push   $0x0
  8009e8:	53                   	push   %ebx
  8009e9:	6a 00                	push   $0x0
  8009eb:	e8 91 12 00 00       	call   801c81 <ipc_recv>
}
  8009f0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f3:	5b                   	pop    %ebx
  8009f4:	5e                   	pop    %esi
  8009f5:	5d                   	pop    %ebp
  8009f6:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009f7:	83 ec 0c             	sub    $0xc,%esp
  8009fa:	6a 01                	push   $0x1
  8009fc:	e8 65 13 00 00       	call   801d66 <ipc_find_env>
  800a01:	a3 00 40 80 00       	mov    %eax,0x804000
  800a06:	83 c4 10             	add    $0x10,%esp
  800a09:	eb c5                	jmp    8009d0 <fsipc+0x12>

00800a0b <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a0b:	55                   	push   %ebp
  800a0c:	89 e5                	mov    %esp,%ebp
  800a0e:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	8b 40 0c             	mov    0xc(%eax),%eax
  800a17:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a1c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a1f:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a24:	ba 00 00 00 00       	mov    $0x0,%edx
  800a29:	b8 02 00 00 00       	mov    $0x2,%eax
  800a2e:	e8 8b ff ff ff       	call   8009be <fsipc>
}
  800a33:	c9                   	leave  
  800a34:	c3                   	ret    

00800a35 <devfile_flush>:
{
  800a35:	55                   	push   %ebp
  800a36:	89 e5                	mov    %esp,%ebp
  800a38:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a41:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a46:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4b:	b8 06 00 00 00       	mov    $0x6,%eax
  800a50:	e8 69 ff ff ff       	call   8009be <fsipc>
}
  800a55:	c9                   	leave  
  800a56:	c3                   	ret    

00800a57 <devfile_stat>:
{
  800a57:	55                   	push   %ebp
  800a58:	89 e5                	mov    %esp,%ebp
  800a5a:	53                   	push   %ebx
  800a5b:	83 ec 04             	sub    $0x4,%esp
  800a5e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a61:	8b 45 08             	mov    0x8(%ebp),%eax
  800a64:	8b 40 0c             	mov    0xc(%eax),%eax
  800a67:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a6c:	ba 00 00 00 00       	mov    $0x0,%edx
  800a71:	b8 05 00 00 00       	mov    $0x5,%eax
  800a76:	e8 43 ff ff ff       	call   8009be <fsipc>
  800a7b:	85 c0                	test   %eax,%eax
  800a7d:	78 2c                	js     800aab <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	68 00 50 80 00       	push   $0x805000
  800a87:	53                   	push   %ebx
  800a88:	e8 dc 0e 00 00       	call   801969 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a8d:	a1 80 50 80 00       	mov    0x805080,%eax
  800a92:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a98:	a1 84 50 80 00       	mov    0x805084,%eax
  800a9d:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800aa3:	83 c4 10             	add    $0x10,%esp
  800aa6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <devfile_write>:
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	53                   	push   %ebx
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800aba:	89 d8                	mov    %ebx,%eax
  800abc:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800ac2:	76 05                	jbe    800ac9 <devfile_write+0x19>
  800ac4:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ac9:	8b 55 08             	mov    0x8(%ebp),%edx
  800acc:	8b 52 0c             	mov    0xc(%edx),%edx
  800acf:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800ad5:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800ada:	83 ec 04             	sub    $0x4,%esp
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	68 08 50 80 00       	push   $0x805008
  800ae6:	e8 f1 0f 00 00       	call   801adc <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	b8 04 00 00 00       	mov    $0x4,%eax
  800af5:	e8 c4 fe ff ff       	call   8009be <fsipc>
  800afa:	83 c4 10             	add    $0x10,%esp
  800afd:	85 c0                	test   %eax,%eax
  800aff:	78 0b                	js     800b0c <devfile_write+0x5c>
	assert(r <= n);
  800b01:	39 c3                	cmp    %eax,%ebx
  800b03:	72 0c                	jb     800b11 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800b05:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b0a:	7f 1e                	jg     800b2a <devfile_write+0x7a>
}
  800b0c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b0f:	c9                   	leave  
  800b10:	c3                   	ret    
	assert(r <= n);
  800b11:	68 78 21 80 00       	push   $0x802178
  800b16:	68 7f 21 80 00       	push   $0x80217f
  800b1b:	68 98 00 00 00       	push   $0x98
  800b20:	68 94 21 80 00       	push   $0x802194
  800b25:	e8 24 07 00 00       	call   80124e <_panic>
	assert(r <= PGSIZE);
  800b2a:	68 9f 21 80 00       	push   $0x80219f
  800b2f:	68 7f 21 80 00       	push   $0x80217f
  800b34:	68 99 00 00 00       	push   $0x99
  800b39:	68 94 21 80 00       	push   $0x802194
  800b3e:	e8 0b 07 00 00       	call   80124e <_panic>

00800b43 <devfile_read>:
{
  800b43:	55                   	push   %ebp
  800b44:	89 e5                	mov    %esp,%ebp
  800b46:	56                   	push   %esi
  800b47:	53                   	push   %ebx
  800b48:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4e:	8b 40 0c             	mov    0xc(%eax),%eax
  800b51:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b56:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	b8 03 00 00 00       	mov    $0x3,%eax
  800b66:	e8 53 fe ff ff       	call   8009be <fsipc>
  800b6b:	89 c3                	mov    %eax,%ebx
  800b6d:	85 c0                	test   %eax,%eax
  800b6f:	78 1f                	js     800b90 <devfile_read+0x4d>
	assert(r <= n);
  800b71:	39 c6                	cmp    %eax,%esi
  800b73:	72 24                	jb     800b99 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b75:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b7a:	7f 33                	jg     800baf <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b7c:	83 ec 04             	sub    $0x4,%esp
  800b7f:	50                   	push   %eax
  800b80:	68 00 50 80 00       	push   $0x805000
  800b85:	ff 75 0c             	pushl  0xc(%ebp)
  800b88:	e8 4f 0f 00 00       	call   801adc <memmove>
	return r;
  800b8d:	83 c4 10             	add    $0x10,%esp
}
  800b90:	89 d8                	mov    %ebx,%eax
  800b92:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b95:	5b                   	pop    %ebx
  800b96:	5e                   	pop    %esi
  800b97:	5d                   	pop    %ebp
  800b98:	c3                   	ret    
	assert(r <= n);
  800b99:	68 78 21 80 00       	push   $0x802178
  800b9e:	68 7f 21 80 00       	push   $0x80217f
  800ba3:	6a 7c                	push   $0x7c
  800ba5:	68 94 21 80 00       	push   $0x802194
  800baa:	e8 9f 06 00 00       	call   80124e <_panic>
	assert(r <= PGSIZE);
  800baf:	68 9f 21 80 00       	push   $0x80219f
  800bb4:	68 7f 21 80 00       	push   $0x80217f
  800bb9:	6a 7d                	push   $0x7d
  800bbb:	68 94 21 80 00       	push   $0x802194
  800bc0:	e8 89 06 00 00       	call   80124e <_panic>

00800bc5 <open>:
{
  800bc5:	55                   	push   %ebp
  800bc6:	89 e5                	mov    %esp,%ebp
  800bc8:	56                   	push   %esi
  800bc9:	53                   	push   %ebx
  800bca:	83 ec 1c             	sub    $0x1c,%esp
  800bcd:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bd0:	56                   	push   %esi
  800bd1:	e8 60 0d 00 00       	call   801936 <strlen>
  800bd6:	83 c4 10             	add    $0x10,%esp
  800bd9:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bde:	7f 6c                	jg     800c4c <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800be0:	83 ec 0c             	sub    $0xc,%esp
  800be3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800be6:	50                   	push   %eax
  800be7:	e8 6b f8 ff ff       	call   800457 <fd_alloc>
  800bec:	89 c3                	mov    %eax,%ebx
  800bee:	83 c4 10             	add    $0x10,%esp
  800bf1:	85 c0                	test   %eax,%eax
  800bf3:	78 3c                	js     800c31 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bf5:	83 ec 08             	sub    $0x8,%esp
  800bf8:	56                   	push   %esi
  800bf9:	68 00 50 80 00       	push   $0x805000
  800bfe:	e8 66 0d 00 00       	call   801969 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c06:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c0e:	b8 01 00 00 00       	mov    $0x1,%eax
  800c13:	e8 a6 fd ff ff       	call   8009be <fsipc>
  800c18:	89 c3                	mov    %eax,%ebx
  800c1a:	83 c4 10             	add    $0x10,%esp
  800c1d:	85 c0                	test   %eax,%eax
  800c1f:	78 19                	js     800c3a <open+0x75>
	return fd2num(fd);
  800c21:	83 ec 0c             	sub    $0xc,%esp
  800c24:	ff 75 f4             	pushl  -0xc(%ebp)
  800c27:	e8 04 f8 ff ff       	call   800430 <fd2num>
  800c2c:	89 c3                	mov    %eax,%ebx
  800c2e:	83 c4 10             	add    $0x10,%esp
}
  800c31:	89 d8                	mov    %ebx,%eax
  800c33:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c36:	5b                   	pop    %ebx
  800c37:	5e                   	pop    %esi
  800c38:	5d                   	pop    %ebp
  800c39:	c3                   	ret    
		fd_close(fd, 0);
  800c3a:	83 ec 08             	sub    $0x8,%esp
  800c3d:	6a 00                	push   $0x0
  800c3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c42:	e8 0c f9 ff ff       	call   800553 <fd_close>
		return r;
  800c47:	83 c4 10             	add    $0x10,%esp
  800c4a:	eb e5                	jmp    800c31 <open+0x6c>
		return -E_BAD_PATH;
  800c4c:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c51:	eb de                	jmp    800c31 <open+0x6c>

00800c53 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c59:	ba 00 00 00 00       	mov    $0x0,%edx
  800c5e:	b8 08 00 00 00       	mov    $0x8,%eax
  800c63:	e8 56 fd ff ff       	call   8009be <fsipc>
}
  800c68:	c9                   	leave  
  800c69:	c3                   	ret    

00800c6a <writebuf>:


static void
writebuf(struct printbuf *b)
{
	if (b->error > 0) {
  800c6a:	83 78 0c 00          	cmpl   $0x0,0xc(%eax)
  800c6e:	7e 38                	jle    800ca8 <writebuf+0x3e>
{
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	53                   	push   %ebx
  800c74:	83 ec 08             	sub    $0x8,%esp
  800c77:	89 c3                	mov    %eax,%ebx
		ssize_t result = write(b->fd, b->buf, b->idx);
  800c79:	ff 70 04             	pushl  0x4(%eax)
  800c7c:	8d 40 10             	lea    0x10(%eax),%eax
  800c7f:	50                   	push   %eax
  800c80:	ff 33                	pushl  (%ebx)
  800c82:	e8 5a fb ff ff       	call   8007e1 <write>
		if (result > 0)
  800c87:	83 c4 10             	add    $0x10,%esp
  800c8a:	85 c0                	test   %eax,%eax
  800c8c:	7e 03                	jle    800c91 <writebuf+0x27>
			b->result += result;
  800c8e:	01 43 08             	add    %eax,0x8(%ebx)
		if (result != b->idx) // error, or wrote less than supplied
  800c91:	3b 43 04             	cmp    0x4(%ebx),%eax
  800c94:	74 0e                	je     800ca4 <writebuf+0x3a>
			b->error = (result < 0 ? result : 0);
  800c96:	89 c2                	mov    %eax,%edx
  800c98:	85 c0                	test   %eax,%eax
  800c9a:	7e 05                	jle    800ca1 <writebuf+0x37>
  800c9c:	ba 00 00 00 00       	mov    $0x0,%edx
  800ca1:	89 53 0c             	mov    %edx,0xc(%ebx)
	}
}
  800ca4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca7:	c9                   	leave  
  800ca8:	c3                   	ret    

00800ca9 <putch>:

static void
putch(int ch, void *thunk)
{
  800ca9:	55                   	push   %ebp
  800caa:	89 e5                	mov    %esp,%ebp
  800cac:	53                   	push   %ebx
  800cad:	83 ec 04             	sub    $0x4,%esp
  800cb0:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct printbuf *b = (struct printbuf *) thunk;
	b->buf[b->idx++] = ch;
  800cb3:	8b 53 04             	mov    0x4(%ebx),%edx
  800cb6:	8d 42 01             	lea    0x1(%edx),%eax
  800cb9:	89 43 04             	mov    %eax,0x4(%ebx)
  800cbc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800cbf:	88 4c 13 10          	mov    %cl,0x10(%ebx,%edx,1)
	if (b->idx == 256) {
  800cc3:	3d 00 01 00 00       	cmp    $0x100,%eax
  800cc8:	74 06                	je     800cd0 <putch+0x27>
		writebuf(b);
		b->idx = 0;
	}
}
  800cca:	83 c4 04             	add    $0x4,%esp
  800ccd:	5b                   	pop    %ebx
  800cce:	5d                   	pop    %ebp
  800ccf:	c3                   	ret    
		writebuf(b);
  800cd0:	89 d8                	mov    %ebx,%eax
  800cd2:	e8 93 ff ff ff       	call   800c6a <writebuf>
		b->idx = 0;
  800cd7:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
}
  800cde:	eb ea                	jmp    800cca <putch+0x21>

00800ce0 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap)
{
  800ce0:	55                   	push   %ebp
  800ce1:	89 e5                	mov    %esp,%ebp
  800ce3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.fd = fd;
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
	b.idx = 0;
  800cf2:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
  800cf9:	00 00 00 
	b.result = 0;
  800cfc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800d03:	00 00 00 
	b.error = 1;
  800d06:	c7 85 f4 fe ff ff 01 	movl   $0x1,-0x10c(%ebp)
  800d0d:	00 00 00 
	vprintfmt(putch, &b, fmt, ap);
  800d10:	ff 75 10             	pushl  0x10(%ebp)
  800d13:	ff 75 0c             	pushl  0xc(%ebp)
  800d16:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800d1c:	50                   	push   %eax
  800d1d:	68 a9 0c 80 00       	push   $0x800ca9
  800d22:	e8 34 07 00 00       	call   80145b <vprintfmt>
	if (b.idx > 0)
  800d27:	83 c4 10             	add    $0x10,%esp
  800d2a:	83 bd ec fe ff ff 00 	cmpl   $0x0,-0x114(%ebp)
  800d31:	7e 0b                	jle    800d3e <vfprintf+0x5e>
		writebuf(&b);
  800d33:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
  800d39:	e8 2c ff ff ff       	call   800c6a <writebuf>

	return (b.result ? b.result : b.error);
  800d3e:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
  800d44:	85 c0                	test   %eax,%eax
  800d46:	75 06                	jne    800d4e <vfprintf+0x6e>
  800d48:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <fprintf>:

int
fprintf(int fd, const char *fmt, ...)
{
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d56:	8d 45 10             	lea    0x10(%ebp),%eax
	cnt = vfprintf(fd, fmt, ap);
  800d59:	50                   	push   %eax
  800d5a:	ff 75 0c             	pushl  0xc(%ebp)
  800d5d:	ff 75 08             	pushl  0x8(%ebp)
  800d60:	e8 7b ff ff ff       	call   800ce0 <vfprintf>
	va_end(ap);

	return cnt;
}
  800d65:	c9                   	leave  
  800d66:	c3                   	ret    

00800d67 <printf>:

int
printf(const char *fmt, ...)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d6d:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vfprintf(1, fmt, ap);
  800d70:	50                   	push   %eax
  800d71:	ff 75 08             	pushl  0x8(%ebp)
  800d74:	6a 01                	push   $0x1
  800d76:	e8 65 ff ff ff       	call   800ce0 <vfprintf>
	va_end(ap);

	return cnt;
}
  800d7b:	c9                   	leave  
  800d7c:	c3                   	ret    

00800d7d <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800d7d:	55                   	push   %ebp
  800d7e:	89 e5                	mov    %esp,%ebp
  800d80:	56                   	push   %esi
  800d81:	53                   	push   %ebx
  800d82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800d85:	83 ec 0c             	sub    $0xc,%esp
  800d88:	ff 75 08             	pushl  0x8(%ebp)
  800d8b:	e8 b0 f6 ff ff       	call   800440 <fd2data>
  800d90:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800d92:	83 c4 08             	add    $0x8,%esp
  800d95:	68 ab 21 80 00       	push   $0x8021ab
  800d9a:	53                   	push   %ebx
  800d9b:	e8 c9 0b 00 00       	call   801969 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800da0:	8b 46 04             	mov    0x4(%esi),%eax
  800da3:	2b 06                	sub    (%esi),%eax
  800da5:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800dab:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800db2:	10 00 00 
	stat->st_dev = &devpipe;
  800db5:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800dbc:	30 80 00 
	return 0;
}
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800dc7:	5b                   	pop    %ebx
  800dc8:	5e                   	pop    %esi
  800dc9:	5d                   	pop    %ebp
  800dca:	c3                   	ret    

00800dcb <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	53                   	push   %ebx
  800dcf:	83 ec 0c             	sub    $0xc,%esp
  800dd2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800dd5:	53                   	push   %ebx
  800dd6:	6a 00                	push   $0x0
  800dd8:	e8 23 f4 ff ff       	call   800200 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ddd:	89 1c 24             	mov    %ebx,(%esp)
  800de0:	e8 5b f6 ff ff       	call   800440 <fd2data>
  800de5:	83 c4 08             	add    $0x8,%esp
  800de8:	50                   	push   %eax
  800de9:	6a 00                	push   $0x0
  800deb:	e8 10 f4 ff ff       	call   800200 <sys_page_unmap>
}
  800df0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <_pipeisclosed>:
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	57                   	push   %edi
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 1c             	sub    $0x1c,%esp
  800dfe:	89 c7                	mov    %eax,%edi
  800e00:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800e02:	a1 04 40 80 00       	mov    0x804004,%eax
  800e07:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800e0a:	83 ec 0c             	sub    $0xc,%esp
  800e0d:	57                   	push   %edi
  800e0e:	e8 95 0f 00 00       	call   801da8 <pageref>
  800e13:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e16:	89 34 24             	mov    %esi,(%esp)
  800e19:	e8 8a 0f 00 00       	call   801da8 <pageref>
		nn = thisenv->env_runs;
  800e1e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800e24:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800e27:	83 c4 10             	add    $0x10,%esp
  800e2a:	39 cb                	cmp    %ecx,%ebx
  800e2c:	74 1b                	je     800e49 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800e2e:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800e31:	75 cf                	jne    800e02 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800e33:	8b 42 58             	mov    0x58(%edx),%eax
  800e36:	6a 01                	push   $0x1
  800e38:	50                   	push   %eax
  800e39:	53                   	push   %ebx
  800e3a:	68 b2 21 80 00       	push   $0x8021b2
  800e3f:	e8 1d 05 00 00       	call   801361 <cprintf>
  800e44:	83 c4 10             	add    $0x10,%esp
  800e47:	eb b9                	jmp    800e02 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800e49:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800e4c:	0f 94 c0             	sete   %al
  800e4f:	0f b6 c0             	movzbl %al,%eax
}
  800e52:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800e55:	5b                   	pop    %ebx
  800e56:	5e                   	pop    %esi
  800e57:	5f                   	pop    %edi
  800e58:	5d                   	pop    %ebp
  800e59:	c3                   	ret    

00800e5a <devpipe_write>:
{
  800e5a:	55                   	push   %ebp
  800e5b:	89 e5                	mov    %esp,%ebp
  800e5d:	57                   	push   %edi
  800e5e:	56                   	push   %esi
  800e5f:	53                   	push   %ebx
  800e60:	83 ec 18             	sub    $0x18,%esp
  800e63:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800e66:	56                   	push   %esi
  800e67:	e8 d4 f5 ff ff       	call   800440 <fd2data>
  800e6c:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800e6e:	83 c4 10             	add    $0x10,%esp
  800e71:	bf 00 00 00 00       	mov    $0x0,%edi
  800e76:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800e79:	74 41                	je     800ebc <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800e7b:	8b 53 04             	mov    0x4(%ebx),%edx
  800e7e:	8b 03                	mov    (%ebx),%eax
  800e80:	83 c0 20             	add    $0x20,%eax
  800e83:	39 c2                	cmp    %eax,%edx
  800e85:	72 14                	jb     800e9b <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800e87:	89 da                	mov    %ebx,%edx
  800e89:	89 f0                	mov    %esi,%eax
  800e8b:	e8 65 ff ff ff       	call   800df5 <_pipeisclosed>
  800e90:	85 c0                	test   %eax,%eax
  800e92:	75 2c                	jne    800ec0 <devpipe_write+0x66>
			sys_yield();
  800e94:	e8 a9 f3 ff ff       	call   800242 <sys_yield>
  800e99:	eb e0                	jmp    800e7b <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800ea1:	89 d0                	mov    %edx,%eax
  800ea3:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800ea8:	78 0b                	js     800eb5 <devpipe_write+0x5b>
  800eaa:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800eae:	42                   	inc    %edx
  800eaf:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800eb2:	47                   	inc    %edi
  800eb3:	eb c1                	jmp    800e76 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800eb5:	48                   	dec    %eax
  800eb6:	83 c8 e0             	or     $0xffffffe0,%eax
  800eb9:	40                   	inc    %eax
  800eba:	eb ee                	jmp    800eaa <devpipe_write+0x50>
	return i;
  800ebc:	89 f8                	mov    %edi,%eax
  800ebe:	eb 05                	jmp    800ec5 <devpipe_write+0x6b>
				return 0;
  800ec0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ec5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ec8:	5b                   	pop    %ebx
  800ec9:	5e                   	pop    %esi
  800eca:	5f                   	pop    %edi
  800ecb:	5d                   	pop    %ebp
  800ecc:	c3                   	ret    

00800ecd <devpipe_read>:
{
  800ecd:	55                   	push   %ebp
  800ece:	89 e5                	mov    %esp,%ebp
  800ed0:	57                   	push   %edi
  800ed1:	56                   	push   %esi
  800ed2:	53                   	push   %ebx
  800ed3:	83 ec 18             	sub    $0x18,%esp
  800ed6:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800ed9:	57                   	push   %edi
  800eda:	e8 61 f5 ff ff       	call   800440 <fd2data>
  800edf:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800ee1:	83 c4 10             	add    $0x10,%esp
  800ee4:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ee9:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800eec:	74 46                	je     800f34 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800eee:	8b 06                	mov    (%esi),%eax
  800ef0:	3b 46 04             	cmp    0x4(%esi),%eax
  800ef3:	75 22                	jne    800f17 <devpipe_read+0x4a>
			if (i > 0)
  800ef5:	85 db                	test   %ebx,%ebx
  800ef7:	74 0a                	je     800f03 <devpipe_read+0x36>
				return i;
  800ef9:	89 d8                	mov    %ebx,%eax
}
  800efb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800efe:	5b                   	pop    %ebx
  800eff:	5e                   	pop    %esi
  800f00:	5f                   	pop    %edi
  800f01:	5d                   	pop    %ebp
  800f02:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800f03:	89 f2                	mov    %esi,%edx
  800f05:	89 f8                	mov    %edi,%eax
  800f07:	e8 e9 fe ff ff       	call   800df5 <_pipeisclosed>
  800f0c:	85 c0                	test   %eax,%eax
  800f0e:	75 28                	jne    800f38 <devpipe_read+0x6b>
			sys_yield();
  800f10:	e8 2d f3 ff ff       	call   800242 <sys_yield>
  800f15:	eb d7                	jmp    800eee <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800f17:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800f1c:	78 0f                	js     800f2d <devpipe_read+0x60>
  800f1e:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800f22:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800f25:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800f28:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800f2a:	43                   	inc    %ebx
  800f2b:	eb bc                	jmp    800ee9 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800f2d:	48                   	dec    %eax
  800f2e:	83 c8 e0             	or     $0xffffffe0,%eax
  800f31:	40                   	inc    %eax
  800f32:	eb ea                	jmp    800f1e <devpipe_read+0x51>
	return i;
  800f34:	89 d8                	mov    %ebx,%eax
  800f36:	eb c3                	jmp    800efb <devpipe_read+0x2e>
				return 0;
  800f38:	b8 00 00 00 00       	mov    $0x0,%eax
  800f3d:	eb bc                	jmp    800efb <devpipe_read+0x2e>

00800f3f <pipe>:
{
  800f3f:	55                   	push   %ebp
  800f40:	89 e5                	mov    %esp,%ebp
  800f42:	56                   	push   %esi
  800f43:	53                   	push   %ebx
  800f44:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800f47:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f4a:	50                   	push   %eax
  800f4b:	e8 07 f5 ff ff       	call   800457 <fd_alloc>
  800f50:	89 c3                	mov    %eax,%ebx
  800f52:	83 c4 10             	add    $0x10,%esp
  800f55:	85 c0                	test   %eax,%eax
  800f57:	0f 88 2a 01 00 00    	js     801087 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f5d:	83 ec 04             	sub    $0x4,%esp
  800f60:	68 07 04 00 00       	push   $0x407
  800f65:	ff 75 f4             	pushl  -0xc(%ebp)
  800f68:	6a 00                	push   $0x0
  800f6a:	e8 0c f2 ff ff       	call   80017b <sys_page_alloc>
  800f6f:	89 c3                	mov    %eax,%ebx
  800f71:	83 c4 10             	add    $0x10,%esp
  800f74:	85 c0                	test   %eax,%eax
  800f76:	0f 88 0b 01 00 00    	js     801087 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800f7c:	83 ec 0c             	sub    $0xc,%esp
  800f7f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800f82:	50                   	push   %eax
  800f83:	e8 cf f4 ff ff       	call   800457 <fd_alloc>
  800f88:	89 c3                	mov    %eax,%ebx
  800f8a:	83 c4 10             	add    $0x10,%esp
  800f8d:	85 c0                	test   %eax,%eax
  800f8f:	0f 88 e2 00 00 00    	js     801077 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800f95:	83 ec 04             	sub    $0x4,%esp
  800f98:	68 07 04 00 00       	push   $0x407
  800f9d:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa0:	6a 00                	push   $0x0
  800fa2:	e8 d4 f1 ff ff       	call   80017b <sys_page_alloc>
  800fa7:	89 c3                	mov    %eax,%ebx
  800fa9:	83 c4 10             	add    $0x10,%esp
  800fac:	85 c0                	test   %eax,%eax
  800fae:	0f 88 c3 00 00 00    	js     801077 <pipe+0x138>
	va = fd2data(fd0);
  800fb4:	83 ec 0c             	sub    $0xc,%esp
  800fb7:	ff 75 f4             	pushl  -0xc(%ebp)
  800fba:	e8 81 f4 ff ff       	call   800440 <fd2data>
  800fbf:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fc1:	83 c4 0c             	add    $0xc,%esp
  800fc4:	68 07 04 00 00       	push   $0x407
  800fc9:	50                   	push   %eax
  800fca:	6a 00                	push   $0x0
  800fcc:	e8 aa f1 ff ff       	call   80017b <sys_page_alloc>
  800fd1:	89 c3                	mov    %eax,%ebx
  800fd3:	83 c4 10             	add    $0x10,%esp
  800fd6:	85 c0                	test   %eax,%eax
  800fd8:	0f 88 89 00 00 00    	js     801067 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800fde:	83 ec 0c             	sub    $0xc,%esp
  800fe1:	ff 75 f0             	pushl  -0x10(%ebp)
  800fe4:	e8 57 f4 ff ff       	call   800440 <fd2data>
  800fe9:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800ff0:	50                   	push   %eax
  800ff1:	6a 00                	push   $0x0
  800ff3:	56                   	push   %esi
  800ff4:	6a 00                	push   $0x0
  800ff6:	e8 c3 f1 ff ff       	call   8001be <sys_page_map>
  800ffb:	89 c3                	mov    %eax,%ebx
  800ffd:	83 c4 20             	add    $0x20,%esp
  801000:	85 c0                	test   %eax,%eax
  801002:	78 55                	js     801059 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  801004:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80100a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100d:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  80100f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801012:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  801019:	8b 15 20 30 80 00    	mov    0x803020,%edx
  80101f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801022:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  801024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801027:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  80102e:	83 ec 0c             	sub    $0xc,%esp
  801031:	ff 75 f4             	pushl  -0xc(%ebp)
  801034:	e8 f7 f3 ff ff       	call   800430 <fd2num>
  801039:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80103c:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  80103e:	83 c4 04             	add    $0x4,%esp
  801041:	ff 75 f0             	pushl  -0x10(%ebp)
  801044:	e8 e7 f3 ff ff       	call   800430 <fd2num>
  801049:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80104c:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  80104f:	83 c4 10             	add    $0x10,%esp
  801052:	bb 00 00 00 00       	mov    $0x0,%ebx
  801057:	eb 2e                	jmp    801087 <pipe+0x148>
	sys_page_unmap(0, va);
  801059:	83 ec 08             	sub    $0x8,%esp
  80105c:	56                   	push   %esi
  80105d:	6a 00                	push   $0x0
  80105f:	e8 9c f1 ff ff       	call   800200 <sys_page_unmap>
  801064:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  801067:	83 ec 08             	sub    $0x8,%esp
  80106a:	ff 75 f0             	pushl  -0x10(%ebp)
  80106d:	6a 00                	push   $0x0
  80106f:	e8 8c f1 ff ff       	call   800200 <sys_page_unmap>
  801074:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  801077:	83 ec 08             	sub    $0x8,%esp
  80107a:	ff 75 f4             	pushl  -0xc(%ebp)
  80107d:	6a 00                	push   $0x0
  80107f:	e8 7c f1 ff ff       	call   800200 <sys_page_unmap>
  801084:	83 c4 10             	add    $0x10,%esp
}
  801087:	89 d8                	mov    %ebx,%eax
  801089:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80108c:	5b                   	pop    %ebx
  80108d:	5e                   	pop    %esi
  80108e:	5d                   	pop    %ebp
  80108f:	c3                   	ret    

00801090 <pipeisclosed>:
{
  801090:	55                   	push   %ebp
  801091:	89 e5                	mov    %esp,%ebp
  801093:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801096:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801099:	50                   	push   %eax
  80109a:	ff 75 08             	pushl  0x8(%ebp)
  80109d:	e8 04 f4 ff ff       	call   8004a6 <fd_lookup>
  8010a2:	83 c4 10             	add    $0x10,%esp
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	78 18                	js     8010c1 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  8010a9:	83 ec 0c             	sub    $0xc,%esp
  8010ac:	ff 75 f4             	pushl  -0xc(%ebp)
  8010af:	e8 8c f3 ff ff       	call   800440 <fd2data>
	return _pipeisclosed(fd, p);
  8010b4:	89 c2                	mov    %eax,%edx
  8010b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b9:	e8 37 fd ff ff       	call   800df5 <_pipeisclosed>
  8010be:	83 c4 10             	add    $0x10,%esp
}
  8010c1:	c9                   	leave  
  8010c2:	c3                   	ret    

008010c3 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  8010c3:	55                   	push   %ebp
  8010c4:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  8010c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8010cb:	5d                   	pop    %ebp
  8010cc:	c3                   	ret    

008010cd <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  8010cd:	55                   	push   %ebp
  8010ce:	89 e5                	mov    %esp,%ebp
  8010d0:	53                   	push   %ebx
  8010d1:	83 ec 0c             	sub    $0xc,%esp
  8010d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  8010d7:	68 ca 21 80 00       	push   $0x8021ca
  8010dc:	53                   	push   %ebx
  8010dd:	e8 87 08 00 00       	call   801969 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  8010e2:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  8010e9:	20 00 00 
	return 0;
}
  8010ec:	b8 00 00 00 00       	mov    $0x0,%eax
  8010f1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8010f4:	c9                   	leave  
  8010f5:	c3                   	ret    

008010f6 <devcons_write>:
{
  8010f6:	55                   	push   %ebp
  8010f7:	89 e5                	mov    %esp,%ebp
  8010f9:	57                   	push   %edi
  8010fa:	56                   	push   %esi
  8010fb:	53                   	push   %ebx
  8010fc:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  801102:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  801107:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  80110d:	eb 1d                	jmp    80112c <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  80110f:	83 ec 04             	sub    $0x4,%esp
  801112:	53                   	push   %ebx
  801113:	03 45 0c             	add    0xc(%ebp),%eax
  801116:	50                   	push   %eax
  801117:	57                   	push   %edi
  801118:	e8 bf 09 00 00       	call   801adc <memmove>
		sys_cputs(buf, m);
  80111d:	83 c4 08             	add    $0x8,%esp
  801120:	53                   	push   %ebx
  801121:	57                   	push   %edi
  801122:	e8 b7 ef ff ff       	call   8000de <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801127:	01 de                	add    %ebx,%esi
  801129:	83 c4 10             	add    $0x10,%esp
  80112c:	89 f0                	mov    %esi,%eax
  80112e:	3b 75 10             	cmp    0x10(%ebp),%esi
  801131:	73 11                	jae    801144 <devcons_write+0x4e>
		m = n - tot;
  801133:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801136:	29 f3                	sub    %esi,%ebx
  801138:	83 fb 7f             	cmp    $0x7f,%ebx
  80113b:	76 d2                	jbe    80110f <devcons_write+0x19>
  80113d:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801142:	eb cb                	jmp    80110f <devcons_write+0x19>
}
  801144:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801147:	5b                   	pop    %ebx
  801148:	5e                   	pop    %esi
  801149:	5f                   	pop    %edi
  80114a:	5d                   	pop    %ebp
  80114b:	c3                   	ret    

0080114c <devcons_read>:
{
  80114c:	55                   	push   %ebp
  80114d:	89 e5                	mov    %esp,%ebp
  80114f:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801156:	75 0c                	jne    801164 <devcons_read+0x18>
		return 0;
  801158:	b8 00 00 00 00       	mov    $0x0,%eax
  80115d:	eb 21                	jmp    801180 <devcons_read+0x34>
		sys_yield();
  80115f:	e8 de f0 ff ff       	call   800242 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801164:	e8 93 ef ff ff       	call   8000fc <sys_cgetc>
  801169:	85 c0                	test   %eax,%eax
  80116b:	74 f2                	je     80115f <devcons_read+0x13>
	if (c < 0)
  80116d:	85 c0                	test   %eax,%eax
  80116f:	78 0f                	js     801180 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801171:	83 f8 04             	cmp    $0x4,%eax
  801174:	74 0c                	je     801182 <devcons_read+0x36>
	*(char*)vbuf = c;
  801176:	8b 55 0c             	mov    0xc(%ebp),%edx
  801179:	88 02                	mov    %al,(%edx)
	return 1;
  80117b:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801180:	c9                   	leave  
  801181:	c3                   	ret    
		return 0;
  801182:	b8 00 00 00 00       	mov    $0x0,%eax
  801187:	eb f7                	jmp    801180 <devcons_read+0x34>

00801189 <cputchar>:
{
  801189:	55                   	push   %ebp
  80118a:	89 e5                	mov    %esp,%ebp
  80118c:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801195:	6a 01                	push   $0x1
  801197:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80119a:	50                   	push   %eax
  80119b:	e8 3e ef ff ff       	call   8000de <sys_cputs>
}
  8011a0:	83 c4 10             	add    $0x10,%esp
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <getchar>:
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  8011ab:	6a 01                	push   $0x1
  8011ad:	8d 45 f7             	lea    -0x9(%ebp),%eax
  8011b0:	50                   	push   %eax
  8011b1:	6a 00                	push   $0x0
  8011b3:	e8 5b f5 ff ff       	call   800713 <read>
	if (r < 0)
  8011b8:	83 c4 10             	add    $0x10,%esp
  8011bb:	85 c0                	test   %eax,%eax
  8011bd:	78 08                	js     8011c7 <getchar+0x22>
	if (r < 1)
  8011bf:	85 c0                	test   %eax,%eax
  8011c1:	7e 06                	jle    8011c9 <getchar+0x24>
	return c;
  8011c3:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8011c7:	c9                   	leave  
  8011c8:	c3                   	ret    
		return -E_EOF;
  8011c9:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8011ce:	eb f7                	jmp    8011c7 <getchar+0x22>

008011d0 <iscons>:
{
  8011d0:	55                   	push   %ebp
  8011d1:	89 e5                	mov    %esp,%ebp
  8011d3:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8011d6:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8011d9:	50                   	push   %eax
  8011da:	ff 75 08             	pushl  0x8(%ebp)
  8011dd:	e8 c4 f2 ff ff       	call   8004a6 <fd_lookup>
  8011e2:	83 c4 10             	add    $0x10,%esp
  8011e5:	85 c0                	test   %eax,%eax
  8011e7:	78 11                	js     8011fa <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8011f2:	39 10                	cmp    %edx,(%eax)
  8011f4:	0f 94 c0             	sete   %al
  8011f7:	0f b6 c0             	movzbl %al,%eax
}
  8011fa:	c9                   	leave  
  8011fb:	c3                   	ret    

008011fc <opencons>:
{
  8011fc:	55                   	push   %ebp
  8011fd:	89 e5                	mov    %esp,%ebp
  8011ff:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  801202:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801205:	50                   	push   %eax
  801206:	e8 4c f2 ff ff       	call   800457 <fd_alloc>
  80120b:	83 c4 10             	add    $0x10,%esp
  80120e:	85 c0                	test   %eax,%eax
  801210:	78 3a                	js     80124c <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801212:	83 ec 04             	sub    $0x4,%esp
  801215:	68 07 04 00 00       	push   $0x407
  80121a:	ff 75 f4             	pushl  -0xc(%ebp)
  80121d:	6a 00                	push   $0x0
  80121f:	e8 57 ef ff ff       	call   80017b <sys_page_alloc>
  801224:	83 c4 10             	add    $0x10,%esp
  801227:	85 c0                	test   %eax,%eax
  801229:	78 21                	js     80124c <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80122b:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801231:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801234:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801236:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801239:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  801240:	83 ec 0c             	sub    $0xc,%esp
  801243:	50                   	push   %eax
  801244:	e8 e7 f1 ff ff       	call   800430 <fd2num>
  801249:	83 c4 10             	add    $0x10,%esp
}
  80124c:	c9                   	leave  
  80124d:	c3                   	ret    

0080124e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80124e:	55                   	push   %ebp
  80124f:	89 e5                	mov    %esp,%ebp
  801251:	57                   	push   %edi
  801252:	56                   	push   %esi
  801253:	53                   	push   %ebx
  801254:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  80125a:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80125d:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801263:	e8 f4 ee ff ff       	call   80015c <sys_getenvid>
  801268:	83 ec 04             	sub    $0x4,%esp
  80126b:	ff 75 0c             	pushl  0xc(%ebp)
  80126e:	ff 75 08             	pushl  0x8(%ebp)
  801271:	53                   	push   %ebx
  801272:	50                   	push   %eax
  801273:	68 d8 21 80 00       	push   $0x8021d8
  801278:	68 00 01 00 00       	push   $0x100
  80127d:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801283:	56                   	push   %esi
  801284:	e8 93 06 00 00       	call   80191c <snprintf>
  801289:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80128b:	83 c4 20             	add    $0x20,%esp
  80128e:	57                   	push   %edi
  80128f:	ff 75 10             	pushl  0x10(%ebp)
  801292:	bf 00 01 00 00       	mov    $0x100,%edi
  801297:	89 f8                	mov    %edi,%eax
  801299:	29 d8                	sub    %ebx,%eax
  80129b:	50                   	push   %eax
  80129c:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80129f:	50                   	push   %eax
  8012a0:	e8 22 06 00 00       	call   8018c7 <vsnprintf>
  8012a5:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8012a7:	83 c4 0c             	add    $0xc,%esp
  8012aa:	68 c3 21 80 00       	push   $0x8021c3
  8012af:	29 df                	sub    %ebx,%edi
  8012b1:	57                   	push   %edi
  8012b2:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8012b5:	50                   	push   %eax
  8012b6:	e8 61 06 00 00       	call   80191c <snprintf>
	sys_cputs(buf, r);
  8012bb:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8012be:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8012c0:	53                   	push   %ebx
  8012c1:	56                   	push   %esi
  8012c2:	e8 17 ee ff ff       	call   8000de <sys_cputs>
  8012c7:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8012ca:	cc                   	int3   
  8012cb:	eb fd                	jmp    8012ca <_panic+0x7c>

008012cd <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8012cd:	55                   	push   %ebp
  8012ce:	89 e5                	mov    %esp,%ebp
  8012d0:	53                   	push   %ebx
  8012d1:	83 ec 04             	sub    $0x4,%esp
  8012d4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8012d7:	8b 13                	mov    (%ebx),%edx
  8012d9:	8d 42 01             	lea    0x1(%edx),%eax
  8012dc:	89 03                	mov    %eax,(%ebx)
  8012de:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e1:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8012e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8012ea:	74 08                	je     8012f4 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8012ec:	ff 43 04             	incl   0x4(%ebx)
}
  8012ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8012f4:	83 ec 08             	sub    $0x8,%esp
  8012f7:	68 ff 00 00 00       	push   $0xff
  8012fc:	8d 43 08             	lea    0x8(%ebx),%eax
  8012ff:	50                   	push   %eax
  801300:	e8 d9 ed ff ff       	call   8000de <sys_cputs>
		b->idx = 0;
  801305:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  80130b:	83 c4 10             	add    $0x10,%esp
  80130e:	eb dc                	jmp    8012ec <putch+0x1f>

00801310 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  801310:	55                   	push   %ebp
  801311:	89 e5                	mov    %esp,%ebp
  801313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801320:	00 00 00 
	b.cnt = 0;
  801323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80132a:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80132d:	ff 75 0c             	pushl  0xc(%ebp)
  801330:	ff 75 08             	pushl  0x8(%ebp)
  801333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801339:	50                   	push   %eax
  80133a:	68 cd 12 80 00       	push   $0x8012cd
  80133f:	e8 17 01 00 00       	call   80145b <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801344:	83 c4 08             	add    $0x8,%esp
  801347:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80134d:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801353:	50                   	push   %eax
  801354:	e8 85 ed ff ff       	call   8000de <sys_cputs>

	return b.cnt;
}
  801359:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801367:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  80136a:	50                   	push   %eax
  80136b:	ff 75 08             	pushl  0x8(%ebp)
  80136e:	e8 9d ff ff ff       	call   801310 <vcprintf>
	va_end(ap);

	return cnt;
}
  801373:	c9                   	leave  
  801374:	c3                   	ret    

00801375 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801375:	55                   	push   %ebp
  801376:	89 e5                	mov    %esp,%ebp
  801378:	57                   	push   %edi
  801379:	56                   	push   %esi
  80137a:	53                   	push   %ebx
  80137b:	83 ec 1c             	sub    $0x1c,%esp
  80137e:	89 c7                	mov    %eax,%edi
  801380:	89 d6                	mov    %edx,%esi
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8b 55 0c             	mov    0xc(%ebp),%edx
  801388:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80138b:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80138e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801391:	bb 00 00 00 00       	mov    $0x0,%ebx
  801396:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801399:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80139c:	39 d3                	cmp    %edx,%ebx
  80139e:	72 05                	jb     8013a5 <printnum+0x30>
  8013a0:	39 45 10             	cmp    %eax,0x10(%ebp)
  8013a3:	77 78                	ja     80141d <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8013a5:	83 ec 0c             	sub    $0xc,%esp
  8013a8:	ff 75 18             	pushl  0x18(%ebp)
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8013b1:	53                   	push   %ebx
  8013b2:	ff 75 10             	pushl  0x10(%ebp)
  8013b5:	83 ec 08             	sub    $0x8,%esp
  8013b8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013bb:	ff 75 e0             	pushl  -0x20(%ebp)
  8013be:	ff 75 dc             	pushl  -0x24(%ebp)
  8013c1:	ff 75 d8             	pushl  -0x28(%ebp)
  8013c4:	e8 23 0a 00 00       	call   801dec <__udivdi3>
  8013c9:	83 c4 18             	add    $0x18,%esp
  8013cc:	52                   	push   %edx
  8013cd:	50                   	push   %eax
  8013ce:	89 f2                	mov    %esi,%edx
  8013d0:	89 f8                	mov    %edi,%eax
  8013d2:	e8 9e ff ff ff       	call   801375 <printnum>
  8013d7:	83 c4 20             	add    $0x20,%esp
  8013da:	eb 11                	jmp    8013ed <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8013dc:	83 ec 08             	sub    $0x8,%esp
  8013df:	56                   	push   %esi
  8013e0:	ff 75 18             	pushl  0x18(%ebp)
  8013e3:	ff d7                	call   *%edi
  8013e5:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8013e8:	4b                   	dec    %ebx
  8013e9:	85 db                	test   %ebx,%ebx
  8013eb:	7f ef                	jg     8013dc <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8013ed:	83 ec 08             	sub    $0x8,%esp
  8013f0:	56                   	push   %esi
  8013f1:	83 ec 04             	sub    $0x4,%esp
  8013f4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8013f7:	ff 75 e0             	pushl  -0x20(%ebp)
  8013fa:	ff 75 dc             	pushl  -0x24(%ebp)
  8013fd:	ff 75 d8             	pushl  -0x28(%ebp)
  801400:	e8 f7 0a 00 00       	call   801efc <__umoddi3>
  801405:	83 c4 14             	add    $0x14,%esp
  801408:	0f be 80 fb 21 80 00 	movsbl 0x8021fb(%eax),%eax
  80140f:	50                   	push   %eax
  801410:	ff d7                	call   *%edi
}
  801412:	83 c4 10             	add    $0x10,%esp
  801415:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801418:	5b                   	pop    %ebx
  801419:	5e                   	pop    %esi
  80141a:	5f                   	pop    %edi
  80141b:	5d                   	pop    %ebp
  80141c:	c3                   	ret    
  80141d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801420:	eb c6                	jmp    8013e8 <printnum+0x73>

00801422 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801422:	55                   	push   %ebp
  801423:	89 e5                	mov    %esp,%ebp
  801425:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801428:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80142b:	8b 10                	mov    (%eax),%edx
  80142d:	3b 50 04             	cmp    0x4(%eax),%edx
  801430:	73 0a                	jae    80143c <sprintputch+0x1a>
		*b->buf++ = ch;
  801432:	8d 4a 01             	lea    0x1(%edx),%ecx
  801435:	89 08                	mov    %ecx,(%eax)
  801437:	8b 45 08             	mov    0x8(%ebp),%eax
  80143a:	88 02                	mov    %al,(%edx)
}
  80143c:	5d                   	pop    %ebp
  80143d:	c3                   	ret    

0080143e <printfmt>:
{
  80143e:	55                   	push   %ebp
  80143f:	89 e5                	mov    %esp,%ebp
  801441:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801444:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801447:	50                   	push   %eax
  801448:	ff 75 10             	pushl  0x10(%ebp)
  80144b:	ff 75 0c             	pushl  0xc(%ebp)
  80144e:	ff 75 08             	pushl  0x8(%ebp)
  801451:	e8 05 00 00 00       	call   80145b <vprintfmt>
}
  801456:	83 c4 10             	add    $0x10,%esp
  801459:	c9                   	leave  
  80145a:	c3                   	ret    

0080145b <vprintfmt>:
{
  80145b:	55                   	push   %ebp
  80145c:	89 e5                	mov    %esp,%ebp
  80145e:	57                   	push   %edi
  80145f:	56                   	push   %esi
  801460:	53                   	push   %ebx
  801461:	83 ec 2c             	sub    $0x2c,%esp
  801464:	8b 75 08             	mov    0x8(%ebp),%esi
  801467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  80146a:	8b 7d 10             	mov    0x10(%ebp),%edi
  80146d:	e9 ae 03 00 00       	jmp    801820 <vprintfmt+0x3c5>
  801472:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801476:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80147d:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801484:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80148b:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801490:	8d 47 01             	lea    0x1(%edi),%eax
  801493:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801496:	8a 17                	mov    (%edi),%dl
  801498:	8d 42 dd             	lea    -0x23(%edx),%eax
  80149b:	3c 55                	cmp    $0x55,%al
  80149d:	0f 87 fe 03 00 00    	ja     8018a1 <vprintfmt+0x446>
  8014a3:	0f b6 c0             	movzbl %al,%eax
  8014a6:	ff 24 85 40 23 80 00 	jmp    *0x802340(,%eax,4)
  8014ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  8014b0:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8014b4:	eb da                	jmp    801490 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8014b6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8014b9:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8014bd:	eb d1                	jmp    801490 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8014bf:	0f b6 d2             	movzbl %dl,%edx
  8014c2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8014c5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ca:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8014cd:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8014d0:	01 c0                	add    %eax,%eax
  8014d2:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8014d6:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8014d9:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8014dc:	83 f9 09             	cmp    $0x9,%ecx
  8014df:	77 52                	ja     801533 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8014e1:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8014e2:	eb e9                	jmp    8014cd <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8014e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e7:	8b 00                	mov    (%eax),%eax
  8014e9:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8014ef:	8d 40 04             	lea    0x4(%eax),%eax
  8014f2:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8014f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8014f8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014fc:	79 92                	jns    801490 <vprintfmt+0x35>
				width = precision, precision = -1;
  8014fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801501:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801504:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80150b:	eb 83                	jmp    801490 <vprintfmt+0x35>
  80150d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801511:	78 08                	js     80151b <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  801513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801516:	e9 75 ff ff ff       	jmp    801490 <vprintfmt+0x35>
  80151b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801522:	eb ef                	jmp    801513 <vprintfmt+0xb8>
  801524:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801527:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80152e:	e9 5d ff ff ff       	jmp    801490 <vprintfmt+0x35>
  801533:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801536:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801539:	eb bd                	jmp    8014f8 <vprintfmt+0x9d>
			lflag++;
  80153b:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80153c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80153f:	e9 4c ff ff ff       	jmp    801490 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801544:	8b 45 14             	mov    0x14(%ebp),%eax
  801547:	8d 78 04             	lea    0x4(%eax),%edi
  80154a:	83 ec 08             	sub    $0x8,%esp
  80154d:	53                   	push   %ebx
  80154e:	ff 30                	pushl  (%eax)
  801550:	ff d6                	call   *%esi
			break;
  801552:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801555:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801558:	e9 c0 02 00 00       	jmp    80181d <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80155d:	8b 45 14             	mov    0x14(%ebp),%eax
  801560:	8d 78 04             	lea    0x4(%eax),%edi
  801563:	8b 00                	mov    (%eax),%eax
  801565:	85 c0                	test   %eax,%eax
  801567:	78 2a                	js     801593 <vprintfmt+0x138>
  801569:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80156b:	83 f8 0f             	cmp    $0xf,%eax
  80156e:	7f 27                	jg     801597 <vprintfmt+0x13c>
  801570:	8b 04 85 a0 24 80 00 	mov    0x8024a0(,%eax,4),%eax
  801577:	85 c0                	test   %eax,%eax
  801579:	74 1c                	je     801597 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80157b:	50                   	push   %eax
  80157c:	68 91 21 80 00       	push   $0x802191
  801581:	53                   	push   %ebx
  801582:	56                   	push   %esi
  801583:	e8 b6 fe ff ff       	call   80143e <printfmt>
  801588:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80158b:	89 7d 14             	mov    %edi,0x14(%ebp)
  80158e:	e9 8a 02 00 00       	jmp    80181d <vprintfmt+0x3c2>
  801593:	f7 d8                	neg    %eax
  801595:	eb d2                	jmp    801569 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801597:	52                   	push   %edx
  801598:	68 13 22 80 00       	push   $0x802213
  80159d:	53                   	push   %ebx
  80159e:	56                   	push   %esi
  80159f:	e8 9a fe ff ff       	call   80143e <printfmt>
  8015a4:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  8015a7:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  8015aa:	e9 6e 02 00 00       	jmp    80181d <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  8015af:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b2:	83 c0 04             	add    $0x4,%eax
  8015b5:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8015b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8015bb:	8b 38                	mov    (%eax),%edi
  8015bd:	85 ff                	test   %edi,%edi
  8015bf:	74 39                	je     8015fa <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8015c1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8015c5:	0f 8e a9 00 00 00    	jle    801674 <vprintfmt+0x219>
  8015cb:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8015cf:	0f 84 a7 00 00 00    	je     80167c <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8015d5:	83 ec 08             	sub    $0x8,%esp
  8015d8:	ff 75 d0             	pushl  -0x30(%ebp)
  8015db:	57                   	push   %edi
  8015dc:	e8 6b 03 00 00       	call   80194c <strnlen>
  8015e1:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8015e4:	29 c1                	sub    %eax,%ecx
  8015e6:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8015e9:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8015ec:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8015f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8015f3:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8015f6:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8015f8:	eb 14                	jmp    80160e <vprintfmt+0x1b3>
				p = "(null)";
  8015fa:	bf 0c 22 80 00       	mov    $0x80220c,%edi
  8015ff:	eb c0                	jmp    8015c1 <vprintfmt+0x166>
					putch(padc, putdat);
  801601:	83 ec 08             	sub    $0x8,%esp
  801604:	53                   	push   %ebx
  801605:	ff 75 e0             	pushl  -0x20(%ebp)
  801608:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  80160a:	4f                   	dec    %edi
  80160b:	83 c4 10             	add    $0x10,%esp
  80160e:	85 ff                	test   %edi,%edi
  801610:	7f ef                	jg     801601 <vprintfmt+0x1a6>
  801612:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801615:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801618:	89 c8                	mov    %ecx,%eax
  80161a:	85 c9                	test   %ecx,%ecx
  80161c:	78 10                	js     80162e <vprintfmt+0x1d3>
  80161e:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801621:	29 c1                	sub    %eax,%ecx
  801623:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801626:	89 75 08             	mov    %esi,0x8(%ebp)
  801629:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80162c:	eb 15                	jmp    801643 <vprintfmt+0x1e8>
  80162e:	b8 00 00 00 00       	mov    $0x0,%eax
  801633:	eb e9                	jmp    80161e <vprintfmt+0x1c3>
					putch(ch, putdat);
  801635:	83 ec 08             	sub    $0x8,%esp
  801638:	53                   	push   %ebx
  801639:	52                   	push   %edx
  80163a:	ff 55 08             	call   *0x8(%ebp)
  80163d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801640:	ff 4d e0             	decl   -0x20(%ebp)
  801643:	47                   	inc    %edi
  801644:	8a 47 ff             	mov    -0x1(%edi),%al
  801647:	0f be d0             	movsbl %al,%edx
  80164a:	85 d2                	test   %edx,%edx
  80164c:	74 59                	je     8016a7 <vprintfmt+0x24c>
  80164e:	85 f6                	test   %esi,%esi
  801650:	78 03                	js     801655 <vprintfmt+0x1fa>
  801652:	4e                   	dec    %esi
  801653:	78 2f                	js     801684 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801655:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801659:	74 da                	je     801635 <vprintfmt+0x1da>
  80165b:	0f be c0             	movsbl %al,%eax
  80165e:	83 e8 20             	sub    $0x20,%eax
  801661:	83 f8 5e             	cmp    $0x5e,%eax
  801664:	76 cf                	jbe    801635 <vprintfmt+0x1da>
					putch('?', putdat);
  801666:	83 ec 08             	sub    $0x8,%esp
  801669:	53                   	push   %ebx
  80166a:	6a 3f                	push   $0x3f
  80166c:	ff 55 08             	call   *0x8(%ebp)
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	eb cc                	jmp    801640 <vprintfmt+0x1e5>
  801674:	89 75 08             	mov    %esi,0x8(%ebp)
  801677:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80167a:	eb c7                	jmp    801643 <vprintfmt+0x1e8>
  80167c:	89 75 08             	mov    %esi,0x8(%ebp)
  80167f:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801682:	eb bf                	jmp    801643 <vprintfmt+0x1e8>
  801684:	8b 75 08             	mov    0x8(%ebp),%esi
  801687:	8b 7d e0             	mov    -0x20(%ebp),%edi
  80168a:	eb 0c                	jmp    801698 <vprintfmt+0x23d>
				putch(' ', putdat);
  80168c:	83 ec 08             	sub    $0x8,%esp
  80168f:	53                   	push   %ebx
  801690:	6a 20                	push   $0x20
  801692:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801694:	4f                   	dec    %edi
  801695:	83 c4 10             	add    $0x10,%esp
  801698:	85 ff                	test   %edi,%edi
  80169a:	7f f0                	jg     80168c <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80169c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80169f:	89 45 14             	mov    %eax,0x14(%ebp)
  8016a2:	e9 76 01 00 00       	jmp    80181d <vprintfmt+0x3c2>
  8016a7:	8b 7d e0             	mov    -0x20(%ebp),%edi
  8016aa:	8b 75 08             	mov    0x8(%ebp),%esi
  8016ad:	eb e9                	jmp    801698 <vprintfmt+0x23d>
	if (lflag >= 2)
  8016af:	83 f9 01             	cmp    $0x1,%ecx
  8016b2:	7f 1f                	jg     8016d3 <vprintfmt+0x278>
	else if (lflag)
  8016b4:	85 c9                	test   %ecx,%ecx
  8016b6:	75 48                	jne    801700 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8016b8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016bb:	8b 00                	mov    (%eax),%eax
  8016bd:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016c0:	89 c1                	mov    %eax,%ecx
  8016c2:	c1 f9 1f             	sar    $0x1f,%ecx
  8016c5:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	8d 40 04             	lea    0x4(%eax),%eax
  8016ce:	89 45 14             	mov    %eax,0x14(%ebp)
  8016d1:	eb 17                	jmp    8016ea <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8016d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016d6:	8b 50 04             	mov    0x4(%eax),%edx
  8016d9:	8b 00                	mov    (%eax),%eax
  8016db:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8016de:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8016e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e4:	8d 40 08             	lea    0x8(%eax),%eax
  8016e7:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8016ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8016ed:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8016f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8016f4:	78 25                	js     80171b <vprintfmt+0x2c0>
			base = 10;
  8016f6:	b8 0a 00 00 00       	mov    $0xa,%eax
  8016fb:	e9 03 01 00 00       	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  801700:	8b 45 14             	mov    0x14(%ebp),%eax
  801703:	8b 00                	mov    (%eax),%eax
  801705:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801708:	89 c1                	mov    %eax,%ecx
  80170a:	c1 f9 1f             	sar    $0x1f,%ecx
  80170d:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801710:	8b 45 14             	mov    0x14(%ebp),%eax
  801713:	8d 40 04             	lea    0x4(%eax),%eax
  801716:	89 45 14             	mov    %eax,0x14(%ebp)
  801719:	eb cf                	jmp    8016ea <vprintfmt+0x28f>
				putch('-', putdat);
  80171b:	83 ec 08             	sub    $0x8,%esp
  80171e:	53                   	push   %ebx
  80171f:	6a 2d                	push   $0x2d
  801721:	ff d6                	call   *%esi
				num = -(long long) num;
  801723:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801726:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801729:	f7 da                	neg    %edx
  80172b:	83 d1 00             	adc    $0x0,%ecx
  80172e:	f7 d9                	neg    %ecx
  801730:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801733:	b8 0a 00 00 00       	mov    $0xa,%eax
  801738:	e9 c6 00 00 00       	jmp    801803 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80173d:	83 f9 01             	cmp    $0x1,%ecx
  801740:	7f 1e                	jg     801760 <vprintfmt+0x305>
	else if (lflag)
  801742:	85 c9                	test   %ecx,%ecx
  801744:	75 32                	jne    801778 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801746:	8b 45 14             	mov    0x14(%ebp),%eax
  801749:	8b 10                	mov    (%eax),%edx
  80174b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801750:	8d 40 04             	lea    0x4(%eax),%eax
  801753:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801756:	b8 0a 00 00 00       	mov    $0xa,%eax
  80175b:	e9 a3 00 00 00       	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 10                	mov    (%eax),%edx
  801765:	8b 48 04             	mov    0x4(%eax),%ecx
  801768:	8d 40 08             	lea    0x8(%eax),%eax
  80176b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80176e:	b8 0a 00 00 00       	mov    $0xa,%eax
  801773:	e9 8b 00 00 00       	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801778:	8b 45 14             	mov    0x14(%ebp),%eax
  80177b:	8b 10                	mov    (%eax),%edx
  80177d:	b9 00 00 00 00       	mov    $0x0,%ecx
  801782:	8d 40 04             	lea    0x4(%eax),%eax
  801785:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801788:	b8 0a 00 00 00       	mov    $0xa,%eax
  80178d:	eb 74                	jmp    801803 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80178f:	83 f9 01             	cmp    $0x1,%ecx
  801792:	7f 1b                	jg     8017af <vprintfmt+0x354>
	else if (lflag)
  801794:	85 c9                	test   %ecx,%ecx
  801796:	75 2c                	jne    8017c4 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801798:	8b 45 14             	mov    0x14(%ebp),%eax
  80179b:	8b 10                	mov    (%eax),%edx
  80179d:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017a2:	8d 40 04             	lea    0x4(%eax),%eax
  8017a5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8017a8:	b8 08 00 00 00       	mov    $0x8,%eax
  8017ad:	eb 54                	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  8017af:	8b 45 14             	mov    0x14(%ebp),%eax
  8017b2:	8b 10                	mov    (%eax),%edx
  8017b4:	8b 48 04             	mov    0x4(%eax),%ecx
  8017b7:	8d 40 08             	lea    0x8(%eax),%eax
  8017ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8017bd:	b8 08 00 00 00       	mov    $0x8,%eax
  8017c2:	eb 3f                	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8017c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8017c7:	8b 10                	mov    (%eax),%edx
  8017c9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8017ce:	8d 40 04             	lea    0x4(%eax),%eax
  8017d1:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8017d4:	b8 08 00 00 00       	mov    $0x8,%eax
  8017d9:	eb 28                	jmp    801803 <vprintfmt+0x3a8>
			putch('0', putdat);
  8017db:	83 ec 08             	sub    $0x8,%esp
  8017de:	53                   	push   %ebx
  8017df:	6a 30                	push   $0x30
  8017e1:	ff d6                	call   *%esi
			putch('x', putdat);
  8017e3:	83 c4 08             	add    $0x8,%esp
  8017e6:	53                   	push   %ebx
  8017e7:	6a 78                	push   $0x78
  8017e9:	ff d6                	call   *%esi
			num = (unsigned long long)
  8017eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017ee:	8b 10                	mov    (%eax),%edx
  8017f0:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8017f5:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8017f8:	8d 40 04             	lea    0x4(%eax),%eax
  8017fb:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8017fe:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  801803:	83 ec 0c             	sub    $0xc,%esp
  801806:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  80180a:	57                   	push   %edi
  80180b:	ff 75 e0             	pushl  -0x20(%ebp)
  80180e:	50                   	push   %eax
  80180f:	51                   	push   %ecx
  801810:	52                   	push   %edx
  801811:	89 da                	mov    %ebx,%edx
  801813:	89 f0                	mov    %esi,%eax
  801815:	e8 5b fb ff ff       	call   801375 <printnum>
			break;
  80181a:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80181d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  801820:	47                   	inc    %edi
  801821:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801825:	83 f8 25             	cmp    $0x25,%eax
  801828:	0f 84 44 fc ff ff    	je     801472 <vprintfmt+0x17>
			if (ch == '\0')
  80182e:	85 c0                	test   %eax,%eax
  801830:	0f 84 89 00 00 00    	je     8018bf <vprintfmt+0x464>
			putch(ch, putdat);
  801836:	83 ec 08             	sub    $0x8,%esp
  801839:	53                   	push   %ebx
  80183a:	50                   	push   %eax
  80183b:	ff d6                	call   *%esi
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	eb de                	jmp    801820 <vprintfmt+0x3c5>
	if (lflag >= 2)
  801842:	83 f9 01             	cmp    $0x1,%ecx
  801845:	7f 1b                	jg     801862 <vprintfmt+0x407>
	else if (lflag)
  801847:	85 c9                	test   %ecx,%ecx
  801849:	75 2c                	jne    801877 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80184b:	8b 45 14             	mov    0x14(%ebp),%eax
  80184e:	8b 10                	mov    (%eax),%edx
  801850:	b9 00 00 00 00       	mov    $0x0,%ecx
  801855:	8d 40 04             	lea    0x4(%eax),%eax
  801858:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80185b:	b8 10 00 00 00       	mov    $0x10,%eax
  801860:	eb a1                	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801862:	8b 45 14             	mov    0x14(%ebp),%eax
  801865:	8b 10                	mov    (%eax),%edx
  801867:	8b 48 04             	mov    0x4(%eax),%ecx
  80186a:	8d 40 08             	lea    0x8(%eax),%eax
  80186d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801870:	b8 10 00 00 00       	mov    $0x10,%eax
  801875:	eb 8c                	jmp    801803 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801877:	8b 45 14             	mov    0x14(%ebp),%eax
  80187a:	8b 10                	mov    (%eax),%edx
  80187c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801881:	8d 40 04             	lea    0x4(%eax),%eax
  801884:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801887:	b8 10 00 00 00       	mov    $0x10,%eax
  80188c:	e9 72 ff ff ff       	jmp    801803 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801891:	83 ec 08             	sub    $0x8,%esp
  801894:	53                   	push   %ebx
  801895:	6a 25                	push   $0x25
  801897:	ff d6                	call   *%esi
			break;
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	e9 7c ff ff ff       	jmp    80181d <vprintfmt+0x3c2>
			putch('%', putdat);
  8018a1:	83 ec 08             	sub    $0x8,%esp
  8018a4:	53                   	push   %ebx
  8018a5:	6a 25                	push   $0x25
  8018a7:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  8018a9:	83 c4 10             	add    $0x10,%esp
  8018ac:	89 f8                	mov    %edi,%eax
  8018ae:	eb 01                	jmp    8018b1 <vprintfmt+0x456>
  8018b0:	48                   	dec    %eax
  8018b1:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8018b5:	75 f9                	jne    8018b0 <vprintfmt+0x455>
  8018b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8018ba:	e9 5e ff ff ff       	jmp    80181d <vprintfmt+0x3c2>
}
  8018bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8018c2:	5b                   	pop    %ebx
  8018c3:	5e                   	pop    %esi
  8018c4:	5f                   	pop    %edi
  8018c5:	5d                   	pop    %ebp
  8018c6:	c3                   	ret    

008018c7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8018c7:	55                   	push   %ebp
  8018c8:	89 e5                	mov    %esp,%ebp
  8018ca:	83 ec 18             	sub    $0x18,%esp
  8018cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8018d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8018d6:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8018da:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8018dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	74 26                	je     80190e <vsnprintf+0x47>
  8018e8:	85 d2                	test   %edx,%edx
  8018ea:	7e 29                	jle    801915 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8018ec:	ff 75 14             	pushl  0x14(%ebp)
  8018ef:	ff 75 10             	pushl  0x10(%ebp)
  8018f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8018f5:	50                   	push   %eax
  8018f6:	68 22 14 80 00       	push   $0x801422
  8018fb:	e8 5b fb ff ff       	call   80145b <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  801900:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801903:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801909:	83 c4 10             	add    $0x10,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    
		return -E_INVAL;
  80190e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801913:	eb f7                	jmp    80190c <vsnprintf+0x45>
  801915:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80191a:	eb f0                	jmp    80190c <vsnprintf+0x45>

0080191c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80191c:	55                   	push   %ebp
  80191d:	89 e5                	mov    %esp,%ebp
  80191f:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801922:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801925:	50                   	push   %eax
  801926:	ff 75 10             	pushl  0x10(%ebp)
  801929:	ff 75 0c             	pushl  0xc(%ebp)
  80192c:	ff 75 08             	pushl  0x8(%ebp)
  80192f:	e8 93 ff ff ff       	call   8018c7 <vsnprintf>
	va_end(ap);

	return rc;
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80193c:	b8 00 00 00 00       	mov    $0x0,%eax
  801941:	eb 01                	jmp    801944 <strlen+0xe>
		n++;
  801943:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801944:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801948:	75 f9                	jne    801943 <strlen+0xd>
	return n;
}
  80194a:	5d                   	pop    %ebp
  80194b:	c3                   	ret    

0080194c <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801952:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801955:	b8 00 00 00 00       	mov    $0x0,%eax
  80195a:	eb 01                	jmp    80195d <strnlen+0x11>
		n++;
  80195c:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80195d:	39 d0                	cmp    %edx,%eax
  80195f:	74 06                	je     801967 <strnlen+0x1b>
  801961:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801965:	75 f5                	jne    80195c <strnlen+0x10>
	return n;
}
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	53                   	push   %ebx
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801973:	89 c2                	mov    %eax,%edx
  801975:	42                   	inc    %edx
  801976:	41                   	inc    %ecx
  801977:	8a 59 ff             	mov    -0x1(%ecx),%bl
  80197a:	88 5a ff             	mov    %bl,-0x1(%edx)
  80197d:	84 db                	test   %bl,%bl
  80197f:	75 f4                	jne    801975 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801981:	5b                   	pop    %ebx
  801982:	5d                   	pop    %ebp
  801983:	c3                   	ret    

00801984 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	53                   	push   %ebx
  801988:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80198b:	53                   	push   %ebx
  80198c:	e8 a5 ff ff ff       	call   801936 <strlen>
  801991:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801994:	ff 75 0c             	pushl  0xc(%ebp)
  801997:	01 d8                	add    %ebx,%eax
  801999:	50                   	push   %eax
  80199a:	e8 ca ff ff ff       	call   801969 <strcpy>
	return dst;
}
  80199f:	89 d8                	mov    %ebx,%eax
  8019a1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8019a4:	c9                   	leave  
  8019a5:	c3                   	ret    

008019a6 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  8019a6:	55                   	push   %ebp
  8019a7:	89 e5                	mov    %esp,%ebp
  8019a9:	56                   	push   %esi
  8019aa:	53                   	push   %ebx
  8019ab:	8b 75 08             	mov    0x8(%ebp),%esi
  8019ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8019b1:	89 f3                	mov    %esi,%ebx
  8019b3:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8019b6:	89 f2                	mov    %esi,%edx
  8019b8:	eb 0c                	jmp    8019c6 <strncpy+0x20>
		*dst++ = *src;
  8019ba:	42                   	inc    %edx
  8019bb:	8a 01                	mov    (%ecx),%al
  8019bd:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8019c0:	80 39 01             	cmpb   $0x1,(%ecx)
  8019c3:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8019c6:	39 da                	cmp    %ebx,%edx
  8019c8:	75 f0                	jne    8019ba <strncpy+0x14>
	}
	return ret;
}
  8019ca:	89 f0                	mov    %esi,%eax
  8019cc:	5b                   	pop    %ebx
  8019cd:	5e                   	pop    %esi
  8019ce:	5d                   	pop    %ebp
  8019cf:	c3                   	ret    

008019d0 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
  8019d3:	56                   	push   %esi
  8019d4:	53                   	push   %ebx
  8019d5:	8b 75 08             	mov    0x8(%ebp),%esi
  8019d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019db:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8019de:	85 c0                	test   %eax,%eax
  8019e0:	74 20                	je     801a02 <strlcpy+0x32>
  8019e2:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8019e6:	89 f0                	mov    %esi,%eax
  8019e8:	eb 05                	jmp    8019ef <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8019ea:	40                   	inc    %eax
  8019eb:	42                   	inc    %edx
  8019ec:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8019ef:	39 d8                	cmp    %ebx,%eax
  8019f1:	74 06                	je     8019f9 <strlcpy+0x29>
  8019f3:	8a 0a                	mov    (%edx),%cl
  8019f5:	84 c9                	test   %cl,%cl
  8019f7:	75 f1                	jne    8019ea <strlcpy+0x1a>
		*dst = '\0';
  8019f9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8019fc:	29 f0                	sub    %esi,%eax
}
  8019fe:	5b                   	pop    %ebx
  8019ff:	5e                   	pop    %esi
  801a00:	5d                   	pop    %ebp
  801a01:	c3                   	ret    
  801a02:	89 f0                	mov    %esi,%eax
  801a04:	eb f6                	jmp    8019fc <strlcpy+0x2c>

00801a06 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
  801a09:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801a0c:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  801a0f:	eb 02                	jmp    801a13 <strcmp+0xd>
		p++, q++;
  801a11:	41                   	inc    %ecx
  801a12:	42                   	inc    %edx
	while (*p && *p == *q)
  801a13:	8a 01                	mov    (%ecx),%al
  801a15:	84 c0                	test   %al,%al
  801a17:	74 04                	je     801a1d <strcmp+0x17>
  801a19:	3a 02                	cmp    (%edx),%al
  801a1b:	74 f4                	je     801a11 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801a1d:	0f b6 c0             	movzbl %al,%eax
  801a20:	0f b6 12             	movzbl (%edx),%edx
  801a23:	29 d0                	sub    %edx,%eax
}
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    

00801a27 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801a27:	55                   	push   %ebp
  801a28:	89 e5                	mov    %esp,%ebp
  801a2a:	53                   	push   %ebx
  801a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a31:	89 c3                	mov    %eax,%ebx
  801a33:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801a36:	eb 02                	jmp    801a3a <strncmp+0x13>
		n--, p++, q++;
  801a38:	40                   	inc    %eax
  801a39:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  801a3a:	39 d8                	cmp    %ebx,%eax
  801a3c:	74 15                	je     801a53 <strncmp+0x2c>
  801a3e:	8a 08                	mov    (%eax),%cl
  801a40:	84 c9                	test   %cl,%cl
  801a42:	74 04                	je     801a48 <strncmp+0x21>
  801a44:	3a 0a                	cmp    (%edx),%cl
  801a46:	74 f0                	je     801a38 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801a48:	0f b6 00             	movzbl (%eax),%eax
  801a4b:	0f b6 12             	movzbl (%edx),%edx
  801a4e:	29 d0                	sub    %edx,%eax
}
  801a50:	5b                   	pop    %ebx
  801a51:	5d                   	pop    %ebp
  801a52:	c3                   	ret    
		return 0;
  801a53:	b8 00 00 00 00       	mov    $0x0,%eax
  801a58:	eb f6                	jmp    801a50 <strncmp+0x29>

00801a5a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a60:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801a63:	8a 10                	mov    (%eax),%dl
  801a65:	84 d2                	test   %dl,%dl
  801a67:	74 07                	je     801a70 <strchr+0x16>
		if (*s == c)
  801a69:	38 ca                	cmp    %cl,%dl
  801a6b:	74 08                	je     801a75 <strchr+0x1b>
	for (; *s; s++)
  801a6d:	40                   	inc    %eax
  801a6e:	eb f3                	jmp    801a63 <strchr+0x9>
			return (char *) s;
	return 0;
  801a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a75:	5d                   	pop    %ebp
  801a76:	c3                   	ret    

00801a77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801a80:	8a 10                	mov    (%eax),%dl
  801a82:	84 d2                	test   %dl,%dl
  801a84:	74 07                	je     801a8d <strfind+0x16>
		if (*s == c)
  801a86:	38 ca                	cmp    %cl,%dl
  801a88:	74 03                	je     801a8d <strfind+0x16>
	for (; *s; s++)
  801a8a:	40                   	inc    %eax
  801a8b:	eb f3                	jmp    801a80 <strfind+0x9>
			break;
	return (char *) s;
}
  801a8d:	5d                   	pop    %ebp
  801a8e:	c3                   	ret    

00801a8f <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801a8f:	55                   	push   %ebp
  801a90:	89 e5                	mov    %esp,%ebp
  801a92:	57                   	push   %edi
  801a93:	56                   	push   %esi
  801a94:	53                   	push   %ebx
  801a95:	8b 7d 08             	mov    0x8(%ebp),%edi
  801a98:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801a9b:	85 c9                	test   %ecx,%ecx
  801a9d:	74 13                	je     801ab2 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801a9f:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801aa5:	75 05                	jne    801aac <memset+0x1d>
  801aa7:	f6 c1 03             	test   $0x3,%cl
  801aaa:	74 0d                	je     801ab9 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801aac:	8b 45 0c             	mov    0xc(%ebp),%eax
  801aaf:	fc                   	cld    
  801ab0:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801ab2:	89 f8                	mov    %edi,%eax
  801ab4:	5b                   	pop    %ebx
  801ab5:	5e                   	pop    %esi
  801ab6:	5f                   	pop    %edi
  801ab7:	5d                   	pop    %ebp
  801ab8:	c3                   	ret    
		c &= 0xFF;
  801ab9:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801abd:	89 d3                	mov    %edx,%ebx
  801abf:	c1 e3 08             	shl    $0x8,%ebx
  801ac2:	89 d0                	mov    %edx,%eax
  801ac4:	c1 e0 18             	shl    $0x18,%eax
  801ac7:	89 d6                	mov    %edx,%esi
  801ac9:	c1 e6 10             	shl    $0x10,%esi
  801acc:	09 f0                	or     %esi,%eax
  801ace:	09 c2                	or     %eax,%edx
  801ad0:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801ad2:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801ad5:	89 d0                	mov    %edx,%eax
  801ad7:	fc                   	cld    
  801ad8:	f3 ab                	rep stos %eax,%es:(%edi)
  801ada:	eb d6                	jmp    801ab2 <memset+0x23>

00801adc <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801adc:	55                   	push   %ebp
  801add:	89 e5                	mov    %esp,%ebp
  801adf:	57                   	push   %edi
  801ae0:	56                   	push   %esi
  801ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae4:	8b 75 0c             	mov    0xc(%ebp),%esi
  801ae7:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801aea:	39 c6                	cmp    %eax,%esi
  801aec:	73 33                	jae    801b21 <memmove+0x45>
  801aee:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  801af1:	39 d0                	cmp    %edx,%eax
  801af3:	73 2c                	jae    801b21 <memmove+0x45>
		s += n;
		d += n;
  801af5:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801af8:	89 d6                	mov    %edx,%esi
  801afa:	09 fe                	or     %edi,%esi
  801afc:	f7 c6 03 00 00 00    	test   $0x3,%esi
  801b02:	75 13                	jne    801b17 <memmove+0x3b>
  801b04:	f6 c1 03             	test   $0x3,%cl
  801b07:	75 0e                	jne    801b17 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  801b09:	83 ef 04             	sub    $0x4,%edi
  801b0c:	8d 72 fc             	lea    -0x4(%edx),%esi
  801b0f:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801b12:	fd                   	std    
  801b13:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b15:	eb 07                	jmp    801b1e <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801b17:	4f                   	dec    %edi
  801b18:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801b1b:	fd                   	std    
  801b1c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801b1e:	fc                   	cld    
  801b1f:	eb 13                	jmp    801b34 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801b21:	89 f2                	mov    %esi,%edx
  801b23:	09 c2                	or     %eax,%edx
  801b25:	f6 c2 03             	test   $0x3,%dl
  801b28:	75 05                	jne    801b2f <memmove+0x53>
  801b2a:	f6 c1 03             	test   $0x3,%cl
  801b2d:	74 09                	je     801b38 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801b2f:	89 c7                	mov    %eax,%edi
  801b31:	fc                   	cld    
  801b32:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801b34:	5e                   	pop    %esi
  801b35:	5f                   	pop    %edi
  801b36:	5d                   	pop    %ebp
  801b37:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801b38:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801b3b:	89 c7                	mov    %eax,%edi
  801b3d:	fc                   	cld    
  801b3e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801b40:	eb f2                	jmp    801b34 <memmove+0x58>

00801b42 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801b45:	ff 75 10             	pushl  0x10(%ebp)
  801b48:	ff 75 0c             	pushl  0xc(%ebp)
  801b4b:	ff 75 08             	pushl  0x8(%ebp)
  801b4e:	e8 89 ff ff ff       	call   801adc <memmove>
}
  801b53:	c9                   	leave  
  801b54:	c3                   	ret    

00801b55 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801b55:	55                   	push   %ebp
  801b56:	89 e5                	mov    %esp,%ebp
  801b58:	56                   	push   %esi
  801b59:	53                   	push   %ebx
  801b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5d:	89 c6                	mov    %eax,%esi
  801b5f:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801b65:	39 f0                	cmp    %esi,%eax
  801b67:	74 16                	je     801b7f <memcmp+0x2a>
		if (*s1 != *s2)
  801b69:	8a 08                	mov    (%eax),%cl
  801b6b:	8a 1a                	mov    (%edx),%bl
  801b6d:	38 d9                	cmp    %bl,%cl
  801b6f:	75 04                	jne    801b75 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801b71:	40                   	inc    %eax
  801b72:	42                   	inc    %edx
  801b73:	eb f0                	jmp    801b65 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801b75:	0f b6 c1             	movzbl %cl,%eax
  801b78:	0f b6 db             	movzbl %bl,%ebx
  801b7b:	29 d8                	sub    %ebx,%eax
  801b7d:	eb 05                	jmp    801b84 <memcmp+0x2f>
	}

	return 0;
  801b7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b84:	5b                   	pop    %ebx
  801b85:	5e                   	pop    %esi
  801b86:	5d                   	pop    %ebp
  801b87:	c3                   	ret    

00801b88 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
  801b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801b91:	89 c2                	mov    %eax,%edx
  801b93:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801b96:	39 d0                	cmp    %edx,%eax
  801b98:	73 07                	jae    801ba1 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801b9a:	38 08                	cmp    %cl,(%eax)
  801b9c:	74 03                	je     801ba1 <memfind+0x19>
	for (; s < ends; s++)
  801b9e:	40                   	inc    %eax
  801b9f:	eb f5                	jmp    801b96 <memfind+0xe>
			break;
	return (void *) s;
}
  801ba1:	5d                   	pop    %ebp
  801ba2:	c3                   	ret    

00801ba3 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
  801ba6:	57                   	push   %edi
  801ba7:	56                   	push   %esi
  801ba8:	53                   	push   %ebx
  801ba9:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801bac:	eb 01                	jmp    801baf <strtol+0xc>
		s++;
  801bae:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801baf:	8a 01                	mov    (%ecx),%al
  801bb1:	3c 20                	cmp    $0x20,%al
  801bb3:	74 f9                	je     801bae <strtol+0xb>
  801bb5:	3c 09                	cmp    $0x9,%al
  801bb7:	74 f5                	je     801bae <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801bb9:	3c 2b                	cmp    $0x2b,%al
  801bbb:	74 2b                	je     801be8 <strtol+0x45>
		s++;
	else if (*s == '-')
  801bbd:	3c 2d                	cmp    $0x2d,%al
  801bbf:	74 2f                	je     801bf0 <strtol+0x4d>
	int neg = 0;
  801bc1:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801bc6:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801bcd:	75 12                	jne    801be1 <strtol+0x3e>
  801bcf:	80 39 30             	cmpb   $0x30,(%ecx)
  801bd2:	74 24                	je     801bf8 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801bd4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801bd8:	75 07                	jne    801be1 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801bda:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801be1:	b8 00 00 00 00       	mov    $0x0,%eax
  801be6:	eb 4e                	jmp    801c36 <strtol+0x93>
		s++;
  801be8:	41                   	inc    %ecx
	int neg = 0;
  801be9:	bf 00 00 00 00       	mov    $0x0,%edi
  801bee:	eb d6                	jmp    801bc6 <strtol+0x23>
		s++, neg = 1;
  801bf0:	41                   	inc    %ecx
  801bf1:	bf 01 00 00 00       	mov    $0x1,%edi
  801bf6:	eb ce                	jmp    801bc6 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801bf8:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801bfc:	74 10                	je     801c0e <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801bfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801c02:	75 dd                	jne    801be1 <strtol+0x3e>
		s++, base = 8;
  801c04:	41                   	inc    %ecx
  801c05:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801c0c:	eb d3                	jmp    801be1 <strtol+0x3e>
		s += 2, base = 16;
  801c0e:	83 c1 02             	add    $0x2,%ecx
  801c11:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801c18:	eb c7                	jmp    801be1 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801c1a:	8d 72 9f             	lea    -0x61(%edx),%esi
  801c1d:	89 f3                	mov    %esi,%ebx
  801c1f:	80 fb 19             	cmp    $0x19,%bl
  801c22:	77 24                	ja     801c48 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801c24:	0f be d2             	movsbl %dl,%edx
  801c27:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801c2a:	3b 55 10             	cmp    0x10(%ebp),%edx
  801c2d:	7d 2b                	jge    801c5a <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801c2f:	41                   	inc    %ecx
  801c30:	0f af 45 10          	imul   0x10(%ebp),%eax
  801c34:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801c36:	8a 11                	mov    (%ecx),%dl
  801c38:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801c3b:	80 fb 09             	cmp    $0x9,%bl
  801c3e:	77 da                	ja     801c1a <strtol+0x77>
			dig = *s - '0';
  801c40:	0f be d2             	movsbl %dl,%edx
  801c43:	83 ea 30             	sub    $0x30,%edx
  801c46:	eb e2                	jmp    801c2a <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801c48:	8d 72 bf             	lea    -0x41(%edx),%esi
  801c4b:	89 f3                	mov    %esi,%ebx
  801c4d:	80 fb 19             	cmp    $0x19,%bl
  801c50:	77 08                	ja     801c5a <strtol+0xb7>
			dig = *s - 'A' + 10;
  801c52:	0f be d2             	movsbl %dl,%edx
  801c55:	83 ea 37             	sub    $0x37,%edx
  801c58:	eb d0                	jmp    801c2a <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801c5e:	74 05                	je     801c65 <strtol+0xc2>
		*endptr = (char *) s;
  801c60:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c63:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801c65:	85 ff                	test   %edi,%edi
  801c67:	74 02                	je     801c6b <strtol+0xc8>
  801c69:	f7 d8                	neg    %eax
}
  801c6b:	5b                   	pop    %ebx
  801c6c:	5e                   	pop    %esi
  801c6d:	5f                   	pop    %edi
  801c6e:	5d                   	pop    %ebp
  801c6f:	c3                   	ret    

00801c70 <atoi>:

int
atoi(const char *s)
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801c73:	6a 0a                	push   $0xa
  801c75:	6a 00                	push   $0x0
  801c77:	ff 75 08             	pushl  0x8(%ebp)
  801c7a:	e8 24 ff ff ff       	call   801ba3 <strtol>
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
  801c84:	57                   	push   %edi
  801c85:	56                   	push   %esi
  801c86:	53                   	push   %ebx
  801c87:	83 ec 0c             	sub    $0xc,%esp
  801c8a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801c8d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801c90:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801c93:	85 ff                	test   %edi,%edi
  801c95:	74 53                	je     801cea <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801c97:	83 ec 0c             	sub    $0xc,%esp
  801c9a:	57                   	push   %edi
  801c9b:	e8 eb e6 ff ff       	call   80038b <sys_ipc_recv>
  801ca0:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801ca3:	85 db                	test   %ebx,%ebx
  801ca5:	74 0b                	je     801cb2 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801ca7:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cad:	8b 52 74             	mov    0x74(%edx),%edx
  801cb0:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801cb2:	85 f6                	test   %esi,%esi
  801cb4:	74 0f                	je     801cc5 <ipc_recv+0x44>
  801cb6:	85 ff                	test   %edi,%edi
  801cb8:	74 0b                	je     801cc5 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801cba:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801cc0:	8b 52 78             	mov    0x78(%edx),%edx
  801cc3:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801cc5:	85 c0                	test   %eax,%eax
  801cc7:	74 30                	je     801cf9 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801cc9:	85 db                	test   %ebx,%ebx
  801ccb:	74 06                	je     801cd3 <ipc_recv+0x52>
      		*from_env_store = 0;
  801ccd:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801cd3:	85 f6                	test   %esi,%esi
  801cd5:	74 2c                	je     801d03 <ipc_recv+0x82>
      		*perm_store = 0;
  801cd7:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801cdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801ce2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ce5:	5b                   	pop    %ebx
  801ce6:	5e                   	pop    %esi
  801ce7:	5f                   	pop    %edi
  801ce8:	5d                   	pop    %ebp
  801ce9:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801cea:	83 ec 0c             	sub    $0xc,%esp
  801ced:	6a ff                	push   $0xffffffff
  801cef:	e8 97 e6 ff ff       	call   80038b <sys_ipc_recv>
  801cf4:	83 c4 10             	add    $0x10,%esp
  801cf7:	eb aa                	jmp    801ca3 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801cf9:	a1 04 40 80 00       	mov    0x804004,%eax
  801cfe:	8b 40 70             	mov    0x70(%eax),%eax
  801d01:	eb df                	jmp    801ce2 <ipc_recv+0x61>
		return -1;
  801d03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801d08:	eb d8                	jmp    801ce2 <ipc_recv+0x61>

00801d0a <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	57                   	push   %edi
  801d0e:	56                   	push   %esi
  801d0f:	53                   	push   %ebx
  801d10:	83 ec 0c             	sub    $0xc,%esp
  801d13:	8b 75 0c             	mov    0xc(%ebp),%esi
  801d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801d19:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801d1c:	85 db                	test   %ebx,%ebx
  801d1e:	75 22                	jne    801d42 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801d20:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801d25:	eb 1b                	jmp    801d42 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801d27:	68 00 25 80 00       	push   $0x802500
  801d2c:	68 7f 21 80 00       	push   $0x80217f
  801d31:	6a 48                	push   $0x48
  801d33:	68 24 25 80 00       	push   $0x802524
  801d38:	e8 11 f5 ff ff       	call   80124e <_panic>
		sys_yield();
  801d3d:	e8 00 e5 ff ff       	call   800242 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801d42:	57                   	push   %edi
  801d43:	53                   	push   %ebx
  801d44:	56                   	push   %esi
  801d45:	ff 75 08             	pushl  0x8(%ebp)
  801d48:	e8 1b e6 ff ff       	call   800368 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801d4d:	83 c4 10             	add    $0x10,%esp
  801d50:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801d53:	74 e8                	je     801d3d <ipc_send+0x33>
  801d55:	85 c0                	test   %eax,%eax
  801d57:	75 ce                	jne    801d27 <ipc_send+0x1d>
		sys_yield();
  801d59:	e8 e4 e4 ff ff       	call   800242 <sys_yield>
		
	}
	
}
  801d5e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801d61:	5b                   	pop    %ebx
  801d62:	5e                   	pop    %esi
  801d63:	5f                   	pop    %edi
  801d64:	5d                   	pop    %ebp
  801d65:	c3                   	ret    

00801d66 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801d6c:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801d71:	89 c2                	mov    %eax,%edx
  801d73:	c1 e2 05             	shl    $0x5,%edx
  801d76:	29 c2                	sub    %eax,%edx
  801d78:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801d7f:	8b 52 50             	mov    0x50(%edx),%edx
  801d82:	39 ca                	cmp    %ecx,%edx
  801d84:	74 0f                	je     801d95 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801d86:	40                   	inc    %eax
  801d87:	3d 00 04 00 00       	cmp    $0x400,%eax
  801d8c:	75 e3                	jne    801d71 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801d8e:	b8 00 00 00 00       	mov    $0x0,%eax
  801d93:	eb 11                	jmp    801da6 <ipc_find_env+0x40>
			return envs[i].env_id;
  801d95:	89 c2                	mov    %eax,%edx
  801d97:	c1 e2 05             	shl    $0x5,%edx
  801d9a:	29 c2                	sub    %eax,%edx
  801d9c:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801da3:	8b 40 48             	mov    0x48(%eax),%eax
}
  801da6:	5d                   	pop    %ebp
  801da7:	c3                   	ret    

00801da8 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	c1 e8 16             	shr    $0x16,%eax
  801db1:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801db8:	a8 01                	test   $0x1,%al
  801dba:	74 21                	je     801ddd <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbf:	c1 e8 0c             	shr    $0xc,%eax
  801dc2:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801dc9:	a8 01                	test   $0x1,%al
  801dcb:	74 17                	je     801de4 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801dcd:	c1 e8 0c             	shr    $0xc,%eax
  801dd0:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801dd7:	ef 
  801dd8:	0f b7 c0             	movzwl %ax,%eax
  801ddb:	eb 05                	jmp    801de2 <pageref+0x3a>
		return 0;
  801ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de2:	5d                   	pop    %ebp
  801de3:	c3                   	ret    
		return 0;
  801de4:	b8 00 00 00 00       	mov    $0x0,%eax
  801de9:	eb f7                	jmp    801de2 <pageref+0x3a>
  801deb:	90                   	nop

00801dec <__udivdi3>:
  801dec:	55                   	push   %ebp
  801ded:	57                   	push   %edi
  801dee:	56                   	push   %esi
  801def:	53                   	push   %ebx
  801df0:	83 ec 1c             	sub    $0x1c,%esp
  801df3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801df7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801dfb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dff:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801e03:	89 ca                	mov    %ecx,%edx
  801e05:	89 f8                	mov    %edi,%eax
  801e07:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801e0b:	85 f6                	test   %esi,%esi
  801e0d:	75 2d                	jne    801e3c <__udivdi3+0x50>
  801e0f:	39 cf                	cmp    %ecx,%edi
  801e11:	77 65                	ja     801e78 <__udivdi3+0x8c>
  801e13:	89 fd                	mov    %edi,%ebp
  801e15:	85 ff                	test   %edi,%edi
  801e17:	75 0b                	jne    801e24 <__udivdi3+0x38>
  801e19:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1e:	31 d2                	xor    %edx,%edx
  801e20:	f7 f7                	div    %edi
  801e22:	89 c5                	mov    %eax,%ebp
  801e24:	31 d2                	xor    %edx,%edx
  801e26:	89 c8                	mov    %ecx,%eax
  801e28:	f7 f5                	div    %ebp
  801e2a:	89 c1                	mov    %eax,%ecx
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	f7 f5                	div    %ebp
  801e30:	89 cf                	mov    %ecx,%edi
  801e32:	89 fa                	mov    %edi,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	39 ce                	cmp    %ecx,%esi
  801e3e:	77 28                	ja     801e68 <__udivdi3+0x7c>
  801e40:	0f bd fe             	bsr    %esi,%edi
  801e43:	83 f7 1f             	xor    $0x1f,%edi
  801e46:	75 40                	jne    801e88 <__udivdi3+0x9c>
  801e48:	39 ce                	cmp    %ecx,%esi
  801e4a:	72 0a                	jb     801e56 <__udivdi3+0x6a>
  801e4c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801e50:	0f 87 9e 00 00 00    	ja     801ef4 <__udivdi3+0x108>
  801e56:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5b:	89 fa                	mov    %edi,%edx
  801e5d:	83 c4 1c             	add    $0x1c,%esp
  801e60:	5b                   	pop    %ebx
  801e61:	5e                   	pop    %esi
  801e62:	5f                   	pop    %edi
  801e63:	5d                   	pop    %ebp
  801e64:	c3                   	ret    
  801e65:	8d 76 00             	lea    0x0(%esi),%esi
  801e68:	31 ff                	xor    %edi,%edi
  801e6a:	31 c0                	xor    %eax,%eax
  801e6c:	89 fa                	mov    %edi,%edx
  801e6e:	83 c4 1c             	add    $0x1c,%esp
  801e71:	5b                   	pop    %ebx
  801e72:	5e                   	pop    %esi
  801e73:	5f                   	pop    %edi
  801e74:	5d                   	pop    %ebp
  801e75:	c3                   	ret    
  801e76:	66 90                	xchg   %ax,%ax
  801e78:	89 d8                	mov    %ebx,%eax
  801e7a:	f7 f7                	div    %edi
  801e7c:	31 ff                	xor    %edi,%edi
  801e7e:	89 fa                	mov    %edi,%edx
  801e80:	83 c4 1c             	add    $0x1c,%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5f                   	pop    %edi
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    
  801e88:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e8d:	29 fd                	sub    %edi,%ebp
  801e8f:	89 f9                	mov    %edi,%ecx
  801e91:	d3 e6                	shl    %cl,%esi
  801e93:	89 c3                	mov    %eax,%ebx
  801e95:	89 e9                	mov    %ebp,%ecx
  801e97:	d3 eb                	shr    %cl,%ebx
  801e99:	89 d9                	mov    %ebx,%ecx
  801e9b:	09 f1                	or     %esi,%ecx
  801e9d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ea1:	89 f9                	mov    %edi,%ecx
  801ea3:	d3 e0                	shl    %cl,%eax
  801ea5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ea9:	89 d6                	mov    %edx,%esi
  801eab:	89 e9                	mov    %ebp,%ecx
  801ead:	d3 ee                	shr    %cl,%esi
  801eaf:	89 f9                	mov    %edi,%ecx
  801eb1:	d3 e2                	shl    %cl,%edx
  801eb3:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801eb7:	89 e9                	mov    %ebp,%ecx
  801eb9:	d3 eb                	shr    %cl,%ebx
  801ebb:	09 da                	or     %ebx,%edx
  801ebd:	89 d0                	mov    %edx,%eax
  801ebf:	89 f2                	mov    %esi,%edx
  801ec1:	f7 74 24 08          	divl   0x8(%esp)
  801ec5:	89 d6                	mov    %edx,%esi
  801ec7:	89 c3                	mov    %eax,%ebx
  801ec9:	f7 64 24 0c          	mull   0xc(%esp)
  801ecd:	39 d6                	cmp    %edx,%esi
  801ecf:	72 17                	jb     801ee8 <__udivdi3+0xfc>
  801ed1:	74 09                	je     801edc <__udivdi3+0xf0>
  801ed3:	89 d8                	mov    %ebx,%eax
  801ed5:	31 ff                	xor    %edi,%edi
  801ed7:	e9 56 ff ff ff       	jmp    801e32 <__udivdi3+0x46>
  801edc:	8b 54 24 04          	mov    0x4(%esp),%edx
  801ee0:	89 f9                	mov    %edi,%ecx
  801ee2:	d3 e2                	shl    %cl,%edx
  801ee4:	39 c2                	cmp    %eax,%edx
  801ee6:	73 eb                	jae    801ed3 <__udivdi3+0xe7>
  801ee8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801eeb:	31 ff                	xor    %edi,%edi
  801eed:	e9 40 ff ff ff       	jmp    801e32 <__udivdi3+0x46>
  801ef2:	66 90                	xchg   %ax,%ax
  801ef4:	31 c0                	xor    %eax,%eax
  801ef6:	e9 37 ff ff ff       	jmp    801e32 <__udivdi3+0x46>
  801efb:	90                   	nop

00801efc <__umoddi3>:
  801efc:	55                   	push   %ebp
  801efd:	57                   	push   %edi
  801efe:	56                   	push   %esi
  801eff:	53                   	push   %ebx
  801f00:	83 ec 1c             	sub    $0x1c,%esp
  801f03:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801f07:	8b 74 24 34          	mov    0x34(%esp),%esi
  801f0b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801f0f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801f13:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801f17:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801f1b:	89 3c 24             	mov    %edi,(%esp)
  801f1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f22:	89 f2                	mov    %esi,%edx
  801f24:	85 c0                	test   %eax,%eax
  801f26:	75 18                	jne    801f40 <__umoddi3+0x44>
  801f28:	39 f7                	cmp    %esi,%edi
  801f2a:	0f 86 a0 00 00 00    	jbe    801fd0 <__umoddi3+0xd4>
  801f30:	89 c8                	mov    %ecx,%eax
  801f32:	f7 f7                	div    %edi
  801f34:	89 d0                	mov    %edx,%eax
  801f36:	31 d2                	xor    %edx,%edx
  801f38:	83 c4 1c             	add    $0x1c,%esp
  801f3b:	5b                   	pop    %ebx
  801f3c:	5e                   	pop    %esi
  801f3d:	5f                   	pop    %edi
  801f3e:	5d                   	pop    %ebp
  801f3f:	c3                   	ret    
  801f40:	89 f3                	mov    %esi,%ebx
  801f42:	39 f0                	cmp    %esi,%eax
  801f44:	0f 87 a6 00 00 00    	ja     801ff0 <__umoddi3+0xf4>
  801f4a:	0f bd e8             	bsr    %eax,%ebp
  801f4d:	83 f5 1f             	xor    $0x1f,%ebp
  801f50:	0f 84 a6 00 00 00    	je     801ffc <__umoddi3+0x100>
  801f56:	bf 20 00 00 00       	mov    $0x20,%edi
  801f5b:	29 ef                	sub    %ebp,%edi
  801f5d:	89 e9                	mov    %ebp,%ecx
  801f5f:	d3 e0                	shl    %cl,%eax
  801f61:	8b 34 24             	mov    (%esp),%esi
  801f64:	89 f2                	mov    %esi,%edx
  801f66:	89 f9                	mov    %edi,%ecx
  801f68:	d3 ea                	shr    %cl,%edx
  801f6a:	09 c2                	or     %eax,%edx
  801f6c:	89 14 24             	mov    %edx,(%esp)
  801f6f:	89 f2                	mov    %esi,%edx
  801f71:	89 e9                	mov    %ebp,%ecx
  801f73:	d3 e2                	shl    %cl,%edx
  801f75:	89 54 24 04          	mov    %edx,0x4(%esp)
  801f79:	89 de                	mov    %ebx,%esi
  801f7b:	89 f9                	mov    %edi,%ecx
  801f7d:	d3 ee                	shr    %cl,%esi
  801f7f:	89 e9                	mov    %ebp,%ecx
  801f81:	d3 e3                	shl    %cl,%ebx
  801f83:	8b 54 24 08          	mov    0x8(%esp),%edx
  801f87:	89 d0                	mov    %edx,%eax
  801f89:	89 f9                	mov    %edi,%ecx
  801f8b:	d3 e8                	shr    %cl,%eax
  801f8d:	09 d8                	or     %ebx,%eax
  801f8f:	89 d3                	mov    %edx,%ebx
  801f91:	89 e9                	mov    %ebp,%ecx
  801f93:	d3 e3                	shl    %cl,%ebx
  801f95:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801f99:	89 f2                	mov    %esi,%edx
  801f9b:	f7 34 24             	divl   (%esp)
  801f9e:	89 d6                	mov    %edx,%esi
  801fa0:	f7 64 24 04          	mull   0x4(%esp)
  801fa4:	89 c3                	mov    %eax,%ebx
  801fa6:	89 d1                	mov    %edx,%ecx
  801fa8:	39 d6                	cmp    %edx,%esi
  801faa:	72 7c                	jb     802028 <__umoddi3+0x12c>
  801fac:	74 72                	je     802020 <__umoddi3+0x124>
  801fae:	8b 54 24 08          	mov    0x8(%esp),%edx
  801fb2:	29 da                	sub    %ebx,%edx
  801fb4:	19 ce                	sbb    %ecx,%esi
  801fb6:	89 f0                	mov    %esi,%eax
  801fb8:	89 f9                	mov    %edi,%ecx
  801fba:	d3 e0                	shl    %cl,%eax
  801fbc:	89 e9                	mov    %ebp,%ecx
  801fbe:	d3 ea                	shr    %cl,%edx
  801fc0:	09 d0                	or     %edx,%eax
  801fc2:	89 e9                	mov    %ebp,%ecx
  801fc4:	d3 ee                	shr    %cl,%esi
  801fc6:	89 f2                	mov    %esi,%edx
  801fc8:	83 c4 1c             	add    $0x1c,%esp
  801fcb:	5b                   	pop    %ebx
  801fcc:	5e                   	pop    %esi
  801fcd:	5f                   	pop    %edi
  801fce:	5d                   	pop    %ebp
  801fcf:	c3                   	ret    
  801fd0:	89 fd                	mov    %edi,%ebp
  801fd2:	85 ff                	test   %edi,%edi
  801fd4:	75 0b                	jne    801fe1 <__umoddi3+0xe5>
  801fd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801fdb:	31 d2                	xor    %edx,%edx
  801fdd:	f7 f7                	div    %edi
  801fdf:	89 c5                	mov    %eax,%ebp
  801fe1:	89 f0                	mov    %esi,%eax
  801fe3:	31 d2                	xor    %edx,%edx
  801fe5:	f7 f5                	div    %ebp
  801fe7:	89 c8                	mov    %ecx,%eax
  801fe9:	f7 f5                	div    %ebp
  801feb:	e9 44 ff ff ff       	jmp    801f34 <__umoddi3+0x38>
  801ff0:	89 c8                	mov    %ecx,%eax
  801ff2:	89 f2                	mov    %esi,%edx
  801ff4:	83 c4 1c             	add    $0x1c,%esp
  801ff7:	5b                   	pop    %ebx
  801ff8:	5e                   	pop    %esi
  801ff9:	5f                   	pop    %edi
  801ffa:	5d                   	pop    %ebp
  801ffb:	c3                   	ret    
  801ffc:	39 f0                	cmp    %esi,%eax
  801ffe:	72 05                	jb     802005 <__umoddi3+0x109>
  802000:	39 0c 24             	cmp    %ecx,(%esp)
  802003:	77 0c                	ja     802011 <__umoddi3+0x115>
  802005:	89 f2                	mov    %esi,%edx
  802007:	29 f9                	sub    %edi,%ecx
  802009:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80200d:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  802011:	8b 44 24 04          	mov    0x4(%esp),%eax
  802015:	83 c4 1c             	add    $0x1c,%esp
  802018:	5b                   	pop    %ebx
  802019:	5e                   	pop    %esi
  80201a:	5f                   	pop    %edi
  80201b:	5d                   	pop    %ebp
  80201c:	c3                   	ret    
  80201d:	8d 76 00             	lea    0x0(%esi),%esi
  802020:	39 44 24 08          	cmp    %eax,0x8(%esp)
  802024:	73 88                	jae    801fae <__umoddi3+0xb2>
  802026:	66 90                	xchg   %ax,%ax
  802028:	2b 44 24 04          	sub    0x4(%esp),%eax
  80202c:	1b 14 24             	sbb    (%esp),%edx
  80202f:	89 d1                	mov    %edx,%ecx
  802031:	89 c3                	mov    %eax,%ebx
  802033:	e9 76 ff ff ff       	jmp    801fae <__umoddi3+0xb2>
