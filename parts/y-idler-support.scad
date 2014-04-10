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
ToDo - Apply global verses local naming convention.
ToDo - Factor out all globals and refactor per functional programming paradigm.
ToDo - Add fillets and rounds to the toe bracket.
*/

// Include a 3d carpenter square (ruler) library for debug.
use <ruler.scad>

// ToDo - Fix parametrics so this design works for Misumi 2040 as well.
gMisumiProfile = [20,60];

gThick = 10;

gToeWidth = 50;
gToeDepth = 22;

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

// These points define corner vertices for the 2d face outline of the body.

// ToDo - Consider creating vertices with a function.

gP1 = [0,gToeDepth];
gP2 = [0,gToeDepth+gMisumiProfile[0]];
gP3 = [gWingWidth+gMisumiProfile[1],gToeDepth+gMisumiProfile[0]];
gP4 = [gWingWidth+gMisumiProfile[1],gToeDepth];
gP5 = [gWingWidth+gMisumiProfile[1]-(gMisumiProfile[1]-gToeWidth)/2,0];
gP6 = [gWingWidth+(gMisumiProfile[1]-gToeWidth)/2,0];
gP7 = [gWingWidth,gToeDepth];

echo("Vertices: ",[gP1,gP2,gP3,gP4,gP5,gP6,gP7]);

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
		translate([gWingWidth+gMisumiProfile[1]-gMisumiProfile[0]/2,gToeDepth+gMisumiProfile[0]-gMisumiProfile[0]/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thickness+2,$fn=gResolution);
		translate([gWingWidth+gMisumiProfile[1]-gMisumiProfile[0]/2-gMisumiProfile[0]*2,gToeDepth+gMisumiProfile[0]-gMisumiProfile[0]/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thickness+2,$fn=gResolution);

		// Make a rounding corner at P2
		translate([FRRadius,gToeDepth+gMisumiProfile[0]-FRRadius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=gResolution);
			}
		// Make a rounding corner at P3
		translate([gWingWidth+gMisumiProfile[1]-FRRadius,gToeDepth+gMisumiProfile[0]-FRRadius,0])
		rotate([0,0,0])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=gResolution);
			}
		}
	}

// Create the toe bracket.
module ToeBracket(Thickness)
	{
	difference()
		{
		translate([gWingWidth+gMisumiProfile[1]/2-gToeBracketDepth/2,0,0])
		cube([gToeBracketDepth,Thickness,gToeBracketWidth+Thickness],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([gWingWidth+gMisumiProfile[1]/2,-Thickness-gToeBracketWidth/2,-1])
		cylinder(r=gFootFastenerDia/2,h=Thickness+4,$fn=gResolution);
		}
	}

// Create the idler pulley bracket.
module PulleyBracket(Thickness)
	{
	rotate([90,0,0])
	translate([0,0,-gToeDepth])
	difference()
		{
		union()
			{
			cube([gIdlerBracketWidth,gIdlerBracketDepth,Thickness],center = false);	
			translate([gIdlerBracketWidth/2,gIdlerBracketDepth,0])
			cylinder(r=gIdlerBracketWidth/2,h=Thickness,$fn=gResolution);
			}
		// Drill a hole for the idler pulley.
		translate([gIdlerBracketWidth/2,gIdlerBracketDepth,-1])
		cylinder(r=gIdlerFastenerDia/2,h=Thickness+4,$fn=gResolution);
		}
	}

// Create the idler pulley assembly with integrated foot.
module assembly(CornerPoints,Thickness,FRRadius)
	{
	union()
		{
		// Create the body.
		color("green") Body(CornerPoints,Thickness,FRRadius);

		// Weld on the toe bracket.
		color("blue") ToeBracket(Thickness);

		// Weld on the idler pulley bracket.
		color("red") PulleyBracket(Thickness);
		}
	}

// Create the assembly.
assembly(CornerPoints=[gP1,gP2,gP3,gP4,gP5,gP6,gP7],Thickness=gThick,FRRadius=gFRRadius);
