# Forecasting Crime in Portland
# ** Convert crimes .dbf to .csv **
# Michael Chirico, Seth Flaxman,
# Charles Loeffler, Pau Pereira
library(data.table)
library(foreign)
library(zoo)
library(sp)
library(rgeos)
library(maptools)

crimes = rbindlist(lapply(list.files(
  "./data", pattern = "^NIJ.*\\.dbf", full.names = TRUE),
  #as.is = TRUE is equivalent to stringsAsFactors = FALSE;
  #  also, some missing data snuck in on one line
  read.dbf, as.is = TRUE))[!is.na(occ_date)]

#number of weeks before March 1, 2017
crimes[ , week_no := unclass(as.IDate("2017-02-28") - 
                               as.IDate(occ_date)) %/% 7L + 1L]

# number of months before March 2017
crimes[, month_no := round((as.yearmon("2017-03-01") - as.yearmon(occ_date))*12)]

# day of the month
crimes[ , day_mo := mday(occ_date)]

# year
crimes[ , occ_year := year(occ_date)]

crimes[ , day_no := difftime(as.IDate('2017-03-01'), occ_date, units='days')]

# numerate forecasting period years
#  (sounds weird but it's useful to compute
#  the AR kdes. This way we can group by 
#  lag number and period to compute a given
#  kde lag)
crimes[occ_date %between% c('2017-03-01', '2018-02-28'), fyear := 2018]
crimes[occ_date %between% c('2016-03-01', '2017-02-28'), fyear := 2017]
crimes[occ_date %between% c('2015-03-01', '2016-02-29'), fyear := 2016]
crimes[occ_date %between% c('2014-03-01', '2015-02-28'), fyear := 2015]
crimes[occ_date %between% c('2013-03-01', '2014-02-28'), fyear := 2014]
crimes[occ_date %between% c('2012-03-01', '2013-02-28'), fyear := 2013]

# ============================================================================
# REMOVE POINTS OUTSIDE BORDERS
# ============================================================================
# create Spatial Points Data Frame
prj = CRS(prjs <- "+init=epsg:2913")
crimes.sp = SpatialPoints(
  coords = crimes[ , cbind(x_coordina, y_coordina)],
  proj4string = prj
)

# load portland boundary
police_districts = 
  readShapePoly('data/Portland_Police_Districts', 
                proj4string = prj)

portland = gUnaryUnion(gBuffer(
  #buffer to eliminate sand grain holes
  #  (1e6 by trial and elimination)
  police_districts, width = 1e6*.Machine$double.eps
))

#eliminate island sub-polygons, see
#  http://gis.stackexchange.com/questions/229232/
subP = portland@polygons[[1L]]@Polygons
areas = sapply(subP, slot, 'area')
keep = sapply(subP, function(p) p@hole || p@area == max(areas))
portland = SpatialPolygons(list(Polygons(subP[keep], ID = 1)),
                           proj4string = prj)

# select crimes within city boundaries
idx = over(crimes.sp, portland)
crimes = crimes[!is.na(idx)]

# eliminate & economize columns to save space
cg_lev = c('DISORDER', 'NON CRIMINAL/ADMIN', 'PROPERTY CRIME')
crimes[ , call_group_type := 
          factor(CALL_GROUP, levels = cg_lev)]
crimes[is.na(call_group_type), 
       call_group_type := factor('other')]
levels(crimes$call_group_type) = c('other', cg_lev)
crimes[ , call_group_type := 
          as.integer(call_group_type)]

crimes[grepl('COLD', CASE_DESC, fixed = TRUE), 
       case_desc_type := 1L]
crimes[grepl('PRIORITY[^*]*$', CASE_DESC),
       case_desc_type := 2L]
crimes[grepl('PRIORITY.*[*]', CASE_DESC),
       case_desc_type := 3L]
crimes[is.na(case_desc_type),
       case_desc_type := 0L]

crimes[ , c('CALL_GROUP', 'final_case',
            'CASE_DESC', 'census_tra') := NULL]

fwrite(crimes[ , !'CATEGORY'], "crimes_all.csv")
crimes.split = split(crimes, by = "CATEGORY", keep.by = FALSE)
fwrite(crimes.split[["STREET CRIMES"]], "crimes_str.csv")
fwrite(crimes.split[["BURGLARY"]], "crimes_bur.csv")
fwrite(crimes.split[["MOTOR VEHICLE THEFT"]], "crimes_veh.csv")
