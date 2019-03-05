================================================
Subpixel Motion Estimation without Interpolation


================================================
This MATLAB package is a supplement to the paper 

S. H. Chan, D. Vo, and T. Q. Nguyen, “Sub-pixel motion estimation without interpolation”, in Proceedings of IEEE Conference on Acoustics, Speech and Signal Processing (ICASSP '10). p. 722-725, 2010.


================================================
Content:


1. Demo.m
	- demonstration file that illustrates the usage of the algorithms


2. FullSearch.m
	[MVy MVx] = FullSearch(Block, img_ref, xc, yc, SearchLimit)
	Input:	Block   - an 8x8 (or other size) patch
		img_ref - reference image
		xc,yc	- coordinate of patch center of Block
		SearchLimit - radius of search window
	Output: MVx, MVy - motion vector fields
	* Search is exhaustive
	

3. LogSearch.m
	[MVy MVx] = LogSearch(Block, img_ref, xc, yc, SearchLimit)
	Input:	Block   - an 8x8 (or other size) patch
		img_ref - reference image
		xc,yc	- coordinate of patch center of Block
		SearchLimit - radius of search window
	Output: MVx, MVy - motion vector fields	
	* Search step is in log scale

4. Motion_Est.m
	Parent procedure for FullSearch.m and LogSearch.m


5. Bidirectional_ME.m
	Parent procedure of Motion_Est.m
	Computes both forward and backward motion vector, and return the larger one.


6. reconstruct.m
	g = reconstruct(img0, MVx, MVy, pel)
	Input:  img0 	 - reference image
		MVx, MVy - motion vector field
		pel      - subpixel accuracy
	Output: g	 - motion compensated image



================================================
COPYRIGHT (C) 2013 Stanley Chan

This program is free software: you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with this program.  If not, see <http://www.gnu.org/licenses/>.



================================================
Last update: November 17, 2013



