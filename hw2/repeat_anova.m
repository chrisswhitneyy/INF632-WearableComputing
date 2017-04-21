function [ varargout ] = repeat_anova( varargin )
% repeat_anova: Calculates the repeat measurement anova based on a matrix
% based where the rows are the subjects and the collumns are the conditions.
%
% Author: Christopher D. Whitney (cw729@nau.edu)

  if (nargin < 1)
    error('At least one argument is need.');
  end
  X = varargin{1};

  % Calculate the mean of the measurments, subjects, and total
  mean_sub = mean(X,2);
  mean_mes = mean(X,1);
  mean_tot = sum(sum(X)) / (size(X,1) * size(X,2));

  % Cacluate number of samples and subjects
  N = size(X,1);
  K = size(X,2);

  % Cacluate sum of squares of measures, subjects, total, and error
  SS_measures = N * sum((mean_mes - mean_tot).^2);
  SS_subjects = K * sum((mean_sub - mean_tot).^2);
  SS_total = sum( sum(  (X - mean_tot).^2)   );
  SS_error = SS_total - SS_measures - SS_subjects;

  % Cacluate degrees of freedom
  df_measures = K - 1;
  df_subjects = N - 1;
  df_grand = (N*K) - 1;
  df_error = df_grand - df_measures - df_subjects;

  % Calculate mean squares
  MS_measures = SS_measures / df_measures;
  MS_subjects = SS_subjects / df_subjects;
  MS_error = SS_error / df_error;

  % Cacluate F ratio and probability of F
  F = MS_measures / MS_error;
  p = 1 - fcdf(F, df_measures, df_error);

  % Assign outputs to varargout
  varargout{1} = p;
  varargout{2} = F;

end  % function repeat_anova

%!test
%! repeatedAnova();
