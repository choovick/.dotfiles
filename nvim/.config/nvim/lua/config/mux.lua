-- Terminal multiplexer detection for tmux / Herdr / TUIOS coexistence.
-- Priority (innermost first): vim.g.dotfiles_mux | DOTFILES_MUX override → TUIOS → HERDR_ENV → TMUX → none
-- TUIOS panes also export HERDR_ENV=1 (herdr emulation), so TUIOS must be checked before Herdr.

local M = {}

---@return "tuios"|"herdr"|"tmux"|"none"
function M.detect()
  local override = vim.g.dotfiles_mux or vim.env.DOTFILES_MUX
  if type(override) == "string" and override ~= "" then
    override = override:lower()
    if override == "tuios" or override == "herdr" or override == "tmux" then
      return override
    end
  end

  -- Real Herdr started inside TUIOS has its own socket path, so it is not mistaken for TUIOS's shim.
  if vim.env.TUIOS_ENV == "1" then
    local herdr_socket = vim.env.HERDR_SOCKET_PATH
    if herdr_socket == nil or herdr_socket == "" or herdr_socket:find("tuios", 1, true) then
      return "tuios"
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
function M.is_tuios()
  return M.detect() == "tuios"
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
