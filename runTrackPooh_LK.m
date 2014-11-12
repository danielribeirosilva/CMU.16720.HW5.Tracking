clear all;clc;
addpaths;

% load 5 initial rects
load('data/pooh/rects_frm992.mat');
firstFrame = 992;%992;
lastFrame = 2999;
vidname = 'pooh_lk_test.avi';

%for testing
rectsHistory = cell(lastFrame, 5);

%index to avoid making 5 calls every time
u = cell(1,5);
v = cell(1,5);
rects = cell(1,5);
rects{1} = rect_lear;
rects{2} = rect_rear;
rects{3} = rect_leye;
rects{4} = rect_reye;
rects{5} = rect_nose;
%for testing purposes
%load('rectsHistory.mat');
%for i=1:5
%    rects{i} = rectsHistory{firstFrame,i};
%end

rectsToDraw = rects;

poohpath = 'data/pooh';

% Open video writer
vidout  = VideoWriter(vidname);
vidout.FrameRate = 10;
open(vidout);

% Add frames to video
for iFrm = (firstFrame+1):lastFrame
    fprintf('frame: %i\n',iFrm);
	
	% Read images (t-1 and t)
	Ipast = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm-1)));
    Inow = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm)));
	
    % compute the displacement for each of the 5 rectangles using LK
    for i=1:5
       [u{i},v{i}] = LucasKanade(Ipast,Inow,rects{i});
       rects{i}  = rects{i} + [u{i},v{i},u{i},v{i}];
       %adjust rects to draw
       rectsToDraw{i}(1) = max(0,rects{i}(1));
       rectsToDraw{i}(2) = max(0,rects{i}(2));
       rectsToDraw{i}(3) = min(size(Inow,2),rects{i}(3));
       rectsToDraw{i}(4) = min(size(Inow,1),rects{i}(4));
       %test
       %rectsHistory{iFrm,i} = rects{i};
    end
    
	hf = figure(1); clf; hold on;
    imshow(Inow);
    for i=1:5
       drawRect([rectsToDraw{i}(1:2),rectsToDraw{i}(3:4)-rectsToDraw{i}(1:2)],'r',3);
    end
    text(80,50,['frame ',num2str(iFrm)],'color','y','fontsize',30);
    hold off;
    title('Pooh tracker with Lucas-Kanade Tracker');
    drawnow;
    
	
	% Write a frame to video, resized so that video will not be too big
	frm = getframe;
	writeVideo(vidout, imresize(frm.cdata, 0.5));
end

% Close video writer
close(vidout);
close(1);
fprintf('Video saved to %s\n', vidname);