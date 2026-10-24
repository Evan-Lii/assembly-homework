# 8086 汇编课程作业

所有作业保存在 `homework` 分支，按题目分别整理目录，便于逐次检查源码、程序、说明和验证记录。

| 目录 | 题目 | 主要内容 |
| --- | --- | --- |
| [hw01](hw01/) | 作业 1 Hello World | 源码汇编与链接、DEBUG U 反汇编、DEBUG E 直接写内存执行 |
| [hw02](hw02/) | 作业 2 ASCII 表 | LOOP、条件跳转、C 实现与中文反汇编注释 |
| [practice](practice/) | 课堂练习 进制转换 | 1～2 位十六进制转十进制、十进制转十六进制 |
| [hw03](hw03/) | 作业 3 求和 | 寄存器、数据段、栈三种存储方式，输入 n 求和，C 实现与反汇编 |
| [hw04](hw04/) | 作业 4 乘法指令和过程调用 | 九九乘法表、MUL、CALL/RET、寄存器保护、双重循环与 C 反汇编 |

每个目录的 README 列出了题目要求、文件用途、运行和重新构建方法。可执行文件与已验证的源码对应。

## 环境

- 汇编：8086 指令、MASM 5.10、LINK 3.65，生成 16 位 DOS EXE。
- 运行 DOS 程序：DOSBox 0.74-3；作业 4 本次在 DOSBox Staging 0.83.0 x64 中验证。
- DEBUG 练习：兼容传统命令的 Debug/X 2.50。
- C（作业 2、3）：TDM-GCC 4.9.2，32 位 x86 Windows，`-O0 -Wall -Wextra -std=c90`。

汇编 EXE 在 DOSBox 中运行；C 版 EXE 在 Windows 中运行。作业 2、3 的 C 目标为 32 位，作业 4 的 C 目标为 64 位，反汇编中均明确标注。

作业 4 的 C 编译器为 MSVC 19.51.36248，使用 /Od /Ob0 /W4 /MT。

## 运行示例

下载或克隆仓库到 `D:\assembly-homework` 后，在 DOSBox 中输入：

```text
mount c D:\assembly-homework
c:
cd hw03
SUM
SUM_N
```

`SUM` 输出 `5050`。`SUM_N` 提示输入 `1～100`，例如输入 `10` 输出 `55`，输入 `100` 输出 `5050`。

各目录名称均可直接在 DOSBox 中使用。其他程序的运行方法见相应目录说明。

## 重新构建

把已安装的 MASM 和 LINK 目录加入 DOSBox 的 `PATH`，在对应作业目录中执行 README 给出的命令。`hw03/PRINTNUM.INC` 是求和汇编的公共十进制输出过程，已随源码提交。

作业 2、3 的 C 编译和反汇编使用支持 32 位目标的 GCC 与 objdump；作业 4 使用 MSVC x64 与 dumpbin。命令见各目录 README，重新编译后应重新核对反汇编地址与注释。

## 验证记录

- 作业 1：真实 DOS EXE 与 DEBUG E 写内存两种方式均输出 `helloworld`，DEBUG 正常退出。
- 作业 2：三份程序输出逐字节一致，均为两行，每行 13 个字母。
- 进制转换：849 次真实 DOS 程序执行全部通过。
- 作业 3：247 次真实程序执行全部通过，输入版遍历 `n=1～100`。
- 作业 4：45 个乘法式核对通过，汇编与 C 输出一致，9 次过程调用后寄存器与栈自检通过。

各目录附有实际输出或验证汇总，测试范围见对应记录。

## 工具参考

- [微软 MS-DOS 历史仓库中的 MASM 与 LINK](https://github.com/microsoft/MS-DOS/tree/main/v4.0/src/TOOLS)
- [Debug/X 项目](https://github.com/Baron-von-Riedesel/DOS-debug)
- [INT 21h AH=0Ah 缓冲输入功能表](https://fd.lod.bz/rbil/interrup/dos_kernel/210a.html)
