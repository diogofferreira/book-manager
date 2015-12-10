function [Set,users]=usersBooks(ratings)
    % Lista de utilizadores
    users = unique(ratings(:,1));     % Extrai os IDs dos utilizadores
    users = users(1:1000);
    Nu = length(users);          % Numero de utilizadores

    % Constroi a lista de filmes para cada utilizador
    Set=cell(Nu,1);            % Usa celulas
    
    wb=waitbar(0,'Processing Data ...');
    for n = 1:Nu,  % Para cada utilizador % Obtem os filmes de cada um
        ind = find(ismember(ratings(:,1),users{n}));
        waitbar((n/Nu),wb);
        % E guarda num array. Usa celulas porque utilizador tem um numero
        % diferente de filmes. Se fossem iguais podia ser um array
        Set{n} = [Set{n} ratings(ind,2)];
    end
    close(wb);
end