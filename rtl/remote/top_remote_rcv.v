//****************************************Copyright (c)***********************************//
//����֧�֣�www.openedv.com
//�Ա����̣�http://openedv.taobao.com 
//��ע΢�Ź���ƽ̨΢�źţ�"����ԭ��"����ѻ�ȡFPGA & STM32���ϡ�
//��Ȩ���У�����ؾ���
//Copyright(C) ����ԭ�� 2018-2028
//All rights reserved                                  
//----------------------------------------------------------------------------------------
// File name:           top_remote_rcv
// Last modified Date:  2018��5��28��16:42:06
// Last Version:        V1.0
// Descriptions:        �����������ʾʵ��
//----------------------------------------------------------------------------------------
// Created by:          ����ԭ��
// Created date:        2018��5��28��16:42:13
// Version:             V1.0
// Descriptions:        The original version
//----------------------------------------------------------------------------------------
//****************************************************************************************// 

module top_remote_rcv(
    input             sys_clk  ,    //ϵͳʱ�� 
    input             sys_rst_n,    //ϵͳ��λ�źţ��͵�ƽ��Ч
    input             remote_in,    //��������ź�
    output    [7:0]   remote_data,   //��������ź�
	 output     [5:0]  sel      ,    //�����λѡ�ź�
    output     [7:0]  seg_led  ,    //����ܶ�ѡ�ź�
    output            led           //led��
);

//wire define
wire  [7:0]   data       ;
wire          repeat_en  ;
//*****************************************************
//**                    main code
//*****************************************************

assign remote_data=data;
//�������ʾģ��
seg_led u_seg_led(
    .clk            (sys_clk),   
    .rst_n          (sys_rst_n),
    .seg_sel        (sel),   
    .seg_led        (seg_led),
    .data           (data),           //��������
    .point          (6'd0),           //��С����
    .en             (1'b1),           //ʹ�������
    .sign           (1'b0)            //�޷�����ʾ
    );

//HS0038B����ģ��
remote_rcv u_remote_rcv(               
    .sys_clk        (sys_clk),  
    .sys_rst_n      (sys_rst_n),    
    .remote_in      (remote_in),
    .repeat_en      (repeat_en),                
    .data_en        (),
    .data           (data)
    );

led_ctrl  u_led_ctrl(
    .sys_clk       (sys_clk),
    .sys_rst_n     (sys_rst_n),
    .repeat_en     (repeat_en),
    .led           (led)
    );
	 
endmodule