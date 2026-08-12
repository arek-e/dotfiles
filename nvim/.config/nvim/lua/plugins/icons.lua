-- Icons.
--
-- Its own eager spec on purpose. This used to be set up inside mini.files'
-- config, which is `keys`-lazy, so mini.icons did not exist until the explorer
-- was first opened — and until then telescope had no file icons and lualine no
-- filetype icon. Anything that wants icons needs them at startup, not later.
--
-- mock_nvim_web_devicons makes mini.icons answer to `require("nvim-web-devicons")`,
-- which is what telescope, lualine and most other plugins look for. That saves
-- installing nvim-web-devicons alongside it.

return {
  {
    "nvim-mini/mini.icons",
    version = false,
    lazy = false,
    priority = 900, -- after the colorscheme (1000), before everything else
    opts = {
      -- Slightly louder file icons than the default, which leans grey
      file = {
        [".eslintrc.js"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        [".oxlintrc.json"] = { glyph = "󰱺", hl = "MiniIconsYellow" },
        ["biome.json"] = { glyph = "󰱺", hl = "MiniIconsGreen" },
        [".stylua.toml"] = { glyph = "󰢱", hl = "MiniIconsBlue" },
        ["lazy-lock.json"] = { glyph = "󰒲", hl = "MiniIconsBlue" },
      },
      filetype = {
        gitcommit = { glyph = "", hl = "MiniIconsOrange" },
      },
    },
    config = function(_, opts)
      require("mini.icons").setup(opts)
      MiniIcons.mock_nvim_web_devicons()
    end,
  },
}
