
obj/user/faultwrite.debug:     file format elf32-i386


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
  80002c:	e8 11 00 00 00       	call   800042 <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:

#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
	*(unsigned*)0 = 0;
  800036:	c7 05 00 00 00 00 00 	movl   $0x0,0x0
  80003d:	00 00 00 
}
  800040:	5d                   	pop    %ebp
  800041:	c3                   	ret    

00800042 <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  800042:	55                   	push   %ebp
  800043:	89 e5                	mov    %esp,%ebp
  800045:	56                   	push   %esi
  800046:	53                   	push   %ebx
  800047:	8b 5d 08             	mov    0x8(%ebp),%ebx
  80004a:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  80004d:	e8 d4 00 00 00       	call   800126 <sys_getenvid>
  800052:	25 ff 03 00 00       	and    $0x3ff,%eax
  800057:	89 c2                	mov    %eax,%edx
  800059:	c1 e2 05             	shl    $0x5,%edx
  80005c:	29 c2                	sub    %eax,%edx
  80005e:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  800065:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80006a:	85 db                	test   %ebx,%ebx
  80006c:	7e 07                	jle    800075 <libmain+0x33>
		binaryname = argv[0];
  80006e:	8b 06                	mov    (%esi),%eax
  800070:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  800075:	83 ec 08             	sub    $0x8,%esp
  800078:	56                   	push   %esi
  800079:	53                   	push   %ebx
  80007a:	e8 b4 ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  80007f:	e8 0a 00 00 00       	call   80008e <exit>
}
  800084:	83 c4 10             	add    $0x10,%esp
  800087:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80008a:	5b                   	pop    %ebx
  80008b:	5e                   	pop    %esi
  80008c:	5d                   	pop    %ebp
  80008d:	c3                   	ret    

0080008e <exit>:

#include <inc/lib.h>

void
exit(void)
{
  80008e:	55                   	push   %ebp
  80008f:	89 e5                	mov    %esp,%ebp
  800091:	83 ec 08             	sub    $0x8,%esp
	close_all();
  800094:	e8 35 05 00 00       	call   8005ce <close_all>
	sys_env_destroy(0);
  800099:	83 ec 0c             	sub    $0xc,%esp
  80009c:	6a 00                	push   $0x0
  80009e:	e8 42 00 00 00       	call   8000e5 <sys_env_destroy>
}
  8000a3:	83 c4 10             	add    $0x10,%esp
  8000a6:	c9                   	leave  
  8000a7:	c3                   	ret    

008000a8 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000a8:	55                   	push   %ebp
  8000a9:	89 e5                	mov    %esp,%ebp
  8000ab:	57                   	push   %edi
  8000ac:	56                   	push   %esi
  8000ad:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8000b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8000b9:	89 c3                	mov    %eax,%ebx
  8000bb:	89 c7                	mov    %eax,%edi
  8000bd:	89 c6                	mov    %eax,%esi
  8000bf:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c1:	5b                   	pop    %ebx
  8000c2:	5e                   	pop    %esi
  8000c3:	5f                   	pop    %edi
  8000c4:	5d                   	pop    %ebp
  8000c5:	c3                   	ret    

008000c6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8000c6:	55                   	push   %ebp
  8000c7:	89 e5                	mov    %esp,%ebp
  8000c9:	57                   	push   %edi
  8000ca:	56                   	push   %esi
  8000cb:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d1:	b8 01 00 00 00       	mov    $0x1,%eax
  8000d6:	89 d1                	mov    %edx,%ecx
  8000d8:	89 d3                	mov    %edx,%ebx
  8000da:	89 d7                	mov    %edx,%edi
  8000dc:	89 d6                	mov    %edx,%esi
  8000de:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e0:	5b                   	pop    %ebx
  8000e1:	5e                   	pop    %esi
  8000e2:	5f                   	pop    %edi
  8000e3:	5d                   	pop    %ebp
  8000e4:	c3                   	ret    

008000e5 <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000e5:	55                   	push   %ebp
  8000e6:	89 e5                	mov    %esp,%ebp
  8000e8:	57                   	push   %edi
  8000e9:	56                   	push   %esi
  8000ea:	53                   	push   %ebx
  8000eb:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000ee:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000f3:	b8 03 00 00 00       	mov    $0x3,%eax
  8000f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8000fb:	89 cb                	mov    %ecx,%ebx
  8000fd:	89 cf                	mov    %ecx,%edi
  8000ff:	89 ce                	mov    %ecx,%esi
  800101:	cd 30                	int    $0x30
	if(check && ret > 0)
  800103:	85 c0                	test   %eax,%eax
  800105:	7f 08                	jg     80010f <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  800107:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80010a:	5b                   	pop    %ebx
  80010b:	5e                   	pop    %esi
  80010c:	5f                   	pop    %edi
  80010d:	5d                   	pop    %ebp
  80010e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	50                   	push   %eax
  800113:	6a 03                	push   $0x3
  800115:	68 0a 1f 80 00       	push   $0x801f0a
  80011a:	6a 23                	push   $0x23
  80011c:	68 27 1f 80 00       	push   $0x801f27
  800121:	e8 df 0f 00 00       	call   801105 <_panic>

00800126 <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  800126:	55                   	push   %ebp
  800127:	89 e5                	mov    %esp,%ebp
  800129:	57                   	push   %edi
  80012a:	56                   	push   %esi
  80012b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80012c:	ba 00 00 00 00       	mov    $0x0,%edx
  800131:	b8 02 00 00 00       	mov    $0x2,%eax
  800136:	89 d1                	mov    %edx,%ecx
  800138:	89 d3                	mov    %edx,%ebx
  80013a:	89 d7                	mov    %edx,%edi
  80013c:	89 d6                	mov    %edx,%esi
  80013e:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800140:	5b                   	pop    %ebx
  800141:	5e                   	pop    %esi
  800142:	5f                   	pop    %edi
  800143:	5d                   	pop    %ebp
  800144:	c3                   	ret    

00800145 <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  800145:	55                   	push   %ebp
  800146:	89 e5                	mov    %esp,%ebp
  800148:	57                   	push   %edi
  800149:	56                   	push   %esi
  80014a:	53                   	push   %ebx
  80014b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80014e:	be 00 00 00 00       	mov    $0x0,%esi
  800153:	b8 04 00 00 00       	mov    $0x4,%eax
  800158:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80015b:	8b 55 08             	mov    0x8(%ebp),%edx
  80015e:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800161:	89 f7                	mov    %esi,%edi
  800163:	cd 30                	int    $0x30
	if(check && ret > 0)
  800165:	85 c0                	test   %eax,%eax
  800167:	7f 08                	jg     800171 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800169:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80016c:	5b                   	pop    %ebx
  80016d:	5e                   	pop    %esi
  80016e:	5f                   	pop    %edi
  80016f:	5d                   	pop    %ebp
  800170:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800171:	83 ec 0c             	sub    $0xc,%esp
  800174:	50                   	push   %eax
  800175:	6a 04                	push   $0x4
  800177:	68 0a 1f 80 00       	push   $0x801f0a
  80017c:	6a 23                	push   $0x23
  80017e:	68 27 1f 80 00       	push   $0x801f27
  800183:	e8 7d 0f 00 00       	call   801105 <_panic>

00800188 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	57                   	push   %edi
  80018c:	56                   	push   %esi
  80018d:	53                   	push   %ebx
  80018e:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800191:	b8 05 00 00 00       	mov    $0x5,%eax
  800196:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800199:	8b 55 08             	mov    0x8(%ebp),%edx
  80019c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80019f:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001a2:	8b 75 18             	mov    0x18(%ebp),%esi
  8001a5:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001a7:	85 c0                	test   %eax,%eax
  8001a9:	7f 08                	jg     8001b3 <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001ae:	5b                   	pop    %ebx
  8001af:	5e                   	pop    %esi
  8001b0:	5f                   	pop    %edi
  8001b1:	5d                   	pop    %ebp
  8001b2:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001b3:	83 ec 0c             	sub    $0xc,%esp
  8001b6:	50                   	push   %eax
  8001b7:	6a 05                	push   $0x5
  8001b9:	68 0a 1f 80 00       	push   $0x801f0a
  8001be:	6a 23                	push   $0x23
  8001c0:	68 27 1f 80 00       	push   $0x801f27
  8001c5:	e8 3b 0f 00 00       	call   801105 <_panic>

008001ca <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001ca:	55                   	push   %ebp
  8001cb:	89 e5                	mov    %esp,%ebp
  8001cd:	57                   	push   %edi
  8001ce:	56                   	push   %esi
  8001cf:	53                   	push   %ebx
  8001d0:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001d3:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001d8:	b8 06 00 00 00       	mov    $0x6,%eax
  8001dd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8001e3:	89 df                	mov    %ebx,%edi
  8001e5:	89 de                	mov    %ebx,%esi
  8001e7:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001e9:	85 c0                	test   %eax,%eax
  8001eb:	7f 08                	jg     8001f5 <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001ed:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f0:	5b                   	pop    %ebx
  8001f1:	5e                   	pop    %esi
  8001f2:	5f                   	pop    %edi
  8001f3:	5d                   	pop    %ebp
  8001f4:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	50                   	push   %eax
  8001f9:	6a 06                	push   $0x6
  8001fb:	68 0a 1f 80 00       	push   $0x801f0a
  800200:	6a 23                	push   $0x23
  800202:	68 27 1f 80 00       	push   $0x801f27
  800207:	e8 f9 0e 00 00       	call   801105 <_panic>

0080020c <sys_yield>:

