DATA SEGMENT
	CHESSBOARD DB 218,13 DUP(194),191,13 DUP(195,13 DUP(197),180),192,13 DUP(193),217 	;�������̵Ļ�����
	X DB 0										;�������� x
	Y DB 0                                                        						;�������� y
	MY DB 1										;�ҵ�������1���Է���������2
	FLAG DB 0									;�ж��Ƿ�������ӵı�ǣ�1Ϊ���ԣ�0Ϊ������
	STATE DB 0									;Ŀǰ��״̬��������0Ϊ��Ϸ�����У�2Ϊһ���˳���3Ϊһ����ʤ
											;0�����£�1���Ѿ����꣬�ȴ�����X��2�ȴ�����Y��4�Է���ʤ��5�Է��˳�
	OVER DB 0									;�ж��Ƿ����������CALL ISWIN 0Ϊû�н�����1Ϊ����������ʱ��������ӷ���ʤ
	LED DB 3FH,06H,5BH,4FH,66H,6DH,7DH,07H,7FH,6FH     					;�߶�����ܶ�Ӧ��ʾ
    S1 DB 0                             									;���ڱ�����������ֵx
    S2 DB 0										;���ڱ�����������ֵy
    TEMP DB 0                          	 								;����ʱ�жϸ��º��ӻ��ǰ���
    ORDER DB 1                          								;˫��ʱ��־����or���֣�1��ʾ���֣�2��ʾ����
    TI DB ' 1 2 3 4 5 6 7 8 9 A B C D E F',0AH,0DH,'$'						;���̵�y����
    ERROR DB 'YOU CANNOT PUT HERE!',0AH,0DH,'$' 						;����,"�㲻�ܷ�������"
    WRONG DB 0AH,0DH,'FALSE INPUT!',0AH,0DH,'$'						;������Ϣ����ʾ
    COLOR DB 0AH,0DH,'PLEASE CHOOSE YOUR CHESSMAN COLOR:(1 FOR BLACK, 2 FOR WHITE)',0AH,0DH,'$'	;ѡ���ӵ���ɫ��1�Ǻ�ɫ��2�ǰ�ɫ
    CLEAN DB 72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,72 DUP(32),0AH,0DH,'$';��������
    PUT DB 'PLEASE INPUT THE POSITION(X Y):',0AH,0DH,'$'						;���������ӵ�λ��(x,y)
    GAMEEND DB 'ONE PLAYER HAS WIN!',0AH,0DH,'$'						;��Ϸ������Ϣ��ʾ
    CONGRA DB 'YOU WIN! CONGRATULATIONS!',0AH,0DH,'$'					;��Ϸ��ʾ��Ϣ,"��ϲ!��Ӯ��!"
    SORRY DB 'YOU LOSE! DONNOT GIVE UP!',0AH,0DH,'$'						;��Ϸ��ʾ��Ϣ,"�Բ���,������,��Ҫ����!"
    WAIT1 DB 'PLEASE WAIT...',0AH,0DH,'$'  							;����ȴ���Ϣ��ʾ 
    CHOOSE DB 'PLEASE CHOOSE GAME MODEL:(1 FOR ONE PLAYER, 2 FOR TWO PLAYERS, ESC TO QUIT)',0AH,0DH,'$'	;ѡ����Ϸ���淨
    EXIT DB 'ONE PLAYER HAS QUIT!',0AH,0DH,'$'							;һ������˳��󲥷�����
             MUS_FREQ DW 330,392,262,294,330,196,262,294,330,392,294				;����Ƶ�ʱ�MUS_FREQ�ͽ���ʱ���MUS_TIME
             DW 330,392,262,294,330,220,294,196,294,330,262
             DW 440,392,440,262,330,220,330,392,294
             DW 330,392,262,294,330,220,294,196,294,330,262
             DW -1										;���ֲ��Ž�����
    MUS_TIME DW 2 DUP(2500),5000,2 DUP(2500),5000,4 DUP(2500),10000
             DW 2 DUP(2500),5000,2 DUP(2500),5000,4 DUP(2500),10000
             DW 4 DUP(5000),4 DUP(2500),10000
             DW 2 DUP(2500),5000,2 DUP(2500),5000,4 DUP(2500),10000
DATA ENDS
STACK SEGMENT STACK
	DW 128H DUP(0)									;��ʼ����ջ						
STACK ENDS
CODE SEGMENT
	ASSUME CS:CODE,DS:DATA,SS:STACK							;˵��һ����Ӧ�Ĺ�ϵ��֮���ٰѶε��׵�ַ��ֵ���μĴ���
START:
	MOV AX,DATA									;���ݿ�װ��μĴ���DS
	MOV DS,AX
    MOV AL,2
	MOV AH,0									;������ʾ��ʽ
	INT 10H
