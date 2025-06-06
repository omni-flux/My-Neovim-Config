-- return {
--   {
--     -- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
--     'folke/tokyonight.nvim',
--     priority = 1000,
--     config = function()
--       ---@diagnostic disable-next-line: missing-fields
--       require('tokyonight').setup {
--         styles = {
--           comments = { italic = false },
--         },
--       }
--       vim.cmd.colorscheme 'tokyonight-night'
--     end,
--   },
-- }
return {
  {
    'Koalhack/darcubox-nvim',
    priority = 1000,
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('darcubox').setup {
        styles = {
          comments = { italic = false },
        },
      }
      vim.cmd.colorscheme 'darcubox'
    end,
  },
}
