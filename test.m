% Advanced face detection with AdaBoost
% Components: AdaBoost, Skin detection, Bootstrapping, Cascades.

% TESTING script 

%%

clear all;
clc;

% set directories
directories;

% load data 
% training boosted classifiers

threshold = 5;

%%

% Testing cropped faces 

testing_cropped_faces_path = [training_directory, 'test_cropped_faces'];
testing_cropped_faces_list = dir(testing_cropped_faces_path);

num_test_croppedFaces = size(testing_cropped_faces_list, 1);

missclassified = 0;
predicted = 0;

% for i = 1: num_test_croppedFaces
%  testing_face = getfield(testing_cropped_faces_list(i), 'name');
%  read_photo = read_gray(testing_face);
%  centeroid = (size(read_photo/2)/2;
   


