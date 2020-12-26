function skinMask = skinDetection(compImg)

    % threshold values obtained after testing
    Ymin = 70;
    cbMin = 110;
    cbMax = 180;
    crMin = 129;
    crMax = 185;

    % allocate memory
    im = zeros(size(compImg,1), size(compImg,2));

    % --- SKIN DETECTION WITH YCBCR --- %
    YCbCr = rgb2ycbcr(compImg);

    % find face-skin px
    for i = 1:size(im,1)
        for j = 1:size(im, 2)
            Y = YCbCr(i,j,1); 
            Cb = YCbCr(i,j,2);
            Cr = YCbCr(i,j,3);
            if((Y > Ymin) && (cbMin <= Cb && Cb <= cbMax ) && (crMin <= Cr && Cr <= crMax))
                im(i,j) = 1;  %found face-skin
            end
        end
    end 
    
    % morph operations - this part can be reduced. 
    im = imfill(im, 'holes');
    im = imdilate(im, strel('square', 6));
    im = imfill(im, 'holes');
    im = logical(im);
    im = bwareafilt(im,1);
    im = imerode(im, strel('disk', 8));
    im = bwareafilt(im,1);    
    skinMask = imfill(im, 'holes');
end