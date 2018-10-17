function [d] = Step_Analysis( d,type_string,subj_string )
%Analysis of Step Length. Step Velocity. Time variability.
%Output rate of the Kinect


%DEFINE SAMPLING RATE
sampling_rate = 30;
dist_conv = 4.13/634;

for iii = 1:length(type_string)
    for ii=1:length(subj_string)
        
        data = d.(type_string{iii}).(subj_string{ii}).Raw_Data;
        
        
        %STEP LENGTH: LEFT/RIGHT ANKLE
        RA = [data(:,37) data(:,38)];
        LA = [data(:,29) data(:,30)];
        
        %Combined array: [LA_xcoordinate LA_ycoordinate RA_xcoordinate
        %RA_ycoordinate
        RA_LA_combined = [LA(:,1) LA(:,2) RA(:,1), RA(:,2)].*dist_conv;
        
        %Convert Indices/Sampling Rate to Time
        t = 0 : (size(LA, 1) - 1);
        tt = t/sampling_rate;
        
        
        
%         PLOT POSITION DATA
%         figure;
%         titles={'Left Angkle, X','Left Ankle, Y','Right Ankle, X','Right Ankle, Y'};
%         for i = 1:4
%             h(i) = subplot(2, 2, i);
%             plot( h(i), tt, RA_LA_combined(:,i) );
%             h(i) = xlabel( 'Time [sec]');
%             h(i) = ylabel( 'Position [Units to be determined] ');
%             title(titles{i})
%         end
%         
        %y = filter([1, 1, 1], 2, RA_LA_combined(:,1));
        %figure;
        %plot (tt, y)
        %Plot attributes
        
        
        %CALCULATE STEP LENGTH
        step_lengthx = (LA(:,1) - RA(:,1))*dist_conv;
        step_lengthy=  (LA(:,2) - RA(:,2))*dist_conv;
        step_length = sqrt(step_lengthx.^2+step_lengthy.^2);
        
        
        
        %ADD FILTER TO STEP LENGTH
        
        
        filter_step = filter([1, 1, 1, 1], 3, step_lengthx);
        figure;
        subplot(2,1,1)
        plot(tt,step_lengthx)
        title('Step Length - X')
        xlabel('Time (s)')
        ylabel('Distance (m)')
        subplot(2,1,2)
        plot(tt,filter_step)
        title('Filtered Step Length')
        xlabel('Time (s)')
        ylabel('Distance (m)')
        
        
        d.(type_string{iii}).(subj_string{ii}).Step_Length_X = step_lengthx;
        d.(type_string{iii}).(subj_string{ii}).Step_Filter = filter_step;
        d.(type_string{iii}).(subj_string{ii}).Time = tt;
        
        
    end
end



end

