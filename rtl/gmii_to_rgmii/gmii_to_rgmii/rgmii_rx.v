//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           rgmii_rx
// Last modified Date:  2020/2/13 9:20:14
// Last Version:        V1.0
// Descriptions:        RGMII����ģ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2020/2/13 9:20:14
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module rgmii_rx(
    //��̫��RGMII�ӿ�
    input              rgmii_rxc   , //RGMII����ʱ��
    input              rgmii_rx_ctl, //RGMII�������ݿ����ź�
    input       [3:0]  rgmii_rxd   , //RGMII��������    

    //��̫��GMII�ӿ�
    output             gmii_rx_clk , //GMII����ʱ��
    output  reg        gmii_rx_dv  , //GMII����������Ч�ź�
    output  reg [7:0]  gmii_rxd      //GMII��������   
    );

//wire define
wire         rgmii_rxc_ibuf;
wire         rgmii_rxc_bufg;     //ȫ��ʱ�ӻ���
wire         rgmii_rxc_bufg_inv; //ȫ��ʱ�ӻ���ȡ��
wire  [3:0]  rgmii_rxd_delay;    //rgmii_rxd������ʱ
wire         rgmii_rx_ctl_delay; //rgmii_rx_ctl������ʱ
wire  [1:0]  gmii_rxdv_t;        //��λGMII������Ч�ź� 
wire  [7:0]  gmii_rxd_t;         //8λGMII������Ч����

//*****************************************************
//**                    main code
//*****************************************************

assign gmii_rx_clk = rgmii_rxc_bufg;
assign rgmii_rxc_bufg_inv = ~rgmii_rxc_bufg;

//�Ĵ����GMII������Ч�źź�����
always @(posedge gmii_rx_clk) begin
    gmii_rx_dv <= gmii_rxdv_t[0] & gmii_rxdv_t[1];
    gmii_rxd <= gmii_rxd_t;
end

//����ȫ�ֻ���
IBUFG BUFG_inst (
   .I  (rgmii_rxc),     // 1-bit input: Clock input
   .O  (rgmii_rxc_ibuf) // 1-bit output: Clock output
);

//ȫ��ʱ�ӻ���
BUFG clkin_buf_inst(
   .I  (rgmii_rxc_ibuf),
   .O  (rgmii_rxc_bufg)
);

//rgmii_rx_ctl����˫�ز���
IDDR2 #(
   .DDR_ALIGNMENT("C1"),    // Sets output alignment to "NONE", "C0" or "C1" 
   .INIT_Q0(1'b0),          // Sets initial state of the Q0 output to 1'b0 or 1'b1
   .INIT_Q1(1'b0),          // Sets initial state of the Q1 output to 1'b0 or 1'b1
   .SRTYPE("ASYNC")         // Specifies "SYNC" or "ASYNC" set/reset
) IDDR2_rgmii_rx_ctl (
   .Q0(gmii_rxdv_t[1]),     // 1-bit output captured with C0 clock
   .Q1(gmii_rxdv_t[0]),     // 1-bit output captured with C1 clock
   .C0(rgmii_rxc_bufg),     // 1-bit clock input
   .C1(rgmii_rxc_bufg_inv), // 1-bit clock input
   .CE(1'b1),               // 1-bit clock enable input
   .D(rgmii_rx_ctl),        // 1-bit DDR data input
   .R(1'b0),                // 1-bit reset input
   .S(1'b0)                 // 1-bit set input
);

//rgmii_rxd����˫�ز���
genvar i;
generate for (i=0; i<4; i=i+1)
    begin : rxdata_bus
        //����˫�ز����Ĵ���
        IDDR2 #(
           .DDR_ALIGNMENT("C1"),    // Sets output alignment to "NONE", "C0" or "C1" 
           .INIT_Q0(1'b0),          // Sets initial state of the Q0 output to 1'b0 or 1'b1
           .INIT_Q1(1'b0),          // Sets initial state of the Q1 output to 1'b0 or 1'b1
           .SRTYPE("ASYNC")         // Specifies "SYNC" or "ASYNC" set/reset
        ) IDDR2_rgmii_rxd (
           .Q0(gmii_rxd_t[4+i]),    // 1-bit output captured with C0 clock
           .Q1(gmii_rxd_t[i]),      // 1-bit output captured with C1 clock
           .C0(rgmii_rxc_bufg),     // 1-bit clock input
           .C1(rgmii_rxc_bufg_inv), // 1-bit clock input
           .CE(1'b1),               // 1-bit clock enable input
           .D(rgmii_rxd[i]),        // 1-bit DDR data input
           .R(1'b0),                // 1-bit reset input
           .S(1'b0)                 // 1-bit set input
        );      
    end
endgenerate

endmodule 