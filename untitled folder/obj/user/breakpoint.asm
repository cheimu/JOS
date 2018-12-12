
obj/user/breakpoint.debug:     file format elf32-i386


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
  80002c:	e8 08 00 00 00       	call   800039 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	asm volatile("int $3");
  800036:	cc                   	int3   
}
  800037:	5d                   	pop    %ebp
  800038:	c3                   	ret    

00800039 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800039:	55                   	push   %ebp
  80003a:	89 e5                	mov    %esp,%ebp
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800041:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800044:	e8 d4 00 00 00       	call   80011d <sys_getenvid>
  800049:	25 ff 03 00 00       	and    $0x3ff,%eax
  80004e:	89 c2                	mov    %eax,%edx
  800050:	c1 e2 05             	shl    $0x5,%edx
  800053:	29 c2                	sub    %eax,%edx
  800055:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80005c:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800061:	85 db                	test   %ebx,%ebx
  800063:	7e 07                	jle    80006c <libmain+0x33>
		binaryname = argv[0];
  800065:	8b 06                	mov    (%esi),%eax
  800067:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80006c:	83 ec 08             	sub    $0x8,%esp
  80006f:	56                   	push   %esi
  800070:	53                   	push   %ebx
  800071:	e8 bd ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800076:	e8 0a 00 00 00       	call   800085 <exit>
}
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800081:	5b                   	pop    %ebx
  800082:	5e                   	pop    %esi
  800083:	5d                   	pop    %ebp
  800084:	c3                   	ret    

00800085 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800085:	55                   	push   %ebp
  800086:	89 e5                	mov    %esp,%ebp
  800088:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80008b:	e8 35 05 00 00       	call   8005c5 <close_all>
	sys_env_destroy(0);
  800090:	83 ec 0c             	sub    $0xc,%esp
  800093:	6a 00                	push   $0x0
  800095:	e8 42 00 00 00       	call   8000dc <sys_env_destroy>
}
  80009a:	83 c4 10             	add    $0x10,%esp
  80009d:	c9                   	leave  
  80009e:	c3                   	ret    

0080009f <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  80009f:	55                   	push   %ebp
  8000a0:	89 e5                	mov    %esp,%ebp
  8000a2:	57                   	push   %edi
  8000a3:	56                   	push   %esi
  8000a4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8000aa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b0:	89 c3                	mov    %eax,%ebx
  8000b2:	89 c7                	mov    %eax,%edi
  8000b4:	89 c6                	mov    %eax,%esi
  8000b6:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000b8:	5b                   	pop    %ebx
  8000b9:	5e                   	pop    %esi
  8000ba:	5f                   	pop    %edi
  8000bb:	5d                   	pop    %ebp
  8000bc:	c3                   	ret    

008000bd <sys_cgetc>:

