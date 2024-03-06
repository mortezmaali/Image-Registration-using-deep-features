%Here is the image to be registered
image = imread('IMG_6130_not_registered.png');
image = im2double(image);
[m n l]=size(image);
refn=2;
img_b =  image(:,:,refn);
size_cube = size(img_b);
img_out2=zeros(m,n,1);
for i = 1:l
    if i == refn
        img_out2(:,:,i)=img_b;
        continue;
    end
    im1 = image(:,:,i);
    
    [matchedPoints1,matchedPoints2]=findmatches4(im1,img_b);
    
    Point1=matchedPoints1;
    Point2=matchedPoints2;
    [im_points,im_ref_points]=inliers(Point1',Point2');
    
    tform = cp2tform(im_points,im_ref_points,'similarity');
    img_out2(:,:,i) = imtransform(im1,tform,'Xdata',[1 size_cube(2)],'Ydata',[1 size_cube(1)]);
end
img_out2 = uint8(255*img_out2);
montage({img_out2, image})
