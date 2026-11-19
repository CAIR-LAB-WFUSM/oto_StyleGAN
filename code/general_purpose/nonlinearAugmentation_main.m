function augmentedImage = nonlinearAugmentation(image)
    % Apply random geometric transformation

    % Random scaling
    scale_factor = rand(1) * 0.5 + 0.75; % Scale factor between 0.75 and 1.25
    scaled_image = imresize(image, scale_factor);

    % Random rotation
    rotation_angle = rand(1) * 30 - 15; % Rotation angle between -15 and 15 degrees
    rotated_image = imrotate(scaled_image, rotation_angle, 'bilinear', 'crop');

    % Random translation
    [h, w, ~] = size(rotated_image);
    tx = randi([-w/4, w/4], 1);
    ty = randi([-h/4, h/4], 1);
    translated_image = imtranslate(rotated_image, [tx, ty]);

    % Apply any additional nonlinear transformations as needed

    augmentedImage = translated_image;
end

% Example usage:
% originalImage = imread('example_image.jpg');
% augmentedImage = nonlinearAugmentation(originalImage);
% imshowpair(originalImage, augmentedImage, 'montage');