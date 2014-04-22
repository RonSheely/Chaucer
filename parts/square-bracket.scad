// Square Bracket

use <round-hole.scad>;

// Defaults

gDimX = 20;
gDimY = 30;
gDimZ = 10;
gFastenerDia = 5;
gFastenerPosX = gDimX/2;
gFastenerPosY = gDimY/2;
gRes = 50;
gNudge = 0.01;

module SquareBracket(
    DimX = gDimX,                 // width
    DimY = gDimY,                 // length
    DimZ = gDimZ,                 // thickness
    FastenerPosX = gFastenerPosX,	 // fastener width position
    FastenerPosY = gFastenerPosY,	 // fastener length position
    FastenerDia = gFastenerDia,   // fastener diameter
    Res = gRes,                   // render resolution
    Nudge = gNudge)               // render error compensation
	{
	difference()
		{
		color("green") cube([DimX, DimY, DimZ]);
		color("red")
		RoundHole(gFastenerPosX, FastenerPosY, FastenerDia, DimZ);
		}
	}

SquareBracket();


