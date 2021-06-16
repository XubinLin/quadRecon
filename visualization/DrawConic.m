function [outputArg1,outputArg2] = DrawConic(Rwc, twc, K, Conic, color)

% 输入的conic是dual

if nargin <5, color = [1 0 0]; end;

Twc = [Rwc, twc; 0, 0, 0, 1];

Conic = Conic/-Conic(3,3);

   
t = -Conic(1:2,3);
T = [eye(2),-t];
T = [T; [zeros(1,2) 1];];

Ccenter = T*Conic*T';
Ccenter = 0.5*(Ccenter+Ccenter');

[ R, D ] = eig(Ccenter(1:2,1:2));

ax = sqrt(abs(diag(D)));

% ax, C, R 椭圆的参数

N=200;

 if isreal(ax(1)) && isreal(ax(2))
    theta = 0:1/N:2*pi+1/N;
  
    state(1,:) = ax(1)*cos(theta);
    state(2,:) = ax(2)*sin(theta);
    X = R * state;
    X(1,:) = X(1,:) + t(1);
    X(2,:) = X(2,:) + t(2);
    X(3,:) = ones(1,size(X,2));
    
    X = X*0.5;
    
    Xw = Twc*[inv(K)*X; ones(1, size(X, 2))];
    
    plot3(Xw(1,:),Xw(2,:),Xw(3,:),'Color',color,'LineWidth',2);
    hold on;

 end
end

