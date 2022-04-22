%% ECS 231 Project 1 Assignment
%  Due 11:59 pm Thursday, April 21, 2022
%  
%  Required datafile: mnistdata.mat 
%  Required file: viewdigit.m
% 
%% Getting started
%
% Upload the MNIST databset of handwritten digits --
% by Yann LeCun (NYU), Corinna Cortes (Google), and
% Chris J. C. Burges (Microsoft Research)  

clear;
load mnistdata;  

%%
% The data is separated into two categories: train and test.
% Each category contains 10 sets of digits from 0-9.  
% Each row vector of length 784 is a 28-by-28 image.
%

whos('-file','mnistdata.mat')

%%
% Here is a way to visualize a selected train/test digit   
%

figure(1) 
m = 6;  % display the selected train/test digits in an m x m array
for i = 1:m*m 

   digit = train8(i,:);
   %digit = test8(i,:);

   digitImage = reshape(digit,28,28);

   subplot(m,m,i); 
   image(rot90(flipud(digitImage),-1)); 
   colormap(gray(256)); 
   axis square tight off; 

end 

%% 
% The figure above shows different instances of digit 8 in the 
% data matrix 'train8'.
%

%%
% Now let us compute the averages (``centroid'') of train digits
%

T(1,:) = mean(train0); 
T(2,:) = mean(train1); 
T(3,:) = mean(train2); 
T(4,:) = mean(train3); 
T(5,:) = mean(train4); 
T(6,:) = mean(train5); 
T(7,:) = mean(train6); 
T(8,:) = mean(train7); 
T(9,:) = mean(train8); 
T(10,:) = mean(train9); 

%% 
% Here is a way to visualize the averages of train digits
%

for i = 1:10 
    digitImage_mean(:,:,i) = reshape(T(i,:),28,28);
end 

figure(2) 
for i = 1:10 
    subplot(2,5,i) 
    image(rot90(flipud(digitImage_mean(:,:,i)),-1)); 
    colormap(gray(256)); 
    axis square tight off; 
end

%%
% The above figure shows the averages of 0, 1, ..., 9 digits.
%

%% Objectives 
%
% In this project, we investigate two algorithms to classify digits: 
% the centroid algorithm and the PCA algorithm.
%

%% Part 1: The Centroid Algorithm
%
% The following code takes a digit $z$ from the test set and computes 
% the 2-norm distances between $z$ and the 10 average train digits 
% computed above.  

