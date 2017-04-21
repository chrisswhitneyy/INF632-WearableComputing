function [ cluster, centroids ] =  kmeans( k, x1, x2 )
% Kmeans: A calculates the kmeans clusters.
% Takes in a k and two row vector data sets (x1 x2)


  % Intializing our centroids (centers)
  for i = 1:k
    % Pick random points
    r_idx = ceil ( rand(1) * size(x1,1) );
    % Assign random points to a cluster
    cluster{i} = [x1(r_idx,1) , x2(r_idx,1)];
    % Remove r_idx from x1 and x2
    x1 = x1(1:size(x1,1) ~= r_idx);
    x2 = x2(1:size(x2,1) ~= r_idx);
  end

  while ( size(x1,1) ~= 0)
      % re-calculate the centroids
      for i = 1:k
        centroids(i, 1:2) = mean ( cluster{i} , 1 );
      end

      % pick the next points to assign to a cluster
      r_idx = ceil ( rand(1) * size(x1,1) );

      % calculate distances
      % x^2 + y^2 = z^2, (x1a - x2b)^2 ...
      for i = 1:k
        dist_point(i) = sqrt( sum( ([x1(r_idx,1) , x2(r_idx,1)] - centroids(i,1:2) ).^2 , 2) );
      end

      % find closet cluster
      [temp, c_idx] = min(dist_point);
      % assign to cluster
      cluster{1,c_idx} = [cluster{1,c_idx}; x1(r_idx,1) , x2(r_idx,1)];

      % Remove r_idx from x1 and x2
      x1 = x1(1:size(x1,1) ~= r_idx);
      x2 = x2(1:size(x2,1) ~= r_idx);
      % x1, x2, should be one point smaller, cluster should be one point larger

  endwhile

endfunction
