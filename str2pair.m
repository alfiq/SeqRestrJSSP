%%
%Función que convierte vector de etiquetas en un par de vectores de 
%trabajos y maquinas
function [order,schedule] = str2pair(str_dwl)
    order = [];
    schedule = [];
    for i = 1:length(str_dwl)
        pop_arr = split(str_dwl(i),"-");
        order = [order str2num(pop_arr(1))];
        schedule = [schedule str2num(pop_arr(2))];
    end
end