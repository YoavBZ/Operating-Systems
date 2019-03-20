
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	83 e4 f0             	and    $0xfffffff0,%esp
       6:	83 ec 10             	sub    $0x10,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
       9:	eb 0e                	jmp    19 <main+0x19>
       b:	90                   	nop
       c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(fd >= 3){
      10:	83 f8 02             	cmp    $0x2,%eax
      13:	0f 8f ce 00 00 00    	jg     e7 <main+0xe7>
  while((fd = open("console", O_RDWR)) >= 0){
      19:	b9 02 00 00 00       	mov    $0x2,%ecx
      1e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
      22:	c7 04 24 64 17 00 00 	movl   $0x1764,(%esp)
      29:	e8 ea 11 00 00       	call   1218 <open>
      2e:	85 c0                	test   %eax,%eax
      30:	79 de                	jns    10 <main+0x10>
      close(fd);
      break;
    }
  }

  int open_fd = open("/path", O_RDWR|O_CREATE);
      32:	ba 02 02 00 00       	mov    $0x202,%edx
      37:	89 54 24 04          	mov    %edx,0x4(%esp)
      3b:	c7 04 24 c2 16 00 00 	movl   $0x16c2,(%esp)
      42:	e8 d1 11 00 00       	call   1218 <open>
  if(open_fd < 0){
      47:	85 c0                	test   %eax,%eax
      49:	79 27                	jns    72 <main+0x72>
      4b:	e9 d1 00 00 00       	jmp    121 <main+0x121>
int
fork1(void)
{
  int pid;

  pid = fork();
      50:	e8 7b 11 00 00       	call   11d0 <fork>
  if(pid == -1)
      55:	83 f8 ff             	cmp    $0xffffffff,%eax
      58:	0f 84 a3 00 00 00    	je     101 <main+0x101>
    if(fork1() == 0)
      5e:	85 c0                	test   %eax,%eax
      60:	0f 84 a7 00 00 00    	je     10d <main+0x10d>
    wait(null);
      66:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      6d:	e8 6e 11 00 00       	call   11e0 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
      72:	b8 64 00 00 00       	mov    $0x64,%eax
      77:	89 44 24 04          	mov    %eax,0x4(%esp)
      7b:	c7 04 24 20 1e 00 00 	movl   $0x1e20,(%esp)
      82:	e8 59 02 00 00       	call   2e0 <getcmd>
      87:	85 c0                	test   %eax,%eax
      89:	78 6a                	js     f5 <main+0xf5>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      8b:	80 3d 20 1e 00 00 63 	cmpb   $0x63,0x1e20
      92:	75 bc                	jne    50 <main+0x50>
      94:	80 3d 21 1e 00 00 64 	cmpb   $0x64,0x1e21
      9b:	75 b3                	jne    50 <main+0x50>
      9d:	80 3d 22 1e 00 00 20 	cmpb   $0x20,0x1e22
      a4:	75 aa                	jne    50 <main+0x50>
      buf[strlen(buf)-1] = 0;  // chop \n
      a6:	c7 04 24 20 1e 00 00 	movl   $0x1e20,(%esp)
      ad:	e8 5e 0f 00 00       	call   1010 <strlen>
      if(chdir(buf+3) < 0)
      b2:	c7 04 24 23 1e 00 00 	movl   $0x1e23,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
      b9:	c6 80 1f 1e 00 00 00 	movb   $0x0,0x1e1f(%eax)
      if(chdir(buf+3) < 0)
      c0:	e8 83 11 00 00       	call   1248 <chdir>
      c5:	85 c0                	test   %eax,%eax
      c7:	79 a9                	jns    72 <main+0x72>
        printf(2, "cannot cd %s\n", buf+3);
      c9:	c7 44 24 08 23 1e 00 	movl   $0x1e23,0x8(%esp)
      d0:	00 
      d1:	c7 44 24 04 6c 17 00 	movl   $0x176c,0x4(%esp)
      d8:	00 
      d9:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
      e0:	e8 4b 12 00 00       	call   1330 <printf>
      e5:	eb 8b                	jmp    72 <main+0x72>
      close(fd);
      e7:	89 04 24             	mov    %eax,(%esp)
      ea:	e8 11 11 00 00       	call   1200 <close>
      ef:	90                   	nop
      break;
      f0:	e9 3d ff ff ff       	jmp    32 <main+0x32>
  exit(0);
      f5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
      fc:	e8 d7 10 00 00       	call   11d8 <exit>
    panic("fork");
     101:	c7 04 24 ed 16 00 00 	movl   $0x16ed,(%esp)
     108:	e8 33 02 00 00       	call   340 <panic>
      runcmd(parsecmd(buf));
     10d:	c7 04 24 20 1e 00 00 	movl   $0x1e20,(%esp)
     114:	e8 17 0e 00 00       	call   f30 <parsecmd>
     119:	89 04 24             	mov    %eax,(%esp)
     11c:	e8 4f 02 00 00       	call   370 <runcmd>
    close(open_fd);
     121:	89 04 24             	mov    %eax,(%esp)
     124:	e8 d7 10 00 00       	call   1200 <close>
    printf(0, "problem to open path");
     129:	c7 44 24 04 c8 16 00 	movl   $0x16c8,0x4(%esp)
     130:	00 
     131:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     138:	e8 f3 11 00 00       	call   1330 <printf>
     13d:	e9 30 ff ff ff       	jmp    72 <main+0x72>
     142:	66 90                	xchg   %ax,%ax
     144:	66 90                	xchg   %ax,%ax
     146:	66 90                	xchg   %ax,%ax
     148:	66 90                	xchg   %ax,%ax
     14a:	66 90                	xchg   %ax,%ax
     14c:	66 90                	xchg   %ax,%ax
     14e:	66 90                	xchg   %ax,%ax

00000150 <strncpy>:
{
     150:	55                   	push   %ebp
     151:	89 e5                	mov    %esp,%ebp
     153:	8b 45 08             	mov    0x8(%ebp),%eax
     156:	56                   	push   %esi
     157:	8b 4d 10             	mov    0x10(%ebp),%ecx
     15a:	53                   	push   %ebx
     15b:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n-- > 0 && (*s++ = *t++) != 0)
     15e:	89 c2                	mov    %eax,%edx
     160:	eb 15                	jmp    177 <strncpy+0x27>
     162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     168:	46                   	inc    %esi
     169:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
     16d:	42                   	inc    %edx
     16e:	84 c9                	test   %cl,%cl
     170:	88 4a ff             	mov    %cl,-0x1(%edx)
     173:	74 09                	je     17e <strncpy+0x2e>
     175:	89 d9                	mov    %ebx,%ecx
     177:	85 c9                	test   %ecx,%ecx
     179:	8d 59 ff             	lea    -0x1(%ecx),%ebx
     17c:	7f ea                	jg     168 <strncpy+0x18>
  while(n-- > 0)
     17e:	31 c9                	xor    %ecx,%ecx
     180:	85 db                	test   %ebx,%ebx
     182:	7e 19                	jle    19d <strncpy+0x4d>
     184:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     18a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *s++ = 0;
     190:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
     194:	89 de                	mov    %ebx,%esi
     196:	41                   	inc    %ecx
     197:	29 ce                	sub    %ecx,%esi
  while(n-- > 0)
     199:	85 f6                	test   %esi,%esi
     19b:	7f f3                	jg     190 <strncpy+0x40>
}
     19d:	5b                   	pop    %ebx
     19e:	5e                   	pop    %esi
     19f:	5d                   	pop    %ebp
     1a0:	c3                   	ret    
     1a1:	eb 0d                	jmp    1b0 <getNextPath>
     1a3:	90                   	nop
     1a4:	90                   	nop
     1a5:	90                   	nop
     1a6:	90                   	nop
     1a7:	90                   	nop
     1a8:	90                   	nop
     1a9:	90                   	nop
     1aa:	90                   	nop
     1ab:	90                   	nop
     1ac:	90                   	nop
     1ad:	90                   	nop
     1ae:	90                   	nop
     1af:	90                   	nop

000001b0 <getNextPath>:
char* getNextPath(char* buff ){
     1b0:	55                   	push   %ebp
     1b1:	89 e5                	mov    %esp,%ebp
     1b3:	57                   	push   %edi
     1b4:	56                   	push   %esi
     1b5:	53                   	push   %ebx
     1b6:	83 ec 2c             	sub    $0x2c,%esp
     1b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  while(*buff !=':' && *buff != null){
     1bc:	0f b6 03             	movzbl (%ebx),%eax
     1bf:	3c 3a                	cmp    $0x3a,%al
     1c1:	0f 84 89 00 00 00    	je     250 <getNextPath+0xa0>
     1c7:	84 c0                	test   %al,%al
     1c9:	0f 84 81 00 00 00    	je     250 <getNextPath+0xa0>
     1cf:	89 d8                	mov    %ebx,%eax
     1d1:	eb 09                	jmp    1dc <getNextPath+0x2c>
     1d3:	90                   	nop
     1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     1d8:	84 c9                	test   %cl,%cl
     1da:	74 0d                	je     1e9 <getNextPath+0x39>
    buff++;
     1dc:	40                   	inc    %eax
  while(*buff !=':' && *buff != null){
     1dd:	0f b6 08             	movzbl (%eax),%ecx
     1e0:	89 c2                	mov    %eax,%edx
     1e2:	29 da                	sub    %ebx,%edx
     1e4:	80 f9 3a             	cmp    $0x3a,%cl
     1e7:	75 ef                	jne    1d8 <getNextPath+0x28>
     1e9:	89 d3                	mov    %edx,%ebx
     1eb:	89 d6                	mov    %edx,%esi
     1ed:	8d 4a 01             	lea    0x1(%edx),%ecx
     1f0:	f7 db                	neg    %ebx
  char* returnedString = (char*)malloc(len+1);
     1f2:	89 0c 24             	mov    %ecx,(%esp)
  buff = buff - len;
     1f5:	01 c3                	add    %eax,%ebx
     1f7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  char* returnedString = (char*)malloc(len+1);
     1fa:	e8 c1 13 00 00       	call   15c0 <malloc>
  returnedString[len] = '\0';
     1ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  char* returnedString = (char*)malloc(len+1);
     202:	89 c7                	mov    %eax,%edi
  returnedString[len] = '\0';
     204:	c6 04 10 00          	movb   $0x0,(%eax,%edx,1)
     208:	89 c2                	mov    %eax,%edx
     20a:	eb 13                	jmp    21f <getNextPath+0x6f>
     20c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(n-- > 0 && (*s++ = *t++) != 0)
     210:	43                   	inc    %ebx
     211:	0f b6 43 ff          	movzbl -0x1(%ebx),%eax
     215:	42                   	inc    %edx
     216:	84 c0                	test   %al,%al
     218:	88 42 ff             	mov    %al,-0x1(%edx)
     21b:	74 09                	je     226 <getNextPath+0x76>
     21d:	89 ce                	mov    %ecx,%esi
     21f:	85 f6                	test   %esi,%esi
     221:	8d 4e ff             	lea    -0x1(%esi),%ecx
     224:	7f ea                	jg     210 <getNextPath+0x60>
  while(n-- > 0)
     226:	85 c9                	test   %ecx,%ecx
     228:	7e 13                	jle    23d <getNextPath+0x8d>
     22a:	31 c0                	xor    %eax,%eax
     22c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
     230:	c6 04 02 00          	movb   $0x0,(%edx,%eax,1)
     234:	89 cb                	mov    %ecx,%ebx
     236:	40                   	inc    %eax
     237:	29 c3                	sub    %eax,%ebx
  while(n-- > 0)
     239:	85 db                	test   %ebx,%ebx
     23b:	7f f3                	jg     230 <getNextPath+0x80>
}
     23d:	83 c4 2c             	add    $0x2c,%esp
     240:	89 f8                	mov    %edi,%eax
     242:	5b                   	pop    %ebx
     243:	5e                   	pop    %esi
     244:	5f                   	pop    %edi
     245:	5d                   	pop    %ebp
     246:	c3                   	ret    
     247:	89 f6                	mov    %esi,%esi
     249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  while(*buff !=':' && *buff != null){
     250:	89 d8                	mov    %ebx,%eax
     252:	31 f6                	xor    %esi,%esi
     254:	b9 01 00 00 00       	mov    $0x1,%ecx
     259:	31 db                	xor    %ebx,%ebx
  uint len = 0;
     25b:	31 d2                	xor    %edx,%edx
     25d:	eb 93                	jmp    1f2 <getNextPath+0x42>
     25f:	90                   	nop

00000260 <movePathPointer>:
char* movePathPointer(char* buff){
     260:	55                   	push   %ebp
     261:	89 e5                	mov    %esp,%ebp
     263:	8b 45 08             	mov    0x8(%ebp),%eax
  while(*buff != ':' && *buff != null){
     266:	0f b6 10             	movzbl (%eax),%edx
     269:	80 fa 3a             	cmp    $0x3a,%dl
     26c:	75 0b                	jne    279 <movePathPointer+0x19>
     26e:	eb 0d                	jmp    27d <movePathPointer+0x1d>
    buff++;
     270:	40                   	inc    %eax
  while(*buff != ':' && *buff != null){
     271:	0f b6 10             	movzbl (%eax),%edx
     274:	80 fa 3a             	cmp    $0x3a,%dl
     277:	74 04                	je     27d <movePathPointer+0x1d>
     279:	84 d2                	test   %dl,%dl
     27b:	75 f3                	jne    270 <movePathPointer+0x10>
  if(*buff == ':'){
     27d:	80 fa 3a             	cmp    $0x3a,%dl
     280:	75 06                	jne    288 <movePathPointer+0x28>
    buff++;
     282:	40                   	inc    %eax
}
     283:	5d                   	pop    %ebp
     284:	c3                   	ret    
     285:	8d 76 00             	lea    0x0(%esi),%esi
    buff = null;
     288:	31 c0                	xor    %eax,%eax
}
     28a:	5d                   	pop    %ebp
     28b:	c3                   	ret    
     28c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000290 <strconcat>:
void strconcat(const char* stringA,const char* stringB ,char* result ,uint lenA ,uint lenB ){
     290:	55                   	push   %ebp
     291:	89 e5                	mov    %esp,%ebp
     293:	83 ec 18             	sub    $0x18,%esp
     296:	8b 45 10             	mov    0x10(%ebp),%eax
     299:	89 5d f8             	mov    %ebx,-0x8(%ebp)
  result[lenA + lenB] = '\0';
     29c:	8b 5d 14             	mov    0x14(%ebp),%ebx
     29f:	8b 55 18             	mov    0x18(%ebp),%edx
void strconcat(const char* stringA,const char* stringB ,char* result ,uint lenA ,uint lenB ){
     2a2:	89 75 fc             	mov    %esi,-0x4(%ebp)
     2a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  result[lenA + lenB] = '\0';
     2a8:	01 c3                	add    %eax,%ebx
     2aa:	01 da                	add    %ebx,%edx
     2ac:	c6 02 00             	movb   $0x0,(%edx)
  strcpy(result, stringA);
     2af:	8b 55 08             	mov    0x8(%ebp),%edx
     2b2:	89 04 24             	mov    %eax,(%esp)
     2b5:	89 54 24 04          	mov    %edx,0x4(%esp)
     2b9:	e8 f2 0c 00 00       	call   fb0 <strcpy>
  strcpy(result + lenA, stringB);
     2be:	89 75 0c             	mov    %esi,0xc(%ebp)
}
     2c1:	8b 75 fc             	mov    -0x4(%ebp),%esi
  strcpy(result + lenA, stringB);
     2c4:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
     2c7:	8b 5d f8             	mov    -0x8(%ebp),%ebx
     2ca:	89 ec                	mov    %ebp,%esp
     2cc:	5d                   	pop    %ebp
  strcpy(result + lenA, stringB);
     2cd:	e9 de 0c 00 00       	jmp    fb0 <strcpy>
     2d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000002e0 <getcmd>:
{
     2e0:	55                   	push   %ebp
  printf(2, "$ ");
     2e1:	b8 a8 16 00 00       	mov    $0x16a8,%eax
{
     2e6:	89 e5                	mov    %esp,%ebp
     2e8:	83 ec 18             	sub    $0x18,%esp
     2eb:	89 5d f8             	mov    %ebx,-0x8(%ebp)
     2ee:	8b 5d 08             	mov    0x8(%ebp),%ebx
     2f1:	89 75 fc             	mov    %esi,-0x4(%ebp)
     2f4:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
     2f7:	89 44 24 04          	mov    %eax,0x4(%esp)
     2fb:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     302:	e8 29 10 00 00       	call   1330 <printf>
  memset(buf, 0, nbuf);
     307:	31 d2                	xor    %edx,%edx
     309:	89 74 24 08          	mov    %esi,0x8(%esp)
     30d:	89 54 24 04          	mov    %edx,0x4(%esp)
     311:	89 1c 24             	mov    %ebx,(%esp)
     314:	e8 27 0d 00 00       	call   1040 <memset>
  gets(buf, nbuf);
     319:	89 74 24 04          	mov    %esi,0x4(%esp)
     31d:	89 1c 24             	mov    %ebx,(%esp)
     320:	e8 6b 0d 00 00       	call   1090 <gets>
  if(buf[0] == 0) // EOF
     325:	31 c0                	xor    %eax,%eax
}
     327:	8b 75 fc             	mov    -0x4(%ebp),%esi
  if(buf[0] == 0) // EOF
     32a:	80 3b 00             	cmpb   $0x0,(%ebx)
}
     32d:	8b 5d f8             	mov    -0x8(%ebp),%ebx
  if(buf[0] == 0) // EOF
     330:	0f 94 c0             	sete   %al
}
     333:	89 ec                	mov    %ebp,%esp
  if(buf[0] == 0) // EOF
     335:	f7 d8                	neg    %eax
}
     337:	5d                   	pop    %ebp
     338:	c3                   	ret    
     339:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000340 <panic>:
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	83 ec 18             	sub    $0x18,%esp
  printf(2, "%s\n", s);
     346:	8b 45 08             	mov    0x8(%ebp),%eax
     349:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     350:	89 44 24 08          	mov    %eax,0x8(%esp)
     354:	b8 60 17 00 00       	mov    $0x1760,%eax
     359:	89 44 24 04          	mov    %eax,0x4(%esp)
     35d:	e8 ce 0f 00 00       	call   1330 <printf>
  exit(0);
     362:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     369:	e8 6a 0e 00 00       	call   11d8 <exit>
     36e:	66 90                	xchg   %ax,%ax

00000370 <runcmd>:
{
     370:	55                   	push   %ebp
     371:	89 e5                	mov    %esp,%ebp
     373:	57                   	push   %edi
     374:	56                   	push   %esi
     375:	53                   	push   %ebx
     376:	81 ec 3c 04 00 00    	sub    $0x43c,%esp
     37c:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(cmd == 0)
     37f:	85 ff                	test   %edi,%edi
     381:	74 5d                	je     3e0 <runcmd+0x70>
  switch(cmd->type){
     383:	83 3f 05             	cmpl   $0x5,(%edi)
     386:	0f 87 98 02 00 00    	ja     624 <runcmd+0x2b4>
     38c:	8b 07                	mov    (%edi),%eax
     38e:	ff 24 85 7c 17 00 00 	jmp    *0x177c(,%eax,4)
    close(rcmd->fd);
     395:	8b 47 14             	mov    0x14(%edi),%eax
     398:	89 04 24             	mov    %eax,(%esp)
     39b:	e8 60 0e 00 00       	call   1200 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     3a0:	8b 47 10             	mov    0x10(%edi),%eax
     3a3:	89 44 24 04          	mov    %eax,0x4(%esp)
     3a7:	8b 47 08             	mov    0x8(%edi),%eax
     3aa:	89 04 24             	mov    %eax,(%esp)
     3ad:	e8 66 0e 00 00       	call   1218 <open>
     3b2:	85 c0                	test   %eax,%eax
     3b4:	79 48                	jns    3fe <runcmd+0x8e>
      printf(2, "open %s failed\n", rcmd->file);
     3b6:	8b 47 08             	mov    0x8(%edi),%eax
     3b9:	c7 44 24 04 dd 16 00 	movl   $0x16dd,0x4(%esp)
     3c0:	00 
     3c1:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     3c8:	89 44 24 08          	mov    %eax,0x8(%esp)
     3cc:	e8 5f 0f 00 00       	call   1330 <printf>
     3d1:	eb 0d                	jmp    3e0 <runcmd+0x70>
     3d3:	90                   	nop
     3d4:	90                   	nop
     3d5:	90                   	nop
     3d6:	90                   	nop
     3d7:	90                   	nop
     3d8:	90                   	nop
     3d9:	90                   	nop
     3da:	90                   	nop
     3db:	90                   	nop
     3dc:	90                   	nop
     3dd:	90                   	nop
     3de:	90                   	nop
     3df:	90                   	nop
      exit(0);
     3e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     3e7:	e8 ec 0d 00 00       	call   11d8 <exit>
  pid = fork();
     3ec:	e8 df 0d 00 00       	call   11d0 <fork>
  if(pid == -1)
     3f1:	83 f8 ff             	cmp    $0xffffffff,%eax
     3f4:	0f 84 36 02 00 00    	je     630 <runcmd+0x2c0>
    if(fork1() == 0)
     3fa:	85 c0                	test   %eax,%eax
     3fc:	75 e2                	jne    3e0 <runcmd+0x70>
      runcmd(bcmd->cmd);
     3fe:	8b 47 04             	mov    0x4(%edi),%eax
     401:	89 04 24             	mov    %eax,(%esp)
     404:	e8 67 ff ff ff       	call   370 <runcmd>
    if(ecmd->argv[0] == 0)
     409:	8b 47 04             	mov    0x4(%edi),%eax
     40c:	85 c0                	test   %eax,%eax
     40e:	74 d0                	je     3e0 <runcmd+0x70>
    exec(ecmd->argv[0], ecmd->argv);
     410:	8d 57 04             	lea    0x4(%edi),%edx
     413:	89 95 d4 fb ff ff    	mov    %edx,-0x42c(%ebp)
     419:	89 54 24 04          	mov    %edx,0x4(%esp)
     41d:	89 04 24             	mov    %eax,(%esp)
     420:	e8 eb 0d 00 00       	call   1210 <exec>
    if(*ecmd->argv[0] == '/'){ // check for absolute path which already handled in line 138
     425:	8b 47 04             	mov    0x4(%edi),%eax
     428:	80 38 2f             	cmpb   $0x2f,(%eax)
     42b:	0f 84 33 01 00 00    	je     564 <runcmd+0x1f4>
    int open_fd = open("/path", O_RDWR);
     431:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
     438:	00 
     439:	c7 04 24 c2 16 00 00 	movl   $0x16c2,(%esp)
     440:	e8 d3 0d 00 00       	call   1218 <open>
    if(open_fd < 0){
     445:	85 c0                	test   %eax,%eax
    int open_fd = open("/path", O_RDWR);
     447:	89 c6                	mov    %eax,%esi
    if(open_fd < 0){
     449:	0f 88 ed 01 00 00    	js     63c <runcmd+0x2cc>
     44f:	8d 9d e8 fb ff ff    	lea    -0x418(%ebp),%ebx
    while((n = read(open_fd, buff, sizeof(buff))));
     455:	c7 44 24 08 00 04 00 	movl   $0x400,0x8(%esp)
     45c:	00 
     45d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     461:	89 34 24             	mov    %esi,(%esp)
     464:	e8 87 0d 00 00       	call   11f0 <read>
     469:	85 c0                	test   %eax,%eax
     46b:	75 e8                	jne    455 <runcmd+0xe5>
    buff[strlen(buff)-1] = '\0';
     46d:	89 1c 24             	mov    %ebx,(%esp)
     470:	e8 9b 0b 00 00       	call   1010 <strlen>
     475:	c6 84 05 e7 fb ff ff 	movb   $0x0,-0x419(%ebp,%eax,1)
     47c:	00 
    while(buffPointer != null){
     47d:	89 a5 d8 fb ff ff    	mov    %esp,-0x428(%ebp)
      char* nextPath = getNextPath(buffPointer);
     483:	89 1c 24             	mov    %ebx,(%esp)
     486:	e8 25 fd ff ff       	call   1b0 <getNextPath>
      uint lenA = strlen(nextPath);
     48b:	89 04 24             	mov    %eax,(%esp)
     48e:	89 85 e0 fb ff ff    	mov    %eax,-0x420(%ebp)
     494:	e8 77 0b 00 00       	call   1010 <strlen>
     499:	89 c6                	mov    %eax,%esi
      uint lenB = strlen(ecmd->argv[0]);
     49b:	8b 47 04             	mov    0x4(%edi),%eax
     49e:	89 04 24             	mov    %eax,(%esp)
     4a1:	e8 6a 0b 00 00       	call   1010 <strlen>
  strcpy(result, stringA);
     4a6:	8b 95 e0 fb ff ff    	mov    -0x420(%ebp),%edx
      char result[lenA + lenB + 1];
     4ac:	89 b5 e4 fb ff ff    	mov    %esi,-0x41c(%ebp)
     4b2:	01 f0                	add    %esi,%eax
     4b4:	8d 48 10             	lea    0x10(%eax),%ecx
     4b7:	83 e1 f0             	and    $0xfffffff0,%ecx
     4ba:	29 cc                	sub    %ecx,%esp
      strconcat(nextPath, ecmd->argv[0] ,result ,lenA ,lenB);
     4bc:	8b 4f 04             	mov    0x4(%edi),%ecx
      char result[lenA + lenB + 1];
     4bf:	8d 74 24 0c          	lea    0xc(%esp),%esi
  result[lenA + lenB] = '\0';
     4c3:	c6 44 04 0c 00       	movb   $0x0,0xc(%esp,%eax,1)
      strconcat(nextPath, ecmd->argv[0] ,result ,lenA ,lenB);
     4c8:	89 8d dc fb ff ff    	mov    %ecx,-0x424(%ebp)
  strcpy(result, stringA);
     4ce:	89 54 24 04          	mov    %edx,0x4(%esp)
     4d2:	89 95 e0 fb ff ff    	mov    %edx,-0x420(%ebp)
     4d8:	89 34 24             	mov    %esi,(%esp)
     4db:	e8 d0 0a 00 00       	call   fb0 <strcpy>
  strcpy(result + lenA, stringB);
     4e0:	8b 8d dc fb ff ff    	mov    -0x424(%ebp),%ecx
     4e6:	89 4c 24 04          	mov    %ecx,0x4(%esp)
     4ea:	8b 85 e4 fb ff ff    	mov    -0x41c(%ebp),%eax
     4f0:	01 f0                	add    %esi,%eax
     4f2:	89 04 24             	mov    %eax,(%esp)
     4f5:	e8 b6 0a 00 00       	call   fb0 <strcpy>
      free(nextPath);
     4fa:	8b 95 e0 fb ff ff    	mov    -0x420(%ebp),%edx
     500:	89 14 24             	mov    %edx,(%esp)
     503:	e8 18 10 00 00       	call   1520 <free>
      printf(1, "%s\n" ,result);
     508:	89 74 24 08          	mov    %esi,0x8(%esp)
     50c:	c7 44 24 04 60 17 00 	movl   $0x1760,0x4(%esp)
     513:	00 
     514:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     51b:	e8 10 0e 00 00       	call   1330 <printf>
      exec(result, ecmd->argv);
     520:	8b 85 d4 fb ff ff    	mov    -0x42c(%ebp),%eax
     526:	89 34 24             	mov    %esi,(%esp)
     529:	89 44 24 04          	mov    %eax,0x4(%esp)
     52d:	e8 de 0c 00 00       	call   1210 <exec>
  while(*buff != ':' && *buff != null){
     532:	0f b6 03             	movzbl (%ebx),%eax
     535:	3c 3a                	cmp    $0x3a,%al
     537:	75 0f                	jne    548 <runcmd+0x1d8>
     539:	eb 11                	jmp    54c <runcmd+0x1dc>
     53b:	90                   	nop
     53c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buff++;
     540:	43                   	inc    %ebx
  while(*buff != ':' && *buff != null){
     541:	0f b6 03             	movzbl (%ebx),%eax
     544:	3c 3a                	cmp    $0x3a,%al
     546:	74 04                	je     54c <runcmd+0x1dc>
     548:	84 c0                	test   %al,%al
     54a:	75 f4                	jne    540 <runcmd+0x1d0>
  if(*buff == ':'){
     54c:	3c 3a                	cmp    $0x3a,%al
     54e:	0f 85 56 01 00 00    	jne    6aa <runcmd+0x33a>
    while(buffPointer != null){
     554:	43                   	inc    %ebx
     555:	8b a5 d8 fb ff ff    	mov    -0x428(%ebp),%esp
     55b:	0f 85 1c ff ff ff    	jne    47d <runcmd+0x10d>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     561:	8b 47 04             	mov    0x4(%edi),%eax
     564:	89 44 24 08          	mov    %eax,0x8(%esp)
     568:	c7 44 24 04 b2 16 00 	movl   $0x16b2,0x4(%esp)
     56f:	00 
     570:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     577:	e8 b4 0d 00 00       	call   1330 <printf>
    break;
     57c:	e9 5f fe ff ff       	jmp    3e0 <runcmd+0x70>
    if(pipe(p) < 0)
     581:	8d 85 e8 fb ff ff    	lea    -0x418(%ebp),%eax
     587:	89 04 24             	mov    %eax,(%esp)
     58a:	e8 59 0c 00 00       	call   11e8 <pipe>
     58f:	85 c0                	test   %eax,%eax
     591:	0f 88 07 01 00 00    	js     69e <runcmd+0x32e>
  pid = fork();
     597:	e8 34 0c 00 00       	call   11d0 <fork>
  if(pid == -1)
     59c:	83 f8 ff             	cmp    $0xffffffff,%eax
     59f:	90                   	nop
     5a0:	0f 84 8a 00 00 00    	je     630 <runcmd+0x2c0>
    if(fork1() == 0){
     5a6:	85 c0                	test   %eax,%eax
     5a8:	0f 84 07 01 00 00    	je     6b5 <runcmd+0x345>
     5ae:	66 90                	xchg   %ax,%ax
  pid = fork();
     5b0:	e8 1b 0c 00 00       	call   11d0 <fork>
  if(pid == -1)
     5b5:	83 f8 ff             	cmp    $0xffffffff,%eax
     5b8:	74 76                	je     630 <runcmd+0x2c0>
    if(fork1() == 0){
     5ba:	85 c0                	test   %eax,%eax
     5bc:	0f 84 9b 00 00 00    	je     65d <runcmd+0x2ed>
    close(p[0]);
     5c2:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
     5c8:	89 04 24             	mov    %eax,(%esp)
     5cb:	e8 30 0c 00 00       	call   1200 <close>
    close(p[1]);
     5d0:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
     5d6:	89 04 24             	mov    %eax,(%esp)
     5d9:	e8 22 0c 00 00       	call   1200 <close>
    wait(null);
     5de:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5e5:	e8 f6 0b 00 00       	call   11e0 <wait>
    wait(null);
     5ea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     5f1:	e8 ea 0b 00 00       	call   11e0 <wait>
    break;
     5f6:	e9 e5 fd ff ff       	jmp    3e0 <runcmd+0x70>
  pid = fork();
     5fb:	e8 d0 0b 00 00       	call   11d0 <fork>
  if(pid == -1)
     600:	83 f8 ff             	cmp    $0xffffffff,%eax
     603:	74 2b                	je     630 <runcmd+0x2c0>
    if(fork1() == 0)
     605:	85 c0                	test   %eax,%eax
     607:	0f 84 f1 fd ff ff    	je     3fe <runcmd+0x8e>
    wait(null);
     60d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     614:	e8 c7 0b 00 00       	call   11e0 <wait>
    runcmd(lcmd->right);
     619:	8b 47 08             	mov    0x8(%edi),%eax
     61c:	89 04 24             	mov    %eax,(%esp)
     61f:	e8 4c fd ff ff       	call   370 <runcmd>
    panic("runcmd");
     624:	c7 04 24 ab 16 00 00 	movl   $0x16ab,(%esp)
     62b:	e8 10 fd ff ff       	call   340 <panic>
    panic("fork");
     630:	c7 04 24 ed 16 00 00 	movl   $0x16ed,(%esp)
     637:	e8 04 fd ff ff       	call   340 <panic>
        close(open_fd);
     63c:	89 04 24             	mov    %eax,(%esp)
     63f:	e8 bc 0b 00 00       	call   1200 <close>
        printf(0, "problem to open path");
     644:	c7 44 24 04 c8 16 00 	movl   $0x16c8,0x4(%esp)
     64b:	00 
     64c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     653:	e8 d8 0c 00 00       	call   1330 <printf>
     658:	e9 f2 fd ff ff       	jmp    44f <runcmd+0xdf>
      close(0);
     65d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
     664:	e8 97 0b 00 00       	call   1200 <close>
      dup(p[0]);
     669:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
     66f:	89 04 24             	mov    %eax,(%esp)
     672:	e8 d9 0b 00 00       	call   1250 <dup>
      close(p[0]);
     677:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
     67d:	89 04 24             	mov    %eax,(%esp)
     680:	e8 7b 0b 00 00       	call   1200 <close>
      close(p[1]);
     685:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
     68b:	89 04 24             	mov    %eax,(%esp)
     68e:	e8 6d 0b 00 00       	call   1200 <close>
      runcmd(pcmd->right);
     693:	8b 47 08             	mov    0x8(%edi),%eax
     696:	89 04 24             	mov    %eax,(%esp)
     699:	e8 d2 fc ff ff       	call   370 <runcmd>
      panic("pipe");
     69e:	c7 04 24 f2 16 00 00 	movl   $0x16f2,(%esp)
     6a5:	e8 96 fc ff ff       	call   340 <panic>
     6aa:	8b a5 d8 fb ff ff    	mov    -0x428(%ebp),%esp
     6b0:	e9 ac fe ff ff       	jmp    561 <runcmd+0x1f1>
      close(1);
     6b5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
     6bc:	e8 3f 0b 00 00       	call   1200 <close>
      dup(p[1]);
     6c1:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
     6c7:	89 04 24             	mov    %eax,(%esp)
     6ca:	e8 81 0b 00 00       	call   1250 <dup>
      close(p[0]);
     6cf:	8b 85 e8 fb ff ff    	mov    -0x418(%ebp),%eax
     6d5:	89 04 24             	mov    %eax,(%esp)
     6d8:	e8 23 0b 00 00       	call   1200 <close>
      close(p[1]);
     6dd:	8b 85 ec fb ff ff    	mov    -0x414(%ebp),%eax
     6e3:	89 04 24             	mov    %eax,(%esp)
     6e6:	e8 15 0b 00 00       	call   1200 <close>
      runcmd(pcmd->left);
     6eb:	8b 47 04             	mov    0x4(%edi),%eax
     6ee:	89 04 24             	mov    %eax,(%esp)
     6f1:	e8 7a fc ff ff       	call   370 <runcmd>
     6f6:	8d 76 00             	lea    0x0(%esi),%esi
     6f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000700 <fork1>:
{
     700:	55                   	push   %ebp
     701:	89 e5                	mov    %esp,%ebp
     703:	83 ec 18             	sub    $0x18,%esp
  pid = fork();
     706:	e8 c5 0a 00 00       	call   11d0 <fork>
  if(pid == -1)
     70b:	83 f8 ff             	cmp    $0xffffffff,%eax
     70e:	74 02                	je     712 <fork1+0x12>
  return pid;
}
     710:	c9                   	leave  
     711:	c3                   	ret    
    panic("fork");
     712:	c7 04 24 ed 16 00 00 	movl   $0x16ed,(%esp)
     719:	e8 22 fc ff ff       	call   340 <panic>
     71e:	66 90                	xchg   %ax,%ax

00000720 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     720:	55                   	push   %ebp
     721:	89 e5                	mov    %esp,%ebp
     723:	53                   	push   %ebx
     724:	83 ec 14             	sub    $0x14,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     727:	c7 04 24 54 00 00 00 	movl   $0x54,(%esp)
     72e:	e8 8d 0e 00 00       	call   15c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     733:	31 d2                	xor    %edx,%edx
     735:	89 54 24 04          	mov    %edx,0x4(%esp)
  cmd = malloc(sizeof(*cmd));
     739:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     73b:	b8 54 00 00 00       	mov    $0x54,%eax
     740:	89 1c 24             	mov    %ebx,(%esp)
     743:	89 44 24 08          	mov    %eax,0x8(%esp)
     747:	e8 f4 08 00 00       	call   1040 <memset>
  cmd->type = EXEC;
  return (struct cmd*)cmd;
}
     74c:	89 d8                	mov    %ebx,%eax
  cmd->type = EXEC;
     74e:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
}
     754:	83 c4 14             	add    $0x14,%esp
     757:	5b                   	pop    %ebx
     758:	5d                   	pop    %ebp
     759:	c3                   	ret    
     75a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000760 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     760:	55                   	push   %ebp
     761:	89 e5                	mov    %esp,%ebp
     763:	53                   	push   %ebx
     764:	83 ec 14             	sub    $0x14,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     767:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
     76e:	e8 4d 0e 00 00       	call   15c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     773:	31 d2                	xor    %edx,%edx
     775:	89 54 24 04          	mov    %edx,0x4(%esp)
  cmd = malloc(sizeof(*cmd));
     779:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     77b:	b8 18 00 00 00       	mov    $0x18,%eax
     780:	89 1c 24             	mov    %ebx,(%esp)
     783:	89 44 24 08          	mov    %eax,0x8(%esp)
     787:	e8 b4 08 00 00       	call   1040 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     78c:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     78f:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     795:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     798:	8b 45 0c             	mov    0xc(%ebp),%eax
     79b:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     79e:	8b 45 10             	mov    0x10(%ebp),%eax
     7a1:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     7a4:	8b 45 14             	mov    0x14(%ebp),%eax
     7a7:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     7aa:	8b 45 18             	mov    0x18(%ebp),%eax
     7ad:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     7b0:	83 c4 14             	add    $0x14,%esp
     7b3:	89 d8                	mov    %ebx,%eax
     7b5:	5b                   	pop    %ebx
     7b6:	5d                   	pop    %ebp
     7b7:	c3                   	ret    
     7b8:	90                   	nop
     7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000007c0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     7c0:	55                   	push   %ebp
     7c1:	89 e5                	mov    %esp,%ebp
     7c3:	53                   	push   %ebx
     7c4:	83 ec 14             	sub    $0x14,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     7c7:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     7ce:	e8 ed 0d 00 00       	call   15c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     7d3:	31 d2                	xor    %edx,%edx
     7d5:	89 54 24 04          	mov    %edx,0x4(%esp)
  cmd = malloc(sizeof(*cmd));
     7d9:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     7db:	b8 0c 00 00 00       	mov    $0xc,%eax
     7e0:	89 1c 24             	mov    %ebx,(%esp)
     7e3:	89 44 24 08          	mov    %eax,0x8(%esp)
     7e7:	e8 54 08 00 00       	call   1040 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     7ec:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     7ef:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     7f5:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     7f8:	8b 45 0c             	mov    0xc(%ebp),%eax
     7fb:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     7fe:	83 c4 14             	add    $0x14,%esp
     801:	89 d8                	mov    %ebx,%eax
     803:	5b                   	pop    %ebx
     804:	5d                   	pop    %ebp
     805:	c3                   	ret    
     806:	8d 76 00             	lea    0x0(%esi),%esi
     809:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000810 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     810:	55                   	push   %ebp
     811:	89 e5                	mov    %esp,%ebp
     813:	53                   	push   %ebx
     814:	83 ec 14             	sub    $0x14,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     817:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
     81e:	e8 9d 0d 00 00       	call   15c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     823:	31 d2                	xor    %edx,%edx
     825:	89 54 24 04          	mov    %edx,0x4(%esp)
  cmd = malloc(sizeof(*cmd));
     829:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     82b:	b8 0c 00 00 00       	mov    $0xc,%eax
     830:	89 1c 24             	mov    %ebx,(%esp)
     833:	89 44 24 08          	mov    %eax,0x8(%esp)
     837:	e8 04 08 00 00       	call   1040 <memset>
  cmd->type = LIST;
  cmd->left = left;
     83c:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     83f:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     845:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     848:	8b 45 0c             	mov    0xc(%ebp),%eax
     84b:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     84e:	83 c4 14             	add    $0x14,%esp
     851:	89 d8                	mov    %ebx,%eax
     853:	5b                   	pop    %ebx
     854:	5d                   	pop    %ebp
     855:	c3                   	ret    
     856:	8d 76 00             	lea    0x0(%esi),%esi
     859:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000860 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	53                   	push   %ebx
     864:	83 ec 14             	sub    $0x14,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     867:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     86e:	e8 4d 0d 00 00       	call   15c0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     873:	31 d2                	xor    %edx,%edx
     875:	89 54 24 04          	mov    %edx,0x4(%esp)
  cmd = malloc(sizeof(*cmd));
     879:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     87b:	b8 08 00 00 00       	mov    $0x8,%eax
     880:	89 1c 24             	mov    %ebx,(%esp)
     883:	89 44 24 08          	mov    %eax,0x8(%esp)
     887:	e8 b4 07 00 00       	call   1040 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     88c:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     88f:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     895:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     898:	83 c4 14             	add    $0x14,%esp
     89b:	89 d8                	mov    %ebx,%eax
     89d:	5b                   	pop    %ebx
     89e:	5d                   	pop    %ebp
     89f:	c3                   	ret    

000008a0 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     8a0:	55                   	push   %ebp
     8a1:	89 e5                	mov    %esp,%ebp
     8a3:	57                   	push   %edi
     8a4:	56                   	push   %esi
     8a5:	53                   	push   %ebx
     8a6:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int ret;

  s = *ps;
     8a9:	8b 45 08             	mov    0x8(%ebp),%eax
{
     8ac:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     8af:	8b 7d 10             	mov    0x10(%ebp),%edi
  s = *ps;
     8b2:	8b 30                	mov    (%eax),%esi
  while(s < es && strchr(whitespace, *s))
     8b4:	39 de                	cmp    %ebx,%esi
     8b6:	72 0d                	jb     8c5 <gettoken+0x25>
     8b8:	eb 22                	jmp    8dc <gettoken+0x3c>
     8ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     8c0:	46                   	inc    %esi
  while(s < es && strchr(whitespace, *s))
     8c1:	39 f3                	cmp    %esi,%ebx
     8c3:	74 17                	je     8dc <gettoken+0x3c>
     8c5:	0f be 06             	movsbl (%esi),%eax
     8c8:	c7 04 24 14 1e 00 00 	movl   $0x1e14,(%esp)
     8cf:	89 44 24 04          	mov    %eax,0x4(%esp)
     8d3:	e8 88 07 00 00       	call   1060 <strchr>
     8d8:	85 c0                	test   %eax,%eax
     8da:	75 e4                	jne    8c0 <gettoken+0x20>
  if(q)
     8dc:	85 ff                	test   %edi,%edi
     8de:	74 02                	je     8e2 <gettoken+0x42>
    *q = s;
     8e0:	89 37                	mov    %esi,(%edi)
  ret = *s;
     8e2:	0f be 06             	movsbl (%esi),%eax
  switch(*s){
     8e5:	3c 29                	cmp    $0x29,%al
     8e7:	7f 57                	jg     940 <gettoken+0xa0>
     8e9:	3c 28                	cmp    $0x28,%al
     8eb:	0f 8d cb 00 00 00    	jge    9bc <gettoken+0x11c>
     8f1:	31 ff                	xor    %edi,%edi
     8f3:	84 c0                	test   %al,%al
     8f5:	0f 85 cd 00 00 00    	jne    9c8 <gettoken+0x128>
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     8fb:	8b 55 14             	mov    0x14(%ebp),%edx
     8fe:	85 d2                	test   %edx,%edx
     900:	74 05                	je     907 <gettoken+0x67>
    *eq = s;
     902:	8b 45 14             	mov    0x14(%ebp),%eax
     905:	89 30                	mov    %esi,(%eax)

  while(s < es && strchr(whitespace, *s))
     907:	39 de                	cmp    %ebx,%esi
     909:	72 0a                	jb     915 <gettoken+0x75>
     90b:	eb 1f                	jmp    92c <gettoken+0x8c>
     90d:	8d 76 00             	lea    0x0(%esi),%esi
    s++;
     910:	46                   	inc    %esi
  while(s < es && strchr(whitespace, *s))
     911:	39 f3                	cmp    %esi,%ebx
     913:	74 17                	je     92c <gettoken+0x8c>
     915:	0f be 06             	movsbl (%esi),%eax
     918:	c7 04 24 14 1e 00 00 	movl   $0x1e14,(%esp)
     91f:	89 44 24 04          	mov    %eax,0x4(%esp)
     923:	e8 38 07 00 00       	call   1060 <strchr>
     928:	85 c0                	test   %eax,%eax
     92a:	75 e4                	jne    910 <gettoken+0x70>
  *ps = s;
     92c:	8b 45 08             	mov    0x8(%ebp),%eax
     92f:	89 30                	mov    %esi,(%eax)
  return ret;
}
     931:	83 c4 1c             	add    $0x1c,%esp
     934:	89 f8                	mov    %edi,%eax
     936:	5b                   	pop    %ebx
     937:	5e                   	pop    %esi
     938:	5f                   	pop    %edi
     939:	5d                   	pop    %ebp
     93a:	c3                   	ret    
     93b:	90                   	nop
     93c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     940:	3c 3e                	cmp    $0x3e,%al
     942:	75 1c                	jne    960 <gettoken+0xc0>
    if(*s == '>'){
     944:	80 7e 01 3e          	cmpb   $0x3e,0x1(%esi)
    s++;
     948:	8d 46 01             	lea    0x1(%esi),%eax
    if(*s == '>'){
     94b:	0f 84 94 00 00 00    	je     9e5 <gettoken+0x145>
    s++;
     951:	89 c6                	mov    %eax,%esi
     953:	bf 3e 00 00 00       	mov    $0x3e,%edi
     958:	eb a1                	jmp    8fb <gettoken+0x5b>
     95a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  switch(*s){
     960:	7f 56                	jg     9b8 <gettoken+0x118>
     962:	88 c1                	mov    %al,%cl
     964:	80 e9 3b             	sub    $0x3b,%cl
     967:	80 f9 01             	cmp    $0x1,%cl
     96a:	76 50                	jbe    9bc <gettoken+0x11c>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     96c:	39 f3                	cmp    %esi,%ebx
     96e:	77 27                	ja     997 <gettoken+0xf7>
     970:	eb 5e                	jmp    9d0 <gettoken+0x130>
     972:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     978:	0f be 06             	movsbl (%esi),%eax
     97b:	c7 04 24 0c 1e 00 00 	movl   $0x1e0c,(%esp)
     982:	89 44 24 04          	mov    %eax,0x4(%esp)
     986:	e8 d5 06 00 00       	call   1060 <strchr>
     98b:	85 c0                	test   %eax,%eax
     98d:	75 1c                	jne    9ab <gettoken+0x10b>
      s++;
     98f:	46                   	inc    %esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     990:	39 f3                	cmp    %esi,%ebx
     992:	74 3c                	je     9d0 <gettoken+0x130>
     994:	0f be 06             	movsbl (%esi),%eax
     997:	89 44 24 04          	mov    %eax,0x4(%esp)
     99b:	c7 04 24 14 1e 00 00 	movl   $0x1e14,(%esp)
     9a2:	e8 b9 06 00 00       	call   1060 <strchr>
     9a7:	85 c0                	test   %eax,%eax
     9a9:	74 cd                	je     978 <gettoken+0xd8>
    ret = 'a';
     9ab:	bf 61 00 00 00       	mov    $0x61,%edi
     9b0:	e9 46 ff ff ff       	jmp    8fb <gettoken+0x5b>
     9b5:	8d 76 00             	lea    0x0(%esi),%esi
  switch(*s){
     9b8:	3c 7c                	cmp    $0x7c,%al
     9ba:	75 b0                	jne    96c <gettoken+0xcc>
  ret = *s;
     9bc:	0f be f8             	movsbl %al,%edi
    s++;
     9bf:	46                   	inc    %esi
    break;
     9c0:	e9 36 ff ff ff       	jmp    8fb <gettoken+0x5b>
     9c5:	8d 76 00             	lea    0x0(%esi),%esi
  switch(*s){
     9c8:	3c 26                	cmp    $0x26,%al
     9ca:	75 a0                	jne    96c <gettoken+0xcc>
     9cc:	eb ee                	jmp    9bc <gettoken+0x11c>
     9ce:	66 90                	xchg   %ax,%ax
  if(eq)
     9d0:	8b 45 14             	mov    0x14(%ebp),%eax
     9d3:	bf 61 00 00 00       	mov    $0x61,%edi
     9d8:	85 c0                	test   %eax,%eax
     9da:	0f 85 22 ff ff ff    	jne    902 <gettoken+0x62>
     9e0:	e9 47 ff ff ff       	jmp    92c <gettoken+0x8c>
      s++;
     9e5:	83 c6 02             	add    $0x2,%esi
      ret = '+';
     9e8:	bf 2b 00 00 00       	mov    $0x2b,%edi
     9ed:	e9 09 ff ff ff       	jmp    8fb <gettoken+0x5b>
     9f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     9f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a00 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     a00:	55                   	push   %ebp
     a01:	89 e5                	mov    %esp,%ebp
     a03:	57                   	push   %edi
     a04:	56                   	push   %esi
     a05:	53                   	push   %ebx
     a06:	83 ec 1c             	sub    $0x1c,%esp
     a09:	8b 7d 08             	mov    0x8(%ebp),%edi
     a0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     a0f:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     a11:	39 f3                	cmp    %esi,%ebx
     a13:	72 10                	jb     a25 <peek+0x25>
     a15:	eb 25                	jmp    a3c <peek+0x3c>
     a17:	89 f6                	mov    %esi,%esi
     a19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    s++;
     a20:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
     a21:	39 de                	cmp    %ebx,%esi
     a23:	74 17                	je     a3c <peek+0x3c>
     a25:	0f be 03             	movsbl (%ebx),%eax
     a28:	c7 04 24 14 1e 00 00 	movl   $0x1e14,(%esp)
     a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
     a33:	e8 28 06 00 00       	call   1060 <strchr>
     a38:	85 c0                	test   %eax,%eax
     a3a:	75 e4                	jne    a20 <peek+0x20>
  *ps = s;
     a3c:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     a3e:	31 c0                	xor    %eax,%eax
     a40:	0f be 13             	movsbl (%ebx),%edx
     a43:	84 d2                	test   %dl,%dl
     a45:	74 17                	je     a5e <peek+0x5e>
     a47:	8b 45 10             	mov    0x10(%ebp),%eax
     a4a:	89 54 24 04          	mov    %edx,0x4(%esp)
     a4e:	89 04 24             	mov    %eax,(%esp)
     a51:	e8 0a 06 00 00       	call   1060 <strchr>
     a56:	85 c0                	test   %eax,%eax
     a58:	0f 95 c0             	setne  %al
     a5b:	0f b6 c0             	movzbl %al,%eax
}
     a5e:	83 c4 1c             	add    $0x1c,%esp
     a61:	5b                   	pop    %ebx
     a62:	5e                   	pop    %esi
     a63:	5f                   	pop    %edi
     a64:	5d                   	pop    %ebp
     a65:	c3                   	ret    
     a66:	8d 76 00             	lea    0x0(%esi),%esi
     a69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000a70 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     a70:	55                   	push   %ebp
     a71:	89 e5                	mov    %esp,%ebp
     a73:	57                   	push   %edi
     a74:	56                   	push   %esi
     a75:	53                   	push   %ebx
     a76:	83 ec 3c             	sub    $0x3c,%esp
     a79:	8b 75 0c             	mov    0xc(%ebp),%esi
     a7c:	8b 5d 10             	mov    0x10(%ebp),%ebx
     a7f:	90                   	nop
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     a80:	b8 14 17 00 00       	mov    $0x1714,%eax
     a85:	89 44 24 08          	mov    %eax,0x8(%esp)
     a89:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     a8d:	89 34 24             	mov    %esi,(%esp)
     a90:	e8 6b ff ff ff       	call   a00 <peek>
     a95:	85 c0                	test   %eax,%eax
     a97:	0f 84 93 00 00 00    	je     b30 <parseredirs+0xc0>
    tok = gettoken(ps, es, 0, 0);
     a9d:	31 c0                	xor    %eax,%eax
     a9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
     aa3:	31 c0                	xor    %eax,%eax
     aa5:	89 44 24 08          	mov    %eax,0x8(%esp)
     aa9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     aad:	89 34 24             	mov    %esi,(%esp)
     ab0:	e8 eb fd ff ff       	call   8a0 <gettoken>
    if(gettoken(ps, es, &q, &eq) != 'a')
     ab5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     ab9:	89 34 24             	mov    %esi,(%esp)
    tok = gettoken(ps, es, 0, 0);
     abc:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     abe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     ac1:	89 44 24 0c          	mov    %eax,0xc(%esp)
     ac5:	8d 45 e0             	lea    -0x20(%ebp),%eax
     ac8:	89 44 24 08          	mov    %eax,0x8(%esp)
     acc:	e8 cf fd ff ff       	call   8a0 <gettoken>
     ad1:	83 f8 61             	cmp    $0x61,%eax
     ad4:	75 65                	jne    b3b <parseredirs+0xcb>
      panic("missing file for redirection");
    switch(tok){
     ad6:	83 ff 3c             	cmp    $0x3c,%edi
     ad9:	74 45                	je     b20 <parseredirs+0xb0>
     adb:	83 ff 3e             	cmp    $0x3e,%edi
     ade:	66 90                	xchg   %ax,%ax
     ae0:	74 05                	je     ae7 <parseredirs+0x77>
     ae2:	83 ff 2b             	cmp    $0x2b,%edi
     ae5:	75 99                	jne    a80 <parseredirs+0x10>
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     ae7:	ba 01 00 00 00       	mov    $0x1,%edx
     aec:	b9 01 02 00 00       	mov    $0x201,%ecx
     af1:	89 54 24 10          	mov    %edx,0x10(%esp)
     af5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     af9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     afc:	89 44 24 08          	mov    %eax,0x8(%esp)
     b00:	8b 45 e0             	mov    -0x20(%ebp),%eax
     b03:	89 44 24 04          	mov    %eax,0x4(%esp)
     b07:	8b 45 08             	mov    0x8(%ebp),%eax
     b0a:	89 04 24             	mov    %eax,(%esp)
     b0d:	e8 4e fc ff ff       	call   760 <redircmd>
     b12:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
     b15:	e9 66 ff ff ff       	jmp    a80 <parseredirs+0x10>
     b1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     b20:	31 ff                	xor    %edi,%edi
     b22:	31 c0                	xor    %eax,%eax
     b24:	89 7c 24 10          	mov    %edi,0x10(%esp)
     b28:	89 44 24 0c          	mov    %eax,0xc(%esp)
     b2c:	eb cb                	jmp    af9 <parseredirs+0x89>
     b2e:	66 90                	xchg   %ax,%ax
    }
  }
  return cmd;
}
     b30:	8b 45 08             	mov    0x8(%ebp),%eax
     b33:	83 c4 3c             	add    $0x3c,%esp
     b36:	5b                   	pop    %ebx
     b37:	5e                   	pop    %esi
     b38:	5f                   	pop    %edi
     b39:	5d                   	pop    %ebp
     b3a:	c3                   	ret    
      panic("missing file for redirection");
     b3b:	c7 04 24 f7 16 00 00 	movl   $0x16f7,(%esp)
     b42:	e8 f9 f7 ff ff       	call   340 <panic>
     b47:	89 f6                	mov    %esi,%esi
     b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000b50 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     b50:	55                   	push   %ebp
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     b51:	ba 17 17 00 00       	mov    $0x1717,%edx
{
     b56:	89 e5                	mov    %esp,%ebp
     b58:	57                   	push   %edi
     b59:	56                   	push   %esi
     b5a:	53                   	push   %ebx
     b5b:	83 ec 3c             	sub    $0x3c,%esp
     b5e:	8b 75 08             	mov    0x8(%ebp),%esi
     b61:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(peek(ps, es, "("))
     b64:	89 54 24 08          	mov    %edx,0x8(%esp)
     b68:	89 34 24             	mov    %esi,(%esp)
     b6b:	89 7c 24 04          	mov    %edi,0x4(%esp)
     b6f:	e8 8c fe ff ff       	call   a00 <peek>
     b74:	85 c0                	test   %eax,%eax
     b76:	0f 85 9c 00 00 00    	jne    c18 <parseexec+0xc8>
     b7c:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
     b7e:	e8 9d fb ff ff       	call   720 <execcmd>
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     b83:	89 7c 24 08          	mov    %edi,0x8(%esp)
     b87:	89 74 24 04          	mov    %esi,0x4(%esp)
     b8b:	89 04 24             	mov    %eax,(%esp)
  ret = execcmd();
     b8e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  ret = parseredirs(ret, ps, es);
     b91:	e8 da fe ff ff       	call   a70 <parseredirs>
     b96:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     b99:	eb 1b                	jmp    bb6 <parseexec+0x66>
     b9b:	90                   	nop
     b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     ba0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     ba3:	89 7c 24 08          	mov    %edi,0x8(%esp)
     ba7:	89 74 24 04          	mov    %esi,0x4(%esp)
     bab:	89 04 24             	mov    %eax,(%esp)
     bae:	e8 bd fe ff ff       	call   a70 <parseredirs>
     bb3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     bb6:	b8 2e 17 00 00       	mov    $0x172e,%eax
     bbb:	89 44 24 08          	mov    %eax,0x8(%esp)
     bbf:	89 7c 24 04          	mov    %edi,0x4(%esp)
     bc3:	89 34 24             	mov    %esi,(%esp)
     bc6:	e8 35 fe ff ff       	call   a00 <peek>
     bcb:	85 c0                	test   %eax,%eax
     bcd:	75 69                	jne    c38 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     bcf:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     bd2:	89 44 24 0c          	mov    %eax,0xc(%esp)
     bd6:	8d 45 e0             	lea    -0x20(%ebp),%eax
     bd9:	89 44 24 08          	mov    %eax,0x8(%esp)
     bdd:	89 7c 24 04          	mov    %edi,0x4(%esp)
     be1:	89 34 24             	mov    %esi,(%esp)
     be4:	e8 b7 fc ff ff       	call   8a0 <gettoken>
     be9:	85 c0                	test   %eax,%eax
     beb:	74 4b                	je     c38 <parseexec+0xe8>
    if(tok != 'a')
     bed:	83 f8 61             	cmp    $0x61,%eax
     bf0:	75 65                	jne    c57 <parseexec+0x107>
    cmd->argv[argc] = q;
     bf2:	8b 45 e0             	mov    -0x20(%ebp),%eax
     bf5:	8b 55 d0             	mov    -0x30(%ebp),%edx
     bf8:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     bfc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     bff:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     c03:	43                   	inc    %ebx
    if(argc >= MAXARGS)
     c04:	83 fb 0a             	cmp    $0xa,%ebx
     c07:	75 97                	jne    ba0 <parseexec+0x50>
      panic("too many args");
     c09:	c7 04 24 20 17 00 00 	movl   $0x1720,(%esp)
     c10:	e8 2b f7 ff ff       	call   340 <panic>
     c15:	8d 76 00             	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     c18:	89 7c 24 04          	mov    %edi,0x4(%esp)
     c1c:	89 34 24             	mov    %esi,(%esp)
     c1f:	e8 9c 01 00 00       	call   dc0 <parseblock>
     c24:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     c27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     c2a:	83 c4 3c             	add    $0x3c,%esp
     c2d:	5b                   	pop    %ebx
     c2e:	5e                   	pop    %esi
     c2f:	5f                   	pop    %edi
     c30:	5d                   	pop    %ebp
     c31:	c3                   	ret    
     c32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c38:	8b 45 d0             	mov    -0x30(%ebp),%eax
     c3b:	8d 04 98             	lea    (%eax,%ebx,4),%eax
  cmd->argv[argc] = 0;
     c3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  cmd->eargv[argc] = 0;
     c45:	c7 40 2c 00 00 00 00 	movl   $0x0,0x2c(%eax)
}
     c4c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     c4f:	83 c4 3c             	add    $0x3c,%esp
     c52:	5b                   	pop    %ebx
     c53:	5e                   	pop    %esi
     c54:	5f                   	pop    %edi
     c55:	5d                   	pop    %ebp
     c56:	c3                   	ret    
      panic("syntax");
     c57:	c7 04 24 19 17 00 00 	movl   $0x1719,(%esp)
     c5e:	e8 dd f6 ff ff       	call   340 <panic>
     c63:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
     c69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000c70 <parsepipe>:
{
     c70:	55                   	push   %ebp
     c71:	89 e5                	mov    %esp,%ebp
     c73:	83 ec 28             	sub    $0x28,%esp
     c76:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     c79:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c7c:	89 75 f8             	mov    %esi,-0x8(%ebp)
     c7f:	8b 75 0c             	mov    0xc(%ebp),%esi
     c82:	89 7d fc             	mov    %edi,-0x4(%ebp)
  cmd = parseexec(ps, es);
     c85:	89 1c 24             	mov    %ebx,(%esp)
     c88:	89 74 24 04          	mov    %esi,0x4(%esp)
     c8c:	e8 bf fe ff ff       	call   b50 <parseexec>
  if(peek(ps, es, "|")){
     c91:	b9 33 17 00 00       	mov    $0x1733,%ecx
     c96:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     c9a:	89 74 24 04          	mov    %esi,0x4(%esp)
     c9e:	89 1c 24             	mov    %ebx,(%esp)
  cmd = parseexec(ps, es);
     ca1:	89 c7                	mov    %eax,%edi
  if(peek(ps, es, "|")){
     ca3:	e8 58 fd ff ff       	call   a00 <peek>
     ca8:	85 c0                	test   %eax,%eax
     caa:	75 14                	jne    cc0 <parsepipe+0x50>
}
     cac:	89 f8                	mov    %edi,%eax
     cae:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     cb1:	8b 75 f8             	mov    -0x8(%ebp),%esi
     cb4:	8b 7d fc             	mov    -0x4(%ebp),%edi
     cb7:	89 ec                	mov    %ebp,%esp
     cb9:	5d                   	pop    %ebp
     cba:	c3                   	ret    
     cbb:	90                   	nop
     cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    gettoken(ps, es, 0, 0);
     cc0:	31 d2                	xor    %edx,%edx
     cc2:	31 c0                	xor    %eax,%eax
     cc4:	89 54 24 08          	mov    %edx,0x8(%esp)
     cc8:	89 74 24 04          	mov    %esi,0x4(%esp)
     ccc:	89 1c 24             	mov    %ebx,(%esp)
     ccf:	89 44 24 0c          	mov    %eax,0xc(%esp)
     cd3:	e8 c8 fb ff ff       	call   8a0 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     cd8:	89 74 24 04          	mov    %esi,0x4(%esp)
     cdc:	89 1c 24             	mov    %ebx,(%esp)
     cdf:	e8 8c ff ff ff       	call   c70 <parsepipe>
}
     ce4:	8b 5d f4             	mov    -0xc(%ebp),%ebx
    cmd = pipecmd(cmd, parsepipe(ps, es));
     ce7:	89 7d 08             	mov    %edi,0x8(%ebp)
}
     cea:	8b 75 f8             	mov    -0x8(%ebp),%esi
     ced:	8b 7d fc             	mov    -0x4(%ebp),%edi
    cmd = pipecmd(cmd, parsepipe(ps, es));
     cf0:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     cf3:	89 ec                	mov    %ebp,%esp
     cf5:	5d                   	pop    %ebp
    cmd = pipecmd(cmd, parsepipe(ps, es));
     cf6:	e9 c5 fa ff ff       	jmp    7c0 <pipecmd>
     cfb:	90                   	nop
     cfc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000d00 <parseline>:
{
     d00:	55                   	push   %ebp
     d01:	89 e5                	mov    %esp,%ebp
     d03:	57                   	push   %edi
     d04:	56                   	push   %esi
     d05:	53                   	push   %ebx
     d06:	83 ec 1c             	sub    $0x1c,%esp
     d09:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d0c:	8b 75 0c             	mov    0xc(%ebp),%esi
  cmd = parsepipe(ps, es);
     d0f:	89 1c 24             	mov    %ebx,(%esp)
     d12:	89 74 24 04          	mov    %esi,0x4(%esp)
     d16:	e8 55 ff ff ff       	call   c70 <parsepipe>
     d1b:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     d1d:	eb 23                	jmp    d42 <parseline+0x42>
     d1f:	90                   	nop
    gettoken(ps, es, 0, 0);
     d20:	31 c0                	xor    %eax,%eax
     d22:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d26:	31 c0                	xor    %eax,%eax
     d28:	89 44 24 08          	mov    %eax,0x8(%esp)
     d2c:	89 74 24 04          	mov    %esi,0x4(%esp)
     d30:	89 1c 24             	mov    %ebx,(%esp)
     d33:	e8 68 fb ff ff       	call   8a0 <gettoken>
    cmd = backcmd(cmd);
     d38:	89 3c 24             	mov    %edi,(%esp)
     d3b:	e8 20 fb ff ff       	call   860 <backcmd>
     d40:	89 c7                	mov    %eax,%edi
  while(peek(ps, es, "&")){
     d42:	b8 35 17 00 00       	mov    $0x1735,%eax
     d47:	89 44 24 08          	mov    %eax,0x8(%esp)
     d4b:	89 74 24 04          	mov    %esi,0x4(%esp)
     d4f:	89 1c 24             	mov    %ebx,(%esp)
     d52:	e8 a9 fc ff ff       	call   a00 <peek>
     d57:	85 c0                	test   %eax,%eax
     d59:	75 c5                	jne    d20 <parseline+0x20>
  if(peek(ps, es, ";")){
     d5b:	b9 31 17 00 00       	mov    $0x1731,%ecx
     d60:	89 4c 24 08          	mov    %ecx,0x8(%esp)
     d64:	89 74 24 04          	mov    %esi,0x4(%esp)
     d68:	89 1c 24             	mov    %ebx,(%esp)
     d6b:	e8 90 fc ff ff       	call   a00 <peek>
     d70:	85 c0                	test   %eax,%eax
     d72:	75 0c                	jne    d80 <parseline+0x80>
}
     d74:	83 c4 1c             	add    $0x1c,%esp
     d77:	89 f8                	mov    %edi,%eax
     d79:	5b                   	pop    %ebx
     d7a:	5e                   	pop    %esi
     d7b:	5f                   	pop    %edi
     d7c:	5d                   	pop    %ebp
     d7d:	c3                   	ret    
     d7e:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     d80:	31 d2                	xor    %edx,%edx
     d82:	31 c0                	xor    %eax,%eax
     d84:	89 54 24 08          	mov    %edx,0x8(%esp)
     d88:	89 74 24 04          	mov    %esi,0x4(%esp)
     d8c:	89 1c 24             	mov    %ebx,(%esp)
     d8f:	89 44 24 0c          	mov    %eax,0xc(%esp)
     d93:	e8 08 fb ff ff       	call   8a0 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     d98:	89 74 24 04          	mov    %esi,0x4(%esp)
     d9c:	89 1c 24             	mov    %ebx,(%esp)
     d9f:	e8 5c ff ff ff       	call   d00 <parseline>
     da4:	89 7d 08             	mov    %edi,0x8(%ebp)
     da7:	89 45 0c             	mov    %eax,0xc(%ebp)
}
     daa:	83 c4 1c             	add    $0x1c,%esp
     dad:	5b                   	pop    %ebx
     dae:	5e                   	pop    %esi
     daf:	5f                   	pop    %edi
     db0:	5d                   	pop    %ebp
    cmd = listcmd(cmd, parseline(ps, es));
     db1:	e9 5a fa ff ff       	jmp    810 <listcmd>
     db6:	8d 76 00             	lea    0x0(%esi),%esi
     db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000dc0 <parseblock>:
{
     dc0:	55                   	push   %ebp
  if(!peek(ps, es, "("))
     dc1:	b8 17 17 00 00       	mov    $0x1717,%eax
{
     dc6:	89 e5                	mov    %esp,%ebp
     dc8:	83 ec 28             	sub    $0x28,%esp
     dcb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
     dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
     dd1:	89 75 f8             	mov    %esi,-0x8(%ebp)
     dd4:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     dd7:	89 44 24 08          	mov    %eax,0x8(%esp)
{
     ddb:	89 7d fc             	mov    %edi,-0x4(%ebp)
  if(!peek(ps, es, "("))
     dde:	89 1c 24             	mov    %ebx,(%esp)
     de1:	89 74 24 04          	mov    %esi,0x4(%esp)
     de5:	e8 16 fc ff ff       	call   a00 <peek>
     dea:	85 c0                	test   %eax,%eax
     dec:	74 74                	je     e62 <parseblock+0xa2>
  gettoken(ps, es, 0, 0);
     dee:	31 c9                	xor    %ecx,%ecx
     df0:	31 ff                	xor    %edi,%edi
     df2:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
     df6:	89 7c 24 08          	mov    %edi,0x8(%esp)
     dfa:	89 74 24 04          	mov    %esi,0x4(%esp)
     dfe:	89 1c 24             	mov    %ebx,(%esp)
     e01:	e8 9a fa ff ff       	call   8a0 <gettoken>
  cmd = parseline(ps, es);
     e06:	89 74 24 04          	mov    %esi,0x4(%esp)
     e0a:	89 1c 24             	mov    %ebx,(%esp)
     e0d:	e8 ee fe ff ff       	call   d00 <parseline>
  if(!peek(ps, es, ")"))
     e12:	89 74 24 04          	mov    %esi,0x4(%esp)
     e16:	89 1c 24             	mov    %ebx,(%esp)
  cmd = parseline(ps, es);
     e19:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     e1b:	b8 53 17 00 00       	mov    $0x1753,%eax
     e20:	89 44 24 08          	mov    %eax,0x8(%esp)
     e24:	e8 d7 fb ff ff       	call   a00 <peek>
     e29:	85 c0                	test   %eax,%eax
     e2b:	74 41                	je     e6e <parseblock+0xae>
  gettoken(ps, es, 0, 0);
     e2d:	31 d2                	xor    %edx,%edx
     e2f:	31 c0                	xor    %eax,%eax
     e31:	89 54 24 08          	mov    %edx,0x8(%esp)
     e35:	89 74 24 04          	mov    %esi,0x4(%esp)
     e39:	89 1c 24             	mov    %ebx,(%esp)
     e3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
     e40:	e8 5b fa ff ff       	call   8a0 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     e45:	89 74 24 08          	mov    %esi,0x8(%esp)
     e49:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     e4d:	89 3c 24             	mov    %edi,(%esp)
     e50:	e8 1b fc ff ff       	call   a70 <parseredirs>
}
     e55:	8b 5d f4             	mov    -0xc(%ebp),%ebx
     e58:	8b 75 f8             	mov    -0x8(%ebp),%esi
     e5b:	8b 7d fc             	mov    -0x4(%ebp),%edi
     e5e:	89 ec                	mov    %ebp,%esp
     e60:	5d                   	pop    %ebp
     e61:	c3                   	ret    
    panic("parseblock");
     e62:	c7 04 24 37 17 00 00 	movl   $0x1737,(%esp)
     e69:	e8 d2 f4 ff ff       	call   340 <panic>
    panic("syntax - missing )");
     e6e:	c7 04 24 42 17 00 00 	movl   $0x1742,(%esp)
     e75:	e8 c6 f4 ff ff       	call   340 <panic>
     e7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000e80 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     e80:	55                   	push   %ebp
     e81:	89 e5                	mov    %esp,%ebp
     e83:	53                   	push   %ebx
     e84:	83 ec 14             	sub    $0x14,%esp
     e87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     e8a:	85 db                	test   %ebx,%ebx
     e8c:	74 1d                	je     eab <nulterminate+0x2b>
    return 0;

  switch(cmd->type){
     e8e:	83 3b 05             	cmpl   $0x5,(%ebx)
     e91:	77 18                	ja     eab <nulterminate+0x2b>
     e93:	8b 03                	mov    (%ebx),%eax
     e95:	ff 24 85 94 17 00 00 	jmp    *0x1794(,%eax,4)
     e9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(lcmd->right);
    break;

  case BACK:
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
     ea0:	8b 43 04             	mov    0x4(%ebx),%eax
     ea3:	89 04 24             	mov    %eax,(%esp)
     ea6:	e8 d5 ff ff ff       	call   e80 <nulterminate>
    break;
  }
  return cmd;
}
     eab:	83 c4 14             	add    $0x14,%esp
     eae:	89 d8                	mov    %ebx,%eax
     eb0:	5b                   	pop    %ebx
     eb1:	5d                   	pop    %ebp
     eb2:	c3                   	ret    
     eb3:	90                   	nop
     eb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(lcmd->left);
     eb8:	8b 43 04             	mov    0x4(%ebx),%eax
     ebb:	89 04 24             	mov    %eax,(%esp)
     ebe:	e8 bd ff ff ff       	call   e80 <nulterminate>
    nulterminate(lcmd->right);
     ec3:	8b 43 08             	mov    0x8(%ebx),%eax
     ec6:	89 04 24             	mov    %eax,(%esp)
     ec9:	e8 b2 ff ff ff       	call   e80 <nulterminate>
}
     ece:	83 c4 14             	add    $0x14,%esp
     ed1:	89 d8                	mov    %ebx,%eax
     ed3:	5b                   	pop    %ebx
     ed4:	5d                   	pop    %ebp
     ed5:	c3                   	ret    
     ed6:	8d 76 00             	lea    0x0(%esi),%esi
     ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    for(i=0; ecmd->argv[i]; i++)
     ee0:	8b 4b 04             	mov    0x4(%ebx),%ecx
     ee3:	8d 43 08             	lea    0x8(%ebx),%eax
     ee6:	85 c9                	test   %ecx,%ecx
     ee8:	74 c1                	je     eab <nulterminate+0x2b>
     eea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     ef0:	8b 50 24             	mov    0x24(%eax),%edx
     ef3:	83 c0 04             	add    $0x4,%eax
     ef6:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     ef9:	8b 50 fc             	mov    -0x4(%eax),%edx
     efc:	85 d2                	test   %edx,%edx
     efe:	75 f0                	jne    ef0 <nulterminate+0x70>
}
     f00:	83 c4 14             	add    $0x14,%esp
     f03:	89 d8                	mov    %ebx,%eax
     f05:	5b                   	pop    %ebx
     f06:	5d                   	pop    %ebp
     f07:	c3                   	ret    
     f08:	90                   	nop
     f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    nulterminate(rcmd->cmd);
     f10:	8b 43 04             	mov    0x4(%ebx),%eax
     f13:	89 04 24             	mov    %eax,(%esp)
     f16:	e8 65 ff ff ff       	call   e80 <nulterminate>
    *rcmd->efile = 0;
     f1b:	8b 43 0c             	mov    0xc(%ebx),%eax
     f1e:	c6 00 00             	movb   $0x0,(%eax)
}
     f21:	83 c4 14             	add    $0x14,%esp
     f24:	89 d8                	mov    %ebx,%eax
     f26:	5b                   	pop    %ebx
     f27:	5d                   	pop    %ebp
     f28:	c3                   	ret    
     f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000f30 <parsecmd>:
{
     f30:	55                   	push   %ebp
     f31:	89 e5                	mov    %esp,%ebp
     f33:	56                   	push   %esi
     f34:	53                   	push   %ebx
     f35:	83 ec 10             	sub    $0x10,%esp
  es = s + strlen(s);
     f38:	8b 5d 08             	mov    0x8(%ebp),%ebx
     f3b:	89 1c 24             	mov    %ebx,(%esp)
     f3e:	e8 cd 00 00 00       	call   1010 <strlen>
     f43:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     f45:	8d 45 08             	lea    0x8(%ebp),%eax
     f48:	89 5c 24 04          	mov    %ebx,0x4(%esp)
     f4c:	89 04 24             	mov    %eax,(%esp)
     f4f:	e8 ac fd ff ff       	call   d00 <parseline>
  peek(&s, es, "");
     f54:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  cmd = parseline(&s, es);
     f58:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     f5a:	b8 c1 16 00 00       	mov    $0x16c1,%eax
     f5f:	89 44 24 08          	mov    %eax,0x8(%esp)
     f63:	8d 45 08             	lea    0x8(%ebp),%eax
     f66:	89 04 24             	mov    %eax,(%esp)
     f69:	e8 92 fa ff ff       	call   a00 <peek>
  if(s != es){
     f6e:	8b 45 08             	mov    0x8(%ebp),%eax
     f71:	39 d8                	cmp    %ebx,%eax
     f73:	75 11                	jne    f86 <parsecmd+0x56>
  nulterminate(cmd);
     f75:	89 34 24             	mov    %esi,(%esp)
     f78:	e8 03 ff ff ff       	call   e80 <nulterminate>
}
     f7d:	83 c4 10             	add    $0x10,%esp
     f80:	89 f0                	mov    %esi,%eax
     f82:	5b                   	pop    %ebx
     f83:	5e                   	pop    %esi
     f84:	5d                   	pop    %ebp
     f85:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     f86:	89 44 24 08          	mov    %eax,0x8(%esp)
     f8a:	c7 44 24 04 55 17 00 	movl   $0x1755,0x4(%esp)
     f91:	00 
     f92:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
     f99:	e8 92 03 00 00       	call   1330 <printf>
    panic("syntax");
     f9e:	c7 04 24 19 17 00 00 	movl   $0x1719,(%esp)
     fa5:	e8 96 f3 ff ff       	call   340 <panic>
     faa:	66 90                	xchg   %ax,%ax
     fac:	66 90                	xchg   %ax,%ax
     fae:	66 90                	xchg   %ax,%ax

00000fb0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     fb0:	55                   	push   %ebp
     fb1:	89 e5                	mov    %esp,%ebp
     fb3:	8b 45 08             	mov    0x8(%ebp),%eax
     fb6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
     fb9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     fba:	89 c2                	mov    %eax,%edx
     fbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     fc0:	41                   	inc    %ecx
     fc1:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
     fc5:	42                   	inc    %edx
     fc6:	84 db                	test   %bl,%bl
     fc8:	88 5a ff             	mov    %bl,-0x1(%edx)
     fcb:	75 f3                	jne    fc0 <strcpy+0x10>
    ;
  return os;
}
     fcd:	5b                   	pop    %ebx
     fce:	5d                   	pop    %ebp
     fcf:	c3                   	ret    

00000fd0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     fd0:	55                   	push   %ebp
     fd1:	89 e5                	mov    %esp,%ebp
     fd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
     fd6:	53                   	push   %ebx
     fd7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(*p && *p == *q)
     fda:	0f b6 01             	movzbl (%ecx),%eax
     fdd:	0f b6 13             	movzbl (%ebx),%edx
     fe0:	84 c0                	test   %al,%al
     fe2:	75 18                	jne    ffc <strcmp+0x2c>
     fe4:	eb 22                	jmp    1008 <strcmp+0x38>
     fe6:	8d 76 00             	lea    0x0(%esi),%esi
     fe9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
     ff0:	41                   	inc    %ecx
  while(*p && *p == *q)
     ff1:	0f b6 01             	movzbl (%ecx),%eax
    p++, q++;
     ff4:	43                   	inc    %ebx
     ff5:	0f b6 13             	movzbl (%ebx),%edx
  while(*p && *p == *q)
     ff8:	84 c0                	test   %al,%al
     ffa:	74 0c                	je     1008 <strcmp+0x38>
     ffc:	38 d0                	cmp    %dl,%al
     ffe:	74 f0                	je     ff0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
}
    1000:	5b                   	pop    %ebx
  return (uchar)*p - (uchar)*q;
    1001:	29 d0                	sub    %edx,%eax
}
    1003:	5d                   	pop    %ebp
    1004:	c3                   	ret    
    1005:	8d 76 00             	lea    0x0(%esi),%esi
    1008:	5b                   	pop    %ebx
    1009:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
    100b:	29 d0                	sub    %edx,%eax
}
    100d:	5d                   	pop    %ebp
    100e:	c3                   	ret    
    100f:	90                   	nop

00001010 <strlen>:

uint
strlen(const char *s)
{
    1010:	55                   	push   %ebp
    1011:	89 e5                	mov    %esp,%ebp
    1013:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
    1016:	80 39 00             	cmpb   $0x0,(%ecx)
    1019:	74 15                	je     1030 <strlen+0x20>
    101b:	31 d2                	xor    %edx,%edx
    101d:	8d 76 00             	lea    0x0(%esi),%esi
    1020:	42                   	inc    %edx
    1021:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
    1025:	89 d0                	mov    %edx,%eax
    1027:	75 f7                	jne    1020 <strlen+0x10>
    ;
  return n;
}
    1029:	5d                   	pop    %ebp
    102a:	c3                   	ret    
    102b:	90                   	nop
    102c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(n = 0; s[n]; n++)
    1030:	31 c0                	xor    %eax,%eax
}
    1032:	5d                   	pop    %ebp
    1033:	c3                   	ret    
    1034:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    103a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00001040 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1040:	55                   	push   %ebp
    1041:	89 e5                	mov    %esp,%ebp
    1043:	8b 55 08             	mov    0x8(%ebp),%edx
    1046:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    1047:	8b 4d 10             	mov    0x10(%ebp),%ecx
    104a:	8b 45 0c             	mov    0xc(%ebp),%eax
    104d:	89 d7                	mov    %edx,%edi
    104f:	fc                   	cld    
    1050:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    1052:	5f                   	pop    %edi
    1053:	89 d0                	mov    %edx,%eax
    1055:	5d                   	pop    %ebp
    1056:	c3                   	ret    
    1057:	89 f6                	mov    %esi,%esi
    1059:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001060 <strchr>:

char*
strchr(const char *s, char c)
{
    1060:	55                   	push   %ebp
    1061:	89 e5                	mov    %esp,%ebp
    1063:	8b 45 08             	mov    0x8(%ebp),%eax
    1066:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    106a:	0f b6 10             	movzbl (%eax),%edx
    106d:	84 d2                	test   %dl,%dl
    106f:	74 1b                	je     108c <strchr+0x2c>
    if(*s == c)
    1071:	38 d1                	cmp    %dl,%cl
    1073:	75 0f                	jne    1084 <strchr+0x24>
    1075:	eb 17                	jmp    108e <strchr+0x2e>
    1077:	89 f6                	mov    %esi,%esi
    1079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    1080:	38 ca                	cmp    %cl,%dl
    1082:	74 0a                	je     108e <strchr+0x2e>
  for(; *s; s++)
    1084:	40                   	inc    %eax
    1085:	0f b6 10             	movzbl (%eax),%edx
    1088:	84 d2                	test   %dl,%dl
    108a:	75 f4                	jne    1080 <strchr+0x20>
      return (char*)s;
  return 0;
    108c:	31 c0                	xor    %eax,%eax
}
    108e:	5d                   	pop    %ebp
    108f:	c3                   	ret    

00001090 <gets>:

char*
gets(char *buf, int max)
{
    1090:	55                   	push   %ebp
    1091:	89 e5                	mov    %esp,%ebp
    1093:	57                   	push   %edi
    1094:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    1095:	31 f6                	xor    %esi,%esi
{
    1097:	53                   	push   %ebx
    1098:	83 ec 3c             	sub    $0x3c,%esp
    109b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    cc = read(0, &c, 1);
    109e:	8d 7d e7             	lea    -0x19(%ebp),%edi
  for(i=0; i+1 < max; ){
    10a1:	eb 32                	jmp    10d5 <gets+0x45>
    10a3:	90                   	nop
    10a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cc = read(0, &c, 1);
    10a8:	ba 01 00 00 00       	mov    $0x1,%edx
    10ad:	89 54 24 08          	mov    %edx,0x8(%esp)
    10b1:	89 7c 24 04          	mov    %edi,0x4(%esp)
    10b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    10bc:	e8 2f 01 00 00       	call   11f0 <read>
    if(cc < 1)
    10c1:	85 c0                	test   %eax,%eax
    10c3:	7e 19                	jle    10de <gets+0x4e>
      break;
    buf[i++] = c;
    10c5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    10c9:	43                   	inc    %ebx
    10ca:	88 43 ff             	mov    %al,-0x1(%ebx)
    if(c == '\n' || c == '\r')
    10cd:	3c 0a                	cmp    $0xa,%al
    10cf:	74 1f                	je     10f0 <gets+0x60>
    10d1:	3c 0d                	cmp    $0xd,%al
    10d3:	74 1b                	je     10f0 <gets+0x60>
  for(i=0; i+1 < max; ){
    10d5:	46                   	inc    %esi
    10d6:	3b 75 0c             	cmp    0xc(%ebp),%esi
    10d9:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    10dc:	7c ca                	jl     10a8 <gets+0x18>
      break;
  }
  buf[i] = '\0';
    10de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
    10e1:	c6 00 00             	movb   $0x0,(%eax)
  return buf;
}
    10e4:	8b 45 08             	mov    0x8(%ebp),%eax
    10e7:	83 c4 3c             	add    $0x3c,%esp
    10ea:	5b                   	pop    %ebx
    10eb:	5e                   	pop    %esi
    10ec:	5f                   	pop    %edi
    10ed:	5d                   	pop    %ebp
    10ee:	c3                   	ret    
    10ef:	90                   	nop
    10f0:	8b 45 08             	mov    0x8(%ebp),%eax
    10f3:	01 c6                	add    %eax,%esi
    10f5:	89 75 d4             	mov    %esi,-0x2c(%ebp)
    10f8:	eb e4                	jmp    10de <gets+0x4e>
    10fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00001100 <stat>:

int
stat(const char *n, struct stat *st)
{
    1100:	55                   	push   %ebp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1101:	31 c0                	xor    %eax,%eax
{
    1103:	89 e5                	mov    %esp,%ebp
    1105:	83 ec 18             	sub    $0x18,%esp
  fd = open(n, O_RDONLY);
    1108:	89 44 24 04          	mov    %eax,0x4(%esp)
    110c:	8b 45 08             	mov    0x8(%ebp),%eax
{
    110f:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    1112:	89 75 fc             	mov    %esi,-0x4(%ebp)
  fd = open(n, O_RDONLY);
    1115:	89 04 24             	mov    %eax,(%esp)
    1118:	e8 fb 00 00 00       	call   1218 <open>
  if(fd < 0)
    111d:	85 c0                	test   %eax,%eax
    111f:	78 2f                	js     1150 <stat+0x50>
    1121:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    1123:	8b 45 0c             	mov    0xc(%ebp),%eax
    1126:	89 1c 24             	mov    %ebx,(%esp)
    1129:	89 44 24 04          	mov    %eax,0x4(%esp)
    112d:	e8 fe 00 00 00       	call   1230 <fstat>
  close(fd);
    1132:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
    1135:	89 c6                	mov    %eax,%esi
  close(fd);
    1137:	e8 c4 00 00 00       	call   1200 <close>
  return r;
}
    113c:	89 f0                	mov    %esi,%eax
    113e:	8b 5d f8             	mov    -0x8(%ebp),%ebx
    1141:	8b 75 fc             	mov    -0x4(%ebp),%esi
    1144:	89 ec                	mov    %ebp,%esp
    1146:	5d                   	pop    %ebp
    1147:	c3                   	ret    
    1148:	90                   	nop
    1149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
    1150:	be ff ff ff ff       	mov    $0xffffffff,%esi
    1155:	eb e5                	jmp    113c <stat+0x3c>
    1157:	89 f6                	mov    %esi,%esi
    1159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00001160 <atoi>:

int
atoi(const char *s)
{
    1160:	55                   	push   %ebp
    1161:	89 e5                	mov    %esp,%ebp
    1163:	8b 4d 08             	mov    0x8(%ebp),%ecx
    1166:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    1167:	0f be 11             	movsbl (%ecx),%edx
    116a:	88 d0                	mov    %dl,%al
    116c:	2c 30                	sub    $0x30,%al
    116e:	3c 09                	cmp    $0x9,%al
  n = 0;
    1170:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
    1175:	77 1e                	ja     1195 <atoi+0x35>
    1177:	89 f6                	mov    %esi,%esi
    1179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
    1180:	41                   	inc    %ecx
    1181:	8d 04 80             	lea    (%eax,%eax,4),%eax
    1184:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
    1188:	0f be 11             	movsbl (%ecx),%edx
    118b:	88 d3                	mov    %dl,%bl
    118d:	80 eb 30             	sub    $0x30,%bl
    1190:	80 fb 09             	cmp    $0x9,%bl
    1193:	76 eb                	jbe    1180 <atoi+0x20>
  return n;
}
    1195:	5b                   	pop    %ebx
    1196:	5d                   	pop    %ebp
    1197:	c3                   	ret    
    1198:	90                   	nop
    1199:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000011a0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    11a0:	55                   	push   %ebp
    11a1:	89 e5                	mov    %esp,%ebp
    11a3:	56                   	push   %esi
    11a4:	8b 45 08             	mov    0x8(%ebp),%eax
    11a7:	53                   	push   %ebx
    11a8:	8b 5d 10             	mov    0x10(%ebp),%ebx
    11ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    11ae:	85 db                	test   %ebx,%ebx
    11b0:	7e 1a                	jle    11cc <memmove+0x2c>
    11b2:	31 d2                	xor    %edx,%edx
    11b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    11ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi
    *dst++ = *src++;
    11c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
    11c4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    11c7:	42                   	inc    %edx
  while(n-- > 0)
    11c8:	39 d3                	cmp    %edx,%ebx
    11ca:	75 f4                	jne    11c0 <memmove+0x20>
  return vdst;
}
    11cc:	5b                   	pop    %ebx
    11cd:	5e                   	pop    %esi
    11ce:	5d                   	pop    %ebp
    11cf:	c3                   	ret    

000011d0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    11d0:	b8 01 00 00 00       	mov    $0x1,%eax
    11d5:	cd 40                	int    $0x40
    11d7:	c3                   	ret    

000011d8 <exit>:
SYSCALL(exit)
    11d8:	b8 02 00 00 00       	mov    $0x2,%eax
    11dd:	cd 40                	int    $0x40
    11df:	c3                   	ret    

000011e0 <wait>:
SYSCALL(wait)
    11e0:	b8 03 00 00 00       	mov    $0x3,%eax
    11e5:	cd 40                	int    $0x40
    11e7:	c3                   	ret    

000011e8 <pipe>:
SYSCALL(pipe)
    11e8:	b8 04 00 00 00       	mov    $0x4,%eax
    11ed:	cd 40                	int    $0x40
    11ef:	c3                   	ret    

000011f0 <read>:
SYSCALL(read)
    11f0:	b8 05 00 00 00       	mov    $0x5,%eax
    11f5:	cd 40                	int    $0x40
    11f7:	c3                   	ret    

000011f8 <write>:
SYSCALL(write)
    11f8:	b8 10 00 00 00       	mov    $0x10,%eax
    11fd:	cd 40                	int    $0x40
    11ff:	c3                   	ret    

00001200 <close>:
SYSCALL(close)
    1200:	b8 15 00 00 00       	mov    $0x15,%eax
    1205:	cd 40                	int    $0x40
    1207:	c3                   	ret    

00001208 <kill>:
SYSCALL(kill)
    1208:	b8 06 00 00 00       	mov    $0x6,%eax
    120d:	cd 40                	int    $0x40
    120f:	c3                   	ret    

00001210 <exec>:
SYSCALL(exec)
    1210:	b8 07 00 00 00       	mov    $0x7,%eax
    1215:	cd 40                	int    $0x40
    1217:	c3                   	ret    

00001218 <open>:
SYSCALL(open)
    1218:	b8 0f 00 00 00       	mov    $0xf,%eax
    121d:	cd 40                	int    $0x40
    121f:	c3                   	ret    

00001220 <mknod>:
SYSCALL(mknod)
    1220:	b8 11 00 00 00       	mov    $0x11,%eax
    1225:	cd 40                	int    $0x40
    1227:	c3                   	ret    

00001228 <unlink>:
SYSCALL(unlink)
    1228:	b8 12 00 00 00       	mov    $0x12,%eax
    122d:	cd 40                	int    $0x40
    122f:	c3                   	ret    

00001230 <fstat>:
SYSCALL(fstat)
    1230:	b8 08 00 00 00       	mov    $0x8,%eax
    1235:	cd 40                	int    $0x40
    1237:	c3                   	ret    

00001238 <link>:
SYSCALL(link)
    1238:	b8 13 00 00 00       	mov    $0x13,%eax
    123d:	cd 40                	int    $0x40
    123f:	c3                   	ret    

00001240 <mkdir>:
SYSCALL(mkdir)
    1240:	b8 14 00 00 00       	mov    $0x14,%eax
    1245:	cd 40                	int    $0x40
    1247:	c3                   	ret    

00001248 <chdir>:
SYSCALL(chdir)
    1248:	b8 09 00 00 00       	mov    $0x9,%eax
    124d:	cd 40                	int    $0x40
    124f:	c3                   	ret    

00001250 <dup>:
SYSCALL(dup)
    1250:	b8 0a 00 00 00       	mov    $0xa,%eax
    1255:	cd 40                	int    $0x40
    1257:	c3                   	ret    

00001258 <getpid>:
SYSCALL(getpid)
    1258:	b8 0b 00 00 00       	mov    $0xb,%eax
    125d:	cd 40                	int    $0x40
    125f:	c3                   	ret    

00001260 <sbrk>:
SYSCALL(sbrk)
    1260:	b8 0c 00 00 00       	mov    $0xc,%eax
    1265:	cd 40                	int    $0x40
    1267:	c3                   	ret    

00001268 <sleep>:
SYSCALL(sleep)
    1268:	b8 0d 00 00 00       	mov    $0xd,%eax
    126d:	cd 40                	int    $0x40
    126f:	c3                   	ret    

00001270 <uptime>:
SYSCALL(uptime)
    1270:	b8 0e 00 00 00       	mov    $0xe,%eax
    1275:	cd 40                	int    $0x40
    1277:	c3                   	ret    

00001278 <detach>:
SYSCALL(detach)
    1278:	b8 16 00 00 00       	mov    $0x16,%eax
    127d:	cd 40                	int    $0x40
    127f:	c3                   	ret    

00001280 <policy>:
SYSCALL(policy)
    1280:	b8 17 00 00 00       	mov    $0x17,%eax
    1285:	cd 40                	int    $0x40
    1287:	c3                   	ret    

00001288 <priority>:
    1288:	b8 18 00 00 00       	mov    $0x18,%eax
    128d:	cd 40                	int    $0x40
    128f:	c3                   	ret    

00001290 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1290:	55                   	push   %ebp
    1291:	89 e5                	mov    %esp,%ebp
    1293:	57                   	push   %edi
    1294:	56                   	push   %esi
    1295:	53                   	push   %ebx
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    1296:	89 d3                	mov    %edx,%ebx
    1298:	c1 eb 1f             	shr    $0x1f,%ebx
{
    129b:	83 ec 4c             	sub    $0x4c,%esp
  if(sgn && xx < 0){
    129e:	84 db                	test   %bl,%bl
{
    12a0:	89 45 c0             	mov    %eax,-0x40(%ebp)
    12a3:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
    12a5:	74 79                	je     1320 <printint+0x90>
    12a7:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    12ab:	74 73                	je     1320 <printint+0x90>
    neg = 1;
    x = -xx;
    12ad:	f7 d8                	neg    %eax
    neg = 1;
    12af:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    12b6:	31 f6                	xor    %esi,%esi
    12b8:	8d 5d d7             	lea    -0x29(%ebp),%ebx
    12bb:	eb 05                	jmp    12c2 <printint+0x32>
    12bd:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    12c0:	89 fe                	mov    %edi,%esi
    12c2:	31 d2                	xor    %edx,%edx
    12c4:	f7 f1                	div    %ecx
    12c6:	8d 7e 01             	lea    0x1(%esi),%edi
    12c9:	0f b6 92 b4 17 00 00 	movzbl 0x17b4(%edx),%edx
  }while((x /= base) != 0);
    12d0:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
    12d2:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
    12d5:	75 e9                	jne    12c0 <printint+0x30>
  if(neg)
    12d7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    12da:	85 d2                	test   %edx,%edx
    12dc:	74 08                	je     12e6 <printint+0x56>
    buf[i++] = '-';
    12de:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
    12e3:	8d 7e 02             	lea    0x2(%esi),%edi
    12e6:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
    12ea:	8b 7d c0             	mov    -0x40(%ebp),%edi
    12ed:	8d 76 00             	lea    0x0(%esi),%esi
    12f0:	0f b6 06             	movzbl (%esi),%eax
    12f3:	4e                   	dec    %esi
  write(fd, &c, 1);
    12f4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
    12f8:	89 3c 24             	mov    %edi,(%esp)
    12fb:	88 45 d7             	mov    %al,-0x29(%ebp)
    12fe:	b8 01 00 00 00       	mov    $0x1,%eax
    1303:	89 44 24 08          	mov    %eax,0x8(%esp)
    1307:	e8 ec fe ff ff       	call   11f8 <write>

  while(--i >= 0)
    130c:	39 de                	cmp    %ebx,%esi
    130e:	75 e0                	jne    12f0 <printint+0x60>
    putc(fd, buf[i]);
}
    1310:	83 c4 4c             	add    $0x4c,%esp
    1313:	5b                   	pop    %ebx
    1314:	5e                   	pop    %esi
    1315:	5f                   	pop    %edi
    1316:	5d                   	pop    %ebp
    1317:	c3                   	ret    
    1318:	90                   	nop
    1319:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1320:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
    1327:	eb 8d                	jmp    12b6 <printint+0x26>
    1329:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00001330 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    1330:	55                   	push   %ebp
    1331:	89 e5                	mov    %esp,%ebp
    1333:	57                   	push   %edi
    1334:	56                   	push   %esi
    1335:	53                   	push   %ebx
    1336:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    1339:	8b 75 0c             	mov    0xc(%ebp),%esi
    133c:	0f b6 1e             	movzbl (%esi),%ebx
    133f:	84 db                	test   %bl,%bl
    1341:	0f 84 d1 00 00 00    	je     1418 <printf+0xe8>
  state = 0;
    1347:	31 ff                	xor    %edi,%edi
    1349:	46                   	inc    %esi
  ap = (uint*)(void*)&fmt + 1;
    134a:	8d 45 10             	lea    0x10(%ebp),%eax
  write(fd, &c, 1);
    134d:	89 fa                	mov    %edi,%edx
    134f:	8b 7d 08             	mov    0x8(%ebp),%edi
  ap = (uint*)(void*)&fmt + 1;
    1352:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1355:	eb 41                	jmp    1398 <printf+0x68>
    1357:	89 f6                	mov    %esi,%esi
    1359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
    1360:	83 f8 25             	cmp    $0x25,%eax
    1363:	89 55 d4             	mov    %edx,-0x2c(%ebp)
        state = '%';
    1366:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
    136b:	74 1e                	je     138b <printf+0x5b>
  write(fd, &c, 1);
    136d:	b8 01 00 00 00       	mov    $0x1,%eax
    1372:	89 44 24 08          	mov    %eax,0x8(%esp)
    1376:	8d 45 e2             	lea    -0x1e(%ebp),%eax
    1379:	89 44 24 04          	mov    %eax,0x4(%esp)
    137d:	89 3c 24             	mov    %edi,(%esp)
    1380:	88 5d e2             	mov    %bl,-0x1e(%ebp)
    1383:	e8 70 fe ff ff       	call   11f8 <write>
    1388:	8b 55 d4             	mov    -0x2c(%ebp),%edx
    138b:	46                   	inc    %esi
  for(i = 0; fmt[i]; i++){
    138c:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
    1390:	84 db                	test   %bl,%bl
    1392:	0f 84 80 00 00 00    	je     1418 <printf+0xe8>
    if(state == 0){
    1398:	85 d2                	test   %edx,%edx
    c = fmt[i] & 0xff;
    139a:	0f be cb             	movsbl %bl,%ecx
    139d:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
    13a0:	74 be                	je     1360 <printf+0x30>
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    13a2:	83 fa 25             	cmp    $0x25,%edx
    13a5:	75 e4                	jne    138b <printf+0x5b>
      if(c == 'd'){
    13a7:	83 f8 64             	cmp    $0x64,%eax
    13aa:	0f 84 f0 00 00 00    	je     14a0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    13b0:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
    13b6:	83 f9 70             	cmp    $0x70,%ecx
    13b9:	74 65                	je     1420 <printf+0xf0>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    13bb:	83 f8 73             	cmp    $0x73,%eax
    13be:	0f 84 8c 00 00 00    	je     1450 <printf+0x120>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    13c4:	83 f8 63             	cmp    $0x63,%eax
    13c7:	0f 84 13 01 00 00    	je     14e0 <printf+0x1b0>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    13cd:	83 f8 25             	cmp    $0x25,%eax
    13d0:	0f 84 e2 00 00 00    	je     14b8 <printf+0x188>
  write(fd, &c, 1);
    13d6:	b8 01 00 00 00       	mov    $0x1,%eax
    13db:	46                   	inc    %esi
    13dc:	89 44 24 08          	mov    %eax,0x8(%esp)
    13e0:	8d 45 e7             	lea    -0x19(%ebp),%eax
    13e3:	89 44 24 04          	mov    %eax,0x4(%esp)
    13e7:	89 3c 24             	mov    %edi,(%esp)
    13ea:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    13ee:	e8 05 fe ff ff       	call   11f8 <write>
    13f3:	ba 01 00 00 00       	mov    $0x1,%edx
    13f8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
    13fb:	89 54 24 08          	mov    %edx,0x8(%esp)
    13ff:	89 44 24 04          	mov    %eax,0x4(%esp)
    1403:	89 3c 24             	mov    %edi,(%esp)
    1406:	88 5d e6             	mov    %bl,-0x1a(%ebp)
    1409:	e8 ea fd ff ff       	call   11f8 <write>
  for(i = 0; fmt[i]; i++){
    140e:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    1412:	31 d2                	xor    %edx,%edx
  for(i = 0; fmt[i]; i++){
    1414:	84 db                	test   %bl,%bl
    1416:	75 80                	jne    1398 <printf+0x68>
    }
  }
}
    1418:	83 c4 3c             	add    $0x3c,%esp
    141b:	5b                   	pop    %ebx
    141c:	5e                   	pop    %esi
    141d:	5f                   	pop    %edi
    141e:	5d                   	pop    %ebp
    141f:	c3                   	ret    
        printint(fd, *ap, 16, 0);
    1420:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    1427:	b9 10 00 00 00       	mov    $0x10,%ecx
    142c:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    142f:	89 f8                	mov    %edi,%eax
    1431:	8b 13                	mov    (%ebx),%edx
    1433:	e8 58 fe ff ff       	call   1290 <printint>
        ap++;
    1438:	89 d8                	mov    %ebx,%eax
      state = 0;
    143a:	31 d2                	xor    %edx,%edx
        ap++;
    143c:	83 c0 04             	add    $0x4,%eax
    143f:	89 45 d0             	mov    %eax,-0x30(%ebp)
    1442:	e9 44 ff ff ff       	jmp    138b <printf+0x5b>
    1447:	89 f6                	mov    %esi,%esi
    1449:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        s = (char*)*ap;
    1450:	8b 45 d0             	mov    -0x30(%ebp),%eax
    1453:	8b 10                	mov    (%eax),%edx
        ap++;
    1455:	83 c0 04             	add    $0x4,%eax
    1458:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    145b:	85 d2                	test   %edx,%edx
    145d:	0f 84 aa 00 00 00    	je     150d <printf+0x1dd>
        while(*s != 0){
    1463:	0f b6 02             	movzbl (%edx),%eax
        s = (char*)*ap;
    1466:	89 d3                	mov    %edx,%ebx
        while(*s != 0){
    1468:	84 c0                	test   %al,%al
    146a:	74 27                	je     1493 <printf+0x163>
    146c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1470:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
    1473:	b8 01 00 00 00       	mov    $0x1,%eax
          s++;
    1478:	43                   	inc    %ebx
  write(fd, &c, 1);
    1479:	89 44 24 08          	mov    %eax,0x8(%esp)
    147d:	8d 45 e3             	lea    -0x1d(%ebp),%eax
    1480:	89 44 24 04          	mov    %eax,0x4(%esp)
    1484:	89 3c 24             	mov    %edi,(%esp)
    1487:	e8 6c fd ff ff       	call   11f8 <write>
        while(*s != 0){
    148c:	0f b6 03             	movzbl (%ebx),%eax
    148f:	84 c0                	test   %al,%al
    1491:	75 dd                	jne    1470 <printf+0x140>
      state = 0;
    1493:	31 d2                	xor    %edx,%edx
    1495:	e9 f1 fe ff ff       	jmp    138b <printf+0x5b>
    149a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    14a0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    14a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
    14ac:	e9 7b ff ff ff       	jmp    142c <printf+0xfc>
    14b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  write(fd, &c, 1);
    14b8:	b9 01 00 00 00       	mov    $0x1,%ecx
    14bd:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    14c0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
    14c4:	89 44 24 04          	mov    %eax,0x4(%esp)
    14c8:	89 3c 24             	mov    %edi,(%esp)
    14cb:	88 5d e5             	mov    %bl,-0x1b(%ebp)
    14ce:	e8 25 fd ff ff       	call   11f8 <write>
      state = 0;
    14d3:	31 d2                	xor    %edx,%edx
    14d5:	e9 b1 fe ff ff       	jmp    138b <printf+0x5b>
    14da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, *ap);
    14e0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
    14e3:	8b 03                	mov    (%ebx),%eax
        ap++;
    14e5:	83 c3 04             	add    $0x4,%ebx
  write(fd, &c, 1);
    14e8:	89 3c 24             	mov    %edi,(%esp)
        putc(fd, *ap);
    14eb:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
    14ee:	b8 01 00 00 00       	mov    $0x1,%eax
    14f3:	89 44 24 08          	mov    %eax,0x8(%esp)
    14f7:	8d 45 e4             	lea    -0x1c(%ebp),%eax
    14fa:	89 44 24 04          	mov    %eax,0x4(%esp)
    14fe:	e8 f5 fc ff ff       	call   11f8 <write>
      state = 0;
    1503:	31 d2                	xor    %edx,%edx
        ap++;
    1505:	89 5d d0             	mov    %ebx,-0x30(%ebp)
    1508:	e9 7e fe ff ff       	jmp    138b <printf+0x5b>
          s = "(null)";
    150d:	bb ac 17 00 00       	mov    $0x17ac,%ebx
        while(*s != 0){
    1512:	b0 28                	mov    $0x28,%al
    1514:	e9 57 ff ff ff       	jmp    1470 <printf+0x140>
    1519:	66 90                	xchg   %ax,%ax
    151b:	66 90                	xchg   %ax,%ax
    151d:	66 90                	xchg   %ax,%ax
    151f:	90                   	nop

00001520 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1520:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1521:	a1 84 1e 00 00       	mov    0x1e84,%eax
{
    1526:	89 e5                	mov    %esp,%ebp
    1528:	57                   	push   %edi
    1529:	56                   	push   %esi
    152a:	53                   	push   %ebx
    152b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    152e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
    1531:	eb 0d                	jmp    1540 <free+0x20>
    1533:	90                   	nop
    1534:	90                   	nop
    1535:	90                   	nop
    1536:	90                   	nop
    1537:	90                   	nop
    1538:	90                   	nop
    1539:	90                   	nop
    153a:	90                   	nop
    153b:	90                   	nop
    153c:	90                   	nop
    153d:	90                   	nop
    153e:	90                   	nop
    153f:	90                   	nop
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1540:	39 c8                	cmp    %ecx,%eax
    1542:	8b 10                	mov    (%eax),%edx
    1544:	73 32                	jae    1578 <free+0x58>
    1546:	39 d1                	cmp    %edx,%ecx
    1548:	72 04                	jb     154e <free+0x2e>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    154a:	39 d0                	cmp    %edx,%eax
    154c:	72 32                	jb     1580 <free+0x60>
      break;
  if(bp + bp->s.size == p->s.ptr){
    154e:	8b 73 fc             	mov    -0x4(%ebx),%esi
    1551:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    1554:	39 fa                	cmp    %edi,%edx
    1556:	74 30                	je     1588 <free+0x68>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1558:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    155b:	8b 50 04             	mov    0x4(%eax),%edx
    155e:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    1561:	39 f1                	cmp    %esi,%ecx
    1563:	74 3c                	je     15a1 <free+0x81>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1565:	89 08                	mov    %ecx,(%eax)
  freep = p;
}
    1567:	5b                   	pop    %ebx
  freep = p;
    1568:	a3 84 1e 00 00       	mov    %eax,0x1e84
}
    156d:	5e                   	pop    %esi
    156e:	5f                   	pop    %edi
    156f:	5d                   	pop    %ebp
    1570:	c3                   	ret    
    1571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1578:	39 d0                	cmp    %edx,%eax
    157a:	72 04                	jb     1580 <free+0x60>
    157c:	39 d1                	cmp    %edx,%ecx
    157e:	72 ce                	jb     154e <free+0x2e>
{
    1580:	89 d0                	mov    %edx,%eax
    1582:	eb bc                	jmp    1540 <free+0x20>
    1584:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
    1588:	8b 7a 04             	mov    0x4(%edx),%edi
    158b:	01 fe                	add    %edi,%esi
    158d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1590:	8b 10                	mov    (%eax),%edx
    1592:	8b 12                	mov    (%edx),%edx
    1594:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1597:	8b 50 04             	mov    0x4(%eax),%edx
    159a:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    159d:	39 f1                	cmp    %esi,%ecx
    159f:	75 c4                	jne    1565 <free+0x45>
    p->s.size += bp->s.size;
    15a1:	8b 4b fc             	mov    -0x4(%ebx),%ecx
  freep = p;
    15a4:	a3 84 1e 00 00       	mov    %eax,0x1e84
    p->s.size += bp->s.size;
    15a9:	01 ca                	add    %ecx,%edx
    15ab:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    15ae:	8b 53 f8             	mov    -0x8(%ebx),%edx
    15b1:	89 10                	mov    %edx,(%eax)
}
    15b3:	5b                   	pop    %ebx
    15b4:	5e                   	pop    %esi
    15b5:	5f                   	pop    %edi
    15b6:	5d                   	pop    %ebp
    15b7:	c3                   	ret    
    15b8:	90                   	nop
    15b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000015c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    15c0:	55                   	push   %ebp
    15c1:	89 e5                	mov    %esp,%ebp
    15c3:	57                   	push   %edi
    15c4:	56                   	push   %esi
    15c5:	53                   	push   %ebx
    15c6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    15cc:	8b 15 84 1e 00 00    	mov    0x1e84,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    15d2:	8d 78 07             	lea    0x7(%eax),%edi
    15d5:	c1 ef 03             	shr    $0x3,%edi
    15d8:	47                   	inc    %edi
  if((prevp = freep) == 0){
    15d9:	85 d2                	test   %edx,%edx
    15db:	0f 84 8f 00 00 00    	je     1670 <malloc+0xb0>
    15e1:	8b 02                	mov    (%edx),%eax
    15e3:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
    15e6:	39 cf                	cmp    %ecx,%edi
    15e8:	76 66                	jbe    1650 <malloc+0x90>
    15ea:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
    15f0:	bb 00 10 00 00       	mov    $0x1000,%ebx
    15f5:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
    15f8:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
    15ff:	eb 10                	jmp    1611 <malloc+0x51>
    1601:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1608:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    160a:	8b 48 04             	mov    0x4(%eax),%ecx
    160d:	39 f9                	cmp    %edi,%ecx
    160f:	73 3f                	jae    1650 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1611:	39 05 84 1e 00 00    	cmp    %eax,0x1e84
    1617:	89 c2                	mov    %eax,%edx
    1619:	75 ed                	jne    1608 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    161b:	89 34 24             	mov    %esi,(%esp)
    161e:	e8 3d fc ff ff       	call   1260 <sbrk>
  if(p == (char*)-1)
    1623:	83 f8 ff             	cmp    $0xffffffff,%eax
    1626:	74 18                	je     1640 <malloc+0x80>
  hp->s.size = nu;
    1628:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    162b:	83 c0 08             	add    $0x8,%eax
    162e:	89 04 24             	mov    %eax,(%esp)
    1631:	e8 ea fe ff ff       	call   1520 <free>
  return freep;
    1636:	8b 15 84 1e 00 00    	mov    0x1e84,%edx
      if((p = morecore(nunits)) == 0)
    163c:	85 d2                	test   %edx,%edx
    163e:	75 c8                	jne    1608 <malloc+0x48>
        return 0;
  }
}
    1640:	83 c4 1c             	add    $0x1c,%esp
        return 0;
    1643:	31 c0                	xor    %eax,%eax
}
    1645:	5b                   	pop    %ebx
    1646:	5e                   	pop    %esi
    1647:	5f                   	pop    %edi
    1648:	5d                   	pop    %ebp
    1649:	c3                   	ret    
    164a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1650:	39 cf                	cmp    %ecx,%edi
    1652:	74 4c                	je     16a0 <malloc+0xe0>
        p->s.size -= nunits;
    1654:	29 f9                	sub    %edi,%ecx
    1656:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1659:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    165c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
    165f:	89 15 84 1e 00 00    	mov    %edx,0x1e84
}
    1665:	83 c4 1c             	add    $0x1c,%esp
      return (void*)(p + 1);
    1668:	83 c0 08             	add    $0x8,%eax
}
    166b:	5b                   	pop    %ebx
    166c:	5e                   	pop    %esi
    166d:	5f                   	pop    %edi
    166e:	5d                   	pop    %ebp
    166f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    1670:	b8 88 1e 00 00       	mov    $0x1e88,%eax
    1675:	ba 88 1e 00 00       	mov    $0x1e88,%edx
    base.s.size = 0;
    167a:	31 c9                	xor    %ecx,%ecx
    base.s.ptr = freep = prevp = &base;
    167c:	a3 84 1e 00 00       	mov    %eax,0x1e84
    base.s.size = 0;
    1681:	b8 88 1e 00 00       	mov    $0x1e88,%eax
    base.s.ptr = freep = prevp = &base;
    1686:	89 15 88 1e 00 00    	mov    %edx,0x1e88
    base.s.size = 0;
    168c:	89 0d 8c 1e 00 00    	mov    %ecx,0x1e8c
    1692:	e9 53 ff ff ff       	jmp    15ea <malloc+0x2a>
    1697:	89 f6                	mov    %esi,%esi
    1699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        prevp->s.ptr = p->s.ptr;
    16a0:	8b 08                	mov    (%eax),%ecx
    16a2:	89 0a                	mov    %ecx,(%edx)
    16a4:	eb b9                	jmp    165f <malloc+0x9f>
