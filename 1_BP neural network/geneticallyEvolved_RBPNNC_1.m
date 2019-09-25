NIND = 300;          
MAXGEN = 200;       
PRECT = 3240;                  
px = 0.7;                    
pm = 0.3;                               

gen = 0;                              
ObjV = nan(MAXGEN, NIND);              
JQ_Acc = nan(1, MAXGEN);
Chrom = zeros(NIND, PRECT);

for i = 1:NIND
    temp = randsample(PRECT, 57);
    Chrom(i, temp) = 1;
end

while gen <= MAXGEN

    if gen == 0
        [ObjV0, JQ_Acc0, trainsam, z] = BP_1(FC, Chrom, NIND);
        SelCh1 = select('rws', Chrom, ObjV0');
    else
       
        [ObjV(gen, :), JQ_Acc(gen)] = BP_2(FC, SelCh3,...
            NIND, trainsam, z);
        if gen == MAXGEN
            break;
        end
        SelCh1 = select('rws', SelCh3, ObjV(gen, :)');
    end
  
    SelCh2 = recombin('xovsp', SelCh1, px);
    SelCh3 = mut(SelCh2, pm);                    
    gen = gen + 1;        
end

