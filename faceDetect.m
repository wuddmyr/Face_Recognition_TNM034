function croppedImage = faceDetect(img)
    
    % color correction
    compImg = colorCorrection(img);
    
    % skin detection
    skinMask = skinDetection(compImg);
    
    % find mouth 
    mouthCenter = findMouth(compImg);
    
    % find eyes
    [eyeMask, leftEyePos, rightEyePos] = findEyes(compImg, mouthCenter);
    
    % clean up
    eyeMap = eyeMask .* skinMask;
    
    % rotate face
    [rotatedEyeMap, rotatedImage, left, right] = faceRotation(eyeMap, compImg, leftEyePos, rightEyePos);
    
    % scale
    [scaledImage, posOfLeftEye] = imageScaling(rotatedEyeMap, rotatedImage, left, right);
    
    % crop
    croppedImage = cropImage(scaledImage, posOfLeftEye); 
    croppedImage = im2double(rgb2gray(croppedImage));
    
    % normalization
    croppedImage = (croppedImage - min(min(croppedImage))) / (max(max(croppedImage)) - min(min(croppedImage)) );
    
    % factor value chosen through obeservation and testing of the set
    factor = 0.74/mean(croppedImage(:)); 
    croppedImage = croppedImage*factor;
    croppedImage = reshape(croppedImage, [], 1); 
    
end