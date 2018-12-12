
obj/user/faultevilhandler.debug:     file format elf32-i386


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
  80002c:	e8 34 00 00 00       	call   800065 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 0c             	sub    $0xc,%esp
	sys_page_alloc(0, (void*) (UXSTACKTOP - PGSIZE), PTE_P|PTE_U|PTE_W);
  800039:	6a 07                	push   $0x7
  80003b:	68 00 f0 bf ee       	push   $0xeebff000
  800040:	6a 00                	push   $0x0
  800042:	e8 21 01 00 00       	call   800168 <sys_page_alloc>
	sys_env_set_pgfault_upcall(0, (void*) 0xF0100020);
  800047:	83 c4 08             	add    $0x8,%esp
  80004a:	68 20 00 10 f0       	push   $0xf0100020
  80004f:	6a 00                	push   $0x0
  800051:	e8 bd 02 00 00       	call   800313 <sys_env_set_pgfault_upcall>
	*(int*)0 = 0;
  800056:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80005d:	00 00 00 
}
  800060:	83 c4 10             	add    $0x10,%esp
  800063:	c9                   	leave  
  800064:	c3                   	ret    

00800065 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800065:	55                   	push   %ebp
  800066:	89 e5                	mov    %esp,%ebp
  800068:	56                   	push   %esi
  800069:	53                   	push   %ebx
  80006a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80006d:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800070:	e8 d4 00 00 00       	call   800149 <sys_getenvid>
  800075:	25 ff 03 00 00       	and    $0x3ff,%eax
  80007a:	89 c2                	mov    %eax,%edx
  80007c:	c1 e2 05             	shl    $0x5,%edx
  80007f:	29 c2                	sub    %eax,%edx
  800081:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800088:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80008d:	85 db                	test   %ebx,%ebx
  80008f:	7e 07                	jle    800098 <libmain+0x33>
		binaryname = argv[0];
  800091:	8b 06                	mov    (%esi),%eax
  800093:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800098:	83 ec 08             	sub    $0x8,%esp
  80009b:	56                   	push   %esi
  80009c:	53                   	push   %ebx
  80009d:	e8 91 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  8000a2:	e8 0a 00 00 00       	call   8000b1 <exit>
}
  8000a7:	83 c4 10             	add    $0x10,%esp
  8000aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8000ad:	5b                   	pop    %ebx
  8000ae:	5e                   	pop    %esi
  8000af:	5d                   	pop    %ebp
  8000b0:	c3                   	ret    

008000b1 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  8000b1:	55                   	push   %ebp
  8000b2:	89 e5                	mov    %esp,%ebp
  8000b4:	83 ec 08             	sub    $0x8,%esp
	close_all();
  8000b7:	e8 35 05 00 00       	call   8005f1 <close_all>
	sys_env_destroy(0);
  8000bc:	83 ec 0c             	sub    $0xc,%esp
  8000bf:	6a 00                	push   $0x0
  8000c1:	e8 42 00 00 00       	call   800108 <sys_env_destroy>
}
  8000c6:	83 c4 10             	add    $0x10,%esp
  8000c9:	c9                   	leave  
  8000ca:	c3                   	ret    

008000cb <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000cb:	55                   	push   %ebp
  8000cc:	89 e5                	mov    %esp,%ebp
  8000ce:	57                   	push   %edi
  8000cf:	56                   	push   %esi
  8000d0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8000dc:	89 c3                	mov    %eax,%ebx
  8000de:	89 c7                	mov    %eax,%edi
  8000e0:	89 c6                	mov    %eax,%esi
  8000e2:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000e4:	5b                   	pop    %ebx
  8000e5:	5e                   	pop    %esi
  8000e6:	5f                   	pop    %edi
  8000e7:	5d                   	pop    %ebp
  8000e8:	c3                   	ret    

008000e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000e9:	55                   	push   %ebp
  8000ea:	89 e5                	mov    %esp,%ebp
  8000ec:	57                   	push   %edi
  8000ed:	56                   	push   %esi
  8000ee:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8000f4:	b8 01 00 00 00       	mov    $0x1,%eax
  8000f9:	89 d1                	mov    %edx,%ecx
  8000fb:	89 d3                	mov    %edx,%ebx
  8000fd:	89 d7                	mov    %edx,%edi
  8000ff:	89 d6                	mov    %edx,%esi
  800101:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  800103:	5b                   	pop    %ebx
  800104:	5e                   	pop    %esi
  800105:	5f                   	pop    %edi
  800106:	5d                   	pop    %ebp
  800107:	c3                   	ret    

00800108 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  800108:	55                   	push   %ebp
  800109:	89 e5                	mov    %esp,%ebp
  80010b:	57                   	push   %edi
  80010c:	56                   	push   %esi
  80010d:	53                   	push   %ebx
  80010e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800111:	b9 00 00 00 00       	mov    $0x0,%ecx
  800116:	b8 03 00 00 00       	mov    $0x3,%eax
  80011b:	8b 55 08             	mov    0x8(%ebp),%edx
  80011e:	89 cb                	mov    %ecx,%ebx
  800120:	89 cf                	mov    %ecx,%edi
  800122:	89 ce                	mov    %ecx,%esi
  800124:	cd 30                	int    $0x30
	if(check && ret > 0)
  800126:	85 c0                	test   %eax,%eax
  800128:	7f 08                	jg     800132 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80012a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80012d:	5b                   	pop    %ebx
  80012e:	5e                   	pop    %esi
  80012f:	5f                   	pop    %edi
  800130:	5d                   	pop    %ebp
  800131:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800132:	83 ec 0c             	sub    $0xc,%esp
  800135:	50                   	push   %eax
  800136:	6a 03                	push   $0x3
  800138:	68 2a 1f 80 00       	push   $0x801f2a
  80013d:	6a 23                	push   $0x23
  80013f:	68 47 1f 80 00       	push   $0x801f47
  800144:	e8 df 0f 00 00       	call   801128 <_panic>

