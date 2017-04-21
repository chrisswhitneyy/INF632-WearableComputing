function [ varargout ] = pooled_std( varargin )
% pooled_std: Calculates the pooled std of either two data sets or from
% supplied characteristics. The characteristics are passed in the following
% format : (mean,std,n) (mean,std,n). The data sets are passed as two nx1
% matrixes
%
% Author: Christopher D. Whitney (cw729@nau.edu)

  if (nargin < 1)
    error('Error: A minium of 1 dataset is needed');
  end

  switch (nargin)
    % Case where there's two data sets
    case 2
      n1_mean = mean (varargin{1});
      n1_std = std (varargin{1});
      n1 = length (varargin{1});

      n2_mean = mean (varargin{2});
      n2_std = std (varargin{2});
      n2 = length (varargin{2});

    % Case where there's characteristics
    case 6
      n1_mean =varargin{1};
      n1_std = varargin{2};
      n1 = varargin{3};

      n2_mean =varargin{4};
      n2_std = varargin{5};
      n2 = varargin{6};
    % Error case
    otherwise
      error (' Error: number of args does not match now characteristics / data set.');
  endswitch

  varargout{1} = sqrt( ( (n1-1)*n1_std^2 + (n2-1)*n2_std^2) / (n1+n2-2) );

end  % pooled_std
