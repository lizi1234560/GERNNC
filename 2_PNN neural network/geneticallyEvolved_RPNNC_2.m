% �Ŵ�����
clear all;close all;
% load('D:\E_Document\��ӱ��ʵ��\�½��ļ���\�м���\5_��ά������.mat')
load('D:\E_Document\18_����ʵ��\08_��ģ̬��������缯Ⱥ\18��ʵ��\1_ʵ������\5_��ӱ��ʵ��һ_��ά������.mat')


% 1�������ĳ�ʼ��
NIND = 460;                              % ��Ⱥ�л���������Ŀ
MAXGEN = 200;                            % �Ŵ�������������
PRECT = 3240;                            % ������λ��
px = 0.7;                                % Ĭ��ֵ��0.7
pm = 0.3;                                % Ĭ��ֵ��0.01

gen = 0;                                  % �Ŵ������Ĵ���
ObjV = nan(MAXGEN, NIND);                 % ObjV��Ϊ��Ӧ�Ⱥ�����ֵ
JQ_Acc = nan(1, MAXGEN);
Chrom = zeros(NIND, PRECT);

% 2����ʼ��Ⱥ����������
% �����ȡ57��������Ȼ����Ϊ1
for i = 1:NIND
    temp = randsample(PRECT, 57);
    Chrom(i, temp) = 1;
end

% 3�����ϵĽ����Ŵ�����
while gen <= MAXGEN
    %  3.1���Գ�ʼ��Ⱥ���з��࣬
    %       Ȼ�������Ӧֵ����ѡ�����
    if gen == 0
        [ObjV0, JQ_Acc0, trainsam, z] = PNN_1(FC, Chrom, NIND);
        SelCh1 = select('rws', Chrom, ObjV0');
    else
        %  3.2������ǳ�ʼ��Ⱥ������Ҫ��֮ǰ��ѵ�����Ͳ��Լ��Ļ����Ͻ��з���
        [ObjV(gen, :), JQ_Acc(gen)] = PNN_2(FC, SelCh3,...
            NIND, trainsam, z);
        if gen == MAXGEN
            break;
        end
        SelCh1 = select('rws', SelCh3, ObjV(gen, :)');
    end
    % 3.3����Ⱥ���н���ͱ���
    SelCh2 = recombin('xovsp', SelCh1, px);
    SelCh3 = mut(SelCh2, pm);                         % SelCh��Ⱥ������
    gen = gen + 1;           % �Ŵ������Ĵ���
end

TeZheng = SelCh3;
Freq = sum(TeZheng, 1);
[highF, ind] = sort(Freq, 'descend');
Importance_fc = ind(1:400);
figure;
plot(JQ_Acc)
set(gca, 'ylim', [0, 1])
xlabel('�Ŵ���������', 'fontname', '����', 'fontsize', 14)
ylabel('��Ⱥ׼ȷ��', 'fontname', '����', 'fontsize', 14)
