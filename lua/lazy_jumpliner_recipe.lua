local M = {}

M.setup = function(config)
  if config.enable_eyeliner_by_default then
    vim.g.lazy_jumpliner_recipe_enable_eyeliner_by_default = true
  end

  if config.enable_mini_jump then
    vim.g.lazy_jumpliner_recipe_enable_mini_jump = true
  end
end

return M
