% Advanced face detection with AdaBoost
% Components: AdaBoost, Skin detection, Bootstrapping, Cascades.

% TESTING script

clear;
clc;

% set directories
directories;

% load data 
load reponsesResults;
load classifiers1000;
load boosted15;
load training_data;

threshold = 5;

%Testing without classifier cascades and skin detection
% 1. Testing cropped faces 

testing_cropped_faces_path = [training_directory,'\', 'test_cropped_faces'];
testing_cropped_faces_list = dir(testing_cropped_faces_path);
testing_cropped_faces_list = remove_unwanted_dir(testing_cropped_faces_list);

num_test_croppedFaces = size(testing_cropped_faces_list, 1);

missclassified = 0;
predRight1 = 0;

for i =1:num_test_croppedFaces
    cropped_face = testing_cropped_faces_list(i).name;
    cropped_pic = double(imread(cropped_face));
    center = (size(cropped_pic)/2)/2;
    cropped_pic = imcrop(cropped_pic, [center 59 59]);
   
    result = apply_classifier_aux(cropped_pic, boosted_classifier, weak_classifiers, [60 60]);
    class = result(31, 31); 
    
    if class < threshold 
        predRight1 = predRight1 +1;
    else
        missclassified = missclassified +1;
    end
  
end

croppedFace_accuracy = (predRight1/num_test_croppedFaces) * 100;
disp(croppedFace_accuracy);

1. Testing non faces 
testing_nonfaces_path = [training_directory, '\', 'test_nonfaces'];
testing_nonfaces_list = dir(testing_nonfaces_path);
testing_nonfaces_list = remove_unwanted_dir(testing_nonfaces_list);
num_testing_nonfaces = size(testing_nonfaces_list, 1);

predRight2 = 0;
missclassified = 0;

for i =1:num_testing_nonfaces
  
    non_face = testing_nonfaces_list(i).name;
    non_facePic = double(imread(non_faces));
    
    result = apply_classifier_aux(non_facePic, boosted_classifier, weak_classifiers, [60 60]);
    %result = boosted_multiscale_search(non_facePic, 3, boosted_classifier, weak_classifiers, [60,60]);
    
    class = max(max(result));                    
                          
    if class <= threshold
        predRight2 = predRight2 +1;
    else
        missclassified = missclassified +1;
    end
   
end
nonFace_accuracy = (predRight2/num_testing_nonfaces) * 100;
disp(nonFace_accuracy);

Testing photos
testing_faces_path = [training_directory,'\', 'test_face_photos'];
testing_faces_list = dir(testing_faces_path);
testing_faces_list = remove_unwanted_dir(testing_faces_list);


num_testing_faces = size(testing_faces_list, 1);

predRight3 = 0;
missclassified = 0;


for i =1:num_testing_faces
    
    test_photo = testing_faces_list(i).name;
    read_pic = read_gray(test_photo);
    result = boosted_multiscale_search(read_pic, 2, ...
                              boosted_classifier, weak_classifiers, ...
                              [60,60]);
                    
    class = max(max(result));
    
    if class < threshold
        predRight3 = predRight3 + 1;
    else
        missclassified = missclassified + 1;
    end
  
end

FaceAcc1 = (predRight3/num_testing_faces) * 100;
disp(FaceAcc1);

%Testing with skin detection
% read histogram
negative_histogram = read_double_image('negatives.bin');
positive_histogram = read_double_image('positives.bin');

predRight4 = 0;
missclassified = 0;


for i =1:num_testing_faces
    first_image = testing_faces_list(i).name;
    sec_image = double(imread(first_image));
    pass_image = read_gray(first_image);
    
    if(size(sec_image, 3) == 3)
        result_on_skin = detect_skin(sec_image, positive_histogram,  negative_histogram);
        figure (i); imshow(result_on_skin, []);
        
        result = boosted_detector_demo(pass_image, 2,  boosted_classifier, ...
                          weak_classifiers, [60,60], 4);
        figure(i); imshow(result, []);
        class = max(max(result));
        
        if class < threshold
            predRight4 = predRight3 + 1;
        else
            missclassified = missclassified + 1;
        end
    end
      
end
FaceAcc2 = (predRight4/num_testing_faces) * 100;
disp(FaceAcc2);


    
