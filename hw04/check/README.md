# 作业 4（二）九九乘法表纠错

使用老师提供的原始 9×9 字节表，逐项比较存储值与行号、列号的乘积，把错误位置显示到屏幕。坐标从 **1** 开始，`x` 为行号，`y` 为列号。程序检查全部 81 项，保留表数据。

## 运行结果

[ASM.OUT](ASM.OUT) 为汇编程序的实际输出，与题目示例一致：

```text
x y
1 1 error
2 3 error
4 5 error
6 6 error
8 8 error

accomplish!
```

| 行 x | 列 y | 原始值 | 应有值 | 相对 table 的字节偏移 |
| --- | --- | --- | --- | --- |
| 1 | 1 | 7 | 1 | 0 |
| 2 | 3 | 7 | 6 | 11 |
| 4 | 5 | 7 | 20 | 31 |
| 6 | 6 | 7 | 36 | 50 |
| 8 | 8 | 7 | 64 | 70 |

## 文件

| 文件 | 用途 |
| --- | --- |
| [CHECK.ASM](CHECK.ASM) / [CHECK.EXE](CHECK.EXE) | 8086 汇编源码及 16 位 DOS 程序 |
| [CHECKIO.INC](CHECKIO.INC) | 实际使用的 PrintError、PutChar 过程，须与 ASM 放在同一目录 |
| [CHECKG.c](CHECKG.c) / [CHECKG.EXE](CHECKG.EXE) | C 全局数组版本，Windows x64 |
| [CHECKL.c](CHECKL.c) / [CHECKL.EXE](CHECKL.EXE) | C 局部自动数组版本，Windows x64 |
| [全局版中文注释](全局反汇编_中文注释.txt) / [局部版中文注释](局部反汇编_中文注释.txt) | 最终 C EXE 中 main、print_error 的每条真实指令及中文说明 |
| [G_DISASM.TXT](G_DISASM.TXT) / [L_DISASM.TXT](L_DISASM.TXT) | 对应用户函数的原始反汇编，含地址及机器码 |
| [REGTEST.ASM](REGTEST.ASM) / [REGTEST.EXE](REGTEST.EXE) / [REG.OUT](REG.OUT) | 输出过程的寄存器、栈平衡自检及实际输出 |
| [DEBUG.IN](DEBUG.IN) / [DEBUG.OUT](DEBUG.OUT) | DEBUG 命令与本次真实调试记录 |
| [TESTS.TXT](TESTS.TXT) / [验证结果.txt](验证结果.txt) | 84 组 DOS 测试结果和完整验证范围 |

## 汇编实现与寻址

`table DB ...` 连续存放 81 个字节，按行排列。第 x 行、第 y 列的偏移为 `(x-1)*9+(y-1)`，每行占 9 字节。

入口用 `MOV AX,@data`、`MOV DS,AX` 设置数据段，然后令 `SI=OFFSET table`。`CMP AL,[SI]` 通过默认的 `DS:SI` 读取当前元素，每轮执行 `INC SI`，恰好扫描 81 字节。这里只比较数据，没有写回修改。

BH 保存行号 1～9，BL 保存列号 1～9。`MOV AL,BH` 后执行 `MUL BL`，8 位无符号乘法将完整结果写入 AX。乘积最大为 81，因此 AH=0，可以用 AL 与一个 DB 字节比较。

外层、内层都使用 `LOOP` 和 CX。每行进入内层前 `PUSH CX`，内层结束后 `POP CX`，恢复外层计数。每行列数固定为 9。

## CALL、RET 与寄存器保护

错误分支执行 `CALL PrintError`。该过程读取主程序的 BH、BL 显示坐标，又借用主程序的 SI 遍历消息字符串、CX 控制消息输出循环。

过程入口依次 `PUSH AX/BX/CX/DX/SI`，结束时逆序恢复，保证主程序的当前表指针 SI 和内层计数 CX 不受影响。PrintError 内部继续 `CALL PutChar`；PutChar 保存调用 DOS 输出所用的 AX，再通过 RET 返回。SI、CX、各次近 CALL 的返回地址均正常出栈。

DI、BP 未被输出过程使用；不承诺保存标志位。近 CALL 将返回 IP 压栈，RET 取回该地址。本程序不依赖输出过程返回时的标志状态。

REGTEST 共调用 PrintError 3 次，每次检查 AX、BX、CX、DX、SI、DI、BP 及 SP；主程序和自检使用同一份 CHECKIO.INC。

## C 全局数组与局部数组的比较

两份 C 程序采用相同的原始数据、嵌套循环和报错过程，区别在于 table 的定义位置。C 下标 row、column 为 0～8，比较值为 `(row+1)*(column+1)`，显示时也加 1。

以下是本次 MSVC `/Od /Ob0 /W4 /MT`、Windows x64 编译的实际结果：

