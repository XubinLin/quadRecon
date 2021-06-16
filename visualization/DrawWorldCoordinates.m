function DrawWorldCoordinates()
    plot3([0, 0.2], [0, 0], [0, 0], 'Color', 'r', 'LineWidth', 1);
    text(0.2, 0, 0, 'Xw','FontName','Arial','Color','r','FontWeight','Bold','FontSize',5);
    hold on;
    plot3([0, 0], [0, 0.2], [0, 0], 'Color', 'g',  'LineWidth', 1);
    text(0, 0.2, 0, 'Yw','FontName','Arial','Color','g','FontWeight','Bold','FontSize',5);
    hold on;
    plot3([0, 0], [0, 0], [0, 0.2], 'Color', 'b',  'LineWidth', 1);
    text(0, 0, 0.2, 'Zw','FontName','Arial','Color','b','FontWeight','Bold','FontSize',5);
    
    grid on;
end

