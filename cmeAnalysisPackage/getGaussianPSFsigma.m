%[sigma] = getGaussianPSFsigma(NA, M, pixelSize, lambda) returns the s.d. of the Gaussian PSF approximation
%
% Inputs     NA        : numerical aperture of the objective
%            M         : magnification of the objective
%            pixelSize : physical pixel size of the CCD in [m]
%            lambda    : emission maximum wavelength of the fluorophore in [m]
%                        -or- fluorophore name (see getFluorPropStruct.m)
%          {'Display'} : Display PSF and its Gaussian approximation. Optional, default: false.
%
% Ouputs
%                sigma : standard deviation of the Gaussian PSF approximation, in pixels

% Francois Aguet, October 2010 (last modified 05/28/2013)

function sigma = getGaussianPSFsigma(NA, M, pixelSize, lambda, varargin)

if isnumeric(lambda)
    lambda = num2cell(lambda);
end
if ischar(lambda)
    lambda = {lambda};
end

ip = inputParser;
ip.CaseSensitive = false;
ip.addRequired('NA', @isscalar);
ip.addRequired('M', @isscalar);
ip.addRequired('pixelSize', @isscalar);
ip.addRequired('lambda', @(x) all(cellfun(@(i) ischar(i) || isscalar(i),x)));
ip.addParamValue('Display', false, @islogical);
ip.parse(NA, M, pixelSize, lambda, varargin{:});

idx = find(cellfun(@ischar, lambda));
for i = idx
    lambda{i} = name2wavelength(lambda(i));
end

% Defaults use values corresponding to optimal imaging conditions
p.ti0 = 0; % working distance has no effect under ideal conditions
p.ni0 = 1.518;
p.ni = 1.518;
p.tg0 = 0.15e-3;
p.tg = 0.15e-3;
p.ng0 = 1.515;
p.ng = 1.515;
p.ns = 1.33;
p.lambda = [];
p.M = M;
p.NA = NA;
p.pixelSize = pixelSize;
p.sf = 1;
p.mode = 1;

ru = 8;
nl = numel(lambda);
sigma = zeros(1,nl);
for i = 1:nl
    p.lambda = lambda{i};
    psf = vectorialPSF([0 0 0], 0, (2*ru)-1, p);
    [pG, ~, ~, res] = fitGaussian2D(psf, [0 0 max(psf(:)) 1 0], 'As');
    sigma(i) = pG(4);
    
    % Display
    if ip.Results.Display
        xa = (-ru+1:ru-1)*p.pixelSize/p.M*1e9;
        
        figure;
        subplot(1,2,1);
        imagesc(xa,xa,psf); colormap(gray(256)); axis image; colorbar;
        title('PSF');
        xlabel('x [nm]');
        ylabel('y [nm]');
        
        subplot(1,2,2);
        imagesc(xa,xa, psf+res.data); colormap(gray(256)); axis image; colorbar;
        title('Gaussian approximation');
        xlabel('x [nm]');
        ylabel('y [nm]');
        linkaxes;
    end
end
