//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Modified by Zuofu Cheng   08-19-2023                               --
//    Fall 2023 Distribution                                             --
//                                                                       --
//    For use with ECE 385 USB + HDMI Lab                                --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  ball ( input logic Reset, frame_clk, vga_clk, clk,
            input logic [15:0] keycode,
            input logic [9:0] pkmn_x_len, pkmn_y_len,
               output logic [9:0]  BallX, BallY, BallS, BallS_x, BallS_y,
               output logic move_map, prev_map, fight, 
               output logic pkmn_animation, in_ball, start, ending, caught,
               output logic [1:0] ball_sprite, pokemon_caught,
               output logic [2:0] fight_animation, pokemon_num,
               output logic [3:0] sprite_pos);
    
    logic [9:0] Ball_X_Motion, Ball_Y_Motion;
   logic [9:0] Ball_X_Motion_, Ball_Y_Motion_;
   logic [9:0] BallX_, BallY_; 
    parameter [9:0] Ball_X_Center=79;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=215;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis
    parameter [9:0] Ball_X_Step_Two = 2;
    parameter [9:0] Ball_Y_Step_Two = 2;
    
    logic [7:0] up = 8'h52;
    logic [7:0] down = 8'h51;
    logic [7:0] left = 8'h50;
    logic [7:0] right = 8'h4F;
    logic [7:0] prev_key;
    
    parameter [9:0] BallS_X = 16;
    parameter [9:0] BallS_Y = 20;
    assign BallS = 16;
    assign BallS_x = BallS_X;  // default ball size
    assign BallS_y = BallS_Y;
    
   logic [5:0] sprite_count = 6'h00;
   logic [6:0] sprite_count_new = 7'h00;
   logic [6:0] ball_count = 7'h00;
    //Position for PKMN
    parameter [9:0] PosX = 10'd79; 
    parameter [9:0] PosY = 10'd260;
    parameter [9:0] PosX2 = 10'd350;
    parameter [9:0] PosY2 = 10'd260;
   

   logic char_move = 1'b0;
   
   logic [9:0] speed_counter;
   logic [2:0] poke_num;
   logic [2:0] ece_catch = 3'b000;
//always_comb
//begin
//if (char_move)
//begin
//    if(sprite_count_new < 7'h10)
//        begin
//            fight_animation <= 3'b001;
//            sprite_count_new <= sprite_count_new + 1;
//        end
//        else if (sprite_count_new >= 7'h10 && sprite_count_new < 7'h20)
//        begin
//            fight_animation <= 3'b010;
//            sprite_count_new <= sprite_count_new + 1;
//        end
//        else if (sprite_count_new >= 7'h20 && sprite_count_new < 7'h30)
//        begin
//            fight_animation <= 3'b011;
//            sprite_count_new <= sprite_count_new + 1;
//        end
//        else if (sprite_count_new >= 7'h30 && sprite_count_new < 7'h40)
//        begin
//            fight_animation <= 3'b100;
//            sprite_count_new <= sprite_count_new + 1;
//        end
//        else
//            begin
//            fight_animation <= 3'b000;
//            in_ball <= 1'b1;
//            char_move <= 1'b0;
//            end
//end
    
//if (in_ball)
//begin
//    if(sprite_count < 5'h0A)
//    begin
//        ball_sprite <= 2'b01;
//        sprite_count <= sprite_count + 1;
//    end
//    else if (sprite_count >= 5'h0A && sprite_count < 5'h14)
//    begin
//        ball_sprite <= 2'b10;
//        sprite_count <= sprite_count + 1;
//    end
//    else
//    begin
//        ball_sprite <= 2'b11;
//        sprite_count <= sprite_count + 1;
//        if (sprite_count == 5'h1f) sprite_count <= 5'h00;
//        in_ball <= 1'b0;
//    end
//end

//end

