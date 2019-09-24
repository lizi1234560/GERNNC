% 遗传进化
clear all;close all;
% load('D:\E_Document\刘颖超实验\新建文件夹\中间结果\5_二维特征表.mat')
load('D:\E_Document\18_论文实验\08_多模态随机神经网络集群\18级实验\1_实验数据\5_刘颖超实验一_二维特征表.mat')


% 1、变量的初始化
NIND = 460;                              % 集群中基分类器数目
MAXGEN = 200;                            % 遗传的最大迭代代数
PRECT = 3240;                            % 二进制位数
px = 0.7;                                % 默认值是0.7
pm = 0.3;                                % 默认值是0.01

gen = 0;                                  % 遗传进化的次数
ObjV = nan(MAXGEN, NIND);                 % ObjV作为适应度函数的值
JQ_Acc = nan(1, MAXGEN);
Chrom = zeros(NIND, PRECT);

% 2、初始种群的特征设置
% 随机抽取57个特征，然后标记为1
for i = 1:NIND
    temp = randsample(PRECT, 57);
    Chrom(i, temp) = 1;
end

% 3、不断的进行遗传进化
while gen <= MAXGEN
    %  3.1）对初始集群进行分类，
    %       然后根据适应值进行选择操作
    if gen == 0
        [ObjV0, JQ_Acc0, trainsam, z] = PNN_1(FC, Chrom, NIND);
        SelCh1 = select('rws', Chrom, ObjV0');
    else
        %  3.2）如果非初始集群，则需要在之前的训练集和测试集的基础上进行分类
        [ObjV(gen, :), JQ_Acc(gen)] = PNN_2(FC, SelCh3,...
            NIND, trainsam, z);
        if gen == MAXGEN
            break;
        end
        SelCh1 = select('rws', SelCh3, ObjV(gen, :)');
    end
    % 3.3）集群进行交叉和变异
    SelCh2 = recombin('xovsp', SelCh1, px);
    SelCh3 = mut(SelCh2, pm);                         % SelCh种群的特征
    gen = gen + 1;           % 遗传进化的代数
end

TeZheng = SelCh3;
Freq = sum(TeZheng, 1);
[highF, ind] = sort(Freq, 'descend');
Importance_fc = ind(1:400);
figure;
plot(JQ_Acc)
set(gca, 'ylim', [0, 1])
xlabel('遗传进化次数', 'fontname', '楷体', 'fontsize', 14)
ylabel('集群准确率', 'fontname', '楷体', 'fontsize', 14)
