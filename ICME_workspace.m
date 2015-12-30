%% Workspace for get_ICME_tabledata.m
clear all
close all

% Check jpb.ninja/index.html or
% http://www.srl.caltech.edu/ACE/ASC/DATA/level3/icmetable2.htm for more
% information regarding each variable.

% BY DEFAULT:: 0 = No; 1 = Yes;

% quality = 1, 2, 3, 4 %% 1 = reliable; 4 = weak;
% lasco_datagap = 0, 1, 2, NaN %% 0 = fine; 1 = data gap; 2 = doubtful association;
% Hut = 0,1 %% MC [H] Event reported by Huttunen et al. that is not listed by Lepping;
% Halo = 0,1 
% dstpeak_info = 0, 1, 2 %% 1 = [P] 'Provisional' value; 2 = [Q] 'Quicklook' data from the WDC for Geomagnetism, Kyoto;
% bde = 0,1,2 NaN %% 2 = SEP;
% bif = 0,1, NaN

tic
[jdssc_rich, jds_icme, jde_icme, jds_mc, jde_mc, bde, bif, quality,...
    V_ICME, vpeak, B, MC, Hut, dstpeak, dstpeak_info, v_transit,...
    jd_lascotime, lasco_datagap, Halo] = get_ICME_tabledata();
toc

