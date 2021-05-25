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
        %% �����
   copy_mark_image = L1;
    image_part3 = (copy_mark_image == 1); 
    % total = bwarea(image_part3);
    % fprintf('total = %f\n', total);
    round_area  = regionprops(image_part3,'Area');
    a = round_area.Area;%ֻ���ṹ��ĵ�һ��ֵ�����a
    fprintf('round_area = %f\n', a*0.00557*0.00557);

    %���ܳ�
    girth = regionprops(image_part3,'Perimeter');
    % girth.Perimeter
    fprintf('s.Perimeter = %f\n', girth.Perimeter);

    %��߽��������ѡ������ֻ����10
    image_part1 = (L1 == 1);    
    
    %figure;imshow(image_part1);

    %���ɫ��Բ��������
    oval = regionprops(image_part1,'Eccentricity');%������ 0 < e < 1֮�䣬eԽС��Խ��Բ��
    % oval.Eccentricity
    fprintf('oval.Eccentricity = %f\n', oval.Eccentricity);
    imwrite(image_part1,[StrOut '\' num2str((h-1)*5+i) '.tif']);

end

