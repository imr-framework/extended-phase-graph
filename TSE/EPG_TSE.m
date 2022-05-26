%% This file implements the EPG framework for a given pulse sequence
% Author: Sairam Geethanath
% Sequence: TSE
% 90y - ESP/2 - 120x - ESP - 120x ...; with positive gradients on
% Initial state of the magnetization is [0 0 1].';
% Generated at: Medical Imaging Research Center (MIRC)
%%
omega = [0 0 1].';
delk=1; %Unit dephasing
esp = 20;%ms
annot=1;%annotate echo intensities on the graph

%% Describe pulse sequence in steps, see if you want to make this concise through functions
%90y;t=0
% omega = cell(40);
omega = rf_rotation(90,90)*omega; om_store{1} = omega;
%Gx - delk;t- = esp/2
omega = shift_grad(delk,omega); om_store{2} = omega;%application of a gradient of unit k; t= esp/2 - will be an issue later
%120x pulse;t+ = esp/2
omega = rf_rotation(0,120)*omega; om_store{3} = omega;
%Gx - delk;t = esp
omega = shift_grad(delk,omega);om_store{4} = omega;
%Gx - delk;t- = 1.5 esp
omega = shift_grad(delk,omega);om_store{5} = omega;
% 120x pulse;t=1.5 esp
omega = rf_rotation(0,120)*omega;om_store{6} = omega;
%Gx - delk;t = 2 esp
omega = shift_grad(delk,omega);om_store{7} = omega;
%Gx - delk;t- = 2.5 esp
omega = shift_grad(delk,omega);om_store{8} = omega;
% 120x pulse;t+=2.5esp
omega = rf_rotation(0,120)*omega;om_store{9} = omega;
%Gx - delk;t = 3 esp
omega = shift_grad(delk,omega);om_store{10} = omega;

%% Display - User inputs need to be improved
seq.rf = [ 90   0     0 0; 
           90 120 120 120];
seq.grad = [delk delk delk delk delk delk];%gradient shift direction
seq.time = [0 10 10 20 30 30 40 50 50 60]; %User defined
% seq.t = [0 '0.5esp' 
seq.events = {'rf', 'grad','rf','grad','grad','rf','grad','grad','rf','grad'}; 
display_epg_v1(om_store,seq,annot);


