function C = name2rgb(name)
%NAME2RGB Returns the RGB triple from a short or long name of a fixed color.

colorspec = fixed_colors;

if length(name) == 1
    i = find(strcmpi(name, colorspec.short_names), 1);
else
    i = find(strcmpi(name, colorspec.long_names), 1);
end

if isempty(i)
    error('Name is not one of the fixed colors. See: fixed_colors().')
end

C = colorspec.rgb_triples(i, :);

end

