-- render-markdown needs conceallevel above 0 to hide the raw syntax it draws
-- over. Set per buffer rather than globally, so concealment does not silently
-- hide things in other filetypes (JSON quotes being the classic case).
vim.opt_local.conceallevel = 2
vim.opt_local.concealcursor = "" -- show raw syntax on the cursor's line

-- Prose wraps; code does not.
vim.opt_local.wrap = true
vim.opt_local.linebreak = true
vim.opt_local.spell = true
