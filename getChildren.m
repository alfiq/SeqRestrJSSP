%%
%%Funcion que cruza a los miembros de una poblacion apra crear una nueva
function [children] = getChildren(dwellers,fitness,selection_m,cross_m,seq_mat)
    child_num = size(dwellers,1);
    gen_num = size(dwellers,2);
    children = strings(size(dwellers));
    
    if lower(cross_m) == "pbx"
        random_vector = randperm(gen_num,3);
    elseif lower(cross_m) == "pmx"
        segment_number = 2;
        split_points = randperm(gen_num,segment_number);
    end
    
    for i = 1:child_num/2 
        if selection_m == "ruleta"
            d_1 = Roulette(dwellers, fitness);
            d_2 = Roulette(dwellers, fitness);
        elseif selection_m == "torneo"
            k = ceil(child_num*.1);
            d_1 = Turnament(dwellers, fitness, k);
            d_2 = Turnament(dwellers, fitness, k);
        end

        if lower(cross_m) == "pbx"
            [c_1,c_2] = PBx(d_1,d_2,random_vector,seq_mat);
        elseif lower(cross_m) == "pmx"
            [c_1,c_2] = PMx(d_1,d_2,split_points,segment_number,seq_mat);
        end
        children(i*2-1,:) = c_1;
        children(i*2,:) = c_2; 

    end
end
%%
%Función de cruza que emplea el algoritmo PMX
function [child1,child2] = PMx(parent1,parent2,split_points,segment_number,seq_mat)


child1 = [];
child2 = [];

sp_extended = [1 split_points length(parent1)];
inter_vec = [];
for i = 1:(length(sp_extended)-1)
    aux_inter = [sp_extended(i) sp_extended(i+1)-1];
    inter_vec = [inter_vec; aux_inter] ;
end
inter_vec(end,end) = sp_extended(end);
inter_vec;

child1 = parent1;

child2 = parent2;

p1 = inter_vec(segment_number,1);
p2 = inter_vec(segment_number,2);

segment1 = parent1(p1:p2);
segment2 = parent2(p1:p2);

for i = p1:p2
    child1(i) = segment2(i-p1+1);
    child2(i) = segment1(i-p1+1);
end
aux_child1 = child1;
aux_child2 = child2;

for i = 1:length(parent1)
    if(i<p1 | i>p2)
        %%Para child 1
        while ismember(child1(i),segment2)
            child1(i) = aux_child2(find(segment2==child1(i))+p1-1);
        end
        %%Para child 2
        while ismember(child2(i),segment1)
            child2(i) = aux_child1(find(segment1==child2(i))+p1-1);
        end
    end
end

child1 = checkAndRepair(child1,seq_mat);
child2 = checkAndRepair(child2,seq_mat);
end
%%
%Función de cruza que emplea el algoritmo PBX
function [child1,child2] = PBx(parent1,parent2,random_vector,seq_mat)
    child1 = "";
    child2 = "";
    child1(random_vector) = parent1(random_vector);
    child2(random_vector) = parent2(random_vector);
    for i = 1:length(parent1)
        if ~ismember(i,random_vector)
            %%Para child 1
            for j = 1:length(parent2)
                if ~ismember(parent2(j),child1)
                    child1(i) = parent2(j);
                    break;
                end
            end
            %Para child 2
            for j = 1:length(parent1)
                if ~ismember(parent1(j),child2)
                    child2(i) = parent1(j);
                    break;
                end
            end
        end
    end
    child1 = checkAndRepair(child1,seq_mat);
    child2 = checkAndRepair(child2,seq_mat);
end
%%
%Funcion de selección que emplea el algoritmo de ruleta
function winner = Roulette(dwellers, fitness)
fitness = sort(fitness,'descend');
cuml_fit = flipud(abs(cumsum(fitness)));
roulette_sel = random('uniform',min(cuml_fit),max(cuml_fit));
aux_i = 1;
for i = 1:length(cuml_fit)
    if cuml_fit(i)>roulette_sel
        aux_i = i;
        break
    end
end
winner = dwellers(aux_i,:,:);

end
%%
%Funció de selección que emplea el algoritmo torneo
function winner = Turnament(dwellers, fitness, k)

selections  = randperm(size(dwellers,1),floor(k));
new_dwellers = dwellers(selections,:,:);
new_fitness = fitness(selections);

[value, pos] = max((new_fitness));

winner_dweller = new_dwellers(pos,:,:);
winner = winner_dweller;

end