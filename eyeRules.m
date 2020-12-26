function image = eyeRules(img)
    % Based on: https://repository.lboro.ac.uk/articles/A_hybrid_method_for_eyes_detection_in_facial_images/9404018

    blobs = regionprops(img, 'Solidity', 'BoundingBox', 'Orientation', 'PixelList', 'Area');

    % remove blobs touching the border
    image = imclearborder(img);
    
    for i = 1:length(blobs)
        
        solidity = blobs(i).Solidity;
        
        width = blobs(i).BoundingBox(3);
        height = blobs(i).BoundingBox(4);
        aspectRatio = width/height;
        
        orientation = blobs(i).Orientation;
        
        % remove blobs that not does satisfy rules
        if ((solidity < 0.5) && (aspectRatio > 4.0 || aspectRatio < 0.8) && (orientation < -45 || orientation > 45))
            regionPx = blobs(i).PixelList;
            image(regionPx) = 0;
        end   
    end
end