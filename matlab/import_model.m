function [m_eclipse,M]=import_model()

%% import model from eclipse
    % opening  file
    fid = fopen('C:\Users\Mohammad\Desktop\PUNQ\PUNQS3.PRP');% fopen : opening file (model data : 'PUNQS3.PRP' )
  
    % copying 'PUNQS3.PRP' file into a cell
    i = 1;
    tline = fgetl(fid); % fgetl : copying one line from file into  tline (char)
    M{i} = tline; % copying tline into cell M
    while ischar(tline) % ischar : false and true for existing of char (loop end when lines in file are ending)
        i = i+1;
        tline = fgetl(fid);
        M{i} = tline;
    end
    fclose(fid);
    
    % M is string type cell, we convert this cell to double matrix
    count=0;
    for i=1:numel(M)-2
        if i~=1 && i~=2662 && i~=2663 && i~=5324 && i~=5325 
            count=count+1;
            m_eclipse(count,1)=str2double(M{i});
        end
    end