void
sys_yield(void)
{
  80020c:	55                   	push   %ebp
  80020d:	89 e5                	mov    %esp,%ebp
  80020f:	57                   	push   %edi
  800210:	56                   	push   %esi
  800211:	53                   	push   %ebx
	asm volatile("int %1\n"
  800212:	ba 00 00 00 00       	mov    $0x0,%edx
  800217:	b8 0b 00 00 00       	mov    $0xb,%eax
  80021c:	89 d1                	mov    %edx,%ecx
  80021e:	89 d3                	mov    %edx,%ebx
  800220:	89 d7                	mov    %edx,%edi
  800222:	89 d6                	mov    %edx,%esi
  800224:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  800226:	5b                   	pop    %ebx
  800227:	5e                   	pop    %esi
  800228:	5f                   	pop    %edi
  800229:	5d                   	pop    %ebp
  80022a:	c3                   	ret    

0080022b <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	57                   	push   %edi
  80022f:	56                   	push   %esi
  800230:	53                   	push   %ebx
  800231:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800234:	bb 00 00 00 00       	mov    $0x0,%ebx
  800239:	b8 08 00 00 00       	mov    $0x8,%eax
  80023e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800241:	8b 55 08             	mov    0x8(%ebp),%edx
  800244:	89 df                	mov    %ebx,%edi
  800246:	89 de                	mov    %ebx,%esi
  800248:	cd 30                	int    $0x30
	if(check && ret > 0)
  80024a:	85 c0                	test   %eax,%eax
  80024c:	7f 08                	jg     800256 <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  80024e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800251:	5b                   	pop    %ebx
  800252:	5e                   	pop    %esi
  800253:	5f                   	pop    %edi
  800254:	5d                   	pop    %ebp
  800255:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800256:	83 ec 0c             	sub    $0xc,%esp
  800259:	50                   	push   %eax
  80025a:	6a 08                	push   $0x8
  80025c:	68 0a 1f 80 00       	push   $0x801f0a
  800261:	6a 23                	push   $0x23
  800263:	68 27 1f 80 00       	push   $0x801f27
  800268:	e8 98 0e 00 00       	call   801105 <_panic>

0080026d <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  80026d:	55                   	push   %ebp
  80026e:	89 e5                	mov    %esp,%ebp
  800270:	57                   	push   %edi
  800271:	56                   	push   %esi
  800272:	53                   	push   %ebx
  800273:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800276:	b9 00 00 00 00       	mov    $0x0,%ecx
  80027b:	b8 0c 00 00 00       	mov    $0xc,%eax
  800280:	8b 55 08             	mov    0x8(%ebp),%edx
  800283:	89 cb                	mov    %ecx,%ebx
  800285:	89 cf                	mov    %ecx,%edi
  800287:	89 ce                	mov    %ecx,%esi
  800289:	cd 30                	int    $0x30
	if(check && ret > 0)
  80028b:	85 c0                	test   %eax,%eax
  80028d:	7f 08                	jg     800297 <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  80028f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800292:	5b                   	pop    %ebx
  800293:	5e                   	pop    %esi
  800294:	5f                   	pop    %edi
  800295:	5d                   	pop    %ebp
  800296:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800297:	83 ec 0c             	sub    $0xc,%esp
  80029a:	50                   	push   %eax
  80029b:	6a 0c                	push   $0xc
  80029d:	68 0a 1f 80 00       	push   $0x801f0a
  8002a2:	6a 23                	push   $0x23
  8002a4:	68 27 1f 80 00       	push   $0x801f27
  8002a9:	e8 57 0e 00 00       	call   801105 <_panic>

008002ae <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002ae:	55                   	push   %ebp
  8002af:	89 e5                	mov    %esp,%ebp
  8002b1:	57                   	push   %edi
  8002b2:	56                   	push   %esi
  8002b3:	53                   	push   %ebx
  8002b4:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002b7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002bc:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8002c7:	89 df                	mov    %ebx,%edi
  8002c9:	89 de                	mov    %ebx,%esi
  8002cb:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002cd:	85 c0                	test   %eax,%eax
  8002cf:	7f 08                	jg     8002d9 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002d4:	5b                   	pop    %ebx
  8002d5:	5e                   	pop    %esi
  8002d6:	5f                   	pop    %edi
  8002d7:	5d                   	pop    %ebp
  8002d8:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002d9:	83 ec 0c             	sub    $0xc,%esp
  8002dc:	50                   	push   %eax
  8002dd:	6a 09                	push   $0x9
  8002df:	68 0a 1f 80 00       	push   $0x801f0a
  8002e4:	6a 23                	push   $0x23
  8002e6:	68 27 1f 80 00       	push   $0x801f27
  8002eb:	e8 15 0e 00 00       	call   801105 <_panic>

008002f0 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	57                   	push   %edi
  8002f4:	56                   	push   %esi
  8002f5:	53                   	push   %ebx
  8002f6:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002f9:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002fe:	b8 0a 00 00 00       	mov    $0xa,%eax
  800303:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800306:	8b 55 08             	mov    0x8(%ebp),%edx
  800309:	89 df                	mov    %ebx,%edi
  80030b:	89 de                	mov    %ebx,%esi
  80030d:	cd 30                	int    $0x30
	if(check && ret > 0)
  80030f:	85 c0                	test   %eax,%eax
  800311:	7f 08                	jg     80031b <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  800313:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800316:	5b                   	pop    %ebx
  800317:	5e                   	pop    %esi
  800318:	5f                   	pop    %edi
  800319:	5d                   	pop    %ebp
  80031a:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80031b:	83 ec 0c             	sub    $0xc,%esp
  80031e:	50                   	push   %eax
  80031f:	6a 0a                	push   $0xa
  800321:	68 0a 1f 80 00       	push   $0x801f0a
  800326:	6a 23                	push   $0x23
  800328:	68 27 1f 80 00       	push   $0x801f27
  80032d:	e8 d3 0d 00 00       	call   801105 <_panic>

00800332 <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  800332:	55                   	push   %ebp
  800333:	89 e5                	mov    %esp,%ebp
  800335:	57                   	push   %edi
  800336:	56                   	push   %esi
  800337:	53                   	push   %ebx
	asm volatile("int %1\n"
  800338:	be 00 00 00 00       	mov    $0x0,%esi
  80033d:	b8 0d 00 00 00       	mov    $0xd,%eax
  800342:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800345:	8b 55 08             	mov    0x8(%ebp),%edx
  800348:	8b 5d 10             	mov    0x10(%ebp),%ebx
  80034b:	8b 7d 14             	mov    0x14(%ebp),%edi
  80034e:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800350:	5b                   	pop    %ebx
  800351:	5e                   	pop    %esi
  800352:	5f                   	pop    %edi
  800353:	5d                   	pop    %ebp
  800354:	c3                   	ret    

00800355 <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  800355:	55                   	push   %ebp
  800356:	89 e5                	mov    %esp,%ebp
  800358:	57                   	push   %edi
  800359:	56                   	push   %esi
  80035a:	53                   	push   %ebx
  80035b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80035e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800363:	b8 0e 00 00 00       	mov    $0xe,%eax
  800368:	8b 55 08             	mov    0x8(%ebp),%edx
  80036b:	89 cb                	mov    %ecx,%ebx
  80036d:	89 cf                	mov    %ecx,%edi
  80036f:	89 ce                	mov    %ecx,%esi
  800371:	cd 30                	int    $0x30
	if(check && ret > 0)
  800373:	85 c0                	test   %eax,%eax
  800375:	7f 08                	jg     80037f <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  800377:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80037a:	5b                   	pop    %ebx
  80037b:	5e                   	pop    %esi
  80037c:	5f                   	pop    %edi
  80037d:	5d                   	pop    %ebp
  80037e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	50                   	push   %eax
  800383:	6a 0e                	push   $0xe
  800385:	68 0a 1f 80 00       	push   $0x801f0a
  80038a:	6a 23                	push   $0x23
  80038c:	68 27 1f 80 00       	push   $0x801f27
  800391:	e8 6f 0d 00 00       	call   801105 <_panic>

00800396 <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  800396:	55                   	push   %ebp
  800397:	89 e5                	mov    %esp,%ebp
  800399:	57                   	push   %edi
  80039a:	56                   	push   %esi
  80039b:	53                   	push   %ebx
	asm volatile("int %1\n"
  80039c:	be 00 00 00 00       	mov    $0x0,%esi
  8003a1:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ac:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003af:	89 f7                	mov    %esi,%edi
  8003b1:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003b3:	5b                   	pop    %ebx
  8003b4:	5e                   	pop    %esi
  8003b5:	5f                   	pop    %edi
  8003b6:	5d                   	pop    %ebp
  8003b7:	c3                   	ret    

008003b8 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003b8:	55                   	push   %ebp
  8003b9:	89 e5                	mov    %esp,%ebp
  8003bb:	57                   	push   %edi
  8003bc:	56                   	push   %esi
  8003bd:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003be:	be 00 00 00 00       	mov    $0x0,%esi
  8003c3:	b8 10 00 00 00       	mov    $0x10,%eax
  8003c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003cb:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ce:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d1:	89 f7                	mov    %esi,%edi
  8003d3:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003d5:	5b                   	pop    %ebx
  8003d6:	5e                   	pop    %esi
  8003d7:	5f                   	pop    %edi
  8003d8:	5d                   	pop    %ebp
  8003d9:	c3                   	ret    

008003da <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003da:	55                   	push   %ebp
  8003db:	89 e5                	mov    %esp,%ebp
  8003dd:	57                   	push   %edi
  8003de:	56                   	push   %esi
  8003df:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003e0:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003e5:	b8 11 00 00 00       	mov    $0x11,%eax
  8003ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8003ed:	89 cb                	mov    %ecx,%ebx
  8003ef:	89 cf                	mov    %ecx,%edi
  8003f1:	89 ce                	mov    %ecx,%esi
  8003f3:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003f5:	5b                   	pop    %ebx
  8003f6:	5e                   	pop    %esi
  8003f7:	5f                   	pop    %edi
  8003f8:	5d                   	pop    %ebp
  8003f9:	c3                   	ret    

008003fa <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  8003fa:	55                   	push   %ebp
  8003fb:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  8003fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800400:	05 00 00 00 30       	add    $0x30000000,%eax
  800405:	c1 e8 0c             	shr    $0xc,%eax
}
  800408:	5d                   	pop    %ebp
  800409:	c3                   	ret    

0080040a <fd2data>:

char*
fd2data(struct Fd *fd)
{
  80040a:	55                   	push   %ebp
  80040b:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  80040d:	8b 45 08             	mov    0x8(%ebp),%eax
  800410:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  800415:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80041a:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  80041f:	5d                   	pop    %ebp
  800420:	c3                   	ret    

00800421 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800421:	55                   	push   %ebp
  800422:	89 e5                	mov    %esp,%ebp
  800424:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800427:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  80042c:	89 c2                	mov    %eax,%edx
  80042e:	c1 ea 16             	shr    $0x16,%edx
  800431:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800438:	f6 c2 01             	test   $0x1,%dl
  80043b:	74 2a                	je     800467 <fd_alloc+0x46>
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	c1 ea 0c             	shr    $0xc,%edx
  800442:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800449:	f6 c2 01             	test   $0x1,%dl
  80044c:	74 19                	je     800467 <fd_alloc+0x46>
  80044e:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  800453:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800458:	75 d2                	jne    80042c <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  80045a:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800460:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  800465:	eb 07                	jmp    80046e <fd_alloc+0x4d>
			*fd_store = fd;
  800467:	89 01                	mov    %eax,(%ecx)
			return 0;
  800469:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80046e:	5d                   	pop    %ebp
  80046f:	c3                   	ret    

00800470 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  800473:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  800477:	77 39                	ja     8004b2 <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800479:	8b 45 08             	mov    0x8(%ebp),%eax
  80047c:	c1 e0 0c             	shl    $0xc,%eax
  80047f:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  800484:	89 c2                	mov    %eax,%edx
  800486:	c1 ea 16             	shr    $0x16,%edx
  800489:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800490:	f6 c2 01             	test   $0x1,%dl
  800493:	74 24                	je     8004b9 <fd_lookup+0x49>
  800495:	89 c2                	mov    %eax,%edx
  800497:	c1 ea 0c             	shr    $0xc,%edx
  80049a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004a1:	f6 c2 01             	test   $0x1,%dl
  8004a4:	74 1a                	je     8004c0 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a9:	89 02                	mov    %eax,(%edx)
	return 0;
  8004ab:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b0:	5d                   	pop    %ebp
  8004b1:	c3                   	ret    
		return -E_INVAL;
  8004b2:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004b7:	eb f7                	jmp    8004b0 <fd_lookup+0x40>
		return -E_INVAL;
  8004b9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004be:	eb f0                	jmp    8004b0 <fd_lookup+0x40>
  8004c0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004c5:	eb e9                	jmp    8004b0 <fd_lookup+0x40>

008004c7 <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004c7:	55                   	push   %ebp
  8004c8:	89 e5                	mov    %esp,%ebp
  8004ca:	83 ec 08             	sub    $0x8,%esp
  8004cd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d0:	ba b4 1f 80 00       	mov    $0x801fb4,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004d5:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004da:	39 08                	cmp    %ecx,(%eax)
  8004dc:	74 33                	je     800511 <dev_lookup+0x4a>
  8004de:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004e1:	8b 02                	mov    (%edx),%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 f3                	jne    8004da <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004e7:	a1 04 40 80 00       	mov    0x804004,%eax
  8004ec:	8b 40 48             	mov    0x48(%eax),%eax
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	51                   	push   %ecx
  8004f3:	50                   	push   %eax
  8004f4:	68 38 1f 80 00       	push   $0x801f38
  8004f9:	e8 1a 0d 00 00       	call   801218 <cprintf>
	*dev = 0;
  8004fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800501:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  800507:	83 c4 10             	add    $0x10,%esp
  80050a:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  80050f:	c9                   	leave  
  800510:	c3                   	ret    
			*dev = devtab[i];
  800511:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800514:	89 01                	mov    %eax,(%ecx)
			return 0;
  800516:	b8 00 00 00 00       	mov    $0x0,%eax
  80051b:	eb f2                	jmp    80050f <dev_lookup+0x48>

0080051d <fd_close>:
{
  80051d:	55                   	push   %ebp
  80051e:	89 e5                	mov    %esp,%ebp
  800520:	57                   	push   %edi
  800521:	56                   	push   %esi
  800522:	53                   	push   %ebx
  800523:	83 ec 1c             	sub    $0x1c,%esp
  800526:	8b 75 08             	mov    0x8(%ebp),%esi
  800529:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  80052c:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80052f:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800530:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  800536:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800539:	50                   	push   %eax
  80053a:	e8 31 ff ff ff       	call   800470 <fd_lookup>
  80053f:	89 c7                	mov    %eax,%edi
  800541:	83 c4 08             	add    $0x8,%esp
  800544:	85 c0                	test   %eax,%eax
  800546:	78 05                	js     80054d <fd_close+0x30>
	    || fd != fd2)
  800548:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  80054b:	74 13                	je     800560 <fd_close+0x43>
		return (must_exist ? r : 0);
  80054d:	84 db                	test   %bl,%bl
  80054f:	75 05                	jne    800556 <fd_close+0x39>
  800551:	bf 00 00 00 00       	mov    $0x0,%edi
}
  800556:	89 f8                	mov    %edi,%eax
  800558:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80055b:	5b                   	pop    %ebx
  80055c:	5e                   	pop    %esi
  80055d:	5f                   	pop    %edi
  80055e:	5d                   	pop    %ebp
  80055f:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800560:	83 ec 08             	sub    $0x8,%esp
  800563:	8d 45 e0             	lea    -0x20(%ebp),%eax
  800566:	50                   	push   %eax
  800567:	ff 36                	pushl  (%esi)
  800569:	e8 59 ff ff ff       	call   8004c7 <dev_lookup>
  80056e:	89 c7                	mov    %eax,%edi
  800570:	83 c4 10             	add    $0x10,%esp
  800573:	85 c0                	test   %eax,%eax
  800575:	78 15                	js     80058c <fd_close+0x6f>
		if (dev->dev_close)
  800577:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80057a:	8b 40 10             	mov    0x10(%eax),%eax
  80057d:	85 c0                	test   %eax,%eax
  80057f:	74 1b                	je     80059c <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800581:	83 ec 0c             	sub    $0xc,%esp
  800584:	56                   	push   %esi
  800585:	ff d0                	call   *%eax
  800587:	89 c7                	mov    %eax,%edi
  800589:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  80058c:	83 ec 08             	sub    $0x8,%esp
  80058f:	56                   	push   %esi
  800590:	6a 00                	push   $0x0
  800592:	e8 33 fc ff ff       	call   8001ca <sys_page_unmap>
	return r;
  800597:	83 c4 10             	add    $0x10,%esp
  80059a:	eb ba                	jmp    800556 <fd_close+0x39>
			r = 0;
  80059c:	bf 00 00 00 00       	mov    $0x0,%edi
  8005a1:	eb e9                	jmp    80058c <fd_close+0x6f>

008005a3 <close>:

int
close(int fdnum)
{
  8005a3:	55                   	push   %ebp
  8005a4:	89 e5                	mov    %esp,%ebp
  8005a6:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005a9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005ac:	50                   	push   %eax
  8005ad:	ff 75 08             	pushl  0x8(%ebp)
  8005b0:	e8 bb fe ff ff       	call   800470 <fd_lookup>
  8005b5:	83 c4 08             	add    $0x8,%esp
  8005b8:	85 c0                	test   %eax,%eax
  8005ba:	78 10                	js     8005cc <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005bc:	83 ec 08             	sub    $0x8,%esp
  8005bf:	6a 01                	push   $0x1
  8005c1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c4:	e8 54 ff ff ff       	call   80051d <fd_close>
  8005c9:	83 c4 10             	add    $0x10,%esp
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <close_all>:

void
close_all(void)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005d5:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005da:	83 ec 0c             	sub    $0xc,%esp
  8005dd:	53                   	push   %ebx
  8005de:	e8 c0 ff ff ff       	call   8005a3 <close>
	for (i = 0; i < MAXFD; i++)
  8005e3:	43                   	inc    %ebx
  8005e4:	83 c4 10             	add    $0x10,%esp
  8005e7:	83 fb 20             	cmp    $0x20,%ebx
  8005ea:	75 ee                	jne    8005da <close_all+0xc>
}
  8005ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005ef:	c9                   	leave  
  8005f0:	c3                   	ret    

008005f1 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005f1:	55                   	push   %ebp
  8005f2:	89 e5                	mov    %esp,%ebp
  8005f4:	57                   	push   %edi
  8005f5:	56                   	push   %esi
  8005f6:	53                   	push   %ebx
  8005f7:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  8005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  8005fd:	50                   	push   %eax
  8005fe:	ff 75 08             	pushl  0x8(%ebp)
  800601:	e8 6a fe ff ff       	call   800470 <fd_lookup>
  800606:	89 c3                	mov    %eax,%ebx
  800608:	83 c4 08             	add    $0x8,%esp
  80060b:	85 c0                	test   %eax,%eax
  80060d:	0f 88 81 00 00 00    	js     800694 <dup+0xa3>
		return r;
	close(newfdnum);
  800613:	83 ec 0c             	sub    $0xc,%esp
  800616:	ff 75 0c             	pushl  0xc(%ebp)
  800619:	e8 85 ff ff ff       	call   8005a3 <close>

	newfd = INDEX2FD(newfdnum);
  80061e:	8b 75 0c             	mov    0xc(%ebp),%esi
  800621:	c1 e6 0c             	shl    $0xc,%esi
  800624:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  80062a:	83 c4 04             	add    $0x4,%esp
  80062d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800630:	e8 d5 fd ff ff       	call   80040a <fd2data>
  800635:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  800637:	89 34 24             	mov    %esi,(%esp)
  80063a:	e8 cb fd ff ff       	call   80040a <fd2data>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  800644:	89 d8                	mov    %ebx,%eax
  800646:	c1 e8 16             	shr    $0x16,%eax
  800649:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800650:	a8 01                	test   $0x1,%al
  800652:	74 11                	je     800665 <dup+0x74>
  800654:	89 d8                	mov    %ebx,%eax
  800656:	c1 e8 0c             	shr    $0xc,%eax
  800659:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800660:	f6 c2 01             	test   $0x1,%dl
  800663:	75 39                	jne    80069e <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  800665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800668:	89 d0                	mov    %edx,%eax
  80066a:	c1 e8 0c             	shr    $0xc,%eax
  80066d:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  800674:	83 ec 0c             	sub    $0xc,%esp
  800677:	25 07 0e 00 00       	and    $0xe07,%eax
  80067c:	50                   	push   %eax
  80067d:	56                   	push   %esi
  80067e:	6a 00                	push   $0x0
  800680:	52                   	push   %edx
  800681:	6a 00                	push   $0x0
  800683:	e8 00 fb ff ff       	call   800188 <sys_page_map>
  800688:	89 c3                	mov    %eax,%ebx
  80068a:	83 c4 20             	add    $0x20,%esp
  80068d:	85 c0                	test   %eax,%eax
  80068f:	78 31                	js     8006c2 <dup+0xd1>
		goto err;

	return newfdnum;
  800691:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  800694:	89 d8                	mov    %ebx,%eax
  800696:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800699:	5b                   	pop    %ebx
  80069a:	5e                   	pop    %esi
  80069b:	5f                   	pop    %edi
  80069c:	5d                   	pop    %ebp
  80069d:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  80069e:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006a5:	83 ec 0c             	sub    $0xc,%esp
  8006a8:	25 07 0e 00 00       	and    $0xe07,%eax
  8006ad:	50                   	push   %eax
  8006ae:	57                   	push   %edi
  8006af:	6a 00                	push   $0x0
  8006b1:	53                   	push   %ebx
  8006b2:	6a 00                	push   $0x0
  8006b4:	e8 cf fa ff ff       	call   800188 <sys_page_map>
  8006b9:	89 c3                	mov    %eax,%ebx
  8006bb:	83 c4 20             	add    $0x20,%esp
  8006be:	85 c0                	test   %eax,%eax
  8006c0:	79 a3                	jns    800665 <dup+0x74>
	sys_page_unmap(0, newfd);
  8006c2:	83 ec 08             	sub    $0x8,%esp
  8006c5:	56                   	push   %esi
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 fd fa ff ff       	call   8001ca <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006cd:	83 c4 08             	add    $0x8,%esp
  8006d0:	57                   	push   %edi
  8006d1:	6a 00                	push   $0x0
  8006d3:	e8 f2 fa ff ff       	call   8001ca <sys_page_unmap>
	return r;
  8006d8:	83 c4 10             	add    $0x10,%esp
  8006db:	eb b7                	jmp    800694 <dup+0xa3>

008006dd <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
  8006e0:	53                   	push   %ebx
  8006e1:	83 ec 14             	sub    $0x14,%esp
  8006e4:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006ea:	50                   	push   %eax
  8006eb:	53                   	push   %ebx
  8006ec:	e8 7f fd ff ff       	call   800470 <fd_lookup>
  8006f1:	83 c4 08             	add    $0x8,%esp
  8006f4:	85 c0                	test   %eax,%eax
  8006f6:	78 3f                	js     800737 <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8006f8:	83 ec 08             	sub    $0x8,%esp
  8006fb:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8006fe:	50                   	push   %eax
  8006ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800702:	ff 30                	pushl  (%eax)
  800704:	e8 be fd ff ff       	call   8004c7 <dev_lookup>
  800709:	83 c4 10             	add    $0x10,%esp
  80070c:	85 c0                	test   %eax,%eax
  80070e:	78 27                	js     800737 <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800710:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800713:	8b 42 08             	mov    0x8(%edx),%eax
  800716:	83 e0 03             	and    $0x3,%eax
  800719:	83 f8 01             	cmp    $0x1,%eax
  80071c:	74 1e                	je     80073c <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  80071e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800721:	8b 40 08             	mov    0x8(%eax),%eax
  800724:	85 c0                	test   %eax,%eax
  800726:	74 35                	je     80075d <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800728:	83 ec 04             	sub    $0x4,%esp
  80072b:	ff 75 10             	pushl  0x10(%ebp)
  80072e:	ff 75 0c             	pushl  0xc(%ebp)
  800731:	52                   	push   %edx
  800732:	ff d0                	call   *%eax
  800734:	83 c4 10             	add    $0x10,%esp
}
  800737:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80073a:	c9                   	leave  
  80073b:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  80073c:	a1 04 40 80 00       	mov    0x804004,%eax
  800741:	8b 40 48             	mov    0x48(%eax),%eax
  800744:	83 ec 04             	sub    $0x4,%esp
  800747:	53                   	push   %ebx
  800748:	50                   	push   %eax
  800749:	68 79 1f 80 00       	push   $0x801f79
  80074e:	e8 c5 0a 00 00       	call   801218 <cprintf>
		return -E_INVAL;
  800753:	83 c4 10             	add    $0x10,%esp
  800756:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80075b:	eb da                	jmp    800737 <read+0x5a>
		return -E_NOT_SUPP;
  80075d:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800762:	eb d3                	jmp    800737 <read+0x5a>

00800764 <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
  800767:	57                   	push   %edi
  800768:	56                   	push   %esi
  800769:	53                   	push   %ebx
  80076a:	83 ec 0c             	sub    $0xc,%esp
  80076d:	8b 7d 08             	mov    0x8(%ebp),%edi
  800770:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  800773:	bb 00 00 00 00       	mov    $0x0,%ebx
  800778:	39 f3                	cmp    %esi,%ebx
  80077a:	73 25                	jae    8007a1 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80077c:	83 ec 04             	sub    $0x4,%esp
  80077f:	89 f0                	mov    %esi,%eax
  800781:	29 d8                	sub    %ebx,%eax
  800783:	50                   	push   %eax
  800784:	89 d8                	mov    %ebx,%eax
  800786:	03 45 0c             	add    0xc(%ebp),%eax
  800789:	50                   	push   %eax
  80078a:	57                   	push   %edi
  80078b:	e8 4d ff ff ff       	call   8006dd <read>
		if (m < 0)
  800790:	83 c4 10             	add    $0x10,%esp
  800793:	85 c0                	test   %eax,%eax
  800795:	78 08                	js     80079f <readn+0x3b>
			return m;
		if (m == 0)
  800797:	85 c0                	test   %eax,%eax
  800799:	74 06                	je     8007a1 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  80079b:	01 c3                	add    %eax,%ebx
  80079d:	eb d9                	jmp    800778 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  80079f:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007a1:	89 d8                	mov    %ebx,%eax
  8007a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007a6:	5b                   	pop    %ebx
  8007a7:	5e                   	pop    %esi
  8007a8:	5f                   	pop    %edi
  8007a9:	5d                   	pop    %ebp
  8007aa:	c3                   	ret    

008007ab <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007ab:	55                   	push   %ebp
  8007ac:	89 e5                	mov    %esp,%ebp
  8007ae:	53                   	push   %ebx
  8007af:	83 ec 14             	sub    $0x14,%esp
  8007b2:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007b5:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007b8:	50                   	push   %eax
  8007b9:	53                   	push   %ebx
  8007ba:	e8 b1 fc ff ff       	call   800470 <fd_lookup>
  8007bf:	83 c4 08             	add    $0x8,%esp
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	78 3a                	js     800800 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007cc:	50                   	push   %eax
  8007cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d0:	ff 30                	pushl  (%eax)
  8007d2:	e8 f0 fc ff ff       	call   8004c7 <dev_lookup>
  8007d7:	83 c4 10             	add    $0x10,%esp
  8007da:	85 c0                	test   %eax,%eax
  8007dc:	78 22                	js     800800 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007e5:	74 1e                	je     800805 <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ea:	8b 52 0c             	mov    0xc(%edx),%edx
  8007ed:	85 d2                	test   %edx,%edx
  8007ef:	74 35                	je     800826 <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007f1:	83 ec 04             	sub    $0x4,%esp
  8007f4:	ff 75 10             	pushl  0x10(%ebp)
  8007f7:	ff 75 0c             	pushl  0xc(%ebp)
  8007fa:	50                   	push   %eax
  8007fb:	ff d2                	call   *%edx
  8007fd:	83 c4 10             	add    $0x10,%esp
}
  800800:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800803:	c9                   	leave  
  800804:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  800805:	a1 04 40 80 00       	mov    0x804004,%eax
  80080a:	8b 40 48             	mov    0x48(%eax),%eax
  80080d:	83 ec 04             	sub    $0x4,%esp
  800810:	53                   	push   %ebx
  800811:	50                   	push   %eax
  800812:	68 95 1f 80 00       	push   $0x801f95
  800817:	e8 fc 09 00 00       	call   801218 <cprintf>
		return -E_INVAL;
  80081c:	83 c4 10             	add    $0x10,%esp
  80081f:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800824:	eb da                	jmp    800800 <write+0x55>
		return -E_NOT_SUPP;
  800826:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80082b:	eb d3                	jmp    800800 <write+0x55>

0080082d <seek>:

int
seek(int fdnum, off_t offset)
{
  80082d:	55                   	push   %ebp
  80082e:	89 e5                	mov    %esp,%ebp
  800830:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800833:	8d 45 fc             	lea    -0x4(%ebp),%eax
  800836:	50                   	push   %eax
  800837:	ff 75 08             	pushl  0x8(%ebp)
  80083a:	e8 31 fc ff ff       	call   800470 <fd_lookup>
  80083f:	83 c4 08             	add    $0x8,%esp
  800842:	85 c0                	test   %eax,%eax
  800844:	78 0e                	js     800854 <seek+0x27>
		return r;
	fd->fd_offset = offset;
  800846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800849:	8b 55 0c             	mov    0xc(%ebp),%edx
  80084c:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  80084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800854:	c9                   	leave  
  800855:	c3                   	ret    

00800856 <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  800856:	55                   	push   %ebp
  800857:	89 e5                	mov    %esp,%ebp
  800859:	53                   	push   %ebx
  80085a:	83 ec 14             	sub    $0x14,%esp
  80085d:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800860:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800863:	50                   	push   %eax
  800864:	53                   	push   %ebx
  800865:	e8 06 fc ff ff       	call   800470 <fd_lookup>
  80086a:	83 c4 08             	add    $0x8,%esp
  80086d:	85 c0                	test   %eax,%eax
  80086f:	78 37                	js     8008a8 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800871:	83 ec 08             	sub    $0x8,%esp
  800874:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800877:	50                   	push   %eax
  800878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80087b:	ff 30                	pushl  (%eax)
  80087d:	e8 45 fc ff ff       	call   8004c7 <dev_lookup>
  800882:	83 c4 10             	add    $0x10,%esp
  800885:	85 c0                	test   %eax,%eax
  800887:	78 1f                	js     8008a8 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800890:	74 1b                	je     8008ad <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  800892:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800895:	8b 52 18             	mov    0x18(%edx),%edx
  800898:	85 d2                	test   %edx,%edx
  80089a:	74 32                	je     8008ce <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  80089c:	83 ec 08             	sub    $0x8,%esp
  80089f:	ff 75 0c             	pushl  0xc(%ebp)
  8008a2:	50                   	push   %eax
  8008a3:	ff d2                	call   *%edx
  8008a5:	83 c4 10             	add    $0x10,%esp
}
  8008a8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ab:	c9                   	leave  
  8008ac:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008ad:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008b2:	8b 40 48             	mov    0x48(%eax),%eax
  8008b5:	83 ec 04             	sub    $0x4,%esp
  8008b8:	53                   	push   %ebx
  8008b9:	50                   	push   %eax
  8008ba:	68 58 1f 80 00       	push   $0x801f58
  8008bf:	e8 54 09 00 00       	call   801218 <cprintf>
		return -E_INVAL;
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008cc:	eb da                	jmp    8008a8 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008ce:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008d3:	eb d3                	jmp    8008a8 <ftruncate+0x52>

008008d5 <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008d5:	55                   	push   %ebp
  8008d6:	89 e5                	mov    %esp,%ebp
  8008d8:	53                   	push   %ebx
  8008d9:	83 ec 14             	sub    $0x14,%esp
  8008dc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008df:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008e2:	50                   	push   %eax
  8008e3:	ff 75 08             	pushl  0x8(%ebp)
  8008e6:	e8 85 fb ff ff       	call   800470 <fd_lookup>
  8008eb:	83 c4 08             	add    $0x8,%esp
  8008ee:	85 c0                	test   %eax,%eax
  8008f0:	78 4b                	js     80093d <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008f2:	83 ec 08             	sub    $0x8,%esp
  8008f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8008f8:	50                   	push   %eax
  8008f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008fc:	ff 30                	pushl  (%eax)
  8008fe:	e8 c4 fb ff ff       	call   8004c7 <dev_lookup>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	85 c0                	test   %eax,%eax
  800908:	78 33                	js     80093d <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  80090a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80090d:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800911:	74 2f                	je     800942 <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  800913:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  800916:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  80091d:	00 00 00 
	stat->st_type = 0;
  800920:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  800927:	00 00 00 
	stat->st_dev = dev;
  80092a:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800930:	83 ec 08             	sub    $0x8,%esp
  800933:	53                   	push   %ebx
  800934:	ff 75 f0             	pushl  -0x10(%ebp)
  800937:	ff 50 14             	call   *0x14(%eax)
  80093a:	83 c4 10             	add    $0x10,%esp
}
  80093d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800940:	c9                   	leave  
  800941:	c3                   	ret    
		return -E_NOT_SUPP;
  800942:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800947:	eb f4                	jmp    80093d <fstat+0x68>

