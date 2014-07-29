function [d] = Posture_Analysis(d, type_string, subj_string)
%Analysis of the posture angle and its time variability.

%DEFINE SAMPLING RATE
sampling_rate = 30;

%Distance Conversion
dist_conv = 4.13/634;

for iii = 1:length(type_string)
    for ii=1:length(subj_string)
        
        data = d.(type_string{iii}).(subj_string{ii}).Raw_Data;
        
        %Posture: Angle between Spine - Shoulder_center
        %S = Spine;
        %SC = Shoulder_Center;
        %inverse tangent[(SC.X-S.X)/(SC.Y-S.Y)];
    end
end

end