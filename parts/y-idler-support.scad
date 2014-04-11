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
ToDo - Fix parametrics so this design works for Misumi 2040 as well.
*/

// Include a 3d carpenter square (ruler) library for debug.
use <ruler.scad>

gMisumiProfile = [20,60];
// gFRRadius = 1;
gBaseFastenerDia = 5;
gFootFastenerDia = 5;
gToeBracketDepth = 30;
gToeBracketWidth = 16;
gIdlerBracketDepth = 21;
gIdlerBracketWidth = 21;
gIdlerFastenerDia = 2.5;

// Calculate the body corner vertices.
function vertices(MisumiProfile,WingWidth,ToeWidth,ToeDepth) =
	[
	[0,ToeDepth],
	[0,ToeDepth+MisumiProfile[0]],
	[WingWidth+MisumiProfile[1],ToeDepth+MisumiProfile[0]],
	[WingWidth+MisumiProfile[1],ToeDepth],
	[WingWidth+MisumiProfile[1]-(MisumiProfile[1]-ToeWidth)/2,0],
	[WingWidth+(MisumiProfile[1]-ToeWidth)/2,0],
	[WingWidth,ToeDepth]
	];

// Draw a ruler.
% translate([0,0,0])
rotate([0,0,0])
xyzruler(30);

// Create the body by extruding a 2d polygon,
// given the vertices and thickness.
// Place the vertices clockwise, starting from the lower left vertex.
module Body(CornerPoints, Thickness, FRRadius, WingWidth,ToeDepth,Resolution)
	{
	difference()
		{
		// Make the body by extruding a 2d polygon.
		linear_extrude(height = Thickness)
		polygon(points = CornerPoints);

		// Drill holes for the mounting fasteners.
		translate([WingWidth+gMisumiProfile[1]-gMisumiProfile[0]/2,ToeDepth+gMisumiProfile[0]-gMisumiProfile[0]/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thickness+2,$fn=Resolution);
		translate([WingWidth+gMisumiProfile[1]-gMisumiProfile[0]/2-gMisumiProfile[0]*2,ToeDepth+gMisumiProfile[0]-gMisumiProfile[0]/2,-1])
		cylinder(r=gBaseFastenerDia/2,h=Thickness+2,$fn=Resolution);

		// Make a rounding corner at P2
		translate([FRRadius,ToeDepth+gMisumiProfile[0]-FRRadius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=Resolution);
			}
		// Make a rounding corner at P3
		translate([WingWidth+gMisumiProfile[1]-FRRadius,ToeDepth+gMisumiProfile[0]-FRRadius,0])
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
module ToeBracket(Thickness, WingWidth, ToeDepth,Resolution)
	{
	difference()
		{
		translate([WingWidth+gMisumiProfile[1]/2-gToeBracketDepth/2,0,0])
		cube([gToeBracketDepth,Thickness,gToeBracketWidth+Thickness],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([WingWidth+gMisumiProfile[1]/2,-Thickness-gToeBracketWidth/2,-1])
		cylinder(r=gFootFastenerDia/2,h=Thickness+4,$fn=Resolution);
		}
	}

// Create the idler pulley bracket.
module PulleyBracket(Thickness,ToeDepth,Resolution)
	{
	rotate([90,0,0])
	translate([0,0,-ToeDepth])
	difference()
		{
		union()
			{
			cube([gIdlerBracketWidth,gIdlerBracketDepth,Thickness],center = false);	
			translate([gIdlerBracketWidth/2,gIdlerBracketDepth,0])
			cylinder(r=gIdlerBracketWidth/2,h=Thickness,$fn=Resolution);
			}
		// Drill a hole for the idler pulley.
		translate([gIdlerBracketWidth/2,gIdlerBracketDepth,-1])
		cylinder(r=gIdlerFastenerDia/2,h=Thickness+4,$fn=Resolution);
		}
	}

// Create the idler pulley assembly with integrated foot.
module assembly()
	{
	union()
		{
		// Create the body.
		color("green") Body(CornerPoints=vertices(MisumiProfile=[20,60],WingWidth=35,ToeWidth=50,ToeDepth=22),Thickness=10,FRRadius=1, WingWidth = 35,ToeDepth = 22,Resolution = 50);

		// Weld on the toe bracket.
		color("blue") ToeBracket(Thickness=10,WingWidth = 35,Resolution = 50);

		// Weld on the idler pulley bracket.
		color("red") PulleyBracket(Thickness=10,ToeDepth = 22,Resolution = 50);
		}
	}

// Create the assembly.
assembly();

