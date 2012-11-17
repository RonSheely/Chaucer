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
// Keep in mind the foot is printed on its back.

// Base Dimensions
BaseWidth = 45;
FootWidth = 25;
Length = 55;
Depth = 20;
Thick = 4;

// Radii
BaseCornerRadius = 0.1;
FootCornerRadius = 1.0;
InsideCornerRadius = 2;

// Render Resolution
CornerResolution = 50;

// Alignment Key Dimensions
KeyDepth = 2;
KeyWidth = 6;
KeyLength = Depth;
KeyCutout = KeyWidth+2;

// Fastener Dimensions
FastenerDia = 5;

// Toe Dimensions
// revisit - I am not printing the toe until I can find a way to
// prevent it from warping during printing.
ToeLength = 5;
ToeFlat = 1;
ToeInsideDia = 8;
ToeOutsideDia = 18;


// Adjusted x-Axis Thickness
/*
Given the way we define our trapezoids using cylindars enclosed by a hull,
we cannot simply scale the inner box to fit nicely inside the outer box
with uniform wall thickness. We must calculate the vertices of the inner
trapezoid. The vertical (y) components of the verticies are obvious. They
are simply the given thickness (Thick) along the y or Length axis. The
horizontal (x) components are given by the trigonmetric relationships below.
*/
xBaseThick = Thick/tan(atan(Length/(BaseWidth/2-FootWidth/2))/2);
echo("xBaseThick: ",xBaseThick);
xFootThick = Thick + Thick*tan(90 + atan(Length/(BaseWidth/2-FootWidth/2)));
echo("xFootThick: ",xFootThick);


/*
<---------BaseWidth--------->
_____________________________ 
\   _____________________   /  ^
 \  \                   /  /   |
->\  \<-xBaseThick     /  /    |
 ->\  \               /  /   Length
  ->\  \<-xFootThick /  /      |
     \  \___________/  /       |
      \_______________/        V
       <--FootWidth-->
*/

// Create a ruler for debug.
use <ruler.scad>
translate([0,-Length/2,Depth])
// translate([0,-22,Depth])
// rotate(-atan(Length/(BaseWidth/2-FootWidth/2)),0,0)
%xyzruler(Length+ToeLength);

// Create a rounded trapezoid extrusion. This is used to build a trapezoid box
// with wall thickness of zero.
// 1. Place the four corners in two dimensions using circles.
// 2. Create a rounded hull around the corners.
// 3. Extrude the rounded trapezoid to three dimensions.

module RoundTrapExtrude(p1,p2,p3,p4,depth,res)
	{
	// Lower Left, p1
	x1 = p1[0];
	y1 = p1[1];
	r1 = p1[2];

	// Upper Left, p2
	x2 = p2[0];
	y2 = p2[1];
	r2 = p2[2];

	// Upper Right, p3
	x3 = p3[0];
	y3 = p3[1];
	r3 = p3[2];

	// Lower Right, p4
	x4 = p4[0];
	y4 = p4[1];
	r4 = p4[2];

	linear_extrude(height=depth)
	hull()
		{
		// Place 4 circles at the corners, with the given radius

		// Lower Left, p1
		translate([x1+r1, y1+r1, 0])
		circle(r=r1, $fn=res);

		// Upper Left, p2
		translate([x2+r2, y2-r2, 0])
		circle(r=r2, $fn=res);

		// Upper Right, p3
		translate([x3-r3, y3-r3, 0])
		circle(r=r3, $fn=res);

		// Lower Right, p4
		translate([x4-r4, y4+r4, 0])
		circle(r=r4, $fn=res);
		}
	}

// Construct an inverted box truss foot.

difference()
	{
	union()
		{
		difference()
			{
			// Construct the outer trapezoid.
			color("green")
			RoundTrapExtrude(
				[-BaseWidth/2,-Length/2,BaseCornerRadius], // LL
				[-FootWidth/2, Length/2,FootCornerRadius], // UL
				[ FootWidth/2, Length/2,FootCornerRadius], // UR
				[ BaseWidth/2,-Length/2,BaseCornerRadius], // LR
				Depth,CornerResolution);
		
			// Mill out the inner trapezoid.
			color("blue")
			translate([0,0,Thick])
			RoundTrapExtrude(
				[-BaseWidth/2+xBaseThick,-Length/2+Thick,InsideCornerRadius], // LL
				[-FootWidth/2+xFootThick, Length/2-Thick,InsideCornerRadius], // UL
				[ FootWidth/2-xFootThick, Length/2-Thick,InsideCornerRadius], // UR
				[ BaseWidth/2-xBaseThick,-Length/2+Thick,InsideCornerRadius], // LR
				Depth,CornerResolution);
			}
	
		// Create the rail alignment key, and weld it to the base.
		// Ramp the edge of the key so that it can be printed.
		translate([-BaseWidth/2,-(Length)/2-KeyDepth,Depth/2-KeyWidth/2])
		rotate([90,0,90])
		// Mill out a space to clear the fastener.
		difference()
			{
			linear_extrude(height = BaseWidth)
			polygon(points=[[0,KeyDepth],[KeyDepth,0],[KeyDepth,KeyWidth],[0,KeyWidth]]);
			color("red")
			translate([-KeyCutout/2,(KeyWidth-KeyCutout)/2,(BaseWidth-KeyCutout)/2])
			cube([KeyCutout,KeyCutout,KeyCutout]);
			}
		}

	// Mill holes for the fasteners.
	rotate([90,0,0])
	translate([0,Depth/2,-(Length+Thick)/2])
	cylinder(h=Length+KeyDepth+5,r=FastenerDia/2,$fn=100);


	// Create the toe, and weld it to the foot.
	// revisit - The toe warps during printing, so I'm commenting it out until
	// I can develop suitible scafolding.
	/*
	translate([0,Length/2,Depth/2])
	rotate([-90,0,0])
	rotate_extrude($fn=100)
	polygon(points=[
	[ToeInsideDia/2,0],
	[ToeInsideDia/2,ToeLength],
	[ToeInsideDia/2+ToeFlat,ToeLength],
	[ToeOutsideDia/2,0]]);
	*/
	}

