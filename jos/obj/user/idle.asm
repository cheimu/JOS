
obj/user/idle.debug:     file format elf32-i386


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
  80002c:	e8 19 00 00 00       	call   80004a <libmain>
1:	jmp 1b
  800031:	eb fe                	jmp    800031 <args_exist+0x5>

00800033 <umain>:
#include <inc/x86.h>
#include <inc/lib.h>

void
umain(int argc, char **argv)
{
  800033:	55                   	push   %ebp
  800034:	89 e5                	mov    %esp,%ebp
  800036:	83 ec 08             	sub    $0x8,%esp
	binaryname = "idle";
  800039:	c7 05 00 30 80 00 00 	movl   $0x801f00,0x803000
  800040:	1f 80 00 
	// Instead of busy-waiting like this,
	// a better way would be to use the processor's HLT instruction
	// to cause the processor to stop executing until the next interrupt -
	// doing so allows the processor to conserve power more effectively.
	while (1) {
		sys_yield();
  800043:	e8 cc 01 00 00       	call   800214 <sys_yield>
  800048:	eb f9                	jmp    800043 <umain+0x10>

0080004a <libmain>:
const volatile struct Env *thisenv;
const char *binaryname = "<unknown>";

void
libmain(int argc, char **argv)
{
  80004a:	55                   	push   %ebp
  80004b:	89 e5                	mov    %esp,%ebp
  80004d:	56                   	push   %esi
  80004e:	53                   	push   %ebx
  80004f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  800052:	8b 75 0c             	mov    0xc(%ebp),%esi
	// set thisenv to point at our Env structure in envs[].
	// LAB 3: Your code here.
	thisenv = &envs[ENVX(sys_getenvid())];
  800055:	e8 d4 00 00 00       	call   80012e <sys_getenvid>
  80005a:	25 ff 03 00 00       	and    $0x3ff,%eax
  80005f:	89 c2                	mov    %eax,%edx
  800061:	c1 e2 05             	shl    $0x5,%edx
  800064:	29 c2                	sub    %eax,%edx
  800066:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  80006d:	a3 04 40 80 00       	mov    %eax,0x804004

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800072:	85 db                	test   %ebx,%ebx
  800074:	7e 07                	jle    80007d <libmain+0x33>
		binaryname = argv[0];
  800076:	8b 06                	mov    (%esi),%eax
  800078:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	umain(argc, argv);
  80007d:	83 ec 08             	sub    $0x8,%esp
  800080:	56                   	push   %esi
  800081:	53                   	push   %ebx
  800082:	e8 ac ff ff ff       	call   800033 <umain>

	// exit gracefully
	exit();
  800087:	e8 0a 00 00 00       	call   800096 <exit>
}
  80008c:	83 c4 10             	add    $0x10,%esp
  80008f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800092:	5b                   	pop    %ebx
  800093:	5e                   	pop    %esi
  800094:	5d                   	pop    %ebp
  800095:	c3                   	ret    

00800096 <exit>:

#include <inc/lib.h>

void
exit(void)
{
  800096:	55                   	push   %ebp
  800097:	89 e5                	mov    %esp,%ebp
  800099:	83 ec 08             	sub    $0x8,%esp
	close_all();
  80009c:	e8 35 05 00 00       	call   8005d6 <close_all>
	sys_env_destroy(0);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	e8 42 00 00 00       	call   8000ed <sys_env_destroy>
}
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	c9                   	leave  
  8000af:	c3                   	ret    

008000b0 <sys_cputs>:
	return ret;
}

void
sys_cputs(const char *s, size_t len)
{
  8000b0:	55                   	push   %ebp
  8000b1:	89 e5                	mov    %esp,%ebp
  8000b3:	57                   	push   %edi
  8000b4:	56                   	push   %esi
  8000b5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8000bb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8000be:	8b 55 08             	mov    0x8(%ebp),%edx
  8000c1:	89 c3                	mov    %eax,%ebx
  8000c3:	89 c7                	mov    %eax,%edi
  8000c5:	89 c6                	mov    %eax,%esi
  8000c7:	cd 30                	int    $0x30
	syscall(SYS_cputs, 0, (uint32_t)s, len, 0, 0, 0);
}
  8000c9:	5b                   	pop    %ebx
  8000ca:	5e                   	pop    %esi
  8000cb:	5f                   	pop    %edi
  8000cc:	5d                   	pop    %ebp
  8000cd:	c3                   	ret    

008000ce <sys_cgetc>:

int
sys_cgetc(void)
{
  8000ce:	55                   	push   %ebp
  8000cf:	89 e5                	mov    %esp,%ebp
  8000d1:	57                   	push   %edi
  8000d2:	56                   	push   %esi
  8000d3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8000d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8000d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8000de:	89 d1                	mov    %edx,%ecx
  8000e0:	89 d3                	mov    %edx,%ebx
  8000e2:	89 d7                	mov    %edx,%edi
  8000e4:	89 d6                	mov    %edx,%esi
  8000e6:	cd 30                	int    $0x30
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0, 0);
}
  8000e8:	5b                   	pop    %ebx
  8000e9:	5e                   	pop    %esi
  8000ea:	5f                   	pop    %edi
  8000eb:	5d                   	pop    %ebp
  8000ec:	c3                   	ret    

008000ed <sys_env_destroy>:

int
sys_env_destroy(envid_t envid)
{
  8000ed:	55                   	push   %ebp
  8000ee:	89 e5                	mov    %esp,%ebp
  8000f0:	57                   	push   %edi
  8000f1:	56                   	push   %esi
  8000f2:	53                   	push   %ebx
  8000f3:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8000f6:	b9 00 00 00 00       	mov    $0x0,%ecx
  8000fb:	b8 03 00 00 00       	mov    $0x3,%eax
  800100:	8b 55 08             	mov    0x8(%ebp),%edx
  800103:	89 cb                	mov    %ecx,%ebx
  800105:	89 cf                	mov    %ecx,%edi
  800107:	89 ce                	mov    %ecx,%esi
  800109:	cd 30                	int    $0x30
	if(check && ret > 0)
  80010b:	85 c0                	test   %eax,%eax
  80010d:	7f 08                	jg     800117 <sys_env_destroy+0x2a>
	return syscall(SYS_env_destroy, 1, envid, 0, 0, 0, 0);
}
  80010f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800112:	5b                   	pop    %ebx
  800113:	5e                   	pop    %esi
  800114:	5f                   	pop    %edi
  800115:	5d                   	pop    %ebp
  800116:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800117:	83 ec 0c             	sub    $0xc,%esp
  80011a:	50                   	push   %eax
  80011b:	6a 03                	push   $0x3
  80011d:	68 0f 1f 80 00       	push   $0x801f0f
  800122:	6a 23                	push   $0x23
  800124:	68 2c 1f 80 00       	push   $0x801f2c
  800129:	e8 df 0f 00 00       	call   80110d <_panic>

0080012e <sys_getenvid>:

envid_t
sys_getenvid(void)
{
  80012e:	55                   	push   %ebp
  80012f:	89 e5                	mov    %esp,%ebp
  800131:	57                   	push   %edi
  800132:	56                   	push   %esi
  800133:	53                   	push   %ebx
	asm volatile("int %1\n"
  800134:	ba 00 00 00 00       	mov    $0x0,%edx
  800139:	b8 02 00 00 00       	mov    $0x2,%eax
  80013e:	89 d1                	mov    %edx,%ecx
  800140:	89 d3                	mov    %edx,%ebx
  800142:	89 d7                	mov    %edx,%edi
  800144:	89 d6                	mov    %edx,%esi
  800146:	cd 30                	int    $0x30
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0, 0);
}
  800148:	5b                   	pop    %ebx
  800149:	5e                   	pop    %esi
  80014a:	5f                   	pop    %edi
  80014b:	5d                   	pop    %ebp
  80014c:	c3                   	ret    

0080014d <sys_page_alloc>:

int
sys_page_alloc(envid_t envid, void *va, int perm)
{
  80014d:	55                   	push   %ebp
  80014e:	89 e5                	mov    %esp,%ebp
  800150:	57                   	push   %edi
  800151:	56                   	push   %esi
  800152:	53                   	push   %ebx
  800153:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800156:	be 00 00 00 00       	mov    $0x0,%esi
  80015b:	b8 04 00 00 00       	mov    $0x4,%eax
  800160:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800163:	8b 55 08             	mov    0x8(%ebp),%edx
  800166:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800169:	89 f7                	mov    %esi,%edi
  80016b:	cd 30                	int    $0x30
	if(check && ret > 0)
  80016d:	85 c0                	test   %eax,%eax
  80016f:	7f 08                	jg     800179 <sys_page_alloc+0x2c>
	return syscall(SYS_page_alloc, 1, envid, (uint32_t) va, perm, 0, 0);
}
  800171:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800174:	5b                   	pop    %ebx
  800175:	5e                   	pop    %esi
  800176:	5f                   	pop    %edi
  800177:	5d                   	pop    %ebp
  800178:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800179:	83 ec 0c             	sub    $0xc,%esp
  80017c:	50                   	push   %eax
  80017d:	6a 04                	push   $0x4
  80017f:	68 0f 1f 80 00       	push   $0x801f0f
  800184:	6a 23                	push   $0x23
  800186:	68 2c 1f 80 00       	push   $0x801f2c
  80018b:	e8 7d 0f 00 00       	call   80110d <_panic>

00800190 <sys_page_map>:

int
sys_page_map(envid_t srcenv, void *srcva, envid_t dstenv, void *dstva, int perm)
{
  800190:	55                   	push   %ebp
  800191:	89 e5                	mov    %esp,%ebp
  800193:	57                   	push   %edi
  800194:	56                   	push   %esi
  800195:	53                   	push   %ebx
  800196:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800199:	b8 05 00 00 00       	mov    $0x5,%eax
  80019e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8001a4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8001a7:	8b 7d 14             	mov    0x14(%ebp),%edi
  8001aa:	8b 75 18             	mov    0x18(%ebp),%esi
  8001ad:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001af:	85 c0                	test   %eax,%eax
  8001b1:	7f 08                	jg     8001bb <sys_page_map+0x2b>
	return syscall(SYS_page_map, 1, srcenv, (uint32_t) srcva, dstenv, (uint32_t) dstva, perm);
}
  8001b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001b6:	5b                   	pop    %ebx
  8001b7:	5e                   	pop    %esi
  8001b8:	5f                   	pop    %edi
  8001b9:	5d                   	pop    %ebp
  8001ba:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001bb:	83 ec 0c             	sub    $0xc,%esp
  8001be:	50                   	push   %eax
  8001bf:	6a 05                	push   $0x5
  8001c1:	68 0f 1f 80 00       	push   $0x801f0f
  8001c6:	6a 23                	push   $0x23
  8001c8:	68 2c 1f 80 00       	push   $0x801f2c
  8001cd:	e8 3b 0f 00 00       	call   80110d <_panic>

008001d2 <sys_page_unmap>:

int
sys_page_unmap(envid_t envid, void *va)
{
  8001d2:	55                   	push   %ebp
  8001d3:	89 e5                	mov    %esp,%ebp
  8001d5:	57                   	push   %edi
  8001d6:	56                   	push   %esi
  8001d7:	53                   	push   %ebx
  8001d8:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8001db:	bb 00 00 00 00       	mov    $0x0,%ebx
  8001e0:	b8 06 00 00 00       	mov    $0x6,%eax
  8001e5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8001e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8001eb:	89 df                	mov    %ebx,%edi
  8001ed:	89 de                	mov    %ebx,%esi
  8001ef:	cd 30                	int    $0x30
	if(check && ret > 0)
  8001f1:	85 c0                	test   %eax,%eax
  8001f3:	7f 08                	jg     8001fd <sys_page_unmap+0x2b>
	return syscall(SYS_page_unmap, 1, envid, (uint32_t) va, 0, 0, 0);
}
  8001f5:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8001f8:	5b                   	pop    %ebx
  8001f9:	5e                   	pop    %esi
  8001fa:	5f                   	pop    %edi
  8001fb:	5d                   	pop    %ebp
  8001fc:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8001fd:	83 ec 0c             	sub    $0xc,%esp
  800200:	50                   	push   %eax
  800201:	6a 06                	push   $0x6
  800203:	68 0f 1f 80 00       	push   $0x801f0f
  800208:	6a 23                	push   $0x23
  80020a:	68 2c 1f 80 00       	push   $0x801f2c
  80020f:	e8 f9 0e 00 00       	call   80110d <_panic>

00800214 <sys_yield>:

void
sys_yield(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	57                   	push   %edi
  800218:	56                   	push   %esi
  800219:	53                   	push   %ebx
	asm volatile("int %1\n"
  80021a:	ba 00 00 00 00       	mov    $0x0,%edx
  80021f:	b8 0b 00 00 00       	mov    $0xb,%eax
  800224:	89 d1                	mov    %edx,%ecx
  800226:	89 d3                	mov    %edx,%ebx
  800228:	89 d7                	mov    %edx,%edi
  80022a:	89 d6                	mov    %edx,%esi
  80022c:	cd 30                	int    $0x30
	syscall(SYS_yield, 0, 0, 0, 0, 0, 0);
}
  80022e:	5b                   	pop    %ebx
  80022f:	5e                   	pop    %esi
  800230:	5f                   	pop    %edi
  800231:	5d                   	pop    %ebp
  800232:	c3                   	ret    

00800233 <sys_env_set_status>:

// sys_exofork is inlined in lib.h

int
sys_env_set_status(envid_t envid, int status)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	57                   	push   %edi
  800237:	56                   	push   %esi
  800238:	53                   	push   %ebx
  800239:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80023c:	bb 00 00 00 00       	mov    $0x0,%ebx
  800241:	b8 08 00 00 00       	mov    $0x8,%eax
  800246:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800249:	8b 55 08             	mov    0x8(%ebp),%edx
  80024c:	89 df                	mov    %ebx,%edi
  80024e:	89 de                	mov    %ebx,%esi
  800250:	cd 30                	int    $0x30
	if(check && ret > 0)
  800252:	85 c0                	test   %eax,%eax
  800254:	7f 08                	jg     80025e <sys_env_set_status+0x2b>
	return syscall(SYS_env_set_status, 1, envid, status, 0, 0, 0);
}
  800256:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800259:	5b                   	pop    %ebx
  80025a:	5e                   	pop    %esi
  80025b:	5f                   	pop    %edi
  80025c:	5d                   	pop    %ebp
  80025d:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80025e:	83 ec 0c             	sub    $0xc,%esp
  800261:	50                   	push   %eax
  800262:	6a 08                	push   $0x8
  800264:	68 0f 1f 80 00       	push   $0x801f0f
  800269:	6a 23                	push   $0x23
  80026b:	68 2c 1f 80 00       	push   $0x801f2c
  800270:	e8 98 0e 00 00       	call   80110d <_panic>

00800275 <sys_sysinfo>:

int
sys_sysinfo(struct sysinfo *info)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	57                   	push   %edi
  800279:	56                   	push   %esi
  80027a:	53                   	push   %ebx
  80027b:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  80027e:	b9 00 00 00 00       	mov    $0x0,%ecx
  800283:	b8 0c 00 00 00       	mov    $0xc,%eax
  800288:	8b 55 08             	mov    0x8(%ebp),%edx
  80028b:	89 cb                	mov    %ecx,%ebx
  80028d:	89 cf                	mov    %ecx,%edi
  80028f:	89 ce                	mov    %ecx,%esi
  800291:	cd 30                	int    $0x30
	if(check && ret > 0)
  800293:	85 c0                	test   %eax,%eax
  800295:	7f 08                	jg     80029f <sys_sysinfo+0x2a>
	return syscall(SYS_sysinfo, 1, (uint32_t)info, 0, 0, 0, 0);
}
  800297:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80029a:	5b                   	pop    %ebx
  80029b:	5e                   	pop    %esi
  80029c:	5f                   	pop    %edi
  80029d:	5d                   	pop    %ebp
  80029e:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	50                   	push   %eax
  8002a3:	6a 0c                	push   $0xc
  8002a5:	68 0f 1f 80 00       	push   $0x801f0f
  8002aa:	6a 23                	push   $0x23
  8002ac:	68 2c 1f 80 00       	push   $0x801f2c
  8002b1:	e8 57 0e 00 00       	call   80110d <_panic>

008002b6 <sys_env_set_trapframe>:

int
sys_env_set_trapframe(envid_t envid, struct Trapframe *tf)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	57                   	push   %edi
  8002ba:	56                   	push   %esi
  8002bb:	53                   	push   %ebx
  8002bc:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  8002bf:	bb 00 00 00 00       	mov    $0x0,%ebx
  8002c4:	b8 09 00 00 00       	mov    $0x9,%eax
  8002c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8002cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8002cf:	89 df                	mov    %ebx,%edi
  8002d1:	89 de                	mov    %ebx,%esi
  8002d3:	cd 30                	int    $0x30
	if(check && ret > 0)
  8002d5:	85 c0                	test   %eax,%eax
  8002d7:	7f 08                	jg     8002e1 <sys_env_set_trapframe+0x2b>
	return syscall(SYS_env_set_trapframe, 1, envid, (uint32_t) tf, 0, 0, 0);
}
  8002d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8002dc:	5b                   	pop    %ebx
  8002dd:	5e                   	pop    %esi
  8002de:	5f                   	pop    %edi
  8002df:	5d                   	pop    %ebp
  8002e0:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  8002e1:	83 ec 0c             	sub    $0xc,%esp
  8002e4:	50                   	push   %eax
  8002e5:	6a 09                	push   $0x9
  8002e7:	68 0f 1f 80 00       	push   $0x801f0f
  8002ec:	6a 23                	push   $0x23
  8002ee:	68 2c 1f 80 00       	push   $0x801f2c
  8002f3:	e8 15 0e 00 00       	call   80110d <_panic>

008002f8 <sys_env_set_pgfault_upcall>:

int
sys_env_set_pgfault_upcall(envid_t envid, void *upcall)
{
  8002f8:	55                   	push   %ebp
  8002f9:	89 e5                	mov    %esp,%ebp
  8002fb:	57                   	push   %edi
  8002fc:	56                   	push   %esi
  8002fd:	53                   	push   %ebx
  8002fe:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800301:	bb 00 00 00 00       	mov    $0x0,%ebx
  800306:	b8 0a 00 00 00       	mov    $0xa,%eax
  80030b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80030e:	8b 55 08             	mov    0x8(%ebp),%edx
  800311:	89 df                	mov    %ebx,%edi
  800313:	89 de                	mov    %ebx,%esi
  800315:	cd 30                	int    $0x30
	if(check && ret > 0)
  800317:	85 c0                	test   %eax,%eax
  800319:	7f 08                	jg     800323 <sys_env_set_pgfault_upcall+0x2b>
	return syscall(SYS_env_set_pgfault_upcall, 1, envid, (uint32_t) upcall, 0, 0, 0);
}
  80031b:	8d 65 f4             	lea    -0xc(%ebp),%esp
  80031e:	5b                   	pop    %ebx
  80031f:	5e                   	pop    %esi
  800320:	5f                   	pop    %edi
  800321:	5d                   	pop    %ebp
  800322:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	50                   	push   %eax
  800327:	6a 0a                	push   $0xa
  800329:	68 0f 1f 80 00       	push   $0x801f0f
  80032e:	6a 23                	push   $0x23
  800330:	68 2c 1f 80 00       	push   $0x801f2c
  800335:	e8 d3 0d 00 00       	call   80110d <_panic>

0080033a <sys_ipc_try_send>:

