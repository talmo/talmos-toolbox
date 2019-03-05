function open_functional_programming_examples()
% Path to the examples page
html_path = fullfile(funpath(true), 'html', 'functional_programming_examples.html');

% Publish the examples page if it does not exist
if ~exists(html_path)
    disp('Publishing examples...')
    html_path = publish('functional_programming_examples.m');
end

% Open the published examples page in a web browser
open(html_path)
end