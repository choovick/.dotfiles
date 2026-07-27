return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
      go = { "staticcheck" },
      -- TODO: figure out cpu usage issues
      -- terraform = { "tflint" },
      markdown = { "markdownlint" },
    }

    -- markdown lint disable some rules https://github.com/markdownlint/markdownlint/blob/main/docs/RULES.md
    local markdownlint = require("lint").linters.markdownlint
    markdownlint.args = {
      "--disable",
      "MD013",
      "MD030",
      "--", -- Required
    }

    -- staticcheck omits an end range for some diagnostics, which nvim-lint
    -- turns into end_lnum = -1 and vim.diagnostic.set rejects. Clamp it back
    -- onto the start position when that happens.
    local staticcheck = require("lint").linters.staticcheck
    local staticcheck_parser = staticcheck.parser
    staticcheck.parser = function(output, bufnr)
      local diagnostics = staticcheck_parser(output, bufnr)
      for _, d in ipairs(diagnostics) do
        if not d.end_lnum or d.end_lnum < d.lnum then
          d.end_lnum = d.lnum
        end
        if not d.end_col or (d.end_lnum == d.lnum and d.end_col < d.col) then
          d.end_col = d.col + 1
        end
      end
      return diagnostics
    end

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
