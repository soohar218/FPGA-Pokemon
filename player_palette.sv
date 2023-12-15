//Up Down Sprite Palette
module player_up_down_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h6, 4'h1, 4'h6},
	{4'hA, 4'h7, 4'h5},
	{4'hE, 4'h1, 4'hE},
	{4'h5, 4'h2, 4'h2},
	{4'h8, 4'h3, 4'h3},
	{4'hD, 4'hC, 4'hC},
	{4'hE, 4'h1, 4'hE},
	{4'h4, 4'h3, 4'h6}, //436
	{4'hF, 4'h6, 4'h4},
	{4'hC, 4'h4, 4'h3},
	{4'hE, 4'hC, 4'h5},
	{4'h1, 4'h0, 4'h1},
	{4'h6, 4'h7, 4'h9},
	{4'h9, 4'h1, 4'h8},
	{4'hC, 4'h9, 4'h8},
	{4'h2, 4'h1, 4'h3}
};

assign {red, green, blue} = palette[index];

endmodule

//Left Right Sprite Palette
module player_left_right_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'hB, 4'h3, 4'h3},
	{4'h6, 4'h2, 4'h2},
	{4'hE, 4'hA, 4'h7},
	{4'h0, 4'h0, 4'h0},
	{4'h8, 4'h5, 4'h4},
	{4'hF, 4'h6, 4'h4},
	{4'hE, 4'h1, 4'hE},
	{4'h9, 4'h1, 4'h7},
	{4'h5, 4'h0, 4'h5},
	{4'hB, 4'h7, 4'h6},
	{4'hC, 4'hB, 4'hC},
	{4'h4, 4'h3, 4'h6},
	{4'h8, 4'h3, 4'h3},
	{4'h3, 4'h1, 4'h2},
	{4'h9, 4'h8, 4'h9}
};

assign {red, green, blue} = palette[index];

endmodule

//Map 1 Palette
module custom_map_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h7, 4'hC, 4'hA},
	{4'h3, 4'h8, 4'h3},
	{4'hE, 4'hD, 4'h8},
	{4'h4, 4'h7, 4'hD},
	{4'h4, 4'hA, 4'h6},
	{4'h5, 4'hA, 4'h4},
	{4'h8, 4'hD, 4'h6},
	{4'h2, 4'h6, 4'h2},
	{4'h7, 4'h9, 4'h9},
	{4'hB, 4'hD, 4'h9},
	{4'h5, 4'hB, 4'h8},
	{4'hA, 4'hF, 4'h7},
	{4'h6, 4'h4, 4'h4},
	{4'hA, 4'h7, 4'h6},
	{4'h6, 4'hB, 4'h5},
	{4'hB, 4'hC, 4'hD}
};

assign {red, green, blue} = palette[index];

endmodule

//Map 2 Sprite Palette
module custom_map2_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h3, 4'h5, 4'h1},
	{4'hE, 4'hD, 4'h8},
	{4'h5, 4'hB, 4'h8},
	{4'h3, 4'h8, 4'h3},
	{4'h6, 4'hC, 4'h5},
	{4'hD, 4'h6, 4'h5},
	{4'h9, 4'hE, 4'h7},
	{4'h7, 4'hC, 4'hA},
	{4'h5, 4'hA, 4'h4},
	{4'h7, 4'hD, 4'h6},
	{4'h8, 4'h8, 4'h7},
	{4'h6, 4'h5, 4'h4},
	{4'hB, 4'hD, 4'h9},
	{4'h2, 4'h7, 4'h2},
	{4'hB, 4'hF, 4'h8},
	{4'h3, 4'h9, 4'h6}
};

assign {red, green, blue} = palette[index];

endmodule

module fight_scene_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'h8, 4'hE, 4'h9},
	{4'h3, 4'h4, 4'h6},
	{4'hD, 4'hC, 4'hA},
	{4'h7, 4'hE, 4'hD},
	{4'hF, 4'hF, 4'hF},
	{4'hA, 4'hE, 4'h7},
	{4'h6, 4'h7, 4'h3},
	{4'h6, 4'hD, 4'h6},
	{4'hB, 4'hF, 4'h9},
	{4'h4, 4'hD, 4'hC},
	{4'h7, 4'h7, 4'h8},
	{4'hB, 4'hA, 4'h6},
	{4'h3, 4'hC, 4'h7},
	{4'hC, 4'hE, 4'hE},
	{4'h2, 4'h3, 4'h3},
	{4'h9, 4'hF, 4'hE}
};

assign {red, green, blue} = palette[index];

endmodule

module player_catch_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h8, 4'h3, 4'h7},
	{4'hD, 4'hB, 4'h9},
	{4'h3, 4'h0, 4'h2},
	{4'hC, 4'h6, 4'h4},
	{4'h5, 4'h3, 4'h3},
	{4'hE, 4'h1, 4'hE},
	{4'hF, 4'hD, 4'hC},
	{4'h1, 4'h0, 4'h0},
	{4'hF, 4'h7, 4'h6},
	{4'h8, 4'h6, 4'h4},
	{4'hD, 4'hB, 4'hC},
	{4'hE, 4'h1, 4'hE}, // D1D
	{4'hF, 4'hD, 4'h7},
	{4'h3, 4'h3, 4'h6},
	{4'hD, 4'hA, 4'h7}
};

assign {red, green, blue} = palette[index];

endmodule

module fight_pikachu_palette (
	input logic [3:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:15][11:0] palette = {
	{4'hE, 4'h1, 4'hE}, // D2C
	{4'hF, 4'hD, 4'h5},
	{4'h2, 4'h0, 4'h0},
	{4'hE, 4'h1, 4'hE},
	{4'hA, 4'h7, 4'h3},
	{4'h6, 4'h3, 4'h0},
	{4'hE, 4'h1, 4'hE}, //807
	{4'hE, 4'hB, 4'h2},
	{4'h4, 4'h3, 4'h3},
	{4'h8, 4'h2, 4'h3},
	{4'hE, 4'h1, 4'hE}, //404
	{4'hE, 4'h1, 4'hE}, //C3A
	{4'hF, 4'hE, 4'h8},
	{4'hD, 4'hA, 4'h4},
	{4'h9, 4'h4, 4'h0},
	{4'hC, 4'h8, 4'h1}
};

assign {red, green, blue} = palette[index];

endmodule

module pokeball_fight_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h5, 4'h2, 4'h5},
	{4'hF, 4'h0, 4'h0},
	{4'hE, 4'hE, 4'hE},
	{4'h8, 4'h0, 4'h0},
	{4'h1, 4'h0, 4'h0},
	{4'hB, 4'h9, 4'hA},
	{4'hA, 4'h1, 4'h9}
};

assign {red, green, blue} = palette[index];

endmodule

module squirtle_fight_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE}, //F0F
	{4'h9, 4'hD, 4'hC},
	{4'h4, 4'h6, 4'h6},
	{4'hC, 4'h7, 4'h2},
	{4'h2, 4'h1, 4'h1},
	{4'h5, 4'hA, 4'h9},
	{4'hF, 4'hC, 4'h7},
	{4'hE, 4'h1, 4'hE} //A1B
};

assign {red, green, blue} = palette[index];

endmodule

module poliwrath_fight_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h7, 4'h8, 4'hB},
	{4'h3, 4'h3, 4'h5},
	{4'hF, 4'hF, 4'hF},
	{4'h9, 4'h1, 4'hA},
	{4'h5, 4'h5, 4'h8},
	{4'hB, 4'hB, 4'hC},
	{4'h0, 4'h0, 4'h0}
};

assign {red, green, blue} = palette[index];

endmodule

module charmander_fight_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'hD, 4'h5, 4'h3},
	{4'h2, 4'h1, 4'h1},
	{4'hF, 4'hD, 4'h8},
	{4'hF, 4'h9, 4'h3},
	{4'h8, 4'h2, 4'h1},
	{4'hB, 4'h1, 4'h8},
	{4'h2, 4'h6, 4'h9}
};

assign {red, green, blue} = palette[index];

endmodule

module bulbasaur_fight_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h0, 4'h8, 4'h8},
	{4'hA, 4'hE, 4'hC},
	{4'h6, 4'h9, 4'h3},
	{4'h1, 4'h4, 4'h2},
	{4'h9, 4'h3, 4'h6},
	{4'hA, 4'hD, 4'h5},
	{4'h6, 4'hD, 4'hA}
};

assign {red, green, blue} = palette[index];

endmodule

module starting_map_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'hF, 4'h7, 4'h2},
	{4'hF, 4'hF, 4'hF},
	{4'hF, 4'hE, 4'h0},
	{4'hE, 4'h1, 4'h2},
	{4'h4, 4'h4, 4'h3},
	{4'h8, 4'h7, 4'h0},
	{4'h8, 4'h8, 4'h8}
};

assign {red, green, blue} = palette[index];

endmodule

module ending_map_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h0, 4'h0, 4'h0},
	{4'hD, 4'hD, 4'hD},
	{4'h0, 4'h9, 4'hD},
	{4'hF, 4'hF, 4'h0},
	{4'hE, 4'h1, 4'h2},
	{4'h8, 4'h8, 4'h8},
	{4'h5, 4'h5, 4'h5},
	{4'hF, 4'hF, 4'hF}
};

assign {red, green, blue} = palette[index];

endmodule

