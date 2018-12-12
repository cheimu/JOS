
obj/user/faultnostack.debug:     file format elf32-i386


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
  80002c:	e8 23 00 00 00       	call   800054 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

void _pgfault_upcall();

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 10             	sub    $0x10,%esp
	sys_env_set_pgfault_upcall(0, (void*) _pgfault_upcall);
  800039:	68 0c 04 80 00       	push   $0x80040c
  80003e:	6a 00                	push   $0x0
  800040:	e8 bd 02 00 00       	call   800302 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800045:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80004c:	00 00 00 
}
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	c9                   	leave  
  800053:	c3                   	ret    

00800054 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800054:	55                   	push   %ebp
  800055:	89 e5                	mov    %esp,%ebp
  800057:	56                   	push   %esi
  800058:	53                   	push   %ebx
  800059:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80005c:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80005f:	e8 d4 00 00 00       	call   800138 <sys_getenvid>
  800064:	25 ff 03 00 00       	and    $0x3ff,%eax
  800069:	89 c2                	mov    %eax,%edx
  80006b:	c1 e2 05             	shl    $0x5,%edx
  80006e:	29 c2                	sub    %eax,%edx
  800070:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800077:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80007c:	85 db                	test   %ebx,%ebx
  80007e:	7e 07                	jle    800087 <libmain+0x33>
		binaryname = argv[0];
  800080:	8b 06                	mov    (%esi),%eax
  800082:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800087:	83 ec 08             	sub    $0x8,%esp
  80008a:	56                   	push   %esi
  80008b:	53                   	push   %ebx
  80008c:	e8 a2 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800091:	e8 0a 00 00 00       	call   8000a0 <exit>
}
  800096:	83 c4 10             	add    $0x10,%esp
  800099:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80009c:	5b                   	pop    %ebx
  80009d:	5e                   	pop    %esi
  80009e:	5d                   	pop    %ebp
  80009f:	c3                   	ret    

008000a0 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000a0:	55                   	push   %ebp
  8000a1:	89 e5                	mov    %esp,%ebp
  8000a3:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000a6:	e8 5b 05 00 00       	call   800606 <close_all>
	sys_env_destroy(0);
  8000ab:	83 ec 0c             	sub    $0xc,%esp
  8000ae:	6a 00                	push   $0x0
  8000b0:	e8 42 00 00 00       	call   8000f7 <sys_env_destroy>
}
  8000b5:	83 c4 10             	add    $0x10,%esp
  8000b8:	c9                   	leave  
  8000b9:	c3                   	ret    

008000ba <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000ba:	55                   	push   %ebp
  8000bb:	89 e5                	mov    %esp,%ebp
  8000bd:	57                   	push   %edi
  8000be:	56                   	push   %esi
  8000bf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000cb:	89 c3                	mov    %eax,%ebx
  8000cd:	89 c7                	mov    %eax,%edi
  8000cf:	89 c6                	mov    %eax,%esi
  8000d1:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000d3:	5b                   	pop    %ebx
  8000d4:	5e                   	pop    %esi
  8000d5:	5f                   	pop    %edi
  8000d6:	5d                   	pop    %ebp
  8000d7:	c3                   	ret    

008000d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000d8:	55                   	push   %ebp
  8000d9:	89 e5                	mov    %esp,%ebp
  8000db:	57                   	push   %edi
  8000dc:	56                   	push   %esi
  8000dd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000de:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e3:	b8 01 00 00 00       	mov    $0x1,%eax
  8000e8:	89 d1                	mov    %edx,%ecx
  8000ea:	89 d3                	mov    %edx,%ebx
  8000ec:	89 d7                	mov    %edx,%edi
  8000ee:	89 d6                	mov    %edx,%esi
  8000f0:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000f2:	5b                   	pop    %ebx
  8000f3:	5e                   	pop    %esi
  8000f4:	5f                   	pop    %edi
  8000f5:	5d                   	pop    %ebp
  8000f6:	c3                   	ret    

008000f7 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000f7:	55                   	push   %ebp
  8000f8:	89 e5                	mov    %esp,%ebp
  8000fa:	57                   	push   %edi
  8000fb:	56                   	push   %esi
  8000fc:	53                   	push   %ebx
  8000fd:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800100:	b9 00 00 00 00       	mov    $0x0,%ecx
  800105:	b8 03 00 00 00       	mov    $0x3,%eax
  80010a:	8b 55 08             	mov    0x8(%ebp),%edx
  80010d:	89 cb                	mov    %ecx,%ebx
  80010f:	89 cf                	mov    %ecx,%edi
  800111:	89 ce                	mov    %ecx,%esi
  800113:	cd 30                	int    $0x30
	if(check && ret > 0)
  800115:	85 c0                	test   %eax,%eax
  800117:	7f 08                	jg     800121 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800119:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80011c:	5b                   	pop    %ebx
  80011d:	5e                   	pop    %esi
  80011e:	5f                   	pop    %edi
  80011f:	5d                   	pop    %ebp
  800120:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800121:	83 ec 0c             	sub    $0xc,%esp
  800124:	50                   	push   %eax
  800125:	6a 03                	push   $0x3
  800127:	68 8a 1f 80 00       	push   $0x801f8a
  80012c:	6a 23                	push   $0x23
  80012e:	68 a7 1f 80 00       	push   $0x801fa7
  800133:	e8 05 10 00 00       	call   80113d <_panic>

