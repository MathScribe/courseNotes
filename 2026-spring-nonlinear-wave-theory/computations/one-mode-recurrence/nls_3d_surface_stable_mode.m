function nls_3d_surface_stable_mode()

    clear; clc; close all;

    %% Stable-mode setup: choose L < pi so k1 > 2
    L    = 2.0;       % stable regime, since k1 = 2*pi/L > 2
    eps0 = 1e-6;

    c1   = eps0/2;
    cm1  = eps0*(0.3 - 0.4i)/2;

    %% Numerical parameters
    Nx   = 512;
    Tmax = 40;

    Nt   = 70000;
    dt   = Tmax/Nt;

    saveEvery = 20;

    %% Spatial grid: periodic on [-L/2, L/2)
    x = linspace(-L/2, L/2, Nx+1);
    x(end) = [];

    %% Fourier wave numbers
    k = (2*pi/L) * [0:Nx/2-1, -Nx/2:-1];

    %% Initial condition: one stable Fourier mode
    k1 = 2*pi/L;
    u = 1 ...
        + c1  * exp( 1i*k1*x ) ...
        + cm1 * exp(-1i*k1*x );

    %% Split-step Fourier method
    E = exp(-1i * k.^2 * dt/2);

    nSave = floor(Nt/saveEvery) + 1;
    Uplot = zeros(nSave, Nx);
    Tplot = zeros(nSave, 1);

    Uplot(1,:) = abs(u);
    Tplot(1)   = 0;

    idx = 1;

    for n = 1:Nt

        % half linear step
        uhat = fft(u);
        uhat = E .* uhat;
        u = ifft(uhat);

        % nonlinear step
        u = u .* exp(2i * abs(u).^2 * dt);

        % half linear step
        uhat = fft(u);
        uhat = E .* uhat;
        u = ifft(uhat);

        % save
        if mod(n, saveEvery) == 0
            idx = idx + 1;
            Uplot(idx,:) = abs(u);
            Tplot(idx)   = n * dt;
        end
    end

    %% 3D surface plot
    [X,T] = meshgrid(x, Tplot);

    figure('Color','w');
    surf(X, T, Uplot, 'EdgeColor', 'none', 'FaceColor', 'interp');
    xlabel('x');
    ylabel('t');
    zlabel('|u(x,t)|');
    title('Focusing NLS: stable Fourier mode (k_1 > 2)');
    view(45, 35);
    axis tight;
    colorbar;
    camlight headlight;
    lighting gouraud;

end