| 观察点 | CHECKG.c 全局版 | CHECKL.c 局部版 |
| --- | --- | --- |
| 定义 | main 外的 unsigned char table[9][9] | main 内、未加 static 的自动数组 |
| 生命周期 | 整个程序执行期间 | 当前 main 调用期间 |
| 本次数组位置 | PE 的 .data，首选地址 0000000140021000 | main 栈帧，RSP+30h 至 RSP+80h |
| 初始化 | 81 个初始字节直接存入 EXE 的数据区 | 进入 main 后执行 81 条逐字节 MOV 初始化 |
| main 分配栈空间 | SUB RSP,38h，即 56 字节 | SUB RSP,A8h，即 168 字节 |
| 行首寻址 | 先取得全局 table 地址，再加 row*9 | LEA RAX,[RSP+RAX+30h]，此时 RAX=row*9 |
| 元素读取 | MOVZX EAX,byte ptr [RAX+RCX] | 相同，RCX 为 column |
| 栈保护 | 本 main 未生成局部数组的 cookie 检查 | 生成 /GS cookie 保存与返回前检查 |

两个数组本身都只有 81 字节。栈帧还包括循环变量、函数调用空间、对齐和可能的安全 cookie，不能把两个栈帧大小的差直接当作数组大小。

这些地址、栈布局和初始化指令是本次编译的观察结果，可能随编译器、优化选项改变。局部数组若加 static，将变为静态存储期，性质也随之改变。

C 反汇编为 x64 指令，参数按 RCX、RDX、R8、R9 传递；与本题 8086 汇编中的 DOS 中断和 16 位寄存器不同。两份反汇编共 197 条用户函数指令，全部机器码与最终 EXE 对应字节核对；只截取 main、print_error，没有展开整个运行库。

**C 运行验证限制：** 两版均已编译、链接成功且无警告；本机 Windows Code Integrity 策略以 WinError 4551 拦截了新生成程序，未进行两个 C EXE 的实际输出比较。未更改系统安全设置。[ASM.OUT](ASM.OUT) 来自真实 DOS 汇编程序；本目录没有把预期结果当作 C 运行输出提交。

## 运行及重建

汇编程序在 DOSBox 中运行。假设仓库位于 D:/assembly-homework：

```text
mount c D:/assembly-homework
c:
cd hw04
cd check
CHECK
```

MASM、LINK 已加入 DOSBox 的 PATH 时，在 check 目录执行：

```text
masm CHECK.ASM;
link CHECK.OBJ;
masm REGTEST.ASM;
link REGTEST.OBJ;
REGTEST
```

C EXE 面向 Windows x64。重建时打开 Visual Studio 的 x64 Native Tools 命令提示符：

```text
cl /nologo /TC /Od /Ob0 /W4 /MT /Fe:CHECKG.EXE CHECKG.c /link /INCREMENTAL:NO /MAP:CHECKG.MAP
cl /nologo /TC /Od /Ob0 /W4 /MT /Fe:CHECKL.EXE CHECKL.c /link /INCREMENTAL:NO /MAP:CHECKL.MAP
dumpbin /nologo /disasm CHECKG.EXE > G_FULL.TXT
dumpbin /nologo /disasm CHECKL.EXE > L_FULL.TXT
```

本次编译器版本为 MSVC 19.51.36248。重新编译后需要重新核对函数地址、指令与注释。

## 按老师提示使用 DEBUG

在 DOSBox 中进入 check 目录后执行 `DEBUG CHECK.EXE`，再逐行输入 DEBUG.IN 中的命令。也可以用 `DEBUG CHECK.EXE < DEBUG.IN > DEBUG.OUT` 保存记录。

1. `U CS:0000 003A` 查看主程序，`U CS:0042 006F` 查看 PrintError。
2. `G=0000 0022` 从入口执行到第一处报错 CALL 之前。该程序入口 IP=0000，CALL 所在 IP=0022。
3. `R` 查看寄存器，`D DS:0000 0050` 查看完整 81 字节原始表。
4. `P` 执行完整的 CALL 并在返回后停止。IP 从 0022 到 0025，AX/BX/CX/DX/SP/BP/SI/DI 均与调用前相同。
5. 再次 `R`、`D DS:0000 0050` 核对寄存器和表数据，最后 `G` 执行至结束，`Q` 退出 DEBUG。

要观察进入过程和压栈过程，可以在 CALL 处使用 `T`，然后逐条查看 PUSH、POP、RET。使用 P 可直接观察完整过程返回后的状态。DEBUG.OUT 已记录本次实际的 U、G、P、R、D 操作，程序最终正常退出，返回码 0000。

上述偏移仅适用于本次提交的 CHECK.EXE；重编译或改源码后，应先 U 反汇编确认新 IP，再设置断点。段地址取决于加载环境，使用 CS、DS 符号即可。

## 验证

- 原始数据的三份源码逐项一致，错误坐标与题图一致。
- 84 组真实 DOS 执行通过：原始表、全对表、81 个位置逐一注入错误、全错表。错误注入使用单独临时 EXE，正式程序的数据未改动。
- 过程寄存器和栈自检、DEBUG 调用前后检查通过。
- 两个 C 版本编译和最终机器码核对通过；原生运行限制见上文。

编译原始记录：[ASM.LOG](ASM.LOG)、[LINK.LOG](LINK.LOG)、[REGASM.LOG](REGASM.LOG)、[REGLNK.LOG](REGLNK.LOG)、[C_BUILD.LOG](C_BUILD.LOG)。
