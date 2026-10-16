# 作业 3 求和

基本要求为计算 `1+2+...+100` 并打印十进制 `5050`。程序实际逐项累加，再进行十进制字符转换。

| 文件 | 实现 |
| --- | --- |
| [SUM.ASM](SUM.ASM) / [EXE](SUM.EXE) | AX 寄存器保存累计结果，运行只输出 5050 和换行 |
| [SUM_DATA.ASM](SUM_DATA.ASM) / [EXE](SUM_DATA.EXE) | 数据段的 DW 变量保存累计结果 |
| [SUM_STK.ASM](SUM_STK.ASM) / [EXE](SUM_STK.EXE) | 栈中的 SS:[BP-2] 保存累计结果 |
| [SUM_N.ASM](SUM_N.ASM) / [EXE](SUM_N.EXE) | 用户输入 1～100 的 n，计算 1+...+n |
| [SUM_C.c](SUM_C.c) / [EXE](SUM_C.EXE) | C 语言实现输入校验与逐项求和 |
| [PRINTNUM.INC](PRINTNUM.INC) | 四份汇编共用的十进制输出过程，重新汇编时必须保留 |
| [C 反汇编中文注释](C反汇编_中文注释.txt) | 逐条解释求和函数，逐段解释输入、校验、调用和输出流程 |

## 运行

在 DOSBox 的本目录运行 `SUM`、`SUM_DATA`、`SUM_STK` 或 `SUM_N`。三个固定版本均输出 `5050`；输入版例如：

```text
n=1   → 1
n=10  → 55
n=100 → 5050
```

C 程序 `SUM_C.EXE` 在 Windows 中运行，根据提示输入 n。

## 数据范围和十进制转换

`5050 = 13BAh`，超过 8 位无符号最大值 255，需要用 16 位字保存。在 `1≤n≤100` 范围内，求和不会超出 16 位范围。

PRINTNUM.INC 反复除以 10，将余数压栈后倒序输出；每位加字符 '0' 的 ASCII 码，并用 INT 21h/AH=02h 输出。DIV 的被除数是 DX:AX，每次除法前清零 DX。

栈版在循环内直接修改 SS:[BP-2]，并在取出结果后恢复 SP 和 BP。数据段版先初始化 DS；寄存器版直接使用 AX 累加。

## 键盘输入

SUM_N 使用 [INT 21h/AH=0Ah 缓冲输入](https://fd.lod.bz/rbil/interrup/dos_kernel/210a.html)，DS:DX 指向输入缓冲区。缓冲区第 1 字节返回实际字符数，第 2 字节起是输入内容。

程序验证输入为 1～3 位数字、数值 1～100。非法输入返回码为 1，并且不显示错误的求和结果。

## 重新构建

在 DOSBox 的本目录中，分别对 SUM、SUM_DATA、SUM_STK、SUM_N 执行，例如：

```text
masm SUM.ASM;
link SUM.OBJ;
```

四份 ASM 均需与 PRINTNUM.INC 保持在同一目录。Windows C 编译和反汇编：

```text
gcc -x c -m32 -O0 -g -Wall -Wextra -std=c90 SUM_C.c -o SUM_C.EXE
objdump -d -Mintel --insn-width=16 SUM_C.EXE > C_FULL.TXT
```

247 次真实程序执行全部通过，交互式汇编版与 C 版分别遍历 n=1～100。见[验证结果](验证结果.txt)、[实际运行示例](实际运行示例.txt)和[完整原始反汇编](C_FULL.TXT)。
