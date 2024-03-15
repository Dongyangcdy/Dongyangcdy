//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           rgmii_tx
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

module rgmii_tx(
    //GMII���Ͷ˿�
    input              gmii_tx_clk , //GMII����ʱ��    
    input              gmii_tx_en  , //GMII���������Ч�ź�
    input       [7:0]  gmii_txd    , //GMII�������        
    
    //RGMII���Ͷ˿�
    output             rgmii_txc   , //RGMII��������ʱ��    
    output             rgmii_tx_ctl, //RGMII���������Ч�ź�
    output      [3:0]  rgmii_txd     //RGMII�������     
    );

//wire define
wire             gmii_tx_clk_inv;   
    
//*****************************************************
//**                    main code
//*****************************************************

assign gmii_tx_clk_inv = ~gmii_tx_clk;

//���˫�ز����Ĵ��� (rgmii_txc)
ODDR2 #(
   .DDR_ALIGNMENT("C0"),// Sets output alignment to "NONE", "C0" or "C1" 
   .INIT(1'b0),         // Sets initial state of the Q output to 1'b0 or 1'b1
   .SRTYPE("ASYNC")     // Specifies "SYNC" or "ASYNC" set/reset
) ODDR2_rgmii_txc (
   .Q(rgmii_txc),       // 1-bit DDR output data
   .C0(gmii_tx_clk),    // 1-bit clock input
   .C1(gmii_tx_clk_inv),// 1-bit clock input
   .CE(1'b1),           // 1-bit clock enable input
   .D0(1'b1),           // 1-bit data input (associated with C0)
   .D1(1'b0),           // 1-bit data input (associated with C1)
   .R(1'b0),            // 1-bit reset input
   .S(1'b0)             // 1-bit set input
);

//���˫�ز����Ĵ��� (rgmii_tx_ctl)
ODDR2 #(
   .DDR_ALIGNMENT("C0"),// Sets output alignment to "NONE", "C0" or "C1" 
   .INIT(1'b0),         // Sets initial state of the Q output to 1'b0 or 1'b1
   .SRTYPE("ASYNC")     // Specifies "SYNC" or "ASYNC" set/reset
) ODDR2_rgmii_tx_ctl (
   .Q(rgmii_tx_ctl),    // 1-bit DDR output data
   .C0(gmii_tx_clk),    // 1-bit clock input
   .C1(gmii_tx_clk_inv),// 1-bit clock input
   .CE(1'b1),           // 1-bit clock enable input
   .D0(gmii_tx_en),     // 1-bit data input (associated with C0)
   .D1(gmii_tx_en),     // 1-bit data input (associated with C1)
   .R(1'b0),            // 1-bit reset input
   .S(1'b0)             // 1-bit set input
);

genvar i;
generate for (i=0; i<4; i=i+1)
    begin : txdata_bus
        //���˫�ز����Ĵ��� (rgmii_txd)
        ODDR2 #(
           .DDR_ALIGNMENT("C0"),// Sets output alignment to "NONE", "C0" or "C1" 
           .INIT(1'b0),         // Sets initial state of the Q output to 1'b0 or 1'b1
           .SRTYPE("ASYNC")     // Specifies "SYNC" or "ASYNC" set/reset
        ) ODDR2_rgmii_txd (
           .Q(rgmii_txd[i]),    // 1-bit DDR output data
           .C0(gmii_tx_clk),    // 1-bit clock input
           .C1(gmii_tx_clk_inv),// 1-bit clock input
           .CE(1'b1),           // 1-bit clock enable input
           .D0(gmii_txd[i]),    // 1-bit data input (associated with C0)
           .D1(gmii_txd[4+i]),  // 1-bit data input (associated with C1)
           .R(1'b0),            // 1-bit reset input
           .S(1'b0)             // 1-bit set input
        );      
    end
endgenerate

endmodule 