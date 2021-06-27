function [ s ] = Edgebased( I )


I = imread('1.png');
x = rgb2gray(I);
%segmentation
BW = edge(x,'canny');
figure, imshow(BW);
se = strel('square',4);
%dilation
BW = imdilate(BW,se);
figure,imshow(BW);
BW = imcomplement(BW);
range = (size(I,1)*size(I,2))/100;
BW2 = bwareaopen(BW,round(range));
figure,imshow(BW2);
title('Remove Small Components')
%mtrxobj
[L, num] = bwlabel(BW2);
[h, w, ~] = size(I);

smallRatio = h*w*0.002;  
totalpixels =0;
%display num_obj
disp(num)
%sum of pie pixels
sumofall=0;
%1st for :sum
for i=2:num-1
     pixels_of_each_sector = 0;
    x = uint8(L==i);
    f = sum(sum(x==1));
    if(f < smallRatio)
        continue;  
    end
    
   %d=sectors
    d = zeros(size(I));
    d(:,:,1) = uint8(x).*I(:,:,1);
    d(:,:,2) = uint8(x).*I(:,:,2);
    d(:,:,3) = uint8(x).*I(:,:,3);

    figure,imshow(uint8(d));
     
    pixels_of_each_sector=0;
    %each sector 
    for j=1:h
        for k=1:w
           
           
            if (d(j,k) ~= 0)
                pixels_of_each_sector = pixels_of_each_sector+1;
   
            end
        end
        
    end
    sumofall= sumofall + pixels_of_each_sector;
 
    
end
disp(sumofall);
for i=2:num-1
     pixels_of_each_sector = 0;
    x = uint8(L==i);
    f = sum(sum(x==1));
    if(f < smallRatio)
        continue;  
    end
    
    d = zeros(size(I));
    d(:,:,1) = uint8(x).*I(:,:,1);
    d(:,:,2) = uint8(x).*I(:,:,2);
    d(:,:,3) = uint8(x).*I(:,:,3);

    
    pixels_of_each_sector=0;
    for j=1:h
        for k=1:w
           
           
            if (d(j,k) ~= 0) % lw el pixel di lonha abyd 
                pixels_of_each_sector = pixels_of_each_sector+1;
                
            end
        end
        
    end
    percentage = (pixels_of_each_sector*100)/sumofall;
    disp(percentage);
end
%etxract legend
Legend = zeros(size(I));
BlackLegendImg = zeros(size(I));
Objects = regionprops(L,'BoundingBox');
for i =1:num
    obj=Objects(i);
    object_X=obj.BoundingBox(1);
    object_Y=obj.BoundingBox(2);
    object_W=obj.BoundingBox(3);
    object_H=obj.BoundingBox(4);
    cropped_image=imcrop(I,[object_X,object_Y,object_W-1,object_H-1]);
    if(i == num)
       Legend = cropped_image;      
       figure,imshow(Legend);
    end
end


LegendResized = imresize(Legend,[h w]);
figure,imshow(LegendResized);
%boxes
BlackkkLegendImg = zeros(size(LegendResized));
x2 = rgb2gray(LegendResized);
edged = edge(x2,'canny');
figure, imshow(edged);
se = strel('square',4);

edged = imdilate(edged,se);
figure,imshow(edged);
edged = imcomplement(edged);
[LForLegend, Lnum] = bwlabel(edged);
Objects = regionprops(LForLegend,'BoundingBox');

ocrResults = ocr(Legend);
recognizedText = ocrResults.Text; 
disp(recognizedText);

length_OCR=length(ocrResults.Words);
% disp(length_OCR);
count = 0;
% betgeb el squares el malwna el fi el legend
for i =1:num-1
    
    obj=Objects(i);
    object_X=obj.BoundingBox(1);
    object_Y=obj.BoundingBox(2);
    object_W=obj.BoundingBox(3);
    object_H=obj.BoundingBox(4);
    cropped_image=imcrop(LegendResized,[object_X,object_Y,object_W-1,object_H-1]);
   BlackkkLegendImg = cropped_image;
   figure,imshow(BlackkkLegendImg);
    BlackkkLegendImg = imresize(BlackkkLegendImg,[h w]);
    figure,imshow(BlackkkLegendImg);
    %sectors again to compare
    for j=2:num-1
    x = uint8(L==i);
    f = sum(sum(x==1));
    if(f < smallRatio)
        continue;  
    end
    d = zeros(size(I));
    d(:,:,1) = uint8(x).*I(:,:,1);
    d(:,:,2) = uint8(x).*I(:,:,2);
    d(:,:,3) = uint8(x).*I(:,:,3);
    
     
    end
end

end