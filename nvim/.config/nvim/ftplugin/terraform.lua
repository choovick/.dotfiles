-- Smart Terraform variable navigation.
--
-- Works around hashicorp/terraform-ls#653 (open since 2021): LSP reference
-- targets are block-granular, so gd on `var.config.database.replicas` lands
-- on the `variable "config"` block root, and references/completion ignore
-- nested traversal steps entirely.
--
--   <leader>td  LSP gd, then treesitter-walk the remaining traversal steps
--               into the variable's type/default attributes (lands on the
--               exact nested key).
--   <leader>tr  fzf-lua grep: on a var.x.y/local.x.y path, greps that exact
--               path (dot and bracket forms); anywhere else, greps the word
--               under the cursor. No LSP involved.
--
-- gd/gr are deliberately NOT overridden: lsp.lua binds them on LspAttach
-- and the re-assert race made them flaky. <leader>td falls back to plain
-- LSP definition when the cursor is not on a var.*/local.* path.

-- Node under the cursor, snapping to the line's first non-blank char when
-- the cursor sits in the indent or on punctuation (so a key line resolves
-- to its key rather than the parent object).
local function node_at_cursor()
  local ok, node = pcall(vim.treesitter.get_node)
  if not ok or not node then
    return nil
  end
  local t = node:type()
  -- Node types that are part of a traversal or string: resolve directly.
  -- Anything else (punctuation, operators, attribute/block nodes from the
  -- indent) snaps to the line's first identifier below.
  if t ~= "identifier" and t ~= "template_literal" and t ~= "variable_expr" and t ~= "get_attr" and t ~= "index" then
    local row = vim.api.nvim_win_get_cursor(0)[1]
    local col = vim.api.nvim_get_current_line():find("%S")
    if col then
      local ok2, snapped = pcall(vim.treesitter.get_node, { pos = { row - 1, col - 1 } })
      if ok2 and snapped then
        local st = snapped:type()
        if st == "identifier" or st == "template_literal" then
          return snapped
        end
      end
    end
  end
  return node
end

-- Extract the traversal under the cursor as a list of segments,
-- e.g. { "var", "config", "database" } for var.config.database or
-- var.config["database"]. Returns nil when not on a var./local. traversal
-- or when a segment is a dynamic index.
local function traversal_under_cursor()
  local node = node_at_cursor()
  if not node then
    return nil
  end
  -- Find the nearest ancestor that directly holds a traversal: its first
  -- named child is a variable_expr (var/local). The container's node type
  -- varies with context -- plain attribute values wrap the traversal in an
  -- expression, but inside `!= ""`, `length(...)`, `for ... in`, `${...}`
  -- the variable_expr/get_attr nodes are children of binary_operation,
  -- operation, interpolation, etc. -- so match structurally, not by type.
  local container = node
  while container do
    local first = container:named_child(0)
    if first and first:type() == "variable_expr" then
      break
    end
    container = container:parent()
  end
  if not container then
    return nil
  end

  local bufnr = vim.api.nvim_get_current_buf()
  local parts = {}
  local chain = {} -- nodes that make up the traversal, for the cursor check
  for child in container:iter_children() do
    local t = child:type()
    if t == "variable_expr" then
      if #parts > 0 then
        break -- a second traversal (e.g. rhs of ==): not part of this one
      end
      table.insert(parts, vim.treesitter.get_node_text(child, bufnr))
      table.insert(chain, child)
    elseif #parts > 0 and t == "get_attr" then
      for sub in child:iter_children() do
        if sub:type() == "identifier" then
          table.insert(parts, vim.treesitter.get_node_text(sub, bufnr))
        end
      end
      table.insert(chain, child)
    elseif #parts > 0 and t == "index" then
      local key = vim.treesitter.get_node_text(child, bufnr):match('%["([^"]+)"%]')
      if not key then
        break -- dynamic or numeric index: keep the static prefix
      end
      table.insert(parts, key)
      table.insert(chain, child)
    elseif child:named() then
      break
    end
  end

  -- The cursor must be on the traversal itself, not on a sibling operand
  -- (the "" in var.a != "", the rhs of a comparison, ...).
  local on_chain = false
  local n = node
  while n and n ~= container do
    for _, c in ipairs(chain) do
      if c == n then
        on_chain = true
        break
      end
    end
    if on_chain then
      break
    end
    n = n:parent()
  end
  if not on_chain then
    return nil
  end

  if #parts < 2 or (parts[1] ~= "var" and parts[1] ~= "local") then
    return nil
  end
  return parts
