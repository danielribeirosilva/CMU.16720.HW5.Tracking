clear all;clc;
addpaths;

%params
alpha = 0.3; %weight of pastpast

% load 5 initial rects
load('data/pooh/rects_frm992.mat');
firstFrame = 992;%992;
lastFrame = 2999;
vidname = 'pooh_lk.avi';

%for testing
rectsHistory = cell(lastFrame, 5);

%index to avoid making 5 calls every time
u = cell(1,5);
v = cell(1,5);
u1 = cell(1,5);
v1 = cell(1,5);
u2 = cell(1,5);
v2 = cell(1,5);
rects = cell(1,5);
rects{1} = rect_lear;
rects{2} = rect_rear;
rects{3} = rect_leye;
rects{4} = rect_reye;
rects{5} = rect_nose;

%load('rectsHistory.mat');
%for i=1:5
%    rects{i} = rectsHistory{firstFrame,i};
%end

poohpath = 'data/pooh';

% Open video writer
vidout  = VideoWriter(vidname);
vidout.FrameRate = 10;
open(vidout);

% Add frames to video
for iFrm = (firstFrame+1):lastFrame
    fprintf('frame: %i\n',iFrm);
	
	% Read images (t-1 and t)
    if iFrm > (firstFrame+1)
        Ipastpast = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm-2)));
    end
	Ipast = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm-1)));
    Inow = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm)));
	
    % compute the displacement for each of the 5 rectangles using LK
    for i=1:5
        
        if iFrm==(firstFrame+1)
            [u1{i},v1{i}] = LucasKanade(Ipast,Inow,rects{i});
            u2{i} = u1{i};
            v2{i} = v1{i};
        else
            [u1{i},v1{i}] = LucasKanade(Ipastpast,Inow,rectsHistory{iFrm-1,i});
            [u2{i},v2{i}] = LucasKanade(Ipast,Inow,rects{i});
            
            %adjust u1/v1 reference to rects
            u1{i} = u1{i} - (rects{i}(1) - rectsHistory{iFrm-1,i}(1));
            v1{i} = v1{i} - (rects{i}(2) - rectsHistory{iFrm-1,i}(2));
        end
        
        %combination
        u{i} = alpha*u1{i} + (1-alpha)*u2{i};
        v{i} = alpha*v1{i} + (1-alpha)*v2{i};
        
       
        rects{i}  = rects{i} + [u{i},v{i},u{i},v{i}];
        %test
        rectsHistory{iFrm,i} = rects{i};
    end
    
	hf = figure(1); clf; hold on;
    imshow(Inow);
    for i=1:5
       drawRect([rects{i}(1:2),rects{i}(3:4)-rects{i}(1:2)],'r',3);
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