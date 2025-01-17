function [ output_args ] = importSkeleton( subj_string )
%This function imports the Skeleton CSV file, converts data into struct,
%and saves it. Input needs to be a cell_array of strings
%Dependencies: 
%    - getAllFiles.m 
%    -             
%Example: subj_string = {'013.1', '013.2', '014.1', '014.2',
% '015.1', '015.2', '016.1', '016.2', '017.1', 
% '017.2', '020.1', '020.2', '021.1', '021.2', '022.1','022.2'}; 
% or subj_string = {'021.1'}
 %% Initialize directory name and column vectors
    cam = 'Camera2';
 
    %This depends on where you save your image folders **Subject to Change**
    startDir = '/Users/adam2392/Desktop/';%'/Volumes/NIL_PASS/Camera1/'; %/Volumes/NIL_PASS/Camera1/001_August07/001_Color_Walk
    mainDir = strcat('/Analysis Folder/', cam);%'/022.1_November18/Skeleton/';
    
    %Separate written Function imports all file names and directory name
    files = getAllFiles(fullfile(startDir,mainDir));
    
    
     %% Initialize Structure Parameters

    coord = {'x','y','z'};
    joint = {'ankle_left','ankle_right','elbow_left','elbow_left','elbow_right',...
        'foot_left','foot_right','hand_left','hand_right','head','hip_center',...
        'hip_left','hip_right','knee_left','knee_right','shoulder_center',...
        'shoulder_left','shoulder_right','spine','wrist_left','wrist_right', 'time_stamp'};
    activity = {'SitStand','SitTurn','StandGo','Walk'};

    %% Import CSV File

    for iii=1:length(subj_string)
        disp(subj_string{iii})

        for ii=1:length(activity)
            disp(activity{ii})
            for i=1:size(files,1)
                curr = files{i};

                %Finding the data file per subject
                if(size(strfind(curr,subj_string{iii}),1)>0 && ...
                        size(strfind(curr,activity{ii}),1)>0 && ...
                        size(strfind(curr,'.csv'),1)>0 && ...
                        size(strfind(curr,'c1'),1)>0)% && ...
                       % strcmp(curr(indexofSkeleton+10:indexofSkeleton+17), 'Skeleton')) %this line added to account for ghost files... ask Adam

                    disp('File Found')
                    disp(curr)

                    [head_x, head_y, head_z,...
                        shoulder_center_x, shoulder_center_y, shoulder_center_z,...
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
                        time_stamp] = csvimport(curr, ...
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

                    % Use second method to get the column data
                    if(isempty(head_x))
                        disp('Make sure file locations are correct!');

                        %get the csv files within csvDir
                        csv = dir(fullfile(startDir,mainDir, '*.csv'));
                        csvName = {csv.name};

                        % get the index of the file name
                        indexofSkeleton = strfind(curr, '/Skeleton');
                        compare = curr(indexofSkeleton+1:end);

                        for index = 1:length(csvName)

                            if strcmp(csvName{index}, compare)
                                indexofFile = index;
                            end
                        end

                        csvFile = fullfile(startDir,mainDir,csvName{indexofFile});

                        [head_x, head_y, head_z,...
                        shoulder_center_x, shoulder_center_y, shoulder_center_z,...
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
                        time_stamp] = importSkeleton_Helper(csvFile);
                    end


                    for j = 1:length(joint)
                        for k = 1:length(coord)
                            data_string = [joint{j} '_' coord{k}];
                            if(strcmp(joint{j}, 'time_stamp'))
                                data_string = [joint{j}];
                                Subj_Name.(activity{ii}).(joint{j}) = eval(data_string);
                            else
                                Subj_Name.(activity{ii}).(joint{j}).(coord{k}) = eval(data_string);
                            end
                        end
                    end
                end

            end
        end
        
        sub = {strrep(subj_string{iii},'.','_')};
        eval(['Subj_' sub{1} '= Subj_Name;'])

        if (exist(strcat('Subj_Preprocessed_Data', '/', cam, '/') ,'dir') ~= 7)
            mkdir(strcat('Subj_Preprocessed_Data/', cam, '/'));
        end


        save([strcat('./Subj_Preprocessed_Data/', cam, '/', 'Subj_') sub{1}],['Subj_' sub{1}])
    end
end

