clear all
close all
%% Import and Save Data (Online)
% url_string = ('http://www.srl.caltech.edu/ACE/ASC/DATA/level3/icmetable2.htm');
% nr_table = 1;

% ICME_tabledata = getTableFromWeb_mod(url_string,nr_table);
% save('ICME_tabledata.mat','ICME_tabledata');
%% Import from Saved Data (Offline)
clear all
load('ICME_tabledata.mat','-mat');
% Remove irrelevant data
first_col = ICME_tabledata(:,1);

% define function
cellfind = @(string)(@(cell_contents)(strcmp(string,cell_contents)));

% get indexes for labels (and remove them)
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
% create a year vector of correct length
first_col = ICME_tabledata_new(:,1);
year_NAN = str2double(first_col);
yearidx = find(year_NAN > 1);
yearstart = year_NAN(yearidx(1));
yearend = year_NAN(yearidx(end));
year_range = yearstart:yearend;

for i = 2:length(yearidx)
    yearidx_diff(i-1) = yearidx(i) - yearidx(i-1);
end
for i = 2:length(yearidx_diff)
    yearidx_last(1) = yearidx_diff(1);
    yearidx_last(i) = yearidx_last(i-1) + yearidx_diff(i);
end

% delete 'year' rows
[ICME_tabledata_new PS] = removerows(ICME_tabledata_new,yearidx);
first_col = ICME_tabledata_new(:,1);

% create year vector based on indexes
for i = 2:length(yearidx)
    year(yearidx(i-1):yearidx(i)-2) = year_range(i-1);
    year(yearidx(end):length(first_col)) = year_range(end);
end

% fill gaps due to some previous logic flaw
for i = 1:length(year_range)-1
    year(yearidx_last(i)) = year_range(i);
end


first_col = ICME_tabledata_new(:,1);
second_col = ICME_tabledata_new(:,2);
third_col = ICME_tabledata_new(:,3);

% check for double spaces
first_col = regexprep(first_col, '\s+', ' ');
second_col = regexprep(second_col, '\s+', ' ');
third_col = regexprep(third_col, '\s+', ' ');

% split columns
first_col_splt = regexp(first_col, '[/ ()]', 'split'); %creating 1by3 and 1by5 cells... fixed later in for loop
second_col_splt = regexp(second_col, '[/ ()]', 'split'); 
third_col_splt = regexp(third_col, '[/ ()]', 'split'); 

first_col_splt = first_col_splt(~cellfun('isempty',first_col_splt));
second_col_splt = second_col_splt(~cellfun('isempty',second_col_splt));
third_col_splt = third_col_splt(~cellfun('isempty',third_col_splt));

% create date-time vectors
first_col_vec = zeros(length(year),6);
second_col_vec = zeros(length(year),6);
third_col_vec = zeros(length(year),6);
for i = 1:length(year)
    first_col_vec(i,1) = year(i);
    first_col_vec(i,2) = str2double(first_col_splt{i}{1});
    first_col_vec(i,3) = str2double(first_col_splt{i}{2});
    first_col_vec(i,4) = str2double(first_col_splt{i}{3}(1:2));
    first_col_vec(i,5) = str2double(first_col_splt{i}{3}(3:4));
end
for i = 1:length(year)
    second_col_vec(i,1) = year(i);
    second_col_vec(i,2) = str2double(second_col_splt{i}{1});
    second_col_vec(i,3) = str2double(second_col_splt{i}{2});
    second_col_vec(i,4) = str2double(second_col_splt{i}{3}(1:2));
    second_col_vec(i,5) = str2double(second_col_splt{i}{3}(3:4));
end
for i = 1:length(year)
    third_col_vec(i,1) = year(i);
    third_col_vec(i,2) = str2double(third_col_splt{i}{1});
    third_col_vec(i,3) = str2double(third_col_splt{i}{2});
    third_col_vec(i,4) = str2double(third_col_splt{i}{3}(1:2));
    third_col_vec(i,5) = str2double(third_col_splt{i}{3}(3:4));
end

% Convert all time vectors to Julian Day
 jdssc_rich = julian_JP(first_col_vec);
 jds_icme = julian_JP(second_col_vec);
 jde_icme = julian_JP(third_col_vec);

% Other date data
for i = 1:length(year)
    if length(first_col_splt{i}) > 3
        date_info_index(i) = 1;
        first_col_splt{i}{5} = []; % assigns empty for 1by5 cells
        second_col_splt{i}{5} = [];
        third_col_splt{i}{5} = [];
        first_col_splt{i} = first_col_splt{i}(~cellfun('isempty',first_col_splt{i})); %removes empty cells
        second_col_splt{i} = second_col_splt{i}(~cellfun('isempty',second_col_splt{i}));
        third_col_splt{i} = third_col_splt{i}(~cellfun('isempty',third_col_splt{i}));
    else
        date_info_index(i) = 0;
    end
end
date_info_index = find(date_info_index > 0);

date_info = zeros(length(year),1);
for i = date_info_index
    if char(first_col_splt{i}(end)) == 'A'
        date_info(i) = 1;
    elseif char(first_col_splt{i}(end)) == 'W'
        date_info(i) = 2;
    elseif char(first_col_splt{i}(end)) == 'S'
        date_info(i) = 3;
    end
end

%%
% for i = 1:length(first_col_splt)
%     for j = 1:length(first_col_splt{i})
%         first_col_splt(i,j) = str2num([first_col_splt{i}{j}]);
%     end
% end
% first_col_split = accumarray(index(:),first_col_splt,[],@(x) {x});
% for i = 1:length(first_col_splt)
%     first_col_splt(i) = cellfun(@str2num,first_col_splt{i});
% end

% first_col_splt = table2array(first_col_splt);

% first_col_splt = cell2mat([first_col_splt{:}]);

% first_col_splt = cell2mat(first_col_splt);
% second_col_splt = str2double(second_col_splt);
% third_col_splt = str2double(third_col_splt);

% for i = 1:length(first_col)
%     first_col_length(i) = length(first_col(i));
% end

% index = find(first_col_length == 4); 
% index = find(length(first_col) == 4);


% timevec = datetime_JP(first_col);