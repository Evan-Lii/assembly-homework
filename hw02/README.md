# 作业 2 按要求打印 ASCII 表

输出小写字母 a～z，每行 13 个字母，字母间一个空格。

| 文件 | 实现 |
| --- | --- |
| [LOOP13.ASM](LOOP13.ASM) / [EXE](LOOP13.EXE) | 两层循环使用 LOOP，内层开始前 PUSH CX，结束后 POP CX |
| [JUMP13.ASM](JUMP13.ASM) / [EXE](JUMP13.EXE) | 使用 DEC CX 与 JNZ 实现两层循环 |
| [ASCII_C.c](ASCII_C.c) / [EXE](ASCII_C.EXE) | C 语言的两层 for 循环 |
| [C 反汇编中文注释](C反汇编_中文注释.txt) | 从最终 C 程序提取真实地址、机器码与指令并添加注释 |

## 实际输出

```text
a b c d e f g h i j k l m
n o p q r s t u v w x y z
```

三份程序的输出逐字节相同，原始输出保存在 LOOP.OUT、JUMP.OUT、C.OUT，见[验证结果](验证结果.txt)。

## 运行和构建

在 DOSBox 的本目录运行 `LOOP13` 或 `JUMP13`。重新汇编、链接：

```text
masm LOOP13.ASM;
link LOOP13.OBJ;
masm JUMP13.ASM;
link JUMP13.OBJ;
```

C 程序在 Windows 运行。使用支持 32 位目标的 GCC：

```text
gcc -x c -m32 -O0 -g -Wall -Wextra -std=c90 ASCII_C.c -o ASCII_C.EXE
objdump -d -Mintel --insn-width=16 ASCII_C.EXE > C_FULL.TXT
```

LOOP 会修改 CX，双重循环若直接复用 CX，会破坏外层计数。因此 LOOP 版保存并恢复外层 CX。C 的真实反汇编及运行库代码保存在 [C_FULL.TXT](C_FULL.TXT)。
