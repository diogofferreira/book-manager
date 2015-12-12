function [Book_Titles,Book_Ratings,Book_Users] = ReadData()
    
    %% Slice Data
    wb=waitbar(0,'Fetching Data ...');
    Book_Titles = table2cell(readtable('BX-Books.csv','Delimiter',';','Format','%q %q %*q %*q %*q %*q %*q %q'));
    wb=waitbar(1/5,wb);
    Book_Ratings = table2cell(readtable('BX-Book-Ratings.csv','Delimiter',';','Format','%q %q %q'));
    wb=waitbar(2/5,wb);
    Book_Users = table2cell(readtable('BX-Users.csv','Delimiter',';','Format','%q %q %*q'));
    wb=waitbar(3/5,wb);
    
    %% Ignoring users with Rating<5
    rating_values=['0','1','2','3','4'];
    wb=waitbar(4/5,wb);
    for i=1:length(rating_values)
        Book_Ratings(find(ismember(Book_Ratings(:,3),rating_values(i))),:)=[];
    end
    wb=waitbar(5/5,wb);
    close(wb);
end

