// Square Bracket

use <round-hole.scad>;

// Defaults

gRes = 50;
gNudge = 0.01;

module SquareBracket(
    DimX,           // width
    DimY,           // length
    DimZ,           // thickness
    FastenerPosX,   // fastener width position
    FastenerPosY,   // fastener length position
    FastenerDia,    // fastener diameter
    Res = gRes,     // render resolution
    Nudge = gNudge) // render error compensation
	{
	difference()
		{
		color("green") cube([DimX, DimY, DimZ]);
		color("red")
		RoundHole(FastenerPosX, FastenerPosY, FastenerDia, DimZ);
		}
	}

SquareBracket(20,30,10, 15,25,5);


