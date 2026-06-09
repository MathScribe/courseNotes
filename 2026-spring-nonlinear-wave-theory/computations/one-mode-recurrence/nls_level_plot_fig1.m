function nls_3d_surface_fig1()

    clear; clc; close all;

    %% Parameters from the paper
    L    = 6;
    eps0 = 1e-4;

    c1  = eps0/2;
    cm1 = eps0*(0.3 - 0.4i)/2;

    %% Numerical parameters
    Nx   = 512;
    Tmax = 60;

    Nt   = 60000;
    dt   = Tmax/Nt;

    saveEvery = 20;

    %% Spatial grid
    x = linspace(-L/2, L/2, Nx+1);
    x(end) = [];

    dx = x(2)-x(1);

    %% Fourier wave numbers
    k = (2*pi/L)*[0:Nx/2-1 -Nx/2:-1];

    %% Initial condition
    k1 = 2*pi/L;

    u = 1 ...
        + c1  * exp( 1i*k1*x ) ...
        + cm1 * exp(-1i*k1*x );

    %% Linear propagator (half step)
    E = exp(-1i * k.^2 * dt/2);

    %% Storage
    nSave = floor(Nt/saveEvery) + 1;

    Uplot = zeros(nSave, Nx);
    Tplot = zeros(nSave, 1);

    Uplot(1,:) = abs(u);
    Tplot(1) = 0;

    idx = 1;

    %% Split-Step Fourier Method
    for n = 1:Nt

        % Half linear step
        uhat = fft(u);
        uhat = E .* uhat;
        u = ifft(uhat);

        % Nonlinear step
        u = u .* exp(2i * abs(u).^2 * dt);

        % Half linear step
        uhat = fft(u);
        uhat = E .* uhat;
        u = ifft(uhat);

        % Save data
        if mod(n,saveEvery)==0
            idx = idx + 1;

            Uplot(idx,:) = abs(u);
            Tplot(idx)   = n*dt;
        end
    end

    %% Meshgrid for plotting
    [X,T] = meshgrid(x,Tplot);

    %% 3D surface plot
    figure('Color','w');

    surf(X,T,Uplot,...
        'EdgeColor','none',...
        'FaceColor','interp');

    xlabel('x','FontSize',14);
    ylabel('t','FontSize',14);
    zlabel('|u(x,t)|','FontSize',14);

    title('Focusing NLS: Modulation Instability and Rogue Wave Recurrence');

    view(45,40);

    axis tight;

    camlight headlight;
    lighting gouraud;

    colormap(parula);

    colorbar;

end