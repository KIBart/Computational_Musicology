# Install/update tidyverse and spotifyr (one time)

# Load libraries (every time)
library(tidyverse)
library(spotifyr)
library(ggplot2)

# Set Spotify access variables (every time)
Sys.setenv(SPOTIFY_CLIENT_ID = '29b7536b5f6f4f21a1e9075195a34105')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e5d4ec6492a44dbf808852fb35d36923')

# Hendrix data
this_is_hendrix <- get_playlist_audio_features('spotify', '37i9dQZF1DWTNV753no4ic')
hendrix <- get_artist_audio_features('jimi hendrix')
live_hendrix <- get_album_tracks('3ok1qnMfMHuJTjPo5G0sQc')

# Counts per key
hendrix_per_key <- hendrix %>% 
  group_by(key_name) %>% 
  summarize(
    count = n())

# Stevie Ray Vaughan data
this_is_srv <- get_playlist_audio_features('spotify', '37i9dQZF1DZ06evO35m9Q4')
srv <- get_artist_audio_features('stevie ray vaughan')
live_srv <- get_album_tracks('7CPcbMHJEr5Z1OHPasEpzf')

# Counts per key
srv_per_key <- srv %>% 
  group_by(key_name) %>% 
  summarize(
    count = n())

# John Mayer data
this_is_mayer <- get_playlist_audio_features('spotify', '37i9dQZF1DWYrlaUEYy4Vg')
mayer <- get_artist_audio_features('john mayer')
live_mayer <- get_album_tracks('4Dgxy95K9BWkDUvQPTaYBb')

# Counts per key
mayer_per_key <- mayer %>% 
  group_by(key_name) %>% 
  summarize(
    count = n())

# Summarise key patterns
ggplot(hendrix_per_key, aes(x = key_name, y = count)) +
  geom_col() +
  ggtitle("Count per key Jimi Hendrix")

ggplot(srv_per_key, aes(x = key_name, y = count)) +
  geom_col() +
  ggtitle("Count per key Stevie Ray Vaughan")

ggplot(mayer_per_key, aes(x = key_name, y = count)) +
  geom_col() +
  ggtitle("Count per key John Mayer")

m_sd_hendrix <-
  hendrix %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness), 
                        max_instr = max(instrumentalness), min_instr = min(instrumentalness),
                              M_temp = mean(tempo), SD_temp = sd(tempo), 
                        max_temp = max(tempo), min_tempo = min(tempo),
                              M_energy = mean(energy), SD_energy = sd(energy),
                        max_energy = max(energy), min_energy = min(energy))
                        

m_sd_srv <-
  srv %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness), 
                    max_instr = max(instrumentalness), min_instr = min(instrumentalness),
                    M_temp = mean(tempo), SD_temp = sd(tempo), 
                    max_temp = max(tempo), min_tempo = min(tempo),
                    M_energy = mean(energy), SD_energy = sd(energy),
                    max_energy = max(energy), min_energy = min(energy))

m_sd_mayer <-
  mayer %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness), 
                      max_instr = max(instrumentalness), min_instr = min(instrumentalness),
                      M_temp = mean(tempo), SD_temp = sd(tempo), 
                      max_temp = max(tempo), min_tempo = min(tempo),
                      M_energy = mean(energy), SD_energy = sd(energy),
                      max_energy = max(energy), min_energy = min(energy))

#m_sd_live_hendrix <-
#  live_hendrix %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness),
#                        M_temp = mean(tempo), SD_temp = sd(tempo),
#                        M_nrg = mean(energy), SD_nrg = sd(energy))

#m_sd_live_srv <-
#  live_srv %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness),
#                    M_temp = mean(tempo), SD_temp = sd(tempo),
#                    M_nrg = mean(energy), SD_nrg = sd(energy))

#m_sd_live_mayer <-
#  live_mayer %>% summarise(M_instr = mean(instrumentalness), SD_instr = sd(instrumentalness),
#                      M_temp = mean(tempo), SD_temp = sd(tempo),
#                      M_nrg = mean(energy), SD_nrg = sd(energy))

m_sd_hendrix
m_sd_srv
m_sd_mayer
