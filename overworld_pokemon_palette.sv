module bulbasaur_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h7, 4'hC, 4'h7},
	{4'hE, 4'h1, 4'hE},
	{4'h3, 4'h6, 4'h2},
	{4'h0, 4'h1, 4'h0},
	{4'h6, 4'hA, 4'h2},
	{4'h5, 4'h8, 4'h5},
	{4'h8, 4'hD, 4'h4},
	{4'hB, 4'hE, 4'hB}
};

assign {red, green, blue} = palette[index];

endmodule

module charmandar_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h6, 4'h3, 4'h0},
	{4'hD, 4'h9, 4'h5},
	{4'h1, 4'h0, 4'h0},
	{4'hA, 4'h5, 4'h2},
	{4'hE, 4'h8, 4'h4},
	{4'hF, 4'hB, 4'h9},
	{4'h9, 4'h6, 4'h3}
};

assign {red, green, blue} = palette[index];

endmodule

module pikachu_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h8, 4'h7, 4'h3},
	{4'hC, 4'h9, 4'h4},
	{4'h0, 4'h0, 4'h0},
	{4'hE, 4'hC, 4'h6},
	{4'h3, 4'h3, 4'h1},
	{4'hB, 4'hA, 4'h6},
	{4'h6, 4'h5, 4'h2}
};

assign {red, green, blue} = palette[index];

endmodule

module poliwrath_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'h2, 4'h2, 4'h4},
	{4'hE, 4'h1, 4'hE},
	{4'h7, 4'h8, 4'hC},
	{4'hB, 4'hB, 4'hC},
	{4'h5, 4'h5, 4'hA},
	{4'hD, 4'hE, 4'hF},
	{4'h0, 4'h0, 4'h0},
	{4'h5, 4'h5, 4'h7}
};

assign {red, green, blue} = palette[index];

endmodule

module squirtle_palette (
	input logic [2:0] index,
	output logic [3:0] red, green, blue
);

localparam [0:7][11:0] palette = {
	{4'hE, 4'h1, 4'hE},
	{4'h5, 4'h9, 4'hB},
	{4'h3, 4'h4, 4'h4},
	{4'h6, 4'hB, 4'hE},
	{4'hA, 4'h9, 4'h6},
	{4'hE, 4'h1, 4'hE}, //91A
	{4'h4, 4'h7, 4'h7},
	{4'h1, 4'h1, 4'h1}
};

assign {red, green, blue} = palette[index];

endmodule
