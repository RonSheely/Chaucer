// Round Bracket
// Construct a round nosed bracket.

use <round-holes.scad>;
use <round-key.scad>;

// Defaults

gRes = 50;
gNudge = 0.01;

module RoundBracket(
    Dia,            // nose diameter
    DimY,           // overall length
    DimZ,           // thickness
	DrillSched,     // drill schedule list, [[PosX,PosY,Dia,Depth],...]
    Res = gRes,     // render resolution
    Nudge = gNudge) // render error compensation
	{
	difference()
		{
		union()
			{
			cube([Dia, DimY-Dia/2, DimZ]);
			translate([Dia/2,DimY-Dia/2,0])
			RoundKey(Dia,Dia/2,DimZ);
			}
		RoundHoles(DrillSched);
		}
	}

// Demo

RoundBracket(20,40,10, [[5,5,5,10],[10,30,5,10],[15,5,5,10]]);


