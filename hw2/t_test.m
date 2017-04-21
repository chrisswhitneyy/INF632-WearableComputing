function [ varargout ] = t_test ( varargin )
% t_test: Calculates the t-score for supplied characteristics and complete data sets.
% Characteristics should be passed as the following (n,mean,std)(n,mean,sd)
% Complete data sets are passed as (set1, set2)
% Authors: Christopher D. Whitney (cw729@nau.edu)

  if (nargin < 2)
    error('Error: A minium of 2 dataset is needed');
  end

  switch nargin
    case 2 % Complete data sets case
      n1 = numel(varargin{1});
      n2 = numel(varargin{2});
      m1 = mean(varargin{1});
      m2 = mean(varargin{2});
      s1 = std(varargin{1});
      s2 = std(varargin{2});

    case 6 % Supplied characteristics case
      n1 = varargin{1};
      m1 = varargin{2};
      s1 = varargin{3};
      n2 = varargin{4};
      m2 = varargin{5};
      s2 = varargin{6};

    otherwise
      error('Number of arguments does not match a known config.');
    end % End of switch

    varargout{1} = tcdf( (m1 - m2) / sqrt ( s1/n1 + s2/n2 ), n1 );

end % t_test
