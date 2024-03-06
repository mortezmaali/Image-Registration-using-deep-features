function [matchedPoints1,matchedPoints2]=findmatches4(I1,I2)
run('C:\Users\Morteza\OneDrive\Desktop\YouTube\Image_registration_DF\vlfeat-0.9.21\toolbox\vl_setup')
I1 = single(I1) ;
I2 = single(I2) ;
[f1,d1] = vl_sift(I1) ;
[f2,d2] = vl_sift(I2) ;
points1 = f1(1:2,:);
points2 = f2(1:2,:);
I1 = im2double(I1) ;
I2 = im2double(I2) ;
net = inceptionresnetv2;
m1=size(points1,2);
for i=1:m1
    if points1(1,i)<31 || points1(1,i)>180 || points1(2,i)<31 || points1(2,i)> 198
        continue;
    end
    x=floor(points1(1,i));
    y=floor(points1(2,i));
    In1=I1(abs(y-30):y+30,abs(x-30):x+30,:);
    Iout = imresize(In1, [299 299]);
    Iout = cat(3,Iout,Iout,Iout);
    layer = 'conv_7b_ac';
    features1(:,i) = activations(net,Iout,layer,'OutputAs','columns');
end
m2=size(points2,2);
for i=1:m2
        if points2(1,i)<31 || points2(1,i)>180 || points2(2,i)<31 || points2(2,i)> 198
        continue;
    end
    x=floor(points2(1,i));
    y=floor(points2(2,i));
    In2=I2(abs(y-30):y+30,abs(x-30):x+30,:);
    Iout = imresize(In2, [299 299]);
    Iout = cat(3,Iout,Iout,Iout);
    layer = 'conv_7b_ac';
    features2(:,i) = activations(net,Iout,layer,'OutputAs','columns');
end
% s=size(features1);
% features2=imresize(features2,[s(1) s(2)]);
[indexPairs, scores] = vl_ubcmatch(features1,features2,0.9);
matchedPoints1 = f1(1:2,indexPairs(1,:));
matchedPoints2 = f2(1:2,indexPairs(2,:));
