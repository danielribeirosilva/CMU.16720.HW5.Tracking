function SDMtrack(models, mean_shape, start_location, start_frame, outvidfile)
% CV Fall 2014 - Provided Code
% You need to implement the SDM test phase in this function, and output a
% tracking video for Winnie the Pooh
%
% Input:
%   models:         The model you trained in SDMtrain.m
%   mean_shape:     A provided 5x2 matrix indicating the x and y coordinates of 5 control points
%   start_location: A initial location for the first frame to start tracking. It has the format
%                   [nose_x nose_y; left_eye_x left_eye_y; right_eye_x right_eye_y; right_nose_x right_nose_y; left_nose_x left_nose_y]
%   start_frame:    A frame index denoting which frame to start tracking
%   outvidfile:     A string indicating the output video file name (eg, 'vidout.avi')

    % Open video for writing	
	vidout = VideoWriter(outvidfile);
	vidout.FrameRate = 20;
	open(vidout);

    % ADD YOUR CODE HERE
    
    %--------------------------------------------------------------
    %--------------------------------------------------------------
    
    nModels = size(models,2)/10;
    
    %find and apply scale to mean shape
    scale = findscale(start_location, mean_shape);
    scaledMeanShape = mean_shape/scale;
    
    %translate mean shape to center
    translationVector = mean(start_location-scaledMeanShape);
    centers = bsxfun(@plus,translationVector,scaledMeanShape);
    
    %--------------------------------------------------------------
    %--------------------------------------------------------------
    
    %initialize
	current_shape = centers;    

	for iFrm = start_frame:1500
		% Load testing image
		I = imread(sprintf('data/pooh/testing/image-%04d.jpg', iFrm));

		% ADD YOUR CODE HERE
        % Store your initial guess as a 5x2 matrix named begin_shape (1st
        %     column indicates x-coordinate, and 2nd column indicates y-coordinate).
        % Store your final guess as a 5x2 matrix named current_shape (in the same format as begin_shape)

        
        %--------------------------------------------------------------
        %--------------------------------------------------------------
        
        %start where last frame ended
        begin_shape = current_shape;
        
        %apply linear all mappings consecutively
        for iMap = 1:nModels
            
            %generate SIFT features
            fc = [current_shape'; [7 4 4 10 10]/scale; zeros(1,5)];
            f = siftwrapper(I, fc);
            %normalize
            %norms = diag(sqrt(f'*f));
            %f = bsxfun(@ldivide,norms',f);

            %reshape (1-by-640)
            f = f(:)';
            f = reshape(f,640,1)';
            
            %get current model
            modelIdx = (1+(iMap-1)*10):(iMap*10);
            model = models(:,modelIdx);
            
            %compute displacement
            d = f*model;
            %reshape
            d = reshape(d,2,5)';
            
            %apply displacement
            current_shape = current_shape + d;
            
        end
        
        
        %--------------------------------------------------------------
        %--------------------------------------------------------------
        
        

		% Draw tracked location of parts
		% Red crosses should track Pooh's nose, eyes and ears
		figure(1);
		if ~exist('hh','var'), hh = imshow(I); hold on; 
		else set(hh,'cdata',I);
		end
		if ~exist('hPtBeg','var'), hPtBeg = plot(begin_shape(:,1), begin_shape(:,2), 'g+', 'MarkerSize', 15, 'LineWidth', 3);
		else set(hPtBeg,'xdata',begin_shape(:,1),'ydata',begin_shape(:,2));
		end
		if ~exist('hPtcurrent_shape','var'), hPtcurrent_shape = plot(current_shape(:,1), current_shape(:,2), 'r+', 'MarkerSize', 25, 'LineWidth', 5);
		else set(hPtcurrent_shape,'xdata',current_shape(:,1),'ydata',current_shape(:,2));
		end
		title(['frame ',num2str(iFrm)]);
		if ~exist('hFrmNum', 'var'), hFrmNum = text(30, 30, ['Frame: ',num2str(iFrm)], 'fontsize', 40, 'color', 'r');
		else set(hFrmNum, 'string', ['Frame: ',num2str(iFrm)]);
		end
		%resized so that video will not be too big
		frm = getframe;
		writeVideo(vidout, imresize(frm.cdata, 0.5));
	end
	
	% close vidobj
	close(vidout);
end
