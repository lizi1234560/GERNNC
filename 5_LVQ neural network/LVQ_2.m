function [rate, JQ_Acc] = LVQ_2(FC, Chrom, N, trainsam, z)
%% BP�����磺ģ�͵�ѵ����Ԥ��
% load('5_��ӱ��ʵ��һ_��ά������.mat')
LMCI = ones(1, 26);
NC = ones(1, 36) + 1;
labels = [LMCI, NC];

%% ��1�������ݼ����з��࣬��Ϊѵ�����Ͳ��Լ�
n = floor(0.6 * 62);
x = randperm(62);
y = x(1:n);       % yΪ�����ȡ��������Ԫ��Ϊѵ����
% y��n��������Ԫ��������Ԫ�ı�ż�¼��y��
z = x(n+1:62);    % zΪ���Լ���������Ԫ�ı�ż�¼��z��

%% ��2�����������������
test_num = length(z);      % ����������Ŀ
fc_num = 57;               % Ҫ��ȡ��������Ŀ

predictY = zeros(N, test_num);

for i = 1:N
    
    % 1�� ��һ������������ȡ����
    
        
    % 2�� �ڶ�������������ȡ������Ŀ
    temp = find(Chrom(i, :) == 1);
    fc(i, :) = randsample(length(temp), fc_num, 'true');
    % ��4005ά���������������ȡfc_numά��������
    % fc�������fc_numά�������ӵı��
    fc_temp = fc(i, :);
    
    traind = FC(trainsam(i, :), fc_temp);    % �õ��ľ��ǳ�ȡ��������������
    trainl = labels(trainsam(i, :));         % trainl��train label ����ѵ�����������
    trainl = full(ind2vec(trainl));
    
    testd = FC(z ,fc_temp);          % z����Ϊ���Լ��е�����
    testl = labels(z);
    
    %% ��������
    net = newlvq(traind_m, 10, [0.4, 0.6], .1);	            % ��������ĿΪ10
    
    %% ѵ������
    net.trainparam.epochs=300;     % ����������300
    net.trainParam.showCommandLine = 0;
    net.trainParam.showWindow = 0;
    net.trainparam.goal=0.05;
    net=train(net,traind',trainl);
    
    %% ����
    test_out = sim(net, testd');
    predictY(i, :) = vec2ind(test_out);
    rate(i) = sum(predictY(i, :) == testl) / length(testl);
end

%% ������������缯Ⱥ��׼ȷ��JQ_Acc
Res_sum = sum(predictY);
Result = sign(Res_sum);
R = sum(Result == testl);
JQ_Acc = R/length(z);

end