SELECT:                                 									;ѡ����
    MOV DX,OFFSET CHOOSE                								;ѡ�񵥻���˫����Ϸ
	MOV AH,09H									;ʹ��21H�жϵ����ù��λ�ù���
	INT 21H										;����Ļ����ʾ���������
    MOV AH,1										;ʹ��21H���жϵ���ʾ���빦��						
	INT 21H
	CMP AL,'1'                         								;1Ϊ����
	JE GAME1									;ѡ��1�󣬻ص�������Ϸ
	CMP AL,'2'                          								;2Ϊ˫��
	JZ MARK										;ѡ��2�󣬽������
	CMP AL,27                           								;ESC�˳�
    JZ GEND0										;��Ϸ����
	MOV DX,OFFSET WRONG      								;������������ʾ����������
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
	CALL BEEP									;���ò�������
	JMP SELECT									;�ص�ѡ����
GEND0:
    MOV AH,4CH										;�˳���Ϸ
	INT 21H
;=========/*����*/========
GAME1:	                               
	MOV AL,2									;����Ļ����ʾ���������
	MOV AH,0
	INT 10H										;����80*25�ڰ׷�ʽ�������Ļ
	CALL INITIAL									;��ʼ��������
	CALL PRINT									;��ӡ����
	CALL SLED                           								;�������ʾ��ǰ״̬
HERE1:
	MOV DX,OFFSET PUT								;��������
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
	MOV AH,1									;���������ESC���˳�
	INT 21H
	CMP AL,27									;���������ESC
	JE QUIT										;�˳���Ϸ
	JMP RXY1									;������������X Y
QUIT:											;�˳���Ϸ����Ϣ
	MOV STATE,2									;��STATE��ֵ��Ϊ2
	MOV DX,OFFSET EXIT								;�����˳�����ʾ�˳���Ϣ
	MOV AH,09H									;ʹ��21H���жϵ���ʾ���빦��
	INT 21H 
	CALL SLED									;�������ʾ��ǰ״̬
	JMP GEND1									;��Ϸ����
MARK:
    JMP GAME2										;������һ����Ϸ
RXY1:											;��¼����X Y(ASCII��)
	MOV X,AL									;��¼x������
	INT 21H										;��ʾ����Ļ��x��ֵ
	CMP AL,27									;����ESC���˳�
	JE QUIT										;�˳���¼����x
	INT 21H										;��ʾ����Ļ��y��ֵ
	CMP AL,27									;����ESC���˳�
	JE QUIT										;�˳���¼����y
	MOV Y,AL									;��¼y������
N1:	MOV AH,07									;�޻�������
	INT 21H
	CMP AL,27									;����ESC���˳�
	JE QUIT										;�˳���Ϸ
	CMP AL,13									;���ǻس������������ȴ��س�
	JNE N1										;����ִ��N1����
	MOV AH,2
	MOV DL,0AH									;��ʾ����������
	INT 21H										;����س�����
	MOV DL,0DH									;��ʾ����������
	INT 21H										;����س�����
	MOV FLAG,1									;flag��ֵΪ1
	CALL CHECK									;���ɷ����ӣ���X��Y�ı�Ϊ��ʵ����ֵ
	CMP FLAG,1									;��������
	JE THERE1									;�����������ж�����
	JMP HERE1									;�����������������������
THERE1:
	MOV MY,1									;�ҵ�������1���Է���������2
	CALL PUTDOWN1									;����v
	CALL ISWIN									;�ж���Ӯ���н����OVER=1
	CALL PRINT									;��ӡ����
	CMP OVER,1									;��Ϸ����																		
	JNZ HERE1
	MOV DX,OFFSET GAMEEND								;��Ϸ��������Ϣ��ʾ
    MOV AH,09H										;����Ļ����ʾ���������
    INT 21H
    MOV AH,02H										;ʹ��10H�жϵ�����λ�ù���																							
    MOV DL,00H										;���ù���������
    MOV DH,11H										;���ù���������
    INT 10H
    MOV STATE,3										;��Ϸ�������˳�
    CALL SLED										;�������ʾ��ǰ״̬
    CALL MUSIC										;��������
GEND1:
	MOV AH,4CH									;�˳���Ϸ
	INT 21H
;=========/*˫��*/========
GAME2:											;˫����Ϸ
    MOV DX,OFFSET COLOR               								;ѡ���Ⱥ��֣�1���֣�2����
    MOV AH,09H										;����Ļ����ʾ���������
    INT 21H
    MOV AH,1										;��Ϸ��ʼ
	INT 21H
	CMP AL,'1'
	JE BLACK										;1Ϊ����
	CMP AL,'2'
	JZ WHITE										;2Ϊ����
	CMP AL,27									;���������ESC
    JZ GEND1										;���˳�
	MOV DX,OFFSET WRONG								;��ʾ�������ʾ��Ϣ
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
	CALL BEEP									;������ʾ��
	JMP GAME2									;��Ϸ����
WHITE:                               									;��ִ�׺��У����ҷ����Ӹ�Ϊ��MY=2��ORDER��Ϊ2
    MOV MY,2										;�ҵ�������1���Է���������2
    MOV STATE,1										;�������꣬���ȴ�����x
    MOV ORDER,2										;�ȴ��Է�����
