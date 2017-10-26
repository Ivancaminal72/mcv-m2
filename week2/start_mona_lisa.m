clearvars;
dst = double(imread('../data/custom/mona-lisa.png'));
src = double(imread('../data/custom/man-in-suit.png')); % flipped girl, because of the eyes
size(dst)
size(src)
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_dst=(imread('../data/custom/mask_dst_face.png'));
mask_src=logical(imread('../data/custom/mask_src_face.png'));

mask_dst = logical(generate_mask(157, 197, 78,37,49,39));
mask_src = logical(generate_mask(157, 197, 88,37,54,39));

size(mask_dst)
size(mask_src)


%Choose a method for calculating the Laplacian:
%1-With backward and forward finite differences.
%2-With it's discretization formula.
method = 2;

for nC = 1: nChannels
    
    if method == 1
        drivingGrad_i = sol_DiBwd(src(:,:,nC));
        drivingGrad_j = sol_DjBwd(src(:,:,nC));

        driving_on_src = sol_DiFwd(drivingGrad_i) + sol_DjFwd(drivingGrad_i);
    
    else 
        src_ext = zeros(size(src(:,:,1))+2);
        src_ext(2:end-1, 2:end-1) = src(:,:,nC);
        driving_on_src = zeros(size(src(:,:,1)));
        for i = 1 : size(src,1)
            for j = 1 : size(src,2)
                driving_on_src(i,j)=src_ext(i,j+1)+src_ext(i+1, j)+src_ext(i+1,j+2)+src_ext(i+2, j+1);
                driving_on_src(i,j)=driving_on_src(i,j)-4*src_ext(i+1,j+1);
            end
        end    
    end
    
    driving_on_dst = zeros(size(src(:,:,1)));
    driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
    param.driving = driving_on_dst;
    
    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);
end


subplot(1,3,1)
imshow(dst1/256)
subplot(1,3,2)
imshow(mask_src)
subplot(1,3,3)
imshow(imread('../data/custom/man-in-suit.png'))
