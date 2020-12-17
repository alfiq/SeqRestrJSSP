%%
%%Se limpian las variables i las figuras
clear all;
close all;
clc;
%%
%%Se inicializan las matrices de los trabajos y 
time_mat = xlsread('TiempoTrabajoMaquina.xlsx');
seq_mat = xlsread('Secuencias.xlsx');
seq_mat = seq_mat(2:end,:);


cross_types=["pmx","pbx"];
selection_types=["torneo","ruleta"];
mutation_types = ["scramble","heuristico"]
selection_vec = [];
for i = 1:size(cross_types,2)
    for j = 1:size(selection_types,2)
        for k = 1:size(mutation_types,2)
            if size(selection_vec,1) == 0
                selection_vec = [i j k];
            else
                selection_vec = [selection_vec;i j k];
            end
        end
    end
end

for selected_set = 1:(size(selection_vec,1))
    tic
    
    %%
    %Se inicializan las variables

    pop_size = 100;
    max_it = 100;
    min_err = 1e-5;
    iter = 0;
    mean_err = inf;
    curr_mean = 0;
    last_mean = 0;
    err_arr = [];
    mean_arr = [];
    mut_rate = 6;
    %%
    %%Se inicializa la población
    dwellers = getInitialPopulation(time_mat,seq_mat,pop_size);
    %Se obtiene el nivel de aptitud para cada miembro
    fitness = getFitness(dwellers,time_mat);
    f=figure;
    subplot(3,2,1);
    C_t = cross_types(selection_vec(selected_set,1));
    S_t = selection_types(selection_vec(selected_set,2));
    M_t = mutation_types(selection_vec(selected_set,3));
    boxplot(fitness);
    title("Distribución de aptitudes inicial");
    annotation('textbox',[0.35,0.02,1,.05],'string',"Cruza tipo "+ C_t + " con selección tipo " + S_t + " y mutación tipo " +M_t,'LineStyle','none')
    %%
    %%Comienza el algoritmo
    S_t
    C_t
    M_t
    selection_m = S_t;
    cross_m = C_t;
    mut_m = M_t;
    while(iter<max_it)&(min_err<abs(mean_err))

        %Se mezclan hijos y padres, se re ordenan y se elimina la mitad.
        children = getChildren(dwellers,fitness,selection_m,cross_m,seq_mat);
        dwellers = [dwellers;children];
        [dwellers,fitness]=sortByFitness(dwellers,time_mat,pop_size);
        %Se mutan a los miembros
        dwellers = mutate(dwellers, time_mat, seq_mat, mut_m, mut_rate);
        [dwellers,fitness]= sortByFitness(dwellers,time_mat,pop_size);
        %Se calcula el error
        curr_mean = (mean(fitness));
        mean_arr = [mean_arr curr_mean];
        mean_err = abs((curr_mean - last_mean)/curr_mean);
        err_arr = [err_arr mean_err];
        last_mean = curr_mean;
        iter = iter+1;
    end
    last_mean
    t_val = toc
    subplot(3,2,2);
    boxplot(fitness);
    title("Distribución de aptitudes final");
    subplot(3,2,3);
    plot(err_arr);
    title("Error relativo");
    subplot(3,2,4);
    plot(mean_arr);
    title("Valor medio de los pobladores")
    subplot(3,2,5);
    title("Ejecucion por trabajos")
    drawGant(dwellers(1,:),time_mat,false);
    subplot(3,2,6);
    title("Ejecucion por maquinas")
    drawGant(dwellers(1,:),time_mat,true);
    annotation('textbox',[0.2,0.02,0.2,.05],'string',"Tiempo: "+string(t_val)+" Segundos",'LineStyle','none');
    annotation('textbox',[0.7,0.02,0.2,.05],'string',"Valor medio: "+string(last_mean)+" y Mejor valor: "+string(fitness(1)),'LineStyle','none');
    set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
    saveas(f,C_t + "_" + S_t + " " +M_t+'.bmp');
    %%
end
function [dwellers,fitness] = sortByFitness(d,time_mat,pop_size)
    fitness = getFitness(d,time_mat);
    [fitness,order] =sort(fitness,'descend');
    dwellers = d(order,:);
    dwellers = dwellers(1:pop_size,:);
    fitness = fitness(1:pop_size);
end