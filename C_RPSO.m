function [Best_score, Eval_Num] = C_RPSO(fhd, D, FESmax, Xmin, Xmax, func_num)
%% ===== Parameters  =====
N = 100;                          % population size 
FES = 0;           % iterations derived from FEs
Eval_Num = 0;
elit_rate = 0.15;
%% ===== Initialization =====
X = Xmin + (Xmax - Xmin) .* rand(N, D);
P = X;

fitness = zeros(N,1);
for i = 1:N
    fitness(i) = feval(fhd, X(i,:)', func_num);
end
FES = FES + N;

Pfit = fitness;
[Best_score, idx] = min(Pfit);
gbest = P(idx,:);
t = 1;
%% ===== Main Loop =====
while FES<FESmax
    [~,sort_in] = sort(fitness);
    e = X(sort_in(1:ceil(elit_rate*N)),:);

    for i = 1:N
        r_p = 0.9*(1-FES/FESmax);
        r_e = 1-r_p;

        % ------ elit box -----
        for j = 1:D
            pwin(j) = e(randi(size(e,1)), j);
        end

        motion = rand(1,D).*(P(randperm(N,1),:)-X(i,:));
        
        % -------- core --------
        X(i,:) = r_p * pwin + r_e * gbest + motion;

        % Boundary control
        X(i,:) = max(min(X(i,:), Xmax), Xmin);
        % Evaluation
        fit = feval(fhd, X(i,:)', func_num);
        FES = FES + 1;
        
        % Update personal best
        if fit < Pfit(i)
            P(i,:)  = X(i,:);
            Pfit(i) = fit;
        end

        % Update global best
        if fit < Best_score
            Best_score = fit;
            gbest = X(i,:);
        end
        fitness(i) = fit; 
        
    end

    t = t+1;
end

Best_score = Best_score - func_num*100;
end