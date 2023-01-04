/*
 * vectorsMath.h
 *
 *  Created on: 27 de set de 2022
 *      Author: Roger Moschiel
 */

#ifndef VECTORS_MATH_H_
#define VECTORS_MATH_H_

//describe any vector
typedef struct {
	float X;
	float Y;
	float Z;
} Vector;

//describe orientation vectors
typedef struct {
	Vector vVertical;
	Vector vForward;
	Vector vLateral;
} Orientation;

//describe the magnitude of the components of a vector in every direction of the orientation
typedef struct {
	float VERTICAL;
	float FORWARD;
	float LATERAL;
} Magnitudes;

void findOrientation(Vector *vVertical, Vector *vVerticalForward, Orientation *orientation);
void findComponentsMagnitudeInTheOrientation(Vector *v, Orientation *orientation, Magnitudes *g);
int angleBetweenVectors(Vector *v1, Vector *v2);
int getVectorAvg(Vector *vList, int listSize, Vector *vAvg);
int isAccVectorValid(Vector *v);
void accumulateVector(Vector *vAccumulated, Vector *vNew);
void divideVector(Vector *v1, int divisor, Vector *outputV);
void multiplyVector(Vector *v1, int multiplier, Vector *outputV);

#endif /* VECTORS_MATH_H_ */