function [Qadj] = GenerateQuadric_hsa(Rcw, tcw, box, K)
% Rcw, tcw: poses of all views
% box: bounding boxes correspoinding to each view
% K:   Camera Intrinsic Matrix

% ours, with horizontal support assumption

nView = size(Rcw, 2);



for nv=1:nView
    
    % 1. Get Dual Conic from bounding box
    a = abs(box{nv}(3)-box{nv}(1))/2;
    b = abs(box{nv}(4)-box{nv}(2))/2;
    t = [(box{nv}(1)+box{nv}(3))/2, (box{nv}(2)+box{nv}(4))/2];
    Ccn = [ a^2,   0,    0; 
             0,	  b^2,   0;
             0,    0,   -1];
    Tc = [1, 0, t(1);
          0, 1, t(2);
          0, 0,   1  ];
    C = Tc*Ccn*Tc';
    C = 0.5*(C+C');
    C = C/(-C(3, 3));
    
    Twc = inv([Rcw{nv}, tcw{nv}; 0, 0, 0, 1]);
    %DrawConics(Twc(1:3, 1:3), Twc(1:3, 4), K, C, [0 1 0]);
    
    % 2. Pre-condition Dual Conic to make it canoical
    l = sqrt(a^2 + b^2);
    H = [l,   0,   t(1);
         0,   l,   t(2);
         0,   0,    1  ];
    H = inv(H);    
    C_t    = H*C*H';    
    C_tv   = sym2vec(C_t);
    C_tv   = C_tv/-C_tv(end);
            
    % 3. Get B matrix from represent H^(-1)P with quadratic form
    P = K*[Rcw{nv}, tcw{nv}];
    P_fr = P'*H';
    n_f = size(P_fr,1)/4;
    for f=1:n_f
        Pf                          = P_fr(4*f-3:4*f,:)';
        vecP(f,1:12)               = Pf(:)';
    end
    B = ComputeBmatrix(vecP);
    
    % 4. Get M matrix by collect B and -C_tv
    M(6*nv-5:6*nv,1:10) = B;
    M(6*nv-5:6*nv,10+nv) = -C_tv;
end

% theta, a, b, c, x, y, z, rho1, rho2, ...
q0 = 0.1*ones(size(M,2)-3, 1)';

A=[]; % 线性不等式约束
b=[];
Aeq=[]; %线性等式约束
beq=[];
vlb = [-pi, 0.02,   0.02,  0.02, -1, -1, -1]; % low bound
vub = [ pi,  0.3,   0.3,   0.3,   1,  1,  1]; % up bound
nonlcon = [];
options = optimoptions('fmincon', 'Display','off');
warning off;
w = fmincon(@(q) hsa_lossfunction(q,M), q0, A, b, Aeq, beq, vlb, vub, nonlcon, options);

th=w(1); a=w(2); b=w(3); c=w(4); tx=w(5); ty=w(6); tz=w(7);

Qadjv = [(a^2)*(cos(th)^2) + (b^2)*(sin(th)^2) - tx^2;
         (a^2-b^2)*sin(th)*cos(th) - tx*ty;
         -tx*tz;
         -tx;
         (a^2)*(sin(th)^2) + (b^2)*(cos(th)^2) - ty^2;
         -ty*tz;
         -ty;
         c^2 + tz^2;
         -tz;
         -1;];

Qadj = vec2sym(Qadjv);


end