00800149 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800149:	55                   	push   %ebp
  80014a:	89 e5                	mov    %esp,%ebp
  80014c:	57                   	push   %edi
  80014d:	56                   	push   %esi
  80014e:	53                   	push   %ebx
	asm volatile("int %1\n"
  80014f:	ba 00 00 00 00       	mov    $0x0,%edx
  800154:	b8 02 00 00 00       	mov    $0x2,%eax
  800159:	89 d1                	mov    %edx,%ecx
  80015b:	89 d3                	mov    %edx,%ebx
  80015d:	89 d7                	mov    %edx,%edi
  80015f:	89 d6                	mov    %edx,%esi
  800161:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800163:	5b                   	pop    %ebx
  800164:	5e                   	pop    %esi
  800165:	5f                   	pop    %edi
  800166:	5d                   	pop    %ebp
  800167:	c3                   	ret    

00800168 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800168:	55                   	push   %ebp
  800169:	89 e5                	mov    %esp,%ebp
  80016b:	57                   	push   %edi
  80016c:	56                   	push   %esi
  80016d:	53                   	push   %ebx
  80016e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800171:	be 00 00 00 00       	mov    $0x0,%esi
  800176:	b8 04 00 00 00       	mov    $0x4,%eax
  80017b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80017e:	8b 55 08             	mov    0x8(%ebp),%edx
  800181:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800184:	89 f7                	mov    %esi,%edi
  800186:	cd 30                	int    $0x30
	if(check && ret > 0)
  800188:	85 c0                	test   %eax,%eax
  80018a:	7f 08                	jg     800194 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  80018c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80018f:	5b                   	pop    %ebx
  800190:	5e                   	pop    %esi
  800191:	5f                   	pop    %edi
  800192:	5d                   	pop    %ebp
  800193:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800194:	83 ec 0c             	sub    $0xc,%esp
  800197:	50                   	push   %eax
  800198:	6a 04                	push   $0x4
  80019a:	68 2a 1f 80 00       	push   $0x801f2a
  80019f:	6a 23                	push   $0x23
  8001a1:	68 47 1f 80 00       	push   $0x801f47
  8001a6:	e8 7d 0f 00 00       	call   801128 <_panic>

008001ab <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  8001ab:	55                   	push   %ebp
  8001ac:	89 e5                	mov    %esp,%ebp
  8001ae:	57                   	push   %edi
  8001af:	56                   	push   %esi
  8001b0:	53                   	push   %ebx
  8001b1:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001b4:	b8 05 00 00 00       	mov    $0x5,%eax
  8001b9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8001bf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001c2:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001c5:	8b 75 18             	mov    0x18(%ebp),%esi
  8001c8:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001ca:	85 c0                	test   %eax,%eax
  8001cc:	7f 08                	jg     8001d6 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ce:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001d1:	5b                   	pop    %ebx
  8001d2:	5e                   	pop    %esi
  8001d3:	5f                   	pop    %edi
  8001d4:	5d                   	pop    %ebp
  8001d5:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001d6:	83 ec 0c             	sub    $0xc,%esp
  8001d9:	50                   	push   %eax
  8001da:	6a 05                	push   $0x5
  8001dc:	68 2a 1f 80 00       	push   $0x801f2a
  8001e1:	6a 23                	push   $0x23
  8001e3:	68 47 1f 80 00       	push   $0x801f47
  8001e8:	e8 3b 0f 00 00       	call   801128 <_panic>

008001ed <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ed:	55                   	push   %ebp
  8001ee:	89 e5                	mov    %esp,%ebp
  8001f0:	57                   	push   %edi
  8001f1:	56                   	push   %esi
  8001f2:	53                   	push   %ebx
  8001f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001fb:	b8 06 00 00 00       	mov    $0x6,%eax
  800200:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800203:	8b 55 08             	mov    0x8(%ebp),%edx
  800206:	89 df                	mov    %ebx,%edi
  800208:	89 de                	mov    %ebx,%esi
  80020a:	cd 30                	int    $0x30
	if(check && ret > 0)
  80020c:	85 c0                	test   %eax,%eax
  80020e:	7f 08                	jg     800218 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  800210:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800213:	5b                   	pop    %ebx
  800214:	5e                   	pop    %esi
  800215:	5f                   	pop    %edi
  800216:	5d                   	pop    %ebp
  800217:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800218:	83 ec 0c             	sub    $0xc,%esp
  80021b:	50                   	push   %eax
  80021c:	6a 06                	push   $0x6
  80021e:	68 2a 1f 80 00       	push   $0x801f2a
  800223:	6a 23                	push   $0x23
  800225:	68 47 1f 80 00       	push   $0x801f47
  80022a:	e8 f9 0e 00 00       	call   801128 <_panic>

0080022f <sys_yield>:

void
sys_yield(void)
{
  80022f:	55                   	push   %ebp
  800230:	89 e5                	mov    %esp,%ebp
  800232:	57                   	push   %edi
  800233:	56                   	push   %esi
  800234:	53                   	push   %ebx
	asm volatile("int %1\n"
  800235:	ba 00 00 00 00       	mov    $0x0,%edx
  80023a:	b8 0b 00 00 00       	mov    $0xb,%eax
  80023f:	89 d1                	mov    %edx,%ecx
  800241:	89 d3                	mov    %edx,%ebx
  800243:	89 d7                	mov    %edx,%edi
  800245:	89 d6                	mov    %edx,%esi
  800247:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800249:	5b                   	pop    %ebx
  80024a:	5e                   	pop    %esi
  80024b:	5f                   	pop    %edi
  80024c:	5d                   	pop    %ebp
  80024d:	c3                   	ret    

0080024e <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80024e:	55                   	push   %ebp
  80024f:	89 e5                	mov    %esp,%ebp
  800251:	57                   	push   %edi
  800252:	56                   	push   %esi
  800253:	53                   	push   %ebx
  800254:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800257:	bb 00 00 00 00       	mov    $0x0,%ebx
  80025c:	b8 08 00 00 00       	mov    $0x8,%eax
  800261:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800264:	8b 55 08             	mov    0x8(%ebp),%edx
  800267:	89 df                	mov    %ebx,%edi
  800269:	89 de                	mov    %ebx,%esi
  80026b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80026d:	85 c0                	test   %eax,%eax
  80026f:	7f 08                	jg     800279 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800271:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800274:	5b                   	pop    %ebx
  800275:	5e                   	pop    %esi
  800276:	5f                   	pop    %edi
  800277:	5d                   	pop    %ebp
  800278:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800279:	83 ec 0c             	sub    $0xc,%esp
  80027c:	50                   	push   %eax
  80027d:	6a 08                	push   $0x8
  80027f:	68 2a 1f 80 00       	push   $0x801f2a
  800284:	6a 23                	push   $0x23
  800286:	68 47 1f 80 00       	push   $0x801f47
  80028b:	e8 98 0e 00 00       	call   801128 <_panic>

00800290 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	57                   	push   %edi
  800294:	56                   	push   %esi
  800295:	53                   	push   %ebx
  800296:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800299:	b9 00 00 00 00       	mov    $0x0,%ecx
  80029e:	b8 0c 00 00 00       	mov    $0xc,%eax
  8002a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8002a6:	89 cb                	mov    %ecx,%ebx
  8002a8:	89 cf                	mov    %ecx,%edi
  8002aa:	89 ce                	mov    %ecx,%esi
  8002ac:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002ae:	85 c0                	test   %eax,%eax
  8002b0:	7f 08                	jg     8002ba <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  8002b2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002b5:	5b                   	pop    %ebx
  8002b6:	5e                   	pop    %esi
  8002b7:	5f                   	pop    %edi
  8002b8:	5d                   	pop    %ebp
  8002b9:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002ba:	83 ec 0c             	sub    $0xc,%esp
  8002bd:	50                   	push   %eax
  8002be:	6a 0c                	push   $0xc
  8002c0:	68 2a 1f 80 00       	push   $0x801f2a
  8002c5:	6a 23                	push   $0x23
  8002c7:	68 47 1f 80 00       	push   $0x801f47
  8002cc:	e8 57 0e 00 00       	call   801128 <_panic>

008002d1 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	57                   	push   %edi
  8002d5:	56                   	push   %esi
  8002d6:	53                   	push   %ebx
  8002d7:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002da:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002df:	b8 09 00 00 00       	mov    $0x9,%eax
  8002e4:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8002ea:	89 df                	mov    %ebx,%edi
  8002ec:	89 de                	mov    %ebx,%esi
  8002ee:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002f0:	85 c0                	test   %eax,%eax
  8002f2:	7f 08                	jg     8002fc <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002f7:	5b                   	pop    %ebx
  8002f8:	5e                   	pop    %esi
  8002f9:	5f                   	pop    %edi
  8002fa:	5d                   	pop    %ebp
  8002fb:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002fc:	83 ec 0c             	sub    $0xc,%esp
  8002ff:	50                   	push   %eax
  800300:	6a 09                	push   $0x9
  800302:	68 2a 1f 80 00       	push   $0x801f2a
  800307:	6a 23                	push   $0x23
  800309:	68 47 1f 80 00       	push   $0x801f47
  80030e:	e8 15 0e 00 00       	call   801128 <_panic>

00800313 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  800313:	55                   	push   %ebp
  800314:	89 e5                	mov    %esp,%ebp
  800316:	57                   	push   %edi
  800317:	56                   	push   %esi
  800318:	53                   	push   %ebx
  800319:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80031c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800321:	b8 0a 00 00 00       	mov    $0xa,%eax
  800326:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800329:	8b 55 08             	mov    0x8(%ebp),%edx
  80032c:	89 df                	mov    %ebx,%edi
  80032e:	89 de                	mov    %ebx,%esi
  800330:	cd 30                	int    $0x30
	if(check && ret > 0)
  800332:	85 c0                	test   %eax,%eax
  800334:	7f 08                	jg     80033e <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800336:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800339:	5b                   	pop    %ebx
  80033a:	5e                   	pop    %esi
  80033b:	5f                   	pop    %edi
  80033c:	5d                   	pop    %ebp
  80033d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80033e:	83 ec 0c             	sub    $0xc,%esp
  800341:	50                   	push   %eax
  800342:	6a 0a                	push   $0xa
  800344:	68 2a 1f 80 00       	push   $0x801f2a
  800349:	6a 23                	push   $0x23
  80034b:	68 47 1f 80 00       	push   $0x801f47
  800350:	e8 d3 0d 00 00       	call   801128 <_panic>

00800355 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	57                   	push   %edi
  800359:	56                   	push   %esi
  80035a:	53                   	push   %ebx
	asm volatile("int %1\n"
  80035b:	be 00 00 00 00       	mov    $0x0,%esi
  800360:	b8 0d 00 00 00       	mov    $0xd,%eax
  800365:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80036e:	8b 7d 14             	mov    0x14(%ebp),%edi
  800371:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800373:	5b                   	pop    %ebx
  800374:	5e                   	pop    %esi
  800375:	5f                   	pop    %edi
  800376:	5d                   	pop    %ebp
  800377:	c3                   	ret    

00800378 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	57                   	push   %edi
  80037c:	56                   	push   %esi
  80037d:	53                   	push   %ebx
  80037e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800381:	b9 00 00 00 00       	mov    $0x0,%ecx
  800386:	b8 0e 00 00 00       	mov    $0xe,%eax
  80038b:	8b 55 08             	mov    0x8(%ebp),%edx
  80038e:	89 cb                	mov    %ecx,%ebx
  800390:	89 cf                	mov    %ecx,%edi
  800392:	89 ce                	mov    %ecx,%esi
  800394:	cd 30                	int    $0x30
	if(check && ret > 0)
  800396:	85 c0                	test   %eax,%eax
  800398:	7f 08                	jg     8003a2 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80039a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80039d:	5b                   	pop    %ebx
  80039e:	5e                   	pop    %esi
  80039f:	5f                   	pop    %edi
  8003a0:	5d                   	pop    %ebp
  8003a1:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8003a2:	83 ec 0c             	sub    $0xc,%esp
  8003a5:	50                   	push   %eax
  8003a6:	6a 0e                	push   $0xe
  8003a8:	68 2a 1f 80 00       	push   $0x801f2a
  8003ad:	6a 23                	push   $0x23
  8003af:	68 47 1f 80 00       	push   $0x801f47
  8003b4:	e8 6f 0d 00 00       	call   801128 <_panic>

008003b9 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  8003b9:	55                   	push   %ebp
  8003ba:	89 e5                	mov    %esp,%ebp
  8003bc:	57                   	push   %edi
  8003bd:	56                   	push   %esi
  8003be:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003bf:	be 00 00 00 00       	mov    $0x0,%esi
  8003c4:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8003cf:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d2:	89 f7                	mov    %esi,%edi
  8003d4:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003d6:	5b                   	pop    %ebx
  8003d7:	5e                   	pop    %esi
  8003d8:	5f                   	pop    %edi
  8003d9:	5d                   	pop    %ebp
  8003da:	c3                   	ret    

008003db <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	57                   	push   %edi
  8003df:	56                   	push   %esi
  8003e0:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003e1:	be 00 00 00 00       	mov    $0x0,%esi
  8003e6:	b8 10 00 00 00       	mov    $0x10,%eax
  8003eb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f1:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003f4:	89 f7                	mov    %esi,%edi
  8003f6:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003f8:	5b                   	pop    %ebx
  8003f9:	5e                   	pop    %esi
  8003fa:	5f                   	pop    %edi
  8003fb:	5d                   	pop    %ebp
  8003fc:	c3                   	ret    

008003fd <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003fd:	55                   	push   %ebp
  8003fe:	89 e5                	mov    %esp,%ebp
  800400:	57                   	push   %edi
  800401:	56                   	push   %esi
  800402:	53                   	push   %ebx
	asm volatile("int %1\n"
  800403:	b9 00 00 00 00       	mov    $0x0,%ecx
  800408:	b8 11 00 00 00       	mov    $0x11,%eax
  80040d:	8b 55 08             	mov    0x8(%ebp),%edx
  800410:	89 cb                	mov    %ecx,%ebx
  800412:	89 cf                	mov    %ecx,%edi
  800414:	89 ce                	mov    %ecx,%esi
  800416:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  800418:	5b                   	pop    %ebx
  800419:	5e                   	pop    %esi
  80041a:	5f                   	pop    %edi
  80041b:	5d                   	pop    %ebp
  80041c:	c3                   	ret    

0080041d <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  80041d:	55                   	push   %ebp
  80041e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800420:	8b 45 08             	mov    0x8(%ebp),%eax
  800423:	05 00 00 00 30       	add    $0x30000000,%eax
  800428:	c1 e8 0c             	shr    $0xc,%eax
}
  80042b:	5d                   	pop    %ebp
  80042c:	c3                   	ret    

0080042d <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80042d:	55                   	push   %ebp
  80042e:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800430:	8b 45 08             	mov    0x8(%ebp),%eax
  800433:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800438:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80043d:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800442:	5d                   	pop    %ebp
  800443:	c3                   	ret    

00800444 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800444:	55                   	push   %ebp
  800445:	89 e5                	mov    %esp,%ebp
  800447:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80044a:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80044f:	89 c2                	mov    %eax,%edx
  800451:	c1 ea 16             	shr    $0x16,%edx
  800454:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  80045b:	f6 c2 01             	test   $0x1,%dl
  80045e:	74 2a                	je     80048a <fd_alloc+0x46>
  800460:	89 c2                	mov    %eax,%edx
  800462:	c1 ea 0c             	shr    $0xc,%edx
  800465:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  80046c:	f6 c2 01             	test   $0x1,%dl
  80046f:	74 19                	je     80048a <fd_alloc+0x46>
  800471:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800476:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  80047b:	75 d2                	jne    80044f <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80047d:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800483:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800488:	eb 07                	jmp    800491 <fd_alloc+0x4d>
			*fd_store = fd;
  80048a:	89 01                	mov    %eax,(%ecx)
			return 0;
  80048c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800491:	5d                   	pop    %ebp
  800492:	c3                   	ret    

00800493 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800496:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80049a:	77 39                	ja     8004d5 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  80049c:	8b 45 08             	mov    0x8(%ebp),%eax
  80049f:	c1 e0 0c             	shl    $0xc,%eax
  8004a2:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  8004a7:	89 c2                	mov    %eax,%edx
  8004a9:	c1 ea 16             	shr    $0x16,%edx
  8004ac:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  8004b3:	f6 c2 01             	test   $0x1,%dl
  8004b6:	74 24                	je     8004dc <fd_lookup+0x49>
  8004b8:	89 c2                	mov    %eax,%edx
  8004ba:	c1 ea 0c             	shr    $0xc,%edx
  8004bd:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004c4:	f6 c2 01             	test   $0x1,%dl
  8004c7:	74 1a                	je     8004e3 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	89 02                	mov    %eax,(%edx)
	return 0;
  8004ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004d3:	5d                   	pop    %ebp
  8004d4:	c3                   	ret    
		return -E_INVAL;
  8004d5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004da:	eb f7                	jmp    8004d3 <fd_lookup+0x40>
		return -E_INVAL;
  8004dc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004e1:	eb f0                	jmp    8004d3 <fd_lookup+0x40>
  8004e3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004e8:	eb e9                	jmp    8004d3 <fd_lookup+0x40>

008004ea <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004ea:	55                   	push   %ebp
  8004eb:	89 e5                	mov    %esp,%ebp
  8004ed:	83 ec 08             	sub    $0x8,%esp
  8004f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004f3:	ba d4 1f 80 00       	mov    $0x801fd4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004f8:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004fd:	39 08                	cmp    %ecx,(%eax)
  8004ff:	74 33                	je     800534 <dev_lookup+0x4a>
  800501:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  800504:	8b 02                	mov    (%edx),%eax
  800506:	85 c0                	test   %eax,%eax
  800508:	75 f3                	jne    8004fd <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  80050a:	a1 04 40 80 00       	mov    0x804004,%eax
  80050f:	8b 40 48             	mov    0x48(%eax),%eax
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	51                   	push   %ecx
  800516:	50                   	push   %eax
  800517:	68 58 1f 80 00       	push   $0x801f58
  80051c:	e8 1a 0d 00 00       	call   80123b <cprintf>
	*dev = 0;
  800521:	8b 45 0c             	mov    0xc(%ebp),%eax
  800524:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80052a:	83 c4 10             	add    $0x10,%esp
  80052d:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800532:	c9                   	leave  
  800533:	c3                   	ret    
			*dev = devtab[i];
  800534:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800537:	89 01                	mov    %eax,(%ecx)
			return 0;
  800539:	b8 00 00 00 00       	mov    $0x0,%eax
  80053e:	eb f2                	jmp    800532 <dev_lookup+0x48>

00800540 <fd_close>:
{
  800540:	55                   	push   %ebp
  800541:	89 e5                	mov    %esp,%ebp
  800543:	57                   	push   %edi
  800544:	56                   	push   %esi
  800545:	53                   	push   %ebx
  800546:	83 ec 1c             	sub    $0x1c,%esp
  800549:	8b 75 08             	mov    0x8(%ebp),%esi
  80054c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80054f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800552:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800553:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800559:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80055c:	50                   	push   %eax
  80055d:	e8 31 ff ff ff       	call   800493 <fd_lookup>
  800562:	89 c7                	mov    %eax,%edi
  800564:	83 c4 08             	add    $0x8,%esp
  800567:	85 c0                	test   %eax,%eax
  800569:	78 05                	js     800570 <fd_close+0x30>
	    || fd != fd2)
  80056b:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80056e:	74 13                	je     800583 <fd_close+0x43>
		return (must_exist ? r : 0);
  800570:	84 db                	test   %bl,%bl
  800572:	75 05                	jne    800579 <fd_close+0x39>
  800574:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800579:	89 f8                	mov    %edi,%eax
  80057b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80057e:	5b                   	pop    %ebx
  80057f:	5e                   	pop    %esi
  800580:	5f                   	pop    %edi
  800581:	5d                   	pop    %ebp
  800582:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800583:	83 ec 08             	sub    $0x8,%esp
  800586:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800589:	50                   	push   %eax
  80058a:	ff 36                	pushl  (%esi)
  80058c:	e8 59 ff ff ff       	call   8004ea <dev_lookup>
  800591:	89 c7                	mov    %eax,%edi
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	85 c0                	test   %eax,%eax
  800598:	78 15                	js     8005af <fd_close+0x6f>
		if (dev->dev_close)
  80059a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80059d:	8b 40 10             	mov    0x10(%eax),%eax
  8005a0:	85 c0                	test   %eax,%eax
  8005a2:	74 1b                	je     8005bf <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  8005a4:	83 ec 0c             	sub    $0xc,%esp
  8005a7:	56                   	push   %esi
  8005a8:	ff d0                	call   *%eax
  8005aa:	89 c7                	mov    %eax,%edi
  8005ac:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  8005af:	83 ec 08             	sub    $0x8,%esp
  8005b2:	56                   	push   %esi
  8005b3:	6a 00                	push   $0x0
  8005b5:	e8 33 fc ff ff       	call   8001ed <sys_page_unmap>
	return r;
  8005ba:	83 c4 10             	add    $0x10,%esp
  8005bd:	eb ba                	jmp    800579 <fd_close+0x39>
			r = 0;
  8005bf:	bf 00 00 00 00       	mov    $0x0,%edi
  8005c4:	eb e9                	jmp    8005af <fd_close+0x6f>

008005c6 <close>:

int
close(int fdnum)
{
  8005c6:	55                   	push   %ebp
  8005c7:	89 e5                	mov    %esp,%ebp
  8005c9:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005cc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005cf:	50                   	push   %eax
  8005d0:	ff 75 08             	pushl  0x8(%ebp)
  8005d3:	e8 bb fe ff ff       	call   800493 <fd_lookup>
  8005d8:	83 c4 08             	add    $0x8,%esp
  8005db:	85 c0                	test   %eax,%eax
  8005dd:	78 10                	js     8005ef <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	6a 01                	push   $0x1
  8005e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e7:	e8 54 ff ff ff       	call   800540 <fd_close>
  8005ec:	83 c4 10             	add    $0x10,%esp
}
  8005ef:	c9                   	leave  
  8005f0:	c3                   	ret    

008005f1 <close_all>:

void
close_all(void)
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	53                   	push   %ebx
  8005f5:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005f8:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005fd:	83 ec 0c             	sub    $0xc,%esp
  800600:	53                   	push   %ebx
  800601:	e8 c0 ff ff ff       	call   8005c6 <close>
	for (i = 0; i < MAXFD; i++)
  800606:	43                   	inc    %ebx
  800607:	83 c4 10             	add    $0x10,%esp
  80060a:	83 fb 20             	cmp    $0x20,%ebx
  80060d:	75 ee                	jne    8005fd <close_all+0xc>
}
  80060f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800612:	c9                   	leave  
  800613:	c3                   	ret    

00800614 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  800614:	55                   	push   %ebp
  800615:	89 e5                	mov    %esp,%ebp
  800617:	57                   	push   %edi
  800618:	56                   	push   %esi
  800619:	53                   	push   %ebx
  80061a:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  80061d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800620:	50                   	push   %eax
  800621:	ff 75 08             	pushl  0x8(%ebp)
  800624:	e8 6a fe ff ff       	call   800493 <fd_lookup>
  800629:	89 c3                	mov    %eax,%ebx
  80062b:	83 c4 08             	add    $0x8,%esp
  80062e:	85 c0                	test   %eax,%eax
  800630:	0f 88 81 00 00 00    	js     8006b7 <dup+0xa3>
		return r;
	close(newfdnum);
  800636:	83 ec 0c             	sub    $0xc,%esp
  800639:	ff 75 0c             	pushl  0xc(%ebp)
  80063c:	e8 85 ff ff ff       	call   8005c6 <close>

	newfd = INDEX2FD(newfdnum);
  800641:	8b 75 0c             	mov    0xc(%ebp),%esi
  800644:	c1 e6 0c             	shl    $0xc,%esi
  800647:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80064d:	83 c4 04             	add    $0x4,%esp
  800650:	ff 75 e4             	pushl  -0x1c(%ebp)
  800653:	e8 d5 fd ff ff       	call   80042d <fd2data>
  800658:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80065a:	89 34 24             	mov    %esi,(%esp)
  80065d:	e8 cb fd ff ff       	call   80042d <fd2data>
  800662:	83 c4 10             	add    $0x10,%esp
  800665:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800667:	89 d8                	mov    %ebx,%eax
  800669:	c1 e8 16             	shr    $0x16,%eax
  80066c:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800673:	a8 01                	test   $0x1,%al
  800675:	74 11                	je     800688 <dup+0x74>
  800677:	89 d8                	mov    %ebx,%eax
  800679:	c1 e8 0c             	shr    $0xc,%eax
  80067c:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800683:	f6 c2 01             	test   $0x1,%dl
  800686:	75 39                	jne    8006c1 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800688:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80068b:	89 d0                	mov    %edx,%eax
  80068d:	c1 e8 0c             	shr    $0xc,%eax
  800690:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800697:	83 ec 0c             	sub    $0xc,%esp
  80069a:	25 07 0e 00 00       	and    $0xe07,%eax
  80069f:	50                   	push   %eax
  8006a0:	56                   	push   %esi
  8006a1:	6a 00                	push   $0x0
  8006a3:	52                   	push   %edx
  8006a4:	6a 00                	push   $0x0
  8006a6:	e8 00 fb ff ff       	call   8001ab <sys_page_map>
  8006ab:	89 c3                	mov    %eax,%ebx
  8006ad:	83 c4 20             	add    $0x20,%esp
  8006b0:	85 c0                	test   %eax,%eax
  8006b2:	78 31                	js     8006e5 <dup+0xd1>
		goto err;

	return newfdnum;
  8006b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  8006b7:	89 d8                	mov    %ebx,%eax
  8006b9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006bc:	5b                   	pop    %ebx
  8006bd:	5e                   	pop    %esi
  8006be:	5f                   	pop    %edi
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006c1:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006c8:	83 ec 0c             	sub    $0xc,%esp
  8006cb:	25 07 0e 00 00       	and    $0xe07,%eax
  8006d0:	50                   	push   %eax
  8006d1:	57                   	push   %edi
  8006d2:	6a 00                	push   $0x0
  8006d4:	53                   	push   %ebx
  8006d5:	6a 00                	push   $0x0
  8006d7:	e8 cf fa ff ff       	call   8001ab <sys_page_map>
  8006dc:	89 c3                	mov    %eax,%ebx
  8006de:	83 c4 20             	add    $0x20,%esp
  8006e1:	85 c0                	test   %eax,%eax
  8006e3:	79 a3                	jns    800688 <dup+0x74>
	sys_page_unmap(0, newfd);
  8006e5:	83 ec 08             	sub    $0x8,%esp
  8006e8:	56                   	push   %esi
  8006e9:	6a 00                	push   $0x0
  8006eb:	e8 fd fa ff ff       	call   8001ed <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006f0:	83 c4 08             	add    $0x8,%esp
  8006f3:	57                   	push   %edi
  8006f4:	6a 00                	push   $0x0
  8006f6:	e8 f2 fa ff ff       	call   8001ed <sys_page_unmap>
	return r;
  8006fb:	83 c4 10             	add    $0x10,%esp
  8006fe:	eb b7                	jmp    8006b7 <dup+0xa3>

00800700 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
  800703:	53                   	push   %ebx
  800704:	83 ec 14             	sub    $0x14,%esp
  800707:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  80070a:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80070d:	50                   	push   %eax
  80070e:	53                   	push   %ebx
  80070f:	e8 7f fd ff ff       	call   800493 <fd_lookup>
  800714:	83 c4 08             	add    $0x8,%esp
  800717:	85 c0                	test   %eax,%eax
  800719:	78 3f                	js     80075a <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  80071b:	83 ec 08             	sub    $0x8,%esp
  80071e:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800721:	50                   	push   %eax
  800722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800725:	ff 30                	pushl  (%eax)
  800727:	e8 be fd ff ff       	call   8004ea <dev_lookup>
  80072c:	83 c4 10             	add    $0x10,%esp
  80072f:	85 c0                	test   %eax,%eax
  800731:	78 27                	js     80075a <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800733:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800736:	8b 42 08             	mov    0x8(%edx),%eax
  800739:	83 e0 03             	and    $0x3,%eax
  80073c:	83 f8 01             	cmp    $0x1,%eax
  80073f:	74 1e                	je     80075f <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800741:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800744:	8b 40 08             	mov    0x8(%eax),%eax
  800747:	85 c0                	test   %eax,%eax
  800749:	74 35                	je     800780 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  80074b:	83 ec 04             	sub    $0x4,%esp
  80074e:	ff 75 10             	pushl  0x10(%ebp)
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	52                   	push   %edx
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
}
  80075a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80075d:	c9                   	leave  
  80075e:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80075f:	a1 04 40 80 00       	mov    0x804004,%eax
  800764:	8b 40 48             	mov    0x48(%eax),%eax
  800767:	83 ec 04             	sub    $0x4,%esp
  80076a:	53                   	push   %ebx
  80076b:	50                   	push   %eax
  80076c:	68 99 1f 80 00       	push   $0x801f99
  800771:	e8 c5 0a 00 00       	call   80123b <cprintf>
		return -E_INVAL;
  800776:	83 c4 10             	add    $0x10,%esp
  800779:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80077e:	eb da                	jmp    80075a <read+0x5a>
		return -E_NOT_SUPP;
  800780:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800785:	eb d3                	jmp    80075a <read+0x5a>

00800787 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800787:	55                   	push   %ebp
  800788:	89 e5                	mov    %esp,%ebp
  80078a:	57                   	push   %edi
  80078b:	56                   	push   %esi
  80078c:	53                   	push   %ebx
  80078d:	83 ec 0c             	sub    $0xc,%esp
  800790:	8b 7d 08             	mov    0x8(%ebp),%edi
  800793:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800796:	bb 00 00 00 00       	mov    $0x0,%ebx
  80079b:	39 f3                	cmp    %esi,%ebx
  80079d:	73 25                	jae    8007c4 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80079f:	83 ec 04             	sub    $0x4,%esp
  8007a2:	89 f0                	mov    %esi,%eax
  8007a4:	29 d8                	sub    %ebx,%eax
  8007a6:	50                   	push   %eax
  8007a7:	89 d8                	mov    %ebx,%eax
  8007a9:	03 45 0c             	add    0xc(%ebp),%eax
  8007ac:	50                   	push   %eax
  8007ad:	57                   	push   %edi
  8007ae:	e8 4d ff ff ff       	call   800700 <read>
		if (m < 0)
  8007b3:	83 c4 10             	add    $0x10,%esp
  8007b6:	85 c0                	test   %eax,%eax
  8007b8:	78 08                	js     8007c2 <readn+0x3b>
			return m;
		if (m == 0)
  8007ba:	85 c0                	test   %eax,%eax
  8007bc:	74 06                	je     8007c4 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007be:	01 c3                	add    %eax,%ebx
  8007c0:	eb d9                	jmp    80079b <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007c2:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007c4:	89 d8                	mov    %ebx,%eax
  8007c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007c9:	5b                   	pop    %ebx
  8007ca:	5e                   	pop    %esi
  8007cb:	5f                   	pop    %edi
  8007cc:	5d                   	pop    %ebp
  8007cd:	c3                   	ret    

008007ce <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007ce:	55                   	push   %ebp
  8007cf:	89 e5                	mov    %esp,%ebp
  8007d1:	53                   	push   %ebx
  8007d2:	83 ec 14             	sub    $0x14,%esp
  8007d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007d8:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007db:	50                   	push   %eax
  8007dc:	53                   	push   %ebx
  8007dd:	e8 b1 fc ff ff       	call   800493 <fd_lookup>
  8007e2:	83 c4 08             	add    $0x8,%esp
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	78 3a                	js     800823 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007ef:	50                   	push   %eax
  8007f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007f3:	ff 30                	pushl  (%eax)
  8007f5:	e8 f0 fc ff ff       	call   8004ea <dev_lookup>
  8007fa:	83 c4 10             	add    $0x10,%esp
  8007fd:	85 c0                	test   %eax,%eax
  8007ff:	78 22                	js     800823 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800801:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800804:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800808:	74 1e                	je     800828 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  80080a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80080d:	8b 52 0c             	mov    0xc(%edx),%edx
  800810:	85 d2                	test   %edx,%edx
  800812:	74 35                	je     800849 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  800814:	83 ec 04             	sub    $0x4,%esp
  800817:	ff 75 10             	pushl  0x10(%ebp)
  80081a:	ff 75 0c             	pushl  0xc(%ebp)
  80081d:	50                   	push   %eax
  80081e:	ff d2                	call   *%edx
  800820:	83 c4 10             	add    $0x10,%esp
}
  800823:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800826:	c9                   	leave  
  800827:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800828:	a1 04 40 80 00       	mov    0x804004,%eax
  80082d:	8b 40 48             	mov    0x48(%eax),%eax
  800830:	83 ec 04             	sub    $0x4,%esp
  800833:	53                   	push   %ebx
  800834:	50                   	push   %eax
  800835:	68 b5 1f 80 00       	push   $0x801fb5
  80083a:	e8 fc 09 00 00       	call   80123b <cprintf>
		return -E_INVAL;
  80083f:	83 c4 10             	add    $0x10,%esp
  800842:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800847:	eb da                	jmp    800823 <write+0x55>
		return -E_NOT_SUPP;
  800849:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80084e:	eb d3                	jmp    800823 <write+0x55>

00800850 <seek>:

int
seek(int fdnum, off_t offset)
{
  800850:	55                   	push   %ebp
  800851:	89 e5                	mov    %esp,%ebp
  800853:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800856:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800859:	50                   	push   %eax
  80085a:	ff 75 08             	pushl  0x8(%ebp)
  80085d:	e8 31 fc ff ff       	call   800493 <fd_lookup>
  800862:	83 c4 08             	add    $0x8,%esp
  800865:	85 c0                	test   %eax,%eax
  800867:	78 0e                	js     800877 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800869:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80086c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80086f:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800872:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	53                   	push   %ebx
  80087d:	83 ec 14             	sub    $0x14,%esp
  800880:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800883:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800886:	50                   	push   %eax
  800887:	53                   	push   %ebx
  800888:	e8 06 fc ff ff       	call   800493 <fd_lookup>
  80088d:	83 c4 08             	add    $0x8,%esp
  800890:	85 c0                	test   %eax,%eax
  800892:	78 37                	js     8008cb <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800894:	83 ec 08             	sub    $0x8,%esp
  800897:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80089a:	50                   	push   %eax
  80089b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80089e:	ff 30                	pushl  (%eax)
  8008a0:	e8 45 fc ff ff       	call   8004ea <dev_lookup>
  8008a5:	83 c4 10             	add    $0x10,%esp
  8008a8:	85 c0                	test   %eax,%eax
  8008aa:	78 1f                	js     8008cb <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8008ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008af:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8008b3:	74 1b                	je     8008d0 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  8008b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008b8:	8b 52 18             	mov    0x18(%edx),%edx
  8008bb:	85 d2                	test   %edx,%edx
  8008bd:	74 32                	je     8008f1 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008bf:	83 ec 08             	sub    $0x8,%esp
  8008c2:	ff 75 0c             	pushl  0xc(%ebp)
  8008c5:	50                   	push   %eax
  8008c6:	ff d2                	call   *%edx
  8008c8:	83 c4 10             	add    $0x10,%esp
}
  8008cb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ce:	c9                   	leave  
  8008cf:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008d0:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008d5:	8b 40 48             	mov    0x48(%eax),%eax
  8008d8:	83 ec 04             	sub    $0x4,%esp
  8008db:	53                   	push   %ebx
  8008dc:	50                   	push   %eax
  8008dd:	68 78 1f 80 00       	push   $0x801f78
  8008e2:	e8 54 09 00 00       	call   80123b <cprintf>
		return -E_INVAL;
  8008e7:	83 c4 10             	add    $0x10,%esp
  8008ea:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008ef:	eb da                	jmp    8008cb <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008f1:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008f6:	eb d3                	jmp    8008cb <ftruncate+0x52>

008008f8 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008f8:	55                   	push   %ebp
  8008f9:	89 e5                	mov    %esp,%ebp
  8008fb:	53                   	push   %ebx
  8008fc:	83 ec 14             	sub    $0x14,%esp
  8008ff:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  800902:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800905:	50                   	push   %eax
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 85 fb ff ff       	call   800493 <fd_lookup>
  80090e:	83 c4 08             	add    $0x8,%esp
  800911:	85 c0                	test   %eax,%eax
  800913:	78 4b                	js     800960 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800915:	83 ec 08             	sub    $0x8,%esp
  800918:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80091b:	50                   	push   %eax
  80091c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80091f:	ff 30                	pushl  (%eax)
  800921:	e8 c4 fb ff ff       	call   8004ea <dev_lookup>
  800926:	83 c4 10             	add    $0x10,%esp
  800929:	85 c0                	test   %eax,%eax
  80092b:	78 33                	js     800960 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80092d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800930:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800934:	74 2f                	je     800965 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800936:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800939:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800940:	00 00 00 
	stat->st_type = 0;
  800943:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80094a:	00 00 00 
	stat->st_dev = dev;
  80094d:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	53                   	push   %ebx
  800957:	ff 75 f0             	pushl  -0x10(%ebp)
  80095a:	ff 50 14             	call   *0x14(%eax)
  80095d:	83 c4 10             	add    $0x10,%esp
}
  800960:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800963:	c9                   	leave  
  800964:	c3                   	ret    
		return -E_NOT_SUPP;
  800965:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80096a:	eb f4                	jmp    800960 <fstat+0x68>

