clc;clear all
%mex cec17_func.c -R2017b -L"/Applications/MATLAB_R2025a.app/bin/maca64" -lmx -lmex -lmatfunc_num=1;
for D = [10]
    Xmin=-100;
    Xmax=100;
    iter_max=10000*D;
    runs=51;
    fhd=str2func('cec17_func');
    AlgorithmName = ['C_RPSO_' num2str(D)]; % ★
    for i=1:30
        func_num=i;
        Function_name = ['F' num2str(func_num)];

        clear Best_score Cg_curve Best_pos Evaluation_Num % ★

        for BL=1:runs
            [Best_score(BL),Eval_Num(BL)]= C_RPSO(fhd,D,iter_max,Xmin,Xmax,func_num);
            Display_Code(Function_name,BL,100,D,Best_score,Eval_Num)
        end
        ExcelData(func_num,:) = [min(Best_score),mean(Best_score),std(Best_score)];

    end

    % 数据记录
    filename = [AlgorithmName 'FixedBenFunc_Result.xlsx'];
    writematrix(ExcelData, filename, 'Sheet', 1, 'Range', 'A1:C54');
end




