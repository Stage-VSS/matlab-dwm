function make(rebuild)
    if ~ispc
        error('Windows only');
    end

    if nargin < 1
        rebuild = false;
    end

    filePath = mfilename('fullpath');
    projectDir = fileparts(filePath);
    
    currentDir = pwd;
    returnToDir = onCleanup(@()cd(currentDir));
    cd(projectDir);
    
    options = '';
    options = [options ' -ldwmapi'];
    
    sourceFiles = dir(fullfile(projectDir, '*.c'));
    for i = 1:length(sourceFiles)
        source = sourceFiles(i);
        
        [path, name] = fileparts(source.name);
        mexname = [name '.' mexext];
        mexfile = dir(mexname);
        
        if rebuild || isempty(mexfile) || datenum(source.date) > datenum(mexfile.date)
            command = sprintf('mex %s %s', options, source.name);
            disp(command);
            
            try
                eval(command);
            catch
                disp(['Error building ''' source.name '''']);
            end
        else
            disp([source.name ' is up to date']);
        end
    end
end