z = double(test7(55,:)); % the 55-th test digit `7' 
dist = zeros(10,1); 
for k=1:10
    dist(k) = norm(z - T(k,:));
end
dist

%%
% Since the 2-norm distance between $z$ and the average train
% digit 7 is the smallest, the centroid classification algorithm will 
% label $z$ as digit '7',  which is indeed the correct answer. 
% (Note that average train digit 7 is actually T(8,:) because MATLAB
% indexing starts at 1.) 
%
%% Task 1: Classify a selected test matrix of digits by the centroid algorithm  
%
% Write a function, called ``mycentroid.m'' with input
% 
% * an n-by-784 test matrix A of digits, i.e., A is one of ``test0, 
%   test1, ..., test9''
% * a 10-by-784 matrix T containing the average (mean) train digits 
% 
% and ouput:
%
% * an n-by-1 vector, where $i$-th entry contains a label (0-9) 
%   for the test digit in A(i,:). 
%
%% Task 2: Report the success rate of the centroid algorithm
%
%  Use your function ``mycentroid.m'' to classify all test matrices 
%  of digits, and report the success rate (correct/total) for each digit 
%  in a table of the following form: 
%   ----------------------------------------------
%   digit        | 0     | 1     | ..... | 9  
%   ----------------------------------------------
%   success rate | xx.x% | yy.y% | ..... | zz.z% 
%   ----------------------------------------------

%% Part 2: The PCA Algorithm
%
% PCA uses the singular value decomposition (SVD) to capture features 
% of train digits, and then compares the test digits with the features 
% for classification. 
%
% For example, to find the first $m = 5$ singular vectors (also called feature 
% vectors) of the train digit ``3'' in ``train3'', we compute the SVD: 

[U3,~,~] = svds(double(train3'), 5);    % note, take ``transpose'' 
size(U3)

%%
% The five singular vectors in U3 form the basis of the ``space'' 
% of the digit '3', and are called the dominant/principal features of
% the digit '3'.  The first two of the five basis vectors shown below

viewdigit(U3(:,1)) 

viewdigit(U3(:,2)) 

%% 
% Following the above description, we can compute basis vectors for 
% principal feature of all digits 0 to 9 as follows: 

basis_length = 5;   % the number $m$ of basis vectors 
Us = zeros(28*28, basis_length, 10);
for k = 1:10
    %
    % go through each digit 0 to 9
    % 
    s = strcat('train',num2str(k-1));
    A = double(eval(s));
    %  
    % get first 5 singular vector
    % 
    [U,~,~] = svds(A', basis_length);
    Us(:,:,k) = U;   % store the basis vectors of digit ``k-1''. 
end

%%
% To see how well a test digit $z$ can be represented in a basis $U^{(k)}_m$
% for some $k$, we solve the least square problem:
%
% $$\min_x\|z-U^{(k)}_m x\|_2.$$
%
% It is easy to see that the solution to the least squares problem is given by
% 
% $$\min_x || z - U^{(k)}_m x||_2 = || z - U^{(k)}_m (U^{(k)}_m)^Tz ||_2.$$
% 
% Consequently, we classify the test digit $z$ as the digit $``k-1''$ 
% if the corresponding $U^{(k)}_m$ obtaining the smallest residual norm. 
% 
% For example
%

z = double(test4(14,:))';  %  select a test digit
dist = zeros(10,1); 
for k = 1:10
    Uk = Us(:,:,k); 
    dist(k) = norm(z - Uk*(Uk'*z));
end
dist

%%
% Since the smallest residual norm is obtained by the basis of digit 4, 
% we then label of the unknown digit $z$ as the digit '4' (which is 
% the correct answer!) 

%% Task 3: Write a function ``mypca.m'' with input: 
% 
% * an n-by-784 test matrix A of digits, i.e., A is one of ``test0, 
%   test1, ..., test9''
% * a 784-by-m-by-10 matrix T containing the first m singular vectors for
%   each of train digits 
% 
% and ouput:
%
% * n-by-1 vector containing the labels (0-9) for digits in A. 
%

%% Task 4: Report the success rate of the PCA algorithm
%
%  run your function ``mypca.m'' on all test digits, and report the 
%  success rate of the PCA algorithm for each digits with the size of basis
%  vectors ``m = basis_length = 1, 5, 10, 20.'' in a table of the following form
%   ---------------------------------------------------
%   digit               | 0     | 1     | ..... | 9  
%   ---------------------------------------------------
%   success rate m = 1  | xx.x% | yy.y% | ..... | zz.z% 
%   success rate m = 5  | xx.x% | yy.y% | ..... | zz.z% 
%   success rate m = 10 | xx.x% | yy.y% | ..... | zz.z% 
%   success rate m = 20 | xx.x% | yy.y% | ..... | zz.z% 
%   ---------------------------------------------------
% 

%% Task 5: Project report
%
%  The report should consist of the following items: 
%
%  * Title
%  * Author (student ID)
%  * Introduction (motivation, objective,...)
%  * Algorithms
%  * Matlab scripts (for tasks 1, 2, 3 and 4)  
%  * Tables for classification success rates 
%  * Summary statements (what you have learned, what are remaining issues) 
%  * Acknowledgement (collaborators and helpers if any)
%  * References if any
%
%  The report is no less than 3 pages but not more than 6 pages.
%