int
sys_ipc_try_send(envid_t envid, uint32_t value, void *srcva, int perm)
{
  80033a:	55                   	push   %ebp
  80033b:	89 e5                	mov    %esp,%ebp
  80033d:	57                   	push   %edi
  80033e:	56                   	push   %esi
  80033f:	53                   	push   %ebx
	asm volatile("int %1\n"
  800340:	be 00 00 00 00       	mov    $0x0,%esi
  800345:	b8 0d 00 00 00       	mov    $0xd,%eax
  80034a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80034d:	8b 55 08             	mov    0x8(%ebp),%edx
  800350:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800353:	8b 7d 14             	mov    0x14(%ebp),%edi
  800356:	cd 30                	int    $0x30
	return syscall(SYS_ipc_try_send, 0, envid, value, (uint32_t) srcva, perm, 0);
}
  800358:	5b                   	pop    %ebx
  800359:	5e                   	pop    %esi
  80035a:	5f                   	pop    %edi
  80035b:	5d                   	pop    %ebp
  80035c:	c3                   	ret    

0080035d <sys_ipc_recv>:

int
sys_ipc_recv(void *dstva)
{
  80035d:	55                   	push   %ebp
  80035e:	89 e5                	mov    %esp,%ebp
  800360:	57                   	push   %edi
  800361:	56                   	push   %esi
  800362:	53                   	push   %ebx
  800363:	83 ec 0c             	sub    $0xc,%esp
	asm volatile("int %1\n"
  800366:	b9 00 00 00 00       	mov    $0x0,%ecx
  80036b:	b8 0e 00 00 00       	mov    $0xe,%eax
  800370:	8b 55 08             	mov    0x8(%ebp),%edx
  800373:	89 cb                	mov    %ecx,%ebx
  800375:	89 cf                	mov    %ecx,%edi
  800377:	89 ce                	mov    %ecx,%esi
  800379:	cd 30                	int    $0x30
	if(check && ret > 0)
  80037b:	85 c0                	test   %eax,%eax
  80037d:	7f 08                	jg     800387 <sys_ipc_recv+0x2a>
	return syscall(SYS_ipc_recv, 1, (uint32_t)dstva, 0, 0, 0, 0);
}
  80037f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800382:	5b                   	pop    %ebx
  800383:	5e                   	pop    %esi
  800384:	5f                   	pop    %edi
  800385:	5d                   	pop    %ebp
  800386:	c3                   	ret    
		panic("syscall %d returned %d (> 0)", num, ret);
  800387:	83 ec 0c             	sub    $0xc,%esp
  80038a:	50                   	push   %eax
  80038b:	6a 0e                	push   $0xe
  80038d:	68 0f 1f 80 00       	push   $0x801f0f
  800392:	6a 23                	push   $0x23
  800394:	68 2c 1f 80 00       	push   $0x801f2c
  800399:	e8 6f 0d 00 00       	call   80110d <_panic>

0080039e <sys_blk_write>:

int
sys_blk_write(uint32_t secno, const void *buf, size_t nsecs)
{
  80039e:	55                   	push   %ebp
  80039f:	89 e5                	mov    %esp,%ebp
  8003a1:	57                   	push   %edi
  8003a2:	56                   	push   %esi
  8003a3:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003a4:	be 00 00 00 00       	mov    $0x0,%esi
  8003a9:	b8 0f 00 00 00       	mov    $0xf,%eax
  8003ae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003b4:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003b7:	89 f7                	mov    %esi,%edi
  8003b9:	cd 30                	int    $0x30
	return syscall(SYS_blk_write, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003bb:	5b                   	pop    %ebx
  8003bc:	5e                   	pop    %esi
  8003bd:	5f                   	pop    %edi
  8003be:	5d                   	pop    %ebp
  8003bf:	c3                   	ret    

008003c0 <sys_blk_read>:

int
sys_blk_read(uint32_t secno, void *buf, size_t nsecs)
{
  8003c0:	55                   	push   %ebp
  8003c1:	89 e5                	mov    %esp,%ebp
  8003c3:	57                   	push   %edi
  8003c4:	56                   	push   %esi
  8003c5:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003c6:	be 00 00 00 00       	mov    $0x0,%esi
  8003cb:	b8 10 00 00 00       	mov    $0x10,%eax
  8003d0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8003d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8003d6:	8b 5d 10             	mov    0x10(%ebp),%ebx
  8003d9:	89 f7                	mov    %esi,%edi
  8003db:	cd 30                	int    $0x30
	return syscall(SYS_blk_read, 0, secno, (uint32_t)buf, nsecs, 0, 0);
}
  8003dd:	5b                   	pop    %ebx
  8003de:	5e                   	pop    %esi
  8003df:	5f                   	pop    %edi
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <sys_set_console_color>:

void sys_set_console_color(int color) {
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	57                   	push   %edi
  8003e6:	56                   	push   %esi
  8003e7:	53                   	push   %ebx
	asm volatile("int %1\n"
  8003e8:	b9 00 00 00 00       	mov    $0x0,%ecx
  8003ed:	b8 11 00 00 00       	mov    $0x11,%eax
  8003f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8003f5:	89 cb                	mov    %ecx,%ebx
  8003f7:	89 cf                	mov    %ecx,%edi
  8003f9:	89 ce                	mov    %ecx,%esi
  8003fb:	cd 30                	int    $0x30
	syscall(SYS_set_console_color,0, (uint32_t)color, 0, 0, 0, 0);
}
  8003fd:	5b                   	pop    %ebx
  8003fe:	5e                   	pop    %esi
  8003ff:	5f                   	pop    %edi
  800400:	5d                   	pop    %ebp
  800401:	c3                   	ret    

00800402 <fd2num>:
// File descriptor manipulators
// --------------------------------------------------------------

int
fd2num(struct Fd *fd)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	05 00 00 00 30       	add    $0x30000000,%eax
  80040d:	c1 e8 0c             	shr    $0xc,%eax
}
  800410:	5d                   	pop    %ebp
  800411:	c3                   	ret    

00800412 <fd2data>:

char*
fd2data(struct Fd *fd)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800415:	8b 45 08             	mov    0x8(%ebp),%eax
  800418:	05 00 00 00 30       	add    $0x30000000,%eax
	return INDEX2DATA(fd2num(fd));
  80041d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800422:	2d 00 00 fe 2f       	sub    $0x2ffe0000,%eax
}
  800427:	5d                   	pop    %ebp
  800428:	c3                   	ret    

00800429 <fd_alloc>:
// Returns 0 on success, < 0 on error.  Errors are:
//	-E_MAX_FD: no more file descriptors
// On error, *fd_store is set to 0.
int
fd_alloc(struct Fd **fd_store)
{
  800429:	55                   	push   %ebp
  80042a:	89 e5                	mov    %esp,%ebp
  80042c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80042f:	b8 00 00 00 d0       	mov    $0xd0000000,%eax
	int i;
	struct Fd *fd;

	for (i = 0; i < MAXFD; i++) {
		fd = INDEX2FD(i);
		if ((uvpd[PDX(fd)] & PTE_P) == 0 || (uvpt[PGNUM(fd)] & PTE_P) == 0) {
  800434:	89 c2                	mov    %eax,%edx
  800436:	c1 ea 16             	shr    $0x16,%edx
  800439:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800440:	f6 c2 01             	test   $0x1,%dl
  800443:	74 2a                	je     80046f <fd_alloc+0x46>
  800445:	89 c2                	mov    %eax,%edx
  800447:	c1 ea 0c             	shr    $0xc,%edx
  80044a:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  800451:	f6 c2 01             	test   $0x1,%dl
  800454:	74 19                	je     80046f <fd_alloc+0x46>
  800456:	05 00 10 00 00       	add    $0x1000,%eax
	for (i = 0; i < MAXFD; i++) {
  80045b:	3d 00 00 02 d0       	cmp    $0xd0020000,%eax
  800460:	75 d2                	jne    800434 <fd_alloc+0xb>
			*fd_store = fd;
			return 0;
		}
	}
	*fd_store = 0;
  800462:	c7 01 00 00 00 00    	movl   $0x0,(%ecx)
	return -E_MAX_OPEN;
  800468:	b8 f6 ff ff ff       	mov    $0xfffffff6,%eax
  80046d:	eb 07                	jmp    800476 <fd_alloc+0x4d>
			*fd_store = fd;
  80046f:	89 01                	mov    %eax,(%ecx)
			return 0;
  800471:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800476:	5d                   	pop    %ebp
  800477:	c3                   	ret    

00800478 <fd_lookup>:
// Returns 0 on success (the page is in range and mapped), < 0 on error.
// Errors are:
//	-E_INVAL: fdnum was either not in range or not mapped.
int
fd_lookup(int fdnum, struct Fd **fd_store)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
	struct Fd *fd;

	if (fdnum < 0 || fdnum >= MAXFD) {
  80047b:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  80047f:	77 39                	ja     8004ba <fd_lookup+0x42>
		if (debug)
			cprintf("[%08x] bad fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	fd = INDEX2FD(fdnum);
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	c1 e0 0c             	shl    $0xc,%eax
  800487:	2d 00 00 00 30       	sub    $0x30000000,%eax
	if (!(uvpd[PDX(fd)] & PTE_P) || !(uvpt[PGNUM(fd)] & PTE_P)) {
  80048c:	89 c2                	mov    %eax,%edx
  80048e:	c1 ea 16             	shr    $0x16,%edx
  800491:	8b 14 95 00 d0 7b ef 	mov    -0x10843000(,%edx,4),%edx
  800498:	f6 c2 01             	test   $0x1,%dl
  80049b:	74 24                	je     8004c1 <fd_lookup+0x49>
  80049d:	89 c2                	mov    %eax,%edx
  80049f:	c1 ea 0c             	shr    $0xc,%edx
  8004a2:	8b 14 95 00 00 40 ef 	mov    -0x10c00000(,%edx,4),%edx
  8004a9:	f6 c2 01             	test   $0x1,%dl
  8004ac:	74 1a                	je     8004c8 <fd_lookup+0x50>
		if (debug)
			cprintf("[%08x] closed fd %d\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	*fd_store = fd;
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	89 02                	mov    %eax,(%edx)
	return 0;
  8004b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8004b8:	5d                   	pop    %ebp
  8004b9:	c3                   	ret    
		return -E_INVAL;
  8004ba:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004bf:	eb f7                	jmp    8004b8 <fd_lookup+0x40>
		return -E_INVAL;
  8004c1:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004c6:	eb f0                	jmp    8004b8 <fd_lookup+0x40>
  8004c8:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8004cd:	eb e9                	jmp    8004b8 <fd_lookup+0x40>

008004cf <dev_lookup>:
	0
};

int
dev_lookup(int dev_id, struct Dev **dev)
{
  8004cf:	55                   	push   %ebp
  8004d0:	89 e5                	mov    %esp,%ebp
  8004d2:	83 ec 08             	sub    $0x8,%esp
  8004d5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8004d8:	ba b8 1f 80 00       	mov    $0x801fb8,%edx
	int i;
	for (i = 0; devtab[i]; i++)
  8004dd:	b8 04 30 80 00       	mov    $0x803004,%eax
		if (devtab[i]->dev_id == dev_id) {
  8004e2:	39 08                	cmp    %ecx,(%eax)
  8004e4:	74 33                	je     800519 <dev_lookup+0x4a>
  8004e6:	83 c2 04             	add    $0x4,%edx
	for (i = 0; devtab[i]; i++)
  8004e9:	8b 02                	mov    (%edx),%eax
  8004eb:	85 c0                	test   %eax,%eax
  8004ed:	75 f3                	jne    8004e2 <dev_lookup+0x13>
			*dev = devtab[i];
			return 0;
		}
	cprintf("[%08x] unknown device type %d\n", thisenv->env_id, dev_id);
  8004ef:	a1 04 40 80 00       	mov    0x804004,%eax
  8004f4:	8b 40 48             	mov    0x48(%eax),%eax
  8004f7:	83 ec 04             	sub    $0x4,%esp
  8004fa:	51                   	push   %ecx
  8004fb:	50                   	push   %eax
  8004fc:	68 3c 1f 80 00       	push   $0x801f3c
  800501:	e8 1a 0d 00 00       	call   801220 <cprintf>
	*dev = 0;
  800506:	8b 45 0c             	mov    0xc(%ebp),%eax
  800509:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return -E_INVAL;
  80050f:	83 c4 10             	add    $0x10,%esp
  800512:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
  800517:	c9                   	leave  
  800518:	c3                   	ret    
			*dev = devtab[i];
  800519:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  80051c:	89 01                	mov    %eax,(%ecx)
			return 0;
  80051e:	b8 00 00 00 00       	mov    $0x0,%eax
  800523:	eb f2                	jmp    800517 <dev_lookup+0x48>

00800525 <fd_close>:
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	57                   	push   %edi
  800529:	56                   	push   %esi
  80052a:	53                   	push   %ebx
  80052b:	83 ec 1c             	sub    $0x1c,%esp
  80052e:	8b 75 08             	mov    0x8(%ebp),%esi
  800531:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800534:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800537:	50                   	push   %eax
	return ((uintptr_t) fd - FDTABLE) / PGSIZE;
  800538:	8d 86 00 00 00 30    	lea    0x30000000(%esi),%eax
  80053e:	c1 e8 0c             	shr    $0xc,%eax
	if ((r = fd_lookup(fd2num(fd), &fd2)) < 0
  800541:	50                   	push   %eax
  800542:	e8 31 ff ff ff       	call   800478 <fd_lookup>
  800547:	89 c7                	mov    %eax,%edi
  800549:	83 c4 08             	add    $0x8,%esp
  80054c:	85 c0                	test   %eax,%eax
  80054e:	78 05                	js     800555 <fd_close+0x30>
	    || fd != fd2)
  800550:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
  800553:	74 13                	je     800568 <fd_close+0x43>
		return (must_exist ? r : 0);
  800555:	84 db                	test   %bl,%bl
  800557:	75 05                	jne    80055e <fd_close+0x39>
  800559:	bf 00 00 00 00       	mov    $0x0,%edi
}
  80055e:	89 f8                	mov    %edi,%eax
  800560:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800563:	5b                   	pop    %ebx
  800564:	5e                   	pop    %esi
  800565:	5f                   	pop    %edi
  800566:	5d                   	pop    %ebp
  800567:	c3                   	ret    
	if ((r = dev_lookup(fd->fd_dev_id, &dev)) >= 0) {
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80056e:	50                   	push   %eax
  80056f:	ff 36                	pushl  (%esi)
  800571:	e8 59 ff ff ff       	call   8004cf <dev_lookup>
  800576:	89 c7                	mov    %eax,%edi
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	85 c0                	test   %eax,%eax
  80057d:	78 15                	js     800594 <fd_close+0x6f>
		if (dev->dev_close)
  80057f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800582:	8b 40 10             	mov    0x10(%eax),%eax
  800585:	85 c0                	test   %eax,%eax
  800587:	74 1b                	je     8005a4 <fd_close+0x7f>
			r = (*dev->dev_close)(fd);
  800589:	83 ec 0c             	sub    $0xc,%esp
  80058c:	56                   	push   %esi
  80058d:	ff d0                	call   *%eax
  80058f:	89 c7                	mov    %eax,%edi
  800591:	83 c4 10             	add    $0x10,%esp
	(void) sys_page_unmap(0, fd);
  800594:	83 ec 08             	sub    $0x8,%esp
  800597:	56                   	push   %esi
  800598:	6a 00                	push   $0x0
  80059a:	e8 33 fc ff ff       	call   8001d2 <sys_page_unmap>
	return r;
  80059f:	83 c4 10             	add    $0x10,%esp
  8005a2:	eb ba                	jmp    80055e <fd_close+0x39>
			r = 0;
  8005a4:	bf 00 00 00 00       	mov    $0x0,%edi
  8005a9:	eb e9                	jmp    800594 <fd_close+0x6f>

008005ab <close>:

int
close(int fdnum)
{
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
  8005ae:	83 ec 18             	sub    $0x18,%esp
	struct Fd *fd;
	int r;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  8005b1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005b4:	50                   	push   %eax
  8005b5:	ff 75 08             	pushl  0x8(%ebp)
  8005b8:	e8 bb fe ff ff       	call   800478 <fd_lookup>
  8005bd:	83 c4 08             	add    $0x8,%esp
  8005c0:	85 c0                	test   %eax,%eax
  8005c2:	78 10                	js     8005d4 <close+0x29>
		return r;
	else
		return fd_close(fd, 1);
  8005c4:	83 ec 08             	sub    $0x8,%esp
  8005c7:	6a 01                	push   $0x1
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	e8 54 ff ff ff       	call   800525 <fd_close>
  8005d1:	83 c4 10             	add    $0x10,%esp
}
  8005d4:	c9                   	leave  
  8005d5:	c3                   	ret    

008005d6 <close_all>:

void
close_all(void)
{
  8005d6:	55                   	push   %ebp
  8005d7:	89 e5                	mov    %esp,%ebp
  8005d9:	53                   	push   %ebx
  8005da:	83 ec 04             	sub    $0x4,%esp
	int i;
	for (i = 0; i < MAXFD; i++)
  8005dd:	bb 00 00 00 00       	mov    $0x0,%ebx
		close(i);
  8005e2:	83 ec 0c             	sub    $0xc,%esp
  8005e5:	53                   	push   %ebx
  8005e6:	e8 c0 ff ff ff       	call   8005ab <close>
	for (i = 0; i < MAXFD; i++)
  8005eb:	43                   	inc    %ebx
  8005ec:	83 c4 10             	add    $0x10,%esp
  8005ef:	83 fb 20             	cmp    $0x20,%ebx
  8005f2:	75 ee                	jne    8005e2 <close_all+0xc>
}
  8005f4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <dup>:
// file and the file offset of the other.
// Closes any previously open file descriptor at 'newfdnum'.
// This is implemented using virtual memory tricks (of course!).
int
dup(int oldfdnum, int newfdnum)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	57                   	push   %edi
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 1c             	sub    $0x1c,%esp
	int r;
	char *ova, *nva;
	pte_t pte;
	struct Fd *oldfd, *newfd;

	if ((r = fd_lookup(oldfdnum, &oldfd)) < 0)
  800602:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  800605:	50                   	push   %eax
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	e8 6a fe ff ff       	call   800478 <fd_lookup>
  80060e:	89 c3                	mov    %eax,%ebx
  800610:	83 c4 08             	add    $0x8,%esp
  800613:	85 c0                	test   %eax,%eax
  800615:	0f 88 81 00 00 00    	js     80069c <dup+0xa3>
		return r;
	close(newfdnum);
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	ff 75 0c             	pushl  0xc(%ebp)
  800621:	e8 85 ff ff ff       	call   8005ab <close>

	newfd = INDEX2FD(newfdnum);
  800626:	8b 75 0c             	mov    0xc(%ebp),%esi
  800629:	c1 e6 0c             	shl    $0xc,%esi
  80062c:	81 ee 00 00 00 30    	sub    $0x30000000,%esi
	ova = fd2data(oldfd);
  800632:	83 c4 04             	add    $0x4,%esp
  800635:	ff 75 e4             	pushl  -0x1c(%ebp)
  800638:	e8 d5 fd ff ff       	call   800412 <fd2data>
  80063d:	89 c3                	mov    %eax,%ebx
	nva = fd2data(newfd);
  80063f:	89 34 24             	mov    %esi,(%esp)
  800642:	e8 cb fd ff ff       	call   800412 <fd2data>
  800647:	83 c4 10             	add    $0x10,%esp
  80064a:	89 c7                	mov    %eax,%edi

	if ((uvpd[PDX(ova)] & PTE_P) && (uvpt[PGNUM(ova)] & PTE_P))
  80064c:	89 d8                	mov    %ebx,%eax
  80064e:	c1 e8 16             	shr    $0x16,%eax
  800651:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  800658:	a8 01                	test   $0x1,%al
  80065a:	74 11                	je     80066d <dup+0x74>
  80065c:	89 d8                	mov    %ebx,%eax
  80065e:	c1 e8 0c             	shr    $0xc,%eax
  800661:	8b 14 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%edx
  800668:	f6 c2 01             	test   $0x1,%dl
  80066b:	75 39                	jne    8006a6 <dup+0xad>
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
			goto err;
	if ((r = sys_page_map(0, oldfd, 0, newfd, uvpt[PGNUM(oldfd)] & PTE_SYSCALL)) < 0)
  80066d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e8 0c             	shr    $0xc,%eax
  800675:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  80067c:	83 ec 0c             	sub    $0xc,%esp
  80067f:	25 07 0e 00 00       	and    $0xe07,%eax
  800684:	50                   	push   %eax
  800685:	56                   	push   %esi
  800686:	6a 00                	push   $0x0
  800688:	52                   	push   %edx
  800689:	6a 00                	push   $0x0
  80068b:	e8 00 fb ff ff       	call   800190 <sys_page_map>
  800690:	89 c3                	mov    %eax,%ebx
  800692:	83 c4 20             	add    $0x20,%esp
  800695:	85 c0                	test   %eax,%eax
  800697:	78 31                	js     8006ca <dup+0xd1>
		goto err;

	return newfdnum;
  800699:	8b 5d 0c             	mov    0xc(%ebp),%ebx

err:
	sys_page_unmap(0, newfd);
	sys_page_unmap(0, nva);
	return r;
}
  80069c:	89 d8                	mov    %ebx,%eax
  80069e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8006a1:	5b                   	pop    %ebx
  8006a2:	5e                   	pop    %esi
  8006a3:	5f                   	pop    %edi
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    
		if ((r = sys_page_map(0, ova, 0, nva, uvpt[PGNUM(ova)] & PTE_SYSCALL)) < 0)
  8006a6:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
  8006ad:	83 ec 0c             	sub    $0xc,%esp
  8006b0:	25 07 0e 00 00       	and    $0xe07,%eax
  8006b5:	50                   	push   %eax
  8006b6:	57                   	push   %edi
  8006b7:	6a 00                	push   $0x0
  8006b9:	53                   	push   %ebx
  8006ba:	6a 00                	push   $0x0
  8006bc:	e8 cf fa ff ff       	call   800190 <sys_page_map>
  8006c1:	89 c3                	mov    %eax,%ebx
  8006c3:	83 c4 20             	add    $0x20,%esp
  8006c6:	85 c0                	test   %eax,%eax
  8006c8:	79 a3                	jns    80066d <dup+0x74>
	sys_page_unmap(0, newfd);
  8006ca:	83 ec 08             	sub    $0x8,%esp
  8006cd:	56                   	push   %esi
  8006ce:	6a 00                	push   $0x0
  8006d0:	e8 fd fa ff ff       	call   8001d2 <sys_page_unmap>
	sys_page_unmap(0, nva);
  8006d5:	83 c4 08             	add    $0x8,%esp
  8006d8:	57                   	push   %edi
  8006d9:	6a 00                	push   $0x0
  8006db:	e8 f2 fa ff ff       	call   8001d2 <sys_page_unmap>
	return r;
  8006e0:	83 c4 10             	add    $0x10,%esp
  8006e3:	eb b7                	jmp    80069c <dup+0xa3>

008006e5 <read>:

ssize_t
read(int fdnum, void *buf, size_t n)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
  8006e8:	53                   	push   %ebx
  8006e9:	83 ec 14             	sub    $0x14,%esp
  8006ec:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8006ef:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8006f2:	50                   	push   %eax
  8006f3:	53                   	push   %ebx
  8006f4:	e8 7f fd ff ff       	call   800478 <fd_lookup>
  8006f9:	83 c4 08             	add    $0x8,%esp
  8006fc:	85 c0                	test   %eax,%eax
  8006fe:	78 3f                	js     80073f <read+0x5a>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800700:	83 ec 08             	sub    $0x8,%esp
  800703:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800706:	50                   	push   %eax
  800707:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80070a:	ff 30                	pushl  (%eax)
  80070c:	e8 be fd ff ff       	call   8004cf <dev_lookup>
  800711:	83 c4 10             	add    $0x10,%esp
  800714:	85 c0                	test   %eax,%eax
  800716:	78 27                	js     80073f <read+0x5a>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_WRONLY) {
  800718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80071b:	8b 42 08             	mov    0x8(%edx),%eax
  80071e:	83 e0 03             	and    $0x3,%eax
  800721:	83 f8 01             	cmp    $0x1,%eax
  800724:	74 1e                	je     800744 <read+0x5f>
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_read)
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800729:	8b 40 08             	mov    0x8(%eax),%eax
  80072c:	85 c0                	test   %eax,%eax
  80072e:	74 35                	je     800765 <read+0x80>
		return -E_NOT_SUPP;
	return (*dev->dev_read)(fd, buf, n);
  800730:	83 ec 04             	sub    $0x4,%esp
  800733:	ff 75 10             	pushl  0x10(%ebp)
  800736:	ff 75 0c             	pushl  0xc(%ebp)
  800739:	52                   	push   %edx
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
}
  80073f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800742:	c9                   	leave  
  800743:	c3                   	ret    
		cprintf("[%08x] read %d -- bad mode\n", thisenv->env_id, fdnum);
  800744:	a1 04 40 80 00       	mov    0x804004,%eax
  800749:	8b 40 48             	mov    0x48(%eax),%eax
  80074c:	83 ec 04             	sub    $0x4,%esp
  80074f:	53                   	push   %ebx
  800750:	50                   	push   %eax
  800751:	68 7d 1f 80 00       	push   $0x801f7d
  800756:	e8 c5 0a 00 00       	call   801220 <cprintf>
		return -E_INVAL;
  80075b:	83 c4 10             	add    $0x10,%esp
  80075e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800763:	eb da                	jmp    80073f <read+0x5a>
		return -E_NOT_SUPP;
  800765:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80076a:	eb d3                	jmp    80073f <read+0x5a>

0080076c <readn>:

ssize_t
readn(int fdnum, void *buf, size_t n)
{
  80076c:	55                   	push   %ebp
  80076d:	89 e5                	mov    %esp,%ebp
  80076f:	57                   	push   %edi
  800770:	56                   	push   %esi
  800771:	53                   	push   %ebx
  800772:	83 ec 0c             	sub    $0xc,%esp
  800775:	8b 7d 08             	mov    0x8(%ebp),%edi
  800778:	8b 75 10             	mov    0x10(%ebp),%esi
	int m, tot;

	for (tot = 0; tot < n; tot += m) {
  80077b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800780:	39 f3                	cmp    %esi,%ebx
  800782:	73 25                	jae    8007a9 <readn+0x3d>
		m = read(fdnum, (char*)buf + tot, n - tot);
  800784:	83 ec 04             	sub    $0x4,%esp
  800787:	89 f0                	mov    %esi,%eax
  800789:	29 d8                	sub    %ebx,%eax
  80078b:	50                   	push   %eax
  80078c:	89 d8                	mov    %ebx,%eax
  80078e:	03 45 0c             	add    0xc(%ebp),%eax
  800791:	50                   	push   %eax
  800792:	57                   	push   %edi
  800793:	e8 4d ff ff ff       	call   8006e5 <read>
		if (m < 0)
  800798:	83 c4 10             	add    $0x10,%esp
  80079b:	85 c0                	test   %eax,%eax
  80079d:	78 08                	js     8007a7 <readn+0x3b>
			return m;
		if (m == 0)
  80079f:	85 c0                	test   %eax,%eax
  8007a1:	74 06                	je     8007a9 <readn+0x3d>
	for (tot = 0; tot < n; tot += m) {
  8007a3:	01 c3                	add    %eax,%ebx
  8007a5:	eb d9                	jmp    800780 <readn+0x14>
		m = read(fdnum, (char*)buf + tot, n - tot);
  8007a7:	89 c3                	mov    %eax,%ebx
			break;
	}
	return tot;
}
  8007a9:	89 d8                	mov    %ebx,%eax
  8007ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8007ae:	5b                   	pop    %ebx
  8007af:	5e                   	pop    %esi
  8007b0:	5f                   	pop    %edi
  8007b1:	5d                   	pop    %ebp
  8007b2:	c3                   	ret    

008007b3 <write>:

ssize_t
write(int fdnum, const void *buf, size_t n)
{
  8007b3:	55                   	push   %ebp
  8007b4:	89 e5                	mov    %esp,%ebp
  8007b6:	53                   	push   %ebx
  8007b7:	83 ec 14             	sub    $0x14,%esp
  8007ba:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8007bd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8007c0:	50                   	push   %eax
  8007c1:	53                   	push   %ebx
  8007c2:	e8 b1 fc ff ff       	call   800478 <fd_lookup>
  8007c7:	83 c4 08             	add    $0x8,%esp
  8007ca:	85 c0                	test   %eax,%eax
  8007cc:	78 3a                	js     800808 <write+0x55>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8007d4:	50                   	push   %eax
  8007d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d8:	ff 30                	pushl  (%eax)
  8007da:	e8 f0 fc ff ff       	call   8004cf <dev_lookup>
  8007df:	83 c4 10             	add    $0x10,%esp
  8007e2:	85 c0                	test   %eax,%eax
  8007e4:	78 22                	js     800808 <write+0x55>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  8007e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e9:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  8007ed:	74 1e                	je     80080d <write+0x5a>
		return -E_INVAL;
	}
	if (debug)
		cprintf("write %d %p %d via dev %s\n",
			fdnum, buf, n, dev->dev_name);
	if (!dev->dev_write)
  8007ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007f2:	8b 52 0c             	mov    0xc(%edx),%edx
  8007f5:	85 d2                	test   %edx,%edx
  8007f7:	74 35                	je     80082e <write+0x7b>
		return -E_NOT_SUPP;
	return (*dev->dev_write)(fd, buf, n);
  8007f9:	83 ec 04             	sub    $0x4,%esp
  8007fc:	ff 75 10             	pushl  0x10(%ebp)
  8007ff:	ff 75 0c             	pushl  0xc(%ebp)
  800802:	50                   	push   %eax
  800803:	ff d2                	call   *%edx
  800805:	83 c4 10             	add    $0x10,%esp
}
  800808:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80080b:	c9                   	leave  
  80080c:	c3                   	ret    
		cprintf("[%08x] write %d -- bad mode\n", thisenv->env_id, fdnum);
  80080d:	a1 04 40 80 00       	mov    0x804004,%eax
  800812:	8b 40 48             	mov    0x48(%eax),%eax
  800815:	83 ec 04             	sub    $0x4,%esp
  800818:	53                   	push   %ebx
  800819:	50                   	push   %eax
  80081a:	68 99 1f 80 00       	push   $0x801f99
  80081f:	e8 fc 09 00 00       	call   801220 <cprintf>
		return -E_INVAL;
  800824:	83 c4 10             	add    $0x10,%esp
  800827:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  80082c:	eb da                	jmp    800808 <write+0x55>
		return -E_NOT_SUPP;
  80082e:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  800833:	eb d3                	jmp    800808 <write+0x55>

00800835 <seek>:

int
seek(int fdnum, off_t offset)
{
  800835:	55                   	push   %ebp
  800836:	89 e5                	mov    %esp,%ebp
  800838:	83 ec 10             	sub    $0x10,%esp
	int r;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0)
  80083b:	8d 45 fc             	lea    -0x4(%ebp),%eax
  80083e:	50                   	push   %eax
  80083f:	ff 75 08             	pushl  0x8(%ebp)
  800842:	e8 31 fc ff ff       	call   800478 <fd_lookup>
  800847:	83 c4 08             	add    $0x8,%esp
  80084a:	85 c0                	test   %eax,%eax
  80084c:	78 0e                	js     80085c <seek+0x27>
		return r;
	fd->fd_offset = offset;
  80084e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800851:	8b 55 0c             	mov    0xc(%ebp),%edx
  800854:	89 50 04             	mov    %edx,0x4(%eax)
	return 0;
  800857:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80085c:	c9                   	leave  
  80085d:	c3                   	ret    

0080085e <ftruncate>:

int
ftruncate(int fdnum, off_t newsize)
{
  80085e:	55                   	push   %ebp
  80085f:	89 e5                	mov    %esp,%ebp
  800861:	53                   	push   %ebx
  800862:	83 ec 14             	sub    $0x14,%esp
  800865:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;
	if ((r = fd_lookup(fdnum, &fd)) < 0
  800868:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80086b:	50                   	push   %eax
  80086c:	53                   	push   %ebx
  80086d:	e8 06 fc ff ff       	call   800478 <fd_lookup>
  800872:	83 c4 08             	add    $0x8,%esp
  800875:	85 c0                	test   %eax,%eax
  800877:	78 37                	js     8008b0 <ftruncate+0x52>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  800879:	83 ec 08             	sub    $0x8,%esp
  80087c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80087f:	50                   	push   %eax
  800880:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800883:	ff 30                	pushl  (%eax)
  800885:	e8 45 fc ff ff       	call   8004cf <dev_lookup>
  80088a:	83 c4 10             	add    $0x10,%esp
  80088d:	85 c0                	test   %eax,%eax
  80088f:	78 1f                	js     8008b0 <ftruncate+0x52>
		return r;
	if ((fd->fd_omode & O_ACCMODE) == O_RDONLY) {
  800891:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800894:	f6 40 08 03          	testb  $0x3,0x8(%eax)
  800898:	74 1b                	je     8008b5 <ftruncate+0x57>
		cprintf("[%08x] ftruncate %d -- bad mode\n",
			thisenv->env_id, fdnum);
		return -E_INVAL;
	}
	if (!dev->dev_trunc)
  80089a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80089d:	8b 52 18             	mov    0x18(%edx),%edx
  8008a0:	85 d2                	test   %edx,%edx
  8008a2:	74 32                	je     8008d6 <ftruncate+0x78>
		return -E_NOT_SUPP;
	return (*dev->dev_trunc)(fd, newsize);
  8008a4:	83 ec 08             	sub    $0x8,%esp
  8008a7:	ff 75 0c             	pushl  0xc(%ebp)
  8008aa:	50                   	push   %eax
  8008ab:	ff d2                	call   *%edx
  8008ad:	83 c4 10             	add    $0x10,%esp
}
  8008b0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008b3:	c9                   	leave  
  8008b4:	c3                   	ret    
			thisenv->env_id, fdnum);
  8008b5:	a1 04 40 80 00       	mov    0x804004,%eax
		cprintf("[%08x] ftruncate %d -- bad mode\n",
  8008ba:	8b 40 48             	mov    0x48(%eax),%eax
  8008bd:	83 ec 04             	sub    $0x4,%esp
  8008c0:	53                   	push   %ebx
  8008c1:	50                   	push   %eax
  8008c2:	68 5c 1f 80 00       	push   $0x801f5c
  8008c7:	e8 54 09 00 00       	call   801220 <cprintf>
		return -E_INVAL;
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8008d4:	eb da                	jmp    8008b0 <ftruncate+0x52>
		return -E_NOT_SUPP;
  8008d6:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  8008db:	eb d3                	jmp    8008b0 <ftruncate+0x52>

008008dd <fstat>:

int
fstat(int fdnum, struct Stat *stat)
{
  8008dd:	55                   	push   %ebp
  8008de:	89 e5                	mov    %esp,%ebp
  8008e0:	53                   	push   %ebx
  8008e1:	83 ec 14             	sub    $0x14,%esp
  8008e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	int r;
	struct Dev *dev;
	struct Fd *fd;

	if ((r = fd_lookup(fdnum, &fd)) < 0
  8008e7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8008ea:	50                   	push   %eax
  8008eb:	ff 75 08             	pushl  0x8(%ebp)
  8008ee:	e8 85 fb ff ff       	call   800478 <fd_lookup>
  8008f3:	83 c4 08             	add    $0x8,%esp
  8008f6:	85 c0                	test   %eax,%eax
  8008f8:	78 4b                	js     800945 <fstat+0x68>
	    || (r = dev_lookup(fd->fd_dev_id, &dev)) < 0)
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800900:	50                   	push   %eax
  800901:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800904:	ff 30                	pushl  (%eax)
  800906:	e8 c4 fb ff ff       	call   8004cf <dev_lookup>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	85 c0                	test   %eax,%eax
  800910:	78 33                	js     800945 <fstat+0x68>
		return r;
	if (!dev->dev_stat)
  800912:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800915:	83 78 14 00          	cmpl   $0x0,0x14(%eax)
  800919:	74 2f                	je     80094a <fstat+0x6d>
		return -E_NOT_SUPP;
	stat->st_name[0] = 0;
  80091b:	c6 03 00             	movb   $0x0,(%ebx)
	stat->st_size = 0;
  80091e:	c7 83 80 00 00 00 00 	movl   $0x0,0x80(%ebx)
  800925:	00 00 00 
	stat->st_type = 0;
  800928:	c7 83 84 00 00 00 00 	movl   $0x0,0x84(%ebx)
  80092f:	00 00 00 
	stat->st_dev = dev;
  800932:	89 83 88 00 00 00    	mov    %eax,0x88(%ebx)
	return (*dev->dev_stat)(fd, stat);
  800938:	83 ec 08             	sub    $0x8,%esp
  80093b:	53                   	push   %ebx
  80093c:	ff 75 f0             	pushl  -0x10(%ebp)
  80093f:	ff 50 14             	call   *0x14(%eax)
  800942:	83 c4 10             	add    $0x10,%esp
}
  800945:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800948:	c9                   	leave  
  800949:	c3                   	ret    
		return -E_NOT_SUPP;
  80094a:	b8 f1 ff ff ff       	mov    $0xfffffff1,%eax
  80094f:	eb f4                	jmp    800945 <fstat+0x68>

00800951 <stat>:

int
stat(const char *path, struct Stat *stat)
{
  800951:	55                   	push   %ebp
  800952:	89 e5                	mov    %esp,%ebp
  800954:	56                   	push   %esi
  800955:	53                   	push   %ebx
	int fd, r;

	if ((fd = open(path, O_RDONLY)) < 0)
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	6a 00                	push   $0x0
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 34 02 00 00       	call   800b97 <open>
  800963:	89 c3                	mov    %eax,%ebx
  800965:	83 c4 10             	add    $0x10,%esp
  800968:	85 c0                	test   %eax,%eax
  80096a:	78 1b                	js     800987 <stat+0x36>
		return fd;
	r = fstat(fd, stat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	50                   	push   %eax
  800973:	e8 65 ff ff ff       	call   8008dd <fstat>
  800978:	89 c6                	mov    %eax,%esi
	close(fd);
  80097a:	89 1c 24             	mov    %ebx,(%esp)
  80097d:	e8 29 fc ff ff       	call   8005ab <close>
	return r;
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	89 f3                	mov    %esi,%ebx
}
  800987:	89 d8                	mov    %ebx,%eax
  800989:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80098c:	5b                   	pop    %ebx
  80098d:	5e                   	pop    %esi
  80098e:	5d                   	pop    %ebp
  80098f:	c3                   	ret    

00800990 <fsipc>:
// type: request code, passed as the simple integer IPC value.
// dstva: virtual address at which to receive reply page, 0 if none.
// Returns result from the file server.
static int
fsipc(unsigned type, void *dstva)
{
  800990:	55                   	push   %ebp
  800991:	89 e5                	mov    %esp,%ebp
  800993:	56                   	push   %esi
  800994:	53                   	push   %ebx
  800995:	89 c6                	mov    %eax,%esi
  800997:	89 d3                	mov    %edx,%ebx
	static envid_t fsenv;
	if (fsenv == 0)
  800999:	83 3d 00 40 80 00 00 	cmpl   $0x0,0x804000
  8009a0:	74 27                	je     8009c9 <fsipc+0x39>
	static_assert(sizeof(fsipcbuf) == PGSIZE);

	if (debug)
		cprintf("[%08x] fsipc %d %08x\n", thisenv->env_id, type, *(uint32_t *)&fsipcbuf);

	ipc_send(fsenv, type, &fsipcbuf, PTE_P | PTE_W | PTE_U);
  8009a2:	6a 07                	push   $0x7
  8009a4:	68 00 50 80 00       	push   $0x805000
  8009a9:	56                   	push   %esi
  8009aa:	ff 35 00 40 80 00    	pushl  0x804000
  8009b0:	e8 14 12 00 00       	call   801bc9 <ipc_send>
	return ipc_recv(NULL, dstva, NULL);
  8009b5:	83 c4 0c             	add    $0xc,%esp
  8009b8:	6a 00                	push   $0x0
  8009ba:	53                   	push   %ebx
  8009bb:	6a 00                	push   $0x0
  8009bd:	e8 7e 11 00 00       	call   801b40 <ipc_recv>
}
  8009c2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009c5:	5b                   	pop    %ebx
  8009c6:	5e                   	pop    %esi
  8009c7:	5d                   	pop    %ebp
  8009c8:	c3                   	ret    
		fsenv = ipc_find_env(ENV_TYPE_FS);
  8009c9:	83 ec 0c             	sub    $0xc,%esp
  8009cc:	6a 01                	push   $0x1
  8009ce:	e8 52 12 00 00       	call   801c25 <ipc_find_env>
  8009d3:	a3 00 40 80 00       	mov    %eax,0x804000
  8009d8:	83 c4 10             	add    $0x10,%esp
  8009db:	eb c5                	jmp    8009a2 <fsipc+0x12>

008009dd <devfile_trunc>:
}

// Truncate or extend an open file to 'size' bytes
static int
devfile_trunc(struct Fd *fd, off_t newsize)
{
  8009dd:	55                   	push   %ebp
  8009de:	89 e5                	mov    %esp,%ebp
  8009e0:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.set_size.req_fileid = fd->fd_file.id;
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8009e9:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.set_size.req_size = newsize;
  8009ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f1:	a3 04 50 80 00       	mov    %eax,0x805004
	return fsipc(FSREQ_SET_SIZE, NULL);
  8009f6:	ba 00 00 00 00       	mov    $0x0,%edx
  8009fb:	b8 02 00 00 00       	mov    $0x2,%eax
  800a00:	e8 8b ff ff ff       	call   800990 <fsipc>
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <devfile_flush>:
{
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 08             	sub    $0x8,%esp
	fsipcbuf.flush.req_fileid = fd->fd_file.id;
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	8b 40 0c             	mov    0xc(%eax),%eax
  800a13:	a3 00 50 80 00       	mov    %eax,0x805000
	return fsipc(FSREQ_FLUSH, NULL);
  800a18:	ba 00 00 00 00       	mov    $0x0,%edx
  800a1d:	b8 06 00 00 00       	mov    $0x6,%eax
  800a22:	e8 69 ff ff ff       	call   800990 <fsipc>
}
  800a27:	c9                   	leave  
  800a28:	c3                   	ret    

00800a29 <devfile_stat>:
{
  800a29:	55                   	push   %ebp
  800a2a:	89 e5                	mov    %esp,%ebp
  800a2c:	53                   	push   %ebx
  800a2d:	83 ec 04             	sub    $0x4,%esp
  800a30:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	fsipcbuf.stat.req_fileid = fd->fd_file.id;
  800a33:	8b 45 08             	mov    0x8(%ebp),%eax
  800a36:	8b 40 0c             	mov    0xc(%eax),%eax
  800a39:	a3 00 50 80 00       	mov    %eax,0x805000
	if ((r = fsipc(FSREQ_STAT, NULL)) < 0)
  800a3e:	ba 00 00 00 00       	mov    $0x0,%edx
  800a43:	b8 05 00 00 00       	mov    $0x5,%eax
  800a48:	e8 43 ff ff ff       	call   800990 <fsipc>
  800a4d:	85 c0                	test   %eax,%eax
  800a4f:	78 2c                	js     800a7d <devfile_stat+0x54>
	strcpy(st->st_name, fsipcbuf.statRet.ret_name);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	68 00 50 80 00       	push   $0x805000
  800a59:	53                   	push   %ebx
  800a5a:	e8 c9 0d 00 00       	call   801828 <strcpy>
	st->st_size = fsipcbuf.statRet.ret_size;
  800a5f:	a1 80 50 80 00       	mov    0x805080,%eax
  800a64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	st->st_type = fsipcbuf.statRet.ret_type;
  800a6a:	a1 84 50 80 00       	mov    0x805084,%eax
  800a6f:	89 83 84 00 00 00    	mov    %eax,0x84(%ebx)
	return 0;
  800a75:	83 c4 10             	add    $0x10,%esp
  800a78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800a7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800a80:	c9                   	leave  
  800a81:	c3                   	ret    

00800a82 <devfile_write>:
{
  800a82:	55                   	push   %ebp
  800a83:	89 e5                	mov    %esp,%ebp
  800a85:	53                   	push   %ebx
  800a86:	83 ec 04             	sub    $0x4,%esp
  800a89:	8b 5d 10             	mov    0x10(%ebp),%ebx
	int size = (n > PGSIZE)? PGSIZE: n;
  800a8c:	89 d8                	mov    %ebx,%eax
  800a8e:	81 fb 00 10 00 00    	cmp    $0x1000,%ebx
  800a94:	76 05                	jbe    800a9b <devfile_write+0x19>
  800a96:	b8 00 10 00 00       	mov    $0x1000,%eax
	fsipcbuf.write.req_fileid = fd->fd_file.id;
  800a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  800a9e:	8b 52 0c             	mov    0xc(%edx),%edx
  800aa1:	89 15 00 50 80 00    	mov    %edx,0x805000
	fsipcbuf.write.req_n = size;
  800aa7:	a3 04 50 80 00       	mov    %eax,0x805004
	memmove(fsipcbuf.write.req_buf, buf, size);
  800aac:	83 ec 04             	sub    $0x4,%esp
  800aaf:	50                   	push   %eax
  800ab0:	ff 75 0c             	pushl  0xc(%ebp)
  800ab3:	68 08 50 80 00       	push   $0x805008
  800ab8:	e8 de 0e 00 00       	call   80199b <memmove>
	if ((r = fsipc(FSREQ_WRITE, NULL)) < 0) {
  800abd:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac2:	b8 04 00 00 00       	mov    $0x4,%eax
  800ac7:	e8 c4 fe ff ff       	call   800990 <fsipc>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	85 c0                	test   %eax,%eax
  800ad1:	78 0b                	js     800ade <devfile_write+0x5c>
	assert(r <= n);
  800ad3:	39 c3                	cmp    %eax,%ebx
  800ad5:	72 0c                	jb     800ae3 <devfile_write+0x61>
	assert(r <= PGSIZE);
  800ad7:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800adc:	7f 1e                	jg     800afc <devfile_write+0x7a>
}
  800ade:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae1:	c9                   	leave  
  800ae2:	c3                   	ret    
	assert(r <= n);
  800ae3:	68 c8 1f 80 00       	push   $0x801fc8
  800ae8:	68 cf 1f 80 00       	push   $0x801fcf
  800aed:	68 98 00 00 00       	push   $0x98
  800af2:	68 e4 1f 80 00       	push   $0x801fe4
  800af7:	e8 11 06 00 00       	call   80110d <_panic>
	assert(r <= PGSIZE);
  800afc:	68 ef 1f 80 00       	push   $0x801fef
  800b01:	68 cf 1f 80 00       	push   $0x801fcf
  800b06:	68 99 00 00 00       	push   $0x99
  800b0b:	68 e4 1f 80 00       	push   $0x801fe4
  800b10:	e8 f8 05 00 00       	call   80110d <_panic>

00800b15 <devfile_read>:
{
  800b15:	55                   	push   %ebp
  800b16:	89 e5                	mov    %esp,%ebp
  800b18:	56                   	push   %esi
  800b19:	53                   	push   %ebx
  800b1a:	8b 75 10             	mov    0x10(%ebp),%esi
	fsipcbuf.read.req_fileid = fd->fd_file.id;
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8b 40 0c             	mov    0xc(%eax),%eax
  800b23:	a3 00 50 80 00       	mov    %eax,0x805000
	fsipcbuf.read.req_n = n;
  800b28:	89 35 04 50 80 00    	mov    %esi,0x805004
	if ((r = fsipc(FSREQ_READ, NULL)) < 0)
  800b2e:	ba 00 00 00 00       	mov    $0x0,%edx
  800b33:	b8 03 00 00 00       	mov    $0x3,%eax
  800b38:	e8 53 fe ff ff       	call   800990 <fsipc>
  800b3d:	89 c3                	mov    %eax,%ebx
  800b3f:	85 c0                	test   %eax,%eax
  800b41:	78 1f                	js     800b62 <devfile_read+0x4d>
	assert(r <= n);
  800b43:	39 c6                	cmp    %eax,%esi
  800b45:	72 24                	jb     800b6b <devfile_read+0x56>
	assert(r <= PGSIZE);
  800b47:	3d 00 10 00 00       	cmp    $0x1000,%eax
  800b4c:	7f 33                	jg     800b81 <devfile_read+0x6c>
	memmove(buf, fsipcbuf.readRet.ret_buf, r);
  800b4e:	83 ec 04             	sub    $0x4,%esp
  800b51:	50                   	push   %eax
  800b52:	68 00 50 80 00       	push   $0x805000
  800b57:	ff 75 0c             	pushl  0xc(%ebp)
  800b5a:	e8 3c 0e 00 00       	call   80199b <memmove>
	return r;
  800b5f:	83 c4 10             	add    $0x10,%esp
}
  800b62:	89 d8                	mov    %ebx,%eax
  800b64:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b67:	5b                   	pop    %ebx
  800b68:	5e                   	pop    %esi
  800b69:	5d                   	pop    %ebp
  800b6a:	c3                   	ret    
	assert(r <= n);
  800b6b:	68 c8 1f 80 00       	push   $0x801fc8
  800b70:	68 cf 1f 80 00       	push   $0x801fcf
  800b75:	6a 7c                	push   $0x7c
  800b77:	68 e4 1f 80 00       	push   $0x801fe4
  800b7c:	e8 8c 05 00 00       	call   80110d <_panic>
	assert(r <= PGSIZE);
  800b81:	68 ef 1f 80 00       	push   $0x801fef
  800b86:	68 cf 1f 80 00       	push   $0x801fcf
  800b8b:	6a 7d                	push   $0x7d
  800b8d:	68 e4 1f 80 00       	push   $0x801fe4
  800b92:	e8 76 05 00 00       	call   80110d <_panic>

00800b97 <open>:
{
  800b97:	55                   	push   %ebp
  800b98:	89 e5                	mov    %esp,%ebp
  800b9a:	56                   	push   %esi
  800b9b:	53                   	push   %ebx
  800b9c:	83 ec 1c             	sub    $0x1c,%esp
  800b9f:	8b 75 08             	mov    0x8(%ebp),%esi
	if (strlen(path) >= MAXPATHLEN)
  800ba2:	56                   	push   %esi
  800ba3:	e8 4d 0c 00 00       	call   8017f5 <strlen>
  800ba8:	83 c4 10             	add    $0x10,%esp
  800bab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
  800bb0:	7f 6c                	jg     800c1e <open+0x87>
	if ((r = fd_alloc(&fd)) < 0)
  800bb2:	83 ec 0c             	sub    $0xc,%esp
  800bb5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800bb8:	50                   	push   %eax
  800bb9:	e8 6b f8 ff ff       	call   800429 <fd_alloc>
  800bbe:	89 c3                	mov    %eax,%ebx
  800bc0:	83 c4 10             	add    $0x10,%esp
  800bc3:	85 c0                	test   %eax,%eax
  800bc5:	78 3c                	js     800c03 <open+0x6c>
	strcpy(fsipcbuf.open.req_path, path);
  800bc7:	83 ec 08             	sub    $0x8,%esp
  800bca:	56                   	push   %esi
  800bcb:	68 00 50 80 00       	push   $0x805000
  800bd0:	e8 53 0c 00 00       	call   801828 <strcpy>
	fsipcbuf.open.req_omode = mode;
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	a3 00 54 80 00       	mov    %eax,0x805400
	if ((r = fsipc(FSREQ_OPEN, fd)) < 0) {
  800bdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800be0:	b8 01 00 00 00       	mov    $0x1,%eax
  800be5:	e8 a6 fd ff ff       	call   800990 <fsipc>
  800bea:	89 c3                	mov    %eax,%ebx
  800bec:	83 c4 10             	add    $0x10,%esp
  800bef:	85 c0                	test   %eax,%eax
  800bf1:	78 19                	js     800c0c <open+0x75>
	return fd2num(fd);
  800bf3:	83 ec 0c             	sub    $0xc,%esp
  800bf6:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf9:	e8 04 f8 ff ff       	call   800402 <fd2num>
  800bfe:	89 c3                	mov    %eax,%ebx
  800c00:	83 c4 10             	add    $0x10,%esp
}
  800c03:	89 d8                	mov    %ebx,%eax
  800c05:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c08:	5b                   	pop    %ebx
  800c09:	5e                   	pop    %esi
  800c0a:	5d                   	pop    %ebp
  800c0b:	c3                   	ret    
		fd_close(fd, 0);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	6a 00                	push   $0x0
  800c11:	ff 75 f4             	pushl  -0xc(%ebp)
  800c14:	e8 0c f9 ff ff       	call   800525 <fd_close>
		return r;
  800c19:	83 c4 10             	add    $0x10,%esp
  800c1c:	eb e5                	jmp    800c03 <open+0x6c>
		return -E_BAD_PATH;
  800c1e:	bb f4 ff ff ff       	mov    $0xfffffff4,%ebx
  800c23:	eb de                	jmp    800c03 <open+0x6c>

00800c25 <sync>:


// Synchronize disk with buffer cache
int
sync(void)
{
  800c25:	55                   	push   %ebp
  800c26:	89 e5                	mov    %esp,%ebp
  800c28:	83 ec 08             	sub    $0x8,%esp
	// Ask the file server to update the disk
	// by writing any dirty blocks in the buffer cache.

	return fsipc(FSREQ_SYNC, NULL);
  800c2b:	ba 00 00 00 00       	mov    $0x0,%edx
  800c30:	b8 08 00 00 00       	mov    $0x8,%eax
  800c35:	e8 56 fd ff ff       	call   800990 <fsipc>
}
  800c3a:	c9                   	leave  
  800c3b:	c3                   	ret    

00800c3c <devpipe_stat>:
	return i;
}

static int
devpipe_stat(struct Fd *fd, struct Stat *stat)
{
  800c3c:	55                   	push   %ebp
  800c3d:	89 e5                	mov    %esp,%ebp
  800c3f:	56                   	push   %esi
  800c40:	53                   	push   %ebx
  800c41:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	struct Pipe *p = (struct Pipe*) fd2data(fd);
  800c44:	83 ec 0c             	sub    $0xc,%esp
  800c47:	ff 75 08             	pushl  0x8(%ebp)
  800c4a:	e8 c3 f7 ff ff       	call   800412 <fd2data>
  800c4f:	89 c6                	mov    %eax,%esi
	strcpy(stat->st_name, "<pipe>");
  800c51:	83 c4 08             	add    $0x8,%esp
  800c54:	68 fb 1f 80 00       	push   $0x801ffb
  800c59:	53                   	push   %ebx
  800c5a:	e8 c9 0b 00 00       	call   801828 <strcpy>
	stat->st_size = p->p_wpos - p->p_rpos;
  800c5f:	8b 46 04             	mov    0x4(%esi),%eax
  800c62:	2b 06                	sub    (%esi),%eax
  800c64:	89 83 80 00 00 00    	mov    %eax,0x80(%ebx)
	stat->st_type = FTYPE_IFIFO;
  800c6a:	c7 83 84 00 00 00 00 	movl   $0x1000,0x84(%ebx)
  800c71:	10 00 00 
	stat->st_dev = &devpipe;
  800c74:	c7 83 88 00 00 00 20 	movl   $0x803020,0x88(%ebx)
  800c7b:	30 80 00 
	return 0;
}
  800c7e:	b8 00 00 00 00       	mov    $0x0,%eax
  800c83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c86:	5b                   	pop    %ebx
  800c87:	5e                   	pop    %esi
  800c88:	5d                   	pop    %ebp
  800c89:	c3                   	ret    

00800c8a <devpipe_close>:

static int
devpipe_close(struct Fd *fd)
{
  800c8a:	55                   	push   %ebp
  800c8b:	89 e5                	mov    %esp,%ebp
  800c8d:	53                   	push   %ebx
  800c8e:	83 ec 0c             	sub    $0xc,%esp
  800c91:	8b 5d 08             	mov    0x8(%ebp),%ebx
	(void) sys_page_unmap(0, fd);
  800c94:	53                   	push   %ebx
  800c95:	6a 00                	push   $0x0
  800c97:	e8 36 f5 ff ff       	call   8001d2 <sys_page_unmap>
	return sys_page_unmap(0, fd2data(fd));
  800c9c:	89 1c 24             	mov    %ebx,(%esp)
  800c9f:	e8 6e f7 ff ff       	call   800412 <fd2data>
  800ca4:	83 c4 08             	add    $0x8,%esp
  800ca7:	50                   	push   %eax
  800ca8:	6a 00                	push   $0x0
  800caa:	e8 23 f5 ff ff       	call   8001d2 <sys_page_unmap>
}
  800caf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800cb2:	c9                   	leave  
  800cb3:	c3                   	ret    

00800cb4 <_pipeisclosed>:
{
  800cb4:	55                   	push   %ebp
  800cb5:	89 e5                	mov    %esp,%ebp
  800cb7:	57                   	push   %edi
  800cb8:	56                   	push   %esi
  800cb9:	53                   	push   %ebx
  800cba:	83 ec 1c             	sub    $0x1c,%esp
  800cbd:	89 c7                	mov    %eax,%edi
  800cbf:	89 d6                	mov    %edx,%esi
		n = thisenv->env_runs;
  800cc1:	a1 04 40 80 00       	mov    0x804004,%eax
  800cc6:	8b 58 58             	mov    0x58(%eax),%ebx
		ret = pageref(fd) == pageref(p);
  800cc9:	83 ec 0c             	sub    $0xc,%esp
  800ccc:	57                   	push   %edi
  800ccd:	e8 95 0f 00 00       	call   801c67 <pageref>
  800cd2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cd5:	89 34 24             	mov    %esi,(%esp)
  800cd8:	e8 8a 0f 00 00       	call   801c67 <pageref>
		nn = thisenv->env_runs;
  800cdd:	8b 15 04 40 80 00    	mov    0x804004,%edx
  800ce3:	8b 4a 58             	mov    0x58(%edx),%ecx
		if (n == nn)
  800ce6:	83 c4 10             	add    $0x10,%esp
  800ce9:	39 cb                	cmp    %ecx,%ebx
  800ceb:	74 1b                	je     800d08 <_pipeisclosed+0x54>
		if (n != nn && ret == 1)
  800ced:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800cf0:	75 cf                	jne    800cc1 <_pipeisclosed+0xd>
			cprintf("pipe race avoided\n", n, thisenv->env_runs, ret);
  800cf2:	8b 42 58             	mov    0x58(%edx),%eax
  800cf5:	6a 01                	push   $0x1
  800cf7:	50                   	push   %eax
  800cf8:	53                   	push   %ebx
  800cf9:	68 02 20 80 00       	push   $0x802002
  800cfe:	e8 1d 05 00 00       	call   801220 <cprintf>
  800d03:	83 c4 10             	add    $0x10,%esp
  800d06:	eb b9                	jmp    800cc1 <_pipeisclosed+0xd>
		ret = pageref(fd) == pageref(p);
  800d08:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  800d0b:	0f 94 c0             	sete   %al
  800d0e:	0f b6 c0             	movzbl %al,%eax
}
  800d11:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d14:	5b                   	pop    %ebx
  800d15:	5e                   	pop    %esi
  800d16:	5f                   	pop    %edi
  800d17:	5d                   	pop    %ebp
  800d18:	c3                   	ret    

00800d19 <devpipe_write>:
{
  800d19:	55                   	push   %ebp
  800d1a:	89 e5                	mov    %esp,%ebp
  800d1c:	57                   	push   %edi
  800d1d:	56                   	push   %esi
  800d1e:	53                   	push   %ebx
  800d1f:	83 ec 18             	sub    $0x18,%esp
  800d22:	8b 75 08             	mov    0x8(%ebp),%esi
	p = (struct Pipe*) fd2data(fd);
  800d25:	56                   	push   %esi
  800d26:	e8 e7 f6 ff ff       	call   800412 <fd2data>
  800d2b:	89 c3                	mov    %eax,%ebx
	for (i = 0; i < n; i++) {
  800d2d:	83 c4 10             	add    $0x10,%esp
  800d30:	bf 00 00 00 00       	mov    $0x0,%edi
  800d35:	3b 7d 10             	cmp    0x10(%ebp),%edi
  800d38:	74 41                	je     800d7b <devpipe_write+0x62>
		while (p->p_wpos >= p->p_rpos + sizeof(p->p_buf)) {
  800d3a:	8b 53 04             	mov    0x4(%ebx),%edx
  800d3d:	8b 03                	mov    (%ebx),%eax
  800d3f:	83 c0 20             	add    $0x20,%eax
  800d42:	39 c2                	cmp    %eax,%edx
  800d44:	72 14                	jb     800d5a <devpipe_write+0x41>
			if (_pipeisclosed(fd, p))
  800d46:	89 da                	mov    %ebx,%edx
  800d48:	89 f0                	mov    %esi,%eax
  800d4a:	e8 65 ff ff ff       	call   800cb4 <_pipeisclosed>
  800d4f:	85 c0                	test   %eax,%eax
  800d51:	75 2c                	jne    800d7f <devpipe_write+0x66>
			sys_yield();
  800d53:	e8 bc f4 ff ff       	call   800214 <sys_yield>
  800d58:	eb e0                	jmp    800d3a <devpipe_write+0x21>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5d:	8a 0c 38             	mov    (%eax,%edi,1),%cl
  800d60:	89 d0                	mov    %edx,%eax
  800d62:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800d67:	78 0b                	js     800d74 <devpipe_write+0x5b>
  800d69:	88 4c 03 08          	mov    %cl,0x8(%ebx,%eax,1)
		p->p_wpos++;
  800d6d:	42                   	inc    %edx
  800d6e:	89 53 04             	mov    %edx,0x4(%ebx)
	for (i = 0; i < n; i++) {
  800d71:	47                   	inc    %edi
  800d72:	eb c1                	jmp    800d35 <devpipe_write+0x1c>
		p->p_buf[p->p_wpos % PIPEBUFSIZ] = buf[i];
  800d74:	48                   	dec    %eax
  800d75:	83 c8 e0             	or     $0xffffffe0,%eax
  800d78:	40                   	inc    %eax
  800d79:	eb ee                	jmp    800d69 <devpipe_write+0x50>
	return i;
  800d7b:	89 f8                	mov    %edi,%eax
  800d7d:	eb 05                	jmp    800d84 <devpipe_write+0x6b>
				return 0;
  800d7f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800d87:	5b                   	pop    %ebx
  800d88:	5e                   	pop    %esi
  800d89:	5f                   	pop    %edi
  800d8a:	5d                   	pop    %ebp
  800d8b:	c3                   	ret    

00800d8c <devpipe_read>:
{
  800d8c:	55                   	push   %ebp
  800d8d:	89 e5                	mov    %esp,%ebp
  800d8f:	57                   	push   %edi
  800d90:	56                   	push   %esi
  800d91:	53                   	push   %ebx
  800d92:	83 ec 18             	sub    $0x18,%esp
  800d95:	8b 7d 08             	mov    0x8(%ebp),%edi
	p = (struct Pipe*)fd2data(fd);
  800d98:	57                   	push   %edi
  800d99:	e8 74 f6 ff ff       	call   800412 <fd2data>
  800d9e:	89 c6                	mov    %eax,%esi
	for (i = 0; i < n; i++) {
  800da0:	83 c4 10             	add    $0x10,%esp
  800da3:	bb 00 00 00 00       	mov    $0x0,%ebx
  800da8:	3b 5d 10             	cmp    0x10(%ebp),%ebx
  800dab:	74 46                	je     800df3 <devpipe_read+0x67>
		while (p->p_rpos == p->p_wpos) {
  800dad:	8b 06                	mov    (%esi),%eax
  800daf:	3b 46 04             	cmp    0x4(%esi),%eax
  800db2:	75 22                	jne    800dd6 <devpipe_read+0x4a>
			if (i > 0)
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	74 0a                	je     800dc2 <devpipe_read+0x36>
				return i;
  800db8:	89 d8                	mov    %ebx,%eax
}
  800dba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800dbd:	5b                   	pop    %ebx
  800dbe:	5e                   	pop    %esi
  800dbf:	5f                   	pop    %edi
  800dc0:	5d                   	pop    %ebp
  800dc1:	c3                   	ret    
			if (_pipeisclosed(fd, p))
  800dc2:	89 f2                	mov    %esi,%edx
  800dc4:	89 f8                	mov    %edi,%eax
  800dc6:	e8 e9 fe ff ff       	call   800cb4 <_pipeisclosed>
  800dcb:	85 c0                	test   %eax,%eax
  800dcd:	75 28                	jne    800df7 <devpipe_read+0x6b>
			sys_yield();
  800dcf:	e8 40 f4 ff ff       	call   800214 <sys_yield>
  800dd4:	eb d7                	jmp    800dad <devpipe_read+0x21>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dd6:	25 1f 00 00 80       	and    $0x8000001f,%eax
  800ddb:	78 0f                	js     800dec <devpipe_read+0x60>
  800ddd:	8a 44 06 08          	mov    0x8(%esi,%eax,1),%al
  800de1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800de4:	88 04 19             	mov    %al,(%ecx,%ebx,1)
		p->p_rpos++;
  800de7:	ff 06                	incl   (%esi)
	for (i = 0; i < n; i++) {
  800de9:	43                   	inc    %ebx
  800dea:	eb bc                	jmp    800da8 <devpipe_read+0x1c>
		buf[i] = p->p_buf[p->p_rpos % PIPEBUFSIZ];
  800dec:	48                   	dec    %eax
  800ded:	83 c8 e0             	or     $0xffffffe0,%eax
  800df0:	40                   	inc    %eax
  800df1:	eb ea                	jmp    800ddd <devpipe_read+0x51>
	return i;
  800df3:	89 d8                	mov    %ebx,%eax
  800df5:	eb c3                	jmp    800dba <devpipe_read+0x2e>
				return 0;
  800df7:	b8 00 00 00 00       	mov    $0x0,%eax
  800dfc:	eb bc                	jmp    800dba <devpipe_read+0x2e>

00800dfe <pipe>:
{
  800dfe:	55                   	push   %ebp
  800dff:	89 e5                	mov    %esp,%ebp
  800e01:	56                   	push   %esi
  800e02:	53                   	push   %ebx
  800e03:	83 ec 1c             	sub    $0x1c,%esp
	if ((r = fd_alloc(&fd0)) < 0
  800e06:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800e09:	50                   	push   %eax
  800e0a:	e8 1a f6 ff ff       	call   800429 <fd_alloc>
  800e0f:	89 c3                	mov    %eax,%ebx
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	85 c0                	test   %eax,%eax
  800e16:	0f 88 2a 01 00 00    	js     800f46 <pipe+0x148>
	    || (r = sys_page_alloc(0, fd0, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e1c:	83 ec 04             	sub    $0x4,%esp
  800e1f:	68 07 04 00 00       	push   $0x407
  800e24:	ff 75 f4             	pushl  -0xc(%ebp)
  800e27:	6a 00                	push   $0x0
  800e29:	e8 1f f3 ff ff       	call   80014d <sys_page_alloc>
  800e2e:	89 c3                	mov    %eax,%ebx
  800e30:	83 c4 10             	add    $0x10,%esp
  800e33:	85 c0                	test   %eax,%eax
  800e35:	0f 88 0b 01 00 00    	js     800f46 <pipe+0x148>
	if ((r = fd_alloc(&fd1)) < 0
  800e3b:	83 ec 0c             	sub    $0xc,%esp
  800e3e:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800e41:	50                   	push   %eax
  800e42:	e8 e2 f5 ff ff       	call   800429 <fd_alloc>
  800e47:	89 c3                	mov    %eax,%ebx
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	85 c0                	test   %eax,%eax
  800e4e:	0f 88 e2 00 00 00    	js     800f36 <pipe+0x138>
	    || (r = sys_page_alloc(0, fd1, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e54:	83 ec 04             	sub    $0x4,%esp
  800e57:	68 07 04 00 00       	push   $0x407
  800e5c:	ff 75 f0             	pushl  -0x10(%ebp)
  800e5f:	6a 00                	push   $0x0
  800e61:	e8 e7 f2 ff ff       	call   80014d <sys_page_alloc>
  800e66:	89 c3                	mov    %eax,%ebx
  800e68:	83 c4 10             	add    $0x10,%esp
  800e6b:	85 c0                	test   %eax,%eax
  800e6d:	0f 88 c3 00 00 00    	js     800f36 <pipe+0x138>
	va = fd2data(fd0);
  800e73:	83 ec 0c             	sub    $0xc,%esp
  800e76:	ff 75 f4             	pushl  -0xc(%ebp)
  800e79:	e8 94 f5 ff ff       	call   800412 <fd2data>
  800e7e:	89 c6                	mov    %eax,%esi
	if ((r = sys_page_alloc(0, va, PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e80:	83 c4 0c             	add    $0xc,%esp
  800e83:	68 07 04 00 00       	push   $0x407
  800e88:	50                   	push   %eax
  800e89:	6a 00                	push   $0x0
  800e8b:	e8 bd f2 ff ff       	call   80014d <sys_page_alloc>
  800e90:	89 c3                	mov    %eax,%ebx
  800e92:	83 c4 10             	add    $0x10,%esp
  800e95:	85 c0                	test   %eax,%eax
  800e97:	0f 88 89 00 00 00    	js     800f26 <pipe+0x128>
	if ((r = sys_page_map(0, va, 0, fd2data(fd1), PTE_P|PTE_W|PTE_U|PTE_SHARE)) < 0)
  800e9d:	83 ec 0c             	sub    $0xc,%esp
  800ea0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ea3:	e8 6a f5 ff ff       	call   800412 <fd2data>
  800ea8:	c7 04 24 07 04 00 00 	movl   $0x407,(%esp)
  800eaf:	50                   	push   %eax
  800eb0:	6a 00                	push   $0x0
  800eb2:	56                   	push   %esi
  800eb3:	6a 00                	push   $0x0
  800eb5:	e8 d6 f2 ff ff       	call   800190 <sys_page_map>
  800eba:	89 c3                	mov    %eax,%ebx
  800ebc:	83 c4 20             	add    $0x20,%esp
  800ebf:	85 c0                	test   %eax,%eax
  800ec1:	78 55                	js     800f18 <pipe+0x11a>
	fd0->fd_dev_id = devpipe.dev_id;
  800ec3:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ecc:	89 10                	mov    %edx,(%eax)
	fd0->fd_omode = O_RDONLY;
  800ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ed1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	fd1->fd_dev_id = devpipe.dev_id;
  800ed8:	8b 15 20 30 80 00    	mov    0x803020,%edx
  800ede:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee1:	89 10                	mov    %edx,(%eax)
	fd1->fd_omode = O_WRONLY;
  800ee3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ee6:	c7 40 08 01 00 00 00 	movl   $0x1,0x8(%eax)
	pfd[0] = fd2num(fd0);
  800eed:	83 ec 0c             	sub    $0xc,%esp
  800ef0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ef3:	e8 0a f5 ff ff       	call   800402 <fd2num>
  800ef8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efb:	89 01                	mov    %eax,(%ecx)
	pfd[1] = fd2num(fd1);
  800efd:	83 c4 04             	add    $0x4,%esp
  800f00:	ff 75 f0             	pushl  -0x10(%ebp)
  800f03:	e8 fa f4 ff ff       	call   800402 <fd2num>
  800f08:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f0b:	89 41 04             	mov    %eax,0x4(%ecx)
	return 0;
  800f0e:	83 c4 10             	add    $0x10,%esp
  800f11:	bb 00 00 00 00       	mov    $0x0,%ebx
  800f16:	eb 2e                	jmp    800f46 <pipe+0x148>
	sys_page_unmap(0, va);
  800f18:	83 ec 08             	sub    $0x8,%esp
  800f1b:	56                   	push   %esi
  800f1c:	6a 00                	push   $0x0
  800f1e:	e8 af f2 ff ff       	call   8001d2 <sys_page_unmap>
  800f23:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd1);
  800f26:	83 ec 08             	sub    $0x8,%esp
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	6a 00                	push   $0x0
  800f2e:	e8 9f f2 ff ff       	call   8001d2 <sys_page_unmap>
  800f33:	83 c4 10             	add    $0x10,%esp
	sys_page_unmap(0, fd0);
  800f36:	83 ec 08             	sub    $0x8,%esp
  800f39:	ff 75 f4             	pushl  -0xc(%ebp)
  800f3c:	6a 00                	push   $0x0
  800f3e:	e8 8f f2 ff ff       	call   8001d2 <sys_page_unmap>
  800f43:	83 c4 10             	add    $0x10,%esp
}
  800f46:	89 d8                	mov    %ebx,%eax
  800f48:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f4b:	5b                   	pop    %ebx
  800f4c:	5e                   	pop    %esi
  800f4d:	5d                   	pop    %ebp
  800f4e:	c3                   	ret    

00800f4f <pipeisclosed>:
{
  800f4f:	55                   	push   %ebp
  800f50:	89 e5                	mov    %esp,%ebp
  800f52:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  800f55:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800f58:	50                   	push   %eax
  800f59:	ff 75 08             	pushl  0x8(%ebp)
  800f5c:	e8 17 f5 ff ff       	call   800478 <fd_lookup>
  800f61:	83 c4 10             	add    $0x10,%esp
  800f64:	85 c0                	test   %eax,%eax
  800f66:	78 18                	js     800f80 <pipeisclosed+0x31>
	p = (struct Pipe*) fd2data(fd);
  800f68:	83 ec 0c             	sub    $0xc,%esp
  800f6b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6e:	e8 9f f4 ff ff       	call   800412 <fd2data>
	return _pipeisclosed(fd, p);
  800f73:	89 c2                	mov    %eax,%edx
  800f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f78:	e8 37 fd ff ff       	call   800cb4 <_pipeisclosed>
  800f7d:	83 c4 10             	add    $0x10,%esp
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <devcons_close>:
	return tot;
}

static int
devcons_close(struct Fd *fd)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
	USED(fd);

	return 0;
}
  800f85:	b8 00 00 00 00       	mov    $0x0,%eax
  800f8a:	5d                   	pop    %ebp
  800f8b:	c3                   	ret    

00800f8c <devcons_stat>:

static int
devcons_stat(struct Fd *fd, struct Stat *stat)
{
  800f8c:	55                   	push   %ebp
  800f8d:	89 e5                	mov    %esp,%ebp
  800f8f:	53                   	push   %ebx
  800f90:	83 ec 0c             	sub    $0xc,%esp
  800f93:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	strcpy(stat->st_name, "<cons>");
  800f96:	68 1a 20 80 00       	push   $0x80201a
  800f9b:	53                   	push   %ebx
  800f9c:	e8 87 08 00 00       	call   801828 <strcpy>
	stat->st_type = FTYPE_IFCHR;
  800fa1:	c7 83 84 00 00 00 00 	movl   $0x2000,0x84(%ebx)
  800fa8:	20 00 00 
	return 0;
}
  800fab:	b8 00 00 00 00       	mov    $0x0,%eax
  800fb0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800fb3:	c9                   	leave  
  800fb4:	c3                   	ret    

00800fb5 <devcons_write>:
{
  800fb5:	55                   	push   %ebp
  800fb6:	89 e5                	mov    %esp,%ebp
  800fb8:	57                   	push   %edi
  800fb9:	56                   	push   %esi
  800fba:	53                   	push   %ebx
  800fbb:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
	for (tot = 0; tot < n; tot += m) {
  800fc1:	be 00 00 00 00       	mov    $0x0,%esi
		memmove(buf, (char*)vbuf + tot, m);
  800fc6:	8d bd 68 ff ff ff    	lea    -0x98(%ebp),%edi
	for (tot = 0; tot < n; tot += m) {
  800fcc:	eb 1d                	jmp    800feb <devcons_write+0x36>
		memmove(buf, (char*)vbuf + tot, m);
  800fce:	83 ec 04             	sub    $0x4,%esp
  800fd1:	53                   	push   %ebx
  800fd2:	03 45 0c             	add    0xc(%ebp),%eax
  800fd5:	50                   	push   %eax
  800fd6:	57                   	push   %edi
  800fd7:	e8 bf 09 00 00       	call   80199b <memmove>
		sys_cputs(buf, m);
  800fdc:	83 c4 08             	add    $0x8,%esp
  800fdf:	53                   	push   %ebx
  800fe0:	57                   	push   %edi
  800fe1:	e8 ca f0 ff ff       	call   8000b0 <sys_cputs>
	for (tot = 0; tot < n; tot += m) {
  800fe6:	01 de                	add    %ebx,%esi
  800fe8:	83 c4 10             	add    $0x10,%esp
  800feb:	89 f0                	mov    %esi,%eax
  800fed:	3b 75 10             	cmp    0x10(%ebp),%esi
  800ff0:	73 11                	jae    801003 <devcons_write+0x4e>
		m = n - tot;
  800ff2:	8b 5d 10             	mov    0x10(%ebp),%ebx
  800ff5:	29 f3                	sub    %esi,%ebx
  800ff7:	83 fb 7f             	cmp    $0x7f,%ebx
  800ffa:	76 d2                	jbe    800fce <devcons_write+0x19>
  800ffc:	bb 7f 00 00 00       	mov    $0x7f,%ebx
  801001:	eb cb                	jmp    800fce <devcons_write+0x19>
}
  801003:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801006:	5b                   	pop    %ebx
  801007:	5e                   	pop    %esi
  801008:	5f                   	pop    %edi
  801009:	5d                   	pop    %ebp
  80100a:	c3                   	ret    

0080100b <devcons_read>:
{
  80100b:	55                   	push   %ebp
  80100c:	89 e5                	mov    %esp,%ebp
  80100e:	83 ec 08             	sub    $0x8,%esp
	if (n == 0)
  801011:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801015:	75 0c                	jne    801023 <devcons_read+0x18>
		return 0;
  801017:	b8 00 00 00 00       	mov    $0x0,%eax
  80101c:	eb 21                	jmp    80103f <devcons_read+0x34>
		sys_yield();
  80101e:	e8 f1 f1 ff ff       	call   800214 <sys_yield>
	while ((c = sys_cgetc()) == 0)
  801023:	e8 a6 f0 ff ff       	call   8000ce <sys_cgetc>
  801028:	85 c0                	test   %eax,%eax
  80102a:	74 f2                	je     80101e <devcons_read+0x13>
	if (c < 0)
  80102c:	85 c0                	test   %eax,%eax
  80102e:	78 0f                	js     80103f <devcons_read+0x34>
	if (c == 0x04)	// ctl-d is eof
  801030:	83 f8 04             	cmp    $0x4,%eax
  801033:	74 0c                	je     801041 <devcons_read+0x36>
	*(char*)vbuf = c;
  801035:	8b 55 0c             	mov    0xc(%ebp),%edx
  801038:	88 02                	mov    %al,(%edx)
	return 1;
  80103a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80103f:	c9                   	leave  
  801040:	c3                   	ret    
		return 0;
  801041:	b8 00 00 00 00       	mov    $0x0,%eax
  801046:	eb f7                	jmp    80103f <devcons_read+0x34>

00801048 <cputchar>:
{
  801048:	55                   	push   %ebp
  801049:	89 e5                	mov    %esp,%ebp
  80104b:	83 ec 20             	sub    $0x20,%esp
	char c = ch;
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	88 45 f7             	mov    %al,-0x9(%ebp)
	sys_cputs(&c, 1);
  801054:	6a 01                	push   $0x1
  801056:	8d 45 f7             	lea    -0x9(%ebp),%eax
  801059:	50                   	push   %eax
  80105a:	e8 51 f0 ff ff       	call   8000b0 <sys_cputs>
}
  80105f:	83 c4 10             	add    $0x10,%esp
  801062:	c9                   	leave  
  801063:	c3                   	ret    

00801064 <getchar>:
{
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 ec 1c             	sub    $0x1c,%esp
	r = read(0, &c, 1);
  80106a:	6a 01                	push   $0x1
  80106c:	8d 45 f7             	lea    -0x9(%ebp),%eax
  80106f:	50                   	push   %eax
  801070:	6a 00                	push   $0x0
  801072:	e8 6e f6 ff ff       	call   8006e5 <read>
	if (r < 0)
  801077:	83 c4 10             	add    $0x10,%esp
  80107a:	85 c0                	test   %eax,%eax
  80107c:	78 08                	js     801086 <getchar+0x22>
	if (r < 1)
  80107e:	85 c0                	test   %eax,%eax
  801080:	7e 06                	jle    801088 <getchar+0x24>
	return c;
  801082:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    
		return -E_EOF;
  801088:	b8 f8 ff ff ff       	mov    $0xfffffff8,%eax
  80108d:	eb f7                	jmp    801086 <getchar+0x22>

0080108f <iscons>:
{
  80108f:	55                   	push   %ebp
  801090:	89 e5                	mov    %esp,%ebp
  801092:	83 ec 20             	sub    $0x20,%esp
	if ((r = fd_lookup(fdnum, &fd)) < 0)
  801095:	8d 45 f4             	lea    -0xc(%ebp),%eax
  801098:	50                   	push   %eax
  801099:	ff 75 08             	pushl  0x8(%ebp)
  80109c:	e8 d7 f3 ff ff       	call   800478 <fd_lookup>
  8010a1:	83 c4 10             	add    $0x10,%esp
  8010a4:	85 c0                	test   %eax,%eax
  8010a6:	78 11                	js     8010b9 <iscons+0x2a>
	return fd->fd_dev_id == devcons.dev_id;
  8010a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010ab:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010b1:	39 10                	cmp    %edx,(%eax)
  8010b3:	0f 94 c0             	sete   %al
  8010b6:	0f b6 c0             	movzbl %al,%eax
}
  8010b9:	c9                   	leave  
  8010ba:	c3                   	ret    

008010bb <opencons>:
{
  8010bb:	55                   	push   %ebp
  8010bc:	89 e5                	mov    %esp,%ebp
  8010be:	83 ec 24             	sub    $0x24,%esp
	if ((r = fd_alloc(&fd)) < 0)
  8010c1:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8010c4:	50                   	push   %eax
  8010c5:	e8 5f f3 ff ff       	call   800429 <fd_alloc>
  8010ca:	83 c4 10             	add    $0x10,%esp
  8010cd:	85 c0                	test   %eax,%eax
  8010cf:	78 3a                	js     80110b <opencons+0x50>
	if ((r = sys_page_alloc(0, fd, PTE_P|PTE_U|PTE_W|PTE_SHARE)) < 0)
  8010d1:	83 ec 04             	sub    $0x4,%esp
  8010d4:	68 07 04 00 00       	push   $0x407
  8010d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8010dc:	6a 00                	push   $0x0
  8010de:	e8 6a f0 ff ff       	call   80014d <sys_page_alloc>
  8010e3:	83 c4 10             	add    $0x10,%esp
  8010e6:	85 c0                	test   %eax,%eax
  8010e8:	78 21                	js     80110b <opencons+0x50>
	fd->fd_dev_id = devcons.dev_id;
  8010ea:	8b 15 3c 30 80 00    	mov    0x80303c,%edx
  8010f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f3:	89 10                	mov    %edx,(%eax)
	fd->fd_omode = O_RDWR;
  8010f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010f8:	c7 40 08 02 00 00 00 	movl   $0x2,0x8(%eax)
	return fd2num(fd);
  8010ff:	83 ec 0c             	sub    $0xc,%esp
  801102:	50                   	push   %eax
  801103:	e8 fa f2 ff ff       	call   800402 <fd2num>
  801108:	83 c4 10             	add    $0x10,%esp
}
  80110b:	c9                   	leave  
  80110c:	c3                   	ret    

0080110d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes JOS to enter the JOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt, ...)
{
  80110d:	55                   	push   %ebp
  80110e:	89 e5                	mov    %esp,%ebp
  801110:	57                   	push   %edi
  801111:	56                   	push   %esi
  801112:	53                   	push   %ebx
  801113:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
	va_list ap;
	char buf[256];
	int r = 0;

	va_start(ap, fmt);
  801119:	8d 7d 14             	lea    0x14(%ebp),%edi

	// Print the panic message
	r = snprintf(buf, sizeof(buf), "[%08x] user panic in %s at %s:%d: ",
  80111c:	8b 1d 00 30 80 00    	mov    0x803000,%ebx
  801122:	e8 07 f0 ff ff       	call   80012e <sys_getenvid>
  801127:	83 ec 04             	sub    $0x4,%esp
  80112a:	ff 75 0c             	pushl  0xc(%ebp)
  80112d:	ff 75 08             	pushl  0x8(%ebp)
  801130:	53                   	push   %ebx
  801131:	50                   	push   %eax
  801132:	68 28 20 80 00       	push   $0x802028
  801137:	68 00 01 00 00       	push   $0x100
  80113c:	8d b5 e8 fe ff ff    	lea    -0x118(%ebp),%esi
  801142:	56                   	push   %esi
  801143:	e8 93 06 00 00       	call   8017db <snprintf>
  801148:	89 c3                	mov    %eax,%ebx
		     sys_getenvid(), binaryname, file, line);
	r += vsnprintf(buf + r, sizeof(buf) - r, fmt, ap);
  80114a:	83 c4 20             	add    $0x20,%esp
  80114d:	57                   	push   %edi
  80114e:	ff 75 10             	pushl  0x10(%ebp)
  801151:	bf 00 01 00 00       	mov    $0x100,%edi
  801156:	89 f8                	mov    %edi,%eax
  801158:	29 d8                	sub    %ebx,%eax
  80115a:	50                   	push   %eax
  80115b:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  80115e:	50                   	push   %eax
  80115f:	e8 22 06 00 00       	call   801786 <vsnprintf>
  801164:	01 c3                	add    %eax,%ebx
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  801166:	83 c4 0c             	add    $0xc,%esp
  801169:	68 13 20 80 00       	push   $0x802013
  80116e:	29 df                	sub    %ebx,%edi
  801170:	57                   	push   %edi
  801171:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
  801174:	50                   	push   %eax
  801175:	e8 61 06 00 00       	call   8017db <snprintf>
	sys_cputs(buf, r);
  80117a:	83 c4 08             	add    $0x8,%esp
	r += snprintf(buf + r, sizeof(buf) - r, "\n");
  80117d:	01 c3                	add    %eax,%ebx
	sys_cputs(buf, r);
  80117f:	53                   	push   %ebx
  801180:	56                   	push   %esi
  801181:	e8 2a ef ff ff       	call   8000b0 <sys_cputs>
  801186:	83 c4 10             	add    $0x10,%esp

	// Cause a breakpoint exception
	while (1)
		asm volatile("int3");
  801189:	cc                   	int3   
  80118a:	eb fd                	jmp    801189 <_panic+0x7c>

0080118c <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
  80118c:	55                   	push   %ebp
  80118d:	89 e5                	mov    %esp,%ebp
  80118f:	53                   	push   %ebx
  801190:	83 ec 04             	sub    $0x4,%esp
  801193:	8b 5d 0c             	mov    0xc(%ebp),%ebx
	b->buf[b->idx++] = ch;
  801196:	8b 13                	mov    (%ebx),%edx
  801198:	8d 42 01             	lea    0x1(%edx),%eax
  80119b:	89 03                	mov    %eax,(%ebx)
  80119d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011a0:	88 4c 13 08          	mov    %cl,0x8(%ebx,%edx,1)
	if (b->idx == 256-1) {
  8011a4:	3d ff 00 00 00       	cmp    $0xff,%eax
  8011a9:	74 08                	je     8011b3 <putch+0x27>
		sys_cputs(b->buf, b->idx);
		b->idx = 0;
	}
	b->cnt++;
  8011ab:	ff 43 04             	incl   0x4(%ebx)
}
  8011ae:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8011b1:	c9                   	leave  
  8011b2:	c3                   	ret    
		sys_cputs(b->buf, b->idx);
  8011b3:	83 ec 08             	sub    $0x8,%esp
  8011b6:	68 ff 00 00 00       	push   $0xff
  8011bb:	8d 43 08             	lea    0x8(%ebx),%eax
  8011be:	50                   	push   %eax
  8011bf:	e8 ec ee ff ff       	call   8000b0 <sys_cputs>
		b->idx = 0;
  8011c4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  8011ca:	83 c4 10             	add    $0x10,%esp
  8011cd:	eb dc                	jmp    8011ab <putch+0x1f>

008011cf <vcprintf>:

int
vcprintf(const char *fmt, va_list ap)
{
  8011cf:	55                   	push   %ebp
  8011d0:	89 e5                	mov    %esp,%ebp
  8011d2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8011d8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8011df:	00 00 00 
	b.cnt = 0;
  8011e2:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8011e9:	00 00 00 
	vprintfmt((void*)putch, &b, fmt, ap);
  8011ec:	ff 75 0c             	pushl  0xc(%ebp)
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8011f8:	50                   	push   %eax
  8011f9:	68 8c 11 80 00       	push   $0x80118c
  8011fe:	e8 17 01 00 00       	call   80131a <vprintfmt>
	sys_cputs(b.buf, b.idx);
  801203:	83 c4 08             	add    $0x8,%esp
  801206:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  80120c:	8d 85 f8 fe ff ff    	lea    -0x108(%ebp),%eax
  801212:	50                   	push   %eax
  801213:	e8 98 ee ff ff       	call   8000b0 <sys_cputs>

	return b.cnt;
}
  801218:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <cprintf>:

int
cprintf(const char *fmt, ...)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
  801223:	83 ec 10             	sub    $0x10,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801226:	8d 45 0c             	lea    0xc(%ebp),%eax
	cnt = vcprintf(fmt, ap);
  801229:	50                   	push   %eax
  80122a:	ff 75 08             	pushl  0x8(%ebp)
  80122d:	e8 9d ff ff ff       	call   8011cf <vcprintf>
	va_end(ap);

	return cnt;
}
  801232:	c9                   	leave  
  801233:	c3                   	ret    

00801234 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  801234:	55                   	push   %ebp
  801235:	89 e5                	mov    %esp,%ebp
  801237:	57                   	push   %edi
  801238:	56                   	push   %esi
  801239:	53                   	push   %ebx
  80123a:	83 ec 1c             	sub    $0x1c,%esp
  80123d:	89 c7                	mov    %eax,%edi
  80123f:	89 d6                	mov    %edx,%esi
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	8b 55 0c             	mov    0xc(%ebp),%edx
  801247:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80124a:	89 55 dc             	mov    %edx,-0x24(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80124d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801250:	bb 00 00 00 00       	mov    $0x0,%ebx
  801255:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  801258:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  80125b:	39 d3                	cmp    %edx,%ebx
  80125d:	72 05                	jb     801264 <printnum+0x30>
  80125f:	39 45 10             	cmp    %eax,0x10(%ebp)
  801262:	77 78                	ja     8012dc <printnum+0xa8>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801264:	83 ec 0c             	sub    $0xc,%esp
  801267:	ff 75 18             	pushl  0x18(%ebp)
  80126a:	8b 45 14             	mov    0x14(%ebp),%eax
  80126d:	8d 58 ff             	lea    -0x1(%eax),%ebx
  801270:	53                   	push   %ebx
  801271:	ff 75 10             	pushl  0x10(%ebp)
  801274:	83 ec 08             	sub    $0x8,%esp
  801277:	ff 75 e4             	pushl  -0x1c(%ebp)
  80127a:	ff 75 e0             	pushl  -0x20(%ebp)
  80127d:	ff 75 dc             	pushl  -0x24(%ebp)
  801280:	ff 75 d8             	pushl  -0x28(%ebp)
  801283:	e8 24 0a 00 00       	call   801cac <__udivdi3>
  801288:	83 c4 18             	add    $0x18,%esp
  80128b:	52                   	push   %edx
  80128c:	50                   	push   %eax
  80128d:	89 f2                	mov    %esi,%edx
  80128f:	89 f8                	mov    %edi,%eax
  801291:	e8 9e ff ff ff       	call   801234 <printnum>
  801296:	83 c4 20             	add    $0x20,%esp
  801299:	eb 11                	jmp    8012ac <printnum+0x78>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80129b:	83 ec 08             	sub    $0x8,%esp
  80129e:	56                   	push   %esi
  80129f:	ff 75 18             	pushl  0x18(%ebp)
  8012a2:	ff d7                	call   *%edi
  8012a4:	83 c4 10             	add    $0x10,%esp
		while (--width > 0)
  8012a7:	4b                   	dec    %ebx
  8012a8:	85 db                	test   %ebx,%ebx
  8012aa:	7f ef                	jg     80129b <printnum+0x67>
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8012ac:	83 ec 08             	sub    $0x8,%esp
  8012af:	56                   	push   %esi
  8012b0:	83 ec 04             	sub    $0x4,%esp
  8012b3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8012b6:	ff 75 e0             	pushl  -0x20(%ebp)
  8012b9:	ff 75 dc             	pushl  -0x24(%ebp)
  8012bc:	ff 75 d8             	pushl  -0x28(%ebp)
  8012bf:	e8 f8 0a 00 00       	call   801dbc <__umoddi3>
  8012c4:	83 c4 14             	add    $0x14,%esp
  8012c7:	0f be 80 4b 20 80 00 	movsbl 0x80204b(%eax),%eax
  8012ce:	50                   	push   %eax
  8012cf:	ff d7                	call   *%edi
}
  8012d1:	83 c4 10             	add    $0x10,%esp
  8012d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8012d7:	5b                   	pop    %ebx
  8012d8:	5e                   	pop    %esi
  8012d9:	5f                   	pop    %edi
  8012da:	5d                   	pop    %ebp
  8012db:	c3                   	ret    
  8012dc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8012df:	eb c6                	jmp    8012a7 <printnum+0x73>

008012e1 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  8012e1:	55                   	push   %ebp
  8012e2:	89 e5                	mov    %esp,%ebp
  8012e4:	8b 45 0c             	mov    0xc(%ebp),%eax
	b->cnt++;
  8012e7:	ff 40 08             	incl   0x8(%eax)
	if (b->buf < b->ebuf)
  8012ea:	8b 10                	mov    (%eax),%edx
  8012ec:	3b 50 04             	cmp    0x4(%eax),%edx
  8012ef:	73 0a                	jae    8012fb <sprintputch+0x1a>
		*b->buf++ = ch;
  8012f1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f4:	89 08                	mov    %ecx,(%eax)
  8012f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f9:	88 02                	mov    %al,(%edx)
}
  8012fb:	5d                   	pop    %ebp
  8012fc:	c3                   	ret    

008012fd <printfmt>:
{
  8012fd:	55                   	push   %ebp
  8012fe:	89 e5                	mov    %esp,%ebp
  801300:	83 ec 08             	sub    $0x8,%esp
	va_start(ap, fmt);
  801303:	8d 45 14             	lea    0x14(%ebp),%eax
	vprintfmt(putch, putdat, fmt, ap);
  801306:	50                   	push   %eax
  801307:	ff 75 10             	pushl  0x10(%ebp)
  80130a:	ff 75 0c             	pushl  0xc(%ebp)
  80130d:	ff 75 08             	pushl  0x8(%ebp)
  801310:	e8 05 00 00 00       	call   80131a <vprintfmt>
}
  801315:	83 c4 10             	add    $0x10,%esp
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <vprintfmt>:
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	57                   	push   %edi
  80131e:	56                   	push   %esi
  80131f:	53                   	push   %ebx
  801320:	83 ec 2c             	sub    $0x2c,%esp
  801323:	8b 75 08             	mov    0x8(%ebp),%esi
  801326:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  801329:	8b 7d 10             	mov    0x10(%ebp),%edi
  80132c:	e9 ae 03 00 00       	jmp    8016df <vprintfmt+0x3c5>
  801331:	c6 45 d4 20          	movb   $0x20,-0x2c(%ebp)
  801335:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
  80133c:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  801343:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
  80134a:	b9 00 00 00 00       	mov    $0x0,%ecx
		switch (ch = *(unsigned char *) fmt++) {
  80134f:	8d 47 01             	lea    0x1(%edi),%eax
  801352:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801355:	8a 17                	mov    (%edi),%dl
  801357:	8d 42 dd             	lea    -0x23(%edx),%eax
  80135a:	3c 55                	cmp    $0x55,%al
  80135c:	0f 87 fe 03 00 00    	ja     801760 <vprintfmt+0x446>
  801362:	0f b6 c0             	movzbl %al,%eax
  801365:	ff 24 85 80 21 80 00 	jmp    *0x802180(,%eax,4)
  80136c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '-';
  80136f:	c6 45 d4 2d          	movb   $0x2d,-0x2c(%ebp)
  801373:	eb da                	jmp    80134f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  801375:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			padc = '0';
  801378:	c6 45 d4 30          	movb   $0x30,-0x2c(%ebp)
  80137c:	eb d1                	jmp    80134f <vprintfmt+0x35>
		switch (ch = *(unsigned char *) fmt++) {
  80137e:	0f b6 d2             	movzbl %dl,%edx
  801381:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  801384:	b8 00 00 00 00       	mov    $0x0,%eax
  801389:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
				precision = precision * 10 + ch - '0';
  80138c:	8d 04 80             	lea    (%eax,%eax,4),%eax
  80138f:	01 c0                	add    %eax,%eax
  801391:	8d 44 02 d0          	lea    -0x30(%edx,%eax,1),%eax
				ch = *fmt;
  801395:	0f be 17             	movsbl (%edi),%edx
				if (ch < '0' || ch > '9')
  801398:	8d 4a d0             	lea    -0x30(%edx),%ecx
  80139b:	83 f9 09             	cmp    $0x9,%ecx
  80139e:	77 52                	ja     8013f2 <vprintfmt+0xd8>
			for (precision = 0; ; ++fmt) {
  8013a0:	47                   	inc    %edi
				precision = precision * 10 + ch - '0';
  8013a1:	eb e9                	jmp    80138c <vprintfmt+0x72>
			precision = va_arg(ap, int);
  8013a3:	8b 45 14             	mov    0x14(%ebp),%eax
  8013a6:	8b 00                	mov    (%eax),%eax
  8013a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8013ae:	8d 40 04             	lea    0x4(%eax),%eax
  8013b1:	89 45 14             	mov    %eax,0x14(%ebp)
		switch (ch = *(unsigned char *) fmt++) {
  8013b4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			if (width < 0)
  8013b7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013bb:	79 92                	jns    80134f <vprintfmt+0x35>
				width = precision, precision = -1;
  8013bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8013c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013c3:	c7 45 d0 ff ff ff ff 	movl   $0xffffffff,-0x30(%ebp)
  8013ca:	eb 83                	jmp    80134f <vprintfmt+0x35>
  8013cc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8013d0:	78 08                	js     8013da <vprintfmt+0xc0>
		switch (ch = *(unsigned char *) fmt++) {
  8013d2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  8013d5:	e9 75 ff ff ff       	jmp    80134f <vprintfmt+0x35>
  8013da:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8013e1:	eb ef                	jmp    8013d2 <vprintfmt+0xb8>
  8013e3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			altflag = 1;
  8013e6:	c7 45 d8 01 00 00 00 	movl   $0x1,-0x28(%ebp)
			goto reswitch;
  8013ed:	e9 5d ff ff ff       	jmp    80134f <vprintfmt+0x35>
  8013f2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  8013f5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8013f8:	eb bd                	jmp    8013b7 <vprintfmt+0x9d>
			lflag++;
  8013fa:	41                   	inc    %ecx
		switch (ch = *(unsigned char *) fmt++) {
  8013fb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
			goto reswitch;
  8013fe:	e9 4c ff ff ff       	jmp    80134f <vprintfmt+0x35>
			putch(va_arg(ap, int), putdat);
  801403:	8b 45 14             	mov    0x14(%ebp),%eax
  801406:	8d 78 04             	lea    0x4(%eax),%edi
  801409:	83 ec 08             	sub    $0x8,%esp
  80140c:	53                   	push   %ebx
  80140d:	ff 30                	pushl  (%eax)
  80140f:	ff d6                	call   *%esi
			break;
  801411:	83 c4 10             	add    $0x10,%esp
			putch(va_arg(ap, int), putdat);
  801414:	89 7d 14             	mov    %edi,0x14(%ebp)
			break;
  801417:	e9 c0 02 00 00       	jmp    8016dc <vprintfmt+0x3c2>
			err = va_arg(ap, int);
  80141c:	8b 45 14             	mov    0x14(%ebp),%eax
  80141f:	8d 78 04             	lea    0x4(%eax),%edi
  801422:	8b 00                	mov    (%eax),%eax
  801424:	85 c0                	test   %eax,%eax
  801426:	78 2a                	js     801452 <vprintfmt+0x138>
  801428:	89 c2                	mov    %eax,%edx
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
  80142a:	83 f8 0f             	cmp    $0xf,%eax
  80142d:	7f 27                	jg     801456 <vprintfmt+0x13c>
  80142f:	8b 04 85 e0 22 80 00 	mov    0x8022e0(,%eax,4),%eax
  801436:	85 c0                	test   %eax,%eax
  801438:	74 1c                	je     801456 <vprintfmt+0x13c>
				printfmt(putch, putdat, "%s", p);
  80143a:	50                   	push   %eax
  80143b:	68 e1 1f 80 00       	push   $0x801fe1
  801440:	53                   	push   %ebx
  801441:	56                   	push   %esi
  801442:	e8 b6 fe ff ff       	call   8012fd <printfmt>
  801447:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  80144a:	89 7d 14             	mov    %edi,0x14(%ebp)
  80144d:	e9 8a 02 00 00       	jmp    8016dc <vprintfmt+0x3c2>
  801452:	f7 d8                	neg    %eax
  801454:	eb d2                	jmp    801428 <vprintfmt+0x10e>
				printfmt(putch, putdat, "error %d", err);
  801456:	52                   	push   %edx
  801457:	68 63 20 80 00       	push   $0x802063
  80145c:	53                   	push   %ebx
  80145d:	56                   	push   %esi
  80145e:	e8 9a fe ff ff       	call   8012fd <printfmt>
  801463:	83 c4 10             	add    $0x10,%esp
			err = va_arg(ap, int);
  801466:	89 7d 14             	mov    %edi,0x14(%ebp)
				printfmt(putch, putdat, "error %d", err);
  801469:	e9 6e 02 00 00       	jmp    8016dc <vprintfmt+0x3c2>
			if ((p = va_arg(ap, char *)) == NULL)
  80146e:	8b 45 14             	mov    0x14(%ebp),%eax
  801471:	83 c0 04             	add    $0x4,%eax
  801474:	89 45 cc             	mov    %eax,-0x34(%ebp)
  801477:	8b 45 14             	mov    0x14(%ebp),%eax
  80147a:	8b 38                	mov    (%eax),%edi
  80147c:	85 ff                	test   %edi,%edi
  80147e:	74 39                	je     8014b9 <vprintfmt+0x19f>
			if (width > 0 && padc != '-')
  801480:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801484:	0f 8e a9 00 00 00    	jle    801533 <vprintfmt+0x219>
  80148a:	80 7d d4 2d          	cmpb   $0x2d,-0x2c(%ebp)
  80148e:	0f 84 a7 00 00 00    	je     80153b <vprintfmt+0x221>
				for (width -= strnlen(p, precision); width > 0; width--)
  801494:	83 ec 08             	sub    $0x8,%esp
  801497:	ff 75 d0             	pushl  -0x30(%ebp)
  80149a:	57                   	push   %edi
  80149b:	e8 6b 03 00 00       	call   80180b <strnlen>
  8014a0:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  8014a3:	29 c1                	sub    %eax,%ecx
  8014a5:	89 4d c8             	mov    %ecx,-0x38(%ebp)
  8014a8:	83 c4 10             	add    $0x10,%esp
					putch(padc, putdat);
  8014ab:	0f be 45 d4          	movsbl -0x2c(%ebp),%eax
  8014af:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8014b2:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8014b5:	89 cf                	mov    %ecx,%edi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014b7:	eb 14                	jmp    8014cd <vprintfmt+0x1b3>
				p = "(null)";
  8014b9:	bf 5c 20 80 00       	mov    $0x80205c,%edi
  8014be:	eb c0                	jmp    801480 <vprintfmt+0x166>
					putch(padc, putdat);
  8014c0:	83 ec 08             	sub    $0x8,%esp
  8014c3:	53                   	push   %ebx
  8014c4:	ff 75 e0             	pushl  -0x20(%ebp)
  8014c7:	ff d6                	call   *%esi
				for (width -= strnlen(p, precision); width > 0; width--)
  8014c9:	4f                   	dec    %edi
  8014ca:	83 c4 10             	add    $0x10,%esp
  8014cd:	85 ff                	test   %edi,%edi
  8014cf:	7f ef                	jg     8014c0 <vprintfmt+0x1a6>
  8014d1:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  8014d4:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014d7:	89 c8                	mov    %ecx,%eax
  8014d9:	85 c9                	test   %ecx,%ecx
  8014db:	78 10                	js     8014ed <vprintfmt+0x1d3>
  8014dd:	8b 4d c8             	mov    -0x38(%ebp),%ecx
  8014e0:	29 c1                	sub    %eax,%ecx
  8014e2:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  8014e5:	89 75 08             	mov    %esi,0x8(%ebp)
  8014e8:	8b 75 d0             	mov    -0x30(%ebp),%esi
  8014eb:	eb 15                	jmp    801502 <vprintfmt+0x1e8>
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	eb e9                	jmp    8014dd <vprintfmt+0x1c3>
					putch(ch, putdat);
  8014f4:	83 ec 08             	sub    $0x8,%esp
  8014f7:	53                   	push   %ebx
  8014f8:	52                   	push   %edx
  8014f9:	ff 55 08             	call   *0x8(%ebp)
  8014fc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8014ff:	ff 4d e0             	decl   -0x20(%ebp)
  801502:	47                   	inc    %edi
  801503:	8a 47 ff             	mov    -0x1(%edi),%al
  801506:	0f be d0             	movsbl %al,%edx
  801509:	85 d2                	test   %edx,%edx
  80150b:	74 59                	je     801566 <vprintfmt+0x24c>
  80150d:	85 f6                	test   %esi,%esi
  80150f:	78 03                	js     801514 <vprintfmt+0x1fa>
  801511:	4e                   	dec    %esi
  801512:	78 2f                	js     801543 <vprintfmt+0x229>
				if (altflag && (ch < ' ' || ch > '~'))
  801514:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801518:	74 da                	je     8014f4 <vprintfmt+0x1da>
  80151a:	0f be c0             	movsbl %al,%eax
  80151d:	83 e8 20             	sub    $0x20,%eax
  801520:	83 f8 5e             	cmp    $0x5e,%eax
  801523:	76 cf                	jbe    8014f4 <vprintfmt+0x1da>
					putch('?', putdat);
  801525:	83 ec 08             	sub    $0x8,%esp
  801528:	53                   	push   %ebx
  801529:	6a 3f                	push   $0x3f
  80152b:	ff 55 08             	call   *0x8(%ebp)
  80152e:	83 c4 10             	add    $0x10,%esp
  801531:	eb cc                	jmp    8014ff <vprintfmt+0x1e5>
  801533:	89 75 08             	mov    %esi,0x8(%ebp)
  801536:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801539:	eb c7                	jmp    801502 <vprintfmt+0x1e8>
  80153b:	89 75 08             	mov    %esi,0x8(%ebp)
  80153e:	8b 75 d0             	mov    -0x30(%ebp),%esi
  801541:	eb bf                	jmp    801502 <vprintfmt+0x1e8>
  801543:	8b 75 08             	mov    0x8(%ebp),%esi
  801546:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801549:	eb 0c                	jmp    801557 <vprintfmt+0x23d>
				putch(' ', putdat);
  80154b:	83 ec 08             	sub    $0x8,%esp
  80154e:	53                   	push   %ebx
  80154f:	6a 20                	push   $0x20
  801551:	ff d6                	call   *%esi
			for (; width > 0; width--)
  801553:	4f                   	dec    %edi
  801554:	83 c4 10             	add    $0x10,%esp
  801557:	85 ff                	test   %edi,%edi
  801559:	7f f0                	jg     80154b <vprintfmt+0x231>
			if ((p = va_arg(ap, char *)) == NULL)
  80155b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80155e:	89 45 14             	mov    %eax,0x14(%ebp)
  801561:	e9 76 01 00 00       	jmp    8016dc <vprintfmt+0x3c2>
  801566:	8b 7d e0             	mov    -0x20(%ebp),%edi
  801569:	8b 75 08             	mov    0x8(%ebp),%esi
  80156c:	eb e9                	jmp    801557 <vprintfmt+0x23d>
	if (lflag >= 2)
  80156e:	83 f9 01             	cmp    $0x1,%ecx
  801571:	7f 1f                	jg     801592 <vprintfmt+0x278>
	else if (lflag)
  801573:	85 c9                	test   %ecx,%ecx
  801575:	75 48                	jne    8015bf <vprintfmt+0x2a5>
		return va_arg(*ap, int);
  801577:	8b 45 14             	mov    0x14(%ebp),%eax
  80157a:	8b 00                	mov    (%eax),%eax
  80157c:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80157f:	89 c1                	mov    %eax,%ecx
  801581:	c1 f9 1f             	sar    $0x1f,%ecx
  801584:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  801587:	8b 45 14             	mov    0x14(%ebp),%eax
  80158a:	8d 40 04             	lea    0x4(%eax),%eax
  80158d:	89 45 14             	mov    %eax,0x14(%ebp)
  801590:	eb 17                	jmp    8015a9 <vprintfmt+0x28f>
		return va_arg(*ap, long long);
  801592:	8b 45 14             	mov    0x14(%ebp),%eax
  801595:	8b 50 04             	mov    0x4(%eax),%edx
  801598:	8b 00                	mov    (%eax),%eax
  80159a:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80159d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  8015a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8015a3:	8d 40 08             	lea    0x8(%eax),%eax
  8015a6:	89 45 14             	mov    %eax,0x14(%ebp)
			num = getint(&ap, lflag);
  8015a9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015ac:	8b 4d dc             	mov    -0x24(%ebp),%ecx
			if ((long long) num < 0) {
  8015af:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8015b3:	78 25                	js     8015da <vprintfmt+0x2c0>
			base = 10;
  8015b5:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015ba:	e9 03 01 00 00       	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, long);
  8015bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015c2:	8b 00                	mov    (%eax),%eax
  8015c4:	89 45 d8             	mov    %eax,-0x28(%ebp)
  8015c7:	89 c1                	mov    %eax,%ecx
  8015c9:	c1 f9 1f             	sar    $0x1f,%ecx
  8015cc:	89 4d dc             	mov    %ecx,-0x24(%ebp)
  8015cf:	8b 45 14             	mov    0x14(%ebp),%eax
  8015d2:	8d 40 04             	lea    0x4(%eax),%eax
  8015d5:	89 45 14             	mov    %eax,0x14(%ebp)
  8015d8:	eb cf                	jmp    8015a9 <vprintfmt+0x28f>
				putch('-', putdat);
  8015da:	83 ec 08             	sub    $0x8,%esp
  8015dd:	53                   	push   %ebx
  8015de:	6a 2d                	push   $0x2d
  8015e0:	ff d6                	call   *%esi
				num = -(long long) num;
  8015e2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015e5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  8015e8:	f7 da                	neg    %edx
  8015ea:	83 d1 00             	adc    $0x0,%ecx
  8015ed:	f7 d9                	neg    %ecx
  8015ef:	83 c4 10             	add    $0x10,%esp
			base = 10;
  8015f2:	b8 0a 00 00 00       	mov    $0xa,%eax
  8015f7:	e9 c6 00 00 00       	jmp    8016c2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  8015fc:	83 f9 01             	cmp    $0x1,%ecx
  8015ff:	7f 1e                	jg     80161f <vprintfmt+0x305>
	else if (lflag)
  801601:	85 c9                	test   %ecx,%ecx
  801603:	75 32                	jne    801637 <vprintfmt+0x31d>
		return va_arg(*ap, unsigned int);
  801605:	8b 45 14             	mov    0x14(%ebp),%eax
  801608:	8b 10                	mov    (%eax),%edx
  80160a:	b9 00 00 00 00       	mov    $0x0,%ecx
  80160f:	8d 40 04             	lea    0x4(%eax),%eax
  801612:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801615:	b8 0a 00 00 00       	mov    $0xa,%eax
  80161a:	e9 a3 00 00 00       	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80161f:	8b 45 14             	mov    0x14(%ebp),%eax
  801622:	8b 10                	mov    (%eax),%edx
  801624:	8b 48 04             	mov    0x4(%eax),%ecx
  801627:	8d 40 08             	lea    0x8(%eax),%eax
  80162a:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  80162d:	b8 0a 00 00 00       	mov    $0xa,%eax
  801632:	e9 8b 00 00 00       	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801637:	8b 45 14             	mov    0x14(%ebp),%eax
  80163a:	8b 10                	mov    (%eax),%edx
  80163c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801641:	8d 40 04             	lea    0x4(%eax),%eax
  801644:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 10;
  801647:	b8 0a 00 00 00       	mov    $0xa,%eax
  80164c:	eb 74                	jmp    8016c2 <vprintfmt+0x3a8>
	if (lflag >= 2)
  80164e:	83 f9 01             	cmp    $0x1,%ecx
  801651:	7f 1b                	jg     80166e <vprintfmt+0x354>
	else if (lflag)
  801653:	85 c9                	test   %ecx,%ecx
  801655:	75 2c                	jne    801683 <vprintfmt+0x369>
		return va_arg(*ap, unsigned int);
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 10                	mov    (%eax),%edx
  80165c:	b9 00 00 00 00       	mov    $0x0,%ecx
  801661:	8d 40 04             	lea    0x4(%eax),%eax
  801664:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801667:	b8 08 00 00 00       	mov    $0x8,%eax
  80166c:	eb 54                	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  80166e:	8b 45 14             	mov    0x14(%ebp),%eax
  801671:	8b 10                	mov    (%eax),%edx
  801673:	8b 48 04             	mov    0x4(%eax),%ecx
  801676:	8d 40 08             	lea    0x8(%eax),%eax
  801679:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  80167c:	b8 08 00 00 00       	mov    $0x8,%eax
  801681:	eb 3f                	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801683:	8b 45 14             	mov    0x14(%ebp),%eax
  801686:	8b 10                	mov    (%eax),%edx
  801688:	b9 00 00 00 00       	mov    $0x0,%ecx
  80168d:	8d 40 04             	lea    0x4(%eax),%eax
  801690:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 8;
  801693:	b8 08 00 00 00       	mov    $0x8,%eax
  801698:	eb 28                	jmp    8016c2 <vprintfmt+0x3a8>
			putch('0', putdat);
  80169a:	83 ec 08             	sub    $0x8,%esp
  80169d:	53                   	push   %ebx
  80169e:	6a 30                	push   $0x30
  8016a0:	ff d6                	call   *%esi
			putch('x', putdat);
  8016a2:	83 c4 08             	add    $0x8,%esp
  8016a5:	53                   	push   %ebx
  8016a6:	6a 78                	push   $0x78
  8016a8:	ff d6                	call   *%esi
			num = (unsigned long long)
  8016aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ad:	8b 10                	mov    (%eax),%edx
  8016af:	b9 00 00 00 00       	mov    $0x0,%ecx
			goto number;
  8016b4:	83 c4 10             	add    $0x10,%esp
				(uintptr_t) va_arg(ap, void *);
  8016b7:	8d 40 04             	lea    0x4(%eax),%eax
  8016ba:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  8016bd:	b8 10 00 00 00       	mov    $0x10,%eax
			printnum(putch, putdat, num, base, width, padc);
  8016c2:	83 ec 0c             	sub    $0xc,%esp
  8016c5:	0f be 7d d4          	movsbl -0x2c(%ebp),%edi
  8016c9:	57                   	push   %edi
  8016ca:	ff 75 e0             	pushl  -0x20(%ebp)
  8016cd:	50                   	push   %eax
  8016ce:	51                   	push   %ecx
  8016cf:	52                   	push   %edx
  8016d0:	89 da                	mov    %ebx,%edx
  8016d2:	89 f0                	mov    %esi,%eax
  8016d4:	e8 5b fb ff ff       	call   801234 <printnum>
			break;
  8016d9:	83 c4 20             	add    $0x20,%esp
			err = va_arg(ap, int);
  8016dc:	8b 7d e4             	mov    -0x1c(%ebp),%edi
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8016df:	47                   	inc    %edi
  8016e0:	0f b6 47 ff          	movzbl -0x1(%edi),%eax
  8016e4:	83 f8 25             	cmp    $0x25,%eax
  8016e7:	0f 84 44 fc ff ff    	je     801331 <vprintfmt+0x17>
			if (ch == '\0')
  8016ed:	85 c0                	test   %eax,%eax
  8016ef:	0f 84 89 00 00 00    	je     80177e <vprintfmt+0x464>
			putch(ch, putdat);
  8016f5:	83 ec 08             	sub    $0x8,%esp
  8016f8:	53                   	push   %ebx
  8016f9:	50                   	push   %eax
  8016fa:	ff d6                	call   *%esi
  8016fc:	83 c4 10             	add    $0x10,%esp
  8016ff:	eb de                	jmp    8016df <vprintfmt+0x3c5>
	if (lflag >= 2)
  801701:	83 f9 01             	cmp    $0x1,%ecx
  801704:	7f 1b                	jg     801721 <vprintfmt+0x407>
	else if (lflag)
  801706:	85 c9                	test   %ecx,%ecx
  801708:	75 2c                	jne    801736 <vprintfmt+0x41c>
		return va_arg(*ap, unsigned int);
  80170a:	8b 45 14             	mov    0x14(%ebp),%eax
  80170d:	8b 10                	mov    (%eax),%edx
  80170f:	b9 00 00 00 00       	mov    $0x0,%ecx
  801714:	8d 40 04             	lea    0x4(%eax),%eax
  801717:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80171a:	b8 10 00 00 00       	mov    $0x10,%eax
  80171f:	eb a1                	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long long);
  801721:	8b 45 14             	mov    0x14(%ebp),%eax
  801724:	8b 10                	mov    (%eax),%edx
  801726:	8b 48 04             	mov    0x4(%eax),%ecx
  801729:	8d 40 08             	lea    0x8(%eax),%eax
  80172c:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  80172f:	b8 10 00 00 00       	mov    $0x10,%eax
  801734:	eb 8c                	jmp    8016c2 <vprintfmt+0x3a8>
		return va_arg(*ap, unsigned long);
  801736:	8b 45 14             	mov    0x14(%ebp),%eax
  801739:	8b 10                	mov    (%eax),%edx
  80173b:	b9 00 00 00 00       	mov    $0x0,%ecx
  801740:	8d 40 04             	lea    0x4(%eax),%eax
  801743:	89 45 14             	mov    %eax,0x14(%ebp)
			base = 16;
  801746:	b8 10 00 00 00       	mov    $0x10,%eax
  80174b:	e9 72 ff ff ff       	jmp    8016c2 <vprintfmt+0x3a8>
			putch(ch, putdat);
  801750:	83 ec 08             	sub    $0x8,%esp
  801753:	53                   	push   %ebx
  801754:	6a 25                	push   $0x25
  801756:	ff d6                	call   *%esi
			break;
  801758:	83 c4 10             	add    $0x10,%esp
  80175b:	e9 7c ff ff ff       	jmp    8016dc <vprintfmt+0x3c2>
			putch('%', putdat);
  801760:	83 ec 08             	sub    $0x8,%esp
  801763:	53                   	push   %ebx
  801764:	6a 25                	push   $0x25
  801766:	ff d6                	call   *%esi
			for (fmt--; fmt[-1] != '%'; fmt--)
  801768:	83 c4 10             	add    $0x10,%esp
  80176b:	89 f8                	mov    %edi,%eax
  80176d:	eb 01                	jmp    801770 <vprintfmt+0x456>
  80176f:	48                   	dec    %eax
  801770:	80 78 ff 25          	cmpb   $0x25,-0x1(%eax)
  801774:	75 f9                	jne    80176f <vprintfmt+0x455>
  801776:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801779:	e9 5e ff ff ff       	jmp    8016dc <vprintfmt+0x3c2>
}
  80177e:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801781:	5b                   	pop    %ebx
  801782:	5e                   	pop    %esi
  801783:	5f                   	pop    %edi
  801784:	5d                   	pop    %ebp
  801785:	c3                   	ret    

00801786 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801786:	55                   	push   %ebp
  801787:	89 e5                	mov    %esp,%ebp
  801789:	83 ec 18             	sub    $0x18,%esp
  80178c:	8b 45 08             	mov    0x8(%ebp),%eax
  80178f:	8b 55 0c             	mov    0xc(%ebp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
  801792:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801795:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
  801799:	89 4d f0             	mov    %ecx,-0x10(%ebp)
  80179c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  8017a3:	85 c0                	test   %eax,%eax
  8017a5:	74 26                	je     8017cd <vsnprintf+0x47>
  8017a7:	85 d2                	test   %edx,%edx
  8017a9:	7e 29                	jle    8017d4 <vsnprintf+0x4e>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8017ab:	ff 75 14             	pushl  0x14(%ebp)
  8017ae:	ff 75 10             	pushl  0x10(%ebp)
  8017b1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8017b4:	50                   	push   %eax
  8017b5:	68 e1 12 80 00       	push   $0x8012e1
  8017ba:	e8 5b fb ff ff       	call   80131a <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
  8017bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c2:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8017c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c8:	83 c4 10             	add    $0x10,%esp
}
  8017cb:	c9                   	leave  
  8017cc:	c3                   	ret    
		return -E_INVAL;
  8017cd:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d2:	eb f7                	jmp    8017cb <vsnprintf+0x45>
  8017d4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  8017d9:	eb f0                	jmp    8017cb <vsnprintf+0x45>

008017db <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8017db:	55                   	push   %ebp
  8017dc:	89 e5                	mov    %esp,%ebp
  8017de:	83 ec 08             	sub    $0x8,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8017e1:	8d 45 14             	lea    0x14(%ebp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
  8017e4:	50                   	push   %eax
  8017e5:	ff 75 10             	pushl  0x10(%ebp)
  8017e8:	ff 75 0c             	pushl  0xc(%ebp)
  8017eb:	ff 75 08             	pushl  0x8(%ebp)
  8017ee:	e8 93 ff ff ff       	call   801786 <vsnprintf>
	va_end(ap);

	return rc;
}
  8017f3:	c9                   	leave  
  8017f4:	c3                   	ret    

008017f5 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
  8017f8:	8b 55 08             	mov    0x8(%ebp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	eb 01                	jmp    801803 <strlen+0xe>
		n++;
  801802:	40                   	inc    %eax
	for (n = 0; *s != '\0'; s++)
  801803:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  801807:	75 f9                	jne    801802 <strlen+0xd>
	return n;
}
  801809:	5d                   	pop    %ebp
  80180a:	c3                   	ret    

0080180b <strnlen>:

int
strnlen(const char *s, size_t size)
{
  80180b:	55                   	push   %ebp
  80180c:	89 e5                	mov    %esp,%ebp
  80180e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801811:	8b 55 0c             	mov    0xc(%ebp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801814:	b8 00 00 00 00       	mov    $0x0,%eax
  801819:	eb 01                	jmp    80181c <strnlen+0x11>
		n++;
  80181b:	40                   	inc    %eax
	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80181c:	39 d0                	cmp    %edx,%eax
  80181e:	74 06                	je     801826 <strnlen+0x1b>
  801820:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  801824:	75 f5                	jne    80181b <strnlen+0x10>
	return n;
}
  801826:	5d                   	pop    %ebp
  801827:	c3                   	ret    

00801828 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801828:	55                   	push   %ebp
  801829:	89 e5                	mov    %esp,%ebp
  80182b:	53                   	push   %ebx
  80182c:	8b 45 08             	mov    0x8(%ebp),%eax
  80182f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
  801832:	89 c2                	mov    %eax,%edx
  801834:	42                   	inc    %edx
  801835:	41                   	inc    %ecx
  801836:	8a 59 ff             	mov    -0x1(%ecx),%bl
  801839:	88 5a ff             	mov    %bl,-0x1(%edx)
  80183c:	84 db                	test   %bl,%bl
  80183e:	75 f4                	jne    801834 <strcpy+0xc>
		/* do nothing */;
	return ret;
}
  801840:	5b                   	pop    %ebx
  801841:	5d                   	pop    %ebp
  801842:	c3                   	ret    

00801843 <strcat>:

char *
strcat(char *dst, const char *src)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	53                   	push   %ebx
  801847:	8b 5d 08             	mov    0x8(%ebp),%ebx
	int len = strlen(dst);
  80184a:	53                   	push   %ebx
  80184b:	e8 a5 ff ff ff       	call   8017f5 <strlen>
  801850:	83 c4 04             	add    $0x4,%esp
	strcpy(dst + len, src);
  801853:	ff 75 0c             	pushl  0xc(%ebp)
  801856:	01 d8                	add    %ebx,%eax
  801858:	50                   	push   %eax
  801859:	e8 ca ff ff ff       	call   801828 <strcpy>
	return dst;
}
  80185e:	89 d8                	mov    %ebx,%eax
  801860:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
  801868:	56                   	push   %esi
  801869:	53                   	push   %ebx
  80186a:	8b 75 08             	mov    0x8(%ebp),%esi
  80186d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  801870:	89 f3                	mov    %esi,%ebx
  801872:	03 5d 10             	add    0x10(%ebp),%ebx
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801875:	89 f2                	mov    %esi,%edx
  801877:	eb 0c                	jmp    801885 <strncpy+0x20>
		*dst++ = *src;
  801879:	42                   	inc    %edx
  80187a:	8a 01                	mov    (%ecx),%al
  80187c:	88 42 ff             	mov    %al,-0x1(%edx)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
  80187f:	80 39 01             	cmpb   $0x1,(%ecx)
  801882:	83 d9 ff             	sbb    $0xffffffff,%ecx
	for (i = 0; i < size; i++) {
  801885:	39 da                	cmp    %ebx,%edx
  801887:	75 f0                	jne    801879 <strncpy+0x14>
	}
	return ret;
}
  801889:	89 f0                	mov    %esi,%eax
  80188b:	5b                   	pop    %ebx
  80188c:	5e                   	pop    %esi
  80188d:	5d                   	pop    %ebp
  80188e:	c3                   	ret    

0080188f <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
  80188f:	55                   	push   %ebp
  801890:	89 e5                	mov    %esp,%ebp
  801892:	56                   	push   %esi
  801893:	53                   	push   %ebx
  801894:	8b 75 08             	mov    0x8(%ebp),%esi
  801897:	8b 55 0c             	mov    0xc(%ebp),%edx
  80189a:	8b 45 10             	mov    0x10(%ebp),%eax
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
  80189d:	85 c0                	test   %eax,%eax
  80189f:	74 20                	je     8018c1 <strlcpy+0x32>
  8018a1:	8d 5c 06 ff          	lea    -0x1(%esi,%eax,1),%ebx
  8018a5:	89 f0                	mov    %esi,%eax
  8018a7:	eb 05                	jmp    8018ae <strlcpy+0x1f>
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
  8018a9:	40                   	inc    %eax
  8018aa:	42                   	inc    %edx
  8018ab:	88 48 ff             	mov    %cl,-0x1(%eax)
		while (--size > 0 && *src != '\0')
  8018ae:	39 d8                	cmp    %ebx,%eax
  8018b0:	74 06                	je     8018b8 <strlcpy+0x29>
  8018b2:	8a 0a                	mov    (%edx),%cl
  8018b4:	84 c9                	test   %cl,%cl
  8018b6:	75 f1                	jne    8018a9 <strlcpy+0x1a>
		*dst = '\0';
  8018b8:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8018bb:	29 f0                	sub    %esi,%eax
}
  8018bd:	5b                   	pop    %ebx
  8018be:	5e                   	pop    %esi
  8018bf:	5d                   	pop    %ebp
  8018c0:	c3                   	ret    
  8018c1:	89 f0                	mov    %esi,%eax
  8018c3:	eb f6                	jmp    8018bb <strlcpy+0x2c>

008018c5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8018c5:	55                   	push   %ebp
  8018c6:	89 e5                	mov    %esp,%ebp
  8018c8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018cb:	8b 55 0c             	mov    0xc(%ebp),%edx
	while (*p && *p == *q)
  8018ce:	eb 02                	jmp    8018d2 <strcmp+0xd>
		p++, q++;
  8018d0:	41                   	inc    %ecx
  8018d1:	42                   	inc    %edx
	while (*p && *p == *q)
  8018d2:	8a 01                	mov    (%ecx),%al
  8018d4:	84 c0                	test   %al,%al
  8018d6:	74 04                	je     8018dc <strcmp+0x17>
  8018d8:	3a 02                	cmp    (%edx),%al
  8018da:	74 f4                	je     8018d0 <strcmp+0xb>
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8018dc:	0f b6 c0             	movzbl %al,%eax
  8018df:	0f b6 12             	movzbl (%edx),%edx
  8018e2:	29 d0                	sub    %edx,%eax
}
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	53                   	push   %ebx
  8018ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ed:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f0:	89 c3                	mov    %eax,%ebx
  8018f2:	03 5d 10             	add    0x10(%ebp),%ebx
	while (n > 0 && *p && *p == *q)
  8018f5:	eb 02                	jmp    8018f9 <strncmp+0x13>
		n--, p++, q++;
  8018f7:	40                   	inc    %eax
  8018f8:	42                   	inc    %edx
	while (n > 0 && *p && *p == *q)
  8018f9:	39 d8                	cmp    %ebx,%eax
  8018fb:	74 15                	je     801912 <strncmp+0x2c>
  8018fd:	8a 08                	mov    (%eax),%cl
  8018ff:	84 c9                	test   %cl,%cl
  801901:	74 04                	je     801907 <strncmp+0x21>
  801903:	3a 0a                	cmp    (%edx),%cl
  801905:	74 f0                	je     8018f7 <strncmp+0x11>
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801907:	0f b6 00             	movzbl (%eax),%eax
  80190a:	0f b6 12             	movzbl (%edx),%edx
  80190d:	29 d0                	sub    %edx,%eax
}
  80190f:	5b                   	pop    %ebx
  801910:	5d                   	pop    %ebp
  801911:	c3                   	ret    
		return 0;
  801912:	b8 00 00 00 00       	mov    $0x0,%eax
  801917:	eb f6                	jmp    80190f <strncmp+0x29>

00801919 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  801922:	8a 10                	mov    (%eax),%dl
  801924:	84 d2                	test   %dl,%dl
  801926:	74 07                	je     80192f <strchr+0x16>
		if (*s == c)
  801928:	38 ca                	cmp    %cl,%dl
  80192a:	74 08                	je     801934 <strchr+0x1b>
	for (; *s; s++)
  80192c:	40                   	inc    %eax
  80192d:	eb f3                	jmp    801922 <strchr+0x9>
			return (char *) s;
	return 0;
  80192f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801934:	5d                   	pop    %ebp
  801935:	c3                   	ret    

00801936 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
  801939:	8b 45 08             	mov    0x8(%ebp),%eax
  80193c:	8a 4d 0c             	mov    0xc(%ebp),%cl
	for (; *s; s++)
  80193f:	8a 10                	mov    (%eax),%dl
  801941:	84 d2                	test   %dl,%dl
  801943:	74 07                	je     80194c <strfind+0x16>
		if (*s == c)
  801945:	38 ca                	cmp    %cl,%dl
  801947:	74 03                	je     80194c <strfind+0x16>
	for (; *s; s++)
  801949:	40                   	inc    %eax
  80194a:	eb f3                	jmp    80193f <strfind+0x9>
			break;
	return (char *) s;
}
  80194c:	5d                   	pop    %ebp
  80194d:	c3                   	ret    

0080194e <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	57                   	push   %edi
  801952:	56                   	push   %esi
  801953:	53                   	push   %ebx
  801954:	8b 7d 08             	mov    0x8(%ebp),%edi
  801957:	8b 4d 10             	mov    0x10(%ebp),%ecx
	char *p;

	if (n == 0)
  80195a:	85 c9                	test   %ecx,%ecx
  80195c:	74 13                	je     801971 <memset+0x23>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
  80195e:	f7 c7 03 00 00 00    	test   $0x3,%edi
  801964:	75 05                	jne    80196b <memset+0x1d>
  801966:	f6 c1 03             	test   $0x3,%cl
  801969:	74 0d                	je     801978 <memset+0x2a>
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
  80196b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196e:	fc                   	cld    
  80196f:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
  801971:	89 f8                	mov    %edi,%eax
  801973:	5b                   	pop    %ebx
  801974:	5e                   	pop    %esi
  801975:	5f                   	pop    %edi
  801976:	5d                   	pop    %ebp
  801977:	c3                   	ret    
		c &= 0xFF;
  801978:	0f b6 55 0c          	movzbl 0xc(%ebp),%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
  80197c:	89 d3                	mov    %edx,%ebx
  80197e:	c1 e3 08             	shl    $0x8,%ebx
  801981:	89 d0                	mov    %edx,%eax
  801983:	c1 e0 18             	shl    $0x18,%eax
  801986:	89 d6                	mov    %edx,%esi
  801988:	c1 e6 10             	shl    $0x10,%esi
  80198b:	09 f0                	or     %esi,%eax
  80198d:	09 c2                	or     %eax,%edx
  80198f:	09 da                	or     %ebx,%edx
			:: "D" (v), "a" (c), "c" (n/4)
  801991:	c1 e9 02             	shr    $0x2,%ecx
		asm volatile("cld; rep stosl\n"
  801994:	89 d0                	mov    %edx,%eax
  801996:	fc                   	cld    
  801997:	f3 ab                	rep stos %eax,%es:(%edi)
  801999:	eb d6                	jmp    801971 <memset+0x23>

0080199b <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	57                   	push   %edi
  80199f:	56                   	push   %esi
  8019a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a3:	8b 75 0c             	mov    0xc(%ebp),%esi
  8019a6:	8b 4d 10             	mov    0x10(%ebp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8019a9:	39 c6                	cmp    %eax,%esi
  8019ab:	73 33                	jae    8019e0 <memmove+0x45>
  8019ad:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
  8019b0:	39 d0                	cmp    %edx,%eax
  8019b2:	73 2c                	jae    8019e0 <memmove+0x45>
		s += n;
		d += n;
  8019b4:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019b7:	89 d6                	mov    %edx,%esi
  8019b9:	09 fe                	or     %edi,%esi
  8019bb:	f7 c6 03 00 00 00    	test   $0x3,%esi
  8019c1:	75 13                	jne    8019d6 <memmove+0x3b>
  8019c3:	f6 c1 03             	test   $0x3,%cl
  8019c6:	75 0e                	jne    8019d6 <memmove+0x3b>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
  8019c8:	83 ef 04             	sub    $0x4,%edi
  8019cb:	8d 72 fc             	lea    -0x4(%edx),%esi
  8019ce:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("std; rep movsl\n"
  8019d1:	fd                   	std    
  8019d2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019d4:	eb 07                	jmp    8019dd <memmove+0x42>
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
  8019d6:	4f                   	dec    %edi
  8019d7:	8d 72 ff             	lea    -0x1(%edx),%esi
			asm volatile("std; rep movsb\n"
  8019da:	fd                   	std    
  8019db:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
  8019dd:	fc                   	cld    
  8019de:	eb 13                	jmp    8019f3 <memmove+0x58>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
  8019e0:	89 f2                	mov    %esi,%edx
  8019e2:	09 c2                	or     %eax,%edx
  8019e4:	f6 c2 03             	test   $0x3,%dl
  8019e7:	75 05                	jne    8019ee <memmove+0x53>
  8019e9:	f6 c1 03             	test   $0x3,%cl
  8019ec:	74 09                	je     8019f7 <memmove+0x5c>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
  8019ee:	89 c7                	mov    %eax,%edi
  8019f0:	fc                   	cld    
  8019f1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
  8019f3:	5e                   	pop    %esi
  8019f4:	5f                   	pop    %edi
  8019f5:	5d                   	pop    %ebp
  8019f6:	c3                   	ret    
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
  8019f7:	c1 e9 02             	shr    $0x2,%ecx
			asm volatile("cld; rep movsl\n"
  8019fa:	89 c7                	mov    %eax,%edi
  8019fc:	fc                   	cld    
  8019fd:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  8019ff:	eb f2                	jmp    8019f3 <memmove+0x58>

00801a01 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
  801a01:	55                   	push   %ebp
  801a02:	89 e5                	mov    %esp,%ebp
	return memmove(dst, src, n);
  801a04:	ff 75 10             	pushl  0x10(%ebp)
  801a07:	ff 75 0c             	pushl  0xc(%ebp)
  801a0a:	ff 75 08             	pushl  0x8(%ebp)
  801a0d:	e8 89 ff ff ff       	call   80199b <memmove>
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
  801a17:	56                   	push   %esi
  801a18:	53                   	push   %ebx
  801a19:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1c:	89 c6                	mov    %eax,%esi
  801a1e:	03 75 10             	add    0x10(%ebp),%esi
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;
  801a21:	8b 55 0c             	mov    0xc(%ebp),%edx

	while (n-- > 0) {
  801a24:	39 f0                	cmp    %esi,%eax
  801a26:	74 16                	je     801a3e <memcmp+0x2a>
		if (*s1 != *s2)
  801a28:	8a 08                	mov    (%eax),%cl
  801a2a:	8a 1a                	mov    (%edx),%bl
  801a2c:	38 d9                	cmp    %bl,%cl
  801a2e:	75 04                	jne    801a34 <memcmp+0x20>
			return (int) *s1 - (int) *s2;
		s1++, s2++;
  801a30:	40                   	inc    %eax
  801a31:	42                   	inc    %edx
  801a32:	eb f0                	jmp    801a24 <memcmp+0x10>
			return (int) *s1 - (int) *s2;
  801a34:	0f b6 c1             	movzbl %cl,%eax
  801a37:	0f b6 db             	movzbl %bl,%ebx
  801a3a:	29 d8                	sub    %ebx,%eax
  801a3c:	eb 05                	jmp    801a43 <memcmp+0x2f>
	}

	return 0;
  801a3e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a43:	5b                   	pop    %ebx
  801a44:	5e                   	pop    %esi
  801a45:	5d                   	pop    %ebp
  801a46:	c3                   	ret    

00801a47 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
  801a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4d:	8b 4d 0c             	mov    0xc(%ebp),%ecx
	const void *ends = (const char *) s + n;
  801a50:	89 c2                	mov    %eax,%edx
  801a52:	03 55 10             	add    0x10(%ebp),%edx
	for (; s < ends; s++)
  801a55:	39 d0                	cmp    %edx,%eax
  801a57:	73 07                	jae    801a60 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
  801a59:	38 08                	cmp    %cl,(%eax)
  801a5b:	74 03                	je     801a60 <memfind+0x19>
	for (; s < ends; s++)
  801a5d:	40                   	inc    %eax
  801a5e:	eb f5                	jmp    801a55 <memfind+0xe>
			break;
	return (void *) s;
}
  801a60:	5d                   	pop    %ebp
  801a61:	c3                   	ret    

00801a62 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
  801a65:	57                   	push   %edi
  801a66:	56                   	push   %esi
  801a67:	53                   	push   %ebx
  801a68:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801a6b:	eb 01                	jmp    801a6e <strtol+0xc>
		s++;
  801a6d:	41                   	inc    %ecx
	while (*s == ' ' || *s == '\t')
  801a6e:	8a 01                	mov    (%ecx),%al
  801a70:	3c 20                	cmp    $0x20,%al
  801a72:	74 f9                	je     801a6d <strtol+0xb>
  801a74:	3c 09                	cmp    $0x9,%al
  801a76:	74 f5                	je     801a6d <strtol+0xb>

	// plus/minus sign
	if (*s == '+')
  801a78:	3c 2b                	cmp    $0x2b,%al
  801a7a:	74 2b                	je     801aa7 <strtol+0x45>
		s++;
	else if (*s == '-')
  801a7c:	3c 2d                	cmp    $0x2d,%al
  801a7e:	74 2f                	je     801aaf <strtol+0x4d>
	int neg = 0;
  801a80:	bf 00 00 00 00       	mov    $0x0,%edi
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801a85:	f7 45 10 ef ff ff ff 	testl  $0xffffffef,0x10(%ebp)
  801a8c:	75 12                	jne    801aa0 <strtol+0x3e>
  801a8e:	80 39 30             	cmpb   $0x30,(%ecx)
  801a91:	74 24                	je     801ab7 <strtol+0x55>
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
  801a93:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801a97:	75 07                	jne    801aa0 <strtol+0x3e>
		s++, base = 8;
	else if (base == 0)
		base = 10;
  801a99:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)
  801aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801aa5:	eb 4e                	jmp    801af5 <strtol+0x93>
		s++;
  801aa7:	41                   	inc    %ecx
	int neg = 0;
  801aa8:	bf 00 00 00 00       	mov    $0x0,%edi
  801aad:	eb d6                	jmp    801a85 <strtol+0x23>
		s++, neg = 1;
  801aaf:	41                   	inc    %ecx
  801ab0:	bf 01 00 00 00       	mov    $0x1,%edi
  801ab5:	eb ce                	jmp    801a85 <strtol+0x23>
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801ab7:	80 79 01 78          	cmpb   $0x78,0x1(%ecx)
  801abb:	74 10                	je     801acd <strtol+0x6b>
	else if (base == 0 && s[0] == '0')
  801abd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ac1:	75 dd                	jne    801aa0 <strtol+0x3e>
		s++, base = 8;
  801ac3:	41                   	inc    %ecx
  801ac4:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801acb:	eb d3                	jmp    801aa0 <strtol+0x3e>
		s += 2, base = 16;
  801acd:	83 c1 02             	add    $0x2,%ecx
  801ad0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801ad7:	eb c7                	jmp    801aa0 <strtol+0x3e>
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
  801ad9:	8d 72 9f             	lea    -0x61(%edx),%esi
  801adc:	89 f3                	mov    %esi,%ebx
  801ade:	80 fb 19             	cmp    $0x19,%bl
  801ae1:	77 24                	ja     801b07 <strtol+0xa5>
			dig = *s - 'a' + 10;
  801ae3:	0f be d2             	movsbl %dl,%edx
  801ae6:	83 ea 57             	sub    $0x57,%edx
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
  801ae9:	3b 55 10             	cmp    0x10(%ebp),%edx
  801aec:	7d 2b                	jge    801b19 <strtol+0xb7>
			break;
		s++, val = (val * base) + dig;
  801aee:	41                   	inc    %ecx
  801aef:	0f af 45 10          	imul   0x10(%ebp),%eax
  801af3:	01 d0                	add    %edx,%eax
		if (*s >= '0' && *s <= '9')
  801af5:	8a 11                	mov    (%ecx),%dl
  801af7:	8d 5a d0             	lea    -0x30(%edx),%ebx
  801afa:	80 fb 09             	cmp    $0x9,%bl
  801afd:	77 da                	ja     801ad9 <strtol+0x77>
			dig = *s - '0';
  801aff:	0f be d2             	movsbl %dl,%edx
  801b02:	83 ea 30             	sub    $0x30,%edx
  801b05:	eb e2                	jmp    801ae9 <strtol+0x87>
		else if (*s >= 'A' && *s <= 'Z')
  801b07:	8d 72 bf             	lea    -0x41(%edx),%esi
  801b0a:	89 f3                	mov    %esi,%ebx
  801b0c:	80 fb 19             	cmp    $0x19,%bl
  801b0f:	77 08                	ja     801b19 <strtol+0xb7>
			dig = *s - 'A' + 10;
  801b11:	0f be d2             	movsbl %dl,%edx
  801b14:	83 ea 37             	sub    $0x37,%edx
  801b17:	eb d0                	jmp    801ae9 <strtol+0x87>
		// we don't properly detect overflow!
	}

	if (endptr)
  801b19:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b1d:	74 05                	je     801b24 <strtol+0xc2>
		*endptr = (char *) s;
  801b1f:	8b 75 0c             	mov    0xc(%ebp),%esi
  801b22:	89 0e                	mov    %ecx,(%esi)
	return (neg ? -val : val);
  801b24:	85 ff                	test   %edi,%edi
  801b26:	74 02                	je     801b2a <strtol+0xc8>
  801b28:	f7 d8                	neg    %eax
}
  801b2a:	5b                   	pop    %ebx
  801b2b:	5e                   	pop    %esi
  801b2c:	5f                   	pop    %edi
  801b2d:	5d                   	pop    %ebp
  801b2e:	c3                   	ret    

00801b2f <atoi>:

int
atoi(const char *s)
{
  801b2f:	55                   	push   %ebp
  801b30:	89 e5                	mov    %esp,%ebp
	return (int)strtol(s, NULL, 10);
  801b32:	6a 0a                	push   $0xa
  801b34:	6a 00                	push   $0x0
  801b36:	ff 75 08             	pushl  0x8(%ebp)
  801b39:	e8 24 ff ff ff       	call   801a62 <strtol>
}
  801b3e:	c9                   	leave  
  801b3f:	c3                   	ret    

00801b40 <ipc_recv>:
//   If 'pg' is null, pass sys_ipc_recv a value that it will understand
//   as meaning "no page".  (Zero is not the right value, since that's
//   a perfectly valid place to map a page.)
int32_t
ipc_recv(envid_t *from_env_store, void *pg, int *perm_store)
{
  801b40:	55                   	push   %ebp
  801b41:	89 e5                	mov    %esp,%ebp
  801b43:	57                   	push   %edi
  801b44:	56                   	push   %esi
  801b45:	53                   	push   %ebx
  801b46:	83 ec 0c             	sub    $0xc,%esp
  801b49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  801b4c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  801b4f:	8b 75 10             	mov    0x10(%ebp),%esi
	// LAB 4: Your code here.
	int res;
	if (pg != NULL) {
  801b52:	85 ff                	test   %edi,%edi
  801b54:	74 53                	je     801ba9 <ipc_recv+0x69>
		res = sys_ipc_recv(pg);
  801b56:	83 ec 0c             	sub    $0xc,%esp
  801b59:	57                   	push   %edi
  801b5a:	e8 fe e7 ff ff       	call   80035d <sys_ipc_recv>
  801b5f:	83 c4 10             	add    $0x10,%esp
	} else {
		res = sys_ipc_recv((void*) -1);
	}
	if (from_env_store != NULL) {
  801b62:	85 db                	test   %ebx,%ebx
  801b64:	74 0b                	je     801b71 <ipc_recv+0x31>
		*from_env_store = thisenv->env_ipc_from;
  801b66:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b6c:	8b 52 74             	mov    0x74(%edx),%edx
  801b6f:	89 13                	mov    %edx,(%ebx)
	}
	if (perm_store != NULL && pg != NULL) {
  801b71:	85 f6                	test   %esi,%esi
  801b73:	74 0f                	je     801b84 <ipc_recv+0x44>
  801b75:	85 ff                	test   %edi,%edi
  801b77:	74 0b                	je     801b84 <ipc_recv+0x44>
		*perm_store = thisenv->env_ipc_perm;
  801b79:	8b 15 04 40 80 00    	mov    0x804004,%edx
  801b7f:	8b 52 78             	mov    0x78(%edx),%edx
  801b82:	89 16                	mov    %edx,(%esi)
	}

	if (res == 0) {
  801b84:	85 c0                	test   %eax,%eax
  801b86:	74 30                	je     801bb8 <ipc_recv+0x78>
		return thisenv->env_ipc_value;
	} else {
		if (from_env_store != NULL) {
  801b88:	85 db                	test   %ebx,%ebx
  801b8a:	74 06                	je     801b92 <ipc_recv+0x52>
      		*from_env_store = 0;
  801b8c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      	}
    	if (perm_store != NULL) {
  801b92:	85 f6                	test   %esi,%esi
  801b94:	74 2c                	je     801bc2 <ipc_recv+0x82>
      		*perm_store = 0;
  801b96:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
      	}
		return -1;
  801b9c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
	}

}
  801ba1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801ba4:	5b                   	pop    %ebx
  801ba5:	5e                   	pop    %esi
  801ba6:	5f                   	pop    %edi
  801ba7:	5d                   	pop    %ebp
  801ba8:	c3                   	ret    
		res = sys_ipc_recv((void*) -1);
  801ba9:	83 ec 0c             	sub    $0xc,%esp
  801bac:	6a ff                	push   $0xffffffff
  801bae:	e8 aa e7 ff ff       	call   80035d <sys_ipc_recv>
  801bb3:	83 c4 10             	add    $0x10,%esp
  801bb6:	eb aa                	jmp    801b62 <ipc_recv+0x22>
		return thisenv->env_ipc_value;
  801bb8:	a1 04 40 80 00       	mov    0x804004,%eax
  801bbd:	8b 40 70             	mov    0x70(%eax),%eax
  801bc0:	eb df                	jmp    801ba1 <ipc_recv+0x61>
		return -1;
  801bc2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  801bc7:	eb d8                	jmp    801ba1 <ipc_recv+0x61>

00801bc9 <ipc_send>:
//   Use sys_yield() to be CPU-friendly.
//   If 'pg' is null, pass sys_ipc_try_send a value that it will understand
//   as meaning "no page".  (Zero is not the right value.)
void
ipc_send(envid_t to_env, uint32_t val, void *pg, int perm)
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
  801bcc:	57                   	push   %edi
  801bcd:	56                   	push   %esi
  801bce:	53                   	push   %ebx
  801bcf:	83 ec 0c             	sub    $0xc,%esp
  801bd2:	8b 75 0c             	mov    0xc(%ebp),%esi
  801bd5:	8b 5d 10             	mov    0x10(%ebp),%ebx
  801bd8:	8b 7d 14             	mov    0x14(%ebp),%edi
	// LAB 4: Your code here.
	if (pg == NULL) {
  801bdb:	85 db                	test   %ebx,%ebx
  801bdd:	75 22                	jne    801c01 <ipc_send+0x38>
		pg = (void *) UTOP+1;
  801bdf:	bb 01 00 c0 ee       	mov    $0xeec00001,%ebx
  801be4:	eb 1b                	jmp    801c01 <ipc_send+0x38>
	}
	int ack = -E_IPC_NOT_RECV;
	while (ack == -E_IPC_NOT_RECV) {
		ack = sys_ipc_try_send(to_env, val, pg, perm);
		// some error ocurred
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801be6:	68 40 23 80 00       	push   $0x802340
  801beb:	68 cf 1f 80 00       	push   $0x801fcf
  801bf0:	6a 48                	push   $0x48
  801bf2:	68 64 23 80 00       	push   $0x802364
  801bf7:	e8 11 f5 ff ff       	call   80110d <_panic>
		sys_yield();
  801bfc:	e8 13 e6 ff ff       	call   800214 <sys_yield>
		ack = sys_ipc_try_send(to_env, val, pg, perm);
  801c01:	57                   	push   %edi
  801c02:	53                   	push   %ebx
  801c03:	56                   	push   %esi
  801c04:	ff 75 08             	pushl  0x8(%ebp)
  801c07:	e8 2e e7 ff ff       	call   80033a <sys_ipc_try_send>
		assert(ack == -E_IPC_NOT_RECV || ack == 0);
  801c0c:	83 c4 10             	add    $0x10,%esp
  801c0f:	83 f8 f9             	cmp    $0xfffffff9,%eax
  801c12:	74 e8                	je     801bfc <ipc_send+0x33>
  801c14:	85 c0                	test   %eax,%eax
  801c16:	75 ce                	jne    801be6 <ipc_send+0x1d>
		sys_yield();
  801c18:	e8 f7 e5 ff ff       	call   800214 <sys_yield>
		
	}
	
}
  801c1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  801c20:	5b                   	pop    %ebx
  801c21:	5e                   	pop    %esi
  801c22:	5f                   	pop    %edi
  801c23:	5d                   	pop    %ebp
  801c24:	c3                   	ret    

00801c25 <ipc_find_env>:
// Find the first environment of the given type.  We'll use this to
// find special environments.
// Returns 0 if no such environment exists.
envid_t
ipc_find_env(enum EnvType type)
{
  801c25:	55                   	push   %ebp
  801c26:	89 e5                	mov    %esp,%ebp
  801c28:	8b 4d 08             	mov    0x8(%ebp),%ecx
	int i;
	for (i = 0; i < NENV; i++)
  801c2b:	b8 00 00 00 00       	mov    $0x0,%eax
		if (envs[i].env_type == type)
  801c30:	89 c2                	mov    %eax,%edx
  801c32:	c1 e2 05             	shl    $0x5,%edx
  801c35:	29 c2                	sub    %eax,%edx
  801c37:	8d 14 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%edx
  801c3e:	8b 52 50             	mov    0x50(%edx),%edx
  801c41:	39 ca                	cmp    %ecx,%edx
  801c43:	74 0f                	je     801c54 <ipc_find_env+0x2f>
	for (i = 0; i < NENV; i++)
  801c45:	40                   	inc    %eax
  801c46:	3d 00 04 00 00       	cmp    $0x400,%eax
  801c4b:	75 e3                	jne    801c30 <ipc_find_env+0xb>
			return envs[i].env_id;
	return 0;
  801c4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801c52:	eb 11                	jmp    801c65 <ipc_find_env+0x40>
			return envs[i].env_id;
  801c54:	89 c2                	mov    %eax,%edx
  801c56:	c1 e2 05             	shl    $0x5,%edx
  801c59:	29 c2                	sub    %eax,%edx
  801c5b:	8d 04 95 00 00 c0 ee 	lea    -0x11400000(,%edx,4),%eax
  801c62:	8b 40 48             	mov    0x48(%eax),%eax
}
  801c65:	5d                   	pop    %ebp
  801c66:	c3                   	ret    

00801c67 <pageref>:
#include <inc/lib.h>

int
pageref(void *v)
{
  801c67:	55                   	push   %ebp
  801c68:	89 e5                	mov    %esp,%ebp
	pte_t pte;

	if (!(uvpd[PDX(v)] & PTE_P))
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	c1 e8 16             	shr    $0x16,%eax
  801c70:	8b 04 85 00 d0 7b ef 	mov    -0x10843000(,%eax,4),%eax
  801c77:	a8 01                	test   $0x1,%al
  801c79:	74 21                	je     801c9c <pageref+0x35>
		return 0;
	pte = uvpt[PGNUM(v)];
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	c1 e8 0c             	shr    $0xc,%eax
  801c81:	8b 04 85 00 00 40 ef 	mov    -0x10c00000(,%eax,4),%eax
	if (!(pte & PTE_P))
  801c88:	a8 01                	test   $0x1,%al
  801c8a:	74 17                	je     801ca3 <pageref+0x3c>
		return 0;
	return pages[PGNUM(pte)].pp_ref;
  801c8c:	c1 e8 0c             	shr    $0xc,%eax
  801c8f:	66 8b 04 c5 04 00 00 	mov    -0x10fffffc(,%eax,8),%ax
  801c96:	ef 
  801c97:	0f b7 c0             	movzwl %ax,%eax
  801c9a:	eb 05                	jmp    801ca1 <pageref+0x3a>
		return 0;
  801c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ca1:	5d                   	pop    %ebp
  801ca2:	c3                   	ret    
		return 0;
  801ca3:	b8 00 00 00 00       	mov    $0x0,%eax
  801ca8:	eb f7                	jmp    801ca1 <pageref+0x3a>
  801caa:	66 90                	xchg   %ax,%ax

00801cac <__udivdi3>:
  801cac:	55                   	push   %ebp
  801cad:	57                   	push   %edi
  801cae:	56                   	push   %esi
  801caf:	53                   	push   %ebx
  801cb0:	83 ec 1c             	sub    $0x1c,%esp
  801cb3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801cb7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801cbb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cbf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  801cc3:	89 ca                	mov    %ecx,%edx
  801cc5:	89 f8                	mov    %edi,%eax
  801cc7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ccb:	85 f6                	test   %esi,%esi
  801ccd:	75 2d                	jne    801cfc <__udivdi3+0x50>
  801ccf:	39 cf                	cmp    %ecx,%edi
  801cd1:	77 65                	ja     801d38 <__udivdi3+0x8c>
  801cd3:	89 fd                	mov    %edi,%ebp
  801cd5:	85 ff                	test   %edi,%edi
  801cd7:	75 0b                	jne    801ce4 <__udivdi3+0x38>
  801cd9:	b8 01 00 00 00       	mov    $0x1,%eax
  801cde:	31 d2                	xor    %edx,%edx
  801ce0:	f7 f7                	div    %edi
  801ce2:	89 c5                	mov    %eax,%ebp
  801ce4:	31 d2                	xor    %edx,%edx
  801ce6:	89 c8                	mov    %ecx,%eax
  801ce8:	f7 f5                	div    %ebp
  801cea:	89 c1                	mov    %eax,%ecx
  801cec:	89 d8                	mov    %ebx,%eax
  801cee:	f7 f5                	div    %ebp
  801cf0:	89 cf                	mov    %ecx,%edi
  801cf2:	89 fa                	mov    %edi,%edx
  801cf4:	83 c4 1c             	add    $0x1c,%esp
  801cf7:	5b                   	pop    %ebx
  801cf8:	5e                   	pop    %esi
  801cf9:	5f                   	pop    %edi
  801cfa:	5d                   	pop    %ebp
  801cfb:	c3                   	ret    
  801cfc:	39 ce                	cmp    %ecx,%esi
  801cfe:	77 28                	ja     801d28 <__udivdi3+0x7c>
  801d00:	0f bd fe             	bsr    %esi,%edi
  801d03:	83 f7 1f             	xor    $0x1f,%edi
  801d06:	75 40                	jne    801d48 <__udivdi3+0x9c>
  801d08:	39 ce                	cmp    %ecx,%esi
  801d0a:	72 0a                	jb     801d16 <__udivdi3+0x6a>
  801d0c:	3b 44 24 04          	cmp    0x4(%esp),%eax
  801d10:	0f 87 9e 00 00 00    	ja     801db4 <__udivdi3+0x108>
  801d16:	b8 01 00 00 00       	mov    $0x1,%eax
  801d1b:	89 fa                	mov    %edi,%edx
  801d1d:	83 c4 1c             	add    $0x1c,%esp
  801d20:	5b                   	pop    %ebx
  801d21:	5e                   	pop    %esi
  801d22:	5f                   	pop    %edi
  801d23:	5d                   	pop    %ebp
  801d24:	c3                   	ret    
  801d25:	8d 76 00             	lea    0x0(%esi),%esi
  801d28:	31 ff                	xor    %edi,%edi
  801d2a:	31 c0                	xor    %eax,%eax
  801d2c:	89 fa                	mov    %edi,%edx
  801d2e:	83 c4 1c             	add    $0x1c,%esp
  801d31:	5b                   	pop    %ebx
  801d32:	5e                   	pop    %esi
  801d33:	5f                   	pop    %edi
  801d34:	5d                   	pop    %ebp
  801d35:	c3                   	ret    
  801d36:	66 90                	xchg   %ax,%ax
  801d38:	89 d8                	mov    %ebx,%eax
  801d3a:	f7 f7                	div    %edi
  801d3c:	31 ff                	xor    %edi,%edi
  801d3e:	89 fa                	mov    %edi,%edx
  801d40:	83 c4 1c             	add    $0x1c,%esp
  801d43:	5b                   	pop    %ebx
  801d44:	5e                   	pop    %esi
  801d45:	5f                   	pop    %edi
  801d46:	5d                   	pop    %ebp
  801d47:	c3                   	ret    
  801d48:	bd 20 00 00 00       	mov    $0x20,%ebp
  801d4d:	29 fd                	sub    %edi,%ebp
  801d4f:	89 f9                	mov    %edi,%ecx
  801d51:	d3 e6                	shl    %cl,%esi
  801d53:	89 c3                	mov    %eax,%ebx
  801d55:	89 e9                	mov    %ebp,%ecx
  801d57:	d3 eb                	shr    %cl,%ebx
  801d59:	89 d9                	mov    %ebx,%ecx
  801d5b:	09 f1                	or     %esi,%ecx
  801d5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801d61:	89 f9                	mov    %edi,%ecx
  801d63:	d3 e0                	shl    %cl,%eax
  801d65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801d69:	89 d6                	mov    %edx,%esi
  801d6b:	89 e9                	mov    %ebp,%ecx
  801d6d:	d3 ee                	shr    %cl,%esi
  801d6f:	89 f9                	mov    %edi,%ecx
  801d71:	d3 e2                	shl    %cl,%edx
  801d73:	8b 5c 24 04          	mov    0x4(%esp),%ebx
  801d77:	89 e9                	mov    %ebp,%ecx
  801d79:	d3 eb                	shr    %cl,%ebx
  801d7b:	09 da                	or     %ebx,%edx
  801d7d:	89 d0                	mov    %edx,%eax
  801d7f:	89 f2                	mov    %esi,%edx
  801d81:	f7 74 24 08          	divl   0x8(%esp)
  801d85:	89 d6                	mov    %edx,%esi
  801d87:	89 c3                	mov    %eax,%ebx
  801d89:	f7 64 24 0c          	mull   0xc(%esp)
  801d8d:	39 d6                	cmp    %edx,%esi
  801d8f:	72 17                	jb     801da8 <__udivdi3+0xfc>
  801d91:	74 09                	je     801d9c <__udivdi3+0xf0>
  801d93:	89 d8                	mov    %ebx,%eax
  801d95:	31 ff                	xor    %edi,%edi
  801d97:	e9 56 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801d9c:	8b 54 24 04          	mov    0x4(%esp),%edx
  801da0:	89 f9                	mov    %edi,%ecx
  801da2:	d3 e2                	shl    %cl,%edx
  801da4:	39 c2                	cmp    %eax,%edx
  801da6:	73 eb                	jae    801d93 <__udivdi3+0xe7>
  801da8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801dab:	31 ff                	xor    %edi,%edi
  801dad:	e9 40 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801db2:	66 90                	xchg   %ax,%ax
  801db4:	31 c0                	xor    %eax,%eax
  801db6:	e9 37 ff ff ff       	jmp    801cf2 <__udivdi3+0x46>
  801dbb:	90                   	nop

00801dbc <__umoddi3>:
  801dbc:	55                   	push   %ebp
  801dbd:	57                   	push   %edi
  801dbe:	56                   	push   %esi
  801dbf:	53                   	push   %ebx
  801dc0:	83 ec 1c             	sub    $0x1c,%esp
  801dc3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801dc7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801dcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801dcf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801dd3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801dd7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ddb:	89 3c 24             	mov    %edi,(%esp)
  801dde:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801de2:	89 f2                	mov    %esi,%edx
  801de4:	85 c0                	test   %eax,%eax
  801de6:	75 18                	jne    801e00 <__umoddi3+0x44>
  801de8:	39 f7                	cmp    %esi,%edi
  801dea:	0f 86 a0 00 00 00    	jbe    801e90 <__umoddi3+0xd4>
  801df0:	89 c8                	mov    %ecx,%eax
  801df2:	f7 f7                	div    %edi
  801df4:	89 d0                	mov    %edx,%eax
  801df6:	31 d2                	xor    %edx,%edx
  801df8:	83 c4 1c             	add    $0x1c,%esp
  801dfb:	5b                   	pop    %ebx
  801dfc:	5e                   	pop    %esi
  801dfd:	5f                   	pop    %edi
  801dfe:	5d                   	pop    %ebp
  801dff:	c3                   	ret    
  801e00:	89 f3                	mov    %esi,%ebx
  801e02:	39 f0                	cmp    %esi,%eax
  801e04:	0f 87 a6 00 00 00    	ja     801eb0 <__umoddi3+0xf4>
  801e0a:	0f bd e8             	bsr    %eax,%ebp
  801e0d:	83 f5 1f             	xor    $0x1f,%ebp
  801e10:	0f 84 a6 00 00 00    	je     801ebc <__umoddi3+0x100>
  801e16:	bf 20 00 00 00       	mov    $0x20,%edi
  801e1b:	29 ef                	sub    %ebp,%edi
  801e1d:	89 e9                	mov    %ebp,%ecx
  801e1f:	d3 e0                	shl    %cl,%eax
  801e21:	8b 34 24             	mov    (%esp),%esi
  801e24:	89 f2                	mov    %esi,%edx
  801e26:	89 f9                	mov    %edi,%ecx
  801e28:	d3 ea                	shr    %cl,%edx
  801e2a:	09 c2                	or     %eax,%edx
  801e2c:	89 14 24             	mov    %edx,(%esp)
  801e2f:	89 f2                	mov    %esi,%edx
  801e31:	89 e9                	mov    %ebp,%ecx
  801e33:	d3 e2                	shl    %cl,%edx
  801e35:	89 54 24 04          	mov    %edx,0x4(%esp)
  801e39:	89 de                	mov    %ebx,%esi
  801e3b:	89 f9                	mov    %edi,%ecx
  801e3d:	d3 ee                	shr    %cl,%esi
  801e3f:	89 e9                	mov    %ebp,%ecx
  801e41:	d3 e3                	shl    %cl,%ebx
  801e43:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e47:	89 d0                	mov    %edx,%eax
  801e49:	89 f9                	mov    %edi,%ecx
  801e4b:	d3 e8                	shr    %cl,%eax
  801e4d:	09 d8                	or     %ebx,%eax
  801e4f:	89 d3                	mov    %edx,%ebx
  801e51:	89 e9                	mov    %ebp,%ecx
  801e53:	d3 e3                	shl    %cl,%ebx
  801e55:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801e59:	89 f2                	mov    %esi,%edx
  801e5b:	f7 34 24             	divl   (%esp)
  801e5e:	89 d6                	mov    %edx,%esi
  801e60:	f7 64 24 04          	mull   0x4(%esp)
  801e64:	89 c3                	mov    %eax,%ebx
  801e66:	89 d1                	mov    %edx,%ecx
  801e68:	39 d6                	cmp    %edx,%esi
  801e6a:	72 7c                	jb     801ee8 <__umoddi3+0x12c>
  801e6c:	74 72                	je     801ee0 <__umoddi3+0x124>
  801e6e:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e72:	29 da                	sub    %ebx,%edx
  801e74:	19 ce                	sbb    %ecx,%esi
  801e76:	89 f0                	mov    %esi,%eax
  801e78:	89 f9                	mov    %edi,%ecx
  801e7a:	d3 e0                	shl    %cl,%eax
  801e7c:	89 e9                	mov    %ebp,%ecx
  801e7e:	d3 ea                	shr    %cl,%edx
  801e80:	09 d0                	or     %edx,%eax
  801e82:	89 e9                	mov    %ebp,%ecx
  801e84:	d3 ee                	shr    %cl,%esi
  801e86:	89 f2                	mov    %esi,%edx
  801e88:	83 c4 1c             	add    $0x1c,%esp
  801e8b:	5b                   	pop    %ebx
  801e8c:	5e                   	pop    %esi
  801e8d:	5f                   	pop    %edi
  801e8e:	5d                   	pop    %ebp
  801e8f:	c3                   	ret    
  801e90:	89 fd                	mov    %edi,%ebp
  801e92:	85 ff                	test   %edi,%edi
  801e94:	75 0b                	jne    801ea1 <__umoddi3+0xe5>
  801e96:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9b:	31 d2                	xor    %edx,%edx
  801e9d:	f7 f7                	div    %edi
  801e9f:	89 c5                	mov    %eax,%ebp
  801ea1:	89 f0                	mov    %esi,%eax
  801ea3:	31 d2                	xor    %edx,%edx
  801ea5:	f7 f5                	div    %ebp
  801ea7:	89 c8                	mov    %ecx,%eax
  801ea9:	f7 f5                	div    %ebp
  801eab:	e9 44 ff ff ff       	jmp    801df4 <__umoddi3+0x38>
  801eb0:	89 c8                	mov    %ecx,%eax
  801eb2:	89 f2                	mov    %esi,%edx
  801eb4:	83 c4 1c             	add    $0x1c,%esp
  801eb7:	5b                   	pop    %ebx
  801eb8:	5e                   	pop    %esi
  801eb9:	5f                   	pop    %edi
  801eba:	5d                   	pop    %ebp
  801ebb:	c3                   	ret    
  801ebc:	39 f0                	cmp    %esi,%eax
  801ebe:	72 05                	jb     801ec5 <__umoddi3+0x109>
  801ec0:	39 0c 24             	cmp    %ecx,(%esp)
  801ec3:	77 0c                	ja     801ed1 <__umoddi3+0x115>
  801ec5:	89 f2                	mov    %esi,%edx
  801ec7:	29 f9                	sub    %edi,%ecx
  801ec9:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801ecd:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed1:	8b 44 24 04          	mov    0x4(%esp),%eax
  801ed5:	83 c4 1c             	add    $0x1c,%esp
  801ed8:	5b                   	pop    %ebx
  801ed9:	5e                   	pop    %esi
  801eda:	5f                   	pop    %edi
  801edb:	5d                   	pop    %ebp
  801edc:	c3                   	ret    
  801edd:	8d 76 00             	lea    0x0(%esi),%esi
  801ee0:	39 44 24 08          	cmp    %eax,0x8(%esp)
  801ee4:	73 88                	jae    801e6e <__umoddi3+0xb2>
  801ee6:	66 90                	xchg   %ax,%ax
  801ee8:	2b 44 24 04          	sub    0x4(%esp),%eax
  801eec:	1b 14 24             	sbb    (%esp),%edx
  801eef:	89 d1                	mov    %edx,%ecx
  801ef1:	89 c3                	mov    %eax,%ebx
  801ef3:	e9 76 ff ff ff       	jmp    801e6e <__umoddi3+0xb2>
