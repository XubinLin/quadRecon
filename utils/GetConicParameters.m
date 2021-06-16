function [ax, C, R] = GetConicParameters(Ch)
s=size(Ch,1);

if Ch(3,3)>0
    Ch = Ch/-Ch(3,3);
end
   
C = -Ch(1:s-1,s);

T = [eye(s-1),-C];

T = [T; [zeros(1,s-1) 1];];

Chcenter = T*Ch*T';
Chcenter = 0.5*(Chcenter+Chcenter');

[ V, D ] = eig(Chcenter(1:s-1,1:s-1));

ax = sqrt(abs(diag(D)));

R = V;
end