end

-- Name of the key an attribute/object_elem node defines. For object_elem the
-- key is its first named child (identifier or quoted template_literal).
local function key_name(node, bufnr)
  local first = node:named_child(0)
  if not first then
    return nil
  end
  local stack = { first }
  while #stack > 0 do
    local n = table.remove(stack)
    local t = n:type()
    if t == "identifier" or t == "template_literal" then
      return vim.treesitter.get_node_text(n, bufnr)
    end
    for i = n:named_child_count() - 1, 0, -1 do
      table.insert(stack, n:named_child(i))
    end
  end
  return nil
end

-- After gd landed on the variable block (or locals attribute), walk the
-- remaining steps through attribute/object_elem keys in document order.
local function walk_into_definition(steps)
  local bufnr = vim.api.nvim_get_current_buf()
  local ok, parser = pcall(vim.treesitter.get_parser, bufnr, "hcl")
  if not ok then
    return
  end
  local root = parser:parse()[1]:root()
  local query = vim.treesitter.query.parse("hcl", "(attribute) @a (object_elem) @e")

  -- Scope the search: the attribute gd landed on, else its enclosing block.
  local scope = vim.treesitter.get_node({ bufnr = bufnr })
  while scope and scope:type() ~= "attribute" and scope:type() ~= "block" do
    scope = scope:parent()
  end
  scope = scope or root

  local cands = {}
  for _, node in query:iter_captures(scope, bufnr) do
    local name = key_name(node, bufnr)
    if name then
      local row, col = node:start()
      table.insert(cands, { name = name, row = row, col = col })
    end
  end
  table.sort(cands, function(a, b)
    return a.row < b.row or (a.row == b.row and a.col < b.col)
  end)

  local from = 1
  for _, step in ipairs(steps) do
    local hit
    for i = from, #cands do
      if cands[i].name == step then
        hit = i
        break
      end
    end
    if not hit then
      vim.api.nvim_echo(
        { { "terraform-nav: '" .. step .. "' not found below definition", "WarningMsg" } },
        true,
        { kind = "echomsg" }
      )
      return
    end
    from = hit + 1
  end
  local target = cands[from - 1]
  vim.api.nvim_win_set_cursor(0, { target.row + 1, target.col })
end

local function smart_gd()
  local parts = traversal_under_cursor()
  if not parts or #parts < 3 then
    return vim.lsp.buf.definition()
  end
  local steps = { unpack(parts, 3) } -- segments below the LSP-resolvable root
  vim.cmd("normal! m'") -- jumplist so <C-o> returns
  vim.lsp.buf.definition({
    on_list = function(options)
      local item = options.items and options.items[1]
      if not item then
        return
      end
      local bufnr = vim.fn.bufadd(item.filename)
      vim.fn.bufload(bufnr)
      vim.api.nvim_set_current_buf(bufnr)
      vim.api.nvim_win_set_cursor(0, { item.lnum, math.max(item.col - 1, 0) })
      walk_into_definition(steps)
    end,
  })
end

