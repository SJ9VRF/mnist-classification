figure(1)
m = 6;  % display the selected train/test digits in an m x m array
for i = 1:m*m
   digit = train9(i,:);
   %digit = test8(i,:);
   digitImage = reshape(digit,28,28);
   subplot(m,m,i);
   image(rot90(flipud(digitImage),-1));
   colormap(gray(256));
   axis square tight off;
end

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

%visualize the averages of train digits

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