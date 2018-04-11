%% SUPERRESOLUTION GRAPHICAL USER INTERFACE DOCUMENTATION

%% 1.- How to use this application.
%%
% The aim of this application is :                                                

%%
% 
% * To discover the possibilities that Super Resolution (SR) offers, without any
% programming skills required
% * To enable users to easily test and compare different SR techniques that
% exist today
% * To offer a flexible project that anyone can modify to suit their needs,
% by adding new registration and reconstruction techniques (for a technical
% documentation on how the implementation was done, please refer to
% http://lcavwww.epfl.ch/reproducible_research/VandewalleSV05/SRTechDoc.pdf
% )
%%
% *1.1 Starting the GUI*
%%
% To start the GUI, simply type 'superresolution' in the MATLAB console,
% after having set MATLAB's current directory to where the files 'superresolution.m'
% and 'superresolution.fig' are located.
%%
% Note: If you would like to change the GUI in any way, type 'GUIDE
% superrestolution' in the console. You will need to do this if you would
% like to add new algorithms to the list for instance.
%% 
% *1.2 Loading images into the GUI*
%%
% To load a set of Low Resolution (LR) images into the GUI, you may choose
% to either:
%%
%
% * Load some of the test images that are provided with this package
% (located in the 'images' directory);
% * Load any set of LR images you may have;
% * Use the tool provided along with this GUI which can generate a number
% of LR images from a single, High Resolution (HR) image. This tool can be
% very useful when you want to artificially generate aliasing in you LR
% images, which can later be corrected by some Reconstruction Techniques.
%%
% In order to load a set of existing LR images, use the 'Add' button on the
% left side of the GUI. Once one or more images have been added, you may
% select one from the list in order to see a preview, along with some basic
% information. You can remove any selected image from the list by
% selecting it and clicking on the 'Remove' button. Use the 'Remove all
% images' button to clear the list completely.
%%
% If you prefer to create a set of LR images, use the 'Create LR images
% from a HR image' button. You will then be asked to provide a source
% image, the number of output LR images, and where to save them to if you
% want to keep them. After creation, and if you decided to automatically
% save the output LR images, they will automatically be loaded in the GUI
% for you.
%%
% *1.3 Setting up the options and generating the HR image*
%%
% Once you have loaded images into the GUI, you can choose the motion
% estimation algorithm that you want to use, and the reconstruction
% technique.
%%
% For the motion estimation, you can ask to estimate only the shifts, or
% both the shifts and the rotations. You may also choose to multiply each
% LR image with a Tukey Window, which will basically add a gradually-disapearing black border to
% it. This may be useful if the LR images were automatically generated using
% circular shifts for instance.
% Note that you can also choose to enter the motion parameters manually.
%%
% For the reconstruction techniques, you can specify the interpolation
% factor, and the percentage of the image that you want to process
% (starting from the middle of the image).
%%
% The last parameters are the Save Options. They enable you to
% automatically save the resulting HR image, either in the current
% directory, or in a specified directory. The image format used is
% uncompressed TIF, in order to avoid any unwanted compression artifacts.
%%
% For more details on the algorithms, see sections 3 and 4 of this
% document.

%% 2.- What is Super-Resolution?
%%
% Super-Resolution (SR) is a process by which a number of LR images are combined
% into a single HR image, which has a greater resolving power. SR is not
% only useful to enhance the ersolving power of an image; it can also, to
% some extent, reduce the aliasing noticably.

%% 3.- Motion Estimation algorithms
%%
% *3.1 Vandewalle et al. (EPFL)*
%%
% This method [1], developped at the EPFL, uses the property that a shift in
% the space domain is translated into a linear shift in the phase of the
% image's Fourrier Transform. Similarly, a rotation in the space domain is
% visible in the amplitude of the Fourrier Transform. Hence, the Vandewalle
% et al. motion estimation algorithm computes the images' Fourrier
% Transforms and determines the 1-D shifts in both their amplitudes and
% phases.
% One advantage of this method is that it discards high-frequency
% components, where aliasing may have occurred, in order to be more robust.

%%
% *3.2 Marcel et al.*
%%
% Similarly to the Vandewalle algorithm, the method of Marcel et al. [4] uses a
% frequency-domain analysis in order to determine the shift and rotation.

%%
% *3.3 Lucchese et al.*
%%
% Lucchese and Cortelazzo [3] developed a rotation
% estimation algorithm based on the property that the
% magnitude of the Fourier transformof an image and the mirrored
% version of the magnitude of the Fourier transform of a
% rotated image have a pair of orthogonal zero-crossing lines.
% The angle that these lines make with the axes is equal to half
% the rotation angle between the two images. The horizontal
% and vertical shifts are estimated afterwards using a standard
% phase correlation method.

%%
% *3.4 Keren et al.*
%%
% The motion estimation algorithm by Keren et al. [2] uses different, downsampled
% versions of the images to be analyzed in order to achieve its goal. First
% a 4x downsampled version of the images is used to perform an estimation
% of the shift and rotation using Taylor series. The same is done with 2x
% downsampling, but after correcting for the shifts and rotations estimated
% earlier. Finally, the same is done with the full-resolution images, in
% order to further fine-tune the estimates.

