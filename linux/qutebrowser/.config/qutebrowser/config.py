# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

c.aliases['fill-password'] = 'spawn --userscript 1pass'

config.bind("<Ctrl-W>", 'fake-key <Ctrl-Backspace>', mode='insert')
config.bind("<Ctrl-A>", 'fake-key <Home>', mode='insert')
config.bind("<Ctrl-E>", 'fake-key <End>', mode='insert')
config.bind("<Ctrl-F>", 'fake-key <Right>', mode='insert')
config.bind("<Ctrl-H>", 'fake-key <Backspace>', mode='insert')
config.bind("<Ctrl-B>", 'fake-key <Left>', mode='insert')
config.bind("<Ctrl-N>", 'fake-key <Down>', mode='insert')
config.bind("<Ctrl-P>", 'fake-key <Up>', mode='insert')
config.bind(';p', 'hint links run :open -p {hint-url}')
config.bind(',m', 'spawn umpv {url}')
config.bind(',M', 'hint links spawn umpv {hint-url}')
config.bind(';M', 'hint --rapid links spawn umpv {hint-url}')

c.auto_save.session = True

c.completion.scrollbar.width = 0

c.content.geolocation = True

c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 2000

c.editor.command = ["wezterm", "-e", "nvim", "{}"]

c.fonts.default_family = "Berkeley Mono"
c.fonts.default_size = "20px"

c.zoom.default = "125%"

c.statusbar.padding = {
    'top': 4,
    'bottom': 4,
    'left': 0,
    'right': 0,
}

# c.tabs.indicator.width = 0
c.tabs.padding = {
    'top': 4,
    'bottom': 4,
    'left': 5,
    'right': 1,
}
c.tabs.show = "multiple"
c.tabs.title.format_pinned = ""
c.tabs.title.format = "{current_title}"

c.spellcheck.languages = ['en-US']

c.colors.webpage.preferred_color_scheme = 'dark'

config.load_autoconfig()
config.source("gruvbox-dark.py")
