% %function [J_green,J_bi,J_green_imcom,J_bi_imcom] = img_imcompliment(I)
%     I = imread('DB1_66.jpg');
%     J_green = I(:,:,1);%ѡ����ɫͨ��,ֱ��ͼ���⻯
%     
%     J_bi=imbinarize(J_green);%���Ҷ�ͼ��ת���ɶ�ֵͼ�񣬸�ֵ��J1
%     J_green_imcom=imcomplement(J_green);%��Ҷ�ͼ��Ĳ�������ͼ����������㣬��ֵ��J2
%     J_bi_imcom=imcomplement(J_bi);%���ֵͼ��Ĳ�����ֵ��J3
%     set(0,'defaultFigurePosition',[100,100,1000,500]);%�޸�ͼ��ͼ��λ�õ�Ĭ������
%     set(0,'defaultFigureColor',[1 1 1])         %�޸�ͼ�α�����ɫ������
%     figure,                              %��ʾ������
%     % ���Ľ������ҪJ1��ͼ����Ϊ��ͼ�лư����Ǻ�ɫ��
%     subplot(131),imshow(J_bi),title('�Ҷ�ͼת��Ϊ��ֵͼ');            %��ʾ�Ҷ�ͼ���䲹ͼ��
%     subplot(132),imshow(J_green_imcom),title('�Ҷ�ͼ�Ĳ�');           %��ʾ��ֵͼ���䲹ͼ��
%     subplot(133),imshow(J_bi_imcom),title('��ֵͼ�Ĳ�');
function image_part3 = extract_FAZ(I)   
    %%  ������ַ�  
    %A = imread('C:\Users\15259\Desktop\����\5-���ȵ��ߵ�.tif');
%     B = imread('C:\Users\15259\Desktop\����\6-��˹ģ��-��-5.tif');
    %I = imread('E:\data\input\image001.png');
    %I = imread('E:\ҽ����\���ݼ�\Messidor\Messidor\20051019_38557_0100_PP.tif');
    A = imadjust(I(:,:,2));
    h = fspecial('average',50);
    B =imfilter(A,h) ;
    A_incom = imcomplement(A);
    B_incom = imcomplement(B);
%     subplot(221),imshow(A),title('ԭͼA');            %��ʾ�Ҷ�ͼ���䲹ͼ��
%     subplot(222),imshow(B),title('ģ��ͼ��B');           %��ʾ��ֵͼ���䲹ͼ��
%     subplot(223),imshow(A_incom),title('A�Ĳ�');
%     subplot(224),imshow(B_incom),title('B�Ĳ�');
    C = A_incom-B_incom;%A�Ĳ�ͼ��ȥģ��ͼ��B���ó���Ѫ��ͼ�����밼������
    C = A_incom-C;
    %figure,imshow(C)

    %% ��˹ģ��
    Gau = Gaussian(50,9);
    fprintf('\nGaussian Filter Kernel Sigma-3\n')
    out_1= convolution_handmade(C,Gau);
    out_1 = uint8(out_1);
    %figure,imshow(out_1);title('��˹ģ��');
    % ��ɫͼ�����ȵ���
    % Ima = out_1; %ͼƬ��λ��Ҫ�� MATLAB ��Current Folder ��
    % BrightFactor = 2.0; %����ͨ���ı������������ı�ͼƬ����
    % figure,
    % subplot( 1 , 2 , 1 );
    % imshow( Ima );title( 'ԭʼͼƬ' , 'FontWeight' , 'bold' , 'Fontsize' , 16 , 'color' , 'black' );
    % Ima_hsv = rgb2hsv( Ima ); %ͼƬ����ɫ�ռ�ת�� 
    % Ima_hsv( : , : , 3 ) = Ima_hsv( : , : , 3 ) * BrightFactor;
    % Ima_2 = hsv2rgb( Ima_hsv ); % hsv => rgb 
    % subplot( 1 , 2 , 2 );imshow( Ima_2 );

    %% �Ҷ�ͼ�����ȵ���
    figure,imhist(out_1);title('�Ҷ�ֱ��ͼ');
    figure,
    %subplot 221;imshow(out_1);title('��˹ģ�����ͼ');
    %gamma�任
    c = 0.11;
    g = c*log(1 + double(out_1));
    %subplot 222;imshow(g);title('gamma�任');
    %
    %�Աȶȵ���
    g2 = imadjust(out_1, [0.04 0.34], [0 1]);
    %subplot 223;imshow(g2);title('�Աȶȵ���');
    %
    %������ת
    g3 = imadjust(out_1, [0 1], [1 0]);
    %subplot 224;imshow(g3);title('������ת');

    %% Renyi�ص���ֵ�ָ�
    img=g3;
    [m n]=size(img);


    Hist=imhist(img);
    q=2;
    H=[];
    for k=2:256
        PA=sum(Hist(1:k-1));
        PB=sum(Hist(k:255));

        Pa=Hist(1:k-1)/PA;
        Pb=Hist(k:256)/PB;

        HA=(1/1-q)*log(sum(Pa.^q));
        HB=(1/1-q)*log(sum(Pb.^q));

        H=[H HA+HB];    
    end

    [junk level]=max(H);
    imgn=imbinarize(mat2gray(img),level/256);
    
    % figure,imshow(imgn);

    %% ��̬ѧ��ʴ
    se1_1=strel('disk',10);%�����Ǵ���һ���뾶Ϊ5��ƽ̹��Բ�̽ṹԪ��
    dila=imdilate(imgn,se1_1);%����
    se1_2=strel('disk',5);
    erode=imerode(dila,se1_2);%��ʴ

