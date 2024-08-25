DLP calculate the optimal value funtion for the deterministic problem
    At the optimal solution, the numbers of scheduled and allocated customers for each setting at each slot are real numbers.

DLP_heu_new_orig calculate the value funtion for the stochastic problem 
    1. the random demands are accurate
    2. the numbers of scheduled and allocated customers for each setting at each slot are integers
       (thus are able to implement in practice)
DLP_heu_new_orig is exactly the heuristics drived in the paper. 

DLP_heu_simu_new_orig are same as DLP_heu_new_orig except that
    1. the random demands are sampled

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
get_V_HS_simple_linear(get_V_VS_simple_linear) only works for linear end-of-day panelty cost
get_V_HS_simple(get_V_VS_simple) works for any form of end-of-day panelty cost
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%old 
DLP_heu are same as DLP_heu_new except that
    2. the numbers of scheduled and allocated customers for each setting at each slot are real numbers
       (thus are NOT able to implement in practice)

DLP_heu_simu are same as DLP_heu_new except that
    1. the random demands are sampled
    2. the numbers of scheduled and allocated customers for each setting at each slot are real numbers
       (thus are NOT able to implement in practice)
    
    
     



