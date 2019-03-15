% MALTAB Script
% Generate binary matrix by n
% Author: quarter26 (Anda)
% This program creates a binary matrix.
% For example, if n = 3, the matrix is like:
% [ 0 0 0,
%   0 0 1,
%   0 1 0,
%   0 1 1,
%   1 0 0,
%   1 0 1,
%   1 1 0,
%   1 1 1 ]

function b = binaryMatrix(n)

a = zeros(2^n, n);
b = zeros(2^n,1);
for i = 0 : (2^n-1)
    c = dec2bin(i,n);
    for j = 1 : n
        b((i+1), j)= str2double(c(j));
    end
end
