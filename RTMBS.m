%% Randomness test methods for binary sequence
% Based on <GB/T 32915-2016>
% Note that only single one group of binary sequence is tested here, since
% it requires 1000 groups of sequence, which is too many to manipulate.

% This program also requires a binary file 'bits.bin' that contains 10^6 
% bits.  This can be applied in another program of mine as reference: 
% 'RandBitGenerator.m'.

% Author: quarter26 (Anda)
clear;clc;

%% Set initial parameters
n = int32(10^6);  % the length of bits;
succCounter = int8(0);
global a;  % significance level
a = 0.01;
disp('Import binary file "bits.bin" in the current directory.');
if exist('bits.bin','file')==0
   error(disp('"bits.bin" does not exist, please create one.'));
else
    fid2 = fopen('bits.bin','rb');
    bits = int8(fread(fid2, [1,n],'int8'));
    fclose(fid2);
end

%% 1. Monobit frequency test
disp('1. Start Monobit frequency test, please wait......');
tic;
%bits1 = int8(randi([0,1],[1,n]));
counter = int16(0);    % counter is the parameter of determining the result, 0 represents fail, 1 represents succeed.

for j = 1:n
    bits1(1,j) = 2 * bits(1,j) - 1;
end

S_n1 = sum(bits1(1,:),2);
V = abs(S_n1) / sqrt(double(n));
P_value = erfc(V / sqrt(2));
if P_value > a
    counter = counter + 1;
end

if counter == 1
    succCounter = succCounter + 1;
    fprintf('This binary sequence passes Monobit frequency test.  It takes time: \n');
else
    disp('This binary sequence does NOT pass Monobit frequency test!  It takes time: \n')
end
toc;
clear bits1;
clear S_n1;

%% 2. Frequency test within a block
disp('2. Start Frequency test within a block, please wait.......');
tic;
counter = int16(0);
m = int32(100);
N = int32(floor(n / m));
pai = double(zeros(1,N));

for i = 1:N
    S_n2 = double(0);
    for j = 1:m
        S_n2 = S_n2 + bits(1,(i - 1) * m + j);
    end
    pai(1,i) = double(S_n2) / double(m);
end

S_n2 = double(0);
for i = 1:N
    S_n2 = S_n2 + (pai(1,i) - 0.5)^2;
end
V = 4 * double(m) * S_n2;
P_value = gammainc(double(N) / 2 , V / 2);
if P_value > a
    counter = counter + 1;
end
toc;
if counter == 1
    succCounter = succCounter + 1;
    fprintf('This binary sequence passes Frequency test within a block.  It takes time: \n');
else
    disp('This binary sequence does NOT pass Frequency test within a block!  It takes time: \n')
end
clear m N pai S_n2;

%% 3. Poker test
disp('3. Start Poker test, please wait......');
tic;
m = int32(4);    % m is the length of group，normally 4 or 8，while if m=8, it would take more time to process；
counter = int16(0);
N = int32(floor(n / m));    % N is the number of groups；
n1 = binaryMatrix(m);
n_i = zeros(1,2^m);
bits1 = reshape(bits, m, N);
bits1 = int32(bits1');
for i = 1:2^m
    for j = 1:N
        if bits1(j,:) == n1(i,:)
            n_i(i) = n_i(i) + 1;
        end
    end
end
s1 = 0;
for i = 1 : 2^m
    s1 = s1 + n_i(i)^2;
end
m = double(m);
N = double(N);
V = 2^m * s1 / N - N;
P_value = gammainc((2^m - 1)/2, V/2);
if P_value > a
    counter = counter + 1;
end
toc;
if counter == 1
    succCounter = succCounter + 1;
    fprintf('This binary sequence passes Poker test.  It takes time: \n');
else
    disp('This binary sequence does NOT pass Poker test!  It takes time: \n')
end
clear bits1 m N n1 n_i s1;

%% 4. Serial test
% The reference standard seems wrong in the number of sequences, I don't
% know how to code :(

%% 5. Runs test
disp('5. Start Runs test, please wait......');
tic;
counter = int16(0);

V_n = 1;
for i = 1:(n-1)
    if bits(i) == bits(i+1)
        V_n = V_n + 1;
    end
end

Freq_1 = 0;
for i = 1 : n
    if bits(i) == 1
        Freq_1 = Freq_1 + 1;
    end
end

n = double(n);
pai = Freq_1 / n;

P_value = erfc( abs(V_n - 2 * n * pai * (1 - pai) ) / (2 * sqrt(2 * n) * pai * (1 - pai )));

if P_value > a
    counter = counter + 1;
end
toc;
if counter == 1
    succCounter = succCounter + 1;
    fprintf('This binary sequence passes Runs test.  It takes time: \n');
else
    disp('This binary sequence does NOT pass Runs test!  It takes time: \n')
end
clear V_n Freq_1 pai;
n = int32(n);
