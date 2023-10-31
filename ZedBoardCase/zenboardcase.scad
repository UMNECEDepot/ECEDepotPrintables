/*
Protective enclosure 1.1 for the Digilent ZedBoard (rev. D)

Designed for University of Minnesota, Department of Electrical and Computer Engineering
By Dave Ballard, 2023
Distributed under CC 4.0 (Attribution) - Distribute and modify freely, but please mention us in all distributions and derivative works

This is fully parametric and should work for other boards where access to ports, controls, displays, etc from the side and top is necessary (as long as all you need are rectangular cutout for access)
*/


//BOARD PARAMETERS

//Which half to generate
//false to generate bottom, true to generate top
generate_top = false;

//print_half allows the model to be generated in halves for smaller printers
//0 - print entire object; 1 - print close half; 2 - print far half
print_half = 2;

//Space to leave between snap-fit wall halves
snap_fit_margin = 0.1;

//Board Dimensions
board_length = 160; //x-direction
board_width = 135;  //y-direction 

//Space to leave around boards
board_margin = 0.4;

//Height of walls of case above top of board
wall_height = 3.5;

//How thick the enclosure shell is
thickness = 2;

//Location of (center of) screw holes in board in [x,y] form
hole_placement = [[4,3.66],[4, board_width-3.66],[board_length-4, 3.66],[board_length-4, board_width-3.66],[board_length-5.75,36],
        [board_length-5.75,board_width-36]];

//How thick the holes are
hole_diameter = 3.75;

//Dimensions of the standoffs that the board rests on
standoff_diameter = hole_diameter + thickness;
standoff_height = 5;
standoff_margin = 1.6;  //This is the thickness of the circuit board itself
screw_hole_diameter = 2;
screw_well_diameter = 4.2; //thick enough for sheet metal screw

//Special cutous that extend below the board
//sides: 0 - bottom, 1 - left, 2 - right, 3 - top
//[side, position, length, depth]
lower_cutouts = [[2,55,27.5,3.5]];

//Cutouts from top of board to access parts from above or let tall parts stick out of enclosure
//Also cuts out any sides it intersects
//in [x1,y1,x2,y2] form
top_cutouts = [
            /*side items arranged in increasing distance from origin*/

            /*bottom*/  [8.5,0,25.5,11], [31.5,0,48,11], [50,0,110,19], 
            /*left*/    [0,13,11.5,79.5], [0,80.5,0,89], [0.5,90,10,94], [0,96.5,0,105.5], [0,109.5,7.5,128],
            
            /*right*/    [144.5,38,160,96.5], [124.5,105.5,160,116], [153,127,160,116], 
            
            /*top*/     [10,119.5,20.5,135], [23.5,135,32.5,135], [37.5,120,75,135], [76.5,108,94,135], [100,124,116.5,135], [120,128,152,135], [126,119,145,135],
            
            /*middle items arranged left to right, bottom to top*/                 
            
            /*switches*/[18,19.5,37,29.5], [92.5,19.5,111,30], [122,10,154.5,19], [134,0.5,143.5,28.5], [8.25,108.5,22.5,117],
            
            /*headers*/ [118.5,21.5,132,32], [146.5,24.5,159.5,32.5], [155,18.5,159.5,25], [23.5,111,30.5,116], [34.5,91,38.5,98], [55,114,59,120.5], [61,99,69,104], [90,91,95,97], [115,93,134,103], [153,117,159.5,126.5],
            
           /*LEDs*/    [39.5,22,43,26.5], [87,22,90,26], [24,74,28,78.5], [7.5,96.5,11.5,105.5],
            
            /*Misc*/            
                /*inductor?*/   [41,93,48,100], 
                /*heat sink*/   [69,56,91,79], 
                /*LCD*/         [46,18,81.5,31.5],
            
            /*?*/
            ];

//END OF PARAMETERS

