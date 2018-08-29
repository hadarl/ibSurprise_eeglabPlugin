function formattedCellArray = prepare_formatted_cellarray(vec,formatStr)
% Useful for creating legends from numeric arrays

formattedCellArray = cell(1,length(vec));

for i = 1:length(vec)
    formattedCellArray(i) = {sprintf(formatStr,vec(i))};
end
    