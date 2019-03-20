
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
  if(fork() > 0)
   9:	e8 42 02 00 00       	call   250 <fork>
   e:	85 c0                	test   %eax,%eax
  10:	7e 0c                	jle    1e <main+0x1e>
    sleep(5);  // Let child exit before parent.
  12:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  19:	e8 ca 02 00 00       	call   2e8 <sleep>
  exit(0);
  1e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  25:	e8 2e 02 00 00       	call   258 <exit>
  2a:	66 90                	xchg   %ax,%ax
  2c:	66 90                	xchg   %ax,%ax
  2e:	66 90                	xchg   %ax,%ax

00000030 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  30:	55                   	push   %ebp
  31:	89 e5                	mov    %esp,%ebp
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  39:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  3a:	89 c2                	mov    %eax,%edx
  3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  40:	41                   	inc    %ecx
  41:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  45:	42                   	inc    %edx
  46:	84 db                	test   %bl,%bl
  48:	88 5a ff             	mov    %bl,-0x1(%edx)
  4b:	75 f3                	jne    40 <strcpy+0x10>
    ;
  return os;
}
  4d:	5b                   	pop    %ebx
  4e:	5d                   	pop    %ebp
  4f:	c3                   	ret    

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  56:	53                   	push   %ebx
  57:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
  5a:	0f b6 01             	movzbl (%ecx),%eax
  5d:	0f b6 13             	movzbl (%ebx),%edx
  60:	84 c0                	test   %al,%al
  62:	75 18                	jne    7c <strcmp+0x2c>
  64:	eb 22                	jmp    88 <strcmp+0x38>
  66:	8d 76 00             	lea    0x0(%esi),%esi
  69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
  70:	41                   	inc    %ecx
  while(*p && *p == *q)
  71:	0f b6 01             	movzbl (%ecx),%eax
    p++, q++;
  74:	43                   	inc    %ebx
  75:	0f b6 13             	movzbl (%ebx),%edx
  while(*p && *p == *q)
  78:	84 c0                	test   %al,%al
  7a:	74 0c                	je     88 <strcmp+0x38>
  7c:	38 d0                	cmp    %dl,%al
  7e:	74 f0                	je     70 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
  80:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
  81:	29 d0                	sub    %edx,%eax
}
  83:	5d                   	pop    %ebp
  84:	c3                   	ret    
  85:	8d 76 00             	lea    0x0(%esi),%esi
  88:	5b                   	pop    %ebx
  89:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
  8b:	29 d0                	sub    %edx,%eax
}
  8d:	5d                   	pop    %ebp
  8e:	c3                   	ret    
  8f:	90                   	nop

00000090 <strlen>:

uint
strlen(const char *s)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  96:	80 39 00             	cmpb   $0x0,(%ecx)
  99:	74 15                	je     b0 <strlen+0x20>
  9b:	31 d2                	xor    %edx,%edx
  9d:	8d 76 00             	lea    0x0(%esi),%esi
  a0:	42                   	inc    %edx
  a1:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  a5:	89 d0                	mov    %edx,%eax
  a7:	75 f7                	jne    a0 <strlen+0x10>
    ;
  return n;
}
  a9:	5d                   	pop    %ebp
  aa:	c3                   	ret    
  ab:	90                   	nop
  ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(n = 0; s[n]; n++)
  b0:	31 c0                	xor    %eax,%eax
}
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
  b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000000c0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c0:	55                   	push   %ebp
  c1:	89 e5                	mov    %esp,%ebp
  c3:	8b 55 08             	mov    0x8(%ebp),%edx
  c6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  cd:	89 d7                	mov    %edx,%edi
  cf:	fc                   	cld    
  d0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d2:	5f                   	pop    %edi
  d3:	89 d0                	mov    %edx,%eax
  d5:	5d                   	pop    %ebp
  d6:	c3                   	ret    
  d7:	89 f6                	mov    %esi,%esi
  d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	55                   	push   %ebp
  e1:	89 e5                	mov    %esp,%ebp
  e3:	8b 45 08             	mov    0x8(%ebp),%eax
  e6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ea:	0f b6 10             	movzbl (%eax),%edx
  ed:	84 d2                	test   %dl,%dl
  ef:	74 1b                	je     10c <strchr+0x2c>
    if(*s == c)
  f1:	38 d1                	cmp    %dl,%cl
  f3:	75 0f                	jne    104 <strchr+0x24>
  f5:	eb 17                	jmp    10e <strchr+0x2e>
  f7:	89 f6                	mov    %esi,%esi
  f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
 100:	38 ca                	cmp    %cl,%dl
 102:	74 0a                	je     10e <strchr+0x2e>
  for(; *s; s++)
 104:	40                   	inc    %eax
 105:	0f b6 10             	movzbl (%eax),%edx
 108:	84 d2                	test   %dl,%dl
 10a:	75 f4                	jne    100 <strchr+0x20>
      return (char*)s;
  return 0;
 10c:	31 c0                	xor    %eax,%eax
}
 10e:	5d                   	pop    %ebp
 10f:	c3                   	ret    

