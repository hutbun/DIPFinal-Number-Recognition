clear all;close all
I = imread('card6.jpg');
I1=rgb2gray(I);      %灰度处理，自动取值二值化
level=graythresh(I1);
I2=im2bw(I1,0.32);
I3=~I2;
%I4=bwareaopen(I3,30); %降噪处理
% I4=medfilt2(I3,[7,7]);  %7*7中值滤波
imshow(I3);
[y x]=size(I3);
%A2=imcrop(I2,[x/5 y*3/7 3*x/10 y/6]);
A2=imcrop(I2,[x/10 y*3/7 x/2 y/5]);
figure,imshow(A2);
% se = strel('line',15);  %进行开运算，使图像形成几个连通域
se = strel('line', 3, 90);
bw= imopen(~A2,se);%去除横线
figure,imshow(bw)
se2 = strel('square',3);%链接断开部分
A3= imdilate(bw,se2);
figure,imshow(~A3)

se = strel('rectangle',[10 20]);  %进行开运算，使图像形成几个连通域 10*20元横向
bw2= imopen(~A3,se);
figure,imshow(bw2)

[B,L] = bwboundaries(bw2,4); 
imshow(label2rgb(L, @jet, [.5 .5 .5]))%分区域
hold on
for k = 1:length(B)
    boundary = B{k};
    plot(boundary(:,2),boundary(:,1),'w','LineWidth',2)%画出边界
end

X = B(4);%B4为学号区域边界坐标
numarea=A2;
% [n m] = size(X{1,1});
% for i = 1:n
%     xx=X{1,1}(i,2);
%     yy=X{1,1}(i,1);
%     area(yy,xx)=0;%圈出学号
% end
% figure,imshow(area)
min_x = min(X{1,1}(:,2));max_x =max(X{1,1}(:,2));
min_y = min(X{1,1}(:,1));max_y =max(X{1,1}(:,1));
lt = [min_x min_y]%学号左上坐标
rb = [max_x max_y]%学号右下坐标

ttt=A2;
for i = min_x:max_x
    for j = min_y:max_y
        ttt(j,i)=0;
    end
end
numarea = imcrop(A2, [min_x-2 min_y max_x-min_x+4 max_y-min_y]);%切割出学号
figure,imshow(numarea)%学号区域
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[m n] = size(numarea);

% numbegin=0;
% nn=1%第几个数
% for i = 1:n %1->宽度
% %   for j = 1:m%1->底
%     sumi = sum(numarea(:,i));
%     if sumi == m %全白
%     else
%         numbegin = numbegin+1;
%     end
%     
%     if (numbegin > 0)&&(sumi == m)%单个数字结束
%         number = numarea()
%         output{nn}=ones(i,j);
%         
%     end
%     
%     
% end
%%%%%%%%%%

output = cell(10,1);%建立输出结构体
begin=1;
whitestart=0;%每列全白色计数
numstart=0;%有信息的列计数
figure
singlese = strel('disk',1);%腐蚀结果
for nn=1:10%第几个数
    for i = begin:n %
        sumi = sum(numarea(:,i));
        if sumi == m %全白
            whitestart = whitestart+1;
        else
            numstart = numstart+1;
        end
        
        if numstart >0 && sumi == m %数字右边界
            output{nn} = ones(m,i);
            siglenum = ones(m,i);
            singlenum=numarea(1:m,i-numstart-1:i);
            singlenum=imopen(singlenum,singlese);
            output{nn}= singlenum%腐蚀单个数字
            subplot(2,5,nn);
            imshow(output{nn});
            %figure,imshow(output{nn});
            filename=['numoutput\',num2str(nn),'.bmp'];
            %imwrite(output{nn},filename);%输出
            imwrite(output{nn}, filename, 'bmp');
            whitestart=0;
            numstart=0;
            begin=i+1;
            break;%完成一个数字 跳出
        end
    end
end
        
    
        
        
        
        
        
        