0080096c <stat>:

int
stat(const char *path, struct Stat *stat)
{
  80096c:	55                   	push   %ebp
  80096d:	89 e5                	mov    %esp,%ebp
  80096f:	56                   	push   %esi
  800970:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800971:	83 ec 08             	sub    $0x8,%esp
  800974:	6a 00                	push   $0x0
  800976:	ff 75 08             	pushl  0x8(%ebp)
  800979:	e8 34 02 00 00       	call   800bb2 <open>
  80097e:	89 c3                	mov    %eax,%ebx
  800980:	83 c4 10             	add    $0x10,%esp
  800983:	85 c0                	test   %eax,%eax
  800985:	78 1b                	js     8009a2 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800987:	83 ec 08             	sub    $0x8,%esp
  80098a:	ff 75 0c             	pushl  0xc(%ebp)
  80098d:	50                   	push   %eax
  80098e:	e8 65 ff ff ff       	call   8008f8 <fstat>
  800993:	89 c6                	mov    %eax,%esi
	close(fd);
  800995:	89 1c 24             	mov    %ebx,(%esp)
  800998:	e8 29 fc ff ff       	call   8005c6 <close>
	return r;
  80099d:	83 c4 10             	add    $0x10,%esp
  8009a0:	89 f3                	mov    %esi,%ebx
}
  8009a2:	89 d8                	mov    %ebx,%eax
  8009a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009a7:	5b                   	pop    %ebx
  8009a8:	5e                   	pop    %esi
  8009a9:	5d                   	pop    %ebp
  8009aa:	c3                   	ret    

008009ab <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  8009ab:	55                   	push   %ebp
  8009ac:	89 e5                	mov    %esp,%ebp
  8009ae:	56                   	push   %esi
  8009af:	53                   	push   %ebx
  8009b0:	89 c6                	mov    %eax,%esi
  8009b2:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  8009b4:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009bb:	74 27                	je     8009e4 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009bd:	6a 07                	push   $0x7
  8009bf:	68 00 50 80 00       	push   $0x805000
  8009c4:	56                   	push   %esi
  8009c5:	ff 35 00 40 80 00    	pushl  0x804000
  8009cb:	e8 14 12 00 00       	call   801be4 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009d0:	83 c4 0c             	add    $0xc,%esp
  8009d3:	6a 00                	push   $0x0
  8009d5:	53                   	push   %ebx
  8009d6:	6a 00                	push   $0x0
  8009d8:	e8 7e 11 00 00       	call   801b5b <ipc_recv>
}
  8009dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009e0:	5b                   	pop    %ebx
  8009e1:	5e                   	pop    %esi
  8009e2:	5d                   	pop    %ebp
  8009e3:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009e4:	83 ec 0c             	sub    $0xc,%esp
  8009e7:	6a 01                	push   $0x1
  8009e9:	e8 52 12 00 00       	call   801c40 <ipc_find_env>
  8009ee:	a3 00 40 80 00       	mov    %eax,0x804000
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	eb c5                	jmp    8009bd <fsipc+0x12>

008009f8 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800a01:	8b 40 0c             	mov    0xc(%eax),%eax
  800a04:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  800a09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a0c:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  800a11:	ba 00 00 00 00       	mov    $0x0,%edx
  800a16:	b8 02 00 00 00       	mov    $0x2,%eax
  800a1b:	e8 8b ff ff ff       	call   8009ab <fsipc>
}
  800a20:	c9                   	leave  
  800a21:	c3                   	ret    

00800a22 <devfile_flush>:
{
  800a22:	55                   	push   %ebp
  800a23:	89 e5                	mov    %esp,%ebp
  800a25:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	8b 40 0c             	mov    0xc(%eax),%eax
  800a2e:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a33:	ba 00 00 00 00       	mov    $0x0,%edx
  800a38:	b8 06 00 00 00       	mov    $0x6,%eax
  800a3d:	e8 69 ff ff ff       	call   8009ab <fsipc>
}
  800a42:	c9                   	leave  
  800a43:	c3                   	ret    

00800a44 <devfile_stat>:
{
  800a44:	55                   	push   %ebp
  800a45:	89 e5                	mov    %esp,%ebp
  800a47:	53                   	push   %ebx
  800a48:	83 ec 04             	sub    $0x4,%esp
  800a4b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a51:	8b 40 0c             	mov    0xc(%eax),%eax
  800a54:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a59:	ba 00 00 00 00       	mov    $0x0,%edx
  800a5e:	b8 05 00 00 00       	mov    $0x5,%eax
  800a63:	e8 43 ff ff ff       	call   8009ab <fsipc>
  800a68:	85 c0                	test   %eax,%eax
  800a6a:	78 2c                	js     800a98 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	68 00 50 80 00       	push   $0x805000
  800a74:	53                   	push   %ebx
  800a75:	e8 c9 0d 00 00       	call   801843 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a7a:	a1 80 50 80 00       	mov    0x805080,%eax
  800a7f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a85:	a1 84 50 80 00       	mov    0x805084,%eax
  800a8a:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a9b:	c9                   	leave  
  800a9c:	c3                   	ret    

00800a9d <devfile_write>:
{
  800a9d:	55                   	push   %ebp
  800a9e:	89 e5                	mov    %esp,%ebp
  800aa0:	53                   	push   %ebx
  800aa1:	83 ec 04             	sub    $0x4,%esp
  800aa4:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800aa7:	89 d8                	mov    %ebx,%eax
  800aa9:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800aaf:	76 05                	jbe    800ab6 <devfile_write+0x19>
  800ab1:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800ab6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ab9:	8b 52 0c             	mov    0xc(%edx),%edx
  800abc:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800ac2:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800ac7:	83 ec 04             	sub    $0x4,%esp
  800aca:	50                   	push   %eax
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	68 08 50 80 00       	push   $0x805008
  800ad3:	e8 de 0e 00 00       	call   8019b6 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800ad8:	ba 00 00 00 00       	mov    $0x0,%edx
  800add:	b8 04 00 00 00       	mov    $0x4,%eax
  800ae2:	e8 c4 fe ff ff       	call   8009ab <fsipc>
  800ae7:	83 c4 10             	add    $0x10,%esp
  800aea:	85 c0                	test   %eax,%eax
  800aec:	78 0b                	js     800af9 <devfile_write+0x5c>
	assert(r <= n);
  800aee:	39 c3                	cmp    %eax,%ebx
  800af0:	72 0c                	jb     800afe <devfile_write+0x61>
	assert(r <= PGSIZE);
  800af2:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800af7:	7f 1e                	jg     800b17 <devfile_write+0x7a>
}
  800af9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800afc:	c9                   	leave  
  800afd:	c3                   	ret    
	assert(r <= n);
  800afe:	68 e4 1f 80 00       	push   $0x801fe4
  800b03:	68 eb 1f 80 00       	push   $0x801feb
  800b08:	68 98 00 00 00       	push   $0x98
  800b0d:	68 00 20 80 00       	push   $0x802000
  800b12:	e8 11 06 00 00       	call   801128 <_panic>
	assert(r <= PGSIZE);
  800b17:	68 0b 20 80 00       	push   $0x80200b
  800b1c:	68 eb 1f 80 00       	push   $0x801feb
  800b21:	68 99 00 00 00       	push   $0x99
  800b26:	68 00 20 80 00       	push   $0x802000
  800b2b:	e8 f8 05 00 00       	call   801128 <_panic>

00800b30 <devfile_read>:
{
  800b30:	55                   	push   %ebp
  800b31:	89 e5                	mov    %esp,%ebp
  800b33:	56                   	push   %esi
  800b34:	53                   	push   %ebx
  800b35:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8b 40 0c             	mov    0xc(%eax),%eax
  800b3e:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b43:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b49:	ba 00 00 00 00       	mov    $0x0,%edx
  800b4e:	b8 03 00 00 00       	mov    $0x3,%eax
  800b53:	e8 53 fe ff ff       	call   8009ab <fsipc>
  800b58:	89 c3                	mov    %eax,%ebx
  800b5a:	85 c0                	test   %eax,%eax
  800b5c:	78 1f                	js     800b7d <devfile_read+0x4d>
	assert(r <= n);
  800b5e:	39 c6                	cmp    %eax,%esi
  800b60:	72 24                	jb     800b86 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b62:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b67:	7f 33                	jg     800b9c <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b69:	83 ec 04             	sub    $0x4,%esp
  800b6c:	50                   	push   %eax
  800b6d:	68 00 50 80 00       	push   $0x805000
  800b72:	ff 75 0c             	pushl  0xc(%ebp)
  800b75:	e8 3c 0e 00 00       	call   8019b6 <memmove>
	return r;
  800b7a:	83 c4 10             	add    $0x10,%esp
}
  800b7d:	89 d8                	mov    %ebx,%eax
  800b7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b82:	5b                   	pop    %ebx
  800b83:	5e                   	pop    %esi
  800b84:	5d                   	pop    %ebp
  800b85:	c3                   	ret    
	assert(r <= n);
  800b86:	68 e4 1f 80 00       	push   $0x801fe4
  800b8b:	68 eb 1f 80 00       	push   $0x801feb
  800b90:	6a 7c                	push   $0x7c
  800b92:	68 00 20 80 00       	push   $0x802000
  800b97:	e8 8c 05 00 00       	call   801128 <_panic>
	assert(r <= PGSIZE);
  800b9c:	68 0b 20 80 00       	push   $0x80200b
  800ba1:	68 eb 1f 80 00       	push   $0x801feb
  800ba6:	6a 7d                	push   $0x7d
  800ba8:	68 00 20 80 00       	push   $0x802000
  800bad:	e8 76 05 00 00       	call   801128 <_panic>

00800bb2 <open>:
{
  800bb2:	55                   	push   %ebp
  800bb3:	89 e5                	mov    %esp,%ebp
  800bb5:	56                   	push   %esi
  800bb6:	53                   	push   %ebx
  800bb7:	83 ec 1c             	sub    $0x1c,%esp
  800bba:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800bbd:	56                   	push   %esi
  800bbe:	e8 4d 0c 00 00       	call   801810 <strlen>
  800bc3:	83 c4 10             	add    $0x10,%esp
  800bc6:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bcb:	7f 6c                	jg     800c39 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800bcd:	83 ec 0c             	sub    $0xc,%esp
  800bd0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bd3:	50                   	push   %eax
  800bd4:	e8 6b f8 ff ff       	call   800444 <fd_alloc>
  800bd9:	89 c3                	mov    %eax,%ebx
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	85 c0                	test   %eax,%eax
  800be0:	78 3c                	js     800c1e <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800be2:	83 ec 08             	sub    $0x8,%esp
  800be5:	56                   	push   %esi
  800be6:	68 00 50 80 00       	push   $0x805000
  800beb:	e8 53 0c 00 00       	call   801843 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bf0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf3:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bf8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bfb:	b8 01 00 00 00       	mov    $0x1,%eax
  800c00:	e8 a6 fd ff ff       	call   8009ab <fsipc>
  800c05:	89 c3                	mov    %eax,%ebx
  800c07:	83 c4 10             	add    $0x10,%esp
  800c0a:	85 c0                	test   %eax,%eax
  800c0c:	78 19                	js     800c27 <open+0x75>
	return fd2num(fd);
  800c0e:	83 ec 0c             	sub    $0xc,%esp
  800c11:	ff 75 f4             	pushl  -0xc(%ebp)
  800c14:	e8 04 f8 ff ff       	call   80041d <fd2num>
  800c19:	89 c3                	mov    %eax,%ebx
  800c1b:	83 c4 10             	add    $0x10,%esp
}
  800c1e:	89 d8                	mov    %ebx,%eax
  800c20:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c23:	5b                   	pop    %ebx
  800c24:	5e                   	pop    %esi
  800c25:	5d                   	pop    %ebp
  800c26:	c3                   	ret    
		fd_close(fd, 0);
  800c27:	83 ec 08             	sub    $0x8,%esp
  800c2a:	6a 00                	push   $0x0
  800c2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800c2f:	e8 0c f9 ff ff       	call   800540 <fd_close>
		return r;
  800c34:	83 c4 10             	add    $0x10,%esp
  800c37:	eb e5                	jmp    800c1e <open+0x6c>
		return -E_BAD_PATH;
  800c39:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c3e:	eb de                	jmp    800c1e <open+0x6c>

00800c40 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c46:	ba 00 00 00 00       	mov    $0x0,%edx
  800c4b:	b8 08 00 00 00       	mov    $0x8,%eax
  800c50:	e8 56 fd ff ff       	call   8009ab <fsipc>
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	56                   	push   %esi
  800c5b:	53                   	push   %ebx
  800c5c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c5f:	83 ec 0c             	sub    $0xc,%esp
  800c62:	ff 75 08             	pushl  0x8(%ebp)
  800c65:	e8 c3 f7 ff ff       	call   80042d <fd2data>
  800c6a:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c6c:	83 c4 08             	add    $0x8,%esp
  800c6f:	68 17 20 80 00       	push   $0x802017
  800c74:	53                   	push   %ebx
  800c75:	e8 c9 0b 00 00       	call   801843 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c7a:	8b 46 04             	mov    0x4(%esi),%eax
  800c7d:	2b 06                	sub    (%esi),%eax
  800c7f:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c85:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c8c:	10 00 00 
	stat->st_dev = &devpipe;
  800c8f:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c96:	30 80 00 
	return 0;
}
  800c99:	b8 00 00 00 00       	mov    $0x0,%eax
  800c9e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ca1:	5b                   	pop    %ebx
  800ca2:	5e                   	pop    %esi
  800ca3:	5d                   	pop    %ebp
  800ca4:	c3                   	ret    

