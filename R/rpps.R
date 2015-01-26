rpps <- read.csv("data/rpps_tab3.csv")

rpps2013 <- rpps %>% 
  filter(specialite == "Généralistes", grepl(pattern = "^[[:digit:]].*", x = zone_inscription), mode_exercice == "Ensemble des modes d'exercice", annee == 2013) 

rpps2013$codep <- sub(pattern = "([[:digit:]AB]{2,3})[[:blank:]]\\-.*", replacement = "\\1", x = as.character(rpps2013$zone_inscription))

save(rpps2013, file = "data/rpps.Rda")
