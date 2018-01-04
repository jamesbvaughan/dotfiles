uiFont = "24px DejaVu Sans Mono"
uiFontBold = "bold {}".format(uiFont)

config.bind("<Ctrl-W>", 'fake-key <Ctrl-Backspace>', mode='insert')
config.bind("<Ctrl-A>", 'fake-key <Home>', mode='insert')
config.bind("<Ctrl-E>", 'fake-key <End>', mode='insert')
config.bind("<Ctrl-F>", 'fake-key <Right>', mode='insert')
config.bind("<Ctrl-H>", 'fake-key <Backspace>', mode='insert')
config.bind("<Ctrl-B>", 'fake-key <Left>', mode='insert')
config.bind("<Ctrl-N>", 'fake-key <Down>', mode='insert')
config.bind("<Ctrl-P>", 'fake-key <Up>', mode='insert')
config.bind('b', 'set-cmd-text -s :bookmark-load')
config.bind('B', 'set-cmd-text -s :bookmark-load -t')
config.bind('<Ctrl-m>', 'view_in_mpv')
config.bind('<Alt-p>', 'pass', mode='insert')
config.bind('sp', 'pocket')

c.aliases = {
    'q': 'quit',
    'pocket': 'open -t https://getpocket.com/edit?url={url}',
    'pass': 'spawn --userscript qute-pass',
    'mpv': 'spawn --userscript view_in_mpv',
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

c.tabs.width.indicator = 0
c.tabs.padding = {
    'top': 1,
    'bottom': 1,
    'left': 5,
    'right': 5,
}
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

c.zoom.default = '150%'

solarized = {
    'base03': '#002b36',
    'base02': '#073642',
    'base01': '#586e75',
    'base00': '#657b83',
    'base0': '#839496',
    'base1': '#93a1a1',
    'base2': '#eee8d5',
    'base3': '#fdf6e3',
    'yellow': '#b58900',
    'orange': '#cb4b16',
    'red': '#dc322f',
    'magenta': '#d33682',
    'violet': '#6c71c4',
    'blue': '#268bd2',
    'cyan': '#2aa198',
    'green': '#859900'
}

c.colors.completion.category.bg = solarized['base03']
c.colors.completion.category.border.bottom = solarized['base03']
c.colors.completion.category.border.top = solarized['base03']
c.colors.completion.category.fg = solarized['base3']
c.colors.completion.even.bg = solarized['base02']
c.colors.completion.fg = solarized['base1']
c.colors.completion.item.selected.bg = solarized['violet']
c.colors.completion.item.selected.border.bottom = solarized['violet']
c.colors.completion.item.selected.border.top = solarized['violet']
c.colors.completion.item.selected.fg = solarized['base3']
c.colors.completion.match.fg = solarized['base2']
c.colors.completion.odd.bg = solarized['base02']
c.colors.completion.scrollbar.bg = solarized['base1']
c.colors.completion.scrollbar.fg = solarized['base2']
c.colors.downloads.bar.bg = solarized['base03']
c.colors.downloads.error.bg = solarized['red']
c.colors.downloads.error.fg = solarized['base3']
# c.colors.downloads.start.bg = '#0000aa'
c.colors.downloads.start.fg = solarized['base3']
# c.colors.downloads.stop.bg = '#00aa00'
# c.colors.downloads.stop.fg = solarized['base3']
# c.colors.downloads.system.bg = 'rgb'
# c.colors.downloads.system.fg = 'rgb'
c.colors.hints.bg = solarized['violet']
c.colors.hints.fg = solarized['base3']
c.colors.hints.match.fg = solarized['base1']
# c.colors.keyhint.bg = 'rgba(0, 0, 0, 80%)'
c.colors.keyhint.fg = solarized['base3']
c.colors.keyhint.suffix.fg = solarized['yellow']
c.colors.messages.error.bg = solarized['red']
c.colors.messages.error.border = solarized['red']
c.colors.messages.error.fg = solarized['base3']
c.colors.messages.info.bg = solarized['base03']
c.colors.messages.info.border = solarized['base03']
c.colors.messages.info.fg = solarized['base3']
c.colors.messages.warning.bg = solarized['orange']
c.colors.messages.warning.border = solarized['orange']
c.colors.messages.warning.fg = solarized['base3']
c.colors.prompts.bg = solarized['base02']
c.colors.prompts.border = '1px solid ' + solarized['base3']
c.colors.prompts.fg = solarized['base3']
c.colors.prompts.selected.bg = solarized['base01']
c.colors.statusbar.caret.bg = solarized['blue']
c.colors.statusbar.caret.fg = solarized['base1']
c.colors.statusbar.caret.selection.bg = solarized['violet']
c.colors.statusbar.caret.selection.fg = solarized['base1']
c.colors.statusbar.command.bg = solarized['base03']
c.colors.statusbar.command.fg = solarized['base1']
c.colors.statusbar.command.private.bg = solarized['base01']
c.colors.statusbar.command.private.fg = solarized['base3']
c.colors.statusbar.insert.bg = solarized['base02']
c.colors.statusbar.insert.fg = solarized['base1']
c.colors.statusbar.normal.bg = solarized['base03']
c.colors.statusbar.normal.fg = solarized['base1']
# c.colors.statusbar.passthrough.bg = solarized['base02']
# c.colors.statusbar.passthrough.fg = solarized['base1']
c.colors.statusbar.private.bg = solarized['base01']
c.colors.statusbar.private.fg = solarized['base3']
c.colors.statusbar.progress.bg = solarized['base1']
c.colors.statusbar.url.error.fg = solarized['red']
c.colors.statusbar.url.fg = solarized['base1']
c.colors.statusbar.url.hover.fg = solarized['base2']
c.colors.statusbar.url.success.http.fg = solarized['base1']
c.colors.statusbar.url.success.https.fg = solarized['base1']
c.colors.statusbar.url.warn.fg = solarized['yellow']
# c.colors.tabs.bar.bg = '#555555'
c.colors.tabs.even.bg = solarized['base02']
c.colors.tabs.even.fg = solarized['base1']
c.colors.tabs.odd.bg = solarized['base03']
c.colors.tabs.odd.fg = solarized['base1']
c.colors.tabs.selected.even.bg = solarized['base1']
c.colors.tabs.selected.even.fg = solarized['base2']
c.colors.tabs.selected.odd.bg = solarized['base1']
c.colors.tabs.selected.odd.fg = solarized['base2']