00800138 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800138:	55                   	push   %ebp
  800139:	89 e5                	mov    %esp,%ebp
  80013b:	57                   	push   %edi
  80013c:	56                   	push   %esi
  80013d:	53                   	push   %ebx
	asm volatile("int %1\n"
  80013e:	ba 00 00 00 00       	mov    $0x0,%edx
  800143:	b8 02 00 00 00       	mov    $0x2,%eax
  800148:	89 d1                	mov    %edx,%ecx
  80014a:	89 d3                	mov    %edx,%ebx
  80014c:	89 d7                	mov    %edx,%edi
  80014e:	89 d6                	mov    %edx,%esi
  800150:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800152:	5b                   	pop    %ebx
  800153:	5e                   	pop    %esi
  800154:	5f                   	pop    %edi
  800155:	5d                   	pop    %ebp
  800156:	c3                   	ret    

00800157 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800157:	55                   	push   %ebp
  800158:	89 e5                	mov    %esp,%ebp
  80015a:	57                   	push   %edi
  80015b:	56                   	push   %esi
  80015c:	53                   	push   %ebx
  80015d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800160:	be 00 00 00 00       	mov    $0x0,%esi
  800165:	b8 04 00 00 00       	mov    $0x4,%eax
  80016a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80016d:	8b 55 08             	mov    0x8(%ebp),%edx
  800170:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800173:	89 f7                	mov    %esi,%edi
  800175:	cd 30                	int    $0x30
	if(check && ret > 0)
  800177:	85 c0                	test   %eax,%eax
  800179:	7f 08                	jg     800183 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80017b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80017e:	5b                   	pop    %ebx
  80017f:	5e                   	pop    %esi
  800180:	5f                   	pop    %edi
  800181:	5d                   	pop    %ebp
  800182:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800183:	83 ec 0c             	sub    $0xc,%esp
  800186:	50                   	push   %eax
  800187:	6a 04                	push   $0x4
  800189:	68 8a 1f 80 00       	push   $0x801f8a
  80018e:	6a 23                	push   $0x23
  800190:	68 a7 1f 80 00       	push   $0x801fa7
  800195:	e8 a3 0f 00 00       	call   80113d <_panic>

0080019a <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80019a:	55                   	push   %ebp
  80019b:	89 e5                	mov    %esp,%ebp
  80019d:	57                   	push   %edi
  80019e:	56                   	push   %esi
  80019f:	53                   	push   %ebx
  8001a0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001a3:	b8 05 00 00 00       	mov    $0x5,%eax
  8001a8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8001ae:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001b1:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001b4:	8b 75 18             	mov    0x18(%ebp),%esi
  8001b7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001b9:	85 c0                	test   %eax,%eax
  8001bb:	7f 08                	jg     8001c5 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001c0:	5b                   	pop    %ebx
  8001c1:	5e                   	pop    %esi
  8001c2:	5f                   	pop    %edi
  8001c3:	5d                   	pop    %ebp
  8001c4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	50                   	push   %eax
  8001c9:	6a 05                	push   $0x5
  8001cb:	68 8a 1f 80 00       	push   $0x801f8a
  8001d0:	6a 23                	push   $0x23
  8001d2:	68 a7 1f 80 00       	push   $0x801fa7
  8001d7:	e8 61 0f 00 00       	call   80113d <_panic>

008001dc <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001dc:	55                   	push   %ebp
  8001dd:	89 e5                	mov    %esp,%ebp
  8001df:	57                   	push   %edi
  8001e0:	56                   	push   %esi
  8001e1:	53                   	push   %ebx
  8001e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001e5:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001ea:	b8 06 00 00 00       	mov    $0x6,%eax
  8001ef:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8001f5:	89 df                	mov    %ebx,%edi
  8001f7:	89 de                	mov    %ebx,%esi
  8001f9:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001fb:	85 c0                	test   %eax,%eax
  8001fd:	7f 08                	jg     800207 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800202:	5b                   	pop    %ebx
  800203:	5e                   	pop    %esi
  800204:	5f                   	pop    %edi
  800205:	5d                   	pop    %ebp
  800206:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	50                   	push   %eax
  80020b:	6a 06                	push   $0x6
  80020d:	68 8a 1f 80 00       	push   $0x801f8a
  800212:	6a 23                	push   $0x23
  800214:	68 a7 1f 80 00       	push   $0x801fa7
  800219:	e8 1f 0f 00 00       	call   80113d <_panic>

0080021e <sys_yield>:

void
sys_yield(void)
{
  80021e:	55                   	push   %ebp
  80021f:	89 e5                	mov    %esp,%ebp
  800221:	57                   	push   %edi
  800222:	56                   	push   %esi
  800223:	53                   	push   %ebx
	asm volatile("int %1\n"
  800224:	ba 00 00 00 00       	mov    $0x0,%edx
  800229:	b8 0b 00 00 00       	mov    $0xb,%eax
  80022e:	89 d1                	mov    %edx,%ecx
  800230:	89 d3                	mov    %edx,%ebx
  800232:	89 d7                	mov    %edx,%edi
  800234:	89 d6                	mov    %edx,%esi
  800236:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800238:	5b                   	pop    %ebx
  800239:	5e                   	pop    %esi
  80023a:	5f                   	pop    %edi
  80023b:	5d                   	pop    %ebp
  80023c:	c3                   	ret    

0080023d <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80023d:	55                   	push   %ebp
  80023e:	89 e5                	mov    %esp,%ebp
  800240:	57                   	push   %edi
  800241:	56                   	push   %esi
  800242:	53                   	push   %ebx
  800243:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800246:	bb 00 00 00 00       	mov    $0x0,%ebx
  80024b:	b8 08 00 00 00       	mov    $0x8,%eax
  800250:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800253:	8b 55 08             	mov    0x8(%ebp),%edx
  800256:	89 df                	mov    %ebx,%edi
  800258:	89 de                	mov    %ebx,%esi
  80025a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80025c:	85 c0                	test   %eax,%eax
  80025e:	7f 08                	jg     800268 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800260:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800263:	5b                   	pop    %ebx
  800264:	5e                   	pop    %esi
  800265:	5f                   	pop    %edi
  800266:	5d                   	pop    %ebp
  800267:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800268:	83 ec 0c             	sub    $0xc,%esp
  80026b:	50                   	push   %eax
  80026c:	6a 08                	push   $0x8
  80026e:	68 8a 1f 80 00       	push   $0x801f8a
  800273:	6a 23                	push   $0x23
  800275:	68 a7 1f 80 00       	push   $0x801fa7
  80027a:	e8 be 0e 00 00       	call   80113d <_panic>

0080027f <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	57                   	push   %edi
  800283:	56                   	push   %esi
  800284:	53                   	push   %ebx
  800285:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800288:	b9 00 00 00 00       	mov    $0x0,%ecx
  80028d:	b8 0c 00 00 00       	mov    $0xc,%eax
  800292:	8b 55 08             	mov    0x8(%ebp),%edx
  800295:	89 cb                	mov    %ecx,%ebx
  800297:	89 cf                	mov    %ecx,%edi
  800299:	89 ce                	mov    %ecx,%esi
  80029b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80029d:	85 c0                	test   %eax,%eax
  80029f:	7f 08                	jg     8002a9 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  8002a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002a4:	5b                   	pop    %ebx
  8002a5:	5e                   	pop    %esi
  8002a6:	5f                   	pop    %edi
  8002a7:	5d                   	pop    %ebp
  8002a8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002a9:	83 ec 0c             	sub    $0xc,%esp
  8002ac:	50                   	push   %eax
  8002ad:	6a 0c                	push   $0xc
  8002af:	68 8a 1f 80 00       	push   $0x801f8a
  8002b4:	6a 23                	push   $0x23
  8002b6:	68 a7 1f 80 00       	push   $0x801fa7
  8002bb:	e8 7d 0e 00 00       	call   80113d <_panic>

008002c0 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	57                   	push   %edi
  8002c4:	56                   	push   %esi
  8002c5:	53                   	push   %ebx
  8002c6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002c9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002ce:	b8 09 00 00 00       	mov    $0x9,%eax
  8002d3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8002d9:	89 df                	mov    %ebx,%edi
  8002db:	89 de                	mov    %ebx,%esi
  8002dd:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002df:	85 c0                	test   %eax,%eax
  8002e1:	7f 08                	jg     8002eb <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002e6:	5b                   	pop    %ebx
  8002e7:	5e                   	pop    %esi
  8002e8:	5f                   	pop    %edi
  8002e9:	5d                   	pop    %ebp
  8002ea:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002eb:	83 ec 0c             	sub    $0xc,%esp
  8002ee:	50                   	push   %eax
  8002ef:	6a 09                	push   $0x9
  8002f1:	68 8a 1f 80 00       	push   $0x801f8a
  8002f6:	6a 23                	push   $0x23
  8002f8:	68 a7 1f 80 00       	push   $0x801fa7
  8002fd:	e8 3b 0e 00 00       	call   80113d <_panic>

00800302 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	57                   	push   %edi
  800306:	56                   	push   %esi
  800307:	53                   	push   %ebx
  800308:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80030b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800310:	b8 0a 00 00 00       	mov    $0xa,%eax
  800315:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800318:	8b 55 08             	mov    0x8(%ebp),%edx
  80031b:	89 df                	mov    %ebx,%edi
  80031d:	89 de                	mov    %ebx,%esi
  80031f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800321:	85 c0                	test   %eax,%eax
  800323:	7f 08                	jg     80032d <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800325:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800328:	5b                   	pop    %ebx
  800329:	5e                   	pop    %esi
  80032a:	5f                   	pop    %edi
  80032b:	5d                   	pop    %ebp
  80032c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80032d:	83 ec 0c             	sub    $0xc,%esp
  800330:	50                   	push   %eax
  800331:	6a 0a                	push   $0xa
  800333:	68 8a 1f 80 00       	push   $0x801f8a
  800338:	6a 23                	push   $0x23
  80033a:	68 a7 1f 80 00       	push   $0x801fa7
  80033f:	e8 f9 0d 00 00       	call   80113d <_panic>

00800344 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800344:	55                   	push   %ebp
  800345:	89 e5                	mov    %esp,%ebp
  800347:	57                   	push   %edi
  800348:	56                   	push   %esi
  800349:	53                   	push   %ebx
	asm volatile("int %1\n"
  80034a:	be 00 00 00 00       	mov    $0x0,%esi
  80034f:	b8 0d 00 00 00       	mov    $0xd,%eax
  800354:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800357:	8b 55 08             	mov    0x8(%ebp),%edx
  80035a:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80035d:	8b 7d 14             	mov    0x14(%ebp),%edi
  800360:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800362:	5b                   	pop    %ebx
  800363:	5e                   	pop    %esi
  800364:	5f                   	pop    %edi
  800365:	5d                   	pop    %ebp
  800366:	c3                   	ret    

00800367 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800367:	55                   	push   %ebp
  800368:	89 e5                	mov    %esp,%ebp
  80036a:	57                   	push   %edi
  80036b:	56                   	push   %esi
  80036c:	53                   	push   %ebx
  80036d:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800370:	b9 00 00 00 00       	mov    $0x0,%ecx
  800375:	b8 0e 00 00 00       	mov    $0xe,%eax
  80037a:	8b 55 08             	mov    0x8(%ebp),%edx
  80037d:	89 cb                	mov    %ecx,%ebx
  80037f:	89 cf                	mov    %ecx,%edi
  800381:	89 ce                	mov    %ecx,%esi
  800383:	cd 30                	int    $0x30
	if(check && ret > 0)
  800385:	85 c0                	test   %eax,%eax
  800387:	7f 08                	jg     800391 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800389:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80038c:	5b                   	pop    %ebx
  80038d:	5e                   	pop    %esi
  80038e:	5f                   	pop    %edi
  80038f:	5d                   	pop    %ebp
  800390:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800391:	83 ec 0c             	sub    $0xc,%esp
  800394:	50                   	push   %eax
  800395:	6a 0e                	push   $0xe
  800397:	68 8a 1f 80 00       	push   $0x801f8a
  80039c:	6a 23                	push   $0x23
  80039e:	68 a7 1f 80 00       	push   $0x801fa7
  8003a3:	e8 95 0d 00 00       	call   80113d <_panic>

008003a8 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	57                   	push   %edi
  8003ac:	56                   	push   %esi
  8003ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003ae:	be 00 00 00 00       	mov    $0x0,%esi
  8003b3:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8003be:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c1:	89 f7                	mov    %esi,%edi
  8003c3:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003c5:	5b                   	pop    %ebx
  8003c6:	5e                   	pop    %esi
  8003c7:	5f                   	pop    %edi
  8003c8:	5d                   	pop    %ebp
  8003c9:	c3                   	ret    

008003ca <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003ca:	55                   	push   %ebp
  8003cb:	89 e5                	mov    %esp,%ebp
  8003cd:	57                   	push   %edi
  8003ce:	56                   	push   %esi
  8003cf:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003d0:	be 00 00 00 00       	mov    $0x0,%esi
  8003d5:	b8 10 00 00 00       	mov    $0x10,%eax
  8003da:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003e3:	89 f7                	mov    %esi,%edi
  8003e5:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003e7:	5b                   	pop    %ebx
  8003e8:	5e                   	pop    %esi
  8003e9:	5f                   	pop    %edi
  8003ea:	5d                   	pop    %ebp
  8003eb:	c3                   	ret    

008003ec <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003ec:	55                   	push   %ebp
  8003ed:	89 e5                	mov    %esp,%ebp
  8003ef:	57                   	push   %edi
  8003f0:	56                   	push   %esi
  8003f1:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003f2:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003f7:	b8 11 00 00 00       	mov    $0x11,%eax
  8003fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ff:	89 cb                	mov    %ecx,%ebx
  800401:	89 cf                	mov    %ecx,%edi
  800403:	89 ce                	mov    %ecx,%esi
  800405:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800407:	5b                   	pop    %ebx
  800408:	5e                   	pop    %esi
  800409:	5f                   	pop    %edi
  80040a:	5d                   	pop    %ebp
  80040b:	c3                   	ret    

0080040c <_pgfault_upcall>:

.text
.globl _pgfault_upcall
_pgfault_upcall:
	// Call the C page fault handler.
	pushl %esp			// function argument: pointer to UTF
  80040c:	54                   	push   %esp
	movl _pgfault_handler, %eax
  80040d:	a1 00 60 80 00       	mov    0x806000,%eax
	call *%eax
  800412:	ff d0                	call   *%eax
	addl $4, %esp			// pop function argument
  800414:	83 c4 04             	add    $0x4,%esp
	// registers are available for intermediate calculations.  You
	// may find that you have to rearrange your code in non-obvious
	// ways as registers become unavailable as scratch space.
	//
	// LAB 4: Your code here.
	movl 48(%esp), %eax
  800417:	8b 44 24 30          	mov    0x30(%esp),%eax
	movl 40(%esp), %ebx
  80041b:	8b 5c 24 28          	mov    0x28(%esp),%ebx
	subl $4, %eax
  80041f:	83 e8 04             	sub    $0x4,%eax
	movl %ebx, (%eax)
  800422:	89 18                	mov    %ebx,(%eax)
	movl %eax, 48(%esp)
  800424:	89 44 24 30          	mov    %eax,0x30(%esp)
	addl $8, %esp
  800428:	83 c4 08             	add    $0x8,%esp
	// Restore the trap-time registers.  After you do this, you
	// can no longer modify any general-purpose registers.
	// LAB 4: Your code here.
	popal
  80042b:	61                   	popa   
	addl $4, %esp
  80042c:	83 c4 04             	add    $0x4,%esp
	// Restore eflags from the stack.  After you do this, you can
	// no longer use arithmetic operations or anything else that
	// modifies eflags.
	// LAB 4: Your code here.
	popfl
  80042f:	9d                   	popf   
	// Switch back to the adjusted trap-time stack.
	// LAB 4: Your code here.
	popl %esp
  800430:	5c                   	pop    %esp
	// Return to re-execute the instruction that faulted.
	// LAB 4: Your code here.
  800431:	c3                   	ret    

00800432 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800432:	55                   	push   %ebp
  800433:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800435:	8b 45 08             	mov    0x8(%ebp),%eax
  800438:	05 00 00 00 30       	add    $0x30000000,%eax
  80043d:	c1 e8 0c             	shr    $0xc,%eax
}
  800440:	5d                   	pop    %ebp
  800441:	c3                   	ret    

00800442 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800442:	55                   	push   %ebp
  800443:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80044d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800452:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800457:	5d                   	pop    %ebp
  800458:	c3                   	ret    

00800459 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800459:	55                   	push   %ebp
  80045a:	89 e5                	mov    %esp,%ebp
  80045c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80045f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800464:	89 c2                	mov    %eax,%edx
  800466:	c1 ea 16             	shr    $0x16,%edx
  800469:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800470:	f6 c2 01             	test   $0x1,%dl
  800473:	74 2a                	je     80049f <fd_alloc+0x46>
  800475:	89 c2                	mov    %eax,%edx
  800477:	c1 ea 0c             	shr    $0xc,%edx
  80047a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800481:	f6 c2 01             	test   $0x1,%dl
  800484:	74 19                	je     80049f <fd_alloc+0x46>
  800486:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80048b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800490:	75 d2                	jne    800464 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800492:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800498:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80049d:	eb 07                	jmp    8004a6 <fd_alloc+0x4d>
			*fd_store = fd;
  80049f:	89 01                	mov    %eax,(%ecx)
			return 0;
  8004a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a6:	5d                   	pop    %ebp
  8004a7:	c3                   	ret    

008004a8 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  8004a8:	55                   	push   %ebp
  8004a9:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  8004ab:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  8004af:	77 39                	ja     8004ea <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  8004b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004b4:	c1 e0 0c             	shl    $0xc,%eax
  8004b7:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004bc:	89 c2                	mov    %eax,%edx
  8004be:	c1 ea 16             	shr    $0x16,%edx
  8004c1:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004c8:	f6 c2 01             	test   $0x1,%dl
  8004cb:	74 24                	je     8004f1 <fd_lookup+0x49>
  8004cd:	89 c2                	mov    %eax,%edx
  8004cf:	c1 ea 0c             	shr    $0xc,%edx
  8004d2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004d9:	f6 c2 01             	test   $0x1,%dl
  8004dc:	74 1a                	je     8004f8 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e1:	89 02                	mov    %eax,(%edx)
	return 0;
  8004e3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004e8:	5d                   	pop    %ebp
  8004e9:	c3                   	ret    
		return -E_INVAL;
  8004ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ef:	eb f7                	jmp    8004e8 <fd_lookup+0x40>
		return -E_INVAL;
  8004f1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004f6:	eb f0                	jmp    8004e8 <fd_lookup+0x40>
  8004f8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004fd:	eb e9                	jmp    8004e8 <fd_lookup+0x40>

008004ff <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	83 ec 08             	sub    $0x8,%esp
  800505:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800508:	ba 34 20 80 00       	mov    $0x802034,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  80050d:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  800512:	39 08                	cmp    %ecx,(%eax)
  800514:	74 33                	je     800549 <dev_lookup+0x4a>
  800516:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800519:	8b 02                	mov    (%edx),%eax
  80051b:	85 c0                	test   %eax,%eax
  80051d:	75 f3                	jne    800512 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80051f:	a1 04 40 80 00       	mov    0x804004,%eax
  800524:	8b 40 48             	mov    0x48(%eax),%eax
  800527:	83 ec 04             	sub    $0x4,%esp
  80052a:	51                   	push   %ecx
  80052b:	50                   	push   %eax
  80052c:	68 b8 1f 80 00       	push   $0x801fb8
  800531:	e8 1a 0d 00 00       	call   801250 <cprintf>
	*dev = 0;
  800536:	8b 45 0c             	mov    0xc(%ebp),%eax
  800539:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80053f:	83 c4 10             	add    $0x10,%esp
  800542:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800547:	c9                   	leave  
  800548:	c3                   	ret    
			*dev = devtab[i];
  800549:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80054c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80054e:	b8 00 00 00 00       	mov    $0x0,%eax
  800553:	eb f2                	jmp    800547 <dev_lookup+0x48>

00800555 <fd_close>:
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	57                   	push   %edi
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 1c             	sub    $0x1c,%esp
  80055e:	8b 75 08             	mov    0x8(%ebp),%esi
  800561:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800564:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800567:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800568:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80056e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800571:	50                   	push   %eax
  800572:	e8 31 ff ff ff       	call   8004a8 <fd_lookup>
  800577:	89 c7                	mov    %eax,%edi
  800579:	83 c4 08             	add    $0x8,%esp
  80057c:	85 c0                	test   %eax,%eax
  80057e:	78 05                	js     800585 <fd_close+0x30>
	    || fd != fd2)
  800580:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800583:	74 13                	je     800598 <fd_close+0x43>
		return (must_exist ? r : 0);
  800585:	84 db                	test   %bl,%bl
  800587:	75 05                	jne    80058e <fd_close+0x39>
  800589:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80058e:	89 f8                	mov    %edi,%eax
  800590:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800593:	5b                   	pop    %ebx
  800594:	5e                   	pop    %esi
  800595:	5f                   	pop    %edi
  800596:	5d                   	pop    %ebp
  800597:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80059e:	50                   	push   %eax
  80059f:	ff 36                	pushl  (%esi)
  8005a1:	e8 59 ff ff ff       	call   8004ff <dev_lookup>
  8005a6:	89 c7                	mov    %eax,%edi
  8005a8:	83 c4 10             	add    $0x10,%esp
  8005ab:	85 c0                	test   %eax,%eax
  8005ad:	78 15                	js     8005c4 <fd_close+0x6f>
		if (dev->dev_close)
  8005af:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005b2:	8b 40 10             	mov    0x10(%eax),%eax
  8005b5:	85 c0                	test   %eax,%eax
  8005b7:	74 1b                	je     8005d4 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8005b9:	83 ec 0c             	sub    $0xc,%esp
  8005bc:	56                   	push   %esi
  8005bd:	ff d0                	call   *%eax
  8005bf:	89 c7                	mov    %eax,%edi
  8005c1:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	56                   	push   %esi
  8005c8:	6a 00                	push   $0x0
  8005ca:	e8 0d fc ff ff       	call   8001dc <sys_page_unmap>
	return r;
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	eb ba                	jmp    80058e <fd_close+0x39>
			r = 0;
  8005d4:	bf 00 00 00 00       	mov    $0x0,%edi
  8005d9:	eb e9                	jmp    8005c4 <fd_close+0x6f>

008005db <close>:

int
close(int fdnum)
{
  8005db:	55                   	push   %ebp
  8005dc:	89 e5                	mov    %esp,%ebp
  8005de:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005e1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005e4:	50                   	push   %eax
  8005e5:	ff 75 08             	pushl  0x8(%ebp)
  8005e8:	e8 bb fe ff ff       	call   8004a8 <fd_lookup>
  8005ed:	83 c4 08             	add    $0x8,%esp
  8005f0:	85 c0                	test   %eax,%eax
  8005f2:	78 10                	js     800604 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	6a 01                	push   $0x1
  8005f9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005fc:	e8 54 ff ff ff       	call   800555 <fd_close>
  800601:	83 c4 10             	add    $0x10,%esp
}
  800604:	c9                   	leave  
  800605:	c3                   	ret    

00800606 <close_all>:

void
close_all(void)
{
  800606:	55                   	push   %ebp
  800607:	89 e5                	mov    %esp,%ebp
  800609:	53                   	push   %ebx
  80060a:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  80060d:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  800612:	83 ec 0c             	sub    $0xc,%esp
  800615:	53                   	push   %ebx
  800616:	e8 c0 ff ff ff       	call   8005db <close>
	for (i = 0; i < MAXFD; i++)
  80061b:	43                   	inc    %ebx
  80061c:	83 c4 10             	add    $0x10,%esp
  80061f:	83 fb 20             	cmp    $0x20,%ebx
  800622:	75 ee                	jne    800612 <close_all+0xc>
}
  800624:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800627:	c9                   	leave  
  800628:	c3                   	ret    

00800629 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800629:	55                   	push   %ebp
  80062a:	89 e5                	mov    %esp,%ebp
  80062c:	57                   	push   %edi
  80062d:	56                   	push   %esi
  80062e:	53                   	push   %ebx
  80062f:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800632:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800635:	50                   	push   %eax
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 6a fe ff ff       	call   8004a8 <fd_lookup>
  80063e:	89 c3                	mov    %eax,%ebx
  800640:	83 c4 08             	add    $0x8,%esp
  800643:	85 c0                	test   %eax,%eax
  800645:	0f 88 81 00 00 00    	js     8006cc <dup+0xa3>
		return r;
	close(newfdnum);
  80064b:	83 ec 0c             	sub    $0xc,%esp
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	e8 85 ff ff ff       	call   8005db <close>

	newfd = INDEX2FD(newfdnum);
  800656:	8b 75 0c             	mov    0xc(%ebp),%esi
  800659:	c1 e6 0c             	shl    $0xc,%esi
  80065c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800662:	83 c4 04             	add    $0x4,%esp
  800665:	ff 75 e4             	pushl  -0x1c(%ebp)
  800668:	e8 d5 fd ff ff       	call   800442 <fd2data>
  80066d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80066f:	89 34 24             	mov    %esi,(%esp)
  800672:	e8 cb fd ff ff       	call   800442 <fd2data>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80067c:	89 d8                	mov    %ebx,%eax
  80067e:	c1 e8 16             	shr    $0x16,%eax
  800681:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800688:	a8 01                	test   $0x1,%al
  80068a:	74 11                	je     80069d <dup+0x74>
  80068c:	89 d8                	mov    %ebx,%eax
  80068e:	c1 e8 0c             	shr    $0xc,%eax
  800691:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800698:	f6 c2 01             	test   $0x1,%dl
  80069b:	75 39                	jne    8006d6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80069d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006a0:	89 d0                	mov    %edx,%eax
  8006a2:	c1 e8 0c             	shr    $0xc,%eax
  8006a5:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006ac:	83 ec 0c             	sub    $0xc,%esp
  8006af:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b4:	50                   	push   %eax
  8006b5:	56                   	push   %esi
  8006b6:	6a 00                	push   $0x0
  8006b8:	52                   	push   %edx
  8006b9:	6a 00                	push   $0x0
  8006bb:	e8 da fa ff ff       	call   80019a <sys_page_map>
  8006c0:	89 c3                	mov    %eax,%ebx
  8006c2:	83 c4 20             	add    $0x20,%esp
  8006c5:	85 c0                	test   %eax,%eax
  8006c7:	78 31                	js     8006fa <dup+0xd1>
		goto err;

	return newfdnum;
  8006c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006cc:	89 d8                	mov    %ebx,%eax
  8006ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006d1:	5b                   	pop    %ebx
  8006d2:	5e                   	pop    %esi
  8006d3:	5f                   	pop    %edi
  8006d4:	5d                   	pop    %ebp
  8006d5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006d6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	25 07 0e 00 00       	and    $0xe07,%eax
  8006e5:	50                   	push   %eax
  8006e6:	57                   	push   %edi
  8006e7:	6a 00                	push   $0x0
  8006e9:	53                   	push   %ebx
  8006ea:	6a 00                	push   $0x0
  8006ec:	e8 a9 fa ff ff       	call   80019a <sys_page_map>
  8006f1:	89 c3                	mov    %eax,%ebx
  8006f3:	83 c4 20             	add    $0x20,%esp
  8006f6:	85 c0                	test   %eax,%eax
  8006f8:	79 a3                	jns    80069d <dup+0x74>
	sys_page_unmap(0, newfd);
  8006fa:	83 ec 08             	sub    $0x8,%esp
  8006fd:	56                   	push   %esi
  8006fe:	6a 00                	push   $0x0
  800700:	e8 d7 fa ff ff       	call   8001dc <sys_page_unmap>
	sys_page_unmap(0, nva);
  800705:	83 c4 08             	add    $0x8,%esp
  800708:	57                   	push   %edi
  800709:	6a 00                	push   $0x0
  80070b:	e8 cc fa ff ff       	call   8001dc <sys_page_unmap>
	return r;
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	eb b7                	jmp    8006cc <dup+0xa3>

00800715 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800715:	55                   	push   %ebp
  800716:	89 e5                	mov    %esp,%ebp
  800718:	53                   	push   %ebx
  800719:	83 ec 14             	sub    $0x14,%esp
  80071c:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80071f:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800722:	50                   	push   %eax
  800723:	53                   	push   %ebx
  800724:	e8 7f fd ff ff       	call   8004a8 <fd_lookup>
  800729:	83 c4 08             	add    $0x8,%esp
  80072c:	85 c0                	test   %eax,%eax
  80072e:	78 3f                	js     80076f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800736:	50                   	push   %eax
  800737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80073a:	ff 30                	pushl  (%eax)
  80073c:	e8 be fd ff ff       	call   8004ff <dev_lookup>
  800741:	83 c4 10             	add    $0x10,%esp
  800744:	85 c0                	test   %eax,%eax
  800746:	78 27                	js     80076f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800748:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80074b:	8b 42 08             	mov    0x8(%edx),%eax
  80074e:	83 e0 03             	and    $0x3,%eax
  800751:	83 f8 01             	cmp    $0x1,%eax
  800754:	74 1e                	je     800774 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	8b 40 08             	mov    0x8(%eax),%eax
  80075c:	85 c0                	test   %eax,%eax
  80075e:	74 35                	je     800795 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800760:	83 ec 04             	sub    $0x4,%esp
  800763:	ff 75 10             	pushl  0x10(%ebp)
  800766:	ff 75 0c             	pushl  0xc(%ebp)
  800769:	52                   	push   %edx
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
}
  80076f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800772:	c9                   	leave  
  800773:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800774:	a1 04 40 80 00       	mov    0x804004,%eax
  800779:	8b 40 48             	mov    0x48(%eax),%eax
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	53                   	push   %ebx
  800780:	50                   	push   %eax
  800781:	68 f9 1f 80 00       	push   $0x801ff9
  800786:	e8 c5 0a 00 00       	call   801250 <cprintf>
		return -E_INVAL;
  80078b:	83 c4 10             	add    $0x10,%esp
  80078e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800793:	eb da                	jmp    80076f <read+0x5a>
		return -E_NOT_SUPP;
  800795:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80079a:	eb d3                	jmp    80076f <read+0x5a>

0080079c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	57                   	push   %edi
  8007a0:	56                   	push   %esi
  8007a1:	53                   	push   %ebx
  8007a2:	83 ec 0c             	sub    $0xc,%esp
  8007a5:	8b 7d 08             	mov    0x8(%ebp),%edi
  8007a8:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  8007ab:	bb 00 00 00 00       	mov    $0x0,%ebx
  8007b0:	39 f3                	cmp    %esi,%ebx
  8007b2:	73 25                	jae    8007d9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007b4:	83 ec 04             	sub    $0x4,%esp
  8007b7:	89 f0                	mov    %esi,%eax
  8007b9:	29 d8                	sub    %ebx,%eax
  8007bb:	50                   	push   %eax
  8007bc:	89 d8                	mov    %ebx,%eax
  8007be:	03 45 0c             	add    0xc(%ebp),%eax
  8007c1:	50                   	push   %eax
  8007c2:	57                   	push   %edi
  8007c3:	e8 4d ff ff ff       	call   800715 <read>
		if (m < 0)
  8007c8:	83 c4 10             	add    $0x10,%esp
  8007cb:	85 c0                	test   %eax,%eax
  8007cd:	78 08                	js     8007d7 <readn+0x3b>
			return m;
		if (m == 0)
  8007cf:	85 c0                	test   %eax,%eax
  8007d1:	74 06                	je     8007d9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007d3:	01 c3                	add    %eax,%ebx
  8007d5:	eb d9                	jmp    8007b0 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007d7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007d9:	89 d8                	mov    %ebx,%eax
  8007db:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007de:	5b                   	pop    %ebx
  8007df:	5e                   	pop    %esi
  8007e0:	5f                   	pop    %edi
  8007e1:	5d                   	pop    %ebp
  8007e2:	c3                   	ret    

008007e3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007e3:	55                   	push   %ebp
  8007e4:	89 e5                	mov    %esp,%ebp
  8007e6:	53                   	push   %ebx
  8007e7:	83 ec 14             	sub    $0x14,%esp
  8007ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007f0:	50                   	push   %eax
  8007f1:	53                   	push   %ebx
  8007f2:	e8 b1 fc ff ff       	call   8004a8 <fd_lookup>
  8007f7:	83 c4 08             	add    $0x8,%esp
  8007fa:	85 c0                	test   %eax,%eax
  8007fc:	78 3a                	js     800838 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007fe:	83 ec 08             	sub    $0x8,%esp
  800801:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800804:	50                   	push   %eax
  800805:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800808:	ff 30                	pushl  (%eax)
  80080a:	e8 f0 fc ff ff       	call   8004ff <dev_lookup>
  80080f:	83 c4 10             	add    $0x10,%esp
  800812:	85 c0                	test   %eax,%eax
  800814:	78 22                	js     800838 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800819:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  80081d:	74 1e                	je     80083d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80081f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800822:	8b 52 0c             	mov    0xc(%edx),%edx
  800825:	85 d2                	test   %edx,%edx
  800827:	74 35                	je     80085e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800829:	83 ec 04             	sub    $0x4,%esp
  80082c:	ff 75 10             	pushl  0x10(%ebp)
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	ff d2                	call   *%edx
  800835:	83 c4 10             	add    $0x10,%esp
}
  800838:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80083b:	c9                   	leave  
  80083c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80083d:	a1 04 40 80 00       	mov    0x804004,%eax
  800842:	8b 40 48             	mov    0x48(%eax),%eax
  800845:	83 ec 04             	sub    $0x4,%esp
  800848:	53                   	push   %ebx
  800849:	50                   	push   %eax
  80084a:	68 15 20 80 00       	push   $0x802015
  80084f:	e8 fc 09 00 00       	call   801250 <cprintf>
		return -E_INVAL;
  800854:	83 c4 10             	add    $0x10,%esp
  800857:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80085c:	eb da                	jmp    800838 <write+0x55>
		return -E_NOT_SUPP;
  80085e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800863:	eb d3                	jmp    800838 <write+0x55>

