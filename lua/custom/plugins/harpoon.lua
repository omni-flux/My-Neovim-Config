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

      vim.keymap.set('n', '<C-S-h>', function()
        harpoon:list():select(1)
      end, { desc = 'Harpoon: Go to item 1' })
      vim.keymap.set('n', '<C-S-j>', function()
        harpoon:list():select(2)
      end, { desc = 'Harpoon: Go to item 2' })
      vim.keymap.set('n', '<C-S-k>', function()
        harpoon:list():select(3)
      end, { desc = 'Harpoon: Go to item 3' })
      vim.keymap.set('n', '<C-S-l>', function()
        harpoon:list():select(4)
      end, { desc = 'Harpoon: Go to item 4' })

      -- Toggle previous & next buffers stored within Harpoon list (from docs)
      vim.keymap.set('n', '<C-S-P>', function()
        harpoon:list():prev()
      end, { desc = 'Harpoon: Go to Previous item' }) -- Ctrl-Shift-P
      vim.keymap.set('n', '<C-S-N>', function()
        harpoon:list():next()
      end, { desc = 'Harpoon: Go to Next item' }) -- Ctrl-Shift-N

      -- Telescope UI (as provided in docs, if you choose to use it)
      -- If using this, you might want to comment out the <C-e> mapping above.
      -- local conf = require("telescope.config").values
      -- local function toggle_telescope(harpoon_files)
      --     local file_paths = {}
      --     for _, item in ipairs(harpoon_files.items) do
      --         table.insert(file_paths, item.value)
      --     end
      --
      --     require("telescope.pickers").new({}, {
      --         prompt_title = "Harpoon",
      --         finder = require("telescope.finders").new_table({
      --             results = file_paths,
      --         }),
      --         previewer = conf.file_previewer({}),
      --         sorter = conf.generic_sorter({}),
      --     }):find()
      -- end
      --
      -- vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end,
      --     { desc = "Open harpoon window with Telescope" })

      -- Optional: Extend Harpoon UI for split navigation (from docs example)
      -- These keymaps (Ctrl-v, Ctrl-x, Ctrl-t) apply *inside the Harpoon quick menu*
      harpoon:extend {
        UI_CREATE = function(cx)
          vim.keymap.set('n', '<C-v>', function()
            harpoon.ui:select_menu_item { vsplit = true }
          end, { buffer = cx.bufnr, desc = 'Open in Vertical Split' })

          vim.keymap.set('n', '<C-x>', function()
            harpoon.ui:select_menu_item { split = true }
          end, { buffer = cx.bufnr, desc = 'Open in Horizontal Split' })

          -- Note: The original docs use <C-t> here as well for tabedit.
          -- This will conflict with the <C-t> for selecting item 2 if the menu isn't smart enough
          -- or if your focus isn't strictly within the menu UI buffer.
          -- For clarity, I'll use a different one, or you can manage this carefully.
          -- Let's stick to the doc's <C-t> for now and you can adjust if it conflicts.
          vim.keymap.set('n', '<C-t>', function()
            harpoon.ui:select_menu_item { tabedit = true }
          end, { buffer = cx.bufnr, desc = 'Open in New Tab' })
        end,
      }
    end,
  },
}
