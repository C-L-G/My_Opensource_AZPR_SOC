/*
 -- ============================================================================
 -- FILE NAME	: spm.h
 -- DESCRIPTION : �X�N���b�`�p�b�h�������w�b�_
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

`ifndef __SPM_HEADER__
	`define __SPM_HEADER__			  // �C���N���[�h�K�[�h

/*
 * �ySPM�̃T�C�Y�ɂ��āz
 * �ESPM�̃T�C�Y��ύX����ɂ́A
 *	 SPM_SIZE�ASPM_DEPTH�ASPM_ADDR_W�ASpmAddrBus�ASpmAddrLoc��ύX���ĉ������B
 * �ESPM_SIZE��SPM�̃T�C�Y���`���Ă��܂��B
 * �ESPM_DEPTH��SPM�̐[�����`���Ă��܂��B
 *	 SPM�̕��͊�{�I��32bit�i4Byte�j�Œ�Ȃ̂ŁA
 *	 SPM_DEPTH��SPM_SIZE��4�Ŋ������l�ɂȂ�܂��B
 * �ESPM_ADDR_W��SPM�̃A�h���X�����`���Ă���A
 *	 SPM_DEPTH��log2�����l�ɂȂ�܂��B
 * �ESpmAddrBus��SpmAddrLoc��SPM_ADDR_W�̃o�X�ł��B
 *	 SPM_ADDR_W-1:0�Ƃ��ĉ������B
 *
 * �ySPM�̃T�C�Y�̗�z
 * �ESPM�̃T�C�Y��16384Byte�i16KB�j�̏ꍇ�A
 *	 SPM_DEPTH��16384��4��4096
 *	 SPM_ADDR_W��log2(4096)��12�ƂȂ�܂��B
 */

	`define SPM_SIZE   16384 // SPM�̃T�C�Y
	`define SPM_DEPTH  4096	 // SPM�̐[��
	`define SPM_ADDR_W 12	 // �A�h���X��
	`define SpmAddrBus 11:0	 // �A�h���X�o�X
	`define SpmAddrLoc 11:0	 // �A�h���X�̈ʒu

`endif
