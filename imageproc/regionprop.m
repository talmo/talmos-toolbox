function stat = regionprop(BW, property)
%REGIONPROP Returns a property for each connected component. Convenience wrapper for regionprops.
% Usage:
%   stat = regionprop(BW, property)
% 
% Args:
%   BW: logical image
%   property: any property accepted by regionprops:
%     'Area'              'EulerNumber'       'Orientation'               
%     'BoundingBox'       'Extent'            'Perimeter'          
%     'Centroid'          'Extrema'           'PixelIdxList' 
%     'ConvexArea'        'FilledArea'        'PixelList'
%     'ConvexHull'        'FilledImage'       'Solidity' 
%     'ConvexImage'       'Image'             'SubarrayIdx'            
%     'Eccentricity'      'MajorAxisLength' 
%     'EquivDiameter'     'MinorAxisLength'                   
%
% Returns:
%   stat: array with specified property for each component
% 
% See also: regionprops, bwconncomp

stat = struct2cell(regionprops(BW, property));
stat = cellcat(stat);

end
