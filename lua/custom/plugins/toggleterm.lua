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
        open_mapping = [[<c-\>]], -- Default global toggle, can be different
        hide_numbers = true,
        shade_terminals = true,
        shading_factor = 1,
        start_in_insert = true,
        insert_mappings = true, -- <Esc> in terminal insert goes to terminal normal
        terminal_mappings = true,
        persist_size = true,
        persist_mode = true,
        direction = 'horizontal', -- Default for :ToggleTerm command
        close_on_exit = true,
        shell = vim.o.shell,
        auto_scroll = true, -- Scroll to bottom on new output
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
      -- We create the terminal instance ONCE.
      -- We will pass/override the 'dir' option when toggling/opening.
      local term_instance = Terminal:new {
        id = 'main_interactive_term',
        hidden = true, -- Start hidden
        -- Initial direction and size are less critical here as toggle functions will set them
        direction = 'horizontal',
        size = 9,
        -- persist_mode = true, -- from global opts
        -- close_on_exit = true, -- from global opts
      }

      -- Helper function to get the desired CWD for the terminal
      local function get_terminal_cwd()
        -- Try to get the directory of the current buffer
        local current_buf_path = vim.api.nvim_buf_get_name(0) -- 0 for current buffer
        local current_buf_dir
        if current_buf_path and current_buf_path ~= '' then
          current_buf_dir = vim.fn.fnamemodify(current_buf_path, ':h') -- :h gets the head/directory
          -- Check if the directory exists
          if vim.fn.isdirectory(current_buf_dir) == 1 then
            return current_buf_dir
          end
        end
        -- Fallback to Neovim's current working directory
        return vim.fn.getcwd()
      end

      local function focus_and_insert(term)
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
        local target_dir = get_terminal_cwd()
        if term_instance:is_open() then
          if term_instance.direction == 'float' or term_instance.dir ~= target_dir then
            -- If it's a float OR if its CWD is different from where we want to open now,
            -- close it completely to ensure it reopens with the correct CWD and direction.
            term_instance:close()
            term_instance:open(9, 'horizontal', { dir = target_dir })
          else -- It's open as a horizontal slit and in the correct CWD, so just close it
            term_instance:close()
          end
        else
          -- If it's closed, open it with the desired CWD, size, and direction
          term_instance:open(9, 'horizontal', { dir = target_dir })
        end

        if term_instance:is_open() and term_instance.direction == 'horizontal' then
          focus_and_insert(term_instance)
        end
      end

      vim.keymap.set(
        { 'n', 't' },
        '<leader>t',
        '<Cmd>lua _G.ToggleBottomPanelTerm()<CR>',
        { noremap = true, silent = true, desc = 'Terminal: Toggle Bottom Panel (9 lines, CWD)' }
      )

      function _G.ToggleCenterFloatTerm()
        local target_dir = get_terminal_cwd()
        if term_instance:is_open() then
          if term_instance.direction == 'horizontal' or term_instance.dir ~= target_dir then
            -- If it's a slit OR if its CWD is different, close it completely.
            term_instance:close()
            term_instance:open(nil, 'float', { dir = target_dir }) -- nil size for float_opts default
          else -- It's open as a float and in the correct CWD, so just close it
            term_instance:close()
          end
        else
          -- If it's closed, open it as a float with the desired CWD
          term_instance:open(nil, 'float', { dir = target_dir })
        end

        if term_instance:is_open() and term_instance.direction == 'float' then
          focus_and_insert(term_instance)
        end
      end

      vim.keymap.set(
        { 'n', 't' },
        '<C-t>',
        '<Cmd>lua _G.ToggleCenterFloatTerm()<CR>',
        { noremap = true, silent = true, desc = 'Terminal: Toggle Centered Float (CWD)' }
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
