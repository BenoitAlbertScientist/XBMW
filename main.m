%% Download data 
addpath 'Affichage&Index&Method'
addpath 'Data'
load iris_s

n=size(x,2);    %Number of objects
nd=size(x,1);   %Number of attributs
c=length(cl);   %Number of clusters

%% COMPARAISON FCM vs FCM-GK
%Apply Alternating Optimization. 

% parameters for AO
parameters.init = 0; %Random initialisation
parameters.iprint = 0; %0 print

% -----  FCM 
disp('--- FCM ---');name_meth = 'FCM'; rng('default'); %Rand init
parameters.distance = 0; %Euclidian distance
[u,v,S] = FCM_AO(x,c,parameters);
EVAL(x,u,v,S,HP,name_data,name_meth);

% ----- FCM-GK
disp('--- GK  ---'); name_meth = 'FCM-GK'; rng('default'); %Rand init
parameters.distance = 1; %Mahalanobis distance
[u,v,S] = FCM_AO(x,c,parameters);
EVAL(x,u,v,S,HP,name_data,name_meth);

%% Evaluation 
%Evaluation with ARI, XB and XBMW.
%Print in 2D clustering.

function [] = EVAL(x,u,v,S,HP,name_data,name_meth)

    %ARI
    hp=Fuzzy2Hard(u);
    fprintf("ARI  = %.2f \n",ARI(HP,Fuzzy2Hard(u)));
    
    %XB
    parameters_XB.choice_index=0;
    xb=XB(x',u,v',parameters_XB);
    fprintf("XB  = %1.2f \n",xb);
    
    %XBMW
    parameters_XBMW.choice_index=1;
    parameters_XBMW.give_cov=1; %S is inverse of covariance matrix
    parameters_XBMW.matrix=S;
    xbmw=XB(x',u,v',parameters_XBMW);
    fprintf("XBMW  = %1.2f \n",xbmw);
    
    %DISPLAY
    titre = strcat(name_data,name_meth);
    DisplayClustering2D(x',v',hp,S,titre);

end

  