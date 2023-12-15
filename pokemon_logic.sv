module player_up_down_example (
   input logic vga_clk,
   input logic [9:0] DrawX, DrawY,
   input logic [9:0] BallX, BallY,
   input logic [3:0] sprite_pos,
   input logic blank,
   input logic in_ball,
   input logic pkmn_animation,
   input logic map_move, fight_en,
   input logic [2:0] fight_animation,
   input logic [1:0] ball_sprite,
   input logic caught, 
   input logic [1:0] caught_out,
   input logic start, ending,
   output logic [9:0] pkmnX_len, pkmnY_len,
   output logic [3:0] red, green, blue,
   input logic [2:0] pokemon_num,
   input logic prev_map
);
parameter [5:0] ASHE_SIZE_X = 16;
parameter [5:0] ASHE_SIZE_Y = 20;

parameter [5:0] BULB_X_LENGTH = 19;
parameter [4:0] BULB_Y_LENGTH = 15;

parameter [5:0] CHAR_X_LENGTH_1 = 18;
parameter [5:0] CHAR_X_LENGTH_2 = 19;
parameter [5:0] CHAR_Y_LENGTH = 16;

parameter [5:0] PIKA_X_LENGTH = 17;
parameter [5:0] PIKA_Y_LENGTH = 17;

parameter [5:0] POLI_X_LENGTH = 17;
parameter [5:0] POLI_Y_LENGTH = 20;

parameter [4:0] SQTL_X_LENGTH = 15;
parameter [4:0] SQTL_Y_LENGTH = 15;

parameter [7:0] fight_playerX = 88; //64;
parameter [7:0] fight_playerY = 202; //50;
parameter [6:0] fight_player_x_length = 64;
parameter [6:0] fight_player_y_length = 50; 

parameter [9:0] fight_pkmnX = 420;
parameter [9:0] fight_pkmnY = 70;
parameter [9:0] fight_pikachu_length = 140;

//Sprite Variables for Up and Down
logic [10:0] rom_address;
logic [3:0] rom_q;
logic [3:0] palette_red, palette_green, palette_blue;

//Sprite Variables for Left and Right
logic [10:0] rom_address_lr;
logic [3:0] rom_q_lr;
logic [3:0] palette_red_lr, palette_green_lr, palette_blue_lr;

//Sprite Variables for 1st Map
logic [16:0] rom_address_map1;
logic [3:0] rom_q_map1;
logic [3:0] red_map1, green_map1, blue_map1;

logic [16:0] rom_address_map2;
logic [3:0] rom_q_map2;
logic [3:0] red_map2, green_map2, blue_map2;

logic [1:0] addr_ud;

//Sprite Variables for Fight Scene
logic [16:0] rom_address_fight;
logic [3:0] rom_q_fight;
logic [3:0] red_fight, green_fight, blue_fight;
//assign rom_address_fight = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);

logic [3:0] rom_q_fight_player;
logic [3:0] red_fight_player, green_fight_player, blue_fight_player;
logic [13:0] rom_address_fight_player;
//    (DrawX - fight_playerX) * (5 * fight_player_x_length) / 960+ (DrawY - fight_playerY) * fight_player_y_length / 150 * (5 * fight_player_x_length)

logic [14:0] rom_address_fight_pokemon;

//Fight Scene Pikachu Sprite Variables
logic [3:0] rom_q_fight_pikachu;
logic [3:0] red_fight_pikachu, green_fight_pikachu, blue_fight_pikachu;


//Pokeball Sprite Variables
logic [15:0] rom_address_pokeball;
logic [2:0] rom_q_pokeball;
logic [3:0] red_ball, green_ball, blue_ball;
parameter [9:0] poke_ballX = 420;
parameter [9:0] poke_ballY = 70;
parameter [9:0] pokeball_x_length = 140;
parameter [9:0] pokeball_y_length = 140;

//Bulbasaur Fight Scene Sprite Variables
logic [2:0] rom_q_bulb_fight;
logic [3:0] red_bulb_fight, green_bulb_fight, blue_bulb_fight;

//Charmander Fight Scene Sprite Variables
logic [2:0] rom_q_char_fight;
logic [3:0] red_char_fight, green_char_fight, blue_char_fight;

//Poliwrath Fight Scene Sprite Variables
logic [2:0] rom_q_poli_fight;
logic [3:0] red_poli_fight, green_poli_fight, blue_poli_fight;

