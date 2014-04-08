/*
Y-Axis Idler Support With Integrated Foot

The primary function is to support the x-axis idler pulley.
The secondary function is to provide the third foot of the
Chaucer 3d vertical printer. This part is fastened to the
end of the Misumi 20mm x 60mm y-axis extrusion with two
self-threading screws.

All dimensions are mm and degrees unless otherwise specified.
*/

// Include a 3d carpenter square (ruler) library for debug.
use <ruler.scad>

ExtrusionWidth = 60;
ExtrusionDepth = 20;

Thick = 10;
IdlerBracketThick = Thick;
BaseWidth = ExtrusionWidth;
BaseDepth = ExtrusionDepth;
ToeWidth = 50;
ToeDepth = 22;
ToeIn = (BaseWidth-ToeWidth)/2;
LittleToeIn = IdlerBracketThick * ToeIn / ToeDepth;
WingWidth = 35;

Resolution = 50;
Radius = 1;
BaseFastenerDia = 5;
FootFastenerDia = 5;

ToeBracketDepth = 30;
ToeBracketWidth = 16;
ToeBracketThick = 8;

IdlerBracketDepth = 21;
IdlerBracketWidth = 21;
IdlerFastenerDia = 2.5;

// These points define corners for the 2d face outline of the body.

P1 = [0,ToeDepth-IdlerBracketThick];
P2 = [0,ToeDepth+BaseDepth];
P3 = [WingWidth+BaseWidth,ToeDepth+BaseDepth];
P4 = [WingWidth+BaseWidth,ToeDepth];
P5 = [WingWidth+BaseWidth-ToeIn,0];
P6 = [WingWidth+ToeIn,0];
P7 = [WingWidth+LittleToeIn,ToeDepth-IdlerBracketThick];

// Draw a ruler.
% translate([0,0,0])
rotate([0,0,0])
xyzruler(30);

// Create the body by extruding a 2d polygon,
// given the vertices and thickness.
// Place the vertices clockwise, starting from the lower left vertex.
module body(CornerPoints, Thickness)
	{
	color("green") difference()
		{
		// Make the body by extruding a 2d polygon.
		linear_extrude(height = Thickness)
		polygon(points = CornerPoints);

		// Drill holes for the mounting fasteners.
		translate([WingWidth+BaseWidth-ExtrusionDepth/2,ToeDepth+BaseDepth-ExtrusionDepth/2,-1])
		cylinder(r=BaseFastenerDia/2,h=Thick+2,$fn=Resolution);
		translate([WingWidth+BaseWidth-ExtrusionDepth/2-ExtrusionDepth*2,ToeDepth+BaseDepth-ExtrusionDepth/2,-1])
		cylinder(r=BaseFastenerDia/2,h=Thick+2,$fn=Resolution);

		// Make a rounding corner at P2
		translate([Radius,ToeDepth+BaseDepth-Radius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([Radius+1,Radius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=Radius,h=Thick+4,$fn=Resolution);
			}
		// Make a rounding corner at P3
		translate([WingWidth+BaseWidth-Radius,ToeDepth+BaseDepth-Radius,0])
		rotate([0,0,0])
		difference()
			{
			translate([0,0,-1])
			cube([Radius+1,Radius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=Radius,h=Thick+4,$fn=Resolution);
			}
		}
	}

union()
	{
	// Create the body.
	body([P1,P2,P3,P4,P5,P6,P7],Thick);

	// Weld on the toe bracket.
	color("blue") difference()
		{
		translate([WingWidth+BaseWidth/2-ToeBracketDepth/2,0,0])
		cube([ToeBracketDepth,ToeBracketThick,ToeBracketWidth+Thick],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([WingWidth+BaseWidth/2,-Thick-ToeBracketWidth/2,-1])
		cylinder(r=FootFastenerDia/2,h=Thick+4,$fn=Resolution);
		}

	// Weld on the idler pulley bracket.
	rotate([90,0,0])
	translate([0,0,-ToeDepth])
	difference()
		{
		color("red") union()
			{
			cube([IdlerBracketWidth,IdlerBracketDepth,IdlerBracketThick],center = false);	
			translate([IdlerBracketWidth/2,IdlerBracketDepth,0])
			cylinder(r=IdlerBracketWidth/2,h=IdlerBracketThick,$fn=Resolution);
			}
		// Drill a hole for the idler pulley.
		translate([IdlerBracketWidth/2,IdlerBracketDepth,-1])
		cylinder(r=IdlerFastenerDia/2,h=Thick+4,$fn=Resolution);
		}
	}

