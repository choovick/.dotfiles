-- Terminal multiplexer detection for tmux / Herdr coexistence.
-- Priority: vim.g.dotfiles_mux | DOTFILES_MUX override → HERDR_ENV → TMUX → none

local M = {}

---@return "herdr"|"tmux"|"none"
function M.detect()
  local override = vim.g.dotfiles_mux or vim.env.DOTFILES_MUX
  if type(override) == "string" and override ~= "" then
    override = override:lower()
    if override == "herdr" or override == "tmux" then
      return override
    end
  end

  if vim.env.HERDR_ENV == "1" then
    return "herdr"
  end

  if vim.env.TMUX and vim.env.TMUX ~= "" then
    return "tmux"
  end

  return "none"
end

---@return boolean
function M.is_herdr()
  return M.detect() == "herdr"
end

---@return boolean
function M.is_tmux()
  return M.detect() == "tmux"
end

return M
