function [Bmin,Bmax,Lmin,Lmax] = getUserDefinedRectangleVals(optval,setting)
%  Austria close to (46.2/49.2/9.3/18)
Bmin = 46.2;        Bmax = 49.2;
Lmin = 9.3;         Lmax = 18;

%// if DB filter (rectangle) is specified by the user (=2)
switch  optval
    case 1  % Emilia Romagna(44.5/45.2/10.6/12)
        Bmin = 44.5;        Bmax = 45.2;
        Lmin = 10.6;        Lmax = 12;
    case 2  %  Vogtland (49/51/11.8/13)
        Bmin = 49;          Bmax = 51;
        Lmin = 11.8;        Lmax = 13;
    case 3  %  empty schwaz test
        Bmin = 47.22;          Bmax = 47.36;
        Lmin = 11.57;        Lmax = 11.89;
    case 4  %  empty Molln test
        Bmin = 47.7;          Bmax = 47.9;
        Lmin = 14.0;        Lmax = 14.5;      
    case 5  %  empty Hall test
        Bmin = 47.21;          Bmax = 47.34;
        Lmin = 11.4;        Lmax = 11.65;    
    case 6  %  Ebreichsdorf
        %Bmin = 47.83;          Bmax = 48.03; %etwa 8km  dB=0.2  dL=0.24
        %Lmin = 16.3;        Lmax = 16.54;  
        Bmin = 47.78;          Bmax = 48.15; %etwa 20km  dB=0.37  dL=0.55
        Lmin = 16.12;        Lmax = 16.67;          
    case 7  %  Seebenstein
        %Bmin = 47.6314;          Bmax = 47.8052;  %etwa 8km   dB=0.17  dL=0.27
        %Lmin = 16.0435;        Lmax = 16.3107;
        Bmin = 47.527;          Bmax = 47.857;    %etwa 20km   dB=0.33  dL=0.55
        Lmin = 15.90;        Lmax = 16.45; 
    case 8  %  leer
%        
    case 9  %reserved
        switch setting.useshape.selectedLandgrenzen
            case 0
                %  Austria close to (46.2/49.2/9.3/18)
                Bmin = 46.2;        Bmax = 49.2;
                Lmin = 9.3;         Lmax = 18;
            case 12
                %  Südtirol
                Bmin = 46;        Bmax = 47;
                Lmin = 10;         Lmax = 13;
            case 13
                %  Slovenia
                Bmin = 45.4;        Bmax = 46.89;
                Lmin = 13.36;         Lmax = 16.58;
            case 14
                %  Italy
                Bmin = 35.45;        Bmax = 47.16;
                Lmin = 6.56;         Lmax = 18.55;
            case 15
                %  Swiss
                Bmin = 45.82;        Bmax = 47.83;
                Lmin = 5.94;         Lmax = 10.51;
            case 16
                %  Slovakia
                Bmin = 47.71;        Bmax = 49.63;
                Lmin = 16.81;         Lmax = 22.60;
            case 17
                %  Hungary
                Bmin = 45.72;        Bmax = 48.60;
                Lmin = 16.08;         Lmax = 22.93;
            case 18
                %  Germany
                Bmin = 47.25;        Bmax = 55.11;
                Lmin = 5.81;         Lmax = 15.09;                
        end
    case 11  %  Friaul
        Bmin = 45.99;          Bmax = 46.52;    %etwa 30km   dB=0.53  dL=0.76
        Lmin = 12.83;        Lmax = 13.59;         
    case 0
        inp = input('>> Enter the Value for Bmin e.g. 49.4 [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            Bmin = str2num(inp);
        end
        inp = input('>> Enter the Value for Bax e.g. 52.4 [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            Bmax = str2num(inp);
        end
        inp = input('>> Enter the Value for Lmin e.g. 9.3 [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            Lmin = str2num(inp);
        end
        inp = input('>> Enter the Value for Lmax e.g. 18.3.4 [q..quit]\n','s');
        if isnumeric(str2num(inp)) && ~strcmp(inp,'q')
            Lmax = str2num(inp);
        end
end