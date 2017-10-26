clearvars;
dst = double(imread('../data/lena.png'));
src = double(imread('../data/girl.png')); % flipped girl, because of the eyes
[ni,nj, nChannels]=size(dst);

param.hi=1;
param.hj=1;


%masks to exchange: Eyes
mask_src=logical(imread('../data/mask_src_eyes.png'));
mask_dst=logical(imread('../data/mask_dst_eyes.png'));

%Choose a method:
method = 3;
%1 -> Calculate Laplacian with backward and forward finite differences +
%sol_Poison_Equation_Axb.m.
%2 -> Calculate Laplacian with it's discretization formula +
%sol_Poison_Equation_Axb.m.
%3 -> Calculate Laplacian with it's discretization formula +
%sol_Gradient_Descent_Explicit.



tic;
for nC = 1: nChannels
    
    driving_on_dst = zeros(size(src(:,:,1)));
    
    if method == 1
        drivingGrad_i = sol_DiBwd(src(:,:,nC));
        drivingGrad_j = sol_DjBwd(src(:,:,nC));
        driving_on_src = sol_DiFwd(drivingGrad_i) + sol_DjFwd(drivingGrad_i);
        
        
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        param.driving = driving_on_dst;
        
        dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);
        
    elseif method == 2 
        driving_on_src=sol_Laplacian(src, nC);
        
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        param.driving = driving_on_dst;

        dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst(:,:,nC), mask_dst,  param);
        
    elseif method == 3
        driving_on_src=sol_Laplacian(src, nC);
        u0=zeros(size(src(:,:,1)));
        dst_nC = dst(:,:,nC);
        u0(not(mask_dst(:))) = dst_nC(not(mask_dst(:)));
        dst1(:,:,nC) = sol_Gradient_Descent_Explicit(u0, mask_dst, mask_src, driving_on_src);
    end
end

%Mouth
%masks to exchange: Mouth
mask_src=logical(imread('../data/mask_src_mouth.png'));
mask_dst=logical(imread('../data/mask_dst_mouth.png'));

for nC = 1: nChannels
    
    driving_on_dst = zeros(size(src(:,:,1)));  
    
    if method == 1
        drivingGrad_i = sol_DiBwd(src(:,:,nC));
        drivingGrad_j = sol_DjBwd(src(:,:,nC));
        driving_on_src = sol_DiFwd(drivingGrad_i) + sol_DjFwd(drivingGrad_i);
    
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        param.driving = driving_on_dst;
        
        dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
        
    elseif method == 2
        driving_on_src = sol_Laplacian(src,nC);
        
        driving_on_dst(mask_dst(:)) = driving_on_src(mask_src(:));
        param.driving = driving_on_dst;
        
        dst1(:,:,nC) = sol_Poisson_Equation_Axb(dst1(:,:,nC), mask_dst,  param);
    elseif method == 3
        driving_on_src=sol_Laplacian(src, nC);
        u0=zeros(size(src(:,:,1)));
        dst_nC = dst1(:,:,nC);
        u0(not(mask_dst(:))) = dst_nC(not(mask_dst(:)));
        dst1(:,:,nC) = sol_Gradient_Descent_Explicit(u0, mask_dst, mask_src, driving_on_src);
    end
    
    
end
toc;
figure;
imshow(dst1/256)