00800949 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800949:	55                   	push   %ebp
  80094a:	89 e5                	mov    %esp,%ebp
  80094c:	56                   	push   %esi
  80094d:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  80094e:	83 ec 08             	sub    $0x8,%esp
  800951:	6a 00                	push   $0x0
  800953:	ff 75 08             	pushl  0x8(%ebp)
  800956:	e8 34 02 00 00       	call   800b8f <open>
  80095b:	89 c3                	mov    %eax,%ebx
  80095d:	83 c4 10             	add    $0x10,%esp
  800960:	85 c0                	test   %eax,%eax
  800962:	78 1b                	js     80097f <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  800964:	83 ec 08             	sub    $0x8,%esp
  800967:	ff 75 0c             	pushl  0xc(%ebp)
  80096a:	50                   	push   %eax
  80096b:	e8 65 ff ff ff       	call   8008d5 <fstat>
  800970:	89 c6                	mov    %eax,%esi
	close(fd);
  800972:	89 1c 24             	mov    %ebx,(%esp)
  800975:	e8 29 fc ff ff       	call   8005a3 <close>
	return r;
  80097a:	83 c4 10             	add    $0x10,%esp
  80097d:	89 f3                	mov    %esi,%ebx
}
  80097f:	89 d8                	mov    %ebx,%eax
  800981:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800984:	5b                   	pop    %ebx
  800985:	5e                   	pop    %esi
  800986:	5d                   	pop    %ebp
  800987:	c3                   	ret    

00800988 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800988:	55                   	push   %ebp
  800989:	89 e5                	mov    %esp,%ebp
  80098b:	56                   	push   %esi
  80098c:	53                   	push   %ebx
  80098d:	89 c6                	mov    %eax,%esi
  80098f:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800991:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  800998:	74 27                	je     8009c1 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  80099a:	6a 07                	push   $0x7
  80099c:	68 00 50 80 00       	push   $0x805000
  8009a1:	56                   	push   %esi
  8009a2:	ff 35 00 40 80 00    	pushl  0x804000
  8009a8:	e8 14 12 00 00       	call   801bc1 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009ad:	83 c4 0c             	add    $0xc,%esp
  8009b0:	6a 00                	push   $0x0
  8009b2:	53                   	push   %ebx
  8009b3:	6a 00                	push   $0x0
  8009b5:	e8 7e 11 00 00       	call   801b38 <ipc_recv>
}
  8009ba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009bd:	5b                   	pop    %ebx
  8009be:	5e                   	pop    %esi
  8009bf:	5d                   	pop    %ebp
  8009c0:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009c1:	83 ec 0c             	sub    $0xc,%esp
  8009c4:	6a 01                	push   $0x1
  8009c6:	e8 52 12 00 00       	call   801c1d <ipc_find_env>
  8009cb:	a3 00 40 80 00       	mov    %eax,0x804000
  8009d0:	83 c4 10             	add    $0x10,%esp
  8009d3:	eb c5                	jmp    80099a <fsipc+0x12>

008009d5 <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009d5:	55                   	push   %ebp
  8009d6:	89 e5                	mov    %esp,%ebp
  8009d8:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009db:	8b 45 08             	mov    0x8(%ebp),%eax
  8009de:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e1:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e9:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8009f3:	b8 02 00 00 00       	mov    $0x2,%eax
  8009f8:	e8 8b ff ff ff       	call   800988 <fsipc>
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <devfile_flush>:
{
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a05:	8b 45 08             	mov    0x8(%ebp),%eax
  800a08:	8b 40 0c             	mov    0xc(%eax),%eax
  800a0b:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a10:	ba 00 00 00 00       	mov    $0x0,%edx
  800a15:	b8 06 00 00 00       	mov    $0x6,%eax
  800a1a:	e8 69 ff ff ff       	call   800988 <fsipc>
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <devfile_stat>:
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	53                   	push   %ebx
  800a25:	83 ec 04             	sub    $0x4,%esp
  800a28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2e:	8b 40 0c             	mov    0xc(%eax),%eax
  800a31:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a36:	ba 00 00 00 00       	mov    $0x0,%edx
  800a3b:	b8 05 00 00 00       	mov    $0x5,%eax
  800a40:	e8 43 ff ff ff       	call   800988 <fsipc>
  800a45:	85 c0                	test   %eax,%eax
  800a47:	78 2c                	js     800a75 <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	68 00 50 80 00       	push   $0x805000
  800a51:	53                   	push   %ebx
  800a52:	e8 c9 0d 00 00       	call   801820 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a57:	a1 80 50 80 00       	mov    0x805080,%eax
  800a5c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a62:	a1 84 50 80 00       	mov    0x805084,%eax
  800a67:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a6d:	83 c4 10             	add    $0x10,%esp
  800a70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a75:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <devfile_write>:
{
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	53                   	push   %ebx
  800a7e:	83 ec 04             	sub    $0x4,%esp
  800a81:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a84:	89 d8                	mov    %ebx,%eax
  800a86:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a8c:	76 05                	jbe    800a93 <devfile_write+0x19>
  800a8e:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a93:	8b 55 08             	mov    0x8(%ebp),%edx
  800a96:	8b 52 0c             	mov    0xc(%edx),%edx
  800a99:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800a9f:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800aa4:	83 ec 04             	sub    $0x4,%esp
  800aa7:	50                   	push   %eax
  800aa8:	ff 75 0c             	pushl  0xc(%ebp)
  800aab:	68 08 50 80 00       	push   $0x805008
  800ab0:	e8 de 0e 00 00       	call   801993 <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800ab5:	ba 00 00 00 00       	mov    $0x0,%edx
  800aba:	b8 04 00 00 00       	mov    $0x4,%eax
  800abf:	e8 c4 fe ff ff       	call   800988 <fsipc>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	85 c0                	test   %eax,%eax
  800ac9:	78 0b                	js     800ad6 <devfile_write+0x5c>
	assert(r <= n);
  800acb:	39 c3                	cmp    %eax,%ebx
  800acd:	72 0c                	jb     800adb <devfile_write+0x61>
	assert(r <= PGSIZE);
  800acf:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800ad4:	7f 1e                	jg     800af4 <devfile_write+0x7a>
}
  800ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ad9:	c9                   	leave  
  800ada:	c3                   	ret    
	assert(r <= n);
  800adb:	68 c4 1f 80 00       	push   $0x801fc4
  800ae0:	68 cb 1f 80 00       	push   $0x801fcb
  800ae5:	68 98 00 00 00       	push   $0x98
  800aea:	68 e0 1f 80 00       	push   $0x801fe0
  800aef:	e8 11 06 00 00       	call   801105 <_panic>
	assert(r <= PGSIZE);
  800af4:	68 eb 1f 80 00       	push   $0x801feb
  800af9:	68 cb 1f 80 00       	push   $0x801fcb
  800afe:	68 99 00 00 00       	push   $0x99
  800b03:	68 e0 1f 80 00       	push   $0x801fe0
  800b08:	e8 f8 05 00 00       	call   801105 <_panic>

00800b0d <devfile_read>:
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	56                   	push   %esi
  800b11:	53                   	push   %ebx
  800b12:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8b 40 0c             	mov    0xc(%eax),%eax
  800b1b:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b20:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b26:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2b:	b8 03 00 00 00       	mov    $0x3,%eax
  800b30:	e8 53 fe ff ff       	call   800988 <fsipc>
  800b35:	89 c3                	mov    %eax,%ebx
  800b37:	85 c0                	test   %eax,%eax
  800b39:	78 1f                	js     800b5a <devfile_read+0x4d>
	assert(r <= n);
  800b3b:	39 c6                	cmp    %eax,%esi
  800b3d:	72 24                	jb     800b63 <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b3f:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b44:	7f 33                	jg     800b79 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b46:	83 ec 04             	sub    $0x4,%esp
  800b49:	50                   	push   %eax
  800b4a:	68 00 50 80 00       	push   $0x805000
  800b4f:	ff 75 0c             	pushl  0xc(%ebp)
  800b52:	e8 3c 0e 00 00       	call   801993 <memmove>
	return r;
  800b57:	83 c4 10             	add    $0x10,%esp
}
  800b5a:	89 d8                	mov    %ebx,%eax
  800b5c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b5f:	5b                   	pop    %ebx
  800b60:	5e                   	pop    %esi
  800b61:	5d                   	pop    %ebp
  800b62:	c3                   	ret    
	assert(r <= n);
  800b63:	68 c4 1f 80 00       	push   $0x801fc4
  800b68:	68 cb 1f 80 00       	push   $0x801fcb
  800b6d:	6a 7c                	push   $0x7c
  800b6f:	68 e0 1f 80 00       	push   $0x801fe0
  800b74:	e8 8c 05 00 00       	call   801105 <_panic>
	assert(r <= PGSIZE);
  800b79:	68 eb 1f 80 00       	push   $0x801feb
  800b7e:	68 cb 1f 80 00       	push   $0x801fcb
  800b83:	6a 7d                	push   $0x7d
  800b85:	68 e0 1f 80 00       	push   $0x801fe0
  800b8a:	e8 76 05 00 00       	call   801105 <_panic>

00800b8f <open>:
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	56                   	push   %esi
  800b93:	53                   	push   %ebx
  800b94:	83 ec 1c             	sub    $0x1c,%esp
  800b97:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800b9a:	56                   	push   %esi
  800b9b:	e8 4d 0c 00 00       	call   8017ed <strlen>
  800ba0:	83 c4 10             	add    $0x10,%esp
  800ba3:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800ba8:	7f 6c                	jg     800c16 <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800baa:	83 ec 0c             	sub    $0xc,%esp
  800bad:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bb0:	50                   	push   %eax
  800bb1:	e8 6b f8 ff ff       	call   800421 <fd_alloc>
  800bb6:	89 c3                	mov    %eax,%ebx
  800bb8:	83 c4 10             	add    $0x10,%esp
  800bbb:	85 c0                	test   %eax,%eax
  800bbd:	78 3c                	js     800bfb <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bbf:	83 ec 08             	sub    $0x8,%esp
  800bc2:	56                   	push   %esi
  800bc3:	68 00 50 80 00       	push   $0x805000
  800bc8:	e8 53 0c 00 00       	call   801820 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bd8:	b8 01 00 00 00       	mov    $0x1,%eax
  800bdd:	e8 a6 fd ff ff       	call   800988 <fsipc>
  800be2:	89 c3                	mov    %eax,%ebx
  800be4:	83 c4 10             	add    $0x10,%esp
  800be7:	85 c0                	test   %eax,%eax
  800be9:	78 19                	js     800c04 <open+0x75>
	return fd2num(fd);
  800beb:	83 ec 0c             	sub    $0xc,%esp
  800bee:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf1:	e8 04 f8 ff ff       	call   8003fa <fd2num>
  800bf6:	89 c3                	mov    %eax,%ebx
  800bf8:	83 c4 10             	add    $0x10,%esp
}
  800bfb:	89 d8                	mov    %ebx,%eax
  800bfd:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c00:	5b                   	pop    %ebx
  800c01:	5e                   	pop    %esi
  800c02:	5d                   	pop    %ebp
  800c03:	c3                   	ret    
		fd_close(fd, 0);
  800c04:	83 ec 08             	sub    $0x8,%esp
  800c07:	6a 00                	push   $0x0
  800c09:	ff 75 f4             	pushl  -0xc(%ebp)
  800c0c:	e8 0c f9 ff ff       	call   80051d <fd_close>
		return r;
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	eb e5                	jmp    800bfb <open+0x6c>
		return -E_BAD_PATH;
  800c16:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c1b:	eb de                	jmp    800bfb <open+0x6c>

