import dracula.draw

# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

dracula.draw.blood(c, {
    'spacing': {
        'vertical': 6,
        'horizontal': 8
    }
})


config.bind("<Ctrl-W>", 'fake-key <Ctrl-Backspace>', mode='insert')
config.bind("<Ctrl-A>", 'fake-key <Home>', mode='insert')
config.bind("<Ctrl-E>", 'fake-key <End>', mode='insert')
config.bind("<Ctrl-F>", 'fake-key <Right>', mode='insert')
config.bind("<Ctrl-H>", 'fake-key <Backspace>', mode='insert')
config.bind("<Ctrl-B>", 'fake-key <Left>', mode='insert')
config.bind("<Ctrl-N>", 'fake-key <Down>', mode='insert')
config.bind("<Ctrl-P>", 'fake-key <Up>', mode='insert')
config.bind('M', 'hint links spawn vlc {hint-url}')
config.bind(';m', 'hint --rapid links spawn vlc {hint-url}')
config.bind('<Alt-p>', 'spawn --userscript qute-pass')
config.bind('<Alt-Shift-p>', 'spawn --userscript qute-pass --password-only')
config.bind('sp', 'open -t https://getpocket.com/edit?url={url}')
config.bind(';p', 'hint links run :open -p {hint-url}')

c.auto_save.session = True

c.completion.scrollbar.width = 0

c.content.geolocation = True

c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 2000

c.editor.command = ["alacritty", "-e", "nvim", "{}"]

c.fonts.default_family = "JetBrains Mono Nerd Font"
c.fonts.default_size = "10px"

c.statusbar.padding = {
    'top': 0,
    'bottom': 0,
    'left': 0,
    'right': 0,
}

c.tabs.indicator.width = 0
c.tabs.padding = {
    'top': 1,
    'bottom': 1,
    'left': 5,
    'right': 1,
}
c.tabs.show = "multiple"
# c.tabs.title.format_pinned = ""
c.tabs.title.format = "{current_title}"

c.spellcheck.languages = ['en-US']

c.zoom.default = '75%'

c.colors.webpage.preferred_color_scheme = 'dark'

config.load_autoconfig(False)