00800865 <seek>:

int
seek(int fdnum, off_t offset)
{
  800865:	55                   	push   %ebp
  800866:	89 e5                	mov    %esp,%ebp
  800868:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80086b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	ff 75 08             	pushl  0x8(%ebp)
  800872:	e8 31 fc ff ff       	call   8004a8 <fd_lookup>
  800877:	83 c4 08             	add    $0x8,%esp
  80087a:	85 c0                	test   %eax,%eax
  80087c:	78 0e                	js     80088c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80087e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800881:	8b 55 0c             	mov    0xc(%ebp),%edx
  800884:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800887:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80088c:	c9                   	leave  
  80088d:	c3                   	ret    

0080088e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80088e:	55                   	push   %ebp
  80088f:	89 e5                	mov    %esp,%ebp
  800891:	53                   	push   %ebx
  800892:	83 ec 14             	sub    $0x14,%esp
  800895:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800898:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80089b:	50                   	push   %eax
  80089c:	53                   	push   %ebx
  80089d:	e8 06 fc ff ff       	call   8004a8 <fd_lookup>
  8008a2:	83 c4 08             	add    $0x8,%esp
  8008a5:	85 c0                	test   %eax,%eax
  8008a7:	78 37                	js     8008e0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008a9:	83 ec 08             	sub    $0x8,%esp
  8008ac:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008af:	50                   	push   %eax
  8008b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b3:	ff 30                	pushl  (%eax)
  8008b5:	e8 45 fc ff ff       	call   8004ff <dev_lookup>
  8008ba:	83 c4 10             	add    $0x10,%esp
  8008bd:	85 c0                	test   %eax,%eax
  8008bf:	78 1f                	js     8008e0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c4:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008c8:	74 1b                	je     8008e5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8008ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008cd:	8b 52 18             	mov    0x18(%edx),%edx
  8008d0:	85 d2                	test   %edx,%edx
  8008d2:	74 32                	je     800906 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008d4:	83 ec 08             	sub    $0x8,%esp
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	50                   	push   %eax
  8008db:	ff d2                	call   *%edx
  8008dd:	83 c4 10             	add    $0x10,%esp
}
  8008e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e3:	c9                   	leave  
  8008e4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008e5:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008ea:	8b 40 48             	mov    0x48(%eax),%eax
  8008ed:	83 ec 04             	sub    $0x4,%esp
  8008f0:	53                   	push   %ebx
  8008f1:	50                   	push   %eax
  8008f2:	68 d8 1f 80 00       	push   $0x801fd8
  8008f7:	e8 54 09 00 00       	call   801250 <cprintf>
		return -E_INVAL;
  8008fc:	83 c4 10             	add    $0x10,%esp
  8008ff:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800904:	eb da                	jmp    8008e0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  800906:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80090b:	eb d3                	jmp    8008e0 <ftruncate+0x52>

0080090d <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  80090d:	55                   	push   %ebp
  80090e:	89 e5                	mov    %esp,%ebp
  800910:	53                   	push   %ebx
  800911:	83 ec 14             	sub    $0x14,%esp
  800914:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800917:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80091a:	50                   	push   %eax
  80091b:	ff 75 08             	pushl  0x8(%ebp)
  80091e:	e8 85 fb ff ff       	call   8004a8 <fd_lookup>
  800923:	83 c4 08             	add    $0x8,%esp
  800926:	85 c0                	test   %eax,%eax
  800928:	78 4b                	js     800975 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800930:	50                   	push   %eax
  800931:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800934:	ff 30                	pushl  (%eax)
  800936:	e8 c4 fb ff ff       	call   8004ff <dev_lookup>
  80093b:	83 c4 10             	add    $0x10,%esp
  80093e:	85 c0                	test   %eax,%eax
  800940:	78 33                	js     800975 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800945:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800949:	74 2f                	je     80097a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80094b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80094e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800955:	00 00 00 
	stat->st_type = 0;
  800958:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80095f:	00 00 00 
	stat->st_dev = dev;
  800962:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800968:	83 ec 08             	sub    $0x8,%esp
  80096b:	53                   	push   %ebx
  80096c:	ff 75 f0             	pushl  -0x10(%ebp)
  80096f:	ff 50 14             	call   *0x14(%eax)
  800972:	83 c4 10             	add    $0x10,%esp
}
  800975:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800978:	c9                   	leave  
  800979:	c3                   	ret    
		return -E_NOT_SUPP;
  80097a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80097f:	eb f4                	jmp    800975 <fstat+0x68>

00800981 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800981:	55                   	push   %ebp
  800982:	89 e5                	mov    %esp,%ebp
  800984:	56                   	push   %esi
  800985:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800986:	83 ec 08             	sub    $0x8,%esp
  800989:	6a 00                	push   $0x0
  80098b:	ff 75 08             	pushl  0x8(%ebp)
  80098e:	e8 34 02 00 00       	call   800bc7 <open>
  800993:	89 c3                	mov    %eax,%ebx
  800995:	83 c4 10             	add    $0x10,%esp
  800998:	85 c0                	test   %eax,%eax
  80099a:	78 1b                	js     8009b7 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80099c:	83 ec 08             	sub    $0x8,%esp
  80099f:	ff 75 0c             	pushl  0xc(%ebp)
  8009a2:	50                   	push   %eax
  8009a3:	e8 65 ff ff ff       	call   80090d <fstat>
  8009a8:	89 c6                	mov    %eax,%esi
	close(fd);
  8009aa:	89 1c 24             	mov    %ebx,(%esp)
  8009ad:	e8 29 fc ff ff       	call   8005db <close>
	return r;
  8009b2:	83 c4 10             	add    $0x10,%esp
  8009b5:	89 f3                	mov    %esi,%ebx
}
  8009b7:	89 d8                	mov    %ebx,%eax
  8009b9:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009bc:	5b                   	pop    %ebx
  8009bd:	5e                   	pop    %esi
  8009be:	5d                   	pop    %ebp
  8009bf:	c3                   	ret    

008009c0 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8009c0:	55                   	push   %ebp
  8009c1:	89 e5                	mov    %esp,%ebp
  8009c3:	56                   	push   %esi
  8009c4:	53                   	push   %ebx
  8009c5:	89 c6                	mov    %eax,%esi
  8009c7:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8009c9:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009d0:	74 27                	je     8009f9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009d2:	6a 07                	push   $0x7
  8009d4:	68 00 50 80 00       	push   $0x805000
  8009d9:	56                   	push   %esi
  8009da:	ff 35 00 40 80 00    	pushl  0x804000
  8009e0:	e8 5a 12 00 00       	call   801c3f <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009e5:	83 c4 0c             	add    $0xc,%esp
  8009e8:	6a 00                	push   $0x0
  8009ea:	53                   	push   %ebx
  8009eb:	6a 00                	push   $0x0
  8009ed:	e8 c4 11 00 00       	call   801bb6 <ipc_recv>
}
  8009f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f5:	5b                   	pop    %ebx
  8009f6:	5e                   	pop    %esi
  8009f7:	5d                   	pop    %ebp
  8009f8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009f9:	83 ec 0c             	sub    $0xc,%esp
  8009fc:	6a 01                	push   $0x1
  8009fe:	e8 98 12 00 00       	call   801c9b <ipc_find_env>
  800a03:	a3 00 40 80 00       	mov    %eax,0x804000
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	eb c5                	jmp    8009d2 <fsipc+0x12>

00800a0d <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  800a0d:	55                   	push   %ebp
  800a0e:	89 e5                	mov    %esp,%ebp
  800a10:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8b 40 0c             	mov    0xc(%eax),%eax
  800a19:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a21:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a26:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2b:	b8 02 00 00 00       	mov    $0x2,%eax
  800a30:	e8 8b ff ff ff       	call   8009c0 <fsipc>
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <devfile_flush>:
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a40:	8b 40 0c             	mov    0xc(%eax),%eax
  800a43:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a48:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4d:	b8 06 00 00 00       	mov    $0x6,%eax
  800a52:	e8 69 ff ff ff       	call   8009c0 <fsipc>
}
  800a57:	c9                   	leave  
  800a58:	c3                   	ret    

00800a59 <devfile_stat>:
{
  800a59:	55                   	push   %ebp
  800a5a:	89 e5                	mov    %esp,%ebp
  800a5c:	53                   	push   %ebx
  800a5d:	83 ec 04             	sub    $0x4,%esp
  800a60:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	8b 40 0c             	mov    0xc(%eax),%eax
  800a69:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a6e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a73:	b8 05 00 00 00       	mov    $0x5,%eax
  800a78:	e8 43 ff ff ff       	call   8009c0 <fsipc>
  800a7d:	85 c0                	test   %eax,%eax
  800a7f:	78 2c                	js     800aad <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	68 00 50 80 00       	push   $0x805000
  800a89:	53                   	push   %ebx
  800a8a:	e8 c9 0d 00 00       	call   801858 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a8f:	a1 80 50 80 00       	mov    0x805080,%eax
  800a94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a9a:	a1 84 50 80 00       	mov    0x805084,%eax
  800a9f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800aa5:	83 c4 10             	add    $0x10,%esp
  800aa8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800aad:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ab0:	c9                   	leave  
  800ab1:	c3                   	ret    

00800ab2 <devfile_write>:
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	53                   	push   %ebx
  800ab6:	83 ec 04             	sub    $0x4,%esp
  800ab9:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800abc:	89 d8                	mov    %ebx,%eax
  800abe:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800ac4:	76 05                	jbe    800acb <devfile_write+0x19>
  800ac6:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800acb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ace:	8b 52 0c             	mov    0xc(%edx),%edx
  800ad1:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800ad7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800adc:	83 ec 04             	sub    $0x4,%esp
  800adf:	50                   	push   %eax
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	68 08 50 80 00       	push   $0x805008
  800ae8:	e8 de 0e 00 00       	call   8019cb <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800aed:	ba 00 00 00 00       	mov    $0x0,%edx
  800af2:	b8 04 00 00 00       	mov    $0x4,%eax
  800af7:	e8 c4 fe ff ff       	call   8009c0 <fsipc>
  800afc:	83 c4 10             	add    $0x10,%esp
  800aff:	85 c0                	test   %eax,%eax
  800b01:	78 0b                	js     800b0e <devfile_write+0x5c>
	assert(r <= n);
  800b03:	39 c3                	cmp    %eax,%ebx
  800b05:	72 0c                	jb     800b13 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800b07:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b0c:	7f 1e                	jg     800b2c <devfile_write+0x7a>
}
  800b0e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b11:	c9                   	leave  
  800b12:	c3                   	ret    
	assert(r <= n);
  800b13:	68 44 20 80 00       	push   $0x802044
  800b18:	68 4b 20 80 00       	push   $0x80204b
  800b1d:	68 98 00 00 00       	push   $0x98
  800b22:	68 60 20 80 00       	push   $0x802060
  800b27:	e8 11 06 00 00       	call   80113d <_panic>
	assert(r <= PGSIZE);
  800b2c:	68 6b 20 80 00       	push   $0x80206b
  800b31:	68 4b 20 80 00       	push   $0x80204b
  800b36:	68 99 00 00 00       	push   $0x99
  800b3b:	68 60 20 80 00       	push   $0x802060
  800b40:	e8 f8 05 00 00       	call   80113d <_panic>

00800b45 <devfile_read>:
{
  800b45:	55                   	push   %ebp
  800b46:	89 e5                	mov    %esp,%ebp
  800b48:	56                   	push   %esi
  800b49:	53                   	push   %ebx
  800b4a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b50:	8b 40 0c             	mov    0xc(%eax),%eax
  800b53:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b58:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b5e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	e8 53 fe ff ff       	call   8009c0 <fsipc>
  800b6d:	89 c3                	mov    %eax,%ebx
  800b6f:	85 c0                	test   %eax,%eax
  800b71:	78 1f                	js     800b92 <devfile_read+0x4d>
	assert(r <= n);
  800b73:	39 c6                	cmp    %eax,%esi
  800b75:	72 24                	jb     800b9b <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b77:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b7c:	7f 33                	jg     800bb1 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b7e:	83 ec 04             	sub    $0x4,%esp
  800b81:	50                   	push   %eax
  800b82:	68 00 50 80 00       	push   $0x805000
  800b87:	ff 75 0c             	pushl  0xc(%ebp)
  800b8a:	e8 3c 0e 00 00       	call   8019cb <memmove>
	return r;
  800b8f:	83 c4 10             	add    $0x10,%esp
}
  800b92:	89 d8                	mov    %ebx,%eax
  800b94:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b97:	5b                   	pop    %ebx
  800b98:	5e                   	pop    %esi
  800b99:	5d                   	pop    %ebp
  800b9a:	c3                   	ret    
	assert(r <= n);
  800b9b:	68 44 20 80 00       	push   $0x802044
  800ba0:	68 4b 20 80 00       	push   $0x80204b
  800ba5:	6a 7c                	push   $0x7c
  800ba7:	68 60 20 80 00       	push   $0x802060
  800bac:	e8 8c 05 00 00       	call   80113d <_panic>
	assert(r <= PGSIZE);
  800bb1:	68 6b 20 80 00       	push   $0x80206b
  800bb6:	68 4b 20 80 00       	push   $0x80204b
  800bbb:	6a 7d                	push   $0x7d
  800bbd:	68 60 20 80 00       	push   $0x802060
  800bc2:	e8 76 05 00 00       	call   80113d <_panic>

00800bc7 <open>:
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	56                   	push   %esi
  800bcb:	53                   	push   %ebx
  800bcc:	83 ec 1c             	sub    $0x1c,%esp
  800bcf:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bd2:	56                   	push   %esi
  800bd3:	e8 4d 0c 00 00       	call   801825 <strlen>
  800bd8:	83 c4 10             	add    $0x10,%esp
  800bdb:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800be0:	7f 6c                	jg     800c4e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800be8:	50                   	push   %eax
  800be9:	e8 6b f8 ff ff       	call   800459 <fd_alloc>
  800bee:	89 c3                	mov    %eax,%ebx
  800bf0:	83 c4 10             	add    $0x10,%esp
  800bf3:	85 c0                	test   %eax,%eax
  800bf5:	78 3c                	js     800c33 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bf7:	83 ec 08             	sub    $0x8,%esp
  800bfa:	56                   	push   %esi
  800bfb:	68 00 50 80 00       	push   $0x805000
  800c00:	e8 53 0c 00 00       	call   801858 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800c05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c08:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800c0d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c10:	b8 01 00 00 00       	mov    $0x1,%eax
  800c15:	e8 a6 fd ff ff       	call   8009c0 <fsipc>
  800c1a:	89 c3                	mov    %eax,%ebx
  800c1c:	83 c4 10             	add    $0x10,%esp
  800c1f:	85 c0                	test   %eax,%eax
  800c21:	78 19                	js     800c3c <open+0x75>
	return fd2num(fd);
  800c23:	83 ec 0c             	sub    $0xc,%esp
  800c26:	ff 75 f4             	pushl  -0xc(%ebp)
  800c29:	e8 04 f8 ff ff       	call   800432 <fd2num>
  800c2e:	89 c3                	mov    %eax,%ebx
  800c30:	83 c4 10             	add    $0x10,%esp
}
  800c33:	89 d8                	mov    %ebx,%eax
  800c35:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c38:	5b                   	pop    %ebx
  800c39:	5e                   	pop    %esi
  800c3a:	5d                   	pop    %ebp
  800c3b:	c3                   	ret    
		fd_close(fd, 0);
  800c3c:	83 ec 08             	sub    $0x8,%esp
  800c3f:	6a 00                	push   $0x0
  800c41:	ff 75 f4             	pushl  -0xc(%ebp)
  800c44:	e8 0c f9 ff ff       	call   800555 <fd_close>
		return r;
  800c49:	83 c4 10             	add    $0x10,%esp
  800c4c:	eb e5                	jmp    800c33 <open+0x6c>
		return -E_BAD_PATH;
  800c4e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c53:	eb de                	jmp    800c33 <open+0x6c>

