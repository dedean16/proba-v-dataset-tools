% Package TIFFs - PROBA-V dataset tools
% Package multiple TIFF images into one .mat data file
clear all; close all; clc

%% Parameters
% Folder containing selected image files
imgdir   = '../tiles/LEVEL2A/22.58698_32.391353/10_ndvi/orig/';
savefile = 'imgset_nile_ndvi_orig';
ndvimode = true;

cd_mfile;

imgset = uint16([]);                        % Initialise image set as uint16
filelist = dir(imgdir);                     % Get filelist

% Add all TIFF files to imgset array
for i = 1:length(filelist)                  % Iterate over files in imgdir
    
    f = filelist(i);
    if length(f.name) >= 4                  % Check filename length
        ext = f.name(end-3:end);            % File extension
        
        % TIFF files only
        if strcmp(ext, '.png')...
                && ~isempty(strfind(f.name, '_333M_'))
            
            if ndvimode
                imgraw = imread([imgdir f.name]);  % Read image file
                img = uint16(2^15 + imgraw * 2^15);
            else
                img = uint16(imread([imgdir f.name]));  % Read image file as uint16
            end
            
            imgset = cat(3, imgset, img);   % Add image to imgset array
            
%             imagesc(img); colorbar
%             pause(0.7)
        end
    end
end

% Save variable to file
save(savefile, 'imgset')                    % Save to file
setsize = size(imgset);
fprintf('Wrote set of %i images to file %s\n', setsize(3), savefile)
