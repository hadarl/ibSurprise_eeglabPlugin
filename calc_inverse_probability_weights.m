function [w, sClustered, wUnique] = calc_inverse_probability_weights(s,empirical,pastLength,betaInd)

% declare_global_params;

if ~exist('empirical','var')
    empirical = 1;
end

if empirical % calculating empirical probabilities

    sUniq = unique(s);
    pSUniq = -1*ones(size(sUniq));

    for i = 1:length(sUniq)
        pSUniq(i) = sum(s==sUniq(i))/length(s);
    end

    pN = -1*ones(length(s),1);

    for i = 1:length(pN)
        pN(i) = pSUniq(sUniq==s(i));
    end

    w = 1./pN;
    % Normalizing to have a mean weight equal to 1:
    w = w/mean(w);
    w = w';

else

    % Calculating the probability for the next element given the last elements:

        N = pastLength;
        k = 0:N;
        pXY_1 = (k+1)/((N+1)*(N+2));
        pXY_0 = (N-k+1)/((N+1)*(N+2));
        pXY = [pXY_0' pXY_1'];

    if ~exist('betaInd','var') % Calculating p(n)
        % n is the number of occurrences of the OTHER tone
        % p(n) = p(x=n,y=0) + p(x=N-n,y=1)
        % if n is large (lower probability) we want to give a higher weight
        pnOdd = pXY(:,1) + flipud(pXY(:,2));
        nSequence = s; % starts from 0
        pnOddSequence = pnOdd(nSequence+1);
        w = 1./pnOddSequence;
        % Normalizing to have a mean weight equal to 1:
        w = w/mean(w);
        wUnique = 1./pnOdd;
        wUnique = wUnique./mean(w);
        sClustered = [];

    else % Calculating IB p(s) weights

        % calculating probabilities using p(x,y)
        % find all the p(x,y) with the same surprise value
        % calculate p(s) by summing up over all x,y pairs with the same
        % surprise

        thresh = 10^-4;

        n = pastLength;
        file = sprintf('IB_probs\\pXhat_X_%d_%d.mat',N,betaInd);
        if exist(file,'file')
            pXhat_X = importdata(file);
            file = sprintf('IB_probs\\pY_Xhat_%d_%d.mat',N,betaInd);
            pY_Xhat = importdata(file);
        else
            p0Xhat_X = eye(n+1);
            [pXhat_X, pY_Xhat] = IB(pXY,betaVec(betaInd),p0Xhat_X);
        end

        sXY = -log2(pY_Xhat) *pXhat_X;

        sXY = sXY';
        assert(size(sXY,2)==2)

        sXYvec = reshape(sXY,[],1);

        [sXYvecSorted, inds1, inverseInds1] = my_sort(sXYvec);

        if 0 %manualMerge

            % Merging surprise values:
            finishedMergeSurprise = 0;
            while ~finishedMergeSurprise
                % Finding the next surprise value that should be merged
                surpriseDiff = [0; diff( sXYvecSorted)];
                indsNewValue = [find(surpriseDiff); length(sXYvecSorted)+1];
                % Allowing a difference up to thresh (not included):
                mergeSurprise = find(surpriseDiff > 0 & surpriseDiff < thresh );

                if isempty(mergeSurprise)
                    finishedMergeSurprise = 1;
                    break
                end

                mergeInd1 = mergeSurprise(1);
                mergeInd2 = indsNewValue(find(indsNewValue==mergeInd1)+1)-1;
                % In case tha last element in sXYvecSorted is unique
                %         if mergeInd2 > length(sXYvecSorted)
                %             mergeInd2 = length(sXYvecSorted);
                %         end

                % mergeSurprise is a subset of indsNewValue
                sXYvecSorted( mergeInd1: mergeInd2) = sXYvecSorted( mergeInd1-1);
            end

        else % merge surprise using histogram
            maxS = 10; % Assuming surprise values don't exceed 10
            nBins = maxS/thresh;
            srg = linspace(thresh/10,maxS,nBins); % The division in 10 is in
            % order to make sure that that diff(srg) will be larger than thresh
            [~,whichedge] = histc(sXYvecSorted,srg(:)');
            sXYvecSorted = srg(whichedge)';

            surpriseDiff = [0; diff( sXYvecSorted)];
            % assert that none of the surprise values are closer than thresh:
            assert(~any(surpriseDiff > 0 & surpriseDiff < thresh ))

        end

        newCluster = (surpriseDiff >= thresh);
        uniqueS1 = [sXYvecSorted(1) ; sXYvecSorted(newCluster)];
        clusters = cumsum( newCluster) + 1;
        nClusters = max(clusters);

        clustersUnSorted = clusters(inverseInds1);
        clustersMat = reshape(clustersUnSorted, [], 2);

        assert(all(size(sXY) == size(pXY)))
        pXYvec = reshape(pXY,[],1);

        % The INDEXING of pXYvec, clustersUnSorted and sXYvec
        % SHOULD BE THE SAME AT THIS POINT!
        % To change back to matrix use:
        % assert(size(pXYvec,2)==1)
        % reshape(pXYvec,[], 2)

        pS_calculated = zeros(1,nClusters);
        for i = 1:nClusters
            %     pXYvec( clustersUnSorted==i)
            pS_calculated(i) = sum( pXYvec( clustersUnSorted==i));
        end
        % Note: the indexing of pS_calculated should be the same as uniqueS1

        if any(pS_calculated==0)
            error('There are zero values in pS_calculated')
        end

        % Finding the right pS for each s in the sequence
        pS_sequence = zeros(1,length(s));
        sClustered = zeros(1,length(s));
        for i = 1:length(uniqueS1)
            inds = (s<uniqueS1(i)+thresh) & (s>uniqueS1(i)-thresh);
            pS_sequence(inds) = pS_calculated(i);
            sClustered(inds) = uniqueS1(i);
        end

%         if any(sClustered==0)
%             error('There are zero surprise values')
%         end

        assert(all(sClustered~=0), 'There are zero surprise values')

        if any(pS_sequence==0)
            error('There are zero values in pS_sequence (but not in pS_calculated)')
        end


        pN = pS_sequence;

        w = 1./pN;
        % Normalizing to have a mean weight equal to 1:
        w = w/mean(w);
    end

end