00800c1d <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c1d:	55                   	push   %ebp
  800c1e:	89 e5                	mov    %esp,%ebp
  800c20:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c23:	ba 00 00 00 00       	mov    $0x0,%edx
  800c28:	b8 08 00 00 00       	mov    $0x8,%eax
  800c2d:	e8 56 fd ff ff       	call   800988 <fsipc>
}
  800c32:	c9                   	leave  
  800c33:	c3                   	ret    

00800c34 <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c34:	55                   	push   %ebp
  800c35:	89 e5                	mov    %esp,%ebp
  800c37:	56                   	push   %esi
  800c38:	53                   	push   %ebx
  800c39:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c3c:	83 ec 0c             	sub    $0xc,%esp
  800c3f:	ff 75 08             	pushl  0x8(%ebp)
  800c42:	e8 c3 f7 ff ff       	call   80040a <fd2data>
  800c47:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c49:	83 c4 08             	add    $0x8,%esp
  800c4c:	68 f7 1f 80 00       	push   $0x801ff7
  800c51:	53                   	push   %ebx
  800c52:	e8 c9 0b 00 00       	call   801820 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c57:	8b 46 04             	mov    0x4(%esi),%eax
  800c5a:	2b 06                	sub    (%esi),%eax
  800c5c:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c62:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c69:	10 00 00 
	stat->st_dev = &devpipe;
  800c6c:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c73:	30 80 00 
	return 0;
}
  800c76:	b8 00 00 00 00       	mov    $0x0,%eax
  800c7b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c7e:	5b                   	pop    %ebx
  800c7f:	5e                   	pop    %esi
  800c80:	5d                   	pop    %ebp
  800c81:	c3                   	ret    

00800c82 <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c82:	55                   	push   %ebp
  800c83:	89 e5                	mov    %esp,%ebp
  800c85:	53                   	push   %ebx
  800c86:	83 ec 0c             	sub    $0xc,%esp
  800c89:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c8c:	53                   	push   %ebx
  800c8d:	6a 00                	push   $0x0
  800c8f:	e8 36 f5 ff ff       	call   8001ca <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c94:	89 1c 24             	mov    %ebx,(%esp)
  800c97:	e8 6e f7 ff ff       	call   80040a <fd2data>
  800c9c:	83 c4 08             	add    $0x8,%esp
  800c9f:	50                   	push   %eax
  800ca0:	6a 00                	push   $0x0
  800ca2:	e8 23 f5 ff ff       	call   8001ca <sys_page_unmap>
}
  800ca7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800caa:	c9                   	leave  
  800cab:	c3                   	ret    

00800cac <_pipeisclosed>:
{
  800cac:	55                   	push   %ebp
  800cad:	89 e5                	mov    %esp,%ebp
  800caf:	57                   	push   %edi
  800cb0:	56                   	push   %esi
  800cb1:	53                   	push   %ebx
  800cb2:	83 ec 1c             	sub    $0x1c,%esp
  800cb5:	89 c7                	mov    %eax,%edi
  800cb7:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cb9:	a1 04 40 80 00       	mov    0x804004,%eax
  800cbe:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cc1:	83 ec 0c             	sub    $0xc,%esp
  800cc4:	57                   	push   %edi
  800cc5:	e8 95 0f 00 00       	call   801c5f <pageref>
  800cca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ccd:	89 34 24             	mov    %esi,(%esp)
  800cd0:	e8 8a 0f 00 00       	call   801c5f <pageref>
		nn = thisenv->env_runs;
  800cd5:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800cdb:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800cde:	83 c4 10             	add    $0x10,%esp
  800ce1:	39 cb                	cmp    %ecx,%ebx
  800ce3:	74 1b                	je     800d00 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800ce5:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800ce8:	75 cf                	jne    800cb9 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800cea:	8b 42 58             	mov    0x58(%edx),%eax
  800ced:	6a 01                	push   $0x1
  800cef:	50                   	push   %eax
  800cf0:	53                   	push   %ebx
  800cf1:	68 fe 1f 80 00       	push   $0x801ffe
  800cf6:	e8 1d 05 00 00       	call   801218 <cprintf>
  800cfb:	83 c4 10             	add    $0x10,%esp
  800cfe:	eb b9                	jmp    800cb9 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d00:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d03:	0f 94 c0             	sete   %al
  800d06:	0f b6 c0             	movzbl %al,%eax
}
  800d09:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d0c:	5b                   	pop    %ebx
  800d0d:	5e                   	pop    %esi
  800d0e:	5f                   	pop    %edi
  800d0f:	5d                   	pop    %ebp
  800d10:	c3                   	ret    

00800d11 <devpipe_write>:
{
  800d11:	55                   	push   %ebp
  800d12:	89 e5                	mov    %esp,%ebp
  800d14:	57                   	push   %edi
  800d15:	56                   	push   %esi
  800d16:	53                   	push   %ebx
  800d17:	83 ec 18             	sub    $0x18,%esp
  800d1a:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d1d:	56                   	push   %esi
  800d1e:	e8 e7 f6 ff ff       	call   80040a <fd2data>
  800d23:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d25:	83 c4 10             	add    $0x10,%esp
  800d28:	bf 00 00 00 00       	mov    $0x0,%edi
  800d2d:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d30:	74 41                	je     800d73 <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d32:	8b 53 04             	mov    0x4(%ebx),%edx
  800d35:	8b 03                	mov    (%ebx),%eax
  800d37:	83 c0 20             	add    $0x20,%eax
  800d3a:	39 c2                	cmp    %eax,%edx
  800d3c:	72 14                	jb     800d52 <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d3e:	89 da                	mov    %ebx,%edx
  800d40:	89 f0                	mov    %esi,%eax
  800d42:	e8 65 ff ff ff       	call   800cac <_pipeisclosed>
  800d47:	85 c0                	test   %eax,%eax
  800d49:	75 2c                	jne    800d77 <devpipe_write+0x66>
			sys_yield();
  800d4b:	e8 bc f4 ff ff       	call   80020c <sys_yield>
  800d50:	eb e0                	jmp    800d32 <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d58:	89 d0                	mov    %edx,%eax
  800d5a:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d5f:	78 0b                	js     800d6c <devpipe_write+0x5b>
  800d61:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d65:	42                   	inc    %edx
  800d66:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d69:	47                   	inc    %edi
  800d6a:	eb c1                	jmp    800d2d <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d6c:	48                   	dec    %eax
  800d6d:	83 c8 e0             	or     $0xffffffe0,%eax
  800d70:	40                   	inc    %eax
  800d71:	eb ee                	jmp    800d61 <devpipe_write+0x50>
	return i;
  800d73:	89 f8                	mov    %edi,%eax
  800d75:	eb 05                	jmp    800d7c <devpipe_write+0x6b>
				return 0;
  800d77:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d7f:	5b                   	pop    %ebx
  800d80:	5e                   	pop    %esi
  800d81:	5f                   	pop    %edi
  800d82:	5d                   	pop    %ebp
  800d83:	c3                   	ret    

00800d84 <devpipe_read>:
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	57                   	push   %edi
  800d88:	56                   	push   %esi
  800d89:	53                   	push   %ebx
  800d8a:	83 ec 18             	sub    $0x18,%esp
  800d8d:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d90:	57                   	push   %edi
  800d91:	e8 74 f6 ff ff       	call   80040a <fd2data>
  800d96:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800d98:	83 c4 10             	add    $0x10,%esp
  800d9b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da0:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800da3:	74 46                	je     800deb <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800da5:	8b 06                	mov    (%esi),%eax
  800da7:	3b 46 04             	cmp    0x4(%esi),%eax
  800daa:	75 22                	jne    800dce <devpipe_read+0x4a>
			if (i > 0)
  800dac:	85 db                	test   %ebx,%ebx
  800dae:	74 0a                	je     800dba <devpipe_read+0x36>
				return i;
  800db0:	89 d8                	mov    %ebx,%eax
}
  800db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800db5:	5b                   	pop    %ebx
  800db6:	5e                   	pop    %esi
  800db7:	5f                   	pop    %edi
  800db8:	5d                   	pop    %ebp
  800db9:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800dba:	89 f2                	mov    %esi,%edx
  800dbc:	89 f8                	mov    %edi,%eax
  800dbe:	e8 e9 fe ff ff       	call   800cac <_pipeisclosed>
  800dc3:	85 c0                	test   %eax,%eax
  800dc5:	75 28                	jne    800def <devpipe_read+0x6b>
			sys_yield();
  800dc7:	e8 40 f4 ff ff       	call   80020c <sys_yield>
  800dcc:	eb d7                	jmp    800da5 <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dce:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800dd3:	78 0f                	js     800de4 <devpipe_read+0x60>
  800dd5:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800dd9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800ddc:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800ddf:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800de1:	43                   	inc    %ebx
  800de2:	eb bc                	jmp    800da0 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800de4:	48                   	dec    %eax
  800de5:	83 c8 e0             	or     $0xffffffe0,%eax
  800de8:	40                   	inc    %eax
  800de9:	eb ea                	jmp    800dd5 <devpipe_read+0x51>
	return i;
  800deb:	89 d8                	mov    %ebx,%eax
  800ded:	eb c3                	jmp    800db2 <devpipe_read+0x2e>
				return 0;
  800def:	b8 00 00 00 00       	mov    $0x0,%eax
  800df4:	eb bc                	jmp    800db2 <devpipe_read+0x2e>

00800df6 <pipe>:
{
  800df6:	55                   	push   %ebp
  800df7:	89 e5                	mov    %esp,%ebp
  800df9:	56                   	push   %esi
  800dfa:	53                   	push   %ebx
  800dfb:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800dfe:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e01:	50                   	push   %eax
  800e02:	e8 1a f6 ff ff       	call   800421 <fd_alloc>
  800e07:	89 c3                	mov    %eax,%ebx
  800e09:	83 c4 10             	add    $0x10,%esp
  800e0c:	85 c0                	test   %eax,%eax
  800e0e:	0f 88 2a 01 00 00    	js     800f3e <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e14:	83 ec 04             	sub    $0x4,%esp
  800e17:	68 07 04 00 00       	push   $0x407
  800e1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800e1f:	6a 00                	push   $0x0
  800e21:	e8 1f f3 ff ff       	call   800145 <sys_page_alloc>
  800e26:	89 c3                	mov    %eax,%ebx
  800e28:	83 c4 10             	add    $0x10,%esp
  800e2b:	85 c0                	test   %eax,%eax
  800e2d:	0f 88 0b 01 00 00    	js     800f3e <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e33:	83 ec 0c             	sub    $0xc,%esp
  800e36:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e39:	50                   	push   %eax
  800e3a:	e8 e2 f5 ff ff       	call   800421 <fd_alloc>
  800e3f:	89 c3                	mov    %eax,%ebx
  800e41:	83 c4 10             	add    $0x10,%esp
  800e44:	85 c0                	test   %eax,%eax
  800e46:	0f 88 e2 00 00 00    	js     800f2e <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e4c:	83 ec 04             	sub    $0x4,%esp
  800e4f:	68 07 04 00 00       	push   $0x407
  800e54:	ff 75 f0             	pushl  -0x10(%ebp)
  800e57:	6a 00                	push   $0x0
  800e59:	e8 e7 f2 ff ff       	call   800145 <sys_page_alloc>
  800e5e:	89 c3                	mov    %eax,%ebx
  800e60:	83 c4 10             	add    $0x10,%esp
  800e63:	85 c0                	test   %eax,%eax
  800e65:	0f 88 c3 00 00 00    	js     800f2e <pipe+0x138>
	va = fd2data(fd0);
  800e6b:	83 ec 0c             	sub    $0xc,%esp
  800e6e:	ff 75 f4             	pushl  -0xc(%ebp)
  800e71:	e8 94 f5 ff ff       	call   80040a <fd2data>
  800e76:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e78:	83 c4 0c             	add    $0xc,%esp
  800e7b:	68 07 04 00 00       	push   $0x407
  800e80:	50                   	push   %eax
  800e81:	6a 00                	push   $0x0
  800e83:	e8 bd f2 ff ff       	call   800145 <sys_page_alloc>
  800e88:	89 c3                	mov    %eax,%ebx
  800e8a:	83 c4 10             	add    $0x10,%esp
  800e8d:	85 c0                	test   %eax,%eax
  800e8f:	0f 88 89 00 00 00    	js     800f1e <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e95:	83 ec 0c             	sub    $0xc,%esp
  800e98:	ff 75 f0             	pushl  -0x10(%ebp)
  800e9b:	e8 6a f5 ff ff       	call   80040a <fd2data>
  800ea0:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800ea7:	50                   	push   %eax
  800ea8:	6a 00                	push   $0x0
  800eaa:	56                   	push   %esi
  800eab:	6a 00                	push   $0x0
  800ead:	e8 d6 f2 ff ff       	call   800188 <sys_page_map>
  800eb2:	89 c3                	mov    %eax,%ebx
  800eb4:	83 c4 20             	add    $0x20,%esp
  800eb7:	85 c0                	test   %eax,%eax
  800eb9:	78 55                	js     800f10 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ebb:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ec1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec4:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ec9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ed0:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ed6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ed9:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800edb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ede:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800ee5:	83 ec 0c             	sub    $0xc,%esp
  800ee8:	ff 75 f4             	pushl  -0xc(%ebp)
  800eeb:	e8 0a f5 ff ff       	call   8003fa <fd2num>
  800ef0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef3:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800ef5:	83 c4 04             	add    $0x4,%esp
  800ef8:	ff 75 f0             	pushl  -0x10(%ebp)
  800efb:	e8 fa f4 ff ff       	call   8003fa <fd2num>
  800f00:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f03:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f06:	83 c4 10             	add    $0x10,%esp
  800f09:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f0e:	eb 2e                	jmp    800f3e <pipe+0x148>
	sys_page_unmap(0, va);
  800f10:	83 ec 08             	sub    $0x8,%esp
  800f13:	56                   	push   %esi
  800f14:	6a 00                	push   $0x0
  800f16:	e8 af f2 ff ff       	call   8001ca <sys_page_unmap>
  800f1b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f1e:	83 ec 08             	sub    $0x8,%esp
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	6a 00                	push   $0x0
  800f26:	e8 9f f2 ff ff       	call   8001ca <sys_page_unmap>
  800f2b:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f2e:	83 ec 08             	sub    $0x8,%esp
  800f31:	ff 75 f4             	pushl  -0xc(%ebp)
  800f34:	6a 00                	push   $0x0
  800f36:	e8 8f f2 ff ff       	call   8001ca <sys_page_unmap>
  800f3b:	83 c4 10             	add    $0x10,%esp
}
  800f3e:	89 d8                	mov    %ebx,%eax
  800f40:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f43:	5b                   	pop    %ebx
  800f44:	5e                   	pop    %esi
  800f45:	5d                   	pop    %ebp
  800f46:	c3                   	ret    

00800f47 <pipeisclosed>:
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f4d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f50:	50                   	push   %eax
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 17 f5 ff ff       	call   800470 <fd_lookup>
  800f59:	83 c4 10             	add    $0x10,%esp
  800f5c:	85 c0                	test   %eax,%eax
  800f5e:	78 18                	js     800f78 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f60:	83 ec 0c             	sub    $0xc,%esp
  800f63:	ff 75 f4             	pushl  -0xc(%ebp)
  800f66:	e8 9f f4 ff ff       	call   80040a <fd2data>
	return _pipeisclosed(fd, p);
  800f6b:	89 c2                	mov    %eax,%edx
  800f6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f70:	e8 37 fd ff ff       	call   800cac <_pipeisclosed>
  800f75:	83 c4 10             	add    $0x10,%esp
}
  800f78:	c9                   	leave  
  800f79:	c3                   	ret    

00800f7a <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f7a:	55                   	push   %ebp
  800f7b:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
  800f82:	5d                   	pop    %ebp
  800f83:	c3                   	ret    

00800f84 <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	53                   	push   %ebx
  800f88:	83 ec 0c             	sub    $0xc,%esp
  800f8b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f8e:	68 16 20 80 00       	push   $0x802016
  800f93:	53                   	push   %ebx
  800f94:	e8 87 08 00 00       	call   801820 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800f99:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fa0:	20 00 00 
	return 0;
}
  800fa3:	b8 00 00 00 00       	mov    $0x0,%eax
  800fa8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fab:	c9                   	leave  
  800fac:	c3                   	ret    

00800fad <devcons_write>:
{
  800fad:	55                   	push   %ebp
  800fae:	89 e5                	mov    %esp,%ebp
  800fb0:	57                   	push   %edi
  800fb1:	56                   	push   %esi
  800fb2:	53                   	push   %ebx
  800fb3:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fb9:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fbe:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fc4:	eb 1d                	jmp    800fe3 <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fc6:	83 ec 04             	sub    $0x4,%esp
  800fc9:	53                   	push   %ebx
  800fca:	03 45 0c             	add    0xc(%ebp),%eax
  800fcd:	50                   	push   %eax
  800fce:	57                   	push   %edi
  800fcf:	e8 bf 09 00 00       	call   801993 <memmove>
		sys_cputs(buf, m);
  800fd4:	83 c4 08             	add    $0x8,%esp
  800fd7:	53                   	push   %ebx
  800fd8:	57                   	push   %edi
  800fd9:	e8 ca f0 ff ff       	call   8000a8 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fde:	01 de                	add    %ebx,%esi
  800fe0:	83 c4 10             	add    $0x10,%esp
  800fe3:	89 f0                	mov    %esi,%eax
  800fe5:	3b 75 10             	cmp    0x10(%ebp),%esi
  800fe8:	73 11                	jae    800ffb <devcons_write+0x4e>
		m = n - tot;
  800fea:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800fed:	29 f3                	sub    %esi,%ebx
  800fef:	83 fb 7f             	cmp    $0x7f,%ebx
  800ff2:	76 d2                	jbe    800fc6 <devcons_write+0x19>
  800ff4:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  800ff9:	eb cb                	jmp    800fc6 <devcons_write+0x19>
}
  800ffb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800ffe:	5b                   	pop    %ebx
  800fff:	5e                   	pop    %esi
  801000:	5f                   	pop    %edi
  801001:	5d                   	pop    %ebp
  801002:	c3                   	ret    

