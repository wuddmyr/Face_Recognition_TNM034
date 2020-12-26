function croppedImage = cropImage(scaledImage, posOfLeftEye)

    x1 = posOfLeftEye(1) - 50; 
    y1 = posOfLeftEye(2) - 100; 
    x2 = 205; 
    y2 = 300;
    
    croppedImage = imcrop(scaledImage,[x1 y1 x2 y2]);
end