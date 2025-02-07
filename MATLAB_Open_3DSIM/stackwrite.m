function stackwrite(imgStack, filename)
    % stackwrite saves a multi-component image stack as a multi-page TIFF file.
    %
    % Parameters:
    % imgStack: A 3D matrix (height x width x numComponents) representing the image stack.
    % filename: The name of the output TIFF file (e.g., 'output_image.tif').
    
    % Check if the input is a 3D matrix
    if ndims(imgStack) == 3
        % Get the dimensions of the image stack
        [height, width, numComponents] = size(imgStack);
    else
        [height, width] = size(imgStack);
        numComponents = 1;
     end
    
    % Create a Tiff object for writing
    t = Tiff(filename, 'w');
    
    % Define tag structure for TIFF
    tagstruct.ImageLength = height;
    tagstruct.ImageWidth = width;
    tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
    tagstruct.BitsPerSample = 32; % Set to 32 bits for floating-point images
    tagstruct.SamplesPerPixel = numComponents; % Number of components
    tagstruct.RowsPerStrip = 16;
    tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;
    tagstruct.Compression = Tiff.Compression.None; % Change as needed
    tagstruct.Software = 'MATLAB';
    tagstruct.SampleFormat = Tiff.SampleFormat.IEEEFP;
    
    % Set the tags for the TIFF file
    t.setTag(tagstruct);
    
    % Write the image data to the TIFF file as 32-bit floats
    t.write(single(imgStack)); % Convert to single if necessary
    
    % Close the Tiff object
    t.close();
end

