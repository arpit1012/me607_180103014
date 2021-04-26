

% ME607: Introduction to composite materials 
% Name: Arpit Agrawal
% Roll Number: 180103014
% Assignment 6: Developing a Computer Code to analyse a Laminate

function Q = Stiffness2(E1,E2,G12,v12,theta)
c = cosd(theta); s = sind(theta);
Q_red = [  E1, 0,     0;
          0,   0,     0;
          0,   0,     0 ];

 T = [ c^2,  s^2,  2*s*c;
       s^2,  c^2, -2*s*c;
      -s*c,  s*c, c^2-s^2];
  
  R = [ 1 0 0;
        0 1 0;
        0 0 2];
    
  Q = inv(T)*Q_red*R*T*inv(R);
  