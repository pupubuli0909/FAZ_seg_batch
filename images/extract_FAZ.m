% %function [J_green,J_bi,J_green_imcom,J_bi_imcom] = img_imcompliment(I)
%     I = imread('DB1_66.jpg');
%     J_green = I(:,:,1);%选择绿色通道,直方图均衡化
%     
%     J_bi=imbinarize(J_green);%将灰度图像转换成二值图像，赋值给J1
%     J_green_imcom=imcomplement(J_green);%求灰度图像的补，即对图像进行求反运算，赋值给J2
%     J_bi_imcom=imcomplement(J_bi);%求二值图像的补，赋值给J3
%     set(0,'defaultFigurePosition',[100,100,1000,500]);%修改图形图像位置的默认设置
%     set(0,'defaultFigureColor',[1 1 1])         %修改图形背景颜色的设置
%     figure,                              %显示运算结果
%     % 最后的结果中需要J1的图，因为该图中黄斑区是黑色的
%     subplot(131),imshow(J_bi),title('灰度图转换为二值图');            %显示灰度图像及其补图像
%     subplot(132),imshow(J_green_imcom),title('灰度图的补');           %显示二值图像及其补图像
%     subplot(133),imshow(J_bi_imcom),title('二值图的补');
function image_part3 = extract_FAZ(I)   
    %%  背景差分法  
    %A = imread('C:\Users\15259\Desktop\步骤\5-亮度调高点.tif');
%     B = imread('C:\Users\15259\Desktop\步骤\6-高斯模糊-核-5.tif');
    %I = imread('E:\data\input\image001.png');
    %I = imread('E:\医工研\数据集\Messidor\Messidor\20051019_38557_0100_PP.tif');
    A = imadjust(I(:,:,2));
    h = fspecial('average',50);
    B =imfilter(A,h) ;
    A_incom = imcomplement(A);
    B_incom = imcomplement(B);
%     subplot(221),imshow(A),title('原图A');            %显示灰度图像及其补图像
%     subplot(222),imshow(B),title('模糊图像B');           %显示二值图像及其补图像
%     subplot(223),imshow(A_incom),title('A的补');
%     subplot(224),imshow(B_incom),title('B的补');
    C = A_incom-B_incom;%A的补图减去模糊图像B，得出了血管图和中央凹的区域
    C = A_incom-C;
    %figure,imshow(C)

    %% 高斯模糊
    Gau = Gaussian(50,9);
    fprintf('\nGaussian Filter Kernel Sigma-3\n')
    out_1= convolution_handmade(C,Gau);
    out_1 = uint8(out_1);
    %figure,imshow(out_1);title('高斯模糊');
    % 彩色图像亮度调节
    % Ima = out_1; %图片的位置要在 MATLAB 的Current Folder 下
    % BrightFactor = 2.0; %可以通过改变亮度因子来改变图片亮度
    % figure,
    % subplot( 1 , 2 , 1 );
    % imshow( Ima );title( '原始图片' , 'FontWeight' , 'bold' , 'Fontsize' , 16 , 'color' , 'black' );
    % Ima_hsv = rgb2hsv( Ima ); %图片的颜色空间转换 
    % Ima_hsv( : , : , 3 ) = Ima_hsv( : , : , 3 ) * BrightFactor;
    % Ima_2 = hsv2rgb( Ima_hsv ); % hsv => rgb 
    % subplot( 1 , 2 , 2 );imshow( Ima_2 );

    %% 灰度图像亮度调节
    figure,imhist(out_1);title('灰度直方图');
    figure,
    %subplot 221;imshow(out_1);title('高斯模糊后的图');
    %gamma变换
    c = 0.11;
    g = c*log(1 + double(out_1));
    %subplot 222;imshow(g);title('gamma变换');
    %
    %对比度调整
    g2 = imadjust(out_1, [0.04 0.34], [0 1]);
    %subplot 223;imshow(g2);title('对比度调整');
    %
    %明暗反转
    g3 = imadjust(out_1, [0 1], [1 0]);
    %subplot 224;imshow(g3);title('明暗反转');

    %% Renyi熵的阈值分割
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

    %% 形态学腐蚀
    se1_1=strel('disk',10);%这里是创建一个半径为5的平坦型圆盘结构元素
    dila=imdilate(imgn,se1_1);%膨胀
    se1_2=strel('disk',5);
    erode=imerode(dila,se1_2);%腐蚀

%     figure,
%     subplot 121;imshow(erode);
%     subplot 122;imshow(dila);

    %% 标记连通区域的位置和序号
    A2 = erode;
    n = 4;%表示4连通区域
    [L,num] = bwlabel(A2,n);
    % Regionprops：用途是get the properties of region，即用来度量图像区域属性的函数。
    % 语法：STATS = regionprops(image,properties)
    % image是为传入的是bwlabel函数传出的，经过标记后的图像数据。
    % properties:这个则是你需要传入的参数。
    % 比如我们需要求面积，则传入Area参数。
    % 求周长，则传入Perimeter参数。
    % 求离心率，则传入Eccentricity参数。
    L1 = imcomplement(L);
    properties = 'BoundingBox';
    STATS = regionprops(L1,properties);
    centroid = regionprops(L1,'Centroid');
    
    %figure,imshow(L1);title('标记后的图像');

    for i=1:1
        rectangle('position',STATS(1).BoundingBox,'edgecolor','r');%参考https://blog.csdn.net/zr459927180/article/details/51152094
        %参数说明：position绘制的为二维图像（他是通过对角的两点确定矩形框）
        %edgecolor 指边缘图像，r表示变换为红色。
        %facecolor 指内部填充颜色。
        text(centroid(i,1).Centroid(1,1)-15,centroid(i,1).Centroid(1,2)-15, num2str(i),'Color', 'r') 
        %这个是为绘制出来的矩形框图标记数字
    end

    %%  其他参数，直径、长轴、短轴、周长、圆度
    copy_mark_image = L1;
    image_part3 = (copy_mark_image == 1); %%这边进行区域的选择，例如只保留3
    % image_part3 = (mark_image ~= 3); 
    
    % figure;imshow(image_part3);
% 
%     %% 求面积
%     % total = bwarea(image_part3);
%     % fprintf('total = %f\n', total);
%     round_area  = regionprops(image_part3,'Area');
%     a = round_area.Area;%只将结构体的第一个值赋予给a
%     fprintf('round_area = %f\n', a*0.00557*0.00557);
% 
%     %求周长
%     girth = regionprops(image_part3,'Perimeter');
%     % girth.Perimeter
%     fprintf('s.Perimeter = %f\n', girth.Perimeter);
% 
%     %这边进行区域的选择，例如只保留10
%     image_part1 = (L1 == 1);    
%     
%     %figure;imshow(image_part1);
% 
%     %求红色椭圆的离心率
%     oval = regionprops(image_part1,'Eccentricity');%离心率 0 < e < 1之间，e越小，越像圆。
%     % oval.Eccentricity
%     fprintf('oval.Eccentricity = %f\n', oval.Eccentricity);
end
%%  