00800c55 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c55:	55                   	push   %ebp
  800c56:	89 e5                	mov    %esp,%ebp
  800c58:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c60:	b8 08 00 00 00       	mov    $0x8,%eax
  800c65:	e8 56 fd ff ff       	call   8009c0 <fsipc>
}
  800c6a:	c9                   	leave  
  800c6b:	c3                   	ret    

00800c6c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c6c:	55                   	push   %ebp
  800c6d:	89 e5                	mov    %esp,%ebp
  800c6f:	56                   	push   %esi
  800c70:	53                   	push   %ebx
  800c71:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c74:	83 ec 0c             	sub    $0xc,%esp
  800c77:	ff 75 08             	pushl  0x8(%ebp)
  800c7a:	e8 c3 f7 ff ff       	call   800442 <fd2data>
  800c7f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c81:	83 c4 08             	add    $0x8,%esp
  800c84:	68 77 20 80 00       	push   $0x802077
  800c89:	53                   	push   %ebx
  800c8a:	e8 c9 0b 00 00       	call   801858 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c8f:	8b 46 04             	mov    0x4(%esi),%eax
  800c92:	2b 06                	sub    (%esi),%eax
  800c94:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c9a:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800ca1:	10 00 00 
	stat->st_dev = &devpipe;
  800ca4:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800cab:	30 80 00 
	return 0;
}
  800cae:	b8 00 00 00 00       	mov    $0x0,%eax
  800cb3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800cb6:	5b                   	pop    %ebx
  800cb7:	5e                   	pop    %esi
  800cb8:	5d                   	pop    %ebp
  800cb9:	c3                   	ret    

00800cba <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	53                   	push   %ebx
  800cbe:	83 ec 0c             	sub    $0xc,%esp
  800cc1:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800cc4:	53                   	push   %ebx
  800cc5:	6a 00                	push   $0x0
  800cc7:	e8 10 f5 ff ff       	call   8001dc <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800ccc:	89 1c 24             	mov    %ebx,(%esp)
  800ccf:	e8 6e f7 ff ff       	call   800442 <fd2data>
  800cd4:	83 c4 08             	add    $0x8,%esp
  800cd7:	50                   	push   %eax
  800cd8:	6a 00                	push   $0x0
  800cda:	e8 fd f4 ff ff       	call   8001dc <sys_page_unmap>
}
  800cdf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ce2:	c9                   	leave  
  800ce3:	c3                   	ret    

00800ce4 <_pipeisclosed>:
{
  800ce4:	55                   	push   %ebp
  800ce5:	89 e5                	mov    %esp,%ebp
  800ce7:	57                   	push   %edi
  800ce8:	56                   	push   %esi
  800ce9:	53                   	push   %ebx
  800cea:	83 ec 1c             	sub    $0x1c,%esp
  800ced:	89 c7                	mov    %eax,%edi
  800cef:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cf1:	a1 04 40 80 00       	mov    0x804004,%eax
  800cf6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cf9:	83 ec 0c             	sub    $0xc,%esp
  800cfc:	57                   	push   %edi
  800cfd:	e8 db 0f 00 00       	call   801cdd <pageref>
  800d02:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d05:	89 34 24             	mov    %esi,(%esp)
  800d08:	e8 d0 0f 00 00       	call   801cdd <pageref>
		nn = thisenv->env_runs;
  800d0d:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800d13:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800d16:	83 c4 10             	add    $0x10,%esp
  800d19:	39 cb                	cmp    %ecx,%ebx
  800d1b:	74 1b                	je     800d38 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800d1d:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d20:	75 cf                	jne    800cf1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d22:	8b 42 58             	mov    0x58(%edx),%eax
  800d25:	6a 01                	push   $0x1
  800d27:	50                   	push   %eax
  800d28:	53                   	push   %ebx
  800d29:	68 7e 20 80 00       	push   $0x80207e
  800d2e:	e8 1d 05 00 00       	call   801250 <cprintf>
  800d33:	83 c4 10             	add    $0x10,%esp
  800d36:	eb b9                	jmp    800cf1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d38:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d3b:	0f 94 c0             	sete   %al
  800d3e:	0f b6 c0             	movzbl %al,%eax
}
  800d41:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d44:	5b                   	pop    %ebx
  800d45:	5e                   	pop    %esi
  800d46:	5f                   	pop    %edi
  800d47:	5d                   	pop    %ebp
  800d48:	c3                   	ret    

00800d49 <devpipe_write>:
{
  800d49:	55                   	push   %ebp
  800d4a:	89 e5                	mov    %esp,%ebp
  800d4c:	57                   	push   %edi
  800d4d:	56                   	push   %esi
  800d4e:	53                   	push   %ebx
  800d4f:	83 ec 18             	sub    $0x18,%esp
  800d52:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d55:	56                   	push   %esi
  800d56:	e8 e7 f6 ff ff       	call   800442 <fd2data>
  800d5b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d5d:	83 c4 10             	add    $0x10,%esp
  800d60:	bf 00 00 00 00       	mov    $0x0,%edi
  800d65:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d68:	74 41                	je     800dab <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d6a:	8b 53 04             	mov    0x4(%ebx),%edx
  800d6d:	8b 03                	mov    (%ebx),%eax
  800d6f:	83 c0 20             	add    $0x20,%eax
  800d72:	39 c2                	cmp    %eax,%edx
  800d74:	72 14                	jb     800d8a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d76:	89 da                	mov    %ebx,%edx
  800d78:	89 f0                	mov    %esi,%eax
  800d7a:	e8 65 ff ff ff       	call   800ce4 <_pipeisclosed>
  800d7f:	85 c0                	test   %eax,%eax
  800d81:	75 2c                	jne    800daf <devpipe_write+0x66>
			sys_yield();
  800d83:	e8 96 f4 ff ff       	call   80021e <sys_yield>
  800d88:	eb e0                	jmp    800d6a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8d:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d90:	89 d0                	mov    %edx,%eax
  800d92:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d97:	78 0b                	js     800da4 <devpipe_write+0x5b>
  800d99:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d9d:	42                   	inc    %edx
  800d9e:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800da1:	47                   	inc    %edi
  800da2:	eb c1                	jmp    800d65 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800da4:	48                   	dec    %eax
  800da5:	83 c8 e0             	or     $0xffffffe0,%eax
  800da8:	40                   	inc    %eax
  800da9:	eb ee                	jmp    800d99 <devpipe_write+0x50>
	return i;
  800dab:	89 f8                	mov    %edi,%eax
  800dad:	eb 05                	jmp    800db4 <devpipe_write+0x6b>
				return 0;
  800daf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db7:	5b                   	pop    %ebx
  800db8:	5e                   	pop    %esi
  800db9:	5f                   	pop    %edi
  800dba:	5d                   	pop    %ebp
  800dbb:	c3                   	ret    

00800dbc <devpipe_read>:
{
  800dbc:	55                   	push   %ebp
  800dbd:	89 e5                	mov    %esp,%ebp
  800dbf:	57                   	push   %edi
  800dc0:	56                   	push   %esi
  800dc1:	53                   	push   %ebx
  800dc2:	83 ec 18             	sub    $0x18,%esp
  800dc5:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800dc8:	57                   	push   %edi
  800dc9:	e8 74 f6 ff ff       	call   800442 <fd2data>
  800dce:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800dd0:	83 c4 10             	add    $0x10,%esp
  800dd3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dd8:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800ddb:	74 46                	je     800e23 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800ddd:	8b 06                	mov    (%esi),%eax
  800ddf:	3b 46 04             	cmp    0x4(%esi),%eax
  800de2:	75 22                	jne    800e06 <devpipe_read+0x4a>
			if (i > 0)
  800de4:	85 db                	test   %ebx,%ebx
  800de6:	74 0a                	je     800df2 <devpipe_read+0x36>
				return i;
  800de8:	89 d8                	mov    %ebx,%eax
}
  800dea:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ded:	5b                   	pop    %ebx
  800dee:	5e                   	pop    %esi
  800def:	5f                   	pop    %edi
  800df0:	5d                   	pop    %ebp
  800df1:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800df2:	89 f2                	mov    %esi,%edx
  800df4:	89 f8                	mov    %edi,%eax
  800df6:	e8 e9 fe ff ff       	call   800ce4 <_pipeisclosed>
  800dfb:	85 c0                	test   %eax,%eax
  800dfd:	75 28                	jne    800e27 <devpipe_read+0x6b>
			sys_yield();
  800dff:	e8 1a f4 ff ff       	call   80021e <sys_yield>
  800e04:	eb d7                	jmp    800ddd <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e06:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800e0b:	78 0f                	js     800e1c <devpipe_read+0x60>
  800e0d:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800e11:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800e14:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800e17:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800e19:	43                   	inc    %ebx
  800e1a:	eb bc                	jmp    800dd8 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e1c:	48                   	dec    %eax
  800e1d:	83 c8 e0             	or     $0xffffffe0,%eax
  800e20:	40                   	inc    %eax
  800e21:	eb ea                	jmp    800e0d <devpipe_read+0x51>
	return i;
  800e23:	89 d8                	mov    %ebx,%eax
  800e25:	eb c3                	jmp    800dea <devpipe_read+0x2e>
				return 0;
  800e27:	b8 00 00 00 00       	mov    $0x0,%eax
  800e2c:	eb bc                	jmp    800dea <devpipe_read+0x2e>

00800e2e <pipe>:
{
  800e2e:	55                   	push   %ebp
  800e2f:	89 e5                	mov    %esp,%ebp
  800e31:	56                   	push   %esi
  800e32:	53                   	push   %ebx
  800e33:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 1a f6 ff ff       	call   800459 <fd_alloc>
  800e3f:	89 c3                	mov    %eax,%ebx
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	85 c0                	test   %eax,%eax
  800e46:	0f 88 2a 01 00 00    	js     800f76 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	68 07 04 00 00       	push   $0x407
  800e54:	ff 75 f4             	pushl  -0xc(%ebp)
  800e57:	6a 00                	push   $0x0
  800e59:	e8 f9 f2 ff ff       	call   800157 <sys_page_alloc>
  800e5e:	89 c3                	mov    %eax,%ebx
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	85 c0                	test   %eax,%eax
  800e65:	0f 88 0b 01 00 00    	js     800f76 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e71:	50                   	push   %eax
  800e72:	e8 e2 f5 ff ff       	call   800459 <fd_alloc>
  800e77:	89 c3                	mov    %eax,%ebx
  800e79:	83 c4 10             	add    $0x10,%esp
  800e7c:	85 c0                	test   %eax,%eax
  800e7e:	0f 88 e2 00 00 00    	js     800f66 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e84:	83 ec 04             	sub    $0x4,%esp
  800e87:	68 07 04 00 00       	push   $0x407
  800e8c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e8f:	6a 00                	push   $0x0
  800e91:	e8 c1 f2 ff ff       	call   800157 <sys_page_alloc>
  800e96:	89 c3                	mov    %eax,%ebx
  800e98:	83 c4 10             	add    $0x10,%esp
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	0f 88 c3 00 00 00    	js     800f66 <pipe+0x138>
	va = fd2data(fd0);
  800ea3:	83 ec 0c             	sub    $0xc,%esp
  800ea6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ea9:	e8 94 f5 ff ff       	call   800442 <fd2data>
  800eae:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800eb0:	83 c4 0c             	add    $0xc,%esp
  800eb3:	68 07 04 00 00       	push   $0x407
  800eb8:	50                   	push   %eax
  800eb9:	6a 00                	push   $0x0
  800ebb:	e8 97 f2 ff ff       	call   800157 <sys_page_alloc>
  800ec0:	89 c3                	mov    %eax,%ebx
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	85 c0                	test   %eax,%eax
  800ec7:	0f 88 89 00 00 00    	js     800f56 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800ecd:	83 ec 0c             	sub    $0xc,%esp
  800ed0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ed3:	e8 6a f5 ff ff       	call   800442 <fd2data>
  800ed8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800edf:	50                   	push   %eax
  800ee0:	6a 00                	push   $0x0
  800ee2:	56                   	push   %esi
  800ee3:	6a 00                	push   $0x0
  800ee5:	e8 b0 f2 ff ff       	call   80019a <sys_page_map>
  800eea:	89 c3                	mov    %eax,%ebx
  800eec:	83 c4 20             	add    $0x20,%esp
  800eef:	85 c0                	test   %eax,%eax
  800ef1:	78 55                	js     800f48 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ef3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800efc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800efe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f01:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800f08:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800f0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f11:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f16:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800f1d:	83 ec 0c             	sub    $0xc,%esp
  800f20:	ff 75 f4             	pushl  -0xc(%ebp)
  800f23:	e8 0a f5 ff ff       	call   800432 <fd2num>
  800f28:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f2b:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f2d:	83 c4 04             	add    $0x4,%esp
  800f30:	ff 75 f0             	pushl  -0x10(%ebp)
  800f33:	e8 fa f4 ff ff       	call   800432 <fd2num>
  800f38:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f3b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f3e:	83 c4 10             	add    $0x10,%esp
  800f41:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f46:	eb 2e                	jmp    800f76 <pipe+0x148>
	sys_page_unmap(0, va);
  800f48:	83 ec 08             	sub    $0x8,%esp
  800f4b:	56                   	push   %esi
  800f4c:	6a 00                	push   $0x0
  800f4e:	e8 89 f2 ff ff       	call   8001dc <sys_page_unmap>
  800f53:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f56:	83 ec 08             	sub    $0x8,%esp
  800f59:	ff 75 f0             	pushl  -0x10(%ebp)
  800f5c:	6a 00                	push   $0x0
  800f5e:	e8 79 f2 ff ff       	call   8001dc <sys_page_unmap>
  800f63:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f66:	83 ec 08             	sub    $0x8,%esp
  800f69:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6c:	6a 00                	push   $0x0
  800f6e:	e8 69 f2 ff ff       	call   8001dc <sys_page_unmap>
  800f73:	83 c4 10             	add    $0x10,%esp
}
  800f76:	89 d8                	mov    %ebx,%eax
  800f78:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f7b:	5b                   	pop    %ebx
  800f7c:	5e                   	pop    %esi
  800f7d:	5d                   	pop    %ebp
  800f7e:	c3                   	ret    

00800f7f <pipeisclosed>:
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f85:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f88:	50                   	push   %eax
  800f89:	ff 75 08             	pushl  0x8(%ebp)
  800f8c:	e8 17 f5 ff ff       	call   8004a8 <fd_lookup>
  800f91:	83 c4 10             	add    $0x10,%esp
  800f94:	85 c0                	test   %eax,%eax
  800f96:	78 18                	js     800fb0 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	e8 9f f4 ff ff       	call   800442 <fd2data>
	return _pipeisclosed(fd, p);
  800fa3:	89 c2                	mov    %eax,%edx
  800fa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800fa8:	e8 37 fd ff ff       	call   800ce4 <_pipeisclosed>
  800fad:	83 c4 10             	add    $0x10,%esp
}
  800fb0:	c9                   	leave  
  800fb1:	c3                   	ret    

00800fb2 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800fb2:	55                   	push   %ebp
  800fb3:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800fb5:	b8 00 00 00 00       	mov    $0x0,%eax
  800fba:	5d                   	pop    %ebp
  800fbb:	c3                   	ret    

00800fbc <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	53                   	push   %ebx
  800fc0:	83 ec 0c             	sub    $0xc,%esp
  800fc3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800fc6:	68 96 20 80 00       	push   $0x802096
  800fcb:	53                   	push   %ebx
  800fcc:	e8 87 08 00 00       	call   801858 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800fd1:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fd8:	20 00 00 
	return 0;
}
  800fdb:	b8 00 00 00 00       	mov    $0x0,%eax
  800fe0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fe3:	c9                   	leave  
  800fe4:	c3                   	ret    

00800fe5 <devcons_write>:
{
  800fe5:	55                   	push   %ebp
  800fe6:	89 e5                	mov    %esp,%ebp
  800fe8:	57                   	push   %edi
  800fe9:	56                   	push   %esi
  800fea:	53                   	push   %ebx
  800feb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800ff1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800ff6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800ffc:	eb 1d                	jmp    80101b <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800ffe:	83 ec 04             	sub    $0x4,%esp
  801001:	53                   	push   %ebx
  801002:	03 45 0c             	add    0xc(%ebp),%eax
  801005:	50                   	push   %eax
  801006:	57                   	push   %edi
  801007:	e8 bf 09 00 00       	call   8019cb <memmove>
		sys_cputs(buf, m);
  80100c:	83 c4 08             	add    $0x8,%esp
  80100f:	53                   	push   %ebx
  801010:	57                   	push   %edi
  801011:	e8 a4 f0 ff ff       	call   8000ba <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801016:	01 de                	add    %ebx,%esi
  801018:	83 c4 10             	add    $0x10,%esp
  80101b:	89 f0                	mov    %esi,%eax
  80101d:	3b 75 10             	cmp    0x10(%ebp),%esi
  801020:	73 11                	jae    801033 <devcons_write+0x4e>
		m = n - tot;
  801022:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801025:	29 f3                	sub    %esi,%ebx
  801027:	83 fb 7f             	cmp    $0x7f,%ebx
  80102a:	76 d2                	jbe    800ffe <devcons_write+0x19>
  80102c:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801031:	eb cb                	jmp    800ffe <devcons_write+0x19>
}
  801033:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801036:	5b                   	pop    %ebx
  801037:	5e                   	pop    %esi
  801038:	5f                   	pop    %edi
  801039:	5d                   	pop    %ebp
  80103a:	c3                   	ret    

