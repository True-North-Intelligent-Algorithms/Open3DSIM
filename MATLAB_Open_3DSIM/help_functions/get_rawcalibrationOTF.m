function [OTF_orders,OTFinc] = get_rawcalibrationOTF(otf_path,SIMparams,numpixelsx,numpixelsy,rawpixelsize)

% copyright Sjoerd Stallinga, TU Delft, 2017-2020

% BN - get_rawcalibrationOTF is a hacked/WIP version of get_calibarionOTF
% that is tweaked to get the OTFs from Janelia Cyro SIM

%{
maxorder = 3;

% initialize output arrays
OTF_orders = zeros(SIMparams.numSIMpixelsx,SIMparams.numSIMpixelsy,maxorder,SIMparams.numSIMpixMATLelsz,1);
OTFinc =  zeros(numpixelsx,numpixelsy,SIMparams.numSIMpixelsz,1);

% loop over color channels
filenameOTFdata = allfilenamesOTFdata;

% read data, this is specific code for the OMX tiff files
a = bfopen(filenameOTFdata); % extract OTF data
img = double(cell2mat(permute(a{1}(:,1),[3 2 1])));
a = fftshift(img,2);

% ring averaged OTFs for Fourier orders
ringOTF = zeros(size(a,1),size(a,2),maxorder);
for jorder = 1:maxorder
    % ringOTF(:,:,jorder) = a(:,:,2*jorder-1)+1i.*a(:,:,2*jorder);
    ringOTF(:,:,jorder) = a(:,:,jorder);
end
%}

fid = fopen(otf_path, 'rb');
data = fread(fid, 'float32', 'ieee-be');
data = reshape(data, 2, []);
data = complex(data(1, :), data(2, :));

a = reshape(data, 65, 81, 3);
a = permute(a, [2,1,3]);
a = fftshift(a,2);

Nxybead = 2*(size(a,1)-1); % number of pixels in xy of bead calibration data
Nzbead = size(a,2); % number of focal slices of bead calibration data

ringOTF = a;
maxorder = 3;

clear img a % remove redundant variables

% bead data with Nxybead x Nxybead pixels and Nzbead focal slices,
% same pixel size and axial spacing as SIM data is assumed, giving the
% following Fourier pixel sizes in xy and in z

%deltaq_omx(1) = 1./(Nxybead*rawpixelsize(1));
%deltaq_omx(2) = 1./(Nxybead*rawpixelsize(2));
%deltaq_omx(3) = 1./(Nzbead*rawpixelsize(3));

deltaq_omx(1) = 1./(Nxybead*61.5);
deltaq_omx(2) = 1./(Nxybead*61.5);
deltaq_omx(3) = 1./(Nzbead*48.08);

% resample ring averaged OTF to full OTF of size
% numSIMpixels x numSIMpixels x numSIMfocus
allsampling = [SIMparams.numSIMpixelsx,SIMparams.numSIMpixelsy,SIMparams.numSIMpixelsz];
for jorder = 1:maxorder
    ringOTForder = squeeze(ringOTF(:,:,jorder));
    OTF_orders(:,:,jorder,:,1) = resample_calibrationOTF(ringOTForder,deltaq_omx,allsampling,SIMparams.SIMpixelsize);
end

OTFinc = squeeze(OTF_orders(:,:,1,:));
end



