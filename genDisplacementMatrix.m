function D = genDisplacementMatrix(dataPath, n, scalesToPerturb)
    
    %load mean shape
    meanShape = importdata(fullfile(dataPath, 'mean_shape.mat'));
    %load annotated data
    ann = load(fullfile(dataPath,'ann'));
    
    D = [];
    
    for u = 1:size(ann, 1)
        
        singleFrameAnnotation = reshape(ann(u,2:end), 2, 5)';
        
        %get perturbed configurations
        perturbedConfiguration = genPerturbedConfigurations(singleFrameAnnotation, meanShape, n, scalesToPerturb);
        perturbedConfiguration = perturbedConfiguration(1:2,:)';
        
        %displacements for this image
        nReal = size(perturbedConfiguration,1) / size(singleFrameAnnotation,1);
        d = repmat(singleFrameAnnotation,nReal,1) - perturbedConfiguration;
        
        %adjust format
        d = d';
        d = d(:);
        d = reshape(d,numel(d)/10,10)';

        %record
        D = [D; d];
        
    end
    
end