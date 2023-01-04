#include <stdio.h>
#include <string.h>
#include "vectorsMath.h"


// This option is just for debbuging the vector components of any acceleration
#define SHOW_COMPONENTS_OF_MEASURED_ACCELERATION 1

int main()
{
    // initialize measured VERTICAL vector (vehicle not moving)
    Vector vVertical;
    vVertical.X = 800;
    vVertical.Y = 1000;
    vVertical.Z = 300;

    // initialize measured FORWARD ACCELERATION (vehicle acceleration in forward direction)
    // OBS: We can also use the vector mesuared when the vehicle is breaking, but we must reverse its direction
    Vector vForwardAcceleration;
    vForwardAcceleration.X = 500;
    vForwardAcceleration.Y = 1000;
    vForwardAcceleration.Z = 1000;

    // find orientation
    Orientation o;
    findOrientation(&vVertical, &vForwardAcceleration, &o);
    printf("Alignment Vectors:\r\n");
    printf("vVertical -> [%i, %i, %i]\r\n", (int)o.vVertical.X, (int)o.vVertical.Y, (int)o.vVertical.Z);
    printf("vForward -> [%i, %i, %i]\r\n", (int)o.vForward.X, (int)o.vForward.Y, (int)o.vForward.Z);
    printf("vLateral -> [%i, %i, %i]\r\n", (int)o.vLateral.X, (int)o.vLateral.Y, (int)o.vLateral.Z);

    //Now as we have the alignment ready, we can measure any magnitude in any direction.

    // initialize ANY mesuared vector
    Vector vG;
    vG.X = 500;
    vG.Y = 1000;
    vG.Z = -1000;

    #if SHOW_COMPONENTS_OF_MEASURED_ACCELERATION
    // find vector components of acceleration for each direction in the orientation
    Orientation vComponents;
    findVectorComponentsInTheOrientation(&vG, &o, &vComponents);
    printf("\r\nComponents of mesuared acceleration: [%i, %i, %i]\r\n", (int)vG.X, (int)vG.Y, (int)vG.Z);
    printf("vVertical Component -> [%i, %i, %i]\r\n", (int)vComponents.vVertical.X, (int)vComponents.vVertical.Y, (int)vComponents.vVertical.Z);
    printf("vForward Component -> [%i, %i, %i]\r\n", (int)vComponents.vForward.X, (int)vComponents.vForward.Y, (int)vComponents.vForward.Z);
    printf("vLateral Component -> [%i, %i, %i]\r\n", (int)vComponents.vLateral.X, (int)vComponents.vLateral.Y, (int)vComponents.vLateral.Z);
    #endif

    // find magnitudes of acceleration components for each direction in the orientation
    Magnitudes g;
    findComponentsMagnitudeInTheOrientation(&vG, &o, &g);
    printf("\r\nComponents magnitudes of mesuared acceleration: [%i, %i, %i]\r\n", (int)vG.X, (int)vG.Y, (int)vG.Z);
    printf("VERTICAL: %i, FORWARD: %i, LATERAL: %i\r\n", (int)g.VERTICAL, (int)g.FORWARD, (int)g.LATERAL);

    return 0;
}