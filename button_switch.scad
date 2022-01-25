use  <plexo.scad>
use <../../mechanical/hinge.scad>
use <../../nohscadlib/fillet.scad>

tp =3; //thickness of the platine
htop = 4; //thickenss of the deco layer on top (min 3, otherwise the underlying structure shows through
tol = .4; //tolerance around the switch mechanisms
name="BOETTCHER"; //the name to inprint 
name_size=5; //size of the writing
name_off = [0,0]; //didn't find out how to mesure automaticly the text, an offset to correct it
cover = cover(); //retrieve the sizes
button_height = 10;

knopf_insert(htop=htop, tol=tol, h=tp, name=name, name_off=name_off, name_size=name_size);
translate([1.2*cover[0][0]/2,0,1.374])rotate([0,180,0])stempel(h=button_height, tol=tol, mask = false);

module knopf_insert(tol = .4,h=tp, name="BOETTCHER", name_off = [28,10], name_size=3, htop=htop)
{

  //Nameplate
    difference()
    {
      translate([0,0,-(h+htop)])
      {
	plexo_insert(tol = tol,h=h, htop=htop+2);
      }


      //color("green")
      translate([name_off[0],-cover[3][0]/2+6+name_off[1],0]) 
      {
	//color("red")
	translate([name_off[0],name_off[1],-1])
	  rotate([0,0,180])
	  linear_extrude(height=4)
	  //,font="Uechi:style=Gothic" , $fn=50
	  text(name, size=name_size, halign="center", valign="center");
      }
    }
            %translate([-5,(cover[2][1])/2-9.1,-2]) stempel(h=button_height, tol=tol, mask = false);
}
