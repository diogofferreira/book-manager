function [Set,users]=usersBooks(ratings)

    users = unique(ratings(:,1));     % Users List
    users = users(2000:2500);         % Choose 2000 Users 
    Nu = length(users);               % Users Size
    
    Set=cell(Nu,1);                   % Books by User
    
    wb=waitbar(0,'Processing Data ...');
    
    for n = 1:Nu
        % Get All Books of User{n}
        ind = find(ismember(ratings(:,1),users{n}));
        Set{n} = [Set{n} ratings(ind,2)];
        
        waitbar((n/Nu),wb);
    end
    
    close(wb);
end