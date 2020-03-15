library(tidyverse)
library(ggplot2)
library(spotifyr)
library(tidyverse)
library(compmus)

Sys.setenv(SPOTIFY_CLIENT_ID = '29b7536b5f6f4f21a1e9075195a34105')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e5d4ec6492a44dbf808852fb35d36923')

lenny <- 
  get_tidy_audio_analysis('0L3jwveF4FBMhzseOHyDyh')

outof <- 
  get_tidy_audio_analysis('5WMKS1iDfugyLhfibIlR51')

redhouse <- 
  get_tidy_audio_analysis('3Vs6cdkM3qIWItjoiiI5p2')

redhouse %>% 
  tempogram(window_size = 8, hop_size = 1, cyclic = FALSE, bpms=30:150) %>% 
  ggplot(aes(x = time, y = bpm, fill = power)) + 
  geom_raster() + 
  scale_fill_viridis_c(guide = 'none') +
  labs(x = 'Time (s)', y = 'Tempo (BPM)') +
  theme_classic()

lenny %>% 
  tempogram(window_size = 8, hop_size = 1, cyclic = FALSE, bpms=30:150) %>% 
  ggplot(aes(x = time, y = bpm, fill = power)) + 
  geom_raster() + 
  scale_fill_viridis_c(guide = 'none') +
  labs(x = 'Time (s)', y = 'Tempo (BPM)') +
  theme_classic()

outof %>% 
  tempogram(window_size = 8, hop_size = 1, cyclic = FALSE, bpms=30:150) %>% 
  ggplot(aes(x = time, y = bpm, fill = power)) + 
  geom_raster() + 
  scale_fill_viridis_c(guide = 'none') +
  labs(x = 'Time (s)', y = 'Tempo (BPM)') +
  theme_classic()
