%%
%Funcion que obtiene la duracion total de una secuencia de trabajos
function time = getTotalTime(dweller,times)
    [order,schedule] = str2pair(dweller);
    elems = length(schedule);
    jobs = size(times,2);
    machines = size(times,1);
    cum_times = zeros(1,jobs);
    cum_machines = zeros(1,machines);
    for i = 1:elems
        x = max(cum_times(order(i)),cum_machines(schedule(i)));
        w = times(schedule(i),order(i));
        cum_times(order(i)) = x + w;
        cum_machines(schedule(i)) = x + w;
    end
    time = -max(max([cum_times cum_machines]));
end