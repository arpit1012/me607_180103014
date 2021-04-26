
% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

clear;
clc;
% Step 1: Taking Inputs from the user
disp('Now Enter the values for all the properties of the lamina below');
disp('Make sure to express all the values as column vectors wherever needed unless specified otherwise');

% Separate Data file is provided in case manaual input is not preferred
%please remove % below and add % where input() is written in case of file
% input

% example_data;

n = input('Enter the number of layers:');
E1 = input('Enter the longitudinal Youngs Modulus:');
E2 = input('Enter the transverse Youngs Modulus:');
G12 = input('Enter the in-plane shear Modulus:');
v12 = input('Enter the major Poissons Ratio:');
theta = input('Enter the ply angle of laminae as a ROW VECTOR:');
alpha = input('Enter the coefficients of thermal expansion of laminae as vector: ');
beta = input('Enter the coefficients of expansion due to moisture of laminae as vector:');
t = input('Enter the thickness of each ply as a ROW VECTOR :');
N = input('Enter the load vector:');
M = input('Enter the moment vector:');
deltaT = input('Enter the change in temperature:');
deltaC = input('Enter the change in moisture content:');

% Final Load Vector is as follows (combining the N and M column wise)
Load = [N;M];

% Step 2: calculate the distance of each layer from center reference i.e.
% mid plane)

t_layer = zeros(1,n+1);
for i=1:n
    t_layer(1,i+1)=t(1,i)+t_layer(1,i);
end;

h = (sum (t)/2)*ones(n+1) - t_layer;

% Step 3: Calculating required A,B,D and reduced Q

Q = zeros(3,3,n);
temp = zeros(3,3,n);
A = zeros(3,3);
B = zeros(3,3);
D = zeros(3,3);

for i=1:n
    Q(:,:,i)=Stiffness(E1,E2,G12,v12,theta(i));
    A(:,:)=A(:,:)+Q (:,:,i).*(h(1,i+1)-h(1,i));
    B(:,:)=B(:,:)+Q (:,:,i).*(0.5*(h (1,i+1).^2-h (1,i).^2));
    D(:,:)=D(:,:)+Q (:,:,i).*((h (1,i+1).^3-h (1,i).^3)/3);
end;

temp = Q;

TotalABD = [A,B;B,D];

% Step 4: Calculating Strain due to extension Load
e = inv(TotalABD)*Load;
for i=1:n
    e0_top = e(1:3)-h(i)*e(4:6);
    e0_bottom = e(1:3)-h(i+1)*e(4:6)
    eL_top(:,:,i) = e0_top;
    eL_bottom(:,:,i) = e0_bottom;
end;

% Step 5: Hygrothermal Analysis
Nt = zeros(3,1);
Nc = zeros(3,1);
Mt = zeros(3,1);
Mc = zeros(3,1);
for i=1:n
    alpha_l(:,:,i) = Trans_layer(alpha,theta(i));
    beta_l(:,:,i) = Trans_layer(beta,theta(i));
    Nt=Nt+Q(:,:,i)*alpha_l (:,:,i).*((h(1,i+1)-h(1,i))*deltaT);
    Mt=Mt+Q(:,:,i)*alpha_l (:,:,i).*((h (1,i+1)^2-h (1,i)^2)*deltaT);
    Nc=Nc+Q(:,:,i)*alpha_l (:,:,i).*((h(1,i+1)-h(1,i))*deltaC);
    Mc=Mc+Q(:,:,i)*alpha_l (:,:,i).*((h (1,i+1)^2-h (1,i)^2)*deltaC);
end;
e_ht = inv(TotalABD)*([Nt;Mt]+[Nc;Mc]);

for i=1:n
    e0_top = e_ht(1:3)-h (i).*e_ht(4:6);
    e0_bottom = e_ht(1:3)-h (i+1).*e_ht(4:6);
    eT = deltaT.*alpha_l(:,:,i);
    eC = deltaC.*beta_l(:,:,i);
    eM_top(:,:,i) = e0_top -eT-eC;
    eM_bottom(:,:,i) = e0_bottom -eT -eC;
end;

% Step 6: Calculating Stress

sigma_top=zeros(3,1,n);
sigma_bottom=zeros(3,1,n);
e_net_top = eM_top + eL_top;
e_net_bottom = eM_bottom + eL_bottom;
for i=1:n
    sigma_top(:,:,i) = Q(:,:,i)*e_net_top(:,:,i);
    sigma_bottom(:,:,i) = Q(:,:,i)*e_net_bottom(:,:,i);
