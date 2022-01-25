use  <plexo.scad>
use <../../mechanical/hinge.scad>
use <../../nohscadlib/fillet.scad>

tp =3; //thickness of the platine
htop = 4; //thickenss of the deco layer on top (min 3, otherwise the underlying structure shows through
tol = .4; //tolerance around the switch mechanisms
name="BOETTCHER"; //the name to inprint 
name_size=3; //size of the writing
name_off = [28,10]; //didn't find out how to mesure automaticly the text, an offset to correct it

hebel_insert(htop=htop, tol=tol, h=tp, name=name, name_off=name_off, name_size=name_size);

//model with a big hinge switch
module hebel_insert(tol = .4,h=tp, name="BOETTCHER", name_off = [28,10], name_size=3, htop=htop)
{
  cover = cover(); //retrieve the sizes
  plexo_insert(tol = tol,h=h, htop=htop);

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
      translate([4,9.6,0]) rotate([0,-90,180])fillet(r=2, h=10, center = true, offs=1);
    }
  }
  translate([-15,12.5,tp+6]) 
  {
    difference()
    {
      cube([30,15,2]);
      translate([name_off[0],name_off[1],-1])
	rotate([0,0,180])
	linear_extrude(height=4)
	text(name, size=name_size);
    }
  }
}
