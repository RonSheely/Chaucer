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

// Total Length of Foot and Toe
TotalLength = 55;
echo("TotalLength: ",TotalLength);

// Toe Dimensions
ToeLength = 10;
ToeFlat = 1;
ToeInsideDia = 8;
ToeOutsideDia = 18;

// Foot Dimensions
BaseWidth = 45;
FootWidth = 25;
FootLength = TotalLength - ToeLength;
echo("FootLength: ",FootLength);
FootDepth = 20;
FootThick = 4;

// Radii
BaseCornerRadius = 0.1;
FootCornerRadius = 1.0;
InsideCornerRadius = 2;

// Render Resolution
CornerResolution = 50;

// Alignment Key Dimensions
KeyDepth = 2;
KeyWidth = 6;
KeyLength = FootDepth;
KeyCutout = KeyWidth+2;

// Fastener Dimensions
FastenerDia = 5;

// Adjusted x-Axis Thickness
/*
Given the way we define our trapezoids using cylindars enclosed by a hull,
we cannot simply scale the inner box to fit nicely inside the outer box
with uniform wall thickness. We must calculate the vertices of the inner
trapezoid. The vertical (y) components of the verticies are obvious. They
are simply the given thickness (FootThick) along the y or FootLength axis. The
horizontal (x) components are given by the trigonmetric relationships below.
*/
xBaseThick = FootThick/tan(atan(FootLength/(BaseWidth/2-FootWidth/2))/2);
echo("xBaseThick: ",xBaseThick);
xFootThick = FootThick + FootThick*tan(90 + atan(FootLength/(BaseWidth/2-FootWidth/2)));
echo("xFootThick: ",xFootThick);


/*
<---------BaseWidth--------->
_____________________________ 
\   _____________________   /  ^
 \  \                   /  /   |
->\  \<-xBaseThick     /  /    |
 ->\  \               /  /   FootLength
  ->\  \<-xFootThick /  /      |
     \  \___________/  /       |
      \_______________/        V
       <--FootWidth-->
*/

// Create a ruler for debug.
use <ruler.scad>
translate([0,-FootLength/2,FootDepth])
// translate([0,-22,FootDepth])
// rotate(-atan(FootLength/(BaseWidth/2-FootWidth/2)),0,0)
%xyzruler(FootLength+ToeLength);

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
			RoundTrapExtrude(
				[-BaseWidth/2,-FootLength/2,BaseCornerRadius], // LL
				[-FootWidth/2, FootLength/2,FootCornerRadius], // UL
				[ FootWidth/2, FootLength/2,FootCornerRadius], // UR
				[ BaseWidth/2,-FootLength/2,BaseCornerRadius], // LR
				FootDepth,CornerResolution);
		
			// Mill out the inner trapezoid.
			translate([0,0,FootThick])
			RoundTrapExtrude(
				[-BaseWidth/2+xBaseThick,-FootLength/2+FootThick,InsideCornerRadius], // LL
				[-FootWidth/2+xFootThick, FootLength/2-FootThick,InsideCornerRadius], // UL
				[ FootWidth/2-xFootThick, FootLength/2-FootThick,InsideCornerRadius], // UR
				[ BaseWidth/2-xBaseThick,-FootLength/2+FootThick,InsideCornerRadius], // LR
				FootDepth,CornerResolution);
			}
	
		// Create the rail alignment key, and weld it to the base.
		// Ramp the edge of the key so that it can be printed.
		translate([-BaseWidth/2,-(FootLength)/2-KeyDepth,FootDepth/2-KeyWidth/2])
		rotate([90,0,90])
		// Mill out a space to clear the fastener.
		difference()
			{
			linear_extrude(height = BaseWidth)
			polygon(points=[[0,KeyDepth],[KeyDepth,0],[KeyDepth,KeyWidth],[0,KeyWidth]]);
			translate([-KeyCutout/2,(KeyWidth-KeyCutout)/2,(BaseWidth-KeyCutout)/2])
			cube([KeyCutout,KeyCutout,KeyCutout]);
			}

		// Create the toe, and weld it to the foot.
		// revisit - The toe warps during printing, so I'm disabling it until
		// suitible scafolding and be developed. I'm using a factory rubber foot
		// with approximately the same dimensions for the interim.
		% translate([0,FootLength/2,FootDepth/2])
		rotate([-90,0,0])
		rotate_extrude($fn=100)
		polygon(points=[
		[ToeInsideDia/2,0],
		[ToeInsideDia/2,ToeLength],
		[ToeInsideDia/2+ToeFlat,ToeLength],
		[ToeOutsideDia/2,0]]);

		// Add scaffoldilng for the toe.
		// This has not been tested, so I'm disabling it.
		* union()
			{
			color("red")
			translate([4.5,FootLength/2+8,FootDepth/2])
			cube([0.5,16,FootDepth],center = true);
			color("green")
			translate([0,FootLength/2+8,FootDepth/2])
			cube([0.5,16,FootDepth],center = true);
			color("blue")
			translate([-4.5,FootLength/2+8,FootDepth/2])
			cube([0.5,16,FootDepth],center = true);
			}
		}

	// Mill a hole for the base fastener.
	rotate([90,0,0])
	translate([0,FootDepth/2,FootLength/2-2*FootThick])
	cylinder(h=3*FootThick,r=FastenerDia/2,$fn=100);

	// Mill a hole for the foot fastener.
	rotate([90,0,0])
	translate([0,FootDepth/2,-FootLength/2-FootThick/2])
	cylinder(h=2*FootThick,r=FastenerDia/2,$fn=100);
	}