BLACK:											;��ִ�ں��У����ҷ����Ӹ�Ϊ��MY=1��ORDER��Ϊ1
	MOV AL,2
	MOV AH,0
	INT 10H										;����80*25�ڰ׷�ʽ�������Ļ
	CALL INITIAL									;��ʼ����������ͨ��
	CALL PRINT									;��ӡ����
	CALL SLED									;�������ʾ��ǰ״̬
HERE2:
	CMP STATE,0									;����STATE�����ʾ��Ϣ
	JE SHOW
	MOV DX,OFFSET WAIT1								;��ʾ�ȴ���Ϣ
	MOV AH,09H
	INT 21H										;��������(STATE=0)�����������ȴ�
	MOV AH,02H
	MOV DL,00H									;����17,0��ʼ
	MOV DH,11H									;����������
	INT 10H
	CALL SLED									;�������ʾ��ǰ״̬
WW:
	CMP STATE,0									;����STATE�����ʾ��Ϣ
	JE SHOW
	CMP STATE,4									;���Է��˳���ʤ����������
	JE ILOSE										;������																		
	CMP STATE,5									;��state��ֵΪ5
	JE HQUIT										;���˳�
	JMP WW
SHOW:
	MOV DX,OFFSET PUT								;��ʾ������Ϣ
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
    CALL SLED										;�������ʾ��ǰ״̬
	MOV AH,1									;���������ESC���˳�
	INT 21H
	CMP AL,27									;���������ESC
	JE IQUIT										;���˳�
	JMP RXY2									;������������X Y
ILOSE:											;�����˵���ʾ��Ϣ
	MOV DX,OFFSET SORRY								;��ʾ��Ǹ��Ϣ
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
	CALL SLED									;�������ʾ��ǰ״̬
	CALL MUSIC									;���ò�������
	JMP GEND2									;��Ϸ������Ϣ��ʾ
IQUIT:											;��ʾ���˳�����Ϣ
	CALL SENDQ									;���˳��͸��Է�����Ϣ
	MOV STATE,3									;�Է��ѻ�ʤ
HQUIT:											;��ʾ�Է��˳�����Ϣ
	MOV DX,OFFSET EXIT								;�����˳�����ʾ�˳���Ϣ
	MOV AH,09H									;����Ļ����ʾ�Է��˳�����Ϣ
	INT 21H
	CALL SLED									;�������ʾ��ǰ״̬
	JMP GEND2									;��Ϸ������Ϣ��ʾ
RXY2:											;��¼����X Y(ASCII��)
	MOV X,AL									;��ʾx����������Ļ��					
	INT 21H
	CMP AL,27									;����ESC���˳�
	JE IQUIT										;���˳�
	INT 21H
	CMP AL,27									;����ESC���˳�
	JE IQUIT										;���˳�
	MOV Y,AL									;��ʾy����������Ļ��
N2:	MOV AH,07									;�޻�������
	INT 21H
	CMP AL,27									;����ESC���˳�
	JE IQUIT										;�������˳�
	CMP AL,13									;���ǻس������������ȴ��س�
	JNE N2										;�ٻص�N2
	MOV AH,2
	MOV DL,0AH									;����س�����
	INT 21H
	MOV DL,0DH									;����������
	INT 21H										;����س�����
    mov AL,X                            			                                         				;�������������ֵx�����Ժ���
    mov S1,AL																								
    mov AL,Y										;�������������ֵy�����Ժ���
    mov S2,AL																															
	MOV FLAG,1									;��������
	CALL CHECK									;���ɷ�����
	CMP FLAG,1									;flag=1����������
	JE THERE2									;�����������ж�����
	JMP HERE2									;�����������������������
THERE2:
    CMP ORDER,2										;ѡ���������
    JZ L2
L1:
 	MOV MY,1									;�ҵ�������1���Է���������2
 	JMP L3
L2: 
    MOV MY,2										;�ҵ�������2���Է�������1
L3:
	CALL PUTDOWN2									;����
	CALL ISWIN									;�ж���Ӯ���н����OVER=1
	CALL PRINT									;��ӡ����
    mov AL,S1																								
    mov X,AL										;�������������ֵx�����Ժ���
    mov AL,S2
    mov Y,AL        										;�������������ֵy�����Ժ���                                                
	CALL SEND									;����������
	CMP OVER,1									;���ӽ���
	JE IWIN										;��ת��IWIN�ӳ���
	MOV STATE,1									;��STATE��1����ʾ�������꣬�ȴ��Է���X
	CALL SLED									;�������ʾ��ǰ״̬
	JMP HERE2