0080103b <devcons_read>:
{
  80103b:	55                   	push   %ebp
  80103c:	89 e5                	mov    %esp,%ebp
  80103e:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801041:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801045:	75 0c                	jne    801053 <devcons_read+0x18>
		return 0;
  801047:	b8 00 00 00 00       	mov    $0x0,%eax
  80104c:	eb 21                	jmp    80106f <devcons_read+0x34>
		sys_yield();
  80104e:	e8 cb f1 ff ff       	call   80021e <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801053:	e8 80 f0 ff ff       	call   8000d8 <sys_cgetc>
  801058:	85 c0                	test   %eax,%eax
  80105a:	74 f2                	je     80104e <devcons_read+0x13>
	if (c < 0)
  80105c:	85 c0                	test   %eax,%eax
  80105e:	78 0f                	js     80106f <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801060:	83 f8 04             	cmp    $0x4,%eax
  801063:	74 0c                	je     801071 <devcons_read+0x36>
	*(char*)vbuf = c;
  801065:	8b 55 0c             	mov    0xc(%ebp),%edx
  801068:	88 02                	mov    %al,(%edx)
	return 1;
  80106a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80106f:	c9                   	leave  
  801070:	c3                   	ret    
		return 0;
  801071:	b8 00 00 00 00       	mov    $0x0,%eax
  801076:	eb f7                	jmp    80106f <devcons_read+0x34>

00801078 <cputchar>:
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801084:	6a 01                	push   $0x1
  801086:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801089:	50                   	push   %eax
  80108a:	e8 2b f0 ff ff       	call   8000ba <sys_cputs>
}
  80108f:	83 c4 10             	add    $0x10,%esp
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <getchar>:
{
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80109a:	6a 01                	push   $0x1
  80109c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80109f:	50                   	push   %eax
  8010a0:	6a 00                	push   $0x0
  8010a2:	e8 6e f6 ff ff       	call   800715 <read>
	if (r < 0)
  8010a7:	83 c4 10             	add    $0x10,%esp
  8010aa:	85 c0                	test   %eax,%eax
  8010ac:	78 08                	js     8010b6 <getchar+0x22>
	if (r < 1)
  8010ae:	85 c0                	test   %eax,%eax
  8010b0:	7e 06                	jle    8010b8 <getchar+0x24>
	return c;
  8010b2:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8010b6:	c9                   	leave  
  8010b7:	c3                   	ret    
		return -E_EOF;
  8010b8:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8010bd:	eb f7                	jmp    8010b6 <getchar+0x22>

008010bf <iscons>:
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c8:	50                   	push   %eax
  8010c9:	ff 75 08             	pushl  0x8(%ebp)
  8010cc:	e8 d7 f3 ff ff       	call   8004a8 <fd_lookup>
  8010d1:	83 c4 10             	add    $0x10,%esp
  8010d4:	85 c0                	test   %eax,%eax
  8010d6:	78 11                	js     8010e9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010db:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010e1:	39 10                	cmp    %edx,(%eax)
  8010e3:	0f 94 c0             	sete   %al
  8010e6:	0f b6 c0             	movzbl %al,%eax
}
  8010e9:	c9                   	leave  
  8010ea:	c3                   	ret    

008010eb <opencons>:
{
  8010eb:	55                   	push   %ebp
  8010ec:	89 e5                	mov    %esp,%ebp
  8010ee:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010f1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010f4:	50                   	push   %eax
  8010f5:	e8 5f f3 ff ff       	call   800459 <fd_alloc>
  8010fa:	83 c4 10             	add    $0x10,%esp
  8010fd:	85 c0                	test   %eax,%eax
  8010ff:	78 3a                	js     80113b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  801101:	83 ec 04             	sub    $0x4,%esp
  801104:	68 07 04 00 00       	push   $0x407
  801109:	ff 75 f4             	pushl  -0xc(%ebp)
  80110c:	6a 00                	push   $0x0
  80110e:	e8 44 f0 ff ff       	call   800157 <sys_page_alloc>
  801113:	83 c4 10             	add    $0x10,%esp
  801116:	85 c0                	test   %eax,%eax
  801118:	78 21                	js     80113b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  80111a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  801120:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801123:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801125:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801128:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80112f:	83 ec 0c             	sub    $0xc,%esp
  801132:	50                   	push   %eax
  801133:	e8 fa f2 ff ff       	call   800432 <fd2num>
  801138:	83 c4 10             	add    $0x10,%esp
}
  80113b:	c9                   	leave  
  80113c:	c3                   	ret    

0080113d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80113d:	55                   	push   %ebp
  80113e:	89 e5                	mov    %esp,%ebp
  801140:	57                   	push   %edi
  801141:	56                   	push   %esi
  801142:	53                   	push   %ebx
  801143:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801149:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80114c:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801152:	e8 e1 ef ff ff       	call   800138 <sys_getenvid>
  801157:	83 ec 04             	sub    $0x4,%esp
  80115a:	ff 75 0c             	pushl  0xc(%ebp)
  80115d:	ff 75 08             	pushl  0x8(%ebp)
  801160:	53                   	push   %ebx
  801161:	50                   	push   %eax
  801162:	68 a4 20 80 00       	push   $0x8020a4
  801167:	68 00 01 00 00       	push   $0x100
  80116c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801172:	56                   	push   %esi
  801173:	e8 93 06 00 00       	call   80180b <snprintf>
  801178:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80117a:	83 c4 20             	add    $0x20,%esp
  80117d:	57                   	push   %edi
  80117e:	ff 75 10             	pushl  0x10(%ebp)
  801181:	bf 00 01 00 00       	mov    $0x100,%edi
  801186:	89 f8                	mov    %edi,%eax
  801188:	29 d8                	sub    %ebx,%eax
  80118a:	50                   	push   %eax
  80118b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80118e:	50                   	push   %eax
  80118f:	e8 22 06 00 00       	call   8017b6 <vsnprintf>
  801194:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801196:	83 c4 0c             	add    $0xc,%esp
  801199:	68 8f 20 80 00       	push   $0x80208f
  80119e:	29 df                	sub    %ebx,%edi
  8011a0:	57                   	push   %edi
  8011a1:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  8011a4:	50                   	push   %eax
  8011a5:	e8 61 06 00 00       	call   80180b <snprintf>
	sys_cputs(buf, r);
  8011aa:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  8011ad:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  8011af:	53                   	push   %ebx
  8011b0:	56                   	push   %esi
  8011b1:	e8 04 ef ff ff       	call   8000ba <sys_cputs>
  8011b6:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011b9:	cc                   	int3   
  8011ba:	eb fd                	jmp    8011b9 <_panic+0x7c>

008011bc <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8011bc:	55                   	push   %ebp
  8011bd:	89 e5                	mov    %esp,%ebp
  8011bf:	53                   	push   %ebx
  8011c0:	83 ec 04             	sub    $0x4,%esp
  8011c3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8011c6:	8b 13                	mov    (%ebx),%edx
  8011c8:	8d 42 01             	lea    0x1(%edx),%eax
  8011cb:	89 03                	mov    %eax,(%ebx)
  8011cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011d0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8011d4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011d9:	74 08                	je     8011e3 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011db:	ff 43 04             	incl   0x4(%ebx)
}
  8011de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011e1:	c9                   	leave  
  8011e2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011e3:	83 ec 08             	sub    $0x8,%esp
  8011e6:	68 ff 00 00 00       	push   $0xff
  8011eb:	8d 43 08             	lea    0x8(%ebx),%eax
  8011ee:	50                   	push   %eax
  8011ef:	e8 c6 ee ff ff       	call   8000ba <sys_cputs>
		b->idx = 0;
  8011f4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011fa:	83 c4 10             	add    $0x10,%esp
  8011fd:	eb dc                	jmp    8011db <putch+0x1f>

008011ff <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011ff:	55                   	push   %ebp
  801200:	89 e5                	mov    %esp,%ebp
  801202:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  801208:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80120f:	00 00 00 
	b.cnt = 0;
  801212:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801219:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  80121c:	ff 75 0c             	pushl  0xc(%ebp)
  80121f:	ff 75 08             	pushl  0x8(%ebp)
  801222:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801228:	50                   	push   %eax
  801229:	68 bc 11 80 00       	push   $0x8011bc
  80122e:	e8 17 01 00 00       	call   80134a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801233:	83 c4 08             	add    $0x8,%esp
  801236:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80123c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801242:	50                   	push   %eax
  801243:	e8 72 ee ff ff       	call   8000ba <sys_cputs>

	return b.cnt;
}
  801248:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80124e:	c9                   	leave  
  80124f:	c3                   	ret    

00801250 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801250:	55                   	push   %ebp
  801251:	89 e5                	mov    %esp,%ebp
  801253:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801256:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801259:	50                   	push   %eax
  80125a:	ff 75 08             	pushl  0x8(%ebp)
  80125d:	e8 9d ff ff ff       	call   8011ff <vcprintf>
	va_end(ap);

	return cnt;
}
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	57                   	push   %edi
  801268:	56                   	push   %esi
  801269:	53                   	push   %ebx
  80126a:	83 ec 1c             	sub    $0x1c,%esp
  80126d:	89 c7                	mov    %eax,%edi
  80126f:	89 d6                	mov    %edx,%esi
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8b 55 0c             	mov    0xc(%ebp),%edx
  801277:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80127a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80127d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801280:	bb 00 00 00 00       	mov    $0x0,%ebx
  801285:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801288:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80128b:	39 d3                	cmp    %edx,%ebx
  80128d:	72 05                	jb     801294 <printnum+0x30>
  80128f:	39 45 10             	cmp    %eax,0x10(%ebp)
  801292:	77 78                	ja     80130c <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801294:	83 ec 0c             	sub    $0xc,%esp
  801297:	ff 75 18             	pushl  0x18(%ebp)
  80129a:	8b 45 14             	mov    0x14(%ebp),%eax
  80129d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8012a0:	53                   	push   %ebx
  8012a1:	ff 75 10             	pushl  0x10(%ebp)
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012aa:	ff 75 e0             	pushl  -0x20(%ebp)
  8012ad:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b0:	ff 75 d8             	pushl  -0x28(%ebp)
  8012b3:	e8 68 0a 00 00       	call   801d20 <__udivdi3>
  8012b8:	83 c4 18             	add    $0x18,%esp
  8012bb:	52                   	push   %edx
  8012bc:	50                   	push   %eax
  8012bd:	89 f2                	mov    %esi,%edx
  8012bf:	89 f8                	mov    %edi,%eax
  8012c1:	e8 9e ff ff ff       	call   801264 <printnum>
  8012c6:	83 c4 20             	add    $0x20,%esp
  8012c9:	eb 11                	jmp    8012dc <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012cb:	83 ec 08             	sub    $0x8,%esp
  8012ce:	56                   	push   %esi
  8012cf:	ff 75 18             	pushl  0x18(%ebp)
  8012d2:	ff d7                	call   *%edi
  8012d4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8012d7:	4b                   	dec    %ebx
  8012d8:	85 db                	test   %ebx,%ebx
  8012da:	7f ef                	jg     8012cb <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012dc:	83 ec 08             	sub    $0x8,%esp
  8012df:	56                   	push   %esi
  8012e0:	83 ec 04             	sub    $0x4,%esp
  8012e3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012e6:	ff 75 e0             	pushl  -0x20(%ebp)
  8012e9:	ff 75 dc             	pushl  -0x24(%ebp)
  8012ec:	ff 75 d8             	pushl  -0x28(%ebp)
  8012ef:	e8 3c 0b 00 00       	call   801e30 <__umoddi3>
  8012f4:	83 c4 14             	add    $0x14,%esp
  8012f7:	0f be 80 c7 20 80 00 	movsbl 0x8020c7(%eax),%eax
  8012fe:	50                   	push   %eax
  8012ff:	ff d7                	call   *%edi
}
  801301:	83 c4 10             	add    $0x10,%esp
  801304:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801307:	5b                   	pop    %ebx
  801308:	5e                   	pop    %esi
  801309:	5f                   	pop    %edi
  80130a:	5d                   	pop    %ebp
  80130b:	c3                   	ret    
  80130c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80130f:	eb c6                	jmp    8012d7 <printnum+0x73>

00801311 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801311:	55                   	push   %ebp
  801312:	89 e5                	mov    %esp,%ebp
  801314:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801317:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  80131a:	8b 10                	mov    (%eax),%edx
  80131c:	3b 50 04             	cmp    0x4(%eax),%edx
  80131f:	73 0a                	jae    80132b <sprintputch+0x1a>
		*b->buf++ = ch;
  801321:	8d 4a 01             	lea    0x1(%edx),%ecx
  801324:	89 08                	mov    %ecx,(%eax)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	88 02                	mov    %al,(%edx)
}
  80132b:	5d                   	pop    %ebp
  80132c:	c3                   	ret    

0080132d <printfmt>:
{
  80132d:	55                   	push   %ebp
  80132e:	89 e5                	mov    %esp,%ebp
  801330:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801333:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801336:	50                   	push   %eax
  801337:	ff 75 10             	pushl  0x10(%ebp)
  80133a:	ff 75 0c             	pushl  0xc(%ebp)
  80133d:	ff 75 08             	pushl  0x8(%ebp)
  801340:	e8 05 00 00 00       	call   80134a <vprintfmt>
}
  801345:	83 c4 10             	add    $0x10,%esp
  801348:	c9                   	leave  
  801349:	c3                   	ret    

