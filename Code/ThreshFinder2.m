clear all;
done=false;
file='FlyStack2TAv.tif';
while done==false
    Thresh=input('Thresh= (0 to quit) ');
    
    close
    if Thresh==0
        break
    end
    A=imread(file,'Index',1);
    B(:,:,1)=A;
    B(:,:,2)=A;
    B(:,:,3)=A;
    bright=max(max(A));
    [X,Y,INT]=FindSpots(A,Thresh);
    [Boy,~]=size(X);
    for i=1:Boy
        B(ceil(Y(i,1)),ceil(X(i,1)),1)=bright;
        B(ceil(Y(i,1)),ceil(X(i,1)),2)=0;
        B(ceil(Y(i,1)),ceil(X(i,1)),3)=0;
    end
    colormap(gray);
    maximum=65535;
    C=B*(maximum/bright);
    image(C);
end