int
sys_cgetc(void)
{
  8000bd:	55                   	push   %ebp
  8000be:	89 e5                	mov    %esp,%ebp
  8000c0:	57                   	push   %edi
  8000c1:	56                   	push   %esi
  8000c2:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c8:	b8 01 00 00 00       	mov    $0x1,%eax
  8000cd:	89 d1                	mov    %edx,%ecx
  8000cf:	89 d3                	mov    %edx,%ebx
  8000d1:	89 d7                	mov    %edx,%edi
  8000d3:	89 d6                	mov    %edx,%esi
  8000d5:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000d7:	5b                   	pop    %ebx
  8000d8:	5e                   	pop    %esi
  8000d9:	5f                   	pop    %edi
  8000da:	5d                   	pop    %ebp
  8000db:	c3                   	ret    

008000dc <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000dc:	55                   	push   %ebp
  8000dd:	89 e5                	mov    %esp,%ebp
  8000df:	57                   	push   %edi
  8000e0:	56                   	push   %esi
  8000e1:	53                   	push   %ebx
  8000e2:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000e5:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000ea:	b8 03 00 00 00       	mov    $0x3,%eax
  8000ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8000f2:	89 cb                	mov    %ecx,%ebx
  8000f4:	89 cf                	mov    %ecx,%edi
  8000f6:	89 ce                	mov    %ecx,%esi
  8000f8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8000fa:	85 c0                	test   %eax,%eax
  8000fc:	7f 08                	jg     800106 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  8000fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800101:	5b                   	pop    %ebx
  800102:	5e                   	pop    %esi
  800103:	5f                   	pop    %edi
  800104:	5d                   	pop    %ebp
  800105:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800106:	83 ec 0c             	sub    $0xc,%esp
  800109:	50                   	push   %eax
  80010a:	6a 03                	push   $0x3
  80010c:	68 0a 1f 80 00       	push   $0x801f0a
  800111:	6a 23                	push   $0x23
  800113:	68 27 1f 80 00       	push   $0x801f27
  800118:	e8 df 0f 00 00       	call   8010fc <_panic>

0080011d <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80011d:	55                   	push   %ebp
  80011e:	89 e5                	mov    %esp,%ebp
  800120:	57                   	push   %edi
  800121:	56                   	push   %esi
  800122:	53                   	push   %ebx
	asm volatile("int %1\n"
  800123:	ba 00 00 00 00       	mov    $0x0,%edx
  800128:	b8 02 00 00 00       	mov    $0x2,%eax
  80012d:	89 d1                	mov    %edx,%ecx
  80012f:	89 d3                	mov    %edx,%ebx
  800131:	89 d7                	mov    %edx,%edi
  800133:	89 d6                	mov    %edx,%esi
  800135:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800137:	5b                   	pop    %ebx
  800138:	5e                   	pop    %esi
  800139:	5f                   	pop    %edi
  80013a:	5d                   	pop    %ebp
  80013b:	c3                   	ret    

0080013c <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80013c:	55                   	push   %ebp
  80013d:	89 e5                	mov    %esp,%ebp
  80013f:	57                   	push   %edi
  800140:	56                   	push   %esi
  800141:	53                   	push   %ebx
  800142:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800145:	be 00 00 00 00       	mov    $0x0,%esi
  80014a:	b8 04 00 00 00       	mov    $0x4,%eax
  80014f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800152:	8b 55 08             	mov    0x8(%ebp),%edx
  800155:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800158:	89 f7                	mov    %esi,%edi
  80015a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80015c:	85 c0                	test   %eax,%eax
  80015e:	7f 08                	jg     800168 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800160:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800168:	83 ec 0c             	sub    $0xc,%esp
  80016b:	50                   	push   %eax
  80016c:	6a 04                	push   $0x4
  80016e:	68 0a 1f 80 00       	push   $0x801f0a
  800173:	6a 23                	push   $0x23
  800175:	68 27 1f 80 00       	push   $0x801f27
  80017a:	e8 7d 0f 00 00       	call   8010fc <_panic>

0080017f <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  80017f:	55                   	push   %ebp
  800180:	89 e5                	mov    %esp,%ebp
  800182:	57                   	push   %edi
  800183:	56                   	push   %esi
  800184:	53                   	push   %ebx
  800185:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800188:	b8 05 00 00 00       	mov    $0x5,%eax
  80018d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800190:	8b 55 08             	mov    0x8(%ebp),%edx
  800193:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800196:	8b 7d 14             	mov    0x14(%ebp),%edi
  800199:	8b 75 18             	mov    0x18(%ebp),%esi
  80019c:	cd 30                	int    $0x30
	if(check && ret > 0)
  80019e:	85 c0                	test   %eax,%eax
  8001a0:	7f 08                	jg     8001aa <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001a2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001a5:	5b                   	pop    %ebx
  8001a6:	5e                   	pop    %esi
  8001a7:	5f                   	pop    %edi
  8001a8:	5d                   	pop    %ebp
  8001a9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001aa:	83 ec 0c             	sub    $0xc,%esp
  8001ad:	50                   	push   %eax
  8001ae:	6a 05                	push   $0x5
  8001b0:	68 0a 1f 80 00       	push   $0x801f0a
  8001b5:	6a 23                	push   $0x23
  8001b7:	68 27 1f 80 00       	push   $0x801f27
  8001bc:	e8 3b 0f 00 00       	call   8010fc <_panic>

008001c1 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001c1:	55                   	push   %ebp
  8001c2:	89 e5                	mov    %esp,%ebp
  8001c4:	57                   	push   %edi
  8001c5:	56                   	push   %esi
  8001c6:	53                   	push   %ebx
  8001c7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001ca:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001cf:	b8 06 00 00 00       	mov    $0x6,%eax
  8001d4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8001da:	89 df                	mov    %ebx,%edi
  8001dc:	89 de                	mov    %ebx,%esi
  8001de:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e0:	85 c0                	test   %eax,%eax
  8001e2:	7f 08                	jg     8001ec <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001e4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001e7:	5b                   	pop    %ebx
  8001e8:	5e                   	pop    %esi
  8001e9:	5f                   	pop    %edi
  8001ea:	5d                   	pop    %ebp
  8001eb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001ec:	83 ec 0c             	sub    $0xc,%esp
  8001ef:	50                   	push   %eax
  8001f0:	6a 06                	push   $0x6
  8001f2:	68 0a 1f 80 00       	push   $0x801f0a
  8001f7:	6a 23                	push   $0x23
  8001f9:	68 27 1f 80 00       	push   $0x801f27
  8001fe:	e8 f9 0e 00 00       	call   8010fc <_panic>

00800203 <sys_yield>:

void
sys_yield(void)
{
  800203:	55                   	push   %ebp
  800204:	89 e5                	mov    %esp,%ebp
  800206:	57                   	push   %edi
  800207:	56                   	push   %esi
  800208:	53                   	push   %ebx
	asm volatile("int %1\n"
  800209:	ba 00 00 00 00       	mov    $0x0,%edx
  80020e:	b8 0b 00 00 00       	mov    $0xb,%eax
  800213:	89 d1                	mov    %edx,%ecx
  800215:	89 d3                	mov    %edx,%ebx
  800217:	89 d7                	mov    %edx,%edi
  800219:	89 d6                	mov    %edx,%esi
  80021b:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80021d:	5b                   	pop    %ebx
  80021e:	5e                   	pop    %esi
  80021f:	5f                   	pop    %edi
  800220:	5d                   	pop    %ebp
  800221:	c3                   	ret    

00800222 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800222:	55                   	push   %ebp
  800223:	89 e5                	mov    %esp,%ebp
  800225:	57                   	push   %edi
  800226:	56                   	push   %esi
  800227:	53                   	push   %ebx
  800228:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80022b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800230:	b8 08 00 00 00       	mov    $0x8,%eax
  800235:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800238:	8b 55 08             	mov    0x8(%ebp),%edx
  80023b:	89 df                	mov    %ebx,%edi
  80023d:	89 de                	mov    %ebx,%esi
  80023f:	cd 30                	int    $0x30
	if(check && ret > 0)
  800241:	85 c0                	test   %eax,%eax
  800243:	7f 08                	jg     80024d <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800245:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800248:	5b                   	pop    %ebx
  800249:	5e                   	pop    %esi
  80024a:	5f                   	pop    %edi
  80024b:	5d                   	pop    %ebp
  80024c:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80024d:	83 ec 0c             	sub    $0xc,%esp
  800250:	50                   	push   %eax
  800251:	6a 08                	push   $0x8
  800253:	68 0a 1f 80 00       	push   $0x801f0a
  800258:	6a 23                	push   $0x23
  80025a:	68 27 1f 80 00       	push   $0x801f27
  80025f:	e8 98 0e 00 00       	call   8010fc <_panic>

00800264 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800264:	55                   	push   %ebp
  800265:	89 e5                	mov    %esp,%ebp
  800267:	57                   	push   %edi
  800268:	56                   	push   %esi
  800269:	53                   	push   %ebx
  80026a:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80026d:	b9 00 00 00 00       	mov    $0x0,%ecx
  800272:	b8 0c 00 00 00       	mov    $0xc,%eax
  800277:	8b 55 08             	mov    0x8(%ebp),%edx
  80027a:	89 cb                	mov    %ecx,%ebx
  80027c:	89 cf                	mov    %ecx,%edi
  80027e:	89 ce                	mov    %ecx,%esi
  800280:	cd 30                	int    $0x30
	if(check && ret > 0)
  800282:	85 c0                	test   %eax,%eax
  800284:	7f 08                	jg     80028e <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800286:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800289:	5b                   	pop    %ebx
  80028a:	5e                   	pop    %esi
  80028b:	5f                   	pop    %edi
  80028c:	5d                   	pop    %ebp
  80028d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80028e:	83 ec 0c             	sub    $0xc,%esp
  800291:	50                   	push   %eax
  800292:	6a 0c                	push   $0xc
  800294:	68 0a 1f 80 00       	push   $0x801f0a
  800299:	6a 23                	push   $0x23
  80029b:	68 27 1f 80 00       	push   $0x801f27
  8002a0:	e8 57 0e 00 00       	call   8010fc <_panic>

008002a5 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002a5:	55                   	push   %ebp
  8002a6:	89 e5                	mov    %esp,%ebp
  8002a8:	57                   	push   %edi
  8002a9:	56                   	push   %esi
  8002aa:	53                   	push   %ebx
  8002ab:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002ae:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002b3:	b8 09 00 00 00       	mov    $0x9,%eax
  8002b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	89 df                	mov    %ebx,%edi
  8002c0:	89 de                	mov    %ebx,%esi
  8002c2:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002c4:	85 c0                	test   %eax,%eax
  8002c6:	7f 08                	jg     8002d0 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002cb:	5b                   	pop    %ebx
  8002cc:	5e                   	pop    %esi
  8002cd:	5f                   	pop    %edi
  8002ce:	5d                   	pop    %ebp
  8002cf:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d0:	83 ec 0c             	sub    $0xc,%esp
  8002d3:	50                   	push   %eax
  8002d4:	6a 09                	push   $0x9
  8002d6:	68 0a 1f 80 00       	push   $0x801f0a
  8002db:	6a 23                	push   $0x23
  8002dd:	68 27 1f 80 00       	push   $0x801f27
  8002e2:	e8 15 0e 00 00       	call   8010fc <_panic>

008002e7 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002e7:	55                   	push   %ebp
  8002e8:	89 e5                	mov    %esp,%ebp
  8002ea:	57                   	push   %edi
  8002eb:	56                   	push   %esi
  8002ec:	53                   	push   %ebx
  8002ed:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002f5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8002fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002fd:	8b 55 08             	mov    0x8(%ebp),%edx
  800300:	89 df                	mov    %ebx,%edi
  800302:	89 de                	mov    %ebx,%esi
  800304:	cd 30                	int    $0x30
	if(check && ret > 0)
  800306:	85 c0                	test   %eax,%eax
  800308:	7f 08                	jg     800312 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80030a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80030d:	5b                   	pop    %ebx
  80030e:	5e                   	pop    %esi
  80030f:	5f                   	pop    %edi
  800310:	5d                   	pop    %ebp
  800311:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800312:	83 ec 0c             	sub    $0xc,%esp
  800315:	50                   	push   %eax
  800316:	6a 0a                	push   $0xa
  800318:	68 0a 1f 80 00       	push   $0x801f0a
  80031d:	6a 23                	push   $0x23
  80031f:	68 27 1f 80 00       	push   $0x801f27
  800324:	e8 d3 0d 00 00       	call   8010fc <_panic>

00800329 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800329:	55                   	push   %ebp
  80032a:	89 e5                	mov    %esp,%ebp
  80032c:	57                   	push   %edi
  80032d:	56                   	push   %esi
  80032e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80032f:	be 00 00 00 00       	mov    $0x0,%esi
  800334:	b8 0d 00 00 00       	mov    $0xd,%eax
  800339:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80033c:	8b 55 08             	mov    0x8(%ebp),%edx
  80033f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800342:	8b 7d 14             	mov    0x14(%ebp),%edi
  800345:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800347:	5b                   	pop    %ebx
  800348:	5e                   	pop    %esi
  800349:	5f                   	pop    %edi
  80034a:	5d                   	pop    %ebp
  80034b:	c3                   	ret    

0080034c <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80034c:	55                   	push   %ebp
  80034d:	89 e5                	mov    %esp,%ebp
  80034f:	57                   	push   %edi
  800350:	56                   	push   %esi
  800351:	53                   	push   %ebx
  800352:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800355:	b9 00 00 00 00       	mov    $0x0,%ecx
  80035a:	b8 0e 00 00 00       	mov    $0xe,%eax
  80035f:	8b 55 08             	mov    0x8(%ebp),%edx
  800362:	89 cb                	mov    %ecx,%ebx
  800364:	89 cf                	mov    %ecx,%edi
  800366:	89 ce                	mov    %ecx,%esi
  800368:	cd 30                	int    $0x30
	if(check && ret > 0)
  80036a:	85 c0                	test   %eax,%eax
  80036c:	7f 08                	jg     800376 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80036e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800371:	5b                   	pop    %ebx
  800372:	5e                   	pop    %esi
  800373:	5f                   	pop    %edi
  800374:	5d                   	pop    %ebp
  800375:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800376:	83 ec 0c             	sub    $0xc,%esp
  800379:	50                   	push   %eax
  80037a:	6a 0e                	push   $0xe
  80037c:	68 0a 1f 80 00       	push   $0x801f0a
  800381:	6a 23                	push   $0x23
  800383:	68 27 1f 80 00       	push   $0x801f27
  800388:	e8 6f 0d 00 00       	call   8010fc <_panic>

0080038d <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80038d:	55                   	push   %ebp
  80038e:	89 e5                	mov    %esp,%ebp
  800390:	57                   	push   %edi
  800391:	56                   	push   %esi
  800392:	53                   	push   %ebx
	asm volatile("int %1\n"
  800393:	be 00 00 00 00       	mov    $0x0,%esi
  800398:	b8 0f 00 00 00       	mov    $0xf,%eax
  80039d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8003a3:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003a6:	89 f7                	mov    %esi,%edi
  8003a8:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003aa:	5b                   	pop    %ebx
  8003ab:	5e                   	pop    %esi
  8003ac:	5f                   	pop    %edi
  8003ad:	5d                   	pop    %ebp
  8003ae:	c3                   	ret    

008003af <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003af:	55                   	push   %ebp
  8003b0:	89 e5                	mov    %esp,%ebp
  8003b2:	57                   	push   %edi
  8003b3:	56                   	push   %esi
  8003b4:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003b5:	be 00 00 00 00       	mov    $0x0,%esi
  8003ba:	b8 10 00 00 00       	mov    $0x10,%eax
  8003bf:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003c2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003c8:	89 f7                	mov    %esi,%edi
  8003ca:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003cc:	5b                   	pop    %ebx
  8003cd:	5e                   	pop    %esi
  8003ce:	5f                   	pop    %edi
  8003cf:	5d                   	pop    %ebp
  8003d0:	c3                   	ret    

008003d1 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003d1:	55                   	push   %ebp
  8003d2:	89 e5                	mov    %esp,%ebp
  8003d4:	57                   	push   %edi
  8003d5:	56                   	push   %esi
  8003d6:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003d7:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003dc:	b8 11 00 00 00       	mov    $0x11,%eax
  8003e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003e4:	89 cb                	mov    %ecx,%ebx
  8003e6:	89 cf                	mov    %ecx,%edi
  8003e8:	89 ce                	mov    %ecx,%esi
  8003ea:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003ec:	5b                   	pop    %ebx
  8003ed:	5e                   	pop    %esi
  8003ee:	5f                   	pop    %edi
  8003ef:	5d                   	pop    %ebp
  8003f0:	c3                   	ret    

008003f1 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003f1:	55                   	push   %ebp
  8003f2:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f7:	05 00 00 00 30       	add    $0x30000000,%eax
  8003fc:	c1 e8 0c             	shr    $0xc,%eax
}
  8003ff:	5d                   	pop    %ebp
  800400:	c3                   	ret    

00800401 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800401:	55                   	push   %ebp
  800402:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800404:	8b 45 08             	mov    0x8(%ebp),%eax
  800407:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80040c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800411:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800416:	5d                   	pop    %ebp
  800417:	c3                   	ret    

00800418 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800418:	55                   	push   %ebp
  800419:	89 e5                	mov    %esp,%ebp
  80041b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80041e:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800423:	89 c2                	mov    %eax,%edx
  800425:	c1 ea 16             	shr    $0x16,%edx
  800428:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80042f:	f6 c2 01             	test   $0x1,%dl
  800432:	74 2a                	je     80045e <fd_alloc+0x46>
  800434:	89 c2                	mov    %eax,%edx
  800436:	c1 ea 0c             	shr    $0xc,%edx
  800439:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800440:	f6 c2 01             	test   $0x1,%dl
  800443:	74 19                	je     80045e <fd_alloc+0x46>
  800445:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80044a:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80044f:	75 d2                	jne    800423 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800451:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800457:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80045c:	eb 07                	jmp    800465 <fd_alloc+0x4d>
			*fd_store = fd;
  80045e:	89 01                	mov    %eax,(%ecx)
			return 0;
  800460:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800465:	5d                   	pop    %ebp
  800466:	c3                   	ret    

00800467 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800467:	55                   	push   %ebp
  800468:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80046a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80046e:	77 39                	ja     8004a9 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800470:	8b 45 08             	mov    0x8(%ebp),%eax
  800473:	c1 e0 0c             	shl    $0xc,%eax
  800476:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80047b:	89 c2                	mov    %eax,%edx
  80047d:	c1 ea 16             	shr    $0x16,%edx
  800480:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800487:	f6 c2 01             	test   $0x1,%dl
  80048a:	74 24                	je     8004b0 <fd_lookup+0x49>
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	c1 ea 0c             	shr    $0xc,%edx
  800491:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800498:	f6 c2 01             	test   $0x1,%dl
  80049b:	74 1a                	je     8004b7 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  80049d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a0:	89 02                	mov    %eax,(%edx)
	return 0;
  8004a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004a7:	5d                   	pop    %ebp
  8004a8:	c3                   	ret    
		return -E_INVAL;
  8004a9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004ae:	eb f7                	jmp    8004a7 <fd_lookup+0x40>
		return -E_INVAL;
  8004b0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b5:	eb f0                	jmp    8004a7 <fd_lookup+0x40>
  8004b7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004bc:	eb e9                	jmp    8004a7 <fd_lookup+0x40>

008004be <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004be:	55                   	push   %ebp
  8004bf:	89 e5                	mov    %esp,%ebp
  8004c1:	83 ec 08             	sub    $0x8,%esp
  8004c4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004c7:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004cc:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004d1:	39 08                	cmp    %ecx,(%eax)
  8004d3:	74 33                	je     800508 <dev_lookup+0x4a>
  8004d5:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004d8:	8b 02                	mov    (%edx),%eax
  8004da:	85 c0                	test   %eax,%eax
  8004dc:	75 f3                	jne    8004d1 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004de:	a1 04 40 80 00       	mov    0x804004,%eax
  8004e3:	8b 40 48             	mov    0x48(%eax),%eax
  8004e6:	83 ec 04             	sub    $0x4,%esp
  8004e9:	51                   	push   %ecx
  8004ea:	50                   	push   %eax
  8004eb:	68 38 1f 80 00       	push   $0x801f38
  8004f0:	e8 1a 0d 00 00       	call   80120f <cprintf>
	*dev = 0;
  8004f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  8004fe:	83 c4 10             	add    $0x10,%esp
  800501:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800506:	c9                   	leave  
  800507:	c3                   	ret    
			*dev = devtab[i];
  800508:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80050b:	89 01                	mov    %eax,(%ecx)
			return 0;
  80050d:	b8 00 00 00 00       	mov    $0x0,%eax
  800512:	eb f2                	jmp    800506 <dev_lookup+0x48>

00800514 <fd_close>:
{
  800514:	55                   	push   %ebp
  800515:	89 e5                	mov    %esp,%ebp
  800517:	57                   	push   %edi
  800518:	56                   	push   %esi
  800519:	53                   	push   %ebx
  80051a:	83 ec 1c             	sub    $0x1c,%esp
  80051d:	8b 75 08             	mov    0x8(%ebp),%esi
  800520:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800523:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800526:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800527:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80052d:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800530:	50                   	push   %eax
  800531:	e8 31 ff ff ff       	call   800467 <fd_lookup>
  800536:	89 c7                	mov    %eax,%edi
  800538:	83 c4 08             	add    $0x8,%esp
  80053b:	85 c0                	test   %eax,%eax
  80053d:	78 05                	js     800544 <fd_close+0x30>
	    || fd != fd2)
  80053f:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800542:	74 13                	je     800557 <fd_close+0x43>
		return (must_exist ? r : 0);
  800544:	84 db                	test   %bl,%bl
  800546:	75 05                	jne    80054d <fd_close+0x39>
  800548:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80054d:	89 f8                	mov    %edi,%eax
  80054f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800552:	5b                   	pop    %ebx
  800553:	5e                   	pop    %esi
  800554:	5f                   	pop    %edi
  800555:	5d                   	pop    %ebp
  800556:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800557:	83 ec 08             	sub    $0x8,%esp
  80055a:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80055d:	50                   	push   %eax
  80055e:	ff 36                	pushl  (%esi)
  800560:	e8 59 ff ff ff       	call   8004be <dev_lookup>
  800565:	89 c7                	mov    %eax,%edi
  800567:	83 c4 10             	add    $0x10,%esp
  80056a:	85 c0                	test   %eax,%eax
  80056c:	78 15                	js     800583 <fd_close+0x6f>
		if (dev->dev_close)
  80056e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800571:	8b 40 10             	mov    0x10(%eax),%eax
  800574:	85 c0                	test   %eax,%eax
  800576:	74 1b                	je     800593 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800578:	83 ec 0c             	sub    $0xc,%esp
  80057b:	56                   	push   %esi
  80057c:	ff d0                	call   *%eax
  80057e:	89 c7                	mov    %eax,%edi
  800580:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	56                   	push   %esi
  800587:	6a 00                	push   $0x0
  800589:	e8 33 fc ff ff       	call   8001c1 <sys_page_unmap>
	return r;
  80058e:	83 c4 10             	add    $0x10,%esp
  800591:	eb ba                	jmp    80054d <fd_close+0x39>
			r = 0;
  800593:	bf 00 00 00 00       	mov    $0x0,%edi
  800598:	eb e9                	jmp    800583 <fd_close+0x6f>

0080059a <close>:

int
close(int fdnum)
{
  80059a:	55                   	push   %ebp
  80059b:	89 e5                	mov    %esp,%ebp
  80059d:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005a0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005a3:	50                   	push   %eax
  8005a4:	ff 75 08             	pushl  0x8(%ebp)
  8005a7:	e8 bb fe ff ff       	call   800467 <fd_lookup>
  8005ac:	83 c4 08             	add    $0x8,%esp
  8005af:	85 c0                	test   %eax,%eax
  8005b1:	78 10                	js     8005c3 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	6a 01                	push   $0x1
  8005b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bb:	e8 54 ff ff ff       	call   800514 <fd_close>
  8005c0:	83 c4 10             	add    $0x10,%esp
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <close_all>:

void
close_all(void)
{
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	53                   	push   %ebx
  8005c9:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005cc:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005d1:	83 ec 0c             	sub    $0xc,%esp
  8005d4:	53                   	push   %ebx
  8005d5:	e8 c0 ff ff ff       	call   80059a <close>
	for (i = 0; i < MAXFD; i++)
  8005da:	43                   	inc    %ebx
  8005db:	83 c4 10             	add    $0x10,%esp
  8005de:	83 fb 20             	cmp    $0x20,%ebx
  8005e1:	75 ee                	jne    8005d1 <close_all+0xc>
}
  8005e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005e6:	c9                   	leave  
  8005e7:	c3                   	ret    

008005e8 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005e8:	55                   	push   %ebp
  8005e9:	89 e5                	mov    %esp,%ebp
  8005eb:	57                   	push   %edi
  8005ec:	56                   	push   %esi
  8005ed:	53                   	push   %ebx
  8005ee:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005f1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 08             	pushl  0x8(%ebp)
  8005f8:	e8 6a fe ff ff       	call   800467 <fd_lookup>
  8005fd:	89 c3                	mov    %eax,%ebx
  8005ff:	83 c4 08             	add    $0x8,%esp
  800602:	85 c0                	test   %eax,%eax
  800604:	0f 88 81 00 00 00    	js     80068b <dup+0xa3>
		return r;
	close(newfdnum);
  80060a:	83 ec 0c             	sub    $0xc,%esp
  80060d:	ff 75 0c             	pushl  0xc(%ebp)
  800610:	e8 85 ff ff ff       	call   80059a <close>

	newfd = INDEX2FD(newfdnum);
  800615:	8b 75 0c             	mov    0xc(%ebp),%esi
  800618:	c1 e6 0c             	shl    $0xc,%esi
  80061b:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800621:	83 c4 04             	add    $0x4,%esp
  800624:	ff 75 e4             	pushl  -0x1c(%ebp)
  800627:	e8 d5 fd ff ff       	call   800401 <fd2data>
  80062c:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80062e:	89 34 24             	mov    %esi,(%esp)
  800631:	e8 cb fd ff ff       	call   800401 <fd2data>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80063b:	89 d8                	mov    %ebx,%eax
  80063d:	c1 e8 16             	shr    $0x16,%eax
  800640:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800647:	a8 01                	test   $0x1,%al
  800649:	74 11                	je     80065c <dup+0x74>
  80064b:	89 d8                	mov    %ebx,%eax
  80064d:	c1 e8 0c             	shr    $0xc,%eax
  800650:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800657:	f6 c2 01             	test   $0x1,%dl
  80065a:	75 39                	jne    800695 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80065c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80065f:	89 d0                	mov    %edx,%eax
  800661:	c1 e8 0c             	shr    $0xc,%eax
  800664:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80066b:	83 ec 0c             	sub    $0xc,%esp
  80066e:	25 07 0e 00 00       	and    $0xe07,%eax
  800673:	50                   	push   %eax
  800674:	56                   	push   %esi
  800675:	6a 00                	push   $0x0
  800677:	52                   	push   %edx
  800678:	6a 00                	push   $0x0
  80067a:	e8 00 fb ff ff       	call   80017f <sys_page_map>
  80067f:	89 c3                	mov    %eax,%ebx
  800681:	83 c4 20             	add    $0x20,%esp
  800684:	85 c0                	test   %eax,%eax
  800686:	78 31                	js     8006b9 <dup+0xd1>
		goto err;

	return newfdnum;
  800688:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80068b:	89 d8                	mov    %ebx,%eax
  80068d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800690:	5b                   	pop    %ebx
  800691:	5e                   	pop    %esi
  800692:	5f                   	pop    %edi
  800693:	5d                   	pop    %ebp
  800694:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  800695:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80069c:	83 ec 0c             	sub    $0xc,%esp
  80069f:	25 07 0e 00 00       	and    $0xe07,%eax
  8006a4:	50                   	push   %eax
  8006a5:	57                   	push   %edi
  8006a6:	6a 00                	push   $0x0
  8006a8:	53                   	push   %ebx
  8006a9:	6a 00                	push   $0x0
  8006ab:	e8 cf fa ff ff       	call   80017f <sys_page_map>
  8006b0:	89 c3                	mov    %eax,%ebx
  8006b2:	83 c4 20             	add    $0x20,%esp
  8006b5:	85 c0                	test   %eax,%eax
  8006b7:	79 a3                	jns    80065c <dup+0x74>
	sys_page_unmap(0, newfd);
  8006b9:	83 ec 08             	sub    $0x8,%esp
  8006bc:	56                   	push   %esi
  8006bd:	6a 00                	push   $0x0
  8006bf:	e8 fd fa ff ff       	call   8001c1 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006c4:	83 c4 08             	add    $0x8,%esp
  8006c7:	57                   	push   %edi
  8006c8:	6a 00                	push   $0x0
  8006ca:	e8 f2 fa ff ff       	call   8001c1 <sys_page_unmap>
	return r;
  8006cf:	83 c4 10             	add    $0x10,%esp
  8006d2:	eb b7                	jmp    80068b <dup+0xa3>

008006d4 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006d4:	55                   	push   %ebp
  8006d5:	89 e5                	mov    %esp,%ebp
  8006d7:	53                   	push   %ebx
  8006d8:	83 ec 14             	sub    $0x14,%esp
  8006db:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006de:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006e1:	50                   	push   %eax
  8006e2:	53                   	push   %ebx
  8006e3:	e8 7f fd ff ff       	call   800467 <fd_lookup>
  8006e8:	83 c4 08             	add    $0x8,%esp
  8006eb:	85 c0                	test   %eax,%eax
  8006ed:	78 3f                	js     80072e <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006ef:	83 ec 08             	sub    $0x8,%esp
  8006f2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006f5:	50                   	push   %eax
  8006f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006f9:	ff 30                	pushl  (%eax)
  8006fb:	e8 be fd ff ff       	call   8004be <dev_lookup>
  800700:	83 c4 10             	add    $0x10,%esp
  800703:	85 c0                	test   %eax,%eax
  800705:	78 27                	js     80072e <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800707:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80070a:	8b 42 08             	mov    0x8(%edx),%eax
  80070d:	83 e0 03             	and    $0x3,%eax
  800710:	83 f8 01             	cmp    $0x1,%eax
  800713:	74 1e                	je     800733 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800718:	8b 40 08             	mov    0x8(%eax),%eax
  80071b:	85 c0                	test   %eax,%eax
  80071d:	74 35                	je     800754 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80071f:	83 ec 04             	sub    $0x4,%esp
  800722:	ff 75 10             	pushl  0x10(%ebp)
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	52                   	push   %edx
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
}
  80072e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800731:	c9                   	leave  
  800732:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800733:	a1 04 40 80 00       	mov    0x804004,%eax
  800738:	8b 40 48             	mov    0x48(%eax),%eax
  80073b:	83 ec 04             	sub    $0x4,%esp
  80073e:	53                   	push   %ebx
  80073f:	50                   	push   %eax
  800740:	68 79 1f 80 00       	push   $0x801f79
  800745:	e8 c5 0a 00 00       	call   80120f <cprintf>
		return -E_INVAL;
  80074a:	83 c4 10             	add    $0x10,%esp
  80074d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800752:	eb da                	jmp    80072e <read+0x5a>
		return -E_NOT_SUPP;
  800754:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800759:	eb d3                	jmp    80072e <read+0x5a>

0080075b <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80075b:	55                   	push   %ebp
  80075c:	89 e5                	mov    %esp,%ebp
  80075e:	57                   	push   %edi
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	8b 7d 08             	mov    0x8(%ebp),%edi
  800767:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80076a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80076f:	39 f3                	cmp    %esi,%ebx
  800771:	73 25                	jae    800798 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800773:	83 ec 04             	sub    $0x4,%esp
  800776:	89 f0                	mov    %esi,%eax
  800778:	29 d8                	sub    %ebx,%eax
  80077a:	50                   	push   %eax
  80077b:	89 d8                	mov    %ebx,%eax
  80077d:	03 45 0c             	add    0xc(%ebp),%eax
  800780:	50                   	push   %eax
  800781:	57                   	push   %edi
  800782:	e8 4d ff ff ff       	call   8006d4 <read>
		if (m < 0)
  800787:	83 c4 10             	add    $0x10,%esp
  80078a:	85 c0                	test   %eax,%eax
  80078c:	78 08                	js     800796 <readn+0x3b>
			return m;
		if (m == 0)
  80078e:	85 c0                	test   %eax,%eax
  800790:	74 06                	je     800798 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  800792:	01 c3                	add    %eax,%ebx
  800794:	eb d9                	jmp    80076f <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800796:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  800798:	89 d8                	mov    %ebx,%eax
  80079a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80079d:	5b                   	pop    %ebx
  80079e:	5e                   	pop    %esi
  80079f:	5f                   	pop    %edi
  8007a0:	5d                   	pop    %ebp
  8007a1:	c3                   	ret    

008007a2 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007a2:	55                   	push   %ebp
  8007a3:	89 e5                	mov    %esp,%ebp
  8007a5:	53                   	push   %ebx
  8007a6:	83 ec 14             	sub    $0x14,%esp
  8007a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007af:	50                   	push   %eax
  8007b0:	53                   	push   %ebx
  8007b1:	e8 b1 fc ff ff       	call   800467 <fd_lookup>
  8007b6:	83 c4 08             	add    $0x8,%esp
  8007b9:	85 c0                	test   %eax,%eax
  8007bb:	78 3a                	js     8007f7 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007bd:	83 ec 08             	sub    $0x8,%esp
  8007c0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007c3:	50                   	push   %eax
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	ff 30                	pushl  (%eax)
  8007c9:	e8 f0 fc ff ff       	call   8004be <dev_lookup>
  8007ce:	83 c4 10             	add    $0x10,%esp
  8007d1:	85 c0                	test   %eax,%eax
  8007d3:	78 22                	js     8007f7 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d8:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007dc:	74 1e                	je     8007fc <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007de:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e1:	8b 52 0c             	mov    0xc(%edx),%edx
  8007e4:	85 d2                	test   %edx,%edx
  8007e6:	74 35                	je     80081d <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007e8:	83 ec 04             	sub    $0x4,%esp
  8007eb:	ff 75 10             	pushl  0x10(%ebp)
  8007ee:	ff 75 0c             	pushl  0xc(%ebp)
  8007f1:	50                   	push   %eax
  8007f2:	ff d2                	call   *%edx
  8007f4:	83 c4 10             	add    $0x10,%esp
}
  8007f7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007fa:	c9                   	leave  
  8007fb:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  8007fc:	a1 04 40 80 00       	mov    0x804004,%eax
  800801:	8b 40 48             	mov    0x48(%eax),%eax
  800804:	83 ec 04             	sub    $0x4,%esp
  800807:	53                   	push   %ebx
  800808:	50                   	push   %eax
  800809:	68 95 1f 80 00       	push   $0x801f95
  80080e:	e8 fc 09 00 00       	call   80120f <cprintf>
		return -E_INVAL;
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80081b:	eb da                	jmp    8007f7 <write+0x55>
		return -E_NOT_SUPP;
  80081d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800822:	eb d3                	jmp    8007f7 <write+0x55>

00800824 <seek>:

int
seek(int fdnum, off_t offset)
{
  800824:	55                   	push   %ebp
  800825:	89 e5                	mov    %esp,%ebp
  800827:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80082a:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80082d:	50                   	push   %eax
  80082e:	ff 75 08             	pushl  0x8(%ebp)
  800831:	e8 31 fc ff ff       	call   800467 <fd_lookup>
  800836:	83 c4 08             	add    $0x8,%esp
  800839:	85 c0                	test   %eax,%eax
  80083b:	78 0e                	js     80084b <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80083d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800840:	8b 55 0c             	mov    0xc(%ebp),%edx
  800843:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800846:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80084b:	c9                   	leave  
  80084c:	c3                   	ret    

0080084d <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80084d:	55                   	push   %ebp
  80084e:	89 e5                	mov    %esp,%ebp
  800850:	53                   	push   %ebx
  800851:	83 ec 14             	sub    $0x14,%esp
  800854:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800857:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80085a:	50                   	push   %eax
  80085b:	53                   	push   %ebx
  80085c:	e8 06 fc ff ff       	call   800467 <fd_lookup>
  800861:	83 c4 08             	add    $0x8,%esp
  800864:	85 c0                	test   %eax,%eax
  800866:	78 37                	js     80089f <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800868:	83 ec 08             	sub    $0x8,%esp
  80086b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80086e:	50                   	push   %eax
  80086f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800872:	ff 30                	pushl  (%eax)
  800874:	e8 45 fc ff ff       	call   8004be <dev_lookup>
  800879:	83 c4 10             	add    $0x10,%esp
  80087c:	85 c0                	test   %eax,%eax
  80087e:	78 1f                	js     80089f <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800883:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800887:	74 1b                	je     8008a4 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800889:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088c:	8b 52 18             	mov    0x18(%edx),%edx
  80088f:	85 d2                	test   %edx,%edx
  800891:	74 32                	je     8008c5 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	50                   	push   %eax
  80089a:	ff d2                	call   *%edx
  80089c:	83 c4 10             	add    $0x10,%esp
}
  80089f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008a2:	c9                   	leave  
  8008a3:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008a4:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008a9:	8b 40 48             	mov    0x48(%eax),%eax
  8008ac:	83 ec 04             	sub    $0x4,%esp
  8008af:	53                   	push   %ebx
  8008b0:	50                   	push   %eax
  8008b1:	68 58 1f 80 00       	push   $0x801f58
  8008b6:	e8 54 09 00 00       	call   80120f <cprintf>
		return -E_INVAL;
  8008bb:	83 c4 10             	add    $0x10,%esp
  8008be:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008c3:	eb da                	jmp    80089f <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008c5:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008ca:	eb d3                	jmp    80089f <ftruncate+0x52>

008008cc <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008cc:	55                   	push   %ebp
  8008cd:	89 e5                	mov    %esp,%ebp
  8008cf:	53                   	push   %ebx
  8008d0:	83 ec 14             	sub    $0x14,%esp
  8008d3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008d6:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008d9:	50                   	push   %eax
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 85 fb ff ff       	call   800467 <fd_lookup>
  8008e2:	83 c4 08             	add    $0x8,%esp
  8008e5:	85 c0                	test   %eax,%eax
  8008e7:	78 4b                	js     800934 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008f3:	ff 30                	pushl  (%eax)
  8008f5:	e8 c4 fb ff ff       	call   8004be <dev_lookup>
  8008fa:	83 c4 10             	add    $0x10,%esp
  8008fd:	85 c0                	test   %eax,%eax
  8008ff:	78 33                	js     800934 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800904:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800908:	74 2f                	je     800939 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80090a:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80090d:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800914:	00 00 00 
	stat->st_type = 0;
  800917:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80091e:	00 00 00 
	stat->st_dev = dev;
  800921:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	53                   	push   %ebx
  80092b:	ff 75 f0             	pushl  -0x10(%ebp)
  80092e:	ff 50 14             	call   *0x14(%eax)
  800931:	83 c4 10             	add    $0x10,%esp
}
  800934:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800937:	c9                   	leave  
  800938:	c3                   	ret    
		return -E_NOT_SUPP;
  800939:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80093e:	eb f4                	jmp    800934 <fstat+0x68>

00800940 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800940:	55                   	push   %ebp
  800941:	89 e5                	mov    %esp,%ebp
  800943:	56                   	push   %esi
  800944:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	6a 00                	push   $0x0
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	e8 34 02 00 00       	call   800b86 <open>
  800952:	89 c3                	mov    %eax,%ebx
  800954:	83 c4 10             	add    $0x10,%esp
  800957:	85 c0                	test   %eax,%eax
  800959:	78 1b                	js     800976 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 0c             	pushl  0xc(%ebp)
  800961:	50                   	push   %eax
  800962:	e8 65 ff ff ff       	call   8008cc <fstat>
  800967:	89 c6                	mov    %eax,%esi
	close(fd);
  800969:	89 1c 24             	mov    %ebx,(%esp)
  80096c:	e8 29 fc ff ff       	call   80059a <close>
	return r;
  800971:	83 c4 10             	add    $0x10,%esp
  800974:	89 f3                	mov    %esi,%ebx
}
  800976:	89 d8                	mov    %ebx,%eax
  800978:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80097b:	5b                   	pop    %ebx
  80097c:	5e                   	pop    %esi
  80097d:	5d                   	pop    %ebp
  80097e:	c3                   	ret    

0080097f <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  80097f:	55                   	push   %ebp
  800980:	89 e5                	mov    %esp,%ebp
  800982:	56                   	push   %esi
  800983:	53                   	push   %ebx
  800984:	89 c6                	mov    %eax,%esi
  800986:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800988:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  80098f:	74 27                	je     8009b8 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  800991:	6a 07                	push   $0x7
  800993:	68 00 50 80 00       	push   $0x805000
  800998:	56                   	push   %esi
  800999:	ff 35 00 40 80 00    	pushl  0x804000
  80099f:	e8 14 12 00 00       	call   801bb8 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009a4:	83 c4 0c             	add    $0xc,%esp
  8009a7:	6a 00                	push   $0x0
  8009a9:	53                   	push   %ebx
  8009aa:	6a 00                	push   $0x0
  8009ac:	e8 7e 11 00 00       	call   801b2f <ipc_recv>
}
  8009b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009b4:	5b                   	pop    %ebx
  8009b5:	5e                   	pop    %esi
  8009b6:	5d                   	pop    %ebp
  8009b7:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009b8:	83 ec 0c             	sub    $0xc,%esp
  8009bb:	6a 01                	push   $0x1
  8009bd:	e8 52 12 00 00       	call   801c14 <ipc_find_env>
  8009c2:	a3 00 40 80 00       	mov    %eax,0x804000
  8009c7:	83 c4 10             	add    $0x10,%esp
  8009ca:	eb c5                	jmp    800991 <fsipc+0x12>

