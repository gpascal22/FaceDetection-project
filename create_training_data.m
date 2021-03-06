clear;
clc;

% set directories
directories;

% training faces list
training_faces_path = [data_directory, '\', 'training_faces'];
% training_faces_list = dir(training_faces_path);
training_faces_list = dir('training_test_data\training_faces');

% training nonfaces list
training_nonfaces_path = [data_directory, '\', 'training_nonfaces'];
%training_nonfaces_list = dir(training_nonfaces_path);
training_nonefaces_list = dir('training_test_data\training_nonfaces');

% get sizes of training lists
num_faces = size(training_faces_list, 1);
num_non_faces = size(training_nonefaces_list, 1);

% First step using rectangle filters with adaboost on all the training images
% Training using Rectangle filters and AdaBoost
% Compute variables for training_data.mat for later use
faces_integrals = zeros(60, 60, 3046);
non_faces_integrals = zeros(60, 60, 130);

% Resize
% Resize
dirData = dir('training_test_data\training_faces\*.bmp'); %takes all the images from the folder/ you can also assign specific address of the folder

%for k = 1:length(dirData) %the loop will continue for the number of images
    % filename = dirData(k).name;
    % data1 = imread(fullfile('training_test_data\training_faces', filename));
    % data2 = imresize(data1,[50 50]);     
    % imwrite(data2, fullfile('ResizedTraining', filename));
%end
% Save resized tranining face images into 3-D matrix 
faces = zeros(60, 60, 3046);

dirResizedTranining = dir('ResizedTraining\*.bmp');

for i = 1:length(dirResizedTranining)
    filename = dirResizedTranining(i).name;
    image = imread(fullfile('ResizedTraining', filename));
    faces(:,:,i) = reshape(image, [60, 60, 1]);
end

dirTrainingNonface = dir('training_test_data\training_nonfaces\*.jpg');
% split non_face training images into 50x50 windows and store in non_faces
% variable
non_faces = zeros(60, 60, 130);
a = 1; % top
b = 60; % bottom
c = 1; % left
d = 60; % right
for i = 1:length(dirTrainingNonface)
    filename = dirTrainingNonface(i).name;
    data1 = imread(fullfile('training_test_data\training_nonfaces', filename));    
    rows = size(data1, 1);
    cols = size(data1, 2);
    while b <= rows
        window = data1(a:b, c:d);
        non_faces(:, :, i) = reshape(window, [60, 60, 1]);
        c = c + 60;
        d = d + 60;     

        if d >= cols 
            d = 60;
            c = 1;
            a = a + 60;
            b = b + 60;
        end
    end

end

% Compute face_integrals and non_faces_integrals
for i = 1:3046
    faces_integrals(:,:,i) = integral_image(faces(:,:,i));  
end
for i = 1:130
    non_faces_integrals(:,:,i) = integral_image(non_faces(:,:,i));  
end

face_size = [60, 60];
face_vertical = 60;
face_horizontal = 60;
% save variables in training_data.mat 
save training_data.mat faces non_faces faces_integrals non_faces_integrals face_size face_horizontal face_vertical ; 
