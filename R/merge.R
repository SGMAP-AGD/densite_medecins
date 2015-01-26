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
sum(damir2013_2$effectifs) / sum(damir2013_2$pop_affiliee) 

png("output/nb_consultations_densite_medecins.png", width = 840, height = 680)
ggplot(damir2013_2, aes(x = densite_medecins, y = acte_affilies)) + 
  geom_point(color = "red") + 
  geom_text(aes(label = codep), color = "black") + 
  geom_hline(yintercept = sum(damir2013_2$nb_actes) / sum(damir2013_2$pop_affiliee), color = "grey", linetype = "dashed") + 
  geom_vline(xintercept = 10^5 * sum(damir2013_2$effectifs) / sum(damir2013_2$pop_affiliee), color = "grey", linetype = "dashed") + 
  theme_blaquans() +
  labs(title = "Nombre de consultations par affilié et densité de médecins") + 
  ylab("Nombre d'actes annuels par affilié") + 
  xlab("Nombre de médecins pour 100 000 affiliés")
dev.off()


damir2013_2 %>% lm(formula = acte_affilies ~ densite_medecins) %>% summary()

damir2013_2 %>% lm(formula = acte_affilies ~ densite_medecins) %>% summary()

write.table(damir2013_2, "data/damir2013_2.csv", row.names = FALSE, sep = ";", dec = ",")


damir2013_3 <- merge(damir2013_2, sgpp2013, by = "codep")

names(damir2013_3)
damir2013_3 %>% lm(formula = acte_affilies ~ densite_medecins + sh0_à_4_ans + sh10_à_14_ans + sh15_à_19_ans + sh20_à_24_ans + sh30_à_34_ans + sh35_à_39_ans + sh40_à_44_ans + sh45_à_49_ans + sh5_à_9_ans + sh50_à_54_ans + sh55_à_59_ans + sh60_à_64_ans + sh65_à_69_ans + sh70_à_74_ans + sh75_à_79_ans + sh80_à_84_ans + sh85_à_89_ans + sh90_ans_et_plus) %>% 
  summary()

damir2013_4 <- merge(damir2013_3, rfm, by.x = "codep", by.y = "CODGEO")

damir2013_4 %>% lm(formula = acte_affilies ~ densite_medecins + sh0_à_4_ans + sh10_à_14_ans + sh15_à_19_ans + sh20_à_24_ans + sh30_à_34_ans + sh35_à_39_ans + sh40_à_44_ans + sh45_à_49_ans + sh5_à_9_ans + sh50_à_54_ans + sh55_à_59_ans + sh60_à_64_ans + sh65_à_69_ans + sh70_à_74_ans + sh75_à_79_ans + sh80_à_84_ans + sh85_à_89_ans + sh90_ans_et_plus + MENIMP11 + QUAR2UC11) %>% 
  summary()


damir2013_4 %>% lm(formula = acte_affilies ~ densite_medecins + MENIMP11 + QUAR2UC11) %>% 
  summary()



# gpp2013_2 %>% 
#   filter(sexe == "total", catage == "Total") %>% 
#   select(codep, n) %>% 
#   plyr::rename(replace = c("n" = "pop_affiliee"))
# 
