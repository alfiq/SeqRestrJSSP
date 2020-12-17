%%
%Función que convierte un par de vectores de trabajos y maquinas en un
%vector de etiquetas
function str_dwl = pair2str(order,schedule)
    str_dwl = [];
    for i = 1:length(schedule)
        pop_str = string(order(i))+"-"+string(schedule(i));
        str_dwl = [str_dwl pop_str];
    end
end