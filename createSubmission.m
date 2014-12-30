function createSubmission(filename,datesData,count)

fid = fopen(filename, 'w') ;
fprintf(fid, '%s,', 'datetime') ;
fprintf(fid, '%s\n', 'count') ;

N = numel(datesData);

for i=1:N 
    fprintf(fid, '%s,', datesData{i});
    fprintf(fid, '%i\n', count(i));
end

fclose(fid);