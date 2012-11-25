/*
Y-Axis Idler Support With Integrated Foot

The primary function is to support the x-axis idler pulley.
The secondary function is to provide the third foot of the
Chaucer 3d vertical printer. This part is fastened to the
end of the Misumi y-axis extrusion with two self-threading
screws.

As per OpenScad default, dimensions are in mm and degrees.
*/

// Create a ruler for debug.
use <ruler.scad>
% translate([0,0,0])
rotate([0,0,0])
xyzruler(30);

Thick = 10;
BaseWidth = 60;
BaseLength = 20;
ToeWidth = 50;
ToeIn = (BaseWidth-ToeWidth)/2;
ToeLength = 22;
WingWidth = 37;

Resolution = 50;
Radius = 1;
FastenerDia = 5;

ToeBracketLength = 30;
ToeBracketWidth = 16;
ToeBracketThick = 8;

IdlerBracketLength = 24;
IdlerBracketWidth = 24;
IdlerBracketThick = 10;
IdlerFastenerDia = 3;

// Place the vertices clockwise, starting from the lower left vertex.

union()
	{
	difference()
		{
		linear_extrude(height = Thick)
		polygon(points=[
		[0,ToeLength], // P1
		[0,ToeLength+BaseLength], // P2
		[WingWidth+BaseWidth,ToeLength+BaseLength], // P3
		[WingWidth+BaseWidth,ToeLength], // P4
		[WingWidth+BaseWidth-ToeIn,0], // P5
		[WingWidth+ToeIn,0], // P6
		[WingWidth,ToeLength]]); // P7
	
		// Make a rounding corner at P1
		/*
		translate([Radius,Radius+ToeLength,0])
		rotate([0,0,180])
		difference()
			{
			translate([0,0,-1])
			cube([Radius+1,Radius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=Radius,h=Thick+4,$fn=Resolution);
			}
		*/

		// Make a rounding corner at P2
		translate([Radius,ToeLength+BaseLength-Radius,0])
		rotate([0,0,90])
		difference()
			{
			translate([0,0,-1])
			cube([Radius+1,Radius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=Radius,h=Thick+4,$fn=Resolution);
			}
	
		// Make a rounding corner at P3
		translate([WingWidth+BaseWidth-Radius,ToeLength+BaseLength-Radius,0])
		rotate([0,0,0])
		difference()
			{
			translate([0,0,-1])
			cube([Radius+1,Radius+1,Thick+2]);
			translate([0,0,-2])
			cylinder(r=Radius,h=Thick+4,$fn=Resolution);
			}
	
		// Drill holes for the mounting fasteners.
		translate([WingWidth+BaseWidth-10,ToeLength+BaseLength-10,-1])
		cylinder(r=FastenerDia/2,h=Thick+4,$fn=Resolution);
		translate([WingWidth+BaseWidth-10-40,ToeLength+BaseLength-10,-1])
		cylinder(r=FastenerDia/2,h=Thick+4,$fn=Resolution);
		}

	// Weld on the toe bracket.
	difference()
		{
		translate([WingWidth+BaseWidth/2-ToeBracketLength/2,0,0])
		cube([ToeBracketLength,ToeBracketThick,ToeBracketWidth+Thick],center = false);
		// Drill a hole for the toe fastener.
		rotate([-90,0,0])
		translate([WingWidth+BaseWidth/2,-Thick-ToeBracketWidth/2,-1])
		cylinder(r=FastenerDia/2,h=Thick+4,$fn=Resolution);
		}

	// Weld on the idler pully bracket.
	rotate([90,0,0])
	translate([0,0,-ToeLength])
	difference()
		{
		union()
			{
			cube([IdlerBracketWidth,IdlerBracketLength,IdlerBracketThick],center = false);	
			translate([IdlerBracketWidth/2,IdlerBracketLength,0])
			cylinder(r=IdlerBracketWidth/2,h=IdlerBracketThick,$fn=Resolution);
			}
		translate([IdlerBracketWidth/2,IdlerBracketLength,-1])
		cylinder(r=IdlerFastenerDia/2,h=Thick+4,$fn=Resolution);
		}
	
	// Weld a block to connect the idler pully bracket to base and toe.
	translate([0,ToeLength-IdlerBracketThick,0])
	cube([WingWidth+ToeIn,Thick+1,Thick]);
	}