00800ca5 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800ca5:	55                   	push   %ebp
  800ca6:	89 e5                	mov    %esp,%ebp
  800ca8:	53                   	push   %ebx
  800ca9:	83 ec 0c             	sub    $0xc,%esp
  800cac:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800caf:	53                   	push   %ebx
  800cb0:	6a 00                	push   $0x0
  800cb2:	e8 36 f5 ff ff       	call   8001ed <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800cb7:	89 1c 24             	mov    %ebx,(%esp)
  800cba:	e8 6e f7 ff ff       	call   80042d <fd2data>
  800cbf:	83 c4 08             	add    $0x8,%esp
  800cc2:	50                   	push   %eax
  800cc3:	6a 00                	push   $0x0
  800cc5:	e8 23 f5 ff ff       	call   8001ed <sys_page_unmap>
}
  800cca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ccd:	c9                   	leave  
  800cce:	c3                   	ret    

00800ccf <_pipeisclosed>:
{
  800ccf:	55                   	push   %ebp
  800cd0:	89 e5                	mov    %esp,%ebp
  800cd2:	57                   	push   %edi
  800cd3:	56                   	push   %esi
  800cd4:	53                   	push   %ebx
  800cd5:	83 ec 1c             	sub    $0x1c,%esp
  800cd8:	89 c7                	mov    %eax,%edi
  800cda:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cdc:	a1 04 40 80 00       	mov    0x804004,%eax
  800ce1:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800ce4:	83 ec 0c             	sub    $0xc,%esp
  800ce7:	57                   	push   %edi
  800ce8:	e8 95 0f 00 00       	call   801c82 <pageref>
  800ced:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cf0:	89 34 24             	mov    %esi,(%esp)
  800cf3:	e8 8a 0f 00 00       	call   801c82 <pageref>
		nn = thisenv->env_runs;
  800cf8:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cfe:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800d01:	83 c4 10             	add    $0x10,%esp
  800d04:	39 cb                	cmp    %ecx,%ebx
  800d06:	74 1b                	je     800d23 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800d08:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d0b:	75 cf                	jne    800cdc <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800d0d:	8b 42 58             	mov    0x58(%edx),%eax
  800d10:	6a 01                	push   $0x1
  800d12:	50                   	push   %eax
  800d13:	53                   	push   %ebx
  800d14:	68 1e 20 80 00       	push   $0x80201e
  800d19:	e8 1d 05 00 00       	call   80123b <cprintf>
  800d1e:	83 c4 10             	add    $0x10,%esp
  800d21:	eb b9                	jmp    800cdc <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d23:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d26:	0f 94 c0             	sete   %al
  800d29:	0f b6 c0             	movzbl %al,%eax
}
  800d2c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d2f:	5b                   	pop    %ebx
  800d30:	5e                   	pop    %esi
  800d31:	5f                   	pop    %edi
  800d32:	5d                   	pop    %ebp
  800d33:	c3                   	ret    

00800d34 <devpipe_write>:
{
  800d34:	55                   	push   %ebp
  800d35:	89 e5                	mov    %esp,%ebp
  800d37:	57                   	push   %edi
  800d38:	56                   	push   %esi
  800d39:	53                   	push   %ebx
  800d3a:	83 ec 18             	sub    $0x18,%esp
  800d3d:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d40:	56                   	push   %esi
  800d41:	e8 e7 f6 ff ff       	call   80042d <fd2data>
  800d46:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	bf 00 00 00 00       	mov    $0x0,%edi
  800d50:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d53:	74 41                	je     800d96 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d55:	8b 53 04             	mov    0x4(%ebx),%edx
  800d58:	8b 03                	mov    (%ebx),%eax
  800d5a:	83 c0 20             	add    $0x20,%eax
  800d5d:	39 c2                	cmp    %eax,%edx
  800d5f:	72 14                	jb     800d75 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d61:	89 da                	mov    %ebx,%edx
  800d63:	89 f0                	mov    %esi,%eax
  800d65:	e8 65 ff ff ff       	call   800ccf <_pipeisclosed>
  800d6a:	85 c0                	test   %eax,%eax
  800d6c:	75 2c                	jne    800d9a <devpipe_write+0x66>
			sys_yield();
  800d6e:	e8 bc f4 ff ff       	call   80022f <sys_yield>
  800d73:	eb e0                	jmp    800d55 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d7b:	89 d0                	mov    %edx,%eax
  800d7d:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d82:	78 0b                	js     800d8f <devpipe_write+0x5b>
  800d84:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d88:	42                   	inc    %edx
  800d89:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d8c:	47                   	inc    %edi
  800d8d:	eb c1                	jmp    800d50 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d8f:	48                   	dec    %eax
  800d90:	83 c8 e0             	or     $0xffffffe0,%eax
  800d93:	40                   	inc    %eax
  800d94:	eb ee                	jmp    800d84 <devpipe_write+0x50>
	return i;
  800d96:	89 f8                	mov    %edi,%eax
  800d98:	eb 05                	jmp    800d9f <devpipe_write+0x6b>
				return 0;
  800d9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d9f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800da2:	5b                   	pop    %ebx
  800da3:	5e                   	pop    %esi
  800da4:	5f                   	pop    %edi
  800da5:	5d                   	pop    %ebp
  800da6:	c3                   	ret    

00800da7 <devpipe_read>:
{
  800da7:	55                   	push   %ebp
  800da8:	89 e5                	mov    %esp,%ebp
  800daa:	57                   	push   %edi
  800dab:	56                   	push   %esi
  800dac:	53                   	push   %ebx
  800dad:	83 ec 18             	sub    $0x18,%esp
  800db0:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800db3:	57                   	push   %edi
  800db4:	e8 74 f6 ff ff       	call   80042d <fd2data>
  800db9:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800dbb:	83 c4 10             	add    $0x10,%esp
  800dbe:	bb 00 00 00 00       	mov    $0x0,%ebx
  800dc3:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800dc6:	74 46                	je     800e0e <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800dc8:	8b 06                	mov    (%esi),%eax
  800dca:	3b 46 04             	cmp    0x4(%esi),%eax
  800dcd:	75 22                	jne    800df1 <devpipe_read+0x4a>
			if (i > 0)
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 0a                	je     800ddd <devpipe_read+0x36>
				return i;
  800dd3:	89 d8                	mov    %ebx,%eax
}
  800dd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dd8:	5b                   	pop    %ebx
  800dd9:	5e                   	pop    %esi
  800dda:	5f                   	pop    %edi
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800ddd:	89 f2                	mov    %esi,%edx
  800ddf:	89 f8                	mov    %edi,%eax
  800de1:	e8 e9 fe ff ff       	call   800ccf <_pipeisclosed>
  800de6:	85 c0                	test   %eax,%eax
  800de8:	75 28                	jne    800e12 <devpipe_read+0x6b>
			sys_yield();
  800dea:	e8 40 f4 ff ff       	call   80022f <sys_yield>
  800def:	eb d7                	jmp    800dc8 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800df1:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800df6:	78 0f                	js     800e07 <devpipe_read+0x60>
  800df8:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dfc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800dff:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800e02:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800e04:	43                   	inc    %ebx
  800e05:	eb bc                	jmp    800dc3 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800e07:	48                   	dec    %eax
  800e08:	83 c8 e0             	or     $0xffffffe0,%eax
  800e0b:	40                   	inc    %eax
  800e0c:	eb ea                	jmp    800df8 <devpipe_read+0x51>
	return i;
  800e0e:	89 d8                	mov    %ebx,%eax
  800e10:	eb c3                	jmp    800dd5 <devpipe_read+0x2e>
				return 0;
  800e12:	b8 00 00 00 00       	mov    $0x0,%eax
  800e17:	eb bc                	jmp    800dd5 <devpipe_read+0x2e>

00800e19 <pipe>:
{
  800e19:	55                   	push   %ebp
  800e1a:	89 e5                	mov    %esp,%ebp
  800e1c:	56                   	push   %esi
  800e1d:	53                   	push   %ebx
  800e1e:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800e21:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e24:	50                   	push   %eax
  800e25:	e8 1a f6 ff ff       	call   800444 <fd_alloc>
  800e2a:	89 c3                	mov    %eax,%ebx
  800e2c:	83 c4 10             	add    $0x10,%esp
  800e2f:	85 c0                	test   %eax,%eax
  800e31:	0f 88 2a 01 00 00    	js     800f61 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e37:	83 ec 04             	sub    $0x4,%esp
  800e3a:	68 07 04 00 00       	push   $0x407
  800e3f:	ff 75 f4             	pushl  -0xc(%ebp)
  800e42:	6a 00                	push   $0x0
  800e44:	e8 1f f3 ff ff       	call   800168 <sys_page_alloc>
  800e49:	89 c3                	mov    %eax,%ebx
  800e4b:	83 c4 10             	add    $0x10,%esp
  800e4e:	85 c0                	test   %eax,%eax
  800e50:	0f 88 0b 01 00 00    	js     800f61 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e56:	83 ec 0c             	sub    $0xc,%esp
  800e59:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 e2 f5 ff ff       	call   800444 <fd_alloc>
  800e62:	89 c3                	mov    %eax,%ebx
  800e64:	83 c4 10             	add    $0x10,%esp
  800e67:	85 c0                	test   %eax,%eax
  800e69:	0f 88 e2 00 00 00    	js     800f51 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e6f:	83 ec 04             	sub    $0x4,%esp
  800e72:	68 07 04 00 00       	push   $0x407
  800e77:	ff 75 f0             	pushl  -0x10(%ebp)
  800e7a:	6a 00                	push   $0x0
  800e7c:	e8 e7 f2 ff ff       	call   800168 <sys_page_alloc>
  800e81:	89 c3                	mov    %eax,%ebx
  800e83:	83 c4 10             	add    $0x10,%esp
  800e86:	85 c0                	test   %eax,%eax
  800e88:	0f 88 c3 00 00 00    	js     800f51 <pipe+0x138>
	va = fd2data(fd0);
  800e8e:	83 ec 0c             	sub    $0xc,%esp
  800e91:	ff 75 f4             	pushl  -0xc(%ebp)
  800e94:	e8 94 f5 ff ff       	call   80042d <fd2data>
  800e99:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e9b:	83 c4 0c             	add    $0xc,%esp
  800e9e:	68 07 04 00 00       	push   $0x407
  800ea3:	50                   	push   %eax
  800ea4:	6a 00                	push   $0x0
  800ea6:	e8 bd f2 ff ff       	call   800168 <sys_page_alloc>
  800eab:	89 c3                	mov    %eax,%ebx
  800ead:	83 c4 10             	add    $0x10,%esp
  800eb0:	85 c0                	test   %eax,%eax
  800eb2:	0f 88 89 00 00 00    	js     800f41 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800eb8:	83 ec 0c             	sub    $0xc,%esp
  800ebb:	ff 75 f0             	pushl  -0x10(%ebp)
  800ebe:	e8 6a f5 ff ff       	call   80042d <fd2data>
  800ec3:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800eca:	50                   	push   %eax
  800ecb:	6a 00                	push   $0x0
  800ecd:	56                   	push   %esi
  800ece:	6a 00                	push   $0x0
  800ed0:	e8 d6 f2 ff ff       	call   8001ab <sys_page_map>
  800ed5:	89 c3                	mov    %eax,%ebx
  800ed7:	83 c4 20             	add    $0x20,%esp
  800eda:	85 c0                	test   %eax,%eax
  800edc:	78 55                	js     800f33 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ede:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ee4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ee7:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ef3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ef9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800efc:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800efe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f01:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800f08:	83 ec 0c             	sub    $0xc,%esp
  800f0b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f0e:	e8 0a f5 ff ff       	call   80041d <fd2num>
  800f13:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f16:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800f18:	83 c4 04             	add    $0x4,%esp
  800f1b:	ff 75 f0             	pushl  -0x10(%ebp)
  800f1e:	e8 fa f4 ff ff       	call   80041d <fd2num>
  800f23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f26:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f29:	83 c4 10             	add    $0x10,%esp
  800f2c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f31:	eb 2e                	jmp    800f61 <pipe+0x148>
	sys_page_unmap(0, va);
  800f33:	83 ec 08             	sub    $0x8,%esp
  800f36:	56                   	push   %esi
  800f37:	6a 00                	push   $0x0
  800f39:	e8 af f2 ff ff       	call   8001ed <sys_page_unmap>
  800f3e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f41:	83 ec 08             	sub    $0x8,%esp
  800f44:	ff 75 f0             	pushl  -0x10(%ebp)
  800f47:	6a 00                	push   $0x0
  800f49:	e8 9f f2 ff ff       	call   8001ed <sys_page_unmap>
  800f4e:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f51:	83 ec 08             	sub    $0x8,%esp
  800f54:	ff 75 f4             	pushl  -0xc(%ebp)
  800f57:	6a 00                	push   $0x0
  800f59:	e8 8f f2 ff ff       	call   8001ed <sys_page_unmap>
  800f5e:	83 c4 10             	add    $0x10,%esp
}
  800f61:	89 d8                	mov    %ebx,%eax
  800f63:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f66:	5b                   	pop    %ebx
  800f67:	5e                   	pop    %esi
  800f68:	5d                   	pop    %ebp
  800f69:	c3                   	ret    

00800f6a <pipeisclosed>:
{
  800f6a:	55                   	push   %ebp
  800f6b:	89 e5                	mov    %esp,%ebp
  800f6d:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f70:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f73:	50                   	push   %eax
  800f74:	ff 75 08             	pushl  0x8(%ebp)
  800f77:	e8 17 f5 ff ff       	call   800493 <fd_lookup>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	85 c0                	test   %eax,%eax
  800f81:	78 18                	js     800f9b <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f83:	83 ec 0c             	sub    $0xc,%esp
  800f86:	ff 75 f4             	pushl  -0xc(%ebp)
  800f89:	e8 9f f4 ff ff       	call   80042d <fd2data>
	return _pipeisclosed(fd, p);
  800f8e:	89 c2                	mov    %eax,%edx
  800f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f93:	e8 37 fd ff ff       	call   800ccf <_pipeisclosed>
  800f98:	83 c4 10             	add    $0x10,%esp
}
  800f9b:	c9                   	leave  
  800f9c:	c3                   	ret    

00800f9d <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f9d:	55                   	push   %ebp
  800f9e:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa5:	5d                   	pop    %ebp
  800fa6:	c3                   	ret    

00800fa7 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800fa7:	55                   	push   %ebp
  800fa8:	89 e5                	mov    %esp,%ebp
  800faa:	53                   	push   %ebx
  800fab:	83 ec 0c             	sub    $0xc,%esp
  800fae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800fb1:	68 36 20 80 00       	push   $0x802036
  800fb6:	53                   	push   %ebx
  800fb7:	e8 87 08 00 00       	call   801843 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800fbc:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fc3:	20 00 00 
	return 0;
}
  800fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  800fcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fce:	c9                   	leave  
  800fcf:	c3                   	ret    

00800fd0 <devcons_write>:
{
  800fd0:	55                   	push   %ebp
  800fd1:	89 e5                	mov    %esp,%ebp
  800fd3:	57                   	push   %edi
  800fd4:	56                   	push   %esi
  800fd5:	53                   	push   %ebx
  800fd6:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fdc:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fe1:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fe7:	eb 1d                	jmp    801006 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	53                   	push   %ebx
  800fed:	03 45 0c             	add    0xc(%ebp),%eax
  800ff0:	50                   	push   %eax
  800ff1:	57                   	push   %edi
  800ff2:	e8 bf 09 00 00       	call   8019b6 <memmove>
		sys_cputs(buf, m);
  800ff7:	83 c4 08             	add    $0x8,%esp
  800ffa:	53                   	push   %ebx
  800ffb:	57                   	push   %edi
  800ffc:	e8 ca f0 ff ff       	call   8000cb <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  801001:	01 de                	add    %ebx,%esi
  801003:	83 c4 10             	add    $0x10,%esp
  801006:	89 f0                	mov    %esi,%eax
  801008:	3b 75 10             	cmp    0x10(%ebp),%esi
  80100b:	73 11                	jae    80101e <devcons_write+0x4e>
		m = n - tot;
  80100d:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801010:	29 f3                	sub    %esi,%ebx
  801012:	83 fb 7f             	cmp    $0x7f,%ebx
  801015:	76 d2                	jbe    800fe9 <devcons_write+0x19>
  801017:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  80101c:	eb cb                	jmp    800fe9 <devcons_write+0x19>
}
  80101e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801021:	5b                   	pop    %ebx
  801022:	5e                   	pop    %esi
  801023:	5f                   	pop    %edi
  801024:	5d                   	pop    %ebp
  801025:	c3                   	ret    

