% 
close all; clear; clc

nbins = 32;

% Input file
FileName      = 'imgset_nile_10RED_orig.mat';
PathName      = './';

% Fetch data from datastructure
imgstruct = load([PathName FileName]);
imgcell   = struct2cell(imgstruct);
imgset = imgcell{1};

% Iterate over images
[W, H, N] = size(imgset);
cnts = zeros(nbins,N);                  % Initialise count array
vals = zeros(nbins,N);                  % Initialise value array


% Iterate over images and make histograms
for n=1:N
    img = double(imgset(:,:,n));        % Take image from set
    [cnt, val] = hist(img(:), nbins);   % Make histogram of pixel values
    
    cnts(:,n) = cnt;                    % Add to array of value counts
    vals(:,n) = val;                    % Add to array of values
end

% Plot histograms
figure
plot(vals, cnts, '.-')
xlabel('Pixel value')
ylabel('Pixel count')
title(sprintf('Image set Nile 10-RED histograms - %i bins', nbins))

% Plot histogram statistics - mean
figure
[hAx,hLine1,hLine2] = plotyy(vals(:,1), mean(cnts,2), vals(:,1), std(cnts,0,2));
xlabel('Pixel value')
ylabel(hAx(1), 'Average Count')
ylabel(hAx(2), 'Standard Deviation of Count')
title(sprintf('Statistics of image set Nile 10-RED histograms - %i bins', nbins))
