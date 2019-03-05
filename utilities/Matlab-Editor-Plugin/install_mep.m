function install_mep()
%INSTALL_MEP Adds Matlab-Editor-Plugin dependencies to the java class path.
% Ref: https://github.com/GavriYashar/Matlab-Editor-Plugin/wiki/Setup

% mep_path = ff(ttbasepath(),'utilities','Matlab-Editor-Plugin');
% javaaddpath(ff(mep_path,'*.jar'))
% % javaaddpath(ff(mep_path,'matconsolectl-4.4.2.jar'))
% % javaaddpath(ff(mep_path,'MEP_1.12.jar'))
% at.mep.Start.start(ff(mep_path,'CustomProps.properties'), ...
%                    ff(mep_path,'DefaultProps.properties'));

mep_path = ff(ttbasepath(),'utilities','Matlab-Editor-Plugin');
mcc_path = ff(mep_path,'matconsolectl-4.4.2.jar');
mepjar_path = ff(mep_path,'MEP_1.12.jar');

javastatic = javaclasspath('-static');
reqs = {mcc_path, mepjar_path};
if ~all(contains(reqs,javastatic))
    f = fopen(ff(prefdir(),'javaclasspath.txt'),'at+');
    fwrite(f,strjoin(reqs,'\n'));
    fclose(f);
    printf('Added Matlab-Editor-Plugin dependencies to the static path.')
end


end

