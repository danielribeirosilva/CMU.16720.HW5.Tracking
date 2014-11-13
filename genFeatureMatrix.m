function F = genFeatureMatrix(dataPath, ann, perturbedConfigurations)
    
    F = [];
    
    for u=1:length(perturbedConfigurations)
        
        %get image
        I = imread(fullfile(dataPath,'training',sprintf('image-%04d.jpg', ann(u,1))));
        
        %get perturbations for this image
        fc = perturbedConfigurations{u};
        
        %extract SIFT features
        f = siftwrapper(I, fc);
        
        %normalize
        %norms = diag(sqrt(f'*f));
        %f = bsxfun(@times,1./norms',f);
        
        %reshape (n-by-640)
        f = f(:)';
        f = reshape(f,640,numel(f)/640)';
        
        %store
        F = [F; f];
        
    end
    
end