008009cc <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009cc:	55                   	push   %ebp
  8009cd:	89 e5                	mov    %esp,%ebp
  8009cf:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8009d8:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e0:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8009ea:	b8 02 00 00 00       	mov    $0x2,%eax
  8009ef:	e8 8b ff ff ff       	call   80097f <fsipc>
}
  8009f4:	c9                   	leave  
  8009f5:	c3                   	ret    

008009f6 <devfile_flush>:
{
  8009f6:	55                   	push   %ebp
  8009f7:	89 e5                	mov    %esp,%ebp
  8009f9:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  8009fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ff:	8b 40 0c             	mov    0xc(%eax),%eax
  800a02:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a07:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0c:	b8 06 00 00 00       	mov    $0x6,%eax
  800a11:	e8 69 ff ff ff       	call   80097f <fsipc>
}
  800a16:	c9                   	leave  
  800a17:	c3                   	ret    

00800a18 <devfile_stat>:
{
  800a18:	55                   	push   %ebp
  800a19:	89 e5                	mov    %esp,%ebp
  800a1b:	53                   	push   %ebx
  800a1c:	83 ec 04             	sub    $0x4,%esp
  800a1f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a22:	8b 45 08             	mov    0x8(%ebp),%eax
  800a25:	8b 40 0c             	mov    0xc(%eax),%eax
  800a28:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a2d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a32:	b8 05 00 00 00       	mov    $0x5,%eax
  800a37:	e8 43 ff ff ff       	call   80097f <fsipc>
  800a3c:	85 c0                	test   %eax,%eax
  800a3e:	78 2c                	js     800a6c <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a40:	83 ec 08             	sub    $0x8,%esp
  800a43:	68 00 50 80 00       	push   $0x805000
  800a48:	53                   	push   %ebx
  800a49:	e8 c9 0d 00 00       	call   801817 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a4e:	a1 80 50 80 00       	mov    0x805080,%eax
  800a53:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a59:	a1 84 50 80 00       	mov    0x805084,%eax
  800a5e:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a64:	83 c4 10             	add    $0x10,%esp
  800a67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a6c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a6f:	c9                   	leave  
  800a70:	c3                   	ret    

00800a71 <devfile_write>:
{
  800a71:	55                   	push   %ebp
  800a72:	89 e5                	mov    %esp,%ebp
  800a74:	53                   	push   %ebx
  800a75:	83 ec 04             	sub    $0x4,%esp
  800a78:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a7b:	89 d8                	mov    %ebx,%eax
  800a7d:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a83:	76 05                	jbe    800a8a <devfile_write+0x19>
  800a85:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800a8d:	8b 52 0c             	mov    0xc(%edx),%edx
  800a90:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800a96:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800a9b:	83 ec 04             	sub    $0x4,%esp
  800a9e:	50                   	push   %eax
  800a9f:	ff 75 0c             	pushl  0xc(%ebp)
  800aa2:	68 08 50 80 00       	push   $0x805008
  800aa7:	e8 de 0e 00 00       	call   80198a <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800aac:	ba 00 00 00 00       	mov    $0x0,%edx
  800ab1:	b8 04 00 00 00       	mov    $0x4,%eax
  800ab6:	e8 c4 fe ff ff       	call   80097f <fsipc>
  800abb:	83 c4 10             	add    $0x10,%esp
  800abe:	85 c0                	test   %eax,%eax
  800ac0:	78 0b                	js     800acd <devfile_write+0x5c>
	assert(r <= n);
  800ac2:	39 c3                	cmp    %eax,%ebx
  800ac4:	72 0c                	jb     800ad2 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800ac6:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800acb:	7f 1e                	jg     800aeb <devfile_write+0x7a>
}
  800acd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad0:	c9                   	leave  
  800ad1:	c3                   	ret    
	assert(r <= n);
  800ad2:	68 c4 1f 80 00       	push   $0x801fc4
  800ad7:	68 cb 1f 80 00       	push   $0x801fcb
  800adc:	68 98 00 00 00       	push   $0x98
  800ae1:	68 e0 1f 80 00       	push   $0x801fe0
  800ae6:	e8 11 06 00 00       	call   8010fc <_panic>
	assert(r <= PGSIZE);
  800aeb:	68 eb 1f 80 00       	push   $0x801feb
  800af0:	68 cb 1f 80 00       	push   $0x801fcb
  800af5:	68 99 00 00 00       	push   $0x99
  800afa:	68 e0 1f 80 00       	push   $0x801fe0
  800aff:	e8 f8 05 00 00       	call   8010fc <_panic>

00800b04 <devfile_read>:
{
  800b04:	55                   	push   %ebp
  800b05:	89 e5                	mov    %esp,%ebp
  800b07:	56                   	push   %esi
  800b08:	53                   	push   %ebx
  800b09:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b0f:	8b 40 0c             	mov    0xc(%eax),%eax
  800b12:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b17:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b1d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b22:	b8 03 00 00 00       	mov    $0x3,%eax
  800b27:	e8 53 fe ff ff       	call   80097f <fsipc>
  800b2c:	89 c3                	mov    %eax,%ebx
  800b2e:	85 c0                	test   %eax,%eax
  800b30:	78 1f                	js     800b51 <devfile_read+0x4d>
	assert(r <= n);
  800b32:	39 c6                	cmp    %eax,%esi
  800b34:	72 24                	jb     800b5a <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b36:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b3b:	7f 33                	jg     800b70 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b3d:	83 ec 04             	sub    $0x4,%esp
  800b40:	50                   	push   %eax
  800b41:	68 00 50 80 00       	push   $0x805000
  800b46:	ff 75 0c             	pushl  0xc(%ebp)
  800b49:	e8 3c 0e 00 00       	call   80198a <memmove>
	return r;
  800b4e:	83 c4 10             	add    $0x10,%esp
}
  800b51:	89 d8                	mov    %ebx,%eax
  800b53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b56:	5b                   	pop    %ebx
  800b57:	5e                   	pop    %esi
  800b58:	5d                   	pop    %ebp
  800b59:	c3                   	ret    
	assert(r <= n);
  800b5a:	68 c4 1f 80 00       	push   $0x801fc4
  800b5f:	68 cb 1f 80 00       	push   $0x801fcb
  800b64:	6a 7c                	push   $0x7c
  800b66:	68 e0 1f 80 00       	push   $0x801fe0
  800b6b:	e8 8c 05 00 00       	call   8010fc <_panic>
	assert(r <= PGSIZE);
  800b70:	68 eb 1f 80 00       	push   $0x801feb
  800b75:	68 cb 1f 80 00       	push   $0x801fcb
  800b7a:	6a 7d                	push   $0x7d
  800b7c:	68 e0 1f 80 00       	push   $0x801fe0
  800b81:	e8 76 05 00 00       	call   8010fc <_panic>

00800b86 <open>:
{
  800b86:	55                   	push   %ebp
  800b87:	89 e5                	mov    %esp,%ebp
  800b89:	56                   	push   %esi
  800b8a:	53                   	push   %ebx
  800b8b:	83 ec 1c             	sub    $0x1c,%esp
  800b8e:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b91:	56                   	push   %esi
  800b92:	e8 4d 0c 00 00       	call   8017e4 <strlen>
  800b97:	83 c4 10             	add    $0x10,%esp
  800b9a:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800b9f:	7f 6c                	jg     800c0d <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800ba1:	83 ec 0c             	sub    $0xc,%esp
  800ba4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	e8 6b f8 ff ff       	call   800418 <fd_alloc>
  800bad:	89 c3                	mov    %eax,%ebx
  800baf:	83 c4 10             	add    $0x10,%esp
  800bb2:	85 c0                	test   %eax,%eax
  800bb4:	78 3c                	js     800bf2 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bb6:	83 ec 08             	sub    $0x8,%esp
  800bb9:	56                   	push   %esi
  800bba:	68 00 50 80 00       	push   $0x805000
  800bbf:	e8 53 0c 00 00       	call   801817 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc7:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcf:	b8 01 00 00 00       	mov    $0x1,%eax
  800bd4:	e8 a6 fd ff ff       	call   80097f <fsipc>
  800bd9:	89 c3                	mov    %eax,%ebx
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	85 c0                	test   %eax,%eax
  800be0:	78 19                	js     800bfb <open+0x75>
	return fd2num(fd);
  800be2:	83 ec 0c             	sub    $0xc,%esp
  800be5:	ff 75 f4             	pushl  -0xc(%ebp)
  800be8:	e8 04 f8 ff ff       	call   8003f1 <fd2num>
  800bed:	89 c3                	mov    %eax,%ebx
  800bef:	83 c4 10             	add    $0x10,%esp
}
  800bf2:	89 d8                	mov    %ebx,%eax
  800bf4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf7:	5b                   	pop    %ebx
  800bf8:	5e                   	pop    %esi
  800bf9:	5d                   	pop    %ebp
  800bfa:	c3                   	ret    
		fd_close(fd, 0);
  800bfb:	83 ec 08             	sub    $0x8,%esp
  800bfe:	6a 00                	push   $0x0
  800c00:	ff 75 f4             	pushl  -0xc(%ebp)
  800c03:	e8 0c f9 ff ff       	call   800514 <fd_close>
		return r;
  800c08:	83 c4 10             	add    $0x10,%esp
  800c0b:	eb e5                	jmp    800bf2 <open+0x6c>
		return -E_BAD_PATH;
  800c0d:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c12:	eb de                	jmp    800bf2 <open+0x6c>

00800c14 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c14:	55                   	push   %ebp
  800c15:	89 e5                	mov    %esp,%ebp
  800c17:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  800c1f:	b8 08 00 00 00       	mov    $0x8,%eax
  800c24:	e8 56 fd ff ff       	call   80097f <fsipc>
}
  800c29:	c9                   	leave  
  800c2a:	c3                   	ret    

