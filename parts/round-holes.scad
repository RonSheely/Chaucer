// Round Holes

use <round-hole.scad>;

// Defaults

gRes = 50;
gNudge = 0.01;

module RoundHoles(
	DrillSched,		// drill schedule list, [[PosX,PosY,Dia,Depth],...]
	Res = gRes,		// render resolution
	Nudge = gNudge)	// render error compensation
	{
	for(sched = DrillSched)
		{
		RoundHole(sched[0], sched[1], sched[2], sched[3], Res = gRes, Nudge = gNudge);
		}
	}

RoundHoles([[10,10,5,10],[10,-10,5,10],[-10,10,5,10],[-10,-10,5,10]]);
