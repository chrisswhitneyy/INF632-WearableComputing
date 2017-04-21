function [ varargout ] = anova( varargin )
% anava: Calculates the anova for complete data sets.
%
% Authors: Christopher D. Whitney (cw729@nau.edu)

  if (nargin ~= 3)
    error('Error: Three data set are needed.');
  end

  % n of each group
  a_n = length(varargin{1});
  b_n = length(varargin{2});
  c_n = length(varargin{3});
  n = a_n + b_n + c_n;

  % sum of each group
  a_sum = sum(varargin{1});
  b_sum = sum(varargin{2});
  c_sum = sum(varargin{3});

  % total sum
  total_sum = a_sum + b_sum + c_sum;

  % sum of squares
  square_sum = sum(varargin{1}.^2) + sum(varargin{2}.^2) + sum(varargin{3}.^2);

  % total sum of squares
  ss_r = square_sum - (total_sum^2 / n);

  % sum of squares between groups
  ss_b = (a_sum^2 / a_n) + (b_sum^2 / b_n) + (c_sum^2 / c_n) - (total_sum^2 / n);

  % sum of sqaures within groups
  ss_w = ss_r - ss_b;

  % degrees of freedom
  df_b = 2;
  df_w = n - 3;

  % ms
  ms_b = ss_b / df_b;
  ms_w = ss_w / df_w;

  % F
  f = ms_b / ms_w;
  pval = 1 - fcdf (f, df_b, df_w);
  % assign output
  varargout{1} = pval;

end  % anava
%!test
%! anova();
