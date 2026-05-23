% clc;clear all
% %mex cec17_func.c -R2017b -L"/Applications/MATLAB_R2025a.app/bin/maca64" -lmx -lmex -lmatfunc_num=1;
% for D = [ 10]
%     Xmin=-100;
%     Xmax=100;
%     iter_max=10000*D;
%     runs=51;
%     fhd=str2func('cec17_func');
%     AlgorithmName = ['SQPCPPIPSO_' num2str(D)]; % ★
%     for i=1:30
%         func_num=i;
%         Function_name = ['F' num2str(func_num)];
% 
%         clear Best_score Cg_curve Best_pos Evaluation_Num % ★
% 
%         for BL=1:runs
%             [Best_score(BL),Eval_Num(BL)]= RPSO(fhd,D,iter_max,Xmin,Xmax,func_num);
%             Display_Code(Function_name,BL,100,D,Best_score,Eval_Num)
%         end
%         ExcelData(func_num,:) = [min(Best_score),mean(Best_score),std(Best_score)];
% 
%     end
% 
%     % 数据记录
%     filename = [AlgorithmName 'FixedBenFunc_Result.xlsx'];
%     writematrix(ExcelData, filename, 'Sheet', 1, 'Range', 'A1:C54');
% end




% ========= 更快 ===========
clc; clear;
warning off;

% ========== 并行池 ==========
if isempty(gcp('nocreate'))
    parpool('local');   % 默认物理核数
end

% ========== 基本参数 ==========
Dims = [50];
runs = 51;
func_num_set = 1:30;
Xmin = -100;
Xmax = 100;

fhd = str2func('cec17_func');

for D = Dims
    iter_max = 10000 * D;
    AlgorithmName = ['AML_RPSO_' num2str(D)];

    % 预分配 Excel 数据
    ExcelData = zeros(30, 3);

    fprintf('\n===== Running Dimension = %d =====\n', D);

    for func_num = func_num_set

        Function_name = ['F' num2str(func_num)];

        % ===== 预分配 =====
        Best_score = zeros(runs,1);
        Eval_Num   = zeros(runs,1);

        % ===== 并行独立运行 =====
        parfor BL = 1:runs
            [Best_score(BL),Eval_Num(BL)] = ...
                AML_RPSO(fhd, D, iter_max, Xmin, Xmax, func_num);
        end

        % ===== 统计 =====
        ExcelData(func_num,1) = min(Best_score);
        ExcelData(func_num,2) = mean(Best_score);
        ExcelData(func_num,3) = std(Best_score);
        ExcelData_new(func_num,:) = Best_score;

        % ===== 简洁显示（可选）=====
        fprintf('%s | min = %.3e | mean = %.3e | std = %.3e\n', ...
            Function_name, ...
            ExcelData(func_num,1), ...
            ExcelData(func_num,2), ...
            ExcelData(func_num,3));
    end

    % ===== 写 Excel =====
    filename = [AlgorithmName '_CEC14_Result.xlsx'];
    writematrix(ExcelData, filename, 'Sheet', 1, 'Range', 'A1:C30');
        filename = [AlgorithmName '_CEC14_51Time_Result.xlsx'];
    writematrix(ExcelData_new, filename, 'Sheet', 1, 'Range', 'A1:AY30');
end