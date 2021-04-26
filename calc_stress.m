
% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

%stress
sigma_top_M=zeros(3,1,n);
sigma_bottom_M=zeros(3,1,n);
sigma_top_L=zeros(3,1,n);
sigma_bottom_L=zeros(3,1,n);
for i=1:n
    sigma_top_M(:,:,i) = Q(:,:,i)*eM_top(:,:,i);
    sigma_bottom_M(:,:,i) = Q(:,:,i)*eM_bottom(:,:,i);
    sigma_top_L(:,:,i) = Q(:,:,i)*eL_top(:,:,i);
    sigma_bottom_L(:,:,i) = Q(:,:,i)*eL_bottom(:,:,i);
end;
%local stress
sigma_top_Ll=zeros(3,1,n);
sigma__bottom_Ll=zeros(3,1,n);
sigma_top_Ml=zeros(3,1,n);
sigma__bottom_Ml=zeros(3,1,n);

for i=1:n
    sigma_top_Ll(:,:,i) = Trans_back(sigma_top_L(:,:,i),theta(i));
    sigma_bottom_Ll(:,:,i) = Trans_back(sigma_bottom_L(:,:,i),theta(i));
    sigma_top_Ml(:,:,i) = Trans_back(sigma_top_M(:,:,i),theta(i));
    sigma_bottom_Ml(:,:,i) = Trans_back(sigma_bottom_M(:,:,i),theta(i));
end;