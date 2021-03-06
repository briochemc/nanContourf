
function h = nanContourf(xb, yb, x, y, z, varargin)
%
% h = nanContourf(xb, yb, x, y, z)
%
% requires inpaint_nans.m (google it or MATLAB Central)
%
% Plots an extrapolated contourf of your (x,y,z), and uses
% xb and yb (the boundaries of the boxes of your map)
% to fill in the nans. Among other things,
% this function eventually calls
%
% h = contourf(x, y, z)
%
% and you should be able to pass usual contourf arguments too,
% as in, e.g.:
%
% h = nanContourf(xb, yb, x, y, z, levels)
%
% The handle returned by nanContourf is that of the inner call
% to contourf.
%
% Default linestyle around nans is 'none' (prettier IMHO).
% Default fill-color for nans is gray (rgb = .8*[1 1 1]).
%
% ---
%
% Example use
%
% z = peaks ;
% z(end,:) = [] ;
%
% % some coordinate system
% x = sin(linspace(-1,1,size(z,2))) ;
% y = log(linspace(1,3,size(z,1))) ;
%
% % create some nan islands and lakes
% iznan = find(flipud(sin(z))>.5) ;
% z(iznan) = nan ;
%
% % usual contourf
% subplot(2,1,1)
% contourf(x,y,z)
% title('usual contourf')
%
% % nanContourf (needs border coordinates)
% % so I create some around x and y
% subplot(2,1,2)
% xb = (x(2:end)+x(1:end-1))/2 ;
% xb = [2*x(1)-xb(1) xb 2*x(end)-xb(end)] ;
% yb = (y(2:end)+y(1:end-1))/2 ;
% yb = [2*y(1)-yb(1) yb 2*y(end)-yb(end)] ;
% nanContourf(xb,yb,x,y,z)
% title('nanContourf')

% filling the nans with inpaint_nans to prevent the contour
% lines from stopping before the borders around the nans.
z_ext = inpaint_nans(z) ;
h = contourf(x,y,z_ext,varargin{:},'linestyle','none') ;
hold on
% black and white z for filling nans with gray color
z_bw = zeros(size(z)) ;
z_bw(find(isnan(z))) = 1 ;
% gray color to fill the nans ; can be changed
gray = .8 * [1 1 1] ;
% filling nans
[jjCC,iiCC] = find(z_bw) ;
for j=1:length(iiCC)
  xfill = [xb(iiCC(j)) xb(iiCC(j)+1) xb(iiCC(j)+1) xb(iiCC(j)) xb(iiCC(j))];
  yfill = [yb(jjCC(j)) yb(jjCC(j)) yb(jjCC(j)+1) yb(jjCC(j)+1) yb(jjCC(j))];
  hnans = fill(xfill,yfill, gray, 'linestyle','none');
  set(hnans,'facealpha',1)
end

% drawing the coast for 'wasd' (as in directions) facing coasts
% a = west
z_bw_a = [z_bw(:,2:end) zeros(size(z_bw,1),1)] ;
ab = z_bw_a & ~z_bw ;
[jj,ii] = find(ab) ;
for i = 1:length(ii)
  plot(xb(ii(i) + [1 1]), yb(jj(i) + [0 1]),'k')
end
% d = east
z_bw_d = [zeros(size(z_bw,1),1) z_bw(:,1:end-1)] ;
db = z_bw_d & ~z_bw ;
[jj,ii] = find(db) ;
for i = 1:length(ii)
  plot(xb(ii(i) + [0 0]), yb(jj(i) + [0 1]),'k')
end
% w = north
z_bw_w = [z_bw(2:end,:); zeros(1,size(z_bw,2))] ;
wb = z_bw_w & ~z_bw ;
[jj,ii] = find(wb) ;
for i = 1:length(ii)
  plot(xb(ii(i) + [0 1]), yb(jj(i) + [1 1]),'k')
end
% s = south
z_bw_s = [zeros(1,size(z_bw,2)); z_bw(1:end-1,:)] ;
sb = z_bw_s & ~z_bw ;
[jj,ii] = find(sb) ;
for i = 1:length(ii)
  plot(xb(ii(i) + [0 1]), yb(jj(i) + [0 0]),'k')
end
end