0080134a <vprintfmt>:
{
  80134a:	55                   	push   %ebp
  80134b:	89 e5                	mov    %esp,%ebp
  80134d:	57                   	push   %edi
  80134e:	56                   	push   %esi
  80134f:	53                   	push   %ebx
  801350:	83 ec 2c             	sub    $0x2c,%esp
  801353:	8b 75 08             	mov    0x8(%ebp),%esi
  801356:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801359:	8b 7d 10             	mov    0x10(%ebp),%edi
  80135c:	e9 ae 03 00 00       	jmp    80170f <vprintfmt+0x3c5>
  801361:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801365:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80136c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801373:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80137a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80137f:	8d 47 01             	lea    0x1(%edi),%eax
  801382:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801385:	8a 17                	mov    (%edi),%dl
  801387:	8d 42 dd             	lea    -0x23(%edx),%eax
  80138a:	3c 55                	cmp    $0x55,%al
  80138c:	0f 87 fe 03 00 00    	ja     801790 <vprintfmt+0x446>
  801392:	0f b6 c0             	movzbl %al,%eax
  801395:	ff 24 85 00 22 80 00 	jmp    *0x802200(,%eax,4)
  80139c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80139f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  8013a3:	eb da                	jmp    80137f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8013a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  8013a8:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  8013ac:	eb d1                	jmp    80137f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  8013ae:	0f b6 d2             	movzbl %dl,%edx
  8013b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013b4:	b8 00 00 00 00       	mov    $0x0,%eax
  8013b9:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8013bc:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8013bf:	01 c0                	add    %eax,%eax
  8013c1:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8013c5:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8013c8:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8013cb:	83 f9 09             	cmp    $0x9,%ecx
  8013ce:	77 52                	ja     801422 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8013d0:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8013d1:	eb e9                	jmp    8013bc <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8013d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013d6:	8b 00                	mov    (%eax),%eax
  8013d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013db:	8b 45 14             	mov    0x14(%ebp),%eax
  8013de:	8d 40 04             	lea    0x4(%eax),%eax
  8013e1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013e4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013eb:	79 92                	jns    80137f <vprintfmt+0x35>
				width = precision, precision = -1;
  8013ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013f3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013fa:	eb 83                	jmp    80137f <vprintfmt+0x35>
  8013fc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801400:	78 08                	js     80140a <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  801402:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801405:	e9 75 ff ff ff       	jmp    80137f <vprintfmt+0x35>
  80140a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  801411:	eb ef                	jmp    801402 <vprintfmt+0xb8>
  801413:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801416:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  80141d:	e9 5d ff ff ff       	jmp    80137f <vprintfmt+0x35>
  801422:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801425:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801428:	eb bd                	jmp    8013e7 <vprintfmt+0x9d>
			lflag++;
  80142a:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  80142b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  80142e:	e9 4c ff ff ff       	jmp    80137f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801433:	8b 45 14             	mov    0x14(%ebp),%eax
  801436:	8d 78 04             	lea    0x4(%eax),%edi
  801439:	83 ec 08             	sub    $0x8,%esp
  80143c:	53                   	push   %ebx
  80143d:	ff 30                	pushl  (%eax)
  80143f:	ff d6                	call   *%esi
			break;
  801441:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801444:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801447:	e9 c0 02 00 00       	jmp    80170c <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80144c:	8b 45 14             	mov    0x14(%ebp),%eax
  80144f:	8d 78 04             	lea    0x4(%eax),%edi
  801452:	8b 00                	mov    (%eax),%eax
  801454:	85 c0                	test   %eax,%eax
  801456:	78 2a                	js     801482 <vprintfmt+0x138>
  801458:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80145a:	83 f8 0f             	cmp    $0xf,%eax
  80145d:	7f 27                	jg     801486 <vprintfmt+0x13c>
  80145f:	8b 04 85 60 23 80 00 	mov    0x802360(,%eax,4),%eax
  801466:	85 c0                	test   %eax,%eax
  801468:	74 1c                	je     801486 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80146a:	50                   	push   %eax
  80146b:	68 5d 20 80 00       	push   $0x80205d
  801470:	53                   	push   %ebx
  801471:	56                   	push   %esi
  801472:	e8 b6 fe ff ff       	call   80132d <printfmt>
  801477:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80147a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80147d:	e9 8a 02 00 00       	jmp    80170c <vprintfmt+0x3c2>
  801482:	f7 d8                	neg    %eax
  801484:	eb d2                	jmp    801458 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801486:	52                   	push   %edx
  801487:	68 df 20 80 00       	push   $0x8020df
  80148c:	53                   	push   %ebx
  80148d:	56                   	push   %esi
  80148e:	e8 9a fe ff ff       	call   80132d <printfmt>
  801493:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801496:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801499:	e9 6e 02 00 00       	jmp    80170c <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80149e:	8b 45 14             	mov    0x14(%ebp),%eax
  8014a1:	83 c0 04             	add    $0x4,%eax
  8014a4:	89 45 cc             	mov    %eax,-0x34(%ebp)
  8014a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8014aa:	8b 38                	mov    (%eax),%edi
  8014ac:	85 ff                	test   %edi,%edi
  8014ae:	74 39                	je     8014e9 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  8014b0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8014b4:	0f 8e a9 00 00 00    	jle    801563 <vprintfmt+0x219>
  8014ba:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8014be:	0f 84 a7 00 00 00    	je     80156b <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8014c4:	83 ec 08             	sub    $0x8,%esp
  8014c7:	ff 75 d0             	pushl  -0x30(%ebp)
  8014ca:	57                   	push   %edi
  8014cb:	e8 6b 03 00 00       	call   80183b <strnlen>
  8014d0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014d3:	29 c1                	sub    %eax,%ecx
  8014d5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014d8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014db:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014df:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014e2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014e5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014e7:	eb 14                	jmp    8014fd <vprintfmt+0x1b3>
				p = "(null)";
  8014e9:	bf d8 20 80 00       	mov    $0x8020d8,%edi
  8014ee:	eb c0                	jmp    8014b0 <vprintfmt+0x166>
					putch(padc, putdat);
  8014f0:	83 ec 08             	sub    $0x8,%esp
  8014f3:	53                   	push   %ebx
  8014f4:	ff 75 e0             	pushl  -0x20(%ebp)
  8014f7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014f9:	4f                   	dec    %edi
  8014fa:	83 c4 10             	add    $0x10,%esp
  8014fd:	85 ff                	test   %edi,%edi
  8014ff:	7f ef                	jg     8014f0 <vprintfmt+0x1a6>
  801501:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  801504:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801507:	89 c8                	mov    %ecx,%eax
  801509:	85 c9                	test   %ecx,%ecx
  80150b:	78 10                	js     80151d <vprintfmt+0x1d3>
  80150d:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  801510:	29 c1                	sub    %eax,%ecx
  801512:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801515:	89 75 08             	mov    %esi,0x8(%ebp)
  801518:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80151b:	eb 15                	jmp    801532 <vprintfmt+0x1e8>
  80151d:	b8 00 00 00 00       	mov    $0x0,%eax
  801522:	eb e9                	jmp    80150d <vprintfmt+0x1c3>
					putch(ch, putdat);
  801524:	83 ec 08             	sub    $0x8,%esp
  801527:	53                   	push   %ebx
  801528:	52                   	push   %edx
  801529:	ff 55 08             	call   *0x8(%ebp)
  80152c:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80152f:	ff 4d e0             	decl   -0x20(%ebp)
  801532:	47                   	inc    %edi
  801533:	8a 47 ff             	mov    -0x1(%edi),%al
  801536:	0f be d0             	movsbl %al,%edx
  801539:	85 d2                	test   %edx,%edx
  80153b:	74 59                	je     801596 <vprintfmt+0x24c>
  80153d:	85 f6                	test   %esi,%esi
  80153f:	78 03                	js     801544 <vprintfmt+0x1fa>
  801541:	4e                   	dec    %esi
  801542:	78 2f                	js     801573 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801544:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801548:	74 da                	je     801524 <vprintfmt+0x1da>
  80154a:	0f be c0             	movsbl %al,%eax
  80154d:	83 e8 20             	sub    $0x20,%eax
  801550:	83 f8 5e             	cmp    $0x5e,%eax
  801553:	76 cf                	jbe    801524 <vprintfmt+0x1da>
					putch('?', putdat);
  801555:	83 ec 08             	sub    $0x8,%esp
  801558:	53                   	push   %ebx
  801559:	6a 3f                	push   $0x3f
  80155b:	ff 55 08             	call   *0x8(%ebp)
  80155e:	83 c4 10             	add    $0x10,%esp
  801561:	eb cc                	jmp    80152f <vprintfmt+0x1e5>
  801563:	89 75 08             	mov    %esi,0x8(%ebp)
  801566:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801569:	eb c7                	jmp    801532 <vprintfmt+0x1e8>
  80156b:	89 75 08             	mov    %esi,0x8(%ebp)
  80156e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801571:	eb bf                	jmp    801532 <vprintfmt+0x1e8>
  801573:	8b 75 08             	mov    0x8(%ebp),%esi
  801576:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801579:	eb 0c                	jmp    801587 <vprintfmt+0x23d>
				putch(' ', putdat);
  80157b:	83 ec 08             	sub    $0x8,%esp
  80157e:	53                   	push   %ebx
  80157f:	6a 20                	push   $0x20
  801581:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801583:	4f                   	dec    %edi
  801584:	83 c4 10             	add    $0x10,%esp
  801587:	85 ff                	test   %edi,%edi
  801589:	7f f0                	jg     80157b <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80158b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80158e:	89 45 14             	mov    %eax,0x14(%ebp)
  801591:	e9 76 01 00 00       	jmp    80170c <vprintfmt+0x3c2>
  801596:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801599:	8b 75 08             	mov    0x8(%ebp),%esi
  80159c:	eb e9                	jmp    801587 <vprintfmt+0x23d>
	if (lflag >= 2)
  80159e:	83 f9 01             	cmp    $0x1,%ecx
  8015a1:	7f 1f                	jg     8015c2 <vprintfmt+0x278>
	else if (lflag)
  8015a3:	85 c9                	test   %ecx,%ecx
  8015a5:	75 48                	jne    8015ef <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  8015a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015aa:	8b 00                	mov    (%eax),%eax
  8015ac:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015af:	89 c1                	mov    %eax,%ecx
  8015b1:	c1 f9 1f             	sar    $0x1f,%ecx
  8015b4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ba:	8d 40 04             	lea    0x4(%eax),%eax
  8015bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8015c0:	eb 17                	jmp    8015d9 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8015c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c5:	8b 50 04             	mov    0x4(%eax),%edx
  8015c8:	8b 00                	mov    (%eax),%eax
  8015ca:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015cd:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d3:	8d 40 08             	lea    0x8(%eax),%eax
  8015d6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015dc:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015df:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015e3:	78 25                	js     80160a <vprintfmt+0x2c0>
			base = 10;
  8015e5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ea:	e9 03 01 00 00       	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f2:	8b 00                	mov    (%eax),%eax
  8015f4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015f7:	89 c1                	mov    %eax,%ecx
  8015f9:	c1 f9 1f             	sar    $0x1f,%ecx
  8015fc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015ff:	8b 45 14             	mov    0x14(%ebp),%eax
  801602:	8d 40 04             	lea    0x4(%eax),%eax
  801605:	89 45 14             	mov    %eax,0x14(%ebp)
  801608:	eb cf                	jmp    8015d9 <vprintfmt+0x28f>
				putch('-', putdat);
  80160a:	83 ec 08             	sub    $0x8,%esp
  80160d:	53                   	push   %ebx
  80160e:	6a 2d                	push   $0x2d
  801610:	ff d6                	call   *%esi
				num = -(long long) num;
  801612:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801615:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801618:	f7 da                	neg    %edx
  80161a:	83 d1 00             	adc    $0x0,%ecx
  80161d:	f7 d9                	neg    %ecx
  80161f:	83 c4 10             	add    $0x10,%esp
			base = 10;
  801622:	b8 0a 00 00 00       	mov    $0xa,%eax
  801627:	e9 c6 00 00 00       	jmp    8016f2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80162c:	83 f9 01             	cmp    $0x1,%ecx
  80162f:	7f 1e                	jg     80164f <vprintfmt+0x305>
	else if (lflag)
  801631:	85 c9                	test   %ecx,%ecx
  801633:	75 32                	jne    801667 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801635:	8b 45 14             	mov    0x14(%ebp),%eax
  801638:	8b 10                	mov    (%eax),%edx
  80163a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80163f:	8d 40 04             	lea    0x4(%eax),%eax
  801642:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801645:	b8 0a 00 00 00       	mov    $0xa,%eax
  80164a:	e9 a3 00 00 00       	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80164f:	8b 45 14             	mov    0x14(%ebp),%eax
  801652:	8b 10                	mov    (%eax),%edx
  801654:	8b 48 04             	mov    0x4(%eax),%ecx
  801657:	8d 40 08             	lea    0x8(%eax),%eax
  80165a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80165d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801662:	e9 8b 00 00 00       	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801667:	8b 45 14             	mov    0x14(%ebp),%eax
  80166a:	8b 10                	mov    (%eax),%edx
  80166c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801671:	8d 40 04             	lea    0x4(%eax),%eax
  801674:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801677:	b8 0a 00 00 00       	mov    $0xa,%eax
  80167c:	eb 74                	jmp    8016f2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80167e:	83 f9 01             	cmp    $0x1,%ecx
  801681:	7f 1b                	jg     80169e <vprintfmt+0x354>
	else if (lflag)
  801683:	85 c9                	test   %ecx,%ecx
  801685:	75 2c                	jne    8016b3 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801687:	8b 45 14             	mov    0x14(%ebp),%eax
  80168a:	8b 10                	mov    (%eax),%edx
  80168c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801691:	8d 40 04             	lea    0x4(%eax),%eax
  801694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801697:	b8 08 00 00 00       	mov    $0x8,%eax
  80169c:	eb 54                	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8b 10                	mov    (%eax),%edx
  8016a3:	8b 48 04             	mov    0x4(%eax),%ecx
  8016a6:	8d 40 08             	lea    0x8(%eax),%eax
  8016a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8016ac:	b8 08 00 00 00       	mov    $0x8,%eax
  8016b1:	eb 3f                	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  8016b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016b6:	8b 10                	mov    (%eax),%edx
  8016b8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016bd:	8d 40 04             	lea    0x4(%eax),%eax
  8016c0:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8016c3:	b8 08 00 00 00       	mov    $0x8,%eax
  8016c8:	eb 28                	jmp    8016f2 <vprintfmt+0x3a8>
			putch('0', putdat);
  8016ca:	83 ec 08             	sub    $0x8,%esp
  8016cd:	53                   	push   %ebx
  8016ce:	6a 30                	push   $0x30
  8016d0:	ff d6                	call   *%esi
			putch('x', putdat);
  8016d2:	83 c4 08             	add    $0x8,%esp
  8016d5:	53                   	push   %ebx
  8016d6:	6a 78                	push   $0x78
  8016d8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016da:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dd:	8b 10                	mov    (%eax),%edx
  8016df:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016e4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016e7:	8d 40 04             	lea    0x4(%eax),%eax
  8016ea:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ed:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016f9:	57                   	push   %edi
  8016fa:	ff 75 e0             	pushl  -0x20(%ebp)
  8016fd:	50                   	push   %eax
  8016fe:	51                   	push   %ecx
  8016ff:	52                   	push   %edx
  801700:	89 da                	mov    %ebx,%edx
  801702:	89 f0                	mov    %esi,%eax
  801704:	e8 5b fb ff ff       	call   801264 <printnum>
			break;
  801709:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  80170c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80170f:	47                   	inc    %edi
  801710:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  801714:	83 f8 25             	cmp    $0x25,%eax
  801717:	0f 84 44 fc ff ff    	je     801361 <vprintfmt+0x17>
			if (ch == '\0')
  80171d:	85 c0                	test   %eax,%eax
  80171f:	0f 84 89 00 00 00    	je     8017ae <vprintfmt+0x464>
			putch(ch, putdat);
  801725:	83 ec 08             	sub    $0x8,%esp
  801728:	53                   	push   %ebx
  801729:	50                   	push   %eax
  80172a:	ff d6                	call   *%esi
  80172c:	83 c4 10             	add    $0x10,%esp
  80172f:	eb de                	jmp    80170f <vprintfmt+0x3c5>
	if (lflag >= 2)
  801731:	83 f9 01             	cmp    $0x1,%ecx
  801734:	7f 1b                	jg     801751 <vprintfmt+0x407>
	else if (lflag)
  801736:	85 c9                	test   %ecx,%ecx
  801738:	75 2c                	jne    801766 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80173a:	8b 45 14             	mov    0x14(%ebp),%eax
  80173d:	8b 10                	mov    (%eax),%edx
  80173f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801744:	8d 40 04             	lea    0x4(%eax),%eax
  801747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80174a:	b8 10 00 00 00       	mov    $0x10,%eax
  80174f:	eb a1                	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801751:	8b 45 14             	mov    0x14(%ebp),%eax
  801754:	8b 10                	mov    (%eax),%edx
  801756:	8b 48 04             	mov    0x4(%eax),%ecx
  801759:	8d 40 08             	lea    0x8(%eax),%eax
  80175c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80175f:	b8 10 00 00 00       	mov    $0x10,%eax
  801764:	eb 8c                	jmp    8016f2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801766:	8b 45 14             	mov    0x14(%ebp),%eax
  801769:	8b 10                	mov    (%eax),%edx
  80176b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801770:	8d 40 04             	lea    0x4(%eax),%eax
  801773:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801776:	b8 10 00 00 00       	mov    $0x10,%eax
  80177b:	e9 72 ff ff ff       	jmp    8016f2 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801780:	83 ec 08             	sub    $0x8,%esp
  801783:	53                   	push   %ebx
  801784:	6a 25                	push   $0x25
  801786:	ff d6                	call   *%esi
			break;
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	e9 7c ff ff ff       	jmp    80170c <vprintfmt+0x3c2>
			putch('%', putdat);
  801790:	83 ec 08             	sub    $0x8,%esp
  801793:	53                   	push   %ebx
  801794:	6a 25                	push   $0x25
  801796:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801798:	83 c4 10             	add    $0x10,%esp
  80179b:	89 f8                	mov    %edi,%eax
  80179d:	eb 01                	jmp    8017a0 <vprintfmt+0x456>
  80179f:	48                   	dec    %eax
  8017a0:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  8017a4:	75 f9                	jne    80179f <vprintfmt+0x455>
  8017a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8017a9:	e9 5e ff ff ff       	jmp    80170c <vprintfmt+0x3c2>
}
  8017ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8017b1:	5b                   	pop    %ebx
  8017b2:	5e                   	pop    %esi
  8017b3:	5f                   	pop    %edi
  8017b4:	5d                   	pop    %ebp
  8017b5:	c3                   	ret    

008017b6 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017b6:	55                   	push   %ebp
  8017b7:	89 e5                	mov    %esp,%ebp
  8017b9:	83 ec 18             	sub    $0x18,%esp
  8017bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bf:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8017c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c5:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8017c9:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8017cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017d3:	85 c0                	test   %eax,%eax
  8017d5:	74 26                	je     8017fd <vsnprintf+0x47>
  8017d7:	85 d2                	test   %edx,%edx
  8017d9:	7e 29                	jle    801804 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017db:	ff 75 14             	pushl  0x14(%ebp)
  8017de:	ff 75 10             	pushl  0x10(%ebp)
  8017e1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017e4:	50                   	push   %eax
  8017e5:	68 11 13 80 00       	push   $0x801311
  8017ea:	e8 5b fb ff ff       	call   80134a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017f2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017f8:	83 c4 10             	add    $0x10,%esp
}
  8017fb:	c9                   	leave  
  8017fc:	c3                   	ret    
		return -E_INVAL;
  8017fd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801802:	eb f7                	jmp    8017fb <vsnprintf+0x45>
  801804:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801809:	eb f0                	jmp    8017fb <vsnprintf+0x45>

0080180b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801811:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  801814:	50                   	push   %eax
  801815:	ff 75 10             	pushl  0x10(%ebp)
  801818:	ff 75 0c             	pushl  0xc(%ebp)
  80181b:	ff 75 08             	pushl  0x8(%ebp)
  80181e:	e8 93 ff ff ff       	call   8017b6 <vsnprintf>
	va_end(ap);

	return rc;
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  80182b:	b8 00 00 00 00       	mov    $0x0,%eax
  801830:	eb 01                	jmp    801833 <strlen+0xe>
		n++;
  801832:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801833:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801837:	75 f9                	jne    801832 <strlen+0xd>
	return n;
}
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801841:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801844:	b8 00 00 00 00       	mov    $0x0,%eax
  801849:	eb 01                	jmp    80184c <strnlen+0x11>
		n++;
  80184b:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80184c:	39 d0                	cmp    %edx,%eax
  80184e:	74 06                	je     801856 <strnlen+0x1b>
  801850:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801854:	75 f5                	jne    80184b <strnlen+0x10>
	return n;
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	53                   	push   %ebx
  80185c:	8b 45 08             	mov    0x8(%ebp),%eax
  80185f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801862:	89 c2                	mov    %eax,%edx
  801864:	42                   	inc    %edx
  801865:	41                   	inc    %ecx
  801866:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801869:	88 5a ff             	mov    %bl,-0x1(%edx)
  80186c:	84 db                	test   %bl,%bl
  80186e:	75 f4                	jne    801864 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801870:	5b                   	pop    %ebx
  801871:	5d                   	pop    %ebp
  801872:	c3                   	ret    

00801873 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801873:	55                   	push   %ebp
  801874:	89 e5                	mov    %esp,%ebp
  801876:	53                   	push   %ebx
  801877:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80187a:	53                   	push   %ebx
  80187b:	e8 a5 ff ff ff       	call   801825 <strlen>
  801880:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801883:	ff 75 0c             	pushl  0xc(%ebp)
  801886:	01 d8                	add    %ebx,%eax
  801888:	50                   	push   %eax
  801889:	e8 ca ff ff ff       	call   801858 <strcpy>
	return dst;
}
  80188e:	89 d8                	mov    %ebx,%eax
  801890:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	56                   	push   %esi
  801899:	53                   	push   %ebx
  80189a:	8b 75 08             	mov    0x8(%ebp),%esi
  80189d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8018a0:	89 f3                	mov    %esi,%ebx
  8018a2:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8018a5:	89 f2                	mov    %esi,%edx
  8018a7:	eb 0c                	jmp    8018b5 <strncpy+0x20>
		*dst++ = *src;
  8018a9:	42                   	inc    %edx
  8018aa:	8a 01                	mov    (%ecx),%al
  8018ac:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  8018af:	80 39 01             	cmpb   $0x1,(%ecx)
  8018b2:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8018b5:	39 da                	cmp    %ebx,%edx
  8018b7:	75 f0                	jne    8018a9 <strncpy+0x14>
	}
	return ret;
}
  8018b9:	89 f0                	mov    %esi,%eax
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5d                   	pop    %ebp
  8018be:	c3                   	ret    

