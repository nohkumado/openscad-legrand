use <../../nohscadlib/fillet.scad>

cover = [
  [76.70,75,8.3],//innen 
  [83.20,80,9.5], //aussen
  [60.40,50.6,5], //ausparung oben
  [45.24,45.75,10], //ausparung innen
];

tp =3;
tdeck =6.8;

plat = [65.67,56.7, cover[1][2]-tp];
durch = [ 3.6,3];
lochq =[51.64,16.09];
 einschn =[50.00,35.40];
schn = [ 2,6.20];
// color("red")

loecher =[lochq[0]-durch[0],lochq[1]-durch[0]];

//plexo_platine();
plexo_cover();

module plexo_cover()
{
  difference()
  {
    translate([0,0,cover[1][2]/2]) rounded_cube(d=20, siz = cover[1]);
    union()
    {
      translate([0,0,cover[0][2]/2-.1]) rounded_cube(d=16, siz = cover[0]);
      translate([0,0,cover[2][2]/2+(cover[1][2]-cover[2][2])+.1]) rounded_cube(d=8, siz = cover[2]);
    }
  }
   difference()
   {
      translate([0,0,cover[1][2]/2+tp/2]) 
	rounded_cube(d=8, siz = [cover[2][0]+3,cover[2][1]+3,cover[1][2]-tp] );
      translate([0,0,cover[1][2]/2+tp/2+.1]) 
	rounded_cube(d=8, siz = [cover[2][0],cover[2][1],cover[1][2]] );
   }
      translate([0,0,tp]) 
plexo_platine();
}
module bohrung(obenrechts = [10,10], center = false )
{
  x = (center)?obenrechts[0]/2:obenrechts[0]; 
  y = (center)?obenrechts[1]/2:obenrechts[1]; 
 for(n=[0:3]) 
   translate([((n%3 == 0)? -1:1)*x,((n >1)? 1:-1)*y,0])  children();
}
module plexo_platine()
{
  difference()
  {
    union()
    {
      bohrung(obenrechts = loecher, center = true  )
      {
	translate([durch[1]-durch[0],0,0]) 
	  cylinder(d=durch[0]+5, h=tp,$fn=20, center = false);
	cylinder(d=durch[0]+5, h=tp,$fn=20, center = false);
      }
      difference()
      {
	union()
	{
	  color("red")
	    translate([0,0,tp/2]) rounded_cube(d=8, siz = [plat[0],plat[1],tp]);
	}
	union()
	{
	  color("blue")
	    translate([0,0,cover[3][2]/2+-.1]) rounded_cube(d=8, siz = cover[3]);
	}
      }
    }
    union()
    {
      bohrung(obenrechts = loecher, center = true  )
      {
	translate([0,0,-1]) 
	{
	  translate([(durch[1]-durch[0])/2,0,0]) 
	    cylinder(d=durch[0], h=tp+2,$fn=20, center = false);
	  translate([(durch[0]-durch[1])/2,0,0]) 
	    cylinder(d=durch[0], h=tp+2,$fn=20, center = false);
	}
      }
      cube([40.30,1.5*loecher[1],30], center = true);
      bohrung(obenrechts = einschn, center = true  )
      {
	translate([0,0,0]) 
	{
	  cube([schn[1],1.5*schn[0],3*tp],center = true);
	}
      }
    }
  }
}
