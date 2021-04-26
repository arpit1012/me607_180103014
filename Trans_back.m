
% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

function sigma_2 = Trans_back(sigma,theta);
c = cosd(theta); s = sind(theta);
T = [ c^2,  s^2,  2*s*c;
       s^2,  c^2, -2*s*c;
      -s*c,  s*c, c^2-s^2];
 sigma_2 = inv(T)*sigma;
 
