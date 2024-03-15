//****************************************Copyright (c)***********************************//
//原子哥在线教学平台：www.yuanzige.com
//技术支持：www.openedv.com
//淘宝店铺：http://openedv.taobao.com
//关注微信公众平台微信号："正点原子"，免费获取ZYNQ & FPGA & STM32 & LINUX资料。
//版权所有，盗版必究。
//Copyright(C) 正点原子 2018-2028
//All rights reserved
//----------------------------------------------------------------------------------------
// File name:           key_ctrl
// Last modified Date:  2019/4/14 10:55:56
// Last Version:        V1.0
// Descriptions:        按键控制模块
//----------------------------------------------------------------------------------------
// Created by:          正点原子
// Created date:        2019/4/14 10:55:56
// Version:             V1.0
// Descriptions:        The original version
//
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module key_ctrl(
    //input
    input        sys_clk,      //时钟信号50Mhz
    input        sys_rst_n,    //复位信号
    input        touch_key,    //按键 
 
    //output
    output [2:0] change_en     //切换信号      
);

//reg define
reg        touch_key_d0;
reg        touch_key_d1;
reg        vs_in_d0;
reg        touch_en;
reg [23:0] cnt_time;
reg [2:0]  change_en ;

//*****************************************************
//**                    main code
//*****************************************************

//对触摸按键端口的数据延迟两个时钟周期
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        touch_key_d0 <= 1'b0;
        touch_key_d1 <= 1'b0;
    end
    else begin
        touch_key_d0 <= touch_key;
        touch_key_d1 <= touch_key_d0;
    end 
end

//产生切换信号
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        change_en <= 3'd4;
    end
    else begin
        if(cnt_time ==  500000) 
            if(change_en == 3'b100)
                change_en <= 3'b1;
            else                 
                change_en <= {change_en[1:0],1'b0};
        else
            change_en <= change_en ;                 
    end 
end

//对按键的低电平时间进行计数
always @ (posedge sys_clk or negedge sys_rst_n) begin
    if(!sys_rst_n) begin
        cnt_time <= 24'b0;
    end
    else begin
        if(touch_key_d1)
            cnt_time <= 24'b0; 
        else if(cnt_time >= 2500000)  
            cnt_time <= cnt_time;
        else
            cnt_time <= cnt_time + 1;                 
    end 
end

endmodule
