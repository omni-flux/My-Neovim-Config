-- lua/custom/plugins/harpoon.lua
return {
  {
    'ThePrimeagen/harpoon',
    branch = 'harpoon2', -- Important: Use the harpoon2 branch
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local harpoon = require 'harpoon'

      -- REQUIRED: Setup Harpoon.
      harpoon:setup {
        settings = {
          save_on_toggle = true, -- Save internal list when UI closes
          sync_on_ui_close = true, -- Save to filesystem when UI closes
        },
      } -- Pass an empty table for default global settings

      -- Keymaps as per the Harpoon "Basic Setup" documentation
      vim.keymap.set('n', '<leader>a', function()
        harpoon:list():add()
      end, { desc = 'Harpoon: Add current file' })
      vim.keymap.set('n', '<C-e>', function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = 'Harpoon: Toggle Quick Menu' })

      vim.keymap.set('n', '<S-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to item 1' })
      vim.keymap.set('n', '<S-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to item 2' })
      vim.keymap.set('n', '<S-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to item 3' })
      vim.keymap.set('n', '<S-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to item 4' })

      -- Toggle previous & next buffers stored within Harpoon list (from docs)
      vim.keymap.set('n', '<S-n>', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Go to Previous item' }) -- Ctrl-Shift-P
      vim.keymap.set('n', '<S-p>', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Go to Next item' }) -- Ctrl-Shift-N
    end,
  },
}
