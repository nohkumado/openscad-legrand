use <../../nohscadlib/fillet.scad>
use <../../mechanical/hinge.scad>

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
 einschn =[50.00,33.40];
schn = [ 2,6.20];
// color("red")

loecher =[lochq[0]-durch[0],lochq[1]-durch[0]];

//plexo_platine(h=.4);
//plexo_cover();
//plexo_insert();
hebel_insert();

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
  translate([0,0,tp]) plexo_platine(h=tp);
}
module bohrung(obenrechts = [10,10], center = false )
{
  x = (center)?obenrechts[0]/2:obenrechts[0]; 
  y = (center)?obenrechts[1]/2:obenrechts[1]; 
 for(n=[0:3]) 
   translate([((n%3 == 0)? -1:1)*x,((n >1)? 1:-1)*y,0])  children();
}
module plexo_platine(h=tp)
{
  difference()
  {
    union()
    {
      bohrung(obenrechts = loecher, center = true  )
      {
	translate([durch[1]-durch[0],0,0]) 
	  cylinder(d=durch[0]+5, h=h,$fn=20, center = false);
	cylinder(d=durch[0]+5, h=h,$fn=20, center = false);
      }
      difference()
      {
	    translate([0,0,h/2]) rounded_cube(d=8, siz = [plat[0],plat[1],h]);
	    translate([0,0,cover[3][2]/2+-.1]) rounded_cube(d=8, siz = cover[3]);
      }
    }
    union()
    {
      bohrung(obenrechts = loecher, center = true  )
      {
	translate([0,0,-1]) 
	{
	  translate([(durch[1]-durch[0])/2,0,0]) 
	    cylinder(d=durch[0], h=h+2,$fn=20, center = false);
	  translate([(durch[0]-durch[1])/2,0,0]) 
	    cylinder(d=durch[0], h=h+2,$fn=20, center = false);
	}
      }
      cube([40.30,1.5*loecher[1],30], center = true);
      bohrung(obenrechts = einschn, center = true  )
      {
	translate([0,0,0]) 
	{
	  cube([schn[1],1.5*schn[0],3*h],center = true);
	}
      }
    }
  }
}


module plexo_insert(tol = .4,h=tp, name="BOETTCHER", name_off = [28,10], name_size=3)
{
  //plexo_cylinder shape
  //h^2=p*q//Euklid Sehnen/Höhensatz
  q=(35.5/2)^2/2;
  pr = 2+q;

  difference()
  {
    union()
    {
      intersection()
      {
	rounded_cube(d=8, siz = [cover[2][0]-tol,cover[2][1]-tol,cover[1][2]] );
	plexo_platine(h=tp);
      }
      translate([0,0,tp+1.5]) 
      {
	difference()
	{
	  rounded_cube(d=8, siz = [cover[2][0]-tol,cover[2][1]-tol,3] );
	  union()
	  {
	    translate([-5,8,0]) cube([13,35,20], center = true);//cut out tampon
	    translate([0,0,-tp]) 
	      bohrung(obenrechts = loecher, center = true  )
	      {
		translate([durch[1]-durch[0],0,0]) 
		  cylinder(d=durch[0]+2, h=2*h,$fn=20, center = false);
		cylinder(d=durch[0]+2, h=2*h,$fn=20, center = false);
	      }
	  }
	}
      }
    }

    intersection()
    {
      color("red")
	translate([0,0,-q+pr/2+tp-.1])
	rotate([0,90,0])
	cylinder(d=pr,h=42,center = true, $fa=.1);
      color("blue")
	translate([0,0,-15+tp+h])
	cube([50,42,30], center = true);
    }
  }
}
module hebel_insert(tol = .4,h=tp, name="BOETTCHER", name_off = [28,10], name_size=3)
{

  plexo_insert(tol = tol,h=h);

    //hinge base
    translate([-15,-25,tp+3]) 
    cube([30,8.8,2]);

  translate([0,-(cover[2][1])/2+11.6,3*h+5])
    rotate([90,0,-90])
    translate([0,0,-15])
    union()
    {
      hinge(outd=10,axe= 5,h=30,parts=3, tol =0.4,print="left", 
	  plate = "bottom", opento = 0, label = "", fld=2, flb = 40, maxalpha = 60, minalpha =0 ,cutoutd = 2 ); 
      hinge(outd=10,axe= 5,h=30,parts=3, tol =0.4,print="right", 
	  plate = "bottom", opento = -0, label = "", fld=2, flb = 10, maxalpha = 60, minalpha =0 ,cutoutd = 2 ); 
    }


    //tampon 
    translate([-9,13,0]) 
    {
      difference()
      {
	cube([8,8.8,10]);
	color("red")
	  translate([4,9.6,0]) rotate([0,-90,180])fillet(r=2, h=10, center = true, offs=1);
      }
    }
    translate([-15,12.5,tp+6]) 
    {
      difference()
      {
  color("green")
    cube([30,15,2]);
  color("red")
    translate([name_off[0],name_off[1],-1])
    rotate([0,0,180])
    linear_extrude(height=4)
    text(name, size=name_size);
      }
    }
}
