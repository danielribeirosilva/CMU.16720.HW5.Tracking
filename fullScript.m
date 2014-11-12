clear all;clc;

dataPath = 'data/pooh';

%load mean shape
meanShape = importdata(fullfile(dataPath, 'mean_shape.mat'));
%load annotated data
ann = load(fullfile(dataPath,'ann'));

%params
scalesToPerturb = [0.8 1 1.2];
n = 100;
nFrms = size(ann, 1);
perturbedConfigurations = cell(1,nFrms);

%generate all perturbed configurations
for u = 1:nFrms
        
        singleFrameAnnotation = reshape(ann(u,2:end), 2, 5)';
        
        %get perturbed configurations
        perturbedConfigurations{u} = genPerturbedConfigurations(singleFrameAnnotation, meanShape, n, scalesToPerturb);
end

D = genDisplacementMatrix(ann, perturbedConfigurations);

F = genFeatureMatrix(dataPath, ann, perturbedConfigurations);