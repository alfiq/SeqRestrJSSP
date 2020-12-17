%%
%%Funcion que calcula la duracion del plan de trabajos
function fitness = getFitness(dwellers,time_mat)
    d_number = size(dwellers,1);
    fitness = [];
    for i  = 1:d_number
        fitness = [fitness getTotalTime(squeeze(dwellers(i,:)),time_mat)];
    end
end