% this force a orientation aligned with the axis, used only for personal debug purposes
FORCE_DEFAULT_ORIENTATION = false;

plotAccConfig = struct();
plotAccConfig.PLOT_ORIENTATION = true;
plotAccConfig.PLOT_VERTICAL_FORWARD = false;
plotAccConfig.PLOT_ACCELERATION_AND_COMPONENTS = false;
plotAccConfig.PLOT_CUBE = true;
plotAccConfig.CUBE_SIZE_RATIO = 1; 
% for a better VISUAL comparison with the device position, this align the orientation (VERTICAL,FORWARD,LATERAL) to axis (X,Y,Z)
plotAccConfig.ADJUST_PLOT_VIEW = true;  

o = struct(); %declare orientation
vVerticalForward = struct(); %declare vertical + forward

if FORCE_DEFAULT_ORIENTATION
    o.vVertical = vectorsMath.vectorToStructFormat([0, 0, 1]);
    o.vForward = vectorsMath.vectorToStructFormat([0, 1, 0]);
    o.vLateral = vectorsMath.vectorToStructFormat([1, 0, 0]);
else
    
    % initialize measured VERTICAL vector (vehicle not moving)
    vVertical = vectorsMath.vectorToStructFormat([16, -23, 978]);

    % initialize measured VERTICAL_FORWARD vector (vehicle acceleration in forward direction)
    vVerticalForward = vectorsMath.vectorToStructFormat([-69, -340, 885]);
    
    % find orientation
    o = vectorsMath.findOrientation(vVertical, vVerticalForward);
end

% initialize ANY mesuared acceleration vector
vAcc = struct();
vAcc.X = 500 * 1; %adjustment for cube plot
vAcc.Y = 600;
vAcc.Z = 400;


% find vector components for the given orientation
accComponents = vectorsMath.findVectorComponentsInTheOrientation(vAcc, o);

% find vector magnitude of acceleration for each direction in the orientation
accMagnitudes = vectorsMath.findVectorsMagnitudeInTheOrientation(vAcc, o);


%******************* PLOT ******************* PLOT ******************* PLOT *****************
if(viewPlot.axisLimit == 1)
    % Before plotting, we convert all vectors to unit vectors, for better scaling
    o.vVertical = vectorsMath.unitVector(o.vVertical);
    o.vForward = vectorsMath.unitVector(o.vForward);
    o.vLateral = vectorsMath.unitVector(o.vLateral);
    vAcc = vectorsMath.unitVector(vAcc);
    accComponents.vVertical = vectorsMath.unitVector(accComponents.vVertical);
    accComponents.vForward = vectorsMath.unitVector(accComponents.vForward);
    accComponents.vLateral = vectorsMath.unitVector(accComponents.vLateral);
    
    if FORCE_DEFAULT_ORIENTATION == false
        vVerticalForward = vectorsMath.unitVector(vVerticalForward);
    end
end

viewPlot.init(true);
viewPlot.plotAccComponentsForAGivenOrientation(plotAccConfig, o, vAcc, accComponents);


