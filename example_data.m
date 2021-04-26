
% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate


clear
clc

E1 = 180*10^9; 
E2 = 10*10^9; 
v12 = 0.25;
G12 = 5*10^9;

alpha = [0.2*10^-7;     
        0.225*10^-4;    
                  0]  ; 
              
beta = [0;     
        0;    
        0]  ;               

n=8;    
theta = [0,+45,-45,90,90,-45,+45,0];
t=0.125*10^-3.*ones(1,8);



N = [1000;
        0;
        0;
       ];
M =[0;
    0;
    0;];
     

deltaT = 100; 
deltaC = 0;

sigma1_u_t=1500*10^6;
sigma1_u_c=1500*10^6;
sigma2_u_t=40*10^6;
sigma2_u_c=246*10^6;
tau12_u=68*10^6;