00800c2b <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c2b:	55                   	push   %ebp
  800c2c:	89 e5                	mov    %esp,%ebp
  800c2e:	56                   	push   %esi
  800c2f:	53                   	push   %ebx
  800c30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c33:	83 ec 0c             	sub    $0xc,%esp
  800c36:	ff 75 08             	pushl  0x8(%ebp)
  800c39:	e8 c3 f7 ff ff       	call   800401 <fd2data>
  800c3e:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c40:	83 c4 08             	add    $0x8,%esp
  800c43:	68 f7 1f 80 00       	push   $0x801ff7
  800c48:	53                   	push   %ebx
  800c49:	e8 c9 0b 00 00       	call   801817 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c4e:	8b 46 04             	mov    0x4(%esi),%eax
  800c51:	2b 06                	sub    (%esi),%eax
  800c53:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c59:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c60:	10 00 00 
	stat->st_dev = &devpipe;
  800c63:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c6a:	30 80 00 
	return 0;
}
  800c6d:	b8 00 00 00 00       	mov    $0x0,%eax
  800c72:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c75:	5b                   	pop    %ebx
  800c76:	5e                   	pop    %esi
  800c77:	5d                   	pop    %ebp
  800c78:	c3                   	ret    

00800c79 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c79:	55                   	push   %ebp
  800c7a:	89 e5                	mov    %esp,%ebp
  800c7c:	53                   	push   %ebx
  800c7d:	83 ec 0c             	sub    $0xc,%esp
  800c80:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c83:	53                   	push   %ebx
  800c84:	6a 00                	push   $0x0
  800c86:	e8 36 f5 ff ff       	call   8001c1 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c8b:	89 1c 24             	mov    %ebx,(%esp)
  800c8e:	e8 6e f7 ff ff       	call   800401 <fd2data>
  800c93:	83 c4 08             	add    $0x8,%esp
  800c96:	50                   	push   %eax
  800c97:	6a 00                	push   $0x0
  800c99:	e8 23 f5 ff ff       	call   8001c1 <sys_page_unmap>
}
  800c9e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ca1:	c9                   	leave  
  800ca2:	c3                   	ret    

00800ca3 <_pipeisclosed>:
{
  800ca3:	55                   	push   %ebp
  800ca4:	89 e5                	mov    %esp,%ebp
  800ca6:	57                   	push   %edi
  800ca7:	56                   	push   %esi
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 1c             	sub    $0x1c,%esp
  800cac:	89 c7                	mov    %eax,%edi
  800cae:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cb0:	a1 04 40 80 00       	mov    0x804004,%eax
  800cb5:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cb8:	83 ec 0c             	sub    $0xc,%esp
  800cbb:	57                   	push   %edi
  800cbc:	e8 95 0f 00 00       	call   801c56 <pageref>
  800cc1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cc4:	89 34 24             	mov    %esi,(%esp)
  800cc7:	e8 8a 0f 00 00       	call   801c56 <pageref>
		nn = thisenv->env_runs;
  800ccc:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cd2:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cd5:	83 c4 10             	add    $0x10,%esp
  800cd8:	39 cb                	cmp    %ecx,%ebx
  800cda:	74 1b                	je     800cf7 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800cdc:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cdf:	75 cf                	jne    800cb0 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800ce1:	8b 42 58             	mov    0x58(%edx),%eax
  800ce4:	6a 01                	push   $0x1
  800ce6:	50                   	push   %eax
  800ce7:	53                   	push   %ebx
  800ce8:	68 fe 1f 80 00       	push   $0x801ffe
  800ced:	e8 1d 05 00 00       	call   80120f <cprintf>
  800cf2:	83 c4 10             	add    $0x10,%esp
  800cf5:	eb b9                	jmp    800cb0 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800cf7:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cfa:	0f 94 c0             	sete   %al
  800cfd:	0f b6 c0             	movzbl %al,%eax
}
  800d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d03:	5b                   	pop    %ebx
  800d04:	5e                   	pop    %esi
  800d05:	5f                   	pop    %edi
  800d06:	5d                   	pop    %ebp
  800d07:	c3                   	ret    

00800d08 <devpipe_write>:
{
  800d08:	55                   	push   %ebp
  800d09:	89 e5                	mov    %esp,%ebp
  800d0b:	57                   	push   %edi
  800d0c:	56                   	push   %esi
  800d0d:	53                   	push   %ebx
  800d0e:	83 ec 18             	sub    $0x18,%esp
  800d11:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d14:	56                   	push   %esi
  800d15:	e8 e7 f6 ff ff       	call   800401 <fd2data>
  800d1a:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d1c:	83 c4 10             	add    $0x10,%esp
  800d1f:	bf 00 00 00 00       	mov    $0x0,%edi
  800d24:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d27:	74 41                	je     800d6a <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d29:	8b 53 04             	mov    0x4(%ebx),%edx
  800d2c:	8b 03                	mov    (%ebx),%eax
  800d2e:	83 c0 20             	add    $0x20,%eax
  800d31:	39 c2                	cmp    %eax,%edx
  800d33:	72 14                	jb     800d49 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d35:	89 da                	mov    %ebx,%edx
  800d37:	89 f0                	mov    %esi,%eax
  800d39:	e8 65 ff ff ff       	call   800ca3 <_pipeisclosed>
  800d3e:	85 c0                	test   %eax,%eax
  800d40:	75 2c                	jne    800d6e <devpipe_write+0x66>
			sys_yield();
  800d42:	e8 bc f4 ff ff       	call   800203 <sys_yield>
  800d47:	eb e0                	jmp    800d29 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4c:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d4f:	89 d0                	mov    %edx,%eax
  800d51:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d56:	78 0b                	js     800d63 <devpipe_write+0x5b>
  800d58:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d5c:	42                   	inc    %edx
  800d5d:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d60:	47                   	inc    %edi
  800d61:	eb c1                	jmp    800d24 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d63:	48                   	dec    %eax
  800d64:	83 c8 e0             	or     $0xffffffe0,%eax
  800d67:	40                   	inc    %eax
  800d68:	eb ee                	jmp    800d58 <devpipe_write+0x50>
	return i;
  800d6a:	89 f8                	mov    %edi,%eax
  800d6c:	eb 05                	jmp    800d73 <devpipe_write+0x6b>
				return 0;
  800d6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d73:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d76:	5b                   	pop    %ebx
  800d77:	5e                   	pop    %esi
  800d78:	5f                   	pop    %edi
  800d79:	5d                   	pop    %ebp
  800d7a:	c3                   	ret    

00800d7b <devpipe_read>:
{
  800d7b:	55                   	push   %ebp
  800d7c:	89 e5                	mov    %esp,%ebp
  800d7e:	57                   	push   %edi
  800d7f:	56                   	push   %esi
  800d80:	53                   	push   %ebx
  800d81:	83 ec 18             	sub    $0x18,%esp
  800d84:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d87:	57                   	push   %edi
  800d88:	e8 74 f6 ff ff       	call   800401 <fd2data>
  800d8d:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800d8f:	83 c4 10             	add    $0x10,%esp
  800d92:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d97:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800d9a:	74 46                	je     800de2 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800d9c:	8b 06                	mov    (%esi),%eax
  800d9e:	3b 46 04             	cmp    0x4(%esi),%eax
  800da1:	75 22                	jne    800dc5 <devpipe_read+0x4a>
			if (i > 0)
  800da3:	85 db                	test   %ebx,%ebx
  800da5:	74 0a                	je     800db1 <devpipe_read+0x36>
				return i;
  800da7:	89 d8                	mov    %ebx,%eax
}
  800da9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dac:	5b                   	pop    %ebx
  800dad:	5e                   	pop    %esi
  800dae:	5f                   	pop    %edi
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800db1:	89 f2                	mov    %esi,%edx
  800db3:	89 f8                	mov    %edi,%eax
  800db5:	e8 e9 fe ff ff       	call   800ca3 <_pipeisclosed>
  800dba:	85 c0                	test   %eax,%eax
  800dbc:	75 28                	jne    800de6 <devpipe_read+0x6b>
			sys_yield();
  800dbe:	e8 40 f4 ff ff       	call   800203 <sys_yield>
  800dc3:	eb d7                	jmp    800d9c <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dc5:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800dca:	78 0f                	js     800ddb <devpipe_read+0x60>
  800dcc:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dd0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dd3:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800dd6:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800dd8:	43                   	inc    %ebx
  800dd9:	eb bc                	jmp    800d97 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800ddb:	48                   	dec    %eax
  800ddc:	83 c8 e0             	or     $0xffffffe0,%eax
  800ddf:	40                   	inc    %eax
  800de0:	eb ea                	jmp    800dcc <devpipe_read+0x51>
	return i;
  800de2:	89 d8                	mov    %ebx,%eax
  800de4:	eb c3                	jmp    800da9 <devpipe_read+0x2e>
				return 0;
  800de6:	b8 00 00 00 00       	mov    $0x0,%eax
  800deb:	eb bc                	jmp    800da9 <devpipe_read+0x2e>

00800ded <pipe>:
{
  800ded:	55                   	push   %ebp
  800dee:	89 e5                	mov    %esp,%ebp
  800df0:	56                   	push   %esi
  800df1:	53                   	push   %ebx
  800df2:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800df5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800df8:	50                   	push   %eax
  800df9:	e8 1a f6 ff ff       	call   800418 <fd_alloc>
  800dfe:	89 c3                	mov    %eax,%ebx
  800e00:	83 c4 10             	add    $0x10,%esp
  800e03:	85 c0                	test   %eax,%eax
  800e05:	0f 88 2a 01 00 00    	js     800f35 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e0b:	83 ec 04             	sub    $0x4,%esp
  800e0e:	68 07 04 00 00       	push   $0x407
  800e13:	ff 75 f4             	pushl  -0xc(%ebp)
  800e16:	6a 00                	push   $0x0
  800e18:	e8 1f f3 ff ff       	call   80013c <sys_page_alloc>
  800e1d:	89 c3                	mov    %eax,%ebx
  800e1f:	83 c4 10             	add    $0x10,%esp
  800e22:	85 c0                	test   %eax,%eax
  800e24:	0f 88 0b 01 00 00    	js     800f35 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e2a:	83 ec 0c             	sub    $0xc,%esp
  800e2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e30:	50                   	push   %eax
  800e31:	e8 e2 f5 ff ff       	call   800418 <fd_alloc>
  800e36:	89 c3                	mov    %eax,%ebx
  800e38:	83 c4 10             	add    $0x10,%esp
  800e3b:	85 c0                	test   %eax,%eax
  800e3d:	0f 88 e2 00 00 00    	js     800f25 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e43:	83 ec 04             	sub    $0x4,%esp
  800e46:	68 07 04 00 00       	push   $0x407
  800e4b:	ff 75 f0             	pushl  -0x10(%ebp)
  800e4e:	6a 00                	push   $0x0
  800e50:	e8 e7 f2 ff ff       	call   80013c <sys_page_alloc>
  800e55:	89 c3                	mov    %eax,%ebx
  800e57:	83 c4 10             	add    $0x10,%esp
  800e5a:	85 c0                	test   %eax,%eax
  800e5c:	0f 88 c3 00 00 00    	js     800f25 <pipe+0x138>
	va = fd2data(fd0);
  800e62:	83 ec 0c             	sub    $0xc,%esp
  800e65:	ff 75 f4             	pushl  -0xc(%ebp)
  800e68:	e8 94 f5 ff ff       	call   800401 <fd2data>
  800e6d:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e6f:	83 c4 0c             	add    $0xc,%esp
  800e72:	68 07 04 00 00       	push   $0x407
  800e77:	50                   	push   %eax
  800e78:	6a 00                	push   $0x0
  800e7a:	e8 bd f2 ff ff       	call   80013c <sys_page_alloc>
  800e7f:	89 c3                	mov    %eax,%ebx
  800e81:	83 c4 10             	add    $0x10,%esp
  800e84:	85 c0                	test   %eax,%eax
  800e86:	0f 88 89 00 00 00    	js     800f15 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e8c:	83 ec 0c             	sub    $0xc,%esp
  800e8f:	ff 75 f0             	pushl  -0x10(%ebp)
  800e92:	e8 6a f5 ff ff       	call   800401 <fd2data>
  800e97:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800e9e:	50                   	push   %eax
  800e9f:	6a 00                	push   $0x0
  800ea1:	56                   	push   %esi
  800ea2:	6a 00                	push   $0x0
  800ea4:	e8 d6 f2 ff ff       	call   80017f <sys_page_map>
  800ea9:	89 c3                	mov    %eax,%ebx
  800eab:	83 c4 20             	add    $0x20,%esp
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	78 55                	js     800f07 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800eb2:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebb:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ec7:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ecd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed0:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ed2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed5:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800edc:	83 ec 0c             	sub    $0xc,%esp
  800edf:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee2:	e8 0a f5 ff ff       	call   8003f1 <fd2num>
  800ee7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800eea:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800eec:	83 c4 04             	add    $0x4,%esp
  800eef:	ff 75 f0             	pushl  -0x10(%ebp)
  800ef2:	e8 fa f4 ff ff       	call   8003f1 <fd2num>
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800efd:	83 c4 10             	add    $0x10,%esp
  800f00:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f05:	eb 2e                	jmp    800f35 <pipe+0x148>
	sys_page_unmap(0, va);
  800f07:	83 ec 08             	sub    $0x8,%esp
  800f0a:	56                   	push   %esi
  800f0b:	6a 00                	push   $0x0
  800f0d:	e8 af f2 ff ff       	call   8001c1 <sys_page_unmap>
  800f12:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f15:	83 ec 08             	sub    $0x8,%esp
  800f18:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1b:	6a 00                	push   $0x0
  800f1d:	e8 9f f2 ff ff       	call   8001c1 <sys_page_unmap>
  800f22:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f25:	83 ec 08             	sub    $0x8,%esp
  800f28:	ff 75 f4             	pushl  -0xc(%ebp)
  800f2b:	6a 00                	push   $0x0
  800f2d:	e8 8f f2 ff ff       	call   8001c1 <sys_page_unmap>
  800f32:	83 c4 10             	add    $0x10,%esp
}
  800f35:	89 d8                	mov    %ebx,%eax
  800f37:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f3a:	5b                   	pop    %ebx
  800f3b:	5e                   	pop    %esi
  800f3c:	5d                   	pop    %ebp
  800f3d:	c3                   	ret    

00800f3e <pipeisclosed>:
{
  800f3e:	55                   	push   %ebp
  800f3f:	89 e5                	mov    %esp,%ebp
  800f41:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f44:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f47:	50                   	push   %eax
  800f48:	ff 75 08             	pushl  0x8(%ebp)
  800f4b:	e8 17 f5 ff ff       	call   800467 <fd_lookup>
  800f50:	83 c4 10             	add    $0x10,%esp
  800f53:	85 c0                	test   %eax,%eax
  800f55:	78 18                	js     800f6f <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f57:	83 ec 0c             	sub    $0xc,%esp
  800f5a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f5d:	e8 9f f4 ff ff       	call   800401 <fd2data>
	return _pipeisclosed(fd, p);
  800f62:	89 c2                	mov    %eax,%edx
  800f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f67:	e8 37 fd ff ff       	call   800ca3 <_pipeisclosed>
  800f6c:	83 c4 10             	add    $0x10,%esp
}
  800f6f:	c9                   	leave  
  800f70:	c3                   	ret    

00800f71 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f71:	55                   	push   %ebp
  800f72:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f74:	b8 00 00 00 00       	mov    $0x0,%eax
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	53                   	push   %ebx
  800f7f:	83 ec 0c             	sub    $0xc,%esp
  800f82:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f85:	68 16 20 80 00       	push   $0x802016
  800f8a:	53                   	push   %ebx
  800f8b:	e8 87 08 00 00       	call   801817 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800f90:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800f97:	20 00 00 
	return 0;
}
  800f9a:	b8 00 00 00 00       	mov    $0x0,%eax
  800f9f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <devcons_write>:
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
  800fa7:	57                   	push   %edi
  800fa8:	56                   	push   %esi
  800fa9:	53                   	push   %ebx
  800faa:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fb0:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fb5:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fbb:	eb 1d                	jmp    800fda <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fbd:	83 ec 04             	sub    $0x4,%esp
  800fc0:	53                   	push   %ebx
  800fc1:	03 45 0c             	add    0xc(%ebp),%eax
  800fc4:	50                   	push   %eax
  800fc5:	57                   	push   %edi
  800fc6:	e8 bf 09 00 00       	call   80198a <memmove>
		sys_cputs(buf, m);
  800fcb:	83 c4 08             	add    $0x8,%esp
  800fce:	53                   	push   %ebx
  800fcf:	57                   	push   %edi
  800fd0:	e8 ca f0 ff ff       	call   80009f <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fd5:	01 de                	add    %ebx,%esi
  800fd7:	83 c4 10             	add    $0x10,%esp
  800fda:	89 f0                	mov    %esi,%eax
  800fdc:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fdf:	73 11                	jae    800ff2 <devcons_write+0x4e>
		m = n - tot;
  800fe1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fe4:	29 f3                	sub    %esi,%ebx
  800fe6:	83 fb 7f             	cmp    $0x7f,%ebx
  800fe9:	76 d2                	jbe    800fbd <devcons_write+0x19>
  800feb:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800ff0:	eb cb                	jmp    800fbd <devcons_write+0x19>
}
  800ff2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <devcons_read>:
{
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801000:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801004:	75 0c                	jne    801012 <devcons_read+0x18>
		return 0;
  801006:	b8 00 00 00 00       	mov    $0x0,%eax
  80100b:	eb 21                	jmp    80102e <devcons_read+0x34>
		sys_yield();
  80100d:	e8 f1 f1 ff ff       	call   800203 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801012:	e8 a6 f0 ff ff       	call   8000bd <sys_cgetc>
  801017:	85 c0                	test   %eax,%eax
  801019:	74 f2                	je     80100d <devcons_read+0x13>
	if (c < 0)
  80101b:	85 c0                	test   %eax,%eax
  80101d:	78 0f                	js     80102e <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80101f:	83 f8 04             	cmp    $0x4,%eax
  801022:	74 0c                	je     801030 <devcons_read+0x36>
	*(char*)vbuf = c;
  801024:	8b 55 0c             	mov    0xc(%ebp),%edx
  801027:	88 02                	mov    %al,(%edx)
	return 1;
  801029:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    
		return 0;
  801030:	b8 00 00 00 00       	mov    $0x0,%eax
  801035:	eb f7                	jmp    80102e <devcons_read+0x34>

00801037 <cputchar>:
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
  801040:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801043:	6a 01                	push   $0x1
  801045:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801048:	50                   	push   %eax
  801049:	e8 51 f0 ff ff       	call   80009f <sys_cputs>
}
  80104e:	83 c4 10             	add    $0x10,%esp
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <getchar>:
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801059:	6a 01                	push   $0x1
  80105b:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80105e:	50                   	push   %eax
  80105f:	6a 00                	push   $0x0
  801061:	e8 6e f6 ff ff       	call   8006d4 <read>
	if (r < 0)
  801066:	83 c4 10             	add    $0x10,%esp
  801069:	85 c0                	test   %eax,%eax
  80106b:	78 08                	js     801075 <getchar+0x22>
	if (r < 1)
  80106d:	85 c0                	test   %eax,%eax
  80106f:	7e 06                	jle    801077 <getchar+0x24>
	return c;
  801071:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    
		return -E_EOF;
  801077:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80107c:	eb f7                	jmp    801075 <getchar+0x22>