%     figure,
%     subplot 121;imshow(erode);
%     subplot 122;imshow(dila);

    %% �����ͨ�����λ�ú����
    A2 = erode;
    n = 4;%��ʾ4��ͨ����
    [L,num] = bwlabel(A2,n);
    % Regionprops����;��get the properties of region������������ͼ���������Եĺ�����
    % �﷨��STATS = regionprops(image,properties)
    % image��Ϊ�������bwlabel���������ģ�������Ǻ��ͼ�����ݡ�
    % properties:�����������Ҫ����Ĳ�����
    % ����������Ҫ�����������Area������
    % ���ܳ�������Perimeter������
    % �������ʣ�����Eccentricity������
    L1 = imcomplement(L);
    properties = 'BoundingBox';
    STATS = regionprops(L1,properties);
    centroid = regionprops(L1,'Centroid');
    
    %figure,imshow(L1);title('��Ǻ��ͼ��');

    for i=1:1
        rectangle('position',STATS(1).BoundingBox,'edgecolor','r');%�ο�https://blog.csdn.net/zr459927180/article/details/51152094
        %����˵����position���Ƶ�Ϊ��άͼ������ͨ���Խǵ�����ȷ�����ο�
        %edgecolor ָ��Եͼ��r��ʾ�任Ϊ��ɫ��
        %facecolor ָ�ڲ������ɫ��
        text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
        %�����Ϊ���Ƴ����ľ��ο�ͼ�������
    end

    %%  ����������ֱ�������ᡢ���ᡢ�ܳ���Բ��
    copy_mark_image = L1;
    image_part3 = (copy_mark_image == 1); %%��߽��������ѡ������ֻ����3
    % image_part3 = (mark_image ~= 3); 
    
    % figure;imshow(image_part3);
% 
%     %% �����
%     % total = bwarea(image_part3);
%     % fprintf('total = %f\n', total);
%     round_area  = regionprops(image_part3,'Area');
%     a = round_area.Area;%ֻ���ṹ��ĵ�һ��ֵ�����a
%     fprintf('round_area = %f\n', a*0.00557*0.00557);
% 
%     %���ܳ�
%     girth = regionprops(image_part3,'Perimeter');
%     % girth.Perimeter
%     fprintf('s.Perimeter = %f\n', girth.Perimeter);
% 
%     %��߽��������ѡ������ֻ����10
%     image_part1 = (L1 == 1);    
%     
%     %figure;imshow(image_part1);
% 
%     %���ɫ��Բ��������
%     oval = regionprops(image_part1,'Eccentricity');%������ 0 < e < 1֮�䣬eԽС��Խ��Բ��
%     % oval.Eccentricity
%     fprintf('oval.Eccentricity = %f\n', oval.Eccentricity);
end
%%  