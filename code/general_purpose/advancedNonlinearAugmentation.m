function augmentedImage = advancedNonlinearAugmentation(image)
    % Apply random combination of advanced augmentation techniques
    
    % Random geometric transformation
    augmentedImage = randomGeometricTransformation(image);
    
    % Random color adjustment
    augmentedImage = randomColorAdjustment(augmentedImage);
    
    % Random filter
    augmentedImage = randomFilter(augmentedImage);

    % Apply any additional advanced nonlinear transformations as needed
    
end

function augmentedImage = randomGeometricTransformation(image)
    % Apply random geometric transformation

    % Random scaling
    scale_factor = rand(1) * 0.5 + 0.75; % Scale factor between 0.75 and 1.25
    scaled_image = imresize(image, scale_factor);

    % Random rotation
    rotation_angle = rand(1) * 30 - 15; % Rotation angle between -15 and 15 degrees
    rotated_image = imrotate(scaled_image, rotation_angle, 'bilinear', 'crop');

    % Random translation
    [h, w, ~] = size(rotated_image);
    tx = randi([-round(w/4), round(w/4)], 1); % Round to ensure integer values
    ty = randi([-round(h/4), round(h/4)], 1); % Round to ensure integer values
    augmentedImage = imtranslate(rotated_image, [tx, ty]);
end

function augmentedImage = randomColorAdjustment(image)
    % Apply random color adjustment

    % Random brightness adjustment
    brightness_factor = rand(1) * 0.5 + 0.75; % Brightness factor between 0.75 and 1.25
    augmentedImage = image * brightness_factor;
    
    % Random contrast adjustment
    contrast_factor = rand(1) * 0.5 + 0.75; % Contrast factor between 0.75 and 1.25
    augmentedImage = augmentedImage - mean(augmentedImage(:)); % Centering
    augmentedImage = augmentedImage * contrast_factor;
    augmentedImage = augmentedImage + mean(image(:)); % Re-centering
end

function augmentedImage = randomFilter(image)
    % Apply random filter to each color channel separately

    % Random choice of filter
    filter_type = randi([1, 3], 1); % Choose from 1 to 3 (e.g., median, gaussian, or sharpen)
    augmentedImage = zeros(size(image)); % Initialize the output
    
    switch filter_type
        case 1
            for i = 1:size(image, 3)
                augmentedImage(:,:,i) = medfilt2(image(:,:,i), [3, 3]); % Median filter
            end
        case 2
            h = fspecial('gaussian', [5, 5], 1); % Gaussian filter
            for i = 1:size(image, 3)
                augmentedImage(:,:,i) = imfilter(image(:,:,i), h, 'symmetric');
            end
        case 3
            h = fspecial('unsharp'); % Unsharp mask (sharpening filter)
            for i = 1:size(image, 3)
                augmentedImage(:,:,i) = imfilter(image(:,:,i), h);
            end
    end
end


% Example usage:
% originalImage = imread('example_image.jpg');
% augmentedImage = advancedNonlinearAugmentation(originalImage);
% imshowpair(originalImage, augmentedImage, 'montage');