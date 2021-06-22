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
bison -d -o final.tab.c final.y <br>
gcc -c -g -I.. final.tab.c <br>
flex -o final.yy.c final.l <br>
gcc -c -g -I.. final.yy.c <br>
gcc -o final final.tab.o final.yy.o -ll
```