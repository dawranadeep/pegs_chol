cd /ddn/gs1/home/dawr2/water/;
%parpool(40);

water     = readmatrix("input/temp_matlab/water.txt");
cls       = readmatrix("input/temp_matlab/clusters.txt");
cls       = cls';
cls       = cls(:, 2:end);
train_idx = readmatrix("input/temp_matlab/train_idx.txt");
train_idx = train_idx(2:end, :);



water_train = water(train_idx==1, :);
water_test  = water(train_idx==0, :);



%%%%%%%%%%% Resolution 1 %%%%%%%%%%%

this_cl_res = 1;
disp(this_cl_res)
train_res  = zeros(size(water_train,1), 1+max(cls(:,this_cl_res)));
test_res   = zeros(size(water_test,1),  1+max(cls(:,this_cl_res)));

water_batch = cell(1+max(cls(:,this_cl_res)), 1);
for i = 1:( 1+max(cls(:,this_cl_res)) )
    this_cl        = find(cls(:,this_cl_res) == i-1);
    water_batch{i} = water_train(this_cl, :);
end


gprMdls = cell(1+max(cls(:,this_cl_res)), 1);

tic;
parfor i = 1:( 1+max(cls(:,this_cl_res)) )
    %disp(i)
    %gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3), ...
     %             "FitMethod", "sr", "ComputationMethod", "v", ...
      %            "PredictMethod", "sr");
    gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3));
end
toc

tic
for i = 1:( 1+max(cls(:,this_cl_res)) )
    train_res(:,i)  = predict(gprMdls{i}, water_train(:, 1:2));
    test_res(:,i)   = predict(gprMdls{i}, water_test(:, 1:2) );
end    
toc


writematrix(train_res, "input/temp_matlab/train_res1.txt");
writematrix(test_res,  "input/temp_matlab/test_res1.txt");





%%%%%%%%%%% Resolution 2 %%%%%%%%%%%

this_cl_res = 2;
disp(this_cl_res)
train_res  = zeros(size(water_train,1), 1+max(cls(:,this_cl_res)));
test_res   = zeros(size(water_test,1),  1+max(cls(:,this_cl_res)));

water_batch = cell(1+max(cls(:,this_cl_res)), 1);
for i = 1:( 1+max(cls(:,this_cl_res)) )
    this_cl        = find(cls(:,this_cl_res) == i-1);
    water_batch{i} = water_train(this_cl, :);
end


gprMdls = cell(1+max(cls(:,this_cl_res)), 1);

tic;
parfor i = 1:( 1+max(cls(:,this_cl_res)) )
    %disp(i)
    %gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3), ...
     %             "FitMethod", "sr", "ComputationMethod", "v", ...
      %            "PredictMethod", "sr");
    gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3));
end
toc

tic
for i = 1:( 1+max(cls(:,this_cl_res)) )
    train_res(:,i)  = predict(gprMdls{i}, water_train(:, 1:2));
    test_res(:,i)   = predict(gprMdls{i}, water_test(:, 1:2) );
end    
toc


writematrix(train_res, "input/temp_matlab/train_res2.txt");
writematrix(test_res,  "input/temp_matlab/test_res2.txt");





%%%%%%%%%%% Resolution 3 %%%%%%%%%%%

this_cl_res = 3;
disp(this_cl_res)
train_res  = zeros(size(water_train,1), 1+max(cls(:,this_cl_res)));
test_res   = zeros(size(water_test,1),  1+max(cls(:,this_cl_res)));

water_batch = cell(1+max(cls(:,this_cl_res)), 1);
for i = 1:( 1+max(cls(:,this_cl_res)) )
    this_cl        = find(cls(:,this_cl_res) == i-1);
    water_batch{i} = water_train(this_cl, :);
end


gprMdls = cell(1+max(cls(:,this_cl_res)), 1);

tic;
parfor i = 1:( 1+max(cls(:,this_cl_res)) )
    %disp(i)
    %gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3), ...
     %             "FitMethod", "sr", "ComputationMethod", "v", ...
      %            "PredictMethod", "sr");
    gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3));
end
toc

tic
for i = 1:( 1+max(cls(:,this_cl_res)) )
    train_res(:,i)  = predict(gprMdls{i}, water_train(:, 1:2));
    test_res(:,i)   = predict(gprMdls{i}, water_test(:, 1:2) );
end    
toc


writematrix(train_res, "input/temp_matlab/train_res3.txt");
writematrix(test_res,  "input/temp_matlab/test_res3.txt");






%%%%%%%%%%% Resolution 4 %%%%%%%%%%%

this_cl_res = 4;
disp(this_cl_res)
train_res  = zeros(size(water_train,1), 1+max(cls(:,this_cl_res)));
test_res   = zeros(size(water_test,1),  1+max(cls(:,this_cl_res)));

water_batch = cell(1+max(cls(:,this_cl_res)), 1);
for i = 1:( 1+max(cls(:,this_cl_res)) )
    this_cl        = find(cls(:,this_cl_res) == i-1);
    water_batch{i} = water_train(this_cl, :);
end


gprMdls = cell(1+max(cls(:,this_cl_res)), 1);

tic;
parfor i = 1:( 1+max(cls(:,this_cl_res)) )
    %disp(i)
    %gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3), ...
     %             "FitMethod", "sr", "ComputationMethod", "v", ...
      %            "PredictMethod", "sr");
    gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3));
end
toc

tic
for i = 1:( 1+max(cls(:,this_cl_res)) )
    train_res(:,i)  = predict(gprMdls{i}, water_train(:, 1:2));
    test_res(:,i)   = predict(gprMdls{i}, water_test(:, 1:2) );
end    
toc


writematrix(train_res, "input/temp_matlab/train_res4.txt");
writematrix(test_res,  "input/temp_matlab/test_res4.txt");







%%%%%%%%%%% Resolution 5 %%%%%%%%%%%

this_cl_res = 5;
disp(this_cl_res)
train_res  = zeros(size(water_train,1), 1+max(cls(:,this_cl_res)));
test_res   = zeros(size(water_test,1),  1+max(cls(:,this_cl_res)));

water_batch = cell(1+max(cls(:,this_cl_res)), 1);
for i = 1:( 1+max(cls(:,this_cl_res)) )
    this_cl        = find(cls(:,this_cl_res) == i-1);
    water_batch{i} = water_train(this_cl, :);
end


gprMdls = cell(1+max(cls(:,this_cl_res)), 1);

tic;
parfor i = 1:( 1+max(cls(:,this_cl_res)) )
    %disp(i)
    %gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3), ...
     %             "FitMethod", "sr", "ComputationMethod", "v", ...
      %            "PredictMethod", "sr");
    gprMdls{i}  = fitrgp(water_batch{i}(:, 1:2), water_batch{i}(:, 3));
end
toc

tic
for i = 1:( 1+max(cls(:,this_cl_res)) )
    train_res(:,i)  = predict(gprMdls{i}, water_train(:, 1:2));
    test_res(:,i)   = predict(gprMdls{i}, water_test(:, 1:2) );
end    
toc


writematrix(train_res, "input/temp_matlab/train_res5.txt");
writematrix(test_res,  "input/temp_matlab/test_res5.txt");



