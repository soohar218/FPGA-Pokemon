`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2023 11:59:30 PM
// Design Name: 
// Module Name: random_num
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module random_num(
        input logic Clk, en,
        output logic [2:0] poke_num
    );
    logic [4:0] result = 5'b11111;
    
    always_ff @ (posedge Clk)
    begin
    if(en)
            result <= {result[3:0] ,(result[4] ^ result[3])};
    end

always_comb
begin
    if ((result == 5'h1f) || (result == 5'h10) || (result == 5'h08) || (result == 5'h06) || (result == 5'h05)) begin
        poke_num = 3'b000;

        end
    else if ((result == 5'h1e) || (result == 5'h04) || (result == 5'h19) || (result == 5'h0a)) begin
        poke_num = 3'b001;
        end
    else if ((result == 5'h1c) || (result == 5'h01) || (result == 5'h03) || (result == 5'h17)) begin
        poke_num = 3'b010;
        end
    else if ((result == 5'h18) || (result == 5'h02) || (result == 5'h11) || (result == 5'h0b)) begin
        poke_num = 3'b011;
        end
    else if ((result == 5'h0c) || (result == 5'h12) || (result == 5'h0f) || (result == 5'h15)) begin
        poke_num = 3'b100;
        end
    end

endmodule