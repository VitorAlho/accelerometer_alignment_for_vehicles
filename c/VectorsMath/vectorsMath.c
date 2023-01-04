/*
 * vectorsMath.c
 *
 *  Created on: September 27th, 2022
 *  Author: Roger Moschiel
 */

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "vectorsMath.h"

#define PI 3.1415

float vectorMagnitude(Vector *v);
void unitVector(Vector *inputV, Vector *outputV);
float dotProduct(Vector *v1, Vector *v2);
void subtractVectors(Vector *v1, Vector *v2, Vector *outputV);
void crossProduct(Vector *v1, Vector *v2, Vector *crossV);
int isVectorsInOppositeDirection(Vector *v1, Vector *v2);
void rotateVectorPassingThroughAnotherVector(Vector *v1, Vector *v2, int angle, Vector *rotV1);
void vectorComponentParallelToAnotherVector(Vector *v1, Vector *v2, Vector *parallelV);
void rotateVectorAroundAnotherVector(Vector *v1, Vector *v2, int angle, Vector *rotV1);
void findVectorComponentsInTheOrientation(Vector *v, Orientation *orientation, Orientation *vComponents);

float vectorMagnitude(Vector *v) {
	return sqrtf(v->X*v->X + v->Y*v->Y + v->Z*v->Z);
}

void unitVector(Vector *inputV, Vector *outputV) {
	float vm = vectorMagnitude(inputV);
    outputV->X = inputV->X / vm;
    outputV->Y = inputV->Y / vm;
    outputV->Z = inputV->Z / vm;
}

float dotProduct(Vector *v1, Vector *v2) {
    return v1->X*v2->X + v1->Y*v2->Y + v1->Z*v2->Z;
}

void subtractVectors(Vector *v1, Vector *v2, Vector *outputV) {
    outputV->X = v1->X - v2->X;
    outputV->Y = v1->Y - v2->Y;
    outputV->Z = v1->Z - v2->Z;
}

void divideVector(Vector *v1, int divisor, Vector *outputV) {
	outputV->X = v1->X / divisor;
	outputV->Y = v1->Y / divisor;
	outputV->Z = v1->Z / divisor;
}

void multiplyVector(Vector *v1, int multiplier, Vector *outputV) {
	outputV->X = v1->X * multiplier;
	outputV->Y = v1->Y * multiplier;
	outputV->Z = v1->Z * multiplier;
}

void accumulateVector(Vector *vAccumulated, Vector *vNew) {
	vAccumulated->X += vNew->X;
	vAccumulated->Y += vNew->Y;
	vAccumulated->Z += vNew->Z;
}

int angleBetweenVectors(Vector *v1, Vector *v2)
{
	float CosTheta = dotProduct(v1, v2) / ( vectorMagnitude(v1) * vectorMagnitude(v2) );
	//range -1 a 1 represents 0 to 180 degrees, it can't be outside this range
	if(CosTheta > 1) CosTheta = 1;
	if(CosTheta < -1) CosTheta = -1;

	//angle = radians*(180/PI)
	return abs((acos(CosTheta)*(180/PI)));
}

int getVectorAvg(Vector *vList, int listSize, Vector *vAvg)
{
	int validCount = 0;
	memset(vAvg, 0, sizeof(Vector));

	for(int i=0; i<listSize; i++)
	{
		//verifica se vetor foi preenchido, e se valores sao menores que 2G (consideramos valores > 2G um erro)
		if(isAccVectorValid(&vList[i]))
		{
			//acumula vetor
			accumulateVector(vAvg, &vList[i]);

			validCount++; //contabiliza vetor valido
		}
	}

	//calculamos a media de todos os vetores validos
	if(validCount)
	{
		divideVector(vAvg, validCount, vAvg);
	}

	return validCount > 0;
}

int isAccVectorValid(Vector *v)
{
	//verifica se vetor foi preenchido, e se valores sao menores que 2G (consideramos valores > 2G erro ou lixo do bkpsram)
	return (v->X!=0 || v->Y!=0 || v->Z!=0) && (v->X<2000 && v->Y<2000 && v->Z<2000);
}

void crossProduct(Vector *v1, Vector *v2, Vector *crossV) {
    // The cross product between two 3-D vectors produces a new vector that is perpendicular to both.
    // https://www.mathworks.com/help/matlab/ref/cross.html#bt9u2fz-5

	crossV->X = v1->Y*v2->Z - v1->Z*v2->Y;
	crossV->Y = v1->Z*v2->X - v1->X*v2->Z;
	crossV->Z = v1->X*v2->Y - v1->Y*v2->X;
}

int isVectorsInOppositeDirection(Vector *v1, Vector *v2) {
    return dotProduct(v1, v2) < 0;
}

