function reproduce_paper_fig1_bw_v3()

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

    %% ================================================================
    % Spatial grid and Fourier modes
    %% ================================================================

    x = linspace(-L/2, L/2, Nx+1);
    x(end) = [];

    k = (2*pi/L)*[0:Nx/2-1, -Nx/2:-1];

    %% ================================================================
    % Initial condition
    %% ================================================================

    u = 1 + eps0*( ...
          c1  * exp( 1i*k1*x ) ...
        + cm1 * exp(-1i*k1*x ) );

    %% ================================================================
    % Split-step Fourier method
    %% ================================================================

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

    %% ================================================================
    % Paper-style black-and-white 3D figure
    %% ================================================================

    [Xgrid,Tgrid] = meshgrid(x,Tplot);

    figure('Color','w','Position',[80 80 1400 460]);
    set(gcf,'Renderer','opengl');
    set(gcf,'InvertHardcopy','off');

    % Constant gray color data.
    % This prevents MATLAB from using blue/yellow data coloring.
    Cgray = 0.68*ones(size(Uplot));

    s = surf(Tgrid, Xgrid, Uplot, Cgray);

    set(s, ...
        'EdgeColor','none', ...
        'FaceColor','interp', ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.82, ...
        'DiffuseStrength',0.55, ...
        'SpecularStrength',0.08, ...
        'SpecularExponent',20);

    % Force grayscale colormap.
    colormap(gray(256));
    caxis([0 1]);

    % Do NOT use shading interp here.
    % shading interp can overwrite the intended surface coloring.

    %% Axis limits

    xlim([-4 Tmax+4]);
    ylim([-L/2 L/2+0.6]);

    % Important:
    % lower bound is 0, not 0.75.
    % This removes the white holes.
    zlim([0 3.05]);

    %% Shape and camera

    pbaspect([9.5 1.55 1.05]);

    % Paper-like orientation
    view([33 18]);

    camproj('orthographic');

    axis off;
    box off;

    %% Lighting

    delete(findall(gca,'Type','light'));

    light('Position',[-30 -20 35],'Style','infinite');
    light('Position',[50 20 25],'Style','infinite');

    lighting gouraud;
    material dull;

    %% Draw simple axes arrows

    hold on;

    z0 = 0.08;
    y0 = -L/2;

    % long time-axis baseline
    plot3([0 Tmax],[y0 y0],[z0 z0], ...
        'k','LineWidth',1.15);

    % time arrow, pointing left
    quiver3(0,y0,z0,-3.2,0,0,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    % x arrow
    quiver3(Tmax,y0,z0,0,L,0,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    % vertical amplitude arrow
    quiver3(Tmax,y0,z0,0,0,1.15,0, ...
        'k','LineWidth',1.15,'MaxHeadSize',0.8);

    text(-3.6,y0,z0,'t','FontSize',15);
    text(Tmax,L/2+0.35,z0,'x','FontSize',15);

    hold off;

    %% Save PNG only

    drawnow;

    outFile = fullfile(fileparts(mfilename('fullpath')), ...
        'paper_fig1_reproduction_bw_v3.png');

    print(gcf,outFile,'-dpng','-r300');

end
