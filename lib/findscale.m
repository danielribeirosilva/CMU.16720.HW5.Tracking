% CV Fall 2014 - Provided Code
% DO NOT MODIFY THIS SCRIPT!!!! THIS SCRIPT WILL BE USED DURING GRADING. 
% IF YOU WANT TO WRITE YOUR OWN findscale, CALL IT A DIFFERENT NAME
% now, mean_shape: 2-by-N matrices containing [x;y] for each column
function scale = findscale(current_shape, mean_shape) 
	tform = cp2tform(current_shape, mean_shape, 'affine');
	T = tform.tdata.T';
	sx = sqrt(T(1)^2 + T(4)^2);
	sy = sqrt(T(2)^2 + T(5)^2);
	scale = mean([sx, sy]);
end