008018bf <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
  8018c2:	56                   	push   %esi
  8018c3:	53                   	push   %ebx
  8018c4:	8b 75 08             	mov    0x8(%ebp),%esi
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8018cd:	85 c0                	test   %eax,%eax
  8018cf:	74 20                	je     8018f1 <strlcpy+0x32>
  8018d1:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8018d5:	89 f0                	mov    %esi,%eax
  8018d7:	eb 05                	jmp    8018de <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018d9:	40                   	inc    %eax
  8018da:	42                   	inc    %edx
  8018db:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018de:	39 d8                	cmp    %ebx,%eax
  8018e0:	74 06                	je     8018e8 <strlcpy+0x29>
  8018e2:	8a 0a                	mov    (%edx),%cl
  8018e4:	84 c9                	test   %cl,%cl
  8018e6:	75 f1                	jne    8018d9 <strlcpy+0x1a>
		*dst = '\0';
  8018e8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018eb:	29 f0                	sub    %esi,%eax
}
  8018ed:	5b                   	pop    %ebx
  8018ee:	5e                   	pop    %esi
  8018ef:	5d                   	pop    %ebp
  8018f0:	c3                   	ret    
  8018f1:	89 f0                	mov    %esi,%eax
  8018f3:	eb f6                	jmp    8018eb <strlcpy+0x2c>

008018f5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018f5:	55                   	push   %ebp
  8018f6:	89 e5                	mov    %esp,%ebp
  8018f8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018fb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018fe:	eb 02                	jmp    801902 <strcmp+0xd>
		p++, q++;
  801900:	41                   	inc    %ecx
  801901:	42                   	inc    %edx
	while (*p && *p == *q)
  801902:	8a 01                	mov    (%ecx),%al
  801904:	84 c0                	test   %al,%al
  801906:	74 04                	je     80190c <strcmp+0x17>
  801908:	3a 02                	cmp    (%edx),%al
  80190a:	74 f4                	je     801900 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80190c:	0f b6 c0             	movzbl %al,%eax
  80190f:	0f b6 12             	movzbl (%edx),%edx
  801912:	29 d0                	sub    %edx,%eax
}
  801914:	5d                   	pop    %ebp
  801915:	c3                   	ret    

00801916 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
  801919:	53                   	push   %ebx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801920:	89 c3                	mov    %eax,%ebx
  801922:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801925:	eb 02                	jmp    801929 <strncmp+0x13>
		n--, p++, q++;
  801927:	40                   	inc    %eax
  801928:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  801929:	39 d8                	cmp    %ebx,%eax
  80192b:	74 15                	je     801942 <strncmp+0x2c>
  80192d:	8a 08                	mov    (%eax),%cl
  80192f:	84 c9                	test   %cl,%cl
  801931:	74 04                	je     801937 <strncmp+0x21>
  801933:	3a 0a                	cmp    (%edx),%cl
  801935:	74 f0                	je     801927 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801937:	0f b6 00             	movzbl (%eax),%eax
  80193a:	0f b6 12             	movzbl (%edx),%edx
  80193d:	29 d0                	sub    %edx,%eax
}
  80193f:	5b                   	pop    %ebx
  801940:	5d                   	pop    %ebp
  801941:	c3                   	ret    
		return 0;
  801942:	b8 00 00 00 00       	mov    $0x0,%eax
  801947:	eb f6                	jmp    80193f <strncmp+0x29>

00801949 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
  80194c:	8b 45 08             	mov    0x8(%ebp),%eax
  80194f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801952:	8a 10                	mov    (%eax),%dl
  801954:	84 d2                	test   %dl,%dl
  801956:	74 07                	je     80195f <strchr+0x16>
		if (*s == c)
  801958:	38 ca                	cmp    %cl,%dl
  80195a:	74 08                	je     801964 <strchr+0x1b>
	for (; *s; s++)
  80195c:	40                   	inc    %eax
  80195d:	eb f3                	jmp    801952 <strchr+0x9>
			return (char *) s;
	return 0;
  80195f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801964:	5d                   	pop    %ebp
  801965:	c3                   	ret    

00801966 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
  801969:	8b 45 08             	mov    0x8(%ebp),%eax
  80196c:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80196f:	8a 10                	mov    (%eax),%dl
  801971:	84 d2                	test   %dl,%dl
  801973:	74 07                	je     80197c <strfind+0x16>
		if (*s == c)
  801975:	38 ca                	cmp    %cl,%dl
  801977:	74 03                	je     80197c <strfind+0x16>
	for (; *s; s++)
  801979:	40                   	inc    %eax
  80197a:	eb f3                	jmp    80196f <strfind+0x9>
			break;
	return (char *) s;
}
  80197c:	5d                   	pop    %ebp
  80197d:	c3                   	ret    

0080197e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
  801981:	57                   	push   %edi
  801982:	56                   	push   %esi
  801983:	53                   	push   %ebx
  801984:	8b 7d 08             	mov    0x8(%ebp),%edi
  801987:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80198a:	85 c9                	test   %ecx,%ecx
  80198c:	74 13                	je     8019a1 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80198e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801994:	75 05                	jne    80199b <memset+0x1d>
  801996:	f6 c1 03             	test   $0x3,%cl
  801999:	74 0d                	je     8019a8 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80199b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80199e:	fc                   	cld    
  80199f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  8019a1:	89 f8                	mov    %edi,%eax
  8019a3:	5b                   	pop    %ebx
  8019a4:	5e                   	pop    %esi
  8019a5:	5f                   	pop    %edi
  8019a6:	5d                   	pop    %ebp
  8019a7:	c3                   	ret    
		c &= 0xFF;
  8019a8:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  8019ac:	89 d3                	mov    %edx,%ebx
  8019ae:	c1 e3 08             	shl    $0x8,%ebx
  8019b1:	89 d0                	mov    %edx,%eax
  8019b3:	c1 e0 18             	shl    $0x18,%eax
  8019b6:	89 d6                	mov    %edx,%esi
  8019b8:	c1 e6 10             	shl    $0x10,%esi
  8019bb:	09 f0                	or     %esi,%eax
  8019bd:	09 c2                	or     %eax,%edx
  8019bf:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8019c1:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8019c4:	89 d0                	mov    %edx,%eax
  8019c6:	fc                   	cld    
  8019c7:	f3 ab                	rep stos %eax,%es:(%edi)
  8019c9:	eb d6                	jmp    8019a1 <memset+0x23>

008019cb <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019cb:	55                   	push   %ebp
  8019cc:	89 e5                	mov    %esp,%ebp
  8019ce:	57                   	push   %edi
  8019cf:	56                   	push   %esi
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019d9:	39 c6                	cmp    %eax,%esi
  8019db:	73 33                	jae    801a10 <memmove+0x45>
  8019dd:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019e0:	39 d0                	cmp    %edx,%eax
  8019e2:	73 2c                	jae    801a10 <memmove+0x45>
		s += n;
		d += n;
  8019e4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019e7:	89 d6                	mov    %edx,%esi
  8019e9:	09 fe                	or     %edi,%esi
  8019eb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019f1:	75 13                	jne    801a06 <memmove+0x3b>
  8019f3:	f6 c1 03             	test   $0x3,%cl
  8019f6:	75 0e                	jne    801a06 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019f8:	83 ef 04             	sub    $0x4,%edi
  8019fb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019fe:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  801a01:	fd                   	std    
  801a02:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a04:	eb 07                	jmp    801a0d <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  801a06:	4f                   	dec    %edi
  801a07:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  801a0a:	fd                   	std    
  801a0b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  801a0d:	fc                   	cld    
  801a0e:	eb 13                	jmp    801a23 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  801a10:	89 f2                	mov    %esi,%edx
  801a12:	09 c2                	or     %eax,%edx
  801a14:	f6 c2 03             	test   $0x3,%dl
  801a17:	75 05                	jne    801a1e <memmove+0x53>
  801a19:	f6 c1 03             	test   $0x3,%cl
  801a1c:	74 09                	je     801a27 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801a1e:	89 c7                	mov    %eax,%edi
  801a20:	fc                   	cld    
  801a21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801a23:	5e                   	pop    %esi
  801a24:	5f                   	pop    %edi
  801a25:	5d                   	pop    %ebp
  801a26:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a27:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801a2a:	89 c7                	mov    %eax,%edi
  801a2c:	fc                   	cld    
  801a2d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a2f:	eb f2                	jmp    801a23 <memmove+0x58>

00801a31 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801a34:	ff 75 10             	pushl  0x10(%ebp)
  801a37:	ff 75 0c             	pushl  0xc(%ebp)
  801a3a:	ff 75 08             	pushl  0x8(%ebp)
  801a3d:	e8 89 ff ff ff       	call   8019cb <memmove>
}
  801a42:	c9                   	leave  
  801a43:	c3                   	ret    

00801a44 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a44:	55                   	push   %ebp
  801a45:	89 e5                	mov    %esp,%ebp
  801a47:	56                   	push   %esi
  801a48:	53                   	push   %ebx
  801a49:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4c:	89 c6                	mov    %eax,%esi
  801a4e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a51:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a54:	39 f0                	cmp    %esi,%eax
  801a56:	74 16                	je     801a6e <memcmp+0x2a>
		if (*s1 != *s2)
  801a58:	8a 08                	mov    (%eax),%cl
  801a5a:	8a 1a                	mov    (%edx),%bl
  801a5c:	38 d9                	cmp    %bl,%cl
  801a5e:	75 04                	jne    801a64 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a60:	40                   	inc    %eax
  801a61:	42                   	inc    %edx
  801a62:	eb f0                	jmp    801a54 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a64:	0f b6 c1             	movzbl %cl,%eax
  801a67:	0f b6 db             	movzbl %bl,%ebx
  801a6a:	29 d8                	sub    %ebx,%eax
  801a6c:	eb 05                	jmp    801a73 <memcmp+0x2f>
	}

	return 0;
  801a6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a73:	5b                   	pop    %ebx
  801a74:	5e                   	pop    %esi
  801a75:	5d                   	pop    %ebp
  801a76:	c3                   	ret    

00801a77 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
  801a7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a7d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a80:	89 c2                	mov    %eax,%edx
  801a82:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a85:	39 d0                	cmp    %edx,%eax
  801a87:	73 07                	jae    801a90 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a89:	38 08                	cmp    %cl,(%eax)
  801a8b:	74 03                	je     801a90 <memfind+0x19>
	for (; s < ends; s++)
  801a8d:	40                   	inc    %eax
  801a8e:	eb f5                	jmp    801a85 <memfind+0xe>
			break;
	return (void *) s;
}
  801a90:	5d                   	pop    %ebp
  801a91:	c3                   	ret    

00801a92 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
  801a95:	57                   	push   %edi
  801a96:	56                   	push   %esi
  801a97:	53                   	push   %ebx
  801a98:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a9b:	eb 01                	jmp    801a9e <strtol+0xc>
		s++;
  801a9d:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a9e:	8a 01                	mov    (%ecx),%al
  801aa0:	3c 20                	cmp    $0x20,%al
  801aa2:	74 f9                	je     801a9d <strtol+0xb>
  801aa4:	3c 09                	cmp    $0x9,%al
  801aa6:	74 f5                	je     801a9d <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801aa8:	3c 2b                	cmp    $0x2b,%al
  801aaa:	74 2b                	je     801ad7 <strtol+0x45>
		s++;
	else if (*s == '-')
  801aac:	3c 2d                	cmp    $0x2d,%al
  801aae:	74 2f                	je     801adf <strtol+0x4d>
	int neg = 0;
  801ab0:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab5:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801abc:	75 12                	jne    801ad0 <strtol+0x3e>
  801abe:	80 39 30             	cmpb   $0x30,(%ecx)
  801ac1:	74 24                	je     801ae7 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801ac3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac7:	75 07                	jne    801ad0 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ac9:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801ad0:	b8 00 00 00 00       	mov    $0x0,%eax
  801ad5:	eb 4e                	jmp    801b25 <strtol+0x93>
		s++;
  801ad7:	41                   	inc    %ecx
	int neg = 0;
  801ad8:	bf 00 00 00 00       	mov    $0x0,%edi
  801add:	eb d6                	jmp    801ab5 <strtol+0x23>
		s++, neg = 1;
  801adf:	41                   	inc    %ecx
  801ae0:	bf 01 00 00 00       	mov    $0x1,%edi
  801ae5:	eb ce                	jmp    801ab5 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ae7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801aeb:	74 10                	je     801afd <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801aed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801af1:	75 dd                	jne    801ad0 <strtol+0x3e>
		s++, base = 8;
  801af3:	41                   	inc    %ecx
  801af4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801afb:	eb d3                	jmp    801ad0 <strtol+0x3e>
		s += 2, base = 16;
  801afd:	83 c1 02             	add    $0x2,%ecx
  801b00:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801b07:	eb c7                	jmp    801ad0 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801b09:	8d 72 9f             	lea    -0x61(%edx),%esi
  801b0c:	89 f3                	mov    %esi,%ebx
  801b0e:	80 fb 19             	cmp    $0x19,%bl
  801b11:	77 24                	ja     801b37 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801b13:	0f be d2             	movsbl %dl,%edx
  801b16:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801b19:	3b 55 10             	cmp    0x10(%ebp),%edx
  801b1c:	7d 2b                	jge    801b49 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801b1e:	41                   	inc    %ecx
  801b1f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b23:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801b25:	8a 11                	mov    (%ecx),%dl
  801b27:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801b2a:	80 fb 09             	cmp    $0x9,%bl
  801b2d:	77 da                	ja     801b09 <strtol+0x77>
			dig = *s - '0';
  801b2f:	0f be d2             	movsbl %dl,%edx
  801b32:	83 ea 30             	sub    $0x30,%edx
  801b35:	eb e2                	jmp    801b19 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801b37:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b3a:	89 f3                	mov    %esi,%ebx
  801b3c:	80 fb 19             	cmp    $0x19,%bl
  801b3f:	77 08                	ja     801b49 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b41:	0f be d2             	movsbl %dl,%edx
  801b44:	83 ea 37             	sub    $0x37,%edx
  801b47:	eb d0                	jmp    801b19 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b49:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b4d:	74 05                	je     801b54 <strtol+0xc2>
		*endptr = (char *) s;
  801b4f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b52:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b54:	85 ff                	test   %edi,%edi
  801b56:	74 02                	je     801b5a <strtol+0xc8>
  801b58:	f7 d8                	neg    %eax
}
  801b5a:	5b                   	pop    %ebx
  801b5b:	5e                   	pop    %esi
  801b5c:	5f                   	pop    %edi
  801b5d:	5d                   	pop    %ebp
  801b5e:	c3                   	ret    

00801b5f <atoi>:

int
atoi(const char *s)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b62:	6a 0a                	push   $0xa
  801b64:	6a 00                	push   $0x0
  801b66:	ff 75 08             	pushl  0x8(%ebp)
  801b69:	e8 24 ff ff ff       	call   801a92 <strtol>
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <set_pgfault_handler>:
// at UXSTACKTOP), and tell the kernel to call the assembly-language
// _pgfault_upcall routine when a page fault occurs.
//
void
set_pgfault_handler(void (*handler)(struct UTrapframe *utf))
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
  801b73:	83 ec 08             	sub    $0x8,%esp
	int r;

	if (_pgfault_handler == 0) {
  801b76:	83 3d 00 60 80 00 00 	cmpl   $0x0,0x806000
  801b7d:	74 0a                	je     801b89 <set_pgfault_handler+0x19>
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
	}

	// Save handler pointer for assembly to call.
	_pgfault_handler = handler;
  801b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b82:	a3 00 60 80 00       	mov    %eax,0x806000
}
  801b87:	c9                   	leave  
  801b88:	c3                   	ret    
		sys_page_alloc(sys_getenvid(), (void*) UXSTACKTOP - PGSIZE, PTE_P | PTE_U | PTE_W);
  801b89:	e8 aa e5 ff ff       	call   800138 <sys_getenvid>
  801b8e:	83 ec 04             	sub    $0x4,%esp
  801b91:	6a 07                	push   $0x7
  801b93:	68 00 f0 bf ee       	push   $0xeebff000
  801b98:	50                   	push   %eax
  801b99:	e8 b9 e5 ff ff       	call   800157 <sys_page_alloc>
		sys_env_set_pgfault_upcall(sys_getenvid(), _pgfault_upcall);
  801b9e:	e8 95 e5 ff ff       	call   800138 <sys_getenvid>
  801ba3:	83 c4 08             	add    $0x8,%esp
  801ba6:	68 0c 04 80 00       	push   $0x80040c
  801bab:	50                   	push   %eax
  801bac:	e8 51 e7 ff ff       	call   800302 <sys_env_set_pgfault_upcall>
  801bb1:	83 c4 10             	add    $0x10,%esp
  801bb4:	eb c9                	jmp    801b7f <set_pgfault_handler+0xf>

00801bb6 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801bb6:	55                   	push   %ebp
  801bb7:	89 e5                	mov    %esp,%ebp
  801bb9:	57                   	push   %edi
  801bba:	56                   	push   %esi
  801bbb:	53                   	push   %ebx
  801bbc:	83 ec 0c             	sub    $0xc,%esp
  801bbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801bc2:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801bc5:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801bc8:	85 ff                	test   %edi,%edi
  801bca:	74 53                	je     801c1f <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801bcc:	83 ec 0c             	sub    $0xc,%esp
  801bcf:	57                   	push   %edi
  801bd0:	e8 92 e7 ff ff       	call   800367 <sys_ipc_recv>
  801bd5:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801bd8:	85 db                	test   %ebx,%ebx
  801bda:	74 0b                	je     801be7 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801bdc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801be2:	8b 52 74             	mov    0x74(%edx),%edx
  801be5:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801be7:	85 f6                	test   %esi,%esi
  801be9:	74 0f                	je     801bfa <ipc_recv+0x44>
  801beb:	85 ff                	test   %edi,%edi
  801bed:	74 0b                	je     801bfa <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801bef:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801bf5:	8b 52 78             	mov    0x78(%edx),%edx
  801bf8:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801bfa:	85 c0                	test   %eax,%eax
  801bfc:	74 30                	je     801c2e <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801bfe:	85 db                	test   %ebx,%ebx
  801c00:	74 06                	je     801c08 <ipc_recv+0x52>
      		*from_env_store = 0;
  801c02:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801c08:	85 f6                	test   %esi,%esi
  801c0a:	74 2c                	je     801c38 <ipc_recv+0x82>
      		*perm_store = 0;
  801c0c:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801c12:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801c17:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c1a:	5b                   	pop    %ebx
  801c1b:	5e                   	pop    %esi
  801c1c:	5f                   	pop    %edi
  801c1d:	5d                   	pop    %ebp
  801c1e:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801c1f:	83 ec 0c             	sub    $0xc,%esp
  801c22:	6a ff                	push   $0xffffffff
  801c24:	e8 3e e7 ff ff       	call   800367 <sys_ipc_recv>
  801c29:	83 c4 10             	add    $0x10,%esp
  801c2c:	eb aa                	jmp    801bd8 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801c2e:	a1 04 40 80 00       	mov    0x804004,%eax
  801c33:	8b 40 70             	mov    0x70(%eax),%eax
  801c36:	eb df                	jmp    801c17 <ipc_recv+0x61>
		return -1;
  801c38:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801c3d:	eb d8                	jmp    801c17 <ipc_recv+0x61>

