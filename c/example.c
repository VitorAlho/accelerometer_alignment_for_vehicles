#include <stdio.h>
#include <string.h>
#include "accOrientation.h"


// This option is just for debbuging the vector components of any acceleration
#define SHOW_COMPONENTS_OF_MEASURED_ACCELERATION 0

int main()
{
    // initialize measured VERTICAL vector (vehicle not moving)
    Vector vVertical;
    vVertical.X = 800;
    vVertical.Y = 1000;
    vVertical.Z = 300;

    // initialize measured VERTICAL_FORWARD vector (vehicle acceleration in forward direction)
    Vector vVerticalForward;
    vVerticalForward.X = 500;
    vVerticalForward.Y = 1000;
    vVerticalForward.Z = 1000;

    // find orientation
    Orientation o;
    findOrientation(&vVertical, &vVerticalForward, &o);
    printf("vVertical -> X: %f, Y: %f, Z: %f\r\n", o.vVertical.X, o.vVertical.Y, o.vVertical.Z);
    printf("vForward -> X: %f, Y: %f, Z: %f\r\n", o.vForward.X, o.vForward.Y, o.vForward.Z);
    printf("vLateral -> X: %f, Y: %f, Z: %f\r\n", o.vLateral.X, o.vLateral.Y, o.vLateral.Z);

    // initialize ANY mesuared acceleration vector
    Vector vG;
    vG.X = 500;
    vG.Y = 1000;
    vG.Z = -1000;

    #if SHOW_COMPONENTS_OF_MEASURED_ACCELERATION
    // find vector components of acceleration for each direction in the orientation
    Orientation vComponents;
    findVectorComponentsInTheOrientation(&vG, &o, &vComponents);
    printf("vVertical Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vVertical.X, vComponents.vVertical.Y, vComponents.vVertical.Z);
    printf("vForward Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vForward.X, vComponents.vForward.Y, vComponents.vForward.Z);
    printf("vLateral Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vLateral.X, vComponents.vLateral.Y, vComponents.vLateral.Z);
    #endif

    // find vector magnitude of acceleration for each direction in the orientation
    OrientationMagnitude g;
    fingVectorsMagnitudeInTheOrientation(&vG, &o, &g);
    printf("VERTICAL: %f, FORWARD: %f, LATERAL: %f\r\n", g.VERTICAL, g.FORWARD, g.LATERAL);

    return 0;
}