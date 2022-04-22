function [class_predict] = mycentroid(A, T)

[n_size, M] = size(A);
class_predict = zeros(1,n_size,'double');
for i = 1:n_size
    z = double(A(n_size,:)); 
    dist = zeros(10,1);
    for k=1:10
        dist(k) = norm(z - T(k,:));
    end
    [M,I] = min(dist);
    class_predict(1,i) = I-1;
end

end 

