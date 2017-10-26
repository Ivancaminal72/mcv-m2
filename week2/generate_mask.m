function [mask] = generate_mask(size_y, size_x, x_1, x_width, y_1, y_width)
    mask = zeros(size_y, size_x);
    mask(y_1:y_1+y_width, x_1:x_1+x_width) = 1;
end