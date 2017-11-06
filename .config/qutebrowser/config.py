uiFont = "16pt monospace"
uiFontBold = "bold {}".format(uiFont)

c.auto_save.session = True

c.content.geolocation = True
c.content.pdfjs = True

c.downloads.position = "bottom"
c.downloads.remove_finished = 2000

c.editor.command = ["urxvt", "-e", "vim", "{}"]

c.fonts.completion.entry = uiFont
c.fonts.completion.category = uiFontBold
c.fonts.tabs = uiFont
c.fonts.statusbar = uiFont
c.fonts.keyhint = uiFont
