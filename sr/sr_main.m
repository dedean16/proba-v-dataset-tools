% Super Resolution - PROBA-V Dataset Tools
% [Hanson 2007]
% This script calls third party functions to perform superresolution
clear; close all; clc


%%===== Parameters =====%%
% SR Type, choose from: 'rbFast', 'rbRobust', 'rbSpline'
SRType        = 'rbRobust';

% Input file
FileName      = 'imgset_nile_ndvi_orig.mat';
PathName      = './';
SRsavepath    = './results/';
SRsuffix      = '_SR';
savenorm      = true;

% SR parameters
resFactor     = 3;
psfSize       = 3;
psfSig        = 1;

props.alpha   = 0.7;
props.beta    = 1;
props.lambda  = 0.04;
props.P       = 2;
props.maxIter = 20;
%========================%


%% Load .mat
handles.LR=LoadVideoMat([PathName FileName]);
handles.LRDisplayI = 1;
handles.prevHR = [];
handles.HR = [];


%% Registration
handles.D=RegisterImageSeq(handles.LR);


%% Get parameters
Hpsf = fspecial('gaussian', [psfSize psfSize], psfSig);

% Round translation to nearest neighbor
D=round(handles.D.*resFactor);

% Shift all images so D is bounded from 0-resFactor
Dr=floor(D/resFactor);
D=mod(D,resFactor)+resFactor;

LR = handles.LR;
[X,Y]=meshgrid(1:size(LR, 2), 1:size(LR, 1));

for i=1:size(LR, 3)
    LR(:,:,i)=interp2(X+Dr(i,1), Y+Dr(i,2), LR(:,:,i), X, Y, '*nearest');
end


%% SR
switch SRType
    
    case 'rbSpline'
        handles.HR=SplineSRInterp(LR, resFactor, Hpsf, props);
    
    case 'rbRobust'
        handles.HR=FastRobustSR(LR(3:end-2,3:end-2,:), D, resFactor, Hpsf, props);
        handles.HR=RobustSR(LR(3:end-2,3:end-2,:), D, handles.HR, resFactor, Hpsf, props);

    case 'rbFast'
        handles.HR=FastRobustSR(LR(3:end-2,3:end-2,:), D, resFactor, Hpsf, props);
end


%% Show SR image
figscale = 1.3;

% Show SR image
HRshow = handles.HR(3:end-1, 4:end-1);
imagesc(HRshow);
% colormap('gray')
colormap inferno
colorbar
title(sprintf('SR result - %s - %s', FileName, SRType),'Interpreter','none')

% Resize figure
fig = gcf;
set(fig, 'Units', 'Normalized')
set(gcf, 'Position', [0.25 0.13 0.50 0.76])

%% Save SR image
% Save SR image to file
imwrite(uint16(handles.HR), [SRsavepath FileName(1:end-4) SRsuffix '.tif']);

if savenorm     % Save normalized SR image to file (for the humans)
    HRnorm = uint8(handles.HR * 255/max(handles.HR(:)));
    imwrite(HRnorm, [SRsavepath FileName(1:end-4) SRsuffix '_norm.tif'])
end;


