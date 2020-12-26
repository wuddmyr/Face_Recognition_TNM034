function mouthCenter = findMouth(compImg)

    threshold = 0.25;

    img = rgb2ycbcr(compImg);
    img = im2double(img);
    Cb = img(:,:,2);
    Cr = img(:,:,3);
    
    n = 0.95 * (mean2((Cr).^2)) / mean2(Cr./Cb);
    mouthMap = (Cr.^2) .* ((Cr.^2) - n.* (Cr./Cb)).^2;
    
    mouthMap = mouthMap.*255;
    
    % threshold in order to find mouth
    mouthMap(mouthMap > threshold) = 255; 

    % morphological operations to remove blob-px
    mouthMap = imerode(mouthMap, strel('disk', 4));
    mouthMap = imdilate(mouthMap, strel('disk', 7));
    
    mouthMap = (mouthMap - min(min(mouthMap))) / (max(max(mouthMap)) - min(min(mouthMap)) );

    % mouth is on lower half of image
    mouthMap = uint8(mouthMap);
    BW = logical(mouthMap);
    [rows, cols] = size(mouthMap);
    BW(1 : round((1/2)*rows), :) = 0; % top 
    mouthMap = BW;
    mouthMap = bwareafilt(mouthMap, 1);
    
    %find the coordinates of mouth   
    mouthProp = regionprops(mouthMap, 'Centroid');
    centroid = mouthProp.Centroid;
    mouthCenter = round(centroid);

%     % alternative 2:
%
%     % threshold value to erase 
%     threshold = 0.4; 
%     
%     % get Cb and Cr
%     img = rgb2ycbcr(compImg);
%     img = im2double(img);
%     Cb = img(:,:,2);
%     Cr = img(:,:,3);
%     
%     n = 0.95 * (mean((Cr).^2)) / mean(Cr./Cb);
%     mouthMap = (Cr.^2) .* ((Cr.^2) - n.* (Cr./Cb)).^2;
%     
%     % normalize
%     mouthMap = (mouthMap ./ max(mouthMap(:)));
%     
%     % dilate potential mouth
%     SE = strel('disk', 10);
%     mouthMap = imdilate(mouthMap, SE);
%     
%     % threshold to remove unwanted px
%     mouthMap = (mouthMap > threshold);
%     
%     % only keep largest blob -> mouth 
%     mouthMap = bwareafilt(mouthMap, 1, 'Largest');
%     
%     % get position of mouth
%     mouthProp = regionprops(mouthMap, 'Centroid');
%     centroid = mouthProp.Centroid;
%     mouthCenter = round(centroid);
%     
    

    
end