IWIN:											;��Ӯ������ʾף����Ϣ����������
	MOV DX,OFFSET CONGRA								;ף����Ϣ��ʾ
	MOV AH,09H									;����Ļ����ʾ���������
	INT 21H
	MOV AH,02H
	MOV DL,00H									;����16,0��ʼ
	MOV DH,10H									;����������
	INT 10H										;��Ļ����ʾ��ʤ������Ϣ
	MOV STATE,2									;��Ӯ��
	CALL SLED									;�������ʾ��ǰ״̬													
	CALL MUSIC									;��������
GEND2:
	MOV AH,4CH									;�˳���Ϸ
	INT 21H
;=========/*�������ʾ�ӳ���*/========
SLED PROC NEAR										;�������ʾ״̬��0��ʾ�����£�1��ʾ�ȴ��Է��£�2��Ӯ�ˣ�3���˳���4�Է�Ӯ�ˣ�5�Է��˳�
	PUSH AX										;����CPU�ֳ�
	PUSH BX
	PUSH DX
    MOV DX,0D413H
	MOV AL,80H									;����8255��ʽ0��A�����
	OUT DX,AL
	MOV AL,STATE									;state��ֵ
	MOV BX,OFFSET LED
	XLAT										;����ܸ���STATE�������
    MOV DX,0D410H
	OUT DX,AL
	POP DX										;�ָ�CPU�ֳ�
	POP BX
	POP AX
	RET										;�ӳ����������
SLED ENDP
;=========/*��ʼ���ӳ���*/========
INITIAL PROC NEAR										;��������Ϣ����ʾ
    MOV AX, CS
    MOV DS, AX
    MOV DX, OFFSET IRQ11                								; DS�жϷ������ε�ַ��DXΪƫ����
    MOV AX, 2573H                       								; AH=25H���ж�����
    INT 21H
    CLI
    MOV DX, 0D84CH                      								; PCI9052 �ж�״̬�����ƼĴ�����ַ��λ
    MOV AL, 43H                         								; ���Ϊ1�����ж�
    OUT DX, AL
    INC DX                              									; PCI9052 �ж�״̬�����ƼĴ�����ַ��λ
    MOV AL, 1DH                        					 			; ������ܵ��ж�״̬
    OUT DX, AL        
    IN AL, 0A1H                         								; ��Ƭ                                                    
    AND AL, 11110111B                   								; ����IRQ11�ж�
    OUT 0A1H,AL
    IN AL, 21H                          									;��Ƭ
    AND AL, 11111011B 
    OUT 21H, AL
    STI       
	MOV AL,00010110B	                						;��ʼ��8253ͨ��0��������ʽ3��������
	MOV DX,0D403H
	OUT DX,AL
	MOV DX,0D400H
	MOV AL,52			               						;������ֵ52
	OUT DX,AL			           
	MOV AX,DATA
	MOV DS,AX
	MOV DX,0D409H									;8251A���ƿڵ�ַ
	MOV AL,0
	OUT DX,AL
	OUT DX,AL
	OUT DX,AL
	MOV AL,40H									;д���������֣��ڲ���λ
	OUT DX,AL
	MOV AL,4EH									;��ʽ�֣��첽��1λֹͣλ��8λ����λ������żУ�飬������16
	OUT DX,AL
	MOV AL,27H									;�����֣������ͣ����з��ͺͽ��գ������ն�׼���ã�������ַ�
	OUT DX,AL							
	RET										;�ӳ����������
INITIAL ENDP
;=========/*��������λ���Ƿ�Ϸ�*/========
CHECK PROC NEAR										;����λ���Ƿ�Ϸ��ļ����Ϣ 
	PUSH AX										;����CPU�ֳ�
	PUSH BX
	PUSH CX
	PUSH DX
    CMP X,'a'										;�������a���Ϸ�
	JL CMPDX									;����������ж�
	CMP X,'f'                           								;���������f�����Ϸ�
	JG ERR										;������Ϣ
	SUB X,39 
	JMP CMPDY
CMPDX:											;X�������ж�
	CMP X,'1'                           								;����С��1�����Ϸ�
	JL ERR										;������Ϣ
	CMP X,'9'										;����С��9�����Ϸ�
	JG ERR										;������Ϣ
CMPDY:                                  									;����X�Ϸ����Ƚ�Y
    CMP Y,'A'										;����С��A���Ϸ�
	JL CMPDY1									;����������ж� 
	CMP Y,'F'										;�������F�����Ϸ�
	JG ERR 										;������Ϣ
	SUB Y,7
	JMP SUBXY
CMPDY1:											;Y�������ж�
    CMP Y,'1'										;����С��1�����Ϸ�
	JL ERR										;���Ϸ�
	CMP Y,'9'										;����С��9�����Ϸ�
	JG ERR										;���Ϸ�
SUBXY:
    SUB X,'1'                            									;��X�ı�Ϊ��ʵ��ֵ
	SUB Y,'1'										;��Y�ı�Ϊ��ʵ��ֵ
	MOV CX,0									;����ָ��
	MOV CL,X
	MOV BX,0									;��ռĴ���
