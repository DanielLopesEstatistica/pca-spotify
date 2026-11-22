renv <- file.path("secrets", ".Renviron")
if (file.exists(renv)) {
  readRenviron(renv)
} else {
  stop(
    "Crie secrets/.Renviron a partir de secrets/.Renviron.example. ",
    "Credenciais: https://developer.spotify.com/dashboard"
  )
}

library(reticulate)

repl_python()

import os
import spotipy
from spotipy.oauth2 import SpotifyOAuth
import pandas as pd

client_id = os.environ.get("SPOTIFY_CLIENT_ID")
client_secret = os.environ.get("SPOTIFY_CLIENT_SECRET")
redirect_uri = os.environ.get("SPOTIFY_REDIRECT_URI", "http://localhost:8000/callback")
scope = os.environ.get("SPOTIFY_SCOPE", "user-library-read user-top-read")

if not client_id or not client_secret:
    raise EnvironmentError(
        "Defina SPOTIFY_CLIENT_ID e SPOTIFY_CLIENT_SECRET em secrets/.Renviron. "
        "https://developer.spotify.com/dashboard"
    )

sp = spotipy.Spotify(auth_manager=SpotifyOAuth(
    client_id=client_id,
    client_secret=client_secret,
    redirect_uri=redirect_uri,
    scope=scope,
))

def get_all(playlist_id):
  all_tracks = []
  offset = 0
  limit = 100

  while True:
    playlist_tracks = sp.playlist_tracks(playlist_id, offset=offset, limit=limit)
    all_tracks.extend(playlist_tracks['items'])

    if len(playlist_tracks['items']) < limit:
      break

    offset += limit

  return all_tracks

data = []

with open("temp.txt", "r") as file:
  file_contents = file.read()

playlist_id = file_contents
top_tracks = get_all(playlist_id)

names = []
artists = []
ids = []

for i, track in enumerate(top_tracks, start=1):
  track = track['track']
  track_name = track['name']
  artist = track['artists'][0]['name']
  track_id = track['id']
  names.append(track_name)
  artists.append(artist)
  ids.append(track_id)

energias = []
valencias = []
danceabilities = []
speechinesses = []
loudnesses = []

for n in range(len(names)):
  caract = sp.audio_features(ids[n])[0]
  energias.append(caract['energy'])
  valencias.append(caract['valence'])
  danceabilities.append(caract['danceability'])
  speechinesses.append(caract['speechiness'])
  loudnesses.append(caract['loudness'])

data = [ids, names, artists, energias, valencias, danceabilities,
        loudnesses, speechinesses]

df = pd.DataFrame(data).transpose()

column_names = ['IDs', 'Names', 'Artists', 'Energies', 'Valences', 'Danceabilities', 'Loudnesses', 'Speechinesses']
df.columns = column_names
df.to_csv('Dados/dados.csv', index=False)

exit()