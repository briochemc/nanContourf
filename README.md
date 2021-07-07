# nanContourf

A GitHub version of nanContourf on MATLAB Central

Example with peaks

```matlab
% start from peaks, cropped for asymmetry
z = peaks ;
z(end,:) = [] ;

% some coordinate system 
x = sin(linspace(-1,1,size(z,2))) ;
y = log(linspace(1,3,size(z,1))) ;

% create some nan islands and lakes
iznan = find(flipud(sin(z))>.5) ;
z(iznan) = nan ;

% usual contourf
subplot(2,1,1)
contourf(x,y,z)
title('usual contourf')

% nanContourf (needs border coordinates)
% so I create some around x and y 
subplot(2,1,2)
xb = (x(2:end)+x(1:end-1))/2 ;
xb = [2*x(1)-xb(1) xb 2*x(end)-xb(end)] ;
yb = (y(2:end)+y(1:end-1))/2 ;
yb = [2*y(1)-yb(1) yb 2*y(end)-yb(end)] ;
nanContourf(xb,yb,x,y,z)
title('nanContourf')
```


Example use for AO users:

```matlab
figure(1)
TRACER = (cosd(ao.LAT) + sind(ao.LON) + cosd(ao.DEPTH / 100)) ;
TRACER(find(~ao.OCN)) = nan ;
TRACER_Slice = squeeze(TRACER(:,100,:)) ;
contourf(ao.lat, ao.depth, TRACER_Slice')
set(gca,'YDir','reverse')


figure(2)
z = ao.depth ;
zb = [0 cumsum(ao.height)] ;
y = ao.lat ;
dy = y(2) - y(1) ;
yb = [y(1) - dy/2    y + dy/2] ;
nanContourf(yb, zb, y, z, TRACER_Slice') ;
set(gca, 'YDir', 'reverse')
```