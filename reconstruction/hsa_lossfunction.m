function f = hsa_lossfunction(q, M)

th = q(1);
a = q(2);
b = q(3);
c = q(4);
tx = q(5);
ty = q(6);
tz = q(7);


w = [(a^2)*(cos(th)^2) + (b^2)*(sin(th)^2) - tx^2;
     (a^2-b^2)*sin(th)*cos(th) - tx*ty;
     -tx*tz;
     -tx;
     (a^2)*(sin(th)^2) + (b^2)*(cos(th)^2) - ty^2;
     -ty*tz;
     -ty;
     c^2 - tz^2;
     -tz;
     -1;
     q(8:end)'];


%f = norm(M.*w, 2);
f = (M*w)'*(M*w);
end

