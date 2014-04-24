// Fillet (or Round)
// Make a length of mini-crown molding.
// Add the molding to an object to make a fillet.
// Subtract the molding from an object to make a round.

// Defaults

gRes = 50;
gNudge = 0.01;

module Fillet(
	Dia,             // diameter
	Len,             // length
	Res = gRes,		// render resolution
	Nudge = gNudge)	// render error compensation
	{
	difference()
		{
		cube([Dia/2,Dia/2,Len]);
		translate([Dia/2,Dia/2,-Nudge])
		cylinder(d = Dia, h = Nudge+Len+Nudge, $fn = Res);
		}
	}

// Demo

Fillet(10,30);