difference() {
if(generate_top) {
//Top
    difference () {
        union() {
            //Box
            difference() {
                //Outer container
                cube([  board_length+2*board_margin+2*thickness, 
                        board_width+2*board_margin+2*thickness, 
                        thickness+wall_height]);
                //Cutout for inner container
                translate([thickness,thickness,0]) 
                    cube([  board_length+2*board_margin, 
                            board_width+2*board_margin, 
                            wall_height]);
                //Shave off outer wall top wall on inside of snap-fit joint
                cube([board_length+2*board_margin+2*thickness,thickness/2+snap_fit_margin/2,wall_height]);
                cube([thickness/2+snap_fit_margin/2,board_width+2*board_margin+2*thickness,wall_height]);
                translate([0,board_width+2*thickness+2*board_margin-thickness/2-snap_fit_margin/2,0])
                    cube([board_length+2*board_margin+2*thickness,thickness/2+snap_fit_margin/2,wall_height]);
                translate([board_length+2*thickness+2*board_margin-thickness/2-snap_fit_margin/2,0,0])
                    cube([thickness/2+snap_fit_margin/2,board_width+2*board_margin+2*thickness,wall_height]);
                //Top cutouts
                for(i = top_cutouts) {
                    x1 = i[0] <= 0 ? i[0]-thickness-board_margin : i[0];
                    y1 = i[1] <= 0 ? i[1]-thickness-board_margin : i[1];
                    x2 = i[2] >= board_length ? i[2]+thickness+board_margin : i[2];
                    y2 = i[3] >= board_width ? i[3]+thickness+board_margin : i[3];;
                   
                    translate([x1+thickness+board_margin,y1+thickness+board_margin,0]) 
                        cube([x2-x1,y2-y1,wall_height+thickness]);
                }
            }
            //Standoffs (above board, to allow screw to pass through board hole from top)
            for(i = hole_placement) {
                difference() {
                    translate([i[0]+board_margin+thickness,i[1]+board_margin+thickness,0]) 
                        cylinder(wall_height, d=standoff_diameter, $fn=45);
                    translate([i[0]+board_margin+thickness,i[1]+board_margin+thickness,0]) 
                        cylinder(wall_height, d=screw_hole_diameter, $fn=45);
                }
            }
        }
    }
    
} else {
//Bottom
    difference() {
        union() {
            //Box
            difference() {
                //Outer container
                cube([  board_length+2*board_margin+2*thickness, 
                        board_width+2*board_margin+2*thickness, 
                        thickness+standoff_height+standoff_margin+wall_height]);
                //Cutout for inner container
                translate([thickness,thickness,thickness]) 
                    cube([  board_length+2*board_margin, 
                            board_width+2*board_margin, 
                            thickness+standoff_height+standoff_margin+wall_height]);
                //Cutout for inner container above board (thinner walls)
                translate([thickness/2-snap_fit_margin/2,thickness/2-snap_fit_margin/2,thickness+standoff_height+standoff_margin]) 
                    cube([  board_length+2*board_margin+thickness+snap_fit_margin, 
                            board_width+2*board_margin+thickness+snap_fit_margin, 
                            thickness+standoff_height+standoff_margin+wall_height]);
                
                //Top cutouts
                for(i = top_cutouts) {
                    x1 = i[0] <= 0 ? i[0]-thickness-board_margin : i[0];
                    y1 = i[1] <= 0 ? i[1]-thickness-board_margin : i[1];
                    x2 = i[2] >= board_length ? i[2]+thickness+board_margin : i[2];
                    y2 = i[3] >= board_width ? i[3]+thickness+board_margin : i[3];;
                   
                    translate([x1+thickness+board_margin,y1+thickness+board_margin,thickness+standoff_height+standoff_margin]) 
                        cube([x2-x1,y2-y1,wall_height]);
                }
                //Side cutouts below board (require supports when printing)
                for(i = lower_cutouts) {
                    if(i[0] == 0) {
                        translate([i[1],0,thickness+standoff_height-i[3]]) 
                            cube([i[2],i[2],i[3]]);
                    } else if(i[0] == 1) {
                        translate([0,i[1],thickness+standoff_height-i[3]]) 
                            cube([i[2],i[2],i[3]]);
                    } else if(i[0] == 2) {
                        translate([board_length+board_margin+thickness,i[1],thickness+standoff_height-i[3]]) 
                            cube([i[2],i[2],i[3]]);
                    } else {
                        translate([i[1],board_width+board_margin+thickness,thickness+standoff_height-i[3]]) 
                            cube([i[2],i[2],i[3]]);
                    }
                }
            }
            //Standoffs (to support board and allow screws for fastening)
            for(i = hole_placement) {
                translate([board_margin+thickness,board_margin+thickness]) difference() {
                    translate([i[0],i[1],thickness]) 
                        cylinder(standoff_height, d=standoff_diameter, $fn=45);
                    translate([i[0],i[1],thickness]) 
                        cylinder(standoff_height+standoff_margin, d=screw_hole_diameter, $fn=45);
                }
            }
        }
        //Bottom drill-outs for screw heads
        for(i = hole_placement) {
            translate([i[0]+board_margin+thickness,i[1]+board_margin+thickness,0]) 
                cylinder(standoff_height, d=screw_well_diameter, $fn=45);
        }
    }
}

//chop off half for smaller print beds
if(print_half == 1) {
    translate([(board_length/2+board_margin+thickness),-(board_width+board_margin*2+thickness*2),-(standoff_height+standoff_margin+wall_height+thickness)]) 
        cube([(board_length/2+board_margin+thickness)*2,(board_width+board_margin*2+thickness*2)*3,(standoff_height+standoff_margin+wall_height+thickness)*3]);
} else if(print_half == 2) {
    translate([-(board_length/2+board_margin+thickness),-(board_width+board_margin*2+thickness*2),-(standoff_height+standoff_margin+wall_height+thickness)]) 
        cube([(board_length/2+board_margin+thickness)*2,(board_width+board_margin*2+thickness*2)*3,(standoff_height+standoff_margin+wall_height+thickness)*3]);
}
}