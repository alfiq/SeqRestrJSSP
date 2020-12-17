%%
%Funcion para crear una poblacion inicial
function [population] = getInitialPopulation(time_mat,seq_mat,number)
    population = [];    
    for i = 1:number
       population = [population; get_dweller(time_mat,seq_mat)];
    end
end
%%
%Función que genera un poblador valido
function dweller = get_dweller(time_mat,seq_mat)
    [schedule,order] = gen_valid_seq(time_mat,seq_mat);
    dweller = pair2str(order,schedule);
end
%%
%Funcion que crea una secuencia valida de trabajos con sus maquinas en el
%orden correcto
function [schedule,order] = gen_valid_seq(time_mat,seq_mat)
    job_num = size(time_mat,2);
    max_seq_len = size(seq_mat,2);
    job_machine_num = zeros(1,job_num);
    job_counter = ones(1,job_num);
    schedule = [];
    order = [];
    for i  = 1:job_num
        for j = 1:max_seq_len
            if seq_mat(i,j) == 0
                break;
            end
            job_machine_num(i) = job_machine_num(i) + 1;
        end
    end
    
    while any(job_counter<=job_machine_num,'all')
        sel_job = randi(job_num);
        if job_counter(sel_job)<=job_machine_num(sel_job)
           schedule = [schedule seq_mat(sel_job,job_counter(sel_job))];
           order = [order sel_job];
           job_counter(sel_job) = job_counter(sel_job) + 1;
        end
    end
    
end