% Advanced face detection with AdaBoost
% Components: AdaBoost, Skin detection, Bootstrapping, Cascades.

% TRAINING script

clear all;
clc;

% set directories
directories;

% training faces list
training_faces_path = [data_directory, 'training_faces'];
% training_faces_list = dir(training_faces_path);
training_faces_list = dir(training_test_data\training_faces);

% training nonfaces list
training_nonfaces_path = [data_directory, 'training_nonfaces'];
%training_nonfaces_list = dir(training_nonfaces_path);
training_nonefaces_list = dir(training_test_data\training_nonfaces);

% get sizes of training lists
num_faces = size(training_faces_list, 1);
num_non_faces = size(training_nonfaces_list, 1);

%% 

% First step using rectangle filters with adaboost on all the training images
% Training using Rectangle filters and AdaBoost 