00801026 <devcons_read>:
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  80102c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801030:	75 0c                	jne    80103e <devcons_read+0x18>
		return 0;
  801032:	b8 00 00 00 00       	mov    $0x0,%eax
  801037:	eb 21                	jmp    80105a <devcons_read+0x34>
		sys_yield();
  801039:	e8 f1 f1 ff ff       	call   80022f <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80103e:	e8 a6 f0 ff ff       	call   8000e9 <sys_cgetc>
  801043:	85 c0                	test   %eax,%eax
  801045:	74 f2                	je     801039 <devcons_read+0x13>
	if (c < 0)
  801047:	85 c0                	test   %eax,%eax
  801049:	78 0f                	js     80105a <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  80104b:	83 f8 04             	cmp    $0x4,%eax
  80104e:	74 0c                	je     80105c <devcons_read+0x36>
	*(char*)vbuf = c;
  801050:	8b 55 0c             	mov    0xc(%ebp),%edx
  801053:	88 02                	mov    %al,(%edx)
	return 1;
  801055:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    
		return 0;
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
  801061:	eb f7                	jmp    80105a <devcons_read+0x34>

00801063 <cputchar>:
{
  801063:	55                   	push   %ebp
  801064:	89 e5                	mov    %esp,%ebp
  801066:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80106f:	6a 01                	push   $0x1
  801071:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801074:	50                   	push   %eax
  801075:	e8 51 f0 ff ff       	call   8000cb <sys_cputs>
}
  80107a:	83 c4 10             	add    $0x10,%esp
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <getchar>:
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801085:	6a 01                	push   $0x1
  801087:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80108a:	50                   	push   %eax
  80108b:	6a 00                	push   $0x0
  80108d:	e8 6e f6 ff ff       	call   800700 <read>
	if (r < 0)
  801092:	83 c4 10             	add    $0x10,%esp
  801095:	85 c0                	test   %eax,%eax
  801097:	78 08                	js     8010a1 <getchar+0x22>
	if (r < 1)
  801099:	85 c0                	test   %eax,%eax
  80109b:	7e 06                	jle    8010a3 <getchar+0x24>
	return c;
  80109d:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    
		return -E_EOF;
  8010a3:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  8010a8:	eb f7                	jmp    8010a1 <getchar+0x22>

008010aa <iscons>:
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8010b0:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010b3:	50                   	push   %eax
  8010b4:	ff 75 08             	pushl  0x8(%ebp)
  8010b7:	e8 d7 f3 ff ff       	call   800493 <fd_lookup>
  8010bc:	83 c4 10             	add    $0x10,%esp
  8010bf:	85 c0                	test   %eax,%eax
  8010c1:	78 11                	js     8010d4 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010cc:	39 10                	cmp    %edx,(%eax)
  8010ce:	0f 94 c0             	sete   %al
  8010d1:	0f b6 c0             	movzbl %al,%eax
}
  8010d4:	c9                   	leave  
  8010d5:	c3                   	ret    

008010d6 <opencons>:
{
  8010d6:	55                   	push   %ebp
  8010d7:	89 e5                	mov    %esp,%ebp
  8010d9:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010dc:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010df:	50                   	push   %eax
  8010e0:	e8 5f f3 ff ff       	call   800444 <fd_alloc>
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	85 c0                	test   %eax,%eax
  8010ea:	78 3a                	js     801126 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010ec:	83 ec 04             	sub    $0x4,%esp
  8010ef:	68 07 04 00 00       	push   $0x407
  8010f4:	ff 75 f4             	pushl  -0xc(%ebp)
  8010f7:	6a 00                	push   $0x0
  8010f9:	e8 6a f0 ff ff       	call   800168 <sys_page_alloc>
  8010fe:	83 c4 10             	add    $0x10,%esp
  801101:	85 c0                	test   %eax,%eax
  801103:	78 21                	js     801126 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  801105:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  80110b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80110e:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  801110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801113:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	50                   	push   %eax
  80111e:	e8 fa f2 ff ff       	call   80041d <fd2num>
  801123:	83 c4 10             	add    $0x10,%esp
}
  801126:	c9                   	leave  
  801127:	c3                   	ret    

00801128 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801128:	55                   	push   %ebp
  801129:	89 e5                	mov    %esp,%ebp
  80112b:	57                   	push   %edi
  80112c:	56                   	push   %esi
  80112d:	53                   	push   %ebx
  80112e:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801134:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801137:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  80113d:	e8 07 f0 ff ff       	call   800149 <sys_getenvid>
  801142:	83 ec 04             	sub    $0x4,%esp
  801145:	ff 75 0c             	pushl  0xc(%ebp)
  801148:	ff 75 08             	pushl  0x8(%ebp)
  80114b:	53                   	push   %ebx
  80114c:	50                   	push   %eax
  80114d:	68 44 20 80 00       	push   $0x802044
  801152:	68 00 01 00 00       	push   $0x100
  801157:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80115d:	56                   	push   %esi
  80115e:	e8 93 06 00 00       	call   8017f6 <snprintf>
  801163:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801165:	83 c4 20             	add    $0x20,%esp
  801168:	57                   	push   %edi
  801169:	ff 75 10             	pushl  0x10(%ebp)
  80116c:	bf 00 01 00 00       	mov    $0x100,%edi
  801171:	89 f8                	mov    %edi,%eax
  801173:	29 d8                	sub    %ebx,%eax
  801175:	50                   	push   %eax
  801176:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801179:	50                   	push   %eax
  80117a:	e8 22 06 00 00       	call   8017a1 <vsnprintf>
  80117f:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801181:	83 c4 0c             	add    $0xc,%esp
  801184:	68 2f 20 80 00       	push   $0x80202f
  801189:	29 df                	sub    %ebx,%edi
  80118b:	57                   	push   %edi
  80118c:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80118f:	50                   	push   %eax
  801190:	e8 61 06 00 00       	call   8017f6 <snprintf>
	sys_cputs(buf, r);
  801195:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801198:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80119a:	53                   	push   %ebx
  80119b:	56                   	push   %esi
  80119c:	e8 2a ef ff ff       	call   8000cb <sys_cputs>
  8011a1:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  8011a4:	cc                   	int3   
  8011a5:	eb fd                	jmp    8011a4 <_panic+0x7c>

008011a7 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	53                   	push   %ebx
  8011ab:	83 ec 04             	sub    $0x4,%esp
  8011ae:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  8011b1:	8b 13                	mov    (%ebx),%edx
  8011b3:	8d 42 01             	lea    0x1(%edx),%eax
  8011b6:	89 03                	mov    %eax,(%ebx)
  8011b8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011bb:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8011bf:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011c4:	74 08                	je     8011ce <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011c6:	ff 43 04             	incl   0x4(%ebx)
}
  8011c9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011cc:	c9                   	leave  
  8011cd:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011ce:	83 ec 08             	sub    $0x8,%esp
  8011d1:	68 ff 00 00 00       	push   $0xff
  8011d6:	8d 43 08             	lea    0x8(%ebx),%eax
  8011d9:	50                   	push   %eax
  8011da:	e8 ec ee ff ff       	call   8000cb <sys_cputs>
		b->idx = 0;
  8011df:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011e5:	83 c4 10             	add    $0x10,%esp
  8011e8:	eb dc                	jmp    8011c6 <putch+0x1f>

008011ea <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011ea:	55                   	push   %ebp
  8011eb:	89 e5                	mov    %esp,%ebp
  8011ed:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011f3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011fa:	00 00 00 
	b.cnt = 0;
  8011fd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  801204:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  801207:	ff 75 0c             	pushl  0xc(%ebp)
  80120a:	ff 75 08             	pushl  0x8(%ebp)
  80120d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  801213:	50                   	push   %eax
  801214:	68 a7 11 80 00       	push   $0x8011a7
  801219:	e8 17 01 00 00       	call   801335 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  80121e:	83 c4 08             	add    $0x8,%esp
  801221:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801227:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80122d:	50                   	push   %eax
  80122e:	e8 98 ee ff ff       	call   8000cb <sys_cputs>

	return b.cnt;
}
  801233:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <cprintf>:

int
cprintf(const char *fmt, ...)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
  80123e:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801241:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801244:	50                   	push   %eax
  801245:	ff 75 08             	pushl  0x8(%ebp)
  801248:	e8 9d ff ff ff       	call   8011ea <vcprintf>
	va_end(ap);

	return cnt;
}
  80124d:	c9                   	leave  
  80124e:	c3                   	ret    

0080124f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80124f:	55                   	push   %ebp
  801250:	89 e5                	mov    %esp,%ebp
  801252:	57                   	push   %edi
  801253:	56                   	push   %esi
  801254:	53                   	push   %ebx
  801255:	83 ec 1c             	sub    $0x1c,%esp
  801258:	89 c7                	mov    %eax,%edi
  80125a:	89 d6                	mov    %edx,%esi
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801265:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801268:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80126b:	bb 00 00 00 00       	mov    $0x0,%ebx
  801270:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801273:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801276:	39 d3                	cmp    %edx,%ebx
  801278:	72 05                	jb     80127f <printnum+0x30>
  80127a:	39 45 10             	cmp    %eax,0x10(%ebp)
  80127d:	77 78                	ja     8012f7 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80127f:	83 ec 0c             	sub    $0xc,%esp
  801282:	ff 75 18             	pushl  0x18(%ebp)
  801285:	8b 45 14             	mov    0x14(%ebp),%eax
  801288:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80128b:	53                   	push   %ebx
  80128c:	ff 75 10             	pushl  0x10(%ebp)
  80128f:	83 ec 08             	sub    $0x8,%esp
  801292:	ff 75 e4             	pushl  -0x1c(%ebp)
  801295:	ff 75 e0             	pushl  -0x20(%ebp)
  801298:	ff 75 dc             	pushl  -0x24(%ebp)
  80129b:	ff 75 d8             	pushl  -0x28(%ebp)
  80129e:	e8 25 0a 00 00       	call   801cc8 <__udivdi3>
  8012a3:	83 c4 18             	add    $0x18,%esp
  8012a6:	52                   	push   %edx
  8012a7:	50                   	push   %eax
  8012a8:	89 f2                	mov    %esi,%edx
  8012aa:	89 f8                	mov    %edi,%eax
  8012ac:	e8 9e ff ff ff       	call   80124f <printnum>
  8012b1:	83 c4 20             	add    $0x20,%esp
  8012b4:	eb 11                	jmp    8012c7 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8012b6:	83 ec 08             	sub    $0x8,%esp
  8012b9:	56                   	push   %esi
  8012ba:	ff 75 18             	pushl  0x18(%ebp)
  8012bd:	ff d7                	call   *%edi
  8012bf:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8012c2:	4b                   	dec    %ebx
  8012c3:	85 db                	test   %ebx,%ebx
  8012c5:	7f ef                	jg     8012b6 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012c7:	83 ec 08             	sub    $0x8,%esp
  8012ca:	56                   	push   %esi
  8012cb:	83 ec 04             	sub    $0x4,%esp
  8012ce:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012d1:	ff 75 e0             	pushl  -0x20(%ebp)
  8012d4:	ff 75 dc             	pushl  -0x24(%ebp)
  8012d7:	ff 75 d8             	pushl  -0x28(%ebp)
  8012da:	e8 f9 0a 00 00       	call   801dd8 <__umoddi3>
  8012df:	83 c4 14             	add    $0x14,%esp
  8012e2:	0f be 80 67 20 80 00 	movsbl 0x802067(%eax),%eax
  8012e9:	50                   	push   %eax
  8012ea:	ff d7                	call   *%edi
}
  8012ec:	83 c4 10             	add    $0x10,%esp
  8012ef:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012f2:	5b                   	pop    %ebx
  8012f3:	5e                   	pop    %esi
  8012f4:	5f                   	pop    %edi
  8012f5:	5d                   	pop    %ebp
  8012f6:	c3                   	ret    
  8012f7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012fa:	eb c6                	jmp    8012c2 <printnum+0x73>

008012fc <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012fc:	55                   	push   %ebp
  8012fd:	89 e5                	mov    %esp,%ebp
  8012ff:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  801302:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  801305:	8b 10                	mov    (%eax),%edx
  801307:	3b 50 04             	cmp    0x4(%eax),%edx
  80130a:	73 0a                	jae    801316 <sprintputch+0x1a>
		*b->buf++ = ch;
  80130c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80130f:	89 08                	mov    %ecx,(%eax)
  801311:	8b 45 08             	mov    0x8(%ebp),%eax
  801314:	88 02                	mov    %al,(%edx)
}
  801316:	5d                   	pop    %ebp
  801317:	c3                   	ret    

00801318 <printfmt>:
{
  801318:	55                   	push   %ebp
  801319:	89 e5                	mov    %esp,%ebp
  80131b:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  80131e:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801321:	50                   	push   %eax
  801322:	ff 75 10             	pushl  0x10(%ebp)
  801325:	ff 75 0c             	pushl  0xc(%ebp)
  801328:	ff 75 08             	pushl  0x8(%ebp)
  80132b:	e8 05 00 00 00       	call   801335 <vprintfmt>
}
  801330:	83 c4 10             	add    $0x10,%esp
  801333:	c9                   	leave  
  801334:	c3                   	ret    

