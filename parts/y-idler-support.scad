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
Radius = 2;

// Place the vertices clockwise, starting from the lower left vertex.

difference()
{
	linear_extrude(height = Thick)
	polygon(points=[
	[0,ToeLength], // 
	[0,ToeLength+BaseLength], //
	[WingWidth+BaseWidth,ToeLength+BaseLength], //
	[WingWidth+BaseWidth,ToeLength], //
	[WingWidth+BaseWidth-ToeIn,0], //
	[WingWidth+ToeIn,0], //
	[WingWidth,ToeLength]]); //

	// Make a rounding corner.
	translate([Radius,ToeLength+BaseLength-Radius,0])
	rotate([0,0,90])
	difference()
		{
		translate([0,0,-1])
		cube([Radius+1,Radius+1,Thick+2]);
		translate([0,0,-2])
		cylinder(r=Radius,h=Thick+4,$fn=Resolution);
		}

}


