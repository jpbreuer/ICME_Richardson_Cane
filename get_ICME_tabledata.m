clear all
close all
%% Import Data
url_string = ('http://www.srl.caltech.edu/ACE/ASC/DATA/level3/icmetable2.htm');
nr_table = 1;

ICME_tabledata = getTableFromWeb_mod(url_string,nr_table);
save('ICME_tabledata.mat','ICME_tabledata');

%% Remove irrelevant data
first_col = ICME_tabledata(:,1);

% define function
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

% get and remove indexes
index = cellfun(cellfind('Disturbance MM/DD (UT) (a)'),first_col);
index = find(index == 1);
[ICME_tabledata_new PS] = removerows(ICME_tabledata,index);
first_col = ICME_tabledata_new(:,1);

% idx = find(strcmp([first_col{:}],'Disturbance'));
% index = strfind(first_col,'Disturbance MM/DD (UT) (a)');
    
% index_array = table2array(index);

% for i = 1:length(index)
%     idx(i) = find(index_array(i) == 1);
% end

%% Correct dates
first_col = ICME_tabledata_new(:,1);
year_NAN = str2double(first_col);
yearidx = find(year_NAN > 1);
[ICME_tabledata_new PS] = removerows(ICME_tabledata_new,yearidx);
first_col = ICME_tabledata_new(:,1);


% for i = 1:length(first_col)
%     first_col_length(i) = length(first_col(i));
% end

% index = find(first_col_length == 4); 
% index = find(length(first_col) == 4);


% timevec = datetime_JP(first_col);