-- Simple references, no LSP:
--   - cursor on a var.x.y / local.x.y path -> grep that exact path
--     (dot and bracket forms, identifier boundaries at both ends)
--   - cursor anywhere else              -> fixed-string grep for the word
local function simple_references()
  local pat, display
  local parts = traversal_under_cursor()
  if parts then
    pat = "(^|[^A-Za-z0-9_])" .. parts[1]
    for i = 2, #parts do
      pat = pat .. string.format('(\\.%s|\\["%s"\\])', parts[i], parts[i])
    end
    pat = pat .. "([^A-Za-z0-9_]|$)"
    display = table.concat(parts, ".")
  else
    local word = vim.fn.expand("<cword>")
    if word == "" then
      return
    end
    pat = vim.pesc(word)
    display = word
  end

  -- Run rg directly: fzf-lua's grep() escaping makes regex semantics murky,
  -- and a loose match here degrades into root-object noise.
  -- --follow: live repos symlink .tf files to template dirs; plain rg skips them.
  local cmd = { "rg", "--follow", "--no-heading", "--column", "--line-number", "--color", "never", "-e", pat, "-g", "*.tf", "-g", "*.tfvars" }
  -- Search the file's own directory, not nvim's cwd: terraform repos are
  -- deep trees of near-identical env dirs, and cwd easily drifts (session
  -- restore, :cd, opening files across the tree).
  local cwd = vim.fn.expand("%:p:h")
  vim.system(cmd, { cwd = cwd, text = true }, function(res)
    vim.schedule(function()
      -- Live dirs are symlinks into template trees. Depending on how a path
      -- is reached, rg --follow may print the dereferenced template path;
      -- jumping there would open a second buffer for the same file (live
      -- path vs realpath). Map resolved targets back to the live names.
      local live_by_target
      local lines, by_line = {}, {}
      for l in (res.stdout or ""):gmatch("[^\n]+") do
        local file, lnum, col = l:match("^(.-):(%d+):(%d+):")
        if file then
          if not live_by_target then
            live_by_target = {}
            for _, name in ipairs(vim.fn.readdir(cwd)) do
              live_by_target[vim.fn.resolve(cwd .. "/" .. name)] = name
            end
          end
          local live = live_by_target[vim.fn.resolve(cwd .. "/" .. file)]
          if live and live ~= file then
            l = live .. l:sub(#file + 1)
            file = live
          end
          table.insert(lines, l)
          by_line[l] = { file = file, lnum = tonumber(lnum), col = tonumber(col) }
        end
      end
      if #lines == 0 then
        vim.api.nvim_echo(
          { { "tf refs: no matches for " .. display, "WarningMsg" } },
          true,
          { kind = "echomsg" }
        )
        return
      end
      require("fzf-lua").fzf_exec(lines, {
        prompt = "tf refs: " .. display .. "> ",
        -- Match count in the title: echoes are swallowed by this config's
        -- noice routing, the title is the one always-visible channel.
        winopts = { title = (" %d matches | dir: %s | rg: %s "):format(#lines, cwd, pat) },
        -- Custom cmd previewer: the builtin resolves relative paths against
        -- nvim's cwd, but hits are relative to the search dir. Fixed context
        -- above the match: fzf-lua does not export FZF_PREVIEW_LINES to cmd
        -- previewers, so the height is not available here.
        preview = {
          type = "cmd",
          fn = function(items)
            local item = by_line[items[1]]
            if not item then
              return ""
            end
            local path = item.file:sub(1, 1) == "/" and item.file or (cwd .. "/" .. item.file)
            return ('bat --color=always --style=numbers --highlight-line %d --line-range "$((%d > 15 ? %d - 15 : 1)):" -- %s'):format(
              item.lnum,
              item.lnum,
              item.lnum,
              vim.fn.shellescape(path)
            )
          end,
        },
        actions = {
          ["default"] = function(selected)
            local item = by_line[selected[1]]
            if not item then
              return
            end
            -- rg ran in `cwd`, so relative hits must resolve against it,
            -- not nvim's cwd.
            local path = item.file
            if not path:match("^/") then
              path = cwd .. "/" .. path
            end
            vim.cmd("edit " .. vim.fn.fnameescape(path))
            vim.api.nvim_win_set_cursor(0, { item.lnum, item.col - 1 })
          end,
        },
      })
    end)
  end)
end

-- Dedicated <leader>t* keys instead of overriding gd/gr: lsp.lua rebinds
-- gd/gr on every LspAttach, and racing it made both flaky.
vim.keymap.set("n", "<leader>td", smart_gd, { buffer = true, silent = true, desc = "Tf definition (walks nested keys)" })
vim.keymap.set("n", "<leader>tr", simple_references, { buffer = true, silent = true, desc = "Tf references (path/word grep)" })
