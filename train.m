% Advanced face detection with AdaBoost
% Components: AdaBoost, Skin detection, Bootstrapping, Cascades.

% TRAINING script
clear ;
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

%save reponsesResults responses labels classifier_number example_number examples;

load reponsesResults.mat;
%boosted_classifier = AdaBoost(responses, labels, 15);
%save boosted15 boosted_classifier;
load boosted15.mat;
% Choose best classifier (highest threshold and high best error, alpha to classify images
% Start training
load classifiers1000.mat
wc = weak_classifiers{683};

response = eval_weak_classifier(wc, examples(:,:,1));
% Train on all training data - run 15 rounds of adaBoost
misclassified = 0;
tic
for i = 1:15
    order = boosted_classifier(i, 1);
    best_classifier = weak_classifiers{order};
    best_threshold = boosted_classifier(i, 3);
    for a = 1:example_number
        response = eval_weak_classifier(best_classifier, examples(:,:,a));
        if a <= size(faces, 3)
            if response <= best_threshold
                misclassified = misclassified + 1;
            end
        end
    end
    classification_accuracy = ((example_number - misclassified)/example_number)*100;
    misclassified = 0;
end
toc

%classification_accuracy = 80.0733
%classification_accuracy = 78.6653
%classification_accuracy = 91.5667
%classification_accuracy = 97.7731
%classification_accuracy = 81.3519
%classification_accuracy = 99.5905
%classification_accuracy = 84.1822
%classification_accuracy = 99.8204
%classification_accuracy = 82.3217
%classification_accuracy = 82.7168
%classification_accuracy = 98.3406
%classification_accuracy = 99.0015
%classification_accuracy = 78.3062
%classification_accuracy = 93.7576
%classification_accuracy = 99.8707
%Elapsed time is 2.628481 seconds.

% BOOSTRAPING
% Bootstrap set
bootstrapDataSet = zeros(50, 50, 5437);
% Add data to boostrap set
% faces
count = 0;
for i = 1:1014
    bootstrapDataSet(:,:,i) = examples(:,:,i);
    count = count + 1;
end
% nonfaces
v = 7250;
for i = 1015:4639
    bootstrapDataSet(:,:,i) = examples(:,:,v);
    count = count + 1;
    v = v + 1; 
end

misI = 0;
number = size(bootstrapDataSet, 3);
misclassified2 = 0;
misclassified3 = 0;
max = 0;
classification_accuracyBT = zeros(15, 1);
count2 = 1;
tic
while count < 5437
    % Train on boostrap set
    for i = 1:15
        order = boosted_classifier(i, 1);
        best_classifier = weak_classifiers{order};
        best_threshold = boosted_classifier(i, 3);
        for a = 1:count
            response = eval_weak_classifier(best_classifier, bootstrapDataSet(:,:,a));
            if a <= 1014
                if response <= best_threshold
                    misclassified2 = misclassified2 + 1;
                end
            end
        end
        acc = ((number - misclassified2)/number)*100;
        classification_accuracyBT(i, 1) = ((number - misclassified2)/number)*100;
        %fprintf("Accuracy: %d", classification_accuracyBT);
        misclassified2 = 0;
        if i == 1
            max = classification_accuracyBT(i, 1);
        else
            if max < classification_accuracyBT(i, 1)
                max = classification_accuracyBT(i, 1);
            end  
        end
        signal = 0;
        % Train on whole data 
        a = count2;
        while a <= 7251 && signal ~= -1
            response = eval_weak_classifier(best_classifier, examples(:,:,a));
            if a <= size(faces, 3)
                if response <= best_threshold 
                    index = a;
                    misclassified3 = misclassified3 + 1; 
                    signal = -1;
                                         
                end
               
            end
            count2 = count2 + 1;
            a = a + 1;
        end
         
        bootstrapDataSet(:,:,count+1) = examples(:,:,a);    
        count = count + 1;
        
    end
    
end
toc
%{ 

Elapsed time is 36.741427 seconds.
%}