00801003 <devcons_read>:
{
  801003:	55                   	push   %ebp
  801004:	89 e5                	mov    %esp,%ebp
  801006:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801009:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100d:	75 0c                	jne    80101b <devcons_read+0x18>
		return 0;
  80100f:	b8 00 00 00 00       	mov    $0x0,%eax
  801014:	eb 21                	jmp    801037 <devcons_read+0x34>
		sys_yield();
  801016:	e8 f1 f1 ff ff       	call   80020c <sys_yield>
	while ((c = sys_cgetc()) == 0)
  80101b:	e8 a6 f0 ff ff       	call   8000c6 <sys_cgetc>
  801020:	85 c0                	test   %eax,%eax
  801022:	74 f2                	je     801016 <devcons_read+0x13>
	if (c < 0)
  801024:	85 c0                	test   %eax,%eax
  801026:	78 0f                	js     801037 <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801028:	83 f8 04             	cmp    $0x4,%eax
  80102b:	74 0c                	je     801039 <devcons_read+0x36>
	*(char*)vbuf = c;
  80102d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801030:	88 02                	mov    %al,(%edx)
	return 1;
  801032:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    
		return 0;
  801039:	b8 00 00 00 00       	mov    $0x0,%eax
  80103e:	eb f7                	jmp    801037 <devcons_read+0x34>

00801040 <cputchar>:
{
  801040:	55                   	push   %ebp
  801041:	89 e5                	mov    %esp,%ebp
  801043:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  801046:	8b 45 08             	mov    0x8(%ebp),%eax
  801049:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  80104c:	6a 01                	push   $0x1
  80104e:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801051:	50                   	push   %eax
  801052:	e8 51 f0 ff ff       	call   8000a8 <sys_cputs>
}
  801057:	83 c4 10             	add    $0x10,%esp
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <getchar>:
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  801062:	6a 01                	push   $0x1
  801064:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801067:	50                   	push   %eax
  801068:	6a 00                	push   $0x0
  80106a:	e8 6e f6 ff ff       	call   8006dd <read>
	if (r < 0)
  80106f:	83 c4 10             	add    $0x10,%esp
  801072:	85 c0                	test   %eax,%eax
  801074:	78 08                	js     80107e <getchar+0x22>
	if (r < 1)
  801076:	85 c0                	test   %eax,%eax
  801078:	7e 06                	jle    801080 <getchar+0x24>
	return c;
  80107a:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  80107e:	c9                   	leave  
  80107f:	c3                   	ret    
		return -E_EOF;
  801080:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  801085:	eb f7                	jmp    80107e <getchar+0x22>

00801087 <iscons>:
{
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80108d:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801090:	50                   	push   %eax
  801091:	ff 75 08             	pushl  0x8(%ebp)
  801094:	e8 d7 f3 ff ff       	call   800470 <fd_lookup>
  801099:	83 c4 10             	add    $0x10,%esp
  80109c:	85 c0                	test   %eax,%eax
  80109e:	78 11                	js     8010b1 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010a3:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010a9:	39 10                	cmp    %edx,(%eax)
  8010ab:	0f 94 c0             	sete   %al
  8010ae:	0f b6 c0             	movzbl %al,%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    

008010b3 <opencons>:
{
  8010b3:	55                   	push   %ebp
  8010b4:	89 e5                	mov    %esp,%ebp
  8010b6:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010bc:	50                   	push   %eax
  8010bd:	e8 5f f3 ff ff       	call   800421 <fd_alloc>
  8010c2:	83 c4 10             	add    $0x10,%esp
  8010c5:	85 c0                	test   %eax,%eax
  8010c7:	78 3a                	js     801103 <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010c9:	83 ec 04             	sub    $0x4,%esp
  8010cc:	68 07 04 00 00       	push   $0x407
  8010d1:	ff 75 f4             	pushl  -0xc(%ebp)
  8010d4:	6a 00                	push   $0x0
  8010d6:	e8 6a f0 ff ff       	call   800145 <sys_page_alloc>
  8010db:	83 c4 10             	add    $0x10,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	78 21                	js     801103 <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010e2:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010eb:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f0:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010f7:	83 ec 0c             	sub    $0xc,%esp
  8010fa:	50                   	push   %eax
  8010fb:	e8 fa f2 ff ff       	call   8003fa <fd2num>
  801100:	83 c4 10             	add    $0x10,%esp
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	57                   	push   %edi
  801109:	56                   	push   %esi
  80110a:	53                   	push   %ebx
  80110b:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801111:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  801114:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  80111a:	e8 07 f0 ff ff       	call   800126 <sys_getenvid>
  80111f:	83 ec 04             	sub    $0x4,%esp
  801122:	ff 75 0c             	pushl  0xc(%ebp)
  801125:	ff 75 08             	pushl  0x8(%ebp)
  801128:	53                   	push   %ebx
  801129:	50                   	push   %eax
  80112a:	68 24 20 80 00       	push   $0x802024
  80112f:	68 00 01 00 00       	push   $0x100
  801134:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  80113a:	56                   	push   %esi
  80113b:	e8 93 06 00 00       	call   8017d3 <snprintf>
  801140:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  801142:	83 c4 20             	add    $0x20,%esp
  801145:	57                   	push   %edi
  801146:	ff 75 10             	pushl  0x10(%ebp)
  801149:	bf 00 01 00 00       	mov    $0x100,%edi
  80114e:	89 f8                	mov    %edi,%eax
  801150:	29 d8                	sub    %ebx,%eax
  801152:	50                   	push   %eax
  801153:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801156:	50                   	push   %eax
  801157:	e8 22 06 00 00       	call   80177e <vsnprintf>
  80115c:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80115e:	83 c4 0c             	add    $0xc,%esp
  801161:	68 0f 20 80 00       	push   $0x80200f
  801166:	29 df                	sub    %ebx,%edi
  801168:	57                   	push   %edi
  801169:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80116c:	50                   	push   %eax
  80116d:	e8 61 06 00 00       	call   8017d3 <snprintf>
	sys_cputs(buf, r);
  801172:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801175:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  801177:	53                   	push   %ebx
  801178:	56                   	push   %esi
  801179:	e8 2a ef ff ff       	call   8000a8 <sys_cputs>
  80117e:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801181:	cc                   	int3   
  801182:	eb fd                	jmp    801181 <_panic+0x7c>

00801184 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  801184:	55                   	push   %ebp
  801185:	89 e5                	mov    %esp,%ebp
  801187:	53                   	push   %ebx
  801188:	83 ec 04             	sub    $0x4,%esp
  80118b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  80118e:	8b 13                	mov    (%ebx),%edx
  801190:	8d 42 01             	lea    0x1(%edx),%eax
  801193:	89 03                	mov    %eax,(%ebx)
  801195:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801198:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  80119c:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a1:	74 08                	je     8011ab <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011a3:	ff 43 04             	incl   0x4(%ebx)
}
  8011a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011a9:	c9                   	leave  
  8011aa:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011ab:	83 ec 08             	sub    $0x8,%esp
  8011ae:	68 ff 00 00 00       	push   $0xff
  8011b3:	8d 43 08             	lea    0x8(%ebx),%eax
  8011b6:	50                   	push   %eax
  8011b7:	e8 ec ee ff ff       	call   8000a8 <sys_cputs>
		b->idx = 0;
  8011bc:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011c2:	83 c4 10             	add    $0x10,%esp
  8011c5:	eb dc                	jmp    8011a3 <putch+0x1f>

008011c7 <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011c7:	55                   	push   %ebp
  8011c8:	89 e5                	mov    %esp,%ebp
  8011ca:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011d0:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011d7:	00 00 00 
	b.cnt = 0;
  8011da:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011e1:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011e4:	ff 75 0c             	pushl  0xc(%ebp)
  8011e7:	ff 75 08             	pushl  0x8(%ebp)
  8011ea:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011f0:	50                   	push   %eax
  8011f1:	68 84 11 80 00       	push   $0x801184
  8011f6:	e8 17 01 00 00       	call   801312 <vprintfmt>
	sys_cputs(b.buf, b.idx);
  8011fb:	83 c4 08             	add    $0x8,%esp
  8011fe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  801204:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  80120a:	50                   	push   %eax
  80120b:	e8 98 ee ff ff       	call   8000a8 <sys_cputs>

	return b.cnt;
}
  801210:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  801216:	c9                   	leave  
  801217:	c3                   	ret    

00801218 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801218:	55                   	push   %ebp
  801219:	89 e5                	mov    %esp,%ebp
  80121b:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80121e:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801221:	50                   	push   %eax
  801222:	ff 75 08             	pushl  0x8(%ebp)
  801225:	e8 9d ff ff ff       	call   8011c7 <vcprintf>
	va_end(ap);

	return cnt;
}
  80122a:	c9                   	leave  
  80122b:	c3                   	ret    

0080122c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80122c:	55                   	push   %ebp
  80122d:	89 e5                	mov    %esp,%ebp
  80122f:	57                   	push   %edi
  801230:	56                   	push   %esi
  801231:	53                   	push   %ebx
  801232:	83 ec 1c             	sub    $0x1c,%esp
  801235:	89 c7                	mov    %eax,%edi
  801237:	89 d6                	mov    %edx,%esi
  801239:	8b 45 08             	mov    0x8(%ebp),%eax
  80123c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80123f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801242:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  801245:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801248:	bb 00 00 00 00       	mov    $0x0,%ebx
  80124d:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801250:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801253:	39 d3                	cmp    %edx,%ebx
  801255:	72 05                	jb     80125c <printnum+0x30>
  801257:	39 45 10             	cmp    %eax,0x10(%ebp)
  80125a:	77 78                	ja     8012d4 <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80125c:	83 ec 0c             	sub    $0xc,%esp
  80125f:	ff 75 18             	pushl  0x18(%ebp)
  801262:	8b 45 14             	mov    0x14(%ebp),%eax
  801265:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801268:	53                   	push   %ebx
  801269:	ff 75 10             	pushl  0x10(%ebp)
  80126c:	83 ec 08             	sub    $0x8,%esp
  80126f:	ff 75 e4             	pushl  -0x1c(%ebp)
  801272:	ff 75 e0             	pushl  -0x20(%ebp)
  801275:	ff 75 dc             	pushl  -0x24(%ebp)
  801278:	ff 75 d8             	pushl  -0x28(%ebp)
  80127b:	e8 24 0a 00 00       	call   801ca4 <__udivdi3>
  801280:	83 c4 18             	add    $0x18,%esp
  801283:	52                   	push   %edx
  801284:	50                   	push   %eax
  801285:	89 f2                	mov    %esi,%edx
  801287:	89 f8                	mov    %edi,%eax
  801289:	e8 9e ff ff ff       	call   80122c <printnum>
  80128e:	83 c4 20             	add    $0x20,%esp
  801291:	eb 11                	jmp    8012a4 <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  801293:	83 ec 08             	sub    $0x8,%esp
  801296:	56                   	push   %esi
  801297:	ff 75 18             	pushl  0x18(%ebp)
  80129a:	ff d7                	call   *%edi
  80129c:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  80129f:	4b                   	dec    %ebx
  8012a0:	85 db                	test   %ebx,%ebx
  8012a2:	7f ef                	jg     801293 <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012a4:	83 ec 08             	sub    $0x8,%esp
  8012a7:	56                   	push   %esi
  8012a8:	83 ec 04             	sub    $0x4,%esp
  8012ab:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012ae:	ff 75 e0             	pushl  -0x20(%ebp)
  8012b1:	ff 75 dc             	pushl  -0x24(%ebp)
  8012b4:	ff 75 d8             	pushl  -0x28(%ebp)
  8012b7:	e8 f8 0a 00 00       	call   801db4 <__umoddi3>
  8012bc:	83 c4 14             	add    $0x14,%esp
  8012bf:	0f be 80 47 20 80 00 	movsbl 0x802047(%eax),%eax
  8012c6:	50                   	push   %eax
  8012c7:	ff d7                	call   *%edi
}
  8012c9:	83 c4 10             	add    $0x10,%esp
  8012cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012cf:	5b                   	pop    %ebx
  8012d0:	5e                   	pop    %esi
  8012d1:	5f                   	pop    %edi
  8012d2:	5d                   	pop    %ebp
  8012d3:	c3                   	ret    
  8012d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012d7:	eb c6                	jmp    80129f <printnum+0x73>

008012d9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012d9:	55                   	push   %ebp
  8012da:	89 e5                	mov    %esp,%ebp
  8012dc:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012df:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012e2:	8b 10                	mov    (%eax),%edx
  8012e4:	3b 50 04             	cmp    0x4(%eax),%edx
  8012e7:	73 0a                	jae    8012f3 <sprintputch+0x1a>
		*b->buf++ = ch;
  8012e9:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012ec:	89 08                	mov    %ecx,(%eax)
  8012ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f1:	88 02                	mov    %al,(%edx)
}
  8012f3:	5d                   	pop    %ebp
  8012f4:	c3                   	ret    

008012f5 <printfmt>:
{
  8012f5:	55                   	push   %ebp
  8012f6:	89 e5                	mov    %esp,%ebp
  8012f8:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  8012fb:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  8012fe:	50                   	push   %eax
  8012ff:	ff 75 10             	pushl  0x10(%ebp)
  801302:	ff 75 0c             	pushl  0xc(%ebp)
  801305:	ff 75 08             	pushl  0x8(%ebp)
  801308:	e8 05 00 00 00       	call   801312 <vprintfmt>
}
  80130d:	83 c4 10             	add    $0x10,%esp
  801310:	c9                   	leave  
  801311:	c3                   	ret    

