% stitch histograms
%
% stitch histogram categories in one canvas
hists = dir('*.png');
%delete('canvas.png');
fig = figure;
row = 1;
length = size(hists, 1);
tot_rows = length/3;
for i = 1:3:length
    h1 = imread(hists(i).name);
    h2 = imread(hists(i+1).name);
    h3 = imread(hists(i+2).name);
    
    subplot(5, 3, row);
    imshow(h1);
    [~, name, ~] = fileparts(hists(i).name); 
    title(name);
    
    subplot(5, 3, row+1);
    imshow(h2);
    [~, name, ~] = fileparts(hists(i+1).name); 
    title(name);
    
    subplot(5, 3, row+2);
    imshow(h3);
    [~, name, ~] = fileparts(hists(i+2).name); 
    title(name);
    
    row = row+3;
end

print(fig, '-r1200', 'canvas', '-dpng')
%print(fig, '-r1200', '-djpg', 'test.jpg')