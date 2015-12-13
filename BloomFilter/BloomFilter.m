function [bloom_filter] = BloomFilter (len,khash,sett)
  %% Initialize Filter
  bloom_filter=uint8(zeros(1,len));
  
  %% Insert Filter
  wb=waitbar(0,'Inserting ...');
  for i=1:length(sett)
    bloom_filter=insert(bloom_filter,sett{i},khash);
    wb=waitbar((i/length(sett)),wb);
  end
  close(wb);
end
