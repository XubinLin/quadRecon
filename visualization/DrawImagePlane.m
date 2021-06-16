function [outputArg1,outputArg2] = DrawImagePlane(Rwc, twc, K, color)
if nargin < 5, color = [0, 0, 1]; end

Twc = [Rwc, twc; 0, 0, 0, 1];

% supposed image size is 640*480
[im_u, im_v] = meshgrid([0, 640], [0, 480]);
im_or = [1 3, 4, 2];
im_uv1 = [im_u(im_or); im_v(im_or); ones(1, size(im_u(im_or), 2))]*0.5;
im_xy1 = Twc*[inv(K)*im_uv1; ones(1, size(im_uv1, 2))];
patch(im_xy1(1,:), im_xy1(2,:), im_xy1(3,:), color, 'FaceAlpha', 0.2);


end

