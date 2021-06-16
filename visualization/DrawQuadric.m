function DrawQuadric(Q, idx, color, alpha, bOutput)

if nargin<5, bOutput='n'; end
if nargin<4, alpha = 0.2; end
if nargin<3, color = [1 1 1]; end
if nargin<2, idx = 0; end
    

Q = Q/(-Q(4, 4));

% t: position of Quadric
t = -Q(1:3, 4);

Tc = [1 0 0 -t(1);
      0 1 0 -t(2);
      0 0 1 -t(3);
      0 0 0   1 ];
Qc = Tc*Q*Tc';

[V, D] = eig(Qc(1:3, 1:3));
a = sqrt(abs(D(1, 1)));
b = sqrt(abs(D(2, 2)));
c = sqrt(abs(D(3, 3)));

if bOutput=='y'
    fprintf('\n Quadric: a, b, c, tx, ty, tz: \n');
    [a, b, c, t']

end

N = 20;
[X,Y,Z] = ellipsoid(0,0,0,a,b,c,N);
%  rotate and center the ellipsoid to the actual center point
%------------------------------------------------------------
XX = zeros(N+1,N+1);
YY = zeros(N+1,N+1);
ZZ = zeros(N+1,N+1);

for k = 1:length(X)
    for j = 1:length(X)
    point = [X(k,j) Y(k,j) Z(k,j)]';
    P = V * point;
    XX(k,j) = P(1)+t(1);
    YY(k,j) = P(2)+t(2);
    ZZ(k,j) = P(3)+t(3);
    end
end

surface(XX,YY,ZZ, 'linewidth', 0.5, 'FaceAlpha', alpha,'EdgeAlpha',0.5, 'FaceColor', color, 'EdgeColor',color); hold on;
text(t(1),t(2),t(3),num2str(idx),'FontName','Arial','Color',color,'FontWeight','Bold','FontSize',10);
end