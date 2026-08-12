-- Bootstrap lazy.nvim, then hand it the `lua/plugins/` directory.

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "--branch=stable",
    "https://github.com/folke/lazy.nvim.git",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  -- Every file under lua/plugins/ is imported. One file per concern.
  spec = { { import = "plugins" } },

  -- Lazy by default: a spec that wants to load eagerly must say so with
  -- `lazy = false`, which makes the eager set easy to audit.
  defaults = { lazy = true, version = false },

  install = { colorscheme = { "gruvbox", "habamax" } },
  checker = { enabled = true, notify = false },
  change_detection = { notify = false },
  ui = { border = "rounded" },

  performance = {
    rtp = {
      -- netrw is intentionally left enabled: there is no file-explorer plugin
      -- in this config, so netrw is the only way to browse a directory.
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
