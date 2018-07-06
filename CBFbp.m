function I_rec1=CBFbp(img,n_view)

% img = dicomread('expdcm-tmp1.DCM_0001.dcm');
% n_view = 60;
%�˲���ͶӰ�ؽ���������
I=double(img);%
[row,col]=size(I);


delta=360/n_view;%����ͶӰ�Ƕȼ��
theta=0:delta:360-delta;%����ͶӰ�Ƕ�����

[R,xp]=radon(I,theta);%ȡͶӰ
[Rrow,Rcol]=size(R);


offset=(max(xp)+1);
R_L=zeros(2*Rrow-1,1);%��ʼ��R_L����
d=1.00;%�˲������������

for n=-Rrow+1:1:row-1
    if(n==0)
        R_L(n+Rrow)=1.00/(4*d*d);
    elseif(mod(n,2)~=0)
        R_L(n+Rrow)=(-1)/(pi*pi*d*d*(n)^2);
    end
end

% R_expand=zeros(Rrow+2*L,Rcol);
% for j=1:Rcol%��ͶӰ���������չ�����ں��˲������ľ��
%     R_expand(1:L,j)=(R(1,j)+R(2,j))/2;
%     R_expand((L+1):(Rrow+L),j)=R(:,j);
%     R_expand((Rrow+L+1):(Rrow+2*L),j)=(R(Rrow-1,j)+R(Rrow,j))/2;
% end

% R_conv=zeros(Rrow+,Rcol);
 R_conv = zeros(Rrow*3-2,Rcol);
for i = 1:Rcol
   R_conv(:,i) =  conv( R(:,i) , R_L );
end

R_conv = R_conv(Rrow:Rrow*2-1,:);
% 
%  for j=1:Rcol%R_L������ͶӰ���о��
%         for i=1:Rrow
%             for m=1:(2*L+1)
%                 R_conv(i,j)=R_conv(i,j)+R_L(m)*R_expand(m+i-1,j);
%             end
%         end
%  end

I_rec=zeros(row,col);
for theta=1:n_view%��ͶӰ�ؽ�����
    rad=(theta-1)*delta;
    co=cosd(rad);
    si=sind(rad);
    for j=1:row
        for k=1:col            
            j0=j-row/2;
            k0=k-col/2;
            xr=j0*co+k0*si+offset;
            xr_n=floor(xr);
            xr_m=xr_n+1;
            R1=R_conv(xr_n,theta);
            R2=R_conv(xr_m,theta);
            I_rec(j,k)=I_rec(j,k)+(R2-R1)/(xr_m-xr_n)*(xr-xr_n)+R1;
        end
    end
end
I_rec1=rot90(pi/theta*I_rec);
% I_rec1=rot90(I_rec);
% figure;imshow(I,[300 2000]);title('OriImg');
% figure;imshow(I_rec1,[300 2000]);title('FBPImg');