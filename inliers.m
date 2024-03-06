function [Point1_in,Point2_in]=inliers(Point1,Point2)
inter=20;
thre=10;
inlierRatio=0;
for i = 1:inter
    sa = randperm(size(Point1,1),4)';
    po1=Point1(sa,:);
    po2=Point2(sa,:);
    m=0;
    for j=1:2:8
        m=m+1;
        A(j:j+1,1:8)=[po1(m,1) po1(m,2) 1 0 0 0 -1*po1(m,1)*po2(m,1) -1*po1(m,2)*po2(m,1);0 0 0 po1(m,1) po1(m,2) 1 -1*po1(m,1)*po2(m,2) -1*po1(m,2)*po2(m,2)];
    end
    n=0;
    for k=1:2:8
        n=n+1;
        b(k:k+1,1)=[po2(n,1);po2(n,2)];
    end
    h=A\b;
    h(9)=1;
    H = reshape(h, [3, 3])';
    yx=[Point1(1:size(Point1,1),1)';Point1(1:size(Point1,1),2)';ones(1,size(Point1,1))];
    yxn=H*yx;
    yxn=yxn./(repmat(yxn(3,:),3,1));
    yxn=floor(yxn);
    Point2n=yxn(1:2,:);
    err = sqrt(sum((Point2n' - Point2) .^ 2,2));
    inlierin = find(err<=thre);
    inlierlength = length(inlierin);
    InlierRatio=inlierlength/size(Point2,1);
    if InlierRatio>=inlierRatio
        Point1_in=Point1(inlierin,:);
        Point2_in=Point2(inlierin,:);
        inlierRatio=InlierRatio;
    end
end

