function output = latexit(input, copyToClipboard)



output = [];



if nargin == 1

copyToClipboard = true;

elseif ~islogical(copyToClipboard)

warning('Second argument should be logical. Assuming value is false');

copyToClipboard = false;

end



if isa(input, 'sym')

% Symbolic object

output = latex(input);

else

% Another type of object

try

output = latex(sym(input));

catch

error('Could not process input. Try converting object to a symbolic form manually and then reprocess');

end

end



if copyToClipboard

clipboard('copy', output);

end