always_comb
begin
    if(keycode == 16'h1E) //Press number 1 for 1x speed
    begin
        speed_counter = 10'd1;
    end
    else if (keycode == 16'h1F) //Press number 2 for 2x speed
    begin
        speed_counter = 10'd2;
    end
    
end


always_ff @ (posedge frame_clk or posedge Reset) //make sure the frame clock is instantiated correctly
begin: Move_Ball

    if (Reset)  // asynchronous Reset
    begin 
        Ball_Y_Motion <= 10'd0; //Ball_Y_Step;
        Ball_X_Motion <= 10'd0; //Ball_X_Step;
        BallY <= Ball_Y_Center;
        BallX <= Ball_X_Center;
        sprite_pos <= 3'b000;
        pkmn_animation <= 1'b1;
        fight_animation <= 3'b000;
        in_ball <= 1'b0;
        ball_sprite <= 2'b00;
        start <= 1'b0;
        ending <= 1'b0;
        move_map <= 1'b0;
        ece_catch <= 3'b000;
        pokemon_caught <= 2'b00;
        fight <= 1'b0;
        
    end
   
    else
    begin
        if (start == 1'b0 && keycode != 16'h00)
        begin
            start <= 1'b1;
            prev_map <= 1'b1;
        end
        
        if (move_map != prev_map)
        begin
            caught <= 1'b0;
            pokemon_num <= poke_num;
            prev_map <= move_map;
        end
        
        if(start == 1'b1) begin
        if (pokemon_caught == 2'b11) ending <= 1'b1;
        if (caught == 1'b1 && fight == 1'b1) fight <= 1'b0;
        
        if (sprite_count < 6'h10) begin
            pkmn_animation <= 1'b0;
            sprite_count <= sprite_count + speed_counter;
        end
         else begin
            pkmn_animation <= 1'b1;
            sprite_count <= sprite_count + speed_counter;
            if (sprite_count > 6'h1f) sprite_count <= 6'h00;
            end
        
//        if(ball_count < 7'h08)
//        begin
//            ball_sprite <= 2'b01;
//            ball_count <= ball_count + 1;
//        end
//        else if (ball_count >= 7'h08 && ball_count < 7'h10)
//        begin
//            ball_sprite <= 2'b10;
//            ball_count <= ball_count + 1;
//        end
//        else
//        begin
//            ball_sprite <= 2'b11;
//            ball_count <= ball_count + 1;
//            if (ball_count == 7'h20) 
//            begin
//            ball_count <= 7'h00;
//            ball_sprite <= 2'b00;
//            end
//        end
        
    if (fight == 1'b1)
    begin
        if (keycode == 16'h06) // C is pressed
        char_move <= 1'b1;
        else if (keycode == 16'h15) // R is pressed
        begin
            fight <= 1'b0;
            sprite_count_new <= 7'h00;
        end
       else if (keycode == 16'h20) ece_catch[2] <= 1'b1;
       else if (keycode == 16'h25) ece_catch[1] <= 1'b1;
       else if (keycode == 16'h22) ece_catch[0] <= 1'b1;
        if (char_move == 1'b1)
        begin
        if(sprite_count_new < 7'h10 && in_ball == 1'b0)
            begin
                fight_animation <= 3'b001;
                sprite_count_new <= sprite_count_new + speed_counter;
            end
            else if (sprite_count_new >= 7'h10 && sprite_count_new < 7'h20 && in_ball == 1'b0)
            begin
                fight_animation <= 3'b010;
                sprite_count_new <= sprite_count_new + speed_counter;
            end
            else if (sprite_count_new >= 7'h20 && sprite_count_new < 7'h30 && in_ball == 1'b0)
            begin
                fight_animation <= 3'b011;
                sprite_count_new <= sprite_count_new + speed_counter;
            end
            else if (sprite_count_new >= 7'h30 && sprite_count_new < 7'h40 && in_ball == 1'b0)
            begin
                fight_animation <= 3'b100;
                sprite_count_new <= sprite_count_new + speed_counter;
            end
            else
            begin
                fight_animation <= 3'b000;
                in_ball <= 1'b1;
                
                if(ball_count < 7'h10)
                begin
                    ball_sprite <= 2'b01;
                    ball_count <= ball_count + speed_counter;
                end
                else if (ball_count >= 7'h10 && ball_count < 7'h20)
                begin
                    ball_sprite <= 2'b10;
                    ball_count <= ball_count + speed_counter;
                end
                else 
                begin
                    ball_sprite <= 2'b11;
                    ball_count <= ball_count + speed_counter;
                    if (ball_count == 7'h50) 
                    begin
                        if ((poke_num != 3'b011 && poke_num != 3'b100) || ece_catch == 3'b111)
                        begin
                            caught <= 1'b1;
                            pokemon_caught = pokemon_caught + 1;
                            ece_catch <= 3'b000;
                        end
                        ball_sprite <= 2'b00;
                        ball_count <= 7'h00;
                        sprite_count_new <= 7'h00;
                        in_ball <= 1'b0;
                        char_move <= 1'b0;
                    end
                end
            end
        end

    end
    
//    if (catch_en == 1'b1) 
//        begin
//            if (keycode == 16'h06) // If C is pressed
//            begin 
//                catch_en <= 1'b1;
//            end 
//            else if (keycode == 16'h15) // If R is pressed
//            begin 
//                catch_en <= 1'b0;
//            end
//        end
        
        else begin
            if (move_map == 1'b0) //1st Map
            begin
                     //modify to control ball motion with the keycode
                if (keycode == 16'h52) //Up = 82 = 8'h52
                begin
                    Ball_Y_Motion <= -speed_counter;
                    Ball_X_Motion <= 10'd0;
                    
                    //Pokemon Interaction Boundary
                    if (caught == 1'b0 && ((BallX >= PosX && BallX < PosX + pkmn_x_len) || ((BallX + BallS_X / 3) >= PosX  && (BallX + BallS_X / 3) < PosX + pkmn_x_len) || ((BallX + 2 * BallS_X / 3) >= PosX  && (BallX + 2 * BallS_X / 3) < PosX + pkmn_x_len)))
                        if (BallY == (PosY + pkmn_y_len) || (BallY == (PosY + pkmn_y_len - 1)) )
                        begin
                            fight <= 1'b1;
                            Ball_Y_Motion <= 10'd3;
                        end
                         
                    if (BallY <= 10'd215)   //Top Boundary
                        begin
                        Ball_Y_Motion <= speed_counter;
                        end
                        
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b0101; // 5
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0100; // 4
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                        prev_key <= 16'h52;
                end
                
                else if (keycode == 16'h50) //Left = 80 = 8'h50
                begin
                    Ball_X_Motion <= -speed_counter;
                    Ball_Y_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallY >= PosY && BallY < PosY + pkmn_y_len) || ((BallY + BallS_Y / 3) >= PosY  && (BallY + BallS_Y / 3) < PosY + pkmn_y_len) || ((BallY + 2 * BallS_Y / 3) >= PosY  && (BallY + 2 * BallS_Y / 3) < PosY + pkmn_y_len)))
                        if (BallX == PosX + pkmn_x_len || (BallX == PosX + pkmn_x_len - 1))
                        begin
                            fight <= 1'b1;
                            Ball_X_Motion <= 10'd3;
                        end
                    
                    if (BallX <= 10'd79 ) //Left Boundary
                        Ball_X_Motion <= speed_counter;
                        
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b1000; // 8
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0111; // 7
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key <= 16'h50;
                end
                
                else if (keycode == 8'h51) //Down = 81 = 8'h51
                begin
                    Ball_Y_Motion <= speed_counter;
                    Ball_X_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallX >= PosX && BallX < PosX + pkmn_x_len) || ((BallX + BallS_X / 3) >= PosX  && (BallX + BallS_X / 3) < PosX + pkmn_x_len) || ((BallX + 2 * BallS_X / 3) >= PosX  && (BallX + 2 * BallS_X / 3) < PosX + pkmn_x_len)))
                        if (BallY + BallS_Y == PosY || (BallY + BallS_Y == PosY + 1))
                        begin
                            fight <= 1'b1;
                            Ball_Y_Motion <= -10'd3;
                        end        
                    
                    if (BallY + BallS_Y >= 10'd295)   //Bottom Boundary
                            Ball_Y_Motion <= -speed_counter;
                    
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b0010;
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0001;
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key = 16'h51;
                end
                
                else if (keycode == 8'h4F) //Right = 79 = 8'h4F
                begin
                    Ball_X_Motion <= speed_counter;
                    Ball_Y_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallY >= PosY && BallY < PosY + pkmn_y_len) || ((BallY + BallS_Y / 3) >= PosY  && (BallY + BallS_Y / 3) < PosY + pkmn_y_len) || ((BallY + 2 * BallS_Y / 3) >= PosY  && (BallY + 2 * BallS_Y / 3) < PosY + pkmn_y_len)))
                        if (BallX + BallS_X == PosX || (BallX + BallS_X == PosX + 1))
                        begin
                            fight <= 1'b1;
                            Ball_X_Motion <= -10'd3;
                        end
                    
                    if ((BallX + BallS_X) >= Ball_X_Max ) //Right Boundary
                        begin
                            Ball_Y_Motion <= 10'd0;
                            Ball_X_Motion <= -(Ball_X_Max -BallS_X);
                            move_map <= 1'b1;
                        end
                    
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b1011; // 11
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b1010; // 10
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key <= 16'h4F;
                end
                
                else 
                begin
                    Ball_Y_Motion <= 10'd0;  //Ball stays still when keyboard is not pressed
                    Ball_X_Motion <= 10'd0;
                    
                    case (prev_key)
                        8'h52: sprite_pos <= 4'b0011; //Up
                        8'h50: sprite_pos <= 4'b0110; //Left
                        8'h51: sprite_pos <= 4'b0000; //Down
                        8'h4F: sprite_pos <= 4'b1001; //Right
                        default: sprite_pos <= 4'b0000;
                    endcase;
                end
                BallY <= (BallY + Ball_Y_Motion);  // Update ball position
                BallX <= (BallX + Ball_X_Motion);
                
//                if ((BallX <= PosX + pkmn_x_len && BallX >= PosX) && (BallY + BallS_Y >= PosY - 1))
//                             //|| (BallX <= PosX + pkmn_x_len + 1 || BallX + BallS_X >= PosX - 1) && BallY + BallS_Y >= PosY - 1 && BallY <= PosY + pkmn_y_len +1 )
//                    begin
//                    fight = 1'b1;
//                    // prevent movement
//                end
//                if (caught == 1'b1 && fight == 1'b1) begin
//                    fight = 1'b0;
//                end 
                
             end
             
             else if (move_map == 1'b1) //2nd Map
             begin
                  //modify to control ball motion with the keycode
                if (keycode == 16'h52) //Up = 82 = 8'h52
                begin
                    Ball_Y_Motion <= -speed_counter;
                    Ball_X_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && (BallX >= PosX2 && BallX < PosX2 + pkmn_x_len) || ((BallX + BallS_X / 3) >= PosX2  && (BallX + BallS_X / 3) < PosX2 + pkmn_x_len) || ((BallX + 2 * BallS_X / 3) >= PosX2  && (BallX + 2 * BallS_X / 3) < PosX2 + pkmn_x_len))
                        if (BallY == (PosY2 + pkmn_y_len) || (BallY == (PosY2 + pkmn_y_len - 1)) )
                        begin
                            fight <= 1'b1;
                            Ball_Y_Motion <= 10'd3;
                        end
                         
                    if (BallX >= 10'd96 && BallX + BallS_X < 10'd543)
                        if (BallY < 10'd70)   //Top Boundary
                            Ball_Y_Motion <= speed_counter;
                    if (BallX >= 0 && BallX  < 10'd96 )
                        if (BallY <= 10'd215)
                            Ball_Y_Motion <= speed_counter;
                    if (BallX + BallS_X >= 10'd543 && BallX + BallS_X < Ball_X_Max)
                        if (BallY <= 10'd215)
                            Ball_Y_Motion <= speed_counter;
                                                  
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b0101; // 5
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0100; // 4
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                        prev_key <= 16'h52;
                end
                
                else if (keycode == 16'h50) //Left = 80 = 8'h50
                begin
                    Ball_X_Motion <= -speed_counter;
                    Ball_Y_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallY >= PosY2 && BallY < PosY2 + pkmn_y_len) || ((BallY + BallS_Y / 3) >= PosY2  && (BallY + BallS_Y / 3) < PosY2 + pkmn_y_len) || ((BallY + 2 * BallS_Y / 3) >= PosY2  && (BallY + 2 * BallS_Y / 3) < PosY2 + pkmn_y_len)))
                        if (BallX == PosX2 + pkmn_x_len || (BallX == PosX2 + pkmn_x_len - 1))
                        begin
                            fight <= 1'b1;
                            Ball_X_Motion <= 10'd3;
                        end
                    
                    if (BallY >= 10'd215 && BallY + BallS_Y < 10'd295)
                        if (BallX <= 1) //Left Boundary
                        begin
                            Ball_Y_Motion <= 10'd0;
                            Ball_X_Motion <= Ball_X_Max - BallS_X;
                            move_map <= 1'b0;
                        end
                    if (BallY >= 0 && BallY < 10'd215)
                        if(BallX < 10'd96)
                            Ball_X_Motion <= speed_counter;
                   if (BallY + BallS_Y >= 10'd295 && BallY < Ball_Y_Max)
                        if(BallX < 10'd96)
                            Ball_X_Motion <= speed_counter;     
                            
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b1000; // 8
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0111; // 7
                        sprite_count <= sprite_count + 1;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key = 16'h50;
                end
                
                else if (keycode == 8'h51) //Down = 81 = 8'h51
                begin
                    Ball_Y_Motion <= speed_counter;
                    Ball_X_Motion <= 10'd0;
 
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallX >= PosX2 && BallX < PosX2 + pkmn_x_len) || ((BallX + BallS_X / 3) >= PosX2  && (BallX + BallS_X / 3) < PosX2 + pkmn_x_len) || ((BallX + 2 * BallS_X / 3) >= PosX2  && (BallX + 2 * BallS_X / 3) < PosX2 + pkmn_x_len)))
                        if (BallY + BallS_Y == PosY2 || (BallY + BallS_Y == PosY2 + 1))
                        begin
                            fight <= 1'b1;
                            Ball_Y_Motion <= -10'd3;
                        end                   
                    
                    if (BallX >= 10'd96 && BallX + BallS_X < 10'd543)
                        if (BallY + BallS_Y > 10'd359)   //Bottom Boundary
                            Ball_Y_Motion <= -speed_counter;
                    if (BallX >= 0 && BallX  < 10'd96)
                        if (BallY + BallS_Y > 10'd294)
                            Ball_Y_Motion <= -speed_counter;
                    if (BallX + BallS_X >= 10'd543 && BallX < Ball_X_Max)
                        if (BallY + BallS_Y > 10'd294)
                            Ball_Y_Motion <= -speed_counter;
                            
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b0010;
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b0001;
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key = 16'h51;
                end
                
                else if (keycode == 8'h4F) //Right = 79 = 8'h4F
                begin
                    Ball_X_Motion <= speed_counter;
                    Ball_Y_Motion <= 10'd0;
                    
                    //Pokemon Interaction
                    if (caught == 1'b0 && ((BallY >= PosY2 && BallY < PosY2 + pkmn_y_len) || ((BallY + BallS_Y / 3) >= PosY2  && (BallY + BallS_Y / 3) < PosY2 + pkmn_y_len) || ((BallY + 2 * BallS_Y / 3) >= PosY2  && (BallY + 2 * BallS_Y / 3) < PosY2 + pkmn_y_len)))
                        if (BallX + BallS_X == PosX2 || (BallX + BallS_X == PosX2 + 1))
                        begin
                            fight <= 1'b1;
                            Ball_X_Motion <= -10'd3;
                        end
                    
                    if (BallY >= 10'd215 && BallY + BallS_Y < 10'd295)
                        if (BallX >= Ball_X_Max) //Right Boundary
                        begin
                            ending <= 1'b1;
                        end
                    if (BallY >= 0 && BallY < 10'd215)
                        if(BallX + BallS_X >= 10'd543)
                            Ball_X_Motion <= -speed_counter;
                    if (BallY + BallS_Y >= 10'd295 && BallY + BallS_Y < Ball_Y_Max)
                        if(BallX + BallS_X >= 10'd543)
                            Ball_X_Motion <= -speed_counter;
                            
                    if (sprite_count < 6'h10) 
                    begin
                        sprite_pos <= 4'b1011; // 11
                        sprite_count <= sprite_count + speed_counter;
                    end
                    else 
                    begin
                        sprite_pos <= 4'b1010; // 10
                        sprite_count <= sprite_count + speed_counter;
                        if (sprite_count > 6'h1f) sprite_count <= 6'h00;
                    end
                    prev_key = 16'h4F;
                end
                else 
                begin
                    Ball_Y_Motion <= 10'd0;  //Ball stays still when keyboard is not pressed
                    Ball_X_Motion <= 10'd0;
                    
                    case (prev_key)
                        8'h52: sprite_pos <= 4'b0011; //Up
                        8'h50: sprite_pos <= 4'b0110; //Left
                        8'h51: sprite_pos <= 4'b0000; //Down
                        8'h4F: sprite_pos <= 4'b1001; //Right
                        default: sprite_pos <= 4'b0000;
                    endcase;
                end
                BallY <= (BallY + Ball_Y_Motion);  // Update ball position
                BallX <= (BallX + Ball_X_Motion);
                
//                if (BallX + BallS_X >= PosX2  && BallX + BallS_X < PosX2 + pkmn_x_len)
//                    if (BallY + BallS_Y >= PosY2 - 1)
//                             //|| (BallX <= PosX + pkmn_x_len + 1 || BallX + BallS_X >= PosX - 1) && BallY + BallS_Y >= PosY - 1 && BallY <= PosY + pkmn_y_len +1 )
//                        begin
//                        fight = 1'b1;
//                        // prevent movement
//                        end
//                if (caught == 1'b1 && fight == 1'b1) begin
//                    fight = 1'b0;
//                end 
            end
           
         end
      end   
end  

      //                 //Fast   
//                 else if (keycode == 16'h1B52 || keycode == 16'h521B) // Up
//                 begin
//                    Ball_Y_Motion <= -10'd2;
//                    Ball_X_Motion <= 10'd0;
                         
//                    if ( (BallY - BallS) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
//                        Ball_Y_Motion <= Ball_Y_Step_Two;
//                 end
//                 else if (keycode == 16'h1B50 || keycode == 16'h501B) // Left
//                 begin
//                    Ball_X_Motion <= -10'd2;
//                    Ball_Y_Motion <= 10'd0;
                         
//                    if ( (BallX - BallS) < Ball_X_Min)  // Ball is at the Left edge, BOUNCE!
//                        Ball_X_Motion <= Ball_X_Step_Two;
//                 end
//                 else if (keycode == 16'h1B51 || keycode == 16'h511B) //Down
//                 begin
//                    Ball_Y_Motion <= 10'd2;
//                    Ball_X_Motion <= 10'd0;
                    
//                    if ( (BallY + BallS) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
//                        Ball_Y_Motion <= -(Ball_Y_Step_Two);  // 2's complement.
//                 end
//                 else if (keycode == 16'h1B4F || keycode == 16'h4F1B) // Right
//                 begin
//                    Ball_X_Motion <= 10'd2;
//                    Ball_Y_Motion <= 10'd0;
                        
//                    if ( (BallX + BallS) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
//                        Ball_X_Motion <= -(Ball_X_Step_Two);  // 2's complement.
//                 end"
         end
         
         random_num random_num_gen(.Clk(frame_clk), .en(1'b1), .poke_num(poke_num));
endmodule