00801312 <vprintfmt>:
{
  801312:	55                   	push   %ebp
  801313:	89 e5                	mov    %esp,%ebp
  801315:	57                   	push   %edi
  801316:	56                   	push   %esi
  801317:	53                   	push   %ebx
  801318:	83 ec 2c             	sub    $0x2c,%esp
  80131b:	8b 75 08             	mov    0x8(%ebp),%esi
  80131e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801321:	8b 7d 10             	mov    0x10(%ebp),%edi
  801324:	e9 ae 03 00 00       	jmp    8016d7 <vprintfmt+0x3c5>
  801329:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  80132d:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  801334:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  80133b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  801342:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  801347:	8d 47 01             	lea    0x1(%edi),%eax
  80134a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80134d:	8a 17                	mov    (%edi),%dl
  80134f:	8d 42 dd             	lea    -0x23(%edx),%eax
  801352:	3c 55                	cmp    $0x55,%al
  801354:	0f 87 fe 03 00 00    	ja     801758 <vprintfmt+0x446>
  80135a:	0f b6 c0             	movzbl %al,%eax
  80135d:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  801364:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  801367:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  80136b:	eb da                	jmp    801347 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80136d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801370:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  801374:	eb d1                	jmp    801347 <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801376:	0f b6 d2             	movzbl %dl,%edx
  801379:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  80137c:	b8 00 00 00 00       	mov    $0x0,%eax
  801381:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  801384:	8d 04 80             	lea    (%eax,%eax,4),%eax
  801387:	01 c0                	add    %eax,%eax
  801389:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  80138d:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801390:	8d 4a d0             	lea    -0x30(%edx),%ecx
  801393:	83 f9 09             	cmp    $0x9,%ecx
  801396:	77 52                	ja     8013ea <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  801398:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  801399:	eb e9                	jmp    801384 <vprintfmt+0x72>
			precision = va_arg(ap, int);
  80139b:	8b 45 14             	mov    0x14(%ebp),%eax
  80139e:	8b 00                	mov    (%eax),%eax
  8013a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8d 40 04             	lea    0x4(%eax),%eax
  8013a9:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013ac:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013af:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013b3:	79 92                	jns    801347 <vprintfmt+0x35>
				width = precision, precision = -1;
  8013b5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013b8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013bb:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013c2:	eb 83                	jmp    801347 <vprintfmt+0x35>
  8013c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013c8:	78 08                	js     8013d2 <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013ca:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013cd:	e9 75 ff ff ff       	jmp    801347 <vprintfmt+0x35>
  8013d2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013d9:	eb ef                	jmp    8013ca <vprintfmt+0xb8>
  8013db:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013de:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013e5:	e9 5d ff ff ff       	jmp    801347 <vprintfmt+0x35>
  8013ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013ed:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013f0:	eb bd                	jmp    8013af <vprintfmt+0x9d>
			lflag++;
  8013f2:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013f6:	e9 4c ff ff ff       	jmp    801347 <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  8013fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8013fe:	8d 78 04             	lea    0x4(%eax),%edi
  801401:	83 ec 08             	sub    $0x8,%esp
  801404:	53                   	push   %ebx
  801405:	ff 30                	pushl  (%eax)
  801407:	ff d6                	call   *%esi
			break;
  801409:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  80140c:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  80140f:	e9 c0 02 00 00       	jmp    8016d4 <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  801414:	8b 45 14             	mov    0x14(%ebp),%eax
  801417:	8d 78 04             	lea    0x4(%eax),%edi
  80141a:	8b 00                	mov    (%eax),%eax
  80141c:	85 c0                	test   %eax,%eax
  80141e:	78 2a                	js     80144a <vprintfmt+0x138>
  801420:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  801422:	83 f8 0f             	cmp    $0xf,%eax
  801425:	7f 27                	jg     80144e <vprintfmt+0x13c>
  801427:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  80142e:	85 c0                	test   %eax,%eax
  801430:	74 1c                	je     80144e <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  801432:	50                   	push   %eax
  801433:	68 dd 1f 80 00       	push   $0x801fdd
  801438:	53                   	push   %ebx
  801439:	56                   	push   %esi
  80143a:	e8 b6 fe ff ff       	call   8012f5 <printfmt>
  80143f:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801442:	89 7d 14             	mov    %edi,0x14(%ebp)
  801445:	e9 8a 02 00 00       	jmp    8016d4 <vprintfmt+0x3c2>
  80144a:	f7 d8                	neg    %eax
  80144c:	eb d2                	jmp    801420 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  80144e:	52                   	push   %edx
  80144f:	68 5f 20 80 00       	push   $0x80205f
  801454:	53                   	push   %ebx
  801455:	56                   	push   %esi
  801456:	e8 9a fe ff ff       	call   8012f5 <printfmt>
  80145b:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80145e:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801461:	e9 6e 02 00 00       	jmp    8016d4 <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  801466:	8b 45 14             	mov    0x14(%ebp),%eax
  801469:	83 c0 04             	add    $0x4,%eax
  80146c:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80146f:	8b 45 14             	mov    0x14(%ebp),%eax
  801472:	8b 38                	mov    (%eax),%edi
  801474:	85 ff                	test   %edi,%edi
  801476:	74 39                	je     8014b1 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801478:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80147c:	0f 8e a9 00 00 00    	jle    80152b <vprintfmt+0x219>
  801482:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  801486:	0f 84 a7 00 00 00    	je     801533 <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  80148c:	83 ec 08             	sub    $0x8,%esp
  80148f:	ff 75 d0             	pushl  -0x30(%ebp)
  801492:	57                   	push   %edi
  801493:	e8 6b 03 00 00       	call   801803 <strnlen>
  801498:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  80149b:	29 c1                	sub    %eax,%ecx
  80149d:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014a0:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014a3:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014aa:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014ad:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014af:	eb 14                	jmp    8014c5 <vprintfmt+0x1b3>
				p = "(null)";
  8014b1:	bf 58 20 80 00       	mov    $0x802058,%edi
  8014b6:	eb c0                	jmp    801478 <vprintfmt+0x166>
					putch(padc, putdat);
  8014b8:	83 ec 08             	sub    $0x8,%esp
  8014bb:	53                   	push   %ebx
  8014bc:	ff 75 e0             	pushl  -0x20(%ebp)
  8014bf:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014c1:	4f                   	dec    %edi
  8014c2:	83 c4 10             	add    $0x10,%esp
  8014c5:	85 ff                	test   %edi,%edi
  8014c7:	7f ef                	jg     8014b8 <vprintfmt+0x1a6>
  8014c9:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014cc:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014cf:	89 c8                	mov    %ecx,%eax
  8014d1:	85 c9                	test   %ecx,%ecx
  8014d3:	78 10                	js     8014e5 <vprintfmt+0x1d3>
  8014d5:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014d8:	29 c1                	sub    %eax,%ecx
  8014da:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014dd:	89 75 08             	mov    %esi,0x8(%ebp)
  8014e0:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014e3:	eb 15                	jmp    8014fa <vprintfmt+0x1e8>
  8014e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014ea:	eb e9                	jmp    8014d5 <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014ec:	83 ec 08             	sub    $0x8,%esp
  8014ef:	53                   	push   %ebx
  8014f0:	52                   	push   %edx
  8014f1:	ff 55 08             	call   *0x8(%ebp)
  8014f4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014f7:	ff 4d e0             	decl   -0x20(%ebp)
  8014fa:	47                   	inc    %edi
  8014fb:	8a 47 ff             	mov    -0x1(%edi),%al
  8014fe:	0f be d0             	movsbl %al,%edx
  801501:	85 d2                	test   %edx,%edx
  801503:	74 59                	je     80155e <vprintfmt+0x24c>
  801505:	85 f6                	test   %esi,%esi
  801507:	78 03                	js     80150c <vprintfmt+0x1fa>
  801509:	4e                   	dec    %esi
  80150a:	78 2f                	js     80153b <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  80150c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801510:	74 da                	je     8014ec <vprintfmt+0x1da>
  801512:	0f be c0             	movsbl %al,%eax
  801515:	83 e8 20             	sub    $0x20,%eax
  801518:	83 f8 5e             	cmp    $0x5e,%eax
  80151b:	76 cf                	jbe    8014ec <vprintfmt+0x1da>
					putch('?', putdat);
  80151d:	83 ec 08             	sub    $0x8,%esp
  801520:	53                   	push   %ebx
  801521:	6a 3f                	push   $0x3f
  801523:	ff 55 08             	call   *0x8(%ebp)
  801526:	83 c4 10             	add    $0x10,%esp
  801529:	eb cc                	jmp    8014f7 <vprintfmt+0x1e5>
  80152b:	89 75 08             	mov    %esi,0x8(%ebp)
  80152e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801531:	eb c7                	jmp    8014fa <vprintfmt+0x1e8>
  801533:	89 75 08             	mov    %esi,0x8(%ebp)
  801536:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801539:	eb bf                	jmp    8014fa <vprintfmt+0x1e8>
  80153b:	8b 75 08             	mov    0x8(%ebp),%esi
  80153e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801541:	eb 0c                	jmp    80154f <vprintfmt+0x23d>
				putch(' ', putdat);
  801543:	83 ec 08             	sub    $0x8,%esp
  801546:	53                   	push   %ebx
  801547:	6a 20                	push   $0x20
  801549:	ff d6                	call   *%esi
			for (; width > 0; width--)
  80154b:	4f                   	dec    %edi
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	85 ff                	test   %edi,%edi
  801551:	7f f0                	jg     801543 <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  801553:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801556:	89 45 14             	mov    %eax,0x14(%ebp)
  801559:	e9 76 01 00 00       	jmp    8016d4 <vprintfmt+0x3c2>
  80155e:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801561:	8b 75 08             	mov    0x8(%ebp),%esi
  801564:	eb e9                	jmp    80154f <vprintfmt+0x23d>
	if (lflag >= 2)
  801566:	83 f9 01             	cmp    $0x1,%ecx
  801569:	7f 1f                	jg     80158a <vprintfmt+0x278>
	else if (lflag)
  80156b:	85 c9                	test   %ecx,%ecx
  80156d:	75 48                	jne    8015b7 <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  80156f:	8b 45 14             	mov    0x14(%ebp),%eax
  801572:	8b 00                	mov    (%eax),%eax
  801574:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801577:	89 c1                	mov    %eax,%ecx
  801579:	c1 f9 1f             	sar    $0x1f,%ecx
  80157c:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  80157f:	8b 45 14             	mov    0x14(%ebp),%eax
  801582:	8d 40 04             	lea    0x4(%eax),%eax
  801585:	89 45 14             	mov    %eax,0x14(%ebp)
  801588:	eb 17                	jmp    8015a1 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  80158a:	8b 45 14             	mov    0x14(%ebp),%eax
  80158d:	8b 50 04             	mov    0x4(%eax),%edx
  801590:	8b 00                	mov    (%eax),%eax
  801592:	89 45 d8             	mov    %eax,-0x28(%ebp)
  801595:	89 55 dc             	mov    %edx,-0x24(%ebp)
  801598:	8b 45 14             	mov    0x14(%ebp),%eax
  80159b:	8d 40 08             	lea    0x8(%eax),%eax
  80159e:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015a1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015a4:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015a7:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015ab:	78 25                	js     8015d2 <vprintfmt+0x2c0>
			base = 10;
  8015ad:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015b2:	e9 03 01 00 00       	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ba:	8b 00                	mov    (%eax),%eax
  8015bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015bf:	89 c1                	mov    %eax,%ecx
  8015c1:	c1 f9 1f             	sar    $0x1f,%ecx
  8015c4:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015c7:	8b 45 14             	mov    0x14(%ebp),%eax
  8015ca:	8d 40 04             	lea    0x4(%eax),%eax
  8015cd:	89 45 14             	mov    %eax,0x14(%ebp)
  8015d0:	eb cf                	jmp    8015a1 <vprintfmt+0x28f>
				putch('-', putdat);
  8015d2:	83 ec 08             	sub    $0x8,%esp
  8015d5:	53                   	push   %ebx
  8015d6:	6a 2d                	push   $0x2d
  8015d8:	ff d6                	call   *%esi
				num = -(long long) num;
  8015da:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015dd:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015e0:	f7 da                	neg    %edx
  8015e2:	83 d1 00             	adc    $0x0,%ecx
  8015e5:	f7 d9                	neg    %ecx
  8015e7:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015ea:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ef:	e9 c6 00 00 00       	jmp    8016ba <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015f4:	83 f9 01             	cmp    $0x1,%ecx
  8015f7:	7f 1e                	jg     801617 <vprintfmt+0x305>
	else if (lflag)
  8015f9:	85 c9                	test   %ecx,%ecx
  8015fb:	75 32                	jne    80162f <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  8015fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801600:	8b 10                	mov    (%eax),%edx
  801602:	b9 00 00 00 00       	mov    $0x0,%ecx
  801607:	8d 40 04             	lea    0x4(%eax),%eax
  80160a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80160d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801612:	e9 a3 00 00 00       	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801617:	8b 45 14             	mov    0x14(%ebp),%eax
  80161a:	8b 10                	mov    (%eax),%edx
  80161c:	8b 48 04             	mov    0x4(%eax),%ecx
  80161f:	8d 40 08             	lea    0x8(%eax),%eax
  801622:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801625:	b8 0a 00 00 00       	mov    $0xa,%eax
  80162a:	e9 8b 00 00 00       	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80162f:	8b 45 14             	mov    0x14(%ebp),%eax
  801632:	8b 10                	mov    (%eax),%edx
  801634:	b9 00 00 00 00       	mov    $0x0,%ecx
  801639:	8d 40 04             	lea    0x4(%eax),%eax
  80163c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80163f:	b8 0a 00 00 00       	mov    $0xa,%eax
  801644:	eb 74                	jmp    8016ba <vprintfmt+0x3a8>
	if (lflag >= 2)
  801646:	83 f9 01             	cmp    $0x1,%ecx
  801649:	7f 1b                	jg     801666 <vprintfmt+0x354>
	else if (lflag)
  80164b:	85 c9                	test   %ecx,%ecx
  80164d:	75 2c                	jne    80167b <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  80164f:	8b 45 14             	mov    0x14(%ebp),%eax
  801652:	8b 10                	mov    (%eax),%edx
  801654:	b9 00 00 00 00       	mov    $0x0,%ecx
  801659:	8d 40 04             	lea    0x4(%eax),%eax
  80165c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80165f:	b8 08 00 00 00       	mov    $0x8,%eax
  801664:	eb 54                	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801666:	8b 45 14             	mov    0x14(%ebp),%eax
  801669:	8b 10                	mov    (%eax),%edx
  80166b:	8b 48 04             	mov    0x4(%eax),%ecx
  80166e:	8d 40 08             	lea    0x8(%eax),%eax
  801671:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801674:	b8 08 00 00 00       	mov    $0x8,%eax
  801679:	eb 3f                	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80167b:	8b 45 14             	mov    0x14(%ebp),%eax
  80167e:	8b 10                	mov    (%eax),%edx
  801680:	b9 00 00 00 00       	mov    $0x0,%ecx
  801685:	8d 40 04             	lea    0x4(%eax),%eax
  801688:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80168b:	b8 08 00 00 00       	mov    $0x8,%eax
  801690:	eb 28                	jmp    8016ba <vprintfmt+0x3a8>
			putch('0', putdat);
  801692:	83 ec 08             	sub    $0x8,%esp
  801695:	53                   	push   %ebx
  801696:	6a 30                	push   $0x30
  801698:	ff d6                	call   *%esi
			putch('x', putdat);
  80169a:	83 c4 08             	add    $0x8,%esp
  80169d:	53                   	push   %ebx
  80169e:	6a 78                	push   $0x78
  8016a0:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a5:	8b 10                	mov    (%eax),%edx
  8016a7:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016ac:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016af:	8d 40 04             	lea    0x4(%eax),%eax
  8016b2:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016b5:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016ba:	83 ec 0c             	sub    $0xc,%esp
  8016bd:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016c1:	57                   	push   %edi
  8016c2:	ff 75 e0             	pushl  -0x20(%ebp)
  8016c5:	50                   	push   %eax
  8016c6:	51                   	push   %ecx
  8016c7:	52                   	push   %edx
  8016c8:	89 da                	mov    %ebx,%edx
  8016ca:	89 f0                	mov    %esi,%eax
  8016cc:	e8 5b fb ff ff       	call   80122c <printnum>
			break;
  8016d1:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016d7:	47                   	inc    %edi
  8016d8:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016dc:	83 f8 25             	cmp    $0x25,%eax
  8016df:	0f 84 44 fc ff ff    	je     801329 <vprintfmt+0x17>
			if (ch == '\0')
  8016e5:	85 c0                	test   %eax,%eax
  8016e7:	0f 84 89 00 00 00    	je     801776 <vprintfmt+0x464>
			putch(ch, putdat);
  8016ed:	83 ec 08             	sub    $0x8,%esp
  8016f0:	53                   	push   %ebx
  8016f1:	50                   	push   %eax
  8016f2:	ff d6                	call   *%esi
  8016f4:	83 c4 10             	add    $0x10,%esp
  8016f7:	eb de                	jmp    8016d7 <vprintfmt+0x3c5>
	if (lflag >= 2)
  8016f9:	83 f9 01             	cmp    $0x1,%ecx
  8016fc:	7f 1b                	jg     801719 <vprintfmt+0x407>
	else if (lflag)
  8016fe:	85 c9                	test   %ecx,%ecx
  801700:	75 2c                	jne    80172e <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  801702:	8b 45 14             	mov    0x14(%ebp),%eax
  801705:	8b 10                	mov    (%eax),%edx
  801707:	b9 00 00 00 00       	mov    $0x0,%ecx
  80170c:	8d 40 04             	lea    0x4(%eax),%eax
  80170f:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801712:	b8 10 00 00 00       	mov    $0x10,%eax
  801717:	eb a1                	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801719:	8b 45 14             	mov    0x14(%ebp),%eax
  80171c:	8b 10                	mov    (%eax),%edx
  80171e:	8b 48 04             	mov    0x4(%eax),%ecx
  801721:	8d 40 08             	lea    0x8(%eax),%eax
  801724:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801727:	b8 10 00 00 00       	mov    $0x10,%eax
  80172c:	eb 8c                	jmp    8016ba <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  80172e:	8b 45 14             	mov    0x14(%ebp),%eax
  801731:	8b 10                	mov    (%eax),%edx
  801733:	b9 00 00 00 00       	mov    $0x0,%ecx
  801738:	8d 40 04             	lea    0x4(%eax),%eax
  80173b:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80173e:	b8 10 00 00 00       	mov    $0x10,%eax
  801743:	e9 72 ff ff ff       	jmp    8016ba <vprintfmt+0x3a8>
			putch(ch, putdat);
  801748:	83 ec 08             	sub    $0x8,%esp
  80174b:	53                   	push   %ebx
  80174c:	6a 25                	push   $0x25
  80174e:	ff d6                	call   *%esi
			break;
  801750:	83 c4 10             	add    $0x10,%esp
  801753:	e9 7c ff ff ff       	jmp    8016d4 <vprintfmt+0x3c2>
			putch('%', putdat);
  801758:	83 ec 08             	sub    $0x8,%esp
  80175b:	53                   	push   %ebx
  80175c:	6a 25                	push   $0x25
  80175e:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801760:	83 c4 10             	add    $0x10,%esp
  801763:	89 f8                	mov    %edi,%eax
  801765:	eb 01                	jmp    801768 <vprintfmt+0x456>
  801767:	48                   	dec    %eax
  801768:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  80176c:	75 f9                	jne    801767 <vprintfmt+0x455>
  80176e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801771:	e9 5e ff ff ff       	jmp    8016d4 <vprintfmt+0x3c2>
}
  801776:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801779:	5b                   	pop    %ebx
  80177a:	5e                   	pop    %esi
  80177b:	5f                   	pop    %edi
  80177c:	5d                   	pop    %ebp
  80177d:	c3                   	ret    

0080177e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80177e:	55                   	push   %ebp
  80177f:	89 e5                	mov    %esp,%ebp
  801781:	83 ec 18             	sub    $0x18,%esp
  801784:	8b 45 08             	mov    0x8(%ebp),%eax
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  80178a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80178d:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801791:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  801794:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80179b:	85 c0                	test   %eax,%eax
  80179d:	74 26                	je     8017c5 <vsnprintf+0x47>
  80179f:	85 d2                	test   %edx,%edx
  8017a1:	7e 29                	jle    8017cc <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017a3:	ff 75 14             	pushl  0x14(%ebp)
  8017a6:	ff 75 10             	pushl  0x10(%ebp)
  8017a9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017ac:	50                   	push   %eax
  8017ad:	68 d9 12 80 00       	push   $0x8012d9
  8017b2:	e8 5b fb ff ff       	call   801312 <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017ba:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c0:	83 c4 10             	add    $0x10,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    
		return -E_INVAL;
  8017c5:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017ca:	eb f7                	jmp    8017c3 <vsnprintf+0x45>
  8017cc:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d1:	eb f0                	jmp    8017c3 <vsnprintf+0x45>

008017d3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017d3:	55                   	push   %ebp
  8017d4:	89 e5                	mov    %esp,%ebp
  8017d6:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017d9:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017dc:	50                   	push   %eax
  8017dd:	ff 75 10             	pushl  0x10(%ebp)
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 93 ff ff ff       	call   80177e <vsnprintf>
	va_end(ap);

	return rc;
}
  8017eb:	c9                   	leave  
  8017ec:	c3                   	ret    

008017ed <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017ed:	55                   	push   %ebp
  8017ee:	89 e5                	mov    %esp,%ebp
  8017f0:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f8:	eb 01                	jmp    8017fb <strlen+0xe>
		n++;
  8017fa:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  8017fb:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  8017ff:	75 f9                	jne    8017fa <strlen+0xd>
	return n;
}
  801801:	5d                   	pop    %ebp
  801802:	c3                   	ret    

00801803 <strnlen>:

int
strnlen(const char *s, size_t size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
  801806:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801809:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80180c:	b8 00 00 00 00       	mov    $0x0,%eax
  801811:	eb 01                	jmp    801814 <strnlen+0x11>
		n++;
  801813:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801814:	39 d0                	cmp    %edx,%eax
  801816:	74 06                	je     80181e <strnlen+0x1b>
  801818:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  80181c:	75 f5                	jne    801813 <strnlen+0x10>
	return n;
}
  80181e:	5d                   	pop    %ebp
  80181f:	c3                   	ret    

00801820 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
  801823:	53                   	push   %ebx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  80182a:	89 c2                	mov    %eax,%edx
  80182c:	42                   	inc    %edx
  80182d:	41                   	inc    %ecx
  80182e:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801831:	88 5a ff             	mov    %bl,-0x1(%edx)
  801834:	84 db                	test   %bl,%bl
  801836:	75 f4                	jne    80182c <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801838:	5b                   	pop    %ebx
  801839:	5d                   	pop    %ebp
  80183a:	c3                   	ret    

0080183b <strcat>:

