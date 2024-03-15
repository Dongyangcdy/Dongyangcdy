//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           binarization
// Last modified Date:  2020/05/04 9:19:08
// Last Version:        V1.0
// Descriptions:        ͼ��Ķ�ֵ������
//                      
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/05/04 9:19:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module binarization(
    //module clock
    input               clk             ,   // ʱ���ź�
    input               rst_n           ,   // ��λ�źţ�����Ч��

    //ͼ����ǰ�����ݽӿ�
    input               ycbcr_vsync     ,   // vsync�ź�
    input               ycbcr_hsync     ,   // hsync�ź�
    input               ycbcr_de        ,   // data enable�ź�
    input   [7:0]       luminance       ,

    //ͼ���������ݽӿ�
    output              post_vsync      ,   // vsync�ź�
    output              post_hsync      ,   // hsync�ź�
    output              post_de         ,   // data enable�ź�
    output   reg        monoc               // monochrome��1=�ף�0=�ڣ�
);

//reg define
reg    ycbcr_vsync_d;
reg    ycbcr_hsync_d;
reg    ycbcr_de_d   ;

//*****************************************************
//**                    main code
//*****************************************************

assign  post_vsync = ycbcr_vsync_d  ;
assign  post_hsync = ycbcr_hsync_d  ;
assign  post_de    = ycbcr_de_d     ;

//��ֵ��
always @(posedge clk or negedge rst_n) begin
    if(!rst_n)
        monoc <= 1'b0;
    else if(luminance > 90)  //��ֵ
        monoc <= 1'b1;
    else
        monoc <= 1'b0;
end

//��ʱ1����ͬ��ʱ���ź�
always@(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        ycbcr_vsync_d <= 1'd0;
        ycbcr_hsync_d <= 1'd0;
        ycbcr_de_d    <= 1'd0;
    end
    else begin
        ycbcr_vsync_d <= ycbcr_vsync;
        ycbcr_hsync_d <= ycbcr_hsync;
        ycbcr_de_d    <= ycbcr_de   ;
    end
end

endmodule 