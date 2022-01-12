/* $fn = 25; */

// Units: mm
lego_u = 7.97;

lego_beam_w = 7.38;
lego_beam_h = 7.76;

lego_pin_hole_d = 4.8;
lego_pin_hole_overhang_d = 6.2;
lego_pin_hole_overhang_h = 0.8;

lego_axle_d = 4.7;
lego_axle_w = 1.6; // Width of one "arm"

lego_axle_outer_r = 0.1;
lego_axle_inner_r = 0.8;

/* Pin_Hole(); */
//Lego_Beam($fn=100, 2);

module Lego_Beam(length, pin_inner_tol=0, pin_outer_tol=0) {
    difference() {
        solid_beam(length*lego_u);
        for(i = [0:length]) {
            translate([lego_u*i,0,0]) Pin_Hole(inner_tol=pin_inner_tol, outer_tol=pin_outer_tol);
        }
    }

    module solid_beam(length) {
        cylinder(lego_beam_h, d=lego_beam_w+pin_outer_tol, center=true);
        translate([length-lego_u,0,0]) cylinder(lego_beam_h, d=lego_beam_w+pin_outer_tol, center=true);
        translate([(length-lego_u)/2,0,0]) cube([length-lego_u, lego_beam_w+pin_outer_tol, lego_beam_h], center=true);
    }
}

module Pin_Hole(inner_tol=0, outer_tol=0) {
    half();
    mirror([0,0,1]) half();

    module half() {
        translate([0,0,lego_beam_h/4]) cylinder(lego_beam_h/2, d=lego_pin_hole_d+inner_tol, center=true);
        translate([0,0,(lego_beam_h-lego_pin_hole_overhang_h)/2]) cylinder(lego_pin_hole_overhang_h, d=lego_pin_hole_overhang_d+outer_tol, center=true);
    }
}

// FreeCAD breaks this
module Lego_Axle(length) {
    difference() {
        group() {
            intersection() {
                union() {
                    cube([lego_axle_w, lego_axle_d, length], center=true);
                    cube([lego_axle_d, lego_axle_w, length], center=true);
                }
                cylinder(length, d=lego_axle_d, center=true);
            }
            d = sqrt(2*(lego_axle_w/2)^2);
            inner_fillet(d);
        }
        union() {
            d = sqrt((lego_axle_d/2)^2-(lego_axle_w/2)^2);
            a = atan2(lego_axle_w/2, d) + 90;
            outer_fillet(d, a);
            /* mirror([1,0,0]) outer_fillet(d, a); */
        }
    }
    
    module inner_fillet(d) {
        for(i = [0:3]) {
            a = 90*i;
            translate(d*[cos(a+45), sin(a+45), 0]) rotate([0, 0, a]) Reverse_Fillet(length, r_to_inverse(lego_axle_inner_r, 90), angle=90);
        }
    }

    module outer_fillet(d, a) {
        outer_fillet_half(d, a);
        mirror([1, 0, 0]) outer_fillet_half(d, a);
    }
    
    module outer_fillet_half(d, a) {
        for(i = [0:3]) {
            rotate([0, 0, 90*i]) translate([-d, -lego_axle_w/2, 0]) Reverse_Fillet(length, r_to_inverse(lego_axle_outer_r, a), angle=a);
        }
    }
}

module Reverse_Fillet(length, i_r, angle=90) {
    angle = angle % 180;
    r = i_r/(1/sin(angle/2)-1);
    w = sqrt((r+i_r)^2 - r^2);
    corner = [
        [0, 0],
        [w, 0],
        [w, r],
        w*[cos(angle), sin(angle)],
    ];
    
    difference() {
        translate([0, 0, -length/2]) linear_extrude(length) polygon(corner);
        translate([w, r, 0]) cylinder(length, r=r, center=true);
    }
}

function r_to_inverse(r, angle) = r*(1/sin(angle/2)-1);
