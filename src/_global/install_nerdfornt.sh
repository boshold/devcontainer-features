if [ ! -f "~/.local/share/fonts/JetBrainsMonoNLNerdFontMono-Regular.ttf" ]; then
    echo "Install JetBrainsMono NerdFont..."
    mkdir -p ~/.local/share/fonts
    curl -o /tmp/JetBrainsMono.zip -LO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip 
    unzip -o /tmp/JetBrainsMono.zip -d ~/.local/share/fonts/
    rm /tmp/JetBrainsMono.zip
    fc-cache ~/.local/share/fonts
fi