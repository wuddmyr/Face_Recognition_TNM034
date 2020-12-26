function compImg = colorCorrection(img)
    
    red = img(:,:,1);
    green = img(:,:,2);
    blue = img(:,:,3);
    
    % inverse of mean of individual color channels
    meanRed = 1/(mean(mean(red)));
    meanGreen = 1/(mean(mean(green)));
    meanBlue = 1/(mean(mean(blue)));
    
    % get max of the inverse-mean
    maxRGB = max(max(meanRed, meanGreen), meanBlue);
    
    meanRed = meanRed/maxRGB;
    meanGreen = meanGreen/maxRGB;
    meanBlue = meanBlue/maxRGB;
    
    red = red*meanRed;
    green = green*meanGreen;
    blue = blue*meanBlue;
    
    compImg = cat(3,red,green,blue);
    
end