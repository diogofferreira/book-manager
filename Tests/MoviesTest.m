[Set,users] = usersMovies('u.data');
J = calcDistancesJ(Set);
SimilarUsers = findSimilar(J,0.4,users);