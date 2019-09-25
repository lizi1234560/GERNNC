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

        sample_num = randsample(length(y), sam_num, 'true');
        trainsam(i, :) = y(sample_num);
        trainl = labels(sample_num);

        FC_Important(trainl,:);  
 
        fc(i, :) = randsample(k, fc_num, 'true');

        fc_temp = fc(i, :);
        
        traind = FC_Important(trainl, fc_temp);  
        trainl = full(ind2vec(trainl));
        
        testd = FC_Important(z ,fc_temp); 
        testl = labels(z);

        net=newpnn(traind',trainl);

        test_out = sim(net,testd');
        predictY(i, :) = vec2ind(test_out);
        rate(i) = sum(predictY(i, :) == testl) / length(testl);
 
    end
    Res_sum = sum(output);
    Result = sign(Res_sum);
    R = sum(Result == test_lab);
    E(k) = R/length(z);
end

