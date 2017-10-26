function u = sol_Gradient_Descent_Explicit(u0, mask_dst, mask_src, driving_on_src)
    %The comented variables where used to choose manually the value of "tau"
    tau = 0.2;
    
    u = u0;
    b = zeros(size(u0));
    %iter = 1000;
    %vsum_b = zeros(iter,1);
    driving_on_u0=sol_Laplacian(u0, 1);
    b(mask_dst(:)) = driving_on_src(mask_src(:))-driving_on_u0(mask_dst(:));
    i = 1;
    sum_b  = -2;
    while sum_b < -1 %i <= iter
        u(mask_dst(:)) = u0(mask_dst(:)) - tau*b(mask_dst(:));
        u0 = u;
        driving_on_u0=sol_Laplacian(u0, 1);
        b(mask_dst(:)) = driving_on_src(mask_src(:))-driving_on_u0(mask_dst(:));
        %vsum_b(i) = ceil(sum(sum(b(mask_dst(:)))));
        sum_b = ceil(sum(sum(b(mask_dst(:)))));
        i=i+1;
    end
    %i
    %figure;
    %plot(vsum_b);
end
