function [rate, JQ_Acc] = LVQ_2(FC, Chrom, N, trainsam, z)

LMCI = ones(1, 26);
NC = ones(1, 36) + 1;
labels = [LMCI, NC];

n = floor(0.6 * 62);
x = randperm(62);
y = x(1:n);     

z = x(n+1:62);  

test_num = length(z); 
fc_num = 57;      

predictY = zeros(N, test_num);

for i = 1:N

    temp = find(Chrom(i, :) == 1);
    fc(i, :) = randsample(length(temp), fc_num, 'true');

    fc_temp = fc(i, :);
    
    traind = FC(trainsam(i, :), fc_temp);   
    trainl = labels(trainsam(i, :));    
    trainl = full(ind2vec(trainl));
    
    testd = FC(z ,fc_temp);   
    testl = labels(z);

    net = newlvq(traind_m, 10, [0.4, 0.6], .1);	 

    net.trainparam.epochs=300;  
    net.trainParam.showCommandLine = 0;
    net.trainParam.showWindow = 0;
    net.trainparam.goal=0.05;
    net=train(net,traind',trainl);

    test_out = sim(net, testd');
    predictY(i, :) = vec2ind(test_out);
    rate(i) = sum(predictY(i, :) == testl) / length(testl);
end

Res_sum = sum(predictY);
Result = sign(Res_sum);
R = sum(Result == testl);
JQ_Acc = R/length(z);

end
