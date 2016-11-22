/* 
 -- ============================================================================
 -- FILE NAME	: chip.v
 -- DESCRIPTION : �`�b�v
 -- ----------------------------------------------------------------------------
 -- Revision  Date		  Coding_by	 Comment
 -- 1.0.0	  2011/06/27  suito		 �V�K�쐬
 -- ============================================================================
*/

/********** ���ʃw�b�_�t�@�C�� **********/
`include "nettype.h"
`include "stddef.h"
`include "global_config.h"

/********** �ʃw�b�_�t�@�C�� **********/
`include "cpu.h"
`include "bus.h"
`include "rom.h"
`include "timer.h"
`include "uart.h"
`include "gpio.h"

/********** ���W���[�� **********/
module chip (
	/********** �N���b�N & ���Z�b�g **********/
	input  wire						 clk,		  // �N���b�N
	input  wire						 clk_,		  // ���]�N���b�N
	input  wire						 reset		  // ���Z�b�g
	/********** UART  **********/
`ifdef IMPLEMENT_UART // UART����
	, input	 wire					 uart_rx	  // UART��M�M��
	, output wire					 uart_tx	  // UART���M�M��
`endif
	/********** �ėp���o�̓|�[�g **********/
`ifdef IMPLEMENT_GPIO // GPIO����
`ifdef GPIO_IN_CH	 // ���̓|�[�g�̎���
	, input wire [`GPIO_IN_CH-1:0]	 gpio_in	  // ���̓|�[�g
`endif
`ifdef GPIO_OUT_CH	 // �o�̓|�[�g�̎���
	, output wire [`GPIO_OUT_CH-1:0] gpio_out	  // �o�̓|�[�g
`endif
`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̎���
	, inout wire [`GPIO_IO_CH-1:0]	 gpio_io	  // ���o�̓|�[�g
