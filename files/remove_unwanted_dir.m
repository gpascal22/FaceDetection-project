function [ result ] = remove_unwanted_dir( list_as_struct )

result = list_as_struct;

[rows, ~] = size(result);

for i = 1:rows
    fi = rows - i + 1;
    if result(fi).isdir == 1
        if fi == rows
            result = result(1:(fi - 1), :);
        elseif fi == 1
            result = result((fi + 1):end, :);
        else
            result = [result(1:(fi - 1), :); result((fi + 1):end, :)];
        end
    end
end

end