## 说明

该例程使用汇编语言完成LED灯闪烁的功能，汇编文件为`start.s`.

- 使用MCU为：STM32F411RCT6；
- LED的IO口为PC0；
- 编译器为IAR 8.32.4

如果编译时提示`__iar_program_start `没有定义，可以按参考下图进行设置：
![option->Linker](picture/01.png)