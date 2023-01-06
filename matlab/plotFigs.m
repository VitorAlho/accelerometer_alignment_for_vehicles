plotFigure1();
plotFigure2();
plotFigure3();
plotFigure4();
plotFigure5();
plotFigure6();
plotFigure7();

function plotVerticalSamples()
    plot3([0 200],[0 100],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 -200],[0 -100],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 150],[0 -150],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 -300],[0 140],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 -290],[0 -240],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 290],[0 240],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 190],[0 140],[0 1000], 'b--^', 'LineWidth',1);
    plot3([0 -190],[0 -140],[0 1000], 'b--^', 'LineWidth',1);
end

function object = plotVerticalAverage(visible)
    vVertical = struct();
    vVertical.X = (200-200+150-300-290+290+190-190)/8;
    vVertical.Y = (100-100-150+140-240+240+140-140)/8;
    vVertical.Z = 1000;
    if(visible)
        viewPlot.plotVectorToMatlabFormat(vVertical, 'b-^',2, "vertical vector");
    end
    object = vVertical;
end

function plotAccOrBreakSamples()
    plot3([0 200],[0 500],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 -200],[0 400],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 150],[0 350],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 -300],[0 400],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 -290],[0 500],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 290],[0 370],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 190],[0 240],[0 1000], 'm--^', 'LineWidth',1);
    plot3([0 -190],[0 420],[0 1000], 'm--^', 'LineWidth',1);
end

function vector = plotAccOrBreakAverage(visible)
    vAccBreak = struct();
    vAccBreak.X = (200-200+150-300-290+290+190-190)/8;
    vAccBreak.Y = (500+400+350+400+500+370+240+420)/8;
    vAccBreak.Z = 1000;
    if(visible)
        viewPlot.plotVectorToMatlabFormat(vAccBreak, 'm-^',3, 'acceleration/breaking vector');
    end
    vector = vAccBreak;
end

function plotForwardPossibilities(vVertical)
    vForward = struct();
    vForward.X = 0;
    vForward.Y = 1000;
    vForward.Z = 0;
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 0), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 20), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 40), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 60), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 80), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 100), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 120), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 140), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 160), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, 180), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -20), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -40), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -60), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -80), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -100), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -120), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -140), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -160), 'k--^', 1, "");
    viewPlot.plotVectorToMatlabFormat(vectorsMath.rotateVectorAroundAnotherVector(vForward, vVertical, -180), 'k--^', 1, "");
end

function plotRange()
    hold on
    r = [0 300];
    [X,Y,Z] = cylinder(r);
    h = 1000;
    Z = Z*h;
    surf(X,Y,Z, 'FaceColor', 'y');
    alpha 0.5
    hold off
end

