function [change_point_out, x_out, confidence_out] = cpa(varargin)
% Change Point Analysis
%
%  [change_point_out, x_out, confidence_out] = cpa(varargin)
%
%  X = varargin{1};
%  T = varargin{2};
%  name = varargin{3};
%  glue_joints = varargin{4};
%  depth = 1;
%
% All options greater than varargin{1} are optional, but must be used in order
%
% Kyle Winfree
% April 2013

switch nargin
	case 1
		% no time data provided, so ignore that
		X = varargin{1};
		T = [1:length(X)];
		name = [];
		glue_joints = [];
		depth = 1;
		
	case 2
		% time data provided, use it for plotting purposes
		X = varargin{1};
		if (ischar(varargin{2}))
			T = [1:length(X)];
			name = varargin{2};
		else
			T = varargin{2};
			name = [];
		end
		glue_joints = [];
		depth = 1;

	case 3
		X = varargin{1};
		T = varargin{2};
		name = varargin{3};
		glue_joints = [];
		depth = 1;

	case 4
		X = varargin{1};
		T = varargin{2};
		name = varargin{3};
		glue_joints = varargin{4};
		depth = 1;
		
%  	case 5
%  		X = varargin{1};
%  		T = varargin{2};
%  		name = varargin{3};
%  		glue_joints = varargin{4};
%  		depth = varargin{5};
		

	otherwise
		error('Dude, view the help')
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% initialize stuff, yes, stuff
bootstrap_iterations = 1000;
change_point_out = NaN;
x_out = [];
confidence_out = [];

X_mean = mean(X); % mean, mu
X_std = std(X); % standard deviation, sigma
X_ste = X_std / sqrt(length(X)); % standard error
CI_lower = X_mean - 1.96*X_ste; % lower 95% confidence interval, from the cumalitve normal distribution function
CI_upper = X_mean + 1.96*X_ste;
CL_lower = X_mean - 3*X_std; % control limit, which includes
CL_upper = X_mean + 3*X_std;

X_err = (X - ones(size(X))*X_mean); % error from mean
Z = X_err / X_std; % z-score
filter_2sd = abs(Z) <= 1.96; % remove the probable outliers, keep +/- 1.96 SD, so middle 95%
Z_filtered = Z(filter_2sd);

X_filtered = X(filter_2sd);
X_mean_filtered = mean(X_filtered);
X_err_filtered = (X_filtered - ones(size(X_filtered))*X_mean_filtered);
T_filtered = T(filter_2sd);

%  window_size = 13; % always set to an odd number!
%  ravg_window = ones(1,window_size) * (1/window_size); % this is an equal weighted average
%  Z_ravg = conv(Z_filtered, ravg_window, 'same'); % rolling average of the z-score ADD 'SAME' WHEN OCTAVE VERSION > 3.6
csum_err = cumsum(X_err_filtered); % _filtered

csum_std = std(csum_err); % standard deviation, sigma
csum_ste = csum_std / sqrt(length(csum_err)); % standard error
csum_CI_lower = mean(csum_err) - 1.96*csum_ste; % lower 95% confidence interval, from the cumalitve normal distribution function
csum_CI_upper = mean(csum_err) + 1.96*csum_ste;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% lets do some bootstrapping!
csum_err_bootstrap = [];
for i = 1:bootstrap_iterations
	X_bootstrap = [X_err_filtered', rand(size(X_err_filtered'))];
	X_bootstrap = sortrows(X_bootstrap, 2)'(1,:);
	csum_err_bootstrap = [csum_err_bootstrap; cumsum(X_bootstrap)];
end

