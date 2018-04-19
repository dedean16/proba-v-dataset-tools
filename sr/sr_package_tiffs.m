% Package TIFFs - PROBA-V dataset tools
% Package multiple TIFF images into one .mat data file
clear all; close all; clc

%% Parameters
% Folder containing selected image files
imgdir   = '../tilesmansel/LEVEL2A/22.58698_32.391353/10_RED/orig/';
savefile = 'imgset_dinges_orig';

cd_mfile;

imgset = uint16([]);                        % Initialise image set
filelist = dir(imgdir);                     % Get filelist

% Add all TIFF files to imgset array
for i = 1:length(filelist)                  % Iterate over files in imgdir
    
    f = filelist(i);
    if length(f.name) >= 4                  % Check filename length
        ext = f.name(end-3:end);            % File extension
        
        % TIFF files only
        if (strcmp(ext, 'tiff') || strcmp(ext, '.tif'))...
                && ~isempty(strfind(f.name, '_333M_'))
            
            img = imread([imgdir f.name]);  % Read image file
            imgset = cat(3, imgset, img);   % Add image to imgset array
        end
    end
end

% Save variable to file
save(savefile, 'imgset')                    % Save to file
setsize = size(imgset);
fprintf('Wrote set of %i images to file\n', setsize(3))
