
% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

function SR=Tsai_wu(sigma_u,sigmaM,sigmaL)
F1 = 1/(sigma_u(1))-1/(sigma_u(2));
F11 = 1/(sigma_u(1)*sigma_u(2));
F2 = 1/(sigma_u(3))-1/(sigma_u(4));
F22 = 1/(sigma_u(3)*sigma_u(4));
F6 = 0;
F66 = 1/(sigma_u (5)^2);
F12 = 1/2*sqrt(1/(sigma_u(1)*sigma_u(2)*sigma_u(3)*sigma_u(4)));
syms x;
for k=1:3
sigma(k)=sigmaM(k)+sigmaL(k)*x;
end;
p=F1*sigma(1)+F2*sigma(2)+F6*sigma(3)+F11*sigma(1)^2+F22*sigma(2)^2+F66*sigma(3)^2+2*F12*sigma(1)*sigma(2)-1;
r=root(p,x);
s=size(r);
R=zeros(s);
for i=1:s
R(i)=root(p,x,i);
end;
SR=max(R);
