/*
 -- ============================================================================
 -- FILE NAME	: bus.h
 -- DESCRIPTION : �o�X�w�b�_
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

`ifndef __BUS_HEADER__
	`define __BUS_HEADER__			 // �C���N���[�h�K�[�h

	/********** �o�X�}�X�^ *********/
	`define BUS_MASTER_CH	   4	 // �o�X�}�X�^�`���l����
	`define BUS_MASTER_INDEX_W 2	 // �o�X�}�X�^�C���f�b�N�X��

	/********** �o�X���̏��L�� *********/
	`define BusOwnerBus		   1:0	 // �o�X����ԃo�X
	`define BUS_OWNER_MASTER_0 2'h0	 // �o�X���̏��L�� �F �o�X�}�X�^0��
	`define BUS_OWNER_MASTER_1 2'h1	 // �o�X���̏��L�� �F �o�X�}�X�^1��
	`define BUS_OWNER_MASTER_2 2'h2	 // �o�X���̏��L�� �F �o�X�}�X�^2��
	`define BUS_OWNER_MASTER_3 2'h3	 // �o�X���̏��L�� �F �o�X�}�X�^3��

	/********** �o�X�X���[�u *********/
	`define BUS_SLAVE_CH	   8	 // �o�X�X���[�u�`���l����
	`define BUS_SLAVE_INDEX_W  3	 // �o�X�X���[�u�C���f�b�N�X��
	`define BusSlaveIndexBus   2:0	 // �o�X�X���[�u�C���f�b�N�X�o�X
	`define BusSlaveIndexLoc   29:27 // �o�X�X���[�u�C���f�b�N�X�̈ʒu

	`define BUS_SLAVE_0		   0	 // �o�X�X���[�u0��
	`define BUS_SLAVE_1		   1	 // �o�X�X���[�u1��
	`define BUS_SLAVE_2		   2	 // �o�X�X���[�u2��
	`define BUS_SLAVE_3		   3	 // �o�X�X���[�u3��
	`define BUS_SLAVE_4		   4	 // �o�X�X���[�u4��
	`define BUS_SLAVE_5		   5	 // �o�X�X���[�u5��
	`define BUS_SLAVE_6		   6	 // �o�X�X���[�u6��
	`define BUS_SLAVE_7		   7	 // �o�X�X���[�u7��

`endif
