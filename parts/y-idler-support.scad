/*
Y-Axis Idler Support With Integrated Foot

The primary function is to support the x-axis idler pulley.
The secondary function is to provide the third foot of the
Chaucer 3d vertical printer. This part is fastened to the
end of the Misumi 20mm x 60mm y-axis extrusion with two
self-threading screws.

All dimensions are mm and degrees unless otherwise specified.

ToDo - Add idler pully and toe bracket fillets for strength.
ToDo - Add a fillet at the inside corner at P7.
ToDo - Add a round at the outside corner at P1.
ToDo - Apply globl verses local naming convention.
*/

// Include a 3d carpenter square (ruler) library for debug.
use <ruler.scad>

gExtrusionWidth = 60;
gExtrusionDepth = 20;

gThick = 10;
gBaseWidth = gExtrusionWidth;
gBaseDepth = gExtrusionDepth;
gToeWidth = 50;
gToeDepth = 22;

// gToeIn specifies the taper of the toe defined by the 
// distanced the toe spreads away from a vertical from
// the corner apex. Since one apex is closer to the toe
// floor than the other, we have one "gLitteToeIn" and
// one regular gToeIn.
gToeIn = (gBaseWidth-gToeWidth)/2;
gLittleToeIn = gThick * gToeIn / gToeDepth;

gWingWidth = 35;

gResolution = 50;
gFRRadius = 1;
gBaseFastenerDia = 5;
gFootFastenerDia = 5;

gToeBracketDepth = 30;
gToeBracketWidth = 16;

gIdlerBracketDepth = 21;
gIdlerBracketWidth = 21;
gIdlerFastenerDia = 2.5;

// These points define corners for the 2d face outline of the body.

gP1 = [0,gToeDepth-gThick];
gP2 = [0,gToeDepth+gBaseDepth];
gP3 = [gWingWidth+gBaseWidth,gToeDepth+gBaseDepth];
gP4 = [gWingWidth+gBaseWidth,gToeDepth];
gP5 = [gWingWidth+gBaseWidth-gToeIn,0];
gP6 = [gWingWidth+gToeIn,0];
gP7 = [gWingWidth+gLittleToeIn,gToeDepth-gThick];

// Draw a ruler.
% translate([0,0,0])
rotate([0,0,0])
xyzruler(30);

// Create the body by extruding a 2d polygon,
// given the vertices and thickness.
// Place the vertices clockwise, starting from the lower left vertex.
module Body(CornerPoints, Thick, FRRadius)
	{
	difference()
		{
		// Make the body by extruding a 2d polygon.
		linear_extrude(height = Thick)
		polygon(points = CornerPoints);

		// Drill holes for the mounting fasteners.
		translate([gWingWidth+gBaseWidth-gExtrusionDepth/2,gToeDepth+gBaseDepth-gExtrusionDepth/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thick+2,$fn=gResolution);
		translate([gWingWidth+gBaseWidth-gExtrusionDepth/2-gExtrusionDepth*2,gToeDepth+gBaseDepth-gExtrusionDepth/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thick+2,$fn=gResolution);

		// Make a rounding corner at P2
		translate([FRRadius,gToeDepth+gBaseDepth-FRRadius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thick+4,$fn=gResolution);
			}
		// Make a rounding corner at P3
		translate([gWingWidth+gBaseWidth-FRRadius,gToeDepth+gBaseDepth-FRRadius,0])
		rotate([0,0,0])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thick+4,$fn=gResolution);
			}
		}
	}

// Create the toe bracket.
module ToeBracket(Thick)
	{
	difference()
		{
		translate([gWingWidth+gBaseWidth/2-gToeBracketDepth/2,0,0])
		cube([gToeBracketDepth,Thick,gToeBracketWidth+Thick],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([gWingWidth+gBaseWidth/2,-Thick-gToeBracketWidth/2,-1])
		cylinder(r=gFootFastenerDia/2,h=Thick+4,$fn=gResolution);
		}
	}

// Create the idler pulley bracket.
module PulleyBracket(Thick)
	{
	rotate([90,0,0])
	translate([0,0,-gToeDepth])
	difference()
		{
		union()
			{
			cube([gIdlerBracketWidth,gIdlerBracketDepth,Thick],center = false);	
			translate([gIdlerBracketWidth/2,gIdlerBracketDepth,0])
			cylinder(r=gIdlerBracketWidth/2,h=Thick,$fn=gResolution);
			}
		// Drill a hole for the idler pulley.
		translate([gIdlerBracketWidth/2,gIdlerBracketDepth,-1])
		cylinder(r=gIdlerFastenerDia/2,h=Thick+4,$fn=gResolution);
		}
	}

union()
	{
	// Create the body.
	color("green") Body([gP1,gP2,gP3,gP4,gP5,gP6,gP7],gThick,gFRRadius);

	// Weld on the toe bracket.
	color("blue") ToeBracket(gThick);

	// Weld on the idler pulley bracket.
	color("red") PulleyBracket(gThick);
	}

