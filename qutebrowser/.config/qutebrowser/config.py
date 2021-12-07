import subprocess

# pylint: disable=C0111
c = c  # noqa: F821 pylint: disable=E0602,C0103
config = config  # noqa: F821 pylint: disable=E0602,C0103

# uiFont = "10px JetBrains Mono Nerd Font"
# uiFontBold = "bold {}".format(uiFont)

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

c.aliases = {
    'q': 'quit',
}

c.auto_save.session = True

c.completion.scrollbar.width = 0

c.content.geolocation = True

c.downloads.location.prompt = False
c.downloads.position = "bottom"
c.downloads.remove_finished = 2000

c.editor.command = ["alacritty", "-e", "nvim", "{}"]

c.fonts.default_family = "JetBrains Mono Nerd Font"
c.fonts.default_size = "10px"
# c.fonts.completion.entry = uiFont
# c.fonts.completion.category = uiFontBold
# c.fonts.downloads = uiFont
# # c.fonts.tabs = uiFont
# c.fonts.statusbar = uiFont
# c.fonts.hints = uiFont
# c.fonts.keyhint = uiFont

c.tabs.indicator.width = 1
c.tabs.padding = {
    'top': 1,
    'bottom': 1,
    'left': 5,
    'right': 1,
}
c.tabs.show = "multiple"
# c.tabs.title.format_pinned = ""
# c.tabs.title.format = "{title}"

c.spellcheck.languages = ['en-US']

c.zoom.default = '75%'

config.load_autoconfig(False)
