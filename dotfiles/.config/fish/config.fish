if status is-interactive
    set -gx EDITOR 'nvim'
    set fish_greeting
    set FZF_DEFAULT_COMMAND 'fd --type f --color=always'

    # Auto-install Fisher and plugins
    if not functions -q fisher
        echo "Installing Fisher..."
        curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
    end

    set -l desired_plugins \
        woheedev/onedark-fish \
        acomagu/fish-async-prompt@a89bf4216b65170e4c3d403e7cbf24ce34b134e6 \
        jethrokuan/z \
        patrickf1/fzf.fish

    # Install missing plugins
    for plugin in $desired_plugins
        if not fisher list | grep -Fx $plugin >/dev/null
            echo "Installing $plugin..."
            fisher install $plugin
        end
    end

    # Load fzf key bindings if fzf.fish is installed
    # if functions -q fzf_key_bindings
    #    fzf_key_bindings
    # end

    if command -q cargo
        if test -f "$HOME/.cargo/env.fish"
            source "$HOME/.cargo/env.fish"
        end
    end

    bind \e\[1\;5C forward-word
    bind \e\[1\;5D backward-word
    bind \b backward-kill-word
    bind \e\[3\;5~ kill-word

    ####### configure NNN #########
    set -l BLK "04"
    set -l CHR "04"
    set -l DIR "b4"
    set -l EXE "00"
    set -l REG "00"
    set -l HARDLINK "00"
    set -l SYMLINK "06"
    set -l MISSING "00"
    set -l ORPHAN "01"
    set -l FIFO "0F"
    set -l SOCK "0F"
    set -l OTHER "02"
    set -gx NNN_FCOLORS "$BLK$CHR$DIR$EXE$REG$HARDLINK$SYMLINK$MISSING$ORPHAN$FIFO$SOCK$OTHER"
    set -gx NNN_PLUG "q:autojump;p:preview-tui;w:fzcd"
    alias nnn "nnn -e"
    alias qw "n -de"
    alias :q "exit"
    alias ld "lazydocker"
    alias lg "lazygit"
    alias cl "clear"
    alias discord "flatpak run com.discordapp.Discord"
    # Temporary file for previews
    set -gx NNN_FIFO "/tmp/nnn.fifo"

    ######## configure Z ################
    set -U Z_CMD "q"
    set -U ZO_METHOD "nnn"
    set -U Z_DATA "$HOME/.z" # This is here for nnn:autojump plugin to work

    ######## configure bat #############
    set -gx BAT_THEME OneHalfDark

    #if not set -q ZELLIJ
    #zellij attach -c "Novil" options --default-layout "/home/sini/.config/zellij/layouts/layout1.kdl"
    #end


end
