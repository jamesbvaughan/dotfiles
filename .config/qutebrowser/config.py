import subprocess

def read_xresources(prefix):
    props = {}
    x = subprocess.run(['xrdb', '-query'], stdout=subprocess.PIPE)
    lines = x.stdout.decode().split('\n')
    for line in filter(lambda l : l.startswith(prefix), lines):
        prop, _, value = line.partition(':\t')
        props[prop] = value
    return props

xresources = read_xresources('*')

uiFont = "16px DejaVu Sans Mono"
uiFontBold = "bold {}".format(uiFont)

config.bind("<Ctrl-W>", 'fake-key <Ctrl-Backspace>', mode='insert')
config.bind("<Ctrl-A>", 'fake-key <Home>', mode='insert')
config.bind("<Ctrl-E>", 'fake-key <End>', mode='insert')
config.bind("<Ctrl-F>", 'fake-key <Right>', mode='insert')
config.bind("<Ctrl-H>", 'fake-key <Backspace>', mode='insert')
config.bind("<Ctrl-B>", 'fake-key <Left>', mode='insert')
config.bind("<Ctrl-N>", 'fake-key <Down>', mode='insert')
config.bind("<Ctrl-P>", 'fake-key <Up>', mode='insert')
config.bind('m', 'spawn vlc {url}')
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

c.editor.command = ["urxvt", "-e", "vim", "{}"]

c.fonts.completion.entry = uiFont
c.fonts.completion.category = uiFontBold
c.fonts.downloads = uiFont
c.fonts.tabs = uiFont
c.fonts.statusbar = uiFont
c.fonts.hints = uiFont
c.fonts.keyhint = uiFont

c.tabs.indicator.width = 0
c.tabs.padding = {
    'top': 1,
    'bottom': 1,
    'left': 5,
    'right': 5,
}
c.tabs.show = "multiple"
c.tabs.title.format_pinned = ""
c.tabs.title.format = "{title}"

c.spellcheck.languages = ['en-US']

c.url.searchengines = {
    'DEFAULT': 'https://duckduckgo.com/?q={}',
    'g': 'https://google.com/search?q={}',
    'y': 'https://youtube.com/results?search_query={}',
    'a': 'https://smile.amazon.com/s?field-keywords={}',
    'r': 'https://reddit.com/r/{}',
}

# c.zoom.default = '150%'

c.colors.completion.category.bg = xresources['*background']
c.colors.completion.category.border.bottom = xresources['*background']
c.colors.completion.category.border.top = xresources['*background']
c.colors.completion.category.fg = xresources['*color15']
c.colors.completion.even.bg = xresources['*color0']
c.colors.completion.fg = xresources['*color14']
c.colors.completion.item.selected.bg = xresources['*color13']
c.colors.completion.item.selected.border.bottom = xresources['*color13']
c.colors.completion.item.selected.border.top = xresources['*color13']
c.colors.completion.item.selected.fg = xresources['*color15']
c.colors.completion.match.fg = xresources['*color7']
c.colors.completion.odd.bg = xresources['*color0']
c.colors.completion.scrollbar.bg = xresources['*color14']
c.colors.completion.scrollbar.fg = xresources['*color7']
c.colors.downloads.bar.bg = xresources['*background']
c.colors.downloads.error.bg = xresources['*color1']
c.colors.downloads.error.fg = xresources['*color15']
c.colors.downloads.start.fg = xresources['*color15']
c.colors.hints.bg = xresources['*color13']
c.colors.hints.fg = xresources['*color15']
c.colors.hints.match.fg = xresources['*color14']
c.colors.keyhint.fg = xresources['*color15']
c.colors.keyhint.suffix.fg = xresources['*color3']
c.colors.messages.error.bg = xresources['*color1']
c.colors.messages.error.border = xresources['*color1']
c.colors.messages.error.fg = xresources['*color15']
c.colors.messages.info.bg = xresources['*background']
c.colors.messages.info.border = xresources['*background']
c.colors.messages.info.fg = xresources['*color15']
c.colors.messages.warning.bg = xresources['*color9']
c.colors.messages.warning.border = xresources['*color9']
c.colors.messages.warning.fg = xresources['*color15']
c.colors.prompts.bg = xresources['*color0']
c.colors.prompts.border = '1px solid ' + xresources['*color15']
c.colors.prompts.fg = xresources['*color15']
c.colors.prompts.selected.bg = xresources['*color10']
c.colors.statusbar.caret.bg = xresources['*color4']
c.colors.statusbar.caret.fg = xresources['*color14']
c.colors.statusbar.caret.selection.bg = xresources['*color13']
c.colors.statusbar.caret.selection.fg = xresources['*color14']
c.colors.statusbar.command.bg = xresources['*background']
c.colors.statusbar.command.fg = xresources['*color14']
c.colors.statusbar.command.private.bg = xresources['*color10']
c.colors.statusbar.command.private.fg = xresources['*color15']
c.colors.statusbar.insert.bg = xresources['*color0']
c.colors.statusbar.insert.fg = xresources['*color14']
c.colors.statusbar.normal.bg = xresources['*background']
c.colors.statusbar.normal.fg = xresources['*color14']
c.colors.statusbar.private.bg = xresources['*color10']
c.colors.statusbar.private.fg = xresources['*color15']
c.colors.statusbar.progress.bg = xresources['*color14']
c.colors.statusbar.url.error.fg = xresources['*color1']
c.colors.statusbar.url.fg = xresources['*color14']
c.colors.statusbar.url.hover.fg = xresources['*color7']
c.colors.statusbar.url.success.http.fg = xresources['*color14']
c.colors.statusbar.url.success.https.fg = xresources['*color14']
c.colors.statusbar.url.warn.fg = xresources['*color3']
c.colors.tabs.even.bg = xresources['*color0']
c.colors.tabs.even.fg = xresources['*color14']
c.colors.tabs.odd.bg = xresources['*background']
c.colors.tabs.odd.fg = xresources['*color14']
c.colors.tabs.selected.even.bg = xresources['*color14']
c.colors.tabs.selected.even.fg = xresources['*color7']
c.colors.tabs.selected.odd.bg = xresources['*color14']
c.colors.tabs.selected.odd.fg = xresources['*color7']
