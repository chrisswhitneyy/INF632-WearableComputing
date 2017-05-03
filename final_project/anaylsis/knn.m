function [ test_set ] = knn( a_x, a_y, b_x , b_y, test_set)
% knn: Calculats the k nearest neighbors using two groups, passed in as a_x, a_y
% b_x, b_y and a test_set
%

  % glue together a_x and a_y into a matrix
  % add in another classification (start with 0)
  % same for b_x and b_y (including the classification of 1)
  % this will result in a big martix with [a_x, a_y, zeros; b_x, b_y, ones;]
  train_set = [a_x, a_y, zeros( size(a_x,1) , 1) ; b_x, b_y, ones( size (b_x,1), 1) ];

  % make a set of x and y of unclassified data
  % use min(a_x & b_x), max(a_x & b_x), mins(y's), max(y's) =  matrix ...
  % of possible points to consider
  %test_set = zeros(100,100);
  % ==== Find it's K NN ====
  % can create a set of k's

  % set k
  k = 5;

  % Loop through each point in the test set
  for x = 1:size(test_set)(2)
    for y = 1:size(test_set)(1)
      % Grab single point
      this_xy = [x,y];

      % 1. Find the distance from xy to each classifed point
      % -> output a vector of distances
      this_distance = sqrt( sum( (train_set(:,1:2) - this_xy).^2 , 2) );
      % append classification back on this_dist_class
      this_dist_class = [this_distance , train_set(:,3)];

      % 2. Sort on the rows, (keep track classification)
      % find the K smallest distances -> k smallest distance with classifications
      this_dist_closest = sortrows(this_dist_class,1)(1:k,1:2);

      % 3a. Find the probable assignment from this K group
      this_likley = mode( this_dist_closest(:,2) );
      % 3b. Assing this xy the same as the most probable
      test_set(x , y) = this_likley;
    end
  end
endfunction
