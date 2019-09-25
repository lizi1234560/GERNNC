Freq = sum(TeZheng, 1);
[highF, ind] = sort(Freq, 'descend');
Importance_fc = ind(1:400);
FC_Important = feature(:, Importance_fc);