//Squirtle Fight Scene Sprite Variables
logic [2:0] rom_q_sqtl_fight;
logic [3:0] red_sqtl_fight, green_sqtl_fight, blue_sqtl_fight;

logic [14:0] rom_address_start;
logic [2:0] rom_q_start;
logic [3:0] red_start, green_start, blue_start;
//assign rom_address_start = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);

logic [14:0] rom_address_end;
logic [2:0] rom_q_end;
logic [3:0] red_end, green_end, blue_end;
//assign rom_address_end = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);


assign fight = fight_en;
logic fight_player_on, fight_pokemon_on;
logic [2:0] catch_player_count = 3'b000;

logic negedge_vga_clk;
// read from ROM on negedge, set pixel on posedge
assign negedge_vga_clk = ~vga_clk;

logic [3:0] temp_red, temp_green, temp_blue;
logic [3:0] temp_red_fight, temp_green_fight, temp_blue_fight;
//Position for PKMN
parameter [9:0] PosX = 10'd79; 
parameter [9:0] PosY = 10'd260;
parameter [9:0] PosX2 = 10'd350;
parameter [9:0] PosY2 = 10'd260;

logic [9:0] pkmn_x_length, pkmn_y_length;
assign pkmnX_len = pkmn_x_length;
assign pkmnY_len = pkmn_x_length;

logic [10:0] rom_address_pokemon;

//PKMN Select Bit
logic pkmn_on;
logic ball_on;

logic [2:0] rom_bulb, rom_char, rom_pika, rom_poli, rom_sqtl;
//Colors for Overworld Pokemons
logic [3:0] red_bulb, green_bulb, blue_bulb;
logic [3:0] red_char, green_char, blue_char;
logic [3:0] red_pika, green_pika, blue_pika;
logic [3:0] red_poli, green_poli, blue_poli;
logic [3:0] red_sqtl, green_sqtl, blue_sqtl;


logic random_en = 1'b1;
//assign pokemon_num = 3'b001;

//assign rom_address_map = ((DrawX * 640) / 640) + (((DrawY * 480) / 480) * 640);
// address into the rom = (x*xDim)/640 + ((y*yDim)/480) * xDim
// this will stretch out the sprite across the entire screen
//rom_address = (DrawX - BallX) + ((DrawY - BallY) * 60);
//assign rom_address = ((DrawX * 100) / 640) + (((DrawY * 180) / 480) * 100);



    assign rom_address_start = ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);
    assign rom_address_end =  ((DrawX * 160) / 640) + (((DrawY * 120) / 480) * 160);
    assign rom_address_fight = ((DrawX * 320) / 640) + (((DrawY * 240) / 480) * 320);
    assign rom_address_map1 = (DrawX * 320 / 640) + (DrawY * 240 / 480) * 320;
    assign rom_address_map2 = (DrawX *320 / 640) + (DrawY * 240/480 * 320);
    
