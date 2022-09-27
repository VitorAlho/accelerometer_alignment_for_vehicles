# acceloremeter_calibration_for_vehicles

This MATLAB script computes the acceloremeter orientation for a vehicle without the need of a gyroscope.
It also computes the components of any other vector/acceleration for the given orientation.

It is assumed that the user is able to collect the **UPWARD** vector, and is able to compute the **UPWARD_FORWARD** vector, as described:
  **UPWARD VECTOR:** it is the raw sensor data when the vehicle is not moving.
  
  **UPWARD_FORWARD_VECTOR:** it is the raw sensor data when the vehicle is moving forward, to be sure the vehicle is moving forward you may use any technique you want, like analyzing if speed is greather than zero, etc.


