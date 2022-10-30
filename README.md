# accelerometer_calibration_for_vehicles

This script computes the accelerometer orientation for a vehicle.
It also computes the components of any other acceleration for the given orientation.

It is assumed that the user is able to collect the **VERTICAL** vector, and is able to compute the **VERTICAL_FORWARD** vector, as described:

**VERTICAL VECTOR:** It is the raw sensor data when the vehicle is not moving, the reason is that when the vehicle is not moving, the only acceleration applied to the accelerometer is the earth's own gravity, as the gravity direction is parallel to the "Vertical" direction, we can assume that the raw sensor data represents the vector of the vertical direction.

**VERTICAL_FORWARD_VECTOR:** it is the raw sensor data when the vehicle is moving forward, to be sure the vehicle is moving forward you may use any technique you want, like analyzing if speed is greather than zero, etc.
