poohpath = 'data/pooh';
load(fullfile(poohpath,'mean_shape.mat'));
meanShape = ms;
scalesToPerturb = [1];
n = 10;
ann = load(fullfile(poohpath,'ann'));
u=1;
now_ann = reshape(ann(u,2:end), 2, 5)';
singleFrameAnnotation = now_ann;

p = genPerturbedConfigurations(singleFrameAnnotation, meanShape, n, scalesToPerturb);
pt = p';

I = imread(fullfile(poohpath,'training',sprintf('image-%04d.jpg', ann(u,1))));
imshow(I);        
hold on;   

plot(pt(:, 1), pt(:, 2), 'r+', 'MarkerSize', 15, 'LineWidth', 1);