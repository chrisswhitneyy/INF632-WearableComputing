% Script to run anaylsis

% input data
data = load('data.txt');

% sum of squares of movements at these points
m = ( data(:,5).^2 .+ data(:,6).^2 .+ data(:,7).^2 ) .^(0.5);
% simplfy data acc to one point motion
data_reduced = [data(:,4), m , data(:,11)];

X = [data_reduced(:,1),data_reduced(:,3)];
Y = [data_reduced(:,2),data_reduced(:,3)];

% divide 30% of data for training set and 70% for testing set

num_points = size(data_reduced(:,1),1)(1);
split_point = round(num_points*0.3);
seq = randperm(num_points);

X_train = X(seq(1:split_point),:);
Y_train = Y(seq(1:split_point),:);

X_test = X(seq(split_point+1:end),:);
Y_test = Y(seq(split_point+1:end),:);

testing_set = [X_test(:,1),Y_test(:,1),X_test(:,2)];

% call KNN

% call classify
results = classify([X_test(:,1),Y_test(:,1)],[X_train(:,1),Y_train(:,1)],X_train(:,2),'quadratic');

disp([results, X_test(:,2)])
% plot
close all;

figure
hold on
title('Classify() Predictions');
plot(Y_test(find ( results == 0 ),:),X_test(find ( results == 0 ),:),'+ob','MarkerSize',9);
plot(Y_test(find ( results == 1 ),:),X_test(find ( results == 1 ),:),'+or','MarkerSize',9);
plot(Y_test((Y_test(:,2)==0),1),X_test((X_test(:,2)==0),1),'+b','MarkerSize',10);
plot(Y_test((Y_test(:,2)==1),1),X_test((X_test(:,2)==1),1),'+r','MarkerSize',10);
ylabel('gas reading');
xlabel('root of sum of squares of accel');

figure
hold on
title('Gas reading vs. Time');
plot(data((data(:,11)==0),4),'+b','MarkerSize',10);
plot( [-50000*ones(length(data((data(:,11)==0),4)),1) ; data((data(:,11)==1),4) ],'+r','MarkerSize',10);
ylabel('gas reading');
xlabel('data point');
legend('not tipsy','tipsy');

figure
hold on
title('AccelX vs. Gas reading');
plot(data((data(:,11)==0),5),data_reduced((data_reduced(:,3)==0),1),'+b','MarkerSize',10);
plot(data((data(:,11)==1),5),data_reduced((data_reduced(:,3)==1),1),'+r','MarkerSize',10);
xlabel('root of sum of squares of accel');
ylabel('gas reading');
legend('not tipsy','tipsy');

figure
hold on
title('AccelY vs. Gas reading');
plot(data((data(:,11)==0),6),data_reduced((data_reduced(:,3)==0),1),'+b','MarkerSize',10);
plot(data((data(:,11)==1),6),data_reduced((data_reduced(:,3)==1),1),'+r','MarkerSize',10);
xlabel('root of sum of squares of accel');
ylabel('gas reading');
legend('not tipsy','tipsy');

figure
hold on
title('AccelZ vs. Gas reading');
plot(data((data(:,11)==0),7),data_reduced((data_reduced(:,3)==0),1),'+b','MarkerSize',10);
plot(data((data(:,11)==1),7),data_reduced((data_reduced(:,3)==1),1),'+r','MarkerSize',10);
xlabel('root of sum of squares of accel');
ylabel('gas reading');
legend('not tipsy','tipsy');

% plot reduced data
figure
hold on
title('General Movement vs. Gas Reading');
plot(data_reduced(data_reduced(:,3)==0,2),data_reduced(data_reduced(:,3)==0,1),'+b','MarkerSize',9);
plot(data_reduced(data_reduced(:,3)==1,2),data_reduced(data_reduced(:,3)==1,1),'+r','MarkerSize',9);
ylabel('gas reading');
xlabel('sum of squares of accel');
legend('not tipsy','tipsy');


% compare predicted classifcations with observed
% picture time


%% ====PLOT====

% Plot all sum of squares movements w/ flagged journal points

% Plot classifcations accuracy
