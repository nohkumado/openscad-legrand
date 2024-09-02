use <../../nohscadlib/fillet.scad>

tp =3; //thickness of the base platine
tdeck =6.8;//thickness of the cover
htop = 3.5; //thickenss of the deco layer on top (min 3, otherwise the underlying structure shows through
gap = .4; //tolerance to leave between elements for better fitting

show = "insert"; //["platine", "cover", "insert", "switch_insert"]
                        //platine is just the hole mask to fix insert and switch
                        //cover is the border of the plexo box, where you insert the insert in the
                        //insert is just a plain insert, in case of an empty box for example 
                        //switch insert is the insert of a switch, means the insert minus the place for
                        //the switch itself
durch = [ 3.6,3];
lochq =[51.64,16.09];
einschn =[50.00,33.40];
schn = [ 2,6.20];
cover = cover();
plat = [65.67,56.7, cover[1][2]-tp];


loecher =[lochq[0]-durch[0],lochq[1]-durch[0]];

if(show == "platine") plexo_platine(h=.4);
else if(show == "cover")plexo_cover();
else  if(show == "insert")plexo_insert(tol = gap, h=tp,htop=htop);
else plexo_switch_insert(tol = gap, h=tp,htop=htop);

//to be able to retrieve the sizes from outside the lib
function cover() = [
  [76.70,75,8.3],//innen 
  [83.20,80,9.5], //aussen
  [60.40,50.6,5], //ausparung oben
  [45.24,45.75,10], //ausparung innen
];

//The border around the piece, making the junction with the wall
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
//The screws that fix the outer part to the inner part
module bohrung(obenrechts = [10,10], center = false )
{
  x = (center)?obenrechts[0]/2:obenrechts[0]; 
  y = (center)?obenrechts[1]/2:obenrechts[1]; 
  for(n=[0:3]) 
    translate([((n%3 == 0)? -1:1)*x,((n >1)? 1:-1)*y,0])  children();
}
//The inner part holding the switching mechanism
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


//The cutout for the switch to let it open and close
module papillon(tol = 0)
{
  tx0 = sqrt(1.5^2+20.5^2);
  triangle = [
    [0,0.3+tol],
    [tx0+tol,2+tol],
    [tx0+tol,-3-tol],
    [0,-3-tol],

  ];
    rotate([90,0,90])
      linear_extrude(height=13, center = true) 
      {
        mirror([1,0,0])polygon(triangle);
        polygon(triangle);
      }
}
//The inner parts cover, generic starting point to add a plexo building block
module plexo_insert(tol = .4,h=tp, htop = tp)
{
  difference()
  {
    union()
    {
      intersection()
      {
        rounded_cube(d=8, siz = [cover[2][0]-tol,cover[2][1]-tol,cover[1][2]] );
        plexo_platine(h=tp);
      }
      translate([0,0,cover[1][2]/4]) 
      {
        difference()
        {
          translate([0,0,htop/2]) 
            rounded_cube(d=8, siz = [cover[2][0]-tol,cover[2][1]-tol,htop] );
          union()
          {
            //Schraubloecher Aufweitung
            translate([0,0,-tp]) 
              bohrung(obenrechts = loecher, center = true  )
              {
                translate([durch[1]-durch[0],0,0]) cylinder(d=durch[0]+2, h=2*(h+htop),$fn=20, center = false);
                cylinder(d=durch[0]+2, h=2*(h+htop),$fn=20, center = false);
              }
          }
        }
      }
    }

  }
}
//The inner parts cover, with the visible part of the switch
//a modeling platform to add custom switches on top of it, it has a hole for passing through 
//something to press onto the switch
module plexo_switch_insert(tol = .4,h=tp, htop = tp)
{
  //plexo_cylinder shape
  //h^2=p*q//Euklid Sehnen/Höhensatz
  q=(35.5/2)^2/2;
  pr = 2+q;

  difference()
  {
    plexo_insert(tol = tol,h=h, htop = htop);

    union()
    {
      translate([0,0,cover[1][2]/4]) 
        translate([-5,0,1]) papillon(tol = 0);
      //untere Rundung
      intersection()
      {
        translate([0,0,-q+pr/2+tp-.1])
          rotate([0,90,0])
          cylinder(d=pr,h=42,center = true, $fa=.1);
        translate([0,0,-15+tp+h])
          cube([50,42,30], center = true);
      }
      translate([-5,(cover[2][1])/2-9.1,htop-2]) stempel(h=10, mask = true, tol=1);
    }
  }
}

module stempel(h=10, tol=.2, mask = false)
{
  innercube = (!mask)?[12-tol,12-tol,h]:[12+tol,12+tol,2*h];
  basecube = (!mask)?[14,14,2]:[14+tol,14+tol,2*h+2*tol];
  translate([0,0,innercube[2]/2]) cube(innercube, center = true);
  color("red")
    translate([-basecube[0]/2,-basecube[1]/2,(!mask)?0:-basecube[2]+2+2*tol]) cube(basecube, center = false);
}
