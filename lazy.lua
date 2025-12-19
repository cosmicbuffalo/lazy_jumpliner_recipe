-- lazy.lua
-- This file is automatically picked up by lazy.nvim when this recipe repo is
-- loaded as a plugin. Any plugins and configurations can be defined here the
-- same way as they would be in a normal lazy configuration file.
-- To get config from the recipe into the nested plugin, use vim.g variables and
-- override them in the config function.
return {
  {
    "cosmicbuffalo/eyeliner.nvim",
    -- stylua: ignore
    keys = {
      "f", "F", "t", "T",
      { "<leader>uf", "<cmd>ToggleFTHighlighting<cr>", desc = "Toggle f/t highlight" },
    },
    opts = {
      highlight_on_key = true,
      dim = false,
      primary_highlight_color = "white",
      secondary_highlight_color = "red",
      disabled_buftypes = { "nofile" },
      disabled_filetypes = { "NerdTree", "NvimTree", "NeoTree", "neo-tree" },
    },
    config = function(_, opts)
      local default_keymaps = not vim.g.lazy_jumpliner_recipe_enable_mini_jump
      opts.default_keymaps = default_keymaps

      local eyeliner = require("eyeliner")
      eyeliner.setup(opts)

      if not vim.g.lazy_jumpliner_recipe_enable_eyeliner_by_default then
        eyeliner.disable()
      end

      -- stylua: ignore
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = opts.primary_highlight_color, bold = true, underline = true })
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = opts.secondary_highlight_color, underline = true })

      local eyeliner_enabled = eyeliner.is_enabled()
      vim.api.nvim_create_user_command("ToggleFTHighlighting", function()
        if eyeliner_enabled() then
          eyeliner.disable()
          vim.notify("Disabled f/t higlighting (eyeliner.nvim)")
        else
          eyeliner.enable()
          vim.notify("Enabled f/t highlighting (eyeliner.nvim)")
        end
      end, { desc = "Toggle f/t highlighting" })
    end,
  },
  {
    "echasnovski/mini.jump",
    keys = { "f", "F", "t", "T" },
    config = function(_, opts)
      if not vim.g.lazy_jumpliner_recipe_enable_mini_jump then
        return
      end

      require("mini.jump").setup(opts)

      -- Add escape key listener to stop mini.jump
      vim.on_key(function(key)
        if
          MiniJump
          and MiniJump.state
          and MiniJump.state.target
          and key == vim.api.nvim_replace_termcodes("<Esc>", true, false, true)
        then
          MiniJump.stop_jumping()
        end
      end)

      -- Enabling eyeliner.handler sets up the autocmd to remove highlights on cursor move
      local utils = require("eyeliner.utils")
      utils.create_augroup("Eyeliner", {clear = true})
      require("eyeliner.handler").enable()

      local eyeliner_highlight = function()
        require("eyeliner").highlight({
          forward = not MiniJump.state.backward,
          case_sensitive = vim.o.smartcase,
        })
      end
      -- run eyeliner on initial f/t/F/T keypress
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniJumpGetTarget",
        callback = eyeliner_highlight,
      })
      -- add to to jump list on jump
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniJumpJump",
        callback = function()
          vim.cmd("normal m`")
          vim.cmd("normal ``")
        end,
      })
    end,
  },
}