%% 4.- Reconstruction algorithms
%%
% *4.1 Interpolation*
% This method simply aligns all the images' pixels on a High Resolution
% grid, and then applies a bicubic interpolation using Matlab's built-in griddata
% function.
%%
% *4.2 Papoulis-Gerchberg*
% The Papoulis-Gerchberg algorithm is a kind of POCS (Projection onto
% Convex Sets) method. It places the given pixels on a HR grid, goes into
% the frequency domain to "cut" the high frequencies, and repeats the
% process until convergence.
%%
% *4.3 Iterated Back Projection*
% The idea behind Iterated Back Projection [6] is to start with a rough
% estimation of the HR image, and iteratively add to it a "gradient" image,
% which is nothing else than the sum of the errors between each LR image
% and the estimated HR image that went through the appropriate transforms
% (given by the motion estimates).
%%
% *4.4 Robust Super Resolution*
% Robust Super Resolution [7] is a more robust version of the above Iterated
% Back Projection. The only difference resides in the computation of the
% gradient, which is not given by the sum of all errors, but by the median
% of all errors. This brings robustness against outliners in the LR images.
%%
% *4.5 POCS*
% This Projection Onto Convex Sets method is similar to the
% Papoulis-Gerchberg method, but instead of cutting the high frequencies,
% the image goes through a low-pass filter that approximates the camera's
% PSF (point spread function).
%%
% *4.6 Structure-Adaptive Normalized Convolution*
% This algorithm is an implementation of a paper by Tuan Q. Pham et al. [5]. It uses normalized convolution (NC) to reconstruct a HR image from
% several LR images. Two options can be enabled for this algorithm: 
% * Noise robustness will analyze the images and determine which pixels are
% noisy in order not to use those.
% * A second pass can be perfomed in the correction, which will adapt the
% size and orientation of the gaussian filters used in the NC, resulting in
% a sharper HR image

%% 5.- Results filenames format
% The HR images that are automatically saved after processing are named
% according to which registration and reconstruction algorithm were used
% (result_xx_yy_n, where xx is the registration method, yy the
% reconstruction method, and n a number from 1 to 99):
%%
% *Registration*
%%
% * Man: manual
% * VA: Vandewalle et al. (EPFL)
% * MA: Marcel et al.
% * LU: Lucchese et at.
% * KE: Keren et al.
%%
% *Reconstruction*
%%
% * IN: Interpolation
% * PG: Papoulis-Gerchberg
% * BP: Iterated Back Projection
% * RS: Robust Super-Resolution
% * PO: POCS
% * NCxy: Normalized Convolution, where x=1 if noise correction was done
% and y=1 if a second pass was done.


%% 6.- References
%%
% * [1] P. Vandewalle, S. S�sstrunk and M. Vetterli, A Frequency Domain Approach to Registration of Aliased Images with Application to Super-Resolution, EURASIP Journal on Applied Signal Processing (special issue on Super-resolution), Vol. 2006, pp. Article ID 71459, 14 pages, 2006.
% * [2] D. Keren, S. Peleg, and R. Brada, Image sequence enhancement using sub-pixel displacement, in Proceedings IEEE Conference on Computer Vision and Pattern Recognition, June 1988, pp. 742-746.
% * [3] L. Lucchese and G. M. Cortelazzo, A noise-robust frequency domain technique for estimating planar roto-translations, IEEE Transactions on Signal Processing, vol. 48, no. 6, pp. 1769-1786, June 2000.
% * [4] B. Marcel, M. Briot, and R. Murrieta, Calcul de Translation et Rotation par la Transformation de Fourier, Traitement du Signal, vol. 14, no. 2, pp. 135-149, 1997.
% * [5] Tuan Q. Pham, Lucas J. van Vliet and Klamer Schutte, Robust Fusion of
% Irregularly Sampled Data Using Adaptive Normalized Convolution, EURASIP
% Journal on Applied Signal Processing, Vol. 2006, Article ID 83268, 12 pages, 2006.
% * [6] M. Irani and S. Peleg, Improving resolution by image registration,
% Graphical Models and Image Processing, 53:231-239, 1991.
% * [7] A. Zomet, A. Rav-Acha, and S. Peleg, Robust Super-Resolution, Proceedings international conference on computer vision and pattern 
% recognition (CVPR), 2001.

%% 7.- License.
% Copyright (C) 2005-2006 Laboratory of Audiovisual Communications (LCAV), 
% Ecole Polytechnique Federale de Lausanne (EPFL), 
% CH-1015 Lausanne, Switzerland 
% 
% This program is free software; you can redistribute it and/or modify it 
% under the terms of the GNU General Public License as published by the 
% Free Software Foundation; either version 2 of the License, or (at your 
% option) any later version. This software is distributed in the hope that 
% it will be useful, but without any warranty; without even the implied 
% warranty of merchantability or fitness for a particular purpose. 
% See the GNU General Public License for more details 
% (enclosed in the file GPL). 

%%
% Developed by Patrick Vandewalle, Karim Krichane, Patrick Zbinden. 
% Please send any comment or suggestion to superresolution@epfl.ch