return {
  {
    'stevearc/oil.nvim',
    opts = {},
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      -- Explicitly preserve netrw settings
      vim.g.loaded_netrw = nil
      vim.g.loaded_netrwPlugin = nil
      vim.g.netrw_nogx = nil

      require('oil').setup {
        -- Disable netrw hijacking to allow netrw to function normally
        default_file_explorer = false,

        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          natural_order = true,
          is_always_hidden = function(name, _)
            return name == '..' or name == '.git'
          end,
        },
        float = {
          padding = 2,
          max_width = 90,
          max_height = 0,
        },
        win_options = {
          wrap = true,
          winblend = 0,
        },
        -- Using default keymaps - they only apply within oil buffers
        keymaps = {
          -- Preserve window navigation keymaps
          ['<C-h>'] = false, -- Disable oil's C-h to allow window navigation
          ['<C-j>'] = false, -- Disable oil's C-j to allow window navigation
          ['<C-k>'] = false, -- Disable oil's C-k to allow window navigation
          ['<C-l>'] = false, -- Disable oil's C-l to allow window navigation
        },
      }

      -- Oil keymaps - simplified and reliable

      -- Helper function to close all oil windows
      local function close_all_oil_windows()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'oil' then
            if #vim.api.nvim_list_wins() > 1 then
              vim.api.nvim_win_close(win, false)
            end
          end
        end
      end

      -- Helper function to check if oil sidebar exists
      local function oil_sidebar_exists()
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          if vim.bo[buf].filetype == 'oil' then
            local win_width = vim.api.nvim_win_get_width(win)
            if win_width <= 35 then -- Consider narrow windows as sidebar
              return true
            end
          end
        end
        return false
      end

      -- <leader>oo - toggle oil in current window (full window)
      vim.keymap.set('n', '<leader>oo', function()
        local oil = require 'oil'

        if vim.bo.filetype == 'oil' then
          -- If we're in oil, close it
          oil.close()
        else
          -- Close any existing oil windows first
          close_all_oil_windows()
          -- Open oil in current window
          oil.open()
        end
      end, { desc = 'Toggle Oil file explorer (full window)' })

      -- <leader>ov - toggle oil sidebar
      vim.keymap.set('n', '<leader>ov', function()
        local oil = require 'oil'

        if oil_sidebar_exists() then
          -- Close sidebar
          close_all_oil_windows()
        else
          -- Close any existing oil first
          close_all_oil_windows()
          -- Open sidebar
          vim.cmd 'topleft vsplit'
          oil.open()
          vim.api.nvim_win_set_width(0, 30)
        end
      end, { desc = 'Toggle Oil sidebar (vertical split)' })
    end,
  },
}
