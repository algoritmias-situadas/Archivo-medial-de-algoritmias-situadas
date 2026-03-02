// Loaded by src/GaschPrimeSynth.scd

//-----------------------------------------------------------------------------------------------------------------------
// 3) ULAM SPIRAL
//-----------------------------------------------------------------------------------------------------------------------
(
~visSide    = 45;                         // Cells per side
~visN       = ~visSide * ~visSide;       // Total cells
~visColorIx = Array.fill(~visN, -1);     // -1 = empty cell, 0..9 = color
~visIndex   = 0;
~visCoords  = Array.newClear(~visN);
~visView    = nil;
~primeColors = [
	Color.new255(255,   0,   0),   // red
	Color.new255(255, 128,   0),   // orange
	Color.new255(255, 255,   0),   // yellow
	Color.new255(190, 255,   0),   // yellowgreen
	Color.new255(  0, 200,   0),   // green
	Color.new255(  0, 180, 160),   // aqua
	Color.new255( 90, 180, 255),   // light blue
	Color.new255(  0,   0, 255),   // blue
	Color.new255(160,   0, 200),   // puple
	Color.new255(255,   0, 150)    // pink
];
~nextColorIndex = 0; // Next sequence global index

// BUILD SPIRAL
~buildSpiralCoords = {
	var center = ((~visSide - 1) / 2).floor;
	var x = center;
	var y = center;
	var dirs = [
		Point(1, 0),    // right
		Point(0, -1),   // up
		Point(-1, 0),   // left
		Point(0, 1)     // down
	];
	var dirIndex = 0;
	var stepLen = 1;
	var idx = 0;

	~visCoords[0] = Point(x, y);
	while({ idx < (~visN - 1) }, {
		2.do {
			stepLen.do {
				if(idx >= (~visN - 1)) { ^nil };
				x = x + dirs[dirIndex].x;
				y = y + dirs[dirIndex].y;
				idx = idx + 1;
				~visCoords[idx] = Point(x, y);
			};
			dirIndex = (dirIndex + 1) % 4;
		};
		stepLen = stepLen + 1;
	});
};
~buildSpiralCoords.(); // Init spiral
)
