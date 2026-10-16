# 作业 1 Hello World

## 要求与文件

- [HELLO.ASM](HELLO.ASM)：传统汇编源码。
- [HELLO.EXE](HELLO.EXE)：实际汇编、链接生成的 16 位 DOS 程序。
- [Word 操作文档](helloworld作业文档.docx)：两种实现方法、机器码对应关系和实际操作记录，共 4 页。
- [EXEU.LOG](EXEU.LOG)：DEBUG 加载 EXE 后执行 U、T、D、G 的实际记录。
- [MEME.LOG](MEME.LOG)：用 E 直接写入机器码和字符串后执行的实际记录。
- [验证结果](验证结果.txt)。

## 传统方式

在 DOSBox 的本目录中运行：

```text
HELLO
```

输出为 `helloworld`，随后回车换行。重新汇编和链接：

```text
masm HELLO.ASM;
link HELLO.OBJ;
```

## DEBUG 实验

在本目录中使用已安装的 DEBUG，可读取随附命令文件复现两种方法：

```text
debug HELLO.EXE < EXEU.IN
debug < MEME.IN
```

第二种方式启动时没有加载 EXE，也没有使用 A 命令；E 命令把 14 字节机器码写到偏移 `0100h`，把字符串写到 `0120h`，再用 `G=100` 执行。

具体输入命令、字节解释和机器码与源代码的对应关系见 Word 文档及两份原始日志。日志中的段地址随再次启动 DEBUG 可以改变。
