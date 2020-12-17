%%
%Función que muta a los mimbros de una poblacion dado un porcentaje de
%individuos a mutar.
function mutated_dwellers = mutate(dwellers, time_mat, seq_mat, method,mut_per)
    mutated_dwellers = dwellers;
    cut_points = [1 4];
    d_number = size(dwellers,1);
    g_number = size(dwellers,2);
    cut_points = randi(g_number-max(cut_points))+cut_points;
    for i = (d_number-d_number*mut_per/100):d_number
        if method == "heuristico"
            mutated_dweller = heuristic(dwellers(i,:), cut_points, time_mat, seq_mat);
        elseif method == "scramble"
            mutated_dweller = scramble2(dwellers(i,:), cut_points, seq_mat);
        end
        mutated_dwellers(i,:) = mutated_dweller;
    end
end

%%
%Función que ejecuta el algoritmo de mutación heuristica
function mutated_dweller = heuristic(dweller, cut_points, time_mat, seq_mat)
    scramble_segment = dweller(cut_points(1):cut_points(2));
    fixed_segment = [dweller(1:cut_points(1)-1) dweller(cut_points(2)+1:end)];
    scrambled_segment = perms(scramble_segment);
    for i=1:length(scrambled_segment)
        if all(scramble_segment == scrambled_segment(i))
            scrambled_segment(i) = [];
        end
    end
    
    %Se vuelve a calcular el fitness
    fitness = -inf;
    best_dweller = dweller;
    for i = 1:length(scrambled_segment)
        aux_dweller = dweller;
        aux_dweller(cut_points(1):cut_points(2)) = scrambled_segment(i,:);
        aux_dweller = checkAndRepair(aux_dweller,seq_mat);
        curr_fit = getTotalTime(aux_dweller,time_mat);
        if fitness<curr_fit
            best_dweller = aux_dweller;
            fitness = curr_fit;
        end
    end
    mutated_dweller = best_dweller;
end
%%
%Función que ejecuta el algoritmo de mutación scramble
function mutated_dweller = scramble2(dweller, cut_points, seq_mat)
    scramble_segment = dweller(cut_points(1):cut_points(2));
    fixed_segment = [dweller(1:cut_points(1)-1) dweller(cut_points(2)+1:end)];
    scrambled_segment = scramble_segment;
    while any(scramble_segment == scrambled_segment)
        scrambled_segment = scramble_segment(randperm...
            (length(scramble_segment)));
    end
    rand_pos = cut_points(1);
    while rand_pos == cut_points(1)
        rand_pos = round(random('uniform',1,length(fixed_segment)));
    end
    mutated_dweller = [fixed_segment scrambled_segment];
    mutated_dweller = checkAndRepair(mutated_dweller,seq_mat);
end