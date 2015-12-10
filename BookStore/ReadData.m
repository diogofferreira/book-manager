function [Book_Titles,Book_Ratings,Book_Users] = ReadData()
    wb=waitbar(0,'Reading Data ...');
    Book_Titles = readtable('BX-Books.csv','Delimiter',';','Format','%q %q %*q %*q %*q %*q %*q %*q');
    wb=waitbar(1/3,wb);
    Book_Ratings = readtable('BX-Book-Ratings.csv','Delimiter',';','Format','%q %q %q');
    Book_Users = readtable('BX-Users.csv','Delimiter',';','Format','%q %q %*q');
    wb=waitbar(2/3,wb);
    Book_Titles = table2cell(Book_Titles);
    Book_Ratings = table2cell(Book_Ratings);
    rating_values=['0','1','2','3','4'];
    for i=1:length(rating_values)
        Book_Ratings(find(ismember(Book_Ratings(:,3),rating_values(i))),:)=[];
    end
    Book_Users = table2cell(Book_Users); 
    wb=waitbar(1/3,wb);
    close(wb);
end

