function reproduce_paper_fig1_bw_v4()

    clear; clc; close all;

    %% ================================================================
    % Parameters from the paper
    %% ================================================================

    L    = 6;
    eps0 = 1e-4;

    c1   = 1/2;
    cm1  = (0.3 - 0.4i)/2;

    k1 = 2*pi/L;

    %% ================================================================
    % Numerical parameters
    %% ================================================================

    Nx   = 384;
    Tmax = 60;

    Nt = 30000;
    dt = Tmax/Nt;

    saveEvery = 25;

    thisDir = fileparts(mfilename('fullpath'));
    datafile = fullfile(thisDir,'fig1_data.mat');

    %% ================================================================
    % Load data if available, otherwise compute it
    %% ================================================================

    if exist(datafile,'file')

        load(datafile,'x','Tplot','Uplot','L','Tmax');

    else

        x = linspace(-L/2, L/2, Nx+1);
        x(end) = [];

        k = (2*pi/L)*[0:Nx/2-1, -Nx/2:-1];

        u = 1 + eps0*( ...
              c1  * exp( 1i*k1*x ) ...
            + cm1 * exp(-1i*k1*x ) );

        Ehalf = exp(-1i*k.^2*dt/2);

        nSave = floor(Nt/saveEvery) + 1;

        Uplot = zeros(nSave,Nx);
        Tplot = zeros(nSave,1);

        Uplot(1,:) = abs(u);
        Tplot(1)   = 0;

        idx = 1;

        for n = 1:Nt

            % half linear step
            uhat = fft(u);
            uhat = Ehalf .* uhat;
            u = ifft(uhat);

            % nonlinear step
            u = u .* exp(2i*abs(u).^2*dt);

            % half linear step
            uhat = fft(u);
            uhat = Ehalf .* uhat;
            u = ifft(uhat);

            if mod(n,saveEvery)==0
                idx = idx + 1;
                Uplot(idx,:) = abs(u);
                Tplot(idx)   = n*dt;
            end
        end

        save(datafile,'x','Tplot','Uplot','L','Tmax');

    end

    %% ================================================================
    % Paper-style black-and-white 3D plot
    %% ================================================================

    [Xgrid,Tgrid] = meshgrid(x,Tplot);

    figure('Color','w','Position',[80 80 1450 520]);
    set(gcf,'Renderer','opengl');
    set(gcf,'InvertHardcopy','off');

    %% ================================================================
    % Grayscale surface coloring
    %% ================================================================

    % The paper is not pure white. It uses a medium-gray surface with
    % bright highlights near peaks and darker shadows near steep slopes.
    %
    % This maps |u| into a narrow grayscale range.
    % Smaller grayLo -> darker surface.
    % Larger grayHi -> brighter peaks.

    grayLo = 0.44;
    grayHi = 0.72;

    Umin = 0.70;
    Umax = 2.85;

    Uclip = min(max(Uplot,Umin),Umax);
    Uscaled = (Uclip - Umin)/(Umax - Umin);

    Cgray = grayLo + (grayHi-grayLo)*Uscaled;

    s = surf(Tgrid, Xgrid, Uplot, Cgray);

    set(s, ...
        'EdgeColor','none', ...
        'FaceColor','interp', ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.55, ...
        'DiffuseStrength',0.85, ...
        'SpecularStrength',0.18, ...
        'SpecularExponent',25);

    colormap(gray(256));
    caxis([0 1]);

    %% ================================================================
    % Axes and camera
    %% ================================================================

    xlim([-4 Tmax+4]);
    ylim([-L/2 L/2+0.55]);

    % Do not clip the lower part of the surface.
    zlim([0 3.05]);

    % Long, thin surface like the paper.
    pbaspect([9.3 1.55 1.05]);

    % Paper-like camera orientation.
    view([32 20]);
    camproj('orthographic');

    % Zoom in to reduce the large white empty region.
    camzoom(1.22);

    axis off;
    box off;

    % Reduce white margins in the exported PNG.
    set(gca,'Position',[0.01 0.02 0.98 0.96]);
    set(gca,'LooseInset',[0 0 0 0]);

    %% ================================================================
    % Lighting
    %% ================================================================

    delete(findall(gca,'Type','light'));

    % Main light from upper-left/front.
    light('Position',[-35 -25 35],'Style','infinite');

    % Weak fill light from the opposite side.
    light('Position',[45 20 18],'Style','infinite');

    lighting gouraud;
    material dull;

    %% ================================================================
    % Draw simple black coordinate arrows
    %% ================================================================

    hold on;

    z0 = 0.07;
    y0 = -L/2;

    % Long time-axis baseline
    plot3([0 Tmax],[y0 y0],[z0 z0], ...
        'k','LineWidth',1.15);

    % Time arrow on the left
    quiver3(0,y0,z0,-3.2,0,0,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    % x arrow on the right
    quiver3(Tmax,y0,z0,0,L,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    % vertical arrow
    quiver3(Tmax,y0,z0,0,0,1.15,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    text(-3.7,y0,z0,'t','FontSize',16);
    text(Tmax,L/2+0.35,z0,'x','FontSize',16);

    hold off;

    %% ================================================================
    % Save PNG only
    %% ================================================================

    drawnow;

    outFile = fullfile(thisDir,'paper_fig1_reproduction_bw_v4.png');
    print(gcf,outFile,'-dpng','-r300');

end
