-- lazy.lua
-- This file is automatically picked up by lazy.nvim when this recipe repo is
-- loaded as a plugin. Any plugins and configurations can be defined here the
-- samy way as they would be in a normal lazy configuration file.
return {
  {
    "cosmicbuffalo/eyeliner.nvim",
    -- stylua: ignore
    keys = {
      "f", "F", "t", "T",
      { "<leader>uf", "<cmd>ToggleFTHighlighting<cr>", desc = "Toggle f/t highlight" },
    },
    opts = {
      enabled_by_default = vim.g.lazy_jumpliner_recipe_enable_eyeliner_by_default,
      highlight_on_key = true,
      dim = false,
      primary_highlight_color = "white",
      secondary_highlight_color = "red",
      disabled_buftypes = { "nofile" },
      disabled_filetypes = { "NerdTree", "NvimTree", "NeoTree", "neo-tree" },
    },
    config = function(_, opts)
      local eyeliner = require("eyeliner")
      eyeliner.setup(opts)

      if not opts.enabled_by_default then
        eyeliner.disable()
      end

      -- stylua: ignore
      vim.api.nvim_set_hl(0, "EyelinerPrimary", { fg = opts.primary_highlight_color, bold = true, underline = true })
      vim.api.nvim_set_hl(0, "EyelinerSecondary", { fg = opts.secondary_highlight_color, underline = true })

      local eyeliner_enabled = require("eyeliner.main")["enabled?"]
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
    enabled = vim.g.lazy_jumpliner_recipe_enable_mini_jump or false,
    keys = { "f", "F", "t", "T" },
    dependencies = {
      {
        "cosmicbuffalo/eyeliner.nvim",
        opts = {
          -- TODO: make sure this only applies when mini.jump is enabled
          default_keymaps = false,
        },
      },
    },
    config = function(_, opts)
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