char *
strcat(char *dst, const char *src)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
  80183e:	53                   	push   %ebx
  80183f:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  801842:	53                   	push   %ebx
  801843:	e8 a5 ff ff ff       	call   8017ed <strlen>
  801848:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  80184b:	ff 75 0c             	pushl  0xc(%ebp)
  80184e:	01 d8                	add    %ebx,%eax
  801850:	50                   	push   %eax
  801851:	e8 ca ff ff ff       	call   801820 <strcpy>
	return dst;
}
  801856:	89 d8                	mov    %ebx,%eax
  801858:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80185b:	c9                   	leave  
  80185c:	c3                   	ret    

0080185d <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  80185d:	55                   	push   %ebp
  80185e:	89 e5                	mov    %esp,%ebp
  801860:	56                   	push   %esi
  801861:	53                   	push   %ebx
  801862:	8b 75 08             	mov    0x8(%ebp),%esi
  801865:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801868:	89 f3                	mov    %esi,%ebx
  80186a:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80186d:	89 f2                	mov    %esi,%edx
  80186f:	eb 0c                	jmp    80187d <strncpy+0x20>
		*dst++ = *src;
  801871:	42                   	inc    %edx
  801872:	8a 01                	mov    (%ecx),%al
  801874:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  801877:	80 39 01             	cmpb   $0x1,(%ecx)
  80187a:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  80187d:	39 da                	cmp    %ebx,%edx
  80187f:	75 f0                	jne    801871 <strncpy+0x14>
	}
	return ret;
}
  801881:	89 f0                	mov    %esi,%eax
  801883:	5b                   	pop    %ebx
  801884:	5e                   	pop    %esi
  801885:	5d                   	pop    %ebp
  801886:	c3                   	ret    

00801887 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	56                   	push   %esi
  80188b:	53                   	push   %ebx
  80188c:	8b 75 08             	mov    0x8(%ebp),%esi
  80188f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801892:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  801895:	85 c0                	test   %eax,%eax
  801897:	74 20                	je     8018b9 <strlcpy+0x32>
  801899:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  80189d:	89 f0                	mov    %esi,%eax
  80189f:	eb 05                	jmp    8018a6 <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018a1:	40                   	inc    %eax
  8018a2:	42                   	inc    %edx
  8018a3:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018a6:	39 d8                	cmp    %ebx,%eax
  8018a8:	74 06                	je     8018b0 <strlcpy+0x29>
  8018aa:	8a 0a                	mov    (%edx),%cl
  8018ac:	84 c9                	test   %cl,%cl
  8018ae:	75 f1                	jne    8018a1 <strlcpy+0x1a>
		*dst = '\0';
  8018b0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018b3:	29 f0                	sub    %esi,%eax
}
  8018b5:	5b                   	pop    %ebx
  8018b6:	5e                   	pop    %esi
  8018b7:	5d                   	pop    %ebp
  8018b8:	c3                   	ret    
  8018b9:	89 f0                	mov    %esi,%eax
  8018bb:	eb f6                	jmp    8018b3 <strlcpy+0x2c>

008018bd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
  8018c0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018c3:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018c6:	eb 02                	jmp    8018ca <strcmp+0xd>
		p++, q++;
  8018c8:	41                   	inc    %ecx
  8018c9:	42                   	inc    %edx
	while (*p && *p == *q)
  8018ca:	8a 01                	mov    (%ecx),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 04                	je     8018d4 <strcmp+0x17>
  8018d0:	3a 02                	cmp    (%edx),%al
  8018d2:	74 f4                	je     8018c8 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018d4:	0f b6 c0             	movzbl %al,%eax
  8018d7:	0f b6 12             	movzbl (%edx),%edx
  8018da:	29 d0                	sub    %edx,%eax
}
  8018dc:	5d                   	pop    %ebp
  8018dd:	c3                   	ret    

008018de <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018de:	55                   	push   %ebp
  8018df:	89 e5                	mov    %esp,%ebp
  8018e1:	53                   	push   %ebx
  8018e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e8:	89 c3                	mov    %eax,%ebx
  8018ea:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018ed:	eb 02                	jmp    8018f1 <strncmp+0x13>
		n--, p++, q++;
  8018ef:	40                   	inc    %eax
  8018f0:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018f1:	39 d8                	cmp    %ebx,%eax
  8018f3:	74 15                	je     80190a <strncmp+0x2c>
  8018f5:	8a 08                	mov    (%eax),%cl
  8018f7:	84 c9                	test   %cl,%cl
  8018f9:	74 04                	je     8018ff <strncmp+0x21>
  8018fb:	3a 0a                	cmp    (%edx),%cl
  8018fd:	74 f0                	je     8018ef <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8018ff:	0f b6 00             	movzbl (%eax),%eax
  801902:	0f b6 12             	movzbl (%edx),%edx
  801905:	29 d0                	sub    %edx,%eax
}
  801907:	5b                   	pop    %ebx
  801908:	5d                   	pop    %ebp
  801909:	c3                   	ret    
		return 0;
  80190a:	b8 00 00 00 00       	mov    $0x0,%eax
  80190f:	eb f6                	jmp    801907 <strncmp+0x29>

00801911 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	8b 45 08             	mov    0x8(%ebp),%eax
  801917:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80191a:	8a 10                	mov    (%eax),%dl
  80191c:	84 d2                	test   %dl,%dl
  80191e:	74 07                	je     801927 <strchr+0x16>
		if (*s == c)
  801920:	38 ca                	cmp    %cl,%dl
  801922:	74 08                	je     80192c <strchr+0x1b>
	for (; *s; s++)
  801924:	40                   	inc    %eax
  801925:	eb f3                	jmp    80191a <strchr+0x9>
			return (char *) s;
	return 0;
  801927:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80192c:	5d                   	pop    %ebp
  80192d:	c3                   	ret    

0080192e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	8b 45 08             	mov    0x8(%ebp),%eax
  801934:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801937:	8a 10                	mov    (%eax),%dl
  801939:	84 d2                	test   %dl,%dl
  80193b:	74 07                	je     801944 <strfind+0x16>
		if (*s == c)
  80193d:	38 ca                	cmp    %cl,%dl
  80193f:	74 03                	je     801944 <strfind+0x16>
	for (; *s; s++)
  801941:	40                   	inc    %eax
  801942:	eb f3                	jmp    801937 <strfind+0x9>
			break;
	return (char *) s;
}
  801944:	5d                   	pop    %ebp
  801945:	c3                   	ret    

00801946 <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  801946:	55                   	push   %ebp
  801947:	89 e5                	mov    %esp,%ebp
  801949:	57                   	push   %edi
  80194a:	56                   	push   %esi
  80194b:	53                   	push   %ebx
  80194c:	8b 7d 08             	mov    0x8(%ebp),%edi
  80194f:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  801952:	85 c9                	test   %ecx,%ecx
  801954:	74 13                	je     801969 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  801956:	f7 c7 03 00 00 00    	test   $0x3,%edi
  80195c:	75 05                	jne    801963 <memset+0x1d>
  80195e:	f6 c1 03             	test   $0x3,%cl
  801961:	74 0d                	je     801970 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  801963:	8b 45 0c             	mov    0xc(%ebp),%eax
  801966:	fc                   	cld    
  801967:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801969:	89 f8                	mov    %edi,%eax
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5f                   	pop    %edi
  80196e:	5d                   	pop    %ebp
  80196f:	c3                   	ret    
		c &= 0xFF;
  801970:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  801974:	89 d3                	mov    %edx,%ebx
  801976:	c1 e3 08             	shl    $0x8,%ebx
  801979:	89 d0                	mov    %edx,%eax
  80197b:	c1 e0 18             	shl    $0x18,%eax
  80197e:	89 d6                	mov    %edx,%esi
  801980:	c1 e6 10             	shl    $0x10,%esi
  801983:	09 f0                	or     %esi,%eax
  801985:	09 c2                	or     %eax,%edx
  801987:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801989:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  80198c:	89 d0                	mov    %edx,%eax
  80198e:	fc                   	cld    
  80198f:	f3 ab                	rep stos %eax,%es:(%edi)
  801991:	eb d6                	jmp    801969 <memset+0x23>

00801993 <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
  801996:	57                   	push   %edi
  801997:	56                   	push   %esi
  801998:	8b 45 08             	mov    0x8(%ebp),%eax
  80199b:	8b 75 0c             	mov    0xc(%ebp),%esi
  80199e:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019a1:	39 c6                	cmp    %eax,%esi
  8019a3:	73 33                	jae    8019d8 <memmove+0x45>
  8019a5:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019a8:	39 d0                	cmp    %edx,%eax
  8019aa:	73 2c                	jae    8019d8 <memmove+0x45>
		s += n;
		d += n;
  8019ac:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019af:	89 d6                	mov    %edx,%esi
  8019b1:	09 fe                	or     %edi,%esi
  8019b3:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019b9:	75 13                	jne    8019ce <memmove+0x3b>
  8019bb:	f6 c1 03             	test   $0x3,%cl
  8019be:	75 0e                	jne    8019ce <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019c0:	83 ef 04             	sub    $0x4,%edi
  8019c3:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019c6:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019c9:	fd                   	std    
  8019ca:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019cc:	eb 07                	jmp    8019d5 <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019ce:	4f                   	dec    %edi
  8019cf:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019d2:	fd                   	std    
  8019d3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019d5:	fc                   	cld    
  8019d6:	eb 13                	jmp    8019eb <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019d8:	89 f2                	mov    %esi,%edx
  8019da:	09 c2                	or     %eax,%edx
  8019dc:	f6 c2 03             	test   $0x3,%dl
  8019df:	75 05                	jne    8019e6 <memmove+0x53>
  8019e1:	f6 c1 03             	test   $0x3,%cl
  8019e4:	74 09                	je     8019ef <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019e6:	89 c7                	mov    %eax,%edi
  8019e8:	fc                   	cld    
  8019e9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019eb:	5e                   	pop    %esi
  8019ec:	5f                   	pop    %edi
  8019ed:	5d                   	pop    %ebp
  8019ee:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019ef:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019f2:	89 c7                	mov    %eax,%edi
  8019f4:	fc                   	cld    
  8019f5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019f7:	eb f2                	jmp    8019eb <memmove+0x58>

008019f9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  8019fc:	ff 75 10             	pushl  0x10(%ebp)
  8019ff:	ff 75 0c             	pushl  0xc(%ebp)
  801a02:	ff 75 08             	pushl  0x8(%ebp)
  801a05:	e8 89 ff ff ff       	call   801993 <memmove>
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
  801a0f:	56                   	push   %esi
  801a10:	53                   	push   %ebx
  801a11:	8b 45 08             	mov    0x8(%ebp),%eax
  801a14:	89 c6                	mov    %eax,%esi
  801a16:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a19:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a1c:	39 f0                	cmp    %esi,%eax
  801a1e:	74 16                	je     801a36 <memcmp+0x2a>
		if (*s1 != *s2)
  801a20:	8a 08                	mov    (%eax),%cl
  801a22:	8a 1a                	mov    (%edx),%bl
  801a24:	38 d9                	cmp    %bl,%cl
  801a26:	75 04                	jne    801a2c <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a28:	40                   	inc    %eax
  801a29:	42                   	inc    %edx
  801a2a:	eb f0                	jmp    801a1c <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a2c:	0f b6 c1             	movzbl %cl,%eax
  801a2f:	0f b6 db             	movzbl %bl,%ebx
  801a32:	29 d8                	sub    %ebx,%eax
  801a34:	eb 05                	jmp    801a3b <memcmp+0x2f>
	}

	return 0;
  801a36:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a3b:	5b                   	pop    %ebx
  801a3c:	5e                   	pop    %esi
  801a3d:	5d                   	pop    %ebp
  801a3e:	c3                   	ret    

00801a3f <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
  801a42:	8b 45 08             	mov    0x8(%ebp),%eax
  801a45:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a48:	89 c2                	mov    %eax,%edx
  801a4a:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a4d:	39 d0                	cmp    %edx,%eax
  801a4f:	73 07                	jae    801a58 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a51:	38 08                	cmp    %cl,(%eax)
  801a53:	74 03                	je     801a58 <memfind+0x19>
	for (; s < ends; s++)
  801a55:	40                   	inc    %eax
  801a56:	eb f5                	jmp    801a4d <memfind+0xe>
			break;
	return (void *) s;
}
  801a58:	5d                   	pop    %ebp
  801a59:	c3                   	ret    

00801a5a <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a5a:	55                   	push   %ebp
  801a5b:	89 e5                	mov    %esp,%ebp
  801a5d:	57                   	push   %edi
  801a5e:	56                   	push   %esi
  801a5f:	53                   	push   %ebx
  801a60:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a63:	eb 01                	jmp    801a66 <strtol+0xc>
		s++;
  801a65:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a66:	8a 01                	mov    (%ecx),%al
  801a68:	3c 20                	cmp    $0x20,%al
  801a6a:	74 f9                	je     801a65 <strtol+0xb>
  801a6c:	3c 09                	cmp    $0x9,%al
  801a6e:	74 f5                	je     801a65 <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a70:	3c 2b                	cmp    $0x2b,%al
  801a72:	74 2b                	je     801a9f <strtol+0x45>
		s++;
	else if (*s == '-')
  801a74:	3c 2d                	cmp    $0x2d,%al
  801a76:	74 2f                	je     801aa7 <strtol+0x4d>
	int neg = 0;
  801a78:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a7d:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a84:	75 12                	jne    801a98 <strtol+0x3e>
  801a86:	80 39 30             	cmpb   $0x30,(%ecx)
  801a89:	74 24                	je     801aaf <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a8f:	75 07                	jne    801a98 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a91:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801a98:	b8 00 00 00 00       	mov    $0x0,%eax
  801a9d:	eb 4e                	jmp    801aed <strtol+0x93>
		s++;
  801a9f:	41                   	inc    %ecx
	int neg = 0;
  801aa0:	bf 00 00 00 00       	mov    $0x0,%edi
  801aa5:	eb d6                	jmp    801a7d <strtol+0x23>
		s++, neg = 1;
  801aa7:	41                   	inc    %ecx
  801aa8:	bf 01 00 00 00       	mov    $0x1,%edi
  801aad:	eb ce                	jmp    801a7d <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801aaf:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801ab3:	74 10                	je     801ac5 <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801ab5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ab9:	75 dd                	jne    801a98 <strtol+0x3e>
		s++, base = 8;
  801abb:	41                   	inc    %ecx
  801abc:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801ac3:	eb d3                	jmp    801a98 <strtol+0x3e>
		s += 2, base = 16;
  801ac5:	83 c1 02             	add    $0x2,%ecx
  801ac8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801acf:	eb c7                	jmp    801a98 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801ad1:	8d 72 9f             	lea    -0x61(%edx),%esi
  801ad4:	89 f3                	mov    %esi,%ebx
  801ad6:	80 fb 19             	cmp    $0x19,%bl
  801ad9:	77 24                	ja     801aff <strtol+0xa5>
			dig = *s - 'a' + 10;
  801adb:	0f be d2             	movsbl %dl,%edx
  801ade:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ae1:	3b 55 10             	cmp    0x10(%ebp),%edx
  801ae4:	7d 2b                	jge    801b11 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801ae6:	41                   	inc    %ecx
  801ae7:	0f af 45 10          	imul   0x10(%ebp),%eax
  801aeb:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801aed:	8a 11                	mov    (%ecx),%dl
  801aef:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801af2:	80 fb 09             	cmp    $0x9,%bl
  801af5:	77 da                	ja     801ad1 <strtol+0x77>
			dig = *s - '0';
  801af7:	0f be d2             	movsbl %dl,%edx
  801afa:	83 ea 30             	sub    $0x30,%edx
  801afd:	eb e2                	jmp    801ae1 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801aff:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b02:	89 f3                	mov    %esi,%ebx
  801b04:	80 fb 19             	cmp    $0x19,%bl
  801b07:	77 08                	ja     801b11 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b09:	0f be d2             	movsbl %dl,%edx
  801b0c:	83 ea 37             	sub    $0x37,%edx
  801b0f:	eb d0                	jmp    801ae1 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b11:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b15:	74 05                	je     801b1c <strtol+0xc2>
		*endptr = (char *) s;
  801b17:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b1a:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b1c:	85 ff                	test   %edi,%edi
  801b1e:	74 02                	je     801b22 <strtol+0xc8>
  801b20:	f7 d8                	neg    %eax
}
  801b22:	5b                   	pop    %ebx
  801b23:	5e                   	pop    %esi
  801b24:	5f                   	pop    %edi
  801b25:	5d                   	pop    %ebp
  801b26:	c3                   	ret    

00801b27 <atoi>:

int
atoi(const char *s)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b2a:	6a 0a                	push   $0xa
  801b2c:	6a 00                	push   $0x0
  801b2e:	ff 75 08             	pushl  0x8(%ebp)
  801b31:	e8 24 ff ff ff       	call   801a5a <strtol>
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	57                   	push   %edi
  801b3c:	56                   	push   %esi
  801b3d:	53                   	push   %ebx
  801b3e:	83 ec 0c             	sub    $0xc,%esp
  801b41:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b44:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b47:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b4a:	85 ff                	test   %edi,%edi
  801b4c:	74 53                	je     801ba1 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b4e:	83 ec 0c             	sub    $0xc,%esp
  801b51:	57                   	push   %edi
  801b52:	e8 fe e7 ff ff       	call   800355 <sys_ipc_recv>
  801b57:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b5a:	85 db                	test   %ebx,%ebx
  801b5c:	74 0b                	je     801b69 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b5e:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b64:	8b 52 74             	mov    0x74(%edx),%edx
  801b67:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b69:	85 f6                	test   %esi,%esi
  801b6b:	74 0f                	je     801b7c <ipc_recv+0x44>
  801b6d:	85 ff                	test   %edi,%edi
  801b6f:	74 0b                	je     801b7c <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b71:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b77:	8b 52 78             	mov    0x78(%edx),%edx
  801b7a:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b7c:	85 c0                	test   %eax,%eax
  801b7e:	74 30                	je     801bb0 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b80:	85 db                	test   %ebx,%ebx
  801b82:	74 06                	je     801b8a <ipc_recv+0x52>
      		*from_env_store = 0;
  801b84:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b8a:	85 f6                	test   %esi,%esi
  801b8c:	74 2c                	je     801bba <ipc_recv+0x82>
      		*perm_store = 0;
  801b8e:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b94:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801b99:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801b9c:	5b                   	pop    %ebx
  801b9d:	5e                   	pop    %esi
  801b9e:	5f                   	pop    %edi
  801b9f:	5d                   	pop    %ebp
  801ba0:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801ba1:	83 ec 0c             	sub    $0xc,%esp
  801ba4:	6a ff                	push   $0xffffffff
  801ba6:	e8 aa e7 ff ff       	call   800355 <sys_ipc_recv>
  801bab:	83 c4 10             	add    $0x10,%esp
  801bae:	eb aa                	jmp    801b5a <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bb0:	a1 04 40 80 00       	mov    0x804004,%eax
  801bb5:	8b 40 70             	mov    0x70(%eax),%eax
  801bb8:	eb df                	jmp    801b99 <ipc_recv+0x61>
		return -1;
  801bba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bbf:	eb d8                	jmp    801b99 <ipc_recv+0x61>