0080107e <iscons>:
{
  80107e:	55                   	push   %ebp
  80107f:	89 e5                	mov    %esp,%ebp
  801081:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801084:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801087:	50                   	push   %eax
  801088:	ff 75 08             	pushl  0x8(%ebp)
  80108b:	e8 d7 f3 ff ff       	call   800467 <fd_lookup>
  801090:	83 c4 10             	add    $0x10,%esp
  801093:	85 c0                	test   %eax,%eax
  801095:	78 11                	js     8010a8 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010a0:	39 10                	cmp    %edx,(%eax)
  8010a2:	0f 94 c0             	sete   %al
  8010a5:	0f b6 c0             	movzbl %al,%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <opencons>:
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b3:	50                   	push   %eax
  8010b4:	e8 5f f3 ff ff       	call   800418 <fd_alloc>
  8010b9:	83 c4 10             	add    $0x10,%esp
  8010bc:	85 c0                	test   %eax,%eax
  8010be:	78 3a                	js     8010fa <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010c0:	83 ec 04             	sub    $0x4,%esp
  8010c3:	68 07 04 00 00       	push   $0x407
  8010c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8010cb:	6a 00                	push   $0x0
  8010cd:	e8 6a f0 ff ff       	call   80013c <sys_page_alloc>
  8010d2:	83 c4 10             	add    $0x10,%esp
  8010d5:	85 c0                	test   %eax,%eax
  8010d7:	78 21                	js     8010fa <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010d9:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e2:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e7:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010ee:	83 ec 0c             	sub    $0xc,%esp
  8010f1:	50                   	push   %eax
  8010f2:	e8 fa f2 ff ff       	call   8003f1 <fd2num>
  8010f7:	83 c4 10             	add    $0x10,%esp
}
  8010fa:	c9                   	leave  
  8010fb:	c3                   	ret    

008010fc <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  8010fc:	55                   	push   %ebp
  8010fd:	89 e5                	mov    %esp,%ebp
  8010ff:	57                   	push   %edi
  801100:	56                   	push   %esi
  801101:	53                   	push   %ebx
  801102:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801108:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80110b:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801111:	e8 07 f0 ff ff       	call   80011d <sys_getenvid>
  801116:	83 ec 04             	sub    $0x4,%esp
  801119:	ff 75 0c             	pushl  0xc(%ebp)
  80111c:	ff 75 08             	pushl  0x8(%ebp)
  80111f:	53                   	push   %ebx
  801120:	50                   	push   %eax
  801121:	68 24 20 80 00       	push   $0x802024
  801126:	68 00 01 00 00       	push   $0x100
  80112b:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801131:	56                   	push   %esi
  801132:	e8 93 06 00 00       	call   8017ca <snprintf>
  801137:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801139:	83 c4 20             	add    $0x20,%esp
  80113c:	57                   	push   %edi
  80113d:	ff 75 10             	pushl  0x10(%ebp)
  801140:	bf 00 01 00 00       	mov    $0x100,%edi
  801145:	89 f8                	mov    %edi,%eax
  801147:	29 d8                	sub    %ebx,%eax
  801149:	50                   	push   %eax
  80114a:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80114d:	50                   	push   %eax
  80114e:	e8 22 06 00 00       	call   801775 <vsnprintf>
  801153:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801155:	83 c4 0c             	add    $0xc,%esp
  801158:	68 0f 20 80 00       	push   $0x80200f
  80115d:	29 df                	sub    %ebx,%edi
  80115f:	57                   	push   %edi
  801160:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801163:	50                   	push   %eax
  801164:	e8 61 06 00 00       	call   8017ca <snprintf>
	sys_cputs(buf, r);
  801169:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80116c:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80116e:	53                   	push   %ebx
  80116f:	56                   	push   %esi
  801170:	e8 2a ef ff ff       	call   80009f <sys_cputs>
  801175:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801178:	cc                   	int3   
  801179:	eb fd                	jmp    801178 <_panic+0x7c>

0080117b <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80117b:	55                   	push   %ebp
  80117c:	89 e5                	mov    %esp,%ebp
  80117e:	53                   	push   %ebx
  80117f:	83 ec 04             	sub    $0x4,%esp
  801182:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801185:	8b 13                	mov    (%ebx),%edx
  801187:	8d 42 01             	lea    0x1(%edx),%eax
  80118a:	89 03                	mov    %eax,(%ebx)
  80118c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80118f:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  801193:	3d ff 00 00 00       	cmp    $0xff,%eax
  801198:	74 08                	je     8011a2 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  80119a:	ff 43 04             	incl   0x4(%ebx)
}
  80119d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011a2:	83 ec 08             	sub    $0x8,%esp
  8011a5:	68 ff 00 00 00       	push   $0xff
  8011aa:	8d 43 08             	lea    0x8(%ebx),%eax
  8011ad:	50                   	push   %eax
  8011ae:	e8 ec ee ff ff       	call   80009f <sys_cputs>
		b->idx = 0;
  8011b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011b9:	83 c4 10             	add    $0x10,%esp
  8011bc:	eb dc                	jmp    80119a <putch+0x1f>

008011be <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011be:	55                   	push   %ebp
  8011bf:	89 e5                	mov    %esp,%ebp
  8011c1:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011c7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011ce:	00 00 00 
	b.cnt = 0;
  8011d1:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011d8:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011db:	ff 75 0c             	pushl  0xc(%ebp)
  8011de:	ff 75 08             	pushl  0x8(%ebp)
  8011e1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011e7:	50                   	push   %eax
  8011e8:	68 7b 11 80 00       	push   $0x80117b
  8011ed:	e8 17 01 00 00       	call   801309 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011f2:	83 c4 08             	add    $0x8,%esp
  8011f5:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  8011fb:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801201:	50                   	push   %eax
  801202:	e8 98 ee ff ff       	call   80009f <sys_cputs>

	return b.cnt;
}
  801207:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80120d:	c9                   	leave  
  80120e:	c3                   	ret    

0080120f <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80120f:	55                   	push   %ebp
  801210:	89 e5                	mov    %esp,%ebp
  801212:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801215:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801218:	50                   	push   %eax
  801219:	ff 75 08             	pushl  0x8(%ebp)
  80121c:	e8 9d ff ff ff       	call   8011be <vcprintf>
	va_end(ap);

	return cnt;
}
  801221:	c9                   	leave  
  801222:	c3                   	ret    

00801223 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801223:	55                   	push   %ebp
  801224:	89 e5                	mov    %esp,%ebp
  801226:	57                   	push   %edi
  801227:	56                   	push   %esi
  801228:	53                   	push   %ebx
  801229:	83 ec 1c             	sub    $0x1c,%esp
  80122c:	89 c7                	mov    %eax,%edi
  80122e:	89 d6                	mov    %edx,%esi
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8b 55 0c             	mov    0xc(%ebp),%edx
  801236:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801239:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80123c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80123f:	bb 00 00 00 00       	mov    $0x0,%ebx
  801244:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801247:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80124a:	39 d3                	cmp    %edx,%ebx
  80124c:	72 05                	jb     801253 <printnum+0x30>
  80124e:	39 45 10             	cmp    %eax,0x10(%ebp)
  801251:	77 78                	ja     8012cb <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801253:	83 ec 0c             	sub    $0xc,%esp
  801256:	ff 75 18             	pushl  0x18(%ebp)
  801259:	8b 45 14             	mov    0x14(%ebp),%eax
  80125c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80125f:	53                   	push   %ebx
  801260:	ff 75 10             	pushl  0x10(%ebp)
  801263:	83 ec 08             	sub    $0x8,%esp
  801266:	ff 75 e4             	pushl  -0x1c(%ebp)
  801269:	ff 75 e0             	pushl  -0x20(%ebp)
  80126c:	ff 75 dc             	pushl  -0x24(%ebp)
  80126f:	ff 75 d8             	pushl  -0x28(%ebp)
  801272:	e8 25 0a 00 00       	call   801c9c <__udivdi3>
  801277:	83 c4 18             	add    $0x18,%esp
  80127a:	52                   	push   %edx
  80127b:	50                   	push   %eax
  80127c:	89 f2                	mov    %esi,%edx
  80127e:	89 f8                	mov    %edi,%eax
  801280:	e8 9e ff ff ff       	call   801223 <printnum>
  801285:	83 c4 20             	add    $0x20,%esp
  801288:	eb 11                	jmp    80129b <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80128a:	83 ec 08             	sub    $0x8,%esp
  80128d:	56                   	push   %esi
  80128e:	ff 75 18             	pushl  0x18(%ebp)
  801291:	ff d7                	call   *%edi
  801293:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  801296:	4b                   	dec    %ebx
  801297:	85 db                	test   %ebx,%ebx
  801299:	7f ef                	jg     80128a <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	56                   	push   %esi
  80129f:	83 ec 04             	sub    $0x4,%esp
  8012a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012a5:	ff 75 e0             	pushl  -0x20(%ebp)
  8012a8:	ff 75 dc             	pushl  -0x24(%ebp)
  8012ab:	ff 75 d8             	pushl  -0x28(%ebp)
  8012ae:	e8 f9 0a 00 00       	call   801dac <__umoddi3>
  8012b3:	83 c4 14             	add    $0x14,%esp
  8012b6:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  8012bd:	50                   	push   %eax
  8012be:	ff d7                	call   *%edi
}
  8012c0:	83 c4 10             	add    $0x10,%esp
  8012c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012c6:	5b                   	pop    %ebx
  8012c7:	5e                   	pop    %esi
  8012c8:	5f                   	pop    %edi
  8012c9:	5d                   	pop    %ebp
  8012ca:	c3                   	ret    
  8012cb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012ce:	eb c6                	jmp    801296 <printnum+0x73>

008012d0 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012d0:	55                   	push   %ebp
  8012d1:	89 e5                	mov    %esp,%ebp
  8012d3:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012d6:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012d9:	8b 10                	mov    (%eax),%edx
  8012db:	3b 50 04             	cmp    0x4(%eax),%edx
  8012de:	73 0a                	jae    8012ea <sprintputch+0x1a>
		*b->buf++ = ch;
  8012e0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012e3:	89 08                	mov    %ecx,(%eax)
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	88 02                	mov    %al,(%edx)
}
  8012ea:	5d                   	pop    %ebp
  8012eb:	c3                   	ret    

008012ec <printfmt>:
{
  8012ec:	55                   	push   %ebp
  8012ed:	89 e5                	mov    %esp,%ebp
  8012ef:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012f2:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012f5:	50                   	push   %eax
  8012f6:	ff 75 10             	pushl  0x10(%ebp)
  8012f9:	ff 75 0c             	pushl  0xc(%ebp)
  8012fc:	ff 75 08             	pushl  0x8(%ebp)
  8012ff:	e8 05 00 00 00       	call   801309 <vprintfmt>
}
  801304:	83 c4 10             	add    $0x10,%esp
  801307:	c9                   	leave  
  801308:	c3                   	ret    