MULX1: 
    ADD BL,15										;��������15��λ
    LOOP MULX1										;ѭ��MULX1
	ADD BL,Y										;������������Y��ֵ
	CMP CHESSBOARD[BX],1                 							;���˴��������ӣ����벻�Ϸ�
	JE ERR							;
	CMP CHESSBOARD[BX],2								;���˴�û�����ӣ�����Ϸ�
	JNE RETURNC 
ERR:
    MOV FLAG,0                           								;���ڲ��Ϸ������룬��ʾ������Ϣ��������������
	MOV DX,OFFSET ERROR
	MOV AH,09H									;����Ļ����ʾ����������Ϣ
    INT 21H
	CALL BEEP									;��������
RETURNC:
    POP DX										;�ָ�CPU�ֳ�
    POP CX
    POP BX
    POP AX
	RET										;�ӳ����������
CHECK ENDP
;=========/*���������ӳ���*/========
PUTDOWN1 PROC NEAR									;�������ӵ���Ϣ��ʾ					
	PUSH AX										;����CPU�ֳ�
	PUSH BX
	PUSH CX
	PUSH DX
	MOV CX,0									;�ַ�ָ���ʼ��
	MOV CL,X
	MOV BX,0									;��ռĴ���
MULX2: 
	ADD BL,15									;�ַ�ָ������15���ֽ�
	LOOP MULX2									;ѭ��MULX2
	ADD BL,Y										;�ַ�ָ������Y���ֽ�
	CMP TEMP,0                         	 							;����TEMPֵ���������ú��ӺͰ���
	JE MM1
	MOV CHESSBOARD[BX],2								;�˴�û������
	MOV TEMP,0									;����TEMPֵ���������ú��ӺͰ���
	JMP YY1
MM1:	
    MOV CHESSBOARD[BX],1									;�˴���������
    MOV TEMP,1										;����TEMPֵ���������ú��ӺͰ���
YY1:	
    POP DX										;�ָ�CPU�ֳ�	
	POP CX
	POP BX
	POP AX
	RET										;�ӳ����������
PUTDOWN1 ENDP
;=========/*˫�������ӳ���*/========
PUTDOWN2 PROC NEAR									;˫�����ӵ���Ϣ��ʾ				
	PUSH AX										;����CPU�ֳ�
	PUSH BX
	PUSH CX
	PUSH DX
	MOV CX,0									;�ַ�ָ���ʼ��
	MOV CL,X	
	MOV BX,0									;��ռĴ���
MULX4: 
	ADD BL,15									;�ַ�ָ������15���ֽ�
	LOOP MULX4									;ѭ��MULX4
	ADD BL,Y										;�ַ�ָ������Y���ֽ�
	CMP MY,1									;�ҵ�������1���Է���������2
	JE MM2
	MOV CHESSBOARD[BX],2								;�˴�û������
	JMP YY2										;���ص��ô�
MM2:													
    MOV CHESSBOARD[BX],1									;�˴���������
YY2:														
	POP DX										;�ָ�CPU�ֳ�
	POP CX
	POP BX
	POP AX
	RET
PUTDOWN2 ENDP
;=========/*�ж��Ƿ��ʤ*/========
ISWIN PROC NEAR										;�һ�ʤ����Ϣ��ʾ
    MOV X,0										;��ʼ��X��Y
    MOV Y,0
LOOPY:
    MOV CX,0										;�ַ�ָ���ʼ��
	MOV CL,X
	MOV BX,0									;��ռĴ���
MULX3: 
    ADD BL,15										;�ַ�ָ������15���ֽ�
	LOOP MULX3									;ѭ��MULX3
	ADD BL,Y                           								;BX=15*X+Y
	MOV DL,CHESSBOARD[BX]               																	
	CMP ORDER,2                         								;����ִ�ڻ�ִ���ж��Լ��Ƿ��ʤ
	JZ L4
	CMP DL,1										;�жϺ����Ƿ��������
	JE PANDUAN									;�жϺ����Ƿ��������5��
	JMP NEXT									;������һ���ж�
L4:
	CMP DL,2										;�жϰ����Ƿ��������
    JE PANDUAN										;�жϰ����Ƿ�����5��
	JMP NEXT 									;������һ���ж�
PANDUAN: 										;��Ϸʤ�����ж�
    CALL TEST1                          								;����
	CMP OVER,1									;��������5����Ϸ����
	JE RETURNISWIN									;����ʤ�����ж�
	CALL TEST2                         								;����
    CMP OVER,1										;��������5����Ϸ����
	JE RETURNISWIN									;����ʤ�����ж�
	CALL TEST3                          								;б��
	CMP OVER,1									;б������5����Ϸ����
	JE RETURNISWIN									;����ʤ�����ж�
	CALL TEST4                          								;б��
    CMP OVER,1										;б������5����Ϸ����
	JE RETURNISWIN									;����ʤ�����ж�
NEXT: 
    INC Y											;Y���ַ�ָ������
	CMP Y,15										;�Ƚ�Y��ֵ
	JNE LOOPY
	MOV Y,0										;��ʼ��Y��ֵ
	INC X										;X���ַ�ָ������
	CMP X,15										;�Ƚ�X��ֵ
	JNE LOOPY
