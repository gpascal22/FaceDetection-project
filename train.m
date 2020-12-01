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
training_faces_list = dir('training_test_data\training_faces');

% training nonfaces list
training_nonfaces_path = [data_directory, 'training_nonfaces'];
%training_nonfaces_list = dir(training_nonfaces_path);
training_nonefaces_list = dir('training_test_data\training_nonfaces');

% get sizes of training lists
num_faces = size(training_faces_list, 1);
num_non_faces = size(training_nonefaces_list, 1);

% First step using rectangle filters with adaboost on all the training images
% Training using Rectangle filters and AdaBoost
% Compute variables for training_data.mat for later use

% Choosing a set of random weak classifiers
load training_data.mat
number = 1000;
weak_classifiers = cell(1, number);
for i = 1:number
    weak_classifiers{i} = generate_classifier(face_vertical, face_horizontal);
end

%save classifiers1000 weak_classifiers

% Precompute responses of all training examples on all weak classifiers
example_number = size(faces, 3) + size(non_faces, 3);
labels = zeros(example_number, 1);
labels (1:size(faces, 3)) = 1;
labels((size(faces, 3)+1):example_number) = -1;
examples = zeros(face_vertical, face_horizontal, example_number);
examples (:, :, 1:size(faces, 3)) = faces_integrals;
examples(:, :, (size(faces, 3)+1):example_number) = non_faces_integrals;

classifier_number = numel(weak_classifiers);

responses =  zeros(classifier_number, example_number);

for example = 1:example_number
    integral = examples(:, :, example);
    for feature = 1:classifier_number
        classifier = weak_classifiers {feature};
        responses(feature, example) = eval_weak_classifier(classifier, integral);
    end
end

%save responsesResults responses labels classifier_number example_number examples;

load reponsesResults.mat;

%tic;
%boosted_classifier = AdaBoost(responses, labels, 15);
%toc;

%save boosted15 boosted_classifier;
load boosted15.mat;
% Choose best classifier (highest threshold and high best error, alpha to classify images
% Start training
load classifiers1000.mat
wc = weak_classifiers{182};

response = eval_weak_classifier(wc, examples(:,:,1)); % -2779
response2 = eval_weak_classifier(wc, examples(:,:,300)); % -2307
response3 = eval_weak_classifier(wc, examples(:,:,3110)); % -3280

response4 = eval_weak_classifier(wc, examples(:,:,3000)); %-2422
response5 = eval_weak_classifier(wc, examples(:,:,10)); % 
response6 = eval_weak_classifier(wc, examples(:,:,20)); % -3210
