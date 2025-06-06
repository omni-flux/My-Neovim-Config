-- lua/kickstart/plugins/neo-tree.lua (or your custom path)
return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x', -- Good to specify a stable branch
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- Essential dependency
    'MunifTanjim/nui.nvim',
  },
  -- cmd = "Neotree", -- We'll use keymaps
  -- lazy = false, -- neo-tree manages its own lazy loading

  -- Define your GLOBAL keymaps to interact with Neo-tree from any buffer
  keys = {
    {
      '<leader>e', -- Primary keymap: Toggle filesystem view
      function()
        require('neo-tree.command').execute {
          toggle = true,
          source = 'filesystem',
          position = 'left', -- Or 'right' if you prefer
          reveal = true, -- Tries to show the current file
        }
      end,
      desc = 'Explorer: Toggle Neo-tree (Filesystem)',
    },
    {
      '<leader>bo', -- Keymap for BUFFERS list
      function()
        require('neo-tree.command').execute {
          toggle = true,
          source = 'buffers',
          position = 'left', -- Or 'right'
        }
      end,
      desc = 'Explorer: Toggle Neo-tree (Buffers)',
    },
    -- Add other global keymaps if desired (e.g., for git_status source)
    -- {
    --   "<leader>gt", -- Example: [G]it [T]ree
    --   function()
    --     require("neo-tree.command").execute({ toggle = true, source = "git_status", position = "float" })
    --   end,
    --   desc = "Explorer: Toggle Neo-tree (Git Status)",
    -- },
  },

  -- Pass options to neo-tree's setup function.
  -- We'll keep this minimal to rely on neo-tree's defaults, which are usually good.
  opts = {
    -- You liked the default look, so we don't need to override many visual components.
    -- Neo-tree will automatically use nvim-web-devicons if available.
    close_if_last_window = false,
    popup_border_style = 'rounded', -- Or "NC" as in your example if you prefer that title bar
    enable_git_status = true,
    enable_diagnostics = true,

    -- Default window mappings (active WHEN INSIDE neo-tree window)
    -- These are generally sensible defaults from neo-tree itself.
    -- The `\` to close is a good addition from Kickstart's usual config.
    window = {
      mappings = {
        ['\\'] = 'close_window', -- Close neo-tree with backslash (when neo-tree is focused)
        -- Keep other default neo-tree mappings like <CR> for open, 'a' for add, etc.
        -- You don't need to list them all here if you're happy with neo-tree's defaults.
        -- Only add mappings here if you want to *override* a neo-tree default
        -- or add a new one *specifically for when neo-tree is active*.
        -- For example, if you wanted 'q' to also close:
        -- ['q'] = 'close_window',
      },
    },

    filesystem = {
      -- Let's use neo-tree's defaults for filtered_items first, then customize if needed.
      -- filtered_items = {
      --   visible = false,
      --   hide_dotfiles = true,
      --   hide_gitignored = true,
      -- },
      follow_current_file = {
        enabled = true, -- When true, neo-tree will try to find the active file when it opens
        leave_dirs_open = false,
      },
      hijack_netrw_behavior = 'open_default', -- This is usually a good default
    },
    -- You can add configurations for 'buffers' and 'git_status' sources here if you
    -- want to customize their specific behaviors or in-tree mappings.
    -- For now, relying on their defaults (plus the global toggle keymaps) is fine.
  },
}
