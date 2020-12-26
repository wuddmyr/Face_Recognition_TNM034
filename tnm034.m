function id = tnm034(im)

    %%%%%%%%%%%%%%%%%%%%%%%%%%
    % --------------------------
    % Daniel Hagstedt, danha896
    % William Uddmyr, wilud321
    % Ludde Jahrl, ludja208
    % --------------------------
    %
    % im: Image of unknown face, RGB-image in uint8format inthe
    % range [0,255]
    %
    % id: The identity number (integer) of the identified person,
    % i.e.‘1’, ‘2’,...,‘16’for the persons belonging to ‘db1’ 
    % and ‘0’for allother faces.
    %
    % id is assigned as -1 if face features such as eyes, mouth etc 
    % cannot be found
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    
    % precalculated eigenfaces and corresponding weights
    load('PCA.mat', 'eigenFaces', 'meanFaceVector', 'weights');
    
    try
        croppedImage = faceDetect(im);

        newMeanFace = croppedImage-meanFaceVector;
        newWeight = eigenFaces'*newMeanFace;

        weightDeviation = zeros(16,16);
        for k = 1:16
            weightDeviation(:,k) = weights(:,k) - newWeight(:);
        end

        weightDeviation = sum(abs(weightDeviation));

        [minDeviation, index] = min((weightDeviation));

        if(minDeviation < 1500)
            id = index;
        else 
            id = 0;
        end
        
    catch
        id = -1;
    end
end
