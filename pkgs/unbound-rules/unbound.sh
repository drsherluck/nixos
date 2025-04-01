#!/usr/bin/env bash
set -u

function fatal {
  echo "$@" 1>&2
  exit 1
}

function youtube {
  echo "updating $1"

  printf 'local-zone: "%s" always_null\n' > $1 \
    'googlevideo.com' \
    'youtu.be' \
    'youtube-nocookie.com' \
    'youtube.googleapis.com' \
    'youtubeeducation.com' \
    'youtubegaming.com' \
    'youtubei.googleapis.com' \
    'yt3.ggpht.com' \
    'ytimg.com'

  for tld in "com" "nl" "be" "fr" "pl" "de" "co.uk"; do
    printf 'local-zone: "%s" always_null\n' "youtube.$tld"
  done >> $1
}

function safesearch {
  echo "updating $1"
  google_domains="$(curl -sq --fail "https://www.google.com/supported_domains")"

  if [ $? -ne 0 ]; then
    fatal "failed to fetch google supported domains"
  fi

  printf "%s\n" > $1 \
    'local-zone: "duckduckgo.com" redirect' \
    'local-data: "duckduckgo.com CNAME safe.duckduckgo.com"' \
    'local-zone: "bing.com" redirect' \
    'local-data: "bing.com CNAME strict.bing.com"' \
    'local-zone: "pixaby.com" redirect' \
    'local-data: "pixabay.com CNAME safesearch.pixabay.com"'

  for tld in "com" "ru" "ua" "by" "kz"; do
    printf 'local-zone: "%s" redirect\n' "yandex.$tld"
    printf 'local-data: "%s A 213.180.193.56"\n' "yandex.$tld"
  done >> $1

  echo -n "$google_domains" | while read domain; do
    d="${domain#.}"
    printf 'local-zone: "%s" redirect\n' "$d"
    printf 'local-data: "%s CNAME forcesafesearch.google.com"\n' "$d"
  done >> $1
}

function oisd {
  echo "updating $2"
  content="$(curl -sq --fail "$1")"
  if [ $? -eq 0 ]; then
    echo -n "$content" > "$2"
  fi
}

function check_config_dir {
  if [[ ! -v CONFIG_DIR ]]; then
    fatal "CONFIG_DIR environment variable not set"
  fi

  if [[ ! -e "$CONFIG_DIR" ]]; then
    fatal "$CONFIG_DIR does not exist"
  fi
}

function update {
  check_config_dir

  for i in "$@"; do
    case "$i" in
      safesearch) safesearch "$CONFIG_DIR/safesearch"
      ;;
      youtube) youtube "$CONFIG_DIR/youtube"
      ;;
      oisd-big) oisd "https://big.oisd.nl/unbound" "$CONFIG_DIR/oisd-big"
      ;;
      oisd-nsfw) oisd "https://nsfw.oisd.nl/unbound" "$CONFIG_DIR/oisd-nsfw"
      ;;
    esac
  done
}

function reload {
  # unbound-control -c /etc/unbound/unbound.conf reload not working
  systemctl restart "unbound.service"
}

# files need to exist before starting unbound
function create_files {
  check_config_dir
  touch "$CONFIG_DIR/safesearch"
  touch "$CONFIG_DIR/oisd-big"
  touch "$CONFIG_DIR/oisd-nsfw"
  touch "$CONFIG_DIR/youtube"
}

for i in "$@"; do
  case "$i" in
    create_files)
      create_files
      break
    ;;
    update)
      shift
      update "$@"
      break
    ;;
    reload)
      reload
      break
    ;;
    *) fatal "unknown command $@"
    ;;
  esac
done
