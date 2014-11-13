function models = SDMtrain(mean_shape, annotations)
% CV Fall 2014 - Provided Code
% You need to implement the SDM training phase in this function, and
% produce tracking models for Winnie the Pooh
%
% Input:
%   mean_shape:    A provided 5x2 matrix indicating the x and y coordinates of 5 control points
%   annotations:   A ground truth annotation for training images. Each row has the format
%                  [frame_num nose_x nose_y left_eye_x left_eye_y right_eye_x right_eye_y right_ear_x right_ear_y left_ear_x left_ear_y]
% Output:
%   models:        The models that you will use in SDMtrack for tracking
%

	models = [];
    
    
    %params
    dataPath = 'data/pooh';
    scalesToPerturb = [0.8 1 1.2];
    n = 200;
    nFrms = size(annotations, 1);
    perturbedConfigurations = cell(1,nFrms);
    nMappings = 5;

    %generate all initial perturbed configurations
    for u = 1:nFrms

            singleFrameAnnotation = reshape(annotations(u,2:end), 2, 5)';

            %get perturbed configurations
            perturbedConfigurations{u} = genPerturbedConfigurations(singleFrameAnnotation, mean_shape, n, scalesToPerturb);
    end
    
    
    for i = 1:nMappings
        
        %get displacement matrix
        D = genDisplacementMatrix(annotations, perturbedConfigurations);
        
        %get feature matrix
        F = genFeatureMatrix(dataPath, annotations, perturbedConfigurations);
        
        %lear mapping and update perturbations
        [perturbedConfigurations, W] = learnMappingAndUpdateConfigurations(D,F,perturbedConfigurations);
        
        models = [models W];
        
        fprintf('loss function: %d\n', norm(D(:)));
    end
    
    
    
    
    
    
end
