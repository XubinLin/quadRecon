function [outputArg1,outputArg2] = DrawBBx(Rwc, twc, K, box, color)
if nargin<5, color = [0, 0, 1]; end


Twc = [Rwc, twc; 0, 0, 0, 1];

[boxPts_u, boxPts_v] = meshgrid([box(1), box(3)], [box(2), box(4)]);
boxPts_or = [1 3, 4, 2];
boxPts_uv1 = [boxPts_u(boxPts_or); boxPts_v(boxPts_or); ones(1, size(boxPts_u(boxPts_or), 2))]*0.5;
% 物体检测框角归一化平面坐标， 在世界坐标系下的表达
boxPts_xy1 = Twc*[inv(K)*boxPts_uv1; ones(1, size(boxPts_uv1, 2))];
patch(boxPts_xy1(1,:), boxPts_xy1(2,:), boxPts_xy1(3,:), color, 'FaceAlpha', 0.2);


end

