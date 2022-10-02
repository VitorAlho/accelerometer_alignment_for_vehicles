LOG_ORIENTATION = false; % LOG orientation vectors (UP, FRONT, RIGHT)
LOG_ACCELERATION_COMPONENTS = false; % LOG the compontens of any given acceleration, align in the orientation
LOG_ACCELERATION_MAGNITUDES = false; % Log the magnitude of the components

PLOT_ORIENTATION = true; 
PLOT_UP_FRONT = false;
PLOT_ACCELERATION_AND_COMPONENTS = true;
PLOT_CUBE = true;
CUBE_SIZE_RATIO = 0.5; 
% This align the orientation plot (UP, FRONT, RIGHT) to axis (X,Y,Z), for a better comparison with the device position
ADJUST_PLOT_VIEW = true;  
% this force a orientation aligned with the axis, used only for personal debug purposes
FORCE_DEFAULT_ORIENTATION = false;

o = struct(); %declare orientation
vUpFront = struct(); %declare up + front

if FORCE_DEFAULT_ORIENTATION
    o.vUp.X = 0; o.vUp.Y = 0; o.vUp.Z = 1;
    o.vFront.X = 0; o.vFront.Y = 1; o.vFront.Z = 0;
    o.vRight.X = 1; o.vRight.Y = 0; o.vRight.Z = 0;
else 
    % initialize measured UP vector (vehicle not moving)
    vUp = struct();
    vUp.X = 800;
    vUp.Y = 1000;
    vUp.Z = 300;

    % initialize measured UP_FRONT vector (vehicle acceleration in front direction)
    vUpFront.X = 500;
    vUpFront.Y = 1000;
    vUpFront.Z = 1000;

    % find orientation
    o = vectorsMath.findOrientation(vUp, vUpFront);
end

if LOG_ORIENTATION
    disp('orientation:');
    disp(o.vUp);
    disp(o.vFront);
    disp(o.vRight);
end

% initialize ANY mesuared acceleration vector
vG = struct();
vG.X = 500;
vG.Y = 1000;
vG.Z = -1000;

% find vector components of acceleration for each direction in the orientation
gvComponents = vectorsMath.findVectorComponentsInTheOrientation(vG, o);

if LOG_ACCELERATION_COMPONENTS
    disp('acceleration components:');
    disp(gvComponents.vUp);
    disp(gvComponents.vFront);
    disp(gvComponents.vRight);
end

% find vector magnitude of acceleration for each direction in the orientation
g = vectorsMath.findVectorsMagnitudeInTheOrientation(vG, o);

if LOG_ACCELERATION_MAGNITUDES
    disp('acceleration magnitudes:');
    disp(g);
end


%******************* PLOT ******************* PLOT ******************* PLOT *****************
% Before plotting, we convert all vectors to unit vectors, for better scaling
o.vUp = vectorsMath.unitVector(o.vUp);
o.vFront = vectorsMath.unitVector(o.vFront);
o.vRight = vectorsMath.unitVector(o.vRight);
vG = vectorsMath.unitVector(vG);
gvComponents.vUp = vectorsMath.unitVector(gvComponents.vUp);
gvComponents.vFront = vectorsMath.unitVector(gvComponents.vFront);
gvComponents.vRight = vectorsMath.unitVector(gvComponents.vRight);
if FORCE_DEFAULT_ORIENTATION == false
    vUpFront = vectorsMath.unitVector(vUpFront);
end

viewPlot.config(true);
plottedObjects = hggroup; % group plotted objects in one single handle, so we can manipulate all at once

if PLOT_ORIENTATION
    % plot 3D orientation, and save its object handler
    plottedObjects(1) = viewPlot.plotVectorToMatlabFormat(o.vUp, 'b-^', 1); % PLOT vUp direction
    plottedObjects(2) = viewPlot.plotVectorToMatlabFormat(o.vFront, 'g-^', 1); % PLOT vFront direction
    plottedObjects(3) = viewPlot.plotVectorToMatlabFormat(o.vRight, 'r-^', 1); % PLOT vRight direction
end

if PLOT_UP_FRONT
    viewPlot.plotVectorToMatlabFormat(vUpFront, 'y-^', 2); % PLOT vUpFront direction
end

if PLOT_CUBE
    % plot 3D cube, and save its object handler
    plottedObjects(4) = viewPlot.plotCube(CUBE_SIZE_RATIO);
end

if PLOT_ACCELERATION_AND_COMPONENTS
    % plot 3D acceleration, and save its object handler
    plottedObjects(5) = viewPlot.plotVectorToMatlabFormat(vG, 'k-^', 2); % PLOT mesuared acceleration vector
    plottedObjects(6) = viewPlot.plotVectorToMatlabFormat(gvComponents.vUp, 'k--^', 2); % PLOT vUp component of acceleration vector
    plottedObjects(7) = viewPlot.plotVectorToMatlabFormat(gvComponents.vFront, 'k--^', 2); % PLOT vFront component of acceleration vector
    plottedObjects(8) = viewPlot.plotVectorToMatlabFormat(gvComponents.vRight, 'k--^', 2); % PLOT vRight component of acceleration vector
end

if (ADJUST_PLOT_VIEW && PLOT_ORIENTATION && (FORCE_DEFAULT_ORIENTATION == false)) 
    viewPlot.adjustPlotView(o, plottedObjects);
end
