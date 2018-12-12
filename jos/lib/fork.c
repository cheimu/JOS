// implement fork from user space

#include <inc/string.h>
#include <inc/lib.h>

// PTE_COW marks copy-on-write page table entries.
// It is one of the bits explicitly allocated to user processes (PTE_AVAIL).
#define PTE_COW		0x800

//
// Custom page fault handler - if faulting page is copy-on-write,
// map in our own private writable copy.
//
static void
pgfault(struct UTrapframe *utf)
{
	void *addr = (void *) utf->utf_fault_va;
	uint32_t err = utf->utf_err;
	int r;

	// Check that the faulting access was (1) a write, and (2) to a
	// copy-on-write page.  If not, panic.
	// Hint:
	//   Use the read-only page table mappings at uvpt
	//   (see <inc/memlayout.h>).

	// LAB 4: Your code here.
	assert((err & FEC_WR) && (uvpd[PDX(addr)] & PTE_P) && (uvpt[PGNUM(addr)] & PTE_COW));

	// Allocate a new page, map it at a temporary location (PFTEMP),
	// copy the data from the old page to the new page, then move the new
	// page to the old page's address.
	// Hint:
	//   You should make three system calls.

	// LAB 4: Your code here.
	envid_t curid = sys_getenvid();
	assert(sys_page_alloc(curid, PFTEMP, PTE_P | PTE_U | PTE_W) >= 0);
	addr = ROUNDDOWN(addr, PGSIZE);
	memcpy(PFTEMP, addr, PGSIZE);
	sys_page_map(curid, PFTEMP, curid, addr, PTE_P | PTE_U | PTE_W);
	sys_page_unmap(curid, PFTEMP);

}

//
// Map our virtual page pn (address pn*PGSIZE) into the target envid
// at the same virtual address.  If the page is writable or copy-on-write,
// the new mapping must be created copy-on-write, and then our mapping must be
// marked copy-on-write as well.  (Exercise: Why do we need to mark ours
// copy-on-write again if it was already copy-on-write at the beginning of
// this function?)
//
// Returns: 0 on success, < 0 on error.
// It is also OK to panic on error.
//
static int
duppage(envid_t envid, unsigned pn)
{
	int r;

	// LAB 4: Your code here.
	if (uvpt[PGNUM(pn*PGSIZE)] & PTE_SHARE) {
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), (uvpt[PGNUM(pn*PGSIZE)] & PTE_SYSCALL)) < 0)
				return -1;
	} else if (uvpt[PGNUM(pn*PGSIZE)] & (PTE_W | PTE_COW)) {
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
				return -1;
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), sys_getenvid(), (void*)(pn*PGSIZE), PTE_P | PTE_U | PTE_COW) < 0)
				return -1;
	} else {
		if (sys_page_map(sys_getenvid(), (void*)(pn*PGSIZE), envid, (void*)(pn*PGSIZE), PTE_P | PTE_U) < 0)
				return -1;
	}
	return 0;
}

//
// User-level fork with copy-on-write.
// Set up our page fault handler appropriately.
// Create a child.
// Copy our address space and page fault handler setup to the child.
// Then mark the child as runnable and return.
//
// Returns: child's envid to the parent, 0 to the child, < 0 on error.
// It is also OK to panic on error.
//
// Hint:
//   Use uvpd, uvpt, and duppage.
//   Remember to fix "thisenv" in the child process.
//   Neither user exception stack should ever be marked copy-on-write,
//   so you must allocate a new page for the child's user exception stack.
//
envid_t
fork(void)
{
	// LAB 4: Your code here.
	set_pgfault_handler(pgfault);
	envid_t childid = sys_exofork();
	if (childid < 0) {
		return -1;
	} 
	if (childid == 0) {
		thisenv = &envs[ENVX(sys_getenvid())];
		return 0;
	}

	for (uint32_t pn = 0; pn < USTACKTOP; pn+=PGSIZE) {
		if ((uvpd[PDX(pn)] & PTE_P) && (uvpt[PGNUM(pn)] & PTE_U)) {
			duppage(childid, pn/PGSIZE);
		}
	}

	if (sys_page_alloc(childid, (void*) (UXSTACKTOP-PGSIZE), PTE_P | PTE_U | PTE_W) < 0){
		return -1;
	}
	extern void _pgfault_upcall();
	if (sys_env_set_pgfault_upcall(childid, _pgfault_upcall) < 0) {
		return -1;
	}
	int temp = sys_env_set_status(childid, ENV_RUNNABLE);
	if (temp < 0) {
		return -1;
	}

	return childid;
}

// Challenge!
int
sfork(void)
{
	panic("sfork not implemented");
	return -E_INVAL;
}
