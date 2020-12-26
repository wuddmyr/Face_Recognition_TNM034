function [eyeImg, leftEyePos, rightEyePos] = findEyes(compImg, mouthCenter)

    % Implementation based on report "A hybrid method for eyes detection in facial images:
    % https://repository.lboro.ac.uk/articles/A_hybrid_method_for_eyes_detection_in_facial_images/9404018
    
    img = rgb2ycbcr(compImg);
    img = im2double(img);
    Y = img(:,:,1);
    Cb = img(:,:,2);
    Cr = img(:,:,3);
 
    % --- ILLUMINATION-BASED METHOD --- %
    Cb2 = (Cb.^2);
    Cr2 = (Cr.^2);
    Cr2Inv = (1-Cr2);
    CbCr = (Cb./Cr);
    
    eyeMapC = (1/3).*Cb2 + (1/3).*Cr2Inv + (1/3).*CbCr;
    eyeMapC = histeq(eyeMapC);
    
    SE = strel('disk', 5);
    nominator = imdilate(Y, SE);
    denominator = imerode(Y, SE);
    eyeMapL = nominator./(denominator + 1);
    
    eyeMap = eyeMapC .* eyeMapL;
    
    % --- COLOUR-BASED METHOD --- %
    grayImg = rgb2gray(compImg);
    grayImg = histeq(grayImg);
    
    % threshold 20 according to report - also gave best result
    threshold = 20;
    darkEyes = grayImg > threshold;
    
    % --- EDGE DENSITY-BASED METHOD --- %
    %detect edges using sobel
    grayImg = rgb2gray(compImg);
    sobelImg = edge(grayImg, 'sobel');
    
    % morph operations 
    SE = strel('disk', 4);  
    imgdil1 = imdilate(sobelImg, SE);
    imgdil2 = imdilate(imgdil1, SE);

    imger1 = imerode(imgdil2, SE);
    imger2 = imerode(imger1, SE);
    edgeDenImg = imerode(imger2, SE);
     
    % --- FIND EYES --- %
    threshold = 0.5; 
    
    % loop until two eyes found
    while 1
        eyeMap2 = eyeMap;
        eyeMap2 = imdilate(eyeMap2, strel('disk', 6));
 
        eyeMap2 = eyeMap2 > threshold;

        % apply rules 
        eyeMap2 = eyeRules(eyeMap2);
        darkEyes = eyeRules(darkEyes);
        edgeDenImg = eyeRules(edgeDenImg);

        % operations to remove blobs
        eyeMap_darkEyes = eyeMap2 & darkEyes; 
        eyeMap_edgeDenImg = eyeMap2 & edgeDenImg;
        darkEyes_edgeDenImg = darkEyes & edgeDenImg;

        % sum-image of all three methods
        eyeImg = eyeMap_darkEyes | eyeMap_edgeDenImg | darkEyes_edgeDenImg;

        % --- REMOVE REMAINING BLOBS - USING MOUTHPOS --- %    
        BW = logical(eyeImg);
        [rows, cols] = size(eyeImg);

        % set unrealistic top and bottom regions to 0
        BW(1 : mouthCenter(2) - round((2/7)*rows), :) = 0; % top 
        BW(mouthCenter(2) - round((1/7)*rows) : end , :) = 0; % bottom
        BW(: , 1 : mouthCenter(1) - round((1/5)*cols)) = 0; % left
        BW(: , mouthCenter(1) + round((1/4)*cols) : end) = 0; % right

        % only keep 2 largest blobs -> potential eyes
        eyeImg = BW;
        eyeImg = bwareafilt(eyeImg, 2); 

        % --- GET LEFT- AND RIGHT-EYE POS --- %
        eyeProp = regionprops(eyeImg, 'Centroid');
        if length(eyeProp) == 2
            leftEyePos = round(eyeProp(1).Centroid);
            rightEyePos = round(eyeProp(2).Centroid);
            return
        else
            if threshold <= 0.0001
                return
            else
                threshold = threshold - 0.1;
            end
        end
    end
end