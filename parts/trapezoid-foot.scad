TopWidth = 40;
BotWidth = 25;
Length = 55;
Depth = 20;
WallThickness = 4;
AdjWallThickness = WallThickness/tan(atan(Length/(TopWidth/2-BotWidth/2))/2);
echo("AdjWallThickness: ",AdjWallThickness);
TopCornerRadius = 0.1;
BotCornerRadius = 1;
InsideCornerRadius = 1;
CornerResolution = 50;

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

difference()
	{
	color("green")
	roundedTrapExtrusion([TopWidth,BotWidth,Length,Depth],TopCornerRadius,BotCornerRadius,CornerResolution);

	color("blue")
	translate([0,0,WallThickness])
	roundedTrapExtrusion([TopWidth-(AdjWallThickness * 2),BotWidth-(WallThickness * 2),Length-(WallThickness * 2),Depth],InsideCornerRadius,InsideCornerRadius,CornerResolution);
	}

// Draw a simple template to debug measurments.
/*
TemplateLength = Length;
TemplateWidth = TopWidth;
color("red")
translate([-TemplateWidth/2,-TemplateLength/2,-2])
cube([TemplateWidth,TemplateLength,2]);
*/