load("data/damir.Rda")
load("data/rpps.Rda")
load("data/pp.Rda")

damir2013_1 <- merge(damir2013, rpps2013, by = "codep" )
write.table(damir2013_1, "data/damir2013_1.csv", row.names = FALSE, sep = ";", dec = ",")

gpp2013_tot_tot <- gpp2013_2 %>% 
  filter(sexe == "total", catage == "Total") %>% 
  select(codep, n) %>% 
  plyr::rename(replace = c("n" = "pop_affiliee"))

damir2013_2 <- merge(damir2013_1, gpp2013_tot_tot, by = "codep")

damir2013_2$acte_affilies <- damir2013_2$nb_actes / damir2013_2$pop_affiliee
damir2013_2$densite_medecins <- damir2013_2$effectifs / damir2013_2$pop_affiliee * 10^5

sum(damir2013_2$nb_actes) / sum(damir2013_2$pop_affiliee)
sum(damir2013_2$effectifs) / sum(damir2013_2$pop_affiliee) * 10^5

pdf("output/nb_consultations_densite_medecins.pdf", width = 12, height = 7)
ggplot(damir2013_2, aes(x = densite_medecins, y = acte_affilies)) + 
  geom_point() + 
  geom_text(aes(label = codep), color = "grey") + 
  theme_blaquans() +
  labs(title = "Nombre de consultations par affilié et densité de médecins") + 
  ylab("Nombre d'actes annuels par affilié") + 
  xlab("Nombre de médecins pour 100 000 affiliés")
dev.off()

png("output/nb_consultations_densite_medecins.png", width = 840, height = 680)
ggplot(damir2013_2, aes(x = densite_medecins, y = acte_affilies)) + 
  geom_point(color = "red") + 
  geom_text(aes(label = codep), color = "black") + 
  theme_blaquans() +
  labs(title = "Nombre de consultations par affilié et densité de médecins") + 
  ylab("Nombre d'actes annuels par affilié") + 
  xlab("Nombre de médecins pour 100 000 affiliés")
dev.off()





summary(lm())

write.table(damir2013_2, "data/damir2013_2.csv", row.names = FALSE, sep = ";", dec = ",")