00801309 <vprintfmt>:
{
  801309:	55                   	push   %ebp
  80130a:	89 e5                	mov    %esp,%ebp
  80130c:	57                   	push   %edi
  80130d:	56                   	push   %esi
  80130e:	53                   	push   %ebx
  80130f:	83 ec 2c             	sub    $0x2c,%esp
  801312:	8b 75 08             	mov    0x8(%ebp),%esi
  801315:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801318:	8b 7d 10             	mov    0x10(%ebp),%edi
  80131b:	e9 ae 03 00 00       	jmp    8016ce <vprintfmt+0x3c5>
  801320:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801324:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80132b:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801332:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801339:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80133e:	8d 47 01             	lea    0x1(%edi),%eax
  801341:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801344:	8a 17                	mov    (%edi),%dl
  801346:	8d 42 dd             	lea    -0x23(%edx),%eax
  801349:	3c 55                	cmp    $0x55,%al
  80134b:	0f 87 fe 03 00 00    	ja     80174f <vprintfmt+0x446>
  801351:	0f b6 c0             	movzbl %al,%eax
  801354:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  80135b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80135e:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801362:	eb da                	jmp    80133e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801367:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80136b:	eb d1                	jmp    80133e <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80136d:	0f b6 d2             	movzbl %dl,%edx
  801370:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801373:	b8 00 00 00 00       	mov    $0x0,%eax
  801378:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80137b:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80137e:	01 c0                	add    %eax,%eax
  801380:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801384:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801387:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80138a:	83 f9 09             	cmp    $0x9,%ecx
  80138d:	77 52                	ja     8013e1 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  80138f:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801390:	eb e9                	jmp    80137b <vprintfmt+0x72>
			precision = va_arg(ap, int);
  801392:	8b 45 14             	mov    0x14(%ebp),%eax
  801395:	8b 00                	mov    (%eax),%eax
  801397:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80139a:	8b 45 14             	mov    0x14(%ebp),%eax
  80139d:	8d 40 04             	lea    0x4(%eax),%eax
  8013a0:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013a6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013aa:	79 92                	jns    80133e <vprintfmt+0x35>
				width = precision, precision = -1;
  8013ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b2:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013b9:	eb 83                	jmp    80133e <vprintfmt+0x35>
  8013bb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013bf:	78 08                	js     8013c9 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013c1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013c4:	e9 75 ff ff ff       	jmp    80133e <vprintfmt+0x35>
  8013c9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013d0:	eb ef                	jmp    8013c1 <vprintfmt+0xb8>
  8013d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013d5:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013dc:	e9 5d ff ff ff       	jmp    80133e <vprintfmt+0x35>
  8013e1:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013e7:	eb bd                	jmp    8013a6 <vprintfmt+0x9d>
			lflag++;
  8013e9:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013ed:	e9 4c ff ff ff       	jmp    80133e <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8013f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8013f5:	8d 78 04             	lea    0x4(%eax),%edi
  8013f8:	83 ec 08             	sub    $0x8,%esp
  8013fb:	53                   	push   %ebx
  8013fc:	ff 30                	pushl  (%eax)
  8013fe:	ff d6                	call   *%esi
			break;
  801400:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801403:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801406:	e9 c0 02 00 00       	jmp    8016cb <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80140b:	8b 45 14             	mov    0x14(%ebp),%eax
  80140e:	8d 78 04             	lea    0x4(%eax),%edi
  801411:	8b 00                	mov    (%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	78 2a                	js     801441 <vprintfmt+0x138>
  801417:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801419:	83 f8 0f             	cmp    $0xf,%eax
  80141c:	7f 27                	jg     801445 <vprintfmt+0x13c>
  80141e:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  801425:	85 c0                	test   %eax,%eax
  801427:	74 1c                	je     801445 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  801429:	50                   	push   %eax
  80142a:	68 dd 1f 80 00       	push   $0x801fdd
  80142f:	53                   	push   %ebx
  801430:	56                   	push   %esi
  801431:	e8 b6 fe ff ff       	call   8012ec <printfmt>
  801436:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801439:	89 7d 14             	mov    %edi,0x14(%ebp)
  80143c:	e9 8a 02 00 00       	jmp    8016cb <vprintfmt+0x3c2>
  801441:	f7 d8                	neg    %eax
  801443:	eb d2                	jmp    801417 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801445:	52                   	push   %edx
  801446:	68 5f 20 80 00       	push   $0x80205f
  80144b:	53                   	push   %ebx
  80144c:	56                   	push   %esi
  80144d:	e8 9a fe ff ff       	call   8012ec <printfmt>
  801452:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801455:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801458:	e9 6e 02 00 00       	jmp    8016cb <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80145d:	8b 45 14             	mov    0x14(%ebp),%eax
  801460:	83 c0 04             	add    $0x4,%eax
  801463:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	8b 38                	mov    (%eax),%edi
  80146b:	85 ff                	test   %edi,%edi
  80146d:	74 39                	je     8014a8 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80146f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801473:	0f 8e a9 00 00 00    	jle    801522 <vprintfmt+0x219>
  801479:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80147d:	0f 84 a7 00 00 00    	je     80152a <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801483:	83 ec 08             	sub    $0x8,%esp
  801486:	ff 75 d0             	pushl  -0x30(%ebp)
  801489:	57                   	push   %edi
  80148a:	e8 6b 03 00 00       	call   8017fa <strnlen>
  80148f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  801492:	29 c1                	sub    %eax,%ecx
  801494:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  801497:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  80149a:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  80149e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014a1:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014a4:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014a6:	eb 14                	jmp    8014bc <vprintfmt+0x1b3>
				p = "(null)";
  8014a8:	bf 58 20 80 00       	mov    $0x802058,%edi
  8014ad:	eb c0                	jmp    80146f <vprintfmt+0x166>
					putch(padc, putdat);
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	53                   	push   %ebx
  8014b3:	ff 75 e0             	pushl  -0x20(%ebp)
  8014b6:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b8:	4f                   	dec    %edi
  8014b9:	83 c4 10             	add    $0x10,%esp
  8014bc:	85 ff                	test   %edi,%edi
  8014be:	7f ef                	jg     8014af <vprintfmt+0x1a6>
  8014c0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014c3:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014c6:	89 c8                	mov    %ecx,%eax
  8014c8:	85 c9                	test   %ecx,%ecx
  8014ca:	78 10                	js     8014dc <vprintfmt+0x1d3>
  8014cc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014cf:	29 c1                	sub    %eax,%ecx
  8014d1:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014d4:	89 75 08             	mov    %esi,0x8(%ebp)
  8014d7:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014da:	eb 15                	jmp    8014f1 <vprintfmt+0x1e8>
  8014dc:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e1:	eb e9                	jmp    8014cc <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014e3:	83 ec 08             	sub    $0x8,%esp
  8014e6:	53                   	push   %ebx
  8014e7:	52                   	push   %edx
  8014e8:	ff 55 08             	call   *0x8(%ebp)
  8014eb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ee:	ff 4d e0             	decl   -0x20(%ebp)
  8014f1:	47                   	inc    %edi
  8014f2:	8a 47 ff             	mov    -0x1(%edi),%al
  8014f5:	0f be d0             	movsbl %al,%edx
  8014f8:	85 d2                	test   %edx,%edx
  8014fa:	74 59                	je     801555 <vprintfmt+0x24c>
  8014fc:	85 f6                	test   %esi,%esi
  8014fe:	78 03                	js     801503 <vprintfmt+0x1fa>
  801500:	4e                   	dec    %esi
  801501:	78 2f                	js     801532 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801503:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801507:	74 da                	je     8014e3 <vprintfmt+0x1da>
  801509:	0f be c0             	movsbl %al,%eax
  80150c:	83 e8 20             	sub    $0x20,%eax
  80150f:	83 f8 5e             	cmp    $0x5e,%eax
  801512:	76 cf                	jbe    8014e3 <vprintfmt+0x1da>
					putch('?', putdat);
  801514:	83 ec 08             	sub    $0x8,%esp
  801517:	53                   	push   %ebx
  801518:	6a 3f                	push   $0x3f
  80151a:	ff 55 08             	call   *0x8(%ebp)
  80151d:	83 c4 10             	add    $0x10,%esp
  801520:	eb cc                	jmp    8014ee <vprintfmt+0x1e5>
  801522:	89 75 08             	mov    %esi,0x8(%ebp)
  801525:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801528:	eb c7                	jmp    8014f1 <vprintfmt+0x1e8>
  80152a:	89 75 08             	mov    %esi,0x8(%ebp)
  80152d:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801530:	eb bf                	jmp    8014f1 <vprintfmt+0x1e8>
  801532:	8b 75 08             	mov    0x8(%ebp),%esi
  801535:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801538:	eb 0c                	jmp    801546 <vprintfmt+0x23d>
				putch(' ', putdat);
  80153a:	83 ec 08             	sub    $0x8,%esp
  80153d:	53                   	push   %ebx
  80153e:	6a 20                	push   $0x20
  801540:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801542:	4f                   	dec    %edi
  801543:	83 c4 10             	add    $0x10,%esp
  801546:	85 ff                	test   %edi,%edi
  801548:	7f f0                	jg     80153a <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80154a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80154d:	89 45 14             	mov    %eax,0x14(%ebp)
  801550:	e9 76 01 00 00       	jmp    8016cb <vprintfmt+0x3c2>
  801555:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801558:	8b 75 08             	mov    0x8(%ebp),%esi
  80155b:	eb e9                	jmp    801546 <vprintfmt+0x23d>
	if (lflag >= 2)
  80155d:	83 f9 01             	cmp    $0x1,%ecx
  801560:	7f 1f                	jg     801581 <vprintfmt+0x278>
	else if (lflag)
  801562:	85 c9                	test   %ecx,%ecx
  801564:	75 48                	jne    8015ae <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801566:	8b 45 14             	mov    0x14(%ebp),%eax
  801569:	8b 00                	mov    (%eax),%eax
  80156b:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80156e:	89 c1                	mov    %eax,%ecx
  801570:	c1 f9 1f             	sar    $0x1f,%ecx
  801573:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801576:	8b 45 14             	mov    0x14(%ebp),%eax
  801579:	8d 40 04             	lea    0x4(%eax),%eax
  80157c:	89 45 14             	mov    %eax,0x14(%ebp)
  80157f:	eb 17                	jmp    801598 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801581:	8b 45 14             	mov    0x14(%ebp),%eax
  801584:	8b 50 04             	mov    0x4(%eax),%edx
  801587:	8b 00                	mov    (%eax),%eax
  801589:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80158c:	89 55 dc             	mov    %edx,-0x24(%ebp)
  80158f:	8b 45 14             	mov    0x14(%ebp),%eax
  801592:	8d 40 08             	lea    0x8(%eax),%eax
  801595:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  801598:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80159b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  80159e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015a2:	78 25                	js     8015c9 <vprintfmt+0x2c0>
			base = 10;
  8015a4:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015a9:	e9 03 01 00 00       	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b1:	8b 00                	mov    (%eax),%eax
  8015b3:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015b6:	89 c1                	mov    %eax,%ecx
  8015b8:	c1 f9 1f             	sar    $0x1f,%ecx
  8015bb:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015be:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c1:	8d 40 04             	lea    0x4(%eax),%eax
  8015c4:	89 45 14             	mov    %eax,0x14(%ebp)
  8015c7:	eb cf                	jmp    801598 <vprintfmt+0x28f>
				putch('-', putdat);
  8015c9:	83 ec 08             	sub    $0x8,%esp
  8015cc:	53                   	push   %ebx
  8015cd:	6a 2d                	push   $0x2d
  8015cf:	ff d6                	call   *%esi
				num = -(long long) num;
  8015d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015d4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015d7:	f7 da                	neg    %edx
  8015d9:	83 d1 00             	adc    $0x0,%ecx
  8015dc:	f7 d9                	neg    %ecx
  8015de:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015e1:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015e6:	e9 c6 00 00 00       	jmp    8016b1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015eb:	83 f9 01             	cmp    $0x1,%ecx
  8015ee:	7f 1e                	jg     80160e <vprintfmt+0x305>
	else if (lflag)
  8015f0:	85 c9                	test   %ecx,%ecx
  8015f2:	75 32                	jne    801626 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8015f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8015f7:	8b 10                	mov    (%eax),%edx
  8015f9:	b9 00 00 00 00       	mov    $0x0,%ecx
  8015fe:	8d 40 04             	lea    0x4(%eax),%eax
  801601:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801604:	b8 0a 00 00 00       	mov    $0xa,%eax
  801609:	e9 a3 00 00 00       	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80160e:	8b 45 14             	mov    0x14(%ebp),%eax
  801611:	8b 10                	mov    (%eax),%edx
  801613:	8b 48 04             	mov    0x4(%eax),%ecx
  801616:	8d 40 08             	lea    0x8(%eax),%eax
  801619:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80161c:	b8 0a 00 00 00       	mov    $0xa,%eax
  801621:	e9 8b 00 00 00       	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801626:	8b 45 14             	mov    0x14(%ebp),%eax
  801629:	8b 10                	mov    (%eax),%edx
  80162b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801630:	8d 40 04             	lea    0x4(%eax),%eax
  801633:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801636:	b8 0a 00 00 00       	mov    $0xa,%eax
  80163b:	eb 74                	jmp    8016b1 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80163d:	83 f9 01             	cmp    $0x1,%ecx
  801640:	7f 1b                	jg     80165d <vprintfmt+0x354>
	else if (lflag)
  801642:	85 c9                	test   %ecx,%ecx
  801644:	75 2c                	jne    801672 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801646:	8b 45 14             	mov    0x14(%ebp),%eax
  801649:	8b 10                	mov    (%eax),%edx
  80164b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801650:	8d 40 04             	lea    0x4(%eax),%eax
  801653:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801656:	b8 08 00 00 00       	mov    $0x8,%eax
  80165b:	eb 54                	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80165d:	8b 45 14             	mov    0x14(%ebp),%eax
  801660:	8b 10                	mov    (%eax),%edx
  801662:	8b 48 04             	mov    0x4(%eax),%ecx
  801665:	8d 40 08             	lea    0x8(%eax),%eax
  801668:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80166b:	b8 08 00 00 00       	mov    $0x8,%eax
  801670:	eb 3f                	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801672:	8b 45 14             	mov    0x14(%ebp),%eax
  801675:	8b 10                	mov    (%eax),%edx
  801677:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167c:	8d 40 04             	lea    0x4(%eax),%eax
  80167f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801682:	b8 08 00 00 00       	mov    $0x8,%eax
  801687:	eb 28                	jmp    8016b1 <vprintfmt+0x3a8>
			putch('0', putdat);
  801689:	83 ec 08             	sub    $0x8,%esp
  80168c:	53                   	push   %ebx
  80168d:	6a 30                	push   $0x30
  80168f:	ff d6                	call   *%esi
			putch('x', putdat);
  801691:	83 c4 08             	add    $0x8,%esp
  801694:	53                   	push   %ebx
  801695:	6a 78                	push   $0x78
  801697:	ff d6                	call   *%esi
			num = (unsigned long long)
  801699:	8b 45 14             	mov    0x14(%ebp),%eax
  80169c:	8b 10                	mov    (%eax),%edx
  80169e:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016a3:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016a6:	8d 40 04             	lea    0x4(%eax),%eax
  8016a9:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016ac:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016b1:	83 ec 0c             	sub    $0xc,%esp
  8016b4:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016b8:	57                   	push   %edi
  8016b9:	ff 75 e0             	pushl  -0x20(%ebp)
  8016bc:	50                   	push   %eax
  8016bd:	51                   	push   %ecx
  8016be:	52                   	push   %edx
  8016bf:	89 da                	mov    %ebx,%edx
  8016c1:	89 f0                	mov    %esi,%eax
  8016c3:	e8 5b fb ff ff       	call   801223 <printnum>
			break;
  8016c8:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016ce:	47                   	inc    %edi
  8016cf:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016d3:	83 f8 25             	cmp    $0x25,%eax
  8016d6:	0f 84 44 fc ff ff    	je     801320 <vprintfmt+0x17>
			if (ch == '\0')
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	0f 84 89 00 00 00    	je     80176d <vprintfmt+0x464>
			putch(ch, putdat);
  8016e4:	83 ec 08             	sub    $0x8,%esp
  8016e7:	53                   	push   %ebx
  8016e8:	50                   	push   %eax
  8016e9:	ff d6                	call   *%esi
  8016eb:	83 c4 10             	add    $0x10,%esp
  8016ee:	eb de                	jmp    8016ce <vprintfmt+0x3c5>
	if (lflag >= 2)
  8016f0:	83 f9 01             	cmp    $0x1,%ecx
  8016f3:	7f 1b                	jg     801710 <vprintfmt+0x407>
	else if (lflag)
  8016f5:	85 c9                	test   %ecx,%ecx
  8016f7:	75 2c                	jne    801725 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  8016f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016fc:	8b 10                	mov    (%eax),%edx
  8016fe:	b9 00 00 00 00       	mov    $0x0,%ecx
  801703:	8d 40 04             	lea    0x4(%eax),%eax
  801706:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801709:	b8 10 00 00 00       	mov    $0x10,%eax
  80170e:	eb a1                	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801710:	8b 45 14             	mov    0x14(%ebp),%eax
  801713:	8b 10                	mov    (%eax),%edx
  801715:	8b 48 04             	mov    0x4(%eax),%ecx
  801718:	8d 40 08             	lea    0x8(%eax),%eax
  80171b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80171e:	b8 10 00 00 00       	mov    $0x10,%eax
  801723:	eb 8c                	jmp    8016b1 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801725:	8b 45 14             	mov    0x14(%ebp),%eax
  801728:	8b 10                	mov    (%eax),%edx
  80172a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172f:	8d 40 04             	lea    0x4(%eax),%eax
  801732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801735:	b8 10 00 00 00       	mov    $0x10,%eax
  80173a:	e9 72 ff ff ff       	jmp    8016b1 <vprintfmt+0x3a8>
			putch(ch, putdat);
  80173f:	83 ec 08             	sub    $0x8,%esp
  801742:	53                   	push   %ebx
  801743:	6a 25                	push   $0x25
  801745:	ff d6                	call   *%esi
			break;
  801747:	83 c4 10             	add    $0x10,%esp
  80174a:	e9 7c ff ff ff       	jmp    8016cb <vprintfmt+0x3c2>
			putch('%', putdat);
  80174f:	83 ec 08             	sub    $0x8,%esp
  801752:	53                   	push   %ebx
  801753:	6a 25                	push   $0x25
  801755:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801757:	83 c4 10             	add    $0x10,%esp
  80175a:	89 f8                	mov    %edi,%eax
  80175c:	eb 01                	jmp    80175f <vprintfmt+0x456>
  80175e:	48                   	dec    %eax
  80175f:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801763:	75 f9                	jne    80175e <vprintfmt+0x455>
  801765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801768:	e9 5e ff ff ff       	jmp    8016cb <vprintfmt+0x3c2>
}
  80176d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801770:	5b                   	pop    %ebx
  801771:	5e                   	pop    %esi
  801772:	5f                   	pop    %edi
  801773:	5d                   	pop    %ebp
  801774:	c3                   	ret    

00801775 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801775:	55                   	push   %ebp
  801776:	89 e5                	mov    %esp,%ebp
  801778:	83 ec 18             	sub    $0x18,%esp
  80177b:	8b 45 08             	mov    0x8(%ebp),%eax
  80177e:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801781:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801784:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801788:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80178b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801792:	85 c0                	test   %eax,%eax
  801794:	74 26                	je     8017bc <vsnprintf+0x47>
  801796:	85 d2                	test   %edx,%edx
  801798:	7e 29                	jle    8017c3 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80179a:	ff 75 14             	pushl  0x14(%ebp)
  80179d:	ff 75 10             	pushl  0x10(%ebp)
  8017a0:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017a3:	50                   	push   %eax
  8017a4:	68 d0 12 80 00       	push   $0x8012d0
  8017a9:	e8 5b fb ff ff       	call   801309 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b1:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b7:	83 c4 10             	add    $0x10,%esp
}
  8017ba:	c9                   	leave  
  8017bb:	c3                   	ret    
		return -E_INVAL;
  8017bc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c1:	eb f7                	jmp    8017ba <vsnprintf+0x45>
  8017c3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017c8:	eb f0                	jmp    8017ba <vsnprintf+0x45>

008017ca <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d0:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017d3:	50                   	push   %eax
  8017d4:	ff 75 10             	pushl  0x10(%ebp)
  8017d7:	ff 75 0c             	pushl  0xc(%ebp)
  8017da:	ff 75 08             	pushl  0x8(%ebp)
  8017dd:	e8 93 ff ff ff       	call   801775 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017e2:	c9                   	leave  
  8017e3:	c3                   	ret    

008017e4 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017e4:	55                   	push   %ebp
  8017e5:	89 e5                	mov    %esp,%ebp
  8017e7:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	eb 01                	jmp    8017f2 <strlen+0xe>
		n++;
  8017f1:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8017f2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017f6:	75 f9                	jne    8017f1 <strlen+0xd>
	return n;
}
  8017f8:	5d                   	pop    %ebp
  8017f9:	c3                   	ret    

008017fa <strnlen>:

int
strnlen(const char *s, size_t size)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
  8017fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801803:	b8 00 00 00 00       	mov    $0x0,%eax
  801808:	eb 01                	jmp    80180b <strnlen+0x11>
		n++;
  80180a:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80180b:	39 d0                	cmp    %edx,%eax
  80180d:	74 06                	je     801815 <strnlen+0x1b>
  80180f:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801813:	75 f5                	jne    80180a <strnlen+0x10>
	return n;
}
  801815:	5d                   	pop    %ebp
  801816:	c3                   	ret    

00801817 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801817:	55                   	push   %ebp
  801818:	89 e5                	mov    %esp,%ebp
  80181a:	53                   	push   %ebx
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801821:	89 c2                	mov    %eax,%edx
  801823:	42                   	inc    %edx
  801824:	41                   	inc    %ecx
  801825:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801828:	88 5a ff             	mov    %bl,-0x1(%edx)
  80182b:	84 db                	test   %bl,%bl
  80182d:	75 f4                	jne    801823 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80182f:	5b                   	pop    %ebx
  801830:	5d                   	pop    %ebp
  801831:	c3                   	ret    

