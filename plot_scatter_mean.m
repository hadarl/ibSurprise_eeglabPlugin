function [uniqueX, meanY, h, semY, stdY, yBinnedByX, confIntY] = plot_scatter_mean(x,y,plotFlag,plotErrBars,binned,binSize,xBins)

if ~exist('plotFlag') || isempty('plotFlag')
    plotFlag = 1;
end

if ~exist('plotErrBars') || isempty('plotErrBars')
    plotErrBars = 0;
end

if ~exist('binned')
    binned = 0;
end

if ~exist('binSize')
    binSize = 0.2;
end


%%
if binned
    if exist('xBins','var')
        xBinnedUnique = xBins;
    else
        maxX = max(x);
        minX = min(x);
        xBinnedUnique = linspace(floor(minX),ceil(maxX),ceil(maxX)/binSize+1);
    end

    [~,edges, whichBin] = histcounts(x,xBinnedUnique(:)');
    x = xBinnedUnique(whichBin);

    uniqueX = xBinnedUnique;

else
    uniqueX = unique(x);

end

meanY = zeros(size(uniqueX));
stdY = zeros(size(uniqueX));
semY = zeros(size(uniqueX));
confIntY = zeros(2,size(uniqueX,2));
meanTStat = zeros(2,size(uniqueX,2));

yBinnedByX = cell(1,length(uniqueX));
for j = 1:length(uniqueX)
    meanY(j) = mean(y(x==uniqueX(j)));
    yBinnedByX(j) = {y(x==uniqueX(j))};
    stdY(j) = std(y(x==uniqueX(j)));
    nSamples = length(y(x==uniqueX(j)));
    semY(j) = std(y(x==uniqueX(j)))/sqrt(nSamples);
    meanTStat(:,j) = tinv([0.025  0.975],nSamples-1);
    confIntY(:,j) = meanY(j) + meanTStat(:,j)*semY(j);
end

% removing bins with no data points:
if binned
    xInds = ~isnan(meanY);
else
    xInds = true(1,length(uniqueX));
end


hold on;
% plot(uniqueX,meanY,'*k')
if plotFlag
    xlabel('Surprise')
    ylabel('AUC')
    switch plotErrBars
        case 0
            h = plot(uniqueX(xInds), meanY(xInds), '*k');
        case 1
            h = errorbar(uniqueX(xInds),meanY(xInds),semY(xInds),'*k');
        case 2
%             y = bsxfun(@plus,confIntY,meanY);
            shadedErrorBar(uniqueX(xInds), meanY(xInds), meanTStat(2,xInds).*semY(xInds)', '-r'); %'lineprops', '-r')
        otherwise
            disp('plotErrBars undefined')
    end
else
    h = [];
end