function display_epg_v1(omega,seq,annot)
T = length(omega);
kmax = size(omega{length(omega)},2);
kstates = -kmax+1:kmax-1;
grad_cnt =1;
rf_cnt=1;
seq.time_unique = unique(seq.time);%treating rf pulses as instantaneous

%% For t==0 case - must be true for all sequences
figure(101); hold on; grid on;
t=0.*ones(1,length(kstates));
plot(t,kstates);
flip = seq.rf(:,rf_cnt).';
text(t(1),kmax-1,[num2str(flip(1)), ' ,',num2str(flip(2))] ,'FontSize',12);
axis ([0 seq.time(end)  -kmax+1 kmax]);


%%
for seq_read =2:length(seq.events)
   
    %% Get data
%              om_current = omega{seq_read};
             om_past  = omega{seq_read -1};
            
            % Fp - states - 
%             Fpc = squeeze(om_current(1,:));
            Fpp = squeeze(om_past(1,:));
            
            % Fm - states - 
%             Fmc = squeeze(om_current(2,:));
            Fmp = squeeze(om_past(2,:));
               
            % Zk - states - 
%             Zc = squeeze(om_current(3,:));
            Zp = squeeze(om_past(3,:));
    
    
    
    
    
    
    
    
    switch (seq.events{seq_read})
        
        
        
        
        
        
        %% RF
        case 'rf' %exchanges populations among three states; depict only 2
%             disp('looking at rf pulse');
            %draw a vertical line spanning all k-states
            rf_cnt = rf_cnt +1;
            t = seq.time(seq_read).*ones(1,length(kstates));
            plot(t,kstates); hold on;
            flip = seq.rf(:,rf_cnt).';
            text(t(1),kmax-1,[num2str(flip(1)), ' ,',num2str(flip(2))] ,'FontSize',12);
           
            
            
       %%   Grad
        case 'grad'
            

                     grad_cnt = grad_cnt +1;
        %            disp('looking at grad');


                    % Fp state plot
                     Fpp_kstates= find(abs(Fpp)> 5*eps) -1;
                     for k=1:length(Fpp_kstates)
%                          Fp_plot = [Fpp_kstates(k) Fpp_kstates(k)+1];
                           Fp_plot = [Fpp_kstates(k) Fpp_kstates(k)+seq.grad(grad_cnt-1)];
                         t =  [seq.time_unique(grad_cnt-1)  seq.time_unique(grad_cnt)];
                         plot(t,Fp_plot,'k-');hold on;
                         %Anotation here
                         if(annot==1)
                         intensity_r = real(Fpp(Fpp_kstates(k)+1)) - mod(real(Fpp(Fpp_kstates(k)+1)),1e-2);
                         intensity_i = imag(Fpp(Fpp_kstates(k)+1)) - mod(imag(Fpp(Fpp_kstates(k)+1)),1e-2);
                         text(t(1),Fp_plot(1),num2str(intensity_r + 1i*intensity_i),'FontSize',12);
                         end
                         
                     end



                     %    Fm state plot
                     Fmp_kstates= -1*(find(abs(Fmp)> 5*eps) -1); 
                     for k=1:length(Fmp_kstates)
%                          Fp_plot = [Fmp_kstates(k) Fmp_kstates(k)+1];
                         Fp_plot = [Fmp_kstates(k) Fmp_kstates(k)+seq.grad(grad_cnt-1)];
                         t =  [seq.time_unique(grad_cnt-1)  seq.time_unique(grad_cnt)];
                         plot(t,Fp_plot,'k-');hold on;


                                 Fmp_echo = find(Fp_plot==0,1);
                                 if(~isempty(Fmp_echo))
                                     plot(t(Fmp_echo), 0, '--ro','LineWidth',2,...
                                    'MarkerEdgeColor','k',...
                                    'MarkerFaceColor','g',...
                                    'MarkerSize',10);
                                 end
                                 
                               
                             if(annot==1)
                                  Fmp_kstates= (find(abs(Fmp)> 5*eps) -1); 
                                 intensity_r = real(Fmp(Fmp_kstates(k)+1)) - mod(real(Fmp(Fmp_kstates(k)+1)),1e-2);
                                 intensity_i = imag(Fmp(Fmp_kstates(k)+1)) - mod(imag(Fmp(Fmp_kstates(k)+1)),1e-2);
                                 text(t(1),Fp_plot(1),num2str(intensity_r + 1i*intensity_i),'FontSize',12);
                             end    
                                 
                                 
                                 
                                 
                                 

                     end


                       %Zp state plot
                      Zp_kstates= (find(abs(Zp)> 5*eps) -1); 
                      for k=1:length(Zp_kstates)
                         Fp_plot = [Zp_kstates(k) Zp_kstates(k)];

                         t =  [seq.time_unique(grad_cnt-1)  seq.time_unique(grad_cnt)];
                         plot(t,Fp_plot,'--k');hold on;
                         
                         
%                          if(annot==1) %TODO later
%                                   Zp_kstates= (find(abs(Fmp)> 5*eps) -1); 
%                                  intensity_r = real(Zp(Zp_kstates(k)+1)) - mod(real(Zp(Zp_kstates(k)+1)),1e-2);
%                                  intensity_i = imag(Zp(Zp_kstates(k)+1)) - mod(imag(Zp(Zp_kstates(k)+1)),1e-2);
%                                  text(t(1),Fp_plot(1),num2str(intensity_r + 1i*intensity_i));
%                           end
                         
                         
                         
                         
                      end

            
                
                
                
                
                
      end
                
    
end


    
    

    
axis ([0 seq.time(end)  -kmax+1 kmax-1]);
title('Turbo Spin Echo','fontsize',18);
xlabel('Time (ms)','fontsize',15);ylabel('k states','fontsize',15);
grid on;
    