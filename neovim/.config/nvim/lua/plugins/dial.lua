local dial_map = function(key, name, mode)
  return {
    key,
    function() return require("dial.map")[name]() end,
    expr = true,
    mode = mode or "n",
    desc = string.format("Dial %s", string.gsub(name, "_", " ")),
  }
end

return {
  {
    "monaqa/dial.nvim",
    keys = {
      dial_map("<c-a>", "inc_normal"),
      dial_map("<c-x>", "dec_normal"),
      dial_map("<c-a>", "inc_visual", "v"),
      dial_map("<c-x>", "dec_visual", "v"),
      dial_map("g<c-a>", "inc_gvisual", "v"),
      dial_map("g<c-x>", "dec_gvisual", "v"),
    },
  },
}
