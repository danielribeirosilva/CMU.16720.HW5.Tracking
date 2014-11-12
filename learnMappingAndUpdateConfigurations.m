function [updatedConfigurations, W] = learnMappingAndUpdateConfigurations(D,F,perturbedConfigurations)
    
    updatedConfigurations = cell(1,length(perturbedConfigurations));

    %learn weight
    W = learnLS(F,D);
    
    for u=1:length(perturbedConfigurations)
        
        %get perturbed configurations
        pConf = perturbedConfigurations{u}(1:2,:);
        
        %reshape
        pConf = pConf(:);
        pConf = reshape(pConf,10,numel(pConf)/10)';
        
        %find new position
        n = size(pConf,1);
        idx = (n*(u-1) + 1):(n*u);
        f = F(idx,:);
        d = f*W;
        updatedConfigurations{u} = pConf + d;
        
    end
    
    
end