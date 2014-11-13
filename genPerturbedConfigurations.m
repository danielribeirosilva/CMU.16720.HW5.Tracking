
%singleFrameAnnotation: 5x2 true components' location
%meanShape: 5x2 mean shape of components
%n: number of perturbed configurations to generate

function perturbedConfiguration = genPerturbedConfigurations(singleFrameAnnotation, meanShape, n, scalesToPerturb)

%params
nComponents = 5;
muPert = 4; %in pixels
nScales = numel(scalesToPerturb);
nPert = ceil(n/nScales);
nTrue = nPert*nScales;

%compute scales
scaleA = findscale(singleFrameAnnotation, meanShape);
scalesB = repmat(scalesToPerturb,nPert*nComponents,1);
scalesB = scalesB(:)';

%generate normallt distr. perturbations
pertX = repmat(muPert*randn(1,nTrue),nComponents,1);
pertX = pertX(:)';
pertY = repmat(muPert*randn(1,nTrue),nComponents,1);
pertY = pertY(:)';

%{
%translate mean shape to center
translationVector = mean(singleFrameAnnotation-meanShape);
ms = bsxfun(@plus,translationVector,meanShape);
%scale mean shape with both scales
ms = ms*scaleA;
centers = repmat(ms',1,nTrue);
centers = bsxfun(@times,scalesB,centers);
%}

%scale mean shape
scaledMeanShape = repmat(meanShape',1,nTrue);
scaledMeanShape = scaledMeanShape/scaleA;
scaledMeanShape = bsxfun(@times,scalesB,scaledMeanShape);
%translate mean shape to center
translationVector = mean(singleFrameAnnotation-(meanShape/scaleA));
centers = bsxfun(@plus,translationVector',scaledMeanShape);


%perturbed configurations
perturbedConfiguration = zeros(4,nTrue*nComponents);
%row 1
perturbedConfiguration(1,:) = centers(1,:) + pertX;
%row 2
perturbedConfiguration(2,:) = centers(2,:) + pertY;
%row 3
perturbedConfiguration(3,:) = repmat([7 4 4 10 10],1,nTrue)./(scalesB/scaleA);

end