RETURNISWIN:
    RET											;�ӳ����������
ISWIN ENDP
;=========/*�жϺ����Ƿ�����5��*/========
TEST1 PROC NEAR										;�����ж��ӳ���
    PUSH BX										;����cpu�ֳ�
    CMP Y,10	 									;�жϺ����Ƿ���10���ֽ�
    JG RETURN1										;��С�������������5��
    CMP DL,CHESSBOARD[BX+1]								;�ж����̺����Ƿ���2����������һ��
    JNE RETURN1
    CMP DL,CHESSBOARD[BX+2]								;�ж����̺����Ƿ���3����������һ��
    JNE RETURN1 
    CMP DL,CHESSBOARD[BX+3]								;�ж����̺����Ƿ���4����������һ��
    JNE RETURN1
    CMP DL,CHESSBOARD[BX+4]								;�ж����̺����Ƿ���5����������һ��
    JNE RETURN1
    MOV OVER,1										;��Ϸ����
RETURN1: 
    POP BX										;�ָ�cpu�ֳ�
    RET											;�ӳ����������
TEST1 ENDP
;=========/*�ж������Ƿ�����5��*/========
TEST2 PROC NEAR										;�����ж��ӳ���
   PUSH BX										;����cpu�ֳ�
   CMP X,10										;�ж������Ƿ���10���ֽ�
   JG RETURN2										;��С��������������5��
   CMP DL,CHESSBOARD[BX+15]								;�ж����������Ƿ���2����������һ��
   JNE RETURN2
   CMP DL,CHESSBOARD[BX+30]								;�ж����������Ƿ���3����������һ��
   JNE RETURN2
   CMP DL,CHESSBOARD[BX+45]								;�ж����������Ƿ���4����������һ��
   JNE RETURN2
   CMP DL,CHESSBOARD[BX+60]								;�ж����������Ƿ���5����������һ��
   JNE RETURN2
   MOV OVER,1   										;��Ϸ����
RETURN2: 
   POP BX
   RET											;�ӳ����������
TEST2 ENDP
;=========/*�ж�б���Ƿ�����5��*/========
TEST3 PROC NEAR										;б���ж��ӳ���
   PUSH BX										;����cpu�ֳ�
   CMP X,4		      								;�ж������Ƿ���4���ֽ�                  																	
   JL RETURN3										;��С����б�ϲ�������5��
   CMP Y,10										;�жϺ����Ƿ���10���ֽ�
   JG RETURN3
   CMP DL,CHESSBOARD[BX-14]								;�ж�����б���Ƿ���2����������һ��
   JNE RETURN3
   CMP DL,CHESSBOARD[BX-28]								;�ж�����б���Ƿ���3����������һ��
   JNE RETURN3
   CMP DL,CHESSBOARD[BX-42]								;�ж�����б���Ƿ���4����������һ��
   JNE RETURN3
   CMP DL,CHESSBOARD[BX-56]								;�ж�����б���Ƿ���5����������һ��
   JNE RETURN3
   MOV OVER,1   										;��Ϸ����
RETURN3: 
   POP BX
   RET											;�ӳ����������
TEST3 ENDP
;=========/*�ж�б���Ƿ�����5��*/========
TEST4 PROC NEAR										;б���ж��ӳ���
   PUSH BX										;����cpu�ֳ�
   CMP X,10										;�ж������Ƿ���10���ֽ�
   JG RETURN4										;��С����б�²�������5��
   CMP Y,10										;�жϺ����Ƿ���10���ֽ�
   JG RETURN4         									;��С����б�²�������5��  ;����б��
   CMP DL,CHESSBOARD[BX+16]								;�ж�����б���Ƿ���2����������һ�� 
   JNE RETURN4
   CMP DL,CHESSBOARD[BX+32]								;�ж�����б���Ƿ���3����������һ��
   JNE RETURN4
   CMP DL,CHESSBOARD[BX+48]								;�ж�����б���Ƿ���4����������һ��
   JNE RETURN4
   CMP DL,CHESSBOARD[BX+64]								;�ж�����б���Ƿ���5����������һ��
	JNE RETURN4
	MOV OVER,1   									;��Ϸ����																		
RETURN4: 
   POP BX
   RET											;�ӳ����������
TEST4 ENDP 	 
;=========/*��ӡ����*/========
PRINT PROC NEAR										;��ӡ����
	PUSH SI
	PUSH AX										;����CPU�ֳ�
	PUSH DX
	MOV AH,02H									;ʹ��10H�жϵ����ù��λ�ù���
	MOV DL,00H									;����0,0��ʼ
    MOV DH,00H										;����������
    INT 10H	
    MOV DX,OFFSET TI									;ָ���ַ���  
    MOV AH,09H										;��Ļ��ʾ�ַ���
    INT 21H
	MOV X,0										;��ʼ��X Y SI
	MOV Y,0
	MOV SI,0
