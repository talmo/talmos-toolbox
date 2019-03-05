% MIRTGUI_SETDEFAULTOPTIONS Set the default option values.
%
% Copyright (C) 2007 Andriy Myronenko (myron@csee.ogi.edu)
%
%     This file is part of the Medical Image Registration Toolkit (MIRT) package.
%
%     The source code is provided under the terms of the GNU General Public License as published by
%     the Free Software Foundation version 2 of the License.
% 
%     MIRT package is distributed in the hope that it will be useful,
%     but WITHOUT ANY WARRANTY; without even the implied warranty of
%     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%     GNU General Public License for more details.
% 
%     You should have received a copy of the GNU General Public License
%     along with CPD package; if not, write to the Free Software
%     Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA


function [prepro, meshopt, transopt]=mirtgui_setdefaultoptions

%%%%%%%%%% Preprocessing options %%%%%%%%%%%%%%%%%%%%%

% Wiener, Gauss filtering options
prepro.wiener=13; % window size
prepro.gauss=[13 3]; % window size and std

%%%%%% Non-Rigid Mesh Registration Options %%%%%%%%%%%%%%%%%%

% (put all in a sigle array, see describtions below)
% 1) wesh size
% 2) similarity (1-RC)
% 3) number of subdivide levels
% 4) lambda (regularization weight)
% 5) maxsteps (number of iterations for a single image)
% 6) fundif (tolerance for a single image)
% 7) gamma (optimization step size)
% 8) anneal (annealing rate for the gamma)
% 9) imfundif (tolerance for the group image)
% 10) maxcycle (overall number of iterations)
% 11) group mode (1-alltomean,2-alltofirst, 3-nexttoprevious, 4-nexttomovingaverage)
% 12) alpha parameter (e.g. RC alpha)
%
meshopt=[16 1 2 0.03 500 0.00001 1 0.8 0.000001 40 3 0.03];


%%%%%%% Translation Registration Options %%%%%%%%%%%%%%%%%%%%% 

% 1) neighbors=2; 
% 2) image resize =2;
% 3) method=1; 

transopt=[2 4 1];
