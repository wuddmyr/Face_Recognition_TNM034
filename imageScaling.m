function [scaledImage, posOfLeftEye] = imageScaling(rotatedEyeMap, rotatedImage, leftEye, rightEye)

    x1=leftEye(1,1);
    x2=rightEye(1,1);

    [rows, columns] = size(rotatedEyeMap);

    % scalefactor is chosen by observing the images in the set
    scalefactor = 110/(x2-x1);

    newWidth = scalefactor * columns;
    newWidth = round(newWidth);
    scaledImage = imresize(rotatedImage, [rows newWidth]);
    rotatedEyeMap = imresize(rotatedEyeMap, [rows newWidth]);

    % get left eye pos
    eyeProp = regionprops(rotatedEyeMap, 'Centroid');
    posOfLeftEye = round(eyeProp(1).Centroid);

end