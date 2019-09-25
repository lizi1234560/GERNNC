function [rate, JQ_Acc, trainsam, z] = LVQ_1(FC, Chrom, N)

LMCI = ones(1, 26);
NC = ones(1, 36) + 1;
labels = [LMCI, NC];

n = floor(0.6 * 62);
x = randperm(62);
y = x(1:n);    

z = x(n+1:62);  

test_num = length(z);   
sam_num = 36;        
fc_num = 57;    

trainsam = nan(N, sam_num);
rate = zeros(1,N);    
fc = zeros(N, fc_num);
predictY = zeros(N, test_num);

for i = 1:N

    sample_num = randsample(length(y), sam_num, 'true');
    trainsam(i, :) = y(sample_num);

    trainl = labels(sample_num);

    FC(trainsam(i, :),:);   

    temp = find(Chrom(i, :) == 1);
    fc(i, :) = randsample(length(temp), fc_num, 'true');

    fc_temp = fc(i, :);
    
    traind = FC(trainsam(i, :), fc_temp);  
    trainl = full(ind2vec(trainl));
    
    testd = FC(z ,fc_temp);   
    testl = labels(z);
    
    traind_m = minmax(traind');

    net = newlvq(traind_m, 10, [0.4, 0.6], .1);	 

    net.trainparam.epochs=300;    
    net.trainParam.showCommandLine = 0;
    net.trainParam.showWindow = 0;
    net.trainparam.goal=0.05;
    net=train(net,traind',trainl);

    test_out = sim(net,testd');
    predictY(i, :) = vec2ind(test_out);
    rate(i) = sum(predictY(i, :) == testl) / length(testl);
end

Res_sum = sum(predictY);
Result = sign(Res_sum);
R = sum(Result == testl);
JQ_Acc = R/length(z);

end
