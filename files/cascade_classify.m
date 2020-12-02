function result = cascade_classify(window)
% Applying a Cascade to a Window

threshold = 1;
k = size(window);

for i = 1: k
    if window < threshold
        window = -1;
        result = window;
    elseif window > threshold
        window = 1;
        result = window;
    end
end

end
