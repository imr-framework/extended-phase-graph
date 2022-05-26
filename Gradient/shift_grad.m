%Modified by: Sachin A B Anchan
%Date:30 june 2014

function omega_new = shift_grad_gre(delk,omega)

%% Shift applies to only F+ and F-- as it does not dephase in z
% check size of previous omega to determine the effect - test multiple
% times

[m,n] = size(omega); %previous time point
% if(m~=3)
%     error('Still implementing equation 26, please use 3xk');
% end

if(n>1)

F = [fliplr(omega(1,:)) squeeze((omega(2,2:end)))]; %arrange to make it like eq 27
        if(delk < 0)
              F = [zeros(1,abs(delk)) F]; %negative shift moves the population downwards - 2n-1 + delk
              Z = [squeeze(omega(3,:)) zeros(1,abs(delk))]; %No change in z due to grads
              Fp = [fliplr(F(1:n)) zeros(1,abs(delk))]; 
              Fm = F(n:end);
              

        else
              F = [F zeros(1,delk)]; %positive shift pushes the population upwards
              Z = [squeeze(omega(3,:)) zeros(1,delk)];
              Fp = fliplr(F(1:n+delk)); 
              Fm = [F(n+delk:end) zeros(1,delk)];
              
        end

else
    F = omega(1,1);
    if(delk > 0)
        
       Fp =  [zeros(1,abs(delk)) F(1)];
       Fm = [0  zeros(1,abs(delk))];
        Z = [squeeze(omega(3,:)) zeros(1,abs(delk))];
    else
        Fp = [0  zeros(1,abs(delk))];
        Fm =  [zeros(1,abs(delk)) F(1)];
        Z = [squeeze(omega(3,:)) zeros(1,abs(delk))];
        
    end
end

omega_new = [Fp;Fm;Z];