if (~isempty(name))
% now plot it if a name has been specified
	fig_csum = figure;
	plot(T_filtered, csum_err)
	hold on
	for i=1:bootstrap_iterations
		plot(T_filtered, csum_err_bootstrap(i,:), 'r');
	end
	plot(T_filtered, csum_err, 'LineWidth', 2);
	if (~isempty(glue_joints))
		axes = axis;
		plot([glue_joints; glue_joints], [ones(1,5)*axes(3); ones(1,5)*axes(4)], 'g', 'LineWidth', 2)
	end
	printfig77(fig_csum, [name, '_cusum']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% determine if we have a real change point
range_bootstrap = max(csum_err_bootstrap, [], 2) - min(csum_err_bootstrap, [], 2);
range_csum = max(csum_err, [], 2) - min(csum_err, [], 2);
[x, ix] = max(abs(csum_err));
change_point = T(ix);
confidence = sum(range_bootstrap < range_csum) / length(range_bootstrap);

if (confidence > .975) % Barry had suggested 97.5%, but why not 90%?
	change_point_out = change_point;
	x_out = x;
	confidence_out = confidence;
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make a perty plot
if (~isempty(name))
	figure, plot([T(1), T(end)], [0, 0], 'r', 'LineWidth', 2)
	hold on
	plot([T(1), T(1); T(end), T(end)], [2, -2; 2, -2], 'r', 'LineWidth', 1)
%  	plot([1, T(end)], [-2, -2], 'r', 'LineWidth', 1)
	axes = axis;
%  	axis([axes(1) axes(2) -3 3]);
%  	plot(T_filtered, Z_ravg(ceil(length(ravg_window)/2):end-floor(length(ravg_window)/2)), 'b', 'LineWidth', 1)
%  	plot(T_filtered, Z_ravg, 'b', 'LineWidth', 1)
	if (~isnan(change_point_out))
%  		plot([T(1), T(1); T(end), T(end)], [csum_CI_upper, csum_CI_lower; csum_CI_upper, csum_CI_lower], 'g', 'LineWidth', 1);
		plot([change_point, change_point], [axes(3), axes(4)], 'm', 'LineWidth', 1)
	end
	[ax, h1, h2] = plotyy(T, Z, T_filtered, csum_err, @plot, @plot); % _filtered
	hold on
	if (~isnan(change_point_out))
		plot([T(1), T(end)], [csum_CI_upper, csum_CI_upper], 'g', 'LineWidth', 1);
		plot([T(1), T(end)], [csum_CI_lower, csum_CI_lower], 'g', 'LineWidth', 1);
%  		plot([change_point, change_point], [axes(3), axes(4)], 'm', 'LineWidth', 1)
	end
	hold off
	if (~ischar(varargin{2}))
		xlabel('T');
	else
		xlabel('Sample');
	end
	ylabel(ax(1), 'z-score');
	ylabel(ax(2), 'cumulative sum');

	set(h1, 'LineStyle', 'none', 'Marker', '*', 'LineWidth', 2);
	set(h2, 'LineWidth', 2);


	printfig77(gcf, name);
	
	fid = fopen([name, '.txt'], 'w');
	fprintf(fid, 'mean = %1.3f\n', X_mean);
	fprintf(fid, 'standard deviation = %1.3f\n', X_std);
	fprintf(fid, 'standard error = %1.3f\n', X_ste);
	fprintf(fid, 'confidence interval upper = %1.3f\n', CI_upper);
	fprintf(fid, 'confidence interval lower = %1.3f\n', CI_lower);
	fprintf(fid, 'control limit upper = %1.3f\n', CL_upper);
	fprintf(fid, 'control limit lower = %1.3f\n', CL_lower);
	fprintf(fid, 'change point location = %1.3f\n', change_point);
	fprintf(fid, 'change point value = %1.3f\n', x);
	fprintf(fid, 'confidence = %1.3f\n', confidence);
	fprintf(fid, 'csum mean = %1.3f\n', mean(csum_err));
	fprintf(fid, 'csum standard error = %1.3f\n', csum_ste);
	fprintf(fid, 'csum confidence interval upper = %1.3f\n', csum_CI_upper);
	fprintf(fid, 'csum confidence interval lower = %1.3f\n', csum_CI_lower);
	fclose(fid);
end