-- lua/custom/plugins/comments.lua
return {
  {
    'numToStr/Comment.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require('Comment').setup {
        padding = true,
        sticky = true,
        ignore = '^$', -- ignore empty lines
        mappings = {
          basic = true, -- keep default mappings (gcc, gbc, etc.)
          extra = true, -- keep extra mappings (gco, gcO, gcA)
        },
      }

      local api = require 'Comment.api'

      -- NORMAL mode: <C-_> (Ctrl+/)
      vim.keymap.set('n', '<C-_>', function()
        if vim.v.count > 0 then
          api.toggle.linewise.count(vim.v.count)
        else
          api.toggle.linewise.current()
        end
      end, {
        noremap = true,
        silent = true,
        desc = 'Toggle comment line(s)',
      })

      -- VISUAL mode: <C-_> (Ctrl+/)
      vim.keymap.set('x', '<C-_>', function()
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Esc>', true, false, true), 'nx', false)
        api.toggle.linewise(vim.fn.visualmode())
      end, {
        noremap = true,
        silent = true,
        desc = 'Toggle comment selection',
      })
    end,
  },
}
