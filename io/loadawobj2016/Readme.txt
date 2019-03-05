
loadawobj.m should load most obj files, although it will ignore any face definitions with more than 6 vertices. The helper file loadawmtl.m will load most material definition files. Once the data is in Matlab, it should be possible to display the data, either with Matlab's patch command, or with the drawaw.m command.

Files in this distribution are
 Readme.txt  html/demoloadaw.pdf
 loadawobj.m loadawmtl.m demoloadaw.m drawaw.m
 icosahedron.obj
 obj/cow.mtl obj/cow.obj obj/cube2.obj obj/plane.mtl
 obj/plane.obj obj/diamond.obj
 obj/trumpet.obj

trumpet.obj is an example of an obj file that only partially loads since some face definitions have more than 6 sizes.

The obj files are believed to be in the public domain, please let me know if this is not the case and I will remove them from the archive. Most of the obj files were downloaded from
http://people.sc.fsu.edu/~jburkardt/data/obj/obj.html

Note that Matlab cannot display surface textures on triangular patches so 
until this is rectified it will not be possible to texturemap from an image onto the model. It may be possible to average vertex data from the tc's and use the interp facility in shading. It may also be possible to use the surface command to texture map onto quadrilaterals if anyone is up for the challenge.
