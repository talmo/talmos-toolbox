function mepstart()
%MEPSTART Starts up MATLAB Editor Plugin.
% Usage:
%   mepstart
% 
% Ref: https://github.com/GavriYashar/Matlab-Editor-Plugin/wiki/Setup
%
% See also: ttstartup, meppaths, javapaths

% Check that the JAR files are in the Java path
jcp = javaclasspath('-all');
mepPaths = meppaths();
inJavaPath = sum(contains(jcp,mepPaths)) == numel(mepPaths);

% Add to dynamic path (doesn't save)
if ~inJavaPath
    for i = 1:numel(mepPaths)
        javaaddpath(mepPaths{i},'-end');
    end
    printf('Added MEP to Java dynamic class path.')
end

mepbasePath = funpath(true);
customPropsPath = ff(mepbasePath,'CustomProps.properties');
defaultPropsPath = ff(mepbasePath,'DefaultProps.properties');

% Start
at.mep.Start.start(customPropsPath, defaultPropsPath);
printf('Started MATLAB Editor Plugin.')

end
