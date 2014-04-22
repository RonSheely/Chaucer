// Round Hole

// Defaults

gPosX = 10;
gPosY = 15;
gDia = 5;
gDepth = 10;
gRes = 50;
gNudge = 0.01;

module RoundHole(
	PosX = gPosX,	// drill position x
	PosY = gPosY,	// drill position y
	Dia = gDia,		// drill diameter
	Depth = gDepth,	// drill depth
	Res = gRes,		// render resolution
	Nudge = gNudge)	// render error compensation
	{
	translate([PosX,PosY,-Nudge]) 
	cylinder(h = Nudge + Depth + Nudge, d = Dia, $fn = Res);
	}

RoundHole();
