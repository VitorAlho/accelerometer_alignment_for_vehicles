% initialize measured UP vector
vUp = struct();
vUp.X = 800;
vUp.Y = 1000;
vUp.Z = 300;

% initialize measured UP_FRONT vector
vUpFront = struct();
vUpFront.X = 500;
vUpFront.Y = 1000;
vUpFront.Z = 1000;

orientation = calibrateOrientation(vUp, vUpFront);

% initialize ANY mesuared acceleration vector
vG = struct();
vG.X = 500;
vG.Y = 1000;
vG.Z = -1000;

% find vector components of acceleration for each direction in the orientation
gvComponents = findVectorComponentsInTheOrientation(vG, orientation);

% find vector magnitude of acceleration for each direction in the orientation
g = fingVectorsMagnitudeInTheOrientation(vG, orientation);

plotVectors(orientation, vUpFront, vG, gvComponents);

disp(g);



function plotVectors(orientation, vUpFront, vG, gvComponents)
    PLOT_UP_FRONT = false;
    PLOT_GRAVITY_AND_COMPONENTS = true;

    % PLOT COMMANDS
    figure;hold on;
    grid on;
    xlabel('X axis (RED)'), ylabel('Y axis (GREEN)'), zlabel('Z axis (BLUE)');
    axis equal;
    origin = [0,0,0];
    %axisLimit = max([abs(accGravity.X), abs(accGravity.Y), abs(accGravity.Z)]);
    axisLimit = 2000;
    xlim([-axisLimit axisLimit]);
    ylim([-axisLimit axisLimit]);
    zlim([-axisLimit axisLimit]);
    axis();
    view(24,43);
    set(gca);
    %set(gca,'CameraPosition',[1 2 3]);
    cla;

    % PLOT AXIS
    axisVector = struct();
    axisVector.X = [1, 0, 0] * axisLimit;
    axisVector.Y = [0, 1, 0] * axisLimit;
    axisVector.Z = [0, 0, 1] * axisLimit;
    plot3([origin(1) axisVector.X(1)],[origin(2) axisVector.X(2)],[origin(3) axisVector.X(3)],'r--^', 'LineWidth',1);
    plot3([origin(1) axisVector.Y(1)],[origin(2) axisVector.Y(2)],[origin(3) axisVector.Y(3)],'g--^', 'LineWidth',1);
    plot3([origin(1) axisVector.Z(1)],[origin(2) axisVector.Z(2)],[origin(3) axisVector.Z(3)],'b--^', 'LineWidth',1);

    % PLOT vUp direction
    plot3([origin(1) orientation.vUp.X],[origin(2) orientation.vUp.Y],[origin(3) orientation.vUp.Z],'m-^', 'LineWidth',2);
    % PLOT vFront direction
    plot3([origin(1) orientation.vFront.X],[origin(2) orientation.vFront.Y],[origin(3) orientation.vFront.Z],'c-^', 'LineWidth',2);
    % PLOT vRight direction
    plot3([origin(1) orientation.vRight.X],[origin(2) orientation.vRight.Y],[origin(3) orientation.vRight.Z],'r-^', 'LineWidth',2);

    if PLOT_UP_FRONT
        %PLOT vUpFront
        plot3([origin(1) vUpFront.X],[origin(2) vUpFront.Y],[origin(3) vUpFront.Z],'y-^', 'LineWidth',2);
    end

    if PLOT_GRAVITY_AND_COMPONENTS
        % PLOT mesuared gravity vector
        plot3([origin(1) vG.X],[origin(2) vG.Y],[origin(3) vG.Z],'k-^', 'LineWidth',4);
        % PLOT vUp component of gravity vector
        plot3([origin(1) gvComponents.vUp.X],[origin(2) gvComponents.vUp.Y],[origin(3) gvComponents.vUp.Z],'k--^', 'LineWidth',2);
        % PLOT vFront component of gravity vector
        plot3([origin(1) gvComponents.vFront.X],[origin(2) gvComponents.vFront.Y],[origin(3) gvComponents.vFront.Z],'k--^', 'LineWidth',2);
        % PLOT vRight component of gravity vector
        plot3([origin(1) gvComponents.vRight.X],[origin(2) gvComponents.vRight.Y],[origin(3) gvComponents.vRight.Z],'k--^', 'LineWidth',2);
    end
end

function res = calibrateOrientation(vUp, vUpFront)
    % find FRONT and RIGHT  vectors
    vFront = rotateVectorThroughAnotherVector(vUp, vUpFront, 90);
    vRight = rotateVectorAroundAnotherVector(vUp, vFront, 90);
    
    orientation = struct();
    orientation.vUp = vUp;
    orientation.vFront = vFront;
    orientation.vRight = vRight;
    
    res = orientation;
