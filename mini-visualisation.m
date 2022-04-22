m = 6;  % display the selected train/test digits in an m x m array
for i = 1:m*m
   digit = train1(i,:);
   %digit = test8(i,:);
   digitImage = reshape(digit,28,28);
   subplot(m,m,i);
   image(rot90(flipud(digitImage),-1));
   colormap(gray(256));
   axis square tight off;
end