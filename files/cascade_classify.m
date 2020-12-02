function result = cascade_classify(window)
% Applying a Cascade to a Window

result = 0;
windowI = integral(window);
classifier_number = size(responses, 1);
example_number = size(responses, 2);
weights = ones(example_number, 1) / example_number;
% cascade 1: first 3 classifiers
[best_classifier1, best_error1, threshold1, alpha1] = ...
        find_best_classifier(responses, labels, weights);
[best_classifier2, best_error2, threshold2, alpha2] = ...
        find_best_classifier(responses, labels, weights);
[best_classifier3, best_error3, threshold3, alpha3] = ...
        find_best_classifier(responses, labels, weights);
response1 = eval_weak_classifier(best_classifier1, windowI);
response2 = eval_weak_classifier(best_classifier2, windowI);
response3 = eval_weak_classifier(best_classifier3, windowI);

averageReponse1 = (response1 + response2 + response3) / 3;

Athreshold1 = (threshold1 + threshold2 + threshold3) / 3;
if averageReponse1 < Athreshold1
    result = -1;
else
    % cascade 2: first 7 classifiers
    [best_classifier4, best_error4, threshold4, alpha4] = ...
            find_best_classifier(responses, labels, weights);
    [best_classifier5, best_error5, threshold5, alpha5] = ...
            find_best_classifier(responses, labels, weights);
    [best_classifier6, best_error6, threshold6, alpha6] = ...
            find_best_classifier(responses, labels, weights);
    [best_classifier7, best_error7, threshold7, alpha7] = ...
            find_best_classifier(responses, labels, weights);
    response4 = eval_weak_classifier(best_classifier4, windowI);
    response5 = eval_weak_classifier(best_classifier5, windowI);
    response6 = eval_weak_classifier(best_classifier6, windowI);
    response7 = eval_weak_classifier(best_classifier7, windowI);

    averageReponse2 = (averageResponse1 + response4 + response5 + response6 + response7) / 5;
    Athreshold2 = (Athreshold1 + threshold4 + threshold5 + threshold6 + threshold7) / 5;
    
    if averageResponse2 < Athreshold2
        result = -1;
    else
        % cascade 3: first 10 classifiers
        [best_classifier8, best_error8, threshold8, alpha8] = ...
                find_best_classifier(responses, labels, weights);
        [best_classifier9, best_error9, threshold9, alpha9] = ...
                find_best_classifier(responses, labels, weights);
        [best_classifier10, best_error10, threshold10, alpha10] = ...
                find_best_classifier(responses, labels, weights);
        response8 = eval_weak_classifier(best_classifier8, windowI);
        response9 = eval_weak_classifier(best_classifier9, windowI);
        response10 = eval_weak_classifier(best_classifier10, windowI);

        averageReponse3 = (averageResponse2 + response8 + response9 + response10) / 4;
        Athreshold3 = (Athreshold2 + threshold1 + threshold2 + threshold3) / 4;
        if averageReponse3 < Athreshold3
            result = -1; % nonface
        else
            result = 1; % face
        end
    end
end

end
