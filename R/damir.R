drv <- dbDriver("PostgreSQL") # on précise le driver
con <- dbConnect(drv, dbname="damir", host = "192.168.1.200", user = "hackdds", password = "hackdds")
dbListTables(con)
#requete <- dbGetQuery(con, "SELECT * FROM r_201411 WHERE asu_nat = '1' AND exe_spe1 = '11' ;")
#requete <- dbGetQuery(con, "SELECT * FROM r_201411 WHERE asu_nat = '1' AND exe_spe1 = '11' AND (prs_nat = '1111' OR prs_nat = '1211') ;")
#test <- dbGetQuery(con, "SELECT cpam, SUM(act_dnb) as nb_actes FROM r_201411 WHERE asu_nat = '1' AND exe_spe1 = '11' AND (prs_nat = '1111' OR prs_nat = '1211') GROUP BY cpam;")

cpam <- dbGetQuery(con, "SELECT * FROM cpam ;")
damir <- dbGetQuery(con, "SELECT sns_date, cpam, SUM(act_dnb) as nb_actes FROM r_full WHERE asu_nat = '1' AND exe_spe1 = '11' AND (prs_nat = '1111' OR prs_nat = '1211') GROUP BY cpam, sns_date ORDER BY sns_date ;")
damir2 <- merge(damir, cpam, by = "cpam")
damir2$year <- as.numeric(substr(x = damir2$sns_date, start = 1, stop = 4))

damir2013 <- damir2 %>% 
  group_by(year, l_dpt) %>% 
  filter(year == 2013) %>%
  summarise(nb_actes = sum(nb_actes))

damir2013$codep <- sub(pattern = "([[:digit:]AB]{2,3})\\-.*", replacement = "\\1", x = damir2013$l_dpt)
damir2013$codep[damir2013$codep == "5-Nord"] <- "59"

save(cpam, damir, damir2, damir2013, file = "data/damir.Rda")

dbDisconnect(con)
dbUnloadDriver(drv)

