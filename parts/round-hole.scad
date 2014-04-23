// Round Hole

// Defaults

gRes = 50;
gNudge = 0.01;

module RoundHole(
	PosX,	        // drill position x
	PosY,	        // drill position y
	Dia,		        // drill diameter
	Depth,	        // drill depth
	Res = gRes,		// render resolution
	Nudge = gNudge)	// render error compensation
	{
	translate([PosX,PosY,-Nudge]) 
	cylinder(h = Nudge + Depth + Nudge, d = Dia, $fn = Res);
	}

// Demo

RoundHole(10,15,5,10);
