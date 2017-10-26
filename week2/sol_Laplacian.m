function out = sol_Laplacian(img, nC)
    img_ext = zeros(size(img(:,:,1))+2);
    img_ext(2:end-1, 2:end-1) = img(:,:,nC);
    out = zeros(size(img(:,:,1)));
    for i = 1 : size(img,1)
        for j = 1 : size(img,2)
            out(i,j)=img_ext(i,j+1)+img_ext(i+1, j)+img_ext(i+1,j+2)+img_ext(i+2, j+1)-4*img_ext(i+1,j+1);              
        end
    end 
end