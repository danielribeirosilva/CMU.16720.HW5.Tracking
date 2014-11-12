function [] = drawFrameX(iFrm, rects)
    poohpath = 'data/pooh';
    I = imread(fullfile(poohpath, 'testing', sprintf('image-%04d.jpg',iFrm)));
    figure(1); clf; hold on;
    imshow(I);
    for i=1:5
       drawRect([rects{iFrm,i}(1:2),rects{iFrm,i}(3:4)-rects{iFrm,i}(1:2)],'r',3);
    end
    text(80,50,['frame ',num2str(iFrm)],'color','y','fontsize',30);
    hold off;
    title('Pooh tracker with Lucas-Kanade Tracker');
    drawnow;
end