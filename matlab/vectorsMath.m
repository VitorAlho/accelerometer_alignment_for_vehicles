classdef vectorsMath
    properties (Constant)
        LOG_ORIENTATION = true; % LOG orientation vectors (UP, FRONT, RIGHT)
        LOG_ACCELERATION_COMPONENTS = true; % LOG the compontens of any given acceleration, align in the orientation
        LOG_ACCELERATION_MAGNITUDES = true; % Log the magnitude of the components
        
        unitVectorX = [1 0 0] * -1;
        unitVectorY = [0 1 0];
        unitVectorZ = [0 0 1];
    end
    methods (Static)
        function res = findOrientation(vUp, vUpFront)
            % find FRONT and RIGHT  vectors
            vFront = vectorsMath.rotateVectorThroughAnotherVector(vUp, vUpFront, 90);
            vRight = vectorsMath.rotateVectorAroundAnotherVector(vUp, vFront, -90);

            o = struct();
            o.vUp = vUp;
            o.vFront = vFront;
            o.vRight = vRight;
            
            if vectorsMath.LOG_ORIENTATION
                disp('orientation:'); 
                disp(['vUp: [',num2str(o.vUp.X),' ',num2str(o.vUp.Y),' ',num2str(o.vUp.Z),']']);
                disp(['vFront: [',num2str(o.vFront.X),' ',num2str(o.vFront.Y),' ',num2str(o.vFront.Z),']']);
                disp(['vRight: [',num2str(o.vRight.X),' ',num2str(o.vRight.Y),' ',num2str(o.vRight.Z),']']);
            end

            res = o;
        end

        function res = findVectorComponentsInTheOrientation(vG, orientation)
            % find vector components of measuread gravity for each direction
            gvComponents = struct();
            gvComponents.vUp = vectorsMath.vectorComponentParallelToAnotherVector(vG, orientation.vUp);
            gvComponents.vFront = vectorsMath.vectorComponentParallelToAnotherVector(vG, orientation.vFront);
            gvComponents.vRight = vectorsMath.vectorComponentParallelToAnotherVector(vG, orientation.vRight);
            
            res = gvComponents;
        end

        function res = findVectorsMagnitudeInTheOrientation(v, orientation)
            vComponents = vectorsMath.findVectorComponentsInTheOrientation(v, orientation);
            
            vMagnitudes = struct();
            vMagnitudes.UP = vectorsMath.vectorMagnitude(vComponents.vUp);
            vMagnitudes.FRONT = vectorsMath.vectorMagnitude(vComponents.vFront);
            vMagnitudes.RIGHT = vectorsMath.vectorMagnitude(vComponents.vRight);

            if (vectorsMath.isVectorsInOppositeDirection(orientation.vUp, vComponents.vUp))
                vMagnitudes.UP = -vMagnitudes.UP; % DOWN
            end
            if (vectorsMath.isVectorsInOppositeDirection(orientation.vFront, vComponents.vFront))
                vMagnitudes.FRONT = -vMagnitudes.FRONT; % BACK
            end
            if (vectorsMath.isVectorsInOppositeDirection(orientation.vRight, vComponents.vRight))
                vMagnitudes.RIGHT = -vMagnitudes.RIGHT; % LEFT
            end
            
            % find acceleration componentes and magnitude for each direction
            g = struct();
            g.vComponents = vComponents;
            g.vMagnitudes = vMagnitudes;
            
            if vectorsMath.LOG_ACCELERATION_COMPONENTS
                c = vComponents;
                disp('components:'); 
                disp(['vUp: [',num2str(c.vUp.X),' ',num2str(c.vUp.Y),' ',num2str(c.vUp.Z),']']);
                disp(['vFront: [',num2str(c.vFront.X),' ',num2str(c.vFront.Y),' ',num2str(c.vFront.Z),']']);
                disp(['vRight: [',num2str(c.vRight.X),' ',num2str(c.vRight.Y),' ',num2str(c.vRight.Z),']']);
            end
            
            if vectorsMath.LOG_ACCELERATION_MAGNITUDES
                disp(['magnitudes -> ', 'up: ', num2str(vMagnitudes.UP), ', front: ',num2str(vMagnitudes.FRONT), ', right: ',num2str(vMagnitudes.RIGHT)]); 
            end

            res = g;
        end

        function res = isVectorsInOppositeDirection(v1, v2)
            res = vectorsMath.dotProduct(v1, v2) < 0;
        end

        function res = angleBetweenVectors(v1, v2)
            U = [v1.X v1.Y v1.Z];
            V = [v2.X v2.Y v2.Z];
            CosTheta = max(min(dot(U,V)/(norm(U)*norm(V)),1),-1);
            ThetaInDegrees = real(acosd(CosTheta));
            res = ThetaInDegrees;
        end
        
        function res = angleBetweenVectorsMatlabFormat(U, V)
            CosTheta = max(min(dot(U,V)/(norm(U)*norm(V)),1),-1);
            ThetaInDegrees = real(acosd(CosTheta));
            res = ThetaInDegrees;
        end

        function res = vectorMagnitude(v)
            res = sqrt(v.X^2 + v.Y^2 + v.Z^2);
        end

        function res = unitVector(v)
            vm = vectorsMath.vectorMagnitude(v);

            e = struct();
            e.X = v.X / vm;
            e.Y = v.Y / vm;
            e.Z = v.Z / vm;
            res = e;
        end

        function res = dotProduct(v1, v2)
            res = v1.X*v2.X + v1.Y*v2.Y + v1.Z*v2.Z;
        end

        function res = rotateVectorThroughAnotherVector(v1, v2, angle)
            % How to rotate a vector through another vector in the same direction
            % https://math.stackexchange.com/questions/4386389/how-to-rotate-a-vector-through-another-vector-in-the-same-direction

            % First we set e1 to the unit vector in the same direction as v1:
            e1 = vectorsMath.unitVector(v1);

            % Now it's simple to find c1 using the dot product:
            c1 = vectorsMath.dotProduct(v2, e1);

            % Let u2 = c2e2 = v2−c1e1; then
            u2 = struct();
            u2.X = v2.X - c1*e1.X;
            u2.Y = v2.Y - c1*e1.Y;
            u2.Z = v2.Z - c1*e1.Z;

            %  Then we set e2 to the unit vector in the same direction as u2.
            e2 = vectorsMath.unitVector(u2);

            % To rotate v1 toward v2 by some other angle ϕ, just compute rotϕv1=(∥v1∥cosϕ)e1+(∥v1∥sinϕ)e2.
            v1_m = vectorsMath.vectorMagnitude(v1);
            radians = angle*(pi/180);

            rotV1 = struct();
            rotV1.X = (v1_m * cos(radians)) * e1.X + (v1_m * sin(radians)) * e2.X;
            rotV1.Y = (v1_m * cos(radians)) * e1.Y + (v1_m * sin(radians)) * e2.Y;
            rotV1.Z = (v1_m * cos(radians)) * e1.Z + (v1_m * sin(radians)) * e2.Z;

            res = rotV1;
        end

        function res = vectorComponentParallelToAnotherVector(v1, v2)
            %Project v1 onto v2. Result will be parallel to v2
            aux = vectorsMath.dotProduct(v1, v2) / vectorsMath.dotProduct(v2 , v2);
            parallel = struct();
            parallel.X = aux * v2.X;
            parallel.Y = aux * v2.Y;
            parallel.Z = aux * v2.Z;
            res = parallel;
        end

        function res = subtractVectors(v1, v2)
            v = struct();
            v.X = v1.X - v2.X;
            v.Y = v1.Y - v2.Y;
            v.Z = v1.Z - v2.Z;
            res = v;
        end

        function res = sumVectors(v1, v2)
            v = struct();
            v.X = v1.X + v2.X;
            v.Y = v1.Y + v2.Y;
            v.Z = v1.Z + v2.Z;
            res = v;
        end

        function res = multiplyVector(v1, c)
            v = struct();
            v.X = v1.X * c;
            v.Y = v1.Y * c;
            v.Z = v1.Z * c;
            res = v;
        end

        function res = divideVector(v1, c)
            v = struct();
            v.X = v1.X / c;
            v.Y = v1.Y / c;
            v.Z = v1.Z / c;
            res = v;
        end

        function res = vectorComponentOrthogonalToAnotherVector(v1, v2)
            %Component of v1 orthogonal to v2. Result is perpendicular to v2
            parallel = vectorsMath.vectorComponentParallelToAnotherVector(v1, v2);
            perpendicular = vectorsMath.subtractVectors(v1, parallel);
            res = perpendicular;
        end

        function res = crossProduct(v1, v2)
            % The cross product between two 3-D vectors produces a new vector that is perpendicular to both.
            % https://www.mathworks.com/help/matlab/ref/cross.html#bt9u2fz-5
            v = struct();
            v.X = v1.Y*v2.Z - v1.Z*v2.Y;
            v.Y = v1.Z*v2.X - v1.X*v2.Z;
            v.Z = v1.X*v2.Y - v1.Y*v2.X;
            res = v;
        end

        function res = rotateVectorAroundAnotherVector(v1, v2, angle)
            % How to rotate a vector around another vector
            % https://math.stackexchange.com/questions/511370/how-to-rotate-one-vector-about-another
            % https://gist.github.com/fasiha/6c331b158d4c40509bd180c5e64f7924#file-rotatevectors-py-L35-L42

            radians = angle*(pi/180);

            paralelToV2 = vectorsMath.vectorComponentParallelToAnotherVector(v1, v2);

            perpendicularToV2 = vectorsMath.subtractVectors(v1, paralelToV2);

            w = vectorsMath.crossProduct(v2, perpendicularToV2);

            v = struct();
            v.X = paralelToV2.X + perpendicularToV2.X * cos(radians) + vectorsMath.vectorMagnitude(perpendicularToV2) * (w.X / vectorsMath.vectorMagnitude(w)) * sin(radians);
            v.Y = paralelToV2.Y + perpendicularToV2.Y * cos(radians) + vectorsMath.vectorMagnitude(perpendicularToV2) * (w.Y / vectorsMath.vectorMagnitude(w)) * sin(radians);
            v.Z = paralelToV2.Z + perpendicularToV2.Z * cos(radians) + vectorsMath.vectorMagnitude(perpendicularToV2) * (w.Z / vectorsMath.vectorMagnitude(w)) * sin(radians);

            res = v;
        end
        
        function res = vectorToMatlabFormat(v)
            res = [v.X v.Y v.Z];
        end
        
        function res = vectorToStructFormat(v)
            V = struct();
            V.X = v(1);
            V.Y = v(2);
            V.Z = v(3);
            res = V;
        end
        
        function res = getAzimuthAndElevationBetweenVectors(v1, v2)
            % https://stackoverflow.com/questions/55507493/how-to-get-azimuth-and-elevation-from-enu-vectors
            vAux = v1 - v2;
            
            azimuth = atan(vAux(1)/vAux(2));
            elevation = atan(vAux(3)/vAux(2));
            
            data = struct();
            data.azimuth = azimuth * (180/pi); %rotation about Z
            data.elevation = elevation * (180/pi); %rotation about Y
            
            res = data;
        end
    end
end