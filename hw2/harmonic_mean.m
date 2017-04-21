function [ varargout ] = harmonic_mean( varargin )
% function harmonic_mean: This function calculates the harmonic mean of
% N complete data set.
% Authors: Christopher D. Whitney (2-10-17)
% Extended description


  if (nargin < 1)
    error('Error: A minium of 1 dataset is needed');
  end

  for i = 1 : nargin
    varargout{i} =  ( sum ( varargin{i}.^(-1) ) / length ( varargin{i} ) )^(-1) ;
  end

end  % function harmonic_mean

%!test
%! a = [1 2 3 4 5 6];
%! b = [6 4 8 1 3 1];
%! a1 = [1;2;3;4;5;6];
%! b1 = [6;4;8;1;3;1];
%! [a_mean,b_mean] = harmonicMean (a,b);
%! assert (a_mean, 2.4490);
%! assert (b_mean, 2.0870);
