//****************************************Copyright (c)***********************************//
//ԭ�Ӹ����߽�ѧƽ̨��www.yuanzige.com
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡZYNQ & FPGA & STM32 & LINUX���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           vip
// Last modified Date:  2020/05/04 9:19:08
// Last Version:        V1.0
// Descriptions:        ����ͼ����ģ���װ��
//                      
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2019/05/04 9:19:08
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module vip_bin(
    //module clock
    input           clk            ,   // ʱ���ź�
    input           rst_n          ,   // ��λ�źţ�����Ч��

    //ͼ����ǰ�����ݽӿ�
    input           pre_frame_vsync,   
    input           pre_frame_hsync,
    input           pre_frame_de   ,
    input    [15:0] pre_rgb        ,
    input    [10:0] xpos           ,
    input    [10:0] ypos           ,

    //ͼ���������ݽӿ�
    output          post_frame_vsync,  // ��ͬ���ź�
    output          post_frame_hsync,  // ��ͬ���ź�
    output          post_frame_de   ,  // ��������ʹ��
    output   [15:0] post_rgb           // RGB565��ɫ����


);

//wire define
wire   [ 7:0]         img_y;
wire   [ 7:0]         post_img_y;
wire   [15:0]         post_rgb;
wire                  post_frame_vsync;
wire                  post_frame_hsync;
wire                  post_frame_de;
wire                  pe_frame_vsync;
wire                  pe_frame_href;
wire                  pe_frame_clken;
wire                  ycbcr_vsync;
wire                  ycbcr_hsync;
wire                  ycbcr_de;
wire                  monoc;

//*****************************************************
//**                    main code
//*****************************************************

assign  post_rgb = {16{monoc}};

//RGBתYCbCrģ��
rgb2ycbcr u_rgb2ycbcr(
    //module clock
    .clk             (clk    ),            // ʱ���ź�
    .rst_n           (rst_n  ),            // ��λ�źţ�����Ч��
    //ͼ����ǰ�����ݽӿ�
    .pre_frame_vsync (pre_frame_vsync),    // vsync�ź�
    .pre_frame_hsync (pre_frame_hsync),    // href�ź�
    .pre_frame_de    (pre_frame_de   ),    // data enable�ź�
    .img_red         (pre_rgb[15:11] ),
    .img_green       (pre_rgb[10:5 ] ),
    .img_blue        (pre_rgb[ 4:0 ] ),
    //ͼ���������ݽӿ�
    .post_frame_vsync(pe_frame_vsync),     // vsync�ź�
    .post_frame_hsync(pe_frame_href),      // href�ź�
    .post_frame_de   (pe_frame_clken),     // data enable�ź�
    .img_y           (img_y),              //�Ҷ�����
    .img_cb          (),
    .img_cr          ()
);

//�Ҷ�ͼ��ֵ�˲�
vip_gray_median_filter u_vip_gray_median_filter(
    .clk    (clk),   
    .rst_n  (rst_n), 
    
    //Ԥ����ͼ������
    .pe_frame_vsync (pe_frame_vsync),      // vsync�ź�
    .pe_frame_href  (pe_frame_href),       // href�ź�
    .pe_frame_clken (pe_frame_clken),      // data enable�ź�
    .pe_img_y       (img_y),               
                                           
    //������ͼ������                     
    .pos_frame_vsync (ycbcr_vsync),        // vsync�ź�
    .pos_frame_href  (ycbcr_hsync),        // href�ź�
    .pos_frame_clken (ycbcr_de),           // data enable�ź�
    .pos_img_y       (post_img_y)          //��ֵ�˲���ĻҶ�����
);

//��ֵ��ģ��
binarization  u_binarization(
    .clk         (clk),
    .rst_n       (rst_n),
    //ͼ����ǰ�����ݽӿ�     
    .ycbcr_vsync (ycbcr_vsync),
    .ycbcr_hsync (ycbcr_hsync),
    .ycbcr_de    (ycbcr_de),
    .luminance   (post_img_y),
    //ͼ���������ݽӿ�     
    .post_vsync  (post_frame_vsync),
    .post_hsync  (post_frame_hsync),
    .post_de     (post_frame_de),
    .monoc       (monoc)                   //��ֵ���������
);
endmodule
