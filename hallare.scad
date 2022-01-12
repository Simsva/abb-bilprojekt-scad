include <lego.scad>;

$fn = 100;

// Units: mm
tol = 0.3;
pcb_h = 1.7+tol*2;
overhang_h = 1;
back_w = 2;
w = lego_u*4;
h = 4.5;
overhang_w = 2;
pcb_w = 20.25+tol*3;

d_pcb = (w-lego_u-pcb_w)/2;
echo(d_pcb);

Holder(lego_beam_w*3);

module Holder(length) {
    half(length);
    mirror([1,0,0]) half(length);
    
    // Back
    translate([0, back_w/2-lego_beam_w/2, overhang_h+pcb_h/2-lego_beam_h/2]) cube([w-lego_beam_w, back_w, overhang_h*2+pcb_h], center=true);

    module half(l) {
        translate([-w/2, 0, 0]) rotate([0,0,90]) Lego_Beam(2, pin_inner_tol=2*tol, pin_outer_tol=tol);
        translate([(-w+lego_beam_w+d_pcb+overhang_w)/2,l/2-lego_beam_w/2,(overhang_h*2+pcb_h-lego_beam_h)/2]) difference() {
            cube([d_pcb+overhang_w, l, overhang_h*2+pcb_h], center=true);
            translate([overhang_w/2,0,0]) cube([overhang_w, l, pcb_h], center=true);
        }
    }
}
