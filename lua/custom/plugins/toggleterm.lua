-- lua/custom/plugins/terminal.lua
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    config = function()
      require('toggleterm').setup {
        size = function(term)
          if term.direction == 'horizontal' then
            return 9
          elseif term.direction == 'vertical' then
            return vim.o.columns * 0.4
          end
        end,
        open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        insert_mappings = true,
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal',
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true,
        float_opts = {
          border = 'rounded',
          winblend = 0,
          width = function(_)
            return math.floor(vim.o.columns * 0.8)
          end,
          height = function(_)
            return math.floor(vim.o.lines * 0.8)
          end,
        },
      }

      local Terminal = require('toggleterm.terminal').Terminal
      local term_instance = Terminal:new {
        id = 'main_interactive_term',
        hidden = true,
        -- Initial direction and size for the first time it's opened by a specific toggle
        -- These can be overridden by the toggle function
        direction = 'horizontal',
        size = 9,
      }

      local function focus_and_insert(term)
        -- This function needs to be called *after* the window is confirmed to be open and valid
        -- Using vim.schedule ensures it runs after the current event loop cycle,
        -- allowing window changes to settle.
        vim.schedule(function()
          if term:is_open() and vim.api.nvim_win_is_valid(term.window) then
            vim.api.nvim_set_current_win(term.window)
            if vim.bo[term.bufnr].modifiable and vim.api.nvim_get_mode().mode ~= 't' then
              vim.cmd 'startinsert'
            end
          end
        end)
      end

      function _G.ToggleBottomPanelTerm()
        if term_instance:is_open() and term_instance.direction == 'float' then
          -- If currently a float, close it first to ensure clean transition
          term_instance:close()
        end
        -- Toggle with specific options for bottom panel
        -- This will open if closed, or close if already a bottom panel
        term_instance:toggle(9, 'horizontal') -- Ensure size 9, horizontal direction
        if term_instance:is_open() and term_instance.direction == 'horizontal' then
          focus_and_insert(term_instance)
        end
      end

      vim.keymap.set(
        { 'n', 't' },
        '<leader>t',
        '<Cmd>lua _G.ToggleBottomPanelTerm()<CR>',
        { noremap = true, silent = true, desc = 'Terminal: Toggle Bottom Panel (9 lines)' }
      )

      function _G.ToggleCenterFloatTerm()
        if term_instance:is_open() and term_instance.direction == 'horizontal' then
          -- If currently a slit, close it first
          term_instance:close()
        end
        -- Toggle with specific options for float
        -- This will open if closed, or close if already a float
        term_instance:toggle(nil, 'float') -- nil size uses float_opts, 'float' direction
        if term_instance:is_open() and term_instance.direction == 'float' then
          focus_and_insert(term_instance)
        end
      end

      vim.keymap.set(
        { 'n', 't' },
        '<C-t>',
        '<Cmd>lua _G.ToggleCenterFloatTerm()<CR>',
        { noremap = true, silent = true, desc = 'Terminal: Toggle Centered Float' }
      )

      vim.api.nvim_create_autocmd('TermOpen', {
        pattern = '*',
        group = vim.api.nvim_create_augroup('MyToggletermCustomizations', { clear = true }),
        callback = function(args)
          vim.opt_local.number = false
          vim.opt_local.relativenumber = false
          vim.opt_local.signcolumn = 'no'
        end,
      })
    end,
  },
}
