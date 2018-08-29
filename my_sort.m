function [sorted, inds, inverseInds] = my_sort(unsorted)
% The same as SORT but returns also the inverse mapping  (for vectors)
% sorted -> unsorted

[sorted, inds] = sort(unsorted);
[~,inverseInds] = ismember( 1:max(inds), inds);