void rotateVectorPassingThroughAnotherVector(Vector *v1, Vector *v2, int angle, Vector *rotV1) {
    // How to rotate a vector passing through another vector in the same direction
    // https://math.stackexchange.com/questions/4386389/how-to-rotate-a-vector-through-another-vector-in-the-same-direction

    // First we set e1 to the unit vector in the same direction as v1:
    Vector e1;
	unitVector(v1, &e1);

    // Now it's simple to find c1 using the dot product:
	float c1 = dotProduct(v2, &e1);

    // Let u2 = c2e2 = v2-c1e1, then
    Vector u2;
    u2.X = v2->X - c1*e1.X;
    u2.Y = v2->Y - c1*e1.Y;
    u2.Z = v2->Z - c1*e1.Z;

    //  Then we set e2 to the unit vector in the same direction as u2.
    Vector e2;
    unitVector(&u2, &e2);

     // To rotate v1 toward v2 by some rad angle, just compute rotV1 = (|v1|cos(rad))e1 + (|v1|sin(rad))e2
    float v1_m = vectorMagnitude(v1);
    float radians = angle*(PI/180.0);
    float cosRad = cos(radians);
    float sinRad = sin(radians);

    rotV1->X = (v1_m * cosRad) * e1.X + (v1_m * sinRad) * e2.X;
    rotV1->Y = (v1_m * cosRad) * e1.Y + (v1_m * sinRad) * e2.Y;
    rotV1->Z = (v1_m * cosRad) * e1.Z + (v1_m * sinRad) * e2.Z;
}

void vectorComponentParallelToAnotherVector(Vector *v1, Vector *v2, Vector *parallelV) {
    // Project v1 onto v2. Result will be parallel to v2
	float aux = (float)dotProduct(v1, v2) / (float)dotProduct(v2 , v2);

	parallelV->X = aux * v2->X;
	parallelV->Y = aux * v2->Y;
	parallelV->Z = aux * v2->Z;
}

void rotateVectorAroundAnotherVector(Vector *v1, Vector *v2, int angle, Vector *rotV1) {
    // How to rotate a vector around another vector
    // https://math.stackexchange.com/questions/511370/how-to-rotate-one-vector-about-another
    // https://gist.github.com/fasiha/6c331b158d4c40509bd180c5e64f7924#file-rotatevectors-py-L35-L42

    float radians = angle*(PI/180);

	Vector paralelToV2;
	vectorComponentParallelToAnotherVector(v1, v2, &paralelToV2);

	Vector perpendicularToV2;
    subtractVectors(v1, &paralelToV2, &perpendicularToV2);

    Vector w;
    crossProduct(v2, &perpendicularToV2, &w);

    float perpendicularToV2_mag = vectorMagnitude(&perpendicularToV2);
    float w_mag = vectorMagnitude(&w);
    float cosRad = cos(radians);
    float sinRad = sin(radians);

    rotV1->X = paralelToV2.X + perpendicularToV2.X * cosRad + perpendicularToV2_mag * (w.X / w_mag) * sinRad;
    rotV1->Y = paralelToV2.Y + perpendicularToV2.Y * cosRad + perpendicularToV2_mag * (w.Y / w_mag) * sinRad;
    rotV1->Z = paralelToV2.Z + perpendicularToV2.Z * cosRad + perpendicularToV2_mag * (w.Z / w_mag) * sinRad;
}

void findOrientation(Vector *vVertical, Vector *vVerticalForward, Orientation *orientation) {
    // find FORWARD and LATERAL  vectors
    //populate FORWARD orientation
	rotateVectorPassingThroughAnotherVector(vVertical, vVerticalForward, 90, &orientation->vForward);
    //populate LATERAL orientation
    rotateVectorAroundAnotherVector(vVertical, &orientation->vForward, -90, &orientation->vLateral);
    
    memcpy(&orientation->vVertical, vVertical, sizeof(Vector));
}

void findVectorComponentsInTheOrientation(Vector *v, Orientation *orientation, Orientation *vComponents) {
    // find vector components of measuread vector for each direction
    vectorComponentParallelToAnotherVector(v, &orientation->vVertical, &vComponents->vVertical);
    vectorComponentParallelToAnotherVector(v, &orientation->vForward, &vComponents->vForward);
    vectorComponentParallelToAnotherVector(v, &orientation->vLateral, &vComponents->vLateral);
}

void findComponentsMagnitudeInTheOrientation(Vector *v, Orientation *orientation, Magnitudes *g) {
	Orientation vComponents;
	
    findVectorComponentsInTheOrientation(v, orientation, &vComponents);

    // find magnitude for each direction
    g->VERTICAL = vectorMagnitude(&vComponents.vVertical);
    g->FORWARD = vectorMagnitude(&vComponents.vForward);
    g->LATERAL = vectorMagnitude(&vComponents.vLateral);

    if (isVectorsInOppositeDirection(&orientation->vVertical, &vComponents.vVertical)){
        g->VERTICAL = -g->VERTICAL;
    }
    if (isVectorsInOppositeDirection(&orientation->vForward, &vComponents.vForward)){
        g->FORWARD = -g->FORWARD;
        }
    if (isVectorsInOppositeDirection(&orientation->vLateral, &vComponents.vLateral)){
        g->LATERAL = -g->LATERAL;
    }
}