`endif
`endif
);

	/********** �o�X�}�X�^�M�� **********/
	// �S�}�X�^���ʐM��~
	wire [`WordDataBus] m_rd_data;				  // �ǂݏo���f�[�^
	wire				m_rdy_;					  // ���f�B
	// �o�X�}�X�^0
	wire				m0_req_;				  // �o�X���N�G�X�g
	wire [`WordAddrBus] m0_addr;				  // �A�h���X
	wire				m0_as_;					  // �A�h���X�X�g���[�u
	wire				m0_rw;					  // �ǂ݁^����
	wire [`WordDataBus] m0_wr_data;				  // �������݃f�[�^
	wire				m0_grnt_;				  // �o�X�O�����g
	// �o�X�}�X�^1
	wire				m1_req_;				  // �o�X���N�G�X�g
	wire [`WordAddrBus] m1_addr;				  // �A�h���X
	wire				m1_as_;					  // �A�h���X�X�g���[�u
	wire				m1_rw;					  // �ǂ݁^����
	wire [`WordDataBus] m1_wr_data;				  // �������݃f�[�^
	wire				m1_grnt_;				  // �o�X�O�����g
	// �o�X�}�X�^2
	wire				m2_req_;				  // �o�X���N�G�X�g
	wire [`WordAddrBus] m2_addr;				  // �A�h���X
	wire				m2_as_;					  // �A�h���X�X�g���[�u
	wire				m2_rw;					  // �ǂ݁^����
	wire [`WordDataBus] m2_wr_data;				  // �������݃f�[�^
	wire				m2_grnt_;				  // �o�X�O�����g
	// �o�X�}�X�^3
	wire				m3_req_;				  // �o�X���N�G�X�g
	wire [`WordAddrBus] m3_addr;				  // �A�h���X
	wire				m3_as_;					  // �A�h���X�X�g���[�u
	wire				m3_rw;					  // �ǂ݁^����
	wire [`WordDataBus] m3_wr_data;				  // �������݃f�[�^
	wire				m3_grnt_;				  // �o�X�O�����g
	/********** �o�X�X���[�u�M�� **********/
	// �S�X���[�u���ʐM��
	wire [`WordAddrBus] s_addr;					  // �A�h���X
	wire				s_as_;					  // �A�h���X�X�g���[�u
	wire				s_rw;					  // �ǂ݁^����
	wire [`WordDataBus] s_wr_data;				  // �������݃f�[�^
	// �o�X�X���[�u0��
	wire [`WordDataBus] s0_rd_data;				  // �ǂݏo���f�[�^
	wire				s0_rdy_;				  // ���f�B
	wire				s0_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u1��
	wire [`WordDataBus] s1_rd_data;				  // �ǂݏo���f�[�^
	wire				s1_rdy_;				  // ���f�B
	wire				s1_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u2��
	wire [`WordDataBus] s2_rd_data;				  // �ǂݏo���f�[�^
	wire				s2_rdy_;				  // ���f�B
	wire				s2_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u3��
	wire [`WordDataBus] s3_rd_data;				  // �ǂݏo���f�[�^
	wire				s3_rdy_;				  // ���f�B
	wire				s3_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u4��
	wire [`WordDataBus] s4_rd_data;				  // �ǂݏo���f�[�^
	wire				s4_rdy_;				  // ���f�B
	wire				s4_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u5��
	wire [`WordDataBus] s5_rd_data;				  // �ǂݏo���f�[�^
	wire				s5_rdy_;				  // ���f�B
	wire				s5_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u6��
	wire [`WordDataBus] s6_rd_data;				  // �ǂݏo���f�[�^
	wire				s6_rdy_;				  // ���f�B
	wire				s6_cs_;					  // �`�b�v�Z���N�g
	// �o�X�X���[�u7��
	wire [`WordDataBus] s7_rd_data;				  // �ǂݏo���f�[�^
	wire				s7_rdy_;				  // ���f�B
	wire				s7_cs_;					  // �`�b�v�Z���N�g
	/********** ���荞�ݗv���M�� **********/
	wire				   irq_timer;			  // �^�C�}IRQ
	wire				   irq_uart_rx;			  // UART IRQ�i��M�j
	wire				   irq_uart_tx;			  // UART IRQ�i���M�j
	wire [`CPU_IRQ_CH-1:0] cpu_irq;				  // CPU IRQ

	assign cpu_irq = {{`CPU_IRQ_CH-3{`LOW}}, 
					  irq_uart_rx, irq_uart_tx, irq_timer};

	/********** CPU **********/
	cpu cpu (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			 (clk),					  // �N���b�N
		.clk_			 (clk_),				  // ���]�N���b�N
		.reset			 (reset),				  // �񓯊����Z�b�g
		/********** �o�X�C���^�t�F�[�X **********/
		// IF Stage
		.if_bus_rd_data	 (m_rd_data),			  // �ǂݏo���f�[�^
		.if_bus_rdy_	 (m_rdy_),				  // ���f�B
		.if_bus_grnt_	 (m0_grnt_),			  // �o�X�O�����g
		.if_bus_req_	 (m0_req_),				  // �o�X���N�G�X�g
		.if_bus_addr	 (m0_addr),				  // �A�h���X
		.if_bus_as_		 (m0_as_),				  // �A�h���X�X�g���[�u
		.if_bus_rw		 (m0_rw),				  // �ǂ݁^����
		.if_bus_wr_data	 (m0_wr_data),			  // �������݃f�[�^
		// MEM Stage
		.mem_bus_rd_data (m_rd_data),			  // �ǂݏo���f�[�^
		.mem_bus_rdy_	 (m_rdy_),				  // ���f�B
		.mem_bus_grnt_	 (m1_grnt_),			  // �o�X�O�����g
		.mem_bus_req_	 (m1_req_),				  // �o�X���N�G�X�g
		.mem_bus_addr	 (m1_addr),				  // �A�h���X
		.mem_bus_as_	 (m1_as_),				  // �A�h���X�X�g���[�u
		.mem_bus_rw		 (m1_rw),				  // �ǂ݁^����
		.mem_bus_wr_data (m1_wr_data),			  // �������݃f�[�^
		/********** ���荞�� **********/
		.cpu_irq		 (cpu_irq)				  // ���荞�ݗv��
	);

	/********** �o�X�}�X�^ 2 : ������ **********/
	assign m2_addr	  = `WORD_ADDR_W'h0;
	assign m2_as_	  = `DISABLE_;
	assign m2_rw	  = `READ;
	assign m2_wr_data = `WORD_DATA_W'h0;
	assign m2_req_	  = `DISABLE_;

	/********** �o�X�}�X�^ 3 : ������ **********/
	assign m3_addr	  = `WORD_ADDR_W'h0;
	assign m3_as_	  = `DISABLE_;
	assign m3_rw	  = `READ;
	assign m3_wr_data = `WORD_DATA_W'h0;
	assign m3_req_	  = `DISABLE_;
   
	/********** �o�X�X���[�u 0 : ROM **********/
	rom rom (
		/********** Clock & Reset **********/
		.clk			 (clk),					  // �N���b�N
		.reset			 (reset),				  // �񓯊����Z�b�g
		/********** Bus Interface **********/
		.cs_			 (s0_cs_),				  // �`�b�v�Z���N�g
		.as_			 (s_as_),				  // �A�h���X�X�g���[�u
		.addr			 (s_addr[`RomAddrLoc]),	  // �A�h���X
		.rd_data		 (s0_rd_data),			  // �ǂݏo���f�[�^
		.rdy_			 (s0_rdy_)				  // ���f�B
	);

	/********** �o�X�X���[�u 1 : Scratch Pad Memory **********/
	assign s1_rd_data = `WORD_DATA_W'h0;
	assign s1_rdy_	  = `DISABLE_;

	/********** �o�X�X���[�u 2 : �^�C�} **********/
`ifdef IMPLEMENT_TIMER // �^�C�}����
	timer timer (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			 (clk),					  // �N���b�N
		.reset			 (reset),				  // ���Z�b�g
		/********** �o�X�C���^�t�F�[�X **********/
		.cs_			 (s2_cs_),				  // �`�b�v�Z���N�g
		.as_			 (s_as_),				  // �A�h���X�X�g���[�u
		.addr			 (s_addr[`TimerAddrLoc]), // �A�h���X
		.rw				 (s_rw),				  // Read / Write
		.wr_data		 (s_wr_data),			  // �������݃f�[�^
		.rd_data		 (s2_rd_data),			  // �ǂݏo���f�[�^
		.rdy_			 (s2_rdy_),				  // ���f�B
		/********** ���荞�� **********/
		.irq			 (irq_timer)			  // ���荞�ݗv��
	 );
`else				   // �^�C�}����
	assign s2_rd_data = `WORD_DATA_W'h0;
	assign s2_rdy_	  = `DISABLE_;
	assign irq_timer  = `DISABLE;
`endif

	/********** �o�X�X���[�u 3 : UART **********/
`ifdef IMPLEMENT_UART // UART����
	uart uart (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			 (clk),					  // �N���b�N
		.reset			 (reset),				  // �񓯊����Z�b�g
		/********** �o�X�C���^�t�F�[�X **********/
		.cs_			 (s3_cs_),				  // �`�b�v�Z���N�g
		.as_			 (s_as_),				  // �A�h���X�X�g���[�u
		.rw				 (s_rw),				  // Read / Write
		.addr			 (s_addr[`UartAddrLoc]),  // �A�h���X
		.wr_data		 (s_wr_data),			  // �������݃f�[�^
		.rd_data		 (s3_rd_data),			  // �ǂݏo���f�[�^
		.rdy_			 (s3_rdy_),				  // ���f�B
		/********** ���荞�� **********/
		.irq_rx			 (irq_uart_rx),			  // ��M�������荞��
		.irq_tx			 (irq_uart_tx),			  // ���M�������荞��
		/********** UART����M�M��	**********/
		.rx				 (uart_rx),				  // UART��M�M��
		.tx				 (uart_tx)				  // UART���M�M��
	);
`else				  // UART������
	assign s3_rd_data  = `WORD_DATA_W'h0;
	assign s3_rdy_	   = `DISABLE_;
	assign irq_uart_rx = `DISABLE;
	assign irq_uart_tx = `DISABLE;
`endif

	/********** �o�X�X���[�u 4 : GPIO **********/
`ifdef IMPLEMENT_GPIO // GPIO����
	gpio gpio (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			 (clk),					 // �N���b�N
		.reset			 (reset),				 // ���Z�b�g
		/********** �o�X�C���^�t�F�[�X **********/
		.cs_			 (s4_cs_),				 // �`�b�v�Z���N�g
		.as_			 (s_as_),				 // �A�h���X�X�g���[�u
		.rw				 (s_rw),				 // Read / Write
		.addr			 (s_addr[`GpioAddrLoc]), // �A�h���X
		.wr_data		 (s_wr_data),			 // �������݃f�[�^
		.rd_data		 (s4_rd_data),			 // �ǂݏo���f�[�^
		.rdy_			 (s4_rdy_)				 // ���f�B
		/********** �ėp���o�̓|�[�g **********/
`ifdef GPIO_IN_CH	 // ���̓|�[�g�̎���
		, .gpio_in		 (gpio_in)				 // ���̓|�[�g
`endif
`ifdef GPIO_OUT_CH	 // �o�̓|�[�g�̎���
		, .gpio_out		 (gpio_out)				 // �o�̓|�[�g
`endif
`ifdef GPIO_IO_CH	 // ���o�̓|�[�g�̎���
		, .gpio_io		 (gpio_io)				 // ���o�̓|�[�g
`endif
	);
`else				  // GPIO������
	assign s4_rd_data = `WORD_DATA_W'h0;
	assign s4_rdy_	  = `DISABLE_;
`endif

	/********** �o�X�X���[�u 5 : ������ **********/
	assign s5_rd_data = `WORD_DATA_W'h0;
	assign s5_rdy_	  = `DISABLE_;
  
	/********** �o�X�X���[�u 6 : ������ **********/
	assign s6_rd_data = `WORD_DATA_W'h0;
	assign s6_rdy_	  = `DISABLE_;
  
	/********** �o�X�X���[�u 7 : ������ **********/
	assign s7_rd_data = `WORD_DATA_W'h0;
	assign s7_rdy_	  = `DISABLE_;

	/********** �o�X **********/
	bus bus (
		/********** �N���b�N & ���Z�b�g **********/
		.clk			 (clk),					 // �N���b�N
		.reset			 (reset),				 // �񓯊����Z�b�g
		/********** �o�X�}�X�^�M�� **********/
		// �S�}�X�^���ʐM��
		.m_rd_data		 (m_rd_data),			 // �ǂݏo���f�[�^
		.m_rdy_			 (m_rdy_),				 // ���f�B
		// �o�X�}�X�^0
		.m0_req_		 (m0_req_),				 // �o�X���N�G�X�g
		.m0_addr		 (m0_addr),				 // �A�h���X
		.m0_as_			 (m0_as_),				 // �A�h���X�X�g���[�u
		.m0_rw			 (m0_rw),				 // �ǂ݁^����
		.m0_wr_data		 (m0_wr_data),			 // �������݃f�[�^
		.m0_grnt_		 (m0_grnt_),			 // �o�X�O�����g
		// �o�X�}�X�^1
		.m1_req_		 (m1_req_),				 // �o�X���N�G�X�g
		.m1_addr		 (m1_addr),				 // �A�h���X
		.m1_as_			 (m1_as_),				 // �A�h���X�X�g���[�u
		.m1_rw			 (m1_rw),				 // �ǂ݁^����
		.m1_wr_data		 (m1_wr_data),			 // �������݃f�[�^
		.m1_grnt_		 (m1_grnt_),			 // �o�X�O�����g
		// �o�X�}�X�^2
		.m2_req_		 (m2_req_),				 // �o�X���N�G�X�g
		.m2_addr		 (m2_addr),				 // �A�h���X
		.m2_as_			 (m2_as_),				 // �A�h���X�X�g���[�u
		.m2_rw			 (m2_rw),				 // �ǂ݁^����
		.m2_wr_data		 (m2_wr_data),			 // �������݃f�[�^
		.m2_grnt_		 (m2_grnt_),			 // �o�X�O�����g
		// �o�X�}�X�^3
		.m3_req_		 (m3_req_),				 // �o�X���N�G�X�g
		.m3_addr		 (m3_addr),				 // �A�h���X
		.m3_as_			 (m3_as_),				 // �A�h���X�X�g���[�u
		.m3_rw			 (m3_rw),				 // �ǂ݁^����
		.m3_wr_data		 (m3_wr_data),			 // �������݃f�[�^
		.m3_grnt_		 (m3_grnt_),			 // �o�X�O�����g
		/********** �o�X�X���[�u�M�� **********/
		// �S�X���[�u���ʐM��
		.s_addr			 (s_addr),				 // �A�h���X
		.s_as_			 (s_as_),				 // �A�h���X�X�g���[�u
		.s_rw			 (s_rw),				 // �ǂ݁^����
		.s_wr_data		 (s_wr_data),			 // �������݃f�[�^
		// �o�X�X���[�u0��
		.s0_rd_data		 (s0_rd_data),			 // �ǂݏo���f�[�^
		.s0_rdy_		 (s0_rdy_),				 // ���f�B
		.s0_cs_			 (s0_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u1��
		.s1_rd_data		 (s1_rd_data),			 // �ǂݏo���f�[�^
		.s1_rdy_		 (s1_rdy_),				 // ���f�B
		.s1_cs_			 (s1_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u2��
		.s2_rd_data		 (s2_rd_data),			 // �ǂݏo���f�[�^
		.s2_rdy_		 (s2_rdy_),				 // ���f�B
		.s2_cs_			 (s2_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u3��
		.s3_rd_data		 (s3_rd_data),			 // �ǂݏo���f�[�^
		.s3_rdy_		 (s3_rdy_),				 // ���f�B
		.s3_cs_			 (s3_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u4��
		.s4_rd_data		 (s4_rd_data),			 // �ǂݏo���f�[�^
		.s4_rdy_		 (s4_rdy_),				 // ���f�B
		.s4_cs_			 (s4_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u5��
		.s5_rd_data		 (s5_rd_data),			 // �ǂݏo���f�[�^
		.s5_rdy_		 (s5_rdy_),				 // ���f�B
		.s5_cs_			 (s5_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u6��
		.s6_rd_data		 (s6_rd_data),			 // �ǂݏo���f�[�^
		.s6_rdy_		 (s6_rdy_),				 // ���f�B
		.s6_cs_			 (s6_cs_),				 // �`�b�v�Z���N�g
		// �o�X�X���[�u7��
		.s7_rd_data		 (s7_rd_data),			 // �ǂݏo���f�[�^
		.s7_rdy_		 (s7_rdy_),				 // ���f�B
		.s7_cs_			 (s7_cs_)				 // �`�b�v�Z���N�g
	);

endmodule
