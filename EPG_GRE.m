%% This file implements the EPG framework for a Gradient Echo pulse sequence
% Author: Sairam Geethanath
% Sequence: GRE
% 30x -delk +delk +delk
% Initial state of the magnetization is [0 0 1].';
% Generated at: Medical Imaging Research Center (MIRC)
%%
clc;  
clear all;
omega = [0 0 1].';
delk=1; %Unit dephasing
esp = 20;%ms                                             
annot=1;%annotate echo intensities on the graph
T1=1000e-3;%seconds
T2=100e-3;%seconds
TR=10e-3;%seconds
M0=1;
E1=exp(-TR/T1);
E2=exp(-TR/T2);
E=[E2 0 0;0 E2 0;0 0 E1];
%% Describe pulse sequence in steps
%
omega = rf_rotation(0,30)*omega;om_store{1} = omega;
%
omega =shift_grad(-delk,omega); om_store{2} = omega;
%
omega =shift_grad(delk,omega); om_store{3} = omega;
%
omega =shift_grad(delk,omega); om_store{4} = omega;

omega =shift_grad(delk,omega); om_store{5} = omega;


%% Display - User inputs need to be improved
seq.rf = [ 0;30];
seq.grad = [-delk delk delk delk -delk];%gradient shift direction
seq.time = [0 10 20 30 40 50]; %User defined
% seq.t = [0 '0.5esp']
seq.events = {'rf', 'grad','grad','grad','grad','grad'}; 
display_epg_v1(om_store,seq,annot);


