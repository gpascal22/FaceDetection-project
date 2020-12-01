% Advanced face detection with AdaBoost
% Components: AdaBoost, Skin detection, Bootstrapping, Cascades.

% TESTING script 

%%

clear all;
clc;

% set directories
directories;

% load data 
load reponsesResults;
load classifiers1000;
load boosted15;
load training_data;

threshold = 5;

%%
% Testing without classifier cascades and skin detection

% 1. Testing cropped faces 

testing_cropped_faces_path = [training_directory,'\', 'test_cropped_faces'];
testing_cropped_faces_list = dir(testing_cropped_faces_path);

num_test_croppedFaces = size(testing_cropped_faces_list, 1);

missclassified = 0;
predRight1 = 0;
dirData_croppedFace = dir('training_test_data\test_cropped_faces\*.bmp'); 

for i = 1: length(dirData_croppedFace)
    filename = dirData_croppedFace(k).name;
    image1 = read_gray(fullfile('training_test_data\test_cropped_faces', filename));
    data2 = imresize(image1,[50 50]);     
    imwrite(data2, fullfile('ResizedTraining', filename));
end

corppedFaces = zeros(50, 50, 3046);

dirResizedTranining = dir('ResizedTraining\*.bmp');
numTestCroppedFaces = length(dirResizedTranining);
for i = 1:numTestCroppedFaces
    filename = numTestCroppedFaces(i).name;
    imageA = imread(fullfile('ResizedTraining', filename));
    corppedFaces(:,:,i) = reshape(imageA, [50, 50, 1]);
    
    result = apply_classifier_aux(croppedFaces, boosted_classifier, weak_classifiers, [50 50]);
    class = result(30, 30);
    
    if class > threshold
        predRight1 = predRight1 + 1;
    else
        missclassified = missclassified + 1;
    end
    
end

croppedFaceAccuracy = (predRight1 / numTestCroppedFaces) * 100;
%%
% 1. Testing cropped faces 

testing_cropped_faces_path = [training_directory, 'test_cropped_faces'];
testing_cropped_faces_list = dir(testing_cropped_faces_path);

num_test_croppedFaces = size(testing_cropped_faces_list, 1);

missclassified = 0;
predRight2 = 0;
dirData_nonFaces = dir('training_test_data\test_nonfaces\*.bmp'); 

for i = 1: length(dirData_nonFaces)
    filename = dirData_nonFaces(k).name;
    image1 = read_gray(fullfile('training_test_data\test_nonfaces', filename));
    result = boosted_multiscale_search(image1, 3, boosted_classifier, weak_classifier, [50, 50], 1);
    classN = max(max(result));
    
    if classN <= threshold
        predRight2 = predicted + 1;
    else
        missclassified = missclassified + 1;
    end
end

nonFacesAccuracy = (predRight2 / length(dirData_nonFaces)) * 100;

%%
% Testing photos

missclassified = 0;
predRight3 = 0;
dirData_face_photos = dir('training_test_data\test_face_photos\*.bmp'); 
num_face_photos = length(dirData_face_photos);
for i = 1: num_face_photos
    filename = num_face_photos(k).name;
    imagePhoto = read_gray(fullfile('training_test_data\test_face_photos', filename));
    result = boosted_multiscale_search(imagePhoto, 2, boosted_classifier, weak_classifier, [50, 50], 1);
    classP = max(max(result));
    
    if classP > threshold
        predRight3 = predicted + 1;
    else
        missclassified = missclassified + 1;
    end
end

facePhotoAccuracy = (predRight3 / num_face_photos) * 100;

%%
% Testing with skin detection

% read histogram
negative_histogram = read_double_image('negatives.bin');
positive_histogram = read_double_image('positives.bin');

for i = 1: num_face_photos
    filename = num_face_photos(k).name;
    imagePhoto = double(imread((fullfile('training_test_data\test_face_photos', filename)));
    imshow(imagePhoto/255);
    imagePhoto2 = read_gray(imagePhoto);
    
    if(size(imagePhoto, 3) == 3)
        resultSkin = detect_skin(imagePhoto, positive_histogram, negative_histogram);
        figure(i); imshow(resultSkin, []);
        result = boosted_detector_demo(imagePhoto2, imagePhoto2, 2, boosted_classifier, weak_classifiers, [50, 50], 4);
        figure(i); imshow(result, []);
    end
end
    
%%
cascade_faces = [];
cascade_nonfaces = [];


%for i = 1:classifier_number-1
    
 %   result = cascade_classify(window);
    
 %   if result == 1
 %       cascade_faces = result;
 %   elseif result == -1
 %      cascade_nonfaces = result;
 %  end
    
end


    
