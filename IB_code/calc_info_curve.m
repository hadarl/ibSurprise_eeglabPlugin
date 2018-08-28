function Info = calc_info_curve(pXY, betaVec, showPlots)

if ~exist('showPlots','var')
    showPlots = 1;
end

% pXY = [9:-1:1; 1:9]'
% pXY = pXY/sum(pXY(:))
if showPlots
    figure;
    imagesc(pXY')
    xlabel('x')
    ylabel('y')
end


% betaVec = logspace(0,3,n); %logspace ( power of min beta, power of max beta, number of beta values )
n = length(betaVec);
Info = zeros(n,2);
xDim =size(pXY,1);
p0Xhat_X = eye(xDim);
% p0Xhat_X = ones(xDim)/xDim;

for i = n:-1:1
    [pXhat_X, pY_Xhat] = IB(pXY,betaVec(i),p0Xhat_X);
    [Info(i,1), Info(i,2)] = info_curve_point(pXhat_X, pY_Xhat,pXY);
    p0Xhat_X = pXhat_X;
    if showPlots
        imagesc(pXhat_X)
        pause(0.1);
    end
end

if showPlots
    figure;
    plot(betaVec,Info(:,1))
    title('I(X;Xhat)');

    figure;
    plot(betaVec,Info(:,2))
    title('I(Xhat;Y)');

    figure;
    plot(Info(:,1),Info(:,2))
    title('I(Xhat;Y) as a function of I(X;Xhat)');

end