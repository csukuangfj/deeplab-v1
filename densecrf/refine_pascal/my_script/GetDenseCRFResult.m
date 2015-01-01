clear all;

load('pascal_seg_colormap');

is_server = 1;

pos_w     = 3;
pos_x_std = 3;

bi_w      = 3;    %5;
bi_x_std  = 95;   %50;
bi_r_std  = 3;    %10;

id = 'comp6';
%trainset = 'train_aug';  %'trainval_aug';
trainset = 'trainval_aug';

%testset  = 'val';        %'val', 'test'
testset  = 'test';

model_name = 'vgg128_ms_pool3'; %vgg128_noup, vgg128_noup_glob, vgg128_ms
feature_name = 'features2'; %'', 'features4', 'features2'  %% use '' for 'features'

if is_server
  %map_folder = fullfile('/rmt/work/deeplabel/exper/voc12/res', model_name, testset, 'fc8', sprintf('post_densecrf_W%d_XStd%d_RStd%d_PosW%d_PosXStd%d', bi_w, bi_x_std, bi_r_std, pos_w, pos_x_std)); 
  map_folder = fullfile('/rmt/work/deeplabel/exper/voc12/res', feature_name, model_name, testset, 'fc8', sprintf('post_densecrf_W%d_XStd%d_RStd%d_PosW%d_PosXStd%d', bi_w, bi_x_std, bi_r_std, pos_w, pos_x_std)); 
else 
  map_folder = '../result';
end

map_dir = dir(fullfile(map_folder, '*.bin'));

save_root_folder = map_folder;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% You do not need to change values below
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
seg_res_dir = [save_root_folder '/results/VOC2012/'];
save_result_folder = fullfile(seg_res_dir, 'Segmentation', [id '_' testset '_cls']);

if ~exist(save_result_folder, 'dir')
    mkdir(save_result_folder);
end

for i = 1 : numel(map_dir)
    fprintf(1, 'processing %d (%d)...\n', i, numel(map_dir));
    map = LoadBinFile(fullfile(map_folder, map_dir(i).name), 'int16');

    img_fn = map_dir(i).name(1:end-4);
    imwrite(uint8(map), colormap, fullfile(save_result_folder, [img_fn, '.png']));
end
