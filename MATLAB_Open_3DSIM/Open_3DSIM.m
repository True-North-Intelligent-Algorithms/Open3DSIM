%% The main program of Open-3DSIM(MATLAB code)
%
% This program is finished by Caoruijie and professor Xipeng in Peking 
% University. 
%
% For some referrence:
% A. Smith, C.S., Slotman, J.A., Schermelleh, L. et al. Structured illumination
%    microscopy with noise-controlled image reconstructions. Nat Methods 18,
%    821–828 (2021). https://doi.org/10.1038/s41592-021-01167-7
% B. Wen, G., Li, S., Wang, L. et al. High-fidelity structured illumination
%    microscopy by point-spread-function engineering. Light Sci Appl 10, 70
%    (2021). https://doi.org/10.1038/s41377-021-00513-w
% C. Zhanghao, K., Chen, X., Liu, W. et al. Super-resolution imaging of
%    fluorescent dipoles via polarized structured illumination microscopy.
%    Nat Commun 10, 4694 (2019). https://doi.org/10.1038/s41467-019-12681-w
% D. Besson S., Leigh R. et al. Bringing Open Data to Whole Slide Imaging.
%    Digital Pathology ECDP 2019. Lecture Notes in Computer Science 11435(2019).
%    https://link.springer.com/chapter/10.1007/978-3-030-23937-4_1
% E. Cris Luengo (2022). DIPimage (https://github.com/DIPlib/diplib), GitHub.
%    Retrieved December 10, 2022.
%
% For any question, please contact: caoruijie@stu.pku.edu.cn or 
% xipeng@pku.edu.cn
%
% We claim a Apache liscence for Open-3DSIM.

close all;
clc;
clear all;

addpath('.\help_functions\');
addpath('.\lib\bfmatlab\');
addpath('.\lib\diplib\share\DIPimage');
setenv('PATH',['.\lib\diplib\bin',';',getenv('PATH')]);

%% Read data
datasets = '.\input\OMX_Actin_488_1518.tif'; % The input data file (dv/tiff/tif are supported)
output = '.\output\';                     % Output file folder for WF/SIM result
numchannels = 1;                          % Total channels
jchannel = 1;                             % Selected channel
numframes = 1;                            % Total frames
jframe = 1;                               % Selected frame
read_type = 1;                            % 1: OMX-SIM, 2:NSIM, 3:Home-built-SIM
disp('-----------Reading data-----------')

status = bfCheckJavaPath(1);
[file, path] = uigetfile(bfGetFileExtensions, 'Choose a file to open');
datasets = [path file];

[dataparams,WF,Nx,Ny,Nz,raw_image] = read_data(datasets,output,numchannels,numframes,jchannel,jframe,read_type);

%% Process data
if read_type == 1
    % Old values...
    % rawpixelsize = [80 80 125]; % pixel size and focal stack spacing (nm)
    % NA = 1.4;                   % objective lens NA
    % refmed = 1.47;              % refractive index medium
    % refcov = 1.512;             % refractive index cover slip
    % refimm = 1.515;             % refractive index immersion medium
    % exwavelength - 488;         % excitation wavelengths
    % emwavelength = 528;         % emission wavelengths

    % new values for Janelia Cyro-SIM
    % NEED TO MANUAL CHANGE THESE VALUES TO CORRECT PIXEL SIZE, NA, RI, and
    % WAVELENGTHS OF THE DATA TO BE PROCESSED
    rawpixelsize = [130 130 250];
    NA = 0.85;                   % objective lens NA
    refmed = 1.01;              % refractive index medium
    refcov = 1.01;             % refractive index cover slip
    refimm = 1.01;             % refractive index immersion medium
    exwavelength = 488;         % excitation wavelengths
    emwavelength = 488;         % emission wavelengths
    fwd = 140e3;                % free working distance from objective to cover slip
    depth = 0;                  % depth of imaged slice from the cover slip
elseif read_type == 2
    rawpixelsize = [65 65 120]; % pixel size and focal stack spacing (nm)
    NA = 1.49;                  % objective lens NA
    refmed = 1.52;              % refractive index medium
    refcov = 1.512;             % refractive index cover slip
    refimm = 1.512;             % refractive index immersion medium
    exwavelength = 488;         % excitation wavelengths
    emwavelength = 525;         % emission wavelengths
    fwd = 120e3;                % free working distance from objective to cover slip (um)
    depth = 0;                  % depth of imaged slice from the cover slip (um)
else
    rawpixelsize = [65 65 125]; % pixel size and focal stack spacing (nm)
    NA = 1.49;                  % objective lens NA
    refmed = 1.47;              % refractive index medium
    refcov = 1.512;             % refractive index cover slip
    refimm = 1.515;             % refractive index immersion medium
    exwavelength = 561;         % excitation wavelengths
    emwavelength = 610;         % emission wavelengths
    fwd = 120e3;                % free working distance from objective to cover slip (um)
    depth = 0;                  % depth of imaged slice from the cover slip (um)
end

% BN I think the first set of notches are used for the OTF
notchwidthxy1 = 2.*Nx/1024;    % notch_width to design Filter
notchdips1 = 1.;              % notch_depth to design Filter

% Second set used for the image ? 
notchwidthxy2 = 2.*Ny/1024;    % notch_width to notch
notchdips2 = 1.;              % notch_depth to notch

% for reference original values... larger values seem to work better with
% low NA Cyro SIM. 
%notchwidthxy1 = 0.4*Nx/1024;    % notch_width to design Filter
%notchdips1 = .92;              % notch_depth to design Filter
%notchwidthxy2 = 0.5*Ny/1024;    % notch_width to notch
%notchdips2 = .98;              % notch_depth to notch

OTFflag = 1;                    % if OTFflag == 1,simulated OTF; if OTFfla == 0 ,experimental OTF
OTF_name = 'C:\Users\bnort\work\Janelia\code\Open3DSIM\MATLAB_Open_3DSIM\input\otf.bin';
num_taper = 0;
attenuation = 0;
disp('-----------Processing data-----------')
[dataparams,freq,ang,pha,module,sum_fft,sum_fft_0] = process_data(dataparams,rawpixelsize,NA,refmed,refcov,refimm,exwavelength,emwavelength,fwd,depth,notchwidthxy1,notchdips1,notchwidthxy2,notchdips2,OTFflag,OTF_name,num_taper,attenuation);


% sum_fft_0 is the shifted FFTs of each angle and order
% inverse FFT is a reconstructed image with each band shifted to 
% the right location but no other processing
no_processing_image = real(fftshift(ifftn(ifftshift(sum_fft_0))));

% sum_fft is the FFT after notch is applied. So inverse of this
% is a reconstructed image with only notch filtering but no OTF based
% frequency filtering 
notch_image = real(fftshift(ifftn(ifftshift(sum_fft))));

output_path = strrep(dataparams.datasets, 'input', 'output');

% save unprocessed image
output_path_temp = regexprep(output_path, '\.mrc$', sprintf('_no_process.mrc'));
stackwrite(single(no_processing_image), output_path_temp);

% save image obtained after notching (but no wiener like filter) 
output_path_temp = regexprep(output_path, '\.mrc$', sprintf('_notch_%.3f_%.3f.mrc', notchwidthxy1, notchdips1));
stackwrite(single(notch_image), output_path_temp);

%% Filter note that lambda is really high... (defaults were high too
% so frequency filter doesn't have too much of an effect...)
lambdaregul1 = 0.5;           % parameter to constuct Filter1
lambdaregul2 = 0.2;           % parameter to constuct Filter2

% for reference original values
%lambdaregul1 = 0.5;
%lambdaregul2 = 0.1;

disp('-----------Filtering and reconstrcuting-----------')
% BN Note now we also return final_image and the abs image so we can see what image
% looks like without doing the abs operation (seems to be much closer to
% simrecon)
[final_image, final_image_abs] = filter_3D(dataparams,sum_fft,Nx,Ny,Nz,lambdaregul1,lambdaregul2,output);

output_path = strrep(dataparams.datasets, 'input', 'output');

% save final image without doing abs
output_path_temp = regexprep(output_path, '\.mrc$', sprintf('_filter_%.4f_%.4f_notch_%.3f_%.3f.mrc', lambdaregul1, lambdaregul2, notchwidthxy1,notchdips1));
stackwrite(single(real(final_image)), output_path_temp)

% save final image with abs
output_path_temp = regexprep(output_path, '\.mrc$', sprintf('_filter_%.4f_%.4f_notch_%.3f_%.3f_abs.mrc', lambdaregul1, lambdaregul2, notchwidthxy1, notchdips1));
stackwrite(single(final_image_abs), output_path_temp)

%% polarized-SIM
%{
calib1_file = '.\input\calib488_1.tif';
calib2_file = '.\input\calib488_2.tif';
calib_type = 1;               % 1-do calibration
disp('-----------pSIMing-----------')
[psim_image] = pSIM(raw_image,final_image,ang,calib1_file,calib2_file,Nz,Nx,Ny,output,calib_type);
%}
