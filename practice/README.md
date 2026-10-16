# 课堂练习 进制转换

| 文件 | 要求与范围 |
| --- | --- |
| [EXCHANGE.ASM](EXCHANGE.ASM) / [EXE](EXCHANGE.EXE) | 输入 1～2 位十六进制数，输出十进制数，支持大小写；范围 00h～FFh |
| [DEC2HEX.ASM](DEC2HEX.ASM) / [EXE](DEC2HEX.EXE) | 输入 0～65535 的十进制整数，输出大写十六进制 |

## 运行示例

在 DOSBox 的本目录运行 `EXCHANGE` 或 `DEC2HEX`，根据提示输入数字后回车。

```text
ff    → 255
A     → 10
255   → FF
65535 → FFFF
```

不带 0x 前缀、符号或空格。允许符合长度限制的前导零。空串、非法字符、过长输入、超范围数值会显示 Invalid input，返回码为 1；成功时返回 0。

## 实现思路

十六进制输入按 `value = value * 16 + digit` 累计；十进制输入按 `value = value * 10 + digit` 累计。十进制解析检查乘积高字与加法进位，避免溢出回绕。

显示结果时反复除以目标进制，把余数压栈后倒序弹出。16 位 DIV 前清零 DX；数值零也至少生成一位数字。

## 重新构建

```text
masm EXCHANGE.ASM;
link EXCHANGE.OBJ;
masm DEC2HEX.ASM;
link DEC2HEX.OBJ;
```

849 次真实 DOS 执行全部通过，包括全部 0～255 数值、大小写、16 位边界和非法输入。见[验证结果](验证结果.txt)及[实际运行示例](实际运行示例.txt)。
