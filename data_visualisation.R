# Install/update tidyverse and spotifyr (one time)

# Load libraries (every time)
library(tidyverse)
library(spotifyr)
library(ggplot2)

# Set Spotify access variables (every time)
Sys.setenv(SPOTIFY_CLIENT_ID = '29b7536b5f6f4f21a1e9075195a34105')
Sys.setenv(SPOTIFY_CLIENT_SECRET = 'e5d4ec6492a44dbf808852fb35d36923')

hendrix <- get_playlist_audio_features('bartderooij2009', '5HDlUKMqBToiJdBpMbRQtM')
srv <- get_playlist_audio_features('bartderooij2009', '4QXGoJ3i6ThCBw4b7DOZ8j')
mayer <- get_playlist_audio_features('bartderooij2009', '5OsbIHtbhXQ7FBNDN1HblL')

live_performances <-
  hendrix %>% mutate(playlist = "Jimi Hendrix") %>%
  bind_rows(srv %>% mutate(playlist = "Stevie Ray Vaughan")) %>%
  bind_rows(mayer %>% mutate(playlist = "John Mayer"))

live_labels <-
  tibble(
    label = c("Voodoo Child\n (Slight Return)", "Voodoo Child\n (Slight Return)", "Wait Untill \nTomorrow", "Lenny", "Lenny"),
    playlist = c("Jimi Hendrix", "Stevie Ray Vaughan", "John Mayer", "Stevie Ray Vaughan", "John Mayer"),
    valence = c(0.695, 0.351, 0.738,0.274 , 0.352),
    energy = c(0.645, 0.784, 0.908,0.248 , 0.315),
  )

live_performances %>%
  mutate(instrumentalness = ifelse(instrumentalness >= 0.5, 'No Vocals', 'With Vocals')) %>%
  ggplot(aes(x = valence, y = energy, fill = instrumentalness, size = danceability)) +
  geom_jitter(alpha = 0.45, shape = 21, color = "gray") +
  geom_text(                   # Add text labels from above.
    aes(
      x = valence,
      y = energy,
      label = label),
    colour = "black",        # Override colour (not mode here).
    size = 3,                # Override size (not loudness here).
    data = live_labels,     # Specify the data source for labels.
    hjust = "left",          # Align left side of label with the point.
    vjust = "bottom",        # Align bottom of label with the point.
    nudge_x = -0.05,         # Nudge the label slightly left.
    nudge_y = 0.02,           # Nudge the label slightly up.
    inherit.aes = FALSE
  ) +
  facet_wrap(~ playlist) +
  theme_linedraw() +
  scale_x_continuous(          # Fine-tune the x axis.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),  # Use grid-lines for quadrants only.
    minor_breaks = NULL      # Remove 'minor' grid-lines.
  ) +
  scale_y_continuous(          # Fine-tune the y axis in the same way.
    limits = c(0, 1),
    breaks = c(0, 0.50, 1),
    minor_breaks = NULL
  ) +
  scale_size_continuous(       # Fine-tune the sizes of each point.
    trans = "identity",           # Use an exp transformation to emphasise loud.
    guide = "none"           # Remove the legend for size.
  ) +
  scale_fill_manual(values = c("#d9324b", "#42e375"), name= "Vocals") +
  labs(                        # Make the titles nice.
    x = "Valence",
    y = "Energy",
    fill = "Vocals"
  )

live_performances %>%
group_by(playlist, key_name) %>% 
  summarize(
    count = n()) %>%
  mutate(count = ifelse(playlist == "Jimi Hendrix", count/158*100,
                    ifelse(playlist == "Stevie Ray Vaughan", count/116*100,
                    ifelse(playlist == "John Mayer", count/92 * 100, "no")))) %>%
  ggplot(aes(x = key_name, y = count, fill = playlist)) +
  geom_col(position = position_dodge(width = 0.6), alpha = 0.6, width = 1.2) +
  ggtitle("Percentage of songs per key") +
  labs(                        # Make the titles nice.
    x = "Key Signature",
    y = "Percentage %",
    fill = "Artist"
  ) +
  theme_light() +
  scale_y_continuous(          # Fine-tune the y axis in the same way.
    limits = c(0, 26),
    breaks = c(0, 5, 10, 15, 20, 25),
    minor_breaks = NULL
  ) +
  scale_fill_brewer(type = "qual", palette = "Paired")
