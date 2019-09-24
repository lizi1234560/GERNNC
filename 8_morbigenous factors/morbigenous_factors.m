% 第四部分，找到差异显著的基因和脑区
% 1）保留最优的特征集合（前320维的最优特征）
Important_fc = Important_fc(1:205);
FC_Important = FC_Important(:, 1:205);
% 2）创建一个矩阵，行为基因编号、列为脑区编号
t = 1; 
for i = 1:36
    for j = 1:90
        a(i, j) = t;
        t = t + 1;
    end
end
% 3）XX是基因编号，YY是脑区编号。因此此时就得到相应的结果编号
for i = 1:320
    [XX(i), YY(i)] = find(a == Important_fc(i));
end
% 4）然后是求基因和脑区的频数
% ○1 先求脑区的频数
brain =zeros(1,90);
for i = 1:90
    brain (i) = length(find(XX == i));
end
% rank_b为brain的降序排序，brain_pos_b为其原始排序的下标。
[rank_b,brain_pos_b]=sort(brain,'descend'); 
brain_new=[rank_b; brain_pos_b];   %将排序和下标组合成一个新矩阵
% ○2 再求基因的频数
jiyin = zeros(1, 36);
for i = 1:36
    jiyin(i) = length(find(YY == i));
end
% rank_j为jiyin的降序排序，brain_pos_j为其原始排序的下标。
[rank_j,brain_pos_j]=sort(jiyin,'descend');
jiyin_new=[rank_j; brain_pos_j];  % 将排序和下标组合成一个新矩阵
