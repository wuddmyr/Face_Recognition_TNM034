myFolder = './DB1';
filePattern = fullfile(myFolder, '*.jpg');
theFiles = dir(filePattern);
    
load('PCA.mat', 'eigenFaces', 'meanFaceVector', 'weights');
results = double(zeros(16, 5));

   for j = 1:length(theFiles)
    
    baseFileName = theFiles(j).name;
    fullFileName = fullfile(theFiles(j).folder, baseFileName);

    correctHits = 0;
    FRR = 0;
    FAR = 0;
    
        % Each image is looped 50 times. Add desired operations in "Tests"
        for i = 1:50
            im = imread(fullFileName);

            % --- Tests --- %
            % angle = -5 + (5+5)*rand(1);
            % im = imrotate(im, angle);
            
            % scale = 0.9 + (1.1-0.9)*rand(1);
            % im = imresize(im, scale);

            % tone = 0.7 + (1.3-0.7)*rand(1);
            % im = im .* tone;
        
            %-------------------------------- %
            % catch if mouth or eyes not found -> id = -1
            try
                croppedImage = faceDetect(im);

                newMeanFace = croppedImage-meanFaceVector;
                newWeight = eigenFaces'*newMeanFace;

                weightDeviation = zeros(16,16);
                for k = 1:16
                    weightDeviation(:,k) = weights(:,k) - newWeight(:);
                end

                weightDeviation = sum(abs(weightDeviation));

                [minDeviation, index] = min((weightDeviation))

                if(minDeviation < 1500) %min value from db0 ~1790

                    id = index
                else 
                    id = 0
                end
            catch
                id = -1;
            end
            
            if (minDeviation < 1500 && j ~=index)
                FAR = FAR+1
            elseif(minDeviation > 1500 && j ==index)
                FRR = FRR+1 
            end
            if(id == j)
                correctHits= correctHits+1;
            end
        end
        results(j,:) = [j, correctHits, correctHits/50, FAR, FRR];
   end
     
 results

