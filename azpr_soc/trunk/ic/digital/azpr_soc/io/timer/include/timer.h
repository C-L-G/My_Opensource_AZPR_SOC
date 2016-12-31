/*
 -- ============================================================================
 -- FILE NAME	: timer.h
 -- DESCRIPTION : �^�C�}�w�b�_
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

`ifndef __TIMER_HEADER__
	`define __TIMER_HEADER__		 // �C���N���[�h�K�[�h

	/********** �o�X **********/
	`define TIMER_ADDR_W		2	 // �A�h���X��
	`define TimerAddrBus		1:0	 // �A�h���X�o�X
	`define TimerAddrLoc		1:0	 // �A�h���X�̈ʒu
	/********** �A�h���X�}�b�v **********/
	`define TIMER_ADDR_CTRL		2'h0 // ���䃌�W�X�^ 0 : �R���g���[��
	`define TIMER_ADDR_INTR		2'h1 // ���䃌�W�X�^ 1 : ���荞��
	`define TIMER_ADDR_EXPR		2'h2 // ���䃌�W�X�^ 2 : �����l
	`define TIMER_ADDR_COUNTER	2'h3 // ���䃌�W�X�^ 3 : �J�E���^
	/********** �r�b�g�}�b�v **********/
	// ���䃌�W�X�^ 0 : �R���g���[��
	`define TimerStartLoc		0	 // �X�^�[�g�r�b�g�̈ʒu
	`define TimerModeLoc		1	 // ���[�h�r�b�g�̈ʒu
	`define TIMER_MODE_ONE_SHOT 1'b0 // ���[�h : �����V���b�g�^�C�}
	`define TIMER_MODE_PERIODIC 1'b1 // ���[�h : �����^�C�}
	// ���䃌�W�X�^ 1 : ���荞�ݗv��
	`define TimerIrqLoc			0	 // ���荞�ݗv���r�b�g�̈ʒu

`endif
