

% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

function alpha=Trans_layer(alpha_l,theta)
c = cosd(theta); s = sind(theta);
T = [ c^2,  s^2,  2*s*c;
       s^2,  c^2, -2*s*c;
      -s*c,  s*c, c^2-s^2];
 alpha = inv(T)*alpha_l;
 alpha(3,1) = 2*alpha(3,1);
end
