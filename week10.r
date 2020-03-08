library(tidyverse)
library(ggplot2)
library(spotifyr)
library(tidyverse)
library(compmus)

Sys.setenv(SPOTIFY_CLIENT_ID = '29b7536b5f6f4f21a1e9075195a34105')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e5d4ec6492a44dbf808852fb35d36923')

circshift <- function(v, n) {if (n == 0) v else c(tail(v, n), head(v, -n))}

# C     C#    D     Eb    E     F     F#    G     Ab    A     Bb    B 
major_chord <- 
  c(1,    0,    0,    0,    1,    0,    0,    1,    0,    0,    0,    0)
minor_chord <- 
  c(1,    0,    0,    1,    0,    0,    0,    1,    0,    0,    0,    0)
seventh_chord <- 
  c(1,    0,    0,    0,    1,    0,    0,    1,    0,    0,    1,    0)

major_key <- 
  c(6.35, 2.23, 3.48, 2.33, 4.38, 4.09, 2.52, 5.19, 2.39, 3.66, 2.29, 2.88)
minor_key <-
  c(6.33, 2.68, 3.52, 5.38, 2.60, 3.53, 2.54, 4.75, 3.98, 2.69, 3.34, 3.17)
chord_templates <-
  tribble(
    ~name  , ~template,
    'Gb:7'  , circshift(seventh_chord,  6),
    'Gb:maj', circshift(major_chord,    6),
    'Bb:min', circshift(minor_chord,   10),
    'Db:maj', circshift(major_chord,    1),
    'F:min' , circshift(minor_chord,    5),
    'Ab:7'  , circshift(seventh_chord,  8),
    'Ab:maj', circshift(major_chord,    8),
    'C:min' , circshift(minor_chord,    0),
    'Eb:7'  , circshift(seventh_chord,  3),
    'Eb:maj', circshift(major_chord,    3),
    'G:min' , circshift(minor_chord,    7),
    'Bb:7'  , circshift(seventh_chord, 10),
    'Bb:maj', circshift(major_chord,   10),
    'D:min' , circshift(minor_chord,    2),
    'F:7'   , circshift(seventh_chord,  5),
    'F:maj' , circshift(major_chord,    5),
    'A:min' , circshift(minor_chord,    9),
    'C:7'   , circshift(seventh_chord,  0),
    'C:maj' , circshift(major_chord,    0),
    'E:min' , circshift(minor_chord,    4),
    'G:7'   , circshift(seventh_chord,  7),
    'G:maj' , circshift(major_chord,    7),
    'B:min' , circshift(minor_chord,   11),
    'D:7'   , circshift(seventh_chord,  2),
    'D:maj' , circshift(major_chord,    2),
    'F#:min', circshift(minor_chord,    6),
    'A:7'   , circshift(seventh_chord,  9),
    'A:maj' , circshift(major_chord,    9),
    'C#:min', circshift(minor_chord,    1),
    'E:7'   , circshift(seventh_chord,  4),
    'E:maj' , circshift(major_chord,    4),
    'G#:min', circshift(minor_chord,    8),
    'B:7'   , circshift(seventh_chord, 11),
    'B:maj' , circshift(major_chord,   11),
    'D#:min', circshift(minor_chord,    3))

key_templates <-
  tribble(
    ~name    , ~template,
    'Gb:maj', circshift(major_key,  6),
    'Bb:min', circshift(minor_key, 10),
    'Db:maj', circshift(major_key,  1),
    'F:min' , circshift(minor_key,  5),
    'Ab:maj', circshift(major_key,  8),
    'C:min' , circshift(minor_key,  0),
    'Eb:maj', circshift(major_key,  3),
    'G:min' , circshift(minor_key,  7),
    'Bb:maj', circshift(major_key, 10),
    'D:min' , circshift(minor_key,  2),
    'F:maj' , circshift(major_key,  5),
    'A:min' , circshift(minor_key,  9),
    'C:maj' , circshift(major_key,  0),
    'E:min' , circshift(minor_key,  4),
    'G:maj' , circshift(major_key,  7),
    'B:min' , circshift(minor_key, 11),
    'D:maj' , circshift(major_key,  2),
    'F#:min', circshift(minor_key,  6),
    'A:maj' , circshift(major_key,  9),
    'C#:min', circshift(minor_key,  1),
    'E:maj' , circshift(major_key,  4),
    'G#:min', circshift(minor_key,  8),
    'B:maj' , circshift(major_key, 11),
    'D#:min', circshift(minor_key,  3))

get_chordogram <- function(uri, chord_templates){
  plot <- get_tidy_audio_analysis(uri) %>% 
    compmus_align(bars, segments) %>% 
    select(bars) %>% unnest(bars) %>% 
    mutate(
      pitches = 
        map(segments, 
            compmus_summarise, pitches, 
            method = 'mean', norm = 'manhattan'))  %>% 
    compmus_match_pitch_template(chord_templates, 'euclidean', 'manhattan') %>% 
    ggplot(
      aes(x = start + duration / 2, width = duration, y = name, fill = d)) +
    geom_tile() +
    scale_fill_viridis_c(option = 'E', guide = 'none') +
    theme_minimal() +
    labs(x = 'Time (s)', y = '')
}

get_keygram <- function(uri, key_templates){
  plot <- get_tidy_audio_analysis(uri) %>% 
    compmus_align(sections, segments) %>% 
    select(sections) %>% unnest(sections) %>% 
    mutate(
      pitches = 
        map(segments, 
            compmus_summarise, pitches, 
            method = 'mean', norm = 'manhattan'))  %>% 
    compmus_match_pitch_template(chord_templates, 'euclidean', 'manhattan') %>% 
    ggplot(
      aes(x = start + duration / 2, width = duration, y = name, fill = d)) +
    geom_tile() +
    scale_fill_viridis_c(option = 'E', guide = 'none') +
    theme_minimal() +
    labs(x = 'Time (s)', y = '')
}

bold_chords <- get_chordogram('0uco0wQkB909zpPlHvu5Cc', chord_templates)
bold_keys <- get_chordogram('0uco0wQkB909zpPlHvu5Cc', key_templates)