00801335 <vprintfmt>:
{
  801335:	55                   	push   %ebp
  801336:	89 e5                	mov    %esp,%ebp
  801338:	57                   	push   %edi
  801339:	56                   	push   %esi
  80133a:	53                   	push   %ebx
  80133b:	83 ec 2c             	sub    $0x2c,%esp
  80133e:	8b 75 08             	mov    0x8(%ebp),%esi
  801341:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801344:	8b 7d 10             	mov    0x10(%ebp),%edi
  801347:	e9 ae 03 00 00       	jmp    8016fa <vprintfmt+0x3c5>
  80134c:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801350:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801357:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80135e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801365:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80136a:	8d 47 01             	lea    0x1(%edi),%eax
  80136d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801370:	8a 17                	mov    (%edi),%dl
  801372:	8d 42 dd             	lea    -0x23(%edx),%eax
  801375:	3c 55                	cmp    $0x55,%al
  801377:	0f 87 fe 03 00 00    	ja     80177b <vprintfmt+0x446>
  80137d:	0f b6 c0             	movzbl %al,%eax
  801380:	ff 24 85 a0 21 80 00 	jmp    *0x8021a0(,%eax,4)
  801387:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80138a:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80138e:	eb da                	jmp    80136a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801390:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801393:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801397:	eb d1                	jmp    80136a <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801399:	0f b6 d2             	movzbl %dl,%edx
  80139c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80139f:	b8 00 00 00 00       	mov    $0x0,%eax
  8013a4:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  8013a7:	8d 04 80             	lea    (%eax,%eax,4),%eax
  8013aa:	01 c0                	add    %eax,%eax
  8013ac:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  8013b0:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  8013b3:	8d 4a d0             	lea    -0x30(%edx),%ecx
  8013b6:	83 f9 09             	cmp    $0x9,%ecx
  8013b9:	77 52                	ja     80140d <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8013bb:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8013bc:	eb e9                	jmp    8013a7 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8013be:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c1:	8b 00                	mov    (%eax),%eax
  8013c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c9:	8d 40 04             	lea    0x4(%eax),%eax
  8013cc:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d6:	79 92                	jns    80136a <vprintfmt+0x35>
				width = precision, precision = -1;
  8013d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013db:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013de:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013e5:	eb 83                	jmp    80136a <vprintfmt+0x35>
  8013e7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013eb:	78 08                	js     8013f5 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013ed:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013f0:	e9 75 ff ff ff       	jmp    80136a <vprintfmt+0x35>
  8013f5:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013fc:	eb ef                	jmp    8013ed <vprintfmt+0xb8>
  8013fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  801401:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  801408:	e9 5d ff ff ff       	jmp    80136a <vprintfmt+0x35>
  80140d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  801410:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801413:	eb bd                	jmp    8013d2 <vprintfmt+0x9d>
			lflag++;
  801415:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  801416:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  801419:	e9 4c ff ff ff       	jmp    80136a <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  80141e:	8b 45 14             	mov    0x14(%ebp),%eax
  801421:	8d 78 04             	lea    0x4(%eax),%edi
  801424:	83 ec 08             	sub    $0x8,%esp
  801427:	53                   	push   %ebx
  801428:	ff 30                	pushl  (%eax)
  80142a:	ff d6                	call   *%esi
			break;
  80142c:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80142f:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801432:	e9 c0 02 00 00       	jmp    8016f7 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801437:	8b 45 14             	mov    0x14(%ebp),%eax
  80143a:	8d 78 04             	lea    0x4(%eax),%edi
  80143d:	8b 00                	mov    (%eax),%eax
  80143f:	85 c0                	test   %eax,%eax
  801441:	78 2a                	js     80146d <vprintfmt+0x138>
  801443:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801445:	83 f8 0f             	cmp    $0xf,%eax
  801448:	7f 27                	jg     801471 <vprintfmt+0x13c>
  80144a:	8b 04 85 00 23 80 00 	mov    0x802300(,%eax,4),%eax
  801451:	85 c0                	test   %eax,%eax
  801453:	74 1c                	je     801471 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  801455:	50                   	push   %eax
  801456:	68 fd 1f 80 00       	push   $0x801ffd
  80145b:	53                   	push   %ebx
  80145c:	56                   	push   %esi
  80145d:	e8 b6 fe ff ff       	call   801318 <printfmt>
  801462:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801465:	89 7d 14             	mov    %edi,0x14(%ebp)
  801468:	e9 8a 02 00 00       	jmp    8016f7 <vprintfmt+0x3c2>
  80146d:	f7 d8                	neg    %eax
  80146f:	eb d2                	jmp    801443 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801471:	52                   	push   %edx
  801472:	68 7f 20 80 00       	push   $0x80207f
  801477:	53                   	push   %ebx
  801478:	56                   	push   %esi
  801479:	e8 9a fe ff ff       	call   801318 <printfmt>
  80147e:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801481:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801484:	e9 6e 02 00 00       	jmp    8016f7 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801489:	8b 45 14             	mov    0x14(%ebp),%eax
  80148c:	83 c0 04             	add    $0x4,%eax
  80148f:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801492:	8b 45 14             	mov    0x14(%ebp),%eax
  801495:	8b 38                	mov    (%eax),%edi
  801497:	85 ff                	test   %edi,%edi
  801499:	74 39                	je     8014d4 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  80149b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80149f:	0f 8e a9 00 00 00    	jle    80154e <vprintfmt+0x219>
  8014a5:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  8014a9:	0f 84 a7 00 00 00    	je     801556 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  8014af:	83 ec 08             	sub    $0x8,%esp
  8014b2:	ff 75 d0             	pushl  -0x30(%ebp)
  8014b5:	57                   	push   %edi
  8014b6:	e8 6b 03 00 00       	call   801826 <strnlen>
  8014bb:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014be:	29 c1                	sub    %eax,%ecx
  8014c0:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014c3:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014c6:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014cd:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014d0:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014d2:	eb 14                	jmp    8014e8 <vprintfmt+0x1b3>
				p = "(null)";
  8014d4:	bf 78 20 80 00       	mov    $0x802078,%edi
  8014d9:	eb c0                	jmp    80149b <vprintfmt+0x166>
					putch(padc, putdat);
  8014db:	83 ec 08             	sub    $0x8,%esp
  8014de:	53                   	push   %ebx
  8014df:	ff 75 e0             	pushl  -0x20(%ebp)
  8014e2:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014e4:	4f                   	dec    %edi
  8014e5:	83 c4 10             	add    $0x10,%esp
  8014e8:	85 ff                	test   %edi,%edi
  8014ea:	7f ef                	jg     8014db <vprintfmt+0x1a6>
  8014ec:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014ef:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014f2:	89 c8                	mov    %ecx,%eax
  8014f4:	85 c9                	test   %ecx,%ecx
  8014f6:	78 10                	js     801508 <vprintfmt+0x1d3>
  8014f8:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014fb:	29 c1                	sub    %eax,%ecx
  8014fd:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801500:	89 75 08             	mov    %esi,0x8(%ebp)
  801503:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801506:	eb 15                	jmp    80151d <vprintfmt+0x1e8>
  801508:	b8 00 00 00 00       	mov    $0x0,%eax
  80150d:	eb e9                	jmp    8014f8 <vprintfmt+0x1c3>
					putch(ch, putdat);
  80150f:	83 ec 08             	sub    $0x8,%esp
  801512:	53                   	push   %ebx
  801513:	52                   	push   %edx
  801514:	ff 55 08             	call   *0x8(%ebp)
  801517:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80151a:	ff 4d e0             	decl   -0x20(%ebp)
  80151d:	47                   	inc    %edi
  80151e:	8a 47 ff             	mov    -0x1(%edi),%al
  801521:	0f be d0             	movsbl %al,%edx
  801524:	85 d2                	test   %edx,%edx
  801526:	74 59                	je     801581 <vprintfmt+0x24c>
  801528:	85 f6                	test   %esi,%esi
  80152a:	78 03                	js     80152f <vprintfmt+0x1fa>
  80152c:	4e                   	dec    %esi
  80152d:	78 2f                	js     80155e <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80152f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801533:	74 da                	je     80150f <vprintfmt+0x1da>
  801535:	0f be c0             	movsbl %al,%eax
  801538:	83 e8 20             	sub    $0x20,%eax
  80153b:	83 f8 5e             	cmp    $0x5e,%eax
  80153e:	76 cf                	jbe    80150f <vprintfmt+0x1da>
					putch('?', putdat);
  801540:	83 ec 08             	sub    $0x8,%esp
  801543:	53                   	push   %ebx
  801544:	6a 3f                	push   $0x3f
  801546:	ff 55 08             	call   *0x8(%ebp)
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	eb cc                	jmp    80151a <vprintfmt+0x1e5>
  80154e:	89 75 08             	mov    %esi,0x8(%ebp)
  801551:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801554:	eb c7                	jmp    80151d <vprintfmt+0x1e8>
  801556:	89 75 08             	mov    %esi,0x8(%ebp)
  801559:	8b 75 d0             	mov    -0x30(%ebp),%esi
  80155c:	eb bf                	jmp    80151d <vprintfmt+0x1e8>
  80155e:	8b 75 08             	mov    0x8(%ebp),%esi
  801561:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801564:	eb 0c                	jmp    801572 <vprintfmt+0x23d>
				putch(' ', putdat);
  801566:	83 ec 08             	sub    $0x8,%esp
  801569:	53                   	push   %ebx
  80156a:	6a 20                	push   $0x20
  80156c:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80156e:	4f                   	dec    %edi
  80156f:	83 c4 10             	add    $0x10,%esp
  801572:	85 ff                	test   %edi,%edi
  801574:	7f f0                	jg     801566 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  801576:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801579:	89 45 14             	mov    %eax,0x14(%ebp)
  80157c:	e9 76 01 00 00       	jmp    8016f7 <vprintfmt+0x3c2>
  801581:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801584:	8b 75 08             	mov    0x8(%ebp),%esi
  801587:	eb e9                	jmp    801572 <vprintfmt+0x23d>
	if (lflag >= 2)
  801589:	83 f9 01             	cmp    $0x1,%ecx
  80158c:	7f 1f                	jg     8015ad <vprintfmt+0x278>
	else if (lflag)
  80158e:	85 c9                	test   %ecx,%ecx
  801590:	75 48                	jne    8015da <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801592:	8b 45 14             	mov    0x14(%ebp),%eax
  801595:	8b 00                	mov    (%eax),%eax
  801597:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159a:	89 c1                	mov    %eax,%ecx
  80159c:	c1 f9 1f             	sar    $0x1f,%ecx
  80159f:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a5:	8d 40 04             	lea    0x4(%eax),%eax
  8015a8:	89 45 14             	mov    %eax,0x14(%ebp)
  8015ab:	eb 17                	jmp    8015c4 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  8015ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8015b0:	8b 50 04             	mov    0x4(%eax),%edx
  8015b3:	8b 00                	mov    (%eax),%eax
  8015b5:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015b8:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8015be:	8d 40 08             	lea    0x8(%eax),%eax
  8015c1:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015c4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015c7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015ca:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015ce:	78 25                	js     8015f5 <vprintfmt+0x2c0>
			base = 10;
  8015d0:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015d5:	e9 03 01 00 00       	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015da:	8b 45 14             	mov    0x14(%ebp),%eax
  8015dd:	8b 00                	mov    (%eax),%eax
  8015df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015e2:	89 c1                	mov    %eax,%ecx
  8015e4:	c1 f9 1f             	sar    $0x1f,%ecx
  8015e7:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ed:	8d 40 04             	lea    0x4(%eax),%eax
  8015f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8015f3:	eb cf                	jmp    8015c4 <vprintfmt+0x28f>
				putch('-', putdat);
  8015f5:	83 ec 08             	sub    $0x8,%esp
  8015f8:	53                   	push   %ebx
  8015f9:	6a 2d                	push   $0x2d
  8015fb:	ff d6                	call   *%esi
				num = -(long long) num;
  8015fd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801600:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801603:	f7 da                	neg    %edx
  801605:	83 d1 00             	adc    $0x0,%ecx
  801608:	f7 d9                	neg    %ecx
  80160a:	83 c4 10             	add    $0x10,%esp
			base = 10;
  80160d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801612:	e9 c6 00 00 00       	jmp    8016dd <vprintfmt+0x3a8>
	if (lflag >= 2)
  801617:	83 f9 01             	cmp    $0x1,%ecx
  80161a:	7f 1e                	jg     80163a <vprintfmt+0x305>
	else if (lflag)
  80161c:	85 c9                	test   %ecx,%ecx
  80161e:	75 32                	jne    801652 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801620:	8b 45 14             	mov    0x14(%ebp),%eax
  801623:	8b 10                	mov    (%eax),%edx
  801625:	b9 00 00 00 00       	mov    $0x0,%ecx
  80162a:	8d 40 04             	lea    0x4(%eax),%eax
  80162d:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801630:	b8 0a 00 00 00       	mov    $0xa,%eax
  801635:	e9 a3 00 00 00       	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80163a:	8b 45 14             	mov    0x14(%ebp),%eax
  80163d:	8b 10                	mov    (%eax),%edx
  80163f:	8b 48 04             	mov    0x4(%eax),%ecx
  801642:	8d 40 08             	lea    0x8(%eax),%eax
  801645:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801648:	b8 0a 00 00 00       	mov    $0xa,%eax
  80164d:	e9 8b 00 00 00       	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801652:	8b 45 14             	mov    0x14(%ebp),%eax
  801655:	8b 10                	mov    (%eax),%edx
  801657:	b9 00 00 00 00       	mov    $0x0,%ecx
  80165c:	8d 40 04             	lea    0x4(%eax),%eax
  80165f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801662:	b8 0a 00 00 00       	mov    $0xa,%eax
  801667:	eb 74                	jmp    8016dd <vprintfmt+0x3a8>
	if (lflag >= 2)
  801669:	83 f9 01             	cmp    $0x1,%ecx
  80166c:	7f 1b                	jg     801689 <vprintfmt+0x354>
	else if (lflag)
  80166e:	85 c9                	test   %ecx,%ecx
  801670:	75 2c                	jne    80169e <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801672:	8b 45 14             	mov    0x14(%ebp),%eax
  801675:	8b 10                	mov    (%eax),%edx
  801677:	b9 00 00 00 00       	mov    $0x0,%ecx
  80167c:	8d 40 04             	lea    0x4(%eax),%eax
  80167f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801682:	b8 08 00 00 00       	mov    $0x8,%eax
  801687:	eb 54                	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801689:	8b 45 14             	mov    0x14(%ebp),%eax
  80168c:	8b 10                	mov    (%eax),%edx
  80168e:	8b 48 04             	mov    0x4(%eax),%ecx
  801691:	8d 40 08             	lea    0x8(%eax),%eax
  801694:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801697:	b8 08 00 00 00       	mov    $0x8,%eax
  80169c:	eb 3f                	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80169e:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a1:	8b 10                	mov    (%eax),%edx
  8016a3:	b9 00 00 00 00       	mov    $0x0,%ecx
  8016a8:	8d 40 04             	lea    0x4(%eax),%eax
  8016ab:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  8016ae:	b8 08 00 00 00       	mov    $0x8,%eax
  8016b3:	eb 28                	jmp    8016dd <vprintfmt+0x3a8>
			putch('0', putdat);
  8016b5:	83 ec 08             	sub    $0x8,%esp
  8016b8:	53                   	push   %ebx
  8016b9:	6a 30                	push   $0x30
  8016bb:	ff d6                	call   *%esi
			putch('x', putdat);
  8016bd:	83 c4 08             	add    $0x8,%esp
  8016c0:	53                   	push   %ebx
  8016c1:	6a 78                	push   $0x78
  8016c3:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8016c8:	8b 10                	mov    (%eax),%edx
  8016ca:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016cf:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016d2:	8d 40 04             	lea    0x4(%eax),%eax
  8016d5:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016d8:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016dd:	83 ec 0c             	sub    $0xc,%esp
  8016e0:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016e4:	57                   	push   %edi
  8016e5:	ff 75 e0             	pushl  -0x20(%ebp)
  8016e8:	50                   	push   %eax
  8016e9:	51                   	push   %ecx
  8016ea:	52                   	push   %edx
  8016eb:	89 da                	mov    %ebx,%edx
  8016ed:	89 f0                	mov    %esi,%eax
  8016ef:	e8 5b fb ff ff       	call   80124f <printnum>
			break;
  8016f4:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016f7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016fa:	47                   	inc    %edi
  8016fb:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016ff:	83 f8 25             	cmp    $0x25,%eax
  801702:	0f 84 44 fc ff ff    	je     80134c <vprintfmt+0x17>
			if (ch == '\0')
  801708:	85 c0                	test   %eax,%eax
  80170a:	0f 84 89 00 00 00    	je     801799 <vprintfmt+0x464>
			putch(ch, putdat);
  801710:	83 ec 08             	sub    $0x8,%esp
  801713:	53                   	push   %ebx
  801714:	50                   	push   %eax
  801715:	ff d6                	call   *%esi
  801717:	83 c4 10             	add    $0x10,%esp
  80171a:	eb de                	jmp    8016fa <vprintfmt+0x3c5>
	if (lflag >= 2)
  80171c:	83 f9 01             	cmp    $0x1,%ecx
  80171f:	7f 1b                	jg     80173c <vprintfmt+0x407>
	else if (lflag)
  801721:	85 c9                	test   %ecx,%ecx
  801723:	75 2c                	jne    801751 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801725:	8b 45 14             	mov    0x14(%ebp),%eax
  801728:	8b 10                	mov    (%eax),%edx
  80172a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80172f:	8d 40 04             	lea    0x4(%eax),%eax
  801732:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801735:	b8 10 00 00 00       	mov    $0x10,%eax
  80173a:	eb a1                	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80173c:	8b 45 14             	mov    0x14(%ebp),%eax
  80173f:	8b 10                	mov    (%eax),%edx
  801741:	8b 48 04             	mov    0x4(%eax),%ecx
  801744:	8d 40 08             	lea    0x8(%eax),%eax
  801747:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80174a:	b8 10 00 00 00       	mov    $0x10,%eax
  80174f:	eb 8c                	jmp    8016dd <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801751:	8b 45 14             	mov    0x14(%ebp),%eax
  801754:	8b 10                	mov    (%eax),%edx
  801756:	b9 00 00 00 00       	mov    $0x0,%ecx
  80175b:	8d 40 04             	lea    0x4(%eax),%eax
  80175e:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801761:	b8 10 00 00 00       	mov    $0x10,%eax
  801766:	e9 72 ff ff ff       	jmp    8016dd <vprintfmt+0x3a8>
			putch(ch, putdat);
  80176b:	83 ec 08             	sub    $0x8,%esp
  80176e:	53                   	push   %ebx
  80176f:	6a 25                	push   $0x25
  801771:	ff d6                	call   *%esi
			break;
  801773:	83 c4 10             	add    $0x10,%esp
  801776:	e9 7c ff ff ff       	jmp    8016f7 <vprintfmt+0x3c2>
			putch('%', putdat);
  80177b:	83 ec 08             	sub    $0x8,%esp
  80177e:	53                   	push   %ebx
  80177f:	6a 25                	push   $0x25
  801781:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801783:	83 c4 10             	add    $0x10,%esp
  801786:	89 f8                	mov    %edi,%eax
  801788:	eb 01                	jmp    80178b <vprintfmt+0x456>
  80178a:	48                   	dec    %eax
  80178b:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80178f:	75 f9                	jne    80178a <vprintfmt+0x455>
  801791:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801794:	e9 5e ff ff ff       	jmp    8016f7 <vprintfmt+0x3c2>
}
  801799:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80179c:	5b                   	pop    %ebx
  80179d:	5e                   	pop    %esi
  80179e:	5f                   	pop    %edi
  80179f:	5d                   	pop    %ebp
  8017a0:	c3                   	ret    

008017a1 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  8017a1:	55                   	push   %ebp
  8017a2:	89 e5                	mov    %esp,%ebp
  8017a4:	83 ec 18             	sub    $0x18,%esp
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  8017ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b0:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  8017b4:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  8017b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017be:	85 c0                	test   %eax,%eax
  8017c0:	74 26                	je     8017e8 <vsnprintf+0x47>
  8017c2:	85 d2                	test   %edx,%edx
  8017c4:	7e 29                	jle    8017ef <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017c6:	ff 75 14             	pushl  0x14(%ebp)
  8017c9:	ff 75 10             	pushl  0x10(%ebp)
  8017cc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017cf:	50                   	push   %eax
  8017d0:	68 fc 12 80 00       	push   $0x8012fc
  8017d5:	e8 5b fb ff ff       	call   801335 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dd:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017e3:	83 c4 10             	add    $0x10,%esp
}
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    
		return -E_INVAL;
  8017e8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ed:	eb f7                	jmp    8017e6 <vsnprintf+0x45>
  8017ef:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017f4:	eb f0                	jmp    8017e6 <vsnprintf+0x45>

008017f6 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017f6:	55                   	push   %ebp
  8017f7:	89 e5                	mov    %esp,%ebp
  8017f9:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017fc:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017ff:	50                   	push   %eax
  801800:	ff 75 10             	pushl  0x10(%ebp)
  801803:	ff 75 0c             	pushl  0xc(%ebp)
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 93 ff ff ff       	call   8017a1 <vsnprintf>
	va_end(ap);

	return rc;
}
  80180e:	c9                   	leave  
  80180f:	c3                   	ret    

00801810 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  801816:	b8 00 00 00 00       	mov    $0x0,%eax
  80181b:	eb 01                	jmp    80181e <strlen+0xe>
		n++;
  80181d:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  80181e:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801822:	75 f9                	jne    80181d <strlen+0xd>
	return n;
}
  801824:	5d                   	pop    %ebp
  801825:	c3                   	ret    

00801826 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80182c:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb 01                	jmp    801837 <strnlen+0x11>
		n++;
  801836:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801837:	39 d0                	cmp    %edx,%eax
  801839:	74 06                	je     801841 <strnlen+0x1b>
  80183b:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80183f:	75 f5                	jne    801836 <strnlen+0x10>
	return n;
}
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80184d:	89 c2                	mov    %eax,%edx
  80184f:	42                   	inc    %edx
  801850:	41                   	inc    %ecx
  801851:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801854:	88 5a ff             	mov    %bl,-0x1(%edx)
  801857:	84 db                	test   %bl,%bl
  801859:	75 f4                	jne    80184f <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  80185b:	5b                   	pop    %ebx
  80185c:	5d                   	pop    %ebp
  80185d:	c3                   	ret    

0080185e <strcat>:

char *
strcat(char *dst, const char *src)
{
  80185e:	55                   	push   %ebp
  80185f:	89 e5                	mov    %esp,%ebp
  801861:	53                   	push   %ebx
  801862:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801865:	53                   	push   %ebx
  801866:	e8 a5 ff ff ff       	call   801810 <strlen>
  80186b:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80186e:	ff 75 0c             	pushl  0xc(%ebp)
  801871:	01 d8                	add    %ebx,%eax
  801873:	50                   	push   %eax
  801874:	e8 ca ff ff ff       	call   801843 <strcpy>
	return dst;
}
  801879:	89 d8                	mov    %ebx,%eax
  80187b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80187e:	c9                   	leave  
  80187f:	c3                   	ret    

