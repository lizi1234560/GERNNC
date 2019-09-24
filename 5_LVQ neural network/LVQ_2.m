function [rate, JQ_Acc] = LVQ_2(FC, Chrom, N, trainsam, z)
%% BP神经网络：模型的训练和预测
% load('5_刘颖超实验一_二维特征表.mat')
LMCI = ones(1, 26);
NC = ones(1, 36) + 1;
labels = [LMCI, NC];

%% （1）对数据集进行分类，分为训练集和测试集
n = floor(0.6 * 62);
x = randperm(62);
y = x(1:n);       % y为随机抽取的样本单元作为训练集
% y有n个样本单元，样本单元的编号记录在y中
z = x(n+1:62);    % z为测试集，样本单元的编号记录在z中

%% （2）进行两个随机过程
test_num = length(z);      % 测试样本数目
fc_num = 57;               % 要提取的特征数目

predictY = zeros(N, test_num);

for i = 1:N
    
    % 1） 第一个随机：随机抽取样本
    
        
    % 2） 第二个随机：随机抽取特征数目
    temp = find(Chrom(i, :) == 1);
    fc(i, :) = randsample(length(temp), fc_num, 'true');
    % 从4005维功能连接中随机抽取fc_num维功能连接
    % fc保存的是fc_num维功能连接的编号
    fc_temp = fc(i, :);
    
    traind = FC(trainsam(i, :), fc_temp);    % 得到的就是抽取到的样本和特征
    trainl = labels(trainsam(i, :));         % trainl：train label 就是训练样本的类别
    trainl = full(ind2vec(trainl));
    
    testd = FC(z ,fc_temp);          % z是作为测试集中的特征
    testl = labels(z);
    
    %% 创建网络
    net = newlvq(traind_m, 10, [0.4, 0.6], .1);	            % 隐含层数目为10
    
    %% 训练网络
    net.trainparam.epochs=300;     % 最大迭代次数300
    net.trainParam.showCommandLine = 0;
    net.trainParam.showWindow = 0;
    net.trainparam.goal=0.05;
    net=train(net,traind',trainl);
    
    %% 测试
    test_out = sim(net, testd');
    predictY(i, :) = vec2ind(test_out);
    rate(i) = sum(predictY(i, :) == testl) / length(testl);
end

%% 计算随机神经网络集群的准确率JQ_Acc
Res_sum = sum(predictY);
Result = sign(Res_sum);
R = sum(Result == testl);
JQ_Acc = R/length(z);

end
