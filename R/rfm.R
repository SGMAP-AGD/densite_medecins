
rev <- loadWorkbook("data/revenu_departement_insee_2011.xlsx")
getSheets(rev)
rfm <- readWorksheet(rev, sheet = "Feuil1", region = "A7:D105")
