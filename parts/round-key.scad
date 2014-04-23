// Round Key

// Defaults

gRes = 50;
gNudge = 0.01;

module RoundKey(
	Dia,            // key diameter
	Slice,          // key slice removed
	Thick,          // key thickness
    Res = gRes,     // render resolution
	Nudge = gNudge) // render error compensation
	{
	difference()
		{
		color("green")
		cylinder(d = Dia, h = Thick, $fn = Res);
		color("red")
		translate([-Dia/2-Nudge,-1.5*Dia-2*Nudge+Slice,-Nudge])
		cube([Dia+2*Nudge,Dia+2*Nudge,Thick+2*Nudge]);
		}
	}

// Demo

RoundKey(30,20,10);//

