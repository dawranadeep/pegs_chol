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



%%%%%%%%%%%%%%%%%% Resoulution 1-5 %%%%%%%%%%%%%%%%

for k= 1:5
    tic;
    disp(k)
    
    train_res = readmatrix(strcat("input/temp_matlab/train_res", num2str(k), ".txt"));
    test_res  = readmatrix(strcat("input/temp_matlab/test_res",  num2str(k), ".txt"));
    
    
    water_batch = cell(1+max(cls(:,k)), 1);
    for i = 1:( 1+max(cls(:,k)) )
        this_cl        = find(cls(:,k) == i-1);
        water_batch{i} = water_train(this_cl, :);
    end
    
    
    
    centers = zeros(1+max(cls(:,k)), 2);
    for i = 1:( 1+max(cls(:,k)) )
        centers(i, :) = mean(water_batch{i}(:,1:2));
    end
    
    [~, train_cl1] = pdist2(centers, water_train(:,1:2), 'euclidean', 'smallest', 1);
    [~, test_cl1]  = pdist2(centers, water_test(:,1:2),  'euclidean', 'smallest', 1);
    
    train_which_cl = zeros(size(train_res));
    train_which_cl(sub2ind(size(train_which_cl), 1:size(water_train,1), train_cl1)) = 1;
    train_en = sum(train_res .* train_which_cl, 2);
    
    test_which_cl = zeros(size(test_res));
    test_which_cl(sub2ind(size(test_which_cl), 1:size(water_test,1), test_cl1)) = 1;
    test_en = sum(test_res .* test_which_cl, 2);
    
    disp(strcat("Res ", num2str(k), " Train MSE = ", num2str(sqrt(mean((water_train(:,3) - train_en).^2)))  ))
    disp(strcat("Res ", num2str(k), " Train MAE = ", num2str(mean(abs(water_train(:,3) - train_en)))  ))
    disp(strcat("Res ", num2str(k), " Test MSE = ",  num2str(sqrt(mean((water_test(:,3)  - test_en ).^2)))  ))
    disp(strcat("Res ", num2str(k), " Test MAE = ",  num2str(mean(abs(water_test(:,3) - test_en)))  ))

   
    bottom = min(   [min(test_en), min(train_en), min(water(:,3))  ]);
    top    = max(   [quantile(test_en, 0.9999), quantile(train_en, 0.9999), max(water(:,3))  ]);
    
    subplot(1,2,1);
    scatter(water_train(:,1), water_train(:,2), 0.5, water_train(:,3));
    shading interp;
    clim manual
    clim([bottom top]);
    xlabel('Lon');
    ylabel('Lat');
    title('True Temperature');
    subplot(1,2,2);
    scatter(water_train(:,1), water_train(:,2), 0.5, train_en);
    shading interp;
    clim manual
    clim([bottom top]);
    xlabel('Lon');
    ylabel('Lat');
    title('Predicted Temperature');
    colorbar;
    sgtitle(strcat("Resolution ", num2str(k), ", ", num2str(k*100), " Clusters, Train Data" ));
    exportgraphics(gcf, strcat("output/train_res", num2str(k),".pdf") );
    close()
    
    subplot(1,2,1);
    scatter(water_test(:,1), water_test(:,2), 0.5, water_test(:,3));
    shading interp;
    clim manual
    clim([bottom top]);
    xlabel('Lon');
    ylabel('Lat');
    title('True Temperature');
    subplot(1,2,2);
    scatter(water_test(:,1), water_test(:,2), 0.5, test_en);
    shading interp;
    clim manual
    clim([bottom top]);
    xlabel('Lon');
    ylabel('Lat');
    title('Predicted Temperature');
    colorbar;
    sgtitle(strcat("Resolution ", num2str(k), ", ", num2str(k*100), " Clusters, Test Data" ));
    exportgraphics(gcf, strcat("output/test_res", num2str(k),".pdf") );
    close()


    toc
end

