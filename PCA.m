myFolder = './DB1';
filePattern = fullfile(myFolder, '*.jpg');
theFiles = dir(filePattern);

% allocate memory
allFaces = double(zeros((206 * 301), 1));
allImages = allFaces;

for currentImage = 1:length(theFiles)
    
    % read img from folder/filename
    baseFileName = theFiles(currentImage).name;
    fullFileName = fullfile(theFiles(currentImage).folder, baseFileName);
    img = imread(fullFileName);
    
    croppedImage = faceDetect(img);
    
    % add all images to an array
    allImages(:,:,currentImage) = croppedImage;
    
    % flatting the image
    allFaces = allFaces + croppedImage;     
end

% number of images in DB1
l = length(allImages(1,1,:));

% calculate the mean
meanFaceVector = allFaces./l;

% allocate memory 
faceDeviationMatrix = double(zeros(length(meanFaceVector), l));

for i=1:l
    faceVector = im2double(reshape(allImages(:,:,i), [], 1));
    faceDeviation = faceVector - meanFaceVector;
    faceDeviationMatrix(:,i) = faceDeviation;
end

% calculate the covariance
cov = (faceDeviationMatrix')*faceDeviationMatrix;

% find eigenfaces
[eVector, ~] = eig(cov);
eigenFaces = faceDeviationMatrix * eVector;
weights = eigenFaces'*faceDeviationMatrix;

save('PCA', 'weights', 'eigenFaces', 'meanFaceVector')

% --- print eigenfaces --- %
% norm eigenfaces
% for j =1:16
%     x = eigenFaces(:, j);
%     eigenfaces2(:,:,j) = reshape(x, 301, 206);
%     eigenfaces2Norm(:,:,j) =  eigenfaces2(:,:,j)./norm(eigenfaces2(:,:,j));
% end
% 
% for e = 1:16
%     subplot3 = subplot(4, 4, e);
%     imshow(eigenfaces2Norm(:,:,e), [])
% end
