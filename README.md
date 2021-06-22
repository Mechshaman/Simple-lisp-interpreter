# Simple lisp interpreter
## 功能
簡易lisp編譯器，功能如下：<br>
1.	Syntax Validation
2.	Print
3.	Numerical Operations 
4.	Logical Operations
5.	if Expression

## 編譯方式
```
bison -d -o final.tab.c final.y
gcc -c -I.. final.tab.c
flex -o final.yy.c final.l
gcc -c -I.. final.yy.c
gcc -o final final.tab.o final.yy.o -ll
```