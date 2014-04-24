// Square Bracket

use <round-holes.scad>;

// Defaults

gRes = 50;
gNudge = 0.01;

module SquareBracket(
    DimX,           // width
    DimY,           // length
    DimZ,           // thickness
	DrillSched,     // drill schedule list, [[PosX,PosY,Dia,Depth],...]
    Res = gRes,     // render resolution
    Nudge = gNudge) // render error compensation
	{
	difference()
		{
		cube([DimX, DimY, DimZ]);
		RoundHoles(DrillSched);
		}
	}

// Demo

SquareBracket(20,30,10, [[5,5,5,10],[5,25,5,10],[15,25,5,10],[15,5,5,10]]);


