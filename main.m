%clear;
load mnistdata;

whos('-file','mnistdata.mat')

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

%Centroid Algorithm
for i = 1:10
    s = strcat('test',num2str(i-1));
    disp(s)
    A = double(eval(s));
    [n_size, M] = size(A);
    true_real = (i-1)*ones(1,n_size,'double');
    class_pred_cent = mycentroid( A, T);
    accuracy_cent = sum(true_real == class_pred_cent,'all')/numel(true_real);
    fprintf('Centroid Algorithm Success Rate of %d : %d \n', i-1, accuracy_cent);

end

disp('\n')


%PCA Algorithm
% the number $m$ of basis vectors

basis_lengths = [1, 2, 3, 4, 5];

for j = 1:4
    basis_length = basis_lengths(j);
    Us = zeros(28*28, basis_length, 10);
    for k = 1:10
            %
        % go through each digit 0 to 9
        %
        s = strcat('train',num2str(k-1));
        %disp(s)
        B = double(eval(s));
        %
        % get first 5 singular vector
        %
        [U,~,~] = svds(B', basis_length);
        Us(:,:,k) = U;   % store the basis vectors of digit ``k-1''.
    end
    
    for i = 1:10
        s = strcat('test',num2str(i-1));
        disp(s)
        A = double(eval(s));
        [n_size, M] = size(A);
        true_real = (i-1)*ones(1,n_size,'double');
        class_pred_pca = mypca( A, Us);
        accuracy_pca = sum(true_real == class_pred_pca,'all')/numel(true_real);
        fprintf('PCA %d Success Rate of %d : %d \n', basis_length, i-1, accuracy_pca);
    
    end
    disp('\n')
end



