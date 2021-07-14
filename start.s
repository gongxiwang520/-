
        
        MODULE  ?cstartup               ; MODULES NAME
        
        ; NOROOY表示这个段如果没有被引用,将会被链接器舍弃,ROOT则表示可不被优化
        SECTION CSTACK:DATA:NOROOT(3)   ; CSTACK SECTION
        
        SECTION .intvec:CODE:NOROOT(2)  ; .intvec SECTION
        ; 引用__iar_program_start
        EXTERN    __iar_program_start
        ; 导出__vector_table
        PUBLIC    __vector_table
        
        DATA
__vector_table
        DCD         sfe(CSTACK)
        DCD         Reset_Handler
        
        ; REORDER表示开始一个新的名字是section的段
        SECTION .text:CODE:REORDER:NOROOT(2)
Reset_Handler          
        ; enable GPIOC Clock
        LDR         R0, =(0x40023800 + 0x30)  ; RCC_AHB1ENR寄存器地址
        LDR         R1, [R0]
        ORR         R1, R1, #(1 << 2)
        STR         R1, [R0]
        
        ; set PC0 as output
        LDR         R0, =(0x40020800 + 0x00)  ; GPIOx_MODER寄存器地址
        LDR         R1, [R0]
        ORR         R1, R1, #(1 << 0)
        STR         R1, [R0]
        
        ; config GPIOx_ODR
        LDR         R2, =(0x40020800 + 0x14)  ; GPIOx_ODR寄存器地址
Loop
        ; set PC0 output high
        LDR         R1, [R2]
        ORR         R1, R1, #(1 << 0)
        STR         R1, [R2]
        
        LDR         R0, =100000
        BL          delay         ; 调用delay函数,并保存LR
        
        ; set PC0 output low
        LDR         R1, [R2]
        BIC         R1, R1, #(1 << 0)
        STR         R1, [R2]
        BL          delay
        
        B           Loop        ; 循环执行
        
delay
        SUBS        R0, R0, #1
        BNE         delay
        MOV         PC, LR        ; delay运行结束,返回LR
        
        END
        