00801880 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801880:	55                   	push   %ebp
  801881:	89 e5                	mov    %esp,%ebp
  801883:	56                   	push   %esi
  801884:	53                   	push   %ebx
  801885:	8b 75 08             	mov    0x8(%ebp),%esi
  801888:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80188b:	89 f3                	mov    %esi,%ebx
  80188d:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801890:	89 f2                	mov    %esi,%edx
  801892:	eb 0c                	jmp    8018a0 <strncpy+0x20>
		*dst++ = *src;
  801894:	42                   	inc    %edx
  801895:	8a 01                	mov    (%ecx),%al
  801897:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80189a:	80 39 01             	cmpb   $0x1,(%ecx)
  80189d:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  8018a0:	39 da                	cmp    %ebx,%edx
  8018a2:	75 f0                	jne    801894 <strncpy+0x14>
	}
	return ret;
}
  8018a4:	89 f0                	mov    %esi,%eax
  8018a6:	5b                   	pop    %ebx
  8018a7:	5e                   	pop    %esi
  8018a8:	5d                   	pop    %ebp
  8018a9:	c3                   	ret    

008018aa <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  8018aa:	55                   	push   %ebp
  8018ab:	89 e5                	mov    %esp,%ebp
  8018ad:	56                   	push   %esi
  8018ae:	53                   	push   %ebx
  8018af:	8b 75 08             	mov    0x8(%ebp),%esi
  8018b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  8018b8:	85 c0                	test   %eax,%eax
  8018ba:	74 20                	je     8018dc <strlcpy+0x32>
  8018bc:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8018c0:	89 f0                	mov    %esi,%eax
  8018c2:	eb 05                	jmp    8018c9 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018c4:	40                   	inc    %eax
  8018c5:	42                   	inc    %edx
  8018c6:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018c9:	39 d8                	cmp    %ebx,%eax
  8018cb:	74 06                	je     8018d3 <strlcpy+0x29>
  8018cd:	8a 0a                	mov    (%edx),%cl
  8018cf:	84 c9                	test   %cl,%cl
  8018d1:	75 f1                	jne    8018c4 <strlcpy+0x1a>
		*dst = '\0';
  8018d3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018d6:	29 f0                	sub    %esi,%eax
}
  8018d8:	5b                   	pop    %ebx
  8018d9:	5e                   	pop    %esi
  8018da:	5d                   	pop    %ebp
  8018db:	c3                   	ret    
  8018dc:	89 f0                	mov    %esi,%eax
  8018de:	eb f6                	jmp    8018d6 <strlcpy+0x2c>

008018e0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018e9:	eb 02                	jmp    8018ed <strcmp+0xd>
		p++, q++;
  8018eb:	41                   	inc    %ecx
  8018ec:	42                   	inc    %edx
	while (*p && *p == *q)
  8018ed:	8a 01                	mov    (%ecx),%al
  8018ef:	84 c0                	test   %al,%al
  8018f1:	74 04                	je     8018f7 <strcmp+0x17>
  8018f3:	3a 02                	cmp    (%edx),%al
  8018f5:	74 f4                	je     8018eb <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018f7:	0f b6 c0             	movzbl %al,%eax
  8018fa:	0f b6 12             	movzbl (%edx),%edx
  8018fd:	29 d0                	sub    %edx,%eax
}
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	53                   	push   %ebx
  801905:	8b 45 08             	mov    0x8(%ebp),%eax
  801908:	8b 55 0c             	mov    0xc(%ebp),%edx
  80190b:	89 c3                	mov    %eax,%ebx
  80190d:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  801910:	eb 02                	jmp    801914 <strncmp+0x13>
		n--, p++, q++;
  801912:	40                   	inc    %eax
  801913:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  801914:	39 d8                	cmp    %ebx,%eax
  801916:	74 15                	je     80192d <strncmp+0x2c>
  801918:	8a 08                	mov    (%eax),%cl
  80191a:	84 c9                	test   %cl,%cl
  80191c:	74 04                	je     801922 <strncmp+0x21>
  80191e:	3a 0a                	cmp    (%edx),%cl
  801920:	74 f0                	je     801912 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801922:	0f b6 00             	movzbl (%eax),%eax
  801925:	0f b6 12             	movzbl (%edx),%edx
  801928:	29 d0                	sub    %edx,%eax
}
  80192a:	5b                   	pop    %ebx
  80192b:	5d                   	pop    %ebp
  80192c:	c3                   	ret    
		return 0;
  80192d:	b8 00 00 00 00       	mov    $0x0,%eax
  801932:	eb f6                	jmp    80192a <strncmp+0x29>

00801934 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	8b 45 08             	mov    0x8(%ebp),%eax
  80193a:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80193d:	8a 10                	mov    (%eax),%dl
  80193f:	84 d2                	test   %dl,%dl
  801941:	74 07                	je     80194a <strchr+0x16>
		if (*s == c)
  801943:	38 ca                	cmp    %cl,%dl
  801945:	74 08                	je     80194f <strchr+0x1b>
	for (; *s; s++)
  801947:	40                   	inc    %eax
  801948:	eb f3                	jmp    80193d <strchr+0x9>
			return (char *) s;
	return 0;
  80194a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80194f:	5d                   	pop    %ebp
  801950:	c3                   	ret    

00801951 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801951:	55                   	push   %ebp
  801952:	89 e5                	mov    %esp,%ebp
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80195a:	8a 10                	mov    (%eax),%dl
  80195c:	84 d2                	test   %dl,%dl
  80195e:	74 07                	je     801967 <strfind+0x16>
		if (*s == c)
  801960:	38 ca                	cmp    %cl,%dl
  801962:	74 03                	je     801967 <strfind+0x16>
	for (; *s; s++)
  801964:	40                   	inc    %eax
  801965:	eb f3                	jmp    80195a <strfind+0x9>
			break;
	return (char *) s;
}
  801967:	5d                   	pop    %ebp
  801968:	c3                   	ret    

00801969 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801969:	55                   	push   %ebp
  80196a:	89 e5                	mov    %esp,%ebp
  80196c:	57                   	push   %edi
  80196d:	56                   	push   %esi
  80196e:	53                   	push   %ebx
  80196f:	8b 7d 08             	mov    0x8(%ebp),%edi
  801972:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801975:	85 c9                	test   %ecx,%ecx
  801977:	74 13                	je     80198c <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801979:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80197f:	75 05                	jne    801986 <memset+0x1d>
  801981:	f6 c1 03             	test   $0x3,%cl
  801984:	74 0d                	je     801993 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801986:	8b 45 0c             	mov    0xc(%ebp),%eax
  801989:	fc                   	cld    
  80198a:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  80198c:	89 f8                	mov    %edi,%eax
  80198e:	5b                   	pop    %ebx
  80198f:	5e                   	pop    %esi
  801990:	5f                   	pop    %edi
  801991:	5d                   	pop    %ebp
  801992:	c3                   	ret    
		c &= 0xFF;
  801993:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801997:	89 d3                	mov    %edx,%ebx
  801999:	c1 e3 08             	shl    $0x8,%ebx
  80199c:	89 d0                	mov    %edx,%eax
  80199e:	c1 e0 18             	shl    $0x18,%eax
  8019a1:	89 d6                	mov    %edx,%esi
  8019a3:	c1 e6 10             	shl    $0x10,%esi
  8019a6:	09 f0                	or     %esi,%eax
  8019a8:	09 c2                	or     %eax,%edx
  8019aa:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  8019ac:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  8019af:	89 d0                	mov    %edx,%eax
  8019b1:	fc                   	cld    
  8019b2:	f3 ab                	rep stos %eax,%es:(%edi)
  8019b4:	eb d6                	jmp    80198c <memset+0x23>

008019b6 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  8019b6:	55                   	push   %ebp
  8019b7:	89 e5                	mov    %esp,%ebp
  8019b9:	57                   	push   %edi
  8019ba:	56                   	push   %esi
  8019bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019be:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019c1:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019c4:	39 c6                	cmp    %eax,%esi
  8019c6:	73 33                	jae    8019fb <memmove+0x45>
  8019c8:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019cb:	39 d0                	cmp    %edx,%eax
  8019cd:	73 2c                	jae    8019fb <memmove+0x45>
		s += n;
		d += n;
  8019cf:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d2:	89 d6                	mov    %edx,%esi
  8019d4:	09 fe                	or     %edi,%esi
  8019d6:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019dc:	75 13                	jne    8019f1 <memmove+0x3b>
  8019de:	f6 c1 03             	test   $0x3,%cl
  8019e1:	75 0e                	jne    8019f1 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019e3:	83 ef 04             	sub    $0x4,%edi
  8019e6:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019e9:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019ec:	fd                   	std    
  8019ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ef:	eb 07                	jmp    8019f8 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019f1:	4f                   	dec    %edi
  8019f2:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019f5:	fd                   	std    
  8019f6:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019f8:	fc                   	cld    
  8019f9:	eb 13                	jmp    801a0e <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019fb:	89 f2                	mov    %esi,%edx
  8019fd:	09 c2                	or     %eax,%edx
  8019ff:	f6 c2 03             	test   $0x3,%dl
  801a02:	75 05                	jne    801a09 <memmove+0x53>
  801a04:	f6 c1 03             	test   $0x3,%cl
  801a07:	74 09                	je     801a12 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  801a09:	89 c7                	mov    %eax,%edi
  801a0b:	fc                   	cld    
  801a0c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  801a0e:	5e                   	pop    %esi
  801a0f:	5f                   	pop    %edi
  801a10:	5d                   	pop    %ebp
  801a11:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  801a12:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  801a15:	89 c7                	mov    %eax,%edi
  801a17:	fc                   	cld    
  801a18:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801a1a:	eb f2                	jmp    801a0e <memmove+0x58>

00801a1c <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a1c:	55                   	push   %ebp
  801a1d:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801a1f:	ff 75 10             	pushl  0x10(%ebp)
  801a22:	ff 75 0c             	pushl  0xc(%ebp)
  801a25:	ff 75 08             	pushl  0x8(%ebp)
  801a28:	e8 89 ff ff ff       	call   8019b6 <memmove>
}
  801a2d:	c9                   	leave  
  801a2e:	c3                   	ret    

00801a2f <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a2f:	55                   	push   %ebp
  801a30:	89 e5                	mov    %esp,%ebp
  801a32:	56                   	push   %esi
  801a33:	53                   	push   %ebx
  801a34:	8b 45 08             	mov    0x8(%ebp),%eax
  801a37:	89 c6                	mov    %eax,%esi
  801a39:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a3c:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a3f:	39 f0                	cmp    %esi,%eax
  801a41:	74 16                	je     801a59 <memcmp+0x2a>
		if (*s1 != *s2)
  801a43:	8a 08                	mov    (%eax),%cl
  801a45:	8a 1a                	mov    (%edx),%bl
  801a47:	38 d9                	cmp    %bl,%cl
  801a49:	75 04                	jne    801a4f <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a4b:	40                   	inc    %eax
  801a4c:	42                   	inc    %edx
  801a4d:	eb f0                	jmp    801a3f <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a4f:	0f b6 c1             	movzbl %cl,%eax
  801a52:	0f b6 db             	movzbl %bl,%ebx
  801a55:	29 d8                	sub    %ebx,%eax
  801a57:	eb 05                	jmp    801a5e <memcmp+0x2f>
	}

	return 0;
  801a59:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5e:	5b                   	pop    %ebx
  801a5f:	5e                   	pop    %esi
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    

00801a62 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	8b 45 08             	mov    0x8(%ebp),%eax
  801a68:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a6b:	89 c2                	mov    %eax,%edx
  801a6d:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a70:	39 d0                	cmp    %edx,%eax
  801a72:	73 07                	jae    801a7b <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a74:	38 08                	cmp    %cl,(%eax)
  801a76:	74 03                	je     801a7b <memfind+0x19>
	for (; s < ends; s++)
  801a78:	40                   	inc    %eax
  801a79:	eb f5                	jmp    801a70 <memfind+0xe>
			break;
	return (void *) s;
}
  801a7b:	5d                   	pop    %ebp
  801a7c:	c3                   	ret    

00801a7d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a7d:	55                   	push   %ebp
  801a7e:	89 e5                	mov    %esp,%ebp
  801a80:	57                   	push   %edi
  801a81:	56                   	push   %esi
  801a82:	53                   	push   %ebx
  801a83:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a86:	eb 01                	jmp    801a89 <strtol+0xc>
		s++;
  801a88:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a89:	8a 01                	mov    (%ecx),%al
  801a8b:	3c 20                	cmp    $0x20,%al
  801a8d:	74 f9                	je     801a88 <strtol+0xb>
  801a8f:	3c 09                	cmp    $0x9,%al
  801a91:	74 f5                	je     801a88 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a93:	3c 2b                	cmp    $0x2b,%al
  801a95:	74 2b                	je     801ac2 <strtol+0x45>
		s++;
	else if (*s == '-')
  801a97:	3c 2d                	cmp    $0x2d,%al
  801a99:	74 2f                	je     801aca <strtol+0x4d>
	int neg = 0;
  801a9b:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aa0:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801aa7:	75 12                	jne    801abb <strtol+0x3e>
  801aa9:	80 39 30             	cmpb   $0x30,(%ecx)
  801aac:	74 24                	je     801ad2 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801aae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab2:	75 07                	jne    801abb <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801ab4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801abb:	b8 00 00 00 00       	mov    $0x0,%eax
  801ac0:	eb 4e                	jmp    801b10 <strtol+0x93>
		s++;
  801ac2:	41                   	inc    %ecx
	int neg = 0;
  801ac3:	bf 00 00 00 00       	mov    $0x0,%edi
  801ac8:	eb d6                	jmp    801aa0 <strtol+0x23>
		s++, neg = 1;
  801aca:	41                   	inc    %ecx
  801acb:	bf 01 00 00 00       	mov    $0x1,%edi
  801ad0:	eb ce                	jmp    801aa0 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ad2:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ad6:	74 10                	je     801ae8 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801ad8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801adc:	75 dd                	jne    801abb <strtol+0x3e>
		s++, base = 8;
  801ade:	41                   	inc    %ecx
  801adf:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ae6:	eb d3                	jmp    801abb <strtol+0x3e>
		s += 2, base = 16;
  801ae8:	83 c1 02             	add    $0x2,%ecx
  801aeb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801af2:	eb c7                	jmp    801abb <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801af4:	8d 72 9f             	lea    -0x61(%edx),%esi
  801af7:	89 f3                	mov    %esi,%ebx
  801af9:	80 fb 19             	cmp    $0x19,%bl
  801afc:	77 24                	ja     801b22 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801afe:	0f be d2             	movsbl %dl,%edx
  801b01:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801b04:	3b 55 10             	cmp    0x10(%ebp),%edx
  801b07:	7d 2b                	jge    801b34 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801b09:	41                   	inc    %ecx
  801b0a:	0f af 45 10          	imul   0x10(%ebp),%eax
  801b0e:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801b10:	8a 11                	mov    (%ecx),%dl
  801b12:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801b15:	80 fb 09             	cmp    $0x9,%bl
  801b18:	77 da                	ja     801af4 <strtol+0x77>
			dig = *s - '0';
  801b1a:	0f be d2             	movsbl %dl,%edx
  801b1d:	83 ea 30             	sub    $0x30,%edx
  801b20:	eb e2                	jmp    801b04 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801b22:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b25:	89 f3                	mov    %esi,%ebx
  801b27:	80 fb 19             	cmp    $0x19,%bl
  801b2a:	77 08                	ja     801b34 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b2c:	0f be d2             	movsbl %dl,%edx
  801b2f:	83 ea 37             	sub    $0x37,%edx
  801b32:	eb d0                	jmp    801b04 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b34:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b38:	74 05                	je     801b3f <strtol+0xc2>
		*endptr = (char *) s;
  801b3a:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b3d:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b3f:	85 ff                	test   %edi,%edi
  801b41:	74 02                	je     801b45 <strtol+0xc8>
  801b43:	f7 d8                	neg    %eax
}
  801b45:	5b                   	pop    %ebx
  801b46:	5e                   	pop    %esi
  801b47:	5f                   	pop    %edi
  801b48:	5d                   	pop    %ebp
  801b49:	c3                   	ret    

00801b4a <atoi>:

int
atoi(const char *s)
{
  801b4a:	55                   	push   %ebp
  801b4b:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b4d:	6a 0a                	push   $0xa
  801b4f:	6a 00                	push   $0x0
  801b51:	ff 75 08             	pushl  0x8(%ebp)
  801b54:	e8 24 ff ff ff       	call   801a7d <strtol>
}
  801b59:	c9                   	leave  
  801b5a:	c3                   	ret    

00801b5b <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b5b:	55                   	push   %ebp
  801b5c:	89 e5                	mov    %esp,%ebp
  801b5e:	57                   	push   %edi
  801b5f:	56                   	push   %esi
  801b60:	53                   	push   %ebx
  801b61:	83 ec 0c             	sub    $0xc,%esp
  801b64:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b67:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b6a:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b6d:	85 ff                	test   %edi,%edi
  801b6f:	74 53                	je     801bc4 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b71:	83 ec 0c             	sub    $0xc,%esp
  801b74:	57                   	push   %edi
  801b75:	e8 fe e7 ff ff       	call   800378 <sys_ipc_recv>
  801b7a:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b7d:	85 db                	test   %ebx,%ebx
  801b7f:	74 0b                	je     801b8c <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b81:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b87:	8b 52 74             	mov    0x74(%edx),%edx
  801b8a:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b8c:	85 f6                	test   %esi,%esi
  801b8e:	74 0f                	je     801b9f <ipc_recv+0x44>
  801b90:	85 ff                	test   %edi,%edi
  801b92:	74 0b                	je     801b9f <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b94:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b9a:	8b 52 78             	mov    0x78(%edx),%edx
  801b9d:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b9f:	85 c0                	test   %eax,%eax
  801ba1:	74 30                	je     801bd3 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801ba3:	85 db                	test   %ebx,%ebx
  801ba5:	74 06                	je     801bad <ipc_recv+0x52>
      		*from_env_store = 0;
  801ba7:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801bad:	85 f6                	test   %esi,%esi
  801baf:	74 2c                	je     801bdd <ipc_recv+0x82>
      		*perm_store = 0;
  801bb1:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801bb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801bbc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801bbf:	5b                   	pop    %ebx
  801bc0:	5e                   	pop    %esi
  801bc1:	5f                   	pop    %edi
  801bc2:	5d                   	pop    %ebp
  801bc3:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801bc4:	83 ec 0c             	sub    $0xc,%esp
  801bc7:	6a ff                	push   $0xffffffff
  801bc9:	e8 aa e7 ff ff       	call   800378 <sys_ipc_recv>
  801bce:	83 c4 10             	add    $0x10,%esp
  801bd1:	eb aa                	jmp    801b7d <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bd3:	a1 04 40 80 00       	mov    0x804004,%eax
  801bd8:	8b 40 70             	mov    0x70(%eax),%eax
  801bdb:	eb df                	jmp    801bbc <ipc_recv+0x61>
		return -1;
  801bdd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801be2:	eb d8                	jmp    801bbc <ipc_recv+0x61>

