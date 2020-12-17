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
%%
%Se inicializan las variables
tic
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
%%
%Se obtiene el nivel de aptitud para cada miembro
fitness = getFitness(dwellers,time_mat);
%%
%Se crea la figura inicial y se grafica la poblacion inicial
figure;
subplot(3,2,1);
boxplot(fitness);
title("Distribución de aptitudes inicial");
%%  
%%Comienza el algoritmo
selection_m = "ruleta";
cross_m = "pmx";
mut_m = 'scramble';
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
    mean_err = abs((curr_mean - last_mean)/curr_mean)
    err_arr = [err_arr mean_err];
    last_mean = curr_mean;
    iter = iter+1
end
toc
%%
%%Se grafica la población final
subplot(3,2,2);
boxplot(fitness);
title("Distribución de aptitudes final");
%%
%%Se grafica el error a traves de la ejecución del programa
subplot(3,2,3);
plot(err_arr);
title("Error relativo");
%%
%%Se grafica el el valor medio a traves d ela ejcución del programa
subplot(3,2,4);
plot(mean_arr);
title("Valor medio de los pobladores")
%%
%%Se dibujan los diagramas de Gantt
subplot(3,2,5);
title("Ejecucion por trabajos")
drawGant(dwellers(1,:),time_mat,false);
subplot(3,2,6);
title("Ejecucion por maquinas")
drawGant(dwellers(1,:),time_mat,true);
set(gcf, 'Units', 'Normalized', 'OuterPosition', [0, 0.04, 1, 0.96]);
%%
for i = 1:10
    figure;
    drawGant(dwellers(1,:),time_mat,true);
    title(string(fitness(i)));
end
%%Funcion que ordena los miembros por aptitud de forma decendente
function [dwellers,fitness] = sortByFitness(d,time_mat,pop_size)
    fitness = getFitness(d,time_mat);
    [fitness,order] =sort(fitness,'descend');
    dwellers = d(order,:);
    dwellers = dwellers(1:pop_size,:);
    fitness = fitness(1:pop_size);
end