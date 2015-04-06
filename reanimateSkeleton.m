%Function written by Adam Li on 07/28/14
%Input: - dirName is the directory name location
%       - expName is the experiment name (e.g. walk, sitstand, turn,etc.)
%       with 001/101 and c1/c2
%       So it would look like 'SitStand_001_c1'
%
%Output: - vidOutput is a video file with all the 
%images inputted into the file one by one
%Description: Saves all the skeletal data into a stream of images
%and saves it as a video

% Example run: reanimateSkeleton('Walk', 'Skeleton_Walk_001_c1_07.csv')

function reanimateSkeleton(expName, fileName)
    %% Initialize directory name and column vectors

    %This depends on where you save your image folders **Subject to Change**
    startDir = '/Volumes/NIL_PASS/Camera1/001_August07';

    %initializes the directory where images are contained
    fullDir = fullfile(startDir);   
    
    %read data and import columns as column vectors
    %%%%Only available in R2014A version!!! T = readtable('filename');%%%%%
    
    %Make sure csv file saved as Windows Comma Separated File if you are using MAC
    %Does not get the last line of data for some reason...
    [head_x,	 head_y,	 head_z,...
        shoulder_center_x,	 shoulder_center_y,	 shoulder_center_z,...
        spine_x,	 spine_y,	 spine_z,...
        hip_center_x,	 hip_center_y,	 hip_center_z,...
        shoulder_left_x,	 shoulder_left_y,	 shoulder_left_z,...
        elbow_left_x,	 elbow_left_y,	 elbow_left_z,...
        wrist_left_x,	 wrist_left_y,	 wrist_left_z,...
        hand_left_x,	 hand_left_y, hand_left_z,...
        shoulder_right_x, shoulder_right_y, shoulder_right_z,...
        elbow_right_x,	 elbow_right_y,	 elbow_right_z,...
        wrist_right_x,	 wrist_right_y,	 wrist_right_z,...
        hand_right_x,	 hand_right_y,	 hand_right_z,...
        hip_left_x,	 hip_left_y,	 hip_left_z,...
        knee_left_x,  knee_left_y,	 knee_left_z,...
        ankle_left_x,	 ankle_left_y,	 ankle_left_z,...
        foot_left_x,	 foot_left_y,	 foot_left_z,...
        hip_right_x,	 hip_right_y,	 hip_right_z,...
        knee_right_x,	 knee_right_y,	 knee_right_z,...
        ankle_right_x,	 ankle_right_y,   ankle_right_z,...
        foot_right_x,	 foot_right_y,	 foot_right_z,...
        time_stamp] = csvimport(fullfile(fullDir, fileName), ...
        'columns', {'head_x',	'head_y',  'head_z',...
        'shoulder_center_x', 'shoulder_center_y', 'shoulder_center_z',...
        'spine_x', 'spine_y', 'spine_z',...
        'hip center_x', 'hip center_y', 'hip center_z',...
        'shoulder left_x', 'shoulder left_y', 'shoulder left_z',...
        'elbow left_x',	'elbow left_y',	 'elbow left_z',...
        'wrist left_x',	 'wrist left_y', 'wrist left_z',...
        'hand left_x',	 'hand left_y',	 'hand left_z',...
        'shoulder right_x',	 'shoulder right_y', 'shoulder right_z',...
        'elbow right_x', 'elbow right_y',	'elbow right_z',...
        'wrist right_x', 'wrist right_y', 'wrist right_z',...
        'hand right_x',	 'hand right_y', 'hand right_z',...
        'hip left_x',	 'hip left_y', 'hip left_z',...
        'knee left_x',  'knee left_y', 'knee left_z',...
        'ankle left_x',	 'ankle left_y', 'ankle left_z',...
        'foot left_x',	 'foot left_y', 'foot left_z',...
        'hip right_x',	 'hip right_y', 'hip right_z',...
        'knee right_x',	 'knee right_y', 'knee right_z',...
        'ankle right_x', 'ankle right_y', 'ankle right_z',...
        'foot right_x',	 'foot right_y', 'foot right_z', 'time_stamp'});

