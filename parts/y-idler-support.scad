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
ToDo - Add fillets and rounds to the toe bracket.
ToDo - Fix parametrics so this design works for Misumi 2040 as well.
Revisit - Consider a more readabile dimension scheme.
*/

// Include a 3d carpenter square (ruler) library for debug.
use <ruler.scad>;
use <round-bracket.scad>;
use <square-bracket.scad>;

// Draw a ruler.
% xyzruler(32);

// Create the body by extruding a 2d polygon,
// given the vertices and thickness.
// Place the vertices clockwise, starting from the lower left vertex.
module Body(
	MisumiProfile,
	Thickness,
	FRRadius,
	WingWidth,
	ToeWidth,
	ToeDepth,
	Resolution,
	FastenerDia)
	{
	color("green") difference()
		{
		// Make the body by extruding a 2d polygon.
		linear_extrude(height = Thickness)
		polygon(points =[
			[0,ToeDepth],
			[0,ToeDepth+MisumiProfile[0]],
			[WingWidth+MisumiProfile[1],ToeDepth+MisumiProfile[0]],
			[WingWidth+MisumiProfile[1],ToeDepth],
			[WingWidth+MisumiProfile[1]-(MisumiProfile[1]-ToeWidth)/2,0],
			[WingWidth+(MisumiProfile[1]-ToeWidth)/2,0],
			[WingWidth,ToeDepth]]);

		// Drill holes for the mounting fasteners.
		translate([WingWidth+MisumiProfile[1]-MisumiProfile[0]/2,ToeDepth+MisumiProfile[0]-MisumiProfile[0]/2,-1])
		cylinder(r=FastenerDia/2,h=Thickness+2,$fn=Resolution);
		translate([WingWidth+MisumiProfile[1]-MisumiProfile[0]/2-MisumiProfile[0]*2,ToeDepth+MisumiProfile[0]-MisumiProfile[0]/2,-1])
		cylinder(r=FastenerDia/2,h=Thickness+2,$fn=Resolution);

		// Make a rounding corner at P2
		translate([FRRadius,ToeDepth+MisumiProfile[0]-FRRadius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([FRRadius+1,FRRadius+1,Thickness+2]);
			translate([0,0,-2])
			cylinder(r=FRRadius,h=Thickness+4,$fn=Resolution);
			}
		// Make a rounding corner at P3
		translate([WingWidth+MisumiProfile[1]-FRRadius,ToeDepth+MisumiProfile[0]-FRRadius,0])
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
module ToeBracket(
	MisumiProfile,
	Thickness,
	WingWidth,
	ToeDepth,
	Resolution,
	FastenerDia,
	BracketWidth,
	BracketDepth)
	{
	color("blue")
	rotate([-90,0,0])
	translate([
		WingWidth+MisumiProfile[1]/2-BracketDepth/2,
		-Thickness-BracketWidth,
		0])
	SquareBracket(
		BracketDepth,
		BracketWidth,
		Thickness,
		[[BracketDepth/2,BracketWidth/2,FastenerDia,Thickness]]);
	/* color("blue") difference()
		{
		translate([WingWidth+MisumiProfile[1]/2-BracketDepth/2,0,0])
		cube([BracketDepth,Thickness,BracketWidth+Thickness],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([WingWidth+MisumiProfile[1]/2,-Thickness-BracketWidth/2,-1])
		cylinder(r=FastenerDia/2,h=Thickness+4,$fn=Resolution);
		} */
	}

// Create the idler pulley bracket.
module PulleyBracket(
	Thickness,
	ToeDepth,
	Resolution,
	FastenerDia,
	BracketWidth,
	BracketDepth)
	{
	rotate([90,0,0])
	translate([0,0,-ToeDepth])
	color("red") RoundBracket(
		BracketWidth,
		BracketDepth+BracketWidth/2,
		Thickness,
		[[BracketWidth/2,BracketDepth,FastenerDia,Thickness]]);
	/* difference()
		{
		union()
			{
			cube([BracketWidth,BracketDepth,Thickness],center = false);	
			translate([BracketWidth/2,BracketDepth,0])
			cylinder(r=BracketWidth/2,h=Thickness,$fn=Resolution);
			}
		// Drill a hole for the idler pulley.
		translate([BracketWidth/2,BracketDepth,-1])
		cylinder(r=FastenerDia/2,h=Thickness+4,$fn=Resolution);
		} */
	}

// Create the idler pulley assembly with integrated foot.
module assembly()
	{
	union()
		{
		// Create the body.
		Body(
			MisumiProfile=[20,60],
			Thickness=10,
			FRRadius=1,
			WingWidth = 35,
			ToeWidth = 50,
			ToeDepth = 22,
			Resolution = 50,
			FastenerDia = 5);

		// Weld on the toe bracket.
		ToeBracket(
			MisumiProfile=[20,60],
			Thickness=10,
			WingWidth = 35,
			Resolution = 50,
			FastenerDia=5,
			BracketWidth = 16,
			BracketDepth = 30);

		// Weld on the idler pulley bracket.
		PulleyBracket(
			Thickness=10,
			ToeDepth = 22,
			Resolution = 50,
			FastenerDia = 2.5,
			BracketWidth = 21,
			BracketDepth=21);
		}
	}

// Create the assembly.
assembly();