00801bc1 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	57                   	push   %edi
  801bc5:	56                   	push   %esi
  801bc6:	53                   	push   %ebx
  801bc7:	83 ec 0c             	sub    $0xc,%esp
  801bca:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bcd:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bd0:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bd3:	85 db                	test   %ebx,%ebx
  801bd5:	75 22                	jne    801bf9 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bd7:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801bdc:	eb 1b                	jmp    801bf9 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801bde:	68 40 23 80 00       	push   $0x802340
  801be3:	68 cb 1f 80 00       	push   $0x801fcb
  801be8:	6a 48                	push   $0x48
  801bea:	68 64 23 80 00       	push   $0x802364
  801bef:	e8 11 f5 ff ff       	call   801105 <_panic>
		sys_yield();
  801bf4:	e8 13 e6 ff ff       	call   80020c <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801bf9:	57                   	push   %edi
  801bfa:	53                   	push   %ebx
  801bfb:	56                   	push   %esi
  801bfc:	ff 75 08             	pushl  0x8(%ebp)
  801bff:	e8 2e e7 ff ff       	call   800332 <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c04:	83 c4 10             	add    $0x10,%esp
  801c07:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c0a:	74 e8                	je     801bf4 <ipc_send+0x33>
  801c0c:	85 c0                	test   %eax,%eax
  801c0e:	75 ce                	jne    801bde <ipc_send+0x1d>
		sys_yield();
  801c10:	e8 f7 e5 ff ff       	call   80020c <sys_yield>
		
	}
	
}
  801c15:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c18:	5b                   	pop    %ebx
  801c19:	5e                   	pop    %esi
  801c1a:	5f                   	pop    %edi
  801c1b:	5d                   	pop    %ebp
  801c1c:	c3                   	ret    

00801c1d <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c1d:	55                   	push   %ebp
  801c1e:	89 e5                	mov    %esp,%ebp
  801c20:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c23:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c28:	89 c2                	mov    %eax,%edx
  801c2a:	c1 e2 05             	shl    $0x5,%edx
  801c2d:	29 c2                	sub    %eax,%edx
  801c2f:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c36:	8b 52 50             	mov    0x50(%edx),%edx
  801c39:	39 ca                	cmp    %ecx,%edx
  801c3b:	74 0f                	je     801c4c <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c3d:	40                   	inc    %eax
  801c3e:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c43:	75 e3                	jne    801c28 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c45:	b8 00 00 00 00       	mov    $0x0,%eax
  801c4a:	eb 11                	jmp    801c5d <ipc_find_env+0x40>
			return envs[i].env_id;
  801c4c:	89 c2                	mov    %eax,%edx
  801c4e:	c1 e2 05             	shl    $0x5,%edx
  801c51:	29 c2                	sub    %eax,%edx
  801c53:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c5a:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c5d:	5d                   	pop    %ebp
  801c5e:	c3                   	ret    

00801c5f <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c62:	8b 45 08             	mov    0x8(%ebp),%eax
  801c65:	c1 e8 16             	shr    $0x16,%eax
  801c68:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c6f:	a8 01                	test   $0x1,%al
  801c71:	74 21                	je     801c94 <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c73:	8b 45 08             	mov    0x8(%ebp),%eax
  801c76:	c1 e8 0c             	shr    $0xc,%eax
  801c79:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c80:	a8 01                	test   $0x1,%al
  801c82:	74 17                	je     801c9b <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c84:	c1 e8 0c             	shr    $0xc,%eax
  801c87:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c8e:	ef 
  801c8f:	0f b7 c0             	movzwl %ax,%eax
  801c92:	eb 05                	jmp    801c99 <pageref+0x3a>
		return 0;
  801c94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c99:	5d                   	pop    %ebp
  801c9a:	c3                   	ret    
		return 0;
  801c9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca0:	eb f7                	jmp    801c99 <pageref+0x3a>
  801ca2:	66 90                	xchg   %ax,%ax

00801ca4 <__udivdi3>:
  801ca4:	55                   	push   %ebp
  801ca5:	57                   	push   %edi
  801ca6:	56                   	push   %esi
  801ca7:	53                   	push   %ebx
  801ca8:	83 ec 1c             	sub    $0x1c,%esp
  801cab:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801caf:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cb3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cb7:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cbb:	89 ca                	mov    %ecx,%edx
  801cbd:	89 f8                	mov    %edi,%eax
  801cbf:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801cc3:	85 f6                	test   %esi,%esi
  801cc5:	75 2d                	jne    801cf4 <__udivdi3+0x50>
  801cc7:	39 cf                	cmp    %ecx,%edi
  801cc9:	77 65                	ja     801d30 <__udivdi3+0x8c>
  801ccb:	89 fd                	mov    %edi,%ebp
  801ccd:	85 ff                	test   %edi,%edi
  801ccf:	75 0b                	jne    801cdc <__udivdi3+0x38>
  801cd1:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd6:	31 d2                	xor    %edx,%edx
  801cd8:	f7 f7                	div    %edi
  801cda:	89 c5                	mov    %eax,%ebp
  801cdc:	31 d2                	xor    %edx,%edx
  801cde:	89 c8                	mov    %ecx,%eax
  801ce0:	f7 f5                	div    %ebp
  801ce2:	89 c1                	mov    %eax,%ecx
  801ce4:	89 d8                	mov    %ebx,%eax
  801ce6:	f7 f5                	div    %ebp
  801ce8:	89 cf                	mov    %ecx,%edi
  801cea:	89 fa                	mov    %edi,%edx
  801cec:	83 c4 1c             	add    $0x1c,%esp
  801cef:	5b                   	pop    %ebx
  801cf0:	5e                   	pop    %esi
  801cf1:	5f                   	pop    %edi
  801cf2:	5d                   	pop    %ebp
  801cf3:	c3                   	ret    
  801cf4:	39 ce                	cmp    %ecx,%esi
  801cf6:	77 28                	ja     801d20 <__udivdi3+0x7c>
  801cf8:	0f bd fe             	bsr    %esi,%edi
  801cfb:	83 f7 1f             	xor    $0x1f,%edi
  801cfe:	75 40                	jne    801d40 <__udivdi3+0x9c>
  801d00:	39 ce                	cmp    %ecx,%esi
  801d02:	72 0a                	jb     801d0e <__udivdi3+0x6a>
  801d04:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d08:	0f 87 9e 00 00 00    	ja     801dac <__udivdi3+0x108>
  801d0e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d13:	89 fa                	mov    %edi,%edx
  801d15:	83 c4 1c             	add    $0x1c,%esp
  801d18:	5b                   	pop    %ebx
  801d19:	5e                   	pop    %esi
  801d1a:	5f                   	pop    %edi
  801d1b:	5d                   	pop    %ebp
  801d1c:	c3                   	ret    
  801d1d:	8d 76 00             	lea    0x0(%esi),%esi
  801d20:	31 ff                	xor    %edi,%edi
  801d22:	31 c0                	xor    %eax,%eax
  801d24:	89 fa                	mov    %edi,%edx
  801d26:	83 c4 1c             	add    $0x1c,%esp
  801d29:	5b                   	pop    %ebx
  801d2a:	5e                   	pop    %esi
  801d2b:	5f                   	pop    %edi
  801d2c:	5d                   	pop    %ebp
  801d2d:	c3                   	ret    
  801d2e:	66 90                	xchg   %ax,%ax
  801d30:	89 d8                	mov    %ebx,%eax
  801d32:	f7 f7                	div    %edi
  801d34:	31 ff                	xor    %edi,%edi
  801d36:	89 fa                	mov    %edi,%edx
  801d38:	83 c4 1c             	add    $0x1c,%esp
  801d3b:	5b                   	pop    %ebx
  801d3c:	5e                   	pop    %esi
  801d3d:	5f                   	pop    %edi
  801d3e:	5d                   	pop    %ebp
  801d3f:	c3                   	ret    
  801d40:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d45:	29 fd                	sub    %edi,%ebp
  801d47:	89 f9                	mov    %edi,%ecx
  801d49:	d3 e6                	shl    %cl,%esi
  801d4b:	89 c3                	mov    %eax,%ebx
  801d4d:	89 e9                	mov    %ebp,%ecx
  801d4f:	d3 eb                	shr    %cl,%ebx
  801d51:	89 d9                	mov    %ebx,%ecx
  801d53:	09 f1                	or     %esi,%ecx
  801d55:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d59:	89 f9                	mov    %edi,%ecx
  801d5b:	d3 e0                	shl    %cl,%eax
  801d5d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d61:	89 d6                	mov    %edx,%esi
  801d63:	89 e9                	mov    %ebp,%ecx
  801d65:	d3 ee                	shr    %cl,%esi
  801d67:	89 f9                	mov    %edi,%ecx
  801d69:	d3 e2                	shl    %cl,%edx
  801d6b:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d6f:	89 e9                	mov    %ebp,%ecx
  801d71:	d3 eb                	shr    %cl,%ebx
  801d73:	09 da                	or     %ebx,%edx
  801d75:	89 d0                	mov    %edx,%eax
  801d77:	89 f2                	mov    %esi,%edx
  801d79:	f7 74 24 08          	divl   0x8(%esp)
  801d7d:	89 d6                	mov    %edx,%esi
  801d7f:	89 c3                	mov    %eax,%ebx
  801d81:	f7 64 24 0c          	mull   0xc(%esp)
  801d85:	39 d6                	cmp    %edx,%esi
  801d87:	72 17                	jb     801da0 <__udivdi3+0xfc>
  801d89:	74 09                	je     801d94 <__udivdi3+0xf0>
  801d8b:	89 d8                	mov    %ebx,%eax
  801d8d:	31 ff                	xor    %edi,%edi
  801d8f:	e9 56 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801d94:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d98:	89 f9                	mov    %edi,%ecx
  801d9a:	d3 e2                	shl    %cl,%edx
  801d9c:	39 c2                	cmp    %eax,%edx
  801d9e:	73 eb                	jae    801d8b <__udivdi3+0xe7>
  801da0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801da3:	31 ff                	xor    %edi,%edi
  801da5:	e9 40 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801daa:	66 90                	xchg   %ax,%ax
  801dac:	31 c0                	xor    %eax,%eax
  801dae:	e9 37 ff ff ff       	jmp    801cea <__udivdi3+0x46>
  801db3:	90                   	nop

00801db4 <__umoddi3>:
  801db4:	55                   	push   %ebp
  801db5:	57                   	push   %edi
  801db6:	56                   	push   %esi
  801db7:	53                   	push   %ebx
  801db8:	83 ec 1c             	sub    $0x1c,%esp
  801dbb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dbf:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dc3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dc7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dcb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dcf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801dd3:	89 3c 24             	mov    %edi,(%esp)
  801dd6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dda:	89 f2                	mov    %esi,%edx
  801ddc:	85 c0                	test   %eax,%eax
  801dde:	75 18                	jne    801df8 <__umoddi3+0x44>
  801de0:	39 f7                	cmp    %esi,%edi
  801de2:	0f 86 a0 00 00 00    	jbe    801e88 <__umoddi3+0xd4>
  801de8:	89 c8                	mov    %ecx,%eax
  801dea:	f7 f7                	div    %edi
  801dec:	89 d0                	mov    %edx,%eax
  801dee:	31 d2                	xor    %edx,%edx
  801df0:	83 c4 1c             	add    $0x1c,%esp
  801df3:	5b                   	pop    %ebx
  801df4:	5e                   	pop    %esi
  801df5:	5f                   	pop    %edi
  801df6:	5d                   	pop    %ebp
  801df7:	c3                   	ret    
  801df8:	89 f3                	mov    %esi,%ebx
  801dfa:	39 f0                	cmp    %esi,%eax
  801dfc:	0f 87 a6 00 00 00    	ja     801ea8 <__umoddi3+0xf4>
  801e02:	0f bd e8             	bsr    %eax,%ebp
  801e05:	83 f5 1f             	xor    $0x1f,%ebp
  801e08:	0f 84 a6 00 00 00    	je     801eb4 <__umoddi3+0x100>
  801e0e:	bf 20 00 00 00       	mov    $0x20,%edi
  801e13:	29 ef                	sub    %ebp,%edi
  801e15:	89 e9                	mov    %ebp,%ecx
  801e17:	d3 e0                	shl    %cl,%eax
  801e19:	8b 34 24             	mov    (%esp),%esi
  801e1c:	89 f2                	mov    %esi,%edx
  801e1e:	89 f9                	mov    %edi,%ecx
  801e20:	d3 ea                	shr    %cl,%edx
  801e22:	09 c2                	or     %eax,%edx
  801e24:	89 14 24             	mov    %edx,(%esp)
  801e27:	89 f2                	mov    %esi,%edx
  801e29:	89 e9                	mov    %ebp,%ecx
  801e2b:	d3 e2                	shl    %cl,%edx
  801e2d:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e31:	89 de                	mov    %ebx,%esi
  801e33:	89 f9                	mov    %edi,%ecx
  801e35:	d3 ee                	shr    %cl,%esi
  801e37:	89 e9                	mov    %ebp,%ecx
  801e39:	d3 e3                	shl    %cl,%ebx
  801e3b:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e3f:	89 d0                	mov    %edx,%eax
  801e41:	89 f9                	mov    %edi,%ecx
  801e43:	d3 e8                	shr    %cl,%eax
  801e45:	09 d8                	or     %ebx,%eax
  801e47:	89 d3                	mov    %edx,%ebx
  801e49:	89 e9                	mov    %ebp,%ecx
  801e4b:	d3 e3                	shl    %cl,%ebx
  801e4d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e51:	89 f2                	mov    %esi,%edx
  801e53:	f7 34 24             	divl   (%esp)
  801e56:	89 d6                	mov    %edx,%esi
  801e58:	f7 64 24 04          	mull   0x4(%esp)
  801e5c:	89 c3                	mov    %eax,%ebx
  801e5e:	89 d1                	mov    %edx,%ecx
  801e60:	39 d6                	cmp    %edx,%esi
  801e62:	72 7c                	jb     801ee0 <__umoddi3+0x12c>
  801e64:	74 72                	je     801ed8 <__umoddi3+0x124>
  801e66:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e6a:	29 da                	sub    %ebx,%edx
  801e6c:	19 ce                	sbb    %ecx,%esi
  801e6e:	89 f0                	mov    %esi,%eax
  801e70:	89 f9                	mov    %edi,%ecx
  801e72:	d3 e0                	shl    %cl,%eax
  801e74:	89 e9                	mov    %ebp,%ecx
  801e76:	d3 ea                	shr    %cl,%edx
  801e78:	09 d0                	or     %edx,%eax
  801e7a:	89 e9                	mov    %ebp,%ecx
  801e7c:	d3 ee                	shr    %cl,%esi
  801e7e:	89 f2                	mov    %esi,%edx
  801e80:	83 c4 1c             	add    $0x1c,%esp
  801e83:	5b                   	pop    %ebx
  801e84:	5e                   	pop    %esi
  801e85:	5f                   	pop    %edi
  801e86:	5d                   	pop    %ebp
  801e87:	c3                   	ret    
  801e88:	89 fd                	mov    %edi,%ebp
  801e8a:	85 ff                	test   %edi,%edi
  801e8c:	75 0b                	jne    801e99 <__umoddi3+0xe5>
  801e8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e93:	31 d2                	xor    %edx,%edx
  801e95:	f7 f7                	div    %edi
  801e97:	89 c5                	mov    %eax,%ebp
  801e99:	89 f0                	mov    %esi,%eax
  801e9b:	31 d2                	xor    %edx,%edx
  801e9d:	f7 f5                	div    %ebp
  801e9f:	89 c8                	mov    %ecx,%eax
  801ea1:	f7 f5                	div    %ebp
  801ea3:	e9 44 ff ff ff       	jmp    801dec <__umoddi3+0x38>
  801ea8:	89 c8                	mov    %ecx,%eax
  801eaa:	89 f2                	mov    %esi,%edx
  801eac:	83 c4 1c             	add    $0x1c,%esp
  801eaf:	5b                   	pop    %ebx
  801eb0:	5e                   	pop    %esi
  801eb1:	5f                   	pop    %edi
  801eb2:	5d                   	pop    %ebp
  801eb3:	c3                   	ret    
  801eb4:	39 f0                	cmp    %esi,%eax
  801eb6:	72 05                	jb     801ebd <__umoddi3+0x109>
  801eb8:	39 0c 24             	cmp    %ecx,(%esp)
  801ebb:	77 0c                	ja     801ec9 <__umoddi3+0x115>
  801ebd:	89 f2                	mov    %esi,%edx
  801ebf:	29 f9                	sub    %edi,%ecx
  801ec1:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ec5:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ec9:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ecd:	83 c4 1c             	add    $0x1c,%esp
  801ed0:	5b                   	pop    %ebx
  801ed1:	5e                   	pop    %esi
  801ed2:	5f                   	pop    %edi
  801ed3:	5d                   	pop    %ebp
  801ed4:	c3                   	ret    
  801ed5:	8d 76 00             	lea    0x0(%esi),%esi
  801ed8:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801edc:	73 88                	jae    801e66 <__umoddi3+0xb2>
  801ede:	66 90                	xchg   %ax,%ax
  801ee0:	2b 44 24 04          	sub    0x4(%esp),%eax
  801ee4:	1b 14 24             	sbb    (%esp),%edx
  801ee7:	89 d1                	mov    %edx,%ecx
  801ee9:	89 c3                	mov    %eax,%ebx
  801eeb:	e9 76 ff ff ff       	jmp    801e66 <__umoddi3+0xb2>
