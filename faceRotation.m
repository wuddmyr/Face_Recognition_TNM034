function [rotatedEyeMap, rotatedImage, left, right] = faceRotation(eyeMap, compImg, leftEyePos, rightEyePos)

    x1 = leftEyePos(1,1);
    y1 = leftEyePos(1,2);
    x2 = rightEyePos(1,1);
    y2 = rightEyePos(1,2);

    angle = -rad2deg(atan((y1-y2)/(x2-x1)));

    rotatedEyeMap = imrotate(eyeMap, angle);
    rotatedImage = imrotate(compImg, angle);
   
    rotatedEyeMap = uint8(rotatedEyeMap);
    rotatedEyeMap = logical(rotatedEyeMap);

    eyeProp = regionprops(rotatedEyeMap, 'Centroid');
    
    left = round(eyeProp(1).Centroid);
    right = round(eyeProp(2).Centroid);
    
    rotatedEyeMap = imresize(rotatedEyeMap,size(eyeMap));
end


