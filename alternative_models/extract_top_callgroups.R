#Calculate top call groups by crime
#  so this doesn't have to be done on each iteration
#** Alternative Model **
#  Used to create the call group KDE namespace
library(data.table)

fwrite(rbindlist(lapply(
  c(all = "crimes_all.csv", street = "crimes_str.csv",
    burglary = "crimes_bur.csv", vehicle = "crimes_veh.csv"), 
  function(ff) {
    tbl = fread(ff)[ , .N, by = .(cg = call_group_type)][order(-N)]
    tbl[seq_len(min(.N - 1L, 3L))]
  }), idcol = 'crime'),
  'top_callgroups_by_crime.csv')