%% Draw points between each relevent joint & plot it
    %Combine x,y of each joint into a separate temp matrix, and plot it
    head = [head_x, head_y];
    shoulder_center = [shoulder_center_x, shoulder_center_y];
    spine = [spine_x, spine_y];
    hip_center = [hip_center_x, hip_center_y];
    shoulder_left = [shoulder_left_x, shoulder_left_y];
    elbow_left = [elbow_left_x, elbow_left_y];
    wrist_left = [wrist_left_x, wrist_left_y];
    hand_left = [hand_left_x, hand_left_y];
    shoulder_right = [shoulder_right_x, shoulder_right_y];
    elbow_right = [elbow_right_x, elbow_right_y];
    wrist_right = [wrist_right_x, wrist_right_y];
    hand_right = [hand_right_x, hand_right_y];
    hip_left = [hip_left_x, hip_left_y];
    knee_left = [knee_left_x, knee_left_y];
    ankle_left = [ankle_left_x, ankle_left_y];
    foot_left = [foot_left_x, foot_left_y];
    hip_right = [hip_right_x, hip_right_y];
    knee_right = [knee_right_x, knee_right_y];
    ankle_right = [ankle_right_x, ankle_right_y];
    foot_right = [foot_right_x, foot_right_y];
    
    %draw the line between each relevant vertice
    %Each number in a row corresponds to a row in V
    N = [1, 2;      %head -> shoulder_center              
         2, 3;      %shoulder_center -> spine
         3, 4;      %spine -> hip_center
 
         2, 5;      %shoulder_center -> shoulder_left
         5, 6;      %shoulder_left -> elbow_left
         6, 7;      %elbow_left -> wrist_left
         7, 8;      %wrist_left -> hand_left
         
         2, 9;      %shoulder_center -> shoulder_right
         9, 10;     %shoulder_right -> elbow_right
         10, 11;    %elbow_right -> wrist_right
         11, 12;    %wrist_right -> hand_right
         
         4, 13;     %hip_center -> hip_left
         13, 14;    %hip_left -> knee_left
         14, 15;    %knee_left -> ankle_left
         15, 16;    %ankle_left -> foot_left
         
         4, 17;     %hip_center -> hip_right
         17, 18;    %hip_right -> knee_right
         18, 19;    %knee_right -> ankle_right
         19, 20];   %ankle_right -> foot_right
     
    %for loop to loop through each row of the csv file
    %vertice matrix will be the different column vector joint's x and y
    
    %Create folder Skeleton_Images
    [s, mess, messid] = mkdir(fullDir, 'Skeleton_Images')
    
    t = cputime;
    %set up figure
    f = figure(1);
    % prevent the figure window from appearing at all
    set(f, 'visible', 'off');

    
    
    for i=1:length(head_x)
                                                           %%Row #'s
        V = [head(i, 1), head(i, 2);                        %head = 1
            shoulder_center(i, 1), shoulder_center(i, 2);   %shoulder_center = 2
            spine(i, 1), spine(i, 2);                       %spine = 3
            hip_center(i, 1), hip_center(i, 2);             %hip_center = 4
            shoulder_left(i, 1), shoulder_left(i, 2);       %shoulder_left = 5
            elbow_left(i, 1), elbow_left(i, 2);             %elbow_left = 6
            wrist_left(i, 1), wrist_left(i, 2);             %wrist_left = 7
            hand_left(i, 1), hand_left(i, 2);               %hand_left = 8
            shoulder_right(i, 1), shoulder_right(i, 2);     %shoulder_right = 9
            elbow_right(i, 1), elbow_right(i, 2);           %elbow_right = 10
            wrist_right(i, 1), wrist_right(i, 2);           %wrist_right = 11
            hand_right(i, 1), hand_right(i, 2);             %hand_right = 12
            hip_left(i, 1), hip_left(i, 2);                 %hip_left = 13
            knee_left(i, 1), knee_left(i, 2);               %knee_left = 14
            ankle_left(i, 1), ankle_left(i, 2);             %ankle_left = 15
            foot_left(i, 1), foot_left(i, 2);               %foot_left = 16
            hip_right(i, 1), hip_right(i, 2);               %hip_right = 17
            knee_right(i, 1), knee_right(i, 2);             %knee_right = 18
            ankle_right(i, 1), ankle_right(i, 2);           %ankle_right = 19
            foot_right(i, 1), foot_right(i, 2)];            %foot_right = 20
    
        for j=1:19 %loop through each of the 19 joint connections
            a = N(j, 1);    %first vertice row# in V
            b = N(j, 2);    %second vertice row# in V
            
            %temporary matrix for plotting out x, y
            H(1,:)=V(a,:);  %first vertice's x, y
            H(2,:)=V(b,:);  %second vertices' x, y
                        
            %plot the line between those points, then loop again
            plot(H(:,1),H(:,2), 'k*-', 'linewidth', 2)
            hold on
        end
        
        xlabel('x axis in meters');
        ylabel('y axis in meters');
        xlim([-1.25 1.25])
        ylim([-1.25 1.25])
        
        %%add chcking functionality to check for "bad images"
        
        %Check if ankle above knee or neck above head
        if((ankle_right(i, 2) > knee_right(i, 2)) || shoulder_center(i, 2) > head(i, 2))
            %Specify name of file and directory with timestamp; timestamp is a 'string'
            imageName = strcat('Skeleton_', expName, '_Bad_');
        else
            imageName = strcat('Skeleton_', expName, '_');
        end
        
        %Check if time stamp in milliseconds is shorter to configure for saving images
        %Adds 0's to make other functions work
        if(length(time_stamp{i}) == 7)
            %Check if the first index in time_stamp is a space. If so,
            %insert 0
            if(time_stamp{i}(1) == ' ')
                beforeMs = strcat('0',time_stamp{i}(2:6));
            else
                beforeMs = time_stamp{i}(1:6);
            end
            
            %store the millisecond part of time_stamp
            millisecond = time_stamp{i}(7);
            imageName = strcat(imageName, beforeMs, '00',millisecond, '.png');
        elseif(length(time_stamp{i}) == 8)
            %Check if the first index in time_stamp is a space. If so,
            %insert 0
            if(time_stamp{i}(1) == ' ')
                beforeMs = strcat('0',time_stamp{i}(2:6));
            else
                beforeMs = time_stamp{i}(1:6);
            end
            
            %store the millisecond part of time_stamp
            millisecond = time_stamp{i}(7:8);
            imageName = strcat(imageName, beforeMs, '0',millisecond, '.png');
        else
            imageName = strcat(imageName, time_stamp{i}, '.png');
        end
        
        %final file name
        file = fullfile(fullDir, 'Skeleton_Images', imageName);
                
        %save the image to file
        saveas(f, file);
        
        %clear current plot
        clf;
    end
    close all;
    
    time = cputime-t;
    message = strcat({'Time elapsed is '}, num2str(time));
    disp(message);
end