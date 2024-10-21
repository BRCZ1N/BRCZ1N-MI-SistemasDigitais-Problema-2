 .section .text
.global dot_product
.type dot_product, %function



dot_product:

    LDR R4, [SP,#0]
    PUSH    {LR}      
    ADD R0,R0,R1
    ADD R0,R0,R2
    ADD R0,R0,R3
    ADD R0,R0,R4
    POP {LR}
    SUB SP, SP, #24
    LDR R0, [SP,#4]
    BX LR