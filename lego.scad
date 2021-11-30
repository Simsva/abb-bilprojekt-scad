// Units: mm
lego_u = 7.97;

lego_beam_w = 7.38;
lego_beam_h = 7.76;

lego_pin_hole_d = 4.8;
lego_pin_hole_overhang_d = 6.2;
lego_pin_hole_overhang_h = 0.8;

lego_axle_d = 4.7;
lego_axle_w = 1.6; // Width of one "arm"

/* Lego_Axle($fn=50, 3*lego_u); */
Reverse_Fillet($fn=50, 10, 2);

module Lego_Axle(length, smooth=true) {
    smoothing = 0.1;
    union() {
        minkowski() {
            scale([1-smoothing, 1-smoothing, 1]) intersection() {
                union() {
                    cube([lego_axle_w, lego_axle_d, length], center=true);
                    cube([lego_axle_d, lego_axle_w, length], center=true);
                }
                cylinder(length, d=lego_axle_d, center=true);
            }
            cylinder(length, d=smoothing*lego_axle_d);
        }
    }
}

module Reverse_Fillet(length, r, angle=90) {
    difference() {
        translate([r/2, r/2, 0]) cube([r, r, length], center=true);
        translate([r, r, 0]) cylinder(length, r=r, center=true);
    }
}
