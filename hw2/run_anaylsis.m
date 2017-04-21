% This script runs the anaylsis needed for INF 632 HW2
% Author: Christopher D. Whitney (cw729@nau.edu)

load([ 'data' filesep '2weeks.mat' ]);
load([ 'data' filesep 'dailySteps.mat' ]);

% Convert cells to matrix
act_steps = [];
fitbit_steps = [];
for i = 1:length(data.a_Steps)
    act_steps(i) = data.a_Steps(i);
end
for i = 1:length(dailySteps.steptotal)
  fitbit_steps(i) = dailySteps.steptotal{i,1}(1);
end


% Calculate means
act_hmean = harmonic_mean(act_steps);
act_mean = mean(act_steps);
fit_hmean = harmonic_mean(fitbit_steps);
fit_mean = mean(fitbit_steps);

disp("==== Tendency ====");
disp(['Act harmonic mean: ' num2str(act_hmean) ' Mean: ' num2str(act_mean)]);
disp(['Fitbit harmonic mean: ' num2str(fit_hmean) ' Mean: ' num2str(fit_mean)]);

% Calculate varainces
p_std = pooled_std(fitbit_steps,act_steps);

disp("==== Variance ====");
disp(['Pooled std: ' num2str(p_std)]);

% Calculate t-score
t_score = t_test(fitbit_steps,act_steps);

disp("==== T-Score ====");
disp( ["Score: " num2str(t_score)] );

% Grab days of the week steps
% Act days
act_steps_m = [];
act_steps_t = [];
act_steps_w = [];
act_steps_th = [];
act_steps_f = [];
act_steps_s = [];
act_steps_su = [];
for i = 1:length(data.a_DayOfWeek)
  if (strcmp(data.a_DayOfWeek(i,1:2),'Mo') == 1)
    act_steps_m(end+1) = data.a_Steps(i);
  elseif (strcmp(data.a_DayOfWeek(i,1:2),'Tu') == 1)
    act_steps_t(end+1) = data.a_Steps(i);
  elseif (strcmp(data.a_DayOfWeek(i,1:2),'We') == 1)
    act_steps_w(end+1) = data.a_Steps(i);
  elseif (strcmp(data.a_DayOfWeek(i,1:2),'Th') == 1)
    act_steps_th(end+1) = data.a_Steps(i);
  elseif (strcmp(data.a_DayOfWeek(i,1:2),'Fr') == 1)
    act_steps_f(end+1) = data.a_Steps(i);
  elseif  (strcmp(data.a_DayOfWeek(i,1:2),'Sa') == 1)
    act_steps_s(end+1) = data.a_Steps(i);
  elseif  (strcmp(data.a_DayOfWeek(i,1:2),'Su') == 1)
    act_steps_su(end+1) = data.a_Steps(i);
  endif
end

% Fitbit days
fit_steps_m = [];
fit_steps_t = [];
fit_steps_w = [];
fit_steps_th = [];
fit_steps_f = [];
fit_steps_s = [];
fit_steps_su = [];
for i = 1:length(dailySteps.activityday)
  day = weekday( dailySteps.activityday{i,1} );
  switch day
    case 1
      fit_steps_su(end+1) = dailySteps.steptotal{i,1}(1);
    case 2
      fit_steps_m(end+1) = dailySteps.steptotal{i,1}(1);
    case 3
      fit_steps_t(end+1) = dailySteps.steptotal{i,1}(1);
    case 4
      fit_steps_w(end+1) = dailySteps.steptotal{i,1}(1);
    case 5
      fit_steps_th(end+1) = dailySteps.steptotal{i,1}(1);
    case 6
      fit_steps_f(end+1) = dailySteps.steptotal{i,1}(1);
    case 7
      fit_steps_s(end+1) = dailySteps.steptotal{i,1}(1);
    otherwise
      error('Weekday() returned invalid day of the week.');
    endswitch
end

% Calculate anova
mt_val = anova(fit_steps_m,act_steps_m,fit_steps_t);
tw_val = anova(fit_steps_t,act_steps_t,fit_steps_w);
wt_val = anova(fit_steps_w,act_steps_w,fit_steps_th);
thf_val = anova(fit_steps_th,act_steps_th,fit_steps_f);
fs_val = anova(fit_steps_f,act_steps_f,fit_steps_s);
ss_val = anova(fit_steps_s,act_steps_su,fit_steps_su);
sm_val = anova(fit_steps_su,act_steps_su,fit_steps_m);

disp("==== Anova DoW ====");
disp( ["Score m-t: " num2str(mt_val) " Score t-w: " num2str(tw_val)] );
disp( ["Score w-th: " num2str(wt_val) " Score th-f: " num2str(thf_val)] );
disp( ["Score m-t: " num2str(mt_val) " Score t-w: " num2str(tw_val)] );
disp( ["Score w-th: " num2str(wt_val) " Score th-f: " num2str(thf_val)] );
disp( ["Score f-s: " num2str(fs_val) " Score s-su: " num2str(ss_val)] );
disp( ["Score su-m: " num2str(fs_val)] );

% Divide data sets in half
act_1 = act_steps(1,1:round(end/2) - 1);
act_2 = act_steps(1,round(end/2) + 1: end);
fitbit_1 = fitbit_steps(1,1:round(end/2)-1);
fitbit_2 = fitbit_steps(1,round(end/2) + 1: end);

% Fill missing points w/ mean
fitbit_1(1,333:50300) = fit_mean;
fitbit_2(1,333:50300) = fit_mean;

mat_all = [act_1 ; act_2 ; fitbit_1 ; fitbit_2];

p_val = repeat_anova(mat_all);

disp("==== Repeated Anova ====");
disp([ "p-value : "  num2str(p_val) ]);
