classdef viewPlot
    properties (Constant)
        axisLimit = 1000;
    end
    methods (Static)
        function init(showAxis)
            axisLimit = viewPlot.axisLimit;
            
            figure;
            hold on;
            grid on;
            xlabel('X axis (RED)'), ylabel('Y axis (GREEN)'), zlabel('Z axis (BLUE)');
            axis equal;
            %axisLimit = max([abs(accGravity.X), abs(accGravity.Y), abs(accGravity.Z)]);
            xlim([-axisLimit axisLimit]);
            ylim([-axisLimit axisLimit]);
            zlim([-axisLimit axisLimit]);
            
            azimuth = 0;
            elevation = 0;
            view(azimuth,elevation);
            
            if showAxis
                viewPlot.plotAxis();
            end
        end
        
        function plotAxis()
            axisLimit = viewPlot.axisLimit;
       
             % PLOT AXIS
            axisVector = struct();
            axisVector.X = vectorsMath.unitVectorX * axisLimit;
            axisVector.Y = vectorsMath.unitVectorY * axisLimit;
            axisVector.Z = vectorsMath.unitVectorZ * axisLimit;
            viewPlot.plotVector(axisVector.X, 'r--^', 2);
            viewPlot.plotVector(axisVector.Y, 'g--^', 2);
            viewPlot.plotVector(axisVector.Z, 'b--^', 2);
        end
        
        function object = plotVector(v, style, lineWidth)
            object = plot3([0 v(1)],[0 v(2)],[0 v(3)], style, 'LineWidth',lineWidth);
        end
        
        function object = plotVectorToMatlabFormat(v, style, lineWidth)
            mv = vectorsMath.vectorToMatlabFormat(v);
            object = viewPlot.plotVector(mv, style, lineWidth);
        end
             
        % sizeRatio em camparação com o valor da variavel axisLimit
        function object = plotCube(sizeRatio)
            axisLimit = viewPlot.axisLimit;
            
            %cube vertices with origin at [0 0 0]
            vert = [0 0 0;1 0 0;1 1 0;0 1 0;0 0 1;1 0 1;1 1 1;0 1 1];
            %setting cube size to axis limits
            vert = vert * axisLimit;
            %center cube by moving its origin to [-axisLimit/2 -axisLimit/2 -axisLimit/2]
            vert = vert - axisLimit/2;
            %adjust size to specifiend sizeRatio
            vert = vert * sizeRatio;
            %setting cube height to half, so it looks like a rectangle
            vert = vert .* [1 1 0.4];
            
            %group vertices combination to form the 6 faces of the cube
            fac = [1 2 6 5;2 3 7 6;3 4 8 7;4 1 5 8;1 2 3 4;5 6 7 8];
            %plot 
            p = patch('Vertices',vert,'Faces',fac,'FaceVertexCData',hsv(6),'FaceColor','flat');
            %transparency
            %p.FaceVertexAlphaData = 0.5;
            %p.FaceAlpha = 'flat';
            
            object = p;
        end
        
        function plotAccComponentsForAGivenOrientation (configs, orientation, acc, accComponents)
            plottedObjects = hggroup; % group plotted objects in one single handle, so we can manipulate all at once

            if configs.PLOT_ORIENTATION
                % plot 3D orientation, and save its object handler
                plottedObjects(1) = viewPlot.plotVectorToMatlabFormat(orientation.vUp, 'b-^', 1); % PLOT vUp direction
                plottedObjects(2) = viewPlot.plotVectorToMatlabFormat(orientation.vFront, 'g-^', 1); % PLOT vFront direction
                plottedObjects(3) = viewPlot.plotVectorToMatlabFormat(orientation.vRight, 'r-^', 1); % PLOT vRight direction
            end

            if configs.PLOT_UP_FRONT
                %viewPlot.plotVectorToMatlabFormat(vUpFront, 'y-^', 2); % PLOT vUpFront direction
            end

            if configs.PLOT_CUBE
                % plot 3D cube, and save its object handler
                plottedObjects(4) = viewPlot.plotCube(configs.CUBE_SIZE_RATIO);
            end

            if configs.PLOT_ACCELERATION_AND_COMPONENTS
                % plot 3D acceleration, and save its object handler
                plottedObjects(5) = viewPlot.plotVectorToMatlabFormat(acc, 'k-^', 2); % PLOT mesuared acceleration vector
                plottedObjects(6) = viewPlot.plotVectorToMatlabFormat(accComponents.vUp, 'k--^', 2); % PLOT vUp component of acceleration vector
                plottedObjects(7) = viewPlot.plotVectorToMatlabFormat(accComponents.vFront, 'k--^', 2); % PLOT vFront component of acceleration vector
                plottedObjects(8) = viewPlot.plotVectorToMatlabFormat(accComponents.vRight, 'k--^', 2); % PLOT vRight component of acceleration vector
            end

            if (configs.ADJUST_PLOT_VIEW && configs.PLOT_ORIENTATION) 
                viewPlot.adjustPlotView(orientation, plottedObjects);
            end 
        end
        
        function adjustPlotView(orientation, plottedObjects)
            cateto = orientation.vUp.Z;
            catetoOposto = orientation.vUp.Y;
            hipotenusa = sqrt(cateto^2 + catetoOposto^2);
            theta = acos(cateto/hipotenusa);
            angleRotationAboutX = theta * (180/pi);
            if(orientation.vUp.Y > 0)
                angleRotationAboutX = -angleRotationAboutX;
            end
            %disp('angleRotationAboutX:');
            %disp(angleRotationAboutX);
            
            %update plot by rotating objects along X axis
            rotate(plottedObjects, vectorsMath.unitVectorX, angleRotationAboutX);
            
            
            ObjUpRotated = plottedObjects(1);
            vUpRotated = [ObjUpRotated.XData(2) ObjUpRotated.YData(2) ObjUpRotated.ZData(2)];
            angleRotationAboutY = vectorsMath.angleBetweenVectorsMatlabFormat(vUpRotated, vectorsMath.unitVectorZ);
            if(vUpRotated(1) > 0) %se estiver no lado positivo de X, rotaciona ao contrario
                angleRotationAboutY = -angleRotationAboutY;
            end
            %disp('angleRotationAboutY:');
            %disp(angleRotationAboutY);
            
            %update plot by rotating objects along Y axis
            rotate(plottedObjects, vectorsMath.unitVectorY, angleRotationAboutY);
 
            
            ObjFrontRotated = plottedObjects(2);
            vFrontRotated = [ObjFrontRotated.XData(2) ObjFrontRotated.YData(2) ObjFrontRotated.ZData(2)];
            angleRotationAboutZ = vectorsMath.angleBetweenVectorsMatlabFormat(vFrontRotated, vectorsMath.unitVectorY);
            if(vFrontRotated(1) > 0) %se estiver no lado positivo de X, rotaciona ao contrario
                angleRotationAboutZ = -angleRotationAboutZ;
            end
            %disp('angleRotationAboutZ:');
            %disp(angleRotationAboutZ);

            %update plot by rotating objects along Z axis
            rotate(plottedObjects, vectorsMath.unitVectorZ, -angleRotationAboutZ);
        end
    end
end


