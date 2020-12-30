clear all

%% Declarations
apparent_viscosity = 0.;

%tau = [0;0;0;0;0;0];
%strain_rate = [-1;0;0;0;0;0];
shear_rate = [];
shear_rate(1) = 0;
tau2 = [];

% bingham
critical_shear_rate_ = 0.1;
tau0_ = 100;
mu_ = 25;
m = 5;

% thixotropy
floc = 2.3;
rest_t = 100;
a_thix = 1.3;
alpha = 0.01;
dt = 0.1;

% loop variables

floc_vec = [];
tau0_vec = [];
tollerance = 0.000001;

%% Loop
for j = 1:1:4
loop = 2000;
for i = 1:1:loop
    if shear_rate(i) * shear_rate(i) > critical_shear_rate_ * critical_shear_rate_  
        if floc > tollerance  
            
            floc_prev= floc;
            floc = floc_prev*exp(-alpha * shear_rate(i)*dt);
            floccheck = floc;
            if floccheck > tollerance                 
                tau0_temp = (1 + floc) * tau0_;
                tau2(i) = tau0_temp*(1-exp(-m*shear_rate(i)))+mu_*shear_rate(i);
                rest_t = (tau0_temp-tau0_)/a_thix;  
            else
                floc = 0.;
                tau2(i) = tau0_*(1-exp(-m*shear_rate(i)))+mu_*shear_rate(i);
                rest_t = 0.;
            end
        else
            tau2(i) = tau0_*(1-exp(-m*shear_rate(i)))+mu_*shear_rate(i);
            rest_t = 0.;
        end
        rest_t = 0.;
        floc_vec1(i) = floc;  
    else 
        
        display("thix")
        tau_t = tau0_ + (a_thix * rest_t);
        tau2(i) = tau_t*(1-exp(-m*shear_rate(i)))+mu_*shear_rate(i);
        
        floc = (tau_t /tau0_) -1;
        rest_t = rest_t + dt;
        floc_vec1(i) = floc;
    end
    
    if i < (loop +1)/2
        shear_rate(i+1) = shear_rate(i) +0.01;
    else
        if shear_rate(i) > 0
            shear_rate(i+1) = shear_rate(i) -0.01;
        else
            shear_rate(i+1) = 0.01;
        end
    end
    
    
    if j == 1
        shear_store1(i) = tau2(i);
        floc_store1(i) = floc_vec1(i);
    end
    if j == 2
        shear_store2(i) = tau2(i);
        floc_store2(i) = floc_vec1(i);
    end
    if j == 3
        shear_store3(i) = tau2(i);
        floc_store3(i) = floc_vec1(i);
    end
    if j == 4
        shear_store4(i) = tau2(i);
        floc_store4(i) = floc_vec1(i);
    end
        
end
%tau0_ = tau0_ + 25;
rest_t = 100 + 10*j;
%rest_t = 100;
%m = m * 2
%a_thix = a_thix + 0.2;
%alpha = alpha + 0.01;
%mu_ = mu_ + 5;
end



%% plotte

figure
hold on
yyaxis left
ylabel('\tau', 'FontSize', 15)
pl = plot (shear_rate(1:loop), shear_store1,'k-', shear_rate(1:loop), shear_store2,'k--', shear_rate(1:loop), shear_store3, 'k-.', shear_rate(1:loop), shear_store4,'k:')

ax = gca;
% This sets background color to black
ax.YColor = 'k';
set(gca,'FontSize',15)

yyaxis right
plot (shear_rate(1:loop), floc_store1,'-', shear_rate(1:loop), floc_store2,'--', shear_rate(1:loop), floc_store3, '-.', shear_rate(1:loop), floc_store4,':')
ylim([0 10])
xlabel('\gamma','FontSize', 15)
ylabel('\lambda','FontSize', 15)

% This sets background color to black
ax.YColor = 'r';