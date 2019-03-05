function initialize_mep()
%INITIALIZE_MEP Initializes Matlab-Editor-Plugin.
% Ref: https://github.com/GavriYashar/Matlab-Editor-Plugin/wiki/Setup

mep_path = ff(ttbasepath(),'utilities','Matlab-Editor-Plugin');

at.mep.Start.start(ff(mep_path,'CustomProps.properties'), ...
                   ff(mep_path,'DefaultProps.properties'));

end

