# 作业 4 乘法指令和过程调用

本页介绍第一部分“输出九九乘法表”。第二部分见 **[九九乘法表纠错](check/)**，包含原始 81 项数据检查、C 全局/局部数组比较和 DEBUG 调试记录。

按题目示例输出从 9 行递减到 1 行的九九乘法表。每行的第二个乘数从 1 增加到当前行号，共 45 个算式。

## 文件

| 文件 | 用途 |
| --- | --- |
| [MUL9.ASM](MUL9.ASM) / [MUL9.EXE](MUL9.EXE) | 8086 汇编主程序，双重循环和过程调用 |
| [TABLEIO.INC](TABLEIO.INC) | PrintCell、PrintDec、PutChar 三个实际输出过程，必须与 ASM 放在同一目录 |
| [MUL9_C.c](MUL9_C.c) / [MUL9_C.EXE](MUL9_C.EXE) | C 语言实现，Windows x64 可执行文件 |
| [C 反汇编中文注释](C反汇编_中文注释.txt) | 从最终 C EXE 提取的两个人工编写函数，共 56 条实际指令，逐条加注释 |
| [C_DISASM.TXT](C_DISASM.TXT) | 相同用户函数的原始反汇编，保留地址、机器码和指令 |
| [REGTEST.ASM](REGTEST.ASM) / [REGTEST.EXE](REGTEST.EXE) | 调用实际输出过程，检查寄存器恢复与栈平衡的自检程序 |
| [ASM.OUT](ASM.OUT) / [C.OUT](C.OUT) | 两个程序的真实输出，逐字节一致 |
| [验证结果](验证结果.txt) | 数学结果、编译和过程调用检查汇总 |

## 实际输出

    The 9mul9 table:
    9*1=9   9*2=18  9*3=27  9*4=36  9*5=45  9*6=54  9*7=63  9*8=72  9*9=81
    8*1=8   8*2=16  8*3=24  8*4=32  8*5=40  8*6=48  8*7=56  8*8=64
    7*1=7   7*2=14  7*3=21  7*4=28  7*5=35  7*6=42  7*7=49
    6*1=6   6*2=12  6*3=18  6*4=24  6*5=30  6*6=36
    5*1=5   5*2=10  5*3=15  5*4=20  5*5=25
    4*1=4   4*2=8   4*3=12  4*4=16
    3*1=3   3*2=6   3*3=9
    2*1=2   2*2=4
    1*1=1

每个非末尾单元格占 8 列，一位数乘积后补 3 个空格，两位数后补 2 个空格。每行最后一个算式后直接换行，不留行末空格。

## 双重循环与乘法

主程序用 BH 保存行号，初值为 9；BL 保存列号，每行从 1 开始。外层 CX 从 9 递减，内层 CX 为当前行的算式数量。进入内层前 PUSH CX，结束后 POP CX，恢复外层计数。

PrintCell 中先把 BH 的行号送入 AL，再执行 MUL BL。8086 的 8 位无符号 MUL 将 AL 与 BL 相乘，完整乘积存入 AX。本题最大乘积为 9*9=81，AH 因而为 0，随后按十进制显示。

## CALL 和 RET 与寄存器保存

主程序执行 CALL PrintCell。PrintCell 再调用 PrintDec 和 PutChar，最后通过 RET 返回，继续执行主程序中 CALL 后面的 INC BL。

| 过程 | 输入 | 保存与恢复 |
| --- | --- | --- |
| PrintCell | BH=行号，BL=列号 | PUSH AX/BX/CX/DX，末尾逆序 POP；用 CX 补空格后恢复主循环的 CX |
| PrintDec | AX=无符号整数 | 保存 AX/BX/CX/DX；内部使用 BX=10 和 CX=位数，结束后恢复 |
| PutChar | DL=要输出的字符 | 保存 AX，设置 AH=02h 调用 INT 21h 后恢复 AX |

SI、DI、BP 未被输出过程使用。过程不承诺保存标志寄存器；主循环使用 LOOP 的 CX 条件，不依赖过程返回时的标志。

8086 近 CALL 会把 16 位返回地址 IP 压栈，RET 从栈中取回 IP。各过程的 PUSH 与 POP 成对且顺序相反，十进制余数也全部弹出，因此调用后 SP 恢复原值。

REGTEST 调用 3 次 PrintCell、5 次 PrintDec、1 次 PutChar，逐次检查 AX、BX、CX、DX、SI、DI、BP 和 SP。覆盖一位数、两位数、行末、数值 0 与 65535，全部返回成功。REG.OUT 是这些独立过程测试的拼接输出。

## 十进制输出

PrintDec 将 AX 反复除以 10，余数压栈后逆序弹出，每位加 ASCII 字符 0 后输出。16 位 DIV 的被除数是 DX:AX，因此每次除法前清零 DX。数值 0 也至少执行一次除法，正确输出一个 0。

## 运行与重新构建

汇编 EXE 是 16 位 DOS 程序，需在 DOSBox 中运行。假设仓库位于 D:/assembly-homework：

    mount c D:/assembly-homework
    c:
    cd hw04
    MUL9

已配置 MASM、LINK 命令路径时，在 hw04 目录中重新编译：

    masm MUL9.ASM;
    link MUL9.OBJ;

过程自检：

    masm REGTEST.ASM;
    link REGTEST.OBJ;
    REGTEST

TABLEIO.INC 须与两份 ASM 源码放在同一目录。

C 版在 Windows x64 中运行 MUL9_C.EXE。使用 Visual Studio 的 x64 Native Tools 命令提示符重新构建和查看完整反汇编：

    cl /nologo /TC /Od /Ob0 /W4 /MT /Fe:MUL9_C.EXE MUL9_C.c /link /INCREMENTAL:NO /MAP:MUL9_C.MAP
    dumpbin /nologo /disasm MUL9_C.EXE > C_FULL.TXT

本次 C 编译器为已有 MSVC 19.51.36248。因当前环境无法启动原来的 32 位编译器，本次采用可运行的 x64 工具；C 源码、反汇编和验证记录均明确标注目标位宽。

C_DISASM.TXT 与中文注释文件只截取 print_cell 和 main 两个用户函数，不包含 C 运行库的全部指令。每条机器码已与最终 EXE 的对应字节核对，函数地址也与链接器 MAP 文件核对。改动源码、编译器或选项后，须重新提取反汇编并核对注释。

## 验证环境与结果

- 汇编与链接：MASM 5.10、LINK 3.65，均无警告、无错误。
- DOS 实际运行：[官方 DOSBox Staging 0.83.0 x64](https://github.com/dosbox-staging/dosbox-staging/releases/tag/v0.83.0)，便携包已核对官方 SHA-256。
- C 实际运行：Windows x64，MSVC，/Od /Ob0 /W4 /MT，编译无警告。
- 全部 45 个算式、9 行递减结构、列宽和换行均核对通过。
- 汇编版与 C 版输出逐字节相同。
- 9 次过程调用后的寄存器与栈平衡自检全部通过。

原始汇编与链接记录：[MULASM.LOG](MULASM.LOG)、[MULLNK.LOG](MULLNK.LOG)、[REGASM.LOG](REGASM.LOG)、[REGLNK.LOG](REGLNK.LOG)。C 编译记录见 [C_BUILD.LOG](C_BUILD.LOG)。