always_ff @ (posedge vga_clk) 
begin : RGB_Display
//    if(start == 1'b1) prev_map <= 1'b1;
//    if (map_move != prev_map) begin
//    // random_en = 1'b0;
//        caught <= 1'b0;
//        pokemon_num <= poke_num;
//        prev_map <= map_move;
//    end


    if (start == 1'b0 && blank)
    begin
    red <= red_start;
    green <= green_start;
    blue <= blue_start;
    
    end
    else if (ending == 1'b1 && blank)
    begin
        red <= red_end;
        green <= green_end;
        blue <= blue_end;
    end
    //rom_address_map_bound <= (DrawX - BallX) + ((DrawY - BallY + ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
    else if (start == 1'b1) begin
    if (fight == 1'b1) begin // NEW
        if(fight_player_on == 1'b1 && ({red_fight_player, green_fight_player, blue_fight_player} != 12'hE1E)) begin
            red <= red_fight_player;
            green <= green_fight_player;
            blue <= blue_fight_player;
        end
        else if(ball_on == 1'b1 && ({red_ball, green_ball, blue_ball} != 12'hE1E))
        begin
            red <= red_ball;
            green <= green_ball;
            blue <= blue_ball;
        end
        else if(fight_pokemon_on == 1'b1&& ({temp_red_fight, temp_green_fight, temp_blue_fight} != 12'hE1E)) begin
            red <= temp_red_fight;
            green <= temp_green_fight;
            blue <= temp_blue_fight;
        end

        else begin
            red <= red_fight;
            green <= green_fight;
            blue <= blue_fight;
        end
    end
    
    else begin
        if (blank && (map_move == 2'b00) && (addr_ud == 2'b10
                                          || (addr_ud == 2'b01 && {palette_red, palette_green, palette_blue} == 12'hE1E) 
                                          || (addr_ud == 2'b00 && {palette_red_lr, palette_green_lr, palette_blue_lr} == 12'hE1E)
                                          || (pkmn_on == 1'b1 && {temp_red, temp_green, temp_blue} == 12'hE1E)))
       begin
            red <= red_map1;
            green <= green_map1;
            blue <= blue_map1;
       end
       
       else if (blank && (map_move == 2'b01) && (addr_ud == 2'b10
                                          || (addr_ud == 2'b01 && {palette_red, palette_green, palette_blue} == 12'hE1E) 
                                          || (addr_ud == 2'b00 && {palette_red_lr, palette_green_lr, palette_blue_lr} == 12'hE1E)
                                          || (pkmn_on == 1'b1 && {temp_red, temp_green, temp_blue} == 12'hE1E)))
        begin
            red <= red_map2;
            green <= green_map2;
            blue <= blue_map2;
       end                                  
       
       else if (blank && pkmn_on == 1'b1)
       begin
            red <= temp_red;
            green <= temp_green;
            blue <= temp_blue;
       end
       
       else if (blank && addr_ud == 2'b01) 
        begin
            red <= palette_red;
            green <= palette_green;
            blue <= palette_blue;
        end
       else if (blank && addr_ud == 2'b00) 
       begin
            red <= palette_red_lr;
            green <= palette_green_lr;
            blue <= palette_blue_lr;
       end
    end
end
    end

always_comb
begin: Choose_PKMN

//if (map_move != prev_map)
//begin
//    pokemon_num = poke_num;
//    prev_map = map_move;
//end

case (pokemon_num)
    //Bulbasaur
    3'b000 :  begin
        pkmn_x_length = BULB_X_LENGTH;
        pkmn_y_length = BULB_Y_LENGTH;
        //rom_address_pokemon = DrawX
        temp_red = red_bulb;
        temp_green = green_bulb;
        temp_blue = blue_bulb;
        temp_red_fight = red_bulb_fight;
        temp_green_fight = green_bulb_fight;
        temp_blue_fight = blue_bulb_fight;
        
    end
    //Charmander
    3'b001 :  begin
        pkmn_x_length = CHAR_X_LENGTH_1;
        pkmn_y_length = CHAR_Y_LENGTH;
        //rom_address = DrawX + (DrawY * (CHAR_X_LENGTH_1 + CHAR_X_LENGTH_2));
        temp_red = red_char;
        temp_green = green_char;
        temp_blue = blue_char;
        temp_red_fight = red_char_fight;
        temp_green_fight = green_char_fight;
        temp_blue_fight = blue_char_fight;
    end
    //Pikachu
    3'b010 :  begin
        pkmn_x_length = PIKA_X_LENGTH;
        pkmn_y_length = PIKA_Y_LENGTH;
        //rom_address = DrawX + (DrawY * (2 * PIKA_X_LENGTH));
        temp_red <= red_pika;
        temp_green <= green_pika;
        temp_blue <= blue_pika;
        temp_red_fight = red_fight_pikachu;
        temp_green_fight = green_fight_pikachu;
        temp_blue_fight = blue_fight_pikachu;
    end
    //Poliwrath
    3'b011 :  begin
        pkmn_x_length = POLI_X_LENGTH;
        pkmn_y_length = POLI_Y_LENGTH;
        //rom_address = DrawX + (DrawY * (2 * POLI_X_LENGTH));
        temp_red = red_poli;
        temp_green = green_poli;
        temp_blue = blue_poli;
        temp_red_fight = red_poli_fight;
        temp_green_fight = green_poli_fight;
        temp_blue_fight = blue_poli_fight;
    end
    //Squirtle
    3'b100 :  begin
        pkmn_x_length = SQTL_X_LENGTH;
        pkmn_y_length = SQTL_Y_LENGTH;
        //rom_address = DrawX + (DrawY * (2 * SQTL_X_LENGTH));
        temp_red = red_sqtl;
        temp_green = green_sqtl;
        temp_blue = blue_sqtl;
        temp_red_fight = red_sqtl_fight;
        temp_green_fight = green_sqtl_fight;
        temp_blue_fight = blue_sqtl_fight;
    end
endcase
end

always_comb
begin:Ball_on_proc


// if (map_move != prev_map) begin
//    // random_en = 1'b0;
//    caught = 1'b0;
//end


if(fight == 1'b1) 
begin
     
     if (DrawX >= fight_playerX && DrawX < fight_playerX + (fight_player_x_length * 3 + 1) &&
               DrawY >= fight_playerY && DrawY < fight_playerY + fight_player_y_length * 3) 
     begin
               //rom_address_fight_player = ((DrawX - fight_playerX) * ((5 * fight_player_x_length)) / 960) + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        case(fight_animation)
        3'b000 : rom_address_fight_player = ((DrawX - fight_playerX) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        3'b001 : rom_address_fight_player = ((DrawX - fight_playerX + (3 * fight_player_x_length)) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        3'b010 : rom_address_fight_player = ((DrawX - fight_playerX + 2 * (3 * fight_player_x_length)) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        3'b011 : rom_address_fight_player = ((DrawX - fight_playerX + 3 * (3 * fight_player_x_length)) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        3'b100 : rom_address_fight_player = ((DrawX - fight_playerX + 4 * (3 * fight_player_x_length)) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        endcase
        //rom_address_fight_player = ((DrawX - fight_playerX) * (5 * fight_player_x_length)) / 960 + ((DrawY - fight_playerY) * fight_player_y_length) / 150 * (5 * fight_player_x_length);
        //(catch_player_count * (fight_player_x_length * 3))
        fight_player_on = 1'b1;
        fight_pokemon_on = 1'b0;
        ball_on = 1'b0;

     end 
     else if (DrawX >= fight_pkmnX && DrawX < fight_pkmnX + (fight_pikachu_length + 1) &&
               DrawY >= fight_pkmnY && DrawY < fight_pkmnY + fight_pikachu_length) 
     begin
        if (in_ball == 1'b0 && caught == 1'b0) begin  // NEW
            rom_address_fight_pokemon = (DrawX - fight_pkmnX) + (DrawY - fight_pkmnY) * (fight_pikachu_length);
            ball_on = 1'b0;
            fight_pokemon_on = 1'b1;
            fight_player_on = 1'b0;
            end
        else 
        begin
            case(ball_sprite)
                2'b00 : rom_address_pokeball = (DrawX - poke_ballX) + (DrawY - poke_ballY) * (3 * pokeball_x_length);
                2'b01 : rom_address_pokeball = (DrawX - poke_ballX + pokeball_x_length) + (DrawY - poke_ballY) * (3 * pokeball_x_length);
                2'b10 : rom_address_pokeball = (DrawX - poke_ballX + 2 * pokeball_x_length) + (DrawY - poke_ballY) * (3 * pokeball_x_length);
                2'b11 : rom_address_pokeball = (DrawX - poke_ballX) + (DrawY - poke_ballY) * (3 * pokeball_x_length);
            endcase
                ball_on = 1'b1;
                fight_player_on = 1'b0;
                fight_pokemon_on = 1'b0;
    //         end
        end
     end
     else begin
        fight_player_on = 1'b0;
        fight_pokemon_on = 1'b0;
        ball_on = 1'b0;
     end
end
        
else begin
    if (DrawX >= BallX && DrawX < BallX + ASHE_SIZE_X + 1 &&
        DrawY >= BallY && DrawY < BallY + ASHE_SIZE_Y)
        begin
        pkmn_on = 1'b0;
        case (sprite_pos) //Sprite for Moving Character (Up, Down, Left, Right)
        4'b0000 : begin
                            rom_address = (DrawX - BallX) + ((DrawY - BallY + ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                            
                        end
        4'b0001 : begin
                            rom_address = (DrawX - BallX) + ((DrawY - BallY) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                        end
        4'b0010 : begin
                            rom_address = (DrawX - BallX) + ((DrawY - BallY + 2 * ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                        end
        4'b0011 : begin
                            rom_address = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY + ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                        end
        4'b0100 : begin
                            rom_address = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                        end
        4'b0101 : begin
                            rom_address = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY + (2 * ASHE_SIZE_Y)) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b01;
                        end
        4'b0110 : begin
                            rom_address_lr = (DrawX - BallX) + ((DrawY - BallY + ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        4'b0111 : begin
                            rom_address_lr = (DrawX - BallX) + ((DrawY - BallY) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        4'b1000 : begin
                            rom_address_lr = (DrawX - BallX) + ((DrawY - BallY + (2 * ASHE_SIZE_Y)) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        4'b1001 : begin
                            rom_address_lr = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY + ASHE_SIZE_Y) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        4'b1010 : begin
                            rom_address_lr = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        4'b1011 : begin
                            rom_address_lr = (DrawX - BallX + ASHE_SIZE_X) + ((DrawY - BallY + (2 * ASHE_SIZE_Y)) * (2 * ASHE_SIZE_X));
                            addr_ud =2'b00;
                        end
        endcase
    end

    else if (caught == 1'b0 &&
               map_move == 2'b00 && DrawX >= PosX && DrawX < PosX + (pkmn_x_length + 1) &&
               DrawY >= PosY && DrawY < PosY + pkmn_y_length)
    begin
        if (pkmn_animation == 1'b1)
            begin
            rom_address_pokemon = (DrawX - PosX) + (DrawY - PosY) * (2 * pkmn_x_length);
            if (pokemon_num == 3'b001) rom_address_pokemon = (DrawX - PosX) + (DrawY - PosY) * (2 * pkmn_x_length + 1);
            end
        if (pkmn_animation == 1'b0)
            begin
            rom_address_pokemon = (DrawX - PosX) + (DrawY- PosY + pkmn_y_length) * (2 * pkmn_x_length);
            if (pokemon_num == 3'b001) rom_address_pokemon = (DrawX - PosX) + (DrawY - PosY + pkmn_y_length) * (2 * pkmn_x_length + 1);
            end
        pkmn_on = 1'b1;
        addr_ud = 2'b11;
        end
    else if ( caught == 1'b0 && 
               map_move == 2'b01 && DrawX >= PosX2 && DrawX < PosX2 + (pkmn_x_length + 1) &&
               DrawY >= PosY2  && DrawY < PosY2 + pkmn_y_length)
    begin
        if (pkmn_animation == 1'b1)
        begin
            rom_address_pokemon = (DrawX - PosX2) + (DrawY - PosY2) * (2 * pkmn_x_length);
            if (pokemon_num == 3'b001) rom_address_pokemon = (DrawX - PosX2) + (DrawY - PosY2) * (2 * pkmn_x_length + 1);
        end
        else if (pkmn_animation == 1'b0)
        begin
            rom_address_pokemon = (DrawX - PosX2) + (DrawY- PosY2 + pkmn_y_length) * (2 * pkmn_x_length);
            if (pokemon_num == 3'b001) rom_address_pokemon = (DrawX - PosX2) + (DrawY - PosY2 + pkmn_y_length) * (2 * pkmn_x_length + 1);
        end
        pkmn_on = 1'b1;
        addr_ud = 2'b11;
        end  
    else
    begin
        addr_ud = 2'b10;
        pkmn_on = 1'b0;
    end
end
end



//new_map_prev_bound_rom new_map_prev_bound_rom (.clka(negedge_vga_clk), .addra(rom_address_map_bound), .douta(rom_q_map_bound));
//new_map_prev_bound_palette new_map_prev_bound_palette (.index(rom_q_map_bound),   .red(red_map_bound), .green (green_map_bound), .blue(blue_map_bound));



//ROM Instantiation
bulbasaur_rom bulbasaur_rom (.clka(negedge_vga_clk), .addra (rom_address_pokemon), .douta(rom_bulb));
bulbasaur_palette bulbasaur_palette (.index(rom_bulb), .red(red_bulb), .green(green_bulb), .blue(blue_bulb));

charmandar_rom charmandar_rom (.clka(negedge_vga_clk), .addra (rom_address_pokemon), .douta(rom_char));
charmandar_palette charmandar_palette (.index (rom_char), .red(red_char), .green (green_char), .blue(blue_char));

pikachu_rom pikachu_rom (.clka(negedge_vga_clk), .addra(rom_address_pokemon), .douta(rom_pika));
pikachu_palette pikachu_palette (.index(rom_pika), .red(red_pika), .green(green_pika), .blue(blue_pika));

poliwrath_rom poliwrath_rom (.clka(negedge_vga_clk), .addra(rom_address_pokemon), .douta(rom_poli));
poliwrath_palette poliwrath_palette (.index (rom_poli), .red(red_poli), .green(green_poli), .blue(blue_poli));

squirtle_rom squirtle_rom (.clka(negedge_vga_clk), .addra(rom_address_pokemon), .douta(rom_sqtl));
squirtle_palette squirtle_palette (.index(rom_sqtl), .red(red_sqtl), .green(green_sqtl), .blue(blue_sqtl));


player_up_down_rom player_up_down_rom (.clka(negedge_vga_clk), .addra(rom_address), .douta(rom_q));
player_up_down_palette player_up_down_palette (   .index(rom_q),   .red(palette_red),   .green(palette_green), .blue(palette_blue));

player_left_right_rom player_left_right_rom (.clka(negedge_vga_clk), .addra(rom_address_lr),. douta(rom_q_lr));
player_left_right_palette player_left_right_palette (.index(rom_q_lr), .red(palette_red_lr), .green(palette_green_lr),   .blue(palette_blue_lr));

//Map Rom Instantiation
custom_map_rom custom_map_rom (   .clka(negedge_vga_clk), .addra(rom_address_map1), .douta(rom_q_map1));
custom_map_palette custom_map_palette (.index(rom_q_map1), .red(red_map1), .green(green_map1), .blue(blue_map1));

custom_map2_rom custom_map2_rom(   .clka(negedge_vga_clk), .addra(rom_address_map2), .douta(rom_q_map2));
custom_map2_palette custom_map2_palette(.index(rom_q_map2), .red(red_map2), .green(green_map2), .blue(blue_map2));

//Fight Scene Rom
fight_scene_rom fight_scene_rom (.clka(negedge_vga_clk), .addra(rom_address_fight), .douta(rom_q_fight));
fight_scene_palette fight_scene_palette (.index (rom_q_fight), .red(red_fight), .green(green_fight), .blue(blue_fight));

player_catch_rom player_catch_rom ( .clka(negedge_vga_clk), .addra (rom_address_fight_player), .douta(rom_q_fight_player));
player_catch_palette player_catch_palette (.index (rom_q_fight_player), .red   (red_fight_player), .green (green_fight_player), .blue(blue_fight_player));

fight_pikachu_rom fight_pikachu_rom ( .clka   (negedge_vga_clk), .addra (rom_address_fight_pokemon), .douta (rom_q_fight_pikachu));
fight_pikachu_palette fight_pikachu_palette (.index (rom_q_fight_pikachu), .red   (red_fight_pikachu), .green (green_fight_pikachu), .blue  (blue_fight_pikachu));

pokeball_fight_rom pokeball_fight_rom (.clka(negedge_vga_clk), .addra (rom_address_pokeball), .douta(rom_q_pokeball));
pokeball_fight_palette pokeball_fight_palette (.index(rom_q_pokeball), .red(red_ball), .green(green_ball), .blue(blue_ball));

bulbasaur_fight_rom bulbasaur_fight_rom ( .clka   (negedge_vga_clk), .addra (rom_address_fight_pokemon), .douta (rom_q_bulb_fight));
bulbasaur_fight_palette bulbasaur_fight_palette (.index (rom_q_bulb_fight), .red   (red_bulb_fight), .green (green_bulb_fight), .blue  (blue_bulb_fight));

charmander_fight_rom charmander_fight_rom ( .clka   (negedge_vga_clk), .addra (rom_address_fight_pokemon), .douta (rom_q_char_fight));
charmander_fight_palette charmander_fight_palette (.index (rom_q_char_fight), .red   (red_char_fight), .green (green_char_fight), .blue  (blue_char_fight));

poliwrath_fight_rom poliwrath_fight_rom ( .clka   (negedge_vga_clk), .addra (rom_address_fight_pokemon), .douta (rom_q_poli_fight));
poliwrath_fight_palette poliwrath_fight_palette (.index (rom_q_poli_fight), .red   (red_poli_fight), .green (green_poli_fight), .blue  (blue_poli_fight));

squirtle_fight_rom squirtle_fight_rom ( .clka   (negedge_vga_clk), .addra (rom_address_fight_pokemon), .douta (rom_q_sqtl_fight));
squirtle_fight_palette squirtle_fight_palette (.index (rom_q_sqtl_fight), .red   (red_sqtl_fight), .green (green_sqtl_fight), .blue  (blue_sqtl_fight));

starting_map_rom starting_map_rom ( .clka   (negedge_vga_clk), .addra (rom_address_start), .douta (rom_q_start));
starting_map_palette starting_map_palette (.index (rom_q_start), .red(red_start), .green(green_start), .blue(blue_start));

ending_map_rom ending_map_rom ( .clka   (negedge_vga_clk), .addra (rom_address_end), .douta (rom_q_end));
ending_map_palette ending_map_palette (.index (rom_q_end), .red(red_end), .green(green_end), .blue(blue_end));


endmodule