00801be4 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801be4:	55                   	push   %ebp
  801be5:	89 e5                	mov    %esp,%ebp
  801be7:	57                   	push   %edi
  801be8:	56                   	push   %esi
  801be9:	53                   	push   %ebx
  801bea:	83 ec 0c             	sub    $0xc,%esp
  801bed:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bf0:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bf3:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bf6:	85 db                	test   %ebx,%ebx
  801bf8:	75 22                	jne    801c1c <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bfa:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bff:	eb 1b                	jmp    801c1c <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c01:	68 60 23 80 00       	push   $0x802360
  801c06:	68 eb 1f 80 00       	push   $0x801feb
  801c0b:	6a 48                	push   $0x48
  801c0d:	68 84 23 80 00       	push   $0x802384
  801c12:	e8 11 f5 ff ff       	call   801128 <_panic>
		sys_yield();
  801c17:	e8 13 e6 ff ff       	call   80022f <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c1c:	57                   	push   %edi
  801c1d:	53                   	push   %ebx
  801c1e:	56                   	push   %esi
  801c1f:	ff 75 08             	pushl  0x8(%ebp)
  801c22:	e8 2e e7 ff ff       	call   800355 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c27:	83 c4 10             	add    $0x10,%esp
  801c2a:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c2d:	74 e8                	je     801c17 <ipc_send+0x33>
  801c2f:	85 c0                	test   %eax,%eax
  801c31:	75 ce                	jne    801c01 <ipc_send+0x1d>
		sys_yield();
  801c33:	e8 f7 e5 ff ff       	call   80022f <sys_yield>
		
	}
	
}
  801c38:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c3b:	5b                   	pop    %ebx
  801c3c:	5e                   	pop    %esi
  801c3d:	5f                   	pop    %edi
  801c3e:	5d                   	pop    %ebp
  801c3f:	c3                   	ret    

00801c40 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c40:	55                   	push   %ebp
  801c41:	89 e5                	mov    %esp,%ebp
  801c43:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c46:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c4b:	89 c2                	mov    %eax,%edx
  801c4d:	c1 e2 05             	shl    $0x5,%edx
  801c50:	29 c2                	sub    %eax,%edx
  801c52:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c59:	8b 52 50             	mov    0x50(%edx),%edx
  801c5c:	39 ca                	cmp    %ecx,%edx
  801c5e:	74 0f                	je     801c6f <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c60:	40                   	inc    %eax
  801c61:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c66:	75 e3                	jne    801c4b <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c68:	b8 00 00 00 00       	mov    $0x0,%eax
  801c6d:	eb 11                	jmp    801c80 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c6f:	89 c2                	mov    %eax,%edx
  801c71:	c1 e2 05             	shl    $0x5,%edx
  801c74:	29 c2                	sub    %eax,%edx
  801c76:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c7d:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c80:	5d                   	pop    %ebp
  801c81:	c3                   	ret    

00801c82 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c85:	8b 45 08             	mov    0x8(%ebp),%eax
  801c88:	c1 e8 16             	shr    $0x16,%eax
  801c8b:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c92:	a8 01                	test   $0x1,%al
  801c94:	74 21                	je     801cb7 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c96:	8b 45 08             	mov    0x8(%ebp),%eax
  801c99:	c1 e8 0c             	shr    $0xc,%eax
  801c9c:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801ca3:	a8 01                	test   $0x1,%al
  801ca5:	74 17                	je     801cbe <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801ca7:	c1 e8 0c             	shr    $0xc,%eax
  801caa:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801cb1:	ef 
  801cb2:	0f b7 c0             	movzwl %ax,%eax
  801cb5:	eb 05                	jmp    801cbc <pageref+0x3a>
		return 0;
  801cb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cbc:	5d                   	pop    %ebp
  801cbd:	c3                   	ret    
		return 0;
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	eb f7                	jmp    801cbc <pageref+0x3a>
  801cc5:	66 90                	xchg   %ax,%ax
  801cc7:	90                   	nop

00801cc8 <__udivdi3>:
  801cc8:	55                   	push   %ebp
  801cc9:	57                   	push   %edi
  801cca:	56                   	push   %esi
  801ccb:	53                   	push   %ebx
  801ccc:	83 ec 1c             	sub    $0x1c,%esp
  801ccf:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cd3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cd7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cdf:	89 ca                	mov    %ecx,%edx
  801ce1:	89 f8                	mov    %edi,%eax
  801ce3:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ce7:	85 f6                	test   %esi,%esi
  801ce9:	75 2d                	jne    801d18 <__udivdi3+0x50>
  801ceb:	39 cf                	cmp    %ecx,%edi
  801ced:	77 65                	ja     801d54 <__udivdi3+0x8c>
  801cef:	89 fd                	mov    %edi,%ebp
  801cf1:	85 ff                	test   %edi,%edi
  801cf3:	75 0b                	jne    801d00 <__udivdi3+0x38>
  801cf5:	b8 01 00 00 00       	mov    $0x1,%eax
  801cfa:	31 d2                	xor    %edx,%edx
  801cfc:	f7 f7                	div    %edi
  801cfe:	89 c5                	mov    %eax,%ebp
  801d00:	31 d2                	xor    %edx,%edx
  801d02:	89 c8                	mov    %ecx,%eax
  801d04:	f7 f5                	div    %ebp
  801d06:	89 c1                	mov    %eax,%ecx
  801d08:	89 d8                	mov    %ebx,%eax
  801d0a:	f7 f5                	div    %ebp
  801d0c:	89 cf                	mov    %ecx,%edi
  801d0e:	89 fa                	mov    %edi,%edx
  801d10:	83 c4 1c             	add    $0x1c,%esp
  801d13:	5b                   	pop    %ebx
  801d14:	5e                   	pop    %esi
  801d15:	5f                   	pop    %edi
  801d16:	5d                   	pop    %ebp
  801d17:	c3                   	ret    
  801d18:	39 ce                	cmp    %ecx,%esi
  801d1a:	77 28                	ja     801d44 <__udivdi3+0x7c>
  801d1c:	0f bd fe             	bsr    %esi,%edi
  801d1f:	83 f7 1f             	xor    $0x1f,%edi
  801d22:	75 40                	jne    801d64 <__udivdi3+0x9c>
  801d24:	39 ce                	cmp    %ecx,%esi
  801d26:	72 0a                	jb     801d32 <__udivdi3+0x6a>
  801d28:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d2c:	0f 87 9e 00 00 00    	ja     801dd0 <__udivdi3+0x108>
  801d32:	b8 01 00 00 00       	mov    $0x1,%eax
  801d37:	89 fa                	mov    %edi,%edx
  801d39:	83 c4 1c             	add    $0x1c,%esp
  801d3c:	5b                   	pop    %ebx
  801d3d:	5e                   	pop    %esi
  801d3e:	5f                   	pop    %edi
  801d3f:	5d                   	pop    %ebp
  801d40:	c3                   	ret    
  801d41:	8d 76 00             	lea    0x0(%esi),%esi
  801d44:	31 ff                	xor    %edi,%edi
  801d46:	31 c0                	xor    %eax,%eax
  801d48:	89 fa                	mov    %edi,%edx
  801d4a:	83 c4 1c             	add    $0x1c,%esp
  801d4d:	5b                   	pop    %ebx
  801d4e:	5e                   	pop    %esi
  801d4f:	5f                   	pop    %edi
  801d50:	5d                   	pop    %ebp
  801d51:	c3                   	ret    
  801d52:	66 90                	xchg   %ax,%ax
  801d54:	89 d8                	mov    %ebx,%eax
  801d56:	f7 f7                	div    %edi
  801d58:	31 ff                	xor    %edi,%edi
  801d5a:	89 fa                	mov    %edi,%edx
  801d5c:	83 c4 1c             	add    $0x1c,%esp
  801d5f:	5b                   	pop    %ebx
  801d60:	5e                   	pop    %esi
  801d61:	5f                   	pop    %edi
  801d62:	5d                   	pop    %ebp
  801d63:	c3                   	ret    
  801d64:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d69:	29 fd                	sub    %edi,%ebp
  801d6b:	89 f9                	mov    %edi,%ecx
  801d6d:	d3 e6                	shl    %cl,%esi
  801d6f:	89 c3                	mov    %eax,%ebx
  801d71:	89 e9                	mov    %ebp,%ecx
  801d73:	d3 eb                	shr    %cl,%ebx
  801d75:	89 d9                	mov    %ebx,%ecx
  801d77:	09 f1                	or     %esi,%ecx
  801d79:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d7d:	89 f9                	mov    %edi,%ecx
  801d7f:	d3 e0                	shl    %cl,%eax
  801d81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d85:	89 d6                	mov    %edx,%esi
  801d87:	89 e9                	mov    %ebp,%ecx
  801d89:	d3 ee                	shr    %cl,%esi
  801d8b:	89 f9                	mov    %edi,%ecx
  801d8d:	d3 e2                	shl    %cl,%edx
  801d8f:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d93:	89 e9                	mov    %ebp,%ecx
  801d95:	d3 eb                	shr    %cl,%ebx
  801d97:	09 da                	or     %ebx,%edx
  801d99:	89 d0                	mov    %edx,%eax
  801d9b:	89 f2                	mov    %esi,%edx
  801d9d:	f7 74 24 08          	divl   0x8(%esp)
  801da1:	89 d6                	mov    %edx,%esi
  801da3:	89 c3                	mov    %eax,%ebx
  801da5:	f7 64 24 0c          	mull   0xc(%esp)
  801da9:	39 d6                	cmp    %edx,%esi
  801dab:	72 17                	jb     801dc4 <__udivdi3+0xfc>
  801dad:	74 09                	je     801db8 <__udivdi3+0xf0>
  801daf:	89 d8                	mov    %ebx,%eax
  801db1:	31 ff                	xor    %edi,%edi
  801db3:	e9 56 ff ff ff       	jmp    801d0e <__udivdi3+0x46>
  801db8:	8b 54 24 04          	mov    0x4(%esp),%edx
  801dbc:	89 f9                	mov    %edi,%ecx
  801dbe:	d3 e2                	shl    %cl,%edx
  801dc0:	39 c2                	cmp    %eax,%edx
  801dc2:	73 eb                	jae    801daf <__udivdi3+0xe7>
  801dc4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dc7:	31 ff                	xor    %edi,%edi
  801dc9:	e9 40 ff ff ff       	jmp    801d0e <__udivdi3+0x46>
  801dce:	66 90                	xchg   %ax,%ax
  801dd0:	31 c0                	xor    %eax,%eax
  801dd2:	e9 37 ff ff ff       	jmp    801d0e <__udivdi3+0x46>
  801dd7:	90                   	nop

00801dd8 <__umoddi3>:
  801dd8:	55                   	push   %ebp
  801dd9:	57                   	push   %edi
  801dda:	56                   	push   %esi
  801ddb:	53                   	push   %ebx
  801ddc:	83 ec 1c             	sub    $0x1c,%esp
  801ddf:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801de3:	8b 74 24 34          	mov    0x34(%esp),%esi
  801de7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801deb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801def:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801df3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801df7:	89 3c 24             	mov    %edi,(%esp)
  801dfa:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dfe:	89 f2                	mov    %esi,%edx
  801e00:	85 c0                	test   %eax,%eax
  801e02:	75 18                	jne    801e1c <__umoddi3+0x44>
  801e04:	39 f7                	cmp    %esi,%edi
  801e06:	0f 86 a0 00 00 00    	jbe    801eac <__umoddi3+0xd4>
  801e0c:	89 c8                	mov    %ecx,%eax
  801e0e:	f7 f7                	div    %edi
  801e10:	89 d0                	mov    %edx,%eax
  801e12:	31 d2                	xor    %edx,%edx
  801e14:	83 c4 1c             	add    $0x1c,%esp
  801e17:	5b                   	pop    %ebx
  801e18:	5e                   	pop    %esi
  801e19:	5f                   	pop    %edi
  801e1a:	5d                   	pop    %ebp
  801e1b:	c3                   	ret    
  801e1c:	89 f3                	mov    %esi,%ebx
  801e1e:	39 f0                	cmp    %esi,%eax
  801e20:	0f 87 a6 00 00 00    	ja     801ecc <__umoddi3+0xf4>
  801e26:	0f bd e8             	bsr    %eax,%ebp
  801e29:	83 f5 1f             	xor    $0x1f,%ebp
  801e2c:	0f 84 a6 00 00 00    	je     801ed8 <__umoddi3+0x100>
  801e32:	bf 20 00 00 00       	mov    $0x20,%edi
  801e37:	29 ef                	sub    %ebp,%edi
  801e39:	89 e9                	mov    %ebp,%ecx
  801e3b:	d3 e0                	shl    %cl,%eax
  801e3d:	8b 34 24             	mov    (%esp),%esi
  801e40:	89 f2                	mov    %esi,%edx
  801e42:	89 f9                	mov    %edi,%ecx
  801e44:	d3 ea                	shr    %cl,%edx
  801e46:	09 c2                	or     %eax,%edx
  801e48:	89 14 24             	mov    %edx,(%esp)
  801e4b:	89 f2                	mov    %esi,%edx
  801e4d:	89 e9                	mov    %ebp,%ecx
  801e4f:	d3 e2                	shl    %cl,%edx
  801e51:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e55:	89 de                	mov    %ebx,%esi
  801e57:	89 f9                	mov    %edi,%ecx
  801e59:	d3 ee                	shr    %cl,%esi
  801e5b:	89 e9                	mov    %ebp,%ecx
  801e5d:	d3 e3                	shl    %cl,%ebx
  801e5f:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e63:	89 d0                	mov    %edx,%eax
  801e65:	89 f9                	mov    %edi,%ecx
  801e67:	d3 e8                	shr    %cl,%eax
  801e69:	09 d8                	or     %ebx,%eax
  801e6b:	89 d3                	mov    %edx,%ebx
  801e6d:	89 e9                	mov    %ebp,%ecx
  801e6f:	d3 e3                	shl    %cl,%ebx
  801e71:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e75:	89 f2                	mov    %esi,%edx
  801e77:	f7 34 24             	divl   (%esp)
  801e7a:	89 d6                	mov    %edx,%esi
  801e7c:	f7 64 24 04          	mull   0x4(%esp)
  801e80:	89 c3                	mov    %eax,%ebx
  801e82:	89 d1                	mov    %edx,%ecx
  801e84:	39 d6                	cmp    %edx,%esi
  801e86:	72 7c                	jb     801f04 <__umoddi3+0x12c>
  801e88:	74 72                	je     801efc <__umoddi3+0x124>
  801e8a:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e8e:	29 da                	sub    %ebx,%edx
  801e90:	19 ce                	sbb    %ecx,%esi
  801e92:	89 f0                	mov    %esi,%eax
  801e94:	89 f9                	mov    %edi,%ecx
  801e96:	d3 e0                	shl    %cl,%eax
  801e98:	89 e9                	mov    %ebp,%ecx
  801e9a:	d3 ea                	shr    %cl,%edx
  801e9c:	09 d0                	or     %edx,%eax
  801e9e:	89 e9                	mov    %ebp,%ecx
  801ea0:	d3 ee                	shr    %cl,%esi
  801ea2:	89 f2                	mov    %esi,%edx
  801ea4:	83 c4 1c             	add    $0x1c,%esp
  801ea7:	5b                   	pop    %ebx
  801ea8:	5e                   	pop    %esi
  801ea9:	5f                   	pop    %edi
  801eaa:	5d                   	pop    %ebp
  801eab:	c3                   	ret    
  801eac:	89 fd                	mov    %edi,%ebp
  801eae:	85 ff                	test   %edi,%edi
  801eb0:	75 0b                	jne    801ebd <__umoddi3+0xe5>
  801eb2:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb7:	31 d2                	xor    %edx,%edx
  801eb9:	f7 f7                	div    %edi
  801ebb:	89 c5                	mov    %eax,%ebp
  801ebd:	89 f0                	mov    %esi,%eax
  801ebf:	31 d2                	xor    %edx,%edx
  801ec1:	f7 f5                	div    %ebp
  801ec3:	89 c8                	mov    %ecx,%eax
  801ec5:	f7 f5                	div    %ebp
  801ec7:	e9 44 ff ff ff       	jmp    801e10 <__umoddi3+0x38>
  801ecc:	89 c8                	mov    %ecx,%eax
  801ece:	89 f2                	mov    %esi,%edx
  801ed0:	83 c4 1c             	add    $0x1c,%esp
  801ed3:	5b                   	pop    %ebx
  801ed4:	5e                   	pop    %esi
  801ed5:	5f                   	pop    %edi
  801ed6:	5d                   	pop    %ebp
  801ed7:	c3                   	ret    
  801ed8:	39 f0                	cmp    %esi,%eax
  801eda:	72 05                	jb     801ee1 <__umoddi3+0x109>
  801edc:	39 0c 24             	cmp    %ecx,(%esp)
  801edf:	77 0c                	ja     801eed <__umoddi3+0x115>
  801ee1:	89 f2                	mov    %esi,%edx
  801ee3:	29 f9                	sub    %edi,%ecx
  801ee5:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ee9:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801eed:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ef1:	83 c4 1c             	add    $0x1c,%esp
  801ef4:	5b                   	pop    %ebx
  801ef5:	5e                   	pop    %esi
  801ef6:	5f                   	pop    %edi
  801ef7:	5d                   	pop    %ebp
  801ef8:	c3                   	ret    
  801ef9:	8d 76 00             	lea    0x0(%esi),%esi
  801efc:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801f00:	73 88                	jae    801e8a <__umoddi3+0xb2>
  801f02:	66 90                	xchg   %ax,%ax
  801f04:	2b 44 24 04          	sub    0x4(%esp),%eax
  801f08:	1b 14 24             	sbb    (%esp),%edx
  801f0b:	89 d1                	mov    %edx,%ecx
  801f0d:	89 c3                	mov    %eax,%ebx
  801f0f:	e9 76 ff ff ff       	jmp    801e8a <__umoddi3+0xb2>
