# Installer les packages nécessaires si absents
to_install <- c("tidyverse", "showtext")
new_packages <- to_install[!(to_install %in% installed.packages()[,"Package"])]
if(length(new_packages)) install.packages(new_packages)

# Charger les bibliothèques nécessaires
library(tidyverse)
library(showtext)

# Ajouter une police Google et configurer showtext
font_add_google("Libre Franklin", "franklin")
showtext_auto()
showtext_opts(dpi = 300)

# Exemple de données
vaccines <- c("DTP, DTaP, or DT", "MMR", "Polio")

cdc_data <- read_csv("Vaccination_Coverage_and_Exemptions_among_Kindergartners_20250118.csv") %>%
  filter(Geography == "United States") %>%
  select(vaccine = "Vaccine/Exemption", school_year = "School Year", estimate = "Estimate (%)") %>%
  filter(vaccine %in% vaccines & school_year != "2009-10" & school_year != "2010-11") %>%
  mutate(estimate = as.numeric(estimate), year = as.numeric(str_replace(school_year, "-..", "")))

cdc_label <- tribble(~label, ~year, ~estimate, ~vaccine,
                     "Whooping\ncough", 2023.25, 92.15, "DTP, DTaP, or DT",
                     "Measles", 2023.25, 93.1, "MMR",
                     "Polio", 2023.25, 92.6, "Polio")

cdc_data %>%
  ggplot(aes(x = year, y = estimate, color = vaccine, fill = vaccine, group = vaccine)) +
  geom_hline(yintercept = 95, color = "black") +
  geom_line(linewidth = 1, show.legend = FALSE) +
  annotate(geom = "segment", x = c(2023.2, 2023), xend = c(2023, 2023), y = c(93.1, 93.1), yend = c(93.1, 92.7)) +
  geom_point(size = 3, shape = 21, color = "white", show.legend = FALSE) +
  annotate(geom = "text", hjust = 1, vjust = -0.3, x = 2023.25, y = 95, label = "FEDERAL\nMEASLES TARGET", family = "franklin", lineheight = 0.8) +
  geom_text(data = cdc_label, mapping = aes(x = year, y = estimate, color = vaccine, label = label), hjust = 0, lineheight = 0.8, size = 13, family = "franklin")