LOOP2: 
    CMP Y,0										;�ж�Y�Ƿ�Ϊ0
    JNE NOTHEAD
    MOV DL,X
    ADD DL,31H										;X���ַ�ָ������
	CMP DL,'9'									;�ж�X�Ƿ���ڵ���9
	JLE PP
	ADD DL,39									;X���ַ�ָ������39���ֽ� 
PP:
    MOV AH,02H
    INT 21H										;ʹ��21H�жϵ�����ַ�����
NOTHEAD:
    MOV DL,CHESSBOARD[SI]
    MOV AH,02H
	INT 21H
	INC SI										;SI��Yָ��ͬʱ����1���ֽڣ�ָ����һ���ַ�
	INC Y										;SI��Yָ��ͬʱ����1���ֽڣ�ָ����һ���ַ�
	CMP Y,15										;�ж�Y�Ĵ�С
	JE NEXTLINE
	MOV DL,'-'									;���һ��'-'
	MOV AH,02H									;ʹ��21H�жϵ�����ַ�����
	INT 21H
	JMP LOOP2									;�ص�ѭ��2
NEXTLINE:
    MOV DL,32
    MOV AH,02H
	INT 21H
	MOV DL,0AH									;���һ���س�����0AH��
	MOV AH,02H									;ʹ��21H�жϵ�����ַ�����
	INT 21H
	MOV DL,0DH									;���һ�����з���0AD��
	MOV AH,02H									;ʹ��21H�жϵ�����ַ�����
	INT 21H
    INC X											;X���ַ�ָ������1���ֽ�
	MOV Y,0										;��ʼ��Y
    CMP X,15
	JNE LOOP2
    MOV DX,OFFSET CLEAN									;������Ļ����Ϣ��ʾ
    MOV AH,09H										;ʹ��21H�жϵ���ʾ�ַ�������
    INT 21H
    MOV AH,02H										;ʹ��10H�жϵ����ù��λ�ù���
	MOV DL,00H									;����0,17��ʼ
    MOV DH,10H										;���ù���������
	INT 10H
	POP DX										;�ָ�CPU�ֳ�
	POP AX
	POP SI
	RET										;�ӳ����������
PRINT ENDP 
;=========/*����������*/========
BEEP PROC NEAR										;�����������ӳ���
        PUSH CX										;����cpu�ֳ�
        MOV AL,10110110B									;������2��д�͸ߡ���ʽ3��������
        OUT 43H,AL										;д�������
        MOV AX,1000
        OUT 42H,AL										;д���8λ����ֵ
        MOV AL,AH
        OUT 42H,AL										;д���8λ����ֵ
        MOV AL,AH
        OUT 42H,AL
        MOV AL,AH
        OUT 42H,AL
        IN AL,61H										;PB�Ķ˿ڵ�ַ
        MOV AH,AL
        OR AL,03H										;��ʾ��������ֻ��PB0PB1ͬʱΪ�ߵ�ƽ ���������ܷ���
        OUT 61H,AL										;ֱ�ӿ��Ʒ���
        MOV CX,0										;��ʼ���ַ�ָ��
L0:     LOOP L0
        DEC BL										;�ַ�ָ������1���ֽ�
        JNZ L0
        MOV AL,AH
        OUT 61H,AL										;�رշ���
        POP CX										;�ָ�cpu�ֳ�
        RET											;�ӳ����������
BEEP ENDP
;=========/*��������*/========
MUSIC PROC NEAR										;���������ӳ���
        MOV AX,DATA
        MOV DS,AX
        LEA SI,MUS_FREQ									;��Ƶ�ʱ�ƫ�Ƶ�ַ��SI
        LEA BP,MUS_TIME									;������ʱ���ƫ�Ƶ�ַ��BP
FREQ:
        MOV DI,[SI]										;��Ƶ��ֵ����DI
        CMP DI,-1
        JE END_MUS
        MOV BX,DS:[BP]									;ȡ����ʱ������BX
        CALL SOUND										;����SOUND�ӳ��򷢳�����
        ADD SI,2
        ADD BP,2
        JMP FREQ
END_MUS:
		RET									;�ӳ����������
MUSIC ENDP

SOUND PROC NEAR									;������������Ϣ	
        PUSH AX										;����CPU�ֳ�
        PUSH BX
        PUSH CX
        PUSH DX
        PUSH DI
        MOV AL,0B6H										;��ʼ��8253��ʹ����������������ź�
        OUT 43H,AL										;43H��8253���ƼĴ����Ķ˿ڵ�ַ
        MOV DX,12H										;���ñ�����
        MOV AX,34DCH									;DX:AX�е�ֵ��Ϊ1234DCH
        DIV DI										;���̣�AX��ΪԤ��ֵ
        OUT 42H,AL										;����LSB
        MOV AL,AH
        OUT 42H,AL										;����MSB
        IN AL,61H										;��8255�˿�B��61H��ԭֵ
        MOV AH,AL										;����˿�ԭֵ
        OR AL,3										;��������
        OUT 61H,AL										;��ͨ������
