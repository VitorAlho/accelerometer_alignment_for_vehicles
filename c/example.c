#include <stdio.h>
#include <string.h>
#include "accOrientation.h"


// This option is just for debbuging the vector components of any acceleration
#define SHOW_COMPONENTS_OF_MEASURED_ACCELERATION 0

int main()
{
    // initialize measured UP vector (vehicle not moving)
    Vector vUp;
    vUp.X = 800;
    vUp.Y = 1000;
    vUp.Z = 300;

    // initialize measured UP_FRONT vector (vehicle acceleration in front direction)
    Vector vUpFront;
    vUpFront.X = 500;
    vUpFront.Y = 1000;
    vUpFront.Z = 1000;

    // find orientation
    Orientation o;
    findOrientation(&vUp, &vUpFront, &o);
    printf("vUp -> X: %f, Y: %f, Z: %f\r\n", o.vUp.X, o.vUp.Y, o.vUp.Z);
    printf("vFront -> X: %f, Y: %f, Z: %f\r\n", o.vFront.X, o.vFront.Y, o.vFront.Z);
    printf("vRight -> X: %f, Y: %f, Z: %f\r\n", o.vRight.X, o.vRight.Y, o.vRight.Z);

    // initialize ANY mesuared acceleration vector
    Vector vG;
    vG.X = 500;
    vG.Y = 1000;
    vG.Z = -1000;

    #if SHOW_COMPONENTS_OF_MEASURED_ACCELERATION
    // find vector components of acceleration for each direction in the orientation
    Orientation vComponents;
    findVectorComponentsInTheOrientation(&vG, &o, &vComponents);
    printf("vUp Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vUp.X, vComponents.vUp.Y, vComponents.vUp.Z);
    printf("vFront Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vFront.X, vComponents.vFront.Y, vComponents.vFront.Z);
    printf("vRight Component -> X: %f, Y: %f, Z: %f\r\n", vComponents.vRight.X, vComponents.vRight.Y, vComponents.vRight.Z);
    #endif

    // find vector magnitude of acceleration for each direction in the orientation
    OrientationMagnitude g;
    fingVectorsMagnitudeInTheOrientation(&vG, &o, &g);
    printf("UP: %f, FRONT: %f, RIGHT: %f\r\n", g.UP, g.FRONT, g.RIGHT);

    return 0;
}