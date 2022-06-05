function []=export_model_to_eclipse(M,m_eclipse)

%% export model to eclipse
count=0;
for i=1:numel(M)
    if str2double(M{i})>0
        count=count+1;
        M{i}=num2str(m_eclipse(count,1));
    end
end

% Write cell M into file
fid = fopen('C:\Users\Mohammad\Desktop\PUNQ\PUNQS3.PRP', 'w'); % :'w' for write into  file
for i = 1:numel(M)
    if M{i+1} == -1 % ending of lines in file (last row in M) % write at same line
        fprintf(fid,'%s', M{i});
        break
    else
        fprintf(fid,'%s\n', M{i}); % write at next line
    end
end