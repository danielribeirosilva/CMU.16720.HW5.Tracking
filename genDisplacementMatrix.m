function D = genDisplacementMatrix(ann, perturbedConfigurations)
    
    D = [];
    
    for u = 1:size(ann, 1)
        
        %get anotation
        singleFrameAnnotation = reshape(ann(u,2:end), 2, 5)';
        
        %get perturbed configuration
        perturbedConfiguration = perturbedConfigurations{u};
        perturbedConfiguration = perturbedConfiguration(1:2,:)';
        
        %displacements for this image
        nReal = size(perturbedConfiguration,1) / size(singleFrameAnnotation,1);
        d = repmat(singleFrameAnnotation,nReal,1) - perturbedConfiguration;
        
        %adjust format
        d = d';
        d = d(:);
        d = reshape(d,10,numel(d)/10)';

        %record
        D = [D; d];
        
    end
    
end