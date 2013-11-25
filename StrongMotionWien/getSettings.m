function setting = getSettings()
% // basic options
setting.db.aec = ' /net/zagsun17/export/home/seismo/bebenkatalog/AEC';
setting.file.evid = 'erschuettWien.csv';
setting.showSignificantEQs.alpha = 0.001;    %dämpfung - coefficient of absorbtion
setting.accmodel.magnitudelimit = 5;      %Grenze für prefered Acceleration algorithmus (Yan < 3.8, McGuire > x)

% // plot options
setting.plot.individual.xlim = [0 40];      %xlimit für plot der report parameter H,I,...XYZ und dist/numbers plot
setting.plot.azimuth.xlim = [0 75];      %xlimit für azimuth
setting.fontsize = 16;  setting.fontsizeaxis = 15;  setting.fontsizetitle = 16;
setting.src.left = 5;  setting.src.bottom = 5;  setting.src.width = 1100;  setting.src.height = 1000;
setting.plot2ndPlotEQlistplot.yesno = 1;

% // coordinates
setting.BGWA.lat = 48.2182;
setting.BGWA.lon = 16.3626;
setting.BGWA.trigg = 0.7;

setting.UMWA.lat = 48.2108;
setting.UMWA.lon = 16.3693;
setting.UMWA.trigg = 1.0;

setting.WIWA.lat = 48.1911;
setting.WIWA.lon = 16.3679;
setting.WIWA.trigg = 0.8;

setting.KMWA.lat = 48.2301;
setting.KMWA.lon = 16.4225;
setting.KMWA.trigg = 0.7;

setting.SNWA.lat = 48.2347;
setting.SNWA.lon = 16.2880;
setting.SNWA.trigg = 0.3;

setting.ZAWA.lat = 48.2489;
setting.ZAWA.lon = 16.3567;
setting.ZAWA.trigg = 0.0;


