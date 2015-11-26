set_nomes = {'Filipa';'Leticia';'Ana';'Rita'};
set_test = {'Diogo';'leticia';'ola';'Ana'};
n=10;
k=3;

%% Initialize Filter

bloom_filter = initialize(n);
L=length(set_nomes);

%% Insert 

for i=1:L
  bloom_filter=insert(bloom_filter,set_nomes{i},k);
endfor

%% Exists?

for i=1:length(set_test)
  fprintf(" %s is Member? %g \n",set_test{i},isMember(bloom_filter,set_test{i},k));
endfor

for i=1:length(set_nomes)
  fprintf(" %s is Member? %g \n",set_nomes{i},isMember(bloom_filter,set_nomes{i},k));
endfor
