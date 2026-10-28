-- .tfvars get the same <leader>td/<leader>tr navigation as .tf; the whole
-- implementation lives in ftplugin/terraform.lua (ftplugins run per buffer,
-- so sourcing it from here binds this buffer).
vim.cmd("runtime! ftplugin/terraform.lua")
