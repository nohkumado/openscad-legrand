use  <plexo.scad>
use <../../mechanical/hinge.scad>
use <../../nohscadlib/fillet.scad>

tp =3; //thickness of the platine
htop = 4; //thickenss of the deco layer on top (min 3, otherwise the underlying structure shows through
tol = .4; //tolerance around the switch mechanisms
name="BOETTCHER"; //the name to inprint 
name_size=5; //size of the writing
name_off = [0,0]; //didn't find out how to mesure automaticly the text, an offset to correct it

knopf_insert(htop=htop, tol=tol, h=tp, name=name, name_off=name_off, name_size=name_size);

module knopf_insert(tol = .4,h=tp, name="BOETTCHER", name_off = [28,10], name_size=3, htop=htop)
{

  cover = cover(); //retrieve the sizes
  translate([0,0,-(h+htop)])
  {
    difference()
    {
    plexo_insert(tol = tol,h=h, htop=htop);
    }
  }


  //Nameplate
  translate([0,-cover[3][0]/2+6,1])
  {
    difference()
    {
      //color("green")
	cube([cover[3][0],15,2], center=true);
      translate([name_off[0],name_off[1],0]) 
      {
	//color("red")
	  translate([name_off[0],name_off[1],-1])
	  rotate([0,0,180])
	  linear_extrude(height=4)
	  //,font="Uechi:style=Gothic" , $fn=50
	  text(name, size=name_size, halign="center", valign="center");
      }
    }
  }
}