00801832 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801832:	55                   	push   %ebp
  801833:	89 e5                	mov    %esp,%ebp
  801835:	53                   	push   %ebx
  801836:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801839:	53                   	push   %ebx
  80183a:	e8 a5 ff ff ff       	call   8017e4 <strlen>
  80183f:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801842:	ff 75 0c             	pushl  0xc(%ebp)
  801845:	01 d8                	add    %ebx,%eax
  801847:	50                   	push   %eax
  801848:	e8 ca ff ff ff       	call   801817 <strcpy>
	return dst;
}
  80184d:	89 d8                	mov    %ebx,%eax
  80184f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801852:	c9                   	leave  
  801853:	c3                   	ret    

00801854 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801854:	55                   	push   %ebp
  801855:	89 e5                	mov    %esp,%ebp
  801857:	56                   	push   %esi
  801858:	53                   	push   %ebx
  801859:	8b 75 08             	mov    0x8(%ebp),%esi
  80185c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80185f:	89 f3                	mov    %esi,%ebx
  801861:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801864:	89 f2                	mov    %esi,%edx
  801866:	eb 0c                	jmp    801874 <strncpy+0x20>
		*dst++ = *src;
  801868:	42                   	inc    %edx
  801869:	8a 01                	mov    (%ecx),%al
  80186b:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80186e:	80 39 01             	cmpb   $0x1,(%ecx)
  801871:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801874:	39 da                	cmp    %ebx,%edx
  801876:	75 f0                	jne    801868 <strncpy+0x14>
	}
	return ret;
}
  801878:	89 f0                	mov    %esi,%eax
  80187a:	5b                   	pop    %ebx
  80187b:	5e                   	pop    %esi
  80187c:	5d                   	pop    %ebp
  80187d:	c3                   	ret    

0080187e <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80187e:	55                   	push   %ebp
  80187f:	89 e5                	mov    %esp,%ebp
  801881:	56                   	push   %esi
  801882:	53                   	push   %ebx
  801883:	8b 75 08             	mov    0x8(%ebp),%esi
  801886:	8b 55 0c             	mov    0xc(%ebp),%edx
  801889:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80188c:	85 c0                	test   %eax,%eax
  80188e:	74 20                	je     8018b0 <strlcpy+0x32>
  801890:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  801894:	89 f0                	mov    %esi,%eax
  801896:	eb 05                	jmp    80189d <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  801898:	40                   	inc    %eax
  801899:	42                   	inc    %edx
  80189a:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  80189d:	39 d8                	cmp    %ebx,%eax
  80189f:	74 06                	je     8018a7 <strlcpy+0x29>
  8018a1:	8a 0a                	mov    (%edx),%cl
  8018a3:	84 c9                	test   %cl,%cl
  8018a5:	75 f1                	jne    801898 <strlcpy+0x1a>
		*dst = '\0';
  8018a7:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018aa:	29 f0                	sub    %esi,%eax
}
  8018ac:	5b                   	pop    %ebx
  8018ad:	5e                   	pop    %esi
  8018ae:	5d                   	pop    %ebp
  8018af:	c3                   	ret    
  8018b0:	89 f0                	mov    %esi,%eax
  8018b2:	eb f6                	jmp    8018aa <strlcpy+0x2c>

008018b4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ba:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018bd:	eb 02                	jmp    8018c1 <strcmp+0xd>
		p++, q++;
  8018bf:	41                   	inc    %ecx
  8018c0:	42                   	inc    %edx
	while (*p && *p == *q)
  8018c1:	8a 01                	mov    (%ecx),%al
  8018c3:	84 c0                	test   %al,%al
  8018c5:	74 04                	je     8018cb <strcmp+0x17>
  8018c7:	3a 02                	cmp    (%edx),%al
  8018c9:	74 f4                	je     8018bf <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018cb:	0f b6 c0             	movzbl %al,%eax
  8018ce:	0f b6 12             	movzbl (%edx),%edx
  8018d1:	29 d0                	sub    %edx,%eax
}
  8018d3:	5d                   	pop    %ebp
  8018d4:	c3                   	ret    

008018d5 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018d5:	55                   	push   %ebp
  8018d6:	89 e5                	mov    %esp,%ebp
  8018d8:	53                   	push   %ebx
  8018d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018df:	89 c3                	mov    %eax,%ebx
  8018e1:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018e4:	eb 02                	jmp    8018e8 <strncmp+0x13>
		n--, p++, q++;
  8018e6:	40                   	inc    %eax
  8018e7:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018e8:	39 d8                	cmp    %ebx,%eax
  8018ea:	74 15                	je     801901 <strncmp+0x2c>
  8018ec:	8a 08                	mov    (%eax),%cl
  8018ee:	84 c9                	test   %cl,%cl
  8018f0:	74 04                	je     8018f6 <strncmp+0x21>
  8018f2:	3a 0a                	cmp    (%edx),%cl
  8018f4:	74 f0                	je     8018e6 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018f6:	0f b6 00             	movzbl (%eax),%eax
  8018f9:	0f b6 12             	movzbl (%edx),%edx
  8018fc:	29 d0                	sub    %edx,%eax
}
  8018fe:	5b                   	pop    %ebx
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    
		return 0;
  801901:	b8 00 00 00 00       	mov    $0x0,%eax
  801906:	eb f6                	jmp    8018fe <strncmp+0x29>

00801908 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801908:	55                   	push   %ebp
  801909:	89 e5                	mov    %esp,%ebp
  80190b:	8b 45 08             	mov    0x8(%ebp),%eax
  80190e:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801911:	8a 10                	mov    (%eax),%dl
  801913:	84 d2                	test   %dl,%dl
  801915:	74 07                	je     80191e <strchr+0x16>
		if (*s == c)
  801917:	38 ca                	cmp    %cl,%dl
  801919:	74 08                	je     801923 <strchr+0x1b>
	for (; *s; s++)
  80191b:	40                   	inc    %eax
  80191c:	eb f3                	jmp    801911 <strchr+0x9>
			return (char *) s;
	return 0;
  80191e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801923:	5d                   	pop    %ebp
  801924:	c3                   	ret    

00801925 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801925:	55                   	push   %ebp
  801926:	89 e5                	mov    %esp,%ebp
  801928:	8b 45 08             	mov    0x8(%ebp),%eax
  80192b:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80192e:	8a 10                	mov    (%eax),%dl
  801930:	84 d2                	test   %dl,%dl
  801932:	74 07                	je     80193b <strfind+0x16>
		if (*s == c)
  801934:	38 ca                	cmp    %cl,%dl
  801936:	74 03                	je     80193b <strfind+0x16>
	for (; *s; s++)
  801938:	40                   	inc    %eax
  801939:	eb f3                	jmp    80192e <strfind+0x9>
			break;
	return (char *) s;
}
  80193b:	5d                   	pop    %ebp
  80193c:	c3                   	ret    

0080193d <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80193d:	55                   	push   %ebp
  80193e:	89 e5                	mov    %esp,%ebp
  801940:	57                   	push   %edi
  801941:	56                   	push   %esi
  801942:	53                   	push   %ebx
  801943:	8b 7d 08             	mov    0x8(%ebp),%edi
  801946:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801949:	85 c9                	test   %ecx,%ecx
  80194b:	74 13                	je     801960 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80194d:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801953:	75 05                	jne    80195a <memset+0x1d>
  801955:	f6 c1 03             	test   $0x3,%cl
  801958:	74 0d                	je     801967 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80195a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80195d:	fc                   	cld    
  80195e:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801960:	89 f8                	mov    %edi,%eax
  801962:	5b                   	pop    %ebx
  801963:	5e                   	pop    %esi
  801964:	5f                   	pop    %edi
  801965:	5d                   	pop    %ebp
  801966:	c3                   	ret    
		c &= 0xFF;
  801967:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80196b:	89 d3                	mov    %edx,%ebx
  80196d:	c1 e3 08             	shl    $0x8,%ebx
  801970:	89 d0                	mov    %edx,%eax
  801972:	c1 e0 18             	shl    $0x18,%eax
  801975:	89 d6                	mov    %edx,%esi
  801977:	c1 e6 10             	shl    $0x10,%esi
  80197a:	09 f0                	or     %esi,%eax
  80197c:	09 c2                	or     %eax,%edx
  80197e:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801980:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801983:	89 d0                	mov    %edx,%eax
  801985:	fc                   	cld    
  801986:	f3 ab                	rep stos %eax,%es:(%edi)
  801988:	eb d6                	jmp    801960 <memset+0x23>

0080198a <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
  80198d:	57                   	push   %edi
  80198e:	56                   	push   %esi
  80198f:	8b 45 08             	mov    0x8(%ebp),%eax
  801992:	8b 75 0c             	mov    0xc(%ebp),%esi
  801995:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801998:	39 c6                	cmp    %eax,%esi
  80199a:	73 33                	jae    8019cf <memmove+0x45>
  80199c:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  80199f:	39 d0                	cmp    %edx,%eax
  8019a1:	73 2c                	jae    8019cf <memmove+0x45>
		s += n;
		d += n;
  8019a3:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019a6:	89 d6                	mov    %edx,%esi
  8019a8:	09 fe                	or     %edi,%esi
  8019aa:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019b0:	75 13                	jne    8019c5 <memmove+0x3b>
  8019b2:	f6 c1 03             	test   $0x3,%cl
  8019b5:	75 0e                	jne    8019c5 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019b7:	83 ef 04             	sub    $0x4,%edi
  8019ba:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019bd:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019c0:	fd                   	std    
  8019c1:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019c3:	eb 07                	jmp    8019cc <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019c5:	4f                   	dec    %edi
  8019c6:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019c9:	fd                   	std    
  8019ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019cc:	fc                   	cld    
  8019cd:	eb 13                	jmp    8019e2 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019cf:	89 f2                	mov    %esi,%edx
  8019d1:	09 c2                	or     %eax,%edx
  8019d3:	f6 c2 03             	test   $0x3,%dl
  8019d6:	75 05                	jne    8019dd <memmove+0x53>
  8019d8:	f6 c1 03             	test   $0x3,%cl
  8019db:	74 09                	je     8019e6 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019dd:	89 c7                	mov    %eax,%edi
  8019df:	fc                   	cld    
  8019e0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019e2:	5e                   	pop    %esi
  8019e3:	5f                   	pop    %edi
  8019e4:	5d                   	pop    %ebp
  8019e5:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019e6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019e9:	89 c7                	mov    %eax,%edi
  8019eb:	fc                   	cld    
  8019ec:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ee:	eb f2                	jmp    8019e2 <memmove+0x58>

008019f0 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019f0:	55                   	push   %ebp
  8019f1:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8019f3:	ff 75 10             	pushl  0x10(%ebp)
  8019f6:	ff 75 0c             	pushl  0xc(%ebp)
  8019f9:	ff 75 08             	pushl  0x8(%ebp)
  8019fc:	e8 89 ff ff ff       	call   80198a <memmove>
}
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	56                   	push   %esi
  801a07:	53                   	push   %ebx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	89 c6                	mov    %eax,%esi
  801a0d:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a10:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a13:	39 f0                	cmp    %esi,%eax
  801a15:	74 16                	je     801a2d <memcmp+0x2a>
		if (*s1 != *s2)
  801a17:	8a 08                	mov    (%eax),%cl
  801a19:	8a 1a                	mov    (%edx),%bl
  801a1b:	38 d9                	cmp    %bl,%cl
  801a1d:	75 04                	jne    801a23 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a1f:	40                   	inc    %eax
  801a20:	42                   	inc    %edx
  801a21:	eb f0                	jmp    801a13 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a23:	0f b6 c1             	movzbl %cl,%eax
  801a26:	0f b6 db             	movzbl %bl,%ebx
  801a29:	29 d8                	sub    %ebx,%eax
  801a2b:	eb 05                	jmp    801a32 <memcmp+0x2f>
	}

	return 0;
  801a2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a32:	5b                   	pop    %ebx
  801a33:	5e                   	pop    %esi
  801a34:	5d                   	pop    %ebp
  801a35:	c3                   	ret    

00801a36 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a36:	55                   	push   %ebp
  801a37:	89 e5                	mov    %esp,%ebp
  801a39:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a3f:	89 c2                	mov    %eax,%edx
  801a41:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a44:	39 d0                	cmp    %edx,%eax
  801a46:	73 07                	jae    801a4f <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a48:	38 08                	cmp    %cl,(%eax)
  801a4a:	74 03                	je     801a4f <memfind+0x19>
	for (; s < ends; s++)
  801a4c:	40                   	inc    %eax
  801a4d:	eb f5                	jmp    801a44 <memfind+0xe>
			break;
	return (void *) s;
}
  801a4f:	5d                   	pop    %ebp
  801a50:	c3                   	ret    

00801a51 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
  801a54:	57                   	push   %edi
  801a55:	56                   	push   %esi
  801a56:	53                   	push   %ebx
  801a57:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a5a:	eb 01                	jmp    801a5d <strtol+0xc>
		s++;
  801a5c:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a5d:	8a 01                	mov    (%ecx),%al
  801a5f:	3c 20                	cmp    $0x20,%al
  801a61:	74 f9                	je     801a5c <strtol+0xb>
  801a63:	3c 09                	cmp    $0x9,%al
  801a65:	74 f5                	je     801a5c <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a67:	3c 2b                	cmp    $0x2b,%al
  801a69:	74 2b                	je     801a96 <strtol+0x45>
		s++;
	else if (*s == '-')
  801a6b:	3c 2d                	cmp    $0x2d,%al
  801a6d:	74 2f                	je     801a9e <strtol+0x4d>
	int neg = 0;
  801a6f:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a74:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a7b:	75 12                	jne    801a8f <strtol+0x3e>
  801a7d:	80 39 30             	cmpb   $0x30,(%ecx)
  801a80:	74 24                	je     801aa6 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a86:	75 07                	jne    801a8f <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a88:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801a8f:	b8 00 00 00 00       	mov    $0x0,%eax
  801a94:	eb 4e                	jmp    801ae4 <strtol+0x93>
		s++;
  801a96:	41                   	inc    %ecx
	int neg = 0;
  801a97:	bf 00 00 00 00       	mov    $0x0,%edi
  801a9c:	eb d6                	jmp    801a74 <strtol+0x23>
		s++, neg = 1;
  801a9e:	41                   	inc    %ecx
  801a9f:	bf 01 00 00 00       	mov    $0x1,%edi
  801aa4:	eb ce                	jmp    801a74 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa6:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801aaa:	74 10                	je     801abc <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801aac:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab0:	75 dd                	jne    801a8f <strtol+0x3e>
		s++, base = 8;
  801ab2:	41                   	inc    %ecx
  801ab3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801aba:	eb d3                	jmp    801a8f <strtol+0x3e>
		s += 2, base = 16;
  801abc:	83 c1 02             	add    $0x2,%ecx
  801abf:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ac6:	eb c7                	jmp    801a8f <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801ac8:	8d 72 9f             	lea    -0x61(%edx),%esi
  801acb:	89 f3                	mov    %esi,%ebx
  801acd:	80 fb 19             	cmp    $0x19,%bl
  801ad0:	77 24                	ja     801af6 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ad2:	0f be d2             	movsbl %dl,%edx
  801ad5:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ad8:	3b 55 10             	cmp    0x10(%ebp),%edx
  801adb:	7d 2b                	jge    801b08 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801add:	41                   	inc    %ecx
  801ade:	0f af 45 10          	imul   0x10(%ebp),%eax
  801ae2:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801ae4:	8a 11                	mov    (%ecx),%dl
  801ae6:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801ae9:	80 fb 09             	cmp    $0x9,%bl
  801aec:	77 da                	ja     801ac8 <strtol+0x77>
			dig = *s - '0';
  801aee:	0f be d2             	movsbl %dl,%edx
  801af1:	83 ea 30             	sub    $0x30,%edx
  801af4:	eb e2                	jmp    801ad8 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801af6:	8d 72 bf             	lea    -0x41(%edx),%esi
  801af9:	89 f3                	mov    %esi,%ebx
  801afb:	80 fb 19             	cmp    $0x19,%bl
  801afe:	77 08                	ja     801b08 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b00:	0f be d2             	movsbl %dl,%edx
  801b03:	83 ea 37             	sub    $0x37,%edx
  801b06:	eb d0                	jmp    801ad8 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b08:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b0c:	74 05                	je     801b13 <strtol+0xc2>
		*endptr = (char *) s;
  801b0e:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b11:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b13:	85 ff                	test   %edi,%edi
  801b15:	74 02                	je     801b19 <strtol+0xc8>
  801b17:	f7 d8                	neg    %eax
}
  801b19:	5b                   	pop    %ebx
  801b1a:	5e                   	pop    %esi
  801b1b:	5f                   	pop    %edi
  801b1c:	5d                   	pop    %ebp
  801b1d:	c3                   	ret    

00801b1e <atoi>:

int
atoi(const char *s)
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b21:	6a 0a                	push   $0xa
  801b23:	6a 00                	push   $0x0
  801b25:	ff 75 08             	pushl  0x8(%ebp)
  801b28:	e8 24 ff ff ff       	call   801a51 <strtol>
}
  801b2d:	c9                   	leave  
  801b2e:	c3                   	ret    

