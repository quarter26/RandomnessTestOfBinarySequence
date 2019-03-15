close all; clear; clc;

n = int32(10^6);    % the length of bits;
fid1=fopen('bits.bin','wb');

disp('Initiating to create bit sequence, please wait..................');
tic;    % start timing

r = rand(1,n);
bit = int8((r<0.5));
fprintf('创建%d个比特的序列花费的时间如下：\n', n);
fprintf('Time that creates %d-bit sequence:：\n', n);

toc;    % end timing
fwrite(fid1, bit, 'int8');
fclose(fid1);
