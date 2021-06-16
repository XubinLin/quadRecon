function DrawCamera(Rwc, twc, K, idx, color)
if nargin < 5 , color = [0 0 0]; end
if nargin < 4 , idx = 0; end

% transfomation in matlab is row major, thus Rwc needs to be transposed
pose = rigid3d(Rwc',(twc)');
plotCamera('AbsolutePose', pose, 'Opacity', 0.3, 'size',0.05 , 'AxesVisible', true, 'color', color); hold on;
text(twc(1), twc(2), twc(3),num2str(idx),'FontName','Arial','Color',[0 0 0 ],'FontWeight','Bold','FontSize',11);


grid on;
axis equal;
xlim([-4, 4]);
ylim([-4, 4]);
zlim([-4, 4]);

end