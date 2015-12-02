for i=1:1
    clear A B
    A=imread('longfileAv.tif','Index',i);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    for j=0:100
    B(100+j,10,2)=4000-j*4000/100;
    B(100+j,10,1)=0+j*4000/100;
    end
    if i==4
        B(:,:,1)=4000;
    end
    imwrite(B,'Test2.tif','Writemode','append','Compression','none')
end