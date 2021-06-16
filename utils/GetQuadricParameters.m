function [a, b, c, R, t] = GetQuadricParameters(Q)
    Q = Q/(-Q(4, 4));

    % t: position of Quadric
    t = -Q(1:3, 4);

    Tc = [1 0 0 -t(1);
          0 1 0 -t(2);
          0 0 1 -t(3);
          0 0 0   1 ];
    Qc = Tc*Q*Tc';

    [V, D] = eig(Qc(1:3, 1:3));
    R = V;
    a = sqrt(abs(D(1, 1)));
    b = sqrt(abs(D(2, 2)));
    c = sqrt(abs(D(3, 3)));
end

