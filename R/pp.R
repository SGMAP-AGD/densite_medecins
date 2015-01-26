# Population protégée

wb <- loadWorkbook("data/RNIAM_RGSLM_JANVIER2013.xls")
getSheets(wb)
pp2013 <- readWorksheet(wb, sheet = "Ensemble RG et SLM", region = "A5:BP113")
gpp2013 <- pp2013 %>% 
  gather(key = categorie, value = n , X0.à.4.ans:Total.2) %>% 
  filter(cpam != "cpam non renseignée (cas particulier de certaines Sections Locales Mutualistes)")

gpp2013$sexe <- ""
gpp2013$sexe[grepl(pattern = "[ls]$", x = gpp2013$categorie)] <- "homme"
gpp2013$sexe[grepl(pattern = "\\.1$", x = gpp2013$categorie)] <- "femme"
gpp2013$sexe[grepl(pattern = "\\.2$", x = gpp2013$categorie)] <- "total"

gpp2013$catage <- sub(pattern = "(.*)[[:blank:]][[:digit:]]$", replacement = "\\1", x = gsub(pattern = "\\.", replacement = " ", x = gsub(pattern = "X", replacement = "", x = gpp2013$categorie)))

# gpp2013 %>% 
#   filter(duplicated(categorie) == FALSE) %>% 
#   select(categorie, catage)

gpp2013$codep <- sub(pattern = "([[:digit:]AB]{2,3})\\-.*", replacement = "\\1", x = gpp2013$l_dpt)
gpp2013$codep[gpp2013$codep == "5-Nord"] <- "59"

gpp2013$cpam <- str_pad(string = gpp2013$cpam, width = 3, side = "left", pad = "0")

gpp2013_1 <- merge(gpp2013, cpam, by = "cpam")

gpp2013_2 <- gpp2013_1 %>% 
  group_by(codep, sexe, catage) %>% 
  summarise(n = sum(n))

save(gpp2013, gpp2013_1, gpp2013_2, file = "data/pp.Rda")
