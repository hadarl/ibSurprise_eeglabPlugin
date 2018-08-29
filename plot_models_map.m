function plot_models_map(map,beta,myTitle,withDetails)

if ~isnumeric(map)
    return;
end

if isnumeric(myTitle)
    myTitle = cellstr(num2str(myTitle(:)));
end

if ~exist('withDetails','var')
    withDetails = 1;
end

nSubplots = size(map,3);
if nSubplots>1
    set(gcf,'position',[87   804   360*nSubplots   226])
else
    set(gcf,'position', [219   615   455   340]);
end

for i = 1:nSubplots
    subplot(1,nSubplots,i);
    imagesc(map(:,:,i))
    axis xy
%     colormap jet

    if withDetails
        colorbar
        set(gca,'FontSize',16)
        xlabel('\beta','interpreter','tex')
        ylabel('N')
        xTicks = get(gca,'XTickLabel');
        xTicks = str2double(xTicks);
        newxTicks = beta(xTicks);
        newxTicksStr = prepare_formatted_cellarray(newxTicks,'%.2f');
        set(gca, 'XTickLabel', newxTicksStr );
        title(myTitle{i})
    else
        set(gca, 'XTickLabel', '' );
        set(gca, 'YTickLabel', '' );
    end

end