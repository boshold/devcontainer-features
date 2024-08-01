# Install NerdFont only if requried
nerdfont_install() {
  local font="$1"

  if [ "$font" = "JetBrains" ] || [ "$font" = "JetBrainsMono"]; then
    # Use nerdfont jetbraisn
    nerdfont_install_jetbrainsmono
  else
    nerdfont_install_generic "$font"
  fi
}

nerdfont_install_jetbrainsmono() {
  if [ -f "~/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf" ]; then
    return 0;
  fi
  
  nerdfont_install_generic "JetBrainsMono"
}

nerdfont_install_generic() {
  local font="$1"
  local tempName="/tmp/font_$(date +%s).zip"
  echo "Install NerdFont '$font'..."

  mkdir -p ~/.local/share/fonts
  rm -rf $tempName
  curl -o $tempName -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip 
  unzip -o $tempName -d ~/.local/share/fonts/
  rm $tempName
  fc-cache ~/.local/share/fonts
}

