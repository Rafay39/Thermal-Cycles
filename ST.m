function [ETA XMASSFLOW DATEN DATEX DAT MASSFLOW COMBUSTION] = ST(P_e,options,display)
% ST Steam power plants modelisation
% ST(P_e,options,display) compute the thermodynamics states for a Steam
% power plant (combustion, exchanger, cycle) turbine based on several 
% inputs (given in OPTION) and based on a given electricity production P_e.
% It returns the main results. It can as well plots graphs if input 
% argument DISPLAY = true (<=> DISPLAY=1)
%
% INPUTS (some inputs can be dependent on others => only one of these 2 can
%         be activated)
% P_E = electrical power output target [W]
% OPTIONS is a structure containing :
%   -options.nsout     [-] : Number of feed-heating 
%   -options.reheat    [-] : Number of reheating
%   -options.T_max     [°C] : Maximum steam temperature
%   -options.T_cond_out[°C] : Condenseur cold outlet temperature
%   -options.p3_hp     [bar] : Maximum pressure
%   -options.drumFlag  [K] : if =1 then drum if =0 => no drum. 
%   -options.eta_mec   [-] : mecanic efficiency of shafts bearings
%   -options.comb is a structure containing combustion data : 
%       -comb.Tmax     [°C] : maximum combustion temperature
%       -comb.lambda   [-] : air excess
%       -comb.x        [-] : the ratio O_x/C. Example 0.05 in CH_1.2O_0.05
%       -comb.y        [-] : the ratio H_y/C. Example 1.2 in CH_1.2O_0.05
%   -options.p_3       [-] : High pressure after last reheating
%   -options.x4        [-] : Vapor ratio [gaseous/liquid] (titre)
%   -options.T0        [°C] : Reference temperature
%   -options.TpinchSub [°C] : Temperature pinch at the subcooler
%   -options.TpinchEx  [°C] : Temperature pinch at a heat exchanger
%   -options.TpinchCond[°C] : Temperature pinch at condenser 
%   -options.Tdrum     [°C] : minimal drum temperature
%   -option.eta_SiC    [-] : Isotrenpic efficiency for compression
%   -option.eta_SiT    [-] : Isotrenpic efficiency for Turbine. It can be a vector of 3 value :
%             	             eta_SiT(1)=eta_SiT_HP,eta_SiT(2)=eta_SiT_MP,eta_SiT(3)=eta_SiT_BP
% DISPLAY = 1 or 0. If 1, then the code should plot graphics. If 0, then 
%          do not plot.
%
%OUPUTS : 
% ETA is a vector with :
%   -eta(1) : eta_cyclen, cycle energy efficiency
%   -eta(2) : eta_toten, overall energy efficiency
%   -eta(3) : eta_cyclex, cycle exegy efficiency
%   -eta(4) : eta_totex, overall exergie efficiency
%   -eta(5) : eta_gen, Steam generator energy efficiency
%   -eta(6) : eta_gex, Steam generator exergy efficiency
%   -eta(7) : eta_combex, Combustion exergy efficiency
%   -eta(8) : eta_chemex, Chimney exergy efficiency (losses)
%   -eta(9) : eta_transex, Heat exchanger overall exergy efficiency
% Xmassflow is a vector with each feedheating massflow (respect to figure 
%           2.33, page 91 "Thermal Power Plants" English version).
%           Xmassflow(1) = mass flow at 6_1 etc...
% DATEN is a vector with : 
%   -daten(1) : perte_gen [W]
%   -daten(2) : perte_mec [W]
%   -daten(3) : perte_cond [W]
% DATEX is a vector with :
%   -datex(1) : perte_mec    [W]
%   -datex(2) : perte_totex  [W]
%   -datex(3) : perte_rotex  [W]
%   -datex(4) : perte_combex [W]
%   -datex(5) : perte_condex [W]
%   -datex(6) : perte_chemex [W]
%   -datex(7) : perte_transex[W]
% DAT is a matrix containing :
% dat = {T_1       , T_2       , ...       , T_4;  [°C]
%        p_1       , p_2       , ...       , p_4;  [bar]
%        h_1       , h_2       , ...       , h_4;  [kJ/kg]
%        s_1       , s_2       , ...       , s_4;  [kJ/kg/K]
%        e_1       , e_2       , ...       , e_4;  [kJ/kg]
%        x_1       , x_2       , ...       , x_4;};[-]
% MASSFLOW is a vector containing : 
%   -massflow(1) = m_a, air massflow [kg/s]
%   -massflow(2) = m_v, water massflow at 2 [kg/s]
%   -massflow(3) = m_c, combustible massflow [kg/s] 
%   -massflow(4) = m_f, exhaust gas massflow [kg/s]
% 
% COMBUSTION is a structure with :
%   -combustion.LHV    : the Lower Heat Value of the fuel [kJ/kg]
%   -combustion.e_c    : the combustible exergie         [kJ/kg]
%   -combustion.lambda : the air excess                   [-]
%   -combustion.Cp_g   : heat capacity of exhaust gas     [kJ/kg/K]
%   -combustion.fum  : is a vector of the exhaust gas composition :
%       -fum(1) = m_O2f  : massflow of O2 in exhaust gas [kg/s]
%       -fum(2) = m_N2f  : massflow of N2 in exhaust gas [kg/s]
%       -fum(3) = m_CO2f : massflow of CO2 in exhaust gas [kg/s]
%       -fum(4) = m_H2Of : massflow of H2O in exhaust gas [kg/s]



if nargin<3
    display = 1;
    if nargin<2
        options = struct();
        if nargin<1
            P_e = 250e6; % [W] Puissance énergétique de l'installation
        end
    end
end


%% Your work
if isfield(options,'T_0')
    T_0 = options.T_0;
else
    T_0 = 288.15;  % [éC]
end

end