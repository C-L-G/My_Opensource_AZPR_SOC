`ifndef __UART_HEADER__
	`define __UART_HEADER__			// �C���N���[�h�K�[�h

	/********** �����J�E���^ *********/
	`define UART_DIV_RATE	   9'd260  // �������[�g
	`define UART_DIV_CNT_W	   9	   // �����J�E���^��
	`define UartDivCntBus	   8:0	   // �����J�E���^�o�X
	/********** �A�h���X�o�X **********/
	`define UartAddrBus		   0:0	// �A�h���X�o�X
	`define UART_ADDR_W		   1	// �A�h���X��
	`define UartAddrLoc		   0:0	// �A�h���X�̈ʒu
	/********** �A�h���X�}�b�v **********/
	`define UART_ADDR_STATUS   1'h0 // ���䃌�W�X�^ 0 : �X�e�[�^�X
	`define UART_ADDR_DATA	   1'h1 // ���䃌�W�X�^ 1 : ����M�f�[�^
	/********** �r�b�g�}�b�v **********/
	`define UartCtrlIrqRx	   0	// ��M�������荞��
	`define UartCtrlIrqTx	   1	// ���M�������荞��
	`define UartCtrlBusyRx	   2	// ��M���t���O
	`define UartCtrlBusyTx	   3	// ���M���t���O
	/********** ����M�X�e�[�^�X **********/
	`define UartStateBus	   0:0	// �X�e�[�^�X�o�X
	`define UART_STATE_IDLE	   1'b0 // �X�e�[�^�X : �A�C�h�����
	`define UART_STATE_TX	   1'b1 // �X�e�[�^�X : ���M��
	`define UART_STATE_RX	   1'b1 // �X�e�[�^�X : ��M��
	/********** �r�b�g�J�E���^ **********/
	`define UartBitCntBus	   3:0	// �r�b�g�J�E���^�o�X
	`define UART_BIT_CNT_W	   4	// �r�b�g�J�E���^��
	`define UART_BIT_CNT_START 4'h0 // �J�E���g�l : �X�^�[�g�r�b�g
	`define UART_BIT_CNT_MSB   4'h8 // �J�E���g�l : �f�[�^��MSB
	`define UART_BIT_CNT_STOP  4'h9 // �J�E���g�l : �X�g�b�v�r�b�g
	/********** �r�b�g���x�� **********/
	`define UART_START_BIT	   1'b0 // �X�^�[�g�r�b�g
	`define UART_STOP_BIT	   1'b1 // �X�g�b�v�r�b�g

`endif
