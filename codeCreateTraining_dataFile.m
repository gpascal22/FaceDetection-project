%addpath 'C:\Users\Xuan\Documents\Jenna\Texas State University\Semester\Fall 2020\CS 4379C - Computer Vision\Final Project\git\ComputerVison-project\files'
%addpath 'C:\Users\Xuan\Documents\Jenna\Texas State University\Semester\Fall 2020\CS 4379C - Computer Vision\Final Project\git\ComputerVison-project\training_test_data'

%cd 'C:\Users\Xuan\Documents\Jenna\Texas State University\Semester\Fall 2020\CS 4379C - Computer Vision\Final Project\git\ComputerVison-project'

clear all;
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
faces_integrals = zeros(50, 50, 3046);
non_faces_integrals = zeros(50, 50, 130);

% Resize
dirData = dir('training_test_data\training_faces\*.bmp'); %takes all the images from the folder/ you can also assign specific address of the folder

%for k = 1:length(dirData) %the loop will continue for the number of images
    % filename = dirData(k).name;
    % data1 = imread(fullfile('training_test_data\training_faces', filename));
    % data2 = imresize(data1,[50 50]);     
    % imwrite(data2, fullfile('ResizedTraining', filename));
%end
% Save resized tranining face images into 3-D matrix 
faces = zeros(50, 50, 3046);

dirResizedTranining = dir('ResizedTraining\*.bmp');

for i = 1:length(dirResizedTranining)
    filename = dirResizedTranining(i).name;
    image = imread(fullfile('ResizedTraining', filename));
    faces(:,:,i) = reshape(image, [50, 50, 1]);
end

dirTrainingNonface = dir('training_test_data\training_nonfaces\*.jpg');
% split non_face training images into 50x50 windows and store in non_faces
% variable
non_faces1 = zeros(50, 50, 2000);
count = 0;
z = 1;
for i = 1:length(dirTrainingNonface)
    a = 1; % top
    b = 50; % bottom
    c = 1; % left
    d = 50; % right
    filename = dirTrainingNonface(i).name;
    data1 = imread(fullfile('training_test_data\training_nonfaces', filename));    
    rows = size(data1, 1);
    cols = size(data1, 2);
    while b <= rows
        window = data1(a:b, c:d);
        non_faces1(:, :, z) = reshape(window, [50, 50, 1]);
        c = c + 50;
        d = d + 50;     
        count = count + 1;
        z = z + 1;
        if d >= cols 
            d = 50;
            c = 1;
            a = a + 50;
            b = b + 50;
        end
    end
    
end
non_faces = zeros(50, 50, count);
for i = 1:count
    non_faces(:,:,i) = non_faces1(:,:,i);
end
% Compute face_integrals and non_faces_integrals
for i = 1:3046
    faces_integrals(:,:,i) = integral_image(faces(:,:,i));  
end
for i = 1:count
    non_faces_integrals(:,:,i) = integral_image(non_faces(:,:,i));  
end

face_size = [50, 50];
face_vertical = 50;
face_horizontal = 50;
% save variables in training_data.mat 
save training_data.mat faces non_faces faces_integrals non_faces_integrals face_size face_horizontal face_vertical ;

