plotConfig = struct();
plotConfig.PLOT_ORIENTATION = true;
plotConfig.PLOT_ACC_OR_BREAKING = true;
plotConfig.PLOT_G_FORCE_AND_COMPONENTS = true;
plotConfig.PLOT_CUBE = true;
plotConfig.CUBE_SIZE_RATIO = 0.7; 
% for a better VISUAL comparison with the device position, this align the orientation (VERTICAL,FORWARD,LATERAL) to axis (X,Y,Z)
plotConfig.ADJUST_PLOT_VIEW = true;

% initialize measured VERTICAL vector (vehicle not moving)
vVertical =  [13, -49, -975];

% initialize measured ACCELERATING OR BREAKING vector
% OBS: If using the vector mesuared when the vehicle is breaking, we must reverse its direction
vAccOrBreaking =  [6, -174, -184]*5;

% initialize ANY mesuared G force vector
gForce = [-500, -600, -400];

alignment.run(plotConfig, vVertical, vAccOrBreaking, gForce);