00000110 <gets>:

char*
gets(char *buf, int max)
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	57                   	push   %edi
 114:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	31 f6                	xor    %esi,%esi
{
 117:	53                   	push   %ebx
 118:	83 ec 3c             	sub    $0x3c,%esp
 11b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cc = read(0, &c, 1);
 11e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
 121:	eb 32                	jmp    155 <gets+0x45>
 123:	90                   	nop
 124:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cc = read(0, &c, 1);
 128:	ba 01 00 00 00       	mov    $0x1,%edx
 12d:	89 54 24 08          	mov    %edx,0x8(%esp)
 131:	89 7c 24 04          	mov    %edi,0x4(%esp)
 135:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 13c:	e8 2f 01 00 00       	call   270 <read>
    if(cc < 1)
 141:	85 c0                	test   %eax,%eax
 143:	7e 19                	jle    15e <gets+0x4e>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	43                   	inc    %ebx
 14a:	88 43 ff             	mov    %al,-0x1(%ebx)
    if(c == '\n' || c == '\r')
 14d:	3c 0a                	cmp    $0xa,%al
 14f:	74 1f                	je     170 <gets+0x60>
 151:	3c 0d                	cmp    $0xd,%al
 153:	74 1b                	je     170 <gets+0x60>
  for(i=0; i+1 < max; ){
 155:	46                   	inc    %esi
 156:	3b 75 0c             	cmp    0xc(%ebp),%esi
 159:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
 15c:	7c ca                	jl     128 <gets+0x18>
      break;
  }
  buf[i] = '\0';
 15e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 161:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
 164:	8b 45 08             	mov    0x8(%ebp),%eax
 167:	83 c4 3c             	add    $0x3c,%esp
 16a:	5b                   	pop    %ebx
 16b:	5e                   	pop    %esi
 16c:	5f                   	pop    %edi
 16d:	5d                   	pop    %ebp
 16e:	c3                   	ret    
 16f:	90                   	nop
 170:	8b 45 08             	mov    0x8(%ebp),%eax
 173:	01 c6                	add    %eax,%esi
 175:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 178:	eb e4                	jmp    15e <gets+0x4e>
 17a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000180 <stat>:

int
stat(const char *n, struct stat *st)
{
 180:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 181:	31 c0                	xor    %eax,%eax
{
 183:	89 e5                	mov    %esp,%ebp
 185:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
 188:	89 44 24 04          	mov    %eax,0x4(%esp)
 18c:	8b 45 08             	mov    0x8(%ebp),%eax
{
 18f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
 192:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
 195:	89 04 24             	mov    %eax,(%esp)
 198:	e8 fb 00 00 00       	call   298 <open>
  if(fd < 0)
 19d:	85 c0                	test   %eax,%eax
 19f:	78 2f                	js     1d0 <stat+0x50>
 1a1:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a6:	89 1c 24             	mov    %ebx,(%esp)
 1a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 1ad:	e8 fe 00 00 00       	call   2b0 <fstat>
  close(fd);
 1b2:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 1b5:	89 c6                	mov    %eax,%esi
  close(fd);
 1b7:	e8 c4 00 00 00       	call   280 <close>
  return r;
}
 1bc:	89 f0                	mov    %esi,%eax
 1be:	8b 5d f8             	mov    -0x8(%ebp),%ebx
 1c1:	8b 75 fc             	mov    -0x4(%ebp),%esi
 1c4:	89 ec                	mov    %ebp,%esp
 1c6:	5d                   	pop    %ebp
 1c7:	c3                   	ret    
 1c8:	90                   	nop
 1c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
 1d0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1d5:	eb e5                	jmp    1bc <stat+0x3c>
 1d7:	89 f6                	mov    %esi,%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <atoi>:

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	0f be 11             	movsbl (%ecx),%edx
 1ea:	88 d0                	mov    %dl,%al
 1ec:	2c 30                	sub    $0x30,%al
 1ee:	3c 09                	cmp    $0x9,%al
  n = 0;
 1f0:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 1f5:	77 1e                	ja     215 <atoi+0x35>
 1f7:	89 f6                	mov    %esi,%esi
 1f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 200:	41                   	inc    %ecx
 201:	8d 04 80             	lea    (%eax,%eax,4),%eax
 204:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 208:	0f be 11             	movsbl (%ecx),%edx
 20b:	88 d3                	mov    %dl,%bl
 20d:	80 eb 30             	sub    $0x30,%bl
 210:	80 fb 09             	cmp    $0x9,%bl
 213:	76 eb                	jbe    200 <atoi+0x20>
  return n;
}
 215:	5b                   	pop    %ebx
 216:	5d                   	pop    %ebp
 217:	c3                   	ret    
 218:	90                   	nop
 219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000220 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	8b 45 08             	mov    0x8(%ebp),%eax
 227:	53                   	push   %ebx
 228:	8b 5d 10             	mov    0x10(%ebp),%ebx
 22b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 22e:	85 db                	test   %ebx,%ebx
 230:	7e 1a                	jle    24c <memmove+0x2c>
 232:	31 d2                	xor    %edx,%edx
 234:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 23a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *dst++ = *src++;
 240:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 244:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 247:	42                   	inc    %edx
  while(n-- > 0)
 248:	39 d3                	cmp    %edx,%ebx
 24a:	75 f4                	jne    240 <memmove+0x20>
  return vdst;
}
 24c:	5b                   	pop    %ebx
 24d:	5e                   	pop    %esi
 24e:	5d                   	pop    %ebp
 24f:	c3                   	ret    

00000250 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 250:	b8 01 00 00 00       	mov    $0x1,%eax
 255:	cd 40                	int    $0x40
 257:	c3                   	ret    

00000258 <exit>:
SYSCALL(exit)
 258:	b8 02 00 00 00       	mov    $0x2,%eax
 25d:	cd 40                	int    $0x40
 25f:	c3                   	ret    

00000260 <wait>:
SYSCALL(wait)
 260:	b8 03 00 00 00       	mov    $0x3,%eax
 265:	cd 40                	int    $0x40
 267:	c3                   	ret    

00000268 <pipe>:
SYSCALL(pipe)
 268:	b8 04 00 00 00       	mov    $0x4,%eax
 26d:	cd 40                	int    $0x40
 26f:	c3                   	ret    

00000270 <read>:
SYSCALL(read)
 270:	b8 05 00 00 00       	mov    $0x5,%eax
 275:	cd 40                	int    $0x40
 277:	c3                   	ret    

00000278 <write>:
SYSCALL(write)
 278:	b8 10 00 00 00       	mov    $0x10,%eax
 27d:	cd 40                	int    $0x40
 27f:	c3                   	ret    

00000280 <close>:
SYSCALL(close)
 280:	b8 15 00 00 00       	mov    $0x15,%eax
 285:	cd 40                	int    $0x40
 287:	c3                   	ret    

00000288 <kill>:
SYSCALL(kill)
 288:	b8 06 00 00 00       	mov    $0x6,%eax
 28d:	cd 40                	int    $0x40
 28f:	c3                   	ret    

00000290 <exec>:
SYSCALL(exec)
 290:	b8 07 00 00 00       	mov    $0x7,%eax
 295:	cd 40                	int    $0x40
 297:	c3                   	ret    

00000298 <open>:
SYSCALL(open)
 298:	b8 0f 00 00 00       	mov    $0xf,%eax
 29d:	cd 40                	int    $0x40
 29f:	c3                   	ret    

000002a0 <mknod>:
SYSCALL(mknod)
 2a0:	b8 11 00 00 00       	mov    $0x11,%eax
 2a5:	cd 40                	int    $0x40
 2a7:	c3                   	ret    

000002a8 <unlink>:
SYSCALL(unlink)
 2a8:	b8 12 00 00 00       	mov    $0x12,%eax
 2ad:	cd 40                	int    $0x40
 2af:	c3                   	ret    

000002b0 <fstat>:
SYSCALL(fstat)
 2b0:	b8 08 00 00 00       	mov    $0x8,%eax
 2b5:	cd 40                	int    $0x40
 2b7:	c3                   	ret    

000002b8 <link>:
SYSCALL(link)
 2b8:	b8 13 00 00 00       	mov    $0x13,%eax
 2bd:	cd 40                	int    $0x40
 2bf:	c3                   	ret    

000002c0 <mkdir>:
SYSCALL(mkdir)
 2c0:	b8 14 00 00 00       	mov    $0x14,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <chdir>:
SYSCALL(chdir)
 2c8:	b8 09 00 00 00       	mov    $0x9,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <dup>:
SYSCALL(dup)
 2d0:	b8 0a 00 00 00       	mov    $0xa,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <getpid>:
SYSCALL(getpid)
 2d8:	b8 0b 00 00 00       	mov    $0xb,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <sbrk>:
SYSCALL(sbrk)
 2e0:	b8 0c 00 00 00       	mov    $0xc,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <sleep>:
SYSCALL(sleep)
 2e8:	b8 0d 00 00 00       	mov    $0xd,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <uptime>:
SYSCALL(uptime)
 2f0:	b8 0e 00 00 00       	mov    $0xe,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <detach>:
SYSCALL(detach)
 2f8:	b8 16 00 00 00       	mov    $0x16,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <policy>:
SYSCALL(policy)
 300:	b8 17 00 00 00       	mov    $0x17,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <priority>:
 308:	b8 18 00 00 00       	mov    $0x18,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	57                   	push   %edi
 314:	56                   	push   %esi
 315:	53                   	push   %ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 316:	89 d3                	mov    %edx,%ebx
 318:	c1 eb 1f             	shr    $0x1f,%ebx
{
 31b:	83 ec 4c             	sub    $0x4c,%esp
  if(sgn && xx < 0){
 31e:	84 db                	test   %bl,%bl
{
 320:	89 45 c0             	mov    %eax,-0x40(%ebp)
 323:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 325:	74 79                	je     3a0 <printint+0x90>
 327:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 32b:	74 73                	je     3a0 <printint+0x90>
    neg = 1;
    x = -xx;
 32d:	f7 d8                	neg    %eax
    neg = 1;
 32f:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 336:	31 f6                	xor    %esi,%esi
 338:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 33b:	eb 05                	jmp    342 <printint+0x32>
 33d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 340:	89 fe                	mov    %edi,%esi
 342:	31 d2                	xor    %edx,%edx
 344:	f7 f1                	div    %ecx
 346:	8d 7e 01             	lea    0x1(%esi),%edi
 349:	0f b6 92 30 07 00 00 	movzbl 0x730(%edx),%edx
  }while((x /= base) != 0);
 350:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 352:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 355:	75 e9                	jne    340 <printint+0x30>
  if(neg)
 357:	8b 55 c4             	mov    -0x3c(%ebp),%edx
 35a:	85 d2                	test   %edx,%edx
 35c:	74 08                	je     366 <printint+0x56>
    buf[i++] = '-';
 35e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 363:	8d 7e 02             	lea    0x2(%esi),%edi
 366:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 36a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 36d:	8d 76 00             	lea    0x0(%esi),%esi
 370:	0f b6 06             	movzbl (%esi),%eax
 373:	4e                   	dec    %esi
  write(fd, &c, 1);
 374:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 378:	89 3c 24             	mov    %edi,(%esp)
 37b:	88 45 d7             	mov    %al,-0x29(%ebp)
 37e:	b8 01 00 00 00       	mov    $0x1,%eax
 383:	89 44 24 08          	mov    %eax,0x8(%esp)
 387:	e8 ec fe ff ff       	call   278 <write>

  while(--i >= 0)
 38c:	39 de                	cmp    %ebx,%esi
 38e:	75 e0                	jne    370 <printint+0x60>
    putc(fd, buf[i]);
}
 390:	83 c4 4c             	add    $0x4c,%esp
 393:	5b                   	pop    %ebx
 394:	5e                   	pop    %esi
 395:	5f                   	pop    %edi
 396:	5d                   	pop    %ebp
 397:	c3                   	ret    
 398:	90                   	nop
 399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 3a0:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3a7:	eb 8d                	jmp    336 <printint+0x26>
 3a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000003b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	53                   	push   %ebx
 3b6:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3b9:	8b 75 0c             	mov    0xc(%ebp),%esi
 3bc:	0f b6 1e             	movzbl (%esi),%ebx
 3bf:	84 db                	test   %bl,%bl
 3c1:	0f 84 d1 00 00 00    	je     498 <printf+0xe8>
  state = 0;
 3c7:	31 ff                	xor    %edi,%edi
 3c9:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
 3ca:	8d 45 10             	lea    0x10(%ebp),%eax
  write(fd, &c, 1);
 3cd:	89 fa                	mov    %edi,%edx
 3cf:	8b 7d 08             	mov    0x8(%ebp),%edi
  ap = (uint*)(void*)&fmt + 1;
 3d2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3d5:	eb 41                	jmp    418 <printf+0x68>
 3d7:	89 f6                	mov    %esi,%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3e0:	83 f8 25             	cmp    $0x25,%eax
 3e3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
 3e6:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 3eb:	74 1e                	je     40b <printf+0x5b>
  write(fd, &c, 1);
 3ed:	b8 01 00 00 00       	mov    $0x1,%eax
 3f2:	89 44 24 08          	mov    %eax,0x8(%esp)
 3f6:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 3fd:	89 3c 24             	mov    %edi,(%esp)
 400:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 403:	e8 70 fe ff ff       	call   278 <write>
 408:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 40b:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
 40c:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 410:	84 db                	test   %bl,%bl
 412:	0f 84 80 00 00 00    	je     498 <printf+0xe8>
    if(state == 0){
 418:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
 41a:	0f be cb             	movsbl %bl,%ecx
 41d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 420:	74 be                	je     3e0 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 422:	83 fa 25             	cmp    $0x25,%edx
 425:	75 e4                	jne    40b <printf+0x5b>
      if(c == 'd'){
 427:	83 f8 64             	cmp    $0x64,%eax
 42a:	0f 84 f0 00 00 00    	je     520 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 430:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 436:	83 f9 70             	cmp    $0x70,%ecx
 439:	74 65                	je     4a0 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 43b:	83 f8 73             	cmp    $0x73,%eax
 43e:	0f 84 8c 00 00 00    	je     4d0 <printf+0x120>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 444:	83 f8 63             	cmp    $0x63,%eax
 447:	0f 84 13 01 00 00    	je     560 <printf+0x1b0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 44d:	83 f8 25             	cmp    $0x25,%eax
 450:	0f 84 e2 00 00 00    	je     538 <printf+0x188>
  write(fd, &c, 1);
 456:	b8 01 00 00 00       	mov    $0x1,%eax
 45b:	46                   	inc    %esi
 45c:	89 44 24 08          	mov    %eax,0x8(%esp)
 460:	8d 45 e7             	lea    -0x19(%ebp),%eax
 463:	89 44 24 04          	mov    %eax,0x4(%esp)
 467:	89 3c 24             	mov    %edi,(%esp)
 46a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 46e:	e8 05 fe ff ff       	call   278 <write>
 473:	ba 01 00 00 00       	mov    $0x1,%edx
 478:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 47b:	89 54 24 08          	mov    %edx,0x8(%esp)
 47f:	89 44 24 04          	mov    %eax,0x4(%esp)
 483:	89 3c 24             	mov    %edi,(%esp)
 486:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 489:	e8 ea fd ff ff       	call   278 <write>
  for(i = 0; fmt[i]; i++){
 48e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 492:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
 494:	84 db                	test   %bl,%bl
 496:	75 80                	jne    418 <printf+0x68>
    }
  }
}
 498:	83 c4 3c             	add    $0x3c,%esp
 49b:	5b                   	pop    %ebx
 49c:	5e                   	pop    %esi
 49d:	5f                   	pop    %edi
 49e:	5d                   	pop    %ebp
 49f:	c3                   	ret    
        printint(fd, *ap, 16, 0);
 4a0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4a7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4ac:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 4af:	89 f8                	mov    %edi,%eax
 4b1:	8b 13                	mov    (%ebx),%edx
 4b3:	e8 58 fe ff ff       	call   310 <printint>
        ap++;
 4b8:	89 d8                	mov    %ebx,%eax
      state = 0;
 4ba:	31 d2                	xor    %edx,%edx
        ap++;
 4bc:	83 c0 04             	add    $0x4,%eax
 4bf:	89 45 d0             	mov    %eax,-0x30(%ebp)
 4c2:	e9 44 ff ff ff       	jmp    40b <printf+0x5b>
 4c7:	89 f6                	mov    %esi,%esi
 4c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = (char*)*ap;
 4d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
 4d3:	8b 10                	mov    (%eax),%edx
        ap++;
 4d5:	83 c0 04             	add    $0x4,%eax
 4d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 4db:	85 d2                	test   %edx,%edx
 4dd:	0f 84 aa 00 00 00    	je     58d <printf+0x1dd>
        while(*s != 0){
 4e3:	0f b6 02             	movzbl (%edx),%eax
        s = (char*)*ap;
 4e6:	89 d3                	mov    %edx,%ebx
        while(*s != 0){
 4e8:	84 c0                	test   %al,%al
 4ea:	74 27                	je     513 <printf+0x163>
 4ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4f0:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 4f3:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
 4f8:	43                   	inc    %ebx
  write(fd, &c, 1);
 4f9:	89 44 24 08          	mov    %eax,0x8(%esp)
 4fd:	8d 45 e3             	lea    -0x1d(%ebp),%eax
 500:	89 44 24 04          	mov    %eax,0x4(%esp)
 504:	89 3c 24             	mov    %edi,(%esp)
 507:	e8 6c fd ff ff       	call   278 <write>
        while(*s != 0){
 50c:	0f b6 03             	movzbl (%ebx),%eax
 50f:	84 c0                	test   %al,%al
 511:	75 dd                	jne    4f0 <printf+0x140>
      state = 0;
 513:	31 d2                	xor    %edx,%edx
 515:	e9 f1 fe ff ff       	jmp    40b <printf+0x5b>
 51a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 520:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 527:	b9 0a 00 00 00       	mov    $0xa,%ecx
 52c:	e9 7b ff ff ff       	jmp    4ac <printf+0xfc>
 531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
 538:	b9 01 00 00 00       	mov    $0x1,%ecx
 53d:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 540:	89 4c 24 08          	mov    %ecx,0x8(%esp)
 544:	89 44 24 04          	mov    %eax,0x4(%esp)
 548:	89 3c 24             	mov    %edi,(%esp)
 54b:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 54e:	e8 25 fd ff ff       	call   278 <write>
      state = 0;
 553:	31 d2                	xor    %edx,%edx
 555:	e9 b1 fe ff ff       	jmp    40b <printf+0x5b>
 55a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, *ap);
 560:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 563:	8b 03                	mov    (%ebx),%eax
        ap++;
 565:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
 568:	89 3c 24             	mov    %edi,(%esp)
        putc(fd, *ap);
 56b:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 56e:	b8 01 00 00 00       	mov    $0x1,%eax
 573:	89 44 24 08          	mov    %eax,0x8(%esp)
 577:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 57a:	89 44 24 04          	mov    %eax,0x4(%esp)
 57e:	e8 f5 fc ff ff       	call   278 <write>
      state = 0;
 583:	31 d2                	xor    %edx,%edx
        ap++;
 585:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 588:	e9 7e fe ff ff       	jmp    40b <printf+0x5b>
          s = "(null)";
 58d:	bb 28 07 00 00       	mov    $0x728,%ebx
        while(*s != 0){
 592:	b0 28                	mov    $0x28,%al
 594:	e9 57 ff ff ff       	jmp    4f0 <printf+0x140>
 599:	66 90                	xchg   %ax,%ax
 59b:	66 90                	xchg   %ax,%ax
 59d:	66 90                	xchg   %ax,%ax
 59f:	90                   	nop

000005a0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5a0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a1:	a1 bc 09 00 00       	mov    0x9bc,%eax
{
 5a6:	89 e5                	mov    %esp,%ebp
 5a8:	57                   	push   %edi
 5a9:	56                   	push   %esi
 5aa:	53                   	push   %ebx
 5ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 5ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 5b1:	eb 0d                	jmp    5c0 <free+0x20>
 5b3:	90                   	nop
 5b4:	90                   	nop
 5b5:	90                   	nop
 5b6:	90                   	nop
 5b7:	90                   	nop
 5b8:	90                   	nop
 5b9:	90                   	nop
 5ba:	90                   	nop
 5bb:	90                   	nop
 5bc:	90                   	nop
 5bd:	90                   	nop
 5be:	90                   	nop
 5bf:	90                   	nop
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5c0:	39 c8                	cmp    %ecx,%eax
 5c2:	8b 10                	mov    (%eax),%edx
 5c4:	73 32                	jae    5f8 <free+0x58>
 5c6:	39 d1                	cmp    %edx,%ecx
 5c8:	72 04                	jb     5ce <free+0x2e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ca:	39 d0                	cmp    %edx,%eax
 5cc:	72 32                	jb     600 <free+0x60>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5ce:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5d1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5d4:	39 fa                	cmp    %edi,%edx
 5d6:	74 30                	je     608 <free+0x68>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5d8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5db:	8b 50 04             	mov    0x4(%eax),%edx
 5de:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5e1:	39 f1                	cmp    %esi,%ecx
 5e3:	74 3c                	je     621 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5e5:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
 5e7:	5b                   	pop    %ebx
  freep = p;
 5e8:	a3 bc 09 00 00       	mov    %eax,0x9bc
}
 5ed:	5e                   	pop    %esi
 5ee:	5f                   	pop    %edi
 5ef:	5d                   	pop    %ebp
 5f0:	c3                   	ret    
 5f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5f8:	39 d0                	cmp    %edx,%eax
 5fa:	72 04                	jb     600 <free+0x60>
 5fc:	39 d1                	cmp    %edx,%ecx
 5fe:	72 ce                	jb     5ce <free+0x2e>
{
 600:	89 d0                	mov    %edx,%eax
 602:	eb bc                	jmp    5c0 <free+0x20>
 604:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 608:	8b 7a 04             	mov    0x4(%edx),%edi
 60b:	01 fe                	add    %edi,%esi
 60d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 610:	8b 10                	mov    (%eax),%edx
 612:	8b 12                	mov    (%edx),%edx
 614:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 617:	8b 50 04             	mov    0x4(%eax),%edx
 61a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 61d:	39 f1                	cmp    %esi,%ecx
 61f:	75 c4                	jne    5e5 <free+0x45>
    p->s.size += bp->s.size;
 621:	8b 4b fc             	mov    -0x4(%ebx),%ecx
  freep = p;
 624:	a3 bc 09 00 00       	mov    %eax,0x9bc
    p->s.size += bp->s.size;
 629:	01 ca                	add    %ecx,%edx
 62b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 62e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 631:	89 10                	mov    %edx,(%eax)
}
 633:	5b                   	pop    %ebx
 634:	5e                   	pop    %esi
 635:	5f                   	pop    %edi
 636:	5d                   	pop    %ebp
 637:	c3                   	ret    
 638:	90                   	nop
 639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000640 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 640:	55                   	push   %ebp
 641:	89 e5                	mov    %esp,%ebp
 643:	57                   	push   %edi
 644:	56                   	push   %esi
 645:	53                   	push   %ebx
 646:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 649:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 64c:	8b 15 bc 09 00 00    	mov    0x9bc,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 652:	8d 78 07             	lea    0x7(%eax),%edi
 655:	c1 ef 03             	shr    $0x3,%edi
 658:	47                   	inc    %edi
  if((prevp = freep) == 0){
 659:	85 d2                	test   %edx,%edx
 65b:	0f 84 8f 00 00 00    	je     6f0 <malloc+0xb0>
 661:	8b 02                	mov    (%edx),%eax
 663:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 666:	39 cf                	cmp    %ecx,%edi
 668:	76 66                	jbe    6d0 <malloc+0x90>
 66a:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 670:	bb 00 10 00 00       	mov    $0x1000,%ebx
 675:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 678:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 67f:	eb 10                	jmp    691 <malloc+0x51>
 681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 688:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 68a:	8b 48 04             	mov    0x4(%eax),%ecx
 68d:	39 f9                	cmp    %edi,%ecx
 68f:	73 3f                	jae    6d0 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 691:	39 05 bc 09 00 00    	cmp    %eax,0x9bc
 697:	89 c2                	mov    %eax,%edx
 699:	75 ed                	jne    688 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 69b:	89 34 24             	mov    %esi,(%esp)
 69e:	e8 3d fc ff ff       	call   2e0 <sbrk>
  if(p == (char*)-1)
 6a3:	83 f8 ff             	cmp    $0xffffffff,%eax
 6a6:	74 18                	je     6c0 <malloc+0x80>
  hp->s.size = nu;
 6a8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6ab:	83 c0 08             	add    $0x8,%eax
 6ae:	89 04 24             	mov    %eax,(%esp)
 6b1:	e8 ea fe ff ff       	call   5a0 <free>
  return freep;
 6b6:	8b 15 bc 09 00 00    	mov    0x9bc,%edx
      if((p = morecore(nunits)) == 0)
 6bc:	85 d2                	test   %edx,%edx
 6be:	75 c8                	jne    688 <malloc+0x48>
        return 0;
  }
}
 6c0:	83 c4 1c             	add    $0x1c,%esp
        return 0;
 6c3:	31 c0                	xor    %eax,%eax
}
 6c5:	5b                   	pop    %ebx
 6c6:	5e                   	pop    %esi
 6c7:	5f                   	pop    %edi
 6c8:	5d                   	pop    %ebp
 6c9:	c3                   	ret    
 6ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 6d0:	39 cf                	cmp    %ecx,%edi
 6d2:	74 4c                	je     720 <malloc+0xe0>
        p->s.size -= nunits;
 6d4:	29 f9                	sub    %edi,%ecx
 6d6:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 6d9:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 6dc:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 6df:	89 15 bc 09 00 00    	mov    %edx,0x9bc
}
 6e5:	83 c4 1c             	add    $0x1c,%esp
      return (void*)(p + 1);
 6e8:	83 c0 08             	add    $0x8,%eax
}
 6eb:	5b                   	pop    %ebx
 6ec:	5e                   	pop    %esi
 6ed:	5f                   	pop    %edi
 6ee:	5d                   	pop    %ebp
 6ef:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
 6f0:	b8 c0 09 00 00       	mov    $0x9c0,%eax
 6f5:	ba c0 09 00 00       	mov    $0x9c0,%edx
    base.s.size = 0;
 6fa:	31 c9                	xor    %ecx,%ecx
    base.s.ptr = freep = prevp = &base;
 6fc:	a3 bc 09 00 00       	mov    %eax,0x9bc
    base.s.size = 0;
 701:	b8 c0 09 00 00       	mov    $0x9c0,%eax
    base.s.ptr = freep = prevp = &base;
 706:	89 15 c0 09 00 00    	mov    %edx,0x9c0
    base.s.size = 0;
 70c:	89 0d c4 09 00 00    	mov    %ecx,0x9c4
 712:	e9 53 ff ff ff       	jmp    66a <malloc+0x2a>
 717:	89 f6                	mov    %esi,%esi
 719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        prevp->s.ptr = p->s.ptr;
 720:	8b 08                	mov    (%eax),%ecx
 722:	89 0a                	mov    %ecx,(%edx)
 724:	eb b9                	jmp    6df <malloc+0x9f>
