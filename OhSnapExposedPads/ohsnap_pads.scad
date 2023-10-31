/*
Digi-Key's Oh Snap! Enclosure for MPLAB® SNAP Debugger
https://www.thingiverse.com/thing:3074301
licensed under the Creative Commons - Attribution license

Modified for University of Minnesota, Department of Electrical and Computer Engineering
By Dave Ballard, 2023

Holes cut to expose pads (so headers can be added)
*/

difference() {
    rotate([90,0,0]) import("./OhSnapSnapTop.stl");
    translate([41,-25-13.5,0]) linear_extrude(5) square([5,13.5]);
    translate([35,-33.5-5,0]) linear_extrude(5) square([11,5]);
    translate([41+2.5,-25-13.5+7.25,0]) linear_extrude(0.5, scale=0.8 ) square([5+1,13.5+1],center=true);
    translate([35+5.5,-33.5-5+2.5,0]) linear_extrude(0.5, scale=0.8) square([11+1,5+1],center=true);
}
