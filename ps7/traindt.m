function dt = traindt(X,Y,maxdepth,splitfn,varargin)
% function dt = traindt(X,Y,maxdepth,splitfn,...)
%
% returns a representation of a decision tree learned on
%        n data points, each with dimension d and a categorical label
%        maxdepth is the maximum depth of the tree
%        splitfn is a function that picks a split
%            it should be callable as splitfn(X,Y,alpha,isleaf,...)
%               where X,Y,alpha are the subset of the data at this node
%               isleaf is true if it must return a leaf
%               the remaining parameters are the trailing parameters to traindt
%            it should return either
%               1) a single class label (indicating a leaf)
%               2) a pair [dim thresh] indicating that the test is
%                   whether x(dim) < thresh
%   X: n x d
%   Y: n x 1
%   maxdepth: 1 x 1
%   splitfn: function / function pointer
%   ...:  remaining args to be passed into splitfn
%
% note: the return value (dt) is a cell array
%       therefore, it should not be placed into a vector, but 
%       must be stored in a cell array if it is to be grouped with
%       other things

dt = traindtw(X,Y,ones(size(Y)),maxdepth,splitfn,varargin{:});
