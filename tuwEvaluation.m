clear all
close all
clc
cd /home/birl/Projects/quadRecon_public;

addpath(genpath('./reconstruction'));
addpath(genpath('./utils'));
addpath(genpath('visualization'));

% tuw_data.mat: 
% partial sequences data (seq1, seq7, seq8, seq10, seq11) from TUW dataset;
% each sequence contains camera poses, object labels, object poses w.r.t
% camera coordinates, 2D bounding box(tl and br corners)

% tuw_model.mat:
% label and point cloud corresponding to objects appearing in TUW dataset

% model_GTs.mat:
% optimal quadric envelop of objects, regarded as grouth truth


load('data/tuw_data.mat');
load('data/tuw_model.mat');
load('data/model_GTs.mat');

DrawWorldCoordinates();



seq_idx = 2;  
%sequences = [1, 2, 3; 2, 3, 4; 3, 4, 5; 4, 5, 6; 5, 6, 7];
sequences = [1, 2, 3;] % views_sequences, e.g. 3 views-basd:1-2-3; 2 views-based:1-3
object_idx = [1:6]; % seq_02



nObjects = length(object_idx);
seq_view = tuw_dataset{seq_idx}.seq_view;
K = tuw_dataset{seq_idx}.K;


for comb= 1:size(sequences,1) 
    view_idx = sequences(comb, :);
    nViews = length(view_idx);
    
    Rwc = cell(1, nViews);
    twc = cell(1, nViews);
    boxes = cell(1, nObjects);
    boxes_2view = cell(1, nObjects);
    
    % 1. load camera poses, bbxes for 3-views based implementation
    for nv=1:nViews
        v_idx = view_idx(nv);
        
        Twc{nv} = seq_view{v_idx}.Twc;
        Rwc{nv} = Twc{nv}(1:3, 1:3);
        twc{nv} = Twc{nv}(1:3, 4);

        Tcw = inv(Twc{nv});
        Rcw{nv} = Tcw(1:3, 1:3);
        tcw{nv} = Tcw(1:3, 4);

        DrawCamera(Rwc{nv}, twc{nv}, K, v_idx, [160 32 240]/255);
        for no = 1:nObjects
            o_idx = object_idx(no);
            boxes{no}{nv} = seq_view{v_idx}.object{no}.bbx;
        end      
        
    end
    
    % 2. load camera poses, bbxes for 2-views based
    for no = 1:nObjects
        boxes_2view{no}{1} = boxes{no}{1};
        boxes_2view{no}{2} = boxes{no}{3};
    end
    Rcw_2view{1} = Rcw{1};
    Rcw_2view{2} = Rcw{3};
    tcw_2view{1} = tcw{1};
    tcw_2view{2} = tcw{3};

    
    % 3. load point cloud and groud truth, reconstruct ellipsoid by various
    % methods
    for no = 1:nObjects
        label = seq_view{1}.object{no}.label;
        Tco = seq_view{1}.object{no}.Tco;
        Two = seq_view{1}.Twc*Tco;
        
        idx = RetrieveIndexByLabel(label);
        model_pc= tuw_model{idx}.pointcloud;
        model_pc = pctransform(model_pc, rigid3d(Two'));
        pcshow(model_pc, 'MarkerSize', 10);
        set(gcf, 'color', 'w');
        set(gca, 'color', 'w');
        set(gca, 'XColor', [0.15, 0.15, 0.15], 'YColor', [0.15, 0.15, 0.15], 'ZColor', [0.15, 0.15, 0.15]);
        
        Qgt = model_GTs{idx}.Q; % ground truth
        Qgt = Two*Qgt*Two';
        DrawQuadric(Qgt, 1, [1, 1, 0], 0.2); % yellow, ground truth reconstructed from point cloud
        
        Q1 = GenerateQuadric_svd(Rcw, tcw, boxes{no}, K); %red, baseline 
        DrawQuadric(Q1, no, [205 0 0]/255, 0.15);
        
        Q2 = GenerateQuadric_hsa(Rcw, tcw, boxes{no}, K); % blue， ours-3views
        DrawQuadric(Q2, no, [0 0 205]/255, 0.15, 'n');
        
        Q3 = GenerateQuadric_hsa(Rcw_2view, tcw_2view, boxes_2view{no}, K); % green， ours-2views
        DrawQuadric(Q3, no, [0 205 0]/255, 0.15, 'n');
        
     
%         % calculate 3D IOU
%         p1(no) = CalculateEllipsoidOverlap(Q1, Qgt, 50000);% baseline
%         p2(no) = CalculateEllipsoidOverlap(Q2, Qgt, 50000);% ours-3Views
%         p3(no) = CalculateEllipsoidOverlap(Q3, Qgt, 50000);% ours-2Views
        
    end

end









