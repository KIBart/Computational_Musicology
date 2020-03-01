library(tidyverse)
library(ggplot2)
library(spotifyr)
library(tidyverse)
library(compmus)

Sys.setenv(SPOTIFY_CLIENT_ID = '29b7536b5f6f4f21a1e9075195a34105')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e5d4ec6492a44dbf808852fb35d36923')

make_self_similarity_matrix <- function(track_id, method="timbre"){
track <- 
  get_tidy_audio_analysis(track_id) %>% 
  compmus_align(bars, segments) %>% 
  select(bars) %>% unnest(bars) %>% 
  mutate(
    pitches = 
      map(segments, 
          compmus_summarise, pitches, 
          method = 'rms', norm = 'euclidean')) %>% 
  mutate(
    timbre = 
      map(segments, 
          compmus_summarise, timbre, 
          method = 'rms', norm = 'euclidean'))
if(method == "cepstrum"){
 plot <- track %>% 
    compmus_gather_timbre %>% 
    ggplot(
      aes(
        x = start + duration / 2, 
        width = duration, 
        y = basis, 
        fill = value)) + 
    geom_tile() +
    labs(x = 'Time (s)', y = NULL, fill = 'Magnitude') +
    scale_fill_viridis_c(option = 'E') +
    theme_classic()
  
}

if (method == "pitches"){
  plot <- track %>% 
    compmus_self_similarity(pitches, 'euclidean') %>% 
    ggplot(
      aes(
        x = xstart + xduration / 2, 
        width = xduration,
        y = ystart + yduration / 2,
        height = yduration,
        fill = d)) + 
    geom_tile() +
    coord_fixed() +
    scale_fill_viridis_c(option = 'E', guide = 'none') +
    theme_classic() +
    labs(x = '', y = '')
}

if (method == "timbre"){
  plot <- track %>% 
  compmus_self_similarity(timbre, 'euclidean') %>% 
  ggplot(
    aes(
      x = xstart + xduration / 2, 
      width = xduration,
      y = ystart + yduration / 2,
      height = yduration,
      fill = d)) + 
  geom_tile() +
  coord_fixed() +
  scale_fill_viridis_c(option = 'E', guide = 'none') +
  theme_classic() +
  labs(x = '', y = '')
}
  return(plot)
}

hendrix_voodoo_timbre <- make_self_similarity_matrix('5rywNTqQPofdsof7f5gvY4', "timbre")
hendrix_voodoo_pitches <- make_self_similarity_matrix('5rywNTqQPofdsof7f5gvY4', "pitches")

mayer_wait_until_timbre <- make_self_similarity_matrix('5SSqUpMby3y8W0qy3JME5E', "timbre")
mayer_wait_until_pitches <- make_self_similarity_matrix('5SSqUpMby3y8W0qy3JME5E', "pitches")

srv_pnj_timbre <- make_self_similarity_matrix('4TqS8mahRles9lf97hZ49X', "timbre")
srv_pnj_pitches <- make_self_similarity_matrix('4TqS8mahRles9lf97hZ49X', "pitches")

# roxanne <- make_self_similarity_matrix('696DnlkuDOXcMAnKlTgXXK', "pitches")

