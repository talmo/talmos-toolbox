# expandaxes
More reliable implementation of the Matlab option "expand axes to fill figure"
More reliable implementation of the option "expand axes to fill figure" in the Export Setup... settings. Works with multiple subplots and usually does not distort objects such as colorbars.
This function attempts to automatically remove white space in figures by expanding the axes objects to fill the figure. The available option in the "export setup" figure menu sometimes distorts the axes and often does not work at all if there is more than one axes or a colorbar. The common fix is to manually change the position of each axes, which can be a tedious process. This function attempts to automate the process while keeping the syntax as simple as possible. It automatically removes the white space of most figures with multiple subplots, superimpozed axes objects and colorbars without distorting the axes.
#

Syntax:
       expandaxes(h)
       expandaxes(h, fHor, fVer) - For manual adjustment of the distance
                                  between subplots
Input arguments:
       - h:    Figure handle
       - fHor: Factor for the distance between subplots in horizontal direction
               (Default: 1)
       - fVer: Factor for the distance between subplots in vertical direction
               (Default: 1)
Hints:
   a)  General rule of thumb for the order of execution when calling expandaxes:
          1) Set objects, FontSizes, etc.
          2) Call expandaxes
          3) Other manipulations of axes and colorbar positions
   b)  By setting
          h.SizeChangedFcn = 'expandaxes(gcf, fHor, fVer);';
       this function can be called with exery resize of the figure h.
