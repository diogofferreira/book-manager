function [Set,users]=usersMovies(file)
udata=load(file);  % loads data from movies file

u= udata(1:end,1:2); clear udata;

users = unique(u(:,1)); % Keeps Users ID's
Nu = length(users);     

Set=cell(Nu,1); 

% For each user saves the movies he rated 
for n = 1:Nu,  
    ind = find(u(:,1) == users(n));
    Set{n} = [Set{n} u(ind,2)];
end
end