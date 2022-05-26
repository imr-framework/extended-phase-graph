function T_phi_alpha = rf_rotation (phi,alpha)
phi = deg2rad(phi);
alpha = deg2rad(alpha);

T_phi_alpha = [cos(alpha/2).^2                     exp(2*1i*phi)*sin(alpha/2).^2       -1i*exp(1i*phi)*sin(alpha);
           exp(-2*1i*phi)*sin(alpha/2).^2       cos(alpha/2).^2                     1i*exp(-1i*phi)*sin(alpha);
           -1i*0.5.*exp(-1i*phi)* sin(alpha)    1i*0.5.*exp(1i*phi)* sin(alpha)     cos(alpha)];