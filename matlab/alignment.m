classdef alignment
    methods (Static)
        function run(plotConfig, vVertical, vAccOrBreaking, gForce)
            % this force a orientation aligned with the axis, used only for personal debug purposes
            FORCE_DEFAULT_ORIENTATION = false;

            o = struct(); %declare orientation

            if FORCE_DEFAULT_ORIENTATION
                o.vVertical = vectorsMath.vectorToStructFormat([0, 0, 1]);
                o.vForward = vectorsMath.vectorToStructFormat([0, 1, 0]);
                o.vLateral = vectorsMath.vectorToStructFormat([1, 0, 0]);
            else
               
                vVertical = vectorsMath.vectorToStructFormat(vVertical);

                vAccOrBreaking = vectorsMath.vectorToStructFormat(vAccOrBreaking);

                % find orientation
                o = vectorsMath.findOrientation(vVertical, vAccOrBreaking);
            end

            gForce = vectorsMath.vectorToStructFormat(gForce);

            % find vector components for the given orientation
            gForceComponents = vectorsMath.findVectorComponentsInTheOrientation(gForce, o);

            % find vector magnitude of acceleration for each direction in the orientation
            gForceMagnitudes = vectorsMath.findVectorsMagnitudeInTheOrientation(gForce, o);

            viewPlot.init(true);
            viewPlot.plotAccComponentsForAGivenOrientation(plotConfig, o, vAccOrBreaking, gForce, gForceComponents);
        end
    end
end