00801b2f <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
  801b32:	57                   	push   %edi
  801b33:	56                   	push   %esi
  801b34:	53                   	push   %ebx
  801b35:	83 ec 0c             	sub    $0xc,%esp
  801b38:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b3b:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b3e:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b41:	85 ff                	test   %edi,%edi
  801b43:	74 53                	je     801b98 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b45:	83 ec 0c             	sub    $0xc,%esp
  801b48:	57                   	push   %edi
  801b49:	e8 fe e7 ff ff       	call   80034c <sys_ipc_recv>
  801b4e:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b51:	85 db                	test   %ebx,%ebx
  801b53:	74 0b                	je     801b60 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b55:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b5b:	8b 52 74             	mov    0x74(%edx),%edx
  801b5e:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b60:	85 f6                	test   %esi,%esi
  801b62:	74 0f                	je     801b73 <ipc_recv+0x44>
  801b64:	85 ff                	test   %edi,%edi
  801b66:	74 0b                	je     801b73 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b68:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6e:	8b 52 78             	mov    0x78(%edx),%edx
  801b71:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b73:	85 c0                	test   %eax,%eax
  801b75:	74 30                	je     801ba7 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b77:	85 db                	test   %ebx,%ebx
  801b79:	74 06                	je     801b81 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b81:	85 f6                	test   %esi,%esi
  801b83:	74 2c                	je     801bb1 <ipc_recv+0x82>
      		*perm_store = 0;
  801b85:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801b90:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b93:	5b                   	pop    %ebx
  801b94:	5e                   	pop    %esi
  801b95:	5f                   	pop    %edi
  801b96:	5d                   	pop    %ebp
  801b97:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801b98:	83 ec 0c             	sub    $0xc,%esp
  801b9b:	6a ff                	push   $0xffffffff
  801b9d:	e8 aa e7 ff ff       	call   80034c <sys_ipc_recv>
  801ba2:	83 c4 10             	add    $0x10,%esp
  801ba5:	eb aa                	jmp    801b51 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801ba7:	a1 04 40 80 00       	mov    0x804004,%eax
  801bac:	8b 40 70             	mov    0x70(%eax),%eax
  801baf:	eb df                	jmp    801b90 <ipc_recv+0x61>
		return -1;
  801bb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bb6:	eb d8                	jmp    801b90 <ipc_recv+0x61>

00801bb8 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bb8:	55                   	push   %ebp
  801bb9:	89 e5                	mov    %esp,%ebp
  801bbb:	57                   	push   %edi
  801bbc:	56                   	push   %esi
  801bbd:	53                   	push   %ebx
  801bbe:	83 ec 0c             	sub    $0xc,%esp
  801bc1:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bc4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bc7:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bca:	85 db                	test   %ebx,%ebx
  801bcc:	75 22                	jne    801bf0 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bce:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bd3:	eb 1b                	jmp    801bf0 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bd5:	68 40 23 80 00       	push   $0x802340
  801bda:	68 cb 1f 80 00       	push   $0x801fcb
  801bdf:	6a 48                	push   $0x48
  801be1:	68 64 23 80 00       	push   $0x802364
  801be6:	e8 11 f5 ff ff       	call   8010fc <_panic>
		sys_yield();
  801beb:	e8 13 e6 ff ff       	call   800203 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801bf0:	57                   	push   %edi
  801bf1:	53                   	push   %ebx
  801bf2:	56                   	push   %esi
  801bf3:	ff 75 08             	pushl  0x8(%ebp)
  801bf6:	e8 2e e7 ff ff       	call   800329 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bfb:	83 c4 10             	add    $0x10,%esp
  801bfe:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c01:	74 e8                	je     801beb <ipc_send+0x33>
  801c03:	85 c0                	test   %eax,%eax
  801c05:	75 ce                	jne    801bd5 <ipc_send+0x1d>
		sys_yield();
  801c07:	e8 f7 e5 ff ff       	call   800203 <sys_yield>
		
	}
	
}
  801c0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c0f:	5b                   	pop    %ebx
  801c10:	5e                   	pop    %esi
  801c11:	5f                   	pop    %edi
  801c12:	5d                   	pop    %ebp
  801c13:	c3                   	ret    

00801c14 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
  801c17:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c1a:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c1f:	89 c2                	mov    %eax,%edx
  801c21:	c1 e2 05             	shl    $0x5,%edx
  801c24:	29 c2                	sub    %eax,%edx
  801c26:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c2d:	8b 52 50             	mov    0x50(%edx),%edx
  801c30:	39 ca                	cmp    %ecx,%edx
  801c32:	74 0f                	je     801c43 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c34:	40                   	inc    %eax
  801c35:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c3a:	75 e3                	jne    801c1f <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c3c:	b8 00 00 00 00       	mov    $0x0,%eax
  801c41:	eb 11                	jmp    801c54 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c43:	89 c2                	mov    %eax,%edx
  801c45:	c1 e2 05             	shl    $0x5,%edx
  801c48:	29 c2                	sub    %eax,%edx
  801c4a:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c51:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c54:	5d                   	pop    %ebp
  801c55:	c3                   	ret    

00801c56 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c56:	55                   	push   %ebp
  801c57:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	c1 e8 16             	shr    $0x16,%eax
  801c5f:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c66:	a8 01                	test   $0x1,%al
  801c68:	74 21                	je     801c8b <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	c1 e8 0c             	shr    $0xc,%eax
  801c70:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c77:	a8 01                	test   $0x1,%al
  801c79:	74 17                	je     801c92 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c7b:	c1 e8 0c             	shr    $0xc,%eax
  801c7e:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c85:	ef 
  801c86:	0f b7 c0             	movzwl %ax,%eax
  801c89:	eb 05                	jmp    801c90 <pageref+0x3a>
		return 0;
  801c8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c90:	5d                   	pop    %ebp
  801c91:	c3                   	ret    
		return 0;
  801c92:	b8 00 00 00 00       	mov    $0x0,%eax
  801c97:	eb f7                	jmp    801c90 <pageref+0x3a>
  801c99:	66 90                	xchg   %ax,%ax
  801c9b:	90                   	nop

00801c9c <__udivdi3>:
  801c9c:	55                   	push   %ebp
  801c9d:	57                   	push   %edi
  801c9e:	56                   	push   %esi
  801c9f:	53                   	push   %ebx
  801ca0:	83 ec 1c             	sub    $0x1c,%esp
  801ca3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801ca7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801caf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cb3:	89 ca                	mov    %ecx,%edx
  801cb5:	89 f8                	mov    %edi,%eax
  801cb7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cbb:	85 f6                	test   %esi,%esi
  801cbd:	75 2d                	jne    801cec <__udivdi3+0x50>
  801cbf:	39 cf                	cmp    %ecx,%edi
  801cc1:	77 65                	ja     801d28 <__udivdi3+0x8c>
  801cc3:	89 fd                	mov    %edi,%ebp
  801cc5:	85 ff                	test   %edi,%edi
  801cc7:	75 0b                	jne    801cd4 <__udivdi3+0x38>
  801cc9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cce:	31 d2                	xor    %edx,%edx
  801cd0:	f7 f7                	div    %edi
  801cd2:	89 c5                	mov    %eax,%ebp
  801cd4:	31 d2                	xor    %edx,%edx
  801cd6:	89 c8                	mov    %ecx,%eax
  801cd8:	f7 f5                	div    %ebp
  801cda:	89 c1                	mov    %eax,%ecx
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	f7 f5                	div    %ebp
  801ce0:	89 cf                	mov    %ecx,%edi
  801ce2:	89 fa                	mov    %edi,%edx
  801ce4:	83 c4 1c             	add    $0x1c,%esp
  801ce7:	5b                   	pop    %ebx
  801ce8:	5e                   	pop    %esi
  801ce9:	5f                   	pop    %edi
  801cea:	5d                   	pop    %ebp
  801ceb:	c3                   	ret    
  801cec:	39 ce                	cmp    %ecx,%esi
  801cee:	77 28                	ja     801d18 <__udivdi3+0x7c>
  801cf0:	0f bd fe             	bsr    %esi,%edi
  801cf3:	83 f7 1f             	xor    $0x1f,%edi
  801cf6:	75 40                	jne    801d38 <__udivdi3+0x9c>
  801cf8:	39 ce                	cmp    %ecx,%esi
  801cfa:	72 0a                	jb     801d06 <__udivdi3+0x6a>
  801cfc:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d00:	0f 87 9e 00 00 00    	ja     801da4 <__udivdi3+0x108>
  801d06:	b8 01 00 00 00       	mov    $0x1,%eax
  801d0b:	89 fa                	mov    %edi,%edx
  801d0d:	83 c4 1c             	add    $0x1c,%esp
  801d10:	5b                   	pop    %ebx
  801d11:	5e                   	pop    %esi
  801d12:	5f                   	pop    %edi
  801d13:	5d                   	pop    %ebp
  801d14:	c3                   	ret    
  801d15:	8d 76 00             	lea    0x0(%esi),%esi
  801d18:	31 ff                	xor    %edi,%edi
  801d1a:	31 c0                	xor    %eax,%eax
  801d1c:	89 fa                	mov    %edi,%edx
  801d1e:	83 c4 1c             	add    $0x1c,%esp
  801d21:	5b                   	pop    %ebx
  801d22:	5e                   	pop    %esi
  801d23:	5f                   	pop    %edi
  801d24:	5d                   	pop    %ebp
  801d25:	c3                   	ret    
  801d26:	66 90                	xchg   %ax,%ax
  801d28:	89 d8                	mov    %ebx,%eax
  801d2a:	f7 f7                	div    %edi
  801d2c:	31 ff                	xor    %edi,%edi
  801d2e:	89 fa                	mov    %edi,%edx
  801d30:	83 c4 1c             	add    $0x1c,%esp
  801d33:	5b                   	pop    %ebx
  801d34:	5e                   	pop    %esi
  801d35:	5f                   	pop    %edi
  801d36:	5d                   	pop    %ebp
  801d37:	c3                   	ret    
  801d38:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d3d:	29 fd                	sub    %edi,%ebp
  801d3f:	89 f9                	mov    %edi,%ecx
  801d41:	d3 e6                	shl    %cl,%esi
  801d43:	89 c3                	mov    %eax,%ebx
  801d45:	89 e9                	mov    %ebp,%ecx
  801d47:	d3 eb                	shr    %cl,%ebx
  801d49:	89 d9                	mov    %ebx,%ecx
  801d4b:	09 f1                	or     %esi,%ecx
  801d4d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d51:	89 f9                	mov    %edi,%ecx
  801d53:	d3 e0                	shl    %cl,%eax
  801d55:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d59:	89 d6                	mov    %edx,%esi
  801d5b:	89 e9                	mov    %ebp,%ecx
  801d5d:	d3 ee                	shr    %cl,%esi
  801d5f:	89 f9                	mov    %edi,%ecx
  801d61:	d3 e2                	shl    %cl,%edx
  801d63:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d67:	89 e9                	mov    %ebp,%ecx
  801d69:	d3 eb                	shr    %cl,%ebx
  801d6b:	09 da                	or     %ebx,%edx
  801d6d:	89 d0                	mov    %edx,%eax
  801d6f:	89 f2                	mov    %esi,%edx
  801d71:	f7 74 24 08          	divl   0x8(%esp)
  801d75:	89 d6                	mov    %edx,%esi
  801d77:	89 c3                	mov    %eax,%ebx
  801d79:	f7 64 24 0c          	mull   0xc(%esp)
  801d7d:	39 d6                	cmp    %edx,%esi
  801d7f:	72 17                	jb     801d98 <__udivdi3+0xfc>
  801d81:	74 09                	je     801d8c <__udivdi3+0xf0>
  801d83:	89 d8                	mov    %ebx,%eax
  801d85:	31 ff                	xor    %edi,%edi
  801d87:	e9 56 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801d8c:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d90:	89 f9                	mov    %edi,%ecx
  801d92:	d3 e2                	shl    %cl,%edx
  801d94:	39 c2                	cmp    %eax,%edx
  801d96:	73 eb                	jae    801d83 <__udivdi3+0xe7>
  801d98:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801d9b:	31 ff                	xor    %edi,%edi
  801d9d:	e9 40 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	31 c0                	xor    %eax,%eax
  801da6:	e9 37 ff ff ff       	jmp    801ce2 <__udivdi3+0x46>
  801dab:	90                   	nop

00801dac <__umoddi3>:
  801dac:	55                   	push   %ebp
  801dad:	57                   	push   %edi
  801dae:	56                   	push   %esi
  801daf:	53                   	push   %ebx
  801db0:	83 ec 1c             	sub    $0x1c,%esp
  801db3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801db7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dbf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dc3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dc7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dcb:	89 3c 24             	mov    %edi,(%esp)
  801dce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dd2:	89 f2                	mov    %esi,%edx
  801dd4:	85 c0                	test   %eax,%eax
  801dd6:	75 18                	jne    801df0 <__umoddi3+0x44>
  801dd8:	39 f7                	cmp    %esi,%edi
  801dda:	0f 86 a0 00 00 00    	jbe    801e80 <__umoddi3+0xd4>
  801de0:	89 c8                	mov    %ecx,%eax
  801de2:	f7 f7                	div    %edi
  801de4:	89 d0                	mov    %edx,%eax
  801de6:	31 d2                	xor    %edx,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	89 f3                	mov    %esi,%ebx
  801df2:	39 f0                	cmp    %esi,%eax
  801df4:	0f 87 a6 00 00 00    	ja     801ea0 <__umoddi3+0xf4>
  801dfa:	0f bd e8             	bsr    %eax,%ebp
  801dfd:	83 f5 1f             	xor    $0x1f,%ebp
  801e00:	0f 84 a6 00 00 00    	je     801eac <__umoddi3+0x100>
  801e06:	bf 20 00 00 00       	mov    $0x20,%edi
  801e0b:	29 ef                	sub    %ebp,%edi
  801e0d:	89 e9                	mov    %ebp,%ecx
  801e0f:	d3 e0                	shl    %cl,%eax
  801e11:	8b 34 24             	mov    (%esp),%esi
  801e14:	89 f2                	mov    %esi,%edx
  801e16:	89 f9                	mov    %edi,%ecx
  801e18:	d3 ea                	shr    %cl,%edx
  801e1a:	09 c2                	or     %eax,%edx
  801e1c:	89 14 24             	mov    %edx,(%esp)
  801e1f:	89 f2                	mov    %esi,%edx
  801e21:	89 e9                	mov    %ebp,%ecx
  801e23:	d3 e2                	shl    %cl,%edx
  801e25:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e29:	89 de                	mov    %ebx,%esi
  801e2b:	89 f9                	mov    %edi,%ecx
  801e2d:	d3 ee                	shr    %cl,%esi
  801e2f:	89 e9                	mov    %ebp,%ecx
  801e31:	d3 e3                	shl    %cl,%ebx
  801e33:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e37:	89 d0                	mov    %edx,%eax
  801e39:	89 f9                	mov    %edi,%ecx
  801e3b:	d3 e8                	shr    %cl,%eax
  801e3d:	09 d8                	or     %ebx,%eax
  801e3f:	89 d3                	mov    %edx,%ebx
  801e41:	89 e9                	mov    %ebp,%ecx
  801e43:	d3 e3                	shl    %cl,%ebx
  801e45:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e49:	89 f2                	mov    %esi,%edx
  801e4b:	f7 34 24             	divl   (%esp)
  801e4e:	89 d6                	mov    %edx,%esi
  801e50:	f7 64 24 04          	mull   0x4(%esp)
  801e54:	89 c3                	mov    %eax,%ebx
  801e56:	89 d1                	mov    %edx,%ecx
  801e58:	39 d6                	cmp    %edx,%esi
  801e5a:	72 7c                	jb     801ed8 <__umoddi3+0x12c>
  801e5c:	74 72                	je     801ed0 <__umoddi3+0x124>
  801e5e:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e62:	29 da                	sub    %ebx,%edx
  801e64:	19 ce                	sbb    %ecx,%esi
  801e66:	89 f0                	mov    %esi,%eax
  801e68:	89 f9                	mov    %edi,%ecx
  801e6a:	d3 e0                	shl    %cl,%eax
  801e6c:	89 e9                	mov    %ebp,%ecx
  801e6e:	d3 ea                	shr    %cl,%edx
  801e70:	09 d0                	or     %edx,%eax
  801e72:	89 e9                	mov    %ebp,%ecx
  801e74:	d3 ee                	shr    %cl,%esi
  801e76:	89 f2                	mov    %esi,%edx
  801e78:	83 c4 1c             	add    $0x1c,%esp
  801e7b:	5b                   	pop    %ebx
  801e7c:	5e                   	pop    %esi
  801e7d:	5f                   	pop    %edi
  801e7e:	5d                   	pop    %ebp
  801e7f:	c3                   	ret    
  801e80:	89 fd                	mov    %edi,%ebp
  801e82:	85 ff                	test   %edi,%edi
  801e84:	75 0b                	jne    801e91 <__umoddi3+0xe5>
  801e86:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8b:	31 d2                	xor    %edx,%edx
  801e8d:	f7 f7                	div    %edi
  801e8f:	89 c5                	mov    %eax,%ebp
  801e91:	89 f0                	mov    %esi,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f5                	div    %ebp
  801e97:	89 c8                	mov    %ecx,%eax
  801e99:	f7 f5                	div    %ebp
  801e9b:	e9 44 ff ff ff       	jmp    801de4 <__umoddi3+0x38>
  801ea0:	89 c8                	mov    %ecx,%eax
  801ea2:	89 f2                	mov    %esi,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	39 f0                	cmp    %esi,%eax
  801eae:	72 05                	jb     801eb5 <__umoddi3+0x109>
  801eb0:	39 0c 24             	cmp    %ecx,(%esp)
  801eb3:	77 0c                	ja     801ec1 <__umoddi3+0x115>
  801eb5:	89 f2                	mov    %esi,%edx
  801eb7:	29 f9                	sub    %edi,%ecx
  801eb9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ebd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec1:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ec5:	83 c4 1c             	add    $0x1c,%esp
  801ec8:	5b                   	pop    %ebx
  801ec9:	5e                   	pop    %esi
  801eca:	5f                   	pop    %edi
  801ecb:	5d                   	pop    %ebp
  801ecc:	c3                   	ret    
  801ecd:	8d 76 00             	lea    0x0(%esi),%esi
  801ed0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ed4:	73 88                	jae    801e5e <__umoddi3+0xb2>
  801ed6:	66 90                	xchg   %ax,%ax
  801ed8:	2b 44 24 04          	sub    0x4(%esp),%eax
  801edc:	1b 14 24             	sbb    (%esp),%edx
  801edf:	89 d1                	mov    %edx,%ecx
  801ee1:	89 c3                	mov    %eax,%ebx
  801ee3:	e9 76 ff ff ff       	jmp    801e5e <__umoddi3+0xb2>
