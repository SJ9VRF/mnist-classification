function viewdigit(digit)
% input: a vector of length 784 
  
   % reshape to 28 by 28 image
   a1 = reshape(double(digit),28,28);
   
   % rescale 
   a1=(a1-min(min(a1))*ones(size(a1)));
   a1=(256/max(max(a1)))*a1;
   digitImage=256*ones(size(a1)) - a1; 
   
   % figure
   figure;
   image(rot90(flipud(digitImage),-1)); 
   colormap(gray(256)); 
   axis square tight off; 
end