00801c3f <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801c3f:	55                   	push   %ebp
  801c40:	89 e5                	mov    %esp,%ebp
  801c42:	57                   	push   %edi
  801c43:	56                   	push   %esi
  801c44:	53                   	push   %ebx
  801c45:	83 ec 0c             	sub    $0xc,%esp
  801c48:	8b 75 0c             	mov    0xc(%ebp),%esi
  801c4b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801c4e:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801c51:	85 db                	test   %ebx,%ebx
  801c53:	75 22                	jne    801c77 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801c55:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801c5a:	eb 1b                	jmp    801c77 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c5c:	68 c0 23 80 00       	push   $0x8023c0
  801c61:	68 4b 20 80 00       	push   $0x80204b
  801c66:	6a 48                	push   $0x48
  801c68:	68 e4 23 80 00       	push   $0x8023e4
  801c6d:	e8 cb f4 ff ff       	call   80113d <_panic>
		sys_yield();
  801c72:	e8 a7 e5 ff ff       	call   80021e <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c77:	57                   	push   %edi
  801c78:	53                   	push   %ebx
  801c79:	56                   	push   %esi
  801c7a:	ff 75 08             	pushl  0x8(%ebp)
  801c7d:	e8 c2 e6 ff ff       	call   800344 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c82:	83 c4 10             	add    $0x10,%esp
  801c85:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c88:	74 e8                	je     801c72 <ipc_send+0x33>
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 ce                	jne    801c5c <ipc_send+0x1d>
		sys_yield();
  801c8e:	e8 8b e5 ff ff       	call   80021e <sys_yield>
		
	}
	
}
  801c93:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c96:	5b                   	pop    %ebx
  801c97:	5e                   	pop    %esi
  801c98:	5f                   	pop    %edi
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    

00801c9b <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c9b:	55                   	push   %ebp
  801c9c:	89 e5                	mov    %esp,%ebp
  801c9e:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801ca1:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801ca6:	89 c2                	mov    %eax,%edx
  801ca8:	c1 e2 05             	shl    $0x5,%edx
  801cab:	29 c2                	sub    %eax,%edx
  801cad:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801cb4:	8b 52 50             	mov    0x50(%edx),%edx
  801cb7:	39 ca                	cmp    %ecx,%edx
  801cb9:	74 0f                	je     801cca <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801cbb:	40                   	inc    %eax
  801cbc:	3d 00 04 00 00       	cmp    $0x400,%eax
  801cc1:	75 e3                	jne    801ca6 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801cc3:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc8:	eb 11                	jmp    801cdb <ipc_find_env+0x40>
			return envs[i].env_id;
  801cca:	89 c2                	mov    %eax,%edx
  801ccc:	c1 e2 05             	shl    $0x5,%edx
  801ccf:	29 c2                	sub    %eax,%edx
  801cd1:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801cd8:	8b 40 48             	mov    0x48(%eax),%eax
}
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce3:	c1 e8 16             	shr    $0x16,%eax
  801ce6:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801ced:	a8 01                	test   $0x1,%al
  801cef:	74 21                	je     801d12 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf4:	c1 e8 0c             	shr    $0xc,%eax
  801cf7:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801cfe:	a8 01                	test   $0x1,%al
  801d00:	74 17                	je     801d19 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801d02:	c1 e8 0c             	shr    $0xc,%eax
  801d05:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801d0c:	ef 
  801d0d:	0f b7 c0             	movzwl %ax,%eax
  801d10:	eb 05                	jmp    801d17 <pageref+0x3a>
		return 0;
  801d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d17:	5d                   	pop    %ebp
  801d18:	c3                   	ret    
		return 0;
  801d19:	b8 00 00 00 00       	mov    $0x0,%eax
  801d1e:	eb f7                	jmp    801d17 <pageref+0x3a>

00801d20 <__udivdi3>:
  801d20:	55                   	push   %ebp
  801d21:	57                   	push   %edi
  801d22:	56                   	push   %esi
  801d23:	53                   	push   %ebx
  801d24:	83 ec 1c             	sub    $0x1c,%esp
  801d27:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801d2b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801d2f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801d33:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801d37:	89 ca                	mov    %ecx,%edx
  801d39:	89 f8                	mov    %edi,%eax
  801d3b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801d3f:	85 f6                	test   %esi,%esi
  801d41:	75 2d                	jne    801d70 <__udivdi3+0x50>
  801d43:	39 cf                	cmp    %ecx,%edi
  801d45:	77 65                	ja     801dac <__udivdi3+0x8c>
  801d47:	89 fd                	mov    %edi,%ebp
  801d49:	85 ff                	test   %edi,%edi
  801d4b:	75 0b                	jne    801d58 <__udivdi3+0x38>
  801d4d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d52:	31 d2                	xor    %edx,%edx
  801d54:	f7 f7                	div    %edi
  801d56:	89 c5                	mov    %eax,%ebp
  801d58:	31 d2                	xor    %edx,%edx
  801d5a:	89 c8                	mov    %ecx,%eax
  801d5c:	f7 f5                	div    %ebp
  801d5e:	89 c1                	mov    %eax,%ecx
  801d60:	89 d8                	mov    %ebx,%eax
  801d62:	f7 f5                	div    %ebp
  801d64:	89 cf                	mov    %ecx,%edi
  801d66:	89 fa                	mov    %edi,%edx
  801d68:	83 c4 1c             	add    $0x1c,%esp
  801d6b:	5b                   	pop    %ebx
  801d6c:	5e                   	pop    %esi
  801d6d:	5f                   	pop    %edi
  801d6e:	5d                   	pop    %ebp
  801d6f:	c3                   	ret    
  801d70:	39 ce                	cmp    %ecx,%esi
  801d72:	77 28                	ja     801d9c <__udivdi3+0x7c>
  801d74:	0f bd fe             	bsr    %esi,%edi
  801d77:	83 f7 1f             	xor    $0x1f,%edi
  801d7a:	75 40                	jne    801dbc <__udivdi3+0x9c>
  801d7c:	39 ce                	cmp    %ecx,%esi
  801d7e:	72 0a                	jb     801d8a <__udivdi3+0x6a>
  801d80:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d84:	0f 87 9e 00 00 00    	ja     801e28 <__udivdi3+0x108>
  801d8a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d8f:	89 fa                	mov    %edi,%edx
  801d91:	83 c4 1c             	add    $0x1c,%esp
  801d94:	5b                   	pop    %ebx
  801d95:	5e                   	pop    %esi
  801d96:	5f                   	pop    %edi
  801d97:	5d                   	pop    %ebp
  801d98:	c3                   	ret    
  801d99:	8d 76 00             	lea    0x0(%esi),%esi
  801d9c:	31 ff                	xor    %edi,%edi
  801d9e:	31 c0                	xor    %eax,%eax
  801da0:	89 fa                	mov    %edi,%edx
  801da2:	83 c4 1c             	add    $0x1c,%esp
  801da5:	5b                   	pop    %ebx
  801da6:	5e                   	pop    %esi
  801da7:	5f                   	pop    %edi
  801da8:	5d                   	pop    %ebp
  801da9:	c3                   	ret    
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	89 d8                	mov    %ebx,%eax
  801dae:	f7 f7                	div    %edi
  801db0:	31 ff                	xor    %edi,%edi
  801db2:	89 fa                	mov    %edi,%edx
  801db4:	83 c4 1c             	add    $0x1c,%esp
  801db7:	5b                   	pop    %ebx
  801db8:	5e                   	pop    %esi
  801db9:	5f                   	pop    %edi
  801dba:	5d                   	pop    %ebp
  801dbb:	c3                   	ret    
  801dbc:	bd 20 00 00 00       	mov    $0x20,%ebp
  801dc1:	29 fd                	sub    %edi,%ebp
  801dc3:	89 f9                	mov    %edi,%ecx
  801dc5:	d3 e6                	shl    %cl,%esi
  801dc7:	89 c3                	mov    %eax,%ebx
  801dc9:	89 e9                	mov    %ebp,%ecx
  801dcb:	d3 eb                	shr    %cl,%ebx
  801dcd:	89 d9                	mov    %ebx,%ecx
  801dcf:	09 f1                	or     %esi,%ecx
  801dd1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd5:	89 f9                	mov    %edi,%ecx
  801dd7:	d3 e0                	shl    %cl,%eax
  801dd9:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ddd:	89 d6                	mov    %edx,%esi
  801ddf:	89 e9                	mov    %ebp,%ecx
  801de1:	d3 ee                	shr    %cl,%esi
  801de3:	89 f9                	mov    %edi,%ecx
  801de5:	d3 e2                	shl    %cl,%edx
  801de7:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801deb:	89 e9                	mov    %ebp,%ecx
  801ded:	d3 eb                	shr    %cl,%ebx
  801def:	09 da                	or     %ebx,%edx
  801df1:	89 d0                	mov    %edx,%eax
  801df3:	89 f2                	mov    %esi,%edx
  801df5:	f7 74 24 08          	divl   0x8(%esp)
  801df9:	89 d6                	mov    %edx,%esi
  801dfb:	89 c3                	mov    %eax,%ebx
  801dfd:	f7 64 24 0c          	mull   0xc(%esp)
  801e01:	39 d6                	cmp    %edx,%esi
  801e03:	72 17                	jb     801e1c <__udivdi3+0xfc>
  801e05:	74 09                	je     801e10 <__udivdi3+0xf0>
  801e07:	89 d8                	mov    %ebx,%eax
  801e09:	31 ff                	xor    %edi,%edi
  801e0b:	e9 56 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e10:	8b 54 24 04          	mov    0x4(%esp),%edx
  801e14:	89 f9                	mov    %edi,%ecx
  801e16:	d3 e2                	shl    %cl,%edx
  801e18:	39 c2                	cmp    %eax,%edx
  801e1a:	73 eb                	jae    801e07 <__udivdi3+0xe7>
  801e1c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e1f:	31 ff                	xor    %edi,%edi
  801e21:	e9 40 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e26:	66 90                	xchg   %ax,%ax
  801e28:	31 c0                	xor    %eax,%eax
  801e2a:	e9 37 ff ff ff       	jmp    801d66 <__udivdi3+0x46>
  801e2f:	90                   	nop

00801e30 <__umoddi3>:
  801e30:	55                   	push   %ebp
  801e31:	57                   	push   %edi
  801e32:	56                   	push   %esi
  801e33:	53                   	push   %ebx
  801e34:	83 ec 1c             	sub    $0x1c,%esp
  801e37:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801e3b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801e3f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801e43:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801e47:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801e4b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801e4f:	89 3c 24             	mov    %edi,(%esp)
  801e52:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801e56:	89 f2                	mov    %esi,%edx
  801e58:	85 c0                	test   %eax,%eax
  801e5a:	75 18                	jne    801e74 <__umoddi3+0x44>
  801e5c:	39 f7                	cmp    %esi,%edi
  801e5e:	0f 86 a0 00 00 00    	jbe    801f04 <__umoddi3+0xd4>
  801e64:	89 c8                	mov    %ecx,%eax
  801e66:	f7 f7                	div    %edi
  801e68:	89 d0                	mov    %edx,%eax
  801e6a:	31 d2                	xor    %edx,%edx
  801e6c:	83 c4 1c             	add    $0x1c,%esp
  801e6f:	5b                   	pop    %ebx
  801e70:	5e                   	pop    %esi
  801e71:	5f                   	pop    %edi
  801e72:	5d                   	pop    %ebp
  801e73:	c3                   	ret    
  801e74:	89 f3                	mov    %esi,%ebx
  801e76:	39 f0                	cmp    %esi,%eax
  801e78:	0f 87 a6 00 00 00    	ja     801f24 <__umoddi3+0xf4>
  801e7e:	0f bd e8             	bsr    %eax,%ebp
  801e81:	83 f5 1f             	xor    $0x1f,%ebp
  801e84:	0f 84 a6 00 00 00    	je     801f30 <__umoddi3+0x100>
  801e8a:	bf 20 00 00 00       	mov    $0x20,%edi
  801e8f:	29 ef                	sub    %ebp,%edi
  801e91:	89 e9                	mov    %ebp,%ecx
  801e93:	d3 e0                	shl    %cl,%eax
  801e95:	8b 34 24             	mov    (%esp),%esi
  801e98:	89 f2                	mov    %esi,%edx
  801e9a:	89 f9                	mov    %edi,%ecx
  801e9c:	d3 ea                	shr    %cl,%edx
  801e9e:	09 c2                	or     %eax,%edx
  801ea0:	89 14 24             	mov    %edx,(%esp)
  801ea3:	89 f2                	mov    %esi,%edx
  801ea5:	89 e9                	mov    %ebp,%ecx
  801ea7:	d3 e2                	shl    %cl,%edx
  801ea9:	89 54 24 04          	mov    %edx,0x4(%esp)
  801ead:	89 de                	mov    %ebx,%esi
  801eaf:	89 f9                	mov    %edi,%ecx
  801eb1:	d3 ee                	shr    %cl,%esi
  801eb3:	89 e9                	mov    %ebp,%ecx
  801eb5:	d3 e3                	shl    %cl,%ebx
  801eb7:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ebb:	89 d0                	mov    %edx,%eax
  801ebd:	89 f9                	mov    %edi,%ecx
  801ebf:	d3 e8                	shr    %cl,%eax
  801ec1:	09 d8                	or     %ebx,%eax
  801ec3:	89 d3                	mov    %edx,%ebx
  801ec5:	89 e9                	mov    %ebp,%ecx
  801ec7:	d3 e3                	shl    %cl,%ebx
  801ec9:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801ecd:	89 f2                	mov    %esi,%edx
  801ecf:	f7 34 24             	divl   (%esp)
  801ed2:	89 d6                	mov    %edx,%esi
  801ed4:	f7 64 24 04          	mull   0x4(%esp)
  801ed8:	89 c3                	mov    %eax,%ebx
  801eda:	89 d1                	mov    %edx,%ecx
  801edc:	39 d6                	cmp    %edx,%esi
  801ede:	72 7c                	jb     801f5c <__umoddi3+0x12c>
  801ee0:	74 72                	je     801f54 <__umoddi3+0x124>
  801ee2:	8b 54 24 08          	mov    0x8(%esp),%edx
  801ee6:	29 da                	sub    %ebx,%edx
  801ee8:	19 ce                	sbb    %ecx,%esi
  801eea:	89 f0                	mov    %esi,%eax
  801eec:	89 f9                	mov    %edi,%ecx
  801eee:	d3 e0                	shl    %cl,%eax
  801ef0:	89 e9                	mov    %ebp,%ecx
  801ef2:	d3 ea                	shr    %cl,%edx
  801ef4:	09 d0                	or     %edx,%eax
  801ef6:	89 e9                	mov    %ebp,%ecx
  801ef8:	d3 ee                	shr    %cl,%esi
  801efa:	89 f2                	mov    %esi,%edx
  801efc:	83 c4 1c             	add    $0x1c,%esp
  801eff:	5b                   	pop    %ebx
  801f00:	5e                   	pop    %esi
  801f01:	5f                   	pop    %edi
  801f02:	5d                   	pop    %ebp
  801f03:	c3                   	ret    
  801f04:	89 fd                	mov    %edi,%ebp
  801f06:	85 ff                	test   %edi,%edi
  801f08:	75 0b                	jne    801f15 <__umoddi3+0xe5>
  801f0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801f0f:	31 d2                	xor    %edx,%edx
  801f11:	f7 f7                	div    %edi
  801f13:	89 c5                	mov    %eax,%ebp
  801f15:	89 f0                	mov    %esi,%eax
  801f17:	31 d2                	xor    %edx,%edx
  801f19:	f7 f5                	div    %ebp
  801f1b:	89 c8                	mov    %ecx,%eax
  801f1d:	f7 f5                	div    %ebp
  801f1f:	e9 44 ff ff ff       	jmp    801e68 <__umoddi3+0x38>
  801f24:	89 c8                	mov    %ecx,%eax
  801f26:	89 f2                	mov    %esi,%edx
  801f28:	83 c4 1c             	add    $0x1c,%esp
  801f2b:	5b                   	pop    %ebx
  801f2c:	5e                   	pop    %esi
  801f2d:	5f                   	pop    %edi
  801f2e:	5d                   	pop    %ebp
  801f2f:	c3                   	ret    
  801f30:	39 f0                	cmp    %esi,%eax
  801f32:	72 05                	jb     801f39 <__umoddi3+0x109>
  801f34:	39 0c 24             	cmp    %ecx,(%esp)
  801f37:	77 0c                	ja     801f45 <__umoddi3+0x115>
  801f39:	89 f2                	mov    %esi,%edx
  801f3b:	29 f9                	sub    %edi,%ecx
  801f3d:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801f41:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801f45:	8b 44 24 04          	mov    0x4(%esp),%eax
  801f49:	83 c4 1c             	add    $0x1c,%esp
  801f4c:	5b                   	pop    %ebx
  801f4d:	5e                   	pop    %esi
  801f4e:	5f                   	pop    %edi
  801f4f:	5d                   	pop    %ebp
  801f50:	c3                   	ret    
  801f51:	8d 76 00             	lea    0x0(%esi),%esi
  801f54:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f58:	73 88                	jae    801ee2 <__umoddi3+0xb2>
  801f5a:	66 90                	xchg   %ax,%ax
  801f5c:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f60:	1b 14 24             	sbb    (%esp),%edx
  801f63:	89 d1                	mov    %edx,%ecx
  801f65:	89 c3                	mov    %eax,%ebx
  801f67:	e9 76 ff ff ff       	jmp    801ee2 <__umoddi3+0xb2>
