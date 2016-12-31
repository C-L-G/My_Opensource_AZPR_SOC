/*
 -- ============================================================================
 -- FILE NAME	: global_config.h
 -- DESCRIPTION : �S�̐ݒ�
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

`ifndef __GLOBAL_CONFIG_HEADER__
	`define __GLOBAL_CONFIG_HEADER__	// �C���N���[�h�K�[�h

//------------------------------------------------------------------------------
// �ݒ荀��
//------------------------------------------------------------------------------
	/********** �^�[�Q�b�g�f�o�C�X : �����ꂩ1��I�� **********/
//	`define TARGET_DEV_MFPGA_SPAR3E		// �}���c�]���{�[�h
	`define TARGET_DEV_AZPR_EV_BOARD	// AZPR�I���W�i���]���{�[�h

	/********** ���Z�b�g�ɐ� : �����ꂩ1��I�� **********/
//	`define POSITIVE_RESET				// Active High
	`define NEGATIVE_RESET				// Active Low

	/********** ����������M���̋ɐ� : �����ꂩ1��I�� **********/
	`define POSITIVE_MEMORY				// Active High
//	`define NEGATIVE_MEMORY				// Active Low

	/********** I/O�ݒ� : ��������I/O���`**********/
	`define IMPLEMENT_TIMER				// �^�C�}
	`define IMPLEMENT_UART				// UART
	`define IMPLEMENT_GPIO				// General Purpose I/O

//------------------------------------------------------------------------------
// �ݒ�ɉ����ăp�����[�^�𐶐�
//------------------------------------------------------------------------------
	/********** ���Z�b�g�ɐ� *********/
	// Active Low
	`ifdef POSITIVE_RESET
		`define RESET_EDGE	  posedge	// ���Z�b�g�G�b�W
		`define RESET_ENABLE  1'b1		// ���Z�b�g�L��
		`define RESET_DISABLE 1'b0		// ���Z�b�g����
	`endif
	// Active High
	`ifdef NEGATIVE_RESET
		`define RESET_EDGE	  negedge	// ���Z�b�g�G�b�W
		`define RESET_ENABLE  1'b0		// ���Z�b�g�L��
		`define RESET_DISABLE 1'b1		// ���Z�b�g����
	`endif

	/********** ����������M���̋ɐ� *********/
	// Actoive High
	`ifdef POSITIVE_MEMORY
		`define MEM_ENABLE	  1'b1		// �������L��
		`define MEM_DISABLE	  1'b0		// ����������
	`endif
	// Active Low
	`ifdef NEGATIVE_MEMORY
		`define MEM_ENABLE	  1'b0		// �������L��
		`define MEM_DISABLE	  1'b1		// ����������
	`endif

`endif
