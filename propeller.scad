//$fn = 1000;

// Units: mm
mag_len = 2;
mag_rad = 3.1;
arm_len = 12;
arm_rad = mag_rad + 1.5/2;
pin_rad = 2;

Propeller(arm_len, arm_rad, mag_len, mag_rad, pin_rad, arm_c=4);

module Propeller(arm_len, arm_rad, mag_len, mag_rad, pin_rad, arm_c=4) {
    difference() {
        for(i = [0 : arm_c]) {
            rotate([90, 0, 360/arm_c*i]) Arm(arm_len, arm_rad, mag_len, mag_rad);
        }
        cylinder(arm_rad*2, r=pin_rad, center=true);
    }
}

module Arm(arm_len, arm_rad, mag_len, mag_rad) {
    translate([0, 0, arm_len/2]) difference() {
        cylinder(arm_len, r=arm_rad, center=true);
        translate([0, 0, arm_len/2]) cylinder(mag_len*2, r=mag_rad, center=true);
    }
}
