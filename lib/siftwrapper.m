% CV Fall 2014 - Provided Code
% DO NOT MODIFY THIS SCRIPT!!!! 
% THIS SCRIPT WILL BE USED DURING GRADING. IF YOU WANT TO WRITE YOUR OWN 
% siftwrapper, CALL IT A DIFFERENT NAME
function d2 = siftwrapper(I, fc)
	%extract sift
	[f, d] = vl_sift(single(rgb2gray(I)), 'frames', fc);

	%vlfeat reorders to features according to scale, need to recover the original order
	d2 = zeros(128, size(fc, 2));
	for p = 1:size(fc, 2)
		[~, II] = min( sum( bsxfun(@minus, f, fc(:,p)).^2, 1 ) );
		d2(:, p) = d(:, II);
	end
end
