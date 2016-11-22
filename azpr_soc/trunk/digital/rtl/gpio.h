/*
 -- ============================================================================
 -- FILE NAME	: gpio.h
 -- DESCRIPTION : General Purpose I/O�w�b�_
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

`ifndef __GPIO_HEADER__
   `define __GPIO_HEADER__			// �C���N���[�h�K�[�h

	/********** �|�[�g���̒�` **********/
	`define GPIO_IN_CH		   4	// ���̓|�[�g��
	`define GPIO_OUT_CH		   18	// �o�̓|�[�g��
	`define GPIO_IO_CH		   16	// ���o�̓|�[�g��
  
	/********** �o�X **********/
	`define GpioAddrBus		   1:0	// �A�h���X�o�X
	`define GPIO_ADDR_W		   2	// �A�h���X��
	`define GpioAddrLoc		   1:0	// �A�h���X�̈ʒu
	/********** �A�h���X�}�b�v **********/
	`define GPIO_ADDR_IN_DATA  2'h0 // ���䃌�W�X�^ 0 : ���̓|�[�g
	`define GPIO_ADDR_OUT_DATA 2'h1 // ���䃌�W�X�^ 1 : �o�̓|�[�g
	`define GPIO_ADDR_IO_DATA  2'h2 // ���䃌�W�X�^ 2 : ���o�̓|�[�g
	`define GPIO_ADDR_IO_DIR   2'h3 // ���䃌�W�X�^ 3 : ���o�͕���
	/********** ���o�͕��� **********/
	`define GPIO_DIR_IN		   1'b0 // ����
	`define GPIO_DIR_OUT	   1'b1 // �o��

`endif
