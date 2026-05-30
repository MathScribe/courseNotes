function reproduce_paper_fig1_bw_v2()

    clear; clc; close all;

    %% ================================================================
    %  Parameters from the paper
    % ================================================================

    L    = 6;
    eps0 = 1e-4;

    c1   = 1/2;
    cm1  = (0.3 - 0.4i)/2;

    k1 = 2*pi/L;

    %% ================================================================
    %  Faster numerical parameters
    % ================================================================

    Nx   = 384;       % faster than 512, still smooth
    Tmax = 60;

    Nt = 30000;       % faster than 60000
    dt = Tmax/Nt;

    saveEvery = 25;

    %% ================================================================
    %  Spatial grid
    % ================================================================

    x = linspace(-L/2, L/2, Nx+1);
    x(end) = [];

    k = (2*pi/L)*[0:Nx/2-1, -Nx/2:-1];

    %% ================================================================
    %  Initial condition
    % ================================================================

    u = 1 + eps0*( ...
          c1  * exp( 1i*k1*x ) ...
        + cm1 * exp(-1i*k1*x ) );

    %% ================================================================
    %  Split-step Fourier method
    % ================================================================

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

        % full nonlinear step
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
    %  Paper-style 3D plot
    % ================================================================

    [Xgrid,Tgrid] = meshgrid(x,Tplot);

    figure('Color','w','Position',[100 100 1200 420]);

    % Important:
    % plot time as the long axis, x as the transverse axis.
    s = surf(Tgrid, Xgrid, Uplot);

    set(s, ...
        'EdgeColor','none', ...
        'FaceColor',[0.68 0.68 0.68], ...   % light gray surface
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.80, ...
        'DiffuseStrength',0.55, ...
        'SpecularStrength',0.18, ...
        'SpecularExponent',18);

    shading interp;

    %% Axes limits
    xlim([0 Tmax]);
    ylim([-L/2 L/2]);
    zlim([0.75 2.9]);

    %% Long thin aspect ratio like the paper
    pbaspect([9 1.6 1.0]);

    %% Orientation
    % This is the main orientation change compared with the previous code.
    view([35 22]);

    camproj('orthographic');

    %% Lighting
    light('Position',[-20 -10 20],'Style','infinite');
    light('Position',[40 20 10],'Style','infinite');

    material dull;

    axis off;
    box off;

    %% ================================================================
    %  Draw simple black axes arrows
    % ================================================================

    hold on;

    z0 = 0.78;

    % time-axis baseline
    plot3([0 Tmax],[-L/2 -L/2],[z0 z0], ...
        'k','LineWidth',1.2);

    % time arrow
    quiver3(0,-L/2,z0,-4,0,0,0, ...
        'k','LineWidth',1.2,'MaxHeadSize',0.8);

    % x arrow
    quiver3(Tmax,-L/2,z0,0,L,0,0, ...
        'k','LineWidth',1.2,'MaxHeadSize',0.8);

    % vertical arrow
    quiver3(Tmax,-L/2,z0,0,0,1.2,0, ...
        'k','LineWidth',1.2,'MaxHeadSize',0.8);

    text(-3,-L/2,z0,'t','FontSize',14);
    text(Tmax, L/2+0.25,z0,'x','FontSize',14);

    hold off;

    %% ================================================================
    %  Save PNG only
    % ================================================================

    drawnow;

    outFile = fullfile(fileparts(mfilename('fullpath')), ...
        'paper_fig1_reproduction_bw_v2.png');

    if exist('exportgraphics','file')
        exportgraphics(gcf,outFile,'Resolution',300);
    else
        print(gcf,outFile,'-dpng','-r300');
    end

end
