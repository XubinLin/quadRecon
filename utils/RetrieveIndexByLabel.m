function [idx] = RetrieveIndexByLabel(label)

LABEL_INDEX = {      'asus_box',              'burti',         'canon_camera_bag',   'cisco_phone',...
              'coffee_container',     'felix_ketchup',        'fruchtmolke',   'jasmine_green_tea',... 
            'muller_milch_banana',  'muller_milch_shoko',     'opencv_book',   'red_mug_white_spots',...
                  'skull',         'strands_mounting_unit',   'toilet_paper',     'water_boiler', ...
             'yellow_toy_car'   };
idx = find(strcmp(LABEL_INDEX, label));
end

