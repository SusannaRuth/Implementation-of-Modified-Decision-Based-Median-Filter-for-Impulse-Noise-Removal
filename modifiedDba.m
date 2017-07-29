%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
close all;
x=imread('lena512.bmp');
%x=double(x);
%x=(x(:,:,1)+x(:,:,2)+x(:,:,3))./3;
%x=uint8(x);
NOISE_VAR = 0.3;
y = imnoise(x,'salt & pepper',NOISE_VAR);
y = double(y);
Y = y;
[R C] = size(x);

for i = 3:R-2
    for j = 3:C-2

        tmp =y(i-1:i+1,j-1:j+1);
        if (Y(i,j) == 0 || Y(i,j) == 255) 
            tmp=tmp(tmp~=0);
            tmp=tmp(tmp~=255);
            tmp=tmp(:);
            len=size(tmp,1);
            if (len ~= 0)
                med=median(tmp);
                Y(i,j)=med;
            else
                tmp =y(i-2:i+2,j-2:j+2);
                tmp=tmp(tmp~=0);
                tmp=tmp(tmp~=255);
                tmp=tmp(:);
                len=size(tmp,1);
                if (len ~= 0)
                    med=median(tmp);
                    Y(i,j)=med;
                else
                     Y(i,j) = Y(i,j-1); 
                end
            end    
            
           
        end
    end
end

% Border Correction 
Y(1,:) = Y(3,:);
Y(2,:) = Y(3,:);
Y(R,:) = Y(R-2,:);
Y(R-1,:) = Y(R-2,:);
Y(:,1) = Y(:,3);
Y(:,2) = Y(:,3);
Y(:,C) = Y(:,C-2);
Y(:,C-1) = Y(:,C-2);

med=medfilt2(y, [3 3]);

figure;imshow(x,[]);title('Given Image');
figure;imshow(y,[]);title('Noisy : Noise Density - ');
figure;imshow(med,[]);title('Traditional Median');
figure;imshow(Y,[]);title('Modified DBA');

x=double(x);
m1=(x-Y).^2;
r1=mean(m1(:));
p1=20*log10(double(max(x(:)))./sqrt(r1));
fprintf('\n The PSNR value of modified median filter is %0.4f', p1);

m2=(x-med).^2;
r2=mean(m2(:));
p2=20*log10(double(max(x(:)))./sqrt(r2));
fprintf('\n The PSNR value of median filter is %0.4f', p2);

ssim1 = ssim(x,Y);
fprintf('\n SSIM of modified median filter is %0.4f', ssim1);

ssim2 = ssim(x,med);
fprintf('\n SSIM of median filter is %0.4f', ssim2);

wmf(x,y);

dbafinal12(x,y);

