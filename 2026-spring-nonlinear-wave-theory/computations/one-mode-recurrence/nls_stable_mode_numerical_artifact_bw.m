function nls_stable_mode_numerical_artifact_bw()

    clear; clc; close all;

    %% Stable regime: k1 > 2
    L = 2.0;              % k1 = 2*pi/L = pi > 2
    eps0 = 1e-4;

    c1  = 1/2;
    cm1 = (0.3 - 0.4i)/2;

    %% Deliberately less conservative numerics
    Nx   = 256;           % coarser grid
    Tmax = 250;           % long time to accumulate numerical error
    Nt   = 20000;         % larger dt than a high-accuracy run
    dt   = Tmax / Nt;

    saveEvery = 20;

    %% Spatial grid
    x = linspace(-L/2, L/2, Nx+1);
    x(end) = [];

    %% Fourier wave numbers
    k = (2*pi/L) * [0:Nx/2-1, -Nx/2:-1];

    %% Initial condition: stable periodic mode
    k1 = 2*pi/L;
    u = 1 + eps0 * ( ...
            c1  * exp( 1i*k1*x ) + ...
            cm1 * exp(-1i*k1*x ) );

    %% Strang splitting propagator
    E = exp(-1i * (k.^2) * dt/2);

    %% Storage
    nSave = floor(Nt/saveEvery) + 1;
    Uplot = zeros(nSave, Nx);
    Tplot = zeros(nSave, 1);

    Uplot(1,:) = abs(u);
    Tplot(1)   = 0;

    idx = 1;

    %% Time stepping
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

        % Save
        if mod(n, saveEvery) == 0
            idx = idx + 1;
            Uplot(idx,:) = abs(u);
            Tplot(idx)   = n * dt;
        end
    end

    %% 3D black-and-white surface plot
    [X,T] = meshgrid(x, Tplot);

    figure('Color','w');
    surf(X, T, Uplot, ...
        'EdgeColor','none', ...
        'FaceColor','interp');

    colormap(gray);
    shading interp;

    xlabel('x','FontSize',13);
    ylabel('t','FontSize',13);
    zlabel('|u(x,t)|','FontSize',13);
    title('Stable mode k_1 > 2: numerical drift/artifact may appear');
    view(45,35);
    axis tight;
    colorbar;

end