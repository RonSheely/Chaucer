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

Thick = 10;
BaseWidth = gExtrusionWidth;
BaseDepth = gExtrusionDepth;
ToeWidth = 50;
ToeDepth = 22;
ToeIn = (BaseWidth-ToeWidth)/2;
LittleToeIn = Thick * ToeIn / ToeDepth;
WingWidth = 35;

Resolution = 50;
FilletRoundRadius = 1;
BaseFastenerDia = 5;
FootFastenerDia = 5;

ToeBracketDepth = 30;
ToeBracketWidth = 16;

IdlerBracketDepth = 21;
IdlerBracketWidth = 21;
IdlerFastenerDia = 2.5;

// These points define corners for the 2d face outline of the body.

P1 = [0,ToeDepth-Thick];
P2 = [0,ToeDepth+BaseDepth];
P3 = [WingWidth+BaseWidth,ToeDepth+BaseDepth];
P4 = [WingWidth+BaseWidth,ToeDepth];
P5 = [WingWidth+BaseWidth-ToeIn,0];
P6 = [WingWidth+ToeIn,0];
P7 = [WingWidth+LittleToeIn,ToeDepth-Thick];

// Draw a ruler.
% translate([0,0,0])
rotate([0,0,0])
xyzruler(30);

// Create the body by extruding a 2d polygon,
// given the vertices and thickness.
// Place the vertices clockwise, starting from the lower left vertex.
module Body(CornerPoints, Thickness, FRRadius)
	{
	difference()
		{
		// Make the body by extruding a 2d polygon.
		linear_extrude(height = Thickness)
		polygon(points = CornerPoints);

		// Drill holes for the mounting fasteners.
		translate([WingWidth+BaseWidth-gExtrusionDepth/2,ToeDepth+BaseDepth-gExtrusionDepth/2,-1])
		cylinder(r=BaseFastenerDia/2,h=Thickness+2,$fn=Resolution);
		translate([WingWidth+BaseWidth-gExtrusionDepth/2-gExtrusionDepth*2,ToeDepth+BaseDepth-gExtrusionDepth/2,-1])
		cylinder(r=BaseFastenerDia/2,h=Thickness+2,$fn=Resolution);

		// Make a rounding corner at P2
		translate([FRRadius,ToeDepth+BaseDepth-FRRadius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=Resolution);
			}
		// Make a rounding corner at P3
		translate([WingWidth+BaseWidth-FRRadius,ToeDepth+BaseDepth-FRRadius,0])
		rotate([0,0,0])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=Resolution);
			}
		}
	}

// Create the toe bracket.
module ToeBracket(Thickness)
	{
	difference()
		{
		translate([WingWidth+BaseWidth/2-ToeBracketDepth/2,0,0])
		cube([ToeBracketDepth,Thickness,ToeBracketWidth+Thickness],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([WingWidth+BaseWidth/2,-Thickness-ToeBracketWidth/2,-1])
		cylinder(r=FootFastenerDia/2,h=Thickness+4,$fn=Resolution);
		}
	}

// Create the idler pulley bracket.
module PulleyBracket(Thickness)
	{
	rotate([90,0,0])
	translate([0,0,-ToeDepth])
	difference()
		{
		union()
			{
			cube([IdlerBracketWidth,IdlerBracketDepth,Thickness],center = false);	
			translate([IdlerBracketWidth/2,IdlerBracketDepth,0])
			cylinder(r=IdlerBracketWidth/2,h=Thickness,$fn=Resolution);
			}
		// Drill a hole for the idler pulley.
		translate([IdlerBracketWidth/2,IdlerBracketDepth,-1])
		cylinder(r=IdlerFastenerDia/2,h=Thickness+4,$fn=Resolution);
		}
	}

union()
	{
	// Create the body.
	color("green") Body([P1,P2,P3,P4,P5,P6,P7],Thick,FilletRoundRadius);

	// Weld on the toe bracket.
	color("blue") ToeBracket(Thick);

	// Weld on the idler pulley bracket.
	color("red") PulleyBracket(Thick);
	}