function plotGforceAndComponents(orientation)
    % initialize ANY mesuared acceleration vector
    gForce = struct();
    gForce.X = -700; %adjustment for cube plot
    gForce.Y = 600;
    gForce.Z = 750;
    viewPlot.plotVectorToMatlabFormat(gForce, 'k--^', 2, "measured G-force vector");
    
    % find vector components for the given orientation
    gForceComponents = vectorsMath.findVectorComponentsInTheOrientation(gForce, orientation);
    viewPlot.plotVectorToMatlabFormat(gForceComponents.vVertical, 'k--o', 2, "vertical component of G-force");
    viewPlot.plotVectorToMatlabFormat(gForceComponents.vForward, 'k--square', 2, "forward component of G-force");
    viewPlot.plotVectorToMatlabFormat(gForceComponents.vLateral, 'k--diamond', 2, "lateral component of G-force");

    % find vector magnitude of acceleration for each direction in the orientation
    gForceMagnitudes = vectorsMath.findVectorsMagnitudeInTheOrientation(gForce, orientation);
    plot3([-gForceMagnitudes.vMagnitudes.LATERAL -gForceMagnitudes.vMagnitudes.LATERAL],[gForceMagnitudes.vMagnitudes.FORWARD gForceMagnitudes.vMagnitudes.FORWARD],[gForceMagnitudes.vMagnitudes.VERTICAL 0], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);
    plot3([0 -gForceMagnitudes.vMagnitudes.LATERAL],[gForceMagnitudes.vMagnitudes.FORWARD gForceMagnitudes.vMagnitudes.FORWARD],[0 0], '--', 'Color',[0.5,0.5,0.5],  'LineWidth',1);
    plot3([-gForceMagnitudes.vMagnitudes.LATERAL -gForceMagnitudes.vMagnitudes.LATERAL],[0 gForceMagnitudes.vMagnitudes.FORWARD],[0 0], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);
    plot3([0 0],[gForceMagnitudes.vMagnitudes.FORWARD gForceMagnitudes.vMagnitudes.FORWARD],[gForceMagnitudes.vMagnitudes.VERTICAL 0], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);
    plot3([-gForceMagnitudes.vMagnitudes.LATERAL -gForceMagnitudes.vMagnitudes.LATERAL],[0 0],[gForceMagnitudes.vMagnitudes.VERTICAL 0], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);
    plot3([0 -gForceMagnitudes.vMagnitudes.LATERAL],[gForceMagnitudes.vMagnitudes.FORWARD gForceMagnitudes.vMagnitudes.FORWARD],[gForceMagnitudes.vMagnitudes.VERTICAL gForceMagnitudes.vMagnitudes.VERTICAL], '--', 'Color',[0.5,0.5,0.5],  'LineWidth',1);
    plot3([-gForceMagnitudes.vMagnitudes.LATERAL -gForceMagnitudes.vMagnitudes.LATERAL],[0 gForceMagnitudes.vMagnitudes.FORWARD],[gForceMagnitudes.vMagnitudes.VERTICAL gForceMagnitudes.vMagnitudes.VERTICAL], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);
    plot3([0 -gForceMagnitudes.vMagnitudes.LATERAL],[0 0],[gForceMagnitudes.vMagnitudes.VERTICAL gForceMagnitudes.vMagnitudes.VERTICAL], '--', 'Color',[0.5,0.5,0.5],  'LineWidth',1);
    plot3([0 0],[0 gForceMagnitudes.vMagnitudes.FORWARD],[gForceMagnitudes.vMagnitudes.VERTICAL gForceMagnitudes.vMagnitudes.VERTICAL], '--', 'Color',[0.5,0.5,0.5], 'LineWidth',1);

end

function plotFigures(enableVerticaSamples, enableVerticalAverage, enableAccOrBreakSamples, enableAccOrBreakAvg, enableForwardPossibilites, enableForward, enableLateral, enableRange, enableGforce)
    viewPlot.init(false);
    
    if(enableVerticaSamples)
        plotVerticalSamples();
    end
    
    vVertical = plotVerticalAverage(enableVerticalAverage);
    
    if(enableAccOrBreakSamples)
        plotAccOrBreakSamples();
    end
    
    vAccBreak = plotAccOrBreakAverage(enableAccOrBreakAvg);
    
    if(enableForwardPossibilites)
        plotForwardPossibilities(vVertical);
    end
    
    o = vectorsMath.findOrientation(vVertical, vAccBreak);
    if(enableForward)
        viewPlot.plotVectorToMatlabFormat(o.vForward, 'g-^',2, "forward vector");
    end
    if(enableLateral)
        viewPlot.plotVectorToMatlabFormat(o.vLateral, 'r-^',2, "lateral vector");
    end
    
    if(enableRange)
        plotRange();
    end
    
    if(enableGforce)
        plotGforceAndComponents(o);
    end
end

function plotFigure1()
   plotFigures(true, true, false, false, false, false, false, false, false);
end

function plotFigure2()
    plotFigures(false, false, true, true, false, false, false, false, false);
end

function plotFigure3()
    plotFigures(false, true, false, false, true, false, false, false, false);
end

function plotFigure4()
    plotFigures(false, true, false, true, true, true, false, false, false);
end

function plotFigure5()
    plotFigures(false, true, false, false, false, true, true, false, false);
end

function plotFigure6()
    plotFigures(true, true, false, false, false, false, false, true, false);
end

function plotFigure7()
    plotFigures(false, true, false, false, false, true, true, false, true);   
end
    