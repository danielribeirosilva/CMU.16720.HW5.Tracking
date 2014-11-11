% CV Fall 2014 - Provided Code
% DO NOT MODIFY THIS SCRIPT!!!! 
% THIS SCRIPT WILL BE USED DURING GRADING. IF YOU WANT TO WRITE YOUR 
% OWN siftwrapper, CALL IT A DIFFERENT NAME.
function h = siftplot(I, fc, d)

h = imshow(I); hold on;
h3 = vl_plotsiftdescriptor(d,fc);
set(h3,'color','g') ;
plot(fc(1,:), fc(2,:), 'r+', 'linewidth', 4, 'markersize', 12);

end
