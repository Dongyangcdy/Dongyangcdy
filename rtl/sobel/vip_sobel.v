//****************************************Copyright (c)***********************************//
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取FPGA & STM32资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           vip
// Last modified Date:  2019/03/22 16:33:40
// Last Version:        V1.0
// Descriptions:        数字图像处理模块封装层
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/03/22 16:33:56
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module vip_sobel(
    //module clock
    input           clk            ,    // 时钟信号
    input           rst_n          ,    // 复位信号（低有效）

    //图像处理前的数据接口
    input           pre_frame_vsync,
    input           pre_frame_hsync,
    input           pre_frame_de   ,
    input    [15:0] pre_rgb        ,
    input    [10:0] xpos           ,
    input    [10:0] ypos           ,

    //图像处理后的数据接口
    output          post_frame_vsync,   // 场同步信号
    output          post_frame_hsync,   // 行同步信号
    output          post_frame_de   ,   // 数据输入使能
    output   [15:0] post_rgb            // RGB565颜色数据
);

parameter  SOBEL_THRESHOLD = 128; //sobel阈值

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
wire                  post_img_bit;
//*****************************************************
//**                    main code
//*****************************************************

assign  post_rgb = {16{~post_img_bit}};

//RGB转YCbCr模块
rgb2ycbcr u_rgb2ycbcr(
    //module clock
    .clk             (clk    ),            // 时钟信号
    .rst_n           (rst_n  ),            // 复位信号（低有效）
    //图像处理前的数据接口
    .pre_frame_vsync (pre_frame_vsync),    // vsync信号
    .pre_frame_hsync (pre_frame_hsync),    // href信号
    .pre_frame_de    (pre_frame_de   ),    // data enable信号
    .img_red         (pre_rgb[15:11] ),
    .img_green       (pre_rgb[10:5 ] ),
    .img_blue        (pre_rgb[ 4:0 ] ),
    //图像处理后的数据接口
    .post_frame_vsync(pe_frame_vsync),     // vsync信号
    .post_frame_hsync(pe_frame_href),      // href信号
    .post_frame_de   (pe_frame_clken),     // data enable信号
    .img_y           (img_y),              //灰度数据
    .img_cb          (),
    .img_cr          ()
);

vip_sobel_edge_detector
    #(
    .SOBEL_THRESHOLD  (SOBEL_THRESHOLD)    //sobel阈值
    )
u_vip_sobel_edge_detector(
    .clk (clk),   
    .rst_n (rst_n),  
    
    //处理前数据
    .per_frame_vsync (pe_frame_vsync),    //处理前帧有效信号
    .per_frame_href  (pe_frame_href),     //处理前行有效信号
    .per_frame_clken (pe_frame_clken),    //处理前图像使能信号
    .per_img_y       (img_y),             //处理前输入灰度数据
    
    //处理后的数据
    .post_frame_vsync (post_frame_vsync), //处理后帧有效信号
    .post_frame_href  (post_frame_hsync), //处理后行有效信号
    .post_frame_clken (post_frame_de),    //输出使能信号
    .post_img_bit     (post_img_bit)      //输出像素
        
);
endmodule
