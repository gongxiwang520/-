
        
        MODULE  ?cstartup               ; MODULES NAME
        
        ; NOROOY��ʾ��������û�б�����,���ᱻ����������,ROOT���ʾ�ɲ����Ż�
        SECTION CSTACK:DATA:NOROOT(3)   ; CSTACK SECTION
        
        SECTION .intvec:CODE:NOROOT(2)  ; .intvec SECTION
        ; ����__iar_program_start
        EXTERN    __iar_program_start
        ; ����__vector_table
        PUBLIC    __vector_table
        
        DATA
__vector_table
        DCD         sfe(CSTACK)
        DCD         Reset_Handler
        
        ; REORDER��ʾ��ʼһ���µ�������section�Ķ�
        SECTION .text:CODE:REORDER:NOROOT(2)
Reset_Handler          
        ; enable GPIOC Clock
        LDR         R0, =(0x40023800 + 0x30)  ; RCC_AHB1ENR�Ĵ�����ַ
        LDR         R1, [R0]
        ORR         R1, R1, #(1 << 2)
        STR         R1, [R0]
        
        ; set PC0 as output
        LDR         R0, =(0x40020800 + 0x00)  ; GPIOx_MODER�Ĵ�����ַ
        LDR         R1, [R0]
        ORR         R1, R1, #(1 << 0)
        STR         R1, [R0]
        
        ; config GPIOx_ODR
        LDR         R2, =(0x40020800 + 0x14)  ; GPIOx_ODR�Ĵ�����ַ
Loop
        ; set PC0 output high
        LDR         R1, [R2]
        ORR         R1, R1, #(1 << 0)
        STR         R1, [R2]
        
        LDR         R0, =100000
        BL          delay         ; ����delay����,������LR
        
        ; set PC0 output low
        LDR         R1, [R2]
        BIC         R1, R1, #(1 << 0)
        STR         R1, [R2]
        BL          delay
        
        B           Loop        ; ѭ��ִ��
        
delay
        SUBS        R0, R0, #1
        BNE         delay
        MOV         PC, LR        ; delay���н���,����LR
        
        END
        