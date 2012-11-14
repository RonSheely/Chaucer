/*
Trapezoid Foot

This is trapezoid box inverted truss used as the rear feet for the Chaucer
3D Vertical Printer. This design was inspired by the similar parts from
Dave Kennell's Pocker Printer Design on Thingiverse. The foot is essentially
comprised of rounded concentric trapezoid boxes.

Todo: Refactor this mess to make it more generic and usable.
Todo: Find a thickness solution that does not use Tan or ATan. Tan and ATan
tend to misbehave.

*/

// Here are the parameters in mm.

// Basic Dimensions
TopWidth = 55;
BotWidth = 25;
Length = 55;
Depth = 20;
Thick = 4;

// Radii
TopCornerRadius = 0.1;
BotCornerRadius = 1;
InsideCornerRadius = 1;

// Render Resolution
CornerResolution = 50;

// Alignment Key Dimensions
KeyDepth = 2.5;
KeyWidth = 6;
KeyLength = Depth;
KeyCutout = KeyWidth+2;

// Fastener Dimensions
FastenerDia = 5.5;

// Adjusted x-Axis Thickness
/*
Given the way we define our trapezoids using cylindars enclosed by a hull,
we cannot simply scale the inner box to fit nicely inside the outer box,
with uniform wall thickness. We must calculate the vertices of the inner
trapezoid. The vertical (y) components of the verticies are obvious. They
are simply the given Thick along the y or Length axis. The horizontal (x)
components are given by the trigonmetric relationship below.
*/
xThick = Thick/tan(atan(Length/(TopWidth/2-BotWidth/2))/2);
echo("xThick: ",xThick); // For debug. Should be slighly more than Thick.

/*
<---------TopWidth--------->
____________________________ 
\   ____________________   /  ^
 \  \                  /  /   |
  \  \                /  /    |
 ->\  \<-xThick      /  /   Length
    \  \            /  /      |
     \  \__________/  /       |
      \______________/        V
       <--BotWidth-->
*/

// Create a ruler for debug.
use <ruler.scad>
translate([0,-Length/2,Depth]) %xyzruler(Length+Thick);

// Create a rounded trapezoid extrusion. This is used to build a trapezoid box
// with wall thickness of zero.
// 1. Place the four corners in two dimensions using circles.
// 2. Create a rounded hull around the corners.
// 3. Extrude the rounded trapezoid to three dimensions.

module roundedTrapExtrusion(size, r1, r2, resolution)
	{
	x1 = size[0];
	x2 = size[1];
	y = size[2];
	z = size[3];

	linear_extrude(height=z)
	hull()
		{
		// Place 4 circles at the corners, with the given radius

		translate([(-x1/2)+(r1), (-y/2)+(r1), 0])
		circle(r=r1, $fn=resolution);

		translate([(x1/2)-(r1), (-y/2)+(r1), 0])
		circle(r=r1, $fn=resolution);

		translate([(-x2/2)+(r2), (y/2)-(r2), 0])
		circle(r=r2, $fn=resolution);

		translate([(x2/2)-(r2), (y/2)-(r2), 0])
		circle(r=r2, $fn=resolution);
		}
	}

// Construct the foot.

difference()
	{
	union()
		{
	difference()
		{
		// Create and extrude the outer trapizod box.
		color("green")
		roundedTrapExtrusion([TopWidth,BotWidth,Length,Depth],
		TopCornerRadius,BotCornerRadius,CornerResolution);

		// Create and extrude the inner trapizoid box, and subtract it from the outer.
		color("blue")
		translate([0,0,Thick])
		roundedTrapExtrusion([TopWidth-(xThick * 2),BotWidth-(Thick * 2),
		Length-(Thick * 2),Depth],InsideCornerRadius,InsideCornerRadius,
		CornerResolution);
		}

	// Create and extrude the rail alignment key.
	// Ramp the edge of the key so that it can be printed.
	translate([-TopWidth/2,-(Length)/2-KeyDepth,Depth/2-KeyWidth/2])
	rotate([90,0,90])
	// Leave a cutout to clear the fastener.
	difference()
		{
		linear_extrude(height = TopWidth)
		polygon(points=[[0,KeyDepth],[KeyDepth,0],[KeyDepth,KeyWidth],[0,KeyWidth]]);
		color("red")
		translate([-KeyCutout/2,(KeyWidth-KeyCutout)/2,(TopWidth-KeyCutout)/2])
		cube([KeyCutout,KeyCutout,KeyCutout]);
		}
	}

	// Bore a hole for the fasteners.
	rotate([90,0,0])
	translate([0,Depth/2,-(Length+Thick)/2])
	cylinder(h=Length+KeyDepth+5,r=FastenerDia/2,$fn=100);
	} 

	// Add the toe.
	translate([0,Length/2,Depth/2])
	rotate([-90,0,0])
	rotate_extrude($fn=100)
	polygon(points=[[0,0],[1,0],[1,1],[3,1],[3,5],[5,5],[8,0]]);