DELAY:  MOV CX,0BBBBH									;��80486/DX2/66��ȡ
DL10MS: LOOP DL10MS									;��ʱ=BXֵ*10ms
        DEC BX
        JNZ DELAY										;��ʱ=BXֵ*10ms
        MOV AL,AH										;�ָ�8255�˿�61H��ԭֵԭֵ
        OUT 61H,AL										;�ر�������
        POP DI										;�ָ�CPU�ֳ�
        POP DX							
        POP CX
        POP BX
        POP AX
        RET											;�ӳ����������
SOUND ENDP
;=========/*����X Y*/========
SEND PROC NEAR										;��ѯ��ʽ����X Y OVER
	PUSH AX										;����CPU�ֳ�
	PUSH DX
LOOPX:
	MOV DX,0D409H
	IN AL,DX
	TEST AL,1
	JZ LOOPX
	MOV DX,0D408H
	MOV AL,X
	OUT DX,AL
LOOPW: 
    MOV DX,0D409H
    IN AL,DX
    TEST AL,1
    JZ LOOPW
    MOV DX,0D408H
    MOV AL,Y
    OUT DX,AL
	POP DX										;�ָ�CPU�ֳ�
	POP AX
	RET										;�ӳ����������
SEND ENDP
;/*�������˳�����Ϣ*/
SENDQ PROC NEAR																															
	PUSH AX										;����CPU�ֳ�
	PUSH DX
LOOY:
	MOV DX,0D409H
	IN AL,DX
	TEST AL,1
	JZ LOOY
	MOV DX,0D408H
	MOV AL,59									;���˳�����59(�ܿ���Ч�����ַ�)
    OUT DX,AL
	POP DX										;�ָ�CPU�ֳ�
	POP AX
	RET										;�ӳ����������
SENDQ ENDP
;=========/*���ͻ�ʤ��Ϣ*/========
SENDW PROC NEAR									;�������˳�����Ϣ
	PUSH AX										;����CPU�ֳ�
	PUSH DX
LOY:
	MOV DX,0D409H
	IN AL,DX
	TEST AL,1
	JZ LOY
	MOV DX,0D408H
	MOV AL,60									;�һ�ʤ����60
    OUT DX,AL
	POP DX										;�ָ�CPU�ֳ�
	POP AX
	RET										;�ӳ����������
SENDW ENDP
;=========/*�ж��ӳ���*/========
IRQ11 PROC FAR					    
	PUSH AX										;����CPU�ֳ�
	PUSH DX
    PUSH CX
	MOV DX,0D408H
	IN AL,DX
    CMP AL,59                           			
    JNZ L9											;���Է��˳�����״̬��Ϊ5
    MOV STATE,5										;�Է��˳�
    CALL SLED										;�������ʾ��ǰ״̬5
    JMP CLE										;�������
L9:    
    CMP AL,60
    jz hwin																				
    CMP STATE,1                         								;STATE=1��ʾ�������꣬׼������X
    JE XX											;׼������x
    CMP STATE,2                        			 					;STATE=2��ʾ׼������Y
    JE YY											;׼������y
    JMP CLE										;��������
XX: 											;����X����STATE=2
    MOV X,AL										;����x������
    MOV STATE,2
    JMP CLE										;����������ʾ����
YY:									
    MOV Y,AL										;����y
    CMP ORDER,2										;��������
    JZ L7
    MOV MY,2										;�ҵ�������2
    call check										;��������Ƿ�Ϸ�
    CALL PUTDOWN2									;˫������
    CALL PRINT										;��ӡ����
    MOV MY,1										;�ҵ�������1
    mov state,0										;��Ϸ���ڽ�����
    call sled      										;�������ʾ��ǰ״̬                                             
    JMP CLE										;������Ļ����
L7: 
    MOV MY,1										;�ҵ�������1���Է���������2
    call check										;��������Ƿ�Ϸ�
    CALL PUTDOWN2									;����
    CALL PRINT										;��ӡ����
    MOV MY,2										;�ҵ�������2���Է�������1
    mov state,0										;��������
    call sled   										;�������ʾ��ǰ״̬                                                 
    JMP CLE										;��Ļ���̸���
HWIN:											;�����Ӯ�ˣ�STATE=4
    MOV STATE,4										;�Է�Ӯ��
    CALL SLED    										;�������ʾ��ǰ״̬                                                  
    JMP CLE										;�������
CLE:
	MOV AL,20H									;���PCI9052�жϱ�־
	OUT 20H,AL
    mov al,20h
    out 0a0h,al 
	MOV DX,0D84DH
	MOV AL,1DH
	OUT DX,AL									;��9052�жϱ�־
    POP CX
	POP DX										;�ָ�CPU�ֳ�
	POP AX
	IRET										;�жϷ���
IRQ11 ENDP
CODE ENDS
	END START		 