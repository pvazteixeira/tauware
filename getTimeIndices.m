function [ ts1_idx, ts2_idx ] = getTimeIndices( ts1, ts2, skip )
%UNTITLED3 Compute indices for the common time interval between two
%timestamp vectors
%   This function returns the indices corresponding to the time interval
%   for which the two input timestamp vectors overlap - think of it as a
%   special version of matlab's intersect().

    % determine start
    if ts1(1)>ts2(1)
        % ts2 begins first 
        d = abs(ts2 - ts1(1));
        idx1start = 1;
        [~,idx2start] = min(d);
    else
        % ts1 begins first
        d = abs(ts1 - ts2(1));
        idx2start = 1;
        [~,idx1start] = min(d);
    end

    % determine end
    if ts1(end)>ts2(end)
        % ts1 ends last 
        d = abs(ts1 - ts2(end));
        idx2end = size(ts2);
        [~,idx1end] = min(d);
    else
        % ts2 ends last
        d = abs(ts2 - ts1(end));
        idx1end = size(ts1);
        [~,idx2end] = min(d);
    end

%     skip = 10*30; % assuming Fs = 30, skip the first 6 seconds (transient)
    
    ts1_idx = (idx1start+skip):idx1end;
    ts2_idx = (idx2start+skip):idx2end;
end

