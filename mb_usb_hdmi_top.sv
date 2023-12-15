`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Zuofu Cheng
// 
// Create Date: 12/11/2022 10:48:49 AM
// Design Name: 
// Module Name: mb_usb_hdmi_top
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// Top level for mb_lwusb test project, copy mb wrapper here from Verilog and modify
// to SV
// Dependencies: microblaze block design
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module mb_usb_hdmi_top(
    input logic Clk,
    input logic reset_rtl_0,
    
    //
    output logic audio_left, 
    
    //USB signals
    input logic [0:0] gpio_usb_int_tri_i,
    output logic gpio_usb_rst_tri_o,
    input logic usb_spi_miso,
    output logic usb_spi_mosi,
    output logic usb_spi_sclk,
    output logic usb_spi_ss,
    
    //UART
    input logic uart_rtl_0_rxd,
    output logic uart_rtl_0_txd,
    
    //HDMI
    output logic hdmi_tmds_clk_n,
    output logic hdmi_tmds_clk_p,
    output logic [2:0]hdmi_tmds_data_n,
    output logic [2:0]hdmi_tmds_data_p,
        
    //HEX displays
    output logic [7:0] hex_segA,
    output logic [3:0] hex_gridA,
    output logic [7:0] hex_segB,
    output logic [3:0] hex_gridB
    );
    
    logic [31:0] keycode0_gpio, keycode1_gpio;
    logic clk_25MHz, clk_125MHz, clk, clk_100MHz;
    logic locked;
    logic [9:0] drawX, drawY, ballxsig, ballysig, ballsizesig;
    logic [9:0] ballsizexsig, ballsizeysig;

    logic hsync, vsync, vde;
    logic [3:0] red, green, blue;
    logic reset_ah;
    logic [3:0] sprite_select;
    logic move_map;
    logic catch_en, p_caught, fight;
    assign reset_ah = reset_rtl_0;
    
    logic [2:0] poke_num;
    logic [2:0] poke_select;
    
    logic pokemon_animation, prev_map;
    logic random_en;
    
    logic [2:0] fight_animation;
    logic [1:0] ball_sprite;
    logic in_ball;
    
    logic start, ending;
    logic [1:0] caught_num;
    
    logic [9:0] curr_pkm_x_len, curr_pkm_y_len;
    //Keycode HEX drivers
    HexDriver HexA (
        .clk(Clk),
        .reset(reset_ah),
        .in({{0,0 ,caught_num}, 4'h0, 4'h0, 4'h0}),
        .hex_seg(hex_segA),
        .hex_grid(hex_gridA)
    );
    
    HexDriver HexB (
        .clk(Clk),
        .reset(reset_ah),
        .in({keycode0_gpio[15:12], keycode0_gpio[11:8], keycode0_gpio[7:4], keycode0_gpio[3:0]}),
        .hex_seg(hex_segB),
        .hex_grid(hex_gridB)
    );
    
    mb_block mb_block_i(
        .clk_100MHz(Clk),
        .gpio_usb_int_tri_i(gpio_usb_int_tri_i),
        .gpio_usb_keycode_0_tri_o(keycode0_gpio),
        .gpio_usb_keycode_1_tri_o(keycode1_gpio),
        .gpio_usb_rst_tri_o(gpio_usb_rst_tri_o),
        .reset_rtl_0(~reset_ah), //Block designs expect active low reset, all other modules are active high
        .uart_rtl_0_rxd(uart_rtl_0_rxd),
        .uart_rtl_0_txd(uart_rtl_0_txd),
        .usb_spi_miso(usb_spi_miso),
        .usb_spi_mosi(usb_spi_mosi),
        .usb_spi_sclk(usb_spi_sclk),
        .usb_spi_ss(usb_spi_ss)
    );
        
    //clock wizard configured with a 1x and 5x clock for HDMI
    clk_wiz_0 clk_wiz (
        .clk_out1(clk_25MHz),
        .clk_out2(clk_125MHz),
        .reset(reset_ah),
        .locked(locked),
        .clk_in1(Clk)
    );
    
    //VGA Sync signal generator
    vga_controller vga (
        .pixel_clk(clk_25MHz),
        .reset(reset_ah),
        .hs(hsync),
        .vs(vsync),
        .active_nblank(vde),
        .drawX(drawX),
        .drawY(drawY)
    );    

    //Real Digital VGA to HDMI converter
    hdmi_tx_0 vga_to_hdmi (
        //Clocking and Reset
        .pix_clk(clk_25MHz),
        .pix_clkx5(clk_125MHz),
        .pix_clk_locked(locked),
        //Reset is active LOW
        .rst(reset_ah),
        //Color and Sync Signals
        .red(red),
        .green(green),
        .blue(blue),
        .hsync(hsync),
        .vsync(vsync),
        .vde(vde),
        
        //aux Data (unused)
        .aux0_din(4'b0),
        .aux1_din(4'b0),
        .aux2_din(4'b0),
        .ade(1'b0),
        
        //Differential outputs
        .TMDS_CLK_P(hdmi_tmds_clk_p),          
        .TMDS_CLK_N(hdmi_tmds_clk_n),          
        .TMDS_DATA_P(hdmi_tmds_data_p),         
        .TMDS_DATA_N(hdmi_tmds_data_n)          
    );

    
//    Ball Module
    ball ball_instance(
        .Reset(reset_ah),
        .frame_clk(vsync),                    //Figure out what this should be so that the ball will move
        .vga_clk(clk_25MHz),
        .clk(Clk),
//        .caught(p_caught),
        .keycode(keycode0_gpio[15:0]),    //Two keycodes
        .pkmn_x_len(curr_pkm_x_len),
        .pkmn_y_len(curr_pkm_y_len),        
        .BallX(ballxsig),
        .BallY(ballysig),
        //.BallS(ballsizesig),
        .BallS_x(ballsizexsig),
        .BallS_y(ballsizeysig),
        .sprite_pos(sprite_select),
        .move_map(move_map),
//        .catch(catch_en),
        .fight(fight),
        .pkmn_animation(pokemon_animation),
        .fight_animation(fight_animation),
        .ball_sprite(ball_sprite),
        .in_ball(in_ball),
        .start(start),
        .ending(ending),
        .caught(p_caught),
        .pokemon_caught(caught_num)        ,
        .pokemon_num(poke_num)
    );
    
    //Color Mapper Module   
//    color_mapper color_instance(
//        .BallX(ballxsig),
//        .BallY(ballysig),
//        .DrawX(drawX),
//        .DrawY(drawY),
//        .Ball_size(ballsizesig),
//        .Red(red),
//        .Green(green),
//        .Blue(blue)
//    );
    
//    player_top_example top_player(
//    .vga_clk(clk_25MHz),
//    .DrawX(drawX),
//    .DrawY(drawY),
//    .BallX(ballxsig),
//    .BallY(ballysig),
//    .sprite_pos(sprite_select),
//    .blank(vde),
//    .red(red),
//    .green(green),
//    .blue(blue)
//    );

    player_up_down_example player(
    .vga_clk(clk_25MHz),
    .DrawX(drawX),
    .DrawY(drawY),
    .BallX(ballxsig),
    .BallY(ballysig),
    .sprite_pos(sprite_select),
    .blank(vde),    
    .red(red),
    .green(green),
    .blue(blue),
    .map_move(move_map),
//    .catch(catch_en),
    .fight_en(fight),
    .caught(p_caught),
    .pkmn_animation(pokemon_animation),
    .pkmnX_len(curr_pkm_x_len), 
    .pkmnY_len(curr_pkm_y_len),
    .fight_animation(fight_animation),
    .ball_sprite(ball_sprite),
    .in_ball(in_ball),
    .start(start),
    .ending(ending),
    .caught_out(caught_num),
    .pokemon_num(poke_num),
    .prev_map(prev_map)
    );
    
    // audio testing 
    
//    logic [17:0] counter = 18'b000000000000000000; 
//    always_ff @ (posedge Clk) begin
//        if (counter < 18'b111111111111111111) counter <= counter  + 1; 
//        else counter <= 0; 
//    end
    
//    if (collide)
//        audio_left = counter < 18'b000000000111111111 ? 1:0; 
//    else
//        audio_left = counter < 18'b000000000000000000 ? 1:0; 
  
    
    // audio testing
    
    
endmodule
