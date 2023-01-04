# accelerometer_alignment_for_vehicles

This script computes the accelerometer orientation for a vehicle.
It also computes the components of any other acceleration for the given orientation.

It is assumed that the user is able to measure the **VERTICAL VECTOR**, and is able to measure the **ACCELERATION OR BREAKING VECTOR**, as described:

**VERTICAL VECTOR:** It is the raw sensor data when the vehicle is not moving, the reason is that when the vehicle is not moving, the only acceleration applied to the accelerometer is the earth's own gravity, as the gravity direction is parallel to the "Vertical" direction, we can assume that the raw sensor data represents the vector of the vertical direction.

**ACCELERATION OR BREAKING VECTOR:** it is the raw sensor data when the vehicle is accelerating or breaking, if using the 'breaking' vector, this vector must have its direction reversed.
