function [class_predict] = mypca( A, T)

[n_size, M] = size(A);
class_predict = zeros(1,n_size,'double');
for i = 1:n_size

    z = double(A(n_size,:))'; 
    dist = zeros(10,1);
    for k = 1:10
        Uk = T(:,:,k);
        dist(k) = norm(z - Uk*(Uk'*z));
    end


    [M,I] = min(dist);
    class_predict(1,i) = I-1;
end

end