end

% local stress
sigma_local_top=zeros(3,1,n);
sigma_local_bottom=zeros(3,1,n);
for i=1:n
    sigma_local_top(:,:,i) = Trans_back(sigma_top(:,:,i),theta(i));
    sigma_local_bottom(:,:,i) = Trans_back(sigma_bottom(:,:,i),theta(i));
end;

% Printing the results
for i=1:n
   fprintf("The local stresses in top layer of lamina %d are:\n",i);
   sigma_local_top(:,:,i)
   fprintf("The local stresses in bottom layer of lamina %d are:\n",i);
   sigma_local_bottom(:,:,i)
end;

% Step 7: Failure Analysis
% Step 7.1: Taking Data for strength of the materials

sigma1_u_t= input('Enter the longitudinal tensile strength in x direction:');
sigma1_u_c= input('Enter the longitudinal compressive strength in x direction:');
sigma2_u_t= input('Enter the transverse tensile strength in x direction:');
sigma2_u_c= input('Enter the transverse compressive strength in y direction:');
tau12_u= input('Enter the maximum shear strength:');
sigma_u=[sigma1_u_t;sigma1_u_c;sigma2_u_t;sigma2_u_c;tau12_u];

% Step 7.2 Applying First Ply Failure and Last Ply Failure Conditions using
% complete degradation

k=0;
reject=0;
fprintf("CONSIDERING COMPLETE DEGRADATION \n");
while k<n
    k;
    calc_stress;
    SR=zeros(n-k,1);

    for i=1:n
        flag=0;
        for b=1:k+1
            if i==reject(b)
                flag=1;
            end;
        end;
        
        if flag==0
            SR_top=Tsai_wu(sigma_u,sigma_top_Ml(:,:,i),sigma_top_Ll(:,:,i));
            SR_bottom=Tsai_wu(sigma_u,sigma_bottom_Ml(:,:,i),sigma_bottom_Ll(:,:,i));
            SR(i,1)=min(SR_top,SR_bottom);
        else
            if i~=1
                SR(i,1)=SR(i-1,1)+100;
            else
                SR(i,1)=10^20;
            end;
        end;
    end;

    sr=min(SR);
    index = find(SR == sr);
    reject = [reject;index];
    s=size(index);
    fprintf("The layer to fail is %d\n",index);
    Pf=sr*Load;
    fprintf("The loading to cause failure (in SI units) is:\n\n")
    
    for j=1:6
        if(j<=3)
            str="Pa-m";
        else
            str="Pa-m^2";
        end;
        
        fprintf("%10.5e %s\n",Pf(j),str);
    end;

    for i=1:s
        Q(:,:,index(i)) = zeros(3,3);
    end;

    k=k+s(1);
    index=0;
end;

% Step 7.3 Applying First Ply Failure and Last Ply Failure Conditions using
% Partial Degradation
fprintf("CONSIDERING PARTIAL DEGRADATION \n");
Q=temp;
k=0;
reject=0;
while k<n
    k;
    calc_stress;
    SR=zeros(n-k,1);

    for i=1:n
        flag=0;
        for b=1:k+1
            if i==reject(b)
                flag=1;
            end;
        end;
        
        if flag==0
            SR_top=Tsai_wu(sigma_u,sigma_top_Ml(:,:,i),sigma_top_Ll(:,:,i));
            SR_bottom=Tsai_wu(sigma_u,sigma_bottom_Ml(:,:,i),sigma_bottom_Ll(:,:,i));
            SR(i,1)=min(SR_top,SR_bottom);
        else
            if i~=1
                SR(i,1)=SR(i-1,1)+100;
            else
                SR(i,1)=10^20;
            end;
        end;
    end;

    sr=min(SR);
    index = find(SR == sr);
    reject = [reject;index];
    s=size(index);
    fprintf("The layer to fail is %d\n",index);
    Pf=sr*Load;
    fprintf("The loading to cause failure (in SI units) is:\n\n")
    
    for j=1:6
        if(j<=3)
            str="Pa-m";
        else
            str="Pa-m^2";
        end;
        
        fprintf("%10.5e %s\n",Pf(j),str);
    end;

    for i=1:s
        Q(:,:,index(i)) = Stiffness2(E1,0,0,v12,theta(i));
    end;

    k=k+s(1);
    index=0;
end;