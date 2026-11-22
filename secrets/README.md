# Credenciais — PCA Spotify

## Configuração

1. Crie um app em [Spotify for Developers — Dashboard](https://developer.spotify.com/dashboard).
2. Em **Settings**, anote **Client ID** e **Client secret**.
3. Adicione **Redirect URI**: `http://localhost:8000/callback` (como em `Python-Part.R`).
4. Copie `.Renviron.example` para `.Renviron` e preencha as variáveis.
5. Execute `Python-Part.R` após `readRenviron("secrets/.Renviron")` (o Rmd faz isso automaticamente se o arquivo existir).

## Documentação

- [Authorization Code Flow (Spotipy)](https://spotipy.readthedocs.io/en/2.24.0/#authorization-code-flow)
- [Scopes usados](https://developer.spotify.com/documentation/web-api/concepts/scopes): `user-library-read`, `user-top-read`
- [Web API — Get Playlist Items](https://developer.spotify.com/documentation/web-api/reference/get-playlists-tracks)