end

function res = findVectorComponentsInTheOrientation(vG, orientation)
    % find vector components of measuread gravity for each direction
    gvComponents = struct();
    gvComponents.vUp = vectorComponentParallelToAnotherVector(vG, orientation.vUp);
    gvComponents.vFront = vectorComponentParallelToAnotherVector(vG, orientation.vFront);
    gvComponents.vRight = vectorComponentParallelToAnotherVector(vG, orientation.vRight);
    
    res = gvComponents;
end

function res = fingVectorsMagnitudeInTheOrientation(vG, orientation)
    gvComponents = findVectorComponentsInTheOrientation(vG, orientation);
    
    % find acceleration magnitude for each direction
    g = struct();
    g.UP = vectorMagnitude(gvComponents.vUp);
    g.FRONT = vectorMagnitude(gvComponents.vFront);
    g.RIGHT = vectorMagnitude(gvComponents.vRight);

    if (isVectorsInOppositeDirection(orientation.vUp, gvComponents.vUp))
        g.UP = -g.UP; % DOWN
    end
    if (isVectorsInOppositeDirection(orientation.vFront, gvComponents.vFront))
        g.FRONT = -g.FRONT; % BACK
    end
    if (isVectorsInOppositeDirection(orientation.vRight, gvComponents.vRight))
        g.RIGHT = -g.RIGHT; % LEFT
    end
    
    res = g;
end

function res = isVectorsInOppositeDirection(v1, v2)
    res = dotProduct(v1, v2) < 0;
end

function res = angleBetweenVectors(v1, v2)
    U = [v1.X v1.Y v1.Z];
    V = [v2.X v2.Y v2.Z];
    CosTheta = max(min(dot(U,V)/(norm(U)*norm(V)),1),-1);
    ThetaInDegrees = real(acosd(CosTheta));
    res = ThetaInDegrees;
end

function res = vectorMagnitude(v)
    res = sqrt(v.X^2 + v.Y^2 + v.Z^2);
end

function res = unitVector(v)
    vm = vectorMagnitude(v);

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
    e1 = unitVector(v1);

    % Now it's simple to find c1 using the dot product:
    c1 = dotProduct(v2, e1);

    % Let u2 = c2e2 = v2−c1e1; then
    u2 = struct();
    u2.X = v2.X - c1*e1.X;
    u2.Y = v2.Y - c1*e1.Y;
    u2.Z = v2.Z - c1*e1.Z;

    %  Then we set e2 to the unit vector in the same direction as u2.
    e2 = unitVector(u2);

    % To rotate v1 toward v2 by some other angle ϕ, just compute rotϕv1=(∥v1∥cosϕ)e1+(∥v1∥sinϕ)e2.
    v1_m = vectorMagnitude(v1);
    radians = angle*(pi/180);

    rotV1 = struct();
    rotV1.X = (v1_m * cos(radians)) * e1.X + (v1_m * sin(radians)) * e2.X;
    rotV1.Y = (v1_m * cos(radians)) * e1.Y + (v1_m * sin(radians)) * e2.Y;
    rotV1.Z = (v1_m * cos(radians)) * e1.Z + (v1_m * sin(radians)) * e2.Z;

    res = rotV1;
end

function res = vectorComponentParallelToAnotherVector(v1, v2)
    %Project v1 onto v2. Result will be parallel to v2
    aux = dotProduct(v1, v2) / dotProduct(v2 , v2);
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
    parallel = vectorComponentParallelToAnotherVector(v1, v2);
    perpendicular = subtractVectors(v1, parallel);
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

    paralelToV2 = vectorComponentParallelToAnotherVector(v1, v2);

    perpendicularToV2 = subtractVectors(v1, paralelToV2);

    w = crossProduct(v2, perpendicularToV2);

    v = struct();
    v.X = paralelToV2.X + perpendicularToV2.X * cos(radians) + vectorMagnitude(perpendicularToV2) * (w.X / vectorMagnitude(w)) * sin(radians);
    v.Y = paralelToV2.Y + perpendicularToV2.Y * cos(radians) + vectorMagnitude(perpendicularToV2) * (w.Y / vectorMagnitude(w)) * sin(radians);
    v.Z = paralelToV2.Z + perpendicularToV2.Z * cos(radians) + vectorMagnitude(perpendicularToV2) * (w.Z / vectorMagnitude(w)) * sin(radians);

    res = v;
end
