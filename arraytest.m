A  = rand(10,1);
header1 = 'Eye State';
fid=fopen('EyeState.txt','w');
fprintf(fid, [ header1 '\n']);
fprintf(fid, '%f %f \n', [A]');
fclose(fid);