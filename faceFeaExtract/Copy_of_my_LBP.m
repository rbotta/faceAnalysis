function [patch_des] = my_LBP(patch_num, w, h, I, I2)

LBP_filter=[2^0 2^1 2^2;2^7 0 2^3;2^6 2^5 2^4];
patch_des = [];
aa = cell(3,3);
a = zeros(w,h,9);
for i = 1 : 3
    for j = 1 : 3
        aa{i,j} = (I - I2(i:w+i-1, j:h+j-1) )>0;
    end
end
for i = 1 : 9
    a(:,:,i) = aa{i}*LBP_filter(i);
end
LBP = sum(a,3);
tt = im2col(LBP, [floor(w/patch_num), floor(h/patch_num)], 'distinct');
for i = 1 : patch_num*patch_num
    gg = histc(tt(:,i),0:255);
    gg = gg / max(gg);
    %temp = sum(gg);
    %gg = gg / temp;
    patch_des = [patch_des gg'];
end

%pyramid
%{
tt1 = im2col(LBP, [floor(w/4), floor(h/4)], 'distinct');
tt2 = im2col(LBP, [floor(w/2), floor(h/2)], 'distinct');
tt3 = LBP(:);
for i = 1 : 4*4
    gg = histc(tt1(:,i),0:255);
    gg = gg / max(gg);
    patch_des = [patch_des gg'];
end
for i = 1 : 2*2
    gg = histc(tt2(:,i),0:255);
    gg = gg / max(gg);
    patch_des = [patch_des gg'];
end
gg = histc(tt3(:),0:255);
gg = gg / max(gg);
patch_des = [patch_des gg'];
%}




