clc
clear
close all
path = 'E:\data\images\';
D = dir([path '*.tif']);
StrIn='E:\data\images';
StrOut='E:\data\images_output';
i=1;
for h= 1:length(D)
    boot=imread([StrIn '\' num2str(h) '.tif']);
    pic_1 = imcrop(boot,[186 202 183 183]);
    %figure;imshow(cc)
    L1 = extract_FAZ(pic_1);  
        %% 求面积
   copy_mark_image = L1;
    image_part3 = (copy_mark_image == 1); 
    % total = bwarea(image_part3);
    % fprintf('total = %f\n', total);
    round_area  = regionprops(image_part3,'Area');
    a = round_area.Area;%只将结构体的第一个值赋予给a
    fprintf('round_area = %f\n', a*0.00557*0.00557);

    %求周长
    girth = regionprops(image_part3,'Perimeter');
    % girth.Perimeter
    fprintf('s.Perimeter = %f\n', girth.Perimeter);

    %这边进行区域的选择，例如只保留10
    image_part1 = (L1 == 1);    
    
    %figure;imshow(image_part1);

    %求红色椭圆的离心率
    oval = regionprops(image_part1,'Eccentricity');%离心率 0 < e < 1之间，e越小，越像圆。
    % oval.Eccentricity
    fprintf('oval.Eccentricity = %f\n', oval.Eccentricity);
    imwrite(image_part1,[StrOut '\' num2str((h-1)*5+i) '.tif']);

end

