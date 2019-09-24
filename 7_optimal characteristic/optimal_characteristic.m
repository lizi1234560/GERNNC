LMCI = -ones(1, 26);
NC = ones(1, 36);
labels = [LMCI, NC];
 
n = floor(0.6 * 62);
x = randperm(62);
y = x(1:n);
z = x(n+1:62);
N =220;
test_num = length(z);
fc_num = 57;
sam_num = 40;
fc = zeros(N, fc_num);
output = zeros(N, test_num);
 
for k = 70:5:400
    for i = 1:N
        
          % 1） 第一个随机：随机抽取样本
        sample_num = randsample(length(y), sam_num, 'true');
        trainsam(i, :) = y(sample_num);
        trainl = labels(sample_num);
        % 得到的就是训练神经网络的样本单元的编号
        FC_Important(trainl,:);         % 得到的就是训练神经网络所用的样本单元的 FC
        % 2） 第二个随机：随机抽取特征数目
        fc(i, :) = randsample(k, fc_num, 'true');
        % 从4005维功能连接中随机抽取fc_num维功能连接
        % fc保存的是fc_num维功能连接的编号
        fc_temp = fc(i, :);
        
        traind = FC_Important(trainl, fc_temp);    % 得到的就是抽取到的样本和特征
        trainl = full(ind2vec(trainl));
        
        testd = FC_Important(z ,fc_temp);          % z是作为测试集中的特征
        testl = labels(z);
        
        %% 创建网络
        net=newpnn(traind',trainl);
        
        %% 训练网络
        %     net.trainParam.showCommandLine = 0;
        %     net.trainParam.showWindow = 0;
        
        %% 测试
        test_out = sim(net,testd');
        predictY(i, :) = vec2ind(test_out);
        rate(i) = sum(predictY(i, :) == testl) / length(testl);
 
    end
    Res_sum = sum(output);
    Result = sign(Res_sum);
    R = sum(Result == test_lab);
    E(k) = R/length(z);
end
E(E == 0) = [];
X = [70:5:400];
plot(X, E)
xlabel('The number of important features', 'fontname', 'Times New Roman', 'fontsize', 14)
ylabel('The accuracy of the random SVM cluster', 'fontname', 'Times New Roman', 'fontsize', 14)
axis([0 400 0 1]);
set (gca,'position',[0.11,0.12,0.84,0.83] );%axis位置，最下角，宽高
set(gca, 'fontsize', 11)
