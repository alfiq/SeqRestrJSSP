
%Función que dibuja un diagrama de Gant de la secuencia de trabajos o
%maquinas segun sea el valor de isJobsRows
function [] = drawGant(dweller,times,isJobsRows)
    if(isJobsRows)
        [schedule,order] = str2pair(dweller);
        elems = length(schedule);
        jobs = size(times,2);
        machines = size(times,1);
        rec_height = 5;
        cum_times = zeros(1,machines);
        cum_machines = zeros(1,jobs);
        for i = 1:elems
            x = max(cum_times(order(i)),cum_machines(schedule(i)));
            y = rec_height*machines - rec_height*(order(i));
            yline(y,'--');
            w = times(order(i),schedule(i));
            cum_times(order(i)) = x + w;
            cum_machines(schedule(i)) = x + w;
            h = 5;
            rectangle('Position',[x y w h]);
            text(x+(w)/2-5,y+(h)/2,"J"+string(schedule(i)),'FontSize',7);
            hold on
        end
        yticks([1:5:machines*5]+1);
        yticklabels(flip(string(1:machines)));
        hold off;
    else
        [order,schedule] = str2pair(dweller);
        elems = length(schedule);
        jobs = size(times,2);
        machines = size(times,1);
        rec_height = 5;
        cum_times = zeros(1,jobs);
        cum_machines = zeros(1,machines);
        for i = 1:elems
            x = max(cum_times(order(i)),cum_machines(schedule(i)));
            y = rec_height*jobs - rec_height*(order(i));
            yline(y,'--');
            w = times(schedule(i),order(i));
            cum_times(order(i)) = x + w;
            cum_machines(schedule(i)) = x + w;
            h = 5;
            rectangle('Position',[x y w h]);
            text(x+(w)/2-5,y+(h)/2,"M"+string(schedule(i)),'FontSize',7);
            hold on
        end
        yticks([1:5:jobs*5]+1);
        yticklabels(flip(string(1:jobs)));
        hold off;
    end
    
end
