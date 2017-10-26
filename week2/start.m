clearvars;
dst = double(imread('../data/lena.png'));
src = double(imread('../data/girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_src=logical(imread('../data/mask_src_eyes.png'));
mask_dst=logical(imread('../data/mask_dst_eyes.png'));

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

%Mouth
%masks to exchange: Mouth
mask_src=logical(imread('../data/mask_src_mouth.png'));
mask_dst=logical(imread('../data/mask_dst_mouth.png'));

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
    
    dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
end

imshow(dst1/256)